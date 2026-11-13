; ============================================================================
; MODULE GUIDE H010
; Intuition input, event conversion and exit/error services.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Intuition input: reads IntuiMessages from the window port, tells RAWKEY and MOUSEBUTTONS apart, converts the mouse codes and returns the messages with ReplyMsg.
; --------------------------------------------------------------------------
; H010: 2488 original bytes; all offsets are section-relative.
        section H010,code
H010:
; Preserved bytes H010+$00000000..$000000B6; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$6466,$303A,$0041,$7373,$6967
        dc.w $6E20,$2244,$6973,$6B20,$4F6E,$653A,$2200,$4173
        dc.w $7369,$676E,$2022,$4469,$736B,$2054,$776F,$3A22
        dc.w $0041,$7373,$6967,$6E20,$2244,$6973,$6B20,$5468
        dc.w $7265,$653A,$2200,$6D61,$7820,$6672,$6565,$2062
        dc.w $6C6F,$636B,$2069,$7320,$0020,$6279,$7465,$732E
        dc.w $0000
        dc.l H010+$00000056
; --------------------------------------------------------------------------
; ROUTINE: module_init_H010 [partial]
; Purpose: Entry of the Intuition input, event conversion and exit/error services module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H010+$09A6.
; Direct callers: H000+$0168
; --------------------------------------------------------------------------
L010_000000B6:
; H010+$000000B6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L010_000000B8:
; H010+$000000B8: 287afff8  movea.l $b2(pc), a4
        movea.l H010+$B2(pc), a4
L010_000000BC:
; H010+$000000BC: 4e550000  link.w a5, #$0
        link.w a5, #$0
L010_000000C0:
; H010+$000000C0: 600008e4  bra.w $9a6
        bra.w H010+$9A6
; --------------------------------------------------------------------------
; ROUTINE: sub_H010_000000C4 [partial]
; Purpose: Routine of the Intuition input, event conversion and exit/error services module; calls H028+$0D74, H003+$00F6, H029+$067A, H042+$0300.
;   - Calls H028+$0D74.
;   - Calls H003+$00F6.
;   - Calls H029+$067A.
;   - Calls H042+$0300.
;   - Calls H053+$0012.
;   - Calls H030+$0C84.
;   - Calls H026+$0106.
;   - Uses the global state: H005+$3E04 (pointer to persistent state A, 2048 bytes); H005+$3E00 (pointer to persistent state B, 2048 bytes); H005+$3DFC (pointer to persistent state C, 1024 bytes).
; Direct callers: H010+$034E
; --------------------------------------------------------------------------
L010_000000C4:
; H010+$000000C4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L010_000000C6:
; H010+$000000C6: 287affea  movea.l $b2(pc), a4
        movea.l H010+$B2(pc), a4
L010_000000CA:
; H010+$000000CA: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
; -> H028+$0D74 (sub_H028_00000D74)
L010_000000CE:
; H010+$000000CE: 4eb900000d74  jsr $d74.l
        jsr (H028+$D74).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L010_000000D4:
; H010+$000000D4: 2f3900003e04  move.l $3e04.l, -(a7)
        move.l (H005+$3E04).l, -(a7)
L010_000000DA:
; H010+$000000DA: 243c00000800  move.l #$800, d2
        move.l #$800, d2
L010_000000E0:
; H010+$000000E0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_000000E2:
; H010+$000000E2: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L010_000000E8:
; H010+$000000E8: 2f3900003e00  move.l $3e00.l, -(a7)
        move.l (H005+$3E00).l, -(a7)
L010_000000EE:
; H010+$000000EE: 243c00000800  move.l #$800, d2
        move.l #$800, d2
L010_000000F4:
; H010+$000000F4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_000000F6:
; H010+$000000F6: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
; STATE: H005+$3DFC = pointer to persistent state C, 1024 bytes
L010_000000FC:
; H010+$000000FC: 2f3900003dfc  move.l $3dfc.l, -(a7)
        move.l (H005+$3DFC).l, -(a7)
L010_00000102:
; H010+$00000102: 243c00000400  move.l #$400, d2
        move.l #$400, d2
L010_00000108:
; H010+$00000108: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_0000010A:
; H010+$0000010A: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
; STATE: H005+$3DF8 = pointer to the ECL buffer
L010_00000110:
; H010+$00000110: 2f3900003df8  move.l $3df8.l, -(a7)
        move.l (H005+$3DF8).l, -(a7)
L010_00000116:
; H010+$00000116: 243c00001e00  move.l #$1e00, d2
        move.l #$1e00, d2
L010_0000011C:
; H010+$0000011C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_0000011E:
; H010+$0000011E: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L010_00000124:
; H010+$00000124: 2f390000282e  move.l $282e.l, -(a7)
        move.l (H005+$282E).l, -(a7)
L010_0000012A:
; H010+$0000012A: 243c00000924  move.l #$924, d2
        move.l #$924, d2
L010_00000130:
; H010+$00000130: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_00000132:
; H010+$00000132: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
; STATE: H005+$282A = pointer to the four GEO data planes
L010_00000138:
; H010+$00000138: 2f390000282a  move.l $282a.l, -(a7)
        move.l (H005+$282A).l, -(a7)
L010_0000013E:
; H010+$0000013E: 243c00000400  move.l #$400, d2
        move.l #$400, d2
L010_00000144:
; H010+$00000144: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_00000146:
; H010+$00000146: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L010_0000014C:
; H010+$0000014C: 487900003334  pea.l $3334.l
        pea.l (H005+$3334).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_00000152:
; H010+$00000152: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_00000158:
; H010+$00000158: 487900003d8a  pea.l $3d8a.l
        pea.l (H005+$3D8A).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_0000015E:
; H010+$0000015E: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_00000164:
; H010+$00000164: 487900002804  pea.l $2804.l
        pea.l (H005+$2804).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_0000016A:
; H010+$0000016A: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_00000170:
; H010+$00000170: 487900002808  pea.l $2808.l
        pea.l (H005+$2808).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_00000176:
; H010+$00000176: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_0000017C:
; H010+$0000017C: 48790000280c  pea.l $280c.l
        pea.l (H005+$280C).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_00000182:
; H010+$00000182: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_00000188:
; H010+$00000188: 48790000332c  pea.l $332c.l
        pea.l (H005+$332C).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_0000018E:
; H010+$0000018E: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_00000194:
; H010+$00000194: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L010_0000019A:
; H010+$0000019A: 0c6d0002fffe  cmpi.w #$2, -$2(a5)
        cmpi.w #$2, -$2(a5)
L010_000001A0:
; H010+$000001A0: 62000022  bhi.w $1c4
        bhi.w H010+$1C4
L010_000001A4:
; H010+$000001A4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L010_000001A8:
; H010+$000001A8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L010_000001AA:
; H010+$000001AA: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L010_000001AE:
; H010+$000001AE: 47f9000027b0  lea.l $27b0.l, a3
        lea.l (H005+$27B0).l, a3
