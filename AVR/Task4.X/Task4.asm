.dseg
.org 0x0100  
; Defining memory space for display content.
digit_counts:   .byte 9   ; Array to store counts for digits 1-9
upper_counts:   .byte 26   ; Array for uppercase letters A-Z
lower_counts:   .byte 26   ; Array for lowercase letters a-z

.cseg
.org 0x1000	
.include "printlib.inc"  ; Include library for display routines
    
.org 0
rjmp start   ; Jump to start after reset   
 
.org 0x100
str: .db "NQWERTYUIOPLKJHGFDSAZCVBNM 123 4 342 5135 4 snghwycoob[wbfd sfe",0 ; Define a string in program memory

start:
; Initialize stack
    ldi r16, HIGH(RAMEND)
    out SPH, r16
    ldi r16, LOW(RAMEND)
    out SPL, r16

; Initialize display
    call init_disp
    ldi r18, 16    ; Set display length

    ldi r30, low(str)	; Load starting memory address
    ldi r31, high(str)

    ldi r16, 0x00   ; Zero to initialize the array elements

    ; Initialize digit_counts
    ldi r26, low(digit_counts)
    ldi r27, high(digit_counts)
    ldi r18, 9        

init_digit_counts:
    st X+, r16
    dec r18
    brne init_digit_counts

    ; Initialize upper_counts
    ldi r26, low(upper_counts)
    ldi r27, high(upper_counts)
    ldi r18, 26  

init_upper_counts:
    st X+, r16
    dec r18
    brne init_upper_counts

    ; Initialize lower_counts
    ldi r26, low(lower_counts)
    ldi r27, high(lower_counts)
    ldi r18, 26              

init_lower_counts:
    st X+, r16
    dec r18
    brne init_lower_counts
;The fun start
counter:
    lpm r22, Z+
    tst r22
    breq call_display
    
    cpi r22, '0'
    brlo special
    cpi r22, ':'
    brsh non_digit
   
digit:
    subi r22, '1'
    ldi r26, low(digit_counts)
    ldi r27, high(digit_counts)
    add r26, r22
    ld r21, X
    inc r21
    st X, r21
    jmp counter

non_digit:
    cpi r22, 'A'
    brlo special
    cpi r22, '['
    brsh non_upper
    
upper:
    subi r22, 'A'
    ldi r26, low(upper_counts)
    ldi r27, high(upper_counts)
    add r26, r22
    ld r21, X
    inc r21
    st X, r21
    jmp counter
    
non_upper:
    cpi r22, 'a'
    brlo special
    cpi r22, '{'
    brsh special
 
lower:
    subi r22, 'a'
    ldi r26, low(lower_counts)
    ldi r27, high(lower_counts)
    add r26, r22
    ld r21, X
    inc r21
    st X, r21
    jmp counter
    
special:
;Ignored.
    jmp counter	
;Time to scroll the display
call_display:
    ldi r18, 0 ;array_pointer
    ldi r19, 0 ;screen_index
    ldi r20, 0 ;char_type
    ldi r21, 0 ;page_count
    ldi r26, low(digit_counts)
    ldi r27, high(digit_counts)
    ldi r18, 9
    call loop
    ldi r20, 1
    ldi r26, low(upper_counts)
    ldi r27, high(upper_counts)
    ldi r18, 26
    call loop
    ldi r18, 26
    ldi r20, 2
    ldi r26, low(lower_counts)
    ldi r27, high(lower_counts)
    call loop
    call clr_dsp
    jmp call_display

loop:
    ld r22, X+
    tst r22
    breq next_loop ; Check if r22 is zero, if yes skip
    cpi r20, 2
    breq lower_loop
    cpi r20, 1
    breq upper_loop
    ;digit_loop
	ldi r16, 58
	call print
	jmp loop_end
    upper_loop:
	ldi r16, 91
	call print
	jmp loop_end
    lower_loop:
	ldi r16, 123
	call print

    loop_end:
	inc r19
	cpi r19, 16
	brne next_loop
	call clr_dsp
	clr r19
    next_loop:
	dec r18
	tst r18
	brne loop
	ret
	
    print:
	call upper_print
	call set_cursor
	ldi r16, 48
	add r16, r22
	call lcd_send_data
	ret
	
    upper_print:
	sub r16, r18
	mov r17, r19
	call show_char
	ret
	
    set_cursor:
	push r16
	ldi r16, 0x40
	add r16, r19
	call lcd_set_ddram_addr
	pop r16
	ret
	
clr_dsp:
    ldi r23, 3
    ldi r16, 250
    delay:
	ldi r17, 250
    delay2:
	dec r17
	brne delay2
	dec r16
	brne delay
    dec r23
    tst r23
    brne delay
    call lcd_clear
    clr r19
    ret