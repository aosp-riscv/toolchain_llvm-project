; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -gvn -o - %s | FileCheck %s
; RUN: opt -S -passes=gvn -o - %s | FileCheck %s

define i32 @foo(i1 %cond, i32* %q, i32* %p) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V0:%.*]] = call i32 @llvm.convergent(i32 0)
; CHECK-NEXT:    store i32 [[V0]], i32* [[Q:%.*]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[PRE:%.*]], label [[MERGE:%.*]]
; CHECK:       pre:
; CHECK-NEXT:    [[T0:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[M0:%.*]] = phi i32 [ [[T0]], [[PRE]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[R0:%.*]] = call i32 @llvm.convergent(i32 [[M0]])
; CHECK-NEXT:    ret i32 [[R0]]
;
entry:
  %v0 = call i32 @llvm.convergent(i32 0)
  store i32 %v0, i32* %q
  br i1 %cond, label %pre, label %merge

pre:
  %t0 = load i32, i32* %p
  br label %merge

merge:
  %m0 = phi i32 [ %t0, %pre ], [ 0, %entry ]
  %r0 = call i32 @llvm.convergent(i32 %m0)
  ret i32 %r0
}

declare i32 @llvm.convergent(i32) #0

attributes #0 = { convergent nounwind readnone }
