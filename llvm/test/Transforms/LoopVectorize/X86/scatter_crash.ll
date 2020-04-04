; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-vectorize -S | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

; This test checks vector GEP before scatter.
; The code bellow crashed due to destroyed SSA while incorrect vectorization of
; the GEP.

@d = global [10 x [10 x i32]] zeroinitializer, align 16
@c = external global i32, align 4
@a = external global i32, align 4
@b = external global i64, align 8

; Function Attrs: norecurse nounwind ssp uwtable
define void @_Z3fn1v() #0 {
; CHECK-LABEL: @_Z3fn1v(
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %vector.ph ], [ [[INDEX_NEXT:%.*]], %vector.body ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <16 x i64> [ <i64 8, i64 10, i64 12, i64 14, i64 16, i64 18, i64 20, i64 22, i64 24, i64 26, i64 28, i64 30, i64 32, i64 34, i64 36, i64 38>, %vector.ph ], [ [[VEC_IND_NEXT:%.*]], %vector.body ]
; CHECK-NEXT:    [[VEC_IND3:%.*]] = phi <16 x i64> [ <i64 0, i64 2, i64 4, i64 6, i64 8, i64 10, i64 12, i64 14, i64 16, i64 18, i64 20, i64 22, i64 24, i64 26, i64 28, i64 30>, %vector.ph ], [ [[VEC_IND_NEXT4:%.*]], %vector.body ]
; CHECK-NEXT:    [[TMP10:%.*]] = sub nsw <16 x i64> <i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8, i64 8>, [[VEC_IND]]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* @d, i64 0, <16 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP12:%.*]] = add nsw <16 x i64> [[TMP10]], [[VEC_IND3]]
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds [10 x i32], <16 x [10 x i32]*> [[TMP11]], <16 x i64> [[TMP12]], i64 0
; CHECK-NEXT:    call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> <i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>, <16 x i32*> [[TMP13]], i32 16, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
; CHECK-NEXT:    [[TMP14:%.*]] = or <16 x i64> [[VEC_IND3]], <i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1>
; CHECK-NEXT:    [[TMP15:%.*]] = add nsw <16 x i64> [[TMP10]], [[TMP14]]
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds [10 x i32], <16 x [10 x i32]*> [[TMP11]], <16 x i64> [[TMP15]], i64 0
; CHECK-NEXT:    call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> <i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>, <16 x i32*> [[TMP16]], i32 8, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <16 x i64> [[VEC_IND]], <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[VEC_IND_NEXT4]] = add <16 x i64> [[VEC_IND3]], <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
; CHECK:         br i1 {{.*}}, label %middle.block, label %vector.body
;
entry:
  %0 = load i32, i32* @c, align 4
  %cmp34 = icmp sgt i32 %0, 8
  br i1 %cmp34, label %for.body.lr.ph, label %for.cond.cleanup

for.body.lr.ph:                                   ; preds = %entry
  %1 = load i32, i32* @a, align 4
  %tobool = icmp eq i32 %1, 0
  %2 = load i64, i64* @b, align 8
  %mul = mul i64 %2, 4063299859190
  %tobool6 = icmp eq i64 %mul, 0
  %3 = sext i32 %0 to i64
  br i1 %tobool, label %for.body.us.preheader, label %for.body.preheader

for.body.preheader:                               ; preds = %for.body.lr.ph
  br label %for.body

for.body.us.preheader:                            ; preds = %for.body.lr.ph
  br label %for.body.us

for.body.us:                                      ; preds = %for.body.us.preheader, %for.cond.cleanup4.us-lcssa.us.us
  %indvars.iv78 = phi i64 [ %indvars.iv.next79, %for.cond.cleanup4.us-lcssa.us.us ], [ 8, %for.body.us.preheader ]
  %indvars.iv70 = phi i64 [ %indvars.iv.next71, %for.cond.cleanup4.us-lcssa.us.us ], [ 0, %for.body.us.preheader ]
  %4 = sub nsw i64 8, %indvars.iv78
  %add.ptr.us = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* @d, i64 0, i64 %indvars.iv78
  %5 = add nsw i64 %4, %indvars.iv70
  %arraydecay.us.us.us = getelementptr inbounds [10 x i32], [10 x i32]* %add.ptr.us, i64 %5, i64 0
  br i1 %tobool6, label %for.body5.us.us.us.preheader, label %for.body5.us.us48.preheader

