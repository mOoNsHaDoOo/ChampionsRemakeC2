; ============================================================================
; MODULE GUIDE H045
; shared arithmetic and support helpers.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; --------------------------------------------------------------------------
; MODULE NOTE
; Shared arithmetic and support helpers: conversions, divisions/multiplications and small calculations used by UI and combat.
; --------------------------------------------------------------------------
; H045: 828 original bytes; all offsets are section-relative.
        section H045,code
H045:
; Preserved bytes H045+$00000000..$00000004; code/data not fully classified.
        dc.l H045+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H045_0336 [partial]
; Purpose: Trampoline to H045+$0336; the actual body is there.
;   - Jumps to the actual body at H045+$0336.
; Direct callers: H000+$007E
; --------------------------------------------------------------------------
L045_00000004:
; H045+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L045_00000008:
; H045+$00000008: 6000032c  bra.w $336
        bra.w H045+$336
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H045_01CC [partial]
; Purpose: Trampoline to H045+$01CC; the actual body is there.
;   - Jumps to the actual body at H045+$01CC.
; Direct callers: H030+$0A06, H067+$054A, H067+$06D0
; --------------------------------------------------------------------------
L045_0000000C:
; H045+$0000000C: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L045_00000010:
; H045+$00000010: 60000056  bra.w $68
        bra.w H045+$68
; --------------------------------------------------------------------------
; ROUTINE: sub_H045_00000014 [partial]
; Purpose: Routine of the shared arithmetic and support helpers module; calls H015+$004A.
;   - Calls H015+$004A.
; Direct callers: H045+$006E, H045+$00CA
; --------------------------------------------------------------------------
L045_00000014:
; H045+$00000014: 4e550000  link.w a5, #$0
        link.w a5, #$0
L045_00000018:
; H045+$00000018: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L045_0000001C:
; H045+$0000001C: 342bfffe  move.w -$2(a3), d2
        move.w -$2(a3), d2
L045_00000020:
; H045+$00000020: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L045_00000024:
; H045+$00000024: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L045_00000028:
; H045+$00000028: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L045_0000002C:
; H045+$0000002C: 6700002c  beq.w $5a
        beq.w H045+$5A
L045_00000030:
; H045+$00000030: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L045_00000034:
; H045+$00000034: 342bfffe  move.w -$2(a3), d2
        move.w -$2(a3), d2
L045_00000038:
; H045+$00000038: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L045_0000003C:
; H045+$0000003C: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L045_00000040:
; H045+$00000040: 0c3300202000  cmpi.b #$20, (a3, d2.w)
        cmpi.b #$20, (a3, d2.w)
L045_00000046:
; H045+$00000046: 67000008  beq.w $50
        beq.w H045+$50
L045_0000004A:
; H045+$0000004A: 7001  moveq #$1, d0
        moveq #1, d0
L045_0000004C:
; H045+$0000004C: 60000012  bra.w $60
        bra.w H045+$60
L045_00000050:
; H045+$00000050: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L045_00000054:
; H045+$00000054: 526bfffe  addq.w #$1, -$2(a3)
        addq.w #$1, -$2(a3)
L045_00000058:
; H045+$00000058: 60be  bra.b $18
        bra.b H045+$18
L045_0000005A:
; H045+$0000005A: 7000  moveq #$0, d0
        moveq #0, d0
L045_0000005C:
; H045+$0000005C: 60000002  bra.w $60
        bra.w H045+$60
L045_00000060:
; H045+$00000060: 4e5d  unlk a5
        unlk a5
L045_00000062:
; H045+$00000062: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L045_00000064:
; H045+$00000064: 588f  addq.l #$4, a7
        addq.l #$4, a7
L045_00000066:
; H045+$00000066: 4ed0  jmp (a0)
        jmp (a0)
L045_00000068:
; H045+$00000068: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L045_0000006C:
; H045+$0000006C: 4855  pea.l (a5)
        pea.l (a5)
L045_0000006E:
; H045+$0000006E: 61a4  bsr.b $14
        bsr.b H045+$14
L045_00000070:
; H045+$00000070: 1400  move.b d0, d2
        move.b d0, d2
L045_00000072:
; H045+$00000072: 4a02  tst.b d2
        tst.b d2
