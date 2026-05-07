; STUB.ASM - template
.MODEL small
.STACK 100h

.CODE
start:
    ; === Your code here ===
    

    ; === End of your code ===
    mov ah, 4Ch
    int 21h
end start

; PSP:0000    CD 20         
; PSP:0080    0Bh - Довжина командного рядка 
; PSP:0081    " hello world 123"  перший символ пробіл
; PSP:002C    1F40h        

; Command line у PSP починається з пробілу 
; Environment block містить null-terminated рядки