; 3LOOP.ASM
.MODEL small
.STACK 100h

.CODE
start:
    
    ; CX = 5 
    mov cx, 5
    xor ax, ax

again:
    add ax, cx
    dec cx
    jnz again
    ; AX = 15


    ; CX = 0 
    mov cx, 0
    xor ax, ax

again0:
    add ax, cx
    dec cx
    jnz again0

    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start
