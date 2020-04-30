; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define void @f() {
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@f()
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    [[A:%.*]] = alloca i32, align 1
; IS__TUNIT_OPM-NEXT:    call void @g(i32* noalias nocapture nonnull readonly dereferenceable(4) [[A]])
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@f()
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    [[A:%.*]] = alloca i32, align 1
; IS__TUNIT_NPM-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 1
; IS__TUNIT_NPM-NEXT:    call void @g(i32 [[TMP0]])
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@f()
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[A:%.*]] = alloca i32, align 1
; IS__CGSCC____-NEXT:    call void @g(i32* noalias nonnull readonly dereferenceable(4) [[A]])
; IS__CGSCC____-NEXT:    ret void
;
entry:
  %a = alloca i32, align 1
  call void @g(i32* %a)
  ret void
}

define internal void @g(i32* %a) {
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@g
; IS__TUNIT_OPM-SAME: (i32* noalias nocapture nonnull readonly dereferenceable(4) [[A:%.*]])
; IS__TUNIT_OPM-NEXT:    [[AA:%.*]] = load i32, i32* [[A]], align 1
; IS__TUNIT_OPM-NEXT:    call void @z(i32 [[AA]])
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@g
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]])
; IS__TUNIT_NPM-NEXT:    [[A_PRIV:%.*]] = alloca i32
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[A_PRIV]]
; IS__TUNIT_NPM-NEXT:    [[AA:%.*]] = load i32, i32* [[A_PRIV]], align 1
; IS__TUNIT_NPM-NEXT:    call void @z(i32 [[AA]])
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@g
; IS__CGSCC____-SAME: (i32* nocapture nonnull readonly dereferenceable(4) [[A:%.*]])
; IS__CGSCC____-NEXT:    [[AA:%.*]] = load i32, i32* [[A]], align 1
; IS__CGSCC____-NEXT:    call void @z(i32 [[AA]])
; IS__CGSCC____-NEXT:    ret void
;
  %aa = load i32, i32* %a, align 1
  call void @z(i32 %aa)
  ret void
}

declare void @z(i32)
