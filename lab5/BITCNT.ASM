.MODEL small
.STACK 100h

.CODE
start:
    ; 1
    push 00AAh
    call bit_count
    add sp, 2          ; очищення стеку

    ; 2
    push 0FFFFh
    call bit_count
    add sp, 2

    ; 3
    push 0001h
    call bit_count
    add sp, 2

    ; 4
    push 0000h
    call bit_count
    add sp, 2


    mov ah, 4Ch
    int 21h


; рахує кількість встановлених бітів
bit_count proc

    push bp
    mov bp, sp

    mov cx, 0              
    mov bx, [bp+4]         

count_loop:

    cmp bx, 0
    je finish              

    test bx, 1             
    jz skip_inc

    inc cx                 

skip_inc:
    shr bx, 1             
    jmp count_loop


finish:
    mov ax, cx            

    mov sp, bp
    pop bp
    ret

bit_count endp

end start
