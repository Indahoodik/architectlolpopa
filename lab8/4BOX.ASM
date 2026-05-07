.MODEL small
.STACK 256

.DATA
BOX_R1  EQU 5               ; Верхній рядок
BOX_C1  EQU 20              ; Ліва колонка
BOX_R2  EQU 18              ; Нижній рядок
BOX_C2  EQU 60              ; Права колонка
BOX_CLR EQU 1Fh             ; Білий на синьому

.CODE
main:
    mov ax, @data
    mov ds, ax
    mov ax, 0B800h
    mov es, ax

    ; Очистка 
    xor di, di
    mov cx, 80 * 25
    mov ax, 0720h
@cls:
    mov es:[di], ax
    add di, 2
    loop @cls

    ; ВЕРХНЯ РАМКА 
    mov di, (BOX_R1 * 80 + BOX_C1) * 2
    mov ah, BOX_CLR

    mov al, 0C9h             ; ╔
    mov es:[di], ax
    add di, 2

    mov cx, BOX_C2 - BOX_C1 - 1
    mov al, 0CDh             ; ═
@top:
    mov es:[di], ax
    add di, 2
    loop @top

    mov al, 0BBh             ; ╗
    mov es:[di], ax


    mov di, ((BOX_R1 + 1) * 80 + BOX_C1) * 2
    mov cx, BOX_R2 - BOX_R1 - 1
    mov ah, BOX_CLR
    mov al, 0BAh             ; ║

@side:
    mov es:[di], ax                              ; ліва сторона
    mov es:[di + (BOX_C2 - BOX_C1)*2], ax        ; права сторона

    add di, 160                                  ; наступний рядок
    loop @side


    mov di, (BOX_R2 * 80 + BOX_C1) * 2
    mov ah, BOX_CLR

    mov al, 0C8h             
    mov es:[di], ax
    add di, 2

    mov cx, BOX_C2 - BOX_C1 - 1
    mov al, 0CDh             
@bottom:
    mov es:[di], ax
    add di, 2
    loop @bottom

    mov al, 0BCh             
    mov es:[di], ax

    mov ah, 00h
    int 16h

    mov ah, 4Ch
    int 21h

END main