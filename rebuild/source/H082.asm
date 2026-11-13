; ============================================================================
; MODULE GUIDE H082
; graphics.library/FreeCprList adapter.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; graphics.library/FreeCprList adapter.
; --------------------------------------------------------------------------
; H082: 156 original bytes; all offsets are section-relative.
        section H082,code
H082:
; Preserved bytes H082+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H082+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H082_00000008 [partial]
; Purpose: Routine of the graphics.library/FreeCprList adapter module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0108
; --------------------------------------------------------------------------
L082_00000008:
; H082+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H082+$4(pc), a0
L082_0000000C:
; H082+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L082_00000012:
; H082+$00000012: 4e75  rts 
        rts 
; Preserved bytes H082+$00000014..$00000074; code/data not fully classified.
        dc.w $226F,$0004,$2C7A,$FFE6,$2F57,$0004,$588F,$4EEE
        dc.w $FE92,$226F,$000A,$202F,$0006,$322F,$0004,$2C7A
        dc.w $FFCC,$2F57,$000A,$4FEF,$000A,$4EEE,$FE8C,$226F
        dc.w $0008,$302F,$0006,$322F,$0004,$2C7A,$FFB0,$2F57
        dc.w $0008,$508F,$4EEE,$FE86,$206F,$0004,$2C7A,$FF9E
        dc.w $2F57,$0004,$588F,$4EEE,$FDDE,$205F,$588F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_FreeCprList [partial]
; Purpose: Adapter to graphics.library/FreeCprList; wraps the library call.
;   - Calls graphics.library/FreeCprList (LVO -564).
; Direct callers: H029+$14BE
; --------------------------------------------------------------------------
L082_00000074:
; H082+$00000074: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L082_00000078:
; H082+$00000078: 2c7aff86  movea.l $0(pc), a6
        movea.l H082+$0(pc), a6
L082_0000007C:
; H082+$0000007C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L082_00000080:
; H082+$00000080: 588f  addq.l #$4, a7
        addq.l #$4, a7
L082_00000082:
; H082+$00000082: 4eeefdcc  jmp -$234(a6) ; graphics.library/FreeCprList
        jmp LVO_graphics_FreeCprList(a6)
; Preserved bytes H082+$00000086..$0000009C; code/data not fully classified.
        dc.w $206F,$0006,$302F,$0004,$2C7A,$FF70,$2F57,$0006
        dc.w $5C8F,$4EEE,$FDAE
; End H082: $9C bytes
