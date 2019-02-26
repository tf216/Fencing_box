    #include p18f87k22.inc
    
    global interupt_setup,hit_left,hit_right
    
     extern  score,ms_delay

    acs0    udata_acs
    hit	    res 1

	
hit_int	code	0x0008
	btfsc	INTCON, RBIF	;check if it was an interrupt caused by PORTB
	call	test		;returns to where the interrupt has been called from
				;call the scoring systemn and stop the time	
;	bcf	INTCON, RBIF	;Clear flag bit
;	bcf	INTCON,	TMR0IF	;Clear timer flag
;	bcf	INTCON, TMR0IE
	incf	LATE
	bcf	INTCON,	TMR0IF	;Clear timer flag
	

	
	movlw	0xF6		;start a timer
	;movwf	0x00
	movwf	TMR0H
	movlw	0xB8
	;movwf	0x00
	movwf	TMR0L
	
	retfie	FAST

	
	
hit code
 	
interupt_setup	    ;look at example code in presentation and can see only enables certain bits
		    ;doesn't reset the whole SFR
	bcf	INTCON, RBIF
	bcf	INTCON,	TMR0IF
	bsf	INTCON2, RBPU
	bcf	RCON, 7
	bsf	INTCON, RBIE	;Enable PORTB interrupts
	bsf	INTCON, GIE	;Enable all interrupts	
	
	movlw	b'10000111'	;set prescaler for 16 bit, prescaler to 64KHz
	movwf	T0CON		
	return
	
hit_check
	bcf	INTCON,TMR0IF
	;movlw	0xF6		;start a timer
	movwf	0x00
	movwf	TMR0H
	;movlw	0xB8
	movwf	0x00
	movwf	TMR0L
	bsf	INTCON, TMR0IE
    
	btfsc	PORTB,4
	bsf	hit,1
	btfsc	PORTB,5
	bsf	hit,2
	return
	
	
hit_left
	bsf	hit,1	    ;note that left has hit
	retfie	1

hit_right
	bsf	hit,2	    ;note that right has hit
	retfie	1

lights	

	btfsc	hit,1
	bsf	PORTE,0
	btfsc	hit,2
	bsf	PORTE,7

	movlw	0x00
	movwf	hit
	movwf	PORTE
	call	score
	return
	
test	bsf	INTCON, TMR0IE
	retfie	1
	
	

	

    end
