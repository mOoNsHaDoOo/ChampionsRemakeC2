; ============================================================================
; MODULE GUIDE H087
; Reading of BMHD, palette and BODY of ILBM pictures.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; ILBM reader: BMHD, CMAP palette and BODY; prepares the bitmap and transfers the rows of the planes through UnPackRow.
; --------------------------------------------------------------------------
; H087: 1132 original bytes; all offsets are section-relative.
        section H087,code
H087:
; Preserved bytes H087+$00000000..$00000004; code/data not fully classified.
        dc.l H087+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H087_0468 [partial]
; Purpose: Trampoline to H087+$0468; the actual body is there.
;   - Jumps to the actual body at H087+$0468.
; Direct callers: H000+$00D8
; --------------------------------------------------------------------------
L087_00000004:
; H087+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L087_00000008:
; H087+$00000008: 6000045e  bra.w $468
        bra.w H087+$468
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H087_0028 [partial]
; Purpose: Trampoline to H087+$0028; the actual body is there.
;   - Jumps to the actual body at H087+$0028.
; Direct callers: H040+$02EC, H040+$052C
; --------------------------------------------------------------------------
L087_0000000C:
; H087+$0000000C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L087_00000010:
; H087+$00000010: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L087_00000014:
; H087+$00000014: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L087_00000018:
; H087+$00000018: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L087_0000001A:
; H087+$0000001A: 7414  moveq #$14, d2
        moveq #20, d2
L087_0000001C:
; H087+$0000001C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H086+$03F2 (trampoline_H086_049E)
L087_0000001E:
; H087+$0000001E: 4eb9000003f2  jsr $3f2.l
        jsr (H086+$3F2).l
L087_00000024:
; H087+$00000024: 60000002  bra.w $28
        bra.w H087+$28
L087_00000028:
; H087+$00000028: 4e5d  unlk a5
        unlk a5
L087_0000002A:
; H087+$0000002A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L087_0000002C:
; H087+$0000002C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L087_0000002E:
; H087+$0000002E: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H087+$00000030..$0000009C; code/data not fully classified.
        dc.w $4E55,$0000,$2F2D,$000C,$266D,$0008,$2F0B,$7404
        dc.w $2F02,$4EB9
        dc.l H086+$000003F2
        dc.w $6000,$0002,$4E5D,$205F,$508F,$4ED0,$4E55,$0000
        dc.w $2F2D,$000C,$266D,$0008,$2F0B,$7408,$2F02,$4EB9
        dc.l H086+$000003F2
        dc.w $6000,$0002,$4E5D,$205F,$508F,$4ED0,$4E55,$0000
        dc.w $2F2D,$000C,$266D,$0008,$2F0B,$7402,$2F02,$4EB9
        dc.l H086+$000003F2
        dc.w $6000,$0002,$4E5D,$205F,$508F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H087_0000009C [partial]
; Purpose: Routine of the reading of BMHD, palette and BODY of ILBM pictures module; calls H015+$00BC, H086+$03F2.
;   - Calls H015+$00BC.
;   - Calls H086+$03F2.
; Direct callers: H040+$031A, H040+$0566
; --------------------------------------------------------------------------
L087_0000009C:
; H087+$0000009C: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L087_000000A0:
; H087+$000000A0: 2b6d000cfff2  move.l $c(a5), -$e(a5)
        move.l $c(a5), -$e(a5)
L087_000000A6:
; H087+$000000A6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L087_000000AA:
; H087+$000000AA: 242b0018  move.l $18(a3), d2
        move.l $18(a3), d2
L087_000000AE:
; H087+$000000AE: 2002  move.l d2, d0
        move.l d2, d0
L087_000000B0:
; H087+$000000B0: 7203  moveq #$3, d1
        moveq #3, d1
; -> H015+$00BC (sub_H015_000000BC)
L087_000000B2:
; H087+$000000B2: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L087_000000B8:
; H087+$000000B8: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L087_000000BC:
; H087+$000000BC: 7400  moveq #$0, d2
        moveq #0, d2
