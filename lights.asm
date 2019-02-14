#include p18f87k22.inc
    
acs0    udata_acs   ; named variables in access ram

    
lights code
 
register_hit
    btfsc   PORTD,0
    goto    hit_left
    btfsc   PORTD,1
    goto    hit_right
    bra	    register_hit
    
hit_left
    bsf	    PORTE,0
    
hit_right
    bsf	    PORTE,1
    



end