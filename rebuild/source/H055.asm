; ============================================================================
; MODULE GUIDE H055
; Adapters for AllocRaster, FreeRaster and InitRastPort.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Adapters for AllocRaster, FreeRaster and InitRastPort.
; --------------------------------------------------------------------------
; H055: 180 original bytes; all offsets are section-relative.
        section H055,code
H055:
; Preserved bytes H055+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H055+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H055_00000008 [partial]
; Purpose: Routine of the AllocRaster, FreeRaster and InitRastPort adapters module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0090
; --------------------------------------------------------------------------
L055_00000008:
; H055+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H055+$4(pc), a0
L055_0000000C:
; H055+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L055_00000012:
; H055+$00000012: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: wrapper_AllocRaster [partial]
; Purpose: Adapter to graphics.library/AllocRaster; wraps the library call.
;   - Calls graphics.library/AllocRaster (LVO -492).
; Direct callers: H029+$04D4, H029+$059E
; --------------------------------------------------------------------------
L055_00000014:
; H055+$00000014: 302f0006  move.w $6(a7), d0
        move.w $6(a7), d0
L055_00000018:
; H055+$00000018: 322f0004  move.w $4(a7), d1
        move.w $4(a7), d1
L055_0000001C:
; H055+$0000001C: 2c7affe2  movea.l $0(pc), a6
        movea.l H055+$0(pc), a6
L055_00000020:
; H055+$00000020: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L055_00000024:
; H055+$00000024: 588f  addq.l #$4, a7
        addq.l #$4, a7
L055_00000026:
; H055+$00000026: 4eeefe14  jmp -$1ec(a6) ; graphics.library/AllocRaster
        jmp LVO_graphics_AllocRaster(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_FreeRaster [partial]
; Purpose: Adapter to graphics.library/FreeRaster; wraps the library call.
;   - Calls graphics.library/FreeRaster (LVO -498).
; Direct callers: H029+$06F4, H029+$071A
; --------------------------------------------------------------------------
L055_0000002A:
; H055+$0000002A: 206f0008  movea.l $8(a7), a0
        movea.l $8(a7), a0
L055_0000002E:
; H055+$0000002E: 302f0006  move.w $6(a7), d0
        move.w $6(a7), d0
L055_00000032:
; H055+$00000032: 322f0004  move.w $4(a7), d1
        move.w $4(a7), d1
L055_00000036:
; H055+$00000036: 2c7affc8  movea.l $0(pc), a6
        movea.l H055+$0(pc), a6
L055_0000003A:
; H055+$0000003A: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L055_0000003E:
; H055+$0000003E: 508f  addq.l #$8, a7
        addq.l #$8, a7
L055_00000040:
; H055+$00000040: 4eeefe0e  jmp -$1f2(a6) ; graphics.library/FreeRaster
        jmp LVO_graphics_FreeRaster(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_InitRastPort [partial]
; Purpose: Adapter to graphics.library/InitRastPort; wraps the library call.
;   - Calls graphics.library/InitRastPort (LVO -198).
; Direct callers: H029+$138A
; --------------------------------------------------------------------------
L055_00000044:
; H055+$00000044: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L055_00000048:
; H055+$00000048: 2c7affb6  movea.l $0(pc), a6
        movea.l H055+$0(pc), a6
L055_0000004C:
; H055+$0000004C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L055_00000050:
; H055+$00000050: 588f  addq.l #$4, a7
        addq.l #$4, a7
L055_00000052:
; H055+$00000052: 4eeeff3a  jmp -$c6(a6) ; graphics.library/InitRastPort
        jmp LVO_graphics_InitRastPort(a6)
; Preserved bytes H055+$00000056..$000000B4; code/data not fully classified.
        dc.w $206F,$000C,$226F,$0008,$202F,$0004,$2C7A,$FF9C
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FE2C,$226F,$0010
        dc.w $302F,$000E,$322F,$000C,$342F,$000A,$362F,$0008
        dc.w $382F,$0006,$3A2F,$0004,$2C7A,$FF70,$2F57,$0010
        dc.w $4FEF,$0010,$4EEE,$FE74,$226F,$0006,$302F,$0004
        dc.w $2C7A,$FF58,$2F57,$0006,$5C8F,$4EEE,$FF16
; End H055: $B4 bytes
