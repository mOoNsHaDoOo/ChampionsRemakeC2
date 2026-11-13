; ============================================================================
; MODULE GUIDE H012
; ECL dispatcher, encounters and native scenario loop.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; ECL dispatcher and scenario loop. The 33 functions include the opcode dispatcher, the encounter/combat handlers, the native loop and the ECL entry services.
; --------------------------------------------------------------------------
; H012: 13580 original bytes; all offsets are section-relative.
        section H012,code
H012:
; Preserved bytes H012+$00000000..$00000178; code/data not fully classified.
        dc.w $0000,$4954,$454D,$002E,$4441,$5800,$556E,$6162
        dc.w $6C65,$2074,$6F20,$6669,$6E64,$2069,$7465,$6D20
        dc.w $6669,$6C65,$007E,$434F,$4D42,$4154,$207E,$5741
        dc.w $4954,$207E,$464C,$4545,$207E,$4144,$5641,$4E43
        dc.w $4500,$7E43,$4F4D,$4241,$5420,$7E57,$4149,$5420
        dc.w $7E46,$4C45,$4520,$7E50,$4152,$4C41,$5900,$0000
        dc.w $426F,$7468,$2073,$6964,$6573,$2077,$6169,$742E
        dc.w $0042,$6F74,$6820,$7369,$6465,$7320,$7761,$6974
        dc.w $2E00,$5468,$6520,$6D6F,$6E73,$7465,$7273,$2066
        dc.w $6C65,$652E,$0054,$6865,$206D,$6F6E,$7374,$6572
        dc.w $7320,$666C,$6565,$2E00,$426F,$7468,$2073,$6964
        dc.w $6573,$2077,$6169,$742E,$007E,$4841,$5547,$4854
        dc.w $5920,$7E53,$4C59,$207E,$4E49,$4345,$207E,$4D45
        dc.w $454B,$207E,$4142,$5553,$4956,$4500,$5468,$6520
        dc.w $656E,$7469,$7265,$2070,$6172,$7479,$2069,$7320
        dc.w $6B69,$6C6C,$6564,$2100,$7072,$6573,$7320,$3C65
        dc.w $6E74,$6572,$3E2F,$3C72,$6574,$7572,$6E3E,$2074
        dc.w $6F20,$636F,$6E74,$696E,$7565,$0073,$7065,$6C6C
        dc.w $0043,$6F6E,$6772,$6174,$756C,$6174,$696F,$6E73
        dc.w $2074,$6865,$2070,$6172,$7479,$2067,$6169,$6E73
        dc.w $2065,$7870,$6572,$6965,$6E63,$6521,$0043,$6F6E
        dc.w $6772,$6174,$756C,$6174,$696F,$6E73,$2000,$2067
        dc.w $6169,$6E73,$2065,$7870,$6572,$6965,$6E63,$6521
        dc.w $0000,$0000
        dc.l H012+$00000002
; --------------------------------------------------------------------------
; ROUTINE: module_init_H012 [partial]
; Purpose: Entry of the ECL dispatcher, encounters and native scenario loop module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H012+$3504.
; Direct callers: H000+$024C
; --------------------------------------------------------------------------
L012_00000178:
; H012+$00000178: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_0000017A:
; H012+$0000017A: 287afff8  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_0000017E:
; H012+$0000017E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L012_00000182:
; H012+$00000182: 60003380  bra.w $3504
        bra.w H012+$3504
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H012_3004 [partial]
; Purpose: Trampoline to H012+$3004; the actual body is there.
;   - Jumps to the actual body at H012+$3004.
; Direct callers: H012+$01E6
; --------------------------------------------------------------------------
L012_00000186:
; H012+$00000186: 60002c6a  bra.w $2df2
        bra.w H012+$2DF2
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_RunAtAddress [verified]
; Purpose: Runs a sequence of opcodes starting from a logical address.
;   - Sets the requested address and the current PC.
;   - Reads the opcode from the ECL buffer[PC-$3500] and calls the local dispatcher.
;   - Goes on as long as the execution flags/conditions allow progress.
; Direct callers: H012+$2936, H012+$2958, H012+$3088, H012+$30FE, H012+$3112, H012+$323A, H012+$33C4, H012+$341A, H012+$34AC
; --------------------------------------------------------------------------
L012_0000018A:
; H012+$0000018A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_0000018C:
; H012+$0000018C: 287affe6  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00000190:
; H012+$00000190: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L012_00000194:
; H012+$00000194: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L012_0000019A:
; H012+$0000019A: 33ed000c00003de8  move.w $c(a5), $3de8.l
        move.w $c(a5), (H005+$3DE8).l
; STATE: H005+$3DEA = logical ECL PC
L012_000001A2:
; H012+$000001A2: 33ed000c00003dea  move.w $c(a5), $3dea.l
        move.w $c(a5), (H005+$3DEA).l
L012_000001AA:
; H012+$000001AA: 42390000000b  clr.b $b.l
        clr.b (H064+$B).l
L012_000001B0:
; H012+$000001B0: 4a390000000b  tst.b $b.l
        tst.b (H064+$B).l
L012_000001B6:
; H012+$000001B6: 66000032  bne.w $1ea
        bne.w H012+$1EA
; STATE: H005+$24D0 = request to exit the scenario loop
L012_000001BA:
; H012+$000001BA: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_000001C0:
; H012+$000001C0: 66000028  bne.w $1ea
        bne.w H012+$1EA
; STATE: H005+$2493 = current ECL opcode
L012_000001C4:
; H012+$000001C4: 13f90000249300002494  move.b $2493.l, $2494.l
        move.b (H005+$2493).l, (H005+$2494).l
; STATE: H005+$3DEA = logical ECL PC
L012_000001CE:
; H012+$000001CE: 343900003dea  move.w $3dea.l, d2
        move.w (H005+$3DEA).l, d2
L012_000001D4:
; H012+$000001D4: 04423500  subi.w #$3500, d2
        subi.w #$3500, d2
; STATE: H005+$3DF8 = pointer to the ECL buffer
L012_000001D8:
; H012+$000001D8: 267900003df8  movea.l $3df8.l, a3
        movea.l (H005+$3DF8).l, a3
; STATE: H005+$2493 = current ECL opcode
L012_000001DE:
; H012+$000001DE: 13f3200000002493  move.b (a3, d2.w), $2493.l
        move.b (a3, d2.w), (H005+$2493).l
L012_000001E6:
; H012+$000001E6: 619e  bsr.b $186
        bsr.b H012+$186
L012_000001E8:
; H012+$000001E8: 60c6  bra.b $1b0
        bra.b H012+$1B0
L012_000001EA:
; H012+$000001EA: 42390000000b  clr.b $b.l
        clr.b (H064+$B).l
L012_000001F0:
; H012+$000001F0: 4e5d  unlk a5
        unlk a5
L012_000001F2:
; H012+$000001F2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_000001F4:
; H012+$000001F4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L012_000001F6:
; H012+$000001F6: 548f  addq.l #$2, a7
        addq.l #$2, a7
L012_000001F8:
; H012+$000001F8: 4ed0  jmp (a0)
        jmp (a0)
; FUNCTION: ECL_30_CHECKPARTY
FN_ECL_30_CHECKPARTY:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_30 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 30=CHECKPARTY.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2EB0
; --------------------------------------------------------------------------
L012_000001FA:
; H012+$000001FA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_000001FC:
; H012+$000001FC: 287aff76  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00000200:
; H012+$00000200: 4e55ffdc  link.w a5, #$ffdc
        link.w a5, #$ffdc
L012_00000204:
; H012+$00000204: 6000006a  bra.w $270
        bra.w H012+$270
; --------------------------------------------------------------------------
; ROUTINE: sub_H012_00000208 [partial]
; Purpose: Routine of the ECL dispatcher, encounters and native scenario loop module; calls H061+$2BAA, H061+$1670, H061+$1F3C, H061+$184E.
;   - Calls H061+$2BAA.
;   - Calls FN_ECL_read_operands (H061+$1670).
;   - Calls H061+$1F3C.
;   - Calls H061+$184E.
;   - Calls H063+$0946.
;   - Calls H029+$0312.
;   - Uses the global state: H005+$3364 (head of the party list).
; Direct callers: H012+$03E6, H012+$0462, H012+$051E, H012+$059A
; --------------------------------------------------------------------------
L012_00000208:
; H012+$00000208: 4e550000  link.w a5, #$0
        link.w a5, #$0
L012_0000020C:
; H012+$0000020C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_00000210:
; H012+$00000210: 3f2bffe6  move.w -$1a(a3), -(a7)
        move.w -$1a(a3), -(a7)
L012_00000214:
; H012+$00000214: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_00000218:
; H012+$00000218: 3f2bffe8  move.w -$18(a3), -(a7)
        move.w -$18(a3), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_0000021C:
; H012+$0000021C: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00000222:
; H012+$00000222: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_00000226:
; H012+$00000226: 3f2bffe4  move.w -$1c(a3), -(a7)
        move.w -$1c(a3), -(a7)
L012_0000022A:
; H012+$0000022A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_0000022E:
; H012+$0000022E: 3f2bffea  move.w -$16(a3), -(a7)
        move.w -$16(a3), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00000232:
; H012+$00000232: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00000238:
; H012+$00000238: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_0000023C:
; H012+$0000023C: 3f2bffe2  move.w -$1e(a3), -(a7)
        move.w -$1e(a3), -(a7)
L012_00000240:
; H012+$00000240: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_00000244:
; H012+$00000244: 3f2bffec  move.w -$14(a3), -(a7)
        move.w -$14(a3), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00000248:
; H012+$00000248: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_0000024E:
; H012+$0000024E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_00000252:
; H012+$00000252: 3f2bffe0  move.w -$20(a3), -(a7)
        move.w -$20(a3), -(a7)
L012_00000256:
; H012+$00000256: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000258:
; H012+$00000258: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L012_0000025C:
; H012+$0000025C: 142bfff3  move.b -$d(a3), d2
        move.b -$d(a3), d2
L012_00000260:
; H012+$00000260: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00000262:
; H012+$00000262: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00000268:
; H012+$00000268: 4e5d  unlk a5
        unlk a5
L012_0000026A:
; H012+$0000026A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L012_0000026C:
; H012+$0000026C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L012_0000026E:
; H012+$0000026E: 4ed0  jmp (a0)
        jmp (a0)
L012_00000270:
; H012+$00000270: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00000274:
; H012+$00000274: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
; STATE: H005+$3364 = head of the party list
L012_0000027A:
; H012+$0000027A: 2b7900003364fff4  move.l $3364.l, -$c(a5)
        move.l (H005+$3364).l, -$c(a5)
L012_00000282:
; H012+$00000282: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L012_00000286:
; H012+$00000286: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000288:
; H012+$00000288: 1439000014d2  move.b $14d2.l, d2
        move.b (H061+$14D2).l, d2
L012_0000028E:
; H012+$0000028E: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L012_00000292:
; H012+$00000292: 6600001c  bne.w $2b0
        bne.w H012+$2B0
L012_00000296:
; H012+$00000296: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L012_0000029C:
; H012+$0000029C: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_000002A2:
; H012+$000002A2: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_000002A8:
; H012+$000002A8: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_000002AC:
; H012+$000002AC: 60000010  bra.w $2be
        bra.w H012+$2BE
L012_000002B0:
; H012+$000002B0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000002B4:
; H012+$000002B4: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000002BA:
; H012+$000002BA: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_000002BE:
; H012+$000002BE: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000002C2:
; H012+$000002C2: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000002C8:
; H012+$000002C8: 3b40fff8  move.w d0, -$8(a5)
        move.w d0, -$8(a5)
L012_000002CC:
; H012+$000002CC: 1f3900001454  move.b $1454.l, -(a7)
        move.b (H061+$1454).l, -(a7)
L012_000002D2:
; H012+$000002D2: 1f3900001494  move.b $1494.l, -(a7)
        move.b (H061+$1494).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_000002D8:
; H012+$000002D8: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_000002DE:
; H012+$000002DE: 3b40ffe6  move.w d0, -$1a(a5)
        move.w d0, -$1a(a5)
L012_000002E2:
; H012+$000002E2: 1f3900001455  move.b $1455.l, -(a7)
        move.b (H061+$1455).l, -(a7)
L012_000002E8:
; H012+$000002E8: 1f3900001495  move.b $1495.l, -(a7)
        move.b (H061+$1495).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_000002EE:
; H012+$000002EE: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_000002F4:
; H012+$000002F4: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L012_000002F8:
; H012+$000002F8: 1f3900001456  move.b $1456.l, -(a7)
        move.b (H061+$1456).l, -(a7)
L012_000002FE:
; H012+$000002FE: 1f3900001496  move.b $1496.l, -(a7)
        move.b (H061+$1496).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_00000304:
; H012+$00000304: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_0000030A:
; H012+$0000030A: 3b40ffe2  move.w d0, -$1e(a5)
        move.w d0, -$1e(a5)
L012_0000030E:
; H012+$0000030E: 1f3900001457  move.b $1457.l, -(a7)
        move.b (H061+$1457).l, -(a7)
L012_00000314:
; H012+$00000314: 1f3900001497  move.b $1497.l, -(a7)
        move.b (H061+$1497).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_0000031A:
; H012+$0000031A: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_00000320:
; H012+$00000320: 3b40ffe0  move.w d0, -$20(a5)
        move.w d0, -$20(a5)
L012_00000324:
; H012+$00000324: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L012_00000328:
; H012+$00000328: 426dffde  clr.w -$22(a5)
        clr.w -$22(a5)
L012_0000032C:
; H012+$0000032C: 3b7c00ffffe8  move.w #$ff, -$18(a5)
        move.w #$ff, -$18(a5)
L012_00000332:
; H012+$00000332: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L012_00000336:
; H012+$00000336: 046d3100fffe  subi.w #$3100, -$2(a5)
        subi.w #$3100, -$2(a5)
L012_0000033C:
; H012+$0000033C: 0c6d8400fffe  cmpi.w #$8400, -$2(a5)
        cmpi.w #$8400, -$2(a5)
L012_00000342:
; H012+$00000342: 6600000a  bne.w $34e
        bne.w H012+$34E
L012_00000346:
; H012+$00000346: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L012_0000034A:
; H012+$0000034A: 6000004a  bra.w $396
        bra.w H012+$396
L012_0000034E:
; H012+$0000034E: 0c6d0019fffe  cmpi.w #$19, -$2(a5)
        cmpi.w #$19, -$2(a5)
L012_00000354:
; H012+$00000354: 6600000c  bne.w $362
        bne.w H012+$362
L012_00000358:
; H012+$00000358: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L012_0000035E:
; H012+$0000035E: 60000036  bra.w $396
        bra.w H012+$396
L012_00000362:
; H012+$00000362: 0c6d00a4fffe  cmpi.w #$a4, -$2(a5)
        cmpi.w #$a4, -$2(a5)
L012_00000368:
; H012+$00000368: 6f00001c  ble.w $386
        ble.w H012+$386
L012_0000036C:
; H012+$0000036C: 0c6d00adfffe  cmpi.w #$ad, -$2(a5)
        cmpi.w #$ad, -$2(a5)
L012_00000372:
; H012+$00000372: 6c000012  bge.w $386
        bge.w H012+$386
L012_00000376:
; H012+$00000376: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_0000037A:
; H012+$0000037A: 044200a3  subi.w #$a3, d2
        subi.w #$a3, d2
L012_0000037E:
; H012+$0000037E: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L012_00000382:
; H012+$00000382: 60000012  bra.w $396
        bra.w H012+$396
L012_00000386:
; H012+$00000386: 0c6d009ffffe  cmpi.w #$9f, -$2(a5)
        cmpi.w #$9f, -$2(a5)
L012_0000038C:
; H012+$0000038C: 66000008  bne.w $396
        bne.w H012+$396
L012_00000390:
; H012+$00000390: 3b7c000afffc  move.w #$a, -$4(a5)
        move.w #$a, -$4(a5)
L012_00000396:
; H012+$00000396: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L012_0000039A:
; H012+$0000039A: 6000021e  bra.w $5ba
        bra.w H012+$5BA
L012_0000039E:
; H012+$0000039E: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L012_000003A2:
; H012+$000003A2: 6700002c  beq.w $3d0
        beq.w H012+$3D0
L012_000003A6:
; H012+$000003A6: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L012_000003AA:
; H012+$000003AA: 66000024  bne.w $3d0
        bne.w H012+$3D0
L012_000003AE:
; H012+$000003AE: 2f2dfff4  move.l -$c(a5), -(a7)
        move.l -$c(a5), -(a7)
L012_000003B2:
; H012+$000003B2: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L012_000003B6:
; H012+$000003B6: 486dffee  pea.l -$12(a5)
        pea.l -$12(a5)
; -> H063+$0946 (sub_H063_00000946)
L012_000003BA:
; H012+$000003BA: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L012_000003C0:
; H012+$000003C0: 1b40fff3  move.b d0, -$d(a5)
        move.b d0, -$d(a5)
L012_000003C4:
; H012+$000003C4: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_000003C8:
; H012+$000003C8: 2b6b018efff4  move.l $18e(a3), -$c(a5)
        move.l $18e(a3), -$c(a5)
L012_000003CE:
; H012+$000003CE: 60ce  bra.b $39e
        bra.b H012+$39E
L012_000003D0:
; H012+$000003D0: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L012_000003D4:
; H012+$000003D4: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
L012_000003D8:
; H012+$000003D8: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L012_000003DC:
; H012+$000003DC: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L012_000003DE:
; H012+$000003DE: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L012_000003E4:
; H012+$000003E4: 4855  pea.l (a5)
        pea.l (a5)
L012_000003E6:
; H012+$000003E6: 6100fe20  bsr.w $208
        bsr.w H012+$208
L012_000003EA:
; H012+$000003EA: 4e75  rts 
        rts 
L012_000003EC:
; H012+$000003EC: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L012_000003F0:
; H012+$000003F0: 67000060  beq.w $452
        beq.w H012+$452
L012_000003F4:
; H012+$000003F4: 526dffde  addq.w #$1, -$22(a5)
        addq.w #$1, -$22(a5)
L012_000003F8:
; H012+$000003F8: 7400  moveq #$0, d2
        moveq #0, d2
L012_000003FA:
; H012+$000003FA: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_000003FE:
; H012+$000003FE: 142b001b  move.b $1b(a3), d2
        move.b $1b(a3), d2
L012_00000402:
; H012+$00000402: b46dffea  cmp.w -$16(a5), d2
        cmp.w -$16(a5), d2
L012_00000406:
; H012+$00000406: 63000010  bls.w $418
        bls.w H012+$418
L012_0000040A:
; H012+$0000040A: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000040C:
; H012+$0000040C: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000410:
; H012+$00000410: 142b001b  move.b $1b(a3), d2
        move.b $1b(a3), d2
L012_00000414:
; H012+$00000414: 3b42ffea  move.w d2, -$16(a5)
        move.w d2, -$16(a5)
L012_00000418:
; H012+$00000418: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000041A:
; H012+$0000041A: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_0000041E:
; H012+$0000041E: 142b001b  move.b $1b(a3), d2
        move.b $1b(a3), d2
L012_00000422:
; H012+$00000422: b46dffe8  cmp.w -$18(a5), d2
        cmp.w -$18(a5), d2
L012_00000426:
; H012+$00000426: 64000010  bcc.w $438
        bcc.w H012+$438
L012_0000042A:
; H012+$0000042A: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000042C:
; H012+$0000042C: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000430:
; H012+$00000430: 142b001b  move.b $1b(a3), d2
        move.b $1b(a3), d2
L012_00000434:
; H012+$00000434: 3b42ffe8  move.w d2, -$18(a5)
        move.w d2, -$18(a5)
L012_00000438:
; H012+$00000438: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000043A:
; H012+$0000043A: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_0000043E:
; H012+$0000043E: 142b001b  move.b $1b(a3), d2
        move.b $1b(a3), d2
L012_00000442:
; H012+$00000442: d56dfffa  add.w d2, -$6(a5)
        add.w d2, -$6(a5)
L012_00000446:
; H012+$00000446: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_0000044A:
; H012+$0000044A: 2b6b018efff4  move.l $18e(a3), -$c(a5)
        move.l $18e(a3), -$c(a5)
L012_00000450:
; H012+$00000450: 609a  bra.b $3ec
        bra.b H012+$3EC
L012_00000452:
; H012+$00000452: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000454:
; H012+$00000454: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_00000458:
; H012+$00000458: 84edffde  divu.w -$22(a5), d2
        divu.w -$22(a5), d2
L012_0000045C:
; H012+$0000045C: 3b42ffec  move.w d2, -$14(a5)
        move.w d2, -$14(a5)
L012_00000460:
; H012+$00000460: 4855  pea.l (a5)
        pea.l (a5)
L012_00000462:
; H012+$00000462: 6100fda4  bsr.w $208
        bsr.w H012+$208
L012_00000466:
; H012+$00000466: 4e75  rts 
        rts 
L012_00000468:
; H012+$00000468: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_0000046C:
; H012+$0000046C: 044200a4  subi.w #$a4, d2
        subi.w #$a4, d2
L012_00000470:
; H012+$00000470: 3b42ffdc  move.w d2, -$24(a5)
        move.w d2, -$24(a5)
L012_00000474:
; H012+$00000474: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L012_00000478:
; H012+$00000478: 67000094  beq.w $50e
        beq.w H012+$50E
L012_0000047C:
; H012+$0000047C: 526dffde  addq.w #$1, -$22(a5)
        addq.w #$1, -$22(a5)
L012_00000480:
; H012+$00000480: 342dffdc  move.w -$24(a5), d2
        move.w -$24(a5), d2
L012_00000484:
; H012+$00000484: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00000486:
; H012+$00000486: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_0000048A:
; H012+$0000048A: 47eb00e0  lea.l $e0(a3), a3
        lea.l $e0(a3), a3
L012_0000048E:
; H012+$0000048E: 7800  moveq #$0, d4
        moveq #0, d4
L012_00000490:
; H012+$00000490: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L012_00000494:
; H012+$00000494: b86dffe8  cmp.w -$18(a5), d4
        cmp.w -$18(a5), d4
L012_00000498:
; H012+$00000498: 6400001a  bcc.w $4b4
        bcc.w H012+$4B4
L012_0000049C:
; H012+$0000049C: 342dffdc  move.w -$24(a5), d2
        move.w -$24(a5), d2
L012_000004A0:
; H012+$000004A0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000004A2:
; H012+$000004A2: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_000004A6:
; H012+$000004A6: 47eb00e0  lea.l $e0(a3), a3
        lea.l $e0(a3), a3
L012_000004AA:
; H012+$000004AA: 7800  moveq #$0, d4
        moveq #0, d4
L012_000004AC:
; H012+$000004AC: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L012_000004B0:
; H012+$000004B0: 3b44ffe8  move.w d4, -$18(a5)
        move.w d4, -$18(a5)
L012_000004B4:
; H012+$000004B4: 342dffdc  move.w -$24(a5), d2
        move.w -$24(a5), d2
L012_000004B8:
; H012+$000004B8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000004BA:
; H012+$000004BA: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_000004BE:
; H012+$000004BE: 47eb00e0  lea.l $e0(a3), a3
        lea.l $e0(a3), a3
L012_000004C2:
; H012+$000004C2: 7800  moveq #$0, d4
        moveq #0, d4
L012_000004C4:
; H012+$000004C4: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L012_000004C8:
; H012+$000004C8: b86dffea  cmp.w -$16(a5), d4
        cmp.w -$16(a5), d4
L012_000004CC:
; H012+$000004CC: 6300001a  bls.w $4e8
        bls.w H012+$4E8
L012_000004D0:
; H012+$000004D0: 342dffdc  move.w -$24(a5), d2
        move.w -$24(a5), d2
L012_000004D4:
; H012+$000004D4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000004D6:
; H012+$000004D6: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_000004DA:
; H012+$000004DA: 47eb00e0  lea.l $e0(a3), a3
        lea.l $e0(a3), a3
L012_000004DE:
; H012+$000004DE: 7800  moveq #$0, d4
        moveq #0, d4
L012_000004E0:
; H012+$000004E0: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L012_000004E4:
; H012+$000004E4: 3b44ffea  move.w d4, -$16(a5)
        move.w d4, -$16(a5)
L012_000004E8:
; H012+$000004E8: 342dffdc  move.w -$24(a5), d2
        move.w -$24(a5), d2
L012_000004EC:
; H012+$000004EC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000004EE:
; H012+$000004EE: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_000004F2:
; H012+$000004F2: 47eb00e0  lea.l $e0(a3), a3
        lea.l $e0(a3), a3
L012_000004F6:
; H012+$000004F6: 7800  moveq #$0, d4
        moveq #0, d4
L012_000004F8:
; H012+$000004F8: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L012_000004FC:
; H012+$000004FC: d96dfffa  add.w d4, -$6(a5)
        add.w d4, -$6(a5)
L012_00000500:
; H012+$00000500: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000504:
; H012+$00000504: 2b6b018efff4  move.l $18e(a3), -$c(a5)
        move.l $18e(a3), -$c(a5)
L012_0000050A:
; H012+$0000050A: 6000ff68  bra.w $474
        bra.w H012+$474
L012_0000050E:
; H012+$0000050E: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000510:
; H012+$00000510: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_00000514:
; H012+$00000514: 84edffde  divu.w -$22(a5), d2
        divu.w -$22(a5), d2
L012_00000518:
; H012+$00000518: 3b42ffec  move.w d2, -$14(a5)
        move.w d2, -$14(a5)
L012_0000051C:
; H012+$0000051C: 4855  pea.l (a5)
        pea.l (a5)
L012_0000051E:
; H012+$0000051E: 6100fce8  bsr.w $208
        bsr.w H012+$208
L012_00000522:
; H012+$00000522: 4e75  rts 
        rts 
L012_00000524:
; H012+$00000524: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L012_00000528:
; H012+$00000528: 67000060  beq.w $58a
        beq.w H012+$58A
L012_0000052C:
; H012+$0000052C: 526dffde  addq.w #$1, -$22(a5)
        addq.w #$1, -$22(a5)
L012_00000530:
; H012+$00000530: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000532:
; H012+$00000532: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000536:
; H012+$00000536: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L012_0000053A:
; H012+$0000053A: b46dffe8  cmp.w -$18(a5), d2
        cmp.w -$18(a5), d2
L012_0000053E:
; H012+$0000053E: 64000010  bcc.w $550
        bcc.w H012+$550
L012_00000542:
; H012+$00000542: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000544:
; H012+$00000544: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000548:
; H012+$00000548: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L012_0000054C:
; H012+$0000054C: 3b42ffe8  move.w d2, -$18(a5)
        move.w d2, -$18(a5)
L012_00000550:
; H012+$00000550: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000552:
; H012+$00000552: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000556:
; H012+$00000556: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L012_0000055A:
; H012+$0000055A: b46dffea  cmp.w -$16(a5), d2
        cmp.w -$16(a5), d2
L012_0000055E:
; H012+$0000055E: 63000010  bls.w $570
        bls.w H012+$570
L012_00000562:
; H012+$00000562: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000564:
; H012+$00000564: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000568:
; H012+$00000568: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L012_0000056C:
; H012+$0000056C: 3b42ffea  move.w d2, -$16(a5)
        move.w d2, -$16(a5)
L012_00000570:
; H012+$00000570: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000572:
; H012+$00000572: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000576:
; H012+$00000576: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L012_0000057A:
; H012+$0000057A: d56dfffa  add.w d2, -$6(a5)
        add.w d2, -$6(a5)
L012_0000057E:
; H012+$0000057E: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00000582:
; H012+$00000582: 2b6b018efff4  move.l $18e(a3), -$c(a5)
        move.l $18e(a3), -$c(a5)
L012_00000588:
; H012+$00000588: 609a  bra.b $524
        bra.b H012+$524
L012_0000058A:
; H012+$0000058A: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000058C:
; H012+$0000058C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_00000590:
; H012+$00000590: 84edffde  divu.w -$22(a5), d2
        divu.w -$22(a5), d2
L012_00000594:
; H012+$00000594: 3b42ffec  move.w d2, -$14(a5)
        move.w d2, -$14(a5)
L012_00000598:
; H012+$00000598: 4855  pea.l (a5)
        pea.l (a5)
L012_0000059A:
; H012+$0000059A: 6100fc6c  bsr.w $208
        bsr.w H012+$208
L012_0000059E:
; H012+$0000059E: 4e75  rts 
        rts 
L012_000005A0:
; H012+$000005A0: 4e75  rts 
        rts 
; Preserved bytes H012+$000005A2..$000005BA; code/data not fully classified.
        dc.w $FFFC,$FDFA,$FE48,$FEC4,$FEC4,$FEC4,$FEC4,$FEC4
        dc.w $FEC4,$FEC4,$FEC4,$FF80
L012_000005BA:
; H012+$000005BA: 47faffe8  lea.l $5a4(pc), a3
        lea.l H012+$5A4(pc), a3
L012_000005BE:
; H012+$000005BE: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L012_000005C2:
; H012+$000005C2: 6302  bls.b $5c6
        bls.b H012+$5C6
L012_000005C4:
; H012+$000005C4: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_000005C6:
; H012+$000005C6: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_000005C8:
; H012+$000005C8: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$05A4; indices 0..10, default -1.
L012_000005CC:
; H012+$000005CC: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_000005D0:
; H012+$000005D0: 4e5d  unlk a5
        unlk a5
L012_000005D2:
; H012+$000005D2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_000005D4:
; H012+$000005D4: 4e75  rts 
        rts 
; FUNCTION: ECL_34_PARTY_SURPRISE
FN_ECL_34_PARTY_SURPRISE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_34 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 34=PARTY SURPRISE.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2EC6
; --------------------------------------------------------------------------
L012_000005D6:
; H012+$000005D6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_000005D8:
; H012+$000005D8: 287afb9a  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_000005DC:
; H012+$000005DC: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L012_000005E0:
; H012+$000005E0: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000005E4:
; H012+$000005E4: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
; STATE: H005+$3364 = head of the party list
L012_000005EA:
; H012+$000005EA: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L012_000005F2:
; H012+$000005F2: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L012_000005F6:
; H012+$000005F6: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L012_000005FA:
; H012+$000005FA: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L012_000005FE:
; H012+$000005FE: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L012_00000602:
; H012+$00000602: 67000036  beq.w $63a
        beq.w H012+$63A
L012_00000606:
; H012+$00000606: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L012_0000060A:
; H012+$0000060A: 0c2b0004005c  cmpi.b #$4, $5c(a3)
        cmpi.b #$4, $5c(a3)
L012_00000610:
; H012+$00000610: 67000010  beq.w $622
        beq.w H012+$622
L012_00000614:
; H012+$00000614: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L012_00000618:
; H012+$00000618: 0c2b000a005c  cmpi.b #$a, $5c(a3)
        cmpi.b #$a, $5c(a3)
L012_0000061E:
; H012+$0000061E: 6600000e  bne.w $62e
        bne.w H012+$62E
L012_00000622:
; H012+$00000622: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L012_00000628:
; H012+$00000628: 1b7c0001fff7  move.b #$1, -$9(a5)
        move.b #$1, -$9(a5)
L012_0000062E:
; H012+$0000062E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L012_00000632:
; H012+$00000632: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L012_00000638:
; H012+$00000638: 60c4  bra.b $5fe
        bra.b H012+$5FE
L012_0000063A:
; H012+$0000063A: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L012_00000640:
; H012+$00000640: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_00000646:
; H012+$00000646: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_0000064C:
; H012+$0000064C: 3b40fff4  move.w d0, -$c(a5)
        move.w d0, -$c(a5)
L012_00000650:
; H012+$00000650: 1f3900001453  move.b $1453.l, -(a7)
        move.b (H061+$1453).l, -(a7)
L012_00000656:
; H012+$00000656: 1f3900001493  move.b $1493.l, -(a7)
        move.b (H061+$1493).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_0000065C:
; H012+$0000065C: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_00000662:
; H012+$00000662: 3b40fff2  move.w d0, -$e(a5)
        move.w d0, -$e(a5)
L012_00000666:
; H012+$00000666: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L012_0000066A:
; H012+$0000066A: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_0000066E:
; H012+$0000066E: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00000674:
; H012+$00000674: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L012_00000678:
; H012+$00000678: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_0000067C:
; H012+$0000067C: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00000682:
; H012+$00000682: 4e5d  unlk a5
        unlk a5
L012_00000684:
; H012+$00000684: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00000686:
; H012+$00000686: 4e75  rts 
        rts 
; FUNCTION: ECL_35_SURPRISE
FN_ECL_35_SURPRISE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_35 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 35=SURPRISE.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2ECC
; --------------------------------------------------------------------------
L012_00000688:
; H012+$00000688: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_0000068A:
; H012+$0000068A: 287afae8  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_0000068E:
; H012+$0000068E: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L012_00000692:
; H012+$00000692: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00000696:
; H012+$00000696: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_0000069C:
; H012+$0000069C: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L012_000006A0:
; H012+$000006A0: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L012_000006A6:
; H012+$000006A6: 0c6d0004fffa  cmpi.w #$4, -$6(a5)
        cmpi.w #$4, -$6(a5)
L012_000006AC:
; H012+$000006AC: 6200002a  bhi.w $6d8
        bhi.w H012+$6D8
L012_000006B0:
; H012+$000006B0: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_000006B4:
; H012+$000006B4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000006B6:
; H012+$000006B6: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_000006B8:
; H012+$000006B8: 47edfff0  lea.l -$10(a5), a3
        lea.l -$10(a5), a3
L012_000006BC:
; H012+$000006BC: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L012_000006C0:
; H012+$000006C0: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000006C4:
; H012+$000006C4: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000006CA:
; H012+$000006CA: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L012_000006CE:
; H012+$000006CE: 37802000  move.w d0, (a3, d2.w)
        move.w d0, (a3, d2.w)
L012_000006D2:
; H012+$000006D2: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L012_000006D6:
; H012+$000006D6: 64ce  bcc.b $6a6
        bcc.b H012+$6A6
L012_000006D8:
; H012+$000006D8: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L012_000006DC:
; H012+$000006DC: 5442  addq.w #$2, d2
        addq.w #$2, d2
L012_000006DE:
; H012+$000006DE: 946dfff0  sub.w -$10(a5), d2
        sub.w -$10(a5), d2
L012_000006E2:
; H012+$000006E2: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L012_000006E6:
; H012+$000006E6: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L012_000006EA:
; H012+$000006EA: 5442  addq.w #$2, d2
        addq.w #$2, d2
L012_000006EC:
; H012+$000006EC: 946dfff4  sub.w -$c(a5), d2
        sub.w -$c(a5), d2
L012_000006F0:
; H012+$000006F0: 3b42ffec  move.w d2, -$14(a5)
        move.w d2, -$14(a5)
L012_000006F4:
; H012+$000006F4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_000006F8:
; H012+$000006F8: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_000006FC:
; H012+$000006FC: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00000702:
; H012+$00000702: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_00000706:
; H012+$00000706: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_0000070A:
; H012+$0000070A: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_0000070E:
; H012+$0000070E: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00000714:
; H012+$00000714: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L012_00000718:
; H012+$00000718: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_0000071C:
; H012+$0000071C: b46dffee  cmp.w -$12(a5), d2
        cmp.w -$12(a5), d2
L012_00000720:
; H012+$00000720: 6e00001e  bgt.w $740
        bgt.w H012+$740
