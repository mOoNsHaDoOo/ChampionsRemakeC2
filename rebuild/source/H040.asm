; ============================================================================
; GUIDA DEL MODULO H040
; Lettore ILBM basato sulle callback del parser IFF.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Lettore ILBM basato sulle callback del parser IFF: FORM/ILBM, BMHD, CMAP, BODY, LIST e PROP. I piani sono limitati a cinque.
; --------------------------------------------------------------------------
; H040: 1632 original bytes; all offsets are section-relative.
        section H040,code
H040:
; Preserved bytes H040+$00000000..$00000210; code/data not fully classified.
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
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000
        dc.l H040+$0000020C
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H040_065C [parziale]
; Scopo: Trampolino verso H040+$065C; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H040+$065C.
; Chiamanti diretti: H000+$00DE
; --------------------------------------------------------------------------
L040_00000210:
; H040+$00000210: 4e550000  link.w a5, #$0
        link.w a5, #$0
L040_00000214:
; H040+$00000214: 60000446  bra.w $65c
        bra.w H040+$65C
;
; --------------------------------------------------------------------------
; ROUTINE: IFF_FORM_ILBM [verificato]
; Scopo: Callback che gestisce FORM ILBM e i suoi chunk grafici.
;   - Verifica il tipo ILBM; per altri FORM percorre la struttura generica.
;   - BMHD riempie il bitmap header, CMAP carica i colori.
;   - BODY richiede un BMHD già letto, prepara la bitmap e la memoria dei piani.
;   - Il percorso limita il numero di piani utilizzati a cinque.
;   - H087+$0166 trasferisce/decomprime le righe del BODY.
; --------------------------------------------------------------------------
L040_00000218:
; H040+$00000218: 4e55ff62  link.w a5, #$ff62
        link.w a5, #$ff62
L040_0000021C:
; H040+$0000021C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L040_00000220:
; H040+$00000220: 0cab494c424d001c  cmpi.l #$494c424d, $1c(a3)
        cmpi.l #$494c424d, $1c(a3)
L040_00000228:
; H040+$00000228: 6700005e  beq.w $288
        beq.w H040+$288
L040_0000022C:
; H040+$0000022C: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L040_00000230:
; H040+$00000230: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$015C (sub_H086_0000015C)
L040_00000234:
; H040+$00000234: 4eb90000015c  jsr $15c.l
        jsr (H086+$15C).l
L040_0000023A:
; H040+$0000023A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_0000023E:
; H040+$0000023E: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L040_00000242:
; H040+$00000242: 6700000a  beq.w $24e
        beq.w H040+$24E
L040_00000246:
; H040+$00000246: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_0000024A:
; H040+$0000024A: 60000262  bra.w $4ae
        bra.w H040+$4AE
L040_0000024E:
; H040+$0000024E: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$0714 (sub_H086_00000714)
L040_00000252:
; H040+$00000252: 4eb900000714  jsr $714.l
        jsr (H086+$714).l
L040_00000258:
; H040+$00000258: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_0000025C:
; H040+$0000025C: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L040_00000260:
; H040+$00000260: 6cec  bge.b $24e
        bge.b H040+$24E
L040_00000262:
; H040+$00000262: 0cadfffffffffffc  cmpi.l #$ffffffff, -$4(a5)
        cmpi.l #$ffffffff, -$4(a5)
L040_0000026A:
; H040+$0000026A: 66000006  bne.w $272
        bne.w H040+$272
L040_0000026E:
; H040+$0000026E: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L040_00000272:
; H040+$00000272: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$01F8 (sub_H086_000001F8)
L040_00000276:
; H040+$00000276: 4eb9000001f8  jsr $1f8.l
        jsr (H086+$1F8).l
L040_0000027C:
; H040+$0000027C: 2b40ff66  move.l d0, -$9a(a5)
        move.l d0, -$9a(a5)
L040_00000280:
; H040+$00000280: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_00000284:
; H040+$00000284: 60000228  bra.w $4ae
        bra.w H040+$4AE
