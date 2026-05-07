.MODEL small
.STACK 100h

.DATA
opt1 DB '1 - Red message ','$'
opt2 DB '2 - Green message ','$'
opt3 DB '3 - Yellow message ','$'
optq DB 'Q - Quit','$'

msg_red   DB 'This is RED message','$'
msg_green DB 'This is GREEN message','$'
msg_yellow DB 'This is YELLOW message','$'


.CODE

print_at PROC
    push bp
    mov bp,sp
    mov dx,word ptr [bp+4]
    mov ah,09h
    int 21h
    pop bp
    ret 6
print_at ENDP

clear_screen PROC
    mov ah,06h
    mov al,0
    mov bh,07h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    ret
clear_screen ENDP

clear_line10 PROC
    mov ah,09h
    int 10h
    ret
clear_line10 ENDP

print_color_char PROC
    mov ah,09h
    mov bh,0
    mov cx,1
    int 10h
    ret
print_color_char ENDP

main:
    mov ax,@data
    mov ds,ax
    call clear_screen

; меню
    push offset opt1
    call print_at
    push offset opt2
    call print_at
    push offset opt3
    call print_at
    push offset optq
    call print_at

menu_loop:
    mov ah,00h
    int 16h
    cmp al,'1'
    je red
    cmp al,'2'
    je green
    cmp al,'3'
    je yellow
    cmp al,'q'
    je quit
    cmp al,'Q'
    je quit
    jmp menu_loop

red:
    call clear_line10
    mov si,offset msg_red
red_loop:
    lodsb
    cmp al,'$'
    je menu_loop
    mov bl,04h
    call print_color_char
    jmp red_loop

green:
    call clear_line10
    mov si,offset msg_green
green_loop:
    lodsb
    cmp al,'$'
    je menu_loop
    mov bl,02h
    call print_color_char
    jmp green_loop

yellow:
    call clear_line10
    mov si,offset msg_yellow
yellow_loop:
    lodsb
    cmp al,'$'
    je menu_loop
    mov bl,0Eh
    call print_color_char
    jmp yellow_loop

quit:
    mov ah,4Ch
    int 21h

END main