L087_000000BE:
; H087+$000000BE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L087_000000C2:
; H087+$000000C2: 1413  move.b (a3), d2
        move.b (a3), d2
L087_000000C4:
; H087+$000000C4: 7800  moveq #$0, d4
        moveq #0, d4
L087_000000C6:
; H087+$000000C6: 182dffff  move.b -$1(a5), d4
        move.b -$1(a5), d4
L087_000000CA:
; H087+$000000CA: b444  cmp.w d4, d2
        cmp.w d4, d2
L087_000000CC:
; H087+$000000CC: 6400000a  bcc.w $d8
        bcc.w H087+$D8
L087_000000D0:
; H087+$000000D0: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L087_000000D4:
; H087+$000000D4: 1b53ffff  move.b (a3), -$1(a5)
        move.b (a3), -$1(a5)
L087_000000D8:
; H087+$000000D8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L087_000000DC:
; H087+$000000DC: 16adffff  move.b -$1(a5), (a3)
        move.b -$1(a5), (a3)
L087_000000E0:
; H087+$000000E0: 7400  moveq #$0, d2
        moveq #0, d2
L087_000000E2:
; H087+$000000E2: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L087_000000E6:
; H087+$000000E6: 4a42  tst.w d2
        tst.w d2
L087_000000E8:
; H087+$000000E8: 6300006c  bls.w $156
        bls.w H087+$156
L087_000000EC:
; H087+$000000EC: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L087_000000F0:
; H087+$000000F0: 47edfff6  lea.l -$a(a5), a3
        lea.l -$a(a5), a3
L087_000000F4:
; H087+$000000F4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L087_000000F6:
; H087+$000000F6: 7403  moveq #$3, d2
        moveq #3, d2
L087_000000F8:
; H087+$000000F8: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H086+$03F2 (trampoline_H086_049E)
L087_000000FA:
; H087+$000000FA: 4eb9000003f2  jsr $3f2.l
        jsr (H086+$3F2).l
L087_00000100:
; H087+$00000100: 2b40fffa  move.l d0, -$6(a5)
        move.l d0, -$6(a5)
L087_00000104:
; H087+$00000104: 4aadfffa  tst.l -$6(a5)
        tst.l -$6(a5)
L087_00000108:
; H087+$00000108: 6700000a  beq.w $114
        beq.w H087+$114
L087_0000010C:
; H087+$0000010C: 202dfffa  move.l -$6(a5), d0
        move.l -$6(a5), d0
L087_00000110:
; H087+$00000110: 6000004a  bra.w $15c
        bra.w H087+$15C
L087_00000114:
; H087+$00000114: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000116:
; H087+$00000116: 142dfff6  move.b -$a(a5), d2
        move.b -$a(a5), d2
L087_0000011A:
; H087+$0000011A: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L087_00000120:
; H087+$00000120: e84a  lsr.w #$4, d2
        lsr.w #$4, d2
L087_00000122:
; H087+$00000122: e142  asl.w #$8, d2
        asl.w #$8, d2
L087_00000124:
; H087+$00000124: 7800  moveq #$0, d4
        moveq #0, d4
L087_00000126:
; H087+$00000126: 182dfff7  move.b -$9(a5), d4
        move.b -$9(a5), d4
L087_0000012A:
; H087+$0000012A: 02840000ffff  andi.l #$ffff, d4
        andi.l #$ffff, d4
L087_00000130:
; H087+$00000130: e84c  lsr.w #$4, d4
        lsr.w #$4, d4
L087_00000132:
; H087+$00000132: e944  asl.w #$4, d4
        asl.w #$4, d4
L087_00000134:
; H087+$00000134: d444  add.w d4, d2
        add.w d4, d2
L087_00000136:
; H087+$00000136: 7800  moveq #$0, d4
        moveq #0, d4
L087_00000138:
; H087+$00000138: 182dfff8  move.b -$8(a5), d4
        move.b -$8(a5), d4