L040_00000288:
; H040+$00000288: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L040_0000028C:
; H040+$0000028C: 2b6b0004ff62  move.l $4(a3), -$9e(a5)
        move.l $4(a3), -$9e(a5)
L040_00000292:
; H040+$00000292: 266dff62  movea.l -$9e(a5), a3
        movea.l -$9e(a5), a3
L040_00000296:
; H040+$00000296: 45edff72  lea.l -$8e(a5), a2
        lea.l -$8e(a5), a2
L040_0000029A:
; H040+$0000029A: 7432  moveq #$32, d2
        moveq #50, d2
L040_0000029C:
; H040+$0000029C: 34db  move.w (a3)+, (a2)+
        move.w (a3)+, (a2)+
L040_0000029E:
; H040+$0000029E: 51cafffc  dbra d2, $29c
        dbra d2, H040+$29C
L040_000002A2:
; H040+$000002A2: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L040_000002A6:
; H040+$000002A6: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$015C (sub_H086_0000015C)
L040_000002AA:
; H040+$000002AA: 4eb90000015c  jsr $15c.l
        jsr (H086+$15C).l
L040_000002B0:
; H040+$000002B0: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_000002B4:
; H040+$000002B4: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L040_000002B8:
; H040+$000002B8: 6700000a  beq.w $2c4
        beq.w H040+$2C4
L040_000002BC:
; H040+$000002BC: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_000002C0:
; H040+$000002C0: 600001ec  bra.w $4ae
        bra.w H040+$4AE
L040_000002C4:
; H040+$000002C4: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$06D6 (sub_H086_000006D6)
L040_000002C8:
; H040+$000002C8: 4eb9000006d6  jsr $6d6.l
        jsr (H086+$6D6).l
L040_000002CE:
; H040+$000002CE: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
; PASSO: Chunk BMHD: descrizione di larghezza, altezza, piani, maschera e compressione.
L040_000002D2:
; H040+$000002D2: 0cad424d4844fffc  cmpi.l #$424d4844, -$4(a5)
        cmpi.l #$424d4844, -$4(a5)
L040_000002DA:
; H040+$000002DA: 6600001e  bne.w $2fa
        bne.w H040+$2FA
L040_000002DE:
; H040+$000002DE: 1b7c0001ff82  move.b #$1, -$7e(a5)
        move.b #$1, -$7e(a5)
L040_000002E4:
; H040+$000002E4: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L040_000002E8:
; H040+$000002E8: 486dff84  pea.l -$7c(a5)
        pea.l -$7c(a5)
; -> H087+$000C (trampoline_H087_0028)
L040_000002EC:
; H040+$000002EC: 4eb90000000c  jsr $c.l
        jsr (H087+$C).l
L040_000002F2:
; H040+$000002F2: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_000002F6:
; H040+$000002F6: 60000184  bra.w $47c
        bra.w H040+$47C
; PASSO: Chunk CMAP: palette dell’immagine.
L040_000002FA:
; H040+$000002FA: 0cad434d4150fffc  cmpi.l #$434d4150, -$4(a5)
        cmpi.l #$434d4150, -$4(a5)
L040_00000302:
; H040+$00000302: 66000024  bne.w $328
        bne.w H040+$328
L040_00000306:
; H040+$00000306: 1b7c0020ff83  move.b #$20, -$7d(a5)
        move.b #$20, -$7d(a5)
L040_0000030C:
; H040+$0000030C: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L040_00000310:
; H040+$00000310: 47edff98  lea.l -$68(a5), a3
        lea.l -$68(a5), a3
L040_00000314:
; H040+$00000314: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L040_00000316:
; H040+$00000316: 486dff83  pea.l -$7d(a5)
        pea.l -$7d(a5)
; -> H087+$009C (sub_H087_0000009C)
L040_0000031A:
; H040+$0000031A: 4eb90000009c  jsr $9c.l
        jsr (H087+$9C).l
