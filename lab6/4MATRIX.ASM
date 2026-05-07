; 4MATRIX.ASM
.MODEL small
.STACK 100h

.DATA
matrix  DB  1,  2,  3,  4
        DB  5,  6,  7,  8
        DB  9, 10, 11, 12

COLS    EQU 4
ROWS    EQU 3
TOTAL   EQU ROWS * COLS

.CODE
start:

    mov ax, @data
    mov ds, ax

    ; Завдання 4.1 

    ; очікуємо 7

    mov al, 1            ; row = 1
    mov bl, COLS
    mul bl               ; AX = row * COLS = 4
    add al, 2            ; + col (2) → AL = 6
    xor ah, ah           ; очистити AH → AX = 0006
    mov si, ax           ; SI = 6 (зміщення)
    mov al, [matrix + si]; AL = 7


    ; очікуємо 4

    mov al, 0            ; row = 0
    mov bl, COLS
    mul bl               ; AX = 0
    add al, 3            ; + col (3)
    xor ah, ah
    mov si, ax           ; SI = 3
    mov al, [matrix + si]; AL = 4


    ; очікуємо 10

    mov al, 2            ; row = 2
    mov bl, COLS
    mul bl               ; AX = 8
    add al, 1            ; + col (1) → 9
    xor ah, ah
    mov si, ax           ; SI = 9
    mov al, [matrix + si]; AL = 10


    ; Завдання 4.2

    xor ax, ax           ; AX = сума = 0
    xor si, si           ; SI = індекс
    mov cx, TOTAL        ; CX = 12 елементів

sum_loop:
    mov bl, [matrix + si]; BL = поточний елемент
    xor bh, bh           ; розширюємо до слова (BX)
    add ax, bx           ; додаємо до суми
    inc si               ; наступний байт
    loop sum_loop

    ; AX = 78 = 004Eh

    mov ah, 4Ch
    int 21h

end start