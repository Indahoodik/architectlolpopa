; HELLO.ASM: your first program
.MODEL small
.STACK 100h

.DATA
    msg db 'Hello, Assembly!', 0Dh, 0Ah, '$'

.CODE
start:
    mov ax, @data        ; setup data segment
    mov ds, ax           ; use these two in ALL your programs

    mov ah, 09h          ; DOS function: string output
    mov dx, offset msg
    int 21h

    mov ah, 4Ch          ; DOS function: end program
    mov al, 0
    int 21h

end start