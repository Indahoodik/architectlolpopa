.MODEL small
.STACK 100h

.CODE
start:

    mov al, 7Bh        
    mov bl, al
    and bl, 00001111b     
    mov bh, al
    and bh, 11110000b    
    shr bh, 4          


    xor ax, ax
    xor bx, bx
    mov al, 35h
    test al, 00000001b
    jz evenNum
    mov bl, 1
    jmp task2
evenNum:
    mov bl, 0

task2:
    or al, 01000000b
    and al, 11110000b




    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start
