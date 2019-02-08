    #include p18f87k22.inc
    extern	ms_delay

acs0    udata_acs   ; named variables in access ram
time_min   res 1    ; reserve 1 byte for variable time_min
time_sec    res 1   ; reserve 1 byte for variable time_sec
    
main	code

    org 0x0
    goto	setup
    org 0x100	

setup
    
    movlw   0x00
    movwf   TRISE
    goto    start
    
start
    movlw   0x0F
    movwf   time_sec
time_loop
    
    movlw   0x01
    movwf   PORTE
    Movlw   0xFF
    call    ms_delay
    movlw   0x00
    movwf   PORTE
    Movlw   0xFF
    call    ms_delay
    decfsz  time_sec
    bra	    time_loop
    
    movlw   0xFF
    movwf   PORTE
    goto    $



    end