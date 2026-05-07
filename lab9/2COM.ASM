.MODEL tiny
.CODE
ORG 100h

start:
    mov ah, 09h
    mov dx, offset msg
    int 21h

    mov ah, 4Ch
    int 21h

msg DB 'I am a COM program!', 0Dh, 0Ah, '$'

END start


;   CS = 1234h
;   DS = CS
;   ES = CS
;   SS = CS
;   IP = 0100h 

;   CS = 5678h
;   DS = 9ABCh
;   IP = 0000h 