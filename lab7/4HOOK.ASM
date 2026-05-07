.MODEL small
.STACK 256

.DATA
tick_count  DW 0
msg_ticks   DB 'Ticks: $'
msg_exit    DB 0Dh, 0Ah, 'Press Q to quit...', 0Dh, 0Ah, '$'
orig_ip     DW ?                
orig_cs     DW ?                

.CODE

my_handler proc far
    push ax
    push ds

    mov ax, @data
    mov ds, ax

    inc tick_count            

    pop ds
    pop ax
    iret                       
my_handler endp


main:
    mov ax, @data
    mov ds, ax

    cli                          
    push es
    xor ax, ax
    mov es, ax                   


    mov ax, word ptr es:[0070h]
    mov orig_ip, ax
    mov ax, word ptr es:[0072h]
    mov orig_cs, ax

 
    mov ax, offset my_handler
    mov word ptr es:[0070h], ax
    mov ax, seg my_handler
    mov word ptr es:[0072h], ax

    pop es
    sti                         

    mov ah, 09h
    mov dx, offset msg_exit
    int 21h

wait_loop:
    mov ah, 02h
    mov dl, 0Dh
    int 21h

    mov ah, 09h
    mov dx, offset msg_ticks
    int 21h



    mov ax, tick_count
    mov dl, ah
    shr dl, 4
    add dl, '0'
    cmp dl, '9'
    jle d1
    add dl, 7
d1:
    mov ah, 02h
    int 21h

    mov ax, tick_count
    mov dl, ah
    and dl, 0Fh
    add dl, '0'
    cmp dl, '9'
    jle d2
    add dl, 7
d2:
    mov ah, 02h
    int 21h

    mov ax, tick_count
    mov dl, al
    shr dl, 4
    add dl, '0'
    cmp dl, '9'
    jle d3
    add dl, 7
d3:
    mov ah, 02h
    int 21h

    mov ax, tick_count
    mov dl, al
    and dl, 0Fh
    add dl, '0'
    cmp dl, '9'
    jle d4
    add dl, 7
d4:
    mov ah, 02h
    int 21h


    mov ah, 01h
    int 16h
    jz wait_loop

    ; Зчитати клавішу
    mov ah, 00h
    int 16h
    cmp al, 'q'
    je done
    cmp al, 'Q'
    je done
    jmp wait_loop

done:
    cli
    push es
    xor ax, ax
    mov es, ax

    mov ax, orig_ip
    mov word ptr es:[0070h], ax
    mov ax, orig_cs
    mov word ptr es:[0072h], ax

    pop es
    sti

    mov ah, 4Ch
    int 21h

END main