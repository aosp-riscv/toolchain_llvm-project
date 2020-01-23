; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+sse3 | FileCheck %s --check-prefixes=CHECK,SSE,SSE3
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+ssse3 | FileCheck %s --check-prefixes=CHECK,SSE,SSSE3
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+sse4.1 | FileCheck %s --check-prefixes=CHECK,SSE,SSE41
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512F
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512BW
;
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mcpu=slm | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mcpu=goldmont | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -mtriple=x86_64-apple-macosx10.8.0 -cost-model -analyze -mcpu=btver2 | FileCheck %s --check-prefixes=BTVER2

define i32 @extract_double(i32 %arg) {
; SSE-LABEL: 'extract_double'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_a = extractelement <2 x double> undef, i32 %arg
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f64_0 = extractelement <2 x double> undef, i32 0
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_1 = extractelement <2 x double> undef, i32 1
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_a = extractelement <4 x double> undef, i32 %arg
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f64_0 = extractelement <4 x double> undef, i32 0
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_3 = extractelement <4 x double> undef, i32 3
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_a = extractelement <8 x double> undef, i32 %arg
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f64_0 = extractelement <8 x double> undef, i32 0
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_3 = extractelement <8 x double> undef, i32 3
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f64_4 = extractelement <8 x double> undef, i32 4
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_7 = extractelement <8 x double> undef, i32 7
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'extract_double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_a = extractelement <2 x double> undef, i32 %arg
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f64_0 = extractelement <2 x double> undef, i32 0
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_1 = extractelement <2 x double> undef, i32 1
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_a = extractelement <4 x double> undef, i32 %arg
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f64_0 = extractelement <4 x double> undef, i32 0
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_3 = extractelement <4 x double> undef, i32 3
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_a = extractelement <8 x double> undef, i32 %arg
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f64_0 = extractelement <8 x double> undef, i32 0
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_3 = extractelement <8 x double> undef, i32 3
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f64_4 = extractelement <8 x double> undef, i32 4
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_7 = extractelement <8 x double> undef, i32 7
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'extract_double'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_a = extractelement <2 x double> undef, i32 %arg
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f64_0 = extractelement <2 x double> undef, i32 0
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_1 = extractelement <2 x double> undef, i32 1
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_a = extractelement <4 x double> undef, i32 %arg
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f64_0 = extractelement <4 x double> undef, i32 0
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_3 = extractelement <4 x double> undef, i32 3
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_a = extractelement <8 x double> undef, i32 %arg
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f64_0 = extractelement <8 x double> undef, i32 0
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_3 = extractelement <8 x double> undef, i32 3
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_4 = extractelement <8 x double> undef, i32 4
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_7 = extractelement <8 x double> undef, i32 7
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; BTVER2-LABEL: 'extract_double'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_a = extractelement <2 x double> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f64_0 = extractelement <2 x double> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f64_1 = extractelement <2 x double> undef, i32 1
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_a = extractelement <4 x double> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f64_0 = extractelement <4 x double> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f64_3 = extractelement <4 x double> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_a = extractelement <8 x double> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f64_0 = extractelement <8 x double> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_3 = extractelement <8 x double> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f64_4 = extractelement <8 x double> undef, i32 4
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f64_7 = extractelement <8 x double> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %v2f64_a = extractelement <2 x double> undef, i32 %arg
  %v2f64_0 = extractelement <2 x double> undef, i32 0
  %v2f64_1 = extractelement <2 x double> undef, i32 1

  %v4f64_a = extractelement <4 x double> undef, i32 %arg
  %v4f64_0 = extractelement <4 x double> undef, i32 0
  %v4f64_3 = extractelement <4 x double> undef, i32 3

  %v8f64_a = extractelement <8 x double> undef, i32 %arg
  %v8f64_0 = extractelement <8 x double> undef, i32 0
  %v8f64_3 = extractelement <8 x double> undef, i32 3
  %v8f64_4 = extractelement <8 x double> undef, i32 4
  %v8f64_7 = extractelement <8 x double> undef, i32 7

  ret i32 undef
}