L010_000001B4:
; H010+$000001B4: 48732802  pea.l $2(a3, d2.l)
        pea.l $2(a3, d2.l)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_000001B8:
; H010+$000001B8: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_000001BE:
; H010+$000001BE: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L010_000001C2:
; H010+$000001C2: 64d6  bcc.b $19a
        bcc.b H010+$19A
L010_000001C4:
; H010+$000001C4: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L010_000001C8:
; H010+$000001C8: 0c6d0004fffe  cmpi.w #$4, -$2(a5)
        cmpi.w #$4, -$2(a5)
L010_000001CE:
; H010+$000001CE: 6200001e  bhi.w $1ee
        bhi.w H010+$1EE
L010_000001D2:
; H010+$000001D2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L010_000001D6:
; H010+$000001D6: e542  asl.w #$2, d2
        asl.w #$2, d2
L010_000001D8:
; H010+$000001D8: 47f900003338  lea.l $3338.l, a3
        lea.l (H005+$3338).l, a3
L010_000001DE:
; H010+$000001DE: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_000001E2:
; H010+$000001E2: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_000001E8:
; H010+$000001E8: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L010_000001EC:
; H010+$000001EC: 64da  bcc.b $1c8
        bcc.b H010+$1C8
L010_000001EE:
; H010+$000001EE: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L010_000001F2:
; H010+$000001F2: 0c6d001cfffe  cmpi.w #$1c, -$2(a5)
        cmpi.w #$1c, -$2(a5)
L010_000001F8:
; H010+$000001F8: 6200003c  bhi.w $236
        bhi.w H010+$236
L010_000001FC:
; H010+$000001FC: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L010_00000200:
; H010+$00000200: 0c6d0001fffc  cmpi.w #$1, -$4(a5)
        cmpi.w #$1, -$4(a5)
L010_00000206:
; H010+$00000206: 62000028  bhi.w $230
        bhi.w H010+$230
L010_0000020A:
; H010+$0000020A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L010_0000020E:
; H010+$0000020E: e742  asl.w #$3, d2
        asl.w #$3, d2
L010_00000210:
; H010+$00000210: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L010_00000216:
; H010+$00000216: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L010_0000021A:
; H010+$0000021A: e544  asl.w #$2, d4
        asl.w #$2, d4
L010_0000021C:
; H010+$0000021C: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L010_00000220:
; H010+$00000220: 48734000  pea.l (a3, d4.w)
        pea.l (a3, d4.w)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_00000224:
; H010+$00000224: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_0000022A:
; H010+$0000022A: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L010_0000022E:
; H010+$0000022E: 64d0  bcc.b $200
        bcc.b H010+$200
L010_00000230:
; H010+$00000230: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L010_00000234:
; H010+$00000234: 64bc  bcc.b $1f2
        bcc.b H010+$1F2
L010_00000236:
; H010+$00000236: 4ab900002798  tst.l $2798.l
        tst.l (H005+$2798).l
L010_0000023C:
; H010+$0000023C: 6700000e  beq.w $24c
        beq.w H010+$24C
L010_00000240:
; H010+$00000240: 487900002798  pea.l $2798.l
        pea.l (H005+$2798).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L010_00000246:
; H010+$00000246: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L010_0000024C:
; H010+$0000024C: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLOW: Calls Free_Sequence (H042+$0300).
L010_00000252:
; H010+$00000252: 4eb900000300  jsr $300.l
        jsr (H042+$300).l
; STATE: H005+$3364 = head of the party list
L010_00000258:
; H010+$00000258: 4ab900003364  tst.l $3364.l
        tst.l (H005+$3364).l
L010_0000025E:
; H010+$0000025E: 67000028  beq.w $288
        beq.w H010+$288
; STATE: H005+$3364 = head of the party list
L010_00000262:
; H010+$00000262: 267900003364  movea.l $3364.l, a3
        movea.l (H005+$3364).l, a3
; STATE: H005+$3368 = current character
L010_00000268:
; H010+$00000268: 23eb018e00003368  move.l $18e(a3), $3368.l
        move.l $18e(a3), (H005+$3368).l
; STATE: H005+$3364 = head of the party list
L010_00000270:
; H010+$00000270: 487900003364  pea.l $3364.l
        pea.l (H005+$3364).l
; -> H053+$0012 (sub_H053_00000012)
L010_00000276:
; H010+$00000276: 4eb900000012  jsr $12.l
        jsr (H053+$12).l
; STATE: H005+$3364 = head of the party list; H005+$3368 = current character
L010_0000027C:
; H010+$0000027C: 23f90000336800003364  move.l $3368.l, $3364.l
        move.l (H005+$3368).l, (H005+$3364).l
L010_00000286:
; H010+$00000286: 60d0  bra.b $258
        bra.b H010+$258
L010_00000288:
; H010+$00000288: 4ab9000052fc  tst.l $52fc.l
        tst.l (H005+$52FC).l
L010_0000028E:
; H010+$0000028E: 67000012  beq.w $2a2
        beq.w H010+$2A2
L010_00000292:
; H010+$00000292: 2f39000052fc  move.l $52fc.l, -(a7)
        move.l (H005+$52FC).l, -(a7)
L010_00000298:
; H010+$00000298: 7434  moveq #$34, d2
        moveq #52, d2
L010_0000029A:
; H010+$0000029A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_0000029C:
; H010+$0000029C: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L010_000002A2:
; H010+$000002A2: 4ab900005300  tst.l $5300.l
        tst.l (H005+$5300).l
L010_000002A8:
; H010+$000002A8: 67000012  beq.w $2bc
        beq.w H010+$2BC
L010_000002AC:
; H010+$000002AC: 2f3900005300  move.l $5300.l, -(a7)
        move.l (H005+$5300).l, -(a7)
L010_000002B2:
; H010+$000002B2: 7434  moveq #$34, d2
        moveq #52, d2
L010_000002B4:
; H010+$000002B4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L010_000002B6:
; H010+$000002B6: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
; -> H030+$0C84 (sub_H030_00000C84)
L010_000002BC:
; H010+$000002BC: 4eb900000c84  jsr $c84.l
        jsr (H030+$C84).l
L010_000002C2:
; H010+$000002C2: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
; STATE: H005+$3D26 = prefix of the data files
L010_000002C6:
; H010+$000002C6: 487900003d26  pea.l $3d26.l
        pea.l (H005+$3D26).l
L010_000002CC:
; H010+$000002CC: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L010_000002D0:
; H010+$000002D0: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
; -> H026+$0106 (sub_H026_00000106)
L010_000002D4:
; H010+$000002D4: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L010_000002DA:
; H010+$000002DA: 1400  move.b d0, d2
        move.b d0, d2
