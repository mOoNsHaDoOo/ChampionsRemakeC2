; H089: 8 original bytes; all offsets are section-relative.
        section H089,code
H089:
; Preserved bytes H089+$00000000..$00000004; code/data not fully classified.
        dc.l H089+$00000000
L089_00000004:
; H089+$00000004: 4e75  rts 
        rts 
; Preserved bytes H089+$00000006..$00000008; code/data not fully classified.
        dc.w $0000
; End H089: $8 bytes
