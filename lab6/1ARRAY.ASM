.MODEL small
.STACK 100h

.DATA
arr_b   DB 0Ah, 0Bh, 0Ch, 0Dh, 0Eh
arr_w   DW 1234h, 5678h, 0ABCDh
msg     DB 'Hi!', 0

.CODE
start:

mov ax, @data
mov ds, ax

; Режими адресації

; Direct 
mov al, [arr_b]          ; AL = 0Ah

; Register indirect
mov bx, offset arr_w
mov ax, [bx]             ; AX = 1234h

; Indexed
mov si, 2
mov al, arr_b[si]        ; AL = 0Ch

; Base + displacement
mov bx, offset arr_w
mov ax, [bx+2]           ; AX = 5678h

; LEA 
lea bx, [arr_w]
mov ax, [bx+4]           ; AX = ABCDh


    ; === End of your code ===
mov ah, 4Ch
int 21h

end start
