; ============================================================================
; MODULE GUIDE H008
; UI interactions, choice requests and menus.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Gathers the UI interactions: choice requests, menus, messages and confirmations. The routines are meant to be called by the game modules, not only by the initial menu.
; --------------------------------------------------------------------------
; H008: 8660 original bytes; all offsets are section-relative.
        section H008,code
H008:
; Preserved bytes H008+$00000000..$0000009A; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$7374,$6172,$7420,$7465,$7374,$6368,$6970
        dc.w $616C,$6C6F,$6300,$6578,$6974,$2074,$6573,$7463
        dc.w $6869,$7061,$6C6C,$6F63,$0020,$4E65,$7874,$0020
        dc.w $5072,$6576,$0020,$4578,$6974,$0059,$6573,$204E
        dc.w $6F00,$0000,$0000
        dc.l H008+$00000052
; --------------------------------------------------------------------------
; ROUTINE: module_init_H008 [partial]
; Purpose: Entry of the UI interactions, choice requests and menus module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H008+$21CC.
; Direct callers: H000+$01B0
; --------------------------------------------------------------------------
L008_0000009A:
; H008+$0000009A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_0000009C:
; H008+$0000009C: 287afff8  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_000000A0:
; H008+$000000A0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L008_000000A4:
; H008+$000000A4: 60002126  bra.w $21cc
        bra.w H008+$21CC
; Preserved bytes H008+$000000A8..$00000102; code/data not fully classified.
        dc.w $2F0C,$287A,$FFEA,$4E55,$FFFC,$3F3C,$0013,$486C
        dc.w $0000,$3F2D,$000C,$4EB9
        dc.l H014+$00000018
        dc.w $3F3C,$0064,$3F3C,$0026,$3F3C,$0001,$4267,$486D
        dc.w $FFFC,$4EB9
        dc.l H029+$00000408
        dc.w $486D,$FFFC,$4EB9
        dc.l H029+$0000067A
        dc.w $3F3C,$0012,$486C,$0014,$3F2D,$000C,$4EB9
        dc.l H014+$00000018
        dc.w $4E5D,$285F,$205F,$548F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_00000102 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H013+$53B2, H013+$0B26, H008+$1496, H008+$16CA, H008+$177A, H013+$0D5A and 8 more
; --------------------------------------------------------------------------
L008_00000102:
; H008+$00000102: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_00000104:
; H008+$00000104: 287aff90  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_00000108:
; H008+$00000108: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L008_0000010C:
; H008+$0000010C: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L008_00000110:
; H008+$00000110: 2b6d000cfffc  move.l $c(a5), -$4(a5)
        move.l $c(a5), -$4(a5)
L008_00000116:
; H008+$00000116: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L008_0000011A:
; H008+$0000011A: 6700001e  beq.w $13a
        beq.w H008+$13A
L008_0000011E:
; H008+$0000011E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L008_00000122:
; H008+$00000122: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L008_00000126:
; H008+$00000126: 67000012  beq.w $13a
        beq.w H008+$13A
L008_0000012A:
; H008+$0000012A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_0000012E:
; H008+$0000012E: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L008_00000134:
; H008+$00000134: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L008_00000138:
; H008+$00000138: 60dc  bra.b $116
        bra.b H008+$116
L008_0000013A:
; H008+$0000013A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L008_0000013E:
; H008+$0000013E: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L008_00000142:
; H008+$00000142: 6600000e  bne.w $152
        bne.w H008+$152
L008_00000146:
; H008+$00000146: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L008_0000014A:
; H008+$0000014A: 6000000c  bra.w $158
        bra.w H008+$158
; Preserved bytes H008+$0000014E..$00000152; code/data not fully classified.
        dc.w $6000,$0008
L008_00000152:
; H008+$00000152: 7000  moveq #$0, d0
        moveq #0, d0
L008_00000154:
; H008+$00000154: 60000002  bra.w $158
        bra.w H008+$158
L008_00000158:
; H008+$00000158: 4e5d  unlk a5
        unlk a5
L008_0000015A:
; H008+$0000015A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_0000015C:
; H008+$0000015C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_0000015E:
; H008+$0000015E: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_00000160:
; H008+$00000160: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_00000162 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H008+$1B7A
; --------------------------------------------------------------------------
L008_00000162:
; H008+$00000162: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_00000164:
; H008+$00000164: 287aff30  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_00000168:
; H008+$00000168: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L008_0000016C:
; H008+$0000016C: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L008_00000170:
; H008+$00000170: 2b6d000cfffc  move.l $c(a5), -$4(a5)
        move.l $c(a5), -$4(a5)
L008_00000176:
; H008+$00000176: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L008_0000017A:
; H008+$0000017A: 67000012  beq.w $18e
        beq.w H008+$18E
L008_0000017E:
; H008+$0000017E: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L008_00000182:
; H008+$00000182: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_00000186:
; H008+$00000186: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L008_0000018C:
; H008+$0000018C: 60e8  bra.b $176
        bra.b H008+$176
L008_0000018E:
; H008+$0000018E: 302dfffa  move.w -$6(a5), d0
        move.w -$6(a5), d0
L008_00000192:
; H008+$00000192: 60000002  bra.w $196
        bra.w H008+$196
L008_00000196:
; H008+$00000196: 4e5d  unlk a5
        unlk a5
L008_00000198:
; H008+$00000198: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_0000019A:
; H008+$0000019A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_0000019C:
; H008+$0000019C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L008_0000019E:
; H008+$0000019E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_000001A0 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H008+$02B0, H008+$0488, H008+$11D6
; --------------------------------------------------------------------------
L008_000001A0:
; H008+$000001A0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_000001A2:
; H008+$000001A2: 287afef2  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_000001A6:
; H008+$000001A6: 4e550000  link.w a5, #$0
        link.w a5, #$0
L008_000001AA:
; H008+$000001AA: 7400  moveq #$0, d2
        moveq #0, d2
L008_000001AC:
; H008+$000001AC: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L008_000001B0:
; H008+$000001B0: 0c420041  cmpi.w #$41, d2
        cmpi.w #$41, d2
L008_000001B4:
; H008+$000001B4: 65000010  bcs.w $1c6
        bcs.w H008+$1C6
L008_000001B8:
; H008+$000001B8: 7400  moveq #$0, d2
        moveq #0, d2
L008_000001BA:
; H008+$000001BA: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L008_000001BE:
; H008+$000001BE: 0c42005a  cmpi.w #$5a, d2
        cmpi.w #$5a, d2
L008_000001C2:
; H008+$000001C2: 6300001e  bls.w $1e2
        bls.w H008+$1E2
L008_000001C6:
; H008+$000001C6: 7400  moveq #$0, d2
        moveq #0, d2
L008_000001C8:
; H008+$000001C8: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L008_000001CC:
; H008+$000001CC: 0c420030  cmpi.w #$30, d2
        cmpi.w #$30, d2
L008_000001D0:
; H008+$000001D0: 6500001a  bcs.w $1ec
        bcs.w H008+$1EC
L008_000001D4:
; H008+$000001D4: 7400  moveq #$0, d2
        moveq #0, d2
L008_000001D6:
; H008+$000001D6: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L008_000001DA:
; H008+$000001DA: 0c420039  cmpi.w #$39, d2
        cmpi.w #$39, d2
L008_000001DE:
; H008+$000001DE: 6200000c  bhi.w $1ec
        bhi.w H008+$1EC
L008_000001E2:
; H008+$000001E2: 7001  moveq #$1, d0
        moveq #1, d0
L008_000001E4:
; H008+$000001E4: 6000000c  bra.w $1f2
        bra.w H008+$1F2
; Preserved bytes H008+$000001E8..$000001EC; code/data not fully classified.
        dc.w $6000,$0008
L008_000001EC:
; H008+$000001EC: 7000  moveq #$0, d0
        moveq #0, d0
L008_000001EE:
; H008+$000001EE: 60000002  bra.w $1f2
        bra.w H008+$1F2
L008_000001F2:
; H008+$000001F2: 4e5d  unlk a5
        unlk a5
L008_000001F4:
; H008+$000001F4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_000001F6:
; H008+$000001F6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_000001F8:
; H008+$000001F8: 548f  addq.l #$2, a7
        addq.l #$2, a7
L008_000001FA:
; H008+$000001FA: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: UI_RequestChoice [partial]
; Purpose: Builds an interaction with prompt/choices and returns the answer.
;   - Used by the demo choice, by the confirmation messages and by many menus.
;   - Receives text, colours/coordinates and flags through the module stack.
;   - The complete signature and all the flags are not assigned yet.
; Direct callers: H001+$0150, H001+$0270, H008+$1D22, H008+$2094, H013+$3598, H013+$4B16, H047+$0B04, H057+$1E2A, H057+$2292, H057+$24F4 ...
; --------------------------------------------------------------------------
L008_000001FC:
; H008+$000001FC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_000001FE:
; H008+$000001FE: 287afe96  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_00000202:
; H008+$00000202: 4e55ff32  link.w a5, #$ff32
        link.w a5, #$ff32
