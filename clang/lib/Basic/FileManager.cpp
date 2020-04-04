//===--- FileManager.cpp - File System Probing and Caching ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file implements the FileManager interface.
//
//===----------------------------------------------------------------------===//
//
// TODO: This should index all interesting directories with dirent calls.
//  getdirentries ?
//  opendir/readdir_r/closedir ?
//
//===----------------------------------------------------------------------===//

#include "clang/Basic/FileManager.h"
#include "clang/Basic/FileSystemStatCache.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cassert>
#include <climits>
#include <cstdint>
#include <cstdlib>
#include <string>
#include <utility>

using namespace clang;

#define DEBUG_TYPE "file-search"

ALWAYS_ENABLED_STATISTIC(NumDirLookups, "Number of directory lookups.");
ALWAYS_ENABLED_STATISTIC(NumFileLookups, "Number of file lookups.");
ALWAYS_ENABLED_STATISTIC(NumDirCacheMisses,
                         "Number of directory cache misses.");
ALWAYS_ENABLED_STATISTIC(NumFileCacheMisses, "Number of file cache misses.");

//===----------------------------------------------------------------------===//
// Common logic.
//===----------------------------------------------------------------------===//

FileManager::FileManager(const FileSystemOptions &FSO,
                         IntrusiveRefCntPtr<llvm::vfs::FileSystem> FS)
    : FS(std::move(FS)), FileSystemOpts(FSO), SeenDirEntries(64),
      SeenFileEntries(64), NextFileUID(0) {
  // If the caller doesn't provide a virtual file system, just grab the real
  // file system.
  if (!this->FS)
    this->FS = llvm::vfs::getRealFileSystem();
}

FileManager::~FileManager() = default;

void FileManager::setStatCache(std::unique_ptr<FileSystemStatCache> statCache) {
  assert(statCache && "No stat cache provided?");
  StatCache = std::move(statCache);
}

void FileManager::clearStatCache() { StatCache.reset(); }

/// Retrieve the directory that the given file name resides in.
/// Filename can point to either a real file or a virtual file.
static llvm::ErrorOr<const DirectoryEntry *>
getDirectoryFromFile(FileManager &FileMgr, StringRef Filename,
                     bool CacheFailure) {
  if (Filename.empty())
    return std::errc::no_such_file_or_directory;

  if (llvm::sys::path::is_separator(Filename[Filename.size() - 1]))
    return std::errc::is_a_directory;

  StringRef DirName = llvm::sys::path::parent_path(Filename);
  // Use the current directory if file has no path component.
  if (DirName.empty())
    DirName = ".";

  return FileMgr.getDirectory(DirName, CacheFailure);
}

/// Add all ancestors of the given path (pointing to either a file or
/// a directory) as virtual directories.
void FileManager::addAncestorsAsVirtualDirs(StringRef Path) {
  StringRef DirName = llvm::sys::path::parent_path(Path);
  if (DirName.empty())
    DirName = ".";

  auto &NamedDirEnt = *SeenDirEntries.insert(
        {DirName, std::errc::no_such_file_or_directory}).first;

  // When caching a virtual directory, we always cache its ancestors
  // at the same time.  Therefore, if DirName is already in the cache,
  // we don't need to recurse as its ancestors must also already be in
  // the cache (or it's a known non-virtual directory).
  if (NamedDirEnt.second)
    return;

  // Add the virtual directory to the cache.
  auto UDE = std::make_unique<DirectoryEntry>();
  UDE->Name = NamedDirEnt.first();
  NamedDirEnt.second = *UDE.get();
  VirtualDirectoryEntries.push_back(std::move(UDE));

  // Recursively add the other ancestors.
  addAncestorsAsVirtualDirs(DirName);
}

