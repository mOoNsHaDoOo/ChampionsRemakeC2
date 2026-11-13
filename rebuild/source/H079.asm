; ============================================================================
; MODULE GUIDE H079
; Exec adapters for interrupts and enabling/disabling.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Exec adapters for interrupts and enabling/disabling: AddIntServer, RemIntServer, Disable, Enable, Forbid.
; --------------------------------------------------------------------------
; H079: 148 original bytes; all offsets are section-relative.
        section H079,code
H079:
; Preserved bytes H079+$00000000..$00000004; code/data not fully classified.
        dc.l H079+$00000000
; --------------------------------------------------------------------------
; ROUTINE: sub_H079_00000004 [partial]
; Purpose: Routine of the Exec adapters for interrupts and enabling/disabling module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$00AE
; --------------------------------------------------------------------------
L079_00000004:
; H079+$00000004: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: wrapper_AddIntServer [partial]
; Purpose: Adapter to exec.library/AddIntServer; wraps the library call.
;   - Calls exec.library/AddIntServer (LVO -168).
; Direct callers: H043+$07E4, H043+$1976
; --------------------------------------------------------------------------
L079_00000006:
; H079+$00000006: 302f0008  move.w $8(a7), d0
        move.w $8(a7), d0
L079_0000000A:
; H079+$0000000A: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L079_0000000E:
; H079+$0000000E: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L079_00000012:
; H079+$00000012: 2f570006  move.l (a7), $6(a7)
        move.l (a7), $6(a7)
L079_00000016:
; H079+$00000016: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L079_00000018:
; H079+$00000018: 4eeeff58  jmp -$a8(a6) ; exec.library/AddIntServer
        jmp LVO_exec_AddIntServer(a6)
; Preserved bytes H079+$0000001C..$0000002E; code/data not fully classified.
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FF4C
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Disable [partial]
; Purpose: Adapter to exec.library/Disable; wraps the library call.
;   - Calls exec.library/Disable (LVO -120).
; Direct callers: H043+$15D0, H043+$0F62, H043+$1082
; --------------------------------------------------------------------------
L079_0000002E:
; H079+$0000002E: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L079_00000032:
; H079+$00000032: 4eeeff88  jmp -$78(a6) ; exec.library/Disable
        jmp LVO_exec_Disable(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Enable [partial]
; Purpose: Adapter to exec.library/Enable; wraps the library call.
;   - Calls exec.library/Enable (LVO -126).
; Direct callers: H043+$164E, H043+$1040, H043+$112E
; --------------------------------------------------------------------------
L079_00000036:
; H079+$00000036: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L079_0000003A:
; H079+$0000003A: 4eeeff82  jmp -$7e(a6) ; exec.library/Enable
        jmp LVO_exec_Enable(a6)
; Preserved bytes H079+$0000003E..$0000004E; code/data not fully classified.
        dc.w $2C78,$0004,$4EEE,$FF7C,$2C78,$0004,$4EEE,$FF76
; --------------------------------------------------------------------------
; ROUTINE: wrapper_RemIntServer [partial]
; Purpose: Adapter to exec.library/RemIntServer; wraps the library call.
;   - Calls exec.library/RemIntServer (LVO -174).
; Direct callers: H043+$085A, H043+$1964
; --------------------------------------------------------------------------
L079_0000004E:
; H079+$0000004E: 302f0008  move.w $8(a7), d0
        move.w $8(a7), d0
L079_00000052:
; H079+$00000052: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L079_00000056:
; H079+$00000056: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L079_0000005A:
; H079+$0000005A: 2f570006  move.l (a7), $6(a7)
        move.l (a7), $6(a7)
L079_0000005E:
; H079+$0000005E: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L079_00000060:
; H079+$00000060: 4eeeff52  jmp -$ae(a6) ; exec.library/RemIntServer
        jmp LVO_exec_RemIntServer(a6)
; Preserved bytes H079+$00000064..$00000094; code/data not fully classified.
        dc.w $302F,$0008,$226F,$0004,$2C78,$0004,$2F57,$0006
        dc.w $5C8F,$4EEE,$FF5E,$2C78,$0004,$4EEE,$FF6A,$202F
        dc.w $0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE,$FF64
; End H079: $94 bytes