L012_00000724:
; H012+$00000724: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L012_00000728:
; H012+$00000728: b46dffec  cmp.w -$14(a5), d2
        cmp.w -$14(a5), d2
L012_0000072C:
; H012+$0000072C: 6e00000c  bgt.w $73a
        bgt.w H012+$73A
L012_00000730:
; H012+$00000730: 3b7c0003fff8  move.w #$3, -$8(a5)
        move.w #$3, -$8(a5)
L012_00000736:
; H012+$00000736: 60000008  bra.w $740
        bra.w H012+$740
L012_0000073A:
; H012+$0000073A: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L012_00000740:
; H012+$00000740: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L012_00000744:
; H012+$00000744: b46dffec  cmp.w -$14(a5), d2
        cmp.w -$14(a5), d2
L012_00000748:
; H012+$00000748: 6e000008  bgt.w $752
        bgt.w H012+$752
L012_0000074C:
; H012+$0000074C: 3b7c0002fff8  move.w #$2, -$8(a5)
        move.w #$2, -$8(a5)
L012_00000752:
; H012+$00000752: 3f3c02cb  move.w #$2cb, -(a7)
        move.w #$2cb, -(a7)
L012_00000756:
; H012+$00000756: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_0000075A:
; H012+$0000075A: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00000760:
; H012+$00000760: 4e5d  unlk a5
        unlk a5
L012_00000762:
; H012+$00000762: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00000764:
; H012+$00000764: 4e75  rts 
        rts 
; FUNCTION: ECL_36_COMBAT
FN_ECL_36_COMBAT:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_36 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 36=COMBAT.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2ED2
; --------------------------------------------------------------------------
L012_00000766:
; H012+$00000766: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00000768:
; H012+$00000768: 287afa0a  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_0000076C:
; H012+$0000076C: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L012_00000770:
; H012+$00000770: 4239000024ae  clr.b $24ae.l
        clr.b (H005+$24AE).l
L012_00000776:
; H012+$00000776: 1b79000024b0fff8  move.b $24b0.l, -$8(a5)
        move.b (H005+$24B0).l, -$8(a5)
L012_0000077E:
; H012+$0000077E: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L012_00000784:
; H012+$00000784: 1b7c0001fff9  move.b #$1, -$7(a5)
        move.b #$1, -$7(a5)
; STATE: H005+$3DEA = logical ECL PC
L012_0000078A:
; H012+$0000078A: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L012_00000790:
; H012+$00000790: 4a39000024b6  tst.b $24b6.l
        tst.b (H005+$24B6).l
L012_00000796:
; H012+$00000796: 660001d6  bne.w $96e
        bne.w H012+$96E
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_0000079A:
; H012+$0000079A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000007A0:
; H012+$000007A0: 0c6b000106d8  cmpi.w #$1, $6d8(a3)
        cmpi.w #$1, $6d8(a3)
L012_000007A6:
; H012+$000007A6: 66000098  bne.w $840
        bne.w H012+$840
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000007AA:
; H012+$000007AA: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000007B0:
; H012+$000007B0: 426b06d8  clr.w $6d8(a3)
        clr.w $6d8(a3)
L012_000007B4:
; H012+$000007B4: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000007BA:
; H012+$000007BA: 6700000c  beq.w $7c8
        beq.w H012+$7C8
L012_000007BE:
; H012+$000007BE: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_000007C2:
; H012+$000007C2: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_000007C8:
; H012+$000007C8: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000007CE:
; H012+$000007CE: 66000008  bne.w $7d8
        bne.w H012+$7D8
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_000007D2:
; H012+$000007D2: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
; -> H071+$092C (sub_H071_0000092C)
L012_000007D8:
; H012+$000007D8: 4eb90000092c  jsr $92c.l
        jsr (H071+$92C).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_000007DE:
; H012+$000007DE: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_000007E4:
; H012+$000007E4: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_000007E8:
; H012+$000007E8: 6600002e  bne.w $818
        bne.w H012+$818
L012_000007EC:
; H012+$000007EC: 422dfff9  clr.b -$7(a5)
        clr.b -$7(a5)
L012_000007F0:
; H012+$000007F0: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000007F6:
; H012+$000007F6: 6700000c  beq.w $804
        beq.w H012+$804
L012_000007FA:
; H012+$000007FA: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_000007FE:
; H012+$000007FE: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_00000804:
; H012+$00000804: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_0000080A:
; H012+$0000080A: 66000008  bne.w $814
        bne.w H012+$814
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_0000080E:
; H012+$0000080E: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L012_00000814:
; H012+$00000814: 60000026  bra.w $83c
        bra.w H012+$83C
L012_00000818:
; H012+$00000818: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_0000081E:
; H012+$0000081E: 6700000c  beq.w $82c
        beq.w H012+$82C
L012_00000822:
; H012+$00000822: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00000826:
; H012+$00000826: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_0000082C:
; H012+$0000082C: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000832:
; H012+$00000832: 66000008  bne.w $83c
        bne.w H012+$83C
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_00000836:
; H012+$00000836: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L012_0000083C:
; H012+$0000083C: 6000012c  bra.w $96a
        bra.w H012+$96A
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00000840:
; H012+$00000840: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00000846:
; H012+$00000846: 0c6b000105c4  cmpi.w #$1, $5c4(a3)
        cmpi.w #$1, $5c4(a3)
L012_0000084C:
; H012+$0000084C: 66000098  bne.w $8e6
        bne.w H012+$8E6
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00000850:
; H012+$00000850: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00000856:
; H012+$00000856: 426b05c4  clr.w $5c4(a3)
        clr.w $5c4(a3)
L012_0000085A:
; H012+$0000085A: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000860:
; H012+$00000860: 6700000c  beq.w $86e
        beq.w H012+$86E
L012_00000864:
; H012+$00000864: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00000868:
; H012+$00000868: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_0000086E:
; H012+$0000086E: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000874:
; H012+$00000874: 66000008  bne.w $87e
        bne.w H012+$87E
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_00000878:
; H012+$00000878: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
; -> H072+$120C (sub_H072_0000120C)
L012_0000087E:
; H012+$0000087E: 4eb90000120c  jsr $120c.l
        jsr (H072+$120C).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00000884:
; H012+$00000884: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_0000088A:
; H012+$0000088A: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_0000088E:
; H012+$0000088E: 6600002e  bne.w $8be
        bne.w H012+$8BE
L012_00000892:
; H012+$00000892: 422dfff9  clr.b -$7(a5)
        clr.b -$7(a5)
L012_00000896:
; H012+$00000896: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_0000089C:
; H012+$0000089C: 6700000c  beq.w $8aa
        beq.w H012+$8AA
L012_000008A0:
; H012+$000008A0: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_000008A4:
; H012+$000008A4: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_000008AA:
; H012+$000008AA: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000008B0:
; H012+$000008B0: 66000008  bne.w $8ba
        bne.w H012+$8BA
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_000008B4:
; H012+$000008B4: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L012_000008BA:
; H012+$000008BA: 60000026  bra.w $8e2
        bra.w H012+$8E2
L012_000008BE:
; H012+$000008BE: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000008C4:
; H012+$000008C4: 6700000c  beq.w $8d2
        beq.w H012+$8D2
L012_000008C8:
; H012+$000008C8: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_000008CC:
; H012+$000008CC: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_000008D2:
; H012+$000008D2: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000008D8:
; H012+$000008D8: 66000008  bne.w $8e2
        bne.w H012+$8E2
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_000008DC:
; H012+$000008DC: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L012_000008E2:
; H012+$000008E2: 60000086  bra.w $96a
        bra.w H012+$96A
L012_000008E6:
; H012+$000008E6: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000008EC:
; H012+$000008EC: 6700000c  beq.w $8fa
        beq.w H012+$8FA
L012_000008F0:
; H012+$000008F0: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_000008F4:
; H012+$000008F4: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_000008FA:
; H012+$000008FA: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000900:
; H012+$00000900: 66000008  bne.w $90a
        bne.w H012+$90A
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_00000904:
; H012+$00000904: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
; -> H070+$1958 (sub_H070_00001958)
L012_0000090A:
; H012+$0000090A: 4eb900001958  jsr $1958.l
        jsr (H070+$1958).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00000910:
; H012+$00000910: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00000916:
; H012+$00000916: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_0000091A:
; H012+$0000091A: 6600002a  bne.w $946
        bne.w H012+$946
L012_0000091E:
; H012+$0000091E: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000924:
; H012+$00000924: 6700000c  beq.w $932
        beq.w H012+$932
L012_00000928:
; H012+$00000928: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_0000092C:
; H012+$0000092C: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_00000932:
; H012+$00000932: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000938:
; H012+$00000938: 66000008  bne.w $942
        bne.w H012+$942
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_0000093C:
; H012+$0000093C: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L012_00000942:
; H012+$00000942: 60000026  bra.w $96a
        bra.w H012+$96A
L012_00000946:
; H012+$00000946: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_0000094C:
; H012+$0000094C: 6700000c  beq.w $95a
        beq.w H012+$95A
L012_00000950:
; H012+$00000950: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00000954:
; H012+$00000954: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_0000095A:
; H012+$0000095A: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000960:
; H012+$00000960: 66000008  bne.w $96a
        bne.w H012+$96A
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_00000964:
; H012+$00000964: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L012_0000096A:
; H012+$0000096A: 60000100  bra.w $a6c
        bra.w H012+$A6C
L012_0000096E:
; H012+$0000096E: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000974:
; H012+$00000974: 6700000c  beq.w $982
        beq.w H012+$982
L012_00000978:
; H012+$00000978: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_0000097C:
; H012+$0000097C: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_00000982:
; H012+$00000982: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000988:
; H012+$00000988: 66000008  bne.w $992
        bne.w H012+$992
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_0000098C:
; H012+$0000098C: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
; STATE: H005+$281C = start of the coordinates/view block
L012_00000992:
; H012+$00000992: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L012_00000998:
; H012+$00000998: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
L012_0000099E:
; H012+$0000099E: 1f3900002820  move.b $2820.l, -(a7)
        move.b (H005+$2820).l, -(a7)
; -> H061+$1C42 (sub_H061_00001C42)
L012_000009A4:
; H012+$000009A4: 4eb900001c42  jsr $1c42.l
        jsr (H061+$1C42).l
L012_000009AA:
; H012+$000009AA: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_000009AE:
; H012+$000009AE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000009B2:
; H012+$000009B2: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000009B8:
; H012+$000009B8: b46b0582  cmp.w $582(a3), d2
        cmp.w $582(a3), d2
L012_000009BC:
; H012+$000009BC: 6400000e  bcc.w $9cc
        bcc.w H012+$9CC
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000009C0:
; H012+$000009C0: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000009C6:
; H012+$000009C6: 376dfffe0582  move.w -$2(a5), $582(a3)
        move.w -$2(a5), $582(a3)
L012_000009CC:
; H012+$000009CC: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLOW: Calls Free_Sequence (H042+$0300).
L012_000009D2:
; H012+$000009D2: 4eb900000300  jsr $300.l
        jsr (H042+$300).l
; STEP: The COMBAT command enters the tactical loop H059+$1782 here.
; FLOW: Calls Combat_MainLoop (H059+$1782).
L012_000009D8:
; H012+$000009D8: 4eb900001782  jsr $1782.l
        jsr (H059+$1782).l
L012_000009DE:
; H012+$000009DE: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000009E4:
; H012+$000009E4: 6700000c  beq.w $9f2
        beq.w H012+$9F2
L012_000009E8:
; H012+$000009E8: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_000009EC:
; H012+$000009EC: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
; -> H070+$1958 (sub_H070_00001958)
L012_000009F2:
; H012+$000009F2: 4eb900001958  jsr $1958.l
        jsr (H070+$1958).l
L012_000009F8:
; H012+$000009F8: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_000009FE:
; H012+$000009FE: 66000008  bne.w $a08
        bne.w H012+$A08
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_00000A02:
; H012+$00000A02: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00000A08:
; H012+$00000A08: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00000A0E:
; H012+$00000A0E: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_00000A12:
; H012+$00000A12: 66000034  bne.w $a48
        bne.w H012+$A48
L012_00000A16:
; H012+$00000A16: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000A1C:
; H012+$00000A1C: 6700000c  beq.w $a2a
        beq.w H012+$A2A
L012_00000A20:
; H012+$00000A20: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00000A24:
; H012+$00000A24: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_00000A2A:
; H012+$00000A2A: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000A30:
; H012+$00000A30: 66000008  bne.w $a3a
        bne.w H012+$A3A
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_00000A34:
; H012+$00000A34: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L012_00000A3A:
; H012+$00000A3A: 3f3c0079  move.w #$79, -(a7)
        move.w #$79, -(a7)
; FLOW: Calls Load_BigPicture (H042+$1006).
L012_00000A3E:
; H012+$00000A3E: 4eb900001006  jsr $1006.l
        jsr (H042+$1006).l
L012_00000A44:
; H012+$00000A44: 60000026  bra.w $a6c
        bra.w H012+$A6C
L012_00000A48:
; H012+$00000A48: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000A4E:
; H012+$00000A4E: 6700000c  beq.w $a5c
        beq.w H012+$A5C
L012_00000A52:
; H012+$00000A52: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00000A56:
; H012+$00000A56: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_00000A5C:
; H012+$00000A5C: 4a39000024a7  tst.b $24a7.l
        tst.b (H005+$24A7).l
L012_00000A62:
; H012+$00000A62: 66000008  bne.w $a6c
        bne.w H012+$A6C
; FLOW: Calls Audio_Initialize (H043+$0584).
L012_00000A66:
; H012+$00000A66: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00000A6C:
; H012+$00000A6C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00000A72:
; H012+$00000A72: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_00000A76:
; H012+$00000A76: 6600000e  bne.w $a86
        bne.w H012+$A86
; STATE: H005+$3DE3 = native context, 5 in combat
L012_00000A7A:
; H012+$00000A7A: 13fc000300003de3  move.b #$3, $3de3.l
        move.b #$3, (H005+$3DE3).l
L012_00000A82:
; H012+$00000A82: 6000000a  bra.w $a8e
        bra.w H012+$A8E
; STATE: H005+$3DE3 = native context, 5 in combat
L012_00000A86:
; H012+$00000A86: 13fc000400003de3  move.b #$4, $3de3.l
        move.b #$4, (H005+$3DE3).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00000A8E:
; H012+$00000A8E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00000A94:
; H012+$00000A94: 342b0594  move.w $594(a3), d2
        move.w $594(a3), d2
L012_00000A98:
; H012+$00000A98: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00000A9A:
; H012+$00000A9A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_00000A9E:
; H012+$00000A9E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_00000AA4:
; H012+$00000AA4: 1400  move.b d0, d2
        move.b d0, d2
L012_00000AA6:
; H012+$00000AA6: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00000AAA:
; H012+$00000AAA: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00000AB0:
; H012+$00000AB0: 37420594  move.w d2, $594(a3)
        move.w d2, $594(a3)
L012_00000AB4:
; H012+$00000AB4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00000AB8:
; H012+$00000AB8: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
L012_00000ABE:
; H012+$00000ABE: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L012_00000AC2:
; H012+$00000AC2: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L012_00000AC4:
; H012+$00000AC4: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L012_00000ACA:
; H012+$00000ACA: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
L012_00000AD0:
; H012+$00000AD0: 4a2dfff9  tst.b -$7(a5)
        tst.b -$7(a5)
L012_00000AD4:
; H012+$00000AD4: 67000034  beq.w $b0a
        beq.w H012+$B0A
; -> H063+$321A (trampoline_H063_3384)
L012_00000AD8:
; H012+$00000AD8: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00000ADE:
; H012+$00000ADE: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00000AE4:
; H012+$00000AE4: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_00000AE8:
; H012+$00000AE8: 66000020  bne.w $b0a
        bne.w H012+$B0A
; STATE: H005+$24D0 = request to exit the scenario loop
L012_00000AEC:
; H012+$00000AEC: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_00000AF2:
; H012+$00000AF2: 66000016  bne.w $b0a
        bne.w H012+$B0A
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00000AF6:
; H012+$00000AF6: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00000AFC:
; H012+$00000AFC: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L012_00000B00:
; H012+$00000B00: 66000008  bne.w $b0a
        bne.w H012+$B0A
; -> H069+$0012 (sub_H069_00000012)
L012_00000B04:
; H012+$00000B04: 4eb900000012  jsr $12.l
        jsr (H069+$12).l
L012_00000B0A:
; H012+$00000B0A: 13edfff8000024b0  move.b -$8(a5), $24b0.l
        move.b -$8(a5), (H005+$24B0).l
L012_00000B12:
; H012+$00000B12: 4e5d  unlk a5
        unlk a5
L012_00000B14:
; H012+$00000B14: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00000B16:
; H012+$00000B16: 4e75  rts 
        rts 
; FUNCTION: ECL_37_ON_GOTO__38_ON_GOSUB
FN_ECL_37_ON_GOTO__38_ON_GOSUB:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_37 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 37=ON GOTO, 38=ON GOSUB.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2ED8
; --------------------------------------------------------------------------
L012_00000B18:
; H012+$00000B18: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00000B1A:
; H012+$00000B1A: 287af658  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00000B1E:
; H012+$00000B1E: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L012_00000B22:
; H012+$00000B22: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L012_00000B26:
; H012+$00000B26: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00000B2A:
; H012+$00000B2A: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00000B30:
; H012+$00000B30: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00000B34:
; H012+$00000B34: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00000B3A:
; H012+$00000B3A: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_00000B3E:
; H012+$00000B3E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00000B42:
; H012+$00000B42: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00000B48:
; H012+$00000B48: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
; STATE: H005+$3DEA = logical ECL PC
L012_00000B4C:
; H012+$00000B4C: 537900003dea  subq.w #$1, $3dea.l
        subq.w #$1, (H005+$3DEA).l
L012_00000B52:
; H012+$00000B52: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00000B56:
; H012+$00000B56: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00000B5C:
; H012+$00000B5C: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L012_00000B60:
; H012+$00000B60: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L012_00000B64:
; H012+$00000B64: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L012_00000B68:
; H012+$00000B68: 6400007a  bcc.w $be4
        bcc.w H012+$BE4
L012_00000B6C:
; H012+$00000B6C: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L012_00000B70:
; H012+$00000B70: 66000072  bne.w $be4
        bne.w H012+$BE4
L012_00000B74:
; H012+$00000B74: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00000B78:
; H012+$00000B78: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L012_00000B7C:
; H012+$00000B7C: 6600005e  bne.w $bdc
        bne.w H012+$BDC
L012_00000B80:
; H012+$00000B80: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$2493 = current ECL opcode
L012_00000B82:
; H012+$00000B82: 143900002493  move.b $2493.l, d2
        move.b (H005+$2493).l, d2
L012_00000B88:
; H012+$00000B88: 0c420025  cmpi.w #$25, d2
        cmpi.w #$25, d2
L012_00000B8C:
; H012+$00000B8C: 66000036  bne.w $bc4
        bne.w H012+$BC4
L012_00000B90:
; H012+$00000B90: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L012_00000B94:
; H012+$00000B94: 5242  addq.w #$1, d2
        addq.w #$1, d2
L012_00000B96:
; H012+$00000B96: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00000B98:
; H012+$00000B98: 47f900001452  lea.l $1452.l, a3
        lea.l (H061+$1452).l, a3
L012_00000B9E:
; H012+$00000B9E: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L012_00000BA2:
; H012+$00000BA2: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L012_00000BA6:
; H012+$00000BA6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L012_00000BA8:
; H012+$00000BA8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00000BAA:
; H012+$00000BAA: 47f900001492  lea.l $1492.l, a3
        lea.l (H061+$1492).l, a3
L012_00000BB0:
; H012+$00000BB0: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_00000BB4:
; H012+$00000BB4: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
; STATE: H005+$3DEA = logical ECL PC
L012_00000BBA:
; H012+$00000BBA: 33c000003dea  move.w d0, $3dea.l
        move.w d0, (H005+$3DEA).l
L012_00000BC0:
; H012+$00000BC0: 60000010  bra.w $bd2
        bra.w H012+$BD2
L012_00000BC4:
; H012+$00000BC4: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L012_00000BC8:
; H012+$00000BC8: 5242  addq.w #$1, d2
        addq.w #$1, d2
L012_00000BCA:
; H012+$00000BCA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H061+$3AAC (sub_H061_00003AAC)
L012_00000BCC:
; H012+$00000BCC: 4eb900003aac  jsr $3aac.l
        jsr (H061+$3AAC).l
L012_00000BD2:
; H012+$00000BD2: 1b7c0001fff7  move.b #$1, -$9(a5)
        move.b #$1, -$9(a5)
L012_00000BD8:
; H012+$00000BD8: 60000006  bra.w $be0
        bra.w H012+$BE0
L012_00000BDC:
; H012+$00000BDC: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L012_00000BE0:
; H012+$00000BE0: 6000ff7e  bra.w $b60
        bra.w H012+$B60
L012_00000BE4:
; H012+$00000BE4: 4e5d  unlk a5
        unlk a5
L012_00000BE6:
; H012+$00000BE6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00000BE8:
; H012+$00000BE8: 4e75  rts 
        rts 
; FUNCTION: ECL_39_TREASURE
FN_ECL_39_TREASURE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_39 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 39=TREASURE.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2EDE
; --------------------------------------------------------------------------
L012_00000BEA:
; H012+$00000BEA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00000BEC:
; H012+$00000BEC: 287af586  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00000BF0:
; H012+$00000BF0: 4e55ff78  link.w a5, #$ff78
        link.w a5, #$ff78
L012_00000BF4:
; H012+$00000BF4: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00000BF8:
; H012+$00000BF8: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00000BFE:
; H012+$00000BFE: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L012_00000C02:
; H012+$00000C02: 0c6d0006fffe  cmpi.w #$6, -$2(a5)
        cmpi.w #$6, -$2(a5)
L012_00000C08:
; H012+$00000C08: 62000038  bhi.w $c42
        bhi.w H012+$C42
L012_00000C0C:
; H012+$00000C0C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00000C10:
; H012+$00000C10: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_00000C14:
; H012+$00000C14: e542  asl.w #$2, d2
        asl.w #$2, d2
L012_00000C16:
; H012+$00000C16: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L012_00000C1C:
; H012+$00000C1C: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L012_00000C20:
; H012+$00000C20: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L012_00000C24:
; H012+$00000C24: 5244  addq.w #$1, d4
        addq.w #$1, d4
L012_00000C26:
; H012+$00000C26: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00000C28:
; H012+$00000C28: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00000C2E:
; H012+$00000C2E: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L012_00000C32:
; H012+$00000C32: 02800000ffff  andi.l #$ffff, d0
        andi.l #$ffff, d0
L012_00000C38:
; H012+$00000C38: 27802000  move.l d0, (a3, d2.w)
        move.l d0, (a3, d2.w)
L012_00000C3C:
; H012+$00000C3C: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L012_00000C40:
; H012+$00000C40: 64c0  bcc.b $c02
        bcc.b H012+$C02
L012_00000C42:
; H012+$00000C42: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00000C46:
; H012+$00000C46: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00000C4C:
; H012+$00000C4C: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L012_00000C50:
; H012+$00000C50: 0c6d0080fffc  cmpi.w #$80, -$4(a5)
        cmpi.w #$80, -$4(a5)
L012_00000C56:
; H012+$00000C56: 640002fc  bcc.w $f54
        bcc.w H012+$F54
L012_00000C5A:
; H012+$00000C5A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00000C5E:
; H012+$00000C5E: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L012_00000C62:
; H012+$00000C62: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$246E = resource group selector
L012_00000C64:
; H012+$00000C64: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L012_00000C6A:
; H012+$00000C6A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L012_00000C6C:
; H012+$00000C6C: 4227  clr.b -(a7)
        clr.b -(a7)
L012_00000C6E:
; H012+$00000C6E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00000C72:
; H012+$00000C72: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00000C76:
; H012+$00000C76: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L012_00000C7A:
; H012+$00000C7A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L012_00000C80:
; H012+$00000C80: 47ec0000  lea.l $0(a4), a3
        lea.l $0(a4), a3
L012_00000C84:
; H012+$00000C84: 45f90000000c  lea.l $c.l, a2
        lea.l (H064+$C).l, a2
L012_00000C8A:
; H012+$00000C8A: 7450  moveq #$50, d2
        moveq #80, d2
L012_00000C8C:
; H012+$00000C8C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L012_00000C8E:
; H012+$00000C8E: 57cafffc  dbeq d2, $c8c
        dbeq d2, H012+$C8C
L012_00000C92:
; H012+$00000C92: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_00000C96:
; H012+$00000C96: 48790000000c  pea.l $c.l
        pea.l (H064+$C).l
L012_00000C9C:
; H012+$00000C9C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00000CA0:
; H012+$00000CA0: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L012_00000CA4:
; H012+$00000CA4: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L012_00000CAA:
; H012+$00000CAA: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_00000CAE:
; H012+$00000CAE: 48790000000c  pea.l $c.l
        pea.l (H064+$C).l
L012_00000CB4:
; H012+$00000CB4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L012_00000CB8:
; H012+$00000CB8: 486c0005  pea.l $5(a4)
        pea.l $5(a4)
L012_00000CBC:
; H012+$00000CBC: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L012_00000CC0:
; H012+$00000CC0: 486dff84  pea.l -$7c(a5)
        pea.l -$7c(a5)
L012_00000CC4:
; H012+$00000CC4: 486dff7e  pea.l -$82(a5)
        pea.l -$82(a5)
; FLOW: Calls DAX_LoadBlock (H028+$0DD8).
L012_00000CC8:
; H012+$00000CC8: 4eb900000dd8  jsr $dd8.l
        jsr (FN_DAX_load_block).l
L012_00000CCE:
; H012+$00000CCE: 4a6dff84  tst.w -$7c(a5)
        tst.w -$7c(a5)
L012_00000CD2:
; H012+$00000CD2: 6600001c  bne.w $cf0
        bne.w H012+$CF0
L012_00000CD6:
; H012+$00000CD6: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L012_00000CDA:
; H012+$00000CDA: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00000CDC:
; H012+$00000CDC: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L012_00000CE0:
; H012+$00000CE0: 486c000a  pea.l $a(a4)
        pea.l $a(a4)
; -> H030+$028A (sub_H030_0000028A)
L012_00000CE4:
; H012+$00000CE4: 4eb90000028a  jsr $28a.l
        jsr (H030+$28A).l
; -> H010+$0332 (sub_H010_00000332)
L012_00000CEA:
; H012+$00000CEA: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L012_00000CF0:
; H012+$00000CF0: 426dff86  clr.w -$7a(a5)
        clr.w -$7a(a5)
L012_00000CF4:
; H012+$00000CF4: 47edff9a  lea.l -$66(a5), a3
        lea.l -$66(a5), a3
L012_00000CF8:
; H012+$00000CF8: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000CFC:
; H012+$00000CFC: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000D00:
; H012+$00000D00: 1b722000ff7d  move.b (a2, d2.w), -$83(a5)
        move.b (a2, d2.w), -$83(a5)
L012_00000D06:
; H012+$00000D06: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00000D08:
; H012+$00000D08: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000D0C:
; H012+$00000D0C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L012_00000D0E:
; H012+$00000D0E: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000D12:
; H012+$00000D12: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L012_00000D16:
; H012+$00000D16: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L012_00000D18:
; H012+$00000D18: 45d3  lea.l (a3), a2
        lea.l (a3), a2
L012_00000D1A:
; H012+$00000D1A: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L012_00000D1C:
; H012+$00000D1C: 7428  moveq #$28, d2
        moveq #40, d2
L012_00000D1E:
; H012+$00000D1E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L012_00000D20:
; H012+$00000D20: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L012_00000D26:
; H012+$00000D26: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00000D28:
; H012+$00000D28: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000D2A:
; H012+$00000D2A: 142dff7d  move.b -$83(a5), d2
        move.b -$83(a5), d2
L012_00000D2E:
; H012+$00000D2E: 45d3  lea.l (a3), a2
        lea.l (a3), a2
L012_00000D30:
; H012+$00000D30: 42322000  clr.b (a2, d2.w)
        clr.b (a2, d2.w)
L012_00000D34:
; H012+$00000D34: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000D38:
; H012+$00000D38: 06420029  addi.w #$29, d2
        addi.w #$29, d2
L012_00000D3C:
; H012+$00000D3C: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000D40:
; H012+$00000D40: 17722000002a  move.b (a2, d2.w), $2a(a3)
        move.b (a2, d2.w), $2a(a3)
L012_00000D46:
; H012+$00000D46: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L012_00000D4A:
; H012+$00000D4A: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000D4E:
; H012+$00000D4E: 0642002e  addi.w #$2e, d2
        addi.w #$2e, d2
L012_00000D52:
; H012+$00000D52: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000D56:
; H012+$00000D56: 177220000030  move.b (a2, d2.w), $30(a3)
        move.b (a2, d2.w), $30(a3)
L012_00000D5C:
; H012+$00000D5C: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L012_00000D62:
; H012+$00000D62: 0c6d0003fffa  cmpi.w #$3, -$6(a5)
        cmpi.w #$3, -$6(a5)
L012_00000D68:
; H012+$00000D68: 62000028  bhi.w $d92
        bhi.w H012+$D92
L012_00000D6C:
; H012+$00000D6C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_00000D70:
; H012+$00000D70: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00000D72:
; H012+$00000D72: 45eb0032  lea.l $32(a3), a2
        lea.l $32(a3), a2
L012_00000D76:
; H012+$00000D76: 382dff86  move.w -$7a(a5), d4
        move.w -$7a(a5), d4
L012_00000D7A:
; H012+$00000D7A: 0644002e  addi.w #$2e, d4
        addi.w #$2e, d4
L012_00000D7E:
; H012+$00000D7E: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L012_00000D82:
; H012+$00000D82: 226dff7e  movea.l -$82(a5), a1
        movea.l -$82(a5), a1
L012_00000D86:
; H012+$00000D86: 15b140002000  move.b (a1, d4.w), (a2, d2.w)
        move.b (a1, d4.w), (a2, d2.w)
L012_00000D8C:
; H012+$00000D8C: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L012_00000D90:
; H012+$00000D90: 64d0  bcc.b $d62
        bcc.b H012+$D62
L012_00000D92:
; H012+$00000D92: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00000D94:
; H012+$00000D94: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000D98:
; H012+$00000D98: 06420032  addi.w #$32, d2
        addi.w #$32, d2
L012_00000D9C:
; H012+$00000D9C: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000DA0:
; H012+$00000DA0: 1f322000  move.b (a2, d2.w), -(a7)
        move.b (a2, d2.w), -(a7)
; -> H031+$008A (sub_H031_0000008A)
L012_00000DA4:
; H012+$00000DA4: 4eb90000008a  jsr $8a.l
        jsr (H031+$8A).l
L012_00000DAA:
; H012+$00000DAA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00000DAC:
; H012+$00000DAC: 37400036  move.w d0, $36(a3)
        move.w d0, $36(a3)
L012_00000DB0:
; H012+$00000DB0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00000DB2:
; H012+$00000DB2: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000DB6:
; H012+$00000DB6: 06420033  addi.w #$33, d2
        addi.w #$33, d2
L012_00000DBA:
; H012+$00000DBA: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000DBE:
; H012+$00000DBE: 1f322000  move.b (a2, d2.w), -(a7)
        move.b (a2, d2.w), -(a7)
; -> H031+$008A (sub_H031_0000008A)
L012_00000DC2:
; H012+$00000DC2: 4eb90000008a  jsr $8a.l
        jsr (H031+$8A).l
L012_00000DC8:
; H012+$00000DC8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00000DCA:
; H012+$00000DCA: 37400038  move.w d0, $38(a3)
        move.w d0, $38(a3)
L012_00000DCE:
; H012+$00000DCE: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000DD2:
; H012+$00000DD2: 06420034  addi.w #$34, d2
        addi.w #$34, d2
L012_00000DD6:
; H012+$00000DD6: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000DDA:
; H012+$00000DDA: 17722000003a  move.b (a2, d2.w), $3a(a3)
        move.b (a2, d2.w), $3a(a3)
L012_00000DE0:
; H012+$00000DE0: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000DE4:
; H012+$00000DE4: 06420035  addi.w #$35, d2
        addi.w #$35, d2
L012_00000DE8:
; H012+$00000DE8: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000DEC:
; H012+$00000DEC: 17722000003b  move.b (a2, d2.w), $3b(a3)
        move.b (a2, d2.w), $3b(a3)
L012_00000DF2:
; H012+$00000DF2: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000DF6:
; H012+$00000DF6: 06420036  addi.w #$36, d2
        addi.w #$36, d2
L012_00000DFA:
; H012+$00000DFA: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000DFE:
; H012+$00000DFE: 17722000003c  move.b (a2, d2.w), $3c(a3)
        move.b (a2, d2.w), $3c(a3)
L012_00000E04:
; H012+$00000E04: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00000E06:
; H012+$00000E06: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000E0A:
; H012+$00000E0A: 06420037  addi.w #$37, d2
        addi.w #$37, d2
L012_00000E0E:
; H012+$00000E0E: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000E12:
; H012+$00000E12: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L012_00000E16:
; H012+$00000E16: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L012_00000E18:
; H012+$00000E18: 45eb003e  lea.l $3e(a3), a2
        lea.l $3e(a3), a2
L012_00000E1C:
; H012+$00000E1C: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L012_00000E1E:
; H012+$00000E1E: 7402  moveq #$2, d2
        moveq #2, d2
L012_00000E20:
; H012+$00000E20: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L012_00000E22:
; H012+$00000E22: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L012_00000E28:
; H012+$00000E28: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00000E2A:
; H012+$00000E2A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00000E2C:
; H012+$00000E2C: 486b003e  pea.l $3e(a3)
        pea.l $3e(a3)
; -> H031+$0012 (sub_H031_00000012)
L012_00000E30:
; H012+$00000E30: 4eb900000012  jsr $12.l
        jsr (H031+$12).l
L012_00000E36:
; H012+$00000E36: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00000E38:
; H012+$00000E38: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000E3C:
; H012+$00000E3C: 06420039  addi.w #$39, d2
        addi.w #$39, d2
L012_00000E40:
; H012+$00000E40: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000E44:
; H012+$00000E44: 177220000040  move.b (a2, d2.w), $40(a3)
        move.b (a2, d2.w), $40(a3)
L012_00000E4A:
; H012+$00000E4A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00000E4C:
; H012+$00000E4C: 342dff86  move.w -$7a(a5), d2
        move.w -$7a(a5), d2
L012_00000E50:
; H012+$00000E50: 0642003a  addi.w #$3a, d2
        addi.w #$3a, d2
L012_00000E54:
; H012+$00000E54: 246dff7e  movea.l -$82(a5), a2
        movea.l -$82(a5), a2
L012_00000E58:
; H012+$00000E58: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L012_00000E5C:
; H012+$00000E5C: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L012_00000E5E:
; H012+$00000E5E: 45eb0042  lea.l $42(a3), a2
        lea.l $42(a3), a2
L012_00000E62:
; H012+$00000E62: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L012_00000E64:
; H012+$00000E64: 7402  moveq #$2, d2
        moveq #2, d2
L012_00000E66:
; H012+$00000E66: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L012_00000E68:
; H012+$00000E68: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L012_00000E6E:
; H012+$00000E6E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00000E70:
; H012+$00000E70: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00000E72:
; H012+$00000E72: 486b0042  pea.l $42(a3)
        pea.l $42(a3)