L040_00000320:
; H040+$00000320: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_00000324:
; H040+$00000324: 60000156  bra.w $47c
        bra.w H040+$47C
; PASSO: Chunk BODY: pixel planari; richiede il bitmap header già acquisito.
L040_00000328:
; H040+$00000328: 0cad424f4459fffc  cmpi.l #$424f4459, -$4(a5)
        cmpi.l #$424f4459, -$4(a5)
L040_00000330:
; H040+$00000330: 66000136  bne.w $468
        bne.w H040+$468
L040_00000334:
; H040+$00000334: 4a2dff82  tst.b -$7e(a5)
        tst.b -$7e(a5)
L040_00000338:
; H040+$00000338: 66000008  bne.w $342
        bne.w H040+$342
L040_0000033C:
; H040+$0000033C: 70f9  moveq #$f9, d0
        moveq #-7, d0
L040_0000033E:
; H040+$0000033E: 6000016e  bra.w $4ae
        bra.w H040+$4AE
L040_00000342:
; H040+$00000342: 7400  moveq #$0, d2
        moveq #0, d2
L040_00000344:
; H040+$00000344: 142dff8c  move.b -$74(a5), d2
        move.b -$74(a5), d2
L040_00000348:
; H040+$00000348: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L040_0000034C:
; H040+$0000034C: 6400000c  bcc.w $35a
        bcc.w H040+$35A
L040_00000350:
; H040+$00000350: 1b6dff8cff6b  move.b -$74(a5), -$95(a5)
        move.b -$74(a5), -$95(a5)
L040_00000356:
; H040+$00000356: 60000008  bra.w $360
        bra.w H040+$360
L040_0000035A:
; H040+$0000035A: 1b7c0005ff6b  move.b #$5, -$95(a5)
        move.b #$5, -$95(a5)
L040_00000360:
; H040+$00000360: 2f3900000204  move.l $204.l, -(a7)
        move.l (H040+$204).l, -(a7)
L040_00000366:
; H040+$00000366: 7400  moveq #$0, d2
        moveq #0, d2
L040_00000368:
; H040+$00000368: 142dff6b  move.b -$95(a5), d2
        move.b -$95(a5), d2
L040_0000036C:
; H040+$0000036C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L040_0000036E:
; H040+$0000036E: 3f2dff84  move.w -$7c(a5), -(a7)
        move.w -$7c(a5), -(a7)
L040_00000372:
; H040+$00000372: 3f2dff86  move.w -$7a(a5), -(a7)
        move.w -$7a(a5), -(a7)
; -> H037+$0014 (wrapper_InitBitMap)
L040_00000376:
; H040+$00000376: 4eb900000014  jsr $14.l
        jsr (H037+$14).l
L040_0000037C:
; H040+$0000037C: 3f2dff84  move.w -$7c(a5), -(a7)
        move.w -$7c(a5), -(a7)
; -> H054+$000C (trampoline_H054_0028)
L040_00000380:
; H040+$00000380: 4eb90000000c  jsr $c.l
        jsr (H054+$C).l
L040_00000386:
; H040+$00000386: 3400  move.w d0, d2
        move.w d0, d2
L040_00000388:
; H040+$00000388: c4edff86  mulu.w -$7a(a5), d2
        mulu.w -$7a(a5), d2
L040_0000038C:
; H040+$0000038C: 2b42ff6c  move.l d2, -$94(a5)
        move.l d2, -$94(a5)
L040_00000390:
; H040+$00000390: 7400  moveq #$0, d2
        moveq #0, d2
L040_00000392:
; H040+$00000392: 142dff6b  move.b -$95(a5), d2
        move.b -$95(a5), d2
L040_00000396:
; H040+$00000396: 2002  move.l d2, d0
        move.l d2, d0
L040_00000398:
; H040+$00000398: 222dff6c  move.l -$94(a5), d1
        move.l -$94(a5), d1
; -> H015+$004A (sub_H015_0000004A)
L040_0000039C:
; H040+$0000039C: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L040_000003A2:
; H040+$000003A2: 2f00  move.l d0, -(a7)
        move.l d0, -(a7)
