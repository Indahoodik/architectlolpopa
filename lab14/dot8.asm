; dot8.asm — Скалярний добуток 64 float через AVX2 FMA
;
; Збірка: nasm -f elf64 -g dot8.asm -o dot8.o && ld dot8.o -o dot8
; Запуск: ./dot8

default rel

%define N 64

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

    str_dot   db "dot(a,b) = "
    str_dot_l equ $ - str_dot
    str_want  db "  (want: 0x44CC0000 = 1632.0)"
    str_want_l equ $ - str_want

section .text
    global _start

_start:
    lea rdi, [a]
    lea rsi, [b]
    call dot_product

    push rax
    lea rsi, [str_dot]
    mov rdx, str_dot_l
    call print_string
    pop rax
    mov edi, eax
    call print_hex32

    lea rsi, [str_want]
    mov rdx, str_want_l
    call print_string
    call print_newline

    mov rax, 60
    xor rdi, rdi
    syscall


; ================================================================
; dot_product — Σ a[i]*b[i], 64 елементи
; ================================================================
dot_product:
    ; --- КРОК 1 ---
    vxorps ymm0, ymm0, ymm0

    mov ecx, 8

.loop:
    vmovaps      ymm1, [rdi]
    vfmadd231ps  ymm0, ymm1, [rsi]

    add rdi, 32
    add rsi, 32

    ; ============================================
    ; TODO 1: цикл
    ; ============================================
    dec ecx
    jnz .loop


    ; ============================================
    ; TODO 2: горизонтальна редукція
    ;
    ; STATE:
    ; після циклу:
    ; ymm0 = [8, 32, 72, 128, 200, 288, 392, 512]
    ;
    ; 1. vextractf128 xmm1, ymm0, 1
    ;    xmm1 = [200, 288, 392, 512]
    ;
    ; 2. vaddps xmm0, xmm0, xmm1
    ;    xmm0 = [208, 320, 464, 640]
    ;
    ; 3. vhaddps xmm0, xmm0, xmm0
    ;    xmm0 = [528, 1104, 528, 1104]
    ;
    ; 4. vhaddps xmm0, xmm0, xmm0
    ;    xmm0 = [1632, 1632, 1632, 1632]
    ; ============================================

    vextractf128 xmm1, ymm0, 1
    vaddps       xmm0, xmm0, xmm1
    vhaddps      xmm0, xmm0, xmm0
    vhaddps      xmm0, xmm0, xmm0


    ; --- КРОК 4 ---
    vmovd eax, xmm0
    ret


; ============================================
; ВІДПОВІДІ
;
; 1. Скільки vfmadd231ps?
;    → 8 інструкцій (по одній на ітерацію)
;
;    Скалярних операцій:
;    → 64 множення + 64 додавання = 128 операцій
;
; 2. Де SIMD "втрачається"?
;    → у горизонтальній редукції (vhaddps)
;    → там вже немає 8× паралелізму
;
; 3. Якщо не обнулити ymm0:
;    → результат буде сміття (накопичення з невідомого стану)
; ============================================

%include "simd_utils.inc"