define i32 @extract_float(i32 %arg) {
; SSE-LABEL: 'extract_float'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_a = extractelement <2 x float> undef, i32 %arg
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f32_0 = extractelement <2 x float> undef, i32 0
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_1 = extractelement <2 x float> undef, i32 1
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_a = extractelement <4 x float> undef, i32 %arg
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f32_0 = extractelement <4 x float> undef, i32 0
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_3 = extractelement <4 x float> undef, i32 3
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_a = extractelement <8 x float> undef, i32 %arg
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f32_0 = extractelement <8 x float> undef, i32 0
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_3 = extractelement <8 x float> undef, i32 3
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f32_4 = extractelement <8 x float> undef, i32 4
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_7 = extractelement <8 x float> undef, i32 7
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_a = extractelement <16 x float> undef, i32 %arg
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v16f32_0 = extractelement <16 x float> undef, i32 0
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_3 = extractelement <16 x float> undef, i32 3
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v16f32_8 = extractelement <16 x float> undef, i32 8
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_15 = extractelement <16 x float> undef, i32 15
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'extract_float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_a = extractelement <2 x float> undef, i32 %arg
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f32_0 = extractelement <2 x float> undef, i32 0
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_1 = extractelement <2 x float> undef, i32 1
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_a = extractelement <4 x float> undef, i32 %arg
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f32_0 = extractelement <4 x float> undef, i32 0
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_3 = extractelement <4 x float> undef, i32 3
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_a = extractelement <8 x float> undef, i32 %arg
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f32_0 = extractelement <8 x float> undef, i32 0
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_3 = extractelement <8 x float> undef, i32 3
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_4 = extractelement <8 x float> undef, i32 4
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_7 = extractelement <8 x float> undef, i32 7
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_a = extractelement <16 x float> undef, i32 %arg
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v16f32_0 = extractelement <16 x float> undef, i32 0
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_3 = extractelement <16 x float> undef, i32 3
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v16f32_8 = extractelement <16 x float> undef, i32 8
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_15 = extractelement <16 x float> undef, i32 15
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'extract_float'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_a = extractelement <2 x float> undef, i32 %arg
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f32_0 = extractelement <2 x float> undef, i32 0
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_1 = extractelement <2 x float> undef, i32 1
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_a = extractelement <4 x float> undef, i32 %arg
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f32_0 = extractelement <4 x float> undef, i32 0
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_3 = extractelement <4 x float> undef, i32 3
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_a = extractelement <8 x float> undef, i32 %arg
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f32_0 = extractelement <8 x float> undef, i32 0
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_3 = extractelement <8 x float> undef, i32 3
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_4 = extractelement <8 x float> undef, i32 4
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_7 = extractelement <8 x float> undef, i32 7
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_a = extractelement <16 x float> undef, i32 %arg
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v16f32_0 = extractelement <16 x float> undef, i32 0
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_3 = extractelement <16 x float> undef, i32 3
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_8 = extractelement <16 x float> undef, i32 8
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_15 = extractelement <16 x float> undef, i32 15
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; BTVER2-LABEL: 'extract_float'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_a = extractelement <2 x float> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2f32_0 = extractelement <2 x float> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32_1 = extractelement <2 x float> undef, i32 1
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_a = extractelement <4 x float> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4f32_0 = extractelement <4 x float> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4f32_3 = extractelement <4 x float> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_a = extractelement <8 x float> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v8f32_0 = extractelement <8 x float> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_3 = extractelement <8 x float> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_4 = extractelement <8 x float> undef, i32 4
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8f32_7 = extractelement <8 x float> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_a = extractelement <16 x float> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v16f32_0 = extractelement <16 x float> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_3 = extractelement <16 x float> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v16f32_8 = extractelement <16 x float> undef, i32 8
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16f32_15 = extractelement <16 x float> undef, i32 15
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %v2f32_a = extractelement <2 x float> undef, i32 %arg
  %v2f32_0 = extractelement <2 x float> undef, i32 0
  %v2f32_1 = extractelement <2 x float> undef, i32 1

  %v4f32_a = extractelement <4 x float> undef, i32 %arg
  %v4f32_0 = extractelement <4 x float> undef, i32 0
  %v4f32_3 = extractelement <4 x float> undef, i32 3

  %v8f32_a = extractelement <8 x float> undef, i32 %arg
  %v8f32_0 = extractelement <8 x float> undef, i32 0
  %v8f32_3 = extractelement <8 x float> undef, i32 3
  %v8f32_4 = extractelement <8 x float> undef, i32 4
  %v8f32_7 = extractelement <8 x float> undef, i32 7

  %v16f32_a = extractelement <16 x float> undef, i32 %arg
  %v16f32_0 = extractelement <16 x float> undef, i32 0
  %v16f32_3 = extractelement <16 x float> undef, i32 3
  %v16f32_8 = extractelement <16 x float> undef, i32 8
  %v16f32_15 = extractelement <16 x float> undef, i32 15

  ret i32 undef
}

