; 2SUM.ASM
.MODEL small
.STACK 100h

.DATA
data_w  DW 10, 20, 30, 40, 50
N       EQU ($ - data_w) / 2

data2   DW 7
N2      EQU ($ - data2) / 2

.CODE
start:

    mov ax, @data
    mov ds, ax


    xor ax, ax          ; AX = 0 
    xor si, si          ; SI = 0 
    mov cx, N           ; CX = 5

sum_loop:
    add ax, data_w[si]
    add si, 2           
    loop sum_loop
    ; AX = 150 = 0096h

    ; ---------------------------------
    ; Завдання 2.2 — процедура array_sum
    ; ---------------------------------

    push N
    push offset data_w
    call array_sum
    add sp, 4
    ; AX = 0096h (150)

    push N2
    push offset data2
    call array_sum
    add sp, 4
    ; AX = 0007h

    mov ah, 4Ch
    int 21h



array_sum proc

    push bp
    mov bp, sp

    push bx
    push cx
    push si

    xor ax, ax              ; AX = 0
    mov bx, [bp+4]          ; BX = offset 
    mov cx, [bp+6]          
    xor si, si              ; SI = 0

sum_proc_loop:
    add ax, [bx+si]
    add si, 2
    loop sum_proc_loop

    pop si
    pop cx
    pop bx

    pop bp
    ret

array_sum endp

end start