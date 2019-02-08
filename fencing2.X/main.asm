    #include p18f87k22.inc
    extern	ms_delay


main	code

setup
    
    movlw   0x00
    movwf   PORTE
    goto    delay_test


delay_test
    movlw   0xFF
    call    ms_delay
    movlw   0x01
    movwf   PORTE
    movlw   0x05
    call    ms_delay
    movlw   0x00
    movwf   PORTE
    bra	    delay_test
    end