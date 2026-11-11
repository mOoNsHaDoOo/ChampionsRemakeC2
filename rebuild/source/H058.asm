; ============================================================================
; GUIDA DEL MODULO H058
; Riposo e memorizzazione/recupero; dettaglio parziale.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Riposo e memorizzazione/recupero: gestisce il riposo del party, il passaggio del tempo e il salvataggio/caricamento locale.
; --------------------------------------------------------------------------
; H058: 4720 original bytes; all offsets are section-relative.
        section H058,code
H058:
; Preserved bytes H058+$00000000..$000000CE; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$5265,$7374,$2054,$696D
        dc.w $6520,$3A20,$0020,$3A20,$0000,$0052,$6573,$7420
        dc.w $4461,$7973,$2048,$6F75,$7273,$204D,$696E,$7320
        dc.w $4164,$6420,$5375,$6274,$7261,$6374,$2045,$7869
        dc.w $7400,$5468,$6520,$7768,$6F6C,$6520,$5061,$7274
        dc.w $7920,$4973,$2048,$6561,$6C65,$6400,$6861,$7320
        dc.w $6D65,$6D6F,$7269,$7A65,$6400,$6861,$7320,$7363
        dc.w $7269,$6265,$6400,$5374,$6F70,$2052,$6573,$7469
        dc.w $6E67,$3F20,$0059,$6F75,$7220,$7265,$706F,$7365
        dc.w $2069,$7320,$7375,$6464,$656E,$6C79,$2069,$6E74
        dc.w $6572,$7275,$7074,$6564,$2100
        dc.l H058+$00000028
; --------------------------------------------------------------------------
; ROUTINE: module_init_H058 [parziale]
; Scopo: Ingresso del modulo riposo e memorizzazione/recupero; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H058+$1268.
; Chiamanti diretti: H000+$01F8
; --------------------------------------------------------------------------
L058_000000CE:
; H058+$000000CE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_000000D0:
; H058+$000000D0: 287afff8  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_000000D4:
; H058+$000000D4: 4e550000  link.w a5, #$0
        link.w a5, #$0
L058_000000D8:
; H058+$000000D8: 6000118e  bra.w $1268
        bra.w H058+$1268
; Preserved bytes H058+$000000DC..$0000017C; code/data not fully classified.
        dc.w $2F0C,$287A,$FFEA,$4E55,$0000,$2679
        dc.l H005+$00003E04
        dc.w $376D,$0018,$018C,$2679
        dc.l H005+$00003E04
        dc.w $376D,$0016,$018E,$2679
        dc.l H005+$00003E04
        dc.w $376D,$0014,$0190,$2679
        dc.l H005+$00003E04
        dc.w $376D,$0012,$0192,$2679
        dc.l H005+$00003E04
        dc.w $376D,$0010,$0194,$2679
        dc.l H005+$00003E04
        dc.w $376D,$000E,$0196,$342D,$000C,$1F02,$3F3C,$00FF
        dc.w $4EB9
        dc.l H029+$00000354
        dc.w $1400,$0242,$00FF,$2679
        dc.l H005+$00003E04
        dc.w $3742,$0198,$342D,$000C,$E04A,$1F02,$3F3C,$00FF
        dc.w $4EB9
        dc.l H029+$00000354
        dc.w $1400,$0242,$00FF,$2679
        dc.l H005+$00003E04
        dc.w $3742,$019A,$4E5D,$285F,$205F,$4FEF,$000E,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H058_02C4 [parziale]
