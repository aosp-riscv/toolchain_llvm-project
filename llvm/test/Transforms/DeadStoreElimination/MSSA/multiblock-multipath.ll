; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -dse -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"

declare void @use(i32 *)

; Tests where the pointer/object is accessible after the function returns.

define void @accessible_after_return_1(i32* noalias %P, i1 %c1) {
; CHECK-LABEL: @accessible_after_return_1(
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 3, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5
bb2:
  store i32 3, i32* %P
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

define void @accessible_after_return_2(i32* noalias %P, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @accessible_after_return_2(
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 3, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb4:
; CHECK-NEXT:    store i32 5, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c.1, label %bb1, label %bb2
bb1:
  store i32 0, i32* %P
  br label %bb5

bb2:
  br i1 %c.2, label %bb3, label %bb4

bb3:
  store i32 3, i32* %P
  br label %bb5

bb4:
  store i32 5, i32* %P
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

; Cannot remove store in entry block because it is not overwritten on path
; entry->bb2->bb5.
define void @accessible_after_return_3(i32* noalias %P, i1 %c1) {
; CHECK-LABEL: @accessible_after_return_3(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5

bb2:
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

; Cannot remove store in entry block because it is not overwritten on path
; entry->bb2->bb5.
define void @accessible_after_return_4(i32* noalias %P, i1 %c1) {
; CHECK-LABEL: @accessible_after_return_4(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  call void @use(i32* %P)
  br label %bb5

bb2:
  br label %bb5

bb5:
  ret void
}

; Cannot remove the store in entry, as it is not overwritten on all paths to an
; exit (patch including bb4).
define void @accessible_after_return5(i32* %P, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @accessible_after_return5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 2, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb4:
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %P
  br i1 %c.1, label %bb1, label %bb2

bb1:
  br i1 %c.2, label %bb3, label %bb4

bb2:
  store i32 1, i32* %P
  br label %bb5

bb3:
  store i32 2, i32* %P
  br label %bb5

bb4:
  br label %bb5

bb5:
  ret void
}

; Can remove store in entry block, because it is overwritten before each return.
define void @accessible_after_return6(i32* %P, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @accessible_after_return6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    store i32 2, i32* [[P]], align 4
; CHECK-NEXT:    ret void
; CHECK:       bb4:
; CHECK-NEXT:    store i32 3, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %P
  br i1 %c.1, label %bb1, label %bb2

bb1:
  br i1 %c.2, label %bb3, label %bb4

bb2:
  store i32 1, i32* %P
  ret void

bb3:
  store i32 2, i32* %P
  ret void

bb4:
  store i32 3, i32* %P
  ret void
}

; Can remove store in bb1, because it is overwritten along each path
; from bb1 to the exit.
define void @accessible_after_return7(i32* %P, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @accessible_after_return7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 2, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    ret void
;
entry:
  br i1 %c.1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br i1 %c.2, label %bb3, label %bb4

bb3:
  store i32 2, i32* %P
  br label %bb5

bb4:
  store i32 1, i32* %P
  br label %bb5

bb2:
  br label %bb5

bb5:
  ret void
}


; Cannot remove store in entry block, because it is overwritten along each path to
; the exit (entry->bb1->bb4->bb5).
define void @accessible_after_return8(i32* %P, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @accessible_after_return8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 2, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb4:
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %P
  br i1 %c.1, label %bb1, label %bb2

bb1:
  br i1 %c.2, label %bb3, label %bb4

bb2:
  store i32 1, i32* %P
  br label %bb5

bb3:
  store i32 2, i32* %P
  br label %bb5

bb4:
  br label %bb5

bb5:
  ret void
}

; Make sure no stores are removed here. In particular, the store in if.then
; should not be removed.
define void @accessible_after_return9(i8* noalias %ptr) {
; CHECK-LABEL: @accessible_after_return9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_0:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_0]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    store i8 99, i8* [[PTR:%.*]], align 8
; CHECK-NEXT:    [[C_1:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_END:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i8 20, i8* [[PTR]], align 8
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[C_2:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_2]], label [[IF_THEN10:%.*]], label [[FOR_INC:%.*]]
; CHECK:       if.then10:
; CHECK-NEXT:    store i8 0, i8* [[PTR]], align 8
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[C_3:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_3]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %c.0 = call i1 @cond()
  br i1 %c.0, label %for.body, label %for.end

for.body:
  store i8 99, i8* %ptr, align 8
  %c.1 = call i1 @cond()
  br i1 %c.1, label %if.end, label %if.then

if.then:
  store i8 20, i8* %ptr, align 8
  br label %if.end

if.end:
  %c.2 = call i1 @cond()
  br i1 %c.2, label %if.then10, label %for.inc

if.then10:
  store i8 0, i8* %ptr, align 8
  br label %for.inc

for.inc:
  %c.3 = call i1 @cond()
  br i1 %c.3, label %for.body, label %for.end

for.end:
  ret void
}

; Cannot remove store in entry block because it is not overwritten on path
; entry->bb2->bb4. Also make sure we deal with dead exit blocks without
; crashing.
define void @accessible_after_return10_dead_block(i32* %P, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @accessible_after_return10_dead_block(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    store i32 2, i32* [[P]], align 4
; CHECK-NEXT:    ret void
; CHECK:       bb4:
; CHECK-NEXT:    ret void
; CHECK:       bb5:
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %P
  br i1 %c.1, label %bb1, label %bb2

bb1:
  br i1 %c.2, label %bb3, label %bb4

bb2:
  store i32 1, i32* %P
  ret void

bb3:
  store i32 2, i32* %P
  ret void

bb4:
  ret void

bb5:
  ret void
}

@linenum = external local_unnamed_addr global i32, align 4

define void @accessible_after_return11_loop() {
; CHECK-LABEL: @accessible_after_return11_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY_I:%.*]]
; CHECK:       for.body.i:
; CHECK-NEXT:    [[C_1:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_1]], label [[FOR_BODY_I]], label [[INIT_PARSE_EXIT:%.*]]
; CHECK:       init_parse.exit:
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull undef)
; CHECK-NEXT:    store i32 0, i32* @linenum, align 4
; CHECK-NEXT:    br label [[FOR_BODY_I20:%.*]]
; CHECK:       for.body.i20:
; CHECK-NEXT:    [[C_2:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_2]], label [[FOR_BODY_I20]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body.i

for.body.i:                                       ; preds = %for.body.i, %entry
  %c.1 = call i1 @cond()
  br i1 %c.1, label %for.body.i, label %init_parse.exit

init_parse.exit:                                  ; preds = %for.body.i
  store i32 0, i32* @linenum, align 4
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull undef) #2
  store i32 0, i32* @linenum, align 4
  br label %for.body.i20

for.body.i20:                                     ; preds = %for.body.i20, %init_parse.exit
  %c.2 = call i1 @cond()
  br i1 %c.2, label %for.body.i20, label %exit

exit:
  ret void
}
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)
declare i1 @cond() readnone nounwind

; Tests where the pointer/object is *NOT* accessible after the function returns.

; The store in the entry block can be eliminated, because it is overwritten
; on all paths to the exit.
define void @alloca_1(i1 %c1) {
; CHECK-LABEL: @alloca_1(
; CHECK-NEXT:    [[P:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 3, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  %P = alloca i32
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5
bb2:
  store i32 3, i32* %P
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

; The store in the entry block can be eliminated, because it is overwritten
; on all paths to the exit.
define void @alloca_2(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @alloca_2(
; CHECK-NEXT:    [[P:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 3, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb4:
; CHECK-NEXT:    store i32 5, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  %P = alloca i32
  store i32 1, i32* %P
  br i1 %c.1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5

bb2:
  br i1 %c.2, label %bb3, label %bb4

bb3:
  store i32 3, i32* %P
  br label %bb5

bb4:
  store i32 5, i32* %P
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

; The store in the entry block cannot be eliminated. There's a path from the
; first store to the read in bb5, where the location is not overwritten.
define void @alloca_3(i1 %c1) {
; CHECK-LABEL: @alloca_3(
; CHECK-NEXT:    [[P:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  %P = alloca i32
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5
bb2:
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

; The store in the entry block can be eliminated, because it is overwritten
; before the use in bb1 and not read on other paths to the function exit. The
; object cannot be accessed by the caller.
define void @alloca_4(i1 %c1) {
; CHECK-LABEL: @alloca_4(
; CHECK-NEXT:    [[P:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    ret void
;
  %P = alloca i32
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  call void @use(i32* %P)
  br label %bb5

bb2:
  br label %bb5

bb5:
  ret void
}

%struct.blam.4 = type { %struct.bar.5, [4 x i8] }
%struct.bar.5 = type <{ i64, i64*, i32, i64 }>

; Make sure we do not eliminate the store in %bb.
define void @alloca_5(i1 %c) {
; CHECK-LABEL: @alloca_5(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = alloca [[STRUCT_BLAM_4:%.*]], align 8
; CHECK-NEXT:    [[TMP38:%.*]] = getelementptr inbounds [[STRUCT_BLAM_4]], %struct.blam.4* [[TMP]], i64 0, i32 0, i32 3
; CHECK-NEXT:    [[TMP39:%.*]] = bitcast i64* [[TMP38]] to i64*
; CHECK-NEXT:    store i64 0, i64* [[TMP39]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB46:%.*]], label [[BB47:%.*]]
; CHECK:       bb46:
; CHECK-NEXT:    ret void
; CHECK:       bb47:
; CHECK-NEXT:    [[TMP48:%.*]] = getelementptr inbounds [[STRUCT_BLAM_4]], %struct.blam.4* [[TMP]], i64 0, i32 0, i32 2
; CHECK-NEXT:    store i32 20, i32* [[TMP48]], align 8
; CHECK-NEXT:    br label [[BB52:%.*]]
; CHECK:       bb52:
; CHECK-NEXT:    br i1 [[C]], label [[BB68:%.*]], label [[BB59:%.*]]
; CHECK:       bb59:
; CHECK-NEXT:    call void @use.2(%struct.blam.4* [[TMP]])
; CHECK-NEXT:    ret void
; CHECK:       bb68:
; CHECK-NEXT:    ret void
;
bb:
  %tmp = alloca %struct.blam.4, align 8
  %tmp36 = getelementptr inbounds %struct.blam.4, %struct.blam.4* %tmp, i64 0, i32 0, i32 1
  %tmp37 = bitcast i64** %tmp36 to i8*
  %tmp38 = getelementptr inbounds %struct.blam.4, %struct.blam.4* %tmp, i64 0, i32 0, i32 3
  %tmp39 = bitcast i64* %tmp38 to i64*
  store i64 0, i64* %tmp39, align 4
  br i1 %c, label %bb46, label %bb47

bb46:                                             ; preds = %bb12
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 dereferenceable(20) %tmp37, i8 0, i64 26, i1 false)
  ret void

bb47:                                             ; preds = %bb12
  %tmp48 = getelementptr inbounds %struct.blam.4, %struct.blam.4* %tmp, i64 0, i32 0, i32 2
  store i32 20, i32* %tmp48, align 8
  br label %bb52

bb52:                                             ; preds = %bb47
  br i1 %c, label %bb68, label %bb59

bb59:                                             ; preds = %bb52
  call void @use.2(%struct.blam.4* %tmp)
  ret void

bb68:                                             ; preds = %bb52
  ret void
}

declare void @use.2(%struct.blam.4*)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)
