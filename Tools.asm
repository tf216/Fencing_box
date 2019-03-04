    include p18f87k22.inc
;    
    global time_test
    extern hit_delay, ms_delay
;    
    
tools code
 
time_test			;toggle port E bit 1 to time how long a hit will register for
    bsf PORTE,1			;toggle port E
    call hit_delay		;call hit delay
    bcf	PORTE,1			;toggle port E
    movlw 0XFF			; wait before toggling again
    call ms_delay
    bra time_test
    
    

    end