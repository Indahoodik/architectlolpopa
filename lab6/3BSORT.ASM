.MODEL small
.STACK 256

.DATA
arr     DW 64, 34, 25, 12, 22, 11, 90
N       EQU ($ - arr) / 2

.CODE
main:
    mov ax, @data
    mov ds, ax

    ; Check array in Dump BEFORE sorting
    ; (set breakpoint here: F2)

    push N
    push offset arr
    call bubble_sort
    add sp, 4

    ; Check array in Dump AFTER sorting
    ; Expected: 11, 12, 22, 25, 34, 64, 90

    mov ah, 4Ch
    int 21h

;----------------------------------------------
; bubble_sort - sorts a word array ascending
; Params: [BP+4] = array offset
;         [BP+6] = element count
; Sorts the array in place
;----------------------------------------------
bubble_sort proc
    push bp
    mov bp, sp
    push si
    push cx
    push dx

    mov cx, [bp+6]       ; CX = N
    dec cx               ; N-1 passes
    jcxz bs_done

bs_outer:
    push cx              ; save outer loop counter
    mov si, [bp+4]       ; SI = array start
    mov dx, cx           ; DX = comparisons this pass

bs_inner:

    ; --- YOUR CODE HERE (4-5 lines) ---
        mov ax, [si]      ; AX = лівий
    cmp ax, [si+2]        ; порівнять лівий та правий
    jbe bs_no_swap        ; лівий менший за правий

    xchg ax, [si+2]       ; міняємо AX і правий елемент місцями
    mov [si], ax          ; записуємо менше значення в ліву комірку

bs_no_swap:
    add si, 2            ; next pair
    dec dx
    jnz bs_inner

    pop cx               ; restore outer counter
    loop bs_outer

bs_done:
    pop dx
    pop cx
    pop si
    pop bp
    ret
bubble_sort endp

END main