; -> H031+$0012 (sub_H031_00000012)
L012_00000E76:
; H012+$00000E76: 4eb900000012  jsr $12.l
        jsr (H031+$12).l
L012_00000E7C:
; H012+$00000E7C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00000E7E:
; H012+$00000E7E: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L012_00000E84:
; H012+$00000E84: 0c6d0003fffa  cmpi.w #$3, -$6(a5)
        cmpi.w #$3, -$6(a5)
L012_00000E8A:
; H012+$00000E8A: 62000028  bhi.w $eb4
        bhi.w H012+$EB4
L012_00000E8E:
; H012+$00000E8E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_00000E92:
; H012+$00000E92: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00000E94:
; H012+$00000E94: 45eb0044  lea.l $44(a3), a2
        lea.l $44(a3), a2
L012_00000E98:
; H012+$00000E98: 382dff86  move.w -$7a(a5), d4
        move.w -$7a(a5), d4
L012_00000E9C:
; H012+$00000E9C: 0644003b  addi.w #$3b, d4
        addi.w #$3b, d4
L012_00000EA0:
; H012+$00000EA0: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L012_00000EA4:
; H012+$00000EA4: 226dff7e  movea.l -$82(a5), a1
        movea.l -$82(a5), a1
L012_00000EA8:
; H012+$00000EA8: 15b140002000  move.b (a1, d4.w), (a2, d2.w)
        move.b (a1, d4.w), (a2, d2.w)
L012_00000EAE:
; H012+$00000EAE: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L012_00000EB2:
; H012+$00000EB2: 64d0  bcc.b $e84
        bcc.b H012+$E84
L012_00000EB4:
; H012+$00000EB4: 066d003fff86  addi.w #$3f, -$7a(a5)
        addi.w #$3f, -$7a(a5)
L012_00000EBA:
; H012+$00000EBA: 4ab900002a3a  tst.l $2a3a.l
        tst.l (H005+$2A3A).l
L012_00000EC0:
; H012+$00000EC0: 6600002e  bne.w $ef0
        bne.w H012+$EF0
L012_00000EC4:
; H012+$00000EC4: 7448  moveq #$48, d2
        moveq #72, d2
L012_00000EC6:
; H012+$00000EC6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L012_00000EC8:
; H012+$00000EC8: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L012_00000ECE:
; H012+$00000ECE: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L012_00000ED4:
; H012+$00000ED4: 23c000002a3a  move.l d0, $2a3a.l
        move.l d0, (H005+$2A3A).l
L012_00000EDA:
; H012+$00000EDA: 47edff9a  lea.l -$66(a5), a3
        lea.l -$66(a5), a3
L012_00000EDE:
; H012+$00000EDE: 247900002a3a  movea.l $2a3a.l, a2
        movea.l (H005+$2A3A).l, a2
L012_00000EE4:
; H012+$00000EE4: 7411  moveq #$11, d2
        moveq #17, d2
L012_00000EE6:
; H012+$00000EE6: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L012_00000EE8:
; H012+$00000EE8: 51cafffc  dbra d2, $ee6
        dbra d2, H012+$EE6
L012_00000EEC:
; H012+$00000EEC: 6000003e  bra.w $f2c
        bra.w H012+$F2C
L012_00000EF0:
; H012+$00000EF0: 2b7900002a3aff96  move.l $2a3a.l, -$6a(a5)
        move.l (H005+$2A3A).l, -$6a(a5)
L012_00000EF8:
; H012+$00000EF8: 7448  moveq #$48, d2
        moveq #72, d2
L012_00000EFA:
; H012+$00000EFA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L012_00000EFC:
; H012+$00000EFC: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L012_00000F02:
; H012+$00000F02: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L012_00000F08:
; H012+$00000F08: 23c000002a3a  move.l d0, $2a3a.l
        move.l d0, (H005+$2A3A).l
L012_00000F0E:
; H012+$00000F0E: 47edff9a  lea.l -$66(a5), a3
        lea.l -$66(a5), a3
L012_00000F12:
; H012+$00000F12: 247900002a3a  movea.l $2a3a.l, a2
        movea.l (H005+$2A3A).l, a2
L012_00000F18:
; H012+$00000F18: 7411  moveq #$11, d2
        moveq #17, d2
L012_00000F1A:
; H012+$00000F1A: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L012_00000F1C:
; H012+$00000F1C: 51cafffc  dbra d2, $f1a
        dbra d2, H012+$F1A
L012_00000F20:
; H012+$00000F20: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L012_00000F26:
; H012+$00000F26: 276dff96002c  move.l -$6a(a5), $2c(a3)
        move.l -$6a(a5), $2c(a3)
L012_00000F2C:
; H012+$00000F2C: 342dff84  move.w -$7c(a5), d2
        move.w -$7c(a5), d2
L012_00000F30:
; H012+$00000F30: 04420100  subi.w #$100, d2
        subi.w #$100, d2
L012_00000F34:
; H012+$00000F34: 382dff86  move.w -$7a(a5), d4
        move.w -$7a(a5), d4
L012_00000F38:
; H012+$00000F38: b842  cmp.w d2, d4
        cmp.w d2, d4
L012_00000F3A:
; H012+$00000F3A: 6500fdb8  bcs.w $cf4
        bcs.w H012+$CF4
L012_00000F3E:
; H012+$00000F3E: 2f2dff7e  move.l -$82(a5), -(a7)
        move.l -$82(a5), -(a7)
L012_00000F42:
; H012+$00000F42: 7400  moveq #$0, d2
        moveq #0, d2
L012_00000F44:
; H012+$00000F44: 342dff84  move.w -$7c(a5), d2
        move.w -$7c(a5), d2
L012_00000F48:
; H012+$00000F48: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L012_00000F4A:
; H012+$00000F4A: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L012_00000F50:
; H012+$00000F50: 60000570  bra.w $14c2
        bra.w H012+$14C2
L012_00000F54:
; H012+$00000F54: 0c6d00fffffc  cmpi.w #$ff, -$4(a5)
        cmpi.w #$ff, -$4(a5)
L012_00000F5A:
; H012+$00000F5A: 67000566  beq.w $14c2
        beq.w H012+$14C2
L012_00000F5E:
; H012+$00000F5E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L012_00000F62:
; H012+$00000F62: 04420080  subi.w #$80, d2
        subi.w #$80, d2
L012_00000F66:
; H012+$00000F66: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L012_00000F6A:
; H012+$00000F6A: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L012_00000F70:
; H012+$00000F70: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L012_00000F74:
; H012+$00000F74: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_00000F78:
; H012+$00000F78: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L012_00000F7A:
; H012+$00000F7A: 62000510  bhi.w $148c
        bhi.w H012+$148C
L012_00000F7E:
; H012+$00000F7E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00000F82:
; H012+$00000F82: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_00000F86:
; H012+$00000F86: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00000F8C:
; H012+$00000F8C: 3b40ff8e  move.w d0, -$72(a5)
        move.w d0, -$72(a5)
L012_00000F90:
; H012+$00000F90: 0c6d0015ff8e  cmpi.w #$15, -$72(a5)
        cmpi.w #$15, -$72(a5)
L012_00000F96:
; H012+$00000F96: 6400000a  bcc.w $fa2
        bcc.w H012+$FA2
L012_00000F9A:
; H012+$00000F9A: 426dff78  clr.w -$88(a5)
        clr.w -$88(a5)
L012_00000F9E:
; H012+$00000F9E: 6000006c  bra.w $100c
        bra.w H012+$100C
L012_00000FA2:
; H012+$00000FA2: 0c6d0042ff8e  cmpi.w #$42, -$72(a5)
        cmpi.w #$42, -$72(a5)
L012_00000FA8:
; H012+$00000FA8: 6400000c  bcc.w $fb6
        bcc.w H012+$FB6
L012_00000FAC:
; H012+$00000FAC: 3b7c0001ff78  move.w #$1, -$88(a5)
        move.w #$1, -$88(a5)
L012_00000FB2:
; H012+$00000FB2: 60000058  bra.w $100c
        bra.w H012+$100C
L012_00000FB6:
; H012+$00000FB6: 0c6d0047ff8e  cmpi.w #$47, -$72(a5)
        cmpi.w #$47, -$72(a5)
L012_00000FBC:
; H012+$00000FBC: 6400000c  bcc.w $fca
        bcc.w H012+$FCA
L012_00000FC0:
; H012+$00000FC0: 3b7c0002ff78  move.w #$2, -$88(a5)
        move.w #$2, -$88(a5)
L012_00000FC6:
; H012+$00000FC6: 60000044  bra.w $100c
        bra.w H012+$100C
L012_00000FCA:
; H012+$00000FCA: 0c6d0051ff8e  cmpi.w #$51, -$72(a5)
        cmpi.w #$51, -$72(a5)
L012_00000FD0:
; H012+$00000FD0: 6400000c  bcc.w $fde
        bcc.w H012+$FDE
L012_00000FD4:
; H012+$00000FD4: 3b7c0003ff78  move.w #$3, -$88(a5)
        move.w #$3, -$88(a5)
L012_00000FDA:
; H012+$00000FDA: 60000030  bra.w $100c
        bra.w H012+$100C
L012_00000FDE:
; H012+$00000FDE: 0c6d0056ff8e  cmpi.w #$56, -$72(a5)
        cmpi.w #$56, -$72(a5)
L012_00000FE4:
; H012+$00000FE4: 6400000c  bcc.w $ff2
        bcc.w H012+$FF2
L012_00000FE8:
; H012+$00000FE8: 3b7c0004ff78  move.w #$4, -$88(a5)
        move.w #$4, -$88(a5)
L012_00000FEE:
; H012+$00000FEE: 6000001c  bra.w $100c
        bra.w H012+$100C
L012_00000FF2:
; H012+$00000FF2: 0c6d0060ff8e  cmpi.w #$60, -$72(a5)
        cmpi.w #$60, -$72(a5)
L012_00000FF8:
; H012+$00000FF8: 6400000c  bcc.w $1006
        bcc.w H012+$1006
L012_00000FFC:
; H012+$00000FFC: 3b7c0005ff78  move.w #$5, -$88(a5)
        move.w #$5, -$88(a5)
L012_00001002:
; H012+$00001002: 60000008  bra.w $100c
        bra.w H012+$100C
L012_00001006:
; H012+$00001006: 3b7c0006ff78  move.w #$6, -$88(a5)
        move.w #$6, -$88(a5)
L012_0000100C:
; H012+$0000100C: 342dff78  move.w -$88(a5), d2
        move.w -$88(a5), d2
L012_00001010:
; H012+$00001010: 600003d2  bra.w $13e4
        bra.w H012+$13E4
L012_00001014:
; H012+$00001014: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001018:
; H012+$00001018: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_0000101C:
; H012+$0000101C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00001022:
; H012+$00001022: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_00001026:
; H012+$00001026: 0c6d000bff8c  cmpi.w #$b, -$74(a5)
        cmpi.w #$b, -$74(a5)
L012_0000102C:
; H012+$0000102C: 6400000a  bcc.w $1038
        bcc.w H012+$1038
L012_00001030:
; H012+$00001030: 426dff7a  clr.w -$86(a5)
        clr.w -$86(a5)
L012_00001034:
; H012+$00001034: 6000001c  bra.w $1052
        bra.w H012+$1052
L012_00001038:
; H012+$00001038: 0c6d001aff8c  cmpi.w #$1a, -$74(a5)
        cmpi.w #$1a, -$74(a5)
L012_0000103E:
; H012+$0000103E: 6400000c  bcc.w $104c
        bcc.w H012+$104C
L012_00001042:
; H012+$00001042: 3b7c0001ff7a  move.w #$1, -$86(a5)
        move.w #$1, -$86(a5)
L012_00001048:
; H012+$00001048: 60000008  bra.w $1052
        bra.w H012+$1052
L012_0000104C:
; H012+$0000104C: 3b7c0002ff7a  move.w #$2, -$86(a5)
        move.w #$2, -$86(a5)
L012_00001052:
; H012+$00001052: 342dff7a  move.w -$86(a5), d2
        move.w -$86(a5), d2
L012_00001056:
; H012+$00001056: 6000024e  bra.w $12a6
        bra.w H012+$12A6
L012_0000105A:
; H012+$0000105A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_0000105E:
; H012+$0000105E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_00001062:
; H012+$00001062: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00001068:
; H012+$00001068: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_0000106C:
; H012+$0000106C: 342dff8c  move.w -$74(a5), d2
        move.w -$74(a5), d2
L012_00001070:
; H012+$00001070: 60000042  bra.w $10b4
        bra.w H012+$10B4
L012_00001074:
; H012+$00001074: 3b7c0006ff88  move.w #$6, -$78(a5)
        move.w #$6, -$78(a5)
L012_0000107A:
; H012+$0000107A: 4e75  rts 
        rts 
L012_0000107C:
; H012+$0000107C: 3b7c0008ff88  move.w #$8, -$78(a5)
        move.w #$8, -$78(a5)
L012_00001082:
; H012+$00001082: 4e75  rts 
        rts 
L012_00001084:
; H012+$00001084: 3b7c0046ff88  move.w #$46, -$78(a5)
        move.w #$46, -$78(a5)
L012_0000108A:
; H012+$0000108A: 4e75  rts 
        rts 
L012_0000108C:
; H012+$0000108C: 3b7c000fff88  move.w #$f, -$78(a5)
        move.w #$f, -$78(a5)
L012_00001092:
; H012+$00001092: 4e75  rts 
        rts 
L012_00001094:
; H012+$00001094: 3b7c001dff88  move.w #$1d, -$78(a5)
        move.w #$1d, -$78(a5)
L012_0000109A:
; H012+$0000109A: 4e75  rts 
        rts 
L012_0000109C:
; H012+$0000109C: 4e75  rts 
        rts 
; Preserved bytes H012+$0000109E..$000010B4; code/data not fully classified.
        dc.w $FFFC,$FFD4,$FFD4,$FFDC,$FFDC,$FFDC,$FFDC,$FFE4
        dc.w $FFE4,$FFEC,$FFF4
L012_000010B4:
; H012+$000010B4: 47faffea  lea.l $10a0(pc), a3
        lea.l H012+$10A0(pc), a3
L012_000010B8:
; H012+$000010B8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000010BA:
; H012+$000010BA: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L012_000010BE:
; H012+$000010BE: 6302  bls.b $10c2
        bls.b H012+$10C2
L012_000010C0:
; H012+$000010C0: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_000010C2:
; H012+$000010C2: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_000010C4:
; H012+$000010C4: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$10A0; indices 0..9, default -1.
L012_000010C8:
; H012+$000010C8: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_000010CC:
; H012+$000010CC: 4e75  rts 
        rts 
L012_000010CE:
; H012+$000010CE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_000010D2:
; H012+$000010D2: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_000010D6:
; H012+$000010D6: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_000010DC:
; H012+$000010DC: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_000010E0:
; H012+$000010E0: 342dff8c  move.w -$74(a5), d2
        move.w -$74(a5), d2
L012_000010E4:
; H012+$000010E4: 60000076  bra.w $115c
        bra.w H012+$115C
L012_000010E8:
; H012+$000010E8: 3b7c0005ff88  move.w #$5, -$78(a5)
        move.w #$5, -$78(a5)
L012_000010EE:
; H012+$000010EE: 4e75  rts 
        rts 
L012_000010F0:
; H012+$000010F0: 3b7c0007ff88  move.w #$7, -$78(a5)
        move.w #$7, -$78(a5)
L012_000010F6:
; H012+$000010F6: 4e75  rts 
        rts 
L012_000010F8:
; H012+$000010F8: 3b7c0018ff88  move.w #$18, -$78(a5)
        move.w #$18, -$78(a5)
L012_000010FE:
; H012+$000010FE: 4e75  rts 
        rts 
L012_00001100:
; H012+$00001100: 3b7c0016ff88  move.w #$16, -$78(a5)
        move.w #$16, -$78(a5)
L012_00001106:
; H012+$00001106: 4e75  rts 
        rts 
L012_00001108:
; H012+$00001108: 3b7c0019ff88  move.w #$19, -$78(a5)
        move.w #$19, -$78(a5)
L012_0000110E:
; H012+$0000110E: 4e75  rts 
        rts 
L012_00001110:
; H012+$00001110: 3b7c0017ff88  move.w #$17, -$78(a5)
        move.w #$17, -$78(a5)
L012_00001116:
; H012+$00001116: 4e75  rts 
        rts 
L012_00001118:
; H012+$00001118: 3b7c001cff88  move.w #$1c, -$78(a5)
        move.w #$1c, -$78(a5)
L012_0000111E:
; H012+$0000111E: 4e75  rts 
        rts 
L012_00001120:
; H012+$00001120: 3b7c001dff88  move.w #$1d, -$78(a5)
        move.w #$1d, -$78(a5)
L012_00001126:
; H012+$00001126: 4e75  rts 
        rts 
L012_00001128:
; H012+$00001128: 3b7c001eff88  move.w #$1e, -$78(a5)
        move.w #$1e, -$78(a5)
L012_0000112E:
; H012+$0000112E: 4e75  rts 
        rts 
L012_00001130:
; H012+$00001130: 4e75  rts 
        rts 
; Preserved bytes H012+$00001132..$0000115C; code/data not fully classified.
        dc.w $FFFC,$FFB4,$FFB4,$FFB4,$FFBC,$FFBC,$FFC4,$FFC4
        dc.w $FFC4,$FFCC,$FFCC,$FFD4,$FFD4,$FFDC,$FFDC,$FFE4
        dc.w $FFE4,$FFEC,$FFEC,$FFF4,$FFF4
L012_0000115C:
; H012+$0000115C: 47faffd6  lea.l $1134(pc), a3
        lea.l H012+$1134(pc), a3
L012_00001160:
; H012+$00001160: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00001162:
; H012+$00001162: 0c420013  cmpi.w #$13, d2
        cmpi.w #$13, d2
L012_00001166:
; H012+$00001166: 6302  bls.b $116a
        bls.b H012+$116A
L012_00001168:
; H012+$00001168: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_0000116A:
; H012+$0000116A: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_0000116C:
; H012+$0000116C: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$1134; indices 0..19, default -1.
L012_00001170:
; H012+$00001170: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001174:
; H012+$00001174: 4e75  rts 
        rts 
L012_00001176:
; H012+$00001176: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_0000117A:
; H012+$0000117A: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_0000117E:
; H012+$0000117E: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00001184:
; H012+$00001184: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_00001188:
; H012+$00001188: 0c6d0004ff8c  cmpi.w #$4, -$74(a5)
        cmpi.w #$4, -$74(a5)
L012_0000118E:
; H012+$0000118E: 64000094  bcc.w $1224
        bcc.w H012+$1224
L012_00001192:
; H012+$00001192: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001196:
; H012+$00001196: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_0000119A:
; H012+$0000119A: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_000011A0:
; H012+$000011A0: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_000011A4:
; H012+$000011A4: 342dff8c  move.w -$74(a5), d2
        move.w -$74(a5), d2
L012_000011A8:
; H012+$000011A8: 6000005e  bra.w $1208
        bra.w H012+$1208
L012_000011AC:
; H012+$000011AC: 3b7c0012ff88  move.w #$12, -$78(a5)
        move.w #$12, -$78(a5)
L012_000011B2:
; H012+$000011B2: 4e75  rts 
        rts 
L012_000011B4:
; H012+$000011B4: 3b7c0011ff88  move.w #$11, -$78(a5)
        move.w #$11, -$78(a5)
L012_000011BA:
; H012+$000011BA: 4e75  rts 
        rts 
L012_000011BC:
; H012+$000011BC: 3b7c000dff88  move.w #$d, -$78(a5)
        move.w #$d, -$78(a5)
L012_000011C2:
; H012+$000011C2: 4e75  rts 
        rts 
L012_000011C4:
; H012+$000011C4: 3b7c0010ff88  move.w #$10, -$78(a5)
        move.w #$10, -$78(a5)
L012_000011CA:
; H012+$000011CA: 4e75  rts 
        rts 
L012_000011CC:
; H012+$000011CC: 3b7c0013ff88  move.w #$13, -$78(a5)
        move.w #$13, -$78(a5)
L012_000011D2:
; H012+$000011D2: 4e75  rts 
        rts 
L012_000011D4:
; H012+$000011D4: 3b7c0014ff88  move.w #$14, -$78(a5)
        move.w #$14, -$78(a5)
L012_000011DA:
; H012+$000011DA: 4e75  rts 
        rts 
L012_000011DC:
; H012+$000011DC: 4e75  rts 
        rts 
; Preserved bytes H012+$000011DE..$00001208; code/data not fully classified.
        dc.w $FFFC,$FFCC,$FFCC,$FFCC,$FFCC,$FFCC,$FFCC,$FFCC
        dc.w $FFCC,$FFD4,$FFD4,$FFD4,$FFD4,$FFD4,$FFDC,$FFE4
        dc.w $FFEC,$FFEC,$FFEC,$FFF4,$FFF4
L012_00001208:
; H012+$00001208: 47faffd6  lea.l $11e0(pc), a3
        lea.l H012+$11E0(pc), a3
L012_0000120C:
; H012+$0000120C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_0000120E:
; H012+$0000120E: 0c420013  cmpi.w #$13, d2
        cmpi.w #$13, d2
L012_00001212:
; H012+$00001212: 6302  bls.b $1216
        bls.b H012+$1216
L012_00001214:
; H012+$00001214: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001216:
; H012+$00001216: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001218:
; H012+$00001218: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$11E0; indices 0..19, default -1.
L012_0000121C:
; H012+$0000121C: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001220:
; H012+$00001220: 60000078  bra.w $129a
        bra.w H012+$129A
L012_00001224:
; H012+$00001224: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001228:
; H012+$00001228: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_0000122C:
; H012+$0000122C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00001232:
; H012+$00001232: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_00001236:
; H012+$00001236: 342dff8c  move.w -$74(a5), d2
        move.w -$74(a5), d2
L012_0000123A:
; H012+$0000123A: 60000046  bra.w $1282
        bra.w H012+$1282
L012_0000123E:
; H012+$0000123E: 3b7c0001ff88  move.w #$1, -$78(a5)
        move.w #$1, -$78(a5)
L012_00001244:
; H012+$00001244: 4e75  rts 
        rts 
L012_00001246:
; H012+$00001246: 3b7c0004ff88  move.w #$4, -$78(a5)
        move.w #$4, -$78(a5)
L012_0000124C:
; H012+$0000124C: 4e75  rts 
        rts 
L012_0000124E:
; H012+$0000124E: 3b7c0008ff88  move.w #$8, -$78(a5)
        move.w #$8, -$78(a5)
L012_00001254:
; H012+$00001254: 4e75  rts 
        rts 
L012_00001256:
; H012+$00001256: 3b7c000aff88  move.w #$a, -$78(a5)
        move.w #$a, -$78(a5)
L012_0000125C:
; H012+$0000125C: 4e75  rts 
        rts 
L012_0000125E:
; H012+$0000125E: 3b7c000eff88  move.w #$e, -$78(a5)
        move.w #$e, -$78(a5)
L012_00001264:
; H012+$00001264: 4e75  rts 
        rts 
L012_00001266:
; H012+$00001266: 3b7c0047ff88  move.w #$47, -$78(a5)
        move.w #$47, -$78(a5)
L012_0000126C:
; H012+$0000126C: 4e75  rts 
        rts 
L012_0000126E:
; H012+$0000126E: 4e75  rts 
        rts 
; Preserved bytes H012+$00001270..$00001282; code/data not fully classified.
        dc.w $FFFC,$FFCC,$FFD4,$FFD4,$FFDC,$FFDC,$FFE4,$FFEC
        dc.w $FFF4
L012_00001282:
; H012+$00001282: 47faffee  lea.l $1272(pc), a3
        lea.l H012+$1272(pc), a3
L012_00001286:
; H012+$00001286: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00001288:
; H012+$00001288: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L012_0000128C:
; H012+$0000128C: 6302  bls.b $1290
        bls.b H012+$1290
L012_0000128E:
; H012+$0000128E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001290:
; H012+$00001290: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001292:
; H012+$00001292: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$1272; indices 0..7, default -1.
L012_00001296:
; H012+$00001296: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_0000129A:
; H012+$0000129A: 4e75  rts 
        rts 
L012_0000129C:
; H012+$0000129C: 4e75  rts 
        rts 
; Preserved bytes H012+$0000129E..$000012A6; code/data not fully classified.
        dc.w $FFFC,$FDBA,$FE2E,$FED6
L012_000012A6:
; H012+$000012A6: 47fafff8  lea.l $12a0(pc), a3
        lea.l H012+$12A0(pc), a3
L012_000012AA:
; H012+$000012AA: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L012_000012AE:
; H012+$000012AE: 6302  bls.b $12b2
        bls.b H012+$12B2
L012_000012B0:
; H012+$000012B0: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_000012B2:
; H012+$000012B2: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_000012B4:
; H012+$000012B4: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$12A0; indices 0..2, default -1.
L012_000012B8:
; H012+$000012B8: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_000012BC:
; H012+$000012BC: 4e75  rts 
        rts 
L012_000012BE:
; H012+$000012BE: 3b7c0027ff88  move.w #$27, -$78(a5)
        move.w #$27, -$78(a5)
L012_000012C4:
; H012+$000012C4: 4e75  rts 
        rts 
L012_000012C6:
; H012+$000012C6: 3b7c0028ff88  move.w #$28, -$78(a5)
        move.w #$28, -$78(a5)
L012_000012CC:
; H012+$000012CC: 4e75  rts 
        rts 
L012_000012CE:
; H012+$000012CE: 3b7c0025ff88  move.w #$25, -$78(a5)
        move.w #$25, -$78(a5)
L012_000012D4:
; H012+$000012D4: 4e75  rts 
        rts 
L012_000012D6:
; H012+$000012D6: 3b7c003bff88  move.w #$3b, -$78(a5)
        move.w #$3b, -$78(a5)
L012_000012DC:
; H012+$000012DC: 4e75  rts 
        rts 
L012_000012DE:
; H012+$000012DE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_000012E2:
; H012+$000012E2: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_000012E6:
; H012+$000012E6: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_000012EC:
; H012+$000012EC: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_000012F0:
; H012+$000012F0: 342dff8c  move.w -$74(a5), d2
        move.w -$74(a5), d2
L012_000012F4:
; H012+$000012F4: 6000005e  bra.w $1354
        bra.w H012+$1354
L012_000012F8:
; H012+$000012F8: 3b7c001fff88  move.w #$1f, -$78(a5)
        move.w #$1f, -$78(a5)
L012_000012FE:
; H012+$000012FE: 4e75  rts 
        rts 
L012_00001300:
; H012+$00001300: 3b7c0023ff88  move.w #$23, -$78(a5)
        move.w #$23, -$78(a5)
L012_00001306:
; H012+$00001306: 4e75  rts 
        rts 
L012_00001308:
; H012+$00001308: 3b7c0024ff88  move.w #$24, -$78(a5)
        move.w #$24, -$78(a5)
L012_0000130E:
; H012+$0000130E: 4e75  rts 
        rts 
L012_00001310:
; H012+$00001310: 3b7c0020ff88  move.w #$20, -$78(a5)
        move.w #$20, -$78(a5)
L012_00001316:
; H012+$00001316: 4e75  rts 
        rts 
L012_00001318:
; H012+$00001318: 3b7c0021ff88  move.w #$21, -$78(a5)
        move.w #$21, -$78(a5)
L012_0000131E:
; H012+$0000131E: 4e75  rts 
        rts 
L012_00001320:
; H012+$00001320: 3b7c0022ff88  move.w #$22, -$78(a5)
        move.w #$22, -$78(a5)
L012_00001326:
; H012+$00001326: 4e75  rts 
        rts 
L012_00001328:
; H012+$00001328: 4e75  rts 
        rts 
; Preserved bytes H012+$0000132A..$00001354; code/data not fully classified.
        dc.w $FFFC,$FFCC,$FFCC,$FFCC,$FFD4,$FFD4,$FFD4,$FFD4
        dc.w $FFD4,$FFD4,$FFD4,$FFD4,$FFDC,$FFDC,$FFDC,$FFDC
        dc.w $FFDC,$FFE4,$FFEC,$FFF4,$FFF4
L012_00001354:
; H012+$00001354: 47faffd6  lea.l $132c(pc), a3
        lea.l H012+$132C(pc), a3
L012_00001358:
; H012+$00001358: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_0000135A:
; H012+$0000135A: 0c420013  cmpi.w #$13, d2
        cmpi.w #$13, d2
L012_0000135E:
; H012+$0000135E: 6302  bls.b $1362
        bls.b H012+$1362
L012_00001360:
; H012+$00001360: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001362:
; H012+$00001362: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001364:
; H012+$00001364: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$132C; indices 0..19, default -1.
L012_00001368:
; H012+$00001368: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_0000136C:
; H012+$0000136C: 4e75  rts 
        rts 
L012_0000136E:
; H012+$0000136E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001372:
; H012+$00001372: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_00001376:
; H012+$00001376: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_0000137C:
; H012+$0000137C: 3b40ff8c  move.w d0, -$74(a5)
        move.w d0, -$74(a5)
L012_00001380:
; H012+$00001380: 342dff8c  move.w -$74(a5), d2
        move.w -$74(a5), d2
L012_00001384:
; H012+$00001384: 60000032  bra.w $13b8
        bra.w H012+$13B8
L012_00001388:
; H012+$00001388: 3b7c0032ff88  move.w #$32, -$78(a5)
        move.w #$32, -$78(a5)
L012_0000138E:
; H012+$0000138E: 4e75  rts 
        rts 
L012_00001390:
; H012+$00001390: 3b7c0030ff88  move.w #$30, -$78(a5)
        move.w #$30, -$78(a5)
L012_00001396:
; H012+$00001396: 4e75  rts 
        rts 
L012_00001398:
; H012+$00001398: 3b7c0034ff88  move.w #$34, -$78(a5)
        move.w #$34, -$78(a5)
L012_0000139E:
; H012+$0000139E: 4e75  rts 
        rts 
L012_000013A0:
; H012+$000013A0: 3b7c0035ff88  move.w #$35, -$78(a5)
        move.w #$35, -$78(a5)
L012_000013A6:
; H012+$000013A6: 4e75  rts 
        rts 
L012_000013A8:
; H012+$000013A8: 4e75  rts 
        rts 
; Preserved bytes H012+$000013AA..$000013B8; code/data not fully classified.
        dc.w $FFFC,$FFDC,$FFDC,$FFE4,$FFE4,$FFEC,$FFF4
L012_000013B8:
; H012+$000013B8: 47fafff2  lea.l $13ac(pc), a3
        lea.l H012+$13AC(pc), a3
L012_000013BC:
; H012+$000013BC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000013BE:
; H012+$000013BE: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L012_000013C2:
; H012+$000013C2: 6302  bls.b $13c6
        bls.b H012+$13C6
L012_000013C4:
; H012+$000013C4: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_000013C6:
; H012+$000013C6: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_000013C8:
; H012+$000013C8: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$13AC; indices 0..5, default -1.
L012_000013CC:
; H012+$000013CC: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_000013D0:
; H012+$000013D0: 4e75  rts 
        rts 
L012_000013D2:
; H012+$000013D2: 4e75  rts 
        rts 
; Preserved bytes H012+$000013D4..$000013E4; code/data not fully classified.
        dc.w $FFFC,$FC3E,$FEE8,$FEF0,$FEF8,$FF00,$FF08,$FF98
L012_000013E4:
; H012+$000013E4: 47fafff0  lea.l $13d6(pc), a3
        lea.l H012+$13D6(pc), a3
L012_000013E8:
; H012+$000013E8: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L012_000013EC:
; H012+$000013EC: 6302  bls.b $13f0
        bls.b H012+$13F0
L012_000013EE:
; H012+$000013EE: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_000013F0:
; H012+$000013F0: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_000013F2:
; H012+$000013F2: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$13D6; indices 0..6, default -1.
L012_000013F6:
; H012+$000013F6: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_000013FA:
; H012+$000013FA: 3f2dff88  move.w -$78(a5), -(a7)
        move.w -$78(a5), -(a7)
L012_000013FE:
; H012+$000013FE: 486dff9a  pea.l -$66(a5)
        pea.l -$66(a5)
; -> H067+$1292 (sub_H067_00001292)
L012_00001402:
; H012+$00001402: 4eb900001292  jsr $1292.l
        jsr (H067+$1292).l
L012_00001408:
; H012+$00001408: 4ab900002a3a  tst.l $2a3a.l
        tst.l (H005+$2A3A).l
L012_0000140E:
; H012+$0000140E: 66000038  bne.w $1448
        bne.w H012+$1448
L012_00001412:
; H012+$00001412: 7448  moveq #$48, d2
        moveq #72, d2
L012_00001414:
; H012+$00001414: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L012_00001416:
; H012+$00001416: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L012_0000141C:
; H012+$0000141C: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L012_00001422:
; H012+$00001422: 23c000002a3a  move.l d0, $2a3a.l
        move.l d0, (H005+$2A3A).l
L012_00001428:
; H012+$00001428: 47edff9a  lea.l -$66(a5), a3
        lea.l -$66(a5), a3
L012_0000142C:
; H012+$0000142C: 247900002a3a  movea.l $2a3a.l, a2
        movea.l (H005+$2A3A).l, a2
L012_00001432:
; H012+$00001432: 7411  moveq #$11, d2
        moveq #17, d2
L012_00001434:
; H012+$00001434: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L012_00001436:
; H012+$00001436: 51cafffc  dbra d2, $1434
        dbra d2, H012+$1434
L012_0000143A:
; H012+$0000143A: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L012_00001440:
; H012+$00001440: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L012_00001444:
; H012+$00001444: 6000003e  bra.w $1484
        bra.w H012+$1484
L012_00001448:
; H012+$00001448: 2b7900002a3aff96  move.l $2a3a.l, -$6a(a5)
        move.l (H005+$2A3A).l, -$6a(a5)
L012_00001450:
; H012+$00001450: 7448  moveq #$48, d2
        moveq #72, d2
L012_00001452:
; H012+$00001452: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L012_00001454:
; H012+$00001454: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L012_0000145A:
; H012+$0000145A: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L012_00001460:
; H012+$00001460: 23c000002a3a  move.l d0, $2a3a.l
        move.l d0, (H005+$2A3A).l
L012_00001466:
; H012+$00001466: 47edff9a  lea.l -$66(a5), a3
        lea.l -$66(a5), a3
L012_0000146A:
; H012+$0000146A: 247900002a3a  movea.l $2a3a.l, a2
        movea.l (H005+$2A3A).l, a2
L012_00001470:
; H012+$00001470: 7411  moveq #$11, d2
        moveq #17, d2
L012_00001472:
; H012+$00001472: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L012_00001474:
; H012+$00001474: 51cafffc  dbra d2, $1472
        dbra d2, H012+$1472
L012_00001478:
; H012+$00001478: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L012_0000147E:
; H012+$0000147E: 276dff96002c  move.l -$6a(a5), $2c(a3)
        move.l -$6a(a5), $2c(a3)
L012_00001484:
; H012+$00001484: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L012_00001488:
; H012+$00001488: 6400faea  bcc.w $f74
        bcc.w H012+$F74
L012_0000148C:
; H012+$0000148C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L012_0000148E:
; H012+$0000148E: 2b7900002a3aff92  move.l $2a3a.l, -$6e(a5)
        move.l (H005+$2A3A).l, -$6e(a5)
L012_00001496:
; H012+$00001496: 4aadff92  tst.l -$6e(a5)
        tst.l -$6e(a5)
