
.MODEL small
.STACK 100h

.CODE
start:

    mov cx, 5

    mov ax, 1          


    cmp cx, 0
    je done

factorial_loop:
    mul cx             
    dec cx
    jnz factorial_loop

done:
;очікуваний результат AX = 0078h (120)

    mov ah, 4Ch
    int 21h
end start
