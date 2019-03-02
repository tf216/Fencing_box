    #include p18f87k22.inc
    
    ;Import all external functions needed
    extern  time_setup, time_loop, ms_delay
    extern  LCD_Setup
    extern  score_setup
    extern  interupt_setup
    
    
;rst code    0    ; reset vector
;    goto    setup
    

	
main	code		;point to starting point in code and setup all functions
    org 0x0		
    goto    setup
    org 0x100	

 
setup
    call    LCD_Setup	; setup LCD
    call    score_setup	; setup scoring system
    call    time_setup	; setup timeing system
    call    interupt_setup  ;setup the interrupt
    clrf    TRISE	; Make PORTE write
    bsf	    TRISE,1	;Except pin1, which resets time
    goto    time_loop	;got to the start of the code
    
    
    end