L012_0000149A:
; H012+$0000149A: 67000026  beq.w $14c2
        beq.w H012+$14C2
; STATE: H005+$3368 = current character
L012_0000149E:
; H012+$0000149E: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L012_000014A4:
; H012+$000014A4: 2f2dff92  move.l -$6e(a5), -(a7)
        move.l -$6e(a5), -(a7)
L012_000014A8:
; H012+$000014A8: 4267  clr.w -(a7)
        clr.w -(a7)
L012_000014AA:
; H012+$000014AA: 4267  clr.w -(a7)
        clr.w -(a7)
L012_000014AC:
; H012+$000014AC: 4227  clr.b -(a7)
        clr.b -(a7)
L012_000014AE:
; H012+$000014AE: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$09B2 (sub_H063_000009B2)
L012_000014B0:
; H012+$000014B0: 4eb9000009b2  jsr $9b2.l
        jsr (H063+$9B2).l
L012_000014B6:
; H012+$000014B6: 266dff92  movea.l -$6e(a5), a3
        movea.l -$6e(a5), a3
L012_000014BA:
; H012+$000014BA: 2b6b002cff92  move.l $2c(a3), -$6e(a5)
        move.l $2c(a3), -$6e(a5)
L012_000014C0:
; H012+$000014C0: 60d4  bra.b $1496
        bra.b H012+$1496
L012_000014C2:
; H012+$000014C2: 4e5d  unlk a5
        unlk a5
L012_000014C4:
; H012+$000014C4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_000014C6:
; H012+$000014C6: 4e75  rts 
        rts 
; FUNCTION: ECL_40_ROB
FN_ECL_40_ROB:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_40 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 40=ROB.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2EE4
; --------------------------------------------------------------------------
L012_000014C8:
; H012+$000014C8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_000014CA:
; H012+$000014CA: 287aeca8  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_000014CE:
; H012+$000014CE: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L012_000014D2:
; H012+$000014D2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000014D6:
; H012+$000014D6: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_000014DC:
; H012+$000014DC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000014E0:
; H012+$000014E0: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000014E6:
; H012+$000014E6: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_000014EA:
; H012+$000014EA: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000014EE:
; H012+$000014EE: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000014F4:
; H012+$000014F4: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L012_000014F8:
; H012+$000014F8: 7464  moveq #$64, d2
        moveq #100, d2
L012_000014FA:
; H012+$000014FA: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L012_000014FE:
; H012+$000014FE: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L012_00001504:
; H012+$00001504: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H015+$0172 (wrapper_SPFlt)
L012_00001506:
; H012+$00001506: 4eb900000172  jsr $172.l
        jsr (H015+$172).l
L012_0000150C:
; H012+$0000150C: 2400  move.l d0, d2
        move.l d0, d2
L012_0000150E:
; H012+$0000150E: 7864  moveq #$64, d4
        moveq #100, d4
L012_00001510:
; H012+$00001510: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L012_00001512:
; H012+$00001512: 2f04  move.l d4, -(a7)
        move.l d4, -(a7)
; -> H015+$0172 (wrapper_SPFlt)
L012_00001514:
; H012+$00001514: 4eb900000172  jsr $172.l
        jsr (H015+$172).l
L012_0000151A:
; H012+$0000151A: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L012_0000151C:
; H012+$0000151C: 2800  move.l d0, d4
        move.l d0, d4
L012_0000151E:
; H012+$0000151E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L012_00001520:
; H012+$00001520: 2f04  move.l d4, -(a7)
        move.l d4, -(a7)
; -> H015+$0122 (wrapper_SPDiv)
L012_00001522:
; H012+$00001522: 4eb900000122  jsr $122.l
        jsr (H015+$122).l
L012_00001528:
; H012+$00001528: 2b40ffee  move.l d0, -$12(a5)
        move.l d0, -$12(a5)
L012_0000152C:
; H012+$0000152C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001530:
; H012+$00001530: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001536:
; H012+$00001536: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L012_0000153A:
; H012+$0000153A: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L012_0000153E:
; H012+$0000153E: 66000026  bne.w $1566
        bne.w H012+$1566
L012_00001542:
; H012+$00001542: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; STATE: H005+$3368 = current character
L012_00001546:
; H012+$00001546: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H061+$3C4C (sub_H061_00003C4C)
L012_0000154C:
; H012+$0000154C: 4eb900003c4c  jsr $3c4c.l
        jsr (H061+$3C4C).l
L012_00001552:
; H012+$00001552: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; STATE: H005+$3368 = current character
L012_00001556:
; H012+$00001556: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H061+$3DBE (sub_H061_00003DBE)
L012_0000155C:
; H012+$0000155C: 4eb900003dbe  jsr $3dbe.l
        jsr (H061+$3DBE).l
L012_00001562:
; H012+$00001562: 60000044  bra.w $15a8
        bra.w H012+$15A8
; STATE: H005+$3364 = head of the party list
L012_00001566:
; H012+$00001566: 2b7900003364fff6  move.l $3364.l, -$a(a5)
        move.l (H005+$3364).l, -$a(a5)
L012_0000156E:
; H012+$0000156E: 4aadfff6  tst.l -$a(a5)
        tst.l -$a(a5)
L012_00001572:
; H012+$00001572: 67000034  beq.w $15a8
        beq.w H012+$15A8
L012_00001576:
; H012+$00001576: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L012_0000157A:
; H012+$0000157A: 2b6b0150fff2  move.l $150(a3), -$e(a5)
        move.l $150(a3), -$e(a5)
L012_00001580:
; H012+$00001580: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
L012_00001584:
; H012+$00001584: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
; -> H061+$3C4C (sub_H061_00003C4C)
L012_00001588:
; H012+$00001588: 4eb900003c4c  jsr $3c4c.l
        jsr (H061+$3C4C).l
L012_0000158E:
; H012+$0000158E: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L012_00001592:
; H012+$00001592: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
; -> H061+$3DBE (sub_H061_00003DBE)
L012_00001596:
; H012+$00001596: 4eb900003dbe  jsr $3dbe.l
        jsr (H061+$3DBE).l
L012_0000159C:
; H012+$0000159C: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L012_000015A0:
; H012+$000015A0: 2b6b018efff6  move.l $18e(a3), -$a(a5)
        move.l $18e(a3), -$a(a5)
L012_000015A6:
; H012+$000015A6: 60c6  bra.b $156e
        bra.b H012+$156E
L012_000015A8:
; H012+$000015A8: 4e5d  unlk a5
        unlk a5
L012_000015AA:
; H012+$000015AA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_000015AC:
; H012+$000015AC: 4e75  rts 
        rts 
; FUNCTION: ECL_41_ENCOUNTER_MENU
FN_ECL_41_ENCOUNTER_MENU:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_41 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 41=ENCOUNTER MENU.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2EEA
; --------------------------------------------------------------------------
L012_000015AE:
; H012+$000015AE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_000015B0:
; H012+$000015B0: 287aebc2  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_000015B4:
; H012+$000015B4: 4e55fbb4  link.w a5, #$fbb4
        link.w a5, #$fbb4
L012_000015B8:
; H012+$000015B8: 13fc0001000024b4  move.b #$1, $24b4.l
        move.b #$1, (H005+$24B4).l
L012_000015C0:
; H012+$000015C0: 4239000024b9  clr.b $24b9.l
        clr.b (H005+$24B9).l
L012_000015C6:
; H012+$000015C6: 13fc0001000024ce  move.b #$1, $24ce.l
        move.b #$1, (H005+$24CE).l
L012_000015CE:
; H012+$000015CE: 486dfbec  pea.l -$414(a5)
        pea.l -$414(a5)
L012_000015D2:
; H012+$000015D2: 486dfbea  pea.l -$416(a5)
        pea.l -$416(a5)
; -> H061+$3FA8 (sub_H061_00003FA8)
L012_000015D6:
; H012+$000015D6: 4eb900003fa8  jsr $3fa8.l
        jsr (H061+$3FA8).l
L012_000015DC:
; H012+$000015DC: 47ec005c  lea.l $5c(a4), a3
        lea.l $5c(a4), a3
L012_000015E0:
; H012+$000015E0: 45edfbba  lea.l -$446(a5), a2
        lea.l -$446(a5), a2
L012_000015E4:
; H012+$000015E4: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L012_000015E6:
; H012+$000015E6: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L012_000015E8:
; H012+$000015E8: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000015EC:
; H012+$000015EC: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_000015F2:
; H012+$000015F2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000015F6:
; H012+$000015F6: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000015FC:
; H012+$000015FC: 13c000002491  move.b d0, $2491.l
        move.b d0, (H005+$2491).l
L012_00001602:
; H012+$00001602: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001606:
; H012+$00001606: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_0000160C:
; H012+$0000160C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001612:
; H012+$00001612: 37400580  move.w d0, $580(a3)
        move.w d0, $580(a3)
L012_00001616:
; H012+$00001616: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_0000161A:
; H012+$0000161A: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001620:
; H012+$00001620: 13c000002490  move.b d0, $2490.l
        move.b d0, (H005+$2490).l
L012_00001626:
; H012+$00001626: 1f3900001455  move.b $1455.l, -(a7)
        move.b (H061+$1455).l, -(a7)
L012_0000162C:
; H012+$0000162C: 1f3900001495  move.b $1495.l, -(a7)
        move.b (H061+$1495).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_00001632:
; H012+$00001632: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_00001638:
; H012+$00001638: 3b40fbb4  move.w d0, -$44c(a5)
        move.w d0, -$44c(a5)
L012_0000163C:
; H012+$0000163C: 426dfbee  clr.w -$412(a5)
        clr.w -$412(a5)
L012_00001640:
; H012+$00001640: 0c6d0004fbee  cmpi.w #$4, -$412(a5)
        cmpi.w #$4, -$412(a5)
L012_00001646:
; H012+$00001646: 6200002c  bhi.w $1674
        bhi.w H012+$1674
L012_0000164A:
; H012+$0000164A: 342dfbee  move.w -$412(a5), d2
        move.w -$412(a5), d2
L012_0000164E:
; H012+$0000164E: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001650:
; H012+$00001650: 47edfff4  lea.l -$c(a5), a3
        lea.l -$c(a5), a3
L012_00001654:
; H012+$00001654: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L012_00001658:
; H012+$00001658: 382dfbee  move.w -$412(a5), d4
        move.w -$412(a5), d4
L012_0000165C:
; H012+$0000165C: 5a44  addq.w #$5, d4
        addq.w #$5, d4
L012_0000165E:
; H012+$0000165E: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001660:
; H012+$00001660: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001666:
; H012+$00001666: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L012_0000166A:
; H012+$0000166A: 37802000  move.w d0, (a3, d2.w)
        move.w d0, (a3, d2.w)
L012_0000166E:
; H012+$0000166E: 526dfbee  addq.w #$1, -$412(a5)
        addq.w #$1, -$412(a5)
L012_00001672:
; H012+$00001672: 64cc  bcc.b $1640
        bcc.b H012+$1640
L012_00001674:
; H012+$00001674: 3b7c0001fbee  move.w #$1, -$412(a5)
        move.w #$1, -$412(a5)
L012_0000167A:
; H012+$0000167A: 0c6d0003fbee  cmpi.w #$3, -$412(a5)
        cmpi.w #$3, -$412(a5)
L012_00001680:
; H012+$00001680: 62000032  bhi.w $16b4
        bhi.w H012+$16B4
L012_00001684:
; H012+$00001684: 342dfbee  move.w -$412(a5), d2
        move.w -$412(a5), d2
L012_00001688:
; H012+$00001688: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_0000168A:
; H012+$0000168A: e142  asl.w #$8, d2
        asl.w #$8, d2
L012_0000168C:
; H012+$0000168C: 47edfcf4  lea.l -$30c(a5), a3
        lea.l -$30c(a5), a3
L012_00001690:
; H012+$00001690: 382dfbee  move.w -$412(a5), d4
        move.w -$412(a5), d4
L012_00001694:
; H012+$00001694: 5344  subq.w #$1, d4
        subq.w #$1, d4
L012_00001696:
; H012+$00001696: e144  asl.w #$8, d4
        asl.w #$8, d4
L012_00001698:
; H012+$00001698: 45f900000052  lea.l $52.l, a2
        lea.l (H061+$52).l, a2
L012_0000169E:
; H012+$0000169E: 45f24000  lea.l (a2, d4.w), a2
        lea.l (a2, d4.w), a2
L012_000016A2:
; H012+$000016A2: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L012_000016A6:
; H012+$000016A6: 743f  moveq #$3f, d2
        moveq #63, d2
L012_000016A8:
; H012+$000016A8: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L012_000016AA:
; H012+$000016AA: 51cafffc  dbra d2, $16a8
        dbra d2, H012+$16A8
L012_000016AE:
; H012+$000016AE: 526dfbee  addq.w #$1, -$412(a5)
        addq.w #$1, -$412(a5)
L012_000016B2:
; H012+$000016B2: 64c6  bcc.b $167a
        bcc.b H012+$167A
L012_000016B4:
; H012+$000016B4: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000016B8:
; H012+$000016B8: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000016BE:
; H012+$000016BE: 3b40fbf2  move.w d0, -$40e(a5)
        move.w d0, -$40e(a5)
L012_000016C2:
; H012+$000016C2: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000016C6:
; H012+$000016C6: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000016CC:
; H012+$000016CC: 3b40fbf0  move.w d0, -$410(a5)
        move.w d0, -$410(a5)
; STATE: H005+$281C = start of the coordinates/view block
L012_000016D0:
; H012+$000016D0: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L012_000016D6:
; H012+$000016D6: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
L012_000016DC:
; H012+$000016DC: 1f3900002820  move.b $2820.l, -(a7)
        move.b (H005+$2820).l, -(a7)
; -> H061+$1C42 (sub_H061_00001C42)
L012_000016E2:
; H012+$000016E2: 4eb900001c42  jsr $1c42.l
        jsr (H061+$1C42).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000016E8:
; H012+$000016E8: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000016EE:
; H012+$000016EE: 37400582  move.w d0, $582(a3)
        move.w d0, $582(a3)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000016F2:
; H012+$000016F2: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000016F8:
; H012+$000016F8: 342b0580  move.w $580(a3), d2
        move.w $580(a3), d2
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000016FC:
; H012+$000016FC: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001702:
; H012+$00001702: b46b0582  cmp.w $582(a3), d2
        cmp.w $582(a3), d2
L012_00001706:
; H012+$00001706: 64000014  bcc.w $171c
        bcc.w H012+$171C
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_0000170A:
; H012+$0000170A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001710:
; H012+$00001710: 247900003e00  movea.l $3e00.l, a2
        movea.l (H005+$3E00).l, a2
L012_00001716:
; H012+$00001716: 356b05800582  move.w $580(a3), $582(a2)
        move.w $580(a3), $582(a2)
L012_0000171C:
; H012+$0000171C: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L012_00001722:
; H012+$00001722: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001728:
; H012+$00001728: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_0000172E:
; H012+$0000172E: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L012_00001732:
; H012+$00001732: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00001734:
; H012+$00001734: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L012_0000173A:
; H012+$0000173A: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
L012_00001740:
; H012+$00001740: 4a39000024bd  tst.b $24bd.l
        tst.b (H005+$24BD).l
L012_00001746:
; H012+$00001746: 6700002e  beq.w $1776
        beq.w H012+$1776
L012_0000174A:
; H012+$0000174A: 4a39000024bc  tst.b $24bc.l
        tst.b (H005+$24BC).l
L012_00001750:
; H012+$00001750: 67000024  beq.w $1776
        beq.w H012+$1776
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00001754:
; H012+$00001754: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_0000175A:
; H012+$0000175A: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_0000175E:
; H012+$0000175E: 67000016  beq.w $1776
        beq.w H012+$1776
L012_00001762:
; H012+$00001762: 7400  moveq #$0, d2
        moveq #0, d2
L012_00001764:
; H012+$00001764: 143900002486  move.b $2486.l, d2
        move.b (H005+$2486).l, d2
L012_0000176A:
; H012+$0000176A: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L012_0000176E:
; H012+$0000176E: 67000006  beq.w $1776
        beq.w H012+$1776
L012_00001772:
; H012+$00001772: 7401  moveq #$1, d2
        moveq #1, d2
L012_00001774:
; H012+$00001774: 6002  bra.b $1778
        bra.b H012+$1778
L012_00001776:
; H012+$00001776: 7400  moveq #$0, d2
        moveq #0, d2
L012_00001778:
; H012+$00001778: 1b42fbe7  move.b d2, -$419(a5)
        move.b d2, -$419(a5)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_0000177C:
; H012+$0000177C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00001782:
; H012+$00001782: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_00001786:
; H012+$00001786: 56c2  sne.b d2
        sne.b d2
L012_00001788:
; H012+$00001788: 4402  neg.b d2
        neg.b d2
L012_0000178A:
; H012+$0000178A: 1b42fbe8  move.b d2, -$418(a5)
        move.b d2, -$418(a5)
L012_0000178E:
; H012+$0000178E: 422dfbe9  clr.b -$417(a5)
        clr.b -$417(a5)
L012_00001792:
; H012+$00001792: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L012_0000179A:
; H012+$0000179A: 33fc00110000334c  move.w #$11, $334c.l
        move.w #$11, (H005+$334C).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000017A2:
; H012+$000017A2: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000017A8:
; H012+$000017A8: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L012_000017AC:
; H012+$000017AC: 600000d4  bra.w $1882
        bra.w H012+$1882
L012_000017B0:
; H012+$000017B0: 3b7c0001fbb6  move.w #$1, -$44a(a5)
        move.w #$1, -$44a(a5)
L012_000017B6:
; H012+$000017B6: 342dfbb6  move.w -$44a(a5), d2
        move.w -$44a(a5), d2
L012_000017BA:
; H012+$000017BA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000017BC:
; H012+$000017BC: e142  asl.w #$8, d2
        asl.w #$8, d2
L012_000017BE:
; H012+$000017BE: 47edfcf4  lea.l -$30c(a5), a3
        lea.l -$30c(a5), a3
L012_000017C2:
; H012+$000017C2: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L012_000017C6:
; H012+$000017C6: 45edfbf4  lea.l -$40c(a5), a2
        lea.l -$40c(a5), a2
L012_000017CA:
; H012+$000017CA: 743f  moveq #$3f, d2
        moveq #63, d2
L012_000017CC:
; H012+$000017CC: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L012_000017CE:
; H012+$000017CE: 51cafffc  dbra d2, $17cc
        dbra d2, H012+$17CC
L012_000017D2:
; H012+$000017D2: 526dfbb6  addq.w #$1, -$44a(a5)
        addq.w #$1, -$44a(a5)
L012_000017D6:
; H012+$000017D6: 4a2dfbf4  tst.b -$40c(a5)
        tst.b -$40c(a5)
L012_000017DA:
; H012+$000017DA: 6600000a  bne.w $17e6
        bne.w H012+$17E6
L012_000017DE:
; H012+$000017DE: 0c6d0003fbb6  cmpi.w #$3, -$44a(a5)
        cmpi.w #$3, -$44a(a5)
L012_000017E4:
; H012+$000017E4: 63d0  bls.b $17b6
        bls.b H012+$17B6
L012_000017E6:
; H012+$000017E6: 4e75  rts 
        rts 
L012_000017E8:
; H012+$000017E8: 3b7c0002fbb6  move.w #$2, -$44a(a5)
        move.w #$2, -$44a(a5)
L012_000017EE:
; H012+$000017EE: 342dfbb6  move.w -$44a(a5), d2
        move.w -$44a(a5), d2
L012_000017F2:
; H012+$000017F2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_000017F4:
; H012+$000017F4: e142  asl.w #$8, d2
        asl.w #$8, d2
L012_000017F6:
; H012+$000017F6: 47edfcf4  lea.l -$30c(a5), a3
        lea.l -$30c(a5), a3
L012_000017FA:
; H012+$000017FA: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L012_000017FE:
; H012+$000017FE: 45edfbf4  lea.l -$40c(a5), a2
        lea.l -$40c(a5), a2
L012_00001802:
; H012+$00001802: 743f  moveq #$3f, d2
        moveq #63, d2
L012_00001804:
; H012+$00001804: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L012_00001806:
; H012+$00001806: 51cafffc  dbra d2, $1804
        dbra d2, H012+$1804
L012_0000180A:
; H012+$0000180A: 526dfbb6  addq.w #$1, -$44a(a5)
        addq.w #$1, -$44a(a5)
L012_0000180E:
; H012+$0000180E: 0c6d0003fbb6  cmpi.w #$3, -$44a(a5)
        cmpi.w #$3, -$44a(a5)
L012_00001814:
; H012+$00001814: 63000008  bls.w $181e
        bls.w H012+$181E
L012_00001818:
; H012+$00001818: 3b7c0001fbb6  move.w #$1, -$44a(a5)
        move.w #$1, -$44a(a5)
L012_0000181E:
; H012+$0000181E: 4a2dfbf4  tst.b -$40c(a5)
        tst.b -$40c(a5)
L012_00001822:
; H012+$00001822: 6600000a  bne.w $182e
        bne.w H012+$182E
L012_00001826:
; H012+$00001826: 0c6d0002fbb6  cmpi.w #$2, -$44a(a5)
        cmpi.w #$2, -$44a(a5)
L012_0000182C:
; H012+$0000182C: 66c0  bne.b $17ee
        bne.b H012+$17EE
L012_0000182E:
; H012+$0000182E: 4e75  rts 
        rts 
L012_00001830:
; H012+$00001830: 3b7c0003fbb6  move.w #$3, -$44a(a5)
        move.w #$3, -$44a(a5)
L012_00001836:
; H012+$00001836: 342dfbb6  move.w -$44a(a5), d2
        move.w -$44a(a5), d2
L012_0000183A:
; H012+$0000183A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_0000183C:
; H012+$0000183C: e142  asl.w #$8, d2
        asl.w #$8, d2
L012_0000183E:
; H012+$0000183E: 47edfcf4  lea.l -$30c(a5), a3
        lea.l -$30c(a5), a3
L012_00001842:
; H012+$00001842: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L012_00001846:
; H012+$00001846: 45edfbf4  lea.l -$40c(a5), a2
        lea.l -$40c(a5), a2
L012_0000184A:
; H012+$0000184A: 743f  moveq #$3f, d2
        moveq #63, d2
L012_0000184C:
; H012+$0000184C: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L012_0000184E:
; H012+$0000184E: 51cafffc  dbra d2, $184c
        dbra d2, H012+$184C
L012_00001852:
; H012+$00001852: 526dfbb6  addq.w #$1, -$44a(a5)
        addq.w #$1, -$44a(a5)
L012_00001856:
; H012+$00001856: 0c6d0003fbb6  cmpi.w #$3, -$44a(a5)
        cmpi.w #$3, -$44a(a5)
L012_0000185C:
; H012+$0000185C: 63000008  bls.w $1866
        bls.w H012+$1866
L012_00001860:
; H012+$00001860: 3b7c0001fbb6  move.w #$1, -$44a(a5)
        move.w #$1, -$44a(a5)
L012_00001866:
; H012+$00001866: 4a2dfbf4  tst.b -$40c(a5)
        tst.b -$40c(a5)
L012_0000186A:
; H012+$0000186A: 6600000a  bne.w $1876
        bne.w H012+$1876
L012_0000186E:
; H012+$0000186E: 0c6d0003fbb6  cmpi.w #$3, -$44a(a5)
        cmpi.w #$3, -$44a(a5)
L012_00001874:
; H012+$00001874: 66c0  bne.b $1836
        bne.b H012+$1836
L012_00001876:
; H012+$00001876: 4e75  rts 
        rts 
L012_00001878:
; H012+$00001878: 4e75  rts 
        rts 
; Preserved bytes H012+$0000187A..$00001882; code/data not fully classified.
        dc.w $FFFC,$FF34,$FF6C,$FFB4
L012_00001882:
; H012+$00001882: 47fafff8  lea.l $187c(pc), a3
        lea.l H012+$187C(pc), a3
L012_00001886:
; H012+$00001886: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L012_0000188A:
; H012+$0000188A: 6302  bls.b $188e
        bls.b H012+$188E
L012_0000188C:
; H012+$0000188C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_0000188E:
; H012+$0000188E: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001890:
; H012+$00001890: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$187C; indices 0..2, default -1.
L012_00001894:
; H012+$00001894: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001898:
; H012+$00001898: 4a2dfbf4  tst.b -$40c(a5)
        tst.b -$40c(a5)
L012_0000189C:
; H012+$0000189C: 66000006  bne.w $18a4
        bne.w H012+$18A4
L012_000018A0:
; H012+$000018A0: 422dfbe8  clr.b -$418(a5)
        clr.b -$418(a5)
L012_000018A4:
; H012+$000018A4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_000018A8:
; H012+$000018A8: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_000018AC:
; H012+$000018AC: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_000018B0:
; H012+$000018B0: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_000018B4:
; H012+$000018B4: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_000018B8:
; H012+$000018B8: 4267  clr.w -(a7)
        clr.w -(a7)
L012_000018BA:
; H012+$000018BA: 1f2dfbe8  move.b -$418(a5), -(a7)
        move.b -$418(a5), -(a7)
L012_000018BE:
; H012+$000018BE: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L012_000018C2:
; H012+$000018C2: 486dfbf4  pea.l -$40c(a5)
        pea.l -$40c(a5)
; -> H030+$0302 (trampoline_H030_0470)
L012_000018C6:
; H012+$000018C6: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000018CC:
; H012+$000018CC: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000018D2:
; H012+$000018D2: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L012_000018D6:
; H012+$000018D6: 67000010  beq.w $18e8
        beq.w H012+$18E8
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_000018DA:
; H012+$000018DA: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_000018E0:
; H012+$000018E0: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_000018E4:
; H012+$000018E4: 66000016  bne.w $18fc
        bne.w H012+$18FC
L012_000018E8:
; H012+$000018E8: 47ec0040  lea.l $40(a4), a3
        lea.l $40(a4), a3
L012_000018EC:
; H012+$000018EC: 45edfbbc  lea.l -$444(a5), a2
        lea.l -$444(a5), a2
L012_000018F0:
; H012+$000018F0: 7428  moveq #$28, d2
        moveq #40, d2
L012_000018F2:
; H012+$000018F2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L012_000018F4:
; H012+$000018F4: 57cafffc  dbeq d2, $18f2
        dbeq d2, H012+$18F2
L012_000018F8:
; H012+$000018F8: 60000012  bra.w $190c
        bra.w H012+$190C
L012_000018FC:
; H012+$000018FC: 47ec0023  lea.l $23(a4), a3
        lea.l $23(a4), a3
L012_00001900:
; H012+$00001900: 45edfbbc  lea.l -$444(a5), a2
        lea.l -$444(a5), a2
L012_00001904:
; H012+$00001904: 7428  moveq #$28, d2
        moveq #40, d2
L012_00001906:
; H012+$00001906: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L012_00001908:
; H012+$00001908: 57cafffc  dbeq d2, $1906
        dbeq d2, H012+$1906
L012_0000190C:
; H012+$0000190C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001910:
; H012+$00001910: 486dfbba  pea.l -$446(a5)
        pea.l -$446(a5)
L012_00001914:
; H012+$00001914: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L012_00001918:
; H012+$00001918: 486dfbbc  pea.l -$444(a5)
        pea.l -$444(a5)
L012_0000191C:
; H012+$0000191C: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L012_00001920:
; H012+$00001920: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00001924:
; H012+$00001924: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L012_00001928:
; H012+$00001928: 4227  clr.b -(a7)
        clr.b -(a7)
L012_0000192A:
; H012+$0000192A: 1f2dfbe7  move.b -$419(a5), -(a7)
        move.b -$419(a5), -(a7)
; -> H061+$36E6 (sub_H061_000036E6)
L012_0000192E:
; H012+$0000192E: 4eb9000036e6  jsr $36e6.l
        jsr (H061+$36E6).l
L012_00001934:
; H012+$00001934: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001938:
; H012+$00001938: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_0000193E:
; H012+$0000193E: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L012_00001942:
; H012+$00001942: 67000010  beq.w $1954
        beq.w H012+$1954
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00001946:
; H012+$00001946: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_0000194C:
; H012+$0000194C: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_00001950:
; H012+$00001950: 66000012  bne.w $1964
        bne.w H012+$1964
L012_00001954:
; H012+$00001954: 0c6d0003fffe  cmpi.w #$3, -$2(a5)
        cmpi.w #$3, -$2(a5)
L012_0000195A:
; H012+$0000195A: 66000008  bne.w $1964
        bne.w H012+$1964
L012_0000195E:
; H012+$0000195E: 3b7c0004fffe  move.w #$4, -$2(a5)
        move.w #$4, -$2(a5)
L012_00001964:
; H012+$00001964: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00001968:
; H012+$00001968: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_0000196A:
; H012+$0000196A: 47edfff4  lea.l -$c(a5), a3
        lea.l -$c(a5), a3
L012_0000196E:
; H012+$0000196E: 3b732000fbb8  move.w (a3, d2.w), -$448(a5)
        move.w (a3, d2.w), -$448(a5)
L012_00001974:
; H012+$00001974: 342dfbb8  move.w -$448(a5), d2
        move.w -$448(a5), d2
L012_00001978:
; H012+$00001978: 6000042e  bra.w $1da8
        bra.w H012+$1DA8
L012_0000197C:
; H012+$0000197C: 0c6d0002fffe  cmpi.w #$2, -$2(a5)
        cmpi.w #$2, -$2(a5)
L012_00001982:
; H012+$00001982: 67000014  beq.w $1998
        beq.w H012+$1998
L012_00001986:
; H012+$00001986: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_0000198A:
; H012+$0000198A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_0000198E:
; H012+$0000198E: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001994:
; H012+$00001994: 6000002e  bra.w $19c4
        bra.w H012+$19C4
L012_00001998:
; H012+$00001998: 342dfbea  move.w -$416(a5), d2
        move.w -$416(a5), d2
L012_0000199C:
; H012+$0000199C: b46dfbf2  cmp.w -$40e(a5), d2
        cmp.w -$40e(a5), d2
L012_000019A0:
; H012+$000019A0: 65000014  bcs.w $19b6
        bcs.w H012+$19B6
L012_000019A4:
; H012+$000019A4: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_000019A8:
; H012+$000019A8: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_000019AC:
; H012+$000019AC: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_000019B2:
; H012+$000019B2: 60000010  bra.w $19c4
        bra.w H012+$19C4
L012_000019B6:
; H012+$000019B6: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_000019BA:
; H012+$000019BA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_000019BE:
; H012+$000019BE: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_000019C4:
; H012+$000019C4: 4e75  rts 
        rts 
L012_000019C6:
; H012+$000019C6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_000019CA:
; H012+$000019CA: 60000126  bra.w $1af2
        bra.w H012+$1AF2
L012_000019CE:
; H012+$000019CE: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_000019D2:
; H012+$000019D2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_000019D6:
; H012+$000019D6: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_000019DC:
; H012+$000019DC: 4e75  rts 
        rts 
L012_000019DE:
; H012+$000019DE: 1b7c0001fbe9  move.b #$1, -$417(a5)
        move.b #$1, -$417(a5)
L012_000019E4:
; H012+$000019E4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_000019E8:
; H012+$000019E8: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_000019EC:
; H012+$000019EC: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_000019F0:
; H012+$000019F0: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_000019F4:
; H012+$000019F4: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_000019F8:
; H012+$000019F8: 4267  clr.w -(a7)
        clr.w -(a7)
L012_000019FA:
; H012+$000019FA: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_000019FE:
; H012+$000019FE: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L012_00001A02:
; H012+$00001A02: 486c005e  pea.l $5e(a4)
        pea.l $5e(a4)
; -> H030+$0302 (trampoline_H030_0470)
L012_00001A06:
; H012+$00001A06: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L012_00001A0C:
; H012+$00001A0C: 4e75  rts 
        rts 
L012_00001A0E:
; H012+$00001A0E: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001A12:
; H012+$00001A12: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001A16:
; H012+$00001A16: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001A1C:
; H012+$00001A1C: 4e75  rts 
        rts 
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001A1E:
; H012+$00001A1E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001A24:
; H012+$00001A24: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L012_00001A28:
; H012+$00001A28: 67000034  beq.w $1a5e
        beq.w H012+$1A5E
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001A2C:
; H012+$00001A2C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001A32:
; H012+$00001A32: 536b0582  subq.w #$1, $582(a3)
        subq.w #$1, $582(a3)
L012_00001A36:
; H012+$00001A36: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L012_00001A3C:
; H012+$00001A3C: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001A42:
; H012+$00001A42: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001A48:
; H012+$00001A48: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L012_00001A4C:
; H012+$00001A4C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00001A4E:
; H012+$00001A4E: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L012_00001A54:
; H012+$00001A54: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
L012_00001A5A:
; H012+$00001A5A: 60000030  bra.w $1a8c
        bra.w H012+$1A8C
L012_00001A5E:
; H012+$00001A5E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001A62:
; H012+$00001A62: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_00001A66:
; H012+$00001A66: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_00001A6A:
; H012+$00001A6A: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_00001A6E:
; H012+$00001A6E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00001A72:
; H012+$00001A72: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00001A74:
; H012+$00001A74: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00001A78:
; H012+$00001A78: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L012_00001A7C:
; H012+$00001A7C: 486c006f  pea.l $6f(a4)
        pea.l $6f(a4)
; -> H030+$0302 (trampoline_H030_0470)
L012_00001A80:
; H012+$00001A80: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L012_00001A86:
; H012+$00001A86: 1b7c0001fbe9  move.b #$1, -$417(a5)
        move.b #$1, -$417(a5)
L012_00001A8C:
; H012+$00001A8C: 4e75  rts 
        rts 
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001A8E:
; H012+$00001A8E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001A94:
; H012+$00001A94: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L012_00001A98:
; H012+$00001A98: 62000014  bhi.w $1aae
        bhi.w H012+$1AAE
L012_00001A9C:
; H012+$00001A9C: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001AA0:
; H012+$00001AA0: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001AA4:
; H012+$00001AA4: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001AAA:
; H012+$00001AAA: 60000036  bra.w $1ae2
        bra.w H012+$1AE2
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001AAE:
; H012+$00001AAE: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001AB4:
; H012+$00001AB4: 536b0582  subq.w #$1, $582(a3)
        subq.w #$1, $582(a3)
L012_00001AB8:
; H012+$00001AB8: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L012_00001ABE:
; H012+$00001ABE: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001AC4:
; H012+$00001AC4: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001ACA:
; H012+$00001ACA: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L012_00001ACE:
; H012+$00001ACE: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00001AD0:
; H012+$00001AD0: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L012_00001AD6:
; H012+$00001AD6: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
L012_00001ADC:
; H012+$00001ADC: 1b7c0001fbe9  move.b #$1, -$417(a5)
        move.b #$1, -$417(a5)
L012_00001AE2:
; H012+$00001AE2: 4e75  rts 
        rts 
L012_00001AE4:
; H012+$00001AE4: 4e75  rts 
        rts 
; Preserved bytes H012+$00001AE6..$00001AF2; code/data not fully classified.
        dc.w $FFFC,$FEE6,$FEF6,$FF26,$FF36,$FFA6
L012_00001AF2:
; H012+$00001AF2: 47fafff4  lea.l $1ae8(pc), a3
        lea.l H012+$1AE8(pc), a3
L012_00001AF6:
; H012+$00001AF6: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L012_00001AFA:
; H012+$00001AFA: 6302  bls.b $1afe
        bls.b H012+$1AFE
