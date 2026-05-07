; ROWSUM.ASM
.MODEL small
.STACK 100h

.DATA
matrix  DB  1,  2,  3,  4
        DB  5,  6,  7,  8
        DB  9, 10, 11, 12

COLS    EQU 4

.CODE
start:

    mov ax, @data
    mov ds, ax

    push 1              
    push COLS           
    push offset matrix  
    call row_sum
    add sp, 6
    ; AX = 001Ah (26)

    push 0
    push COLS
    push offset matrix
    call row_sum
    add sp, 6
    ; AX = 000Ah (10)

    push 2
    push COLS
    push offset matrix
    call row_sum
    add sp, 6
    ; AX = 002Ah (42)

    mov ah, 4Ch
    int 21h



row_sum proc

    push bp
    mov bp, sp

    push bx
    push cx
    push dx
    push si

    mov bx, [bp+4]      ; BX = адреса матриці
    mov cx, [bp+6]      ; CX = кількість стовпців
    mov ax, [bp+8]      ; AX = номер рядка


    mul cx              ; AX = row * COLS (кількість байтів до рядка)
    mov si, ax          ; SI = зміщення початку рядка

    xor ax, ax          ; AX = сума (0)

sum_loop:
    mov dl, [bx+si]     ; DL = елемент (байт)
    xor dh, dh          ; перетворюємо DX у слово
    add ax, dx          ; додаємо до суми
    inc si              ; наступний елемент
    loop sum_loop

    pop si
    pop dx
    pop cx
    pop bx
    pop bp
    ret

row_sum endp

end start