L087_0000013C:
; H087+$0000013C: 02840000ffff  andi.l #$ffff, d4
        andi.l #$ffff, d4
L087_00000142:
; H087+$00000142: e84c  lsr.w #$4, d4
        lsr.w #$4, d4
L087_00000144:
; H087+$00000144: d444  add.w d4, d2
        add.w d4, d2
L087_00000146:
; H087+$00000146: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L087_0000014A:
; H087+$0000014A: 3682  move.w d2, (a3)
        move.w d2, (a3)
L087_0000014C:
; H087+$0000014C: 54adfff2  addq.l #$2, -$e(a5)
        addq.l #$2, -$e(a5)
L087_00000150:
; H087+$00000150: 532dffff  subq.b #$1, -$1(a5)
        subq.b #$1, -$1(a5)
L087_00000154:
; H087+$00000154: 608a  bra.b $e0
        bra.b H087+$E0
L087_00000156:
; H087+$00000156: 7000  moveq #$0, d0
        moveq #0, d0
L087_00000158:
; H087+$00000158: 60000002  bra.w $15c
        bra.w H087+$15C
L087_0000015C:
; H087+$0000015C: 4e5d  unlk a5
        unlk a5
L087_0000015E:
; H087+$0000015E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L087_00000160:
; H087+$00000160: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L087_00000164:
; H087+$00000164: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Read_ILBM_BODY [verified]
; Purpose: Reads BODY transferring rows and planes into the destination bitmap.
;   - Computes the bytes per row and checks geometry, buffer and compression.
;   - Checks the masking flag and prepares the pointers to the planes.
;   - For every row and plane it reads/copies the data or calls the row decompression.
;   - The accepted compression mode is limited to 0 or 1.
; Direct callers: H040+$042C
; --------------------------------------------------------------------------
L087_00000166:
; H087+$00000166: 4e55ff94  link.w a5, #$ff94
        link.w a5, #$ff94
L087_0000016A:
; H087+$0000016A: 7400  moveq #$0, d2
        moveq #0, d2
L087_0000016C:
; H087+$0000016C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L087_00000170:
; H087+$00000170: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L087_00000174:
; H087+$00000174: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L087_00000178:
; H087+$00000178: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L087_0000017C:
; H087+$0000017C: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
; -> H054+$000C (trampoline_H054_0028)
L087_0000017E:
; H087+$0000017E: 4eb90000000c  jsr $c.l
        jsr (H054+$C).l
L087_00000184:
; H087+$00000184: 3b40fff8  move.w d0, -$8(a5)
        move.w d0, -$8(a5)
L087_00000188:
; H087+$00000188: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H099+$01B0 (trampoline_H099_01CE)
L087_0000018C:
; H087+$0000018C: 4eb9000001b0  jsr $1b0.l
        jsr (H099+$1B0).l
L087_00000192:
; H087+$00000192: 02800000ffff  andi.l #$ffff, d0
        andi.l #$ffff, d0
L087_00000198:
; H087+$00000198: 2b40fff4  move.l d0, -$c(a5)
        move.l d0, -$c(a5)
L087_0000019C:
; H087+$0000019C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L087_000001A0:
; H087+$000001A0: 3b6b0002fff2  move.w $2(a3), -$e(a5)
        move.w $2(a3), -$e(a5)
L087_000001A6:
; H087+$000001A6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L087_000001AA:
; H087+$000001AA: 1b6b000afff1  move.b $a(a3), -$f(a5)
        move.b $a(a3), -$f(a5)
L087_000001B0:
; H087+$000001B0: 7400  moveq #$0, d2
        moveq #0, d2
L087_000001B2:
; H087+$000001B2: 142dfff1  move.b -$f(a5), d2
        move.b -$f(a5), d2
L087_000001B6:
; H087+$000001B6: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L087_000001BA:
; H087+$000001BA: 63000008  bls.w $1c4
        bls.w H087+$1C4
