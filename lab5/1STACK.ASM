.MODEL small
.STACK 100h



.CODE
start:
    MOV AX, 000Ah
    MOV BX, 000Bh
    MOV CX, 000ch

    PUSH AX
    PUSH BX
    PUSH CX

    POP DX
    POP SI
    POP DI

    xor ax, ax
    xor bx, bx

    mov ax, 1234h
    mov bx, 5678h

    push ax
    push bx

    pop ax
    pop bx

    xor ax, ax
    xor bx, bx
    xor cx, cx

    mov ax, 11h
    mov bx, 22h
    mov cx, 33h


    push ax
    push bx
    push cx

    pop ax
    pop cx
    pop bx


    ; === End of your code
    mov ah, 4Ch
    int 21h
end start