L040_000003A4:
; H040+$000003A4: 267900000208  movea.l $208.l, a3
        movea.l (H040+$208).l, a3
; PASSO: Callback di allocazione della memoria dei piani: indirizzo registrato da Read_ILBM.
L040_000003AA:
; H040+$000003AA: 4e93  jsr (a3)
        jsr (a3)
L040_000003AC:
; H040+$000003AC: 267900000204  movea.l $204.l, a3
        movea.l (H040+$204).l, a3
L040_000003B2:
; H040+$000003B2: 27400008  move.l d0, $8(a3)
        move.l d0, $8(a3)
L040_000003B6:
; H040+$000003B6: 267900000204  movea.l $204.l, a3
        movea.l (H040+$204).l, a3
L040_000003BC:
; H040+$000003BC: 4aab0008  tst.l $8(a3)
        tst.l $8(a3)
L040_000003C0:
; H040+$000003C0: 6700009a  beq.w $45c
        beq.w H040+$45C
L040_000003C4:
; H040+$000003C4: 3b7c0001ff70  move.w #$1, -$90(a5)
        move.w #$1, -$90(a5)
L040_000003CA:
; H040+$000003CA: 7400  moveq #$0, d2
        moveq #0, d2
L040_000003CC:
; H040+$000003CC: 142dff6b  move.b -$95(a5), d2
        move.b -$95(a5), d2
L040_000003D0:
; H040+$000003D0: 382dff70  move.w -$90(a5), d4
        move.w -$90(a5), d4
L040_000003D4:
; H040+$000003D4: b842  cmp.w d2, d4
        cmp.w d2, d4
L040_000003D6:
; H040+$000003D6: 6c000034  bge.w $40c
        bge.w H040+$40C
L040_000003DA:
; H040+$000003DA: 267900000204  movea.l $204.l, a3
        movea.l (H040+$204).l, a3
L040_000003E0:
; H040+$000003E0: 342dff70  move.w -$90(a5), d2
        move.w -$90(a5), d2
L040_000003E4:
; H040+$000003E4: e542  asl.w #$2, d2
        asl.w #$2, d2
L040_000003E6:
; H040+$000003E6: 45eb0008  lea.l $8(a3), a2
        lea.l $8(a3), a2
L040_000003EA:
; H040+$000003EA: 382dff70  move.w -$90(a5), d4
        move.w -$90(a5), d4
L040_000003EE:
; H040+$000003EE: 48c4  ext.l d4
        ext.l d4
L040_000003F0:
; H040+$000003F0: 2004  move.l d4, d0
        move.l d4, d0
L040_000003F2:
; H040+$000003F2: 222dff6c  move.l -$94(a5), d1
        move.l -$94(a5), d1
; -> H015+$004A (sub_H015_0000004A)
L040_000003F6:
; H040+$000003F6: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L040_000003FC:
; H040+$000003FC: 2800  move.l d0, d4
        move.l d0, d4
L040_000003FE:
; H040+$000003FE: d8ab0008  add.l $8(a3), d4
        add.l $8(a3), d4
L040_00000402:
; H040+$00000402: 25842000  move.l d4, (a2, d2.w)
        move.l d4, (a2, d2.w)
L040_00000406:
; H040+$00000406: 526dff70  addq.w #$1, -$90(a5)
        addq.w #$1, -$90(a5)
L040_0000040A:
; H040+$0000040A: 60be  bra.b $3ca
        bra.b H040+$3CA
L040_0000040C:
; H040+$0000040C: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L040_00000410:
; H040+$00000410: 2f3900000204  move.l $204.l, -(a7)
        move.l (H040+$204).l, -(a7)
L040_00000416:
; H040+$00000416: 42a7  clr.l -(a7)
        clr.l -(a7)
L040_00000418:
; H040+$00000418: 486dff84  pea.l -$7c(a5)
        pea.l -$7c(a5)