L087_000001BE:
; H087+$000001BE: 70fa  moveq #$fa, d0
        moveq #-6, d0
L087_000001C0:
; H087+$000001C0: 6000029c  bra.w $45e
        bra.w H087+$45E
L087_000001C4:
; H087+$000001C4: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L087_000001C8:
; H087+$000001C8: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L087_000001CC:
; H087+$000001CC: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L087_000001CE:
; H087+$000001CE: 6600001c  bne.w $1ec
        bne.w H087+$1EC
L087_000001D2:
; H087+$000001D2: 242dfff4  move.l -$c(a5), d2
        move.l -$c(a5), d2
L087_000001D6:
; H087+$000001D6: e382  asl.l #$1, d2
        asl.l #$1, d2
L087_000001D8:
; H087+$000001D8: 282d0008  move.l $8(a5), d4
        move.l $8(a5), d4
L087_000001DC:
; H087+$000001DC: b882  cmp.l d2, d4
        cmp.l d2, d4
L087_000001DE:
; H087+$000001DE: 6d00000c  blt.w $1ec
        blt.w H087+$1EC
L087_000001E2:
; H087+$000001E2: 0c6d0011fffa  cmpi.w #$11, -$6(a5)
        cmpi.w #$11, -$6(a5)
L087_000001E8:
; H087+$000001E8: 63000008  bls.w $1f2
        bls.w H087+$1F2
L087_000001EC:
; H087+$000001EC: 70fa  moveq #$fa, d0
        moveq #-6, d0
L087_000001EE:
; H087+$000001EE: 6000026e  bra.w $45e
        bra.w H087+$45E
L087_000001F2:
; H087+$000001F2: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L087_000001F6:
; H087+$000001F6: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L087_000001FA:
; H087+$000001FA: b46b0002  cmp.w $2(a3), d2
        cmp.w $2(a3), d2
L087_000001FE:
; H087+$000001FE: 6300000c  bls.w $20c
        bls.w H087+$20C
L087_00000202:
; H087+$00000202: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L087_00000206:
; H087+$00000206: 3b6b0002fff2  move.w $2(a3), -$e(a5)
        move.w $2(a3), -$e(a5)
L087_0000020C:
; H087+$0000020C: 426dffee  clr.w -$12(a5)
        clr.w -$12(a5)
L087_00000210:
; H087+$00000210: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000212:
; H087+$00000212: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L087_00000216:
; H087+$00000216: 142b0005  move.b $5(a3), d2
        move.b $5(a3), d2
L087_0000021A:
; H087+$0000021A: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L087_0000021E:
; H087+$0000021E: b842  cmp.w d2, d4
        cmp.w d2, d4
L087_00000220:
; H087+$00000220: 64000026  bcc.w $248
        bcc.w H087+$248
L087_00000224:
; H087+$00000224: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L087_00000228:
; H087+$00000228: e542  asl.w #$2, d2
        asl.w #$2, d2
L087_0000022A:
; H087+$0000022A: 47edff94  lea.l -$6c(a5), a3
        lea.l -$6c(a5), a3
L087_0000022E:
; H087+$0000022E: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L087_00000232:
; H087+$00000232: e544  asl.w #$2, d4
        asl.w #$2, d4
L087_00000234:
; H087+$00000234: 246d0018  movea.l $18(a5), a2
        movea.l $18(a5), a2
L087_00000238:
; H087+$00000238: 45ea0008  lea.l $8(a2), a2
        lea.l $8(a2), a2
L087_0000023C:
; H087+$0000023C: 27b240002000  move.l (a2, d4.w), (a3, d2.w)
        move.l (a2, d4.w), (a3, d2.w)
L087_00000242:
; H087+$00000242: 526dffee  addq.w #$1, -$12(a5)
        addq.w #$1, -$12(a5)
L087_00000246:
; H087+$00000246: 60c8  bra.b $210
        bra.b H087+$210
L087_00000248:
; H087+$00000248: 0c6d0011ffee  cmpi.w #$11, -$12(a5)
        cmpi.w #$11, -$12(a5)
