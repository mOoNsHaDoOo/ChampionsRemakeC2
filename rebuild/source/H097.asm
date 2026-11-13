; ============================================================================
; MODULE GUIDE H097
; Actions and control of the actors in combat; partial detail.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Actions and control of the actors in combat: turns, choices, movement and end conditions.
; --------------------------------------------------------------------------
; H097: 8296 original bytes; all offsets are section-relative.
        section H097,code
H097:
; Preserved bytes H097+$00000000..$000000A2; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$4D61,$6769,$6320,$4F6E,$004D,$6167,$6963
        dc.w $204F,$6666,$0069,$7320,$666F,$7263,$6564,$2074
        dc.w $6F20,$666C,$6565,$0053,$7572,$7265,$6E64,$6572
        dc.w $7300,$4D6F,$7665,$2F41,$7474,$6163,$6B2C,$204D
        dc.w $6F76,$6520,$4C65,$6674,$203D,$2000,$2000,$666C
        dc.w $6565,$7320,$696E,$2070,$616E,$6963,$0000
        dc.l H097+$00000042
; --------------------------------------------------------------------------
; ROUTINE: module_init_H097 [partial]
; Purpose: Entry of the actions and control of the actors in combat module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H097+$1FAC.
; Direct callers: H000+$0210
; --------------------------------------------------------------------------
L097_000000A2:
; H097+$000000A2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_000000A4:
; H097+$000000A4: 287afff8  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_000000A8:
; H097+$000000A8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L097_000000AC:
; H097+$000000AC: 60001efe  bra.w $1fac
        bra.w H097+$1FAC
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_000000B0 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H010+$042E, H063+$1D44, H029+$03E2, H096+$4DE8.
;   - Calls H010+$042E.
;   - Calls H063+$1D44.
;   - Calls H029+$03E2.
;   - Calls H096+$4DE8.
;   - Uses the global state: H005+$5305 (byte of the pending key/action); H005+$3364 (head of the party list).
; Direct callers: H097+$1D76, H097+$1F3C, H097+$14D0
; --------------------------------------------------------------------------
L097_000000B0:
; H097+$000000B0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_000000B2:
; H097+$000000B2: 287affea  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_000000B6:
; H097+$000000B6: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L097_000000BA:
; H097+$000000BA: 422dfffa  clr.b -$6(a5)
        clr.b -$6(a5)
; -> H010+$042E (trampoline_H010_0882)
L097_000000BE:
; H097+$000000BE: 4eb90000042e  jsr $42e.l
        jsr (H010+$42E).l
; STATE: H005+$5305 = byte of the pending key/action
L097_000000C4:
; H097+$000000C4: 4a3900005305  tst.b $5305.l
        tst.b (H005+$5305).l
L097_000000CA:
; H097+$000000CA: 67000166  beq.w $232
        beq.w H097+$232
; STATE: H005+$5305 = byte of the pending key/action
L097_000000CE:
; H097+$000000CE: 1b7900005305fffb  move.b $5305.l, -$5(a5)
        move.b (H005+$5305).l, -$5(a5)
L097_000000D6:
; H097+$000000D6: 1b7c0001fffa  move.b #$1, -$6(a5)
        move.b #$1, -$6(a5)
L097_000000DC:
; H097+$000000DC: 7400  moveq #$0, d2
        moveq #0, d2
L097_000000DE:
; H097+$000000DE: 142dfffb  move.b -$5(a5), d2
        move.b -$5(a5), d2
L097_000000E2:
; H097+$000000E2: 60000136  bra.w $21a
        bra.w H097+$21A
L097_000000E6:
; H097+$000000E6: 4a39000024a0  tst.b $24a0.l
        tst.b (H005+$24A0).l
L097_000000EC:
; H097+$000000EC: 57c2  seq.b d2
        seq.b d2
L097_000000EE:
; H097+$000000EE: 4402  neg.b d2
        neg.b d2
L097_000000F0:
; H097+$000000F0: 13c2000024a0  move.b d2, $24a0.l
        move.b d2, (H005+$24A0).l
L097_000000F6:
; H097+$000000F6: 4a39000024a0  tst.b $24a0.l
        tst.b (H005+$24A0).l
L097_000000FC:
; H097+$000000FC: 67000014  beq.w $112
        beq.w H097+$112
L097_00000100:
; H097+$00000100: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L097_00000104:
; H097+$00000104: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L097_00000108:
; H097+$00000108: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L097_0000010E:
; H097+$0000010E: 60000010  bra.w $120
        bra.w H097+$120
