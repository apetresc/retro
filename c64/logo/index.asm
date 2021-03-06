;============================================================
; index file which loads all source code and resource files
;============================================================

;============================================================
;    specify output file
;============================================================

!cpu 6502
!to "build/logo.prg",cbm    ; output file

;============================================================
; BASIC loader with start address $c000
;============================================================

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152
* = $c000     				            ; start address for 6502 code

;============================================================
;  Main routine with IRQ setup and custom IRQ routine
;============================================================

!source "code/main.asm"

;============================================================
;    setup and init symbols we use in the code
;============================================================

!source "code/setup_symbols.asm"

;============================================================
; tables and strings of data 
;============================================================

!source "code/data_static_text.asm"
!source "code/data_colorwash.asm"
!source "code/data_bitmap.asm"

;============================================================
; one-time initialization routines
;============================================================

!source "code/init_clear_screen.asm"
!source "code/init_static_text.asm"
!source "code/init_logo.asm"

;============================================================
;    subroutines called during custom IRQ
;============================================================

!source "code/sub_colorwash.asm"
!source "code/sub_music.asm"

;============================================================
; load resource files (for this small intro its just the sid)
;============================================================

!source "code/load_resources.asm"
