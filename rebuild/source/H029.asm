; ============================================================================
; MODULE GUIDE H029
; Graphic records, bitplanes, masks and tile drawing.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Graphic records: allocates BitMap and planes, loads DAA blocks, copies the planes, prepares masks and draws 24x24 tiles with a masked or direct blit.
; --------------------------------------------------------------------------
; H029: 6084 original bytes; all offsets are section-relative.
        section H029,code
H029:
; Preserved bytes H029+$00000000..$00000118; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$7374,$6172,$7420
        dc.w $7465,$7374,$6368,$6970,$616C,$6C6F,$6300,$6578
        dc.w $6974,$2074,$6573,$7463,$6869,$7061,$6C6C,$6F63
        dc.w $0070,$6F69,$6E74,$6572,$732E,$6461,$6100,$706C
        dc.w $616E,$6520,$616C,$6C6F,$6320,$7072,$6F62,$6C65
        dc.w $6D00,$706C,$616E,$6520,$616C,$6C6F,$6320,$7072
        dc.w $6F62,$6C65,$6D00,$7468,$6567,$7261,$6672,$6563
        dc.w $2D00,$3878,$3800,$2E64,$6161,$006C,$6F61,$6467
        dc.w $7261,$6672,$6563,$3A74,$6275,$6673,$697A,$6500
        dc.w $696E,$7475,$6974,$696F,$6E2E,$6C69,$6272,$6172
        dc.w $7900,$6772,$6170,$6869,$6373,$2E6C,$6962,$7261
        dc.w $7279,$0000
        dc.l H029+$0000006A
; --------------------------------------------------------------------------
; ROUTINE: module_init_H029 [partial]
; Purpose: Entry of the graphic records, bitplanes, masks and tile drawing module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H029+$179C.
; Direct callers: H000+$0120
; --------------------------------------------------------------------------
L029_00000118:
; H029+$00000118: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_0000011A:
; H029+$0000011A: 287afff8  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000011E:
; H029+$0000011E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_00000122:
; H029+$00000122: 60001678  bra.w $179c
        bra.w H029+$179C
; Preserved bytes H029+$00000126..$00000180; code/data not fully classified.
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
; ROUTINE: sub_H029_00000180 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H003+$00F6, H021+$0230.
;   - Calls H003+$00F6.
;   - Calls H021+$0230.
;   - Uses the global state: H005+$52F6 (pointer to the game window).
; Direct callers: H029+$12C6, H029+$02FE
; --------------------------------------------------------------------------
L029_00000180:
; H029+$00000180: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000182:
; H029+$00000182: 287aff90  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000186:
; H029+$00000186: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_0000018A:
; H029+$0000018A: 4aacffec  tst.l -$14(a4)
        tst.l -$14(a4)
L029_0000018E:
; H029+$0000018E: 67000020  beq.w $1b0
        beq.w H029+$1B0
L029_00000192:
; H029+$00000192: 2f2cffec  move.l -$14(a4), -(a7)
        move.l -$14(a4), -(a7)
L029_00000196:
; H029+$00000196: 2f2cffe8  move.l -$18(a4), -(a7)
        move.l -$18(a4), -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L029_0000019A:
; H029+$0000019A: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L029_000001A0:
; H029+$000001A0: 42acffec  clr.l -$14(a4)
        clr.l -$14(a4)
; STATE: H005+$52F6 = pointer to the game window
L029_000001A4:
; H029+$000001A4: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
; -> H021+$0230 (wrapper_ClearPointer)
L029_000001AA:
; H029+$000001AA: 4eb900000230  jsr $230.l
        jsr (H021+$230).l
L029_000001B0:
; H029+$000001B0: 4e5d  unlk a5
        unlk a5
L029_000001B2:
; H029+$000001B2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000001B4:
; H029+$000001B4: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_000001B6 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H021+$02EE.
;   - Calls H021+$02EE.
;   - Uses the global state: H005+$52F6 (pointer to the game window).
; Direct callers: H008+$0A0C, H058+$10A2, H058+$1250
; --------------------------------------------------------------------------
L029_000001B6:
; H029+$000001B6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_000001B8:
; H029+$000001B8: 287aff5a  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000001BC:
; H029+$000001BC: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_000001C0:
; H029+$000001C0: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L029_000001C4:
; H029+$000001C4: 6d000018  blt.w $1de
        blt.w H029+$1DE
L029_000001C8:
; H029+$000001C8: 0c6d000b000c  cmpi.w #$b, $c(a5)
        cmpi.w #$b, $c(a5)
L029_000001CE:
; H029+$000001CE: 6e00000e  bgt.w $1de
        bgt.w H029+$1DE
L029_000001D2:
; H029+$000001D2: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L029_000001D6:
; H029+$000001D6: b46cfff0  cmp.w -$10(a4), d2
        cmp.w -$10(a4), d2
L029_000001DA:
; H029+$000001DA: 66000006  bne.w $1e2
        bne.w H029+$1E2
L029_000001DE:
; H029+$000001DE: 6000004a  bra.w $22a
        bra.w H029+$22A
L029_000001E2:
; H029+$000001E2: 396d000cfff0  move.w $c(a5), -$10(a4)
        move.w $c(a5), -$10(a4)
L029_000001E8:
; H029+$000001E8: 4aacffec  tst.l -$14(a4)
        tst.l -$14(a4)
L029_000001EC:
; H029+$000001EC: 6700003c  beq.w $22a
        beq.w H029+$22A
L029_000001F0:
; H029+$000001F0: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L029_000001F4:
; H029+$000001F4: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L029_000001F8:
; H029+$000001F8: 266cffec  movea.l -$14(a4), a3
        movea.l -$14(a4), a3
L029_000001FC:
; H029+$000001FC: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L029_00000200:
; H029+$00000200: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; STATE: H005+$52F6 = pointer to the game window
L029_00000202:
; H029+$00000202: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
L029_00000208:
; H029+$00000208: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L029_0000020A:
; H029+$0000020A: 3f2b0008  move.w $8(a3), -(a7)
        move.w $8(a3), -(a7)
L029_0000020E:
; H029+$0000020E: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L029_00000212:
; H029+$00000212: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L029_00000216:
; H029+$00000216: 4442  neg.w d2
        neg.w d2
L029_00000218:
; H029+$00000218: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_0000021A:
; H029+$0000021A: 342b0006  move.w $6(a3), d2
        move.w $6(a3), d2
L029_0000021E:
; H029+$0000021E: 4442  neg.w d2
        neg.w d2
L029_00000220:
; H029+$00000220: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H021+$02EE (wrapper_SetPointer)
L029_00000222:
; H029+$00000222: 4eb9000002ee  jsr $2ee.l
        jsr (H021+$2EE).l
L029_00000228:
; H029+$00000228: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_0000022A:
; H029+$0000022A: 4e5d  unlk a5
        unlk a5
L029_0000022C:
; H029+$0000022C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_0000022E:
; H029+$0000022E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000230:
; H029+$00000230: 548f  addq.l #$2, a7
        addq.l #$2, a7
L029_00000232:
; H029+$00000232: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00000234 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H002+$00F2, H002+$0156, H003+$0068, H002+$0122.
;   - Calls H002+$00F2.
;   - Calls H002+$0156.
;   - Calls H003+$0068.
;   - Calls H002+$0122.
;   - Calls H002+$0014.
; Direct callers: H029+$12B2
; --------------------------------------------------------------------------
L029_00000234:
; H029+$00000234: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000236:
; H029+$00000236: 287afedc  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000023A:
; H029+$0000023A: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L029_0000023E:
; H029+$0000023E: 47ec0027  lea.l $27(a4), a3
        lea.l $27(a4), a3
L029_00000242:
; H029+$00000242: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000244:
; H029+$00000244: 2f3c000003ed  move.l #MODE_OLDFILE, -(a7)
        move.l #MODE_OLDFILE, -(a7)
; -> H002+$00F2 (wrapper_Open)
L029_0000024A:
; H029+$0000024A: 4eb9000000f2  jsr $f2.l
        jsr (H002+$F2).l
L029_00000250:
; H029+$00000250: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L029_00000254:
; H029+$00000254: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L029_00000258:
; H029+$00000258: 670000b2  beq.w $30c
        beq.w H029+$30C
L029_0000025C:
; H029+$0000025C: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L029_00000260:
; H029+$00000260: 42a7  clr.l -(a7)
        clr.l -(a7)
L029_00000262:
; H029+$00000262: 2f3c00000001  move.l #$1, -(a7)
        move.l #$1, -(a7)
; -> H002+$0156 (wrapper_Seek)
L029_00000268:
; H029+$00000268: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L029_0000026E:
; H029+$0000026E: 2940ffe8  move.l d0, -$18(a4)
        move.l d0, -$18(a4)
L029_00000272:
; H029+$00000272: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L029_00000276:
; H029+$00000276: 42a7  clr.l -(a7)
        clr.l -(a7)
L029_00000278:
; H029+$00000278: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H002+$0156 (wrapper_Seek)
L029_0000027E:
; H029+$0000027E: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L029_00000284:
; H029+$00000284: 2940ffe8  move.l d0, -$18(a4)
        move.l d0, -$18(a4)
L029_00000288:
; H029+$00000288: 2f2cffe8  move.l -$18(a4), -(a7)
        move.l -$18(a4), -(a7)
L029_0000028C:
; H029+$0000028C: 2f3c00000002  move.l #$2, -(a7)
        move.l #MEMF_CHIP, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L029_00000292:
; H029+$00000292: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L029_00000298:
; H029+$00000298: 2940ffec  move.l d0, -$14(a4)
        move.l d0, -$14(a4)
L029_0000029C:
; H029+$0000029C: 4aacffec  tst.l -$14(a4)
        tst.l -$14(a4)
L029_000002A0:
; H029+$000002A0: 67000060  beq.w $302
        beq.w H029+$302
L029_000002A4:
; H029+$000002A4: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L029_000002A8:
; H029+$000002A8: 2f2cffec  move.l -$14(a4), -(a7)
        move.l -$14(a4), -(a7)
L029_000002AC:
; H029+$000002AC: 2f2cffe8  move.l -$18(a4), -(a7)
        move.l -$18(a4), -(a7)
; -> H002+$0122 (wrapper_Read)
L029_000002B0:
; H029+$000002B0: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L029_000002B6:
; H029+$000002B6: 2400  move.l d0, d2
        move.l d0, d2
L029_000002B8:
; H029+$000002B8: b4acffe8  cmp.l -$18(a4), d2
        cmp.l -$18(a4), d2
L029_000002BC:
; H029+$000002BC: 66000040  bne.w $2fe
        bne.w H029+$2FE
L029_000002C0:
; H029+$000002C0: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L029_000002C4:
; H029+$000002C4: 0c6d000bfffa  cmpi.w #$b, -$6(a5)
        cmpi.w #$b, -$6(a5)
L029_000002CA:
; H029+$000002CA: 6e00002e  bgt.w $2fa
        bgt.w H029+$2FA
L029_000002CE:
; H029+$000002CE: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_000002D2:
; H029+$000002D2: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L029_000002D6:
; H029+$000002D6: 266cffec  movea.l -$14(a4), a3
        movea.l -$14(a4), a3
L029_000002DA:
; H029+$000002DA: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L029_000002DE:
; H029+$000002DE: c9fc000a  muls.w #$a, d4
        muls.w #$a, d4
L029_000002E2:
; H029+$000002E2: 246cffec  movea.l -$14(a4), a2
        movea.l -$14(a4), a2
L029_000002E6:
; H029+$000002E6: 2c324800  move.l (a2, d4.l), d6
        move.l (a2, d4.l), d6
L029_000002EA:
; H029+$000002EA: 282cffec  move.l -$14(a4), d4
        move.l -$14(a4), d4
L029_000002EE:
; H029+$000002EE: dc84  add.l d4, d6
        add.l d4, d6
L029_000002F0:
; H029+$000002F0: 27862800  move.l d6, (a3, d2.l)
        move.l d6, (a3, d2.l)
L029_000002F4:
; H029+$000002F4: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L029_000002F8:
; H029+$000002F8: 68ca  bvc.b $2c4
        bvc.b H029+$2C4
L029_000002FA:
; H029+$000002FA: 60000006  bra.w $302
        bra.w H029+$302
L029_000002FE:
; H029+$000002FE: 6100fe80  bsr.w $180
        bsr.w H029+$180
L029_00000302:
; H029+$00000302: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L029_00000306:
; H029+$00000306: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L029_0000030C:
; H029+$0000030C: 4e5d  unlk a5
        unlk a5
L029_0000030E:
; H029+$0000030E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000310:
; H029+$00000310: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00000312 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H027+$08EA, H027+$2758, H085+$277A, H062+$28EE, H085+$13B0, H085+$1530 and 58 more
; --------------------------------------------------------------------------
L029_00000312:
; H029+$00000312: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000314:
; H029+$00000314: 287afdfe  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000318:
; H029+$00000318: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L029_0000031C:
; H029+$0000031C: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L029_00000320:
; H029+$00000320: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L029_00000324:
; H029+$00000324: 5342  subq.w #$1, d2
        subq.w #$1, d2
L029_00000326:
; H029+$00000326: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000328:
; H029+$00000328: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_0000032C:
; H029+$0000032C: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L029_0000032E:
; H029+$0000032E: 62000016  bhi.w $346
        bhi.w H029+$346
L029_00000332:
; H029+$00000332: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_00000336:
; H029+$00000336: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L029_0000033A:
; H029+$0000033A: 17ad000c2000  move.b $c(a5), (a3, d2.w)
        move.b $c(a5), (a3, d2.w)
L029_00000340:
; H029+$00000340: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L029_00000344:
; H029+$00000344: 64e2  bcc.b $328
        bcc.b H029+$328
L029_00000346:
; H029+$00000346: 548f  addq.l #$2, a7
        addq.l #$2, a7
L029_00000348:
; H029+$00000348: 4e5d  unlk a5
        unlk a5
L029_0000034A:
; H029+$0000034A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_0000034C:
; H029+$0000034C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_0000034E:
; H029+$0000034E: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L029_00000352:
; H029+$00000352: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H029_036C [partial]
; Purpose: Trampoline to H029+$036C; the actual body is there.
;   - Jumps to the actual body at H029+$036C.
; Direct callers: H027+$0690, H027+$06FA, H027+$0A5A, H027+$0DE2, H027+$138A, H027+$1A22 and 158 more
; --------------------------------------------------------------------------
L029_00000354:
; H029+$00000354: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000356:
; H029+$00000356: 287afdbc  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000035A:
; H029+$0000035A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_0000035E:
; H029+$0000035E: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L029_00000362:
; H029+$00000362: c42d000e  and.b $e(a5), d2
        and.b $e(a5), d2
L029_00000366:
; H029+$00000366: 1002  move.b d2, d0
        move.b d2, d0
L029_00000368:
; H029+$00000368: 60000002  bra.w $36c
        bra.w H029+$36C
L029_0000036C:
; H029+$0000036C: 4e5d  unlk a5
        unlk a5
L029_0000036E:
; H029+$0000036E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000370:
; H029+$00000370: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000372:
; H029+$00000372: 588f  addq.l #$4, a7
        addq.l #$4, a7
L029_00000374:
; H029+$00000374: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H029_0390 [partial]
; Purpose: Trampoline to H029+$0390; the actual body is there.
;   - Jumps to the actual body at H029+$0390.
; Direct callers: H027+$30F0, H027+$3E1C, H068+$0D62
; --------------------------------------------------------------------------
L029_00000376:
; H029+$00000376: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000378:
; H029+$00000378: 287afd9a  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000037C:
; H029+$0000037C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_00000380:
; H029+$00000380: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L029_00000384:
; H029+$00000384: 182d000e  move.b $e(a5), d4
        move.b $e(a5), d4
L029_00000388:
; H029+$00000388: b504  eor.b d2, d4
        eor.b d2, d4
L029_0000038A:
; H029+$0000038A: 1004  move.b d4, d0
        move.b d4, d0
L029_0000038C:
; H029+$0000038C: 60000002  bra.w $390
        bra.w H029+$390
L029_00000390:
; H029+$00000390: 4e5d  unlk a5
        unlk a5
L029_00000392:
; H029+$00000392: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000394:
; H029+$00000394: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000396:
; H029+$00000396: 588f  addq.l #$4, a7
        addq.l #$4, a7
L029_00000398:
; H029+$00000398: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H029_03B2 [partial]
; Purpose: Trampoline to H029+$03B2; the actual body is there.
;   - Jumps to the actual body at H029+$03B2.
; Direct callers: H085+$265E, H027+$38C8, H012+$2552, H013+$5C56, H064+$129A, H068+$0D90 and 8 more
; --------------------------------------------------------------------------
L029_0000039A:
; H029+$0000039A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_0000039C:
; H029+$0000039C: 287afd76  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000003A0:
; H029+$000003A0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_000003A4:
; H029+$000003A4: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L029_000003A8:
; H029+$000003A8: 842d000e  or.b $e(a5), d2
        or.b $e(a5), d2
L029_000003AC:
; H029+$000003AC: 1002  move.b d2, d0
        move.b d2, d0
L029_000003AE:
; H029+$000003AE: 60000002  bra.w $3b2
        bra.w H029+$3B2
L029_000003B2:
; H029+$000003B2: 4e5d  unlk a5
        unlk a5
L029_000003B4:
; H029+$000003B4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000003B6:
; H029+$000003B6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_000003B8:
; H029+$000003B8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L029_000003BA:
; H029+$000003BA: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H029+$000003BC..$000003E2; code/data not fully classified.
        dc.w $2F0C,$287A,$FD54,$4E55,$0000,$343C,$00FF,$182D
        dc.w $000C,$4604,$C404,$1002,$6000,$0002,$4E5D,$285F
        dc.w $205F,$548F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_000003E2 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H027+$0378, H027+$0426, H027+$060A, H027+$0664, H027+$06C2, H027+$09D8 and 103 more
