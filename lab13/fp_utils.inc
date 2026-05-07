; ==============================================================
; fp_utils.inc — Допоміжні функції для виводу
;
; Підключення: %include "fp_utils.inc" (в кінці .asm файлу)
;
; Усі функції ЗБЕРІГАЮТЬ значення всіх регістрів.
; Можна викликати без push/pop навколо виклику.
; ==============================================================

section .bss
    _pu_char_buf  resb 1
    _pu_uint_buf  resb 12
    _pu_hex_buf   resb 8

section .data
    _pu_hex_prefix db "0x"

section .text

; --- print_char: вивести символ з DIL ---
print_char:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r11
    mov byte [_pu_char_buf], dil
    mov rax, 1
    mov rdi, 1
    lea rsi, [_pu_char_buf]
    mov rdx, 1
    syscall
    pop r11
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax
    ret

; --- print_newline: вивести '\n' ---
print_newline:
    push rdi
    mov dil, 10
    call print_char
    pop rdi
    ret

; --- print_string: вивести рядок (RSI=адреса, RDX=довжина) ---
print_string:
    push rax
    push rcx
    push rdi
    push r11
    mov rax, 1
    mov rdi, 1
    syscall
    pop r11
    pop rdi
    pop rcx
    pop rax
    ret

; --- print_uint: вивести беззнакове 32-бітне число з EDI ---
print_uint:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r11
    mov eax, edi
    lea rsi, [_pu_uint_buf + 11]
    xor ecx, ecx
    mov ebx, 10
    test eax, eax
    jnz .pu_loop
    dec rsi
    mov byte [rsi], '0'
    inc ecx
    jmp .pu_write
.pu_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc ecx
    test eax, eax
    jnz .pu_loop
.pu_write:
    mov rdx, rcx
    mov rax, 1
    mov rdi, 1
    syscall
    pop r11
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

; --- print_int: вивести знакове 32-бітне число з EDI ---
print_int:
    test edi, edi
    jns print_uint
    push rdi
    mov dil, '-'
    call print_char
    pop rdi
    neg edi
    jmp print_uint

; --- print_hex32: вивести 32-бітне число з EDI як 0xHHHHHHHH ---
print_hex32:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r11
    mov ebx, edi
    mov rax, 1
    mov rdi, 1
    lea rsi, [_pu_hex_prefix]
    mov rdx, 2
    syscall
    mov ecx, 8
    lea rsi, [_pu_hex_buf]
.ph_loop:
    rol ebx, 4
    mov eax, ebx
    and eax, 0xF
    cmp al, 10
    jl .ph_digit
    add al, ('A' - 10)
    jmp .ph_store
.ph_digit:
    add al, '0'
.ph_store:
    mov [rsi], al
    inc rsi
    dec ecx
    jnz .ph_loop
    lea rsi, [_pu_hex_buf]
    mov rdx, 8
    mov rax, 1
    mov rdi, 1
    syscall
    pop r11
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret