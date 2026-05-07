; hello.asm — перша програма x86-64 для Linux
; Аналог DOS-програми з INT 21h/09h, але через syscall

section .data
    msg db "Hello from x86-64!", 10    ; 10 = '\n' (новий рядок)
    msg_len equ $ - msg                ; довжина рядка (обчислюється автоматично)

section .text
    global _start

_start:
    ; --- Вивести рядок (аналог INT 21h/09h) ---
    mov rax, 1              ; syscall номер 1 = sys_write
    mov rdi, 1              ; file descriptor 1 = stdout
    mov rsi, msg            ; адреса рядка
    mov rdx, msg_len        ; довжина рядка
    syscall

    ; --- Вийти з програми (аналог INT 21h/4Ch) ---
    mov rax, 60             ; syscall номер 60 = sys_exit
    xor rdi, rdi            ; код виходу 0
    syscall

; 1. syscall
; 2. регістр RAX

; 3. секції NASM: section .data, section .text

; 4. глобальний символ global _start

; 5. msg_len equ $ - msg
; довжина обчислюється як різниця між поточною адресою і початком рядка

; 2.2

; 1. RAX = 1      RDI = 1     
; RSI = адреса msg (рядка "Hello from x86-64!")
; RDX = довжина рядка (msg_len)
; 2. RAX = кількість записаних байтів
; 3. RSI містить адресу рядка msg у пам'яті
