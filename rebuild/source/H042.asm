; ============================================================================
; GUIDA DEL MODULO H042
; Sequenze grafiche, cache, HEAD/BODY e BIGPIC.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Sequenze grafiche: cache, caricamento HEAD/BODY, BIGPIC, frame e distruzione delle sequenze. Usa il lettore ILBM e i record grafici.
; --------------------------------------------------------------------------
; H042: 4420 original bytes; all offsets are section-relative.
        section H042,code
H042:
; Preserved bytes H042+$00000000..$00000146; code/data not fully classified.
        dc.w $0000,$7374,$6172,$7420,$7465,$7374,$6368,$6970
        dc.w $616C,$6C6F,$6300,$6578,$6974,$2074,$6573,$7463
        dc.w $6869,$7061,$6C6C,$6F63,$0000,$004C,$6F61,$6469
        dc.w $6E67,$2E2E,$2E50,$6C65,$6173,$6520,$5761,$6974
        dc.w $0050,$4943,$0046,$494E,$414C,$002E,$6461,$6100
        dc.w $436F,$756C,$6420,$6E6F,$7420,$6F70,$656E,$2069
        dc.w $6E64,$6578,$6564,$2066,$696C,$6520,$696E,$206C
        dc.w $6F61,$6473,$6571,$7565,$6E63,$6521,$0A00,$4572
        dc.w $726F,$7220,$756E,$7061,$636B,$696E,$6720,$726F
        dc.w $7720,$696E,$204C,$6F61,$6453,$6571,$7565,$6E63
        dc.w $6521,$0A00,$4572,$726F,$7220,$6361,$6C6C,$696E
        dc.w $6720,$556E,$5061,$636B,$526F,$7720,$696E,$204C
        dc.w $6F61,$6453,$6571,$7565,$6E63,$6521,$0A00,$4572
        dc.w $726F,$7220,$696E,$2055,$6E50,$6163,$6B52,$6F77
        dc.w $2069,$6E20,$6C6F,$6164,$5365,$7175,$656E,$6365
        dc.w $210A,$0048,$4541,$4400,$6865,$6164,$204E,$4F54
        dc.w $2066,$6F75,$6E64,$0042,$4F44,$5900,$6865,$6164
        dc.w $206E,$6F74,$2066,$6F75,$6E64,$0049,$6C6C,$6567
        dc.w $616C,$2072,$616E,$6765,$2069,$6E20,$5368,$6F77
        dc.w $3344,$5370,$7269,$7465,$2E00,$4249,$4750,$4943
        dc.w $0000
        dc.l H042+$00000002
; --------------------------------------------------------------------------
; ROUTINE: module_init_H042 [parziale]
; Scopo: Ingresso del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H042+$1134.
; Chiamanti diretti: H000+$0156
; --------------------------------------------------------------------------
L042_00000146:
; H042+$00000146: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000148:
; H042+$00000148: 287afff8  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_0000014C:
; H042+$0000014C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L042_00000150:
; H042+$00000150: 60000fe2  bra.w $1134
        bra.w H042+$1134
