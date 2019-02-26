    #include p18f87k22.inc
    
    global interupt_setup,hit_left,hit_right
    
     extern  score,ms_delay

    acs0    udata_acs
    hit	    res 1

	
hit_int	code	0x0008
	btfss	INTCON, RBIF	;check if it was an interrupt caused by PORTB
	retfie	1		;rturns to where the interrupt has been called from
	call	score		;call the scoring systemn and stop the time	
	bcf	INTCON, RBIF	;Clear flag bit
	retfie	1

	
	
hit code
	
interupt_setup	    ;look at example code in presentation and can see only enables certain bits
		    ;doesn't reset the whole SFR
	bsf	INTCON2, RBPU
	bcf	RCON, 7
	bsf	INTCON, RBIE	;Enable PORTB interrupts
	;bsf	INTCON, TMR0IE	;Enable Timer interupt
	bsf	INTCON, GIE	;Enable all interrupts
	
	;bsf
	return
	

	
hit_left
	bsf	hit,1	    ;note that left has hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	bsf	hit,0	    ;prevent other fencer's hit from registering
	goto	lights
hit_right
	bsf	hit,2	    ;note that right has hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	bsf	hit,0	    ;prevent other fencer's hit from registering
	goto	lights

lights	
;	movlw	0xFF
;	movwf	PORTE
	btfsc	hit,1
	bsf	PORTE,0
	btfsc	hit,2
	bsf	PORTE,7
	movlw	0xFF
	call	ms_delay
	movlw	0xFF
	call	ms_delay
	movlw	0xFF
	call	ms_delay
	movlw	0xFF
	call	ms_delay
	movlw	0xFF
	call	ms_delay
	movlw	0xFF
	call	ms_delay
	movlw	0x00
	movwf	hit
	movwf	PORTE
	return
	

	

    end
