init_logo ldx #0x00
          ldy #0xa0
loop_logo lda bitmap,x
          sta color_ram,x
          lda #0xa0
          sta screen_ram,x

          inx
          cpx #0xff
          bne loop_logo
          rts
