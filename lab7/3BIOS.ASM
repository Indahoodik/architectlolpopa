.model small
.stack 100h

.code
start:
    mov ax, @data
    mov ds, ax

    mov ah, 06h         
    mov al, 0           
    mov bh, 07h         
    mov cx, 0000h      
    mov dx, 184Fh        
    int 10h



    mov ah, 02h
    mov dh, 12          
    mov dl, 30          
    mov bh, 0            
    int 10h


    mov ah, 09h
    mov al, 'A'          
    mov bl, 1Eh          
    mov bh, 0
    mov cx, 1           
    int 10h



    mov si, offset word

    mov dh, 14          
    mov dl, 30

next_char:

    ; встановити курсор
    mov ah, 02h
    mov bh, 0
    int 10h

    ; взяти символ
    lodsb               

    cmp al, '$'
    je after_hello

    ; колір залежить від позиції
    mov ah, 09h
    mov bh, 0
    mov cx, 1

    mov bl, [color]     
    int 10h

    ; наступний стовпець
    inc dl

    ; наступний колір
    inc byte ptr color

    jmp next_char


after_hello:


    mov ah, 00h
    int 16h             



    mov dl, al
    mov ah, 02h
    int 21h



    mov ah, 4Ch
    int 21h


.data
word  db 'HELLO$'
color db 1Ah            


end start