L045_00000074:
; H045+$00000074: 66000008  bne.w $7e
        bne.w H045+$7E
L045_00000078:
; H045+$00000078: 7000  moveq #$0, d0
        moveq #0, d0
L045_0000007A:
; H045+$0000007A: 60000150  bra.w $1cc
        bra.w H045+$1CC
L045_0000007E:
; H045+$0000007E: 4a2d000a  tst.b $a(a5)
        tst.b $a(a5)
L045_00000082:
; H045+$00000082: 67000058  beq.w $dc
        beq.w H045+$DC
L045_00000086:
; H045+$00000086: 422dfff5  clr.b -$b(a5)
        clr.b -$b(a5)
L045_0000008A:
; H045+$0000008A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L045_0000008E:
; H045+$0000008E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L045_00000092:
; H045+$00000092: 0c33002d2000  cmpi.b #$2d, (a3, d2.w)
        cmpi.b #$2d, (a3, d2.w)
L045_00000098:
; H045+$00000098: 67000014  beq.w $ae
        beq.w H045+$AE
L045_0000009C:
; H045+$0000009C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L045_000000A0:
; H045+$000000A0: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L045_000000A4:
; H045+$000000A4: 0c33002b2000  cmpi.b #$2b, (a3, d2.w)
        cmpi.b #$2b, (a3, d2.w)
L045_000000AA:
; H045+$000000AA: 66000030  bne.w $dc
        bne.w H045+$DC
L045_000000AE:
; H045+$000000AE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L045_000000B2:
; H045+$000000B2: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L045_000000B6:
; H045+$000000B6: 0c33002d2000  cmpi.b #$2d, (a3, d2.w)
        cmpi.b #$2d, (a3, d2.w)
L045_000000BC:
; H045+$000000BC: 57c2  seq.b d2
        seq.b d2
L045_000000BE:
; H045+$000000BE: 4402  neg.b d2
        neg.b d2
L045_000000C0:
; H045+$000000C0: 1b42fff5  move.b d2, -$b(a5)
        move.b d2, -$b(a5)
L045_000000C4:
; H045+$000000C4: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L045_000000C8:
; H045+$000000C8: 4855  pea.l (a5)
        pea.l (a5)
L045_000000CA:
; H045+$000000CA: 6100ff48  bsr.w $14
        bsr.w H045+$14
L045_000000CE:
; H045+$000000CE: 1400  move.b d0, d2
        move.b d0, d2
L045_000000D0:
; H045+$000000D0: 4a02  tst.b d2
        tst.b d2
L045_000000D2:
; H045+$000000D2: 66000008  bne.w $dc
        bne.w H045+$DC
L045_000000D6:
; H045+$000000D6: 7000  moveq #$0, d0
        moveq #0, d0
L045_000000D8:
; H045+$000000D8: 600000f2  bra.w $1cc
        bra.w H045+$1CC
L045_000000DC:
; H045+$000000DC: 7400  moveq #$0, d2
        moveq #0, d2
L045_000000DE:
; H045+$000000DE: 2b42fff6  move.l d2, -$a(a5)
        move.l d2, -$a(a5)
L045_000000E2:
; H045+$000000E2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L045_000000E6:
; H045+$000000E6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L045_000000EA:
; H045+$000000EA: 0c3300202000  cmpi.b #$20, (a3, d2.w)
        cmpi.b #$20, (a3, d2.w)
L045_000000F0:
; H045+$000000F0: 630000b2  bls.w $1a4
        bls.w H045+$1A4
L045_000000F4:
; H045+$000000F4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L045_000000F8:
; H045+$000000F8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L045_000000FC:
; H045+$000000FC: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L045_00000100:
; H045+$00000100: 0c040061  cmpi.b #$61, d4
        cmpi.b #$61, d4
L045_00000104:
; H045+$00000104: 650a  bcs.b $110
        bcs.b H045+$110
L045_00000106:
; H045+$00000106: 0c04007a  cmpi.b #$7a, d4
        cmpi.b #$7a, d4
L045_0000010A:
; H045+$0000010A: 6204  bhi.b $110
        bhi.b H045+$110
L045_0000010C:
; H045+$0000010C: 0204005f  andi.b #$5f, d4
        andi.b #$5f, d4
