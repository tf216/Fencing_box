    #include p18f87k22.inc
    extern  ms_delay, time_setup, time_loop
    extern  LCD_write, LCD_Setup, LCD_Write_Message, LCD_clear, LCD_Send_Byte_D,LCD_Send_Byte_I
    extern  score_setup
    
    
;rst code    0    ; reset vector
;    goto    setup
    

	
main	code
    org 0x0
    goto	setup
    org 0x100	

 
setup
    call    LCD_Setup	; setup LCD
    call    score_setup
    call    time_setup
    movlw   0x00
    movwf   TRISE
    goto    start
    
    
start
    call    time_loop
    ;call    write_score
    ;call    LCD_write
    ;goto    score
    ;goto    $
   


    


    

    end