L010_000002DC:
; H010+$000002DC: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L010_000002E0:
; H010+$000002E0: 6700004a  beq.w $32c
        beq.w H010+$32C
L010_000002E4:
; H010+$000002E4: 47ec0005  lea.l $5(a4), a3
        lea.l $5(a4), a3
L010_000002E8:
; H010+$000002E8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L010_000002EA:
; H010+$000002EA: 7400  moveq #$0, d2
        moveq #0, d2
L010_000002EC:
; H010+$000002EC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L010_000002EE:
; H010+$000002EE: 7400  moveq #$0, d2
        moveq #0, d2
L010_000002F0:
; H010+$000002F0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01E8 (wrapper_Execute)
L010_000002F2:
; H010+$000002F2: 4eb9000001e8  jsr $1e8.l
        jsr (H002+$1E8).l
L010_000002F8:
; H010+$000002F8: 1b40fffb  move.b d0, -$5(a5)
        move.b d0, -$5(a5)
L010_000002FC:
; H010+$000002FC: 47ec0018  lea.l $18(a4), a3
        lea.l $18(a4), a3
L010_00000300:
; H010+$00000300: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L010_00000302:
; H010+$00000302: 7400  moveq #$0, d2
        moveq #0, d2
L010_00000304:
; H010+$00000304: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L010_00000306:
; H010+$00000306: 7400  moveq #$0, d2
        moveq #0, d2
L010_00000308:
; H010+$00000308: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01E8 (wrapper_Execute)
L010_0000030A:
; H010+$0000030A: 4eb9000001e8  jsr $1e8.l
        jsr (H002+$1E8).l
L010_00000310:
; H010+$00000310: 1b40fffb  move.b d0, -$5(a5)
        move.b d0, -$5(a5)
L010_00000314:
; H010+$00000314: 47ec002b  lea.l $2b(a4), a3
        lea.l $2b(a4), a3
L010_00000318:
; H010+$00000318: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L010_0000031A:
; H010+$0000031A: 7400  moveq #$0, d2
        moveq #0, d2
L010_0000031C:
; H010+$0000031C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L010_0000031E:
; H010+$0000031E: 7400  moveq #$0, d2
        moveq #0, d2
L010_00000320:
; H010+$00000320: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01E8 (wrapper_Execute)
L010_00000322:
; H010+$00000322: 4eb9000001e8  jsr $1e8.l
        jsr (H002+$1E8).l
L010_00000328:
; H010+$00000328: 1b40fffb  move.b d0, -$5(a5)
        move.b d0, -$5(a5)
L010_0000032C:
; H010+$0000032C: 4e5d  unlk a5
        unlk a5
L010_0000032E:
; H010+$0000032E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L010_00000330:
; H010+$00000330: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H010_00000332 [partial]
; Purpose: Routine of the Intuition input, event conversion and exit/error services module; calls H043+$0840, H029+$148E, H029+$12BC, H015+$0046.
;   - Calls H043+$0840.
;   - Calls H029+$148E.
;   - Calls H029+$12BC.
;   - Calls H015+$0046.
; Direct callers: H001+$01AE, H001+$01C0, H034+$0168, H043+$168A, H028+$0F68, H013+$51DE and 9 more
; --------------------------------------------------------------------------
L010_00000332:
; H010+$00000332: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L010_00000334:
; H010+$00000334: 287afd7c  movea.l $b2(pc), a4
        movea.l H010+$B2(pc), a4
L010_00000338:
; H010+$00000338: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
; FLOW: Calls Audio_Shutdown (H043+$0840).
L010_0000033C:
; H010+$0000033C: 4eb900000840  jsr $840.l
        jsr (H043+$840).l
; -> H029+$148E (sub_H029_0000148E)
L010_00000342:
; H010+$00000342: 4eb90000148e  jsr $148e.l
        jsr (H029+$148E).l
; -> H029+$12BC (sub_H029_000012BC)
L010_00000348:
; H010+$00000348: 4eb9000012bc  jsr $12bc.l
        jsr (H029+$12BC).l
L010_0000034E:
; H010+$0000034E: 6100fd74  bsr.w $c4
        bsr.w H010+$C4
L010_00000352:
; H010+$00000352: 7000  moveq #$0, d0
        moveq #0, d0
; -> H015+$0046 (trampoline_H015_033E)
L010_00000354:
; H010+$00000354: 4eb900000046  jsr $46.l
        jsr (H015+$46).l
L010_0000035A:
; H010+$0000035A: 4e5d  unlk a5
        unlk a5
L010_0000035C:
; H010+$0000035C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L010_0000035E:
; H010+$0000035E: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H010_00000360 [partial]
; Purpose: Routine of the Intuition input, event conversion and exit/error services module; calls H020+$085A, H020+$082E.
;   - Calls H020+$085A.
;   - Calls H020+$082E.
; Direct callers: H011+$18FE, H042+$0F76, H011+$1616, H035+$0082
; --------------------------------------------------------------------------
L010_00000360:
; H010+$00000360: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L010_00000362:
; H010+$00000362: 287afd4e  movea.l $b2(pc), a4
        movea.l H010+$B2(pc), a4
L010_00000366:
; H010+$00000366: 4e550000  link.w a5, #$0
        link.w a5, #$0
L010_0000036A:
; H010+$0000036A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L010_0000036E:
; H010+$0000036E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L010_00000370:
; H010+$00000370: 08020000  btst.b #$0, d2
        btst #$0, d2
L010_00000374:
; H010+$00000374: 6702  beq.b $378
        beq.b H010+$378
L010_00000376:
; H010+$00000376: 5242  addq.w #$1, d2
        addq.w #$1, d2
L010_00000378:
; H010+$00000378: 9ec2  suba.w d2, a7
        suba.w d2, a7
L010_0000037A:
; H010+$0000037A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L010_0000037E:
; H010+$0000037E: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L010_00000382:
; H010+$00000382: 244f  movea.l a7, a2
        movea.l a7, a2
L010_00000384:
; H010+$00000384: 5342  subq.w #$1, d2
        subq.w #$1, d2
L010_00000386:
; H010+$00000386: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L010_00000388:
; H010+$00000388: 51cafffc  dbra d2, $386
        dbra d2, H010+$386
L010_0000038C:
; H010+$0000038C: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L010_00000390:
; H010+$00000390: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H020+$085A (sub_H020_0000085A)
L010_00000394:
; H010+$00000394: 4eb90000085a  jsr $85a.l
        jsr (H020+$85A).l
; -> H020+$082E (trampoline_H020_0856)
L010_0000039A:
; H010+$0000039A: 4eb90000082e  jsr $82e.l
        jsr (H020+$82E).l
L010_000003A0:
; H010+$000003A0: 4e5d  unlk a5
        unlk a5
