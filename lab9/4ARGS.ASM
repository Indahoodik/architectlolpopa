.MODEL tiny
.CODE
ORG 100h

start:
    mov cl, ds:[80h]       ; CL = command tail length
    xor ch, ch
    cmp cx, 0
    je no_args

    mov si, 81h            ; SI → command tail
    xor bx, bx             ; BL = state: 0 = in spaces, 1 = in argument
                            ; BH = argument count

parse_loop:
    lodsb                   ; AL = next byte from [SI], SI++
    cmp al, 0Dh            ; Carriage return? (end of tail)
    je parse_done

    cmp al, ' '
    je got_space

    ; --- Not a space: we have a printable character ---
    cmp bl, 0              ; Якщо ми були в пробілах?
    jne already_in_arg      ; Якщо BL=1, вже всередині аргументу

    ; Початок нового аргументу
    mov bl, 1               ; тепер ми в аргументі
    inc bh                  ; збільшуємо номер аргументу
    call print_arg_header

already_in_arg:
    mov dl, al              ; виводимо символ
    mov ah, 02h
    int 21h
    jmp check_done

got_space:
    mov bl, 0               ; повертаємося у стан "в пробілах"

check_done:
    loop parse_loop

parse_done:
    ; Print final newline
    mov ah, 09h
    mov dx, offset crlf
    int 21h

    ; Print total count
    mov ah, 09h
    mov dx, offset msg_count
    int 21h
    mov dl, bh
    add dl, '0'            ; Convert count to ASCII digit (works for 0-9)
    mov ah, 02h
    int 21h
    mov ah, 09h
    mov dx, offset crlf
    int 21h

    jmp done

no_args:
    mov ah, 09h
    mov dx, offset msg_none
    int 21h

done:
    mov ah, 4Ch
    int 21h

;----------------------------------------------
; print_arg_header - prints newline + "  Arg N: "
; Input: BH = argument number (1-based, already incremented)
; Preserves: AX, DX (saved/restored on stack)
;----------------------------------------------
print_arg_header proc
    push ax
    push dx
    ; Newline + prefix
    mov ah, 09h
    mov dx, offset prefix
    int 21h
    ; Argument number
    mov dl, bh
    add dl, '0'
    mov ah, 02h
    int 21h
    ; Colon and space
    mov ah, 09h
    mov dx, offset colon
    int 21h
    pop dx
    pop ax
    ret
print_arg_header endp

; --- Data ---
prefix    DB 0Dh, 0Ah, '  Arg $'
colon     DB ': $'
crlf      DB 0Dh, 0Ah, '$'
msg_count DB 'Count: $'
msg_none  DB 'No arguments.', 0Dh, 0Ah, '$'

END start