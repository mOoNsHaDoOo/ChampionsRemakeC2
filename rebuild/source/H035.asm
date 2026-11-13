; ============================================================================
; MODULE GUIDE H035
; loading of the 24x24 set and COMSPR resources.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; --------------------------------------------------------------------------
; MODULE NOTE
; Loading of 24x24 sets and COMSPR resources. The strings include 'Start range error in Load24x24Set'; the routines handle offset and range of the frames.
; --------------------------------------------------------------------------
; H035: 1760 original bytes; all offsets are section-relative.
        section H035,code
H035:
; Preserved bytes H035+$00000000..$00000032; code/data not fully classified.
        dc.w $5374,$6172,$7420,$7261,$6E67,$6520,$6572,$726F
        dc.w $7220,$696E,$204C,$6F61,$6432,$3478,$3234,$5365
        dc.w $7400,$434F,$4D53,$5052,$0049,$434F,$4E00
        dc.l H035+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H035 [partial]
; Purpose: Entry of the loading of 24x24 sets and COMSPR resources module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H035+$06D8.
; Direct callers: H000+$015C
; --------------------------------------------------------------------------
L035_00000032:
; H035+$00000032: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L035_00000034:
; H035+$00000034: 287afff8  movea.l $2e(pc), a4
        movea.l H035+$2E(pc), a4
L035_00000038:
; H035+$00000038: 4e550000  link.w a5, #$0
        link.w a5, #$0
L035_0000003C:
; H035+$0000003C: 6000069a  bra.w $6d8
        bra.w H035+$6D8
; --------------------------------------------------------------------------
; ROUTINE: sub_H035_00000040 [partial]
; Purpose: Routine of the loading of 24x24 sets and COMSPR resources module; calls H010+$0360, H010+$0332, H029+$0A0E, H016+$0014.
;   - Calls H010+$0360.
;   - Calls H010+$0332.
;   - Calls H029+$0A0E.
;   - Calls H016+$0014.
;   - Calls H029+$067A.
; Direct callers: H095+$1664, H095+$167E, H095+$16AA, H095+$16C4
; --------------------------------------------------------------------------
L035_00000040:
; H035+$00000040: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L035_00000042:
; H035+$00000042: 287affea  movea.l $2e(pc), a4
        movea.l H035+$2E(pc), a4
L035_00000046:
; H035+$00000046: 4e55fff0  link.w a5, #$fff0
        link.w a5, #$fff0
L035_0000004A:
; H035+$0000004A: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L035_0000004E:
; H035+$0000004E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L035_00000050:
; H035+$00000050: 08020000  btst.b #$0, d2
        btst #$0, d2
L035_00000054:
; H035+$00000054: 6702  beq.b $58
        beq.b H035+$58
L035_00000056:
; H035+$00000056: 5242  addq.w #$1, d2
        addq.w #$1, d2
L035_00000058:
; H035+$00000058: 9ec2  suba.w d2, a7
        suba.w d2, a7
L035_0000005A:
; H035+$0000005A: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L035_0000005E:
; H035+$0000005E: 2b4f0012  move.l a7, $12(a5)
        move.l a7, $12(a5)
L035_00000062:
; H035+$00000062: 244f  movea.l a7, a2
        movea.l a7, a2
L035_00000064:
; H035+$00000064: 5342  subq.w #$1, d2
        subq.w #$1, d2
L035_00000066:
; H035+$00000066: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L035_00000068:
; H035+$00000068: 51cafffc  dbra d2, $66
        dbra d2, H035+$66
L035_0000006C:
; H035+$0000006C: 7400  moveq #$0, d2
        moveq #0, d2
L035_0000006E:
; H035+$0000006E: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L035_00000072:
; H035+$00000072: 0c420027  cmpi.w #$27, d2
        cmpi.w #$27, d2
L035_00000076:
; H035+$00000076: 63000016  bls.w $8e
        bls.w H035+$8E
L035_0000007A:
; H035+$0000007A: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L035_0000007E:
; H035+$0000007E: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
; -> H010+$0360 (sub_H010_00000360)
L035_00000082:
; H035+$00000082: 4eb900000360  jsr $360.l
        jsr (H010+$360).l
; -> H010+$0332 (sub_H010_00000332)
L035_00000088:
; H035+$00000088: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L035_0000008E:
; H035+$0000008E: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L035_00000092:
; H035+$00000092: 7400  moveq #$0, d2
        moveq #0, d2
L035_00000094:
; H035+$00000094: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L035_00000098:
; H035+$00000098: 0c420022  cmpi.w #$22, d2
        cmpi.w #$22, d2
L035_0000009C:
; H035+$0000009C: 6600000c  bne.w $aa
        bne.w H035+$AA
L035_000000A0:
; H035+$000000A0: 3b7c0008fff0  move.w #$8, -$10(a5)
        move.w #$8, -$10(a5)
L035_000000A6:
; H035+$000000A6: 60000006  bra.w $ae
        bra.w H035+$AE
