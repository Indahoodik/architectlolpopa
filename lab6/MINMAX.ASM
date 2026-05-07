; MINMAX.ASM
.MODEL small
.STACK 100h

.DATA
arr1    DW 5, -3, 12, 0, -7, 8
N1      EQU ($ - arr1) / 2

arr2    DW 42
N2      EQU ($ - arr2) / 2

arr3    DW -1, -2, -3
N3      EQU ($ - arr3) / 2

.CODE
start:

    mov ax, @data
    mov ds, ax

    ; --- Тест 1 ---
    push N1
    push offset arr1
    call find_min_max
    add sp, 4
    ; AX = FFF9h (-7)
    ; BX = 000Ch (12)

    ; --- Тест 2 ---
    push N2
    push offset arr2
    call find_min_max
    add sp, 4
    ; AX = 002Ah (42)
    ; BX = 002Ah (42)

    ; --- Тест 3 ---
    push N3
    push offset arr3
    call find_min_max
    add sp, 4
    ; AX = FFFDh (-3)
    ; BX = FFFFh (-1)

    mov ah, 4Ch
    int 21h



find_min_max proc

    push bp
    mov bp, sp

    push si
    push cx
    push dx

    mov si, [bp+4]      ; SI = адреса масиву
    mov cx, [bp+6]      ; CX = кількість елементів

    ; --- ініціалізація min і max першим елементом ---
    mov ax, [si]        ; AX = min
    mov bx, ax          ; BX = max

    add si, 2           ; перейти до другого елемента
    dec cx              ; один вже обробили
    jcxz mm_done        ; якщо був один елемент

mm_loop:

    mov dx, [si]        ; DX = поточний елемент

    ; ---- перевірка на мінімум ----
    cmp dx, ax
    jl  new_min

check_max:
    cmp dx, bx
    jg  new_max
    jmp next_elem

new_min:
    mov ax, dx
    jmp check_max

new_max:
    mov bx, dx

next_elem:
    add si, 2
    loop mm_loop

mm_done:
    pop dx
    pop cx
    pop si
    pop bp
    ret

find_min_max endp

end start