define i32 @extract_i64(i32 %arg) {
; CHECK-LABEL: 'extract_i64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i64_a = extractelement <2 x i64> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i64_0 = extractelement <2 x i64> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i64_1 = extractelement <2 x i64> undef, i32 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i64_a = extractelement <4 x i64> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i64_0 = extractelement <4 x i64> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i64_3 = extractelement <4 x i64> undef, i32 3
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_a = extractelement <8 x i64> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_0 = extractelement <8 x i64> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_3 = extractelement <8 x i64> undef, i32 3
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_4 = extractelement <8 x i64> undef, i32 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_7 = extractelement <8 x i64> undef, i32 7
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; BTVER2-LABEL: 'extract_i64'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i64_a = extractelement <2 x i64> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i64_0 = extractelement <2 x i64> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i64_1 = extractelement <2 x i64> undef, i32 1
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i64_a = extractelement <4 x i64> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i64_0 = extractelement <4 x i64> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i64_3 = extractelement <4 x i64> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_a = extractelement <8 x i64> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_0 = extractelement <8 x i64> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_3 = extractelement <8 x i64> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_4 = extractelement <8 x i64> undef, i32 4
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i64_7 = extractelement <8 x i64> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %v2i64_a = extractelement <2 x i64> undef, i32 %arg
  %v2i64_0 = extractelement <2 x i64> undef, i32 0
  %v2i64_1 = extractelement <2 x i64> undef, i32 1

  %v4i64_a = extractelement <4 x i64> undef, i32 %arg
  %v4i64_0 = extractelement <4 x i64> undef, i32 0
  %v4i64_3 = extractelement <4 x i64> undef, i32 3

  %v8i64_a = extractelement <8 x i64> undef, i32 %arg
  %v8i64_0 = extractelement <8 x i64> undef, i32 0
  %v8i64_3 = extractelement <8 x i64> undef, i32 3
  %v8i64_4 = extractelement <8 x i64> undef, i32 4
  %v8i64_7 = extractelement <8 x i64> undef, i32 7

  ret i32 undef
}

define i32 @extract_i32(i32 %arg) {
; CHECK-LABEL: 'extract_i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i32_a = extractelement <2 x i32> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i32_0 = extractelement <2 x i32> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i32_1 = extractelement <2 x i32> undef, i32 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i32_a = extractelement <4 x i32> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i32_0 = extractelement <4 x i32> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i32_3 = extractelement <4 x i32> undef, i32 3
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_a = extractelement <8 x i32> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_0 = extractelement <8 x i32> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_3 = extractelement <8 x i32> undef, i32 3
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_4 = extractelement <8 x i32> undef, i32 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_7 = extractelement <8 x i32> undef, i32 7
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_a = extractelement <16 x i32> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_0 = extractelement <16 x i32> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_3 = extractelement <16 x i32> undef, i32 3
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_8 = extractelement <16 x i32> undef, i32 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_15 = extractelement <16 x i32> undef, i32 15
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; BTVER2-LABEL: 'extract_i32'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i32_a = extractelement <2 x i32> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i32_0 = extractelement <2 x i32> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2i32_1 = extractelement <2 x i32> undef, i32 1
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i32_a = extractelement <4 x i32> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i32_0 = extractelement <4 x i32> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v4i32_3 = extractelement <4 x i32> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_a = extractelement <8 x i32> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_0 = extractelement <8 x i32> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_3 = extractelement <8 x i32> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_4 = extractelement <8 x i32> undef, i32 4
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i32_7 = extractelement <8 x i32> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_a = extractelement <16 x i32> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_0 = extractelement <16 x i32> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_3 = extractelement <16 x i32> undef, i32 3
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_8 = extractelement <16 x i32> undef, i32 8
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i32_15 = extractelement <16 x i32> undef, i32 15
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %v2i32_a = extractelement <2 x i32> undef, i32 %arg
  %v2i32_0 = extractelement <2 x i32> undef, i32 0
  %v2i32_1 = extractelement <2 x i32> undef, i32 1

  %v4i32_a = extractelement <4 x i32> undef, i32 %arg
  %v4i32_0 = extractelement <4 x i32> undef, i32 0
  %v4i32_3 = extractelement <4 x i32> undef, i32 3

  %v8i32_a = extractelement <8 x i32> undef, i32 %arg
  %v8i32_0 = extractelement <8 x i32> undef, i32 0
  %v8i32_3 = extractelement <8 x i32> undef, i32 3
  %v8i32_4 = extractelement <8 x i32> undef, i32 4
  %v8i32_7 = extractelement <8 x i32> undef, i32 7

  %v16i32_a = extractelement <16 x i32> undef, i32 %arg
  %v16i32_0 = extractelement <16 x i32> undef, i32 0
  %v16i32_3 = extractelement <16 x i32> undef, i32 3
  %v16i32_8 = extractelement <16 x i32> undef, i32 8
  %v16i32_15 = extractelement <16 x i32> undef, i32 15

  ret i32 undef
}

