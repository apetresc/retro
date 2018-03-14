;============================================================
; clear screen
; a loop instead of kernal routine to save cycles
;============================================================

init_screen      ldx #0x01     ; set X to zero (black color code)
                 stx 0xd021    ; set background color
                 stx 0xd020    ; set border color

clear            lda #0x20     ; #0x20 is the spacebar Screen Code
                 sta 0x0400,x  ; fill four areas with 256 spacebar characters
                 sta 0x0500,x 
                 sta 0x0600,x 
                 sta 0x06e8,x 
                 lda #0x01     ; set foreground to black in Color Ram 
                 sta 0xd800,x  
                 sta 0xd900,x
                 sta 0xda00,x
                 sta 0xdae8,x
                 inx           ; increment X
                 bne clear     ; did X turn to zero yet?
                               ; if not, continue with the loop
                 rts           ; return from this subroutine