; Scopo: Trampolino verso H058+$02C4; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H058+$02C4.
; Chiamanti diretti: H058+$05B6
; --------------------------------------------------------------------------
L058_0000017C:
; H058+$0000017C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_0000017E:
; H058+$0000017E: 287aff4a  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000182:
; H058+$00000182: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L058_00000186:
; H058+$00000186: 6000013c  bra.w $2c4
        bra.w H058+$2C4
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_0000018A [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H034+$0178.
;   - Richiama H034+$0178.
;   - Usa lo stato globale: H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H058+$02CE, H058+$02DC, H058+$02EA
; --------------------------------------------------------------------------
L058_0000018A:
; H058+$0000018A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L058_0000018E:
; H058+$0000018E: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L058_00000192:
; H058+$00000192: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_00000194:
; H058+$00000194: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_0000019A:
; H058+$0000019A: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L058_0000019E:
; H058+$0000019E: b86d000c  cmp.w $c(a5), d4
        cmp.w $c(a5), d4
L058_000001A2:
; H058+$000001A2: 65000108  bcs.w $2ac
        bcs.w H058+$2AC
L058_000001A6:
; H058+$000001A6: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L058_000001AA:
; H058+$000001AA: 5742  subq.w #$3, d2
        subq.w #$3, d2
L058_000001AC:
; H058+$000001AC: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_000001AE:
; H058+$000001AE: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_000001B4:
; H058+$000001B4: 0c7300032000  cmpi.w #$3, (a3, d2.w)
        cmpi.w #$3, (a3, d2.w)
L058_000001BA:
; H058+$000001BA: 65000018  bcs.w $1d4
        bcs.w H058+$1D4
L058_000001BE:
; H058+$000001BE: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L058_000001C2:
; H058+$000001C2: 5742  subq.w #$3, d2
        subq.w #$3, d2
L058_000001C4:
; H058+$000001C4: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_000001C6:
; H058+$000001C6: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_000001CC:
; H058+$000001CC: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L058_000001D0:
; H058+$000001D0: 60000014  bra.w $1e6
        bra.w H058+$1E6
L058_000001D4:
; H058+$000001D4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L058_000001D8:
; H058+$000001D8: 5742  subq.w #$3, d2
        subq.w #$3, d2
L058_000001DA:
; H058+$000001DA: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_000001DC:
; H058+$000001DC: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_000001E2:
; H058+$000001E2: 52732000  addq.w #$1, (a3, d2.w)
        addq.w #$1, (a3, d2.w)
L058_000001E6:
; H058+$000001E6: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L058_000001EA:
; H058+$000001EA: 60000070  bra.w $25c
        bra.w H058+$25C
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_000001EE:
; H058+$000001EE: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_000001F4:
; H058+$000001F4: 342b03f2  move.w $3f2(a3), d2
        move.w $3f2(a3), d2
L058_000001F8:
; H058+$000001F8: 0642000a  addi.w #$a, d2
        addi.w #$a, d2
L058_000001FC:
; H058+$000001FC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_00000200:
; H058+$00000200: 3742fffa  move.w d2, -$6(a3)
        move.w d2, -$6(a3)
L058_00000204:
; H058+$00000204: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_00000208:
; H058+$00000208: 377c0008fffc  move.w #$8, -$4(a3)
        move.w #$8, -$4(a3)
L058_0000020E:
; H058+$0000020E: 4e75  rts 
        rts 
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_00000210:
; H058+$00000210: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_00000216:
; H058+$00000216: 342b03f4  move.w $3f4(a3), d2
        move.w $3f4(a3), d2
L058_0000021A:
; H058+$0000021A: 5c42  addq.w #$6, d2
        addq.w #$6, d2
L058_0000021C:
; H058+$0000021C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_00000220:
; H058+$00000220: 3742fffa  move.w d2, -$6(a3)
        move.w d2, -$6(a3)
L058_00000224:
; H058+$00000224: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_00000228:
; H058+$00000228: 377c0013fffc  move.w #$13, -$4(a3)
        move.w #$13, -$4(a3)
L058_0000022E:
; H058+$0000022E: 4e75  rts 
        rts 
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_00000230:
; H058+$00000230: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_00000236:
; H058+$00000236: 342b03f6  move.w $3f6(a3), d2
        move.w $3f6(a3), d2
L058_0000023A:
; H058+$0000023A: 0642000e  addi.w #$e, d2
        addi.w #$e, d2
L058_0000023E:
; H058+$0000023E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_00000242:
; H058+$00000242: 3742fffa  move.w d2, -$6(a3)
        move.w d2, -$6(a3)
L058_00000246:
; H058+$00000246: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_0000024A:
; H058+$0000024A: 377c001efffc  move.w #$1e, -$4(a3)
        move.w #$1e, -$4(a3)
L058_00000250:
; H058+$00000250: 4e75  rts 
        rts 
L058_00000252:
; H058+$00000252: 4e75  rts 
        rts 
; Preserved bytes H058+$00000254..$0000025C; code/data not fully classified.
        dc.w $FFFC,$FF98,$FFBA,$FFDA
L058_0000025C:
; H058+$0000025C: 47fafff8  lea.l $256(pc), a3
        lea.l H058+$256(pc), a3
L058_00000260:
; H058+$00000260: 044201fc  subi.w #$1fc, d2
        subi.w #$1fc, d2
L058_00000264:
; H058+$00000264: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L058_00000268:
; H058+$00000268: 6302  bls.b $26c
        bls.b H058+$26C
L058_0000026A:
; H058+$0000026A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L058_0000026C:
; H058+$0000026C: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_0000026E:
; H058+$0000026E: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H058+$0256; indici 0..2, default -1.
L058_00000272:
; H058+$00000272: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L058_00000276:
; H058+$00000276: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_0000027A:
; H058+$0000027A: 3f2bfffc  move.w -$4(a3), -(a7)
        move.w -$4(a3), -(a7)
L058_0000027E:
; H058+$0000027E: 4267  clr.w -(a7)
        clr.w -(a7)
L058_00000280:
; H058+$00000280: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L058_00000284:
; H058+$00000284: 342bfffa  move.w -$6(a3), d2
        move.w -$6(a3), d2
L058_00000288:
; H058+$00000288: 06420114  addi.w #$114, d2
        addi.w #$114, d2
L058_0000028C:
; H058+$0000028C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L058_0000028E:
; H058+$0000028E: 4227  clr.b -(a7)
        clr.b -(a7)
L058_00000290:
; H058+$00000290: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L058_00000292:
; H058+$00000292: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L058_00000298:
; H058+$00000298: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L058_0000029C:
; H058+$0000029C: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_0000029E:
; H058+$0000029E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_000002A4:
; H058+$000002A4: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L058_000002A8:
; H058+$000002A8: 60000012  bra.w $2bc
        bra.w H058+$2BC
L058_000002AC:
; H058+$000002AC: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L058_000002B0:
; H058+$000002B0: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_000002B2:
; H058+$000002B2: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_000002B8:
; H058+$000002B8: 52732000  addq.w #$1, (a3, d2.w)
        addq.w #$1, (a3, d2.w)
L058_000002BC:
; H058+$000002BC: 4e5d  unlk a5
        unlk a5
L058_000002BE:
; H058+$000002BE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_000002C0:
; H058+$000002C0: 508f  addq.l #$8, a7
        addq.l #$8, a7
L058_000002C2:
; H058+$000002C2: 4ed0  jmp (a0)
        jmp (a0)
L058_000002C4:
; H058+$000002C4: 3f3c01fc  move.w #$1fc, -(a7)
        move.w #$1fc, -(a7)
L058_000002C8:
; H058+$000002C8: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L058_000002CC:
; H058+$000002CC: 4855  pea.l (a5)
        pea.l (a5)
L058_000002CE:
; H058+$000002CE: 6100feba  bsr.w $18a
        bsr.w H058+$18A
L058_000002D2:
; H058+$000002D2: 3f3c01fd  move.w #$1fd, -(a7)
        move.w #$1fd, -(a7)
L058_000002D6:
; H058+$000002D6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_000002DA:
; H058+$000002DA: 4855  pea.l (a5)
        pea.l (a5)
L058_000002DC:
; H058+$000002DC: 6100feac  bsr.w $18a
        bsr.w H058+$18A
L058_000002E0:
; H058+$000002E0: 3f3c01fe  move.w #$1fe, -(a7)
        move.w #$1fe, -(a7)
L058_000002E4:
; H058+$000002E4: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L058_000002E8:
; H058+$000002E8: 4855  pea.l (a5)
        pea.l (a5)
L058_000002EA:
; H058+$000002EA: 6100fe9e  bsr.w $18a
        bsr.w H058+$18A
L058_000002EE:
; H058+$000002EE: 4e5d  unlk a5
        unlk a5
L058_000002F0:
; H058+$000002F0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_000002F2:
; H058+$000002F2: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_000002F4 [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H029+$0312, H062+$0452.
;   - Richiama H029+$0312.
;   - Richiama H062+$0452.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento); H005+$3E00 (puntatore stato persistente B, 2048 byte); H005+$3364 (testa della lista del party).
; Chiamanti diretti: H058+$0700
; --------------------------------------------------------------------------
L058_000002F4:
; H058+$000002F4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_000002F6:
; H058+$000002F6: 287afdd2  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_000002FA:
; H058+$000002FA: 4e55ffe6  link.w a5, #$ffe6
        link.w a5, #$ffe6
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L058_000002FE:
; H058+$000002FE: 0c39000200003de3  cmpi.b #$2, $3de3.l
        cmpi.b #$2, (H005+$3DE3).l
L058_00000306:
; H058+$00000306: 6700001c  beq.w $324
        beq.w H058+$324
L058_0000030A:
; H058+$0000030A: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L058_0000030E:
; H058+$0000030E: 486cffd8  pea.l -$28(a4)
        pea.l -$28(a4)
L058_00000312:
; H058+$00000312: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L058_00000316:
; H058+$00000316: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H029+$0312 (sub_H029_00000312)
L058_0000031A:
; H058+$0000031A: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L058_00000320:
; H058+$00000320: 6000004c  bra.w $36e
        bra.w H058+$36E
L058_00000324:
; H058+$00000324: 422dfff2  clr.b -$e(a5)
        clr.b -$e(a5)
L058_00000328:
; H058+$00000328: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L058_0000032E:
; H058+$0000032E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_00000332:
; H058+$00000332: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000334:
; H058+$00000334: 47ecffd8  lea.l -$28(a4), a3
        lea.l -$28(a4), a3
L058_00000338:
; H058+$00000338: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L058_0000033C:
; H058+$0000033C: 67000008  beq.w $346
        beq.w H058+$346
L058_00000340:
; H058+$00000340: 1b7c0001fff2  move.b #$1, -$e(a5)
        move.b #$1, -$e(a5)
L058_00000346:
; H058+$00000346: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L058_0000034A:
; H058+$0000034A: 4a2dfff2  tst.b -$e(a5)
        tst.b -$e(a5)
L058_0000034E:
; H058+$0000034E: 66000012  bne.w $362
        bne.w H058+$362
L058_00000352:
; H058+$00000352: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L058_00000356:
; H058+$00000356: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L058_0000035C:
; H058+$0000035C: b46b067c  cmp.w $67c(a3), d2
        cmp.w $67c(a3), d2
L058_00000360:
; H058+$00000360: 63cc  bls.b $32e
        bls.b H058+$32E
L058_00000362:
; H058+$00000362: 4a2dfff2  tst.b -$e(a5)
        tst.b -$e(a5)
L058_00000366:
; H058+$00000366: 66000006  bne.w $36e
        bne.w H058+$36E
L058_0000036A:
; H058+$0000036A: 600001b6  bra.w $522
        bra.w H058+$522
L058_0000036E:
; H058+$0000036E: 3b6d000efff8  move.w $e(a5), -$8(a5)
        move.w $e(a5), -$8(a5)
L058_00000374:
; H058+$00000374: 1b6d000cffff  move.b $c(a5), -$1(a5)
        move.b $c(a5), -$1(a5)
L058_0000037A:
; H058+$0000037A: 0c2d0001ffff  cmpi.b #$1, -$1(a5)
        cmpi.b #$1, -$1(a5)
L058_00000380:
; H058+$00000380: 63000028  bls.w $3aa
        bls.w H058+$3AA
L058_00000384:
; H058+$00000384: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000386:
; H058+$00000386: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L058_0000038A:
; H058+$0000038A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_0000038C:
; H058+$0000038C: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L058_00000390:
; H058+$00000390: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000392:
; H058+$00000392: 47f90000500a  lea.l $500a.l, a3
        lea.l (H005+$500A).l, a3
L058_00000398:
; H058+$00000398: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L058_0000039C:
; H058+$0000039C: c8f32000  mulu.w (a3, d2.w), d4
        mulu.w (a3, d2.w), d4
L058_000003A0:
; H058+$000003A0: 3b44fff8  move.w d4, -$8(a5)
        move.w d4, -$8(a5)
L058_000003A4:
; H058+$000003A4: 532dffff  subq.b #$1, -$1(a5)
        subq.b #$1, -$1(a5)
L058_000003A8:
; H058+$000003A8: 60d0  bra.b $37a
        bra.b H058+$37A
L058_000003AA:
; H058+$000003AA: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L058_000003AE:
; H058+$000003AE: 63000172  bls.w $522
        bls.w H058+$522
L058_000003B2:
; H058+$000003B2: 0c6d000afff8  cmpi.w #$a, -$8(a5)
        cmpi.w #$a, -$8(a5)
L058_000003B8:
; H058+$000003B8: 6300000c  bls.w $3c6
        bls.w H058+$3C6
L058_000003BC:
; H058+$000003BC: 3b7c000afffa  move.w #$a, -$6(a5)
        move.w #$a, -$6(a5)
L058_000003C2:
; H058+$000003C2: 60000008  bra.w $3cc
        bra.w H058+$3CC
L058_000003C6:
; H058+$000003C6: 3b6dfff8fffa  move.w -$8(a5), -$6(a5)
        move.w -$8(a5), -$6(a5)
L058_000003CC:
; H058+$000003CC: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
; STATO: H005+$3364 = testa della lista del party
L058_000003D2:
; H058+$000003D2: 2b7900003364fff4  move.l $3364.l, -$c(a5)
        move.l (H005+$3364).l, -$c(a5)
L058_000003DA:
; H058+$000003DA: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L058_000003DE:
; H058+$000003DE: 67000126  beq.w $506
        beq.w H058+$506
L058_000003E2:
; H058+$000003E2: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_000003E6:
; H058+$000003E6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_000003E8:
; H058+$000003E8: 47ecffd8  lea.l -$28(a4), a3
        lea.l -$28(a4), a3
L058_000003EC:
; H058+$000003EC: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L058_000003F0:
; H058+$000003F0: 67000102  beq.w $4f4
        beq.w H058+$4F4
L058_000003F4:
; H058+$000003F4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_000003F8:
; H058+$000003F8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_000003FA:
; H058+$000003FA: 47ecffd8  lea.l -$28(a4), a3
        lea.l -$28(a4), a3
L058_000003FE:
; H058+$000003FE: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L058_00000402:
; H058+$00000402: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L058_00000406:
; H058+$00000406: 2b6b00e8ffee  move.l $e8(a3), -$12(a5)
        move.l $e8(a3), -$12(a5)
L058_0000040C:
; H058+$0000040C: 4aadffee  tst.l -$12(a5)
        tst.l -$12(a5)
L058_00000410:
; H058+$00000410: 670000e2  beq.w $4f4
        beq.w H058+$4F4
L058_00000414:
; H058+$00000414: 2b6dffeeffea  move.l -$12(a5), -$16(a5)
        move.l -$12(a5), -$16(a5)
L058_0000041A:
; H058+$0000041A: 266dffea  movea.l -$16(a5), a3
        movea.l -$16(a5), a3
L058_0000041E:
; H058+$0000041E: 4aab0006  tst.l $6(a3)
        tst.l $6(a3)
L058_00000422:
; H058+$00000422: 6700000e  beq.w $432
        beq.w H058+$432
L058_00000426:
; H058+$00000426: 266dffea  movea.l -$16(a5), a3
        movea.l -$16(a5), a3
L058_0000042A:
; H058+$0000042A: 2b6b0006ffea  move.l $6(a3), -$16(a5)
        move.l $6(a3), -$16(a5)
L058_00000430:
; H058+$00000430: 60e8  bra.b $41a
        bra.b H058+$41A
L058_00000432:
; H058+$00000432: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L058_00000436:
; H058+$00000436: 4aadffee  tst.l -$12(a5)
        tst.l -$12(a5)
L058_0000043A:
; H058+$0000043A: 67000088  beq.w $4c4
        beq.w H058+$4C4
L058_0000043E:
; H058+$0000043E: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L058_00000442:
; H058+$00000442: 66000080  bne.w $4c4
        bne.w H058+$4C4
L058_00000446:
; H058+$00000446: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L058_0000044A:
; H058+$0000044A: 2b6b0006ffe6  move.l $6(a3), -$1a(a5)
        move.l $6(a3), -$1a(a5)
L058_00000450:
; H058+$00000450: 242dffee  move.l -$12(a5), d2
        move.l -$12(a5), d2
L058_00000454:
; H058+$00000454: b4adffea  cmp.l -$16(a5), d2
        cmp.l -$16(a5), d2
L058_00000458:
; H058+$00000458: 66000008  bne.w $462
        bne.w H058+$462
L058_0000045C:
; H058+$0000045C: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L058_00000462:
; H058+$00000462: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L058_00000466:
; H058+$00000466: 4a6b0002  tst.w $2(a3)
        tst.w $2(a3)
L058_0000046A:
; H058+$0000046A: 66000006  bne.w $472
        bne.w H058+$472
L058_0000046E:
; H058+$0000046E: 6000004a  bra.w $4ba
        bra.w H058+$4BA
L058_00000472:
; H058+$00000472: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L058_00000476:
; H058+$00000476: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L058_0000047A:
; H058+$0000047A: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L058_0000047E:
; H058+$0000047E: 63000022  bls.w $4a2
        bls.w H058+$4A2
L058_00000482:
; H058+$00000482: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L058_00000486:
; H058+$00000486: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L058_0000048A:
; H058+$0000048A: 956b0002  sub.w d2, $2(a3)
        sub.w d2, $2(a3)
L058_0000048E:
; H058+$0000048E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_00000492:
; H058+$00000492: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000494:
; H058+$00000494: 47ecffd8  lea.l -$28(a4), a3
        lea.l -$28(a4), a3
L058_00000498:
; H058+$00000498: 17bc00012000  move.b #$1, (a3, d2.w)
        move.b #$1, (a3, d2.w)
L058_0000049E:
; H058+$0000049E: 6000001a  bra.w $4ba
        bra.w H058+$4BA
L058_000004A2:
; H058+$000004A2: 2f2dfff4  move.l -$c(a5), -(a7)
        move.l -$c(a5), -(a7)
L058_000004A6:
; H058+$000004A6: 7400  moveq #$0, d2
        moveq #0, d2
L058_000004A8:
; H058+$000004A8: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L058_000004AC:
; H058+$000004AC: 1413  move.b (a3), d2
        move.b (a3), d2
L058_000004AE:
; H058+$000004AE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L058_000004B0:
; H058+$000004B0: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
; -> H062+$0452 (sub_H062_00000452)
L058_000004B4:
; H058+$000004B4: 4eb900000452  jsr $452.l
        jsr (H062+$452).l
L058_000004BA:
; H058+$000004BA: 2b6dffe6ffee  move.l -$1a(a5), -$12(a5)
        move.l -$1a(a5), -$12(a5)
L058_000004C0:
; H058+$000004C0: 6000ff74  bra.w $436
        bra.w H058+$436
L058_000004C4:
; H058+$000004C4: 4aadffee  tst.l -$12(a5)
        tst.l -$12(a5)
L058_000004C8:
; H058+$000004C8: 6700002a  beq.w $4f4
        beq.w H058+$4F4
L058_000004CC:
; H058+$000004CC: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L058_000004D0:
; H058+$000004D0: 4a6b0002  tst.w $2(a3)
        tst.w $2(a3)
L058_000004D4:
; H058+$000004D4: 63000012  bls.w $4e8
        bls.w H058+$4E8
L058_000004D8:
; H058+$000004D8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_000004DC:
; H058+$000004DC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_000004DE:
; H058+$000004DE: 47ecffd8  lea.l -$28(a4), a3
        lea.l -$28(a4), a3
L058_000004E2:
; H058+$000004E2: 17bc00012000  move.b #$1, (a3, d2.w)
        move.b #$1, (a3, d2.w)
L058_000004E8:
; H058+$000004E8: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L058_000004EC:
; H058+$000004EC: 2b6b0006ffee  move.l $6(a3), -$12(a5)
        move.l $6(a3), -$12(a5)
L058_000004F2:
; H058+$000004F2: 60d0  bra.b $4c4
        bra.b H058+$4C4
L058_000004F4:
; H058+$000004F4: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L058_000004F8:
; H058+$000004F8: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L058_000004FC:
; H058+$000004FC: 2b6b018efff4  move.l $18e(a3), -$c(a5)
        move.l $18e(a3), -$c(a5)
L058_00000502:
; H058+$00000502: 6000fed6  bra.w $3da
        bra.w H058+$3DA
L058_00000506:
; H058+$00000506: 0c6d000afff8  cmpi.w #$a, -$8(a5)
        cmpi.w #$a, -$8(a5)
L058_0000050C:
; H058+$0000050C: 6300000c  bls.w $51a
        bls.w H058+$51A
L058_00000510:
; H058+$00000510: 046d000afff8  subi.w #$a, -$8(a5)
        subi.w #$a, -$8(a5)
L058_00000516:
; H058+$00000516: 60000006  bra.w $51e
        bra.w H058+$51E
L058_0000051A:
; H058+$0000051A: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L058_0000051E:
; H058+$0000051E: 6000fe8a  bra.w $3aa
        bra.w H058+$3AA
L058_00000522:
; H058+$00000522: 4e5d  unlk a5
        unlk a5
L058_00000524:
; H058+$00000524: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000526:
; H058+$00000526: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_00000528:
; H058+$00000528: 588f  addq.l #$4, a7
        addq.l #$4, a7
L058_0000052A:
; H058+$0000052A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_0000052C [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; opera su H005+$3364 (testa della lista del party).
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H058+$06B4, H058+$0604
; --------------------------------------------------------------------------
L058_0000052C:
; H058+$0000052C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_0000052E:
; H058+$0000052E: 287afb9a  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000532:
; H058+$00000532: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L058_00000536:
; H058+$00000536: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L058_0000053A:
; H058+$0000053A: 0c2d0006ffff  cmpi.b #$6, -$1(a5)
        cmpi.b #$6, -$1(a5)
L058_00000540:
; H058+$00000540: 620000a8  bhi.w $5ea
        bhi.w H058+$5EA
L058_00000544:
; H058+$00000544: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000546:
; H058+$00000546: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L058_0000054A:
; H058+$0000054A: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_0000054C:
; H058+$0000054C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000550:
; H058+$00000550: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000552:
; H058+$00000552: 182dffff  move.b -$1(a5), d4
        move.b -$1(a5), d4
L058_00000556:
; H058+$00000556: e344  asl.w #$1, d4
        asl.w #$1, d4
L058_00000558:
; H058+$00000558: 45f90000500a  lea.l $500a.l, a2
        lea.l (H005+$500A).l, a2
L058_0000055E:
; H058+$0000055E: 3c332000  move.w (a3, d2.w), d6
        move.w (a3, d2.w), d6
L058_00000562:
; H058+$00000562: bc724000  cmp.w (a2, d4.w), d6
        cmp.w (a2, d4.w), d6
L058_00000566:
; H058+$00000566: 6500007a  bcs.w $5e2
        bcs.w H058+$5E2
L058_0000056A:
; H058+$0000056A: 0c2d0006ffff  cmpi.b #$6, -$1(a5)
        cmpi.b #$6, -$1(a5)
L058_00000570:
; H058+$00000570: 6700004c  beq.w $5be
        beq.w H058+$5BE
L058_00000574:
; H058+$00000574: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000576:
; H058+$00000576: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L058_0000057A:
; H058+$0000057A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L058_0000057C:
; H058+$0000057C: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L058_00000580:
; H058+$00000580: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000582:
; H058+$00000582: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000586:
; H058+$00000586: 52732000  addq.w #$1, (a3, d2.w)
        addq.w #$1, (a3, d2.w)
L058_0000058A:
; H058+$0000058A: 7400  moveq #$0, d2
        moveq #0, d2
L058_0000058C:
; H058+$0000058C: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L058_00000590:
; H058+$00000590: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000592:
; H058+$00000592: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000596:
; H058+$00000596: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000598:
; H058+$00000598: 182dffff  move.b -$1(a5), d4
        move.b -$1(a5), d4
L058_0000059C:
; H058+$0000059C: e344  asl.w #$1, d4
        asl.w #$1, d4
L058_0000059E:
; H058+$0000059E: 45f90000500a  lea.l $500a.l, a2
        lea.l (H005+$500A).l, a2
L058_000005A4:
; H058+$000005A4: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L058_000005A8:
; H058+$000005A8: 9d732000  sub.w d6, (a3, d2.w)
        sub.w d6, (a3, d2.w)
L058_000005AC:
; H058+$000005AC: 0c2d0003ffff  cmpi.b #$3, -$1(a5)
        cmpi.b #$3, -$1(a5)
L058_000005B2:
; H058+$000005B2: 66000006  bne.w $5ba
        bne.w H058+$5BA
L058_000005B6:
; H058+$000005B6: 6100fbc4  bsr.w $17c
        bsr.w H058+$17C
L058_000005BA:
; H058+$000005BA: 60000026  bra.w $5e2
        bra.w H058+$5E2
; STATO: H005+$3364 = testa della lista del party
L058_000005BE:
; H058+$000005BE: 2b7900003364fffa  move.l $3364.l, -$6(a5)
        move.l (H005+$3364).l, -$6(a5)
L058_000005C6:
; H058+$000005C6: 4aadfffa  tst.l -$6(a5)
        tst.l -$6(a5)
L058_000005CA:
; H058+$000005CA: 67000016  beq.w $5e2
        beq.w H058+$5E2
L058_000005CE:
; H058+$000005CE: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L058_000005D2:
; H058+$000005D2: 526b0062  addq.w #$1, $62(a3)
        addq.w #$1, $62(a3)
L058_000005D6:
; H058+$000005D6: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L058_000005DA:
; H058+$000005DA: 2b6b018efffa  move.l $18e(a3), -$6(a5)
        move.l $18e(a3), -$6(a5)
L058_000005E0:
; H058+$000005E0: 60e4  bra.b $5c6
        bra.b H058+$5C6
L058_000005E2:
; H058+$000005E2: 522dffff  addq.b #$1, -$1(a5)
        addq.b #$1, -$1(a5)
L058_000005E6:
; H058+$000005E6: 6400ff52  bcc.w $53a
        bcc.w H058+$53A
L058_000005EA:
; H058+$000005EA: 4e5d  unlk a5
        unlk a5
L058_000005EC:
; H058+$000005EC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_000005EE:
; H058+$000005EE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_000005F0:
; H058+$000005F0: 588f  addq.l #$4, a7
        addq.l #$4, a7
L058_000005F2:
; H058+$000005F2: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_000005F4 [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H058+$083E, H058+$0AE4, H058+$0B10
; --------------------------------------------------------------------------
L058_000005F4:
; H058+$000005F4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_000005F6:
; H058+$000005F6: 287afad2  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_000005FA:
; H058+$000005FA: 4e550000  link.w a5, #$0
        link.w a5, #$0
L058_000005FE:
; H058+$000005FE: 4879000024f4  pea.l $24f4.l
        pea.l (H005+$24F4).l
L058_00000604:
; H058+$00000604: 6100ff26  bsr.w $52c
        bsr.w H058+$52C
L058_00000608:
; H058+$00000608: 4a79000024fe  tst.w $24fe.l
        tst.w (H005+$24FE).l
L058_0000060E:
; H058+$0000060E: 63000034  bls.w $644
        bls.w H058+$644
L058_00000612:
; H058+$00000612: 343900005012  move.w $5012.l, d2
        move.w (H005+$5012).l, d2
L058_00000618:
; H058+$00000618: c4f9000024fe  mulu.w $24fe.l, d2
        mulu.w (H005+$24FE).l, d2
L058_0000061E:
; H058+$0000061E: d479000024fc  add.w $24fc.l, d2
        add.w (H005+$24FC).l, d2
L058_00000624:
; H058+$00000624: 33c2000024fc  move.w d2, $24fc.l
        move.w d2, (H005+$24FC).l
L058_0000062A:
; H058+$0000062A: 4279000024fe  clr.w $24fe.l
        clr.w (H005+$24FE).l
L058_00000630:
; H058+$00000630: 0c790063000024fc  cmpi.w #$63, $24fc.l
        cmpi.w #$63, (H005+$24FC).l
L058_00000638:
; H058+$00000638: 6300000a  bls.w $644
        bls.w H058+$644
L058_0000063C:
; H058+$0000063C: 33fc0063000024fc  move.w #$63, $24fc.l
        move.w #$63, (H005+$24FC).l
L058_00000644:
; H058+$00000644: 4e5d  unlk a5
        unlk a5
L058_00000646:
; H058+$00000646: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000648:
; H058+$00000648: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_0000064A [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; opera su H005+$3E04 (puntatore stato persistente A, 2048 byte).
;   - Usa lo stato globale: H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H012+$23CA, H068+$0DB4, H068+$0C02, H068+$0B0E, H068+$0B20, H059+$1600 e altri 1
; --------------------------------------------------------------------------
L058_0000064A:
; H058+$0000064A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_0000064C:
; H058+$0000064C: 287afa7c  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000650:
; H058+$00000650: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L058_00000654:
; H058+$00000654: 422dfff1  clr.b -$f(a5)
        clr.b -$f(a5)
L058_00000658:
; H058+$00000658: 0c2d0006fff1  cmpi.b #$6, -$f(a5)
        cmpi.b #$6, -$f(a5)
L058_0000065E:
; H058+$0000065E: 6200002c  bhi.w $68c
        bhi.w H058+$68C
L058_00000662:
; H058+$00000662: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000664:
; H058+$00000664: 142dfff1  move.b -$f(a5), d2
        move.b -$f(a5), d2
L058_00000668:
; H058+$00000668: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_0000066A:
; H058+$0000066A: 47edfff2  lea.l -$e(a5), a3
        lea.l -$e(a5), a3
L058_0000066E:
; H058+$0000066E: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000670:
; H058+$00000670: 182dfff1  move.b -$f(a5), d4
        move.b -$f(a5), d4
L058_00000674:
; H058+$00000674: 064400c6  addi.w #$c6, d4
        addi.w #$c6, d4
L058_00000678:
; H058+$00000678: e344  asl.w #$1, d4
        asl.w #$1, d4
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_0000067A:
; H058+$0000067A: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L058_00000680:
; H058+$00000680: 37b240002000  move.w (a2, d4.w), (a3, d2.w)
        move.w (a2, d4.w), (a3, d2.w)
L058_00000686:
; H058+$00000686: 522dfff1  addq.b #$1, -$f(a5)
        addq.b #$1, -$f(a5)
L058_0000068A:
; H058+$0000068A: 64cc  bcc.b $658
        bcc.b H058+$658
L058_0000068C:
; H058+$0000068C: 3b7c0001ffee  move.w #$1, -$12(a5)
        move.w #$1, -$12(a5)
L058_00000692:
; H058+$00000692: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L058_00000696:
; H058+$00000696: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L058_0000069A:
; H058+$0000069A: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L058_0000069C:
; H058+$0000069C: 62000020  bhi.w $6be
        bhi.w H058+$6BE
L058_000006A0:
; H058+$000006A0: 7400  moveq #$0, d2
        moveq #0, d2
L058_000006A2:
; H058+$000006A2: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L058_000006A6:
; H058+$000006A6: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_000006A8:
; H058+$000006A8: 47edfff2  lea.l -$e(a5), a3
        lea.l -$e(a5), a3
L058_000006AC:
; H058+$000006AC: 52732000  addq.w #$1, (a3, d2.w)
        addq.w #$1, (a3, d2.w)
L058_000006B0:
; H058+$000006B0: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
L058_000006B4:
; H058+$000006B4: 6100fe76  bsr.w $52c
        bsr.w H058+$52C
L058_000006B8:
; H058+$000006B8: 526dffee  addq.w #$1, -$12(a5)
        addq.w #$1, -$12(a5)
L058_000006BC:
; H058+$000006BC: 64d8  bcc.b $696
        bcc.b H058+$696
L058_000006BE:
; H058+$000006BE: 548f  addq.l #$2, a7
        addq.l #$2, a7
L058_000006C0:
; H058+$000006C0: 422dfff1  clr.b -$f(a5)
        clr.b -$f(a5)
L058_000006C4:
; H058+$000006C4: 0c2d0006fff1  cmpi.b #$6, -$f(a5)
        cmpi.b #$6, -$f(a5)
L058_000006CA:
; H058+$000006CA: 6200002c  bhi.w $6f8
        bhi.w H058+$6F8
L058_000006CE:
; H058+$000006CE: 7400  moveq #$0, d2
        moveq #0, d2
L058_000006D0:
; H058+$000006D0: 142dfff1  move.b -$f(a5), d2
        move.b -$f(a5), d2
L058_000006D4:
; H058+$000006D4: 064200c6  addi.w #$c6, d2
        addi.w #$c6, d2
L058_000006D8:
; H058+$000006D8: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L058_000006DA:
; H058+$000006DA: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L058_000006E0:
; H058+$000006E0: 7800  moveq #$0, d4
        moveq #0, d4
L058_000006E2:
; H058+$000006E2: 182dfff1  move.b -$f(a5), d4
        move.b -$f(a5), d4
L058_000006E6:
; H058+$000006E6: e344  asl.w #$1, d4
        asl.w #$1, d4
L058_000006E8:
; H058+$000006E8: 45edfff2  lea.l -$e(a5), a2
        lea.l -$e(a5), a2
L058_000006EC:
; H058+$000006EC: 37b240002000  move.w (a2, d4.w), (a3, d2.w)
        move.w (a2, d4.w), (a3, d2.w)
L058_000006F2:
; H058+$000006F2: 522dfff1  addq.b #$1, -$f(a5)
        addq.b #$1, -$f(a5)
L058_000006F6:
; H058+$000006F6: 64cc  bcc.b $6c4
        bcc.b H058+$6C4
L058_000006F8:
; H058+$000006F8: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L058_000006FC:
; H058+$000006FC: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L058_00000700:
; H058+$00000700: 6100fbf2  bsr.w $2f4
        bsr.w H058+$2F4
L058_00000704:
; H058+$00000704: 4e5d  unlk a5
        unlk a5
L058_00000706:
; H058+$00000706: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000708:
; H058+$00000708: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_0000070A:
; H058+$0000070A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L058_0000070C:
; H058+$0000070C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_0000070E [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H029+$0312.
;   - Richiama H029+$0312.
; Chiamanti diretti: H058+$1162, H058+$0AFC, H058+$0B0C
; --------------------------------------------------------------------------
L058_0000070E:
; H058+$0000070E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_00000710:
; H058+$00000710: 287af9b8  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000714:
; H058+$00000714: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L058_00000718:
; H058+$00000718: 4a79000024fc  tst.w $24fc.l
        tst.w (H005+$24FC).l
L058_0000071E:
; H058+$0000071E: 66000024  bne.w $744
        bne.w H058+$744
L058_00000722:
; H058+$00000722: 4a79000024fa  tst.w $24fa.l
        tst.w (H005+$24FA).l
L058_00000728:
; H058+$00000728: 6600001a  bne.w $744
        bne.w H058+$744
L058_0000072C:
; H058+$0000072C: 4a79000024f8  tst.w $24f8.l
        tst.w (H005+$24F8).l
L058_00000732:
; H058+$00000732: 66000010  bne.w $744
        bne.w H058+$744
L058_00000736:
; H058+$00000736: 4a79000024f6  tst.w $24f6.l
        tst.w (H005+$24F6).l
L058_0000073C:
; H058+$0000073C: 66000006  bne.w $744
        bne.w H058+$744
L058_00000740:
; H058+$00000740: 60000100  bra.w $842
        bra.w H058+$842
L058_00000744:
; H058+$00000744: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000746:
; H058+$00000746: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L058_0000074A:
; H058+$0000074A: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_0000074C:
; H058+$0000074C: 47f9000024f4  lea.l $24f4.l, a3
        lea.l (H005+$24F4).l, a3
L058_00000752:
; H058+$00000752: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L058_00000756:
; H058+$00000756: b8732000  cmp.w (a3, d2.w), d4
        cmp.w (a3, d2.w), d4
L058_0000075A:
; H058+$0000075A: 630000cc  bls.w $828
        bls.w H058+$828
L058_0000075E:
; H058+$0000075E: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000760:
; H058+$00000760: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L058_00000764:
; H058+$00000764: 5242  addq.w #$1, d2
        addq.w #$1, d2
L058_00000766:
; H058+$00000766: 1b42ffff  move.b d2, -$1(a5)
        move.b d2, -$1(a5)
L058_0000076A:
; H058+$0000076A: 7400  moveq #$0, d2
        moveq #0, d2
L058_0000076C:
; H058+$0000076C: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L058_00000770:
; H058+$00000770: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000772:
; H058+$00000772: 47f9000024f4  lea.l $24f4.l, a3
        lea.l (H005+$24F4).l, a3
L058_00000778:
; H058+$00000778: 4a732000  tst.w (a3, d2.w)
        tst.w (a3, d2.w)
L058_0000077C:
; H058+$0000077C: 6600001a  bne.w $798
        bne.w H058+$798
L058_00000780:
; H058+$00000780: 0c2d0005ffff  cmpi.b #$5, -$1(a5)
        cmpi.b #$5, -$1(a5)
L058_00000786:
; H058+$00000786: 64000010  bcc.w $798
        bcc.w H058+$798
L058_0000078A:
; H058+$0000078A: 7400  moveq #$0, d2
        moveq #0, d2
L058_0000078C:
; H058+$0000078C: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L058_00000790:
; H058+$00000790: 5242  addq.w #$1, d2
        addq.w #$1, d2
L058_00000792:
; H058+$00000792: 1b42ffff  move.b d2, -$1(a5)
        move.b d2, -$1(a5)
L058_00000796:
; H058+$00000796: 60d2  bra.b $76a
        bra.b H058+$76A
L058_00000798:
; H058+$00000798: 0c2d0005ffff  cmpi.b #$5, -$1(a5)
        cmpi.b #$5, -$1(a5)
L058_0000079E:
; H058+$0000079E: 66000020  bne.w $7c0
        bne.w H058+$7C0
L058_000007A2:
; H058+$000007A2: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L058_000007A6:
; H058+$000007A6: 4879000024f4  pea.l $24f4.l
        pea.l (H005+$24F4).l
L058_000007AC:
; H058+$000007AC: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L058_000007B0:
; H058+$000007B0: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L058_000007B2:
; H058+$000007B2: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L058_000007B8:
; H058+$000007B8: 426d000e  clr.w $e(a5)
        clr.w $e(a5)
L058_000007BC:
; H058+$000007BC: 60000066  bra.w $824
        bra.w H058+$824
L058_000007C0:
; H058+$000007C0: 1b6dfffffffe  move.b -$1(a5), -$2(a5)
        move.b -$1(a5), -$2(a5)
L058_000007C6:
; H058+$000007C6: 7400  moveq #$0, d2
        moveq #0, d2
L058_000007C8:
; H058+$000007C8: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L058_000007CC:
; H058+$000007CC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L058_000007CE:
; H058+$000007CE: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L058_000007D0:
; H058+$000007D0: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L058_000007D4:
; H058+$000007D4: b417  cmp.b (a7), d2
        cmp.b (a7), d2
L058_000007D6:
; H058+$000007D6: 6500004a  bcs.w $822
        bcs.w H058+$822
L058_000007DA:
; H058+$000007DA: 7400  moveq #$0, d2
        moveq #0, d2
L058_000007DC:
; H058+$000007DC: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L058_000007E0:
; H058+$000007E0: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_000007E2:
; H058+$000007E2: 47f9000024f4  lea.l $24f4.l, a3
        lea.l (H005+$24F4).l, a3
L058_000007E8:
; H058+$000007E8: 53732000  subq.w #$1, (a3, d2.w)
        subq.w #$1, (a3, d2.w)
L058_000007EC:
; H058+$000007EC: 7400  moveq #$0, d2
        moveq #0, d2
L058_000007EE:
; H058+$000007EE: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L058_000007F2:
; H058+$000007F2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_000007F4:
; H058+$000007F4: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L058_000007F8:
; H058+$000007F8: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_000007FA:
; H058+$000007FA: 47f9000024f4  lea.l $24f4.l, a3
        lea.l (H005+$24F4).l, a3
L058_00000800:
; H058+$00000800: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000802:
; H058+$00000802: 182dfffe  move.b -$2(a5), d4
        move.b -$2(a5), d4
L058_00000806:
; H058+$00000806: 5344  subq.w #$1, d4
        subq.w #$1, d4
L058_00000808:
; H058+$00000808: 024400ff  andi.w #$ff, d4
        andi.w #$ff, d4
L058_0000080C:
; H058+$0000080C: e344  asl.w #$1, d4
        asl.w #$1, d4
L058_0000080E:
; H058+$0000080E: 45f90000500a  lea.l $500a.l, a2
        lea.l (H005+$500A).l, a2
L058_00000814:
; H058+$00000814: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L058_00000818:
; H058+$00000818: dd732000  add.w d6, (a3, d2.w)
        add.w d6, (a3, d2.w)
L058_0000081C:
; H058+$0000081C: 532dfffe  subq.b #$1, -$2(a5)
        subq.b #$1, -$2(a5)
L058_00000820:
; H058+$00000820: 64ae  bcc.b $7d0
        bcc.b H058+$7D0
L058_00000822:
; H058+$00000822: 548f  addq.l #$2, a7
        addq.l #$2, a7
L058_00000824:
; H058+$00000824: 6000ff1e  bra.w $744
        bra.w H058+$744
L058_00000828:
; H058+$00000828: 7400  moveq #$0, d2
        moveq #0, d2
L058_0000082A:
; H058+$0000082A: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L058_0000082E:
; H058+$0000082E: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000830:
; H058+$00000830: 47f9000024f4  lea.l $24f4.l, a3
        lea.l (H005+$24F4).l, a3
L058_00000836:
; H058+$00000836: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L058_0000083A:
; H058+$0000083A: 99732000  sub.w d4, (a3, d2.w)
        sub.w d4, (a3, d2.w)
L058_0000083E:
; H058+$0000083E: 6100fdb4  bsr.w $5f4
        bsr.w H058+$5F4
L058_00000842:
; H058+$00000842: 4e5d  unlk a5
        unlk a5
L058_00000844:
; H058+$00000844: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000846:
; H058+$00000846: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_00000848:
; H058+$00000848: 588f  addq.l #$4, a7
        addq.l #$4, a7
L058_0000084A:
; H058+$0000084A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_0000084C [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H030+$0256, H045+$01D6.
;   - Richiama H030+$0256.
;   - Richiama H045+$01D6.
; Chiamanti diretti: H058+$109A, H058+$111A, H058+$09C2, H058+$117E, H058+$11FA, H058+$0BE8 e altri 2
; --------------------------------------------------------------------------
L058_0000084C:
; H058+$0000084C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_0000084E:
; H058+$0000084E: 287af87a  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000852:
; H058+$00000852: 4e55ffc0  link.w a5, #$ffc0
        link.w a5, #$ffc0
L058_00000856:
; H058+$00000856: 422dffd1  clr.b -$2f(a5)
        clr.b -$2f(a5)
L058_0000085A:
; H058+$0000085A: 0c2d0006ffd1  cmpi.b #$6, -$2f(a5)
        cmpi.b #$6, -$2f(a5)
L058_00000860:
; H058+$00000860: 6200001a  bhi.w $87c
        bhi.w H058+$87C
L058_00000864:
; H058+$00000864: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000866:
; H058+$00000866: 142dffd1  move.b -$2f(a5), d2
        move.b -$2f(a5), d2
L058_0000086A:
; H058+$0000086A: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_0000086C:
; H058+$0000086C: 47edffc2  lea.l -$3e(a5), a3
        lea.l -$3e(a5), a3
L058_00000870:
; H058+$00000870: 37bc000a2000  move.w #$a, (a3, d2.w)
        move.w #$a, (a3, d2.w)
L058_00000876:
; H058+$00000876: 522dffd1  addq.b #$1, -$2f(a5)
        addq.b #$1, -$2f(a5)
L058_0000087A:
; H058+$0000087A: 64de  bcc.b $85a
        bcc.b H058+$85A
L058_0000087C:
; H058+$0000087C: 7400  moveq #$0, d2
        moveq #0, d2
L058_0000087E:
; H058+$0000087E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L058_00000882:
; H058+$00000882: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000884:
; H058+$00000884: 47edffc2  lea.l -$3e(a5), a3
        lea.l -$3e(a5), a3
L058_00000888:
; H058+$00000888: 37bc000f2000  move.w #$f, (a3, d2.w)
        move.w #$f, (a3, d2.w)
L058_0000088E:
; H058+$0000088E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_00000892:
; H058+$00000892: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L058_00000896:
; H058+$00000896: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L058_0000089A:
; H058+$0000089A: 4267  clr.w -(a7)
        clr.w -(a7)
L058_0000089C:
; H058+$0000089C: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L058_000008A0:
; H058+$000008A0: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L058_000008A4:
; H058+$000008A4: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L058_000008AA:
; H058+$000008AA: 3b7c000bffc0  move.w #$b, -$40(a5)
        move.w #$b, -$40(a5)
L058_000008B0:
; H058+$000008B0: 1b7c0004ffd1  move.b #$4, -$2f(a5)
        move.b #$4, -$2f(a5)
L058_000008B6:
; H058+$000008B6: 0c2d0003ffd1  cmpi.b #$3, -$2f(a5)
        cmpi.b #$3, -$2f(a5)
L058_000008BC:
; H058+$000008BC: 6500008e  bcs.w $94c
        bcs.w H058+$94C
L058_000008C0:
; H058+$000008C0: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L058_000008C4:
; H058+$000008C4: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L058_000008C8:
; H058+$000008C8: 7400  moveq #$0, d2
        moveq #0, d2
L058_000008CA:
; H058+$000008CA: 142dffd1  move.b -$2f(a5), d2
        move.b -$2f(a5), d2
L058_000008CE:
; H058+$000008CE: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_000008D0:
; H058+$000008D0: 47f9000024f4  lea.l $24f4.l, a3
        lea.l (H005+$24F4).l, a3
L058_000008D6:
; H058+$000008D6: 7800  moveq #$0, d4
        moveq #0, d4
L058_000008D8:
; H058+$000008D8: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L058_000008DC:
; H058+$000008DC: 2f04  move.l d4, -(a7)
        move.l d4, -(a7)
L058_000008DE:
; H058+$000008DE: 4227  clr.b -(a7)
        clr.b -(a7)
L058_000008E0:
; H058+$000008E0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L058_000008E4:
; H058+$000008E4: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L058_000008E8:
; H058+$000008E8: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L058_000008EC:
; H058+$000008EC: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L058_000008F2:
; H058+$000008F2: 342dffc0  move.w -$40(a5), d2
        move.w -$40(a5), d2
L058_000008F6:
; H058+$000008F6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L058_000008F8:
; H058+$000008F8: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L058_000008FA:
; H058+$000008FA: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L058_000008FE:
; H058+$000008FE: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000900:
; H058+$00000900: 142dffd1  move.b -$2f(a5), d2
        move.b -$2f(a5), d2
L058_00000904:
; H058+$00000904: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000906:
; H058+$00000906: 47edffc2  lea.l -$3e(a5), a3
        lea.l -$3e(a5), a3
L058_0000090A:
; H058+$0000090A: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L058_0000090E:
; H058+$0000090E: 4267  clr.w -(a7)
        clr.w -(a7)
L058_00000910:
; H058+$00000910: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L058_00000914:
; H058+$00000914: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L058_00000918:
; H058+$00000918: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L058_0000091E:
; H058+$0000091E: 342dffc0  move.w -$40(a5), d2
        move.w -$40(a5), d2
L058_00000922:
; H058+$00000922: 5242  addq.w #$1, d2
        addq.w #$1, d2
L058_00000924:
; H058+$00000924: 5442  addq.w #$2, d2
        addq.w #$2, d2
L058_00000926:
; H058+$00000926: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L058_00000928:
; H058+$00000928: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L058_0000092C:
; H058+$0000092C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L058_00000930:
; H058+$00000930: 4267  clr.w -(a7)
        clr.w -(a7)
L058_00000932:
; H058+$00000932: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L058_00000936:
; H058+$00000936: 486c000d  pea.l $d(a4)
        pea.l $d(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L058_0000093A:
; H058+$0000093A: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L058_00000940:
; H058+$00000940: 566dffc0  addq.w #$3, -$40(a5)
        addq.w #$3, -$40(a5)
L058_00000944:
; H058+$00000944: 532dffd1  subq.b #$1, -$2f(a5)
        subq.b #$1, -$2f(a5)
L058_00000948:
; H058+$00000948: 6400ff6c  bcc.w $8b6
        bcc.w H058+$8B6
L058_0000094C:
; H058+$0000094C: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L058_00000950:
; H058+$00000950: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L058_00000954:
; H058+$00000954: 3439000024f8  move.w $24f8.l, d2
        move.w (H005+$24F8).l, d2
L058_0000095A:
; H058+$0000095A: c4fc000a  mulu.w #$a, d2
        mulu.w #$a, d2
L058_0000095E:
; H058+$0000095E: d479000024f6  add.w $24f6.l, d2
        add.w (H005+$24F6).l, d2
L058_00000964:
; H058+$00000964: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L058_0000096A:
; H058+$0000096A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L058_0000096C:
; H058+$0000096C: 4227  clr.b -(a7)
        clr.b -(a7)
L058_0000096E:
; H058+$0000096E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L058_00000972:
; H058+$00000972: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L058_00000976:
; H058+$00000976: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L058_0000097A:
; H058+$0000097A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L058_00000980:
; H058+$00000980: 342dffc0  move.w -$40(a5), d2
        move.w -$40(a5), d2
L058_00000984:
; H058+$00000984: 5242  addq.w #$1, d2
        addq.w #$1, d2
L058_00000986:
; H058+$00000986: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L058_00000988:
; H058+$00000988: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L058_0000098C:
; H058+$0000098C: 3f2dffc6  move.w -$3a(a5), -(a7)
        move.w -$3a(a5), -(a7)
L058_00000990:
; H058+$00000990: 4267  clr.w -(a7)
        clr.w -(a7)
L058_00000992:
; H058+$00000992: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L058_00000996:
; H058+$00000996: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L058_0000099A:
; H058+$0000099A: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L058_000009A0:
; H058+$000009A0: 4e5d  unlk a5
        unlk a5
L058_000009A2:
; H058+$000009A2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_000009A4:
; H058+$000009A4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_000009A6:
; H058+$000009A6: 548f  addq.l #$2, a7
        addq.l #$2, a7
L058_000009A8:
; H058+$000009A8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_000009AA [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H008+$01FC.
;   - Richiama H008+$01FC.
; Chiamanti diretti: H058+$10B8
; --------------------------------------------------------------------------
L058_000009AA:
; H058+$000009AA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_000009AC:
; H058+$000009AC: 287af71c  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_000009B0:
; H058+$000009B0: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L058_000009B4:
; H058+$000009B4: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L058_000009B8:
; H058+$000009B8: 1b7c0002fffc  move.b #$2, -$4(a5)
        move.b #$2, -$4(a5)
L058_000009BE:
; H058+$000009BE: 1f2dfffc  move.b -$4(a5), -(a7)
        move.b -$4(a5), -(a7)
L058_000009C2:
; H058+$000009C2: 6100fe88  bsr.w $84c
        bsr.w H058+$84C
L058_000009C6:
; H058+$000009C6: 4267  clr.w -(a7)
        clr.w -(a7)
L058_000009C8:
; H058+$000009C8: 486c0011  pea.l $11(a4)
        pea.l $11(a4)
L058_000009CC:
; H058+$000009CC: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L058_000009D0:
; H058+$000009D0: 486c0013  pea.l $13(a4)
        pea.l $13(a4)
L058_000009D4:
; H058+$000009D4: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L058_000009D8:
; H058+$000009D8: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L058_000009DC:
; H058+$000009DC: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L058_000009E0:
; H058+$000009E0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L058_000009E4:
; H058+$000009E4: 4227  clr.b -(a7)
        clr.b -(a7)
L058_000009E6:
; H058+$000009E6: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L058_000009EA:
; H058+$000009EA: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L058_000009F0:
; H058+$000009F0: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
L058_000009F4:
; H058+$000009F4: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L058_000009F8:
; H058+$000009F8: 6700008a  beq.w $a84
        beq.w H058+$A84
L058_000009FC:
; H058+$000009FC: 7400  moveq #$0, d2
        moveq #0, d2
L058_000009FE:
; H058+$000009FE: 142dfffd  move.b -$3(a5), d2
        move.b -$3(a5), d2
L058_00000A02:
; H058+$00000A02: 60000066  bra.w $a6a
        bra.w H058+$A6A
L058_00000A06:
; H058+$00000A06: 1b7c0041fffd  move.b #$41, -$3(a5)
        move.b #$41, -$3(a5)
L058_00000A0C:
; H058+$00000A0C: 4e75  rts 
        rts 
L058_00000A0E:
; H058+$00000A0E: 1b7c0053fffd  move.b #$53, -$3(a5)
        move.b #$53, -$3(a5)
L058_00000A14:
; H058+$00000A14: 4e75  rts 
        rts 
L058_00000A16:
; H058+$00000A16: 522dfffc  addq.b #$1, -$4(a5)
        addq.b #$1, -$4(a5)
L058_00000A1A:
; H058+$00000A1A: 0c2d0004fffc  cmpi.b #$4, -$4(a5)
        cmpi.b #$4, -$4(a5)
L058_00000A20:
; H058+$00000A20: 63000008  bls.w $a2a
        bls.w H058+$A2A
L058_00000A24:
; H058+$00000A24: 1b7c0002fffc  move.b #$2, -$4(a5)
        move.b #$2, -$4(a5)
L058_00000A2A:
; H058+$00000A2A: 1b7c0058fffd  move.b #$58, -$3(a5)
        move.b #$58, -$3(a5)
L058_00000A30:
; H058+$00000A30: 4e75  rts 
        rts 
L058_00000A32:
; H058+$00000A32: 532dfffc  subq.b #$1, -$4(a5)
        subq.b #$1, -$4(a5)
L058_00000A36:
; H058+$00000A36: 0c2d0002fffc  cmpi.b #$2, -$4(a5)
        cmpi.b #$2, -$4(a5)
L058_00000A3C:
; H058+$00000A3C: 64000008  bcc.w $a46
        bcc.w H058+$A46
L058_00000A40:
; H058+$00000A40: 1b7c0004fffc  move.b #$4, -$4(a5)
        move.b #$4, -$4(a5)
L058_00000A46:
; H058+$00000A46: 1b7c0058fffd  move.b #$58, -$3(a5)
        move.b #$58, -$3(a5)
L058_00000A4C:
; H058+$00000A4C: 4e75  rts 
        rts 
L058_00000A4E:
; H058+$00000A4E: 1b7c0058fffd  move.b #$58, -$3(a5)
        move.b #$58, -$3(a5)
L058_00000A54:
; H058+$00000A54: 4e75  rts 
        rts 
; Preserved bytes H058+$00000A56..$00000A6A; code/data not fully classified.
        dc.w $FFF6,$FFAE,$FFF6,$FFF6,$FFBE,$FFF6,$FFDA,$FFF6
        dc.w $FFF6,$FFB6
L058_00000A6A:
; H058+$00000A6A: 47faffec  lea.l $a58(pc), a3
        lea.l H058+$A58(pc), a3
L058_00000A6E:
; H058+$00000A6E: 04420048  subi.w #$48, d2
        subi.w #$48, d2
L058_00000A72:
; H058+$00000A72: 0c420008  cmpi.w #$8, d2
        cmpi.w #$8, d2
L058_00000A76:
; H058+$00000A76: 6302  bls.b $a7a
        bls.b H058+$A7A
L058_00000A78:
; H058+$00000A78: 74ff  moveq #$ff, d2
        moveq #-1, d2
L058_00000A7A:
; H058+$00000A7A: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000A7C:
; H058+$00000A7C: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H058+$0A58; indici 0..8, default -1.
L058_00000A80:
; H058+$00000A80: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L058_00000A84:
; H058+$00000A84: 0c2d000dfffd  cmpi.b #$d, -$3(a5)
        cmpi.b #$d, -$3(a5)
L058_00000A8A:
; H058+$00000A8A: 66000008  bne.w $a94
        bne.w H058+$A94
L058_00000A8E:
; H058+$00000A8E: 1b7c0052fffd  move.b #$52, -$3(a5)
        move.b #$52, -$3(a5)
L058_00000A94:
; H058+$00000A94: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000A96:
; H058+$00000A96: 142dfffd  move.b -$3(a5), d2
        move.b -$3(a5), d2
L058_00000A9A:
; H058+$00000A9A: 600000a4  bra.w $b40
        bra.w H058+$B40
L058_00000A9E:
; H058+$00000A9E: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L058_00000AA4:
; H058+$00000AA4: 4e75  rts 
        rts 
L058_00000AA6:
; H058+$00000AA6: 1b7c0004fffc  move.b #$4, -$4(a5)
        move.b #$4, -$4(a5)
L058_00000AAC:
; H058+$00000AAC: 4e75  rts 
        rts 
L058_00000AAE:
; H058+$00000AAE: 1b7c0003fffc  move.b #$3, -$4(a5)
        move.b #$3, -$4(a5)
L058_00000AB4:
; H058+$00000AB4: 4e75  rts 
        rts 
L058_00000AB6:
; H058+$00000AB6: 1b7c0002fffc  move.b #$2, -$4(a5)
        move.b #$2, -$4(a5)
L058_00000ABC:
; H058+$00000ABC: 4e75  rts 
        rts 
L058_00000ABE:
; H058+$00000ABE: 0c2d0002fffc  cmpi.b #$2, -$4(a5)
        cmpi.b #$2, -$4(a5)
L058_00000AC4:
; H058+$00000AC4: 6600000c  bne.w $ad2
        bne.w H058+$AD2
L058_00000AC8:
; H058+$00000AC8: 5a79000024f6  addq.w #$5, $24f6.l
        addq.w #$5, (H005+$24F6).l
L058_00000ACE:
; H058+$00000ACE: 60000014  bra.w $ae4
        bra.w H058+$AE4
L058_00000AD2:
; H058+$00000AD2: 7400  moveq #$0, d2
        moveq #0, d2
L058_00000AD4:
; H058+$00000AD4: 142dfffc  move.b -$4(a5), d2
        move.b -$4(a5), d2
L058_00000AD8:
; H058+$00000AD8: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000ADA:
; H058+$00000ADA: 47f9000024f4  lea.l $24f4.l, a3
        lea.l (H005+$24F4).l, a3
L058_00000AE0:
; H058+$00000AE0: 52732000  addq.w #$1, (a3, d2.w)
        addq.w #$1, (a3, d2.w)
L058_00000AE4:
; H058+$00000AE4: 6100fb0e  bsr.w $5f4
        bsr.w H058+$5F4
L058_00000AE8:
; H058+$00000AE8: 4e75  rts 
        rts 
L058_00000AEA:
; H058+$00000AEA: 0c2d0002fffc  cmpi.b #$2, -$4(a5)
        cmpi.b #$2, -$4(a5)
L058_00000AF0:
; H058+$00000AF0: 66000012  bne.w $b04
        bne.w H058+$B04
L058_00000AF4:
; H058+$00000AF4: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L058_00000AF8:
; H058+$00000AF8: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L058_00000AFC:
; H058+$00000AFC: 6100fc10  bsr.w $70e
        bsr.w H058+$70E
L058_00000B00:
; H058+$00000B00: 6000000e  bra.w $b10
        bra.w H058+$B10
L058_00000B04:
; H058+$00000B04: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_00000B08:
; H058+$00000B08: 1f2dfffc  move.b -$4(a5), -(a7)
        move.b -$4(a5), -(a7)
L058_00000B0C:
; H058+$00000B0C: 6100fc00  bsr.w $70e
        bsr.w H058+$70E
L058_00000B10:
; H058+$00000B10: 6100fae2  bsr.w $5f4
        bsr.w H058+$5F4
L058_00000B14:
; H058+$00000B14: 4e75  rts 
        rts 
L058_00000B16:
; H058+$00000B16: 4e75  rts 
        rts 
; Preserved bytes H058+$00000B18..$00000B40; code/data not fully classified.
        dc.w $FFFC,$FFA4,$FFFC,$FFFC,$FF8C,$FFFC,$FFFC,$FFFC
        dc.w $FF94,$FFFC,$FFFC,$FFFC,$FFFC,$FF9C,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FF84,$FFD0
L058_00000B40:
; H058+$00000B40: 47faffd8  lea.l $b1a(pc), a3
        lea.l H058+$B1A(pc), a3
L058_00000B44:
; H058+$00000B44: 04420041  subi.w #$41, d2
        subi.w #$41, d2
L058_00000B48:
; H058+$00000B48: 0c420012  cmpi.w #$12, d2
        cmpi.w #$12, d2
L058_00000B4C:
; H058+$00000B4C: 6302  bls.b $b50
        bls.b H058+$B50
L058_00000B4E:
; H058+$00000B4E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L058_00000B50:
; H058+$00000B50: e342  asl.w #$1, d2
        asl.w #$1, d2
L058_00000B52:
; H058+$00000B52: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H058+$0B1A; indici 0..18, default -1.
L058_00000B56:
; H058+$00000B56: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L058_00000B5A:
; H058+$00000B5A: 0c2d0052fffd  cmpi.b #$52, -$3(a5)
        cmpi.b #$52, -$3(a5)
L058_00000B60:
; H058+$00000B60: 67000014  beq.w $b76
        beq.w H058+$B76
L058_00000B64:
; H058+$00000B64: 0c2d0045fffd  cmpi.b #$45, -$3(a5)
        cmpi.b #$45, -$3(a5)
L058_00000B6A:
; H058+$00000B6A: 6700000a  beq.w $b76
        beq.w H058+$B76
L058_00000B6E:
; H058+$00000B6E: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L058_00000B72:
; H058+$00000B72: 6600fe4a  bne.w $9be
        bne.w H058+$9BE
L058_00000B76:
; H058+$00000B76: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L058_00000B7A:
; H058+$00000B7A: 60000002  bra.w $b7e
        bra.w H058+$B7E
L058_00000B7E:
; H058+$00000B7E: 4e5d  unlk a5
        unlk a5
L058_00000B80:
; H058+$00000B80: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000B82:
; H058+$00000B82: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_00000B84 [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H062+$253C, H030+$0256, H063+$0D80, H030+$0B4A.
;   - Richiama H062+$253C.
;   - Richiama H030+$0256.
;   - Richiama H063+$0D80.
;   - Richiama H030+$0B4A.
;   - Richiama H063+$1EE8.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party); H005+$3368 (personaggio corrente).
; Chiamanti diretti: H058+$1196
; --------------------------------------------------------------------------
L058_00000B84:
; H058+$00000B84: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_00000B86:
; H058+$00000B86: 287af542  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000B8A:
; H058+$00000B8A: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L058_00000B8E:
; H058+$00000B8E: 5279000024ea  addq.w #$1, $24ea.l
        addq.w #$1, (H005+$24EA).l
L058_00000B94:
; H058+$00000B94: 0c790120000024ea  cmpi.w #$120, $24ea.l
        cmpi.w #$120, (H005+$24EA).l
L058_00000B9C:
; H058+$00000B9C: 65000090  bcs.w $c2e
        bcs.w H058+$C2E
L058_00000BA0:
; H058+$00000BA0: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
; STATO: H005+$3364 = testa della lista del party
L058_00000BA4:
; H058+$00000BA4: 2b7900003364fffa  move.l $3364.l, -$6(a5)
        move.l (H005+$3364).l, -$6(a5)
L058_00000BAC:
; H058+$00000BAC: 4aadfffa  tst.l -$6(a5)
        tst.l -$6(a5)
L058_00000BB0:
; H058+$00000BB0: 6700002c  beq.w $bde
        beq.w H058+$BDE
L058_00000BB4:
; H058+$00000BB4: 2f2dfffa  move.l -$6(a5), -(a7)
        move.l -$6(a5), -(a7)
L058_00000BB8:
; H058+$00000BB8: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_00000BBC:
; H058+$00000BBC: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H062+$253C (sub_H062_0000253C)
L058_00000BBE:
; H058+$00000BBE: 4eb90000253c  jsr $253c.l
        jsr (H062+$253C).l
L058_00000BC4:
; H058+$00000BC4: 1400  move.b d0, d2
        move.b d0, d2
L058_00000BC6:
; H058+$00000BC6: 4a02  tst.b d2
        tst.b d2
L058_00000BC8:
; H058+$00000BC8: 67000008  beq.w $bd2
        beq.w H058+$BD2
L058_00000BCC:
; H058+$00000BCC: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L058_00000BD2:
; H058+$00000BD2: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L058_00000BD6:
; H058+$00000BD6: 2b6b018efffa  move.l $18e(a3), -$6(a5)
        move.l $18e(a3), -$6(a5)
L058_00000BDC:
; H058+$00000BDC: 60ce  bra.b $bac
        bra.b H058+$BAC
L058_00000BDE:
; H058+$00000BDE: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L058_00000BE2:
; H058+$00000BE2: 67000008  beq.w $bec
        beq.w H058+$BEC
L058_00000BE6:
; H058+$00000BE6: 4227  clr.b -(a7)
        clr.b -(a7)
L058_00000BE8:
; H058+$00000BE8: 6100fc62  bsr.w $84c
        bsr.w H058+$84C
L058_00000BEC:
; H058+$00000BEC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_00000BF0:
; H058+$00000BF0: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L058_00000BF4:
; H058+$00000BF4: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L058_00000BF8:
; H058+$00000BF8: 4267  clr.w -(a7)
        clr.w -(a7)
L058_00000BFA:
; H058+$00000BFA: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
L058_00000BFE:
; H058+$00000BFE: 486c003a  pea.l $3a(a4)
        pea.l $3a(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L058_00000C02:
; H058+$00000C02: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L058_00000C08:
; H058+$00000C08: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L058_00000C0C:
; H058+$00000C0C: 6700000e  beq.w $c1c
        beq.w H058+$C1C
; STATO: H005+$3368 = personaggio corrente
L058_00000C10:
; H058+$00000C10: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L058_00000C16:
; H058+$00000C16: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
; -> H030+$0B4A (sub_H030_00000B4A)
L058_00000C1C:
; H058+$00000C1C: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
; -> H063+$1EE8 (sub_H063_00001EE8)
L058_00000C22:
; H058+$00000C22: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
L058_00000C28:
; H058+$00000C28: 4279000024ea  clr.w $24ea.l
        clr.w (H005+$24EA).l
L058_00000C2E:
; H058+$00000C2E: 4e5d  unlk a5
        unlk a5
L058_00000C30:
; H058+$00000C30: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000C32:
; H058+$00000C32: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_00000C34:
; H058+$00000C34: 548f  addq.l #$2, a7
        addq.l #$2, a7
L058_00000C36:
; H058+$00000C36: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_00000C38 [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H029+$0354, H033+$18EE.
;   - Richiama H029+$0354.
;   - Richiama H033+$18EE.
; Chiamanti diretti: H058+$0F24, H058+$0FDA
; --------------------------------------------------------------------------
L058_00000C38:
; H058+$00000C38: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_00000C3A:
; H058+$00000C3A: 287af48e  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000C3E:
; H058+$00000C3E: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L058_00000C42:
; H058+$00000C42: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L058_00000C46:
; H058+$00000C46: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L058_00000C4A:
; H058+$00000C4A: 0c6d0039fffc  cmpi.w #$39, -$4(a5)
        cmpi.w #$39, -$4(a5)
L058_00000C50:
; H058+$00000C50: 620000c8  bhi.w $d1a
        bhi.w H058+$D1A
L058_00000C54:
; H058+$00000C54: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L058_00000C58:
; H058+$00000C58: 660000c0  bne.w $d1a
        bne.w H058+$D1A
L058_00000C5C:
; H058+$00000C5C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_00000C60:
; H058+$00000C60: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L058_00000C64:
; H058+$00000C64: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L058_00000C68:
; H058+$00000C68: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000C6A:
; H058+$00000C6A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L058_00000C6E:
; H058+$00000C6E: 0c44007f  cmpi.w #$7f, d4
        cmpi.w #$7f, d4
L058_00000C72:
; H058+$00000C72: 6300009e  bls.w $d12
        bls.w H058+$D12
L058_00000C76:
; H058+$00000C76: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000C7A:
; H058+$00000C7A: 4a13  tst.b (a3)
        tst.b (a3)
L058_00000C7C:
; H058+$00000C7C: 6700003a  beq.w $cb8
        beq.w H058+$CB8
L058_00000C80:
; H058+$00000C80: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_00000C84:
; H058+$00000C84: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L058_00000C88:
; H058+$00000C88: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L058_00000C8C:
; H058+$00000C8C: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L058_00000C90:
; H058+$00000C90: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L058_00000C94:
; H058+$00000C94: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L058_00000C9A:
; H058+$00000C9A: 1400  move.b d0, d2
        move.b d0, d2
L058_00000C9C:
; H058+$00000C9C: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L058_00000CA0:
; H058+$00000CA0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000CA2:
; H058+$00000CA2: e942  asl.w #$4, d2
        asl.w #$4, d2
L058_00000CA4:
; H058+$00000CA4: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L058_00000CAA:
; H058+$00000CAA: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000CAC:
; H058+$00000CAC: 18332001  move.b $1(a3, d2.w), d4
        move.b $1(a3, d2.w), d4
L058_00000CB0:
; H058+$00000CB0: 3b44fffe  move.w d4, -$2(a5)
        move.w d4, -$2(a5)
L058_00000CB4:
; H058+$00000CB4: 60000054  bra.w $d0a
        bra.w H058+$D0A
L058_00000CB8:
; H058+$00000CB8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_00000CBC:
; H058+$00000CBC: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L058_00000CC0:
; H058+$00000CC0: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L058_00000CC4:
; H058+$00000CC4: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L058_00000CC8:
; H058+$00000CC8: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L058_00000CCC:
; H058+$00000CCC: 45ea001e  lea.l $1e(a2), a2
        lea.l $1e(a2), a2
L058_00000CD0:
; H058+$00000CD0: 7c00  moveq #$0, d6
        moveq #0, d6
L058_00000CD2:
; H058+$00000CD2: 1c324000  move.b (a2, d4.w), d6
        move.b (a2, d4.w), d6
L058_00000CD6:
; H058+$00000CD6: 04460080  subi.w #$80, d6
        subi.w #$80, d6
L058_00000CDA:
; H058+$00000CDA: 17862000  move.b d6, (a3, d2.w)
        move.b d6, (a3, d2.w)
L058_00000CDE:
; H058+$00000CDE: 4227  clr.b -(a7)
        clr.b -(a7)
L058_00000CE0:
; H058+$00000CE0: 6100fb6a  bsr.w $84c
        bsr.w H058+$84C
L058_00000CE4:
; H058+$00000CE4: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L058_00000CE8:
; H058+$00000CE8: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L058_00000CEC:
; H058+$00000CEC: 486c0054  pea.l $54(a4)
        pea.l $54(a4)
L058_00000CF0:
; H058+$00000CF0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_00000CF4:
; H058+$00000CF4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L058_00000CF8:
; H058+$00000CF8: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L058_00000CFC:
; H058+$00000CFC: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000CFE:
; H058+$00000CFE: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L058_00000D02:
; H058+$00000D02: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
; -> H033+$18EE (sub_H033_000018EE)
L058_00000D04:
; H058+$00000D04: 4eb9000018ee  jsr $18ee.l
        jsr (H033+$18EE).l
L058_00000D0A:
; H058+$00000D0A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000D0E:
; H058+$00000D0E: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L058_00000D12:
; H058+$00000D12: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L058_00000D16:
; H058+$00000D16: 6000ff32  bra.w $c4a
        bra.w H058+$C4A
L058_00000D1A:
; H058+$00000D1A: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L058_00000D1E:
; H058+$00000D1E: 60000002  bra.w $d22
        bra.w H058+$D22
L058_00000D22:
; H058+$00000D22: 4e5d  unlk a5
        unlk a5
L058_00000D24:
; H058+$00000D24: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000D26:
; H058+$00000D26: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_00000D28:
; H058+$00000D28: 508f  addq.l #$8, a7
        addq.l #$8, a7
L058_00000D2A:
; H058+$00000D2A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_00000D2C [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H033+$17E6, H029+$0354, H033+$1836, H033+$18EE.
;   - Richiama H033+$17E6.
;   - Richiama H029+$0354.
;   - Richiama H033+$1836.
;   - Richiama H033+$18EE.
; Chiamanti diretti: H058+$0F0C, H058+$0FC2
; --------------------------------------------------------------------------
L058_00000D2C:
; H058+$00000D2C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_00000D2E:
; H058+$00000D2E: 287af39a  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000D32:
; H058+$00000D32: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L058_00000D36:
; H058+$00000D36: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L058_00000D3A:
; H058+$00000D3A: 422dfff5  clr.b -$b(a5)
        clr.b -$b(a5)
L058_00000D3E:
; H058+$00000D3E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L058_00000D42:
; H058+$00000D42: 2b6b0150fff6  move.l $150(a3), -$a(a5)
        move.l $150(a3), -$a(a5)
L058_00000D48:
; H058+$00000D48: 4aadfff6  tst.l -$a(a5)
        tst.l -$a(a5)
L058_00000D4C:
; H058+$00000D4C: 67000120  beq.w $e6e
        beq.w H058+$E6E
L058_00000D50:
; H058+$00000D50: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L058_00000D54:
; H058+$00000D54: 66000118  bne.w $e6e
        bne.w H058+$E6E
L058_00000D58:
; H058+$00000D58: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L058_00000D5E:
; H058+$00000D5E: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
; -> H033+$17E6 (sub_H033_000017E6)
L058_00000D62:
; H058+$00000D62: 4eb9000017e6  jsr $17e6.l
        jsr (H033+$17E6).l
L058_00000D68:
; H058+$00000D68: 1400  move.b d0, d2
        move.b d0, d2
L058_00000D6A:
; H058+$00000D6A: 4a02  tst.b d2
        tst.b d2
L058_00000D6C:
; H058+$00000D6C: 670000f2  beq.w $e60
        beq.w H058+$E60
L058_00000D70:
; H058+$00000D70: 0c6d0003fffe  cmpi.w #$3, -$2(a5)
        cmpi.w #$3, -$2(a5)
L058_00000D76:
; H058+$00000D76: 620000e8  bhi.w $e60
        bhi.w H058+$E60
L058_00000D7A:
; H058+$00000D7A: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L058_00000D7E:
; H058+$00000D7E: 660000e0  bne.w $e60
        bne.w H058+$E60
L058_00000D82:
; H058+$00000D82: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000D86:
; H058+$00000D86: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000D88:
; H058+$00000D88: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L058_00000D8C:
; H058+$00000D8C: 47eb0044  lea.l $44(a3), a3
        lea.l $44(a3), a3
L058_00000D90:
; H058+$00000D90: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000D92:
; H058+$00000D92: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L058_00000D96:
; H058+$00000D96: 0c440080  cmpi.w #$80, d4
        cmpi.w #$80, d4
L058_00000D9A:
; H058+$00000D9A: 630000bc  bls.w $e58
        bls.w H058+$E58
L058_00000D9E:
; H058+$00000D9E: 1b7c0001fff5  move.b #$1, -$b(a5)
        move.b #$1, -$b(a5)
L058_00000DA4:
; H058+$00000DA4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000DA8:
; H058+$00000DA8: 4a13  tst.b (a3)
        tst.b (a3)
L058_00000DAA:
; H058+$00000DAA: 6700003c  beq.w $de8
        beq.w H058+$DE8
L058_00000DAE:
; H058+$00000DAE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000DB2:
; H058+$00000DB2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000DB4:
; H058+$00000DB4: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L058_00000DB8:
; H058+$00000DB8: 47eb0044  lea.l $44(a3), a3
        lea.l $44(a3), a3
L058_00000DBC:
; H058+$00000DBC: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L058_00000DC0:
; H058+$00000DC0: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L058_00000DC4:
; H058+$00000DC4: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L058_00000DCA:
; H058+$00000DCA: 1400  move.b d0, d2
        move.b d0, d2
L058_00000DCC:
; H058+$00000DCC: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L058_00000DD0:
; H058+$00000DD0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000DD2:
; H058+$00000DD2: e942  asl.w #$4, d2
        asl.w #$4, d2
L058_00000DD4:
; H058+$00000DD4: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L058_00000DDA:
; H058+$00000DDA: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000DDC:
; H058+$00000DDC: 18332001  move.b $1(a3, d2.w), d4
        move.b $1(a3, d2.w), d4
L058_00000DE0:
; H058+$00000DE0: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L058_00000DE4:
; H058+$00000DE4: 60000072  bra.w $e58
        bra.w H058+$E58
L058_00000DE8:
; H058+$00000DE8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000DEC:
; H058+$00000DEC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000DEE:
; H058+$00000DEE: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L058_00000DF2:
; H058+$00000DF2: 47eb0044  lea.l $44(a3), a3
        lea.l $44(a3), a3
L058_00000DF6:
; H058+$00000DF6: 1f332000  move.b (a3, d2.w), -(a7)
        move.b (a3, d2.w), -(a7)
L058_00000DFA:
; H058+$00000DFA: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L058_00000DFE:
; H058+$00000DFE: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L058_00000E04:
; H058+$00000E04: 1400  move.b d0, d2
        move.b d0, d2
L058_00000E06:
; H058+$00000E06: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L058_00000E0A:
; H058+$00000E0A: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L058_00000E0E:
; H058+$00000E0E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L058_00000E12:
; H058+$00000E12: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000E14:
; H058+$00000E14: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L058_00000E18:
; H058+$00000E18: 47eb0066  lea.l $66(a3), a3
        lea.l $66(a3), a3
L058_00000E1C:
; H058+$00000E1C: 17bc00012000  move.b #$1, (a3, d2.w)
        move.b #$1, (a3, d2.w)
L058_00000E22:
; H058+$00000E22: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L058_00000E26:
; H058+$00000E26: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L058_00000E2A:
; H058+$00000E2A: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H033+$1836 (sub_H033_00001836)
L058_00000E2E:
; H058+$00000E2E: 4eb900001836  jsr $1836.l
        jsr (H033+$1836).l
L058_00000E34:
; H058+$00000E34: 4227  clr.b -(a7)
        clr.b -(a7)
L058_00000E36:
; H058+$00000E36: 6100fa14  bsr.w $84c
        bsr.w H058+$84C
L058_00000E3A:
; H058+$00000E3A: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L058_00000E3E:
; H058+$00000E3E: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L058_00000E42:
; H058+$00000E42: 486c0062  pea.l $62(a4)
        pea.l $62(a4)
L058_00000E46:
; H058+$00000E46: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H033+$18EE (sub_H033_000018EE)
L058_00000E4A:
; H058+$00000E4A: 4eb9000018ee  jsr $18ee.l
        jsr (H033+$18EE).l
L058_00000E50:
; H058+$00000E50: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000E54:
; H058+$00000E54: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L058_00000E58:
; H058+$00000E58: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L058_00000E5C:
; H058+$00000E5C: 6000ff12  bra.w $d70
        bra.w H058+$D70
L058_00000E60:
; H058+$00000E60: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L058_00000E64:
; H058+$00000E64: 2b6b002cfff6  move.l $2c(a3), -$a(a5)
        move.l $2c(a3), -$a(a5)
L058_00000E6A:
; H058+$00000E6A: 6000fedc  bra.w $d48
        bra.w H058+$D48
L058_00000E6E:
; H058+$00000E6E: 302dfffa  move.w -$6(a5), d0
        move.w -$6(a5), d0
L058_00000E72:
; H058+$00000E72: 60000002  bra.w $e76
        bra.w H058+$E76
L058_00000E76:
; H058+$00000E76: 4e5d  unlk a5
        unlk a5
L058_00000E78:
; H058+$00000E78: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000E7A:
; H058+$00000E7A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_00000E7C:
; H058+$00000E7C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L058_00000E7E:
; H058+$00000E7E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_00000E80 [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; opera su H005+$3364 (testa della lista del party).
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H058+$119A
; --------------------------------------------------------------------------
L058_00000E80:
; H058+$00000E80: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_00000E82:
; H058+$00000E82: 287af246  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000E86:
; H058+$00000E86: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L058_00000E8A:
; H058+$00000E8A: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
; STATO: H005+$3364 = testa della lista del party
L058_00000E90:
; H058+$00000E90: 2b7900003364fff8  move.l $3364.l, -$8(a5)
        move.l (H005+$3364).l, -$8(a5)
L058_00000E98:
; H058+$00000E98: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L058_00000E9C:
; H058+$00000E9C: 670000b8  beq.w $f56
        beq.w H058+$F56
L058_00000EA0:
; H058+$00000EA0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000EA4:
; H058+$00000EA4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000EA6:
; H058+$00000EA6: 47f9000024ec  lea.l $24ec.l, a3
        lea.l (H005+$24EC).l, a3
L058_00000EAC:
; H058+$00000EAC: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000EAE:
; H058+$00000EAE: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L058_00000EB2:
; H058+$00000EB2: 4a44  tst.w d4
        tst.w d4
L058_00000EB4:
; H058+$00000EB4: 63000026  bls.w $edc
        bls.w H058+$EDC
L058_00000EB8:
; H058+$00000EB8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000EBC:
; H058+$00000EBC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000EBE:
; H058+$00000EBE: 47f9000024ec  lea.l $24ec.l, a3
        lea.l (H005+$24EC).l, a3
L058_00000EC4:
; H058+$00000EC4: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L058_00000EC8:
; H058+$00000EC8: 5344  subq.w #$1, d4
        subq.w #$1, d4
L058_00000ECA:
; H058+$00000ECA: 45f9000024ec  lea.l $24ec.l, a2
        lea.l (H005+$24EC).l, a2
L058_00000ED0:
; H058+$00000ED0: 7c00  moveq #$0, d6
        moveq #0, d6
L058_00000ED2:
; H058+$00000ED2: 1c324000  move.b (a2, d4.w), d6
        move.b (a2, d4.w), d6
L058_00000ED6:
; H058+$00000ED6: 5346  subq.w #$1, d6
        subq.w #$1, d6
L058_00000ED8:
; H058+$00000ED8: 17862000  move.b d6, (a3, d2.w)
        move.b d6, (a3, d2.w)
L058_00000EDC:
; H058+$00000EDC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000EE0:
; H058+$00000EE0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000EE2:
; H058+$00000EE2: 47f9000024ec  lea.l $24ec.l, a3
        lea.l (H005+$24EC).l, a3
L058_00000EE8:
; H058+$00000EE8: 7800  moveq #$0, d4
        moveq #0, d4
L058_00000EEA:
; H058+$00000EEA: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L058_00000EEE:
; H058+$00000EEE: 4a44  tst.w d4
        tst.w d4
L058_00000EF0:
; H058+$00000EF0: 66000052  bne.w $f44
        bne.w H058+$F44
L058_00000EF4:
; H058+$00000EF4: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L058_00000EF8:
; H058+$00000EF8: 4a6b0058  tst.w $58(a3)
        tst.w $58(a3)
L058_00000EFC:
; H058+$00000EFC: 66000046  bne.w $f44
        bne.w H058+$F44
L058_00000F00:
; H058+$00000F00: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L058_00000F04:
; H058+$00000F04: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L058_00000F08:
; H058+$00000F08: 486dfff7  pea.l -$9(a5)
        pea.l -$9(a5)
L058_00000F0C:
; H058+$00000F0C: 6100fe1e  bsr.w $d2c
        bsr.w H058+$D2C
L058_00000F10:
; H058+$00000F10: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L058_00000F14:
; H058+$00000F14: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L058_00000F18:
; H058+$00000F18: 66000012  bne.w $f2c
        bne.w H058+$F2C
L058_00000F1C:
; H058+$00000F1C: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L058_00000F20:
; H058+$00000F20: 486dfff7  pea.l -$9(a5)
        pea.l -$9(a5)
L058_00000F24:
; H058+$00000F24: 6100fd12  bsr.w $c38
        bsr.w H058+$C38
L058_00000F28:
; H058+$00000F28: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L058_00000F2C:
; H058+$00000F2C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000F30:
; H058+$00000F30: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000F32:
; H058+$00000F32: 47f9000024ec  lea.l $24ec.l, a3
        lea.l (H005+$24EC).l, a3
L058_00000F38:
; H058+$00000F38: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L058_00000F3C:
; H058+$00000F3C: c8fc0003  mulu.w #$3, d4
        mulu.w #$3, d4
L058_00000F40:
; H058+$00000F40: 17842000  move.b d4, (a3, d2.w)
        move.b d4, (a3, d2.w)
L058_00000F44:
; H058+$00000F44: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L058_00000F48:
; H058+$00000F48: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
L058_00000F4E:
; H058+$00000F4E: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L058_00000F52:
; H058+$00000F52: 6000ff44  bra.w $e98
        bra.w H058+$E98
L058_00000F56:
; H058+$00000F56: 4e5d  unlk a5
        unlk a5
L058_00000F58:
; H058+$00000F58: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00000F5A:
; H058+$00000F5A: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_00000F5C [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; opera su H005+$3364 (testa della lista del party).
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H058+$11A2
; --------------------------------------------------------------------------
L058_00000F5C:
; H058+$00000F5C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_00000F5E:
; H058+$00000F5E: 287af16a  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_00000F62:
; H058+$00000F62: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L058_00000F66:
; H058+$00000F66: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000F6A:
; H058+$00000F6A: 5253  addq.w #$1, (a3)
        addq.w #$1, (a3)
L058_00000F6C:
; H058+$00000F6C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000F70:
; H058+$00000F70: 0c53000c  cmpi.w #$c, (a3)
        cmpi.w #$c, (a3)
L058_00000F74:
; H058+$00000F74: 65000094  bcs.w $100a
        bcs.w H058+$100A
L058_00000F78:
; H058+$00000F78: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L058_00000F7C:
; H058+$00000F7C: 4253  clr.w (a3)
        clr.w (a3)
L058_00000F7E:
; H058+$00000F7E: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
; STATO: H005+$3364 = testa della lista del party
L058_00000F84:
; H058+$00000F84: 2b7900003364fff8  move.l $3364.l, -$8(a5)
        move.l (H005+$3364).l, -$8(a5)
L058_00000F8C:
; H058+$00000F8C: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L058_00000F90:
; H058+$00000F90: 67000078  beq.w $100a
        beq.w H058+$100A
L058_00000F94:
; H058+$00000F94: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L058_00000F98:
; H058+$00000F98: 4a6b0058  tst.w $58(a3)
        tst.w $58(a3)
L058_00000F9C:
; H058+$00000F9C: 6f00005c  ble.w $ffa
        ble.w H058+$FFA
L058_00000FA0:
; H058+$00000FA0: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L058_00000FA4:
; H058+$00000FA4: 536b0058  subq.w #$1, $58(a3)
        subq.w #$1, $58(a3)
L058_00000FA8:
; H058+$00000FA8: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L058_00000FAC:
; H058+$00000FAC: 4a6b0058  tst.w $58(a3)
        tst.w $58(a3)
L058_00000FB0:
; H058+$00000FB0: 66000048  bne.w $ffa
        bne.w H058+$FFA
L058_00000FB4:
; H058+$00000FB4: 1b7c0001fff7  move.b #$1, -$9(a5)
        move.b #$1, -$9(a5)
L058_00000FBA:
; H058+$00000FBA: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L058_00000FBE:
; H058+$00000FBE: 486dfff7  pea.l -$9(a5)
        pea.l -$9(a5)
L058_00000FC2:
; H058+$00000FC2: 6100fd68  bsr.w $d2c
        bsr.w H058+$D2C
L058_00000FC6:
; H058+$00000FC6: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L058_00000FCA:
; H058+$00000FCA: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L058_00000FCE:
; H058+$00000FCE: 66000012  bne.w $fe2
        bne.w H058+$FE2
L058_00000FD2:
; H058+$00000FD2: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L058_00000FD6:
; H058+$00000FD6: 486dfff7  pea.l -$9(a5)
        pea.l -$9(a5)
L058_00000FDA:
; H058+$00000FDA: 6100fc5c  bsr.w $c38
        bsr.w H058+$C38
L058_00000FDE:
; H058+$00000FDE: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L058_00000FE2:
; H058+$00000FE2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L058_00000FE6:
; H058+$00000FE6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00000FE8:
; H058+$00000FE8: 47f9000024ec  lea.l $24ec.l, a3
        lea.l (H005+$24EC).l, a3
L058_00000FEE:
; H058+$00000FEE: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L058_00000FF2:
; H058+$00000FF2: c8fc0003  mulu.w #$3, d4
        mulu.w #$3, d4
L058_00000FF6:
; H058+$00000FF6: 17842000  move.b d4, (a3, d2.w)
        move.b d4, (a3, d2.w)
L058_00000FFA:
; H058+$00000FFA: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L058_00000FFE:
; H058+$00000FFE: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
L058_00001004:
; H058+$00001004: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L058_00001008:
; H058+$00001008: 6082  bra.b $f8c
        bra.b H058+$F8C
L058_0000100A:
; H058+$0000100A: 4e5d  unlk a5
        unlk a5
L058_0000100C:
; H058+$0000100C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_0000100E:
; H058+$0000100E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_00001010:
; H058+$00001010: 588f  addq.l #$4, a7
        addq.l #$4, a7
L058_00001012:
; H058+$00001012: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H058_00001014 [parziale]
; Scopo: Routine del modulo riposo e memorizzazione/recupero; richiama H029+$0312, H030+$0B6C, H029+$01B6, H010+$042E.
;   - Richiama H029+$0312.
;   - Richiama H030+$0B6C.
;   - Richiama H029+$01B6.
;   - Richiama H010+$042E.
;   - Richiama H008+$203C.
;   - Richiama H008+$139E.
;   - Richiama H062+$156C.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party); H005+$5305 (byte del tasto/azione pendente); H005+$3E00 (puntatore stato persistente B, 2048 byte).
; Chiamanti diretti: H057+$123A, H057+$2EEA
; --------------------------------------------------------------------------
L058_00001014:
; H058+$00001014: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L058_00001016:
; H058+$00001016: 287af0b2  movea.l $ca(pc), a4
        movea.l H058+$CA(pc), a4
L058_0000101A:
; H058+$0000101A: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L058_0000101E:
; H058+$0000101E: 422dffed  clr.b -$13(a5)
        clr.b -$13(a5)
L058_00001022:
; H058+$00001022: 422dffee  clr.b -$12(a5)
        clr.b -$12(a5)
L058_00001026:
; H058+$00001026: 3b7c0001fff4  move.w #$1, -$c(a5)
        move.w #$1, -$c(a5)
; STATO: H005+$3364 = testa della lista del party
L058_0000102C:
; H058+$0000102C: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L058_00001034:
; H058+$00001034: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L058_00001038:
; H058+$00001038: 67000022  beq.w $105c
        beq.w H058+$105C
L058_0000103C:
; H058+$0000103C: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L058_00001040:
; H058+$00001040: 5342  subq.w #$1, d2
        subq.w #$1, d2
L058_00001042:
; H058+$00001042: 47f9000024ec  lea.l $24ec.l, a3
        lea.l (H005+$24EC).l, a3
L058_00001048:
; H058+$00001048: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L058_0000104C:
; H058+$0000104C: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L058_00001050:
; H058+$00001050: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L058_00001054:
; H058+$00001054: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L058_0000105A:
; H058+$0000105A: 60d8  bra.b $1034
        bra.b H058+$1034
L058_0000105C:
; H058+$0000105C: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L058_00001060:
; H058+$00001060: 486cffd8  pea.l -$28(a4)
        pea.l -$28(a4)
L058_00001064:
; H058+$00001064: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L058_00001068:
; H058+$00001068: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H029+$0312 (sub_H029_00000312)
L058_0000106C:
; H058+$0000106C: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L058_00001072:
; H058+$00001072: 426dfff2  clr.w -$e(a5)
        clr.w -$e(a5)
L058_00001076:
; H058+$00001076: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L058_0000107A:
; H058+$0000107A: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L058_0000107E:
; H058+$0000107E: 6700001e  beq.w $109e
        beq.w H058+$109E
L058_00001082:
; H058+$00001082: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_00001086:
; H058+$00001086: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L058_0000108A:
; H058+$0000108A: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L058_0000108E:
; H058+$0000108E: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L058_00001092:
; H058+$00001092: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L058_00001098:
; H058+$00001098: 4227  clr.b -(a7)
        clr.b -(a7)
L058_0000109A:
; H058+$0000109A: 6100f7b0  bsr.w $84c
        bsr.w H058+$84C
L058_0000109E:
; H058+$0000109E: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
; -> H029+$01B6 (sub_H029_000001B6)
L058_000010A2:
; H058+$000010A2: 4eb9000001b6  jsr $1b6.l
        jsr (H029+$1B6).l
L058_000010A8:
; H058+$000010A8: 13fc0001000024e2  move.b #$1, $24e2.l
        move.b #$1, (H005+$24E2).l
L058_000010B0:
; H058+$000010B0: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L058_000010B4:
; H058+$000010B4: 67000016  beq.w $10cc
        beq.w H058+$10CC
L058_000010B8:
; H058+$000010B8: 6100f8f0  bsr.w $9aa
        bsr.w H058+$9AA
L058_000010BC:
; H058+$000010BC: 1400  move.b d0, d2
        move.b d0, d2
L058_000010BE:
; H058+$000010BE: 4a02  tst.b d2
        tst.b d2
L058_000010C0:
; H058+$000010C0: 57c2  seq.b d2
        seq.b d2
L058_000010C2:
; H058+$000010C2: 4402  neg.b d2
        neg.b d2
L058_000010C4:
; H058+$000010C4: 1b42ffef  move.b d2, -$11(a5)
        move.b d2, -$11(a5)
L058_000010C8:
; H058+$000010C8: 60000006  bra.w $10d0
        bra.w H058+$10D0
L058_000010CC:
; H058+$000010CC: 422dffef  clr.b -$11(a5)
        clr.b -$11(a5)
L058_000010D0:
; H058+$000010D0: 4a2dffef  tst.b -$11(a5)
        tst.b -$11(a5)
L058_000010D4:
; H058+$000010D4: 6600015a  bne.w $1230
        bne.w H058+$1230
L058_000010D8:
; H058+$000010D8: 4a79000024fc  tst.w $24fc.l
        tst.w (H005+$24FC).l
L058_000010DE:
; H058+$000010DE: 62000020  bhi.w $1100
        bhi.w H058+$1100
L058_000010E2:
; H058+$000010E2: 4a79000024fa  tst.w $24fa.l
        tst.w (H005+$24FA).l
L058_000010E8:
; H058+$000010E8: 62000016  bhi.w $1100
        bhi.w H058+$1100
L058_000010EC:
; H058+$000010EC: 4a79000024f8  tst.w $24f8.l
        tst.w (H005+$24F8).l
L058_000010F2:
; H058+$000010F2: 6200000c  bhi.w $1100
        bhi.w H058+$1100
L058_000010F6:
; H058+$000010F6: 4a79000024f6  tst.w $24f6.l
        tst.w (H005+$24F6).l
L058_000010FC:
; H058+$000010FC: 63000132  bls.w $1230
        bls.w H058+$1230
; -> H010+$042E (trampoline_H010_0882)
L058_00001100:
; H058+$00001100: 4eb90000042e  jsr $42e.l
        jsr (H010+$42E).l
L058_00001106:
; H058+$00001106: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L058_0000110A:
; H058+$0000110A: 67000046  beq.w $1152
        beq.w H058+$1152
; STATO: H005+$5305 = byte del tasto/azione pendente
L058_0000110E:
; H058+$0000110E: 4a3900005305  tst.b $5305.l
        tst.b (H005+$5305).l
L058_00001114:
; H058+$00001114: 6700003c  beq.w $1152
        beq.w H058+$1152
L058_00001118:
; H058+$00001118: 4227  clr.b -(a7)
        clr.b -(a7)
L058_0000111A:
; H058+$0000111A: 6100f730  bsr.w $84c
        bsr.w H058+$84C
L058_0000111E:
; H058+$0000111E: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L058_00001122:
; H058+$00001122: 486c006e  pea.l $6e(a4)
        pea.l $6e(a4)
L058_00001126:
; H058+$00001126: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L058_0000112A:
; H058+$0000112A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L058_0000112E:
; H058+$0000112E: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H008+$203C (sub_H008_0000203C)
L058_00001132:
; H058+$00001132: 4eb90000203c  jsr $203c.l
        jsr (H008+$203C).l
L058_00001138:
; H058+$00001138: 1400  move.b d0, d2
        move.b d0, d2
L058_0000113A:
; H058+$0000113A: 0c020059  cmpi.b #$59, d2
        cmpi.b #$59, d2
L058_0000113E:
; H058+$0000113E: 6600000c  bne.w $114c
        bne.w H058+$114C
L058_00001142:
; H058+$00001142: 1b7c0001ffef  move.b #$1, -$11(a5)
        move.b #$1, -$11(a5)
L058_00001148:
; H058+$00001148: 60000008  bra.w $1152
        bra.w H058+$1152
; -> H008+$139E (sub_H008_0000139E)
L058_0000114C:
; H058+$0000114C: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
L058_00001152:
; H058+$00001152: 4a2dffef  tst.b -$11(a5)
        tst.b -$11(a5)
L058_00001156:
; H058+$00001156: 660000d4  bne.w $122c
        bne.w H058+$122C
L058_0000115A:
; H058+$0000115A: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L058_0000115E:
; H058+$0000115E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L058_00001162:
; H058+$00001162: 6100f5aa  bsr.w $70e
        bsr.w H058+$70E
L058_00001166:
; H058+$00001166: 526dfff0  addq.w #$1, -$10(a5)
        addq.w #$1, -$10(a5)
L058_0000116A:
; H058+$0000116A: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L058_0000116E:
; H058+$0000116E: 67000016  beq.w $1186
        beq.w H058+$1186
L058_00001172:
; H058+$00001172: 0c6d0005fff0  cmpi.w #$5, -$10(a5)
        cmpi.w #$5, -$10(a5)
L058_00001178:
; H058+$00001178: 6500000c  bcs.w $1186
        bcs.w H058+$1186
L058_0000117C:
; H058+$0000117C: 4227  clr.b -(a7)
        clr.b -(a7)
L058_0000117E:
; H058+$0000117E: 6100f6cc  bsr.w $84c
        bsr.w H058+$84C
L058_00001182:
; H058+$00001182: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L058_00001186:
; H058+$00001186: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L058_0000118A:
; H058+$0000118A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L058_0000118E:
; H058+$0000118E: 6100f4ba  bsr.w $64a
        bsr.w H058+$64A
L058_00001192:
; H058+$00001192: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L058_00001196:
; H058+$00001196: 6100f9ec  bsr.w $b84
        bsr.w H058+$B84
L058_0000119A:
; H058+$0000119A: 6100fce4  bsr.w $e80
        bsr.w H058+$E80
L058_0000119E:
; H058+$0000119E: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
L058_000011A2:
; H058+$000011A2: 6100fdb8  bsr.w $f5c
        bsr.w H058+$F5C
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L058_000011A6:
; H058+$000011A6: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L058_000011AC:
; H058+$000011AC: 4a6b05a4  tst.w $5a4(a3)
        tst.w $5a4(a3)
L058_000011B0:
; H058+$000011B0: 6300007a  bls.w $122c
        bls.w H058+$122C
L058_000011B4:
; H058+$000011B4: 527900003dde  addq.w #$1, $3dde.l
        addq.w #$1, (H005+$3DDE).l
L058_000011BA:
; H058+$000011BA: 343900003dde  move.w $3dde.l, d2
        move.w (H005+$3DDE).l, d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L058_000011C0:
; H058+$000011C0: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L058_000011C6:
; H058+$000011C6: b46b05a4  cmp.w $5a4(a3), d2
        cmp.w $5a4(a3), d2
L058_000011CA:
; H058+$000011CA: 65000060  bcs.w $122c
        bcs.w H058+$122C
L058_000011CE:
; H058+$000011CE: 427900003dde  clr.w $3dde.l
        clr.w (H005+$3DDE).l
L058_000011D4:
; H058+$000011D4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_000011D8:
; H058+$000011D8: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L058_000011DC:
; H058+$000011DC: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L058_000011E2:
; H058+$000011E2: 3400  move.w d0, d2
        move.w d0, d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L058_000011E4:
; H058+$000011E4: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L058_000011EA:
; H058+$000011EA: b46b05a6  cmp.w $5a6(a3), d2
        cmp.w $5a6(a3), d2
L058_000011EE:
; H058+$000011EE: 6200003c  bhi.w $122c
        bhi.w H058+$122C
; -> H063+$1EE8 (sub_H063_00001EE8)
L058_000011F2:
; H058+$000011F2: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
L058_000011F8:
; H058+$000011F8: 4227  clr.b -(a7)
        clr.b -(a7)
L058_000011FA:
; H058+$000011FA: 6100f650  bsr.w $84c
        bsr.w H058+$84C
L058_000011FE:
; H058+$000011FE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_00001202:
; H058+$00001202: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L058_00001206:
; H058+$00001206: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L058_0000120A:
; H058+$0000120A: 4267  clr.w -(a7)
        clr.w -(a7)
L058_0000120C:
; H058+$0000120C: 3f3c0024  move.w #$24, -(a7)
        move.w #$24, -(a7)
L058_00001210:
; H058+$00001210: 486c007d  pea.l $7d(a4)
        pea.l $7d(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L058_00001214:
; H058+$00001214: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L058_0000121A:
; H058+$0000121A: 1b7c0001ffef  move.b #$1, -$11(a5)
        move.b #$1, -$11(a5)
L058_00001220:
; H058+$00001220: 1b7c0001ffed  move.b #$1, -$13(a5)
        move.b #$1, -$13(a5)
; -> H030+$0B4A (sub_H030_00000B4A)
L058_00001226:
; H058+$00001226: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L058_0000122C:
; H058+$0000122C: 6000fea2  bra.w $10d0
        bra.w H058+$10D0
L058_00001230:
; H058+$00001230: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L058_00001234:
; H058+$00001234: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L058_00001238:
; H058+$00001238: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L058_0000123C:
; H058+$0000123C: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L058_00001240:
; H058+$00001240: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L058_00001246:
; H058+$00001246: 4239000024e2  clr.b $24e2.l
        clr.b (H005+$24E2).l
L058_0000124C:
; H058+$0000124C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; -> H029+$01B6 (sub_H029_000001B6)
L058_00001250:
; H058+$00001250: 4eb9000001b6  jsr $1b6.l
        jsr (H029+$1B6).l
L058_00001256:
; H058+$00001256: 102dffed  move.b -$13(a5), d0
        move.b -$13(a5), d0
L058_0000125A:
; H058+$0000125A: 60000002  bra.w $125e
        bra.w H058+$125E
L058_0000125E:
; H058+$0000125E: 4e5d  unlk a5
        unlk a5
L058_00001260:
; H058+$00001260: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_00001262:
; H058+$00001262: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L058_00001264:
; H058+$00001264: 548f  addq.l #$2, a7
        addq.l #$2, a7
L058_00001266:
; H058+$00001266: 4ed0  jmp (a0)
        jmp (a0)
L058_00001268:
; H058+$00001268: 4e5d  unlk a5
        unlk a5
L058_0000126A:
; H058+$0000126A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L058_0000126C:
; H058+$0000126C: 4e75  rts 
        rts 
; Preserved bytes H058+$0000126E..$00001270; code/data not fully classified.
        dc.w $0000
; End H058: $1270 bytes
