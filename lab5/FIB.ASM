.MODEL small
.STACK 100h

.CODE
start:
    mov ax, 10
    push ax
    call fibonacci
    add sp, 2

    ; AX = 55 

    mov ah,4Ch
    int 21h


fibonacci proc
    push bp
    mov bp, sp

    push bx        
    push cx

    mov ax, [bp+4] 

    ; базові випадки
    cmp ax, 0
    jne check_one
    mov ax, 0
    jmp finish

check_one:
    cmp ax, 1
    jne recursive
    mov ax, 1
    jmp finish


recursive:

    mov bx, ax     


    dec ax
    push ax
    call fibonacci
    add sp, 2

    push ax        

    mov ax, bx
    sub ax, 2
    push ax
    call fibonacci
    add sp, 2


    pop cx         
    add ax, cx     

finish:
    pop cx
    pop bx
    pop bp
    ret
fibonacci endp

END start
