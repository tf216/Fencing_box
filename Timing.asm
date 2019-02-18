    #include p18f87k22.inc
    global  ms_delay, delay_x4us
    global  time_setup, time_loop, LCD_write,time_loop
   
    extern  write_score, LCD_clear, LCD_Send_Byte_I, LCD_Send_Byte_D, score

acs0    udata_acs   ; named variables in access ram
delay_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
delay_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
delay_cnt_ms  res 1   ; reserve 1 byte for ms counter


time_min   res 1    ; reserve 1 byte for variable time_min
time_min_counter    res	1
time_sec    res 1   ; reserve 1 byte for variable time_sec
time_10sec	res 1
time_sec_counter    res	1
time_10sec_counter  res	1
 
  
  
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
	


time_setup
    movlw   0x30
    movwf   time_sec
    movlw   0x01
    movwf   time_sec_counter
    movlw   0x01
    movwf   time_10sec_counter
    movlw   0x30
    movwf   time_10sec
    movlw   0x33
    movwf   time_min
    movlw   0x04
    movwf   time_min_counter
    
    return
	
    
time_loop
    btfsc   PORTD,0
    call    score
    call    LCD_write
    
    
    movlw   0x50
    call    ms_delay
    movlw   0xFF
    ;call    ms_delay
    ;call    LCD_clear
    
    movlw   0x01
    subwf   time_sec
    decfsz  time_sec_counter
    bra	    time_loop
    movlw   0x39
    movwf   time_sec
    movlw   0x0A
    movwf   time_sec_counter
    movlw   0x01
    subwf   time_10sec
    decfsz  time_10sec_counter
    bra	    time_loop
    
    movlw   0x39
    movwf   time_sec
    movlw   0x0A
    movwf   time_sec_counter
    movlw   0x35
    movwf   time_10sec
    movlw   0x06
    movwf   time_10sec_counter
    movlw   0x01
    subwf   time_min
    decfsz  time_min_counter
    bra	    time_loop
    
    goto    $
    
LCD_write
    call    LCD_clear
    movf    time_min,W
    call    Clock_write
    movlw   0x3A
    call    Clock_write
    movf    time_10sec,W
    call    Clock_write
    movf    time_sec,W
    call    Clock_write
    
    
    movlw   .168
    call    LCD_Send_Byte_I
    movlw   0x01	
    call    ms_delay
    call    write_score
    return

Clock_write
    call	LCD_Send_Byte_D
    movlw	0x01	
    call	ms_delay
    return
    
    return
    
test
    goto    $

	

    end