; add.asm — IEEE 754 floating-point addition (FIXED NASM VERSION)

default rel

%include "fp_utils.inc"

section .data
    test1_a     dd 0x41200000
    test1_b     dd 0x40A00000
    test1_exp   dd 0x41700000

    test2_a     dd 0x41200000
    test2_b     dd 0xC0A00000
    test2_exp   dd 0x40A00000

    test3_a     dd 0x3DCCCCCD
    test3_b     dd 0x3E4CCCCD
    test3_exp   dd 0x3E99999A

    str_plus    db " + "
    str_plus_l  equ $ - str_plus
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
    call run_case

    mov r12d, [test2_a]
    mov r13d, [test2_b]
    mov r15d, [test2_exp]
    call run_case

    mov r12d, [test3_a]
    mov r13d, [test3_b]
    mov r15d, [test3_exp]
    call run_case

    mov rax, 60
    xor rdi, rdi
    syscall


; ============================================================
run_case:
    call fp_add

    mov edi, r12d
    call print_hex32
    lea rsi, [str_plus]
    mov rdx, str_plus_l
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
fp_add:
    push rax
    push rbx
    push rcx
    push rdx

; -------- unpack A --------
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

; -------- unpack B --------
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

; -------- ensure exp_a >= exp_b --------
    mov eax, [exp_a]
    cmp eax, [exp_b]
    jge .no_swap

    mov eax, [sign_a]
    mov ebx, [sign_b]
    mov [sign_a], ebx
    mov [sign_b], eax

    mov eax, [exp_a]
    mov ebx, [exp_b]
    mov [exp_a], ebx
    mov [exp_b], eax

    mov eax, [mant_a]
    mov ebx, [mant_b]
    mov [mant_a], ebx
    mov [mant_b], eax

.no_swap:

; -------- align mantissa --------
    mov eax, [exp_a]
    mov ebx, [exp_b]
    sub eax, ebx
    mov ecx, eax

    cmp ecx, 24
    jae .zero_b

    mov eax, [mant_b]
    shr eax, cl
    mov [mant_b], eax
    jmp .aligned

.zero_b:
    xor eax, eax
    mov [mant_b], eax

.aligned:

; -------- add / subtract --------
    mov eax, [mant_a]
    mov ebx, [mant_b]

    mov ecx, [sign_a]
    mov edx, [sign_b]

    cmp ecx, edx
    je .add

; ---- subtract ----
    sub eax, ebx
    mov [sign_r], ecx
    mov eax, [exp_a]
    mov [exp_r], eax

    test eax, eax
    jns .store_sub
    neg eax
    xor dword [sign_r], 1

.store_sub:
    mov [mant_r], eax
    jmp .normalize

; ---- add ----
.add:
    add eax, ebx
    mov [mant_r], eax
    mov eax, [exp_a]
    mov [exp_r], eax
    mov eax, ecx
    mov [sign_r], eax


; -------- normalize --------
.normalize:
    mov eax, [mant_r]

    test eax, eax
    jnz .norm_ok
    mov r14d, 0
    jmp .done

.norm_ok:
    mov ebx, eax
    and ebx, 0x1000000
    cmp ebx, 0
    jz .shift_up

    shr eax, 1
    mov ebx, [exp_r]
    inc ebx
    mov [exp_r], ebx
    jmp .pack

.shift_up:
.norm_loop:
    mov ebx, eax
    and ebx, 0x800000
    cmp ebx, 0
    jnz .pack

    shl eax, 1
    mov ebx, [exp_r]
    dec ebx
    mov [exp_r], ebx
    jmp .norm_loop


; -------- pack --------
.pack:
    mov [mant_r], eax

    mov eax, [mant_r]
    and eax, 0x7FFFFF

    mov ebx, [sign_r]
    shl ebx, 31

    mov ecx, [exp_r]
    shl ecx, 23

    or ebx, ecx
    or ebx, eax

    mov r14d, ebx

.done:
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret