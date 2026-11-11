; ============================================================================
; GUIDA DEL MODULO H070
; Esito combattimento, tesori e distribuzione delle ricompense.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Esito del combattimento, tesori e distribuzione delle ricompense.
; --------------------------------------------------------------------------
; H070: 6940 original bytes; all offsets are section-relative.
        section H070,code
H070:
; Preserved bytes H070+$00000000..$00000272; code/data not fully classified.
        dc.w $0000,$7072,$6573,$7320,$3C65,$6E74,$6572,$3E2F
        dc.w $3C72,$6574,$7572,$6E3E,$2074,$6F20,$636F,$6E74
        dc.w $696E,$7565,$0000,$0054,$6865,$2070,$6172,$7479
        dc.w $2068,$6173,$2066,$6C65,$642E,$0059,$6F75,$2068
        dc.w $6176,$6520,$6C6F,$7374,$2074,$6865,$2066,$6967
        dc.w $6874,$2E00,$5468,$6520,$7061,$7274,$7920,$6861
        dc.w $7320,$776F,$6E2E,$0054,$6865,$2070,$6172,$7479
        dc.w $206D,$616B,$6573,$2061,$2077,$6974,$6864,$7261
        dc.w $776C,$2E20,$2041,$2073,$6D61,$6C6C,$0066,$6565
        dc.w $2068,$6173,$2062,$6565,$6E20,$6173,$7365,$7373
        dc.w $6564,$2062,$7920,$7468,$6520,$6261,$6E6B,$2E00
        dc.w $5468,$6520,$7061,$7274,$7920,$6861,$7320,$666F
        dc.w $756E,$6420,$5472,$6561,$7375,$7265,$2100,$4561
        dc.w $6368,$2063,$6861,$7261,$6374,$6572,$2072,$6563
        dc.w $6569,$7665,$7320,$0065,$7870,$6572,$6965,$6E63
        dc.w $6520,$706F,$696E,$7473,$2E00,$4974,$656D,$733A
        dc.w $2000,$5461,$6B65,$0054,$616B,$653A,$2000,$4D6F
        dc.w $6E65,$7920,$4974,$656D,$7320,$4578,$6974,$0000
        dc.w $0056,$6965,$7720,$506F,$6F6C,$2045,$7869,$7400
        dc.w $2045,$7869,$7400,$2044,$6574,$6563,$7420,$4578
        dc.w $6974,$0056,$6965,$7720,$5461,$6B65,$2050,$6F6F
        dc.w $6C20,$5368,$6172,$6500,$5669,$6577,$2054,$616B
        dc.w $6520,$506F,$6F6C,$007E,$5965,$7320,$7E4E,$6F00
        dc.w $5468,$6572,$6520,$6973,$2073,$7469,$6C6C,$2074
        dc.w $7265,$6173,$7572,$6520,$6C65,$6674,$2E20,$2000
        dc.w $446F,$2079,$6F75,$2077,$616E,$7420,$746F,$2067
        dc.w $6F20,$6261,$636B,$2061,$6E64,$2063,$6C61,$696D
        dc.w $2079,$6F75,$7220,$7472,$6561,$7375,$7265,$3F00
        dc.w $2074,$616B,$6573,$2061,$6E64,$2068,$6964,$6573
        dc.w $2068,$6973,$2073,$6861,$7265,$2E00,$2074,$616B
        dc.w $6573,$2061,$6E64,$2068,$6964,$6573,$2068,$6572
        dc.w $2073,$6861,$7265,$2E00,$0000,$7072,$6573,$7320
        dc.w $3C65,$6E74,$6572,$3E2F,$3C72,$6574,$7572,$6E3E
        dc.w $2074,$6F20,$636F,$6E74,$696E,$7565,$0054,$6865
        dc.w $206D,$6F6E,$7374,$6572,$7320,$7265,$6A6F,$6963
        dc.w $6520,$666F,$7220,$7468,$6520,$7061,$7274,$7920
        dc.w $6861,$7320,$6265,$656E,$2064,$6573,$7472,$6F79
        dc.w $6564,$2E00,$5072,$6573,$7320,$616E,$7920,$6B65
        dc.w $7920,$746F,$2063,$6F6E,$7469,$6E75,$6500
        dc.l H070+$00000002
; --------------------------------------------------------------------------
; ROUTINE: module_init_H070 [parziale]
; Scopo: Ingresso del modulo esito combattimento, tesori e distribuzione delle ricompense; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H070+$1B16.
; Chiamanti diretti: H000+$0240
; --------------------------------------------------------------------------
L070_00000272:
; H070+$00000272: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00000274:
; H070+$00000274: 287afff8  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00000278:
; H070+$00000278: 4e550000  link.w a5, #$0
        link.w a5, #$0
L070_0000027C:
; H070+$0000027C: 60001898  bra.w $1b16
        bra.w H070+$1B16
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00000280 [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H015+$004A, H003+$0068, H063+$09B2, H015+$00BC.
;   - Richiama H015+$004A.
;   - Richiama H003+$0068.
;   - Richiama H063+$09B2.
;   - Richiama H015+$00BC.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party); H005+$3E00 (puntatore stato persistente B, 2048 byte).
; Chiamanti diretti: H070+$09B6
; --------------------------------------------------------------------------
L070_00000280:
; H070+$00000280: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00000282:
; H070+$00000282: 287affea  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00000286:
; H070+$00000286: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L070_0000028A:
; H070+$0000028A: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000028C:
; H070+$0000028C: 2b42fff6  move.l d2, -$a(a5)
        move.l d2, -$a(a5)
; STATO: H005+$3364 = testa della lista del party
L070_00000290:
; H070+$00000290: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L070_00000298:
; H070+$00000298: 426dffec  clr.w -$14(a5)
        clr.w -$14(a5)
L070_0000029C:
; H070+$0000029C: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_000002A0:
; H070+$000002A0: 670001b0  beq.w $452
        beq.w H070+$452
L070_000002A4:
; H070+$000002A4: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000002A8:
; H070+$000002A8: 2b6b0150ffee  move.l $150(a3), -$12(a5)
        move.l $150(a3), -$12(a5)
L070_000002AE:
; H070+$000002AE: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000002B2:
; H070+$000002B2: 0c2b00010199  cmpi.b #$1, $199(a3)
        cmpi.b #$1, $199(a3)
L070_000002B8:
; H070+$000002B8: 6600018a  bne.w $444
        bne.w H070+$444
L070_000002BC:
; H070+$000002BC: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000002C0:
; H070+$000002C0: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L070_000002C4:
; H070+$000002C4: 6700017e  beq.w $444
        beq.w H070+$444
L070_000002C8:
; H070+$000002C8: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000002CC:
; H070+$000002CC: 0c2b00030197  cmpi.b #$3, $197(a3)
        cmpi.b #$3, $197(a3)
L070_000002D2:
; H070+$000002D2: 67000170  beq.w $444
        beq.w H070+$444
L070_000002D6:
; H070+$000002D6: 197c0001ffff  move.b #$1, -$1(a4)
        move.b #$1, -$1(a4)
L070_000002DC:
; H070+$000002DC: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L070_000002E0:
; H070+$000002E0: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_000002E4:
; H070+$000002E4: 0c2b00010015  cmpi.b #$1, $15(a3)
        cmpi.b #$1, $15(a3)
L070_000002EA:
; H070+$000002EA: 6600003e  bne.w $32a
        bne.w H070+$32A
L070_000002EE:
; H070+$000002EE: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
L070_000002F2:
; H070+$000002F2: 0c2d0006fffb  cmpi.b #$6, -$5(a5)
        cmpi.b #$6, -$5(a5)
L070_000002F8:
; H070+$000002F8: 62000030  bhi.w $32a
        bhi.w H070+$32A
L070_000002FC:
; H070+$000002FC: 7400  moveq #$0, d2
        moveq #0, d2
L070_000002FE:
; H070+$000002FE: 142dfffb  move.b -$5(a5), d2
        move.b -$5(a5), d2
L070_00000302:
; H070+$00000302: e542  asl.w #$2, d2
        asl.w #$2, d2
L070_00000304:
; H070+$00000304: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L070_0000030A:
; H070+$0000030A: 7800  moveq #$0, d4
        moveq #0, d4
L070_0000030C:
; H070+$0000030C: 182dfffb  move.b -$5(a5), d4
        move.b -$5(a5), d4
L070_00000310:
; H070+$00000310: e344  asl.w #$1, d4
        asl.w #$1, d4
L070_00000312:
; H070+$00000312: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L070_00000316:
; H070+$00000316: 45ea00f0  lea.l $f0(a2), a2
        lea.l $f0(a2), a2
L070_0000031A:
; H070+$0000031A: 7c00  moveq #$0, d6
        moveq #0, d6
L070_0000031C:
; H070+$0000031C: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L070_00000320:
; H070+$00000320: ddb32000  add.l d6, (a3, d2.w)
        add.l d6, (a3, d2.w)
L070_00000324:
; H070+$00000324: 522dfffb  addq.b #$1, -$5(a5)
        addq.b #$1, -$5(a5)
L070_00000328:
; H070+$00000328: 64c8  bcc.b $2f2
        bcc.b H070+$2F2
L070_0000032A:
; H070+$0000032A: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000032C:
; H070+$0000032C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000330:
; H070+$00000330: 342b013c  move.w $13c(a3), d2
        move.w $13c(a3), d2
L070_00000334:
; H070+$00000334: d4adfff6  add.l -$a(a5), d2
        add.l -$a(a5), d2
L070_00000338:
; H070+$00000338: 7800  moveq #$0, d4
        moveq #0, d4
L070_0000033A:
; H070+$0000033A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_0000033E:
; H070+$0000033E: 182b013e  move.b $13e(a3), d4
        move.b $13e(a3), d4
L070_00000342:
; H070+$00000342: 7c00  moveq #$0, d6
        moveq #0, d6
L070_00000344:
; H070+$00000344: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000348:
; H070+$00000348: 1c2b0123  move.b $123(a3), d6
        move.b $123(a3), d6
L070_0000034C:
; H070+$0000034C: 2004  move.l d4, d0
        move.l d4, d0
L070_0000034E:
; H070+$0000034E: 2206  move.l d6, d1
        move.l d6, d1
; -> H015+$004A (sub_H015_0000004A)
L070_00000350:
; H070+$00000350: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L070_00000356:
; H070+$00000356: 2800  move.l d0, d4
        move.l d0, d4
L070_00000358:
; H070+$00000358: d484  add.l d4, d2
        add.l d4, d2
L070_0000035A:
; H070+$0000035A: 2b42fff6  move.l d2, -$a(a5)
        move.l d2, -$a(a5)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_0000035E:
; H070+$0000035E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000364:
; H070+$00000364: 0c6b000105c6  cmpi.w #$1, $5c6(a3)
        cmpi.w #$1, $5c6(a3)
L070_0000036A:
; H070+$0000036A: 670000d8  beq.w $444
        beq.w H070+$444
L070_0000036E:
; H070+$0000036E: 4aadffee  tst.l -$12(a5)
        tst.l -$12(a5)
L070_00000372:
; H070+$00000372: 670000d0  beq.w $444
        beq.w H070+$444
L070_00000376:
; H070+$00000376: 526dffec  addq.w #$1, -$14(a5)
        addq.w #$1, -$14(a5)
L070_0000037A:
; H070+$0000037A: 4ab900002a3a  tst.l $2a3a.l
        tst.l (H005+$2A3A).l
L070_00000380:
; H070+$00000380: 66000058  bne.w $3da
        bne.w H070+$3DA
L070_00000384:
; H070+$00000384: 7448  moveq #$48, d2
        moveq #72, d2
L070_00000386:
; H070+$00000386: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L070_00000388:
; H070+$00000388: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L070_0000038E:
; H070+$0000038E: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L070_00000394:
; H070+$00000394: 23c000002a3a  move.l d0, $2a3a.l
        move.l d0, (H005+$2A3A).l
L070_0000039A:
; H070+$0000039A: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L070_0000039E:
; H070+$0000039E: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
L070_000003A2:
; H070+$000003A2: 4267  clr.w -(a7)
        clr.w -(a7)
L070_000003A4:
; H070+$000003A4: 4267  clr.w -(a7)
        clr.w -(a7)
L070_000003A6:
; H070+$000003A6: 4227  clr.b -(a7)
        clr.b -(a7)
L070_000003A8:
; H070+$000003A8: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$09B2 (sub_H063_000009B2)
L070_000003AA:
; H070+$000003AA: 4eb9000009b2  jsr $9b2.l
        jsr (H063+$9B2).l
L070_000003B0:
; H070+$000003B0: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L070_000003B4:
; H070+$000003B4: 247900002a3a  movea.l $2a3a.l, a2
        movea.l (H005+$2A3A).l, a2
L070_000003BA:
; H070+$000003BA: 7411  moveq #$11, d2
        moveq #17, d2
L070_000003BC:
; H070+$000003BC: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L070_000003BE:
; H070+$000003BE: 51cafffc  dbra d2, $3bc
        dbra d2, H070+$3BC
L070_000003C2:
; H070+$000003C2: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L070_000003C8:
; H070+$000003C8: 422b003a  clr.b $3a(a3)
        clr.b $3a(a3)
L070_000003CC:
; H070+$000003CC: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L070_000003D2:
; H070+$000003D2: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L070_000003D6:
; H070+$000003D6: 6000005e  bra.w $436
        bra.w H070+$436
L070_000003DA:
; H070+$000003DA: 2b7900002a3afff2  move.l $2a3a.l, -$e(a5)
        move.l (H005+$2A3A).l, -$e(a5)
L070_000003E2:
; H070+$000003E2: 7448  moveq #$48, d2
        moveq #72, d2
L070_000003E4:
; H070+$000003E4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L070_000003E6:
; H070+$000003E6: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L070_000003EC:
; H070+$000003EC: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L070_000003F2:
; H070+$000003F2: 23c000002a3a  move.l d0, $2a3a.l
        move.l d0, (H005+$2A3A).l
L070_000003F8:
; H070+$000003F8: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L070_000003FC:
; H070+$000003FC: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
L070_00000400:
; H070+$00000400: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000402:
; H070+$00000402: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000404:
; H070+$00000404: 4227  clr.b -(a7)
        clr.b -(a7)
L070_00000406:
; H070+$00000406: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$09B2 (sub_H063_000009B2)
L070_00000408:
; H070+$00000408: 4eb9000009b2  jsr $9b2.l
        jsr (H063+$9B2).l
L070_0000040E:
; H070+$0000040E: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L070_00000412:
; H070+$00000412: 247900002a3a  movea.l $2a3a.l, a2
        movea.l (H005+$2A3A).l, a2
L070_00000418:
; H070+$00000418: 7411  moveq #$11, d2
        moveq #17, d2
L070_0000041A:
; H070+$0000041A: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L070_0000041C:
; H070+$0000041C: 51cafffc  dbra d2, $41a
        dbra d2, H070+$41A
L070_00000420:
; H070+$00000420: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L070_00000426:
; H070+$00000426: 422b003a  clr.b $3a(a3)
        clr.b $3a(a3)
L070_0000042A:
; H070+$0000042A: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L070_00000430:
; H070+$00000430: 276dfff2002c  move.l -$e(a5), $2c(a3)
        move.l -$e(a5), $2c(a3)
L070_00000436:
; H070+$00000436: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L070_0000043A:
; H070+$0000043A: 2b6b002cffee  move.l $2c(a3), -$12(a5)
        move.l $2c(a3), -$12(a5)
L070_00000440:
; H070+$00000440: 6000ff2c  bra.w $36e
        bra.w H070+$36E
L070_00000444:
; H070+$00000444: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000448:
; H070+$00000448: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L070_0000044E:
; H070+$0000044E: 6000fe4c  bra.w $29c
        bra.w H070+$29C
L070_00000452:
; H070+$00000452: 243900002a1e  move.l $2a1e.l, d2
        move.l (H005+$2A1E).l, d2
L070_00000458:
; H070+$00000458: 2002  move.l d2, d0
        move.l d2, d0
L070_0000045A:
; H070+$0000045A: 7264  moveq #$64, d1
        moveq #100, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_0000045C:
; H070+$0000045C: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_00000462:
; H070+$00000462: 2400  move.l d0, d2
        move.l d0, d2
L070_00000464:
; H070+$00000464: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_00000468:
; H070+$00000468: 243900002a22  move.l $2a22.l, d2
        move.l (H005+$2A22).l, d2
L070_0000046E:
; H070+$0000046E: 2002  move.l d2, d0
        move.l d2, d0
L070_00000470:
; H070+$00000470: 7214  moveq #$14, d1
        moveq #20, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_00000472:
; H070+$00000472: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_00000478:
; H070+$00000478: 2400  move.l d0, d2
        move.l d0, d2
L070_0000047A:
; H070+$0000047A: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_0000047E:
; H070+$0000047E: 243900002a26  move.l $2a26.l, d2
        move.l (H005+$2A26).l, d2
L070_00000484:
; H070+$00000484: 2002  move.l d2, d0
        move.l d2, d0
L070_00000486:
; H070+$00000486: 720a  moveq #$a, d1
        moveq #10, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_00000488:
; H070+$00000488: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_0000048E:
; H070+$0000048E: 2400  move.l d0, d2
        move.l d0, d2
L070_00000490:
; H070+$00000490: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_00000494:
; H070+$00000494: 243900002a2a  move.l $2a2a.l, d2
        move.l (H005+$2A2A).l, d2
L070_0000049A:
; H070+$0000049A: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_0000049E:
; H070+$0000049E: 243900002a2e  move.l $2a2e.l, d2
        move.l (H005+$2A2E).l, d2
