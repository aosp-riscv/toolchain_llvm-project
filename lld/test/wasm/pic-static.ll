; Test that PIC code can be linked into static binaries.
; In this case the GOT entries will end up as internalized wasm globals with
; fixed values.
; RUN: llc -relocation-model=pic -filetype=obj %p/Inputs/ret32.ll -o %t.ret32.o
; RUN: llc -relocation-model=pic -filetype=obj %s -o %t.o
; RUN: wasm-ld -o %t.wasm %t.o %t.ret32.o
; RUN: obj2yaml %t.wasm | FileCheck %s

target triple = "wasm32-unknown-emscripten"

declare i32 @ret32(float)
@global_float = global float 1.0
@hidden_float = hidden global float 2.0

@ret32_ptr = global i32 (float)* @ret32, align 4

define i32 (float)* @getaddr_external() {
  ret i32 (float)* @ret32;
}

define i32 ()* @getaddr_hidden() {
  ret i32 ()* @hidden_func;
}

define hidden i32 @hidden_func() {
  ret i32 1
}

define void @_start() {
entry:
  %f = load float, float* @hidden_float, align 4
  %addr = load i32 (float)*, i32 (float)** @ret32_ptr, align 4
  %arg = load float, float* @global_float, align 4
  call i32 %addr(float %arg)

  %addr2 = call i32 (float)* @getaddr_external()
  %arg2 = load float, float* @hidden_float, align 4
  call i32 %addr2(float %arg2)

  %addr3 = call i32 ()* @getaddr_hidden()
  call i32 %addr3()

  ret void
}

; CHECK:        - Type:            GLOBAL
; CHECK-NEXT:     Globals:

; __stack_pointer
; CHECK-NEXT:       - Index:           0
; CHECK-NEXT:         Type:            I32
; CHECK-NEXT:         Mutable:         true
; CHECK-NEXT:         InitExpr:
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           66576

; GOT.func.ret32
; CHECK-NEXT:       - Index:           1
; CHECK-NEXT:         Type:            I32
; CHECK-NEXT:         Mutable:         false
; CHECK-NEXT:         InitExpr:
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           2

; __table_base
; CHECK-NEXT:       - Index:           2
; CHECK-NEXT:         Type:            I32
; CHECK-NEXT:         Mutable:         false
; CHECK-NEXT:         InitExpr:
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           1

; GOT.mem.global_float
; CHECK-NEXT:       - Index:           3
; CHECK-NEXT:         Type:            I32
; CHECK-NEXT:         Mutable:         false
; CHECK-NEXT:         InitExpr:
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           1024

; GOT.mem.ret32_ptr
; CHECK-NEXT:       - Index:           4
; CHECK-NEXT:         Type:            I32
; CHECK-NEXT:         Mutable:         false
; CHECK-NEXT:         InitExpr:
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           1032

; __memory_base
; CHECK-NEXT:       - Index:           5
; CHECK-NEXT:         Type:            I32
; CHECK-NEXT:         Mutable:         false
; CHECK-NEXT:         InitExpr:
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           1024
