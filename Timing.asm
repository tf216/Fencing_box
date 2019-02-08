    #include p18f87k22.inc
    global  ms_delay, delay_x4us

acs0    udata_acs   ; named variables in access ram
delay_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
delay_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
delay_cnt_ms  res 1   ; reserve 1 byte for ms counter

 
timing	code


ms_delay	    ; delay given in ms in W
	movwf	delay_cnt_ms	;store milliseconds to be delayed in delay_cnt_ms
delay_loop1
	movlw	.250		;1 ms delay
	call	delay_x4us	;call delay_x4us
	decfsz	delay_cnt_ms	;move to next millisecond delay and skip next line if 0
	bra	delay_loop1	;perform another millisecond delay
	return
    
delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	delay_cnt_l   ; now need to multiply by 16
	swapf   delay_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	delay_cnt_l,W ; move low nibble to W
	movwf	delay_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	delay_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	delay
	return

delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
delay_loop2
	decf 	delay_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	delay_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	delay_loop2		; carry, then loop again
	return			; carry reset so return

    end