L035_000000AA:
; H035+$000000AA: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L035_000000AE:
; H035+$000000AE: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L035_000000B2:
; H035+$000000B2: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L035_000000B6:
; H035+$000000B6: 7400  moveq #$0, d2
        moveq #0, d2
L035_000000B8:
; H035+$000000B8: 142d0010  move.b $10(a5), d2
        move.b $10(a5), d2
L035_000000BC:
; H035+$000000BC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_000000BE:
; H035+$000000BE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_000000C2:
; H035+$000000C2: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L035_000000C6:
; H035+$000000C6: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L035_000000C8:
; H035+$000000C8: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L035_000000CC:
; H035+$000000CC: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L035_000000D2:
; H035+$000000D2: 7400  moveq #$0, d2
        moveq #0, d2
L035_000000D4:
; H035+$000000D4: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L035_000000D8:
; H035+$000000D8: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L035_000000DC:
; H035+$000000DC: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L035_000000E0:
; H035+$000000E0: 7400  moveq #$0, d2
        moveq #0, d2
L035_000000E2:
; H035+$000000E2: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L035_000000E6:
; H035+$000000E6: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L035_000000EA:
; H035+$000000EA: d46dfff4  add.w -$c(a5), d2
        add.w -$c(a5), d2
L035_000000EE:
; H035+$000000EE: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L035_000000F2:
; H035+$000000F2: 4ab90000332c  tst.l $332c.l
        tst.l (H005+$332C).l
L035_000000F8:
; H035+$000000F8: 6700008a  beq.w $184
        beq.w H035+$184
L035_000000FC:
; H035+$000000FC: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L035_00000100:
; H035+$00000100: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L035_00000104:
; H035+$00000104: 4853  pea.l (a3)
        pea.l (a3)
L035_00000106:
; H035+$00000106: 4267  clr.w -(a7)
        clr.w -(a7)
L035_00000108:
; H035+$00000108: 4267  clr.w -(a7)
        clr.w -(a7)
L035_0000010A:
; H035+$0000010A: 24790000332c  movea.l $332c.l, a2
        movea.l (H005+$332C).l, a2
L035_00000110:
; H035+$00000110: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L035_00000114:
; H035+$00000114: 4853  pea.l (a3)
        pea.l (a3)
L035_00000116:
; H035+$00000116: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L035_0000011A:
; H035+$0000011A: 4267  clr.w -(a7)
        clr.w -(a7)
L035_0000011C:
; H035+$0000011C: 7400  moveq #$0, d2
        moveq #0, d2
L035_0000011E:
; H035+$0000011E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L035_00000122:
; H035+$00000122: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L035_00000126:
; H035+$00000126: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_00000128:
; H035+$00000128: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L035_0000012C:
; H035+$0000012C: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L035_00000130:
; H035+$00000130: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L035_00000134:
; H035+$00000134: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L035_00000136:
; H035+$00000136: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L035_0000013C:
; H035+$0000013C: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L035_00000140:
; H035+$00000140: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L035_00000144:
; H035+$00000144: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L035_00000148:
; H035+$00000148: 4853  pea.l (a3)
        pea.l (a3)
L035_0000014A:
; H035+$0000014A: 4267  clr.w -(a7)
        clr.w -(a7)
L035_0000014C:
; H035+$0000014C: 4267  clr.w -(a7)
        clr.w -(a7)
L035_0000014E:
; H035+$0000014E: 24790000332c  movea.l $332c.l, a2
        movea.l (H005+$332C).l, a2
L035_00000154:
; H035+$00000154: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L035_00000158:
; H035+$00000158: 4853  pea.l (a3)
        pea.l (a3)
L035_0000015A:
; H035+$0000015A: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L035_0000015E:
; H035+$0000015E: 4267  clr.w -(a7)
        clr.w -(a7)
L035_00000160:
; H035+$00000160: 7400  moveq #$0, d2
        moveq #0, d2
L035_00000162:
; H035+$00000162: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L035_00000166:
; H035+$00000166: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L035_0000016A:
; H035+$0000016A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_0000016C:
; H035+$0000016C: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L035_00000170:
; H035+$00000170: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L035_00000174:
; H035+$00000174: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L035_00000178:
; H035+$00000178: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L035_0000017A:
; H035+$0000017A: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L035_00000180:
; H035+$00000180: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L035_00000184:
; H035+$00000184: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L035_00000188:
; H035+$00000188: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L035_0000018E:
; H035+$0000018E: 4e5d  unlk a5
        unlk a5
L035_00000190:
; H035+$00000190: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L035_00000192:
; H035+$00000192: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L035_00000194:
; H035+$00000194: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L035_00000198:
; H035+$00000198: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H035_0000019A [partial]
; Purpose: Routine of the loading of 24x24 sets and COMSPR resources module; calls H029+$0B94.
;   - Calls H029+$0B94.
; Direct callers: H048+$06D8, H048+$0788, H048+$07E8, H048+$0874, H048+$040A, H048+$04BA and 2 more
; --------------------------------------------------------------------------
L035_0000019A:
; H035+$0000019A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L035_0000019C:
; H035+$0000019C: 287afe90  movea.l $2e(pc), a4
        movea.l H035+$2E(pc), a4
