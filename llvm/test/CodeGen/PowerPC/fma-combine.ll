; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -enable-no-signed-zeros-fp-math \
; RUN:     -enable-unsafe-fp-math  < %s | FileCheck -check-prefix=CHECK-FAST %s
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -enable-no-signed-zeros-fp-math \
; RUN:     -enable-unsafe-fp-math -mattr=-vsx < %s | FileCheck -check-prefix=CHECK-FAST-NOVSX %s
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s

define double @fma_combine1(double %a, double %b, double %c) {
; CHECK-FAST-LABEL: fma_combine1:
; CHECK-FAST:       # %bb.0: # %entry
; CHECK-FAST-NEXT:    xsnmaddadp 1, 3, 2
; CHECK-FAST-NEXT:    blr
;
; CHECK-FAST-NOVSX-LABEL: fma_combine1:
; CHECK-FAST-NOVSX:       # %bb.0: # %entry
; CHECK-FAST-NOVSX-NEXT:    fnmadd 1, 3, 2, 1
; CHECK-FAST-NOVSX-NEXT:    blr
;
; CHECK-LABEL: fma_combine1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnegdp 0, 3
; CHECK-NEXT:    xsmuldp 0, 0, 2
; CHECK-NEXT:    xssubdp 1, 0, 1
; CHECK-NEXT:    blr
entry:
  %fneg1 = fneg double %c
  %mul = fmul double %fneg1, %b
  %add = fsub double %mul, %a
  ret double %add
}

define double @fma_combine2(double %a, double %b, double %c) {
; CHECK-FAST-LABEL: fma_combine2:
; CHECK-FAST:       # %bb.0: # %entry
; CHECK-FAST-NEXT:    xsnmaddadp 1, 2, 3
; CHECK-FAST-NEXT:    blr
;
; CHECK-FAST-NOVSX-LABEL: fma_combine2:
; CHECK-FAST-NOVSX:       # %bb.0: # %entry
; CHECK-FAST-NOVSX-NEXT:    fnmadd 1, 2, 3, 1
; CHECK-FAST-NOVSX-NEXT:    blr
;
; CHECK-LABEL: fma_combine2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnegdp 0, 3
; CHECK-NEXT:    xsmuldp 0, 2, 0
; CHECK-NEXT:    xssubdp 1, 0, 1
; CHECK-NEXT:    blr
entry:
  %fneg1 = fneg double %c
  %mul = fmul double %b, %fneg1
  %add = fsub double %mul, %a
  ret double %add
}

@v = common local_unnamed_addr global double 0.000000e+00, align 8
@z = common local_unnamed_addr global double 0.000000e+00, align 8
define double @fma_combine_two_uses(double %a, double %b, double %c) {
; CHECK-FAST-LABEL: fma_combine_two_uses:
; CHECK-FAST:       # %bb.0: # %entry
; CHECK-FAST-NEXT:    xsnegdp 0, 1
; CHECK-FAST-NEXT:    addis 3, 2, v@toc@ha
; CHECK-FAST-NEXT:    addis 4, 2, z@toc@ha
; CHECK-FAST-NEXT:    xsnmaddadp 1, 3, 2
; CHECK-FAST-NEXT:    xsnegdp 2, 3
; CHECK-FAST-NEXT:    stfd 0, v@toc@l(3)
; CHECK-FAST-NEXT:    stfd 2, z@toc@l(4)
; CHECK-FAST-NEXT:    blr
;
; CHECK-FAST-NOVSX-LABEL: fma_combine_two_uses:
; CHECK-FAST-NOVSX:       # %bb.0: # %entry
; CHECK-FAST-NOVSX-NEXT:    fnmadd 0, 3, 2, 1
; CHECK-FAST-NOVSX-NEXT:    fneg 2, 1
; CHECK-FAST-NOVSX-NEXT:    addis 3, 2, v@toc@ha
; CHECK-FAST-NOVSX-NEXT:    addis 4, 2, z@toc@ha
; CHECK-FAST-NOVSX-NEXT:    fneg 3, 3
; CHECK-FAST-NOVSX-NEXT:    fmr 1, 0
; CHECK-FAST-NOVSX-NEXT:    stfd 2, v@toc@l(3)
; CHECK-FAST-NOVSX-NEXT:    stfd 3, z@toc@l(4)
; CHECK-FAST-NOVSX-NEXT:    blr
;
; CHECK-LABEL: fma_combine_two_uses:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnegdp 3, 3
; CHECK-NEXT:    addis 3, 2, v@toc@ha
; CHECK-NEXT:    addis 4, 2, z@toc@ha
; CHECK-NEXT:    xsmuldp 0, 3, 2
; CHECK-NEXT:    stfd 3, z@toc@l(4)
; CHECK-NEXT:    xsnegdp 2, 1
; CHECK-NEXT:    xssubdp 0, 0, 1
; CHECK-NEXT:    stfd 2, v@toc@l(3)
; CHECK-NEXT:    fmr 1, 0
; CHECK-NEXT:    blr
entry:
  %fneg = fneg double %a
  store double %fneg, double* @v, align 8
  %fneg1 = fneg double %c
  store double %fneg1, double* @z, align 8
  %mul = fmul double %fneg1, %b
  %add = fsub double %mul, %a
  ret double %add
}

define double @fma_combine_one_use(double %a, double %b, double %c) {
; CHECK-FAST-LABEL: fma_combine_one_use:
; CHECK-FAST:       # %bb.0: # %entry
; CHECK-FAST-NEXT:    xsnegdp 0, 1
; CHECK-FAST-NEXT:    addis 3, 2, v@toc@ha
; CHECK-FAST-NEXT:    xsnmaddadp 1, 3, 2
; CHECK-FAST-NEXT:    stfd 0, v@toc@l(3)
; CHECK-FAST-NEXT:    blr
;
; CHECK-FAST-NOVSX-LABEL: fma_combine_one_use:
; CHECK-FAST-NOVSX:       # %bb.0: # %entry
; CHECK-FAST-NOVSX-NEXT:    fnmadd 0, 3, 2, 1
; CHECK-FAST-NOVSX-NEXT:    fneg 2, 1
; CHECK-FAST-NOVSX-NEXT:    addis 3, 2, v@toc@ha
; CHECK-FAST-NOVSX-NEXT:    fmr 1, 0
; CHECK-FAST-NOVSX-NEXT:    stfd 2, v@toc@l(3)
; CHECK-FAST-NOVSX-NEXT:    blr
;
; CHECK-LABEL: fma_combine_one_use:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnegdp 0, 3
; CHECK-NEXT:    addis 3, 2, v@toc@ha
; CHECK-NEXT:    xsmuldp 0, 0, 2
; CHECK-NEXT:    xsnegdp 2, 1
; CHECK-NEXT:    xssubdp 0, 0, 1
; CHECK-NEXT:    stfd 2, v@toc@l(3)
; CHECK-NEXT:    fmr 1, 0
; CHECK-NEXT:    blr
entry:
  %fneg = fneg double %a
  store double %fneg, double* @v, align 8
  %fneg1 = fneg double %c
  %mul = fmul double %fneg1, %b
  %add = fsub double %mul, %a
  ret double %add
}
