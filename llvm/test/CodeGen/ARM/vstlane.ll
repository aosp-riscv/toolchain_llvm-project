; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm -mattr=+neon | FileCheck %s

;Check the (default) alignment.
define void @vst1lanei8(i8* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: vst1lanei8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vst1.8 {d16[3]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i8>, <8 x i8>* %B
	%tmp2 = extractelement <8 x i8> %tmp1, i32 3
	store i8 %tmp2, i8* %A, align 8
	ret void
}

;Check for a post-increment updating store.
define void @vst1lanei8_update(i8** %ptr, <8 x i8>* %B) nounwind {
; CHECK-LABEL: vst1lanei8_update:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ldr r2, [r0]
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vst1.8 {d16[3]}, [r2]!
; CHECK-NEXT:    str r2, [r0]
; CHECK-NEXT:    mov pc, lr
	%A = load i8*, i8** %ptr
	%tmp1 = load <8 x i8>, <8 x i8>* %B
	%tmp2 = extractelement <8 x i8> %tmp1, i32 3
	store i8 %tmp2, i8* %A, align 8
	%tmp3 = getelementptr i8, i8* %A, i32 1
	store i8* %tmp3, i8** %ptr
	ret void
}

;Check the alignment value.  Max for this instruction is 16 bits:
define void @vst1lanei16(i16* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: vst1lanei16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vst1.16 {d16[2]}, [r0:16]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i16>, <4 x i16>* %B
	%tmp2 = extractelement <4 x i16> %tmp1, i32 2
	store i16 %tmp2, i16* %A, align 8
	ret void
}

;Check the alignment value.  Max for this instruction is 32 bits:
define void @vst1lanei32(i32* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: vst1lanei32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vst1.32 {d16[1]}, [r0:32]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, <2 x i32>* %B
	%tmp2 = extractelement <2 x i32> %tmp1, i32 1
	store i32 %tmp2, i32* %A, align 8
	ret void
}

define void @vst1lanef(float* %A, <2 x float>* %B) nounwind {
; CHECK-LABEL: vst1lanef:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vst1.32 {d16[1]}, [r0:32]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x float>, <2 x float>* %B
	%tmp2 = extractelement <2 x float> %tmp1, i32 1
	store float %tmp2, float* %A
	ret void
}

; // Can use scalar load. No need to use vectors.
; // CHE-CK: vst1.8 {d17[1]}, [r0]
define void @vst1laneQi8(i8* %A, <16 x i8>* %B) nounwind {
; CHECK-LABEL: vst1laneQi8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vst1.8 {d17[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <16 x i8>, <16 x i8>* %B
	%tmp2 = extractelement <16 x i8> %tmp1, i32 9
	store i8 %tmp2, i8* %A, align 8
	ret void
}

define void @vst1laneQi16(i16* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: vst1laneQi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vst1.16 {d17[1]}, [r0:16]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i16>, <8 x i16>* %B
	%tmp2 = extractelement <8 x i16> %tmp1, i32 5
	store i16 %tmp2, i16* %A, align 8
	ret void
}

; // Can use scalar load. No need to use vectors.
; // CHE-CK: vst1.32 {d17[1]}, [r0:32]
define void @vst1laneQi32(i32* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: vst1laneQi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ldr r1, [r1, #12]
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i32>, <4 x i32>* %B
	%tmp2 = extractelement <4 x i32> %tmp1, i32 3
	store i32 %tmp2, i32* %A, align 8
	ret void
}

;Check for a post-increment updating store.
; // Can use scalar load. No need to use vectors.
; // CHE-CK: vst1.32 {d17[1]}, [r1:32]!
define void @vst1laneQi32_update(i32** %ptr, <4 x i32>* %B) nounwind {
; CHECK-LABEL: vst1laneQi32_update:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ldr r2, [r0]
; CHECK-NEXT:    ldr r1, [r1, #12]
; CHECK-NEXT:    str r1, [r2], #4
; CHECK-NEXT:    str r2, [r0]
; CHECK-NEXT:    mov pc, lr
	%A = load i32*, i32** %ptr
	%tmp1 = load <4 x i32>, <4 x i32>* %B
	%tmp2 = extractelement <4 x i32> %tmp1, i32 3
	store i32 %tmp2, i32* %A, align 8
	%tmp3 = getelementptr i32, i32* %A, i32 1
	store i32* %tmp3, i32** %ptr
	ret void
}

; // Can use scalar load. No need to use vectors.
; // CHE-CK: vst1.32 {d17[1]}, [r0]
define void @vst1laneQf(float* %A, <4 x float>* %B) nounwind {
; CHECK-LABEL: vst1laneQf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ldr r1, [r1, #12]
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x float>, <4 x float>* %B
	%tmp2 = extractelement <4 x float> %tmp1, i32 3
	store float %tmp2, float* %A
	ret void
}

;Check the alignment value.  Max for this instruction is 16 bits:
define void @vst2lanei8(i8* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: vst2lanei8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vst2.8 {d16[1], d17[1]}, [r0:16]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i8>, <8 x i8>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v8i8(i8* %A, <8 x i8> %tmp1, <8 x i8> %tmp1, i32 1, i32 4)
	ret void
}

;Check the alignment value.  Max for this instruction is 32 bits:
define void @vst2lanei16(i16* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: vst2lanei16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vst2.16 {d16[1], d17[1]}, [r0:32]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i16* %A to i8*
	%tmp1 = load <4 x i16>, <4 x i16>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v4i16(i8* %tmp0, <4 x i16> %tmp1, <4 x i16> %tmp1, i32 1, i32 8)
	ret void
}

;Check for a post-increment updating store with register increment.
define void @vst2lanei16_update(i16** %ptr, <4 x i16>* %B, i32 %inc) nounwind {
; CHECK-LABEL: vst2lanei16_update:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    lsl r1, r2, #1
; CHECK-NEXT:    ldr r3, [r0]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vst2.16 {d16[1], d17[1]}, [r3], r1
; CHECK-NEXT:    str r3, [r0]
; CHECK-NEXT:    mov pc, lr
	%A = load i16*, i16** %ptr
	%tmp0 = bitcast i16* %A to i8*
	%tmp1 = load <4 x i16>, <4 x i16>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v4i16(i8* %tmp0, <4 x i16> %tmp1, <4 x i16> %tmp1, i32 1, i32 2)
	%tmp2 = getelementptr i16, i16* %A, i32 %inc
	store i16* %tmp2, i16** %ptr
	ret void
}

define void @vst2lanei32(i32* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: vst2lanei32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vst2.32 {d16[1], d17[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i32* %A to i8*
	%tmp1 = load <2 x i32>, <2 x i32>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v2i32(i8* %tmp0, <2 x i32> %tmp1, <2 x i32> %tmp1, i32 1, i32 1)
	ret void
}

define void @vst2lanef(float* %A, <2 x float>* %B) nounwind {
; CHECK-LABEL: vst2lanef:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vst2.32 {d16[1], d17[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast float* %A to i8*
	%tmp1 = load <2 x float>, <2 x float>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v2f32(i8* %tmp0, <2 x float> %tmp1, <2 x float> %tmp1, i32 1, i32 1)
	ret void
}

;Check the (default) alignment.
define void @vst2laneQi16(i16* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: vst2laneQi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vst2.16 {d17[1], d19[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i16* %A to i8*
	%tmp1 = load <8 x i16>, <8 x i16>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v8i16(i8* %tmp0, <8 x i16> %tmp1, <8 x i16> %tmp1, i32 5, i32 1)
	ret void
}

;Check the alignment value.  Max for this instruction is 64 bits:
define void @vst2laneQi32(i32* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: vst2laneQi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vst2.32 {d17[0], d19[0]}, [r0:64]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i32* %A to i8*
	%tmp1 = load <4 x i32>, <4 x i32>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v4i32(i8* %tmp0, <4 x i32> %tmp1, <4 x i32> %tmp1, i32 2, i32 16)
	ret void
}

define void @vst2laneQf(float* %A, <4 x float>* %B) nounwind {
; CHECK-LABEL: vst2laneQf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vst2.32 {d17[1], d19[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast float* %A to i8*
	%tmp1 = load <4 x float>, <4 x float>* %B
	call void @llvm.arm.neon.vst2lane.p0i8.v4f32(i8* %tmp0, <4 x float> %tmp1, <4 x float> %tmp1, i32 3, i32 1)
	ret void
}

declare void @llvm.arm.neon.vst2lane.p0i8.v8i8(i8*, <8 x i8>, <8 x i8>, i32, i32) nounwind
declare void @llvm.arm.neon.vst2lane.p0i8.v4i16(i8*, <4 x i16>, <4 x i16>, i32, i32) nounwind
declare void @llvm.arm.neon.vst2lane.p0i8.v2i32(i8*, <2 x i32>, <2 x i32>, i32, i32) nounwind
declare void @llvm.arm.neon.vst2lane.p0i8.v2f32(i8*, <2 x float>, <2 x float>, i32, i32) nounwind

declare void @llvm.arm.neon.vst2lane.p0i8.v8i16(i8*, <8 x i16>, <8 x i16>, i32, i32) nounwind
declare void @llvm.arm.neon.vst2lane.p0i8.v4i32(i8*, <4 x i32>, <4 x i32>, i32, i32) nounwind
declare void @llvm.arm.neon.vst2lane.p0i8.v4f32(i8*, <4 x float>, <4 x float>, i32, i32) nounwind

define void @vst3lanei8(i8* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: vst3lanei8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vst3.8 {d16[1], d17[1], d18[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i8>, <8 x i8>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v8i8(i8* %A, <8 x i8> %tmp1, <8 x i8> %tmp1, <8 x i8> %tmp1, i32 1, i32 1)
	ret void
}

;Check the (default) alignment value.  VST3 does not support alignment.
define void @vst3lanei16(i16* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: vst3lanei16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vst3.16 {d16[1], d17[1], d18[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i16* %A to i8*
	%tmp1 = load <4 x i16>, <4 x i16>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v4i16(i8* %tmp0, <4 x i16> %tmp1, <4 x i16> %tmp1, <4 x i16> %tmp1, i32 1, i32 8)
	ret void
}

define void @vst3lanei32(i32* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: vst3lanei32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vst3.32 {d16[1], d17[1], d18[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i32* %A to i8*
	%tmp1 = load <2 x i32>, <2 x i32>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v2i32(i8* %tmp0, <2 x i32> %tmp1, <2 x i32> %tmp1, <2 x i32> %tmp1, i32 1, i32 1)
	ret void
}

define void @vst3lanef(float* %A, <2 x float>* %B) nounwind {
; CHECK-LABEL: vst3lanef:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vst3.32 {d16[1], d17[1], d18[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast float* %A to i8*
	%tmp1 = load <2 x float>, <2 x float>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v2f32(i8* %tmp0, <2 x float> %tmp1, <2 x float> %tmp1, <2 x float> %tmp1, i32 1, i32 1)
	ret void
}

define void @vst3laneQi16(i16* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: vst3laneQi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vorr q10, q8, q8
; CHECK-NEXT:    vst3.16 {d17[2], d19[2], d21[2]}, [r0]
; CHECK-NEXT:    mov pc, lr
;Check the (default) alignment value.  VST3 does not support alignment.
	%tmp0 = bitcast i16* %A to i8*
	%tmp1 = load <8 x i16>, <8 x i16>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v8i16(i8* %tmp0, <8 x i16> %tmp1, <8 x i16> %tmp1, <8 x i16> %tmp1, i32 6, i32 8)
	ret void
}

define void @vst3laneQi32(i32* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: vst3laneQi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vorr q10, q8, q8
; CHECK-NEXT:    vst3.32 {d16[0], d18[0], d20[0]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i32* %A to i8*
	%tmp1 = load <4 x i32>, <4 x i32>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v4i32(i8* %tmp0, <4 x i32> %tmp1, <4 x i32> %tmp1, <4 x i32> %tmp1, i32 0, i32 1)
	ret void
}

;Check for a post-increment updating store.
define void @vst3laneQi32_update(i32** %ptr, <4 x i32>* %B) nounwind {
; CHECK-LABEL: vst3laneQi32_update:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    ldr r2, [r0]
; CHECK-NEXT:    vorr q10, q8, q8
; CHECK-NEXT:    vst3.32 {d16[0], d18[0], d20[0]}, [r2]!
; CHECK-NEXT:    str r2, [r0]
; CHECK-NEXT:    mov pc, lr
	%A = load i32*, i32** %ptr
	%tmp0 = bitcast i32* %A to i8*
	%tmp1 = load <4 x i32>, <4 x i32>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v4i32(i8* %tmp0, <4 x i32> %tmp1, <4 x i32> %tmp1, <4 x i32> %tmp1, i32 0, i32 1)
	%tmp2 = getelementptr i32, i32* %A, i32 3
	store i32* %tmp2, i32** %ptr
	ret void
}

define void @vst3laneQf(float* %A, <4 x float>* %B) nounwind {
; CHECK-LABEL: vst3laneQf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vorr q10, q8, q8
; CHECK-NEXT:    vst3.32 {d16[1], d18[1], d20[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast float* %A to i8*
	%tmp1 = load <4 x float>, <4 x float>* %B
	call void @llvm.arm.neon.vst3lane.p0i8.v4f32(i8* %tmp0, <4 x float> %tmp1, <4 x float> %tmp1, <4 x float> %tmp1, i32 1, i32 1)
	ret void
}

declare void @llvm.arm.neon.vst3lane.p0i8.v8i8(i8*, <8 x i8>, <8 x i8>, <8 x i8>, i32, i32) nounwind
declare void @llvm.arm.neon.vst3lane.p0i8.v4i16(i8*, <4 x i16>, <4 x i16>, <4 x i16>, i32, i32) nounwind
declare void @llvm.arm.neon.vst3lane.p0i8.v2i32(i8*, <2 x i32>, <2 x i32>, <2 x i32>, i32, i32) nounwind
declare void @llvm.arm.neon.vst3lane.p0i8.v2f32(i8*, <2 x float>, <2 x float>, <2 x float>, i32, i32) nounwind

declare void @llvm.arm.neon.vst3lane.p0i8.v8i16(i8*, <8 x i16>, <8 x i16>, <8 x i16>, i32, i32) nounwind
declare void @llvm.arm.neon.vst3lane.p0i8.v4i32(i8*, <4 x i32>, <4 x i32>, <4 x i32>, i32, i32) nounwind
declare void @llvm.arm.neon.vst3lane.p0i8.v4f32(i8*, <4 x float>, <4 x float>, <4 x float>, i32, i32) nounwind


;Check the alignment value.  Max for this instruction is 32 bits:
define void @vst4lanei8(i8* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: vst4lanei8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vorr d19, d16, d16
; CHECK-NEXT:    vst4.8 {d16[1], d17[1], d18[1], d19[1]}, [r0:32]
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i8>, <8 x i8>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v8i8(i8* %A, <8 x i8> %tmp1, <8 x i8> %tmp1, <8 x i8> %tmp1, <8 x i8> %tmp1, i32 1, i32 8)
	ret void
}

;Check for a post-increment updating store.
define void @vst4lanei8_update(i8** %ptr, <8 x i8>* %B) nounwind {
; CHECK-LABEL: vst4lanei8_update:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    ldr r2, [r0]
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vorr d19, d16, d16
; CHECK-NEXT:    vst4.8 {d16[1], d17[1], d18[1], d19[1]}, [r2:32]!
; CHECK-NEXT:    str r2, [r0]
; CHECK-NEXT:    mov pc, lr
	%A = load i8*, i8** %ptr
	%tmp1 = load <8 x i8>, <8 x i8>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v8i8(i8* %A, <8 x i8> %tmp1, <8 x i8> %tmp1, <8 x i8> %tmp1, <8 x i8> %tmp1, i32 1, i32 8)
	%tmp2 = getelementptr i8, i8* %A, i32 4
	store i8* %tmp2, i8** %ptr
	ret void
}

define void @vst4lanei16(i16* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: vst4lanei16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vorr d19, d16, d16
; CHECK-NEXT:    vst4.16 {d16[1], d17[1], d18[1], d19[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i16* %A to i8*
	%tmp1 = load <4 x i16>, <4 x i16>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v4i16(i8* %tmp0, <4 x i16> %tmp1, <4 x i16> %tmp1, <4 x i16> %tmp1, <4 x i16> %tmp1, i32 1, i32 1)
	ret void
}

;Check the alignment value.  Max for this instruction is 128 bits:
define void @vst4lanei32(i32* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: vst4lanei32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vorr d19, d16, d16
; CHECK-NEXT:    vst4.32 {d16[1], d17[1], d18[1], d19[1]}, [r0:128]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i32* %A to i8*
	%tmp1 = load <2 x i32>, <2 x i32>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v2i32(i8* %tmp0, <2 x i32> %tmp1, <2 x i32> %tmp1, <2 x i32> %tmp1, <2 x i32> %tmp1, i32 1, i32 16)
	ret void
}

define void @vst4lanef(float* %A, <2 x float>* %B) nounwind {
; CHECK-LABEL: vst4lanef:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vorr d19, d16, d16
; CHECK-NEXT:    vst4.32 {d16[1], d17[1], d18[1], d19[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast float* %A to i8*
	%tmp1 = load <2 x float>, <2 x float>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v2f32(i8* %tmp0, <2 x float> %tmp1, <2 x float> %tmp1, <2 x float> %tmp1, <2 x float> %tmp1, i32 1, i32 1)
	ret void
}

;Check the alignment value.  Max for this instruction is 64 bits:
define void @vst4laneQi16(i16* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: vst4laneQi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vorr q10, q8, q8
; CHECK-NEXT:    vorr q11, q8, q8
; CHECK-NEXT:    vst4.16 {d17[3], d19[3], d21[3], d23[3]}, [r0:64]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i16* %A to i8*
	%tmp1 = load <8 x i16>, <8 x i16>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v8i16(i8* %tmp0, <8 x i16> %tmp1, <8 x i16> %tmp1, <8 x i16> %tmp1, <8 x i16> %tmp1, i32 7, i32 16)
	ret void
}

;Check the (default) alignment.
define void @vst4laneQi32(i32* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: vst4laneQi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vorr q10, q8, q8
; CHECK-NEXT:    vorr q11, q8, q8
; CHECK-NEXT:    vst4.32 {d17[0], d19[0], d21[0], d23[0]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast i32* %A to i8*
	%tmp1 = load <4 x i32>, <4 x i32>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v4i32(i8* %tmp0, <4 x i32> %tmp1, <4 x i32> %tmp1, <4 x i32> %tmp1, <4 x i32> %tmp1, i32 2, i32 1)
	ret void
}

define void @vst4laneQf(float* %A, <4 x float>* %B) nounwind {
; CHECK-LABEL: vst4laneQf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vorr q9, q8, q8
; CHECK-NEXT:    vorr q10, q8, q8
; CHECK-NEXT:    vorr q11, q8, q8
; CHECK-NEXT:    vst4.32 {d16[1], d18[1], d20[1], d22[1]}, [r0]
; CHECK-NEXT:    mov pc, lr
	%tmp0 = bitcast float* %A to i8*
	%tmp1 = load <4 x float>, <4 x float>* %B
	call void @llvm.arm.neon.vst4lane.p0i8.v4f32(i8* %tmp0, <4 x float> %tmp1, <4 x float> %tmp1, <4 x float> %tmp1, <4 x float> %tmp1, i32 1, i32 1)
	ret void
}

; Make sure this doesn't crash; PR10258
define <8 x i16> @variable_insertelement(<8 x i16> %a, i16 %b, i32 %c) nounwind readnone {
; CHECK-LABEL: variable_insertelement:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    mov r11, sp
; CHECK-NEXT:    sub sp, sp, #24
; CHECK-NEXT:    bic sp, sp, #15
; CHECK-NEXT:    ldr lr, [r11, #12]
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    mov r1, sp
; CHECK-NEXT:    and r0, lr, #7
; CHECK-NEXT:    mov r2, r1
; CHECK-NEXT:    ldrh r12, [r11, #8]
; CHECK-NEXT:    lsl r0, r0, #1
; CHECK-NEXT:    vst1.64 {d16, d17}, [r2:128], r0
; CHECK-NEXT:    strh r12, [r2]
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1:128]
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov sp, r11
; CHECK-NEXT:    pop {r11, lr}
; CHECK-NEXT:    mov pc, lr
    %r = insertelement <8 x i16> %a, i16 %b, i32 %c
    ret <8 x i16> %r
}

declare void @llvm.arm.neon.vst4lane.p0i8.v8i8(i8*, <8 x i8>, <8 x i8>, <8 x i8>, <8 x i8>, i32, i32) nounwind
declare void @llvm.arm.neon.vst4lane.p0i8.v4i16(i8*, <4 x i16>, <4 x i16>, <4 x i16>, <4 x i16>, i32, i32) nounwind
declare void @llvm.arm.neon.vst4lane.p0i8.v2i32(i8*, <2 x i32>, <2 x i32>, <2 x i32>, <2 x i32>, i32, i32) nounwind
declare void @llvm.arm.neon.vst4lane.p0i8.v2f32(i8*, <2 x float>, <2 x float>, <2 x float>, <2 x float>, i32, i32) nounwind

declare void @llvm.arm.neon.vst4lane.p0i8.v8i16(i8*, <8 x i16>, <8 x i16>, <8 x i16>, <8 x i16>, i32, i32) nounwind
declare void @llvm.arm.neon.vst4lane.p0i8.v4i32(i8*, <4 x i32>, <4 x i32>, <4 x i32>, <4 x i32>, i32, i32) nounwind
declare void @llvm.arm.neon.vst4lane.p0i8.v4f32(i8*, <4 x float>, <4 x float>, <4 x float>, <4 x float>, i32, i32) nounwind
