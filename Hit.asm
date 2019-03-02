    #include p18f87k22.inc
    
    global interupt_setup,hit_left,hit_right,hit
    
     extern  score,ms_delay,delay_x4us

acs0    udata_acs
hit	res 1
	
delay_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
delay_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
delay_cnt_ms  res 1   ; reserve 1 byte for ms counter

	
hit_int	code	0x0008
	btfss	INTCON, RBIF	;check if it was an interrupt caused by PORTB
	retfie	1		;rturns to where the interrupt has been called from
	
	call	hit_delay
	call	lights
	bsf	hit,0	;call the scoring systemn and stop the time	
	bcf	INTCON, RBIF	;Clear flag bit
	retfie	1

	
	
hit code
	
interupt_setup	    ;look at example code in presentation and can see only enables certain bits
		    ;doesn't reset the whole SFR
	bsf	INTCON2, RBPU
	bcf	RCON, 7
	bsf	INTCON, RBIE	;Enable PORTB interrupts
	bcf	TRISB,6
	bcf	TRISB,7
	bsf	INTCON, GIE	;Enable all interrupts
	return
;******These lines of code are useless, but somehow the programme will not build without them******
hit_left
	bsf	hit,1	    ;note that left has hit
	movlw	0xFF
	call	ms_delay    ;delay where other fencer can hit
	bsf	hit,0	    ;prevent other fencer's hit from registering
	goto	lights
hit_right
	bsf	hit,2	    ;note that right has hit
	bsf	hit,0	    ;prevent other fencer's hit from registering
	goto	lights
;******* useful code again********
lights	
	btfsc	hit,1
	bsf	LATE,0
	btfsc	hit,2
	bsf	LATE,7
	movlw	0xFF
	call	ms_delay
	movlw	0xFF
	call	ms_delay
	movlw	0x00
	movwf	hit
	movwf	PORTE
	return
	
hit_delay			;delay for maximum amount of time to make double obvious. would be .38 for real box
	movlw	0xFF
	movwf	delay_cnt_ms	;store milliseconds to be delayed in delay_cnt_ms
delay_loop1
	movlw	.250		;1 ms delay
	btfsc	PORTB,4
	bsf	hit,1
	btfsc	PORTB,5
	bsf	hit,2
	call	delay_x4us	;call delay_x4us
	decfsz	delay_cnt_ms	;move to next millisecond delay and skip next line if 0
	bra	delay_loop1	;perform another millisecond delay
	return
	

	

    end
