; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

;; Testing that x18 is backed up and restored, and that x29 (if used) still
;; points to the x29,x30 pair on the stack.

; RUN: llc < %s -mtriple=aarch64-linux-gnu --frame-pointer=non-leaf | FileCheck %s
; RUN: llc < %s -mtriple=aarch64-linux-gnu --frame-pointer=non-leaf -mattr=+reserve-x18 | FileCheck %s

declare dso_local void @other()

define dso_local win64cc void @func() #0 {
; CHECK-LABEL: func:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    stp x29, x30, [sp, #-32]! // 16-byte Folded Spill
; CHECK-NEXT:    str x18, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    bl other
; CHECK-NEXT:    ldr x18, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    ldp x29, x30, [sp], #32 // 16-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  tail call void @other()
  ret void
}

attributes #0 = { nounwind }