llvm::Expected<DirectoryEntryRef>
FileManager::getDirectoryRef(StringRef DirName, bool CacheFailure) {
  // stat doesn't like trailing separators except for root directory.
  // At least, on Win32 MSVCRT, stat() cannot strip trailing '/'.
  // (though it can strip '\\')
  if (DirName.size() > 1 &&
      DirName != llvm::sys::path::root_path(DirName) &&
      llvm::sys::path::is_separator(DirName.back()))
    DirName = DirName.substr(0, DirName.size()-1);
#ifdef _WIN32
  // Fixing a problem with "clang C:test.c" on Windows.
  // Stat("C:") does not recognize "C:" as a valid directory
  std::string DirNameStr;
  if (DirName.size() > 1 && DirName.back() == ':' &&
      DirName.equals_lower(llvm::sys::path::root_name(DirName))) {
    DirNameStr = DirName.str() + '.';
    DirName = DirNameStr;
  }
#endif

  ++NumDirLookups;

  // See if there was already an entry in the map.  Note that the map
  // contains both virtual and real directories.
  auto SeenDirInsertResult =
      SeenDirEntries.insert({DirName, std::errc::no_such_file_or_directory});
  if (!SeenDirInsertResult.second) {
    if (SeenDirInsertResult.first->second)
      return DirectoryEntryRef(&*SeenDirInsertResult.first);
    return llvm::errorCodeToError(SeenDirInsertResult.first->second.getError());
  }

  // We've not seen this before. Fill it in.
  ++NumDirCacheMisses;
  auto &NamedDirEnt = *SeenDirInsertResult.first;
  assert(!NamedDirEnt.second && "should be newly-created");

  // Get the null-terminated directory name as stored as the key of the
  // SeenDirEntries map.
  StringRef InterndDirName = NamedDirEnt.first();

  // Check to see if the directory exists.
  llvm::vfs::Status Status;
  auto statError = getStatValue(InterndDirName, Status, false,
                                nullptr /*directory lookup*/);
  if (statError) {
    // There's no real directory at the given path.
    if (CacheFailure)
      NamedDirEnt.second = statError;
    else
      SeenDirEntries.erase(DirName);
    return llvm::errorCodeToError(statError);
  }

  // It exists.  See if we have already opened a directory with the
  // same inode (this occurs on Unix-like systems when one dir is
  // symlinked to another, for example) or the same path (on
  // Windows).
  DirectoryEntry &UDE = UniqueRealDirs[Status.getUniqueID()];

  NamedDirEnt.second = UDE;
  if (UDE.getName().empty()) {
    // We don't have this directory yet, add it.  We use the string
    // key from the SeenDirEntries map as the string.
    UDE.Name  = InterndDirName;
  }

  return DirectoryEntryRef(&NamedDirEnt);
}

llvm::ErrorOr<const DirectoryEntry *>
FileManager::getDirectory(StringRef DirName, bool CacheFailure) {
  auto Result = getDirectoryRef(DirName, CacheFailure);
  if (Result)
    return &Result->getDirEntry();
  return llvm::errorToErrorCode(Result.takeError());
}

llvm::ErrorOr<const FileEntry *>
FileManager::getFile(StringRef Filename, bool openFile, bool CacheFailure) {
  auto Result = getFileRef(Filename, openFile, CacheFailure);
  if (Result)
    return &Result->getFileEntry();
  return llvm::errorToErrorCode(Result.takeError());
}

