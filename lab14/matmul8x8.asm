; matmul8x8.asm — C = A * B (8x8 float) через AVX2 FMA
; 8 YMM-акумуляторів, кожен = рядок C

default rel

section .data
    align 32

    ; A = identity matrix (8x8)
    A:
    dd 1.0,0,0,0,0,0,0,0
    dd 0,1.0,0,0,0,0,0,0
    dd 0,0,1.0,0,0,0,0,0
    dd 0,0,0,1.0,0,0,0,0
    dd 0,0,0,0,1.0,0,0,0
    dd 0,0,0,0,0,1.0,0,0
    dd 0,0,0,0,0,0,1.0,0
    dd 0,0,0,0,0,0,0,1.0

    ; B[i][j] = i*8 + j + 1 (1..64)
    B:
    %assign i 0
    %rep 8
        %assign j 0
        %rep 8
            dd (i*8 + j + 1)
            %assign j j+1
        %endrep
        %assign i i+1
    %endrep

section .bss
    align 32
    C: resd 64

section .text
    global _start

_start:
    call matmul8

    ; вивести перший рядок C для перевірки
    lea rdi, [C]
    call print_ymm_buf

    mov rax, 60
    xor rdi, rdi
    syscall


; ============================================================
; matmul8 — 8x8 C = A * B
; ============================================================
matmul8:
    ; zero C rows in registers
    vxorps ymm0, ymm0, ymm0
    vxorps ymm1, ymm1, ymm1
    vxorps ymm2, ymm2, ymm2
    vxorps ymm3, ymm3, ymm3
    vxorps ymm4, ymm4, ymm4
    vxorps ymm5, ymm5, ymm5
    vxorps ymm6, ymm6, ymm6
    vxorps ymm7, ymm7, ymm7

    xor ecx, ecx            ; k = 0

.loop:
    vmovaps ymm8, [B + rcx*32]   ; B[k]

    ; row 0
    vbroadcastss ymm9, [A + 0*32 + rcx*4]
    vfmadd231ps ymm0, ymm8, ymm9

    ; row 1
    vbroadcastss ymm9, [A + 1*32 + rcx*4]
    vfmadd231ps ymm1, ymm8, ymm9

    ; row 2
    vbroadcastss ymm9, [A + 2*32 + rcx*4]
    vfmadd231ps ymm2, ymm8, ymm9

    ; row 3
    vbroadcastss ymm9, [A + 3*32 + rcx*4]
    vfmadd231ps ymm3, ymm8, ymm9

    ; row 4
    vbroadcastss ymm9, [A + 4*32 + rcx*4]
    vfmadd231ps ymm4, ymm8, ymm9

    ; row 5
    vbroadcastss ymm9, [A + 5*32 + rcx*4]
    vfmadd231ps ymm5, ymm8, ymm9

    ; row 6
    vbroadcastss ymm9, [A + 6*32 + rcx*4]
    vfmadd231ps ymm6, ymm8, ymm9

    ; row 7
    vbroadcastss ymm9, [A + 7*32 + rcx*4]
    vfmadd231ps ymm7, ymm8, ymm9

    inc ecx
    cmp ecx, 8
    jl .loop

    ; store C
    vmovaps [C + 0*32], ymm0
    vmovaps [C + 1*32], ymm1
    vmovaps [C + 2*32], ymm2
    vmovaps [C + 3*32], ymm3
    vmovaps [C + 4*32], ymm4
    vmovaps [C + 5*32], ymm5
    vmovaps [C + 6*32], ymm6
    vmovaps [C + 7*32], ymm7

    ret

%include "simd_utils.inc"