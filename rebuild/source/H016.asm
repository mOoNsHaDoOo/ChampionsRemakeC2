; ============================================================================
; MODULE GUIDE H016
; graphics.library adapters for blit, waiting and raster clearing.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; graphics.library adapters for blits, blitter wait, raster clearing and BltMaskBitMapRastPort. They do not program the custom registers directly.
; --------------------------------------------------------------------------
; H016: 436 original bytes; all offsets are section-relative.
        section H016,code
H016:
; Preserved bytes H016+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H016+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H016_00000008 [partial]
; Purpose: Routine of the graphics.library adapters for blits, waiting and raster clearing module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$001E
; --------------------------------------------------------------------------
L016_00000008:
; H016+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H016+$4(pc), a0
L016_0000000C:
; H016+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L016_00000012:
; H016+$00000012: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: wrapper_BltBitMap [partial]
; Purpose: Adapter to graphics.library/BltBitMap; wraps the library call.
;   - Calls graphics.library/BltBitMap (LVO -30).
; Direct callers: H063+$2064, H063+$20A6, H063+$210C, H063+$2164, H029+$155C, H006+$0158 and 24 more
; --------------------------------------------------------------------------
L016_00000014:
; H016+$00000014: 206f001c  movea.l $1c(a7), a0
        movea.l $1c(a7), a0
L016_00000018:
; H016+$00000018: 302f001a  move.w $1a(a7), d0
        move.w $1a(a7), d0
L016_0000001C:
; H016+$0000001C: 322f0018  move.w $18(a7), d1
        move.w $18(a7), d1
L016_00000020:
; H016+$00000020: 226f0014  movea.l $14(a7), a1
        movea.l $14(a7), a1
L016_00000024:
; H016+$00000024: 342f0012  move.w $12(a7), d2
        move.w $12(a7), d2
L016_00000028:
; H016+$00000028: 362f0010  move.w $10(a7), d3
        move.w $10(a7), d3
L016_0000002C:
; H016+$0000002C: 382f000e  move.w $e(a7), d4
        move.w $e(a7), d4
L016_00000030:
; H016+$00000030: 3a2f000c  move.w $c(a7), d5
        move.w $c(a7), d5
L016_00000034:
; H016+$00000034: 1c2f000a  move.b $a(a7), d6
        move.b $a(a7), d6
L016_00000038:
; H016+$00000038: 1e2f0008  move.b $8(a7), d7
        move.b $8(a7), d7
L016_0000003C:
; H016+$0000003C: 246f0004  movea.l $4(a7), a2
        movea.l $4(a7), a2
L016_00000040:
; H016+$00000040: 2c7affbe  movea.l $0(pc), a6
        movea.l H016+$0(pc), a6
L016_00000044:
; H016+$00000044: 2f57001c  move.l (a7), $1c(a7)
        move.l (a7), $1c(a7)
L016_00000048:
; H016+$00000048: 4fef001c  lea.l $1c(a7), a7
        lea.l $1c(a7), a7
L016_0000004C:
; H016+$0000004C: 4eeeffe2  jmp -$1e(a6) ; graphics.library/BltBitMap
        jmp LVO_graphics_BltBitMap(a6)
; Preserved bytes H016+$00000050..$00000084; code/data not fully classified.
        dc.w $206F,$0016,$302F,$0014,$322F,$0012,$226F,$000E
        dc.w $342F,$000C,$362F,$000A,$382F,$0008,$3A2F,$0006
        dc.w $1C2F,$0004,$2C7A,$FF8A,$2F57,$0016,$4FEF,$0016
        dc.w $4EEE,$FDA2
; --------------------------------------------------------------------------
; ROUTINE: wrapper_BltClear [partial]
; Purpose: Adapter to graphics.library/BltClear; wraps the library call.
;   - Calls graphics.library/BltClear (LVO -300).
; Direct callers: H029+$053C, H029+$05F2, H029+$07D4, H029+$08D6, H066+$0CCA, H066+$0CEA
; --------------------------------------------------------------------------
L016_00000084:
; H016+$00000084: 226f000c  movea.l $c(a7), a1
        movea.l $c(a7), a1
L016_00000088:
; H016+$00000088: 202f0008  move.l $8(a7), d0
        move.l $8(a7), d0
L016_0000008C:
; H016+$0000008C: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L016_00000090:
; H016+$00000090: 2c7aff6e  movea.l $0(pc), a6
        movea.l H016+$0(pc), a6
L016_00000094:
; H016+$00000094: 2f57000c  move.l (a7), $c(a7)
        move.l (a7), $c(a7)