; --------------------------------------------------------------------------
L029_000003E2:
; H029+$000003E2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_000003E4:
; H029+$000003E4: 287afd2e  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000003E8:
; H029+$000003E8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_000003EC:
; H029+$000003EC: 7400  moveq #$0, d2
        moveq #0, d2
L029_000003EE:
; H029+$000003EE: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L029_000003F2:
; H029+$000003F2: 1413  move.b (a3), d2
        move.b (a3), d2
L029_000003F4:
; H029+$000003F4: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L029_000003F8:
; H029+$000003F8: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L029_000003FC:
; H029+$000003FC: 1682  move.b d2, (a3)
        move.b d2, (a3)
L029_000003FE:
; H029+$000003FE: 4e5d  unlk a5
        unlk a5
L029_00000400:
; H029+$00000400: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000402:
; H029+$00000402: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000404:
; H029+$00000404: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L029_00000406:
; H029+$00000406: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Allocate_GraphicRecord [verified]
; Purpose: Creates the graphic record of the game and the bitplane memory.
;   - Aligns the width to 16 pixels.
;   - Allocates the 20-byte record and a 40-byte BitMap.
;   - Initialises a five-plane bitmap, allocates each raster and clears it.
;   - If requested it also builds the mask bitmap.
;   - Stores geometry and sizes in the resulting record.
; Direct callers: H006+$035A, H006+$0374, H006+$0390, H029+$0B48, H029+$0F80, H029+$136E, H035+$05BE, H042+$0202, H042+$07EE, H042+$0912 ...
; --------------------------------------------------------------------------
L029_00000408:
; H029+$00000408: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_0000040A:
; H029+$0000040A: 287afd08  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000040E:
; H029+$0000040E: 4e55ffce  link.w a5, #$ffce
        link.w a5, #$ffce
L029_00000412:
; H029+$00000412: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L029_00000416:
; H029+$00000416: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000418:
; H029+$00000418: c4ed0014  mulu.w $14(a5), d2
        mulu.w $14(a5), d2
L029_0000041C:
; H029+$0000041C: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L029_00000420:
; H029+$00000420: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000422:
; H029+$00000422: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_00000426:
; H029+$00000426: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_0000042A:
; H029+$0000042A: 4a42  tst.w d2
        tst.w d2
L029_0000042C:
; H029+$0000042C: 63000014  bls.w $442
        bls.w H029+$442
L029_00000430:
; H029+$00000430: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000432:
; H029+$00000432: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_00000436:
; H029+$00000436: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_0000043A:
; H029+$0000043A: 7810  moveq #$10, d4
        moveq #16, d4
L029_0000043C:
; H029+$0000043C: 9842  sub.w d2, d4
        sub.w d2, d4
L029_0000043E:
; H029+$0000043E: d96dfffa  add.w d4, -$6(a5)
        add.w d4, -$6(a5)
L029_00000442:
; H029+$00000442: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000444:
; H029+$00000444: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_00000448:
; H029+$00000448: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L029_0000044A:
; H029+$0000044A: c4ed0016  mulu.w $16(a5), d2
        mulu.w $16(a5), d2
L029_0000044E:
; H029+$0000044E: c4fc0005  mulu.w #$5, d2
        mulu.w #$5, d2
L029_00000452:
; H029+$00000452: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L029_00000456:
; H029+$00000456: 7414  moveq #$14, d2
        moveq #20, d2
L029_00000458:
; H029+$00000458: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_0000045A:
; H029+$0000045A: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L029_00000460:
; H029+$00000460: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L029_00000466:
; H029+$00000466: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_0000046A:
; H029+$0000046A: 2680  move.l d0, (a3)
        move.l d0, (a3)
L029_0000046C:
; H029+$0000046C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000470:
; H029+$00000470: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000472:
; H029+$00000472: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000474:
; H029+$00000474: 7428  moveq #$28, d2
        moveq #40, d2
L029_00000476:
; H029+$00000476: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_00000478:
; H029+$00000478: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L029_0000047E:
; H029+$0000047E: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L029_00000484:
; H029+$00000484: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000486:
; H029+$00000486: 27400010  move.l d0, $10(a3)
        move.l d0, $10(a3)
L029_0000048A:
; H029+$0000048A: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_0000048E:
; H029+$0000048E: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000490:
; H029+$00000490: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L029_00000494:
; H029+$00000494: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L029_00000498:
; H029+$00000498: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_0000049C:
; H029+$0000049C: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
; -> H037+$0014 (wrapper_InitBitMap)
L029_000004A0:
; H029+$000004A0: 4eb900000014  jsr $14.l
        jsr (H037+$14).l
L029_000004A6:
; H029+$000004A6: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
; STEP: Allocation loop of the five rasters Planes[0..4].
L029_000004AA:
; H029+$000004AA: 0c6d0004fffe  cmpi.w #$4, -$2(a5)
        cmpi.w #$4, -$2(a5)
L029_000004B0:
; H029+$000004B0: 62000098  bhi.w $54a
        bhi.w H029+$54A
L029_000004B4:
; H029+$000004B4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_000004B8:
; H029+$000004B8: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_000004BA:
; H029+$000004BA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L029_000004BE:
; H029+$000004BE: e542  asl.w #$2, d2
        asl.w #$2, d2
L029_000004C0:
; H029+$000004C0: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L029_000004C4:
; H029+$000004C4: 47eb0008  lea.l $8(a3), a3
        lea.l $8(a3), a3
L029_000004C8:
; H029+$000004C8: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L029_000004CC:
; H029+$000004CC: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_000004D0:
; H029+$000004D0: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
; -> H055+$0014 (wrapper_AllocRaster)
L029_000004D4:
; H029+$000004D4: 4eb900000014  jsr $14.l
        jsr (H055+$14).l
L029_000004DA:
; H029+$000004DA: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L029_000004DE:
; H029+$000004DE: 27802000  move.l d0, (a3, d2.w)
        move.l d0, (a3, d2.w)
L029_000004E2:
; H029+$000004E2: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_000004E6:
; H029+$000004E6: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_000004E8:
; H029+$000004E8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L029_000004EC:
; H029+$000004EC: e542  asl.w #$2, d2
        asl.w #$2, d2
L029_000004EE:
; H029+$000004EE: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L029_000004F2:
; H029+$000004F2: 47eb0008  lea.l $8(a3), a3
        lea.l $8(a3), a3
L029_000004F6:
; H029+$000004F6: 4ab32000  tst.l (a3, d2.w)
        tst.l (a3, d2.w)
L029_000004FA:
; H029+$000004FA: 66000018  bne.w $514
        bne.w H029+$514
L029_000004FE:
; H029+$000004FE: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L029_00000502:
; H029+$00000502: 486c0034  pea.l $34(a4)
        pea.l $34(a4)
L029_00000506:
; H029+$00000506: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; -> H014+$0018 (sub_H014_00000018)
L029_0000050A:
; H029+$0000050A: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L029_00000510:
; H029+$00000510: 60000030  bra.w $542
        bra.w H029+$542
L029_00000514:
; H029+$00000514: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000518:
; H029+$00000518: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_0000051A:
; H029+$0000051A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L029_0000051E:
; H029+$0000051E: e542  asl.w #$2, d2
        asl.w #$2, d2
L029_00000520:
; H029+$00000520: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L029_00000524:
; H029+$00000524: 47eb0008  lea.l $8(a3), a3
        lea.l $8(a3), a3
L029_00000528:
; H029+$00000528: 2f332000  move.l (a3, d2.w), -(a7)
        move.l (a3, d2.w), -(a7)
L029_0000052C:
; H029+$0000052C: 7400  moveq #$0, d2
        moveq #0, d2
L029_0000052E:
; H029+$0000052E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_00000532:
; H029+$00000532: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L029_00000534:
; H029+$00000534: c4ed0016  mulu.w $16(a5), d2
        mulu.w $16(a5), d2
L029_00000538:
; H029+$00000538: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_0000053A:
; H029+$0000053A: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0084 (wrapper_BltClear)
L029_0000053C:
; H029+$0000053C: 4eb900000084  jsr $84.l
        jsr (H016+$84).l
L029_00000542:
; H029+$00000542: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L029_00000546:
; H029+$00000546: 6400ff62  bcc.w $4aa
        bcc.w H029+$4AA
; STEP: If a mask is requested, allocates and links a separate bitmap.
L029_0000054A:
; H029+$0000054A: 0c6d00010010  cmpi.w #$1, $10(a5)
        cmpi.w #$1, $10(a5)
L029_00000550:
; H029+$00000550: 660000e4  bne.w $636
        bne.w H029+$636
L029_00000554:
; H029+$00000554: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000558:
; H029+$00000558: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_0000055A:
; H029+$0000055A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_0000055C:
; H029+$0000055C: 7428  moveq #$28, d2
        moveq #40, d2
L029_0000055E:
; H029+$0000055E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_00000560:
; H029+$00000560: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L029_00000566:
; H029+$00000566: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L029_0000056C:
; H029+$0000056C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_0000056E:
; H029+$0000056E: 2740000c  move.l d0, $c(a3)
        move.l d0, $c(a3)
L029_00000572:
; H029+$00000572: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000576:
; H029+$00000576: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000578:
; H029+$00000578: 2f2b000c  move.l $c(a3), -(a7)
        move.l $c(a3), -(a7)
L029_0000057C:
; H029+$0000057C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L029_00000580:
; H029+$00000580: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_00000584:
; H029+$00000584: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
; -> H037+$0014 (wrapper_InitBitMap)
L029_00000588:
; H029+$00000588: 4eb900000014  jsr $14.l
        jsr (H037+$14).l
L029_0000058E:
; H029+$0000058E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000592:
; H029+$00000592: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000594:
; H029+$00000594: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000596:
; H029+$00000596: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_0000059A:
; H029+$0000059A: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
; -> H055+$0014 (wrapper_AllocRaster)
L029_0000059E:
; H029+$0000059E: 4eb900000014  jsr $14.l
        jsr (H055+$14).l
L029_000005A4:
; H029+$000005A4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_000005A6:
; H029+$000005A6: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L029_000005AA:
; H029+$000005AA: 27400008  move.l d0, $8(a3)
        move.l d0, $8(a3)
L029_000005AE:
; H029+$000005AE: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_000005B2:
; H029+$000005B2: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_000005B4:
; H029+$000005B4: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L029_000005B8:
; H029+$000005B8: 4aab0008  tst.l $8(a3)
        tst.l $8(a3)
L029_000005BC:
; H029+$000005BC: 66000016  bne.w $5d4
        bne.w H029+$5D4
L029_000005C0:
; H029+$000005C0: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L029_000005C4:
; H029+$000005C4: 486c0048  pea.l $48(a4)
        pea.l $48(a4)
L029_000005C8:
; H029+$000005C8: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H014+$0018 (sub_H014_00000018)
L029_000005CA:
; H029+$000005CA: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L029_000005D0:
; H029+$000005D0: 60000026  bra.w $5f8
        bra.w H029+$5F8
L029_000005D4:
; H029+$000005D4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_000005D8:
; H029+$000005D8: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_000005DA:
; H029+$000005DA: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L029_000005DE:
; H029+$000005DE: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
L029_000005E2:
; H029+$000005E2: 7400  moveq #$0, d2
        moveq #0, d2
L029_000005E4:
; H029+$000005E4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_000005E8:
; H029+$000005E8: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L029_000005EA:
; H029+$000005EA: c4ed0016  mulu.w $16(a5), d2
        mulu.w $16(a5), d2
L029_000005EE:
; H029+$000005EE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_000005F0:
; H029+$000005F0: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0084 (wrapper_BltClear)
L029_000005F2:
; H029+$000005F2: 4eb900000084  jsr $84.l
        jsr (H016+$84).l
L029_000005F8:
; H029+$000005F8: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L029_000005FE:
; H029+$000005FE: 0c6d0004fffe  cmpi.w #$4, -$2(a5)
        cmpi.w #$4, -$2(a5)
L029_00000604:
; H029+$00000604: 6200002c  bhi.w $632
        bhi.w H029+$632
L029_00000608:
; H029+$00000608: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_0000060C:
; H029+$0000060C: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_0000060E:
; H029+$0000060E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L029_00000612:
; H029+$00000612: e542  asl.w #$2, d2
        asl.w #$2, d2
L029_00000614:
; H029+$00000614: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L029_00000618:
; H029+$00000618: 47eb0008  lea.l $8(a3), a3
        lea.l $8(a3), a3
L029_0000061C:
; H029+$0000061C: 226d000c  movea.l $c(a5), a1
        movea.l $c(a5), a1
L029_00000620:
; H029+$00000620: 2451  movea.l (a1), a2
        movea.l (a1), a2
L029_00000622:
; H029+$00000622: 246a000c  movea.l $c(a2), a2
        movea.l $c(a2), a2
L029_00000626:
; H029+$00000626: 27aa00082000  move.l $8(a2), (a3, d2.w)
        move.l $8(a2), (a3, d2.w)
L029_0000062C:
; H029+$0000062C: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L029_00000630:
; H029+$00000630: 64cc  bcc.b $5fe
        bcc.b H029+$5FE
L029_00000632:
; H029+$00000632: 6000000c  bra.w $640
        bra.w H029+$640
L029_00000636:
; H029+$00000636: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_0000063A:
; H029+$0000063A: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_0000063C:
; H029+$0000063C: 42ab000c  clr.l $c(a3)
        clr.l $c(a3)
L029_00000640:
; H029+$00000640: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000644:
; H029+$00000644: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000646:
; H029+$00000646: 36ad0016  move.w $16(a5), (a3)
        move.w $16(a5), (a3)
L029_0000064A:
; H029+$0000064A: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_0000064E:
; H029+$0000064E: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000650:
; H029+$00000650: 376d00140002  move.w $14(a5), $2(a3)
        move.w $14(a5), $2(a3)
L029_00000656:
; H029+$00000656: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_0000065A:
; H029+$0000065A: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_0000065C:
; H029+$0000065C: 376dfffc000a  move.w -$4(a5), $a(a3)
        move.w -$4(a5), $a(a3)
L029_00000662:
; H029+$00000662: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000666:
; H029+$00000666: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000668:
; H029+$00000668: 376d00120008  move.w $12(a5), $8(a3)
        move.w $12(a5), $8(a3)
L029_0000066E:
; H029+$0000066E: 4e5d  unlk a5
        unlk a5
L029_00000670:
; H029+$00000670: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000672:
; H029+$00000672: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000674:
; H029+$00000674: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L029_00000678:
; H029+$00000678: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Free_GraphicRecord [partial]
; Purpose: Frees the graphic record, the rasters and the associated mask.
;   - Used before replacing a picture and in the clean-up of the resources.
;   - The caller passes the address of the pointer to the record.
; Direct callers: H006+$01A2, H010+$0152, H010+$015E, H010+$016A, H010+$0176, H010+$0182, H010+$018E, H010+$01B8, H010+$01E2, H010+$0224 ...
; --------------------------------------------------------------------------
L029_0000067A:
; H029+$0000067A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_0000067C:
; H029+$0000067C: 287afa96  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000680:
; H029+$00000680: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L029_00000684:
; H029+$00000684: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_00000688:
; H029+$00000688: 4a93  tst.l (a3)
        tst.l (a3)
L029_0000068A:
; H029+$0000068A: 6600000a  bne.w $696
        bne.w H029+$696
L029_0000068E:
; H029+$0000068E: 600000cc  bra.w $75c
        bra.w H029+$75C
; Preserved bytes H029+$00000692..$00000696; code/data not fully classified.
        dc.w $6000,$0002
L029_00000696:
; H029+$00000696: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_0000069A:
; H029+$0000069A: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_0000069C:
; H029+$0000069C: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_000006A0:
; H029+$000006A0: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_000006A2:
; H029+$000006A2: c4eb0008  mulu.w $8(a3), d2
        mulu.w $8(a3), d2
L029_000006A6:
; H029+$000006A6: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L029_000006AA:
; H029+$000006AA: 7400  moveq #$0, d2
        moveq #0, d2
L029_000006AC:
; H029+$000006AC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_000006B0:
; H029+$000006B0: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_000006B4:
; H029+$000006B4: 4a42  tst.w d2
        tst.w d2
L029_000006B6:
; H029+$000006B6: 63000014  bls.w $6cc
        bls.w H029+$6CC
L029_000006BA:
; H029+$000006BA: 7400  moveq #$0, d2
        moveq #0, d2
L029_000006BC:
; H029+$000006BC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_000006C0:
; H029+$000006C0: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_000006C4:
; H029+$000006C4: 7810  moveq #$10, d4
        moveq #16, d4
L029_000006C6:
; H029+$000006C6: 9842  sub.w d2, d4
        sub.w d2, d4
L029_000006C8:
; H029+$000006C8: d96dfffa  add.w d4, -$6(a5)
        add.w d4, -$6(a5)
L029_000006CC:
; H029+$000006CC: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L029_000006D0:
; H029+$000006D0: 0c6d0004fffe  cmpi.w #$4, -$2(a5)
        cmpi.w #$4, -$2(a5)
L029_000006D6:
; H029+$000006D6: 6200002a  bhi.w $702
        bhi.w H029+$702
L029_000006DA:
; H029+$000006DA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000006DC:
; H029+$000006DC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L029_000006E0:
; H029+$000006E0: e542  asl.w #$2, d2
        asl.w #$2, d2
L029_000006E2:
; H029+$000006E2: 246b0010  movea.l $10(a3), a2
        movea.l $10(a3), a2
L029_000006E6:
; H029+$000006E6: 45ea0008  lea.l $8(a2), a2
        lea.l $8(a2), a2
L029_000006EA:
; H029+$000006EA: 2f322000  move.l (a2, d2.w), -(a7)
        move.l (a2, d2.w), -(a7)
L029_000006EE:
; H029+$000006EE: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_000006F2:
; H029+$000006F2: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
; -> H055+$002A (wrapper_FreeRaster)
L029_000006F4:
; H029+$000006F4: 4eb90000002a  jsr $2a.l
        jsr (H055+$2A).l
L029_000006FA:
; H029+$000006FA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_000006FC:
; H029+$000006FC: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L029_00000700:
; H029+$00000700: 64ce  bcc.b $6d0
        bcc.b H029+$6D0
