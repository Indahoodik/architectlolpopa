.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===
    
    ; Експеримент 1.1: Zero Flag
    mov ax, 7
    sub ax, 7        

    ; Експеримент 1.2: Carry Flag
    mov al, 250
    add al, 10        

    ; Експеримент 1.3: Sign Flag та Overflow Flag 

    mov al, 100
    add al, 50       ; Ми додавали два додатних числа, але отримали від’ємне.


    ; Експеримент 1.4: CF = 1 та ZF = 1
    xor al, al
    mov al, 250
    add al, 6      

    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start
