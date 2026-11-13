; ============================================================================
; MODULE GUIDE H025
; Building of NewWindow and OpenWindow.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Building of NewWindow and OpenWindow call. The structure is prepared on the stack and passed to the Intuition wrapper.
; --------------------------------------------------------------------------
; H025: 264 original bytes; all offsets are section-relative.
        section H025,code
H025:
; Preserved bytes H025+$00000000..$0000001A; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000
        dc.l H025+$00000016
; --------------------------------------------------------------------------
; ROUTINE: module_init_H025 [partial]
; Purpose: Entry of the NewWindow and OpenWindow building module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H025+$00CC.
; Direct callers: H000+$0066
; --------------------------------------------------------------------------
L025_0000001A:
; H025+$0000001A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L025_0000001C:
; H025+$0000001C: 287afff8  movea.l $16(pc), a4
        movea.l H025+$16(pc), a4
L025_00000020:
; H025+$00000020: 4e550000  link.w a5, #$0
        link.w a5, #$0
L025_00000024:
; H025+$00000024: 600000a6  bra.w $cc
        bra.w H025+$CC
; FUNCTION: build_NewWindow_OpenWindow
FN_build_NewWindow_OpenWindow:
;
; --------------------------------------------------------------------------
; ROUTINE: Open_GameWindow [verified]
; Purpose: Builds a NewWindow on the stack and calls OpenWindow.
;   - Copies geometry, IDCMP, flags, title and screen/bitmap pointers.
;   - Selects the window type according to whether the screen is supplied.
;   - Uses the wrapper H021+$029C.
; Direct callers: H029+$1262
; --------------------------------------------------------------------------
L025_00000028:
; H025+$00000028: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L025_0000002A:
; H025+$0000002A: 287affea  movea.l $16(pc), a4
        movea.l H025+$16(pc), a4
L025_0000002E:
; H025+$0000002E: 4e55ffd0  link.w a5, #$ffd0
        link.w a5, #$ffd0
L025_00000032:
; H025+$00000032: 47edffd0  lea.l -$30(a5), a3
        lea.l -$30(a5), a3
L025_00000036:
; H025+$00000036: 36ad0026  move.w $26(a5), (a3)
        move.w $26(a5), (a3)
L025_0000003A:
; H025+$0000003A: 376d00240002  move.w $24(a5), $2(a3)
        move.w $24(a5), $2(a3)
L025_00000040:
; H025+$00000040: 376d00220004  move.w $22(a5), $4(a3)
        move.w $22(a5), $4(a3)
L025_00000046:
; H025+$00000046: 376d00200006  move.w $20(a5), $6(a3)
        move.w $20(a5), $6(a3)
L025_0000004C:
; H025+$0000004C: 176cffff0008  move.b -$1(a4), $8(a3)
        move.b -$1(a4), $8(a3)
L025_00000052:
; H025+$00000052: 176cfffe0009  move.b -$2(a4), $9(a3)
        move.b -$2(a4), $9(a3)
L025_00000058:
; H025+$00000058: 276d001c000a  move.l $1c(a5), $a(a3)
        move.l $1c(a5), $a(a3)
L025_0000005E:
; H025+$0000005E: 276d0018000e  move.l $18(a5), $e(a3)
        move.l $18(a5), $e(a3)
L025_00000064:
; H025+$00000064: 276d00140012  move.l $14(a5), $12(a3)
        move.l $14(a5), $12(a3)
L025_0000006A:
; H025+$0000006A: 276cfffa0016  move.l -$6(a4), $16(a3)
        move.l -$6(a4), $16(a3)
L025_00000070:
; H025+$00000070: 276d000c001a  move.l $c(a5), $1a(a3)
        move.l $c(a5), $1a(a3)
L025_00000076:
; H025+$00000076: 276d0010001e  move.l $10(a5), $1e(a3)
        move.l $10(a5), $1e(a3)
