.MODEL small
.STACK 100h

.DATA
title   DB ' My Panel ', 0
msg1    DB 'Name: Artur', 0
msg2    DB 'Group: CS-XX', 0
msg3    DB 'Course: Computer Systems Architecture', 0
msg4    DB 'Lab: 08 - Video Memory', 0
hint    DB 'Press any key to exit...', 0

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



    mov di, (3*80 + 10)*2
    mov ah, 1Fh

    mov al, 0C9h ; ╔
    mov es:[di], ax
    add di, 2

    mov cx, 70-10-1
    mov al, 0CDh ; ═
@top:
    mov es:[di], ax
    add di, 2
    loop @top

    mov al, 0BBh ; ╗
    mov es:[di], ax


    mov di, ((3+1)*80 + 10)*2
    mov cx, 20-3-1
    mov ah, 1Fh
    mov al, 0BAh ; ║

@side:
    mov es:[di], ax
    mov es:[di + (70-10)*2], ax
    add di, 160
    loop @side


    mov di, (20*80 + 10)*2
    mov ah, 1Fh

    mov al, 0C8h ; ╚
    mov es:[di], ax
    add di, 2

    mov cx, 70-10-1
    mov al, 0CDh
@bottom:
    mov es:[di], ax
    add di, 2
    loop @bottom

    mov al, 0BCh ; ╝
    mov es:[di], ax

    ; Заголовок 
    push 1Fh
    push 3
    push 35          
    push offset title
    call vram_str
    add sp, 8


    push 0Fh
    push 6
    push 15
    push offset msg1
    call vram_str
    add sp, 8

    push 0Ah
    push 8
    push 15
    push offset msg2
    call vram_str
    add sp, 8

    push 0Eh
    push 10
    push 15
    push offset msg3
    call vram_str
    add sp, 8

    push 0Bh
    push 12
    push 15
    push offset msg4
    call vram_str
    add sp, 8


    push 08h
    push 23
    push 25
    push offset hint
    call vram_str
    add sp, 8


    mov ah, 00h
    int 16h

    mov ah, 4Ch
    int 21h


; Процедура vram_str


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

    ; (row * 80 + col) * 2
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