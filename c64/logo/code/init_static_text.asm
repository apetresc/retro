;============================================================
; write the two line of text to screen center
;============================================================


init_text  ldx #0x00          ; init X-Register with 0x00
loop_text  lda line1,x      ; read characters from line1 table of text...
           sta screen_ram+text_line_offset*0x0028,x      ; ...and store in screen ram near the center
           lda line2,x      ; read characters from line1 table of text...
           sta screen_ram+(text_line_offset+2)*0x0028,x      ; ...and put 2 rows below line1

           inx 
           cpx #0x28         ; finished when all 40 cols of a line are processed
           bne loop_text    ; loop if we are not done yet
           rts