llvm::Expected<FileEntryRef>
FileManager::getFileRef(StringRef Filename, bool openFile, bool CacheFailure) {
  ++NumFileLookups;

  // See if there is already an entry in the map.
  auto SeenFileInsertResult =
      SeenFileEntries.insert({Filename, std::errc::no_such_file_or_directory});
  if (!SeenFileInsertResult.second) {
    if (!SeenFileInsertResult.first->second)
      return llvm::errorCodeToError(
          SeenFileInsertResult.first->second.getError());
    // Construct and return and FileEntryRef, unless it's a redirect to another
    // filename.
    SeenFileEntryOrRedirect Value = *SeenFileInsertResult.first->second;
    FileEntry *FE;
    if (LLVM_LIKELY(FE = Value.dyn_cast<FileEntry *>()))
      return FileEntryRef(SeenFileInsertResult.first->first(), *FE);
    return getFileRef(*Value.get<const StringRef *>(), openFile, CacheFailure);
  }

  // We've not seen this before. Fill it in.
  ++NumFileCacheMisses;
  auto *NamedFileEnt = &*SeenFileInsertResult.first;
  assert(!NamedFileEnt->second && "should be newly-created");

  // Get the null-terminated file name as stored as the key of the
  // SeenFileEntries map.
  StringRef InterndFileName = NamedFileEnt->first();

  // Look up the directory for the file.  When looking up something like
  // sys/foo.h we'll discover all of the search directories that have a 'sys'
  // subdirectory.  This will let us avoid having to waste time on known-to-fail
  // searches when we go to find sys/bar.h, because all the search directories
  // without a 'sys' subdir will get a cached failure result.
  auto DirInfoOrErr = getDirectoryFromFile(*this, Filename, CacheFailure);
  if (!DirInfoOrErr) { // Directory doesn't exist, file can't exist.
    if (CacheFailure)
      NamedFileEnt->second = DirInfoOrErr.getError();
    else
      SeenFileEntries.erase(Filename);

    return llvm::errorCodeToError(DirInfoOrErr.getError());
  }
  const DirectoryEntry *DirInfo = *DirInfoOrErr;

  // FIXME: Use the directory info to prune this, before doing the stat syscall.
  // FIXME: This will reduce the # syscalls.

  // Check to see if the file exists.
  std::unique_ptr<llvm::vfs::File> F;
  llvm::vfs::Status Status;
  auto statError = getStatValue(InterndFileName, Status, true,
                                openFile ? &F : nullptr);
  if (statError) {
    // There's no real file at the given path.
    if (CacheFailure)
      NamedFileEnt->second = statError;
    else
      SeenFileEntries.erase(Filename);

    return llvm::errorCodeToError(statError);
  }

  assert((openFile || !F) && "undesired open file");

  // It exists.  See if we have already opened a file with the same inode.
  // This occurs when one dir is symlinked to another, for example.
  FileEntry &UFE = UniqueRealFiles[Status.getUniqueID()];

  NamedFileEnt->second = &UFE;

  // If the name returned by getStatValue is different than Filename, re-intern
  // the name.
  if (Status.getName() != Filename) {
    auto &NewNamedFileEnt =
        *SeenFileEntries.insert({Status.getName(), &UFE}).first;
    assert((*NewNamedFileEnt.second).get<FileEntry *>() == &UFE &&
           "filename from getStatValue() refers to wrong file");
    InterndFileName = NewNamedFileEnt.first().data();
    // In addition to re-interning the name, construct a redirecting seen file
    // entry, that will point to the name the filesystem actually wants to use.
    StringRef *Redirect = new (CanonicalNameStorage) StringRef(InterndFileName);
    auto SeenFileInsertResultIt = SeenFileEntries.find(Filename);
    assert(SeenFileInsertResultIt != SeenFileEntries.end() &&
           "unexpected SeenFileEntries cache miss");
    SeenFileInsertResultIt->second = Redirect;
    NamedFileEnt = &*SeenFileInsertResultIt;
  }

  if (UFE.isValid()) { // Already have an entry with this inode, return it.

    // FIXME: this hack ensures that if we look up a file by a virtual path in
    // the VFS that the getDir() will have the virtual path, even if we found
    // the file by a 'real' path first. This is required in order to find a
    // module's structure when its headers/module map are mapped in the VFS.
    // We should remove this as soon as we can properly support a file having
    // multiple names.
    if (DirInfo != UFE.Dir && Status.IsVFSMapped)
      UFE.Dir = DirInfo;

    // Always update the name to use the last name by which a file was accessed.
    // FIXME: Neither this nor always using the first name is correct; we want
    // to switch towards a design where we return a FileName object that
    // encapsulates both the name by which the file was accessed and the
    // corresponding FileEntry.
    // FIXME: The Name should be removed from FileEntry once all clients
    // adopt FileEntryRef.
    UFE.Name = InterndFileName;

    return FileEntryRef(InterndFileName, UFE);
  }

  // Otherwise, we don't have this file yet, add it.
  UFE.Name    = InterndFileName;
  UFE.Size    = Status.getSize();
  UFE.ModTime = llvm::sys::toTimeT(Status.getLastModificationTime());
  UFE.Dir     = DirInfo;
  UFE.UID     = NextFileUID++;
  UFE.UniqueID = Status.getUniqueID();
  UFE.IsNamedPipe = Status.getType() == llvm::sys::fs::file_type::fifo_file;
  UFE.File = std::move(F);
  UFE.IsValid = true;

  if (UFE.File) {
    if (auto PathName = UFE.File->getName())
      fillRealPathName(&UFE, *PathName);
  } else if (!openFile) {
    // We should still fill the path even if we aren't opening the file.
    fillRealPathName(&UFE, InterndFileName);
  }
  return FileEntryRef(InterndFileName, UFE);
}