L070_000004A4:
; H070+$000004A4: e382  asl.l #$1, d2
        asl.l #$1, d2
L070_000004A6:
; H070+$000004A6: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_000004AA:
; H070+$000004AA: 243900002a32  move.l $2a32.l, d2
        move.l (H005+$2A32).l, d2
L070_000004B0:
; H070+$000004B0: 2002  move.l d2, d0
        move.l d2, d0
L070_000004B2:
; H070+$000004B2: 223c000000fa  move.l #$fa, d1
        move.l #$fa, d1
; -> H015+$004A (sub_H015_0000004A)
L070_000004B8:
; H070+$000004B8: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L070_000004BE:
; H070+$000004BE: 2400  move.l d0, d2
        move.l d0, d2
L070_000004C0:
; H070+$000004C0: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_000004C4:
; H070+$000004C4: 243900002a36  move.l $2a36.l, d2
        move.l (H005+$2A36).l, d2
L070_000004CA:
; H070+$000004CA: 2002  move.l d2, d0
        move.l d2, d0
L070_000004CC:
; H070+$000004CC: 223c00000898  move.l #$898, d1
        move.l #$898, d1
; -> H015+$004A (sub_H015_0000004A)
L070_000004D2:
; H070+$000004D2: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L070_000004D8:
; H070+$000004D8: 2400  move.l d0, d2
        move.l d0, d2
L070_000004DA:
; H070+$000004DA: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_000004DE:
; H070+$000004DE: 2b7900002a3afff2  move.l $2a3a.l, -$e(a5)
        move.l (H005+$2A3A).l, -$e(a5)
L070_000004E6:
; H070+$000004E6: 4aadfff2  tst.l -$e(a5)
        tst.l -$e(a5)
L070_000004EA:
; H070+$000004EA: 67000038  beq.w $524
        beq.w H070+$524
L070_000004EE:
; H070+$000004EE: 242dfff2  move.l -$e(a5), d2
        move.l -$e(a5), d2
L070_000004F2:
; H070+$000004F2: b4b90000335c  cmp.l $335c.l, d2
        cmp.l (H005+$335C).l, d2
L070_000004F8:
; H070+$000004F8: 6700002a  beq.w $524
        beq.w H070+$524
L070_000004FC:
; H070+$000004FC: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L070_00000500:
; H070+$00000500: 4a6b0036  tst.w $36(a3)
        tst.w $36(a3)
L070_00000504:
; H070+$00000504: 6f000012  ble.w $518
        ble.w H070+$518
L070_00000508:
; H070+$00000508: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L070_0000050C:
; H070+$0000050C: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L070_00000510:
; H070+$00000510: c5fc0190  muls.w #$190, d2
        muls.w #$190, d2
L070_00000514:
; H070+$00000514: d5adfff6  add.l d2, -$a(a5)
        add.l d2, -$a(a5)
L070_00000518:
; H070+$00000518: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L070_0000051C:
; H070+$0000051C: 2b6b002cfff2  move.l $2c(a3), -$e(a5)
        move.l $2c(a3), -$e(a5)
L070_00000522:
; H070+$00000522: 60c2  bra.b $4e6
        bra.b H070+$4E6
L070_00000524:
; H070+$00000524: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00000526:
; H070+$00000526: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_0000052C:
; H070+$0000052C: 342b067c  move.w $67c(a3), d2
        move.w $67c(a3), d2
L070_00000530:
; H070+$00000530: 7800  moveq #$0, d4
        moveq #0, d4
L070_00000532:
; H070+$00000532: 183900002499  move.b $2499.l, d4
        move.b (H005+$2499).l, d4
L070_00000538:
; H070+$00000538: 9484  sub.l d4, d2
        sub.l d4, d2
L070_0000053A:
; H070+$0000053A: 282dfff6  move.l -$a(a5), d4
        move.l -$a(a5), d4
L070_0000053E:
; H070+$0000053E: 2004  move.l d4, d0
        move.l d4, d0
L070_00000540:
; H070+$00000540: 2202  move.l d2, d1
        move.l d2, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_00000542:
; H070+$00000542: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_00000548:
; H070+$00000548: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L070_0000054C:
; H070+$0000054C: 2680  move.l d0, (a3)
        move.l d0, (a3)
L070_0000054E:
; H070+$0000054E: 4e5d  unlk a5
        unlk a5
L070_00000550:
; H070+$00000550: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00000552:
; H070+$00000552: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L070_00000554:
; H070+$00000554: 588f  addq.l #$4, a7
        addq.l #$4, a7
L070_00000556:
; H070+$00000556: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H070_076E [parziale]
; Scopo: Trampolino verso H070+$076E; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H070+$076E.
; Chiamanti diretti: H070+$09C0
; --------------------------------------------------------------------------
L070_00000558:
; H070+$00000558: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_0000055A:
; H070+$0000055A: 287afd12  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_0000055E:
; H070+$0000055E: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L070_00000562:
; H070+$00000562: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L070_00000568:
; H070+$00000568: 4a6b03ea  tst.w $3ea(a3)
        tst.w $3ea(a3)
L070_0000056C:
; H070+$0000056C: 67000006  beq.w $574
        beq.w H070+$574
L070_00000570:
; H070+$00000570: 600001fc  bra.w $76e
        bra.w H070+$76E
; STATO: H005+$3364 = testa della lista del party
L070_00000574:
; H070+$00000574: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L070_0000057C:
; H070+$0000057C: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_00000580:
; H070+$00000580: 670001ec  beq.w $76e
        beq.w H070+$76E
L070_00000584:
; H070+$00000584: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000588:
; H070+$00000588: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L070_0000058C:
; H070+$0000058C: 670001d2  beq.w $760
        beq.w H070+$760
L070_00000590:
; H070+$00000590: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000594:
; H070+$00000594: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L070_0000059A:
; H070+$0000059A: 670001c4  beq.w $760
        beq.w H070+$760
L070_0000059E:
; H070+$0000059E: 2b6d000cfff8  move.l $c(a5), -$8(a5)
        move.l $c(a5), -$8(a5)
L070_000005A4:
; H070+$000005A4: 7400  moveq #$0, d2
        moveq #0, d2
L070_000005A6:
; H070+$000005A6: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000005AA:
; H070+$000005AA: 142b005c  move.b $5c(a3), d2
        move.b $5c(a3), d2
L070_000005AE:
; H070+$000005AE: 6000018e  bra.w $73e
        bra.w H070+$73E
L070_000005B2:
; H070+$000005B2: 7400  moveq #$0, d2
        moveq #0, d2
L070_000005B4:
; H070+$000005B4: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000005B8:
; H070+$000005B8: 142b0015  move.b $15(a3), d2
        move.b $15(a3), d2
L070_000005BC:
; H070+$000005BC: 0c42000e  cmpi.w #$e, d2
        cmpi.w #$e, d2
L070_000005C0:
; H070+$000005C0: 6300001a  bls.w $5dc
        bls.w H070+$5DC
L070_000005C4:
; H070+$000005C4: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_000005C8:
; H070+$000005C8: 2002  move.l d2, d0
        move.l d2, d0
L070_000005CA:
; H070+$000005CA: 720a  moveq #$a, d1
        moveq #10, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_000005CC:
; H070+$000005CC: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_000005D2:
; H070+$000005D2: 2400  move.l d0, d2
        move.l d0, d2
L070_000005D4:
; H070+$000005D4: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L070_000005D8:
; H070+$000005D8: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L070_000005DC:
; H070+$000005DC: 4e75  rts 
        rts 
L070_000005DE:
; H070+$000005DE: 7400  moveq #$0, d2
        moveq #0, d2
L070_000005E0:
; H070+$000005E0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000005E4:
; H070+$000005E4: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L070_000005E8:
; H070+$000005E8: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_000005EC:
; H070+$000005EC: 6300001a  bls.w $608
        bls.w H070+$608
L070_000005F0:
; H070+$000005F0: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_000005F4:
; H070+$000005F4: 2002  move.l d2, d0
        move.l d2, d0
L070_000005F6:
; H070+$000005F6: 720a  moveq #$a, d1
        moveq #10, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_000005F8:
; H070+$000005F8: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_000005FE:
; H070+$000005FE: 2400  move.l d0, d2
        move.l d0, d2
L070_00000600:
; H070+$00000600: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L070_00000604:
; H070+$00000604: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L070_00000608:
; H070+$00000608: 4e75  rts 
        rts 
L070_0000060A:
; H070+$0000060A: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000060C:
; H070+$0000060C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000610:
; H070+$00000610: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L070_00000614:
; H070+$00000614: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_00000618:
; H070+$00000618: 6300002c  bls.w $646
        bls.w H070+$646
L070_0000061C:
; H070+$0000061C: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000061E:
; H070+$0000061E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000622:
; H070+$00000622: 142b0015  move.b $15(a3), d2
        move.b $15(a3), d2
L070_00000626:
; H070+$00000626: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_0000062A:
; H070+$0000062A: 6300001a  bls.w $646
        bls.w H070+$646
L070_0000062E:
; H070+$0000062E: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_00000632:
; H070+$00000632: 2002  move.l d2, d0
        move.l d2, d0
L070_00000634:
; H070+$00000634: 720a  moveq #$a, d1
        moveq #10, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_00000636:
; H070+$00000636: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_0000063C:
; H070+$0000063C: 2400  move.l d0, d2
        move.l d0, d2
L070_0000063E:
; H070+$0000063E: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L070_00000642:
; H070+$00000642: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L070_00000646:
; H070+$00000646: 4e75  rts 
        rts 
L070_00000648:
; H070+$00000648: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000064A:
; H070+$0000064A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_0000064E:
; H070+$0000064E: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L070_00000652:
; H070+$00000652: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_00000656:
; H070+$00000656: 6300003e  bls.w $696
        bls.w H070+$696
L070_0000065A:
; H070+$0000065A: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000065C:
; H070+$0000065C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000660:
; H070+$00000660: 142b0013  move.b $13(a3), d2
        move.b $13(a3), d2
L070_00000664:
; H070+$00000664: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_00000668:
; H070+$00000668: 6300002c  bls.w $696
        bls.w H070+$696
L070_0000066C:
; H070+$0000066C: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000066E:
; H070+$0000066E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000672:
; H070+$00000672: 142b0015  move.b $15(a3), d2
        move.b $15(a3), d2
L070_00000676:
; H070+$00000676: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_0000067A:
; H070+$0000067A: 6300001a  bls.w $696
        bls.w H070+$696
L070_0000067E:
; H070+$0000067E: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_00000682:
; H070+$00000682: 2002  move.l d2, d0
        move.l d2, d0
L070_00000684:
; H070+$00000684: 720a  moveq #$a, d1
        moveq #10, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_00000686:
; H070+$00000686: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_0000068C:
; H070+$0000068C: 2400  move.l d0, d2
        move.l d0, d2
L070_0000068E:
; H070+$0000068E: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L070_00000692:
; H070+$00000692: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L070_00000696:
; H070+$00000696: 4e75  rts 
        rts 
L070_00000698:
; H070+$00000698: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000069A:
; H070+$0000069A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_0000069E:
; H070+$0000069E: 142b0013  move.b $13(a3), d2
        move.b $13(a3), d2
L070_000006A2:
; H070+$000006A2: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_000006A6:
; H070+$000006A6: 6300001a  bls.w $6c2
        bls.w H070+$6C2
L070_000006AA:
; H070+$000006AA: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_000006AE:
; H070+$000006AE: 2002  move.l d2, d0
        move.l d2, d0
L070_000006B0:
; H070+$000006B0: 720a  moveq #$a, d1
        moveq #10, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_000006B2:
; H070+$000006B2: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_000006B8:
; H070+$000006B8: 2400  move.l d0, d2
        move.l d0, d2
L070_000006BA:
; H070+$000006BA: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L070_000006BE:
; H070+$000006BE: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L070_000006C2:
; H070+$000006C2: 4e75  rts 
        rts 
L070_000006C4:
; H070+$000006C4: 7400  moveq #$0, d2
        moveq #0, d2
L070_000006C6:
; H070+$000006C6: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000006CA:
; H070+$000006CA: 142b0017  move.b $17(a3), d2
        move.b $17(a3), d2
L070_000006CE:
; H070+$000006CE: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L070_000006D2:
; H070+$000006D2: 6300001a  bls.w $6ee
        bls.w H070+$6EE
L070_000006D6:
; H070+$000006D6: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_000006DA:
; H070+$000006DA: 2002  move.l d2, d0
        move.l d2, d0
L070_000006DC:
; H070+$000006DC: 720a  moveq #$a, d1
        moveq #10, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_000006DE:
; H070+$000006DE: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_000006E4:
; H070+$000006E4: 2400  move.l d0, d2
        move.l d0, d2
L070_000006E6:
; H070+$000006E6: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L070_000006EA:
; H070+$000006EA: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L070_000006EE:
; H070+$000006EE: 4e75  rts 
        rts 
L070_000006F0:
; H070+$000006F0: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_000006F4:
; H070+$000006F4: 2002  move.l d2, d0
        move.l d2, d0
L070_000006F6:
; H070+$000006F6: 7202  moveq #$2, d1
        moveq #2, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_000006F8:
; H070+$000006F8: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_000006FE:
; H070+$000006FE: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L070_00000702:
; H070+$00000702: 4e75  rts 
        rts 
L070_00000704:
; H070+$00000704: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L070_00000708:
; H070+$00000708: 2002  move.l d2, d0
        move.l d2, d0
L070_0000070A:
; H070+$0000070A: 7203  moveq #$3, d1
        moveq #3, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_0000070C:
; H070+$0000070C: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_00000712:
; H070+$00000712: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L070_00000716:
; H070+$00000716: 4e75  rts 
        rts 
L070_00000718:
; H070+$00000718: 4e75  rts 
        rts 
; Preserved bytes H070+$0000071A..$0000073E; code/data not fully classified.
        dc.w $FFFC,$FE96,$FFFC,$FEC2,$FEEE,$FF2C,$FF7C,$FFA8
        dc.w $FFFC,$FFD4,$FFE8,$FFD4,$FFD4,$FFD4,$FFD4,$FFD4
        dc.w $FFE8,$FFD4
L070_0000073E:
; H070+$0000073E: 47faffdc  lea.l $71c(pc), a3
        lea.l H070+$71C(pc), a3
L070_00000742:
; H070+$00000742: 0c420010  cmpi.w #$10, d2
        cmpi.w #$10, d2
L070_00000746:
; H070+$00000746: 6302  bls.b $74a
        bls.b H070+$74A
L070_00000748:
; H070+$00000748: 74ff  moveq #$ff, d2
        moveq #-1, d2
L070_0000074A:
; H070+$0000074A: e342  asl.w #$1, d2
        asl.w #$1, d2
L070_0000074C:
; H070+$0000074C: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H070+$071C; indici 0..16, default -1.
L070_00000750:
; H070+$00000750: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L070_00000754:
; H070+$00000754: 242dfff8  move.l -$8(a5), d2
        move.l -$8(a5), d2
L070_00000758:
; H070+$00000758: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_0000075C:
; H070+$0000075C: d5ab011e  add.l d2, $11e(a3)
        add.l d2, $11e(a3)
L070_00000760:
; H070+$00000760: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000764:
; H070+$00000764: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L070_0000076A:
; H070+$0000076A: 6000fe10  bra.w $57c
        bra.w H070+$57C
L070_0000076E:
; H070+$0000076E: 4e5d  unlk a5
        unlk a5
L070_00000770:
; H070+$00000770: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00000772:
; H070+$00000772: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L070_00000774:
; H070+$00000774: 588f  addq.l #$4, a7
        addq.l #$4, a7
