.MODEL small
.STACK 100h

.DATA
arr1    DW 64, 34, 25, 12, 22, 11, 90
N1      EQU ($ - arr1) / 2

arr2    DW 5, -3, 12, 0, -7, 8
N2      EQU ($ - arr2) / 2

.CODE
start:

    mov ax, @data
    mov ds, ax


    push N1
    push offset arr1
    call insertion_sort
    add sp, 4
    ; 11, 12, 22, 25, 34, 64, 90

    push N2
    push offset arr2
    call insertion_sort
    add sp, 4
    ; -7, -3, 0, 5, 8, 12

    mov ah, 4Ch
    int 21h


insertion_sort proc

    push bp
    mov bp, sp

    push bx
    push cx
    push dx
    push si
    push di

    mov bx, [bp+4]      ; BX = адреса масиву
    mov cx, [bp+6]      ; CX = N
    cmp cx, 1
    jle is_done         

    mov si, 2           

outer_loop:

    mov ax, [bx+si]     ; key = arr[i]
    mov di, si
    sub di, 2           ; j = i - 1 (у байтах)

inner_loop:

    cmp di, 0
    jl  insert_key      ; якщо j < 0 → вставляємо key

    mov dx, [bx+di]     ; DX = arr[j]
    cmp dx, ax
    jle insert_key      ; якщо arr[j] <= key → місце знайдено

    ; --- зсув вправо ---
    mov [bx+di+2], dx   ; arr[j+1] = arr[j]
    sub di, 2           ; j = j - 1
    jmp inner_loop

insert_key:
    mov [bx+di+2], ax   

    add si, 2           
    dec cx
    cmp cx, 1
    jg outer_loop

is_done:

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop bp
    ret

insertion_sort endp

end start