const FileEntry *
FileManager::getVirtualFile(StringRef Filename, off_t Size,
                            time_t ModificationTime) {
  ++NumFileLookups;

  // See if there is already an entry in the map for an existing file.
  auto &NamedFileEnt = *SeenFileEntries.insert(
      {Filename, std::errc::no_such_file_or_directory}).first;
  if (NamedFileEnt.second) {
    SeenFileEntryOrRedirect Value = *NamedFileEnt.second;
    FileEntry *FE;
    if (LLVM_LIKELY(FE = Value.dyn_cast<FileEntry *>()))
      return FE;
    return getVirtualFile(*Value.get<const StringRef *>(), Size,
                          ModificationTime);
  }

  // We've not seen this before, or the file is cached as non-existent.
  ++NumFileCacheMisses;
  addAncestorsAsVirtualDirs(Filename);
  FileEntry *UFE = nullptr;

  // Now that all ancestors of Filename are in the cache, the
  // following call is guaranteed to find the DirectoryEntry from the
  // cache.
  auto DirInfo = getDirectoryFromFile(*this, Filename, /*CacheFailure=*/true);
  assert(DirInfo &&
         "The directory of a virtual file should already be in the cache.");

  // Check to see if the file exists. If so, drop the virtual file
  llvm::vfs::Status Status;
  const char *InterndFileName = NamedFileEnt.first().data();
  if (!getStatValue(InterndFileName, Status, true, nullptr)) {
    UFE = &UniqueRealFiles[Status.getUniqueID()];
    Status = llvm::vfs::Status(
      Status.getName(), Status.getUniqueID(),
      llvm::sys::toTimePoint(ModificationTime),
      Status.getUser(), Status.getGroup(), Size,
      Status.getType(), Status.getPermissions());

    NamedFileEnt.second = UFE;

    // If we had already opened this file, close it now so we don't
    // leak the descriptor. We're not going to use the file
    // descriptor anyway, since this is a virtual file.
    if (UFE->File)
      UFE->closeFile();

    // If we already have an entry with this inode, return it.
    if (UFE->isValid())
      return UFE;

    UFE->UniqueID = Status.getUniqueID();
    UFE->IsNamedPipe = Status.getType() == llvm::sys::fs::file_type::fifo_file;
    fillRealPathName(UFE, Status.getName());
  } else {
    VirtualFileEntries.push_back(std::make_unique<FileEntry>());
    UFE = VirtualFileEntries.back().get();
    NamedFileEnt.second = UFE;
  }

  UFE->Name    = InterndFileName;
  UFE->Size    = Size;
  UFE->ModTime = ModificationTime;
  UFE->Dir     = *DirInfo;
  UFE->UID     = NextFileUID++;
  UFE->IsValid = true;
  UFE->File.reset();
  return UFE;
}