L035_000001A0:
; H035+$000001A0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L035_000001A4:
; H035+$000001A4: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L035_000001A8:
; H035+$000001A8: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L035_000001AC:
; H035+$000001AC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_000001AE:
; H035+$000001AE: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L035_000001B2:
; H035+$000001B2: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L035_000001B6:
; H035+$000001B6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_000001B8:
; H035+$000001B8: 1f2d000e  move.b $e(a5), -(a7)
        move.b $e(a5), -(a7)
L035_000001BC:
; H035+$000001BC: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L035_000001C0:
; H035+$000001C0: 2f390000332c  move.l $332c.l, -(a7)
        move.l (H005+$332C).l, -(a7)
L035_000001C6:
; H035+$000001C6: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; FLOW: Calls Draw_GraphicTile24 (H029+$0B94).
L035_000001CC:
; H035+$000001CC: 4eb900000b94  jsr $b94.l
        jsr (H029+$B94).l
L035_000001D2:
; H035+$000001D2: 4e5d  unlk a5
        unlk a5
L035_000001D4:
; H035+$000001D4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L035_000001D6:
; H035+$000001D6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L035_000001D8:
; H035+$000001D8: 508f  addq.l #$8, a7
        addq.l #$8, a7
L035_000001DA:
; H035+$000001DA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H035_000001DC [partial]
; Purpose: Routine of the loading of 24x24 sets and COMSPR resources module; calls H029+$067A.
;   - Calls H029+$067A.
; Direct callers: H053+$0190, H053+$0140, H066+$1302, H047+$141E
; --------------------------------------------------------------------------
L035_000001DC:
; H035+$000001DC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L035_000001DE:
; H035+$000001DE: 287afe4e  movea.l $2e(pc), a4
        movea.l H035+$2E(pc), a4
L035_000001E2:
; H035+$000001E2: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L035_000001E6:
; H035+$000001E6: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L035_000001EA:
; H035+$000001EA: 0c6d0001fffe  cmpi.w #$1, -$2(a5)
        cmpi.w #$1, -$2(a5)
L035_000001F0:
; H035+$000001F0: 6200004a  bhi.w $23c
        bhi.w H035+$23C
L035_000001F4:
; H035+$000001F4: 7400  moveq #$0, d2
        moveq #0, d2
L035_000001F6:
; H035+$000001F6: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L035_000001FA:
; H035+$000001FA: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_000001FC:
; H035+$000001FC: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_00000202:
; H035+$00000202: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L035_00000206:
; H035+$00000206: e544  asl.w #$2, d4
        asl.w #$2, d4
L035_00000208:
; H035+$00000208: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L035_0000020C:
; H035+$0000020C: 4ab34000  tst.l (a3, d4.w)
        tst.l (a3, d4.w)
L035_00000210:
; H035+$00000210: 67000024  beq.w $236
        beq.w H035+$236
L035_00000214:
; H035+$00000214: 7400  moveq #$0, d2
        moveq #0, d2
L035_00000216:
; H035+$00000216: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L035_0000021A:
; H035+$0000021A: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_0000021C:
; H035+$0000021C: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_00000222:
; H035+$00000222: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L035_00000226:
; H035+$00000226: e544  asl.w #$2, d4
        asl.w #$2, d4
L035_00000228:
; H035+$00000228: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L035_0000022C:
; H035+$0000022C: 48734000  pea.l (a3, d4.w)
        pea.l (a3, d4.w)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L035_00000230:
; H035+$00000230: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L035_00000236:
; H035+$00000236: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L035_0000023A:
; H035+$0000023A: 64ae  bcc.b $1ea
        bcc.b H035+$1EA
L035_0000023C:
; H035+$0000023C: 4e5d  unlk a5
        unlk a5
L035_0000023E:
; H035+$0000023E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L035_00000240:
; H035+$00000240: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L035_00000242:
; H035+$00000242: 548f  addq.l #$2, a7
        addq.l #$2, a7
L035_00000244:
; H035+$00000244: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H035_00000246 [partial]
; Purpose: Routine of the loading of 24x24 sets and COMSPR resources module; calls H026+$0188, H026+$0452, H026+$0106, H029+$0A0E.
;   - Calls H026+$0188.
;   - Calls H026+$0452.
;   - Calls H026+$0106.
;   - Calls H029+$0A0E.
;   - Calls H045+$01D6.
;   - Calls H026+$01E0.
;   - Calls H029+$0EFE.
;   - Uses the global state: H005+$246E (resource group selector).
; Direct callers: H006+$076E, H006+$079A, H064+$083A, H066+$27DE, H066+$2F28
; --------------------------------------------------------------------------
L035_00000246:
; H035+$00000246: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L035_00000248:
; H035+$00000248: 287afde4  movea.l $2e(pc), a4
        movea.l H035+$2E(pc), a4
L035_0000024C:
; H035+$0000024C: 4e55ff9e  link.w a5, #$ff9e
        link.w a5, #$ff9e
L035_00000250:
; H035+$00000250: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L035_00000254:
; H035+$00000254: 5242  addq.w #$1, d2
        addq.w #$1, d2