L012_00001AFC:
; H012+$00001AFC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001AFE:
; H012+$00001AFE: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001B00:
; H012+$00001B00: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$1AE8; indices 0..4, default -1.
L012_00001B04:
; H012+$00001B04: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001B08:
; H012+$00001B08: 4e75  rts 
        rts 
L012_00001B0A:
; H012+$00001B0A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00001B0E:
; H012+$00001B0E: 600000ba  bra.w $1bca
        bra.w H012+$1BCA
L012_00001B12:
; H012+$00001B12: 342dfbf0  move.w -$410(a5), d2
        move.w -$410(a5), d2
L012_00001B16:
; H012+$00001B16: b46dfbec  cmp.w -$414(a5), d2
        cmp.w -$414(a5), d2
L012_00001B1A:
; H012+$00001B1A: 6300004a  bls.w $1b66
        bls.w H012+$1B66
L012_00001B1E:
; H012+$00001B1E: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001B22:
; H012+$00001B22: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001B24:
; H012+$00001B24: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001B2A:
; H012+$00001B2A: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L012_00001B32:
; H012+$00001B32: 33fc00110000334c  move.w #$11, $334c.l
        move.w #$11, (H005+$334C).l
L012_00001B3A:
; H012+$00001B3A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001B3E:
; H012+$00001B3E: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_00001B42:
; H012+$00001B42: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_00001B46:
; H012+$00001B46: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_00001B4A:
; H012+$00001B4A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00001B4E:
; H012+$00001B4E: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00001B50:
; H012+$00001B50: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00001B54:
; H012+$00001B54: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L012_00001B58:
; H012+$00001B58: 486c0080  pea.l $80(a4)
        pea.l $80(a4)
; -> H030+$0302 (trampoline_H030_0470)
L012_00001B5C:
; H012+$00001B5C: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L012_00001B62:
; H012+$00001B62: 60000010  bra.w $1b74
        bra.w H012+$1B74
L012_00001B66:
; H012+$00001B66: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001B6A:
; H012+$00001B6A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001B6E:
; H012+$00001B6E: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001B74:
; H012+$00001B74: 4e75  rts 
        rts 
L012_00001B76:
; H012+$00001B76: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001B7A:
; H012+$00001B7A: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001B7C:
; H012+$00001B7C: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001B82:
; H012+$00001B82: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L012_00001B8A:
; H012+$00001B8A: 33fc00110000334c  move.w #$11, $334c.l
        move.w #$11, (H005+$334C).l
L012_00001B92:
; H012+$00001B92: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001B96:
; H012+$00001B96: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_00001B9A:
; H012+$00001B9A: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_00001B9E:
; H012+$00001B9E: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_00001BA2:
; H012+$00001BA2: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00001BA6:
; H012+$00001BA6: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00001BA8:
; H012+$00001BA8: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00001BAC:
; H012+$00001BAC: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L012_00001BB0:
; H012+$00001BB0: 486c0093  pea.l $93(a4)
        pea.l $93(a4)
; -> H030+$0302 (trampoline_H030_0470)
L012_00001BB4:
; H012+$00001BB4: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L012_00001BBA:
; H012+$00001BBA: 4e75  rts 
        rts 
L012_00001BBC:
; H012+$00001BBC: 4e75  rts 
        rts 
; Preserved bytes H012+$00001BBE..$00001BCA; code/data not fully classified.
        dc.w $FFFC,$FF52,$FFB6,$FFB6,$FFB6,$FFB6
L012_00001BCA:
; H012+$00001BCA: 47fafff4  lea.l $1bc0(pc), a3
        lea.l H012+$1BC0(pc), a3
L012_00001BCE:
; H012+$00001BCE: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L012_00001BD2:
; H012+$00001BD2: 6302  bls.b $1bd6
        bls.b H012+$1BD6
L012_00001BD4:
; H012+$00001BD4: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001BD6:
; H012+$00001BD6: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001BD8:
; H012+$00001BD8: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$1BC0; indices 0..4, default -1.
L012_00001BDC:
; H012+$00001BDC: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001BE0:
; H012+$00001BE0: 4e75  rts 
        rts 
L012_00001BE2:
; H012+$00001BE2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00001BE6:
; H012+$00001BE6: 600000f6  bra.w $1cde
        bra.w H012+$1CDE
L012_00001BEA:
; H012+$00001BEA: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001BEE:
; H012+$00001BEE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001BF2:
; H012+$00001BF2: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001BF8:
; H012+$00001BF8: 4e75  rts 
        rts 
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001BFA:
; H012+$00001BFA: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001C00:
; H012+$00001C00: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L012_00001C04:
; H012+$00001C04: 67000034  beq.w $1c3a
        beq.w H012+$1C3A
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001C08:
; H012+$00001C08: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001C0E:
; H012+$00001C0E: 536b0582  subq.w #$1, $582(a3)
        subq.w #$1, $582(a3)
L012_00001C12:
; H012+$00001C12: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L012_00001C18:
; H012+$00001C18: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001C1E:
; H012+$00001C1E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001C24:
; H012+$00001C24: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L012_00001C28:
; H012+$00001C28: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00001C2A:
; H012+$00001C2A: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L012_00001C30:
; H012+$00001C30: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
L012_00001C36:
; H012+$00001C36: 6000002a  bra.w $1c62
        bra.w H012+$1C62
L012_00001C3A:
; H012+$00001C3A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00001C3E:
; H012+$00001C3E: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_00001C42:
; H012+$00001C42: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_00001C46:
; H012+$00001C46: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_00001C4A:
; H012+$00001C4A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00001C4E:
; H012+$00001C4E: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00001C50:
; H012+$00001C50: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00001C54:
; H012+$00001C54: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L012_00001C58:
; H012+$00001C58: 486c00a6  pea.l $a6(a4)
        pea.l $a6(a4)
; -> H030+$0302 (trampoline_H030_0470)
L012_00001C5C:
; H012+$00001C5C: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L012_00001C62:
; H012+$00001C62: 1b7c0001fbe9  move.b #$1, -$417(a5)
        move.b #$1, -$417(a5)
L012_00001C68:
; H012+$00001C68: 4e75  rts 
        rts 
L012_00001C6A:
; H012+$00001C6A: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001C6E:
; H012+$00001C6E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001C72:
; H012+$00001C72: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001C78:
; H012+$00001C78: 4e75  rts 
        rts 
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001C7A:
; H012+$00001C7A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001C80:
; H012+$00001C80: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L012_00001C84:
; H012+$00001C84: 62000014  bhi.w $1c9a
        bhi.w H012+$1C9A
L012_00001C88:
; H012+$00001C88: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001C8C:
; H012+$00001C8C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001C90:
; H012+$00001C90: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001C96:
; H012+$00001C96: 60000036  bra.w $1cce
        bra.w H012+$1CCE
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001C9A:
; H012+$00001C9A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001CA0:
; H012+$00001CA0: 536b0582  subq.w #$1, $582(a3)
        subq.w #$1, $582(a3)
L012_00001CA4:
; H012+$00001CA4: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L012_00001CAA:
; H012+$00001CAA: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001CB0:
; H012+$00001CB0: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001CB6:
; H012+$00001CB6: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L012_00001CBA:
; H012+$00001CBA: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00001CBC:
; H012+$00001CBC: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L012_00001CC2:
; H012+$00001CC2: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
L012_00001CC8:
; H012+$00001CC8: 1b7c0001fbe9  move.b #$1, -$417(a5)
        move.b #$1, -$417(a5)
L012_00001CCE:
; H012+$00001CCE: 4e75  rts 
        rts 
L012_00001CD0:
; H012+$00001CD0: 4e75  rts 
        rts 
; Preserved bytes H012+$00001CD2..$00001CDE; code/data not fully classified.
        dc.w $FFFC,$FF16,$FF26,$FF96,$FF26,$FFA6
L012_00001CDE:
; H012+$00001CDE: 47fafff4  lea.l $1cd4(pc), a3
        lea.l H012+$1CD4(pc), a3
L012_00001CE2:
; H012+$00001CE2: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L012_00001CE6:
; H012+$00001CE6: 6302  bls.b $1cea
        bls.b H012+$1CEA
L012_00001CE8:
; H012+$00001CE8: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001CEA:
; H012+$00001CEA: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001CEC:
; H012+$00001CEC: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$1CD4; indices 0..4, default -1.
L012_00001CF0:
; H012+$00001CF0: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001CF4:
; H012+$00001CF4: 4e75  rts 
        rts 
L012_00001CF6:
; H012+$00001CF6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00001CFA:
; H012+$00001CFA: 60000086  bra.w $1d82
        bra.w H012+$1D82
L012_00001CFE:
; H012+$00001CFE: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001D02:
; H012+$00001D02: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001D06:
; H012+$00001D06: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001D0C:
; H012+$00001D0C: 4e75  rts 
        rts 
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001D0E:
; H012+$00001D0E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001D14:
; H012+$00001D14: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L012_00001D18:
; H012+$00001D18: 62000014  bhi.w $1d2e
        bhi.w H012+$1D2E
L012_00001D1C:
; H012+$00001D1C: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001D20:
; H012+$00001D20: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001D24:
; H012+$00001D24: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001D2A:
; H012+$00001D2A: 60000036  bra.w $1d62
        bra.w H012+$1D62
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001D2E:
; H012+$00001D2E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001D34:
; H012+$00001D34: 536b0582  subq.w #$1, $582(a3)
        subq.w #$1, $582(a3)
L012_00001D38:
; H012+$00001D38: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L012_00001D3E:
; H012+$00001D3E: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00001D44:
; H012+$00001D44: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00001D4A:
; H012+$00001D4A: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L012_00001D4E:
; H012+$00001D4E: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00001D50:
; H012+$00001D50: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L012_00001D56:
; H012+$00001D56: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
L012_00001D5C:
; H012+$00001D5C: 1b7c0001fbe9  move.b #$1, -$417(a5)
        move.b #$1, -$417(a5)
L012_00001D62:
; H012+$00001D62: 4e75  rts 
        rts 
L012_00001D64:
; H012+$00001D64: 3f2dfbb4  move.w -$44c(a5), -(a7)
        move.w -$44c(a5), -(a7)
L012_00001D68:
; H012+$00001D68: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001D6C:
; H012+$00001D6C: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001D72:
; H012+$00001D72: 4e75  rts 
        rts 
L012_00001D74:
; H012+$00001D74: 4e75  rts 
        rts 
; Preserved bytes H012+$00001D76..$00001D82; code/data not fully classified.
        dc.w $FFFC,$FF86,$FF96,$FFEC,$FF96,$FF96
L012_00001D82:
; H012+$00001D82: 47fafff4  lea.l $1d78(pc), a3
        lea.l H012+$1D78(pc), a3
L012_00001D86:
; H012+$00001D86: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L012_00001D8A:
; H012+$00001D8A: 6302  bls.b $1d8e
        bls.b H012+$1D8E
L012_00001D8C:
; H012+$00001D8C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001D8E:
; H012+$00001D8E: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001D90:
; H012+$00001D90: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$1D78; indices 0..4, default -1.
L012_00001D94:
; H012+$00001D94: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001D98:
; H012+$00001D98: 4e75  rts 
        rts 
L012_00001D9A:
; H012+$00001D9A: 4e75  rts 
        rts 
; Preserved bytes H012+$00001D9C..$00001DA8; code/data not fully classified.
        dc.w $FFFC,$FBDE,$FC28,$FD6C,$FE44,$FF58
L012_00001DA8:
; H012+$00001DA8: 47fafff4  lea.l $1d9e(pc), a3
        lea.l H012+$1D9E(pc), a3
L012_00001DAC:
; H012+$00001DAC: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L012_00001DB0:
; H012+$00001DB0: 6302  bls.b $1db4
        bls.b H012+$1DB4
L012_00001DB2:
; H012+$00001DB2: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00001DB4:
; H012+$00001DB4: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001DB6:
; H012+$00001DB6: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$1D9E; indices 0..4, default -1.
L012_00001DBA:
; H012+$00001DBA: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00001DBE:
; H012+$00001DBE: 4a2dfbe9  tst.b -$417(a5)
        tst.b -$417(a5)
L012_00001DC2:
; H012+$00001DC2: 6600f97c  bne.w $1740
        bne.w H012+$1740
; -> H008+$139E (sub_H008_0000139E)
L012_00001DC6:
; H012+$00001DC6: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
L012_00001DCC:
; H012+$00001DCC: 4239000024ce  clr.b $24ce.l
        clr.b (H005+$24CE).l
L012_00001DD2:
; H012+$00001DD2: 4239000024b4  clr.b $24b4.l
        clr.b (H005+$24B4).l
L012_00001DD8:
; H012+$00001DD8: 4e5d  unlk a5
        unlk a5
L012_00001DDA:
; H012+$00001DDA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00001DDC:
; H012+$00001DDC: 4e75  rts 
        rts 
; FUNCTION: ECL_44_PARLAY
FN_ECL_44_PARLAY:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_44 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 44=PARLAY.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F00
; --------------------------------------------------------------------------
L012_00001DDE:
; H012+$00001DDE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00001DE0:
; H012+$00001DE0: 287ae392  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00001DE4:
; H012+$00001DE4: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L012_00001DE8:
; H012+$00001DE8: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00001DEC:
; H012+$00001DEC: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00001DF2:
; H012+$00001DF2: 422dffed  clr.b -$13(a5)
        clr.b -$13(a5)
L012_00001DF6:
; H012+$00001DF6: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L012_00001DFA:
; H012+$00001DFA: 0c6d0004fffa  cmpi.w #$4, -$6(a5)
        cmpi.w #$4, -$6(a5)
L012_00001E00:
; H012+$00001E00: 6200002c  bhi.w $1e2e
        bhi.w H012+$1E2E
L012_00001E04:
; H012+$00001E04: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_00001E08:
; H012+$00001E08: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001E0A:
; H012+$00001E0A: 47edfff0  lea.l -$10(a5), a3
        lea.l -$10(a5), a3
L012_00001E0E:
; H012+$00001E0E: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L012_00001E12:
; H012+$00001E12: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L012_00001E16:
; H012+$00001E16: 5244  addq.w #$1, d4
        addq.w #$1, d4
L012_00001E18:
; H012+$00001E18: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001E1A:
; H012+$00001E1A: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001E20:
; H012+$00001E20: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L012_00001E24:
; H012+$00001E24: 37802000  move.w d0, (a3, d2.w)
        move.w d0, (a3, d2.w)
L012_00001E28:
; H012+$00001E28: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L012_00001E2C:
; H012+$00001E2C: 64cc  bcc.b $1dfa
        bcc.b H012+$1DFA
L012_00001E2E:
; H012+$00001E2E: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00001E30:
; H012+$00001E30: 486dffed  pea.l -$13(a5)
        pea.l -$13(a5)
L012_00001E34:
; H012+$00001E34: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L012_00001E38:
; H012+$00001E38: 486c00b7  pea.l $b7(a4)
        pea.l $b7(a4)
L012_00001E3C:
; H012+$00001E3C: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L012_00001E40:
; H012+$00001E40: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00001E44:
; H012+$00001E44: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L012_00001E48:
; H012+$00001E48: 4227  clr.b -(a7)
        clr.b -(a7)
L012_00001E4A:
; H012+$00001E4A: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H061+$36E6 (sub_H061_000036E6)
L012_00001E4C:
; H012+$00001E4C: 4eb9000036e6  jsr $36e6.l
        jsr (H061+$36E6).l
L012_00001E52:
; H012+$00001E52: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_00001E56:
; H012+$00001E56: 1f3900001457  move.b $1457.l, -(a7)
        move.b (H061+$1457).l, -(a7)
L012_00001E5C:
; H012+$00001E5C: 1f3900001497  move.b $1497.l, -(a7)
        move.b (H061+$1497).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_00001E62:
; H012+$00001E62: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_00001E68:
; H012+$00001E68: 3b40ffee  move.w d0, -$12(a5)
        move.w d0, -$12(a5)
L012_00001E6C:
; H012+$00001E6C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00001E70:
; H012+$00001E70: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00001E72:
; H012+$00001E72: 47edfff0  lea.l -$10(a5), a3
        lea.l -$10(a5), a3
L012_00001E76:
; H012+$00001E76: 3b732000fffc  move.w (a3, d2.w), -$4(a5)
        move.w (a3, d2.w), -$4(a5)
L012_00001E7C:
; H012+$00001E7C: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L012_00001E80:
; H012+$00001E80: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_00001E84:
; H012+$00001E84: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_00001E8A:
; H012+$00001E8A: 4e5d  unlk a5
        unlk a5
L012_00001E8C:
; H012+$00001E8C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00001E8E:
; H012+$00001E8E: 4e75  rts 
        rts 
; FUNCTION: ECL_50_FIND_ITEM
FN_ECL_50_FIND_ITEM:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_50 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 50=FIND ITEM.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F20
; --------------------------------------------------------------------------
L012_00001E90:
; H012+$00001E90: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00001E92:
; H012+$00001E92: 287ae2e0  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00001E96:
; H012+$00001E96: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L012_00001E9A:
; H012+$00001E9A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00001E9E:
; H012+$00001E9E: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00001EA4:
; H012+$00001EA4: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L012_00001EA8:
; H012+$00001EA8: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001EAC:
; H012+$00001EAC: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001EB2:
; H012+$00001EB2: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_00001EB6:
; H012+$00001EB6: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L012_00001EBA:
; H012+$00001EBA: 48790000237e  pea.l $237e.l
        pea.l (H005+$237E).l
L012_00001EC0:
; H012+$00001EC0: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L012_00001EC4:
; H012+$00001EC4: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L012_00001EC6:
; H012+$00001EC6: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L012_00001ECC:
; H012+$00001ECC: 13fc00010000237f  move.b #$1, $237f.l
        move.b #$1, (H005+$237F).l
; STATE: H005+$3364 = head of the party list
L012_00001ED4:
; H012+$00001ED4: 2b7900003364fff8  move.l $3364.l, -$8(a5)
        move.l (H005+$3364).l, -$8(a5)
L012_00001EDC:
; H012+$00001EDC: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L012_00001EE0:
; H012+$00001EE0: 67000064  beq.w $1f46
        beq.w H012+$1F46
L012_00001EE4:
; H012+$00001EE4: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L012_00001EE8:
; H012+$00001EE8: 6600005c  bne.w $1f46
        bne.w H012+$1F46
L012_00001EEC:
; H012+$00001EEC: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00001EF0:
; H012+$00001EF0: 2b6b0150fff4  move.l $150(a3), -$c(a5)
        move.l $150(a3), -$c(a5)
L012_00001EF6:
; H012+$00001EF6: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L012_00001EFA:
; H012+$00001EFA: 6700003e  beq.w $1f3a
        beq.w H012+$1F3A
L012_00001EFE:
; H012+$00001EFE: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L012_00001F02:
; H012+$00001F02: 66000036  bne.w $1f3a
        bne.w H012+$1F3A
L012_00001F06:
; H012+$00001F06: 7400  moveq #$0, d2
        moveq #0, d2
L012_00001F08:
; H012+$00001F08: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00001F0C:
; H012+$00001F0C: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L012_00001F10:
; H012+$00001F10: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L012_00001F14:
; H012+$00001F14: b842  cmp.w d2, d4
        cmp.w d2, d4
L012_00001F16:
; H012+$00001F16: 66000016  bne.w $1f2e
        bne.w H012+$1F2E
L012_00001F1A:
; H012+$00001F1A: 13fc00010000237e  move.b #$1, $237e.l
        move.b #$1, (H005+$237E).l
L012_00001F22:
; H012+$00001F22: 42390000237f  clr.b $237f.l
        clr.b (H005+$237F).l
L012_00001F28:
; H012+$00001F28: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L012_00001F2E:
; H012+$00001F2E: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L012_00001F32:
; H012+$00001F32: 2b6b002cfff4  move.l $2c(a3), -$c(a5)
        move.l $2c(a3), -$c(a5)
L012_00001F38:
; H012+$00001F38: 60bc  bra.b $1ef6
        bra.b H012+$1EF6
L012_00001F3A:
; H012+$00001F3A: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00001F3E:
; H012+$00001F3E: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
L012_00001F44:
; H012+$00001F44: 6096  bra.b $1edc
        bra.b H012+$1EDC
L012_00001F46:
; H012+$00001F46: 4e5d  unlk a5
        unlk a5
L012_00001F48:
; H012+$00001F48: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00001F4A:
; H012+$00001F4A: 4e75  rts 
        rts 
; FUNCTION: ECL_58_DELAY
FN_ECL_58_DELAY:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_58 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 58=DELAY.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F4C
; --------------------------------------------------------------------------
L012_00001F4C:
; H012+$00001F4C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00001F4E:
; H012+$00001F4E: 287ae224  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00001F52:
; H012+$00001F52: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATE: H005+$3DEA = logical ECL PC
L012_00001F56:
; H012+$00001F56: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
; -> H030+$0B4A (sub_H030_00000B4A)
L012_00001F5C:
; H012+$00001F5C: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L012_00001F62:
; H012+$00001F62: 4e5d  unlk a5
        unlk a5
L012_00001F64:
; H012+$00001F64: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00001F66:
; H012+$00001F66: 4e75  rts 
        rts 
; FUNCTION: ECL_46_DAMAGE
FN_ECL_46_DAMAGE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_46 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 46=DAMAGE.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F0C
; --------------------------------------------------------------------------
L012_00001F68:
; H012+$00001F68: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00001F6A:
; H012+$00001F6A: 287ae208  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00001F6E:
; H012+$00001F6E: 4e55ffda  link.w a5, #$ffda
        link.w a5, #$ffda
; STATE: H005+$3368 = current character
L012_00001F72:
; H012+$00001F72: 2b7900003368ffde  move.l $3368.l, -$22(a5)
        move.l (H005+$3368).l, -$22(a5)
L012_00001F7A:
; H012+$00001F7A: 422dffdd  clr.b -$23(a5)
        clr.b -$23(a5)
L012_00001F7E:
; H012+$00001F7E: 422dffdc  clr.b -$24(a5)
        clr.b -$24(a5)
; STATE: H005+$3364 = head of the party list
L012_00001F82:
; H012+$00001F82: 2b7900003364ffe6  move.l $3364.l, -$1a(a5)
        move.l (H005+$3364).l, -$1a(a5)
L012_00001F8A:
; H012+$00001F8A: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00001F8E:
; H012+$00001F8E: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00001F94:
; H012+$00001F94: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001F98:
; H012+$00001F98: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001F9E:
; H012+$00001F9E: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_00001FA2:
; H012+$00001FA2: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001FA6:
; H012+$00001FA6: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001FAC:
; H012+$00001FAC: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L012_00001FB0:
; H012+$00001FB0: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001FB4:
; H012+$00001FB4: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001FBA:
; H012+$00001FBA: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L012_00001FBE:
; H012+$00001FBE: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001FC2:
; H012+$00001FC2: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001FC8:
; H012+$00001FC8: 3b40fff2  move.w d0, -$e(a5)
        move.w d0, -$e(a5)
L012_00001FCC:
; H012+$00001FCC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00001FD0:
; H012+$00001FD0: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00001FD6:
; H012+$00001FD6: 3b40fff4  move.w d0, -$c(a5)
        move.w d0, -$c(a5)
L012_00001FDA:
; H012+$00001FDA: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L012_00001FDE:
; H012+$00001FDE: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_00001FE2:
; H012+$00001FE2: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00001FE8:
; H012+$00001FE8: 3400  move.w d0, d2
        move.w d0, d2
L012_00001FEA:
; H012+$00001FEA: d46dfff2  add.w -$e(a5), d2
        add.w -$e(a5), d2
L012_00001FEE:
; H012+$00001FEE: 3b42ffea  move.w d2, -$16(a5)
        move.w d2, -$16(a5)
L012_00001FF2:
; H012+$00001FF2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00001FF6:
; H012+$00001FF6: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00001FF8:
; H012+$00001FF8: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_00001FFC:
; H012+$00001FFC: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_00002002:
; H012+$00002002: 1b40ffdb  move.b d0, -$25(a5)
        move.b d0, -$25(a5)
L012_00002006:
; H012+$00002006: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_0000200A:
; H012+$0000200A: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_0000200C:
; H012+$0000200C: 3f3c0040  move.w #$40, -(a7)
        move.w #$40, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_00002010:
; H012+$00002010: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_00002016:
; H012+$00002016: 1400  move.b d0, d2
        move.b d0, d2
L012_00002018:
; H012+$00002018: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_0000201C:
; H012+$0000201C: 4a42  tst.w d2
        tst.w d2
L012_0000201E:
; H012+$0000201E: 6700000c  beq.w $202c
        beq.w H012+$202C
L012_00002022:
; H012+$00002022: 1b7c0001ffdc  move.b #$1, -$24(a5)
        move.b #$1, -$24(a5)
L012_00002028:
; H012+$00002028: 6000001a  bra.w $2044
        bra.w H012+$2044
L012_0000202C:
; H012+$0000202C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00002030:
; H012+$00002030: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00002036:
; H012+$00002036: 3f2b067c  move.w $67c(a3), -(a7)
        move.w $67c(a3), -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_0000203A:
; H012+$0000203A: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00002040:
; H012+$00002040: 3b40fff0  move.w d0, -$10(a5)
        move.w d0, -$10(a5)
L012_00002044:
; H012+$00002044: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00002048:
; H012+$00002048: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_0000204A:
; H012+$0000204A: 3f3c0080  move.w #$80, -(a7)
        move.w #$80, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_0000204E:
; H012+$0000204E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_00002054:
; H012+$00002054: 1400  move.b d0, d2
        move.b d0, d2
L012_00002056:
; H012+$00002056: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_0000205A:
; H012+$0000205A: 4a42  tst.w d2
        tst.w d2
L012_0000205C:
; H012+$0000205C: 670001ac  beq.w $220a
        beq.w H012+$220A
L012_00002060:
; H012+$00002060: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00002064:
; H012+$00002064: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00002066:
; H012+$00002066: 3f3c001f  move.w #$1f, -(a7)
        move.w #$1f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_0000206A:
; H012+$0000206A: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_00002070:
; H012+$00002070: 1400  move.b d0, d2
        move.b d0, d2
L012_00002072:
; H012+$00002072: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_00002076:
; H012+$00002076: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L012_0000207A:
; H012+$0000207A: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L012_0000207E:
; H012+$0000207E: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00002080:
; H012+$00002080: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_00002084:
; H012+$00002084: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_0000208A:
; H012+$0000208A: 1400  move.b d0, d2
        move.b d0, d2
L012_0000208C:
; H012+$0000208C: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_00002090:
; H012+$00002090: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L012_00002094:
; H012+$00002094: 4a2dffdc  tst.b -$24(a5)
        tst.b -$24(a5)
L012_00002098:
; H012+$00002098: 6700008e  beq.w $2128
        beq.w H012+$2128
L012_0000209C:
; H012+$0000209C: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L012_000020A0:
; H012+$000020A0: 67000082  beq.w $2124
        beq.w H012+$2124
L012_000020A4:
; H012+$000020A4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_000020A8:
; H012+$000020A8: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_000020AA:
; H012+$000020AA: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_000020AE:
; H012+$000020AE: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_000020B4:
; H012+$000020B4: 1400  move.b d0, d2
        move.b d0, d2
L012_000020B6:
; H012+$000020B6: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_000020BA:
; H012+$000020BA: 4a42  tst.w d2
        tst.w d2
L012_000020BC:
; H012+$000020BC: 67000014  beq.w $20d2
        beq.w H012+$20D2
L012_000020C0:
; H012+$000020C0: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
L012_000020C4:
; H012+$000020C4: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_000020C8:
; H012+$000020C8: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_000020CE:
; H012+$000020CE: 60000046  bra.w $2116
        bra.w H012+$2116
L012_000020D2:
; H012+$000020D2: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
L012_000020D6:
; H012+$000020D6: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L012_000020DA:
; H012+$000020DA: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_000020DC:
; H012+$000020DC: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
; -> H062+$142C (sub_H062_0000142C)
L012_000020E0:
; H012+$000020E0: 4eb90000142c  jsr $142c.l
        jsr (H062+$142C).l
L012_000020E6:
; H012+$000020E6: 1400  move.b d0, d2
        move.b d0, d2
L012_000020E8:
; H012+$000020E8: 4a02  tst.b d2
        tst.b d2
L012_000020EA:
; H012+$000020EA: 66000014  bne.w $2100
        bne.w H012+$2100
L012_000020EE:
; H012+$000020EE: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
L012_000020F2:
; H012+$000020F2: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_000020F6:
; H012+$000020F6: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_000020FC:
; H012+$000020FC: 60000018  bra.w $2116
        bra.w H012+$2116
L012_00002100:
; H012+$00002100: 4a2dffdb  tst.b -$25(a5)
        tst.b -$25(a5)
L012_00002104:
; H012+$00002104: 67000010  beq.w $2116
        beq.w H012+$2116
L012_00002108:
; H012+$00002108: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
L012_0000210C:
; H012+$0000210C: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_00002110:
; H012+$00002110: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_00002116:
; H012+$00002116: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L012_0000211A:
; H012+$0000211A: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L012_00002120:
; H012+$00002120: 6000ff7a  bra.w $209c
        bra.w H012+$209C
L012_00002124:
; H012+$00002124: 600000e0  bra.w $2206
        bra.w H012+$2206
L012_00002128:
; H012+$00002128: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L012_0000212C:
; H012+$0000212C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_0000212E:
; H012+$0000212E: 3f3c0080  move.w #$80, -(a7)
        move.w #$80, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_00002132:
; H012+$00002132: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_00002138:
; H012+$00002138: 1400  move.b d0, d2
        move.b d0, d2
L012_0000213A:
; H012+$0000213A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_0000213E:
; H012+$0000213E: 4a42  tst.w d2
        tst.w d2
L012_00002140:
; H012+$00002140: 6700005a  beq.w $219c
        beq.w H012+$219C
L012_00002144:
; H012+$00002144: 4a6dffee  tst.w -$12(a5)
        tst.w -$12(a5)
L012_00002148:
; H012+$00002148: 67000022  beq.w $216c
        beq.w H012+$216C
; STATE: H005+$3368 = current character
L012_0000214C:
; H012+$0000214C: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L012_00002152:
; H012+$00002152: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L012_00002156:
; H012+$00002156: 5342  subq.w #$1, d2
        subq.w #$1, d2
L012_00002158:
; H012+$00002158: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_0000215A:
; H012+$0000215A: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
; -> H062+$142C (sub_H062_0000142C)
L012_0000215E:
; H012+$0000215E: 4eb90000142c  jsr $142c.l
        jsr (H062+$142C).l
L012_00002164:
; H012+$00002164: 1400  move.b d0, d2
        move.b d0, d2
L012_00002166:
; H012+$00002166: 4a02  tst.b d2
        tst.b d2
L012_00002168:
; H012+$00002168: 66000016  bne.w $2180
        bne.w H012+$2180
L012_0000216C:
; H012+$0000216C: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
; STATE: H005+$3368 = current character
L012_00002170:
; H012+$00002170: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_00002176:
; H012+$00002176: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_0000217C:
; H012+$0000217C: 6000001a  bra.w $2198
        bra.w H012+$2198
L012_00002180:
; H012+$00002180: 4a2dffdb  tst.b -$25(a5)
        tst.b -$25(a5)
L012_00002184:
; H012+$00002184: 67000012  beq.w $2198
        beq.w H012+$2198
L012_00002188:
; H012+$00002188: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
; STATE: H005+$3368 = current character
L012_0000218C:
; H012+$0000218C: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_00002192:
; H012+$00002192: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_00002198:
; H012+$00002198: 6000006c  bra.w $2206
        bra.w H012+$2206
L012_0000219C:
; H012+$0000219C: 3b7c0002fff8  move.w #$2, -$8(a5)
        move.w #$2, -$8(a5)
L012_000021A2:
; H012+$000021A2: 3f2dfff0  move.w -$10(a5), -(a7)
        move.w -$10(a5), -(a7)
L012_000021A6:
; H012+$000021A6: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L012_000021AA:
; H012+$000021AA: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L012_000021AC:
; H012+$000021AC: 62000012  bhi.w $21c0
        bhi.w H012+$21C0
L012_000021B0:
; H012+$000021B0: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L012_000021B4:
; H012+$000021B4: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L012_000021BA:
; H012+$000021BA: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L012_000021BE:
; H012+$000021BE: 64e6  bcc.b $21a6
        bcc.b H012+$21A6
L012_000021C0:
; H012+$000021C0: 548f  addq.l #$2, a7
        addq.l #$2, a7
L012_000021C2:
; H012+$000021C2: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
L012_000021C6:
; H012+$000021C6: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L012_000021CA:
; H012+$000021CA: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_000021CC:
; H012+$000021CC: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
; -> H062+$142C (sub_H062_0000142C)
L012_000021D0:
; H012+$000021D0: 4eb90000142c  jsr $142c.l
        jsr (H062+$142C).l
L012_000021D6:
; H012+$000021D6: 1400  move.b d0, d2
        move.b d0, d2
L012_000021D8:
; H012+$000021D8: 4a02  tst.b d2
        tst.b d2
L012_000021DA:
; H012+$000021DA: 66000014  bne.w $21f0
        bne.w H012+$21F0
L012_000021DE:
; H012+$000021DE: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
L012_000021E2:
; H012+$000021E2: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_000021E6:
; H012+$000021E6: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_000021EC:
; H012+$000021EC: 60000018  bra.w $2206
        bra.w H012+$2206
L012_000021F0:
; H012+$000021F0: 4a2dffdb  tst.b -$25(a5)
        tst.b -$25(a5)
L012_000021F4:
; H012+$000021F4: 67000010  beq.w $2206
        beq.w H012+$2206
L012_000021F8:
; H012+$000021F8: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
L012_000021FC:
; H012+$000021FC: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_00002200:
; H012+$00002200: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_00002206:
; H012+$00002206: 6000009e  bra.w $22a6
        bra.w H012+$22A6
L012_0000220A:
; H012+$0000220A: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L012_00002210:
; H012+$00002210: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L012_00002214:
; H012+$00002214: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L012_00002218:
; H012+$00002218: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L012_0000221A:
; H012+$0000221A: 62000088  bhi.w $22a4
        bhi.w H012+$22A4
; STATE: H005+$3364 = head of the party list
L012_0000221E:
; H012+$0000221E: 2b7900003364ffe6  move.l $3364.l, -$1a(a5)
        move.l (H005+$3364).l, -$1a(a5)
L012_00002226:
; H012+$00002226: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_0000222A:
; H012+$0000222A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00002230:
; H012+$00002230: 3f2b067c  move.w $67c(a3), -(a7)
        move.w $67c(a3), -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_00002234:
; H012+$00002234: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_0000223A:
; H012+$0000223A: 3b40fff0  move.w d0, -$10(a5)
        move.w d0, -$10(a5)
L012_0000223E:
; H012+$0000223E: 3b7c0001ffec  move.w #$1, -$14(a5)
        move.w #$1, -$14(a5)
L012_00002244:
; H012+$00002244: 342dffec  move.w -$14(a5), d2
        move.w -$14(a5), d2
L012_00002248:
; H012+$00002248: b46dfff0  cmp.w -$10(a5), d2
        cmp.w -$10(a5), d2
L012_0000224C:
; H012+$0000224C: 64000012  bcc.w $2260
        bcc.w H012+$2260