L029_00000702:
; H029+$00000702: 4aab000c  tst.l $c(a3)
        tst.l $c(a3)
L029_00000706:
; H029+$00000706: 6700002c  beq.w $734
        beq.w H029+$734
L029_0000070A:
; H029+$0000070A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_0000070C:
; H029+$0000070C: 246b000c  movea.l $c(a3), a2
        movea.l $c(a3), a2
L029_00000710:
; H029+$00000710: 2f2a0008  move.l $8(a2), -(a7)
        move.l $8(a2), -(a7)
L029_00000714:
; H029+$00000714: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_00000718:
; H029+$00000718: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
; -> H055+$002A (wrapper_FreeRaster)
L029_0000071A:
; H029+$0000071A: 4eb90000002a  jsr $2a.l
        jsr (H055+$2A).l
L029_00000720:
; H029+$00000720: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000722:
; H029+$00000722: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000724:
; H029+$00000724: 2f2b000c  move.l $c(a3), -(a7)
        move.l $c(a3), -(a7)
L029_00000728:
; H029+$00000728: 7428  moveq #$28, d2
        moveq #40, d2
L029_0000072A:
; H029+$0000072A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L029_0000072C:
; H029+$0000072C: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L029_00000732:
; H029+$00000732: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000734:
; H029+$00000734: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000736:
; H029+$00000736: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L029_0000073A:
; H029+$0000073A: 7428  moveq #$28, d2
        moveq #40, d2
L029_0000073C:
; H029+$0000073C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L029_0000073E:
; H029+$0000073E: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L029_00000744:
; H029+$00000744: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000746:
; H029+$00000746: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_0000074A:
; H029+$0000074A: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L029_0000074C:
; H029+$0000074C: 7414  moveq #$14, d2
        moveq #20, d2
L029_0000074E:
; H029+$0000074E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L029_00000750:
; H029+$00000750: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L029_00000756:
; H029+$00000756: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_0000075A:
; H029+$0000075A: 4293  clr.l (a3)
        clr.l (a3)
L029_0000075C:
; H029+$0000075C: 4e5d  unlk a5
        unlk a5
L029_0000075E:
; H029+$0000075E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000760:
; H029+$00000760: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000762:
; H029+$00000762: 588f  addq.l #$4, a7
        addq.l #$4, a7
L029_00000764:
; H029+$00000764: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00000766 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H016+$0084, H016+$0014.
;   - Calls H016+$0084.
;   - Calls H016+$0014.
; Direct callers: H042+$0D2E, H029+$09FE, H029+$1008, H042+$0A48, H066+$121C, H066+$123A
; --------------------------------------------------------------------------
L029_00000766:
; H029+$00000766: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000768:
; H029+$00000768: 287af9aa  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000076C:
; H029+$0000076C: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L029_00000770:
; H029+$00000770: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L029_00000774:
; H029+$00000774: 342b0008  move.w $8(a3), d2
        move.w $8(a3), d2
L029_00000778:
; H029+$00000778: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_0000077A:
; H029+$0000077A: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L029_0000077E:
; H029+$0000077E: c4eb0002  mulu.w $2(a3), d2
        mulu.w $2(a3), d2
L029_00000782:
; H029+$00000782: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L029_00000786:
; H029+$00000786: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000788:
; H029+$00000788: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L029_0000078C:
; H029+$0000078C: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_00000790:
; H029+$00000790: 4a42  tst.w d2
        tst.w d2
L029_00000792:
; H029+$00000792: 63000014  bls.w $7a8
        bls.w H029+$7A8
L029_00000796:
; H029+$00000796: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000798:
; H029+$00000798: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L029_0000079C:
; H029+$0000079C: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_000007A0:
; H029+$000007A0: 7810  moveq #$10, d4
        moveq #16, d4
L029_000007A2:
; H029+$000007A2: 9842  sub.w d2, d4
        sub.w d2, d4
L029_000007A4:
; H029+$000007A4: d96dfffc  add.w d4, -$4(a5)
        add.w d4, -$4(a5)
L029_000007A8:
; H029+$000007A8: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L029_000007AC:
; H029+$000007AC: 7400  moveq #$0, d2
        moveq #0, d2
L029_000007AE:
; H029+$000007AE: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L029_000007B2:
; H029+$000007B2: 4a42  tst.w d2
        tst.w d2
L029_000007B4:
; H029+$000007B4: 67000104  beq.w $8ba
        beq.w H029+$8BA
L029_000007B8:
; H029+$000007B8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000007BA:
; H029+$000007BA: 246b000c  movea.l $c(a3), a2
        movea.l $c(a3), a2
L029_000007BE:
; H029+$000007BE: 2f2a0008  move.l $8(a2), -(a7)
        move.l $8(a2), -(a7)
L029_000007C2:
; H029+$000007C2: 7400  moveq #$0, d2
        moveq #0, d2
L029_000007C4:
; H029+$000007C4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L029_000007C8:
; H029+$000007C8: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L029_000007CA:
; H029+$000007CA: c4d3  mulu.w (a3), d2
        mulu.w (a3), d2
L029_000007CC:
; H029+$000007CC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_000007CE:
; H029+$000007CE: 2f3c00000001  move.l #$1, -(a7)
        move.l #$1, -(a7)
; -> H016+$0084 (wrapper_BltClear)
L029_000007D4:
; H029+$000007D4: 4eb900000084  jsr $84.l
        jsr (H016+$84).l
L029_000007DA:
; H029+$000007DA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_000007DC:
; H029+$000007DC: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L029_000007E0:
; H029+$000007E0: 0c6d0004fff8  cmpi.w #$4, -$8(a5)
        cmpi.w #$4, -$8(a5)
L029_000007E6:
; H029+$000007E6: 6200008e  bhi.w $876
        bhi.w H029+$876
L029_000007EA:
; H029+$000007EA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000007EC:
; H029+$000007EC: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L029_000007F0:
; H029+$000007F0: 7401  moveq #$1, d2
        moveq #1, d2
L029_000007F2:
; H029+$000007F2: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L029_000007F6:
; H029+$000007F6: 4a44  tst.w d4
        tst.w d4
L029_000007F8:
; H029+$000007F8: 6a06  bpl.b $800
        bpl.b H029+$800
L029_000007FA:
; H029+$000007FA: 4444  neg.w d4
        neg.w d4
L029_000007FC:
; H029+$000007FC: e86a  lsr.w d4, d2
        lsr.w d4, d2
L029_000007FE:
; H029+$000007FE: 6002  bra.b $802
        bra.b H029+$802
L029_00000800:
; H029+$00000800: e96a  lsl.w d4, d2
        lsl.w d4, d2
L029_00000802:
; H029+$00000802: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000804:
; H029+$00000804: 6100fb4e  bsr.w $354
        bsr.w H029+$354
L029_00000808:
; H029+$00000808: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_0000080A:
; H029+$0000080A: 1400  move.b d0, d2
        move.b d0, d2
L029_0000080C:
; H029+$0000080C: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L029_00000810:
; H029+$00000810: 4a42  tst.w d2
        tst.w d2
L029_00000812:
; H029+$00000812: 6700000c  beq.w $820
        beq.w H029+$820
L029_00000816:
; H029+$00000816: 3b7c00b0fffa  move.w #$b0, -$6(a5)
        move.w #$b0, -$6(a5)
L029_0000081C:
; H029+$0000081C: 60000008  bra.w $826
        bra.w H029+$826
L029_00000820:
; H029+$00000820: 3b7c00e0fffa  move.w #$e0, -$6(a5)
        move.w #$e0, -$6(a5)
L029_00000826:
; H029+$00000826: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000828:
; H029+$00000828: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L029_0000082C:
; H029+$0000082C: 4267  clr.w -(a7)
        clr.w -(a7)
L029_0000082E:
; H029+$0000082E: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000830:
; H029+$00000830: 2f2b000c  move.l $c(a3), -(a7)
        move.l $c(a3), -(a7)
L029_00000834:
; H029+$00000834: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000836:
; H029+$00000836: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000838:
; H029+$00000838: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_0000083C:
; H029+$0000083C: c4eb0008  mulu.w $8(a3), d2
        mulu.w $8(a3), d2
L029_00000840:
; H029+$00000840: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000842:
; H029+$00000842: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000844:
; H029+$00000844: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L029_00000846:
; H029+$00000846: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_0000084A:
; H029+$0000084A: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L029_0000084C:
; H029+$0000084C: 7401  moveq #$1, d2
        moveq #1, d2
L029_0000084E:
; H029+$0000084E: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L029_00000852:
; H029+$00000852: 4a44  tst.w d4
        tst.w d4
L029_00000854:
; H029+$00000854: 6a06  bpl.b $85c
        bpl.b H029+$85C
L029_00000856:
; H029+$00000856: 4444  neg.w d4
        neg.w d4
L029_00000858:
; H029+$00000858: e86a  lsr.w d4, d2
        lsr.w d4, d2
L029_0000085A:
; H029+$0000085A: 6002  bra.b $85e
        bra.b H029+$85E
L029_0000085C:
; H029+$0000085C: e96a  lsl.w d4, d2
        lsl.w d4, d2
L029_0000085E:
; H029+$0000085E: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L029_00000860:
; H029+$00000860: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00000862:
; H029+$00000862: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_00000868:
; H029+$00000868: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_0000086A:
; H029+$0000086A: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L029_0000086E:
; H029+$0000086E: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L029_00000872:
; H029+$00000872: 6400ff6c  bcc.w $7e0
        bcc.w H029+$7E0
L029_00000876:
; H029+$00000876: 0c6b00030002  cmpi.w #$3, $2(a3)
        cmpi.w #$3, $2(a3)
L029_0000087C:
; H029+$0000087C: 64000038  bcc.w $8b6
        bcc.w H029+$8B6
L029_00000880:
; H029+$00000880: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000882:
; H029+$00000882: 2f2b000c  move.l $c(a3), -(a7)
        move.l $c(a3), -(a7)
L029_00000886:
; H029+$00000886: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000888:
; H029+$00000888: 4267  clr.w -(a7)
        clr.w -(a7)
L029_0000088A:
; H029+$0000088A: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L029_0000088E:
; H029+$0000088E: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000890:
; H029+$00000890: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000892:
; H029+$00000892: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_00000896:
; H029+$00000896: c4eb0008  mulu.w $8(a3), d2
        mulu.w $8(a3), d2
L029_0000089A:
; H029+$0000089A: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_0000089C:
; H029+$0000089C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_0000089E:
; H029+$0000089E: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L029_000008A0:
; H029+$000008A0: 1f3c0080  move.b #$80, -(a7)
        move.b #$80, -(a7)
L029_000008A4:
; H029+$000008A4: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_000008A8:
; H029+$000008A8: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_000008AA:
; H029+$000008AA: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_000008B0:
; H029+$000008B0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_000008B2:
; H029+$000008B2: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L029_000008B6:
; H029+$000008B6: 6000005c  bra.w $914
        bra.w H029+$914
L029_000008BA:
; H029+$000008BA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000008BC:
; H029+$000008BC: 246b000c  movea.l $c(a3), a2
        movea.l $c(a3), a2
L029_000008C0:
; H029+$000008C0: 2f2a0008  move.l $8(a2), -(a7)
        move.l $8(a2), -(a7)
L029_000008C4:
; H029+$000008C4: 7400  moveq #$0, d2
        moveq #0, d2
L029_000008C6:
; H029+$000008C6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L029_000008CA:
; H029+$000008CA: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L029_000008CC:
; H029+$000008CC: c4d3  mulu.w (a3), d2
        mulu.w (a3), d2
L029_000008CE:
; H029+$000008CE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_000008D0:
; H029+$000008D0: 2f3c00000001  move.l #$1, -(a7)
        move.l #$1, -(a7)
; -> H016+$0084 (wrapper_BltClear)
L029_000008D6:
; H029+$000008D6: 4eb900000084  jsr $84.l
        jsr (H016+$84).l
L029_000008DC:
; H029+$000008DC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_000008DE:
; H029+$000008DE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000008E0:
; H029+$000008E0: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L029_000008E4:
; H029+$000008E4: 4267  clr.w -(a7)
        clr.w -(a7)
L029_000008E6:
; H029+$000008E6: 4267  clr.w -(a7)
        clr.w -(a7)
L029_000008E8:
; H029+$000008E8: 2f2b000c  move.l $c(a3), -(a7)
        move.l $c(a3), -(a7)
L029_000008EC:
; H029+$000008EC: 4267  clr.w -(a7)
        clr.w -(a7)
L029_000008EE:
; H029+$000008EE: 4267  clr.w -(a7)
        clr.w -(a7)
L029_000008F0:
; H029+$000008F0: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_000008F4:
; H029+$000008F4: c4eb0008  mulu.w $8(a3), d2
        mulu.w $8(a3), d2
L029_000008F8:
; H029+$000008F8: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_000008FA:
; H029+$000008FA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_000008FC:
; H029+$000008FC: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L029_000008FE:
; H029+$000008FE: 1f3c00e0  move.b #$e0, -(a7)
        move.b #$e0, -(a7)
L029_00000902:
; H029+$00000902: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_00000906:
; H029+$00000906: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00000908:
; H029+$00000908: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_0000090E:
; H029+$0000090E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000910:
; H029+$00000910: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L029_00000914:
; H029+$00000914: 4e5d  unlk a5
        unlk a5
L029_00000916:
; H029+$00000916: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000918:
; H029+$00000918: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_0000091A:
; H029+$0000091A: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L029_0000091C:
; H029+$0000091C: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Populate_GraphicPlanes [verified]
; Purpose: Copies graphic planes from a buffer into the record already allocated.
;   - Computes the space of one plane from the geometry with 16-pixel alignment.
;   - Copies the planes into the Planes vector of the bitmap at +$10 of the record.
;   - If the mask bitmap exists it calls the path that prepares it.
; Direct callers: H029+$0B72, H042+$08AA, H042+$09F2, H042+$0CD4
; --------------------------------------------------------------------------
L029_0000091E:
; H029+$0000091E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000920:
; H029+$00000920: 287af7f2  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000924:
; H029+$00000924: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L029_00000928:
; H029+$00000928: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_0000092C:
; H029+$0000092C: 4a93  tst.l (a3)
        tst.l (a3)
L029_0000092E:
; H029+$0000092E: 66000016  bne.w $946
        bne.w H029+$946
L029_00000932:
; H029+$00000932: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L029_00000936:
; H029+$00000936: 486c005c  pea.l $5c(a4)
        pea.l $5c(a4)
L029_0000093A:
; H029+$0000093A: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H014+$0018 (sub_H014_00000018)
L029_0000093C:
; H029+$0000093C: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L029_00000942:
; H029+$00000942: 600000be  bra.w $a02
        bra.w H029+$A02
L029_00000946:
; H029+$00000946: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_0000094A:
; H029+$0000094A: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_0000094C:
; H029+$0000094C: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_00000950:
; H029+$00000950: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000952:
; H029+$00000952: c4eb0008  mulu.w $8(a3), d2
        mulu.w $8(a3), d2
L029_00000956:
; H029+$00000956: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L029_0000095A:
; H029+$0000095A: 7400  moveq #$0, d2
        moveq #0, d2
L029_0000095C:
; H029+$0000095C: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L029_00000960:
; H029+$00000960: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_00000964:
; H029+$00000964: 4a42  tst.w d2
        tst.w d2
L029_00000966:
; H029+$00000966: 63000014  bls.w $97c
        bls.w H029+$97C
L029_0000096A:
; H029+$0000096A: 7400  moveq #$0, d2
        moveq #0, d2
L029_0000096C:
; H029+$0000096C: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L029_00000970:
; H029+$00000970: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L029_00000974:
; H029+$00000974: 7810  moveq #$10, d4
        moveq #16, d4
L029_00000976:
; H029+$00000976: 9842  sub.w d2, d4
        sub.w d2, d4
L029_00000978:
; H029+$00000978: d96dfff8  add.w d4, -$8(a5)
        add.w d4, -$8(a5)
L029_0000097C:
; H029+$0000097C: 3413  move.w (a3), d2
        move.w (a3), d2
L029_0000097E:
; H029+$0000097E: c4edfff8  mulu.w -$8(a5), d2
        mulu.w -$8(a5), d2
L029_00000982:
; H029+$00000982: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L029_00000984:
; H029+$00000984: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L029_00000988:
; H029+$00000988: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L029_0000098C:
; H029+$0000098C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L029_00000990:
; H029+$00000990: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L029_00000994:
; H029+$00000994: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L029_00000996:
; H029+$00000996: 6200004a  bhi.w $9e2
        bhi.w H029+$9E2
L029_0000099A:
; H029+$0000099A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_0000099E:
; H029+$0000099E: c4edfffe  mulu.w -$2(a5), d2
        mulu.w -$2(a5), d2
L029_000009A2:
; H029+$000009A2: d46d0014  add.w $14(a5), d2
        add.w $14(a5), d2
L029_000009A6:
; H029+$000009A6: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L029_000009AA:
; H029+$000009AA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000009AC:
; H029+$000009AC: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L029_000009B0:
; H029+$000009B0: 246d0016  movea.l $16(a5), a2
        movea.l $16(a5), a2
L029_000009B4:
; H029+$000009B4: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L029_000009B8:
; H029+$000009B8: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L029_000009BA:
; H029+$000009BA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L029_000009BE:
; H029+$000009BE: e542  asl.w #$2, d2
        asl.w #$2, d2
L029_000009C0:
; H029+$000009C0: 246b0010  movea.l $10(a3), a2
        movea.l $10(a3), a2
L029_000009C4:
; H029+$000009C4: 45ea0008  lea.l $8(a2), a2
        lea.l $8(a2), a2
L029_000009C8:
; H029+$000009C8: 2f322000  move.l (a2, d2.w), -(a7)
        move.l (a2, d2.w), -(a7)
L029_000009CC:
; H029+$000009CC: 7400  moveq #$0, d2
        moveq #0, d2
