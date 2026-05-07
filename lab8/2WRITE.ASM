

.MODEL small
.STACK 100h

.DATA
hello  DB 'HELLO'
colors DB 0Ch, 0Ah, 0Eh, 09h, 0Dh

.CODE
start:
    mov ax, @data
    mov ds, ax

    ; Налаштування ES 
    mov ax, 0B800h
    mov es, ax

    ; Очистка екрана
    xor di, di
    mov cx, 2000          ; 80 * 25 символів
    mov ax, 0720h         ; пробіл (20h) з атрибутом 07h

@cls:
    mov es:[di], ax
    add di, 2             ; перехід до наступної позиції
    loop @cls


    xor di, di
    mov al, 'H'
    mov ah, 1Fh           ; білий на синьому
    mov es:[di], ax

    mov di, 2             ; позиція (0,1)
    mov al, 'i'
    mov ah, 1Fh
    mov es:[di], ax

    mov di, 07D0h         ; 
    mov al, '*'
    mov ah, 4Eh           ; жовтий на червоному
    mov es:[di], ax

    ; Вивід "HELLO" 
    mov si, OFFSET hello  
    mov bx, OFFSET colors 
    mov di, 07CAh        
    mov cx, 5             

@print_hello:
    mov al, [si]          
    mov ah, [bx]          
    mov es:[di], ax       

    inc si                
    inc bx               
    add di, 2             

    loop @print_hello

    mov ah, 4Ch
    int 21h

end start