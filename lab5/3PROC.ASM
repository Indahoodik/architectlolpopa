.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===

    mov ax, -5
    call abs_val        ; AX = 5


    ; 3.2
    push 20             
    push 10             
    call add_two
    add sp, 4        

    ; 3.3
    push 8
    push 15
    call max_of_two
    add sp, 4           ; AX = 15 (000Fh)

    push 42
    push 3
    call max_of_two
    add sp, 4           ; AX = 42 (002Ah)

    push 7
    push 7
    call max_of_two
    add sp, 4           ; AX = 7 (0007h)


    ; === End of your code ===
    mov ah, 4Ch
    int 21h



abs_val proc
    cmp ax, 0
    jge abs_done
    neg ax
abs_done:
    ret
abs_val endp




add_two proc

    push bp
    mov bp, sp

    ; [BP+6] = 20
    ; [BP+4] = 10
    ; [BP+2] = return address
    ; [BP+0] = saved BP

    mov ax, [bp+4]     ; AX = 10
    add ax, [bp+6]     ; AX = 30

    mov sp, bp
    pop bp
    ret

add_two endp


max_of_two proc

    push bp
    mov bp, sp

    mov ax, [bp+4]     
    cmp ax, [bp+6]     
    jge a_is_bigger

    mov ax, [bp+6]     

a_is_bigger:

    mov sp, bp
    pop bp
    ret

max_of_two endp

end start