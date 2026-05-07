; dot8_ilp.asm — ILP-експеримент: ланцюг vs незалежні акумулятори

default rel

%define ITERS 10000000

section .data
    align 32
    a:
    %rep 8
        dd 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
    %endrep

    align 32
    b:
    %rep 8
        dd 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
    %endrep

    str_chain db "Version A (chain,  1 acc):  "
    str_chain_l equ $ - str_chain
    str_indep db "Version B (indep, 4 accs):  "
    str_indep_l equ $ - str_indep
    str_cycles db " cycles"
    str_cycles_l equ $ - str_cycles
    str_ratio db "Ratio A/B = "
    str_ratio_l equ $ - str_ratio

section .text
    global _start

_start:
    ; ===== Version A =====
    lfence
    rdtsc
    shl rdx, 32
    or  rax, rdx
    mov r14, rax

    lea rdi, [a]
    lea rsi, [b]
    mov rdx, ITERS
    call dot_chain

    lfence
    rdtsc
    shl rdx, 32
    or  rax, rdx
    sub rax, r14
    mov r14, rax

    lea rsi, [str_chain]
    mov rdx, str_chain_l
    call print_string
    mov rdi, r14
    call print_uint64
    lea rsi, [str_cycles]
    mov rdx, str_cycles_l
    call print_string
    call print_newline

    ; ===== Version B =====
    lfence
    rdtsc
    shl rdx, 32
    or  rax, rdx
    mov r15, rax

    lea rdi, [a]
    lea rsi, [b]
    mov rdx, ITERS
    call dot_indep

    lfence
    rdtsc
    shl rdx, 32
    or  rax, rdx
    sub rax, r15
    mov r15, rax

    lea rsi, [str_indep]
    mov rdx, str_indep_l
    call print_string
    mov rdi, r15
    call print_uint64
    lea rsi, [str_cycles]
    mov rdx, str_cycles_l
    call print_string
    call print_newline

    ; ratio
    lea rsi, [str_ratio]
    mov rdx, str_ratio_l
    call print_string
    mov rax, r14
    xor rdx, rdx
    div r15
    mov rdi, rax
    call print_uint64
    call print_newline

    mov rax, 60
    xor rdi, rdi
    syscall


; ================================================================
; Version A — 1 accumulator
; ================================================================
dot_chain:
    vxorps ymm0, ymm0, ymm0
.loop:
    vmovaps      ymm1, [rdi]
    vfmadd231ps  ymm0, ymm1, [rsi]
    vmovaps      ymm1, [rdi + 32]
    vfmadd231ps  ymm0, ymm1, [rsi + 32]
    vmovaps      ymm1, [rdi + 64]
    vfmadd231ps  ymm0, ymm1, [rsi + 64]
    vmovaps      ymm1, [rdi + 96]
    vfmadd231ps  ymm0, ymm1, [rsi + 96]
    vmovaps      ymm1, [rdi + 128]
    vfmadd231ps  ymm0, ymm1, [rsi + 128]
    vmovaps      ymm1, [rdi + 160]
    vfmadd231ps  ymm0, ymm1, [rsi + 160]
    vmovaps      ymm1, [rdi + 192]
    vfmadd231ps  ymm0, ymm1, [rsi + 192]
    vmovaps      ymm1, [rdi + 224]
    vfmadd231ps  ymm0, ymm1, [rsi + 224]
    dec rdx
    jnz .loop
    ret


; ================================================================
; Version B — 4 independent accumulators
; ================================================================
dot_indep:
    vxorps ymm0, ymm0, ymm0
    vxorps ymm1, ymm1, ymm1
    vxorps ymm2, ymm2, ymm2
    vxorps ymm3, ymm3, ymm3

.loop:
    vmovaps      ymm4, [rdi]
    vfmadd231ps  ymm0, ymm4, [rsi]

    vmovaps      ymm4, [rdi + 32]
    vfmadd231ps  ymm1, ymm4, [rsi + 32]

    vmovaps      ymm4, [rdi + 64]
    vfmadd231ps  ymm2, ymm4, [rsi + 64]

    vmovaps      ymm4, [rdi + 96]
    vfmadd231ps  ymm3, ymm4, [rsi + 96]

    ; ===== TODO (додано) =====
    vmovaps      ymm4, [rdi + 128]
    vfmadd231ps  ymm0, ymm4, [rsi + 128]

    vmovaps      ymm4, [rdi + 160]
    vfmadd231ps  ymm1, ymm4, [rsi + 160]

    vmovaps      ymm4, [rdi + 192]
    vfmadd231ps  ymm2, ymm4, [rsi + 192]

    vmovaps      ymm4, [rdi + 224]
    vfmadd231ps  ymm3, ymm4, [rsi + 224]

    dec rdx
    jnz .loop

    vaddps ymm0, ymm0, ymm1
    vaddps ymm2, ymm2, ymm3
    vaddps ymm0, ymm0, ymm2
    ret


; ============================================
; ВІДПОВІДІ
;
; Чому Version B швидша:
; → немає ланцюга залежностей (RAW)
; → CPU може виконувати кілька FMA паралельно
;
; Чому не 8×:
; → обмеження по load-портам (пам'ять)
;
; Висновок:
; → ILP критично важливий навіть при SIMD
; ============================================

%include "simd_utils.inc"