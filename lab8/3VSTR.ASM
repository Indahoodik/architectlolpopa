.MODEL small
.STACK 100h

.DATA
msg1 DB 'Hello, Video Memory!', 0
msg2 DB 'Direct writes are fast!', 0
msg3 DB 'Top left', 0
msg4 DB 'Bottom line', 0
msg5 DB 0

.CODE
start:
    mov ax, @data
    mov ds, ax

    mov ax, 0B800h
    mov es, ax

    xor di, di
    mov cx, 2000
    mov ax, 0720h

@cls:
    mov es:[di], ax
    add di, 2
    loop @cls

    push 1Fh         
    push 5           
    push 10          
    push offset msg1 
    call vram_str
    add sp, 8


    push 2Ah         
    push 7
    push 10
    push offset msg2
    call vram_str
    add sp, 8




    push 0Fh
    push 0
    push 0
    push offset msg3
    call vram_str
    add sp, 8


    push 0Eh
    push 24
    push 10
    push offset msg4
    call vram_str
    add sp, 8


    push 1Fh
    push 12
    push 30
    push offset msg5
    call vram_str
    add sp, 8


    mov ah, 4Ch
    int 21h



vram_str proc
    push bp
    mov bp, sp

    push ax
    push bx
    push si
    push di
    push es

    mov ax, 0B800h
    mov es, ax



    mov ax, [bp+8]   
    mov bx, 80
    mul bx           

    add ax, [bp+6]  
    shl ax, 1        

    mov di, ax


    mov si, [bp+4]           
    mov ah, byte ptr [bp+10] 

@loop:
    lodsb           

    cmp al, 0        
    je @done

    mov es:[di], ax  

    add di, 2        
    jmp @loop

@done:
    pop es
    pop di
    pop si
    pop bx
    pop ax
    pop bp
    ret

vram_str endp

end start