L040_0000041C:
; H040+$0000041C: 47f900000000  lea.l $0.l, a3
        lea.l (H040+$0).l, a3
L040_00000422:
; H040+$00000422: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L040_00000424:
; H040+$00000424: 243c00000200  move.l #$200, d2
        move.l #$200, d2
L040_0000042A:
; H040+$0000042A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; PASSO: Lettura del BODY, con eventuale decompressione per riga/piano.
; FLUSSO: Chiama Read_ILBM_BODY (H087+$0166).
L040_0000042C:
; H040+$0000042C: 4eb900000166  jsr $166.l
        jsr (H087+$166).l
L040_00000432:
; H040+$00000432: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_00000436:
; H040+$00000436: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L040_0000043A:
; H040+$0000043A: 6600000a  bne.w $446
        bne.w H040+$446
L040_0000043E:
; H040+$0000043E: 2b7cfffffffefffc  move.l #$fffffffe, -$4(a5)
        move.l #$fffffffe, -$4(a5)
L040_00000446:
; H040+$00000446: 47edff72  lea.l -$8e(a5), a3
        lea.l -$8e(a5), a3
L040_0000044A:
; H040+$0000044A: 247900000200  movea.l $200.l, a2
        movea.l (H040+$200).l, a2
L040_00000450:
; H040+$00000450: 7432  moveq #$32, d2
        moveq #50, d2
L040_00000452:
; H040+$00000452: 34db  move.w (a3)+, (a2)+
        move.w (a3)+, (a2)+
L040_00000454:
; H040+$00000454: 51cafffc  dbra d2, $452
        dbra d2, H040+$452
L040_00000458:
; H040+$00000458: 6000000a  bra.w $464
        bra.w H040+$464
L040_0000045C:
; H040+$0000045C: 2b7cfffffffafffc  move.l #$fffffffa, -$4(a5)
        move.l #$fffffffa, -$4(a5)
L040_00000464:
; H040+$00000464: 60000016  bra.w $47c
        bra.w H040+$47C
L040_00000468:
; H040+$00000468: 0cadfffffffffffc  cmpi.l #$ffffffff, -$4(a5)
        cmpi.l #$ffffffff, -$4(a5)
L040_00000470:
; H040+$00000470: 6600000a  bne.w $47c
        bne.w H040+$47C
L040_00000474:
; H040+$00000474: 2b7cfffffff9fffc  move.l #$fffffff9, -$4(a5)
        move.l #$fffffff9, -$4(a5)
L040_0000047C:
; H040+$0000047C: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L040_00000480:
; H040+$00000480: 6c00fe42  bge.w $2c4
        bge.w H040+$2C4
L040_00000484:
; H040+$00000484: 0cadfffffffefffc  cmpi.l #$fffffffe, -$4(a5)
        cmpi.l #$fffffffe, -$4(a5)
L040_0000048C:
; H040+$0000048C: 6700000a  beq.w $498
        beq.w H040+$498
L040_00000490:
; H040+$00000490: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_00000494:
; H040+$00000494: 60000018  bra.w $4ae
        bra.w H040+$4AE
L040_00000498:
; H040+$00000498: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$01F8 (sub_H086_000001F8)
L040_0000049C:
; H040+$0000049C: 4eb9000001f8  jsr $1f8.l
        jsr (H086+$1F8).l
L040_000004A2:
; H040+$000004A2: 2b40ff66  move.l d0, -$9a(a5)
        move.l d0, -$9a(a5)
L040_000004A6:
; H040+$000004A6: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_000004AA:
; H040+$000004AA: 60000002  bra.w $4ae
        bra.w H040+$4AE
L040_000004AE:
; H040+$000004AE: 4e5d  unlk a5
        unlk a5
L040_000004B0:
; H040+$000004B0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L040_000004B2:
; H040+$000004B2: 588f  addq.l #$4, a7
        addq.l #$4, a7
