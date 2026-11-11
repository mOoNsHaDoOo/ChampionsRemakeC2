; ============================================================================
; GUIDA DEL MODULO H028
; File, richieste disco, caricamento a ID e RLE DAX.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; File e caricamento a ID: percorsi, Seek/Read, directory DAX, decompressione RLE e servizi di caricamento blocchi. H028+$0DD8 e' il caricatore; H028+$09DC il decompressore.
; --------------------------------------------------------------------------
; H028: 4488 original bytes; all offsets are section-relative.
        section H028,code
H028:
; Preserved bytes H028+$00000000..$000001B8; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$5265
        dc.w $7472,$7900,$4341,$4E43,$454C,$0000,$0000,$0044
        dc.w $4630,$3A00,$4469,$736B,$2054,$776F,$3A00,$4469
        dc.w $736B,$2054,$6872,$6565,$3A00,$756E,$636F,$6D70
        dc.w $7265,$7373,$206F,$7665,$7275,$6E73,$2062,$7566
        dc.w $6665,$723E,$0075,$6E63,$6F6D,$7072,$6573,$7320
        dc.w $6F76,$6572,$756E,$7320,$6275,$6666,$6572,$3E00
        dc.w $6368,$6172,$532E,$4C42,$4D00,$6368,$6172,$542E
        dc.w $4C42,$4D00,$636F,$756C,$6420,$6E6F,$7420,$6F70
        dc.w $656E,$2066,$696C,$6500,$2E64,$6178,$002E,$6461
        dc.w $7800,$6C61,$7267,$6520,$6C69,$6D69,$7420,$696E
        dc.w $2067,$6574,$6461,$7461,$626C,$6F63,$6B3E,$0052
        dc.w $414D,$3A00
        dc.l H028+$000000FE
; --------------------------------------------------------------------------
; ROUTINE: module_init_H028 [parziale]
; Scopo: Ingresso del modulo file, richieste disco, caricamento a ID e RLE DAX; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H028+$1174.
; Chiamanti diretti: H000+$016E
; --------------------------------------------------------------------------
L028_000001B8:
; H028+$000001B8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_000001BA:
; H028+$000001BA: 287afff8  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_000001BE:
; H028+$000001BE: 4e550000  link.w a5, #$0
        link.w a5, #$0
L028_000001C2:
; H028+$000001C2: 60000fb0  bra.w $1174
        bra.w H028+$1174
;
; --------------------------------------------------------------------------
; ROUTINE: Open_WithRetry [parziale]
; Scopo: Helper di apertura con interazione in caso di supporto/file non disponibile.
;   - Usa il percorso richiesto e i servizi DOS.
;   - I messaggi Retry e CANCEL consentono al chiamante di gestire il tentativo successivo.
; Chiamanti diretti: H028+$07BE, H066+$0A38, H066+$0B4E
; --------------------------------------------------------------------------
L028_000001C6:
; H028+$000001C6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_000001C8:
; H028+$000001C8: 287affea  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_000001CC:
; H028+$000001CC: 4e55ffbe  link.w a5, #$ffbe
        link.w a5, #$ffbe
L028_000001D0:
; H028+$000001D0: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L028_000001D4:
; H028+$000001D4: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_000001D6:
; H028+$000001D6: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_000001DA:
; H028+$000001DA: 6702  beq.b $1de
        beq.b H028+$1DE
L028_000001DC:
; H028+$000001DC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_000001DE:
; H028+$000001DE: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_000001E0:
; H028+$000001E0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_000001E4:
; H028+$000001E4: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L028_000001E8:
; H028+$000001E8: 244f  movea.l a7, a2
        movea.l a7, a2
L028_000001EA:
; H028+$000001EA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_000001EC:
; H028+$000001EC: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_000001EE:
; H028+$000001EE: 51cafffc  dbra d2, $1ec
        dbra d2, H028+$1EC
L028_000001F2:
; H028+$000001F2: 47edffbe  lea.l -$42(a5), a3
        lea.l -$42(a5), a3
L028_000001F6:
; H028+$000001F6: 16bc0003  move.b #$3, (a3)
        move.b #$3, (a3)
L028_000001FA:
; H028+$000001FA: 177c00010001  move.b #$1, $1(a3)
        move.b #$1, $1(a3)
L028_00000200:
; H028+$00000200: 177c00010002  move.b #$1, $2(a3)
        move.b #$1, $2(a3)
L028_00000206:
; H028+$00000206: 377c000a0004  move.w #$a, $4(a3)
        move.w #$a, $4(a3)
L028_0000020C:
; H028+$0000020C: 377c000a0006  move.w #$a, $6(a3)
        move.w #$a, $6(a3)
L028_00000212:
; H028+$00000212: 42ab0008  clr.l $8(a3)
        clr.l $8(a3)
L028_00000216:
; H028+$00000216: 42ab000c  clr.l $c(a3)
        clr.l $c(a3)
L028_0000021A:
; H028+$0000021A: 42ab0010  clr.l $10(a3)
        clr.l $10(a3)
L028_0000021E:
; H028+$0000021E: 47edffe6  lea.l -$1a(a5), a3
        lea.l -$1a(a5), a3
L028_00000222:
; H028+$00000222: 16bc0002  move.b #$2, (a3)
        move.b #$2, (a3)
L028_00000226:
; H028+$00000226: 177c00010001  move.b #$1, $1(a3)
        move.b #$1, $1(a3)
L028_0000022C:
; H028+$0000022C: 177c00010002  move.b #$1, $2(a3)
        move.b #$1, $2(a3)
L028_00000232:
; H028+$00000232: 377c00030004  move.w #$3, $4(a3)
        move.w #$3, $4(a3)
L028_00000238:
; H028+$00000238: 377c00030006  move.w #$3, $6(a3)
        move.w #$3, $6(a3)
L028_0000023E:
; H028+$0000023E: 42ab0008  clr.l $8(a3)
        clr.l $8(a3)
L028_00000242:
; H028+$00000242: 42ab000c  clr.l $c(a3)
        clr.l $c(a3)
L028_00000246:
; H028+$00000246: 42ab0010  clr.l $10(a3)
        clr.l $10(a3)
L028_0000024A:
; H028+$0000024A: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L028_0000024E:
; H028+$0000024E: 16bc0002  move.b #$2, (a3)
        move.b #$2, (a3)
L028_00000252:
; H028+$00000252: 177c00010001  move.b #$1, $1(a3)
        move.b #$1, $1(a3)
L028_00000258:
; H028+$00000258: 177c00010002  move.b #$1, $2(a3)
        move.b #$1, $2(a3)
L028_0000025E:
; H028+$0000025E: 377c00030004  move.w #$3, $4(a3)
        move.w #$3, $4(a3)
L028_00000264:
; H028+$00000264: 377c00030006  move.w #$3, $6(a3)
        move.w #$3, $6(a3)
L028_0000026A:
; H028+$0000026A: 42ab0008  clr.l $8(a3)
        clr.l $8(a3)
L028_0000026E:
; H028+$0000026E: 42ab000c  clr.l $c(a3)
        clr.l $c(a3)
L028_00000272:
; H028+$00000272: 42ab0010  clr.l $10(a3)
        clr.l $10(a3)
L028_00000276:
; H028+$00000276: 47ec0000  lea.l $0(a4), a3
        lea.l $0(a4), a3
L028_0000027A:
; H028+$0000027A: 2b4bfff2  move.l a3, -$e(a5)
        move.l a3, -$e(a5)
L028_0000027E:
; H028+$0000027E: 47ec0006  lea.l $6(a4), a3
        lea.l $6(a4), a3
L028_00000282:
; H028+$00000282: 2b4bffde  move.l a3, -$22(a5)
        move.l a3, -$22(a5)
L028_00000286:
; H028+$00000286: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_0000028A:
; H028+$0000028A: 2b4bffca  move.l a3, -$36(a5)
        move.l a3, -$36(a5)
; STATO: H005+$52F6 = puntatore alla finestra del gioco
L028_0000028E:
; H028+$0000028E: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
L028_00000294:
; H028+$00000294: 47edffbe  lea.l -$42(a5), a3
        lea.l -$42(a5), a3
L028_00000298:
; H028+$00000298: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_0000029A:
; H028+$0000029A: 47edffe6  lea.l -$1a(a5), a3
        lea.l -$1a(a5), a3
L028_0000029E:
; H028+$0000029E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_000002A0:
; H028+$000002A0: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L028_000002A4:
; H028+$000002A4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_000002A6:
; H028+$000002A6: 2f3c00008000  move.l #$8000, -(a7)
        move.l #$8000, -(a7)
L028_000002AC:
; H028+$000002AC: 42a7  clr.l -(a7)
        clr.l -(a7)
L028_000002AE:
; H028+$000002AE: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L028_000002B2:
; H028+$000002B2: 3f3c0046  move.w #$46, -(a7)
        move.w #$46, -(a7)
; -> H021+$03AE (wrapper_AutoRequest)
L028_000002B6:
; H028+$000002B6: 4eb9000003ae  jsr $3ae.l
        jsr (H021+$3AE).l
L028_000002BC:
; H028+$000002BC: 1400  move.b d0, d2
        move.b d0, d2
L028_000002BE:
; H028+$000002BE: 4a02  tst.b d2
        tst.b d2
L028_000002C0:
; H028+$000002C0: 67000002  beq.w $2c4
        beq.w H028+$2C4
L028_000002C4:
; H028+$000002C4: 4e5d  unlk a5
        unlk a5
L028_000002C6:
; H028+$000002C6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_000002C8:
; H028+$000002C8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_000002CA:
; H028+$000002CA: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L028_000002CE:
; H028+$000002CE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_000002D0 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H002+$00DC, H002+$01A2.
;   - Richiama H002+$00DC.
;   - Richiama H002+$01A2.
; Chiamanti diretti: H006+$0258, H028+$05B4, H066+$2A0A, H066+$31C8, H066+$1D5C, H066+$2ABE e altri 3
; --------------------------------------------------------------------------
L028_000002D0:
; H028+$000002D0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_000002D2:
; H028+$000002D2: 287afee0  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_000002D6:
; H028+$000002D6: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L028_000002DA:
; H028+$000002DA: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L028_000002DE:
; H028+$000002DE: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_000002E0:
; H028+$000002E0: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_000002E4:
; H028+$000002E4: 6702  beq.b $2e8
        beq.b H028+$2E8
L028_000002E6:
; H028+$000002E6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_000002E8:
; H028+$000002E8: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_000002EA:
; H028+$000002EA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_000002EE:
; H028+$000002EE: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L028_000002F2:
; H028+$000002F2: 244f  movea.l a7, a2
        movea.l a7, a2
L028_000002F4:
; H028+$000002F4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_000002F6:
; H028+$000002F6: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_000002F8:
; H028+$000002F8: 51cafffc  dbra d2, $2f6
        dbra d2, H028+$2F6
L028_000002FC:
; H028+$000002FC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000300:
; H028+$00000300: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000302:
; H028+$00000302: 2f3cfffffffe  move.l #$fffffffe, -(a7)
        move.l #$fffffffe, -(a7)
; -> H002+$00DC (wrapper_Lock)
L028_00000308:
; H028+$00000308: 4eb9000000dc  jsr $dc.l
        jsr (H002+$DC).l
L028_0000030E:
; H028+$0000030E: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L028_00000312:
; H028+$00000312: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L028_00000316:
; H028+$00000316: 67000016  beq.w $32e
        beq.w H028+$32E
L028_0000031A:
; H028+$0000031A: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H002+$01A2 (wrapper_UnLock)
L028_0000031E:
; H028+$0000031E: 4eb9000001a2  jsr $1a2.l
        jsr (H002+$1A2).l
L028_00000324:
; H028+$00000324: 7001  moveq #$1, d0
        moveq #1, d0
L028_00000326:
; H028+$00000326: 6000000c  bra.w $334
        bra.w H028+$334
; Preserved bytes H028+$0000032A..$0000032E; code/data not fully classified.
        dc.w $6000,$0008
L028_0000032E:
; H028+$0000032E: 7000  moveq #$0, d0
        moveq #0, d0
L028_00000330:
; H028+$00000330: 60000002  bra.w $334
        bra.w H028+$334
L028_00000334:
; H028+$00000334: 4e5d  unlk a5
        unlk a5