L035_00000256:
; H035+$00000256: 08020000  btst.b #$0, d2
        btst #$0, d2
L035_0000025A:
; H035+$0000025A: 6702  beq.b $25e
        beq.b H035+$25E
L035_0000025C:
; H035+$0000025C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L035_0000025E:
; H035+$0000025E: 9ec2  suba.w d2, a7
        suba.w d2, a7
L035_00000260:
; H035+$00000260: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L035_00000264:
; H035+$00000264: 2b4f0010  move.l a7, $10(a5)
        move.l a7, $10(a5)
L035_00000268:
; H035+$00000268: 244f  movea.l a7, a2
        movea.l a7, a2
L035_0000026A:
; H035+$0000026A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L035_0000026C:
; H035+$0000026C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L035_0000026E:
; H035+$0000026E: 51cafffc  dbra d2, $26c
        dbra d2, H035+$26C
L035_00000272:
; H035+$00000272: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_00000276:
; H035+$00000276: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_0000027A:
; H035+$0000027A: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L035_0000027E:
; H035+$0000027E: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L035_00000282:
; H035+$00000282: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L035_00000288:
; H035+$00000288: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L035_0000028C:
; H035+$0000028C: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
L035_00000290:
; H035+$00000290: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_00000294:
; H035+$00000294: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_00000298:
; H035+$00000298: 4267  clr.w -(a7)
        clr.w -(a7)
L035_0000029A:
; H035+$0000029A: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
; -> H026+$0452 (sub_H026_00000452)
L035_0000029E:
; H035+$0000029E: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L035_000002A4:
; H035+$000002A4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_000002A8:
; H035+$000002A8: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_000002AC:
; H035+$000002AC: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L035_000002B0:
; H035+$000002B0: 486c0022  pea.l $22(a4)
        pea.l $22(a4)
; -> H026+$0106 (sub_H026_00000106)
L035_000002B4:
; H035+$000002B4: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L035_000002BA:
; H035+$000002BA: 1400  move.b d0, d2
        move.b d0, d2
L035_000002BC:
; H035+$000002BC: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L035_000002C0:
; H035+$000002C0: 67000022  beq.w $2e4
        beq.w H035+$2E4
L035_000002C4:
; H035+$000002C4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_000002C8:
; H035+$000002C8: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_000002CC:
; H035+$000002CC: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L035_000002D0:
; H035+$000002D0: 486c0029  pea.l $29(a4)
        pea.l $29(a4)
; -> H026+$0106 (sub_H026_00000106)
L035_000002D4:
; H035+$000002D4: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L035_000002DA:
; H035+$000002DA: 1400  move.b d0, d2
        move.b d0, d2
L035_000002DC:
; H035+$000002DC: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L035_000002E0:
; H035+$000002E0: 66000060  bne.w $342
        bne.w H035+$342
L035_000002E4:
; H035+$000002E4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_000002E8:
; H035+$000002E8: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_000002EC:
; H035+$000002EC: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L035_000002F0:
; H035+$000002F0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_000002F4:
; H035+$000002F4: 1f3c0008  move.b #$8, -(a7)
        move.b #$8, -(a7)
L035_000002F8:
; H035+$000002F8: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_000002FC:
; H035+$000002FC: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_000002FE:
; H035+$000002FE: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_00000304:
; H035+$00000304: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L035_00000308:
; H035+$00000308: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L035_0000030E:
; H035+$0000030E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_00000312:
; H035+$00000312: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_00000316:
; H035+$00000316: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L035_0000031A:
; H035+$0000031A: 06420080  addi.w #$80, d2
        addi.w #$80, d2
L035_0000031E:
; H035+$0000031E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_00000320:
; H035+$00000320: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_00000324:
; H035+$00000324: 1f3c0008  move.b #$8, -(a7)
        move.b #$8, -(a7)
L035_00000328:
; H035+$00000328: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_0000032C:
; H035+$0000032C: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_0000032E:
; H035+$0000032E: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_00000334:
; H035+$00000334: 48732004  pea.l $4(a3, d2.w)
        pea.l $4(a3, d2.w)
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L035_00000338:
; H035+$00000338: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L035_0000033E:
; H035+$0000033E: 60000114  bra.w $454
        bra.w H035+$454
L035_00000342:
; H035+$00000342: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_00000346:
; H035+$00000346: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L035_0000034A:
; H035+$0000034A: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$246E = resource group selector
L035_0000034C:
; H035+$0000034C: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L035_00000352:
; H035+$00000352: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L035_00000354:
; H035+$00000354: 4227  clr.b -(a7)
        clr.b -(a7)
L035_00000356:
; H035+$00000356: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L035_0000035A:
; H035+$0000035A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_0000035E:
; H035+$0000035E: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L035_00000362:
; H035+$00000362: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L035_00000368:
; H035+$00000368: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_0000036C:
; H035+$0000036C: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_00000370:
; H035+$00000370: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_00000374:
; H035+$00000374: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L035_00000378:
; H035+$00000378: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L035_0000037E:
; H035+$0000037E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_00000382:
; H035+$00000382: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_00000386:
; H035+$00000386: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L035_0000038A:
; H035+$0000038A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_0000038E:
; H035+$0000038E: 4227  clr.b -(a7)
        clr.b -(a7)