L040_000004B4:
; H040+$000004B4: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: IFF_PROP_ILBM [verificato]
; Scopo: Callback per proprietà ILBM ereditate da un gruppo IFF.
;   - Accetta il tipo ILBM.
;   - Riconosce BMHD e CMAP e aggiorna la struttura delle proprietà.
;   - Il parser generico gestisce il passaggio al chunk successivo.
; --------------------------------------------------------------------------
L040_000004B6:
; H040+$000004B6: 4e55ffd0  link.w a5, #$ffd0
        link.w a5, #$ffd0
L040_000004BA:
; H040+$000004BA: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L040_000004BE:
; H040+$000004BE: 2b6b0004ffd4  move.l $4(a3), -$2c(a5)
        move.l $4(a3), -$2c(a5)
L040_000004C4:
; H040+$000004C4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L040_000004C8:
; H040+$000004C8: 0cab494c424d001c  cmpi.l #$494c424d, $1c(a3)
        cmpi.l #$494c424d, $1c(a3)
L040_000004D0:
; H040+$000004D0: 67000008  beq.w $4da
        beq.w H040+$4DA
L040_000004D4:
; H040+$000004D4: 7000  moveq #$0, d0
        moveq #0, d0
L040_000004D6:
; H040+$000004D6: 600000ca  bra.w $5a2
        bra.w H040+$5A2
L040_000004DA:
; H040+$000004DA: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L040_000004DE:
; H040+$000004DE: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$015C (sub_H086_0000015C)
L040_000004E2:
; H040+$000004E2: 4eb90000015c  jsr $15c.l
        jsr (H086+$15C).l
L040_000004E8:
; H040+$000004E8: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_000004EC:
; H040+$000004EC: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L040_000004F0:
; H040+$000004F0: 6700000a  beq.w $4fc
        beq.w H040+$4FC
L040_000004F4:
; H040+$000004F4: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_000004F8:
; H040+$000004F8: 600000a8  bra.w $5a2
        bra.w H040+$5A2
L040_000004FC:
; H040+$000004FC: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$07C0 (sub_H086_000007C0)
L040_00000500:
; H040+$00000500: 4eb9000007c0  jsr $7c0.l
        jsr (H086+$7C0).l
L040_00000506:
; H040+$00000506: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_0000050A:
; H040+$0000050A: 0cad424d4844fffc  cmpi.l #$424d4844, -$4(a5)
        cmpi.l #$424d4844, -$4(a5)
L040_00000512:
; H040+$00000512: 66000026  bne.w $53a
        bne.w H040+$53A
L040_00000516:
; H040+$00000516: 266dffd4  movea.l -$2c(a5), a3
        movea.l -$2c(a5), a3
L040_0000051A:
; H040+$0000051A: 177c00010010  move.b #$1, $10(a3)
        move.b #$1, $10(a3)
L040_00000520:
; H040+$00000520: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L040_00000524:
; H040+$00000524: 266dffd4  movea.l -$2c(a5), a3
        movea.l -$2c(a5), a3
L040_00000528:
; H040+$00000528: 486b0012  pea.l $12(a3)
        pea.l $12(a3)
; -> H087+$000C (trampoline_H087_0028)
L040_0000052C:
; H040+$0000052C: 4eb90000000c  jsr $c.l
        jsr (H087+$C).l
L040_00000532:
; H040+$00000532: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_00000536:
; H040+$00000536: 60000038  bra.w $570
        bra.w H040+$570
L040_0000053A:
; H040+$0000053A: 0cad434d4150fffc  cmpi.l #$434d4150, -$4(a5)
        cmpi.l #$434d4150, -$4(a5)
L040_00000542:
; H040+$00000542: 6600002c  bne.w $570
        bne.w H040+$570
L040_00000546:
; H040+$00000546: 266dffd4  movea.l -$2c(a5), a3
        movea.l -$2c(a5), a3
L040_0000054A:
; H040+$0000054A: 177c00200011  move.b #$20, $11(a3)
        move.b #$20, $11(a3)
L040_00000550:
; H040+$00000550: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L040_00000554:
; H040+$00000554: 266dffd4  movea.l -$2c(a5), a3
        movea.l -$2c(a5), a3