L070_00000776:
; H070+$00000776: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00000778 [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H029+$03E2, H062+$0452, H053+$00CA.
;   - Richiama H029+$03E2.
;   - Richiama H062+$0452.
;   - Richiama H053+$00CA.
;   - Usa lo stato globale: H005+$24D0 (richiesta di uscita dal ciclo scenario); H005+$3364 (testa della lista del party); H005+$3E00 (puntatore stato persistente B, 2048 byte).
; Chiamanti diretti: H070+$197E
; --------------------------------------------------------------------------
L070_00000778:
; H070+$00000778: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_0000077A:
; H070+$0000077A: 287afaf2  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_0000077E:
; H070+$0000077E: 4e55ffe0  link.w a5, #$ffe0
        link.w a5, #$ffe0
L070_00000782:
; H070+$00000782: 3b7c0003ffea  move.w #$3, -$16(a5)
        move.w #$3, -$16(a5)
L070_00000788:
; H070+$00000788: 3b7c000bffec  move.w #$b, -$14(a5)
        move.w #$b, -$14(a5)
L070_0000078E:
; H070+$0000078E: 3b7c0015ffee  move.w #$15, -$12(a5)
        move.w #$15, -$12(a5)
L070_00000794:
; H070+$00000794: 3b7c0017fff0  move.w #$17, -$10(a5)
        move.w #$17, -$10(a5)
L070_0000079A:
; H070+$0000079A: 3b7c001bfff2  move.w #$1b, -$e(a5)
        move.w #$1b, -$e(a5)
L070_000007A0:
; H070+$000007A0: 3b7c0023fff4  move.w #$23, -$c(a5)
        move.w #$23, -$c(a5)
L070_000007A6:
; H070+$000007A6: 3b7c0028fff6  move.w #$28, -$a(a5)
        move.w #$28, -$a(a5)
L070_000007AC:
; H070+$000007AC: 3b7c0033fff8  move.w #$33, -$8(a5)
        move.w #$33, -$8(a5)
L070_000007B2:
; H070+$000007B2: 3b7c0034fffa  move.w #$34, -$6(a5)
        move.w #$34, -$6(a5)
L070_000007B8:
; H070+$000007B8: 3b7c0035fffc  move.w #$35, -$4(a5)
        move.w #$35, -$4(a5)
L070_000007BE:
; H070+$000007BE: 3b7c001ffffe  move.w #$1f, -$2(a5)
        move.w #$1f, -$2(a5)
L070_000007C4:
; H070+$000007C4: 423900002499  clr.b $2499.l
        clr.b (H005+$2499).l
; STATO: H005+$24D0 = richiesta di uscita dal ciclo scenario
L070_000007CA:
; H070+$000007CA: 13fc0001000024d0  move.b #$1, $24d0.l
        move.b #$1, (H005+$24D0).l
L070_000007D2:
; H070+$000007D2: 422cfffe  clr.b -$2(a4)
        clr.b -$2(a4)
; STATO: H005+$3364 = testa della lista del party
L070_000007D6:
; H070+$000007D6: 2b7900003364ffe6  move.l $3364.l, -$1a(a5)
        move.l (H005+$3364).l, -$1a(a5)
L070_000007DE:
; H070+$000007DE: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L070_000007E2:
; H070+$000007E2: 67000034  beq.w $818
        beq.w H070+$818
L070_000007E6:
; H070+$000007E6: 246dffe6  movea.l -$1a(a5), a2
        movea.l -$1a(a5), a2
L070_000007EA:
; H070+$000007EA: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_000007EE:
; H070+$000007EE: 0c2b00010015  cmpi.b #$1, $15(a3)
        cmpi.b #$1, $15(a3)
L070_000007F4:
; H070+$000007F4: 67000022  beq.w $818
        beq.w H070+$818
L070_000007F8:
; H070+$000007F8: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_000007FC:
; H070+$000007FC: 0c2b00030197  cmpi.b #$3, $197(a3)
        cmpi.b #$3, $197(a3)
L070_00000802:
; H070+$00000802: 66000008  bne.w $80c
        bne.w H070+$80C
L070_00000806:
; H070+$00000806: 197c0001fffe  move.b #$1, -$2(a4)
        move.b #$1, -$2(a4)
L070_0000080C:
; H070+$0000080C: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000810:
; H070+$00000810: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L070_00000816:
; H070+$00000816: 60c6  bra.b $7de
        bra.b H070+$7DE
; STATO: H005+$3364 = testa della lista del party
L070_00000818:
; H070+$00000818: 2b7900003364ffe6  move.l $3364.l, -$1a(a5)
        move.l (H005+$3364).l, -$1a(a5)
L070_00000820:
; H070+$00000820: 422dffe1  clr.b -$1f(a5)
        clr.b -$1f(a5)
L070_00000824:
; H070+$00000824: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L070_00000828:
; H070+$00000828: 67000052  beq.w $87c
        beq.w H070+$87C
L070_0000082C:
; H070+$0000082C: 4a2dffe1  tst.b -$1f(a5)
        tst.b -$1f(a5)
L070_00000830:
; H070+$00000830: 6600004a  bne.w $87c
        bne.w H070+$87C
L070_00000834:
; H070+$00000834: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000838:
; H070+$00000838: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L070_0000083C:
; H070+$0000083C: 6600002c  bne.w $86a
        bne.w H070+$86A
L070_00000840:
; H070+$00000840: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000844:
; H070+$00000844: 0c2b00040197  cmpi.b #$4, $197(a3)
        cmpi.b #$4, $197(a3)
L070_0000084A:
; H070+$0000084A: 6700001e  beq.w $86a
        beq.w H070+$86A
L070_0000084E:
; H070+$0000084E: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000852:
; H070+$00000852: 0c2b00030197  cmpi.b #$3, $197(a3)
        cmpi.b #$3, $197(a3)
L070_00000858:
; H070+$00000858: 67000010  beq.w $86a
        beq.w H070+$86A
L070_0000085C:
; H070+$0000085C: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000860:
; H070+$00000860: 0c2b00050197  cmpi.b #$5, $197(a3)
        cmpi.b #$5, $197(a3)
L070_00000866:
; H070+$00000866: 66000008  bne.w $870
        bne.w H070+$870
L070_0000086A:
; H070+$0000086A: 1b7c0001ffe1  move.b #$1, -$1f(a5)
        move.b #$1, -$1f(a5)
L070_00000870:
; H070+$00000870: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000874:
; H070+$00000874: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L070_0000087A:
; H070+$0000087A: 60a8  bra.b $824
        bra.b H070+$824
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_0000087C:
; H070+$0000087C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000882:
; H070+$00000882: 4a6b05cc  tst.w $5cc(a3)
        tst.w $5cc(a3)
L070_00000886:
; H070+$00000886: 67000010  beq.w $898
        beq.w H070+$898
L070_0000088A:
; H070+$0000088A: 4a2dffe1  tst.b -$1f(a5)
        tst.b -$1f(a5)
L070_0000088E:
; H070+$0000088E: 67000008  beq.w $898
        beq.w H070+$898
; STATO: H005+$24D0 = richiesta di uscita dal ciclo scenario
L070_00000892:
; H070+$00000892: 4239000024d0  clr.b $24d0.l
        clr.b (H005+$24D0).l
L070_00000898:
; H070+$00000898: 4239000024c0  clr.b $24c0.l
        clr.b (H005+$24C0).l
; STATO: H005+$3364 = testa della lista del party
L070_0000089E:
; H070+$0000089E: 2b7900003364ffe6  move.l $3364.l, -$1a(a5)
        move.l (H005+$3364).l, -$1a(a5)
; STATO: H005+$24D7 = flag del ramo demo
L070_000008A6:
; H070+$000008A6: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L070_000008AC:
; H070+$000008AC: 660002ea  bne.w $b98
        bne.w H070+$B98
L070_000008B0:
; H070+$000008B0: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L070_000008B4:
; H070+$000008B4: 670000f0  beq.w $9a6
        beq.w H070+$9A6
L070_000008B8:
; H070+$000008B8: 246dffe6  movea.l -$1a(a5), a2
        movea.l -$1a(a5), a2
L070_000008BC:
; H070+$000008BC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_000008C0:
; H070+$000008C0: 0c2b00010015  cmpi.b #$1, $15(a3)
        cmpi.b #$1, $15(a3)
L070_000008C6:
; H070+$000008C6: 670000de  beq.w $9a6
        beq.w H070+$9A6
L070_000008CA:
; H070+$000008CA: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_000008CE:
; H070+$000008CE: 0c2b00030197  cmpi.b #$3, $197(a3)
        cmpi.b #$3, $197(a3)
L070_000008D4:
; H070+$000008D4: 6700001c  beq.w $8f2
        beq.w H070+$8F2
L070_000008D8:
; H070+$000008D8: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_000008DC:
; H070+$000008DC: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L070_000008E2:
; H070+$000008E2: 6700000e  beq.w $8f2
        beq.w H070+$8F2
L070_000008E6:
; H070+$000008E6: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_000008EA:
; H070+$000008EA: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L070_000008EE:
; H070+$000008EE: 66000026  bne.w $916
        bne.w H070+$916
L070_000008F2:
; H070+$000008F2: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_000008F6:
; H070+$000008F6: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L070_000008FA:
; H070+$000008FA: 6600001a  bne.w $916
        bne.w H070+$916
L070_000008FE:
; H070+$000008FE: 7400  moveq #$0, d2
        moveq #0, d2
L070_00000900:
; H070+$00000900: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000904:
; H070+$00000904: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L070_00000908:
; H070+$00000908: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L070_0000090C:
; H070+$0000090C: 64000008  bcc.w $916
        bcc.w H070+$916
; STATO: H005+$24D0 = richiesta di uscita dal ciclo scenario
L070_00000910:
; H070+$00000910: 4239000024d0  clr.b $24d0.l
        clr.b (H005+$24D0).l
L070_00000916:
; H070+$00000916: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_0000091A:
; H070+$0000091A: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L070_00000920:
; H070+$00000920: 6700000e  beq.w $930
        beq.w H070+$930
L070_00000924:
; H070+$00000924: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000928:
; H070+$00000928: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L070_0000092C:
; H070+$0000092C: 6600000e  bne.w $93c
        bne.w H070+$93C
L070_00000930:
; H070+$00000930: 13fc0001000024c0  move.b #$1, $24c0.l
        move.b #$1, (H005+$24C0).l
L070_00000938:
; H070+$00000938: 422cfffe  clr.b -$2(a4)
        clr.b -$2(a4)
L070_0000093C:
; H070+$0000093C: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000940:
; H070+$00000940: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L070_00000944:
; H070+$00000944: 67000010  beq.w $956
        beq.w H070+$956
L070_00000948:
; H070+$00000948: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_0000094C:
; H070+$0000094C: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L070_00000952:
; H070+$00000952: 66000012  bne.w $966
        bne.w H070+$966
L070_00000956:
; H070+$00000956: 487900002499  pea.l $2499.l
        pea.l (H005+$2499).l
L070_0000095C:
; H070+$0000095C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L070_00000960:
; H070+$00000960: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L070_00000966:
; H070+$00000966: 3b7c0001ffe2  move.w #$1, -$1e(a5)
        move.w #$1, -$1e(a5)
L070_0000096C:
; H070+$0000096C: 0c6d000bffe2  cmpi.w #$b, -$1e(a5)
        cmpi.w #$b, -$1e(a5)
L070_00000972:
; H070+$00000972: 62000024  bhi.w $998
        bhi.w H070+$998
L070_00000976:
; H070+$00000976: 2f2dffe6  move.l -$1a(a5), -(a7)
        move.l -$1a(a5), -(a7)
L070_0000097A:
; H070+$0000097A: 342dffe2  move.w -$1e(a5), d2
        move.w -$1e(a5), d2
L070_0000097E:
; H070+$0000097E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L070_00000980:
; H070+$00000980: e342  asl.w #$1, d2
        asl.w #$1, d2
L070_00000982:
; H070+$00000982: 47edffea  lea.l -$16(a5), a3
        lea.l -$16(a5), a3
L070_00000986:
; H070+$00000986: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L070_0000098A:
; H070+$0000098A: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H062+$0452 (sub_H062_00000452)
L070_0000098C:
; H070+$0000098C: 4eb900000452  jsr $452.l
        jsr (H062+$452).l
L070_00000992:
; H070+$00000992: 526dffe2  addq.w #$1, -$1e(a5)
        addq.w #$1, -$1e(a5)
L070_00000996:
; H070+$00000996: 64d4  bcc.b $96c
        bcc.b H070+$96C
L070_00000998:
; H070+$00000998: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_0000099C:
; H070+$0000099C: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L070_000009A2:
; H070+$000009A2: 6000ff0c  bra.w $8b0
        bra.w H070+$8B0
L070_000009A6:
; H070+$000009A6: 4a39000024c0  tst.b $24c0.l
        tst.b (H005+$24C0).l
L070_000009AC:
; H070+$000009AC: 67000016  beq.w $9c4
        beq.w H070+$9C4
L070_000009B0:
; H070+$000009B0: 48790000236e  pea.l $236e.l
        pea.l (H005+$236E).l
L070_000009B6:
; H070+$000009B6: 6100f8c8  bsr.w $280
        bsr.w H070+$280
L070_000009BA:
; H070+$000009BA: 2f390000236e  move.l $236e.l, -(a7)
        move.l (H005+$236E).l, -(a7)
L070_000009C0:
; H070+$000009C0: 6100fb96  bsr.w $558
        bsr.w H070+$558
; STATO: H005+$3364 = testa della lista del party
L070_000009C4:
; H070+$000009C4: 2b7900003364ffe6  move.l $3364.l, -$1a(a5)
        move.l (H005+$3364).l, -$1a(a5)
; STATO: H005+$24D0 = richiesta di uscita dal ciclo scenario
L070_000009CC:
; H070+$000009CC: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L070_000009D2:
; H070+$000009D2: 66000162  bne.w $b36
        bne.w H070+$B36
L070_000009D6:
; H070+$000009D6: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L070_000009DA:
; H070+$000009DA: 67000156  beq.w $b32
        beq.w H070+$B32
L070_000009DE:
; H070+$000009DE: 246dffe6  movea.l -$1a(a5), a2
        movea.l -$1a(a5), a2
L070_000009E2:
; H070+$000009E2: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_000009E6:
; H070+$000009E6: 0c2b00010015  cmpi.b #$1, $15(a3)
        cmpi.b #$1, $15(a3)
L070_000009EC:
; H070+$000009EC: 67000144  beq.w $b32
        beq.w H070+$B32
L070_000009F0:
; H070+$000009F0: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L070_000009F4:
; H070+$000009F4: 660000e0  bne.w $ad6
        bne.w H070+$AD6
L070_000009F8:
; H070+$000009F8: 7400  moveq #$0, d2
        moveq #0, d2
L070_000009FA:
; H070+$000009FA: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_000009FE:
; H070+$000009FE: 142b0197  move.b $197(a3), d2
        move.b $197(a3), d2
L070_00000A02:
; H070+$00000A02: 600000ac  bra.w $ab0
        bra.w H070+$AB0
L070_00000A06:
; H070+$00000A06: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A0A:
; H070+$00000A0A: 422b0197  clr.b $197(a3)
        clr.b $197(a3)
L070_00000A0E:
; H070+$00000A0E: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A12:
; H070+$00000A12: 177c00010198  move.b #$1, $198(a3)
        move.b #$1, $198(a3)
L070_00000A18:
; H070+$00000A18: 4e75  rts 
        rts 
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00000A1A:
; H070+$00000A1A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000A20:
; H070+$00000A20: 4a6b05cc  tst.w $5cc(a3)
        tst.w $5cc(a3)
L070_00000A24:
; H070+$00000A24: 67000022  beq.w $a48
        beq.w H070+$A48
L070_00000A28:
; H070+$00000A28: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A2C:
; H070+$00000A2C: 422b0197  clr.b $197(a3)
        clr.b $197(a3)
L070_00000A30:
; H070+$00000A30: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A34:
; H070+$00000A34: 177c00010198  move.b #$1, $198(a3)
        move.b #$1, $198(a3)
L070_00000A3A:
; H070+$00000A3A: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A3E:
; H070+$00000A3E: 177c000101a8  move.b #$1, $1a8(a3)
        move.b #$1, $1a8(a3)
L070_00000A44:
; H070+$00000A44: 6000000c  bra.w $a52
        bra.w H070+$A52
L070_00000A48:
; H070+$00000A48: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A4C:
; H070+$00000A4C: 177c00040197  move.b #$4, $197(a3)
        move.b #$4, $197(a3)
L070_00000A52:
; H070+$00000A52: 4e75  rts 
        rts 
L070_00000A54:
; H070+$00000A54: 7400  moveq #$0, d2
        moveq #0, d2
L070_00000A56:
; H070+$00000A56: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A5A:
; H070+$00000A5A: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L070_00000A5E:
; H070+$00000A5E: 4a42  tst.w d2
        tst.w d2
L070_00000A60:
; H070+$00000A60: 63000018  bls.w $a7a
        bls.w H070+$A7A
L070_00000A64:
; H070+$00000A64: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A68:
; H070+$00000A68: 422b0197  clr.b $197(a3)
        clr.b $197(a3)
L070_00000A6C:
; H070+$00000A6C: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A70:
; H070+$00000A70: 177c00010198  move.b #$1, $198(a3)
        move.b #$1, $198(a3)
L070_00000A76:
; H070+$00000A76: 6000002c  bra.w $aa4
        bra.w H070+$AA4
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00000A7A:
; H070+$00000A7A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000A80:
; H070+$00000A80: 4a6b05cc  tst.w $5cc(a3)
        tst.w $5cc(a3)
L070_00000A84:
; H070+$00000A84: 6700001e  beq.w $aa4
        beq.w H070+$AA4
L070_00000A88:
; H070+$00000A88: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A8C:
; H070+$00000A8C: 422b0197  clr.b $197(a3)
        clr.b $197(a3)
L070_00000A90:
; H070+$00000A90: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A94:
; H070+$00000A94: 177c00010198  move.b #$1, $198(a3)
        move.b #$1, $198(a3)
L070_00000A9A:
; H070+$00000A9A: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000A9E:
; H070+$00000A9E: 177c000101a8  move.b #$1, $1a8(a3)
        move.b #$1, $1a8(a3)
L070_00000AA4:
; H070+$00000AA4: 4e75  rts 
        rts 
L070_00000AA6:
; H070+$00000AA6: 4e75  rts 
        rts 
; Preserved bytes H070+$00000AA8..$00000AB0; code/data not fully classified.
        dc.w $FFFC,$FF5C,$FFAA,$FF70
L070_00000AB0:
; H070+$00000AB0: 47fafff8  lea.l $aaa(pc), a3
        lea.l H070+$AAA(pc), a3
L070_00000AB4:
; H070+$00000AB4: 5742  subq.w #$3, d2
        subq.w #$3, d2
L070_00000AB6:
; H070+$00000AB6: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L070_00000ABA:
; H070+$00000ABA: 6302  bls.b $abe
        bls.b H070+$ABE
L070_00000ABC:
; H070+$00000ABC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L070_00000ABE:
; H070+$00000ABE: e342  asl.w #$1, d2
        asl.w #$1, d2
L070_00000AC0:
; H070+$00000AC0: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H070+$0AAA; indici 0..2, default -1.
L070_00000AC4:
; H070+$00000AC4: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L070_00000AC8:
; H070+$00000AC8: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000ACC:
; H070+$00000ACC: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L070_00000AD2:
; H070+$00000AD2: 6000005a  bra.w $b2e
        bra.w H070+$B2E
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00000AD6:
; H070+$00000AD6: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000ADC:
; H070+$00000ADC: 377c0081058e  move.w #$81, $58e(a3)
        move.w #$81, $58e(a3)
L070_00000AE2:
; H070+$00000AE2: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000AE6:
; H070+$00000AE6: 0c2b00030197  cmpi.b #$3, $197(a3)
        cmpi.b #$3, $197(a3)
L070_00000AEC:
; H070+$00000AEC: 66000022  bne.w $b10
        bne.w H070+$B10
L070_00000AF0:
; H070+$00000AF0: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000AF4:
; H070+$00000AF4: 422b0197  clr.b $197(a3)
        clr.b $197(a3)
L070_00000AF8:
; H070+$00000AF8: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000AFC:
; H070+$00000AFC: 177c00010198  move.b #$1, $198(a3)
        move.b #$1, $198(a3)
L070_00000B02:
; H070+$00000B02: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000B06:
; H070+$00000B06: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L070_00000B0C:
; H070+$00000B0C: 60000020  bra.w $b2e
        bra.w H070+$B2E
; STATO: H005+$3368 = personaggio corrente
L070_00000B10:
; H070+$00000B10: 23edffe600003368  move.l -$1a(a5), $3368.l
        move.l -$1a(a5), (H005+$3368).l
L070_00000B18:
; H070+$00000B18: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000B1C:
; H070+$00000B1C: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L070_00000B22:
; H070+$00000B22: 4227  clr.b -(a7)
        clr.b -(a7)
L070_00000B24:
; H070+$00000B24: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H053+$00CA (trampoline_H053_01E8)
L070_00000B28:
; H070+$00000B28: 4eb9000000ca  jsr $ca.l
        jsr (H053+$CA).l
L070_00000B2E:
; H070+$00000B2E: 6000fea6  bra.w $9d6
        bra.w H070+$9D6
L070_00000B32:
; H070+$00000B32: 60000064  bra.w $b98
        bra.w H070+$B98
; STATO: H005+$3364 = testa della lista del party
L070_00000B36:
; H070+$00000B36: 2b7900003364ffe6  move.l $3364.l, -$1a(a5)
        move.l (H005+$3364).l, -$1a(a5)
L070_00000B3E:
; H070+$00000B3E: 422dffe5  clr.b -$1b(a5)
        clr.b -$1b(a5)
L070_00000B42:
; H070+$00000B42: 4aadffe6  tst.l -$1a(a5)
        tst.l -$1a(a5)
L070_00000B46:
; H070+$00000B46: 67000046  beq.w $b8e
        beq.w H070+$B8E
L070_00000B4A:
; H070+$00000B4A: 4a2dffe5  tst.b -$1b(a5)
        tst.b -$1b(a5)
L070_00000B4E:
; H070+$00000B4E: 6600003e  bne.w $b8e
        bne.w H070+$B8E
L070_00000B52:
; H070+$00000B52: 246dffe6  movea.l -$1a(a5), a2
        movea.l -$1a(a5), a2
L070_00000B56:
; H070+$00000B56: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_00000B5A:
; H070+$00000B5A: 0c2b00010015  cmpi.b #$1, $15(a3)
        cmpi.b #$1, $15(a3)
L070_00000B60:
; H070+$00000B60: 6700001a  beq.w $b7c
        beq.w H070+$B7C
; STATO: H005+$3368 = personaggio corrente
L070_00000B64:
; H070+$00000B64: 23edffe600003368  move.l -$1a(a5), $3368.l
        move.l -$1a(a5), (H005+$3368).l
L070_00000B6C:
; H070+$00000B6C: 4227  clr.b -(a7)
        clr.b -(a7)
L070_00000B6E:
; H070+$00000B6E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H053+$00CA (trampoline_H053_01E8)
L070_00000B72:
; H070+$00000B72: 4eb9000000ca  jsr $ca.l
        jsr (H053+$CA).l
L070_00000B78:
; H070+$00000B78: 60000008  bra.w $b82
        bra.w H070+$B82
L070_00000B7C:
; H070+$00000B7C: 1b7c0001ffe5  move.b #$1, -$1b(a5)
        move.b #$1, -$1b(a5)
L070_00000B82:
; H070+$00000B82: 266dffe6  movea.l -$1a(a5), a3
        movea.l -$1a(a5), a3
L070_00000B86:
; H070+$00000B86: 2b6b018effe6  move.l $18e(a3), -$1a(a5)
        move.l $18e(a3), -$1a(a5)
L070_00000B8C:
; H070+$00000B8C: 60b4  bra.b $b42
        bra.b H070+$B42
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00000B8E:
; H070+$00000B8E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000B94:
; H070+$00000B94: 426b067c  clr.w $67c(a3)
        clr.w $67c(a3)
L070_00000B98:
; H070+$00000B98: 4e5d  unlk a5
        unlk a5
L070_00000B9A:
; H070+$00000B9A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00000B9C:
; H070+$00000B9C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00000B9E [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H044+$01C2, H030+$0256, H003+$00F6, H029+$0312.
;   - Richiama H044+$01C2.
;   - Richiama H030+$0256.
;   - Richiama H003+$00F6.
;   - Richiama H029+$0312.
;   - Richiama H045+$01D6.
;   - Richiama H063+$0112.
;   - Richiama H026+$01E0.
;   - Usa lo stato globale: H005+$3E00 (puntatore stato persistente B, 2048 byte); H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H070+$1A28
; --------------------------------------------------------------------------
L070_00000B9E:
; H070+$00000B9E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00000BA0:
; H070+$00000BA0: 287af6cc  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00000BA4:
; H070+$00000BA4: 4e55ff92  link.w a5, #$ff92
        link.w a5, #$ff92
L070_00000BA8:
; H070+$00000BA8: 47ec0023  lea.l $23(a4), a3
        lea.l $23(a4), a3
L070_00000BAC:
; H070+$00000BAC: 45edff9c  lea.l -$64(a5), a2
        lea.l -$64(a5), a2
L070_00000BB0:
; H070+$00000BB0: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_00000BB2:
; H070+$00000BB2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_00000BB4:
; H070+$00000BB4: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_00000BB6:
; H070+$00000BB6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L070_00000BBA:
; H070+$00000BBA: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
L070_00000BC0:
; H070+$00000BC0: 4a2cffff  tst.b -$1(a4)
        tst.b -$1(a4)
L070_00000BC4:
; H070+$00000BC4: 670000e0  beq.w $ca6
        beq.w H070+$CA6
L070_00000BC8:
; H070+$00000BC8: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L070_00000BCC:
; H070+$00000BCC: 6700006e  beq.w $c3c
        beq.w H070+$C3C
L070_00000BD0:
; H070+$00000BD0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000BD4:
; H070+$00000BD4: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L070_00000BD8:
; H070+$00000BD8: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000BDC:
; H070+$00000BDC: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000BDE:
; H070+$00000BDE: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L070_00000BE2:
; H070+$00000BE2: 486c0025  pea.l $25(a4)
        pea.l $25(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000BE6:
; H070+$00000BE6: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000BEC:
; H070+$00000BEC: 7400  moveq #$0, d2
        moveq #0, d2
L070_00000BEE:
; H070+$00000BEE: 2b42000c  move.l d2, $c(a5)
        move.l d2, $c(a5)
L070_00000BF2:
; H070+$00000BF2: 2b7900002a3aff96  move.l $2a3a.l, -$6a(a5)
        move.l (H005+$2A3A).l, -$6a(a5)
L070_00000BFA:
; H070+$00000BFA: 4aadff96  tst.l -$6a(a5)
        tst.l -$6a(a5)
L070_00000BFE:
; H070+$00000BFE: 67000022  beq.w $c22
        beq.w H070+$C22
L070_00000C02:
; H070+$00000C02: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L070_00000C06:
; H070+$00000C06: 2b6b002cff92  move.l $2c(a3), -$6e(a5)
        move.l $2c(a3), -$6e(a5)
L070_00000C0C:
; H070+$00000C0C: 2f2dff96  move.l -$6a(a5), -(a7)
        move.l -$6a(a5), -(a7)
L070_00000C10:
; H070+$00000C10: 7448  moveq #$48, d2
        moveq #72, d2
L070_00000C12:
; H070+$00000C12: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L070_00000C14:
; H070+$00000C14: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L070_00000C1A:
; H070+$00000C1A: 2b6dff92ff96  move.l -$6e(a5), -$6a(a5)
        move.l -$6e(a5), -$6a(a5)
L070_00000C20:
; H070+$00000C20: 60d8  bra.b $bfa
        bra.b H070+$BFA
L070_00000C22:
; H070+$00000C22: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L070_00000C26:
; H070+$00000C26: 487900002a1e  pea.l $2a1e.l
        pea.l (H005+$2A1E).l
L070_00000C2C:
; H070+$00000C2C: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L070_00000C30:
; H070+$00000C30: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L070_00000C32:
; H070+$00000C32: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L070_00000C38:
; H070+$00000C38: 60000068  bra.w $ca2
        bra.w H070+$CA2
L070_00000C3C:
; H070+$00000C3C: 4a39000024c0  tst.b $24c0.l
        tst.b (H005+$24C0).l
L070_00000C42:
; H070+$00000C42: 66000042  bne.w $c86
        bne.w H070+$C86
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00000C46:
; H070+$00000C46: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000C4C:
; H070+$00000C4C: 4a6b05cc  tst.w $5cc(a3)
        tst.w $5cc(a3)
L070_00000C50:
; H070+$00000C50: 67000034  beq.w $c86
        beq.w H070+$C86
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00000C54:
; H070+$00000C54: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00000C5A:
; H070+$00000C5A: 377c0080058e  move.w #$80, $58e(a3)
        move.w #$80, $58e(a3)
L070_00000C60:
; H070+$00000C60: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000C64:
; H070+$00000C64: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L070_00000C68:
; H070+$00000C68: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000C6C:
; H070+$00000C6C: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000C6E:
; H070+$00000C6E: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L070_00000C72:
; H070+$00000C72: 486c0039  pea.l $39(a4)
        pea.l $39(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000C76:
; H070+$00000C76: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000C7C:
; H070+$00000C7C: 7400  moveq #$0, d2
        moveq #0, d2
L070_00000C7E:
; H070+$00000C7E: 2b42000c  move.l d2, $c(a5)
        move.l d2, $c(a5)
L070_00000C82:
; H070+$00000C82: 6000001e  bra.w $ca2
        bra.w H070+$CA2
L070_00000C86:
; H070+$00000C86: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000C8A:
; H070+$00000C8A: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L070_00000C8E:
; H070+$00000C8E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000C92:
; H070+$00000C92: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000C94:
; H070+$00000C94: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L070_00000C98:
; H070+$00000C98: 486c0052  pea.l $52(a4)
        pea.l $52(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000C9C:
; H070+$00000C9C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000CA2:
; H070+$00000CA2: 60000068  bra.w $d0c
        bra.w H070+$D0C
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L070_00000CA6:
; H070+$00000CA6: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L070_00000CAC:
; H070+$00000CAC: 4a6b03ea  tst.w $3ea(a3)
        tst.w $3ea(a3)
L070_00000CB0:
; H070+$00000CB0: 6700003e  beq.w $cf0
        beq.w H070+$CF0
L070_00000CB4:
; H070+$00000CB4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000CB8:
; H070+$00000CB8: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L070_00000CBC:
; H070+$00000CBC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000CC0:
; H070+$00000CC0: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000CC2:
; H070+$00000CC2: 3f3c0025  move.w #$25, -(a7)
        move.w #$25, -(a7)
L070_00000CC6:
; H070+$00000CC6: 486c0065  pea.l $65(a4)
        pea.l $65(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000CCA:
; H070+$00000CCA: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000CD0:
; H070+$00000CD0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000CD4:
; H070+$00000CD4: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L070_00000CD8:
; H070+$00000CD8: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000CDC:
; H070+$00000CDC: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000CDE:
; H070+$00000CDE: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L070_00000CE2:
; H070+$00000CE2: 486c008b  pea.l $8b(a4)
        pea.l $8b(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000CE6:
; H070+$00000CE6: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000CEC:
; H070+$00000CEC: 6000001e  bra.w $d0c
        bra.w H070+$D0C
L070_00000CF0:
; H070+$00000CF0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000CF4:
; H070+$00000CF4: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L070_00000CF8:
; H070+$00000CF8: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000CFC:
; H070+$00000CFC: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000CFE:
; H070+$00000CFE: 3f3c001d  move.w #$1d, -(a7)
        move.w #$1d, -(a7)
L070_00000D02:
; H070+$00000D02: 486c00ae  pea.l $ae(a4)
        pea.l $ae(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000D06:
; H070+$00000D06: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000D0C:
; H070+$00000D0C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000D10:
; H070+$00000D10: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
L070_00000D14:
; H070+$00000D14: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L070_00000D18:
; H070+$00000D18: 4227  clr.b -(a7)
        clr.b -(a7)
L070_00000D1A:
; H070+$00000D1A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000D1E:
; H070+$00000D1E: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L070_00000D22:
; H070+$00000D22: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L070_00000D26:
; H070+$00000D26: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L070_00000D2C:
; H070+$00000D2C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000D30:
; H070+$00000D30: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; -> H063+$0112 (sub_H063_00000112)
L070_00000D34:
; H070+$00000D34: 4eb900000112  jsr $112.l
        jsr (H063+$112).l
L070_00000D3A:
; H070+$00000D3A: 47ec00cc  lea.l $cc(a4), a3
        lea.l $cc(a4), a3
L070_00000D3E:
; H070+$00000D3E: 45edffa2  lea.l -$5e(a5), a2
        lea.l -$5e(a5), a2
L070_00000D42:
; H070+$00000D42: 7450  moveq #$50, d2
        moveq #80, d2
L070_00000D44:
; H070+$00000D44: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_00000D46:
; H070+$00000D46: 57cafffc  dbeq d2, $d44
        dbeq d2, H070+$D44
L070_00000D4A:
; H070+$00000D4A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_00000D4E:
; H070+$00000D4E: 486dffa2  pea.l -$5e(a5)
        pea.l -$5e(a5)
L070_00000D52:
; H070+$00000D52: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000D56:
; H070+$00000D56: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L070_00000D5A:
; H070+$00000D5A: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L070_00000D60:
; H070+$00000D60: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L070_00000D66:
; H070+$00000D66: 4a6b03ea  tst.w $3ea(a3)
        tst.w $3ea(a3)
L070_00000D6A:
; H070+$00000D6A: 6600003a  bne.w $da6
        bne.w H070+$DA6
L070_00000D6E:
; H070+$00000D6E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000D72:
; H070+$00000D72: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L070_00000D76:
; H070+$00000D76: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000D7A:
; H070+$00000D7A: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000D7C:
; H070+$00000D7C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_00000D80:
; H070+$00000D80: 486dffa2  pea.l -$5e(a5)
        pea.l -$5e(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000D84:
; H070+$00000D84: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000D8A:
; H070+$00000D8A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000D8E:
; H070+$00000D8E: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L070_00000D92:
; H070+$00000D92: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000D96:
; H070+$00000D96: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000D98:
; H070+$00000D98: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L070_00000D9C:
; H070+$00000D9C: 486c00e5  pea.l $e5(a4)
        pea.l $e5(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L070_00000DA0:
; H070+$00000DA0: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L070_00000DA6:
; H070+$00000DA6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L070_00000DAA:
; H070+$00000DAA: 486dff9c  pea.l -$64(a5)
        pea.l -$64(a5)
L070_00000DAE:
; H070+$00000DAE: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L070_00000DB2:
; H070+$00000DB2: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L070_00000DB6:
; H070+$00000DB6: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_00000DBA:
; H070+$00000DBA: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_00000DBE:
; H070+$00000DBE: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_00000DC2:
; H070+$00000DC2: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_00000DC6:
; H070+$00000DC6: 4227  clr.b -(a7)
        clr.b -(a7)
L070_00000DC8:
; H070+$00000DC8: 486dff9b  pea.l -$65(a5)
        pea.l -$65(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L070_00000DCC:
; H070+$00000DCC: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L070_00000DD2:
; H070+$00000DD2: 1b40ffa1  move.b d0, -$5f(a5)
        move.b d0, -$5f(a5)
L070_00000DD6:
; H070+$00000DD6: 4e5d  unlk a5
        unlk a5
L070_00000DD8:
; H070+$00000DD8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00000DDA:
; H070+$00000DDA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L070_00000DDC:
; H070+$00000DDC: 588f  addq.l #$4, a7
        addq.l #$4, a7
L070_00000DDE:
; H070+$00000DDE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00000DE0 [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H044+$01C2, H063+$09B2, H008+$13C0.
;   - Richiama H044+$01C2.
;   - Richiama H063+$09B2.
;   - Richiama H008+$13C0.
; Chiamanti diretti: H070+$0EBE
; --------------------------------------------------------------------------
L070_00000DE0:
; H070+$00000DE0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00000DE2:
; H070+$00000DE2: 287af48a  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00000DE6:
; H070+$00000DE6: 4e55ffe0  link.w a5, #$ffe0
        link.w a5, #$ffe0
L070_00000DEA:
; H070+$00000DEA: 1b7c0001ffe5  move.b #$1, -$1b(a5)
        move.b #$1, -$1b(a5)
L070_00000DF0:
; H070+$00000DF0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L070_00000DF4:
; H070+$00000DF4: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
L070_00000DFA:
; H070+$00000DFA: 2b7900002a3affe0  move.l $2a3a.l, -$20(a5)
        move.l (H005+$2A3A).l, -$20(a5)
L070_00000E02:
; H070+$00000E02: 4aadffe0  tst.l -$20(a5)
        tst.l -$20(a5)
L070_00000E06:
; H070+$00000E06: 67000022  beq.w $e2a
        beq.w H070+$E2A
L070_00000E0A:
; H070+$00000E0A: 42a7  clr.l -(a7)
        clr.l -(a7)
L070_00000E0C:
; H070+$00000E0C: 2f2dffe0  move.l -$20(a5), -(a7)
        move.l -$20(a5), -(a7)
L070_00000E10:
; H070+$00000E10: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000E12:
; H070+$00000E12: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00000E14:
; H070+$00000E14: 4227  clr.b -(a7)
        clr.b -(a7)
L070_00000E16:
; H070+$00000E16: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$09B2 (sub_H063_000009B2)
L070_00000E18:
; H070+$00000E18: 4eb9000009b2  jsr $9b2.l
        jsr (H063+$9B2).l
L070_00000E1E:
; H070+$00000E1E: 266dffe0  movea.l -$20(a5), a3
        movea.l -$20(a5), a3
L070_00000E22:
; H070+$00000E22: 2b6b002cffe0  move.l $2c(a3), -$20(a5)
        move.l $2c(a3), -$20(a5)
L070_00000E28:
; H070+$00000E28: 60d8  bra.b $e02
        bra.b H070+$E02
L070_00000E2A:
; H070+$00000E2A: 2b7900002a3afffc  move.l $2a3a.l, -$4(a5)
        move.l (H005+$2A3A).l, -$4(a5)
L070_00000E32:
; H070+$00000E32: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L070_00000E36:
; H070+$00000E36: 486c00f8  pea.l $f8(a4)
        pea.l $f8(a4)
L070_00000E3A:
; H070+$00000E3A: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L070_00000E3E:
; H070+$00000E3E: 486c0100  pea.l $100(a4)
        pea.l $100(a4)
L070_00000E42:
; H070+$00000E42: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L070_00000E46:
; H070+$00000E46: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000E4A:
; H070+$00000E4A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_00000E4E:
; H070+$00000E4E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000E52:
; H070+$00000E52: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00000E56:
; H070+$00000E56: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L070_00000E5A:
; H070+$00000E5A: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L070_00000E5E:
; H070+$00000E5E: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L070_00000E62:
; H070+$00000E62: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_00000E66:
; H070+$00000E66: 486dffe5  pea.l -$1b(a5)
        pea.l -$1b(a5)
L070_00000E6A:
; H070+$00000E6A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L070_00000E6E:
; H070+$00000E6E: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H008+$13C0 (trampoline_H008_1AF4)
L070_00000E72:
; H070+$00000E72: 4eb9000013c0  jsr $13c0.l
        jsr (H008+$13C0).l
L070_00000E78:
; H070+$00000E78: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L070_00000E7C:
; H070+$00000E7C: 1680  move.b d0, (a3)
        move.b d0, (a3)
L070_00000E7E:
; H070+$00000E7E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L070_00000E82:
; H070+$00000E82: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L070_00000E86:
; H070+$00000E86: 2493  move.l (a3), (a2)
        move.l (a3), (a2)
L070_00000E88:
; H070+$00000E88: 4e5d  unlk a5
        unlk a5
L070_00000E8A:
; H070+$00000E8A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00000E8C:
; H070+$00000E8C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L070_00000E8E:
; H070+$00000E8E: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L070_00000E92:
; H070+$00000E92: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00000E94 [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H071+$047C, H003+$00F6, H063+$321A.
;   - Richiama H071+$047C.
;   - Richiama H003+$00F6.
;   - Richiama H063+$321A.
; Chiamanti diretti: H070+$1128, H070+$0FF6
; --------------------------------------------------------------------------
L070_00000E94:
; H070+$00000E94: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00000E96:
; H070+$00000E96: 287af3d6  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00000E9A:
; H070+$00000E9A: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L070_00000E9E:
; H070+$00000E9E: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L070_00000EA2:
; H070+$00000EA2: 2b7900002a3afff2  move.l $2a3a.l, -$e(a5)
        move.l (H005+$2A3A).l, -$e(a5)
L070_00000EAA:
; H070+$00000EAA: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L070_00000EAE:
; H070+$00000EAE: 486dfff7  pea.l -$9(a5)
        pea.l -$9(a5)
L070_00000EB2:
; H070+$00000EB2: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
L070_00000EB6:
; H070+$00000EB6: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
L070_00000EBA:
; H070+$00000EBA: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
L070_00000EBE:
; H070+$00000EBE: 6100ff20  bsr.w $de0
        bsr.w H070+$DE0
L070_00000EC2:
; H070+$00000EC2: 0c2d0054fff7  cmpi.b #$54, -$9(a5)
        cmpi.b #$54, -$9(a5)
L070_00000EC8:
; H070+$00000EC8: 67000016  beq.w $ee0
        beq.w H070+$EE0
L070_00000ECC:
; H070+$00000ECC: 0c2d000dfff7  cmpi.b #$d, -$9(a5)
        cmpi.b #$d, -$9(a5)
L070_00000ED2:
; H070+$00000ED2: 6700000c  beq.w $ee0
        beq.w H070+$EE0
L070_00000ED6:
; H070+$00000ED6: 1b7c0001fff6  move.b #$1, -$a(a5)
        move.b #$1, -$a(a5)
L070_00000EDC:
; H070+$00000EDC: 60000098  bra.w $f76
        bra.w H070+$F76
L070_00000EE0:
; H070+$00000EE0: 422dfff6  clr.b -$a(a5)
        clr.b -$a(a5)
L070_00000EE4:
; H070+$00000EE4: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L070_00000EE8:
; H070+$00000EE8: 486dffef  pea.l -$11(a5)
        pea.l -$11(a5)
; -> H071+$047C (sub_H071_0000047C)
L070_00000EEC:
; H070+$00000EEC: 4eb90000047c  jsr $47c.l
        jsr (H071+$47C).l
L070_00000EF2:
; H070+$00000EF2: 4a2dffef  tst.b -$11(a5)
        tst.b -$11(a5)
L070_00000EF6:
; H070+$00000EF6: 6600007e  bne.w $f76
        bne.w H070+$F76
L070_00000EFA:
; H070+$00000EFA: 2b7900002a3afff8  move.l $2a3a.l, -$8(a5)
        move.l (H005+$2A3A).l, -$8(a5)
L070_00000F02:
; H070+$00000F02: 242dfff8  move.l -$8(a5), d2
        move.l -$8(a5), d2
L070_00000F06:
; H070+$00000F06: b4adfffc  cmp.l -$4(a5), d2
        cmp.l -$4(a5), d2
L070_00000F0A:
; H070+$00000F0A: 66000012  bne.w $f1e
        bne.w H070+$F1E
L070_00000F0E:
; H070+$00000F0E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000F12:
; H070+$00000F12: 23eb002c00002a3a  move.l $2c(a3), $2a3a.l
        move.l $2c(a3), (H005+$2A3A).l
L070_00000F1A:
; H070+$00000F1A: 6000002c  bra.w $f48
        bra.w H070+$F48
L070_00000F1E:
; H070+$00000F1E: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L070_00000F22:
; H070+$00000F22: 242b002c  move.l $2c(a3), d2
        move.l $2c(a3), d2
L070_00000F26:
; H070+$00000F26: b4adfffc  cmp.l -$4(a5), d2
        cmp.l -$4(a5), d2
L070_00000F2A:
; H070+$00000F2A: 6700000e  beq.w $f3a
        beq.w H070+$F3A
L070_00000F2E:
; H070+$00000F2E: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L070_00000F32:
; H070+$00000F32: 2b6b002cfff8  move.l $2c(a3), -$8(a5)
        move.l $2c(a3), -$8(a5)
L070_00000F38:
; H070+$00000F38: 60e4  bra.b $f1e
        bra.b H070+$F1E
L070_00000F3A:
; H070+$00000F3A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000F3E:
; H070+$00000F3E: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L070_00000F42:
; H070+$00000F42: 256b002c002c  move.l $2c(a3), $2c(a2)
        move.l $2c(a3), $2c(a2)
L070_00000F48:
; H070+$00000F48: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00000F4C:
; H070+$00000F4C: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L070_00000F50:
; H070+$00000F50: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_00000F54:
; H070+$00000F54: 67000010  beq.w $f66
        beq.w H070+$F66
L070_00000F58:
; H070+$00000F58: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L070_00000F5C:
; H070+$00000F5C: 7448  moveq #$48, d2
        moveq #72, d2
L070_00000F5E:
; H070+$00000F5E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L070_00000F60:
; H070+$00000F60: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L070_00000F66:
; H070+$00000F66: 4ab900002a3a  tst.l $2a3a.l
        tst.l (H005+$2A3A).l
L070_00000F6C:
; H070+$00000F6C: 66000008  bne.w $f76
        bne.w H070+$F76
L070_00000F70:
; H070+$00000F70: 1b7c0001fff6  move.b #$1, -$a(a5)
        move.b #$1, -$a(a5)
L070_00000F76:
; H070+$00000F76: 4a2dfff6  tst.b -$a(a5)
        tst.b -$a(a5)
L070_00000F7A:
; H070+$00000F7A: 6700ff32  beq.w $eae
        beq.w H070+$EAE
; -> H063+$321A (trampoline_H063_3384)
L070_00000F7E:
; H070+$00000F7E: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L070_00000F84:
; H070+$00000F84: 4e5d  unlk a5
        unlk a5
L070_00000F86:
; H070+$00000F86: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00000F88:
; H070+$00000F88: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00000F8A [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H008+$01FC, H067+$0F72, H063+$321A, H065+$3390.
;   - Richiama H008+$01FC.
;   - Richiama H067+$0F72.
;   - Richiama H063+$321A.
;   - Richiama H065+$3390.
;   - Richiama H063+$0D80.
;   - Richiama H067+$11F4.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H070+$1328
; --------------------------------------------------------------------------
L070_00000F8A:
; H070+$00000F8A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00000F8C:
; H070+$00000F8C: 287af2e0  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00000F90:
; H070+$00000F90: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L070_00000F94:
; H070+$00000F94: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L070_00000F98:
; H070+$00000F98: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L070_00000F9C:
; H070+$00000F9C: 4a13  tst.b (a3)
        tst.b (a3)
L070_00000F9E:
; H070+$00000F9E: 67000188  beq.w $1128
        beq.w H070+$1128
L070_00000FA2:
; H070+$00000FA2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L070_00000FA6:
; H070+$00000FA6: 4a13  tst.b (a3)
        tst.b (a3)
L070_00000FA8:
; H070+$00000FA8: 6700016e  beq.w $1118
        beq.w H070+$1118
L070_00000FAC:
; H070+$00000FAC: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L070_00000FB0:
; H070+$00000FB0: 486c0105  pea.l $105(a4)
        pea.l $105(a4)
L070_00000FB4:
; H070+$00000FB4: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L070_00000FB8:
; H070+$00000FB8: 486c010c  pea.l $10c(a4)
        pea.l $10c(a4)
L070_00000FBC:
; H070+$00000FBC: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L070_00000FC0:
; H070+$00000FC0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00000FC4:
; H070+$00000FC4: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_00000FC8:
; H070+$00000FC8: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_00000FCC:
; H070+$00000FCC: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_00000FD0:
; H070+$00000FD0: 486dfffd  pea.l -$3(a5)
        pea.l -$3(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L070_00000FD4:
; H070+$00000FD4: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L070_00000FDA:
; H070+$00000FDA: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L070_00000FDE:
; H070+$00000FDE: 7400  moveq #$0, d2
        moveq #0, d2
L070_00000FE0:
; H070+$00000FE0: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L070_00000FE4:
; H070+$00000FE4: 600000dc  bra.w $10c2
        bra.w H070+$10C2
; -> H067+$0F72 (sub_H067_00000F72)
L070_00000FE8:
; H070+$00000FE8: 4eb900000f72  jsr $f72.l
        jsr (H067+$F72).l
; -> H063+$321A (trampoline_H063_3384)
L070_00000FEE:
; H070+$00000FEE: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L070_00000FF4:
; H070+$00000FF4: 4e75  rts 
        rts 
L070_00000FF6:
; H070+$00000FF6: 6100fe9c  bsr.w $e94
        bsr.w H070+$E94
L070_00000FFA:
; H070+$00000FFA: 4e75  rts 
        rts 
L070_00000FFC:
; H070+$00000FFC: 1b7c0001fffe  move.b #$1, -$2(a5)
        move.b #$1, -$2(a5)
L070_00001002:
; H070+$00001002: 4e75  rts 
        rts 
L070_00001004:
; H070+$00001004: 1f2dffff  move.b -$1(a5), -(a7)
        move.b -$1(a5), -(a7)
; -> H065+$3390 (trampoline_H065_3474)
L070_00001008:
; H070+$00001008: 4eb900003390  jsr $3390.l
        jsr (H065+$3390).l
L070_0000100E:
; H070+$0000100E: 4e75  rts 
        rts 
L070_00001010:
; H070+$00001010: 1f2dffff  move.b -$1(a5), -(a7)
        move.b -$1(a5), -(a7)
; -> H065+$3390 (trampoline_H065_3474)
L070_00001014:
; H070+$00001014: 4eb900003390  jsr $3390.l
        jsr (H065+$3390).l
L070_0000101A:
; H070+$0000101A: 4e75  rts 
        rts 
L070_0000101C:
; H070+$0000101C: 4e75  rts 
        rts 
; Preserved bytes H070+$0000101E..$000010C2; code/data not fully classified.
        dc.w $FFFC,$FFDC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFDC,$FFFC
        dc.w $FFFC,$FFE4,$FFD6,$FFFC,$FFFC,$FFFC,$FFC8,$FFFC
        dc.w $FFFC,$FFF0
L070_000010C2:
; H070+$000010C2: 47faff5c  lea.l $1020(pc), a3
        lea.l H070+$1020(pc), a3
L070_000010C6:
; H070+$000010C6: 0c420050  cmpi.w #$50, d2
        cmpi.w #$50, d2
L070_000010CA:
; H070+$000010CA: 6302  bls.b $10ce
        bls.b H070+$10CE
L070_000010CC:
; H070+$000010CC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L070_000010CE:
; H070+$000010CE: e342  asl.w #$1, d2
        asl.w #$1, d2
L070_000010D0:
; H070+$000010D0: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H070+$1020; indici 0..80, default -1.
L070_000010D4:
; H070+$000010D4: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
; STATO: H005+$3368 = personaggio corrente
L070_000010D8:
; H070+$000010D8: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L070_000010DE:
; H070+$000010DE: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L070_000010E4:
; H070+$000010E4: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L070_000010E8:
; H070+$000010E8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H067+$11F4 (sub_H067_000011F4)
L070_000010EC:
; H070+$000010EC: 4eb9000011f4  jsr $11f4.l
        jsr (H067+$11F4).l
L070_000010F2:
; H070+$000010F2: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L070_000010F6:
; H070+$000010F6: 4a13  tst.b (a3)
        tst.b (a3)
L070_000010F8:
; H070+$000010F8: 6700000c  beq.w $1106
        beq.w H070+$1106
L070_000010FC:
; H070+$000010FC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L070_00001100:
; H070+$00001100: 4a13  tst.b (a3)
        tst.b (a3)
L070_00001102:
; H070+$00001102: 66000008  bne.w $110c
        bne.w H070+$110C
L070_00001106:
; H070+$00001106: 1b7c0001fffe  move.b #$1, -$2(a5)
        move.b #$1, -$2(a5)
L070_0000110C:
; H070+$0000110C: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L070_00001110:
; H070+$00001110: 6700fe9a  beq.w $fac
        beq.w H070+$FAC
L070_00001114:
; H070+$00001114: 6000000e  bra.w $1124
        bra.w H070+$1124
; -> H067+$0F72 (sub_H067_00000F72)
L070_00001118:
; H070+$00001118: 4eb900000f72  jsr $f72.l
        jsr (H067+$F72).l
; -> H063+$321A (trampoline_H063_3384)
L070_0000111E:
; H070+$0000111E: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L070_00001124:
; H070+$00001124: 60000006  bra.w $112c
        bra.w H070+$112C
L070_00001128:
; H070+$00001128: 6100fd6a  bsr.w $e94
        bsr.w H070+$E94
L070_0000112C:
; H070+$0000112C: 4e5d  unlk a5
        unlk a5
L070_0000112E:
; H070+$0000112E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00001130:
; H070+$00001130: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L070_00001132:
; H070+$00001132: 508f  addq.l #$8, a7
        addq.l #$8, a7
L070_00001134:
; H070+$00001134: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00001136 [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H063+$321A, H067+$11F4, H026+$01E0, H008+$01FC.
;   - Richiama H063+$321A.
;   - Richiama H067+$11F4.
;   - Richiama H026+$01E0.
;   - Richiama H008+$01FC.
;   - Richiama H065+$196E.
;   - Richiama H067+$0794.
;   - Richiama H067+$08CC.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H070+$1A2C
; --------------------------------------------------------------------------
L070_00001136:
; H070+$00001136: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00001138:
; H070+$00001138: 287af134  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_0000113C:
; H070+$0000113C: 4e55ff88  link.w a5, #$ff88
        link.w a5, #$ff88
L070_00001140:
; H070+$00001140: 47ec011d  lea.l $11d(a4), a3
        lea.l $11d(a4), a3
L070_00001144:
; H070+$00001144: 45edffa2  lea.l -$5e(a5), a2
        lea.l -$5e(a5), a2
L070_00001148:
; H070+$00001148: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_0000114A:
; H070+$0000114A: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_0000114C:
; H070+$0000114C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_0000114E:
; H070+$0000114E: 422dffa8  clr.b -$58(a5)
        clr.b -$58(a5)
; -> H063+$321A (trampoline_H063_3384)
L070_00001152:
; H070+$00001152: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L070_00001158:
; H070+$00001158: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L070_0000115C:
; H070+$0000115C: 486dffff  pea.l -$1(a5)
        pea.l -$1(a5)
L070_00001160:
; H070+$00001160: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H067+$11F4 (sub_H067_000011F4)
L070_00001164:
; H070+$00001164: 4eb9000011f4  jsr $11f4.l
        jsr (H067+$11F4).l
L070_0000116A:
; H070+$0000116A: 47ec011f  lea.l $11f(a4), a3
        lea.l $11f(a4), a3
L070_0000116E:
; H070+$0000116E: 45edffaa  lea.l -$56(a5), a2
        lea.l -$56(a5), a2
L070_00001172:
; H070+$00001172: 7450  moveq #$50, d2
        moveq #80, d2
L070_00001174:
; H070+$00001174: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_00001176:
; H070+$00001176: 57cafffc  dbeq d2, $1174
        dbeq d2, H070+$1174
L070_0000117A:
; H070+$0000117A: 426dff9e  clr.w -$62(a5)
        clr.w -$62(a5)
L070_0000117E:
; H070+$0000117E: 47ec012e  lea.l $12e(a4), a3
        lea.l $12e(a4), a3
L070_00001182:
; H070+$00001182: 45edff8a  lea.l -$76(a5), a2
        lea.l -$76(a5), a2
L070_00001186:
; H070+$00001186: 740f  moveq #$f, d2
        moveq #15, d2
L070_00001188:
; H070+$00001188: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_0000118A:
; H070+$0000118A: 57cafffc  dbeq d2, $1188
        dbeq d2, H070+$1188
L070_0000118E:
; H070+$0000118E: 422dff9b  clr.b -$65(a5)
        clr.b -$65(a5)
L070_00001192:
; H070+$00001192: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L070_00001196:
; H070+$00001196: 670000b8  beq.w $1250
        beq.w H070+$1250
L070_0000119A:
; H070+$0000119A: 0c6d0039ff9e  cmpi.w #$39, -$62(a5)
        cmpi.w #$39, -$62(a5)
L070_000011A0:
; H070+$000011A0: 620000ae  bhi.w $1250
        bhi.w H070+$1250
L070_000011A4:
; H070+$000011A4: 4a2dff9b  tst.b -$65(a5)
        tst.b -$65(a5)
L070_000011A8:
; H070+$000011A8: 660000a6  bne.w $1250
        bne.w H070+$1250
L070_000011AC:
; H070+$000011AC: 342dff9e  move.w -$62(a5), d2
        move.w -$62(a5), d2
; STATO: H005+$3368 = personaggio corrente
L070_000011B0:
; H070+$000011B0: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L070_000011B6:
; H070+$000011B6: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L070_000011BA:
; H070+$000011BA: 7800  moveq #$0, d4
        moveq #0, d4
L070_000011BC:
; H070+$000011BC: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L070_000011C0:
; H070+$000011C0: 0c440005  cmpi.w #$5, d4
        cmpi.w #$5, d4
L070_000011C4:
; H070+$000011C4: 67000056  beq.w $121c
        beq.w H070+$121C
L070_000011C8:
; H070+$000011C8: 342dff9e  move.w -$62(a5), d2
        move.w -$62(a5), d2
; STATO: H005+$3368 = personaggio corrente
L070_000011CC:
; H070+$000011CC: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L070_000011D2:
; H070+$000011D2: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L070_000011D6:
; H070+$000011D6: 7800  moveq #$0, d4
        moveq #0, d4
L070_000011D8:
; H070+$000011D8: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L070_000011DC:
; H070+$000011DC: 0c44000b  cmpi.w #$b, d4
        cmpi.w #$b, d4
L070_000011E0:
; H070+$000011E0: 6700003a  beq.w $121c
        beq.w H070+$121C
L070_000011E4:
; H070+$000011E4: 342dff9e  move.w -$62(a5), d2
        move.w -$62(a5), d2
; STATO: H005+$3368 = personaggio corrente
L070_000011E8:
; H070+$000011E8: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L070_000011EE:
; H070+$000011EE: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L070_000011F2:
; H070+$000011F2: 7800  moveq #$0, d4
        moveq #0, d4
L070_000011F4:
; H070+$000011F4: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L070_000011F8:
; H070+$000011F8: 0c44004d  cmpi.w #$4d, d4
        cmpi.w #$4d, d4
L070_000011FC:
; H070+$000011FC: 6700001e  beq.w $121c
        beq.w H070+$121C
L070_00001200:
; H070+$00001200: 342dff9e  move.w -$62(a5), d2
        move.w -$62(a5), d2
; STATO: H005+$3368 = personaggio corrente
L070_00001204:
; H070+$00001204: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L070_0000120A:
; H070+$0000120A: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L070_0000120E:
; H070+$0000120E: 7800  moveq #$0, d4
        moveq #0, d4
L070_00001210:
; H070+$00001210: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L070_00001214:
; H070+$00001214: 0c440067  cmpi.w #$67, d4
        cmpi.w #$67, d4
L070_00001218:
; H070+$00001218: 6600002e  bne.w $1248
        bne.w H070+$1248
; STATO: H005+$3368 = personaggio corrente
L070_0000121C:
; H070+$0000121C: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L070_00001222:
; H070+$00001222: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L070_00001226:
; H070+$00001226: 67000020  beq.w $1248
        beq.w H070+$1248
L070_0000122A:
; H070+$0000122A: 1b7c0001ff9b  move.b #$1, -$65(a5)
        move.b #$1, -$65(a5)
L070_00001230:
; H070+$00001230: 342dff9e  move.w -$62(a5), d2
        move.w -$62(a5), d2
; STATO: H005+$3368 = personaggio corrente
L070_00001234:
; H070+$00001234: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L070_0000123A:
; H070+$0000123A: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L070_0000123E:
; H070+$0000123E: 7800  moveq #$0, d4
        moveq #0, d4
L070_00001240:
; H070+$00001240: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L070_00001244:
; H070+$00001244: 3b44ff9c  move.w d4, -$64(a5)
        move.w d4, -$64(a5)
L070_00001248:
; H070+$00001248: 526dff9e  addq.w #$1, -$62(a5)
        addq.w #$1, -$62(a5)
L070_0000124C:
; H070+$0000124C: 6000ff4c  bra.w $119a
        bra.w H070+$119A
L070_00001250:
; H070+$00001250: 4a2dff9b  tst.b -$65(a5)
        tst.b -$65(a5)
L070_00001254:
; H070+$00001254: 67000012  beq.w $1268
        beq.w H070+$1268
L070_00001258:
; H070+$00001258: 47ec0134  lea.l $134(a4), a3
        lea.l $134(a4), a3
L070_0000125C:
; H070+$0000125C: 45edff8a  lea.l -$76(a5), a2
        lea.l -$76(a5), a2
L070_00001260:
; H070+$00001260: 740f  moveq #$f, d2
        moveq #15, d2
L070_00001262:
; H070+$00001262: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_00001264:
; H070+$00001264: 57cafffc  dbeq d2, $1262
        dbeq d2, H070+$1262
L070_00001268:
; H070+$00001268: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L070_0000126C:
; H070+$0000126C: 6700002c  beq.w $129a
        beq.w H070+$129A
L070_00001270:
; H070+$00001270: 47ec0141  lea.l $141(a4), a3
        lea.l $141(a4), a3
L070_00001274:
; H070+$00001274: 45edffaa  lea.l -$56(a5), a2
        lea.l -$56(a5), a2
L070_00001278:
; H070+$00001278: 7450  moveq #$50, d2
        moveq #80, d2
L070_0000127A:
; H070+$0000127A: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_0000127C:
; H070+$0000127C: 57cafffc  dbeq d2, $127a
        dbeq d2, H070+$127A
L070_00001280:
; H070+$00001280: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_00001284:
; H070+$00001284: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
L070_00001288:
; H070+$00001288: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_0000128C:
; H070+$0000128C: 486dff8a  pea.l -$76(a5)
        pea.l -$76(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L070_00001290:
; H070+$00001290: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L070_00001296:
; H070+$00001296: 60000030  bra.w $12c8
        bra.w H070+$12C8
L070_0000129A:
; H070+$0000129A: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L070_0000129E:
; H070+$0000129E: 67000028  beq.w $12c8
        beq.w H070+$12C8
L070_000012A2:
; H070+$000012A2: 47ec0156  lea.l $156(a4), a3
        lea.l $156(a4), a3
L070_000012A6:
; H070+$000012A6: 45edffaa  lea.l -$56(a5), a2
        lea.l -$56(a5), a2
L070_000012AA:
; H070+$000012AA: 7450  moveq #$50, d2
        moveq #80, d2
L070_000012AC:
; H070+$000012AC: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_000012AE:
; H070+$000012AE: 57cafffc  dbeq d2, $12ac
        dbeq d2, H070+$12AC
L070_000012B2:
; H070+$000012B2: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_000012B6:
; H070+$000012B6: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
L070_000012BA:
; H070+$000012BA: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_000012BE:
; H070+$000012BE: 486dff8a  pea.l -$76(a5)
        pea.l -$76(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L070_000012C2:
; H070+$000012C2: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L070_000012C8:
; H070+$000012C8: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L070_000012CC:
; H070+$000012CC: 486dffa2  pea.l -$5e(a5)
        pea.l -$5e(a5)
L070_000012D0:
; H070+$000012D0: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_000012D4:
; H070+$000012D4: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
L070_000012D8:
; H070+$000012D8: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L070_000012DC:
; H070+$000012DC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_000012E0:
; H070+$000012E0: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_000012E4:
; H070+$000012E4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_000012E8:
; H070+$000012E8: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_000012EC:
; H070+$000012EC: 486dffa7  pea.l -$59(a5)
        pea.l -$59(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L070_000012F0:
; H070+$000012F0: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L070_000012F6:
; H070+$000012F6: 1b40ffa9  move.b d0, -$57(a5)
        move.b d0, -$57(a5)
L070_000012FA:
; H070+$000012FA: 4a2dffa7  tst.b -$59(a5)
        tst.b -$59(a5)
L070_000012FE:
; H070+$000012FE: 6600020a  bne.w $150a
        bne.w H070+$150A
L070_00001302:
; H070+$00001302: 1b7900002483ff89  move.b $2483.l, -$77(a5)
        move.b (H005+$2483).l, -$77(a5)
L070_0000130A:
; H070+$0000130A: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000130C:
; H070+$0000130C: 142dffa9  move.b -$57(a5), d2
        move.b -$57(a5), d2
L070_00001310:
; H070+$00001310: 600001d6  bra.w $14e8
        bra.w H070+$14E8
L070_00001314:
; H070+$00001314: 486dffa7  pea.l -$59(a5)
        pea.l -$59(a5)
; -> H065+$196E (sub_H065_0000196E)
L070_00001318:
; H070+$00001318: 4eb90000196e  jsr $196e.l
        jsr (H065+$196E).l
L070_0000131E:
; H070+$0000131E: 4e75  rts 
        rts 
L070_00001320:
; H070+$00001320: 486dffff  pea.l -$1(a5)
        pea.l -$1(a5)
L070_00001324:
; H070+$00001324: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L070_00001328:
; H070+$00001328: 6100fc60  bsr.w $f8a
        bsr.w H070+$F8A
L070_0000132C:
; H070+$0000132C: 4e75  rts 
        rts 
L070_0000132E:
; H070+$0000132E: 4a2dffa7  tst.b -$59(a5)
        tst.b -$59(a5)
L070_00001332:
; H070+$00001332: 66000008  bne.w $133c
        bne.w H070+$133C
; -> H067+$0794 (sub_H067_00000794)
L070_00001336:
; H070+$00001336: 4eb900000794  jsr $794.l
        jsr (H067+$794).l
L070_0000133C:
; H070+$0000133C: 4e75  rts 
        rts 
; -> H067+$08CC (sub_H067_000008CC)
L070_0000133E:
; H070+$0000133E: 4eb9000008cc  jsr $8cc.l
        jsr (H067+$8CC).l
L070_00001344:
; H070+$00001344: 4e75  rts 
        rts 
L070_00001346:
; H070+$00001346: 3f2dff9c  move.w -$64(a5), -(a7)
        move.w -$64(a5), -(a7)
L070_0000134A:
; H070+$0000134A: 4227  clr.b -(a7)
        clr.b -(a7)
L070_0000134C:
; H070+$0000134C: 4227  clr.b -(a7)
        clr.b -(a7)
L070_0000134E:
; H070+$0000134E: 486dffa7  pea.l -$59(a5)
        pea.l -$59(a5)
; -> H033+$1426 (sub_H033_00001426)
L070_00001352:
; H070+$00001352: 4eb900001426  jsr $1426.l
        jsr (H033+$1426).l
L070_00001358:
; H070+$00001358: 4e75  rts 
        rts 
L070_0000135A:
; H070+$0000135A: 486dffff  pea.l -$1(a5)
        pea.l -$1(a5)
L070_0000135E:
; H070+$0000135E: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H067+$11F4 (sub_H067_000011F4)
L070_00001362:
; H070+$00001362: 4eb9000011f4  jsr $11f4.l
        jsr (H067+$11F4).l
L070_00001368:
; H070+$00001368: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L070_0000136C:
; H070+$0000136C: 6600000a  bne.w $1378
        bne.w H070+$1378
L070_00001370:
; H070+$00001370: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L070_00001374:
; H070+$00001374: 670000b8  beq.w $142e
        beq.w H070+$142E
L070_00001378:
; H070+$00001378: 47ec0165  lea.l $165(a4), a3
        lea.l $165(a4), a3
L070_0000137C:
; H070+$0000137C: 45edffaa  lea.l -$56(a5), a2
        lea.l -$56(a5), a2
L070_00001380:
; H070+$00001380: 7450  moveq #$50, d2
        moveq #80, d2
L070_00001382:
; H070+$00001382: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L070_00001384:
; H070+$00001384: 57cafffc  dbeq d2, $1382
        dbeq d2, H070+$1382
L070_00001388:
; H070+$00001388: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_0000138C:
; H070+$0000138C: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L070_00001390:
; H070+$00001390: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L070_00001394:
; H070+$00001394: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L070_00001398:
; H070+$00001398: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_0000139C:
; H070+$0000139C: 4267  clr.w -(a7)
        clr.w -(a7)
L070_0000139E:
; H070+$0000139E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_000013A2:
; H070+$000013A2: 3f3c001f  move.w #$1f, -(a7)
        move.w #$1f, -(a7)
L070_000013A6:
; H070+$000013A6: 486c016e  pea.l $16e(a4)
        pea.l $16e(a4)
; -> H030+$0302 (trampoline_H030_0470)
L070_000013AA:
; H070+$000013AA: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L070_000013B0:
; H070+$000013B0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_000013B4:
; H070+$000013B4: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L070_000013B8:
; H070+$000013B8: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L070_000013BC:
; H070+$000013BC: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L070_000013C0:
; H070+$000013C0: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_000013C4:
; H070+$000013C4: 4267  clr.w -(a7)
        clr.w -(a7)
L070_000013C6:
; H070+$000013C6: 4227  clr.b -(a7)
        clr.b -(a7)
L070_000013C8:
; H070+$000013C8: 3f3c002f  move.w #$2f, -(a7)
        move.w #$2f, -(a7)
L070_000013CC:
; H070+$000013CC: 486c018e  pea.l $18e(a4)
        pea.l $18e(a4)
; -> H030+$0302 (trampoline_H030_0470)
L070_000013D0:
; H070+$000013D0: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L070_000013D6:
; H070+$000013D6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L070_000013DA:
; H070+$000013DA: 486dffa2  pea.l -$5e(a5)
        pea.l -$5e(a5)
L070_000013DE:
; H070+$000013DE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_000013E2:
; H070+$000013E2: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
L070_000013E6:
; H070+$000013E6: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L070_000013EA:
; H070+$000013EA: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_000013EE:
; H070+$000013EE: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_000013F2:
; H070+$000013F2: 4227  clr.b -(a7)
        clr.b -(a7)
L070_000013F4:
; H070+$000013F4: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H061+$36E6 (sub_H061_000036E6)
L070_000013F6:
; H070+$000013F6: 4eb9000036e6  jsr $36e6.l
        jsr (H061+$36E6).l
L070_000013FC:
; H070+$000013FC: 3b40ffa0  move.w d0, -$60(a5)
        move.w d0, -$60(a5)
L070_00001400:
; H070+$00001400: 0c6d0001ffa0  cmpi.w #$1, -$60(a5)
        cmpi.w #$1, -$60(a5)
L070_00001406:
; H070+$00001406: 6600000c  bne.w $1414
        bne.w H070+$1414
L070_0000140A:
; H070+$0000140A: 1b7c0001ffa8  move.b #$1, -$58(a5)
        move.b #$1, -$58(a5)
L070_00001410:
; H070+$00001410: 60000018  bra.w $142a
        bra.w H070+$142A
L070_00001414:
; H070+$00001414: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L070_00001418:
; H070+$00001418: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L070_0000141C:
; H070+$0000141C: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L070_00001420:
; H070+$00001420: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L070_00001424:
; H070+$00001424: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L070_0000142A:
; H070+$0000142A: 60000008  bra.w $1434
        bra.w H070+$1434
L070_0000142E:
; H070+$0000142E: 1b7c0001ffa8  move.b #$1, -$58(a5)
        move.b #$1, -$58(a5)
L070_00001434:
; H070+$00001434: 4e75  rts 
        rts 
L070_00001436:
; H070+$00001436: 4e75  rts 
        rts 
; Preserved bytes H070+$00001438..$000014E8; code/data not fully classified.
        dc.w $FFFC,$FF20,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FF0C,$FF20,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FEF4,$FFFC,$FFFC,$FF04,$FEE6,$FFFC,$FEDA
L070_000014E8:
; H070+$000014E8: 47faff50  lea.l $143a(pc), a3
        lea.l H070+$143A(pc), a3
L070_000014EC:
; H070+$000014EC: 0c420056  cmpi.w #$56, d2
        cmpi.w #$56, d2
L070_000014F0:
; H070+$000014F0: 6302  bls.b $14f4
        bls.b H070+$14F4
L070_000014F2:
; H070+$000014F2: 74ff  moveq #$ff, d2
        moveq #-1, d2
L070_000014F4:
; H070+$000014F4: e342  asl.w #$1, d2
        asl.w #$1, d2
L070_000014F6:
; H070+$000014F6: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H070+$143A; indici 0..86, default -1.
L070_000014FA:
; H070+$000014FA: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L070_000014FE:
; H070+$000014FE: 13edff8900002483  move.b -$77(a5), $2483.l
        move.b -$77(a5), (H005+$2483).l
L070_00001506:
; H070+$00001506: 60000018  bra.w $1520
        bra.w H070+$1520
L070_0000150A:
; H070+$0000150A: 1f2dffa9  move.b -$57(a5), -(a7)
        move.b -$57(a5), -(a7)
; -> H065+$3390 (trampoline_H065_3474)
L070_0000150E:
; H070+$0000150E: 4eb900003390  jsr $3390.l
        jsr (H065+$3390).l
; STATO: H005+$3368 = personaggio corrente
L070_00001514:
; H070+$00001514: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L070_0000151A:
; H070+$0000151A: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L070_00001520:
; H070+$00001520: 4a2dffa8  tst.b -$58(a5)
        tst.b -$58(a5)
L070_00001524:
; H070+$00001524: 6700fc36  beq.w $115c
        beq.w H070+$115C
L070_00001528:
; H070+$00001528: 4e5d  unlk a5
        unlk a5
L070_0000152A:
; H070+$0000152A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_0000152C:
; H070+$0000152C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_0000152E [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H053+$00CA, H003+$00F6.
;   - Richiama H053+$00CA.
;   - Richiama H003+$00F6.
;   - Usa lo stato globale: H005+$3E00 (puntatore stato persistente B, 2048 byte); H005+$3364 (testa della lista del party); H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H070+$198A
; --------------------------------------------------------------------------
L070_0000152E:
; H070+$0000152E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_00001530:
; H070+$00001530: 287aed3c  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00001534:
; H070+$00001534: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L070_00001538:
; H070+$00001538: 1b7c0001fff7  move.b #$1, -$9(a5)
        move.b #$1, -$9(a5)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_0000153E:
; H070+$0000153E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001544:
; H070+$00001544: 426b0590  clr.w $590(a3)
        clr.w $590(a3)
; STATO: H005+$3364 = testa della lista del party
L070_00001548:
; H070+$00001548: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L070_00001550:
; H070+$00001550: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_00001554:
; H070+$00001554: 670000f6  beq.w $164c
        beq.w H070+$164C
L070_00001558:
; H070+$00001558: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L070_0000155C:
; H070+$0000155C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_00001560:
; H070+$00001560: 0c2b00010015  cmpi.b #$1, $15(a3)
        cmpi.b #$1, $15(a3)
L070_00001566:
; H070+$00001566: 67000010  beq.w $1578
        beq.w H070+$1578
L070_0000156A:
; H070+$0000156A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_0000156E:
; H070+$0000156E: 0c2b00010199  cmpi.b #$1, $199(a3)
        cmpi.b #$1, $199(a3)
L070_00001574:
; H070+$00001574: 6600009a  bne.w $1610
        bne.w H070+$1610
L070_00001578:
; H070+$00001578: 197c0001ffff  move.b #$1, -$1(a4)
        move.b #$1, -$1(a4)
L070_0000157E:
; H070+$0000157E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001582:
; H070+$00001582: 0c2b00010198  cmpi.b #$1, $198(a3)
        cmpi.b #$1, $198(a3)
L070_00001588:
; H070+$00001588: 67000020  beq.w $15aa
        beq.w H070+$15AA
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_0000158C:
; H070+$0000158C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001592:
; H070+$00001592: 526b0590  addq.w #$1, $590(a3)
        addq.w #$1, $590(a3)
L070_00001596:
; H070+$00001596: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L070_0000159A:
; H070+$0000159A: 6700000e  beq.w $15aa
        beq.w H070+$15AA
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L070_0000159E:
; H070+$0000159E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L070_000015A4:
; H070+$000015A4: 377c000103f0  move.w #$1, $3f0(a3)
        move.w #$1, $3f0(a3)
L070_000015AA:
; H070+$000015AA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000015AE:
; H070+$000015AE: 0c2b00030197  cmpi.b #$3, $197(a3)
        cmpi.b #$3, $197(a3)
L070_000015B4:
; H070+$000015B4: 6600001c  bne.w $15d2
        bne.w H070+$15D2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_000015B8:
; H070+$000015B8: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_000015BE:
; H070+$000015BE: 4a6b058e  tst.w $58e(a3)
        tst.w $58e(a3)
L070_000015C2:
; H070+$000015C2: 6600000e  bne.w $15d2
        bne.w H070+$15D2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_000015C6:
; H070+$000015C6: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_000015CC:
; H070+$000015CC: 377c0001058e  move.w #$1, $58e(a3)
        move.w #$1, $58e(a3)
L070_000015D2:
; H070+$000015D2: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L070_000015D6:
; H070+$000015D6: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000015DA:
; H070+$000015DA: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
; STATO: H005+$3368 = personaggio corrente
L070_000015E0:
; H070+$000015E0: 23edfffc00003368  move.l -$4(a5), $3368.l
        move.l -$4(a5), (H005+$3368).l
L070_000015E8:
; H070+$000015E8: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L070_000015EC:
; H070+$000015EC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_000015F0:
; H070+$000015F0: 0c2b00010015  cmpi.b #$1, $15(a3)
        cmpi.b #$1, $15(a3)
L070_000015F6:
; H070+$000015F6: 57c2  seq.b d2
        seq.b d2
L070_000015F8:
; H070+$000015F8: 4402  neg.b d2
        neg.b d2
L070_000015FA:
; H070+$000015FA: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L070_000015FC:
; H070+$000015FC: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H053+$00CA (trampoline_H053_01E8)
L070_00001600:
; H070+$00001600: 4eb9000000ca  jsr $ca.l
        jsr (H053+$CA).l
L070_00001606:
; H070+$00001606: 2b6dfff8fffc  move.l -$8(a5), -$4(a5)
        move.l -$8(a5), -$4(a5)
L070_0000160C:
; H070+$0000160C: 6000003a  bra.w $1648
        bra.w H070+$1648
L070_00001610:
; H070+$00001610: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001614:
; H070+$00001614: 4aab0192  tst.l $192(a3)
        tst.l $192(a3)
L070_00001618:
; H070+$00001618: 67000024  beq.w $163e
        beq.w H070+$163E
L070_0000161C:
; H070+$0000161C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001620:
; H070+$00001620: 2f2b0192  move.l $192(a3), -(a7)
        move.l $192(a3), -(a7)
L070_00001624:
; H070+$00001624: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L070_00001628:
; H070+$00001628: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L070_0000162C:
; H070+$0000162C: 7418  moveq #$18, d2
        moveq #24, d2
L070_0000162E:
; H070+$0000162E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L070_00001630:
; H070+$00001630: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L070_00001636:
; H070+$00001636: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_0000163A:
; H070+$0000163A: 42ab0192  clr.l $192(a3)
        clr.l $192(a3)
L070_0000163E:
; H070+$0000163E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001642:
; H070+$00001642: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L070_00001648:
; H070+$00001648: 6000ff06  bra.w $1550
        bra.w H070+$1550
; STATO: H005+$3364 = testa della lista del party; H005+$3368 = personaggio corrente
L070_0000164C:
; H070+$0000164C: 23f90000336400003368  move.l $3364.l, $3368.l
        move.l (H005+$3364).l, (H005+$3368).l
L070_00001656:
; H070+$00001656: 4e5d  unlk a5
        unlk a5
L070_00001658:
; H070+$00001658: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_0000165A:
; H070+$0000165A: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_0000165C [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H029+$0354, H015+$00BC, H044+$01C2, H026+$0188.
;   - Richiama H029+$0354.
;   - Richiama H015+$00BC.
;   - Richiama H044+$01C2.
;   - Richiama H026+$0188.
;   - Richiama H026+$01E0.
;   - Richiama H030+$0302.
;   - Richiama H008+$01FC.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H070+$1A1E
; --------------------------------------------------------------------------
L070_0000165C:
; H070+$0000165C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_0000165E:
; H070+$0000165E: 287aec0e  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_00001662:
; H070+$00001662: 4e55ff92  link.w a5, #$ff92
        link.w a5, #$ff92
L070_00001666:
; H070+$00001666: 422dffe7  clr.b -$19(a5)
        clr.b -$19(a5)
; STATO: H005+$3364 = testa della lista del party
L070_0000166A:
; H070+$0000166A: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L070_00001672:
; H070+$00001672: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L070_00001676:
; H070+$00001676: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L070_0000167A:
; H070+$0000167A: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_0000167E:
; H070+$0000167E: 6700006c  beq.w $16ec
        beq.w H070+$16EC
L070_00001682:
; H070+$00001682: 7400  moveq #$0, d2
        moveq #0, d2
L070_00001684:
; H070+$00001684: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001688:
; H070+$00001688: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L070_0000168C:
; H070+$0000168C: 0c42007f  cmpi.w #$7f, d2
        cmpi.w #$7f, d2
L070_00001690:
; H070+$00001690: 6300004a  bls.w $16dc
        bls.w H070+$16DC
L070_00001694:
; H070+$00001694: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001698:
; H070+$00001698: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L070_0000169C:
; H070+$0000169C: 6600003e  bne.w $16dc
        bne.w H070+$16DC
L070_000016A0:
; H070+$000016A0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000016A4:
; H070+$000016A4: 1f2b00ed  move.b $ed(a3), -(a7)
        move.b $ed(a3), -(a7)
L070_000016A8:
; H070+$000016A8: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L070_000016AC:
; H070+$000016AC: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L070_000016B2:
; H070+$000016B2: 1400  move.b d0, d2
        move.b d0, d2
L070_000016B4:
; H070+$000016B4: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L070_000016B8:
; H070+$000016B8: d56dfffa  add.w d2, -$6(a5)
        add.w d2, -$6(a5)
L070_000016BC:
; H070+$000016BC: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000016C0:
; H070+$000016C0: 1f2b00ed  move.b $ed(a3), -(a7)
        move.b $ed(a3), -(a7)
L070_000016C4:
; H070+$000016C4: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L070_000016C8:
; H070+$000016C8: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L070_000016CE:
; H070+$000016CE: 1400  move.b d0, d2
        move.b d0, d2
L070_000016D0:
; H070+$000016D0: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L070_000016D4:
; H070+$000016D4: d56dfff8  add.w d2, -$8(a5)
        add.w d2, -$8(a5)
L070_000016D8:
; H070+$000016D8: 60000006  bra.w $16e0
        bra.w H070+$16E0
L070_000016DC:
; H070+$000016DC: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L070_000016E0:
; H070+$000016E0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000016E4:
; H070+$000016E4: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L070_000016EA:
; H070+$000016EA: 608e  bra.b $167a
        bra.b H070+$167A
L070_000016EC:
; H070+$000016EC: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L070_000016F0:
; H070+$000016F0: 63000072  bls.w $1764
        bls.w H070+$1764
L070_000016F4:
; H070+$000016F4: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L070_000016F8:
; H070+$000016F8: 0c2d0006fff3  cmpi.b #$6, -$d(a5)
        cmpi.b #$6, -$d(a5)
L070_000016FE:
; H070+$000016FE: 62000064  bhi.w $1764
        bhi.w H070+$1764
L070_00001702:
; H070+$00001702: 7400  moveq #$0, d2
        moveq #0, d2
L070_00001704:
; H070+$00001704: 142dfff3  move.b -$d(a5), d2
        move.b -$d(a5), d2
L070_00001708:
; H070+$00001708: e542  asl.w #$2, d2
        asl.w #$2, d2
L070_0000170A:
; H070+$0000170A: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L070_00001710:
; H070+$00001710: 4ab32000  tst.l (a3, d2.w)
        tst.l (a3, d2.w)
L070_00001714:
; H070+$00001714: 6f000048  ble.w $175e
        ble.w H070+$175E
L070_00001718:
; H070+$00001718: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000171A:
; H070+$0000171A: 142dfff3  move.b -$d(a5), d2
        move.b -$d(a5), d2
L070_0000171E:
; H070+$0000171E: e542  asl.w #$2, d2
        asl.w #$2, d2
L070_00001720:
; H070+$00001720: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L070_00001726:
; H070+$00001726: 7800  moveq #$0, d4
        moveq #0, d4
L070_00001728:
; H070+$00001728: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L070_0000172C:
; H070+$0000172C: 2c332000  move.l (a3, d2.w), d6
        move.l (a3, d2.w), d6
L070_00001730:
; H070+$00001730: 2006  move.l d6, d0
        move.l d6, d0
L070_00001732:
; H070+$00001732: 2204  move.l d4, d1
        move.l d4, d1
; -> H015+$00BC (sub_H015_000000BC)
L070_00001734:
; H070+$00001734: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L070_0000173A:
; H070+$0000173A: 3b40fff6  move.w d0, -$a(a5)
        move.w d0, -$a(a5)
L070_0000173E:
; H070+$0000173E: 7400  moveq #$0, d2
        moveq #0, d2
L070_00001740:
; H070+$00001740: 142dfff3  move.b -$d(a5), d2
        move.b -$d(a5), d2
L070_00001744:
; H070+$00001744: e542  asl.w #$2, d2
        asl.w #$2, d2
L070_00001746:
; H070+$00001746: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L070_0000174C:
; H070+$0000174C: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L070_00001750:
; H070+$00001750: c8edfff6  mulu.w -$a(a5), d4
        mulu.w -$a(a5), d4
L070_00001754:
; H070+$00001754: 99b32000  sub.l d4, (a3, d2.w)
        sub.l d4, (a3, d2.w)
L070_00001758:
; H070+$00001758: 1b7c0001ffe7  move.b #$1, -$19(a5)
        move.b #$1, -$19(a5)
L070_0000175E:
; H070+$0000175E: 522dfff3  addq.b #$1, -$d(a5)
        addq.b #$1, -$d(a5)
L070_00001762:
; H070+$00001762: 6494  bcc.b $16f8
        bcc.b H070+$16F8
L070_00001764:
; H070+$00001764: 4a2dffe7  tst.b -$19(a5)
        tst.b -$19(a5)
L070_00001768:
; H070+$00001768: 6700014e  beq.w $18b8
        beq.w H070+$18B8
L070_0000176C:
; H070+$0000176C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L070_00001770:
; H070+$00001770: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
; STATO: H005+$3364 = testa della lista del party
L070_00001776:
; H070+$00001776: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L070_0000177E:
; H070+$0000177E: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L070_00001782:
; H070+$00001782: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_00001786:
; H070+$00001786: 67000102  beq.w $188a
        beq.w H070+$188A
L070_0000178A:
; H070+$0000178A: 7400  moveq #$0, d2
        moveq #0, d2
L070_0000178C:
; H070+$0000178C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001790:
; H070+$00001790: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L070_00001794:
; H070+$00001794: 0c42007f  cmpi.w #$7f, d2
        cmpi.w #$7f, d2
L070_00001798:
; H070+$00001798: 630000e2  bls.w $187c
        bls.w H070+$187C
L070_0000179C:
; H070+$0000179C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000017A0:
; H070+$000017A0: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L070_000017A4:
; H070+$000017A4: 660000d6  bne.w $187c
        bne.w H070+$187C
L070_000017A8:
; H070+$000017A8: 7400  moveq #$0, d2
        moveq #0, d2
L070_000017AA:
; H070+$000017AA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000017AE:
; H070+$000017AE: 142b00ed  move.b $ed(a3), d2
        move.b $ed(a3), d2
L070_000017B2:
; H070+$000017B2: 4a42  tst.w d2
        tst.w d2
L070_000017B4:
; H070+$000017B4: 630000c6  bls.w $187c
        bls.w H070+$187C
L070_000017B8:
; H070+$000017B8: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000017BC:
; H070+$000017BC: 4a2b010e  tst.b $10e(a3)
        tst.b $10e(a3)
L070_000017C0:
; H070+$000017C0: 6600005e  bne.w $1820
        bne.w H070+$1820
L070_000017C4:
; H070+$000017C4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_000017C8:
; H070+$000017C8: 486dff92  pea.l -$6e(a5)
        pea.l -$6e(a5)
L070_000017CC:
; H070+$000017CC: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_000017D0:
; H070+$000017D0: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L070_000017D4:
; H070+$000017D4: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L070_000017DA:
; H070+$000017DA: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_000017DE:
; H070+$000017DE: 486dff92  pea.l -$6e(a5)
        pea.l -$6e(a5)
L070_000017E2:
; H070+$000017E2: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L070_000017E6:
; H070+$000017E6: 486c01be  pea.l $1be(a4)
        pea.l $1be(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L070_000017EA:
; H070+$000017EA: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L070_000017F0:
; H070+$000017F0: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L070_000017F4:
; H070+$000017F4: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L070_000017F8:
; H070+$000017F8: 5a42  addq.w #$5, d2
        addq.w #$5, d2
L070_000017FA:
; H070+$000017FA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L070_000017FC:
; H070+$000017FC: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L070_00001800:
; H070+$00001800: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L070_00001804:
; H070+$00001804: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00001808:
; H070+$00001808: 4267  clr.w -(a7)
        clr.w -(a7)
L070_0000180A:
; H070+$0000180A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_0000180E:
; H070+$0000180E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_00001812:
; H070+$00001812: 486dff92  pea.l -$6e(a5)
        pea.l -$6e(a5)
; -> H030+$0302 (trampoline_H030_0470)
L070_00001816:
; H070+$00001816: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L070_0000181C:
; H070+$0000181C: 6000005a  bra.w $1878
        bra.w H070+$1878
L070_00001820:
; H070+$00001820: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_00001824:
; H070+$00001824: 486dff92  pea.l -$6e(a5)
        pea.l -$6e(a5)
L070_00001828:
; H070+$00001828: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_0000182C:
; H070+$0000182C: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L070_00001830:
; H070+$00001830: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L070_00001836:
; H070+$00001836: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_0000183A:
; H070+$0000183A: 486dff92  pea.l -$6e(a5)
        pea.l -$6e(a5)
L070_0000183E:
; H070+$0000183E: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L070_00001842:
; H070+$00001842: 486c01da  pea.l $1da(a4)
        pea.l $1da(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L070_00001846:
; H070+$00001846: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L070_0000184C:
; H070+$0000184C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L070_00001850:
; H070+$00001850: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L070_00001854:
; H070+$00001854: 5a42  addq.w #$5, d2
        addq.w #$5, d2
L070_00001856:
; H070+$00001856: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L070_00001858:
; H070+$00001858: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L070_0000185C:
; H070+$0000185C: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L070_00001860:
; H070+$00001860: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00001864:
; H070+$00001864: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00001866:
; H070+$00001866: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_0000186A:
; H070+$0000186A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L070_0000186E:
; H070+$0000186E: 486dff92  pea.l -$6e(a5)
        pea.l -$6e(a5)
; -> H030+$0302 (trampoline_H030_0470)
L070_00001872:
; H070+$00001872: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L070_00001878:
; H070+$00001878: 546dfff4  addq.w #$2, -$c(a5)
        addq.w #$2, -$c(a5)
L070_0000187C:
; H070+$0000187C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001880:
; H070+$00001880: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L070_00001886:
; H070+$00001886: 6000fefa  bra.w $1782
        bra.w H070+$1782
L070_0000188A:
; H070+$0000188A: 4267  clr.w -(a7)
        clr.w -(a7)
L070_0000188C:
; H070+$0000188C: 486c01f6  pea.l $1f6(a4)
        pea.l $1f6(a4)
L070_00001890:
; H070+$00001890: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L070_00001894:
; H070+$00001894: 486c01f8  pea.l $1f8(a4)
        pea.l $1f8(a4)
L070_00001898:
; H070+$00001898: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_0000189C:
; H070+$0000189C: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_000018A0:
; H070+$000018A0: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L070_000018A4:
; H070+$000018A4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_000018A8:
; H070+$000018A8: 4227  clr.b -(a7)
        clr.b -(a7)
L070_000018AA:
; H070+$000018AA: 486dffe6  pea.l -$1a(a5)
        pea.l -$1a(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L070_000018AE:
; H070+$000018AE: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L070_000018B4:
; H070+$000018B4: 1b40ffe5  move.b d0, -$1b(a5)
        move.b d0, -$1b(a5)
L070_000018B8:
; H070+$000018B8: 4e5d  unlk a5
        unlk a5
L070_000018BA:
; H070+$000018BA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_000018BC:
; H070+$000018BC: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_000018BE [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H003+$0068, H071+$047C, H003+$00F6.
;   - Richiama H003+$0068.
;   - Richiama H071+$047C.
;   - Richiama H003+$00F6.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H070+$1962
; --------------------------------------------------------------------------
L070_000018BE:
; H070+$000018BE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_000018C0:
; H070+$000018C0: 287ae9ac  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_000018C4:
; H070+$000018C4: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L070_000018C8:
; H070+$000018C8: 2b7900003360fff4  move.l $3360.l, -$c(a5)
        move.l (H005+$3360).l, -$c(a5)
L070_000018D0:
; H070+$000018D0: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L070_000018D4:
; H070+$000018D4: 67000076  beq.w $194c
        beq.w H070+$194C
L070_000018D8:
; H070+$000018D8: 7448  moveq #$48, d2
        moveq #72, d2
L070_000018DA:
; H070+$000018DA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L070_000018DC:
; H070+$000018DC: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L070_000018E2:
; H070+$000018E2: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L070_000018E8:
; H070+$000018E8: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L070_000018EC:
; H070+$000018EC: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
; STATO: H005+$3368 = personaggio corrente
L070_000018F0:
; H070+$000018F0: 23eb004800003368  move.l $48(a3), $3368.l
        move.l $48(a3), (H005+$3368).l
L070_000018F8:
; H070+$000018F8: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L070_000018FC:
; H070+$000018FC: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L070_00001900:
; H070+$00001900: 7411  moveq #$11, d2
        moveq #17, d2
L070_00001902:
; H070+$00001902: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L070_00001904:
; H070+$00001904: 51cafffc  dbra d2, $1902
        dbra d2, H070+$1902
L070_00001908:
; H070+$00001908: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_0000190C:
; H070+$0000190C: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L070_00001910:
; H070+$00001910: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L070_00001914:
; H070+$00001914: 486dffef  pea.l -$11(a5)
        pea.l -$11(a5)
; -> H071+$047C (sub_H071_0000047C)
L070_00001918:
; H070+$00001918: 4eb90000047c  jsr $47c.l
        jsr (H071+$47C).l
L070_0000191E:
; H070+$0000191E: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L070_00001922:
; H070+$00001922: 7448  moveq #$48, d2
        moveq #72, d2
L070_00001924:
; H070+$00001924: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L070_00001926:
; H070+$00001926: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L070_0000192C:
; H070+$0000192C: 2b6dfff4fff0  move.l -$c(a5), -$10(a5)
        move.l -$c(a5), -$10(a5)
L070_00001932:
; H070+$00001932: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L070_00001936:
; H070+$00001936: 2b6b004cfff4  move.l $4c(a3), -$c(a5)
        move.l $4c(a3), -$c(a5)
L070_0000193C:
; H070+$0000193C: 2f2dfff0  move.l -$10(a5), -(a7)
        move.l -$10(a5), -(a7)
L070_00001940:
; H070+$00001940: 7450  moveq #$50, d2
        moveq #80, d2
L070_00001942:
; H070+$00001942: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L070_00001944:
; H070+$00001944: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L070_0000194A:
; H070+$0000194A: 6084  bra.b $18d0
        bra.b H070+$18D0
L070_0000194C:
; H070+$0000194C: 42b900003360  clr.l $3360.l
        clr.l (H005+$3360).l
L070_00001952:
; H070+$00001952: 4e5d  unlk a5
        unlk a5
L070_00001954:
; H070+$00001954: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00001956:
; H070+$00001956: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H070_00001958 [parziale]
; Scopo: Routine del modulo esito combattimento, tesori e distribuzione delle ricompense; richiama H063+$13BE, H003+$00F6, H044+$01C2, H030+$0302.
;   - Richiama H063+$13BE.
;   - Richiama H003+$00F6.
;   - Richiama H044+$01C2.
;   - Richiama H030+$0302.
;   - Richiama H030+$028A.
;   - Usa lo stato globale: H005+$3E00 (puntatore stato persistente B, 2048 byte); H005+$24D7 (flag del ramo demo); H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H012+$09F2, H012+$090A
; --------------------------------------------------------------------------
L070_00001958:
; H070+$00001958: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L070_0000195A:
; H070+$0000195A: 287ae912  movea.l $26e(pc), a4
        movea.l H070+$26E(pc), a4
L070_0000195E:
; H070+$0000195E: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L070_00001962:
; H070+$00001962: 6100ff5a  bsr.w $18be
        bsr.w H070+$18BE
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00001966:
; H070+$00001966: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_0000196C:
; H070+$0000196C: 426b058e  clr.w $58e(a3)
        clr.w $58e(a3)
L070_00001970:
; H070+$00001970: 422cffff  clr.b -$1(a4)
        clr.b -$1(a4)
; STATO: H005+$24D7 = flag del ramo demo
L070_00001974:
; H070+$00001974: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L070_0000197A:
; H070+$0000197A: 66000006  bne.w $1982
        bne.w H070+$1982
L070_0000197E:
; H070+$0000197E: 6100edf8  bsr.w $778
        bsr.w H070+$778
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L070_00001982:
; H070+$00001982: 13fc000600003de3  move.b #$6, $3de3.l
        move.b #$6, (H005+$3DE3).l
L070_0000198A:
; H070+$0000198A: 6100fba2  bsr.w $152e
        bsr.w H070+$152E
; STATO: H005+$24D7 = flag del ramo demo
L070_0000198E:
; H070+$0000198E: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L070_00001994:
; H070+$00001994: 67000006  beq.w $199c
        beq.w H070+$199C
L070_00001998:
; H070+$00001998: 60000176  bra.w $1b10
        bra.w H070+$1B10
; STATO: H005+$3364 = testa della lista del party
L070_0000199C:
; H070+$0000199C: 2b7900003364fff4  move.l $3364.l, -$c(a5)
        move.l (H005+$3364).l, -$c(a5)
L070_000019A4:
; H070+$000019A4: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L070_000019A8:
; H070+$000019A8: 67000018  beq.w $19c2
        beq.w H070+$19C2
L070_000019AC:
; H070+$000019AC: 2f2dfff4  move.l -$c(a5), -(a7)
        move.l -$c(a5), -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L070_000019B0:
; H070+$000019B0: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L070_000019B6:
; H070+$000019B6: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L070_000019BA:
; H070+$000019BA: 2b6b018efff4  move.l $18e(a3), -$c(a5)
        move.l $18e(a3), -$c(a5)
L070_000019C0:
; H070+$000019C0: 60e2  bra.b $19a4
        bra.b H070+$19A4
; STATO: H005+$24D0 = richiesta di uscita dal ciclo scenario
L070_000019C2:
; H070+$000019C2: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L070_000019C8:
; H070+$000019C8: 6700000c  beq.w $19d6
        beq.w H070+$19D6
L070_000019CC:
; H070+$000019CC: 4a39000024c1  tst.b $24c1.l
        tst.b (H005+$24C1).l
L070_000019D2:
; H070+$000019D2: 67000096  beq.w $1a6a
        beq.w H070+$1A6A
L070_000019D6:
; H070+$000019D6: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L070_000019DA:
; H070+$000019DA: 67000038  beq.w $1a14
        beq.w H070+$1A14
L070_000019DE:
; H070+$000019DE: 2b7900002a3afffc  move.l $2a3a.l, -$4(a5)
        move.l (H005+$2A3A).l, -$4(a5)
L070_000019E6:
; H070+$000019E6: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_000019EA:
; H070+$000019EA: 67000022  beq.w $1a0e
        beq.w H070+$1A0E
L070_000019EE:
; H070+$000019EE: 2b6dfffcfff8  move.l -$4(a5), -$8(a5)
        move.l -$4(a5), -$8(a5)
L070_000019F4:
; H070+$000019F4: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_000019F8:
; H070+$000019F8: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L070_000019FE:
; H070+$000019FE: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L070_00001A02:
; H070+$00001A02: 7448  moveq #$48, d2
        moveq #72, d2
L070_00001A04:
; H070+$00001A04: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L070_00001A06:
; H070+$00001A06: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L070_00001A0C:
; H070+$00001A0C: 60d8  bra.b $19e6
        bra.b H070+$19E6
L070_00001A0E:
; H070+$00001A0E: 42b900002a3a  clr.l $2a3a.l
        clr.l (H005+$2A3A).l
; STATO: H005+$24D7 = flag del ramo demo
L070_00001A14:
; H070+$00001A14: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L070_00001A1A:
; H070+$00001A1A: 66000014  bne.w $1a30
        bne.w H070+$1A30
L070_00001A1E:
; H070+$00001A1E: 6100fc3c  bsr.w $165c
        bsr.w H070+$165C
L070_00001A22:
; H070+$00001A22: 2f390000236e  move.l $236e.l, -(a7)
        move.l (H005+$236E).l, -(a7)
L070_00001A28:
; H070+$00001A28: 6100f174  bsr.w $b9e
        bsr.w H070+$B9E
L070_00001A2C:
; H070+$00001A2C: 6100f708  bsr.w $1136
        bsr.w H070+$1136
L070_00001A30:
; H070+$00001A30: 2b7900002a3afffc  move.l $2a3a.l, -$4(a5)
        move.l (H005+$2A3A).l, -$4(a5)
L070_00001A38:
; H070+$00001A38: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L070_00001A3C:
; H070+$00001A3C: 67000022  beq.w $1a60
        beq.w H070+$1A60
L070_00001A40:
; H070+$00001A40: 2b6dfffcfff8  move.l -$4(a5), -$8(a5)
        move.l -$4(a5), -$8(a5)
L070_00001A46:
; H070+$00001A46: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L070_00001A4A:
; H070+$00001A4A: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L070_00001A50:
; H070+$00001A50: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L070_00001A54:
; H070+$00001A54: 7448  moveq #$48, d2
        moveq #72, d2
L070_00001A56:
; H070+$00001A56: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L070_00001A58:
; H070+$00001A58: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L070_00001A5E:
; H070+$00001A5E: 60d8  bra.b $1a38
        bra.b H070+$1A38
L070_00001A60:
; H070+$00001A60: 42b900002a3a  clr.l $2a3a.l
        clr.l (H005+$2A3A).l
L070_00001A66:
; H070+$00001A66: 60000064  bra.w $1acc
        bra.w H070+$1ACC
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00001A6A:
; H070+$00001A6A: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001A70:
; H070+$00001A70: 377c0080058e  move.w #$80, $58e(a3)
        move.w #$80, $58e(a3)
L070_00001A76:
; H070+$00001A76: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L070_00001A7A:
; H070+$00001A7A: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
L070_00001A80:
; H070+$00001A80: 33fc00020000334e  move.w #$2, $334e.l
        move.w #$2, (H005+$334E).l
L070_00001A88:
; H070+$00001A88: 33fc00060000334c  move.w #$6, $334c.l
        move.w #$6, (H005+$334C).l
L070_00001A90:
; H070+$00001A90: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L070_00001A94:
; H070+$00001A94: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L070_00001A98:
; H070+$00001A98: 3f3c0025  move.w #$25, -(a7)
        move.w #$25, -(a7)
L070_00001A9C:
; H070+$00001A9C: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L070_00001AA0:
; H070+$00001AA0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L070_00001AA4:
; H070+$00001AA4: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00001AA6:
; H070+$00001AA6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L070_00001AAA:
; H070+$00001AAA: 3f3c0036  move.w #$36, -(a7)
        move.w #$36, -(a7)
L070_00001AAE:
; H070+$00001AAE: 486c021b  pea.l $21b(a4)
        pea.l $21b(a4)
; -> H030+$0302 (trampoline_H030_0470)
L070_00001AB2:
; H070+$00001AB2: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L070_00001AB8:
; H070+$00001AB8: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L070_00001ABC:
; H070+$00001ABC: 4267  clr.w -(a7)
        clr.w -(a7)
L070_00001ABE:
; H070+$00001ABE: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
L070_00001AC2:
; H070+$00001AC2: 486c0252  pea.l $252(a4)
        pea.l $252(a4)
; -> H030+$028A (sub_H030_0000028A)
L070_00001AC6:
; H070+$00001AC6: 4eb90000028a  jsr $28a.l
        jsr (H030+$28A).l
L070_00001ACC:
; H070+$00001ACC: 13fc0001000024ce  move.b #$1, $24ce.l
        move.b #$1, (H005+$24CE).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00001AD4:
; H070+$00001AD4: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001ADA:
; H070+$00001ADA: 426b06e0  clr.w $6e0(a3)
        clr.w $6e0(a3)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00001ADE:
; H070+$00001ADE: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001AE4:
; H070+$00001AE4: 426b06e2  clr.w $6e2(a3)
        clr.w $6e2(a3)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00001AE8:
; H070+$00001AE8: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001AEE:
; H070+$00001AEE: 426b06e4  clr.w $6e4(a3)
        clr.w $6e4(a3)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00001AF2:
; H070+$00001AF2: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001AF8:
; H070+$00001AF8: 426b05c6  clr.w $5c6(a3)
        clr.w $5c6(a3)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L070_00001AFC:
; H070+$00001AFC: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L070_00001B02:
; H070+$00001B02: 426b05cc  clr.w $5cc(a3)
        clr.w $5cc(a3)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L070_00001B06:
; H070+$00001B06: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L070_00001B0C:
; H070+$00001B0C: 426b03ea  clr.w $3ea(a3)
        clr.w $3ea(a3)
L070_00001B10:
; H070+$00001B10: 4e5d  unlk a5
        unlk a5
L070_00001B12:
; H070+$00001B12: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00001B14:
; H070+$00001B14: 4e75  rts 
        rts 
L070_00001B16:
; H070+$00001B16: 4e5d  unlk a5
        unlk a5
L070_00001B18:
; H070+$00001B18: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L070_00001B1A:
; H070+$00001B1A: 4e75  rts 
        rts 
; End H070: $1B1C bytes
