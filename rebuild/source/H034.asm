; ============================================================================
; MODULE GUIDE H034
; loading of 8x8 resources (8X8D) and error messages.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; --------------------------------------------------------------------------
; MODULE NOTE
; Loading of 8x8 resources (8X8D) and error messages. The strings of the module include 'Unable to load ... from 8x8D'.
; --------------------------------------------------------------------------
; H034: 472 original bytes; all offsets are section-relative.
        section H034,code
H034:
; Preserved bytes H034+$00000000..$00000024; code/data not fully classified.
        dc.w $3878,$3864,$0055,$6E61,$626C,$6520,$746F,$206C
        dc.w $6F61,$6420,$0020,$6672,$6F6D,$2038,$7838,$4400
        dc.l H034+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H034 [partial]
; Purpose: Entry of the loading of 8x8 resources (8X8D) and error messages module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H034+$01D2.
; Direct callers: H000+$014A
; --------------------------------------------------------------------------
L034_00000024:
; H034+$00000024: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L034_00000026:
; H034+$00000026: 287afff8  movea.l $20(pc), a4
        movea.l H034+$20(pc), a4
L034_0000002A:
; H034+$0000002A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L034_0000002E:
; H034+$0000002E: 600001a2  bra.w $1d2
        bra.w H034+$1D2
; --------------------------------------------------------------------------
; ROUTINE: sub_H034_00000032 [partial]
; Purpose: Routine of the loading of 8x8 resources (8X8D) and error messages module; calls H045+$01D6, H026+$01E0, H029+$0A0E, H010+$0974.
;   - Calls H045+$01D6.
;   - Calls H026+$01E0.
;   - Calls H029+$0A0E.
;   - Calls H010+$0974.
;   - Calls H010+$0332.
;   - Uses the global state: H005+$246E (resource group selector).
; Direct callers: H006+$0734, H006+$0740, H011+$1818, H011+$1834
; --------------------------------------------------------------------------
L034_00000032:
; H034+$00000032: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L034_00000034:
; H034+$00000034: 287affea  movea.l $20(pc), a4
        movea.l H034+$20(pc), a4
L034_00000038:
; H034+$00000038: 4e55ff04  link.w a5, #$ff04
        link.w a5, #$ff04
L034_0000003C:
; H034+$0000003C: 7400  moveq #$0, d2
        moveq #0, d2
L034_0000003E:
; H034+$0000003E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L034_00000042:
; H034+$00000042: 4a42  tst.w d2
        tst.w d2
L034_00000044:
; H034+$00000044: 65000010  bcs.w $56
        bcs.w H034+$56
L034_00000048:
; H034+$00000048: 7400  moveq #$0, d2
        moveq #0, d2
L034_0000004A:
; H034+$0000004A: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L034_0000004E:
; H034+$0000004E: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L034_00000052:
; H034+$00000052: 63000006  bls.w $5a
        bls.w H034+$5A
L034_00000056:
; H034+$00000056: 60000116  bra.w $16e
        bra.w H034+$16E
L034_0000005A:
; H034+$0000005A: 47ec0000  lea.l $0(a4), a3
        lea.l $0(a4), a3
L034_0000005E:
; H034+$0000005E: 45edff08  lea.l -$f8(a5), a2
        lea.l -$f8(a5), a2
L034_00000062:
; H034+$00000062: 7450  moveq #$50, d2
        moveq #80, d2
L034_00000064:
; H034+$00000064: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L034_00000066:
; H034+$00000066: 57cafffc  dbeq d2, $64
        dbeq d2, H034+$64
L034_0000006A:
; H034+$0000006A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L034_0000006E:
; H034+$0000006E: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L034_00000072:
; H034+$00000072: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$246E = resource group selector
L034_00000074:
; H034+$00000074: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L034_0000007A:
; H034+$0000007A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L034_0000007C:
; H034+$0000007C: 4227  clr.b -(a7)
        clr.b -(a7)