L029_000009CE:
; H029+$000009CE: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L029_000009D2:
; H029+$000009D2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L029_000009D4:
; H029+$000009D4: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L029_000009DA:
; H029+$000009DA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_000009DC:
; H029+$000009DC: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L029_000009E0:
; H029+$000009E0: 64ae  bcc.b $990
        bcc.b H029+$990
L029_000009E2:
; H029+$000009E2: 548f  addq.l #$2, a7
        addq.l #$2, a7
L029_000009E4:
; H029+$000009E4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_000009E8:
; H029+$000009E8: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_000009EA:
; H029+$000009EA: 4aab000c  tst.l $c(a3)
        tst.l $c(a3)
L029_000009EE:
; H029+$000009EE: 67000012  beq.w $a02
        beq.w H029+$A02
L029_000009F2:
; H029+$000009F2: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_000009F6:
; H029+$000009F6: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_000009F8:
; H029+$000009F8: 4853  pea.l (a3)
        pea.l (a3)
L029_000009FA:
; H029+$000009FA: 1f2d0010  move.b $10(a5), -(a7)
        move.b $10(a5), -(a7)
L029_000009FE:
; H029+$000009FE: 6100fd66  bsr.w $766
        bsr.w H029+$766
L029_00000A02:
; H029+$00000A02: 4e5d  unlk a5
        unlk a5
L029_00000A04:
; H029+$00000A04: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000A06:
; H029+$00000A06: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000A08:
; H029+$00000A08: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L029_00000A0C:
; H029+$00000A0C: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Load_IndexedGraphicRecord [verified]
; Purpose: Loads a graphic record from a .daa container.
;   - Discards the previous destination record if present.
;   - Passes name/ID to DAX_LoadBlock specifying the .daa extension.
;   - Reads the small graphic header, creates the record/bitmap and transfers the planes.
;   - Frees the temporary buffer after the copy.
;   - The native DAA variants are not all described by the Python decoder yet.
; Direct callers: H006+$0120, H006+$07BE, H006+$07DC, H006+$07FC, H034+$00D0, H035+$00CC, H035+$0308, H035+$0338, H035+$03A0, H035+$040E ...
; --------------------------------------------------------------------------
L029_00000A0E:
; H029+$00000A0E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000A10:
; H029+$00000A10: 287af702  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000A14:
; H029+$00000A14: 4e55ff98  link.w a5, #$ff98
        link.w a5, #$ff98
L029_00000A18:
; H029+$00000A18: 342d001a  move.w $1a(a5), d2
        move.w $1a(a5), d2
L029_00000A1C:
; H029+$00000A1C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L029_00000A1E:
; H029+$00000A1E: 08020000  btst.b #$0, d2
        btst #$0, d2
L029_00000A22:
; H029+$00000A22: 6702  beq.b $a26
        beq.b H029+$A26
L029_00000A24:
; H029+$00000A24: 5242  addq.w #$1, d2
        addq.w #$1, d2
L029_00000A26:
; H029+$00000A26: 9ec2  suba.w d2, a7
        suba.w d2, a7
L029_00000A28:
; H029+$00000A28: 266d0016  movea.l $16(a5), a3
        movea.l $16(a5), a3
L029_00000A2C:
; H029+$00000A2C: 2b4f0016  move.l a7, $16(a5)
        move.l a7, $16(a5)
L029_00000A30:
; H029+$00000A30: 244f  movea.l a7, a2
        movea.l a7, a2
L029_00000A32:
; H029+$00000A32: 5342  subq.w #$1, d2
        subq.w #$1, d2
L029_00000A34:
; H029+$00000A34: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L029_00000A36:
; H029+$00000A36: 51cafffc  dbra d2, $a34
        dbra d2, H029+$A34
L029_00000A3A:
; H029+$00000A3A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_00000A3E:
; H029+$00000A3E: 4a93  tst.l (a3)
        tst.l (a3)
L029_00000A40:
; H029+$00000A40: 6700000a  beq.w $a4c
        beq.w H029+$A4C
L029_00000A44:
; H029+$00000A44: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L029_00000A48:
; H029+$00000A48: 6100fc30  bsr.w $67a
        bsr.w H029+$67A
L029_00000A4C:
; H029+$00000A4C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L029_00000A50:
; H029+$00000A50: 486dffa4  pea.l -$5c(a5)
        pea.l -$5c(a5)
L029_00000A54:
; H029+$00000A54: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L029_00000A58:
; H029+$00000A58: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L029_00000A5C:
; H029+$00000A5C: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000A5E:
; H029+$00000A5E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; -> H026+$0452 (sub_H026_00000452)
L029_00000A62:
; H029+$00000A62: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L029_00000A68:
; H029+$00000A68: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L029_00000A6C:
; H029+$00000A6C: 486dffa4  pea.l -$5c(a5)
        pea.l -$5c(a5)
L029_00000A70:
; H029+$00000A70: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L029_00000A74:
; H029+$00000A74: 486c0068  pea.l $68(a4)
        pea.l $68(a4)
; -> H026+$0106 (sub_H026_00000106)
L029_00000A78:
; H029+$00000A78: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L029_00000A7E:
; H029+$00000A7E: 1400  move.b d0, d2
        move.b d0, d2
L029_00000A80:
; H029+$00000A80: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L029_00000A84:
; H029+$00000A84: 66000012  bne.w $a98
        bne.w H029+$A98
L029_00000A88:
; H029+$00000A88: 3b7c0003ff9e  move.w #$3, -$62(a5)
        move.w #$3, -$62(a5)
L029_00000A8E:
; H029+$00000A8E: 3b7c0009ffa0  move.w #$9, -$60(a5)
        move.w #$9, -$60(a5)
L029_00000A94:
; H029+$00000A94: 6000000e  bra.w $aa4
        bra.w H029+$AA4
L029_00000A98:
; H029+$00000A98: 3b7c0004ff9e  move.w #$4, -$62(a5)
        move.w #$4, -$62(a5)
L029_00000A9E:
; H029+$00000A9E: 3b7c0049ffa0  move.w #$49, -$60(a5)
        move.w #$49, -$60(a5)
L029_00000AA4:
; H029+$00000AA4: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L029_00000AA8:
; H029+$00000AA8: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L029_00000AAC:
; H029+$00000AAC: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L029_00000AB0:
; H029+$00000AB0: 486c006c  pea.l $6c(a4)
        pea.l $6c(a4)
L029_00000AB4:
; H029+$00000AB4: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L029_00000AB8:
; H029+$00000AB8: 486dffa2  pea.l -$5e(a5)
        pea.l -$5e(a5)
L029_00000ABC:
; H029+$00000ABC: 486dff9a  pea.l -$66(a5)
        pea.l -$66(a5)
; STEP: Loads the ID from the .daa container through the block loader.
; FLOW: Calls DAX_LoadBlock (H028+$0DD8).
L029_00000AC0:
; H029+$00000AC0: 4eb900000dd8  jsr $dd8.l
        jsr (FN_DAX_load_block).l
L029_00000AC6:
; H029+$00000AC6: 4a6dffa2  tst.w -$5e(a5)
        tst.w -$5e(a5)
L029_00000ACA:
; H029+$00000ACA: 66000028  bne.w $af4
        bne.w H029+$AF4
L029_00000ACE:
; H029+$00000ACE: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L029_00000AD2:
; H029+$00000AD2: 486c0071  pea.l $71(a4)
        pea.l $71(a4)
L029_00000AD6:
; H029+$00000AD6: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H014+$0018 (sub_H014_00000018)
L029_00000AD8:
; H029+$00000AD8: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L029_00000ADE:
; H029+$00000ADE: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L029_00000AE2:
; H029+$00000AE2: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L029_00000AE6:
; H029+$00000AE6: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
; -> H014+$0018 (sub_H014_00000018)
L029_00000AEA:
; H029+$00000AEA: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L029_00000AF0:
; H029+$00000AF0: 60000096  bra.w $b88
        bra.w H029+$B88
L029_00000AF4:
; H029+$00000AF4: 266dff9a  movea.l -$66(a5), a3
        movea.l -$66(a5), a3
L029_00000AF8:
; H029+$00000AF8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000AFA:
; H029+$00000AFA: 47edfff6  lea.l -$a(a5), a3
        lea.l -$a(a5), a3
L029_00000AFE:
; H029+$00000AFE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000B00:
; H029+$00000B00: 7409  moveq #$9, d2
        moveq #9, d2
L029_00000B02:
; H029+$00000B02: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L029_00000B04:
; H029+$00000B04: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L029_00000B0A:
; H029+$00000B0A: 0c6d0004ff9e  cmpi.w #$4, -$62(a5)
        cmpi.w #$4, -$62(a5)
L029_00000B10:
; H029+$00000B10: 6600001e  bne.w $b30
        bne.w H029+$B30
L029_00000B14:
; H029+$00000B14: 266dff9a  movea.l -$66(a5), a3
        movea.l -$66(a5), a3
L029_00000B18:
; H029+$00000B18: 47eb0009  lea.l $9(a3), a3
        lea.l $9(a3), a3
L029_00000B1C:
; H029+$00000B1C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000B1E:
; H029+$00000B1E: 47f90000522e  lea.l $522e.l, a3
        lea.l (H005+$522E).l, a3
L029_00000B24:
; H029+$00000B24: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000B26:
; H029+$00000B26: 7440  moveq #$40, d2
        moveq #64, d2
L029_00000B28:
; H029+$00000B28: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L029_00000B2A:
; H029+$00000B2A: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L029_00000B30:
; H029+$00000B30: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L029_00000B34:
; H029+$00000B34: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L029_00000B38:
; H029+$00000B38: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000B3A:
; H029+$00000B3A: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L029_00000B3E:
; H029+$00000B3E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000B40:
; H029+$00000B40: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L029_00000B44:
; H029+$00000B44: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; STEP: Allocates the graphic structure after reading the small header of the block.
; FLOW: Calls Allocate_GraphicRecord (H029+$0408).
L029_00000B48:
; H029+$00000B48: 6100f8be  bsr.w $408
        bsr.w H029+$408
L029_00000B4C:
; H029+$00000B4C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000B50:
; H029+$00000B50: 2652  movea.l (a2), a3
        movea.l (a2), a3
L029_00000B52:
; H029+$00000B52: 376dfffa0004  move.w -$6(a5), $4(a3)
        move.w -$6(a5), $4(a3)
L029_00000B58:
; H029+$00000B58: 376dfffc0004  move.w -$4(a5), $4(a3)
        move.w -$4(a5), $4(a3)
L029_00000B5E:
; H029+$00000B5E: 2f2dff9a  move.l -$66(a5), -(a7)
        move.l -$66(a5), -(a7)
L029_00000B62:
; H029+$00000B62: 3f2dffa0  move.w -$60(a5), -(a7)
        move.w -$60(a5), -(a7)
L029_00000B66:
; H029+$00000B66: 3f2dff9e  move.w -$62(a5), -(a7)
        move.w -$62(a5), -(a7)
L029_00000B6A:
; H029+$00000B6A: 1f2d0010  move.b $10(a5), -(a7)
        move.b $10(a5), -(a7)
L029_00000B6E:
; H029+$00000B6E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; STEP: Copies the decompressed planes into the final record/bitmap.
; FLOW: Calls Populate_GraphicPlanes (H029+$091E).
L029_00000B72:
; H029+$00000B72: 6100fdaa  bsr.w $91e
        bsr.w H029+$91E
L029_00000B76:
; H029+$00000B76: 2f2dff9a  move.l -$66(a5), -(a7)
        move.l -$66(a5), -(a7)
L029_00000B7A:
; H029+$00000B7A: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000B7C:
; H029+$00000B7C: 342dffa2  move.w -$5e(a5), d2
        move.w -$5e(a5), d2
L029_00000B80:
; H029+$00000B80: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L029_00000B82:
; H029+$00000B82: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L029_00000B88:
; H029+$00000B88: 4e5d  unlk a5
        unlk a5
L029_00000B8A:
; H029+$00000B8A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000B8C:
; H029+$00000B8C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000B8E:
; H029+$00000B8E: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L029_00000B92:
; H029+$00000B92: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Draw_GraphicTile24 [verified]
; Purpose: Draws a 24x24-pixel box/tile from the graphic record.
;   - Chooses the destination bitmap and the vertical offset of the context.
;   - With a mask it prepares a masked blit; the queued branch uses H049+$04AE.
;   - The other branches call BltMaskBitMapRastPort or BltBitMap.
;   - Uses different minterms for the paths with and without a mask.
; Direct callers: H029+$0DF8, H029+$0E16, H035+$01CC, H063+$2622
; --------------------------------------------------------------------------
L029_00000B94:
; H029+$00000B94: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000B96:
; H029+$00000B96: 287af57c  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000B9A:
; H029+$00000B9A: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L029_00000B9E:
; H029+$00000B9E: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000BA0:
; H029+$00000BA0: 142d0016  move.b $16(a5), d2
        move.b $16(a5), d2
L029_00000BA4:
; H029+$00000BA4: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L029_00000BA8:
; H029+$00000BA8: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
; STATE: H005+$3DE3 = native context, 5 in combat
L029_00000BAC:
; H029+$00000BAC: 4a3900003de3  tst.b $3de3.l
        tst.b (H005+$3DE3).l
L029_00000BB2:
; H029+$00000BB2: 6600000a  bne.w $bbe
        bne.w H029+$BBE
L029_00000BB6:
; H029+$00000BB6: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L029_00000BBA:
; H029+$00000BBA: 60000008  bra.w $bc4
        bra.w H029+$BC4
L029_00000BBE:
; H029+$00000BBE: 3b7c0008fffe  move.w #$8, -$2(a5)
        move.w #$8, -$2(a5)
L029_00000BC4:
; H029+$00000BC4: 4a2cfffb  tst.b -$5(a4)
        tst.b -$5(a4)
L029_00000BC8:
; H029+$00000BC8: 6700000c  beq.w $bd6
        beq.w H029+$BD6
L029_00000BCC:
; H029+$00000BCC: 2b6cfffcfff2  move.l -$4(a4), -$e(a5)
        move.l -$4(a4), -$e(a5)
L029_00000BD2:
; H029+$00000BD2: 60000016  bra.w $bea
        bra.w H029+$BEA
; STATE: H005+$52F2 = pointer to the game screen
L029_00000BD6:
; H029+$00000BD6: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L029_00000BDC:
; H029+$00000BDC: 47eb0054  lea.l $54(a3), a3
        lea.l $54(a3), a3
L029_00000BE0:
; H029+$00000BE0: 2b4bfff2  move.l a3, -$e(a5)
        move.l a3, -$e(a5)
L029_00000BE4:
; H029+$00000BE4: 197c0001fff7  move.b #$1, -$9(a4)
        move.b #$1, -$9(a4)
L029_00000BEA:
; H029+$00000BEA: 4a2cfffa  tst.b -$6(a4)
        tst.b -$6(a4)
L029_00000BEE:
; H029+$00000BEE: 670000ae  beq.w $c9e
        beq.w H029+$C9E
L029_00000BF2:
; H029+$00000BF2: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000BF4:
; H029+$00000BF4: 142d0014  move.b $14(a5), d2
        move.b $14(a5), d2
L029_00000BF8:
; H029+$00000BF8: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L029_00000BFC:
; H029+$00000BFC: 6600005a  bne.w $c58
        bne.w H029+$C58
L029_00000C00:
; H029+$00000C00: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L029_00000C04:
; H029+$00000C04: 4aab000c  tst.l $c(a3)
        tst.l $c(a3)
L029_00000C08:
; H029+$00000C08: 6700004e  beq.w $c58
        beq.w H029+$C58
L029_00000C0C:
; H029+$00000C0C: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L029_00000C10:
; H029+$00000C10: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L029_00000C14:
; H029+$00000C14: 4853  pea.l (a3)
        pea.l (a3)
L029_00000C16:
; H029+$00000C16: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_00000C1A:
; H029+$00000C1A: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000C1C:
; H029+$00000C1C: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L029_00000C20:
; H029+$00000C20: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000C22:
; H029+$00000C22: 342d001a  move.w $1a(a5), d2
        move.w $1a(a5), d2
L029_00000C26:
; H029+$00000C26: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000C2A:
; H029+$00000C2A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000C2C:
; H029+$00000C2C: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L029_00000C30:
; H029+$00000C30: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000C34:
; H029+$00000C34: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000C36:
; H029+$00000C36: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000C3A:
; H029+$00000C3A: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000C3E:
; H029+$00000C3E: 1f3c00ca  move.b #$ca, -(a7)
        move.b #$ca, -(a7)
L029_00000C42:
; H029+$00000C42: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L029_00000C46:
; H029+$00000C46: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L029_00000C4A:
; H029+$00000C4A: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
; FLOW: Calls Queue_BitplaneBlit (H049+$04AE).
L029_00000C4E:
; H029+$00000C4E: 4eb9000004ae  jsr $4ae.l
        jsr (H049+$4AE).l
L029_00000C54:
; H029+$00000C54: 60000044  bra.w $c9a
        bra.w H029+$C9A
L029_00000C58:
; H029+$00000C58: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L029_00000C5C:
; H029+$00000C5C: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L029_00000C60:
; H029+$00000C60: 4853  pea.l (a3)
        pea.l (a3)
L029_00000C62:
; H029+$00000C62: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_00000C66:
; H029+$00000C66: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000C68:
; H029+$00000C68: 246dfff2  movea.l -$e(a5), a2
        movea.l -$e(a5), a2
L029_00000C6C:
; H029+$00000C6C: 266a0004  movea.l $4(a2), a3
        movea.l $4(a2), a3
L029_00000C70:
; H029+$00000C70: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000C72:
; H029+$00000C72: 342d001a  move.w $1a(a5), d2
        move.w $1a(a5), d2
L029_00000C76:
; H029+$00000C76: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000C7A:
; H029+$00000C7A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000C7C:
; H029+$00000C7C: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L029_00000C80:
; H029+$00000C80: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000C84:
; H029+$00000C84: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000C86:
; H029+$00000C86: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000C8A:
; H029+$00000C8A: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000C8E:
; H029+$00000C8E: 1f3c00ca  move.b #$ca, -(a7)
        move.b #$ca, -(a7)
