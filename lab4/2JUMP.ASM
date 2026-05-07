.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===
    
    mov ax, 0FFFFh      ; Яке це число? signed: ___ unsigned: ___
    cmp ax, 1
    jg  is_greater      ; signed comparison: перехід буде?
    ; ja is_greater  - беззнакове порівняння
    jmp not_greater

is_greater:
    mov bx, 1           ; маркер: "перейшли"
    jmp done

not_greater:
    mov bx, 0           ; маркер: "не перейшли"

done:
    ; перевірте BX у TD
    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start