L016_00000098:
; H016+$00000098: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L016_0000009C:
; H016+$0000009C: 4eeefed4  jmp -$12c(a6) ; graphics.library/BltClear
        jmp LVO_graphics_BltClear(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_BltMaskBitMapRastPort [partial]
; Purpose: Adapter to graphics.library/BltMaskBitMapRastPort; wraps the library call.
;   - Calls graphics.library/BltMaskBitMapRastPort (LVO -636).
; Direct callers: H029+$0CF8, H035+$06AC, H011+$07AC, H011+$081A
; --------------------------------------------------------------------------
L016_000000A0:
; H016+$000000A0: 206f001a  movea.l $1a(a7), a0
        movea.l $1a(a7), a0
L016_000000A4:
; H016+$000000A4: 302f0018  move.w $18(a7), d0
        move.w $18(a7), d0
L016_000000A8:
; H016+$000000A8: 322f0016  move.w $16(a7), d1
        move.w $16(a7), d1
L016_000000AC:
; H016+$000000AC: 226f0012  movea.l $12(a7), a1
        movea.l $12(a7), a1
L016_000000B0:
; H016+$000000B0: 342f0010  move.w $10(a7), d2
        move.w $10(a7), d2
L016_000000B4:
; H016+$000000B4: 362f000e  move.w $e(a7), d3
        move.w $e(a7), d3
L016_000000B8:
; H016+$000000B8: 382f000c  move.w $c(a7), d4
        move.w $c(a7), d4
L016_000000BC:
; H016+$000000BC: 3a2f000a  move.w $a(a7), d5
        move.w $a(a7), d5
L016_000000C0:
; H016+$000000C0: 1c2f0008  move.b $8(a7), d6
        move.b $8(a7), d6
L016_000000C4:
; H016+$000000C4: 246f0004  movea.l $4(a7), a2
        movea.l $4(a7), a2
L016_000000C8:
; H016+$000000C8: 2c7aff36  movea.l $0(pc), a6
        movea.l H016+$0(pc), a6
L016_000000CC:
; H016+$000000CC: 2f57001a  move.l (a7), $1a(a7)
        move.l (a7), $1a(a7)
L016_000000D0:
; H016+$000000D0: 4fef001a  lea.l $1a(a7), a7
        lea.l $1a(a7), a7
L016_000000D4:
; H016+$000000D4: 4eeefd84  jmp -$27c(a6) ; graphics.library/BltMaskBitMapRastPort
        jmp LVO_graphics_BltMaskBitMapRastPort(a6)
; Preserved bytes H016+$000000D8..$000001AC; code/data not fully classified.
        dc.w $226F,$0012,$206F,$000E,$302F,$000C,$322F,$000A
        dc.w $342F,$0008,$362F,$0006,$382F,$0004,$2C7A,$FF0A
        dc.w $2F57,$0012,$4FEF,$0012,$4EEE,$FEC8,$206F,$0014
        dc.w $302F,$0012,$322F,$0010,$226F,$000C,$342F,$000A
        dc.w $362F,$0008,$382F,$0006,$3A2F,$0004,$2C7A,$FEDA
        dc.w $2F57,$0014,$4FEF,$0014,$4EEE,$FFDC,$206F,$0016
        dc.w $302F,$0014,$322F,$0012,$226F,$000E,$342F,$000C
        dc.w $362F,$000A,$382F,$0008,$3A2F,$0006,$1C2F,$0004
        dc.w $2C7A,$FEA6,$2F57,$0016,$4FEF,$0016,$4EEE,$FDD8
        dc.w $2C7A,$FE96,$4EEE,$FE32,$2C7A,$FE8E,$4EEE,$FE38
        dc.w $226F,$0004,$2C7A,$FE82,$2F57,$0004,$588F,$4EEE
        dc.w $FEEC,$226F,$0004,$2C7A,$FE70,$2F57,$0004,$588F
        dc.w $4EEE,$FEDA,$2C7A,$FE62,$4EEE,$FE80,$2C7A,$FE5A
        dc.w $4EEE,$FF1C
; --------------------------------------------------------------------------
; ROUTINE: wrapper_WaitTOF [partial]
; Purpose: Adapter to graphics.library/WaitTOF; wraps the library call.
;   - Calls graphics.library/WaitTOF (LVO -270).
; Direct callers: H029+$16C6, H029+$1702, H007+$04E6, H007+$046E, H029+$15BC
; --------------------------------------------------------------------------
L016_000001AC:
; H016+$000001AC: 2c7afe52  movea.l $0(pc), a6
        movea.l H016+$0(pc), a6
L016_000001B0:
; H016+$000001B0: 4eeefef2  jmp -$10e(a6) ; graphics.library/WaitTOF
        jmp LVO_graphics_WaitTOF(a6)
; End H016: $1B4 bytes
