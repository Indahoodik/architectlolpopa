.MODEL tiny
.CODE
ORG 100h

start:
    ; --- Read command tail length ---
    mov cl, ds:[80h]       ; CL = length of command tail
    xor ch, ch             ; CX = length (zero-extend)
    cmp cx, 0
    je no_args             ; No arguments? Skip to message

    ; --- Display header ---
    mov ah, 09h
    mov dx, offset hdr
    int 21h

    ; --- Print the command tail character by character ---
    mov si, 81h            ; SI → first byte of command tail

print_loop:
    lodsb                  ; AL = [DS:SI], SI++
    mov dl, al             ; символ у DL
    mov ah, 02h            ; DOS: вивід символу
    int 21h
    loop print_loop        ; повторюємо CX разів

    ; --- Newline after output ---
    mov ah, 09h
    mov dx, offset crlf
    int 21h

    jmp done

no_args:
    mov ah, 09h
    mov dx, offset none
    int 21h

done:
    mov ah, 4Ch
    int 21h

hdr  DB 'Tail: $'
none DB 'No arguments provided.', 0Dh, 0Ah, '$'
crlf DB 0Dh, 0Ah, '$'

END start