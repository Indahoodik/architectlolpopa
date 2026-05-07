default rel

section .data
    align 32
    probe: dd 0x3F800000, 0x40000000, 0x40400000, 0x40800000
           dd 0x40A00000, 0x40C00000, 0x40E00000, 0x41000000

section .text
    global _start

_start:
    lea rdi, [probe]
    call print_ymm_buf

    mov rax, 60
    xor rdi, rdi
    syscall

%include "simd_utils.inc"