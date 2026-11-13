; ============================================================================
; MODULE GUIDE H024
; Building of NewScreen and OpenScreen.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Building of NewScreen and OpenScreen call. The structure is prepared on the stack and passed to the Intuition wrapper.
; --------------------------------------------------------------------------
; H024: 268 original bytes; all offsets are section-relative.
        section H024,code
H024:
; Preserved bytes H024+$00000000..$0000001C; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000
        dc.l H024+$00000018
; --------------------------------------------------------------------------
; ROUTINE: module_init_H024 [partial]
; Purpose: Entry of the NewScreen and OpenScreen building module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H024+$00E2.
; Direct callers: H000+$0060
; --------------------------------------------------------------------------
L024_0000001C:
; H024+$0000001C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L024_0000001E:
; H024+$0000001E: 287afff8  movea.l $18(pc), a4
        movea.l H024+$18(pc), a4
L024_00000022:
; H024+$00000022: 4e550000  link.w a5, #$0
        link.w a5, #$0
L024_00000026:
; H024+$00000026: 600000ba  bra.w $e2
        bra.w H024+$E2
; FUNCTION: build_NewScreen_OpenScreen
FN_build_NewScreen_OpenScreen:
;
; --------------------------------------------------------------------------
; ROUTINE: Open_GameScreen [verified]
; Purpose: Builds a NewScreen on the stack and calls OpenScreen.
;   - Derives the mode ID/flags from geometry and arguments.
;   - Fills in sizes, depth, colours, font, title and custom bitmap.
;   - Forwards the structure to the wrapper H021+$0184.
; Direct callers: H029+$1226
; --------------------------------------------------------------------------
L024_0000002A:
; H024+$0000002A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L024_0000002C:
; H024+$0000002C: 287affea  movea.l $18(pc), a4
        movea.l H024+$18(pc), a4
L024_00000030:
; H024+$00000030: 4e55ffde  link.w a5, #$ffde
        link.w a5, #$ffde
L024_00000034:
; H024+$00000034: 426dffde  clr.w -$22(a5)
        clr.w -$22(a5)
L024_00000038:
; H024+$00000038: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L024_0000003C:
; H024+$0000003C: 48c2  ext.l d2
        ext.l d2
L024_0000003E:
; H024+$0000003E: 85fc0002  divs.w #$2, d2
        divs.w #$2, d2
L024_00000042:
; H024+$00000042: 382d0014  move.w $14(a5), d4
        move.w $14(a5), d4
L024_00000046:
; H024+$00000046: b842  cmp.w d2, d4
        cmp.w d2, d4
L024_00000048:
; H024+$00000048: 6f000008  ble.w $52
        ble.w H024+$52
L024_0000004C:
; H024+$0000004C: 006d8000ffde  ori.w #$8000, -$22(a5)
        ori.w #$8000, -$22(a5)
L024_00000052:
; H024+$00000052: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L024_00000056:
; H024+$00000056: b46cfffc  cmp.w -$4(a4), d2
        cmp.w -$4(a4), d2
L024_0000005A:
; H024+$0000005A: 6f000008  ble.w $64
        ble.w H024+$64
L024_0000005E:
; H024+$0000005E: 006d0004ffde  ori.w #$4, -$22(a5)
        ori.w #$4, -$22(a5)
L024_00000064:
; H024+$00000064: 0c6d00060010  cmpi.w #$6, $10(a5)
        cmpi.w #$6, $10(a5)
L024_0000006A:
; H024+$0000006A: 66000008  bne.w $74
        bne.w H024+$74
L024_0000006E:
; H024+$0000006E: 006d0800ffde  ori.w #$800, -$22(a5)
        ori.w #$800, -$22(a5)
L024_00000074:
; H024+$00000074: 47edffe0  lea.l -$20(a5), a3
        lea.l -$20(a5), a3
L024_00000078:
; H024+$00000078: 36acfff8  move.w -$8(a4), (a3)
        move.w -$8(a4), (a3)