L045_00000110:
; H045+$00000110: 1b44fffb  move.b d4, -$5(a5)
        move.b d4, -$5(a5)
L045_00000114:
; H045+$00000114: 0c2d0030fffb  cmpi.b #$30, -$5(a5)
        cmpi.b #$30, -$5(a5)
L045_0000011A:
; H045+$0000011A: 6500001e  bcs.w $13a
        bcs.w H045+$13A
L045_0000011E:
; H045+$0000011E: 0c2d0039fffb  cmpi.b #$39, -$5(a5)
        cmpi.b #$39, -$5(a5)
L045_00000124:
; H045+$00000124: 62000014  bhi.w $13a
        bhi.w H045+$13A
L045_00000128:
; H045+$00000128: 7400  moveq #$0, d2
        moveq #0, d2
L045_0000012A:
; H045+$0000012A: 142dfffb  move.b -$5(a5), d2
        move.b -$5(a5), d2
L045_0000012E:
; H045+$0000012E: 04420030  subi.w #$30, d2
        subi.w #$30, d2
L045_00000132:
; H045+$00000132: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L045_00000136:
; H045+$00000136: 60000032  bra.w $16a
        bra.w H045+$16A
L045_0000013A:
; H045+$0000013A: 0c2d0041fffb  cmpi.b #$41, -$5(a5)
        cmpi.b #$41, -$5(a5)
L045_00000140:
; H045+$00000140: 65000022  bcs.w $164
        bcs.w H045+$164
L045_00000144:
; H045+$00000144: 0c2d005afffb  cmpi.b #$5a, -$5(a5)
        cmpi.b #$5a, -$5(a5)
L045_0000014A:
; H045+$0000014A: 62000018  bhi.w $164
        bhi.w H045+$164
L045_0000014E:
; H045+$0000014E: 7400  moveq #$0, d2
        moveq #0, d2
L045_00000150:
; H045+$00000150: 142dfffb  move.b -$5(a5), d2
        move.b -$5(a5), d2
L045_00000154:
; H045+$00000154: 04420041  subi.w #$41, d2
        subi.w #$41, d2
L045_00000158:
; H045+$00000158: 0642000a  addi.w #$a, d2
        addi.w #$a, d2
L045_0000015C:
; H045+$0000015C: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L045_00000160:
; H045+$00000160: 60000008  bra.w $16a
        bra.w H045+$16A
L045_00000164:
; H045+$00000164: 7000  moveq #$0, d0
        moveq #0, d0
L045_00000166:
; H045+$00000166: 60000064  bra.w $1cc
        bra.w H045+$1CC
L045_0000016A:
; H045+$0000016A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L045_0000016E:
; H045+$0000016E: b46d0008  cmp.w $8(a5), d2
        cmp.w $8(a5), d2
L045_00000172:
; H045+$00000172: 65000008  bcs.w $17c
        bcs.w H045+$17C
L045_00000176:
; H045+$00000176: 7000  moveq #$0, d0
        moveq #0, d0
L045_00000178:
; H045+$00000178: 60000052  bra.w $1cc
        bra.w H045+$1CC
L045_0000017C:
; H045+$0000017C: 7400  moveq #$0, d2
        moveq #0, d2
L045_0000017E:
; H045+$0000017E: 342d0008  move.w $8(a5), d2
        move.w $8(a5), d2
L045_00000182:
; H045+$00000182: 2002  move.l d2, d0
        move.l d2, d0
L045_00000184:
; H045+$00000184: 222dfff6  move.l -$a(a5), d1
        move.l -$a(a5), d1
; -> H015+$004A (sub_H015_0000004A)
L045_00000188:
; H045+$00000188: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L045_0000018E:
; H045+$0000018E: 2400  move.l d0, d2
        move.l d0, d2
L045_00000190:
; H045+$00000190: 7800  moveq #$0, d4
        moveq #0, d4
L045_00000192:
; H045+$00000192: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L045_00000196:
; H045+$00000196: d484  add.l d4, d2
        add.l d4, d2
L045_00000198:
; H045+$00000198: 2b42fff6  move.l d2, -$a(a5)
        move.l d2, -$a(a5)
L045_0000019C:
; H045+$0000019C: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L045_000001A0:
; H045+$000001A0: 6000ff40  bra.w $e2
        bra.w H045+$E2
