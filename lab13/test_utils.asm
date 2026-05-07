default rel
section .text
    global _start

_start:
    mov edi, 0x41200000
    call print_hex32
    call print_newline

    mov rax, 60
    xor rdi, rdi
    syscall

%include "fp_utils.inc"