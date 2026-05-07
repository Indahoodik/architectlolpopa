; CALC - розрахунок виразу (A * 2 + B) - (C + D)
; Змінні: A = 15, B = 23, C = 8, D = 12

.MODEL small
.STACK 100h

.CODE
start:
    ; Cleaning registers
    xor ax, ax           ; AX = 0
    xor bx, bx           ; BX = 0
    xor cx, cx           ; CX = 0
    xor dx, dx           ; DX = 0

    ; Loading values
    mov ax, 15           ; A = 15
    mov bx, 23           ; B = 23
    mov cx, 8            ; C = 8
    mov dx, 12           ; D = 12


    ; Arithmetics
    ; 1 Дія: AX = A * 2
    add ax, ax           ; AX = 30

    ; 2 Дія: AX = A*2 + B
    add ax, bx          ; AX = 30 + 23 = 53

    ; 3 Дія: CX = C + D
    add cx, dx           ; CX = 8 + 12 = 20

    ; 4 Дія: AX = (A*2 + B) - (C + D)
    sub ax, cx           ; AX = 53 - 20 = 33

    ; Exit program
    mov ah, 4Ch
    int 21h

end start
