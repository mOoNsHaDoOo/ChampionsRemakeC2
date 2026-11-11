; H078: 8 original bytes; all offsets are section-relative.
        section H078,code
H078:
; Preserved bytes H078+$00000000..$00000004; code/data not fully classified.
        dc.l H078+$00000000
L078_00000004:
; H078+$00000004: 4e75  rts 
        rts 
; Preserved bytes H078+$00000006..$00000008; code/data not fully classified.
        dc.w $0000
; End H078: $8 bytes
