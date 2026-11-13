; ============================================================================
; MODULE GUIDE H037
; graphics.library/InitBitMap adapter.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; graphics.library/InitBitMap adapter.
; --------------------------------------------------------------------------
; H037: 52 original bytes; all offsets are section-relative.
        section H037,code
H037:
; Preserved bytes H037+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H037+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H037_00000008 [partial]
; Purpose: Routine of the graphics.library/InitBitMap adapter module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0072
; --------------------------------------------------------------------------
L037_00000008:
; H037+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H037+$4(pc), a0
L037_0000000C:
; H037+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L037_00000012:
; H037+$00000012: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: wrapper_InitBitMap [partial]
; Purpose: Adapter to graphics.library/InitBitMap; wraps the library call.
;   - Calls graphics.library/InitBitMap (LVO -390).
; Direct callers: H029+$04A0, H029+$0588, H040+$0376
; --------------------------------------------------------------------------
L037_00000014:
; H037+$00000014: 206f000a  movea.l $a(a7), a0
        movea.l $a(a7), a0
L037_00000018:
; H037+$00000018: 302f0008  move.w $8(a7), d0
        move.w $8(a7), d0
L037_0000001C:
; H037+$0000001C: 322f0006  move.w $6(a7), d1
        move.w $6(a7), d1
L037_00000020:
; H037+$00000020: 342f0004  move.w $4(a7), d2
        move.w $4(a7), d2
L037_00000024:
; H037+$00000024: 2c7affda  movea.l $0(pc), a6
        movea.l H037+$0(pc), a6
L037_00000028:
; H037+$00000028: 2f57000a  move.l (a7), $a(a7)
        move.l (a7), $a(a7)
L037_0000002C:
; H037+$0000002C: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L037_00000030:
; H037+$00000030: 4eeefe7a  jmp -$186(a6) ; graphics.library/InitBitMap
        jmp LVO_graphics_InitBitMap(a6)
; End H037: $34 bytes
