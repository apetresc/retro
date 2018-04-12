; load sid music

* = address_music                         ; address to load the music data
!bin "resources/jeff_donald_reloc.sid",, $7c+2  ; remove header from sid and cut off original loading address 
;!bin "resources/pokemon2.sid",, $7c+2  ; remove header from sid and cut off original loading address 
;!bin "resources/ff2_reloc.sid",, $7c+2  ; remove header from sid and cut off original loading address 
