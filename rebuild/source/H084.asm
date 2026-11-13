; ============================================================================
; MODULE GUIDE H084
; intuition.library/GetPrefs adapter.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; intuition.library/GetPrefs adapter.
; --------------------------------------------------------------------------
; H084: 92 original bytes; all offsets are section-relative.
        section H084,code
H084:
; Preserved bytes H084+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H084+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H084_00000008 [partial]
; Purpose: Routine of the intuition.library/GetPrefs adapter module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0114
; --------------------------------------------------------------------------
L084_00000008:
; H084+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H084+$4(pc), a0
L084_0000000C:
; H084+$0000000C: 216cfff0fffc  move.l -$10(a4), -$4(a0)
        move.l -$10(a4), -$4(a0)
L084_00000012:
; H084+$00000012: 4e75  rts 
        rts 
; Preserved bytes H084+$00000014..$0000002A; code/data not fully classified.
        dc.w $206F,$0006,$302F,$0004,$2C7A,$FFE2,$2F57,$0006
        dc.w $5C8F,$4EEE,$FF82
; --------------------------------------------------------------------------
; ROUTINE: wrapper_GetPrefs [partial]
; Purpose: Adapter to intuition.library/GetPrefs; wraps the library call.
;   - Calls intuition.library/GetPrefs (LVO -132).
; Direct callers: H029+$13B4
; --------------------------------------------------------------------------
L084_0000002A:
; H084+$0000002A: 206f0006  movea.l $6(a7), a0
        movea.l $6(a7), a0
L084_0000002E:
; H084+$0000002E: 302f0004  move.w $4(a7), d0
        move.w $4(a7), d0
L084_00000032:
; H084+$00000032: 2c7affcc  movea.l $0(pc), a6
        movea.l H084+$0(pc), a6
L084_00000036:
; H084+$00000036: 2f570006  move.l (a7), $6(a7)
        move.l (a7), $6(a7)
L084_0000003A:
; H084+$0000003A: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L084_0000003C:
; H084+$0000003C: 4eeeff7c  jmp -$84(a6) ; intuition.library/GetPrefs
        jmp LVO_intuition_GetPrefs(a6)
; Preserved bytes H084+$00000040..$0000005C; code/data not fully classified.
        dc.w $206F,$0008,$302F,$0006,$7200,$122F,$0004,$2C7A
        dc.w $FFB0,$2F57,$0008,$508F,$4EEE,$FEBC
; End H084: $5C bytes
