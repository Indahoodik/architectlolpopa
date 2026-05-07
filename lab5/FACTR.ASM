.MODEL small
.STACK 100h

.CODE
start:

    push 5
    call factorial
    add sp, 2      

    push 7
    call factorial
    add sp, 2

    mov ah,4Ch
    int 21h


factorial proc

    push bp
    mov bp, sp

    push bx            

    mov bx, [bp+4]     

    cmp bx, 1
    jg recursive_case

    mov ax, 1
    jmp finish


recursive_case:

    dec bx             
    push bx            
    call factorial
    add sp, 2          



    mov bx, [bp+4]    
    mul bx             

finish:
    pop bx

    mov sp, bp
    pop bp
    ret

factorial endp

end start