L035_00000390:
; H035+$00000390: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_00000394:
; H035+$00000394: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_00000396:
; H035+$00000396: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_0000039C:
; H035+$0000039C: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L035_000003A0:
; H035+$000003A0: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L035_000003A6:
; H035+$000003A6: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L035_000003AA:
; H035+$000003AA: 47f900003da2  lea.l $3da2.l, a3
        lea.l (H005+$3DA2).l, a3
L035_000003B0:
; H035+$000003B0: 45d7  lea.l (a7), a2
        lea.l (a7), a2
L035_000003B2:
; H035+$000003B2: 7403  moveq #$3, d2
        moveq #3, d2
L035_000003B4:
; H035+$000003B4: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L035_000003B6:
; H035+$000003B6: 51cafffc  dbra d2, $3b4
        dbra d2, H035+$3B4
L035_000003BA:
; H035+$000003BA: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L035_000003BE:
; H035+$000003BE: 47f900003d92  lea.l $3d92.l, a3
        lea.l (H005+$3D92).l, a3
L035_000003C4:
; H035+$000003C4: 45d7  lea.l (a7), a2
        lea.l (a7), a2
L035_000003C6:
; H035+$000003C6: 7403  moveq #$3, d2
        moveq #3, d2
L035_000003C8:
; H035+$000003C8: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L035_000003CA:
; H035+$000003CA: 51cafffc  dbra d2, $3c8
        dbra d2, H035+$3C8
L035_000003CE:
; H035+$000003CE: 4267  clr.w -(a7)
        clr.w -(a7)
L035_000003D0:
; H035+$000003D0: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_000003D4:
; H035+$000003D4: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_000003D6:
; H035+$000003D6: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_000003DC:
; H035+$000003DC: 2f332000  move.l (a3, d2.w), -(a7)
        move.l (a3, d2.w), -(a7)
; -> H029+$0EFE (trampoline_H029_10AC)
L035_000003E0:
; H035+$000003E0: 4eb900000efe  jsr $efe.l
        jsr (H029+$EFE).l
L035_000003E6:
; H035+$000003E6: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L035_000003EA:
; H035+$000003EA: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L035_000003EE:
; H035+$000003EE: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L035_000003F2:
; H035+$000003F2: 06420080  addi.w #$80, d2
        addi.w #$80, d2
L035_000003F6:
; H035+$000003F6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_000003F8:
; H035+$000003F8: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_000003FC:
; H035+$000003FC: 4227  clr.b -(a7)
        clr.b -(a7)
L035_000003FE:
; H035+$000003FE: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_00000402:
; H035+$00000402: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_00000404:
; H035+$00000404: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_0000040A:
; H035+$0000040A: 48732004  pea.l $4(a3, d2.w)
        pea.l $4(a3, d2.w)
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L035_0000040E:
; H035+$0000040E: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L035_00000414:
; H035+$00000414: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L035_00000418:
; H035+$00000418: 47f900003da2  lea.l $3da2.l, a3
        lea.l (H005+$3DA2).l, a3
L035_0000041E:
; H035+$0000041E: 45d7  lea.l (a7), a2
        lea.l (a7), a2
L035_00000420:
; H035+$00000420: 7403  moveq #$3, d2
        moveq #3, d2
L035_00000422:
; H035+$00000422: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L035_00000424:
; H035+$00000424: 51cafffc  dbra d2, $422
        dbra d2, H035+$422
L035_00000428:
; H035+$00000428: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L035_0000042C:
; H035+$0000042C: 47f900003d92  lea.l $3d92.l, a3
        lea.l (H005+$3D92).l, a3
L035_00000432:
; H035+$00000432: 45d7  lea.l (a7), a2
        lea.l (a7), a2
L035_00000434:
; H035+$00000434: 7403  moveq #$3, d2
        moveq #3, d2
L035_00000436:
; H035+$00000436: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L035_00000438:
; H035+$00000438: 51cafffc  dbra d2, $436
        dbra d2, H035+$436
L035_0000043C:
; H035+$0000043C: 4267  clr.w -(a7)
        clr.w -(a7)
L035_0000043E:
; H035+$0000043E: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_00000442:
; H035+$00000442: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_00000444:
; H035+$00000444: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_0000044A:
; H035+$0000044A: 2f332004  move.l $4(a3, d2.w), -(a7)
        move.l $4(a3, d2.w), -(a7)
; -> H029+$0EFE (trampoline_H029_10AC)
L035_0000044E:
; H035+$0000044E: 4eb900000efe  jsr $efe.l
        jsr (H029+$EFE).l
L035_00000454:
; H035+$00000454: 4e5d  unlk a5
        unlk a5
