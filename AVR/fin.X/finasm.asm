.dseg                        ; switch to data memory 1
.org 0x100                   ; from address 0x100 (do not use addresses 0 - 0x100)

flag: .byte 1                ; reserving space for 1 byte

.cseg                        ; switch to program memory
; subroutines for work with the display
.org 0x1000
.include "printlib.inc"

; Program start - after reset
.org 0
    jmp start
.org 0x16                    ; 2
    jmp interrupt

.org 0x100

start:
    ; Initialization of the display
    call init_disp
    ; Initialization of the timer interrupt
    call init_int

    ldi r16, 0               ; 3
    sts flag, r16

    ldi r17, 0
    ldi r16, '0'
    call show_char

main_loop:
    lds r20, flag
    cpi r20, 0               ; loading and testing the flag value
    breq main_loop           ; if there is no flag -> return to the start of the loop
                             ; there is the flag
    ldi r20, 0               ; clear the flag
    sts flag, r20

    ; event triggered 1x per second 4
    inc r16
    ; Check if character needs to roll over
    cpi r16, 58           ; Compare r16 with ASCII for ':'
    brlt no_reset         ; If less, no need to reset
    ldi r16, '0'          ; Reset to '0'
no_reset:
    call show_char        ; Update the display with the current character
    jmp main_loop

end: jmp end

init_button:
    push r16
    ; enable AD converter and set pre-divider
    ; (set the ADEN bit in memory at address ADCSRA without affecting the other bits) 1
    lds r16, ADCSRA
    ori r16, (1<<ADEN) | (0b010<<ADPS0); 2
    sts ADCSRA, r16

    ; set reference voltage (0b01<<REFS0)
    ; set output alignment to the left (1<<ADLAR) 3
    ldi r16, (0b01<<REFS0) | (1<<ADLAR); 4
    sts ADMUX, r16

    pop r16
    ret
    
init_int:                    ; 5
    push r16
    cli                      ; global interrupt disable

    ; clear the current value of the TCNT1 timer/counter
    ;    (so that the first second does not start midway through a second)
    ; Do not change the order of storing TCNT1H and TCNT1L
    ;     - the value might not be stored correctly!
    clr r16
    sts TCNT1H, r16
    sts TCNT1L, r16

    ; interrupt enable when the TCNT1 timer/counter reaches the OCR1A value
    ldi r16, (1<<OCIE1A)
    sts TIMSK1, r16

    ; set to clear the TCNT1 counter when it reaches the OCR1A value (1<<WGM12)
    ; set pre-divider to 1024 (0b101<<CS10 - bits CS12, CS11 and CS10 are consecutive)
    ldi r16, (1<<WGM12) | (0b101<<CS10)
    sts TCCR1B, r16

    ; setting of OCR1A, i.e., the resulting cut-off frequency
    ; interrupt frequency = frequency of chip 328P / pre-divison / (OCR1A+1)
    ; the frequency of the 328P chip is 16 MHz, i.e. 16 000 000
    ; the pre-divider is set to 1024
    ; we want the interruption frequency to be 1 Hz
    ; OCR1A = (frequency of chip 328P / pre-divison / interrupt frequency) - 1
    ; OCR1A = (16000000 / 1024 / 1) - 1
    ; OCR1A = 15624
    ; 16bit value must be set in two registers OCR1AH:OCR1AL
    ; 15624 = 61 * 256 + 8              ; 6
    ; Do not change the order of storing TCNT1H and TCNT1L
    ;     - the value might not be stored correctly!
    ldi r16, 61
    sts OCR1AH, r16
    ldi r16, 8
    sts OCR1AL, r16

    sei                     ; global interrupt enable
    pop r16
    ret

interrupt:                  ; 6
    ; store register and SREG
    push r16
    in r16, SREG
    push r16

    ; set the flag
    ldi r16, 1
    sts flag, r16

    ; restore SREG and register
    pop r16
    out SREG, r16
    pop r16
    reti                ; 7