L028_00000336:
; H028+$00000336: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00000338:
; H028+$00000338: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_0000033A:
; H028+$0000033A: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L028_0000033C:
; H028+$0000033C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_0000033E [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H003+$0068, H026+$0452, H002+$00DC, H002+$0070.
;   - Richiama H003+$0068.
;   - Richiama H026+$0452.
;   - Richiama H002+$00DC.
;   - Richiama H002+$0070.
;   - Richiama H002+$01A2.
;   - Richiama H003+$00F6.
;   - Richiama H026+$0188.
; Chiamanti diretti: H066+$09B8, H066+$0A4C
; --------------------------------------------------------------------------
L028_0000033E:
; H028+$0000033E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_00000340:
; H028+$00000340: 287afe72  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_00000344:
; H028+$00000344: 4e55ffa8  link.w a5, #$ffa8
        link.w a5, #$ffa8
L028_00000348:
; H028+$00000348: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L028_0000034C:
; H028+$0000034C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_0000034E:
; H028+$0000034E: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000352:
; H028+$00000352: 6702  beq.b $356
        beq.b H028+$356
L028_00000354:
; H028+$00000354: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000356:
; H028+$00000356: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000358:
; H028+$00000358: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_0000035C:
; H028+$0000035C: 2b4f0010  move.l a7, $10(a5)
        move.l a7, $10(a5)
L028_00000360:
; H028+$00000360: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000362:
; H028+$00000362: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000364:
; H028+$00000364: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000366:
; H028+$00000366: 51cafffc  dbra d2, $364
        dbra d2, H028+$364
L028_0000036A:
; H028+$0000036A: 243c00000104  move.l #$104, d2
        move.l #$104, d2
L028_00000370:
; H028+$00000370: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L028_00000372:
; H028+$00000372: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L028_00000378:
; H028+$00000378: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L028_0000037E:
; H028+$0000037E: 2940ff08  move.l d0, -$f8(a4)
        move.l d0, -$f8(a4)
L028_00000382:
; H028+$00000382: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000386:
; H028+$00000386: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L028_0000038A:
; H028+$0000038A: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L028_0000038E:
; H028+$0000038E: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L028_00000392:
; H028+$00000392: 4267  clr.w -(a7)
        clr.w -(a7)
L028_00000394:
; H028+$00000394: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H026+$0452 (sub_H026_00000452)
L028_00000398:
; H028+$00000398: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L028_0000039E:
; H028+$0000039E: 47edffae  lea.l -$52(a5), a3
        lea.l -$52(a5), a3
L028_000003A2:
; H028+$000003A2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_000003A4:
; H028+$000003A4: 2f3cfffffffe  move.l #$fffffffe, -(a7)
        move.l #$fffffffe, -(a7)
; -> H002+$00DC (wrapper_Lock)
L028_000003AA:
; H028+$000003AA: 4eb9000000dc  jsr $dc.l
        jsr (H002+$DC).l
L028_000003B0:
; H028+$000003B0: 2b40ffaa  move.l d0, -$56(a5)
        move.l d0, -$56(a5)
L028_000003B4:
; H028+$000003B4: 2f2dffaa  move.l -$56(a5), -(a7)
        move.l -$56(a5), -(a7)
L028_000003B8:
; H028+$000003B8: 2f2cff08  move.l -$f8(a4), -(a7)
        move.l -$f8(a4), -(a7)
; -> H002+$0070 (wrapper_Examine)
L028_000003BC:
; H028+$000003BC: 4eb900000070  jsr $70.l
        jsr (H002+$70).l
L028_000003C2:
; H028+$000003C2: 1b40ffa9  move.b d0, -$57(a5)
        move.b d0, -$57(a5)
L028_000003C6:
; H028+$000003C6: 2f2dffaa  move.l -$56(a5), -(a7)
        move.l -$56(a5), -(a7)
; -> H002+$01A2 (wrapper_UnLock)
L028_000003CA:
; H028+$000003CA: 4eb9000001a2  jsr $1a2.l
        jsr (H002+$1A2).l
L028_000003D0:
; H028+$000003D0: 2f2cff08  move.l -$f8(a4), -(a7)
        move.l -$f8(a4), -(a7)
L028_000003D4:
; H028+$000003D4: 243c00000104  move.l #$104, d2
        move.l #$104, d2
L028_000003DA:
; H028+$000003DA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L028_000003DC:
; H028+$000003DC: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L028_000003E2:
; H028+$000003E2: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_000003E6:
; H028+$000003E6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L028_000003EA:
; H028+$000003EA: 3f3c006b  move.w #$6b, -(a7)
        move.w #$6b, -(a7)
L028_000003EE:
; H028+$000003EE: 266cff08  movea.l -$f8(a4), a3
        movea.l -$f8(a4), a3
L028_000003F2:
; H028+$000003F2: 486b0008  pea.l $8(a3)
        pea.l $8(a3)
; -> H026+$0188 (sub_H026_00000188)
L028_000003F6:
; H028+$000003F6: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_000003FC:
; H028+$000003FC: 4e5d  unlk a5
        unlk a5
L028_000003FE:
; H028+$000003FE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00000400:
; H028+$00000400: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_00000402:
; H028+$00000402: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L028_00000406:
; H028+$00000406: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_00000408 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H026+$054E, H026+$000C, H026+$0452, H026+$03F6.
;   - Richiama H026+$054E.
;   - Richiama H026+$000C.
;   - Richiama H026+$0452.
;   - Richiama H026+$03F6.
;   - Richiama H026+$0188.
; Chiamanti diretti: H028+$0668
; --------------------------------------------------------------------------
L028_00000408:
; H028+$00000408: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_0000040A:
; H028+$0000040A: 287afda8  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_0000040E:
; H028+$0000040E: 4e55ffa8  link.w a5, #$ffa8
        link.w a5, #$ffa8
L028_00000412:
; H028+$00000412: 342d0022  move.w $22(a5), d2
        move.w $22(a5), d2
L028_00000416:
; H028+$00000416: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000418:
; H028+$00000418: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_0000041C:
; H028+$0000041C: 6702  beq.b $420
        beq.b H028+$420
L028_0000041E:
; H028+$0000041E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000420:
; H028+$00000420: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000422:
; H028+$00000422: 266d001e  movea.l $1e(a5), a3
        movea.l $1e(a5), a3
L028_00000426:
; H028+$00000426: 2b4f001e  move.l a7, $1e(a5)
        move.l a7, $1e(a5)
L028_0000042A:
; H028+$0000042A: 244f  movea.l a7, a2
        movea.l a7, a2
L028_0000042C:
; H028+$0000042C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_0000042E:
; H028+$0000042E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000430:
; H028+$00000430: 51cafffc  dbra d2, $42e
        dbra d2, H028+$42E
L028_00000434:
; H028+$00000434: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_00000438:
; H028+$00000438: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L028_0000043C:
; H028+$0000043C: 1f3c002e  move.b #$2e, -(a7)
        move.b #$2e, -(a7)
L028_00000440:
; H028+$00000440: 4267  clr.w -(a7)
        clr.w -(a7)
L028_00000442:
; H028+$00000442: 3f3c004f  move.w #$4f, -(a7)
        move.w #$4f, -(a7)
; -> H026+$054E (sub_H026_0000054E)
L028_00000446:
; H028+$00000446: 4eb90000054e  jsr $54e.l
        jsr (H026+$54E).l
L028_0000044C:
; H028+$0000044C: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L028_00000450:
; H028+$00000450: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_00000454:
; H028+$00000454: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L028_00000458:
; H028+$00000458: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L028_0000045E:
; H028+$0000045E: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L028_00000462:
; H028+$00000462: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L028_00000466:
; H028+$00000466: 6d000046  blt.w $4ae
        blt.w H028+$4AE
L028_0000046A:
; H028+$0000046A: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L028_0000046E:
; H028+$0000046E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L028_00000472:
; H028+$00000472: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_00000476:
; H028+$00000476: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L028_0000047A:
; H028+$0000047A: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L028_0000047E:
; H028+$0000047E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L028_00000482:
; H028+$00000482: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L028_00000486:
; H028+$00000486: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H026+$0452 (sub_H026_00000452)
L028_00000488:
; H028+$00000488: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L028_0000048E:
; H028+$0000048E: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_00000492:
; H028+$00000492: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L028_00000496:
; H028+$00000496: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L028_0000049A:
; H028+$0000049A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L028_0000049E:
; H028+$0000049E: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L028_000004A2:
; H028+$000004A2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H026+$03F6 (sub_H026_000003F6)
L028_000004A4:
; H028+$000004A4: 4eb9000003f6  jsr $3f6.l
        jsr (H026+$3F6).l
L028_000004AA:
; H028+$000004AA: 60000016  bra.w $4c2
        bra.w H028+$4C2
L028_000004AE:
; H028+$000004AE: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L028_000004B2:
; H028+$000004B2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L028_000004B6:
; H028+$000004B6: 4267  clr.w -(a7)
        clr.w -(a7)
L028_000004B8:
; H028+$000004B8: 486c000d  pea.l $d(a4)
        pea.l $d(a4)
; -> H026+$0188 (sub_H026_00000188)
L028_000004BC:
; H028+$000004BC: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_000004C2:
; H028+$000004C2: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_000004C6:
; H028+$000004C6: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L028_000004CA:
; H028+$000004CA: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L028_000004D0:
; H028+$000004D0: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L028_000004D4:
; H028+$000004D4: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L028_000004D8:
; H028+$000004D8: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L028_000004DC:
; H028+$000004DC: 6f000076  ble.w $554
        ble.w H028+$554
L028_000004E0:
; H028+$000004E0: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L028_000004E4:
; H028+$000004E4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_000004E6:
; H028+$000004E6: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L028_000004EA:
; H028+$000004EA: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L028_000004EE:
; H028+$000004EE: 6d000024  blt.w $514
        blt.w H028+$514
L028_000004F2:
; H028+$000004F2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L028_000004F6:
; H028+$000004F6: 266d001e  movea.l $1e(a5), a3
        movea.l $1e(a5), a3
L028_000004FA:
; H028+$000004FA: 0c33003a2000  cmpi.b #$3a, (a3, d2.w)
        cmpi.b #$3a, (a3, d2.w)
L028_00000500:
; H028+$00000500: 6600000c  bne.w $50e
        bne.w H028+$50E
L028_00000504:
; H028+$00000504: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L028_00000508:
; H028+$00000508: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_0000050A:
; H028+$0000050A: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L028_0000050E:
; H028+$0000050E: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L028_00000512:
; H028+$00000512: 68d6  bvc.b $4ea
        bvc.b H028+$4EA
L028_00000514:
; H028+$00000514: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_00000518:
; H028+$00000518: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L028_0000051C:
; H028+$0000051C: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_00000520:
; H028+$00000520: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L028_00000524:
; H028+$00000524: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L028_00000528:
; H028+$00000528: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L028_0000052C:
; H028+$0000052C: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L028_00000530:
; H028+$00000530: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H026+$0452 (sub_H026_00000452)
L028_00000532:
; H028+$00000532: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L028_00000538:
; H028+$00000538: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_0000053C:
; H028+$0000053C: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L028_00000540:
; H028+$00000540: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L028_00000544:
; H028+$00000544: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L028_00000548:
; H028+$00000548: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L028_0000054C:
; H028+$0000054C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H026+$03F6 (sub_H026_000003F6)
L028_0000054E:
; H028+$0000054E: 4eb9000003f6  jsr $3f6.l
        jsr (H026+$3F6).l
L028_00000554:
; H028+$00000554: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L028_00000558:
; H028+$00000558: 2f2d0018  move.l $18(a5), -(a7)
        move.l $18(a5), -(a7)
L028_0000055C:
; H028+$0000055C: 3f2d0022  move.w $22(a5), -(a7)
        move.w $22(a5), -(a7)
L028_00000560:
; H028+$00000560: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L028_00000564:
; H028+$00000564: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_0000056A:
; H028+$0000056A: 4e5d  unlk a5
        unlk a5
L028_0000056C:
; H028+$0000056C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_0000056E:
; H028+$0000056E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_00000570:
; H028+$00000570: 4fef0018  lea.l $18(a7), a7
        lea.l $18(a7), a7
L028_00000574:
; H028+$00000574: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_00000576 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H026+$0188, H026+$01E0, H002+$00F2.
;   - Richiama H026+$0188.
;   - Richiama H026+$01E0.
;   - Richiama H002+$00F2.
; Chiamanti diretti: H028+$075E, H028+$0788
; --------------------------------------------------------------------------
L028_00000576:
; H028+$00000576: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_00000578:
; H028+$00000578: 287afc3a  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_0000057C:
; H028+$0000057C: 4e55ffae  link.w a5, #$ffae
        link.w a5, #$ffae
L028_00000580:
; H028+$00000580: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000584:
; H028+$00000584: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L028_00000588:
; H028+$00000588: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_0000058C:
; H028+$0000058C: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L028_00000590:
; H028+$00000590: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_00000596:
; H028+$00000596: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_0000059A:
; H028+$0000059A: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L028_0000059E:
; H028+$0000059E: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L028_000005A2:
; H028+$000005A2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L028_000005A6:
; H028+$000005A6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L028_000005AC:
; H028+$000005AC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_000005B0:
; H028+$000005B0: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L028_000005B4:
; H028+$000005B4: 6100fd1a  bsr.w $2d0
        bsr.w H028+$2D0
L028_000005B8:
; H028+$000005B8: 1400  move.b d0, d2
        move.b d0, d2
L028_000005BA:
; H028+$000005BA: 4a02  tst.b d2
        tst.b d2
L028_000005BC:
; H028+$000005BC: 6700002a  beq.w $5e8
        beq.w H028+$5E8
L028_000005C0:
; H028+$000005C0: 47edffae  lea.l -$52(a5), a3
        lea.l -$52(a5), a3
L028_000005C4:
; H028+$000005C4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_000005C6:
; H028+$000005C6: 2f3c000003ed  move.l #MODE_OLDFILE, -(a7)
        move.l #MODE_OLDFILE, -(a7)
; -> H002+$00F2 (wrapper_Open)
L028_000005CC:
; H028+$000005CC: 4eb9000000f2  jsr $f2.l
        jsr (H002+$F2).l
L028_000005D2:
; H028+$000005D2: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L028_000005D6:
; H028+$000005D6: 2680  move.l d0, (a3)
        move.l d0, (a3)
L028_000005D8:
; H028+$000005D8: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L028_000005DC:
; H028+$000005DC: 4a93  tst.l (a3)
        tst.l (a3)
L028_000005DE:
; H028+$000005DE: 56c2  sne.b d2
        sne.b d2
L028_000005E0:
; H028+$000005E0: 4402  neg.b d2
        neg.b d2
L028_000005E2:
; H028+$000005E2: 1002  move.b d2, d0
        move.b d2, d0
L028_000005E4:
; H028+$000005E4: 60000008  bra.w $5ee
        bra.w H028+$5EE
L028_000005E8:
; H028+$000005E8: 7000  moveq #$0, d0
        moveq #0, d0
L028_000005EA:
; H028+$000005EA: 60000002  bra.w $5ee
        bra.w H028+$5EE
L028_000005EE:
; H028+$000005EE: 4e5d  unlk a5
        unlk a5
L028_000005F0:
; H028+$000005F0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_000005F2:
; H028+$000005F2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_000005F4:
; H028+$000005F4: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L028_000005F8:
; H028+$000005F8: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Open_ResourceFile [parziale]
; Scopo: Risolve prefissi e richieste di disco per una risorsa.
;   - Usa H005+$3D26 come prefisso dei dati.
;   - Distingue il gruppo delle risorse e prepara richieste Disk Two/Disk Three nei rami previsti.
;   - Restituisce l’handle tramite il parametro di uscita.
; Chiamanti diretti: H007+$0536, H007+$0A52, H028+$0C28, H028+$0CC2, H030+$0C32, H043+$062E, H066+$08C6
; --------------------------------------------------------------------------
L028_000005FA:
; H028+$000005FA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_000005FC:
; H028+$000005FC: 287afbb6  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_00000600:
; H028+$00000600: 4e55fe88  link.w a5, #$fe88
        link.w a5, #$fe88
L028_00000604:
; H028+$00000604: 342d001c  move.w $1c(a5), d2
        move.w $1c(a5), d2
L028_00000608:
; H028+$00000608: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_0000060A:
; H028+$0000060A: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_0000060E:
; H028+$0000060E: 6702  beq.b $612
        beq.b H028+$612
L028_00000610:
; H028+$00000610: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000612:
; H028+$00000612: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000614:
; H028+$00000614: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L028_00000618:
; H028+$00000618: 2b4f0018  move.l a7, $18(a5)
        move.l a7, $18(a5)
L028_0000061C:
; H028+$0000061C: 244f  movea.l a7, a2
        movea.l a7, a2
L028_0000061E:
; H028+$0000061E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000620:
; H028+$00000620: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000622:
; H028+$00000622: 51cafffc  dbra d2, $620
        dbra d2, H028+$620
L028_00000626:
; H028+$00000626: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L028_0000062A:
; H028+$0000062A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_0000062C:
; H028+$0000062C: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000630:
; H028+$00000630: 6702  beq.b $634
        beq.b H028+$634
L028_00000632:
; H028+$00000632: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000634:
; H028+$00000634: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000636:
; H028+$00000636: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L028_0000063A:
; H028+$0000063A: 2b4f0012  move.l a7, $12(a5)
        move.l a7, $12(a5)
L028_0000063E:
; H028+$0000063E: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000640:
; H028+$00000640: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000642:
; H028+$00000642: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000644:
; H028+$00000644: 51cafffc  dbra d2, $642
        dbra d2, H028+$642
L028_00000648:
; H028+$00000648: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L028_0000064C:
; H028+$0000064C: 2f2d0018  move.l $18(a5), -(a7)
        move.l $18(a5), -(a7)
L028_00000650:
; H028+$00000650: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000654:
; H028+$00000654: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L028_00000658:
; H028+$00000658: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_0000065C:
; H028+$0000065C: 486dff06  pea.l -$fa(a5)
        pea.l -$fa(a5)
L028_00000660:
; H028+$00000660: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000664:
; H028+$00000664: 486dfeb4  pea.l -$14c(a5)
        pea.l -$14c(a5)
L028_00000668:
; H028+$00000668: 6100fd9e  bsr.w $408
        bsr.w H028+$408
L028_0000066C:
; H028+$0000066C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000670:
; H028+$00000670: 486dff06  pea.l -$fa(a5)
        pea.l -$fa(a5)
L028_00000674:
; H028+$00000674: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000678:
; H028+$00000678: 486dfeb4  pea.l -$14c(a5)
        pea.l -$14c(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L028_0000067C:
; H028+$0000067C: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L028_00000682:
; H028+$00000682: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000686:
; H028+$00000686: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L028_0000068A:
; H028+$0000068A: 4267  clr.w -(a7)
        clr.w -(a7)
L028_0000068C:
; H028+$0000068C: 486c000f  pea.l $f(a4)
        pea.l $f(a4)
; -> H026+$0106 (sub_H026_00000106)
L028_00000690:
; H028+$00000690: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L028_00000696:
; H028+$00000696: 1400  move.b d0, d2
        move.b d0, d2
L028_00000698:
; H028+$00000698: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L028_0000069C:
; H028+$0000069C: 66000018  bne.w $6b6
        bne.w H028+$6B6
L028_000006A0:
; H028+$000006A0: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_000006A4:
; H028+$000006A4: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L028_000006A8:
; H028+$000006A8: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_000006AC:
; H028+$000006AC: 486cffae  pea.l -$52(a4)
        pea.l -$52(a4)
; -> H026+$0188 (sub_H026_00000188)
L028_000006B0:
; H028+$000006B0: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_000006B6:
; H028+$000006B6: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L028_000006BA:
; H028+$000006BA: 486dfe9e  pea.l -$162(a5)
        pea.l -$162(a5)
L028_000006BE:
; H028+$000006BE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
; STATO: H005+$3D26 = prefisso dei file dati
L028_000006C2:
; H028+$000006C2: 487900003d26  pea.l $3d26.l
        pea.l (H005+$3D26).l
; -> H026+$0188 (sub_H026_00000188)
L028_000006C8:
; H028+$000006C8: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_000006CE:
; H028+$000006CE: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L028_000006D2:
; H028+$000006D2: 486dfe9e  pea.l -$162(a5)
        pea.l -$162(a5)
L028_000006D6:
; H028+$000006D6: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L028_000006DA:
; H028+$000006DA: 486c0011  pea.l $11(a4)
        pea.l $11(a4)
; -> H026+$0106 (sub_H026_00000106)
L028_000006DE:
; H028+$000006DE: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L028_000006E4:
; H028+$000006E4: 1400  move.b d0, d2
        move.b d0, d2
L028_000006E6:
; H028+$000006E6: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L028_000006EA:
; H028+$000006EA: 6600005e  bne.w $74a
        bne.w H028+$74A
L028_000006EE:
; H028+$000006EE: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$246E = selettore del gruppo risorse
L028_000006F0:
; H028+$000006F0: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L028_000006F6:
; H028+$000006F6: 6000003a  bra.w $732
        bra.w H028+$732
L028_000006FA:
; H028+$000006FA: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L028_000006FE:
; H028+$000006FE: 486dfe9e  pea.l -$162(a5)
        pea.l -$162(a5)
L028_00000702:
; H028+$00000702: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L028_00000706:
; H028+$00000706: 486c0016  pea.l $16(a4)
        pea.l $16(a4)
; -> H026+$0188 (sub_H026_00000188)
L028_0000070A:
; H028+$0000070A: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_00000710:
; H028+$00000710: 4e75  rts 
        rts 
L028_00000712:
; H028+$00000712: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L028_00000716:
; H028+$00000716: 486dfe9e  pea.l -$162(a5)
        pea.l -$162(a5)
L028_0000071A:
; H028+$0000071A: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L028_0000071E:
; H028+$0000071E: 486c0020  pea.l $20(a4)
        pea.l $20(a4)
; -> H026+$0188 (sub_H026_00000188)
L028_00000722:
; H028+$00000722: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_00000728:
; H028+$00000728: 4e75  rts 
        rts 
L028_0000072A:
; H028+$0000072A: 4e75  rts 
        rts 
; Preserved bytes H028+$0000072C..$00000732; code/data not fully classified.
        dc.w $FFFC,$FFCC,$FFE4
L028_00000732:
; H028+$00000732: 47fafffa  lea.l $72e(pc), a3
        lea.l H028+$72E(pc), a3
L028_00000736:
; H028+$00000736: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000738:
; H028+$00000738: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L028_0000073C:
; H028+$0000073C: 6302  bls.b $740
        bls.b H028+$740
L028_0000073E:
; H028+$0000073E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L028_00000740:
; H028+$00000740: e342  asl.w #$1, d2
        asl.w #$1, d2
L028_00000742:
; H028+$00000742: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H028+$072E; indici 0..1, default -1.
L028_00000746:
; H028+$00000746: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L028_0000074A:
; H028+$0000074A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L028_0000074E:
; H028+$0000074E: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L028_00000752:
; H028+$00000752: 486dfe9e  pea.l -$162(a5)
        pea.l -$162(a5)
L028_00000756:
; H028+$00000756: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_0000075A:
; H028+$0000075A: 486dff06  pea.l -$fa(a5)
        pea.l -$fa(a5)
L028_0000075E:
; H028+$0000075E: 6100fe16  bsr.w $576
        bsr.w H028+$576
L028_00000762:
; H028+$00000762: 1400  move.b d0, d2
        move.b d0, d2
L028_00000764:
; H028+$00000764: 4a02  tst.b d2
        tst.b d2
L028_00000766:
; H028+$00000766: 6700000c  beq.w $774
        beq.w H028+$774
L028_0000076A:
; H028+$0000076A: 7001  moveq #$1, d0
        moveq #1, d0
L028_0000076C:
; H028+$0000076C: 60000066  bra.w $7d4
        bra.w H028+$7D4
; Preserved bytes H028+$00000770..$00000774; code/data not fully classified.
        dc.w $6000,$0028
L028_00000774:
; H028+$00000774: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L028_00000778:
; H028+$00000778: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_0000077C:
; H028+$0000077C: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L028_00000780:
; H028+$00000780: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000784:
; H028+$00000784: 486dff06  pea.l -$fa(a5)
        pea.l -$fa(a5)
L028_00000788:
; H028+$00000788: 6100fdec  bsr.w $576
        bsr.w H028+$576
L028_0000078C:
; H028+$0000078C: 1400  move.b d0, d2
        move.b d0, d2
L028_0000078E:
; H028+$0000078E: 4a02  tst.b d2
        tst.b d2
L028_00000790:
; H028+$00000790: 67000008  beq.w $79a
        beq.w H028+$79A
L028_00000794:
; H028+$00000794: 7001  moveq #$1, d0
        moveq #1, d0
L028_00000796:
; H028+$00000796: 6000003c  bra.w $7d4
        bra.w H028+$7D4
L028_0000079A:
; H028+$0000079A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_0000079E:
; H028+$0000079E: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
L028_000007A2:
; H028+$000007A2: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_000007A6:
; H028+$000007A6: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L028_000007AA:
; H028+$000007AA: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_000007B0:
; H028+$000007B0: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L028_000007B4:
; H028+$000007B4: 4267  clr.w -(a7)
        clr.w -(a7)
L028_000007B6:
; H028+$000007B6: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_000007BA:
; H028+$000007BA: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
; FLUSSO: Chiama Open_WithRetry (H028+$01C6).
L028_000007BE:
; H028+$000007BE: 6100fa06  bsr.w $1c6
        bsr.w H028+$1C6
L028_000007C2:
; H028+$000007C2: 7400  moveq #$0, d2
        moveq #0, d2
L028_000007C4:
; H028+$000007C4: 4a02  tst.b d2
        tst.b d2
L028_000007C6:
; H028+$000007C6: 6782  beq.b $74a
        beq.b H028+$74A
L028_000007C8:
; H028+$000007C8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_000007CC:
; H028+$000007CC: 4293  clr.l (a3)
        clr.l (a3)
L028_000007CE:
; H028+$000007CE: 7000  moveq #$0, d0
        moveq #0, d0
L028_000007D0:
; H028+$000007D0: 60000002  bra.w $7d4
        bra.w H028+$7D4
L028_000007D4:
; H028+$000007D4: 4e5d  unlk a5
        unlk a5
L028_000007D6:
; H028+$000007D6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_000007D8:
; H028+$000007D8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_000007DA:
; H028+$000007DA: 4fef0012  lea.l $12(a7), a7
        lea.l $12(a7), a7
L028_000007DE:
; H028+$000007DE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_000007E0 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H026+$000C, H026+$0452, H026+$0106, H026+$03F6.
;   - Richiama H026+$000C.
;   - Richiama H026+$0452.
;   - Richiama H026+$0106.
;   - Richiama H026+$03F6.
;   - Richiama H026+$0188.
; Chiamanti diretti: H028+$0994, H066+$2D66
; --------------------------------------------------------------------------
L028_000007E0:
; H028+$000007E0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_000007E2:
; H028+$000007E2: 287af9d0  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_000007E6:
; H028+$000007E6: 4e55ffa8  link.w a5, #$ffa8
        link.w a5, #$ffa8
L028_000007EA:
; H028+$000007EA: 342d001c  move.w $1c(a5), d2
        move.w $1c(a5), d2
L028_000007EE:
; H028+$000007EE: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_000007F0:
; H028+$000007F0: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_000007F4:
; H028+$000007F4: 6702  beq.b $7f8
        beq.b H028+$7F8
L028_000007F6:
; H028+$000007F6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_000007F8:
; H028+$000007F8: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_000007FA:
; H028+$000007FA: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L028_000007FE:
; H028+$000007FE: 2b4f0018  move.l a7, $18(a5)
        move.l a7, $18(a5)
L028_00000802:
; H028+$00000802: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000804:
; H028+$00000804: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000806:
; H028+$00000806: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000808:
; H028+$00000808: 51cafffc  dbra d2, $806
        dbra d2, H028+$806
L028_0000080C:
; H028+$0000080C: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L028_00000810:
; H028+$00000810: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000812:
; H028+$00000812: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000816:
; H028+$00000816: 6702  beq.b $81a
        beq.b H028+$81A
L028_00000818:
; H028+$00000818: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_0000081A:
; H028+$0000081A: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_0000081C:
; H028+$0000081C: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L028_00000820:
; H028+$00000820: 2b4f0012  move.l a7, $12(a5)
        move.l a7, $12(a5)
L028_00000824:
; H028+$00000824: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000826:
; H028+$00000826: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000828:
; H028+$00000828: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_0000082A:
; H028+$0000082A: 51cafffc  dbra d2, $828
        dbra d2, H028+$828
L028_0000082E:
; H028+$0000082E: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_00000832:
; H028+$00000832: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L028_00000836:
; H028+$00000836: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L028_0000083C:
; H028+$0000083C: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L028_00000840:
; H028+$00000840: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L028_00000844:
; H028+$00000844: 2f2d0018  move.l $18(a5), -(a7)
        move.l $18(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L028_00000848:
; H028+$00000848: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L028_0000084E:
; H028+$0000084E: 3400  move.w d0, d2
        move.w d0, d2
L028_00000850:
; H028+$00000850: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L028_00000854:
; H028+$00000854: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L028_00000858:
; H028+$00000858: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L028_0000085C:
; H028+$0000085C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L028_00000860:
; H028+$00000860: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L028_00000864:
; H028+$00000864: 64000068  bcc.w $8ce
        bcc.w H028+$8CE
L028_00000868:
; H028+$00000868: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_0000086C:
; H028+$0000086C: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
L028_00000870:
; H028+$00000870: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L028_00000874:
; H028+$00000874: 2f2d0018  move.l $18(a5), -(a7)
        move.l $18(a5), -(a7)
L028_00000878:
; H028+$00000878: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L028_0000087C:
; H028+$0000087C: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H026+$0452 (sub_H026_00000452)
L028_00000880:
; H028+$00000880: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L028_00000886:
; H028+$00000886: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_0000088A:
; H028+$0000088A: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
L028_0000088E:
; H028+$0000088E: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_00000892:
; H028+$00000892: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; -> H026+$0106 (sub_H026_00000106)
L028_00000896:
; H028+$00000896: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L028_0000089C:
; H028+$0000089C: 1400  move.b d0, d2
        move.b d0, d2
L028_0000089E:
; H028+$0000089E: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L028_000008A2:
; H028+$000008A2: 66000024  bne.w $8c8
        bne.w H028+$8C8
L028_000008A6:
; H028+$000008A6: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L028_000008AA:
; H028+$000008AA: 2f2d0018  move.l $18(a5), -(a7)
        move.l $18(a5), -(a7)
L028_000008AE:
; H028+$000008AE: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L028_000008B2:
; H028+$000008B2: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H026+$03F6 (sub_H026_000003F6)
L028_000008B6:
; H028+$000008B6: 4eb9000003f6  jsr $3f6.l
        jsr (H026+$3F6).l
L028_000008BC:
; H028+$000008BC: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_000008C0:
; H028+$000008C0: d56dfffa  add.w d2, -$6(a5)
        add.w d2, -$6(a5)
L028_000008C4:
; H028+$000008C4: 60000006  bra.w $8cc
        bra.w H028+$8CC
L028_000008C8:
; H028+$000008C8: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L028_000008CC:
; H028+$000008CC: 608e  bra.b $85c
        bra.b H028+$85C
L028_000008CE:
; H028+$000008CE: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L028_000008D2:
; H028+$000008D2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L028_000008D6:
; H028+$000008D6: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L028_000008DA:
; H028+$000008DA: 2f2d0018  move.l $18(a5), -(a7)
        move.l $18(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L028_000008DE:
; H028+$000008DE: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_000008E4:
; H028+$000008E4: 4e5d  unlk a5
        unlk a5
L028_000008E6:
; H028+$000008E6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_000008E8:
; H028+$000008E8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_000008EA:
; H028+$000008EA: 4fef0012  lea.l $12(a7), a7
        lea.l $12(a7), a7
L028_000008EE:
; H028+$000008EE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_000008F0 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H026+$0188, H026+$0452.
;   - Richiama H026+$0188.
;   - Richiama H026+$0452.
; Chiamanti diretti: H066+$132C, H066+$2D7C, H066+$1874
; --------------------------------------------------------------------------
L028_000008F0:
; H028+$000008F0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_000008F2:
; H028+$000008F2: 287af8c0  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_000008F6:
; H028+$000008F6: 4e55ff50  link.w a5, #$ff50
        link.w a5, #$ff50
L028_000008FA:
; H028+$000008FA: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L028_000008FE:
; H028+$000008FE: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000900:
; H028+$00000900: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000904:
; H028+$00000904: 6702  beq.b $908
        beq.b H028+$908
L028_00000906:
; H028+$00000906: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000908:
; H028+$00000908: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_0000090A:
; H028+$0000090A: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L028_0000090E:
; H028+$0000090E: 2b4f0012  move.l a7, $12(a5)
        move.l a7, $12(a5)
L028_00000912:
; H028+$00000912: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000914:
; H028+$00000914: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000916:
; H028+$00000916: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000918:
; H028+$00000918: 51cafffc  dbra d2, $916
        dbra d2, H028+$916
L028_0000091C:
; H028+$0000091C: 1b7c0020fff6  move.b #$20, -$a(a5)
        move.b #$20, -$a(a5)
L028_00000922:
; H028+$00000922: 1b7c002efff7  move.b #$2e, -$9(a5)
        move.b #$2e, -$9(a5)
L028_00000928:
; H028+$00000928: 1b7c002afff8  move.b #$2a, -$8(a5)
        move.b #$2a, -$8(a5)
L028_0000092E:
; H028+$0000092E: 1b7c002cfff9  move.b #$2c, -$7(a5)
        move.b #$2c, -$7(a5)
L028_00000934:
; H028+$00000934: 1b7c003ffffa  move.b #$3f, -$6(a5)
        move.b #$3f, -$6(a5)
L028_0000093A:
; H028+$0000093A: 1b7c002ffffb  move.b #$2f, -$5(a5)
        move.b #$2f, -$5(a5)
L028_00000940:
; H028+$00000940: 1b7c0023fffc  move.b #$23, -$4(a5)
        move.b #$23, -$4(a5)
L028_00000946:
; H028+$00000946: 1b7c003afffd  move.b #$3a, -$3(a5)
        move.b #$3a, -$3(a5)
L028_0000094C:
; H028+$0000094C: 1b7c003bfffe  move.b #$3b, -$2(a5)
        move.b #$3b, -$2(a5)
L028_00000952:
; H028+$00000952: 1b7c007cffff  move.b #$7c, -$1(a5)
        move.b #$7c, -$1(a5)
L028_00000958:
; H028+$00000958: 422dff51  clr.b -$af(a5)
        clr.b -$af(a5)
L028_0000095C:
; H028+$0000095C: 3b7c0001fff4  move.w #$1, -$c(a5)
        move.w #$1, -$c(a5)
L028_00000962:
; H028+$00000962: 0c6d000afff4  cmpi.w #$a, -$c(a5)
        cmpi.w #$a, -$c(a5)
L028_00000968:
; H028+$00000968: 6200004a  bhi.w $9b4
        bhi.w H028+$9B4
L028_0000096C:
; H028+$0000096C: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L028_00000970:
; H028+$00000970: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000972:
; H028+$00000972: 47edfff6  lea.l -$a(a5), a3
        lea.l -$a(a5), a3
L028_00000976:
; H028+$00000976: 1b732000ff50  move.b (a3, d2.w), -$b0(a5)
        move.b (a3, d2.w), -$b0(a5)
L028_0000097C:
; H028+$0000097C: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_00000980:
; H028+$00000980: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L028_00000984:
; H028+$00000984: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000988:
; H028+$00000988: 486dff50  pea.l -$b0(a5)
        pea.l -$b0(a5)
L028_0000098C:
; H028+$0000098C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000990:
; H028+$00000990: 486dffa2  pea.l -$5e(a5)
        pea.l -$5e(a5)
L028_00000994:
; H028+$00000994: 6100fe4a  bsr.w $7e0
        bsr.w H028+$7E0
L028_00000998:
; H028+$00000998: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_0000099C:
; H028+$0000099C: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L028_000009A0:
; H028+$000009A0: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_000009A4:
; H028+$000009A4: 486dffa2  pea.l -$5e(a5)
        pea.l -$5e(a5)
; -> H026+$0188 (sub_H026_00000188)
L028_000009A8:
; H028+$000009A8: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_000009AE:
; H028+$000009AE: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L028_000009B2:
; H028+$000009B2: 64ae  bcc.b $962
        bcc.b H028+$962
L028_000009B4:
; H028+$000009B4: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L028_000009B8:
; H028+$000009B8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L028_000009BC:
; H028+$000009BC: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L028_000009C0:
; H028+$000009C0: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L028_000009C4:
; H028+$000009C4: 4267  clr.w -(a7)
        clr.w -(a7)
L028_000009C6:
; H028+$000009C6: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H026+$0452 (sub_H026_00000452)
L028_000009CA:
; H028+$000009CA: 4eb900000452  jsr $452.l
        jsr (H026+$452).l
L028_000009D0:
; H028+$000009D0: 4e5d  unlk a5
        unlk a5
L028_000009D2:
; H028+$000009D2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_000009D4:
; H028+$000009D4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_000009D6:
; H028+$000009D6: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L028_000009DA:
; H028+$000009DA: 4ed0  jmp (a0)
        jmp (a0)
; FUNCTION: DAX_decompress_RLE
FN_DAX_decompress_RLE:
;
; --------------------------------------------------------------------------
; ROUTINE: DAX_DecompressRLE [verificato]
; Scopo: Decompressore RLE usato dal caricatore di blocchi.
;   - Avanza separatamente indice sorgente e indice destinazione.
;   - I rami copiano una sequenza letterale o ripetono un byte.
;   - Controlla i limiti del buffer di uscita e richiama il gestore errori nei rami di sconfinamento.
;   - La routine originale è stata confrontata in emulazione con il decoder ricostruito su tutti i 239 blocchi DAX.
; ABI: A5+$0C = dimensione destinazione*; +$10 = dimensione compressa*.
; ABI: A5+$14 = destinazione*; +$18 = sorgente*.
; Chiamanti diretti: H028+$1074
; --------------------------------------------------------------------------
L028_000009DC:
; H028+$000009DC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_000009DE:
; H028+$000009DE: 287af7d4  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_000009E2:
; H028+$000009E2: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L028_000009E6:
; H028+$000009E6: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L028_000009EA:
; H028+$000009EA: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L028_000009EE:
; H028+$000009EE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L028_000009F2:
; H028+$000009F2: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L028_000009F6:
; H028+$000009F6: 7800  moveq #$0, d4
        moveq #0, d4
L028_000009F8:
; H028+$000009F8: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L028_000009FC:
; H028+$000009FC: 3b44fff8  move.w d4, -$8(a5)
        move.w d4, -$8(a5)
L028_00000A00:
; H028+$00000A00: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L028_00000A04:
; H028+$00000A04: 65000014  bcs.w $a1a
        bcs.w H028+$A1A
L028_00000A08:
; H028+$00000A08: 0c6d007efff8  cmpi.w #$7e, -$8(a5)
        cmpi.w #$7e, -$8(a5)
L028_00000A0E:
; H028+$00000A0E: 6200000a  bhi.w $a1a
        bhi.w H028+$A1A
L028_00000A12:
; H028+$00000A12: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L028_00000A16:
; H028+$00000A16: 6000001c  bra.w $a34
        bra.w H028+$A34
L028_00000A1A:
; H028+$00000A1A: 0c6d007ffff8  cmpi.w #$7f, -$8(a5)
        cmpi.w #$7f, -$8(a5)
L028_00000A20:
; H028+$00000A20: 65000012  bcs.w $a34
        bcs.w H028+$A34
L028_00000A24:
; H028+$00000A24: 0c6d00fefff8  cmpi.w #$fe, -$8(a5)
        cmpi.w #$fe, -$8(a5)
L028_00000A2A:
; H028+$00000A2A: 62000008  bhi.w $a34
        bhi.w H028+$A34
L028_00000A2E:
; H028+$00000A2E: 3b7c0001fff6  move.w #$1, -$a(a5)
        move.w #$1, -$a(a5)
L028_00000A34:
; H028+$00000A34: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L028_00000A38:
; H028+$00000A38: 60000116  bra.w $b50
        bra.w H028+$B50
L028_00000A3C:
; H028+$00000A3C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_00000A40:
; H028+$00000A40: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L028_00000A44:
; H028+$00000A44: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000A46:
; H028+$00000A46: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000A4A:
; H028+$00000A4A: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L028_00000A4C:
; H028+$00000A4C: 62000038  bhi.w $a86
        bhi.w H028+$A86
L028_00000A50:
; H028+$00000A50: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L028_00000A54:
; H028+$00000A54: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000A56:
; H028+$00000A56: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L028_00000A5A:
; H028+$00000A5A: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L028_00000A5E:
; H028+$00000A5E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000A60:
; H028+$00000A60: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_00000A64:
; H028+$00000A64: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L028_00000A68:
; H028+$00000A68: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L028_00000A6C:
; H028+$00000A6C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000A6E:
; H028+$00000A6E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L028_00000A72:
; H028+$00000A72: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000A74:
; H028+$00000A74: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L028_00000A7A:
; H028+$00000A7A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L028_00000A7C:
; H028+$00000A7C: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L028_00000A82:
; H028+$00000A82: 60000022  bra.w $aa6
        bra.w H028+$AA6
L028_00000A86:
; H028+$00000A86: 3f3c001a  move.w #$1a, -(a7)
        move.w #$1a, -(a7)
L028_00000A8A:
; H028+$00000A8A: 486c002c  pea.l $2c(a4)
        pea.l $2c(a4)
L028_00000A8E:
; H028+$00000A8E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_00000A92:
; H028+$00000A92: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L028_00000A96:
; H028+$00000A96: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000A98:
; H028+$00000A98: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000A9C:
; H028+$00000A9C: 9453  sub.w (a3), d2
        sub.w (a3), d2
L028_00000A9E:
; H028+$00000A9E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H014+$0018 (sub_H014_00000018)
L028_00000AA0:
; H028+$00000AA0: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L028_00000AA6:
; H028+$00000AA6: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L028_00000AAA:
; H028+$00000AAA: 5442  addq.w #$2, d2
        addq.w #$2, d2
L028_00000AAC:
; H028+$00000AAC: d56dfffe  add.w d2, -$2(a5)
        add.w d2, -$2(a5)
L028_00000AB0:
; H028+$00000AB0: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L028_00000AB4:
; H028+$00000AB4: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000AB6:
; H028+$00000AB6: d56dfffc  add.w d2, -$4(a5)
        add.w d2, -$4(a5)
L028_00000ABA:
; H028+$00000ABA: 4e75  rts 
        rts 
L028_00000ABC:
; H028+$00000ABC: 343c0100  move.w #$100, d2
        move.w #$100, d2
L028_00000AC0:
; H028+$00000AC0: 946dfff8  sub.w -$8(a5), d2
        sub.w -$8(a5), d2
L028_00000AC4:
; H028+$00000AC4: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L028_00000AC8:
; H028+$00000AC8: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L028_00000ACC:
; H028+$00000ACC: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L028_00000AD0:
; H028+$00000AD0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000AD2:
; H028+$00000AD2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L028_00000AD4:
; H028+$00000AD4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L028_00000AD8:
; H028+$00000AD8: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L028_00000ADA:
; H028+$00000ADA: 62000058  bhi.w $b34
        bhi.w H028+$B34
L028_00000ADE:
; H028+$00000ADE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_00000AE2:
; H028+$00000AE2: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L028_00000AE6:
; H028+$00000AE6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000AEA:
; H028+$00000AEA: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L028_00000AEC:
; H028+$00000AEC: 62000022  bhi.w $b10
        bhi.w H028+$B10
L028_00000AF0:
; H028+$00000AF0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_00000AF4:
; H028+$00000AF4: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L028_00000AF8:
; H028+$00000AF8: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L028_00000AFC:
; H028+$00000AFC: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L028_00000B00:
; H028+$00000B00: 5244  addq.w #$1, d4
        addq.w #$1, d4
L028_00000B02:
; H028+$00000B02: 246d0018  movea.l $18(a5), a2
        movea.l $18(a5), a2
L028_00000B06:
; H028+$00000B06: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L028_00000B0C:
; H028+$00000B0C: 60000020  bra.w $b2e
        bra.w H028+$B2E
L028_00000B10:
; H028+$00000B10: 3f3c001a  move.w #$1a, -(a7)
        move.w #$1a, -(a7)
L028_00000B14:
; H028+$00000B14: 486c0047  pea.l $47(a4)
        pea.l $47(a4)
L028_00000B18:
; H028+$00000B18: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_00000B1C:
; H028+$00000B1C: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L028_00000B20:
; H028+$00000B20: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000B24:
; H028+$00000B24: 9453  sub.w (a3), d2
        sub.w (a3), d2
L028_00000B26:
; H028+$00000B26: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H014+$0018 (sub_H014_00000018)
L028_00000B28:
; H028+$00000B28: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L028_00000B2E:
; H028+$00000B2E: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L028_00000B32:
; H028+$00000B32: 64a0  bcc.b $ad4
        bcc.b H028+$AD4
L028_00000B34:
; H028+$00000B34: 548f  addq.l #$2, a7
        addq.l #$2, a7
L028_00000B36:
; H028+$00000B36: 546dfffe  addq.w #$2, -$2(a5)
        addq.w #$2, -$2(a5)
L028_00000B3A:
; H028+$00000B3A: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L028_00000B3E:
; H028+$00000B3E: d56dfffc  add.w d2, -$4(a5)
        add.w d2, -$4(a5)
L028_00000B42:
; H028+$00000B42: 4e75  rts 
        rts 
L028_00000B44:
; H028+$00000B44: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L028_00000B48:
; H028+$00000B48: 4e75  rts 
        rts 
; Preserved bytes H028+$00000B4A..$00000B50; code/data not fully classified.
        dc.w $FFF8,$FEF0,$FF70
L028_00000B50:
; H028+$00000B50: 47fafffa  lea.l $b4c(pc), a3
        lea.l H028+$B4C(pc), a3
L028_00000B54:
; H028+$00000B54: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L028_00000B58:
; H028+$00000B58: 6302  bls.b $b5c
        bls.b H028+$B5C
L028_00000B5A:
; H028+$00000B5A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L028_00000B5C:
; H028+$00000B5C: e342  asl.w #$1, d2
        asl.w #$1, d2
L028_00000B5E:
; H028+$00000B5E: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H028+$0B4C; indici 0..1, default -1.
L028_00000B62:
; H028+$00000B62: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L028_00000B66:
; H028+$00000B66: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L028_00000B6A:
; H028+$00000B6A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000B6E:
; H028+$00000B6E: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L028_00000B70:
; H028+$00000B70: 6500fe7c  bcs.w $9ee
        bcs.w H028+$9EE
L028_00000B74:
; H028+$00000B74: 4e5d  unlk a5
        unlk a5
L028_00000B76:
; H028+$00000B76: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00000B78:
; H028+$00000B78: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_00000B7A:
; H028+$00000B7A: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L028_00000B7E:
; H028+$00000B7E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_00000B80 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H026+$0188, H026+$01E0, H002+$0122.
;   - Richiama H026+$0188.
;   - Richiama H026+$01E0.
;   - Richiama H002+$0122.
;   - Usa lo stato globale: H005+$246E (selettore del gruppo risorse).
; Chiamanti diretti: H028+$0E3E, H042+$05C8
; --------------------------------------------------------------------------
L028_00000B80:
; H028+$00000B80: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_00000B82:
; H028+$00000B82: 287af630  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_00000B86:
; H028+$00000B86: 4e55ffa6  link.w a5, #$ffa6
        link.w a5, #$ffa6
L028_00000B8A:
; H028+$00000B8A: 342d001e  move.w $1e(a5), d2
        move.w $1e(a5), d2
L028_00000B8E:
; H028+$00000B8E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000B90:
; H028+$00000B90: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000B94:
; H028+$00000B94: 6702  beq.b $b98
        beq.b H028+$B98
L028_00000B96:
; H028+$00000B96: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000B98:
; H028+$00000B98: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000B9A:
; H028+$00000B9A: 266d001a  movea.l $1a(a5), a3
        movea.l $1a(a5), a3
L028_00000B9E:
; H028+$00000B9E: 2b4f001a  move.l a7, $1a(a5)
        move.l a7, $1a(a5)
L028_00000BA2:
; H028+$00000BA2: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000BA4:
; H028+$00000BA4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000BA6:
; H028+$00000BA6: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000BA8:
; H028+$00000BA8: 51cafffc  dbra d2, $ba6
        dbra d2, H028+$BA6
L028_00000BAC:
; H028+$00000BAC: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L028_00000BB0:
; H028+$00000BB0: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000BB2:
; H028+$00000BB2: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000BB6:
; H028+$00000BB6: 6702  beq.b $bba
        beq.b H028+$BBA
L028_00000BB8:
; H028+$00000BB8: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000BBA:
; H028+$00000BBA: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000BBC:
; H028+$00000BBC: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L028_00000BC0:
; H028+$00000BC0: 2b4f0014  move.l a7, $14(a5)
        move.l a7, $14(a5)
L028_00000BC4:
; H028+$00000BC4: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000BC6:
; H028+$00000BC6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000BC8:
; H028+$00000BC8: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000BCA:
; H028+$00000BCA: 51cafffc  dbra d2, $bc8
        dbra d2, H028+$BC8
L028_00000BCE:
; H028+$00000BCE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000BD2:
; H028+$00000BD2: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
L028_00000BD6:
; H028+$00000BD6: 3f2d001e  move.w $1e(a5), -(a7)
        move.w $1e(a5), -(a7)
L028_00000BDA:
; H028+$00000BDA: 2f2d001a  move.l $1a(a5), -(a7)
        move.l $1a(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L028_00000BDE:
; H028+$00000BDE: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L028_00000BE4:
; H028+$00000BE4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000BE8:
; H028+$00000BE8: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
L028_00000BEC:
; H028+$00000BEC: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L028_00000BF0:
; H028+$00000BF0: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L028_00000BF4:
; H028+$00000BF4: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L028_00000BFA:
; H028+$00000BFA: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L028_00000BFE:
; H028+$00000BFE: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
L028_00000C02:
; H028+$00000C02: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$246E = selettore del gruppo risorse
L028_00000C04:
; H028+$00000C04: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L028_00000C0A:
; H028+$00000C0A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000C0C:
; H028+$00000C0C: c5fc001e  muls.w #$1e, d2
        muls.w #$1e, d2
L028_00000C10:
; H028+$00000C10: 47f900003e08  lea.l $3e08.l, a3
        lea.l (H005+$3E08).l, a3
L028_00000C16:
; H028+$00000C16: 3f3c001d  move.w #$1d, -(a7)
        move.w #$1d, -(a7)
L028_00000C1A:
; H028+$00000C1A: 48732800  pea.l (a3, d2.l)
        pea.l (a3, d2.l)
L028_00000C1E:
; H028+$00000C1E: 1f39000024a4  move.b $24a4.l, -(a7)
        move.b (H005+$24A4).l, -(a7)
L028_00000C24:
; H028+$00000C24: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; FLUSSO: Chiama Open_ResourceFile (H028+$05FA).
L028_00000C28:
; H028+$00000C28: 6100f9d0  bsr.w $5fa
        bsr.w H028+$5FA
L028_00000C2C:
; H028+$00000C2C: 1400  move.b d0, d2
        move.b d0, d2
L028_00000C2E:
; H028+$00000C2E: 4a02  tst.b d2
        tst.b d2
L028_00000C30:
; H028+$00000C30: 66000008  bne.w $c3a
        bne.w H028+$C3A
L028_00000C34:
; H028+$00000C34: 7000  moveq #$0, d0
        moveq #0, d0
L028_00000C36:
; H028+$00000C36: 60000024  bra.w $c5c
        bra.w H028+$C5C
L028_00000C3A:
; H028+$00000C3A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000C3E:
; H028+$00000C3E: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L028_00000C40:
; H028+$00000C40: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000C44:
; H028+$00000C44: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000C46:
; H028+$00000C46: 2f3c00000002  move.l #$2, -(a7)
        move.l #$2, -(a7)
; -> H002+$0122 (wrapper_Read)
L028_00000C4C:
; H028+$00000C4C: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L028_00000C52:
; H028+$00000C52: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L028_00000C56:
; H028+$00000C56: 7001  moveq #$1, d0
        moveq #1, d0
L028_00000C58:
; H028+$00000C58: 60000002  bra.w $c5c
        bra.w H028+$C5C
L028_00000C5C:
; H028+$00000C5C: 4e5d  unlk a5
        unlk a5
L028_00000C5E:
; H028+$00000C5E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00000C60:
; H028+$00000C60: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_00000C62:
; H028+$00000C62: 4fef0014  lea.l $14(a7), a7
        lea.l $14(a7), a7
L028_00000C66:
; H028+$00000C66: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_00000C68 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H003+$0068, H040+$05E4, H003+$0090, H002+$0014.
;   - Richiama H003+$0068.
;   - Richiama H040+$05E4.
;   - Richiama H003+$0090.
;   - Richiama H002+$0014.
; Chiamanti diretti: H028+$0D54, H028+$0D64
; --------------------------------------------------------------------------
L028_00000C68:
; H028+$00000C68: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_00000C6A:
; H028+$00000C6A: 287af548  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_00000C6E:
; H028+$00000C6E: 4e55ff8e  link.w a5, #$ff8e
        link.w a5, #$ff8e
L028_00000C72:
; H028+$00000C72: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L028_00000C76:
; H028+$00000C76: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000C78:
; H028+$00000C78: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000C7C:
; H028+$00000C7C: 6702  beq.b $c80
        beq.b H028+$C80
L028_00000C7E:
; H028+$00000C7E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000C80:
; H028+$00000C80: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000C82:
; H028+$00000C82: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000C86:
; H028+$00000C86: 2b4f0010  move.l a7, $10(a5)
        move.l a7, $10(a5)
L028_00000C8A:
; H028+$00000C8A: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000C8C:
; H028+$00000C8C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000C8E:
; H028+$00000C8E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000C90:
; H028+$00000C90: 51cafffc  dbra d2, $c8e
        dbra d2, H028+$C8E
L028_00000C94:
; H028+$00000C94: 7428  moveq #$28, d2
        moveq #40, d2
L028_00000C96:
; H028+$00000C96: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L028_00000C98:
; H028+$00000C98: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L028_00000C9E:
; H028+$00000C9E: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L028_00000CA4:
; H028+$00000CA4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000CA8:
; H028+$00000CA8: 2680  move.l d0, (a3)
        move.l d0, (a3)
L028_00000CAA:
; H028+$00000CAA: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L028_00000CAE:
; H028+$00000CAE: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L028_00000CB2:
; H028+$00000CB2: 3f3c001d  move.w #$1d, -(a7)
        move.w #$1d, -(a7)
L028_00000CB6:
; H028+$00000CB6: 487900003e08  pea.l $3e08.l
        pea.l (H005+$3E08).l
L028_00000CBC:
; H028+$00000CBC: 4227  clr.b -(a7)
        clr.b -(a7)
L028_00000CBE:
; H028+$00000CBE: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLUSSO: Chiama Open_ResourceFile (H028+$05FA).
L028_00000CC2:
; H028+$00000CC2: 6100f936  bsr.w $5fa
        bsr.w H028+$5FA
L028_00000CC6:
; H028+$00000CC6: 1400  move.b d0, d2
        move.b d0, d2
L028_00000CC8:
; H028+$00000CC8: 4a02  tst.b d2
        tst.b d2
L028_00000CCA:
; H028+$00000CCA: 6700005e  beq.w $d2a
        beq.w H028+$D2A
L028_00000CCE:
; H028+$00000CCE: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L028_00000CD2:
; H028+$00000CD2: 67000056  beq.w $d2a
        beq.w H028+$D2A
L028_00000CD6:
; H028+$00000CD6: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L028_00000CDA:
; H028+$00000CDA: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L028_00000CDE:
; H028+$00000CDE: 2652  movea.l (a2), a3
        movea.l (a2), a3
L028_00000CE0:
; H028+$00000CE0: 4853  pea.l (a3)
        pea.l (a3)
L028_00000CE2:
; H028+$00000CE2: 486dff92  pea.l -$6e(a5)
        pea.l -$6e(a5)
L028_00000CE6:
; H028+$00000CE6: 48790000004a  pea.l $4a.l
        pea.l (H041+$4A).l
; FLUSSO: Chiama Read_ILBM (H040+$05E4).
L028_00000CEC:
; H028+$00000CEC: 4eb9000005e4  jsr $5e4.l
        jsr (H040+$5E4).l
L028_00000CF2:
; H028+$00000CF2: 2b40ff8e  move.l d0, -$72(a5)
        move.l d0, -$72(a5)
L028_00000CF6:
; H028+$00000CF6: 47edffb8  lea.l -$48(a5), a3
        lea.l -$48(a5), a3
L028_00000CFA:
; H028+$00000CFA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000CFC:
; H028+$00000CFC: 47f90000522e  lea.l $522e.l, a3
        lea.l (H005+$522E).l, a3
L028_00000D02:
; H028+$00000D02: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000D04:
; H028+$00000D04: 2f3c00000040  move.l #$40, -(a7)
        move.l #$40, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L028_00000D0A:
; H028+$00000D0A: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L028_00000D10:
; H028+$00000D10: 33f90000522e0000523e  move.w $522e.l, $523e.l
        move.w (H005+$522E).l, (H005+$523E).l
L028_00000D1A:
; H028+$00000D1A: 42790000522e  clr.w $522e.l
        clr.w (H005+$522E).l
L028_00000D20:
; H028+$00000D20: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L028_00000D24:
; H028+$00000D24: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L028_00000D2A:
; H028+$00000D2A: 4e5d  unlk a5
        unlk a5
L028_00000D2C:
; H028+$00000D2C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00000D2E:
; H028+$00000D2E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_00000D30:
; H028+$00000D30: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L028_00000D34:
; H028+$00000D34: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_00000D36 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H066+$1B3A, H066+$0E5A, H047+$093E, H013+$2A8C
; --------------------------------------------------------------------------
L028_00000D36:
; H028+$00000D36: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_00000D38:
; H028+$00000D38: 287af47a  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_00000D3C:
; H028+$00000D3C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L028_00000D40:
; H028+$00000D40: 4a2cff07  tst.b -$f9(a4)
        tst.b -$f9(a4)
L028_00000D44:
; H028+$00000D44: 66000028  bne.w $d6e
        bne.w H028+$D6E
L028_00000D48:
; H028+$00000D48: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L028_00000D4C:
; H028+$00000D4C: 486c0062  pea.l $62(a4)
        pea.l $62(a4)
L028_00000D50:
; H028+$00000D50: 486cff56  pea.l -$aa(a4)
        pea.l -$aa(a4)
L028_00000D54:
; H028+$00000D54: 6100ff12  bsr.w $c68
        bsr.w H028+$C68
L028_00000D58:
; H028+$00000D58: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L028_00000D5C:
; H028+$00000D5C: 486c006c  pea.l $6c(a4)
        pea.l $6c(a4)
L028_00000D60:
; H028+$00000D60: 486cff52  pea.l -$ae(a4)
        pea.l -$ae(a4)
L028_00000D64:
; H028+$00000D64: 6100ff02  bsr.w $c68
        bsr.w H028+$C68
L028_00000D68:
; H028+$00000D68: 197c0001ff07  move.b #$1, -$f9(a4)
        move.b #$1, -$f9(a4)
L028_00000D6E:
; H028+$00000D6E: 4e5d  unlk a5
        unlk a5
L028_00000D70:
; H028+$00000D70: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00000D72:
; H028+$00000D72: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_00000D74 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; richiama H041+$00BE, H003+$00F6.
;   - Richiama H041+$00BE.
;   - Richiama H003+$00F6.
; Chiamanti diretti: H010+$00CE, H013+$5146
; --------------------------------------------------------------------------
L028_00000D74:
; H028+$00000D74: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_00000D76:
; H028+$00000D76: 287af43c  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_00000D7A:
; H028+$00000D7A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L028_00000D7E:
; H028+$00000D7E: 4a2cff07  tst.b -$f9(a4)
        tst.b -$f9(a4)
L028_00000D82:
; H028+$00000D82: 6700004e  beq.w $dd2
        beq.w H028+$DD2
L028_00000D86:
; H028+$00000D86: 4aacff56  tst.l -$aa(a4)
        tst.l -$aa(a4)
L028_00000D8A:
; H028+$00000D8A: 6700001e  beq.w $daa
        beq.w H028+$DAA
L028_00000D8E:
; H028+$00000D8E: 266cff56  movea.l -$aa(a4), a3
        movea.l -$aa(a4), a3
L028_00000D92:
; H028+$00000D92: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
; -> H041+$00BE (sub_H041_000000BE)
L028_00000D96:
; H028+$00000D96: 4eb9000000be  jsr $be.l
        jsr (H041+$BE).l
L028_00000D9C:
; H028+$00000D9C: 2f2cff56  move.l -$aa(a4), -(a7)
        move.l -$aa(a4), -(a7)
L028_00000DA0:
; H028+$00000DA0: 7428  moveq #$28, d2
        moveq #40, d2
L028_00000DA2:
; H028+$00000DA2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L028_00000DA4:
; H028+$00000DA4: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L028_00000DAA:
; H028+$00000DAA: 4aacff52  tst.l -$ae(a4)
        tst.l -$ae(a4)
L028_00000DAE:
; H028+$00000DAE: 6700001e  beq.w $dce
        beq.w H028+$DCE
L028_00000DB2:
; H028+$00000DB2: 266cff52  movea.l -$ae(a4), a3
        movea.l -$ae(a4), a3
L028_00000DB6:
; H028+$00000DB6: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
; -> H041+$00BE (sub_H041_000000BE)
L028_00000DBA:
; H028+$00000DBA: 4eb9000000be  jsr $be.l
        jsr (H041+$BE).l
L028_00000DC0:
; H028+$00000DC0: 2f2cff52  move.l -$ae(a4), -(a7)
        move.l -$ae(a4), -(a7)
L028_00000DC4:
; H028+$00000DC4: 7428  moveq #$28, d2
        moveq #40, d2
L028_00000DC6:
; H028+$00000DC6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L028_00000DC8:
; H028+$00000DC8: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L028_00000DCE:
; H028+$00000DCE: 422cff07  clr.b -$f9(a4)
        clr.b -$f9(a4)
L028_00000DD2:
; H028+$00000DD2: 4e5d  unlk a5
        unlk a5
L028_00000DD4:
; H028+$00000DD4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00000DD6:
; H028+$00000DD6: 4e75  rts 
        rts 
; FUNCTION: DAX_load_block
FN_DAX_load_block:
;
; --------------------------------------------------------------------------
; ROUTINE: DAX_LoadBlock [verificato]
; Scopo: Trova un ID nella directory, legge e decomprime il blocco corrispondente.
;   - Legge voci ID/offset/dimensioni; il percorso .dax converte gli interi little-endian.
;   - Cerca l’ID richiesto e posiziona il file con Seek.
;   - Alloca un buffer compresso e un buffer di uscita; aggiunge 256 byte di margine alla dimensione runtime.
;   - Chiama H028+$09DC e libera il buffer compresso.
; ABI: Dopo il prologo di modulo: A5+$0C = buffer** di uscita; +$10 = dimensione* di uscita.
; ABI: A5+$14 = ID word; +$16 = estensione*; +$1A = limite estensione word.
; ABI: A5+$1C = nome base*; +$20 = limite nome word.
; Chiamanti diretti: H011+$1574, H011+$18E8, H012+$0CC8, H029+$0AC0, H061+$1B7E, H066+$20BA, H066+$2430, H066+$2554
; --------------------------------------------------------------------------
L028_00000DD8:
; H028+$00000DD8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_00000DDA:
; H028+$00000DDA: 287af3d8  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_00000DDE:
; H028+$00000DDE: 4e55ff88  link.w a5, #$ff88
        link.w a5, #$ff88
L028_00000DE2:
; H028+$00000DE2: 342d0020  move.w $20(a5), d2
        move.w $20(a5), d2
L028_00000DE6:
; H028+$00000DE6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000DE8:
; H028+$00000DE8: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000DEC:
; H028+$00000DEC: 6702  beq.b $df0
        beq.b H028+$DF0
L028_00000DEE:
; H028+$00000DEE: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000DF0:
; H028+$00000DF0: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000DF2:
; H028+$00000DF2: 266d001c  movea.l $1c(a5), a3
        movea.l $1c(a5), a3
L028_00000DF6:
; H028+$00000DF6: 2b4f001c  move.l a7, $1c(a5)
        move.l a7, $1c(a5)
L028_00000DFA:
; H028+$00000DFA: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000DFC:
; H028+$00000DFC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000DFE:
; H028+$00000DFE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000E00:
; H028+$00000E00: 51cafffc  dbra d2, $dfe
        dbra d2, H028+$DFE
L028_00000E04:
; H028+$00000E04: 342d001a  move.w $1a(a5), d2
        move.w $1a(a5), d2
L028_00000E08:
; H028+$00000E08: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000E0A:
; H028+$00000E0A: 08020000  btst.b #$0, d2
        btst #$0, d2
L028_00000E0E:
; H028+$00000E0E: 6702  beq.b $e12
        beq.b H028+$E12
L028_00000E10:
; H028+$00000E10: 5242  addq.w #$1, d2
        addq.w #$1, d2
L028_00000E12:
; H028+$00000E12: 9ec2  suba.w d2, a7
        suba.w d2, a7
L028_00000E14:
; H028+$00000E14: 266d0016  movea.l $16(a5), a3
        movea.l $16(a5), a3
L028_00000E18:
; H028+$00000E18: 2b4f0016  move.l a7, $16(a5)
        move.l a7, $16(a5)
L028_00000E1C:
; H028+$00000E1C: 244f  movea.l a7, a2
        movea.l a7, a2
L028_00000E1E:
; H028+$00000E1E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L028_00000E20:
; H028+$00000E20: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L028_00000E22:
; H028+$00000E22: 51cafffc  dbra d2, $e20
        dbra d2, H028+$E20
L028_00000E26:
; H028+$00000E26: 3f2d0020  move.w $20(a5), -(a7)
        move.w $20(a5), -(a7)
L028_00000E2A:
; H028+$00000E2A: 2f2d001c  move.l $1c(a5), -(a7)
        move.l $1c(a5), -(a7)
L028_00000E2E:
; H028+$00000E2E: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L028_00000E32:
; H028+$00000E32: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L028_00000E36:
; H028+$00000E36: 486dffea  pea.l -$16(a5)
        pea.l -$16(a5)
L028_00000E3A:
; H028+$00000E3A: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L028_00000E3E:
; H028+$00000E3E: 6100fd40  bsr.w $b80
        bsr.w H028+$B80
L028_00000E42:
; H028+$00000E42: 1400  move.b d0, d2
        move.b d0, d2
L028_00000E44:
; H028+$00000E44: 4a02  tst.b d2
        tst.b d2
L028_00000E46:
; H028+$00000E46: 66000022  bne.w $e6a
        bne.w H028+$E6A
L028_00000E4A:
; H028+$00000E4A: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L028_00000E4E:
; H028+$00000E4E: 486c0076  pea.l $76(a4)
        pea.l $76(a4)
L028_00000E52:
; H028+$00000E52: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H014+$0018 (sub_H014_00000018)
L028_00000E54:
; H028+$00000E54: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L028_00000E5A:
; H028+$00000E5A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000E5E:
; H028+$00000E5E: 4253  clr.w (a3)
        clr.w (a3)
L028_00000E60:
; H028+$00000E60: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000E64:
; H028+$00000E64: 4293  clr.l (a3)
        clr.l (a3)
L028_00000E66:
; H028+$00000E66: 60000224  bra.w $108c
        bra.w H028+$108C
L028_00000E6A:
; H028+$00000E6A: 426dff88  clr.w -$78(a5)
        clr.w -$78(a5)
L028_00000E6E:
; H028+$00000E6E: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L028_00000E72:
; H028+$00000E72: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L028_00000E76:
; H028+$00000E76: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L028_00000E7A:
; H028+$00000E7A: 486c008a  pea.l $8a(a4)
        pea.l $8a(a4)
; -> H026+$0106 (sub_H026_00000106)
L028_00000E7E:
; H028+$00000E7E: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L028_00000E84:
; H028+$00000E84: 1400  move.b d0, d2
        move.b d0, d2
L028_00000E86:
; H028+$00000E86: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L028_00000E8A:
; H028+$00000E8A: 66000010  bne.w $e9c
        bne.w H028+$E9C
L028_00000E8E:
; H028+$00000E8E: 486dffea  pea.l -$16(a5)
        pea.l -$16(a5)
; -> H031+$0012 (sub_H031_00000012)
L028_00000E92:
; H028+$00000E92: 4eb900000012  jsr $12.l
        jsr (H031+$12).l
L028_00000E98:
; H028+$00000E98: 546dffea  addq.w #$2, -$16(a5)
        addq.w #$2, -$16(a5)
L028_00000E9C:
; H028+$00000E9C: 526dff88  addq.w #$1, -$78(a5)
        addq.w #$1, -$78(a5)
L028_00000EA0:
; H028+$00000EA0: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L028_00000EA4:
; H028+$00000EA4: 47edfff5  lea.l -$b(a5), a3
        lea.l -$b(a5), a3
L028_00000EA8:
; H028+$00000EA8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000EAA:
; H028+$00000EAA: 7401  moveq #$1, d2
        moveq #1, d2
L028_00000EAC:
; H028+$00000EAC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L028_00000EAE:
; H028+$00000EAE: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L028_00000EB4:
; H028+$00000EB4: 2b40fff0  move.l d0, -$10(a5)
        move.l d0, -$10(a5)
L028_00000EB8:
; H028+$00000EB8: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L028_00000EBC:
; H028+$00000EBC: 47edfff6  lea.l -$a(a5), a3
        lea.l -$a(a5), a3
L028_00000EC0:
; H028+$00000EC0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000EC2:
; H028+$00000EC2: 7404  moveq #$4, d2
        moveq #4, d2
L028_00000EC4:
; H028+$00000EC4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L028_00000EC6:
; H028+$00000EC6: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L028_00000ECC:
; H028+$00000ECC: 2b40fff0  move.l d0, -$10(a5)
        move.l d0, -$10(a5)
L028_00000ED0:
; H028+$00000ED0: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L028_00000ED4:
; H028+$00000ED4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000ED8:
; H028+$00000ED8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000EDA:
; H028+$00000EDA: 7402  moveq #$2, d2
        moveq #2, d2
L028_00000EDC:
; H028+$00000EDC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L028_00000EDE:
; H028+$00000EDE: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L028_00000EE4:
; H028+$00000EE4: 2b40fff0  move.l d0, -$10(a5)
        move.l d0, -$10(a5)
L028_00000EE8:
; H028+$00000EE8: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L028_00000EEC:
; H028+$00000EEC: 47edfffe  lea.l -$2(a5), a3
        lea.l -$2(a5), a3
L028_00000EF0:
; H028+$00000EF0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L028_00000EF2:
; H028+$00000EF2: 7402  moveq #$2, d2
        moveq #2, d2
L028_00000EF4:
; H028+$00000EF4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L028_00000EF6:
; H028+$00000EF6: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L028_00000EFC:
; H028+$00000EFC: 2b40fff0  move.l d0, -$10(a5)
        move.l d0, -$10(a5)
L028_00000F00:
; H028+$00000F00: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L028_00000F04:
; H028+$00000F04: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L028_00000F08:
; H028+$00000F08: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L028_00000F0C:
; H028+$00000F0C: 486c008f  pea.l $8f(a4)
        pea.l $8f(a4)
; -> H026+$0106 (sub_H026_00000106)
L028_00000F10:
; H028+$00000F10: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L028_00000F16:
; H028+$00000F16: 1400  move.b d0, d2
        move.b d0, d2
L028_00000F18:
; H028+$00000F18: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L028_00000F1C:
; H028+$00000F1C: 66000020  bne.w $f3e
        bne.w H028+$F3E
L028_00000F20:
; H028+$00000F20: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H031+$0012 (sub_H031_00000012)
L028_00000F24:
; H028+$00000F24: 4eb900000012  jsr $12.l
        jsr (H031+$12).l
L028_00000F2A:
; H028+$00000F2A: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H031+$0012 (sub_H031_00000012)
L028_00000F2E:
; H028+$00000F2E: 4eb900000012  jsr $12.l
        jsr (H031+$12).l
L028_00000F34:
; H028+$00000F34: 486dfff6  pea.l -$a(a5)
        pea.l -$a(a5)
; -> H031+$003E (sub_H031_0000003E)
L028_00000F38:
; H028+$00000F38: 4eb90000003e  jsr $3e.l
        jsr (H031+$3E).l
L028_00000F3E:
; H028+$00000F3E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000F42:
; H028+$00000F42: 06530100  addi.w #$100, (a3)
        addi.w #$100, (a3)
L028_00000F46:
; H028+$00000F46: 0c6da000fffe  cmpi.w #$a000, -$2(a5)
        cmpi.w #$a000, -$2(a5)
L028_00000F4C:
; H028+$00000F4C: 63000020  bls.w $f6e
        bls.w H028+$F6E
L028_00000F50:
; H028+$00000F50: 7400  moveq #$0, d2
        moveq #0, d2
L028_00000F52:
; H028+$00000F52: 142dfff5  move.b -$b(a5), d2
        move.b -$b(a5), d2
L028_00000F56:
; H028+$00000F56: b46d0014  cmp.w $14(a5), d2
        cmp.w $14(a5), d2
L028_00000F5A:
; H028+$00000F5A: 66000012  bne.w $f6e
        bne.w H028+$F6E
L028_00000F5E:
; H028+$00000F5E: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L028_00000F62:
; H028+$00000F62: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
; -> H010+$0332 (sub_H010_00000332)
L028_00000F68:
; H028+$00000F68: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L028_00000F6E:
; H028+$00000F6E: 0c6d03e7ff88  cmpi.w #$3e7, -$78(a5)
        cmpi.w #$3e7, -$78(a5)
L028_00000F74:
; H028+$00000F74: 63000014  bls.w $f8a
        bls.w H028+$F8A
L028_00000F78:
; H028+$00000F78: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L028_00000F7C:
; H028+$00000F7C: 486c0094  pea.l $94(a4)
        pea.l $94(a4)
L028_00000F80:
; H028+$00000F80: 3f2dff88  move.w -$78(a5), -(a7)
        move.w -$78(a5), -(a7)
; -> H014+$0018 (sub_H014_00000018)
L028_00000F84:
; H028+$00000F84: 4eb900000018  jsr $18.l
        jsr (H014+$18).l
L028_00000F8A:
; H028+$00000F8A: 7400  moveq #$0, d2
        moveq #0, d2
L028_00000F8C:
; H028+$00000F8C: 142dfff5  move.b -$b(a5), d2
        move.b -$b(a5), d2
L028_00000F90:
; H028+$00000F90: b46d0014  cmp.w $14(a5), d2
        cmp.w $14(a5), d2
L028_00000F94:
; H028+$00000F94: 67000020  beq.w $fb6
        beq.w H028+$FB6
L028_00000F98:
; H028+$00000F98: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L028_00000F9C:
; H028+$00000F9C: 7400  moveq #$0, d2
        moveq #0, d2
L028_00000F9E:
; H028+$00000F9E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L028_00000FA0:
; H028+$00000FA0: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H002+$0156 (wrapper_Seek)
L028_00000FA2:
; H028+$00000FA2: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L028_00000FA8:
; H028+$00000FA8: 2400  move.l d0, d2
        move.l d0, d2
L028_00000FAA:
; H028+$00000FAA: 7800  moveq #$0, d4
        moveq #0, d4
L028_00000FAC:
; H028+$00000FAC: 382dffea  move.w -$16(a5), d4
        move.w -$16(a5), d4
L028_00000FB0:
; H028+$00000FB0: b484  cmp.l d4, d2
        cmp.l d4, d2
L028_00000FB2:
; H028+$00000FB2: 6d00fee8  blt.w $e9c
        blt.w H028+$E9C
L028_00000FB6:
; H028+$00000FB6: 7400  moveq #$0, d2
        moveq #0, d2
L028_00000FB8:
; H028+$00000FB8: 142dfff5  move.b -$b(a5), d2
        move.b -$b(a5), d2
L028_00000FBC:
; H028+$00000FBC: b46d0014  cmp.w $14(a5), d2
        cmp.w $14(a5), d2
L028_00000FC0:
; H028+$00000FC0: 6700001c  beq.w $fde
        beq.w H028+$FDE
L028_00000FC4:
; H028+$00000FC4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000FC8:
; H028+$00000FC8: 4253  clr.w (a3)
        clr.w (a3)
L028_00000FCA:
; H028+$00000FCA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00000FCE:
; H028+$00000FCE: 4293  clr.l (a3)
        clr.l (a3)
L028_00000FD0:
; H028+$00000FD0: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L028_00000FD4:
; H028+$00000FD4: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L028_00000FDA:
; H028+$00000FDA: 600000b0  bra.w $108c
        bra.w H028+$108C
L028_00000FDE:
; H028+$00000FDE: 7400  moveq #$0, d2
        moveq #0, d2
L028_00000FE0:
; H028+$00000FE0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L028_00000FE4:
; H028+$00000FE4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L028_00000FE6:
; H028+$00000FE6: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L028_00000FEC:
; H028+$00000FEC: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L028_00000FF2:
; H028+$00000FF2: 23c000003c7e  move.l d0, $3c7e.l
        move.l d0, (H005+$3C7E).l
L028_00000FF8:
; H028+$00000FF8: 7400  moveq #$0, d2
        moveq #0, d2
L028_00000FFA:
; H028+$00000FFA: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L028_00000FFE:
; H028+$00000FFE: 3413  move.w (a3), d2
        move.w (a3), d2
L028_00001000:
; H028+$00001000: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L028_00001002:
; H028+$00001002: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L028_00001008:
; H028+$00001008: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L028_0000100E:
; H028+$0000100E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_00001012:
; H028+$00001012: 2680  move.l d0, (a3)
        move.l d0, (a3)
L028_00001014:
; H028+$00001014: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L028_00001018:
; H028+$00001018: 7400  moveq #$0, d2
        moveq #0, d2
L028_0000101A:
; H028+$0000101A: 342dffea  move.w -$16(a5), d2
        move.w -$16(a5), d2
L028_0000101E:
; H028+$0000101E: d4adfff6  add.l -$a(a5), d2
        add.l -$a(a5), d2
L028_00001022:
; H028+$00001022: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L028_00001024:
; H028+$00001024: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H002+$0156 (wrapper_Seek)
L028_0000102A:
; H028+$0000102A: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L028_00001030:
; H028+$00001030: 2b40fff0  move.l d0, -$10(a5)
        move.l d0, -$10(a5)
L028_00001034:
; H028+$00001034: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
L028_00001038:
; H028+$00001038: 2f3900003c7e  move.l $3c7e.l, -(a7)
        move.l (H005+$3C7E).l, -(a7)
L028_0000103E:
; H028+$0000103E: 7400  moveq #$0, d2
        moveq #0, d2
L028_00001040:
; H028+$00001040: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L028_00001044:
; H028+$00001044: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L028_00001046:
; H028+$00001046: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L028_0000104C:
; H028+$0000104C: 2b40fff0  move.l d0, -$10(a5)
        move.l d0, -$10(a5)
L028_00001050:
; H028+$00001050: 2f2dffec  move.l -$14(a5), -(a7)
        move.l -$14(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L028_00001054:
; H028+$00001054: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L028_0000105A:
; H028+$0000105A: 3b6dfffefffc  move.w -$2(a5), -$4(a5)
        move.w -$2(a5), -$4(a5)
L028_00001060:
; H028+$00001060: 2f3900003c7e  move.l $3c7e.l, -(a7)
        move.l (H005+$3C7E).l, -(a7)
L028_00001066:
; H028+$00001066: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L028_0000106A:
; H028+$0000106A: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L028_0000106C:
; H028+$0000106C: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L028_00001070:
; H028+$00001070: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; FLUSSO: Chiama DAX_DecompressRLE (H028+$09DC).
L028_00001074:
; H028+$00001074: 6100f966  bsr.w $9dc
        bsr.w H028+$9DC
L028_00001078:
; H028+$00001078: 2f3900003c7e  move.l $3c7e.l, -(a7)
        move.l (H005+$3C7E).l, -(a7)
L028_0000107E:
; H028+$0000107E: 7400  moveq #$0, d2
        moveq #0, d2
L028_00001080:
; H028+$00001080: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L028_00001084:
; H028+$00001084: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L028_00001086:
; H028+$00001086: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L028_0000108C:
; H028+$0000108C: 4e5d  unlk a5
        unlk a5
L028_0000108E:
; H028+$0000108E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00001090:
; H028+$00001090: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_00001092:
; H028+$00001092: 4fef0016  lea.l $16(a7), a7
        lea.l $16(a7), a7
L028_00001096:
; H028+$00001096: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H028_00001098 [parziale]
; Scopo: Routine del modulo file, richieste disco, caricamento a ID e RLE DAX; opera su H005+$246E (selettore del gruppo risorse).
;   - Usa lo stato globale: H005+$246E (selettore del gruppo risorse).
; Chiamanti diretti: H061+$2AC0
; --------------------------------------------------------------------------
L028_00001098:
; H028+$00001098: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L028_0000109A:
; H028+$0000109A: 287af118  movea.l $1b4(pc), a4
        movea.l H028+$1B4(pc), a4
L028_0000109E:
; H028+$0000109E: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATO: H005+$246E = selettore del gruppo risorse
L028_000010A2:
; H028+$000010A2: 13f90000246e0000246d  move.b $246e.l, $246d.l
        move.b (H005+$246E).l, (H005+$246D).l
L028_000010AC:
; H028+$000010AC: 7400  moveq #$0, d2
        moveq #0, d2
L028_000010AE:
; H028+$000010AE: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L028_000010B2:
; H028+$000010B2: 5442  addq.w #$2, d2
        addq.w #$2, d2
L028_000010B4:
; H028+$000010B4: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L028_000010BA:
; H028+$000010BA: 84fc0003  divu.w #$3, d2
        divu.w #$3, d2
; STATO: H005+$246E = selettore del gruppo risorse
L028_000010BE:
; H028+$000010BE: 13c20000246e  move.b d2, $246e.l
        move.b d2, (H005+$246E).l
L028_000010C4:
; H028+$000010C4: 4e5d  unlk a5
        unlk a5
L028_000010C6:
; H028+$000010C6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_000010C8:
; H028+$000010C8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L028_000010CA:
; H028+$000010CA: 548f  addq.l #$2, a7
        addq.l #$2, a7
L028_000010CC:
; H028+$000010CC: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H028+$000010CE..$00001174; code/data not fully classified.
        dc.w $2F0C,$287A,$F0E2,$4E55,$0000,$13F9
        dc.l H005+$0000246D
        dc.l H005+$0000246E
        dc.w $4E5D,$285F,$4E75,$2F0C,$287A,$F0C8,$4E55,$0000
        dc.w $3F3C,$0007,$2F2D,$000C,$3F3C,$0004,$486C,$00B1
        dc.w $4EB9
        dc.l H026+$00000088
        dc.w $1400,$0C02,$0001,$6600,$000C,$7000,$6000,$0054
        dc.w $6000,$0050,$266D,$000C,$0C13,$0044,$6600,$001A
        dc.w $266D,$000C,$0C2B,$0048,$0001,$6600,$000C,$7001
        dc.w $6000,$0030,$6000,$002C,$266D,$000C,$0C13,$0044
        dc.w $6600,$001A,$266D,$000C,$0C2B,$0046,$0001,$6600
        dc.w $000C,$7003,$6000,$000C,$6000,$0008,$7002,$6000
        dc.w $0002,$4E5D,$285F,$205F,$588F,$4ED0
L028_00001174:
; H028+$00001174: 422cff07  clr.b -$f9(a4)
        clr.b -$f9(a4)
L028_00001178:
; H028+$00001178: 42acff56  clr.l -$aa(a4)
        clr.l -$aa(a4)
L028_0000117C:
; H028+$0000117C: 42acff52  clr.l -$ae(a4)
        clr.l -$ae(a4)
L028_00001180:
; H028+$00001180: 4e5d  unlk a5
        unlk a5
L028_00001182:
; H028+$00001182: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L028_00001184:
; H028+$00001184: 4e75  rts 
        rts 
; Preserved bytes H028+$00001186..$00001188; code/data not fully classified.
        dc.w $0000
; End H028: $1188 bytes