L008_00000206:
; H008+$00000206: 6000036c  bra.w $574
        bra.w H008+$574
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_0000020A [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H026+$000C.
;   - Calls H026+$000C.
; Direct callers: H008+$0612
; --------------------------------------------------------------------------
L008_0000020A:
; H008+$0000020A: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L008_0000020E:
; H008+$0000020E: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L008_00000212:
; H008+$00000212: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000214:
; H008+$00000214: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_00000218:
; H008+$00000218: 6702  beq.b $21c
        beq.b H008+$21C
L008_0000021A:
; H008+$0000021A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_0000021C:
; H008+$0000021C: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_0000021E:
; H008+$0000021E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000222:
; H008+$00000222: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L008_00000226:
; H008+$00000226: 244f  movea.l a7, a2
        movea.l a7, a2
L008_00000228:
; H008+$00000228: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_0000022A:
; H008+$0000022A: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_0000022C:
; H008+$0000022C: 51cafffc  dbra d2, $22a
        dbra d2, H008+$22A
L008_00000230:
; H008+$00000230: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L008_00000236:
; H008+$00000236: 0c6d0014fffc  cmpi.w #$14, -$4(a5)
        cmpi.w #$14, -$4(a5)
L008_0000023C:
; H008+$0000023C: 6200003c  bhi.w $27a
        bhi.w H008+$27A
L008_00000240:
; H008+$00000240: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L008_00000244:
; H008+$00000244: 0c6d0001fffa  cmpi.w #$1, -$6(a5)
        cmpi.w #$1, -$6(a5)
L008_0000024A:
; H008+$0000024A: 62000028  bhi.w $274
        bhi.w H008+$274
L008_0000024E:
; H008+$0000024E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L008_00000252:
; H008+$00000252: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000254:
; H008+$00000254: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000256:
; H008+$00000256: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000025A:
; H008+$0000025A: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_0000025E:
; H008+$0000025E: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L008_00000262:
; H008+$00000262: e344  asl.w #$1, d4
        asl.w #$1, d4
L008_00000264:
; H008+$00000264: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L008_00000268:
; H008+$00000268: 37bc03e74000  move.w #$3e7, (a3, d4.w)
        move.w #$3e7, (a3, d4.w)
L008_0000026E:
; H008+$0000026E: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L008_00000272:
; H008+$00000272: 64d0  bcc.b $244
        bcc.b H008+$244
L008_00000274:
; H008+$00000274: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L008_00000278:
; H008+$00000278: 64bc  bcc.b $236
        bcc.b H008+$236
L008_0000027A:
; H008+$0000027A: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L008_00000280:
; H008+$00000280: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L008_00000284:
; H008+$00000284: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_00000288:
; H008+$00000288: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_0000028E:
; H008+$0000028E: 3b40fff8  move.w d0, -$8(a5)
        move.w d0, -$8(a5)
L008_00000292:
; H008+$00000292: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L008_00000296:
; H008+$00000296: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L008_0000029A:
; H008+$0000029A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L008_0000029E:
; H008+$0000029E: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L008_000002A0:
; H008+$000002A0: 6200008a  bhi.w $32c
        bhi.w H008+$32C
L008_000002A4:
; H008+$000002A4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L008_000002A8:
; H008+$000002A8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_000002AC:
; H008+$000002AC: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L008_000002B0:
; H008+$000002B0: 6100feee  bsr.w $1a0
        bsr.w H008+$1A0
L008_000002B4:
; H008+$000002B4: 1400  move.b d0, d2
        move.b d0, d2
L008_000002B6:
; H008+$000002B6: 4a02  tst.b d2
        tst.b d2
L008_000002B8:
; H008+$000002B8: 6700006a  beq.w $324
        beq.w H008+$324
L008_000002BC:
; H008+$000002BC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_000002C0:
; H008+$000002C0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000002C2:
; H008+$000002C2: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_000002C4:
; H008+$000002C4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000002C8:
; H008+$000002C8: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_000002CC:
; H008+$000002CC: 0c7303e72000  cmpi.w #$3e7, (a3, d2.w)
        cmpi.w #$3e7, (a3, d2.w)
L008_000002D2:
; H008+$000002D2: 6600001c  bne.w $2f0
        bne.w H008+$2F0
L008_000002D6:
; H008+$000002D6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_000002DA:
; H008+$000002DA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000002DC:
; H008+$000002DC: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_000002DE:
; H008+$000002DE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000002E2:
; H008+$000002E2: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_000002E6:
; H008+$000002E6: 37adfffc2000  move.w -$4(a5), (a3, d2.w)
        move.w -$4(a5), (a3, d2.w)
L008_000002EC:
; H008+$000002EC: 60000036  bra.w $324
        bra.w H008+$324
L008_000002F0:
; H008+$000002F0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_000002F4:
; H008+$000002F4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000002F6:
; H008+$000002F6: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_000002F8:
; H008+$000002F8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000002FC:
; H008+$000002FC: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_00000300:
; H008+$00000300: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L008_00000304:
; H008+$00000304: 5544  subq.w #$2, d4
        subq.w #$2, d4
L008_00000306:
; H008+$00000306: 37842002  move.w d4, $2(a3, d2.w)
        move.w d4, $2(a3, d2.w)
L008_0000030A:
; H008+$0000030A: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L008_0000030E:
; H008+$0000030E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_00000312:
; H008+$00000312: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000314:
; H008+$00000314: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000316:
; H008+$00000316: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000031A:
; H008+$0000031A: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_0000031E:
; H008+$0000031E: 37adfffc2000  move.w -$4(a5), (a3, d2.w)
        move.w -$4(a5), (a3, d2.w)
L008_00000324:
; H008+$00000324: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L008_00000328:
; H008+$00000328: 6400ff70  bcc.w $29a
        bcc.w H008+$29A
L008_0000032C:
; H008+$0000032C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L008_0000032E:
; H008+$0000032E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_00000332:
; H008+$00000332: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000334:
; H008+$00000334: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000336:
; H008+$00000336: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000033A:
; H008+$0000033A: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_0000033E:
; H008+$0000033E: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L008_00000342:
; H008+$00000342: 5344  subq.w #$1, d4
        subq.w #$1, d4
L008_00000344:
; H008+$00000344: 37842002  move.w d4, $2(a3, d2.w)
        move.w d4, $2(a3, d2.w)
L008_00000348:
; H008+$00000348: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L008_0000034E:
; H008+$0000034E: 0c6d0014fffc  cmpi.w #$14, -$4(a5)
        cmpi.w #$14, -$4(a5)
L008_00000354:
; H008+$00000354: 6200005e  bhi.w $3b4
        bhi.w H008+$3B4
L008_00000358:
; H008+$00000358: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L008_0000035C:
; H008+$0000035C: 0c6d0001fffa  cmpi.w #$1, -$6(a5)
        cmpi.w #$1, -$6(a5)
L008_00000362:
; H008+$00000362: 6200004a  bhi.w $3ae
        bhi.w H008+$3AE
L008_00000366:
; H008+$00000366: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L008_0000036A:
; H008+$0000036A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_0000036C:
; H008+$0000036C: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_0000036E:
; H008+$0000036E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000372:
; H008+$00000372: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_00000376:
; H008+$00000376: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L008_0000037A:
; H008+$0000037A: e344  asl.w #$1, d4
        asl.w #$1, d4
L008_0000037C:
; H008+$0000037C: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L008_00000380:
; H008+$00000380: 0c7303e74000  cmpi.w #$3e7, (a3, d4.w)
        cmpi.w #$3e7, (a3, d4.w)
L008_00000386:
; H008+$00000386: 66000020  bne.w $3a8
        bne.w H008+$3A8
L008_0000038A:
; H008+$0000038A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L008_0000038E:
; H008+$0000038E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000390:
; H008+$00000390: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000392:
; H008+$00000392: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000396:
; H008+$00000396: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_0000039A:
; H008+$0000039A: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L008_0000039E:
; H008+$0000039E: e344  asl.w #$1, d4
        asl.w #$1, d4
L008_000003A0:
; H008+$000003A0: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L008_000003A4:
; H008+$000003A4: 42734000  clr.w (a3, d4.w)
        clr.w (a3, d4.w)
L008_000003A8:
; H008+$000003A8: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L008_000003AC:
; H008+$000003AC: 64ae  bcc.b $35c
        bcc.b H008+$35C
L008_000003AE:
; H008+$000003AE: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L008_000003B2:
; H008+$000003B2: 649a  bcc.b $34e
        bcc.b H008+$34E
L008_000003B4:
; H008+$000003B4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000003B8:
; H008+$000003B8: 376dfffeff8c  move.w -$2(a5), -$74(a3)
        move.w -$2(a5), -$74(a3)
L008_000003BE:
; H008+$000003BE: 4e5d  unlk a5
        unlk a5
L008_000003C0:
; H008+$000003C0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_000003C2:
; H008+$000003C2: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L008_000003C6:
; H008+$000003C6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_000003C8 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H030+$00B6, H021+$026C, H026+$000C, H030+$0A40.
;   - Calls H030+$00B6.
;   - Calls H021+$026C.
;   - Calls H026+$000C.
;   - Calls H030+$0A40.
;   - Calls H030+$0256.
;   - Calls H042+$0B80.
;   - Calls H042+$0254.
;   - Uses the global state: H005+$52F6 (pointer to the game window); H005+$3E04 (pointer to persistent state A, 2048 bytes); H005+$3DE3 (native context, 5 in combat).
; Direct callers: H008+$0696, H008+$0AE8, H008+$0B64, H008+$1262, H008+$1004
; --------------------------------------------------------------------------
L008_000003C8:
; H008+$000003C8: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L008_000003CC:
; H008+$000003CC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000003D0:
; H008+$000003D0: 4a6bff90  tst.w -$70(a3)
        tst.w -$70(a3)
L008_000003D4:
; H008+$000003D4: 63000196  bls.w $56c
        bls.w H008+$56C
L008_000003D8:
; H008+$000003D8: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L008_000003DC:
; H008+$000003DC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000003E0:
; H008+$000003E0: 342bff90  move.w -$70(a3), d2
        move.w -$70(a3), d2
L008_000003E4:
; H008+$000003E4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000003E6:
; H008+$000003E6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_000003E8:
; H008+$000003E8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_000003EC:
; H008+$000003EC: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L008_000003EE:
; H008+$000003EE: 62000124  bhi.w $514
        bhi.w H008+$514
L008_000003F2:
; H008+$000003F2: 7400  moveq #$0, d2
        moveq #0, d2
L008_000003F4:
; H008+$000003F4: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L008_000003F8:
; H008+$000003F8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000003FA:
; H008+$000003FA: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_000003FC:
; H008+$000003FC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000400:
; H008+$00000400: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_00000404:
; H008+$00000404: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L008_00000408:
; H008+$00000408: b8732000  cmp.w (a3, d2.w), d4
        cmp.w (a3, d2.w), d4
L008_0000040C:
; H008+$0000040C: 6500006a  bcs.w $478
        bcs.w H008+$478
L008_00000410:
; H008+$00000410: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000412:
; H008+$00000412: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L008_00000416:
; H008+$00000416: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000418:
; H008+$00000418: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_0000041A:
; H008+$0000041A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000041E:
; H008+$0000041E: 47ebff3c  lea.l -$c4(a3), a3
        lea.l -$c4(a3), a3
L008_00000422:
; H008+$00000422: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L008_00000426:
; H008+$00000426: b8732002  cmp.w $2(a3, d2.w), d4
        cmp.w $2(a3, d2.w), d4
L008_0000042A:
; H008+$0000042A: 6200004c  bhi.w $478
        bhi.w H008+$478
L008_0000042E:
; H008+$0000042E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000432:
; H008+$00000432: 4a6b0014  tst.w $14(a3)
        tst.w $14(a3)
L008_00000436:
; H008+$00000436: 67000040  beq.w $478
        beq.w H008+$478
L008_0000043A:
; H008+$0000043A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000043E:
; H008+$0000043E: 342bff8e  move.w -$72(a3), d2
        move.w -$72(a3), d2
L008_00000442:
; H008+$00000442: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L008_00000446:
; H008+$00000446: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00000448:
; H008+$00000448: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L008_0000044C:
; H008+$0000044C: 4267  clr.w -(a7)
        clr.w -(a7)
L008_0000044E:
; H008+$0000044E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000452:
; H008+$00000452: 3f2b0014  move.w $14(a3), -(a7)
        move.w $14(a3), -(a7)
L008_00000456:
; H008+$00000456: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L008_0000045A:
; H008+$0000045A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_0000045E:
; H008+$0000045E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000462:
; H008+$00000462: 266b001a  movea.l $1a(a3), a3
        movea.l $1a(a3), a3
L008_00000466:
; H008+$00000466: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L008_0000046A:
; H008+$0000046A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H030+$00B6 (sub_H030_000000B6)
L008_0000046E:
; H008+$0000046E: 4eb9000000b6  jsr $b6.l
        jsr (H030+$B6).l
L008_00000474:
; H008+$00000474: 60000096  bra.w $50c
        bra.w H008+$50C
L008_00000478:
; H008+$00000478: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_0000047C:
; H008+$0000047C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000480:
; H008+$00000480: 266b001a  movea.l $1a(a3), a3
        movea.l $1a(a3), a3
L008_00000484:
; H008+$00000484: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L008_00000488:
; H008+$00000488: 6100fd16  bsr.w $1a0
        bsr.w H008+$1A0
L008_0000048C:
; H008+$0000048C: 1400  move.b d0, d2
        move.b d0, d2
L008_0000048E:
; H008+$0000048E: 4a02  tst.b d2
        tst.b d2
L008_00000490:
; H008+$00000490: 67000040  beq.w $4d2
        beq.w H008+$4D2
L008_00000494:
; H008+$00000494: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000498:
; H008+$00000498: 342bff8e  move.w -$72(a3), d2
        move.w -$72(a3), d2
L008_0000049C:
; H008+$0000049C: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L008_000004A0:
; H008+$000004A0: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_000004A2:
; H008+$000004A2: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L008_000004A6:
; H008+$000004A6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000004AA:
; H008+$000004AA: 3f2b0014  move.w $14(a3), -(a7)
        move.w $14(a3), -(a7)
L008_000004AE:
; H008+$000004AE: 4267  clr.w -(a7)
        clr.w -(a7)
L008_000004B0:
; H008+$000004B0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L008_000004B4:
; H008+$000004B4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_000004B8:
; H008+$000004B8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000004BC:
; H008+$000004BC: 266b001a  movea.l $1a(a3), a3
        movea.l $1a(a3), a3
L008_000004C0:
; H008+$000004C0: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L008_000004C4:
; H008+$000004C4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H030+$00B6 (sub_H030_000000B6)
L008_000004C8:
; H008+$000004C8: 4eb9000000b6  jsr $b6.l
        jsr (H030+$B6).l
L008_000004CE:
; H008+$000004CE: 6000003c  bra.w $50c
        bra.w H008+$50C
L008_000004D2:
; H008+$000004D2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000004D6:
; H008+$000004D6: 342bff8e  move.w -$72(a3), d2
        move.w -$72(a3), d2
L008_000004DA:
; H008+$000004DA: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L008_000004DE:
; H008+$000004DE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_000004E0:
; H008+$000004E0: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L008_000004E4:
; H008+$000004E4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000004E8:
; H008+$000004E8: 3f2b0016  move.w $16(a3), -(a7)
        move.w $16(a3), -(a7)
L008_000004EC:
; H008+$000004EC: 4267  clr.w -(a7)
        clr.w -(a7)
L008_000004EE:
; H008+$000004EE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L008_000004F2:
; H008+$000004F2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_000004F6:
; H008+$000004F6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000004FA:
; H008+$000004FA: 266b001a  movea.l $1a(a3), a3
        movea.l $1a(a3), a3
L008_000004FE:
; H008+$000004FE: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L008_00000502:
; H008+$00000502: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H030+$00B6 (sub_H030_000000B6)
L008_00000506:
; H008+$00000506: 4eb9000000b6  jsr $b6.l
        jsr (H030+$B6).l
L008_0000050C:
; H008+$0000050C: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L008_00000510:
; H008+$00000510: 6400fed6  bcc.w $3e8
        bcc.w H008+$3E8
L008_00000514:
; H008+$00000514: 548f  addq.l #$2, a7
        addq.l #$2, a7
L008_00000516:
; H008+$00000516: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000051A:
; H008+$0000051A: 342bff8e  move.w -$72(a3), d2
        move.w -$72(a3), d2
L008_0000051E:
; H008+$0000051E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000522:
; H008+$00000522: d46bff90  add.w -$70(a3), d2
        add.w -$70(a3), d2
L008_00000526:
; H008+$00000526: 0c420027  cmpi.w #$27, d2
        cmpi.w #$27, d2
L008_0000052A:
; H008+$0000052A: 64000040  bcc.w $56c
        bcc.w H008+$56C
L008_0000052E:
; H008+$0000052E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000532:
; H008+$00000532: 342bff8e  move.w -$72(a3), d2
        move.w -$72(a3), d2
L008_00000536:
; H008+$00000536: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000053A:
; H008+$0000053A: d46bff90  add.w -$70(a3), d2
        add.w -$70(a3), d2
L008_0000053E:
; H008+$0000053E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00000540:
; H008+$00000540: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L008_00000544:
; H008+$00000544: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00000546:
; H008+$00000546: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00000548:
; H008+$00000548: 7427  moveq #$27, d2
        moveq #39, d2
L008_0000054A:
; H008+$0000054A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000054E:
; H008+$0000054E: 946bff90  sub.w -$70(a3), d2
        sub.w -$70(a3), d2
L008_00000552:
; H008+$00000552: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00000556:
; H008+$00000556: 946bff8e  sub.w -$72(a3), d2
        sub.w -$72(a3), d2
L008_0000055A:
; H008+$0000055A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_0000055C:
; H008+$0000055C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_0000055E:
; H008+$0000055E: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
L008_00000562:
; H008+$00000562: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H030+$00B6 (sub_H030_000000B6)
L008_00000566:
; H008+$00000566: 4eb9000000b6  jsr $b6.l
        jsr (H030+$B6).l
L008_0000056C:
; H008+$0000056C: 4e5d  unlk a5
        unlk a5
L008_0000056E:
; H008+$0000056E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00000570:
; H008+$00000570: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_00000572:
; H008+$00000572: 4ed0  jmp (a0)
        jmp (a0)
L008_00000574:
; H008+$00000574: 342d0024  move.w $24(a5), d2
        move.w $24(a5), d2
L008_00000578:
; H008+$00000578: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_0000057A:
; H008+$0000057A: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_0000057E:
; H008+$0000057E: 6702  beq.b $582
        beq.b H008+$582
L008_00000580:
; H008+$00000580: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000582:
; H008+$00000582: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_00000584:
; H008+$00000584: 266d0020  movea.l $20(a5), a3
        movea.l $20(a5), a3
L008_00000588:
; H008+$00000588: 2b4f0020  move.l a7, $20(a5)
        move.l a7, $20(a5)
L008_0000058C:
; H008+$0000058C: 244f  movea.l a7, a2
        movea.l a7, a2
L008_0000058E:
; H008+$0000058E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000590:
; H008+$00000590: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_00000592:
; H008+$00000592: 51cafffc  dbra d2, $590
        dbra d2, H008+$590
L008_00000596:
; H008+$00000596: 342d001e  move.w $1e(a5), d2
        move.w $1e(a5), d2
L008_0000059A:
; H008+$0000059A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_0000059C:
; H008+$0000059C: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_000005A0:
; H008+$000005A0: 6702  beq.b $5a4
        beq.b H008+$5A4
L008_000005A2:
; H008+$000005A2: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_000005A4:
; H008+$000005A4: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_000005A6:
; H008+$000005A6: 266d001a  movea.l $1a(a5), a3
        movea.l $1a(a5), a3
L008_000005AA:
; H008+$000005AA: 2b4f001a  move.l a7, $1a(a5)
        move.l a7, $1a(a5)
L008_000005AE:
; H008+$000005AE: 244f  movea.l a7, a2
        movea.l a7, a2
L008_000005B0:
; H008+$000005B0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000005B2:
; H008+$000005B2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_000005B4:
; H008+$000005B4: 51cafffc  dbra d2, $5b2
        dbra d2, H008+$5B2
; STATE: H005+$52F6 = pointer to the game window
L008_000005B8:
; H008+$000005B8: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
; STATE: H005+$52F6 = pointer to the game window
L008_000005BE:
; H008+$000005BE: 2679000052f6  movea.l $52f6.l, a3
        movea.l (H005+$52F6).l, a3
L008_000005C4:
; H008+$000005C4: 242b0052  move.l $52(a3), d2
        move.l $52(a3), d2
L008_000005C8:
; H008+$000005C8: 008200400000  ori.l #$400000, d2
        ori.l #$400000, d2
L008_000005CE:
; H008+$000005CE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H021+$026C (wrapper_ModifyIDCMP)
L008_000005D0:
; H008+$000005D0: 4eb90000026c  jsr $26c.l
        jsr (H021+$26C).l
L008_000005D6:
; H008+$000005D6: 42390000249d  clr.b $249d.l
        clr.b (H005+$249D).l
L008_000005DC:
; H008+$000005DC: 4a6d0016  tst.w $16(a5)
        tst.w $16(a5)
L008_000005E0:
; H008+$000005E0: 6600000a  bne.w $5ec
        bne.w H008+$5EC
L008_000005E4:
; H008+$000005E4: 4a6d0014  tst.w $14(a5)
        tst.w $14(a5)
L008_000005E8:
; H008+$000005E8: 67000006  beq.w $5f0
        beq.w H008+$5F0
L008_000005EC:
; H008+$000005EC: 7401  moveq #$1, d2
        moveq #1, d2
L008_000005EE:
; H008+$000005EE: 6002  bra.b $5f2
        bra.b H008+$5F2
L008_000005F0:
; H008+$000005F0: 7400  moveq #$0, d2
        moveq #0, d2
L008_000005F2:
; H008+$000005F2: 1b42ff3a  move.b d2, -$c6(a5)
        move.b d2, -$c6(a5)
L008_000005F6:
; H008+$000005F6: 3f2d0024  move.w $24(a5), -(a7)
        move.w $24(a5), -(a7)
L008_000005FA:
; H008+$000005FA: 2f2d0020  move.l $20(a5), -(a7)
        move.l $20(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_000005FE:
; H008+$000005FE: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_00000604:
; H008+$00000604: 3b40ff8e  move.w d0, -$72(a5)
        move.w d0, -$72(a5)
L008_00000608:
; H008+$00000608: 3f2d001e  move.w $1e(a5), -(a7)
        move.w $1e(a5), -(a7)
L008_0000060C:
; H008+$0000060C: 2f2d001a  move.l $1a(a5), -(a7)
        move.l $1a(a5), -(a7)
L008_00000610:
; H008+$00000610: 4855  pea.l (a5)
        pea.l (a5)
L008_00000612:
; H008+$00000612: 6100fbf6  bsr.w $20a
        bsr.w H008+$20A
L008_00000616:
; H008+$00000616: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000618:
; H008+$00000618: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_0000061E:
; H008+$0000061E: b46dff8c  cmp.w -$74(a5), d2
        cmp.w -$74(a5), d2
L008_00000622:
; H008+$00000622: 62000010  bhi.w $634
        bhi.w H008+$634
L008_00000626:
; H008+$00000626: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000628:
; H008+$00000628: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_0000062E:
; H008+$0000062E: 4a42  tst.w d2
        tst.w d2
L008_00000630:
; H008+$00000630: 6600000a  bne.w $63c
        bne.w H008+$63C
L008_00000634:
; H008+$00000634: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L008_0000063C:
; H008+$0000063C: 3f2d001e  move.w $1e(a5), -(a7)
        move.w $1e(a5), -(a7)
L008_00000640:
; H008+$00000640: 2f2d001a  move.l $1a(a5), -(a7)
        move.l $1a(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_00000644:
; H008+$00000644: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_0000064A:
; H008+$0000064A: 3b40ff90  move.w d0, -$70(a5)
        move.w d0, -$70(a5)
L008_0000064E:
; H008+$0000064E: 422dffa2  clr.b -$5e(a5)
        clr.b -$5e(a5)
L008_00000652:
; H008+$00000652: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000656:
; H008+$00000656: 4213  clr.b (a3)
        clr.b (a3)
L008_00000658:
; H008+$00000658: 422dff3b  clr.b -$c5(a5)
        clr.b -$c5(a5)
; -> H030+$0A40 (sub_H030_00000A40)
L008_0000065C:
; H008+$0000065C: 4eb900000a40  jsr $a40.l
        jsr (H030+$A40).l
L008_00000662:
; H008+$00000662: 2b40ffaa  move.l d0, -$56(a5)
        move.l d0, -$56(a5)
L008_00000666:
; H008+$00000666: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000668:
; H008+$00000668: 266d0020  movea.l $20(a5), a3
        movea.l $20(a5), a3
L008_0000066C:
; H008+$0000066C: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L008_00000670:
; H008+$00000670: 6700001c  beq.w $68e
        beq.w H008+$68E
L008_00000674:
; H008+$00000674: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00000676:
; H008+$00000676: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L008_0000067A:
; H008+$0000067A: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L008_0000067E:
; H008+$0000067E: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00000680:
; H008+$00000680: 3f2d0024  move.w $24(a5), -(a7)
        move.w $24(a5), -(a7)
L008_00000684:
; H008+$00000684: 2f2d0020  move.l $20(a5), -(a7)
        move.l $20(a5), -(a7)
; FLOW: Calls UI_DrawText (H030+$0256).
L008_00000688:
; H008+$00000688: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L008_0000068E:
; H008+$0000068E: 1f3900002483  move.b $2483.l, -(a7)
        move.b (H005+$2483).l, -(a7)
L008_00000694:
; H008+$00000694: 4855  pea.l (a5)
        pea.l (a5)
L008_00000696:
; H008+$00000696: 6100fd30  bsr.w $3c8
        bsr.w H008+$3C8
L008_0000069A:
; H008+$0000069A: 422dffa2  clr.b -$5e(a5)
        clr.b -$5e(a5)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_0000069E:
; H008+$0000069E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_000006A4:
; H008+$000006A4: 4a6b03fe  tst.w $3fe(a3)
        tst.w $3fe(a3)
L008_000006A8:
; H008+$000006A8: 6600000a  bne.w $6b4
        bne.w H008+$6B4
L008_000006AC:
; H008+$000006AC: 4a2d0010  tst.b $10(a5)
        tst.b $10(a5)
L008_000006B0:
; H008+$000006B0: 670000b8  beq.w $76a
        beq.w H008+$76A
L008_000006B4:
; H008+$000006B4: 4a79000027be  tst.w $27be.l
        tst.w (H005+$27BE).l
L008_000006BA:
; H008+$000006BA: 630000ae  bls.w $76a
        bls.w H008+$76A
; -> H030+$0A40 (sub_H030_00000A40)
L008_000006BE:
; H008+$000006BE: 4eb900000a40  jsr $a40.l
        jsr (H030+$A40).l
L008_000006C4:
; H008+$000006C4: 2b40ffa6  move.l d0, -$5a(a5)
        move.l d0, -$5a(a5)
L008_000006C8:
; H008+$000006C8: 47f9000027bc  lea.l $27bc.l, a3
        lea.l (H005+$27BC).l, a3
L008_000006CE:
; H008+$000006CE: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L008_000006D2:
; H008+$000006D2: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_000006D4:
; H008+$000006D4: 3b42ff32  move.w d2, -$ce(a5)
        move.w d2, -$ce(a5)
L008_000006D8:
; H008+$000006D8: 342dff32  move.w -$ce(a5), d2
        move.w -$ce(a5), d2
L008_000006DC:
; H008+$000006DC: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L008_000006DE:
; H008+$000006DE: 63000008  bls.w $6e8
        bls.w H008+$6E8
L008_000006E2:
; H008+$000006E2: 3b7c0001ff32  move.w #$1, -$ce(a5)
        move.w #$1, -$ce(a5)
L008_000006E8:
; H008+$000006E8: 342dff32  move.w -$ce(a5), d2
        move.w -$ce(a5), d2
L008_000006EC:
; H008+$000006EC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000006EE:
; H008+$000006EE: e342  asl.w #$1, d2
        asl.w #$1, d2
L008_000006F0:
; H008+$000006F0: 45eb000e  lea.l $e(a3), a2
        lea.l $e(a3), a2
L008_000006F4:
; H008+$000006F4: 38322000  move.w (a2, d2.w), d4
        move.w (a2, d2.w), d4
L008_000006F8:
; H008+$000006F8: c8fc000a  mulu.w #$a, d4
        mulu.w #$a, d4
L008_000006FC:
; H008+$000006FC: 0444000b  subi.w #$b, d4
        subi.w #$b, d4
L008_00000700:
; H008+$00000700: 3b44ff34  move.w d4, -$cc(a5)
        move.w d4, -$cc(a5)
L008_00000704:
; H008+$00000704: 4a6dff34  tst.w -$cc(a5)
        tst.w -$cc(a5)
L008_00000708:
; H008+$00000708: 6c000006  bge.w $710
        bge.w H008+$710
L008_0000070C:
; H008+$0000070C: 426dff34  clr.w -$cc(a5)
        clr.w -$cc(a5)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000710:
; H008+$00000710: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L008_00000716:
; H008+$00000716: 4a6a03fe  tst.w $3fe(a2)
        tst.w $3fe(a2)
L008_0000071A:
; H008+$0000071A: 66000016  bne.w $732
        bne.w H008+$732
L008_0000071E:
; H008+$0000071E: 242dffa6  move.l -$5a(a5), d2
        move.l -$5a(a5), d2
L008_00000722:
; H008+$00000722: 94adffaa  sub.l -$56(a5), d2
        sub.l -$56(a5), d2
L008_00000726:
; H008+$00000726: 382dff34  move.w -$cc(a5), d4
        move.w -$cc(a5), d4
L008_0000072A:
; H008+$0000072A: 48c4  ext.l d4
        ext.l d4
L008_0000072C:
; H008+$0000072C: b484  cmp.l d4, d2
        cmp.l d4, d2
L008_0000072E:
; H008+$0000072E: 6d00003a  blt.w $76a
        blt.w H008+$76A
L008_00000732:
; H008+$00000732: 376dff320002  move.w -$ce(a5), $2(a3)
        move.w -$ce(a5), $2(a3)
L008_00000738:
; H008+$00000738: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L008_0000073A:
; H008+$0000073A: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L008_0000073E:
; H008+$0000073E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L008_00000742:
; H008+$00000742: 1f2d0010  move.b $10(a5), -(a7)
        move.b $10(a5), -(a7)
L008_00000746:
; H008+$00000746: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L008_00000748:
; H008+$00000748: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L008_0000074C:
; H008+$0000074C: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; -> H042+$0B80 (sub_H042_00000B80)
L008_00000752:
; H008+$00000752: 4eb900000b80  jsr $b80.l
        jsr (H042+$B80).l
L008_00000758:
; H008+$00000758: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L008_0000075A:
; H008+$0000075A: 2f00  move.l d0, -(a7)
        move.l d0, -(a7)
; -> H042+$0254 (sub_H042_00000254)
L008_0000075C:
; H008+$0000075C: 4eb900000254  jsr $254.l
        jsr (H042+$254).l
L008_00000762:
; H008+$00000762: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L008_00000764:
; H008+$00000764: 2b6dffa6ffaa  move.l -$5a(a5), -$56(a5)
        move.l -$5a(a5), -$56(a5)
L008_0000076A:
; H008+$0000076A: 4a39000024e2  tst.b $24e2.l
        tst.b (H005+$24E2).l
L008_00000770:
; H008+$00000770: 6700000c  beq.w $77e
        beq.w H008+$77E
L008_00000774:
; H008+$00000774: 3b7c0009ffa4  move.w #$9, -$5c(a5)
        move.w #$9, -$5c(a5)
L008_0000077A:
; H008+$0000077A: 6000028c  bra.w $a08
        bra.w H008+$A08
; STATE: H005+$52F6 = pointer to the game window
L008_0000077E:
; H008+$0000077E: 2679000052f6  movea.l $52f6.l, a3
        movea.l (H005+$52F6).l, a3
L008_00000784:
; H008+$00000784: 342b000c  move.w $c(a3), d2
        move.w $c(a3), d2
L008_00000788:
; H008+$00000788: 48c2  ext.l d2
        ext.l d2
L008_0000078A:
; H008+$0000078A: 85fc0008  divs.w #$8, d2
        divs.w #$8, d2
L008_0000078E:
; H008+$0000078E: 3b42ff96  move.w d2, -$6a(a5)
        move.w d2, -$6a(a5)
; STATE: H005+$52F6 = pointer to the game window
L008_00000792:
; H008+$00000792: 2679000052f6  movea.l $52f6.l, a3
        movea.l (H005+$52F6).l, a3
L008_00000798:
; H008+$00000798: 342b000e  move.w $e(a3), d2
        move.w $e(a3), d2
L008_0000079C:
; H008+$0000079C: 48c2  ext.l d2
        ext.l d2
L008_0000079E:
; H008+$0000079E: 85fc0008  divs.w #$8, d2
        divs.w #$8, d2
L008_000007A2:
; H008+$000007A2: 3b42ff98  move.w d2, -$68(a5)
        move.w d2, -$68(a5)
L008_000007A6:
; H008+$000007A6: 422dffa3  clr.b -$5d(a5)
        clr.b -$5d(a5)
L008_000007AA:
; H008+$000007AA: 4a39000024cb  tst.b $24cb.l
        tst.b (H005+$24CB).l
L008_000007B0:
; H008+$000007B0: 6600000c  bne.w $7be
        bne.w H008+$7BE
L008_000007B4:
; H008+$000007B4: 4a39000024cc  tst.b $24cc.l
        tst.b (H005+$24CC).l
L008_000007BA:
; H008+$000007BA: 670000f6  beq.w $8b2
        beq.w H008+$8B2
; STATE: H005+$3DE3 = native context, 5 in combat
L008_000007BE:
; H008+$000007BE: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L008_000007C6:
; H008+$000007C6: 660000ea  bne.w $8b2
        bne.w H008+$8B2
L008_000007CA:
; H008+$000007CA: 4a6dff98  tst.w -$68(a5)
        tst.w -$68(a5)
L008_000007CE:
; H008+$000007CE: 6d0000e2  blt.w $8b2
        blt.w H008+$8B2
L008_000007D2:
; H008+$000007D2: 0c6d0016ff98  cmpi.w #$16, -$68(a5)
        cmpi.w #$16, -$68(a5)
L008_000007D8:
; H008+$000007D8: 6e0000d8  bgt.w $8b2
        bgt.w H008+$8B2
L008_000007DC:
; H008+$000007DC: 4a6dff96  tst.w -$6a(a5)
        tst.w -$6a(a5)
L008_000007E0:
; H008+$000007E0: 6d0000d0  blt.w $8b2
        blt.w H008+$8B2
L008_000007E4:
; H008+$000007E4: 0c6d0016ff96  cmpi.w #$16, -$6a(a5)
        cmpi.w #$16, -$6a(a5)
L008_000007EA:
; H008+$000007EA: 6e0000c6  bgt.w $8b2
        bgt.w H008+$8B2
L008_000007EE:
; H008+$000007EE: 4a39000024cc  tst.b $24cc.l
        tst.b (H005+$24CC).l
L008_000007F4:
; H008+$000007F4: 67000032  beq.w $828
        beq.w H008+$828
L008_000007F8:
; H008+$000007F8: 343900002438  move.w $2438.l, d2
        move.w (H005+$2438).l, d2
L008_000007FE:
; H008+$000007FE: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_00000804:
; H008+$00000804: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L008_00000808:
; H008+$00000808: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_0000080A:
; H008+$0000080A: 3b42ff9c  move.w d2, -$64(a5)
        move.w d2, -$64(a5)
L008_0000080E:
; H008+$0000080E: 343900002436  move.w $2436.l, d2
        move.w (H005+$2436).l, d2
L008_00000814:
; H008+$00000814: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_0000081A:
; H008+$0000081A: 946b0004  sub.w $4(a3), d2
        sub.w $4(a3), d2
L008_0000081E:
; H008+$0000081E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000820:
; H008+$00000820: 3b42ff9a  move.w d2, -$66(a5)
        move.w d2, -$66(a5)
L008_00000824:
; H008+$00000824: 6000005a  bra.w $880
        bra.w H008+$880
; STATE: H005+$3368 = current character
L008_00000828:
; H008+$00000828: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H048+$0AA8 (sub_H048_00000AA8)
L008_0000082E:
; H008+$0000082E: 4eb900000aa8  jsr $aa8.l
        jsr (H048+$AA8).l
L008_00000834:
; H008+$00000834: 3b40ff94  move.w d0, -$6c(a5)
        move.w d0, -$6c(a5)
L008_00000838:
; H008+$00000838: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_0000083C:
; H008+$0000083C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_0000083E:
; H008+$0000083E: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L008_00000842:
; H008+$00000842: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L008_00000848:
; H008+$00000848: 38332800  move.w (a3, d2.l), d4
        move.w (a3, d2.l), d4
L008_0000084C:
; H008+$0000084C: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_00000852:
; H008+$00000852: 986b0002  sub.w $2(a3), d4
        sub.w $2(a3), d4
L008_00000856:
; H008+$00000856: 5244  addq.w #$1, d4
        addq.w #$1, d4
L008_00000858:
; H008+$00000858: 3b44ff9c  move.w d4, -$64(a5)
        move.w d4, -$64(a5)
L008_0000085C:
; H008+$0000085C: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000860:
; H008+$00000860: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000862:
; H008+$00000862: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L008_00000866:
; H008+$00000866: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L008_0000086C:
; H008+$0000086C: 38332802  move.w $2(a3, d2.l), d4
        move.w $2(a3, d2.l), d4
L008_00000870:
; H008+$00000870: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_00000876:
; H008+$00000876: 986b0004  sub.w $4(a3), d4
        sub.w $4(a3), d4
L008_0000087A:
; H008+$0000087A: 5244  addq.w #$1, d4
        addq.w #$1, d4
L008_0000087C:
; H008+$0000087C: 3b44ff9a  move.w d4, -$66(a5)
        move.w d4, -$66(a5)
L008_00000880:
; H008+$00000880: 3f2dff9c  move.w -$64(a5), -(a7)
        move.w -$64(a5), -(a7)
L008_00000884:
; H008+$00000884: 3f2dff9a  move.w -$66(a5), -(a7)
        move.w -$66(a5), -(a7)
L008_00000888:
; H008+$00000888: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_0000088C:
; H008+$0000088C: 5442  addq.w #$2, d2
        addq.w #$2, d2
L008_0000088E:
; H008+$0000088E: 48c2  ext.l d2
        ext.l d2
L008_00000890:
; H008+$00000890: 85fc0003  divs.w #$3, d2
        divs.w #$3, d2
L008_00000894:
; H008+$00000894: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00000896:
; H008+$00000896: 342dff96  move.w -$6a(a5), d2
        move.w -$6a(a5), d2
L008_0000089A:
; H008+$0000089A: 5442  addq.w #$2, d2
        addq.w #$2, d2
L008_0000089C:
; H008+$0000089C: 48c2  ext.l d2
        ext.l d2
L008_0000089E:
; H008+$0000089E: 85fc0003  divs.w #$3, d2
        divs.w #$3, d2
L008_000008A2:
; H008+$000008A2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H046+$0012 (sub_H046_00000012)
L008_000008A4:
; H008+$000008A4: 4eb900000012  jsr $12.l
        jsr (H046+$12).l
L008_000008AA:
; H008+$000008AA: 1b40ffa3  move.b d0, -$5d(a5)
        move.b d0, -$5d(a5)
L008_000008AE:
; H008+$000008AE: 600000d6  bra.w $986
        bra.w H008+$986
L008_000008B2:
; H008+$000008B2: 4a39000024b0  tst.b $24b0.l
        tst.b (H005+$24B0).l
L008_000008B8:
; H008+$000008B8: 670000cc  beq.w $986
        beq.w H008+$986
L008_000008BC:
; H008+$000008BC: 0c6d0003ff98  cmpi.w #$3, -$68(a5)
        cmpi.w #$3, -$68(a5)
L008_000008C2:
; H008+$000008C2: 6d000020  blt.w $8e4
        blt.w H008+$8E4
L008_000008C6:
; H008+$000008C6: 0c6d000dff98  cmpi.w #$d, -$68(a5)
        cmpi.w #$d, -$68(a5)
L008_000008CC:
; H008+$000008CC: 6e000016  bgt.w $8e4
        bgt.w H008+$8E4
L008_000008D0:
; H008+$000008D0: 0c6d0003ff96  cmpi.w #$3, -$6a(a5)
        cmpi.w #$3, -$6a(a5)
L008_000008D6:
; H008+$000008D6: 6d00000c  blt.w $8e4
        blt.w H008+$8E4
L008_000008DA:
; H008+$000008DA: 0c6d000dff96  cmpi.w #$d, -$6a(a5)
        cmpi.w #$d, -$6a(a5)
L008_000008E0:
; H008+$000008E0: 6f000044  ble.w $926
        ble.w H008+$926
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_000008E4:
; H008+$000008E4: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_000008EA:
; H008+$000008EA: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L008_000008EE:
; H008+$000008EE: 66000096  bne.w $986
        bne.w H008+$986
; STATE: H005+$3DE3 = native context, 5 in combat
L008_000008F2:
; H008+$000008F2: 0c39000300003de3  cmpi.b #$3, $3de3.l
        cmpi.b #$3, (H005+$3DE3).l
L008_000008FA:
; H008+$000008FA: 6600008a  bne.w $986
        bne.w H008+$986
L008_000008FE:
; H008+$000008FE: 0c6d0001ff98  cmpi.w #$1, -$68(a5)
        cmpi.w #$1, -$68(a5)
L008_00000904:
; H008+$00000904: 6d000080  blt.w $986
        blt.w H008+$986
L008_00000908:
; H008+$00000908: 0c6d0026ff98  cmpi.w #$26, -$68(a5)
        cmpi.w #$26, -$68(a5)
L008_0000090E:
; H008+$0000090E: 6e000076  bgt.w $986
        bgt.w H008+$986
L008_00000912:
; H008+$00000912: 0c6d0001ff96  cmpi.w #$1, -$6a(a5)
        cmpi.w #$1, -$6a(a5)
L008_00000918:
; H008+$00000918: 6d00006c  blt.w $986
        blt.w H008+$986
L008_0000091C:
; H008+$0000091C: 0c6d000fff96  cmpi.w #$f, -$6a(a5)
        cmpi.w #$f, -$6a(a5)
L008_00000922:
; H008+$00000922: 6e000062  bgt.w $986
        bgt.w H008+$986
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000926:
; H008+$00000926: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_0000092C:
; H008+$0000092C: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L008_00000930:
; H008+$00000930: 66000034  bne.w $966
        bne.w H008+$966
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000934:
; H008+$00000934: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_0000093A:
; H008+$0000093A: 342b0186  move.w $186(a3), d2
        move.w $186(a3), d2
L008_0000093E:
; H008+$0000093E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000940:
; H008+$00000940: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000942:
; H008+$00000942: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_00000948:
; H008+$00000948: 342b0188  move.w $188(a3), d2
        move.w $188(a3), d2
L008_0000094C:
; H008+$0000094C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_0000094E:
; H008+$0000094E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00000950:
; H008+$00000950: 3f2dff98  move.w -$68(a5), -(a7)
        move.w -$68(a5), -(a7)
L008_00000954:
; H008+$00000954: 3f2dff96  move.w -$6a(a5), -(a7)
        move.w -$6a(a5), -(a7)
; -> H046+$0012 (sub_H046_00000012)
L008_00000958:
; H008+$00000958: 4eb900000012  jsr $12.l
        jsr (H046+$12).l
L008_0000095E:
; H008+$0000095E: 1b40ffa3  move.b d0, -$5d(a5)
        move.b d0, -$5d(a5)
L008_00000962:
; H008+$00000962: 60000022  bra.w $986
        bra.w H008+$986
L008_00000966:
; H008+$00000966: 342dff96  move.w -$6a(a5), d2
        move.w -$6a(a5), d2
L008_0000096A:
; H008+$0000096A: 5742  subq.w #$3, d2
        subq.w #$3, d2
L008_0000096C:
; H008+$0000096C: c5fc000c  muls.w #$c, d2
        muls.w #$c, d2
L008_00000970:
; H008+$00000970: 47f900004f86  lea.l $4f86.l, a3
        lea.l (H005+$4F86).l, a3
L008_00000976:
; H008+$00000976: 382dff98  move.w -$68(a5), d4
        move.w -$68(a5), d4
L008_0000097A:
; H008+$0000097A: 5744  subq.w #$3, d4
        subq.w #$3, d4
L008_0000097C:
; H008+$0000097C: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L008_00000980:
; H008+$00000980: 1b734000ffa3  move.b (a3, d4.w), -$5d(a5)
        move.b (a3, d4.w), -$5d(a5)
L008_00000986:
; H008+$00000986: 3b7c000affa4  move.w #$a, -$5c(a5)
        move.w #$a, -$5c(a5)
L008_0000098C:
; H008+$0000098C: 7400  moveq #$0, d2
        moveq #0, d2
L008_0000098E:
; H008+$0000098E: 142dffa3  move.b -$5d(a5), d2
        move.b -$5d(a5), d2
L008_00000992:
; H008+$00000992: 6000005a  bra.w $9ee
        bra.w H008+$9EE
L008_00000996:
; H008+$00000996: 426dffa4  clr.w -$5c(a5)
        clr.w -$5c(a5)
L008_0000099A:
; H008+$0000099A: 4e75  rts 
        rts 
L008_0000099C:
; H008+$0000099C: 3b7c0001ffa4  move.w #$1, -$5c(a5)
        move.w #$1, -$5c(a5)
L008_000009A2:
; H008+$000009A2: 4e75  rts 
        rts 
L008_000009A4:
; H008+$000009A4: 3b7c0002ffa4  move.w #$2, -$5c(a5)
        move.w #$2, -$5c(a5)
L008_000009AA:
; H008+$000009AA: 4e75  rts 
        rts 
L008_000009AC:
; H008+$000009AC: 3b7c0003ffa4  move.w #$3, -$5c(a5)
        move.w #$3, -$5c(a5)
L008_000009B2:
; H008+$000009B2: 4e75  rts 
        rts 
L008_000009B4:
; H008+$000009B4: 3b7c0004ffa4  move.w #$4, -$5c(a5)
        move.w #$4, -$5c(a5)
L008_000009BA:
; H008+$000009BA: 4e75  rts 
        rts 
L008_000009BC:
; H008+$000009BC: 3b7c0005ffa4  move.w #$5, -$5c(a5)
        move.w #$5, -$5c(a5)
L008_000009C2:
; H008+$000009C2: 4e75  rts 
        rts 
L008_000009C4:
; H008+$000009C4: 3b7c0006ffa4  move.w #$6, -$5c(a5)
        move.w #$6, -$5c(a5)
L008_000009CA:
; H008+$000009CA: 4e75  rts 
        rts 
L008_000009CC:
; H008+$000009CC: 3b7c0007ffa4  move.w #$7, -$5c(a5)
        move.w #$7, -$5c(a5)
L008_000009D2:
; H008+$000009D2: 4e75  rts 
        rts 
L008_000009D4:
; H008+$000009D4: 4e75  rts 
        rts 
; Preserved bytes H008+$000009D6..$000009EE; code/data not fully classified.
        dc.w $FFFC,$FFF4,$FFBE,$FFC4,$FFFC,$FFEC,$FFFC,$FFCC
        dc.w $FFFC,$FFE4,$FFDC,$FFD4
L008_000009EE:
; H008+$000009EE: 47faffe8  lea.l $9d8(pc), a3
        lea.l H008+$9D8(pc), a3
L008_000009F2:
; H008+$000009F2: 04420047  subi.w #$47, d2
        subi.w #$47, d2
L008_000009F6:
; H008+$000009F6: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L008_000009FA:
; H008+$000009FA: 6302  bls.b $9fe
        bls.b H008+$9FE
L008_000009FC:
; H008+$000009FC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L008_000009FE:
; H008+$000009FE: e342  asl.w #$1, d2
        asl.w #$1, d2
L008_00000A00:
; H008+$00000A00: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H008+$09D8; indices 0..10, default -1.
L008_00000A04:
; H008+$00000A04: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L008_00000A08:
; H008+$00000A08: 3f2dffa4  move.w -$5c(a5), -(a7)
        move.w -$5c(a5), -(a7)
; -> H029+$01B6 (sub_H029_000001B6)
L008_00000A0C:
; H008+$00000A0C: 4eb9000001b6  jsr $1b6.l
        jsr (H029+$1B6).l
L008_00000A12:
; H008+$00000A12: 4ab900002792  tst.l $2792.l
        tst.l (H005+$2792).l
L008_00000A18:
; H008+$00000A18: 6f000030  ble.w $a4a
        ble.w H008+$A4A
; -> H030+$0A40 (sub_H030_00000A40)
L008_00000A1C:
; H008+$00000A1C: 4eb900000a40  jsr $a40.l
        jsr (H030+$A40).l
L008_00000A22:
; H008+$00000A22: 2400  move.l d0, d2
        move.l d0, d2
L008_00000A24:
; H008+$00000A24: 94adffaa  sub.l -$56(a5), d2
        sub.l -$56(a5), d2
L008_00000A28:
; H008+$00000A28: 4a82  tst.l d2
        tst.l d2
L008_00000A2A:
; H008+$00000A2A: 6c02  bge.b $a2e
        bge.b H008+$A2E
L008_00000A2C:
; H008+$00000A2C: 4482  neg.l d2
        neg.l d2
L008_00000A2E:
; H008+$00000A2E: b4b900002792  cmp.l $2792.l, d2
        cmp.l (H005+$2792).l, d2
L008_00000A34:
; H008+$00000A34: 6d000014  blt.w $a4a
        blt.w H008+$A4A
L008_00000A38:
; H008+$00000A38: 1b79000052fbffa2  move.b $52fb.l, -$5e(a5)
        move.b (H005+$52FB).l, -$5e(a5)
L008_00000A40:
; H008+$00000A40: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000A46:
; H008+$00000A46: 60000010  bra.w $a58
        bra.w H008+$A58
; -> H010+$042E (trampoline_H010_0882)
L008_00000A4A:
; H008+$00000A4A: 4eb90000042e  jsr $42e.l
        jsr (H010+$42E).l
; STATE: H005+$5305 = byte of the pending key/action
L008_00000A50:
; H008+$00000A50: 1b7900005305ffa2  move.b $5305.l, -$5e(a5)
        move.b (H005+$5305).l, -$5e(a5)
L008_00000A58:
; H008+$00000A58: 4a2dffa2  tst.b -$5e(a5)
        tst.b -$5e(a5)
L008_00000A5C:
; H008+$00000A5C: 670008e8  beq.w $1346
        beq.w H008+$1346
L008_00000A60:
; H008+$00000A60: 4a2dff3b  tst.b -$c5(a5)
        tst.b -$c5(a5)
L008_00000A64:
; H008+$00000A64: 660008e0  bne.w $1346
        bne.w H008+$1346
L008_00000A68:
; H008+$00000A68: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000A6C:
; H008+$00000A6C: 4213  clr.b (a3)
        clr.b (a3)
; STATE: H005+$5305 = byte of the pending key/action
L008_00000A6E:
; H008+$00000A6E: 4a3900005305  tst.b $5305.l
        tst.b (H005+$5305).l
L008_00000A74:
; H008+$00000A74: 63000020  bls.w $a96
        bls.w H008+$A96
; STATE: H005+$5305 = byte of the pending key/action
L008_00000A78:
; H008+$00000A78: 0c39000500005305  cmpi.b #$5, $5305.l
        cmpi.b #$5, (H005+$5305).l
L008_00000A80:
; H008+$00000A80: 64000014  bcc.w $a96
        bcc.w H008+$A96
L008_00000A84:
; H008+$00000A84: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000A8A:
; H008+$00000A8A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000A8E:
; H008+$00000A8E: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000A92:
; H008+$00000A92: 600008b2  bra.w $1346
        bra.w H008+$1346
L008_00000A96:
; H008+$00000A96: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000A98:
; H008+$00000A98: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_00000A9C:
; H008+$00000A9C: 6000088e  bra.w $132c
        bra.w H008+$132C
L008_00000AA0:
; H008+$00000AA0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000AA4:
; H008+$00000AA4: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000AA8:
; H008+$00000AA8: 0c6d0001ff8c  cmpi.w #$1, -$74(a5)
        cmpi.w #$1, -$74(a5)
L008_00000AAE:
; H008+$00000AAE: 63000040  bls.w $af0
        bls.w H008+$AF0
L008_00000AB2:
; H008+$00000AB2: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000AB4:
; H008+$00000AB4: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_00000ABA:
; H008+$00000ABA: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L008_00000ABE:
; H008+$00000ABE: 66000010  bne.w $ad0
        bne.w H008+$AD0
L008_00000AC2:
; H008+$00000AC2: 342dff8c  move.w -$74(a5), d2
        move.w -$74(a5), d2
L008_00000AC6:
; H008+$00000AC6: 13c200002483  move.b d2, $2483.l
        move.b d2, (H005+$2483).l
L008_00000ACC:
; H008+$00000ACC: 60000012  bra.w $ae0
        bra.w H008+$AE0
L008_00000AD0:
; H008+$00000AD0: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000AD2:
; H008+$00000AD2: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_00000AD8:
; H008+$00000AD8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000ADA:
; H008+$00000ADA: 13c200002483  move.b d2, $2483.l
        move.b d2, (H005+$2483).l
L008_00000AE0:
; H008+$00000AE0: 1f3900002483  move.b $2483.l, -(a7)
        move.b (H005+$2483).l, -(a7)
L008_00000AE6:
; H008+$00000AE6: 4855  pea.l (a5)
        pea.l (a5)
L008_00000AE8:
; H008+$00000AE8: 6100f8de  bsr.w $3c8
        bsr.w H008+$3C8
L008_00000AEC:
; H008+$00000AEC: 6000002e  bra.w $b1c
        bra.w H008+$B1C
L008_00000AF0:
; H008+$00000AF0: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L008_00000AF4:
; H008+$00000AF4: 67000020  beq.w $b16
        beq.w H008+$B16
L008_00000AF8:
; H008+$00000AF8: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000AFA:
; H008+$00000AFA: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_00000AFE:
; H008+$00000AFE: 04420031  subi.w #$31, d2
        subi.w #$31, d2
L008_00000B02:
; H008+$00000B02: 47f900004f7c  lea.l $4f7c.l, a3
        lea.l (H005+$4F7C).l, a3
L008_00000B08:
; H008+$00000B08: 1b732000ffa2  move.b (a3, d2.w), -$5e(a5)
        move.b (a3, d2.w), -$5e(a5)
L008_00000B0E:
; H008+$00000B0E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000B12:
; H008+$00000B12: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000B16:
; H008+$00000B16: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000B1C:
; H008+$00000B1C: 4e75  rts 
        rts 
L008_00000B1E:
; H008+$00000B1E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000B22:
; H008+$00000B22: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000B26:
; H008+$00000B26: 0c6d0001ff8c  cmpi.w #$1, -$74(a5)
        cmpi.w #$1, -$74(a5)
L008_00000B2C:
; H008+$00000B2C: 6300003e  bls.w $b6c
        bls.w H008+$B6C
L008_00000B30:
; H008+$00000B30: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000B32:
; H008+$00000B32: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_00000B38:
; H008+$00000B38: b46dff8c  cmp.w -$74(a5), d2
        cmp.w -$74(a5), d2
L008_00000B3C:
; H008+$00000B3C: 6600000e  bne.w $b4c
        bne.w H008+$B4C
L008_00000B40:
; H008+$00000B40: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L008_00000B48:
; H008+$00000B48: 60000012  bra.w $b5c
        bra.w H008+$B5C
L008_00000B4C:
; H008+$00000B4C: 487900002483  pea.l $2483.l
        pea.l (H005+$2483).l
L008_00000B52:
; H008+$00000B52: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L008_00000B56:
; H008+$00000B56: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L008_00000B5C:
; H008+$00000B5C: 1f3900002483  move.b $2483.l, -(a7)
        move.b (H005+$2483).l, -(a7)
L008_00000B62:
; H008+$00000B62: 4855  pea.l (a5)
        pea.l (a5)
L008_00000B64:
; H008+$00000B64: 6100f862  bsr.w $3c8
        bsr.w H008+$3C8
L008_00000B68:
; H008+$00000B68: 6000002e  bra.w $b98
        bra.w H008+$B98
L008_00000B6C:
; H008+$00000B6C: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000B72:
; H008+$00000B72: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L008_00000B76:
; H008+$00000B76: 67000020  beq.w $b98
        beq.w H008+$B98
L008_00000B7A:
; H008+$00000B7A: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000B7C:
; H008+$00000B7C: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_00000B80:
; H008+$00000B80: 04420031  subi.w #$31, d2
        subi.w #$31, d2
L008_00000B84:
; H008+$00000B84: 47f900004f7c  lea.l $4f7c.l, a3
        lea.l (H005+$4F7C).l, a3
L008_00000B8A:
; H008+$00000B8A: 1b732000ffa2  move.b (a3, d2.w), -$5e(a5)
        move.b (a3, d2.w), -$5e(a5)
L008_00000B90:
; H008+$00000B90: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000B94:
; H008+$00000B94: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000B98:
; H008+$00000B98: 4e75  rts 
        rts 
L008_00000B9A:
; H008+$00000B9A: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000BA0:
; H008+$00000BA0: 422dffa2  clr.b -$5e(a5)
        clr.b -$5e(a5)
L008_00000BA4:
; H008+$00000BA4: 4e75  rts 
        rts 
L008_00000BA6:
; H008+$00000BA6: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00000BAC:
; H008+$00000BAC: 670005d8  beq.w $1186
        beq.w H008+$1186
; STATE: H005+$2354 = mouse Y coordinate
L008_00000BB0:
; H008+$00000BB0: 343900002354  move.w $2354.l, d2
        move.w (H005+$2354).l, d2
L008_00000BB6:
; H008+$00000BB6: 48c2  ext.l d2
        ext.l d2
L008_00000BB8:
; H008+$00000BB8: 85fc0008  divs.w #$8, d2
        divs.w #$8, d2
L008_00000BBC:
; H008+$00000BBC: 3b42ff96  move.w d2, -$6a(a5)
        move.w d2, -$6a(a5)
; STATE: H005+$2356 = mouse X coordinate
L008_00000BC0:
; H008+$00000BC0: 343900002356  move.w $2356.l, d2
        move.w (H005+$2356).l, d2
L008_00000BC6:
; H008+$00000BC6: 48c2  ext.l d2
        ext.l d2
L008_00000BC8:
; H008+$00000BC8: 85fc0008  divs.w #$8, d2
        divs.w #$8, d2
L008_00000BCC:
; H008+$00000BCC: 3b42ff98  move.w d2, -$68(a5)
        move.w d2, -$68(a5)
L008_00000BD0:
; H008+$00000BD0: 4a3900000001  tst.b $1.l
        tst.b (H047+$1).l
L008_00000BD6:
; H008+$00000BD6: 67000014  beq.w $bec
        beq.w H008+$BEC
L008_00000BDA:
; H008+$00000BDA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000BDE:
; H008+$00000BDE: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000BE2:
; H008+$00000BE2: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000BE8:
; H008+$00000BE8: 60000598  bra.w $1182
        bra.w H008+$1182
L008_00000BEC:
; H008+$00000BEC: 4a39000024a2  tst.b $24a2.l
        tst.b (H005+$24A2).l
L008_00000BF2:
; H008+$00000BF2: 67000144  beq.w $d38
        beq.w H008+$D38
; STATE: H005+$3DE3 = native context, 5 in combat
L008_00000BF6:
; H008+$00000BF6: 0c39000300003de3  cmpi.b #$3, $3de3.l
        cmpi.b #$3, (H005+$3DE3).l
L008_00000BFE:
; H008+$00000BFE: 66000010  bne.w $c10
        bne.w H008+$C10
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000C02:
; H008+$00000C02: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_00000C08:
; H008+$00000C08: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L008_00000C0C:
; H008+$00000C0C: 6700012a  beq.w $d38
        beq.w H008+$D38
L008_00000C10:
; H008+$00000C10: 4a39000024b0  tst.b $24b0.l
        tst.b (H005+$24B0).l
L008_00000C16:
; H008+$00000C16: 66000120  bne.w $d38
        bne.w H008+$D38
; STATE: H005+$3DE3 = native context, 5 in combat
L008_00000C1A:
; H008+$00000C1A: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L008_00000C22:
; H008+$00000C22: 67000114  beq.w $d38
        beq.w H008+$D38
L008_00000C26:
; H008+$00000C26: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000C28:
; H008+$00000C28: 14390000248d  move.b $248d.l, d2
        move.b (H005+$248D).l, d2
L008_00000C2E:
; H008+$00000C2E: 382dff98  move.w -$68(a5), d4
        move.w -$68(a5), d4
L008_00000C32:
; H008+$00000C32: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_00000C34:
; H008+$00000C34: 6d000102  blt.w $d38
        blt.w H008+$D38
L008_00000C38:
; H008+$00000C38: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000C3A:
; H008+$00000C3A: 14390000248c  move.b $248c.l, d2
        move.b (H005+$248C).l, d2
L008_00000C40:
; H008+$00000C40: 382dff98  move.w -$68(a5), d4
        move.w -$68(a5), d4
L008_00000C44:
; H008+$00000C44: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_00000C46:
; H008+$00000C46: 6e0000f0  bgt.w $d38
        bgt.w H008+$D38
L008_00000C4A:
; H008+$00000C4A: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000C4C:
; H008+$00000C4C: 14390000248b  move.b $248b.l, d2
        move.b (H005+$248B).l, d2
L008_00000C52:
; H008+$00000C52: 382dff96  move.w -$6a(a5), d4
        move.w -$6a(a5), d4
L008_00000C56:
; H008+$00000C56: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_00000C58:
; H008+$00000C58: 6d0000de  blt.w $d38
        blt.w H008+$D38
L008_00000C5C:
; H008+$00000C5C: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000C5E:
; H008+$00000C5E: 14390000248a  move.b $248a.l, d2
        move.b (H005+$248A).l, d2
L008_00000C64:
; H008+$00000C64: 382dff96  move.w -$6a(a5), d4
        move.w -$6a(a5), d4
L008_00000C68:
; H008+$00000C68: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_00000C6A:
; H008+$00000C6A: 6e0000cc  bgt.w $d38
        bgt.w H008+$D38
L008_00000C6E:
; H008+$00000C6E: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000C70:
; H008+$00000C70: 14390000248b  move.b $248b.l, d2
        move.b (H005+$248B).l, d2
L008_00000C76:
; H008+$00000C76: 382dff96  move.w -$6a(a5), d4
        move.w -$6a(a5), d4
L008_00000C7A:
; H008+$00000C7A: 9842  sub.w d2, d4
        sub.w d2, d4
L008_00000C7C:
; H008+$00000C7C: 3b44ff94  move.w d4, -$6c(a5)
        move.w d4, -$6c(a5)
; STATE: H005+$3364 = head of the party list
L008_00000C80:
; H008+$00000C80: 2b7900003364ff36  move.l $3364.l, -$ca(a5)
        move.l (H005+$3364).l, -$ca(a5)
L008_00000C88:
; H008+$00000C88: 3b7c0001ff92  move.w #$1, -$6e(a5)
        move.w #$1, -$6e(a5)
L008_00000C8E:
; H008+$00000C8E: 3f2dff94  move.w -$6c(a5), -(a7)
        move.w -$6c(a5), -(a7)
L008_00000C92:
; H008+$00000C92: 342dff92  move.w -$6e(a5), d2
        move.w -$6e(a5), d2
L008_00000C96:
; H008+$00000C96: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L008_00000C98:
; H008+$00000C98: 6200001a  bhi.w $cb4
        bhi.w H008+$CB4
L008_00000C9C:
; H008+$00000C9C: 4aadff36  tst.l -$ca(a5)
        tst.l -$ca(a5)
L008_00000CA0:
; H008+$00000CA0: 6700000c  beq.w $cae
        beq.w H008+$CAE
L008_00000CA4:
; H008+$00000CA4: 266dff36  movea.l -$ca(a5), a3
        movea.l -$ca(a5), a3
L008_00000CA8:
; H008+$00000CA8: 2b6b018eff36  move.l $18e(a3), -$ca(a5)
        move.l $18e(a3), -$ca(a5)
L008_00000CAE:
; H008+$00000CAE: 526dff92  addq.w #$1, -$6e(a5)
        addq.w #$1, -$6e(a5)
L008_00000CB2:
; H008+$00000CB2: 64de  bcc.b $c92
        bcc.b H008+$C92
L008_00000CB4:
; H008+$00000CB4: 548f  addq.l #$2, a7
        addq.l #$2, a7
L008_00000CB6:
; H008+$00000CB6: 4aadff36  tst.l -$ca(a5)
        tst.l -$ca(a5)
L008_00000CBA:
; H008+$00000CBA: 67000078  beq.w $d34
        beq.w H008+$D34
L008_00000CBE:
; H008+$00000CBE: 1b7c0048ffa2  move.b #$48, -$5e(a5)
        move.b #$48, -$5e(a5)
L008_00000CC4:
; H008+$00000CC4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000CC8:
; H008+$00000CC8: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000CCC:
; H008+$00000CCC: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000CD2:
; H008+$00000CD2: 4a39000024d8  tst.b $24d8.l
        tst.b (H005+$24D8).l
L008_00000CD8:
; H008+$00000CD8: 6700000e  beq.w $ce8
        beq.w H008+$CE8
L008_00000CDC:
; H008+$00000CDC: 23edff3600002508  move.l -$ca(a5), $2508.l
        move.l -$ca(a5), (H005+$2508).l
L008_00000CE4:
; H008+$00000CE4: 6000004e  bra.w $d34
        bra.w H008+$D34
; STATE: H005+$3368 = current character
L008_00000CE8:
; H008+$00000CE8: 243900003368  move.l $3368.l, d2
        move.l (H005+$3368).l, d2
L008_00000CEE:
; H008+$00000CEE: b4adff36  cmp.l -$ca(a5), d2
        cmp.l -$ca(a5), d2
L008_00000CF2:
; H008+$00000CF2: 66000038  bne.w $d2c
        bne.w H008+$D2C
L008_00000CF6:
; H008+$00000CF6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000CFA:
; H008+$00000CFA: 4213  clr.b (a3)
        clr.b (a3)
L008_00000CFC:
; H008+$00000CFC: 7400  moveq #$0, d2
        moveq #0, d2
L008_00000CFE:
; H008+$00000CFE: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_00000D04:
; H008+$00000D04: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000D06:
; H008+$00000D06: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000D08:
; H008+$00000D08: 47edff3c  lea.l -$c4(a5), a3
        lea.l -$c4(a5), a3
L008_00000D0C:
; H008+$00000D0C: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L008_00000D10:
; H008+$00000D10: 266d001a  movea.l $1a(a5), a3
        movea.l $1a(a5), a3
L008_00000D14:
; H008+$00000D14: 1b734000ffa2  move.b (a3, d4.w), -$5e(a5)
        move.b (a3, d4.w), -$5e(a5)
L008_00000D1A:
; H008+$00000D1A: 4a2dffa2  tst.b -$5e(a5)
        tst.b -$5e(a5)
L008_00000D1E:
; H008+$00000D1E: 66000008  bne.w $d28
        bne.w H008+$D28
L008_00000D22:
; H008+$00000D22: 1b7c000dffa2  move.b #$d, -$5e(a5)
        move.b #$d, -$5e(a5)
L008_00000D28:
; H008+$00000D28: 6000000a  bra.w $d34
        bra.w H008+$D34
; STATE: H005+$3368 = current character
L008_00000D2C:
; H008+$00000D2C: 23edff3600003368  move.l -$ca(a5), $3368.l
        move.l -$ca(a5), (H005+$3368).l
L008_00000D34:
; H008+$00000D34: 6000044c  bra.w $1182
        bra.w H008+$1182
L008_00000D38:
; H008+$00000D38: 4a39000024cb  tst.b $24cb.l
        tst.b (H005+$24CB).l
L008_00000D3E:
; H008+$00000D3E: 6600000c  bne.w $d4c
        bne.w H008+$D4C
L008_00000D42:
; H008+$00000D42: 4a39000024cc  tst.b $24cc.l
        tst.b (H005+$24CC).l
L008_00000D48:
; H008+$00000D48: 67000104  beq.w $e4e
        beq.w H008+$E4E
; STATE: H005+$3DE3 = native context, 5 in combat
L008_00000D4C:
; H008+$00000D4C: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L008_00000D54:
; H008+$00000D54: 660000f8  bne.w $e4e
        bne.w H008+$E4E
L008_00000D58:
; H008+$00000D58: 4a6dff98  tst.w -$68(a5)
        tst.w -$68(a5)
L008_00000D5C:
; H008+$00000D5C: 6d0000f0  blt.w $e4e
        blt.w H008+$E4E
L008_00000D60:
; H008+$00000D60: 0c6d0016ff98  cmpi.w #$16, -$68(a5)
        cmpi.w #$16, -$68(a5)
L008_00000D66:
; H008+$00000D66: 6e0000e6  bgt.w $e4e
        bgt.w H008+$E4E
L008_00000D6A:
; H008+$00000D6A: 4a6dff96  tst.w -$6a(a5)
        tst.w -$6a(a5)
L008_00000D6E:
; H008+$00000D6E: 6d0000de  blt.w $e4e
        blt.w H008+$E4E
L008_00000D72:
; H008+$00000D72: 0c6d0016ff96  cmpi.w #$16, -$6a(a5)
        cmpi.w #$16, -$6a(a5)
L008_00000D78:
; H008+$00000D78: 6e0000d4  bgt.w $e4e
        bgt.w H008+$E4E
L008_00000D7C:
; H008+$00000D7C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000D80:
; H008+$00000D80: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00000D84:
; H008+$00000D84: 4a39000024cc  tst.b $24cc.l
        tst.b (H005+$24CC).l
L008_00000D8A:
; H008+$00000D8A: 67000032  beq.w $dbe
        beq.w H008+$DBE
L008_00000D8E:
; H008+$00000D8E: 343900002438  move.w $2438.l, d2
        move.w (H005+$2438).l, d2
L008_00000D94:
; H008+$00000D94: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_00000D9A:
; H008+$00000D9A: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L008_00000D9E:
; H008+$00000D9E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000DA0:
; H008+$00000DA0: 3b42ff9c  move.w d2, -$64(a5)
        move.w d2, -$64(a5)
L008_00000DA4:
; H008+$00000DA4: 343900002436  move.w $2436.l, d2
        move.w (H005+$2436).l, d2
L008_00000DAA:
; H008+$00000DAA: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_00000DB0:
; H008+$00000DB0: 946b0004  sub.w $4(a3), d2
        sub.w $4(a3), d2
L008_00000DB4:
; H008+$00000DB4: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000DB6:
; H008+$00000DB6: 3b42ff9a  move.w d2, -$66(a5)
        move.w d2, -$66(a5)
L008_00000DBA:
; H008+$00000DBA: 6000005a  bra.w $e16
        bra.w H008+$E16
; STATE: H005+$3368 = current character
L008_00000DBE:
; H008+$00000DBE: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H048+$0AA8 (sub_H048_00000AA8)
L008_00000DC4:
; H008+$00000DC4: 4eb900000aa8  jsr $aa8.l
        jsr (H048+$AA8).l
L008_00000DCA:
; H008+$00000DCA: 3b40ff94  move.w d0, -$6c(a5)
        move.w d0, -$6c(a5)
L008_00000DCE:
; H008+$00000DCE: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000DD2:
; H008+$00000DD2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000DD4:
; H008+$00000DD4: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L008_00000DD8:
; H008+$00000DD8: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L008_00000DDE:
; H008+$00000DDE: 38332800  move.w (a3, d2.l), d4
        move.w (a3, d2.l), d4
L008_00000DE2:
; H008+$00000DE2: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_00000DE8:
; H008+$00000DE8: 986b0002  sub.w $2(a3), d4
        sub.w $2(a3), d4
L008_00000DEC:
; H008+$00000DEC: 5244  addq.w #$1, d4
        addq.w #$1, d4
L008_00000DEE:
; H008+$00000DEE: 3b44ff9c  move.w d4, -$64(a5)
        move.w d4, -$64(a5)
L008_00000DF2:
; H008+$00000DF2: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000DF6:
; H008+$00000DF6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000DF8:
; H008+$00000DF8: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L008_00000DFC:
; H008+$00000DFC: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L008_00000E02:
; H008+$00000E02: 38332802  move.w $2(a3, d2.l), d4
        move.w $2(a3, d2.l), d4
L008_00000E06:
; H008+$00000E06: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L008_00000E0C:
; H008+$00000E0C: 986b0004  sub.w $4(a3), d4
        sub.w $4(a3), d4
L008_00000E10:
; H008+$00000E10: 5244  addq.w #$1, d4
        addq.w #$1, d4
L008_00000E12:
; H008+$00000E12: 3b44ff9a  move.w d4, -$66(a5)
        move.w d4, -$66(a5)
L008_00000E16:
; H008+$00000E16: 3f2dff9c  move.w -$64(a5), -(a7)
        move.w -$64(a5), -(a7)
L008_00000E1A:
; H008+$00000E1A: 3f2dff9a  move.w -$66(a5), -(a7)
        move.w -$66(a5), -(a7)
L008_00000E1E:
; H008+$00000E1E: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_00000E22:
; H008+$00000E22: 5442  addq.w #$2, d2
        addq.w #$2, d2
L008_00000E24:
; H008+$00000E24: 48c2  ext.l d2
        ext.l d2
L008_00000E26:
; H008+$00000E26: 85fc0003  divs.w #$3, d2
        divs.w #$3, d2
L008_00000E2A:
; H008+$00000E2A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00000E2C:
; H008+$00000E2C: 342dff96  move.w -$6a(a5), d2
        move.w -$6a(a5), d2
L008_00000E30:
; H008+$00000E30: 5442  addq.w #$2, d2
        addq.w #$2, d2
L008_00000E32:
; H008+$00000E32: 48c2  ext.l d2
        ext.l d2
L008_00000E34:
; H008+$00000E34: 85fc0003  divs.w #$3, d2
        divs.w #$3, d2
L008_00000E38:
; H008+$00000E38: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H046+$0012 (sub_H046_00000012)
L008_00000E3A:
; H008+$00000E3A: 4eb900000012  jsr $12.l
        jsr (H046+$12).l
L008_00000E40:
; H008+$00000E40: 1b40ffa2  move.b d0, -$5e(a5)
        move.b d0, -$5e(a5)
L008_00000E44:
; H008+$00000E44: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000E4A:
; H008+$00000E4A: 60000336  bra.w $1182
        bra.w H008+$1182
L008_00000E4E:
; H008+$00000E4E: 4a39000024b0  tst.b $24b0.l
        tst.b (H005+$24B0).l
L008_00000E54:
; H008+$00000E54: 670000de  beq.w $f34
        beq.w H008+$F34
L008_00000E58:
; H008+$00000E58: 0c6d0003ff98  cmpi.w #$3, -$68(a5)
        cmpi.w #$3, -$68(a5)
L008_00000E5E:
; H008+$00000E5E: 6d000020  blt.w $e80
        blt.w H008+$E80
L008_00000E62:
; H008+$00000E62: 0c6d000dff98  cmpi.w #$d, -$68(a5)
        cmpi.w #$d, -$68(a5)
L008_00000E68:
; H008+$00000E68: 6e000016  bgt.w $e80
        bgt.w H008+$E80
L008_00000E6C:
; H008+$00000E6C: 0c6d0003ff96  cmpi.w #$3, -$6a(a5)
        cmpi.w #$3, -$6a(a5)
L008_00000E72:
; H008+$00000E72: 6d00000c  blt.w $e80
        blt.w H008+$E80
L008_00000E76:
; H008+$00000E76: 0c6d000dff96  cmpi.w #$d, -$6a(a5)
        cmpi.w #$d, -$6a(a5)
L008_00000E7C:
; H008+$00000E7C: 6f000044  ble.w $ec2
        ble.w H008+$EC2
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000E80:
; H008+$00000E80: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_00000E86:
; H008+$00000E86: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L008_00000E8A:
; H008+$00000E8A: 660000a8  bne.w $f34
        bne.w H008+$F34
; STATE: H005+$3DE3 = native context, 5 in combat
L008_00000E8E:
; H008+$00000E8E: 0c39000300003de3  cmpi.b #$3, $3de3.l
        cmpi.b #$3, (H005+$3DE3).l
L008_00000E96:
; H008+$00000E96: 6600009c  bne.w $f34
        bne.w H008+$F34
L008_00000E9A:
; H008+$00000E9A: 0c6d0001ff98  cmpi.w #$1, -$68(a5)
        cmpi.w #$1, -$68(a5)
L008_00000EA0:
; H008+$00000EA0: 6d000092  blt.w $f34
        blt.w H008+$F34
L008_00000EA4:
; H008+$00000EA4: 0c6d0026ff98  cmpi.w #$26, -$68(a5)
        cmpi.w #$26, -$68(a5)
L008_00000EAA:
; H008+$00000EAA: 6e000088  bgt.w $f34
        bgt.w H008+$F34
L008_00000EAE:
; H008+$00000EAE: 0c6d0001ff96  cmpi.w #$1, -$6a(a5)
        cmpi.w #$1, -$6a(a5)
L008_00000EB4:
; H008+$00000EB4: 6d00007e  blt.w $f34
        blt.w H008+$F34
L008_00000EB8:
; H008+$00000EB8: 0c6d000fff96  cmpi.w #$f, -$6a(a5)
        cmpi.w #$f, -$6a(a5)
L008_00000EBE:
; H008+$00000EBE: 6e000074  bgt.w $f34
        bgt.w H008+$F34
L008_00000EC2:
; H008+$00000EC2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00000EC6:
; H008+$00000EC6: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000ECA:
; H008+$00000ECA: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_00000ED0:
; H008+$00000ED0: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L008_00000ED4:
; H008+$00000ED4: 66000034  bne.w $f0a
        bne.w H008+$F0A
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000ED8:
; H008+$00000ED8: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_00000EDE:
; H008+$00000EDE: 342b0186  move.w $186(a3), d2
        move.w $186(a3), d2
L008_00000EE2:
; H008+$00000EE2: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000EE4:
; H008+$00000EE4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_00000EE6:
; H008+$00000EE6: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_00000EEC:
; H008+$00000EEC: 342b0188  move.w $188(a3), d2
        move.w $188(a3), d2
L008_00000EF0:
; H008+$00000EF0: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00000EF2:
; H008+$00000EF2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00000EF4:
; H008+$00000EF4: 3f2dff98  move.w -$68(a5), -(a7)
        move.w -$68(a5), -(a7)
L008_00000EF8:
; H008+$00000EF8: 3f2dff96  move.w -$6a(a5), -(a7)
        move.w -$6a(a5), -(a7)
; -> H046+$0012 (sub_H046_00000012)
L008_00000EFC:
; H008+$00000EFC: 4eb900000012  jsr $12.l
        jsr (H046+$12).l
L008_00000F02:
; H008+$00000F02: 1b40ffa2  move.b d0, -$5e(a5)
        move.b d0, -$5e(a5)
L008_00000F06:
; H008+$00000F06: 60000022  bra.w $f2a
        bra.w H008+$F2A
L008_00000F0A:
; H008+$00000F0A: 342dff96  move.w -$6a(a5), d2
        move.w -$6a(a5), d2
L008_00000F0E:
; H008+$00000F0E: 5742  subq.w #$3, d2
        subq.w #$3, d2
L008_00000F10:
; H008+$00000F10: c5fc000c  muls.w #$c, d2
        muls.w #$c, d2
L008_00000F14:
; H008+$00000F14: 47f900004f86  lea.l $4f86.l, a3
        lea.l (H005+$4F86).l, a3
L008_00000F1A:
; H008+$00000F1A: 382dff98  move.w -$68(a5), d4
        move.w -$68(a5), d4
L008_00000F1E:
; H008+$00000F1E: 5744  subq.w #$3, d4
        subq.w #$3, d4
L008_00000F20:
; H008+$00000F20: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L008_00000F24:
; H008+$00000F24: 1b734000ffa2  move.b (a3, d4.w), -$5e(a5)
        move.b (a3, d4.w), -$5e(a5)
L008_00000F2A:
; H008+$00000F2A: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00000F30:
; H008+$00000F30: 60000250  bra.w $1182
        bra.w H008+$1182
L008_00000F34:
; H008+$00000F34: 0c6d0018ff96  cmpi.w #$18, -$6a(a5)
        cmpi.w #$18, -$6a(a5)
L008_00000F3A:
; H008+$00000F3A: 660000de  bne.w $101a
        bne.w H008+$101A
L008_00000F3E:
; H008+$00000F3E: 4a2dff3b  tst.b -$c5(a5)
        tst.b -$c5(a5)
L008_00000F42:
; H008+$00000F42: 660000d6  bne.w $101a
        bne.w H008+$101A
L008_00000F46:
; H008+$00000F46: 526dff98  addq.w #$1, -$68(a5)
        addq.w #$1, -$68(a5)
L008_00000F4A:
; H008+$00000F4A: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_00000F4E:
; H008+$00000F4E: b46dff8e  cmp.w -$72(a5), d2
        cmp.w -$72(a5), d2
L008_00000F52:
; H008+$00000F52: 6e000030  bgt.w $f84
        bgt.w H008+$F84
; STATE: H005+$52F6 = pointer to the game window
L008_00000F56:
; H008+$00000F56: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
; STATE: H005+$52F6 = pointer to the game window
L008_00000F5C:
; H008+$00000F5C: 2679000052f6  movea.l $52f6.l, a3
        movea.l (H005+$52F6).l, a3
L008_00000F62:
; H008+$00000F62: 242b0052  move.l $52(a3), d2
        move.l $52(a3), d2
L008_00000F66:
; H008+$00000F66: 283c00400000  move.l #$400000, d4
        move.l #$400000, d4
L008_00000F6C:
; H008+$00000F6C: 4684  not.l d4
        not.l d4
L008_00000F6E:
; H008+$00000F6E: c484  and.l d4, d2
        and.l d4, d2
L008_00000F70:
; H008+$00000F70: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H021+$026C (wrapper_ModifyIDCMP)
L008_00000F72:
; H008+$00000F72: 4eb90000026c  jsr $26c.l
        jsr (H021+$26C).l
L008_00000F78:
; H008+$00000F78: 102dffa1  move.b -$5f(a5), d0
        move.b -$5f(a5), d0
L008_00000F7C:
; H008+$00000F7C: 60000414  bra.w $1392
        bra.w H008+$1392
; Preserved bytes H008+$00000F80..$00000F84; code/data not fully classified.
        dc.w $6000,$000E
L008_00000F84:
; H008+$00000F84: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_00000F88:
; H008+$00000F88: 946dff8e  sub.w -$72(a5), d2
        sub.w -$72(a5), d2
L008_00000F8C:
; H008+$00000F8C: 3b42ff98  move.w d2, -$68(a5)
        move.w d2, -$68(a5)
L008_00000F90:
; H008+$00000F90: 3b7c0001ff94  move.w #$1, -$6c(a5)
        move.w #$1, -$6c(a5)
L008_00000F96:
; H008+$00000F96: 3f2dff8c  move.w -$74(a5), -(a7)
        move.w -$74(a5), -(a7)
L008_00000F9A:
; H008+$00000F9A: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000F9E:
; H008+$00000F9E: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L008_00000FA0:
; H008+$00000FA0: 62000072  bhi.w $1014
        bhi.w H008+$1014
L008_00000FA4:
; H008+$00000FA4: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000FA8:
; H008+$00000FA8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000FAA:
; H008+$00000FAA: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000FAC:
; H008+$00000FAC: 47edff3c  lea.l -$c4(a5), a3
        lea.l -$c4(a5), a3
L008_00000FB0:
; H008+$00000FB0: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L008_00000FB4:
; H008+$00000FB4: 5244  addq.w #$1, d4
        addq.w #$1, d4
L008_00000FB6:
; H008+$00000FB6: b86dff98  cmp.w -$68(a5), d4
        cmp.w -$68(a5), d4
L008_00000FBA:
; H008+$00000FBA: 6e000052  bgt.w $100e
        bgt.w H008+$100E
L008_00000FBE:
; H008+$00000FBE: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000FC2:
; H008+$00000FC2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000FC4:
; H008+$00000FC4: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000FC6:
; H008+$00000FC6: 47edff3c  lea.l -$c4(a5), a3
        lea.l -$c4(a5), a3
L008_00000FCA:
; H008+$00000FCA: 38332002  move.w $2(a3, d2.w), d4
        move.w $2(a3, d2.w), d4
L008_00000FCE:
; H008+$00000FCE: 5244  addq.w #$1, d4
        addq.w #$1, d4
L008_00000FD0:
; H008+$00000FD0: b86dff98  cmp.w -$68(a5), d4
        cmp.w -$68(a5), d4
L008_00000FD4:
; H008+$00000FD4: 6d000038  blt.w $100e
        blt.w H008+$100E
L008_00000FD8:
; H008+$00000FD8: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000FDC:
; H008+$00000FDC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00000FDE:
; H008+$00000FDE: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00000FE0:
; H008+$00000FE0: 47edff3c  lea.l -$c4(a5), a3
        lea.l -$c4(a5), a3
L008_00000FE4:
; H008+$00000FE4: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L008_00000FE8:
; H008+$00000FE8: 266d001a  movea.l $1a(a5), a3
        movea.l $1a(a5), a3
L008_00000FEC:
; H008+$00000FEC: 1b734000ffa2  move.b (a3, d4.w), -$5e(a5)
        move.b (a3, d4.w), -$5e(a5)
L008_00000FF2:
; H008+$00000FF2: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00000FF6:
; H008+$00000FF6: 13c200002483  move.b d2, $2483.l
        move.b d2, (H005+$2483).l
L008_00000FFC:
; H008+$00000FFC: 1f3900002483  move.b $2483.l, -(a7)
        move.b (H005+$2483).l, -(a7)
L008_00001002:
; H008+$00001002: 4855  pea.l (a5)
        pea.l (a5)
L008_00001004:
; H008+$00001004: 6100f3c2  bsr.w $3c8
        bsr.w H008+$3C8
L008_00001008:
; H008+$00001008: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_0000100E:
; H008+$0000100E: 526dff94  addq.w #$1, -$6c(a5)
        addq.w #$1, -$6c(a5)
L008_00001012:
; H008+$00001012: 6486  bcc.b $f9a
        bcc.b H008+$F9A
L008_00001014:
; H008+$00001014: 548f  addq.l #$2, a7
        addq.l #$2, a7
L008_00001016:
; H008+$00001016: 6000016a  bra.w $1182
        bra.w H008+$1182
L008_0000101A:
; H008+$0000101A: 4a39000024da  tst.b $24da.l
        tst.b (H005+$24DA).l
L008_00001020:
; H008+$00001020: 670000c6  beq.w $10e8
        beq.w H008+$10E8
L008_00001024:
; H008+$00001024: 4a2dff3b  tst.b -$c5(a5)
        tst.b -$c5(a5)
L008_00001028:
; H008+$00001028: 660000be  bne.w $10e8
        bne.w H008+$10E8
L008_0000102C:
; H008+$0000102C: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_00001032:
; H008+$00001032: 342dff96  move.w -$6a(a5), d2
        move.w -$6a(a5), d2
L008_00001036:
; H008+$00001036: 60000086  bra.w $10be
        bra.w H008+$10BE
L008_0000103A:
; H008+$0000103A: 0c6d0001ff98  cmpi.w #$1, -$68(a5)
        cmpi.w #$1, -$68(a5)
L008_00001040:
; H008+$00001040: 6d000014  blt.w $1056
        blt.w H008+$1056
L008_00001044:
; H008+$00001044: 0c6d0010ff98  cmpi.w #$10, -$68(a5)
        cmpi.w #$10, -$68(a5)
L008_0000104A:
; H008+$0000104A: 6e00000a  bgt.w $1056
        bgt.w H008+$1056
L008_0000104E:
; H008+$0000104E: 33fc000600002506  move.w #$6, $2506.l
        move.w #$6, (H005+$2506).l
L008_00001056:
; H008+$00001056: 4e75  rts 
        rts 
L008_00001058:
; H008+$00001058: 0c6d001fff98  cmpi.w #$1f, -$68(a5)
        cmpi.w #$1f, -$68(a5)
L008_0000105E:
; H008+$0000105E: 6d000014  blt.w $1074
        blt.w H008+$1074
L008_00001062:
; H008+$00001062: 0c6d0021ff98  cmpi.w #$21, -$68(a5)
        cmpi.w #$21, -$68(a5)
L008_00001068:
; H008+$00001068: 6e00000a  bgt.w $1074
        bgt.w H008+$1074
L008_0000106C:
; H008+$0000106C: 33fc000700002506  move.w #$7, $2506.l
        move.w #$7, (H005+$2506).l
L008_00001074:
; H008+$00001074: 4e75  rts 
        rts 
L008_00001076:
; H008+$00001076: 0c6d0005ff98  cmpi.w #$5, -$68(a5)
        cmpi.w #$5, -$68(a5)
L008_0000107C:
; H008+$0000107C: 6d00001a  blt.w $1098
        blt.w H008+$1098
L008_00001080:
; H008+$00001080: 0c6d0009ff98  cmpi.w #$9, -$68(a5)
        cmpi.w #$9, -$68(a5)
L008_00001086:
; H008+$00001086: 6e000010  bgt.w $1098
        bgt.w H008+$1098
L008_0000108A:
; H008+$0000108A: 342dff96  move.w -$6a(a5), d2
        move.w -$6a(a5), d2
L008_0000108E:
; H008+$0000108E: 04420009  subi.w #$9, d2
        subi.w #$9, d2
L008_00001092:
; H008+$00001092: 33c200002506  move.w d2, $2506.l
        move.w d2, (H005+$2506).l
L008_00001098:
; H008+$00001098: 4e75  rts 
        rts 
L008_0000109A:
; H008+$0000109A: 422dff3b  clr.b -$c5(a5)
        clr.b -$c5(a5)
L008_0000109E:
; H008+$0000109E: 4e75  rts 
        rts 
; Preserved bytes H008+$000010A0..$000010BE; code/data not fully classified.
        dc.w $FFF8,$FF98,$FFF8,$FFB6,$FFF8,$FFF8,$FFF8,$FFF8
        dc.w $FFF8,$FFD4,$FFD4,$FFD4,$FFD4,$FFD4,$FFD4
L008_000010BE:
; H008+$000010BE: 47faffe2  lea.l $10a2(pc), a3
        lea.l H008+$10A2(pc), a3
L008_000010C2:
; H008+$000010C2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000010C4:
; H008+$000010C4: 0c42000d  cmpi.w #$d, d2
        cmpi.w #$d, d2
L008_000010C8:
; H008+$000010C8: 6302  bls.b $10cc
        bls.b H008+$10CC
L008_000010CA:
; H008+$000010CA: 74ff  moveq #$ff, d2
        moveq #-1, d2
L008_000010CC:
; H008+$000010CC: e342  asl.w #$1, d2
        asl.w #$1, d2
L008_000010CE:
; H008+$000010CE: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H008+$10A2; indices 0..13, default -1.
L008_000010D2:
; H008+$000010D2: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L008_000010D6:
; H008+$000010D6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_000010DA:
; H008+$000010DA: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_000010DE:
; H008+$000010DE: 1b7c0047ffa2  move.b #$47, -$5e(a5)
        move.b #$47, -$5e(a5)
L008_000010E4:
; H008+$000010E4: 6000009c  bra.w $1182
        bra.w H008+$1182
L008_000010E8:
; H008+$000010E8: 4a2dff3b  tst.b -$c5(a5)
        tst.b -$c5(a5)
L008_000010EC:
; H008+$000010EC: 66000094  bne.w $1182
        bne.w H008+$1182
L008_000010F0:
; H008+$000010F0: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_000010F4:
; H008+$000010F4: b47900002504  cmp.w $2504.l, d2
        cmp.w (H005+$2504).l, d2
L008_000010FA:
; H008+$000010FA: 6d000086  blt.w $1182
        blt.w H008+$1182
L008_000010FE:
; H008+$000010FE: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_00001102:
; H008+$00001102: b47900002502  cmp.w $2502.l, d2
        cmp.w (H005+$2502).l, d2
L008_00001108:
; H008+$00001108: 6e000078  bgt.w $1182
        bgt.w H008+$1182
L008_0000110C:
; H008+$0000110C: 3b7c0001ff94  move.w #$1, -$6c(a5)
        move.w #$1, -$6c(a5)
L008_00001112:
; H008+$00001112: 0c6d0019ff94  cmpi.w #$19, -$6c(a5)
        cmpi.w #$19, -$6c(a5)
L008_00001118:
; H008+$00001118: 62000068  bhi.w $1182
        bhi.w H008+$1182
L008_0000111C:
; H008+$0000111C: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00001120:
; H008+$00001120: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001122:
; H008+$00001122: 47f900002778  lea.l $2778.l, a3
        lea.l (H005+$2778).l, a3
L008_00001128:
; H008+$00001128: 7800  moveq #$0, d4
        moveq #0, d4
L008_0000112A:
; H008+$0000112A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L008_0000112E:
; H008+$0000112E: 0c4400ff  cmpi.w #$ff, d4
        cmpi.w #$ff, d4
L008_00001132:
; H008+$00001132: 6700004e  beq.w $1182
        beq.w H008+$1182
L008_00001136:
; H008+$00001136: 4a2dff3b  tst.b -$c5(a5)
        tst.b -$c5(a5)
L008_0000113A:
; H008+$0000113A: 66000046  bne.w $1182
        bne.w H008+$1182
L008_0000113E:
; H008+$0000113E: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00001142:
; H008+$00001142: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001144:
; H008+$00001144: 47f900002778  lea.l $2778.l, a3
        lea.l (H005+$2778).l, a3
L008_0000114A:
; H008+$0000114A: 7800  moveq #$0, d4
        moveq #0, d4
L008_0000114C:
; H008+$0000114C: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L008_00001150:
; H008+$00001150: b86dff96  cmp.w -$6a(a5), d4
        cmp.w -$6a(a5), d4
L008_00001154:
; H008+$00001154: 6e000026  bgt.w $117c
        bgt.w H008+$117C
L008_00001158:
; H008+$00001158: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_0000115E:
; H008+$0000115E: 7400  moveq #$0, d2
        moveq #0, d2
L008_00001160:
; H008+$00001160: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_00001166:
; H008+$00001166: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001168:
; H008+$00001168: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_0000116A:
; H008+$0000116A: 47edff3c  lea.l -$c4(a5), a3
        lea.l -$c4(a5), a3
L008_0000116E:
; H008+$0000116E: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L008_00001172:
; H008+$00001172: 266d001a  movea.l $1a(a5), a3
        movea.l $1a(a5), a3
L008_00001176:
; H008+$00001176: 1b734000ffa2  move.b (a3, d4.w), -$5e(a5)
        move.b (a3, d4.w), -$5e(a5)
L008_0000117C:
; H008+$0000117C: 526dff94  addq.w #$1, -$6c(a5)
        addq.w #$1, -$6c(a5)
L008_00001180:
; H008+$00001180: 6090  bra.b $1112
        bra.b H008+$1112
L008_00001182:
; H008+$00001182: 60000034  bra.w $11b8
        bra.w H008+$11B8
L008_00001186:
; H008+$00001186: 7400  moveq #$0, d2
        moveq #0, d2
L008_00001188:
; H008+$00001188: 143900002483  move.b $2483.l, d2
        move.b (H005+$2483).l, d2
L008_0000118E:
; H008+$0000118E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001190:
; H008+$00001190: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_00001192:
; H008+$00001192: 47edff3c  lea.l -$c4(a5), a3
        lea.l -$c4(a5), a3
L008_00001196:
; H008+$00001196: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L008_0000119A:
; H008+$0000119A: 266d001a  movea.l $1a(a5), a3
        movea.l $1a(a5), a3
L008_0000119E:
; H008+$0000119E: 1b734000ffa2  move.b (a3, d4.w), -$5e(a5)
        move.b (a3, d4.w), -$5e(a5)
L008_000011A4:
; H008+$000011A4: 4a2dffa2  tst.b -$5e(a5)
        tst.b -$5e(a5)
L008_000011A8:
; H008+$000011A8: 66000008  bne.w $11b2
        bne.w H008+$11B2
L008_000011AC:
; H008+$000011AC: 1b7c000dffa2  move.b #$d, -$5e(a5)
        move.b #$d, -$5e(a5)
L008_000011B2:
; H008+$000011B2: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_000011B8:
; H008+$000011B8: 4e75  rts 
        rts 
L008_000011BA:
; H008+$000011BA: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_000011BE:
; H008+$000011BE: 0c020061  cmpi.b #$61, d2
        cmpi.b #$61, d2
L008_000011C2:
; H008+$000011C2: 650a  bcs.b $11ce
        bcs.b H008+$11CE
L008_000011C4:
; H008+$000011C4: 0c02007a  cmpi.b #$7a, d2
        cmpi.b #$7a, d2
L008_000011C8:
; H008+$000011C8: 6204  bhi.b $11ce
        bhi.b H008+$11CE
L008_000011CA:
; H008+$000011CA: 0202005f  andi.b #$5f, d2
        andi.b #$5f, d2
L008_000011CE:
; H008+$000011CE: 1b42ffa2  move.b d2, -$5e(a5)
        move.b d2, -$5e(a5)
L008_000011D2:
; H008+$000011D2: 1f2dffa2  move.b -$5e(a5), -(a7)
        move.b -$5e(a5), -(a7)
L008_000011D6:
; H008+$000011D6: 6100efc8  bsr.w $1a0
        bsr.w H008+$1A0
L008_000011DA:
; H008+$000011DA: 1400  move.b d0, d2
        move.b d0, d2
L008_000011DC:
; H008+$000011DC: 4a02  tst.b d2
        tst.b d2
L008_000011DE:
; H008+$000011DE: 6600000c  bne.w $11ec
        bne.w H008+$11EC
L008_000011E2:
; H008+$000011E2: 0c2d0020ffa2  cmpi.b #$20, -$5e(a5)
        cmpi.b #$20, -$5e(a5)
L008_000011E8:
; H008+$000011E8: 66000084  bne.w $126e
        bne.w H008+$126E
L008_000011EC:
; H008+$000011EC: 0c2d0020ffa2  cmpi.b #$20, -$5e(a5)
        cmpi.b #$20, -$5e(a5)
L008_000011F2:
; H008+$000011F2: 6600000c  bne.w $1200
        bne.w H008+$1200
L008_000011F6:
; H008+$000011F6: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_000011FC:
; H008+$000011FC: 60000070  bra.w $126e
        bra.w H008+$126E
L008_00001200:
; H008+$00001200: 426dff94  clr.w -$6c(a5)
        clr.w -$6c(a5)
L008_00001204:
; H008+$00001204: 3f2dff90  move.w -$70(a5), -(a7)
        move.w -$70(a5), -(a7)
L008_00001208:
; H008+$00001208: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_0000120C:
; H008+$0000120C: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L008_0000120E:
; H008+$0000120E: 6200005c  bhi.w $126c
        bhi.w H008+$126C
L008_00001212:
; H008+$00001212: 342dff94  move.w -$6c(a5), d2
        move.w -$6c(a5), d2
L008_00001216:
; H008+$00001216: 266d001a  movea.l $1a(a5), a3
        movea.l $1a(a5), a3
L008_0000121A:
; H008+$0000121A: 182dffa2  move.b -$5e(a5), d4
        move.b -$5e(a5), d4
L008_0000121E:
; H008+$0000121E: b8332000  cmp.b (a3, d2.w), d4
        cmp.b (a3, d2.w), d4
L008_00001222:
; H008+$00001222: 66000042  bne.w $1266
        bne.w H008+$1266
L008_00001226:
; H008+$00001226: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_0000122C:
; H008+$0000122C: 3b7c0001ff98  move.w #$1, -$68(a5)
        move.w #$1, -$68(a5)
L008_00001232:
; H008+$00001232: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_00001236:
; H008+$00001236: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001238:
; H008+$00001238: e542  asl.w #$2, d2
        asl.w #$2, d2
L008_0000123A:
; H008+$0000123A: 47edff3c  lea.l -$c4(a5), a3
        lea.l -$c4(a5), a3
L008_0000123E:
; H008+$0000123E: 382dff94  move.w -$6c(a5), d4
        move.w -$6c(a5), d4
L008_00001242:
; H008+$00001242: b8732000  cmp.w (a3, d2.w), d4
        cmp.w (a3, d2.w), d4
L008_00001246:
; H008+$00001246: 67000008  beq.w $1250
        beq.w H008+$1250
L008_0000124A:
; H008+$0000124A: 526dff98  addq.w #$1, -$68(a5)
        addq.w #$1, -$68(a5)
L008_0000124E:
; H008+$0000124E: 60e2  bra.b $1232
        bra.b H008+$1232
L008_00001250:
; H008+$00001250: 342dff98  move.w -$68(a5), d2
        move.w -$68(a5), d2
L008_00001254:
; H008+$00001254: 13c200002483  move.b d2, $2483.l
        move.b d2, (H005+$2483).l
L008_0000125A:
; H008+$0000125A: 1f3900002483  move.b $2483.l, -(a7)
        move.b (H005+$2483).l, -(a7)
L008_00001260:
; H008+$00001260: 4855  pea.l (a5)
        pea.l (a5)
L008_00001262:
; H008+$00001262: 6100f164  bsr.w $3c8
        bsr.w H008+$3C8
L008_00001266:
; H008+$00001266: 526dff94  addq.w #$1, -$6c(a5)
        addq.w #$1, -$6c(a5)
L008_0000126A:
; H008+$0000126A: 649c  bcc.b $1208
        bcc.b H008+$1208
L008_0000126C:
; H008+$0000126C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L008_0000126E:
; H008+$0000126E: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L008_00001272:
; H008+$00001272: 67000060  beq.w $12d4
        beq.w H008+$12D4
L008_00001276:
; H008+$00001276: 7400  moveq #$0, d2
        moveq #0, d2
L008_00001278:
; H008+$00001278: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_0000127C:
; H008+$0000127C: 0c420031  cmpi.w #$31, d2
        cmpi.w #$31, d2
L008_00001280:
; H008+$00001280: 65000010  bcs.w $1292
        bcs.w H008+$1292
L008_00001284:
; H008+$00001284: 7400  moveq #$0, d2
        moveq #0, d2
L008_00001286:
; H008+$00001286: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_0000128A:
; H008+$0000128A: 0c420039  cmpi.w #$39, d2
        cmpi.w #$39, d2
L008_0000128E:
; H008+$0000128E: 6300000c  bls.w $129c
        bls.w H008+$129C
L008_00001292:
; H008+$00001292: 0c2d005cffa2  cmpi.b #$5c, -$5e(a5)
        cmpi.b #$5c, -$5e(a5)
L008_00001298:
; H008+$00001298: 6600003a  bne.w $12d4
        bne.w H008+$12D4
L008_0000129C:
; H008+$0000129C: 0c2d005cffa2  cmpi.b #$5c, -$5e(a5)
        cmpi.b #$5c, -$5e(a5)
L008_000012A2:
; H008+$000012A2: 6600000c  bne.w $12b0
        bne.w H008+$12B0
L008_000012A6:
; H008+$000012A6: 1b7c0037ffa2  move.b #$37, -$5e(a5)
        move.b #$37, -$5e(a5)
L008_000012AC:
; H008+$000012AC: 60000018  bra.w $12c6
        bra.w H008+$12C6
L008_000012B0:
; H008+$000012B0: 7400  moveq #$0, d2
        moveq #0, d2
L008_000012B2:
; H008+$000012B2: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_000012B6:
; H008+$000012B6: 04420031  subi.w #$31, d2
        subi.w #$31, d2
L008_000012BA:
; H008+$000012BA: 47f900004f7c  lea.l $4f7c.l, a3
        lea.l (H005+$4F7C).l, a3
L008_000012C0:
; H008+$000012C0: 1b732000ffa2  move.b (a3, d2.w), -$5e(a5)
        move.b (a3, d2.w), -$5e(a5)
L008_000012C6:
; H008+$000012C6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_000012CA:
; H008+$000012CA: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_000012CE:
; H008+$000012CE: 1b7c0001ff3b  move.b #$1, -$c5(a5)
        move.b #$1, -$c5(a5)
L008_000012D4:
; H008+$000012D4: 4e75  rts 
        rts 
; Preserved bytes H008+$000012D6..$0000132C; code/data not fully classified.
        dc.w $FEE2,$F8CE,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2
        dc.w $FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$F8C2
        dc.w $FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2
        dc.w $FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2
        dc.w $FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2,$FEE2
        dc.w $F7C8,$FEE2,$F846
L008_0000132C:
; H008+$0000132C: 47faffaa  lea.l $12d8(pc), a3
        lea.l H008+$12D8(pc), a3
L008_00001330:
; H008+$00001330: 0442000d  subi.w #$d, d2
        subi.w #$d, d2
L008_00001334:
; H008+$00001334: 0c420029  cmpi.w #$29, d2
        cmpi.w #$29, d2
L008_00001338:
; H008+$00001338: 6302  bls.b $133c
        bls.b H008+$133C
L008_0000133A:
; H008+$0000133A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L008_0000133C:
; H008+$0000133C: e342  asl.w #$1, d2
        asl.w #$1, d2
L008_0000133E:
; H008+$0000133E: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H008+$12D8; indices 0..41, default -1.
L008_00001342:
; H008+$00001342: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L008_00001346:
; H008+$00001346: 4a2dff3b  tst.b -$c5(a5)
        tst.b -$c5(a5)
L008_0000134A:
; H008+$0000134A: 6700f34e  beq.w $69a
        beq.w H008+$69A
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L008_0000134E:
; H008+$0000134E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L008_00001354:
; H008+$00001354: 426b03fe  clr.w $3fe(a3)
        clr.w $3fe(a3)
L008_00001358:
; H008+$00001358: 1b6dffa2ffa1  move.b -$5e(a5), -$5f(a5)
        move.b -$5e(a5), -$5f(a5)
L008_0000135E:
; H008+$0000135E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001362:
; H008+$00001362: 13d30000249d  move.b (a3), $249d.l
        move.b (a3), (H005+$249D).l
; STATE: H005+$52F6 = pointer to the game window
L008_00001368:
; H008+$00001368: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
; STATE: H005+$52F6 = pointer to the game window
L008_0000136E:
; H008+$0000136E: 2679000052f6  movea.l $52f6.l, a3
        movea.l (H005+$52F6).l, a3
L008_00001374:
; H008+$00001374: 242b0052  move.l $52(a3), d2
        move.l $52(a3), d2
L008_00001378:
; H008+$00001378: 283c00400000  move.l #$400000, d4
        move.l #$400000, d4
L008_0000137E:
; H008+$0000137E: 4684  not.l d4
        not.l d4
L008_00001380:
; H008+$00001380: c484  and.l d4, d2
        and.l d4, d2
L008_00001382:
; H008+$00001382: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H021+$026C (wrapper_ModifyIDCMP)
L008_00001384:
; H008+$00001384: 4eb90000026c  jsr $26c.l
        jsr (H021+$26C).l
L008_0000138A:
; H008+$0000138A: 102dffa1  move.b -$5f(a5), d0
        move.b -$5f(a5), d0
L008_0000138E:
; H008+$0000138E: 60000002  bra.w $1392
        bra.w H008+$1392
L008_00001392:
; H008+$00001392: 4e5d  unlk a5
        unlk a5
L008_00001394:
; H008+$00001394: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_00001396:
; H008+$00001396: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00001398:
; H008+$00001398: 4fef001a  lea.l $1a(a7), a7
        lea.l $1a(a7), a7
L008_0000139C:
; H008+$0000139C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_0000139E [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H030+$019A.
;   - Calls H030+$019A.
; Direct callers: H006+$06E8, H006+$0B5E, H061+$1AF2, H061+$1BC6, H013+$5136, H013+$538C and 16 more
; --------------------------------------------------------------------------
L008_0000139E:
; H008+$0000139E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_000013A0:
; H008+$000013A0: 287aecf4  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_000013A4:
; H008+$000013A4: 4e550000  link.w a5, #$0
        link.w a5, #$0
L008_000013A8:
; H008+$000013A8: 4267  clr.w -(a7)
        clr.w -(a7)
L008_000013AA:
; H008+$000013AA: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L008_000013AE:
; H008+$000013AE: 4267  clr.w -(a7)
        clr.w -(a7)
L008_000013B0:
; H008+$000013B0: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
; -> H030+$019A (sub_H030_0000019A)
L008_000013B4:
; H008+$000013B4: 4eb90000019a  jsr $19a.l
        jsr (H030+$19A).l
L008_000013BA:
; H008+$000013BA: 4e5d  unlk a5
        unlk a5
L008_000013BC:
; H008+$000013BC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_000013BE:
; H008+$000013BE: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H008_1AF4 [partial]
; Purpose: Trampoline to H008+$1AF4; the actual body is there.
;   - Jumps to the actual body at H008+$1AF4.
;   - Calls H026+$0188.
;   - Calls H026+$01E0.
;   - Uses the global state: H005+$2354 (mouse Y coordinate); H005+$2356 (mouse X coordinate).
; Direct callers: H013+$4F24, H013+$5362, H013+$0BC0, H013+$0DF4, H013+$0F58, H065+$1836 and 11 more
; --------------------------------------------------------------------------
L008_000013C0:
; H008+$000013C0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_000013C2:
; H008+$000013C2: 287aecd2  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_000013C6:
; H008+$000013C6: 4e55ff6a  link.w a5, #$ff6a
        link.w a5, #$ff6a
L008_000013CA:
; H008+$000013CA: 60000728  bra.w $1af4
        bra.w H008+$1AF4
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_000013CE [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H008+$14AE
; --------------------------------------------------------------------------
L008_000013CE:
; H008+$000013CE: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L008_000013D2:
; H008+$000013D2: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L008_000013D6:
; H008+$000013D6: 2b6d000cfffc  move.l $c(a5), -$4(a5)
        move.l $c(a5), -$4(a5)
L008_000013DC:
; H008+$000013DC: 42adfff8  clr.l -$8(a5)
        clr.l -$8(a5)
L008_000013E0:
; H008+$000013E0: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L008_000013E4:
; H008+$000013E4: 67000030  beq.w $1416
        beq.w H008+$1416
L008_000013E8:
; H008+$000013E8: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L008_000013EC:
; H008+$000013EC: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L008_000013F0:
; H008+$000013F0: 6c000024  bge.w $1416
        bge.w H008+$1416
L008_000013F4:
; H008+$000013F4: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_000013F8:
; H008+$000013F8: 4a2b002a  tst.b $2a(a3)
        tst.b $2a(a3)
L008_000013FC:
; H008+$000013FC: 67000008  beq.w $1406
        beq.w H008+$1406
L008_00001400:
; H008+$00001400: 2b6dfffcfff8  move.l -$4(a5), -$8(a5)
        move.l -$4(a5), -$8(a5)
L008_00001406:
; H008+$00001406: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_0000140A:
; H008+$0000140A: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L008_00001410:
; H008+$00001410: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L008_00001414:
; H008+$00001414: 60ca  bra.b $13e0
        bra.b H008+$13E0
L008_00001416:
; H008+$00001416: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L008_0000141A:
; H008+$0000141A: 6600001a  bne.w $1436
        bne.w H008+$1436
L008_0000141E:
; H008+$0000141E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001422:
; H008+$00001422: 4a2b002a  tst.b $2a(a3)
        tst.b $2a(a3)
L008_00001426:
; H008+$00001426: 6700000e  beq.w $1436
        beq.w H008+$1436
L008_0000142A:
; H008+$0000142A: 202d000c  move.l $c(a5), d0
        move.l $c(a5), d0
L008_0000142E:
; H008+$0000142E: 6000000e  bra.w $143e
        bra.w H008+$143E
; Preserved bytes H008+$00001432..$00001436; code/data not fully classified.
        dc.w $6000,$000A
L008_00001436:
; H008+$00001436: 202dfff8  move.l -$8(a5), d0
        move.l -$8(a5), d0
L008_0000143A:
; H008+$0000143A: 60000002  bra.w $143e
        bra.w H008+$143E
L008_0000143E:
; H008+$0000143E: 4e5d  unlk a5
        unlk a5
L008_00001440:
; H008+$00001440: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00001442:
; H008+$00001442: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L008_00001446:
; H008+$00001446: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_00001448 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H029+$0312, H030+$0B6C, H030+$0256, H026+$000C.
;   - Calls H029+$0312.
;   - Calls H030+$0B6C.
;   - Calls H030+$0256.
;   - Calls H026+$000C.
;   - Calls H030+$00B6.
; Direct callers: H008+$1C50, H008+$1A54
; --------------------------------------------------------------------------
L008_00001448:
; H008+$00001448: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L008_0000144C:
; H008+$0000144C: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L008_00001450:
; H008+$00001450: 487900002778  pea.l $2778.l
        pea.l (H005+$2778).l
L008_00001456:
; H008+$00001456: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
L008_0000145A:
; H008+$0000145A: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
; -> H029+$0312 (sub_H029_00000312)
L008_0000145E:
; H008+$0000145E: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L008_00001464:
; H008+$00001464: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001468:
; H008+$00001468: 3f2b0024  move.w $24(a3), -(a7)
        move.w $24(a3), -(a7)
L008_0000146C:
; H008+$0000146C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001470:
; H008+$00001470: 3f2b0022  move.w $22(a3), -(a7)
        move.w $22(a3), -(a7)
L008_00001474:
; H008+$00001474: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001478:
; H008+$00001478: 3f2b0020  move.w $20(a3), -(a7)
        move.w $20(a3), -(a7)
L008_0000147C:
; H008+$0000147C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001480:
; H008+$00001480: 3f2b001e  move.w $1e(a3), -(a7)
        move.w $1e(a3), -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L008_00001484:
; H008+$00001484: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L008_0000148A:
; H008+$0000148A: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L008_0000148E:
; H008+$0000148E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001492:
; H008+$00001492: 2f2b001a  move.l $1a(a3), -(a7)
        move.l $1a(a3), -(a7)
L008_00001496:
; H008+$00001496: 6100ec6a  bsr.w $102
        bsr.w H008+$102
L008_0000149A:
; H008+$0000149A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L008_0000149E:
; H008+$0000149E: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L008_000014A2:
; H008+$000014A2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000014A6:
; H008+$000014A6: 2f2b001a  move.l $1a(a3), -(a7)
        move.l $1a(a3), -(a7)
L008_000014AA:
; H008+$000014AA: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_000014AE:
; H008+$000014AE: 6100ff1e  bsr.w $13ce
        bsr.w H008+$13CE
L008_000014B2:
; H008+$000014B2: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L008_000014B6:
; H008+$000014B6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000014BA:
; H008+$000014BA: 3b6b0022fff6  move.w $22(a3), -$a(a5)
        move.w $22(a3), -$a(a5)
L008_000014C0:
; H008+$000014C0: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000014C4:
; H008+$000014C4: 377c0001ffaa  move.w #$1, -$56(a3)
        move.w #$1, -$56(a3)
L008_000014CA:
; H008+$000014CA: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L008_000014CE:
; H008+$000014CE: 67000104  beq.w $15d4
        beq.w H008+$15D4
L008_000014D2:
; H008+$000014D2: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L008_000014D6:
; H008+$000014D6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000014DA:
; H008+$000014DA: b46b001e  cmp.w $1e(a3), d2
        cmp.w $1e(a3), d2
L008_000014DE:
; H008+$000014DE: 6e0000f4  bgt.w $15d4
        bgt.w H008+$15D4
L008_000014E2:
; H008+$000014E2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000014E6:
; H008+$000014E6: 342bffaa  move.w -$56(a3), d2
        move.w -$56(a3), d2
L008_000014EA:
; H008+$000014EA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000014EC:
; H008+$000014EC: 47f900002778  lea.l $2778.l, a3
        lea.l (H005+$2778).l, a3
L008_000014F2:
; H008+$000014F2: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L008_000014F6:
; H008+$000014F6: 17842000  move.b d4, (a3, d2.w)
        move.b d4, (a3, d2.w)
L008_000014FA:
; H008+$000014FA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_000014FE:
; H008+$000014FE: 4a2b002a  tst.b $2a(a3)
        tst.b $2a(a3)
L008_00001502:
; H008+$00001502: 6700002a  beq.w $152e
        beq.w H008+$152E
L008_00001506:
; H008+$00001506: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000150A:
; H008+$0000150A: 3f2b0024  move.w $24(a3), -(a7)
        move.w $24(a3), -(a7)
L008_0000150E:
; H008+$0000150E: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L008_00001512:
; H008+$00001512: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001516:
; H008+$00001516: 3f2b002a  move.w $2a(a3), -(a7)
        move.w $2a(a3), -(a7)
L008_0000151A:
; H008+$0000151A: 4267  clr.w -(a7)
        clr.w -(a7)
L008_0000151C:
; H008+$0000151C: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001520:
; H008+$00001520: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; FLOW: Calls UI_DrawText (H030+$0256).
L008_00001524:
; H008+$00001524: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L008_0000152A:
; H008+$0000152A: 60000026  bra.w $1552
        bra.w H008+$1552
L008_0000152E:
; H008+$0000152E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001532:
; H008+$00001532: 3f2b0024  move.w $24(a3), -(a7)
        move.w $24(a3), -(a7)
L008_00001536:
; H008+$00001536: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L008_0000153A:
; H008+$0000153A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000153E:
; H008+$0000153E: 3f2b0028  move.w $28(a3), -(a7)
        move.w $28(a3), -(a7)
L008_00001542:
; H008+$00001542: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00001544:
; H008+$00001544: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001548:
; H008+$00001548: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; FLOW: Calls UI_DrawText (H030+$0256).
L008_0000154C:
; H008+$0000154C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L008_00001552:
; H008+$00001552: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001556:
; H008+$00001556: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_0000155A:
; H008+$0000155A: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_00001560:
; H008+$00001560: 3400  move.w d0, d2
        move.w d0, d2
L008_00001562:
; H008+$00001562: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001566:
; H008+$00001566: b46bffac  cmp.w -$54(a3), d2
        cmp.w -$54(a3), d2
L008_0000156A:
; H008+$0000156A: 6400004e  bcc.w $15ba
        bcc.w H008+$15BA
L008_0000156E:
; H008+$0000156E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001572:
; H008+$00001572: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_00001576:
; H008+$00001576: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_0000157C:
; H008+$0000157C: 3400  move.w d0, d2
        move.w d0, d2
L008_0000157E:
; H008+$0000157E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001582:
; H008+$00001582: d46b0024  add.w $24(a3), d2
        add.w $24(a3), d2
L008_00001586:
; H008+$00001586: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00001588:
; H008+$00001588: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L008_0000158C:
; H008+$0000158C: 4267  clr.w -(a7)
        clr.w -(a7)
L008_0000158E:
; H008+$0000158E: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00001590:
; H008+$00001590: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001594:
; H008+$00001594: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_00001598:
; H008+$00001598: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_0000159E:
; H008+$0000159E: 3400  move.w d0, d2
        move.w d0, d2
L008_000015A0:
; H008+$000015A0: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000015A4:
; H008+$000015A4: 382bffac  move.w -$54(a3), d4
        move.w -$54(a3), d4
L008_000015A8:
; H008+$000015A8: 9842  sub.w d2, d4
        sub.w d2, d4
L008_000015AA:
; H008+$000015AA: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L008_000015AC:
; H008+$000015AC: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
L008_000015B0:
; H008+$000015B0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H030+$00B6 (sub_H030_000000B6)
L008_000015B4:
; H008+$000015B4: 4eb9000000b6  jsr $b6.l
        jsr (H030+$B6).l
L008_000015BA:
; H008+$000015BA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_000015BE:
; H008+$000015BE: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L008_000015C4:
; H008+$000015C4: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L008_000015C8:
; H008+$000015C8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000015CC:
; H008+$000015CC: 526bffaa  addq.w #$1, -$56(a3)
        addq.w #$1, -$56(a3)
L008_000015D0:
; H008+$000015D0: 6000fef8  bra.w $14ca
        bra.w H008+$14CA
L008_000015D4:
; H008+$000015D4: 4e5d  unlk a5
        unlk a5
L008_000015D6:
; H008+$000015D6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_000015D8:
; H008+$000015D8: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_000015DA:
; H008+$000015DA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_000015DC [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H026+$000C.
;   - Calls H026+$000C.
; Direct callers: H008+$16DE, H008+$178E
; --------------------------------------------------------------------------
L008_000015DC:
; H008+$000015DC: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L008_000015E0:
; H008+$000015E0: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L008_000015E4:
; H008+$000015E4: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_000015E6:
; H008+$000015E6: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_000015EA:
; H008+$000015EA: 6702  beq.b $15ee
        beq.b H008+$15EE
L008_000015EC:
; H008+$000015EC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_000015EE:
; H008+$000015EE: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_000015F0:
; H008+$000015F0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_000015F4:
; H008+$000015F4: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L008_000015F8:
; H008+$000015F8: 244f  movea.l a7, a2
        movea.l a7, a2
L008_000015FA:
; H008+$000015FA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000015FC:
; H008+$000015FC: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_000015FE:
; H008+$000015FE: 51cafffc  dbra d2, $15fc
        dbra d2, H008+$15FC
L008_00001602:
; H008+$00001602: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L008_00001606:
; H008+$00001606: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L008_0000160A:
; H008+$0000160A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_0000160E:
; H008+$0000160E: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_00001614:
; H008+$00001614: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L008_00001618:
; H008+$00001618: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_0000161C:
; H008+$0000161C: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L008_00001620:
; H008+$00001620: 6400001a  bcc.w $163c
        bcc.w H008+$163C
L008_00001624:
; H008+$00001624: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_00001628:
; H008+$00001628: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_0000162C:
; H008+$0000162C: 0c3300202000  cmpi.b #$20, (a3, d2.w)
        cmpi.b #$20, (a3, d2.w)
L008_00001632:
; H008+$00001632: 66000008  bne.w $163c
        bne.w H008+$163C
L008_00001636:
; H008+$00001636: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L008_0000163A:
; H008+$0000163A: 60dc  bra.b $1618
        bra.b H008+$1618
L008_0000163C:
; H008+$0000163C: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L008_00001640:
; H008+$00001640: 60000002  bra.w $1644
        bra.w H008+$1644
L008_00001644:
; H008+$00001644: 4e5d  unlk a5
        unlk a5
L008_00001646:
; H008+$00001646: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00001648:
; H008+$00001648: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L008_0000164C:
; H008+$0000164C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_0000164E [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H026+$000C.
;   - Calls H026+$000C.
; Direct callers: H008+$16F2, H008+$17A2
; --------------------------------------------------------------------------
L008_0000164E:
; H008+$0000164E: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L008_00001652:
; H008+$00001652: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L008_00001656:
; H008+$00001656: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001658:
; H008+$00001658: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_0000165C:
; H008+$0000165C: 6702  beq.b $1660
        beq.b H008+$1660
L008_0000165E:
; H008+$0000165E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001660:
; H008+$00001660: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_00001662:
; H008+$00001662: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001666:
; H008+$00001666: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L008_0000166A:
; H008+$0000166A: 244f  movea.l a7, a2
        movea.l a7, a2
L008_0000166C:
; H008+$0000166C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_0000166E:
; H008+$0000166E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_00001670:
; H008+$00001670: 51cafffc  dbra d2, $166e
        dbra d2, H008+$166E
L008_00001674:
; H008+$00001674: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L008_00001678:
; H008+$00001678: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L008_0000167C:
; H008+$0000167C: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L008_00001682:
; H008+$00001682: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L008_00001686:
; H008+$00001686: 0c6d0001fffe  cmpi.w #$1, -$2(a5)
        cmpi.w #$1, -$2(a5)
L008_0000168C:
; H008+$0000168C: 6300001a  bls.w $16a8
        bls.w H008+$16A8
L008_00001690:
; H008+$00001690: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_00001694:
; H008+$00001694: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001698:
; H008+$00001698: 0c3300202000  cmpi.b #$20, (a3, d2.w)
        cmpi.b #$20, (a3, d2.w)
L008_0000169E:
; H008+$0000169E: 66000008  bne.w $16a8
        bne.w H008+$16A8
L008_000016A2:
; H008+$000016A2: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L008_000016A6:
; H008+$000016A6: 60de  bra.b $1686
        bra.b H008+$1686
L008_000016A8:
; H008+$000016A8: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L008_000016AC:
; H008+$000016AC: 60000002  bra.w $16b0
        bra.w H008+$16B0
L008_000016B0:
; H008+$000016B0: 4e5d  unlk a5
        unlk a5
L008_000016B2:
; H008+$000016B2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_000016B4:
; H008+$000016B4: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L008_000016B8:
; H008+$000016B8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_000016BA [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H026+$0452, H030+$0256.
;   - Calls H026+$0452.
;   - Calls H030+$0256.
; Direct callers: H008+$1C62, H008+$1F1A
; --------------------------------------------------------------------------
L008_000016BA:
; H008+$000016BA: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L008_000016BE:
; H008+$000016BE: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L008_000016C2:
; H008+$000016C2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000016C6:
; H008+$000016C6: 2f2b001a  move.l $1a(a3), -(a7)
        move.l $1a(a3), -(a7)
L008_000016CA:
; H008+$000016CA: 6100ea36  bsr.w $102
        bsr.w H008+$102
L008_000016CE:
; H008+$000016CE: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L008_000016D2:
; H008+$000016D2: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_000016D6:
; H008+$000016D6: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L008_000016DA:
; H008+$000016DA: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_000016DE:
; H008+$000016DE: 6100fefc  bsr.w $15dc
        bsr.w H008+$15DC
L008_000016E2:
; H008+$000016E2: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L008_000016E6:
; H008+$000016E6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_000016EA:
; H008+$000016EA: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L008_000016EE:
; H008+$000016EE: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_000016F2:
; H008+$000016F2: 6100ff5a  bsr.w $164e
        bsr.w H008+$164E
L008_000016F6:
; H008+$000016F6: 3400  move.w d0, d2
        move.w d0, d2
L008_000016F8:
; H008+$000016F8: 946dfffa  sub.w -$6(a5), d2
        sub.w -$6(a5), d2
L008_000016FC:
; H008+$000016FC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_000016FE:
; H008+$000016FE: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L008_00001702:
; H008+$00001702: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L008_00001706:
; H008+$00001706: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000170A:
; H008+$0000170A: 486bffae  pea.l -$52(a3)
        pea.l -$52(a3)
L008_0000170E:
; H008+$0000170E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001712:
; H008+$00001712: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L008_00001716:
; H008+$00001716: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L008_0000171A:
; H008+$0000171A: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H026+$0452 (sub_H026_00000452)
L008_0000171E:
; H008+$0000171E: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L008_00001724:
; H008+$00001724: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001728:
; H008+$00001728: 342b0024  move.w $24(a3), d2
        move.w $24(a3), d2
L008_0000172C:
; H008+$0000172C: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L008_00001730:
; H008+$00001730: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00001732:
; H008+$00001732: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L008_00001736:
; H008+$00001736: 947900002796  sub.w $2796.l, d2
        sub.w (H005+$2796).l, d2
L008_0000173C:
; H008+$0000173C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001740:
; H008+$00001740: d46b0022  add.w $22(a3), d2
        add.w $22(a3), d2
L008_00001744:
; H008+$00001744: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00001746:
; H008+$00001746: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00001748:
; H008+$00001748: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000174C:
; H008+$0000174C: 3f2b0026  move.w $26(a3), -(a7)
        move.w $26(a3), -(a7)
L008_00001750:
; H008+$00001750: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L008_00001754:
; H008+$00001754: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001758:
; H008+$00001758: 486bffae  pea.l -$52(a3)
        pea.l -$52(a3)
; FLOW: Calls UI_DrawText (H030+$0256).
L008_0000175C:
; H008+$0000175C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L008_00001762:
; H008+$00001762: 4e5d  unlk a5
        unlk a5
L008_00001764:
; H008+$00001764: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00001766:
; H008+$00001766: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_00001768:
; H008+$00001768: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_0000176A [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H026+$0452, H030+$0256.
;   - Calls H026+$0452.
;   - Calls H030+$0256.
; Direct callers: H008+$1D52, H008+$1EFC
; --------------------------------------------------------------------------
L008_0000176A:
; H008+$0000176A: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L008_0000176E:
; H008+$0000176E: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L008_00001772:
; H008+$00001772: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001776:
; H008+$00001776: 2f2b001a  move.l $1a(a3), -(a7)
        move.l $1a(a3), -(a7)
L008_0000177A:
; H008+$0000177A: 6100e986  bsr.w $102
        bsr.w H008+$102
L008_0000177E:
; H008+$0000177E: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L008_00001782:
; H008+$00001782: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001786:
; H008+$00001786: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L008_0000178A:
; H008+$0000178A: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_0000178E:
; H008+$0000178E: 6100fe4c  bsr.w $15dc
        bsr.w H008+$15DC
L008_00001792:
; H008+$00001792: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L008_00001796:
; H008+$00001796: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_0000179A:
; H008+$0000179A: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L008_0000179E:
; H008+$0000179E: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_000017A2:
; H008+$000017A2: 6100feaa  bsr.w $164e
        bsr.w H008+$164E
L008_000017A6:
; H008+$000017A6: 3400  move.w d0, d2
        move.w d0, d2
L008_000017A8:
; H008+$000017A8: 946dfffa  sub.w -$6(a5), d2
        sub.w -$6(a5), d2
L008_000017AC:
; H008+$000017AC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_000017AE:
; H008+$000017AE: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L008_000017B2:
; H008+$000017B2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_000017B6:
; H008+$000017B6: 4a2b002a  tst.b $2a(a3)
        tst.b $2a(a3)
L008_000017BA:
; H008+$000017BA: 67000066  beq.w $1822
        beq.w H008+$1822
L008_000017BE:
; H008+$000017BE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L008_000017C2:
; H008+$000017C2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000017C6:
; H008+$000017C6: 486bffae  pea.l -$52(a3)
        pea.l -$52(a3)
L008_000017CA:
; H008+$000017CA: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_000017CE:
; H008+$000017CE: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L008_000017D2:
; H008+$000017D2: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L008_000017D6:
; H008+$000017D6: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H026+$0452 (sub_H026_00000452)
L008_000017DA:
; H008+$000017DA: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L008_000017E0:
; H008+$000017E0: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000017E4:
; H008+$000017E4: 342b0024  move.w $24(a3), d2
        move.w $24(a3), d2
L008_000017E8:
; H008+$000017E8: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L008_000017EC:
; H008+$000017EC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_000017EE:
; H008+$000017EE: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L008_000017F2:
; H008+$000017F2: 947900002796  sub.w $2796.l, d2
        sub.w (H005+$2796).l, d2
L008_000017F8:
; H008+$000017F8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000017FC:
; H008+$000017FC: d46b0022  add.w $22(a3), d2
        add.w $22(a3), d2
L008_00001800:
; H008+$00001800: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00001802:
; H008+$00001802: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001806:
; H008+$00001806: 3f2b002a  move.w $2a(a3), -(a7)
        move.w $2a(a3), -(a7)
L008_0000180A:
; H008+$0000180A: 4267  clr.w -(a7)
        clr.w -(a7)
L008_0000180C:
; H008+$0000180C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L008_00001810:
; H008+$00001810: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001814:
; H008+$00001814: 486bffae  pea.l -$52(a3)
        pea.l -$52(a3)
; FLOW: Calls UI_DrawText (H030+$0256).
L008_00001818:
; H008+$00001818: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L008_0000181E:
; H008+$0000181E: 60000062  bra.w $1882
        bra.w H008+$1882
L008_00001822:
; H008+$00001822: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L008_00001826:
; H008+$00001826: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000182A:
; H008+$0000182A: 486bffae  pea.l -$52(a3)
        pea.l -$52(a3)
L008_0000182E:
; H008+$0000182E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001832:
; H008+$00001832: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L008_00001836:
; H008+$00001836: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L008_0000183A:
; H008+$0000183A: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H026+$0452 (sub_H026_00000452)
L008_0000183E:
; H008+$0000183E: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L008_00001844:
; H008+$00001844: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001848:
; H008+$00001848: 342b0024  move.w $24(a3), d2
        move.w $24(a3), d2
L008_0000184C:
; H008+$0000184C: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L008_00001850:
; H008+$00001850: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00001852:
; H008+$00001852: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L008_00001856:
; H008+$00001856: 947900002796  sub.w $2796.l, d2
        sub.w (H005+$2796).l, d2
L008_0000185C:
; H008+$0000185C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001860:
; H008+$00001860: d46b0022  add.w $22(a3), d2
        add.w $22(a3), d2
L008_00001864:
; H008+$00001864: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L008_00001866:
; H008+$00001866: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000186A:
; H008+$0000186A: 3f2b0028  move.w $28(a3), -(a7)
        move.w $28(a3), -(a7)
L008_0000186E:
; H008+$0000186E: 4267  clr.w -(a7)
        clr.w -(a7)
L008_00001870:
; H008+$00001870: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L008_00001874:
; H008+$00001874: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001878:
; H008+$00001878: 486bffae  pea.l -$52(a3)
        pea.l -$52(a3)
; FLOW: Calls UI_DrawText (H030+$0256).
L008_0000187C:
; H008+$0000187C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L008_00001882:
; H008+$00001882: 4e5d  unlk a5
        unlk a5
L008_00001884:
; H008+$00001884: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00001886:
; H008+$00001886: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_00001888:
; H008+$00001888: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_0000188A [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H008+$1AE8, H008+$1A46
; --------------------------------------------------------------------------
L008_0000188A:
; H008+$0000188A: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L008_0000188E:
; H008+$0000188E: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L008_00001892:
; H008+$00001892: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001896:
; H008+$00001896: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_0000189A:
; H008+$0000189A: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_0000189C:
; H008+$0000189C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000018A0:
; H008+$000018A0: 2f2b001a  move.l $1a(a3), -(a7)
        move.l $1a(a3), -(a7)
L008_000018A4:
; H008+$000018A4: 6100e85c  bsr.w $102
        bsr.w H008+$102
L008_000018A8:
; H008+$000018A8: 2b40fffa  move.l d0, -$6(a5)
        move.l d0, -$6(a5)
L008_000018AC:
; H008+$000018AC: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L008_000018B0:
; H008+$000018B0: 6700007a  beq.w $192c
        beq.w H008+$192C
L008_000018B4:
; H008+$000018B4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_000018B8:
; H008+$000018B8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000018BC:
; H008+$000018BC: b46bffa4  cmp.w -$5c(a3), d2
        cmp.w -$5c(a3), d2
L008_000018C0:
; H008+$000018C0: 6c000066  bge.w $1928
        bge.w H008+$1928
L008_000018C4:
; H008+$000018C4: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L008_000018C8:
; H008+$000018C8: 4a2b002a  tst.b $2a(a3)
        tst.b $2a(a3)
L008_000018CC:
; H008+$000018CC: 6700005a  beq.w $1928
        beq.w H008+$1928
L008_000018D0:
; H008+$000018D0: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L008_000018D4:
; H008+$000018D4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000018D8:
; H008+$000018D8: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_000018DC:
; H008+$000018DC: 5253  addq.w #$1, (a3)
        addq.w #$1, (a3)
L008_000018DE:
; H008+$000018DE: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_000018E4:
; H008+$000018E4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000018E8:
; H008+$000018E8: d46bffa4  add.w -$5c(a3), d2
        add.w -$5c(a3), d2
L008_000018EC:
; H008+$000018EC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_000018EE:
; H008+$000018EE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000018F2:
; H008+$000018F2: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_000018F6:
; H008+$000018F6: 3813  move.w (a3), d4
        move.w (a3), d4
L008_000018F8:
; H008+$000018F8: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_000018FA:
; H008+$000018FA: 6f000010  ble.w $190c
        ble.w H008+$190C
L008_000018FE:
; H008+$000018FE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001902:
; H008+$00001902: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001906:
; H008+$00001906: 36b900002796  move.w $2796.l, (a3)
        move.w (H005+$2796).l, (a3)
L008_0000190C:
; H008+$0000190C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001910:
; H008+$00001910: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001914:
; H008+$00001914: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_00001916:
; H008+$00001916: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000191A:
; H008+$0000191A: 2f2b001a  move.l $1a(a3), -(a7)
        move.l $1a(a3), -(a7)
L008_0000191E:
; H008+$0000191E: 6100e7e2  bsr.w $102
        bsr.w H008+$102
L008_00001922:
; H008+$00001922: 2b40fffa  move.l d0, -$6(a5)
        move.l d0, -$6(a5)
L008_00001926:
; H008+$00001926: 608c  bra.b $18b4
        bra.b H008+$18B4
L008_00001928:
; H008+$00001928: 60000076  bra.w $19a0
        bra.w H008+$19A0
L008_0000192C:
; H008+$0000192C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L008_00001930:
; H008+$00001930: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001934:
; H008+$00001934: b46bffa4  cmp.w -$5c(a3), d2
        cmp.w -$5c(a3), d2
L008_00001938:
; H008+$00001938: 6c000066  bge.w $19a0
        bge.w H008+$19A0
L008_0000193C:
; H008+$0000193C: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L008_00001940:
; H008+$00001940: 4a2b002a  tst.b $2a(a3)
        tst.b $2a(a3)
L008_00001944:
; H008+$00001944: 6700005a  beq.w $19a0
        beq.w H008+$19A0
L008_00001948:
; H008+$00001948: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L008_0000194C:
; H008+$0000194C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001950:
; H008+$00001950: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001954:
; H008+$00001954: 5353  subq.w #$1, (a3)
        subq.w #$1, (a3)
L008_00001956:
; H008+$00001956: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000195A:
; H008+$0000195A: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_0000195E:
; H008+$0000195E: 3413  move.w (a3), d2
        move.w (a3), d2
L008_00001960:
; H008+$00001960: b47900002796  cmp.w $2796.l, d2
        cmp.w (H005+$2796).l, d2
L008_00001966:
; H008+$00001966: 6c00001c  bge.w $1984
        bge.w H008+$1984
L008_0000196A:
; H008+$0000196A: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_00001970:
; H008+$00001970: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001974:
; H008+$00001974: d46bffa4  add.w -$5c(a3), d2
        add.w -$5c(a3), d2
L008_00001978:
; H008+$00001978: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_0000197A:
; H008+$0000197A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_0000197E:
; H008+$0000197E: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001982:
; H008+$00001982: 3682  move.w d2, (a3)
        move.w d2, (a3)
L008_00001984:
; H008+$00001984: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001988:
; H008+$00001988: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_0000198C:
; H008+$0000198C: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_0000198E:
; H008+$0000198E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001992:
; H008+$00001992: 2f2b001a  move.l $1a(a3), -(a7)
        move.l $1a(a3), -(a7)
L008_00001996:
; H008+$00001996: 6100e76a  bsr.w $102
        bsr.w H008+$102
L008_0000199A:
; H008+$0000199A: 2b40fffa  move.l d0, -$6(a5)
        move.l d0, -$6(a5)
L008_0000199E:
; H008+$0000199E: 608c  bra.b $192c
        bra.b H008+$192C
L008_000019A0:
; H008+$000019A0: 4e5d  unlk a5
        unlk a5
L008_000019A2:
; H008+$000019A2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_000019A4:
; H008+$000019A4: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_000019A6:
; H008+$000019A6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_000019A8 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H008+$1D8A, H008+$1D9E, H008+$1E30, H008+$1E06
; --------------------------------------------------------------------------
L008_000019A8:
; H008+$000019A8: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L008_000019AC:
; H008+$000019AC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000019B0:
; H008+$000019B0: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_000019B4:
; H008+$000019B4: 3413  move.w (a3), d2
        move.w (a3), d2
L008_000019B6:
; H008+$000019B6: 947900002796  sub.w $2796.l, d2
        sub.w (H005+$2796).l, d2
L008_000019BC:
; H008+$000019BC: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L008_000019C0:
; H008+$000019C0: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L008_000019C4:
; H008+$000019C4: 67000046  beq.w $1a0c
        beq.w H008+$1A0C
L008_000019C8:
; H008+$000019C8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000019CC:
; H008+$000019CC: 342bffa4  move.w -$5c(a3), d2
        move.w -$5c(a3), d2
L008_000019D0:
; H008+$000019D0: d57900002796  add.w d2, $2796.l
        add.w d2, (H005+$2796).l
L008_000019D6:
; H008+$000019D6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000019DA:
; H008+$000019DA: 342bffa8  move.w -$58(a3), d2
        move.w -$58(a3), d2
L008_000019DE:
; H008+$000019DE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000019E2:
; H008+$000019E2: 946bffa4  sub.w -$5c(a3), d2
        sub.w -$5c(a3), d2
L008_000019E6:
; H008+$000019E6: 383900002796  move.w $2796.l, d4
        move.w (H005+$2796).l, d4
L008_000019EC:
; H008+$000019EC: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_000019EE:
; H008+$000019EE: 6f000018  ble.w $1a08
        ble.w H008+$1A08
L008_000019F2:
; H008+$000019F2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000019F6:
; H008+$000019F6: 342bffa8  move.w -$58(a3), d2
        move.w -$58(a3), d2
L008_000019FA:
; H008+$000019FA: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_000019FE:
; H008+$000019FE: 946bffa4  sub.w -$5c(a3), d2
        sub.w -$5c(a3), d2
L008_00001A02:
; H008+$00001A02: 33c200002796  move.w d2, $2796.l
        move.w d2, (H005+$2796).l
L008_00001A08:
; H008+$00001A08: 60000020  bra.w $1a2a
        bra.w H008+$1A2A
L008_00001A0C:
; H008+$00001A0C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001A10:
; H008+$00001A10: 342bffa4  move.w -$5c(a3), d2
        move.w -$5c(a3), d2
L008_00001A14:
; H008+$00001A14: 957900002796  sub.w d2, $2796.l
        sub.w d2, (H005+$2796).l
L008_00001A1A:
; H008+$00001A1A: 4a7900002796  tst.w $2796.l
        tst.w (H005+$2796).l
L008_00001A20:
; H008+$00001A20: 6c000008  bge.w $1a2a
        bge.w H008+$1A2A
L008_00001A24:
; H008+$00001A24: 427900002796  clr.w $2796.l
        clr.w (H005+$2796).l
L008_00001A2A:
; H008+$00001A2A: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_00001A30:
; H008+$00001A30: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L008_00001A34:
; H008+$00001A34: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001A38:
; H008+$00001A38: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001A3C:
; H008+$00001A3C: 3682  move.w d2, (a3)
        move.w d2, (a3)
L008_00001A3E:
; H008+$00001A3E: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L008_00001A42:
; H008+$00001A42: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_00001A46:
; H008+$00001A46: 6100fe42  bsr.w $188a
        bsr.w H008+$188A
L008_00001A4A:
; H008+$00001A4A: 3f3900002796  move.w $2796.l, -(a7)
        move.w (H005+$2796).l, -(a7)
L008_00001A50:
; H008+$00001A50: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_00001A54:
; H008+$00001A54: 6100f9f2  bsr.w $1448
        bsr.w H008+$1448
L008_00001A58:
; H008+$00001A58: 4e5d  unlk a5
        unlk a5
L008_00001A5A:
; H008+$00001A5A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00001A5C:
; H008+$00001A5C: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_00001A5E:
; H008+$00001A5E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_00001A60 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H026+$0188, H026+$01E0.
;   - Calls H026+$0188.
;   - Calls H026+$01E0.
;   - Uses the global state: H005+$2354 (mouse Y coordinate); H005+$2356 (mouse X coordinate).
; Direct callers: H008+$1C3A, H008+$1D6C, H008+$1D78
; --------------------------------------------------------------------------
L008_00001A60:
; H008+$00001A60: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L008_00001A64:
; H008+$00001A64: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L008_00001A68:
; H008+$00001A68: 6700003e  beq.w $1aa8
        beq.w H008+$1AA8
L008_00001A6C:
; H008+$00001A6C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001A70:
; H008+$00001A70: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001A74:
; H008+$00001A74: 5253  addq.w #$1, (a3)
        addq.w #$1, (a3)
L008_00001A76:
; H008+$00001A76: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_00001A7C:
; H008+$00001A7C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001A80:
; H008+$00001A80: d46bffa4  add.w -$5c(a3), d2
        add.w -$5c(a3), d2
L008_00001A84:
; H008+$00001A84: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001A86:
; H008+$00001A86: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001A8A:
; H008+$00001A8A: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001A8E:
; H008+$00001A8E: 3813  move.w (a3), d4
        move.w (a3), d4
L008_00001A90:
; H008+$00001A90: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_00001A92:
; H008+$00001A92: 6f000010  ble.w $1aa4
        ble.w H008+$1AA4
L008_00001A96:
; H008+$00001A96: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001A9A:
; H008+$00001A9A: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001A9E:
; H008+$00001A9E: 36b900002796  move.w $2796.l, (a3)
        move.w (H005+$2796).l, (a3)
L008_00001AA4:
; H008+$00001AA4: 6000003a  bra.w $1ae0
        bra.w H008+$1AE0
L008_00001AA8:
; H008+$00001AA8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001AAC:
; H008+$00001AAC: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001AB0:
; H008+$00001AB0: 5353  subq.w #$1, (a3)
        subq.w #$1, (a3)
L008_00001AB2:
; H008+$00001AB2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001AB6:
; H008+$00001AB6: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001ABA:
; H008+$00001ABA: 3413  move.w (a3), d2
        move.w (a3), d2
L008_00001ABC:
; H008+$00001ABC: b47900002796  cmp.w $2796.l, d2
        cmp.w (H005+$2796).l, d2
L008_00001AC2:
; H008+$00001AC2: 6c00001c  bge.w $1ae0
        bge.w H008+$1AE0
L008_00001AC6:
; H008+$00001AC6: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_00001ACC:
; H008+$00001ACC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001AD0:
; H008+$00001AD0: d46bffa4  add.w -$5c(a3), d2
        add.w -$5c(a3), d2
L008_00001AD4:
; H008+$00001AD4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001AD6:
; H008+$00001AD6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L008_00001ADA:
; H008+$00001ADA: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L008_00001ADE:
; H008+$00001ADE: 3682  move.w d2, (a3)
        move.w d2, (a3)
L008_00001AE0:
; H008+$00001AE0: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L008_00001AE4:
; H008+$00001AE4: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L008_00001AE8:
; H008+$00001AE8: 6100fda0  bsr.w $188a
        bsr.w H008+$188A
L008_00001AEC:
; H008+$00001AEC: 4e5d  unlk a5
        unlk a5
L008_00001AEE:
; H008+$00001AEE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00001AF0:
; H008+$00001AF0: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_00001AF2:
; H008+$00001AF2: 4ed0  jmp (a0)
        jmp (a0)
L008_00001AF4:
; H008+$00001AF4: 342d0036  move.w $36(a5), d2
        move.w $36(a5), d2
L008_00001AF8:
; H008+$00001AF8: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001AFA:
; H008+$00001AFA: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_00001AFE:
; H008+$00001AFE: 6702  beq.b $1b02
        beq.b H008+$1B02
L008_00001B00:
; H008+$00001B00: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001B02:
; H008+$00001B02: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_00001B04:
; H008+$00001B04: 266d0032  movea.l $32(a5), a3
        movea.l $32(a5), a3
L008_00001B08:
; H008+$00001B08: 2b4f0032  move.l a7, $32(a5)
        move.l a7, $32(a5)
L008_00001B0C:
; H008+$00001B0C: 244f  movea.l a7, a2
        movea.l a7, a2
L008_00001B0E:
; H008+$00001B0E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001B10:
; H008+$00001B10: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_00001B12:
; H008+$00001B12: 51cafffc  dbra d2, $1b10
        dbra d2, H008+$1B10
L008_00001B16:
; H008+$00001B16: 342d0030  move.w $30(a5), d2
        move.w $30(a5), d2
L008_00001B1A:
; H008+$00001B1A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001B1C:
; H008+$00001B1C: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_00001B20:
; H008+$00001B20: 6702  beq.b $1b24
        beq.b H008+$1B24
L008_00001B22:
; H008+$00001B22: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001B24:
; H008+$00001B24: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_00001B26:
; H008+$00001B26: 266d002c  movea.l $2c(a5), a3
        movea.l $2c(a5), a3
L008_00001B2A:
; H008+$00001B2A: 2b4f002c  move.l a7, $2c(a5)
        move.l a7, $2c(a5)
L008_00001B2E:
; H008+$00001B2E: 244f  movea.l a7, a2
        movea.l a7, a2
L008_00001B30:
; H008+$00001B30: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001B32:
; H008+$00001B32: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_00001B34:
; H008+$00001B34: 51cafffc  dbra d2, $1b32
        dbra d2, H008+$1B32
L008_00001B38:
; H008+$00001B38: 4aad001a  tst.l $1a(a5)
        tst.l $1a(a5)
L008_00001B3C:
; H008+$00001B3C: 66000014  bne.w $1b52
        bne.w H008+$1B52
L008_00001B40:
; H008+$00001B40: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001B44:
; H008+$00001B44: 4253  clr.w (a3)
        clr.w (a3)
L008_00001B46:
; H008+$00001B46: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001B4A:
; H008+$00001B4A: 4293  clr.l (a3)
        clr.l (a3)
L008_00001B4C:
; H008+$00001B4C: 7000  moveq #$0, d0
        moveq #0, d0
L008_00001B4E:
; H008+$00001B4E: 600004e0  bra.w $2030
        bra.w H008+$2030
L008_00001B52:
; H008+$00001B52: 1b7c004effa2  move.b #$4e, -$5e(a5)
        move.b #$4e, -$5e(a5)
L008_00001B58:
; H008+$00001B58: 33ed002400002504  move.w $24(a5), $2504.l
        move.w $24(a5), (H005+$2504).l
L008_00001B60:
; H008+$00001B60: 33ed002000002502  move.w $20(a5), $2502.l
        move.w $20(a5), (H005+$2502).l
L008_00001B68:
; H008+$00001B68: 342d0020  move.w $20(a5), d2
        move.w $20(a5), d2
L008_00001B6C:
; H008+$00001B6C: 946d0024  sub.w $24(a5), d2
        sub.w $24(a5), d2
L008_00001B70:
; H008+$00001B70: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001B72:
; H008+$00001B72: 3b42ffac  move.w d2, -$54(a5)
        move.w d2, -$54(a5)
L008_00001B76:
; H008+$00001B76: 2f2d001a  move.l $1a(a5), -(a7)
        move.l $1a(a5), -(a7)
L008_00001B7A:
; H008+$00001B7A: 6100e5e6  bsr.w $162
        bsr.w H008+$162
L008_00001B7E:
; H008+$00001B7E: 3b40ffa8  move.w d0, -$58(a5)
        move.w d0, -$58(a5)
L008_00001B82:
; H008+$00001B82: 342d001e  move.w $1e(a5), d2
        move.w $1e(a5), d2
L008_00001B86:
; H008+$00001B86: 946d0022  sub.w $22(a5), d2
        sub.w $22(a5), d2
L008_00001B8A:
; H008+$00001B8A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00001B8C:
; H008+$00001B8C: 3b42ffa4  move.w d2, -$5c(a5)
        move.w d2, -$5c(a5)
L008_00001B90:
; H008+$00001B90: 2b6d001aff72  move.l $1a(a5), -$8e(a5)
        move.l $1a(a5), -$8e(a5)
L008_00001B96:
; H008+$00001B96: 426dff70  clr.w -$90(a5)
        clr.w -$90(a5)
L008_00001B9A:
; H008+$00001B9A: 4aadff72  tst.l -$8e(a5)
        tst.l -$8e(a5)
L008_00001B9E:
; H008+$00001B9E: 6700001e  beq.w $1bbe
        beq.w H008+$1BBE
L008_00001BA2:
; H008+$00001BA2: 266dff72  movea.l -$8e(a5), a3
        movea.l -$8e(a5), a3
L008_00001BA6:
; H008+$00001BA6: 4a2b002a  tst.b $2a(a3)
        tst.b $2a(a3)
L008_00001BAA:
; H008+$00001BAA: 67000012  beq.w $1bbe
        beq.w H008+$1BBE
L008_00001BAE:
; H008+$00001BAE: 266dff72  movea.l -$8e(a5), a3
        movea.l -$8e(a5), a3
L008_00001BB2:
; H008+$00001BB2: 2b6b002cff72  move.l $2c(a3), -$8e(a5)
        move.l $2c(a3), -$8e(a5)
L008_00001BB8:
; H008+$00001BB8: 526dff70  addq.w #$1, -$90(a5)
        addq.w #$1, -$90(a5)
L008_00001BBC:
; H008+$00001BBC: 60dc  bra.b $1b9a
        bra.b H008+$1B9A
L008_00001BBE:
; H008+$00001BBE: 2b6d001aff72  move.l $1a(a5), -$8e(a5)
        move.l $1a(a5), -$8e(a5)
L008_00001BC4:
; H008+$00001BC4: 426dff6e  clr.w -$92(a5)
        clr.w -$92(a5)
L008_00001BC8:
; H008+$00001BC8: 4aadff72  tst.l -$8e(a5)
        tst.l -$8e(a5)
L008_00001BCC:
; H008+$00001BCC: 67000012  beq.w $1be0
        beq.w H008+$1BE0
L008_00001BD0:
; H008+$00001BD0: 266dff72  movea.l -$8e(a5), a3
        movea.l -$8e(a5), a3
L008_00001BD4:
; H008+$00001BD4: 2b6b002cff72  move.l $2c(a3), -$8e(a5)
        move.l $2c(a3), -$8e(a5)
L008_00001BDA:
; H008+$00001BDA: 526dff6e  addq.w #$1, -$92(a5)
        addq.w #$1, -$92(a5)
L008_00001BDE:
; H008+$00001BDE: 60e8  bra.b $1bc8
        bra.b H008+$1BC8
L008_00001BE0:
; H008+$00001BE0: 342dff6e  move.w -$92(a5), d2
        move.w -$92(a5), d2
L008_00001BE4:
; H008+$00001BE4: b46dffa4  cmp.w -$5c(a5), d2
        cmp.w -$5c(a5), d2
L008_00001BE8:
; H008+$00001BE8: 6e000008  bgt.w $1bf2
        bgt.w H008+$1BF2
L008_00001BEC:
; H008+$00001BEC: 427900002796  clr.w $2796.l
        clr.w (H005+$2796).l
L008_00001BF2:
; H008+$00001BF2: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_00001BF8:
; H008+$00001BF8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001BFC:
; H008+$00001BFC: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L008_00001BFE:
; H008+$00001BFE: 6f000014  ble.w $1c14
        ble.w H008+$1C14
L008_00001C02:
; H008+$00001C02: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001C06:
; H008+$00001C06: 33d300002796  move.w (a3), $2796.l
        move.w (a3), (H005+$2796).l
L008_00001C0C:
; H008+$00001C0C: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L008_00001C10:
; H008+$00001C10: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00001C14:
; H008+$00001C14: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_00001C1A:
; H008+$00001C1A: b46dff6e  cmp.w -$92(a5), d2
        cmp.w -$92(a5), d2
L008_00001C1E:
; H008+$00001C1E: 6f000010  ble.w $1c30
        ble.w H008+$1C30
L008_00001C22:
; H008+$00001C22: 427900002796  clr.w $2796.l
        clr.w (H005+$2796).l
L008_00001C28:
; H008+$00001C28: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L008_00001C2C:
; H008+$00001C2C: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L008_00001C30:
; H008+$00001C30: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001C34:
; H008+$00001C34: 5253  addq.w #$1, (a3)
        addq.w #$1, (a3)
L008_00001C36:
; H008+$00001C36: 4227  clr.b -(a7)
        clr.b -(a7)
L008_00001C38:
; H008+$00001C38: 4855  pea.l (a5)
        pea.l (a5)
L008_00001C3A:
; H008+$00001C3A: 6100fe24  bsr.w $1a60
        bsr.w H008+$1A60
L008_00001C3E:
; H008+$00001C3E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L008_00001C42:
; H008+$00001C42: 4a13  tst.b (a3)
        tst.b (a3)
L008_00001C44:
; H008+$00001C44: 6700000e  beq.w $1c54
        beq.w H008+$1C54
L008_00001C48:
; H008+$00001C48: 3f3900002796  move.w $2796.l, -(a7)
        move.w (H005+$2796).l, -(a7)
L008_00001C4E:
; H008+$00001C4E: 4855  pea.l (a5)
        pea.l (a5)
L008_00001C50:
; H008+$00001C50: 6100f7f6  bsr.w $1448
        bsr.w H008+$1448
L008_00001C54:
; H008+$00001C54: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L008_00001C58:
; H008+$00001C58: 4213  clr.b (a3)
        clr.b (a3)
L008_00001C5A:
; H008+$00001C5A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001C5E:
; H008+$00001C5E: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_00001C60:
; H008+$00001C60: 4855  pea.l (a5)
        pea.l (a5)
L008_00001C62:
; H008+$00001C62: 6100fa56  bsr.w $16ba
        bsr.w H008+$16BA
L008_00001C66:
; H008+$00001C66: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001C6A:
; H008+$00001C6A: 486dff78  pea.l -$88(a5)
        pea.l -$88(a5)
L008_00001C6E:
; H008+$00001C6E: 3f2d0030  move.w $30(a5), -(a7)
        move.w $30(a5), -(a7)
L008_00001C72:
; H008+$00001C72: 2f2d002c  move.l $2c(a5), -(a7)
        move.l $2c(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L008_00001C76:
; H008+$00001C76: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L008_00001C7C:
; H008+$00001C7C: 422dff77  clr.b -$89(a5)
        clr.b -$89(a5)
L008_00001C80:
; H008+$00001C80: 422dff76  clr.b -$8a(a5)
        clr.b -$8a(a5)
L008_00001C84:
; H008+$00001C84: 342dffa8  move.w -$58(a5), d2
        move.w -$58(a5), d2
L008_00001C88:
; H008+$00001C88: 946dffa4  sub.w -$5c(a5), d2
        sub.w -$5c(a5), d2
L008_00001C8C:
; H008+$00001C8C: 383900002796  move.w $2796.l, d4
        move.w (H005+$2796).l, d4
L008_00001C92:
; H008+$00001C92: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_00001C94:
; H008+$00001C94: 6c00001e  bge.w $1cb4
        bge.w H008+$1CB4
L008_00001C98:
; H008+$00001C98: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001C9C:
; H008+$00001C9C: 486dff78  pea.l -$88(a5)
        pea.l -$88(a5)
L008_00001CA0:
; H008+$00001CA0: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L008_00001CA4:
; H008+$00001CA4: 486c0027  pea.l $27(a4)
        pea.l $27(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L008_00001CA8:
; H008+$00001CA8: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L008_00001CAE:
; H008+$00001CAE: 1b7c0001ff77  move.b #$1, -$89(a5)
        move.b #$1, -$89(a5)
L008_00001CB4:
; H008+$00001CB4: 343900002796  move.w $2796.l, d2
        move.w (H005+$2796).l, d2
L008_00001CBA:
; H008+$00001CBA: b46dff70  cmp.w -$90(a5), d2
        cmp.w -$90(a5), d2
L008_00001CBE:
; H008+$00001CBE: 6f00001e  ble.w $1cde
        ble.w H008+$1CDE
L008_00001CC2:
; H008+$00001CC2: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001CC6:
; H008+$00001CC6: 486dff78  pea.l -$88(a5)
        pea.l -$88(a5)
L008_00001CCA:
; H008+$00001CCA: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L008_00001CCE:
; H008+$00001CCE: 486c002d  pea.l $2d(a4)
        pea.l $2d(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L008_00001CD2:
; H008+$00001CD2: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L008_00001CD8:
; H008+$00001CD8: 1b7c0001ff76  move.b #$1, -$8a(a5)
        move.b #$1, -$8a(a5)
L008_00001CDE:
; H008+$00001CDE: 4a2d0018  tst.b $18(a5)
        tst.b $18(a5)
L008_00001CE2:
; H008+$00001CE2: 67000018  beq.w $1cfc
        beq.w H008+$1CFC
L008_00001CE6:
; H008+$00001CE6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001CEA:
; H008+$00001CEA: 486dff78  pea.l -$88(a5)
        pea.l -$88(a5)
L008_00001CEE:
; H008+$00001CEE: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L008_00001CF2:
; H008+$00001CF2: 486c0033  pea.l $33(a4)
        pea.l $33(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L008_00001CF6:
; H008+$00001CF6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L008_00001CFC:
; H008+$00001CFC: 3f2d0036  move.w $36(a5), -(a7)
        move.w $36(a5), -(a7)
L008_00001D00:
; H008+$00001D00: 2f2d0032  move.l $32(a5), -(a7)
        move.l $32(a5), -(a7)
L008_00001D04:
; H008+$00001D04: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L008_00001D08:
; H008+$00001D08: 486dff78  pea.l -$88(a5)
        pea.l -$88(a5)
L008_00001D0C:
; H008+$00001D0C: 3f2d002a  move.w $2a(a5), -(a7)
        move.w $2a(a5), -(a7)
L008_00001D10:
; H008+$00001D10: 3f2d0028  move.w $28(a5), -(a7)
        move.w $28(a5), -(a7)
L008_00001D14:
; H008+$00001D14: 3f2d0026  move.w $26(a5), -(a7)
        move.w $26(a5), -(a7)
L008_00001D18:
; H008+$00001D18: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L008_00001D1C:
; H008+$00001D1C: 4227  clr.b -(a7)
        clr.b -(a7)
L008_00001D1E:
; H008+$00001D1E: 486dffa7  pea.l -$59(a5)
        pea.l -$59(a5)
; FLOW: Calls UI_RequestChoice (H008+$01FC).
L008_00001D22:
; H008+$00001D22: 6100e4d8  bsr.w $1fc
        bsr.w H008+$1FC
L008_00001D26:
; H008+$00001D26: 1b40ffa3  move.b d0, -$5d(a5)
        move.b d0, -$5d(a5)
; STATE: H005+$2354 = mouse Y coordinate
L008_00001D2A:
; H008+$00001D2A: 343900002354  move.w $2354.l, d2
        move.w (H005+$2354).l, d2
L008_00001D30:
; H008+$00001D30: 48c2  ext.l d2
        ext.l d2
L008_00001D32:
; H008+$00001D32: 85fc0008  divs.w #$8, d2
        divs.w #$8, d2
L008_00001D36:
; H008+$00001D36: 3b42ff6a  move.w d2, -$96(a5)
        move.w d2, -$96(a5)
; STATE: H005+$2356 = mouse X coordinate
L008_00001D3A:
; H008+$00001D3A: 343900002356  move.w $2356.l, d2
        move.w (H005+$2356).l, d2
L008_00001D40:
; H008+$00001D40: 48c2  ext.l d2
        ext.l d2
L008_00001D42:
; H008+$00001D42: 85fc0008  divs.w #$8, d2
        divs.w #$8, d2
L008_00001D46:
; H008+$00001D46: 3b42ff6c  move.w d2, -$94(a5)
        move.w d2, -$94(a5)
L008_00001D4A:
; H008+$00001D4A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001D4E:
; H008+$00001D4E: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_00001D50:
; H008+$00001D50: 4855  pea.l (a5)
        pea.l (a5)
L008_00001D52:
; H008+$00001D52: 6100fa16  bsr.w $176a
        bsr.w H008+$176A
L008_00001D56:
; H008+$00001D56: 4a2dffa7  tst.b -$59(a5)
        tst.b -$59(a5)
L008_00001D5A:
; H008+$00001D5A: 6700007e  beq.w $1dda
        beq.w H008+$1DDA
L008_00001D5E:
; H008+$00001D5E: 7400  moveq #$0, d2
        moveq #0, d2
L008_00001D60:
; H008+$00001D60: 142dffa3  move.b -$5d(a5), d2
        move.b -$5d(a5), d2
L008_00001D64:
; H008+$00001D64: 60000056  bra.w $1dbc
        bra.w H008+$1DBC
L008_00001D68:
; H008+$00001D68: 4227  clr.b -(a7)
        clr.b -(a7)
L008_00001D6A:
; H008+$00001D6A: 4855  pea.l (a5)
        pea.l (a5)
L008_00001D6C:
; H008+$00001D6C: 6100fcf2  bsr.w $1a60
        bsr.w H008+$1A60
L008_00001D70:
; H008+$00001D70: 4e75  rts 
        rts 
L008_00001D72:
; H008+$00001D72: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L008_00001D76:
; H008+$00001D76: 4855  pea.l (a5)
        pea.l (a5)
L008_00001D78:
; H008+$00001D78: 6100fce6  bsr.w $1a60
        bsr.w H008+$1A60
L008_00001D7C:
; H008+$00001D7C: 4e75  rts 
        rts 
L008_00001D7E:
; H008+$00001D7E: 4a2dff76  tst.b -$8a(a5)
        tst.b -$8a(a5)
L008_00001D82:
; H008+$00001D82: 6700000a  beq.w $1d8e
        beq.w H008+$1D8E
L008_00001D86:
; H008+$00001D86: 4227  clr.b -(a7)
        clr.b -(a7)
L008_00001D88:
; H008+$00001D88: 4855  pea.l (a5)
        pea.l (a5)
L008_00001D8A:
; H008+$00001D8A: 6100fc1c  bsr.w $19a8
        bsr.w H008+$19A8
L008_00001D8E:
; H008+$00001D8E: 4e75  rts 
        rts 
L008_00001D90:
; H008+$00001D90: 4a2dff77  tst.b -$89(a5)
        tst.b -$89(a5)
L008_00001D94:
; H008+$00001D94: 6700000c  beq.w $1da2
        beq.w H008+$1DA2
L008_00001D98:
; H008+$00001D98: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L008_00001D9C:
; H008+$00001D9C: 4855  pea.l (a5)
        pea.l (a5)
L008_00001D9E:
; H008+$00001D9E: 6100fc08  bsr.w $19a8
        bsr.w H008+$19A8
L008_00001DA2:
; H008+$00001DA2: 4e75  rts 
        rts 
L008_00001DA4:
; H008+$00001DA4: 4e75  rts 
        rts 
; Preserved bytes H008+$00001DA6..$00001DBC; code/data not fully classified.
        dc.w $FFFC,$FFC0,$FFD6,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFCA,$FFE8
L008_00001DBC:
; H008+$00001DBC: 47faffea  lea.l $1da8(pc), a3
        lea.l H008+$1DA8(pc), a3
L008_00001DC0:
; H008+$00001DC0: 04420048  subi.w #$48, d2
        subi.w #$48, d2
L008_00001DC4:
; H008+$00001DC4: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L008_00001DC8:
; H008+$00001DC8: 6302  bls.b $1dcc
        bls.b H008+$1DCC
L008_00001DCA:
; H008+$00001DCA: 74ff  moveq #$ff, d2
        moveq #-1, d2
L008_00001DCC:
; H008+$00001DCC: e342  asl.w #$1, d2
        asl.w #$1, d2
L008_00001DCE:
; H008+$00001DCE: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H008+$1DA8; indices 0..9, default -1.
L008_00001DD2:
; H008+$00001DD2: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L008_00001DD6:
; H008+$00001DD6: 60000250  bra.w $2028
        bra.w H008+$2028
L008_00001DDA:
; H008+$00001DDA: 7400  moveq #$0, d2
        moveq #0, d2
L008_00001DDC:
; H008+$00001DDC: 142dffa3  move.b -$5d(a5), d2
        move.b -$5d(a5), d2
L008_00001DE0:
; H008+$00001DE0: 6000022a  bra.w $200c
        bra.w H008+$200C
L008_00001DE4:
; H008+$00001DE4: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00001DEA:
; H008+$00001DEA: 67000016  beq.w $1e02
        beq.w H008+$1E02
L008_00001DEE:
; H008+$00001DEE: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00001DF4:
; H008+$00001DF4: 67000014  beq.w $1e0a
        beq.w H008+$1E0A
L008_00001DF8:
; H008+$00001DF8: 0c6d0018ff6a  cmpi.w #$18, -$96(a5)
        cmpi.w #$18, -$96(a5)
L008_00001DFE:
; H008+$00001DFE: 6600000a  bne.w $1e0a
        bne.w H008+$1E0A
L008_00001E02:
; H008+$00001E02: 4227  clr.b -(a7)
        clr.b -(a7)
L008_00001E04:
; H008+$00001E04: 4855  pea.l (a5)
        pea.l (a5)
L008_00001E06:
; H008+$00001E06: 6100fba0  bsr.w $19a8
        bsr.w H008+$19A8
L008_00001E0A:
; H008+$00001E0A: 4e75  rts 
        rts 
L008_00001E0C:
; H008+$00001E0C: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00001E12:
; H008+$00001E12: 67000016  beq.w $1e2a
        beq.w H008+$1E2A
L008_00001E16:
; H008+$00001E16: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00001E1C:
; H008+$00001E1C: 67000016  beq.w $1e34
        beq.w H008+$1E34
L008_00001E20:
; H008+$00001E20: 0c6d0018ff6a  cmpi.w #$18, -$96(a5)
        cmpi.w #$18, -$96(a5)
L008_00001E26:
; H008+$00001E26: 6600000c  bne.w $1e34
        bne.w H008+$1E34
L008_00001E2A:
; H008+$00001E2A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L008_00001E2E:
; H008+$00001E2E: 4855  pea.l (a5)
        pea.l (a5)
L008_00001E30:
; H008+$00001E30: 6100fb76  bsr.w $19a8
        bsr.w H008+$19A8
L008_00001E34:
; H008+$00001E34: 4e75  rts 
        rts 
L008_00001E36:
; H008+$00001E36: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001E3A:
; H008+$00001E3A: 4293  clr.l (a3)
        clr.l (a3)
L008_00001E3C:
; H008+$00001E3C: 7000  moveq #$0, d0
        moveq #0, d0
L008_00001E3E:
; H008+$00001E3E: 600001f0  bra.w $2030
        bra.w H008+$2030
; Preserved bytes H008+$00001E42..$00001E44; code/data not fully classified.
        dc.w $4E75
L008_00001E44:
; H008+$00001E44: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00001E4A:
; H008+$00001E4A: 670000de  beq.w $1f2a
        beq.w H008+$1F2A
L008_00001E4E:
; H008+$00001E4E: 0c6d0018ff6a  cmpi.w #$18, -$96(a5)
        cmpi.w #$18, -$96(a5)
L008_00001E54:
; H008+$00001E54: 670000d4  beq.w $1f2a
        beq.w H008+$1F2A
L008_00001E58:
; H008+$00001E58: 342dff6c  move.w -$94(a5), d2
        move.w -$94(a5), d2
L008_00001E5C:
; H008+$00001E5C: b47900002504  cmp.w $2504.l, d2
        cmp.w (H005+$2504).l, d2
L008_00001E62:
; H008+$00001E62: 6d0000c2  blt.w $1f26
        blt.w H008+$1F26
L008_00001E66:
; H008+$00001E66: 342dff6c  move.w -$94(a5), d2
        move.w -$94(a5), d2
L008_00001E6A:
; H008+$00001E6A: b47900002502  cmp.w $2502.l, d2
        cmp.w (H005+$2502).l, d2
L008_00001E70:
; H008+$00001E70: 6e0000b4  bgt.w $1f26
        bgt.w H008+$1F26
L008_00001E74:
; H008+$00001E74: 3b7c0001ffaa  move.w #$1, -$56(a5)
        move.w #$1, -$56(a5)
L008_00001E7A:
; H008+$00001E7A: 422dffa6  clr.b -$5a(a5)
        clr.b -$5a(a5)
L008_00001E7E:
; H008+$00001E7E: 0c6d0019ffaa  cmpi.w #$19, -$56(a5)
        cmpi.w #$19, -$56(a5)
L008_00001E84:
; H008+$00001E84: 620000a0  bhi.w $1f26
        bhi.w H008+$1F26
L008_00001E88:
; H008+$00001E88: 342dffaa  move.w -$56(a5), d2
        move.w -$56(a5), d2
L008_00001E8C:
; H008+$00001E8C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001E8E:
; H008+$00001E8E: 47f900002778  lea.l $2778.l, a3
        lea.l (H005+$2778).l, a3
L008_00001E94:
; H008+$00001E94: 7800  moveq #$0, d4
        moveq #0, d4
L008_00001E96:
; H008+$00001E96: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L008_00001E9A:
; H008+$00001E9A: 0c4400ff  cmpi.w #$ff, d4
        cmpi.w #$ff, d4
L008_00001E9E:
; H008+$00001E9E: 67000086  beq.w $1f26
        beq.w H008+$1F26
L008_00001EA2:
; H008+$00001EA2: 342dffaa  move.w -$56(a5), d2
        move.w -$56(a5), d2
L008_00001EA6:
; H008+$00001EA6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001EA8:
; H008+$00001EA8: 47f900002778  lea.l $2778.l, a3
        lea.l (H005+$2778).l, a3
L008_00001EAE:
; H008+$00001EAE: 7800  moveq #$0, d4
        moveq #0, d4
L008_00001EB0:
; H008+$00001EB0: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L008_00001EB4:
; H008+$00001EB4: b86dff6a  cmp.w -$96(a5), d4
        cmp.w -$96(a5), d4
L008_00001EB8:
; H008+$00001EB8: 66000064  bne.w $1f1e
        bne.w H008+$1F1E
L008_00001EBC:
; H008+$00001EBC: 342dffaa  move.w -$56(a5), d2
        move.w -$56(a5), d2
L008_00001EC0:
; H008+$00001EC0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001EC2:
; H008+$00001EC2: d47900002796  add.w $2796.l, d2
        add.w (H005+$2796).l, d2
L008_00001EC8:
; H008+$00001EC8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001ECC:
; H008+$00001ECC: 3813  move.w (a3), d4
        move.w (a3), d4
L008_00001ECE:
; H008+$00001ECE: b842  cmp.w d2, d4
        cmp.w d2, d4
L008_00001ED0:
; H008+$00001ED0: 66000022  bne.w $1ef4
        bne.w H008+$1EF4
L008_00001ED4:
; H008+$00001ED4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001ED8:
; H008+$00001ED8: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_00001EDA:
; H008+$00001EDA: 2f2d001a  move.l $1a(a5), -(a7)
        move.l $1a(a5), -(a7)
L008_00001EDE:
; H008+$00001EDE: 6100e222  bsr.w $102
        bsr.w H008+$102
L008_00001EE2:
; H008+$00001EE2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001EE6:
; H008+$00001EE6: 2680  move.l d0, (a3)
        move.l d0, (a3)
L008_00001EE8:
; H008+$00001EE8: 102dffa3  move.b -$5d(a5), d0
        move.b -$5d(a5), d0
L008_00001EEC:
; H008+$00001EEC: 60000142  bra.w $2030
        bra.w H008+$2030
; Preserved bytes H008+$00001EF0..$00001EF4; code/data not fully classified.
        dc.w $6000,$002C
L008_00001EF4:
; H008+$00001EF4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001EF8:
; H008+$00001EF8: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_00001EFA:
; H008+$00001EFA: 4855  pea.l (a5)
        pea.l (a5)
L008_00001EFC:
; H008+$00001EFC: 6100f86c  bsr.w $176a
        bsr.w H008+$176A
L008_00001F00:
; H008+$00001F00: 342dffaa  move.w -$56(a5), d2
        move.w -$56(a5), d2
L008_00001F04:
; H008+$00001F04: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00001F06:
; H008+$00001F06: d47900002796  add.w $2796.l, d2
        add.w (H005+$2796).l, d2
L008_00001F0C:
; H008+$00001F0C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001F10:
; H008+$00001F10: 3682  move.w d2, (a3)
        move.w d2, (a3)
L008_00001F12:
; H008+$00001F12: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001F16:
; H008+$00001F16: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_00001F18:
; H008+$00001F18: 4855  pea.l (a5)
        pea.l (a5)
L008_00001F1A:
; H008+$00001F1A: 6100f79e  bsr.w $16ba
        bsr.w H008+$16BA
L008_00001F1E:
; H008+$00001F1E: 526dffaa  addq.w #$1, -$56(a5)
        addq.w #$1, -$56(a5)
L008_00001F22:
; H008+$00001F22: 6000ff5a  bra.w $1e7e
        bra.w H008+$1E7E
L008_00001F26:
; H008+$00001F26: 6000003e  bra.w $1f66
        bra.w H008+$1F66
L008_00001F2A:
; H008+$00001F2A: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00001F30:
; H008+$00001F30: 67000018  beq.w $1f4a
        beq.w H008+$1F4A
L008_00001F34:
; H008+$00001F34: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L008_00001F3A:
; H008+$00001F3A: 6700002a  beq.w $1f66
        beq.w H008+$1F66
L008_00001F3E:
; H008+$00001F3E: 142dffa2  move.b -$5e(a5), d2
        move.b -$5e(a5), d2
L008_00001F42:
; H008+$00001F42: b42dffa3  cmp.b -$5d(a5), d2
        cmp.b -$5d(a5), d2
L008_00001F46:
; H008+$00001F46: 6600001e  bne.w $1f66
        bne.w H008+$1F66
L008_00001F4A:
; H008+$00001F4A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L008_00001F4E:
; H008+$00001F4E: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L008_00001F50:
; H008+$00001F50: 2f2d001a  move.l $1a(a5), -(a7)
        move.l $1a(a5), -(a7)
L008_00001F54:
; H008+$00001F54: 6100e1ac  bsr.w $102
        bsr.w H008+$102
L008_00001F58:
; H008+$00001F58: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00001F5C:
; H008+$00001F5C: 2680  move.l d0, (a3)
        move.l d0, (a3)
L008_00001F5E:
; H008+$00001F5E: 102dffa3  move.b -$5d(a5), d0
        move.b -$5d(a5), d0
L008_00001F62:
; H008+$00001F62: 600000cc  bra.w $2030
        bra.w H008+$2030
L008_00001F66:
; H008+$00001F66: 4e75  rts 
        rts 
; Preserved bytes H008+$00001F68..$0000200C; code/data not fully classified.
        dc.w $FEDA,$FECC,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FECC,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FECC,$FEDA
        dc.w $FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEDA,$FEA2
        dc.w $FEDA,$FE7A
L008_0000200C:
; H008+$0000200C: 47faff5c  lea.l $1f6a(pc), a3
        lea.l H008+$1F6A(pc), a3
L008_00002010:
; H008+$00002010: 0c420050  cmpi.w #$50, d2
        cmpi.w #$50, d2
L008_00002014:
; H008+$00002014: 6302  bls.b $2018
        bls.b H008+$2018
L008_00002016:
; H008+$00002016: 74ff  moveq #$ff, d2
        moveq #-1, d2
L008_00002018:
; H008+$00002018: e342  asl.w #$1, d2
        asl.w #$1, d2
L008_0000201A:
; H008+$0000201A: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H008+$1F6A; indices 0..80, default -1.
L008_0000201E:
; H008+$0000201E: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L008_00002022:
; H008+$00002022: 1b6dffa3ffa2  move.b -$5d(a5), -$5e(a5)
        move.b -$5d(a5), -$5e(a5)
L008_00002028:
; H008+$00002028: 7400  moveq #$0, d2
        moveq #0, d2
L008_0000202A:
; H008+$0000202A: 4a02  tst.b d2
        tst.b d2
L008_0000202C:
; H008+$0000202C: 6700fc2c  beq.w $1c5a
        beq.w H008+$1C5A
L008_00002030:
; H008+$00002030: 4e5d  unlk a5
        unlk a5
L008_00002032:
; H008+$00002032: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_00002034:
; H008+$00002034: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00002036:
; H008+$00002036: 4fef002c  lea.l $2c(a7), a7
        lea.l $2c(a7), a7
L008_0000203A:
; H008+$0000203A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_0000203C [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H013+$516E, H013+$51AA, H013+$2C1E, H013+$2C46, H096+$392A, H057+$30B2 and 24 more
; --------------------------------------------------------------------------
L008_0000203C:
; H008+$0000203C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_0000203E:
; H008+$0000203E: 287ae056  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_00002042:
; H008+$00002042: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L008_00002046:
; H008+$00002046: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L008_0000204A:
; H008+$0000204A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_0000204C:
; H008+$0000204C: 08020000  btst.b #$0, d2
        btst #$0, d2
L008_00002050:
; H008+$00002050: 6702  beq.b $2054
        beq.b H008+$2054
L008_00002052:
; H008+$00002052: 5242  addq.w #$1, d2
        addq.w #$1, d2
L008_00002054:
; H008+$00002054: 9ec2  suba.w d2, a7
        suba.w d2, a7
L008_00002056:
; H008+$00002056: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L008_0000205A:
; H008+$0000205A: 2b4f0012  move.l a7, $12(a5)
        move.l a7, $12(a5)
L008_0000205E:
; H008+$0000205E: 244f  movea.l a7, a2
        movea.l a7, a2
L008_00002060:
; H008+$00002060: 5342  subq.w #$1, d2
        subq.w #$1, d2
L008_00002062:
; H008+$00002062: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_00002064:
; H008+$00002064: 51cafffc  dbra d2, $2062
        dbra d2, H008+$2062
L008_00002068:
; H008+$00002068: 13fc000200002483  move.b #$2, $2483.l
        move.b #$2, (H005+$2483).l
L008_00002070:
; H008+$00002070: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L008_00002074:
; H008+$00002074: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L008_00002078:
; H008+$00002078: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L008_0000207C:
; H008+$0000207C: 486c0039  pea.l $39(a4)
        pea.l $39(a4)
L008_00002080:
; H008+$00002080: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L008_00002084:
; H008+$00002084: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L008_00002088:
; H008+$00002088: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L008_0000208C:
; H008+$0000208C: 4227  clr.b -(a7)
        clr.b -(a7)
L008_0000208E:
; H008+$0000208E: 4227  clr.b -(a7)
        clr.b -(a7)
L008_00002090:
; H008+$00002090: 486dffff  pea.l -$1(a5)
        pea.l -$1(a5)
; FLOW: Calls UI_RequestChoice (H008+$01FC).
L008_00002094:
; H008+$00002094: 6100e166  bsr.w $1fc
        bsr.w H008+$1FC
L008_00002098:
; H008+$00002098: 1b40fffe  move.b d0, -$2(a5)
        move.b d0, -$2(a5)
L008_0000209C:
; H008+$0000209C: 0c2d0059fffe  cmpi.b #$59, -$2(a5)
        cmpi.b #$59, -$2(a5)
L008_000020A2:
; H008+$000020A2: 6700000a  beq.w $20ae
        beq.w H008+$20AE
L008_000020A6:
; H008+$000020A6: 0c2d004efffe  cmpi.b #$4e, -$2(a5)
        cmpi.b #$4e, -$2(a5)
L008_000020AC:
; H008+$000020AC: 66c2  bne.b $2070
        bne.b H008+$2070
L008_000020AE:
; H008+$000020AE: 102dfffe  move.b -$2(a5), d0
        move.b -$2(a5), d0
L008_000020B2:
; H008+$000020B2: 60000002  bra.w $20b6
        bra.w H008+$20B6
L008_000020B6:
; H008+$000020B6: 4e5d  unlk a5
        unlk a5
L008_000020B8:
; H008+$000020B8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_000020BA:
; H008+$000020BA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_000020BC:
; H008+$000020BC: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L008_000020C0:
; H008+$000020C0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_000020C2 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H003+$0068.
;   - Calls H003+$0068.
; Direct callers: H013+$4E86, H013+$0AEA, H064+$1434, H013+$0D1E, H013+$0E62, H013+$127E and 2 more
; --------------------------------------------------------------------------
L008_000020C2:
; H008+$000020C2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_000020C4:
; H008+$000020C4: 287adfd0  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_000020C8:
; H008+$000020C8: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L008_000020CC:
; H008+$000020CC: 7430  moveq #$30, d2
        moveq #48, d2
L008_000020CE:
; H008+$000020CE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L008_000020D0:
; H008+$000020D0: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L008_000020D6:
; H008+$000020D6: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L008_000020DC:
; H008+$000020DC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_000020E0:
; H008+$000020E0: 2680  move.l d0, (a3)
        move.l d0, (a3)
L008_000020E2:
; H008+$000020E2: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L008_000020E6:
; H008+$000020E6: 2652  movea.l (a2), a3
        movea.l (a2), a3
L008_000020E8:
; H008+$000020E8: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L008_000020EC:
; H008+$000020EC: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L008_000020F0:
; H008+$000020F0: 2652  movea.l (a2), a3
        movea.l (a2), a3
L008_000020F2:
; H008+$000020F2: 422b002a  clr.b $2a(a3)
        clr.b $2a(a3)
L008_000020F6:
; H008+$000020F6: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L008_000020FA:
; H008+$000020FA: 2652  movea.l (a2), a3
        movea.l (a2), a3
L008_000020FC:
; H008+$000020FC: 45ec0040  lea.l $40(a4), a2
        lea.l $40(a4), a2
L008_00002100:
; H008+$00002100: 7428  moveq #$28, d2
        moveq #40, d2
L008_00002102:
; H008+$00002102: 16da  move.b (a2)+, (a3)+
        move.b (a2)+, (a3)+
L008_00002104:
; H008+$00002104: 57cafffc  dbeq d2, $2102
        dbeq d2, H008+$2102
L008_00002108:
; H008+$00002108: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_0000210C:
; H008+$0000210C: 2b53fffc  move.l (a3), -$4(a5)
        move.l (a3), -$4(a5)
L008_00002110:
; H008+$00002110: 3b7c0002fffa  move.w #$2, -$6(a5)
        move.w #$2, -$6(a5)
L008_00002116:
; H008+$00002116: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L008_0000211A:
; H008+$0000211A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L008_0000211E:
; H008+$0000211E: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L008_00002120:
; H008+$00002120: 6e00004a  bgt.w $216c
        bgt.w H008+$216C
L008_00002124:
; H008+$00002124: 7430  moveq #$30, d2
        moveq #48, d2
L008_00002126:
; H008+$00002126: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L008_00002128:
; H008+$00002128: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L008_0000212E:
; H008+$0000212E: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L008_00002134:
; H008+$00002134: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_00002138:
; H008+$00002138: 2740002c  move.l d0, $2c(a3)
        move.l d0, $2c(a3)
L008_0000213C:
; H008+$0000213C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_00002140:
; H008+$00002140: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L008_00002146:
; H008+$00002146: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_0000214A:
; H008+$0000214A: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L008_0000214E:
; H008+$0000214E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_00002152:
; H008+$00002152: 422b002a  clr.b $2a(a3)
        clr.b $2a(a3)
L008_00002156:
; H008+$00002156: 47ec0042  lea.l $42(a4), a3
        lea.l $42(a4), a3
L008_0000215A:
; H008+$0000215A: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L008_0000215E:
; H008+$0000215E: 7428  moveq #$28, d2
        moveq #40, d2
L008_00002160:
; H008+$00002160: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L008_00002162:
; H008+$00002162: 57cafffc  dbeq d2, $2160
        dbeq d2, H008+$2160
L008_00002166:
; H008+$00002166: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L008_0000216A:
; H008+$0000216A: 68ae  bvc.b $211a
        bvc.b H008+$211A
L008_0000216C:
; H008+$0000216C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L008_0000216E:
; H008+$0000216E: 4e5d  unlk a5
        unlk a5
L008_00002170:
; H008+$00002170: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_00002172:
; H008+$00002172: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_00002174:
; H008+$00002174: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L008_00002176:
; H008+$00002176: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H008_00002178 [partial]
; Purpose: Routine of the UI interactions, choice requests and menus module; calls H003+$00F6.
;   - Calls H003+$00F6.
; Direct callers: H013+$4F42, H013+$51D2, H013+$0BD6, H013+$56B8, H013+$56C2, H013+$0D10 and 15 more
; --------------------------------------------------------------------------
L008_00002178:
; H008+$00002178: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L008_0000217A:
; H008+$0000217A: 287adf1a  movea.l $96(pc), a4
        movea.l H008+$96(pc), a4
L008_0000217E:
; H008+$0000217E: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L008_00002182:
; H008+$00002182: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00002186:
; H008+$00002186: 4a93  tst.l (a3)
        tst.l (a3)
L008_00002188:
; H008+$00002188: 67000038  beq.w $21c2
        beq.w H008+$21C2
L008_0000218C:
; H008+$0000218C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_00002190:
; H008+$00002190: 2b53fffc  move.l (a3), -$4(a5)
        move.l (a3), -$4(a5)
L008_00002194:
; H008+$00002194: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L008_00002198:
; H008+$00002198: 67000022  beq.w $21bc
        beq.w H008+$21BC
L008_0000219C:
; H008+$0000219C: 2b6dfffcfff8  move.l -$4(a5), -$8(a5)
        move.l -$4(a5), -$8(a5)
L008_000021A2:
; H008+$000021A2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L008_000021A6:
; H008+$000021A6: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L008_000021AC:
; H008+$000021AC: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L008_000021B0:
; H008+$000021B0: 7430  moveq #$30, d2
        moveq #48, d2
L008_000021B2:
; H008+$000021B2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L008_000021B4:
; H008+$000021B4: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L008_000021BA:
; H008+$000021BA: 60d8  bra.b $2194
        bra.b H008+$2194
L008_000021BC:
; H008+$000021BC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L008_000021C0:
; H008+$000021C0: 4293  clr.l (a3)
        clr.l (a3)
L008_000021C2:
; H008+$000021C2: 4e5d  unlk a5
        unlk a5
L008_000021C4:
; H008+$000021C4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_000021C6:
; H008+$000021C6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L008_000021C8:
; H008+$000021C8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L008_000021CA:
; H008+$000021CA: 4ed0  jmp (a0)
        jmp (a0)
L008_000021CC:
; H008+$000021CC: 4e5d  unlk a5
        unlk a5
L008_000021CE:
; H008+$000021CE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L008_000021D0:
; H008+$000021D0: 4e75  rts 
        rts 
; Preserved bytes H008+$000021D2..$000021D4; code/data not fully classified.
        dc.w $0000
; End H008: $21D4 bytes
