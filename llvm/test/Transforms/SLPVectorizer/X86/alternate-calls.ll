; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=slm -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=knl -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skx -basic-aa -slp-vectorizer -instcombine -S | FileCheck %s

define <8 x float> @ceil_floor(<8 x float> %a) {
; CHECK-LABEL: @ceil_floor(
; CHECK-NEXT:    [[A0:%.*]] = extractelement <8 x float> [[A:%.*]], i32 0
; CHECK-NEXT:    [[A1:%.*]] = extractelement <8 x float> [[A]], i32 1
; CHECK-NEXT:    [[A2:%.*]] = extractelement <8 x float> [[A]], i32 2
; CHECK-NEXT:    [[A3:%.*]] = extractelement <8 x float> [[A]], i32 3
; CHECK-NEXT:    [[A4:%.*]] = extractelement <8 x float> [[A]], i32 4
; CHECK-NEXT:    [[A5:%.*]] = extractelement <8 x float> [[A]], i32 5
; CHECK-NEXT:    [[A6:%.*]] = extractelement <8 x float> [[A]], i32 6
; CHECK-NEXT:    [[A7:%.*]] = extractelement <8 x float> [[A]], i32 7
; CHECK-NEXT:    [[AB0:%.*]] = call float @llvm.ceil.f32(float [[A0]])
; CHECK-NEXT:    [[AB1:%.*]] = call float @llvm.floor.f32(float [[A1]])
; CHECK-NEXT:    [[AB2:%.*]] = call float @llvm.floor.f32(float [[A2]])
; CHECK-NEXT:    [[AB3:%.*]] = call float @llvm.ceil.f32(float [[A3]])
; CHECK-NEXT:    [[AB4:%.*]] = call float @llvm.ceil.f32(float [[A4]])
; CHECK-NEXT:    [[AB5:%.*]] = call float @llvm.ceil.f32(float [[A5]])
; CHECK-NEXT:    [[AB6:%.*]] = call float @llvm.floor.f32(float [[A6]])
; CHECK-NEXT:    [[AB7:%.*]] = call float @llvm.floor.f32(float [[A7]])
; CHECK-NEXT:    [[R0:%.*]] = insertelement <8 x float> undef, float [[AB0]], i32 0
; CHECK-NEXT:    [[R1:%.*]] = insertelement <8 x float> [[R0]], float [[AB1]], i32 1
; CHECK-NEXT:    [[R2:%.*]] = insertelement <8 x float> [[R1]], float [[AB2]], i32 2
; CHECK-NEXT:    [[R3:%.*]] = insertelement <8 x float> [[R2]], float [[AB3]], i32 3
; CHECK-NEXT:    [[R4:%.*]] = insertelement <8 x float> [[R3]], float [[AB4]], i32 4
; CHECK-NEXT:    [[R5:%.*]] = insertelement <8 x float> [[R4]], float [[AB5]], i32 5
; CHECK-NEXT:    [[R6:%.*]] = insertelement <8 x float> [[R5]], float [[AB6]], i32 6
; CHECK-NEXT:    [[R7:%.*]] = insertelement <8 x float> [[R6]], float [[AB7]], i32 7
; CHECK-NEXT:    ret <8 x float> [[R7]]
;
  %a0 = extractelement <8 x float> %a, i32 0
  %a1 = extractelement <8 x float> %a, i32 1
  %a2 = extractelement <8 x float> %a, i32 2
  %a3 = extractelement <8 x float> %a, i32 3
  %a4 = extractelement <8 x float> %a, i32 4
  %a5 = extractelement <8 x float> %a, i32 5
  %a6 = extractelement <8 x float> %a, i32 6
  %a7 = extractelement <8 x float> %a, i32 7
  %ab0 = call float @llvm.ceil.f32(float %a0)
  %ab1 = call float @llvm.floor.f32(float %a1)
  %ab2 = call float @llvm.floor.f32(float %a2)
  %ab3 = call float @llvm.ceil.f32(float %a3)
  %ab4 = call float @llvm.ceil.f32(float %a4)
  %ab5 = call float @llvm.ceil.f32(float %a5)
  %ab6 = call float @llvm.floor.f32(float %a6)
  %ab7 = call float @llvm.floor.f32(float %a7)
  %r0 = insertelement <8 x float> undef, float %ab0, i32 0
  %r1 = insertelement <8 x float>   %r0, float %ab1, i32 1
  %r2 = insertelement <8 x float>   %r1, float %ab2, i32 2
  %r3 = insertelement <8 x float>   %r2, float %ab3, i32 3
  %r4 = insertelement <8 x float>   %r3, float %ab4, i32 4
  %r5 = insertelement <8 x float>   %r4, float %ab5, i32 5
  %r6 = insertelement <8 x float>   %r5, float %ab6, i32 6
  %r7 = insertelement <8 x float>   %r6, float %ab7, i32 7
  ret <8 x float> %r7
}

declare float @llvm.ceil.f32(float)
declare float @llvm.floor.f32(float)