L010_000003A2:
; H010+$000003A2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L010_000003A4:
; H010+$000003A4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L010_000003A6:
; H010+$000003A6: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L010_000003A8:
; H010+$000003A8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H010_000003AA [partial]
; Purpose: Routine of the Intuition input, event conversion and exit/error services module; calls H003+$007E, H045+$01D6, H026+$0254, H026+$01E0.
;   - Calls H003+$007E.
;   - Calls H045+$01D6.
;   - Calls H026+$0254.
;   - Calls H026+$01E0.
;   - Calls H030+$0256.
; Direct callers: H010+$0820
; --------------------------------------------------------------------------
L010_000003AA:
; H010+$000003AA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L010_000003AC:
; H010+$000003AC: 287afd04  movea.l $b2(pc), a4
        movea.l H010+$B2(pc), a4
L010_000003B0:
; H010+$000003B0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L010_000003B4:
; H010+$000003B4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L010_000003B8:
; H010+$000003B8: 486cffae  pea.l -$52(a4)
        pea.l -$52(a4)
L010_000003BC:
; H010+$000003BC: 2f3c00020000  move.l #$20000, -(a7)
        move.l #$20000, -(a7)
; -> H003+$007E (wrapper_AvailMem)
L010_000003C2:
; H010+$000003C2: 4eb90000007e  jsr $7e.l
        jsr (H003+$7E).l
L010_000003C8:
; H010+$000003C8: 2f00  move.l d0, -(a7)
        move.l d0, -(a7)
L010_000003CA:
; H010+$000003CA: 4227  clr.b -(a7)
        clr.b -(a7)
L010_000003CC:
; H010+$000003CC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L010_000003D0:
; H010+$000003D0: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L010_000003D4:
; H010+$000003D4: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L010_000003D8:
; H010+$000003D8: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L010_000003DE:
; H010+$000003DE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L010_000003E2:
; H010+$000003E2: 486cffae  pea.l -$52(a4)
        pea.l -$52(a4)
L010_000003E6:
; H010+$000003E6: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L010_000003EA:
; H010+$000003EA: 486c0040  pea.l $40(a4)
        pea.l $40(a4)
L010_000003EE:
; H010+$000003EE: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H026+$0254 (sub_H026_00000254)
L010_000003F0:
; H010+$000003F0: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L010_000003F6:
; H010+$000003F6: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L010_000003FA:
; H010+$000003FA: 486cffae  pea.l -$52(a4)
        pea.l -$52(a4)