L029_00000C92:
; H029+$00000C92: 42a7  clr.l -(a7)
        clr.l -(a7)
; FLOW: Calls Queue_BitplaneBlit (H049+$04AE).
L029_00000C94:
; H029+$00000C94: 4eb9000004ae  jsr $4ae.l
        jsr (H049+$4AE).l
L029_00000C9A:
; H029+$00000C9A: 600000b0  bra.w $d4c
        bra.w H029+$D4C
L029_00000C9E:
; H029+$00000C9E: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000CA0:
; H029+$00000CA0: 142d0014  move.b $14(a5), d2
        move.b $14(a5), d2
L029_00000CA4:
; H029+$00000CA4: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L029_00000CA8:
; H029+$00000CA8: 66000058  bne.w $d02
        bne.w H029+$D02
L029_00000CAC:
; H029+$00000CAC: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L029_00000CB0:
; H029+$00000CB0: 4aab000c  tst.l $c(a3)
        tst.l $c(a3)
L029_00000CB4:
; H029+$00000CB4: 6700004c  beq.w $d02
        beq.w H029+$D02
L029_00000CB8:
; H029+$00000CB8: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L029_00000CBC:
; H029+$00000CBC: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L029_00000CC0:
; H029+$00000CC0: 4853  pea.l (a3)
        pea.l (a3)
L029_00000CC2:
; H029+$00000CC2: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_00000CC6:
; H029+$00000CC6: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000CC8:
; H029+$00000CC8: 2f2dfff2  move.l -$e(a5), -(a7)
        move.l -$e(a5), -(a7)
L029_00000CCC:
; H029+$00000CCC: 342d001a  move.w $1a(a5), d2
        move.w $1a(a5), d2
L029_00000CD0:
; H029+$00000CD0: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000CD4:
; H029+$00000CD4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000CD6:
; H029+$00000CD6: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L029_00000CDA:
; H029+$00000CDA: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000CDE:
; H029+$00000CDE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000CE0:
; H029+$00000CE0: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000CE4:
; H029+$00000CE4: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000CE8:
; H029+$00000CE8: 1f3c00e0  move.b #$e0, -(a7)
        move.b #$e0, -(a7)
L029_00000CEC:
; H029+$00000CEC: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L029_00000CF0:
; H029+$00000CF0: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L029_00000CF4:
; H029+$00000CF4: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
; -> H016+$00A0 (wrapper_BltMaskBitMapRastPort)
L029_00000CF8:
; H029+$00000CF8: 4eb9000000a0  jsr $a0.l
        jsr (H016+$A0).l
L029_00000CFE:
; H029+$00000CFE: 6000004c  bra.w $d4c
        bra.w H029+$D4C
L029_00000D02:
; H029+$00000D02: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L029_00000D06:
; H029+$00000D06: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L029_00000D0A:
; H029+$00000D0A: 4853  pea.l (a3)
        pea.l (a3)
L029_00000D0C:
; H029+$00000D0C: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L029_00000D10:
; H029+$00000D10: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000D12:
; H029+$00000D12: 246dfff2  movea.l -$e(a5), a2
        movea.l -$e(a5), a2
L029_00000D16:
; H029+$00000D16: 266a0004  movea.l $4(a2), a3
        movea.l $4(a2), a3
L029_00000D1A:
; H029+$00000D1A: 4853  pea.l (a3)
        pea.l (a3)
L029_00000D1C:
; H029+$00000D1C: 342d001a  move.w $1a(a5), d2
        move.w $1a(a5), d2
L029_00000D20:
; H029+$00000D20: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000D24:
; H029+$00000D24: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000D26:
; H029+$00000D26: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L029_00000D2A:
; H029+$00000D2A: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L029_00000D2E:
; H029+$00000D2E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000D30:
; H029+$00000D30: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000D34:
; H029+$00000D34: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000D38:
; H029+$00000D38: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L029_00000D3C:
; H029+$00000D3C: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_00000D40:
; H029+$00000D40: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00000D42:
; H029+$00000D42: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_00000D48:
; H029+$00000D48: 2b40fff6  move.l d0, -$a(a5)
        move.l d0, -$a(a5)
L029_00000D4C:
; H029+$00000D4C: 4e5d  unlk a5
        unlk a5
L029_00000D4E:
; H029+$00000D4E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000D50:
; H029+$00000D50: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000D52:
; H029+$00000D52: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L029_00000D56:
; H029+$00000D56: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00000D58 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H016+$0014.
;   - Calls H016+$0014.
;   - Uses the global state: H005+$52F2 (pointer to the game screen).
; Direct callers: H063+$290A, H063+$293A, H048+$1534
; --------------------------------------------------------------------------
L029_00000D58:
; H029+$00000D58: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000D5A:
; H029+$00000D5A: 287af3b8  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000D5E:
; H029+$00000D5E: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L029_00000D62:
; H029+$00000D62: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000D64:
; H029+$00000D64: 142d0014  move.b $14(a5), d2
        move.b $14(a5), d2
L029_00000D68:
; H029+$00000D68: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L029_00000D6C:
; H029+$00000D6C: 66000092  bne.w $e00
        bne.w H029+$E00
L029_00000D70:
; H029+$00000D70: 4a2cfffb  tst.b -$5(a4)
        tst.b -$5(a4)
L029_00000D74:
; H029+$00000D74: 67000012  beq.w $d88
        beq.w H029+$D88
L029_00000D78:
; H029+$00000D78: 267900003d8e  movea.l $3d8e.l, a3
        movea.l (H005+$3D8E).l, a3
L029_00000D7E:
; H029+$00000D7E: 2b6b0010fff8  move.l $10(a3), -$8(a5)
        move.l $10(a3), -$8(a5)
L029_00000D84:
; H029+$00000D84: 60000010  bra.w $d96
        bra.w H029+$D96
; STATE: H005+$52F2 = pointer to the game screen
L029_00000D88:
; H029+$00000D88: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L029_00000D8E:
; H029+$00000D8E: 47eb00b8  lea.l $b8(a3), a3
        lea.l $b8(a3), a3
L029_00000D92:
; H029+$00000D92: 2b4bfff8  move.l a3, -$8(a5)
        move.l a3, -$8(a5)
L029_00000D96:
; H029+$00000D96: 3b7c0008fff6  move.w #$8, -$a(a5)
        move.w #$8, -$a(a5)
L029_00000D9C:
; H029+$00000D9C: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L029_00000DA0:
; H029+$00000DA0: 342d001a  move.w $1a(a5), d2
        move.w $1a(a5), d2
L029_00000DA4:
; H029+$00000DA4: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L029_00000DA8:
; H029+$00000DA8: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000DAA:
; H029+$00000DAA: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L029_00000DAE:
; H029+$00000DAE: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L029_00000DB2:
; H029+$00000DB2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000DB4:
; H029+$00000DB4: 247900003d8a  movea.l $3d8a.l, a2
        movea.l (H005+$3D8A).l, a2
L029_00000DBA:
; H029+$00000DBA: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L029_00000DBE:
; H029+$00000DBE: 4853  pea.l (a3)
        pea.l (a3)
L029_00000DC0:
; H029+$00000DC0: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000DC2:
; H029+$00000DC2: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000DC4:
; H029+$00000DC4: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000DC8:
; H029+$00000DC8: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L029_00000DCC:
; H029+$00000DCC: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L029_00000DD0:
; H029+$00000DD0: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_00000DD4:
; H029+$00000DD4: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00000DD6:
; H029+$00000DD6: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_00000DDC:
; H029+$00000DDC: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L029_00000DE0:
; H029+$00000DE0: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L029_00000DE4:
; H029+$00000DE4: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L029_00000DE8:
; H029+$00000DE8: 1f2d0016  move.b $16(a5), -(a7)
        move.b $16(a5), -(a7)
L029_00000DEC:
; H029+$00000DEC: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L029_00000DF0:
; H029+$00000DF0: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L029_00000DF4:
; H029+$00000DF4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; FLOW: Calls Draw_GraphicTile24 (H029+$0B94).
L029_00000DF8:
; H029+$00000DF8: 6100fd9a  bsr.w $b94
        bsr.w H029+$B94
L029_00000DFC:
; H029+$00000DFC: 6000001c  bra.w $e1a
        bra.w H029+$E1A
L029_00000E00:
; H029+$00000E00: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L029_00000E04:
; H029+$00000E04: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L029_00000E08:
; H029+$00000E08: 1f2d0016  move.b $16(a5), -(a7)
        move.b $16(a5), -(a7)
L029_00000E0C:
; H029+$00000E0C: 4227  clr.b -(a7)
        clr.b -(a7)
L029_00000E0E:
; H029+$00000E0E: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L029_00000E12:
; H029+$00000E12: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; FLOW: Calls Draw_GraphicTile24 (H029+$0B94).
L029_00000E16:
; H029+$00000E16: 6100fd7c  bsr.w $b94
        bsr.w H029+$B94
L029_00000E1A:
; H029+$00000E1A: 4e5d  unlk a5
        unlk a5
L029_00000E1C:
; H029+$00000E1C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000E1E:
; H029+$00000E1E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000E20:
; H029+$00000E20: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L029_00000E24:
; H029+$00000E24: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H029_0E88 [partial]
; Purpose: Trampoline to H029+$0E88; the actual body is there.
;   - Jumps to the actual body at H029+$0E88.
; Direct callers: H069+$004A
; --------------------------------------------------------------------------
L029_00000E26:
; H029+$00000E26: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000E28:
; H029+$00000E28: 287af2ea  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000E2C:
; H029+$00000E2C: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L029_00000E30:
; H029+$00000E30: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L029_00000E34:
; H029+$00000E34: 6600000a  bne.w $e40
        bne.w H029+$E40
L029_00000E38:
; H029+$00000E38: 6000004e  bra.w $e88
        bra.w H029+$E88
; Preserved bytes H029+$00000E3C..$00000E40; code/data not fully classified.
        dc.w $6000,$004A
L029_00000E40:
; H029+$00000E40: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_00000E44:
; H029+$00000E44: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; STATE: H005+$52F2 = pointer to the game screen
L029_00000E46:
; H029+$00000E46: 2479000052f2  movea.l $52f2.l, a2
        movea.l (H005+$52F2).l, a2
L029_00000E4C:
; H029+$00000E4C: 486a00b8  pea.l $b8(a2)
        pea.l $b8(a2)
L029_00000E50:
; H029+$00000E50: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L029_00000E54:
; H029+$00000E54: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000E56:
; H029+$00000E56: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000E58:
; H029+$00000E58: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L029_00000E5C:
; H029+$00000E5C: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000E5E:
; H029+$00000E5E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000E60:
; H029+$00000E60: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L029_00000E64:
; H029+$00000E64: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000E66:
; H029+$00000E66: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000E68:
; H029+$00000E68: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_00000E6C:
; H029+$00000E6C: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000E6E:
; H029+$00000E6E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000E70:
; H029+$00000E70: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L029_00000E72:
; H029+$00000E72: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L029_00000E76:
; H029+$00000E76: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_00000E7A:
; H029+$00000E7A: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00000E7C:
; H029+$00000E7C: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_00000E82:
; H029+$00000E82: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000E84:
; H029+$00000E84: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L029_00000E88:
; H029+$00000E88: 4e5d  unlk a5
        unlk a5
L029_00000E8A:
; H029+$00000E8A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000E8C:
; H029+$00000E8C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000E8E:
; H029+$00000E8E: 508f  addq.l #$8, a7
        addq.l #$8, a7
L029_00000E90:
; H029+$00000E90: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H029_0EF4 [partial]
; Purpose: Trampoline to H029+$0EF4; the actual body is there.
;   - Jumps to the actual body at H029+$0EF4.
; Direct callers: H042+$029A, H042+$1122, H069+$00D4
; --------------------------------------------------------------------------
L029_00000E92:
; H029+$00000E92: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000E94:
; H029+$00000E94: 287af27e  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000E98:
; H029+$00000E98: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L029_00000E9C:
; H029+$00000E9C: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L029_00000EA0:
; H029+$00000EA0: 6600000a  bne.w $eac
        bne.w H029+$EAC
L029_00000EA4:
; H029+$00000EA4: 6000004e  bra.w $ef4
        bra.w H029+$EF4
; Preserved bytes H029+$00000EA8..$00000EAC; code/data not fully classified.
        dc.w $6000,$004A
L029_00000EAC:
; H029+$00000EAC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_00000EB0:
; H029+$00000EB0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000EB2:
; H029+$00000EB2: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L029_00000EB6:
; H029+$00000EB6: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000EB8:
; H029+$00000EB8: 4267  clr.w -(a7)
        clr.w -(a7)
; STATE: H005+$52F2 = pointer to the game screen
L029_00000EBA:
; H029+$00000EBA: 2479000052f2  movea.l $52f2.l, a2
        movea.l (H005+$52F2).l, a2
L029_00000EC0:
; H029+$00000EC0: 486a00b8  pea.l $b8(a2)
        pea.l $b8(a2)
L029_00000EC4:
; H029+$00000EC4: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L029_00000EC8:
; H029+$00000EC8: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000ECA:
; H029+$00000ECA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000ECC:
; H029+$00000ECC: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L029_00000ED0:
; H029+$00000ED0: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000ED2:
; H029+$00000ED2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000ED4:
; H029+$00000ED4: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_00000ED8:
; H029+$00000ED8: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000EDA:
; H029+$00000EDA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000EDC:
; H029+$00000EDC: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L029_00000EDE:
; H029+$00000EDE: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L029_00000EE2:
; H029+$00000EE2: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_00000EE6:
; H029+$00000EE6: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00000EE8:
; H029+$00000EE8: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_00000EEE:
; H029+$00000EEE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000EF0:
; H029+$00000EF0: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L029_00000EF4:
; H029+$00000EF4: 4e5d  unlk a5
        unlk a5
L029_00000EF6:
; H029+$00000EF6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00000EF8:
; H029+$00000EF8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00000EFA:
; H029+$00000EFA: 508f  addq.l #$8, a7
        addq.l #$8, a7
L029_00000EFC:
; H029+$00000EFC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H029_10AC [partial]
; Purpose: Trampoline to H029+$10AC; the actual body is there.
;   - Jumps to the actual body at H029+$10AC.
; Direct callers: H035+$03E0, H035+$044E, H066+$106E, H066+$10B0, H066+$12B4, H066+$12F6 and 2 more
; --------------------------------------------------------------------------
L029_00000EFE:
; H029+$00000EFE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00000F00:
; H029+$00000F00: 287af212  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00000F04:
; H029+$00000F04: 4e55ffea  link.w a5, #$ffea
        link.w a5, #$ffea
L029_00000F08:
; H029+$00000F08: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L029_00000F0C:
; H029+$00000F0C: 66000006  bne.w $f14
        bne.w H029+$F14
L029_00000F10:
; H029+$00000F10: 6000019a  bra.w $10ac
        bra.w H029+$10AC
L029_00000F14:
; H029+$00000F14: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L029_00000F18:
; H029+$00000F18: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L029_00000F1C:
; H029+$00000F1C: 6c00001a  bge.w $f38
        bge.w H029+$F38
L029_00000F20:
; H029+$00000F20: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L029_00000F24:
; H029+$00000F24: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_00000F28:
; H029+$00000F28: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000F2A:
; H029+$00000F2A: c4eb0008  mulu.w $8(a3), d2
        mulu.w $8(a3), d2
L029_00000F2E:
; H029+$00000F2E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L029_00000F30:
; H029+$00000F30: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L029_00000F34:
; H029+$00000F34: 6000001e  bra.w $f54
        bra.w H029+$F54
L029_00000F38:
; H029+$00000F38: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_00000F3C:
; H029+$00000F3C: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000F3E:
; H029+$00000F3E: c4ed0010  mulu.w $10(a5), d2
        mulu.w $10(a5), d2
L029_00000F42:
; H029+$00000F42: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L029_00000F46:
; H029+$00000F46: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L029_00000F4A:
; H029+$00000F4A: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00000F4C:
; H029+$00000F4C: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L029_00000F50:
; H029+$00000F50: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L029_00000F54:
; H029+$00000F54: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L029_00000F58:
; H029+$00000F58: 946dfff6  sub.w -$a(a5), d2
        sub.w -$a(a5), d2
L029_00000F5C:
; H029+$00000F5C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L029_00000F5E:
; H029+$00000F5E: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L029_00000F62:
; H029+$00000F62: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000F64:
; H029+$00000F64: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000F68:
; H029+$00000F68: 3f12  move.w (a2), -(a7)
        move.w (a2), -(a7)
L029_00000F6A:
; H029+$00000F6A: 7400  moveq #$0, d2
        moveq #0, d2
L029_00000F6C:
; H029+$00000F6C: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L029_00000F70:
; H029+$00000F70: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L029_00000F72:
; H029+$00000F72: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_00000F74:
; H029+$00000F74: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L029_00000F78:
; H029+$00000F78: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L029_00000F7C:
; H029+$00000F7C: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
; FLOW: Calls Allocate_GraphicRecord (H029+$0408).
L029_00000F80:
; H029+$00000F80: 6100f486  bsr.w $408
        bsr.w H029+$408
L029_00000F84:
; H029+$00000F84: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000F86:
; H029+$00000F86: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000F88:
; H029+$00000F88: 226d000c  movea.l $c(a5), a1
        movea.l $c(a5), a1
L029_00000F8C:
; H029+$00000F8C: 24690010  movea.l $10(a1), a2
        movea.l $10(a1), a2
L029_00000F90:
; H029+$00000F90: 4852  pea.l (a2)
        pea.l (a2)
L029_00000F92:
; H029+$00000F92: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L029_00000F96:
; H029+$00000F96: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000F98:
; H029+$00000F98: 226dffec  movea.l -$14(a5), a1
        movea.l -$14(a5), a1
L029_00000F9C:
; H029+$00000F9C: 24690010  movea.l $10(a1), a2
        movea.l $10(a1), a2
