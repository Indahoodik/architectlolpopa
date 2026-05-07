; saxpy.asm — y[i] = a * x[i] + y[i] для 1024 float через AVX2

default rel

%define N 1024

section .data
    align 4
    scalar_a: dd 2.0

    y_init: dd 10.0

    str_y0  db "y[0]   = "
    str_y0_l  equ $ - str_y0
    str_y1  db "y[1]   = "
    str_y1_l  equ $ - str_y1
    str_y511 db "y[511] = "
    str_y511_l equ $ - str_y511
    str_y1023 db "y[1023] = "
    str_y1023_l equ $ - str_y1023

section .bss
    align 32
    x: resd N
    align 32
    y: resd N

section .text
    global _start

_start:
    ; --- init x, y ---
    mov ecx, N
    xor eax, eax
    lea rdi, [x]
    movss xmm1, [y_init]
    lea rsi, [y]

.init:
    cvtsi2ss xmm0, eax
    movss [rdi], xmm0
    movss [rsi], xmm1
    add rdi, 4
    add rsi, 4
    inc eax
    dec ecx
    jnz .init

    call saxpy_kernel

    ; --- print results ---
    lea rsi, [str_y0]
    mov rdx, str_y0_l
    call print_string
    mov edi, [y]
    call print_hex32
    call print_newline

    lea rsi, [str_y1]
    mov rdx, str_y1_l
    call print_string
    mov edi, [y + 4]
    call print_hex32
    call print_newline

    lea rsi, [str_y511]
    mov rdx, str_y511_l
    call print_string
    mov edi, [y + 511*4]
    call print_hex32
    call print_newline

    lea rsi, [str_y1023]
    mov rdx, str_y1023_l
    call print_string
    mov edi, [y + 1023*4]
    call print_hex32
    call print_newline

    mov rax, 60
    xor rdi, rdi
    syscall


; ================================================================
; SAXPY kernel: y = a*x + y
; ================================================================
saxpy_kernel:
    ; ymm_a = [a,a,a,a,a,a,a,a]
    vbroadcastss ymm3, [scalar_a]

    lea rdi, [x]
    lea rsi, [y]
    mov ecx, N
    shr ecx, 3              ; 1024 / 8 = 128 ітерацій

.loop:
    vmovaps ymm1, [rdi]     ; x
    vmovaps ymm2, [rsi]     ; y

    vfmadd231ps ymm2, ymm1, ymm3   ; y = x*a + y

    vmovaps [rsi], ymm2

    add rdi, 32
    add rsi, 32

    dec ecx
    jnz .loop

    ret

%include "simd_utils.inc"