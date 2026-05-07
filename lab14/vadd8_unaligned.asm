; vadd8_unaligned.asm — демонстрація проблеми вирівнювання

default rel

section .data
    align 32
    a: dd 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0

    db 0                 ; ← шім (зсуває b)
    ; align 32           ; ← навмисно ВИМКНЕНО
    b: dd 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0

    str_a db "a = "
    str_a_len equ $ - str_a
    str_b db "b = "
    str_b_len equ $ - str_b
    str_c db "c = "
    str_c_len equ $ - str_c

section .bss
    align 32
    c: resd 8

section .text
    global _start

_start:
    ; print a
    lea rsi, [str_a]
    mov rdx, str_a_len
    call print_string
    lea rdi, [a]
    call print_ymm_buf

    ; print b
    lea rsi, [str_b]
    mov rdx, str_b_len
    call print_string
    lea rdi, [b]
    call print_ymm_buf

    ; load a (OK)
    vmovaps ymm0, [a]

    ; ❌ тут буде падіння
    vmovaps ymm1, [b]

    vaddps ymm2, ymm0, ymm1
    vmovaps [c], ymm2

    ; print c
    lea rsi, [str_c]
    mov rdx, str_c_len
    call print_string
    lea rdi, [c]
    call print_ymm_buf

    mov rax, 60
    xor rdi, rdi
    syscall


; ============================================
; ВІДПОВІДІ (для звіту)
;
; 1. Що зламалося?
;    → SIGSEGV (segmentation fault)
;    → exit=139 = 128 + 11 (signal 11)
;
; 2. Де саме впало?
;    → на інструкції: vmovaps ymm1, [b]
;
; 3. Чому без db 0 працює?
;    → a вирівняний на 32 байти
;    → b = a + 32 → теж вирівняний
;
;    з db 0:
;    → b = a + 33 → не кратно 32 → crash
;
; 4. Як виправити без align?
;    → замінити vmovaps → vmovups
;
; ============================================

%include "simd_utils.inc"