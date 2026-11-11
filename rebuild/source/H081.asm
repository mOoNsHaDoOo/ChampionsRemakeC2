; H081: 76 original bytes; all offsets are section-relative.
        section H081,code
H081:
; Preserved bytes H081+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H081+$00000004
L081_00000008:
; H081+$00000008: 4e75  rts 
        rts 
; Preserved bytes H081+$0000000A..$0000004C; code/data not fully classified.
        dc.w $206F,$0008,$226F,$0004,$2C7A,$FFEC,$2F57,$0008
        dc.w $508F,$4EEE,$FFD6,$206F,$0008,$226F,$0004,$2C7A
        dc.w $FFD6,$2F57,$0008,$508F,$4EEE,$FFCA,$206F,$0008
        dc.w $226F,$0004,$2C7A,$FFC0,$2F57,$0008,$508F,$4EEE
        dc.w $FFD0
; End H081: $4C bytes
