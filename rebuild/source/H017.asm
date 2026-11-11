; H017: 56 original bytes; all offsets are section-relative.
        section H017,code
H017:
; Preserved bytes H017+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H017+$00000004
L017_00000008:
; H017+$00000008: 4e75  rts 
        rts 
; Preserved bytes H017+$0000000A..$00000038; code/data not fully classified.
        dc.w $206F,$000A,$202F,$0006,$322F,$0004,$2C7A,$FFE8
        dc.w $2F57,$000A,$4FEF,$000A,$4EEE,$FFDC,$206F,$0004
        dc.w $2C7A,$FFD4,$2F57,$0004,$588F,$4EEE,$FFE2
; End H017: $38 bytes
