.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===
    ; Експеримент 4.1: 16-bit MUL
    mov ax, 1000
    mov bx, 100
    mul bx ; результат в DX:AX


    ; Експеримент 4.2: DIV
    mov ax, 1000
    xor dx, dx          
    mov bx, 7
    div bx
    ; AX частка, DX остача

    ; Експеримент 4.3: Division Overflow
    mov ax, 1000
    mov bl, 3
    div bl              ; програма впаде
   
   
    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start