L087_0000024E:
; H087+$0000024E: 64000016  bcc.w $266
        bcc.w H087+$266
L087_00000252:
; H087+$00000252: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L087_00000256:
; H087+$00000256: e542  asl.w #$2, d2
        asl.w #$2, d2
L087_00000258:
; H087+$00000258: 47edff94  lea.l -$6c(a5), a3
        lea.l -$6c(a5), a3
L087_0000025C:
; H087+$0000025C: 42b32000  clr.l (a3, d2.w)
        clr.l (a3, d2.w)
L087_00000260:
; H087+$00000260: 526dffee  addq.w #$1, -$12(a5)
        addq.w #$1, -$12(a5)
L087_00000264:
; H087+$00000264: 60e2  bra.b $248
        bra.b H087+$248
L087_00000266:
; H087+$00000266: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000268:
; H087+$00000268: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L087_0000026C:
; H087+$0000026C: 142b0009  move.b $9(a3), d2
        move.b $9(a3), d2
L087_00000270:
; H087+$00000270: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L087_00000274:
; H087+$00000274: 66000030  bne.w $2a6
        bne.w H087+$2A6
L087_00000278:
; H087+$00000278: 4aad0014  tst.l $14(a5)
        tst.l $14(a5)
L087_0000027C:
; H087+$0000027C: 67000016  beq.w $294
        beq.w H087+$294
L087_00000280:
; H087+$00000280: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L087_00000284:
; H087+$00000284: e542  asl.w #$2, d2
        asl.w #$2, d2
L087_00000286:
; H087+$00000286: 47edff94  lea.l -$6c(a5), a3
        lea.l -$6c(a5), a3
L087_0000028A:
; H087+$0000028A: 27ad00142000  move.l $14(a5), (a3, d2.w)
        move.l $14(a5), (a3, d2.w)
L087_00000290:
; H087+$00000290: 60000010  bra.w $2a2
        bra.w H087+$2A2
L087_00000294:
; H087+$00000294: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L087_00000298:
; H087+$00000298: e542  asl.w #$2, d2
        asl.w #$2, d2
L087_0000029A:
; H087+$0000029A: 47edff94  lea.l -$6c(a5), a3
        lea.l -$6c(a5), a3
L087_0000029E:
; H087+$0000029E: 42b32000  clr.l (a3, d2.w)
        clr.l (a3, d2.w)
L087_000002A2:
; H087+$000002A2: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L087_000002A6:
; H087+$000002A6: 2b6d000cffe0  move.l $c(a5), -$20(a5)
        move.l $c(a5), -$20(a5)
L087_000002AC:
; H087+$000002AC: 7400  moveq #$0, d2
        moveq #0, d2
L087_000002AE:
; H087+$000002AE: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L087_000002B2:
; H087+$000002B2: d5ad000c  add.l d2, $c(a5)
        add.l d2, $c(a5)
L087_000002B6:
; H087+$000002B6: 7400  moveq #$0, d2
        moveq #0, d2
L087_000002B8:
; H087+$000002B8: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L087_000002BC:
; H087+$000002BC: 95ad0008  sub.l d2, $8(a5)
        sub.l d2, $8(a5)
L087_000002C0:
; H087+$000002C0: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L087_000002C4:
; H087+$000002C4: d4ad0008  add.l $8(a5), d2
        add.l $8(a5), d2
L087_000002C8:
; H087+$000002C8: 2b42ffe4  move.l d2, -$1c(a5)
        move.l d2, -$1c(a5)
L087_000002CC:
; H087+$000002CC: 3b6dfff2ffec  move.w -$e(a5), -$14(a5)
        move.w -$e(a5), -$14(a5)
L087_000002D2:
; H087+$000002D2: 4a6dffec  tst.w -$14(a5)
        tst.w -$14(a5)
L087_000002D6:
; H087+$000002D6: 63000180  bls.w $458
        bls.w H087+$458