L029_00000FA0:
; H029+$00000FA0: 4852  pea.l (a2)
        pea.l (a2)
L029_00000FA2:
; H029+$00000FA2: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000FA4:
; H029+$00000FA4: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00000FA6:
; H029+$00000FA6: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L029_00000FAA:
; H029+$00000FAA: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L029_00000FAE:
; H029+$00000FAE: 3f12  move.w (a2), -(a7)
        move.w (a2), -(a7)
L029_00000FB0:
; H029+$00000FB0: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L029_00000FB4:
; H029+$00000FB4: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_00000FB8:
; H029+$00000FB8: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00000FBA:
; H029+$00000FBA: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_00000FC0:
; H029+$00000FC0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00000FC2:
; H029+$00000FC2: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L029_00000FC6:
; H029+$00000FC6: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L029_00000FCA:
; H029+$00000FCA: 0c6d000ffff0  cmpi.w #$f, -$10(a5)
        cmpi.w #$f, -$10(a5)
L029_00000FD0:
; H029+$00000FD0: 620000d2  bhi.w $10a4
        bhi.w H029+$10A4
L029_00000FD4:
; H029+$00000FD4: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L029_00000FD8:
; H029+$00000FD8: 45ed0022  lea.l $22(a5), a2
        lea.l $22(a5), a2
L029_00000FDC:
; H029+$00000FDC: 7800  moveq #$0, d4
        moveq #0, d4
L029_00000FDE:
; H029+$00000FDE: 18322000  move.b (a2, d2.w), d4
        move.b (a2, d2.w), d4
L029_00000FE2:
; H029+$00000FE2: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L029_00000FE6:
; H029+$00000FE6: 45ed0012  lea.l $12(a5), a2
        lea.l $12(a5), a2
L029_00000FEA:
; H029+$00000FEA: 7c00  moveq #$0, d6
        moveq #0, d6
L029_00000FEC:
; H029+$00000FEC: 1c322000  move.b (a2, d2.w), d6
        move.b (a2, d2.w), d6
L029_00000FF0:
; H029+$00000FF0: b846  cmp.w d6, d4
        cmp.w d6, d4
L029_00000FF2:
; H029+$00000FF2: 670000a8  beq.w $109c
        beq.w H029+$109C
L029_00000FF6:
; H029+$00000FF6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00000FF8:
; H029+$00000FF8: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L029_00000FFC:
; H029+$00000FFC: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L029_00001000:
; H029+$00001000: 45ed0022  lea.l $22(a5), a2
        lea.l $22(a5), a2
L029_00001004:
; H029+$00001004: 1f322000  move.b (a2, d2.w), -(a7)
        move.b (a2, d2.w), -(a7)
L029_00001008:
; H029+$00001008: 6100f75c  bsr.w $766
        bsr.w H029+$766
L029_0000100C:
; H029+$0000100C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_0000100E:
; H029+$0000100E: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L029_00001012:
; H029+$00001012: 0c6d0004fff8  cmpi.w #$4, -$8(a5)
        cmpi.w #$4, -$8(a5)
L029_00001018:
; H029+$00001018: 6e000082  bgt.w $109c
        bgt.w H029+$109C
L029_0000101C:
; H029+$0000101C: 7401  moveq #$1, d2
        moveq #1, d2
L029_0000101E:
; H029+$0000101E: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L029_00001022:
; H029+$00001022: 4a44  tst.w d4
        tst.w d4
L029_00001024:
; H029+$00001024: 6a06  bpl.b $102c
        bpl.b H029+$102C
L029_00001026:
; H029+$00001026: 4444  neg.w d4
        neg.w d4
L029_00001028:
; H029+$00001028: e86a  lsr.w d4, d2
        lsr.w d4, d2
L029_0000102A:
; H029+$0000102A: 6002  bra.b $102e
        bra.b H029+$102E
L029_0000102C:
; H029+$0000102C: e96a  lsl.w d4, d2
        lsl.w d4, d2
L029_0000102E:
; H029+$0000102E: 1b42ffeb  move.b d2, -$15(a5)
        move.b d2, -$15(a5)
L029_00001032:
; H029+$00001032: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L029_00001036:
; H029+$00001036: 45ed0022  lea.l $22(a5), a2
        lea.l $22(a5), a2
L029_0000103A:
; H029+$0000103A: 18322000  move.b (a2, d2.w), d4
        move.b (a2, d2.w), d4
L029_0000103E:
; H029+$0000103E: c82dffeb  and.b -$15(a5), d4
        and.b -$15(a5), d4
L029_00001042:
; H029+$00001042: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L029_00001046:
; H029+$00001046: 45ed0012  lea.l $12(a5), a2
        lea.l $12(a5), a2
L029_0000104A:
; H029+$0000104A: 1c322000  move.b (a2, d2.w), d6
        move.b (a2, d2.w), d6
L029_0000104E:
; H029+$0000104E: cc2dffeb  and.b -$15(a5), d6
        and.b -$15(a5), d6
L029_00001052:
; H029+$00001052: b806  cmp.b d6, d4
        cmp.b d6, d4
L029_00001054:
; H029+$00001054: 6700003e  beq.w $1094
        beq.w H029+$1094
L029_00001058:
; H029+$00001058: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_0000105A:
; H029+$0000105A: 226dffec  movea.l -$14(a5), a1
        movea.l -$14(a5), a1
L029_0000105E:
; H029+$0000105E: 2469000c  movea.l $c(a1), a2
        movea.l $c(a1), a2
L029_00001062:
; H029+$00001062: 4852  pea.l (a2)
        pea.l (a2)
L029_00001064:
; H029+$00001064: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001066:
; H029+$00001066: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001068:
; H029+$00001068: 226d000c  movea.l $c(a5), a1
        movea.l $c(a5), a1
L029_0000106C:
; H029+$0000106C: 24690010  movea.l $10(a1), a2
        movea.l $10(a1), a2
L029_00001070:
; H029+$00001070: 4852  pea.l (a2)
        pea.l (a2)
L029_00001072:
; H029+$00001072: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L029_00001076:
; H029+$00001076: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001078:
; H029+$00001078: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L029_0000107C:
; H029+$0000107C: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L029_0000107E:
; H029+$0000107E: 1f3c0090  move.b #$90, -(a7)
        move.b #$90, -(a7)
L029_00001082:
; H029+$00001082: 1f2dffeb  move.b -$15(a5), -(a7)
        move.b -$15(a5), -(a7)
L029_00001086:
; H029+$00001086: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_00001088:
; H029+$00001088: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_0000108E:
; H029+$0000108E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L029_00001090:
; H029+$00001090: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L029_00001094:
; H029+$00001094: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L029_00001098:
; H029+$00001098: 6800ff78  bvc.w $1012
        bvc.w H029+$1012
L029_0000109C:
; H029+$0000109C: 526dfff0  addq.w #$1, -$10(a5)
        addq.w #$1, -$10(a5)
L029_000010A0:
; H029+$000010A0: 6400ff28  bcc.w $fca
        bcc.w H029+$FCA
L029_000010A4:
; H029+$000010A4: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L029_000010A8:
; H029+$000010A8: 6100f5d0  bsr.w $67a
        bsr.w H029+$67A
L029_000010AC:
; H029+$000010AC: 4e5d  unlk a5
        unlk a5
L029_000010AE:
; H029+$000010AE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000010B0:
; H029+$000010B0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_000010B2:
; H029+$000010B2: 4fef0026  lea.l $26(a7), a7
        lea.l $26(a7), a7
L029_000010B6:
; H029+$000010B6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_000010B8 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H038+$013C, H038+$0118.
;   - Calls H038+$013C.
;   - Calls H038+$0118.
; Direct callers: H047+$1330, H047+$0562, H047+$03A4
; --------------------------------------------------------------------------
L029_000010B8:
; H029+$000010B8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_000010BA:
; H029+$000010BA: 287af058  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000010BE:
; H029+$000010BE: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_000010C2:
; H029+$000010C2: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L029_000010C8:
; H029+$000010C8: 7400  moveq #$0, d2
        moveq #0, d2
L029_000010CA:
; H029+$000010CA: 142d0010  move.b $10(a5), d2
        move.b $10(a5), d2
L029_000010CE:
; H029+$000010CE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H038+$013C (wrapper_SetAPen)
L029_000010D0:
; H029+$000010D0: 4eb90000013c  jsr $13c.l
        jsr (H038+$13C).l
L029_000010D6:
; H029+$000010D6: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L029_000010DC:
; H029+$000010DC: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L029_000010E0:
; H029+$000010E0: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_000010E2:
; H029+$000010E2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_000010E4:
; H029+$000010E4: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L029_000010E8:
; H029+$000010E8: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_000010EA:
; H029+$000010EA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_000010EC:
; H029+$000010EC: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L029_000010F0:
; H029+$000010F0: d46d0014  add.w $14(a5), d2
        add.w $14(a5), d2
L029_000010F4:
; H029+$000010F4: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_000010F6:
; H029+$000010F6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L029_000010F8:
; H029+$000010F8: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L029_000010FA:
; H029+$000010FA: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L029_000010FE:
; H029+$000010FE: d46d0012  add.w $12(a5), d2
        add.w $12(a5), d2
L029_00001102:
; H029+$00001102: e742  asl.w #$3, d2
        asl.w #$3, d2
L029_00001104:
; H029+$00001104: 5342  subq.w #$1, d2
        subq.w #$1, d2
L029_00001106:
; H029+$00001106: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H038+$0118 (wrapper_RectFill)
L029_00001108:
; H029+$00001108: 4eb900000118  jsr $118.l
        jsr (H038+$118).l
L029_0000110E:
; H029+$0000110E: 4e5d  unlk a5
        unlk a5
