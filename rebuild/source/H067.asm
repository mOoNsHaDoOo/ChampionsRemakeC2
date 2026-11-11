; ============================================================================
; GUIDA DEL MODULO H067
; Monete, gemme, gioielli e condivisione del denaro.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Monete, gemme, gioielli e condivisione del denaro: conversioni, somme e distribuzione al party.
; --------------------------------------------------------------------------
; H067: 9820 original bytes; all offsets are section-relative.
        section H067,code
H067:
; Preserved bytes H067+$00000000..$000001BA; code/data not fully classified.
        dc.w $4F76,$6572,$6C6F,$6164,$6564,$2E20,$204D,$6F6E
        dc.w $6579,$2077,$696C,$6C20,$6265,$2070,$7574,$2069
        dc.w $6E20,$506F,$6F6C,$2E00,$0000,$4F76,$6572,$6C6F
        dc.w $6164,$6564,$004F,$7665,$726C,$6F61,$6465,$6400
        dc.w $4765,$6D73,$2000,$706C,$6174,$696E,$756D,$2000
        dc.w $6272,$6F6E,$7A65,$2000,$7369,$6C76,$6572,$2000
        dc.w $7374,$6565,$6C20,$0043,$6F70,$7065,$7220,$004A
        dc.w $6577,$656C,$7279,$2000,$2000,$5365,$6C65,$6374
        dc.w $2074,$7970,$6520,$6F66,$2063,$6F69,$6E20,$0053
        dc.w $656C,$6563,$7400,$486F,$7720,$6D75,$6368,$2000
        dc.w $2077,$696C,$6C20,$796F,$7520,$7461,$6B65,$3F20
        dc.w $004E,$6F20,$4765,$6D73,$206F,$7220,$4A65,$7765
        dc.w $6C72,$7900,$0000,$2047,$656D,$0020,$4765,$6D73
        dc.w $0000,$0020,$7069,$6563,$6520,$6F66,$204A,$6577
        dc.w $656C,$7279,$0020,$7069,$6563,$6573,$206F,$6620
        dc.w $4A65,$7765,$6C72,$7900,$596F,$7520,$6861,$7665
        dc.w $2061,$2066,$696E,$6520,$636F,$6C6C,$6563,$7469
        dc.w $6F6E,$206F,$6620,$3A20,$0000,$0020,$2047,$656D
        dc.w $7300,$2020,$4A65,$7765,$6C72,$7900,$2045,$7869
        dc.w $7400,$4170,$7072,$6169,$7365,$2020,$3A20,$2000
        dc.w $5468,$6520,$4765,$6D20,$6973,$2056,$616C,$7565
        dc.w $6420,$6174,$2000,$2073,$7465,$656C,$2E00,$5365
        dc.w $6C6C,$0053,$656C,$6C20,$4B65,$6570,$0059,$6F75
        dc.w $2063,$616E,$2020,$3A20,$2000,$5468,$6520,$4A65
        dc.w $7765,$6C20,$6973,$2056,$616C,$7565,$6420,$6174
        dc.w $2000,$2073,$7465,$656C,$2E00,$5365,$6C6C,$0053
        dc.w $656C,$6C20,$4B65,$6570,$0059,$6F75,$2063,$616E
        dc.w $2020,$3A20,$2000
        dc.l H067+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H067 [parziale]
; Scopo: Ingresso del modulo monete, gemme, gioielli e condivisione del denaro; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H067+$2654.
; Chiamanti diretti: H000+$01C2
; --------------------------------------------------------------------------
L067_000001BA:
; H067+$000001BA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000001BC:
; H067+$000001BC: 287afff8  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000001C0:
; H067+$000001C0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L067_000001C4:
; H067+$000001C4: 6000248e  bra.w $2654
        bra.w H067+$2654
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_000001C8 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H063+$1A8A.
;   - Richiama H063+$1A8A.
; Chiamanti diretti: H067+$0718, H067+$0240, H067+$0B48
; --------------------------------------------------------------------------
L067_000001C8:
; H067+$000001C8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000001CA:
; H067+$000001CA: 287affea  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000001CE:
; H067+$000001CE: 4e550000  link.w a5, #$0
        link.w a5, #$0
L067_000001D2:
; H067+$000001D2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$1A8A (trampoline_H063_1B66)
L067_000001D6:
; H067+$000001D6: 4eb900001a8a  jsr $1a8a.l
        jsr (H063+$1A8A).l
L067_000001DC:
; H067+$000001DC: 3400  move.w d0, d2
        move.w d0, d2
L067_000001DE:
; H067+$000001DE: 064205dc  addi.w #$5dc, d2
        addi.w #$5dc, d2
L067_000001E2:
; H067+$000001E2: 3002  move.w d2, d0
        move.w d2, d0
L067_000001E4:
; H067+$000001E4: 60000002  bra.w $1e8
        bra.w H067+$1E8
L067_000001E8:
; H067+$000001E8: 4e5d  unlk a5
        unlk a5
L067_000001EA:
; H067+$000001EA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_000001EC:
; H067+$000001EC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_000001EE:
; H067+$000001EE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L067_000001F0:
; H067+$000001F0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_000001F2 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H067+$0CB6, H067+$074A, H067+$0838
; --------------------------------------------------------------------------
L067_000001F2:
; H067+$000001F2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000001F4:
; H067+$000001F4: 287affc0  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000001F8:
; H067+$000001F8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L067_000001FC:
; H067+$000001FC: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L067_00000200:
; H067+$00000200: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L067_00000204:
; H067+$00000204: 956b018c  sub.w d2, $18c(a3)
        sub.w d2, $18c(a3)
L067_00000208:
; H067+$00000208: 4e5d  unlk a5
        unlk a5
L067_0000020A:
; H067+$0000020A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_0000020C:
; H067+$0000020C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_0000020E:
; H067+$0000020E: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L067_00000210:
; H067+$00000210: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000212 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H067+$0772, H067+$0A40, H067+$0A8C, H067+$0B9A, H067+$0AF8, H067+$0BFE e altri 3
; --------------------------------------------------------------------------
L067_00000212:
; H067+$00000212: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000214:
; H067+$00000214: 287affa0  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000218:
; H067+$00000218: 4e550000  link.w a5, #$0
        link.w a5, #$0
L067_0000021C:
; H067+$0000021C: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L067_00000220:
; H067+$00000220: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L067_00000224:
; H067+$00000224: d56b018c  add.w d2, $18c(a3)
        add.w d2, $18c(a3)
L067_00000228:
; H067+$00000228: 4e5d  unlk a5
        unlk a5
L067_0000022A:
; H067+$0000022A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_0000022C:
; H067+$0000022C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_0000022E:
; H067+$0000022E: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L067_00000230:
; H067+$00000230: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000232 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H065+$2274, H067+$09FC, H067+$0A64, H067+$0D20, H067+$214A, H067+$243C e altri 1
; --------------------------------------------------------------------------
L067_00000232:
; H067+$00000232: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000234:
; H067+$00000234: 287aff80  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000238:
; H067+$00000238: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L067_0000023C:
; H067+$0000023C: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L067_00000240:
; H067+$00000240: 6186  bsr.b $1c8
        bsr.b H067+$1C8
L067_00000242:
; H067+$00000242: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L067_00000246:
; H067+$00000246: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L067_0000024A:
; H067+$0000024A: 342b018c  move.w $18c(a3), d2
        move.w $18c(a3), d2
L067_0000024E:
; H067+$0000024E: d46d0010  add.w $10(a5), d2
        add.w $10(a5), d2
L067_00000252:
; H067+$00000252: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L067_00000256:
; H067+$00000256: 63000038  bls.w $290
        bls.w H067+$290
L067_0000025A:
; H067+$0000025A: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L067_00000260:
; H067+$00000260: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L067_00000264:
; H067+$00000264: 342b018c  move.w $18c(a3), d2
        move.w $18c(a3), d2
L067_00000268:
; H067+$00000268: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L067_0000026C:
; H067+$0000026C: 6300000c  bls.w $27a
        bls.w H067+$27A
L067_00000270:
; H067+$00000270: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_00000274:
; H067+$00000274: 4253  clr.w (a3)
        clr.w (a3)
L067_00000276:
; H067+$00000276: 60000014  bra.w $28c
        bra.w H067+$28C
L067_0000027A:
; H067+$0000027A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L067_0000027E:
; H067+$0000027E: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L067_00000282:
; H067+$00000282: 946b018c  sub.w $18c(a3), d2
        sub.w $18c(a3), d2
L067_00000286:
; H067+$00000286: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_0000028A:
; H067+$0000028A: 3682  move.w d2, (a3)
        move.w d2, (a3)
L067_0000028C:
; H067+$0000028C: 6000000c  bra.w $29a
        bra.w H067+$29A
L067_00000290:
; H067+$00000290: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L067_00000294:
; H067+$00000294: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_00000298:
; H067+$00000298: 4253  clr.w (a3)
        clr.w (a3)
L067_0000029A:
; H067+$0000029A: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L067_0000029E:
; H067+$0000029E: 60000002  bra.w $2a2
        bra.w H067+$2A2
L067_000002A2:
; H067+$000002A2: 4e5d  unlk a5
        unlk a5