L087_000002DA:
; H087+$000002DA: 426dffee  clr.w -$12(a5)
        clr.w -$12(a5)
L087_000002DE:
; H087+$000002DE: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L087_000002E2:
; H087+$000002E2: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L087_000002E6:
; H087+$000002E6: 64000168  bcc.w $450
        bcc.w H087+$450
L087_000002EA:
; H087+$000002EA: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L087_000002EE:
; H087+$000002EE: e542  asl.w #$2, d2
        asl.w #$2, d2
L087_000002F0:
; H087+$000002F0: 47edff94  lea.l -$6c(a5), a3
        lea.l -$6c(a5), a3
L087_000002F4:
; H087+$000002F4: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L087_000002F8:
; H087+$000002F8: 2b4bffd8  move.l a3, -$28(a5)
        move.l a3, -$28(a5)
L087_000002FC:
; H087+$000002FC: 266dffd8  movea.l -$28(a5), a3
        movea.l -$28(a5), a3
L087_00000300:
; H087+$00000300: 4a93  tst.l (a3)
        tst.l (a3)
L087_00000302:
; H087+$00000302: 66000010  bne.w $314
        bne.w H087+$314
L087_00000306:
; H087+$00000306: 2b6dffe0ffdc  move.l -$20(a5), -$24(a5)
        move.l -$20(a5), -$24(a5)
L087_0000030C:
; H087+$0000030C: 47edffdc  lea.l -$24(a5), a3
        lea.l -$24(a5), a3
L087_00000310:
; H087+$00000310: 2b4bffd8  move.l a3, -$28(a5)
        move.l a3, -$28(a5)
L087_00000314:
; H087+$00000314: 242dffe4  move.l -$1c(a5), d2
        move.l -$1c(a5), d2
L087_00000318:
; H087+$00000318: 94ad000c  sub.l $c(a5), d2
        sub.l $c(a5), d2
L087_0000031C:
; H087+$0000031C: 3b42ffea  move.w d2, -$16(a5)
        move.w d2, -$16(a5)
L087_00000320:
; H087+$00000320: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000322:
; H087+$00000322: 342dffea  move.w -$16(a5), d2
        move.w -$16(a5), d2
L087_00000326:
; H087+$00000326: 282d0008  move.l $8(a5), d4
        move.l $8(a5), d4
L087_0000032A:
; H087+$0000032A: 9882  sub.l d2, d4
        sub.l d2, d4
L087_0000032C:
; H087+$0000032C: 3b44ffe8  move.w d4, -$18(a5)
        move.w d4, -$18(a5)
L087_00000330:
; H087+$00000330: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000332:
; H087+$00000332: 342dffe8  move.w -$18(a5), d2
        move.w -$18(a5), d2
L087_00000336:
; H087+$00000336: b4adfff4  cmp.l -$c(a5), d2
        cmp.l -$c(a5), d2
L087_0000033A:
; H087+$0000033A: 6c000098  bge.w $3d4
        bge.w H087+$3D4
L087_0000033E:
; H087+$0000033E: 2f2dffe4  move.l -$1c(a5), -(a7)
        move.l -$1c(a5), -(a7)
L087_00000342:
; H087+$00000342: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L087_00000346:
; H087+$00000346: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000348:
; H087+$00000348: 342dffe8  move.w -$18(a5), d2
        move.w -$18(a5), d2
L087_0000034C:
; H087+$0000034C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L087_0000034E:
; H087+$0000034E: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L087_00000354:
; H087+$00000354: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000356:
; H087+$00000356: 342dffea  move.w -$16(a5), d2
        move.w -$16(a5), d2
L087_0000035A:
; H087+$0000035A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L087_0000035C:
; H087+$0000035C: 2f2d001c  move.l $1c(a5), -(a7)
        move.l $1c(a5), -(a7)
; -> H039+$000C (trampoline_H039_0022)
L087_00000360:
; H087+$00000360: 4eb90000000c  jsr $c.l
        jsr (H039+$C).l