L012_00002250:
; H012+$00002250: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L012_00002254:
; H012+$00002254: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L012_0000225A:
; H012+$0000225A: 526dffec  addq.w #$1, -$14(a5)
        addq.w #$1, -$14(a5)
L012_0000225E:
; H012+$0000225E: 60e4  bra.b $2244
        bra.b H012+$2244
L012_00002260:
; H012+$00002260: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
L012_00002264:
; H012+$00002264: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
; -> H062+$126C (sub_H062_0000126C)
L012_00002268:
; H012+$00002268: 4eb90000126c  jsr $126c.l
        jsr (H062+$126C).l
L012_0000226E:
; H012+$0000226E: 1400  move.b d0, d2
        move.b d0, d2
L012_00002270:
; H012+$00002270: 4a02  tst.b d2
        tst.b d2
L012_00002272:
; H012+$00002272: 67000010  beq.w $2284
        beq.w H012+$2284
L012_00002276:
; H012+$00002276: 3f2dffea  move.w -$16(a5), -(a7)
        move.w -$16(a5), -(a7)
L012_0000227A:
; H012+$0000227A: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
; -> H061+$4092 (sub_H061_00004092)
L012_0000227E:
; H012+$0000227E: 4eb900004092  jsr $4092.l
        jsr (H061+$4092).l
L012_00002284:
; H012+$00002284: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L012_00002288:
; H012+$00002288: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H062+$156C (sub_H062_0000156C)
L012_0000228C:
; H012+$0000228C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L012_00002292:
; H012+$00002292: 3400  move.w d0, d2
        move.w d0, d2
L012_00002294:
; H012+$00002294: d46dfff2  add.w -$e(a5), d2
        add.w -$e(a5), d2
L012_00002298:
; H012+$00002298: 3b42ffea  move.w d2, -$16(a5)
        move.w d2, -$16(a5)
L012_0000229C:
; H012+$0000229C: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L012_000022A0:
; H012+$000022A0: 6400ff72  bcc.w $2214
        bcc.w H012+$2214
L012_000022A4:
; H012+$000022A4: 548f  addq.l #$2, a7
        addq.l #$2, a7
; STATE: H005+$3364 = head of the party list
L012_000022A6:
; H012+$000022A6: 2b7900003364ffe2  move.l $3364.l, -$1e(a5)
        move.l (H005+$3364).l, -$1e(a5)
; STATE: H005+$24D0 = request to exit the scenario loop
L012_000022AE:
; H012+$000022AE: 13fc0001000024d0  move.b #$1, $24d0.l
        move.b #$1, (H005+$24D0).l
L012_000022B6:
; H012+$000022B6: 4aadffe2  tst.l -$1e(a5)
        tst.l -$1e(a5)
L012_000022BA:
; H012+$000022BA: 67000020  beq.w $22dc
        beq.w H012+$22DC
L012_000022BE:
; H012+$000022BE: 266dffe2  movea.l -$1e(a5), a3
        movea.l -$1e(a5), a3
L012_000022C2:
; H012+$000022C2: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L012_000022C6:
; H012+$000022C6: 67000008  beq.w $22d0
        beq.w H012+$22D0
; STATE: H005+$24D0 = request to exit the scenario loop
L012_000022CA:
; H012+$000022CA: 4239000024d0  clr.b $24d0.l
        clr.b (H005+$24D0).l
L012_000022D0:
; H012+$000022D0: 266dffe2  movea.l -$1e(a5), a3
        movea.l -$1e(a5), a3
L012_000022D4:
; H012+$000022D4: 2b6b018effe2  move.l $18e(a3), -$1e(a5)
        move.l $18e(a3), -$1e(a5)
L012_000022DA:
; H012+$000022DA: 60da  bra.b $22b6
        bra.b H012+$22B6
; STATE: H005+$24D0 = request to exit the scenario loop
L012_000022DC:
; H012+$000022DC: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_000022E2:
; H012+$000022E2: 67000052  beq.w $2336
        beq.w H012+$2336
L012_000022E6:
; H012+$000022E6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L012_000022EA:
; H012+$000022EA: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
L012_000022F0:
; H012+$000022F0: 33fc00020000334e  move.w #$2, $334e.l
        move.w #$2, (H005+$334E).l
L012_000022F8:
; H012+$000022F8: 33fc00020000334c  move.w #$2, $334c.l
        move.w #$2, (H005+$334C).l
L012_00002300:
; H012+$00002300: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00002304:
; H012+$00002304: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00002308:
; H012+$00002308: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_0000230C:
; H012+$0000230C: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_00002310:
; H012+$00002310: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00002314:
; H012+$00002314: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00002316:
; H012+$00002316: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_0000231A:
; H012+$0000231A: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L012_0000231E:
; H012+$0000231E: 486c00da  pea.l $da(a4)
        pea.l $da(a4)
; -> H030+$0302 (trampoline_H030_0470)
L012_00002322:
; H012+$00002322: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L012_00002328:
; H012+$00002328: 243c00000096  move.l #$96, d2
        move.l #$96, d2
L012_0000232E:
; H012+$0000232E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H036+$0034 (wrapper_Delay)
L012_00002330:
; H012+$00002330: 4eb900000034  jsr $34.l
        jsr (H036+$34).l
; STATE: H005+$3368 = current character
L012_00002336:
; H012+$00002336: 23edffde00003368  move.l -$22(a5), $3368.l
        move.l -$22(a5), (H005+$3368).l
L012_0000233E:
; H012+$0000233E: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L012_00002342:
; H012+$00002342: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00002344:
; H012+$00002344: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L012_00002348:
; H012+$00002348: 486c00f6  pea.l $f6(a4)
        pea.l $f6(a4)
; -> H030+$028A (sub_H030_0000028A)
L012_0000234C:
; H012+$0000234C: 4eb90000028a  jsr $28a.l
        jsr (H030+$28A).l
L012_00002352:
; H012+$00002352: 4e5d  unlk a5
        unlk a5
L012_00002354:
; H012+$00002354: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002356:
; H012+$00002356: 4e75  rts 
        rts 
; FUNCTION: ECL_49_SPRITE_OFF
FN_ECL_49_SPRITE_OFF:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_49 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 49=SPRITE OFF.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F1A
; --------------------------------------------------------------------------
L012_00002358:
; H012+$00002358: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_0000235A:
; H012+$0000235A: 287ade18  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_0000235E:
; H012+$0000235E: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATE: H005+$3DEA = logical ECL PC
L012_00002362:
; H012+$00002362: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L012_00002368:
; H012+$00002368: 4a39000024ba  tst.b $24ba.l
        tst.b (H005+$24BA).l
L012_0000236E:
; H012+$0000236E: 6700001c  beq.w $238c
        beq.w H012+$238C
L012_00002372:
; H012+$00002372: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
; -> H060+$0018 (sub_H060_00000018)
L012_0000237A:
; H012+$0000237A: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
L012_00002380:
; H012+$00002380: 4239000024ba  clr.b $24ba.l
        clr.b (H005+$24BA).l
L012_00002386:
; H012+$00002386: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
L012_0000238C:
; H012+$0000238C: 4e5d  unlk a5
        unlk a5
L012_0000238E:
; H012+$0000238E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002390:
; H012+$00002390: 4e75  rts 
        rts 
; FUNCTION: ECL_52_ECL_CLOCK
FN_ECL_52_ECL_CLOCK:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_52 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 52=ECL CLOCK.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F2C
; --------------------------------------------------------------------------
L012_00002392:
; H012+$00002392: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002394:
; H012+$00002394: 287addde  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002398:
; H012+$00002398: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L012_0000239C:
; H012+$0000239C: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000023A0:
; H012+$000023A0: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_000023A6:
; H012+$000023A6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000023AA:
; H012+$000023AA: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000023B0:
; H012+$000023B0: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_000023B4:
; H012+$000023B4: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000023B8:
; H012+$000023B8: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000023BE:
; H012+$000023BE: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L012_000023C2:
; H012+$000023C2: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L012_000023C6:
; H012+$000023C6: 1f2dfffd  move.b -$3(a5), -(a7)
        move.b -$3(a5), -(a7)
; -> H058+$064A (sub_H058_0000064A)
L012_000023CA:
; H012+$000023CA: 4eb90000064a  jsr $64a.l
        jsr (H058+$64A).l
L012_000023D0:
; H012+$000023D0: 4e5d  unlk a5
        unlk a5
L012_000023D2:
; H012+$000023D2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_000023D4:
; H012+$000023D4: 4e75  rts 
        rts 
; FUNCTION: ECL_51_PRINT_RETURN
FN_ECL_51_PRINT_RETURN:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_51 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 51=PRINT RETURN.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F26
; --------------------------------------------------------------------------
L012_000023D6:
; H012+$000023D6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_000023D8:
; H012+$000023D8: 287add9a  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_000023DC:
; H012+$000023DC: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATE: H005+$3DEA = logical ECL PC
L012_000023E0:
; H012+$000023E0: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L012_000023E6:
; H012+$000023E6: 4a39000024be  tst.b $24be.l
        tst.b (H005+$24BE).l
L012_000023EC:
; H012+$000023EC: 6700001a  beq.w $2408
        beq.w H012+$2408
L012_000023F0:
; H012+$000023F0: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L012_000023F8:
; H012+$000023F8: 52790000334c  addq.w #$1, $334c.l
        addq.w #$1, (H005+$334C).l
L012_000023FE:
; H012+$000023FE: 4239000024be  clr.b $24be.l
        clr.b (H005+$24BE).l
L012_00002404:
; H012+$00002404: 60000010  bra.w $2416
        bra.w H012+$2416
L012_00002408:
; H012+$00002408: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L012_00002410:
; H012+$00002410: 52790000334c  addq.w #$1, $334c.l
        addq.w #$1, (H005+$334C).l
L012_00002416:
; H012+$00002416: 4e5d  unlk a5
        unlk a5
L012_00002418:
; H012+$00002418: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_0000241A:
; H012+$0000241A: 4e75  rts 
        rts 
; FUNCTION: ECL_61_CLEAR_BOX
FN_ECL_61_CLEAR_BOX:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_61 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 61=CLEAR BOX.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F5E
; --------------------------------------------------------------------------
L012_0000241C:
; H012+$0000241C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_0000241E:
; H012+$0000241E: 287add54  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002422:
; H012+$00002422: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATE: H005+$3DEA = logical ECL PC
L012_00002426:
; H012+$00002426: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L012_0000242C:
; H012+$0000242C: 4239000024ae  clr.b $24ae.l
        clr.b (H005+$24AE).l
; -> H044+$0330 (sub_H044_00000330)
L012_00002432:
; H012+$00002432: 4eb900000330  jsr $330.l
        jsr (H044+$330).l
; STATE: H005+$3368 = current character
L012_00002438:
; H012+$00002438: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L012_0000243E:
; H012+$0000243E: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
; -> H063+$33A0 (trampoline_H063_3652)
L012_00002444:
; H012+$00002444: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
; STATE: H005+$24D7 = flag of the demo branch
L012_0000244A:
; H012+$0000244A: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L012_00002450:
; H012+$00002450: 6600001a  bne.w $246c
        bne.w H012+$246C
L012_00002454:
; H012+$00002454: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L012_00002458:
; H012+$00002458: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L012_0000245C:
; H012+$0000245C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00002460:
; H012+$00002460: 2f39000027c2  move.l $27c2.l, -(a7)
        move.l (H005+$27C2).l, -(a7)
; -> H042+$0254 (sub_H042_00000254)
L012_00002466:
; H012+$00002466: 4eb900000254  jsr $254.l
        jsr (H042+$254).l
; -> H063+$33A0 (trampoline_H063_3652)
L012_0000246C:
; H012+$0000246C: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L012_00002472:
; H012+$00002472: 4239000024b2  clr.b $24b2.l
        clr.b (H005+$24B2).l
L012_00002478:
; H012+$00002478: 13fc0001000024bf  move.b #$1, $24bf.l
        move.b #$1, (H005+$24BF).l
L012_00002480:
; H012+$00002480: 4e5d  unlk a5
        unlk a5
L012_00002482:
; H012+$00002482: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002484:
; H012+$00002484: 4e75  rts 
        rts 
; FUNCTION: ECL_57_WHO
FN_ECL_57_WHO:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_57 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 57=WHO.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F46
; --------------------------------------------------------------------------
L012_00002486:
; H012+$00002486: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002488:
; H012+$00002488: 287adcea  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_0000248C:
; H012+$0000248C: 4e55ffac  link.w a5, #$ffac
        link.w a5, #$ffac
L012_00002490:
; H012+$00002490: 1b79000024b0ffad  move.b $24b0.l, -$53(a5)
        move.b (H005+$24B0).l, -$53(a5)
L012_00002498:
; H012+$00002498: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L012_0000249E:
; H012+$0000249E: 4239000024b3  clr.b $24b3.l
        clr.b (H005+$24B3).l
L012_000024A4:
; H012+$000024A4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000024A8:
; H012+$000024A8: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_000024AE:
; H012+$000024AE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_000024B2:
; H012+$000024B2: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_000024B6:
; H012+$000024B6: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_000024BA:
; H012+$000024BA: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L012_000024BE:
; H012+$000024BE: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L012_000024C4:
; H012+$000024C4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_000024C8:
; H012+$000024C8: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L012_000024CC:
; H012+$000024CC: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L012_000024D0:
; H012+$000024D0: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
; -> H026+$0188 (sub_H026_00000188)
L012_000024D6:
; H012+$000024D6: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L012_000024DC:
; H012+$000024DC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_000024E0:
; H012+$000024E0: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L012_000024E4:
; H012+$000024E4: 4227  clr.b -(a7)
        clr.b -(a7)
L012_000024E6:
; H012+$000024E6: 4227  clr.b -(a7)
        clr.b -(a7)
; STATE: H005+$3368 = current character
L012_000024E8:
; H012+$000024E8: 487900003368  pea.l $3368.l
        pea.l (H005+$3368).l
; -> H063+$3A26 (sub_H063_00003A26)
L012_000024EE:
; H012+$000024EE: 4eb900003a26  jsr $3a26.l
        jsr (H063+$3A26).l
L012_000024F4:
; H012+$000024F4: 13edffad000024b0  move.b -$53(a5), $24b0.l
        move.b -$53(a5), (H005+$24B0).l
L012_000024FC:
; H012+$000024FC: 4e5d  unlk a5
        unlk a5
L012_000024FE:
; H012+$000024FE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002500:
; H012+$00002500: 4e75  rts 
        rts 
; FUNCTION: ECL_54_ADD_NPC
FN_ECL_54_ADD_NPC:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_54 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 54=ADD NPC.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F3A
; --------------------------------------------------------------------------
L012_00002502:
; H012+$00002502: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002504:
; H012+$00002504: 287adc6e  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002508:
; H012+$00002508: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L012_0000250C:
; H012+$0000250C: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00002510:
; H012+$00002510: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00002516:
; H012+$00002516: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_0000251A:
; H012+$0000251A: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00002520:
; H012+$00002520: 3b40fff6  move.w d0, -$a(a5)
        move.w d0, -$a(a5)
L012_00002524:
; H012+$00002524: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
; -> H066+$276E (trampoline_H066_27E4)
L012_00002528:
; H012+$00002528: 4eb90000276e  jsr $276e.l
        jsr (H066+$276E).l
L012_0000252E:
; H012+$0000252E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00002532:
; H012+$00002532: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00002538:
; H012+$00002538: 3b40fff4  move.w d0, -$c(a5)
        move.w d0, -$c(a5)
L012_0000253C:
; H012+$0000253C: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000253E:
; H012+$0000253E: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L012_00002542:
; H012+$00002542: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L012_00002544:
; H012+$00002544: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L012_00002548:
; H012+$00002548: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L012_0000254C:
; H012+$0000254C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_0000254E:
; H012+$0000254E: 3f3c0080  move.w #$80, -(a7)
        move.w #$80, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L012_00002552:
; H012+$00002552: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L012_00002558:
; H012+$00002558: 1400  move.b d0, d2
        move.b d0, d2
L012_0000255A:
; H012+$0000255A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L012_0000255E:
; H012+$0000255E: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L012_00002562:
; H012+$00002562: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
; STATE: H005+$3368 = current character
L012_00002566:
; H012+$00002566: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L012_0000256C:
; H012+$0000256C: 174200ec  move.b d2, $ec(a3)
        move.b d2, $ec(a3)
; STATE: H005+$3368 = current character
L012_00002570:
; H012+$00002570: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L012_00002576:
; H012+$00002576: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
; STATE: H005+$3368 = current character
L012_0000257C:
; H012+$0000257C: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L012_00002582:
; H012+$00002582: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
; STATE: H005+$3364 = head of the party list
L012_00002588:
; H012+$00002588: 2b7900003364fff8  move.l $3364.l, -$8(a5)
        move.l (H005+$3364).l, -$8(a5)
L012_00002590:
; H012+$00002590: 4e5d  unlk a5
        unlk a5
L012_00002592:
; H012+$00002592: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002594:
; H012+$00002594: 4e75  rts 
        rts 
; FUNCTION: ECL_59_SPELL
FN_ECL_59_SPELL:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_59 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 59=SPELL.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F52
; --------------------------------------------------------------------------
L012_00002596:
; H012+$00002596: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002598:
; H012+$00002598: 287adbda  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_0000259C:
; H012+$0000259C: 4e55fff0  link.w a5, #$fff0
        link.w a5, #$fff0
L012_000025A0:
; H012+$000025A0: 422dfff4  clr.b -$c(a5)
        clr.b -$c(a5)
L012_000025A4:
; H012+$000025A4: 422dfff5  clr.b -$b(a5)
        clr.b -$b(a5)
L012_000025A8:
; H012+$000025A8: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000025AC:
; H012+$000025AC: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_000025B2:
; H012+$000025B2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000025B6:
; H012+$000025B6: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000025BC:
; H012+$000025BC: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_000025C0:
; H012+$000025C0: 1f3900001453  move.b $1453.l, -(a7)
        move.b (H061+$1453).l, -(a7)
L012_000025C6:
; H012+$000025C6: 1f3900001493  move.b $1493.l, -(a7)
        move.b (H061+$1493).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_000025CC:
; H012+$000025CC: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_000025D2:
; H012+$000025D2: 3b40fff2  move.w d0, -$e(a5)
        move.w d0, -$e(a5)
L012_000025D6:
; H012+$000025D6: 1f3900001454  move.b $1454.l, -(a7)
        move.b (H061+$1454).l, -(a7)
L012_000025DC:
; H012+$000025DC: 1f3900001494  move.b $1494.l, -(a7)
        move.b (H061+$1494).l, -(a7)
; FLOW: Calls ECL_DecodeAddress (H061+$1F3C).
L012_000025E2:
; H012+$000025E2: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L012_000025E8:
; H012+$000025E8: 3b40fff0  move.w d0, -$10(a5)
        move.w d0, -$10(a5)
L012_000025EC:
; H012+$000025EC: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L012_000025F2:
; H012+$000025F2: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
; STATE: H005+$3364 = head of the party list
L012_000025F6:
; H012+$000025F6: 2b7900003364fff6  move.l $3364.l, -$a(a5)
        move.l (H005+$3364).l, -$a(a5)
L012_000025FE:
; H012+$000025FE: 4aadfff6  tst.l -$a(a5)
        tst.l -$a(a5)
L012_00002602:
; H012+$00002602: 67000080  beq.w $2684
        beq.w H012+$2684
L012_00002606:
; H012+$00002606: 4a2dfff5  tst.b -$b(a5)
        tst.b -$b(a5)
L012_0000260A:
; H012+$0000260A: 66000078  bne.w $2684
        bne.w H012+$2684
L012_0000260E:
; H012+$0000260E: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L012_00002614:
; H012+$00002614: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L012_00002618:
; H012+$00002618: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L012_0000261C:
; H012+$0000261C: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L012_00002620:
; H012+$00002620: 7800  moveq #$0, d4
        moveq #0, d4
L012_00002622:
; H012+$00002622: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L012_00002626:
; H012+$00002626: b86dfffe  cmp.w -$2(a5), d4
        cmp.w -$2(a5), d4
L012_0000262A:
; H012+$0000262A: 6600000c  bne.w $2638
        bne.w H012+$2638
L012_0000262E:
; H012+$0000262E: 1b7c0001fff5  move.b #$1, -$b(a5)
        move.b #$1, -$b(a5)
L012_00002634:
; H012+$00002634: 6000001a  bra.w $2650
        bra.w H012+$2650
L012_00002638:
; H012+$00002638: 0c6d0039fffc  cmpi.w #$39, -$4(a5)
        cmpi.w #$39, -$4(a5)
L012_0000263E:
; H012+$0000263E: 6200000a  bhi.w $264a
        bhi.w H012+$264A
L012_00002642:
; H012+$00002642: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L012_00002646:
; H012+$00002646: 60000008  bra.w $2650
        bra.w H012+$2650
L012_0000264A:
; H012+$0000264A: 1b7c0001fff4  move.b #$1, -$c(a5)
        move.b #$1, -$c(a5)
L012_00002650:
; H012+$00002650: 4a2dfff4  tst.b -$c(a5)
        tst.b -$c(a5)
L012_00002654:
; H012+$00002654: 66000008  bne.w $265e
        bne.w H012+$265E
L012_00002658:
; H012+$00002658: 4a2dfff5  tst.b -$b(a5)
        tst.b -$b(a5)
L012_0000265C:
; H012+$0000265C: 67b6  beq.b $2614
        beq.b H012+$2614
L012_0000265E:
; H012+$0000265E: 422dfff4  clr.b -$c(a5)
        clr.b -$c(a5)
L012_00002662:
; H012+$00002662: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L012_00002666:
; H012+$00002666: 2b6b018efff6  move.l $18e(a3), -$a(a5)
        move.l $18e(a3), -$a(a5)
L012_0000266C:
; H012+$0000266C: 4aadfff6  tst.l -$a(a5)
        tst.l -$a(a5)
L012_00002670:
; H012+$00002670: 6700000e  beq.w $2680
        beq.w H012+$2680
L012_00002674:
; H012+$00002674: 4a2dfff5  tst.b -$b(a5)
        tst.b -$b(a5)
L012_00002678:
; H012+$00002678: 66000006  bne.w $2680
        bne.w H012+$2680
L012_0000267C:
; H012+$0000267C: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L012_00002680:
; H012+$00002680: 6000ff7c  bra.w $25fe
        bra.w H012+$25FE
L012_00002684:
; H012+$00002684: 0c6d0039fffc  cmpi.w #$39, -$4(a5)
        cmpi.w #$39, -$4(a5)
L012_0000268A:
; H012+$0000268A: 63000008  bls.w $2694
        bls.w H012+$2694
L012_0000268E:
; H012+$0000268E: 3b7c00fffffc  move.w #$ff, -$4(a5)
        move.w #$ff, -$4(a5)
L012_00002694:
; H012+$00002694: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L012_00002698:
; H012+$00002698: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_0000269C:
; H012+$0000269C: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_000026A2:
; H012+$000026A2: 3f2dfff0  move.w -$10(a5), -(a7)
        move.w -$10(a5), -(a7)
L012_000026A6:
; H012+$000026A6: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L012_000026AA:
; H012+$000026AA: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L012_000026B0:
; H012+$000026B0: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L012_000026B4:
; H012+$000026B4: 486c0119  pea.l $119(a4)
        pea.l $119(a4)
L012_000026B8:
; H012+$000026B8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L012_000026BC:
; H012+$000026BC: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_000026BE:
; H012+$000026BE: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L012_000026C2:
; H012+$000026C2: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_000026C4:
; H012+$000026C4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_000026C8:
; H012+$000026C8: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
; -> H056+$0886 (sub_H056_00000886)
L012_000026CA:
; H012+$000026CA: 4eb900000886  jsr $886.l
        jsr (H056+$886).l
L012_000026D0:
; H012+$000026D0: 4e5d  unlk a5
        unlk a5
L012_000026D2:
; H012+$000026D2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_000026D4:
; H012+$000026D4: 4e75  rts 
        rts 
; FUNCTION: ECL_45_CALL
FN_ECL_45_CALL:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_45 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 45=CALL.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F06
; --------------------------------------------------------------------------
L012_000026D6:
; H012+$000026D6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_000026D8:
; H012+$000026D8: 287ada9a  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_000026DC:
; H012+$000026DC: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L012_000026E0:
; H012+$000026E0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000026E4:
; H012+$000026E4: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_000026EA:
; H012+$000026EA: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L012_000026F0:
; H012+$000026F0: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; -> H061+$1F12 (sub_H061_00001F12)
L012_000026F6:
; H012+$000026F6: 4eb900001f12  jsr $1f12.l
        jsr (H061+$1F12).l
L012_000026FC:
; H012+$000026FC: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_00002700:
; H012+$00002700: 0c6d2e10fffe  cmpi.w #$2e10, -$2(a5)
        cmpi.w #$2e10, -$2(a5)
L012_00002706:
; H012+$00002706: 6600000a  bne.w $2712
        bne.w H012+$2712
L012_0000270A:
; H012+$0000270A: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L012_0000270E:
; H012+$0000270E: 6000004e  bra.w $275e
        bra.w H012+$275E
L012_00002712:
; H012+$00002712: 0c6d6803fffe  cmpi.w #$6803, -$2(a5)
        cmpi.w #$6803, -$2(a5)
L012_00002718:
; H012+$00002718: 6600000c  bne.w $2726
        bne.w H012+$2726
L012_0000271C:
; H012+$0000271C: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L012_00002722:
; H012+$00002722: 6000003a  bra.w $275e
        bra.w H012+$275E
L012_00002726:
; H012+$00002726: 0c6db203fffe  cmpi.w #$b203, -$2(a5)
        cmpi.w #$b203, -$2(a5)
L012_0000272C:
; H012+$0000272C: 6600000c  bne.w $273a
        bne.w H012+$273A
L012_00002730:
; H012+$00002730: 3b7c0002fffe  move.w #$2, -$2(a5)
        move.w #$2, -$2(a5)
L012_00002736:
; H012+$00002736: 60000026  bra.w $275e
        bra.w H012+$275E
L012_0000273A:
; H012+$0000273A: 0c6dc018fffe  cmpi.w #$c018, -$2(a5)
        cmpi.w #$c018, -$2(a5)
L012_00002740:
; H012+$00002740: 6600000c  bne.w $274e
        bne.w H012+$274E
L012_00002744:
; H012+$00002744: 3b7c0003fffe  move.w #$3, -$2(a5)
        move.w #$3, -$2(a5)
L012_0000274A:
; H012+$0000274A: 60000012  bra.w $275e
        bra.w H012+$275E
L012_0000274E:
; H012+$0000274E: 0c6dc01efffe  cmpi.w #$c01e, -$2(a5)
        cmpi.w #$c01e, -$2(a5)
L012_00002754:
; H012+$00002754: 66000008  bne.w $275e
        bne.w H012+$275E
L012_00002758:
; H012+$00002758: 3b7c0004fffe  move.w #$4, -$2(a5)
        move.w #$4, -$2(a5)
L012_0000275E:
; H012+$0000275E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00002762:
; H012+$00002762: 600001a2  bra.w $2906
        bra.w H012+$2906
; STATE: H005+$281C = start of the coordinates/view block
L012_00002766:
; H012+$00002766: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L012_0000276C:
; H012+$0000276C: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
; -> H011+$04E2 (sub_H011_000004E2)
L012_00002772:
; H012+$00002772: 4eb9000004e2  jsr $4e2.l
        jsr (H011+$4E2).l
L012_00002778:
; H012+$00002778: 13c000002822  move.b d0, $2822.l
        move.b d0, (H005+$2822).l
L012_0000277E:
; H012+$0000277E: 4a39000024bd  tst.b $24bd.l
        tst.b (H005+$24BD).l
L012_00002784:
; H012+$00002784: 6600002a  bne.w $27b0
        bne.w H012+$27B0
L012_00002788:
; H012+$00002788: 4a39000024ba  tst.b $24ba.l
        tst.b (H005+$24BA).l
L012_0000278E:
; H012+$0000278E: 66000020  bne.w $27b0
        bne.w H012+$27B0
L012_00002792:
; H012+$00002792: 4a39000024b8  tst.b $24b8.l
        tst.b (H005+$24B8).l
L012_00002798:
; H012+$00002798: 66000016  bne.w $27b0
        bne.w H012+$27B0
L012_0000279C:
; H012+$0000279C: 4a39000024b7  tst.b $24b7.l
        tst.b (H005+$24B7).l
L012_000027A2:
; H012+$000027A2: 6600000c  bne.w $27b0
        bne.w H012+$27B0
L012_000027A6:
; H012+$000027A6: 4a39000024b5  tst.b $24b5.l
        tst.b (H005+$24B5).l
L012_000027AC:
; H012+$000027AC: 6700006c  beq.w $281a
        beq.w H012+$281A
L012_000027B0:
; H012+$000027B0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_000027B4:
; H012+$000027B4: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
L012_000027BA:
; H012+$000027BA: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L012_000027BE:
; H012+$000027BE: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L012_000027C0:
; H012+$000027C0: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L012_000027C6:
; H012+$000027C6: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
; -> H060+$0018 (sub_H060_00000018)
L012_000027CE:
; H012+$000027CE: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
; -> H063+$33A0 (trampoline_H063_3652)
L012_000027D4:
; H012+$000027D4: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L012_000027DA:
; H012+$000027DA: 4239000024b5  clr.b $24b5.l
        clr.b (H005+$24B5).l
L012_000027E0:
; H012+$000027E0: 4239000024b8  clr.b $24b8.l
        clr.b (H005+$24B8).l
L012_000027E6:
; H012+$000027E6: 4239000024b7  clr.b $24b7.l
        clr.b (H005+$24B7).l
L012_000027EC:
; H012+$000027EC: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
L012_000027F2:
; H012+$000027F2: 4239000024ba  clr.b $24ba.l
        clr.b (H005+$24BA).l
; STATE: H005+$281C = start of the coordinates/view block
L012_000027F8:
; H012+$000027F8: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L012_000027FE:
; H012+$000027FE: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
L012_00002804:
; H012+$00002804: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002806:
; H012+$00002806: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L012_0000280C:
; H012+$0000280C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; FLOW: Calls Map_QueryWall (H011+$01AA).
L012_0000280E:
; H012+$0000280E: 4eb9000001aa  jsr $1aa.l
        jsr (H011+$1AA).l
L012_00002814:
; H012+$00002814: 13c000002821  move.b d0, $2821.l
        move.b d0, (H005+$2821).l
L012_0000281A:
; H012+$0000281A: 4e75  rts 
        rts 
L012_0000281C:
; H012+$0000281C: 47f9000027bc  lea.l $27bc.l, a3
        lea.l (H005+$27BC).l, a3
L012_00002822:
; H012+$00002822: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00002824:
; H012+$00002824: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L012_00002828:
; H012+$00002828: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L012_0000282C:
; H012+$0000282C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00002830:
; H012+$00002830: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L012_00002832:
; H012+$00002832: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L012_00002836:
; H012+$00002836: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; -> H042+$0B80 (sub_H042_00000B80)
L012_0000283C:
; H012+$0000283C: 4eb900000b80  jsr $b80.l
        jsr (H042+$B80).l
L012_00002842:
; H012+$00002842: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_00002844:
; H012+$00002844: 2f00  move.l d0, -(a7)
        move.l d0, -(a7)
; -> H042+$0254 (sub_H042_00000254)
L012_00002846:
; H012+$00002846: 4eb900000254  jsr $254.l
        jsr (H042+$254).l
L012_0000284C:
; H012+$0000284C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_0000284E:
; H012+$0000284E: 526b0002  addq.w #$1, $2(a3)
        addq.w #$1, $2(a3)
L012_00002852:
; H012+$00002852: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L012_00002856:
; H012+$00002856: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L012_00002858:
; H012+$00002858: 63000008  bls.w $2862
        bls.w H012+$2862
L012_0000285C:
; H012+$0000285C: 377c00010002  move.w #$1, $2(a3)
        move.w #$1, $2(a3)
L012_00002862:
; H012+$00002862: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H030+$0B4A (sub_H030_00000B4A)
L012_00002864:
; H012+$00002864: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L012_0000286A:
; H012+$0000286A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L012_0000286C:
; H012+$0000286C: 4e75  rts 
        rts 
L012_0000286E:
; H012+$0000286E: 343900002376  move.w $2376.l, d2
        move.w (H005+$2376).l, d2
L012_00002874:
; H012+$00002874: 6000002e  bra.w $28a4
        bra.w H012+$28A4
L012_00002878:
; H012+$00002878: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_0000287C:
; H012+$0000287C: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_00002882:
; H012+$00002882: 4e75  rts 
        rts 
L012_00002884:
; H012+$00002884: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00002888:
; H012+$00002888: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_0000288E:
; H012+$0000288E: 4e75  rts 
        rts 
L012_00002890:
; H012+$00002890: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00002894:
; H012+$00002894: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_0000289A:
; H012+$0000289A: 4e75  rts 
        rts 
; Preserved bytes H012+$0000289C..$000028A4; code/data not fully classified.
        dc.w $FFF2,$FFDA,$FFF2,$FFE6
L012_000028A4:
; H012+$000028A4: 47fafff8  lea.l $289e(pc), a3
        lea.l H012+$289E(pc), a3
L012_000028A8:
; H012+$000028A8: 5142  subq.w #$8, d2
        subq.w #$8, d2
L012_000028AA:
; H012+$000028AA: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L012_000028AE:
; H012+$000028AE: 6302  bls.b $28b2
        bls.b H012+$28B2
L012_000028B0:
; H012+$000028B0: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_000028B2:
; H012+$000028B2: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_000028B4:
; H012+$000028B4: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$289E; indices 0..2, default -1.
L012_000028B8:
; H012+$000028B8: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_000028BC:
; H012+$000028BC: 4e75  rts 
        rts 
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_000028BE:
; H012+$000028BE: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_000028C4:
; H012+$000028C4: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_000028C8:
; H012+$000028C8: 66000024  bne.w $28ee
        bne.w H012+$28EE
; STATE: H005+$281C = start of the coordinates/view block
L012_000028CC:
; H012+$000028CC: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L012_000028D2:
; H012+$000028D2: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
L012_000028D8:
; H012+$000028D8: 7400  moveq #$0, d2
        moveq #0, d2
L012_000028DA:
; H012+$000028DA: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L012_000028E0:
; H012+$000028E0: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; FLOW: Calls Map_QueryWall (H011+$01AA).
L012_000028E2:
; H012+$000028E2: 4eb9000001aa  jsr $1aa.l
        jsr (H011+$1AA).l
L012_000028E8:
; H012+$000028E8: 13c000002821  move.b d0, $2821.l
        move.b d0, (H005+$2821).l
L012_000028EE:
; H012+$000028EE: 4e75  rts 
        rts 
; -> H061+$3B4E (trampoline_H061_3BEE)
L012_000028F0:
; H012+$000028F0: 4eb900003b4e  jsr $3b4e.l
        jsr (H061+$3B4E).l
L012_000028F6:
; H012+$000028F6: 4e75  rts 
        rts 
L012_000028F8:
; H012+$000028F8: 4e75  rts 
        rts 
; Preserved bytes H012+$000028FA..$00002906; code/data not fully classified.
        dc.w $FFFC,$FE6A,$FF20,$FF72,$FFC2,$FFF4
L012_00002906:
; H012+$00002906: 47fafff4  lea.l $28fc(pc), a3
        lea.l H012+$28FC(pc), a3
