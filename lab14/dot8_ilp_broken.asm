; dot8_ilp_broken.asm — ILP експеримент з навмисною залежністю

default rel

%define ITERS 10000000

section .data
    align 32
    a:
    %rep 8
        dd 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0
    %endrep

    align 32
    b:
    %rep 8
        dd 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0
    %endrep

section .text
    global _start

_start:
    lea rdi, [a]
    lea rsi, [b]
    mov rdx, ITERS
    call dot_indep

    mov rax, 60
    xor rdi, rdi
    syscall


; ================================================================
; dot_indep — ЗЛАМАНА версія (одна FMA створює RAW-залежність)
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

    vmovaps      ymm4, [rdi + 128]
    vfmadd231ps  ymm0, ymm4, [rsi + 128]

    vmovaps      ymm4, [rdi + 160]

    ; було: ymm1
    ; стало: ymm0 → створює RAW залежність
    vfmadd231ps  ymm0, ymm4, [rsi + 160]

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