; decode.asm — IEEE 754 decode

default rel

section .data
    float_10    dd 0x41200000
    float_neg5  dd 0xC0A00000
    float_0_1   dd 0x3DCCCCCD
    float_1     dd 0x3F800000

    str_eq      db " = "
    str_eq_len  equ $ - str_eq
    str_exp     db " * 2^"
    str_exp_len equ $ - str_exp

section .text
global _start

_start:
    mov r12d, [float_10]
    call decode_print

    mov r12d, [float_neg5]
    call decode_print

    mov r12d, [float_0_1]
    call decode_print

    mov r12d, [float_1]
    call decode_print

    mov rax, 60
    xor rdi, rdi
    syscall


; ============================================================
decode_print:

    mov edi, r12d
    call print_hex32

    lea rsi, [str_eq]
    mov rdx, str_eq_len
    call print_string

    ; -------------------------
    ; SIGN
    ; -------------------------
    mov eax, r12d
    shr eax, 31
    test eax, eax
    jnz .negative
    mov dil, '+'
    jmp .after_sign
.negative:
    mov dil, '-'
.after_sign:
    call print_char

    ; ============================================================
    ; TODO 1: print "1."
    ; ============================================================
    mov dil, '1'
    call print_char

    mov dil, '.'
    call print_char


    ; ============================================================
    ; TODO 2: mantissa (23 bits)
    ; ============================================================
    mov eax, r12d
    and eax, 0x7FFFFF     ; mantissa only

    mov ecx, 22           ; bit index

.m_loop:
    bt eax, ecx           ; CF = bit
    jc .one

    mov dil, '0'
    jmp .out

.one:
    mov dil, '1'

.out:
    call print_char

    dec ecx
    jns .m_loop


    ; ============================================================
    ; TODO 3: exponent
    ; ============================================================
    mov eax, r12d
    shr eax, 23
    and eax, 0xFF
    sub eax, 127

    lea rsi, [str_exp]
    mov rdx, str_exp_len
    call print_string

    mov edi, eax
    call print_int


    call print_newline
    ret

%include "fp_utils.inc"