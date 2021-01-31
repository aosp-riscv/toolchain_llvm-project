; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc-unknown-linux-gnu < %s | FileCheck %s

declare float @fminf(float, float)
declare double @fmin(double, double)
declare ppc_fp128 @fminl(ppc_fp128, ppc_fp128)
declare float @llvm.minnum.f32(float, float)
declare double @llvm.minnum.f64(double, double)
declare ppc_fp128 @llvm.minnum.ppcf128(ppc_fp128, ppc_fp128)

declare <2 x float> @llvm.minnum.v2f32(<2 x float>, <2 x float>)
declare <4 x float> @llvm.minnum.v4f32(<4 x float>, <4 x float>)
declare <8 x float> @llvm.minnum.v8f32(<8 x float>, <8 x float>)

define float @test_fminf(float %x, float %y) {
; CHECK-LABEL: test_fminf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -16(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    lwz 0, 20(1)
; CHECK-NEXT:    addi 1, 1, 16
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call float @fminf(float %x, float %y) readnone
  ret float %z
}

define double @test_fmin(double %x, double %y) {
; CHECK-LABEL: test_fmin:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -16(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    bl fmin
; CHECK-NEXT:    lwz 0, 20(1)
; CHECK-NEXT:    addi 1, 1, 16
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call double @fmin(double %x, double %y) readnone
  ret double %z
}

define ppc_fp128 @test_fminl(ppc_fp128 %x, ppc_fp128 %y) {
; CHECK-LABEL: test_fminl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -112(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    stfd 1, 40(1)
; CHECK-NEXT:    lwz 3, 44(1)
; CHECK-NEXT:    stfd 2, 32(1)
; CHECK-NEXT:    stw 3, 60(1)
; CHECK-NEXT:    lwz 3, 40(1)
; CHECK-NEXT:    stfd 3, 72(1)
; CHECK-NEXT:    stw 3, 56(1)
; CHECK-NEXT:    lwz 3, 36(1)
; CHECK-NEXT:    stfd 4, 64(1)
; CHECK-NEXT:    stw 3, 52(1)
; CHECK-NEXT:    lwz 3, 32(1)
; CHECK-NEXT:    lfd 1, 56(1)
; CHECK-NEXT:    stw 3, 48(1)
; CHECK-NEXT:    lwz 3, 76(1)
; CHECK-NEXT:    lfd 2, 48(1)
; CHECK-NEXT:    stw 3, 92(1)
; CHECK-NEXT:    lwz 3, 72(1)
; CHECK-NEXT:    stw 3, 88(1)
; CHECK-NEXT:    lwz 3, 68(1)
; CHECK-NEXT:    lfd 3, 88(1)
; CHECK-NEXT:    stw 3, 84(1)
; CHECK-NEXT:    lwz 3, 64(1)
; CHECK-NEXT:    stw 3, 80(1)
; CHECK-NEXT:    lfd 4, 80(1)
; CHECK-NEXT:    bl fminl
; CHECK-NEXT:    stfd 1, 16(1)
; CHECK-NEXT:    lwz 3, 20(1)
; CHECK-NEXT:    stfd 2, 24(1)
; CHECK-NEXT:    stw 3, 108(1)
; CHECK-NEXT:    lwz 3, 16(1)
; CHECK-NEXT:    stw 3, 104(1)
; CHECK-NEXT:    lwz 3, 28(1)
; CHECK-NEXT:    lfd 1, 104(1)
; CHECK-NEXT:    stw 3, 100(1)
; CHECK-NEXT:    lwz 3, 24(1)
; CHECK-NEXT:    stw 3, 96(1)
; CHECK-NEXT:    lfd 2, 96(1)
; CHECK-NEXT:    lwz 0, 116(1)
; CHECK-NEXT:    addi 1, 1, 112
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call ppc_fp128 @fminl(ppc_fp128 %x, ppc_fp128 %y) readnone
  ret ppc_fp128 %z
}

define float @test_intrinsic_fmin_f32(float %x, float %y) {
; CHECK-LABEL: test_intrinsic_fmin_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -16(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    lwz 0, 20(1)
; CHECK-NEXT:    addi 1, 1, 16
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call float @llvm.minnum.f32(float %x, float %y) readnone
  ret float %z
}

define double @test_intrinsic_fmin_f64(double %x, double %y) {
; CHECK-LABEL: test_intrinsic_fmin_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -16(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    bl fmin
; CHECK-NEXT:    lwz 0, 20(1)
; CHECK-NEXT:    addi 1, 1, 16
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call double @llvm.minnum.f64(double %x, double %y) readnone
  ret double %z
}

define ppc_fp128 @test_intrinsic_fmin_f128(ppc_fp128 %x, ppc_fp128 %y) {
; CHECK-LABEL: test_intrinsic_fmin_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -112(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    stfd 1, 40(1)
; CHECK-NEXT:    lwz 3, 44(1)
; CHECK-NEXT:    stfd 2, 32(1)
; CHECK-NEXT:    stw 3, 60(1)
; CHECK-NEXT:    lwz 3, 40(1)
; CHECK-NEXT:    stfd 3, 72(1)
; CHECK-NEXT:    stw 3, 56(1)
; CHECK-NEXT:    lwz 3, 36(1)
; CHECK-NEXT:    stfd 4, 64(1)
; CHECK-NEXT:    stw 3, 52(1)
; CHECK-NEXT:    lwz 3, 32(1)
; CHECK-NEXT:    lfd 1, 56(1)
; CHECK-NEXT:    stw 3, 48(1)
; CHECK-NEXT:    lwz 3, 76(1)
; CHECK-NEXT:    lfd 2, 48(1)
; CHECK-NEXT:    stw 3, 92(1)
; CHECK-NEXT:    lwz 3, 72(1)
; CHECK-NEXT:    stw 3, 88(1)
; CHECK-NEXT:    lwz 3, 68(1)
; CHECK-NEXT:    lfd 3, 88(1)
; CHECK-NEXT:    stw 3, 84(1)
; CHECK-NEXT:    lwz 3, 64(1)
; CHECK-NEXT:    stw 3, 80(1)
; CHECK-NEXT:    lfd 4, 80(1)
; CHECK-NEXT:    bl fminl
; CHECK-NEXT:    stfd 1, 16(1)
; CHECK-NEXT:    lwz 3, 20(1)
; CHECK-NEXT:    stfd 2, 24(1)
; CHECK-NEXT:    stw 3, 108(1)
; CHECK-NEXT:    lwz 3, 16(1)
; CHECK-NEXT:    stw 3, 104(1)
; CHECK-NEXT:    lwz 3, 28(1)
; CHECK-NEXT:    lfd 1, 104(1)
; CHECK-NEXT:    stw 3, 100(1)
; CHECK-NEXT:    lwz 3, 24(1)
; CHECK-NEXT:    stw 3, 96(1)
; CHECK-NEXT:    lfd 2, 96(1)
; CHECK-NEXT:    lwz 0, 116(1)
; CHECK-NEXT:    addi 1, 1, 112
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call ppc_fp128 @llvm.minnum.ppcf128(ppc_fp128 %x, ppc_fp128 %y) readnone
  ret ppc_fp128 %z
}

define <2 x float> @test_intrinsic_fminf_v2f32(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: test_intrinsic_fminf_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    .cfi_offset f29, -24
; CHECK-NEXT:    .cfi_offset f30, -16
; CHECK-NEXT:    .cfi_offset f31, -8
; CHECK-NEXT:    stfd 30, 16(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 30, 2
; CHECK-NEXT:    fmr 2, 3
; CHECK-NEXT:    stfd 29, 8(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 31, 24(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 31, 4
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 29, 1
; CHECK-NEXT:    fmr 1, 30
; CHECK-NEXT:    fmr 2, 31
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 2, 1
; CHECK-NEXT:    fmr 1, 29
; CHECK-NEXT:    lfd 31, 24(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 30, 16(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 29, 8(1) # 8-byte Folded Reload
; CHECK-NEXT:    lwz 0, 36(1)
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call <2 x float> @llvm.minnum.v2f32(<2 x float> %x, <2 x float> %y) readnone
  ret <2 x float> %z
}

define <4 x float> @test_intrinsic_fmin_v4f32(<4 x float> %x, <4 x float> %y) {
; CHECK-LABEL: test_intrinsic_fmin_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -64(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    .cfi_offset f25, -56
; CHECK-NEXT:    .cfi_offset f26, -48
; CHECK-NEXT:    .cfi_offset f27, -40
; CHECK-NEXT:    .cfi_offset f28, -32
; CHECK-NEXT:    .cfi_offset f29, -24
; CHECK-NEXT:    .cfi_offset f30, -16
; CHECK-NEXT:    .cfi_offset f31, -8
; CHECK-NEXT:    stfd 26, 16(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 26, 2
; CHECK-NEXT:    fmr 2, 5
; CHECK-NEXT:    stfd 25, 8(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 27, 24(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 27, 3
; CHECK-NEXT:    stfd 28, 32(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 28, 4
; CHECK-NEXT:    stfd 29, 40(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 29, 6
; CHECK-NEXT:    stfd 30, 48(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 30, 7
; CHECK-NEXT:    stfd 31, 56(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 31, 8
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 25, 1
; CHECK-NEXT:    fmr 1, 26
; CHECK-NEXT:    fmr 2, 29
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 29, 1
; CHECK-NEXT:    fmr 1, 27
; CHECK-NEXT:    fmr 2, 30
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 30, 1
; CHECK-NEXT:    fmr 1, 28
; CHECK-NEXT:    fmr 2, 31
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 4, 1
; CHECK-NEXT:    fmr 1, 25
; CHECK-NEXT:    fmr 2, 29
; CHECK-NEXT:    fmr 3, 30
; CHECK-NEXT:    lfd 31, 56(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 30, 48(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 29, 40(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 28, 32(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 27, 24(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 26, 16(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 25, 8(1) # 8-byte Folded Reload
; CHECK-NEXT:    lwz 0, 68(1)
; CHECK-NEXT:    addi 1, 1, 64
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call <4 x float> @llvm.minnum.v4f32(<4 x float> %x, <4 x float> %y) readnone
  ret <4 x float> %z
}

define <8 x float> @test_intrinsic_fmin_v8f32(<8 x float> %x, <8 x float> %y) {
; CHECK-LABEL: test_intrinsic_fmin_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -128(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 128
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    .cfi_offset f17, -120
; CHECK-NEXT:    .cfi_offset f18, -112
; CHECK-NEXT:    .cfi_offset f19, -104
; CHECK-NEXT:    .cfi_offset f20, -96
; CHECK-NEXT:    .cfi_offset f21, -88
; CHECK-NEXT:    .cfi_offset f22, -80
; CHECK-NEXT:    .cfi_offset f23, -72
; CHECK-NEXT:    .cfi_offset f24, -64
; CHECK-NEXT:    .cfi_offset f25, -56
; CHECK-NEXT:    .cfi_offset f26, -48
; CHECK-NEXT:    .cfi_offset f27, -40
; CHECK-NEXT:    .cfi_offset f28, -32
; CHECK-NEXT:    .cfi_offset f29, -24
; CHECK-NEXT:    .cfi_offset f30, -16
; CHECK-NEXT:    .cfi_offset f31, -8
; CHECK-NEXT:    stfd 25, 72(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 25, 2
; CHECK-NEXT:    lfs 2, 136(1)
; CHECK-NEXT:    stfd 17, 8(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 18, 16(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 19, 24(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 20, 32(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 21, 40(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 22, 48(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 23, 56(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 24, 64(1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd 26, 80(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 26, 3
; CHECK-NEXT:    stfd 27, 88(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 27, 4
; CHECK-NEXT:    stfd 28, 96(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 28, 5
; CHECK-NEXT:    stfd 29, 104(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 29, 6
; CHECK-NEXT:    stfd 30, 112(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 30, 7
; CHECK-NEXT:    stfd 31, 120(1) # 8-byte Folded Spill
; CHECK-NEXT:    fmr 31, 8
; CHECK-NEXT:    lfs 24, 192(1)
; CHECK-NEXT:    lfs 23, 184(1)
; CHECK-NEXT:    lfs 22, 176(1)
; CHECK-NEXT:    lfs 21, 168(1)
; CHECK-NEXT:    lfs 20, 160(1)
; CHECK-NEXT:    lfs 19, 152(1)
; CHECK-NEXT:    lfs 18, 144(1)
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 17, 1
; CHECK-NEXT:    fmr 1, 25
; CHECK-NEXT:    fmr 2, 18
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 25, 1
; CHECK-NEXT:    fmr 1, 26
; CHECK-NEXT:    fmr 2, 19
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 26, 1
; CHECK-NEXT:    fmr 1, 27
; CHECK-NEXT:    fmr 2, 20
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 27, 1
; CHECK-NEXT:    fmr 1, 28
; CHECK-NEXT:    fmr 2, 21
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 28, 1
; CHECK-NEXT:    fmr 1, 29
; CHECK-NEXT:    fmr 2, 22
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 29, 1
; CHECK-NEXT:    fmr 1, 30
; CHECK-NEXT:    fmr 2, 23
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 30, 1
; CHECK-NEXT:    fmr 1, 31
; CHECK-NEXT:    fmr 2, 24
; CHECK-NEXT:    bl fminf
; CHECK-NEXT:    fmr 8, 1
; CHECK-NEXT:    fmr 1, 17
; CHECK-NEXT:    fmr 2, 25
; CHECK-NEXT:    fmr 3, 26
; CHECK-NEXT:    fmr 4, 27
; CHECK-NEXT:    fmr 5, 28
; CHECK-NEXT:    fmr 6, 29
; CHECK-NEXT:    fmr 7, 30
; CHECK-NEXT:    lfd 31, 120(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 30, 112(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 29, 104(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 28, 96(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 27, 88(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 26, 80(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 25, 72(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 24, 64(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 23, 56(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 22, 48(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 21, 40(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 20, 32(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 19, 24(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 18, 16(1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd 17, 8(1) # 8-byte Folded Reload
; CHECK-NEXT:    lwz 0, 132(1)
; CHECK-NEXT:    addi 1, 1, 128
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %z = call <8 x float> @llvm.minnum.v8f32(<8 x float> %x, <8 x float> %y) readnone
  ret <8 x float> %z
}

define ppc_fp128 @fminnum_const(ppc_fp128 %0) {
; CHECK-LABEL: fminnum_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    stw 0, 4(1)
; CHECK-NEXT:    stwu 1, -96(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 96
; CHECK-NEXT:    .cfi_offset lr, 4
; CHECK-NEXT:    stfd 1, 40(1)
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    stw 3, 76(1)
; CHECK-NEXT:    lis 4, 16368
; CHECK-NEXT:    stw 3, 68(1)
; CHECK-NEXT:    stw 3, 64(1)
; CHECK-NEXT:    lwz 3, 44(1)
; CHECK-NEXT:    stfd 2, 32(1)
; CHECK-NEXT:    stw 3, 60(1)
; CHECK-NEXT:    lwz 3, 40(1)
; CHECK-NEXT:    stw 4, 72(1)
; CHECK-NEXT:    stw 3, 56(1)
; CHECK-NEXT:    lwz 3, 36(1)
; CHECK-NEXT:    lfd 3, 72(1)
; CHECK-NEXT:    stw 3, 52(1)
; CHECK-NEXT:    lwz 3, 32(1)
; CHECK-NEXT:    lfd 4, 64(1)
; CHECK-NEXT:    stw 3, 48(1)
; CHECK-NEXT:    lfd 1, 56(1)
; CHECK-NEXT:    lfd 2, 48(1)
; CHECK-NEXT:    bl fminl
; CHECK-NEXT:    stfd 1, 16(1)
; CHECK-NEXT:    lwz 3, 20(1)
; CHECK-NEXT:    stfd 2, 24(1)
; CHECK-NEXT:    stw 3, 92(1)
; CHECK-NEXT:    lwz 3, 16(1)
; CHECK-NEXT:    stw 3, 88(1)
; CHECK-NEXT:    lwz 3, 28(1)
; CHECK-NEXT:    lfd 1, 88(1)
; CHECK-NEXT:    stw 3, 84(1)
; CHECK-NEXT:    lwz 3, 24(1)
; CHECK-NEXT:    stw 3, 80(1)
; CHECK-NEXT:    lfd 2, 80(1)
; CHECK-NEXT:    lwz 0, 100(1)
; CHECK-NEXT:    addi 1, 1, 96
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %2 = tail call fast ppc_fp128 @llvm.minnum.ppcf128(ppc_fp128 %0, ppc_fp128 0xM3FF00000000000000000000000000000)
  ret ppc_fp128 %2
}

