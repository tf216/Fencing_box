#include p18f87k22.inc
    
   global  write_score, score_setup, score
   extern  LCD_Send_Byte_D, ms_delay, time_loop,LCD_write,min_pause, time_setup

acs0    udata_acs   ; named variables in access ram
score_left	    res 1
score_right	    res 1
score_left_count    res 1
score_right_count   res 1
score_10left	    res 1
score_10right	    res 1
score_10left_count    res 1
score_10right_count   res 1
    
score code   
 
score_setup
    movlw   0x30		;ASCII code for 0 to be written to LCD
    movwf   score_left		;send scores to memory
    movwf   score_right
    movwf   score_10left
    movwf   score_10right
    movlw   0x0A		;initialise counter to reset score to 0 after 10 increments
    movwf   score_left_count	
    movwf   score_right_count
    movwf   score_10left_count	
    movwf   score_10right_count
    
    return
    
    
    
score				;check which button is being pressed
    btfsc   PORTB, 3
    call    inc_left
    btfsc   PORTB, 2
    call    inc_right
    btfsc   PORTB, 1
    call    min_pause
    btfsc   PORTB,0
    return
    bra	    score


inc_left			;increment score on LH side
    decfsz  score_left_count	;decrement counter to reset, if 0 go to reset the counter
    goto    left_inc		;go to increment the counter, if counter is not zero
    goto    left_zero		
left_inc
    incf    score_left		;increment score
    call    LCD_write
    return
left_zero			
    movlw   0x30		;reset ascii value to 0
    movwf   score_left
    movlw   0x0A		;reset counter to 10
    movwf   score_left_count
    decfsz  score_10left_count
    goto    left10_inc
    goto    left10_zero
left10_inc
    incf    score_10left
    call    LCD_write		;write score (and time) to LCD
    return
left10_zero
    movlw   0x30		;reset ascii value to 0
    movwf   score_10left
    movlw   0x0A		;reset counter to 10
    movwf   score_10left_count
    call    LCD_write		;write score (and time) to LCD
    return
    
    
    ;***** same as for LH side, but for RH side*****
inc_right
    decfsz  score_right_count
    goto    right_inc
    goto    right_zero
right_inc
    incf    score_right
    call    LCD_write
    return
right_zero
    movlw   0x30
    movwf   score_right
    movlw   0x0A
    movwf   score_right_count
    decfsz  score_10right_count
    goto    right10_inc
    goto    right10_zero
right10_inc
    incf    score_10right
    call    LCD_write		;write score (and time) to LCD
    return
right10_zero
    movlw   0x30		;reset ascii value to 0
    movwf   score_10right
    movlw   0x0A		;reset counter to 10
    movwf   score_10right_count
    call    LCD_write		;write score (and time) to LCD
    return

    
write_score			;write the score to the	   LCD display
    movf    score_10left, W	;move LH score
    call    LCD_Send_Byte_D	;send to display
    movf    score_left, W	;move LH score
    call    LCD_Send_Byte_D	;send to display
    movlw   0x2D		;send '-' to display
    call    LCD_Send_Byte_D
    movf    score_10right, W	;move LH score
    call    LCD_Send_Byte_D	;send to display
    movf    score_right, W	;send RH score
    call    LCD_Send_Byte_D
    movlw   0xFF
    call    ms_delay		; delay for 1/4 sec to prevent single button press registering **tens of thousands of times**
    return
  
    
    end


