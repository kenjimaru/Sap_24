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
    
    ldi r16, 5
    ldi r17, 10
    ldi r18, 17 ; 66 : no precision error | 17: precision loss when shifting

    ; Extend r16 to 16 bits (r21:r20)
    mov r20, r16
    ldi r21, 0
    sbrc r20, 7
    ldi r21, 0xFF

    ; Extend r17 to 16 bits (r23:r22)
    mov r22, r17
    ldi r23, 0
    sbrc r22, 7
    ldi r23, 0xFF

    ; Extend r18 to 16 bits (r25:r24)
    mov r24, r18
    ldi r25, 0
    sbrc r24, 7
    ldi r25, 0xFF

    ; Multiply r20 by 4
    ldi r26, 4
    mul r20, r26
    mov r20, r0	; Lower byte of result
    mov r21, r1	; Higher byte of result
    clr r1

    ; Multiply r22 by 3
    ldi r26, 3
    mul r22, r26
    mov r22, r0	; Save multiplication result temporarily
    mov r23, r1
    clr r1

    ; Add results of multiplications
    add r20, r22
    adc r21, r23

    ; Subtract r25:r24 from r21:r20
    sub r20, r24
    sbc r21, r25
    
    mov r26, r20    
    andi r26, 0x07  ; Isolate the lowest 3 bits
    cpi r26, 0x00   ; Compare Isolated bits to 0
    breq noError
    
    ldi r16, 'E'
    ldi r17, 5
    call show_char
    ldi r16, 'R'
    ldi r17, 6
    call show_char
    ldi r16, 'R'
    ldi r17, 7
    call show_char
    ldi r16, 'O'
    ldi r17, 8
    call show_char
    ldi r16, 'R'
    ldi r17, 9
    call show_char
    
noError:
    
    ; Arithmetic right shift by 3 (division by 8)
    asr r21
    ror r20
    asr r21
    ror r20
    asr r21
    ror r20

    ; The result is now stored in r21:r20
    clr r22
    clr r23
    
    ldi r17, 0
    mov r22, r21
    call getHighNibbles
    
    ldi r17, 1
    mov r22, r21
    call getLowNibbles
    
    ldi r17, 2
    mov r22, r20
    call getHighNibbles
    
    ldi r17, 3
    mov r22, r20
    call getLowNibbles
    
end:
    jmp end ; Infinite loop to stop the program

getHighNibbles:
    andi r22, 0xF0
    lsr r22
    lsr r22
    lsr r22
    lsr r22
    call asciiConvert
    mov r16, r22
    call show_char
    ret
    
getLowNibbles:
    andi r22, 0x0F
    call asciiConvert
    mov r16, r22
    call show_Char
    ret
    
asciiConvert:
    cpi r22, 10
    brlo Digit 
    subi r22, -7
    
Digit:
    subi r22, -48
    ret