L029_00001110:
; H029+$00001110: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00001112:
; H029+$00001112: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00001114:
; H029+$00001114: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L029_00001118:
; H029+$00001118: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H029+$0000111A..$0000115C; code/data not fully classified.
        dc.w $2F0C,$287A,$EFF6,$4E55,$0000,$2F39
        dc.l H005+$000052EE
        dc.w $7400,$142D,$000C,$3F02,$4EB9
        dc.l H038+$0000013C
        dc.w $2F39
        dc.l H005+$000052EE
        dc.w $3F2D,$0010,$3F2D,$000E,$4EB9
        dc.l H038+$000001DC
        dc.w $33C0
        dc.l H005+$00003358
        dc.w $4E5D,$285F,$205F,$5C8F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_0000115C [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H022+$0084.
;   - Calls H022+$0084.
;   - Uses the global state: H005+$52F2 (pointer to the game screen).
; Direct callers: H029+$12AE
; --------------------------------------------------------------------------
L029_0000115C:
; H029+$0000115C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_0000115E:
; H029+$0000115E: 287aefb4  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00001162:
; H029+$00001162: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_00001166:
; H029+$00001166: 4279000052ae  clr.w $52ae.l
        clr.w (H005+$52AE).l
L029_0000116C:
; H029+$0000116C: 33fc000a000052b0  move.w #$a, $52b0.l
        move.w #$a, (H005+$52B0).l
L029_00001174:
; H029+$00001174: 33fc00a0000052b2  move.w #$a0, $52b2.l
        move.w #$a0, (H005+$52B2).l
L029_0000117C:
; H029+$0000117C: 33fc00aa000052b4  move.w #$aa, $52b4.l
        move.w #$aa, (H005+$52B4).l
L029_00001184:
; H029+$00001184: 33fc0a00000052b6  move.w #$a00, $52b6.l
        move.w #$a00, (H005+$52B6).l
L029_0000118C:
; H029+$0000118C: 33fc0a0a000052b8  move.w #$a0a, $52b8.l
        move.w #$a0a, (H005+$52B8).l
L029_00001194:
; H029+$00001194: 33fc0a50000052ba  move.w #$a50, $52ba.l
        move.w #$a50, (H005+$52BA).l
L029_0000119C:
; H029+$0000119C: 33fc0aaa000052bc  move.w #$aaa, $52bc.l
        move.w #$aaa, (H005+$52BC).l
L029_000011A4:
; H029+$000011A4: 33fc0555000052be  move.w #$555, $52be.l
        move.w #$555, (H005+$52BE).l
L029_000011AC:
; H029+$000011AC: 33fc055f000052c0  move.w #$55f, $52c0.l
        move.w #$55f, (H005+$52C0).l
L029_000011B4:
; H029+$000011B4: 33fc05f5000052c2  move.w #$5f5, $52c2.l
        move.w #$5f5, (H005+$52C2).l
L029_000011BC:
; H029+$000011BC: 33fc05ff000052c4  move.w #$5ff, $52c4.l
        move.w #$5ff, (H005+$52C4).l
L029_000011C4:
; H029+$000011C4: 33fc0f55000052c6  move.w #$f55, $52c6.l
        move.w #$f55, (H005+$52C6).l
L029_000011CC:
; H029+$000011CC: 33fc0f5f000052c8  move.w #$f5f, $52c8.l
        move.w #$f5f, (H005+$52C8).l
L029_000011D4:
; H029+$000011D4: 33fc0ff5000052ca  move.w #$ff5, $52ca.l
        move.w #$ff5, (H005+$52CA).l
L029_000011DC:
; H029+$000011DC: 33fc0fff000052cc  move.w #$fff, $52cc.l
        move.w #$fff, (H005+$52CC).l
; STATE: H005+$52F2 = pointer to the game screen
L029_000011E4:
; H029+$000011E4: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L029_000011EA:
; H029+$000011EA: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L029_000011EE:
; H029+$000011EE: 47f9000052ae  lea.l $52ae.l, a3
        lea.l (H005+$52AE).l, a3
L029_000011F4:
; H029+$000011F4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000011F6:
; H029+$000011F6: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L029_000011FA:
; H029+$000011FA: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L029_00001200:
; H029+$00001200: 4e5d  unlk a5
        unlk a5
L029_00001202:
; H029+$00001202: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00001204:
; H029+$00001204: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00001206 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H024+$002A, H021+$01D2, H025+$0028, H021+$011E.
;   - Calls FN_build_NewScreen_OpenScreen (H024+$002A).
;   - Calls H021+$01D2.
;   - Calls FN_build_NewWindow_OpenWindow (H025+$0028).
;   - Calls H021+$011E.
;   - Calls H021+$01FA.
;   - Calls H051+$004A.
;   - Uses the global state: H005+$52F2 (pointer to the game screen); H005+$52F6 (pointer to the game window).
; Direct callers: H006+$027A
; --------------------------------------------------------------------------
L029_00001206:
; H029+$00001206: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00001208:
; H029+$00001208: 287aef0a  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000120C:
; H029+$0000120C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_00001210:
; H029+$00001210: 33fc010f00000004  move.w #$10f, $4.l
        move.w #$10f, (H024+$4).l
L029_00001218:
; H029+$00001218: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L029_0000121C:
; H029+$0000121C: 3f3c00c8  move.w #$c8, -(a7)
        move.w #$c8, -(a7)
L029_00001220:
; H029+$00001220: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L029_00001224:
; H029+$00001224: 42a7  clr.l -(a7)
        clr.l -(a7)
; FLOW: Calls Open_GameScreen (H024+$002A).
L029_00001226:
; H029+$00001226: 4eb90000002a  jsr $2a.l
        jsr (FN_build_NewScreen_OpenScreen).l
; STATE: H005+$52F2 = pointer to the game screen
L029_0000122C:
; H029+$0000122C: 23c0000052f2  move.l d0, $52f2.l
        move.l d0, (H005+$52F2).l
; STATE: H005+$52F2 = pointer to the game screen
L029_00001232:
; H029+$00001232: 2f39000052f2  move.l $52f2.l, -(a7)
        move.l (H005+$52F2).l, -(a7)
L029_00001238:
; H029+$00001238: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H021+$01D2 (wrapper_ShowTitle)
L029_0000123A:
; H029+$0000123A: 4eb9000001d2  jsr $1d2.l
        jsr (H021+$1D2).l
L029_00001240:
; H029+$00001240: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001242:
; H029+$00001242: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001244:
; H029+$00001244: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L029_00001248:
; H029+$00001248: 3f3c00c8  move.w #$c8, -(a7)
        move.w #$c8, -(a7)
L029_0000124C:
; H029+$0000124C: 2f3c00000408  move.l #$408, -(a7)
        move.l #IDCMP_RAWKEY+IDCMP_MOUSEBUTTONS, -(a7)
L029_00001252:
; H029+$00001252: 2f3c00011900  move.l #$11900, -(a7)
        move.l #WFLG_RMBTRAP+WFLG_ACTIVATE+WFLG_BORDERLESS+WFLG_BACKDROP, -(a7)
L029_00001258:
; H029+$00001258: 42a7  clr.l -(a7)
        clr.l -(a7)
; STATE: H005+$52F2 = pointer to the game screen
L029_0000125A:
; H029+$0000125A: 2f39000052f2  move.l $52f2.l, -(a7)
        move.l (H005+$52F2).l, -(a7)
L029_00001260:
; H029+$00001260: 42a7  clr.l -(a7)
        clr.l -(a7)
; FLOW: Calls Open_GameWindow (H025+$0028).
L029_00001262:
; H029+$00001262: 4eb900000028  jsr $28.l
        jsr (FN_build_NewWindow_OpenWindow).l
; STATE: H005+$52F6 = pointer to the game window
L029_00001268:
; H029+$00001268: 23c0000052f6  move.l d0, $52f6.l
        move.l d0, (H005+$52F6).l
; STATE: H005+$52F6 = pointer to the game window
L029_0000126E:
; H029+$0000126E: 2679000052f6  movea.l $52f6.l, a3
        movea.l (H005+$52F6).l, a3
L029_00001274:
; H029+$00001274: 23eb0032000052ee  move.l $32(a3), $52ee.l
        move.l $32(a3), (H005+$52EE).l
; -> H021+$011E (wrapper_CloseWorkBench)
L029_0000127C:
; H029+$0000127C: 4eb90000011e  jsr $11e.l
        jsr (H021+$11E).l
L029_00001282:
; H029+$00001282: 1400  move.b d0, d2
        move.b d0, d2
L029_00001284:
; H029+$00001284: 4a02  tst.b d2
        tst.b d2
L029_00001286:
; H029+$00001286: 6700000e  beq.w $1296
        beq.w H029+$1296
; STATE: H005+$52F6 = pointer to the game window
L029_0000128A:
; H029+$0000128A: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
; -> H021+$01FA (wrapper_ActivateWindow)
L029_00001290:
; H029+$00001290: 4eb9000001fa  jsr $1fa.l
        jsr (H021+$1FA).l
L029_00001296:
; H029+$00001296: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H051+$004A (wrapper_FindTask)
L029_00001298:
; H029+$00001298: 4eb90000004a  jsr $4a.l
        jsr (H051+$4A).l
L029_0000129E:
; H029+$0000129E: 2940ffe0  move.l d0, -$20(a4)
        move.l d0, -$20(a4)
L029_000012A2:
; H029+$000012A2: 266cffe0  movea.l -$20(a4), a3
        movea.l -$20(a4), a3
; STATE: H005+$52F6 = pointer to the game window
L029_000012A6:
; H029+$000012A6: 2779000052f600b8  move.l $52f6.l, $b8(a3)
        move.l (H005+$52F6).l, $b8(a3)
L029_000012AE:
; H029+$000012AE: 6100feac  bsr.w $115c
        bsr.w H029+$115C
L029_000012B2:
; H029+$000012B2: 6100ef80  bsr.w $234
        bsr.w H029+$234
L029_000012B6:
; H029+$000012B6: 4e5d  unlk a5
        unlk a5
L029_000012B8:
; H029+$000012B8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000012BA:
; H029+$000012BA: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_000012BC [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H051+$004A, H021+$0242, H021+$010C, H021+$0196.
;   - Calls H051+$004A.
;   - Calls H021+$0242.
;   - Calls H021+$010C.
;   - Calls H021+$0196.
;   - Uses the global state: H005+$52F6 (pointer to the game window); H005+$52F2 (pointer to the game screen).
; Direct callers: H010+$0348
; --------------------------------------------------------------------------
L029_000012BC:
; H029+$000012BC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_000012BE:
; H029+$000012BE: 287aee54  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000012C2:
; H029+$000012C2: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_000012C6:
; H029+$000012C6: 6100eeb8  bsr.w $180
        bsr.w H029+$180
L029_000012CA:
; H029+$000012CA: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H051+$004A (wrapper_FindTask)
L029_000012CC:
; H029+$000012CC: 4eb90000004a  jsr $4a.l
        jsr (H051+$4A).l
L029_000012D2:
; H029+$000012D2: 2940ffe0  move.l d0, -$20(a4)
        move.l d0, -$20(a4)
L029_000012D6:
; H029+$000012D6: 266cffe0  movea.l -$20(a4), a3
        movea.l -$20(a4), a3
L029_000012DA:
; H029+$000012DA: 42ab00b8  clr.l $b8(a3)
        clr.l $b8(a3)
; STATE: H005+$52F6 = pointer to the game window
L029_000012DE:
; H029+$000012DE: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
; -> H021+$0242 (wrapper_CloseWindow)
L029_000012E4:
; H029+$000012E4: 4eb900000242  jsr $242.l
        jsr (H021+$242).l
; STATE: H005+$52F2 = pointer to the game screen
L029_000012EA:
; H029+$000012EA: 2f39000052f2  move.l $52f2.l, -(a7)
        move.l (H005+$52F2).l, -(a7)
; -> H021+$010C (wrapper_CloseScreen)
L029_000012F0:
; H029+$000012F0: 4eb90000010c  jsr $10c.l
        jsr (H021+$10C).l
; -> H021+$0196 (wrapper_OpenWorkBench)
L029_000012F6:
; H029+$000012F6: 4eb900000196  jsr $196.l
        jsr (H021+$196).l
; STATE: H005+$52F2 = pointer to the game screen
L029_000012FC:
; H029+$000012FC: 23c0000052f2  move.l d0, $52f2.l
        move.l d0, (H005+$52F2).l
L029_00001302:
; H029+$00001302: 4e5d  unlk a5
        unlk a5
L029_00001304:
; H029+$00001304: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00001306:
; H029+$00001306: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00001308 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H029+$13C2, H029+$13D4
; --------------------------------------------------------------------------
L029_00001308:
; H029+$00001308: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_0000130A:
; H029+$0000130A: 287aee08  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000130E:
; H029+$0000130E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_00001312:
; H029+$00001312: 0c2d0080000c  cmpi.b #$80, $c(a5)
        cmpi.b #$80, $c(a5)
L029_00001318:
; H029+$00001318: 64000012  bcc.w $132c
        bcc.w H029+$132C
L029_0000131C:
; H029+$0000131C: 7400  moveq #$0, d2
        moveq #0, d2
L029_0000131E:
; H029+$0000131E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L029_00001322:
; H029+$00001322: 3002  move.w d2, d0
        move.w d2, d0
L029_00001324:
; H029+$00001324: 60000016  bra.w $133c
        bra.w H029+$133C
; Preserved bytes H029+$00001328..$0000132C; code/data not fully classified.
        dc.w $6000,$0012
L029_0000132C:
; H029+$0000132C: 7400  moveq #$0, d2
        moveq #0, d2
L029_0000132E:
; H029+$0000132E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L029_00001332:
; H029+$00001332: 04420100  subi.w #$100, d2
        subi.w #$100, d2
L029_00001336:
; H029+$00001336: 3002  move.w d2, d0
        move.w d2, d0
L029_00001338:
; H029+$00001338: 60000002  bra.w $133c
        bra.w H029+$133C
L029_0000133C:
; H029+$0000133C: 4e5d  unlk a5
        unlk a5
L029_0000133E:
; H029+$0000133E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00001340:
; H029+$00001340: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L029_00001342:
; H029+$00001342: 548f  addq.l #$2, a7
        addq.l #$2, a7
L029_00001344:
; H029+$00001344: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Prepare_DisplayResources [partial]
; Purpose: Prepares display resources, bitmaps and objects needed by the graphics.
;   - Relies on the Intuition and graphics bases already available.
;   - The path contains library checks/opens and handling of the graphic records.
;   - The complete reconstruction of the geometry and of the flags of every variant is still open.
; Direct callers: H006+$039C
; --------------------------------------------------------------------------
L029_00001346:
; H029+$00001346: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00001348:
; H029+$00001348: 287aedca  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000134C:
; H029+$0000134C: 4e55ff78  link.w a5, #$ff78
        link.w a5, #$ff78
L029_00001350:
; H029+$00001350: 4ab900003d8e  tst.l $3d8e.l
        tst.l (H005+$3D8E).l
L029_00001356:
; H029+$00001356: 66000130  bne.w $1488
        bne.w H029+$1488
L029_0000135A:
; H029+$0000135A: 3f3c00c8  move.w #$c8, -(a7)
        move.w #$c8, -(a7)
L029_0000135E:
; H029+$0000135E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L029_00001362:
; H029+$00001362: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L029_00001366:
; H029+$00001366: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001368:
; H029+$00001368: 487900003d8e  pea.l $3d8e.l
        pea.l (H005+$3D8E).l
; FLOW: Calls Allocate_GraphicRecord (H029+$0408).
L029_0000136E:
; H029+$0000136E: 6100f098  bsr.w $408
        bsr.w H029+$408
L029_00001372:
; H029+$00001372: 7464  moveq #$64, d2
        moveq #100, d2
L029_00001374:
; H029+$00001374: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L029_00001376:
; H029+$00001376: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L029_0000137C:
; H029+$0000137C: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L029_00001382:
; H029+$00001382: 2940fffc  move.l d0, -$4(a4)
        move.l d0, -$4(a4)
L029_00001386:
; H029+$00001386: 2f2cfffc  move.l -$4(a4), -(a7)
        move.l -$4(a4), -(a7)
; -> H055+$0044 (wrapper_InitRastPort)
L029_0000138A:
; H029+$0000138A: 4eb900000044  jsr $44.l
        jsr (H055+$44).l
L029_00001390:
; H029+$00001390: 267900003d8e  movea.l $3d8e.l, a3
        movea.l (H005+$3D8E).l, a3
L029_00001396:
; H029+$00001396: 246cfffc  movea.l -$4(a4), a2
        movea.l -$4(a4), a2
L029_0000139A:
; H029+$0000139A: 256b00100004  move.l $10(a3), $4(a2)
        move.l $10(a3), $4(a2)
L029_000013A0:
; H029+$000013A0: 486cffca  pea.l -$36(a4)
        pea.l -$36(a4)
; -> H022+$0060 (wrapper_InitView)
L029_000013A4:
; H029+$000013A4: 4eb900000060  jsr $60.l
        jsr (H022+$60).l
L029_000013AA:
; H029+$000013AA: 47edff7c  lea.l -$84(a5), a3
        lea.l -$84(a5), a3
L029_000013AE:
; H029+$000013AE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_000013B0:
; H029+$000013B0: 3f3c007c  move.w #$7c, -(a7)
        move.w #$7c, -(a7)
; -> H084+$002A (wrapper_GetPrefs)
L029_000013B4:
; H029+$000013B4: 4eb90000002a  jsr $2a.l
        jsr (H084+$2A).l
L029_000013BA:
; H029+$000013BA: 2b40ff78  move.l d0, -$88(a5)
        move.l d0, -$88(a5)
L029_000013BE:
; H029+$000013BE: 1f2dfff2  move.b -$e(a5), -(a7)
        move.b -$e(a5), -(a7)
L029_000013C2:
; H029+$000013C2: 6100ff44  bsr.w $1308
        bsr.w H029+$1308
L029_000013C6:
; H029+$000013C6: 3400  move.w d0, d2
        move.w d0, d2
L029_000013C8:
; H029+$000013C8: d46dfff4  add.w -$c(a5), d2
        add.w -$c(a5), d2
L029_000013CC:
; H029+$000013CC: 3942ffd8  move.w d2, -$28(a4)
        move.w d2, -$28(a4)
L029_000013D0:
; H029+$000013D0: 1f2dfff3  move.b -$d(a5), -(a7)
        move.b -$d(a5), -(a7)
L029_000013D4:
; H029+$000013D4: 6100ff32  bsr.w $1308
        bsr.w H029+$1308
L029_000013D8:
; H029+$000013D8: 3400  move.w d0, d2
        move.w d0, d2
L029_000013DA:
; H029+$000013DA: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L029_000013DE:
; H029+$000013DE: 3942ffd6  move.w d2, -$2a(a4)
        move.w d2, -$2a(a4)
L029_000013E2:
; H029+$000013E2: 47ecffa2  lea.l -$5e(a4), a3
        lea.l -$5e(a4), a3
L029_000013E6:
; H029+$000013E6: 294bffca  move.l a3, -$36(a4)
        move.l a3, -$36(a4)
L029_000013EA:
; H029+$000013EA: 486cffa2  pea.l -$5e(a4)
        pea.l -$5e(a4)
; -> H022+$0072 (wrapper_InitVPort)
L029_000013EE:
; H029+$000013EE: 4eb900000072  jsr $72.l
        jsr (H022+$72).l
L029_000013F4:
; H029+$000013F4: 267900003d8e  movea.l $3d8e.l, a3
        movea.l (H005+$3D8E).l, a3
L029_000013FA:
; H029+$000013FA: 296b0010ff9a  move.l $10(a3), -$66(a4)
        move.l $10(a3), -$66(a4)
L029_00001400:
; H029+$00001400: 426cff9e  clr.w -$62(a4)
        clr.w -$62(a4)
L029_00001404:
; H029+$00001404: 426cffa0  clr.w -$60(a4)
        clr.w -$60(a4)
L029_00001408:
; H029+$00001408: 42acff96  clr.l -$6a(a4)
        clr.l -$6a(a4)
L029_0000140C:
; H029+$0000140C: 397c0140ffba  move.w #$140, -$46(a4)
        move.w #$140, -$46(a4)
L029_00001412:
; H029+$00001412: 397c00c8ffbc  move.w #$c8, -$44(a4)
        move.w #$c8, -$44(a4)
L029_00001418:
; H029+$00001418: 47ecff96  lea.l -$6a(a4), a3
        lea.l -$6a(a4), a3
L029_0000141C:
; H029+$0000141C: 294bffc6  move.l a3, -$3a(a4)
        move.l a3, -$3a(a4)
L029_00001420:
; H029+$00001420: 7420  moveq #$20, d2
        moveq #32, d2
L029_00001422:
; H029+$00001422: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H022+$0038 (wrapper_GetColorMap)
L029_00001424:
; H029+$00001424: 4eb900000038  jsr $38.l
        jsr (H022+$38).l
L029_0000142A:
; H029+$0000142A: 2940ffa6  move.l d0, -$5a(a4)
        move.l d0, -$5a(a4)
L029_0000142E:
; H029+$0000142E: 486cffca  pea.l -$36(a4)
        pea.l -$36(a4)
L029_00001432:
; H029+$00001432: 486cffa2  pea.l -$5e(a4)
        pea.l -$5e(a4)
; -> H022+$00B2 (wrapper_MakeVPort)
L029_00001436:
; H029+$00001436: 4eb9000000b2  jsr $b2.l
        jsr (H022+$B2).l
L029_0000143C:
; H029+$0000143C: 486cffca  pea.l -$36(a4)
        pea.l -$36(a4)
; -> H022+$00C8 (wrapper_MrgCop)
L029_00001440:
; H029+$00001440: 4eb9000000c8  jsr $c8.l
        jsr (H022+$C8).l
L029_00001446:
; H029+$00001446: 47ec0086  lea.l $86(a4), a3
        lea.l $86(a4), a3
L029_0000144A:
; H029+$0000144A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_0000144C:
; H029+$0000144C: 7400  moveq #$0, d2
        moveq #0, d2
L029_0000144E:
; H029+$0000144E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H018+$006A (wrapper_OpenLibrary)
L029_00001450:
; H029+$00001450: 4eb90000006a  jsr $6a.l
        jsr (H018+$6A).l
L029_00001456:
; H029+$00001456: 2940fff2  move.l d0, -$e(a4)
        move.l d0, -$e(a4)
L029_0000145A:
; H029+$0000145A: 47ec0098  lea.l $98(a4), a3
        lea.l $98(a4), a3
L029_0000145E:
; H029+$0000145E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_00001460:
; H029+$00001460: 7400  moveq #$0, d2
        moveq #0, d2
L029_00001462:
; H029+$00001462: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H018+$006A (wrapper_OpenLibrary)
L029_00001464:
; H029+$00001464: 4eb90000006a  jsr $6a.l
        jsr (H018+$6A).l
L029_0000146A:
; H029+$0000146A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L029_0000146E:
; H029+$0000146E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L029_00001472:
; H029+$00001472: 296b0022ffdc  move.l $22(a3), -$24(a4)
        move.l $22(a3), -$24(a4)
L029_00001478:
; H029+$00001478: 2b6dfffcfff8  move.l -$4(a5), -$8(a5)
        move.l -$4(a5), -$8(a5)
L029_0000147E:
; H029+$0000147E: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H018+$0018 (wrapper_CloseLibrary)
L029_00001482:
; H029+$00001482: 4eb900000018  jsr $18.l
        jsr (H018+$18).l
L029_00001488:
; H029+$00001488: 4e5d  unlk a5
        unlk a5
L029_0000148A:
; H029+$0000148A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_0000148C:
; H029+$0000148C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_0000148E [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H022+$0014, H022+$0026, H082+$0074, H003+$00F6.
;   - Calls H022+$0014.
;   - Calls H022+$0026.
;   - Calls H082+$0074.
;   - Calls H003+$00F6.
;   - Calls H018+$0018.
; Direct callers: H010+$0342
; --------------------------------------------------------------------------
L029_0000148E:
; H029+$0000148E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00001490:
; H029+$00001490: 287aec82  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00001494:
; H029+$00001494: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L029_00001498:
; H029+$00001498: 4aacfffc  tst.l -$4(a4)
        tst.l -$4(a4)
L029_0000149C:
; H029+$0000149C: 67000048  beq.w $14e6
        beq.w H029+$14E6
L029_000014A0:
; H029+$000014A0: 2b6cffa6fffc  move.l -$5a(a4), -$4(a5)
        move.l -$5a(a4), -$4(a5)
L029_000014A6:
; H029+$000014A6: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H022+$0014 (wrapper_FreeColorMap)
L029_000014AA:
; H029+$000014AA: 4eb900000014  jsr $14.l
        jsr (H022+$14).l
L029_000014B0:
; H029+$000014B0: 486cffa2  pea.l -$5e(a4)
        pea.l -$5e(a4)
; -> H022+$0026 (wrapper_FreeVPortCopLists)
L029_000014B4:
; H029+$000014B4: 4eb900000026  jsr $26.l
        jsr (H022+$26).l
L029_000014BA:
; H029+$000014BA: 2f2cffce  move.l -$32(a4), -(a7)
        move.l -$32(a4), -(a7)
; -> H082+$0074 (wrapper_FreeCprList)
L029_000014BE:
; H029+$000014BE: 4eb900000074  jsr $74.l
        jsr (H082+$74).l
L029_000014C4:
; H029+$000014C4: 2f2cfffc  move.l -$4(a4), -(a7)
        move.l -$4(a4), -(a7)
L029_000014C8:
; H029+$000014C8: 7464  moveq #$64, d2
        moveq #100, d2
L029_000014CA:
; H029+$000014CA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L029_000014CC:
; H029+$000014CC: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L029_000014D2:
; H029+$000014D2: 42acfffc  clr.l -$4(a4)
        clr.l -$4(a4)
L029_000014D6:
; H029+$000014D6: 2b6cfff2fff8  move.l -$e(a4), -$8(a5)
        move.l -$e(a4), -$8(a5)
L029_000014DC:
; H029+$000014DC: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H018+$0018 (wrapper_CloseLibrary)
L029_000014E0:
; H029+$000014E0: 4eb900000018  jsr $18.l
        jsr (H018+$18).l
L029_000014E6:
; H029+$000014E6: 487900003d8e  pea.l $3d8e.l
        pea.l (H005+$3D8E).l
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L029_000014EC:
; H029+$000014EC: 6100f18c  bsr.w $67a
        bsr.w H029+$67A
L029_000014F0:
; H029+$000014F0: 4e5d  unlk a5
        unlk a5
L029_000014F2:
; H029+$000014F2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000014F4:
; H029+$000014F4: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_000014F6 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H010+$0974.
;   - Calls H010+$0974.
;   - Uses the global state: H005+$52F2 (pointer to the game screen).
; Direct callers: H029+$16B8, H029+$1596
; --------------------------------------------------------------------------
L029_000014F6:
; H029+$000014F6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_000014F8:
; H029+$000014F8: 287aec1a  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000014FC:
; H029+$000014FC: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_00001500:
; H029+$00001500: 266cfff2  movea.l -$e(a4), a3
        movea.l -$e(a4), a3
L029_00001504:
; H029+$00001504: 242b003c  move.l $3c(a3), d2
        move.l $3c(a3), d2
; STATE: H005+$52F2 = pointer to the game screen
L029_00001508:
; H029+$00001508: b4b9000052f2  cmp.l $52f2.l, d2
        cmp.l (H005+$52F2).l, d2
L029_0000150E:
; H029+$0000150E: 6700000a  beq.w $151a
        beq.w H029+$151A
; -> H010+$0974 (sub_H010_00000974)
L029_00001512:
; H029+$00001512: 4eb900000974  jsr $974.l
        jsr (H010+$974).l
L029_00001518:
; H029+$00001518: 60e6  bra.b $1500
        bra.b H029+$1500
L029_0000151A:
; H029+$0000151A: 4e5d  unlk a5
        unlk a5
L029_0000151C:
; H029+$0000151C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_0000151E:
; H029+$0000151E: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00001520 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H016+$0014.
;   - Calls H016+$0014.
;   - Uses the global state: H005+$52F2 (pointer to the game screen).
; Direct callers: H029+$16B4, H063+$254C
; --------------------------------------------------------------------------
L029_00001520:
; H029+$00001520: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00001522:
; H029+$00001522: 287aebf0  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_00001526:
; H029+$00001526: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATE: H005+$52F2 = pointer to the game screen
L029_0000152A:
; H029+$0000152A: 2479000052f2  movea.l $52f2.l, a2
        movea.l (H005+$52F2).l, a2
L029_00001530:
; H029+$00001530: 266a0058  movea.l $58(a2), a3
        movea.l $58(a2), a3
L029_00001534:
; H029+$00001534: 4853  pea.l (a3)
        pea.l (a3)
L029_00001536:
; H029+$00001536: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001538:
; H029+$00001538: 4267  clr.w -(a7)
        clr.w -(a7)
L029_0000153A:
; H029+$0000153A: 247900003d8e  movea.l $3d8e.l, a2
        movea.l (H005+$3D8E).l, a2
L029_00001540:
; H029+$00001540: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L029_00001544:
; H029+$00001544: 4853  pea.l (a3)
        pea.l (a3)
L029_00001546:
; H029+$00001546: 4267  clr.w -(a7)
        clr.w -(a7)
L029_00001548:
; H029+$00001548: 4267  clr.w -(a7)
        clr.w -(a7)
L029_0000154A:
; H029+$0000154A: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L029_0000154E:
; H029+$0000154E: 3f3c00c8  move.w #$c8, -(a7)
        move.w #$c8, -(a7)
L029_00001552:
; H029+$00001552: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L029_00001556:
; H029+$00001556: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L029_0000155A:
; H029+$0000155A: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L029_0000155C:
; H029+$0000155C: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L029_00001562:
; H029+$00001562: 33c000003358  move.w d0, $3358.l
        move.w d0, (H005+$3358).l
L029_00001568:
; H029+$00001568: 426cfff8  clr.w -$8(a4)
        clr.w -$8(a4)
L029_0000156C:
; H029+$0000156C: 422cfff7  clr.b -$9(a4)
        clr.b -$9(a4)
L029_00001570:
; H029+$00001570: 4e5d  unlk a5
        unlk a5
L029_00001572:
; H029+$00001572: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00001574:
; H029+$00001574: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00001576 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H022+$00A0, H016+$01AC.
;   - Calls H022+$00A0.
;   - Calls H016+$01AC.
; Direct callers: H063+$2592, H063+$272E
; --------------------------------------------------------------------------
L029_00001576:
; H029+$00001576: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_00001578:
; H029+$00001578: 287aeb9a  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000157C:
; H029+$0000157C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_00001580:
; H029+$00001580: 7401  moveq #$1, d2
        moveq #1, d2
L029_00001582:
; H029+$00001582: 946cfff8  sub.w -$8(a4), d2
        sub.w -$8(a4), d2
L029_00001586:
; H029+$00001586: 3942fff8  move.w d2, -$8(a4)
        move.w d2, -$8(a4)
L029_0000158A:
; H029+$0000158A: 422cfffa  clr.b -$6(a4)
        clr.b -$6(a4)
L029_0000158E:
; H029+$0000158E: 4a6cfff8  tst.w -$8(a4)
        tst.w -$8(a4)
L029_00001592:
; H029+$00001592: 66000018  bne.w $15ac
        bne.w H029+$15AC
L029_00001596:
; H029+$00001596: 6100ff5e  bsr.w $14f6
        bsr.w H029+$14F6
L029_0000159A:
; H029+$0000159A: 486cffca  pea.l -$36(a4)
        pea.l -$36(a4)
; -> H022+$00A0 (wrapper_LoadView)
L029_0000159E:
; H029+$0000159E: 4eb9000000a0  jsr $a0.l
        jsr (H022+$A0).l
L029_000015A4:
; H029+$000015A4: 422cfffb  clr.b -$5(a4)
        clr.b -$5(a4)
L029_000015A8:
; H029+$000015A8: 60000012  bra.w $15bc
        bra.w H029+$15BC
L029_000015AC:
; H029+$000015AC: 2f2cffdc  move.l -$24(a4), -(a7)
        move.l -$24(a4), -(a7)
; -> H022+$00A0 (wrapper_LoadView)
L029_000015B0:
; H029+$000015B0: 4eb9000000a0  jsr $a0.l
        jsr (H022+$A0).l
L029_000015B6:
; H029+$000015B6: 197c0001fffb  move.b #$1, -$5(a4)
        move.b #$1, -$5(a4)
; -> H016+$01AC (wrapper_WaitTOF)
L029_000015BC:
; H029+$000015BC: 4eb9000001ac  jsr $1ac.l
        jsr (H016+$1AC).l
L029_000015C2:
; H029+$000015C2: 4e5d  unlk a5
        unlk a5
L029_000015C4:
; H029+$000015C4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000015C6:
; H029+$000015C6: 4e75  rts 
        rts 
; Preserved bytes H029+$000015C8..$000016A2; code/data not fully classified.
        dc.w $2F0C,$287A,$EB48,$4E55,$0000,$526C,$FFE4,$4A6C
        dc.w $FFE6,$6600,$000E,$4A2C,$FFF7,$6700,$0006,$6100
        dc.w $FF38,$422C,$FFFA,$4A6C,$FFE6,$6600,$000E,$4A6C
        dc.w $FFE4,$6700,$0006,$7401,$6002,$7400,$1942,$FFFB
        dc.w $4E5D,$285F,$4E75,$2F0C,$287A,$EB02,$4E55,$0000
        dc.w $536C,$FFE4,$4A6C,$FFE6,$6600,$0046,$4A6C,$FFE4
        dc.w $6600,$003E,$2479
        dc.l H005+$00003D8E
        dc.w $266A,$0010,$4853,$3F3C,$0008,$3F3C,$0008,$2679
        dc.l H005+$000052F2
        dc.w $47EB,$00B8,$2F0B,$3F3C,$0008,$3F3C,$0008,$3F3C
        dc.w $00A8,$3F3C,$00A8,$1F3C,$00CA,$42A7,$4EB9
        dc.l H049+$000004AE
        dc.w $4A6C,$FFE4,$6600,$000E,$4A6C,$FFE6,$6600,$0006
        dc.w $7401,$6002,$7400,$1942,$FFFA,$4A6C,$FFE6,$6600
        dc.w $000E,$4A6C,$FFE4,$6700,$0006,$7401,$6002,$7400
        dc.w $1942,$FFFB,$4E5D,$285F,$4E75
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_000016A2 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H022+$00A0, H016+$01AC.
;   - Calls H022+$00A0.
;   - Calls H016+$01AC.
; Direct callers: H048+$0DFC, H048+$088E, H048+$0BDA, H048+$033E, H042+$026C, H042+$0EF6 and 5 more
; --------------------------------------------------------------------------
L029_000016A2:
; H029+$000016A2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_000016A4:
; H029+$000016A4: 287aea6e  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000016A8:
; H029+$000016A8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_000016AC:
; H029+$000016AC: 4a6cffe6  tst.w -$1a(a4)
        tst.w -$1a(a4)
L029_000016B0:
; H029+$000016B0: 6600001a  bne.w $16cc
        bne.w H029+$16CC
L029_000016B4:
; H029+$000016B4: 6100fe6a  bsr.w $1520
        bsr.w H029+$1520
L029_000016B8:
; H029+$000016B8: 6100fe3c  bsr.w $14f6
        bsr.w H029+$14F6
L029_000016BC:
; H029+$000016BC: 486cffca  pea.l -$36(a4)
        pea.l -$36(a4)
; -> H022+$00A0 (wrapper_LoadView)
L029_000016C0:
; H029+$000016C0: 4eb9000000a0  jsr $a0.l
        jsr (H022+$A0).l
; -> H016+$01AC (wrapper_WaitTOF)
L029_000016C6:
; H029+$000016C6: 4eb9000001ac  jsr $1ac.l
        jsr (H016+$1AC).l
L029_000016CC:
; H029+$000016CC: 526cffe6  addq.w #$1, -$1a(a4)
        addq.w #$1, -$1a(a4)
L029_000016D0:
; H029+$000016D0: 422cfffb  clr.b -$5(a4)
        clr.b -$5(a4)
L029_000016D4:
; H029+$000016D4: 422cfffa  clr.b -$6(a4)
        clr.b -$6(a4)
L029_000016D8:
; H029+$000016D8: 4e5d  unlk a5
        unlk a5
L029_000016DA:
; H029+$000016DA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000016DC:
; H029+$000016DC: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_000016DE [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H022+$00A0, H016+$01AC.
;   - Calls H022+$00A0.
;   - Calls H016+$01AC.
; Direct callers: H048+$0946, H048+$0F78, H048+$0578, H042+$02A0, H048+$0DDA, H042+$0F40 and 5 more
; --------------------------------------------------------------------------
L029_000016DE:
; H029+$000016DE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_000016E0:
; H029+$000016E0: 287aea32  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_000016E4:
; H029+$000016E4: 4e550000  link.w a5, #$0
        link.w a5, #$0
L029_000016E8:
; H029+$000016E8: 536cffe6  subq.w #$1, -$1a(a4)
        subq.w #$1, -$1a(a4)
L029_000016EC:
; H029+$000016EC: 4a6cffe6  tst.w -$1a(a4)
        tst.w -$1a(a4)
L029_000016F0:
; H029+$000016F0: 6e00001c  bgt.w $170e
        bgt.w H029+$170E
L029_000016F4:
; H029+$000016F4: 426cffe6  clr.w -$1a(a4)
        clr.w -$1a(a4)
L029_000016F8:
; H029+$000016F8: 2f2cffdc  move.l -$24(a4), -(a7)
        move.l -$24(a4), -(a7)
; -> H022+$00A0 (wrapper_LoadView)
L029_000016FC:
; H029+$000016FC: 4eb9000000a0  jsr $a0.l
        jsr (H022+$A0).l
; -> H016+$01AC (wrapper_WaitTOF)
L029_00001702:
; H029+$00001702: 4eb9000001ac  jsr $1ac.l
        jsr (H016+$1AC).l
L029_00001708:
; H029+$00001708: 197c0001fffa  move.b #$1, -$6(a4)
        move.b #$1, -$6(a4)
L029_0000170E:
; H029+$0000170E: 422cfffb  clr.b -$5(a4)
        clr.b -$5(a4)
L029_00001712:
; H029+$00001712: 4e5d  unlk a5
        unlk a5
L029_00001714:
; H029+$00001714: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_00001716:
; H029+$00001716: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H029_00001718 [partial]
; Purpose: Routine of the graphic records, bitplanes, masks and tile drawing module; calls H022+$0084.
;   - Calls H022+$0084.
; Direct callers: H042+$0266, H042+$0EF0, H042+$10E6, H011+$0B82, H095+$25DC
; --------------------------------------------------------------------------
L029_00001718:
; H029+$00001718: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L029_0000171A:
; H029+$0000171A: 287ae9f8  movea.l $114(pc), a4
        movea.l H029+$114(pc), a4
L029_0000171E:
; H029+$0000171E: 4e55ffb6  link.w a5, #$ffb6
        link.w a5, #$ffb6
L029_00001722:
; H029+$00001722: 246cffdc  movea.l -$24(a4), a2
        movea.l -$24(a4), a2
L029_00001726:
; H029+$00001726: 266a0004  movea.l $4(a2), a3
        movea.l $4(a2), a3
L029_0000172A:
; H029+$0000172A: 2b6b0004fffc  move.l $4(a3), -$4(a5)
        move.l $4(a3), -$4(a5)
L029_00001730:
; H029+$00001730: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L029_00001734:
; H029+$00001734: 0c9301800000  cmpi.l #$1800000, (a3)
        cmpi.l #$1800000, (a3)
L029_0000173A:
; H029+$0000173A: 6700000e  beq.w $174a
        beq.w H029+$174A
L029_0000173E:
; H029+$0000173E: 242dfffc  move.l -$4(a5), d2
        move.l -$4(a5), d2
L029_00001742:
; H029+$00001742: 5882  addq.l #$4, d2
        addq.l #$4, d2
L029_00001744:
; H029+$00001744: 2b42fffc  move.l d2, -$4(a5)
        move.l d2, -$4(a5)
L029_00001748:
; H029+$00001748: 60e6  bra.b $1730
        bra.b H029+$1730
L029_0000174A:
; H029+$0000174A: 2b6dfffcfff8  move.l -$4(a5), -$8(a5)
        move.l -$4(a5), -$8(a5)
L029_00001750:
; H029+$00001750: 426dffb6  clr.w -$4a(a5)
        clr.w -$4a(a5)
L029_00001754:
; H029+$00001754: 0c6d001fffb6  cmpi.w #$1f, -$4a(a5)
        cmpi.w #$1f, -$4a(a5)
L029_0000175A:
; H029+$0000175A: 6e000026  bgt.w $1782
        bgt.w H029+$1782
L029_0000175E:
; H029+$0000175E: 342dffb6  move.w -$4a(a5), d2
        move.w -$4a(a5), d2
L029_00001762:
; H029+$00001762: e342  asl.w #$1, d2
        asl.w #$1, d2
L029_00001764:
; H029+$00001764: 47edffb8  lea.l -$48(a5), a3
        lea.l -$48(a5), a3
L029_00001768:
; H029+$00001768: 382dffb6  move.w -$4a(a5), d4
        move.w -$4a(a5), d4
L029_0000176C:
; H029+$0000176C: e344  asl.w #$1, d4
        asl.w #$1, d4
L029_0000176E:
; H029+$0000176E: 5244  addq.w #$1, d4
        addq.w #$1, d4
L029_00001770:
; H029+$00001770: e344  asl.w #$1, d4
        asl.w #$1, d4
L029_00001772:
; H029+$00001772: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L029_00001776:
; H029+$00001776: 37b240002000  move.w (a2, d4.w), (a3, d2.w)
        move.w (a2, d4.w), (a3, d2.w)
L029_0000177C:
; H029+$0000177C: 526dffb6  addq.w #$1, -$4a(a5)
        addq.w #$1, -$4a(a5)
L029_00001780:
; H029+$00001780: 68d2  bvc.b $1754
        bvc.b H029+$1754
L029_00001782:
; H029+$00001782: 486cffa2  pea.l -$5e(a4)
        pea.l -$5e(a4)
L029_00001786:
; H029+$00001786: 47edffb8  lea.l -$48(a5), a3
        lea.l -$48(a5), a3
L029_0000178A:
; H029+$0000178A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L029_0000178C:
; H029+$0000178C: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L029_00001790:
; H029+$00001790: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L029_00001796:
; H029+$00001796: 4e5d  unlk a5
        unlk a5
L029_00001798:
; H029+$00001798: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_0000179A:
; H029+$0000179A: 4e75  rts 
        rts 
L029_0000179C:
; H029+$0000179C: 397cfffffff0  move.w #$ffff, -$10(a4)
        move.w #$ffff, -$10(a4)
L029_000017A2:
; H029+$000017A2: 42acffec  clr.l -$14(a4)
        clr.l -$14(a4)
L029_000017A6:
; H029+$000017A6: 42acfffc  clr.l -$4(a4)
        clr.l -$4(a4)
L029_000017AA:
; H029+$000017AA: 426cffe6  clr.w -$1a(a4)
        clr.w -$1a(a4)
L029_000017AE:
; H029+$000017AE: 426cffe4  clr.w -$1c(a4)
        clr.w -$1c(a4)
L029_000017B2:
; H029+$000017B2: 422cfffb  clr.b -$5(a4)
        clr.b -$5(a4)
L029_000017B6:
; H029+$000017B6: 422cfffa  clr.b -$6(a4)
        clr.b -$6(a4)
L029_000017BA:
; H029+$000017BA: 422cfff7  clr.b -$9(a4)
        clr.b -$9(a4)
L029_000017BE:
; H029+$000017BE: 4e5d  unlk a5
        unlk a5
L029_000017C0:
; H029+$000017C0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L029_000017C2:
; H029+$000017C2: 4e75  rts 
        rts 
; End H029: $17C4 bytes