L025_0000007C:
; H025+$0000007C: 276cfff60022  move.l -$a(a4), $22(a3)
        move.l -$a(a4), $22(a3)
L025_00000082:
; H025+$00000082: 376cfff40026  move.w -$c(a4), $26(a3)
        move.w -$c(a4), $26(a3)
L025_00000088:
; H025+$00000088: 376cfff00028  move.w -$10(a4), $28(a3)
        move.w -$10(a4), $28(a3)
L025_0000008E:
; H025+$0000008E: 376cfff2002a  move.w -$e(a4), $2a(a3)
        move.w -$e(a4), $2a(a3)
L025_00000094:
; H025+$00000094: 376cffee002c  move.w -$12(a4), $2c(a3)
        move.w -$12(a4), $2c(a3)
L025_0000009A:
; H025+$0000009A: 4aad0010  tst.l $10(a5)
        tst.l $10(a5)
L025_0000009E:
; H025+$0000009E: 6600000c  bne.w $ac
        bne.w H025+$AC
L025_000000A2:
; H025+$000000A2: 377c0001002e  move.w #$1, $2e(a3)
        move.w #$1, $2e(a3)
L025_000000A8:
; H025+$000000A8: 60000008  bra.w $b2
        bra.w H025+$B2
L025_000000AC:
; H025+$000000AC: 377c000f002e  move.w #$f, $2e(a3)
        move.w #$f, $2e(a3)
L025_000000B2:
; H025+$000000B2: 486dffd0  pea.l -$30(a5)
        pea.l -$30(a5)
; -> H021+$029C (wrapper_OpenWindow)
L025_000000B6:
; H025+$000000B6: 4eb90000029c  jsr $29c.l
        jsr (H021+$29C).l
L025_000000BC:
; H025+$000000BC: 60000002  bra.w $c0
        bra.w H025+$C0
L025_000000C0:
; H025+$000000C0: 4e5d  unlk a5
        unlk a5
L025_000000C2:
; H025+$000000C2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L025_000000C4:
; H025+$000000C4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L025_000000C6:
; H025+$000000C6: 4fef001c  lea.l $1c(a7), a7
        lea.l $1c(a7), a7
L025_000000CA:
; H025+$000000CA: 4ed0  jmp (a0)
        jmp (a0)
L025_000000CC:
; H025+$000000CC: 29790000002affea  move.l $2a.l, -$16(a4)
        move.l (H015+$2A).l, -$16(a4)
L025_000000D4:
; H025+$000000D4: 197c00ffffff  move.b #$ff, -$1(a4)
        move.b #$ff, -$1(a4)
L025_000000DA:
; H025+$000000DA: 197c00fffffe  move.b #$ff, -$2(a4)
        move.b #$ff, -$2(a4)
L025_000000E0:
; H025+$000000E0: 397c0028fff4  move.w #$28, -$c(a4)
        move.w #$28, -$c(a4)
L025_000000E6:
; H025+$000000E6: 266cffea  movea.l -$16(a4), a3
        movea.l -$16(a4), a3
L025_000000EA:
; H025+$000000EA: 396b00dafff2  move.w $da(a3), -$e(a4)
        move.w $da(a3), -$e(a4)
L025_000000F0:
; H025+$000000F0: 397c0028fff0  move.w #$28, -$10(a4)
        move.w #$28, -$10(a4)
L025_000000F6:
; H025+$000000F6: 266cffea  movea.l -$16(a4), a3
        movea.l -$16(a4), a3
L025_000000FA:
; H025+$000000FA: 396b00d8ffee  move.w $d8(a3), -$12(a4)
        move.w $d8(a3), -$12(a4)
L025_00000100:
; H025+$00000100: 4e5d  unlk a5
        unlk a5
L025_00000102:
; H025+$00000102: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L025_00000104:
; H025+$00000104: 4e75  rts 
        rts 
; Preserved bytes H025+$00000106..$00000108; code/data not fully classified.
        dc.w $0000
; End H025: $108 bytes
