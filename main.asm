    #include p18f87k22.inc
    extern  ms_delay
    extern  LCD_Setup, LCD_Write_Message, LCD_clear, LCD_Send_Byte_D,LCD_Send_Byte_I

acs0    udata_acs   ; named variables in access ram
time_min   res 1    ; reserve 1 byte for variable time_min
time_sec    res 1   ; reserve 1 byte for variable time_sec
time_10sec	res 1
time_sec_counter    res	1
time_10sec_counter  res	1
time_min    res	1
    
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
    movlw   0x39
    movwf   time_sec
    movlw   0x0A
    movwf   time_sec_counter
    movlw   0x06
    movwf   time_10sec_counter
    movlw   0x35
    movwf   time_10sec
    
   

time_loop
    movf  time_10sec, W
    call    Clock_write
    movf  time_sec, W
    call    Clock_write
    movlw   0xE0
    call    ms_delay
    movlw   0xFF
    ;call    ms_delay
    call    LCD_clear
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
    
    
    movlw   0xFF
    goto    $
    
Clock_write
;    lfsr	FSR0, time_sec	; Load FSR0 with address in RAM
;    movlw	0xFF
;    movwf	delay_count
;    movlw	upper(time_sec)	; address of data in PM
;    movwf	TBLPTRU		; load upper bits to TBLPTRU
;    movlw	high(myTable)	; address of data in PM
;    movwf	TBLPTRH		; load high byte to TBLPTRH
;    movlw	low(myTable)	; address of data in PM
;    movwf	TBLPTRL		; load low byte to TBLPTRL
;    movlw	0x02		; bytes to read
;    movwf 	counter		; our counter register
;loop
;    tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;    movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;    decfsz	counter		; count down to zero
;    bra	loop		; keep going until finished
;    
    

;    
    ;movlw	.168
    ;call	LCD_Send_Byte_I
    ;movlw	0x40	
    ;call	ms_delay
    

    call	LCD_Send_Byte_D
    movlw	0xff	
    call	ms_delay
    
    return
    
    end