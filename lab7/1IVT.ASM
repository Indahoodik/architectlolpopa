.model small
.stack 100h

.code
start:
    mov ax, @data
    mov ds, ax

    mov ah, 4Ch
    int 21h


;IVT

; INT 21h (DOS):
; адреса в IVT: 0000:0084
; handler: XXXX:XXXX

; INT 10h (Video BIOS):
; адреса в IVT: 0000:0040
; handler: XXXX:XXXX

; INT 00h (Divide by zero):
; адреса в IVT: 0000:0000
; handler: XXXX:XXXX


;BIOS DATA AREA 

; 0040:006C — системний таймер (DWORD)
; значення постійно збільшується (~18.2 разів за секунду)

; 0040:001A — head pointer клавіатурного буфера
; 0040:001C — tail pointer клавіатурного буфера

; при натисканні клавіш значення змінюються,
; у діапазоні 0040:001E–0040:003D з’являються scan-коди клавіш


end start