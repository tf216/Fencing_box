    #include p18f87k22.inc
    extern  ms_delay
    extern  LCD_Setup, LCD_Write_Message, LCD_clear, LCD_Send_Byte_D,LCD_Send_Byte_I

acs0    udata_acs   ; named variables in access ram
time_min   res 1    ; reserve 1 byte for variable time_min
time_min_counter    res	1
time_sec    res 1   ; reserve 1 byte for variable time_sec
time_10sec	res 1
time_sec_counter    res	1
time_10sec_counter  res	1
score_left	    res 1
score_right	    res 1
score_left_count    res 1
score_right_count   res 1

    
;rst code    0    ; reset vector
;    goto    setup
    
;tables udata	0x400
;myTime	res 0x10
;
; 
;	
;	
;pdata code
;timetable
;    data    '3'
;    constant leng    0x01
	
main	code

    org 0x0
    goto	setup
    org 0x100	

 
setup
    call    LCD_Setup	; setup LCD
    movlw   0x00
    movwf   TRISE
    goto    start
    
start
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
    movlw   0x30
    movwf   score_left
    movwf   score_right
    movlw   0x0A
    movwf   score_left_count
    movwf   score_right_count
    call    time_loop
    ;call    write_score
    ;call    LCD_write
    ;goto    score
    ;goto    $
   

time_loop
    movf    time_min, W
    call    LCD_write

    
    
    
;    call    write_score
;    movlw   b'00000110'
;    call    LCD_Send_Byte_I
;    movlW   0x01	
;    call    ms_delay
    
    
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
    
score
    btfsc   PORTD, 1
    call    inc_left
    btfsc   PORTD, 2
    call    inc_right
    bra	    score

inc_left
    decfsz  score_left_count
    goto    left_inc
    goto    left_zero
left_inc
    incf    score_left
    call    write_score
    return
left_zero
    movlw   0x30
    movwf   score_left
    movlw   0x0A
    movwf   score_left_count
    call    write_score
    return
    
    
inc_right
    decfsz  score_right_count
    goto    right_inc
    goto    right_zero
right_inc
    incf    score_right
    call    write_score
    return
right_zero
    movlw   0x30
    movwf   score_right
    movlw   0x0A
    movwf   score_right_count
    call    write_score
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
    
  
Clock_write
    call	LCD_Send_Byte_D
    movlw	0x01	
    call	ms_delay
    
    return
    
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
    end