; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define i128 @__addvti3() {
; CHECK-LABEL: __addvti3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq $-1, %rax
; CHECK-NEXT:    movq $-1, %rdx
; CHECK-NEXT:    retq
          ret i128 -1
}
