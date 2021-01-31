; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -S -phi-node-folding-threshold=1 | FileCheck %s
; RUN: opt < %s -simplifycfg -S -phi-node-folding-threshold=2 | FileCheck %s
; RUN: opt < %s -simplifycfg -S -phi-node-folding-threshold=7 | FileCheck %s

; Test merging of blocks containing complex expressions,
; with various folding thresholds

define i32 @test(i1 %a, i1 %b, i32 %i, i32 %j, i32 %k) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[A:%.*]], label [[M:%.*]], label [[O:%.*]]
; CHECK:       O:
; CHECK-NEXT:    [[IAJ:%.*]] = add i32 [[I:%.*]], [[J:%.*]]
; CHECK-NEXT:    [[IAJAK:%.*]] = add i32 [[IAJ]], [[K:%.*]]
; CHECK-NEXT:    [[IXJ:%.*]] = xor i32 [[I]], [[J]]
; CHECK-NEXT:    [[IXJXK:%.*]] = xor i32 [[IXJ]], [[K]]
; CHECK-NEXT:    [[WP:%.*]] = select i1 [[B:%.*]], i32 [[IAJAK]], i32 [[IXJXK]]
; CHECK-NEXT:    [[WP2:%.*]] = add i32 [[WP]], [[WP]]
; CHECK-NEXT:    br label [[M]]
; CHECK:       M:
; CHECK-NEXT:    [[W:%.*]] = phi i32 [ [[WP2]], [[O]] ], [ 2, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[R:%.*]] = add i32 [[W]], 1
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %a, label %M, label %O
O:
  br i1 %b, label %P, label %Q
P:
  %iaj = add i32 %i, %j
  %iajak = add i32 %iaj, %k
  br label %N
Q:
  %ixj = xor i32 %i, %j
  %ixjxk = xor i32 %ixj, %k
  br label %N
N:
  ; This phi should be foldable if threshold >= 2
  %Wp = phi i32 [ %iajak, %P ], [ %ixjxk, %Q ]
  %Wp2 = add i32 %Wp, %Wp
  br label %M
M:
  ; This phi should be foldable if threshold >= 7
  %W = phi i32 [ %Wp2, %N ], [ 2, %entry ]
  %R = add i32 %W, 1
  ret i32 %R
}

