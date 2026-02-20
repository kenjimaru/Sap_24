; Program start - after reset
.org 0
jmp start

; Start of program - main program
.org 0x100 ;
start:

     ldi r16, 5
     ldi r17, 10
     ldi r18, 66
     
     lsl r16
     lsl r16
     
     mov r19, r17     
     lsl r17
     lsl r17
     sub r17, r19     

     add r16, r17
     brvs OVERFLOW
     sub r16, r18
     brvs OVERFLOW
     
     asr r16
     asr r16
     asr r16
     mov r20, r16

OVERFLOW:
    ldi r19, 1
    jmp OVERFLOW
     
end: 
    ldi r19, 0
    jmp end ; Stop the program - infinite loop 