llvm::Optional<FileEntryRef> FileManager::getBypassFile(FileEntryRef VF) {
  // Stat of the file and return nullptr if it doesn't exist.
  llvm::vfs::Status Status;
  if (getStatValue(VF.getName(), Status, /*isFile=*/true, /*F=*/nullptr))
    return None;

  // Fill it in from the stat.
  BypassFileEntries.push_back(std::make_unique<FileEntry>());
  const FileEntry &VFE = VF.getFileEntry();
  FileEntry &BFE = *BypassFileEntries.back();
  BFE.Name = VFE.getName();
  BFE.Size = Status.getSize();
  BFE.Dir = VFE.Dir;
  BFE.ModTime = llvm::sys::toTimeT(Status.getLastModificationTime());
  BFE.UID = NextFileUID++;
  BFE.IsValid = true;
  return FileEntryRef(VF.getName(), BFE);
}

bool FileManager::FixupRelativePath(SmallVectorImpl<char> &path) const {
  StringRef pathRef(path.data(), path.size());

  if (FileSystemOpts.WorkingDir.empty()
      || llvm::sys::path::is_absolute(pathRef))
    return false;

  SmallString<128> NewPath(FileSystemOpts.WorkingDir);
  llvm::sys::path::append(NewPath, pathRef);
  path = NewPath;
  return true;
}

bool FileManager::makeAbsolutePath(SmallVectorImpl<char> &Path) const {
  bool Changed = FixupRelativePath(Path);

  if (!llvm::sys::path::is_absolute(StringRef(Path.data(), Path.size()))) {
    FS->makeAbsolute(Path);
    Changed = true;
  }

  return Changed;
}

void FileManager::fillRealPathName(FileEntry *UFE, llvm::StringRef FileName) {
  llvm::SmallString<128> AbsPath(FileName);
  // This is not the same as `VFS::getRealPath()`, which resolves symlinks
  // but can be very expensive on real file systems.
  // FIXME: the semantic of RealPathName is unclear, and the name might be
  // misleading. We need to clean up the interface here.
  makeAbsolutePath(AbsPath);
  llvm::sys::path::remove_dots(AbsPath, /*remove_dot_dot=*/true);
  UFE->RealPathName = std::string(AbsPath.str());
}

llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>>
FileManager::getBufferForFile(const FileEntry *Entry, bool isVolatile) {
  uint64_t FileSize = Entry->getSize();
  // If there's a high enough chance that the file have changed since we
  // got its size, force a stat before opening it.
  if (isVolatile)
    FileSize = -1;

  StringRef Filename = Entry->getName();
  // If the file is already open, use the open file descriptor.
  if (Entry->File) {
    auto Result =
        Entry->File->getBuffer(Filename, FileSize,
                               /*RequiresNullTerminator=*/true, isVolatile);
    Entry->closeFile();
    return Result;
  }

  // Otherwise, open the file.
  return getBufferForFileImpl(Filename, FileSize, isVolatile);
}

llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>>
FileManager::getBufferForFileImpl(StringRef Filename, int64_t FileSize,
                                  bool isVolatile) {
  if (FileSystemOpts.WorkingDir.empty())
    return FS->getBufferForFile(Filename, FileSize,
                                /*RequiresNullTerminator=*/true, isVolatile);

  SmallString<128> FilePath(Filename);
  FixupRelativePath(FilePath);
  return FS->getBufferForFile(FilePath, FileSize,
                              /*RequiresNullTerminator=*/true, isVolatile);
}

