.MODEL small
.STACK 100h
.DATA
    msg db 'Setup OK!$'
.CODE
start:
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset msg
    int 21h
    mov ah, 4Ch
    int 21h
end start