L067_000002A4:
; H067+$000002A4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_000002A6:
; H067+$000002A6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_000002A8:
; H067+$000002A8: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L067_000002AC:
; H067+$000002AC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_000002AE [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H015+$004A, H015+$00BC.
;   - Richiama H015+$004A.
;   - Richiama H015+$00BC.
; Chiamanti diretti: H065+$23EC, H071+$07FC, H072+$0486
; --------------------------------------------------------------------------
L067_000002AE:
; H067+$000002AE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000002B0:
; H067+$000002B0: 287aff04  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000002B4:
; H067+$000002B4: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L067_000002B8:
; H067+$000002B8: 7400  moveq #$0, d2
        moveq #0, d2
L067_000002BA:
; H067+$000002BA: 2b42fffc  move.l d2, -$4(a5)
        move.l d2, -$4(a5)
L067_000002BE:
; H067+$000002BE: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L067_000002C2:
; H067+$000002C2: 0c2d0004fff7  cmpi.b #$4, -$9(a5)
        cmpi.b #$4, -$9(a5)
L067_000002C8:
; H067+$000002C8: 6200003e  bhi.w $308
        bhi.w H067+$308
L067_000002CC:
; H067+$000002CC: 7400  moveq #$0, d2
        moveq #0, d2
L067_000002CE:
; H067+$000002CE: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L067_000002D2:
; H067+$000002D2: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_000002D4:
; H067+$000002D4: 47f900000000  lea.l $0.l, a3
        lea.l (H005+$0).l, a3
L067_000002DA:
; H067+$000002DA: 7800  moveq #$0, d4
        moveq #0, d4
L067_000002DC:
; H067+$000002DC: 182dfff7  move.b -$9(a5), d4
        move.b -$9(a5), d4
L067_000002E0:
; H067+$000002E0: e544  asl.w #$2, d4
        asl.w #$2, d4
L067_000002E2:
; H067+$000002E2: 45ed000c  lea.l $c(a5), a2
        lea.l $c(a5), a2
L067_000002E6:
; H067+$000002E6: 2c332000  move.l (a3, d2.w), d6
        move.l (a3, d2.w), d6
L067_000002EA:
; H067+$000002EA: 2006  move.l d6, d0
        move.l d6, d0
L067_000002EC:
; H067+$000002EC: 22324000  move.l (a2, d4.w), d1
        move.l (a2, d4.w), d1
; -> H015+$004A (sub_H015_0000004A)
L067_000002F0:
; H067+$000002F0: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L067_000002F6:
; H067+$000002F6: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L067_000002FA:
; H067+$000002FA: 242dfff8  move.l -$8(a5), d2
        move.l -$8(a5), d2
L067_000002FE:
; H067+$000002FE: d5adfffc  add.l d2, -$4(a5)
        add.l d2, -$4(a5)
L067_00000302:
; H067+$00000302: 522dfff7  addq.b #$1, -$9(a5)
        addq.b #$1, -$9(a5)
L067_00000306:
; H067+$00000306: 64ba  bcc.b $2c2
        bcc.b H067+$2C2
L067_00000308:
; H067+$00000308: 242dfffc  move.l -$4(a5), d2
        move.l -$4(a5), d2
L067_0000030C:
; H067+$0000030C: 2002  move.l d2, d0
        move.l d2, d0
L067_0000030E:
; H067+$0000030E: 223900000010  move.l $10.l, d1
        move.l (H005+$10).l, d1
; -> H015+$00BC (sub_H015_000000BC)
L067_00000314:
; H067+$00000314: 4eb9000000bc  jsr $bc.l
        jsr (H015+$BC).l
L067_0000031A:
; H067+$0000031A: 60000002  bra.w $31e
        bra.w H067+$31E
L067_0000031E:
; H067+$0000031E: 4e5d  unlk a5
        unlk a5
L067_00000320:
; H067+$00000320: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00000322:
; H067+$00000322: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00000324:
; H067+$00000324: 4fef001c  lea.l $1c(a7), a7
        lea.l $1c(a7), a7
L067_00000328:
; H067+$00000328: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_0000032A [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; opera su H005+$3368 (personaggio corrente).
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H065+$23CE, H071+$0716, H072+$0468
; --------------------------------------------------------------------------
L067_0000032A:
; H067+$0000032A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_0000032C:
; H067+$0000032C: 287afe88  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000330:
; H067+$00000330: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L067_00000334:
; H067+$00000334: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L067_00000338:
; H067+$00000338: 0c2d0004ffff  cmpi.b #$4, -$1(a5)
        cmpi.b #$4, -$1(a5)
L067_0000033E:
; H067+$0000033E: 6200001e  bhi.w $35e
        bhi.w H067+$35E
L067_00000342:
; H067+$00000342: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000344:
; H067+$00000344: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L067_00000348:
; H067+$00000348: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3368 = personaggio corrente
L067_0000034A:
; H067+$0000034A: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00000350:
; H067+$00000350: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000354:
; H067+$00000354: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L067_00000358:
; H067+$00000358: 522dffff  addq.b #$1, -$1(a5)
        addq.b #$1, -$1(a5)
L067_0000035C:
; H067+$0000035C: 64da  bcc.b $338
        bcc.b H067+$338
; STATO: H005+$3368 = personaggio corrente
L067_0000035E:
; H067+$0000035E: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00000364:
; H067+$00000364: 376d000c00f8  move.w $c(a5), $f8(a3)
        move.w $c(a5), $f8(a3)
L067_0000036A:
; H067+$0000036A: 4e5d  unlk a5
        unlk a5
L067_0000036C:
; H067+$0000036C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_0000036E:
; H067+$0000036E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00000370:
; H067+$00000370: 548f  addq.l #$2, a7
        addq.l #$2, a7
L067_00000372:
; H067+$00000372: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000374 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H065+$2416, H071+$083E, H072+$04AE
; --------------------------------------------------------------------------
L067_00000374:
; H067+$00000374: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000376:
; H067+$00000376: 287afe3e  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_0000037A:
; H067+$0000037A: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L067_0000037E:
; H067+$0000037E: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L067_00000382:
; H067+$00000382: 0c2d0004ffff  cmpi.b #$4, -$1(a5)
        cmpi.b #$4, -$1(a5)
L067_00000388:
; H067+$00000388: 6200001c  bhi.w $3a6
        bhi.w H067+$3A6
L067_0000038C:
; H067+$0000038C: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000038E:
; H067+$0000038E: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L067_00000392:
; H067+$00000392: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000394:
; H067+$00000394: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_0000039A:
; H067+$0000039A: 7800  moveq #$0, d4
        moveq #0, d4
L067_0000039C:
; H067+$0000039C: 27842000  move.l d4, (a3, d2.w)
        move.l d4, (a3, d2.w)
L067_000003A0:
; H067+$000003A0: 522dffff  addq.b #$1, -$1(a5)
        addq.b #$1, -$1(a5)
L067_000003A4:
; H067+$000003A4: 64dc  bcc.b $382
        bcc.b H067+$382
L067_000003A6:
; H067+$000003A6: 7400  moveq #$0, d2
        moveq #0, d2
L067_000003A8:
; H067+$000003A8: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L067_000003AC:
; H067+$000003AC: 23c200002a2e  move.l d2, $2a2e.l
        move.l d2, (H005+$2A2E).l
L067_000003B2:
; H067+$000003B2: 4e5d  unlk a5
        unlk a5
L067_000003B4:
; H067+$000003B4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_000003B6:
; H067+$000003B6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_000003B8:
; H067+$000003B8: 548f  addq.l #$2, a7
        addq.l #$2, a7
L067_000003BA:
; H067+$000003BA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_000003BC [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H063+$1D44.
;   - Richiama H063+$1D44.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H067+$2286, H067+$2578
; --------------------------------------------------------------------------
L067_000003BC:
; H067+$000003BC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000003BE:
; H067+$000003BE: 287afdf6  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000003C2:
; H067+$000003C2: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
; STATO: H005+$3368 = personaggio corrente
L067_000003C6:
; H067+$000003C6: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L067_000003CC:
; H067+$000003CC: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L067_000003D0:
; H067+$000003D0: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L067_000003D4:
; H067+$000003D4: 6100fe5c  bsr.w $232
        bsr.w H067+$232
L067_000003D8:
; H067+$000003D8: 1400  move.b d0, d2
        move.b d0, d2
L067_000003DA:
; H067+$000003DA: 4a02  tst.b d2
        tst.b d2
L067_000003DC:
; H067+$000003DC: 6700004a  beq.w $428
        beq.w H067+$428
L067_000003E0:
; H067+$000003E0: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L067_000003E4:
; H067+$000003E4: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L067_000003E8:
; H067+$000003E8: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L067_000003EE:
; H067+$000003EE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
; STATO: H005+$3368 = personaggio corrente
L067_000003F2:
; H067+$000003F2: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_000003F8:
; H067+$000003F8: d56b00f8  add.w d2, $f8(a3)
        add.w d2, $f8(a3)
; STATO: H005+$3368 = personaggio corrente
L067_000003FC:
; H067+$000003FC: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L067_00000402:
; H067+$00000402: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L067_00000406:
; H067+$00000406: 6100fe0a  bsr.w $212
        bsr.w H067+$212
L067_0000040A:
; H067+$0000040A: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000040C:
; H067+$0000040C: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L067_00000410:
; H067+$00000410: d4b900002a2e  add.l $2a2e.l, d2
        add.l (H005+$2A2E).l, d2
L067_00000416:
; H067+$00000416: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000418:
; H067+$00000418: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L067_0000041C:
; H067+$0000041C: 9484  sub.l d4, d2
        sub.l d4, d2
L067_0000041E:
; H067+$0000041E: 23c200002a2e  move.l d2, $2a2e.l
        move.l d2, (H005+$2A2E).l
L067_00000424:
; H067+$00000424: 6000001e  bra.w $444
        bra.w H067+$444
L067_00000428:
; H067+$00000428: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
; STATO: H005+$3368 = personaggio corrente
L067_0000042C:
; H067+$0000042C: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00000432:
; H067+$00000432: d56b00f8  add.w d2, $f8(a3)
        add.w d2, $f8(a3)
; STATO: H005+$3368 = personaggio corrente
L067_00000436:
; H067+$00000436: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L067_0000043C:
; H067+$0000043C: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L067_00000440:
; H067+$00000440: 6100fdd0  bsr.w $212
        bsr.w H067+$212
L067_00000444:
; H067+$00000444: 4e5d  unlk a5
        unlk a5
L067_00000446:
; H067+$00000446: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00000448:
; H067+$00000448: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_0000044A:
; H067+$0000044A: 548f  addq.l #$2, a7
        addq.l #$2, a7
L067_0000044C:
; H067+$0000044C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_0000044E [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H030+$019A, H030+$0256, H026+$000C, H045+$01D6.
;   - Richiama H030+$019A.
;   - Richiama H030+$0256.
;   - Richiama H026+$000C.
;   - Richiama H045+$01D6.
;   - Richiama H063+$0112.
;   - Richiama H010+$0974.
;   - Richiama H026+$01E0.
;   - Usa lo stato globale: H005+$5305 (byte del tasto/azione pendente).
; Chiamanti diretti: H065+$18F2, H065+$15A8, H067+$117E
; --------------------------------------------------------------------------
L067_0000044E:
; H067+$0000044E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000450:
; H067+$00000450: 287afd64  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000454:
; H067+$00000454: 4e55ffde  link.w a5, #$ffde
        link.w a5, #$ffde
L067_00000458:
; H067+$00000458: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L067_0000045C:
; H067+$0000045C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L067_0000045E:
; H067+$0000045E: 08020000  btst.b #$0, d2
        btst #$0, d2
L067_00000462:
; H067+$00000462: 6702  beq.b $466
        beq.b H067+$466
L067_00000464:
; H067+$00000464: 5242  addq.w #$1, d2
        addq.w #$1, d2
L067_00000466:
; H067+$00000466: 9ec2  suba.w d2, a7
        suba.w d2, a7
L067_00000468:
; H067+$00000468: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L067_0000046C:
; H067+$0000046C: 2b4f000e  move.l a7, $e(a5)
        move.l a7, $e(a5)
L067_00000470:
; H067+$00000470: 244f  movea.l a7, a2
        movea.l a7, a2
L067_00000472:
; H067+$00000472: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00000474:
; H067+$00000474: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00000476:
; H067+$00000476: 51cafffc  dbra d2, $474
        dbra d2, H067+$474
L067_0000047A:
; H067+$0000047A: 4267  clr.w -(a7)
        clr.w -(a7)
L067_0000047C:
; H067+$0000047C: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L067_00000480:
; H067+$00000480: 4267  clr.w -(a7)
        clr.w -(a7)
L067_00000482:
; H067+$00000482: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
; -> H030+$019A (sub_H030_0000019A)
L067_00000486:
; H067+$00000486: 4eb90000019a  jsr $19a.l
        jsr (H030+$19A).l
L067_0000048C:
; H067+$0000048C: 4267  clr.w -(a7)
        clr.w -(a7)
L067_0000048E:
; H067+$0000048E: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L067_00000492:
; H067+$00000492: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L067_00000496:
; H067+$00000496: 4267  clr.w -(a7)
        clr.w -(a7)
L067_00000498:
; H067+$00000498: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L067_0000049C:
; H067+$0000049C: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L067_000004A0:
; H067+$000004A0: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L067_000004A6:
; H067+$000004A6: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L067_000004AA:
; H067+$000004AA: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L067_000004AE:
; H067+$000004AE: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L067_000004B4:
; H067+$000004B4: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L067_000004B8:
; H067+$000004B8: 3b6dfffafffe  move.w -$6(a5), -$2(a5)
        move.w -$6(a5), -$2(a5)
L067_000004BE:
; H067+$000004BE: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_000004C2:
; H067+$000004C2: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
L067_000004C6:
; H067+$000004C6: 7400  moveq #$0, d2
        moveq #0, d2
L067_000004C8:
; H067+$000004C8: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L067_000004CC:
; H067+$000004CC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_000004CE:
; H067+$000004CE: 4227  clr.b -(a7)
        clr.b -(a7)
L067_000004D0:
; H067+$000004D0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_000004D4:
; H067+$000004D4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L067_000004D8:
; H067+$000004D8: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L067_000004DC:
; H067+$000004DC: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L067_000004E2:
; H067+$000004E2: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_000004E6:
; H067+$000004E6: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; -> H063+$0112 (sub_H063_00000112)
L067_000004EA:
; H067+$000004EA: 4eb900000112  jsr $112.l
        jsr (H063+$112).l
L067_000004F0:
; H067+$000004F0: 47ec0028  lea.l $28(a4), a3
        lea.l $28(a4), a3
L067_000004F4:
; H067+$000004F4: 45edffec  lea.l -$14(a5), a2
        lea.l -$14(a5), a2
L067_000004F8:
; H067+$000004F8: 7406  moveq #$6, d2
        moveq #6, d2
L067_000004FA:
; H067+$000004FA: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_000004FC:
; H067+$000004FC: 57cafffc  dbeq d2, $4fa
        dbeq d2, H067+$4FA
; -> H010+$0974 (sub_H010_00000974)
L067_00000500:
; H067+$00000500: 4eb900000974  jsr $974.l
        jsr (H010+$974).l
; STATO: H005+$5305 = byte del tasto/azione pendente
L067_00000506:
; H067+$00000506: 1b7900005305ffeb  move.b $5305.l, -$15(a5)
        move.b (H005+$5305).l, -$15(a5)
L067_0000050E:
; H067+$0000050E: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000510:
; H067+$00000510: 142dffeb  move.b -$15(a5), d2
        move.b -$15(a5), d2
L067_00000514:
; H067+$00000514: 60000150  bra.w $666
        bra.w H067+$666
L067_00000518:
; H067+$00000518: 1b6dffebffde  move.b -$15(a5), -$22(a5)
        move.b -$15(a5), -$22(a5)
L067_0000051E:
; H067+$0000051E: 422dffdf  clr.b -$21(a5)
        clr.b -$21(a5)
L067_00000522:
; H067+$00000522: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_00000526:
; H067+$00000526: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L067_0000052A:
; H067+$0000052A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_0000052E:
; H067+$0000052E: 486dffde  pea.l -$22(a5)
        pea.l -$22(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00000532:
; H067+$00000532: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00000538:
; H067+$00000538: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_0000053C:
; H067+$0000053C: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L067_00000540:
; H067+$00000540: 486dffe6  pea.l -$1a(a5)
        pea.l -$1a(a5)
L067_00000544:
; H067+$00000544: 4227  clr.b -(a7)
        clr.b -(a7)
L067_00000546:
; H067+$00000546: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; -> H045+$000C (trampoline_H045_01CC)
L067_0000054A:
; H067+$0000054A: 4eb90000000c  jsr $c.l
        jsr (H045+$C).l
L067_00000550:
; H067+$00000550: 1b40ffe5  move.b d0, -$1b(a5)
        move.b d0, -$1b(a5)
L067_00000554:
; H067+$00000554: 242dffe6  move.l -$1a(a5), d2
        move.l -$1a(a5), d2
L067_00000558:
; H067+$00000558: b46d0014  cmp.w $14(a5), d2
        cmp.w $14(a5), d2
L067_0000055C:
; H067+$0000055C: 6200000a  bhi.w $568
        bhi.w H067+$568
L067_00000560:
; H067+$00000560: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L067_00000564:
; H067+$00000564: 60000030  bra.w $596
        bra.w H067+$596
L067_00000568:
; H067+$00000568: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_0000056C:
; H067+$0000056C: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L067_00000570:
; H067+$00000570: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_00000574:
; H067+$00000574: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; -> H026+$0188 (sub_H026_00000188)
L067_00000578:
; H067+$00000578: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_0000057E:
; H067+$0000057E: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_00000582:
; H067+$00000582: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; -> H026+$000C (trampoline_H026_0014)
L067_00000586:
; H067+$00000586: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L067_0000058C:
; H067+$0000058C: 3400  move.w d0, d2
        move.w d0, d2
L067_0000058E:
; H067+$0000058E: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L067_00000592:
; H067+$00000592: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L067_00000596:
; H067+$00000596: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L067_0000059A:
; H067+$0000059A: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L067_0000059E:
; H067+$0000059E: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_000005A2:
; H067+$000005A2: 4267  clr.w -(a7)
        clr.w -(a7)
L067_000005A4:
; H067+$000005A4: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_000005A8:
; H067+$000005A8: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L067_000005AC:
; H067+$000005AC: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L067_000005B2:
; H067+$000005B2: 4e75  rts 
        rts 
L067_000005B4:
; H067+$000005B4: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_000005B8:
; H067+$000005B8: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
; -> H026+$000C (trampoline_H026_0014)
L067_000005BC:
; H067+$000005BC: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L067_000005C2:
; H067+$000005C2: 3400  move.w d0, d2
        move.w d0, d2
L067_000005C4:
; H067+$000005C4: 4a42  tst.w d2
        tst.w d2
L067_000005C6:
; H067+$000005C6: 63000034  bls.w $5fc
        bls.w H067+$5FC
L067_000005CA:
; H067+$000005CA: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_000005CE:
; H067+$000005CE: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
; -> H026+$000C (trampoline_H026_0014)
L067_000005D2:
; H067+$000005D2: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L067_000005D8:
; H067+$000005D8: 3400  move.w d0, d2
        move.w d0, d2
L067_000005DA:
; H067+$000005DA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_000005DC:
; H067+$000005DC: 47edffec  lea.l -$14(a5), a3
        lea.l -$14(a5), a3
L067_000005E0:
; H067+$000005E0: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L067_000005E4:
; H067+$000005E4: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L067_000005E8:
; H067+$000005E8: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L067_000005EC:
; H067+$000005EC: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L067_000005F0:
; H067+$000005F0: 4267  clr.w -(a7)
        clr.w -(a7)
L067_000005F2:
; H067+$000005F2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H030+$019A (sub_H030_0000019A)
L067_000005F6:
; H067+$000005F6: 4eb90000019a  jsr $19a.l
        jsr (H030+$19A).l
L067_000005FC:
; H067+$000005FC: 4e75  rts 
        rts 
L067_000005FE:
; H067+$000005FE: 4e75  rts 
        rts 
; Preserved bytes H067+$00000600..$00000666; code/data not fully classified.
        dc.w $FFFC,$FFB2,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FF16,$FF16,$FF16,$FF16,$FF16,$FF16,$FF16
        dc.w $FF16,$FF16,$FF16
L067_00000666:
; H067+$00000666: 47faff9a  lea.l $602(pc), a3
        lea.l H067+$602(pc), a3
L067_0000066A:
; H067+$0000066A: 5142  subq.w #$8, d2
        subq.w #$8, d2
L067_0000066C:
; H067+$0000066C: 0c420031  cmpi.w #$31, d2
        cmpi.w #$31, d2
L067_00000670:
; H067+$00000670: 6302  bls.b $674
        bls.b H067+$674
L067_00000672:
; H067+$00000672: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00000674:
; H067+$00000674: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000676:
; H067+$00000676: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H067+$0602; indici 0..49, default -1.
L067_0000067A:
; H067+$0000067A: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L067_0000067E:
; H067+$0000067E: 0c2d000dffeb  cmpi.b #$d, -$15(a5)
        cmpi.b #$d, -$15(a5)
L067_00000684:
; H067+$00000684: 6700000c  beq.w $692
        beq.w H067+$692
L067_00000688:
; H067+$00000688: 0c2d001bffeb  cmpi.b #$1b, -$15(a5)
        cmpi.b #$1b, -$15(a5)
L067_0000068E:
; H067+$0000068E: 6600fe70  bne.w $500
        bne.w H067+$500
L067_00000692:
; H067+$00000692: 4267  clr.w -(a7)
        clr.w -(a7)
L067_00000694:
; H067+$00000694: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L067_00000698:
; H067+$00000698: 4267  clr.w -(a7)
        clr.w -(a7)
L067_0000069A:
; H067+$0000069A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
; -> H030+$019A (sub_H030_0000019A)
L067_0000069E:
; H067+$0000069E: 4eb90000019a  jsr $19a.l
        jsr (H030+$19A).l
L067_000006A4:
; H067+$000006A4: 0c2d001bffeb  cmpi.b #$1b, -$15(a5)
        cmpi.b #$1b, -$15(a5)
L067_000006AA:
; H067+$000006AA: 6600000a  bne.w $6b6
        bne.w H067+$6B6
L067_000006AE:
; H067+$000006AE: 42adffe0  clr.l -$20(a5)
        clr.l -$20(a5)
L067_000006B2:
; H067+$000006B2: 6000002e  bra.w $6e2
        bra.w H067+$6E2
L067_000006B6:
; H067+$000006B6: 4a2dffec  tst.b -$14(a5)
        tst.b -$14(a5)
L067_000006BA:
; H067+$000006BA: 67000022  beq.w $6de
        beq.w H067+$6DE
L067_000006BE:
; H067+$000006BE: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_000006C2:
; H067+$000006C2: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L067_000006C6:
; H067+$000006C6: 486dffe0  pea.l -$20(a5)
        pea.l -$20(a5)
L067_000006CA:
; H067+$000006CA: 4227  clr.b -(a7)
        clr.b -(a7)
L067_000006CC:
; H067+$000006CC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; -> H045+$000C (trampoline_H045_01CC)
L067_000006D0:
; H067+$000006D0: 4eb90000000c  jsr $c.l
        jsr (H045+$C).l
L067_000006D6:
; H067+$000006D6: 1b40ffe5  move.b d0, -$1b(a5)
        move.b d0, -$1b(a5)
L067_000006DA:
; H067+$000006DA: 60000006  bra.w $6e2
        bra.w H067+$6E2
L067_000006DE:
; H067+$000006DE: 42adffe0  clr.l -$20(a5)
        clr.l -$20(a5)
L067_000006E2:
; H067+$000006E2: 242dffe0  move.l -$20(a5), d2
        move.l -$20(a5), d2
L067_000006E6:
; H067+$000006E6: 3002  move.w d2, d0
        move.w d2, d0
L067_000006E8:
; H067+$000006E8: 60000002  bra.w $6ec
        bra.w H067+$6EC
L067_000006EC:
; H067+$000006EC: 4e5d  unlk a5
        unlk a5
L067_000006EE:
; H067+$000006EE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_000006F0:
; H067+$000006F0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_000006F2:
; H067+$000006F2: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L067_000006F6:
; H067+$000006F6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_000006F8 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H063+$1D44.
;   - Richiama H063+$1D44.
; Chiamanti diretti: H065+$15C4
; --------------------------------------------------------------------------
L067_000006F8:
; H067+$000006F8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000006FA:
; H067+$000006FA: 287afaba  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000006FE:
; H067+$000006FE: 4e550000  link.w a5, #$0
        link.w a5, #$0
L067_00000702:
; H067+$00000702: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L067_00000706:
; H067+$00000706: 2652  movea.l (a2), a3
        movea.l (a2), a3
L067_00000708:
; H067+$00000708: 342b018c  move.w $18c(a3), d2
        move.w $18c(a3), d2
L067_0000070C:
; H067+$0000070C: d46d000e  add.w $e(a5), d2
        add.w $e(a5), d2
L067_00000710:
; H067+$00000710: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_00000712:
; H067+$00000712: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L067_00000716:
; H067+$00000716: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L067_00000718:
; H067+$00000718: 6100faae  bsr.w $1c8
        bsr.w H067+$1C8
L067_0000071C:
; H067+$0000071C: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L067_0000071E:
; H067+$0000071E: 3800  move.w d0, d4
        move.w d0, d4
L067_00000720:
; H067+$00000720: b444  cmp.w d4, d2
        cmp.w d4, d2
L067_00000722:
; H067+$00000722: 62000056  bhi.w $77a
        bhi.w H067+$77A
L067_00000726:
; H067+$00000726: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L067_0000072A:
; H067+$0000072A: 2652  movea.l (a2), a3
        movea.l (a2), a3
L067_0000072C:
; H067+$0000072C: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000072E:
; H067+$0000072E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_00000732:
; H067+$00000732: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000734:
; H067+$00000734: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000738:
; H067+$00000738: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L067_0000073C:
; H067+$0000073C: 99732000  sub.w d4, (a3, d2.w)
        sub.w d4, (a3, d2.w)
L067_00000740:
; H067+$00000740: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L067_00000744:
; H067+$00000744: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L067_00000746:
; H067+$00000746: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L067_0000074A:
; H067+$0000074A: 6100faa6  bsr.w $1f2
        bsr.w H067+$1F2
L067_0000074E:
; H067+$0000074E: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L067_00000752:
; H067+$00000752: 2652  movea.l (a2), a3
        movea.l (a2), a3
L067_00000754:
; H067+$00000754: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000756:
; H067+$00000756: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_0000075A:
; H067+$0000075A: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_0000075C:
; H067+$0000075C: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000760:
; H067+$00000760: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L067_00000764:
; H067+$00000764: d9732000  add.w d4, (a3, d2.w)
        add.w d4, (a3, d2.w)
L067_00000768:
; H067+$00000768: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L067_0000076C:
; H067+$0000076C: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L067_0000076E:
; H067+$0000076E: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L067_00000772:
; H067+$00000772: 6100fa9e  bsr.w $212
        bsr.w H067+$212
L067_00000776:
; H067+$00000776: 60000010  bra.w $788
        bra.w H067+$788
L067_0000077A:
; H067+$0000077A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_0000077E:
; H067+$0000077E: 486c002a  pea.l $2a(a4)
        pea.l $2a(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L067_00000782:
; H067+$00000782: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L067_00000788:
; H067+$00000788: 4e5d  unlk a5
        unlk a5
L067_0000078A:
; H067+$0000078A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_0000078C:
; H067+$0000078C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_0000078E:
; H067+$0000078E: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L067_00000792:
; H067+$00000792: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000794 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H029+$0312.
;   - Richiama H029+$0312.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H072+$1328, H071+$0A5C, H070+$1336
; --------------------------------------------------------------------------
L067_00000794:
; H067+$00000794: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000796:
; H067+$00000796: 287afa1e  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_0000079A:
; H067+$0000079A: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
; STATO: H005+$3364 = testa della lista del party
L067_0000079E:
; H067+$0000079E: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L067_000007A6:
; H067+$000007A6: 13fc0001000024e3  move.b #$1, $24e3.l
        move.b #$1, (H005+$24E3).l
L067_000007AE:
; H067+$000007AE: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L067_000007B2:
; H067+$000007B2: 670000b4  beq.w $868
        beq.w H067+$868
L067_000007B6:
; H067+$000007B6: 7400  moveq #$0, d2
        moveq #0, d2
L067_000007B8:
; H067+$000007B8: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_000007BC:
; H067+$000007BC: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L067_000007C0:
; H067+$000007C0: 4a42  tst.w d2
        tst.w d2
L067_000007C2:
; H067+$000007C2: 67000014  beq.w $7d8
        beq.w H067+$7D8
L067_000007C6:
; H067+$000007C6: 7400  moveq #$0, d2
        moveq #0, d2
L067_000007C8:
; H067+$000007C8: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_000007CC:
; H067+$000007CC: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L067_000007D0:
; H067+$000007D0: 0c4200b3  cmpi.w #$b3, d2
        cmpi.w #$b3, d2
L067_000007D4:
; H067+$000007D4: 66000084  bne.w $85a
        bne.w H067+$85A
L067_000007D8:
; H067+$000007D8: 422dfff9  clr.b -$7(a5)
        clr.b -$7(a5)
L067_000007DC:
; H067+$000007DC: 0c2d0006fff9  cmpi.b #$6, -$7(a5)
        cmpi.b #$6, -$7(a5)
L067_000007E2:
; H067+$000007E2: 6200005e  bhi.w $842
        bhi.w H067+$842
L067_000007E6:
; H067+$000007E6: 7400  moveq #$0, d2
        moveq #0, d2
L067_000007E8:
; H067+$000007E8: 142dfff9  move.b -$7(a5), d2
        move.b -$7(a5), d2
L067_000007EC:
; H067+$000007EC: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_000007EE:
; H067+$000007EE: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_000007F4:
; H067+$000007F4: 7800  moveq #$0, d4
        moveq #0, d4
L067_000007F6:
; H067+$000007F6: 182dfff9  move.b -$7(a5), d4
        move.b -$7(a5), d4
L067_000007FA:
; H067+$000007FA: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_000007FC:
; H067+$000007FC: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L067_00000800:
; H067+$00000800: 45ea00f0  lea.l $f0(a2), a2
        lea.l $f0(a2), a2
L067_00000804:
; H067+$00000804: 7c00  moveq #$0, d6
        moveq #0, d6
L067_00000806:
; H067+$00000806: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L067_0000080A:
; H067+$0000080A: 7800  moveq #$0, d4
        moveq #0, d4
L067_0000080C:
; H067+$0000080C: 182dfff9  move.b -$7(a5), d4
        move.b -$7(a5), d4
L067_00000810:
; H067+$00000810: e544  asl.w #$2, d4
        asl.w #$2, d4
L067_00000812:
; H067+$00000812: 45f900002a1e  lea.l $2a1e.l, a2
        lea.l (H005+$2A1E).l, a2
L067_00000818:
; H067+$00000818: dcb24000  add.l (a2, d4.w), d6
        add.l (a2, d4.w), d6
L067_0000081C:
; H067+$0000081C: 27862000  move.l d6, (a3, d2.w)
        move.l d6, (a3, d2.w)
L067_00000820:
; H067+$00000820: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000824:
; H067+$00000824: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000826:
; H067+$00000826: 142dfff9  move.b -$7(a5), d2
        move.b -$7(a5), d2
L067_0000082A:
; H067+$0000082A: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_0000082C:
; H067+$0000082C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000830:
; H067+$00000830: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000834:
; H067+$00000834: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L067_00000838:
; H067+$00000838: 6100f9b8  bsr.w $1f2
        bsr.w H067+$1F2
L067_0000083C:
; H067+$0000083C: 522dfff9  addq.b #$1, -$7(a5)
        addq.b #$1, -$7(a5)
L067_00000840:
; H067+$00000840: 649a  bcc.b $7dc
        bcc.b H067+$7DC
L067_00000842:
; H067+$00000842: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_00000846:
; H067+$00000846: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_0000084A:
; H067+$0000084A: 486b00f0  pea.l $f0(a3)
        pea.l $f0(a3)
L067_0000084E:
; H067+$0000084E: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L067_00000852:
; H067+$00000852: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L067_00000854:
; H067+$00000854: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L067_0000085A:
; H067+$0000085A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_0000085E:
; H067+$0000085E: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L067_00000864:
; H067+$00000864: 6000ff48  bra.w $7ae
        bra.w H067+$7AE
L067_00000868:
; H067+$00000868: 4e5d  unlk a5
        unlk a5
L067_0000086A:
; H067+$0000086A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_0000086C:
; H067+$0000086C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_0000086E [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; opera su H005+$3364 (testa della lista del party).
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H067+$08E2
; --------------------------------------------------------------------------
L067_0000086E:
; H067+$0000086E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000870:
; H067+$00000870: 287af944  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000874:
; H067+$00000874: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
; STATO: H005+$3364 = testa della lista del party
L067_00000878:
; H067+$00000878: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L067_00000880:
; H067+$00000880: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L067_00000884:
; H067+$00000884: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L067_00000888:
; H067+$00000888: 67000034  beq.w $8be
        beq.w H067+$8BE
L067_0000088C:
; H067+$0000088C: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000088E:
; H067+$0000088E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000892:
; H067+$00000892: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L067_00000896:
; H067+$00000896: 4a42  tst.w d2
        tst.w d2
L067_00000898:
; H067+$00000898: 67000014  beq.w $8ae
        beq.w H067+$8AE
L067_0000089C:
; H067+$0000089C: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000089E:
; H067+$0000089E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_000008A2:
; H067+$000008A2: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L067_000008A6:
; H067+$000008A6: 0c4200b3  cmpi.w #$b3, d2
        cmpi.w #$b3, d2
L067_000008AA:
; H067+$000008AA: 66000006  bne.w $8b2
        bne.w H067+$8B2
L067_000008AE:
; H067+$000008AE: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L067_000008B2:
; H067+$000008B2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_000008B6:
; H067+$000008B6: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L067_000008BC:
; H067+$000008BC: 60c6  bra.b $884
        bra.b H067+$884
L067_000008BE:
; H067+$000008BE: 302dfffa  move.w -$6(a5), d0
        move.w -$6(a5), d0
L067_000008C2:
; H067+$000008C2: 60000002  bra.w $8c6
        bra.w H067+$8C6
L067_000008C6:
; H067+$000008C6: 4e5d  unlk a5
        unlk a5
L067_000008C8:
; H067+$000008C8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_000008CA:
; H067+$000008CA: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_000008CC [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H029+$0312.
;   - Richiama H029+$0312.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H072+$133E, H071+$0A72, H070+$133E
; --------------------------------------------------------------------------
L067_000008CC:
; H067+$000008CC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000008CE:
; H067+$000008CE: 287af8e6  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000008D2:
; H067+$000008D2: 4e55ffd4  link.w a5, #$ffd4
        link.w a5, #$ffd4
; STATO: H005+$3364 = testa della lista del party
L067_000008D6:
; H067+$000008D6: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L067_000008DE:
; H067+$000008DE: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L067_000008E2:
; H067+$000008E2: 618a  bsr.b $86e
        bsr.b H067+$86E
L067_000008E4:
; H067+$000008E4: 3b40fff6  move.w d0, -$a(a5)
        move.w d0, -$a(a5)
L067_000008E8:
; H067+$000008E8: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_000008EC:
; H067+$000008EC: 486dffe4  pea.l -$1c(a5)
        pea.l -$1c(a5)
L067_000008F0:
; H067+$000008F0: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L067_000008F4:
; H067+$000008F4: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L067_000008F6:
; H067+$000008F6: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L067_000008FC:
; H067+$000008FC: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_00000900:
; H067+$00000900: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L067_00000904:
; H067+$00000904: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L067_00000908:
; H067+$00000908: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L067_0000090A:
; H067+$0000090A: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L067_00000910:
; H067+$00000910: 422dffd5  clr.b -$2b(a5)
        clr.b -$2b(a5)
L067_00000914:
; H067+$00000914: 0c2d0006ffd5  cmpi.b #$6, -$2b(a5)
        cmpi.b #$6, -$2b(a5)
L067_0000091A:
; H067+$0000091A: 620000a0  bhi.w $9bc
        bhi.w H067+$9BC
L067_0000091E:
; H067+$0000091E: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000920:
; H067+$00000920: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000924:
; H067+$00000924: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000926:
; H067+$00000926: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_0000092C:
; H067+$0000092C: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_00000930:
; H067+$00000930: 4a44  tst.w d4
        tst.w d4
L067_00000932:
; H067+$00000932: 63000060  bls.w $994
        bls.w H067+$994
L067_00000936:
; H067+$00000936: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000938:
; H067+$00000938: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_0000093C:
; H067+$0000093C: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_0000093E:
; H067+$0000093E: 47edffe4  lea.l -$1c(a5), a3
        lea.l -$1c(a5), a3
L067_00000942:
; H067+$00000942: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000944:
; H067+$00000944: 182dffd5  move.b -$2b(a5), d4
        move.b -$2b(a5), d4
L067_00000948:
; H067+$00000948: e544  asl.w #$2, d4
        asl.w #$2, d4
L067_0000094A:
; H067+$0000094A: 45f900002a1e  lea.l $2a1e.l, a2
        lea.l (H005+$2A1E).l, a2
L067_00000950:
; H067+$00000950: 2c324000  move.l (a2, d4.w), d6
        move.l (a2, d4.w), d6
L067_00000954:
; H067+$00000954: 02860000ffff  andi.l #$ffff, d6
        andi.l #$ffff, d6
L067_0000095A:
; H067+$0000095A: 8cedfff6  divu.w -$a(a5), d6
        divu.w -$a(a5), d6
L067_0000095E:
; H067+$0000095E: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L067_00000962:
; H067+$00000962: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000964:
; H067+$00000964: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000968:
; H067+$00000968: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_0000096A:
; H067+$0000096A: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_0000096E:
; H067+$0000096E: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000970:
; H067+$00000970: 182dffd5  move.b -$2b(a5), d4
        move.b -$2b(a5), d4
L067_00000974:
; H067+$00000974: e544  asl.w #$2, d4
        asl.w #$2, d4
L067_00000976:
; H067+$00000976: 45f900002a1e  lea.l $2a1e.l, a2
        lea.l (H005+$2A1E).l, a2
L067_0000097C:
; H067+$0000097C: 2c324000  move.l (a2, d4.w), d6
        move.l (a2, d4.w), d6
L067_00000980:
; H067+$00000980: 02860000ffff  andi.l #$ffff, d6
        andi.l #$ffff, d6
L067_00000986:
; H067+$00000986: 8cedfff6  divu.w -$a(a5), d6
        divu.w -$a(a5), d6
L067_0000098A:
; H067+$0000098A: 4846  swap d6
        swap d6
L067_0000098C:
; H067+$0000098C: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L067_00000990:
; H067+$00000990: 60000022  bra.w $9b4
        bra.w H067+$9B4
L067_00000994:
; H067+$00000994: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000996:
; H067+$00000996: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_0000099A:
; H067+$0000099A: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_0000099C:
; H067+$0000099C: 47edffe4  lea.l -$1c(a5), a3
        lea.l -$1c(a5), a3
L067_000009A0:
; H067+$000009A0: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L067_000009A4:
; H067+$000009A4: 7400  moveq #$0, d2
        moveq #0, d2
L067_000009A6:
; H067+$000009A6: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_000009AA:
; H067+$000009AA: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_000009AC:
; H067+$000009AC: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_000009B0:
; H067+$000009B0: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L067_000009B4:
; H067+$000009B4: 522dffd5  addq.b #$1, -$2b(a5)
        addq.b #$1, -$2b(a5)
L067_000009B8:
; H067+$000009B8: 6400ff5a  bcc.w $914
        bcc.w H067+$914
L067_000009BC:
; H067+$000009BC: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L067_000009C0:
; H067+$000009C0: 67000150  beq.w $b12
        beq.w H067+$B12
L067_000009C4:
; H067+$000009C4: 7400  moveq #$0, d2
        moveq #0, d2
L067_000009C6:
; H067+$000009C6: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_000009CA:
; H067+$000009CA: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L067_000009CE:
; H067+$000009CE: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L067_000009D2:
; H067+$000009D2: 64000130  bcc.w $b04
        bcc.w H067+$B04
L067_000009D6:
; H067+$000009D6: 1b7c0006ffd5  move.b #$6, -$2b(a5)
        move.b #$6, -$2b(a5)
L067_000009DC:
; H067+$000009DC: 4a2dffd5  tst.b -$2b(a5)
        tst.b -$2b(a5)
L067_000009E0:
; H067+$000009E0: 65000122  bcs.w $b04
        bcs.w H067+$B04
L067_000009E4:
; H067+$000009E4: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_000009E8:
; H067+$000009E8: 7400  moveq #$0, d2
        moveq #0, d2
L067_000009EA:
; H067+$000009EA: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_000009EE:
; H067+$000009EE: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_000009F0:
; H067+$000009F0: 47edffe4  lea.l -$1c(a5), a3
        lea.l -$1c(a5), a3
L067_000009F4:
; H067+$000009F4: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L067_000009F8:
; H067+$000009F8: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
L067_000009FC:
; H067+$000009FC: 6100f834  bsr.w $232
        bsr.w H067+$232
L067_00000A00:
; H067+$00000A00: 1400  move.b d0, d2
        move.b d0, d2
L067_00000A02:
; H067+$00000A02: 4a02  tst.b d2
        tst.b d2
L067_00000A04:
; H067+$00000A04: 6600009e  bne.w $aa4
        bne.w H067+$AA4
L067_00000A08:
; H067+$00000A08: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000A0A:
; H067+$00000A0A: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000A0E:
; H067+$00000A0E: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000A10:
; H067+$00000A10: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000A14:
; H067+$00000A14: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000A18:
; H067+$00000A18: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000A1A:
; H067+$00000A1A: 182dffd5  move.b -$2b(a5), d4
        move.b -$2b(a5), d4
L067_00000A1E:
; H067+$00000A1E: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00000A20:
; H067+$00000A20: 45edffe4  lea.l -$1c(a5), a2
        lea.l -$1c(a5), a2
L067_00000A24:
; H067+$00000A24: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L067_00000A28:
; H067+$00000A28: dd732000  add.w d6, (a3, d2.w)
        add.w d6, (a3, d2.w)
L067_00000A2C:
; H067+$00000A2C: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000A30:
; H067+$00000A30: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000A32:
; H067+$00000A32: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000A36:
; H067+$00000A36: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000A38:
; H067+$00000A38: 47edffe4  lea.l -$1c(a5), a3
        lea.l -$1c(a5), a3
L067_00000A3C:
; H067+$00000A3C: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L067_00000A40:
; H067+$00000A40: 6100f7d0  bsr.w $212
        bsr.w H067+$212
L067_00000A44:
; H067+$00000A44: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000A46:
; H067+$00000A46: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000A4A:
; H067+$00000A4A: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000A4C:
; H067+$00000A4C: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000A50:
; H067+$00000A50: 4a732000  tst.w (a3, d2.w)
        tst.w (a3, d2.w)
L067_00000A54:
; H067+$00000A54: 6300004a  bls.w $aa0
        bls.w H067+$AA0
L067_00000A58:
; H067+$00000A58: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000A5C:
; H067+$00000A5C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00000A60:
; H067+$00000A60: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
L067_00000A64:
; H067+$00000A64: 6100f7cc  bsr.w $232
        bsr.w H067+$232
L067_00000A68:
; H067+$00000A68: 1400  move.b d0, d2
        move.b d0, d2
L067_00000A6A:
; H067+$00000A6A: 4a02  tst.b d2
        tst.b d2
L067_00000A6C:
; H067+$00000A6C: 66000032  bne.w $aa0
        bne.w H067+$AA0
L067_00000A70:
; H067+$00000A70: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000A72:
; H067+$00000A72: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000A76:
; H067+$00000A76: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000A78:
; H067+$00000A78: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000A7C:
; H067+$00000A7C: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000A80:
; H067+$00000A80: 52732000  addq.w #$1, (a3, d2.w)
        addq.w #$1, (a3, d2.w)
L067_00000A84:
; H067+$00000A84: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000A88:
; H067+$00000A88: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00000A8C:
; H067+$00000A8C: 6100f784  bsr.w $212
        bsr.w H067+$212
L067_00000A90:
; H067+$00000A90: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000A92:
; H067+$00000A92: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000A96:
; H067+$00000A96: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000A98:
; H067+$00000A98: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000A9C:
; H067+$00000A9C: 53732000  subq.w #$1, (a3, d2.w)
        subq.w #$1, (a3, d2.w)
L067_00000AA0:
; H067+$00000AA0: 6000005a  bra.w $afc
        bra.w H067+$AFC
L067_00000AA4:
; H067+$00000AA4: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000AA6:
; H067+$00000AA6: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000AAA:
; H067+$00000AAA: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000AAC:
; H067+$00000AAC: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000AB0:
; H067+$00000AB0: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000AB4:
; H067+$00000AB4: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L067_00000AB8:
; H067+$00000AB8: d9732000  add.w d4, (a3, d2.w)
        add.w d4, (a3, d2.w)
L067_00000ABC:
; H067+$00000ABC: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000ABE:
; H067+$00000ABE: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000AC2:
; H067+$00000AC2: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000AC4:
; H067+$00000AC4: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000AC8:
; H067+$00000AC8: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000ACA:
; H067+$00000ACA: 182dffd5  move.b -$2b(a5), d4
        move.b -$2b(a5), d4
L067_00000ACE:
; H067+$00000ACE: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00000AD0:
; H067+$00000AD0: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L067_00000AD4:
; H067+$00000AD4: 7c00  moveq #$0, d6
        moveq #0, d6
L067_00000AD6:
; H067+$00000AD6: 1c2dffd5  move.b -$2b(a5), d6
        move.b -$2b(a5), d6
L067_00000ADA:
; H067+$00000ADA: e346  asl.w #$1, d6
        asl.w #$1, d6
L067_00000ADC:
; H067+$00000ADC: 43edffe4  lea.l -$1c(a5), a1
        lea.l -$1c(a5), a1
L067_00000AE0:
; H067+$00000AE0: 36324000  move.w (a2, d4.w), d3
        move.w (a2, d4.w), d3
L067_00000AE4:
; H067+$00000AE4: d6716000  add.w (a1, d6.w), d3
        add.w (a1, d6.w), d3
L067_00000AE8:
; H067+$00000AE8: 966dfff2  sub.w -$e(a5), d3
        sub.w -$e(a5), d3
L067_00000AEC:
; H067+$00000AEC: 37832000  move.w d3, (a3, d2.w)
        move.w d3, (a3, d2.w)
L067_00000AF0:
; H067+$00000AF0: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000AF4:
; H067+$00000AF4: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L067_00000AF8:
; H067+$00000AF8: 6100f718  bsr.w $212
        bsr.w H067+$212
L067_00000AFC:
; H067+$00000AFC: 532dffd5  subq.b #$1, -$2b(a5)
        subq.b #$1, -$2b(a5)
L067_00000B00:
; H067+$00000B00: 6400feda  bcc.w $9dc
        bcc.w H067+$9DC
L067_00000B04:
; H067+$00000B04: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000B08:
; H067+$00000B08: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L067_00000B0E:
; H067+$00000B0E: 6000feac  bra.w $9bc
        bra.w H067+$9BC
L067_00000B12:
; H067+$00000B12: 1b7c0006ffd5  move.b #$6, -$2b(a5)
        move.b #$6, -$2b(a5)
L067_00000B18:
; H067+$00000B18: 4a2dffd5  tst.b -$2b(a5)
        tst.b -$2b(a5)
L067_00000B1C:
; H067+$00000B1C: 6500010a  bcs.w $c28
        bcs.w H067+$C28
L067_00000B20:
; H067+$00000B20: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000B22:
; H067+$00000B22: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000B26:
; H067+$00000B26: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000B28:
; H067+$00000B28: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000B2C:
; H067+$00000B2C: 4a732000  tst.w (a3, d2.w)
        tst.w (a3, d2.w)
L067_00000B30:
; H067+$00000B30: 630000ee  bls.w $c20
        bls.w H067+$C20
; STATO: H005+$3364 = testa della lista del party
L067_00000B34:
; H067+$00000B34: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L067_00000B3C:
; H067+$00000B3C: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L067_00000B40:
; H067+$00000B40: 670000de  beq.w $c20
        beq.w H067+$C20
L067_00000B44:
; H067+$00000B44: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000B48:
; H067+$00000B48: 6100f67e  bsr.w $1c8
        bsr.w H067+$1C8
L067_00000B4C:
; H067+$00000B4C: 3400  move.w d0, d2
        move.w d0, d2
L067_00000B4E:
; H067+$00000B4E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000B52:
; H067+$00000B52: 946b018c  sub.w $18c(a3), d2
        sub.w $18c(a3), d2
L067_00000B56:
; H067+$00000B56: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L067_00000B5A:
; H067+$00000B5A: 4a6dfff2  tst.w -$e(a5)
        tst.w -$e(a5)
L067_00000B5E:
; H067+$00000B5E: 630000b2  bls.w $c12
        bls.w H067+$C12
L067_00000B62:
; H067+$00000B62: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000B64:
; H067+$00000B64: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000B68:
; H067+$00000B68: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000B6A:
; H067+$00000B6A: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000B6E:
; H067+$00000B6E: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L067_00000B72:
; H067+$00000B72: b8732000  cmp.w (a3, d2.w), d4
        cmp.w (a3, d2.w), d4
L067_00000B76:
; H067+$00000B76: 6400004e  bcc.w $bc6
        bcc.w H067+$BC6
L067_00000B7A:
; H067+$00000B7A: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000B7C:
; H067+$00000B7C: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000B80:
; H067+$00000B80: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000B82:
; H067+$00000B82: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000B86:
; H067+$00000B86: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000B8A:
; H067+$00000B8A: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L067_00000B8E:
; H067+$00000B8E: d9732000  add.w d4, (a3, d2.w)
        add.w d4, (a3, d2.w)
L067_00000B92:
; H067+$00000B92: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000B96:
; H067+$00000B96: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L067_00000B9A:
; H067+$00000B9A: 6100f676  bsr.w $212
        bsr.w H067+$212
L067_00000B9E:
; H067+$00000B9E: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000BA0:
; H067+$00000BA0: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000BA4:
; H067+$00000BA4: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000BA6:
; H067+$00000BA6: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000BAA:
; H067+$00000BAA: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000BAC:
; H067+$00000BAC: 182dffd5  move.b -$2b(a5), d4
        move.b -$2b(a5), d4
L067_00000BB0:
; H067+$00000BB0: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00000BB2:
; H067+$00000BB2: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L067_00000BB6:
; H067+$00000BB6: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L067_00000BBA:
; H067+$00000BBA: 9c6dfff2  sub.w -$e(a5), d6
        sub.w -$e(a5), d6
L067_00000BBE:
; H067+$00000BBE: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L067_00000BC2:
; H067+$00000BC2: 6000004e  bra.w $c12
        bra.w H067+$C12
L067_00000BC6:
; H067+$00000BC6: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000BC8:
; H067+$00000BC8: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000BCC:
; H067+$00000BCC: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000BCE:
; H067+$00000BCE: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000BD2:
; H067+$00000BD2: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000BD6:
; H067+$00000BD6: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000BD8:
; H067+$00000BD8: 182dffd5  move.b -$2b(a5), d4
        move.b -$2b(a5), d4
L067_00000BDC:
; H067+$00000BDC: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00000BDE:
; H067+$00000BDE: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L067_00000BE2:
; H067+$00000BE2: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L067_00000BE6:
; H067+$00000BE6: dd732000  add.w d6, (a3, d2.w)
        add.w d6, (a3, d2.w)
L067_00000BEA:
; H067+$00000BEA: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L067_00000BEE:
; H067+$00000BEE: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000BF0:
; H067+$00000BF0: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000BF4:
; H067+$00000BF4: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000BF6:
; H067+$00000BF6: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000BFA:
; H067+$00000BFA: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L067_00000BFE:
; H067+$00000BFE: 6100f612  bsr.w $212
        bsr.w H067+$212
L067_00000C02:
; H067+$00000C02: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000C04:
; H067+$00000C04: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000C08:
; H067+$00000C08: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000C0A:
; H067+$00000C0A: 47edffd6  lea.l -$2a(a5), a3
        lea.l -$2a(a5), a3
L067_00000C0E:
; H067+$00000C0E: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L067_00000C12:
; H067+$00000C12: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L067_00000C16:
; H067+$00000C16: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L067_00000C1C:
; H067+$00000C1C: 6000ff1e  bra.w $b3c
        bra.w H067+$B3C
L067_00000C20:
; H067+$00000C20: 532dffd5  subq.b #$1, -$2b(a5)
        subq.b #$1, -$2b(a5)
L067_00000C24:
; H067+$00000C24: 6400fef2  bcc.w $b18
        bcc.w H067+$B18
L067_00000C28:
; H067+$00000C28: 4239000024e3  clr.b $24e3.l
        clr.b (H005+$24E3).l
L067_00000C2E:
; H067+$00000C2E: 422dffd5  clr.b -$2b(a5)
        clr.b -$2b(a5)
L067_00000C32:
; H067+$00000C32: 0c2d0006ffd5  cmpi.b #$6, -$2b(a5)
        cmpi.b #$6, -$2b(a5)
L067_00000C38:
; H067+$00000C38: 6200004c  bhi.w $c86
        bhi.w H067+$C86
L067_00000C3C:
; H067+$00000C3C: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000C3E:
; H067+$00000C3E: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000C42:
; H067+$00000C42: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000C44:
; H067+$00000C44: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00000C4A:
; H067+$00000C4A: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000C4C:
; H067+$00000C4C: 182dffd5  move.b -$2b(a5), d4
        move.b -$2b(a5), d4
L067_00000C50:
; H067+$00000C50: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00000C52:
; H067+$00000C52: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L067_00000C56:
; H067+$00000C56: 7c00  moveq #$0, d6
        moveq #0, d6
L067_00000C58:
; H067+$00000C58: 3c324000  move.w (a2, d4.w), d6
        move.w (a2, d4.w), d6
L067_00000C5C:
; H067+$00000C5C: 27862000  move.l d6, (a3, d2.w)
        move.l d6, (a3, d2.w)
L067_00000C60:
; H067+$00000C60: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000C62:
; H067+$00000C62: 142dffd5  move.b -$2b(a5), d2
        move.b -$2b(a5), d2
L067_00000C66:
; H067+$00000C66: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000C68:
; H067+$00000C68: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00000C6E:
; H067+$00000C6E: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_00000C72:
; H067+$00000C72: 4a44  tst.w d4
        tst.w d4
L067_00000C74:
; H067+$00000C74: 6700000a  beq.w $c80
        beq.w H067+$C80
L067_00000C78:
; H067+$00000C78: 13fc0001000024e3  move.b #$1, $24e3.l
        move.b #$1, (H005+$24E3).l
L067_00000C80:
; H067+$00000C80: 522dffd5  addq.b #$1, -$2b(a5)
        addq.b #$1, -$2b(a5)
L067_00000C84:
; H067+$00000C84: 64ac  bcc.b $c32
        bcc.b H067+$C32
L067_00000C86:
; H067+$00000C86: 4e5d  unlk a5
        unlk a5
L067_00000C88:
; H067+$00000C88: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00000C8A:
; H067+$00000C8A: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000C8C [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; opera su H005+$3DE3 (contesto nativo, 5 nel combattimento).
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H065+$190A
; --------------------------------------------------------------------------
L067_00000C8C:
; H067+$00000C8C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000C8E:
; H067+$00000C8E: 287af526  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000C92:
; H067+$00000C92: 4e550000  link.w a5, #$0
        link.w a5, #$0
L067_00000C96:
; H067+$00000C96: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000C98:
; H067+$00000C98: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_00000C9C:
; H067+$00000C9C: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000C9E:
; H067+$00000C9E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L067_00000CA2:
; H067+$00000CA2: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000CA6:
; H067+$00000CA6: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L067_00000CAA:
; H067+$00000CAA: 99732000  sub.w d4, (a3, d2.w)
        sub.w d4, (a3, d2.w)
L067_00000CAE:
; H067+$00000CAE: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L067_00000CB2:
; H067+$00000CB2: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L067_00000CB6:
; H067+$00000CB6: 6100f53a  bsr.w $1f2
        bsr.w H067+$1F2
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L067_00000CBA:
; H067+$00000CBA: 0c39000600003de3  cmpi.b #$6, $3de3.l
        cmpi.b #$6, (H005+$3DE3).l
L067_00000CC2:
; H067+$00000CC2: 6700000e  beq.w $cd2
        beq.w H067+$CD2
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L067_00000CC6:
; H067+$00000CC6: 0c39000100003de3  cmpi.b #$1, $3de3.l
        cmpi.b #$1, (H005+$3DE3).l
L067_00000CCE:
; H067+$00000CCE: 66000030  bne.w $d00
        bne.w H067+$D00
L067_00000CD2:
; H067+$00000CD2: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000CD4:
; H067+$00000CD4: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_00000CD8:
; H067+$00000CD8: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000CDA:
; H067+$00000CDA: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00000CE0:
; H067+$00000CE0: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000CE2:
; H067+$00000CE2: 182d000c  move.b $c(a5), d4
        move.b $c(a5), d4
L067_00000CE6:
; H067+$00000CE6: e544  asl.w #$2, d4
        asl.w #$2, d4
L067_00000CE8:
; H067+$00000CE8: 45f900002a1e  lea.l $2a1e.l, a2
        lea.l (H005+$2A1E).l, a2
L067_00000CEE:
; H067+$00000CEE: 2c324000  move.l (a2, d4.w), d6
        move.l (a2, d4.w), d6
L067_00000CF2:
; H067+$00000CF2: dc6d000e  add.w $e(a5), d6
        add.w $e(a5), d6
L067_00000CF6:
; H067+$00000CF6: 02860000ffff  andi.l #$ffff, d6
        andi.l #$ffff, d6
L067_00000CFC:
; H067+$00000CFC: 27862000  move.l d6, (a3, d2.w)
        move.l d6, (a3, d2.w)
L067_00000D00:
; H067+$00000D00: 4e5d  unlk a5
        unlk a5
L067_00000D02:
; H067+$00000D02: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00000D04:
; H067+$00000D04: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00000D06:
; H067+$00000D06: 508f  addq.l #$8, a7
        addq.l #$8, a7
L067_00000D08:
; H067+$00000D08: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000D0A [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H063+$1D44.
;   - Richiama H063+$1D44.
; Chiamanti diretti: H067+$1194
; --------------------------------------------------------------------------
L067_00000D0A:
; H067+$00000D0A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000D0C:
; H067+$00000D0C: 287af4a8  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000D10:
; H067+$00000D10: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L067_00000D14:
; H067+$00000D14: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L067_00000D18:
; H067+$00000D18: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L067_00000D1C:
; H067+$00000D1C: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L067_00000D20:
; H067+$00000D20: 6100f510  bsr.w $232
        bsr.w H067+$232
L067_00000D24:
; H067+$00000D24: 1400  move.b d0, d2
        move.b d0, d2
L067_00000D26:
; H067+$00000D26: 4a02  tst.b d2
        tst.b d2
L067_00000D28:
; H067+$00000D28: 67000014  beq.w $d3e
        beq.w H067+$D3E
L067_00000D2C:
; H067+$00000D2C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_00000D30:
; H067+$00000D30: 486c0035  pea.l $35(a4)
        pea.l $35(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L067_00000D34:
; H067+$00000D34: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L067_00000D3A:
; H067+$00000D3A: 60000084  bra.w $dc0
        bra.w H067+$DC0
L067_00000D3E:
; H067+$00000D3E: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000D40:
; H067+$00000D40: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_00000D44:
; H067+$00000D44: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000D46:
; H067+$00000D46: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00000D4C:
; H067+$00000D4C: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_00000D50:
; H067+$00000D50: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L067_00000D54:
; H067+$00000D54: b444  cmp.w d4, d2
        cmp.w d4, d2
L067_00000D56:
; H067+$00000D56: 63000018  bls.w $d70
        bls.w H067+$D70
L067_00000D5A:
; H067+$00000D5A: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000D5C:
; H067+$00000D5C: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_00000D60:
; H067+$00000D60: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000D62:
; H067+$00000D62: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00000D68:
; H067+$00000D68: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_00000D6C:
; H067+$00000D6C: 3b44000e  move.w d4, $e(a5)
        move.w d4, $e(a5)
L067_00000D70:
; H067+$00000D70: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000D72:
; H067+$00000D72: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_00000D76:
; H067+$00000D76: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000D78:
; H067+$00000D78: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00000D7E:
; H067+$00000D7E: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000D80:
; H067+$00000D80: 182d000c  move.b $c(a5), d4
        move.b $c(a5), d4
L067_00000D84:
; H067+$00000D84: e544  asl.w #$2, d4
        asl.w #$2, d4
L067_00000D86:
; H067+$00000D86: 45f900002a1e  lea.l $2a1e.l, a2
        lea.l (H005+$2A1E).l, a2
L067_00000D8C:
; H067+$00000D8C: 7c00  moveq #$0, d6
        moveq #0, d6
L067_00000D8E:
; H067+$00000D8E: 3c2d000e  move.w $e(a5), d6
        move.w $e(a5), d6
L067_00000D92:
; H067+$00000D92: 26324000  move.l (a2, d4.w), d3
        move.l (a2, d4.w), d3
L067_00000D96:
; H067+$00000D96: 9686  sub.l d6, d3
        sub.l d6, d3
L067_00000D98:
; H067+$00000D98: 27832000  move.l d3, (a3, d2.w)
        move.l d3, (a3, d2.w)
L067_00000D9C:
; H067+$00000D9C: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000D9E:
; H067+$00000D9E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L067_00000DA2:
; H067+$00000DA2: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00000DA4:
; H067+$00000DA4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L067_00000DA8:
; H067+$00000DA8: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L067_00000DAC:
; H067+$00000DAC: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L067_00000DB0:
; H067+$00000DB0: d9732000  add.w d4, (a3, d2.w)
        add.w d4, (a3, d2.w)
L067_00000DB4:
; H067+$00000DB4: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L067_00000DB8:
; H067+$00000DB8: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L067_00000DBC:
; H067+$00000DBC: 6100f454  bsr.w $212
        bsr.w H067+$212
L067_00000DC0:
; H067+$00000DC0: 4e5d  unlk a5
        unlk a5
L067_00000DC2:
; H067+$00000DC2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00000DC4:
; H067+$00000DC4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00000DC6:
; H067+$00000DC6: 508f  addq.l #$8, a7
        addq.l #$8, a7
L067_00000DC8:
; H067+$00000DC8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000DCA [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H026+$0188.
;   - Richiama H026+$0188.
; Chiamanti diretti: H065+$1872, H065+$154E, H067+$1128
; --------------------------------------------------------------------------
L067_00000DCA:
; H067+$00000DCA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000DCC:
; H067+$00000DCC: 287af3e8  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000DD0:
; H067+$00000DD0: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L067_00000DD4:
; H067+$00000DD4: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L067_00000DD8:
; H067+$00000DD8: 5242  addq.w #$1, d2
        addq.w #$1, d2
L067_00000DDA:
; H067+$00000DDA: 08020000  btst.b #$0, d2
        btst #$0, d2
L067_00000DDE:
; H067+$00000DDE: 6702  beq.b $de2
        beq.b H067+$DE2
L067_00000DE0:
; H067+$00000DE0: 5242  addq.w #$1, d2
        addq.w #$1, d2
L067_00000DE2:
; H067+$00000DE2: 9ec2  suba.w d2, a7
        suba.w d2, a7
L067_00000DE4:
; H067+$00000DE4: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L067_00000DE8:
; H067+$00000DE8: 2b4f0012  move.l a7, $12(a5)
        move.l a7, $12(a5)
L067_00000DEC:
; H067+$00000DEC: 244f  movea.l a7, a2
        movea.l a7, a2
L067_00000DEE:
; H067+$00000DEE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00000DF0:
; H067+$00000DF0: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00000DF2:
; H067+$00000DF2: 51cafffc  dbra d2, $df0
        dbra d2, H067+$DF0
L067_00000DF6:
; H067+$00000DF6: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L067_00000DFA:
; H067+$00000DFA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L067_00000DFE:
; H067+$00000DFE: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L067_00000E02:
; H067+$00000E02: 0c3300202000  cmpi.b #$20, (a3, d2.w)
        cmpi.b #$20, (a3, d2.w)
L067_00000E08:
; H067+$00000E08: 66000008  bne.w $e12
        bne.w H067+$E12
L067_00000E0C:
; H067+$00000E0C: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L067_00000E10:
; H067+$00000E10: 60e8  bra.b $dfa
        bra.b H067+$DFA
L067_00000E12:
; H067+$00000E12: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L067_00000E16:
; H067+$00000E16: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L067_00000E1A:
; H067+$00000E1A: 7800  moveq #$0, d4
        moveq #0, d4
L067_00000E1C:
; H067+$00000E1C: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L067_00000E20:
; H067+$00000E20: 60000122  bra.w $f44
        bra.w H067+$F44
L067_00000E24:
; H067+$00000E24: 1b7c0005fffd  move.b #$5, -$3(a5)
        move.b #$5, -$3(a5)
L067_00000E2A:
; H067+$00000E2A: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L067_00000E2E:
; H067+$00000E2E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_00000E32:
; H067+$00000E32: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_00000E36:
; H067+$00000E36: 486c0040  pea.l $40(a4)
        pea.l $40(a4)
; -> H026+$0188 (sub_H026_00000188)
L067_00000E3A:
; H067+$00000E3A: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00000E40:
; H067+$00000E40: 4e75  rts 
        rts 
L067_00000E42:
; H067+$00000E42: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L067_00000E46:
; H067+$00000E46: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_00000E4A:
; H067+$00000E4A: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L067_00000E4E:
; H067+$00000E4E: 486c0046  pea.l $46(a4)
        pea.l $46(a4)
; -> H026+$0188 (sub_H026_00000188)
L067_00000E52:
; H067+$00000E52: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00000E58:
; H067+$00000E58: 1b7c0003fffd  move.b #$3, -$3(a5)
        move.b #$3, -$3(a5)
L067_00000E5E:
; H067+$00000E5E: 4e75  rts 
        rts 
L067_00000E60:
; H067+$00000E60: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L067_00000E64:
; H067+$00000E64: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_00000E68:
; H067+$00000E68: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L067_00000E6C:
; H067+$00000E6C: 486c0050  pea.l $50(a4)
        pea.l $50(a4)
; -> H026+$0188 (sub_H026_00000188)
L067_00000E70:
; H067+$00000E70: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00000E76:
; H067+$00000E76: 1b7c0002fffd  move.b #$2, -$3(a5)
        move.b #$2, -$3(a5)
L067_00000E7C:
; H067+$00000E7C: 4e75  rts 
        rts 
L067_00000E7E:
; H067+$00000E7E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L067_00000E82:
; H067+$00000E82: 5242  addq.w #$1, d2
        addq.w #$1, d2
L067_00000E84:
; H067+$00000E84: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L067_00000E88:
; H067+$00000E88: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L067_00000E8C:
; H067+$00000E8C: 0c040061  cmpi.b #$61, d4
        cmpi.b #$61, d4
L067_00000E90:
; H067+$00000E90: 650a  bcs.b $e9c
        bcs.b H067+$E9C
L067_00000E92:
; H067+$00000E92: 0c04007a  cmpi.b #$7a, d4
        cmpi.b #$7a, d4
L067_00000E96:
; H067+$00000E96: 6204  bhi.b $e9c
        bhi.b H067+$E9C
L067_00000E98:
; H067+$00000E98: 0204005f  andi.b #$5f, d4
        andi.b #$5f, d4
L067_00000E9C:
; H067+$00000E9C: 0c040049  cmpi.b #$49, d4
        cmpi.b #$49, d4
L067_00000EA0:
; H067+$00000EA0: 66000020  bne.w $ec2
        bne.w H067+$EC2
L067_00000EA4:
; H067+$00000EA4: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L067_00000EA8:
; H067+$00000EA8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_00000EAC:
; H067+$00000EAC: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L067_00000EB0:
; H067+$00000EB0: 486c0058  pea.l $58(a4)
        pea.l $58(a4)
; -> H026+$0188 (sub_H026_00000188)
L067_00000EB4:
; H067+$00000EB4: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00000EBA:
; H067+$00000EBA: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L067_00000EBE:
; H067+$00000EBE: 6000001e  bra.w $ede
        bra.w H067+$EDE
L067_00000EC2:
; H067+$00000EC2: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L067_00000EC6:
; H067+$00000EC6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_00000ECA:
; H067+$00000ECA: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_00000ECE:
; H067+$00000ECE: 486c0060  pea.l $60(a4)
        pea.l $60(a4)
; -> H026+$0188 (sub_H026_00000188)
L067_00000ED2:
; H067+$00000ED2: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00000ED8:
; H067+$00000ED8: 1b7c0004fffd  move.b #$4, -$3(a5)
        move.b #$4, -$3(a5)
L067_00000EDE:
; H067+$00000EDE: 4e75  rts 
        rts 
L067_00000EE0:
; H067+$00000EE0: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L067_00000EE4:
; H067+$00000EE4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_00000EE8:
; H067+$00000EE8: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L067_00000EEC:
; H067+$00000EEC: 486c0067  pea.l $67(a4)
        pea.l $67(a4)
; -> H026+$0188 (sub_H026_00000188)
L067_00000EF0:
; H067+$00000EF0: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00000EF6:
; H067+$00000EF6: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L067_00000EFC:
; H067+$00000EFC: 4e75  rts 
        rts 
L067_00000EFE:
; H067+$00000EFE: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L067_00000F02:
; H067+$00000F02: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_00000F06:
; H067+$00000F06: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L067_00000F0A:
; H067+$00000F0A: 486c006f  pea.l $6f(a4)
        pea.l $6f(a4)
; -> H026+$0188 (sub_H026_00000188)
L067_00000F0E:
; H067+$00000F0E: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00000F14:
; H067+$00000F14: 1b7c0006fffd  move.b #$6, -$3(a5)
        move.b #$6, -$3(a5)
L067_00000F1A:
; H067+$00000F1A: 4e75  rts 
        rts 
L067_00000F1C:
; H067+$00000F1C: 4e75  rts 
        rts 
; Preserved bytes H067+$00000F1E..$00000F44; code/data not fully classified.
        dc.w $FFFC,$FF40,$FFC0,$FFFC,$FFFC,$FFFC,$FF04,$FFFC
        dc.w $FFFC,$FFDE,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FF22
        dc.w $FFFC,$FFFC,$FF5E
L067_00000F44:
; H067+$00000F44: 47faffda  lea.l $f20(pc), a3
        lea.l H067+$F20(pc), a3
L067_00000F48:
; H067+$00000F48: 04440042  subi.w #$42, d4
        subi.w #$42, d4
L067_00000F4C:
; H067+$00000F4C: 0c440011  cmpi.w #$11, d4
        cmpi.w #$11, d4
L067_00000F50:
; H067+$00000F50: 6302  bls.b $f54
        bls.b H067+$F54
L067_00000F52:
; H067+$00000F52: 78ff  moveq #$ff, d4
        moveq #-1, d4
L067_00000F54:
; H067+$00000F54: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00000F56:
; H067+$00000F56: 38334000  move.w (a3, d4.w), d4
        move.w (a3, d4.w), d4
; DISPATCH: word relative a H067+$0F20; indici 0..17, default -1.
L067_00000F5A:
; H067+$00000F5A: 4eb34000  jsr (a3, d4.w)
        jsr (a3, d4.w)
L067_00000F5E:
; H067+$00000F5E: 102dfffd  move.b -$3(a5), d0
        move.b -$3(a5), d0
L067_00000F62:
; H067+$00000F62: 60000002  bra.w $f66
        bra.w H067+$F66
L067_00000F66:
; H067+$00000F66: 4e5d  unlk a5
        unlk a5
L067_00000F68:
; H067+$00000F68: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00000F6A:
; H067+$00000F6A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00000F6C:
; H067+$00000F6C: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L067_00000F70:
; H067+$00000F70: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00000F72 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H044+$01C2, H003+$0068, H045+$01D6, H026+$0188.
;   - Richiama H044+$01C2.
;   - Richiama H003+$0068.
;   - Richiama H045+$01D6.
;   - Richiama H026+$0188.
;   - Richiama H026+$01E0.
;   - Richiama H008+$13C0.
;   - Richiama H026+$0254.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H072+$1318, H071+$0A4C, H070+$1118, H070+$0FE8
; --------------------------------------------------------------------------
L067_00000F72:
; H067+$00000F72: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00000F74:
; H067+$00000F74: 287af240  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00000F78:
; H067+$00000F78: 4e55ff92  link.w a5, #$ff92
        link.w a5, #$ff92
L067_00000F7C:
; H067+$00000F7C: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L067_00000F7E:
; H067+$00000F7E: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
L067_00000F84:
; H067+$00000F84: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L067_00000F88:
; H067+$00000F88: 1b7c0001ff94  move.b #$1, -$6c(a5)
        move.b #$1, -$6c(a5)
L067_00000F8E:
; H067+$00000F8E: 42adfff6  clr.l -$a(a5)
        clr.l -$a(a5)
L067_00000F92:
; H067+$00000F92: 42adfff2  clr.l -$e(a5)
        clr.l -$e(a5)
L067_00000F96:
; H067+$00000F96: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L067_00000F9A:
; H067+$00000F9A: 0c2d0006ffff  cmpi.b #$6, -$1(a5)
        cmpi.b #$6, -$1(a5)
L067_00000FA0:
; H067+$00000FA0: 620000fa  bhi.w $109c
        bhi.w H067+$109C
L067_00000FA4:
; H067+$00000FA4: 7400  moveq #$0, d2
        moveq #0, d2
L067_00000FA6:
; H067+$00000FA6: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L067_00000FAA:
; H067+$00000FAA: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00000FAC:
; H067+$00000FAC: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00000FB2:
; H067+$00000FB2: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_00000FB6:
; H067+$00000FB6: 4a44  tst.w d4
        tst.w d4
L067_00000FB8:
; H067+$00000FB8: 630000da  bls.w $1094
        bls.w H067+$1094
L067_00000FBC:
; H067+$00000FBC: 526dffec  addq.w #$1, -$14(a5)
        addq.w #$1, -$14(a5)
L067_00000FC0:
; H067+$00000FC0: 4aadfff6  tst.l -$a(a5)
        tst.l -$a(a5)
L067_00000FC4:
; H067+$00000FC4: 66000022  bne.w $fe8
        bne.w H067+$FE8
L067_00000FC8:
; H067+$00000FC8: 7430  moveq #$30, d2
        moveq #48, d2
L067_00000FCA:
; H067+$00000FCA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_00000FCC:
; H067+$00000FCC: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L067_00000FD2:
; H067+$00000FD2: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L067_00000FD8:
; H067+$00000FD8: 2b40fff6  move.l d0, -$a(a5)
        move.l d0, -$a(a5)
L067_00000FDC:
; H067+$00000FDC: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L067_00000FE0:
; H067+$00000FE0: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L067_00000FE4:
; H067+$00000FE4: 60000026  bra.w $100c
        bra.w H067+$100C
L067_00000FE8:
; H067+$00000FE8: 2b6dfff6fff2  move.l -$a(a5), -$e(a5)
        move.l -$a(a5), -$e(a5)
L067_00000FEE:
; H067+$00000FEE: 7430  moveq #$30, d2
        moveq #48, d2
L067_00000FF0:
; H067+$00000FF0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_00000FF2:
; H067+$00000FF2: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L067_00000FF8:
; H067+$00000FF8: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L067_00000FFE:
; H067+$00000FFE: 2b40fff6  move.l d0, -$a(a5)
        move.l d0, -$a(a5)
L067_00001002:
; H067+$00001002: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L067_00001006:
; H067+$00001006: 276dfff2002c  move.l -$e(a5), $2c(a3)
        move.l -$e(a5), $2c(a3)
L067_0000100C:
; H067+$0000100C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L067_00001010:
; H067+$00001010: 486dff98  pea.l -$68(a5)
        pea.l -$68(a5)
L067_00001014:
; H067+$00001014: 7400  moveq #$0, d2
        moveq #0, d2
L067_00001016:
; H067+$00001016: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L067_0000101A:
; H067+$0000101A: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_0000101C:
; H067+$0000101C: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00001022:
; H067+$00001022: 2f332000  move.l (a3, d2.w), -(a7)
        move.l (a3, d2.w), -(a7)
L067_00001026:
; H067+$00001026: 4227  clr.b -(a7)
        clr.b -(a7)
L067_00001028:
; H067+$00001028: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_0000102C:
; H067+$0000102C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_00001030:
; H067+$00001030: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L067_00001034:
; H067+$00001034: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L067_0000103A:
; H067+$0000103A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_0000103E:
; H067+$0000103E: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L067_00001042:
; H067+$00001042: 7400  moveq #$0, d2
        moveq #0, d2
L067_00001044:
; H067+$00001044: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L067_00001048:
; H067+$00001048: c5fc000c  muls.w #$c, d2
        muls.w #$c, d2
L067_0000104C:
; H067+$0000104C: 47f900004b7e  lea.l $4b7e.l, a3
        lea.l (H005+$4B7E).l, a3
L067_00001052:
; H067+$00001052: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_00001056:
; H067+$00001056: 48732800  pea.l (a3, d2.l)
        pea.l (a3, d2.l)
; -> H026+$0188 (sub_H026_00000188)
L067_0000105A:
; H067+$0000105A: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L067_00001060:
; H067+$00001060: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001064:
; H067+$00001064: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L067_00001068:
; H067+$00001068: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_0000106C:
; H067+$0000106C: 486c0078  pea.l $78(a4)
        pea.l $78(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001070:
; H067+$00001070: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00001076:
; H067+$00001076: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_0000107A:
; H067+$0000107A: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L067_0000107E:
; H067+$0000107E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L067_00001082:
; H067+$00001082: 486dff98  pea.l -$68(a5)
        pea.l -$68(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001086:
; H067+$00001086: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_0000108C:
; H067+$0000108C: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L067_00001090:
; H067+$00001090: 422b002a  clr.b $2a(a3)
        clr.b $2a(a3)
L067_00001094:
; H067+$00001094: 522dffff  addq.b #$1, -$1(a5)
        addq.b #$1, -$1(a5)
L067_00001098:
; H067+$00001098: 6400ff00  bcc.w $f9a
        bcc.w H067+$F9A
L067_0000109C:
; H067+$0000109C: 2b6dfff6fff2  move.l -$a(a5), -$e(a5)
        move.l -$a(a5), -$e(a5)
L067_000010A2:
; H067+$000010A2: 2b6dfff6ffee  move.l -$a(a5), -$12(a5)
        move.l -$a(a5), -$12(a5)
L067_000010A8:
; H067+$000010A8: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L067_000010B0:
; H067+$000010B0: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L067_000010B4:
; H067+$000010B4: 486c007a  pea.l $7a(a4)
        pea.l $7a(a4)
L067_000010B8:
; H067+$000010B8: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L067_000010BC:
; H067+$000010BC: 486c008f  pea.l $8f(a4)
        pea.l $8f(a4)
L067_000010C0:
; H067+$000010C0: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_000010C4:
; H067+$000010C4: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_000010C8:
; H067+$000010C8: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_000010CC:
; H067+$000010CC: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L067_000010D0:
; H067+$000010D0: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L067_000010D4:
; H067+$000010D4: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_000010D8:
; H067+$000010D8: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L067_000010DC:
; H067+$000010DC: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L067_000010E0:
; H067+$000010E0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L067_000010E4:
; H067+$000010E4: 486dff94  pea.l -$6c(a5)
        pea.l -$6c(a5)
L067_000010E8:
; H067+$000010E8: 486dffea  pea.l -$16(a5)
        pea.l -$16(a5)
L067_000010EC:
; H067+$000010EC: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
; -> H008+$13C0 (trampoline_H008_1AF4)
L067_000010F0:
; H067+$000010F0: 4eb9000013c0  jsr $13c0.l
        jsr (H008+$13C0).l
L067_000010F6:
; H067+$000010F6: 1b40ff93  move.b d0, -$6d(a5)
        move.b d0, -$6d(a5)
L067_000010FA:
; H067+$000010FA: 4aadfff2  tst.l -$e(a5)
        tst.l -$e(a5)
L067_000010FE:
; H067+$000010FE: 6700000a  beq.w $110a
        beq.w H067+$110A
L067_00001102:
; H067+$00001102: 4a2dff93  tst.b -$6d(a5)
        tst.b -$6d(a5)
L067_00001106:
; H067+$00001106: 6600000c  bne.w $1114
        bne.w H067+$1114
L067_0000110A:
; H067+$0000110A: 1b7c0001ff95  move.b #$1, -$6b(a5)
        move.b #$1, -$6b(a5)
L067_00001110:
; H067+$00001110: 600000d4  bra.w $11e6
        bra.w H067+$11E6
L067_00001114:
; H067+$00001114: 422dff95  clr.b -$6b(a5)
        clr.b -$6b(a5)
L067_00001118:
; H067+$00001118: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_0000111C:
; H067+$0000111C: 2f2dfff2  move.l -$e(a5), -(a7)
        move.l -$e(a5), -(a7)
L067_00001120:
; H067+$00001120: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L067_00001124:
; H067+$00001124: 486dff98  pea.l -$68(a5)
        pea.l -$68(a5)
L067_00001128:
; H067+$00001128: 6100fca0  bsr.w $dca
        bsr.w H067+$DCA
L067_0000112C:
; H067+$0000112C: 1b40fffe  move.b d0, -$2(a5)
        move.b d0, -$2(a5)
L067_00001130:
; H067+$00001130: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L067_00001134:
; H067+$00001134: 486dff98  pea.l -$68(a5)
        pea.l -$68(a5)
L067_00001138:
; H067+$00001138: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L067_0000113C:
; H067+$0000113C: 486c0096  pea.l $96(a4)
        pea.l $96(a4)
L067_00001140:
; H067+$00001140: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H026+$0254 (sub_H026_00000254)
L067_00001142:
; H067+$00001142: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L067_00001148:
; H067+$00001148: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L067_0000114C:
; H067+$0000114C: 486dff98  pea.l -$68(a5)
        pea.l -$68(a5)
L067_00001150:
; H067+$00001150: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L067_00001154:
; H067+$00001154: 486c00a0  pea.l $a0(a4)
        pea.l $a0(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001158:
; H067+$00001158: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_0000115E:
; H067+$0000115E: 7400  moveq #$0, d2
        moveq #0, d2
L067_00001160:
; H067+$00001160: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L067_00001164:
; H067+$00001164: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00001166:
; H067+$00001166: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_0000116C:
; H067+$0000116C: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_00001170:
; H067+$00001170: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L067_00001172:
; H067+$00001172: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L067_00001176:
; H067+$00001176: 486dff98  pea.l -$68(a5)
        pea.l -$68(a5)
L067_0000117A:
; H067+$0000117A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_0000117E:
; H067+$0000117E: 6100f2ce  bsr.w $44e
        bsr.w H067+$44E
L067_00001182:
; H067+$00001182: 3b40ff96  move.w d0, -$6a(a5)
        move.w d0, -$6a(a5)
; STATO: H005+$3368 = personaggio corrente
L067_00001186:
; H067+$00001186: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L067_0000118C:
; H067+$0000118C: 3f2dff96  move.w -$6a(a5), -(a7)
        move.w -$6a(a5), -(a7)
L067_00001190:
; H067+$00001190: 1f2dfffe  move.b -$2(a5), -(a7)
        move.b -$2(a5), -(a7)
L067_00001194:
; H067+$00001194: 6100fb74  bsr.w $d0a
        bsr.w H067+$D0A
L067_00001198:
; H067+$00001198: 486dffee  pea.l -$12(a5)
        pea.l -$12(a5)
; -> H008+$2178 (sub_H008_00002178)
L067_0000119C:
; H067+$0000119C: 4eb900002178  jsr $2178.l
        jsr (H008+$2178).l
L067_000011A2:
; H067+$000011A2: 4239000024e3  clr.b $24e3.l
        clr.b (H005+$24E3).l
L067_000011A8:
; H067+$000011A8: 1b7c0001ff95  move.b #$1, -$6b(a5)
        move.b #$1, -$6b(a5)
L067_000011AE:
; H067+$000011AE: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L067_000011B2:
; H067+$000011B2: 0c2d0006ffff  cmpi.b #$6, -$1(a5)
        cmpi.b #$6, -$1(a5)
L067_000011B8:
; H067+$000011B8: 6200002c  bhi.w $11e6
        bhi.w H067+$11E6
L067_000011BC:
; H067+$000011BC: 7400  moveq #$0, d2
        moveq #0, d2
L067_000011BE:
; H067+$000011BE: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L067_000011C2:
; H067+$000011C2: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_000011C4:
; H067+$000011C4: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_000011CA:
; H067+$000011CA: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_000011CE:
; H067+$000011CE: 4a44  tst.w d4
        tst.w d4
L067_000011D0:
; H067+$000011D0: 6300000e  bls.w $11e0
        bls.w H067+$11E0
L067_000011D4:
; H067+$000011D4: 13fc0001000024e3  move.b #$1, $24e3.l
        move.b #$1, (H005+$24E3).l
L067_000011DC:
; H067+$000011DC: 422dff95  clr.b -$6b(a5)
        clr.b -$6b(a5)
L067_000011E0:
; H067+$000011E0: 522dffff  addq.b #$1, -$1(a5)
        addq.b #$1, -$1(a5)
L067_000011E4:
; H067+$000011E4: 64cc  bcc.b $11b2
        bcc.b H067+$11B2
L067_000011E6:
; H067+$000011E6: 4a2dff95  tst.b -$6b(a5)
        tst.b -$6b(a5)
L067_000011EA:
; H067+$000011EA: 6700fd9c  beq.w $f88
        beq.w H067+$F88
L067_000011EE:
; H067+$000011EE: 4e5d  unlk a5
        unlk a5
L067_000011F0:
; H067+$000011F0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_000011F2:
; H067+$000011F2: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_000011F4 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H072+$1286, H071+$09C2, H072+$135A, H071+$0A8E, H070+$1164, H070+$1362 e altri 1
; --------------------------------------------------------------------------
L067_000011F4:
; H067+$000011F4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_000011F6:
; H067+$000011F6: 287aefbe  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_000011FA:
; H067+$000011FA: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L067_000011FE:
; H067+$000011FE: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L067_00001202:
; H067+$00001202: 4213  clr.b (a3)
        clr.b (a3)
L067_00001204:
; H067+$00001204: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_00001208:
; H067+$00001208: 4213  clr.b (a3)
        clr.b (a3)
L067_0000120A:
; H067+$0000120A: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L067_0000120E:
; H067+$0000120E: 0c2d0006ffff  cmpi.b #$6, -$1(a5)
        cmpi.b #$6, -$1(a5)
L067_00001214:
; H067+$00001214: 62000028  bhi.w $123e
        bhi.w H067+$123E
L067_00001218:
; H067+$00001218: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000121A:
; H067+$0000121A: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L067_0000121E:
; H067+$0000121E: e542  asl.w #$2, d2
        asl.w #$2, d2
L067_00001220:
; H067+$00001220: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L067_00001226:
; H067+$00001226: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L067_0000122A:
; H067+$0000122A: 4a44  tst.w d4
        tst.w d4
L067_0000122C:
; H067+$0000122C: 6700000a  beq.w $1238
        beq.w H067+$1238
L067_00001230:
; H067+$00001230: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L067_00001234:
; H067+$00001234: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L067_00001238:
; H067+$00001238: 522dffff  addq.b #$1, -$1(a5)
        addq.b #$1, -$1(a5)
L067_0000123C:
; H067+$0000123C: 64d0  bcc.b $120e
        bcc.b H067+$120E
L067_0000123E:
; H067+$0000123E: 4ab900002a3a  tst.l $2a3a.l
        tst.l (H005+$2A3A).l
L067_00001244:
; H067+$00001244: 6700000a  beq.w $1250
        beq.w H067+$1250
L067_00001248:
; H067+$00001248: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_0000124C:
; H067+$0000124C: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L067_00001250:
; H067+$00001250: 4e5d  unlk a5
        unlk a5
L067_00001252:
; H067+$00001252: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00001254:
; H067+$00001254: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00001256:
; H067+$00001256: 508f  addq.l #$8, a7
        addq.l #$8, a7
L067_00001258:
; H067+$00001258: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_0000125A [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H062+$156C.
;   - Richiama H062+$156C.
; Chiamanti diretti: H067+$1450
; --------------------------------------------------------------------------
L067_0000125A:
; H067+$0000125A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_0000125C:
; H067+$0000125C: 287aef58  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00001260:
; H067+$00001260: 4e550000  link.w a5, #$0
        link.w a5, #$0
L067_00001264:
; H067+$00001264: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001268:
; H067+$00001268: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_0000126C:
; H067+$0000126C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001272:
; H067+$00001272: 3400  move.w d0, d2
        move.w d0, d2
L067_00001274:
; H067+$00001274: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L067_00001278:
; H067+$00001278: 6400000c  bcc.w $1286
        bcc.w H067+$1286
L067_0000127C:
; H067+$0000127C: 7001  moveq #$1, d0
        moveq #1, d0
L067_0000127E:
; H067+$0000127E: 6000000c  bra.w $128c
        bra.w H067+$128C
; Preserved bytes H067+$00001282..$00001286; code/data not fully classified.
        dc.w $6000,$0008
L067_00001286:
; H067+$00001286: 7002  moveq #$2, d0
        moveq #2, d0
L067_00001288:
; H067+$00001288: 60000002  bra.w $128c
        bra.w H067+$128C
L067_0000128C:
; H067+$0000128C: 4e5d  unlk a5
        unlk a5
L067_0000128E:
; H067+$0000128E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00001290:
; H067+$00001290: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00001292 [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H029+$0312, H062+$156C, H029+$039A.
;   - Richiama H029+$0312.
;   - Richiama H062+$156C.
;   - Richiama H029+$039A.
; Chiamanti diretti: H012+$1402
; --------------------------------------------------------------------------
L067_00001292:
; H067+$00001292: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00001294:
; H067+$00001294: 287aef20  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00001298:
; H067+$00001298: 4e55ff84  link.w a5, #$ff84
        link.w a5, #$ff84
L067_0000129C:
; H067+$0000129C: 3b7c005fff84  move.w #$5f, -$7c(a5)
        move.w #$5f, -$7c(a5)
L067_000012A2:
; H067+$000012A2: 3b7c005eff86  move.w #$5e, -$7a(a5)
        move.w #$5e, -$7a(a5)
L067_000012A8:
; H067+$000012A8: 3b7c0035ff88  move.w #$35, -$78(a5)
        move.w #$35, -$78(a5)
L067_000012AE:
; H067+$000012AE: 3b7c0001ff8a  move.w #$1, -$76(a5)
        move.w #$1, -$76(a5)
L067_000012B4:
; H067+$000012B4: 3b7c0190ff8c  move.w #$190, -$74(a5)
        move.w #$190, -$74(a5)
L067_000012BA:
; H067+$000012BA: 3b7c0003ff8e  move.w #$3, -$72(a5)
        move.w #$3, -$72(a5)
L067_000012C0:
; H067+$000012C0: 3b7c0063ff90  move.w #$63, -$70(a5)
        move.w #$63, -$70(a5)
L067_000012C6:
; H067+$000012C6: 426dff92  clr.w -$6e(a5)
        clr.w -$6e(a5)
L067_000012CA:
; H067+$000012CA: 3b7c0050ff94  move.w #$50, -$6c(a5)
        move.w #$50, -$6c(a5)
L067_000012D0:
; H067+$000012D0: 3b7c005aff96  move.w #$5a, -$6a(a5)
        move.w #$5a, -$6a(a5)
L067_000012D6:
; H067+$000012D6: 3b7c0035ff98  move.w #$35, -$68(a5)
        move.w #$35, -$68(a5)
L067_000012DC:
; H067+$000012DC: 3b7c0001ff9a  move.w #$1, -$66(a5)
        move.w #$1, -$66(a5)
L067_000012E2:
; H067+$000012E2: 3b7c0226ff9c  move.w #$226, -$64(a5)
        move.w #$226, -$64(a5)
L067_000012E8:
; H067+$000012E8: 3b7c0001ff9e  move.w #$1, -$62(a5)
        move.w #$1, -$62(a5)
L067_000012EE:
; H067+$000012EE: 3b7c003bffa0  move.w #$3b, -$60(a5)
        move.w #$3b, -$60(a5)
L067_000012F4:
; H067+$000012F4: 426dffa2  clr.w -$5e(a5)
        clr.w -$5e(a5)
L067_000012F8:
; H067+$000012F8: 3b7c005fffa4  move.w #$5f, -$5c(a5)
        move.w #$5f, -$5c(a5)
L067_000012FE:
; H067+$000012FE: 3b7c005affa6  move.w #$5a, -$5a(a5)
        move.w #$5a, -$5a(a5)
L067_00001304:
; H067+$00001304: 3b7c0035ffa8  move.w #$35, -$58(a5)
        move.w #$35, -$58(a5)
L067_0000130A:
; H067+$0000130A: 3b7c0001ffaa  move.w #$1, -$56(a5)
        move.w #$1, -$56(a5)
L067_00001310:
; H067+$00001310: 3b7c00c8ffac  move.w #$c8, -$54(a5)
        move.w #$c8, -$54(a5)
L067_00001316:
; H067+$00001316: 3b7c0001ffae  move.w #$1, -$52(a5)
        move.w #$1, -$52(a5)
L067_0000131C:
; H067+$0000131C: 3b7c0003ffb0  move.w #$3, -$50(a5)
        move.w #$3, -$50(a5)
L067_00001322:
; H067+$00001322: 426dffb2  clr.w -$4e(a5)
        clr.w -$4e(a5)
L067_00001326:
; H067+$00001326: 3b7c005cffb4  move.w #$5c, -$4c(a5)
        move.w #$5c, -$4c(a5)
L067_0000132C:
; H067+$0000132C: 3b7c005affb6  move.w #$5a, -$4a(a5)
        move.w #$5a, -$4a(a5)
L067_00001332:
; H067+$00001332: 3b7c0035ffb8  move.w #$35, -$48(a5)
        move.w #$35, -$48(a5)
L067_00001338:
; H067+$00001338: 3b7c0001ffba  move.w #$1, -$46(a5)
        move.w #$1, -$46(a5)
L067_0000133E:
; H067+$0000133E: 3b7c00e1ffbc  move.w #$e1, -$44(a5)
        move.w #$e1, -$44(a5)
L067_00001344:
; H067+$00001344: 3b7c0001ffbe  move.w #$1, -$42(a5)
        move.w #$1, -$42(a5)
L067_0000134A:
; H067+$0000134A: 3b7c0030ffc0  move.w #$30, -$40(a5)
        move.w #$30, -$40(a5)
L067_00001350:
; H067+$00001350: 426dffc2  clr.w -$3e(a5)
        clr.w -$3e(a5)
L067_00001354:
; H067+$00001354: 3b7c0062ffc4  move.w #$62, -$3c(a5)
        move.w #$62, -$3c(a5)
L067_0000135A:
; H067+$0000135A: 3b7c005affc6  move.w #$5a, -$3a(a5)
        move.w #$5a, -$3a(a5)
L067_00001360:
; H067+$00001360: 3b7c0033ffc8  move.w #$33, -$38(a5)
        move.w #$33, -$38(a5)
L067_00001366:
; H067+$00001366: 3b7c0001ffca  move.w #$1, -$36(a5)
        move.w #$1, -$36(a5)
L067_0000136C:
; H067+$0000136C: 3b7c157cffcc  move.w #$157c, -$34(a5)
        move.w #$157c, -$34(a5)
L067_00001372:
; H067+$00001372: 3b7c001effce  move.w #$1e, -$32(a5)
        move.w #$1e, -$32(a5)
L067_00001378:
; H067+$00001378: 3b7c0041ffd0  move.w #$41, -$30(a5)
        move.w #$41, -$30(a5)
L067_0000137E:
; H067+$0000137E: 426dffd2  clr.w -$2e(a5)
        clr.w -$2e(a5)
L067_00001382:
; H067+$00001382: 3b7c004effd4  move.w #$4e, -$2c(a5)
        move.w #$4e, -$2c(a5)
L067_00001388:
; H067+$00001388: 3b7c005affd6  move.w #$5a, -$2a(a5)
        move.w #$5a, -$2a(a5)
L067_0000138E:
; H067+$0000138E: 3b7c0048ffd8  move.w #$48, -$28(a5)
        move.w #$48, -$28(a5)
L067_00001394:
; H067+$00001394: 3b7c000affda  move.w #$a, -$26(a5)
        move.w #$a, -$26(a5)
L067_0000139A:
; H067+$0000139A: 3b7c1d4cffdc  move.w #$1d4c, -$24(a5)
        move.w #$1d4c, -$24(a5)
L067_000013A0:
; H067+$000013A0: 426dffde  clr.w -$22(a5)
        clr.w -$22(a5)
L067_000013A4:
; H067+$000013A4: 3b7c0026ffe0  move.w #$26, -$20(a5)
        move.w #$26, -$20(a5)
L067_000013AA:
; H067+$000013AA: 3b7c0083ffe2  move.w #$83, -$1e(a5)
        move.w #$83, -$1e(a5)
L067_000013B0:
; H067+$000013B0: 3b7c0058ffe4  move.w #$58, -$1c(a5)
        move.w #$58, -$1c(a5)
L067_000013B6:
; H067+$000013B6: 3b7c005affe6  move.w #$5a, -$1a(a5)
        move.w #$5a, -$1a(a5)
L067_000013BC:
; H067+$000013BC: 3b7c0007ffe8  move.w #$7, -$18(a5)
        move.w #$7, -$18(a5)
L067_000013C2:
; H067+$000013C2: 3b7c0014ffea  move.w #$14, -$16(a5)
        move.w #$14, -$16(a5)
L067_000013C8:
; H067+$000013C8: 3b7c05dcffec  move.w #$5dc, -$14(a5)
        move.w #$5dc, -$14(a5)
L067_000013CE:
; H067+$000013CE: 3b7c0001ffee  move.w #$1, -$12(a5)
        move.w #$1, -$12(a5)
L067_000013D4:
; H067+$000013D4: 3b7c0033fff0  move.w #$33, -$10(a5)
        move.w #$33, -$10(a5)
L067_000013DA:
; H067+$000013DA: 426dfff2  clr.w -$e(a5)
        clr.w -$e(a5)
L067_000013DE:
; H067+$000013DE: 3f3c0047  move.w #$47, -(a7)
        move.w #$47, -(a7)
L067_000013E2:
; H067+$000013E2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L067_000013E6:
; H067+$000013E6: 3f3c0047  move.w #$47, -(a7)
        move.w #$47, -(a7)
L067_000013EA:
; H067+$000013EA: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L067_000013EC:
; H067+$000013EC: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L067_000013F2:
; H067+$000013F2: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L067_000013F6:
; H067+$000013F6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_000013FA:
; H067+$000013FA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_000013FC:
; H067+$000013FC: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L067_00001400:
; H067+$00001400: 486b0044  pea.l $44(a3)
        pea.l $44(a3)
L067_00001404:
; H067+$00001404: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L067_00001408:
; H067+$00001408: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L067_0000140A:
; H067+$0000140A: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L067_00001410:
; H067+$00001410: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001412:
; H067+$00001412: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L067_00001416:
; H067+$00001416: 422b003a  clr.b $3a(a3)
        clr.b $3a(a3)
L067_0000141A:
; H067+$0000141A: 177c0006003b  move.b #$6, $3b(a3)
        move.b #$6, $3b(a3)
L067_00001420:
; H067+$00001420: 422b003c  clr.b $3c(a3)
        clr.b $3c(a3)
L067_00001424:
; H067+$00001424: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L067_00001428:
; H067+$00001428: 17420030  move.b d2, $30(a3)
        move.b d2, $30(a3)
L067_0000142C:
; H067+$0000142C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_0000142E:
; H067+$0000142E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L067_00001432:
; H067+$00001432: 486b0032  pea.l $32(a3)
        pea.l $32(a3)
L067_00001436:
; H067+$00001436: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L067_0000143A:
; H067+$0000143A: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L067_0000143C:
; H067+$0000143C: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L067_00001442:
; H067+$00001442: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001444:
; H067+$00001444: 7400  moveq #$0, d2
        moveq #0, d2
L067_00001446:
; H067+$00001446: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L067_0000144A:
; H067+$0000144A: 6000085c  bra.w $1ca8
        bra.w H067+$1CA8
L067_0000144E:
; H067+$0000144E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001450:
; H067+$00001450: 6100fe08  bsr.w $125a
        bsr.w H067+$125A
L067_00001454:
; H067+$00001454: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001456:
; H067+$00001456: 37400036  move.w d0, $36(a3)
        move.w d0, $36(a3)
L067_0000145A:
; H067+$0000145A: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000145C:
; H067+$0000145C: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L067_00001460:
; H067+$00001460: 60000158  bra.w $15ba
        bra.w H067+$15BA
L067_00001464:
; H067+$00001464: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001466:
; H067+$00001466: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_0000146A:
; H067+$0000146A: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_0000146E:
; H067+$0000146E: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001474:
; H067+$00001474: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001476:
; H067+$00001476: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L067_0000147A:
; H067+$0000147A: 0c6d0005fffe  cmpi.w #$5, -$2(a5)
        cmpi.w #$5, -$2(a5)
L067_00001480:
; H067+$00001480: 66000008  bne.w $148a
        bne.w H067+$148A
L067_00001484:
; H067+$00001484: 3b7c0031fff8  move.w #$31, -$8(a5)
        move.w #$31, -$8(a5)
L067_0000148A:
; H067+$0000148A: 177c00070034  move.b #$7, $34(a3)
        move.b #$7, $34(a3)
L067_00001490:
; H067+$00001490: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_00001494:
; H067+$00001494: 0642006e  addi.w #$6e, d2
        addi.w #$6e, d2
L067_00001498:
; H067+$00001498: 17420033  move.b d2, $33(a3)
        move.b d2, $33(a3)
L067_0000149C:
; H067+$0000149C: 4e75  rts 
        rts 
L067_0000149E:
; H067+$0000149E: 177c000c0034  move.b #$c, $34(a3)
        move.b #$c, $34(a3)
L067_000014A4:
; H067+$000014A4: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_000014A8:
; H067+$000014A8: 0642006e  addi.w #$6e, d2
        addi.w #$6e, d2
L067_000014AC:
; H067+$000014AC: 17420033  move.b d2, $33(a3)
        move.b d2, $33(a3)
L067_000014B0:
; H067+$000014B0: 4e75  rts 
        rts 
L067_000014B2:
; H067+$000014B2: 176b00300034  move.b $30(a3), $34(a3)
        move.b $30(a3), $34(a3)
L067_000014B8:
; H067+$000014B8: 177c00300033  move.b #$30, $33(a3)
        move.b #$30, $33(a3)
L067_000014BE:
; H067+$000014BE: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_000014C2:
; H067+$000014C2: 0642006e  addi.w #$6e, d2
        addi.w #$6e, d2
L067_000014C6:
; H067+$000014C6: 17420032  move.b d2, $32(a3)
        move.b d2, $32(a3)
L067_000014CA:
; H067+$000014CA: 177c0004003b  move.b #$4, $3b(a3)
        move.b #$4, $3b(a3)
L067_000014D0:
; H067+$000014D0: 4e75  rts 
        rts 
L067_000014D2:
; H067+$000014D2: 176b00300034  move.b $30(a3), $34(a3)
        move.b $30(a3), $34(a3)
L067_000014D8:
; H067+$000014D8: 177c002f0033  move.b #$2f, $33(a3)
        move.b #$2f, $33(a3)
L067_000014DE:
; H067+$000014DE: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_000014E2:
; H067+$000014E2: 0642006e  addi.w #$6e, d2
        addi.w #$6e, d2
L067_000014E6:
; H067+$000014E6: 17420032  move.b d2, $32(a3)
        move.b d2, $32(a3)
L067_000014EA:
; H067+$000014EA: 177c0004003b  move.b #$4, $3b(a3)
        move.b #$4, $3b(a3)
L067_000014F0:
; H067+$000014F0: 4e75  rts 
        rts 
L067_000014F2:
; H067+$000014F2: 177c001e0034  move.b #$1e, $34(a3)
        move.b #$1e, $34(a3)
L067_000014F8:
; H067+$000014F8: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_000014FC:
; H067+$000014FC: 0642006e  addi.w #$6e, d2
        addi.w #$6e, d2
L067_00001500:
; H067+$00001500: 17420033  move.b d2, $33(a3)
        move.b d2, $33(a3)
L067_00001504:
; H067+$00001504: 4e75  rts 
        rts 
L067_00001506:
; H067+$00001506: 177c00320034  move.b #$32, $34(a3)
        move.b #$32, $34(a3)
L067_0000150C:
; H067+$0000150C: 177c005a0033  move.b #$5a, $33(a3)
        move.b #$5a, $33(a3)
L067_00001512:
; H067+$00001512: 377c00040036  move.w #$4, $36(a3)
        move.w #$4, $36(a3)
L067_00001518:
; H067+$00001518: 177c006b0032  move.b #$6b, $32(a3)
        move.b #$6b, $32(a3)
L067_0000151E:
; H067+$0000151E: 4e75  rts 
        rts 
L067_00001520:
; H067+$00001520: 177c002e0034  move.b #$2e, $34(a3)
        move.b #$2e, $34(a3)
L067_00001526:
; H067+$00001526: 177c00310033  move.b #$31, $33(a3)
        move.b #$31, $33(a3)
L067_0000152C:
; H067+$0000152C: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_00001530:
; H067+$00001530: 0642006e  addi.w #$6e, d2
        addi.w #$6e, d2
L067_00001534:
; H067+$00001534: 17420032  move.b d2, $32(a3)
        move.b d2, $32(a3)
L067_00001538:
; H067+$00001538: 4e75  rts 
        rts 
L067_0000153A:
; H067+$0000153A: 176b00300034  move.b $30(a3), $34(a3)
        move.b $30(a3), $34(a3)
L067_00001540:
; H067+$00001540: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_00001544:
; H067+$00001544: 0642006e  addi.w #$6e, d2
        addi.w #$6e, d2
L067_00001548:
; H067+$00001548: 17420033  move.b d2, $33(a3)
        move.b d2, $33(a3)
L067_0000154C:
; H067+$0000154C: 4e75  rts 
        rts 
; Preserved bytes H067+$0000154E..$000015BA; code/data not fully classified.
        dc.w $FFEA,$FF14,$FFEA,$FFEA,$FFEA,$FFEA,$FF4E,$FFEA
        dc.w $FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA
        dc.w $FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA
        dc.w $FFA2,$FF62,$FF82,$FF82,$FF82,$FF82,$FF82,$FFEA
        dc.w $FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFEA
        dc.w $FFEA,$FFEA,$FFEA,$FFEA,$FFB6,$FFEA,$FFEA,$FFEA
        dc.w $FFEA,$FFEA,$FFEA,$FFEA,$FFEA,$FFD0
L067_000015BA:
; H067+$000015BA: 45faff94  lea.l $1550(pc), a2
        lea.l H067+$1550(pc), a2
L067_000015BE:
; H067+$000015BE: 5f42  subq.w #$7, d2
        subq.w #$7, d2
L067_000015C0:
; H067+$000015C0: 0c420034  cmpi.w #$34, d2
        cmpi.w #$34, d2
L067_000015C4:
; H067+$000015C4: 6302  bls.b $15c8
        bls.b H067+$15C8
L067_000015C6:
; H067+$000015C6: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_000015C8:
; H067+$000015C8: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_000015CA:
; H067+$000015CA: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$1550; indici 0..52, default -1.
L067_000015CE:
; H067+$000015CE: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_000015D2:
; H067+$000015D2: 426b0038  clr.w $38(a3)
        clr.w $38(a3)
L067_000015D6:
; H067+$000015D6: 422b0040  clr.b $40(a3)
        clr.b $40(a3)
L067_000015DA:
; H067+$000015DA: 7400  moveq #$0, d2
        moveq #0, d2
L067_000015DC:
; H067+$000015DC: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L067_000015E0:
; H067+$000015E0: 6000013e  bra.w $1720
        bra.w H067+$1720
L067_000015E4:
; H067+$000015E4: 377c004b003e  move.w #$4b, $3e(a3)
        move.w #$4b, $3e(a3)
L067_000015EA:
; H067+$000015EA: 4e75  rts 
        rts 
L067_000015EC:
; H067+$000015EC: 377c0032003e  move.w #$32, $3e(a3)
        move.w #$32, $3e(a3)
L067_000015F2:
; H067+$000015F2: 4e75  rts 
        rts 
L067_000015F4:
; H067+$000015F4: 377c007d003e  move.w #$7d, $3e(a3)
        move.w #$7d, $3e(a3)
L067_000015FA:
; H067+$000015FA: 4e75  rts 
        rts 
L067_000015FC:
; H067+$000015FC: 377c0064003e  move.w #$64, $3e(a3)
        move.w #$64, $3e(a3)
L067_00001602:
; H067+$00001602: 4e75  rts 
        rts 
L067_00001604:
; H067+$00001604: 377c0096003e  move.w #$96, $3e(a3)
        move.w #$96, $3e(a3)
L067_0000160A:
; H067+$0000160A: 4e75  rts 
        rts 
L067_0000160C:
; H067+$0000160C: 377c00af003e  move.w #$af, $3e(a3)
        move.w #$af, $3e(a3)
L067_00001612:
; H067+$00001612: 4e75  rts 
        rts 
L067_00001614:
; H067+$00001614: 377c000a003e  move.w #$a, $3e(a3)
        move.w #$a, $3e(a3)
L067_0000161A:
; H067+$0000161A: 4e75  rts 
        rts 
L067_0000161C:
; H067+$0000161C: 377c0005003e  move.w #$5, $3e(a3)
        move.w #$5, $3e(a3)
L067_00001622:
; H067+$00001622: 177c00140040  move.b #$14, $40(a3)
        move.b #$14, $40(a3)
L067_00001628:
; H067+$00001628: 4e75  rts 
        rts 
L067_0000162A:
; H067+$0000162A: 377c003c003e  move.w #$3c, $3e(a3)
        move.w #$3c, $3e(a3)
L067_00001630:
; H067+$00001630: 4e75  rts 
        rts 
L067_00001632:
; H067+$00001632: 377c0050003e  move.w #$50, $3e(a3)
        move.w #$50, $3e(a3)
L067_00001638:
; H067+$00001638: 4e75  rts 
        rts 
L067_0000163A:
; H067+$0000163A: 377c0014003e  move.w #$14, $3e(a3)
        move.w #$14, $3e(a3)
L067_00001640:
; H067+$00001640: 4e75  rts 
        rts 
L067_00001642:
; H067+$00001642: 377c0028003e  move.w #$28, $3e(a3)
        move.w #$28, $3e(a3)
L067_00001648:
; H067+$00001648: 4e75  rts 
        rts 
L067_0000164A:
; H067+$0000164A: 377c0023003e  move.w #$23, $3e(a3)
        move.w #$23, $3e(a3)
L067_00001650:
; H067+$00001650: 4e75  rts 
        rts 
L067_00001652:
; H067+$00001652: 377c00fa003e  move.w #$fa, $3e(a3)
        move.w #$fa, $3e(a3)
L067_00001658:
; H067+$00001658: 4e75  rts 
        rts 
L067_0000165A:
; H067+$0000165A: 377c0190003e  move.w #$190, $3e(a3)
        move.w #$190, $3e(a3)
L067_00001660:
; H067+$00001660: 4e75  rts 
        rts 
L067_00001662:
; H067+$00001662: 377c012c003e  move.w #$12c, $3e(a3)
        move.w #$12c, $3e(a3)
L067_00001668:
; H067+$00001668: 4e75  rts 
        rts 
L067_0000166A:
; H067+$0000166A: 377c015e003e  move.w #$15e, $3e(a3)
        move.w #$15e, $3e(a3)
L067_00001670:
; H067+$00001670: 4e75  rts 
        rts 
L067_00001672:
; H067+$00001672: 377c01c2003e  move.w #$1c2, $3e(a3)
        move.w #$1c2, $3e(a3)
L067_00001678:
; H067+$00001678: 4e75  rts 
        rts 
L067_0000167A:
; H067+$0000167A: 377c0001003e  move.w #$1, $3e(a3)
        move.w #$1, $3e(a3)
L067_00001680:
; H067+$00001680: 4e75  rts 
        rts 
L067_00001682:
; H067+$00001682: 377c0004003e  move.w #$4, $3e(a3)
        move.w #$4, $3e(a3)
L067_00001688:
; H067+$00001688: 177c00140040  move.b #$14, $40(a3)
        move.b #$14, $40(a3)
L067_0000168E:
; H067+$0000168E: 4e75  rts 
        rts 
; Preserved bytes H067+$00001690..$00001720; code/data not fully classified.
        dc.w $FFF0,$FF52,$FFF0,$FFF0,$FF82,$FF8A,$FF5A,$FFA8
        dc.w $FF6A,$FF62,$FF98,$FFF0,$FFF0,$FFB0,$FF5A,$FF5A
        dc.w $FF6A,$FF52,$FF98,$FFB8,$FFC0,$FFF0,$FFA0,$FF5A
        dc.w $FF6A,$FF5A,$FFF0,$FFF0,$FFE8,$FF5A,$FFF0,$FF72
        dc.w $FFC0,$FFC8,$FFD0,$FFD8,$FFE0,$FF5A,$FFF0,$FFF0
        dc.w $FFF0,$FFF0,$FFF0,$FFF0,$FFF0,$FFF0,$FFF0,$FFF0
        dc.w $FFF0,$FFF0,$FF82,$FFF0,$FFF0,$FFF0,$FFF0,$FFF0
        dc.w $FFF0,$FFF0,$FFF0,$FFE8,$FFF0,$FFF0,$FFF0,$FFF0
        dc.w $FFF0,$FFF0,$FFF0,$FF5A,$FFF0,$FFF0,$FF72,$FF7A
L067_00001720:
; H067+$00001720: 45faff70  lea.l $1692(pc), a2
        lea.l H067+$1692(pc), a2
L067_00001724:
; H067+$00001724: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001726:
; H067+$00001726: 0c420046  cmpi.w #$46, d2
        cmpi.w #$46, d2
L067_0000172A:
; H067+$0000172A: 6302  bls.b $172e
        bls.b H067+$172E
L067_0000172C:
; H067+$0000172C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_0000172E:
; H067+$0000172E: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001730:
; H067+$00001730: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$1692; indici 0..70, default -1.
L067_00001734:
; H067+$00001734: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_00001738:
; H067+$00001738: 7400  moveq #$0, d2
        moveq #0, d2
L067_0000173A:
; H067+$0000173A: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L067_0000173E:
; H067+$0000173E: 6000009e  bra.w $17de
        bra.w H067+$17DE
L067_00001742:
; H067+$00001742: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_00001746:
; H067+$00001746: c5fc04e2  muls.w #$4e2, d2
        muls.w #$4e2, d2
L067_0000174A:
; H067+$0000174A: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_0000174E:
; H067+$0000174E: 4e75  rts 
        rts 
L067_00001750:
; H067+$00001750: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_00001754:
; H067+$00001754: c5fc004b  muls.w #$4b, d2
        muls.w #$4b, d2
L067_00001758:
; H067+$00001758: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_0000175C:
; H067+$0000175C: 4e75  rts 
        rts 
L067_0000175E:
; H067+$0000175E: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_00001762:
; H067+$00001762: c5fc05dc  muls.w #$5dc, d2
        muls.w #$5dc, d2
L067_00001766:
; H067+$00001766: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_0000176A:
; H067+$0000176A: 4e75  rts 
        rts 
L067_0000176C:
; H067+$0000176C: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_00001770:
; H067+$00001770: c5fc06d6  muls.w #$6d6, d2
        muls.w #$6d6, d2
L067_00001774:
; H067+$00001774: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_00001778:
; H067+$00001778: 4e75  rts 
        rts 
L067_0000177A:
; H067+$0000177A: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_0000177E:
; H067+$0000177E: c5fc07d0  muls.w #$7d0, d2
        muls.w #$7d0, d2
L067_00001782:
; H067+$00001782: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_00001786:
; H067+$00001786: 4e75  rts 
        rts 
L067_00001788:
; H067+$00001788: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_0000178C:
; H067+$0000178C: c5fc09c4  muls.w #$9c4, d2
        muls.w #$9c4, d2
L067_00001790:
; H067+$00001790: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_00001794:
; H067+$00001794: 4e75  rts 
        rts 
L067_00001796:
; H067+$00001796: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_0000179A:
; H067+$0000179A: c5fc05dc  muls.w #$5dc, d2
        muls.w #$5dc, d2
L067_0000179E:
; H067+$0000179E: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_000017A2:
; H067+$000017A2: 4e75  rts 
        rts 
L067_000017A4:
; H067+$000017A4: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L067_000017A8:
; H067+$000017A8: c5fc03e8  muls.w #$3e8, d2
        muls.w #$3e8, d2
L067_000017AC:
; H067+$000017AC: 37420042  move.w d2, $42(a3)
        move.w d2, $42(a3)
L067_000017B0:
; H067+$000017B0: 4e75  rts 
        rts 
; Preserved bytes H067+$000017B2..$000017DE; code/data not fully classified.
        dc.w $FFF0,$FF9C,$FFF0,$FFAA,$FFAA,$FFB8,$FFC6,$FFD4
        dc.w $FF8E,$FFF0,$FFF0,$FFF0,$FFF0,$FFF0,$FFF0,$FFF0
        dc.w $FFF0,$FFF0,$FFF0,$FFF0,$FFF0,$FFE2
L067_000017DE:
; H067+$000017DE: 45faffd4  lea.l $17b4(pc), a2
        lea.l H067+$17B4(pc), a2
L067_000017E2:
; H067+$000017E2: 0442001e  subi.w #$1e, d2
        subi.w #$1e, d2
L067_000017E6:
; H067+$000017E6: 0c420014  cmpi.w #$14, d2
        cmpi.w #$14, d2
L067_000017EA:
; H067+$000017EA: 6302  bls.b $17ee
        bls.b H067+$17EE
L067_000017EC:
; H067+$000017EC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_000017EE:
; H067+$000017EE: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_000017F0:
; H067+$000017F0: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$17B4; indici 0..20, default -1.
L067_000017F4:
; H067+$000017F4: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_000017F8:
; H067+$000017F8: 4e75  rts 
        rts 
L067_000017FA:
; H067+$000017FA: 177c0004003b  move.b #$4, $3b(a3)
        move.b #$4, $3b(a3)
L067_00001800:
; H067+$00001800: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001802:
; H067+$00001802: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001806:
; H067+$00001806: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_0000180A:
; H067+$0000180A: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001810:
; H067+$00001810: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001812:
; H067+$00001812: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L067_00001816:
; H067+$00001816: 7400  moveq #$0, d2
        moveq #0, d2
L067_00001818:
; H067+$00001818: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L067_0000181C:
; H067+$0000181C: 0c420027  cmpi.w #$27, d2
        cmpi.w #$27, d2
L067_00001820:
; H067+$00001820: 6600004a  bne.w $186c
        bne.w H067+$186C
L067_00001824:
; H067+$00001824: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001826:
; H067+$00001826: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_0000182A:
; H067+$0000182A: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_0000182E:
; H067+$0000182E: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001834:
; H067+$00001834: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001836:
; H067+$00001836: 3400  move.w d0, d2
        move.w d0, d2
L067_00001838:
; H067+$00001838: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L067_0000183C:
; H067+$0000183C: 66000018  bne.w $1856
        bne.w H067+$1856
L067_00001840:
; H067+$00001840: 3b7c0003fff4  move.w #$3, -$c(a5)
        move.w #$3, -$c(a5)
L067_00001846:
; H067+$00001846: 177c00780034  move.b #$78, $34(a3)
        move.b #$78, $34(a3)
L067_0000184C:
; H067+$0000184C: 177c00280033  move.b #$28, $33(a3)
        move.b #$28, $33(a3)
L067_00001852:
; H067+$00001852: 60000014  bra.w $1868
        bra.w H067+$1868
L067_00001856:
; H067+$00001856: 3b7c0002fff4  move.w #$2, -$c(a5)
        move.w #$2, -$c(a5)
L067_0000185C:
; H067+$0000185C: 177c00770034  move.b #$77, $34(a3)
        move.b #$77, $34(a3)
L067_00001862:
; H067+$00001862: 177c00280033  move.b #$28, $33(a3)
        move.b #$28, $33(a3)
L067_00001868:
; H067+$00001868: 60000012  bra.w $187c
        bra.w H067+$187C
L067_0000186C:
; H067+$0000186C: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L067_00001870:
; H067+$00001870: 177c00260034  move.b #$26, $34(a3)
        move.b #$26, $34(a3)
L067_00001876:
; H067+$00001876: 177c00270033  move.b #$27, $33(a3)
        move.b #$27, $33(a3)
L067_0000187C:
; H067+$0000187C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L067_00001880:
; H067+$00001880: 06420063  addi.w #$63, d2
        addi.w #$63, d2
L067_00001884:
; H067+$00001884: 17420032  move.b d2, $32(a3)
        move.b d2, $32(a3)
L067_00001888:
; H067+$00001888: 377c00010036  move.w #$1, $36(a3)
        move.w #$1, $36(a3)
L067_0000188E:
; H067+$0000188E: 377c0019003e  move.w #$19, $3e(a3)
        move.w #$19, $3e(a3)
L067_00001894:
; H067+$00001894: 422b0040  clr.b $40(a3)
        clr.b $40(a3)
L067_00001898:
; H067+$00001898: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L067_0000189E:
; H067+$0000189E: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L067_000018A2:
; H067+$000018A2: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L067_000018A6:
; H067+$000018A6: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L067_000018A8:
; H067+$000018A8: 620002a0  bhi.w $1b4a
        bhi.w H067+$1B4A
L067_000018AC:
; H067+$000018AC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_000018AE:
; H067+$000018AE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_000018B2:
; H067+$000018B2: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_000018B6:
; H067+$000018B6: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_000018BC:
; H067+$000018BC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_000018BE:
; H067+$000018BE: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L067_000018C2:
; H067+$000018C2: 7400  moveq #$0, d2
        moveq #0, d2
L067_000018C4:
; H067+$000018C4: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L067_000018C8:
; H067+$000018C8: 0c420027  cmpi.w #$27, d2
        cmpi.w #$27, d2
L067_000018CC:
; H067+$000018CC: 66000192  bne.w $1a60
        bne.w H067+$1A60
L067_000018D0:
; H067+$000018D0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L067_000018D4:
; H067+$000018D4: 6000016e  bra.w $1a44
        bra.w H067+$1A44
L067_000018D8:
; H067+$000018D8: 0c6d0002fff4  cmpi.w #$2, -$c(a5)
        cmpi.w #$2, -$c(a5)
L067_000018DE:
; H067+$000018DE: 6600002a  bne.w $190a
        bne.w H067+$190A
L067_000018E2:
; H067+$000018E2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_000018E4:
; H067+$000018E4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_000018E8:
; H067+$000018E8: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_000018EC:
; H067+$000018EC: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_000018F2:
; H067+$000018F2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_000018F4:
; H067+$000018F4: 3400  move.w d0, d2
        move.w d0, d2
L067_000018F6:
; H067+$000018F6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_000018F8:
; H067+$000018F8: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_000018FA:
; H067+$000018FA: 45f9000014c6  lea.l $14c6.l, a2
        lea.l (H005+$14C6).l, a2
L067_00001900:
; H067+$00001900: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001906:
; H067+$00001906: 60000026  bra.w $192e
        bra.w H067+$192E
L067_0000190A:
; H067+$0000190A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_0000190C:
; H067+$0000190C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001910:
; H067+$00001910: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001914:
; H067+$00001914: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_0000191A:
; H067+$0000191A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_0000191C:
; H067+$0000191C: 3400  move.w d0, d2
        move.w d0, d2
L067_0000191E:
; H067+$0000191E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001920:
; H067+$00001920: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001922:
; H067+$00001922: 45f900001516  lea.l $1516.l, a2
        lea.l (H005+$1516).l, a2
L067_00001928:
; H067+$00001928: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_0000192E:
; H067+$0000192E: 4e75  rts 
        rts 
L067_00001930:
; H067+$00001930: 0c6d0002fff4  cmpi.w #$2, -$c(a5)
        cmpi.w #$2, -$c(a5)
L067_00001936:
; H067+$00001936: 6600002a  bne.w $1962
        bne.w H067+$1962
L067_0000193A:
; H067+$0000193A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_0000193C:
; H067+$0000193C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001940:
; H067+$00001940: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001944:
; H067+$00001944: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_0000194A:
; H067+$0000194A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_0000194C:
; H067+$0000194C: 3400  move.w d0, d2
        move.w d0, d2
L067_0000194E:
; H067+$0000194E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001950:
; H067+$00001950: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001952:
; H067+$00001952: 45f9000014da  lea.l $14da.l, a2
        lea.l (H005+$14DA).l, a2
L067_00001958:
; H067+$00001958: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_0000195E:
; H067+$0000195E: 60000026  bra.w $1986
        bra.w H067+$1986
L067_00001962:
; H067+$00001962: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001964:
; H067+$00001964: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001968:
; H067+$00001968: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_0000196C:
; H067+$0000196C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001972:
; H067+$00001972: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001974:
; H067+$00001974: 3400  move.w d0, d2
        move.w d0, d2
L067_00001976:
; H067+$00001976: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001978:
; H067+$00001978: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_0000197A:
; H067+$0000197A: 45f90000152a  lea.l $152a.l, a2
        lea.l (H005+$152A).l, a2
L067_00001980:
; H067+$00001980: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001986:
; H067+$00001986: 4e75  rts 
        rts 
L067_00001988:
; H067+$00001988: 0c6d0002fff4  cmpi.w #$2, -$c(a5)
        cmpi.w #$2, -$c(a5)
L067_0000198E:
; H067+$0000198E: 6600002a  bne.w $19ba
        bne.w H067+$19BA
L067_00001992:
; H067+$00001992: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001994:
; H067+$00001994: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001998:
; H067+$00001998: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_0000199C:
; H067+$0000199C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_000019A2:
; H067+$000019A2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_000019A4:
; H067+$000019A4: 3400  move.w d0, d2
        move.w d0, d2
L067_000019A6:
; H067+$000019A6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_000019A8:
; H067+$000019A8: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_000019AA:
; H067+$000019AA: 45f9000014ee  lea.l $14ee.l, a2
        lea.l (H005+$14EE).l, a2
L067_000019B0:
; H067+$000019B0: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_000019B6:
; H067+$000019B6: 60000026  bra.w $19de
        bra.w H067+$19DE
L067_000019BA:
; H067+$000019BA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_000019BC:
; H067+$000019BC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_000019C0:
; H067+$000019C0: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_000019C4:
; H067+$000019C4: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_000019CA:
; H067+$000019CA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_000019CC:
; H067+$000019CC: 3400  move.w d0, d2
        move.w d0, d2
L067_000019CE:
; H067+$000019CE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_000019D0:
; H067+$000019D0: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_000019D2:
; H067+$000019D2: 45f90000153e  lea.l $153e.l, a2
        lea.l (H005+$153E).l, a2
L067_000019D8:
; H067+$000019D8: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_000019DE:
; H067+$000019DE: 4e75  rts 
        rts 
L067_000019E0:
; H067+$000019E0: 0c6d0002fff4  cmpi.w #$2, -$c(a5)
        cmpi.w #$2, -$c(a5)
L067_000019E6:
; H067+$000019E6: 6600002a  bne.w $1a12
        bne.w H067+$1A12
L067_000019EA:
; H067+$000019EA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_000019EC:
; H067+$000019EC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_000019F0:
; H067+$000019F0: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_000019F4:
; H067+$000019F4: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_000019FA:
; H067+$000019FA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_000019FC:
; H067+$000019FC: 3400  move.w d0, d2
        move.w d0, d2
L067_000019FE:
; H067+$000019FE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001A00:
; H067+$00001A00: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001A02:
; H067+$00001A02: 45f900001502  lea.l $1502.l, a2
        lea.l (H005+$1502).l, a2
L067_00001A08:
; H067+$00001A08: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001A0E:
; H067+$00001A0E: 60000026  bra.w $1a36
        bra.w H067+$1A36
L067_00001A12:
; H067+$00001A12: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001A14:
; H067+$00001A14: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001A18:
; H067+$00001A18: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001A1C:
; H067+$00001A1C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001A22:
; H067+$00001A22: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001A24:
; H067+$00001A24: 3400  move.w d0, d2
        move.w d0, d2
L067_00001A26:
; H067+$00001A26: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001A28:
; H067+$00001A28: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001A2A:
; H067+$00001A2A: 45f900001552  lea.l $1552.l, a2
        lea.l (H005+$1552).l, a2
L067_00001A30:
; H067+$00001A30: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001A36:
; H067+$00001A36: 4e75  rts 
        rts 
L067_00001A38:
; H067+$00001A38: 4e75  rts 
        rts 
; Preserved bytes H067+$00001A3A..$00001A44; code/data not fully classified.
        dc.w $FFFC,$FE9C,$FEF4,$FF4C,$FFA4
L067_00001A44:
; H067+$00001A44: 45fafff6  lea.l $1a3c(pc), a2
        lea.l H067+$1A3C(pc), a2
L067_00001A48:
; H067+$00001A48: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001A4A:
; H067+$00001A4A: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L067_00001A4E:
; H067+$00001A4E: 6302  bls.b $1a52
        bls.b H067+$1A52
L067_00001A50:
; H067+$00001A50: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00001A52:
; H067+$00001A52: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001A54:
; H067+$00001A54: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$1A3C; indici 0..3, default -1.
L067_00001A58:
; H067+$00001A58: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_00001A5C:
; H067+$00001A5C: 600000c6  bra.w $1b24
        bra.w H067+$1B24
L067_00001A60:
; H067+$00001A60: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L067_00001A64:
; H067+$00001A64: 600000a6  bra.w $1b0c
        bra.w H067+$1B0C
L067_00001A68:
; H067+$00001A68: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001A6A:
; H067+$00001A6A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001A6E:
; H067+$00001A6E: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001A72:
; H067+$00001A72: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001A78:
; H067+$00001A78: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001A7A:
; H067+$00001A7A: 3400  move.w d0, d2
        move.w d0, d2
L067_00001A7C:
; H067+$00001A7C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001A7E:
; H067+$00001A7E: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001A80:
; H067+$00001A80: 45f900001476  lea.l $1476.l, a2
        lea.l (H005+$1476).l, a2
L067_00001A86:
; H067+$00001A86: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001A8C:
; H067+$00001A8C: 4e75  rts 
        rts 
L067_00001A8E:
; H067+$00001A8E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001A90:
; H067+$00001A90: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001A94:
; H067+$00001A94: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001A98:
; H067+$00001A98: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001A9E:
; H067+$00001A9E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001AA0:
; H067+$00001AA0: 3400  move.w d0, d2
        move.w d0, d2
L067_00001AA2:
; H067+$00001AA2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001AA4:
; H067+$00001AA4: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001AA6:
; H067+$00001AA6: 45f90000148a  lea.l $148a.l, a2
        lea.l (H005+$148A).l, a2
L067_00001AAC:
; H067+$00001AAC: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001AB2:
; H067+$00001AB2: 4e75  rts 
        rts 
L067_00001AB4:
; H067+$00001AB4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001AB6:
; H067+$00001AB6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001ABA:
; H067+$00001ABA: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001ABE:
; H067+$00001ABE: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001AC4:
; H067+$00001AC4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001AC6:
; H067+$00001AC6: 3400  move.w d0, d2
        move.w d0, d2
L067_00001AC8:
; H067+$00001AC8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001ACA:
; H067+$00001ACA: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001ACC:
; H067+$00001ACC: 45f90000149e  lea.l $149e.l, a2
        lea.l (H005+$149E).l, a2
L067_00001AD2:
; H067+$00001AD2: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001AD8:
; H067+$00001AD8: 4e75  rts 
        rts 
L067_00001ADA:
; H067+$00001ADA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001ADC:
; H067+$00001ADC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001AE0:
; H067+$00001AE0: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001AE4:
; H067+$00001AE4: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001AEA:
; H067+$00001AEA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001AEC:
; H067+$00001AEC: 3400  move.w d0, d2
        move.w d0, d2
L067_00001AEE:
; H067+$00001AEE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001AF0:
; H067+$00001AF0: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001AF2:
; H067+$00001AF2: 45f9000014b2  lea.l $14b2.l, a2
        lea.l (H005+$14B2).l, a2
L067_00001AF8:
; H067+$00001AF8: 3b722000fff6  move.w (a2, d2.w), -$a(a5)
        move.w (a2, d2.w), -$a(a5)
L067_00001AFE:
; H067+$00001AFE: 4e75  rts 
        rts 
L067_00001B00:
; H067+$00001B00: 4e75  rts 
        rts 
; Preserved bytes H067+$00001B02..$00001B0C; code/data not fully classified.
        dc.w $FFFC,$FF64,$FF8A,$FFB0,$FFD6
L067_00001B0C:
; H067+$00001B0C: 45fafff6  lea.l $1b04(pc), a2
        lea.l H067+$1B04(pc), a2
L067_00001B10:
; H067+$00001B10: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001B12:
; H067+$00001B12: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L067_00001B16:
; H067+$00001B16: 6302  bls.b $1b1a
        bls.b H067+$1B1A
L067_00001B18:
; H067+$00001B18: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00001B1A:
; H067+$00001B1A: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001B1C:
; H067+$00001B1C: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$1B04; indici 0..3, default -1.
L067_00001B20:
; H067+$00001B20: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_00001B24:
; H067+$00001B24: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L067_00001B28:
; H067+$00001B28: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001B2A:
; H067+$00001B2A: 45eb0044  lea.l $44(a3), a2
        lea.l $44(a3), a2
L067_00001B2E:
; H067+$00001B2E: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L067_00001B32:
; H067+$00001B32: 15842000  move.b d4, (a2, d2.w)
        move.b d4, (a2, d2.w)
L067_00001B36:
; H067+$00001B36: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L067_00001B3A:
; H067+$00001B3A: c4fc0096  mulu.w #$96, d2
        mulu.w #$96, d2
L067_00001B3E:
; H067+$00001B3E: d56b0042  add.w d2, $42(a3)
        add.w d2, $42(a3)
L067_00001B42:
; H067+$00001B42: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L067_00001B46:
; H067+$00001B46: 6400fd5a  bcc.w $18a2
        bcc.w H067+$18A2
L067_00001B4A:
; H067+$00001B4A: 548f  addq.l #$2, a7
        addq.l #$2, a7
L067_00001B4C:
; H067+$00001B4C: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L067_00001B50:
; H067+$00001B50: 6000003e  bra.w $1b90
        bra.w H067+$1B90
L067_00001B54:
; H067+$00001B54: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001B56:
; H067+$00001B56: 1f2b003b  move.b $3b(a3), -(a7)
        move.b $3b(a3), -(a7)
L067_00001B5A:
; H067+$00001B5A: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L067_00001B5E:
; H067+$00001B5E: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L067_00001B64:
; H067+$00001B64: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001B66:
; H067+$00001B66: 1740003b  move.b d0, $3b(a3)
        move.b d0, $3b(a3)
L067_00001B6A:
; H067+$00001B6A: 4e75  rts 
        rts 
L067_00001B6C:
; H067+$00001B6C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001B6E:
; H067+$00001B6E: 1f2b003b  move.b $3b(a3), -(a7)
        move.b $3b(a3), -(a7)
L067_00001B72:
; H067+$00001B72: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L067_00001B76:
; H067+$00001B76: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L067_00001B7C:
; H067+$00001B7C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001B7E:
; H067+$00001B7E: 1740003b  move.b d0, $3b(a3)
        move.b d0, $3b(a3)
L067_00001B82:
; H067+$00001B82: 4e75  rts 
        rts 
L067_00001B84:
; H067+$00001B84: 422b003b  clr.b $3b(a3)
        clr.b $3b(a3)
L067_00001B88:
; H067+$00001B88: 4e75  rts 
        rts 
; Preserved bytes H067+$00001B8A..$00001B90; code/data not fully classified.
        dc.w $FFF8,$FFC8,$FFE0
L067_00001B90:
; H067+$00001B90: 45fafffa  lea.l $1b8c(pc), a2
        lea.l H067+$1B8C(pc), a2
L067_00001B94:
; H067+$00001B94: 5542  subq.w #$2, d2
        subq.w #$2, d2
L067_00001B96:
; H067+$00001B96: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L067_00001B9A:
; H067+$00001B9A: 6302  bls.b $1b9e
        bls.b H067+$1B9E
L067_00001B9C:
; H067+$00001B9C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00001B9E:
; H067+$00001B9E: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001BA0:
; H067+$00001BA0: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$1B8C; indici 0..1, default -1.
L067_00001BA4:
; H067+$00001BA4: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_00001BA8:
; H067+$00001BA8: 4e75  rts 
        rts 
L067_00001BAA:
; H067+$00001BAA: 3b7c0021fff8  move.w #$21, -$8(a5)
        move.w #$21, -$8(a5)
L067_00001BB0:
; H067+$00001BB0: 4e75  rts 
        rts 
L067_00001BB2:
; H067+$00001BB2: 3b7c0009fff8  move.w #$9, -$8(a5)
        move.w #$9, -$8(a5)
L067_00001BB8:
; H067+$00001BB8: 4e75  rts 
        rts 
L067_00001BBA:
; H067+$00001BBA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L067_00001BBC:
; H067+$00001BBC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001BC0:
; H067+$00001BC0: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_00001BC4:
; H067+$00001BC4: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00001BCA:
; H067+$00001BCA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L067_00001BCC:
; H067+$00001BCC: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L067_00001BD0:
; H067+$00001BD0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L067_00001BD4:
; H067+$00001BD4: 60000026  bra.w $1bfc
        bra.w H067+$1BFC
L067_00001BD8:
; H067+$00001BD8: 3b7c0011fff8  move.w #$11, -$8(a5)
        move.w #$11, -$8(a5)
L067_00001BDE:
; H067+$00001BDE: 4e75  rts 
        rts 
L067_00001BE0:
; H067+$00001BE0: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L067_00001BE6:
; H067+$00001BE6: 4e75  rts 
        rts 
L067_00001BE8:
; H067+$00001BE8: 4e75  rts 
        rts 
; Preserved bytes H067+$00001BEA..$00001BFC; code/data not fully classified.
        dc.w $FFFC,$FFEC,$FFEC,$FFEC,$FFEC,$FFEC,$FFF4,$FFF4
        dc.w $FFF4
L067_00001BFC:
; H067+$00001BFC: 45faffee  lea.l $1bec(pc), a2
        lea.l H067+$1BEC(pc), a2
L067_00001C00:
; H067+$00001C00: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001C02:
; H067+$00001C02: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L067_00001C06:
; H067+$00001C06: 6302  bls.b $1c0a
        bls.b H067+$1C0A
L067_00001C08:
; H067+$00001C08: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00001C0A:
; H067+$00001C0A: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001C0C:
; H067+$00001C0C: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$1BEC; indici 0..7, default -1.
L067_00001C10:
; H067+$00001C10: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_00001C14:
; H067+$00001C14: 4e75  rts 
        rts 
L067_00001C16:
; H067+$00001C16: 4e75  rts 
        rts 
; Preserved bytes H067+$00001C18..$00001CA8; code/data not fully classified.
        dc.w $FFFC,$F834,$F834,$F834,$F834,$F834,$F834,$F834
        dc.w $F834,$F834,$F834,$F834,$F834,$F834,$F834,$F834
        dc.w $F834,$F834,$F834,$F834,$F834,$F834,$F834,$F834
        dc.w $F834,$F834,$F834,$F834,$F834,$F834,$F834,$F834
        dc.w $F834,$F834,$F834,$F834,$F834,$F834,$FFFC,$FBE0
        dc.w $FBE0,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFA0,$FFFC,$F834,$FFFC,$FF90,$FF98,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$F834,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$F834,$F834
L067_00001CA8:
; H067+$00001CA8: 45faff70  lea.l $1c1a(pc), a2
        lea.l H067+$1C1A(pc), a2
L067_00001CAC:
; H067+$00001CAC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001CAE:
; H067+$00001CAE: 0c420046  cmpi.w #$46, d2
        cmpi.w #$46, d2
L067_00001CB2:
; H067+$00001CB2: 6302  bls.b $1cb6
        bls.b H067+$1CB6
L067_00001CB4:
; H067+$00001CB4: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00001CB6:
; H067+$00001CB6: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001CB8:
; H067+$00001CB8: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H067+$1C1A; indici 0..70, default -1.
L067_00001CBC:
; H067+$00001CBC: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L067_00001CC0:
; H067+$00001CC0: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L067_00001CC4:
; H067+$00001CC4: 670000ac  beq.w $1d72
        beq.w H067+$1D72
L067_00001CC8:
; H067+$00001CC8: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L067_00001CCC:
; H067+$00001CCC: 0c6d0002fffa  cmpi.w #$2, -$6(a5)
        cmpi.w #$2, -$6(a5)
L067_00001CD2:
; H067+$00001CD2: 6200002c  bhi.w $1d00
        bhi.w H067+$1D00
L067_00001CD6:
; H067+$00001CD6: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L067_00001CDA:
; H067+$00001CDA: 5242  addq.w #$1, d2
        addq.w #$1, d2
L067_00001CDC:
; H067+$00001CDC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001CDE:
; H067+$00001CDE: 45eb0032  lea.l $32(a3), a2
        lea.l $32(a3), a2
L067_00001CE2:
; H067+$00001CE2: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L067_00001CE6:
; H067+$00001CE6: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L067_00001CEA:
; H067+$00001CEA: 5344  subq.w #$1, d4
        subq.w #$1, d4
L067_00001CEC:
; H067+$00001CEC: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00001CEE:
; H067+$00001CEE: 43edff84  lea.l -$7c(a5), a1
        lea.l -$7c(a5), a1
L067_00001CF2:
; H067+$00001CF2: 3c314000  move.w (a1, d4.w), d6
        move.w (a1, d4.w), d6
L067_00001CF6:
; H067+$00001CF6: 15862000  move.b d6, (a2, d2.w)
        move.b d6, (a2, d2.w)
L067_00001CFA:
; H067+$00001CFA: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L067_00001CFE:
; H067+$00001CFE: 64cc  bcc.b $1ccc
        bcc.b H067+$1CCC
L067_00001D00:
; H067+$00001D00: 377c00010036  move.w #$1, $36(a3)
        move.w #$1, $36(a3)
L067_00001D06:
; H067+$00001D06: 377c00010038  move.w #$1, $38(a3)
        move.w #$1, $38(a3)
L067_00001D0C:
; H067+$00001D0C: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L067_00001D10:
; H067+$00001D10: 5642  addq.w #$3, d2
        addq.w #$3, d2
L067_00001D12:
; H067+$00001D12: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001D14:
; H067+$00001D14: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001D16:
; H067+$00001D16: 45edff84  lea.l -$7c(a5), a2
        lea.l -$7c(a5), a2
L067_00001D1A:
; H067+$00001D1A: 37722000003e  move.w (a2, d2.w), $3e(a3)
        move.w (a2, d2.w), $3e(a3)
L067_00001D20:
; H067+$00001D20: 422b0040  clr.b $40(a3)
        clr.b $40(a3)
L067_00001D24:
; H067+$00001D24: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L067_00001D28:
; H067+$00001D28: 5842  addq.w #$4, d2
        addq.w #$4, d2
L067_00001D2A:
; H067+$00001D2A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001D2C:
; H067+$00001D2C: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001D2E:
; H067+$00001D2E: 45edff84  lea.l -$7c(a5), a2
        lea.l -$7c(a5), a2
L067_00001D32:
; H067+$00001D32: 377220000042  move.w (a2, d2.w), $42(a3)
        move.w (a2, d2.w), $42(a3)
L067_00001D38:
; H067+$00001D38: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L067_00001D3E:
; H067+$00001D3E: 0c6d0003fffa  cmpi.w #$3, -$6(a5)
        cmpi.w #$3, -$6(a5)
L067_00001D44:
; H067+$00001D44: 6200002c  bhi.w $1d72
        bhi.w H067+$1D72
L067_00001D48:
; H067+$00001D48: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L067_00001D4C:
; H067+$00001D4C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L067_00001D4E:
; H067+$00001D4E: 45eb0044  lea.l $44(a3), a2
        lea.l $44(a3), a2
L067_00001D52:
; H067+$00001D52: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L067_00001D56:
; H067+$00001D56: 5844  addq.w #$4, d4
        addq.w #$4, d4
L067_00001D58:
; H067+$00001D58: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L067_00001D5C:
; H067+$00001D5C: 5344  subq.w #$1, d4
        subq.w #$1, d4
L067_00001D5E:
; H067+$00001D5E: e344  asl.w #$1, d4
        asl.w #$1, d4
L067_00001D60:
; H067+$00001D60: 43edff84  lea.l -$7c(a5), a1
        lea.l -$7c(a5), a1
L067_00001D64:
; H067+$00001D64: 3c314000  move.w (a1, d4.w), d6
        move.w (a1, d4.w), d6
L067_00001D68:
; H067+$00001D68: 15862000  move.b d6, (a2, d2.w)
        move.b d6, (a2, d2.w)
L067_00001D6C:
; H067+$00001D6C: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L067_00001D70:
; H067+$00001D70: 64cc  bcc.b $1d3e
        bcc.b H067+$1D3E
L067_00001D72:
; H067+$00001D72: 4e5d  unlk a5
        unlk a5
L067_00001D74:
; H067+$00001D74: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00001D76:
; H067+$00001D76: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00001D78:
; H067+$00001D78: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L067_00001D7A:
; H067+$00001D7A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H067_00001D7C [parziale]
; Scopo: Routine del modulo monete, gemme, gioielli e condivisione del denaro; richiama H063+$1D44, H045+$01D6, H026+$01E0, H030+$0B6C.
;   - Richiama H063+$1D44.
;   - Richiama H045+$01D6.
;   - Richiama H026+$01E0.
;   - Richiama H030+$0B6C.
;   - Richiama H063+$1F34.
;   - Richiama H030+$0256.
;   - Richiama H008+$01FC.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H072+$134A, H071+$0A7E
; --------------------------------------------------------------------------
L067_00001D7C:
; H067+$00001D7C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L067_00001D7E:
; H067+$00001D7E: 287ae436  movea.l $1b6(pc), a4
        movea.l H067+$1B6(pc), a4
L067_00001D82:
; H067+$00001D82: 4e55ff44  link.w a5, #$ff44
        link.w a5, #$ff44
L067_00001D86:
; H067+$00001D86: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_00001D8A:
; H067+$00001D8A: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
; STATO: H005+$3368 = personaggio corrente
L067_00001D8E:
; H067+$00001D8E: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001D94:
; H067+$00001D94: 4a6b00fa  tst.w $fa(a3)
        tst.w $fa(a3)
L067_00001D98:
; H067+$00001D98: 66000028  bne.w $1dc2
        bne.w H067+$1DC2
; STATO: H005+$3368 = personaggio corrente
L067_00001D9C:
; H067+$00001D9C: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001DA2:
; H067+$00001DA2: 4a6b00fc  tst.w $fc(a3)
        tst.w $fc(a3)
L067_00001DA6:
; H067+$00001DA6: 6600001a  bne.w $1dc2
        bne.w H067+$1DC2
L067_00001DAA:
; H067+$00001DAA: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L067_00001DAE:
; H067+$00001DAE: 486c00b1  pea.l $b1(a4)
        pea.l $b1(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L067_00001DB2:
; H067+$00001DB2: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L067_00001DB8:
; H067+$00001DB8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L067_00001DBC:
; H067+$00001DBC: 4213  clr.b (a3)
        clr.b (a3)
L067_00001DBE:
; H067+$00001DBE: 6000088a  bra.w $264a
        bra.w H067+$264A
; STATO: H005+$3368 = personaggio corrente
L067_00001DC2:
; H067+$00001DC2: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001DC8:
; H067+$00001DC8: 4a6b00fa  tst.w $fa(a3)
        tst.w $fa(a3)
L067_00001DCC:
; H067+$00001DCC: 6600001a  bne.w $1de8
        bne.w H067+$1DE8
; STATO: H005+$3368 = personaggio corrente
L067_00001DD0:
; H067+$00001DD0: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001DD6:
; H067+$00001DD6: 4a6b00fc  tst.w $fc(a3)
        tst.w $fc(a3)
L067_00001DDA:
; H067+$00001DDA: 6600000c  bne.w $1de8
        bne.w H067+$1DE8
L067_00001DDE:
; H067+$00001DDE: 1b7c0001ff47  move.b #$1, -$b9(a5)
        move.b #$1, -$b9(a5)
L067_00001DE4:
; H067+$00001DE4: 6000085c  bra.w $2642
        bra.w H067+$2642
L067_00001DE8:
; H067+$00001DE8: 422dff47  clr.b -$b9(a5)
        clr.b -$b9(a5)
L067_00001DEC:
; H067+$00001DEC: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001DF0:
; H067+$00001DF0: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_00001DF4:
; H067+$00001DF4: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L067_00001DF6:
; H067+$00001DF6: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001DFC:
; H067+$00001DFC: 342b00fa  move.w $fa(a3), d2
        move.w $fa(a3), d2
L067_00001E00:
; H067+$00001E00: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_00001E02:
; H067+$00001E02: 4227  clr.b -(a7)
        clr.b -(a7)
L067_00001E04:
; H067+$00001E04: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_00001E08:
; H067+$00001E08: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L067_00001E0C:
; H067+$00001E0C: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L067_00001E10:
; H067+$00001E10: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L067_00001E16:
; H067+$00001E16: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001E1A:
; H067+$00001E1A: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L067_00001E1E:
; H067+$00001E1E: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L067_00001E20:
; H067+$00001E20: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001E26:
; H067+$00001E26: 342b00fc  move.w $fc(a3), d2
        move.w $fc(a3), d2
L067_00001E2A:
; H067+$00001E2A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_00001E2C:
; H067+$00001E2C: 4227  clr.b -(a7)
        clr.b -(a7)
L067_00001E2E:
; H067+$00001E2E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_00001E32:
; H067+$00001E32: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L067_00001E36:
; H067+$00001E36: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L067_00001E3A:
; H067+$00001E3A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
; STATO: H005+$3368 = personaggio corrente
L067_00001E40:
; H067+$00001E40: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001E46:
; H067+$00001E46: 342b00fa  move.w $fa(a3), d2
        move.w $fa(a3), d2
L067_00001E4A:
; H067+$00001E4A: 6000004a  bra.w $1e96
        bra.w H067+$1E96
L067_00001E4E:
; H067+$00001E4E: 47ec00c4  lea.l $c4(a4), a3
        lea.l $c4(a4), a3
L067_00001E52:
; H067+$00001E52: 45edff82  lea.l -$7e(a5), a2
        lea.l -$7e(a5), a2
L067_00001E56:
; H067+$00001E56: 7428  moveq #$28, d2
        moveq #40, d2
L067_00001E58:
; H067+$00001E58: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00001E5A:
; H067+$00001E5A: 57cafffc  dbeq d2, $1e58
        dbeq d2, H067+$1E58
L067_00001E5E:
; H067+$00001E5E: 4e75  rts 
        rts 
L067_00001E60:
; H067+$00001E60: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001E64:
; H067+$00001E64: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_00001E68:
; H067+$00001E68: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L067_00001E6C:
; H067+$00001E6C: 486c00c6  pea.l $c6(a4)
        pea.l $c6(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001E70:
; H067+$00001E70: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00001E76:
; H067+$00001E76: 4e75  rts 
        rts 
L067_00001E78:
; H067+$00001E78: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001E7C:
; H067+$00001E7C: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_00001E80:
; H067+$00001E80: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_00001E84:
; H067+$00001E84: 486c00cb  pea.l $cb(a4)
        pea.l $cb(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001E88:
; H067+$00001E88: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00001E8E:
; H067+$00001E8E: 4e75  rts 
        rts 
; Preserved bytes H067+$00001E90..$00001E96; code/data not fully classified.
        dc.w $FFE6,$FFBC,$FFCE
L067_00001E96:
; H067+$00001E96: 47fafffa  lea.l $1e92(pc), a3
        lea.l H067+$1E92(pc), a3
L067_00001E9A:
; H067+$00001E9A: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L067_00001E9E:
; H067+$00001E9E: 6302  bls.b $1ea2
        bls.b H067+$1EA2
L067_00001EA0:
; H067+$00001EA0: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00001EA2:
; H067+$00001EA2: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001EA4:
; H067+$00001EA4: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H067+$1E92; indici 0..1, default -1.
L067_00001EA8:
; H067+$00001EA8: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
; STATO: H005+$3368 = personaggio corrente
L067_00001EAC:
; H067+$00001EAC: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001EB2:
; H067+$00001EB2: 342b00fc  move.w $fc(a3), d2
        move.w $fc(a3), d2
L067_00001EB6:
; H067+$00001EB6: 6000004a  bra.w $1f02
        bra.w H067+$1F02
L067_00001EBA:
; H067+$00001EBA: 47ec00d1  lea.l $d1(a4), a3
        lea.l $d1(a4), a3
L067_00001EBE:
; H067+$00001EBE: 45edff58  lea.l -$a8(a5), a2
        lea.l -$a8(a5), a2
L067_00001EC2:
; H067+$00001EC2: 7428  moveq #$28, d2
        moveq #40, d2
L067_00001EC4:
; H067+$00001EC4: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00001EC6:
; H067+$00001EC6: 57cafffc  dbeq d2, $1ec4
        dbeq d2, H067+$1EC4
L067_00001ECA:
; H067+$00001ECA: 4e75  rts 
        rts 
L067_00001ECC:
; H067+$00001ECC: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001ED0:
; H067+$00001ED0: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L067_00001ED4:
; H067+$00001ED4: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L067_00001ED8:
; H067+$00001ED8: 486c00d3  pea.l $d3(a4)
        pea.l $d3(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001EDC:
; H067+$00001EDC: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00001EE2:
; H067+$00001EE2: 4e75  rts 
        rts 
L067_00001EE4:
; H067+$00001EE4: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001EE8:
; H067+$00001EE8: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L067_00001EEC:
; H067+$00001EEC: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L067_00001EF0:
; H067+$00001EF0: 486c00e5  pea.l $e5(a4)
        pea.l $e5(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001EF4:
; H067+$00001EF4: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00001EFA:
; H067+$00001EFA: 4e75  rts 
        rts 
; Preserved bytes H067+$00001EFC..$00001F02; code/data not fully classified.
        dc.w $FFE6,$FFBC,$FFCE
L067_00001F02:
; H067+$00001F02: 47fafffa  lea.l $1efe(pc), a3
        lea.l H067+$1EFE(pc), a3
L067_00001F06:
; H067+$00001F06: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L067_00001F0A:
; H067+$00001F0A: 6302  bls.b $1f0e
        bls.b H067+$1F0E
L067_00001F0C:
; H067+$00001F0C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_00001F0E:
; H067+$00001F0E: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_00001F10:
; H067+$00001F10: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H067+$1EFE; indici 0..1, default -1.
L067_00001F14:
; H067+$00001F14: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L067_00001F18:
; H067+$00001F18: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001F1C:
; H067+$00001F1C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001F20:
; H067+$00001F20: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L067_00001F24:
; H067+$00001F24: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L067_00001F28:
; H067+$00001F28: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
; STATO: H005+$3368 = personaggio corrente
L067_00001F2E:
; H067+$00001F2E: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L067_00001F34:
; H067+$00001F34: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001F38:
; H067+$00001F38: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001F3C:
; H067+$00001F3C: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$1F34 (trampoline_H063_1F7E)
L067_00001F3E:
; H067+$00001F3E: 4eb900001f34  jsr $1f34.l
        jsr (H063+$1F34).l
L067_00001F44:
; H067+$00001F44: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001F48:
; H067+$00001F48: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L067_00001F4C:
; H067+$00001F4C: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_00001F50:
; H067+$00001F50: 4267  clr.w -(a7)
        clr.w -(a7)
L067_00001F52:
; H067+$00001F52: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
L067_00001F56:
; H067+$00001F56: 486c00f8  pea.l $f8(a4)
        pea.l $f8(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L067_00001F5A:
; H067+$00001F5A: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L067_00001F60:
; H067+$00001F60: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001F64:
; H067+$00001F64: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L067_00001F68:
; H067+$00001F68: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_00001F6C:
; H067+$00001F6C: 4267  clr.w -(a7)
        clr.w -(a7)
L067_00001F6E:
; H067+$00001F6E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001F72:
; H067+$00001F72: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L067_00001F76:
; H067+$00001F76: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L067_00001F7C:
; H067+$00001F7C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00001F80:
; H067+$00001F80: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_00001F84:
; H067+$00001F84: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_00001F88:
; H067+$00001F88: 4267  clr.w -(a7)
        clr.w -(a7)
L067_00001F8A:
; H067+$00001F8A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001F8E:
; H067+$00001F8E: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L067_00001F92:
; H067+$00001F92: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L067_00001F98:
; H067+$00001F98: 47ec0119  lea.l $119(a4), a3
        lea.l $119(a4), a3
L067_00001F9C:
; H067+$00001F9C: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L067_00001FA0:
; H067+$00001FA0: 7428  moveq #$28, d2
        moveq #40, d2
L067_00001FA2:
; H067+$00001FA2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00001FA4:
; H067+$00001FA4: 57cafffc  dbeq d2, $1fa2
        dbeq d2, H067+$1FA2
; STATO: H005+$3368 = personaggio corrente
L067_00001FA8:
; H067+$00001FA8: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001FAE:
; H067+$00001FAE: 4a6b00fa  tst.w $fa(a3)
        tst.w $fa(a3)
L067_00001FB2:
; H067+$00001FB2: 67000012  beq.w $1fc6
        beq.w H067+$1FC6
L067_00001FB6:
; H067+$00001FB6: 47ec011b  lea.l $11b(a4), a3
        lea.l $11b(a4), a3
L067_00001FBA:
; H067+$00001FBA: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L067_00001FBE:
; H067+$00001FBE: 7428  moveq #$28, d2
        moveq #40, d2
L067_00001FC0:
; H067+$00001FC0: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00001FC2:
; H067+$00001FC2: 57cafffc  dbeq d2, $1fc0
        dbeq d2, H067+$1FC0
; STATO: H005+$3368 = personaggio corrente
L067_00001FC6:
; H067+$00001FC6: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00001FCC:
; H067+$00001FCC: 4a6b00fc  tst.w $fc(a3)
        tst.w $fc(a3)
L067_00001FD0:
; H067+$00001FD0: 67000018  beq.w $1fea
        beq.w H067+$1FEA
L067_00001FD4:
; H067+$00001FD4: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001FD8:
; H067+$00001FD8: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L067_00001FDC:
; H067+$00001FDC: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L067_00001FE0:
; H067+$00001FE0: 486c0122  pea.l $122(a4)
        pea.l $122(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001FE4:
; H067+$00001FE4: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00001FEA:
; H067+$00001FEA: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00001FEE:
; H067+$00001FEE: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L067_00001FF2:
; H067+$00001FF2: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L067_00001FF6:
; H067+$00001FF6: 486c012c  pea.l $12c(a4)
        pea.l $12c(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_00001FFA:
; H067+$00001FFA: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00002000:
; H067+$00002000: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_00002004:
; H067+$00002004: 486c0132  pea.l $132(a4)
        pea.l $132(a4)
L067_00002008:
; H067+$00002008: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_0000200C:
; H067+$0000200C: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L067_00002010:
; H067+$00002010: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_00002014:
; H067+$00002014: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_00002018:
; H067+$00002018: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_0000201C:
; H067+$0000201C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L067_00002020:
; H067+$00002020: 4227  clr.b -(a7)
        clr.b -(a7)
L067_00002022:
; H067+$00002022: 486dff46  pea.l -$ba(a5)
        pea.l -$ba(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L067_00002026:
; H067+$00002026: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L067_0000202C:
; H067+$0000202C: 1b40ff57  move.b d0, -$a9(a5)
        move.b d0, -$a9(a5)
L067_00002030:
; H067+$00002030: 7400  moveq #$0, d2
        moveq #0, d2
L067_00002032:
; H067+$00002032: 142dff57  move.b -$a9(a5), d2
        move.b -$a9(a5), d2
L067_00002036:
; H067+$00002036: 600005e8  bra.w $2620
        bra.w H067+$2620
; STATO: H005+$3368 = personaggio corrente
L067_0000203A:
; H067+$0000203A: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00002040:
; H067+$00002040: 4a6b00fa  tst.w $fa(a3)
        tst.w $fa(a3)
L067_00002044:
; H067+$00002044: 67000244  beq.w $228a
        beq.w H067+$228A
; STATO: H005+$3368 = personaggio corrente
L067_00002048:
; H067+$00002048: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_0000204E:
; H067+$0000204E: 536b00fa  subq.w #$1, $fa(a3)
        subq.w #$1, $fa(a3)
L067_00002052:
; H067+$00002052: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00002056:
; H067+$00002056: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_0000205A:
; H067+$0000205A: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_00002060:
; H067+$00002060: 3b40ff54  move.w d0, -$ac(a5)
        move.w d0, -$ac(a5)
L067_00002064:
; H067+$00002064: 0c6d001aff54  cmpi.w #$1a, -$ac(a5)
        cmpi.w #$1a, -$ac(a5)
L067_0000206A:
; H067+$0000206A: 6400000c  bcc.w $2078
        bcc.w H067+$2078
L067_0000206E:
; H067+$0000206E: 3b7c0005ff52  move.w #$5, -$ae(a5)
        move.w #$5, -$ae(a5)
L067_00002074:
; H067+$00002074: 60000058  bra.w $20ce
        bra.w H067+$20CE
L067_00002078:
; H067+$00002078: 0c6d0033ff54  cmpi.w #$33, -$ac(a5)
        cmpi.w #$33, -$ac(a5)
L067_0000207E:
; H067+$0000207E: 6400000c  bcc.w $208c
        bcc.w H067+$208C
L067_00002082:
; H067+$00002082: 3b7c0019ff52  move.w #$19, -$ae(a5)
        move.w #$19, -$ae(a5)
L067_00002088:
; H067+$00002088: 60000044  bra.w $20ce
        bra.w H067+$20CE
L067_0000208C:
; H067+$0000208C: 0c6d0047ff54  cmpi.w #$47, -$ac(a5)
        cmpi.w #$47, -$ac(a5)
L067_00002092:
; H067+$00002092: 6400000c  bcc.w $20a0
        bcc.w H067+$20A0
L067_00002096:
; H067+$00002096: 3b7c0032ff52  move.w #$32, -$ae(a5)
        move.w #$32, -$ae(a5)
L067_0000209C:
; H067+$0000209C: 60000030  bra.w $20ce
        bra.w H067+$20CE
L067_000020A0:
; H067+$000020A0: 0c6d005bff54  cmpi.w #$5b, -$ac(a5)
        cmpi.w #$5b, -$ac(a5)
L067_000020A6:
; H067+$000020A6: 6400000c  bcc.w $20b4
        bcc.w H067+$20B4
L067_000020AA:
; H067+$000020AA: 3b7c00faff52  move.w #$fa, -$ae(a5)
        move.w #$fa, -$ae(a5)
L067_000020B0:
; H067+$000020B0: 6000001c  bra.w $20ce
        bra.w H067+$20CE
L067_000020B4:
; H067+$000020B4: 0c6d0064ff54  cmpi.w #$64, -$ac(a5)
        cmpi.w #$64, -$ac(a5)
L067_000020BA:
; H067+$000020BA: 6400000c  bcc.w $20c8
        bcc.w H067+$20C8
L067_000020BE:
; H067+$000020BE: 3b7c01f4ff52  move.w #$1f4, -$ae(a5)
        move.w #$1f4, -$ae(a5)
L067_000020C4:
; H067+$000020C4: 60000008  bra.w $20ce
        bra.w H067+$20CE
L067_000020C8:
; H067+$000020C8: 3b7c09c4ff52  move.w #$9c4, -$ae(a5)
        move.w #$9c4, -$ae(a5)
L067_000020CE:
; H067+$000020CE: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_000020D2:
; H067+$000020D2: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_000020D6:
; H067+$000020D6: 7400  moveq #$0, d2
        moveq #0, d2
L067_000020D8:
; H067+$000020D8: 342dff52  move.w -$ae(a5), d2
        move.w -$ae(a5), d2
L067_000020DC:
; H067+$000020DC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_000020DE:
; H067+$000020DE: 4227  clr.b -(a7)
        clr.b -(a7)
L067_000020E0:
; H067+$000020E0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_000020E4:
; H067+$000020E4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L067_000020E8:
; H067+$000020E8: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L067_000020EC:
; H067+$000020EC: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L067_000020F2:
; H067+$000020F2: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_000020F6:
; H067+$000020F6: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_000020FA:
; H067+$000020FA: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
L067_000020FE:
; H067+$000020FE: 486c0140  pea.l $140(a4)
        pea.l $140(a4)
L067_00002102:
; H067+$00002102: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H026+$0254 (sub_H026_00000254)
L067_00002104:
; H067+$00002104: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L067_0000210A:
; H067+$0000210A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_0000210E:
; H067+$0000210E: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_00002112:
; H067+$00002112: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L067_00002116:
; H067+$00002116: 486c0156  pea.l $156(a4)
        pea.l $156(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_0000211A:
; H067+$0000211A: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00002120:
; H067+$00002120: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00002124:
; H067+$00002124: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L067_00002128:
; H067+$00002128: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_0000212C:
; H067+$0000212C: 4267  clr.w -(a7)
        clr.w -(a7)
L067_0000212E:
; H067+$0000212E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00002132:
; H067+$00002132: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L067_00002136:
; H067+$00002136: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
; STATO: H005+$3368 = personaggio corrente
L067_0000213C:
; H067+$0000213C: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L067_00002142:
; H067+$00002142: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00002146:
; H067+$00002146: 486dff50  pea.l -$b0(a5)
        pea.l -$b0(a5)
L067_0000214A:
; H067+$0000214A: 6100e0e6  bsr.w $232
        bsr.w H067+$232
L067_0000214E:
; H067+$0000214E: 1400  move.b d0, d2
        move.b d0, d2
L067_00002150:
; H067+$00002150: 4a02  tst.b d2
        tst.b d2
L067_00002152:
; H067+$00002152: 66000016  bne.w $216a
        bne.w H067+$216A
L067_00002156:
; H067+$00002156: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L067_00002158:
; H067+$00002158: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_0000215E:
; H067+$0000215E: 142b014f  move.b $14f(a3), d2
        move.b $14f(a3), d2
L067_00002162:
; H067+$00002162: 0c420010  cmpi.w #$10, d2
        cmpi.w #$10, d2
L067_00002166:
; H067+$00002166: 6500001c  bcs.w $2184
        bcs.w H067+$2184
L067_0000216A:
; H067+$0000216A: 47ec015e  lea.l $15e(a4), a3
        lea.l $15e(a4), a3
L067_0000216E:
; H067+$0000216E: 45edffac  lea.l -$54(a5), a2
        lea.l -$54(a5), a2
L067_00002172:
; H067+$00002172: 7428  moveq #$28, d2
        moveq #40, d2
L067_00002174:
; H067+$00002174: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00002176:
; H067+$00002176: 57cafffc  dbeq d2, $2174
        dbeq d2, H067+$2174
L067_0000217A:
; H067+$0000217A: 1b7c0001ff45  move.b #$1, -$bb(a5)
        move.b #$1, -$bb(a5)
L067_00002180:
; H067+$00002180: 60000016  bra.w $2198
        bra.w H067+$2198
L067_00002184:
; H067+$00002184: 47ec0163  lea.l $163(a4), a3
        lea.l $163(a4), a3
L067_00002188:
; H067+$00002188: 45edffac  lea.l -$54(a5), a2
        lea.l -$54(a5), a2
L067_0000218C:
; H067+$0000218C: 7428  moveq #$28, d2
        moveq #40, d2
L067_0000218E:
; H067+$0000218E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00002190:
; H067+$00002190: 57cafffc  dbeq d2, $218e
        dbeq d2, H067+$218E
L067_00002194:
; H067+$00002194: 422dff45  clr.b -$bb(a5)
        clr.b -$bb(a5)
L067_00002198:
; H067+$00002198: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L067_0000219C:
; H067+$0000219C: 486c016d  pea.l $16d(a4)
        pea.l $16d(a4)
L067_000021A0:
; H067+$000021A0: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_000021A4:
; H067+$000021A4: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L067_000021A8:
; H067+$000021A8: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_000021AC:
; H067+$000021AC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_000021B0:
; H067+$000021B0: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_000021B4:
; H067+$000021B4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L067_000021B8:
; H067+$000021B8: 4227  clr.b -(a7)
        clr.b -(a7)
L067_000021BA:
; H067+$000021BA: 486dff46  pea.l -$ba(a5)
        pea.l -$ba(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L067_000021BE:
; H067+$000021BE: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L067_000021C4:
; H067+$000021C4: 1b40ff57  move.b d0, -$a9(a5)
        move.b d0, -$a9(a5)
L067_000021C8:
; H067+$000021C8: 0c2d004bff57  cmpi.b #$4b, -$a9(a5)
        cmpi.b #$4b, -$a9(a5)
L067_000021CE:
; H067+$000021CE: 660000b2  bne.w $2282
        bne.w H067+$2282
L067_000021D2:
; H067+$000021D2: 4a2dff45  tst.b -$bb(a5)
        tst.b -$bb(a5)
L067_000021D6:
; H067+$000021D6: 660000aa  bne.w $2282
        bne.w H067+$2282
L067_000021DA:
; H067+$000021DA: 7448  moveq #$48, d2
        moveq #72, d2
L067_000021DC:
; H067+$000021DC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_000021DE:
; H067+$000021DE: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L067_000021E4:
; H067+$000021E4: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L067_000021EA:
; H067+$000021EA: 2b40ff48  move.l d0, -$b8(a5)
        move.l d0, -$b8(a5)
L067_000021EE:
; H067+$000021EE: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_000021F2:
; H067+$000021F2: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L067_000021F6:
; H067+$000021F6: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_000021FA:
; H067+$000021FA: 422b003a  clr.b $3a(a3)
        clr.b $3a(a3)
L067_000021FE:
; H067+$000021FE: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_00002202:
; H067+$00002202: 177c007a0034  move.b #$7a, $34(a3)
        move.b #$7a, $34(a3)
L067_00002208:
; H067+$00002208: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_0000220C:
; H067+$0000220C: 422b0033  clr.b $33(a3)
        clr.b $33(a3)
L067_00002210:
; H067+$00002210: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_00002214:
; H067+$00002214: 422b0032  clr.b $32(a3)
        clr.b $32(a3)
L067_00002218:
; H067+$00002218: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_0000221C:
; H067+$0000221C: 177c002f0030  move.b #$2f, $30(a3)
        move.b #$2f, $30(a3)
L067_00002222:
; H067+$00002222: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_00002226:
; H067+$00002226: 376dff520042  move.w -$ae(a5), $42(a3)
        move.w -$ae(a5), $42(a3)
L067_0000222C:
; H067+$0000222C: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_00002230:
; H067+$00002230: 377c0001003e  move.w #$1, $3e(a3)
        move.w #$1, $3e(a3)
L067_00002236:
; H067+$00002236: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_0000223A:
; H067+$0000223A: 422b003b  clr.b $3b(a3)
        clr.b $3b(a3)
; STATO: H005+$3368 = personaggio corrente
L067_0000223E:
; H067+$0000223E: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00002244:
; H067+$00002244: 2b6b0150ff4c  move.l $150(a3), -$b4(a5)
        move.l $150(a3), -$b4(a5)
L067_0000224A:
; H067+$0000224A: 4aadff4c  tst.l -$b4(a5)
        tst.l -$b4(a5)
L067_0000224E:
; H067+$0000224E: 6600000c  bne.w $225c
        bne.w H067+$225C
L067_00002252:
; H067+$00002252: 2b6dff48ff4c  move.l -$b8(a5), -$b4(a5)
        move.l -$b8(a5), -$b4(a5)
L067_00002258:
; H067+$00002258: 60000024  bra.w $227e
        bra.w H067+$227E
L067_0000225C:
; H067+$0000225C: 266dff4c  movea.l -$b4(a5), a3
        movea.l -$b4(a5), a3
L067_00002260:
; H067+$00002260: 4aab002c  tst.l $2c(a3)
        tst.l $2c(a3)
L067_00002264:
; H067+$00002264: 6700000e  beq.w $2274
        beq.w H067+$2274
L067_00002268:
; H067+$00002268: 266dff4c  movea.l -$b4(a5), a3
        movea.l -$b4(a5), a3
L067_0000226C:
; H067+$0000226C: 2b6b002cff4c  move.l $2c(a3), -$b4(a5)
        move.l $2c(a3), -$b4(a5)
L067_00002272:
; H067+$00002272: 60e8  bra.b $225c
        bra.b H067+$225C
L067_00002274:
; H067+$00002274: 266dff4c  movea.l -$b4(a5), a3
        movea.l -$b4(a5), a3
L067_00002278:
; H067+$00002278: 276dff48002c  move.l -$b8(a5), $2c(a3)
        move.l -$b8(a5), $2c(a3)
L067_0000227E:
; H067+$0000227E: 6000000a  bra.w $228a
        bra.w H067+$228A
L067_00002282:
; H067+$00002282: 3f2dff52  move.w -$ae(a5), -(a7)
        move.w -$ae(a5), -(a7)
L067_00002286:
; H067+$00002286: 6100e134  bsr.w $3bc
        bsr.w H067+$3BC
L067_0000228A:
; H067+$0000228A: 4e75  rts 
        rts 
; STATO: H005+$3368 = personaggio corrente
L067_0000228C:
; H067+$0000228C: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00002292:
; H067+$00002292: 4a6b00fc  tst.w $fc(a3)
        tst.w $fc(a3)
L067_00002296:
; H067+$00002296: 670002e4  beq.w $257c
        beq.w H067+$257C
; STATO: H005+$3368 = personaggio corrente
L067_0000229A:
; H067+$0000229A: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_000022A0:
; H067+$000022A0: 536b00fc  subq.w #$1, $fc(a3)
        subq.w #$1, $fc(a3)
L067_000022A4:
; H067+$000022A4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_000022A8:
; H067+$000022A8: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L067_000022AC:
; H067+$000022AC: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L067_000022B2:
; H067+$000022B2: 3b40ff54  move.w d0, -$ac(a5)
        move.w d0, -$ac(a5)
L067_000022B6:
; H067+$000022B6: 0c6d0001ff54  cmpi.w #$1, -$ac(a5)
        cmpi.w #$1, -$ac(a5)
L067_000022BC:
; H067+$000022BC: 6600001e  bne.w $22dc
        bne.w H067+$22DC
L067_000022C0:
; H067+$000022C0: 243c000001c2  move.l #$1c2, d2
        move.l #$1c2, d2
L067_000022C6:
; H067+$000022C6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L067_000022C8:
; H067+$000022C8: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L067_000022CE:
; H067+$000022CE: 2400  move.l d0, d2
        move.l d0, d2
L067_000022D0:
; H067+$000022D0: 06420032  addi.w #$32, d2
        addi.w #$32, d2
L067_000022D4:
; H067+$000022D4: 3b42ff52  move.w d2, -$ae(a5)
        move.w d2, -$ae(a5)
L067_000022D8:
; H067+$000022D8: 600000d8  bra.w $23b2
        bra.w H067+$23B2
L067_000022DC:
; H067+$000022DC: 0c6d0002ff54  cmpi.w #$2, -$ac(a5)
        cmpi.w #$2, -$ac(a5)
L067_000022E2:
; H067+$000022E2: 6600001e  bne.w $2302
        bne.w H067+$2302
L067_000022E6:
; H067+$000022E6: 243c000001f4  move.l #$1f4, d2
        move.l #$1f4, d2
L067_000022EC:
; H067+$000022EC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L067_000022EE:
; H067+$000022EE: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L067_000022F4:
; H067+$000022F4: 2400  move.l d0, d2
        move.l d0, d2
L067_000022F6:
; H067+$000022F6: 06420064  addi.w #$64, d2
        addi.w #$64, d2
L067_000022FA:
; H067+$000022FA: 3b42ff52  move.w d2, -$ae(a5)
        move.w d2, -$ae(a5)
L067_000022FE:
; H067+$000022FE: 600000b2  bra.w $23b2
        bra.w H067+$23B2
L067_00002302:
; H067+$00002302: 0c6d0003ff54  cmpi.w #$3, -$ac(a5)
        cmpi.w #$3, -$ac(a5)
L067_00002308:
; H067+$00002308: 6600001e  bne.w $2328
        bne.w H067+$2328
L067_0000230C:
; H067+$0000230C: 243c000002ee  move.l #$2ee, d2
        move.l #$2ee, d2
L067_00002312:
; H067+$00002312: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L067_00002314:
; H067+$00002314: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L067_0000231A:
; H067+$0000231A: 2400  move.l d0, d2
        move.l d0, d2
L067_0000231C:
; H067+$0000231C: 06420096  addi.w #$96, d2
        addi.w #$96, d2
L067_00002320:
; H067+$00002320: 3b42ff52  move.w d2, -$ae(a5)
        move.w d2, -$ae(a5)
L067_00002324:
; H067+$00002324: 6000008c  bra.w $23b2
        bra.w H067+$23B2
L067_00002328:
; H067+$00002328: 0c6d0004ff54  cmpi.w #$4, -$ac(a5)
        cmpi.w #$4, -$ac(a5)
L067_0000232E:
; H067+$0000232E: 6600001e  bne.w $234e
        bne.w H067+$234E
L067_00002332:
; H067+$00002332: 243c000004e2  move.l #$4e2, d2
        move.l #$4e2, d2
L067_00002338:
; H067+$00002338: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L067_0000233A:
; H067+$0000233A: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L067_00002340:
; H067+$00002340: 2400  move.l d0, d2
        move.l d0, d2
L067_00002342:
; H067+$00002342: 064200fa  addi.w #$fa, d2
        addi.w #$fa, d2
L067_00002346:
; H067+$00002346: 3b42ff52  move.w d2, -$ae(a5)
        move.w d2, -$ae(a5)
L067_0000234A:
; H067+$0000234A: 60000066  bra.w $23b2
        bra.w H067+$23B2
L067_0000234E:
; H067+$0000234E: 0c6d0008ff54  cmpi.w #$8, -$ac(a5)
        cmpi.w #$8, -$ac(a5)
L067_00002354:
; H067+$00002354: 6400001e  bcc.w $2374
        bcc.w H067+$2374
L067_00002358:
; H067+$00002358: 243c000009c4  move.l #$9c4, d2
        move.l #$9c4, d2
L067_0000235E:
; H067+$0000235E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L067_00002360:
; H067+$00002360: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L067_00002366:
; H067+$00002366: 2400  move.l d0, d2
        move.l d0, d2
L067_00002368:
; H067+$00002368: 064201f4  addi.w #$1f4, d2
        addi.w #$1f4, d2
L067_0000236C:
; H067+$0000236C: 3b42ff52  move.w d2, -$ae(a5)
        move.w d2, -$ae(a5)
L067_00002370:
; H067+$00002370: 60000040  bra.w $23b2
        bra.w H067+$23B2
L067_00002374:
; H067+$00002374: 0c6d0009ff54  cmpi.w #$9, -$ac(a5)
        cmpi.w #$9, -$ac(a5)
L067_0000237A:
; H067+$0000237A: 6600001e  bne.w $239a
        bne.w H067+$239A
L067_0000237E:
; H067+$0000237E: 243c00000bb8  move.l #$bb8, d2
        move.l #$bb8, d2
L067_00002384:
; H067+$00002384: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L067_00002386:
; H067+$00002386: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L067_0000238C:
; H067+$0000238C: 2400  move.l d0, d2
        move.l d0, d2
L067_0000238E:
; H067+$0000238E: 064203e8  addi.w #$3e8, d2
        addi.w #$3e8, d2
L067_00002392:
; H067+$00002392: 3b42ff52  move.w d2, -$ae(a5)
        move.w d2, -$ae(a5)
L067_00002396:
; H067+$00002396: 6000001a  bra.w $23b2
        bra.w H067+$23B2
L067_0000239A:
; H067+$0000239A: 243c00001388  move.l #$1388, d2
        move.l #$1388, d2
L067_000023A0:
; H067+$000023A0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L067_000023A2:
; H067+$000023A2: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L067_000023A8:
; H067+$000023A8: 2400  move.l d0, d2
        move.l d0, d2
L067_000023AA:
; H067+$000023AA: 064203e8  addi.w #$3e8, d2
        addi.w #$3e8, d2
L067_000023AE:
; H067+$000023AE: 3b42ff52  move.w d2, -$ae(a5)
        move.w d2, -$ae(a5)
L067_000023B2:
; H067+$000023B2: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_000023B6:
; H067+$000023B6: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
L067_000023BA:
; H067+$000023BA: 7400  moveq #$0, d2
        moveq #0, d2
L067_000023BC:
; H067+$000023BC: 342dff52  move.w -$ae(a5), d2
        move.w -$ae(a5), d2
L067_000023C0:
; H067+$000023C0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_000023C2:
; H067+$000023C2: 4227  clr.b -(a7)
        clr.b -(a7)
L067_000023C4:
; H067+$000023C4: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_000023C8:
; H067+$000023C8: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L067_000023CC:
; H067+$000023CC: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L067_000023D0:
; H067+$000023D0: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L067_000023D6:
; H067+$000023D6: 47ec017a  lea.l $17a(a4), a3
        lea.l $17a(a4), a3
L067_000023DA:
; H067+$000023DA: 45edff82  lea.l -$7e(a5), a2
        lea.l -$7e(a5), a2
L067_000023DE:
; H067+$000023DE: 7428  moveq #$28, d2
        moveq #40, d2
L067_000023E0:
; H067+$000023E0: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_000023E2:
; H067+$000023E2: 57cafffc  dbeq d2, $23e0
        dbeq d2, H067+$23E0
L067_000023E6:
; H067+$000023E6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_000023EA:
; H067+$000023EA: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_000023EE:
; H067+$000023EE: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_000023F2:
; H067+$000023F2: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L067_000023F6:
; H067+$000023F6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_000023FC:
; H067+$000023FC: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00002400:
; H067+$00002400: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
L067_00002404:
; H067+$00002404: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L067_00002408:
; H067+$00002408: 486c0192  pea.l $192(a4)
        pea.l $192(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L067_0000240C:
; H067+$0000240C: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L067_00002412:
; H067+$00002412: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00002416:
; H067+$00002416: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L067_0000241A:
; H067+$0000241A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_0000241E:
; H067+$0000241E: 4267  clr.w -(a7)
        clr.w -(a7)
L067_00002420:
; H067+$00002420: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00002424:
; H067+$00002424: 486dff82  pea.l -$7e(a5)
        pea.l -$7e(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L067_00002428:
; H067+$00002428: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
; STATO: H005+$3368 = personaggio corrente
L067_0000242E:
; H067+$0000242E: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L067_00002434:
; H067+$00002434: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L067_00002438:
; H067+$00002438: 486dff50  pea.l -$b0(a5)
        pea.l -$b0(a5)
L067_0000243C:
; H067+$0000243C: 6100ddf4  bsr.w $232
        bsr.w H067+$232
L067_00002440:
; H067+$00002440: 1400  move.b d0, d2
        move.b d0, d2
L067_00002442:
; H067+$00002442: 4a02  tst.b d2
        tst.b d2
L067_00002444:
; H067+$00002444: 66000016  bne.w $245c
        bne.w H067+$245C
L067_00002448:
; H067+$00002448: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L067_0000244A:
; H067+$0000244A: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00002450:
; H067+$00002450: 142b014f  move.b $14f(a3), d2
        move.b $14f(a3), d2
L067_00002454:
; H067+$00002454: 0c420010  cmpi.w #$10, d2
        cmpi.w #$10, d2
L067_00002458:
; H067+$00002458: 6500001c  bcs.w $2476
        bcs.w H067+$2476
L067_0000245C:
; H067+$0000245C: 47ec019a  lea.l $19a(a4), a3
        lea.l $19a(a4), a3
L067_00002460:
; H067+$00002460: 45edffac  lea.l -$54(a5), a2
        lea.l -$54(a5), a2
L067_00002464:
; H067+$00002464: 7428  moveq #$28, d2
        moveq #40, d2
L067_00002466:
; H067+$00002466: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00002468:
; H067+$00002468: 57cafffc  dbeq d2, $2466
        dbeq d2, H067+$2466
L067_0000246C:
; H067+$0000246C: 1b7c0001ff45  move.b #$1, -$bb(a5)
        move.b #$1, -$bb(a5)
L067_00002472:
; H067+$00002472: 60000016  bra.w $248a
        bra.w H067+$248A
L067_00002476:
; H067+$00002476: 47ec019f  lea.l $19f(a4), a3
        lea.l $19f(a4), a3
L067_0000247A:
; H067+$0000247A: 45edffac  lea.l -$54(a5), a2
        lea.l -$54(a5), a2
L067_0000247E:
; H067+$0000247E: 7428  moveq #$28, d2
        moveq #40, d2
L067_00002480:
; H067+$00002480: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L067_00002482:
; H067+$00002482: 57cafffc  dbeq d2, $2480
        dbeq d2, H067+$2480
L067_00002486:
; H067+$00002486: 422dff45  clr.b -$bb(a5)
        clr.b -$bb(a5)
L067_0000248A:
; H067+$0000248A: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L067_0000248E:
; H067+$0000248E: 486c01a9  pea.l $1a9(a4)
        pea.l $1a9(a4)
L067_00002492:
; H067+$00002492: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L067_00002496:
; H067+$00002496: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L067_0000249A:
; H067+$0000249A: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L067_0000249E:
; H067+$0000249E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L067_000024A2:
; H067+$000024A2: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L067_000024A6:
; H067+$000024A6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L067_000024AA:
; H067+$000024AA: 4227  clr.b -(a7)
        clr.b -(a7)
L067_000024AC:
; H067+$000024AC: 486dff46  pea.l -$ba(a5)
        pea.l -$ba(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L067_000024B0:
; H067+$000024B0: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L067_000024B6:
; H067+$000024B6: 1b40ff57  move.b d0, -$a9(a5)
        move.b d0, -$a9(a5)
L067_000024BA:
; H067+$000024BA: 0c2d004bff57  cmpi.b #$4b, -$a9(a5)
        cmpi.b #$4b, -$a9(a5)
L067_000024C0:
; H067+$000024C0: 660000b2  bne.w $2574
        bne.w H067+$2574
L067_000024C4:
; H067+$000024C4: 4a2dff45  tst.b -$bb(a5)
        tst.b -$bb(a5)
L067_000024C8:
; H067+$000024C8: 660000aa  bne.w $2574
        bne.w H067+$2574
L067_000024CC:
; H067+$000024CC: 7448  moveq #$48, d2
        moveq #72, d2
L067_000024CE:
; H067+$000024CE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L067_000024D0:
; H067+$000024D0: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L067_000024D6:
; H067+$000024D6: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L067_000024DC:
; H067+$000024DC: 2b40ff48  move.l d0, -$b8(a5)
        move.l d0, -$b8(a5)
L067_000024E0:
; H067+$000024E0: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_000024E4:
; H067+$000024E4: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L067_000024E8:
; H067+$000024E8: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_000024EC:
; H067+$000024EC: 422b003a  clr.b $3a(a3)
        clr.b $3a(a3)
L067_000024F0:
; H067+$000024F0: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_000024F4:
; H067+$000024F4: 177c007b0034  move.b #$7b, $34(a3)
        move.b #$7b, $34(a3)
L067_000024FA:
; H067+$000024FA: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_000024FE:
; H067+$000024FE: 422b0033  clr.b $33(a3)
        clr.b $33(a3)
L067_00002502:
; H067+$00002502: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_00002506:
; H067+$00002506: 422b0032  clr.b $32(a3)
        clr.b $32(a3)
L067_0000250A:
; H067+$0000250A: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_0000250E:
; H067+$0000250E: 177c002f0030  move.b #$2f, $30(a3)
        move.b #$2f, $30(a3)
L067_00002514:
; H067+$00002514: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_00002518:
; H067+$00002518: 376dff520042  move.w -$ae(a5), $42(a3)
        move.w -$ae(a5), $42(a3)
L067_0000251E:
; H067+$0000251E: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_00002522:
; H067+$00002522: 377c0001003e  move.w #$1, $3e(a3)
        move.w #$1, $3e(a3)
L067_00002528:
; H067+$00002528: 266dff48  movea.l -$b8(a5), a3
        movea.l -$b8(a5), a3
L067_0000252C:
; H067+$0000252C: 422b003b  clr.b $3b(a3)
        clr.b $3b(a3)
; STATO: H005+$3368 = personaggio corrente
L067_00002530:
; H067+$00002530: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L067_00002536:
; H067+$00002536: 2b6b0150ff4c  move.l $150(a3), -$b4(a5)
        move.l $150(a3), -$b4(a5)
L067_0000253C:
; H067+$0000253C: 4aadff4c  tst.l -$b4(a5)
        tst.l -$b4(a5)
L067_00002540:
; H067+$00002540: 6600000c  bne.w $254e
        bne.w H067+$254E
L067_00002544:
; H067+$00002544: 2b6dff48ff4c  move.l -$b8(a5), -$b4(a5)
        move.l -$b8(a5), -$b4(a5)
L067_0000254A:
; H067+$0000254A: 60000024  bra.w $2570
        bra.w H067+$2570
L067_0000254E:
; H067+$0000254E: 266dff4c  movea.l -$b4(a5), a3
        movea.l -$b4(a5), a3
L067_00002552:
; H067+$00002552: 4aab002c  tst.l $2c(a3)
        tst.l $2c(a3)
L067_00002556:
; H067+$00002556: 6700000e  beq.w $2566
        beq.w H067+$2566
L067_0000255A:
; H067+$0000255A: 266dff4c  movea.l -$b4(a5), a3
        movea.l -$b4(a5), a3
L067_0000255E:
; H067+$0000255E: 2b6b002cff4c  move.l $2c(a3), -$b4(a5)
        move.l $2c(a3), -$b4(a5)
L067_00002564:
; H067+$00002564: 60e8  bra.b $254e
        bra.b H067+$254E
L067_00002566:
; H067+$00002566: 266dff4c  movea.l -$b4(a5), a3
        movea.l -$b4(a5), a3
L067_0000256A:
; H067+$0000256A: 276dff48002c  move.l -$b8(a5), $2c(a3)
        move.l -$b8(a5), $2c(a3)
L067_00002570:
; H067+$00002570: 6000000a  bra.w $257c
        bra.w H067+$257C
L067_00002574:
; H067+$00002574: 3f2dff52  move.w -$ae(a5), -(a7)
        move.w -$ae(a5), -(a7)
L067_00002578:
; H067+$00002578: 6100de42  bsr.w $3bc
        bsr.w H067+$3BC
L067_0000257C:
; H067+$0000257C: 4e75  rts 
        rts 
L067_0000257E:
; H067+$0000257E: 1b7c0001ff47  move.b #$1, -$b9(a5)
        move.b #$1, -$b9(a5)
L067_00002584:
; H067+$00002584: 4e75  rts 
        rts 
L067_00002586:
; H067+$00002586: 4e75  rts 
        rts 
; Preserved bytes H067+$00002588..$00002620; code/data not fully classified.
        dc.w $FFFC,$FFF4,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFF4,$FFFC
        dc.w $FAB0,$FFFC,$FFFC,$FD02
L067_00002620:
; H067+$00002620: 47faff68  lea.l $258a(pc), a3
        lea.l H067+$258A(pc), a3
L067_00002624:
; H067+$00002624: 0c42004a  cmpi.w #$4a, d2
        cmpi.w #$4a, d2
L067_00002628:
; H067+$00002628: 6302  bls.b $262c
        bls.b H067+$262C
L067_0000262A:
; H067+$0000262A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L067_0000262C:
; H067+$0000262C: e342  asl.w #$1, d2
        asl.w #$1, d2
L067_0000262E:
; H067+$0000262E: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H067+$258A; indici 0..74, default -1.
L067_00002632:
; H067+$00002632: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
; STATO: H005+$3368 = personaggio corrente
L067_00002636:
; H067+$00002636: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L067_0000263C:
; H067+$0000263C: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L067_00002642:
; H067+$00002642: 4a2dff47  tst.b -$b9(a5)
        tst.b -$b9(a5)
L067_00002646:
; H067+$00002646: 6700f77a  beq.w $1dc2
        beq.w H067+$1DC2
L067_0000264A:
; H067+$0000264A: 4e5d  unlk a5
        unlk a5
L067_0000264C:
; H067+$0000264C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_0000264E:
; H067+$0000264E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L067_00002650:
; H067+$00002650: 588f  addq.l #$4, a7
        addq.l #$4, a7
L067_00002652:
; H067+$00002652: 4ed0  jmp (a0)
        jmp (a0)
L067_00002654:
; H067+$00002654: 4e5d  unlk a5
        unlk a5
L067_00002656:
; H067+$00002656: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L067_00002658:
; H067+$00002658: 4e75  rts 
        rts 
; Preserved bytes H067+$0000265A..$0000265C; code/data not fully classified.
        dc.w $0000
; End H067: $265C bytes