L035_00000456:
; H035+$00000456: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L035_00000458:
; H035+$00000458: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L035_0000045A:
; H035+$0000045A: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L035_0000045E:
; H035+$0000045E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H035_00000460 [partial]
; Purpose: Routine of the loading of 24x24 sets and COMSPR resources module; calls H029+$0408, H049+$09D6, H049+$04AE, H016+$00A0.
;   - Calls H029+$0408.
;   - Calls H049+$09D6.
;   - Calls H049+$04AE.
;   - Calls H016+$00A0.
;   - Calls H029+$067A.
;   - Uses the global state: H005+$3DE3 (native context, 5 in combat); H005+$52F2 (pointer to the game screen).
; Direct callers: H048+$0EE4, H048+$0940, H048+$04EA, H048+$0572, H048+$10F4, H047+$0108 and 5 more
; --------------------------------------------------------------------------
L035_00000460:
; H035+$00000460: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L035_00000462:
; H035+$00000462: 287afbca  movea.l $2e(pc), a4
        movea.l H035+$2E(pc), a4
L035_00000466:
; H035+$00000466: 4e55ffe0  link.w a5, #$ffe0
        link.w a5, #$ffe0
L035_0000046A:
; H035+$0000046A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_0000046E:
; H035+$0000046E: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_00000470:
; H035+$00000470: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_00000476:
; H035+$00000476: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L035_0000047A:
; H035+$0000047A: e544  asl.w #$2, d4
        asl.w #$2, d4
L035_0000047C:
; H035+$0000047C: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L035_00000480:
; H035+$00000480: 4ab34000  tst.l (a3, d4.w)
        tst.l (a3, d4.w)
L035_00000484:
; H035+$00000484: 66000006  bne.w $48c
        bne.w H035+$48C
L035_00000488:
; H035+$00000488: 60000242  bra.w $6cc
        bra.w H035+$6CC
L035_0000048C:
; H035+$0000048C: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_00000490:
; H035+$00000490: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_00000492:
; H035+$00000492: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L035_00000498:
; H035+$00000498: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L035_0000049C:
; H035+$0000049C: e544  asl.w #$2, d4
        asl.w #$2, d4
L035_0000049E:
; H035+$0000049E: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L035_000004A2:
; H035+$000004A2: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L035_000004A6:
; H035+$000004A6: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L035_000004AA:
; H035+$000004AA: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L035_000004AE:
; H035+$000004AE: 3b420014  move.w d2, $14(a5)
        move.w d2, $14(a5)
L035_000004B2:
; H035+$000004B2: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L035_000004B6:
; H035+$000004B6: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L035_000004BA:
; H035+$000004BA: 3b420012  move.w d2, $12(a5)
        move.w d2, $12(a5)
L035_000004BE:
; H035+$000004BE: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L035_000004C2:
; H035+$000004C2: e74a  lsl.w #$3, d2
        lsl.w #$3, d2
L035_000004C4:
; H035+$000004C4: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L035_000004C8:
; H035+$000004C8: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L035_000004CC:
; H035+$000004CC: 3b53fffa  move.w (a3), -$6(a5)
        move.w (a3), -$6(a5)
L035_000004D0:
; H035+$000004D0: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
; STATE: H005+$3DE3 = native context, 5 in combat
L035_000004D4:
; H035+$000004D4: 4a3900003de3  tst.b $3de3.l
        tst.b (H005+$3DE3).l
L035_000004DA:
; H035+$000004DA: 6600000a  bne.w $4e6
        bne.w H035+$4E6
L035_000004DE:
; H035+$000004DE: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L035_000004E2:
; H035+$000004E2: 60000090  bra.w $574
        bra.w H035+$574
L035_000004E6:
; H035+$000004E6: 3b7c0008fffe  move.w #$8, -$2(a5)
        move.w #$8, -$2(a5)
L035_000004EC:
; H035+$000004EC: 4a6d0014  tst.w $14(a5)
        tst.w $14(a5)
L035_000004F0:
; H035+$000004F0: 6c000012  bge.w $504
        bge.w H035+$504
L035_000004F4:
; H035+$000004F4: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L035_000004F8:
; H035+$000004F8: d56dfffc  add.w d2, -$4(a5)
        add.w d2, -$4(a5)
L035_000004FC:
; H035+$000004FC: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L035_00000500:
; H035+$00000500: 956dfff8  sub.w d2, -$8(a5)
        sub.w d2, -$8(a5)
L035_00000504:
; H035+$00000504: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L035_00000508:
; H035+$00000508: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L035_0000050C:
; H035+$0000050C: 044200a8  subi.w #$a8, d2
        subi.w #$a8, d2
L035_00000510:
; H035+$00000510: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L035_00000514:
; H035+$00000514: 4a6dfff4  tst.w -$c(a5)
        tst.w -$c(a5)
L035_00000518:
; H035+$00000518: 6f00000a  ble.w $524
        ble.w H035+$524
L035_0000051C:
; H035+$0000051C: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L035_00000520:
; H035+$00000520: 956dfffc  sub.w d2, -$4(a5)
        sub.w d2, -$4(a5)
L035_00000524:
; H035+$00000524: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L035_00000528:
; H035+$00000528: 6e000006  bgt.w $530
        bgt.w H035+$530
L035_0000052C:
; H035+$0000052C: 6000019e  bra.w $6cc
        bra.w H035+$6CC