for.body5.us.us48.preheader:                      ; preds = %for.body.us
  store i32 8, i32* %arraydecay.us.us.us, align 16
  %indvars.iv.next66 = or i64 %indvars.iv70, 1
  %6 = add nsw i64 %4, %indvars.iv.next66
  %arraydecay.us.us55.1 = getelementptr inbounds [10 x i32], [10 x i32]* %add.ptr.us, i64 %6, i64 0
  store i32 8, i32* %arraydecay.us.us55.1, align 8
  br label %for.cond.cleanup4.us-lcssa.us.us

for.body5.us.us.us.preheader:                     ; preds = %for.body.us
  store i32 7, i32* %arraydecay.us.us.us, align 16
  %indvars.iv.next73 = or i64 %indvars.iv70, 1
  %7 = add nsw i64 %4, %indvars.iv.next73
  %arraydecay.us.us.us.1 = getelementptr inbounds [10 x i32], [10 x i32]* %add.ptr.us, i64 %7, i64 0
  store i32 7, i32* %arraydecay.us.us.us.1, align 8
  br label %for.cond.cleanup4.us-lcssa.us.us

for.cond.cleanup4.us-lcssa.us.us:                 ; preds = %for.body5.us.us48.preheader, %for.body5.us.us.us.preheader
  %indvars.iv.next79 = add nuw nsw i64 %indvars.iv78, 2
  %cmp.us = icmp slt i64 %indvars.iv.next79, %3
  %indvars.iv.next71 = add nuw nsw i64 %indvars.iv70, 2
  br i1 %cmp.us, label %for.body.us, label %for.cond.cleanup.loopexit

for.cond.cleanup.loopexit:                        ; preds = %for.cond.cleanup4.us-lcssa.us.us
  br label %for.cond.cleanup

for.cond.cleanup.loopexit99:                      ; preds = %for.body
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit99, %for.cond.cleanup.loopexit, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv95 = phi i64 [ %indvars.iv.next96, %for.body ], [ 8, %for.body.preheader ]
  %indvars.iv87 = phi i64 [ %indvars.iv.next88, %for.body ], [ 0, %for.body.preheader ]
  %8 = sub nsw i64 8, %indvars.iv95
  %add.ptr = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* @d, i64 0, i64 %indvars.iv95
  %9 = add nsw i64 %8, %indvars.iv87
  %arraydecay.us31 = getelementptr inbounds [10 x i32], [10 x i32]* %add.ptr, i64 %9, i64 0
  store i32 8, i32* %arraydecay.us31, align 16
  %indvars.iv.next90 = or i64 %indvars.iv87, 1
  %10 = add nsw i64 %8, %indvars.iv.next90
  %arraydecay.us31.1 = getelementptr inbounds [10 x i32], [10 x i32]* %add.ptr, i64 %10, i64 0
  store i32 8, i32* %arraydecay.us31.1, align 8
  %indvars.iv.next96 = add nuw nsw i64 %indvars.iv95, 2
  %cmp = icmp slt i64 %indvars.iv.next96, %3
  %indvars.iv.next88 = add nuw nsw i64 %indvars.iv87, 2
  br i1 %cmp, label %for.body, label %for.cond.cleanup.loopexit99
}

attributes #0 = { norecurse nounwind ssp uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="knl" "target-features"="+adx,+aes,+avx,+avx2,+avx512cd,+avx512er,+avx512f,+avx512pf,+bmi,+bmi2,+cx16,+f16c,+fma,+fsgsbase,+fxsr,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prefetchwt1,+rdrnd,+rdseed,+rtm,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
