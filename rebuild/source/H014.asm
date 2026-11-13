; ============================================================================
; MODULE GUIDE H014
; Presentation/handling of the program errors.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; H014: 224 original bytes; all offsets are section-relative.
        section H014,code
H014:
; Preserved bytes H014+$00000000..$0000000A; code/data not fully classified.
        dc.w $3E00,$2E20,$0000
        dc.l H014+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H014 [partial]
; Purpose: Entry of the presentation/handling of the program errors module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H014+$00DA.
; Direct callers: H000+$011A
; --------------------------------------------------------------------------
L014_0000000A:
; H014+$0000000A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L014_0000000C:
; H014+$0000000C: 287afff8  movea.l $6(pc), a4
        movea.l H014+$6(pc), a4
L014_00000010:
; H014+$00000010: 4e550000  link.w a5, #$0
        link.w a5, #$0
L014_00000014:
; H014+$00000014: 600000c4  bra.w $da
        bra.w H014+$DA
; --------------------------------------------------------------------------
; ROUTINE: sub_H014_00000018 [partial]
; Purpose: Routine of the presentation/handling of the program errors module; calls H045+$01D6, H026+$0254, H026+$01E0, H030+$0256.
;   - Calls H045+$01D6.
;   - Calls H026+$0254.
;   - Calls H026+$01E0.
;   - Calls H030+$0256.
;   - Calls H010+$0974.
; Direct callers: H029+$050A, H029+$05CA, H029+$0AD8, H029+$0AEA, H028+$0E54, H029+$093C and 7 more
; --------------------------------------------------------------------------
L014_00000018:
; H014+$00000018: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L014_0000001A:
; H014+$0000001A: 287affea  movea.l $6(pc), a4
        movea.l H014+$6(pc), a4
L014_0000001E:
; H014+$0000001E: 4e55ffae  link.w a5, #$ffae
        link.w a5, #$ffae
L014_00000022:
; H014+$00000022: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L014_00000026:
; H014+$00000026: 5242  addq.w #$1, d2
        addq.w #$1, d2
L014_00000028:
; H014+$00000028: 08020000  btst.b #$0, d2
        btst #$0, d2
L014_0000002C:
; H014+$0000002C: 6702  beq.b $30
        beq.b H014+$30
L014_0000002E:
; H014+$0000002E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L014_00000030:
; H014+$00000030: 9ec2  suba.w d2, a7
        suba.w d2, a7
L014_00000032:
; H014+$00000032: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L014_00000036:
; H014+$00000036: 2b4f000e  move.l a7, $e(a5)
        move.l a7, $e(a5)
L014_0000003A:
; H014+$0000003A: 244f  movea.l a7, a2
        movea.l a7, a2
L014_0000003C:
; H014+$0000003C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L014_0000003E:
; H014+$0000003E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L014_00000040:
; H014+$00000040: 51cafffc  dbra d2, $3e
        dbra d2, H014+$3E
L014_00000044:
; H014+$00000044: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L014_00000048:
; H014+$00000048: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L014_0000004C:
; H014+$0000004C: 7400  moveq #$0, d2
        moveq #0, d2
L014_0000004E:
; H014+$0000004E: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L014_00000052:
; H014+$00000052: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L014_00000054:
; H014+$00000054: 4227  clr.b -(a7)
        clr.b -(a7)
L014_00000056:
; H014+$00000056: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L014_0000005A:
; H014+$0000005A: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L014_0000005E:
; H014+$0000005E: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L014_00000062:
; H014+$00000062: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L014_00000068:
; H014+$00000068: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L014_0000006C:
; H014+$0000006C: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L014_00000070:
; H014+$00000070: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L014_00000074:
; H014+$00000074: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L014_00000078:
; H014+$00000078: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H026+$0254 (sub_H026_00000254)
L014_0000007A:
; H014+$0000007A: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L014_00000080:
; H014+$00000080: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L014_00000084:
; H014+$00000084: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L014_00000088:
; H014+$00000088: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L014_0000008C:
; H014+$0000008C: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L014_00000090:
; H014+$00000090: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H026+$0254 (sub_H026_00000254)
L014_00000092:
; H014+$00000092: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L014_00000098:
; H014+$00000098: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L014_0000009C:
; H014+$0000009C: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L014_000000A0:
; H014+$000000A0: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L014_000000A4:
; H014+$000000A4: 486c0002  pea.l $2(a4)
        pea.l $2(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L014_000000A8:
; H014+$000000A8: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L014_000000AE:
; H014+$000000AE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L014_000000B2:
; H014+$000000B2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L014_000000B6:
; H014+$000000B6: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L014_000000BA:
; H014+$000000BA: 4267  clr.w -(a7)
        clr.w -(a7)
L014_000000BC:
; H014+$000000BC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L014_000000C0:
; H014+$000000C0: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; FLOW: Calls UI_DrawText (H030+$0256).
L014_000000C4:
; H014+$000000C4: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
; -> H010+$0974 (sub_H010_00000974)
L014_000000CA:
; H014+$000000CA: 4eb900000974  jsr $974.l
        jsr (H010+$974).l
L014_000000D0:
; H014+$000000D0: 4e5d  unlk a5
        unlk a5
L014_000000D2:
; H014+$000000D2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L014_000000D4:
; H014+$000000D4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L014_000000D6:
; H014+$000000D6: 508f  addq.l #$8, a7
        addq.l #$8, a7
L014_000000D8:
; H014+$000000D8: 4ed0  jmp (a0)
        jmp (a0)
L014_000000DA:
; H014+$000000DA: 4e5d  unlk a5
        unlk a5
L014_000000DC:
; H014+$000000DC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L014_000000DE:
; H014+$000000DE: 4e75  rts 
        rts 
; End H014: $E0 bytes