L035_00000530:
; H035+$00000530: 4a6d0012  tst.w $12(a5)
        tst.w $12(a5)
L035_00000534:
; H035+$00000534: 6c000012  bge.w $548
        bge.w H035+$548
L035_00000538:
; H035+$00000538: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L035_0000053C:
; H035+$0000053C: d56dfffa  add.w d2, -$6(a5)
        add.w d2, -$6(a5)
L035_00000540:
; H035+$00000540: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L035_00000544:
; H035+$00000544: 956dfff6  sub.w d2, -$a(a5)
        sub.w d2, -$a(a5)
L035_00000548:
; H035+$00000548: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L035_0000054C:
; H035+$0000054C: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L035_00000550:
; H035+$00000550: 044200a8  subi.w #$a8, d2
        subi.w #$a8, d2
L035_00000554:
; H035+$00000554: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L035_00000558:
; H035+$00000558: 4a6dfff4  tst.w -$c(a5)
        tst.w -$c(a5)
L035_0000055C:
; H035+$0000055C: 6f00000a  ble.w $568
        ble.w H035+$568
L035_00000560:
; H035+$00000560: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L035_00000564:
; H035+$00000564: 956dfffa  sub.w d2, -$6(a5)
        sub.w d2, -$6(a5)
L035_00000568:
; H035+$00000568: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L035_0000056C:
; H035+$0000056C: 6e000006  bgt.w $574
        bgt.w H035+$574
L035_00000570:
; H035+$00000570: 6000015a  bra.w $6cc
        bra.w H035+$6CC
L035_00000574:
; H035+$00000574: 4a3900000065  tst.b $65.l
        tst.b (H029+$65).l
L035_0000057A:
; H035+$0000057A: 6700000e  beq.w $58a
        beq.w H035+$58A
L035_0000057E:
; H035+$0000057E: 2b7900000066ffe4  move.l $66.l, -$1c(a5)
        move.l (H029+$66).l, -$1c(a5)
L035_00000586:
; H035+$00000586: 60000018  bra.w $5a0
        bra.w H035+$5A0
; STATE: H005+$52F2 = pointer to the game screen
L035_0000058A:
; H035+$0000058A: 2479000052f2  movea.l $52f2.l, a2
        movea.l (H005+$52F2).l, a2
L035_00000590:
; H035+$00000590: 45ea0054  lea.l $54(a2), a2
        lea.l $54(a2), a2
L035_00000594:
; H035+$00000594: 2b4affe4  move.l a2, -$1c(a5)
        move.l a2, -$1c(a5)
L035_00000598:
; H035+$00000598: 13fc000100000061  move.b #$1, $61.l
        move.b #$1, (H029+$61).l
L035_000005A0:
; H035+$000005A0: 0c6d00030010  cmpi.w #$3, $10(a5)
        cmpi.w #$3, $10(a5)
L035_000005A6:
; H035+$000005A6: 63000062  bls.w $60a
        bls.w H035+$60A
L035_000005AA:
; H035+$000005AA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L035_000005AC:
; H035+$000005AC: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L035_000005AE:
; H035+$000005AE: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L035_000005B2:
; H035+$000005B2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_000005B6:
; H035+$000005B6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L035_000005BA:
; H035+$000005BA: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
; FLOW: Calls Allocate_GraphicRecord (H029+$0408).
L035_000005BE:
; H035+$000005BE: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L035_000005C4:
; H035+$000005C4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L035_000005C6:
; H035+$000005C6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L035_000005C8:
; H035+$000005C8: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L035_000005CC:
; H035+$000005CC: e742  asl.w #$3, d2
        asl.w #$3, d2
L035_000005CE:
; H035+$000005CE: 45f900003244  lea.l $3244.l, a2
        lea.l (H005+$3244).l, a2
L035_000005D4:
; H035+$000005D4: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L035_000005D8:
; H035+$000005D8: e544  asl.w #$2, d4
        asl.w #$2, d4
L035_000005DA:
; H035+$000005DA: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L035_000005DE:
; H035+$000005DE: 2f324000  move.l (a2, d4.w), -(a7)
        move.l (a2, d4.w), -(a7)
L035_000005E2:
; H035+$000005E2: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
; -> H049+$09D6 (sub_H049_000009D6)
L035_000005E6:
; H035+$000005E6: 4eb9000009d6  jsr $9d6.l
        jsr (H049+$9D6).l
L035_000005EC:
; H035+$000005EC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L035_000005EE:
; H035+$000005EE: 246dffec  movea.l -$14(a5), a2
        movea.l -$14(a5), a2
L035_000005F2:
; H035+$000005F2: 2b6a0010ffe8  move.l $10(a2), -$18(a5)
        move.l $10(a2), -$18(a5)
L035_000005F8:
; H035+$000005F8: 226dffec  movea.l -$14(a5), a1
        movea.l -$14(a5), a1
L035_000005FC:
; H035+$000005FC: 2469000c  movea.l $c(a1), a2
        movea.l $c(a1), a2