; Preserved bytes H042+$00000154..$000001AE; code/data not fully classified.
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
; ROUTINE: sub_H042_000001AE [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; richiama H029+$0408, H049+$09D6, H029+$067A.
;   - Richiama H029+$0408.
;   - Richiama H049+$09D6.
;   - Richiama H029+$067A.
; Chiamanti diretti: H042+$0BA8, H042+$0BC0, H042+$0CEA, H042+$08C6, H042+$0A08
; --------------------------------------------------------------------------
L042_000001AE:
; H042+$000001AE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_000001B0:
; H042+$000001B0: 287aff90  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_000001B4:
; H042+$000001B4: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L042_000001B8:
; H042+$000001B8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_000001BC:
; H042+$000001BC: 4a93  tst.l (a3)
        tst.l (a3)
L042_000001BE:
; H042+$000001BE: 6700008a  beq.w $24a
        beq.w H042+$24A
L042_000001C2:
; H042+$000001C2: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_000001C6:
; H042+$000001C6: 2652  movea.l (a2), a3
        movea.l (a2), a3
L042_000001C8:
; H042+$000001C8: 4aab000c  tst.l $c(a3)
        tst.l $c(a3)
L042_000001CC:
; H042+$000001CC: 6700000c  beq.w $1da
        beq.w H042+$1DA
L042_000001D0:
; H042+$000001D0: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L042_000001D6:
; H042+$000001D6: 60000006  bra.w $1de
        bra.w H042+$1DE
L042_000001DA:
; H042+$000001DA: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L042_000001DE:
; H042+$000001DE: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_000001E2:
; H042+$000001E2: 2652  movea.l (a2), a3
        movea.l (a2), a3
L042_000001E4:
; H042+$000001E4: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L042_000001E6:
; H042+$000001E6: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_000001EA:
; H042+$000001EA: 2652  movea.l (a2), a3
        movea.l (a2), a3
L042_000001EC:
; H042+$000001EC: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L042_000001F0:
; H042+$000001F0: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_000001F4:
; H042+$000001F4: 2652  movea.l (a2), a3
        movea.l (a2), a3
L042_000001F6:
; H042+$000001F6: 3f2b0008  move.w $8(a3), -(a7)
        move.w $8(a3), -(a7)
L042_000001FA:
; H042+$000001FA: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L042_000001FE:
; H042+$000001FE: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLUSSO: Chiama Allocate_GraphicRecord (H029+$0408).
L042_00000202:
; H042+$00000202: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L042_00000208:
; H042+$00000208: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_0000020C:
; H042+$0000020C: 2652  movea.l (a2), a3
        movea.l (a2), a3
L042_0000020E:
; H042+$0000020E: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L042_00000212:
; H042+$00000212: 356b00040004  move.w $4(a3), $4(a2)
        move.w $4(a3), $4(a2)
L042_00000218:
; H042+$00000218: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_0000021C:
; H042+$0000021C: 2652  movea.l (a2), a3
        movea.l (a2), a3
L042_0000021E:
; H042+$0000021E: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L042_00000222:
; H042+$00000222: 356b00060006  move.w $6(a3), $6(a2)
        move.w $6(a3), $6(a2)
L042_00000228:
; H042+$00000228: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_0000022C:
; H042+$0000022C: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L042_0000022E:
; H042+$0000022E: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H049+$09D6 (sub_H049_000009D6)
L042_00000232:
; H042+$00000232: 4eb9000009d6  jsr $9d6.l
        jsr (H049+$9D6).l
L042_00000238:
; H042+$00000238: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; FLUSSO: Chiama Free_GraphicRecord (H029+$067A).
L042_0000023C:
; H042+$0000023C: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L042_00000242:
; H042+$00000242: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000246:
; H042+$00000246: 26adfffc  move.l -$4(a5), (a3)
        move.l -$4(a5), (a3)
L042_0000024A:
; H042+$0000024A: 4e5d  unlk a5
        unlk a5
L042_0000024C:
; H042+$0000024C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_0000024E:
; H042+$0000024E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_00000250:
; H042+$00000250: 588f  addq.l #$4, a7
        addq.l #$4, a7
L042_00000252:
; H042+$00000252: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H042_00000254 [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; richiama H029+$1718, H029+$16A2, H022+$0084, H029+$0E92.
;   - Richiama H029+$1718.
;   - Richiama H029+$16A2.
;   - Richiama H022+$0084.
;   - Richiama H029+$0E92.
;   - Richiama H029+$16DE.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H008+$075C, H063+$3274, H042+$0F3C, H042+$02CA, H042+$02F2, H012+$2466 e altri 3
; --------------------------------------------------------------------------
L042_00000254:
; H042+$00000254: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000256:
; H042+$00000256: 287afeea  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_0000025A:
; H042+$0000025A: 4e55ffde  link.w a5, #$ffde
        link.w a5, #$ffde
L042_0000025E:
; H042+$0000025E: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L042_00000262:
; H042+$00000262: 67000042  beq.w $2a6
        beq.w H042+$2A6
; -> H029+$1718 (sub_H029_00001718)
L042_00000266:
; H042+$00000266: 4eb900001718  jsr $1718.l
        jsr (H029+$1718).l
; -> H029+$16A2 (sub_H029_000016A2)
L042_0000026C:
; H042+$0000026C: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L042_00000272:
; H042+$00000272: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L042_00000278:
; H042+$00000278: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L042_0000027C:
; H042+$0000027C: 47f9000052ae  lea.l $52ae.l, a3
        lea.l (H005+$52AE).l, a3
L042_00000282:
; H042+$00000282: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000284:
; H042+$00000284: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L042_00000288:
; H042+$00000288: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L042_0000028E:
; H042+$0000028E: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L042_00000292:
; H042+$00000292: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L042_00000296:
; H042+$00000296: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H029+$0E92 (trampoline_H029_0EF4)
L042_0000029A:
; H042+$0000029A: 4eb900000e92  jsr $e92.l
        jsr (H029+$E92).l
; -> H029+$16DE (sub_H029_000016DE)
L042_000002A0:
; H042+$000002A0: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L042_000002A6:
; H042+$000002A6: 4e5d  unlk a5
        unlk a5
L042_000002A8:
; H042+$000002A8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_000002AA:
; H042+$000002AA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_000002AC:
; H042+$000002AC: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L042_000002B0:
; H042+$000002B0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H042_000002B2 [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H042+$0F12
; --------------------------------------------------------------------------
L042_000002B2:
; H042+$000002B2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_000002B4:
; H042+$000002B4: 287afe8c  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_000002B8:
; H042+$000002B8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L042_000002BC:
; H042+$000002BC: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L042_000002C0:
; H042+$000002C0: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L042_000002C4:
; H042+$000002C4: 4227  clr.b -(a7)
        clr.b -(a7)
L042_000002C6:
; H042+$000002C6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L042_000002CA:
; H042+$000002CA: 6188  bsr.b $254
        bsr.b H042+$254
L042_000002CC:
; H042+$000002CC: 4e5d  unlk a5
        unlk a5
L042_000002CE:
; H042+$000002CE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_000002D0:
; H042+$000002D0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_000002D2:
; H042+$000002D2: 508f  addq.l #$8, a7
        addq.l #$8, a7
L042_000002D4:
; H042+$000002D4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H042_000002D6 [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H042+$0F24
; --------------------------------------------------------------------------
L042_000002D6:
; H042+$000002D6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_000002D8:
; H042+$000002D8: 287afe68  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_000002DC:
; H042+$000002DC: 4e550000  link.w a5, #$0
        link.w a5, #$0
L042_000002E0:
; H042+$000002E0: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L042_000002E4:
; H042+$000002E4: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L042_000002E8:
; H042+$000002E8: 5a42  addq.w #$5, d2
        addq.w #$5, d2
L042_000002EA:
; H042+$000002EA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L042_000002EC:
; H042+$000002EC: 4227  clr.b -(a7)
        clr.b -(a7)
L042_000002EE:
; H042+$000002EE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L042_000002F2:
; H042+$000002F2: 6100ff60  bsr.w $254
        bsr.w H042+$254
L042_000002F6:
; H042+$000002F6: 4e5d  unlk a5
        unlk a5
L042_000002F8:
; H042+$000002F8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_000002FA:
; H042+$000002FA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_000002FC:
; H042+$000002FC: 508f  addq.l #$8, a7
        addq.l #$8, a7
L042_000002FE:
; H042+$000002FE: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Free_Sequence [verificato]
; Scopo: Libera la sequenza grafica corrente.
;   - Libera i due record grafici agli offset +6 e +$0A della struttura.
;   - Scorre i buffer dei frame successivi e li libera con la dimensione registrata.
;   - Azzera il numero di frame e invalida nome/ID della cache di sequenza.
; Chiamanti diretti: H007+$0A02, H010+$0252, H012+$09D2, H012+$3030, H042+$0666, H042+$1016, H068+$1662
; --------------------------------------------------------------------------
L042_00000300:
; H042+$00000300: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000302:
; H042+$00000302: 287afe3e  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_00000306:
; H042+$00000306: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L042_0000030A:
; H042+$0000030A: 422cffff  clr.b -$1(a4)
        clr.b -$1(a4)
L042_0000030E:
; H042+$0000030E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000312:
; H042+$00000312: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000314:
; H042+$00000314: 486b0006  pea.l $6(a3)
        pea.l $6(a3)
; FLUSSO: Chiama Free_GraphicRecord (H029+$067A).
L042_00000318:
; H042+$00000318: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L042_0000031E:
; H042+$0000031E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000320:
; H042+$00000320: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000322:
; H042+$00000322: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
; FLUSSO: Chiama Free_GraphicRecord (H029+$067A).
L042_00000326:
; H042+$00000326: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L042_0000032C:
; H042+$0000032C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000032E:
; H042+$0000032E: 3b7c0002fffe  move.w #$2, -$2(a5)
        move.w #$2, -$2(a5)
L042_00000334:
; H042+$00000334: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L042_00000338:
; H042+$00000338: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L042_0000033A:
; H042+$0000033A: 6200005a  bhi.w $396
        bhi.w H042+$396
L042_0000033E:
; H042+$0000033E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L042_00000342:
; H042+$00000342: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_00000344:
; H042+$00000344: e542  asl.w #$2, d2
        asl.w #$2, d2
L042_00000346:
; H042+$00000346: 45eb002c  lea.l $2c(a3), a2
        lea.l $2c(a3), a2
L042_0000034A:
; H042+$0000034A: 4ab22000  tst.l (a2, d2.w)
        tst.l (a2, d2.w)
L042_0000034E:
; H042+$0000034E: 67000040  beq.w $390
        beq.w H042+$390
L042_00000352:
; H042+$00000352: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000354:
; H042+$00000354: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L042_00000358:
; H042+$00000358: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_0000035A:
; H042+$0000035A: e542  asl.w #$2, d2
        asl.w #$2, d2
L042_0000035C:
; H042+$0000035C: 45eb002c  lea.l $2c(a3), a2
        lea.l $2c(a3), a2
L042_00000360:
; H042+$00000360: 2f322000  move.l (a2, d2.w), -(a7)
        move.l (a2, d2.w), -(a7)
L042_00000364:
; H042+$00000364: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L042_00000368:
; H042+$00000368: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_0000036A:
; H042+$0000036A: e342  asl.w #$1, d2
        asl.w #$1, d2
L042_0000036C:
; H042+$0000036C: 45eb001e  lea.l $1e(a3), a2
        lea.l $1e(a3), a2
L042_00000370:
; H042+$00000370: 7800  moveq #$0, d4
        moveq #0, d4
L042_00000372:
; H042+$00000372: 38322000  move.w (a2, d2.w), d4
        move.w (a2, d2.w), d4
L042_00000376:
; H042+$00000376: 2f04  move.l d4, -(a7)
        move.l d4, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L042_00000378:
; H042+$00000378: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L042_0000037E:
; H042+$0000037E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000380:
; H042+$00000380: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L042_00000384:
; H042+$00000384: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_00000386:
; H042+$00000386: e542  asl.w #$2, d2
        asl.w #$2, d2
L042_00000388:
; H042+$00000388: 45eb002c  lea.l $2c(a3), a2
        lea.l $2c(a3), a2
L042_0000038C:
; H042+$0000038C: 42b22000  clr.l (a2, d2.w)
        clr.l (a2, d2.w)
L042_00000390:
; H042+$00000390: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L042_00000394:
; H042+$00000394: 609e  bra.b $334
        bra.b H042+$334
L042_00000396:
; H042+$00000396: 4253  clr.w (a3)
        clr.w (a3)
L042_00000398:
; H042+$00000398: 45ec0027  lea.l $27(a4), a2
        lea.l $27(a4), a2
L042_0000039C:
; H042+$0000039C: 43f9000027a6  lea.l $27a6.l, a1
        lea.l (H005+$27A6).l, a1
L042_000003A2:
; H042+$000003A2: 7408  moveq #$8, d2
        moveq #8, d2
L042_000003A4:
; H042+$000003A4: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L042_000003A6:
; H042+$000003A6: 57cafffc  dbeq d2, $3a4
        dbeq d2, H042+$3A4
L042_000003AA:
; H042+$000003AA: 13fc00ff00002486  move.b #$ff, $2486.l
        move.b #$ff, (H005+$2486).l
L042_000003B2:
; H042+$000003B2: 4e5d  unlk a5
        unlk a5
L042_000003B4:
; H042+$000003B4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_000003B6:
; H042+$000003B6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_000003B8:
; H042+$000003B8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L042_000003BA:
; H042+$000003BA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H042_000003BC [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; richiama H016+$0014.
;   - Richiama H016+$0014.
; Chiamanti diretti: H042+$0D06, H042+$0A24
; --------------------------------------------------------------------------
L042_000003BC:
; H042+$000003BC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_000003BE:
; H042+$000003BE: 287afd82  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_000003C2:
; H042+$000003C2: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L042_000003C6:
; H042+$000003C6: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L042_000003CA:
; H042+$000003CA: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000003CC:
; H042+$000003CC: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000003CE:
; H042+$000003CE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L042_000003D2:
; H042+$000003D2: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000003D4:
; H042+$000003D4: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000003D6:
; H042+$000003D6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_000003DA:
; H042+$000003DA: 3413  move.w (a3), d2
        move.w (a3), d2
L042_000003DC:
; H042+$000003DC: e742  asl.w #$3, d2
        asl.w #$3, d2
L042_000003DE:
; H042+$000003DE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L042_000003E0:
; H042+$000003E0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_000003E4:
; H042+$000003E4: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L042_000003E8:
; H042+$000003E8: 1f3c0060  move.b #$60, -(a7)
        move.b #$60, -(a7)
L042_000003EC:
; H042+$000003EC: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L042_000003F0:
; H042+$000003F0: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L042_000003F2:
; H042+$000003F2: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L042_000003F8:
; H042+$000003F8: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L042_000003FC:
; H042+$000003FC: 4e5d  unlk a5
        unlk a5
L042_000003FE:
; H042+$000003FE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00000400:
; H042+$00000400: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_00000402:
; H042+$00000402: 508f  addq.l #$8, a7
        addq.l #$8, a7
L042_00000404:
; H042+$00000404: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Load_Sequence [parziale]
; Scopo: Carica una sequenza grafica indicizzata e la prepara per visualizzazione.
;   - Evita il ricaricamento quando nome e ID sono già quelli correnti.
;   - Apre il contenitore .daa e cerca la sequenza richiesta.
;   - Legge header e blocchi compressi; usa UnPackRow per ricostruire porzioni di dati.
;   - Prepara i record grafici e conserva i buffer dei frame successivi.
;   - Non sono ancora attribuiti tutti i campi dell’header della sequenza.
; Chiamanti diretti: H057+$31CE, H061+$1DE0, H061+$1EB4, H063+$32D6, H063+$3360, H064+$0BC8
; --------------------------------------------------------------------------
L042_00000406:
; H042+$00000406: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000408:
; H042+$00000408: 287afd38  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_0000040C:
; H042+$0000040C: 4e55ff22  link.w a5, #$ff22
        link.w a5, #$ff22
L042_00000410:
; H042+$00000410: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L042_00000414:
; H042+$00000414: 5242  addq.w #$1, d2
        addq.w #$1, d2
L042_00000416:
; H042+$00000416: 08020000  btst.b #$0, d2
        btst #$0, d2
L042_0000041A:
; H042+$0000041A: 6702  beq.b $41e
        beq.b H042+$41E
L042_0000041C:
; H042+$0000041C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L042_0000041E:
; H042+$0000041E: 9ec2  suba.w d2, a7
        suba.w d2, a7
L042_00000420:
; H042+$00000420: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L042_00000424:
; H042+$00000424: 2b4f0014  move.l a7, $14(a5)
        move.l a7, $14(a5)
L042_00000428:
; H042+$00000428: 244f  movea.l a7, a2
        movea.l a7, a2
L042_0000042A:
; H042+$0000042A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L042_0000042C:
; H042+$0000042C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L042_0000042E:
; H042+$0000042E: 51cafffc  dbra d2, $42c
        dbra d2, H042+$42C
L042_00000432:
; H042+$00000432: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000436:
; H042+$00000436: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000438:
; H042+$00000438: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L042_0000043C:
; H042+$0000043C: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L042_00000440:
; H042+$00000440: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L042_00000444:
; H042+$00000444: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L042_00000448:
; H042+$00000448: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L042_0000044E:
; H042+$0000044E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000450:
; H042+$00000450: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000452:
; H042+$00000452: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L042_00000456:
; H042+$00000456: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L042_0000045A:
; H042+$0000045A: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L042_0000045E:
; H042+$0000045E: 4879000027a6  pea.l $27a6.l
        pea.l (H005+$27A6).l
; -> H026+$0106 (sub_H026_00000106)
L042_00000464:
; H042+$00000464: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L042_0000046A:
; H042+$0000046A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000046C:
; H042+$0000046C: 1400  move.b d0, d2
        move.b d0, d2
L042_0000046E:
; H042+$0000046E: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L042_00000472:
; H042+$00000472: 66000014  bne.w $488
        bne.w H042+$488
L042_00000476:
; H042+$00000476: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000478:
; H042+$00000478: 143900002486  move.b $2486.l, d2
        move.b (H005+$2486).l, d2
L042_0000047E:
; H042+$0000047E: 382d0012  move.w $12(a5), d4
        move.w $12(a5), d4
L042_00000482:
; H042+$00000482: b842  cmp.w d2, d4
        cmp.w d2, d4
L042_00000484:
; H042+$00000484: 6700000c  beq.w $492
        beq.w H042+$492
L042_00000488:
; H042+$00000488: 0c6d00ff0012  cmpi.w #$ff, $12(a5)
        cmpi.w #$ff, $12(a5)
L042_0000048E:
; H042+$0000048E: 66000006  bne.w $496
        bne.w H042+$496
L042_00000492:
; H042+$00000492: 600006e0  bra.w $b74
        bra.w H042+$B74
L042_00000496:
; H042+$00000496: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000498:
; H042+$00000498: 7402  moveq #$2, d2
        moveq #2, d2
L042_0000049A:
; H042+$0000049A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L042_0000049C:
; H042+$0000049C: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L042_000004A2:
; H042+$000004A2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000004A4:
; H042+$000004A4: 2400  move.l d0, d2
        move.l d0, d2
L042_000004A6:
; H042+$000004A6: 0c8200000001  cmpi.l #$1, d2
        cmpi.l #$1, d2
L042_000004AC:
; H042+$000004AC: 57c2  seq.b d2
        seq.b d2
L042_000004AE:
; H042+$000004AE: 4402  neg.b d2
        neg.b d2
L042_000004B0:
; H042+$000004B0: 1942fffe  move.b d2, -$2(a4)
        move.b d2, -$2(a4)
L042_000004B4:
; H042+$000004B4: 4a39000024d4  tst.b $24d4.l
        tst.b (H005+$24D4).l
L042_000004BA:
; H042+$000004BA: 67000036  beq.w $4f2
        beq.w H042+$4F2
L042_000004BE:
; H042+$000004BE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000004C0:
; H042+$000004C0: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000004C2:
; H042+$000004C2: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L042_000004C6:
; H042+$000004C6: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000004C8:
; H042+$000004C8: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
; -> H030+$019A (sub_H030_0000019A)
L042_000004CC:
; H042+$000004CC: 4eb90000019a  jsr $19a.l
        jsr (H030+$19A).l
L042_000004D2:
; H042+$000004D2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000004D4:
; H042+$000004D4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000004D6:
; H042+$000004D6: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000004D8:
; H042+$000004D8: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L042_000004DC:
; H042+$000004DC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L042_000004E0:
; H042+$000004E0: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000004E2:
; H042+$000004E2: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
L042_000004E6:
; H042+$000004E6: 486c0029  pea.l $29(a4)
        pea.l $29(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L042_000004EA:
; H042+$000004EA: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L042_000004F0:
; H042+$000004F0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000004F2:
; H042+$000004F2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000004F4:
; H042+$000004F4: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L042_000004F8:
; H042+$000004F8: 4879000027a6  pea.l $27a6.l
        pea.l (H005+$27A6).l
L042_000004FE:
; H042+$000004FE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L042_00000502:
; H042+$00000502: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; -> H026+$0188 (sub_H026_00000188)
L042_00000506:
; H042+$00000506: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L042_0000050C:
; H042+$0000050C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000050E:
; H042+$0000050E: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L042_00000512:
; H042+$00000512: 13c200002486  move.b d2, $2486.l
        move.b d2, (H005+$2486).l
L042_00000518:
; H042+$00000518: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000051A:
; H042+$0000051A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L042_0000051E:
; H042+$0000051E: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L042_00000522:
; H042+$00000522: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L042_00000526:
; H042+$00000526: 486c003f  pea.l $3f(a4)
        pea.l $3f(a4)
; -> H026+$0106 (sub_H026_00000106)
L042_0000052A:
; H042+$0000052A: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L042_00000530:
; H042+$00000530: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000532:
; H042+$00000532: 1400  move.b d0, d2
        move.b d0, d2
L042_00000534:
; H042+$00000534: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L042_00000538:
; H042+$00000538: 67000026  beq.w $560
        beq.w H042+$560
L042_0000053C:
; H042+$0000053C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000053E:
; H042+$0000053E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L042_00000542:
; H042+$00000542: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L042_00000546:
; H042+$00000546: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L042_0000054A:
; H042+$0000054A: 486c0043  pea.l $43(a4)
        pea.l $43(a4)
; -> H026+$0106 (sub_H026_00000106)
L042_0000054E:
; H042+$0000054E: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L042_00000554:
; H042+$00000554: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000556:
; H042+$00000556: 1400  move.b d0, d2
        move.b d0, d2
L042_00000558:
; H042+$00000558: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L042_0000055C:
; H042+$0000055C: 66000006  bne.w $564
        bne.w H042+$564
L042_00000560:
; H042+$00000560: 7401  moveq #$1, d2
        moveq #1, d2
L042_00000562:
; H042+$00000562: 6002  bra.b $566
        bra.b H042+$566
L042_00000564:
; H042+$00000564: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000566:
; H042+$00000566: 1b42ffa1  move.b d2, -$5f(a5)
        move.b d2, -$5f(a5)
L042_0000056A:
; H042+$0000056A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000056C:
; H042+$0000056C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00000570:
; H042+$00000570: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
L042_00000574:
; H042+$00000574: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$246E = selettore del gruppo risorse
L042_00000576:
; H042+$00000576: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L042_0000057C:
; H042+$0000057C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_0000057E:
; H042+$0000057E: 4227  clr.b -(a7)
        clr.b -(a7)
L042_00000580:
; H042+$00000580: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L042_00000584:
; H042+$00000584: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00000588:
; H042+$00000588: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L042_0000058C:
; H042+$0000058C: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L042_00000592:
; H042+$00000592: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000594:
; H042+$00000594: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000596:
; H042+$00000596: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L042_0000059A:
; H042+$0000059A: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L042_0000059E:
; H042+$0000059E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_000005A2:
; H042+$000005A2: 486dff9e  pea.l -$62(a5)
        pea.l -$62(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L042_000005A6:
; H042+$000005A6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L042_000005AC:
; H042+$000005AC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000005AE:
; H042+$000005AE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000005B0:
; H042+$000005B0: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L042_000005B4:
; H042+$000005B4: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L042_000005B8:
; H042+$000005B8: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L042_000005BC:
; H042+$000005BC: 486c0049  pea.l $49(a4)
        pea.l $49(a4)
L042_000005C0:
; H042+$000005C0: 486dff8e  pea.l -$72(a5)
        pea.l -$72(a5)
L042_000005C4:
; H042+$000005C4: 486dff90  pea.l -$70(a5)
        pea.l -$70(a5)
; -> H028+$0B80 (sub_H028_00000B80)
L042_000005C8:
; H042+$000005C8: 4eb900000b80  jsr $b80.l
        jsr (H028+$B80).l
L042_000005CE:
; H042+$000005CE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000005D0:
; H042+$000005D0: 1400  move.b d0, d2
        move.b d0, d2
L042_000005D2:
; H042+$000005D2: 4a02  tst.b d2
        tst.b d2
L042_000005D4:
; H042+$000005D4: 66000018  bne.w $5ee
        bne.w H042+$5EE
L042_000005D8:
; H042+$000005D8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000005DA:
; H042+$000005DA: 3f3c002d  move.w #$2d, -(a7)
        move.w #$2d, -(a7)
L042_000005DE:
; H042+$000005DE: 486c004e  pea.l $4e(a4)
        pea.l $4e(a4)
; -> H020+$085A (sub_H020_0000085A)
L042_000005E2:
; H042+$000005E2: 4eb90000085a  jsr $85a.l
        jsr (H020+$85A).l
L042_000005E8:
; H042+$000005E8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000005EA:
; H042+$000005EA: 60000588  bra.w $b74
        bra.w H042+$B74
L042_000005EE:
; H042+$000005EE: 426dff8c  clr.w -$74(a5)
        clr.w -$74(a5)
L042_000005F2:
; H042+$000005F2: 526dff8c  addq.w #$1, -$74(a5)
        addq.w #$1, -$74(a5)
L042_000005F6:
; H042+$000005F6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000005F8:
; H042+$000005F8: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_000005FC:
; H042+$000005FC: 45edff98  lea.l -$68(a5), a2
        lea.l -$68(a5), a2
L042_00000600:
; H042+$00000600: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_00000602:
; H042+$00000602: 7406  moveq #$6, d2
        moveq #6, d2
L042_00000604:
; H042+$00000604: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_00000606:
; H042+$00000606: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_0000060C:
; H042+$0000060C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000060E:
; H042+$0000060E: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_00000612:
; H042+$00000612: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000614:
; H042+$00000614: 142dff98  move.b -$68(a5), d2
        move.b -$68(a5), d2
L042_00000618:
; H042+$00000618: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L042_0000061C:
; H042+$0000061C: 67000022  beq.w $640
        beq.w H042+$640
L042_00000620:
; H042+$00000620: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000622:
; H042+$00000622: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_00000626:
; H042+$00000626: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000628:
; H042+$00000628: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_0000062A:
; H042+$0000062A: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H002+$0156 (wrapper_Seek)
L042_0000062C:
; H042+$0000062C: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L042_00000632:
; H042+$00000632: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000634:
; H042+$00000634: 2400  move.l d0, d2
        move.l d0, d2
L042_00000636:
; H042+$00000636: 7800  moveq #$0, d4
        moveq #0, d4
L042_00000638:
; H042+$00000638: 382dff8e  move.w -$72(a5), d4
        move.w -$72(a5), d4
L042_0000063C:
; H042+$0000063C: b484  cmp.l d4, d2
        cmp.l d4, d2
L042_0000063E:
; H042+$0000063E: 6db2  blt.b $5f2
        blt.b H042+$5F2
L042_00000640:
; H042+$00000640: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000642:
; H042+$00000642: 142dff98  move.b -$68(a5), d2
        move.b -$68(a5), d2
L042_00000646:
; H042+$00000646: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L042_0000064A:
; H042+$0000064A: 67000014  beq.w $660
        beq.w H042+$660
L042_0000064E:
; H042+$0000064E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000650:
; H042+$00000650: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L042_00000654:
; H042+$00000654: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L042_0000065A:
; H042+$0000065A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000065C:
; H042+$0000065C: 60000516  bra.w $b74
        bra.w H042+$B74
L042_00000660:
; H042+$00000660: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000662:
; H042+$00000662: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; FLUSSO: Chiama Free_Sequence (H042+$0300).
L042_00000666:
; H042+$00000666: 6100fc98  bsr.w $300
        bsr.w H042+$300
L042_0000066A:
; H042+$0000066A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000066C:
; H042+$0000066C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000066E:
; H042+$0000066E: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L042_00000672:
; H042+$00000672: 4879000027a6  pea.l $27a6.l
        pea.l (H005+$27A6).l
L042_00000678:
; H042+$00000678: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L042_0000067C:
; H042+$0000067C: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L042_00000680:
; H042+$00000680: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L042_00000686:
; H042+$00000686: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000688:
; H042+$00000688: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L042_0000068C:
; H042+$0000068C: 13c200002486  move.b d2, $2486.l
        move.b d2, (H005+$2486).l
L042_00000692:
; H042+$00000692: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000694:
; H042+$00000694: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_00000698:
; H042+$00000698: 7400  moveq #$0, d2
        moveq #0, d2
L042_0000069A:
; H042+$0000069A: 342dff8e  move.w -$72(a5), d2
        move.w -$72(a5), d2
L042_0000069E:
; H042+$0000069E: d4adff9a  add.l -$66(a5), d2
        add.l -$66(a5), d2
L042_000006A2:
; H042+$000006A2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_000006A4:
; H042+$000006A4: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H002+$0156 (wrapper_Seek)
L042_000006AA:
; H042+$000006AA: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L042_000006B0:
; H042+$000006B0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000006B2:
; H042+$000006B2: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_000006B6:
; H042+$000006B6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000006B8:
; H042+$000006B8: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_000006BC:
; H042+$000006BC: 45edff34  lea.l -$cc(a5), a2
        lea.l -$cc(a5), a2
L042_000006C0:
; H042+$000006C0: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_000006C2:
; H042+$000006C2: 7402  moveq #$2, d2
        moveq #2, d2
L042_000006C4:
; H042+$000006C4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_000006C6:
; H042+$000006C6: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_000006CC:
; H042+$000006CC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000006CE:
; H042+$000006CE: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_000006D2:
; H042+$000006D2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000006D4:
; H042+$000006D4: 7400  moveq #$0, d2
        moveq #0, d2
L042_000006D6:
; H042+$000006D6: 342dff34  move.w -$cc(a5), d2
        move.w -$cc(a5), d2
L042_000006DA:
; H042+$000006DA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_000006DC:
; H042+$000006DC: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L042_000006DE:
; H042+$000006DE: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L042_000006E4:
; H042+$000006E4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000006E6:
; H042+$000006E6: 2b40ffa6  move.l d0, -$5a(a5)
        move.l d0, -$5a(a5)
L042_000006EA:
; H042+$000006EA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000006EC:
; H042+$000006EC: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_000006F0:
; H042+$000006F0: 2f2dffa6  move.l -$5a(a5), -(a7)
        move.l -$5a(a5), -(a7)
L042_000006F4:
; H042+$000006F4: 7400  moveq #$0, d2
        moveq #0, d2
L042_000006F6:
; H042+$000006F6: 342dff34  move.w -$cc(a5), d2
        move.w -$cc(a5), d2
L042_000006FA:
; H042+$000006FA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_000006FC:
; H042+$000006FC: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_00000702:
; H042+$00000702: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000704:
; H042+$00000704: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_00000708:
; H042+$00000708: 2b6dffa6ff2a  move.l -$5a(a5), -$d6(a5)
        move.l -$5a(a5), -$d6(a5)
L042_0000070E:
; H042+$0000070E: 45edff36  lea.l -$ca(a5), a2
        lea.l -$ca(a5), a2
L042_00000712:
; H042+$00000712: 2b4aff26  move.l a2, -$da(a5)
        move.l a2, -$da(a5)
L042_00000716:
; H042+$00000716: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000718:
; H042+$00000718: 486dff2a  pea.l -$d6(a5)
        pea.l -$d6(a5)
L042_0000071C:
; H042+$0000071C: 486dff26  pea.l -$da(a5)
        pea.l -$da(a5)
L042_00000720:
; H042+$00000720: 3f2dff34  move.w -$cc(a5), -(a7)
        move.w -$cc(a5), -(a7)
L042_00000724:
; H042+$00000724: 3f3c0056  move.w #$56, -(a7)
        move.w #$56, -(a7)
; FLUSSO: Chiama UnPackRow_ByteRun1 (H088+$000C).
L042_00000728:
; H042+$00000728: 4eb90000000c  jsr $c.l
        jsr (H088+$C).l
L042_0000072E:
; H042+$0000072E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000730:
; H042+$00000730: 1400  move.b d0, d2
        move.b d0, d2
L042_00000732:
; H042+$00000732: 4a02  tst.b d2
        tst.b d2
L042_00000734:
; H042+$00000734: 67000014  beq.w $74a
        beq.w H042+$74A
L042_00000738:
; H042+$00000738: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000073A:
; H042+$0000073A: 3f3c0025  move.w #$25, -(a7)
        move.w #$25, -(a7)
L042_0000073E:
; H042+$0000073E: 486c007c  pea.l $7c(a4)
        pea.l $7c(a4)
; -> H020+$085A (sub_H020_0000085A)
L042_00000742:
; H042+$00000742: 4eb90000085a  jsr $85a.l
        jsr (H020+$85A).l
L042_00000748:
; H042+$00000748: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000074A:
; H042+$0000074A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000074C:
; H042+$0000074C: 2f2dffa6  move.l -$5a(a5), -(a7)
        move.l -$5a(a5), -(a7)
L042_00000750:
; H042+$00000750: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000752:
; H042+$00000752: 342dff34  move.w -$cc(a5), d2
        move.w -$cc(a5), d2
L042_00000756:
; H042+$00000756: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L042_00000758:
; H042+$00000758: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L042_0000075E:
; H042+$0000075E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000760:
; H042+$00000760: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000762:
; H042+$00000762: 45edff40  lea.l -$c0(a5), a2
        lea.l -$c0(a5), a2
L042_00000766:
; H042+$00000766: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_00000768:
; H042+$00000768: 45f9000052ae  lea.l $52ae.l, a2
        lea.l (H005+$52AE).l, a2
L042_0000076E:
; H042+$0000076E: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_00000770:
; H042+$00000770: 7440  moveq #$40, d2
        moveq #64, d2
L042_00000772:
; H042+$00000772: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L042_00000774:
; H042+$00000774: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L042_0000077A:
; H042+$0000077A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000077C:
; H042+$0000077C: 4279000052ae  clr.w $52ae.l
        clr.w (H005+$52AE).l
L042_00000782:
; H042+$00000782: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000784:
; H042+$00000784: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000786:
; H042+$00000786: 342dff80  move.w -$80(a5), d2
        move.w -$80(a5), d2
L042_0000078A:
; H042+$0000078A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_0000078C:
; H042+$0000078C: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L042_0000078E:
; H042+$0000078E: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L042_00000794:
; H042+$00000794: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000796:
; H042+$00000796: 2b40ffa6  move.l d0, -$5a(a5)
        move.l d0, -$5a(a5)
L042_0000079A:
; H042+$0000079A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000079C:
; H042+$0000079C: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_000007A0:
; H042+$000007A0: 2f2dffa6  move.l -$5a(a5), -(a7)
        move.l -$5a(a5), -(a7)
L042_000007A4:
; H042+$000007A4: 7400  moveq #$0, d2
        moveq #0, d2
L042_000007A6:
; H042+$000007A6: 342dff80  move.w -$80(a5), d2
        move.w -$80(a5), d2
L042_000007AA:
; H042+$000007AA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_000007AC:
; H042+$000007AC: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_000007B2:
; H042+$000007B2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000007B4:
; H042+$000007B4: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_000007B8:
; H042+$000007B8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000007BA:
; H042+$000007BA: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_000007BE:
; H042+$000007BE: 45eb000e  lea.l $e(a3), a2
        lea.l $e(a3), a2
L042_000007C2:
; H042+$000007C2: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_000007C4:
; H042+$000007C4: 7402  moveq #$2, d2
        moveq #2, d2
L042_000007C6:
; H042+$000007C6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_000007C8:
; H042+$000007C8: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_000007CE:
; H042+$000007CE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000007D0:
; H042+$000007D0: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_000007D4:
; H042+$000007D4: 42ab000a  clr.l $a(a3)
        clr.l $a(a3)
L042_000007D8:
; H042+$000007D8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000007DA:
; H042+$000007DA: 3f2dff36  move.w -$ca(a5), -(a7)
        move.w -$ca(a5), -(a7)
L042_000007DE:
; H042+$000007DE: 3f2dff38  move.w -$c8(a5), -(a7)
        move.w -$c8(a5), -(a7)
L042_000007E2:
; H042+$000007E2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_000007E6:
; H042+$000007E6: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L042_000007EA:
; H042+$000007EA: 486b0006  pea.l $6(a3)
        pea.l $6(a3)
; FLUSSO: Chiama Allocate_GraphicRecord (H029+$0408).
L042_000007EE:
; H042+$000007EE: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L042_000007F4:
; H042+$000007F4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000007F6:
; H042+$000007F6: 246b0006  movea.l $6(a3), a2
        movea.l $6(a3), a2
L042_000007FA:
; H042+$000007FA: 356dff3a0004  move.w -$c6(a5), $4(a2)
        move.w -$c6(a5), $4(a2)
L042_00000800:
; H042+$00000800: 356dff3c0006  move.w -$c4(a5), $6(a2)
        move.w -$c4(a5), $6(a2)
L042_00000806:
; H042+$00000806: 246b0006  movea.l $6(a3), a2
        movea.l $6(a3), a2
L042_0000080A:
; H042+$0000080A: 3b6a000affa2  move.w $a(a2), -$5e(a5)
        move.w $a(a2), -$5e(a5)
L042_00000810:
; H042+$00000810: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000812:
; H042+$00000812: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000814:
; H042+$00000814: 342dffa2  move.w -$5e(a5), d2
        move.w -$5e(a5), d2
L042_00000818:
; H042+$00000818: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_0000081A:
; H042+$0000081A: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L042_0000081C:
; H042+$0000081C: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L042_00000822:
; H042+$00000822: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000824:
; H042+$00000824: 2b40ffaa  move.l d0, -$56(a5)
        move.l d0, -$56(a5)
L042_00000828:
; H042+$00000828: 2b6dffa6ff2a  move.l -$5a(a5), -$d6(a5)
        move.l -$5a(a5), -$d6(a5)
L042_0000082E:
; H042+$0000082E: 2b6dffaaff26  move.l -$56(a5), -$da(a5)
        move.l -$56(a5), -$da(a5)
L042_00000834:
; H042+$00000834: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000836:
; H042+$00000836: 486dff2a  pea.l -$d6(a5)
        pea.l -$d6(a5)
L042_0000083A:
; H042+$0000083A: 486dff26  pea.l -$da(a5)
        pea.l -$da(a5)
L042_0000083E:
; H042+$0000083E: 3f2dff80  move.w -$80(a5), -(a7)
        move.w -$80(a5), -(a7)
L042_00000842:
; H042+$00000842: 3f2dffa2  move.w -$5e(a5), -(a7)
        move.w -$5e(a5), -(a7)
; FLUSSO: Chiama UnPackRow_ByteRun1 (H088+$000C).
L042_00000846:
; H042+$00000846: 4eb90000000c  jsr $c.l
        jsr (H088+$C).l
L042_0000084C:
; H042+$0000084C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000084E:
; H042+$0000084E: 1400  move.b d0, d2
        move.b d0, d2
L042_00000850:
; H042+$00000850: 4a02  tst.b d2
        tst.b d2
L042_00000852:
; H042+$00000852: 67000014  beq.w $868
        beq.w H042+$868
L042_00000856:
; H042+$00000856: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000858:
; H042+$00000858: 3f3c0029  move.w #$29, -(a7)
        move.w #$29, -(a7)
L042_0000085C:
; H042+$0000085C: 486c00a2  pea.l $a2(a4)
        pea.l $a2(a4)
; -> H020+$085A (sub_H020_0000085A)
L042_00000860:
; H042+$00000860: 4eb90000085a  jsr $85a.l
        jsr (H020+$85A).l
L042_00000866:
; H042+$00000866: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000868:
; H042+$00000868: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000086A:
; H042+$0000086A: 2f2dffa6  move.l -$5a(a5), -(a7)
        move.l -$5a(a5), -(a7)
L042_0000086E:
; H042+$0000086E: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000870:
; H042+$00000870: 342dff80  move.w -$80(a5), d2
        move.w -$80(a5), d2
L042_00000874:
; H042+$00000874: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L042_00000876:
; H042+$00000876: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L042_0000087C:
; H042+$0000087C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000087E:
; H042+$0000087E: 4a2dffa1  tst.b -$5f(a5)
        tst.b -$5f(a5)
L042_00000882:
; H042+$00000882: 6700000a  beq.w $88e
        beq.w H042+$88E
L042_00000886:
; H042+$00000886: 426dff30  clr.w -$d0(a5)
        clr.w -$d0(a5)
L042_0000088A:
; H042+$0000088A: 60000008  bra.w $894
        bra.w H042+$894
L042_0000088E:
; H042+$0000088E: 3b7c000dff30  move.w #$d, -$d0(a5)
        move.w #$d, -$d0(a5)
L042_00000894:
; H042+$00000894: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000896:
; H042+$00000896: 2f2dffaa  move.l -$56(a5), -(a7)
        move.l -$56(a5), -(a7)
L042_0000089A:
; H042+$0000089A: 4267  clr.w -(a7)
        clr.w -(a7)
L042_0000089C:
; H042+$0000089C: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L042_000008A0:
; H042+$000008A0: 342dff30  move.w -$d0(a5), d2
        move.w -$d0(a5), d2
L042_000008A4:
; H042+$000008A4: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L042_000008A6:
; H042+$000008A6: 486b0006  pea.l $6(a3)
        pea.l $6(a3)
; FLUSSO: Chiama Populate_GraphicPlanes (H029+$091E).
L042_000008AA:
; H042+$000008AA: 4eb90000091e  jsr $91e.l
        jsr (H029+$91E).l
L042_000008B0:
; H042+$000008B0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000008B2:
; H042+$000008B2: 196cfffeffff  move.b -$2(a4), -$1(a4)
        move.b -$2(a4), -$1(a4)
L042_000008B8:
; H042+$000008B8: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L042_000008BC:
; H042+$000008BC: 6700000e  beq.w $8cc
        beq.w H042+$8CC
L042_000008C0:
; H042+$000008C0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000008C2:
; H042+$000008C2: 486b0006  pea.l $6(a3)
        pea.l $6(a3)
L042_000008C6:
; H042+$000008C6: 6100f8e6  bsr.w $1ae
        bsr.w H042+$1AE
L042_000008CA:
; H042+$000008CA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000008CC:
; H042+$000008CC: 4a39000024d4  tst.b $24d4.l
        tst.b (H005+$24D4).l
L042_000008D2:
; H042+$000008D2: 66000010  bne.w $8e4
        bne.w H042+$8E4
L042_000008D6:
; H042+$000008D6: 4a2dffa1  tst.b -$5f(a5)
        tst.b -$5f(a5)
L042_000008DA:
; H042+$000008DA: 67000008  beq.w $8e4
        beq.w H042+$8E4
L042_000008DE:
; H042+$000008DE: 3b7c0001ff3e  move.w #$1, -$c2(a5)
        move.w #$1, -$c2(a5)
L042_000008E4:
; H042+$000008E4: 36adff3e  move.w -$c2(a5), (a3)
        move.w -$c2(a5), (a3)
L042_000008E8:
; H042+$000008E8: 377c00010002  move.w #$1, $2(a3)
        move.w #$1, $2(a3)
L042_000008EE:
; H042+$000008EE: 426b0004  clr.w $4(a3)
        clr.w $4(a3)
L042_000008F2:
; H042+$000008F2: 0c6d0002ff3e  cmpi.w #$2, -$c2(a5)
        cmpi.w #$2, -$c2(a5)
L042_000008F8:
; H042+$000008F8: 6500022e  bcs.w $b28
        bcs.w H042+$B28
L042_000008FC:
; H042+$000008FC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000008FE:
; H042+$000008FE: 3f2dff36  move.w -$ca(a5), -(a7)
        move.w -$ca(a5), -(a7)
L042_00000902:
; H042+$00000902: 3f2dff38  move.w -$c8(a5), -(a7)
        move.w -$c8(a5), -(a7)
L042_00000906:
; H042+$00000906: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_0000090A:
; H042+$0000090A: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L042_0000090E:
; H042+$0000090E: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
; FLUSSO: Chiama Allocate_GraphicRecord (H029+$0408).
L042_00000912:
; H042+$00000912: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L042_00000918:
; H042+$00000918: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_0000091A:
; H042+$0000091A: 246b000a  movea.l $a(a3), a2
        movea.l $a(a3), a2
L042_0000091E:
; H042+$0000091E: 356dff3a0004  move.w -$c6(a5), $4(a2)
        move.w -$c6(a5), $4(a2)
L042_00000924:
; H042+$00000924: 356dff3c0006  move.w -$c4(a5), $6(a2)
        move.w -$c4(a5), $6(a2)
L042_0000092A:
; H042+$0000092A: 0c6d0002ff3e  cmpi.w #$2, -$c2(a5)
        cmpi.w #$2, -$c2(a5)
L042_00000930:
; H042+$00000930: 66000128  bne.w $a5a
        bne.w H042+$A5A
L042_00000934:
; H042+$00000934: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000936:
; H042+$00000936: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000938:
; H042+$00000938: 342dff82  move.w -$7e(a5), d2
        move.w -$7e(a5), d2
L042_0000093C:
; H042+$0000093C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_0000093E:
; H042+$0000093E: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L042_00000940:
; H042+$00000940: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L042_00000946:
; H042+$00000946: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000948:
; H042+$00000948: 2b40ffa6  move.l d0, -$5a(a5)
        move.l d0, -$5a(a5)
L042_0000094C:
; H042+$0000094C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000094E:
; H042+$0000094E: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_00000952:
; H042+$00000952: 2f2dffa6  move.l -$5a(a5), -(a7)
        move.l -$5a(a5), -(a7)
L042_00000956:
; H042+$00000956: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000958:
; H042+$00000958: 342dff82  move.w -$7e(a5), d2
        move.w -$7e(a5), d2
L042_0000095C:
; H042+$0000095C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_0000095E:
; H042+$0000095E: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_00000964:
; H042+$00000964: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000966:
; H042+$00000966: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_0000096A:
; H042+$0000096A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000096C:
; H042+$0000096C: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_00000970:
; H042+$00000970: 45eb0010  lea.l $10(a3), a2
        lea.l $10(a3), a2
L042_00000974:
; H042+$00000974: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_00000976:
; H042+$00000976: 7402  moveq #$2, d2
        moveq #2, d2
L042_00000978:
; H042+$00000978: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_0000097A:
; H042+$0000097A: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_00000980:
; H042+$00000980: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000982:
; H042+$00000982: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_00000986:
; H042+$00000986: 2b6dffa6ff2a  move.l -$5a(a5), -$d6(a5)
        move.l -$5a(a5), -$d6(a5)
L042_0000098C:
; H042+$0000098C: 2b6dffaaff26  move.l -$56(a5), -$da(a5)
        move.l -$56(a5), -$da(a5)
L042_00000992:
; H042+$00000992: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000994:
; H042+$00000994: 486dff2a  pea.l -$d6(a5)
        pea.l -$d6(a5)
L042_00000998:
; H042+$00000998: 486dff26  pea.l -$da(a5)
        pea.l -$da(a5)
L042_0000099C:
; H042+$0000099C: 3f2dff82  move.w -$7e(a5), -(a7)
        move.w -$7e(a5), -(a7)
L042_000009A0:
; H042+$000009A0: 3f2dffa2  move.w -$5e(a5), -(a7)
        move.w -$5e(a5), -(a7)
; FLUSSO: Chiama UnPackRow_ByteRun1 (H088+$000C).
L042_000009A4:
; H042+$000009A4: 4eb90000000c  jsr $c.l
        jsr (H088+$C).l
L042_000009AA:
; H042+$000009AA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000009AC:
; H042+$000009AC: 1400  move.b d0, d2
        move.b d0, d2
L042_000009AE:
; H042+$000009AE: 4a02  tst.b d2
        tst.b d2
L042_000009B0:
; H042+$000009B0: 67000002  beq.w $9b4
        beq.w H042+$9B4
L042_000009B4:
; H042+$000009B4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000009B6:
; H042+$000009B6: 2f2dffa6  move.l -$5a(a5), -(a7)
        move.l -$5a(a5), -(a7)
L042_000009BA:
; H042+$000009BA: 7400  moveq #$0, d2
        moveq #0, d2
L042_000009BC:
; H042+$000009BC: 342dff82  move.w -$7e(a5), d2
        move.w -$7e(a5), d2
L042_000009C0:
; H042+$000009C0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L042_000009C2:
; H042+$000009C2: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L042_000009C8:
; H042+$000009C8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000009CA:
; H042+$000009CA: 246b000a  movea.l $a(a3), a2
        movea.l $a(a3), a2
L042_000009CE:
; H042+$000009CE: 2b6a000cff22  move.l $c(a2), -$de(a5)
        move.l $c(a2), -$de(a5)
L042_000009D4:
; H042+$000009D4: 246b000a  movea.l $a(a3), a2
        movea.l $a(a3), a2
L042_000009D8:
; H042+$000009D8: 42aa000c  clr.l $c(a2)
        clr.l $c(a2)
L042_000009DC:
; H042+$000009DC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_000009DE:
; H042+$000009DE: 2f2dffaa  move.l -$56(a5), -(a7)
        move.l -$56(a5), -(a7)
L042_000009E2:
; H042+$000009E2: 4267  clr.w -(a7)
        clr.w -(a7)
L042_000009E4:
; H042+$000009E4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L042_000009E8:
; H042+$000009E8: 342dff30  move.w -$d0(a5), d2
        move.w -$d0(a5), d2
L042_000009EC:
; H042+$000009EC: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L042_000009EE:
; H042+$000009EE: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
; FLUSSO: Chiama Populate_GraphicPlanes (H029+$091E).
L042_000009F2:
; H042+$000009F2: 4eb90000091e  jsr $91e.l
        jsr (H029+$91E).l
L042_000009F8:
; H042+$000009F8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_000009FA:
; H042+$000009FA: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L042_000009FE:
; H042+$000009FE: 6700000e  beq.w $a0e
        beq.w H042+$A0E
L042_00000A02:
; H042+$00000A02: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000A04:
; H042+$00000A04: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
L042_00000A08:
; H042+$00000A08: 6100f7a4  bsr.w $1ae
        bsr.w H042+$1AE
L042_00000A0C:
; H042+$00000A0C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000A0E:
; H042+$00000A0E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000A10:
; H042+$00000A10: 226b0006  movea.l $6(a3), a1
        movea.l $6(a3), a1
L042_00000A14:
; H042+$00000A14: 24690010  movea.l $10(a1), a2
        movea.l $10(a1), a2
L042_00000A18:
; H042+$00000A18: 4852  pea.l (a2)
        pea.l (a2)
L042_00000A1A:
; H042+$00000A1A: 226b000a  movea.l $a(a3), a1
        movea.l $a(a3), a1
L042_00000A1E:
; H042+$00000A1E: 24690010  movea.l $10(a1), a2
        movea.l $10(a1), a2
L042_00000A22:
; H042+$00000A22: 4852  pea.l (a2)
        pea.l (a2)
L042_00000A24:
; H042+$00000A24: 6100f996  bsr.w $3bc
        bsr.w H042+$3BC
L042_00000A28:
; H042+$00000A28: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000A2A:
; H042+$00000A2A: 4aadff22  tst.l -$de(a5)
        tst.l -$de(a5)
L042_00000A2E:
; H042+$00000A2E: 67000020  beq.w $a50
        beq.w H042+$A50
L042_00000A32:
; H042+$00000A32: 246b000a  movea.l $a(a3), a2
        movea.l $a(a3), a2
L042_00000A36:
; H042+$00000A36: 256dff22000c  move.l -$de(a5), $c(a2)
        move.l -$de(a5), $c(a2)
L042_00000A3C:
; H042+$00000A3C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000A3E:
; H042+$00000A3E: 2f2b000a  move.l $a(a3), -(a7)
        move.l $a(a3), -(a7)
L042_00000A42:
; H042+$00000A42: 342dff30  move.w -$d0(a5), d2
        move.w -$d0(a5), d2
L042_00000A46:
; H042+$00000A46: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
; -> H029+$0766 (sub_H029_00000766)
L042_00000A48:
; H042+$00000A48: 4eb900000766  jsr $766.l
        jsr (H029+$766).l
L042_00000A4E:
; H042+$00000A4E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000A50:
; H042+$00000A50: 377c00020004  move.w #$2, $4(a3)
        move.w #$2, $4(a3)
L042_00000A56:
; H042+$00000A56: 600000d0  bra.w $b28
        bra.w H042+$B28
L042_00000A5A:
; H042+$00000A5A: 3b7c0002ffa4  move.w #$2, -$5c(a5)
        move.w #$2, -$5c(a5)
L042_00000A60:
; H042+$00000A60: 3f2dff3e  move.w -$c2(a5), -(a7)
        move.w -$c2(a5), -(a7)
L042_00000A64:
; H042+$00000A64: 342dffa4  move.w -$5c(a5), d2
        move.w -$5c(a5), d2
L042_00000A68:
; H042+$00000A68: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L042_00000A6A:
; H042+$00000A6A: 620000ba  bhi.w $b26
        bhi.w H042+$B26
L042_00000A6E:
; H042+$00000A6E: 342dffa4  move.w -$5c(a5), d2
        move.w -$5c(a5), d2
L042_00000A72:
; H042+$00000A72: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_00000A74:
; H042+$00000A74: e542  asl.w #$2, d2
        asl.w #$2, d2
L042_00000A76:
; H042+$00000A76: 45eb002c  lea.l $2c(a3), a2
        lea.l $2c(a3), a2
L042_00000A7A:
; H042+$00000A7A: 48e72030  movem.l d2/a2-a3, -(a7)
        movem.l d2/a2-a3, -(a7)
L042_00000A7E:
; H042+$00000A7E: 382dffa4  move.w -$5c(a5), d4
        move.w -$5c(a5), d4
L042_00000A82:
; H042+$00000A82: 5344  subq.w #$1, d4
        subq.w #$1, d4
L042_00000A84:
; H042+$00000A84: e344  asl.w #$1, d4
        asl.w #$1, d4
L042_00000A86:
; H042+$00000A86: 43edff80  lea.l -$80(a5), a1
        lea.l -$80(a5), a1
L042_00000A8A:
; H042+$00000A8A: 7c00  moveq #$0, d6
        moveq #0, d6
L042_00000A8C:
; H042+$00000A8C: 3c314000  move.w (a1, d4.w), d6
        move.w (a1, d4.w), d6
L042_00000A90:
; H042+$00000A90: 2f06  move.l d6, -(a7)
        move.l d6, -(a7)
L042_00000A92:
; H042+$00000A92: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L042_00000A94:
; H042+$00000A94: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L042_00000A9A:
; H042+$00000A9A: 4cdf0c04  movem.l (a7)+, d2/a2-a3
        movem.l (a7)+, d2/a2-a3
L042_00000A9E:
; H042+$00000A9E: 25802000  move.l d0, (a2, d2.w)
        move.l d0, (a2, d2.w)
L042_00000AA2:
; H042+$00000AA2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000AA4:
; H042+$00000AA4: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_00000AA8:
; H042+$00000AA8: 342dffa4  move.w -$5c(a5), d2
        move.w -$5c(a5), d2
L042_00000AAC:
; H042+$00000AAC: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_00000AAE:
; H042+$00000AAE: e542  asl.w #$2, d2
        asl.w #$2, d2
L042_00000AB0:
; H042+$00000AB0: 45eb002c  lea.l $2c(a3), a2
        lea.l $2c(a3), a2
L042_00000AB4:
; H042+$00000AB4: 2f322000  move.l (a2, d2.w), -(a7)
        move.l (a2, d2.w), -(a7)
L042_00000AB8:
; H042+$00000AB8: 342dffa4  move.w -$5c(a5), d2
        move.w -$5c(a5), d2
L042_00000ABC:
; H042+$00000ABC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L042_00000ABE:
; H042+$00000ABE: e342  asl.w #$1, d2
        asl.w #$1, d2
L042_00000AC0:
; H042+$00000AC0: 45edff80  lea.l -$80(a5), a2
        lea.l -$80(a5), a2
L042_00000AC4:
; H042+$00000AC4: 7800  moveq #$0, d4
        moveq #0, d4
L042_00000AC6:
; H042+$00000AC6: 38322000  move.w (a2, d2.w), d4
        move.w (a2, d2.w), d4
L042_00000ACA:
; H042+$00000ACA: 2f04  move.l d4, -(a7)
        move.l d4, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_00000ACC:
; H042+$00000ACC: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_00000AD2:
; H042+$00000AD2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000AD4:
; H042+$00000AD4: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_00000AD8:
; H042+$00000AD8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000ADA:
; H042+$00000ADA: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
L042_00000ADE:
; H042+$00000ADE: 342dffa4  move.w -$5c(a5), d2
        move.w -$5c(a5), d2
L042_00000AE2:
; H042+$00000AE2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L042_00000AE4:
; H042+$00000AE4: e342  asl.w #$1, d2
        asl.w #$1, d2
L042_00000AE6:
; H042+$00000AE6: 45eb000e  lea.l $e(a3), a2
        lea.l $e(a3), a2
L042_00000AEA:
; H042+$00000AEA: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L042_00000AEE:
; H042+$00000AEE: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_00000AF0:
; H042+$00000AF0: 7402  moveq #$2, d2
        moveq #2, d2
L042_00000AF2:
; H042+$00000AF2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$0122 (wrapper_Read)
L042_00000AF4:
; H042+$00000AF4: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L042_00000AFA:
; H042+$00000AFA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000AFC:
; H042+$00000AFC: 2b40ff94  move.l d0, -$6c(a5)
        move.l d0, -$6c(a5)
L042_00000B00:
; H042+$00000B00: 342dffa4  move.w -$5c(a5), d2
        move.w -$5c(a5), d2
L042_00000B04:
; H042+$00000B04: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_00000B06:
; H042+$00000B06: e342  asl.w #$1, d2
        asl.w #$1, d2
L042_00000B08:
; H042+$00000B08: 45eb001e  lea.l $1e(a3), a2
        lea.l $1e(a3), a2
L042_00000B0C:
; H042+$00000B0C: 382dffa4  move.w -$5c(a5), d4
        move.w -$5c(a5), d4
L042_00000B10:
; H042+$00000B10: 5344  subq.w #$1, d4
        subq.w #$1, d4
L042_00000B12:
; H042+$00000B12: e344  asl.w #$1, d4
        asl.w #$1, d4
L042_00000B14:
; H042+$00000B14: 43edff80  lea.l -$80(a5), a1
        lea.l -$80(a5), a1
L042_00000B18:
; H042+$00000B18: 35b140002000  move.w (a1, d4.w), (a2, d2.w)
        move.w (a1, d4.w), (a2, d2.w)
L042_00000B1E:
; H042+$00000B1E: 526dffa4  addq.w #$1, -$5c(a5)
        addq.w #$1, -$5c(a5)
L042_00000B22:
; H042+$00000B22: 6400ff40  bcc.w $a64
        bcc.w H042+$A64
L042_00000B26:
; H042+$00000B26: 548f  addq.l #$2, a7
        addq.l #$2, a7
L042_00000B28:
; H042+$00000B28: 4aadffaa  tst.l -$56(a5)
        tst.l -$56(a5)
L042_00000B2C:
; H042+$00000B2C: 67000018  beq.w $b46
        beq.w H042+$B46
L042_00000B30:
; H042+$00000B30: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000B32:
; H042+$00000B32: 2f2dffaa  move.l -$56(a5), -(a7)
        move.l -$56(a5), -(a7)
L042_00000B36:
; H042+$00000B36: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000B38:
; H042+$00000B38: 342dffa2  move.w -$5e(a5), d2
        move.w -$5e(a5), d2
L042_00000B3C:
; H042+$00000B3C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L042_00000B3E:
; H042+$00000B3E: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L042_00000B44:
; H042+$00000B44: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000B46:
; H042+$00000B46: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000B48:
; H042+$00000B48: 2f2dff90  move.l -$70(a5), -(a7)
        move.l -$70(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L042_00000B4C:
; H042+$00000B4C: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L042_00000B52:
; H042+$00000B52: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000B54:
; H042+$00000B54: 4a39000024d4  tst.b $24d4.l
        tst.b (H005+$24D4).l
L042_00000B5A:
; H042+$00000B5A: 67000018  beq.w $b74
        beq.w H042+$B74
L042_00000B5E:
; H042+$00000B5E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000B60:
; H042+$00000B60: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000B62:
; H042+$00000B62: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L042_00000B66:
; H042+$00000B66: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000B68:
; H042+$00000B68: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
; -> H030+$019A (sub_H030_0000019A)
L042_00000B6C:
; H042+$00000B6C: 4eb90000019a  jsr $19a.l
        jsr (H030+$19A).l
L042_00000B72:
; H042+$00000B72: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000B74:
; H042+$00000B74: 4e5d  unlk a5
        unlk a5
L042_00000B76:
; H042+$00000B76: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00000B78:
; H042+$00000B78: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_00000B7A:
; H042+$00000B7A: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L042_00000B7E:
; H042+$00000B7E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H042_00000B80 [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; richiama H036+$0034, H003+$0068, H088+$000C, H020+$085A.
;   - Richiama H036+$0034.
;   - Richiama H003+$0068.
;   - Richiama H088+$000C.
;   - Richiama H020+$085A.
;   - Richiama H029+$091E.
;   - Richiama H029+$0766.
;   - Richiama H003+$00F6.
; Chiamanti diretti: H008+$0752, H042+$0F8A, H012+$283C
; --------------------------------------------------------------------------
L042_00000B80:
; H042+$00000B80: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000B82:
; H042+$00000B82: 287af5be  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_00000B86:
; H042+$00000B86: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L042_00000B8A:
; H042+$00000B8A: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L042_00000B8E:
; H042+$00000B8E: 67000034  beq.w $bc4
        beq.w H042+$BC4
L042_00000B92:
; H042+$00000B92: 4a2cffff  tst.b -$1(a4)
        tst.b -$1(a4)
L042_00000B96:
; H042+$00000B96: 6600002c  bne.w $bc4
        bne.w H042+$BC4
L042_00000B9A:
; H042+$00000B9A: 197c0001ffff  move.b #$1, -$1(a4)
        move.b #$1, -$1(a4)
L042_00000BA0:
; H042+$00000BA0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000BA4:
; H042+$00000BA4: 486b0006  pea.l $6(a3)
        pea.l $6(a3)
L042_00000BA8:
; H042+$00000BA8: 6100f604  bsr.w $1ae
        bsr.w H042+$1AE
L042_00000BAC:
; H042+$00000BAC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000BB0:
; H042+$00000BB0: 0c530002  cmpi.w #$2, (a3)
        cmpi.w #$2, (a3)
L042_00000BB4:
; H042+$00000BB4: 6600000e  bne.w $bc4
        bne.w H042+$BC4
L042_00000BB8:
; H042+$00000BB8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000BBC:
; H042+$00000BBC: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
L042_00000BC0:
; H042+$00000BC0: 6100f5ec  bsr.w $1ae
        bsr.w H042+$1AE
L042_00000BC4:
; H042+$00000BC4: 0c6d00010010  cmpi.w #$1, $10(a5)
        cmpi.w #$1, $10(a5)
L042_00000BCA:
; H042+$00000BCA: 65000194  bcs.w $d60
        bcs.w H042+$D60
L042_00000BCE:
; H042+$00000BCE: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L042_00000BD2:
; H042+$00000BD2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000BD6:
; H042+$00000BD6: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L042_00000BD8:
; H042+$00000BD8: 62000186  bhi.w $d60
        bhi.w H042+$D60
L042_00000BDC:
; H042+$00000BDC: 0c6d00010010  cmpi.w #$1, $10(a5)
        cmpi.w #$1, $10(a5)
L042_00000BE2:
; H042+$00000BE2: 67000012  beq.w $bf6
        beq.w H042+$BF6
L042_00000BE6:
; H042+$00000BE6: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L042_00000BEA:
; H042+$00000BEA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000BEE:
; H042+$00000BEE: b46b0004  cmp.w $4(a3), d2
        cmp.w $4(a3), d2
L042_00000BF2:
; H042+$00000BF2: 66000038  bne.w $c2c
        bne.w H042+$C2C
L042_00000BF6:
; H042+$00000BF6: 2f3c0000000b  move.l #$b, -(a7)
        move.l #$b, -(a7)
; -> H036+$0034 (wrapper_Delay)
L042_00000BFC:
; H042+$00000BFC: 4eb900000034  jsr $34.l
        jsr (H036+$34).l
L042_00000C02:
; H042+$00000C02: 0c6d00010010  cmpi.w #$1, $10(a5)
        cmpi.w #$1, $10(a5)
L042_00000C08:
; H042+$00000C08: 66000012  bne.w $c1c
        bne.w H042+$C1C
L042_00000C0C:
; H042+$00000C0C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000C10:
; H042+$00000C10: 202b0006  move.l $6(a3), d0
        move.l $6(a3), d0
L042_00000C14:
; H042+$00000C14: 60000150  bra.w $d66
        bra.w H042+$D66
; Preserved bytes H042+$00000C18..$00000C1C; code/data not fully classified.
        dc.w $6000,$000E
L042_00000C1C:
; H042+$00000C1C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000C20:
; H042+$00000C20: 202b000a  move.l $a(a3), d0
        move.l $a(a3), d0
L042_00000C24:
; H042+$00000C24: 60000140  bra.w $d66
        bra.w H042+$D66
; Preserved bytes H042+$00000C28..$00000C2C; code/data not fully classified.
        dc.w $6000,$0132
L042_00000C2C:
; H042+$00000C2C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_00000C30:
; H042+$00000C30: 266a000a  movea.l $a(a2), a3
        movea.l $a(a2), a3
L042_00000C34:
; H042+$00000C34: 3b6b000afffa  move.w $a(a3), -$6(a5)
        move.w $a(a3), -$6(a5)
L042_00000C3A:
; H042+$00000C3A: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000C3C:
; H042+$00000C3C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L042_00000C40:
; H042+$00000C40: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_00000C42:
; H042+$00000C42: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L042_00000C44:
; H042+$00000C44: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L042_00000C4A:
; H042+$00000C4A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L042_00000C4E:
; H042+$00000C4E: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L042_00000C52:
; H042+$00000C52: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_00000C54:
; H042+$00000C54: e542  asl.w #$2, d2
        asl.w #$2, d2
L042_00000C56:
; H042+$00000C56: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000C5A:
; H042+$00000C5A: 47eb002c  lea.l $2c(a3), a3
        lea.l $2c(a3), a3
L042_00000C5E:
; H042+$00000C5E: 2b732000fff4  move.l (a3, d2.w), -$c(a5)
        move.l (a3, d2.w), -$c(a5)
L042_00000C64:
; H042+$00000C64: 2b6dfffcfff0  move.l -$4(a5), -$10(a5)
        move.l -$4(a5), -$10(a5)
L042_00000C6A:
; H042+$00000C6A: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
L042_00000C6E:
; H042+$00000C6E: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
L042_00000C72:
; H042+$00000C72: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L042_00000C76:
; H042+$00000C76: 5542  subq.w #$2, d2
        subq.w #$2, d2
L042_00000C78:
; H042+$00000C78: e342  asl.w #$1, d2
        asl.w #$1, d2
L042_00000C7A:
; H042+$00000C7A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000C7E:
; H042+$00000C7E: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L042_00000C82:
; H042+$00000C82: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L042_00000C86:
; H042+$00000C86: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; FLUSSO: Chiama UnPackRow_ByteRun1 (H088+$000C).
L042_00000C8A:
; H042+$00000C8A: 4eb90000000c  jsr $c.l
        jsr (H088+$C).l
L042_00000C90:
; H042+$00000C90: 1400  move.b d0, d2
        move.b d0, d2
L042_00000C92:
; H042+$00000C92: 4a02  tst.b d2
        tst.b d2
L042_00000C94:
; H042+$00000C94: 67000010  beq.w $ca6
        beq.w H042+$CA6
L042_00000C98:
; H042+$00000C98: 3f3c0024  move.w #$24, -(a7)
        move.w #$24, -(a7)
L042_00000C9C:
; H042+$00000C9C: 486c00cc  pea.l $cc(a4)
        pea.l $cc(a4)
; -> H020+$085A (sub_H020_0000085A)
L042_00000CA0:
; H042+$00000CA0: 4eb90000085a  jsr $85a.l
        jsr (H020+$85A).l
L042_00000CA6:
; H042+$00000CA6: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_00000CAA:
; H042+$00000CAA: 266a000a  movea.l $a(a2), a3
        movea.l $a(a2), a3
L042_00000CAE:
; H042+$00000CAE: 2b6b000cffec  move.l $c(a3), -$14(a5)
        move.l $c(a3), -$14(a5)
L042_00000CB4:
; H042+$00000CB4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_00000CB8:
; H042+$00000CB8: 266a000a  movea.l $a(a2), a3
        movea.l $a(a2), a3
L042_00000CBC:
; H042+$00000CBC: 42ab000c  clr.l $c(a3)
        clr.l $c(a3)
L042_00000CC0:
; H042+$00000CC0: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L042_00000CC4:
; H042+$00000CC4: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000CC6:
; H042+$00000CC6: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L042_00000CCA:
; H042+$00000CCA: 4227  clr.b -(a7)
        clr.b -(a7)
L042_00000CCC:
; H042+$00000CCC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000CD0:
; H042+$00000CD0: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
; FLUSSO: Chiama Populate_GraphicPlanes (H029+$091E).
L042_00000CD4:
; H042+$00000CD4: 4eb90000091e  jsr $91e.l
        jsr (H029+$91E).l
L042_00000CDA:
; H042+$00000CDA: 4a2cffff  tst.b -$1(a4)
        tst.b -$1(a4)
L042_00000CDE:
; H042+$00000CDE: 6700000e  beq.w $cee
        beq.w H042+$CEE
L042_00000CE2:
; H042+$00000CE2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000CE6:
; H042+$00000CE6: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
L042_00000CEA:
; H042+$00000CEA: 6100f4c2  bsr.w $1ae
        bsr.w H042+$1AE
L042_00000CEE:
; H042+$00000CEE: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_00000CF2:
; H042+$00000CF2: 266a0006  movea.l $6(a2), a3
        movea.l $6(a2), a3
L042_00000CF6:
; H042+$00000CF6: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L042_00000CFA:
; H042+$00000CFA: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_00000CFE:
; H042+$00000CFE: 266a000a  movea.l $a(a2), a3
        movea.l $a(a2), a3
L042_00000D02:
; H042+$00000D02: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L042_00000D06:
; H042+$00000D06: 6100f6b4  bsr.w $3bc
        bsr.w H042+$3BC
L042_00000D0A:
; H042+$00000D0A: 4aadffec  tst.l -$14(a5)
        tst.l -$14(a5)
L042_00000D0E:
; H042+$00000D0E: 67000024  beq.w $d34
        beq.w H042+$D34
L042_00000D12:
; H042+$00000D12: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_00000D16:
; H042+$00000D16: 266a000a  movea.l $a(a2), a3
        movea.l $a(a2), a3
L042_00000D1A:
; H042+$00000D1A: 276dffec000c  move.l -$14(a5), $c(a3)
        move.l -$14(a5), $c(a3)
L042_00000D20:
; H042+$00000D20: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L042_00000D24:
; H042+$00000D24: 266a000a  movea.l $a(a2), a3
        movea.l $a(a2), a3
L042_00000D28:
; H042+$00000D28: 4853  pea.l (a3)
        pea.l (a3)
L042_00000D2A:
; H042+$00000D2A: 1f3c000d  move.b #$d, -(a7)
        move.b #$d, -(a7)
; -> H029+$0766 (sub_H029_00000766)
L042_00000D2E:
; H042+$00000D2E: 4eb900000766  jsr $766.l
        jsr (H029+$766).l
L042_00000D34:
; H042+$00000D34: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000D38:
; H042+$00000D38: 376d00100004  move.w $10(a5), $4(a3)
        move.w $10(a5), $4(a3)
L042_00000D3E:
; H042+$00000D3E: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L042_00000D42:
; H042+$00000D42: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000D44:
; H042+$00000D44: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L042_00000D48:
; H042+$00000D48: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L042_00000D4A:
; H042+$00000D4A: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L042_00000D50:
; H042+$00000D50: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L042_00000D54:
; H042+$00000D54: 202b000a  move.l $a(a3), d0
        move.l $a(a3), d0
L042_00000D58:
; H042+$00000D58: 6000000c  bra.w $d66
        bra.w H042+$D66
; Preserved bytes H042+$00000D5C..$00000D60; code/data not fully classified.
        dc.w $6000,$0008
L042_00000D60:
; H042+$00000D60: 7000  moveq #$0, d0
        moveq #0, d0
L042_00000D62:
; H042+$00000D62: 60000002  bra.w $d66
        bra.w H042+$D66
L042_00000D66:
; H042+$00000D66: 4e5d  unlk a5
        unlk a5
L042_00000D68:
; H042+$00000D68: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00000D6A:
; H042+$00000D6A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_00000D6C:
; H042+$00000D6C: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L042_00000D6E:
; H042+$00000D6E: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Load_HeadBody [parziale]
; Scopo: Carica le risorse HEAD e BODY usate dalla visualizzazione dei personaggi.
;   - Compone i nomi HEAD e BODY.
;   - Usa il caricamento grafico con l’ID richiesto e segnala la mancata risorsa.
; Chiamanti diretti: H061+$1D4C, H063+$3292
; --------------------------------------------------------------------------
L042_00000D70:
; H042+$00000D70: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000D72:
; H042+$00000D72: 287af3ce  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_00000D76:
; H042+$00000D76: 4e55ffd4  link.w a5, #$ffd4
        link.w a5, #$ffd4
L042_00000D7A:
; H042+$00000D7A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00000D7E:
; H042+$00000D7E: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L042_00000D82:
; H042+$00000D82: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$246E = selettore del gruppo risorse
L042_00000D84:
; H042+$00000D84: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L042_00000D8A:
; H042+$00000D8A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_00000D8C:
; H042+$00000D8C: 4227  clr.b -(a7)
        clr.b -(a7)
L042_00000D8E:
; H042+$00000D8E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L042_00000D92:
; H042+$00000D92: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00000D96:
; H042+$00000D96: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L042_00000D9A:
; H042+$00000D9A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L042_00000DA0:
; H042+$00000DA0: 0c6d00ff000e  cmpi.w #$ff, $e(a5)
        cmpi.w #$ff, $e(a5)
L042_00000DA6:
; H042+$00000DA6: 6700008c  beq.w $e34
        beq.w H042+$E34
L042_00000DAA:
; H042+$00000DAA: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000DAC:
; H042+$00000DAC: 1439000027b0  move.b $27b0.l, d2
        move.b (H005+$27B0).l, d2
L042_00000DB2:
; H042+$00000DB2: 0c4200ff  cmpi.w #$ff, d2
        cmpi.w #$ff, d2
L042_00000DB6:
; H042+$00000DB6: 67000012  beq.w $dca
        beq.w H042+$DCA
L042_00000DBA:
; H042+$00000DBA: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000DBC:
; H042+$00000DBC: 1439000027b0  move.b $27b0.l, d2
        move.b (H005+$27B0).l, d2
L042_00000DC2:
; H042+$00000DC2: b46d000e  cmp.w $e(a5), d2
        cmp.w $e(a5), d2
L042_00000DC6:
; H042+$00000DC6: 6700006c  beq.w $e34
        beq.w H042+$E34
L042_00000DCA:
; H042+$00000DCA: 47ec00f1  lea.l $f1(a4), a3
        lea.l $f1(a4), a3
L042_00000DCE:
; H042+$00000DCE: 45edffd4  lea.l -$2c(a5), a2
        lea.l -$2c(a5), a2
L042_00000DD2:
; H042+$00000DD2: 7428  moveq #$28, d2
        moveq #40, d2
L042_00000DD4:
; H042+$00000DD4: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L042_00000DD6:
; H042+$00000DD6: 57cafffc  dbeq d2, $dd4
        dbeq d2, H042+$DD4
L042_00000DDA:
; H042+$00000DDA: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L042_00000DDE:
; H042+$00000DDE: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L042_00000DE2:
; H042+$00000DE2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00000DE6:
; H042+$00000DE6: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L042_00000DEA:
; H042+$00000DEA: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L042_00000DF0:
; H042+$00000DF0: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L042_00000DF4:
; H042+$00000DF4: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L042_00000DF8:
; H042+$00000DF8: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L042_00000DFC:
; H042+$00000DFC: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000DFE:
; H042+$00000DFE: 4227  clr.b -(a7)
        clr.b -(a7)
L042_00000E00:
; H042+$00000E00: 4879000027b2  pea.l $27b2.l
        pea.l (H005+$27B2).l
; FLUSSO: Chiama Load_IndexedGraphicRecord (H029+$0A0E).
L042_00000E06:
; H042+$00000E06: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L042_00000E0C:
; H042+$00000E0C: 4ab9000027b2  tst.l $27b2.l
        tst.l (H005+$27B2).l
L042_00000E12:
; H042+$00000E12: 66000016  bne.w $e2a
        bne.w H042+$E2A
L042_00000E16:
; H042+$00000E16: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L042_00000E1A:
; H042+$00000E1A: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000E1C:
; H042+$00000E1C: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L042_00000E20:
; H042+$00000E20: 486c00f6  pea.l $f6(a4)
        pea.l $f6(a4)
; -> H030+$028A (sub_H030_0000028A)
L042_00000E24:
; H042+$00000E24: 4eb90000028a  jsr $28a.l
        jsr (H030+$28A).l
L042_00000E2A:
; H042+$00000E2A: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L042_00000E2E:
; H042+$00000E2E: 13c2000027b0  move.b d2, $27b0.l
        move.b d2, (H005+$27B0).l
L042_00000E34:
; H042+$00000E34: 0c6d00ff000c  cmpi.w #$ff, $c(a5)
        cmpi.w #$ff, $c(a5)
L042_00000E3A:
; H042+$00000E3A: 6700008c  beq.w $ec8
        beq.w H042+$EC8
L042_00000E3E:
; H042+$00000E3E: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000E40:
; H042+$00000E40: 1439000027b6  move.b $27b6.l, d2
        move.b (H005+$27B6).l, d2
L042_00000E46:
; H042+$00000E46: 0c4200ff  cmpi.w #$ff, d2
        cmpi.w #$ff, d2
L042_00000E4A:
; H042+$00000E4A: 67000012  beq.w $e5e
        beq.w H042+$E5E
L042_00000E4E:
; H042+$00000E4E: 7400  moveq #$0, d2
        moveq #0, d2
L042_00000E50:
; H042+$00000E50: 1439000027b6  move.b $27b6.l, d2
        move.b (H005+$27B6).l, d2
L042_00000E56:
; H042+$00000E56: b46d000c  cmp.w $c(a5), d2
        cmp.w $c(a5), d2
L042_00000E5A:
; H042+$00000E5A: 6700006c  beq.w $ec8
        beq.w H042+$EC8
L042_00000E5E:
; H042+$00000E5E: 47ec0105  lea.l $105(a4), a3
        lea.l $105(a4), a3
L042_00000E62:
; H042+$00000E62: 45edffd4  lea.l -$2c(a5), a2
        lea.l -$2c(a5), a2
L042_00000E66:
; H042+$00000E66: 7428  moveq #$28, d2
        moveq #40, d2
L042_00000E68:
; H042+$00000E68: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L042_00000E6A:
; H042+$00000E6A: 57cafffc  dbeq d2, $e68
        dbeq d2, H042+$E68
L042_00000E6E:
; H042+$00000E6E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L042_00000E72:
; H042+$00000E72: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L042_00000E76:
; H042+$00000E76: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00000E7A:
; H042+$00000E7A: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L042_00000E7E:
; H042+$00000E7E: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L042_00000E84:
; H042+$00000E84: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L042_00000E88:
; H042+$00000E88: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L042_00000E8C:
; H042+$00000E8C: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L042_00000E90:
; H042+$00000E90: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000E92:
; H042+$00000E92: 4227  clr.b -(a7)
        clr.b -(a7)
L042_00000E94:
; H042+$00000E94: 4879000027b8  pea.l $27b8.l
        pea.l (H005+$27B8).l
; FLUSSO: Chiama Load_IndexedGraphicRecord (H029+$0A0E).
L042_00000E9A:
; H042+$00000E9A: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L042_00000EA0:
; H042+$00000EA0: 4ab9000027b8  tst.l $27b8.l
        tst.l (H005+$27B8).l
L042_00000EA6:
; H042+$00000EA6: 66000016  bne.w $ebe
        bne.w H042+$EBE
L042_00000EAA:
; H042+$00000EAA: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L042_00000EAE:
; H042+$00000EAE: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000EB0:
; H042+$00000EB0: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L042_00000EB4:
; H042+$00000EB4: 486c010a  pea.l $10a(a4)
        pea.l $10a(a4)
; -> H030+$028A (sub_H030_0000028A)
L042_00000EB8:
; H042+$00000EB8: 4eb90000028a  jsr $28a.l
        jsr (H030+$28A).l
L042_00000EBE:
; H042+$00000EBE: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L042_00000EC2:
; H042+$00000EC2: 13c2000027b6  move.b d2, $27b6.l
        move.b d2, (H005+$27B6).l
L042_00000EC8:
; H042+$00000EC8: 4e5d  unlk a5
        unlk a5
L042_00000ECA:
; H042+$00000ECA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00000ECC:
; H042+$00000ECC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_00000ECE:
; H042+$00000ECE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L042_00000ED0:
; H042+$00000ED0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H042_00000ED2 [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; richiama H029+$1718, H029+$16A2, H029+$16DE.
;   - Richiama H029+$1718.
;   - Richiama H029+$16A2.
;   - Richiama H029+$16DE.
; Chiamanti diretti: H063+$32A4, H061+$1D5E
; --------------------------------------------------------------------------
L042_00000ED2:
; H042+$00000ED2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000ED4:
; H042+$00000ED4: 287af26c  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_00000ED8:
; H042+$00000ED8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L042_00000EDC:
; H042+$00000EDC: 47f90000522e  lea.l $522e.l, a3
        lea.l (H005+$522E).l, a3
L042_00000EE2:
; H042+$00000EE2: 45f9000052ae  lea.l $52ae.l, a2
        lea.l (H005+$52AE).l, a2
L042_00000EE8:
; H042+$00000EE8: 740f  moveq #$f, d2
        moveq #15, d2
L042_00000EEA:
; H042+$00000EEA: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L042_00000EEC:
; H042+$00000EEC: 51cafffc  dbra d2, $eea
        dbra d2, H042+$EEA
; -> H029+$1718 (sub_H029_00001718)
L042_00000EF0:
; H042+$00000EF0: 4eb900001718  jsr $1718.l
        jsr (H029+$1718).l
; -> H029+$16A2 (sub_H029_000016A2)
L042_00000EF6:
; H042+$00000EF6: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
L042_00000EFC:
; H042+$00000EFC: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L042_00000F00:
; H042+$00000F00: 6700002a  beq.w $f2c
        beq.w H042+$F2C
L042_00000F04:
; H042+$00000F04: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L042_00000F08:
; H042+$00000F08: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L042_00000F0C:
; H042+$00000F0C: 2f39000027b2  move.l $27b2.l, -(a7)
        move.l (H005+$27B2).l, -(a7)
L042_00000F12:
; H042+$00000F12: 6100f39e  bsr.w $2b2
        bsr.w H042+$2B2
L042_00000F16:
; H042+$00000F16: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L042_00000F1A:
; H042+$00000F1A: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L042_00000F1E:
; H042+$00000F1E: 2f39000027b8  move.l $27b8.l, -(a7)
        move.l (H005+$27B8).l, -(a7)
L042_00000F24:
; H042+$00000F24: 6100f3b0  bsr.w $2d6
        bsr.w H042+$2D6
L042_00000F28:
; H042+$00000F28: 60000016  bra.w $f40
        bra.w H042+$F40
L042_00000F2C:
; H042+$00000F2C: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L042_00000F30:
; H042+$00000F30: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L042_00000F34:
; H042+$00000F34: 4227  clr.b -(a7)
        clr.b -(a7)
L042_00000F36:
; H042+$00000F36: 2f39000027b2  move.l $27b2.l, -(a7)
        move.l (H005+$27B2).l, -(a7)
L042_00000F3C:
; H042+$00000F3C: 6100f316  bsr.w $254
        bsr.w H042+$254
; -> H029+$16DE (sub_H029_000016DE)
L042_00000F40:
; H042+$00000F40: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L042_00000F46:
; H042+$00000F46: 4e5d  unlk a5
        unlk a5
L042_00000F48:
; H042+$00000F48: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00000F4A:
; H042+$00000F4A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_00000F4C:
; H042+$00000F4C: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L042_00000F4E:
; H042+$00000F4E: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Show3DSprite [parziale]
; Scopo: Percorso di visualizzazione di uno sprite nella scena 3D.
;   - Verifica il range richiesto e usa i record grafici/sequence del contesto.
;   - Il messaggio Illegal range in Show3DSprite identifica il sottosistema.
;   - I parametri geometrici completi restano da documentare.
; Chiamanti diretti: H061+$1E1E
; --------------------------------------------------------------------------
L042_00000F50:
; H042+$00000F50: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00000F52:
; H042+$00000F52: 287af1ee  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_00000F56:
; H042+$00000F56: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L042_00000F5A:
; H042+$00000F5A: 0c6d00010010  cmpi.w #$1, $10(a5)
        cmpi.w #$1, $10(a5)
L042_00000F60:
; H042+$00000F60: 6500000c  bcs.w $f6e
        bcs.w H042+$F6E
L042_00000F64:
; H042+$00000F64: 0c6d00030010  cmpi.w #$3, $10(a5)
        cmpi.w #$3, $10(a5)
L042_00000F6A:
; H042+$00000F6A: 63000016  bls.w $f82
        bls.w H042+$F82
L042_00000F6E:
; H042+$00000F6E: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L042_00000F72:
; H042+$00000F72: 486c0119  pea.l $119(a4)
        pea.l $119(a4)
; -> H010+$0360 (sub_H010_00000360)
L042_00000F76:
; H042+$00000F76: 4eb900000360  jsr $360.l
        jsr (H010+$360).l
; -> H010+$0332 (sub_H010_00000332)
L042_00000F7C:
; H042+$00000F7C: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L042_00000F82:
; H042+$00000F82: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L042_00000F86:
; H042+$00000F86: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L042_00000F8A:
; H042+$00000F8A: 6100fbf4  bsr.w $b80
        bsr.w H042+$B80
L042_00000F8E:
; H042+$00000F8E: 2b40fffa  move.l d0, -$6(a5)
        move.l d0, -$6(a5)
L042_00000F92:
; H042+$00000F92: 4aadfffa  tst.l -$6(a5)
        tst.l -$6(a5)
L042_00000F96:
; H042+$00000F96: 67000060  beq.w $ff8
        beq.w H042+$FF8
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L042_00000F9A:
; H042+$00000F9A: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L042_00000FA0:
; H042+$00000FA0: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L042_00000FA4:
; H042+$00000FA4: 47f9000052ae  lea.l $52ae.l, a3
        lea.l (H005+$52AE).l, a3
L042_00000FAA:
; H042+$00000FAA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000FAC:
; H042+$00000FAC: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L042_00000FB0:
; H042+$00000FB0: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L042_00000FB6:
; H042+$00000FB6: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L042_00000FBA:
; H042+$00000FBA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_00000FBC:
; H042+$00000FBC: 2f2b0010  move.l $10(a3), -(a7)
        move.l $10(a3), -(a7)
L042_00000FC0:
; H042+$00000FC0: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00000FC2:
; H042+$00000FC2: 4267  clr.w -(a7)
        clr.w -(a7)
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L042_00000FC4:
; H042+$00000FC4: 2479000052f2  movea.l $52f2.l, a2
        movea.l (H005+$52F2).l, a2
L042_00000FCA:
; H042+$00000FCA: 45ea0054  lea.l $54(a2), a2
        lea.l $54(a2), a2
L042_00000FCE:
; H042+$00000FCE: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L042_00000FD0:
; H042+$00000FD0: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L042_00000FD4:
; H042+$00000FD4: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L042_00000FD8:
; H042+$00000FD8: 3f3c0058  move.w #$58, -(a7)
        move.w #$58, -(a7)
L042_00000FDC:
; H042+$00000FDC: 3f3c0058  move.w #$58, -(a7)
        move.w #$58, -(a7)
L042_00000FE0:
; H042+$00000FE0: 1f3c00ca  move.b #$ca, -(a7)
        move.b #$ca, -(a7)
L042_00000FE4:
; H042+$00000FE4: 246b000c  movea.l $c(a3), a2
        movea.l $c(a3), a2
L042_00000FE8:
; H042+$00000FE8: 2f2a0008  move.l $8(a2), -(a7)
        move.l $8(a2), -(a7)
; FLUSSO: Chiama Queue_BitplaneBlit (H049+$04AE).
L042_00000FEC:
; H042+$00000FEC: 4eb9000004ae  jsr $4ae.l
        jsr (H049+$4AE).l
L042_00000FF2:
; H042+$00000FF2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L042_00000FF4:
; H042+$00000FF4: 60000006  bra.w $ffc
        bra.w H042+$FFC
L042_00000FF8:
; H042+$00000FF8: 60000002  bra.w $ffc
        bra.w H042+$FFC
L042_00000FFC:
; H042+$00000FFC: 4e5d  unlk a5
        unlk a5
L042_00000FFE:
; H042+$00000FFE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00001000:
; H042+$00001000: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_00001002:
; H042+$00001002: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L042_00001004:
; H042+$00001004: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Load_BigPicture [parziale]
; Scopo: Carica la risorsa BIGPIC richiesta.
;   - Costruisce il nome BIGPIC e richiama i servizi di caricamento grafico.
;   - La relazione con tutti i formati di picture resta da completare.
; Chiamanti diretti: H012+$0A3E, H064+$0B72, H066+$2FDE
; --------------------------------------------------------------------------
L042_00001006:
; H042+$00001006: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_00001008:
; H042+$00001008: 287af138  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_0000100C:
; H042+$0000100C: 4e55ffd2  link.w a5, #$ffd2
        link.w a5, #$ffd2
L042_00001010:
; H042+$00001010: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLUSSO: Chiama Free_Sequence (H042+$0300).
L042_00001016:
; H042+$00001016: 6100f2e8  bsr.w $300
        bsr.w H042+$300
L042_0000101A:
; H042+$0000101A: 7400  moveq #$0, d2
        moveq #0, d2
L042_0000101C:
; H042+$0000101C: 143900002484  move.b $2484.l, d2
        move.b (H005+$2484).l, d2
L042_00001022:
; H042+$00001022: b46d000c  cmp.w $c(a5), d2
        cmp.w $c(a5), d2
L042_00001026:
; H042+$00001026: 66000006  bne.w $102e
        bne.w H042+$102E
L042_0000102A:
; H042+$0000102A: 600000a6  bra.w $10d2
        bra.w H042+$10D2
L042_0000102E:
; H042+$0000102E: 47ec0138  lea.l $138(a4), a3
        lea.l $138(a4), a3
L042_00001032:
; H042+$00001032: 45edffd4  lea.l -$2c(a5), a2
        lea.l -$2c(a5), a2
L042_00001036:
; H042+$00001036: 7428  moveq #$28, d2
        moveq #40, d2
L042_00001038:
; H042+$00001038: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L042_0000103A:
; H042+$0000103A: 57cafffc  dbeq d2, $1038
        dbeq d2, H042+$1038
L042_0000103E:
; H042+$0000103E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00001042:
; H042+$00001042: 486dffd2  pea.l -$2e(a5)
        pea.l -$2e(a5)
L042_00001046:
; H042+$00001046: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$246E = selettore del gruppo risorse
L042_00001048:
; H042+$00001048: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L042_0000104E:
; H042+$0000104E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L042_00001050:
; H042+$00001050: 4227  clr.b -(a7)
        clr.b -(a7)
L042_00001052:
; H042+$00001052: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L042_00001056:
; H042+$00001056: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_0000105A:
; H042+$0000105A: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L042_0000105E:
; H042+$0000105E: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L042_00001064:
; H042+$00001064: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L042_00001068:
; H042+$00001068: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L042_0000106C:
; H042+$0000106C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00001070:
; H042+$00001070: 486dffd2  pea.l -$2e(a5)
        pea.l -$2e(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L042_00001074:
; H042+$00001074: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L042_0000107A:
; H042+$0000107A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L042_0000107E:
; H042+$0000107E: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L042_00001082:
; H042+$00001082: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L042_00001086:
; H042+$00001086: 4267  clr.w -(a7)
        clr.w -(a7)
L042_00001088:
; H042+$00001088: 4227  clr.b -(a7)
        clr.b -(a7)
L042_0000108A:
; H042+$0000108A: 487900002798  pea.l $2798.l
        pea.l (H005+$2798).l
; FLUSSO: Chiama Load_IndexedGraphicRecord (H029+$0A0E).
L042_00001090:
; H042+$00001090: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L042_00001096:
; H042+$00001096: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L042_0000109A:
; H042+$0000109A: 0c6d001ffffe  cmpi.w #$1f, -$2(a5)
        cmpi.w #$1f, -$2(a5)
L042_000010A0:
; H042+$000010A0: 62000026  bhi.w $10c8
        bhi.w H042+$10C8
L042_000010A4:
; H042+$000010A4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L042_000010A8:
; H042+$000010A8: e342  asl.w #$1, d2
        asl.w #$1, d2
L042_000010AA:
; H042+$000010AA: 47f90000526e  lea.l $526e.l, a3
        lea.l (H005+$526E).l, a3
L042_000010B0:
; H042+$000010B0: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L042_000010B4:
; H042+$000010B4: e344  asl.w #$1, d4
        asl.w #$1, d4
L042_000010B6:
; H042+$000010B6: 45f90000522e  lea.l $522e.l, a2
        lea.l (H005+$522E).l, a2
L042_000010BC:
; H042+$000010BC: 37b240002000  move.w (a2, d4.w), (a3, d2.w)
        move.w (a2, d4.w), (a3, d2.w)
L042_000010C2:
; H042+$000010C2: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L042_000010C6:
; H042+$000010C6: 64d2  bcc.b $109a
        bcc.b H042+$109A
L042_000010C8:
; H042+$000010C8: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L042_000010CC:
; H042+$000010CC: 13c200002484  move.b d2, $2484.l
        move.b d2, (H005+$2484).l
L042_000010D2:
; H042+$000010D2: 4e5d  unlk a5
        unlk a5
L042_000010D4:
; H042+$000010D4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_000010D6:
; H042+$000010D6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L042_000010D8:
; H042+$000010D8: 548f  addq.l #$2, a7
        addq.l #$2, a7
L042_000010DA:
; H042+$000010DA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H042_000010DC [parziale]
; Scopo: Routine del modulo sequenze grafiche, cache, HEAD/BODY e BIGPIC; richiama H029+$1718, H029+$16A2, H044+$0452, H022+$0084.
;   - Richiama H029+$1718.
;   - Richiama H029+$16A2.
;   - Richiama H044+$0452.
;   - Richiama H022+$0084.
;   - Richiama H029+$0E92.
;   - Richiama H029+$16DE.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H060+$0174, H064+$0B78
; --------------------------------------------------------------------------
L042_000010DC:
; H042+$000010DC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L042_000010DE:
; H042+$000010DE: 287af062  movea.l $142(pc), a4
        movea.l H042+$142(pc), a4
L042_000010E2:
; H042+$000010E2: 4e550000  link.w a5, #$0
        link.w a5, #$0
; -> H029+$1718 (sub_H029_00001718)
L042_000010E6:
; H042+$000010E6: 4eb900001718  jsr $1718.l
        jsr (H029+$1718).l
; -> H029+$16A2 (sub_H029_000016A2)
L042_000010EC:
; H042+$000010EC: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
; -> H044+$0452 (sub_H044_00000452)
L042_000010F2:
; H042+$000010F2: 4eb900000452  jsr $452.l
        jsr (H044+$452).l
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L042_000010F8:
; H042+$000010F8: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L042_000010FE:
; H042+$000010FE: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L042_00001102:
; H042+$00001102: 47f90000526e  lea.l $526e.l, a3
        lea.l (H005+$526E).l, a3
L042_00001108:
; H042+$00001108: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L042_0000110A:
; H042+$0000110A: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L042_0000110E:
; H042+$0000110E: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L042_00001114:
; H042+$00001114: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_00001118:
; H042+$00001118: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L042_0000111C:
; H042+$0000111C: 2f3900002798  move.l $2798.l, -(a7)
        move.l (H005+$2798).l, -(a7)
; -> H029+$0E92 (trampoline_H029_0EF4)
L042_00001122:
; H042+$00001122: 4eb900000e92  jsr $e92.l
        jsr (H029+$E92).l
; -> H029+$16DE (sub_H029_000016DE)
L042_00001128:
; H042+$00001128: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L042_0000112E:
; H042+$0000112E: 4e5d  unlk a5
        unlk a5
L042_00001130:
; H042+$00001130: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00001132:
; H042+$00001132: 4e75  rts 
        rts 
L042_00001134:
; H042+$00001134: 422cffff  clr.b -$1(a4)
        clr.b -$1(a4)
L042_00001138:
; H042+$00001138: 422cfffe  clr.b -$2(a4)
        clr.b -$2(a4)
L042_0000113C:
; H042+$0000113C: 4e5d  unlk a5
        unlk a5
L042_0000113E:
; H042+$0000113E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L042_00001140:
; H042+$00001140: 4e75  rts 
        rts 
; Preserved bytes H042+$00001142..$00001144; code/data not fully classified.
        dc.w $0000
; End H042: $1144 bytes
