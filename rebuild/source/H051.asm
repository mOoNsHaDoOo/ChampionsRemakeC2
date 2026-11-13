; ============================================================================
; MODULE GUIDE H051
; Exec/FindTask adapter.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Exec/FindTask adapter.
; --------------------------------------------------------------------------
; H051: 256 original bytes; all offsets are section-relative.
        section H051,code
H051:
; Preserved bytes H051+$00000000..$00000004; code/data not fully classified.
        dc.l H051+$00000000
; --------------------------------------------------------------------------
; ROUTINE: sub_H051_00000004 [partial]
; Purpose: Routine of the Exec/FindTask adapter module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$00A2
; --------------------------------------------------------------------------
L051_00000004:
; H051+$00000004: 4e75  rts 
        rts 
; Preserved bytes H051+$00000006..$0000004A; code/data not fully classified.
        dc.w $226F,$000C,$246F,$0008,$266F,$0004,$2C78,$0004
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FEE6,$302F,$0004
        dc.w $48C0,$2C78,$0004,$2F57,$0002,$548F,$4EEE,$FEB6
        dc.w $302F,$0004,$48C0,$2C78,$0004,$2F57,$0002,$548F
        dc.w $4EEE,$FEAA
; --------------------------------------------------------------------------
; ROUTINE: wrapper_FindTask [partial]
; Purpose: Adapter to exec.library/FindTask; wraps the library call.
;   - Calls exec.library/FindTask (LVO -294).
; Direct callers: H029+$1298, H029+$12CC
; --------------------------------------------------------------------------
L051_0000004A:
; H051+$0000004A: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L051_0000004E:
; H051+$0000004E: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L051_00000052:
; H051+$00000052: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L051_00000056:
; H051+$00000056: 588f  addq.l #$4, a7
        addq.l #$4, a7
L051_00000058:
; H051+$00000058: 4eeefeda  jmp -$126(a6) ; exec.library/FindTask
        jmp LVO_exec_FindTask(a6)
; Preserved bytes H051+$0000005C..$00000100; code/data not fully classified.
        dc.w $302F,$0004,$48C0,$2C78,$0004,$2F57,$0002,$548F
        dc.w $4EEE,$FEB0,$302F,$0004,$48C0,$2C78,$0004,$2F57
        dc.w $0002,$548F,$4EEE,$FEA4,$226F,$0004,$2C78,$0004
        dc.w $2F57,$0004,$588F,$4EEE,$FEE0,$202F,$0008,$222F
        dc.w $0004,$2C78,$0004,$2F57,$0008,$508F,$4EEE,$FEC8
        dc.w $202F,$0008,$222F,$0004,$2C78,$0004,$2F57,$0008
        dc.w $508F,$4EEE,$FECE,$226F,$0006,$302F,$0004,$2C78
        dc.w $0004,$2F57,$0006,$5C8F,$4EEE,$FED4,$226F,$0008
        dc.w $202F,$0004,$2C78,$0004,$2F57,$0008,$508F,$4EEE
        dc.w $FEBC,$202F,$0004,$2C78,$0004,$2F57,$0004,$588F
        dc.w $4EEE,$FEC2
; End H051: $100 bytes