L012_0000290A:
; H012+$0000290A: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L012_0000290E:
; H012+$0000290E: 6302  bls.b $2912
        bls.b H012+$2912
L012_00002910:
; H012+$00002910: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00002912:
; H012+$00002912: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00002914:
; H012+$00002914: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$28FC; indices 0..4, default -1.
L012_00002918:
; H012+$00002918: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_0000291C:
; H012+$0000291C: 4e5d  unlk a5
        unlk a5
L012_0000291E:
; H012+$0000291E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002920:
; H012+$00002920: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H012_00002922 [partial]
; Purpose: Routine of the ECL dispatcher, encounters and native scenario loop module; calls H057+$2F3A, H063+$321A, H060+$0018, H069+$0012.
;   - Calls H057+$2F3A.
;   - Calls H063+$321A.
;   - Calls H060+$0018.
;   - Calls H069+$0012.
;   - Uses the global state: H005+$3E04 (pointer to persistent state A, 2048 bytes).
; Direct callers: H012+$3380, H012+$2A50
; --------------------------------------------------------------------------
L012_00002922:
; H012+$00002922: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002924:
; H012+$00002924: 287ad84e  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002928:
; H012+$00002928: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L012_0000292C:
; H012+$0000292C: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L012_00002930:
; H012+$00002930: 3f3900003df0  move.w $3df0.l, -(a7)
        move.w (H005+$3DF0).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_00002936:
; H012+$00002936: 6100d852  bsr.w $18a
        bsr.w H012+$18A
L012_0000293A:
; H012+$0000293A: 486dffff  pea.l -$1(a5)
        pea.l -$1(a5)
; -> H057+$2F3A (sub_H057_00002F3A)
L012_0000293E:
; H012+$0000293E: 4eb900002f3a  jsr $2f3a.l
        jsr (H057+$2F3A).l
L012_00002944:
; H012+$00002944: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L012_00002948:
; H012+$00002948: 67000012  beq.w $295c
        beq.w H012+$295C
; -> H063+$321A (trampoline_H063_3384)
L012_0000294C:
; H012+$0000294C: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L012_00002952:
; H012+$00002952: 3f3900003dee  move.w $3dee.l, -(a7)
        move.w (H005+$3DEE).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_00002958:
; H012+$00002958: 6100d830  bsr.w $18a
        bsr.w H012+$18A
L012_0000295C:
; H012+$0000295C: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00002964:
; H012+$00002964: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_0000296A:
; H012+$0000296A: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L012_0000296E:
; H012+$0000296E: 66000008  bne.w $2978
        bne.w H012+$2978
; -> H060+$0018 (sub_H060_00000018)
L012_00002972:
; H012+$00002972: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
L012_00002978:
; H012+$00002978: 4239000024a3  clr.b $24a3.l
        clr.b (H005+$24A3).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_0000297E:
; H012+$0000297E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00002984:
; H012+$00002984: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_00002988:
; H012+$00002988: 66000016  bne.w $29a0
        bne.w H012+$29A0
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_0000298C:
; H012+$0000298C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00002992:
; H012+$00002992: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L012_00002996:
; H012+$00002996: 66000008  bne.w $29a0
        bne.w H012+$29A0
; -> H069+$0012 (sub_H069_00000012)
L012_0000299A:
; H012+$0000299A: 4eb900000012  jsr $12.l
        jsr (H069+$12).l
L012_000029A0:
; H012+$000029A0: 4e5d  unlk a5
        unlk a5
L012_000029A2:
; H012+$000029A2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_000029A4:
; H012+$000029A4: 4e75  rts 
        rts 
; FUNCTION: ECL_56_PROGRAM
FN_ECL_56_PROGRAM:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_56 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 56=PROGRAM.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F40
; --------------------------------------------------------------------------
L012_000029A6:
; H012+$000029A6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_000029A8:
; H012+$000029A8: 287ad7ca  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_000029AC:
; H012+$000029AC: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L012_000029B0:
; H012+$000029B0: 1b79000024b0fff6  move.b $24b0.l, -$a(a5)
        move.b (H005+$24B0).l, -$a(a5)
L012_000029B8:
; H012+$000029B8: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L012_000029BE:
; H012+$000029BE: 4a3900000009  tst.b $9.l
        tst.b (H064+$9).l
L012_000029C4:
; H012+$000029C4: 67000012  beq.w $29d8
        beq.w H012+$29D8
; STATE: H005+$3368 = current character
L012_000029C8:
; H012+$000029C8: 23f90000000000003368  move.l $0.l, $3368.l
        move.l (H064+$0).l, (H005+$3368).l
L012_000029D2:
; H012+$000029D2: 423900000009  clr.b $9.l
        clr.b (H064+$9).l
; STATE: H005+$3DEA = logical ECL PC
L012_000029D8:
; H012+$000029D8: 3b7900003deafffc  move.w $3dea.l, -$4(a5)
        move.w (H005+$3DEA).l, -$4(a5)
L012_000029E0:
; H012+$000029E0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_000029E4:
; H012+$000029E4: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_000029EA:
; H012+$000029EA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_000029EE:
; H012+$000029EE: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_000029F4:
; H012+$000029F4: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_000029F8:
; H012+$000029F8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_000029FC:
; H012+$000029FC: 6000008c  bra.w $2a8a
        bra.w H012+$2A8A
L012_00002A00:
; H012+$00002A00: 42390000249c  clr.b $249c.l
        clr.b (H005+$249C).l
; FLOW: Calls Party_MainMenu (H013+$4BFC).
L012_00002A06:
; H012+$00002A06: 4eb900004bfc  jsr $4bfc.l
        jsr (H013+$4BFC).l
L012_00002A0C:
; H012+$00002A0C: 13fc00010000249c  move.b #$1, $249c.l
        move.b #$1, (H005+$249C).l
L012_00002A14:
; H012+$00002A14: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002A16:
; H012+$00002A16: 143900002486  move.b $2486.l, d2
        move.b (H005+$2486).l, d2
L012_00002A1C:
; H012+$00002A1C: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L012_00002A20:
; H012+$00002A20: 67000024  beq.w $2a46
        beq.w H012+$2A46
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00002A24:
; H012+$00002A24: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00002A2A:
; H012+$00002A2A: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L012_00002A2E:
; H012+$00002A2E: 66000016  bne.w $2a46
        bne.w H012+$2A46
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00002A32:
; H012+$00002A32: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00002A38:
; H012+$00002A38: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_00002A3C:
; H012+$00002A3C: 66000008  bne.w $2a46
        bne.w H012+$2A46
; -> H063+$321A (trampoline_H063_3384)
L012_00002A40:
; H012+$00002A40: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L012_00002A46:
; H012+$00002A46: 4e75  rts 
        rts 
; STATE: H005+$3DEA = logical ECL PC
L012_00002A48:
; H012+$00002A48: 3b7900003deafffc  move.w $3dea.l, -$4(a5)
        move.w (H005+$3DEA).l, -$4(a5)
L012_00002A50:
; H012+$00002A50: 6100fed0  bsr.w $2922
        bsr.w H012+$2922
; STATE: H005+$3DEA = logical ECL PC
L012_00002A54:
; H012+$00002A54: 33edfffc00003dea  move.w -$4(a5), $3dea.l
        move.w -$4(a5), (H005+$3DEA).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00002A5C:
; H012+$00002A5C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00002A62:
; H012+$00002A62: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L012_00002A66:
; H012+$00002A66: 66000008  bne.w $2a70
        bne.w H012+$2A70
; FLOW: Calls ECL_Handler_0 (H064+$0156).
L012_00002A6A:
; H012+$00002A6A: 4eb900000156  jsr $156.l
        jsr (FN_ECL_0_EXIT).l
L012_00002A70:
; H012+$00002A70: 4e75  rts 
        rts 
L012_00002A72:
; H012+$00002A72: 4e75  rts 
        rts 
; Preserved bytes H012+$00002A74..$00002A8A; code/data not fully classified.
        dc.w $FFFC,$FF8A,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFD2
L012_00002A8A:
; H012+$00002A8A: 47faffea  lea.l $2a76(pc), a3
        lea.l H012+$2A76(pc), a3
L012_00002A8E:
; H012+$00002A8E: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L012_00002A92:
; H012+$00002A92: 6302  bls.b $2a96
        bls.b H012+$2A96
L012_00002A94:
; H012+$00002A94: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00002A96:
; H012+$00002A96: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00002A98:
; H012+$00002A98: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$2A76; indices 0..9, default -1.
L012_00002A9C:
; H012+$00002A9C: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_00002AA0:
; H012+$00002AA0: 13edfff6000024b0  move.b -$a(a5), $24b0.l
        move.b -$a(a5), (H005+$24B0).l
L012_00002AA8:
; H012+$00002AA8: 4e5d  unlk a5
        unlk a5
L012_00002AAA:
; H012+$00002AAA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002AAC:
; H012+$00002AAC: 4e75  rts 
        rts 
; FUNCTION: ECL_60_PROTECTION
FN_ECL_60_PROTECTION:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_60 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 60=PROTECTION.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F58
; --------------------------------------------------------------------------
L012_00002AAE:
; H012+$00002AAE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002AB0:
; H012+$00002AB0: 287ad6c2  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002AB4:
; H012+$00002AB4: 4e550000  link.w a5, #$0
        link.w a5, #$0
L012_00002AB8:
; H012+$00002AB8: 4e5d  unlk a5
        unlk a5
L012_00002ABA:
; H012+$00002ABA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002ABC:
; H012+$00002ABC: 4e75  rts 
        rts 
; FUNCTION: ECL_62_DUMP
FN_ECL_62_DUMP:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_62 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 62=DUMP.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F64
; --------------------------------------------------------------------------
L012_00002ABE:
; H012+$00002ABE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002AC0:
; H012+$00002AC0: 287ad6b2  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002AC4:
; H012+$00002AC4: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
; STATE: H005+$3DEA = logical ECL PC
L012_00002AC8:
; H012+$00002AC8: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L012_00002ACE:
; H012+$00002ACE: 4227  clr.b -(a7)
        clr.b -(a7)
L012_00002AD0:
; H012+$00002AD0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H053+$00CA (trampoline_H053_01E8)
L012_00002AD4:
; H012+$00002AD4: 4eb9000000ca  jsr $ca.l
        jsr (H053+$CA).l
; STATE: H005+$3368 = current character
L012_00002ADA:
; H012+$00002ADA: 23f90000336800000000  move.l $3368.l, $0.l
        move.l (H005+$3368).l, (H064+$0).l
; STATE: H005+$3368 = current character
L012_00002AE4:
; H012+$00002AE4: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L012_00002AEA:
; H012+$00002AEA: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L012_00002AF0:
; H012+$00002AF0: 4e5d  unlk a5
        unlk a5
L012_00002AF2:
; H012+$00002AF2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002AF4:
; H012+$00002AF4: 4e75  rts 
        rts 
; FUNCTION: ECL_63_FIND_SPECIAL
FN_ECL_63_FIND_SPECIAL:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_63 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 63=FIND SPECIAL.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F6A
; --------------------------------------------------------------------------
L012_00002AF6:
; H012+$00002AF6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002AF8:
; H012+$00002AF8: 287ad67a  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002AFC:
; H012+$00002AFC: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L012_00002B00:
; H012+$00002B00: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L012_00002B04:
; H012+$00002B04: 48790000237e  pea.l $237e.l
        pea.l (H005+$237E).l
L012_00002B0A:
; H012+$00002B0A: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L012_00002B0E:
; H012+$00002B0E: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L012_00002B10:
; H012+$00002B10: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L012_00002B16:
; H012+$00002B16: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00002B1A:
; H012+$00002B1A: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00002B20:
; H012+$00002B20: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00002B24:
; H012+$00002B24: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00002B2A:
; H012+$00002B2A: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
; STATE: H005+$3368 = current character
L012_00002B2E:
; H012+$00002B2E: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L012_00002B34:
; H012+$00002B34: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L012_00002B38:
; H012+$00002B38: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L012_00002B3C:
; H012+$00002B3C: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L012_00002B42:
; H012+$00002B42: 1400  move.b d0, d2
        move.b d0, d2
L012_00002B44:
; H012+$00002B44: 4a02  tst.b d2
        tst.b d2
L012_00002B46:
; H012+$00002B46: 6700000e  beq.w $2b56
        beq.w H012+$2B56
L012_00002B4A:
; H012+$00002B4A: 13fc00010000237e  move.b #$1, $237e.l
        move.b #$1, (H005+$237E).l
L012_00002B52:
; H012+$00002B52: 6000000a  bra.w $2b5e
        bra.w H012+$2B5E
L012_00002B56:
; H012+$00002B56: 13fc00010000237f  move.b #$1, $237f.l
        move.b #$1, (H005+$237F).l
L012_00002B5E:
; H012+$00002B5E: 4e5d  unlk a5
        unlk a5
L012_00002B60:
; H012+$00002B60: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002B62:
; H012+$00002B62: 4e75  rts 
        rts 
; FUNCTION: ECL_64_DESTROY_ITEMS
FN_ECL_64_DESTROY_ITEMS:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_64 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 64=DESTROY ITEMS.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F70
; --------------------------------------------------------------------------
L012_00002B64:
; H012+$00002B64: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002B66:
; H012+$00002B66: 287ad60c  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002B6A:
; H012+$00002B6A: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L012_00002B6E:
; H012+$00002B6E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00002B72:
; H012+$00002B72: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00002B78:
; H012+$00002B78: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00002B7C:
; H012+$00002B7C: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00002B82:
; H012+$00002B82: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
; STATE: H005+$3368 = current character
L012_00002B86:
; H012+$00002B86: 2b7900003368fff6  move.l $3368.l, -$a(a5)
        move.l (H005+$3368).l, -$a(a5)
; STATE: H005+$3364 = head of the party list
L012_00002B8E:
; H012+$00002B8E: 2b7900003364fffa  move.l $3364.l, -$6(a5)
        move.l (H005+$3364).l, -$6(a5)
L012_00002B96:
; H012+$00002B96: 4aadfffa  tst.l -$6(a5)
        tst.l -$6(a5)
L012_00002B9A:
; H012+$00002B9A: 6700007e  beq.w $2c1a
        beq.w H012+$2C1A
L012_00002B9E:
; H012+$00002B9E: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L012_00002BA2:
; H012+$00002BA2: 2b6b0150fff2  move.l $150(a3), -$e(a5)
        move.l $150(a3), -$e(a5)
L012_00002BA8:
; H012+$00002BA8: 4aadfff2  tst.l -$e(a5)
        tst.l -$e(a5)
L012_00002BAC:
; H012+$00002BAC: 67000054  beq.w $2c02
        beq.w H012+$2C02
L012_00002BB0:
; H012+$00002BB0: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L012_00002BB4:
; H012+$00002BB4: 2b6b002cffee  move.l $2c(a3), -$12(a5)
        move.l $2c(a3), -$12(a5)
L012_00002BBA:
; H012+$00002BBA: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002BBC:
; H012+$00002BBC: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L012_00002BC0:
; H012+$00002BC0: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L012_00002BC4:
; H012+$00002BC4: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L012_00002BC8:
; H012+$00002BC8: b842  cmp.w d2, d4
        cmp.w d2, d4
L012_00002BCA:
; H012+$00002BCA: 6600002e  bne.w $2bfa
        bne.w H012+$2BFA
; STATE: H005+$3368 = current character
L012_00002BCE:
; H012+$00002BCE: 23edfffa00003368  move.l -$6(a5), $3368.l
        move.l -$6(a5), (H005+$3368).l
L012_00002BD6:
; H012+$00002BD6: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L012_00002BDA:
; H012+$00002BDA: 4a2b003a  tst.b $3a(a3)
        tst.b $3a(a3)
L012_00002BDE:
; H012+$00002BDE: 6700000c  beq.w $2bec
        beq.w H012+$2BEC
L012_00002BE2:
; H012+$00002BE2: 2f2dfff2  move.l -$e(a5), -(a7)
        move.l -$e(a5), -(a7)
; -> H065+$2C04 (sub_H065_00002C04)
L012_00002BE6:
; H012+$00002BE6: 4eb900002c04  jsr $2c04.l
        jsr (H065+$2C04).l
L012_00002BEC:
; H012+$00002BEC: 2f2dfffa  move.l -$6(a5), -(a7)
        move.l -$6(a5), -(a7)
L012_00002BF0:
; H012+$00002BF0: 2f2dfff2  move.l -$e(a5), -(a7)
        move.l -$e(a5), -(a7)
; -> H063+$1BE8 (sub_H063_00001BE8)
L012_00002BF4:
; H012+$00002BF4: 4eb900001be8  jsr $1be8.l
        jsr (H063+$1BE8).l
L012_00002BFA:
; H012+$00002BFA: 2b6dffeefff2  move.l -$12(a5), -$e(a5)
        move.l -$12(a5), -$e(a5)
L012_00002C00:
; H012+$00002C00: 60a6  bra.b $2ba8
        bra.b H012+$2BA8
L012_00002C02:
; H012+$00002C02: 2f2dfffa  move.l -$6(a5), -(a7)
        move.l -$6(a5), -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L012_00002C06:
; H012+$00002C06: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L012_00002C0C:
; H012+$00002C0C: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L012_00002C10:
; H012+$00002C10: 2b6b018efffa  move.l $18e(a3), -$6(a5)
        move.l $18e(a3), -$6(a5)
L012_00002C16:
; H012+$00002C16: 6000ff7e  bra.w $2b96
        bra.w H012+$2B96
; STATE: H005+$3368 = current character
L012_00002C1A:
; H012+$00002C1A: 23edfff600003368  move.l -$a(a5), $3368.l
        move.l -$a(a5), (H005+$3368).l
L012_00002C22:
; H012+$00002C22: 4e5d  unlk a5
        unlk a5
L012_00002C24:
; H012+$00002C24: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002C26:
; H012+$00002C26: 4e75  rts 
        rts 
; FUNCTION: ECL_65_ADD_EP
FN_ECL_65_ADD_EP:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_65 [name verified; semantics partial]
; Purpose: ECL handler linked from the execution table: 65=ADD EP.
;   - The opcode/name/address link is verified by cross-checking H056 and H012.
;   - The single effects on the fields and all the parameters of this handler are not yet fully commented.
; Direct callers: H012+$2F76
; --------------------------------------------------------------------------
L012_00002C28:
; H012+$00002C28: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002C2A:
; H012+$00002C2A: 287ad548  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002C2E:
; H012+$00002C2E: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L012_00002C32:
; H012+$00002C32: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_ReadOperands (H061+$1670).
L012_00002C36:
; H012+$00002C36: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L012_00002C3C:
; H012+$00002C3C: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00002C40:
; H012+$00002C40: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00002C46:
; H012+$00002C46: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L012_00002C4A:
; H012+$00002C4A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLOW: Calls ECL_EvaluateOperand (H061+$184E).
L012_00002C4E:
; H012+$00002C4E: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L012_00002C54:
; H012+$00002C54: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L012_00002C58:
; H012+$00002C58: 33fc00110000334c  move.w #$11, $334c.l
        move.w #$11, (H005+$334C).l
L012_00002C60:
; H012+$00002C60: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L012_00002C68:
; H012+$00002C68: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L012_00002C6C:
; H012+$00002C6C: 670000aa  beq.w $2d18
        beq.w H012+$2D18
L012_00002C70:
; H012+$00002C70: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00002C74:
; H012+$00002C74: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_00002C78:
; H012+$00002C78: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_00002C7C:
; H012+$00002C7C: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_00002C80:
; H012+$00002C80: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00002C84:
; H012+$00002C84: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00002C86:
; H012+$00002C86: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00002C8A:
; H012+$00002C8A: 3f3c002b  move.w #$2b, -(a7)
        move.w #$2b, -(a7)
L012_00002C8E:
; H012+$00002C8E: 486c011f  pea.l $11f(a4)
        pea.l $11f(a4)
; -> H030+$0302 (trampoline_H030_0470)
L012_00002C92:
; H012+$00002C92: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
; -> H030+$0B4A (sub_H030_00000B4A)
L012_00002C98:
; H012+$00002C98: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
; STATE: H005+$3364 = head of the party list
L012_00002C9E:
; H012+$00002C9E: 2b7900003364fff8  move.l $3364.l, -$8(a5)
        move.l (H005+$3364).l, -$8(a5)
L012_00002CA6:
; H012+$00002CA6: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L012_00002CAA:
; H012+$00002CAA: 67000068  beq.w $2d14
        beq.w H012+$2D14
L012_00002CAE:
; H012+$00002CAE: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L012_00002CB2:
; H012+$00002CB2: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L012_00002CB6:
; H012+$00002CB6: 0c2d0007fff7  cmpi.b #$7, -$9(a5)
        cmpi.b #$7, -$9(a5)
L012_00002CBC:
; H012+$00002CBC: 62000022  bhi.w $2ce0
        bhi.w H012+$2CE0
L012_00002CC0:
; H012+$00002CC0: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002CC2:
; H012+$00002CC2: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L012_00002CC6:
; H012+$00002CC6: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00002CCA:
; H012+$00002CCA: 47eb00fe  lea.l $fe(a3), a3
        lea.l $fe(a3), a3
L012_00002CCE:
; H012+$00002CCE: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L012_00002CD2:
; H012+$00002CD2: 63000006  bls.w $2cda
        bls.w H012+$2CDA
L012_00002CD6:
; H012+$00002CD6: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L012_00002CDA:
; H012+$00002CDA: 522dfff7  addq.b #$1, -$9(a5)
        addq.b #$1, -$9(a5)
L012_00002CDE:
; H012+$00002CDE: 64d6  bcc.b $2cb6
        bcc.b H012+$2CB6
L012_00002CE0:
; H012+$00002CE0: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002CE2:
; H012+$00002CE2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00002CE6:
; H012+$00002CE6: 84edfff4  divu.w -$c(a5), d2
        divu.w -$c(a5), d2
L012_00002CEA:
; H012+$00002CEA: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L012_00002CEE:
; H012+$00002CEE: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00002CF2:
; H012+$00002CF2: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L012_00002CF6:
; H012+$00002CF6: 67000010  beq.w $2d08
        beq.w H012+$2D08
L012_00002CFA:
; H012+$00002CFA: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002CFC:
; H012+$00002CFC: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L012_00002D00:
; H012+$00002D00: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00002D04:
; H012+$00002D04: d5ab011e  add.l d2, $11e(a3)
        add.l d2, $11e(a3)
L012_00002D08:
; H012+$00002D08: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00002D0C:
; H012+$00002D0C: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
L012_00002D12:
; H012+$00002D12: 6092  bra.b $2ca6
        bra.b H012+$2CA6
L012_00002D14:
; H012+$00002D14: 600000d6  bra.w $2dec
        bra.w H012+$2DEC
; STATE: H005+$3368 = current character
L012_00002D18:
; H012+$00002D18: 2b7900003368fff8  move.l $3368.l, -$8(a5)
        move.l (H005+$3368).l, -$8(a5)
L012_00002D20:
; H012+$00002D20: 47ec014b  lea.l $14b(a4), a3
        lea.l $14b(a4), a3
L012_00002D24:
; H012+$00002D24: 45f90000000c  lea.l $c.l, a2
        lea.l (H064+$C).l, a2
L012_00002D2A:
; H012+$00002D2A: 7450  moveq #$50, d2
        moveq #80, d2
L012_00002D2C:
; H012+$00002D2C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L012_00002D2E:
; H012+$00002D2E: 57cafffc  dbeq d2, $2d2c
        dbeq d2, H012+$2D2C
L012_00002D32:
; H012+$00002D32: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_00002D36:
; H012+$00002D36: 48790000000c  pea.l $c.l
        pea.l (H064+$C).l
L012_00002D3C:
; H012+$00002D3C: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L012_00002D40:
; H012+$00002D40: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L012_00002D44:
; H012+$00002D44: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L012_00002D4A:
; H012+$00002D4A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_00002D4E:
; H012+$00002D4E: 48790000000c  pea.l $c.l
        pea.l (H064+$C).l
