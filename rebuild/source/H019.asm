; ============================================================================
; MODULE GUIDE H019
; initialisation of a data slot.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; H019: 240 original bytes; all offsets are section-relative.
        section H019,code
H019:
; Preserved bytes H019+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H019+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H019_00000008 [partial]
; Purpose: Routine of the initialisation of a data slot module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0030
; --------------------------------------------------------------------------
L019_00000008:
; H019+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H019+$4(pc), a0
L019_0000000C:
; H019+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L019_00000012:
; H019+$00000012: 4e75  rts 
        rts 
; Preserved bytes H019+$00000014..$000000F0; code/data not fully classified.
        dc.w $226F,$0004,$2C7A,$FFE6,$2F57,$0004,$588F,$4EEE
        dc.w $FE20,$226F,$0008,$206F,$0004,$2C7A,$FFD0,$2F57
        dc.w $0008,$508F,$4EEE,$FE26,$226F,$0004,$2C7A,$FFBE
        dc.w $2F57,$0004,$588F,$4EEE,$FFAC,$226F,$0004,$2C7A
        dc.w $FFAC,$2F57,$0004,$588F,$4EEE,$FFB2,$206F,$0004
        dc.w $2C7A,$FF9A,$2F57,$0004,$588F,$4EEE,$FFB8,$226F
        dc.w $0004,$2C7A,$FF88,$2F57,$0004,$588F,$4EEE,$FE1A
        dc.w $226F,$0008,$206F,$0004,$2C7A,$FF72,$2F57,$0008
        dc.w $508F,$4EEE,$FFBE,$226F,$0008,$7000,$102F,$0006
        dc.w $7200,$122F,$0004,$2C7A,$FF54,$2F57,$0008,$508F
        dc.w $4EEE,$FFA6,$226F,$000A,$206F,$0006,$302F,$0004
        dc.w $2C7A,$FF3A,$2F57,$000A,$4FEF,$000A,$4EEE,$FFC4
        dc.w $226F,$000A,$206F,$0006,$302F,$0004,$2C7A,$FF1E
        dc.w $2F57,$000A,$4FEF,$000A,$4EEE,$FFCA
; End H019: $F0 bytes