L040_00000558:
; H040+$00000558: 47eb0026  lea.l $26(a3), a3
        lea.l $26(a3), a3
L040_0000055C:
; H040+$0000055C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L040_0000055E:
; H040+$0000055E: 266dffd4  movea.l -$2c(a5), a3
        movea.l -$2c(a5), a3
L040_00000562:
; H040+$00000562: 486b0011  pea.l $11(a3)
        pea.l $11(a3)
; -> H087+$009C (sub_H087_0000009C)
L040_00000566:
; H040+$00000566: 4eb90000009c  jsr $9c.l
        jsr (H087+$9C).l
L040_0000056C:
; H040+$0000056C: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_00000570:
; H040+$00000570: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L040_00000574:
; H040+$00000574: 6c86  bge.b $4fc
        bge.b H040+$4FC
L040_00000576:
; H040+$00000576: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H086+$01F8 (sub_H086_000001F8)
L040_0000057A:
; H040+$0000057A: 4eb9000001f8  jsr $1f8.l
        jsr (H086+$1F8).l
L040_00000580:
; H040+$00000580: 2b40ffd0  move.l d0, -$30(a5)
        move.l d0, -$30(a5)
L040_00000584:
; H040+$00000584: 0cadfffffffffffc  cmpi.l #$ffffffff, -$4(a5)
        cmpi.l #$ffffffff, -$4(a5)
L040_0000058C:
; H040+$0000058C: 6600000c  bne.w $59a
        bne.w H040+$59A
L040_00000590:
; H040+$00000590: 7000  moveq #$0, d0
        moveq #0, d0
L040_00000592:
; H040+$00000592: 6000000e  bra.w $5a2
        bra.w H040+$5A2
; Preserved bytes H040+$00000596..$0000059A; code/data not fully classified.
        dc.w $6000,$000A
L040_0000059A:
; H040+$0000059A: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_0000059E:
; H040+$0000059E: 60000002  bra.w $5a2
        bra.w H040+$5A2
L040_000005A2:
; H040+$000005A2: 4e5d  unlk a5
        unlk a5
L040_000005A4:
; H040+$000005A4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L040_000005A6:
; H040+$000005A6: 588f  addq.l #$4, a7
        addq.l #$4, a7
L040_000005A8:
; H040+$000005A8: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: IFF_LIST [verificato]
; Scopo: Callback di attraversamento LIST del parser IFF.
;   - Copia il contesto delle proprietà e passa la visita al parser generico.
;   - Le proprietà possono essere ereditate dai FORM contenuti.
; --------------------------------------------------------------------------
L040_000005AA:
; H040+$000005AA: 4e55ff96  link.w a5, #$ff96
        link.w a5, #$ff96
L040_000005AE:
; H040+$000005AE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L040_000005B2:
; H040+$000005B2: 2b6b0004ff96  move.l $4(a3), -$6a(a5)
        move.l $4(a3), -$6a(a5)
L040_000005B8:
; H040+$000005B8: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L040_000005BC:
; H040+$000005BC: 45edff9a  lea.l -$66(a5), a2
        lea.l -$66(a5), a2
L040_000005C0:
; H040+$000005C0: 7432  moveq #$32, d2
        moveq #50, d2
L040_000005C2:
; H040+$000005C2: 34db  move.w (a3)+, (a2)+
        move.w (a3)+, (a2)+
L040_000005C4:
; H040+$000005C4: 51cafffc  dbra d2, $5c2
        dbra d2, H040+$5C2
L040_000005C8:
; H040+$000005C8: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L040_000005CC:
; H040+$000005CC: 47edff9a  lea.l -$66(a5), a3
        lea.l -$66(a5), a3
L040_000005D0:
; H040+$000005D0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H086+$0578 (sub_H086_00000578)
L040_000005D2:
; H040+$000005D2: 4eb900000578  jsr $578.l
        jsr (H086+$578).l
