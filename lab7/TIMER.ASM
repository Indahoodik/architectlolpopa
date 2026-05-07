.MODEL small
.STACK 256

.DATA
tick_count DW 0

orig_ip DW ?
orig_cs DW ?

msg_exit DB 0Dh,0Ah,'Press Q to quit',0Dh,0Ah,'$'

.CODE

my_handler PROC FAR

    push ax
    push bx
    push cx
    push dx
    push ds
    push es

    mov ax,@data
    mov ds,ax

    inc tick_count
    mov ax,tick_count
    xor dx,dx
    mov bx,18
    div bx            

    xor dx,dx
    mov bx,60
    div bx           

    mov cx,dx         
    mov bx,ax        

    mov ax,bx
    xor dx,dx
    mov bx,10
    div bx      

    add al,30h
    add dl,30h


    mov ax,0B800h
    mov es,ax

    mov di,(0*80+70)*2   

    mov ah,07h
    mov es:[di],al
    mov es:[di+1],ah

    mov es:[di+2],dl
    mov es:[di+3],ah

    mov byte ptr es:[di+4],':'
    mov byte ptr es:[di+5],07h

    mov ax,cx
    xor dx,dx
    mov bx,10
    div bx

    add al,30h
    add dl,30h

    mov es:[di+6],al
    mov es:[di+7],ah

    mov es:[di+8],dl
    mov es:[di+9],ah

    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax

    iret
my_handler ENDP

main:

    mov ax,@data
    mov ds,ax


    cli
    push es
    xor ax,ax
    mov es,ax

    mov ax,word ptr es:[0070h]
    mov orig_ip,ax
    mov ax,word ptr es:[0072h]
    mov orig_cs,ax

    mov ax,offset my_handler
    mov word ptr es:[0070h],ax
    mov ax,seg my_handler
    mov word ptr es:[0072h],ax

    pop es
    sti

    mov ah,09h
    mov dx,offset msg_exit
    int 21h

wait_loop:

    mov ah,01h
    int 16h
    jz wait_loop

    mov ah,00h
    int 16h

    cmp al,'q'
    je done
    cmp al,'Q'
    je done

    jmp wait_loop


done:

    cli
    push es
    xor ax,ax
    mov es,ax

    mov ax,orig_ip
    mov word ptr es:[0070h],ax
    mov ax,orig_cs
    mov word ptr es:[0072h],ax

    pop es
    sti

    mov ah,4Ch
    int 21h

END main