L087_00000366:
; H087+$00000366: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L087_00000368:
; H087+$00000368: 2800  move.l d0, d4
        move.l d0, d4
L087_0000036A:
; H087+$0000036A: b484  cmp.l d4, d2
        cmp.l d4, d2
L087_0000036C:
; H087+$0000036C: 6f000022  ble.w $390
        ble.w H087+$390
L087_00000370:
; H087+$00000370: 2f2d001c  move.l $1c(a5), -(a7)
        move.l $1c(a5), -(a7)
; -> H039+$000C (trampoline_H039_0022)
L087_00000374:
; H087+$00000374: 4eb90000000c  jsr $c.l
        jsr (H039+$C).l
L087_0000037A:
; H087+$0000037A: 3b40ffea  move.w d0, -$16(a5)
        move.w d0, -$16(a5)
L087_0000037E:
; H087+$0000037E: 342dffe8  move.w -$18(a5), d2
        move.w -$18(a5), d2
L087_00000382:
; H087+$00000382: d46dffea  add.w -$16(a5), d2
        add.w -$16(a5), d2
L087_00000386:
; H087+$00000386: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L087_0000038C:
; H087+$0000038C: 2b420008  move.l d2, $8(a5)
        move.l d2, $8(a5)
L087_00000390:
; H087+$00000390: 2f2d001c  move.l $1c(a5), -(a7)
        move.l $1c(a5), -(a7)
L087_00000394:
; H087+$00000394: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000396:
; H087+$00000396: 342dffe8  move.w -$18(a5), d2
        move.w -$18(a5), d2
L087_0000039A:
; H087+$0000039A: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L087_0000039E:
; H087+$0000039E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L087_000003A0:
; H087+$000003A0: 7400  moveq #$0, d2
        moveq #0, d2
L087_000003A2:
; H087+$000003A2: 342dffea  move.w -$16(a5), d2
        move.w -$16(a5), d2
L087_000003A6:
; H087+$000003A6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H086+$03F2 (trampoline_H086_049E)
L087_000003A8:
; H087+$000003A8: 4eb9000003f2  jsr $3f2.l
        jsr (H086+$3F2).l
L087_000003AE:
; H087+$000003AE: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L087_000003B2:
; H087+$000003B2: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L087_000003B6:
; H087+$000003B6: 6700000a  beq.w $3c2
        beq.w H087+$3C2
L087_000003BA:
; H087+$000003BA: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L087_000003BE:
; H087+$000003BE: 6000009e  bra.w $45e
        bra.w H087+$45E
L087_000003C2:
; H087+$000003C2: 2b6d000cffe4  move.l $c(a5), -$1c(a5)
        move.l $c(a5), -$1c(a5)
L087_000003C8:
; H087+$000003C8: 242d0008  move.l $8(a5), d2
        move.l $8(a5), d2
L087_000003CC:
; H087+$000003CC: 3b42ffe8  move.w d2, -$18(a5)
        move.w d2, -$18(a5)
L087_000003D0:
; H087+$000003D0: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L087_000003D4:
; H087+$000003D4: 7400  moveq #$0, d2
        moveq #0, d2
L087_000003D6:
; H087+$000003D6: 142dfff1  move.b -$f(a5), d2
        move.b -$f(a5), d2
L087_000003DA:
; H087+$000003DA: 4a42  tst.w d2
        tst.w d2
L087_000003DC:
; H087+$000003DC: 66000046  bne.w $424
        bne.w H087+$424
L087_000003E0:
; H087+$000003E0: 342dffe8  move.w -$18(a5), d2
        move.w -$18(a5), d2
L087_000003E4:
; H087+$000003E4: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L087_000003E8:
; H087+$000003E8: 64000008  bcc.w $3f2
        bcc.w H087+$3F2
L087_000003EC:
; H087+$000003EC: 70f9  moveq #$f9, d0
        moveq #-7, d0