L040_000005D8:
; H040+$000005D8: 60000002  bra.w $5dc
        bra.w H040+$5DC
L040_000005DC:
; H040+$000005DC: 4e5d  unlk a5
        unlk a5
L040_000005DE:
; H040+$000005DE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L040_000005E0:
; H040+$000005E0: 588f  addq.l #$4, a7
        addq.l #$4, a7
L040_000005E2:
; H040+$000005E2: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Read_ILBM [verificato]
; Scopo: Configura il parser IFF e legge un’immagine ILBM.
;   - Registra le callback LIST, PROP, FORM e CAT nella struttura del parser.
;   - Conserva i puntatori di output alla bitmap e il callback di allocazione.
;   - Delega il riconoscimento dei gruppi al parser generico H086+$04BA.
; Chiamanti diretti: H007+$057A, H028+$0CEC, H030+$0C54
; --------------------------------------------------------------------------
L040_000005E4:
; H040+$000005E4: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L040_000005E8:
; H040+$000005E8: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L040_000005EC:
; H040+$000005EC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L040_000005F0:
; H040+$000005F0: 45d3  lea.l (a3), a2
        lea.l (a3), a2
L040_000005F2:
; H040+$000005F2: 43faffb6  lea.l $5aa(pc), a1
        lea.l H040+$5AA(pc), a1
L040_000005F6:
; H040+$000005F6: 2489  move.l a1, (a2)
        move.l a1, (a2)
L040_000005F8:
; H040+$000005F8: 43fafebc  lea.l $4b6(pc), a1
        lea.l H040+$4B6(pc), a1
L040_000005FC:
; H040+$000005FC: 25490004  move.l a1, $4(a2)
        move.l a1, $4(a2)
L040_00000600:
; H040+$00000600: 43fafc16  lea.l $218(pc), a1
        lea.l H040+$218(pc), a1
L040_00000604:
; H040+$00000604: 25490008  move.l a1, $8(a2)
        move.l a1, $8(a2)
L040_00000608:
; H040+$00000608: 43f9000006bc  lea.l $6bc.l, a1
        lea.l (H086+$6BC).l, a1
L040_0000060E:
; H040+$0000060E: 2549000c  move.l a1, $c(a2)
        move.l a1, $c(a2)
L040_00000612:
; H040+$00000612: 422b0010  clr.b $10(a3)
        clr.b $10(a3)
L040_00000616:
; H040+$00000616: 422b0011  clr.b $11(a3)
        clr.b $11(a3)
L040_0000061A:
; H040+$0000061A: 23ed000800000208  move.l $8(a5), $208.l
        move.l $8(a5), (H040+$208).l
L040_00000622:
; H040+$00000622: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L040_00000626:
; H040+$00000626: 23cb00000204  move.l a3, $204.l
        move.l a3, (H040+$204).l
L040_0000062C:
; H040+$0000062C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L040_00000630:
; H040+$00000630: 23cb00000200  move.l a3, $200.l
        move.l a3, (H040+$200).l
L040_00000636:
; H040+$00000636: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L040_0000063A:
; H040+$0000063A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L040_0000063E:
; H040+$0000063E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H086+$04BA (sub_H086_000004BA)
L040_00000640:
; H040+$00000640: 4eb9000004ba  jsr $4ba.l
        jsr (H086+$4BA).l
L040_00000646:
; H040+$00000646: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L040_0000064A:
; H040+$0000064A: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L040_0000064E:
; H040+$0000064E: 60000002  bra.w $652
        bra.w H040+$652
L040_00000652:
; H040+$00000652: 4e5d  unlk a5
        unlk a5
L040_00000654:
; H040+$00000654: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L040_00000656:
; H040+$00000656: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L040_0000065A:
; H040+$0000065A: 4ed0  jmp (a0)
        jmp (a0)
L040_0000065C:
; H040+$0000065C: 4e5d  unlk a5
        unlk a5
L040_0000065E:
; H040+$0000065E: 4e75  rts 
        rts 
; End H040: $660 bytes
