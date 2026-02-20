; routines for work with display
.org 0x1000
.include "printlib.inc"
    
;start the program - after reset
.org 0
    jmp start

; start of the program - main
.org 0x100
start:
    ;display initialization
    call init_disp
    
    
    ldi r16, 0x5A
    
    mov r18, r16
    mov r19, r16 
    andi r18, 0xF0
    lsr r18
    lsr r18
    lsr r18
    lsr r18
    call asciiConvert
    mov r16, r18
    ldi r17, 0
    call show_char
    mov r16, r19
    
    mov r18, r16
    andi r18, 0x0F
    call asciiConvert
    mov r16, r18
    ldi r17, 1
    call show_char

end:
    jmp end
    
    asciiConvert:
	cpi r18, 10
	brlo Digit 
	subi r18, -7

    Digit:
	subi r18, -48
	ret