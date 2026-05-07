.MODEL small
.STACK 100h

.DATA
old_1C  dd 0                

msg     DB '   HELLO FROM ASM MARQUEE DEMO!   '
msg_len EQU ($ - msg)

index   dw 0                
.CODE
start:
    mov ax, @data
    mov ds, ax

    mov ax, 0B800h
    mov es, ax

    mov ax, 351Ch
    int 21h
    mov word ptr old_1C, bx
    mov word ptr old_1C+2, es

    mov dx, offset timer_handler
    mov ax, 251Ch
    int 21h

main_loop:
    mov ah, 01h
    int 16h
    jz main_loop

    mov ah, 00h
    int 16h

    cmp al, 'q'
    je exit
    cmp al, 'Q'
    je exit

    jmp main_loop

exit:
    mov dx, word ptr old_1C
    mov ds, word ptr old_1C+2
    mov ax, 251Ch
    int 21h

    mov ax, @data
    mov ds, ax

    mov ah, 4Ch
    int 21h


timer_handler proc far

    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es


    mov ax, @data
    mov ds, ax

    mov ax, 0B800h
    mov es, ax


    mov di, (24 * 80) * 2


    mov cx, 79
shift_loop:
    mov ax, es:[di + 2]
    mov es:[di], ax
    add di, 2
    loop shift_loop


    mov bx, index
    mov si, offset msg
    add si, bx

    mov al, [si]
    mov ah, 0Ah            

    mov di, (24 * 80 + 79) * 2
    mov es:[di], ax


    inc index
    mov ax, index
    cmp ax, msg_len
    jb ok

    mov index, 0

ok:
    pushf
    call dword ptr old_1C

    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    iret

timer_handler endp

END start