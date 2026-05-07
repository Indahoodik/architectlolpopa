; 2MAX2.ASM
.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===
    ; Test 1: (10, 5)
    mov ax, 10
    mov bx, 5
    cmp ax, bx
    jge ax_is_greater1
    mov cx, bx
    jmp done_1
    ax_is_greater1:
        mov cx, ax
    done_1:
        ; CX = 10



    ; Test 2: (3, 8)
    mov ax, 3
    mov bx, 8
    cmp ax, bx
    jge ax_is_greater2
    mov cx, bx
    jmp done_2
    ax_is_greater2:
        mov cx, ax
    done_2:
        ; CX = 8



    ; Test 3: (7, 7)
    mov ax, 7
    mov bx, 7
    cmp ax, bx
    jge ax_is_greater3
    mov cx, bx
    jmp done_3
    ax_is_greater3:
        mov cx, ax
    done_3:
        ; CX = 7

   
   
   
    ; Test 4: (-5, 3)
    mov ax, -5
    mov bx, 3
    cmp ax, bx
    jge ax_is_greater4
    mov cx, bx
    jmp done_4
    ax_is_greater4:
        mov cx, ax
    done_4:
        ; CX = 3



    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start