/// getStatValue - Get the 'stat' information for the specified path,
/// using the cache to accelerate it if possible.  This returns true
/// if the path points to a virtual file or does not exist, or returns
/// false if it's an existent real file.  If FileDescriptor is NULL,
/// do directory look-up instead of file look-up.
std::error_code
FileManager::getStatValue(StringRef Path, llvm::vfs::Status &Status,
                          bool isFile, std::unique_ptr<llvm::vfs::File> *F) {
  // FIXME: FileSystemOpts shouldn't be passed in here, all paths should be
  // absolute!
  if (FileSystemOpts.WorkingDir.empty())
    return FileSystemStatCache::get(Path, Status, isFile, F,
                                    StatCache.get(), *FS);

  SmallString<128> FilePath(Path);
  FixupRelativePath(FilePath);

  return FileSystemStatCache::get(FilePath.c_str(), Status, isFile, F,
                                  StatCache.get(), *FS);
}

std::error_code 
FileManager::getNoncachedStatValue(StringRef Path,
                                   llvm::vfs::Status &Result) {
  SmallString<128> FilePath(Path);
  FixupRelativePath(FilePath);

  llvm::ErrorOr<llvm::vfs::Status> S = FS->status(FilePath.c_str());
  if (!S)
    return S.getError();
  Result = *S;
  return std::error_code();
}

void FileManager::GetUniqueIDMapping(
                   SmallVectorImpl<const FileEntry *> &UIDToFiles) const {
  UIDToFiles.clear();
  UIDToFiles.resize(NextFileUID);

  // Map file entries
  for (llvm::StringMap<llvm::ErrorOr<SeenFileEntryOrRedirect>,
                       llvm::BumpPtrAllocator>::const_iterator
           FE = SeenFileEntries.begin(),
           FEEnd = SeenFileEntries.end();
       FE != FEEnd; ++FE)
    if (llvm::ErrorOr<SeenFileEntryOrRedirect> Entry = FE->getValue()) {
      if (const auto *FE = (*Entry).dyn_cast<FileEntry *>())
        UIDToFiles[FE->getUID()] = FE;
    }

  // Map virtual file entries
  for (const auto &VFE : VirtualFileEntries)
    UIDToFiles[VFE->getUID()] = VFE.get();
}

StringRef FileManager::getCanonicalName(const DirectoryEntry *Dir) {
  llvm::DenseMap<const void *, llvm::StringRef>::iterator Known
    = CanonicalNames.find(Dir);
  if (Known != CanonicalNames.end())
    return Known->second;

  StringRef CanonicalName(Dir->getName());

  SmallString<4096> CanonicalNameBuf;
  if (!FS->getRealPath(Dir->getName(), CanonicalNameBuf))
    CanonicalName = StringRef(CanonicalNameBuf).copy(CanonicalNameStorage);

  CanonicalNames.insert({Dir, CanonicalName});
  return CanonicalName;
}

StringRef FileManager::getCanonicalName(const FileEntry *File) {
  llvm::DenseMap<const void *, llvm::StringRef>::iterator Known
    = CanonicalNames.find(File);
  if (Known != CanonicalNames.end())
    return Known->second;

  StringRef CanonicalName(File->getName());

  SmallString<4096> CanonicalNameBuf;
  if (!FS->getRealPath(File->getName(), CanonicalNameBuf))
    CanonicalName = StringRef(CanonicalNameBuf).copy(CanonicalNameStorage);

  CanonicalNames.insert({File, CanonicalName});
  return CanonicalName;
}

void FileManager::PrintStats() const {
  llvm::errs() << "\n*** File Manager Stats:\n";
  llvm::errs() << UniqueRealFiles.size() << " real files found, "
               << UniqueRealDirs.size() << " real dirs found.\n";
  llvm::errs() << VirtualFileEntries.size() << " virtual files found, "
               << VirtualDirectoryEntries.size() << " virtual dirs found.\n";
  llvm::errs() << NumDirLookups << " dir lookups, "
               << NumDirCacheMisses << " dir cache misses.\n";
  llvm::errs() << NumFileLookups << " file lookups, "
               << NumFileCacheMisses << " file cache misses.\n";

  //llvm::errs() << PagesMapped << BytesOfPagesMapped << FSLookups;
}
