; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -mattr=-unaligned-access-mode < %s | FileCheck -check-prefixes=GCN,GFX900 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -mattr=-unaligned-access-mode -amdgpu-enable-flat-scratch < %s | FileCheck -check-prefixes=GCN,FLATSCR %s

define <2 x half> @chain_hi_to_lo_private() {
; GFX900-LABEL: chain_hi_to_lo_private:
; GFX900:       ; %bb.0: ; %bb
; GFX900-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX900-NEXT:    buffer_load_ushort v0, off, s[0:3], 0 offset:2
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_load_short_d16_hi v0, off, s[0:3], 0
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: chain_hi_to_lo_private:
; FLATSCR:       ; %bb.0: ; %bb
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    s_mov_b32 s0, 2
; FLATSCR-NEXT:    scratch_load_ushort v0, off, s0
; FLATSCR-NEXT:    s_mov_b32 s0, 0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_load_short_d16_hi v0, off, s0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds half, half addrspace(5)* null, i64 1
  %load_lo = load half, half addrspace(5)* %gep_lo
  %gep_hi = getelementptr inbounds half, half addrspace(5)* null, i64 0
  %load_hi = load half, half addrspace(5)* %gep_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_private_different_bases(half addrspace(5)* %base_lo, half addrspace(5)* %base_hi) {
; GFX900-LABEL: chain_hi_to_lo_private_different_bases:
; GFX900:       ; %bb.0: ; %bb
; GFX900-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX900-NEXT:    buffer_load_ushort v0, v0, s[0:3], 0 offen
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_load_short_d16_hi v0, v1, s[0:3], 0 offen
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: chain_hi_to_lo_private_different_bases:
; FLATSCR:       ; %bb.0: ; %bb
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    scratch_load_ushort v0, v0, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_load_short_d16_hi v0, v1, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
bb:
  %load_lo = load half, half addrspace(5)* %base_lo
  %load_hi = load half, half addrspace(5)* %base_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_arithmatic(half addrspace(5)* %base, half %in) {
; GFX900-LABEL: chain_hi_to_lo_arithmatic:
; GFX900:       ; %bb.0: ; %bb
; GFX900-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX900-NEXT:    v_add_f16_e32 v1, 1.0, v1
; GFX900-NEXT:    buffer_load_short_d16_hi v1, v0, s[0:3], 0 offen
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v0, v1
; GFX900-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: chain_hi_to_lo_arithmatic:
; FLATSCR:       ; %bb.0: ; %bb
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    v_add_f16_e32 v1, 1.0, v1
; FLATSCR-NEXT:    scratch_load_short_d16_hi v1, v0, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_mov_b32_e32 v0, v1
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
bb:
  %arith_lo = fadd half %in, 1.0
  %load_hi = load half, half addrspace(5)* %base

  %temp = insertelement <2 x half> undef, half %arith_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_group() {
; GCN-LABEL: chain_hi_to_lo_group:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    ds_read_u16 v0, v1 offset:2
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_read_u16_d16_hi v0, v1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds half, half addrspace(3)* null, i64 1
  %load_lo = load half, half addrspace(3)* %gep_lo
  %gep_hi = getelementptr inbounds half, half addrspace(3)* null, i64 0
  %load_hi = load half, half addrspace(3)* %gep_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_group_different_bases(half addrspace(3)* %base_lo, half addrspace(3)* %base_hi) {
; GCN-LABEL: chain_hi_to_lo_group_different_bases:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    ds_read_u16 v0, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_read_u16_d16_hi v0, v1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %load_lo = load half, half addrspace(3)* %base_lo
  %load_hi = load half, half addrspace(3)* %base_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_global() {
; GCN-LABEL: chain_hi_to_lo_global:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, 2
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    global_load_ushort v0, v[0:1], off
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    global_load_short_d16_hi v0, v[1:2], off
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds half, half addrspace(1)* null, i64 1
  %load_lo = load half, half addrspace(1)* %gep_lo
  %gep_hi = getelementptr inbounds half, half addrspace(1)* null, i64 0
  %load_hi = load half, half addrspace(1)* %gep_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_global_different_bases(half addrspace(1)* %base_lo, half addrspace(1)* %base_hi) {
; GCN-LABEL: chain_hi_to_lo_global_different_bases:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    global_load_ushort v0, v[0:1], off
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    global_load_short_d16_hi v0, v[2:3], off
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %load_lo = load half, half addrspace(1)* %base_lo
  %load_hi = load half, half addrspace(1)* %base_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_flat() {
; GCN-LABEL: chain_hi_to_lo_flat:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, 2
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    flat_load_ushort v0, v[0:1]
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    flat_load_short_d16_hi v0, v[1:2]
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds half, half* null, i64 1
  %load_lo = load half, half* %gep_lo
  %gep_hi = getelementptr inbounds half, half* null, i64 0
  %load_hi = load half, half* %gep_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

define <2 x half> @chain_hi_to_lo_flat_different_bases(half* %base_lo, half* %base_hi) {
; GCN-LABEL: chain_hi_to_lo_flat_different_bases:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    flat_load_ushort v0, v[0:1]
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    flat_load_short_d16_hi v0, v[2:3]
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %load_lo = load half, half* %base_lo
  %load_hi = load half, half* %base_hi

  %temp = insertelement <2 x half> undef, half %load_lo, i32 0
  %result = insertelement <2 x half> %temp, half %load_hi, i32 1

  ret <2 x half> %result
}

; Make sure we don't lose any of the private stores.
define amdgpu_kernel void @vload2_private(i16 addrspace(1)* nocapture readonly %in, <2 x i16> addrspace(1)* nocapture %out) #0 {
; GFX900-LABEL: vload2_private:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s6, s9
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GFX900-NEXT:    s_load_dwordx4 s[4:7], s[4:5], 0x0
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s9
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    global_load_ushort v0, v2, s[4:5]
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_store_short v0, off, s[0:3], 0 offset:4
; GFX900-NEXT:    global_load_ushort v0, v2, s[4:5] offset:2
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_store_short v0, off, s[0:3], 0 offset:6
; GFX900-NEXT:    global_load_ushort v0, v2, s[4:5] offset:4
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_store_short v0, off, s[0:3], 0 offset:8
; GFX900-NEXT:    buffer_load_ushort v0, off, s[0:3], 0 offset:4
; GFX900-NEXT:    buffer_load_ushort v3, off, s[0:3], 0 offset:6
; GFX900-NEXT:    s_waitcnt vmcnt(1)
; GFX900-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v1, v3
; GFX900-NEXT:    buffer_load_short_d16_hi v1, off, s[0:3], 0 offset:8
; GFX900-NEXT:    v_lshl_or_b32 v0, v3, 16, v0
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    global_store_dwordx2 v2, v[0:1], s[6:7]
; GFX900-NEXT:    s_endpgm
;
; FLATSCR-LABEL: vload2_private:
; FLATSCR:       ; %bb.0: ; %entry
; FLATSCR-NEXT:    s_add_u32 flat_scratch_lo, s2, s5
; FLATSCR-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; FLATSCR-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x0
; FLATSCR-NEXT:    v_mov_b32_e32 v2, 0
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    s_waitcnt lgkmcnt(0)
; FLATSCR-NEXT:    global_load_ushort v0, v2, s[0:1]
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_short off, v0, vcc_hi offset:4
; FLATSCR-NEXT:    global_load_ushort v0, v2, s[0:1] offset:2
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_short off, v0, vcc_hi offset:6
; FLATSCR-NEXT:    global_load_ushort v0, v2, s[0:1] offset:4
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_short off, v0, vcc_hi offset:8
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_load_ushort v0, off, vcc_hi offset:4
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_load_ushort v3, off, vcc_hi offset:6
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    s_waitcnt vmcnt(1)
; FLATSCR-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_mov_b32_e32 v1, v3
; FLATSCR-NEXT:    scratch_load_short_d16_hi v1, off, vcc_hi offset:8
; FLATSCR-NEXT:    v_lshl_or_b32 v0, v3, 16, v0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    global_store_dwordx2 v2, v[0:1], s[2:3]
; FLATSCR-NEXT:    s_endpgm
entry:
  %loc = alloca [3 x i16], align 2, addrspace(5)
  %loc.0.sroa_cast1 = bitcast [3 x i16] addrspace(5)* %loc to i8 addrspace(5)*
  %tmp = load i16, i16 addrspace(1)* %in, align 2
  %loc.0.sroa_idx = getelementptr inbounds [3 x i16], [3 x i16] addrspace(5)* %loc, i32 0, i32 0
  store volatile i16 %tmp, i16 addrspace(5)* %loc.0.sroa_idx
  %arrayidx.1 = getelementptr inbounds i16, i16 addrspace(1)* %in, i64 1
  %tmp1 = load i16, i16 addrspace(1)* %arrayidx.1, align 2
  %loc.2.sroa_idx3 = getelementptr inbounds [3 x i16], [3 x i16] addrspace(5)* %loc, i32 0, i32 1
  store volatile i16 %tmp1, i16 addrspace(5)* %loc.2.sroa_idx3
  %arrayidx.2 = getelementptr inbounds i16, i16 addrspace(1)* %in, i64 2
  %tmp2 = load i16, i16 addrspace(1)* %arrayidx.2, align 2
  %loc.4.sroa_idx = getelementptr inbounds [3 x i16], [3 x i16] addrspace(5)* %loc, i32 0, i32 2
  store volatile i16 %tmp2, i16 addrspace(5)* %loc.4.sroa_idx
  %loc.0.sroa_cast = bitcast [3 x i16] addrspace(5)* %loc to <2 x i16> addrspace(5)*
  %loc.0. = load <2 x i16>, <2 x i16> addrspace(5)* %loc.0.sroa_cast, align 2
  store <2 x i16> %loc.0., <2 x i16> addrspace(1)* %out, align 4
  %loc.2.sroa_idx = getelementptr inbounds [3 x i16], [3 x i16] addrspace(5)* %loc, i32 0, i32 1
  %loc.2.sroa_cast = bitcast i16 addrspace(5)* %loc.2.sroa_idx to <2 x i16> addrspace(5)*
  %loc.2. = load <2 x i16>, <2 x i16> addrspace(5)* %loc.2.sroa_cast, align 2
  %arrayidx6 = getelementptr inbounds <2 x i16>, <2 x i16> addrspace(1)* %out, i64 1
  store <2 x i16> %loc.2., <2 x i16> addrspace(1)* %arrayidx6, align 4
  %loc.0.sroa_cast2 = bitcast [3 x i16] addrspace(5)* %loc to i8 addrspace(5)*
  ret void
}

; There is another instruction between the misordered instruction and
; the value dependent load, so a simple operand check is insufficient.
define <2 x i16> @chain_hi_to_lo_group_other_dep(i16 addrspace(3)* %ptr) {
; GCN-LABEL: chain_hi_to_lo_group_other_dep:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    ds_read_u16_d16_hi v1, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_pk_sub_u16 v1, v1, -12 op_sel_hi:[1,0]
; GCN-NEXT:    ds_read_u16_d16 v1, v0 offset:2
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds i16, i16 addrspace(3)* %ptr, i64 1
  %load_lo = load i16, i16 addrspace(3)* %gep_lo
  %gep_hi = getelementptr inbounds i16, i16 addrspace(3)* %ptr, i64 0
  %load_hi = load i16, i16 addrspace(3)* %gep_hi
  %to.hi = insertelement <2 x i16> undef, i16 %load_hi, i32 1
  %op.hi = add <2 x i16> %to.hi, <i16 12, i16 12>
  %result = insertelement <2 x i16> %op.hi, i16 %load_lo, i32 0
  ret <2 x i16> %result
}

; The volatile operations aren't put on the same chain
define <2 x i16> @chain_hi_to_lo_group_other_dep_multi_chain(i16 addrspace(3)* %ptr) {
; GCN-LABEL: chain_hi_to_lo_group_other_dep_multi_chain:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    ds_read_u16 v1, v0 offset:2
; GCN-NEXT:    ds_read_u16_d16_hi v0, v0
; GCN-NEXT:    v_mov_b32_e32 v2, 0xffff
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_pk_sub_u16 v0, v0, -12 op_sel_hi:[1,0]
; GCN-NEXT:    v_bfi_b32 v0, v2, v1, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds i16, i16 addrspace(3)* %ptr, i64 1
  %load_lo = load volatile i16, i16 addrspace(3)* %gep_lo
  %gep_hi = getelementptr inbounds i16, i16 addrspace(3)* %ptr, i64 0
  %load_hi = load volatile i16, i16 addrspace(3)* %gep_hi
  %to.hi = insertelement <2 x i16> undef, i16 %load_hi, i32 1
  %op.hi = add <2 x i16> %to.hi, <i16 12, i16 12>
  %result = insertelement <2 x i16> %op.hi, i16 %load_lo, i32 0
  ret <2 x i16> %result
}

define <2 x i16> @chain_hi_to_lo_private_other_dep(i16 addrspace(5)* %ptr) {
; GFX900-LABEL: chain_hi_to_lo_private_other_dep:
; GFX900:       ; %bb.0: ; %bb
; GFX900-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX900-NEXT:    buffer_load_short_d16_hi v1, v0, s[0:3], 0 offen
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    v_pk_sub_u16 v1, v1, -12 op_sel_hi:[1,0]
; GFX900-NEXT:    buffer_load_short_d16 v1, v0, s[0:3], 0 offen offset:2
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v0, v1
; GFX900-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: chain_hi_to_lo_private_other_dep:
; FLATSCR:       ; %bb.0: ; %bb
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    scratch_load_short_d16_hi v1, v0, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_pk_sub_u16 v1, v1, -12 op_sel_hi:[1,0]
; FLATSCR-NEXT:    scratch_load_short_d16 v1, v0, off offset:2
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_mov_b32_e32 v0, v1
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds i16, i16 addrspace(5)* %ptr, i64 1
  %load_lo = load i16, i16 addrspace(5)* %gep_lo
  %gep_hi = getelementptr inbounds i16, i16 addrspace(5)* %ptr, i64 0
  %load_hi = load i16, i16 addrspace(5)* %gep_hi
  %to.hi = insertelement <2 x i16> undef, i16 %load_hi, i32 1
  %op.hi = add <2 x i16> %to.hi, <i16 12, i16 12>
  %result = insertelement <2 x i16> %op.hi, i16 %load_lo, i32 0
  ret <2 x i16> %result
}

define <2 x i16> @chain_hi_to_lo_global_other_dep(i16 addrspace(1)* %ptr) {
; GCN-LABEL: chain_hi_to_lo_global_other_dep:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    global_load_ushort v2, v[0:1], off offset:2
; GCN-NEXT:    global_load_short_d16_hi v0, v[0:1], off
; GCN-NEXT:    v_mov_b32_e32 v1, 0xffff
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_pk_sub_u16 v0, v0, -12 op_sel_hi:[1,0]
; GCN-NEXT:    v_bfi_b32 v0, v1, v2, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds i16, i16 addrspace(1)* %ptr, i64 1
  %load_lo = load volatile i16, i16 addrspace(1)* %gep_lo
  %gep_hi = getelementptr inbounds i16, i16 addrspace(1)* %ptr, i64 0
  %load_hi = load volatile i16, i16 addrspace(1)* %gep_hi
  %to.hi = insertelement <2 x i16> undef, i16 %load_hi, i32 1
  %op.hi = add <2 x i16> %to.hi, <i16 12, i16 12>
  %result = insertelement <2 x i16> %op.hi, i16 %load_lo, i32 0
  ret <2 x i16> %result
}

define <2 x i16> @chain_hi_to_lo_flat_other_dep(i16 addrspace(0)* %ptr) {
; GCN-LABEL: chain_hi_to_lo_flat_other_dep:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    flat_load_ushort v2, v[0:1] offset:2
; GCN-NEXT:    flat_load_short_d16_hi v0, v[0:1]
; GCN-NEXT:    v_mov_b32_e32 v1, 0xffff
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_pk_sub_u16 v0, v0, -12 op_sel_hi:[1,0]
; GCN-NEXT:    v_bfi_b32 v0, v1, v2, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds i16, i16 addrspace(0)* %ptr, i64 1
  %load_lo = load volatile i16, i16 addrspace(0)* %gep_lo
  %gep_hi = getelementptr inbounds i16, i16 addrspace(0)* %ptr, i64 0
  %load_hi = load volatile i16, i16 addrspace(0)* %gep_hi
  %to.hi = insertelement <2 x i16> undef, i16 %load_hi, i32 1
  %op.hi = add <2 x i16> %to.hi, <i16 12, i16 12>
  %result = insertelement <2 x i16> %op.hi, i16 %load_lo, i32 0
  ret <2 x i16> %result
}

define <2 x i16> @chain_hi_to_lo_group_may_alias_store(i16 addrspace(3)* %ptr, i16 addrspace(3)* %may.alias) {
; GCN-LABEL: chain_hi_to_lo_group_may_alias_store:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v3, 0x7b
; GCN-NEXT:    ds_read_u16 v2, v0
; GCN-NEXT:    ds_write_b16 v1, v3
; GCN-NEXT:    ds_read_u16 v0, v0 offset:2
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GCN-NEXT:    v_lshl_or_b32 v0, v2, 16, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb:
  %gep_lo = getelementptr inbounds i16, i16 addrspace(3)* %ptr, i64 1
  %gep_hi = getelementptr inbounds i16, i16 addrspace(3)* %ptr, i64 0
  %load_hi = load i16, i16 addrspace(3)* %gep_hi
  store i16 123, i16 addrspace(3)* %may.alias
  %load_lo = load i16, i16 addrspace(3)* %gep_lo

  %to.hi = insertelement <2 x i16> undef, i16 %load_hi, i32 1
  %result = insertelement <2 x i16> %to.hi, i16 %load_lo, i32 0
  ret <2 x i16> %result
}
