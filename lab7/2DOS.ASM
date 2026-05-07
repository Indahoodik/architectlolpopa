.model small
.stack 100h

.data
msg     DB 'Hello, Interrupts!', 0Dh, 0Ah, '$'
prompt  DB 'Enter a char: $'

prompt2 DB 'Type text, press Enter to finish: $'
result  DB 'You typed XX chars', 0Dh, 0Ah, '$'

.code
start:
    mov ax, @data
    mov ds, ax


    mov ah, 09h
    mov dx, offset msg
    int 21h




    mov ah, 09h
    mov dx, offset prompt
    int 21h



    mov ah, 01h
    int 21h            



    mov dl, al
    mov ah, 02h
    int 21h


    mov dl, 0Dh
    mov ah, 02h
    int 21h

    mov dl, 0Ah
    mov ah, 02h
    int 21h




    mov ah, 09h
    mov dx, offset prompt2
    int 21h

    xor cx, cx       

read_loop:
    mov ah, 01h
    int 21h           

    cmp al, 0Dh      
    je done_count

    inc cx
    jmp read_loop

done_count:

    mov ah, 09h
    mov dx, offset result
    int 21h


    mov ah, 4Ch
    int 21h

end start