L045_000001A4:
; H045+$000001A4: 4a2d000a  tst.b $a(a5)
        tst.b $a(a5)
L045_000001A8:
; H045+$000001A8: 67000014  beq.w $1be
        beq.w H045+$1BE
L045_000001AC:
; H045+$000001AC: 4a2dfff5  tst.b -$b(a5)
        tst.b -$b(a5)
L045_000001B0:
; H045+$000001B0: 6700000c  beq.w $1be
        beq.w H045+$1BE
L045_000001B4:
; H045+$000001B4: 242dfff6  move.l -$a(a5), d2
        move.l -$a(a5), d2
L045_000001B8:
; H045+$000001B8: 4482  neg.l d2
        neg.l d2
L045_000001BA:
; H045+$000001BA: 2b42fff6  move.l d2, -$a(a5)
        move.l d2, -$a(a5)
L045_000001BE:
; H045+$000001BE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L045_000001C2:
; H045+$000001C2: 26adfff6  move.l -$a(a5), (a3)
        move.l -$a(a5), (a3)
L045_000001C6:
; H045+$000001C6: 7001  moveq #$1, d0
        moveq #1, d0
L045_000001C8:
; H045+$000001C8: 60000002  bra.w $1cc
        bra.w H045+$1CC
L045_000001CC:
; H045+$000001CC: 4e5d  unlk a5
        unlk a5
L045_000001CE:
; H045+$000001CE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L045_000001D0:
; H045+$000001D0: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L045_000001D4:
; H045+$000001D4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H045_000001D6 [partial]
; Purpose: Routine of the shared arithmetic and support helpers module; calls H015+$006E.
;   - Calls H015+$006E.
; Direct callers: H056+$07AE, H062+$2264, H056+$08DA, H056+$08FE, H056+$0922, H063+$0FD8 and 77 more
; --------------------------------------------------------------------------
L045_000001D6:
; H045+$000001D6: 4e55ffa2  link.w a5, #$ffa2
        link.w a5, #$ffa2
L045_000001DA:
; H045+$000001DA: 426dffa8  clr.w -$58(a5)
        clr.w -$58(a5)
L045_000001DE:
; H045+$000001DE: 426dffa6  clr.w -$5a(a5)
        clr.w -$5a(a5)
L045_000001E2:
; H045+$000001E2: 426dffa2  clr.w -$5e(a5)
        clr.w -$5e(a5)
L045_000001E6:
; H045+$000001E6: 2b6d0010ffaa  move.l $10(a5), -$56(a5)
        move.l $10(a5), -$56(a5)
L045_000001EC:
; H045+$000001EC: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L045_000001F0:
; H045+$000001F0: 67000026  beq.w $218
        beq.w H045+$218
L045_000001F4:
; H045+$000001F4: 4aad0010  tst.l $10(a5)
        tst.l $10(a5)
L045_000001F8:
; H045+$000001F8: 6c00001e  bge.w $218
        bge.w H045+$218
L045_000001FC:
; H045+$000001FC: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L045_00000200:
; H045+$00000200: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L045_00000204:
; H045+$00000204: 17bc002d2000  move.b #$2d, (a3, d2.w)
        move.b #$2d, (a3, d2.w)
L045_0000020A:
; H045+$0000020A: 526dffa6  addq.w #$1, -$5a(a5)
        addq.w #$1, -$5a(a5)
L045_0000020E:
; H045+$0000020E: 242d0010  move.l $10(a5), d2
        move.l $10(a5), d2
L045_00000212:
; H045+$00000212: 4482  neg.l d2
        neg.l d2
L045_00000214:
; H045+$00000214: 2b42ffaa  move.l d2, -$56(a5)
        move.l d2, -$56(a5)
L045_00000218:
; H045+$00000218: 7400  moveq #$0, d2
        moveq #0, d2
L045_0000021A:
; H045+$0000021A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L045_0000021E:
; H045+$0000021E: 282dffaa  move.l -$56(a5), d4
        move.l -$56(a5), d4
L045_00000222:
; H045+$00000222: 2004  move.l d4, d0
        move.l d4, d0
L045_00000224:
; H045+$00000224: 2202  move.l d2, d1
        move.l d2, d1
