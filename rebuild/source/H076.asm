; H076: 8 original bytes; all offsets are section-relative.
        section H076,code
H076:
; Preserved bytes H076+$00000000..$00000004; code/data not fully classified.
        dc.l H076+$00000000
L076_00000004:
; H076+$00000004: 4e75  rts 
        rts 
; Preserved bytes H076+$00000006..$00000008; code/data not fully classified.
        dc.w $0000
; End H076: $8 bytes
