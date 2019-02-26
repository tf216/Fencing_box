    #include p18f87k22.inc
    global  ms_delay, delay_x4us,min_pause
    global  time_setup, time_loop, Clock_write
    global  time_min, time_10sec, time_sec
   
    extern  LCD_Send_Byte_D, score, LCD_write,hit

acs0    udata_acs   ; named variables in access ram
delay_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
delay_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
delay_cnt_ms  res 1   ; reserve 1 byte for ms counter


time_min   res 1    ; reserve 1 byte for variable time_min
time_min_counter    res	1   ;reserve byte for timing counter
time_sec    res 1   ; reserve 1 byte for variable time_sec
time_10sec	res 1	    ;reserve byte for value of 10's of seconds
time_sec_counter    res	1   ;counter for the number of seconds
time_10sec_counter  res	1   ;counter for the number of 10's of seconds
 
  
  
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
	


time_setup	    ;set the initial value of the clockk to 3:00 (what it is in a fencing match)
    movlw   0x30	    ;set the value of seconds to 0
    movwf   time_sec
    movlw   0x01	    ;set the second counter to 1
    movwf   time_sec_counter
    movlw   0x01	    ;set the 10's of seconds counter to 1
    movwf   time_10sec_counter
    movlw   0x30	    ;set the value of 10's of seconds to 0
    movwf   time_10sec
    movlw   0x33	    ;set the value of minutes to 3
    movwf   time_min
    movlw   0x04	    ;ste the counter of minutes to 4
    movwf   time_min_counter
    return
	
    
time_loop

    call    LCD_write	    ;wrtie the time and score to the LCD
    
    
    movlw   0xFA	    ;delay a second
    call    ms_delay	    
    movlw   0xFA	    
    call    ms_delay
    movlw   0xFA	    
    call    ms_delay
    movlw   0xFA	    
    call    ms_delay
    
    btfsc   hit,0
    call    score
    bcf	    hit,0
    
    movlw   0x01	    
    subwf   time_sec		;subtract one second of timer
    decfsz  time_sec_counter	;decrement seconds 10 times and then reset once zero
    bra	    time_loop		;call time loop again for next second is seconds value is not zero
    movlw   0x39		
    movwf   time_sec		;Reset the ASCII value of seconds to 9
    movlw   0x0A
    movwf   time_sec_counter	;Reset the seconds counter to 10
    movlw   0x01		
    subwf   time_10sec		;Subtract 1 off of the 10's of seconds
    decfsz  time_10sec_counter	;decrement the 10's of seconds counter
    bra	    time_loop		;repeat the time loop
    
    movlw   0x39		;Reset the value of seconds every minute
    movwf   time_sec
    movlw   0x0A		;Reset the seconds counter every minute
    movwf   time_sec_counter
    movlw   0x35		;Reset the 10's of seconds value to 5 every minute
    movwf   time_10sec
    movlw   0x06		;Reset the 10's of seconds counter every minute
    movwf   time_10sec_counter
    movlw   0x01		;Subtract 1 off the value of minutes
    subwf   time_min
    decfsz  time_min_counter	;Decrement the minute counter until it reaches 0 at which point the clock stops
    bra	    time_loop
    

    call    score
    
    
min_pause
	    ;set the initial value of the clockk to 1:00 
    movlw   0x30	    ;set the value of seconds to 0
    movwf   time_sec
    movlw   0x01	    ;set the second counter to 1
    movwf   time_sec_counter
    movlw   0x01	    ;set the 10's of seconds counter to 1
    movwf   time_10sec_counter
    movlw   0x30	    ;set the value of 10's of seconds to 0
    movwf   time_10sec
    movlw   0x31	    ;set the value of minutes to 1
    movwf   time_min
    movlw   0x02	    ;ste the counter of minutes to 1
    movwf   time_min_counter
 
min_loop
    call    LCD_write	    ;wrtie the time and score to the LCD
    
;    movlw   0xFA	    ;delay a second
;    call    ms_delay	    
;    movlw   0xFA	    
;    call    ms_delay
;    movlw   0xFA	    
;    call    ms_delay
;    movlw   0xFA	    
;    call    ms_delay
    
    movlw   0x01	    
    subwf   time_sec		;subtract one second of timer
    decfsz  time_sec_counter	;decrement seconds 10 times and then reset once zero
    bra	    min_loop		;call time loop again for next second is seconds value is not zero
    movlw   0x39		
    movwf   time_sec		;Reset the ASCII value of seconds to 9
    movlw   0x0A
    movwf   time_sec_counter	;Reset the seconds counter to 10
    movlw   0x01		
    subwf   time_10sec		;Subtract 1 off of the 10's of seconds
    decfsz  time_10sec_counter	;decrement the 10's of seconds counter
    bra	    min_loop		;repeat the time loop
    
    movlw   0x39		;Reset the value of seconds every minute
    movwf   time_sec
    movlw   0x0A		;Reset the seconds counter every minute
    movwf   time_sec_counter
    movlw   0x35		;Reset the 10's of seconds value to 5 every minute
    movwf   time_10sec
    movlw   0x06		;Reset the 10's of seconds counter every minute
    movwf   time_10sec_counter
    movlw   0x01		;Subtract 1 off the value of minutes
    subwf   time_min
    decfsz  time_min_counter	;Decrement the minute counter until it reaches 0 at which point the clock stops
    bra	    min_loop
    
    call    time_setup
    call    LCD_write
    return
    

Clock_write
    call	LCD_Send_Byte_D
    movlw	0x01	
    call	ms_delay
    return
    
    return

	

    end