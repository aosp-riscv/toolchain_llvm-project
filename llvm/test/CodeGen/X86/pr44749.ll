; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx10.15.0 -O0 | FileCheck %s

define i32 @a() {
; CHECK-LABEL: a:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    ## kill: def $al killed $al killed $eax
; CHECK-NEXT:    movsd %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movsd %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    callq _b
; CHECK-NEXT:    cvtsi2sd %eax, %xmm0
; CHECK-NEXT:    movq _calloc@{{.*}}(%rip), %rcx
; CHECK-NEXT:    subq $-1, %rcx
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    xorps %xmm2, %xmm2
; CHECK-NEXT:    movsd %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movsd %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movsd %xmm1, (%rsp) ## 8-byte Spill
; CHECK-NEXT:    jne LBB0_2
; CHECK-NEXT:  ## %bb.1: ## %entry
; CHECK-NEXT:    movsd {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 8-byte Reload
; CHECK-NEXT:    ## xmm0 = mem[0],zero
; CHECK-NEXT:    movsd %xmm0, (%rsp) ## 8-byte Spill
; CHECK-NEXT:  LBB0_2: ## %entry
; CHECK-NEXT:    movsd (%rsp), %xmm0 ## 8-byte Reload
; CHECK-NEXT:    ## xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    addsd %xmm1, %xmm0
; CHECK-NEXT:    movsd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 8-byte Reload
; CHECK-NEXT:    ## xmm1 = mem[0],zero
; CHECK-NEXT:    ucomisd %xmm0, %xmm1
; CHECK-NEXT:    setae %al
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movl %ecx, %edx
; CHECK-NEXT:    leaq {{.*}}(%rip), %rsi
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    cvttsd2si %xmm0, %eax
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    retq
entry:
  %call = call i32 (...) @b()
  %conv = sitofp i32 %call to double
  %cmp = fcmp ole double fsub (double sitofp (i32 select (i1 icmp ne (i8* (i64, i64)* bitcast (i8* getelementptr (i8, i8* bitcast (i8* (i64, i64)* @calloc to i8*), i64 1) to i8* (i64, i64)*), i8* (i64, i64)* null), i32 1, i32 0) to double), double 1.000000e+02), %conv
  %cond = select i1 %cmp, double 1.000000e+00, double 3.140000e+00
  %conv2 = fptosi double %cond to i32
  ret i32 %conv2
}

declare i8* @calloc(i64, i64)

declare i32 @b(...)