; -> H015+$006E (sub_H015_0000006E)
L045_00000226:
; H045+$00000226: 4eb90000006e  jsr $6e.l
        jsr (H015+$6E).l
L045_0000022C:
; H045+$0000022C: 3b41ffae  move.w d1, -$52(a5)
        move.w d1, -$52(a5)
L045_00000230:
; H045+$00000230: 0c6d000affae  cmpi.w #$a, -$52(a5)
        cmpi.w #$a, -$52(a5)
L045_00000236:
; H045+$00000236: 6400001a  bcc.w $252
        bcc.w H045+$252
L045_0000023A:
; H045+$0000023A: 342dffa8  move.w -$58(a5), d2
        move.w -$58(a5), d2
L045_0000023E:
; H045+$0000023E: 47edffb0  lea.l -$50(a5), a3
        lea.l -$50(a5), a3
L045_00000242:
; H045+$00000242: 382dffae  move.w -$52(a5), d4
        move.w -$52(a5), d4
L045_00000246:
; H045+$00000246: 06440030  addi.w #$30, d4
        addi.w #$30, d4
L045_0000024A:
; H045+$0000024A: 17842000  move.b d4, (a3, d2.w)
        move.b d4, (a3, d2.w)
L045_0000024E:
; H045+$0000024E: 6000001a  bra.w $26a
        bra.w H045+$26A
L045_00000252:
; H045+$00000252: 342dffa8  move.w -$58(a5), d2
        move.w -$58(a5), d2
L045_00000256:
; H045+$00000256: 47edffb0  lea.l -$50(a5), a3
        lea.l -$50(a5), a3
L045_0000025A:
; H045+$0000025A: 382dffae  move.w -$52(a5), d4
        move.w -$52(a5), d4
L045_0000025E:
; H045+$0000025E: 06440041  addi.w #$41, d4
        addi.w #$41, d4
L045_00000262:
; H045+$00000262: 0444000a  subi.w #$a, d4
        subi.w #$a, d4
L045_00000266:
; H045+$00000266: 17842000  move.b d4, (a3, d2.w)
        move.b d4, (a3, d2.w)
L045_0000026A:
; H045+$0000026A: 526dffa8  addq.w #$1, -$58(a5)
        addq.w #$1, -$58(a5)
L045_0000026E:
; H045+$0000026E: 7400  moveq #$0, d2
        moveq #0, d2
L045_00000270:
; H045+$00000270: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L045_00000274:
; H045+$00000274: 282dffaa  move.l -$56(a5), d4
        move.l -$56(a5), d4
L045_00000278:
; H045+$00000278: 2004  move.l d4, d0
        move.l d4, d0
L045_0000027A:
; H045+$0000027A: 2202  move.l d2, d1
        move.l d2, d1
; -> H015+$006E (sub_H015_0000006E)
L045_0000027C:
; H045+$0000027C: 4eb90000006e  jsr $6e.l
        jsr (H015+$6E).l
L045_00000282:
; H045+$00000282: 2b40ffaa  move.l d0, -$56(a5)
        move.l d0, -$56(a5)
L045_00000286:
; H045+$00000286: 4aadffaa  tst.l -$56(a5)
        tst.l -$56(a5)
L045_0000028A:
; H045+$0000028A: 668c  bne.b $218
        bne.b H045+$218
L045_0000028C:
; H045+$0000028C: 342d000a  move.w $a(a5), d2
        move.w $a(a5), d2
L045_00000290:
; H045+$00000290: b46dffa8  cmp.w -$58(a5), d2
        cmp.w -$58(a5), d2
L045_00000294:
; H045+$00000294: 63000040  bls.w $2d6
        bls.w H045+$2D6
L045_00000298:
; H045+$00000298: 342d000a  move.w $a(a5), d2
        move.w $a(a5), d2
L045_0000029C:
; H045+$0000029C: 946dffa8  sub.w -$58(a5), d2
        sub.w -$58(a5), d2
L045_000002A0:
; H045+$000002A0: 3b42ffa4  move.w d2, -$5c(a5)
        move.w d2, -$5c(a5)
L045_000002A4:
; H045+$000002A4: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L045_000002A8:
; H045+$000002A8: 382dffa6  move.w -$5a(a5), d4
        move.w -$5a(a5), d4
