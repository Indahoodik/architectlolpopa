; div.asm 

default rel

section .data
    test1_a     dd 0x40C00000   ; 6.0
    test1_b     dd 0x40000000   ; 2.0
    test1_exp   dd 0x40400000   ; 3.0

    test2_a     dd 0x41700000   ; 15.0
    test2_b     dd 0x40400000   ; 3.0
    test2_exp   dd 0x40A00000   ; 5.0

    test3_a     dd 0x3F800000   ; 1.0
    test3_b     dd 0x40400000   ; 3.0
    test3_exp   dd 0x3EAAAAAB   ; ~0.333...

    str_div     db " / "
    str_div_l   equ $ - str_div
    str_eq      db " = "
    str_eq_l    equ $ - str_eq
    str_want    db "  (want: "
    str_want_l  equ $ - str_want

section .bss
    sign_a  resd 1
    exp_a   resd 1
    mant_a  resd 1
    sign_b  resd 1
    exp_b   resd 1
    mant_b  resd 1
    sign_r  resd 1
    exp_r   resd 1
    mant_r  resd 1

section .text
global _start

_start:

    mov r12d, [test1_a]
    mov r13d, [test1_b]
    mov r15d, [test1_exp]
    call fp_div
    call print_case

    mov r12d, [test2_a]
    mov r13d, [test2_b]
    mov r15d, [test2_exp]
    call fp_div
    call print_case

    mov r12d, [test3_a]
    mov r13d, [test3_b]
    mov r15d, [test3_exp]
    call fp_div
    call print_case

    mov rax, 60
    xor rdi, rdi
    syscall


; ============================================================
print_case:
    mov edi, r12d
    call print_hex32
    lea rsi, [str_div]
    mov rdx, str_div_l
    call print_string

    mov edi, r13d
    call print_hex32
    lea rsi, [str_eq]
    mov rdx, str_eq_l
    call print_string

    mov edi, r14d
    call print_hex32
    lea rsi, [str_want]
    mov rdx, str_want_l
    call print_string

    mov edi, r15d
    call print_hex32
    mov dil, ')'
    call print_char
    call print_newline
    ret


; ============================================================
fp_div:
    push rax
    push rbx
    push rcx
    push rdx

    ; ---------- A ----------
    mov eax, r12d
    shr eax, 31
    mov [sign_a], eax

    mov eax, r12d
    shr eax, 23
    and eax, 0xFF
    mov [exp_a], eax

    mov eax, r12d
    and eax, 0x7FFFFF
    or eax, 0x800000
    mov [mant_a], eax

    ; ---------- B ----------
    mov eax, r13d
    shr eax, 31
    mov [sign_b], eax

    mov eax, r13d
    shr eax, 23
    and eax, 0xFF
    mov [exp_b], eax

    mov eax, r13d
    and eax, 0x7FFFFF
    or eax, 0x800000
    mov [mant_b], eax


    ; ============================================================
    ; SIGN (XOR)
    ; ============================================================
    mov eax, [sign_a]
    xor eax, [sign_b]
    mov [sign_r], eax


    ; ============================================================
    ; EXPONENT
    ; exp_r = exp_a - exp_b + 127
    ; ============================================================
    mov eax, [exp_a]
    sub eax, [exp_b]
    add eax, 127
    mov [exp_r], eax


    ; ============================================================
    ; MANTISSA DIVISION
    ; ============================================================
    mov eax, [mant_a]
    xor rdx, rdx
    xor rcx, rcx
    mov ecx, [mant_b]

    shl rax, 23          ; align precision (up to 47-bit)
    div rcx              ; unsigned division → quotient in RAX


    ; ============================================================
    ; NORMALIZATION
    ; ============================================================
    bt rax, 47
    jc .shift24

    shr rax, 23
    jmp .norm_done

.shift24:
    shr rax, 24
    inc dword [exp_r]

.norm_done:
    mov [mant_r], eax


    ; ============================================================
    ; PACK RESULT
    ; ============================================================
    mov eax, [mant_r]
    and eax, 0x7FFFFF

    mov ebx, [sign_r]
    shl ebx, 31

    mov ecx, [exp_r]
    shl ecx, 23

    or ebx, ecx
    or ebx, eax

    mov r14d, ebx


    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret


%include "fp_utils.inc"