L012_00002D54:
; H012+$00002D54: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L012_00002D58:
; H012+$00002D58: 486c015c  pea.l $15c(a4)
        pea.l $15c(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L012_00002D5C:
; H012+$00002D5C: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L012_00002D62:
; H012+$00002D62: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L012_00002D66:
; H012+$00002D66: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L012_00002D6A:
; H012+$00002D6A: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L012_00002D6E:
; H012+$00002D6E: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L012_00002D72:
; H012+$00002D72: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L012_00002D76:
; H012+$00002D76: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00002D78:
; H012+$00002D78: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_00002D7C:
; H012+$00002D7C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_00002D80:
; H012+$00002D80: 48790000000c  pea.l $c.l
        pea.l (H064+$C).l
; -> H030+$0302 (trampoline_H030_0470)
L012_00002D86:
; H012+$00002D86: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
; -> H030+$0B4A (sub_H030_00000B4A)
L012_00002D8C:
; H012+$00002D8C: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L012_00002D92:
; H012+$00002D92: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L012_00002D96:
; H012+$00002D96: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L012_00002D9A:
; H012+$00002D9A: 0c2d0007fff7  cmpi.b #$7, -$9(a5)
        cmpi.b #$7, -$9(a5)
L012_00002DA0:
; H012+$00002DA0: 62000022  bhi.w $2dc4
        bhi.w H012+$2DC4
L012_00002DA4:
; H012+$00002DA4: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002DA6:
; H012+$00002DA6: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L012_00002DAA:
; H012+$00002DAA: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00002DAE:
; H012+$00002DAE: 47eb00fe  lea.l $fe(a3), a3
        lea.l $fe(a3), a3
L012_00002DB2:
; H012+$00002DB2: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L012_00002DB6:
; H012+$00002DB6: 63000006  bls.w $2dbe
        bls.w H012+$2DBE
L012_00002DBA:
; H012+$00002DBA: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L012_00002DBE:
; H012+$00002DBE: 522dfff7  addq.b #$1, -$9(a5)
        addq.b #$1, -$9(a5)
L012_00002DC2:
; H012+$00002DC2: 64d6  bcc.b $2d9a
        bcc.b H012+$2D9A
L012_00002DC4:
; H012+$00002DC4: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002DC6:
; H012+$00002DC6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L012_00002DCA:
; H012+$00002DCA: 84edfff4  divu.w -$c(a5), d2
        divu.w -$c(a5), d2
L012_00002DCE:
; H012+$00002DCE: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L012_00002DD2:
; H012+$00002DD2: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00002DD6:
; H012+$00002DD6: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L012_00002DDA:
; H012+$00002DDA: 67000010  beq.w $2dec
        beq.w H012+$2DEC
L012_00002DDE:
; H012+$00002DDE: 7400  moveq #$0, d2
        moveq #0, d2
L012_00002DE0:
; H012+$00002DE0: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L012_00002DE4:
; H012+$00002DE4: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L012_00002DE8:
; H012+$00002DE8: d5ab011e  add.l d2, $11e(a3)
        add.l d2, $11e(a3)
L012_00002DEC:
; H012+$00002DEC: 4e5d  unlk a5
        unlk a5
L012_00002DEE:
; H012+$00002DEE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00002DF0:
; H012+$00002DF0: 4e75  rts 
        rts 
; FUNCTION: ECL_execute_opcode
FN_ECL_execute_opcode:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_DispatchOpcode [verified]
; Purpose: Selects the native handler of the current ECL opcode.
;   - Reads H005+$2493.
;   - The table at H012+$2F80 covers opcodes 0..65; there is a default branch.
;   - The shared handlers can tell the opcode apart through the current byte.
; --------------------------------------------------------------------------
L012_00002DF2:
; H012+$00002DF2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00002DF4:
; H012+$00002DF4: 287ad37e  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00002DF8:
; H012+$00002DF8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L012_00002DFC:
; H012+$00002DFC: 7400  moveq #$0, d2
        moveq #0, d2
; STATE: H005+$2493 = current ECL opcode
L012_00002DFE:
; H012+$00002DFE: 143900002493  move.b $2493.l, d2
        move.b (H005+$2493).l, d2
L012_00002E04:
; H012+$00002E04: 600001fe  bra.w $3004
        bra.w H012+$3004
; FLOW: Calls ECL_Handler_0 (H064+$0156).
L012_00002E08:
; H012+$00002E08: 4eb900000156  jsr $156.l
        jsr (FN_ECL_0_EXIT).l
L012_00002E0E:
; H012+$00002E0E: 4e75  rts 
        rts 
; FLOW: Calls ECL_GOTO (H064+$0202).
L012_00002E10:
; H012+$00002E10: 4eb900000202  jsr $202.l
        jsr (FN_ECL_1_GOTO).l
L012_00002E16:
; H012+$00002E16: 4e75  rts 
        rts 
; FLOW: Calls ECL_GOSUB (H064+$0234).
L012_00002E18:
; H012+$00002E18: 4eb900000234  jsr $234.l
        jsr (FN_ECL_2_GOSUB).l
L012_00002E1E:
; H012+$00002E1E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_3 (H064+$0258).
L012_00002E20:
; H012+$00002E20: 4eb900000258  jsr $258.l
        jsr (FN_ECL_3_COMPARE).l
L012_00002E26:
; H012+$00002E26: 4e75  rts 
        rts 
; FLOW: Calls ECL_Arithmetic (H064+$0306).
L012_00002E28:
; H012+$00002E28: 4eb900000306  jsr $306.l
        jsr (FN_ECL_4_ADD__5_SUBTRAT__6_DIVIDE__7_MULTIPLY).l
L012_00002E2E:
; H012+$00002E2E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_8 (H064+$03FC).
L012_00002E30:
; H012+$00002E30: 4eb9000003fc  jsr $3fc.l
        jsr (FN_ECL_8_RANDOM).l
L012_00002E36:
; H012+$00002E36: 4e75  rts 
        rts 
; FLOW: Calls ECL_SAVE_AssignVariable (H064+$0468).
L012_00002E38:
; H012+$00002E38: 4eb900000468  jsr $468.l
        jsr (FN_ECL_9_SAVE).l
L012_00002E3E:
; H012+$00002E3E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_10 (H064+$04DC).
L012_00002E40:
; H012+$00002E40: 4eb9000004dc  jsr $4dc.l
        jsr (FN_ECL_10_LOAD_CHARACTER).l
L012_00002E46:
; H012+$00002E46: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_11 (H064+$06A0).
L012_00002E48:
; H012+$00002E48: 4eb9000006a0  jsr $6a0.l
        jsr (FN_ECL_11_LOAD_MONSTER).l
L012_00002E4E:
; H012+$00002E4E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_12 (H064+$05E2).
L012_00002E50:
; H012+$00002E50: 4eb9000005e2  jsr $5e2.l
        jsr (FN_ECL_12_SETUP_MONSTER).l
L012_00002E56:
; H012+$00002E56: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_13 (H064+$0ABE).
L012_00002E58:
; H012+$00002E58: 4eb900000abe  jsr $abe.l
        jsr (FN_ECL_13_APPROACH).l
L012_00002E5E:
; H012+$00002E5E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_14 (H064+$0B10).
L012_00002E60:
; H012+$00002E60: 4eb900000b10  jsr $b10.l
        jsr (FN_ECL_14_PICTURE).l
L012_00002E66:
; H012+$00002E66: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_15 (H064+$0C62).
L012_00002E68:
; H012+$00002E68: 4eb900000c62  jsr $c62.l
        jsr (FN_ECL_15_INPUT_NUMBER).l
L012_00002E6E:
; H012+$00002E6E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_16 (H064+$0CC4).
L012_00002E70:
; H012+$00002E70: 4eb900000cc4  jsr $cc4.l
        jsr (FN_ECL_16_INPUT_STRING).l
L012_00002E76:
; H012+$00002E76: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_17 (H064+$0D4A).
L012_00002E78:
; H012+$00002E78: 4eb900000d4a  jsr $d4a.l
        jsr (FN_ECL_17_PRINT__18_PRINTCLEAR).l
L012_00002E7E:
; H012+$00002E7E: 4e75  rts 
        rts 
; FLOW: Calls ECL_RETURN (H064+$0E40).
L012_00002E80:
; H012+$00002E80: 4eb900000e40  jsr $e40.l
        jsr (FN_ECL_19_RETURN).l
L012_00002E86:
; H012+$00002E86: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_20 (H064+$0E9C).
L012_00002E88:
; H012+$00002E88: 4eb900000e9c  jsr $e9c.l
        jsr (FN_ECL_20_COMPARE_AND).l
L012_00002E8E:
; H012+$00002E8E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_21 (H064+$13AC).
L012_00002E90:
; H012+$00002E90: 4eb9000013ac  jsr $13ac.l
        jsr (FN_ECL_21_VERTICAL_MENU).l
L012_00002E96:
; H012+$00002E96: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_22 (H064+$0F30).
L012_00002E98:
; H012+$00002E98: 4eb900000f30  jsr $f30.l
        jsr (FN_ECL_22_IF__23_IF__24_IF__25_IF__26_IF__27_IF).l
L012_00002E9E:
; H012+$00002E9E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_28 (H064+$1748).
L012_00002EA0:
; H012+$00002EA0: 4eb900001748  jsr $1748.l
        jsr (FN_ECL_28_CLEARMONSTERS).l
L012_00002EA6:
; H012+$00002EA6: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_29 (H064+$17BC).
L012_00002EA8:
; H012+$00002EA8: 4eb9000017bc  jsr $17bc.l
        jsr (FN_ECL_29_PARTYSTRENGTH).l
L012_00002EAE:
; H012+$00002EAE: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_30 (H012+$01FA).
L012_00002EB0:
; H012+$00002EB0: 6100d348  bsr.w $1fa
        bsr.w H012+$1FA
L012_00002EB4:
; H012+$00002EB4: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_32 (H064+$0F90).
L012_00002EB6:
; H012+$00002EB6: 4eb900000f90  jsr $f90.l
        jsr (FN_ECL_32_NEWECL).l
L012_00002EBC:
; H012+$00002EBC: 4e75  rts 
        rts 
; FLOW: Calls ECL_LOAD_FILES_or_PIECES (H064+$1004).
L012_00002EBE:
; H012+$00002EBE: 4eb900001004  jsr $1004.l
        jsr (FN_ECL_33_LOAD_FILES__55_LOAD_PIECES).l
L012_00002EC4:
; H012+$00002EC4: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_34 (H012+$05D6).
L012_00002EC6:
; H012+$00002EC6: 6100d70e  bsr.w $5d6
        bsr.w H012+$5D6
L012_00002ECA:
; H012+$00002ECA: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_35 (H012+$0688).
L012_00002ECC:
; H012+$00002ECC: 6100d7ba  bsr.w $688
        bsr.w H012+$688
L012_00002ED0:
; H012+$00002ED0: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_36 (H012+$0766).
L012_00002ED2:
; H012+$00002ED2: 6100d892  bsr.w $766
        bsr.w H012+$766
L012_00002ED6:
; H012+$00002ED6: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_37 (H012+$0B18).
L012_00002ED8:
; H012+$00002ED8: 6100dc3e  bsr.w $b18
        bsr.w H012+$B18
L012_00002EDC:
; H012+$00002EDC: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_39 (H012+$0BEA).
L012_00002EDE:
; H012+$00002EDE: 6100dd0a  bsr.w $bea
        bsr.w H012+$BEA
L012_00002EE2:
; H012+$00002EE2: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_40 (H012+$14C8).
L012_00002EE4:
; H012+$00002EE4: 6100e5e2  bsr.w $14c8
        bsr.w H012+$14C8
L012_00002EE8:
; H012+$00002EE8: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_41 (H012+$15AE).
L012_00002EEA:
; H012+$00002EEA: 6100e6c2  bsr.w $15ae
        bsr.w H012+$15AE
L012_00002EEE:
; H012+$00002EEE: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_42 (H064+$12CA).
L012_00002EF0:
; H012+$00002EF0: 4eb9000012ca  jsr $12ca.l
        jsr (FN_ECL_42_GETTABLE).l
L012_00002EF6:
; H012+$00002EF6: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_43 (H064+$1544).
L012_00002EF8:
; H012+$00002EF8: 4eb900001544  jsr $1544.l
        jsr (FN_ECL_43_HORIZONTAL_MENU).l
L012_00002EFE:
; H012+$00002EFE: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_44 (H012+$1DDE).
L012_00002F00:
; H012+$00002F00: 6100eedc  bsr.w $1dde
        bsr.w H012+$1DDE
L012_00002F04:
; H012+$00002F04: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_45 (H012+$26D6).
L012_00002F06:
; H012+$00002F06: 6100f7ce  bsr.w $26d6
        bsr.w H012+$26D6
L012_00002F0A:
; H012+$00002F0A: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_46 (H012+$1F68).
L012_00002F0C:
; H012+$00002F0C: 6100f05a  bsr.w $1f68
        bsr.w H012+$1F68
L012_00002F10:
; H012+$00002F10: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_47 (H064+$121C).
L012_00002F12:
; H012+$00002F12: 4eb90000121c  jsr $121c.l
        jsr (FN_ECL_47_AND__48_OR).l
L012_00002F18:
; H012+$00002F18: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_49 (H012+$2358).
L012_00002F1A:
; H012+$00002F1A: 6100f43c  bsr.w $2358
        bsr.w H012+$2358
L012_00002F1E:
; H012+$00002F1E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_50 (H012+$1E90).
L012_00002F20:
; H012+$00002F20: 6100ef6e  bsr.w $1e90
        bsr.w H012+$1E90
L012_00002F24:
; H012+$00002F24: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_51 (H012+$23D6).
L012_00002F26:
; H012+$00002F26: 6100f4ae  bsr.w $23d6
        bsr.w H012+$23D6
L012_00002F2A:
; H012+$00002F2A: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_52 (H012+$2392).
L012_00002F2C:
; H012+$00002F2C: 6100f464  bsr.w $2392
        bsr.w H012+$2392
L012_00002F30:
; H012+$00002F30: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_53 (H064+$1346).
L012_00002F32:
; H012+$00002F32: 4eb900001346  jsr $1346.l
        jsr (FN_ECL_53_SAVE_TABLE).l
L012_00002F38:
; H012+$00002F38: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_54 (H012+$2502).
L012_00002F3A:
; H012+$00002F3A: 6100f5c6  bsr.w $2502
        bsr.w H012+$2502
L012_00002F3E:
; H012+$00002F3E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_56 (H012+$29A6).
L012_00002F40:
; H012+$00002F40: 6100fa64  bsr.w $29a6
        bsr.w H012+$29A6
L012_00002F44:
; H012+$00002F44: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_57 (H012+$2486).
L012_00002F46:
; H012+$00002F46: 6100f53e  bsr.w $2486
        bsr.w H012+$2486
L012_00002F4A:
; H012+$00002F4A: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_58 (H012+$1F4C).
L012_00002F4C:
; H012+$00002F4C: 6100effe  bsr.w $1f4c
        bsr.w H012+$1F4C
L012_00002F50:
; H012+$00002F50: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_59 (H012+$2596).
L012_00002F52:
; H012+$00002F52: 6100f642  bsr.w $2596
        bsr.w H012+$2596
L012_00002F56:
; H012+$00002F56: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_60 (H012+$2AAE).
L012_00002F58:
; H012+$00002F58: 6100fb54  bsr.w $2aae
        bsr.w H012+$2AAE
L012_00002F5C:
; H012+$00002F5C: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_61 (H012+$241C).
L012_00002F5E:
; H012+$00002F5E: 6100f4bc  bsr.w $241c
        bsr.w H012+$241C
L012_00002F62:
; H012+$00002F62: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_62 (H012+$2ABE).
L012_00002F64:
; H012+$00002F64: 6100fb58  bsr.w $2abe
        bsr.w H012+$2ABE
L012_00002F68:
; H012+$00002F68: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_63 (H012+$2AF6).
L012_00002F6A:
; H012+$00002F6A: 6100fb8a  bsr.w $2af6
        bsr.w H012+$2AF6
L012_00002F6E:
; H012+$00002F6E: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_64 (H012+$2B64).
L012_00002F70:
; H012+$00002F70: 6100fbf2  bsr.w $2b64
        bsr.w H012+$2B64
L012_00002F74:
; H012+$00002F74: 4e75  rts 
        rts 
; FLOW: Calls ECL_Handler_65 (H012+$2C28).
L012_00002F76:
; H012+$00002F76: 6100fcb0  bsr.w $2c28
        bsr.w H012+$2C28
L012_00002F7A:
; H012+$00002F7A: 4e75  rts 
        rts 
L012_00002F7C:
; H012+$00002F7C: 4e75  rts 
        rts 
; Preserved bytes H012+$00002F7E..$00003004; code/data not fully classified.
        dc.w $FFFC,$FE88,$FE90,$FE98,$FEA0,$FEA8,$FEA8,$FEA8
        dc.w $FEA8,$FEB0,$FEB8,$FEC0,$FEC8,$FED0,$FED8,$FEE0
        dc.w $FEE8,$FEF0,$FEF8,$FEF8,$FF00,$FF08,$FF10,$FF18
        dc.w $FF18,$FF18,$FF18,$FF18,$FF18,$FF20,$FF28,$FF30
        dc.w $FFFC,$FF36,$FF3E,$FF46,$FF4C,$FF52,$FF58,$FF58
        dc.w $FF5E,$FF64,$FF6A,$FF70,$FF78,$FF80,$FF86,$FF8C
        dc.w $FF92,$FF92,$FF9A,$FFA0,$FFA6,$FFAC,$FFB2,$FFBA
        dc.w $FF3E,$FFC0,$FFC6,$FFCC,$FFD2,$FFD8,$FFDE,$FFE4
        dc.w $FFEA,$FFF0,$FFF6
L012_00003004:
; H012+$00003004: 47faff7a  lea.l $2f80(pc), a3
        lea.l H012+$2F80(pc), a3
L012_00003008:
; H012+$00003008: 0c420041  cmpi.w #$41, d2
        cmpi.w #$41, d2
L012_0000300C:
; H012+$0000300C: 6302  bls.b $3010
        bls.b H012+$3010
L012_0000300E:
; H012+$0000300E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L012_00003010:
; H012+$00003010: e342  asl.w #$1, d2
        asl.w #$1, d2
L012_00003012:
; H012+$00003012: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H012+$2F80; indices 0..65, default -1.
L012_00003016:
; H012+$00003016: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L012_0000301A:
; H012+$0000301A: 4e5d  unlk a5
        unlk a5
L012_0000301C:
; H012+$0000301C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_0000301E:
; H012+$0000301E: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H012_00003020 [partial]
; Purpose: Routine of the ECL dispatcher, encounters and native scenario loop module; calls H042+$0300, H011+$04E2, H060+$0018, H063+$0D80.
;   - Calls H042+$0300.
;   - Calls H011+$04E2.
;   - Calls H060+$0018.
;   - Calls H063+$0D80.
;   - Uses the global state: H005+$281C (start of the coordinates/view block); H005+$3E00 (pointer to persistent state B, 2048 bytes); H005+$3368 (current character).
; Direct callers: H012+$329E, H012+$342C, H012+$33D2, H012+$34BA
; --------------------------------------------------------------------------
L012_00003020:
; H012+$00003020: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00003022:
; H012+$00003022: 287ad150  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00003026:
; H012+$00003026: 4e550000  link.w a5, #$0
        link.w a5, #$0
L012_0000302A:
; H012+$0000302A: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLOW: Calls Free_Sequence (H042+$0300).
L012_00003030:
; H012+$00003030: 4eb900000300  jsr $300.l
        jsr (H042+$300).l
L012_00003036:
; H012+$00003036: 47ec016f  lea.l $16f(a4), a3
        lea.l $16f(a4), a3
L012_0000303A:
; H012+$0000303A: 45f90000279c  lea.l $279c.l, a2
        lea.l (H005+$279C).l, a2
L012_00003040:
; H012+$00003040: 7408  moveq #$8, d2
        moveq #8, d2
L012_00003042:
; H012+$00003042: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L012_00003044:
; H012+$00003044: 57cafffc  dbeq d2, $3042
        dbeq d2, H012+$3042
L012_00003048:
; H012+$00003048: 13fc00ff00002485  move.b #$ff, $2485.l
        move.b #$ff, (H005+$2485).l
L012_00003050:
; H012+$00003050: 42390000000a  clr.b $a.l
        clr.b (H064+$A).l
; STATE: H005+$281C = start of the coordinates/view block
L012_00003056:
; H012+$00003056: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L012_0000305C:
; H012+$0000305C: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
; -> H011+$04E2 (sub_H011_000004E2)
L012_00003062:
; H012+$00003062: 4eb9000004e2  jsr $4e2.l
        jsr (H011+$4E2).l
L012_00003068:
; H012+$00003068: 13c000002822  move.b d0, $2822.l
        move.b d0, (H005+$2822).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_0000306E:
; H012+$0000306E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00003074:
; H012+$00003074: 426b05aa  clr.w $5aa(a3)
        clr.w $5aa(a3)
; STATE: H005+$3368 = current character
L012_00003078:
; H012+$00003078: 23f90000336800000000  move.l $3368.l, $0.l
        move.l (H005+$3368).l, (H064+$0).l
L012_00003082:
; H012+$00003082: 3f3900003dec  move.w $3dec.l, -(a7)
        move.w (H005+$3DEC).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_00003088:
; H012+$00003088: 6100d100  bsr.w $18a
        bsr.w H012+$18A
L012_0000308C:
; H012+$0000308C: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_00003092:
; H012+$00003092: 66000014  bne.w $30a8
        bne.w H012+$30A8
L012_00003096:
; H012+$00003096: 7400  moveq #$0, d2
        moveq #0, d2
L012_00003098:
; H012+$00003098: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_0000309E:
; H012+$0000309E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_000030A4:
; H012+$000030A4: 374201e4  move.w d2, $1e4(a3)
        move.w d2, $1e4(a3)
L012_000030A8:
; H012+$000030A8: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_000030AE:
; H012+$000030AE: 66000086  bne.w $3136
        bne.w H012+$3136
L012_000030B2:
; H012+$000030B2: 0c39000400003de2  cmpi.b #$4, $3de2.l
        cmpi.b #$4, (H005+$3DE2).l
L012_000030BA:
; H012+$000030BA: 6600000e  bne.w $30ca
        bne.w H012+$30CA
; STATE: H005+$3DE3 = native context, 5 in combat
L012_000030BE:
; H012+$000030BE: 0c39000400003de3  cmpi.b #$4, $3de3.l
        cmpi.b #$4, (H005+$3DE3).l
L012_000030C6:
; H012+$000030C6: 6600000c  bne.w $30d4
        bne.w H012+$30D4
L012_000030CA:
; H012+$000030CA: 4a3900000008  tst.b $8.l
        tst.b (H064+$8).l
L012_000030D0:
; H012+$000030D0: 6600001a  bne.w $30ec
        bne.w H012+$30EC
L012_000030D4:
; H012+$000030D4: 0c39000400003de2  cmpi.b #$4, $3de2.l
        cmpi.b #$4, (H005+$3DE2).l
L012_000030DC:
; H012+$000030DC: 66000014  bne.w $30f2
        bne.w H012+$30F2
; STATE: H005+$3DE3 = native context, 5 in combat
L012_000030E0:
; H012+$000030E0: 0c39000400003de3  cmpi.b #$4, $3de3.l
        cmpi.b #$4, (H005+$3DE3).l
L012_000030E8:
; H012+$000030E8: 66000008  bne.w $30f2
        bne.w H012+$30F2
; -> H060+$0018 (sub_H060_00000018)
L012_000030EC:
; H012+$000030EC: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
L012_000030F2:
; H012+$000030F2: 42390000000a  clr.b $a.l
        clr.b (H064+$A).l
L012_000030F8:
; H012+$000030F8: 3f3900003df4  move.w $3df4.l, -(a7)
        move.w (H005+$3DF4).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_000030FE:
; H012+$000030FE: 6100d08a  bsr.w $18a
        bsr.w H012+$18A
L012_00003102:
; H012+$00003102: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_00003108:
; H012+$00003108: 6600002c  bne.w $3136
        bne.w H012+$3136
L012_0000310C:
; H012+$0000310C: 3f3900003df2  move.w $3df2.l, -(a7)
        move.w (H005+$3DF2).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_00003112:
; H012+$00003112: 6100d076  bsr.w $18a
        bsr.w H012+$18A
L012_00003116:
; H012+$00003116: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_0000311C:
; H012+$0000311C: 66000018  bne.w $3136
        bne.w H012+$3136
; STATE: H005+$3368 = current character
L012_00003120:
; H012+$00003120: 23f90000000000003368  move.l $0.l, $3368.l
        move.l (H064+$0).l, (H005+$3368).l
; STATE: H005+$3368 = current character
L012_0000312A:
; H012+$0000312A: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L012_00003130:
; H012+$00003130: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L012_00003136:
; H012+$00003136: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_0000313C:
; H012+$0000313C: 6600feec  bne.w $302a
        bne.w H012+$302A
; STATE: H005+$3DE3 = native context, 5 in combat
L012_00003140:
; H012+$00003140: 13f900003de300003de2  move.b $3de3.l, $3de2.l
        move.b (H005+$3DE3).l, (H005+$3DE2).l
L012_0000314A:
; H012+$0000314A: 4e5d  unlk a5
        unlk a5
L012_0000314C:
; H012+$0000314C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_0000314E:
; H012+$0000314E: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Scenario_MainLoop [verified]
; Purpose: Native scenario loop: links ECL scripts, player commands and scene update.
;   - Selects/loads the ECL through H061+$1ACC.
;   - Initialises the ECL entries and starts the entry of the scenario.
;   - Alternates execution of the ECL events with native exploration input.
;   - H068+$0C0E handles the exploration menu; H068+$122E handles movement/door interactions.
;   - Checks the exit request H005+$24D0 and clears the party context.
; Direct callers: H001+$0216
; --------------------------------------------------------------------------
L012_00003150:
; H012+$00003150: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L012_00003152:
; H012+$00003152: 287ad020  movea.l $174(pc), a4
        movea.l H012+$174(pc), a4
L012_00003156:
; H012+$00003156: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
; STATE: H005+$3368 = current character
L012_0000315A:
; H012+$0000315A: 23f90000336800000000  move.l $3368.l, $0.l
        move.l (H005+$3368).l, (H064+$0).l
L012_00003164:
; H012+$00003164: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
L012_0000316C:
; H012+$0000316C: 4239000024bb  clr.b $24bb.l
        clr.b (H005+$24BB).l
L012_00003172:
; H012+$00003172: 423900000007  clr.b $7.l
        clr.b (H064+$7).l
L012_00003178:
; H012+$00003178: 423900000006  clr.b $6.l
        clr.b (H064+$6).l
L012_0000317E:
; H012+$0000317E: 423900000009  clr.b $9.l
        clr.b (H064+$9).l
L012_00003184:
; H012+$00003184: 423900000008  clr.b $8.l
        clr.b (H064+$8).l
L012_0000318A:
; H012+$0000318A: 13fc0001000024b2  move.b #$1, $24b2.l
        move.b #$1, (H005+$24B2).l
; STATE: H005+$3DE3 = native context, 5 in combat
L012_00003192:
; H012+$00003192: 13fc000400003de3  move.b #$4, $3de3.l
        move.b #$4, (H005+$3DE3).l
L012_0000319A:
; H012+$0000319A: 42390000000a  clr.b $a.l
        clr.b (H064+$A).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_000031A0:
; H012+$000031A0: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_000031A6:
; H012+$000031A6: 4a6b01e4  tst.w $1e4(a3)
        tst.w $1e4(a3)
L012_000031AA:
; H012+$000031AA: 66000036  bne.w $31e2
        bne.w H012+$31E2
L012_000031AE:
; H012+$000031AE: 4239000024b2  clr.b $24b2.l
        clr.b (H005+$24B2).l
; STATE: H005+$24D7 = flag of the demo branch
L012_000031B4:
; H012+$000031B4: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L012_000031BA:
; H012+$000031BA: 6700000e  beq.w $31ca
        beq.w H012+$31CA
L012_000031BE:
; H012+$000031BE: 13fc003900002498  move.b #$39, $2498.l
        move.b #$39, (H005+$2498).l
L012_000031C6:
; H012+$000031C6: 60000016  bra.w $31de
        bra.w H012+$31DE
L012_000031CA:
; H012+$000031CA: 13fc002400002498  move.b #$24, $2498.l
        move.b #$24, (H005+$2498).l
; STATE: H005+$3368 = current character
L012_000031D2:
; H012+$000031D2: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L012_000031D8:
; H012+$000031D8: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L012_000031DE:
; H012+$000031DE: 60000012  bra.w $31f2
        bra.w H012+$31F2
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_000031E2:
; H012+$000031E2: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_000031E8:
; H012+$000031E8: 342b01e4  move.w $1e4(a3), d2
        move.w $1e4(a3), d2
L012_000031EC:
; H012+$000031EC: 13c200002498  move.b d2, $2498.l
        move.b d2, (H005+$2498).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_000031F2:
; H012+$000031F2: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_000031F8:
; H012+$000031F8: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L012_000031FC:
; H012+$000031FC: 6600000a  bne.w $3208
        bne.w H012+$3208
; STATE: H005+$3DE3 = native context, 5 in combat
L012_00003200:
; H012+$00003200: 13fc000300003de3  move.b #$3, $3de3.l
        move.b #$3, (H005+$3DE3).l
L012_00003208:
; H012+$00003208: 1f3900002498  move.b $2498.l, -(a7)
        move.b (H005+$2498).l, -(a7)
; STEP: Loads the ECL program selected for the session.
; FLOW: Calls ECL_LoadProgram (H061+$1ACC).
L012_0000320E:
; H012+$0000320E: 4eb900001acc  jsr $1acc.l
        jsr (H061+$1ACC).l
L012_00003214:
; H012+$00003214: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00003216:
; H012+$00003216: 4267  clr.w -(a7)
        clr.w -(a7)
L012_00003218:
; H012+$00003218: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L012_0000321C:
; H012+$0000321C: 4267  clr.w -(a7)
        clr.w -(a7)
L012_0000321E:
; H012+$0000321E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L012_00003222:
; H012+$00003222: 48790000000c  pea.l $c.l
        pea.l (H064+$C).l
; FLOW: Calls UI_DrawText (H030+$0256).
L012_00003228:
; H012+$00003228: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
; FLOW: Calls ECL_ResetExecution (H061+$1928).
L012_0000322E:
; H012+$0000322E: 4eb900001928  jsr $1928.l
        jsr (H061+$1928).l
L012_00003234:
; H012+$00003234: 3f3900003dec  move.w $3dec.l, -(a7)
        move.w (H005+$3DEC).l, -(a7)
; STEP: Runs the initial ECL entry of the scenario.
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_0000323A:
; H012+$0000323A: 6100cf4e  bsr.w $18a
        bsr.w H012+$18A
; STATE: H005+$24D7 = flag of the demo branch
L012_0000323E:
; H012+$0000323E: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L012_00003244:
; H012+$00003244: 67000038  beq.w $327e
        beq.w H012+$327E
; STATE: H005+$3364 = head of the party list
L012_00003248:
; H012+$00003248: 2b7900003364fffa  move.l $3364.l, -$6(a5)
        move.l (H005+$3364).l, -$6(a5)
L012_00003250:
; H012+$00003250: 4aadfffa  tst.l -$6(a5)
        tst.l -$6(a5)
L012_00003254:
; H012+$00003254: 67000024  beq.w $327a
        beq.w H012+$327A
; STATE: H005+$3368 = current character
L012_00003258:
; H012+$00003258: 23edfffa00003368  move.l -$6(a5), $3368.l
        move.l -$6(a5), (H005+$3368).l
L012_00003260:
; H012+$00003260: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L012_00003264:
; H012+$00003264: 2b6b018efffa  move.l $18e(a3), -$6(a5)
        move.l $18e(a3), -$6(a5)
L012_0000326A:
; H012+$0000326A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L012_0000326E:
; H012+$0000326E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H053+$00CA (trampoline_H053_01E8)
L012_00003272:
; H012+$00003272: 4eb9000000ca  jsr $ca.l
        jsr (H053+$CA).l
L012_00003278:
; H012+$00003278: 60d6  bra.b $3250
        bra.b H012+$3250
L012_0000327A:
; H012+$0000327A: 60000282  bra.w $34fe
        bra.w H012+$34FE
L012_0000327E:
; H012+$0000327E: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_00003284:
; H012+$00003284: 66000018  bne.w $329e
        bne.w H012+$329E
L012_00003288:
; H012+$00003288: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000328A:
; H012+$0000328A: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00003290:
; H012+$00003290: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00003296:
; H012+$00003296: 374201e4  move.w d2, $1e4(a3)
        move.w d2, $1e4(a3)
L012_0000329A:
; H012+$0000329A: 60000006  bra.w $32a2
        bra.w H012+$32A2
L012_0000329E:
; H012+$0000329E: 6100fd80  bsr.w $3020
        bsr.w H012+$3020
; STATE: H005+$3DE3 = native context, 5 in combat
L012_000032A2:
; H012+$000032A2: 0c39000300003de3  cmpi.b #$3, $3de3.l
        cmpi.b #$3, (H005+$3DE3).l
L012_000032AA:
; H012+$000032AA: 6700002c  beq.w $32d8
        beq.w H012+$32D8
L012_000032AE:
; H012+$000032AE: 4a39000024d1  tst.b $24d1.l
        tst.b (H005+$24D1).l
L012_000032B4:
; H012+$000032B4: 67000022  beq.w $32d8
        beq.w H012+$32D8
L012_000032B8:
; H012+$000032B8: 0c390001000024b2  cmpi.b #$1, $24b2.l
        cmpi.b #$1, (H005+$24B2).l
L012_000032C0:
; H012+$000032C0: 66000008  bne.w $32ca
        bne.w H012+$32CA
; -> H063+$321A (trampoline_H063_3384)
L012_000032C4:
; H012+$000032C4: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L012_000032CA:
; H012+$000032CA: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
; -> H060+$0018 (sub_H060_00000018)
L012_000032D2:
; H012+$000032D2: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
L012_000032D8:
; H012+$000032D8: 4239000024d1  clr.b $24d1.l
        clr.b (H005+$24D1).l
L012_000032DE:
; H012+$000032DE: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L012_000032E4:
; H012+$000032E4: 343900003de8  move.w $3de8.l, d2
        move.w (H005+$3DE8).l, d2
L012_000032EA:
; H012+$000032EA: b47900003df4  cmp.w $3df4.l, d2
        cmp.w (H005+$3DF4).l, d2
L012_000032F0:
; H012+$000032F0: 67000130  beq.w $3422
        beq.w H012+$3422
L012_000032F4:
; H012+$000032F4: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_000032FA:
; H012+$000032FA: 66000126  bne.w $3422
        bne.w H012+$3422
; STEP: Native exploration interaction; the choice comes back in D0.
; FLOW: Calls Exploration_CommandMenu (H068+$0C0E).
L012_000032FE:
; H012+$000032FE: 4eb900000c0e  jsr $c0e.l
        jsr (H068+$C0E).l
L012_00003304:
; H012+$00003304: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
; STATE: H005+$3368 = current character
L012_00003308:
; H012+$00003308: 23f90000336800000000  move.l $3368.l, $0.l
        move.l (H005+$3368).l, (H064+$0).l
L012_00003312:
; H012+$00003312: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_00003318:
; H012+$00003318: 66000014  bne.w $332e
        bne.w H012+$332E
L012_0000331C:
; H012+$0000331C: 7400  moveq #$0, d2
        moveq #0, d2
L012_0000331E:
; H012+$0000331E: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00003324:
; H012+$00003324: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_0000332A:
; H012+$0000332A: 374201e4  move.w d2, $1e4(a3)
        move.w d2, $1e4(a3)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_0000332E:
; H012+$0000332E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_00003334:
; H012+$00003334: 0c6b00010594  cmpi.w #$1, $594(a3)
        cmpi.w #$1, $594(a3)
L012_0000333A:
; H012+$0000333A: 6200001e  bhi.w $335a
        bhi.w H012+$335A
L012_0000333E:
; H012+$0000333E: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L012_00003342:
; H012+$00003342: 0c020061  cmpi.b #$61, d2
        cmpi.b #$61, d2
L012_00003346:
; H012+$00003346: 650a  bcs.b $3352
        bcs.b H012+$3352
L012_00003348:
; H012+$00003348: 0c02007a  cmpi.b #$7a, d2
        cmpi.b #$7a, d2
L012_0000334C:
; H012+$0000334C: 6204  bhi.b $3352
        bhi.b H012+$3352
L012_0000334E:
; H012+$0000334E: 0202005f  andi.b #$5f, d2
        andi.b #$5f, d2
L012_00003352:
; H012+$00003352: 0c020045  cmpi.b #$45, d2
        cmpi.b #$45, d2
L012_00003356:
; H012+$00003356: 660000b2  bne.w $340a
        bne.w H012+$340A
; STATE: H005+$24D0 = request to exit the scenario loop
L012_0000335A:
; H012+$0000335A: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_00003360:
; H012+$00003360: 660000a8  bne.w $340a
        bne.w H012+$340A
L012_00003364:
; H012+$00003364: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L012_00003368:
; H012+$00003368: 0c020061  cmpi.b #$61, d2
        cmpi.b #$61, d2
L012_0000336C:
; H012+$0000336C: 650a  bcs.b $3378
        bcs.b H012+$3378
L012_0000336E:
; H012+$0000336E: 0c02007a  cmpi.b #$7a, d2
        cmpi.b #$7a, d2
L012_00003372:
; H012+$00003372: 6204  bhi.b $3378
        bhi.b H012+$3378
L012_00003374:
; H012+$00003374: 0202005f  andi.b #$5f, d2
        andi.b #$5f, d2
L012_00003378:
; H012+$00003378: 0c020045  cmpi.b #$45, d2
        cmpi.b #$45, d2
L012_0000337C:
; H012+$0000337C: 6600000a  bne.w $3388
        bne.w H012+$3388
L012_00003380:
; H012+$00003380: 6100f5a0  bsr.w $2922
        bsr.w H012+$2922
L012_00003384:
; H012+$00003384: 60000062  bra.w $33e8
        bra.w H012+$33E8
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_00003388:
; H012+$00003388: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_0000338E:
; H012+$0000338E: 342b0594  move.w $594(a3), d2
        move.w $594(a3), d2
L012_00003392:
; H012+$00003392: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L012_00003394:
; H012+$00003394: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L012_00003398:
; H012+$00003398: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L012_0000339E:
; H012+$0000339E: 13c000002497  move.b d0, $2497.l
        move.b d0, (H005+$2497).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000033A4:
; H012+$000033A4: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000033AA:
; H012+$000033AA: 377c00010594  move.w #$1, $594(a3)
        move.w #$1, $594(a3)
L012_000033B0:
; H012+$000033B0: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
; -> H060+$0018 (sub_H060_00000018)
L012_000033B8:
; H012+$000033B8: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
L012_000033BE:
; H012+$000033BE: 3f3900003df2  move.w $3df2.l, -(a7)
        move.w (H005+$3DF2).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_000033C4:
; H012+$000033C4: 6100cdc4  bsr.w $18a
        bsr.w H012+$18A
L012_000033C8:
; H012+$000033C8: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_000033CE:
; H012+$000033CE: 67000006  beq.w $33d6
        beq.w H012+$33D6
L012_000033D2:
; H012+$000033D2: 6100fc4c  bsr.w $3020
        bsr.w H012+$3020
L012_000033D6:
; H012+$000033D6: 7400  moveq #$0, d2
        moveq #0, d2
L012_000033D8:
; H012+$000033D8: 143900002497  move.b $2497.l, d2
        move.b (H005+$2497).l, d2
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L012_000033DE:
; H012+$000033DE: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L012_000033E4:
; H012+$000033E4: 37420594  move.w d2, $594(a3)
        move.w d2, $594(a3)
; STATE: H005+$24D0 = request to exit the scenario loop
L012_000033E8:
; H012+$000033E8: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_000033EE:
; H012+$000033EE: 66000016  bne.w $3406
        bne.w H012+$3406
; FLOW: Calls Exploration_CommandMenu (H068+$0C0E).
L012_000033F2:
; H012+$000033F2: 4eb900000c0e  jsr $c0e.l
        jsr (H068+$C0E).l
L012_000033F8:
; H012+$000033F8: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
; STATE: H005+$3368 = current character
L012_000033FC:
; H012+$000033FC: 23f90000336800000000  move.l $3368.l, $0.l
        move.l (H005+$3368).l, (H064+$0).l
L012_00003406:
; H012+$00003406: 6000ff26  bra.w $332e
        bra.w H012+$332E
; STATE: H005+$24D0 = request to exit the scenario loop
L012_0000340A:
; H012+$0000340A: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_00003410:
; H012+$00003410: 6600000c  bne.w $341e
        bne.w H012+$341E
L012_00003414:
; H012+$00003414: 3f3900003df4  move.w $3df4.l, -(a7)
        move.w (H005+$3DF4).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_0000341A:
; H012+$0000341A: 6100cd6e  bsr.w $18a
        bsr.w H012+$18A
L012_0000341E:
; H012+$0000341E: 6000009e  bra.w $34be
        bra.w H012+$34BE
L012_00003422:
; H012+$00003422: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_00003428:
; H012+$00003428: 6700000a  beq.w $3434
        beq.w H012+$3434
L012_0000342C:
; H012+$0000342C: 6100fbf2  bsr.w $3020
        bsr.w H012+$3020
L012_00003430:
; H012+$00003430: 6000008c  bra.w $34be
        bra.w H012+$34BE
; STATE: H005+$24D0 = request to exit the scenario loop
L012_00003434:
; H012+$00003434: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_0000343A:
; H012+$0000343A: 66000082  bne.w $34be
        bne.w H012+$34BE
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_0000343E:
; H012+$0000343E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
; STATE: H005+$281C = start of the coordinates/view block
L012_00003444:
; H012+$00003444: 37790000281c01e0  move.w $281c.l, $1e0(a3)
        move.w (H005+$281C).l, $1e0(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_0000344C:
; H012+$0000344C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00003452:
; H012+$00003452: 37790000281e01e2  move.w $281e.l, $1e2(a3)
        move.w (H005+$281E).l, $1e2(a3)
; STEP: Native handling of movement/doors, before the next ECL event.
; FLOW: Calls Exploration_MoveOrDoor (H068+$122E).
L012_0000345A:
; H012+$0000345A: 4eb90000122e  jsr $122e.l
        jsr (H068+$122E).l
; -> H060+$0018 (sub_H060_00000018)
L012_00003460:
; H012+$00003460: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
; STATE: H005+$281C = start of the coordinates/view block
L012_00003466:
; H012+$00003466: 34390000281c  move.w $281c.l, d2
        move.w (H005+$281C).l, d2
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_0000346C:
; H012+$0000346C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00003472:
; H012+$00003472: b46b01e0  cmp.w $1e0(a3), d2
        cmp.w $1e0(a3), d2
L012_00003476:
; H012+$00003476: 66000016  bne.w $348e
        bne.w H012+$348E
L012_0000347A:
; H012+$0000347A: 34390000281e  move.w $281e.l, d2
        move.w (H005+$281E).l, d2
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L012_00003480:
; H012+$00003480: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L012_00003486:
; H012+$00003486: b46b01e2  cmp.w $1e2(a3), d2
        cmp.w $1e2(a3), d2
L012_0000348A:
; H012+$0000348A: 6700000c  beq.w $3498
        beq.w H012+$3498
L012_0000348E:
; H012+$0000348E: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
; FLOW: Calls Audio_Command (H043+$190E).
L012_00003492:
; H012+$00003492: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L012_00003498:
; H012+$00003498: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
L012_0000349E:
; H012+$0000349E: 13fc0001000024bc  move.b #$1, $24bc.l
        move.b #$1, (H005+$24BC).l
L012_000034A6:
; H012+$000034A6: 3f3900003df2  move.w $3df2.l, -(a7)
        move.w (H005+$3DF2).l, -(a7)
; FLOW: Calls ECL_RunAtAddress (H012+$018A).
L012_000034AC:
; H012+$000034AC: 6100ccdc  bsr.w $18a
        bsr.w H012+$18A
L012_000034B0:
; H012+$000034B0: 4a390000000a  tst.b $a.l
        tst.b (H064+$A).l
L012_000034B6:
; H012+$000034B6: 67000006  beq.w $34be
        beq.w H012+$34BE
L012_000034BA:
; H012+$000034BA: 6100fb64  bsr.w $3020
        bsr.w H012+$3020
; STEP: Goes back to the loop until exit from the scenario is requested.
; STATE: H005+$24D0 = request to exit the scenario loop
L012_000034BE:
; H012+$000034BE: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L012_000034C4:
; H012+$000034C4: 6700fe1e  beq.w $32e4
        beq.w H012+$32E4
; STATE: H005+$24D0 = request to exit the scenario loop
L012_000034C8:
; H012+$000034C8: 4239000024d0  clr.b $24d0.l
        clr.b (H005+$24D0).l
; STATE: H005+$3364 = head of the party list
L012_000034CE:
; H012+$000034CE: 2b7900003364fffa  move.l $3364.l, -$6(a5)
        move.l (H005+$3364).l, -$6(a5)
L012_000034D6:
; H012+$000034D6: 4aadfffa  tst.l -$6(a5)
        tst.l -$6(a5)
L012_000034DA:
; H012+$000034DA: 67000022  beq.w $34fe
        beq.w H012+$34FE
; STATE: H005+$3368 = current character
L012_000034DE:
; H012+$000034DE: 23edfffa00003368  move.l -$6(a5), $3368.l
        move.l -$6(a5), (H005+$3368).l
L012_000034E6:
; H012+$000034E6: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L012_000034EA:
; H012+$000034EA: 2b6b018efffa  move.l $18e(a3), -$6(a5)
        move.l $18e(a3), -$6(a5)
L012_000034F0:
; H012+$000034F0: 4227  clr.b -(a7)
        clr.b -(a7)
L012_000034F2:
; H012+$000034F2: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H053+$00CA (trampoline_H053_01E8)
L012_000034F6:
; H012+$000034F6: 4eb9000000ca  jsr $ca.l
        jsr (H053+$CA).l
L012_000034FC:
; H012+$000034FC: 60d8  bra.b $34d6
        bra.b H012+$34D6
L012_000034FE:
; H012+$000034FE: 4e5d  unlk a5
        unlk a5
L012_00003500:
; H012+$00003500: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00003502:
; H012+$00003502: 4e75  rts 
        rts 
L012_00003504:
; H012+$00003504: 4e5d  unlk a5
        unlk a5
L012_00003506:
; H012+$00003506: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L012_00003508:
; H012+$00003508: 4e75  rts 
        rts 
; Preserved bytes H012+$0000350A..$0000350C; code/data not fully classified.
        dc.w $0000
; End H012: $350C bytes