L034_0000007E:
; H034+$0000007E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L034_00000082:
; H034+$00000082: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L034_00000086:
; H034+$00000086: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L034_0000008A:
; H034+$0000008A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L034_00000090:
; H034+$00000090: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L034_00000094:
; H034+$00000094: 486dff08  pea.l -$f8(a5)
        pea.l -$f8(a5)
L034_00000098:
; H034+$00000098: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L034_0000009C:
; H034+$0000009C: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L034_000000A0:
; H034+$000000A0: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L034_000000A6:
; H034+$000000A6: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L034_000000AA:
; H034+$000000AA: 486dff08  pea.l -$f8(a5)
        pea.l -$f8(a5)
L034_000000AE:
; H034+$000000AE: 7400  moveq #$0, d2
        moveq #0, d2
L034_000000B0:
; H034+$000000B0: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L034_000000B4:
; H034+$000000B4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L034_000000B6:
; H034+$000000B6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L034_000000BA:
; H034+$000000BA: 1f3c000d  move.b #$d, -(a7)
        move.b #$d, -(a7)
L034_000000BE:
; H034+$000000BE: 7400  moveq #$0, d2
        moveq #0, d2
L034_000000C0:
; H034+$000000C0: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L034_000000C4:
; H034+$000000C4: e542  asl.w #$2, d2
        asl.w #$2, d2
L034_000000C6:
; H034+$000000C6: 47f900003338  lea.l $3338.l, a3
        lea.l (H005+$3338).l, a3
L034_000000CC:
; H034+$000000CC: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L034_000000D0:
; H034+$000000D0: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L034_000000D6:
; H034+$000000D6: 7400  moveq #$0, d2
        moveq #0, d2
L034_000000D8:
; H034+$000000D8: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L034_000000DC:
; H034+$000000DC: e542  asl.w #$2, d2
        asl.w #$2, d2
L034_000000DE:
; H034+$000000DE: 47f900003338  lea.l $3338.l, a3
        lea.l (H005+$3338).l, a3
L034_000000E4:
; H034+$000000E4: 4ab32000  tst.l (a3, d2.w)
        tst.l (a3, d2.w)
L034_000000E8:
; H034+$000000E8: 66000084  bne.w $16e
        bne.w H034+$16E
L034_000000EC:
; H034+$000000EC: 47ec0005  lea.l $5(a4), a3
        lea.l $5(a4), a3
L034_000000F0:
; H034+$000000F0: 45edffac  lea.l -$54(a5), a2
        lea.l -$54(a5), a2
L034_000000F4:
; H034+$000000F4: 7450  moveq #$50, d2
        moveq #80, d2
L034_000000F6:
; H034+$000000F6: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L034_000000F8:
; H034+$000000F8: 57cafffc  dbeq d2, $f6
        dbeq d2, H034+$F6
L034_000000FC:
; H034+$000000FC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L034_00000100:
; H034+$00000100: 486dff5a  pea.l -$a6(a5)
        pea.l -$a6(a5)
L034_00000104:
; H034+$00000104: 7400  moveq #$0, d2
        moveq #0, d2
L034_00000106:
; H034+$00000106: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L034_0000010A:
; H034+$0000010A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L034_0000010C:
; H034+$0000010C: 4227  clr.b -(a7)
        clr.b -(a7)