L035_00000600:
; H035+$00000600: 2b6a0008ffe0  move.l $8(a2), -$20(a5)
        move.l $8(a2), -$20(a5)
L035_00000606:
; H035+$00000606: 60000012  bra.w $61a
        bra.w H035+$61A
L035_0000060A:
; H035+$0000060A: 2b6b0010ffe8  move.l $10(a3), -$18(a5)
        move.l $10(a3), -$18(a5)
L035_00000610:
; H035+$00000610: 246b000c  movea.l $c(a3), a2
        movea.l $c(a3), a2
L035_00000614:
; H035+$00000614: 2b6a0008ffe0  move.l $8(a2), -$20(a5)
        move.l $8(a2), -$20(a5)
L035_0000061A:
; H035+$0000061A: 4a3900000064  tst.b $64.l
        tst.b (H029+$64).l
L035_00000620:
; H035+$00000620: 6700004c  beq.w $66e
        beq.w H035+$66E
L035_00000624:
; H035+$00000624: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L035_00000626:
; H035+$00000626: 2f2dffe8  move.l -$18(a5), -(a7)
        move.l -$18(a5), -(a7)
L035_0000062A:
; H035+$0000062A: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L035_0000062E:
; H035+$0000062E: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L035_00000632:
; H035+$00000632: 2f2dffe4  move.l -$1c(a5), -(a7)
        move.l -$1c(a5), -(a7)
L035_00000636:
; H035+$00000636: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L035_0000063A:
; H035+$0000063A: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L035_0000063E:
; H035+$0000063E: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L035_00000642:
; H035+$00000642: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_00000644:
; H035+$00000644: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L035_00000648:
; H035+$00000648: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L035_0000064C:
; H035+$0000064C: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L035_00000650:
; H035+$00000650: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_00000652:
; H035+$00000652: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L035_00000656:
; H035+$00000656: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L035_0000065A:
; H035+$0000065A: 1f3c00ca  move.b #$ca, -(a7)
        move.b #$ca, -(a7)
L035_0000065E:
; H035+$0000065E: 2f2dffe0  move.l -$20(a5), -(a7)
        move.l -$20(a5), -(a7)
; FLOW: Calls Queue_BitplaneBlit (H049+$04AE).
L035_00000662:
; H035+$00000662: 4eb9000004ae  jsr $4ae.l
        jsr (H049+$4AE).l
L035_00000668:
; H035+$00000668: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L035_0000066A:
; H035+$0000066A: 60000048  bra.w $6b4
        bra.w H035+$6B4
L035_0000066E:
; H035+$0000066E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L035_00000670:
; H035+$00000670: 2f2dffe8  move.l -$18(a5), -(a7)
        move.l -$18(a5), -(a7)
L035_00000674:
; H035+$00000674: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L035_00000678:
; H035+$00000678: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L035_0000067C:
; H035+$0000067C: 2f2dffe4  move.l -$1c(a5), -(a7)
        move.l -$1c(a5), -(a7)
L035_00000680:
; H035+$00000680: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L035_00000684:
; H035+$00000684: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L035_00000688:
; H035+$00000688: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L035_0000068C:
; H035+$0000068C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_0000068E:
; H035+$0000068E: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L035_00000692:
; H035+$00000692: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L035_00000696:
; H035+$00000696: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L035_0000069A:
; H035+$0000069A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L035_0000069C:
; H035+$0000069C: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L035_000006A0:
; H035+$000006A0: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L035_000006A4:
; H035+$000006A4: 1f3c00e0  move.b #$e0, -(a7)
        move.b #$e0, -(a7)
L035_000006A8:
; H035+$000006A8: 2f2dffe0  move.l -$20(a5), -(a7)
        move.l -$20(a5), -(a7)
; -> H016+$00A0 (wrapper_BltMaskBitMapRastPort)
L035_000006AC:
; H035+$000006AC: 4eb9000000a0  jsr $a0.l
        jsr (H016+$A0).l
L035_000006B2:
; H035+$000006B2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L035_000006B4:
; H035+$000006B4: 0c6d00030010  cmpi.w #$3, $10(a5)
        cmpi.w #$3, $10(a5)
L035_000006BA:
; H035+$000006BA: 63000010  bls.w $6cc
        bls.w H035+$6CC
L035_000006BE:
; H035+$000006BE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L035_000006C0:
; H035+$000006C0: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L035_000006C4:
; H035+$000006C4: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L035_000006CA:
; H035+$000006CA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L035_000006CC:
; H035+$000006CC: 4e5d  unlk a5
        unlk a5
L035_000006CE:
; H035+$000006CE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L035_000006D0:
; H035+$000006D0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L035_000006D2:
; H035+$000006D2: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L035_000006D6:
; H035+$000006D6: 4ed0  jmp (a0)
        jmp (a0)
L035_000006D8:
; H035+$000006D8: 4e5d  unlk a5
        unlk a5
L035_000006DA:
; H035+$000006DA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L035_000006DC:
; H035+$000006DC: 4e75  rts 
        rts 
; Preserved bytes H035+$000006DE..$000006E0; code/data not fully classified.
        dc.w $0000
; End H035: $6E0 bytes