L045_000002AC:
; H045+$000002AC: b842  cmp.w d2, d4
        cmp.w d2, d4
L045_000002AE:
; H045+$000002AE: 64000026  bcc.w $2d6
        bcc.w H045+$2D6
L045_000002B2:
; H045+$000002B2: 4a6dffa4  tst.w -$5c(a5)
        tst.w -$5c(a5)
L045_000002B6:
; H045+$000002B6: 6300001e  bls.w $2d6
        bls.w H045+$2D6
L045_000002BA:
; H045+$000002BA: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L045_000002BE:
; H045+$000002BE: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L045_000002C2:
; H045+$000002C2: 17ad00082000  move.b $8(a5), (a3, d2.w)
        move.b $8(a5), (a3, d2.w)
L045_000002C8:
; H045+$000002C8: 526dffa6  addq.w #$1, -$5a(a5)
        addq.w #$1, -$5a(a5)
L045_000002CC:
; H045+$000002CC: 536dffa4  subq.w #$1, -$5c(a5)
        subq.w #$1, -$5c(a5)
L045_000002D0:
; H045+$000002D0: 526dffa2  addq.w #$1, -$5e(a5)
        addq.w #$1, -$5e(a5)
L045_000002D4:
; H045+$000002D4: 60ce  bra.b $2a4
        bra.b H045+$2A4
L045_000002D6:
; H045+$000002D6: 536dffa8  subq.w #$1, -$58(a5)
        subq.w #$1, -$58(a5)
L045_000002DA:
; H045+$000002DA: 4a6dffa8  tst.w -$58(a5)
        tst.w -$58(a5)
L045_000002DE:
; H045+$000002DE: 6d000040  blt.w $320
        blt.w H045+$320
L045_000002E2:
; H045+$000002E2: 342dffa2  move.w -$5e(a5), d2
        move.w -$5e(a5), d2
L045_000002E6:
; H045+$000002E6: b46d000a  cmp.w $a(a5), d2
        cmp.w $a(a5), d2
L045_000002EA:
; H045+$000002EA: 64000034  bcc.w $320
        bcc.w H045+$320
L045_000002EE:
; H045+$000002EE: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L045_000002F2:
; H045+$000002F2: 382dffa6  move.w -$5a(a5), d4
        move.w -$5a(a5), d4
L045_000002F6:
; H045+$000002F6: b842  cmp.w d2, d4
        cmp.w d2, d4
L045_000002F8:
; H045+$000002F8: 64000026  bcc.w $320
        bcc.w H045+$320
L045_000002FC:
; H045+$000002FC: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L045_00000300:
; H045+$00000300: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L045_00000304:
; H045+$00000304: 382dffa8  move.w -$58(a5), d4
        move.w -$58(a5), d4
L045_00000308:
; H045+$00000308: 45edffb0  lea.l -$50(a5), a2
        lea.l -$50(a5), a2
L045_0000030C:
; H045+$0000030C: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L045_00000312:
; H045+$00000312: 526dffa6  addq.w #$1, -$5a(a5)
        addq.w #$1, -$5a(a5)
L045_00000316:
; H045+$00000316: 536dffa8  subq.w #$1, -$58(a5)
        subq.w #$1, -$58(a5)
L045_0000031A:
; H045+$0000031A: 526dffa2  addq.w #$1, -$5e(a5)
        addq.w #$1, -$5e(a5)
L045_0000031E:
; H045+$0000031E: 60ba  bra.b $2da
        bra.b H045+$2DA
L045_00000320:
; H045+$00000320: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L045_00000324:
; H045+$00000324: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L045_00000328:
; H045+$00000328: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L045_0000032C:
; H045+$0000032C: 4e5d  unlk a5
        unlk a5
L045_0000032E:
; H045+$0000032E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L045_00000330:
; H045+$00000330: 4fef0012  lea.l $12(a7), a7
        lea.l $12(a7), a7
L045_00000334:
; H045+$00000334: 4ed0  jmp (a0)
        jmp (a0)
L045_00000336:
; H045+$00000336: 4e5d  unlk a5
        unlk a5
L045_00000338:
; H045+$00000338: 4e75  rts 
        rts 
; Preserved bytes H045+$0000033A..$0000033C; code/data not fully classified.
        dc.w $0000
; End H045: $33C bytes
