; REGS.ASM - calculating expression using registers

.MODEL small
.STACK 100h

.CODE
start:
    ; Cleaning registers
    xor ax, ax           ; AX = 0
    xor bx, bx           ; BX = 0

    ; Loading values
    mov ax, 25           ; AX = 25
    mov bx, 17           ; BX = 17
    mov cx, 10           ; CL = 10

    ; Arithmetic
    add ax, bx           
    add ax, ax           
    sub ax, cx           



    ; Exit program
    mov ah, 4Ch
    int 21h

end start