define i32 @extract_i16(i32 %arg) {
; CHECK-LABEL: 'extract_i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i16_a = extractelement <8 x i16> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i16_0 = extractelement <8 x i16> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i16_7 = extractelement <8 x i16> undef, i32 7
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_a = extractelement <16 x i16> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_0 = extractelement <16 x i16> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_7 = extractelement <16 x i16> undef, i32 7
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_8 = extractelement <16 x i16> undef, i32 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_15 = extractelement <16 x i16> undef, i32 15
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_a = extractelement <32 x i16> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_0 = extractelement <32 x i16> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_7 = extractelement <32 x i16> undef, i32 7
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_8 = extractelement <32 x i16> undef, i32 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_15 = extractelement <32 x i16> undef, i32 15
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_16 = extractelement <32 x i16> undef, i32 16
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_24 = extractelement <32 x i16> undef, i32 24
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_31 = extractelement <32 x i16> undef, i32 31
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; BTVER2-LABEL: 'extract_i16'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i16_a = extractelement <8 x i16> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i16_0 = extractelement <8 x i16> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v8i16_7 = extractelement <8 x i16> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_a = extractelement <16 x i16> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_0 = extractelement <16 x i16> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_7 = extractelement <16 x i16> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_8 = extractelement <16 x i16> undef, i32 8
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i16_15 = extractelement <16 x i16> undef, i32 15
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_a = extractelement <32 x i16> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_0 = extractelement <32 x i16> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_7 = extractelement <32 x i16> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_8 = extractelement <32 x i16> undef, i32 8
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_15 = extractelement <32 x i16> undef, i32 15
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_16 = extractelement <32 x i16> undef, i32 16
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_24 = extractelement <32 x i16> undef, i32 24
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i16_31 = extractelement <32 x i16> undef, i32 31
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %v8i16_a = extractelement <8 x i16> undef, i32 %arg
  %v8i16_0 = extractelement <8 x i16> undef, i32 0
  %v8i16_7 = extractelement <8 x i16> undef, i32 7

  %v16i16_a = extractelement <16 x i16> undef, i32 %arg
  %v16i16_0 = extractelement <16 x i16> undef, i32 0
  %v16i16_7 = extractelement <16 x i16> undef, i32 7
  %v16i16_8 = extractelement <16 x i16> undef, i32 8
  %v16i16_15 = extractelement <16 x i16> undef, i32 15

  %v32i16_a = extractelement <32 x i16> undef, i32 %arg
  %v32i16_0 = extractelement <32 x i16> undef, i32 0
  %v32i16_7 = extractelement <32 x i16> undef, i32 7
  %v32i16_8 = extractelement <32 x i16> undef, i32 8
  %v32i16_15 = extractelement <32 x i16> undef, i32 15
  %v32i16_16 = extractelement <32 x i16> undef, i32 16
  %v32i16_24 = extractelement <32 x i16> undef, i32 24
  %v32i16_31 = extractelement <32 x i16> undef, i32 31

  ret i32 undef
}

