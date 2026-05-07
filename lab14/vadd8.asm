; vadd8.asm — Векторне додавання 8 float за одну SIMD-інструкцію
;
; Збірка: nasm -f elf64 -g vadd8.asm -o vadd8.o && ld vadd8.o -o vadd8
; Запуск: ./vadd8

default rel

section .data
    ; Два вирівняні масиви по 8 float32
    align 32
    a: dd 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0

    align 32
    b: dd 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0

    str_a db "a = "
    str_a_len equ $ - str_a
    str_b db "b = "
    str_b_len equ $ - str_b
    str_c db "c = "
    str_c_len equ $ - str_c

section .bss
    align 32
    c: resd 8                   ; місце для результату

section .text
    global _start

_start:
    ; --- Вивести "a = " + масив a ---
    lea rsi, [str_a]
    mov rdx, str_a_len
    call print_string
    lea rdi, [a]
    call print_ymm_buf

    ; --- Вивести "b = " + масив b ---
    lea rsi, [str_b]
    mov rdx, str_b_len
    call print_string
    lea rdi, [b]
    call print_ymm_buf

    ; ============================================
    ; Завантаження a
    ; STATE:
    ;   ymm0 = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
    ; ============================================
    vmovaps ymm0, [a]

    ; ============================================
    ; TODO 1: Завантажити масив b у YMM1
    ; STATE:
    ;   ymm1 = [10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]
    ; ============================================
    vmovaps ymm1, [b]

    ; ============================================
    ; TODO 2: Додати YMM0 + YMM1, результат у YMM2
    ; STATE:
    ;   ymm2 = [11.0, 22.0, 33.0, 44.0, 55.0, 66.0, 77.0, 88.0]
    ; ============================================
    vaddps ymm2, ymm0, ymm1

    ; ============================================
    ; TODO 3: Зберегти YMM2 у буфер c
    ; STATE:
    ;   c[0..7] = [11.0, 22.0, 33.0, 44.0, 55.0, 66.0, 77.0, 88.0]
    ; ============================================
    vmovaps [c], ymm2

    ; --- Вивести "c = " + масив c ---
    lea rsi, [str_c]
    mov rdx, str_c_len
    call print_string
    lea rdi, [c]
    call print_ymm_buf

    ; Вихід
    mov rax, 60
    xor rdi, rdi
    syscall


; ============================================
; ВІДПОВІДІ
;
; 1. Скільки addss потрібно?
;    → 8 інструкцій (по одній на кожен float)
;
; 2. Чому немає циклу?
;    → Бо SIMD виконує 8 операцій за одну інструкцію
;
; 3. Висновок:
;    → SIMD дає паралелізм на рівні даних
; ============================================

%include "simd_utils.inc"