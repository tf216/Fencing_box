    #include p18f87k22.inc
    
     global interupt_setup
   
     extern  score,ms_delay
    
    acs0    udata_acs
    hit	    res 1


	
hit_int	code	0x0008
	btfsc	hit,0
	retfie	1
	btfss	INTCON, RBIE	;check if it was an interrupt caused by PORTB
	retfie	1
	btfsc	PORTB, 4
	call	hit_left		;returns to where the interrupt has been called from
	btfss	PORTB, 5
	call	hit_right
	btfsc	INTCON,RBIE
	call	score		;call the scoring systemn and stop the time	
	bcf	INTCON, RBIF	;Clear flag bit
	retfie	1		;returns to where the interrupt has been called from

	
	
hit code
	
interupt_setup	    ;look at example code in presentation and can see only enables certain bits
		    ;doesn't reset the whole SFR
	bsf	INTCON2, RBPU
	bcf	RCON, 7
	bsf	INTCON, RBIE	;Enable PORTB interrupts
	bsf	INTCON, GIE	;Enable all interrupts
	movlw	0x00
	movwf	hit
	return

hit_left
	bsf	hit,1	    ;note that left has hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	bsf	hit,0	    ;prevent other fencer's hit from registering
	goto	lights
hit_right
	bsf	hit,2	    ;note that right has hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	bsf	hit,0	    ;prevent other fencer's hit from registering
	goto	lights
	
lights	
	btfsc	hit,1
	bsf	PORTG,0
	btfsc	hit,2
	bsf	PORTG,7
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
	movwf	PORTG
	return
	

	

    end