define i32 @extract_i8(i32 %arg) {
; CHECK-LABEL: 'extract_i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_a = extractelement <16 x i8> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_0 = extractelement <16 x i8> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_8 = extractelement <16 x i8> undef, i32 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_15 = extractelement <16 x i8> undef, i32 15
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_a = extractelement <32 x i8> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_0 = extractelement <32 x i8> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_7 = extractelement <32 x i8> undef, i32 7
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_8 = extractelement <32 x i8> undef, i32 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_15 = extractelement <32 x i8> undef, i32 15
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_24 = extractelement <32 x i8> undef, i32 24
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_31 = extractelement <32 x i8> undef, i32 31
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_a = extractelement <64 x i8> undef, i32 %arg
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_0 = extractelement <64 x i8> undef, i32 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_7 = extractelement <64 x i8> undef, i32 7
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_8 = extractelement <64 x i8> undef, i32 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_15 = extractelement <64 x i8> undef, i32 15
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_24 = extractelement <64 x i8> undef, i32 24
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_31 = extractelement <64 x i8> undef, i32 31
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_32 = extractelement <64 x i8> undef, i32 32
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_48 = extractelement <64 x i8> undef, i32 48
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_63 = extractelement <64 x i8> undef, i32 63
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; BTVER2-LABEL: 'extract_i8'
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_a = extractelement <16 x i8> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_0 = extractelement <16 x i8> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_8 = extractelement <16 x i8> undef, i32 8
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v16i8_15 = extractelement <16 x i8> undef, i32 15
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_a = extractelement <32 x i8> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_0 = extractelement <32 x i8> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_7 = extractelement <32 x i8> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_8 = extractelement <32 x i8> undef, i32 8
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_15 = extractelement <32 x i8> undef, i32 15
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_24 = extractelement <32 x i8> undef, i32 24
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v32i8_31 = extractelement <32 x i8> undef, i32 31
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_a = extractelement <64 x i8> undef, i32 %arg
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_0 = extractelement <64 x i8> undef, i32 0
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_7 = extractelement <64 x i8> undef, i32 7
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_8 = extractelement <64 x i8> undef, i32 8
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_15 = extractelement <64 x i8> undef, i32 15
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_24 = extractelement <64 x i8> undef, i32 24
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_31 = extractelement <64 x i8> undef, i32 31
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_32 = extractelement <64 x i8> undef, i32 32
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_48 = extractelement <64 x i8> undef, i32 48
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v64i8_63 = extractelement <64 x i8> undef, i32 63
; BTVER2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %v16i8_a = extractelement <16 x i8> undef, i32 %arg
  %v16i8_0 = extractelement <16 x i8> undef, i32 0
  %v16i8_8 = extractelement <16 x i8> undef, i32 8
  %v16i8_15 = extractelement <16 x i8> undef, i32 15

  %v32i8_a = extractelement <32 x i8> undef, i32 %arg
  %v32i8_0 = extractelement <32 x i8> undef, i32 0
  %v32i8_7 = extractelement <32 x i8> undef, i32 7
  %v32i8_8 = extractelement <32 x i8> undef, i32 8
  %v32i8_15 = extractelement <32 x i8> undef, i32 15
  %v32i8_24 = extractelement <32 x i8> undef, i32 24
  %v32i8_31 = extractelement <32 x i8> undef, i32 31

  %v64i8_a = extractelement <64 x i8> undef, i32 %arg
  %v64i8_0 = extractelement <64 x i8> undef, i32 0
  %v64i8_7 = extractelement <64 x i8> undef, i32 7
  %v64i8_8 = extractelement <64 x i8> undef, i32 8
  %v64i8_15 = extractelement <64 x i8> undef, i32 15
  %v64i8_24 = extractelement <64 x i8> undef, i32 24
  %v64i8_31 = extractelement <64 x i8> undef, i32 31
  %v64i8_32 = extractelement <64 x i8> undef, i32 32
  %v64i8_48 = extractelement <64 x i8> undef, i32 48
  %v64i8_63 = extractelement <64 x i8> undef, i32 63

  ret i32 undef
}
