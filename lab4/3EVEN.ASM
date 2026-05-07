.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===
    xor ax, ax      
    mov cx, 2       ; start from 2

again:
    add ax, cx      
    add cx, 2       
    cmp cx, 12      
    jne again

    ; AX = 001Eh (тобто 30)
    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start