L024_0000007C:
; H024+$0000007C: 376cfff60002  move.w -$a(a4), $2(a3)
        move.w -$a(a4), $2(a3)
L024_00000082:
; H024+$00000082: 376d00140004  move.w $14(a5), $4(a3)
        move.w $14(a5), $4(a3)
L024_00000088:
; H024+$00000088: 376d00120006  move.w $12(a5), $6(a3)
        move.w $12(a5), $6(a3)
L024_0000008E:
; H024+$0000008E: 376d00100008  move.w $10(a5), $8(a3)
        move.w $10(a5), $8(a3)
L024_00000094:
; H024+$00000094: 176cfffb000a  move.b -$5(a4), $a(a3)
        move.b -$5(a4), $a(a3)
L024_0000009A:
; H024+$0000009A: 176cfffa000b  move.b -$6(a4), $b(a3)
        move.b -$6(a4), $b(a3)
L024_000000A0:
; H024+$000000A0: 376dffde000c  move.w -$22(a5), $c(a3)
        move.w -$22(a5), $c(a3)
L024_000000A6:
; H024+$000000A6: 342cffec  move.w -$14(a4), d2
        move.w -$14(a4), d2
L024_000000AA:
; H024+$000000AA: 0042000f  ori.w #$f, d2
        ori.w #$f, d2
L024_000000AE:
; H024+$000000AE: 3742000e  move.w d2, $e(a3)
        move.w d2, $e(a3)
L024_000000B2:
; H024+$000000B2: 276cfff20010  move.l -$e(a4), $10(a3)
        move.l -$e(a4), $10(a3)
L024_000000B8:
; H024+$000000B8: 276d000c0014  move.l $c(a5), $14(a3)
        move.l $c(a5), $14(a3)
L024_000000BE:
; H024+$000000BE: 42ab0018  clr.l $18(a3)
        clr.l $18(a3)
L024_000000C2:
; H024+$000000C2: 276cffee001c  move.l -$12(a4), $1c(a3)
        move.l -$12(a4), $1c(a3)
L024_000000C8:
; H024+$000000C8: 486dffe0  pea.l -$20(a5)
        pea.l -$20(a5)
; -> H021+$0184 (wrapper_OpenScreen)
L024_000000CC:
; H024+$000000CC: 4eb900000184  jsr $184.l
        jsr (H021+$184).l
L024_000000D2:
; H024+$000000D2: 60000002  bra.w $d6
        bra.w H024+$D6
L024_000000D6:
; H024+$000000D6: 4e5d  unlk a5
        unlk a5
L024_000000D8:
; H024+$000000D8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L024_000000DA:
; H024+$000000DA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L024_000000DC:
; H024+$000000DC: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L024_000000E0:
; H024+$000000E0: 4ed0  jmp (a0)
        jmp (a0)
L024_000000E2:
; H024+$000000E2: 29790000002affe8  move.l $2a.l, -$18(a4)
        move.l (H015+$2A).l, -$18(a4)
L024_000000EA:
; H024+$000000EA: 266cffe8  movea.l -$18(a4), a3
        movea.l -$18(a4), a3
L024_000000EE:
; H024+$000000EE: 396b00dafffe  move.w $da(a3), -$2(a4)
        move.w $da(a3), -$2(a4)
L024_000000F4:
; H024+$000000F4: 266cffe8  movea.l -$18(a4), a3
        movea.l -$18(a4), a3
L024_000000F8:
; H024+$000000F8: 396b00d8fffc  move.w $d8(a3), -$4(a4)
        move.w $d8(a3), -$4(a4)
L024_000000FE:
; H024+$000000FE: 197c0001fffa  move.b #$1, -$6(a4)
        move.b #$1, -$6(a4)
L024_00000104:
; H024+$00000104: 4e5d  unlk a5
        unlk a5
L024_00000106:
; H024+$00000106: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L024_00000108:
; H024+$00000108: 4e75  rts 
        rts 
; Preserved bytes H024+$0000010A..$0000010C; code/data not fully classified.
        dc.w $0000
; End H024: $10C bytes