L034_0000010E:
; H034+$0000010E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L034_00000112:
; H034+$00000112: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L034_00000116:
; H034+$00000116: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L034_0000011A:
; H034+$0000011A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L034_00000120:
; H034+$00000120: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L034_00000124:
; H034+$00000124: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L034_00000128:
; H034+$00000128: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L034_0000012C:
; H034+$0000012C: 486dff5a  pea.l -$a6(a5)
        pea.l -$a6(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L034_00000130:
; H034+$00000130: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L034_00000136:
; H034+$00000136: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L034_0000013A:
; H034+$0000013A: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L034_0000013E:
; H034+$0000013E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L034_00000142:
; H034+$00000142: 486c0015  pea.l $15(a4)
        pea.l $15(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L034_00000146:
; H034+$00000146: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L034_0000014C:
; H034+$0000014C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L034_00000150:
; H034+$00000150: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L034_00000154:
; H034+$00000154: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L034_00000158:
; H034+$00000158: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L034_0000015C:
; H034+$0000015C: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
; -> H010+$0974 (sub_H010_00000974)
L034_00000162:
; H034+$00000162: 4eb900000974  jsr $974.l
        jsr (H010+$974).l
; -> H010+$0332 (sub_H010_00000332)
L034_00000168:
; H034+$00000168: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L034_0000016E:
; H034+$0000016E: 4e5d  unlk a5
        unlk a5
L034_00000170:
; H034+$00000170: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L034_00000172:
; H034+$00000172: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L034_00000174:
; H034+$00000174: 588f  addq.l #$4, a7
        addq.l #$4, a7
L034_00000176:
; H034+$00000176: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H034_01A8 [partial]
; Purpose: Trampoline to H034+$01A8; the actual body is there.
;   - Jumps to the actual body at H034+$01A8.
;   - Calls H049+$012A.
; Direct callers: H044+$0308, H044+$031E, H044+$02C2, H044+$027C, H044+$0298, H044+$035E and 28 more
; --------------------------------------------------------------------------
L034_00000178:
; H034+$00000178: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L034_0000017A:
; H034+$0000017A: 287afea4  movea.l $20(pc), a4
        movea.l H034+$20(pc), a4
L034_0000017E:
; H034+$0000017E: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L034_00000182:
; H034+$00000182: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L034_00000186:
; H034+$00000186: 67000012  beq.w $19a
        beq.w H034+$19A
L034_0000018A:
; H034+$0000018A: 2679000027c2  movea.l $27c2.l, a3
        movea.l (H005+$27C2).l, a3
L034_00000190:
; H034+$00000190: 2b6b0010fffc  move.l $10(a3), -$4(a5)
        move.l $10(a3), -$4(a5)
L034_00000196:
; H034+$00000196: 60000010  bra.w $1a8
        bra.w H034+$1A8
; STATE: H005+$52F2 = pointer to the game screen
L034_0000019A:
; H034+$0000019A: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L034_000001A0:
; H034+$000001A0: 47eb00b8  lea.l $b8(a3), a3
        lea.l $b8(a3), a3
L034_000001A4:
; H034+$000001A4: 2b4bfffc  move.l a3, -$4(a5)
        move.l a3, -$4(a5)
L034_000001A8:
; H034+$000001A8: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L034_000001AC:
; H034+$000001AC: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L034_000001B0:
; H034+$000001B0: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L034_000001B4:
; H034+$000001B4: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L034_000001B8:
; H034+$000001B8: 47f900003338  lea.l $3338.l, a3
        lea.l (H005+$3338).l, a3
L034_000001BE:
; H034+$000001BE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H049+$012A (trampoline_H049_0198)
L034_000001C0:
; H034+$000001C0: 4eb90000012a  jsr $12a.l
        jsr (H049+$12A).l
L034_000001C6:
; H034+$000001C6: 4e5d  unlk a5
        unlk a5
L034_000001C8:
; H034+$000001C8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L034_000001CA:
; H034+$000001CA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L034_000001CC:
; H034+$000001CC: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L034_000001D0:
; H034+$000001D0: 4ed0  jmp (a0)
        jmp (a0)
L034_000001D2:
; H034+$000001D2: 4e5d  unlk a5
        unlk a5
L034_000001D4:
; H034+$000001D4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L034_000001D6:
; H034+$000001D6: 4e75  rts 
        rts 
; End H034: $1D8 bytes
