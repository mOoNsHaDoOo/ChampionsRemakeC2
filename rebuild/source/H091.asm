; H091: 8 original bytes; all offsets are section-relative.
        section H091,code
H091:
; Preserved bytes H091+$00000000..$00000004; code/data not fully classified.
        dc.l H091+$00000000
L091_00000004:
; H091+$00000004: 4e75  rts 
        rts 
; Preserved bytes H091+$00000006..$00000008; code/data not fully classified.
        dc.w $0000
; End H091: $8 bytes