L010_000003FE:
; H010+$000003FE: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L010_00000402:
; H010+$00000402: 486c0053  pea.l $53(a4)
        pea.l $53(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L010_00000406:
; H010+$00000406: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L010_0000040C:
; H010+$0000040C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L010_00000410:
; H010+$00000410: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L010_00000414:
; H010+$00000414: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L010_00000418:
; H010+$00000418: 4267  clr.w -(a7)
        clr.w -(a7)
L010_0000041A:
; H010+$0000041A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L010_0000041E:
; H010+$0000041E: 486cffae  pea.l -$52(a4)
        pea.l -$52(a4)
; FLOW: Calls UI_DrawText (H030+$0256).
L010_00000422:
; H010+$00000422: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L010_00000428:
; H010+$00000428: 4e5d  unlk a5
        unlk a5
L010_0000042A:
; H010+$0000042A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L010_0000042C:
; H010+$0000042C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H010_0882 [partial]
; Purpose: Trampoline to H010+$0882; the actual body is there.
;   - Jumps to the actual body at H010+$0882.
;   - Calls H050+$002A.
;   - Calls H050+$0064.
;   - Uses the global state: H005+$5305 (byte of the pending key/action); H005+$52F6 (pointer to the game window); H005+$2356 (mouse X coordinate).
; Direct callers: H007+$0678, H010+$0994, H008+$0A4A, H057+$3098, H058+$1100, H097+$00BE
; --------------------------------------------------------------------------
L010_0000042E:
; H010+$0000042E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L010_00000430:
; H010+$00000430: 287afc80  movea.l $b2(pc), a4
        movea.l H010+$B2(pc), a4
L010_00000434:
; H010+$00000434: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L010_00000438:
; H010+$00000438: 60000448  bra.w $882
        bra.w H010+$882
; --------------------------------------------------------------------------
; ROUTINE: sub_H010_0000043C [partial]
; Purpose: Routine of the Intuition input, event conversion and exit/error services module; calls H050+$002A, H050+$0064.
;   - Calls H050+$002A.
;   - Calls H050+$0064.
;   - Uses the global state: H005+$5305 (byte of the pending key/action); H005+$52F6 (pointer to the game window); H005+$2356 (mouse X coordinate).
; Direct callers: H010+$08D8
; --------------------------------------------------------------------------
L010_0000043C:
; H010+$0000043C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L010_00000440:
; H010+$00000440: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_00000442:
; H010+$00000442: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_00000448:
; H010+$00000448: 0c420060  cmpi.w #$60, d2
        cmpi.w #$60, d2
L010_0000044C:
; H010+$0000044C: 67000012  beq.w $460
        beq.w H010+$460
L010_00000450:
; H010+$00000450: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_00000452:
; H010+$00000452: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_00000458:
; H010+$00000458: 0c420061  cmpi.w #$61, d2
        cmpi.w #$61, d2
L010_0000045C:
; H010+$0000045C: 66000012  bne.w $470
        bne.w H010+$470
L010_00000460:
; H010+$00000460: 197c0001ffac  move.b #$1, -$54(a4)
        move.b #$1, -$54(a4)
; STATE: H005+$5305 = byte of the pending key/action
L010_00000466:
; H010+$00000466: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_0000046C:
; H010+$0000046C: 6000035a  bra.w $7c8
        bra.w H010+$7C8
L010_00000470:
; H010+$00000470: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_00000472:
; H010+$00000472: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_00000478:
; H010+$00000478: 0c4200e0  cmpi.w #$e0, d2
        cmpi.w #$e0, d2
L010_0000047C:
; H010+$0000047C: 67000012  beq.w $490
        beq.w H010+$490
L010_00000480:
; H010+$00000480: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_00000482:
; H010+$00000482: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_00000488:
; H010+$00000488: 0c4200e1  cmpi.w #$e1, d2
        cmpi.w #$e1, d2
L010_0000048C:
; H010+$0000048C: 66000010  bne.w $49e
        bne.w H010+$49E
L010_00000490:
; H010+$00000490: 422cffac  clr.b -$54(a4)
        clr.b -$54(a4)
; STATE: H005+$5305 = byte of the pending key/action
L010_00000494:
; H010+$00000494: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_0000049A:
; H010+$0000049A: 6000032c  bra.w $7c8
        bra.w H010+$7C8
L010_0000049E:
; H010+$0000049E: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_000004A0:
; H010+$000004A0: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_000004A6:
; H010+$000004A6: 0c420064  cmpi.w #$64, d2
        cmpi.w #$64, d2
L010_000004AA:
; H010+$000004AA: 67000012  beq.w $4be
        beq.w H010+$4BE
L010_000004AE:
; H010+$000004AE: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_000004B0:
; H010+$000004B0: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_000004B6:
; H010+$000004B6: 0c420065  cmpi.w #$65, d2
        cmpi.w #$65, d2
L010_000004BA:
; H010+$000004BA: 66000012  bne.w $4ce
        bne.w H010+$4CE
L010_000004BE:
; H010+$000004BE: 197c0001ffad  move.b #$1, -$53(a4)
        move.b #$1, -$53(a4)
; STATE: H005+$5305 = byte of the pending key/action
L010_000004C4:
; H010+$000004C4: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_000004CA:
; H010+$000004CA: 600002fc  bra.w $7c8
        bra.w H010+$7C8
L010_000004CE:
; H010+$000004CE: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_000004D0:
; H010+$000004D0: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_000004D6:
; H010+$000004D6: 0c4200e4  cmpi.w #$e4, d2
        cmpi.w #$e4, d2
L010_000004DA:
; H010+$000004DA: 67000012  beq.w $4ee
        beq.w H010+$4EE
L010_000004DE:
; H010+$000004DE: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_000004E0:
; H010+$000004E0: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_000004E6:
; H010+$000004E6: 0c4200e5  cmpi.w #$e5, d2
        cmpi.w #$e5, d2
L010_000004EA:
; H010+$000004EA: 66000010  bne.w $4fc
        bne.w H010+$4FC
L010_000004EE:
; H010+$000004EE: 422cffad  clr.b -$53(a4)
        clr.b -$53(a4)
; STATE: H005+$5305 = byte of the pending key/action
L010_000004F2:
; H010+$000004F2: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_000004F8:
; H010+$000004F8: 600002ce  bra.w $7c8
        bra.w H010+$7C8
L010_000004FC:
; H010+$000004FC: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_000004FE:
; H010+$000004FE: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_00000504:
; H010+$00000504: 0c420063  cmpi.w #$63, d2
        cmpi.w #$63, d2
L010_00000508:
; H010+$00000508: 66000012  bne.w $51c
        bne.w H010+$51C
L010_0000050C:
; H010+$0000050C: 197c0001ffab  move.b #$1, -$55(a4)
        move.b #$1, -$55(a4)
; STATE: H005+$5305 = byte of the pending key/action
L010_00000512:
; H010+$00000512: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_00000518:
; H010+$00000518: 600002ae  bra.w $7c8
        bra.w H010+$7C8
L010_0000051C:
; H010+$0000051C: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_0000051E:
; H010+$0000051E: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_00000524:
; H010+$00000524: 0c4200e3  cmpi.w #$e3, d2
        cmpi.w #$e3, d2
L010_00000528:
; H010+$00000528: 66000010  bne.w $53a
        bne.w H010+$53A
L010_0000052C:
; H010+$0000052C: 422cffab  clr.b -$55(a4)
        clr.b -$55(a4)
; STATE: H005+$5305 = byte of the pending key/action
L010_00000530:
; H010+$00000530: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_00000536:
; H010+$00000536: 60000290  bra.w $7c8
        bra.w H010+$7C8
L010_0000053A:
; H010+$0000053A: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_0000053C:
; H010+$0000053C: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_00000542:
; H010+$00000542: 6000026c  bra.w $7b0
        bra.w H010+$7B0
; STATE: H005+$5305 = byte of the pending key/action
L010_00000546:
; H010+$00000546: 13fc003100005305  move.b #$31, $5305.l
        move.b #$31, (H005+$5305).l
L010_0000054E:
; H010+$0000054E: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000550:
; H010+$00000550: 13fc003200005305  move.b #$32, $5305.l
        move.b #$32, (H005+$5305).l
L010_00000558:
; H010+$00000558: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000055A:
; H010+$0000055A: 13fc003300005305  move.b #$33, $5305.l
        move.b #$33, (H005+$5305).l
L010_00000562:
; H010+$00000562: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000564:
; H010+$00000564: 13fc003400005305  move.b #$34, $5305.l
        move.b #$34, (H005+$5305).l
L010_0000056C:
; H010+$0000056C: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000056E:
; H010+$0000056E: 13fc003500005305  move.b #$35, $5305.l
        move.b #$35, (H005+$5305).l
L010_00000576:
; H010+$00000576: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000578:
; H010+$00000578: 13fc003600005305  move.b #$36, $5305.l
        move.b #$36, (H005+$5305).l
L010_00000580:
; H010+$00000580: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000582:
; H010+$00000582: 13fc003700005305  move.b #$37, $5305.l
        move.b #$37, (H005+$5305).l
L010_0000058A:
; H010+$0000058A: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000058C:
; H010+$0000058C: 13fc003800005305  move.b #$38, $5305.l
        move.b #$38, (H005+$5305).l
L010_00000594:
; H010+$00000594: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000596:
; H010+$00000596: 13fc003900005305  move.b #$39, $5305.l
        move.b #$39, (H005+$5305).l
L010_0000059E:
; H010+$0000059E: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005A0:
; H010+$000005A0: 13fc003000005305  move.b #$30, $5305.l
        move.b #$30, (H005+$5305).l
L010_000005A8:
; H010+$000005A8: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005AA:
; H010+$000005AA: 13fc007100005305  move.b #$71, $5305.l
        move.b #$71, (H005+$5305).l
L010_000005B2:
; H010+$000005B2: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005B4:
; H010+$000005B4: 13fc007700005305  move.b #$77, $5305.l
        move.b #$77, (H005+$5305).l
L010_000005BC:
; H010+$000005BC: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005BE:
; H010+$000005BE: 13fc006500005305  move.b #$65, $5305.l
        move.b #$65, (H005+$5305).l
L010_000005C6:
; H010+$000005C6: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005C8:
; H010+$000005C8: 13fc007200005305  move.b #$72, $5305.l
        move.b #$72, (H005+$5305).l
L010_000005D0:
; H010+$000005D0: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005D2:
; H010+$000005D2: 13fc007400005305  move.b #$74, $5305.l
        move.b #$74, (H005+$5305).l
L010_000005DA:
; H010+$000005DA: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005DC:
; H010+$000005DC: 13fc007900005305  move.b #$79, $5305.l
        move.b #$79, (H005+$5305).l
L010_000005E4:
; H010+$000005E4: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005E6:
; H010+$000005E6: 13fc007500005305  move.b #$75, $5305.l
        move.b #$75, (H005+$5305).l
L010_000005EE:
; H010+$000005EE: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005F0:
; H010+$000005F0: 13fc006900005305  move.b #$69, $5305.l
        move.b #$69, (H005+$5305).l
L010_000005F8:
; H010+$000005F8: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000005FA:
; H010+$000005FA: 13fc006f00005305  move.b #$6f, $5305.l
        move.b #$6f, (H005+$5305).l
L010_00000602:
; H010+$00000602: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000604:
; H010+$00000604: 13fc007000005305  move.b #$70, $5305.l
        move.b #$70, (H005+$5305).l
L010_0000060C:
; H010+$0000060C: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000060E:
; H010+$0000060E: 13fc006100005305  move.b #$61, $5305.l
        move.b #$61, (H005+$5305).l
L010_00000616:
; H010+$00000616: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000618:
; H010+$00000618: 13fc007300005305  move.b #$73, $5305.l
        move.b #$73, (H005+$5305).l
L010_00000620:
; H010+$00000620: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000622:
; H010+$00000622: 13fc006400005305  move.b #$64, $5305.l
        move.b #$64, (H005+$5305).l
L010_0000062A:
; H010+$0000062A: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000062C:
; H010+$0000062C: 13fc006600005305  move.b #$66, $5305.l
        move.b #$66, (H005+$5305).l
L010_00000634:
; H010+$00000634: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000636:
; H010+$00000636: 13fc006700005305  move.b #$67, $5305.l
        move.b #$67, (H005+$5305).l
L010_0000063E:
; H010+$0000063E: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000640:
; H010+$00000640: 13fc006800005305  move.b #$68, $5305.l
        move.b #$68, (H005+$5305).l
L010_00000648:
; H010+$00000648: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000064A:
; H010+$0000064A: 13fc006a00005305  move.b #$6a, $5305.l
        move.b #$6a, (H005+$5305).l
L010_00000652:
; H010+$00000652: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000654:
; H010+$00000654: 13fc006b00005305  move.b #$6b, $5305.l
        move.b #$6b, (H005+$5305).l
L010_0000065C:
; H010+$0000065C: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000065E:
; H010+$0000065E: 13fc006c00005305  move.b #$6c, $5305.l
        move.b #$6c, (H005+$5305).l
L010_00000666:
; H010+$00000666: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000668:
; H010+$00000668: 13fc003b00005305  move.b #$3b, $5305.l
        move.b #$3b, (H005+$5305).l
L010_00000670:
; H010+$00000670: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000672:
; H010+$00000672: 13fc002700005305  move.b #$27, $5305.l
        move.b #$27, (H005+$5305).l
L010_0000067A:
; H010+$0000067A: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000067C:
; H010+$0000067C: 13fc007a00005305  move.b #$7a, $5305.l
        move.b #$7a, (H005+$5305).l
L010_00000684:
; H010+$00000684: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000686:
; H010+$00000686: 13fc007800005305  move.b #$78, $5305.l
        move.b #$78, (H005+$5305).l
L010_0000068E:
; H010+$0000068E: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000690:
; H010+$00000690: 13fc006300005305  move.b #$63, $5305.l
        move.b #$63, (H005+$5305).l
L010_00000698:
; H010+$00000698: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000069A:
; H010+$0000069A: 13fc007600005305  move.b #$76, $5305.l
        move.b #$76, (H005+$5305).l
L010_000006A2:
; H010+$000006A2: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006A4:
; H010+$000006A4: 13fc006200005305  move.b #$62, $5305.l
        move.b #$62, (H005+$5305).l
L010_000006AC:
; H010+$000006AC: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006AE:
; H010+$000006AE: 13fc006e00005305  move.b #$6e, $5305.l
        move.b #$6e, (H005+$5305).l
L010_000006B6:
; H010+$000006B6: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006B8:
; H010+$000006B8: 13fc006d00005305  move.b #$6d, $5305.l
        move.b #$6d, (H005+$5305).l
L010_000006C0:
; H010+$000006C0: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006C2:
; H010+$000006C2: 13fc002c00005305  move.b #$2c, $5305.l
        move.b #$2c, (H005+$5305).l
L010_000006CA:
; H010+$000006CA: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006CC:
; H010+$000006CC: 13fc002e00005305  move.b #$2e, $5305.l
        move.b #$2e, (H005+$5305).l
L010_000006D4:
; H010+$000006D4: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006D6:
; H010+$000006D6: 13fc002000005305  move.b #$20, $5305.l
        move.b #$20, (H005+$5305).l
L010_000006DE:
; H010+$000006DE: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006E0:
; H010+$000006E0: 13fc000800005305  move.b #$8, $5305.l
        move.b #$8, (H005+$5305).l
L010_000006E8:
; H010+$000006E8: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006EA:
; H010+$000006EA: 13fc000d00005305  move.b #$d, $5305.l
        move.b #$d, (H005+$5305).l
L010_000006F2:
; H010+$000006F2: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006F4:
; H010+$000006F4: 13fc001b00005305  move.b #$1b, $5305.l
        move.b #$1b, (H005+$5305).l
L010_000006FC:
; H010+$000006FC: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_000006FE:
; H010+$000006FE: 13fc001000005305  move.b #$10, $5305.l
        move.b #$10, (H005+$5305).l
L010_00000706:
; H010+$00000706: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000708:
; H010+$00000708: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_0000070E:
; H010+$0000070E: 4e75  rts 
        rts 
; Preserved bytes H010+$00000710..$000007B0; code/data not fully classified.
        dc.w $FFF6,$FE34,$FE3E,$FE48,$FE52,$FE5C,$FE66,$FE70
        dc.w $FE7A,$FE84,$FE8E,$FFF6,$FFF6,$FFF6,$FFF6,$FE8E
        dc.w $FE98,$FEA2,$FEAC,$FEB6,$FEC0,$FECA,$FED4,$FEDE
        dc.w $FEE8,$FEF2,$FFF6,$FFF6,$FFF6,$FE34,$FE3E,$FE48
        dc.w $FEFC,$FF06,$FF10,$FF1A,$FF24,$FF2E,$FF38,$FF42
        dc.w $FF4C,$FF56,$FF60,$FFF6,$FFF6,$FE52,$FE5C,$FE66
        dc.w $FFF6,$FF6A,$FF74,$FF7E,$FF88,$FF92,$FF9C,$FFA6
        dc.w $FFB0,$FFBA,$FFF6,$FFF6,$FFF6,$FE70,$FE7A,$FE84
        dc.w $FFC4,$FFCE,$FFF6,$FFD8,$FFD8,$FFE2,$FFEC,$FFF6
        dc.w $FFF6,$FFF6,$FFF6,$FFF6,$FE7A,$FE3E,$FE66,$FE52
L010_000007B0:
; H010+$000007B0: 47faff60  lea.l $712(pc), a3
        lea.l H010+$712(pc), a3
L010_000007B4:
; H010+$000007B4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L010_000007B6:
; H010+$000007B6: 0c42004e  cmpi.w #$4e, d2
        cmpi.w #$4e, d2
L010_000007BA:
; H010+$000007BA: 6302  bls.b $7be
        bls.b H010+$7BE
L010_000007BC:
; H010+$000007BC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L010_000007BE:
; H010+$000007BE: e342  asl.w #$1, d2
        asl.w #$1, d2
L010_000007C0:
; H010+$000007C0: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H010+$0712; indices 0..78, default -1.
L010_000007C4:
; H010+$000007C4: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L010_000007C8:
; H010+$000007C8: 4a2cffac  tst.b -$54(a4)
        tst.b -$54(a4)
L010_000007CC:
; H010+$000007CC: 67000006  beq.w $7d4
        beq.w H010+$7D4
L010_000007D0:
; H010+$000007D0: 600000a8  bra.w $87a
        bra.w H010+$87A
L010_000007D4:
; H010+$000007D4: 4a2cffab  tst.b -$55(a4)
        tst.b -$55(a4)
L010_000007D8:
; H010+$000007D8: 67000006  beq.w $7e0
        beq.w H010+$7E0
L010_000007DC:
; H010+$000007DC: 6000009c  bra.w $87a
        bra.w H010+$87A
L010_000007E0:
; H010+$000007E0: 4a2cffad  tst.b -$53(a4)
        tst.b -$53(a4)
L010_000007E4:
; H010+$000007E4: 67000094  beq.w $87a
        beq.w H010+$87A
L010_000007E8:
; H010+$000007E8: 422cffad  clr.b -$53(a4)
        clr.b -$53(a4)
L010_000007EC:
; H010+$000007EC: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$5305 = byte of the pending key/action
L010_000007EE:
; H010+$000007EE: 143900005305  move.b $5305.l, d2
        move.b (H005+$5305).l, d2
L010_000007F4:
; H010+$000007F4: 6000006a  bra.w $860
        bra.w H010+$860
; STATE: H005+$5305 = byte of the pending key/action
L010_000007F8:
; H010+$000007F8: 13fc000100005305  move.b #$1, $5305.l
        move.b #$1, (H005+$5305).l
L010_00000800:
; H010+$00000800: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000802:
; H010+$00000802: 13fc000200005305  move.b #$2, $5305.l
        move.b #$2, (H005+$5305).l
L010_0000080A:
; H010+$0000080A: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_0000080C:
; H010+$0000080C: 13fc000300005305  move.b #$3, $5305.l
        move.b #$3, (H005+$5305).l
L010_00000814:
; H010+$00000814: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000816:
; H010+$00000816: 13fc000400005305  move.b #$4, $5305.l
        move.b #$4, (H005+$5305).l
L010_0000081E:
; H010+$0000081E: 4e75  rts 
        rts 
L010_00000820:
; H010+$00000820: 6100fb88  bsr.w $3aa
        bsr.w H010+$3AA
L010_00000824:
; H010+$00000824: 4e75  rts 
        rts 
L010_00000826:
; H010+$00000826: 197c0001ffad  move.b #$1, -$53(a4)
        move.b #$1, -$53(a4)
L010_0000082C:
; H010+$0000082C: 4e75  rts 
        rts 
; Preserved bytes H010+$0000082E..$00000860; code/data not fully classified.
        dc.w $FFF6,$FFC8,$FFF6,$FFF0,$FFF6,$FFF6,$FFF6,$FFF6
        dc.w $FFF6,$FFF6,$FFF6,$FFF6,$FFF6,$FFD2,$FFF6,$FFF6
        dc.w $FFF6,$FFDC,$FFF6,$FFF6,$FFF6,$FFF6,$FFF6,$FFF6
        dc.w $FFE6
L010_00000860:
; H010+$00000860: 47faffce  lea.l $830(pc), a3
        lea.l H010+$830(pc), a3
L010_00000864:
; H010+$00000864: 04420061  subi.w #$61, d2
        subi.w #$61, d2
L010_00000868:
; H010+$00000868: 0c420017  cmpi.w #$17, d2
        cmpi.w #$17, d2
L010_0000086C:
; H010+$0000086C: 6302  bls.b $870
        bls.b H010+$870
L010_0000086E:
; H010+$0000086E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L010_00000870:
; H010+$00000870: e342  asl.w #$1, d2
        asl.w #$1, d2
L010_00000872:
; H010+$00000872: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H010+$0830; indices 0..23, default -1.
L010_00000876:
; H010+$00000876: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L010_0000087A:
; H010+$0000087A: 4e5d  unlk a5
        unlk a5
L010_0000087C:
; H010+$0000087C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L010_0000087E:
; H010+$0000087E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L010_00000880:
; H010+$00000880: 4ed0  jmp (a0)
        jmp (a0)
; FUNCTION: poll_IntuiMessages
FN_poll_IntuiMessages:
;
; --------------------------------------------------------------------------
; ROUTINE: Poll_IntuitionEvents [verified]
; Purpose: Consumes the IntuiMessages of the game window.
;   - GetMsg reads from the UserPort.
;   - RAWKEY takes the keyboard code and forwards it to the local converter.
;   - MOUSEBUTTONS copies the coordinates; $68 produces Return and $69 Escape.
;   - ReplyMsg returns the message before the next attempt.
; --------------------------------------------------------------------------
; STATE: H005+$5305 = byte of the pending key/action
L010_00000882:
; H010+$00000882: 423900005305  clr.b $5305.l
        clr.b (H005+$5305).l
L010_00000888:
; H010+$00000888: 42390000249e  clr.b $249e.l
        clr.b (H005+$249E).l
; STATE: H005+$52F6 = pointer to the game window
L010_0000088E:
; H010+$0000088E: 2479000052f6  movea.l $52f6.l, a2
        movea.l (H005+$52F6).l, a2
L010_00000894:
; H010+$00000894: 266a0056  movea.l $56(a2), a3
        movea.l $56(a2), a3
L010_00000898:
; H010+$00000898: 4853  pea.l (a3)
        pea.l (a3)
; -> H050+$002A (wrapper_GetMsg)
L010_0000089A:
; H010+$0000089A: 4eb90000002a  jsr $2a.l
        jsr (H050+$2A).l
L010_000008A0:
; H010+$000008A0: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L010_000008A4:
; H010+$000008A4: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L010_000008A8:
; H010+$000008A8: 670000bc  beq.w $966
        beq.w H010+$966
L010_000008AC:
; H010+$000008AC: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L010_000008B0:
; H010+$000008B0: 0cab000004000014  cmpi.l #$400, $14(a3)
        cmpi.l #IDCMP_RAWKEY, $14(a3)
L010_000008B8:
; H010+$000008B8: 66000028  bne.w $8e2
        bne.w H010+$8E2
; STATE: H005+$5305 = byte of the pending key/action
L010_000008BC:
; H010+$000008BC: 4a3900005305  tst.b $5305.l
        tst.b (H005+$5305).l
L010_000008C2:
; H010+$000008C2: 6600001a  bne.w $8de
        bne.w H010+$8DE
L010_000008C6:
; H010+$000008C6: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L010_000008CA:
; H010+$000008CA: 342a0018  move.w $18(a2), d2
        move.w $18(a2), d2
; STATE: H005+$5305 = byte of the pending key/action
L010_000008CE:
; H010+$000008CE: 13c200005305  move.b d2, $5305.l
        move.b d2, (H005+$5305).l
L010_000008D4:
; H010+$000008D4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L010_000008D6:
; H010+$000008D6: 4855  pea.l (a5)
        pea.l (a5)
L010_000008D8:
; H010+$000008D8: 6100fb62  bsr.w $43c
        bsr.w H010+$43C
L010_000008DC:
; H010+$000008DC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L010_000008DE:
; H010+$000008DE: 60000078  bra.w $958
        bra.w H010+$958
L010_000008E2:
; H010+$000008E2: 0cab000000080014  cmpi.l #$8, $14(a3)
        cmpi.l #IDCMP_MOUSEBUTTONS, $14(a3)
L010_000008EA:
; H010+$000008EA: 6600006c  bne.w $958
        bne.w H010+$958
L010_000008EE:
; H010+$000008EE: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
; STATE: H005+$2356 = mouse X coordinate
L010_000008F2:
; H010+$000008F2: 33ea002000002356  move.w $20(a2), $2356.l
        move.w $20(a2), (H005+$2356).l
L010_000008FA:
; H010+$000008FA: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
; STATE: H005+$2354 = mouse Y coordinate
L010_000008FE:
; H010+$000008FE: 33ea002200002354  move.w $22(a2), $2354.l
        move.w $22(a2), (H005+$2354).l
L010_00000906:
; H010+$00000906: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L010_0000090A:
; H010+$0000090A: 342a0018  move.w $18(a2), d2
        move.w $18(a2), d2
L010_0000090E:
; H010+$0000090E: 6000002e  bra.w $93e
        bra.w H010+$93E
; STATE: H005+$5305 = byte of the pending key/action
L010_00000912:
; H010+$00000912: 13fc000d00005305  move.b #$d, $5305.l
        move.b #$d, (H005+$5305).l
L010_0000091A:
; H010+$0000091A: 13fc00010000249e  move.b #$1, $249e.l
        move.b #$1, (H005+$249E).l
L010_00000922:
; H010+$00000922: 4e75  rts 
        rts 
; STATE: H005+$5305 = byte of the pending key/action
L010_00000924:
; H010+$00000924: 13fc001b00005305  move.b #$1b, $5305.l
        move.b #$1b, (H005+$5305).l
L010_0000092C:
; H010+$0000092C: 13fc00010000249e  move.b #$1, $249e.l
        move.b #$1, (H005+$249E).l
L010_00000934:
; H010+$00000934: 4e75  rts 
        rts 
L010_00000936:
; H010+$00000936: 4e75  rts 
        rts 
; Preserved bytes H010+$00000938..$0000093E; code/data not fully classified.
        dc.w $FFFC,$FFD8,$FFEA
L010_0000093E:
; H010+$0000093E: 45fafffa  lea.l $93a(pc), a2
        lea.l H010+$93A(pc), a2
L010_00000942:
; H010+$00000942: 04420068  subi.w #$68, d2
        subi.w #IECODE_LBUTTON, d2
L010_00000946:
; H010+$00000946: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L010_0000094A:
; H010+$0000094A: 6302  bls.b $94e
        bls.b H010+$94E
L010_0000094C:
; H010+$0000094C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L010_0000094E:
; H010+$0000094E: e342  asl.w #$1, d2
        asl.w #$1, d2
L010_00000950:
; H010+$00000950: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: words relative to H010+$093A; indices 0..1, default -1.
L010_00000954:
; H010+$00000954: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L010_00000958:
; H010+$00000958: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L010_0000095A:
; H010+$0000095A: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H050+$0064 (wrapper_ReplyMsg)
L010_0000095E:
; H010+$0000095E: 4eb900000064  jsr $64.l
        jsr (H050+$64).l
L010_00000964:
; H010+$00000964: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L010_00000966:
; H010+$00000966: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L010_0000096A:
; H010+$0000096A: 6600ff22  bne.w $88e
        bne.w H010+$88E
L010_0000096E:
; H010+$0000096E: 4e5d  unlk a5
        unlk a5
L010_00000970:
; H010+$00000970: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L010_00000972:
; H010+$00000972: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H010_00000974 [partial]
; Purpose: Routine of the Intuition input, event conversion and exit/error services module; calls H050+$0076.
;   - Calls H050+$0076.
;   - Uses the global state: H005+$52F6 (pointer to the game window); H005+$5305 (byte of the pending key/action).
; Direct callers: H030+$02E0, H029+$1512, H014+$00CA, H034+$0162, H030+$078C, H013+$34FE and 4 more
; --------------------------------------------------------------------------
L010_00000974:
; H010+$00000974: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L010_00000976:
; H010+$00000976: 287af73a  movea.l $b2(pc), a4
        movea.l H010+$B2(pc), a4
L010_0000097A:
; H010+$0000097A: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
; STATE: H005+$52F6 = pointer to the game window
L010_0000097E:
; H010+$0000097E: 2479000052f6  movea.l $52f6.l, a2
        movea.l (H005+$52F6).l, a2
L010_00000984:
; H010+$00000984: 266a0056  movea.l $56(a2), a3
        movea.l $56(a2), a3
L010_00000988:
; H010+$00000988: 4853  pea.l (a3)
        pea.l (a3)
; -> H050+$0076 (wrapper_WaitPort)
L010_0000098A:
; H010+$0000098A: 4eb900000076  jsr $76.l
        jsr (H050+$76).l
L010_00000990:
; H010+$00000990: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L010_00000994:
; H010+$00000994: 6100fa98  bsr.w $42e
        bsr.w H010+$42E
; STATE: H005+$5305 = byte of the pending key/action
L010_00000998:
; H010+$00000998: 4a3900005305  tst.b $5305.l
        tst.b (H005+$5305).l
L010_0000099E:
; H010+$0000099E: 67de  beq.b $97e
        beq.b H010+$97E
L010_000009A0:
; H010+$000009A0: 4e5d  unlk a5
        unlk a5
L010_000009A2:
; H010+$000009A2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L010_000009A4:
; H010+$000009A4: 4e75  rts 
        rts 
L010_000009A6:
; H010+$000009A6: 422cffad  clr.b -$53(a4)
        clr.b -$53(a4)
L010_000009AA:
; H010+$000009AA: 422cffac  clr.b -$54(a4)
        clr.b -$54(a4)
L010_000009AE:
; H010+$000009AE: 422cffab  clr.b -$55(a4)
        clr.b -$55(a4)
L010_000009B2:
; H010+$000009B2: 4e5d  unlk a5
        unlk a5
L010_000009B4:
; H010+$000009B4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L010_000009B6:
; H010+$000009B6: 4e75  rts 
        rts 
; End H010: $9B8 bytes