L097_00000112:
; H097+$00000112: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L097_00000116:
; H097+$00000116: 486c0009  pea.l $9(a4)
        pea.l $9(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L097_0000011A:
; H097+$0000011A: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L097_00000120:
; H097+$00000120: 4e75  rts 
        rts 
; STATE: H005+$3364 = head of the party list
L097_00000122:
; H097+$00000122: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L097_0000012A:
; H097+$0000012A: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L097_0000012E:
; H097+$0000012E: 67000036  beq.w $166
        beq.w H097+$166
L097_00000132:
; H097+$00000132: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000134:
; H097+$00000134: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L097_00000138:
; H097+$00000138: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L097_0000013C:
; H097+$0000013C: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L097_00000140:
; H097+$00000140: 64000018  bcc.w $15a
        bcc.w H097+$15A
L097_00000144:
; H097+$00000144: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L097_00000148:
; H097+$00000148: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L097_0000014E:
; H097+$0000014E: 6700000a  beq.w $15a
        beq.w H097+$15A
L097_00000152:
; H097+$00000152: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L097_00000156:
; H097+$00000156: 422b019a  clr.b $19a(a3)
        clr.b $19a(a3)
L097_0000015A:
; H097+$0000015A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L097_0000015E:
; H097+$0000015E: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L097_00000164:
; H097+$00000164: 60c4  bra.b $12a
        bra.b H097+$12A
L097_00000166:
; H097+$00000166: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000016A:
; H097+$0000016A: 4a2b019a  tst.b $19a(a3)
        tst.b $19a(a3)
L097_0000016E:
; H097+$0000016E: 6600003a  bne.w $1aa
        bne.w H097+$1AA
L097_00000172:
; H097+$00000172: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000176:
; H097+$00000176: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000017A:
; H097+$0000017A: 377c00140004  move.w #$14, $4(a3)
        move.w #$14, $4(a3)
L097_00000180:
; H097+$00000180: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000184:
; H097+$00000184: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000188:
; H097+$00000188: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000018A:
; H097+$0000018A: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_0000018E:
; H097+$0000018E: 4a42  tst.w d2
        tst.w d2
L097_00000190:
; H097+$00000190: 63000012  bls.w $1a4
        bls.w H097+$1A4
L097_00000194:
; H097+$00000194: 487900002480  pea.l $2480.l
        pea.l (H005+$2480).l
L097_0000019A:
; H097+$0000019A: 3f3cffff  move.w #$ffff, -(a7)
        move.w #$ffff, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L097_0000019E:
; H097+$0000019E: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L097_000001A4:
; H097+$000001A4: 1b7c0001fffa  move.b #$1, -$6(a5)
        move.b #$1, -$6(a5)
L097_000001AA:
; H097+$000001AA: 4e75  rts 
        rts 
; -> H096+$4DE8 (trampoline_H096_4DF8)
L097_000001AC:
; H097+$000001AC: 4eb900004de8  jsr $4de8.l
        jsr (H096+$4DE8).l
L097_000001B2:
; H097+$000001B2: 1b40fff9  move.b d0, -$7(a5)
        move.b d0, -$7(a5)
L097_000001B6:
; H097+$000001B6: 4e75  rts 
        rts 
L097_000001B8:
; H097+$000001B8: 4e75  rts 
        rts 
; Preserved bytes H097+$000001BA..$0000021A; code/data not fully classified.
        dc.w $FFFC,$FFF0,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FF66,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FF2A
L097_0000021A:
; H097+$0000021A: 47faffa0  lea.l $1bc(pc), a3
        lea.l H097+$1BC(pc), a3
L097_0000021E:
; H097+$0000021E: 5942  subq.w #$4, d2
        subq.w #$4, d2
L097_00000220:
; H097+$00000220: 0c42002e  cmpi.w #$2e, d2
        cmpi.w #$2e, d2
L097_00000224:
; H097+$00000224: 6302  bls.b $228
        bls.b H097+$228
L097_00000226:
; H097+$00000226: 74ff  moveq #$ff, d2
        moveq #-1, d2
L097_00000228:
; H097+$00000228: e342  asl.w #$1, d2
        asl.w #$1, d2
L097_0000022A:
; H097+$0000022A: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H097+$01BC; indices 0..46, default -1.
L097_0000022E:
; H097+$0000022E: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L097_00000232:
; H097+$00000232: 102dfffa  move.b -$6(a5), d0
        move.b -$6(a5), d0
L097_00000236:
; H097+$00000236: 60000002  bra.w $23a
        bra.w H097+$23A
L097_0000023A:
; H097+$0000023A: 4e5d  unlk a5
        unlk a5
L097_0000023C:
; H097+$0000023C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_0000023E:
; H097+$0000023E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00000240:
; H097+$00000240: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_00000242:
; H097+$00000242: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_00000244 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H063+$1EE8, H063+$135A, H063+$3698, H063+$2F12.
;   - Calls H063+$1EE8.
;   - Calls H063+$135A.
;   - Calls H063+$3698.
;   - Calls H063+$2F12.
;   - Calls H063+$2F5A.
; Direct callers: H097+$1F98, H097+$19FA, H097+$18C0, H097+$1B70, H097+$17A4
; --------------------------------------------------------------------------
L097_00000244:
; H097+$00000244: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_00000246:
; H097+$00000246: 287afe56  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_0000024A:
; H097+$0000024A: 4e550000  link.w a5, #$0
        link.w a5, #$0
; -> H063+$1EE8 (sub_H063_00001EE8)
L097_0000024E:
; H097+$0000024E: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
L097_00000254:
; H097+$00000254: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$135A (sub_H063_0000135A)
L097_00000258:
; H097+$00000258: 4eb90000135a  jsr $135a.l
        jsr (H063+$135A).l
L097_0000025E:
; H097+$0000025E: 1400  move.b d0, d2
        move.b d0, d2
L097_00000260:
; H097+$00000260: 4a02  tst.b d2
        tst.b d2
L097_00000262:
; H097+$00000262: 66000024  bne.w $288
        bne.w H097+$288
L097_00000266:
; H097+$00000266: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$3698 (sub_H063_00003698)
L097_0000026A:
; H097+$0000026A: 4eb900003698  jsr $3698.l
        jsr (H063+$3698).l
L097_00000270:
; H097+$00000270: 1400  move.b d0, d2
        move.b d0, d2
L097_00000272:
; H097+$00000272: 4a02  tst.b d2
        tst.b d2
L097_00000274:
; H097+$00000274: 66000012  bne.w $288
        bne.w H097+$288
L097_00000278:
; H097+$00000278: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000027C:
; H097+$0000027C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000280:
; H097+$00000280: 4a6b0004  tst.w $4(a3)
        tst.w $4(a3)
L097_00000284:
; H097+$00000284: 66000014  bne.w $29a
        bne.w H097+$29A
L097_00000288:
; H097+$00000288: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_0000028C:
; H097+$0000028C: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_00000292:
; H097+$00000292: 60000014  bra.w $2a8
        bra.w H097+$2A8
; Preserved bytes H097+$00000296..$0000029A; code/data not fully classified.
        dc.w $6000,$0010
L097_0000029A:
; H097+$0000029A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F5A (sub_H063_00002F5A)
L097_0000029E:
; H097+$0000029E: 4eb900002f5a  jsr $2f5a.l
        jsr (H063+$2F5A).l
L097_000002A4:
; H097+$000002A4: 60000002  bra.w $2a8
        bra.w H097+$2A8
L097_000002A8:
; H097+$000002A8: 4e5d  unlk a5
        unlk a5
L097_000002AA:
; H097+$000002AA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_000002AC:
; H097+$000002AC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_000002AE:
; H097+$000002AE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_000002B0:
; H097+$000002B0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_000002B2 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H029+$0354.
;   - Calls H029+$0354.
; Direct callers: H097+$0D52
; --------------------------------------------------------------------------
L097_000002B2:
; H097+$000002B2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_000002B4:
; H097+$000002B4: 287afde8  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_000002B8:
; H097+$000002B8: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L097_000002BC:
; H097+$000002BC: 7400  moveq #$0, d2
        moveq #0, d2
L097_000002BE:
; H097+$000002BE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000002C2:
; H097+$000002C2: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_000002C6:
; H097+$000002C6: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_000002CA:
; H097+$000002CA: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_000002D0:
; H097+$000002D0: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L097_000002D4:
; H097+$000002D4: 45edffec  lea.l -$14(a5), a2
        lea.l -$14(a5), a2
L097_000002D8:
; H097+$000002D8: 7408  moveq #$8, d2
        moveq #8, d2
L097_000002DA:
; H097+$000002DA: 34db  move.w (a3)+, (a2)+
        move.w (a3)+, (a2)+
L097_000002DC:
; H097+$000002DC: 51cafffc  dbra d2, $2da
        dbra d2, H097+$2DA
L097_000002E0:
; H097+$000002E0: 7400  moveq #$0, d2
        moveq #0, d2
L097_000002E2:
; H097+$000002E2: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L097_000002E6:
; H097+$000002E6: 7800  moveq #$0, d4
        moveq #0, d4
L097_000002E8:
; H097+$000002E8: 182dfff6  move.b -$a(a5), d4
        move.b -$a(a5), d4
L097_000002EC:
; H097+$000002EC: c4c4  mulu.w d4, d2
        mulu.w d4, d2
L097_000002EE:
; H097+$000002EE: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_000002F2:
; H097+$000002F2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000002F6:
; H097+$000002F6: 4a6b0036  tst.w $36(a3)
        tst.w $36(a3)
L097_000002FA:
; H097+$000002FA: 6f000014  ble.w $310
        ble.w H097+$310
L097_000002FE:
; H097+$000002FE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000302:
; H097+$00000302: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L097_00000306:
; H097+$00000306: e742  asl.w #$3, d2
        asl.w #$3, d2
L097_00000308:
; H097+$00000308: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L097_0000030C:
; H097+$0000030C: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_00000310:
; H097+$00000310: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L097_00000314:
; H097+$00000314: 6f000010  ble.w $326
        ble.w H097+$326
L097_00000318:
; H097+$00000318: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L097_0000031C:
; H097+$0000031C: e342  asl.w #$1, d2
        asl.w #$1, d2
L097_0000031E:
; H097+$0000031E: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L097_00000322:
; H097+$00000322: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_00000326:
; H097+$00000326: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000328:
; H097+$00000328: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000032C:
; H097+$0000032C: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_00000330:
; H097+$00000330: 0c420036  cmpi.w #$36, d2
        cmpi.w #$36, d2
L097_00000334:
; H097+$00000334: 6600002c  bne.w $362
        bne.w H097+$362
L097_00000338:
; H097+$00000338: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L097_0000033C:
; H097+$0000033C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000340:
; H097+$00000340: 4aab000c  tst.l $c(a3)
        tst.l $c(a3)
L097_00000344:
; H097+$00000344: 6700001c  beq.w $362
        beq.w H097+$362
L097_00000348:
; H097+$00000348: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L097_0000034C:
; H097+$0000034C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000350:
; H097+$00000350: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L097_00000354:
; H097+$00000354: 4a2b00df  tst.b $df(a3)
        tst.b $df(a3)
L097_00000358:
; H097+$00000358: 63000008  bls.w $362
        bls.w H097+$362
L097_0000035C:
; H097+$0000035C: 3b7c0008fffe  move.w #$8, -$2(a5)
        move.w #$8, -$2(a5)
L097_00000362:
; H097+$00000362: 1f2dfffc  move.b -$4(a5), -(a7)
        move.b -$4(a5), -(a7)
L097_00000366:
; H097+$00000366: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_0000036A:
; H097+$0000036A: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000370:
; H097+$00000370: 1400  move.b d0, d2
        move.b d0, d2
L097_00000372:
; H097+$00000372: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L097_00000376:
; H097+$00000376: 4a42  tst.w d2
        tst.w d2
L097_00000378:
; H097+$00000378: 63000014  bls.w $38e
        bls.w H097+$38E
L097_0000037C:
; H097+$0000037C: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000037E:
; H097+$0000037E: 142dfff2  move.b -$e(a5), d2
        move.b -$e(a5), d2
L097_00000382:
; H097+$00000382: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00000384:
; H097+$00000384: e342  asl.w #$1, d2
        asl.w #$1, d2
L097_00000386:
; H097+$00000386: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L097_0000038A:
; H097+$0000038A: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_0000038E:
; H097+$0000038E: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000390:
; H097+$00000390: 142dffed  move.b -$13(a5), d2
        move.b -$13(a5), d2
L097_00000394:
; H097+$00000394: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L097_00000398:
; H097+$00000398: 6200000c  bhi.w $3a6
        bhi.w H097+$3A6
L097_0000039C:
; H097+$0000039C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_000003A0:
; H097+$000003A0: 5642  addq.w #$3, d2
        addq.w #$3, d2
L097_000003A2:
; H097+$000003A2: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_000003A6:
; H097+$000003A6: 7400  moveq #$0, d2
        moveq #0, d2
L097_000003A8:
; H097+$000003A8: 142dffed  move.b -$13(a5), d2
        move.b -$13(a5), d2
L097_000003AC:
; H097+$000003AC: 7800  moveq #$0, d4
        moveq #0, d4
L097_000003AE:
; H097+$000003AE: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L097_000003B2:
; H097+$000003B2: 182b0188  move.b $188(a3), d4
        move.b $188(a3), d4
L097_000003B6:
; H097+$000003B6: d444  add.w d4, d2
        add.w d4, d2
L097_000003B8:
; H097+$000003B8: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L097_000003BC:
; H097+$000003BC: 63000006  bls.w $3c4
        bls.w H097+$3C4
L097_000003C0:
; H097+$000003C0: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L097_000003C4:
; H097+$000003C4: 7400  moveq #$0, d2
        moveq #0, d2
L097_000003C6:
; H097+$000003C6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000003CA:
; H097+$000003CA: 142b0046  move.b $46(a3), d2
        move.b $46(a3), d2
L097_000003CE:
; H097+$000003CE: 0c420084  cmpi.w #$84, d2
        cmpi.w #$84, d2
L097_000003D2:
; H097+$000003D2: 6600002e  bne.w $402
        bne.w H097+$402
L097_000003D6:
; H097+$000003D6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000003DA:
; H097+$000003DA: 1f2b0045  move.b $45(a3), -(a7)
        move.b $45(a3), -(a7)
L097_000003DE:
; H097+$000003DE: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_000003E2:
; H097+$000003E2: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_000003E8:
; H097+$000003E8: 1400  move.b d0, d2
        move.b d0, d2
L097_000003EA:
; H097+$000003EA: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L097_000003EE:
; H097+$000003EE: 7800  moveq #$0, d4
        moveq #0, d4
L097_000003F0:
; H097+$000003F0: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L097_000003F4:
; H097+$000003F4: 182b010f  move.b $10f(a3), d4
        move.b $10f(a3), d4
L097_000003F8:
; H097+$000003F8: b444  cmp.w d4, d2
        cmp.w d4, d2
L097_000003FA:
; H097+$000003FA: 67000006  beq.w $402
        beq.w H097+$402
L097_000003FE:
; H097+$000003FE: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L097_00000402:
; H097+$00000402: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000404:
; H097+$00000404: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000408:
; H097+$00000408: 142b0045  move.b $45(a3), d2
        move.b $45(a3), d2
L097_0000040C:
; H097+$0000040C: 0c420053  cmpi.w #$53, d2
        cmpi.w #$53, d2
L097_00000410:
; H097+$00000410: 66000006  bne.w $418
        bne.w H097+$418
L097_00000414:
; H097+$00000414: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L097_00000418:
; H097+$00000418: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000041C:
; H097+$0000041C: 4a2b003c  tst.b $3c(a3)
        tst.b $3c(a3)
L097_00000420:
; H097+$00000420: 67000006  beq.w $428
        beq.w H097+$428
L097_00000424:
; H097+$00000424: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L097_00000428:
; H097+$00000428: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L097_0000042C:
; H097+$0000042C: 60000002  bra.w $430
        bra.w H097+$430
L097_00000430:
; H097+$00000430: 4e5d  unlk a5
        unlk a5
L097_00000432:
; H097+$00000432: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_00000434:
; H097+$00000434: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00000436:
; H097+$00000436: 508f  addq.l #$8, a7
        addq.l #$8, a7
L097_00000438:
; H097+$00000438: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_0000043A [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H062+$1898, H063+$1DC2, H029+$0354, H062+$083E.
;   - Calls H062+$1898.
;   - Calls H063+$1DC2.
;   - Calls H029+$0354.
;   - Calls H062+$083E.
;   - Calls H096+$3852.
;   - Calls H096+$023E.
;   - Calls H062+$0452.
;   - Uses the global state: H005+$3E00 (pointer to persistent state B, 2048 bytes).
; Direct callers: H097+$1E44
; --------------------------------------------------------------------------
L097_0000043A:
; H097+$0000043A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_0000043C:
; H097+$0000043C: 287afc60  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00000440:
; H097+$00000440: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L097_00000444:
; H097+$00000444: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000448:
; H097+$00000448: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000044C:
; H097+$0000044C: 422b0016  clr.b $16(a3)
        clr.b $16(a3)
L097_00000450:
; H097+$00000450: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H062+$1898 (sub_H062_00001898)
L097_00000454:
; H097+$00000454: 4eb900001898  jsr $1898.l
        jsr (H062+$1898).l
L097_0000045A:
; H097+$0000045A: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000045E:
; H097+$0000045E: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000462:
; H097+$00000462: 4a2b0012  tst.b $12(a3)
        tst.b $12(a3)
L097_00000466:
; H097+$00000466: 6700002e  beq.w $496
        beq.w H097+$496
L097_0000046A:
; H097+$0000046A: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000046E:
; H097+$0000046E: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000472:
; H097+$00000472: 177c00010016  move.b #$1, $16(a3)
        move.b #$1, $16(a3)
L097_00000478:
; H097+$00000478: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_0000047C:
; H097+$0000047C: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L097_00000480:
; H097+$00000480: 486c0013  pea.l $13(a4)
        pea.l $13(a4)
L097_00000484:
; H097+$00000484: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L097_00000488:
; H097+$00000488: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L097_0000048C:
; H097+$0000048C: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L097_00000492:
; H097+$00000492: 6000017c  bra.w $610
        bra.w H097+$610
L097_00000496:
; H097+$00000496: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000498:
; H097+$00000498: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000049C:
; H097+$0000049C: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L097_000004A0:
; H097+$000004A0: 0c42007f  cmpi.w #$7f, d2
        cmpi.w #$7f, d2
L097_000004A4:
; H097+$000004A4: 6300016a  bls.w $610
        bls.w H097+$610
L097_000004A8:
; H097+$000004A8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000004AC:
; H097+$000004AC: 1f2b00ec  move.b $ec(a3), -(a7)
        move.b $ec(a3), -(a7)
L097_000004B0:
; H097+$000004B0: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_000004B4:
; H097+$000004B4: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_000004BA:
; H097+$000004BA: 1400  move.b d0, d2
        move.b d0, d2
L097_000004BC:
; H097+$000004BC: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L097_000004C0:
; H097+$000004C0: e342  asl.w #$1, d2
        asl.w #$1, d2
L097_000004C2:
; H097+$000004C2: 13c200002478  move.b d2, $2478.l
        move.b d2, (H005+$2478).l
L097_000004C8:
; H097+$000004C8: 7400  moveq #$0, d2
        moveq #0, d2
L097_000004CA:
; H097+$000004CA: 143900002478  move.b $2478.l, d2
        move.b (H005+$2478).l, d2
L097_000004D0:
; H097+$000004D0: 0c420066  cmpi.w #$66, d2
        cmpi.w #$66, d2
L097_000004D4:
; H097+$000004D4: 63000008  bls.w $4de
        bls.w H097+$4DE
L097_000004D8:
; H097+$000004D8: 423900002478  clr.b $2478.l
        clr.b (H005+$2478).l
L097_000004DE:
; H097+$000004DE: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L097_000004E2:
; H097+$000004E2: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
; -> H062+$083E (trampoline_H062_0F04)
L097_000004E6:
; H097+$000004E6: 4eb90000083e  jsr $83e.l
        jsr (H062+$83E).l
L097_000004EC:
; H097+$000004EC: 7400  moveq #$0, d2
        moveq #0, d2
L097_000004EE:
; H097+$000004EE: 143900002478  move.b $2478.l, d2
        move.b (H005+$2478).l, d2
L097_000004F4:
; H097+$000004F4: 7800  moveq #$0, d4
        moveq #0, d4
L097_000004F6:
; H097+$000004F6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000004FA:
; H097+$000004FA: 182b01a8  move.b $1a8(a3), d4
        move.b $1a8(a3), d4
L097_000004FE:
; H097+$000004FE: c8fc0064  mulu.w #$64, d4
        mulu.w #$64, d4
L097_00000502:
; H097+$00000502: 7c00  moveq #$0, d6
        moveq #0, d6
L097_00000504:
; H097+$00000504: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000508:
; H097+$00000508: 1c2b0064  move.b $64(a3), d6
        move.b $64(a3), d6
L097_0000050C:
; H097+$0000050C: 88c6  divu.w d6, d4
        divu.w d6, d4
L097_0000050E:
; H097+$0000050E: 7c64  moveq #$64, d6
        moveq #100, d6
L097_00000510:
; H097+$00000510: 9c44  sub.w d4, d6
        sub.w d4, d6
L097_00000512:
; H097+$00000512: b446  cmp.w d6, d2
        cmp.w d6, d2
L097_00000514:
; H097+$00000514: 65000010  bcs.w $526
        bcs.w H097+$526
L097_00000518:
; H097+$00000518: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000051A:
; H097+$0000051A: 143900002478  move.b $2478.l, d2
        move.b (H005+$2478).l, d2
L097_00000520:
; H097+$00000520: 4a42  tst.w d2
        tst.w d2
L097_00000522:
; H097+$00000522: 660000ec  bne.w $610
        bne.w H097+$610
L097_00000526:
; H097+$00000526: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000528:
; H097+$00000528: 143900002478  move.b $2478.l, d2
        move.b (H005+$2478).l, d2
L097_0000052E:
; H097+$0000052E: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L097_00000532:
; H097+$00000532: 13f90000248100002478  move.b $2481.l, $2478.l
        move.b (H005+$2481).l, (H005+$2478).l
L097_0000053C:
; H097+$0000053C: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L097_00000540:
; H097+$00000540: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
; -> H062+$083E (trampoline_H062_0F04)
L097_00000544:
; H097+$00000544: 4eb90000083e  jsr $83e.l
        jsr (H062+$83E).l
L097_0000054A:
; H097+$0000054A: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000054C:
; H097+$0000054C: 143900002478  move.b $2478.l, d2
        move.b (H005+$2478).l, d2
L097_00000552:
; H097+$00000552: 7864  moveq #$64, d4
        moveq #100, d4
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L097_00000554:
; H097+$00000554: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L097_0000055A:
; H097+$0000055A: 986b058c  sub.w $58c(a3), d4
        sub.w $58c(a3), d4
L097_0000055E:
; H097+$0000055E: b444  cmp.w d4, d2
        cmp.w d4, d2
L097_00000560:
; H097+$00000560: 6500001c  bcs.w $57e
        bcs.w H097+$57E
L097_00000564:
; H097+$00000564: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000566:
; H097+$00000566: 143900002478  move.b $2478.l, d2
        move.b (H005+$2478).l, d2
L097_0000056C:
; H097+$0000056C: 4a42  tst.w d2
        tst.w d2
L097_0000056E:
; H097+$0000056E: 6700000e  beq.w $57e
        beq.w H097+$57E
L097_00000572:
; H097+$00000572: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000576:
; H097+$00000576: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L097_0000057A:
; H097+$0000057A: 66000094  bne.w $610
        bne.w H097+$610
L097_0000057E:
; H097+$0000057E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H096+$3852 (sub_H096_00003852)
L097_00000582:
; H097+$00000582: 4eb900003852  jsr $3852.l
        jsr (H096+$3852).l
L097_00000588:
; H097+$00000588: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L097_0000058C:
; H097+$0000058C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H096+$023E (sub_H096_0000023E)
L097_00000590:
; H097+$00000590: 4eb90000023e  jsr $23e.l
        jsr (H096+$23E).l
L097_00000596:
; H097+$00000596: 3400  move.w d0, d2
        move.w d0, d2
L097_00000598:
; H097+$00000598: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_0000059E:
; H097+$0000059E: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L097_000005A0:
; H097+$000005A0: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L097_000005A4:
; H097+$000005A4: 65000034  bcs.w $5da
        bcs.w H097+$5DA
L097_000005A8:
; H097+$000005A8: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000005AC:
; H097+$000005AC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000005B0:
; H097+$000005B0: 177c00010016  move.b #$1, $16(a3)
        move.b #$1, $16(a3)
L097_000005B6:
; H097+$000005B6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000005BA:
; H097+$000005BA: 3f3c004a  move.w #$4a, -(a7)
        move.w #$4a, -(a7)
L097_000005BE:
; H097+$000005BE: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H062+$0452 (sub_H062_00000452)
L097_000005C0:
; H097+$000005C0: 4eb900000452  jsr $452.l
        jsr (H062+$452).l
L097_000005C6:
; H097+$000005C6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000005CA:
; H097+$000005CA: 3f3c004b  move.w #$4b, -(a7)
        move.w #$4b, -(a7)
L097_000005CE:
; H097+$000005CE: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H062+$0452 (sub_H062_00000452)
L097_000005D0:
; H097+$000005D0: 4eb900000452  jsr $452.l
        jsr (H062+$452).l
L097_000005D6:
; H097+$000005D6: 60000038  bra.w $610
        bra.w H097+$610
L097_000005DA:
; H097+$000005DA: 7400  moveq #$0, d2
        moveq #0, d2
L097_000005DC:
; H097+$000005DC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000005E0:
; H097+$000005E0: 142b0013  move.b $13(a3), d2
        move.b $13(a3), d2
L097_000005E4:
; H097+$000005E4: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L097_000005E8:
; H097+$000005E8: 63000026  bls.w $610
        bls.w H097+$610
L097_000005EC:
; H097+$000005EC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000005F0:
; H097+$000005F0: 1f3c0004  move.b #$4, -(a7)
        move.b #$4, -(a7)
L097_000005F4:
; H097+$000005F4: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L097_000005F8:
; H097+$000005F8: 486c0025  pea.l $25(a4)
        pea.l $25(a4)
; -> H062+$1694 (sub_H062_00001694)
L097_000005FC:
; H097+$000005FC: 4eb900001694  jsr $1694.l
        jsr (H062+$1694).l
L097_00000602:
; H097+$00000602: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_00000606:
; H097+$00000606: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_0000060C:
; H097+$0000060C: 60000008  bra.w $616
        bra.w H097+$616
L097_00000610:
; H097+$00000610: 7000  moveq #$0, d0
        moveq #0, d0
L097_00000612:
; H097+$00000612: 60000002  bra.w $616
        bra.w H097+$616
L097_00000616:
; H097+$00000616: 4e5d  unlk a5
        unlk a5
L097_00000618:
; H097+$00000618: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_0000061A:
; H097+$0000061A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_0000061C:
; H097+$0000061C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_0000061E:
; H097+$0000061E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H097_075C [partial]
; Purpose: Trampoline to H097+$075C; the actual body is there.
;   - Jumps to the actual body at H097+$075C.
;   - Calls H096+$25DA.
;   - Calls H033+$11FC.
;   - Calls H063+$2BDE.
; Direct callers: H097+$09AA, H097+$0BBE
; --------------------------------------------------------------------------
L097_00000620:
; H097+$00000620: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_00000622:
; H097+$00000622: 287afa7a  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00000626:
; H097+$00000626: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L097_0000062A:
; H097+$0000062A: 60000130  bra.w $75c
        bra.w H097+$75C
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H097_0650 [partial]
; Purpose: Trampoline to H097+$0650; the actual body is there.
;   - Jumps to the actual body at H097+$0650.
;   - Calls H077+$08AC.
;   - Calls H063+$2B4C.
;   - Calls H062+$142C.
;   - Calls H096+$25DA.
;   - Calls H033+$11FC.
;   - Calls H063+$2BDE.
;   - Uses the global state: H005+$3368 (current character).
; Direct callers: H097+$0866
; --------------------------------------------------------------------------
L097_0000062E:
; H097+$0000062E: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
; STATE: H005+$3368 = current character
L097_00000632:
; H097+$00000632: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L097_00000638:
; H097+$00000638: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L097_0000063C:
; H097+$0000063C: 6600000c  bne.w $64a
        bne.w H097+$64A
L097_00000640:
; H097+$00000640: 3b7cfffefffc  move.w #$fffe, -$4(a5)
        move.w #$fffe, -$4(a5)
L097_00000646:
; H097+$00000646: 60000008  bra.w $650
        bra.w H097+$650
L097_0000064A:
; H097+$0000064A: 3b7c0008fffc  move.w #$8, -$4(a5)
        move.w #$8, -$4(a5)
L097_00000650:
; H097+$00000650: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L097_00000654:
; H097+$00000654: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L097_00000658:
; H097+$00000658: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L097_0000065C:
; H097+$0000065C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_0000065E:
; H097+$0000065E: e942  asl.w #$4, d2
        asl.w #$4, d2
L097_00000660:
; H097+$00000660: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L097_00000666:
; H097+$00000666: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000668:
; H097+$00000668: 1833200f  move.b $f(a3, d2.w), d4
        move.b $f(a3, d2.w), d4
L097_0000066C:
; H097+$0000066C: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L097_0000066E:
; H097+$0000066E: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L097_00000672:
; H097+$00000672: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00000676:
; H097+$00000676: 2f3900002ade  move.l $2ade.l, -(a7)
        move.l (H005+$2ADE).l, -(a7)
; -> H077+$08AC (sub_H077_000008AC)
L097_0000067C:
; H097+$0000067C: 4eb9000008ac  jsr $8ac.l
        jsr (H077+$8AC).l
L097_00000682:
; H097+$00000682: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L097_00000688:
; H097+$00000688: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000068A:
; H097+$0000068A: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L097_00000690:
; H097+$00000690: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L097_00000692:
; H097+$00000692: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_00000696:
; H097+$00000696: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L097_00000698:
; H097+$00000698: 620000b0  bhi.w $74a
        bhi.w H097+$74A
L097_0000069C:
; H097+$0000069C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_000006A0:
; H097+$000006A0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_000006A2:
; H097+$000006A2: e542  asl.w #$2, d2
        asl.w #$2, d2
L097_000006A4:
; H097+$000006A4: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L097_000006AA:
; H097+$000006AA: 7800  moveq #$0, d4
        moveq #0, d4
L097_000006AC:
; H097+$000006AC: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_000006B0:
; H097+$000006B0: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_000006B2:
; H097+$000006B2: e544  asl.w #$2, d4
        asl.w #$2, d4
L097_000006B4:
; H097+$000006B4: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L097_000006BA:
; H097+$000006BA: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
; STATE: H005+$3368 = current character
L097_000006BE:
; H097+$000006BE: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$2B4C (trampoline_H063_2B72)
L097_000006C4:
; H097+$000006C4: 4eb900002b4c  jsr $2b4c.l
        jsr (H063+$2B4C).l
L097_000006CA:
; H097+$000006CA: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L097_000006CE:
; H097+$000006CE: 1400  move.b d0, d2
        move.b d0, d2
L097_000006D0:
; H097+$000006D0: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L097_000006D4:
; H097+$000006D4: 182b0199  move.b $199(a3), d4
        move.b $199(a3), d4
L097_000006D8:
; H097+$000006D8: b802  cmp.b d2, d4
        cmp.b d2, d4
L097_000006DA:
; H097+$000006DA: 67000066  beq.w $742
        beq.w H097+$742
L097_000006DE:
; H097+$000006DE: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L097_000006E2:
; H097+$000006E2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_000006E4:
; H097+$000006E4: e942  asl.w #$4, d2
        asl.w #$4, d2
L097_000006E6:
; H097+$000006E6: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L097_000006EC:
; H097+$000006EC: 0c3300012008  cmpi.b #$1, $8(a3, d2.w)
        cmpi.b #$1, $8(a3, d2.w)
L097_000006F2:
; H097+$000006F2: 6700004e  beq.w $742
        beq.w H097+$742
L097_000006F6:
; H097+$000006F6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_000006FA:
; H097+$000006FA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_000006FC:
; H097+$000006FC: e542  asl.w #$2, d2
        asl.w #$2, d2
L097_000006FE:
; H097+$000006FE: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L097_00000704:
; H097+$00000704: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000706:
; H097+$00000706: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_0000070A:
; H097+$0000070A: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_0000070C:
; H097+$0000070C: e544  asl.w #$2, d4
        asl.w #$2, d4
L097_0000070E:
; H097+$0000070E: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L097_00000714:
; H097+$00000714: 2f334000  move.l (a3, d4.w), -(a7)
        move.l (a3, d4.w), -(a7)
L097_00000718:
; H097+$00000718: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L097_0000071C:
; H097+$0000071C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_0000071E:
; H097+$0000071E: e942  asl.w #$4, d2
        asl.w #$4, d2
L097_00000720:
; H097+$00000720: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L097_00000726:
; H097+$00000726: 1f332009  move.b $9(a3, d2.w), -(a7)
        move.b $9(a3, d2.w), -(a7)
L097_0000072A:
; H097+$0000072A: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H062+$142C (sub_H062_0000142C)
L097_0000072E:
; H097+$0000072E: 4eb90000142c  jsr $142c.l
        jsr (H062+$142C).l
L097_00000734:
; H097+$00000734: 1400  move.b d0, d2
        move.b d0, d2
L097_00000736:
; H097+$00000736: 4a02  tst.b d2
        tst.b d2
L097_00000738:
; H097+$00000738: 66000008  bne.w $742
        bne.w H097+$742
L097_0000073C:
; H097+$0000073C: 7001  moveq #$1, d0
        moveq #1, d0
L097_0000073E:
; H097+$0000073E: 60000012  bra.w $752
        bra.w H097+$752
L097_00000742:
; H097+$00000742: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L097_00000746:
; H097+$00000746: 6400ff4a  bcc.w $692
        bcc.w H097+$692
L097_0000074A:
; H097+$0000074A: 548f  addq.l #$2, a7
        addq.l #$2, a7
L097_0000074C:
; H097+$0000074C: 7000  moveq #$0, d0
        moveq #0, d0
L097_0000074E:
; H097+$0000074E: 60000002  bra.w $752
        bra.w H097+$752
L097_00000752:
; H097+$00000752: 4e5d  unlk a5
        unlk a5
L097_00000754:
; H097+$00000754: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00000756:
; H097+$00000756: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L097_0000075A:
; H097+$0000075A: 4ed0  jmp (a0)
        jmp (a0)
L097_0000075C:
; H097+$0000075C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L097_00000760:
; H097+$00000760: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00000762:
; H097+$00000762: e942  asl.w #$4, d2
        asl.w #$4, d2
L097_00000764:
; H097+$00000764: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L097_0000076A:
; H097+$0000076A: 7800  moveq #$0, d4
        moveq #0, d4
L097_0000076C:
; H097+$0000076C: 1833200d  move.b $d(a3, d2.w), d4
        move.b $d(a3, d2.w), d4
L097_00000770:
; H097+$00000770: b86d000c  cmp.w $c(a5), d4
        cmp.w $c(a5), d4
L097_00000774:
; H097+$00000774: 65000110  bcs.w $886
        bcs.w H097+$886
L097_00000778:
; H097+$00000778: 0c6d0003000e  cmpi.w #$3, $e(a5)
        cmpi.w #$3, $e(a5)
L097_0000077E:
; H097+$0000077E: 67000018  beq.w $798
        beq.w H097+$798
L097_00000782:
; H097+$00000782: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L097_00000786:
; H097+$00000786: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00000788:
; H097+$00000788: e942  asl.w #$4, d2
        asl.w #$4, d2
L097_0000078A:
; H097+$0000078A: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L097_00000790:
; H097+$00000790: 4a33200e  tst.b $e(a3, d2.w)
        tst.b $e(a3, d2.w)
L097_00000794:
; H097+$00000794: 67000022  beq.w $7b8
        beq.w H097+$7B8
L097_00000798:
; H097+$00000798: 0c6d0003000e  cmpi.w #$3, $e(a5)
        cmpi.w #$3, $e(a5)
L097_0000079E:
; H097+$0000079E: 66000022  bne.w $7c2
        bne.w H097+$7C2
L097_000007A2:
; H097+$000007A2: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L097_000007A6:
; H097+$000007A6: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H096+$25DA (sub_H096_000025DA)
L097_000007AA:
; H097+$000007AA: 4eb9000025da  jsr $25da.l
        jsr (H096+$25DA).l
L097_000007B0:
; H097+$000007B0: 1400  move.b d0, d2
        move.b d0, d2
L097_000007B2:
; H097+$000007B2: 4a02  tst.b d2
        tst.b d2
L097_000007B4:
; H097+$000007B4: 6700000c  beq.w $7c2
        beq.w H097+$7C2
L097_000007B8:
; H097+$000007B8: 7001  moveq #$1, d0
        moveq #1, d0
L097_000007BA:
; H097+$000007BA: 600000ca  bra.w $886
        bra.w H097+$886
; Preserved bytes H097+$000007BE..$000007C2; code/data not fully classified.
        dc.w $6000,$00C6
L097_000007C2:
; H097+$000007C2: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L097_000007C6:
; H097+$000007C6: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
; -> H033+$11FC (sub_H033_000011FC)
L097_000007CA:
; H097+$000007CA: 4eb9000011fc  jsr $11fc.l
        jsr (H033+$11FC).l
L097_000007D0:
; H097+$000007D0: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
; -> H063+$2BDE (sub_H063_00002BDE)
L097_000007D2:
; H097+$000007D2: 4eb900002bde  jsr $2bde.l
        jsr (H063+$2BDE).l
L097_000007D8:
; H097+$000007D8: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L097_000007DC:
; H097+$000007DC: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L097_000007E0:
; H097+$000007E0: 630000a4  bls.w $886
        bls.w H097+$886
L097_000007E4:
; H097+$000007E4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L097_000007E8:
; H097+$000007E8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_000007EA:
; H097+$000007EA: e942  asl.w #$4, d2
        asl.w #$4, d2
L097_000007EC:
; H097+$000007EC: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L097_000007F2:
; H097+$000007F2: 7800  moveq #$0, d4
        moveq #0, d4
L097_000007F4:
; H097+$000007F4: 1833200f  move.b $f(a3, d2.w), d4
        move.b $f(a3, d2.w), d4
L097_000007F8:
; H097+$000007F8: 4a44  tst.w d4
        tst.w d4
L097_000007FA:
; H097+$000007FA: 6600000c  bne.w $808
        bne.w H097+$808
L097_000007FE:
; H097+$000007FE: 7001  moveq #$1, d0
        moveq #1, d0
L097_00000800:
; H097+$00000800: 60000084  bra.w $886
        bra.w H097+$886
; Preserved bytes H097+$00000804..$00000808; code/data not fully classified.
        dc.w $6000,$0080
L097_00000808:
; H097+$00000808: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L097_0000080E:
; H097+$0000080E: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L097_00000812:
; H097+$00000812: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L097_00000816:
; H097+$00000816: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L097_00000818:
; H097+$00000818: 62000064  bhi.w $87e
        bhi.w H097+$87E
L097_0000081C:
; H097+$0000081C: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L097_00000820:
; H097+$00000820: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00000822:
; H097+$00000822: 47f900002444  lea.l $2444.l, a3
        lea.l (H005+$2444).l, a3
L097_00000828:
; H097+$00000828: 7800  moveq #$0, d4
        moveq #0, d4
L097_0000082A:
; H097+$0000082A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_0000082E:
; H097+$0000082E: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_00000830:
; H097+$00000830: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L097_00000834:
; H097+$00000834: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L097_0000083A:
; H097+$0000083A: 3f334800  move.w (a3, d4.l), -(a7)
        move.w (a3, d4.l), -(a7)
L097_0000083E:
; H097+$0000083E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L097_00000842:
; H097+$00000842: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00000844:
; H097+$00000844: 47f900002444  lea.l $2444.l, a3
        lea.l (H005+$2444).l, a3
L097_0000084A:
; H097+$0000084A: 7800  moveq #$0, d4
        moveq #0, d4
L097_0000084C:
; H097+$0000084C: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_00000850:
; H097+$00000850: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_00000852:
; H097+$00000852: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L097_00000856:
; H097+$00000856: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L097_0000085C:
; H097+$0000085C: 3f334802  move.w $2(a3, d4.l), -(a7)
        move.w $2(a3, d4.l), -(a7)
L097_00000860:
; H097+$00000860: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L097_00000864:
; H097+$00000864: 4855  pea.l (a5)
        pea.l (a5)
L097_00000866:
; H097+$00000866: 6100fdc6  bsr.w $62e
        bsr.w H097+$62E
L097_0000086A:
; H097+$0000086A: 1400  move.b d0, d2
        move.b d0, d2
L097_0000086C:
; H097+$0000086C: 4a02  tst.b d2
        tst.b d2
L097_0000086E:
; H097+$0000086E: 67000008  beq.w $878
        beq.w H097+$878
L097_00000872:
; H097+$00000872: 7000  moveq #$0, d0
        moveq #0, d0
L097_00000874:
; H097+$00000874: 60000010  bra.w $886
        bra.w H097+$886
L097_00000878:
; H097+$00000878: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L097_0000087C:
; H097+$0000087C: 6494  bcc.b $812
        bcc.b H097+$812
L097_0000087E:
; H097+$0000087E: 548f  addq.l #$2, a7
        addq.l #$2, a7
L097_00000880:
; H097+$00000880: 7001  moveq #$1, d0
        moveq #1, d0
L097_00000882:
; H097+$00000882: 60000002  bra.w $886
        bra.w H097+$886
L097_00000886:
; H097+$00000886: 4e5d  unlk a5
        unlk a5
L097_00000888:
; H097+$00000888: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_0000088A:
; H097+$0000088A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_0000088C:
; H097+$0000088C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L097_0000088E:
; H097+$0000088E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_00000890 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H062+$156C, H063+$2B4C, H033+$17E6, H065+$2F82.
;   - Calls H062+$156C.
;   - Calls H063+$2B4C.
;   - Calls H033+$17E6.
;   - Calls H065+$2F82.
;   - Uses the global state: H005+$3E04 (pointer to persistent state A, 2048 bytes).
; Direct callers: H097+$1E92
; --------------------------------------------------------------------------
L097_00000890:
; H097+$00000890: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_00000892:
; H097+$00000892: 287af80a  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00000896:
; H097+$00000896: 4e55ffe4  link.w a5, #$ffe4
        link.w a5, #$ffe4
L097_0000089A:
; H097+$0000089A: 42adffe6  clr.l -$1a(a5)
        clr.l -$1a(a5)
L097_0000089E:
; H097+$0000089E: 3b7c0007fffe  move.w #$7, -$2(a5)
        move.w #$7, -$2(a5)
L097_000008A4:
; H097+$000008A4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_000008A8:
; H097+$000008A8: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_000008AC:
; H097+$000008AC: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_000008B2:
; H097+$000008B2: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L097_000008B6:
; H097+$000008B6: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000008BA:
; H097+$000008BA: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000008BE:
; H097+$000008BE: 4a2b0002  tst.b $2(a3)
        tst.b $2(a3)
L097_000008C2:
; H097+$000008C2: 67000114  beq.w $9d8
        beq.w H097+$9D8
L097_000008C6:
; H097+$000008C6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2B4C (trampoline_H063_2B72)
L097_000008CA:
; H097+$000008CA: 4eb900002b4c  jsr $2b4c.l
        jsr (H063+$2B4C).l
L097_000008D0:
; H097+$000008D0: 1400  move.b d0, d2
        move.b d0, d2
L097_000008D2:
; H097+$000008D2: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L097_000008D6:
; H097+$000008D6: 47f900002a1c  lea.l $2a1c.l, a3
        lea.l (H005+$2A1C).l, a3
L097_000008DC:
; H097+$000008DC: 7800  moveq #$0, d4
        moveq #0, d4
L097_000008DE:
; H097+$000008DE: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_000008E2:
; H097+$000008E2: 4a44  tst.w d4
        tst.w d4
L097_000008E4:
; H097+$000008E4: 630000f2  bls.w $9d8
        bls.w H097+$9D8
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L097_000008E8:
; H097+$000008E8: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L097_000008EE:
; H097+$000008EE: 4a6b01ca  tst.w $1ca(a3)
        tst.w $1ca(a3)
L097_000008F2:
; H097+$000008F2: 660000e4  bne.w $9d8
        bne.w H097+$9D8
L097_000008F6:
; H097+$000008F6: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L097_000008FC:
; H097+$000008FC: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L097_00000900:
; H097+$00000900: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L097_00000904:
; H097+$00000904: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L097_00000906:
; H097+$00000906: 620000ce  bhi.w $9d6
        bhi.w H097+$9D6
L097_0000090A:
; H097+$0000090A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000090E:
; H097+$0000090E: 2b6b0150ffea  move.l $150(a3), -$16(a5)
        move.l $150(a3), -$16(a5)
L097_00000914:
; H097+$00000914: 4aadffea  tst.l -$16(a5)
        tst.l -$16(a5)
L097_00000918:
; H097+$00000918: 670000b0  beq.w $9ca
        beq.w H097+$9CA
L097_0000091C:
; H097+$0000091C: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L097_00000920:
; H097+$00000920: 660000a8  bne.w $9ca
        bne.w H097+$9CA
L097_00000924:
; H097+$00000924: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000926:
; H097+$00000926: 266dffea  movea.l -$16(a5), a3
        movea.l -$16(a5), a3
L097_0000092A:
; H097+$0000092A: 142b0045  move.b $45(a3), d2
        move.b $45(a3), d2
L097_0000092E:
; H097+$0000092E: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L097_00000932:
; H097+$00000932: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000934:
; H097+$00000934: 266dffea  movea.l -$16(a5), a3
        movea.l -$16(a5), a3
L097_00000938:
; H097+$00000938: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_0000093C:
; H097+$0000093C: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000940:
; H097+$00000940: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000946:
; H097+$00000946: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000948:
; H097+$00000948: 18332800  move.b (a3, d2.l), d4
        move.b (a3, d2.l), d4
L097_0000094C:
; H097+$0000094C: 3b44fff4  move.w d4, -$c(a5)
        move.w d4, -$c(a5)
L097_00000950:
; H097+$00000950: 2f2dffea  move.l -$16(a5), -(a7)
        move.l -$16(a5), -(a7)
; -> H033+$17E6 (sub_H033_000017E6)
L097_00000954:
; H097+$00000954: 4eb9000017e6  jsr $17e6.l
        jsr (H033+$17E6).l
L097_0000095A:
; H097+$0000095A: 1400  move.b d0, d2
        move.b d0, d2
L097_0000095C:
; H097+$0000095C: 4a02  tst.b d2
        tst.b d2
L097_0000095E:
; H097+$0000095E: 6600005c  bne.w $9bc
        bne.w H097+$9BC
L097_00000962:
; H097+$00000962: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000964:
; H097+$00000964: 266dffea  movea.l -$16(a5), a3
        movea.l -$16(a5), a3
L097_00000968:
; H097+$00000968: 142b0046  move.b $46(a3), d2
        move.b $46(a3), d2
L097_0000096C:
; H097+$0000096C: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L097_00000970:
; H097+$00000970: 6400004a  bcc.w $9bc
        bcc.w H097+$9BC
L097_00000974:
; H097+$00000974: 266dffea  movea.l -$16(a5), a3
        movea.l -$16(a5), a3
L097_00000978:
; H097+$00000978: 4a2b003a  tst.b $3a(a3)
        tst.b $3a(a3)
L097_0000097C:
; H097+$0000097C: 6700003e  beq.w $9bc
        beq.w H097+$9BC
L097_00000980:
; H097+$00000980: 4a6dfff2  tst.w -$e(a5)
        tst.w -$e(a5)
L097_00000984:
; H097+$00000984: 63000036  bls.w $9bc
        bls.w H097+$9BC
L097_00000988:
; H097+$00000988: 0c6d0038fff2  cmpi.w #$38, -$e(a5)
        cmpi.w #$38, -$e(a5)
L097_0000098E:
; H097+$0000098E: 6300000e  bls.w $99e
        bls.w H097+$99E
L097_00000992:
; H097+$00000992: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L097_00000996:
; H097+$00000996: 04420017  subi.w #$17, d2
        subi.w #$17, d2
L097_0000099A:
; H097+$0000099A: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L097_0000099E:
; H097+$0000099E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000009A2:
; H097+$000009A2: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L097_000009A6:
; H097+$000009A6: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L097_000009AA:
; H097+$000009AA: 6100fc74  bsr.w $620
        bsr.w H097+$620
L097_000009AE:
; H097+$000009AE: 1400  move.b d0, d2
        move.b d0, d2
L097_000009B0:
; H097+$000009B0: 4a02  tst.b d2
        tst.b d2
L097_000009B2:
; H097+$000009B2: 67000008  beq.w $9bc
        beq.w H097+$9BC
L097_000009B6:
; H097+$000009B6: 2b6dffeaffe6  move.l -$16(a5), -$1a(a5)
        move.l -$16(a5), -$1a(a5)
L097_000009BC:
; H097+$000009BC: 266dffea  movea.l -$16(a5), a3
        movea.l -$16(a5), a3
L097_000009C0:
; H097+$000009C0: 2b6b002cffea  move.l $2c(a3), -$16(a5)
        move.l $2c(a3), -$16(a5)
L097_000009C6:
; H097+$000009C6: 6000ff4c  bra.w $914
        bra.w H097+$914
L097_000009CA:
; H097+$000009CA: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L097_000009CE:
; H097+$000009CE: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L097_000009D2:
; H097+$000009D2: 6400ff2c  bcc.w $900
        bcc.w H097+$900
L097_000009D6:
; H097+$000009D6: 548f  addq.l #$2, a7
        addq.l #$2, a7
L097_000009D8:
; H097+$000009D8: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L097_000009DC:
; H097+$000009DC: 67000016  beq.w $9f4
        beq.w H097+$9F4
L097_000009E0:
; H097+$000009E0: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
L097_000009E4:
; H097+$000009E4: 486dffe5  pea.l -$1b(a5)
        pea.l -$1b(a5)
; -> H065+$2F82 (sub_H065_00002F82)
L097_000009E8:
; H097+$000009E8: 4eb900002f82  jsr $2f82.l
        jsr (H065+$2F82).l
L097_000009EE:
; H097+$000009EE: 7001  moveq #$1, d0
        moveq #1, d0
L097_000009F0:
; H097+$000009F0: 60000008  bra.w $9fa
        bra.w H097+$9FA
L097_000009F4:
; H097+$000009F4: 7000  moveq #$0, d0
        moveq #0, d0
L097_000009F6:
; H097+$000009F6: 60000002  bra.w $9fa
        bra.w H097+$9FA
L097_000009FA:
; H097+$000009FA: 4e5d  unlk a5
        unlk a5
L097_000009FC:
; H097+$000009FC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_000009FE:
; H097+$000009FE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00000A00:
; H097+$00000A00: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_00000A02:
; H097+$00000A02: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_00000A04 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H096+$1B04, H096+$160A.
;   - Calls H096+$1B04.
;   - Calls H096+$160A.
; Direct callers: H097+$1EF8
; --------------------------------------------------------------------------
L097_00000A04:
; H097+$00000A04: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_00000A06:
; H097+$00000A06: 287af696  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00000A0A:
; H097+$00000A0A: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L097_00000A0E:
; H097+$00000A0E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000A12:
; H097+$00000A12: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000A16:
; H097+$00000A16: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000A18:
; H097+$00000A18: 142b0013  move.b $13(a3), d2
        move.b $13(a3), d2
L097_00000A1C:
; H097+$00000A1C: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000A1E:
; H097+$00000A1E: 18390000248f  move.b $248f.l, d4
        move.b (H005+$248F).l, d4
L097_00000A24:
; H097+$00000A24: b444  cmp.w d4, d2
        cmp.w d4, d2
L097_00000A26:
; H097+$00000A26: 64000050  bcc.w $a78
        bcc.w H097+$A78
L097_00000A2A:
; H097+$00000A2A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000A2E:
; H097+$00000A2E: 4a2b00fe  tst.b $fe(a3)
        tst.b $fe(a3)
L097_00000A32:
; H097+$00000A32: 62000016  bhi.w $a4a
        bhi.w H097+$A4A
L097_00000A36:
; H097+$00000A36: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000A3A:
; H097+$00000A3A: 142b0106  move.b $106(a3), d2
        move.b $106(a3), d2
L097_00000A3E:
; H097+$00000A3E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000A42:
; H097+$00000A42: b42b00dc  cmp.b $dc(a3), d2
        cmp.b $dc(a3), d2
L097_00000A46:
; H097+$00000A46: 63000030  bls.w $a78
        bls.w H097+$A78
L097_00000A4A:
; H097+$00000A4A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00000A4E:
; H097+$00000A4E: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
L097_00000A52:
; H097+$00000A52: 486dfffb  pea.l -$5(a5)
        pea.l -$5(a5)
; -> H096+$1B04 (sub_H096_00001B04)
L097_00000A56:
; H097+$00000A56: 4eb900001b04  jsr $1b04.l
        jsr (H096+$1B04).l
L097_00000A5C:
; H097+$00000A5C: 1400  move.b d0, d2
        move.b d0, d2
L097_00000A5E:
; H097+$00000A5E: 4a02  tst.b d2
        tst.b d2
L097_00000A60:
; H097+$00000A60: 67000016  beq.w $a78
        beq.w H097+$A78
L097_00000A64:
; H097+$00000A64: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H096+$160A (sub_H096_0000160A)
L097_00000A68:
; H097+$00000A68: 4eb90000160a  jsr $160a.l
        jsr (H096+$160A).l
L097_00000A6E:
; H097+$00000A6E: 7001  moveq #$1, d0
        moveq #1, d0
L097_00000A70:
; H097+$00000A70: 6000000c  bra.w $a7e
        bra.w H097+$A7E
; Preserved bytes H097+$00000A74..$00000A78; code/data not fully classified.
        dc.w $6000,$0008
L097_00000A78:
; H097+$00000A78: 7000  moveq #$0, d0
        moveq #0, d0
L097_00000A7A:
; H097+$00000A7A: 60000002  bra.w $a7e
        bra.w H097+$A7E
L097_00000A7E:
; H097+$00000A7E: 4e5d  unlk a5
        unlk a5
L097_00000A80:
; H097+$00000A80: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_00000A82:
; H097+$00000A82: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00000A84:
; H097+$00000A84: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_00000A86:
; H097+$00000A86: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_00000A88 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H062+$156C, H063+$2B4C, H096+$3100.
;   - Calls H062+$156C.
;   - Calls H063+$2B4C.
;   - Calls H096+$3100.
; Direct callers: H097+$1F1A
; --------------------------------------------------------------------------
L097_00000A88:
; H097+$00000A88: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_00000A8A:
; H097+$00000A8A: 287af612  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00000A8E:
; H097+$00000A8E: 4e55ff76  link.w a5, #$ff76
        link.w a5, #$ff76
L097_00000A92:
; H097+$00000A92: 426dff7c  clr.w -$84(a5)
        clr.w -$84(a5)
L097_00000A96:
; H097+$00000A96: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000A9A:
; H097+$00000A9A: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00000A9E:
; H097+$00000A9E: 4a2b0001  tst.b $1(a3)
        tst.b $1(a3)
L097_00000AA2:
; H097+$00000AA2: 67000054  beq.w $af8
        beq.w H097+$AF8
L097_00000AA6:
; H097+$00000AA6: 3b7c0001ff7a  move.w #$1, -$86(a5)
        move.w #$1, -$86(a5)
L097_00000AAC:
; H097+$00000AAC: 0c6d0039ff7a  cmpi.w #$39, -$86(a5)
        cmpi.w #$39, -$86(a5)
L097_00000AB2:
; H097+$00000AB2: 62000044  bhi.w $af8
        bhi.w H097+$AF8
L097_00000AB6:
; H097+$00000AB6: 342dff7a  move.w -$86(a5), d2
        move.w -$86(a5), d2
L097_00000ABA:
; H097+$00000ABA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000ABE:
; H097+$00000ABE: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L097_00000AC2:
; H097+$00000AC2: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000AC4:
; H097+$00000AC4: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_00000AC8:
; H097+$00000AC8: 4a44  tst.w d4
        tst.w d4
L097_00000ACA:
; H097+$00000ACA: 63000026  bls.w $af2
        bls.w H097+$AF2
L097_00000ACE:
; H097+$00000ACE: 342dff7c  move.w -$84(a5), d2
        move.w -$84(a5), d2
L097_00000AD2:
; H097+$00000AD2: e342  asl.w #$1, d2
        asl.w #$1, d2
L097_00000AD4:
; H097+$00000AD4: 47edff8c  lea.l -$74(a5), a3
        lea.l -$74(a5), a3
L097_00000AD8:
; H097+$00000AD8: 382dff7a  move.w -$86(a5), d4
        move.w -$86(a5), d4
L097_00000ADC:
; H097+$00000ADC: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000AE0:
; H097+$00000AE0: 45ea001e  lea.l $1e(a2), a2
        lea.l $1e(a2), a2
L097_00000AE4:
; H097+$00000AE4: 7c00  moveq #$0, d6
        moveq #0, d6
L097_00000AE6:
; H097+$00000AE6: 1c324000  move.b (a2, d4.w), d6
        move.b (a2, d4.w), d6
L097_00000AEA:
; H097+$00000AEA: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L097_00000AEE:
; H097+$00000AEE: 526dff7c  addq.w #$1, -$84(a5)
        addq.w #$1, -$84(a5)
L097_00000AF2:
; H097+$00000AF2: 526dff7a  addq.w #$1, -$86(a5)
        addq.w #$1, -$86(a5)
L097_00000AF6:
; H097+$00000AF6: 64b4  bcc.b $aac
        bcc.b H097+$AAC
L097_00000AF8:
; H097+$00000AF8: 426dff76  clr.w -$8a(a5)
        clr.w -$8a(a5)
L097_00000AFC:
; H097+$00000AFC: 3b7c0007ff86  move.w #$7, -$7a(a5)
        move.w #$7, -$7a(a5)
L097_00000B02:
; H097+$00000B02: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00000B06:
; H097+$00000B06: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00000B0A:
; H097+$00000B0A: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_00000B10:
; H097+$00000B10: 3b40ff84  move.w d0, -$7c(a5)
        move.w d0, -$7c(a5)
L097_00000B14:
; H097+$00000B14: 3b7c0001ff80  move.w #$1, -$80(a5)
        move.w #$1, -$80(a5)
L097_00000B1A:
; H097+$00000B1A: 4a6dff7c  tst.w -$84(a5)
        tst.w -$84(a5)
L097_00000B1E:
; H097+$00000B1E: 630000c0  bls.w $be0
        bls.w H097+$BE0
L097_00000B22:
; H097+$00000B22: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000B24:
; H097+$00000B24: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000B28:
; H097+$00000B28: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L097_00000B2C:
; H097+$00000B2C: 0c42007f  cmpi.w #$7f, d2
        cmpi.w #$7f, d2
L097_00000B30:
; H097+$00000B30: 6200000c  bhi.w $b3e
        bhi.w H097+$B3E
L097_00000B34:
; H097+$00000B34: 4a39000024a0  tst.b $24a0.l
        tst.b (H005+$24A0).l
L097_00000B3A:
; H097+$00000B3A: 670000a4  beq.w $be0
        beq.w H097+$BE0
L097_00000B3E:
; H097+$00000B3E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2B4C (trampoline_H063_2B72)
L097_00000B42:
; H097+$00000B42: 4eb900002b4c  jsr $2b4c.l
        jsr (H063+$2B4C).l
L097_00000B48:
; H097+$00000B48: 1400  move.b d0, d2
        move.b d0, d2
L097_00000B4A:
; H097+$00000B4A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L097_00000B4E:
; H097+$00000B4E: 47f900002a1c  lea.l $2a1c.l, a3
        lea.l (H005+$2A1C).l, a3
L097_00000B54:
; H097+$00000B54: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000B56:
; H097+$00000B56: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_00000B5A:
; H097+$00000B5A: 4a44  tst.w d4
        tst.w d4
L097_00000B5C:
; H097+$00000B5C: 63000082  bls.w $be0
        bls.w H097+$BE0
L097_00000B60:
; H097+$00000B60: 342dff80  move.w -$80(a5), d2
        move.w -$80(a5), d2
L097_00000B64:
; H097+$00000B64: b46dff84  cmp.w -$7c(a5), d2
        cmp.w -$7c(a5), d2
L097_00000B68:
; H097+$00000B68: 62000076  bhi.w $be0
        bhi.w H097+$BE0
L097_00000B6C:
; H097+$00000B6C: 4a6dff76  tst.w -$8a(a5)
        tst.w -$8a(a5)
L097_00000B70:
; H097+$00000B70: 6600006e  bne.w $be0
        bne.w H097+$BE0
L097_00000B74:
; H097+$00000B74: 3b7c0001ff7e  move.w #$1, -$82(a5)
        move.w #$1, -$82(a5)
L097_00000B7A:
; H097+$00000B7A: 0c6d0004ff7e  cmpi.w #$4, -$82(a5)
        cmpi.w #$4, -$82(a5)
L097_00000B80:
; H097+$00000B80: 64000054  bcc.w $bd6
        bcc.w H097+$BD6
L097_00000B84:
; H097+$00000B84: 4a6dff76  tst.w -$8a(a5)
        tst.w -$8a(a5)
L097_00000B88:
; H097+$00000B88: 6600004c  bne.w $bd6
        bne.w H097+$BD6
L097_00000B8C:
; H097+$00000B8C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00000B90:
; H097+$00000B90: 3f2dff7c  move.w -$84(a5), -(a7)
        move.w -$84(a5), -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00000B94:
; H097+$00000B94: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_00000B9A:
; H097+$00000B9A: 3400  move.w d0, d2
        move.w d0, d2
L097_00000B9C:
; H097+$00000B9C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00000B9E:
; H097+$00000B9E: 3b42ff7a  move.w d2, -$86(a5)
        move.w d2, -$86(a5)
L097_00000BA2:
; H097+$00000BA2: 342dff7a  move.w -$86(a5), d2
        move.w -$86(a5), d2
L097_00000BA6:
; H097+$00000BA6: e342  asl.w #$1, d2
        asl.w #$1, d2
L097_00000BA8:
; H097+$00000BA8: 47edff8c  lea.l -$74(a5), a3
        lea.l -$74(a5), a3
L097_00000BAC:
; H097+$00000BAC: 3b732000ff78  move.w (a3, d2.w), -$88(a5)
        move.w (a3, d2.w), -$88(a5)
L097_00000BB2:
; H097+$00000BB2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00000BB6:
; H097+$00000BB6: 3f2dff78  move.w -$88(a5), -(a7)
        move.w -$88(a5), -(a7)
L097_00000BBA:
; H097+$00000BBA: 3f2dff86  move.w -$7a(a5), -(a7)
        move.w -$7a(a5), -(a7)
L097_00000BBE:
; H097+$00000BBE: 6100fa60  bsr.w $620
        bsr.w H097+$620
L097_00000BC2:
; H097+$00000BC2: 1400  move.b d0, d2
        move.b d0, d2
L097_00000BC4:
; H097+$00000BC4: 4a02  tst.b d2
        tst.b d2
L097_00000BC6:
; H097+$00000BC6: 67000008  beq.w $bd0
        beq.w H097+$BD0
L097_00000BCA:
; H097+$00000BCA: 3b6dff78ff76  move.w -$88(a5), -$8a(a5)
        move.w -$88(a5), -$8a(a5)
L097_00000BD0:
; H097+$00000BD0: 526dff7e  addq.w #$1, -$82(a5)
        addq.w #$1, -$82(a5)
L097_00000BD4:
; H097+$00000BD4: 60a4  bra.b $b7a
        bra.b H097+$B7A
L097_00000BD6:
; H097+$00000BD6: 536dff86  subq.w #$1, -$7a(a5)
        subq.w #$1, -$7a(a5)
L097_00000BDA:
; H097+$00000BDA: 526dff80  addq.w #$1, -$80(a5)
        addq.w #$1, -$80(a5)
L097_00000BDE:
; H097+$00000BDE: 6080  bra.b $b60
        bra.b H097+$B60
L097_00000BE0:
; H097+$00000BE0: 4a6dff76  tst.w -$8a(a5)
        tst.w -$8a(a5)
L097_00000BE4:
; H097+$00000BE4: 63000018  bls.w $bfe
        bls.w H097+$BFE
L097_00000BE8:
; H097+$00000BE8: 3f2dff76  move.w -$8a(a5), -(a7)
        move.w -$8a(a5), -(a7)
L097_00000BEC:
; H097+$00000BEC: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L097_00000BF0:
; H097+$00000BF0: 486dff83  pea.l -$7d(a5)
        pea.l -$7d(a5)
; -> H096+$3100 (sub_H096_00003100)
L097_00000BF4:
; H097+$00000BF4: 4eb900003100  jsr $3100.l
        jsr (H096+$3100).l
L097_00000BFA:
; H097+$00000BFA: 60000006  bra.w $c02
        bra.w H097+$C02
L097_00000BFE:
; H097+$00000BFE: 422dff83  clr.b -$7d(a5)
        clr.b -$7d(a5)
L097_00000C02:
; H097+$00000C02: 102dff83  move.b -$7d(a5), d0
        move.b -$7d(a5), d0
L097_00000C06:
; H097+$00000C06: 60000002  bra.w $c0a
        bra.w H097+$C0A
L097_00000C0A:
; H097+$00000C0A: 4e5d  unlk a5
        unlk a5
L097_00000C0C:
; H097+$00000C0C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_00000C0E:
; H097+$00000C0E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00000C10:
; H097+$00000C10: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_00000C12:
; H097+$00000C12: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_00000C14 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H029+$0354, H063+$2BDE, H065+$2C04, H063+$13BE.
;   - Calls H029+$0354.
;   - Calls H063+$2BDE.
;   - Calls H065+$2C04.
;   - Calls H063+$13BE.
;   - Calls H096+$11D4.
;   - Calls H063+$1160.
; Direct callers: H097+$1F34, H097+$1BEE
; --------------------------------------------------------------------------
L097_00000C14:
; H097+$00000C14: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_00000C16:
; H097+$00000C16: 287af486  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00000C1A:
; H097+$00000C1A: 4e55ffda  link.w a5, #$ffda
        link.w a5, #$ffda
L097_00000C1E:
; H097+$00000C1E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000C22:
; H097+$00000C22: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L097_00000C26:
; H097+$00000C26: 67000034  beq.w $c5c
        beq.w H097+$C5C
L097_00000C2A:
; H097+$00000C2A: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000C2C:
; H097+$00000C2C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000C30:
; H097+$00000C30: 142b0188  move.b $188(a3), d2
        move.b $188(a3), d2
L097_00000C34:
; H097+$00000C34: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000C38:
; H097+$00000C38: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L097_00000C3C:
; H097+$00000C3C: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000C3E:
; H097+$00000C3E: 182b0030  move.b $30(a3), d4
        move.b $30(a3), d4
L097_00000C42:
; H097+$00000C42: c9fc0012  muls.w #$12, d4
        muls.w #$12, d4
L097_00000C46:
; H097+$00000C46: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000C4C:
; H097+$00000C4C: 7c00  moveq #$0, d6
        moveq #0, d6
L097_00000C4E:
; H097+$00000C4E: 1c334801  move.b $1(a3, d4.l), d6
        move.b $1(a3, d4.l), d6
L097_00000C52:
; H097+$00000C52: 9446  sub.w d6, d2
        sub.w d6, d2
L097_00000C54:
; H097+$00000C54: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000C58:
; H097+$00000C58: 17420188  move.b d2, $188(a3)
        move.b d2, $188(a3)
L097_00000C5C:
; H097+$00000C5C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000C60:
; H097+$00000C60: 4aab0158  tst.l $158(a3)
        tst.l $158(a3)
L097_00000C64:
; H097+$00000C64: 67000034  beq.w $c9a
        beq.w H097+$C9A
L097_00000C68:
; H097+$00000C68: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000C6A:
; H097+$00000C6A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000C6E:
; H097+$00000C6E: 142b0188  move.b $188(a3), d2
        move.b $188(a3), d2
L097_00000C72:
; H097+$00000C72: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00000C76:
; H097+$00000C76: 266a0158  movea.l $158(a2), a3
        movea.l $158(a2), a3
L097_00000C7A:
; H097+$00000C7A: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000C7C:
; H097+$00000C7C: 182b0030  move.b $30(a3), d4
        move.b $30(a3), d4
L097_00000C80:
; H097+$00000C80: c9fc0012  muls.w #$12, d4
        muls.w #$12, d4
L097_00000C84:
; H097+$00000C84: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000C8A:
; H097+$00000C8A: 7c00  moveq #$0, d6
        moveq #0, d6
L097_00000C8C:
; H097+$00000C8C: 1c334801  move.b $1(a3, d4.l), d6
        move.b $1(a3, d4.l), d6
L097_00000C90:
; H097+$00000C90: 9446  sub.w d6, d2
        sub.w d6, d2
L097_00000C92:
; H097+$00000C92: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000C96:
; H097+$00000C96: 17420188  move.b d2, $188(a3)
        move.b d2, $188(a3)
L097_00000C9A:
; H097+$00000C9A: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L097_00000C9E:
; H097+$00000C9E: 42adfff8  clr.l -$8(a5)
        clr.l -$8(a5)
L097_00000CA2:
; H097+$00000CA2: 42adfff4  clr.l -$c(a5)
        clr.l -$c(a5)
L097_00000CA6:
; H097+$00000CA6: 3b7c0001ffea  move.w #$1, -$16(a5)
        move.w #$1, -$16(a5)
L097_00000CAC:
; H097+$00000CAC: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000CAE:
; H097+$00000CAE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000CB2:
; H097+$00000CB2: 142b0114  move.b $114(a3), d2
        move.b $114(a3), d2
L097_00000CB6:
; H097+$00000CB6: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000CB8:
; H097+$00000CB8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000CBC:
; H097+$00000CBC: 182b0112  move.b $112(a3), d4
        move.b $112(a3), d4
L097_00000CC0:
; H097+$00000CC0: c4c4  mulu.w d4, d2
        mulu.w d4, d2
L097_00000CC2:
; H097+$00000CC2: 3b42ffe8  move.w d2, -$18(a5)
        move.w d2, -$18(a5)
L097_00000CC6:
; H097+$00000CC6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000CCA:
; H097+$00000CCA: 4a6b0116  tst.w $116(a3)
        tst.w $116(a3)
L097_00000CCE:
; H097+$00000CCE: 6f000014  ble.w $ce4
        ble.w H097+$CE4
L097_00000CD2:
; H097+$00000CD2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000CD6:
; H097+$00000CD6: 342b0116  move.w $116(a3), d2
        move.w $116(a3), d2
L097_00000CDA:
; H097+$00000CDA: e342  asl.w #$1, d2
        asl.w #$1, d2
L097_00000CDC:
; H097+$00000CDC: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L097_00000CE0:
; H097+$00000CE0: 3b42ffe8  move.w d2, -$18(a5)
        move.w d2, -$18(a5)
L097_00000CE4:
; H097+$00000CE4: 426dffe6  clr.w -$1a(a5)
        clr.w -$1a(a5)
L097_00000CE8:
; H097+$00000CE8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000CEC:
; H097+$00000CEC: 2b6b0150fff0  move.l $150(a3), -$10(a5)
        move.l $150(a3), -$10(a5)
L097_00000CF2:
; H097+$00000CF2: 4aadfff0  tst.l -$10(a5)
        tst.l -$10(a5)
L097_00000CF6:
; H097+$00000CF6: 6700018e  beq.w $e86
        beq.w H097+$E86
L097_00000CFA:
; H097+$00000CFA: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000CFC:
; H097+$00000CFC: 266dfff0  movea.l -$10(a5), a3
        movea.l -$10(a5), a3
L097_00000D00:
; H097+$00000D00: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_00000D04:
; H097+$00000D04: 3b42ffe2  move.w d2, -$1e(a5)
        move.w d2, -$1e(a5)
L097_00000D08:
; H097+$00000D08: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L097_00000D0C:
; H097+$00000D0C: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000D10:
; H097+$00000D10: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000D16:
; H097+$00000D16: 4a332800  tst.b (a3, d2.l)
        tst.b (a3, d2.l)
L097_00000D1A:
; H097+$00000D1A: 660000da  bne.w $df6
        bne.w H097+$DF6
L097_00000D1E:
; H097+$00000D1E: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L097_00000D22:
; H097+$00000D22: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000D26:
; H097+$00000D26: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000D2C:
; H097+$00000D2C: 1f33280f  move.b $f(a3, d2.l), -(a7)
        move.b $f(a3, d2.l), -(a7)
L097_00000D30:
; H097+$00000D30: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000D32:
; H097+$00000D32: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000D36:
; H097+$00000D36: 142b0122  move.b $122(a3), d2
        move.b $122(a3), d2
L097_00000D3A:
; H097+$00000D3A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000D3C:
; H097+$00000D3C: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000D42:
; H097+$00000D42: 1400  move.b d0, d2
        move.b d0, d2
L097_00000D44:
; H097+$00000D44: 4a02  tst.b d2
        tst.b d2
L097_00000D46:
; H097+$00000D46: 670000ae  beq.w $df6
        beq.w H097+$DF6
L097_00000D4A:
; H097+$00000D4A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00000D4E:
; H097+$00000D4E: 2f2dfff0  move.l -$10(a5), -(a7)
        move.l -$10(a5), -(a7)
L097_00000D52:
; H097+$00000D52: 6100f55e  bsr.w $2b2
        bsr.w H097+$2B2
L097_00000D56:
; H097+$00000D56: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L097_00000D5A:
; H097+$00000D5A: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L097_00000D5E:
; H097+$00000D5E: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000D62:
; H097+$00000D62: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000D68:
; H097+$00000D68: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L097_00000D6C:
; H097+$00000D6C: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000D70:
; H097+$00000D70: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000D76:
; H097+$00000D76: 1400  move.b d0, d2
        move.b d0, d2
L097_00000D78:
; H097+$00000D78: 4a02  tst.b d2
        tst.b d2
L097_00000D7A:
; H097+$00000D7A: 66000026  bne.w $da2
        bne.w H097+$DA2
L097_00000D7E:
; H097+$00000D7E: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L097_00000D82:
; H097+$00000D82: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000D86:
; H097+$00000D86: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000D8C:
; H097+$00000D8C: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L097_00000D90:
; H097+$00000D90: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000D94:
; H097+$00000D94: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000D9A:
; H097+$00000D9A: 1400  move.b d0, d2
        move.b d0, d2
L097_00000D9C:
; H097+$00000D9C: 4a02  tst.b d2
        tst.b d2
L097_00000D9E:
; H097+$00000D9E: 6700001a  beq.w $dba
        beq.w H097+$DBA
L097_00000DA2:
; H097+$00000DA2: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L097_00000DA6:
; H097+$00000DA6: b46dffea  cmp.w -$16(a5), d2
        cmp.w -$16(a5), d2
L097_00000DAA:
; H097+$00000DAA: 6300000e  bls.w $dba
        bls.w H097+$DBA
L097_00000DAE:
; H097+$00000DAE: 2b6dfff0fffc  move.l -$10(a5), -$4(a5)
        move.l -$10(a5), -$4(a5)
L097_00000DB4:
; H097+$00000DB4: 3b6dffe4ffea  move.w -$1c(a5), -$16(a5)
        move.w -$1c(a5), -$16(a5)
L097_00000DBA:
; H097+$00000DBA: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L097_00000DBE:
; H097+$00000DBE: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000DC2:
; H097+$00000DC2: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000DC8:
; H097+$00000DC8: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L097_00000DCC:
; H097+$00000DCC: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000DD0:
; H097+$00000DD0: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000DD6:
; H097+$00000DD6: 1400  move.b d0, d2
        move.b d0, d2
L097_00000DD8:
; H097+$00000DD8: 4a02  tst.b d2
        tst.b d2
L097_00000DDA:
; H097+$00000DDA: 6600001a  bne.w $df6
        bne.w H097+$DF6
L097_00000DDE:
; H097+$00000DDE: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L097_00000DE2:
; H097+$00000DE2: b46dffe8  cmp.w -$18(a5), d2
        cmp.w -$18(a5), d2
L097_00000DE6:
; H097+$00000DE6: 6300000e  bls.w $df6
        bls.w H097+$DF6
L097_00000DEA:
; H097+$00000DEA: 2b6dfff0fff8  move.l -$10(a5), -$8(a5)
        move.l -$10(a5), -$8(a5)
L097_00000DF0:
; H097+$00000DF0: 3b6dffe4ffe8  move.w -$1c(a5), -$18(a5)
        move.w -$1c(a5), -$18(a5)
L097_00000DF6:
; H097+$00000DF6: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L097_00000DFA:
; H097+$00000DFA: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000DFE:
; H097+$00000DFE: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000E04:
; H097+$00000E04: 0c3300012800  cmpi.b #$1, (a3, d2.l)
        cmpi.b #$1, (a3, d2.l)
L097_00000E0A:
; H097+$00000E0A: 6600006c  bne.w $e78
        bne.w H097+$E78
L097_00000E0E:
; H097+$00000E0E: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L097_00000E12:
; H097+$00000E12: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000E16:
; H097+$00000E16: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000E1C:
; H097+$00000E1C: 1f33280f  move.b $f(a3, d2.l), -(a7)
        move.b $f(a3, d2.l), -(a7)
L097_00000E20:
; H097+$00000E20: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000E22:
; H097+$00000E22: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000E26:
; H097+$00000E26: 142b0122  move.b $122(a3), d2
        move.b $122(a3), d2
L097_00000E2A:
; H097+$00000E2A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000E2C:
; H097+$00000E2C: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000E32:
; H097+$00000E32: 1400  move.b d0, d2
        move.b d0, d2
L097_00000E34:
; H097+$00000E34: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L097_00000E38:
; H097+$00000E38: 4a42  tst.w d2
        tst.w d2
L097_00000E3A:
; H097+$00000E3A: 6300003c  bls.w $e78
        bls.w H097+$E78
L097_00000E3E:
; H097+$00000E3E: 266dfff0  movea.l -$10(a5), a3
        movea.l -$10(a5), a3
L097_00000E42:
; H097+$00000E42: 4a6b0036  tst.w $36(a3)
        tst.w $36(a3)
L097_00000E46:
; H097+$00000E46: 6d000014  blt.w $e5c
        blt.w H097+$E5C
L097_00000E4A:
; H097+$00000E4A: 266dfff0  movea.l -$10(a5), a3
        movea.l -$10(a5), a3
L097_00000E4E:
; H097+$00000E4E: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L097_00000E52:
; H097+$00000E52: 5242  addq.w #$1, d2
        addq.w #$1, d2
L097_00000E54:
; H097+$00000E54: 3b42ffe4  move.w d2, -$1c(a5)
        move.w d2, -$1c(a5)
L097_00000E58:
; H097+$00000E58: 60000006  bra.w $e60
        bra.w H097+$E60
L097_00000E5C:
; H097+$00000E5C: 426dffe4  clr.w -$1c(a5)
        clr.w -$1c(a5)
L097_00000E60:
; H097+$00000E60: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L097_00000E64:
; H097+$00000E64: b46dffe6  cmp.w -$1a(a5), d2
        cmp.w -$1a(a5), d2
L097_00000E68:
; H097+$00000E68: 6300000e  bls.w $e78
        bls.w H097+$E78
L097_00000E6C:
; H097+$00000E6C: 2b6dfff0fff4  move.l -$10(a5), -$c(a5)
        move.l -$10(a5), -$c(a5)
L097_00000E72:
; H097+$00000E72: 3b6dffe4ffe6  move.w -$1c(a5), -$1a(a5)
        move.w -$1c(a5), -$1a(a5)
L097_00000E78:
; H097+$00000E78: 266dfff0  movea.l -$10(a5), a3
        movea.l -$10(a5), a3
L097_00000E7C:
; H097+$00000E7C: 2b6b002cfff0  move.l $2c(a3), -$10(a5)
        move.l $2c(a3), -$10(a5)
L097_00000E82:
; H097+$00000E82: 6000fe6e  bra.w $cf2
        bra.w H097+$CF2
L097_00000E86:
; H097+$00000E86: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L097_00000E8A:
; H097+$00000E8A: 6700005e  beq.w $eea
        beq.w H097+$EEA
L097_00000E8E:
; H097+$00000E8E: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000E90:
; H097+$00000E90: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L097_00000E94:
; H097+$00000E94: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_00000E98:
; H097+$00000E98: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000E9C:
; H097+$00000E9C: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000EA2:
; H097+$00000EA2: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000EA4:
; H097+$00000EA4: 1833280e  move.b $e(a3, d2.l), d4
        move.b $e(a3, d2.l), d4
L097_00000EA8:
; H097+$00000EA8: 0c440001  cmpi.w #$1, d4
        cmpi.w #$1, d4
L097_00000EAC:
; H097+$00000EAC: 6300003c  bls.w $eea
        bls.w H097+$EEA
L097_00000EB0:
; H097+$00000EB0: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000EB2:
; H097+$00000EB2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L097_00000EB6:
; H097+$00000EB6: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_00000EBA:
; H097+$00000EBA: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000EBE:
; H097+$00000EBE: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000EC4:
; H097+$00000EC4: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L097_00000EC8:
; H097+$00000EC8: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000ECC:
; H097+$00000ECC: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000ED2:
; H097+$00000ED2: 1400  move.b d0, d2
        move.b d0, d2
L097_00000ED4:
; H097+$00000ED4: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L097_00000ED8:
; H097+$00000ED8: 0c420014  cmpi.w #$14, d2
        cmpi.w #$14, d2
L097_00000EDC:
; H097+$00000EDC: 6600000c  bne.w $eea
        bne.w H097+$EEA
L097_00000EE0:
; H097+$00000EE0: 1b7c0001ffdc  move.b #$1, -$24(a5)
        move.b #$1, -$24(a5)
L097_00000EE6:
; H097+$00000EE6: 60000006  bra.w $eee
        bra.w H097+$EEE
L097_00000EEA:
; H097+$00000EEA: 422dffdc  clr.b -$24(a5)
        clr.b -$24(a5)
L097_00000EEE:
; H097+$00000EEE: 422dffdb  clr.b -$25(a5)
        clr.b -$25(a5)
L097_00000EF2:
; H097+$00000EF2: 42adffec  clr.l -$14(a5)
        clr.l -$14(a5)
L097_00000EF6:
; H097+$00000EF6: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L097_00000EFA:
; H097+$00000EFA: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L097_00000EFE:
; H097+$00000EFE: 6700009a  beq.w $f9a
        beq.w H097+$F9A
L097_00000F02:
; H097+$00000F02: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000F04:
; H097+$00000F04: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L097_00000F08:
; H097+$00000F08: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_00000F0C:
; H097+$00000F0C: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00000F10:
; H097+$00000F10: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00000F16:
; H097+$00000F16: 7800  moveq #$0, d4
        moveq #0, d4
L097_00000F18:
; H097+$00000F18: 18332810  move.b $10(a3, d2.l), d4
        move.b $10(a3, d2.l), d4
L097_00000F1C:
; H097+$00000F1C: 3b44ffe0  move.w d4, -$20(a5)
        move.w d4, -$20(a5)
L097_00000F20:
; H097+$00000F20: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L097_00000F24:
; H097+$00000F24: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L097_00000F26:
; H097+$00000F26: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000F2A:
; H097+$00000F2A: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000F30:
; H097+$00000F30: 1400  move.b d0, d2
        move.b d0, d2
L097_00000F32:
; H097+$00000F32: 4a02  tst.b d2
        tst.b d2
L097_00000F34:
; H097+$00000F34: 67000008  beq.w $f3e
        beq.w H097+$F3E
L097_00000F38:
; H097+$00000F38: 2b6dfffcffec  move.l -$4(a5), -$14(a5)
        move.l -$4(a5), -$14(a5)
L097_00000F3E:
; H097+$00000F3E: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L097_00000F42:
; H097+$00000F42: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L097_00000F44:
; H097+$00000F44: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000F48:
; H097+$00000F48: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000F4E:
; H097+$00000F4E: 1400  move.b d0, d2
        move.b d0, d2
L097_00000F50:
; H097+$00000F50: 4a02  tst.b d2
        tst.b d2
L097_00000F52:
; H097+$00000F52: 67000046  beq.w $f9a
        beq.w H097+$F9A
L097_00000F56:
; H097+$00000F56: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L097_00000F5A:
; H097+$00000F5A: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L097_00000F5C:
; H097+$00000F5C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000F60:
; H097+$00000F60: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000F66:
; H097+$00000F66: 1400  move.b d0, d2
        move.b d0, d2
L097_00000F68:
; H097+$00000F68: 4a02  tst.b d2
        tst.b d2
L097_00000F6A:
; H097+$00000F6A: 6700000c  beq.w $f78
        beq.w H097+$F78
L097_00000F6E:
; H097+$00000F6E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000F72:
; H097+$00000F72: 2b6b0180ffec  move.l $180(a3), -$14(a5)
        move.l $180(a3), -$14(a5)
L097_00000F78:
; H097+$00000F78: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L097_00000F7C:
; H097+$00000F7C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L097_00000F7E:
; H097+$00000F7E: 3f3c0080  move.w #$80, -(a7)
        move.w #$80, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L097_00000F82:
; H097+$00000F82: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L097_00000F88:
; H097+$00000F88: 1400  move.b d0, d2
        move.b d0, d2
L097_00000F8A:
; H097+$00000F8A: 4a02  tst.b d2
        tst.b d2
L097_00000F8C:
; H097+$00000F8C: 6700000c  beq.w $f9a
        beq.w H097+$F9A
L097_00000F90:
; H097+$00000F90: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00000F94:
; H097+$00000F94: 2b6b0184ffec  move.l $184(a3), -$14(a5)
        move.l $184(a3), -$14(a5)
L097_00000F9A:
; H097+$00000F9A: 4aadffec  tst.l -$14(a5)
        tst.l -$14(a5)
L097_00000F9E:
; H097+$00000F9E: 6600000c  bne.w $fac
        bne.w H097+$FAC
L097_00000FA2:
; H097+$00000FA2: 0c6d000affe0  cmpi.w #$a, -$20(a5)
        cmpi.w #$a, -$20(a5)
L097_00000FA8:
; H097+$00000FA8: 66000008  bne.w $fb2
        bne.w H097+$FB2
L097_00000FAC:
; H097+$00000FAC: 1b7c0001ffdb  move.b #$1, -$25(a5)
        move.b #$1, -$25(a5)
L097_00000FB2:
; H097+$00000FB2: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L097_00000FB6:
; H097+$00000FB6: 67000044  beq.w $ffc
        beq.w H097+$FFC
L097_00000FBA:
; H097+$00000FBA: 7400  moveq #$0, d2
        moveq #0, d2
L097_00000FBC:
; H097+$00000FBC: 342dffe8  move.w -$18(a5), d2
        move.w -$18(a5), d2
L097_00000FC0:
; H097+$00000FC0: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L097_00000FC2:
; H097+$00000FC2: 382dffea  move.w -$16(a5), d4
        move.w -$16(a5), d4
L097_00000FC6:
; H097+$00000FC6: b842  cmp.w d2, d4
        cmp.w d2, d4
L097_00000FC8:
; H097+$00000FC8: 63000032  bls.w $ffc
        bls.w H097+$FFC
L097_00000FCC:
; H097+$00000FCC: 4a2dffdb  tst.b -$25(a5)
        tst.b -$25(a5)
L097_00000FD0:
; H097+$00000FD0: 6700002a  beq.w $ffc
        beq.w H097+$FFC
L097_00000FD4:
; H097+$00000FD4: 4a2dffdc  tst.b -$24(a5)
        tst.b -$24(a5)
L097_00000FD8:
; H097+$00000FD8: 66000018  bne.w $ff2
        bne.w H097+$FF2
L097_00000FDC:
; H097+$00000FDC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00000FE0:
; H097+$00000FE0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H063+$2BDE (sub_H063_00002BDE)
L097_00000FE4:
; H097+$00000FE4: 4eb900002bde  jsr $2bde.l
        jsr (H063+$2BDE).l
L097_00000FEA:
; H097+$00000FEA: 3400  move.w d0, d2
        move.w d0, d2
L097_00000FEC:
; H097+$00000FEC: 4a42  tst.w d2
        tst.w d2
L097_00000FEE:
; H097+$00000FEE: 6600000c  bne.w $ffc
        bne.w H097+$FFC
L097_00000FF2:
; H097+$00000FF2: 2b6dfffcfff0  move.l -$4(a5), -$10(a5)
        move.l -$4(a5), -$10(a5)
L097_00000FF8:
; H097+$00000FF8: 60000008  bra.w $1002
        bra.w H097+$1002
L097_00000FFC:
; H097+$00000FFC: 2b6dfff8fff0  move.l -$8(a5), -$10(a5)
        move.l -$8(a5), -$10(a5)
L097_00001002:
; H097+$00001002: 422dffdd  clr.b -$23(a5)
        clr.b -$23(a5)
L097_00001006:
; H097+$00001006: 1b7c0001ffde  move.b #$1, -$22(a5)
        move.b #$1, -$22(a5)
L097_0000100C:
; H097+$0000100C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001010:
; H097+$00001010: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L097_00001014:
; H097+$00001014: 67000026  beq.w $103c
        beq.w H097+$103C
L097_00001018:
; H097+$00001018: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000101C:
; H097+$0000101C: 242b0154  move.l $154(a3), d2
        move.l $154(a3), d2
L097_00001020:
; H097+$00001020: b4adfff0  cmp.l -$10(a5), d2
        cmp.l -$10(a5), d2
L097_00001024:
; H097+$00001024: 67000012  beq.w $1038
        beq.w H097+$1038
L097_00001028:
; H097+$00001028: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000102C:
; H097+$0000102C: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L097_00001030:
; H097+$00001030: 4a2b003c  tst.b $3c(a3)
        tst.b $3c(a3)
L097_00001034:
; H097+$00001034: 67000006  beq.w $103c
        beq.w H097+$103C
L097_00001038:
; H097+$00001038: 422dffde  clr.b -$22(a5)
        clr.b -$22(a5)
L097_0000103C:
; H097+$0000103C: 4a2dffde  tst.b -$22(a5)
        tst.b -$22(a5)
L097_00001040:
; H097+$00001040: 6700008c  beq.w $10ce
        beq.w H097+$10CE
L097_00001044:
; H097+$00001044: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001048:
; H097+$00001048: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L097_0000104C:
; H097+$0000104C: 67000010  beq.w $105e
        beq.w H097+$105E
L097_00001050:
; H097+$00001050: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001054:
; H097+$00001054: 2f2b0154  move.l $154(a3), -(a7)
        move.l $154(a3), -(a7)
; -> H065+$2C04 (sub_H065_00002C04)
L097_00001058:
; H097+$00001058: 4eb900002c04  jsr $2c04.l
        jsr (H065+$2C04).l
L097_0000105E:
; H097+$0000105E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L097_00001062:
; H097+$00001062: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L097_00001068:
; H097+$00001068: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000106C:
; H097+$0000106C: 4aab0158  tst.l $158(a3)
        tst.l $158(a3)
L097_00001070:
; H097+$00001070: 67000044  beq.w $10b6
        beq.w H097+$10B6
L097_00001074:
; H097+$00001074: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001078:
; H097+$00001078: 266a0158  movea.l $158(a2), a3
        movea.l $158(a2), a3
L097_0000107C:
; H097+$0000107C: 4a2b003c  tst.b $3c(a3)
        tst.b $3c(a3)
L097_00001080:
; H097+$00001080: 66000034  bne.w $10b6
        bne.w H097+$10B6
L097_00001084:
; H097+$00001084: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001086:
; H097+$00001086: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000108A:
; H097+$0000108A: 142b0188  move.b $188(a3), d2
        move.b $188(a3), d2
L097_0000108E:
; H097+$0000108E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001092:
; H097+$00001092: 266a0158  movea.l $158(a2), a3
        movea.l $158(a2), a3
L097_00001096:
; H097+$00001096: 7800  moveq #$0, d4
        moveq #0, d4
L097_00001098:
; H097+$00001098: 182b0030  move.b $30(a3), d4
        move.b $30(a3), d4
L097_0000109C:
; H097+$0000109C: c9fc0012  muls.w #$12, d4
        muls.w #$12, d4
L097_000010A0:
; H097+$000010A0: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_000010A6:
; H097+$000010A6: 7c00  moveq #$0, d6
        moveq #0, d6
L097_000010A8:
; H097+$000010A8: 1c334801  move.b $1(a3, d4.l), d6
        move.b $1(a3, d4.l), d6
L097_000010AC:
; H097+$000010AC: 9446  sub.w d6, d2
        sub.w d6, d2
L097_000010AE:
; H097+$000010AE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000010B2:
; H097+$000010B2: 17420188  move.b d2, $188(a3)
        move.b d2, $188(a3)
L097_000010B6:
; H097+$000010B6: 4aadfff0  tst.l -$10(a5)
        tst.l -$10(a5)
L097_000010BA:
; H097+$000010BA: 6700000c  beq.w $10c8
        beq.w H097+$10C8
L097_000010BE:
; H097+$000010BE: 2f2dfff0  move.l -$10(a5), -(a7)
        move.l -$10(a5), -(a7)
; -> H065+$2C04 (sub_H065_00002C04)
L097_000010C2:
; H097+$000010C2: 4eb900002c04  jsr $2c04.l
        jsr (H065+$2C04).l
L097_000010C8:
; H097+$000010C8: 1b7c0001ffdd  move.b #$1, -$23(a5)
        move.b #$1, -$23(a5)
L097_000010CE:
; H097+$000010CE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L097_000010D2:
; H097+$000010D2: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L097_000010D8:
; H097+$000010D8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H096+$11D4 (sub_H096_000011D4)
L097_000010DC:
; H097+$000010DC: 4eb9000011d4  jsr $11d4.l
        jsr (H096+$11D4).l
L097_000010E2:
; H097+$000010E2: 1b7c0001ffde  move.b #$1, -$22(a5)
        move.b #$1, -$22(a5)
L097_000010E8:
; H097+$000010E8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000010EC:
; H097+$000010EC: 4aab0158  tst.l $158(a3)
        tst.l $158(a3)
L097_000010F0:
; H097+$000010F0: 67000026  beq.w $1118
        beq.w H097+$1118
L097_000010F4:
; H097+$000010F4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000010F8:
; H097+$000010F8: 242b0158  move.l $158(a3), d2
        move.l $158(a3), d2
L097_000010FC:
; H097+$000010FC: b4adfff4  cmp.l -$c(a5), d2
        cmp.l -$c(a5), d2
L097_00001100:
; H097+$00001100: 67000012  beq.w $1114
        beq.w H097+$1114
L097_00001104:
; H097+$00001104: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001108:
; H097+$00001108: 266a0158  movea.l $158(a2), a3
        movea.l $158(a2), a3
L097_0000110C:
; H097+$0000110C: 4a2b003c  tst.b $3c(a3)
        tst.b $3c(a3)
L097_00001110:
; H097+$00001110: 67000006  beq.w $1118
        beq.w H097+$1118
L097_00001114:
; H097+$00001114: 422dffde  clr.b -$22(a5)
        clr.b -$22(a5)
L097_00001118:
; H097+$00001118: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000111A:
; H097+$0000111A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000111E:
; H097+$0000111E: 142b0188  move.b $188(a3), d2
        move.b $188(a3), d2
L097_00001122:
; H097+$00001122: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L097_00001126:
; H097+$00001126: 6300004a  bls.w $1172
        bls.w H097+$1172
L097_0000112A:
; H097+$0000112A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000112E:
; H097+$0000112E: 4aab0158  tst.l $158(a3)
        tst.l $158(a3)
L097_00001132:
; H097+$00001132: 67000012  beq.w $1146
        beq.w H097+$1146
L097_00001136:
; H097+$00001136: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000113A:
; H097+$0000113A: 266a0158  movea.l $158(a2), a3
        movea.l $158(a2), a3
L097_0000113E:
; H097+$0000113E: 4a2b003c  tst.b $3c(a3)
        tst.b $3c(a3)
L097_00001142:
; H097+$00001142: 67000016  beq.w $115a
        beq.w H097+$115A
L097_00001146:
; H097+$00001146: 2f2dfff0  move.l -$10(a5), -(a7)
        move.l -$10(a5), -(a7)
; -> H065+$2C04 (sub_H065_00002C04)
L097_0000114A:
; H097+$0000114A: 4eb900002c04  jsr $2c04.l
        jsr (H065+$2C04).l
L097_00001150:
; H097+$00001150: 1b7c0001ffdd  move.b #$1, -$23(a5)
        move.b #$1, -$23(a5)
L097_00001156:
; H097+$00001156: 60000016  bra.w $116e
        bra.w H097+$116E
L097_0000115A:
; H097+$0000115A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000115E:
; H097+$0000115E: 2f2b0158  move.l $158(a3), -(a7)
        move.l $158(a3), -(a7)
; -> H065+$2C04 (sub_H065_00002C04)
L097_00001162:
; H097+$00001162: 4eb900002c04  jsr $2c04.l
        jsr (H065+$2C04).l
L097_00001168:
; H097+$00001168: 1b7c0001ffdd  move.b #$1, -$23(a5)
        move.b #$1, -$23(a5)
L097_0000116E:
; H097+$0000116E: 60000058  bra.w $11c8
        bra.w H097+$11C8
L097_00001172:
; H097+$00001172: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001174:
; H097+$00001174: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001178:
; H097+$00001178: 142b0188  move.b $188(a3), d2
        move.b $188(a3), d2
L097_0000117C:
; H097+$0000117C: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L097_00001180:
; H097+$00001180: 64000046  bcc.w $11c8
        bcc.w H097+$11C8
L097_00001184:
; H097+$00001184: 4a2dffde  tst.b -$22(a5)
        tst.b -$22(a5)
L097_00001188:
; H097+$00001188: 6700003e  beq.w $11c8
        beq.w H097+$11C8
L097_0000118C:
; H097+$0000118C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001190:
; H097+$00001190: 4aab0158  tst.l $158(a3)
        tst.l $158(a3)
L097_00001194:
; H097+$00001194: 67000010  beq.w $11a6
        beq.w H097+$11A6
L097_00001198:
; H097+$00001198: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000119C:
; H097+$0000119C: 2f2b0158  move.l $158(a3), -(a7)
        move.l $158(a3), -(a7)
; -> H065+$2C04 (sub_H065_00002C04)
L097_000011A0:
; H097+$000011A0: 4eb900002c04  jsr $2c04.l
        jsr (H065+$2C04).l
L097_000011A6:
; H097+$000011A6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L097_000011AA:
; H097+$000011AA: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L097_000011B0:
; H097+$000011B0: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L097_000011B4:
; H097+$000011B4: 6700000c  beq.w $11c2
        beq.w H097+$11C2
L097_000011B8:
; H097+$000011B8: 2f2dfff4  move.l -$c(a5), -(a7)
        move.l -$c(a5), -(a7)
; -> H065+$2C04 (sub_H065_00002C04)
L097_000011BC:
; H097+$000011BC: 4eb900002c04  jsr $2c04.l
        jsr (H065+$2C04).l
L097_000011C2:
; H097+$000011C2: 1b7c0001ffdd  move.b #$1, -$23(a5)
        move.b #$1, -$23(a5)
L097_000011C8:
; H097+$000011C8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L097_000011CC:
; H097+$000011CC: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L097_000011D2:
; H097+$000011D2: 4a2dffdd  tst.b -$23(a5)
        tst.b -$23(a5)
L097_000011D6:
; H097+$000011D6: 6700000c  beq.w $11e4
        beq.w H097+$11E4
L097_000011DA:
; H097+$000011DA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$1160 (trampoline_H063_1350)
L097_000011DE:
; H097+$000011DE: 4eb900001160  jsr $1160.l
        jsr (H063+$1160).l
L097_000011E4:
; H097+$000011E4: 4e5d  unlk a5
        unlk a5
L097_000011E6:
; H097+$000011E6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_000011E8:
; H097+$000011E8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_000011EA:
; H097+$000011EA: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_000011EC:
; H097+$000011EC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_000011EE [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H048+$113E, H063+$0946, H062+$142C.
;   - Calls H048+$113E.
;   - Calls H063+$0946.
;   - Calls H062+$142C.
; Direct callers: H097+$1656
; --------------------------------------------------------------------------
L097_000011EE:
; H097+$000011EE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_000011F0:
; H097+$000011F0: 287aeeac  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_000011F4:
; H097+$000011F4: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L097_000011F8:
; H097+$000011F8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000011FC:
; H097+$000011FC: 4213  clr.b (a3)
        clr.b (a3)
L097_000011FE:
; H097+$000011FE: 422dffef  clr.b -$11(a5)
        clr.b -$11(a5)
L097_00001202:
; H097+$00001202: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L097_00001206:
; H097+$00001206: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000120A:
; H097+$0000120A: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000120C:
; H097+$0000120C: 142b0017  move.b $17(a3), d2
        move.b $17(a3), d2
L097_00001210:
; H097+$00001210: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00001212:
; H097+$00001212: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L097_00001216:
; H097+$00001216: 47ecffc4  lea.l -$3c(a4), a3
        lea.l -$3c(a4), a3
L097_0000121A:
; H097+$0000121A: 382d0012  move.w $12(a5), d4
        move.w $12(a5), d4
L097_0000121E:
; H097+$0000121E: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_00001220:
; H097+$00001220: e344  asl.w #$1, d4
        asl.w #$1, d4
L097_00001222:
; H097+$00001222: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L097_00001226:
; H097+$00001226: 3b734000fffa  move.w (a3, d4.w), -$6(a5)
        move.w (a3, d4.w), -$6(a5)
L097_0000122C:
; H097+$0000122C: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L097_00001230:
; H097+$00001230: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L097_00001234:
; H097+$00001234: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_0000123A:
; H097+$0000123A: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L097_0000123E:
; H097+$0000123E: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L097_00001242:
; H097+$00001242: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L097_00001246:
; H097+$00001246: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L097_0000124A:
; H097+$0000124A: 486dfff6  pea.l -$a(a5)
        pea.l -$a(a5)
L097_0000124E:
; H097+$0000124E: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
L097_00001252:
; H097+$00001252: 486dfff1  pea.l -$f(a5)
        pea.l -$f(a5)
L097_00001256:
; H097+$00001256: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
; -> H048+$113E (sub_H048_0000113E)
L097_0000125A:
; H097+$0000125A: 4eb90000113e  jsr $113e.l
        jsr (H048+$113E).l
L097_00001260:
; H097+$00001260: 4a6dfff4  tst.w -$c(a5)
        tst.w -$c(a5)
L097_00001264:
; H097+$00001264: 6600000e  bne.w $1274
        bne.w H097+$1274
L097_00001268:
; H097+$00001268: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000126C:
; H097+$0000126C: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L097_00001270:
; H097+$00001270: 600001a6  bra.w $1418
        bra.w H097+$1418
L097_00001274:
; H097+$00001274: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L097_00001278:
; H097+$00001278: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_0000127A:
; H097+$0000127A: e542  asl.w #$2, d2
        asl.w #$2, d2
L097_0000127C:
; H097+$0000127C: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L097_00001282:
; H097+$00001282: 7800  moveq #$0, d4
        moveq #0, d4
L097_00001284:
; H097+$00001284: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_00001288:
; H097+$00001288: 0c4400ff  cmpi.w #$ff, d4
        cmpi.w #$ff, d4
L097_0000128C:
; H097+$0000128C: 66000008  bne.w $1296
        bne.w H097+$1296
L097_00001290:
; H097+$00001290: 7000  moveq #$0, d0
        moveq #0, d0
L097_00001292:
; H097+$00001292: 6000018c  bra.w $1420
        bra.w H097+$1420
L097_00001296:
; H097+$00001296: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L097_0000129A:
; H097+$0000129A: 02420001  andi.w #$1, d2
        andi.w #$1, d2
L097_0000129E:
; H097+$0000129E: 4a02  tst.b d2
        tst.b d2
L097_000012A0:
; H097+$000012A0: 67000022  beq.w $12c4
        beq.w H097+$12C4
L097_000012A4:
; H097+$000012A4: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L097_000012A8:
; H097+$000012A8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_000012AA:
; H097+$000012AA: e542  asl.w #$2, d2
        asl.w #$2, d2
L097_000012AC:
; H097+$000012AC: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L097_000012B2:
; H097+$000012B2: 7800  moveq #$0, d4
        moveq #0, d4
L097_000012B4:
; H097+$000012B4: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_000012B8:
; H097+$000012B8: c8fc0003  mulu.w #$3, d4
        mulu.w #$3, d4
L097_000012BC:
; H097+$000012BC: 3b44fff2  move.w d4, -$e(a5)
        move.w d4, -$e(a5)
L097_000012C0:
; H097+$000012C0: 6000001c  bra.w $12de
        bra.w H097+$12DE
L097_000012C4:
; H097+$000012C4: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L097_000012C8:
; H097+$000012C8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_000012CA:
; H097+$000012CA: e542  asl.w #$2, d2
        asl.w #$2, d2
L097_000012CC:
; H097+$000012CC: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L097_000012D2:
; H097+$000012D2: 7800  moveq #$0, d4
        moveq #0, d4
L097_000012D4:
; H097+$000012D4: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_000012D8:
; H097+$000012D8: e344  asl.w #$1, d4
        asl.w #$1, d4
L097_000012DA:
; H097+$000012DA: 3b44fff2  move.w d4, -$e(a5)
        move.w d4, -$e(a5)
L097_000012DE:
; H097+$000012DE: 4a6dfff6  tst.w -$a(a5)
        tst.w -$a(a5)
L097_000012E2:
; H097+$000012E2: 66000134  bne.w $1418
        bne.w H097+$1418
L097_000012E6:
; H097+$000012E6: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L097_000012EA:
; H097+$000012EA: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000012EE:
; H097+$000012EE: 7400  moveq #$0, d2
        moveq #0, d2
L097_000012F0:
; H097+$000012F0: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_000012F4:
; H097+$000012F4: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L097_000012F8:
; H097+$000012F8: b842  cmp.w d2, d4
        cmp.w d2, d4
L097_000012FA:
; H097+$000012FA: 6400011c  bcc.w $1418
        bcc.w H097+$1418
L097_000012FE:
; H097+$000012FE: 4a2dfff1  tst.b -$f(a5)
        tst.b -$f(a5)
L097_00001302:
; H097+$00001302: 670000a4  beq.w $13a8
        beq.w H097+$13A8
L097_00001306:
; H097+$00001306: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L097_0000130A:
; H097+$0000130A: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
L097_0000130E:
; H097+$0000130E: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L097_00001312:
; H097+$00001312: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L097_00001318:
; H097+$00001318: 1400  move.b d0, d2
        move.b d0, d2
L097_0000131A:
; H097+$0000131A: 4a02  tst.b d2
        tst.b d2
L097_0000131C:
; H097+$0000131C: 6600008a  bne.w $13a8
        bne.w H097+$13A8
L097_00001320:
; H097+$00001320: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L097_00001324:
; H097+$00001324: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L097_00001328:
; H097+$00001328: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L097_0000132C:
; H097+$0000132C: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L097_00001332:
; H097+$00001332: 1400  move.b d0, d2
        move.b d0, d2
L097_00001334:
; H097+$00001334: 4a02  tst.b d2
        tst.b d2
L097_00001336:
; H097+$00001336: 66000070  bne.w $13a8
        bne.w H097+$13A8
L097_0000133A:
; H097+$0000133A: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L097_0000133E:
; H097+$0000133E: 3f3c0063  move.w #$63, -(a7)
        move.w #$63, -(a7)
L097_00001342:
; H097+$00001342: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L097_00001346:
; H097+$00001346: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L097_0000134C:
; H097+$0000134C: 1400  move.b d0, d2
        move.b d0, d2
L097_0000134E:
; H097+$0000134E: 4a02  tst.b d2
        tst.b d2
L097_00001350:
; H097+$00001350: 66000056  bne.w $13a8
        bne.w H097+$13A8
L097_00001354:
; H097+$00001354: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L097_00001358:
; H097+$00001358: 3f3c003f  move.w #$3f, -(a7)
        move.w #$3f, -(a7)
L097_0000135C:
; H097+$0000135C: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L097_00001360:
; H097+$00001360: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L097_00001366:
; H097+$00001366: 1400  move.b d0, d2
        move.b d0, d2
L097_00001368:
; H097+$00001368: 4a02  tst.b d2
        tst.b d2
L097_0000136A:
; H097+$0000136A: 6600003c  bne.w $13a8
        bne.w H097+$13A8
L097_0000136E:
; H097+$0000136E: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L097_00001372:
; H097+$00001372: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001376:
; H097+$00001376: 4a2b0012  tst.b $12(a3)
        tst.b $12(a3)
L097_0000137A:
; H097+$0000137A: 6600002c  bne.w $13a8
        bne.w H097+$13A8
L097_0000137E:
; H097+$0000137E: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L097_00001382:
; H097+$00001382: 4227  clr.b -(a7)
        clr.b -(a7)
L097_00001384:
; H097+$00001384: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H062+$142C (sub_H062_0000142C)
L097_00001386:
; H097+$00001386: 4eb90000142c  jsr $142c.l
        jsr (H062+$142C).l
L097_0000138C:
; H097+$0000138C: 1400  move.b d0, d2
        move.b d0, d2
L097_0000138E:
; H097+$0000138E: 4a02  tst.b d2
        tst.b d2
L097_00001390:
; H097+$00001390: 66000016  bne.w $13a8
        bne.w H097+$13A8
L097_00001394:
; H097+$00001394: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L097_00001398:
; H097+$00001398: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000139C:
; H097+$0000139C: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000139E:
; H097+$0000139E: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_000013A2:
; H097+$000013A2: 5242  addq.w #$1, d2
        addq.w #$1, d2
L097_000013A4:
; H097+$000013A4: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L097_000013A8:
; H097+$000013A8: 4a2dfff0  tst.b -$10(a5)
        tst.b -$10(a5)
L097_000013AC:
; H097+$000013AC: 6700004e  beq.w $13fc
        beq.w H097+$13FC
L097_000013B0:
; H097+$000013B0: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L097_000013B4:
; H097+$000013B4: 0c2b000700db  cmpi.b #$7, $db(a3)
        cmpi.b #$7, $db(a3)
L097_000013BA:
; H097+$000013BA: 64000040  bcc.w $13fc
        bcc.w H097+$13FC
L097_000013BE:
; H097+$000013BE: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L097_000013C2:
; H097+$000013C2: 3f3c0063  move.w #$63, -(a7)
        move.w #$63, -(a7)
L097_000013C6:
; H097+$000013C6: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L097_000013CA:
; H097+$000013CA: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L097_000013D0:
; H097+$000013D0: 1400  move.b d0, d2
        move.b d0, d2
L097_000013D2:
; H097+$000013D2: 4a02  tst.b d2
        tst.b d2
L097_000013D4:
; H097+$000013D4: 66000026  bne.w $13fc
        bne.w H097+$13FC
L097_000013D8:
; H097+$000013D8: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L097_000013DC:
; H097+$000013DC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000013E0:
; H097+$000013E0: 4a2b0012  tst.b $12(a3)
        tst.b $12(a3)
L097_000013E4:
; H097+$000013E4: 66000016  bne.w $13fc
        bne.w H097+$13FC
L097_000013E8:
; H097+$000013E8: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L097_000013EC:
; H097+$000013EC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000013F0:
; H097+$000013F0: 7400  moveq #$0, d2
        moveq #0, d2
L097_000013F2:
; H097+$000013F2: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_000013F6:
; H097+$000013F6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L097_000013F8:
; H097+$000013F8: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L097_000013FC:
; H097+$000013FC: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L097_00001400:
; H097+$00001400: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001404:
; H097+$00001404: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001406:
; H097+$00001406: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_0000140A:
; H097+$0000140A: b46dfff2  cmp.w -$e(a5), d2
        cmp.w -$e(a5), d2
L097_0000140E:
; H097+$0000140E: 65000008  bcs.w $1418
        bcs.w H097+$1418
L097_00001412:
; H097+$00001412: 1b7c0001ffef  move.b #$1, -$11(a5)
        move.b #$1, -$11(a5)
L097_00001418:
; H097+$00001418: 102dffef  move.b -$11(a5), d0
        move.b -$11(a5), d0
L097_0000141C:
; H097+$0000141C: 60000002  bra.w $1420
        bra.w H097+$1420
L097_00001420:
; H097+$00001420: 4e5d  unlk a5
        unlk a5
L097_00001422:
; H097+$00001422: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_00001424:
; H097+$00001424: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00001426:
; H097+$00001426: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L097_0000142A:
; H097+$0000142A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_0000142C [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H045+$01D6, H026+$01E0, H030+$0256, H062+$156C.
;   - Calls H045+$01D6.
;   - Calls H026+$01E0.
;   - Calls H030+$0256.
;   - Calls H062+$156C.
;   - Calls H063+$3CA0.
;   - Calls H096+$10FA.
;   - Calls H063+$2F12.
; Direct callers: H097+$199E, H097+$1B64
; --------------------------------------------------------------------------
L097_0000142C:
; H097+$0000142C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_0000142E:
; H097+$0000142E: 287aec6e  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00001432:
; H097+$00001432: 4e55ffa0  link.w a5, #$ffa0
        link.w a5, #$ffa0
L097_00001436:
; H097+$00001436: 47ec0030  lea.l $30(a4), a3
        lea.l $30(a4), a3
L097_0000143A:
; H097+$0000143A: 45f900003c82  lea.l $3c82.l, a2
        lea.l (H005+$3C82).l, a2
L097_00001440:
; H097+$00001440: 7450  moveq #$50, d2
        moveq #80, d2
L097_00001442:
; H097+$00001442: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L097_00001444:
; H097+$00001444: 57cafffc  dbeq d2, $1442
        dbeq d2, H097+$1442
L097_00001448:
; H097+$00001448: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L097_0000144C:
; H097+$0000144C: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
L097_00001450:
; H097+$00001450: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001454:
; H097+$00001454: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001458:
; H097+$00001458: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000145A:
; H097+$0000145A: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_0000145E:
; H097+$0000145E: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_00001464:
; H097+$00001464: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L097_00001466:
; H097+$00001466: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_0000146C:
; H097+$0000146C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L097_0000146E:
; H097+$0000146E: 4227  clr.b -(a7)
        clr.b -(a7)
L097_00001470:
; H097+$00001470: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L097_00001474:
; H097+$00001474: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L097_00001478:
; H097+$00001478: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L097_0000147C:
; H097+$0000147C: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L097_00001482:
; H097+$00001482: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L097_00001486:
; H097+$00001486: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
L097_0000148A:
; H097+$0000148A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_0000148E:
; H097+$0000148E: 486c004a  pea.l $4a(a4)
        pea.l $4a(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L097_00001492:
; H097+$00001492: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L097_00001498:
; H097+$00001498: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L097_0000149C:
; H097+$0000149C: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L097_000014A2:
; H097+$000014A2: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L097_000014A6:
; H097+$000014A6: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L097_000014AA:
; H097+$000014AA: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L097_000014B0:
; H097+$000014B0: 4267  clr.w -(a7)
        clr.w -(a7)
L097_000014B2:
; H097+$000014B2: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L097_000014B6:
; H097+$000014B6: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L097_000014BA:
; H097+$000014BA: 4267  clr.w -(a7)
        clr.w -(a7)
L097_000014BC:
; H097+$000014BC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L097_000014C0:
; H097+$000014C0: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
; FLOW: Calls UI_DrawText (H030+$0256).
L097_000014C6:
; H097+$000014C6: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L097_000014CC:
; H097+$000014CC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000014D0:
; H097+$000014D0: 6100ebde  bsr.w $b0
        bsr.w H097+$B0
L097_000014D4:
; H097+$000014D4: 1400  move.b d0, d2
        move.b d0, d2
L097_000014D6:
; H097+$000014D6: 4a02  tst.b d2
        tst.b d2
L097_000014D8:
; H097+$000014D8: 660003ee  bne.w $18c8
        bne.w H097+$18C8
L097_000014DC:
; H097+$000014DC: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000014E0:
; H097+$000014E0: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000014E4:
; H097+$000014E4: 7400  moveq #$0, d2
        moveq #0, d2
L097_000014E6:
; H097+$000014E6: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_000014EA:
; H097+$000014EA: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_000014F0:
; H097+$000014F0: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L097_000014F2:
; H097+$000014F2: 4a42  tst.w d2
        tst.w d2
L097_000014F4:
; H097+$000014F4: 630003c6  bls.w $18bc
        bls.w H097+$18BC
L097_000014F8:
; H097+$000014F8: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000014FC:
; H097+$000014FC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001500:
; H097+$00001500: 4a6b0004  tst.w $4(a3)
        tst.w $4(a3)
L097_00001504:
; H097+$00001504: 6f0003b6  ble.w $18bc
        ble.w H097+$18BC
L097_00001508:
; H097+$00001508: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000150A:
; H097+$0000150A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000150E:
; H097+$0000150E: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L097_00001512:
; H097+$00001512: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L097_00001516:
; H097+$00001516: 6500004a  bcs.w $1562
        bcs.w H097+$1562
L097_0000151A:
; H097+$0000151A: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000151C:
; H097+$0000151C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001520:
; H097+$00001520: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L097_00001524:
; H097+$00001524: 0c42007f  cmpi.w #$7f, d2
        cmpi.w #$7f, d2
L097_00001528:
; H097+$00001528: 6300002a  bls.w $1554
        bls.w H097+$1554
L097_0000152C:
; H097+$0000152C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00001530:
; H097+$00001530: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00001534:
; H097+$00001534: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_0000153A:
; H097+$0000153A: 3400  move.w d0, d2
        move.w d0, d2
L097_0000153C:
; H097+$0000153C: 7800  moveq #$0, d4
        moveq #0, d4
L097_0000153E:
; H097+$0000153E: 183900002478  move.b $2478.l, d4
        move.b (H005+$2478).l, d4
L097_00001544:
; H097+$00001544: d444  add.w d4, d2
        add.w d4, d2
L097_00001546:
; H097+$00001546: 7800  moveq #$0, d4
        moveq #0, d4
L097_00001548:
; H097+$00001548: 183900002481  move.b $2481.l, d4
        move.b (H005+$2481).l, d4
L097_0000154E:
; H097+$0000154E: b444  cmp.w d4, d2
        cmp.w d4, d2
L097_00001550:
; H097+$00001550: 64000010  bcc.w $1562
        bcc.w H097+$1562
L097_00001554:
; H097+$00001554: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001558:
; H097+$00001558: 0c2b00010199  cmpi.b #$1, $199(a3)
        cmpi.b #$1, $199(a3)
L097_0000155E:
; H097+$0000155E: 6600035c  bne.w $18bc
        bne.w H097+$18BC
L097_00001562:
; H097+$00001562: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001566:
; H097+$00001566: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000156A:
; H097+$0000156A: 4a2b0016  tst.b $16(a3)
        tst.b $16(a3)
L097_0000156E:
; H097+$0000156E: 6600001c  bne.w $158c
        bne.w H097+$158C
L097_00001572:
; H097+$00001572: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001576:
; H097+$00001576: 4aab015c  tst.l $15c(a3)
        tst.l $15c(a3)
L097_0000157A:
; H097+$0000157A: 66000010  bne.w $158c
        bne.w H097+$158C
L097_0000157E:
; H097+$0000157E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001582:
; H097+$00001582: 0c2b0005005c  cmpi.b #$5, $5c(a3)
        cmpi.b #$5, $5c(a3)
L097_00001588:
; H097+$00001588: 67000332  beq.w $18bc
        beq.w H097+$18BC
L097_0000158C:
; H097+$0000158C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001590:
; H097+$00001590: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001594:
; H097+$00001594: 4a2b0016  tst.b $16(a3)
        tst.b $16(a3)
L097_00001598:
; H097+$00001598: 66000020  bne.w $15ba
        bne.w H097+$15BA
L097_0000159C:
; H097+$0000159C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000015A0:
; H097+$000015A0: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000015A4:
; H097+$000015A4: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000015A8:
; H097+$000015A8: 2f2b000c  move.l $c(a3), -(a7)
        move.l $c(a3), -(a7)
; -> H063+$3CA0 (sub_H063_00003CA0)
L097_000015AC:
; H097+$000015AC: 4eb900003ca0  jsr $3ca0.l
        jsr (H063+$3CA0).l
L097_000015B2:
; H097+$000015B2: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L097_000015B6:
; H097+$000015B6: 6000006e  bra.w $1626
        bra.w H097+$1626
L097_000015BA:
; H097+$000015BA: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000015BE:
; H097+$000015BE: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000015C2:
; H097+$000015C2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L097_000015C4:
; H097+$000015C4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_000015C8:
; H097+$000015C8: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_000015CC:
; H097+$000015CC: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_000015D2:
; H097+$000015D2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L097_000015D4:
; H097+$000015D4: 17400017  move.b d0, $17(a3)
        move.b d0, $17(a3)
L097_000015D8:
; H097+$000015D8: 7400  moveq #$0, d2
        moveq #0, d2
L097_000015DA:
; H097+$000015DA: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L097_000015E0:
; H097+$000015E0: 7800  moveq #$0, d4
        moveq #0, d4
L097_000015E2:
; H097+$000015E2: 183900002820  move.b $2820.l, d4
        move.b (H005+$2820).l, d4
L097_000015E8:
; H097+$000015E8: 5444  addq.w #$2, d4
        addq.w #$2, d4
L097_000015EA:
; H097+$000015EA: 02840000ffff  andi.l #$ffff, d4
        andi.l #$ffff, d4
L097_000015F0:
; H097+$000015F0: 02440003  andi.w #$3, d4
        andi.w #$3, d4
L097_000015F4:
; H097+$000015F4: 02840000ffff  andi.l #$ffff, d4
        andi.l #$ffff, d4
L097_000015FA:
; H097+$000015FA: e24c  lsr.w #$1, d4
        lsr.w #$1, d4
L097_000015FC:
; H097+$000015FC: 9444  sub.w d4, d2
        sub.w d4, d2
L097_000015FE:
; H097+$000015FE: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_00001602:
; H097+$00001602: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001606:
; H097+$00001606: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L097_0000160A:
; H097+$0000160A: 6600000c  bne.w $1618
        bne.w H097+$1618
L097_0000160E:
; H097+$0000160E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_00001612:
; H097+$00001612: 5842  addq.w #$4, d2
        addq.w #$4, d2
L097_00001614:
; H097+$00001614: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_00001618:
; H097+$00001618: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000161A:
; H097+$0000161A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_0000161E:
; H097+$0000161E: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L097_00001622:
; H097+$00001622: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_00001626:
; H097+$00001626: 422dfff9  clr.b -$7(a5)
        clr.b -$7(a5)
L097_0000162A:
; H097+$0000162A: 422dfff8  clr.b -$8(a5)
        clr.b -$8(a5)
L097_0000162E:
; H097+$0000162E: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L097_00001634:
; H097+$00001634: 0c6d0006fffa  cmpi.w #$6, -$6(a5)
        cmpi.w #$6, -$6(a5)
L097_0000163A:
; H097+$0000163A: 64000056  bcc.w $1692
        bcc.w H097+$1692
L097_0000163E:
; H097+$0000163E: 4a2dfff8  tst.b -$8(a5)
        tst.b -$8(a5)
L097_00001642:
; H097+$00001642: 6600004e  bne.w $1692
        bne.w H097+$1692
L097_00001646:
; H097+$00001646: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_0000164A:
; H097+$0000164A: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L097_0000164E:
; H097+$0000164E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L097_00001652:
; H097+$00001652: 486dfff9  pea.l -$7(a5)
        pea.l -$7(a5)
L097_00001656:
; H097+$00001656: 6100fb96  bsr.w $11ee
        bsr.w H097+$11EE
L097_0000165A:
; H097+$0000165A: 1400  move.b d0, d2
        move.b d0, d2
L097_0000165C:
; H097+$0000165C: 4a02  tst.b d2
        tst.b d2
L097_0000165E:
; H097+$0000165E: 66000032  bne.w $1692
        bne.w H097+$1692
L097_00001662:
; H097+$00001662: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001666:
; H097+$00001666: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000166A:
; H097+$0000166A: 4a2b0016  tst.b $16(a3)
        tst.b $16(a3)
L097_0000166E:
; H097+$0000166E: 6700001c  beq.w $168c
        beq.w H097+$168C
L097_00001672:
; H097+$00001672: 4a2dfff9  tst.b -$7(a5)
        tst.b -$7(a5)
L097_00001676:
; H097+$00001676: 67000014  beq.w $168c
        beq.w H097+$168C
L097_0000167A:
; H097+$0000167A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H096+$10FA (sub_H096_000010FA)
L097_0000167E:
; H097+$0000167E: 4eb9000010fa  jsr $10fa.l
        jsr (H096+$10FA).l
L097_00001684:
; H097+$00001684: 1b40fff8  move.b d0, -$8(a5)
        move.b d0, -$8(a5)
L097_00001688:
; H097+$00001688: 60000006  bra.w $1690
        bra.w H097+$1690
L097_0000168C:
; H097+$0000168C: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L097_00001690:
; H097+$00001690: 60a2  bra.b $1634
        bra.b H097+$1634
L097_00001692:
; H097+$00001692: 4a2dfff8  tst.b -$8(a5)
        tst.b -$8(a5)
L097_00001696:
; H097+$00001696: 6700002c  beq.w $16c4
        beq.w H097+$16C4
L097_0000169A:
; H097+$0000169A: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000169E:
; H097+$0000169E: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000016A2:
; H097+$000016A2: 422b0008  clr.b $8(a3)
        clr.b $8(a3)
L097_000016A6:
; H097+$000016A6: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000016AA:
; H097+$000016AA: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000016AE:
; H097+$000016AE: 422b0016  clr.b $16(a3)
        clr.b $16(a3)
L097_000016B2:
; H097+$000016B2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_000016B6:
; H097+$000016B6: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_000016BC:
; H097+$000016BC: 1b40fff8  move.b d0, -$8(a5)
        move.b d0, -$8(a5)
L097_000016C0:
; H097+$000016C0: 60000104  bra.w $17c6
        bra.w H097+$17C6
L097_000016C4:
; H097+$000016C4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000016C8:
; H097+$000016C8: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000016CC:
; H097+$000016CC: 7400  moveq #$0, d2
        moveq #0, d2
L097_000016CE:
; H097+$000016CE: 142b0017  move.b $17(a3), d2
        move.b $17(a3), d2
L097_000016D2:
; H097+$000016D2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_000016D4:
; H097+$000016D4: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L097_000016D8:
; H097+$000016D8: 47ecffc4  lea.l -$3c(a4), a3
        lea.l -$3c(a4), a3
L097_000016DC:
; H097+$000016DC: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L097_000016E0:
; H097+$000016E0: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_000016E2:
; H097+$000016E2: e344  asl.w #$1, d4
        asl.w #$1, d4
L097_000016E4:
; H097+$000016E4: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L097_000016E8:
; H097+$000016E8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_000016EC:
; H097+$000016EC: d4734000  add.w (a3, d4.w), d2
        add.w (a3, d4.w), d2
L097_000016F0:
; H097+$000016F0: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_000016F6:
; H097+$000016F6: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L097_000016FA:
; H097+$000016FA: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L097_000016FE:
; H097+$000016FE: 0c6d0006fffa  cmpi.w #$6, -$6(a5)
        cmpi.w #$6, -$6(a5)
L097_00001704:
; H097+$00001704: 6700001c  beq.w $1722
        beq.w H097+$1722
L097_00001708:
; H097+$00001708: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L097_0000170C:
; H097+$0000170C: 5842  addq.w #$4, d2
        addq.w #$4, d2
L097_0000170E:
; H097+$0000170E: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_00001714:
; H097+$00001714: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L097_00001718:
; H097+$00001718: 382cffc2  move.w -$3e(a4), d4
        move.w -$3e(a4), d4
L097_0000171C:
; H097+$0000171C: b842  cmp.w d2, d4
        cmp.w d2, d4
L097_0000171E:
; H097+$0000171E: 6600008c  bne.w $17ac
        bne.w H097+$17AC
L097_00001722:
; H097+$00001722: 526cffc0  addq.w #$1, -$40(a4)
        addq.w #$1, -$40(a4)
L097_00001726:
; H097+$00001726: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000172A:
; H097+$0000172A: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000172E:
; H097+$0000172E: 226d000c  movea.l $c(a5), a1
        movea.l $c(a5), a1
L097_00001732:
; H097+$00001732: 24690192  movea.l $192(a1), a2
        movea.l $192(a1), a2
L097_00001736:
; H097+$00001736: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001738:
; H097+$00001738: 142a0017  move.b $17(a2), d2
        move.b $17(a2), d2
L097_0000173C:
; H097+$0000173C: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L097_00001742:
; H097+$00001742: 84fc0006  divu.w #$6, d2
        divu.w #$6, d2
L097_00001746:
; H097+$00001746: 4842  swap d2
        swap d2
L097_00001748:
; H097+$00001748: 5242  addq.w #$1, d2
        addq.w #$1, d2
L097_0000174A:
; H097+$0000174A: 17420017  move.b d2, $17(a3)
        move.b d2, $17(a3)
L097_0000174E:
; H097+$0000174E: 0c6c0001ffc0  cmpi.w #$1, -$40(a4)
        cmpi.w #$1, -$40(a4)
L097_00001754:
; H097+$00001754: 63000056  bls.w $17ac
        bls.w H097+$17AC
L097_00001758:
; H097+$00001758: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000175C:
; H097+$0000175C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001760:
; H097+$00001760: 42ab000c  clr.l $c(a3)
        clr.l $c(a3)
L097_00001764:
; H097+$00001764: 0c6c0002ffc0  cmpi.w #$2, -$40(a4)
        cmpi.w #$2, -$40(a4)
L097_0000176A:
; H097+$0000176A: 63000018  bls.w $1784
        bls.w H097+$1784
L097_0000176E:
; H097+$0000176E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001772:
; H097+$00001772: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001776:
; H097+$00001776: 422b0008  clr.b $8(a3)
        clr.b $8(a3)
L097_0000177A:
; H097+$0000177A: 1b7c0001fff8  move.b #$1, -$8(a5)
        move.b #$1, -$8(a5)
L097_00001780:
; H097+$00001780: 6000002a  bra.w $17ac
        bra.w H097+$17AC
L097_00001784:
; H097+$00001784: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001788:
; H097+$00001788: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L097_0000178C:
; H097+$0000178C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L097_00001790:
; H097+$00001790: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H096+$4B86 (sub_H096_00004B86)
L097_00001792:
; H097+$00001792: 4eb900004b86  jsr $4b86.l
        jsr (H096+$4B86).l
L097_00001798:
; H097+$00001798: 1400  move.b d0, d2
        move.b d0, d2
L097_0000179A:
; H097+$0000179A: 4a02  tst.b d2
        tst.b d2
L097_0000179C:
; H097+$0000179C: 6600000e  bne.w $17ac
        bne.w H097+$17AC
L097_000017A0:
; H097+$000017A0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000017A4:
; H097+$000017A4: 6100ea9e  bsr.w $244
        bsr.w H097+$244
L097_000017A8:
; H097+$000017A8: 1b40fff8  move.b d0, -$8(a5)
        move.b d0, -$8(a5)
L097_000017AC:
; H097+$000017AC: 0c6d0006fffa  cmpi.w #$6, -$6(a5)
        cmpi.w #$6, -$6(a5)
L097_000017B2:
; H097+$000017B2: 6400000c  bcc.w $17c0
        bcc.w H097+$17C0
L097_000017B6:
; H097+$000017B6: 396dfffcffc2  move.w -$4(a5), -$3e(a4)
        move.w -$4(a5), -$3e(a4)
L097_000017BC:
; H097+$000017BC: 60000008  bra.w $17c6
        bra.w H097+$17C6
L097_000017C0:
; H097+$000017C0: 1b7c0001fff8  move.b #$1, -$8(a5)
        move.b #$1, -$8(a5)
L097_000017C6:
; H097+$000017C6: 4a2dfff8  tst.b -$8(a5)
        tst.b -$8(a5)
L097_000017CA:
; H097+$000017CA: 660000ec  bne.w $18b8
        bne.w H097+$18B8
L097_000017CE:
; H097+$000017CE: 4a39000024c8  tst.b $24c8.l
        tst.b (H005+$24C8).l
L097_000017D4:
; H097+$000017D4: 66000022  bne.w $17f8
        bne.w H097+$17F8
L097_000017D8:
; H097+$000017D8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000017DC:
; H097+$000017DC: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H048+$0230 (sub_H048_00000230)
L097_000017DE:
; H097+$000017DE: 4eb900000230  jsr $230.l
        jsr (H048+$230).l
L097_000017E4:
; H097+$000017E4: 1400  move.b d0, d2
        move.b d0, d2
L097_000017E6:
; H097+$000017E6: 4a02  tst.b d2
        tst.b d2
L097_000017E8:
; H097+$000017E8: 6600000e  bne.w $17f8
        bne.w H097+$17F8
L097_000017EC:
; H097+$000017EC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_000017F0:
; H097+$000017F0: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L097_000017F4:
; H097+$000017F4: 66000006  bne.w $17fc
        bne.w H097+$17FC
L097_000017F8:
; H097+$000017F8: 7401  moveq #$1, d2
        moveq #1, d2
L097_000017FA:
; H097+$000017FA: 6002  bra.b $17fe
        bra.b H097+$17FE
L097_000017FC:
; H097+$000017FC: 7400  moveq #$0, d2
        moveq #0, d2
L097_000017FE:
; H097+$000017FE: 13c2000024c6  move.b d2, $24c6.l
        move.b d2, (H005+$24C6).l
L097_00001804:
; H097+$00001804: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001808:
; H097+$00001808: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L097_0000180C:
; H097+$0000180C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L097_0000180E:
; H097+$0000180E: 4227  clr.b -(a7)
        clr.b -(a7)
L097_00001810:
; H097+$00001810: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H048+$0FEC (sub_H048_00000FEC)
L097_00001812:
; H097+$00001812: 4eb900000fec  jsr $fec.l
        jsr (H048+$FEC).l
L097_00001818:
; H097+$00001818: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_0000181C:
; H097+$0000181C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001820:
; H097+$00001820: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001824:
; H097+$00001824: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001826:
; H097+$00001826: 142b000b  move.b $b(a3), d2
        move.b $b(a3), d2
L097_0000182A:
; H097+$0000182A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H096+$0C3C (sub_H096_00000C3C)
L097_0000182C:
; H097+$0000182C: 4eb900000c3c  jsr $c3c.l
        jsr (H096+$C3C).l
L097_00001832:
; H097+$00001832: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001836:
; H097+$00001836: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L097_0000183A:
; H097+$0000183A: 66000014  bne.w $1850
        bne.w H097+$1850
L097_0000183E:
; H097+$0000183E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_00001842:
; H097+$00001842: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_00001848:
; H097+$00001848: 1b40fff8  move.b d0, -$8(a5)
        move.b d0, -$8(a5)
L097_0000184C:
; H097+$0000184C: 6000006a  bra.w $18b8
        bra.w H097+$18B8
L097_00001850:
; H097+$00001850: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001854:
; H097+$00001854: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001858:
; H097+$00001858: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000185A:
; H097+$0000185A: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_0000185E:
; H097+$0000185E: 4a42  tst.w d2
        tst.w d2
L097_00001860:
; H097+$00001860: 6300001c  bls.w $187e
        bls.w H097+$187E
L097_00001864:
; H097+$00001864: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001868:
; H097+$00001868: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000186C:
; H097+$0000186C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001870:
; H097+$00001870: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001872:
; H097+$00001872: 142b000b  move.b $b(a3), d2
        move.b $b(a3), d2
L097_00001876:
; H097+$00001876: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H096+$099C (sub_H096_0000099C)
L097_00001878:
; H097+$00001878: 4eb90000099c  jsr $99c.l
        jsr (H096+$99C).l
L097_0000187E:
; H097+$0000187E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001882:
; H097+$00001882: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L097_00001886:
; H097+$00001886: 67000014  beq.w $189c
        beq.w H097+$189C
L097_0000188A:
; H097+$0000188A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$135A (sub_H063_0000135A)
L097_0000188E:
; H097+$0000188E: 4eb90000135a  jsr $135a.l
        jsr (H063+$135A).l
L097_00001894:
; H097+$00001894: 1400  move.b d0, d2
        move.b d0, d2
L097_00001896:
; H097+$00001896: 4a02  tst.b d2
        tst.b d2
L097_00001898:
; H097+$00001898: 67000010  beq.w $18aa
        beq.w H097+$18AA
L097_0000189C:
; H097+$0000189C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_000018A0:
; H097+$000018A0: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_000018A6:
; H097+$000018A6: 1b40fff8  move.b d0, -$8(a5)
        move.b d0, -$8(a5)
L097_000018AA:
; H097+$000018AA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000018AE:
; H097+$000018AE: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H062+$1038 (trampoline_H062_1262)
L097_000018B2:
; H097+$000018B2: 4eb900001038  jsr $1038.l
        jsr (H062+$1038).l
L097_000018B8:
; H097+$000018B8: 6000000e  bra.w $18c8
        bra.w H097+$18C8
L097_000018BC:
; H097+$000018BC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000018C0:
; H097+$000018C0: 6100e982  bsr.w $244
        bsr.w H097+$244
L097_000018C4:
; H097+$000018C4: 1b40fff8  move.b d0, -$8(a5)
        move.b d0, -$8(a5)
L097_000018C8:
; H097+$000018C8: 4e5d  unlk a5
        unlk a5
L097_000018CA:
; H097+$000018CA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_000018CC:
; H097+$000018CC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_000018CE:
; H097+$000018CE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_000018D0:
; H097+$000018D0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_000018D2 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H062+$083E, H063+$3980, H096+$1562, H048+$0F88.
;   - Calls H062+$083E.
;   - Calls H063+$3980.
;   - Calls H096+$1562.
;   - Calls H048+$0F88.
;   - Calls H048+$0FBA.
;   - Calls H077+$0378.
;   - Calls H063+$2BDE.
; Direct callers: H097+$1F88
; --------------------------------------------------------------------------
L097_000018D2:
; H097+$000018D2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_000018D4:
; H097+$000018D4: 287ae7c8  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_000018D8:
; H097+$000018D8: 4e55ffe8  link.w a5, #$ffe8
        link.w a5, #$ffe8
L097_000018DC:
; H097+$000018DC: 397c0008ffc2  move.w #$8, -$3e(a4)
        move.w #$8, -$3e(a4)
L097_000018E2:
; H097+$000018E2: 426cffc0  clr.w -$40(a4)
        clr.w -$40(a4)
L097_000018E6:
; H097+$000018E6: 426cffbe  clr.w -$42(a4)
        clr.w -$42(a4)
L097_000018EA:
; H097+$000018EA: 426dffe8  clr.w -$18(a5)
        clr.w -$18(a5)
L097_000018EE:
; H097+$000018EE: 1b7c0001fffe  move.b #$1, -$2(a5)
        move.b #$1, -$2(a5)
L097_000018F4:
; H097+$000018F4: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L097_000018F8:
; H097+$000018F8: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L097_000018FC:
; H097+$000018FC: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
; -> H062+$083E (trampoline_H062_0F04)
L097_00001900:
; H097+$00001900: 4eb90000083e  jsr $83e.l
        jsr (H062+$83E).l
L097_00001906:
; H097+$00001906: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_0000190A:
; H097+$0000190A: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L097_0000190E:
; H097+$0000190E: 66000020  bne.w $1930
        bne.w H097+$1930
L097_00001912:
; H097+$00001912: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$3980 (sub_H063_00003980)
L097_00001916:
; H097+$00001916: 4eb900003980  jsr $3980.l
        jsr (H063+$3980).l
L097_0000191C:
; H097+$0000191C: 1400  move.b d0, d2
        move.b d0, d2
L097_0000191E:
; H097+$0000191E: 4a02  tst.b d2
        tst.b d2
L097_00001920:
; H097+$00001920: 6700000e  beq.w $1930
        beq.w H097+$1930
L097_00001924:
; H097+$00001924: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001928:
; H097+$00001928: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000192C:
; H097+$0000192C: 426b0004  clr.w $4(a3)
        clr.w $4(a3)
L097_00001930:
; H097+$00001930: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001934:
; H097+$00001934: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001938:
; H097+$00001938: 4a6b0004  tst.w $4(a3)
        tst.w $4(a3)
L097_0000193C:
; H097+$0000193C: 66000006  bne.w $1944
        bne.w H097+$1944
L097_00001940:
; H097+$00001940: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L097_00001944:
; H097+$00001944: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L097_00001948:
; H097+$00001948: 66000406  bne.w $1d50
        bne.w H097+$1D50
L097_0000194C:
; H097+$0000194C: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L097_00001950:
; H097+$00001950: 670003fe  beq.w $1d50
        beq.w H097+$1D50
L097_00001954:
; H097+$00001954: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001958:
; H097+$00001958: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000195C:
; H097+$0000195C: 4a2b0016  tst.b $16(a3)
        tst.b $16(a3)
L097_00001960:
; H097+$00001960: 67000042  beq.w $19a4
        beq.w H097+$19A4
L097_00001964:
; H097+$00001964: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001968:
; H097+$00001968: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_0000196C:
; H097+$0000196C: 7400  moveq #$0, d2
        moveq #0, d2
L097_0000196E:
; H097+$0000196E: 142b0008  move.b $8(a3), d2
        move.b $8(a3), d2
L097_00001972:
; H097+$00001972: 4a42  tst.w d2
        tst.w d2
L097_00001974:
; H097+$00001974: 6300002e  bls.w $19a4
        bls.w H097+$19A4
L097_00001978:
; H097+$00001978: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000197C:
; H097+$0000197C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001980:
; H097+$00001980: 4a6b0004  tst.w $4(a3)
        tst.w $4(a3)
L097_00001984:
; H097+$00001984: 6f00001e  ble.w $19a4
        ble.w H097+$19A4
L097_00001988:
; H097+$00001988: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_0000198C:
; H097+$0000198C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001990:
; H097+$00001990: 0c6b00140004  cmpi.w #$14, $4(a3)
        cmpi.w #$14, $4(a3)
L097_00001996:
; H097+$00001996: 6c00000c  bge.w $19a4
        bge.w H097+$19A4
L097_0000199A:
; H097+$0000199A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_0000199E:
; H097+$0000199E: 6100fa8c  bsr.w $142c
        bsr.w H097+$142C
L097_000019A2:
; H097+$000019A2: 60c0  bra.b $1964
        bra.b H097+$1964
L097_000019A4:
; H097+$000019A4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000019A8:
; H097+$000019A8: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000019AC:
; H097+$000019AC: 4a6b0004  tst.w $4(a3)
        tst.w $4(a3)
L097_000019B0:
; H097+$000019B0: 67000014  beq.w $19c6
        beq.w H097+$19C6
L097_000019B4:
; H097+$000019B4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_000019B8:
; H097+$000019B8: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_000019BC:
; H097+$000019BC: 0c6b00140004  cmpi.w #$14, $4(a3)
        cmpi.w #$14, $4(a3)
L097_000019C2:
; H097+$000019C2: 6600000a  bne.w $19ce
        bne.w H097+$19CE
L097_000019C6:
; H097+$000019C6: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L097_000019CA:
; H097+$000019CA: 60000006  bra.w $19d2
        bra.w H097+$19D2
L097_000019CE:
; H097+$000019CE: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L097_000019D2:
; H097+$000019D2: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L097_000019D6:
; H097+$000019D6: 66000374  bne.w $1d4c
        bne.w H097+$1D4C
L097_000019DA:
; H097+$000019DA: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L097_000019DE:
; H097+$000019DE: 6700036c  beq.w $1d4c
        beq.w H097+$1D4C
L097_000019E2:
; H097+$000019E2: 526dffe8  addq.w #$1, -$18(a5)
        addq.w #$1, -$18(a5)
L097_000019E6:
; H097+$000019E6: 0c6d0014ffe8  cmpi.w #$14, -$18(a5)
        cmpi.w #$14, -$18(a5)
L097_000019EC:
; H097+$000019EC: 6300001c  bls.w $1a0a
        bls.w H097+$1A0A
L097_000019F0:
; H097+$000019F0: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L097_000019F6:
; H097+$000019F6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_000019FA:
; H097+$000019FA: 6100e848  bsr.w $244
        bsr.w H097+$244
L097_000019FE:
; H097+$000019FE: 1400  move.b d0, d2
        move.b d0, d2
L097_00001A00:
; H097+$00001A00: 4a02  tst.b d2
        tst.b d2
L097_00001A02:
; H097+$00001A02: 57c2  seq.b d2
        seq.b d2
L097_00001A04:
; H097+$00001A04: 4402  neg.b d2
        neg.b d2
L097_00001A06:
; H097+$00001A06: 1b42fffe  move.b d2, -$2(a5)
        move.b d2, -$2(a5)
L097_00001A0A:
; H097+$00001A0A: 4239000024c8  clr.b $24c8.l
        clr.b (H005+$24C8).l
L097_00001A10:
; H097+$00001A10: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L097_00001A16:
; H097+$00001A16: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001A1A:
; H097+$00001A1A: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L097_00001A1E:
; H097+$00001A1E: 67000026  beq.w $1a46
        beq.w H097+$1A46
L097_00001A22:
; H097+$00001A22: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001A26:
; H097+$00001A26: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L097_00001A2A:
; H097+$00001A2A: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001A2C:
; H097+$00001A2C: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L097_00001A30:
; H097+$00001A30: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L097_00001A34:
; H097+$00001A34: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L097_00001A3A:
; H097+$00001A3A: 7800  moveq #$0, d4
        moveq #0, d4
L097_00001A3C:
; H097+$00001A3C: 1833280e  move.b $e(a3, d2.l), d4
        move.b $e(a3, d2.l), d4
L097_00001A40:
; H097+$00001A40: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_00001A42:
; H097+$00001A42: 3b44fffc  move.w d4, -$4(a5)
        move.w d4, -$4(a5)
L097_00001A46:
; H097+$00001A46: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L097_00001A4A:
; H097+$00001A4A: 6700000c  beq.w $1a58
        beq.w H097+$1A58
L097_00001A4E:
; H097+$00001A4E: 0c6d00fffffc  cmpi.w #$ff, -$4(a5)
        cmpi.w #$ff, -$4(a5)
L097_00001A54:
; H097+$00001A54: 65000008  bcs.w $1a5e
        bcs.w H097+$1A5E
L097_00001A58:
; H097+$00001A58: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L097_00001A5E:
; H097+$00001A5E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001A62:
; H097+$00001A62: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001A66:
; H097+$00001A66: 2b6b000cffee  move.l $c(a3), -$12(a5)
        move.l $c(a3), -$12(a5)
L097_00001A6C:
; H097+$00001A6C: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L097_00001A70:
; H097+$00001A70: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L097_00001A74:
; H097+$00001A74: 6700000e  beq.w $1a84
        beq.w H097+$1A84
L097_00001A78:
; H097+$00001A78: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L097_00001A7C:
; H097+$00001A7C: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L097_00001A80:
; H097+$00001A80: 66000006  bne.w $1a88
        bne.w H097+$1A88
L097_00001A84:
; H097+$00001A84: 42adffee  clr.l -$12(a5)
        clr.l -$12(a5)
L097_00001A88:
; H097+$00001A88: 4aadffee  tst.l -$12(a5)
        tst.l -$12(a5)
L097_00001A8C:
; H097+$00001A8C: 67000094  beq.w $1b22
        beq.w H097+$1B22
L097_00001A90:
; H097+$00001A90: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001A94:
; H097+$00001A94: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H096+$1562 (trampoline_H096_1600)
L097_00001A98:
; H097+$00001A98: 4eb900001562  jsr $1562.l
        jsr (H096+$1562).l
L097_00001A9E:
; H097+$00001A9E: 1400  move.b d0, d2
        move.b d0, d2
L097_00001AA0:
; H097+$00001AA0: 4a02  tst.b d2
        tst.b d2
L097_00001AA2:
; H097+$00001AA2: 6700007e  beq.w $1b22
        beq.w H097+$1B22
L097_00001AA6:
; H097+$00001AA6: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L097_00001AAA:
; H097+$00001AAA: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L097_00001AB0:
; H097+$00001AB0: 3b40ffec  move.w d0, -$14(a5)
        move.w d0, -$14(a5)
L097_00001AB4:
; H097+$00001AB4: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L097_00001AB8:
; H097+$00001AB8: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L097_00001ABE:
; H097+$00001ABE: 3b40ffea  move.w d0, -$16(a5)
        move.w d0, -$16(a5)
L097_00001AC2:
; H097+$00001AC2: 3b6dfffcfffa  move.w -$4(a5), -$6(a5)
        move.w -$4(a5), -$6(a5)
L097_00001AC8:
; H097+$00001AC8: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L097_00001ACE:
; H097+$00001ACE: 422b0008  clr.b $8(a3)
        clr.b $8(a3)
L097_00001AD2:
; H097+$00001AD2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L097_00001AD6:
; H097+$00001AD6: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L097_00001ADC:
; H097+$00001ADC: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L097_00001ADE:
; H097+$00001ADE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L097_00001AE2:
; H097+$00001AE2: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L097_00001AE8:
; H097+$00001AE8: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L097_00001AEA:
; H097+$00001AEA: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L097_00001AEE:
; H097+$00001AEE: 486dffea  pea.l -$16(a5)
        pea.l -$16(a5)
L097_00001AF2:
; H097+$00001AF2: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L097_00001AF6:
; H097+$00001AF6: 2f3900002ade  move.l $2ade.l, -(a7)
        move.l (H005+$2ADE).l, -(a7)
; -> H077+$0378 (sub_H077_00000378)
L097_00001AFC:
; H097+$00001AFC: 4eb900000378  jsr $378.l
        jsr (H077+$378).l
L097_00001B02:
; H097+$00001B02: 1400  move.b d0, d2
        move.b d0, d2
L097_00001B04:
; H097+$00001B04: 4a02  tst.b d2
        tst.b d2
L097_00001B06:
; H097+$00001B06: 6700001a  beq.w $1b22
        beq.w H097+$1B22
L097_00001B0A:
; H097+$00001B0A: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001B0C:
; H097+$00001B0C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L097_00001B10:
; H097+$00001B10: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L097_00001B12:
; H097+$00001B12: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L097_00001B16:
; H097+$00001B16: 6200000a  bhi.w $1b22
        bhi.w H097+$1B22
L097_00001B1A:
; H097+$00001B1A: 13fc0001000024c8  move.b #$1, $24c8.l
        move.b #$1, (H005+$24C8).l
L097_00001B22:
; H097+$00001B22: 4a39000024c8  tst.b $24c8.l
        tst.b (H005+$24C8).l
L097_00001B28:
; H097+$00001B28: 66000108  bne.w $1c32
        bne.w H097+$1C32
L097_00001B2C:
; H097+$00001B2C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001B30:
; H097+$00001B30: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H063+$2BDE (sub_H063_00002BDE)
L097_00001B34:
; H097+$00001B34: 4eb900002bde  jsr $2bde.l
        jsr (H063+$2BDE).l
L097_00001B3A:
; H097+$00001B3A: 3b40fff8  move.w d0, -$8(a5)
        move.w d0, -$8(a5)
L097_00001B3E:
; H097+$00001B3E: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L097_00001B42:
; H097+$00001B42: 66000038  bne.w $1b7c
        bne.w H097+$1B7C
L097_00001B46:
; H097+$00001B46: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001B4A:
; H097+$00001B4A: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L097_00001B4E:
; H097+$00001B4E: 4227  clr.b -(a7)
        clr.b -(a7)
L097_00001B50:
; H097+$00001B50: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H096+$4B86 (sub_H096_00004B86)
L097_00001B52:
; H097+$00001B52: 4eb900004b86  jsr $4b86.l
        jsr (H096+$4B86).l
L097_00001B58:
; H097+$00001B58: 1400  move.b d0, d2
        move.b d0, d2
L097_00001B5A:
; H097+$00001B5A: 4a02  tst.b d2
        tst.b d2
L097_00001B5C:
; H097+$00001B5C: 6700000e  beq.w $1b6c
        beq.w H097+$1B6C
L097_00001B60:
; H097+$00001B60: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001B64:
; H097+$00001B64: 6100f8c6  bsr.w $142c
        bsr.w H097+$142C
L097_00001B68:
; H097+$00001B68: 6000000e  bra.w $1b78
        bra.w H097+$1B78
L097_00001B6C:
; H097+$00001B6C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001B70:
; H097+$00001B70: 6100e6d2  bsr.w $244
        bsr.w H097+$244
L097_00001B74:
; H097+$00001B74: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L097_00001B78:
; H097+$00001B78: 600000b8  bra.w $1c32
        bra.w H097+$1C32
L097_00001B7C:
; H097+$00001B7C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00001B80:
; H097+$00001B80: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00001B84:
; H097+$00001B84: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_00001B8A:
; H097+$00001B8A: 3b40fff6  move.w d0, -$a(a5)
        move.w d0, -$a(a5)
L097_00001B8E:
; H097+$00001B8E: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L097_00001B92:
; H097+$00001B92: 5342  subq.w #$1, d2
        subq.w #$1, d2
L097_00001B94:
; H097+$00001B94: 47f900002444  lea.l $2444.l, a3
        lea.l (H005+$2444).l, a3
L097_00001B9A:
; H097+$00001B9A: 7800  moveq #$0, d4
        moveq #0, d4
L097_00001B9C:
; H097+$00001B9C: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L097_00001BA0:
; H097+$00001BA0: 5344  subq.w #$1, d4
        subq.w #$1, d4
L097_00001BA2:
; H097+$00001BA2: e544  asl.w #$2, d4
        asl.w #$2, d4
L097_00001BA4:
; H097+$00001BA4: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L097_00001BAA:
; H097+$00001BAA: 2b734000ffee  move.l (a3, d4.w), -$12(a5)
        move.l (a3, d4.w), -$12(a5)
L097_00001BB0:
; H097+$00001BB0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$3698 (sub_H063_00003698)
L097_00001BB4:
; H097+$00001BB4: 4eb900003698  jsr $3698.l
        jsr (H063+$3698).l
L097_00001BBA:
; H097+$00001BBA: 1400  move.b d0, d2
        move.b d0, d2
L097_00001BBC:
; H097+$00001BBC: 4a02  tst.b d2
        tst.b d2
L097_00001BBE:
; H097+$00001BBE: 6700003c  beq.w $1bfc
        beq.w H097+$1BFC
L097_00001BC2:
; H097+$00001BC2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$3734 (sub_H063_00003734)
L097_00001BC6:
; H097+$00001BC6: 4eb900003734  jsr $3734.l
        jsr (H063+$3734).l
L097_00001BCC:
; H097+$00001BCC: 1400  move.b d0, d2
        move.b d0, d2
L097_00001BCE:
; H097+$00001BCE: 4a02  tst.b d2
        tst.b d2
L097_00001BD0:
; H097+$00001BD0: 6600002a  bne.w $1bfc
        bne.w H097+$1BFC
L097_00001BD4:
; H097+$00001BD4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001BD8:
; H097+$00001BD8: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H063+$2BDE (sub_H063_00002BDE)
L097_00001BDC:
; H097+$00001BDC: 4eb900002bde  jsr $2bde.l
        jsr (H063+$2BDE).l
L097_00001BE2:
; H097+$00001BE2: 3400  move.w d0, d2
        move.w d0, d2
L097_00001BE4:
; H097+$00001BE4: 4a42  tst.w d2
        tst.w d2
L097_00001BE6:
; H097+$00001BE6: 63000014  bls.w $1bfc
        bls.w H097+$1BFC
L097_00001BEA:
; H097+$00001BEA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001BEE:
; H097+$00001BEE: 6100f024  bsr.w $c14
        bsr.w H097+$C14
L097_00001BF2:
; H097+$00001BF2: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L097_00001BF8:
; H097+$00001BF8: 60000038  bra.w $1c32
        bra.w H097+$1C32
L097_00001BFC:
; H097+$00001BFC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001C00:
; H097+$00001C00: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H063+$2DC6 (sub_H063_00002DC6)
L097_00001C04:
; H097+$00001C04: 4eb900002dc6  jsr $2dc6.l
        jsr (H063+$2DC6).l
L097_00001C0A:
; H097+$00001C0A: 3400  move.w d0, d2
        move.w d0, d2
L097_00001C0C:
; H097+$00001C0C: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L097_00001C10:
; H097+$00001C10: 67000018  beq.w $1c2a
        beq.w H097+$1C2A
L097_00001C14:
; H097+$00001C14: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001C18:
; H097+$00001C18: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H096+$1562 (trampoline_H096_1600)
L097_00001C1C:
; H097+$00001C1C: 4eb900001562  jsr $1562.l
        jsr (H096+$1562).l
L097_00001C22:
; H097+$00001C22: 1400  move.b d0, d2
        move.b d0, d2
L097_00001C24:
; H097+$00001C24: 4a02  tst.b d2
        tst.b d2
L097_00001C26:
; H097+$00001C26: 6700000a  beq.w $1c32
        beq.w H097+$1C32
L097_00001C2A:
; H097+$00001C2A: 13fc0001000024c8  move.b #$1, $24c8.l
        move.b #$1, (H005+$24C8).l
L097_00001C32:
; H097+$00001C32: 4a39000024c8  tst.b $24c8.l
        tst.b (H005+$24C8).l
L097_00001C38:
; H097+$00001C38: 67000034  beq.w $1c6e
        beq.w H097+$1C6E
L097_00001C3C:
; H097+$00001C3C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L097_00001C40:
; H097+$00001C40: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L097_00001C46:
; H097+$00001C46: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L097_00001C48:
; H097+$00001C48: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L097_00001C4C:
; H097+$00001C4C: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L097_00001C52:
; H097+$00001C52: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L097_00001C54:
; H097+$00001C54: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L097_00001C58:
; H097+$00001C58: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001C5C:
; H097+$00001C5C: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H063+$3CA0 (sub_H063_00003CA0)
L097_00001C60:
; H097+$00001C60: 4eb900003ca0  jsr $3ca0.l
        jsr (H063+$3CA0).l
L097_00001C66:
; H097+$00001C66: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
; -> H048+$0DF2 (sub_H048_00000DF2)
L097_00001C68:
; H097+$00001C68: 4eb900000df2  jsr $df2.l
        jsr (H048+$DF2).l
L097_00001C6E:
; H097+$00001C6E: 4a39000024c8  tst.b $24c8.l
        tst.b (H005+$24C8).l
L097_00001C74:
; H097+$00001C74: 670000d6  beq.w $1d4c
        beq.w H097+$1D4C
L097_00001C78:
; H097+$00001C78: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001C7C:
; H097+$00001C7C: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H096+$1340 (sub_H096_00001340)
L097_00001C80:
; H097+$00001C80: 4eb900001340  jsr $1340.l
        jsr (H096+$1340).l
L097_00001C86:
; H097+$00001C86: 1400  move.b d0, d2
        move.b d0, d2
L097_00001C88:
; H097+$00001C88: 4a02  tst.b d2
        tst.b d2
L097_00001C8A:
; H097+$00001C8A: 67000014  beq.w $1ca0
        beq.w H097+$1CA0
L097_00001C8E:
; H097+$00001C8E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_00001C92:
; H097+$00001C92: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_00001C98:
; H097+$00001C98: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L097_00001C9C:
; H097+$00001C9C: 600000ae  bra.w $1d4c
        bra.w H097+$1D4C
L097_00001CA0:
; H097+$00001CA0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001CA4:
; H097+$00001CA4: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H096+$20E6 (sub_H096_000020E6)
L097_00001CA8:
; H097+$00001CA8: 4eb9000020e6  jsr $20e6.l
        jsr (H096+$20E6).l
L097_00001CAE:
; H097+$00001CAE: 42adfff2  clr.l -$e(a5)
        clr.l -$e(a5)
L097_00001CB2:
; H097+$00001CB2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$3698 (sub_H063_00003698)
L097_00001CB6:
; H097+$00001CB6: 4eb900003698  jsr $3698.l
        jsr (H063+$3698).l
L097_00001CBC:
; H097+$00001CBC: 1400  move.b d0, d2
        move.b d0, d2
L097_00001CBE:
; H097+$00001CBE: 4a02  tst.b d2
        tst.b d2
L097_00001CC0:
; H097+$00001CC0: 67000044  beq.w $1d06
        beq.w H097+$1D06
L097_00001CC4:
; H097+$00001CC4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001CC8:
; H097+$00001CC8: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
; -> H063+$37B2 (sub_H063_000037B2)
L097_00001CCC:
; H097+$00001CCC: 4eb9000037b2  jsr $37b2.l
        jsr (H063+$37B2).l
L097_00001CD2:
; H097+$00001CD2: 13c0000024c8  move.b d0, $24c8.l
        move.b d0, (H005+$24C8).l
L097_00001CD8:
; H097+$00001CD8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$3734 (sub_H063_00003734)
L097_00001CDC:
; H097+$00001CDC: 4eb900003734  jsr $3734.l
        jsr (H063+$3734).l
L097_00001CE2:
; H097+$00001CE2: 1400  move.b d0, d2
        move.b d0, d2
L097_00001CE4:
; H097+$00001CE4: 4a02  tst.b d2
        tst.b d2
L097_00001CE6:
; H097+$00001CE6: 6700001e  beq.w $1d06
        beq.w H097+$1D06
L097_00001CEA:
; H097+$00001CEA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001CEE:
; H097+$00001CEE: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H063+$2DC6 (sub_H063_00002DC6)
L097_00001CF2:
; H097+$00001CF2: 4eb900002dc6  jsr $2dc6.l
        jsr (H063+$2DC6).l
L097_00001CF8:
; H097+$00001CF8: 3400  move.w d0, d2
        move.w d0, d2
L097_00001CFA:
; H097+$00001CFA: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L097_00001CFE:
; H097+$00001CFE: 66000006  bne.w $1d06
        bne.w H097+$1D06
L097_00001D02:
; H097+$00001D02: 42adfff2  clr.l -$e(a5)
        clr.l -$e(a5)
L097_00001D06:
; H097+$00001D06: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001D0A:
; H097+$00001D0A: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
L097_00001D0E:
; H097+$00001D0E: 4227  clr.b -(a7)
        clr.b -(a7)
L097_00001D10:
; H097+$00001D10: 2f2dfff2  move.l -$e(a5), -(a7)
        move.l -$e(a5), -(a7)
L097_00001D14:
; H097+$00001D14: 486dffff  pea.l -$1(a5)
        pea.l -$1(a5)
; -> H096+$2182 (sub_H096_00002182)
L097_00001D18:
; H097+$00001D18: 4eb900002182  jsr $2182.l
        jsr (H096+$2182).l
L097_00001D1E:
; H097+$00001D1E: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L097_00001D22:
; H097+$00001D22: 67000016  beq.w $1d3a
        beq.w H097+$1D3A
L097_00001D26:
; H097+$00001D26: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001D2A:
; H097+$00001D2A: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001D2E:
; H097+$00001D2E: 422b0008  clr.b $8(a3)
        clr.b $8(a3)
L097_00001D32:
; H097+$00001D32: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L097_00001D36:
; H097+$00001D36: 60000014  bra.w $1d4c
        bra.w H097+$1D4C
L097_00001D3A:
; H097+$00001D3A: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L097_00001D3E:
; H097+$00001D3E: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L097_00001D42:
; H097+$00001D42: 66000008  bne.w $1d4c
        bne.w H097+$1D4C
L097_00001D46:
; H097+$00001D46: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L097_00001D4C:
; H097+$00001D4C: 6000fbf6  bra.w $1944
        bra.w H097+$1944
L097_00001D50:
; H097+$00001D50: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L097_00001D54:
; H097+$00001D54: 57c2  seq.b d2
        seq.b d2
L097_00001D56:
; H097+$00001D56: 4402  neg.b d2
        neg.b d2
L097_00001D58:
; H097+$00001D58: 1002  move.b d2, d0
        move.b d2, d0
L097_00001D5A:
; H097+$00001D5A: 60000002  bra.w $1d5e
        bra.w H097+$1D5E
L097_00001D5E:
; H097+$00001D5E: 4e5d  unlk a5
        unlk a5
L097_00001D60:
; H097+$00001D60: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_00001D62:
; H097+$00001D62: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00001D64:
; H097+$00001D64: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_00001D66:
; H097+$00001D66: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H097_00001D68 [partial]
; Purpose: Routine of the actions and control of the actors in combat module; calls H008+$139E, H063+$1EE8, H063+$2F12, H062+$156C.
;   - Calls H008+$139E.
;   - Calls H063+$1EE8.
;   - Calls H063+$2F12.
;   - Calls H062+$156C.
;   - Calls H063+$1DC2.
;   - Calls H033+$1426.
;   - Calls H096+$4B86.
; Direct callers: H059+$15B4, H059+$10B6
; --------------------------------------------------------------------------
L097_00001D68:
; H097+$00001D68: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L097_00001D6A:
; H097+$00001D6A: 287ae332  movea.l $9e(pc), a4
        movea.l H097+$9E(pc), a4
L097_00001D6E:
; H097+$00001D6E: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L097_00001D72:
; H097+$00001D72: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001D76:
; H097+$00001D76: 6100e338  bsr.w $b0
        bsr.w H097+$B0
L097_00001D7A:
; H097+$00001D7A: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
; -> H008+$139E (sub_H008_0000139E)
L097_00001D7E:
; H097+$00001D7E: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
; -> H063+$1EE8 (sub_H063_00001EE8)
L097_00001D84:
; H097+$00001D84: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
L097_00001D8A:
; H097+$00001D8A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001D8E:
; H097+$00001D8E: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L097_00001D92:
; H097+$00001D92: 66000010  bne.w $1da4
        bne.w H097+$1DA4
L097_00001D96:
; H097+$00001D96: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_00001D9A:
; H097+$00001D9A: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_00001DA0:
; H097+$00001DA0: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001DA4:
; H097+$00001DA4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001DA8:
; H097+$00001DA8: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001DAC:
; H097+$00001DAC: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001DAE:
; H097+$00001DAE: 142b0017  move.b $17(a3), d2
        move.b $17(a3), d2
L097_00001DB2:
; H097+$00001DB2: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_00001DB6:
; H097+$00001DB6: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L097_00001DBA:
; H097+$00001DBA: 67000024  beq.w $1de0
        beq.w H097+$1DE0
L097_00001DBE:
; H097+$00001DBE: 0c6d0004fffe  cmpi.w #$4, -$2(a5)
        cmpi.w #$4, -$2(a5)
L097_00001DC4:
; H097+$00001DC4: 6200001a  bhi.w $1de0
        bhi.w H097+$1DE0
L097_00001DC8:
; H097+$00001DC8: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00001DCC:
; H097+$00001DCC: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00001DD0:
; H097+$00001DD0: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_00001DD6:
; H097+$00001DD6: 3400  move.w d0, d2
        move.w d0, d2
L097_00001DD8:
; H097+$00001DD8: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L097_00001DDC:
; H097+$00001DDC: 6600004a  bne.w $1e28
        bne.w H097+$1E28
L097_00001DE0:
; H097+$00001DE0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00001DE4:
; H097+$00001DE4: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00001DE8:
; H097+$00001DE8: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_00001DEE:
; H097+$00001DEE: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L097_00001DF2:
; H097+$00001DF2: 0c6d0008fffe  cmpi.w #$8, -$2(a5)
        cmpi.w #$8, -$2(a5)
L097_00001DF8:
; H097+$00001DF8: 6600001c  bne.w $1e16
        bne.w H097+$1E16
L097_00001DFC:
; H097+$00001DFC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00001E00:
; H097+$00001E00: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00001E04:
; H097+$00001E04: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_00001E0A:
; H097+$00001E0A: 3400  move.w d0, d2
        move.w d0, d2
L097_00001E0C:
; H097+$00001E0C: 5842  addq.w #$4, d2
        addq.w #$4, d2
L097_00001E0E:
; H097+$00001E0E: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L097_00001E12:
; H097+$00001E12: 60000014  bra.w $1e28
        bra.w H097+$1E28
L097_00001E16:
; H097+$00001E16: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L097_00001E1A:
; H097+$00001E1A: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L097_00001E1E:
; H097+$00001E1E: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L097_00001E24:
; H097+$00001E24: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L097_00001E28:
; H097+$00001E28: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001E2C:
; H097+$00001E2C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001E30:
; H097+$00001E30: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L097_00001E34:
; H097+$00001E34: 17420017  move.b d2, $17(a3)
        move.b d2, $17(a3)
L097_00001E38:
; H097+$00001E38: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L097_00001E3C:
; H097+$00001E3C: 6600000e  bne.w $1e4c
        bne.w H097+$1E4C
L097_00001E40:
; H097+$00001E40: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001E44:
; H097+$00001E44: 6100e5f4  bsr.w $43a
        bsr.w H097+$43A
L097_00001E48:
; H097+$00001E48: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001E4C:
; H097+$00001E4C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001E50:
; H097+$00001E50: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001E54:
; H097+$00001E54: 4a2b0016  tst.b $16(a3)
        tst.b $16(a3)
L097_00001E58:
; H097+$00001E58: 6700002c  beq.w $1e86
        beq.w H097+$1E86
L097_00001E5C:
; H097+$00001E5C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001E60:
; H097+$00001E60: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001E64:
; H097+$00001E64: 4a2b0012  tst.b $12(a3)
        tst.b $12(a3)
L097_00001E68:
; H097+$00001E68: 6600001c  bne.w $1e86
        bne.w H097+$1E86
L097_00001E6C:
; H097+$00001E6C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001E70:
; H097+$00001E70: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L097_00001E74:
; H097+$00001E74: 486c004c  pea.l $4c(a4)
        pea.l $4c(a4)
L097_00001E78:
; H097+$00001E78: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L097_00001E7C:
; H097+$00001E7C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L097_00001E80:
; H097+$00001E80: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L097_00001E86:
; H097+$00001E86: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L097_00001E8A:
; H097+$00001E8A: 66000116  bne.w $1fa2
        bne.w H097+$1FA2
L097_00001E8E:
; H097+$00001E8E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001E92:
; H097+$00001E92: 6100e9fc  bsr.w $890
        bsr.w H097+$890
L097_00001E96:
; H097+$00001E96: 1400  move.b d0, d2
        move.b d0, d2
L097_00001E98:
; H097+$00001E98: 4a02  tst.b d2
        tst.b d2
L097_00001E9A:
; H097+$00001E9A: 67000014  beq.w $1eb0
        beq.w H097+$1EB0
L097_00001E9E:
; H097+$00001E9E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_00001EA2:
; H097+$00001EA2: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_00001EA8:
; H097+$00001EA8: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001EAC:
; H097+$00001EAC: 600000f4  bra.w $1fa2
        bra.w H097+$1FA2
L097_00001EB0:
; H097+$00001EB0: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001EB4:
; H097+$00001EB4: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001EB8:
; H097+$00001EB8: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001EBA:
; H097+$00001EBA: 1413  move.b (a3), d2
        move.b (a3), d2
L097_00001EBC:
; H097+$00001EBC: 4a42  tst.w d2
        tst.w d2
L097_00001EBE:
; H097+$00001EBE: 63000034  bls.w $1ef4
        bls.w H097+$1EF4
L097_00001EC2:
; H097+$00001EC2: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001EC6:
; H097+$00001EC6: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001ECA:
; H097+$00001ECA: 7400  moveq #$0, d2
        moveq #0, d2
L097_00001ECC:
; H097+$00001ECC: 1413  move.b (a3), d2
        move.b (a3), d2
L097_00001ECE:
; H097+$00001ECE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L097_00001ED0:
; H097+$00001ED0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L097_00001ED4:
; H097+$00001ED4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L097_00001ED8:
; H097+$00001ED8: 486dfffd  pea.l -$3(a5)
        pea.l -$3(a5)
; -> H033+$1426 (sub_H033_00001426)
L097_00001EDC:
; H097+$00001EDC: 4eb900001426  jsr $1426.l
        jsr (H033+$1426).l
L097_00001EE2:
; H097+$00001EE2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_00001EE6:
; H097+$00001EE6: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_00001EEC:
; H097+$00001EEC: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001EF0:
; H097+$00001EF0: 600000b0  bra.w $1fa2
        bra.w H097+$1FA2
L097_00001EF4:
; H097+$00001EF4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001EF8:
; H097+$00001EF8: 6100eb0a  bsr.w $a04
        bsr.w H097+$A04
L097_00001EFC:
; H097+$00001EFC: 1400  move.b d0, d2
        move.b d0, d2
L097_00001EFE:
; H097+$00001EFE: 4a02  tst.b d2
        tst.b d2
L097_00001F00:
; H097+$00001F00: 67000014  beq.w $1f16
        beq.w H097+$1F16
L097_00001F04:
; H097+$00001F04: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L097_00001F08:
; H097+$00001F08: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L097_00001F0E:
; H097+$00001F0E: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001F12:
; H097+$00001F12: 6000008e  bra.w $1fa2
        bra.w H097+$1FA2
L097_00001F16:
; H097+$00001F16: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001F1A:
; H097+$00001F1A: 6100eb6c  bsr.w $a88
        bsr.w H097+$A88
L097_00001F1E:
; H097+$00001F1E: 1400  move.b d0, d2
        move.b d0, d2
L097_00001F20:
; H097+$00001F20: 4a02  tst.b d2
        tst.b d2
L097_00001F22:
; H097+$00001F22: 6700000c  beq.w $1f30
        beq.w H097+$1F30
L097_00001F26:
; H097+$00001F26: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L097_00001F2C:
; H097+$00001F2C: 60000074  bra.w $1fa2
        bra.w H097+$1FA2
L097_00001F30:
; H097+$00001F30: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001F34:
; H097+$00001F34: 6100ecde  bsr.w $c14
        bsr.w H097+$C14
L097_00001F38:
; H097+$00001F38: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001F3C:
; H097+$00001F3C: 6100e172  bsr.w $b0
        bsr.w H097+$B0
L097_00001F40:
; H097+$00001F40: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001F44:
; H097+$00001F44: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L097_00001F48:
; H097+$00001F48: 66000058  bne.w $1fa2
        bne.w H097+$1FA2
L097_00001F4C:
; H097+$00001F4C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001F50:
; H097+$00001F50: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L097_00001F54:
; H097+$00001F54: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L097_00001F58:
; H097+$00001F58: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H096+$4B86 (sub_H096_00004B86)
L097_00001F5A:
; H097+$00001F5A: 4eb900004b86  jsr $4b86.l
        jsr (H096+$4B86).l
L097_00001F60:
; H097+$00001F60: 1400  move.b d0, d2
        move.b d0, d2
L097_00001F62:
; H097+$00001F62: 4a02  tst.b d2
        tst.b d2
L097_00001F64:
; H097+$00001F64: 6700002e  beq.w $1f94
        beq.w H097+$1F94
L097_00001F68:
; H097+$00001F68: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L097_00001F6C:
; H097+$00001F6C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L097_00001F70:
; H097+$00001F70: 4a6b0004  tst.w $4(a3)
        tst.w $4(a3)
L097_00001F74:
; H097+$00001F74: 6f00001e  ble.w $1f94
        ble.w H097+$1F94
L097_00001F78:
; H097+$00001F78: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L097_00001F7C:
; H097+$00001F7C: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L097_00001F80:
; H097+$00001F80: 67000012  beq.w $1f94
        beq.w H097+$1F94
L097_00001F84:
; H097+$00001F84: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001F88:
; H097+$00001F88: 6100f948  bsr.w $18d2
        bsr.w H097+$18D2
L097_00001F8C:
; H097+$00001F8C: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001F90:
; H097+$00001F90: 6000000e  bra.w $1fa0
        bra.w H097+$1FA0
L097_00001F94:
; H097+$00001F94: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L097_00001F98:
; H097+$00001F98: 6100e2aa  bsr.w $244
        bsr.w H097+$244
L097_00001F9C:
; H097+$00001F9C: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L097_00001FA0:
; H097+$00001FA0: 60a2  bra.b $1f44
        bra.b H097+$1F44
L097_00001FA2:
; H097+$00001FA2: 4e5d  unlk a5
        unlk a5
L097_00001FA4:
; H097+$00001FA4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_00001FA6:
; H097+$00001FA6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L097_00001FA8:
; H097+$00001FA8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L097_00001FAA:
; H097+$00001FAA: 4ed0  jmp (a0)
        jmp (a0)
L097_00001FAC:
; H097+$00001FAC: 397c0008ffc4  move.w #$8, -$3c(a4)
        move.w #$8, -$3c(a4)
L097_00001FB2:
; H097+$00001FB2: 397c0007ffc6  move.w #$7, -$3a(a4)
        move.w #$7, -$3a(a4)
L097_00001FB8:
; H097+$00001FB8: 397c0006ffc8  move.w #$6, -$38(a4)
        move.w #$6, -$38(a4)
L097_00001FBE:
; H097+$00001FBE: 397c0001ffca  move.w #$1, -$36(a4)
        move.w #$1, -$36(a4)
L097_00001FC4:
; H097+$00001FC4: 397c0002ffcc  move.w #$2, -$34(a4)
        move.w #$2, -$34(a4)
L097_00001FCA:
; H097+$00001FCA: 397c0008ffce  move.w #$8, -$32(a4)
        move.w #$8, -$32(a4)
L097_00001FD0:
; H097+$00001FD0: 397c0001ffd0  move.w #$1, -$30(a4)
        move.w #$1, -$30(a4)
L097_00001FD6:
; H097+$00001FD6: 397c0002ffd2  move.w #$2, -$2e(a4)
        move.w #$2, -$2e(a4)
L097_00001FDC:
; H097+$00001FDC: 397c0007ffd4  move.w #$7, -$2c(a4)
        move.w #$7, -$2c(a4)
L097_00001FE2:
; H097+$00001FE2: 397c0006ffd6  move.w #$6, -$2a(a4)
        move.w #$6, -$2a(a4)
L097_00001FE8:
; H097+$00001FE8: 397c0007ffd8  move.w #$7, -$28(a4)
        move.w #$7, -$28(a4)
L097_00001FEE:
; H097+$00001FEE: 397c0001ffda  move.w #$1, -$26(a4)
        move.w #$1, -$26(a4)
L097_00001FF4:
; H097+$00001FF4: 397c0008ffdc  move.w #$8, -$24(a4)
        move.w #$8, -$24(a4)
L097_00001FFA:
; H097+$00001FFA: 397c0006ffde  move.w #$6, -$22(a4)
        move.w #$6, -$22(a4)
L097_00002000:
; H097+$00002000: 397c0002ffe0  move.w #$2, -$20(a4)
        move.w #$2, -$20(a4)
L097_00002006:
; H097+$00002006: 397c0001ffe2  move.w #$1, -$1e(a4)
        move.w #$1, -$1e(a4)
L097_0000200C:
; H097+$0000200C: 397c0007ffe4  move.w #$7, -$1c(a4)
        move.w #$7, -$1c(a4)
L097_00002012:
; H097+$00002012: 397c0008ffe6  move.w #$8, -$1a(a4)
        move.w #$8, -$1a(a4)
L097_00002018:
; H097+$00002018: 397c0002ffe8  move.w #$2, -$18(a4)
        move.w #$2, -$18(a4)
L097_0000201E:
; H097+$0000201E: 397c0006ffea  move.w #$6, -$16(a4)
        move.w #$6, -$16(a4)
L097_00002024:
; H097+$00002024: 397c0008ffec  move.w #$8, -$14(a4)
        move.w #$8, -$14(a4)
L097_0000202A:
; H097+$0000202A: 397c0007ffee  move.w #$7, -$12(a4)
        move.w #$7, -$12(a4)
L097_00002030:
; H097+$00002030: 397c0006fff0  move.w #$6, -$10(a4)
        move.w #$6, -$10(a4)
L097_00002036:
; H097+$00002036: 397c0005fff2  move.w #$5, -$e(a4)
        move.w #$5, -$e(a4)
L097_0000203C:
; H097+$0000203C: 397c0004fff4  move.w #$4, -$c(a4)
        move.w #$4, -$c(a4)
L097_00002042:
; H097+$00002042: 397c0008fff6  move.w #$8, -$a(a4)
        move.w #$8, -$a(a4)
L097_00002048:
; H097+$00002048: 397c0001fff8  move.w #$1, -$8(a4)
        move.w #$1, -$8(a4)
L097_0000204E:
; H097+$0000204E: 397c0002fffa  move.w #$2, -$6(a4)
        move.w #$2, -$6(a4)
L097_00002054:
; H097+$00002054: 397c0003fffc  move.w #$3, -$4(a4)
        move.w #$3, -$4(a4)
L097_0000205A:
; H097+$0000205A: 397c0004fffe  move.w #$4, -$2(a4)
        move.w #$4, -$2(a4)
L097_00002060:
; H097+$00002060: 4e5d  unlk a5
        unlk a5
L097_00002062:
; H097+$00002062: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L097_00002064:
; H097+$00002064: 4e75  rts 
        rts 
; Preserved bytes H097+$00002066..$00002068; code/data not fully classified.
        dc.w $0000
; End H097: $2068 bytes