L087_000003EE:
; H087+$000003EE: 6000006e  bra.w $45e
        bra.w H087+$45E
L087_000003F2:
; H087+$000003F2: 2f2dffe4  move.l -$1c(a5), -(a7)
        move.l -$1c(a5), -(a7)
L087_000003F6:
; H087+$000003F6: 266dffd8  movea.l -$28(a5), a3
        movea.l -$28(a5), a3
L087_000003FA:
; H087+$000003FA: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L087_000003FC:
; H087+$000003FC: 7400  moveq #$0, d2
        moveq #0, d2
L087_000003FE:
; H087+$000003FE: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L087_00000402:
; H087+$00000402: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L087_00000404:
; H087+$00000404: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L087_0000040A:
; H087+$0000040A: 7400  moveq #$0, d2
        moveq #0, d2
L087_0000040C:
; H087+$0000040C: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L087_00000410:
; H087+$00000410: d5adffe4  add.l d2, -$1c(a5)
        add.l d2, -$1c(a5)
L087_00000414:
; H087+$00000414: 7400  moveq #$0, d2
        moveq #0, d2
L087_00000416:
; H087+$00000416: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L087_0000041A:
; H087+$0000041A: 266dffd8  movea.l -$28(a5), a3
        movea.l -$28(a5), a3
L087_0000041E:
; H087+$0000041E: d593  add.l d2, (a3)
        add.l d2, (a3)
L087_00000420:
; H087+$00000420: 60000026  bra.w $448
        bra.w H087+$448
L087_00000424:
; H087+$00000424: 486dffe4  pea.l -$1c(a5)
        pea.l -$1c(a5)
L087_00000428:
; H087+$00000428: 2f2dffd8  move.l -$28(a5), -(a7)
        move.l -$28(a5), -(a7)
L087_0000042C:
; H087+$0000042C: 3f2dffe8  move.w -$18(a5), -(a7)
        move.w -$18(a5), -(a7)
L087_00000430:
; H087+$00000430: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; FLOW: Calls UnPackRow_ByteRun1 (H088+$000C).
L087_00000434:
; H087+$00000434: 4eb90000000c  jsr $c.l
        jsr (H088+$C).l
L087_0000043A:
; H087+$0000043A: 1400  move.b d0, d2
        move.b d0, d2
L087_0000043C:
; H087+$0000043C: 4a02  tst.b d2
        tst.b d2
L087_0000043E:
; H087+$0000043E: 67000008  beq.w $448
        beq.w H087+$448
L087_00000442:
; H087+$00000442: 70f9  moveq #$f9, d0
        moveq #-7, d0
L087_00000444:
; H087+$00000444: 60000018  bra.w $45e
        bra.w H087+$45E
L087_00000448:
; H087+$00000448: 526dffee  addq.w #$1, -$12(a5)
        addq.w #$1, -$12(a5)
L087_0000044C:
; H087+$0000044C: 6000fe90  bra.w $2de
        bra.w H087+$2DE
L087_00000450:
; H087+$00000450: 536dffec  subq.w #$1, -$14(a5)
        subq.w #$1, -$14(a5)
L087_00000454:
; H087+$00000454: 6000fe7c  bra.w $2d2
        bra.w H087+$2D2
L087_00000458:
; H087+$00000458: 7000  moveq #$0, d0
        moveq #0, d0
L087_0000045A:
; H087+$0000045A: 60000002  bra.w $45e
        bra.w H087+$45E
L087_0000045E:
; H087+$0000045E: 4e5d  unlk a5
        unlk a5
L087_00000460:
; H087+$00000460: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L087_00000462:
; H087+$00000462: 4fef0018  lea.l $18(a7), a7
        lea.l $18(a7), a7
L087_00000466:
; H087+$00000466: 4ed0  jmp (a0)
        jmp (a0)
L087_00000468:
; H087+$00000468: 4e5d  unlk a5
        unlk a5
L087_0000046A:
; H087+$0000046A: 4e75  rts 
        rts 
; End H087: $46C bytes
