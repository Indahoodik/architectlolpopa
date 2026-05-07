; STUB.ASM - template
.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===
    
    mov ax, 3
    push ax
    call double_it
    add sp, 2
    ; Точка D: AX = ?

    mov ah, 4Ch
    int 21h

double_it proc
    push bp
    mov bp, sp
    ; Точка A: намалюйте стек (4 верхні слова)
    mov ax, [bp+4]
    shl ax, 1
    ; Точка B: AX = ?
    pop bp
    ; Точка C: SP = ? (відносно початкового)
    ret
double_it endp


    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start

; Точка A: [bp] saved BP [bp+2] return address [bp+4] 0003h 
; Точка B: AX = 0006h
; Точка C: SP = початковий SP − 2
; Точка D: AX = 0006h
