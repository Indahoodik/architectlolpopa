; MAX.ASM - Maximum of three signed numbers
.MODEL small
.STACK 100h

.CODE
start:

    mov ax, 15
    mov bx, -8
    mov cx, 23


    cmp ax, bx
    jg  ax_ge_bx        ; AX > BX ? then AX stays max
    mov ax, bx          ; else BX is larger

ax_ge_bx:


    cmp ax, cx
    jg  done            ; AX > CX ? then AX is final max
    mov ax, cx          ; else CX is larger

done:


    mov ah, 4Ch
    int 21h
end start
