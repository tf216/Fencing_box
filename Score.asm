#include p18f87k22.inc
    
   global  write_score, score_setup, score
   extern  LCD_Send_Byte_D, ms_delay, time_loop,LCD_write

acs0    udata_acs   ; named variables in access ram
score_left	    res 1
score_right	    res 1
score_left_count    res 1
score_right_count   res 1
    
score code   
 
score_setup
    movlw   0x30
    movwf   score_left
    movwf   score_right
    movlw   0x0A
    movwf   score_left_count
    movwf   score_right_count
    
    return
    
    
    
score
    btfsc   PORTD, 1
    call    inc_left
    btfsc   PORTD, 2
    call    inc_right
    btfsc   PORTD,4
    return
    bra	    score

inc_left
    decfsz  score_left_count
    goto    left_inc
    goto    left_zero
left_inc
    incf    score_left
    call    LCD_write
    return
left_zero
    movlw   0x30
    movwf   score_left
    movlw   0x0A
    movwf   score_left_count
    call    LCD_write
    return
    
    
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
    call    LCD_write
    return

    
write_score
    ;call    LCD_clear
    movf    score_left, W
    call    LCD_Send_Byte_D
    movlw   0x2D
    call    LCD_Send_Byte_D
    movf    score_right, W
    call    LCD_Send_Byte_D
    movlw   0xFF
    call    ms_delay
    return
  
    
    end


