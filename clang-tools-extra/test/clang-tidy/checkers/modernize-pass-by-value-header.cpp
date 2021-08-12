// RUN: cp %S/Inputs/modernize-pass-by-value/header.h %T/pass-by-value-header.h
// RUN: clang-tidy %s -checks='-*,modernize-pass-by-value' -header-filter='.*' -fix -- -std=c++11 -I %T \
// RUN: | FileCheck %s -check-prefix=CHECK-MESSAGES -implicit-check-not="{{warning|error}}:"
// RUN: FileCheck -input-file=%T/pass-by-value-header.h %s -check-prefix=CHECK-FIXES
//
// RUN: cp %S/Inputs/modernize-pass-by-value/header.h %T/pass-by-value-header.h
// RUN: clang-tidy %s -checks='*' --skip-headers=0 -- -std=c++11 -I %T \
// RUN: 2>&1 | FileCheck %s -check-prefix=CHECK-NOHEADER -allow-empty
//
// RUN: cp %S/Inputs/modernize-pass-by-value/header.h %T/pass-by-value-header.h
// RUN: clang-tidy %s -checks='-*,modernize-pass-by-value' --skip-headers -fix -- -std=c++11 -I %T \
// RUN: | FileCheck %s -check-prefix=CHECK-SKIP -allow-empty -implicit-check-not="{{warning|error}}:"
// RUN: FileCheck -input-file=%T/pass-by-value-header.h %s -check-prefix=CHECK-SKIP-FIXES
//
// RUN: cp %S/Inputs/modernize-pass-by-value/header.h %T/pass-by-value-header.h
// RUN: clang-tidy %s -checks='*' --skip-headers -- -std=c++11 -I %T \
// RUN: | FileCheck %s -check-prefix=CHECK-SKIP -allow-empty -implicit-check-not="{{warning|error}}:"
//
// FIXME: Make the test work in all language modes.

#include "pass-by-value-header.h"
// header file warnings are not shown, with --skip-headers, or without -header-filter
// CHECK-MESSAGES:     :8:5: warning: pass by value and use std::move [modernize-pass-by-value]
// CHECK-NOHEADER-NOT: :8:5: warning: pass by value and use std::move [modernize-pass-by-value]
// CHECK-SKIP-NOT:     :8:5: warning: pass by value and use std::move [modernize-pass-by-value]
//
// CHECK-FIXES: #include <utility>
// CHECK-FIXES: A(ThreadId tid) : threadid(std::move(tid)) {}
// CHECK-SKIP-FIXES-NOT: #include <utility>
//
// header files are checked even without -header-filtler
// CHECK-NOHEADER: Suppressed {{.*}} warnings
// CHECK-NOHEADER: Use -header-filter={{.*}} to display errors{{.*}}
//
// header files are not checked with --skip-headers
// CHECK-SKIP-NOT: Suppressed {{.*}} warnings
// CHECK-SKIP-NOT: Use -header-filter={{.*}} to display errors{{.*}}
