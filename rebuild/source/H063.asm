; ============================================================================
; GUIDA DEL MODULO H063
; Helper per personaggi, inventario e aggiornamento UI; mappa parziale.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Personaggi, inventario e aggiornamento UI: 52 funzioni, fra cui copia/confronto stringhe, stato del personaggio, liste di oggetti e refresh della scheda.
; --------------------------------------------------------------------------
; H063: 16496 original bytes; all offsets are section-relative.
        section H063,code
H063:
; Preserved bytes H063+$00000000..$00000104; code/data not fully classified.
        dc.w $0000,$0000,$2059,$6573,$2020,$0020,$4E6F,$2020
        dc.w $2000,$2A20,$0020,$0020,$0073,$2000,$2000,$4E61
        dc.w $6D65,$0041,$4320,$2048,$5000,$2D00,$2F00,$2000
        dc.w $4869,$7470,$6F69,$6E74,$7300,$4143,$0028,$4865
        dc.w $6C70,$6C65,$7373,$2900,$2843,$6173,$7469,$6E67
        dc.w $2900,$4E69,$6C20,$4974,$656D,$2070,$6F69,$6E74
        dc.w $6572,$2E2E,$2E00,$5472,$6965,$6420,$746F,$204C
        dc.w $6F73,$6520,$6974,$656D,$2026,$2063,$6F75,$6C64
        dc.w $6E27,$7420,$6669,$6E64,$2069,$7421,$0027,$7300
        dc.w $6973,$2066,$756C,$6C79,$2068,$6561,$6C65,$6400
        dc.w $6973,$2070,$6172,$7469,$616C,$6C79,$2068,$6561
        dc.w $6C65,$6400,$4775,$6172,$6469,$6E67,$0050,$4943
        dc.w $0050,$4943,$0000,$002C,$0020,$0020,$003A,$002A
        dc.w $0020,$6361,$6D70,$696E,$6700,$2073,$6561,$7263
        dc.w $6800,$6973,$2062,$616E,$6461,$6765,$6400,$0000
        dc.w $2000,$2045,$7869,$7400,$5365,$6C65,$6374,$0000
        dc.l H063+$00000002
; --------------------------------------------------------------------------
; ROUTINE: module_init_H063 [parziale]
; Scopo: Ingresso del modulo helper per personaggi, inventario e aggiornamento UI; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H063+$406A.
; Chiamanti diretti: H000+$01B6
; --------------------------------------------------------------------------
L063_00000104:
; H063+$00000104: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00000106:
; H063+$00000106: 287afff8  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000010A:
; H063+$0000010A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_0000010E:
; H063+$0000010E: 60003f5a  bra.w $406a
        bra.w H063+$406A
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00000112 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H062+$2272, H063+$0FE6, H063+$10AC, H063+$1116, H064+$0DB8, H065+$0F7E e altri 6
; --------------------------------------------------------------------------
L063_00000112:
; H063+$00000112: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00000114:
; H063+$00000114: 287affea  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00000118:
; H063+$00000118: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_0000011C:
; H063+$0000011C: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000011E:
; H063+$0000011E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000122:
; H063+$00000122: 0c3300202000  cmpi.b #$20, (a3, d2.w)
        cmpi.b #$20, (a3, d2.w)
L063_00000128:
; H063+$00000128: 66000036  bne.w $160
        bne.w H063+$160
L063_0000012C:
; H063+$0000012C: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_00000130:
; H063+$00000130: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000134:
; H063+$00000134: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000138:
; H063+$00000138: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L063_0000013C:
; H063+$0000013C: 67000020  beq.w $15e
        beq.w H063+$15E
L063_00000140:
; H063+$00000140: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000144:
; H063+$00000144: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000148:
; H063+$00000148: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L063_0000014C:
; H063+$0000014C: 5244  addq.w #$1, d4
        addq.w #$1, d4
L063_0000014E:
; H063+$0000014E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00000152:
; H063+$00000152: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L063_00000158:
; H063+$00000158: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L063_0000015C:
; H063+$0000015C: 60d2  bra.b $130
        bra.b H063+$130
L063_0000015E:
; H063+$0000015E: 60bc  bra.b $11c
        bra.b H063+$11C
L063_00000160:
; H063+$00000160: 4e5d  unlk a5
        unlk a5
L063_00000162:
; H063+$00000162: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00000164:
; H063+$00000164: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00000166:
; H063+$00000166: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L063_00000168:
; H063+$00000168: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_0000016A [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$05A8, H063+$04A2, H096+$039E
; --------------------------------------------------------------------------
L063_0000016A:
; H063+$0000016A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000016C:
; H063+$0000016C: 287aff92  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00000170:
; H063+$00000170: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_00000174:
; H063+$00000174: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000176:
; H063+$00000176: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000017A:
; H063+$0000017A: 142b0017  move.b $17(a3), d2
        move.b $17(a3), d2
L063_0000017E:
; H063+$0000017E: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00000182:
; H063+$00000182: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000186:
; H063+$00000186: 60000078  bra.w $200
        bra.w H063+$200
L063_0000018A:
; H063+$0000018A: 3b7cfffcfffc  move.w #$fffc, -$4(a5)
        move.w #$fffc, -$4(a5)
L063_00000190:
; H063+$00000190: 4e75  rts 
        rts 
L063_00000192:
; H063+$00000192: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000196:
; H063+$00000196: 5d42  subq.w #$6, d2
        subq.w #$6, d2
L063_00000198:
; H063+$00000198: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_0000019C:
; H063+$0000019C: 4e75  rts 
        rts 
L063_0000019E:
; H063+$0000019E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_000001A2:
; H063+$000001A2: 0442000f  subi.w #$f, d2
        subi.w #$f, d2
L063_000001A6:
; H063+$000001A6: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_000001AA:
; H063+$000001AA: 4e75  rts 
        rts 
L063_000001AC:
; H063+$000001AC: 3b7c0003fffc  move.w #$3, -$4(a5)
        move.w #$3, -$4(a5)
L063_000001B2:
; H063+$000001B2: 4e75  rts 
        rts 
L063_000001B4:
; H063+$000001B4: 3b7c0004fffc  move.w #$4, -$4(a5)
        move.w #$4, -$4(a5)
L063_000001BA:
; H063+$000001BA: 4e75  rts 
        rts 
L063_000001BC:
; H063+$000001BC: 3b7c0005fffc  move.w #$5, -$4(a5)
        move.w #$5, -$4(a5)
L063_000001C2:
; H063+$000001C2: 4e75  rts 
        rts 
L063_000001C4:
; H063+$000001C4: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L063_000001C8:
; H063+$000001C8: 4e75  rts 
        rts 
; Preserved bytes H063+$000001CA..$00000200; code/data not fully classified.
        dc.w $FFF8,$FFBE,$FFBE,$FFBE,$FFC6,$FFC6,$FFC6,$FFF8
        dc.w $FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8
        dc.w $FFF8,$FFD2,$FFD2,$FFD2,$FFE0,$FFE0,$FFE8,$FFE8
        dc.w $FFE8,$FFF0,$FFF0
L063_00000200:
; H063+$00000200: 47faffca  lea.l $1cc(pc), a3
        lea.l H063+$1CC(pc), a3
L063_00000204:
; H063+$00000204: 0c420019  cmpi.w #$19, d2
        cmpi.w #$19, d2
L063_00000208:
; H063+$00000208: 6302  bls.b $20c
        bls.b H063+$20C
L063_0000020A:
; H063+$0000020A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_0000020C:
; H063+$0000020C: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_0000020E:
; H063+$0000020E: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$01CC; indici 0..25, default -1.
L063_00000212:
; H063+$00000212: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00000216:
; H063+$00000216: 302dfffc  move.w -$4(a5), d0
        move.w -$4(a5), d0
L063_0000021A:
; H063+$0000021A: 60000002  bra.w $21e
        bra.w H063+$21E
L063_0000021E:
; H063+$0000021E: 4e5d  unlk a5
        unlk a5
L063_00000220:
; H063+$00000220: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00000222:
; H063+$00000222: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00000224:
; H063+$00000224: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00000226:
; H063+$00000226: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_032C [parziale]
; Scopo: Trampolino verso H063+$032C; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$032C.
; Chiamanti diretti: H063+$19C8, H063+$0366, H063+$1A98
; --------------------------------------------------------------------------
L063_00000228:
; H063+$00000228: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000022A:
; H063+$0000022A: 287afed4  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000022E:
; H063+$0000022E: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_00000232:
; H063+$00000232: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000234:
; H063+$00000234: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000238:
; H063+$00000238: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L063_0000023C:
; H063+$0000023C: 600000ee  bra.w $32c
        bra.w H063+$32C
L063_00000240:
; H063+$00000240: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000242:
; H063+$00000242: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000246:
; H063+$00000246: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L063_0000024A:
; H063+$0000024A: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_0000024E:
; H063+$0000024E: 4e75  rts 
        rts 
L063_00000250:
; H063+$00000250: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000252:
; H063+$00000252: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000256:
; H063+$00000256: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L063_0000025A:
; H063+$0000025A: 4a42  tst.w d2
        tst.w d2
L063_0000025C:
; H063+$0000025C: 6600000c  bne.w $26a
        bne.w H063+$26A
L063_00000260:
; H063+$00000260: 3b7c0012fffe  move.w #$12, -$2(a5)
        move.w #$12, -$2(a5)
L063_00000266:
; H063+$00000266: 60000078  bra.w $2e0
        bra.w H063+$2E0
L063_0000026A:
; H063+$0000026A: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000026C:
; H063+$0000026C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000270:
; H063+$00000270: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L063_00000274:
; H063+$00000274: 0c420033  cmpi.w #$33, d2
        cmpi.w #$33, d2
L063_00000278:
; H063+$00000278: 6400000c  bcc.w $286
        bcc.w H063+$286
L063_0000027C:
; H063+$0000027C: 3b7c0013fffe  move.w #$13, -$2(a5)
        move.w #$13, -$2(a5)
L063_00000282:
; H063+$00000282: 6000005c  bra.w $2e0
        bra.w H063+$2E0
L063_00000286:
; H063+$00000286: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000288:
; H063+$00000288: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000028C:
; H063+$0000028C: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L063_00000290:
; H063+$00000290: 0c42004c  cmpi.w #$4c, d2
        cmpi.w #$4c, d2
L063_00000294:
; H063+$00000294: 6400000c  bcc.w $2a2
        bcc.w H063+$2A2
L063_00000298:
; H063+$00000298: 3b7c0014fffe  move.w #$14, -$2(a5)
        move.w #$14, -$2(a5)
L063_0000029E:
; H063+$0000029E: 60000040  bra.w $2e0
        bra.w H063+$2E0
L063_000002A2:
; H063+$000002A2: 7400  moveq #$0, d2
        moveq #0, d2
L063_000002A4:
; H063+$000002A4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000002A8:
; H063+$000002A8: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L063_000002AC:
; H063+$000002AC: 0c42005b  cmpi.w #$5b, d2
        cmpi.w #$5b, d2
L063_000002B0:
; H063+$000002B0: 6400000c  bcc.w $2be
        bcc.w H063+$2BE
L063_000002B4:
; H063+$000002B4: 3b7c0015fffe  move.w #$15, -$2(a5)
        move.w #$15, -$2(a5)
L063_000002BA:
; H063+$000002BA: 60000024  bra.w $2e0
        bra.w H063+$2E0
L063_000002BE:
; H063+$000002BE: 7400  moveq #$0, d2
        moveq #0, d2
L063_000002C0:
; H063+$000002C0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000002C4:
; H063+$000002C4: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L063_000002C8:
; H063+$000002C8: 0c420064  cmpi.w #$64, d2
        cmpi.w #$64, d2
L063_000002CC:
; H063+$000002CC: 6400000c  bcc.w $2da
        bcc.w H063+$2DA
L063_000002D0:
; H063+$000002D0: 3b7c0016fffe  move.w #$16, -$2(a5)
        move.w #$16, -$2(a5)
L063_000002D6:
; H063+$000002D6: 60000008  bra.w $2e0
        bra.w H063+$2E0
L063_000002DA:
; H063+$000002DA: 3b7c0017fffe  move.w #$17, -$2(a5)
        move.w #$17, -$2(a5)
L063_000002E0:
; H063+$000002E0: 4e75  rts 
        rts 
L063_000002E2:
; H063+$000002E2: 7400  moveq #$0, d2
        moveq #0, d2
L063_000002E4:
; H063+$000002E4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000002E8:
; H063+$000002E8: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L063_000002EC:
; H063+$000002EC: 5a42  addq.w #$5, d2
        addq.w #$5, d2
L063_000002EE:
; H063+$000002EE: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_000002F2:
; H063+$000002F2: 4e75  rts 
        rts 
L063_000002F4:
; H063+$000002F4: 4e75  rts 
        rts 
; Preserved bytes H063+$000002F6..$0000032C; code/data not fully classified.
        dc.w $FFFC,$FF48,$FF48,$FF48,$FF48,$FF48,$FF48,$FF48
        dc.w $FF48,$FF48,$FF48,$FF48,$FF48,$FF48,$FF48,$FF48
        dc.w $FF48,$FF48,$FF48,$FF58,$FFEA,$FFEA,$FFEA,$FFEA
        dc.w $FFEA,$FFEA,$FFEA
L063_0000032C:
; H063+$0000032C: 47faffca  lea.l $2f8(pc), a3
        lea.l H063+$2F8(pc), a3
L063_00000330:
; H063+$00000330: 0c420019  cmpi.w #$19, d2
        cmpi.w #$19, d2
L063_00000334:
; H063+$00000334: 6302  bls.b $338
        bls.b H063+$338
L063_00000336:
; H063+$00000336: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00000338:
; H063+$00000338: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_0000033A:
; H063+$0000033A: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$02F8; indici 0..25, default -1.
L063_0000033E:
; H063+$0000033E: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00000342:
; H063+$00000342: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L063_00000346:
; H063+$00000346: 60000002  bra.w $34a
        bra.w H063+$34A
L063_0000034A:
; H063+$0000034A: 4e5d  unlk a5
        unlk a5
L063_0000034C:
; H063+$0000034C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_0000034E:
; H063+$0000034E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00000350:
; H063+$00000350: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00000352:
; H063+$00000352: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00000354 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$055A, H063+$16DA, H063+$0504
; --------------------------------------------------------------------------
L063_00000354:
; H063+$00000354: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00000356:
; H063+$00000356: 287afda8  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000035A:
; H063+$0000035A: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_0000035E:
; H063+$0000035E: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L063_00000362:
; H063+$00000362: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00000366:
; H063+$00000366: 6100fec0  bsr.w $228
        bsr.w H063+$228
L063_0000036A:
; H063+$0000036A: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L063_0000036E:
; H063+$0000036E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000372:
; H063+$00000372: 4a2b011b  tst.b $11b(a3)
        tst.b $11b(a3)
L063_00000376:
; H063+$00000376: 670000a8  beq.w $420
        beq.w H063+$420
L063_0000037A:
; H063+$0000037A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000037E:
; H063+$0000037E: 60000088  bra.w $408
        bra.w H063+$408
L063_00000382:
; H063+$00000382: 3b7cfffdfffc  move.w #$fffd, -$4(a5)
        move.w #$fffd, -$4(a5)
L063_00000388:
; H063+$00000388: 4e75  rts 
        rts 
L063_0000038A:
; H063+$0000038A: 3b7cfffefffc  move.w #$fffe, -$4(a5)
        move.w #$fffe, -$4(a5)
L063_00000390:
; H063+$00000390: 4e75  rts 
        rts 
L063_00000392:
; H063+$00000392: 3b7cfffffffc  move.w #$ffff, -$4(a5)
        move.w #$ffff, -$4(a5)
L063_00000398:
; H063+$00000398: 4e75  rts 
        rts 
L063_0000039A:
; H063+$0000039A: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L063_000003A0:
; H063+$000003A0: 4e75  rts 
        rts 
L063_000003A2:
; H063+$000003A2: 3b7c0002fffc  move.w #$2, -$4(a5)
        move.w #$2, -$4(a5)
L063_000003A8:
; H063+$000003A8: 4e75  rts 
        rts 
L063_000003AA:
; H063+$000003AA: 3b7c0003fffc  move.w #$3, -$4(a5)
        move.w #$3, -$4(a5)
L063_000003B0:
; H063+$000003B0: 4e75  rts 
        rts 
L063_000003B2:
; H063+$000003B2: 3b7c0004fffc  move.w #$4, -$4(a5)
        move.w #$4, -$4(a5)
L063_000003B8:
; H063+$000003B8: 4e75  rts 
        rts 
L063_000003BA:
; H063+$000003BA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_000003BE:
; H063+$000003BE: 04420017  subi.w #$17, d2
        subi.w #$17, d2
L063_000003C2:
; H063+$000003C2: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_000003C6:
; H063+$000003C6: 4e75  rts 
        rts 
L063_000003C8:
; H063+$000003C8: 4e75  rts 
        rts 
; Preserved bytes H063+$000003CA..$00000408; code/data not fully classified.
        dc.w $FFFC,$FFB6,$FFB6,$FFB6,$FFBE,$FFBE,$FFC6,$FFC6
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFCE,$FFCE,$FFCE,$FFD6,$FFD6,$FFD6,$FFDE
        dc.w $FFDE,$FFDE,$FFE6,$FFE6,$FFEE,$FFEE,$FFEE
L063_00000408:
; H063+$00000408: 47faffc2  lea.l $3cc(pc), a3
        lea.l H063+$3CC(pc), a3
L063_0000040C:
; H063+$0000040C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_0000040E:
; H063+$0000040E: 0c42001d  cmpi.w #$1d, d2
        cmpi.w #$1d, d2
L063_00000412:
; H063+$00000412: 6302  bls.b $416
        bls.b H063+$416
L063_00000414:
; H063+$00000414: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00000416:
; H063+$00000416: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00000418:
; H063+$00000418: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$03CC; indici 0..29, default -1.
L063_0000041C:
; H063+$0000041C: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00000420:
; H063+$00000420: 302dfffc  move.w -$4(a5), d0
        move.w -$4(a5), d0
L063_00000424:
; H063+$00000424: 60000002  bra.w $428
        bra.w H063+$428
L063_00000428:
; H063+$00000428: 4e5d  unlk a5
        unlk a5
L063_0000042A:
; H063+$0000042A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_0000042C:
; H063+$0000042C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_0000042E:
; H063+$0000042E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00000430:
; H063+$00000430: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00000432 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H029+$0354.
;   - Richiama H029+$0354.
; Chiamanti diretti: H063+$170C
; --------------------------------------------------------------------------
L063_00000432:
; H063+$00000432: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00000434:
; H063+$00000434: 287afcca  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00000438:
; H063+$00000438: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L063_0000043C:
; H063+$0000043C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000440:
; H063+$00000440: 2b6b0154fffc  move.l $154(a3), -$4(a5)
        move.l $154(a3), -$4(a5)
L063_00000446:
; H063+$00000446: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_0000044A:
; H063+$0000044A: 67000258  beq.w $6a4
        beq.w H063+$6A4
L063_0000044E:
; H063+$0000044E: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000450:
; H063+$00000450: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000454:
; H063+$00000454: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00000458:
; H063+$00000458: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L063_0000045C:
; H063+$0000045C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000460:
; H063+$00000460: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00000464:
; H063+$00000464: 156b005a019b  move.b $5a(a3), $19b(a2)
        move.b $5a(a3), $19b(a2)
L063_0000046A:
; H063+$0000046A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_0000046E:
; H063+$0000046E: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_00000472:
; H063+$00000472: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_00000478:
; H063+$00000478: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L063_0000047C:
; H063+$0000047C: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_00000480:
; H063+$00000480: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_00000486:
; H063+$00000486: 1400  move.b d0, d2
        move.b d0, d2
L063_00000488:
; H063+$00000488: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_0000048C:
; H063+$0000048C: 4a42  tst.w d2
        tst.w d2
L063_0000048E:
; H063+$0000048E: 67000024  beq.w $4b4
        beq.w H063+$4B4
L063_00000492:
; H063+$00000492: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000494:
; H063+$00000494: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000498:
; H063+$00000498: 142b019b  move.b $19b(a3), d2
        move.b $19b(a3), d2
L063_0000049C:
; H063+$0000049C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_0000049E:
; H063+$0000049E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000004A2:
; H063+$000004A2: 6100fcc6  bsr.w $16a
        bsr.w H063+$16A
L063_000004A6:
; H063+$000004A6: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L063_000004A8:
; H063+$000004A8: 3800  move.w d0, d4
        move.w d0, d4
L063_000004AA:
; H063+$000004AA: d444  add.w d4, d2
        add.w d4, d2
L063_000004AC:
; H063+$000004AC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000004B0:
; H063+$000004B0: 1742019b  move.b d2, $19b(a3)
        move.b d2, $19b(a3)
L063_000004B4:
; H063+$000004B4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_000004B8:
; H063+$000004B8: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_000004BC:
; H063+$000004BC: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_000004C2:
; H063+$000004C2: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_000004C6:
; H063+$000004C6: 3573280c01a4  move.w $c(a3, d2.l), $1a4(a2)
        move.w $c(a3, d2.l), $1a4(a2)
L063_000004CC:
; H063+$000004CC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_000004D0:
; H063+$000004D0: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_000004D4:
; H063+$000004D4: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_000004DA:
; H063+$000004DA: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L063_000004DE:
; H063+$000004DE: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_000004E2:
; H063+$000004E2: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_000004E8:
; H063+$000004E8: 1400  move.b d0, d2
        move.b d0, d2
L063_000004EA:
; H063+$000004EA: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_000004EE:
; H063+$000004EE: 4a42  tst.w d2
        tst.w d2
L063_000004F0:
; H063+$000004F0: 67000040  beq.w $532
        beq.w H063+$532
L063_000004F4:
; H063+$000004F4: 7400  moveq #$0, d2
        moveq #0, d2
L063_000004F6:
; H063+$000004F6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000004FA:
; H063+$000004FA: 142b019b  move.b $19b(a3), d2
        move.b $19b(a3), d2
L063_000004FE:
; H063+$000004FE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_00000500:
; H063+$00000500: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00000504:
; H063+$00000504: 6100fe4e  bsr.w $354
        bsr.w H063+$354
L063_00000508:
; H063+$00000508: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L063_0000050A:
; H063+$0000050A: 3800  move.w d0, d4
        move.w d0, d4
L063_0000050C:
; H063+$0000050C: d444  add.w d4, d2
        add.w d4, d2
L063_0000050E:
; H063+$0000050E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000512:
; H063+$00000512: 1742019b  move.b d2, $19b(a3)
        move.b d2, $19b(a3)
L063_00000516:
; H063+$00000516: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000051A:
; H063+$0000051A: 4eb9000019b6  jsr $19b6.l
        jsr (H063+$19B6).l
L063_00000520:
; H063+$00000520: 3400  move.w d0, d2
        move.w d0, d2
L063_00000522:
; H063+$00000522: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000526:
; H063+$00000526: d46b01a4  add.w $1a4(a3), d2
        add.w $1a4(a3), d2
L063_0000052A:
; H063+$0000052A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000052E:
; H063+$0000052E: 374201a4  move.w d2, $1a4(a3)
        move.w d2, $1a4(a3)
L063_00000532:
; H063+$00000532: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000536:
; H063+$00000536: 3b6b0036fff8  move.w $36(a3), -$8(a5)
        move.w $36(a3), -$8(a5)
L063_0000053C:
; H063+$0000053C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00000540:
; H063+$00000540: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_00000544:
; H063+$00000544: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_0000054A:
; H063+$0000054A: 7800  moveq #$0, d4
        moveq #0, d4
L063_0000054C:
; H063+$0000054C: 18332810  move.b $10(a3, d2.l), d4
        move.b $10(a3, d2.l), d4
L063_00000550:
; H063+$00000550: 0c44007f  cmpi.w #$7f, d4
        cmpi.w #$7f, d4
L063_00000554:
; H063+$00000554: 63000022  bls.w $578
        bls.w H063+$578
L063_00000558:
; H063+$00000558: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000055C:
; H063+$0000055C: 4aab0184  tst.l $184(a3)
        tst.l $184(a3)
L063_00000560:
; H063+$00000560: 67000016  beq.w $578
        beq.w H063+$578
L063_00000564:
; H063+$00000564: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00000568:
; H063+$00000568: 266a0184  movea.l $184(a2), a3
        movea.l $184(a2), a3
L063_0000056C:
; H063+$0000056C: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L063_00000570:
; H063+$00000570: d46b0036  add.w $36(a3), d2
        add.w $36(a3), d2
L063_00000574:
; H063+$00000574: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L063_00000578:
; H063+$00000578: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_0000057C:
; H063+$0000057C: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_00000580:
; H063+$00000580: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_00000586:
; H063+$00000586: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L063_0000058A:
; H063+$0000058A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_0000058E:
; H063+$0000058E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_00000594:
; H063+$00000594: 1400  move.b d0, d2
        move.b d0, d2
L063_00000596:
; H063+$00000596: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_0000059A:
; H063+$0000059A: 4a42  tst.w d2
        tst.w d2
L063_0000059C:
; H063+$0000059C: 63000022  bls.w $5c0
        bls.w H063+$5C0
L063_000005A0:
; H063+$000005A0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000005A4:
; H063+$000005A4: 4aab0180  tst.l $180(a3)
        tst.l $180(a3)
L063_000005A8:
; H063+$000005A8: 67000016  beq.w $5c0
        beq.w H063+$5C0
L063_000005AC:
; H063+$000005AC: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_000005B0:
; H063+$000005B0: 266a0180  movea.l $180(a2), a3
        movea.l $180(a2), a3
L063_000005B4:
; H063+$000005B4: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L063_000005B8:
; H063+$000005B8: d46b0036  add.w $36(a3), d2
        add.w $36(a3), d2
L063_000005BC:
; H063+$000005BC: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L063_000005C0:
; H063+$000005C0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000005C4:
; H063+$000005C4: 342b01a4  move.w $1a4(a3), d2
        move.w $1a4(a3), d2
L063_000005C8:
; H063+$000005C8: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L063_000005CC:
; H063+$000005CC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000005D0:
; H063+$000005D0: 374201a4  move.w d2, $1a4(a3)
        move.w d2, $1a4(a3)
L063_000005D4:
; H063+$000005D4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000005D8:
; H063+$000005D8: 4a2b005b  tst.b $5b(a3)
        tst.b $5b(a3)
L063_000005DC:
; H063+$000005DC: 67000010  beq.w $5ee
        beq.w H063+$5EE
L063_000005E0:
; H063+$000005E0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000005E4:
; H063+$000005E4: 0c2b0001005b  cmpi.b #$1, $5b(a3)
        cmpi.b #$1, $5b(a3)
L063_000005EA:
; H063+$000005EA: 6600004e  bne.w $63a
        bne.w H063+$63A
L063_000005EE:
; H063+$000005EE: 7400  moveq #$0, d2
        moveq #0, d2
L063_000005F0:
; H063+$000005F0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_000005F4:
; H063+$000005F4: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_000005F8:
; H063+$000005F8: 0c420015  cmpi.w #$15, d2
        cmpi.w #$15, d2
L063_000005FC:
; H063+$000005FC: 63000014  bls.w $612
        bls.w H063+$612
L063_00000600:
; H063+$00000600: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000602:
; H063+$00000602: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000606:
; H063+$00000606: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_0000060A:
; H063+$0000060A: 0c42001b  cmpi.w #$1b, d2
        cmpi.w #$1b, d2
L063_0000060E:
; H063+$0000060E: 65000026  bcs.w $636
        bcs.w H063+$636
L063_00000612:
; H063+$00000612: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000614:
; H063+$00000614: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000618:
; H063+$00000618: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_0000061C:
; H063+$0000061C: 0c420013  cmpi.w #$13, d2
        cmpi.w #$13, d2
L063_00000620:
; H063+$00000620: 67000014  beq.w $636
        beq.w H063+$636
L063_00000624:
; H063+$00000624: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000626:
; H063+$00000626: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_0000062A:
; H063+$0000062A: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_0000062E:
; H063+$0000062E: 0c420012  cmpi.w #$12, d2
        cmpi.w #$12, d2
L063_00000632:
; H063+$00000632: 66000006  bne.w $63a
        bne.w H063+$63A
L063_00000636:
; H063+$00000636: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L063_0000063A:
; H063+$0000063A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000063E:
; H063+$0000063E: 0c2b0005005b  cmpi.b #$5, $5b(a3)
        cmpi.b #$5, $5b(a3)
L063_00000644:
; H063+$00000644: 66000018  bne.w $65e
        bne.w H063+$65E
L063_00000648:
; H063+$00000648: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000064A:
; H063+$0000064A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_0000064E:
; H063+$0000064E: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00000652:
; H063+$00000652: 0c420043  cmpi.w #$43, d2
        cmpi.w #$43, d2
L063_00000656:
; H063+$00000656: 66000006  bne.w $65e
        bne.w H063+$65E
L063_0000065A:
; H063+$0000065A: 546dfff8  addq.w #$2, -$8(a5)
        addq.w #$2, -$8(a5)
L063_0000065E:
; H063+$0000065E: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000660:
; H063+$00000660: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000664:
; H063+$00000664: 142b019b  move.b $19b(a3), d2
        move.b $19b(a3), d2
L063_00000668:
; H063+$00000668: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L063_0000066C:
; H063+$0000066C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000670:
; H063+$00000670: 1742019b  move.b d2, $19b(a3)
        move.b d2, $19b(a3)
L063_00000674:
; H063+$00000674: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00000678:
; H063+$00000678: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_0000067C:
; H063+$0000067C: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_00000682:
; H063+$00000682: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00000686:
; H063+$00000686: 1573280a01a0  move.b $a(a3, d2.l), $1a0(a2)
        move.b $a(a3, d2.l), $1a0(a2)
L063_0000068C:
; H063+$0000068C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00000690:
; H063+$00000690: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_00000694:
; H063+$00000694: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_0000069A:
; H063+$0000069A: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_0000069E:
; H063+$0000069E: 1573280b01a2  move.b $b(a3, d2.l), $1a2(a2)
        move.b $b(a3, d2.l), $1a2(a2)
L063_000006A4:
; H063+$000006A4: 4e5d  unlk a5
        unlk a5
L063_000006A6:
; H063+$000006A6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000006A8:
; H063+$000006A8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000006AA:
; H063+$000006AA: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_000006AC:
; H063+$000006AC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000006AE [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H063+$1736
; --------------------------------------------------------------------------
L063_000006AE:
; H063+$000006AE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000006B0:
; H063+$000006B0: 287afa4e  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000006B4:
; H063+$000006B4: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_000006B8:
; H063+$000006B8: 7400  moveq #$0, d2
        moveq #0, d2
L063_000006BA:
; H063+$000006BA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000006BE:
; H063+$000006BE: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_000006C2:
; H063+$000006C2: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_000006C6:
; H063+$000006C6: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_000006CC:
; H063+$000006CC: 0c3300022800  cmpi.b #$2, (a3, d2.l)
        cmpi.b #$2, (a3, d2.l)
L063_000006D2:
; H063+$000006D2: 6600007a  bne.w $74e
        bne.w H063+$74E
L063_000006D6:
; H063+$000006D6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000006DA:
; H063+$000006DA: 0c6b0097003e  cmpi.w #$97, $3e(a3)
        cmpi.w #$97, $3e(a3)
L063_000006E0:
; H063+$000006E0: 64000014  bcc.w $6f6
        bcc.w H063+$6F6
L063_000006E4:
; H063+$000006E4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_000006E8:
; H063+$000006E8: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L063_000006EC:
; H063+$000006EC: 156b00da01a9  move.b $da(a3), $1a9(a2)
        move.b $da(a3), $1a9(a2)
L063_000006F2:
; H063+$000006F2: 60000028  bra.w $71c
        bra.w H063+$71C
L063_000006F6:
; H063+$000006F6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000006FA:
; H063+$000006FA: 0c6b0190003e  cmpi.w #$190, $3e(a3)
        cmpi.w #$190, $3e(a3)
L063_00000700:
; H063+$00000700: 64000010  bcc.w $712
        bcc.w H063+$712
L063_00000704:
; H063+$00000704: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00000708:
; H063+$00000708: 177c000901a9  move.b #$9, $1a9(a3)
        move.b #$9, $1a9(a3)
L063_0000070E:
; H063+$0000070E: 6000000c  bra.w $71c
        bra.w H063+$71C
L063_00000712:
; H063+$00000712: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00000716:
; H063+$00000716: 177c000601a9  move.b #$6, $1a9(a3)
        move.b #$6, $1a9(a3)
L063_0000071C:
; H063+$0000071C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000720:
; H063+$00000720: 4a6b0036  tst.w $36(a3)
        tst.w $36(a3)
L063_00000724:
; H063+$00000724: 67000028  beq.w $74e
        beq.w H063+$74E
L063_00000728:
; H063+$00000728: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000072A:
; H063+$0000072A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_0000072E:
; H063+$0000072E: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L063_00000732:
; H063+$00000732: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L063_00000736:
; H063+$00000736: 62000016  bhi.w $74e
        bhi.w H063+$74E
L063_0000073A:
; H063+$0000073A: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000073C:
; H063+$0000073C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00000740:
; H063+$00000740: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L063_00000744:
; H063+$00000744: 5642  addq.w #$3, d2
        addq.w #$3, d2
L063_00000746:
; H063+$00000746: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_0000074A:
; H063+$0000074A: 174201a9  move.b d2, $1a9(a3)
        move.b d2, $1a9(a3)
L063_0000074E:
; H063+$0000074E: 4e5d  unlk a5
        unlk a5
L063_00000750:
; H063+$00000750: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00000752:
; H063+$00000752: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00000754:
; H063+$00000754: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_00000756:
; H063+$00000756: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00000758 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H029+$0354.
;   - Richiama H029+$0354.
; Chiamanti diretti: H063+$174A
; --------------------------------------------------------------------------
L063_00000758:
; H063+$00000758: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000075A:
; H063+$0000075A: 287af9a4  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000075E:
; H063+$0000075E: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_00000762:
; H063+$00000762: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000764:
; H063+$00000764: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000768:
; H063+$00000768: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_0000076C:
; H063+$0000076C: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_00000770:
; H063+$00000770: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_00000776:
; H063+$00000776: 7800  moveq #$0, d4
        moveq #0, d4
L063_00000778:
; H063+$00000778: 18332807  move.b $7(a3, d2.l), d4
        move.b $7(a3, d2.l), d4
L063_0000077C:
; H063+$0000077C: 3b44fffe  move.w d4, -$2(a5)
        move.w d4, -$2(a5)
L063_00000780:
; H063+$00000780: 0c6d007ffffe  cmpi.w #$7f, -$2(a5)
        cmpi.w #$7f, -$2(a5)
L063_00000786:
; H063+$00000786: 6300010e  bls.w $896
        bls.w H063+$896
L063_0000078A:
; H063+$0000078A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000078E:
; H063+$0000078E: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_00000790:
; H063+$00000790: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_00000794:
; H063+$00000794: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_0000079A:
; H063+$0000079A: 1400  move.b d0, d2
        move.b d0, d2
L063_0000079C:
; H063+$0000079C: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_000007A0:
; H063+$000007A0: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_000007A4:
; H063+$000007A4: 7400  moveq #$0, d2
        moveq #0, d2
L063_000007A6:
; H063+$000007A6: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_000007AA:
; H063+$000007AA: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_000007AE:
; H063+$000007AE: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_000007B2:
; H063+$000007B2: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_000007B8:
; H063+$000007B8: 1b732800fffd  move.b (a3, d2.l), -$3(a5)
        move.b (a3, d2.l), -$3(a5)
L063_000007BE:
; H063+$000007BE: 0c2d0001fffd  cmpi.b #$1, -$3(a5)
        cmpi.b #$1, -$3(a5)
L063_000007C4:
; H063+$000007C4: 6600001a  bne.w $7e0
        bne.w H063+$7E0
L063_000007C8:
; H063+$000007C8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_000007CC:
; H063+$000007CC: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_000007D0:
; H063+$000007D0: d46b0036  add.w $36(a3), d2
        add.w $36(a3), d2
L063_000007D4:
; H063+$000007D4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_000007D8:
; H063+$000007D8: 37420002  move.w d2, $2(a3)
        move.w d2, $2(a3)
L063_000007DC:
; H063+$000007DC: 600000b8  bra.w $896
        bra.w H063+$896
L063_000007E0:
; H063+$000007E0: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L063_000007E4:
; H063+$000007E4: 66000066  bne.w $84c
        bne.w H063+$84C
L063_000007E8:
; H063+$000007E8: 0c2d0009fffd  cmpi.b #$9, -$3(a5)
        cmpi.b #$9, -$3(a5)
L063_000007EE:
; H063+$000007EE: 66000028  bne.w $818
        bne.w H063+$818
L063_000007F2:
; H063+$000007F2: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_000007F6:
; H063+$000007F6: 342b0036  move.w $36(a3), d2
        move.w $36(a3), d2
L063_000007FA:
; H063+$000007FA: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_000007FE:
; H063+$000007FE: b46b0006  cmp.w $6(a3), d2
        cmp.w $6(a3), d2
L063_00000802:
; H063+$00000802: 6f000010  ble.w $814
        ble.w H063+$814
L063_00000806:
; H063+$00000806: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_0000080A:
; H063+$0000080A: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L063_0000080E:
; H063+$0000080E: 356b00360006  move.w $36(a3), $6(a2)
        move.w $36(a3), $6(a2)
L063_00000814:
; H063+$00000814: 6000001a  bra.w $830
        bra.w H063+$830
L063_00000818:
; H063+$00000818: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_0000081C:
; H063+$0000081C: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L063_00000820:
; H063+$00000820: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000824:
; H063+$00000824: d46b0036  add.w $36(a3), d2
        add.w $36(a3), d2
L063_00000828:
; H063+$00000828: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_0000082C:
; H063+$0000082C: 37420004  move.w d2, $4(a3)
        move.w d2, $4(a3)
L063_00000830:
; H063+$00000830: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L063_00000834:
; H063+$00000834: 342b018a  move.w $18a(a3), d2
        move.w $18a(a3), d2
L063_00000838:
; H063+$00000838: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_0000083C:
; H063+$0000083C: d46b0038  add.w $38(a3), d2
        add.w $38(a3), d2
L063_00000840:
; H063+$00000840: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L063_00000844:
; H063+$00000844: 3742018a  move.w d2, $18a(a3)
        move.w d2, $18a(a3)
L063_00000848:
; H063+$00000848: 6000004c  bra.w $896
        bra.w H063+$896
L063_0000084C:
; H063+$0000084C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000850:
; H063+$00000850: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000854:
; H063+$00000854: d46b0036  add.w $36(a3), d2
        add.w $36(a3), d2
L063_00000858:
; H063+$00000858: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_0000085C:
; H063+$0000085C: b46b0008  cmp.w $8(a3), d2
        cmp.w $8(a3), d2
L063_00000860:
; H063+$00000860: 6f000034  ble.w $896
        ble.w H063+$896
L063_00000864:
; H063+$00000864: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000868:
; H063+$00000868: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_0000086C:
; H063+$0000086C: d46b0036  add.w $36(a3), d2
        add.w $36(a3), d2
L063_00000870:
; H063+$00000870: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00000874:
; H063+$00000874: 37420008  move.w d2, $8(a3)
        move.w d2, $8(a3)
L063_00000878:
; H063+$00000878: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_0000087C:
; H063+$0000087C: 4a6b0036  tst.w $36(a3)
        tst.w $36(a3)
L063_00000880:
; H063+$00000880: 6f000014  ble.w $896
        ble.w H063+$896
L063_00000884:
; H063+$00000884: 0c2d0002fffd  cmpi.b #$2, -$3(a5)
        cmpi.b #$2, -$3(a5)
L063_0000088A:
; H063+$0000088A: 6600000a  bne.w $896
        bne.w H063+$896
L063_0000088E:
; H063+$0000088E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000892:
; H063+$00000892: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L063_00000896:
; H063+$00000896: 4e5d  unlk a5
        unlk a5
L063_00000898:
; H063+$00000898: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_0000089A:
; H063+$0000089A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_0000089C:
; H063+$0000089C: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L063_000008A0:
; H063+$000008A0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000008A2 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H063+$17B0
; --------------------------------------------------------------------------
L063_000008A2:
; H063+$000008A2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000008A4:
; H063+$000008A4: 287af85a  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000008A8:
; H063+$000008A8: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_000008AC:
; H063+$000008AC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000008B0:
; H063+$000008B0: 4eb900001a8a  jsr $1a8a.l
        jsr (H063+$1A8A).l
L063_000008B6:
; H063+$000008B6: 3400  move.w d0, d2
        move.w d0, d2
L063_000008B8:
; H063+$000008B8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000008BC:
; H063+$000008BC: 382b018c  move.w $18c(a3), d4
        move.w $18c(a3), d4
L063_000008C0:
; H063+$000008C0: 9842  sub.w d2, d4
        sub.w d2, d4
L063_000008C2:
; H063+$000008C2: 3b44fffe  move.w d4, -$2(a5)
        move.w d4, -$2(a5)
L063_000008C6:
; H063+$000008C6: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L063_000008CA:
; H063+$000008CA: 6c000006  bge.w $8d2
        bge.w H063+$8D2
L063_000008CE:
; H063+$000008CE: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_000008D2:
; H063+$000008D2: 0c6d0201fffe  cmpi.w #$201, -$2(a5)
        cmpi.w #$201, -$2(a5)
L063_000008D8:
; H063+$000008D8: 6c000014  bge.w $8ee
        bge.w H063+$8EE
L063_000008DC:
; H063+$000008DC: 7400  moveq #$0, d2
        moveq #0, d2
L063_000008DE:
; H063+$000008DE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000008E2:
; H063+$000008E2: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L063_000008E6:
; H063+$000008E6: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_000008EA:
; H063+$000008EA: 60000030  bra.w $91c
        bra.w H063+$91C
L063_000008EE:
; H063+$000008EE: 0c6d0301fffe  cmpi.w #$301, -$2(a5)
        cmpi.w #$301, -$2(a5)
L063_000008F4:
; H063+$000008F4: 6c00000c  bge.w $902
        bge.w H063+$902
L063_000008F8:
; H063+$000008F8: 3b7c0009fffc  move.w #$9, -$4(a5)
        move.w #$9, -$4(a5)
L063_000008FE:
; H063+$000008FE: 6000001c  bra.w $91c
        bra.w H063+$91C
L063_00000902:
; H063+$00000902: 0c6d0401fffe  cmpi.w #$401, -$2(a5)
        cmpi.w #$401, -$2(a5)
L063_00000908:
; H063+$00000908: 6c00000c  bge.w $916
        bge.w H063+$916
L063_0000090C:
; H063+$0000090C: 3b7c0006fffc  move.w #$6, -$4(a5)
        move.w #$6, -$4(a5)
L063_00000912:
; H063+$00000912: 60000008  bra.w $91c
        bra.w H063+$91C
L063_00000916:
; H063+$00000916: 3b7c0003fffc  move.w #$3, -$4(a5)
        move.w #$3, -$4(a5)
L063_0000091C:
; H063+$0000091C: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000091E:
; H063+$0000091E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000922:
; H063+$00000922: 142b01a9  move.b $1a9(a3), d2
        move.b $1a9(a3), d2
L063_00000926:
; H063+$00000926: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L063_0000092A:
; H063+$0000092A: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_0000092C:
; H063+$0000092C: 6400000e  bcc.w $93c
        bcc.w H063+$93C
L063_00000930:
; H063+$00000930: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00000934:
; H063+$00000934: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000938:
; H063+$00000938: 174201a9  move.b d2, $1a9(a3)
        move.b d2, $1a9(a3)
L063_0000093C:
; H063+$0000093C: 4e5d  unlk a5
        unlk a5
L063_0000093E:
; H063+$0000093E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00000940:
; H063+$00000940: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00000942:
; H063+$00000942: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00000944:
; H063+$00000944: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00000946 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$0B16, H027+$0D90, H027+$2BEC, H027+$2C42, H027+$3240, H027+$3676 e altri 53
; --------------------------------------------------------------------------
L063_00000946:
; H063+$00000946: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00000948:
; H063+$00000948: 287af7b6  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000094C:
; H063+$0000094C: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_00000950:
; H063+$00000950: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L063_00000954:
; H063+$00000954: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L063_00000958:
; H063+$00000958: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_0000095C:
; H063+$0000095C: 24ab00e8  move.l $e8(a3), (a2)
        move.l $e8(a3), (a2)
L063_00000960:
; H063+$00000960: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00000964:
; H063+$00000964: 4a93  tst.l (a3)
        tst.l (a3)
L063_00000966:
; H063+$00000966: 67000036  beq.w $99e
        beq.w H063+$99E
L063_0000096A:
; H063+$0000096A: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L063_0000096E:
; H063+$0000096E: 6600002e  bne.w $99e
        bne.w H063+$99E
L063_00000972:
; H063+$00000972: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00000976:
; H063+$00000976: 2652  movea.l (a2), a3
        movea.l (a2), a3
L063_00000978:
; H063+$00000978: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000097A:
; H063+$0000097A: 1413  move.b (a3), d2
        move.b (a3), d2
L063_0000097C:
; H063+$0000097C: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L063_00000980:
; H063+$00000980: 6600000c  bne.w $98e
        bne.w H063+$98E
L063_00000984:
; H063+$00000984: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L063_0000098A:
; H063+$0000098A: 60000010  bra.w $99c
        bra.w H063+$99C
L063_0000098E:
; H063+$0000098E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00000992:
; H063+$00000992: 2652  movea.l (a2), a3
        movea.l (a2), a3
L063_00000994:
; H063+$00000994: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00000998:
; H063+$00000998: 24ab0006  move.l $6(a3), (a2)
        move.l $6(a3), (a2)
L063_0000099C:
; H063+$0000099C: 60c2  bra.b $960
        bra.b H063+$960
L063_0000099E:
; H063+$0000099E: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L063_000009A2:
; H063+$000009A2: 60000002  bra.w $9a6
        bra.w H063+$9A6
L063_000009A6:
; H063+$000009A6: 4e5d  unlk a5
        unlk a5
L063_000009A8:
; H063+$000009A8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000009AA:
; H063+$000009AA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000009AC:
; H063+$000009AC: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L063_000009B0:
; H063+$000009B0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000009B2 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H026+$01E0, H045+$01D6, H026+$03F6, H029+$0354.
;   - Richiama H026+$01E0.
;   - Richiama H045+$01D6.
;   - Richiama H026+$03F6.
;   - Richiama H029+$0354.
;   - Richiama H030+$0256.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H063+$125C, H065+$2EBC, H071+$09A8, H065+$0AA6, H065+$0AD2, H065+$27B2 e altri 11
; --------------------------------------------------------------------------
L063_000009B2:
; H063+$000009B2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000009B4:
; H063+$000009B4: 287af74a  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000009B8:
; H063+$000009B8: 4e55ffa0  link.w a5, #$ffa0
        link.w a5, #$ffa0
L063_000009BC:
; H063+$000009BC: 47ec0000  lea.l $0(a4), a3
        lea.l $0(a4), a3
L063_000009C0:
; H063+$000009C0: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L063_000009C4:
; H063+$000009C4: 7428  moveq #$28, d2
        moveq #40, d2
L063_000009C6:
; H063+$000009C6: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_000009C8:
; H063+$000009C8: 57cafffc  dbeq d2, $9c6
        dbeq d2, H063+$9C6
L063_000009CC:
; H063+$000009CC: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L063_000009D0:
; H063+$000009D0: 67000032  beq.w $a04
        beq.w H063+$A04
L063_000009D4:
; H063+$000009D4: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_000009D8:
; H063+$000009D8: 4a2b003a  tst.b $3a(a3)
        tst.b $3a(a3)
L063_000009DC:
; H063+$000009DC: 67000016  beq.w $9f4
        beq.w H063+$9F4
L063_000009E0:
; H063+$000009E0: 47ec0002  lea.l $2(a4), a3
        lea.l $2(a4), a3
L063_000009E4:
; H063+$000009E4: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L063_000009E8:
; H063+$000009E8: 7428  moveq #$28, d2
        moveq #40, d2
L063_000009EA:
; H063+$000009EA: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_000009EC:
; H063+$000009EC: 57cafffc  dbeq d2, $9ea
        dbeq d2, H063+$9EA
L063_000009F0:
; H063+$000009F0: 60000012  bra.w $a04
        bra.w H063+$A04
L063_000009F4:
; H063+$000009F4: 47ec0009  lea.l $9(a4), a3
        lea.l $9(a4), a3
L063_000009F8:
; H063+$000009F8: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L063_000009FC:
; H063+$000009FC: 7428  moveq #$28, d2
        moveq #40, d2
L063_000009FE:
; H063+$000009FE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00000A00:
; H063+$00000A00: 57cafffc  dbeq d2, $9fe
        dbeq d2, H063+$9FE
L063_00000A04:
; H063+$00000A04: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
; STATO: H005+$3364 = testa della lista del party
L063_00000A08:
; H063+$00000A08: 2b7900003364fff2  move.l $3364.l, -$e(a5)
        move.l (H005+$3364).l, -$e(a5)
L063_00000A10:
; H063+$00000A10: 4aadfff2  tst.l -$e(a5)
        tst.l -$e(a5)
L063_00000A14:
; H063+$00000A14: 67000034  beq.w $a4a
        beq.w H063+$A4A
L063_00000A18:
; H063+$00000A18: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L063_00000A1C:
; H063+$00000A1C: 6600002c  bne.w $a4a
        bne.w H063+$A4A
L063_00000A20:
; H063+$00000A20: 2f2dfff2  move.l -$e(a5), -(a7)
        move.l -$e(a5), -(a7)
L063_00000A24:
; H063+$00000A24: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L063_00000A28:
; H063+$00000A28: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L063_00000A2C:
; H063+$00000A2C: 6100ff18  bsr.w $946
        bsr.w H063+$946
L063_00000A30:
; H063+$00000A30: 1400  move.b d0, d2
        move.b d0, d2
L063_00000A32:
; H063+$00000A32: 4a02  tst.b d2
        tst.b d2
L063_00000A34:
; H063+$00000A34: 67000008  beq.w $a3e
        beq.w H063+$A3E
L063_00000A38:
; H063+$00000A38: 1b7c0001fff7  move.b #$1, -$9(a5)
        move.b #$1, -$9(a5)
L063_00000A3E:
; H063+$00000A3E: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L063_00000A42:
; H063+$00000A42: 2b6b018efff2  move.l $18e(a3), -$e(a5)
        move.l $18e(a3), -$e(a5)
L063_00000A48:
; H063+$00000A48: 60c6  bra.b $a10
        bra.b H063+$A10
L063_00000A4A:
; H063+$00000A4A: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L063_00000A4E:
; H063+$00000A4E: 6700003c  beq.w $a8c
        beq.w H063+$A8C
L063_00000A52:
; H063+$00000A52: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000A56:
; H063+$00000A56: 4a6b0036  tst.w $36(a3)
        tst.w $36(a3)
L063_00000A5A:
; H063+$00000A5A: 6e00001a  bgt.w $a76
        bgt.w H063+$A76
L063_00000A5E:
; H063+$00000A5E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000A62:
; H063+$00000A62: 4a6b0038  tst.w $38(a3)
        tst.w $38(a3)
L063_00000A66:
; H063+$00000A66: 6e00000e  bgt.w $a76
        bgt.w H063+$A76
L063_00000A6A:
; H063+$00000A6A: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000A6E:
; H063+$00000A6E: 4a2b003c  tst.b $3c(a3)
        tst.b $3c(a3)
L063_00000A72:
; H063+$00000A72: 67000018  beq.w $a8c
        beq.w H063+$A8C
L063_00000A76:
; H063+$00000A76: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000A7A:
; H063+$00000A7A: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00000A7E:
; H063+$00000A7E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00000A82:
; H063+$00000A82: 486c0010  pea.l $10(a4)
        pea.l $10(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00000A86:
; H063+$00000A86: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00000A8C:
; H063+$00000A8C: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000A8E:
; H063+$00000A8E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000A92:
; H063+$00000A92: 142b0040  move.b $40(a3), d2
        move.b $40(a3), d2
L063_00000A96:
; H063+$00000A96: 4a42  tst.w d2
        tst.w d2
L063_00000A98:
; H063+$00000A98: 63000088  bls.w $b22
        bls.w H063+$B22
L063_00000A9C:
; H063+$00000A9C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00000AA0:
; H063+$00000AA0: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
L063_00000AA4:
; H063+$00000AA4: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000AA6:
; H063+$00000AA6: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000AAA:
; H063+$00000AAA: 142b0040  move.b $40(a3), d2
        move.b $40(a3), d2
L063_00000AAE:
; H063+$00000AAE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_00000AB0:
; H063+$00000AB0: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00000AB2:
; H063+$00000AB2: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00000AB6:
; H063+$00000AB6: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L063_00000ABA:
; H063+$00000ABA: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_00000ABE:
; H063+$00000ABE: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L063_00000AC4:
; H063+$00000AC4: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_00000AC8:
; H063+$00000AC8: 0c6d0002fffe  cmpi.w #$2, -$2(a5)
        cmpi.w #$2, -$2(a5)
L063_00000ACE:
; H063+$00000ACE: 62000026  bhi.w $af6
        bhi.w H063+$AF6
L063_00000AD2:
; H063+$00000AD2: 0c2d0020ffa0  cmpi.b #$20, -$60(a5)
        cmpi.b #$20, -$60(a5)
L063_00000AD8:
; H063+$00000AD8: 66000016  bne.w $af0
        bne.w H063+$AF0
L063_00000ADC:
; H063+$00000ADC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00000AE0:
; H063+$00000AE0: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
L063_00000AE4:
; H063+$00000AE4: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00000AE6:
; H063+$00000AE6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H026+$03F6 (sub_H026_000003F6)
L063_00000AEA:
; H063+$00000AEA: 4eb9000003f6  jsr $3f6.l
        jsr (H026+$3F6).l
L063_00000AF0:
; H063+$00000AF0: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L063_00000AF4:
; H063+$00000AF4: 64d2  bcc.b $ac8
        bcc.b H063+$AC8
L063_00000AF6:
; H063+$00000AF6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000AFA:
; H063+$00000AFA: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00000AFE:
; H063+$00000AFE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00000B02:
; H063+$00000B02: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00000B06:
; H063+$00000B06: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00000B0C:
; H063+$00000B0C: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000B10:
; H063+$00000B10: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00000B14:
; H063+$00000B14: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00000B18:
; H063+$00000B18: 486c0013  pea.l $13(a4)
        pea.l $13(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00000B1C:
; H063+$00000B1C: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00000B22:
; H063+$00000B22: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L063_00000B26:
; H063+$00000B26: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L063_00000B2C:
; H063+$00000B2C: 0c6d0003fffe  cmpi.w #$3, -$2(a5)
        cmpi.w #$3, -$2(a5)
L063_00000B32:
; H063+$00000B32: 62000070  bhi.w $ba4
        bhi.w H063+$BA4
L063_00000B36:
; H063+$00000B36: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000B3A:
; H063+$00000B3A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00000B3C:
; H063+$00000B3C: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000B40:
; H063+$00000B40: 47eb0032  lea.l $32(a3), a3
        lea.l $32(a3), a3
L063_00000B44:
; H063+$00000B44: 7800  moveq #$0, d4
        moveq #0, d4
L063_00000B46:
; H063+$00000B46: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_00000B4A:
; H063+$00000B4A: 4a44  tst.w d4
        tst.w d4
L063_00000B4C:
; H063+$00000B4C: 67000050  beq.w $b9e
        beq.w H063+$B9E
L063_00000B50:
; H063+$00000B50: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000B54:
; H063+$00000B54: 5742  subq.w #$3, d2
        subq.w #$3, d2
L063_00000B56:
; H063+$00000B56: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000B5A:
; H063+$00000B5A: 182b003b  move.b $3b(a3), d4
        move.b $3b(a3), d4
L063_00000B5E:
; H063+$00000B5E: 4a42  tst.w d2
        tst.w d2
L063_00000B60:
; H063+$00000B60: 6a06  bpl.b $b68
        bpl.b H063+$B68
L063_00000B62:
; H063+$00000B62: 4442  neg.w d2
        neg.w d2
L063_00000B64:
; H063+$00000B64: e42c  lsr.b d2, d4
        lsr.b d2, d4
L063_00000B66:
; H063+$00000B66: 6002  bra.b $b6a
        bra.b H063+$B6A
L063_00000B68:
; H063+$00000B68: e52c  lsl.b d2, d4
        lsl.b d2, d4
L063_00000B6A:
; H063+$00000B6A: 1f04  move.b d4, -(a7)
        move.b d4, -(a7)
L063_00000B6C:
; H063+$00000B6C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_00000B70:
; H063+$00000B70: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_00000B76:
; H063+$00000B76: 1400  move.b d0, d2
        move.b d0, d2
L063_00000B78:
; H063+$00000B78: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_00000B7C:
; H063+$00000B7C: 4a42  tst.w d2
        tst.w d2
L063_00000B7E:
; H063+$00000B7E: 6600001e  bne.w $b9e
        bne.w H063+$B9E
L063_00000B82:
; H063+$00000B82: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000B86:
; H063+$00000B86: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00000B88:
; H063+$00000B88: 7801  moveq #$1, d4
        moveq #1, d4
L063_00000B8A:
; H063+$00000B8A: 4a42  tst.w d2
        tst.w d2
L063_00000B8C:
; H063+$00000B8C: 6a06  bpl.b $b94
        bpl.b H063+$B94
L063_00000B8E:
; H063+$00000B8E: 4442  neg.w d2
        neg.w d2
L063_00000B90:
; H063+$00000B90: e42c  lsr.b d2, d4
        lsr.b d2, d4
L063_00000B92:
; H063+$00000B92: 6002  bra.b $b96
        bra.b H063+$B96
L063_00000B94:
; H063+$00000B94: e52c  lsl.b d2, d4
        lsl.b d2, d4
L063_00000B96:
; H063+$00000B96: 024400ff  andi.w #$ff, d4
        andi.w #$ff, d4
L063_00000B9A:
; H063+$00000B9A: d96dfffc  add.w d4, -$4(a5)
        add.w d4, -$4(a5)
L063_00000B9E:
; H063+$00000B9E: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L063_00000BA2:
; H063+$00000BA2: 6488  bcc.b $b2c
        bcc.b H063+$B2C
L063_00000BA4:
; H063+$00000BA4: 422dfff6  clr.b -$a(a5)
        clr.b -$a(a5)
L063_00000BA8:
; H063+$00000BA8: 3b7c0003fffe  move.w #$3, -$2(a5)
        move.w #$3, -$2(a5)
L063_00000BAE:
; H063+$00000BAE: 0c6d0001fffe  cmpi.w #$1, -$2(a5)
        cmpi.w #$1, -$2(a5)
L063_00000BB4:
; H063+$00000BB4: 6500019a  bcs.w $d50
        bcs.w H063+$D50
L063_00000BB8:
; H063+$00000BB8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00000BBC:
; H063+$00000BBC: 7801  moveq #$1, d4
        moveq #1, d4
L063_00000BBE:
; H063+$00000BBE: 986dfffe  sub.w -$2(a5), d4
        sub.w -$2(a5), d4
L063_00000BC2:
; H063+$00000BC2: 4a44  tst.w d4
        tst.w d4
L063_00000BC4:
; H063+$00000BC4: 6a06  bpl.b $bcc
        bpl.b H063+$BCC
L063_00000BC6:
; H063+$00000BC6: 4444  neg.w d4
        neg.w d4
L063_00000BC8:
; H063+$00000BC8: e82a  lsr.b d4, d2
        lsr.b d4, d2
L063_00000BCA:
; H063+$00000BCA: 6002  bra.b $bce
        bra.b H063+$BCE
L063_00000BCC:
; H063+$00000BCC: e92a  lsl.b d4, d2
        lsl.b d4, d2
L063_00000BCE:
; H063+$00000BCE: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_00000BD0:
; H063+$00000BD0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_00000BD4:
; H063+$00000BD4: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_00000BDA:
; H063+$00000BDA: 1400  move.b d0, d2
        move.b d0, d2
L063_00000BDC:
; H063+$00000BDC: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_00000BE0:
; H063+$00000BE0: 4a42  tst.w d2
        tst.w d2
L063_00000BE2:
; H063+$00000BE2: 63000164  bls.w $d48
        bls.w H063+$D48
L063_00000BE6:
; H063+$00000BE6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000BEA:
; H063+$00000BEA: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00000BEE:
; H063+$00000BEE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000BF2:
; H063+$00000BF2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00000BF4:
; H063+$00000BF4: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000BF8:
; H063+$00000BF8: 47eb0032  lea.l $32(a3), a3
        lea.l $32(a3), a3
L063_00000BFC:
; H063+$00000BFC: 7800  moveq #$0, d4
        moveq #0, d4
L063_00000BFE:
; H063+$00000BFE: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_00000C02:
; H063+$00000C02: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00000C04:
; H063+$00000C04: c9fc0016  muls.w #$16, d4
        muls.w #$16, d4
L063_00000C08:
; H063+$00000C08: 47f90000406e  lea.l $406e.l, a3
        lea.l (H005+$406E).l, a3
L063_00000C0E:
; H063+$00000C0E: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L063_00000C12:
; H063+$00000C12: 48734800  pea.l (a3, d4.l)
        pea.l (a3, d4.l)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00000C16:
; H063+$00000C16: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00000C1C:
; H063+$00000C1C: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000C1E:
; H063+$00000C1E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000C22:
; H063+$00000C22: 142b0040  move.b $40(a3), d2
        move.b $40(a3), d2
L063_00000C26:
; H063+$00000C26: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L063_00000C2A:
; H063+$00000C2A: 6500000a  bcs.w $c36
        bcs.w H063+$C36
L063_00000C2E:
; H063+$00000C2E: 4a2dfff6  tst.b -$a(a5)
        tst.b -$a(a5)
L063_00000C32:
; H063+$00000C32: 6700001c  beq.w $c50
        beq.w H063+$C50
L063_00000C36:
; H063+$00000C36: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000C3A:
; H063+$00000C3A: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00000C3E:
; H063+$00000C3E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00000C42:
; H063+$00000C42: 486c0015  pea.l $15(a4)
        pea.l $15(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00000C46:
; H063+$00000C46: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00000C4C:
; H063+$00000C4C: 600000fa  bra.w $d48
        bra.w H063+$D48
L063_00000C50:
; H063+$00000C50: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00000C54:
; H063+$00000C54: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00000C56:
; H063+$00000C56: 7801  moveq #$1, d4
        moveq #1, d4
L063_00000C58:
; H063+$00000C58: 4a42  tst.w d2
        tst.w d2
L063_00000C5A:
; H063+$00000C5A: 6a06  bpl.b $c62
        bpl.b H063+$C62
L063_00000C5C:
; H063+$00000C5C: 4442  neg.w d2
        neg.w d2
L063_00000C5E:
; H063+$00000C5E: e42c  lsr.b d2, d4
        lsr.b d2, d4
L063_00000C60:
; H063+$00000C60: 6002  bra.b $c64
        bra.b H063+$C64
L063_00000C62:
; H063+$00000C62: e52c  lsl.b d2, d4
        lsl.b d2, d4
L063_00000C64:
; H063+$00000C64: 024400ff  andi.w #$ff, d4
        andi.w #$ff, d4
L063_00000C68:
; H063+$00000C68: b86dfffc  cmp.w -$4(a5), d4
        cmp.w -$4(a5), d4
L063_00000C6C:
; H063+$00000C6C: 670000a4  beq.w $d12
        beq.w H063+$D12
L063_00000C70:
; H063+$00000C70: 0c6d0001fffe  cmpi.w #$1, -$2(a5)
        cmpi.w #$1, -$2(a5)
L063_00000C76:
; H063+$00000C76: 6600001e  bne.w $c96
        bne.w H063+$C96
L063_00000C7A:
; H063+$00000C7A: 0c6d0004fffc  cmpi.w #$4, -$4(a5)
        cmpi.w #$4, -$4(a5)
L063_00000C80:
; H063+$00000C80: 63000014  bls.w $c96
        bls.w H063+$C96
L063_00000C84:
; H063+$00000C84: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000C86:
; H063+$00000C86: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000C8A:
; H063+$00000C8A: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00000C8E:
; H063+$00000C8E: 0c420037  cmpi.w #$37, d2
        cmpi.w #$37, d2
L063_00000C92:
; H063+$00000C92: 6600007e  bne.w $d12
        bne.w H063+$D12
L063_00000C96:
; H063+$00000C96: 0c6d0002fffe  cmpi.w #$2, -$2(a5)
        cmpi.w #$2, -$2(a5)
L063_00000C9C:
; H063+$00000C9C: 66000010  bne.w $cae
        bne.w H063+$CAE
L063_00000CA0:
; H063+$00000CA0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00000CA4:
; H063+$00000CA4: 02420001  andi.w #$1, d2
        andi.w #$1, d2
L063_00000CA8:
; H063+$00000CA8: 4a02  tst.b d2
        tst.b d2
L063_00000CAA:
; H063+$00000CAA: 67000066  beq.w $d12
        beq.w H063+$D12
L063_00000CAE:
; H063+$00000CAE: 0c6d0003fffe  cmpi.w #$3, -$2(a5)
        cmpi.w #$3, -$2(a5)
L063_00000CB4:
; H063+$00000CB4: 66000014  bne.w $cca
        bne.w H063+$CCA
L063_00000CB8:
; H063+$00000CB8: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000CBA:
; H063+$00000CBA: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000CBE:
; H063+$00000CBE: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00000CC2:
; H063+$00000CC2: 0c420037  cmpi.w #$37, d2
        cmpi.w #$37, d2
L063_00000CC6:
; H063+$00000CC6: 6700004a  beq.w $d12
        beq.w H063+$D12
L063_00000CCA:
; H063+$00000CCA: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000CCC:
; H063+$00000CCC: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000CD0:
; H063+$00000CD0: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00000CD4:
; H063+$00000CD4: 0c42001e  cmpi.w #$1e, d2
        cmpi.w #$1e, d2
L063_00000CD8:
; H063+$00000CD8: 67000026  beq.w $d00
        beq.w H063+$D00
L063_00000CDC:
; H063+$00000CDC: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000CDE:
; H063+$00000CDE: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000CE2:
; H063+$00000CE2: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00000CE6:
; H063+$00000CE6: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L063_00000CEA:
; H063+$00000CEA: 67000014  beq.w $d00
        beq.w H063+$D00
L063_00000CEE:
; H063+$00000CEE: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000CF0:
; H063+$00000CF0: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000CF4:
; H063+$00000CF4: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00000CF8:
; H063+$00000CF8: 0c42000c  cmpi.w #$c, d2
        cmpi.w #$c, d2
L063_00000CFC:
; H063+$00000CFC: 66000034  bne.w $d32
        bne.w H063+$D32
L063_00000D00:
; H063+$00000D00: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000D02:
; H063+$00000D02: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00000D06:
; H063+$00000D06: 142b0034  move.b $34(a3), d2
        move.b $34(a3), d2
L063_00000D0A:
; H063+$00000D0A: 0c42005d  cmpi.w #$5d, d2
        cmpi.w #$5d, d2
L063_00000D0E:
; H063+$00000D0E: 67000022  beq.w $d32
        beq.w H063+$D32
L063_00000D12:
; H063+$00000D12: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000D16:
; H063+$00000D16: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00000D1A:
; H063+$00000D1A: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00000D1E:
; H063+$00000D1E: 486c0017  pea.l $17(a4)
        pea.l $17(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00000D22:
; H063+$00000D22: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00000D28:
; H063+$00000D28: 1b7c0001fff6  move.b #$1, -$a(a5)
        move.b #$1, -$a(a5)
L063_00000D2E:
; H063+$00000D2E: 60000018  bra.w $d48
        bra.w H063+$D48
L063_00000D32:
; H063+$00000D32: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000D36:
; H063+$00000D36: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00000D3A:
; H063+$00000D3A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00000D3E:
; H063+$00000D3E: 486c001a  pea.l $1a(a4)
        pea.l $1a(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00000D42:
; H063+$00000D42: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00000D48:
; H063+$00000D48: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L063_00000D4C:
; H063+$00000D4C: 6400fe60  bcc.w $bae
        bcc.w H063+$BAE
L063_00000D50:
; H063+$00000D50: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L063_00000D54:
; H063+$00000D54: 6700001e  beq.w $d74
        beq.w H063+$D74
L063_00000D58:
; H063+$00000D58: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L063_00000D5C:
; H063+$00000D5C: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L063_00000D60:
; H063+$00000D60: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00000D64:
; H063+$00000D64: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00000D66:
; H063+$00000D66: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00000D6A:
; H063+$00000D6A: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00000D6E:
; H063+$00000D6E: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00000D74:
; H063+$00000D74: 4e5d  unlk a5
        unlk a5
L063_00000D76:
; H063+$00000D76: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00000D78:
; H063+$00000D78: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00000D7A:
; H063+$00000D7A: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L063_00000D7E:
; H063+$00000D7E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00000D80 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H030+$0256, H029+$03E2, H030+$0B6C.
;   - Richiama H030+$0256.
;   - Richiama H029+$03E2.
;   - Richiama H030+$0B6C.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento); H005+$3E04 (puntatore stato persistente A, 2048 byte); H005+$3364 (testa della lista del party).
; Chiamanti diretti: H027+$097C, H027+$19C0, H062+$03E0, H063+$2B3E, H063+$3ADE, H013+$4DCE e altri 36
; --------------------------------------------------------------------------
L063_00000D80:
; H063+$00000D80: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00000D82:
; H063+$00000D82: 287af37c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00000D86:
; H063+$00000D86: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00000D8A:
; H063+$00000D8A: 0c39000300003de3  cmpi.b #$3, $3de3.l
        cmpi.b #$3, (H005+$3DE3).l
L063_00000D92:
; H063+$00000D92: 66000010  bne.w $da4
        bne.w H063+$DA4
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_00000D96:
; H063+$00000D96: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_00000D9C:
; H063+$00000D9C: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L063_00000DA0:
; H063+$00000DA0: 6700000c  beq.w $dae
        beq.w H063+$DAE
L063_00000DA4:
; H063+$00000DA4: 4a39000024ae  tst.b $24ae.l
        tst.b (H005+$24AE).l
L063_00000DAA:
; H063+$00000DAA: 67000006  beq.w $db2
        beq.w H063+$DB2
L063_00000DAE:
; H063+$00000DAE: 600001e6  bra.w $f96
        bra.w H063+$F96
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00000DB2:
; H063+$00000DB2: 4a3900003de3  tst.b $3de3.l
        tst.b (H005+$3DE3).l
L063_00000DB8:
; H063+$00000DB8: 6600000c  bne.w $dc6
        bne.w H063+$DC6
L063_00000DBC:
; H063+$00000DBC: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L063_00000DC2:
; H063+$00000DC2: 60000008  bra.w $dcc
        bra.w H063+$DCC
L063_00000DC6:
; H063+$00000DC6: 3b7c0011fffa  move.w #$11, -$6(a5)
        move.w #$11, -$6(a5)
L063_00000DCC:
; H063+$00000DCC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00000DD0:
; H063+$00000DD0: 13c20000248d  move.b d2, $248d.l
        move.b d2, (H005+$248D).l
L063_00000DD6:
; H063+$00000DD6: 13fc00040000248b  move.b #$4, $248b.l
        move.b #$4, (H005+$248B).l
L063_00000DDE:
; H063+$00000DDE: 13fc00260000248c  move.b #$26, $248c.l
        move.b #$26, (H005+$248C).l
L063_00000DE6:
; H063+$00000DE6: 13fc00030000248a  move.b #$3, $248a.l
        move.b #$3, (H005+$248A).l
L063_00000DEE:
; H063+$00000DEE: 3b7c0002fff8  move.w #$2, -$8(a5)
        move.w #$2, -$8(a5)
L063_00000DF4:
; H063+$00000DF4: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L063_00000DF8:
; H063+$00000DF8: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000DFC:
; H063+$00000DFC: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00000E00:
; H063+$00000E00: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00000E02:
; H063+$00000E02: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L063_00000E06:
; H063+$00000E06: 486c001c  pea.l $1c(a4)
        pea.l $1c(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00000E0A:
; H063+$00000E0A: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00000E10:
; H063+$00000E10: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L063_00000E14:
; H063+$00000E14: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000E18:
; H063+$00000E18: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00000E1C:
; H063+$00000E1C: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00000E1E:
; H063+$00000E1E: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L063_00000E22:
; H063+$00000E22: 486c0021  pea.l $21(a4)
        pea.l $21(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00000E26:
; H063+$00000E26: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00000E2C:
; H063+$00000E2C: 546dfff8  addq.w #$2, -$8(a5)
        addq.w #$2, -$8(a5)
; STATO: H005+$3364 = testa della lista del party
L063_00000E30:
; H063+$00000E30: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L063_00000E38:
; H063+$00000E38: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_00000E3C:
; H063+$00000E3C: 67000142  beq.w $f80
        beq.w H063+$F80
L063_00000E40:
; H063+$00000E40: 48790000248a  pea.l $248a.l
        pea.l (H005+$248A).l
L063_00000E46:
; H063+$00000E46: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L063_00000E4A:
; H063+$00000E4A: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L063_00000E50:
; H063+$00000E50: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L063_00000E54:
; H063+$00000E54: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000E58:
; H063+$00000E58: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00000E5C:
; H063+$00000E5C: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00000E60:
; H063+$00000E60: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00000E66:
; H063+$00000E66: 242dfffc  move.l -$4(a5), d2
        move.l -$4(a5), d2
L063_00000E6A:
; H063+$00000E6A: b4ad000c  cmp.l $c(a5), d2
        cmp.l $c(a5), d2
L063_00000E6E:
; H063+$00000E6E: 66000022  bne.w $e92
        bne.w H063+$E92
L063_00000E72:
; H063+$00000E72: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L063_00000E76:
; H063+$00000E76: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000E7A:
; H063+$00000E7A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00000E7E:
; H063+$00000E7E: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00000E80:
; H063+$00000E80: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00000E84:
; H063+$00000E84: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00000E88:
; H063+$00000E88: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00000E8E:
; H063+$00000E8E: 60000016  bra.w $ea6
        bra.w H063+$EA6
L063_00000E92:
; H063+$00000E92: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L063_00000E96:
; H063+$00000E96: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L063_00000E9A:
; H063+$00000E9A: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000E9E:
; H063+$00000E9E: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00000EA0:
; H063+$00000EA0: 4eb900001f34  jsr $1f34.l
        jsr (H063+$1F34).l
L063_00000EA6:
; H063+$00000EA6: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000EA8:
; H063+$00000EA8: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000EAC:
; H063+$00000EAC: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_00000EB0:
; H063+$00000EB0: 0c420033  cmpi.w #$33, d2
        cmpi.w #$33, d2
L063_00000EB4:
; H063+$00000EB4: 6400000c  bcc.w $ec2
        bcc.w H063+$EC2
L063_00000EB8:
; H063+$00000EB8: 3b7c0001fff6  move.w #$1, -$a(a5)
        move.w #$1, -$a(a5)
L063_00000EBE:
; H063+$00000EBE: 6000003e  bra.w $efe
        bra.w H063+$EFE
L063_00000EC2:
; H063+$00000EC2: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000EC4:
; H063+$00000EC4: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000EC8:
; H063+$00000EC8: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_00000ECC:
; H063+$00000ECC: 0c42003d  cmpi.w #$3d, d2
        cmpi.w #$3d, d2
L063_00000ED0:
; H063+$00000ED0: 6400000c  bcc.w $ede
        bcc.w H063+$EDE
L063_00000ED4:
; H063+$00000ED4: 3b7c0002fff6  move.w #$2, -$a(a5)
        move.w #$2, -$a(a5)
L063_00000EDA:
; H063+$00000EDA: 60000022  bra.w $efe
        bra.w H063+$EFE
L063_00000EDE:
; H063+$00000EDE: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000EE0:
; H063+$00000EE0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000EE4:
; H063+$00000EE4: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_00000EE8:
; H063+$00000EE8: 0c420046  cmpi.w #$46, d2
        cmpi.w #$46, d2
L063_00000EEC:
; H063+$00000EEC: 6400000c  bcc.w $efa
        bcc.w H063+$EFA
L063_00000EF0:
; H063+$00000EF0: 3b7c0001fff6  move.w #$1, -$a(a5)
        move.w #$1, -$a(a5)
L063_00000EF6:
; H063+$00000EF6: 60000006  bra.w $efe
        bra.w H063+$EFE
L063_00000EFA:
; H063+$00000EFA: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L063_00000EFE:
; H063+$00000EFE: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L063_00000F02:
; H063+$00000F02: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00000F06:
; H063+$00000F06: 06420020  addi.w #$20, d2
        addi.w #$20, d2
L063_00000F0A:
; H063+$00000F0A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00000F0C:
; H063+$00000F0C: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000F10:
; H063+$00000F10: 4eb900000fa0  jsr $fa0.l
        jsr (H063+$FA0).l
L063_00000F16:
; H063+$00000F16: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000F18:
; H063+$00000F18: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000F1C:
; H063+$00000F1C: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_00000F20:
; H063+$00000F20: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L063_00000F24:
; H063+$00000F24: 6400000c  bcc.w $f32
        bcc.w H063+$F32
L063_00000F28:
; H063+$00000F28: 3b7c0002fff6  move.w #$2, -$a(a5)
        move.w #$2, -$a(a5)
L063_00000F2E:
; H063+$00000F2E: 60000022  bra.w $f52
        bra.w H063+$F52
L063_00000F32:
; H063+$00000F32: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000F34:
; H063+$00000F34: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000F38:
; H063+$00000F38: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_00000F3C:
; H063+$00000F3C: 0c420064  cmpi.w #$64, d2
        cmpi.w #$64, d2
L063_00000F40:
; H063+$00000F40: 6400000c  bcc.w $f4e
        bcc.w H063+$F4E
L063_00000F44:
; H063+$00000F44: 3b7c0001fff6  move.w #$1, -$a(a5)
        move.w #$1, -$a(a5)
L063_00000F4A:
; H063+$00000F4A: 60000006  bra.w $f52
        bra.w H063+$F52
L063_00000F4E:
; H063+$00000F4E: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L063_00000F52:
; H063+$00000F52: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L063_00000F56:
; H063+$00000F56: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00000F5A:
; H063+$00000F5A: 06420024  addi.w #$24, d2
        addi.w #$24, d2
L063_00000F5E:
; H063+$00000F5E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00000F60:
; H063+$00000F60: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000F64:
; H063+$00000F64: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00000F66:
; H063+$00000F66: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00000F68:
; H063+$00000F68: 4eb90000103a  jsr $103a.l
        jsr (H063+$103A).l
L063_00000F6E:
; H063+$00000F6E: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L063_00000F72:
; H063+$00000F72: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00000F76:
; H063+$00000F76: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L063_00000F7C:
; H063+$00000F7C: 6000feba  bra.w $e38
        bra.w H063+$E38
L063_00000F80:
; H063+$00000F80: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L063_00000F84:
; H063+$00000F84: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L063_00000F88:
; H063+$00000F88: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00000F8C:
; H063+$00000F8C: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00000F90:
; H063+$00000F90: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00000F96:
; H063+$00000F96: 4e5d  unlk a5
        unlk a5
L063_00000F98:
; H063+$00000F98: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00000F9A:
; H063+$00000F9A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00000F9C:
; H063+$00000F9C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00000F9E:
; H063+$00000F9E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00000FA0 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H045+$01D6, H026+$0254, H030+$0256.
;   - Richiama H045+$01D6.
;   - Richiama H026+$0254.
;   - Richiama H030+$0256.
; Chiamanti diretti: H063+$1222, H063+$0F10, H065+$0DA2
; --------------------------------------------------------------------------
L063_00000FA0:
; H063+$00000FA0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00000FA2:
; H063+$00000FA2: 287af15c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00000FA6:
; H063+$00000FA6: 4e55ffac  link.w a5, #$ffac
        link.w a5, #$ffac
L063_00000FAA:
; H063+$00000FAA: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00000FAE:
; H063+$00000FAE: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_00000FB2:
; H063+$00000FB2: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000FB4:
; H063+$00000FB4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00000FB8:
; H063+$00000FB8: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_00000FBC:
; H063+$00000FBC: 0442003c  subi.w #$3c, d2
        subi.w #$3c, d2
L063_00000FC0:
; H063+$00000FC0: 4a42  tst.w d2
        tst.w d2
L063_00000FC2:
; H063+$00000FC2: 6c02  bge.b $fc6
        bge.b H063+$FC6
L063_00000FC4:
; H063+$00000FC4: 4442  neg.w d2
        neg.w d2
L063_00000FC6:
; H063+$00000FC6: 48c2  ext.l d2
        ext.l d2
L063_00000FC8:
; H063+$00000FC8: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_00000FCA:
; H063+$00000FCA: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00000FCC:
; H063+$00000FCC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00000FD0:
; H063+$00000FD0: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_00000FD4:
; H063+$00000FD4: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_00000FD8:
; H063+$00000FD8: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L063_00000FDE:
; H063+$00000FDE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00000FE2:
; H063+$00000FE2: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_00000FE6:
; H063+$00000FE6: 6100f12a  bsr.w $112
        bsr.w H063+$112
L063_00000FEA:
; H063+$00000FEA: 7400  moveq #$0, d2
        moveq #0, d2
L063_00000FEC:
; H063+$00000FEC: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00000FF0:
; H063+$00000FF0: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_00000FF4:
; H063+$00000FF4: 0c42003c  cmpi.w #$3c, d2
        cmpi.w #$3c, d2
L063_00000FF8:
; H063+$00000FF8: 6300001a  bls.w $1014
        bls.w H063+$1014
L063_00000FFC:
; H063+$00000FFC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00001000:
; H063+$00001000: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_00001004:
; H063+$00001004: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001008:
; H063+$00001008: 486c0028  pea.l $28(a4)
        pea.l $28(a4)
L063_0000100C:
; H063+$0000100C: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H026+$0254 (sub_H026_00000254)
L063_0000100E:
; H063+$0000100E: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L063_00001014:
; H063+$00001014: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L063_00001018:
; H063+$00001018: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L063_0000101C:
; H063+$0000101C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001020:
; H063+$00001020: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001022:
; H063+$00001022: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00001026:
; H063+$00001026: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_0000102A:
; H063+$0000102A: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00001030:
; H063+$00001030: 4e5d  unlk a5
        unlk a5
L063_00001032:
; H063+$00001032: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001034:
; H063+$00001034: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001036:
; H063+$00001036: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_00001038:
; H063+$00001038: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_0000103A [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H045+$01D6, H030+$0256, H026+$000C, H026+$0254.
;   - Richiama H045+$01D6.
;   - Richiama H030+$0256.
;   - Richiama H026+$000C.
;   - Richiama H026+$0254.
; Chiamanti diretti: H063+$11EA, H063+$0F68, H013+$3228, H065+$0C8A
; --------------------------------------------------------------------------
L063_0000103A:
; H063+$0000103A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000103C:
; H063+$0000103C: 287af0c2  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001040:
; H063+$00001040: 4e55ffaa  link.w a5, #$ffaa
        link.w a5, #$ffaa
L063_00001044:
; H063+$00001044: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001046:
; H063+$00001046: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_0000104A:
; H063+$0000104A: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_0000104E:
; H063+$0000104E: 7800  moveq #$0, d4
        moveq #0, d4
L063_00001050:
; H063+$00001050: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00001054:
; H063+$00001054: 182b0064  move.b $64(a3), d4
        move.b $64(a3), d4
L063_00001058:
; H063+$00001058: b444  cmp.w d4, d2
        cmp.w d4, d2
L063_0000105A:
; H063+$0000105A: 6400000c  bcc.w $1068
        bcc.w H063+$1068
L063_0000105E:
; H063+$0000105E: 3b7c000effac  move.w #$e, -$54(a5)
        move.w #$e, -$54(a5)
L063_00001064:
; H063+$00001064: 60000008  bra.w $106e
        bra.w H063+$106E
L063_00001068:
; H063+$00001068: 3b7c000affac  move.w #$a, -$54(a5)
        move.w #$a, -$54(a5)
L063_0000106E:
; H063+$0000106E: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L063_00001072:
; H063+$00001072: 67000008  beq.w $107c
        beq.w H063+$107C
L063_00001076:
; H063+$00001076: 3b7c000dffac  move.w #$d, -$54(a5)
        move.w #$d, -$54(a5)
L063_0000107C:
; H063+$0000107C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00001080:
; H063+$00001080: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_00001084:
; H063+$00001084: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001086:
; H063+$00001086: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_0000108A:
; H063+$0000108A: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_0000108E:
; H063+$0000108E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_00001090:
; H063+$00001090: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00001092:
; H063+$00001092: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001096:
; H063+$00001096: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L063_0000109A:
; H063+$0000109A: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_0000109E:
; H063+$0000109E: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L063_000010A4:
; H063+$000010A4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_000010A8:
; H063+$000010A8: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_000010AC:
; H063+$000010AC: 6100f064  bsr.w $112
        bsr.w H063+$112
L063_000010B0:
; H063+$000010B0: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L063_000010B4:
; H063+$000010B4: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L063_000010B8:
; H063+$000010B8: 3f2dffac  move.w -$54(a5), -(a7)
        move.w -$54(a5), -(a7)
L063_000010BC:
; H063+$000010BC: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000010BE:
; H063+$000010BE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_000010C2:
; H063+$000010C2: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_000010C6:
; H063+$000010C6: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_000010CC:
; H063+$000010CC: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L063_000010D0:
; H063+$000010D0: 67000082  beq.w $1154
        beq.w H063+$1154
L063_000010D4:
; H063+$000010D4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_000010D8:
; H063+$000010D8: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; -> H026+$000C (trampoline_H026_0014)
L063_000010DC:
; H063+$000010DC: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L063_000010E2:
; H063+$000010E2: 3b40ffaa  move.w d0, -$56(a5)
        move.w d0, -$56(a5)
L063_000010E6:
; H063+$000010E6: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_000010EA:
; H063+$000010EA: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_000010EE:
; H063+$000010EE: 7400  moveq #$0, d2
        moveq #0, d2
L063_000010F0:
; H063+$000010F0: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_000010F4:
; H063+$000010F4: 142b0064  move.b $64(a3), d2
        move.b $64(a3), d2
L063_000010F8:
; H063+$000010F8: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_000010FA:
; H063+$000010FA: 4227  clr.b -(a7)
        clr.b -(a7)
L063_000010FC:
; H063+$000010FC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001100:
; H063+$00001100: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L063_00001104:
; H063+$00001104: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_00001108:
; H063+$00001108: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L063_0000110E:
; H063+$0000110E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_00001112:
; H063+$00001112: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_00001116:
; H063+$00001116: 6100effa  bsr.w $112
        bsr.w H063+$112
L063_0000111A:
; H063+$0000111A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_0000111E:
; H063+$0000111E: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L063_00001122:
; H063+$00001122: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001126:
; H063+$00001126: 486c002a  pea.l $2a(a4)
        pea.l $2a(a4)
L063_0000112A:
; H063+$0000112A: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H026+$0254 (sub_H026_00000254)
L063_0000112C:
; H063+$0000112C: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L063_00001132:
; H063+$00001132: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L063_00001136:
; H063+$00001136: d46dffaa  add.w -$56(a5), d2
        add.w -$56(a5), d2
L063_0000113A:
; H063+$0000113A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_0000113C:
; H063+$0000113C: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L063_00001140:
; H063+$00001140: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001144:
; H063+$00001144: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001146:
; H063+$00001146: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L063_0000114A:
; H063+$0000114A: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_0000114E:
; H063+$0000114E: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00001154:
; H063+$00001154: 4e5d  unlk a5
        unlk a5
L063_00001156:
; H063+$00001156: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001158:
; H063+$00001158: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_0000115A:
; H063+$0000115A: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L063_0000115E:
; H063+$0000115E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_1350 [parziale]
; Scopo: Trampolino verso H063+$1350; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$1350.
; Chiamanti diretti: H027+$0FBC, H027+$25A8, H096+$3C06, H096+$40CA, H096+$2286, H059+$1560 e altri 5
; --------------------------------------------------------------------------
L063_00001160:
; H063+$00001160: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001162:
; H063+$00001162: 287aef9c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001166:
; H063+$00001166: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_0000116A:
; H063+$0000116A: 4a39000024c7  tst.b $24c7.l
        tst.b (H005+$24C7).l
L063_00001170:
; H063+$00001170: 66000006  bne.w $1178
        bne.w H063+$1178
L063_00001174:
; H063+$00001174: 600001da  bra.w $1350
        bra.w H063+$1350
L063_00001178:
; H063+$00001178: 4239000024c7  clr.b $24c7.l
        clr.b (H005+$24C7).l
L063_0000117E:
; H063+$0000117E: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_00001182:
; H063+$00001182: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001186:
; H063+$00001186: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_0000118A:
; H063+$0000118A: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_0000118E:
; H063+$0000118E: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00001194:
; H063+$00001194: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L063_0000119A:
; H063+$0000119A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000119E:
; H063+$0000119E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_000011A2:
; H063+$000011A2: 486c002c  pea.l $2c(a4)
        pea.l $2c(a4)
L063_000011A6:
; H063+$000011A6: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L063_000011AA:
; H063+$000011AA: 4227  clr.b -(a7)
        clr.b -(a7)
L063_000011AC:
; H063+$000011AC: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L063_000011B2:
; H063+$000011B2: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L063_000011B6:
; H063+$000011B6: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_000011BA:
; H063+$000011BA: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_000011BE:
; H063+$000011BE: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_000011C0:
; H063+$000011C0: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000011C2:
; H063+$000011C2: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_000011C6:
; H063+$000011C6: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000011C8:
; H063+$000011C8: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L063_000011CC:
; H063+$000011CC: 486c002e  pea.l $2e(a4)
        pea.l $2e(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_000011D0:
; H063+$000011D0: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_000011D6:
; H063+$000011D6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000011DA:
; H063+$000011DA: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L063_000011DE:
; H063+$000011DE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_000011E2:
; H063+$000011E2: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_000011E4:
; H063+$000011E4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000011E6:
; H063+$000011E6: 4227  clr.b -(a7)
        clr.b -(a7)
L063_000011E8:
; H063+$000011E8: 4227  clr.b -(a7)
        clr.b -(a7)
L063_000011EA:
; H063+$000011EA: 6100fe4e  bsr.w $103a
        bsr.w H063+$103A
L063_000011EE:
; H063+$000011EE: 546dfffc  addq.w #$2, -$4(a5)
        addq.w #$2, -$4(a5)
L063_000011F2:
; H063+$000011F2: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_000011F6:
; H063+$000011F6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_000011FA:
; H063+$000011FA: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_000011FC:
; H063+$000011FC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000011FE:
; H063+$000011FE: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001202:
; H063+$00001202: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001204:
; H063+$00001204: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00001208:
; H063+$00001208: 486c0038  pea.l $38(a4)
        pea.l $38(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_0000120C:
; H063+$0000120C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00001212:
; H063+$00001212: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00001216:
; H063+$00001216: 3f3c001a  move.w #$1a, -(a7)
        move.w #$1a, -(a7)
L063_0000121A:
; H063+$0000121A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_0000121E:
; H063+$0000121E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001220:
; H063+$00001220: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00001222:
; H063+$00001222: 6100fd7c  bsr.w $fa0
        bsr.w H063+$FA0
L063_00001226:
; H063+$00001226: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_0000122A:
; H063+$0000122A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_0000122C:
; H063+$0000122C: 33c20000334c  move.w d2, $334c.l
        move.w d2, (H005+$334C).l
L063_00001232:
; H063+$00001232: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001236:
; H063+$00001236: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L063_0000123A:
; H063+$0000123A: 6700005c  beq.w $1298
        beq.w H063+$1298
L063_0000123E:
; H063+$0000123E: 546dfffc  addq.w #$2, -$4(a5)
        addq.w #$2, -$4(a5)
L063_00001242:
; H063+$00001242: 3b7c0017fffe  move.w #$17, -$2(a5)
        move.w #$17, -$2(a5)
L063_00001248:
; H063+$00001248: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000124C:
; H063+$0000124C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001250:
; H063+$00001250: 2f2b0154  move.l $154(a3), -(a7)
        move.l $154(a3), -(a7)
L063_00001254:
; H063+$00001254: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001256:
; H063+$00001256: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001258:
; H063+$00001258: 4227  clr.b -(a7)
        clr.b -(a7)
L063_0000125A:
; H063+$0000125A: 4227  clr.b -(a7)
        clr.b -(a7)
L063_0000125C:
; H063+$0000125C: 6100f754  bsr.w $9b2
        bsr.w H063+$9B2
L063_00001260:
; H063+$00001260: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_00001264:
; H063+$00001264: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001268:
; H063+$00001268: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_0000126A:
; H063+$0000126A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_0000126C:
; H063+$0000126C: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001270:
; H063+$00001270: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001274:
; H063+$00001274: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001276:
; H063+$00001276: 5442  addq.w #$2, d2
        addq.w #$2, d2
L063_00001278:
; H063+$00001278: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_0000127A:
; H063+$0000127A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_0000127E:
; H063+$0000127E: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001280:
; H063+$00001280: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00001284:
; H063+$00001284: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00001288:
; H063+$00001288: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L063_0000128C:
; H063+$0000128C: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00001290:
; H063+$00001290: 4853  pea.l (a3)
        pea.l (a3)
; -> H030+$0302 (trampoline_H030_0470)
L063_00001292:
; H063+$00001292: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L063_00001298:
; H063+$00001298: 34390000334c  move.w $334c.l, d2
        move.w (H005+$334C).l, d2
L063_0000129E:
; H063+$0000129E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_000012A0:
; H063+$000012A0: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_000012A4:
; H063+$000012A4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000012A8:
; H063+$000012A8: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L063_000012AC:
; H063+$000012AC: 6600003a  bne.w $12e8
        bne.w H063+$12E8
L063_000012B0:
; H063+$000012B0: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_000012B4:
; H063+$000012B4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_000012B8:
; H063+$000012B8: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_000012BA:
; H063+$000012BA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000012BC:
; H063+$000012BC: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_000012C0:
; H063+$000012C0: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000012C2:
; H063+$000012C2: 7400  moveq #$0, d2
        moveq #0, d2
L063_000012C4:
; H063+$000012C4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000012C8:
; H063+$000012C8: 142b0197  move.b $197(a3), d2
        move.b $197(a3), d2
L063_000012CC:
; H063+$000012CC: c5fc000e  muls.w #$e, d2
        muls.w #$e, d2
L063_000012D0:
; H063+$000012D0: 47f900004b00  lea.l $4b00.l, a3
        lea.l (H005+$4B00).l, a3
L063_000012D6:
; H063+$000012D6: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L063_000012DA:
; H063+$000012DA: 48732800  pea.l (a3, d2.l)
        pea.l (a3, d2.l)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_000012DE:
; H063+$000012DE: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_000012E4:
; H063+$000012E4: 6000006a  bra.w $1350
        bra.w H063+$1350
L063_000012E8:
; H063+$000012E8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000012EC:
; H063+$000012EC: 4eb90000135a  jsr $135a.l
        jsr (H063+$135A).l
L063_000012F2:
; H063+$000012F2: 1400  move.b d0, d2
        move.b d0, d2
L063_000012F4:
; H063+$000012F4: 4a02  tst.b d2
        tst.b d2
L063_000012F6:
; H063+$000012F6: 67000026  beq.w $131e
        beq.w H063+$131E
L063_000012FA:
; H063+$000012FA: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_000012FE:
; H063+$000012FE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001302:
; H063+$00001302: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001304:
; H063+$00001304: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00001306:
; H063+$00001306: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_0000130A:
; H063+$0000130A: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000130C:
; H063+$0000130C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001310:
; H063+$00001310: 486c003b  pea.l $3b(a4)
        pea.l $3b(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00001314:
; H063+$00001314: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_0000131A:
; H063+$0000131A: 60000034  bra.w $1350
        bra.w H063+$1350
L063_0000131E:
; H063+$0000131E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00001322:
; H063+$00001322: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00001326:
; H063+$00001326: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001328:
; H063+$00001328: 1413  move.b (a3), d2
        move.b (a3), d2
L063_0000132A:
; H063+$0000132A: 4a42  tst.w d2
        tst.w d2
L063_0000132C:
; H063+$0000132C: 63000022  bls.w $1350
        bls.w H063+$1350
L063_00001330:
; H063+$00001330: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_00001334:
; H063+$00001334: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001338:
; H063+$00001338: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_0000133A:
; H063+$0000133A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_0000133C:
; H063+$0000133C: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00001340:
; H063+$00001340: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001342:
; H063+$00001342: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L063_00001346:
; H063+$00001346: 486c0046  pea.l $46(a4)
        pea.l $46(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_0000134A:
; H063+$0000134A: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00001350:
; H063+$00001350: 4e5d  unlk a5
        unlk a5
L063_00001352:
; H063+$00001352: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001354:
; H063+$00001354: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001356:
; H063+$00001356: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00001358:
; H063+$00001358: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_0000135A [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H063+$12EC, H096+$2978, H096+$1C2E, H096+$1F4C, H062+$0276, H097+$0258 e altri 5
; --------------------------------------------------------------------------
L063_0000135A:
; H063+$0000135A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000135C:
; H063+$0000135C: 287aeda2  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001360:
; H063+$00001360: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L063_00001364:
; H063+$00001364: 422dfff9  clr.b -$7(a5)
        clr.b -$7(a5)
L063_00001368:
; H063+$00001368: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L063_0000136E:
; H063+$0000136E: 0c6d0004fffe  cmpi.w #$4, -$2(a5)
        cmpi.w #$4, -$2(a5)
L063_00001374:
; H063+$00001374: 62000036  bhi.w $13ac
        bhi.w H063+$13AC
L063_00001378:
; H063+$00001378: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000137C:
; H063+$0000137C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001380:
; H063+$00001380: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00001382:
; H063+$00001382: 47f900004066  lea.l $4066.l, a3
        lea.l (H005+$4066).l, a3
L063_00001388:
; H063+$00001388: 7800  moveq #$0, d4
        moveq #0, d4
L063_0000138A:
; H063+$0000138A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_0000138E:
; H063+$0000138E: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L063_00001390:
; H063+$00001390: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L063_00001394:
; H063+$00001394: 6100f5b0  bsr.w $946
        bsr.w H063+$946
L063_00001398:
; H063+$00001398: 1400  move.b d0, d2
        move.b d0, d2
L063_0000139A:
; H063+$0000139A: 4a02  tst.b d2
        tst.b d2
L063_0000139C:
; H063+$0000139C: 67000008  beq.w $13a6
        beq.w H063+$13A6
L063_000013A0:
; H063+$000013A0: 1b7c0001fff9  move.b #$1, -$7(a5)
        move.b #$1, -$7(a5)
L063_000013A6:
; H063+$000013A6: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L063_000013AA:
; H063+$000013AA: 64c2  bcc.b $136e
        bcc.b H063+$136E
L063_000013AC:
; H063+$000013AC: 102dfff9  move.b -$7(a5), d0
        move.b -$7(a5), d0
L063_000013B0:
; H063+$000013B0: 60000002  bra.w $13b4
        bra.w H063+$13B4
L063_000013B4:
; H063+$000013B4: 4e5d  unlk a5
        unlk a5
L063_000013B6:
; H063+$000013B6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000013B8:
; H063+$000013B8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000013BA:
; H063+$000013BA: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_000013BC:
; H063+$000013BC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000013BE [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H029+$03E2, H073+$130A.
;   - Richiama H029+$03E2.
;   - Richiama H073+$130A.
; Chiamanti diretti: H027+$0F56, H027+$0D5E, H085+$08E0, H012+$2576, H012+$2C06, H096+$2490 e altri 18
; --------------------------------------------------------------------------
L063_000013BE:
; H063+$000013BE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000013C0:
; H063+$000013C0: 287aed3e  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000013C4:
; H063+$000013C4: 4e55ffe4  link.w a5, #$ffe4
        link.w a5, #$ffe4
L063_000013C8:
; H063+$000013C8: 422dffeb  clr.b -$15(a5)
        clr.b -$15(a5)
L063_000013CC:
; H063+$000013CC: 0c2d000cffeb  cmpi.b #$c, -$15(a5)
        cmpi.b #$c, -$15(a5)
L063_000013D2:
; H063+$000013D2: 6200001c  bhi.w $13f0
        bhi.w H063+$13F0
L063_000013D6:
; H063+$000013D6: 7400  moveq #$0, d2
        moveq #0, d2
L063_000013D8:
; H063+$000013D8: 142dffeb  move.b -$15(a5), d2
        move.b -$15(a5), d2
L063_000013DC:
; H063+$000013DC: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_000013DE:
; H063+$000013DE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000013E2:
; H063+$000013E2: 47eb0154  lea.l $154(a3), a3
        lea.l $154(a3), a3
L063_000013E6:
; H063+$000013E6: 42b32000  clr.l (a3, d2.w)
        clr.l (a3, d2.w)
L063_000013EA:
; H063+$000013EA: 522dffeb  addq.b #$1, -$15(a5)
        addq.b #$1, -$15(a5)
L063_000013EE:
; H063+$000013EE: 64dc  bcc.b $13cc
        bcc.b H063+$13CC
L063_000013F0:
; H063+$000013F0: 422dfff6  clr.b -$a(a5)
        clr.b -$a(a5)
L063_000013F4:
; H063+$000013F4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000013F8:
; H063+$000013F8: 422b014f  clr.b $14f(a3)
        clr.b $14f(a3)
L063_000013FC:
; H063+$000013FC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001400:
; H063+$00001400: 2b6b0150fff8  move.l $150(a3), -$8(a5)
        move.l $150(a3), -$8(a5)
L063_00001406:
; H063+$00001406: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000140A:
; H063+$0000140A: 422b0188  clr.b $188(a3)
        clr.b $188(a3)
L063_0000140E:
; H063+$0000140E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001412:
; H063+$00001412: 426b018c  clr.w $18c(a3)
        clr.w $18c(a3)
L063_00001416:
; H063+$00001416: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L063_0000141A:
; H063+$0000141A: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L063_0000141E:
; H063+$0000141E: 6700017c  beq.w $159c
        beq.w H063+$159C
L063_00001422:
; H063+$00001422: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001426:
; H063+$00001426: 486b014f  pea.l $14f(a3)
        pea.l $14f(a3)
L063_0000142A:
; H063+$0000142A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L063_0000142E:
; H063+$0000142E: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L063_00001434:
; H063+$00001434: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001438:
; H063+$00001438: 3b6b003effe6  move.w $3e(a3), -$1a(a5)
        move.w $3e(a3), -$1a(a5)
L063_0000143E:
; H063+$0000143E: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001440:
; H063+$00001440: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001444:
; H063+$00001444: 142b0040  move.b $40(a3), d2
        move.b $40(a3), d2
L063_00001448:
; H063+$00001448: 4a42  tst.w d2
        tst.w d2
L063_0000144A:
; H063+$0000144A: 63000014  bls.w $1460
        bls.w H063+$1460
L063_0000144E:
; H063+$0000144E: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001450:
; H063+$00001450: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001454:
; H063+$00001454: 142b0040  move.b $40(a3), d2
        move.b $40(a3), d2
L063_00001458:
; H063+$00001458: c4edffe6  mulu.w -$1a(a5), d2
        mulu.w -$1a(a5), d2
L063_0000145C:
; H063+$0000145C: 3b42ffe6  move.w d2, -$1a(a5)
        move.w d2, -$1a(a5)
L063_00001460:
; H063+$00001460: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001464:
; H063+$00001464: 342b018c  move.w $18c(a3), d2
        move.w $18c(a3), d2
L063_00001468:
; H063+$00001468: d46dffe6  add.w -$1a(a5), d2
        add.w -$1a(a5), d2
L063_0000146C:
; H063+$0000146C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001470:
; H063+$00001470: 3742018c  move.w d2, $18c(a3)
        move.w d2, $18c(a3)
L063_00001474:
; H063+$00001474: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001478:
; H063+$00001478: 4a2b003a  tst.b $3a(a3)
        tst.b $3a(a3)
L063_0000147C:
; H063+$0000147C: 67000110  beq.w $158e
        beq.w H063+$158E
L063_00001480:
; H063+$00001480: 342dffe6  move.w -$1a(a5), d2
        move.w -$1a(a5), d2
L063_00001484:
; H063+$00001484: d56cfffe  add.w d2, -$2(a4)
        add.w d2, -$2(a4)
L063_00001488:
; H063+$00001488: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000148A:
; H063+$0000148A: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_0000148E:
; H063+$0000148E: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00001492:
; H063+$00001492: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_00001496:
; H063+$00001496: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_0000149C:
; H063+$0000149C: 7800  moveq #$0, d4
        moveq #0, d4
L063_0000149E:
; H063+$0000149E: 18332800  move.b (a3, d2.l), d4
        move.b (a3, d2.l), d4
L063_000014A2:
; H063+$000014A2: 3b44ffe4  move.w d4, -$1c(a5)
        move.w d4, -$1c(a5)
L063_000014A6:
; H063+$000014A6: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L063_000014AA:
; H063+$000014AA: 60000066  bra.w $1512
        bra.w H063+$1512
L063_000014AE:
; H063+$000014AE: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L063_000014B2:
; H063+$000014B2: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_000014B6:
; H063+$000014B6: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_000014B8:
; H063+$000014B8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000014BC:
; H063+$000014BC: 47eb0154  lea.l $154(a3), a3
        lea.l $154(a3), a3
L063_000014C0:
; H063+$000014C0: 27adfff82000  move.l -$8(a5), (a3, d2.w)
        move.l -$8(a5), (a3, d2.w)
L063_000014C6:
; H063+$000014C6: 4e75  rts 
        rts 
L063_000014C8:
; H063+$000014C8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000014CC:
; H063+$000014CC: 4aab0178  tst.l $178(a3)
        tst.l $178(a3)
L063_000014D0:
; H063+$000014D0: 6700001c  beq.w $14ee
        beq.w H063+$14EE
L063_000014D4:
; H063+$000014D4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000014D8:
; H063+$000014D8: 4aab017c  tst.l $17c(a3)
        tst.l $17c(a3)
L063_000014DC:
; H063+$000014DC: 6600000c  bne.w $14ea
        bne.w H063+$14EA
L063_000014E0:
; H063+$000014E0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000014E4:
; H063+$000014E4: 276dfff8017c  move.l -$8(a5), $17c(a3)
        move.l -$8(a5), $17c(a3)
L063_000014EA:
; H063+$000014EA: 6000000c  bra.w $14f8
        bra.w H063+$14F8
L063_000014EE:
; H063+$000014EE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000014F2:
; H063+$000014F2: 276dfff80178  move.l -$8(a5), $178(a3)
        move.l -$8(a5), $178(a3)
L063_000014F8:
; H063+$000014F8: 4e75  rts 
        rts 
L063_000014FA:
; H063+$000014FA: 4e75  rts 
        rts 
; Preserved bytes H063+$000014FC..$00001512; code/data not fully classified.
        dc.w $FFFC,$FFB0,$FFB0,$FFB0,$FFB0,$FFB0,$FFB0,$FFB0
        dc.w $FFB0,$FFB0,$FFCA
L063_00001512:
; H063+$00001512: 47faffea  lea.l $14fe(pc), a3
        lea.l H063+$14FE(pc), a3
L063_00001516:
; H063+$00001516: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L063_0000151A:
; H063+$0000151A: 6302  bls.b $151e
        bls.b H063+$151E
L063_0000151C:
; H063+$0000151C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_0000151E:
; H063+$0000151E: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00001520:
; H063+$00001520: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$14FE; indici 0..9, default -1.
L063_00001524:
; H063+$00001524: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00001528:
; H063+$00001528: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000152A:
; H063+$0000152A: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_0000152E:
; H063+$0000152E: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00001532:
; H063+$00001532: 0c42001e  cmpi.w #$1e, d2
        cmpi.w #$1e, d2
L063_00001536:
; H063+$00001536: 6600000c  bne.w $1544
        bne.w H063+$1544
L063_0000153A:
; H063+$0000153A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000153E:
; H063+$0000153E: 276dfff80180  move.l -$8(a5), $180(a3)
        move.l -$8(a5), $180(a3)
L063_00001544:
; H063+$00001544: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001546:
; H063+$00001546: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_0000154A:
; H063+$0000154A: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_0000154E:
; H063+$0000154E: 0c42000c  cmpi.w #$c, d2
        cmpi.w #$c, d2
L063_00001552:
; H063+$00001552: 6600000c  bne.w $1560
        bne.w H063+$1560
L063_00001556:
; H063+$00001556: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000155A:
; H063+$0000155A: 276dfff80184  move.l -$8(a5), $184(a3)
        move.l -$8(a5), $184(a3)
L063_00001560:
; H063+$00001560: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001562:
; H063+$00001562: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001566:
; H063+$00001566: 142b0188  move.b $188(a3), d2
        move.b $188(a3), d2
L063_0000156A:
; H063+$0000156A: 7800  moveq #$0, d4
        moveq #0, d4
L063_0000156C:
; H063+$0000156C: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001570:
; H063+$00001570: 182b0030  move.b $30(a3), d4
        move.b $30(a3), d4
L063_00001574:
; H063+$00001574: c9fc0012  muls.w #$12, d4
        muls.w #$12, d4
L063_00001578:
; H063+$00001578: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_0000157E:
; H063+$0000157E: 7c00  moveq #$0, d6
        moveq #0, d6
L063_00001580:
; H063+$00001580: 1c334801  move.b $1(a3, d4.l), d6
        move.b $1(a3, d4.l), d6
L063_00001584:
; H063+$00001584: d446  add.w d6, d2
        add.w d6, d2
L063_00001586:
; H063+$00001586: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000158A:
; H063+$0000158A: 17420188  move.b d2, $188(a3)
        move.b d2, $188(a3)
L063_0000158E:
; H063+$0000158E: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001592:
; H063+$00001592: 2b6b002cfff8  move.l $2c(a3), -$8(a5)
        move.l $2c(a3), -$8(a5)
L063_00001598:
; H063+$00001598: 6000fe80  bra.w $141a
        bra.w H063+$141A
L063_0000159C:
; H063+$0000159C: 1b7c0001ffe9  move.b #$1, -$17(a5)
        move.b #$1, -$17(a5)
L063_000015A2:
; H063+$000015A2: 0c2d0006ffe9  cmpi.b #$6, -$17(a5)
        cmpi.b #$6, -$17(a5)
L063_000015A8:
; H063+$000015A8: 6200002c  bhi.w $15d6
        bhi.w H063+$15D6
L063_000015AC:
; H063+$000015AC: 7400  moveq #$0, d2
        moveq #0, d2
L063_000015AE:
; H063+$000015AE: 142dffe9  move.b -$17(a5), d2
        move.b -$17(a5), d2
L063_000015B2:
; H063+$000015B2: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_000015B4:
; H063+$000015B4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000015B8:
; H063+$000015B8: 47eb00f0  lea.l $f0(a3), a3
        lea.l $f0(a3), a3
L063_000015BC:
; H063+$000015BC: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_000015C0:
; H063+$000015C0: 382a018c  move.w $18c(a2), d4
        move.w $18c(a2), d4
L063_000015C4:
; H063+$000015C4: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L063_000015C8:
; H063+$000015C8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000015CC:
; H063+$000015CC: 3744018c  move.w d4, $18c(a3)
        move.w d4, $18c(a3)
L063_000015D0:
; H063+$000015D0: 522dffe9  addq.b #$1, -$17(a5)
        addq.b #$1, -$17(a5)
L063_000015D4:
; H063+$000015D4: 64cc  bcc.b $15a2
        bcc.b H063+$15A2
L063_000015D6:
; H063+$000015D6: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L063_000015DC:
; H063+$000015DC: 0c6d0002fffe  cmpi.w #$2, -$2(a5)
        cmpi.w #$2, -$2(a5)
L063_000015E2:
; H063+$000015E2: 62000072  bhi.w $1656
        bhi.w H063+$1656
L063_000015E6:
; H063+$000015E6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_000015EA:
; H063+$000015EA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_000015EC:
; H063+$000015EC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000015F0:
; H063+$000015F0: 47eb01a0  lea.l $1a0(a3), a3
        lea.l $1a0(a3), a3
L063_000015F4:
; H063+$000015F4: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L063_000015F8:
; H063+$000015F8: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_000015FA:
; H063+$000015FA: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_000015FE:
; H063+$000015FE: 45ea0112  lea.l $112(a2), a2
        lea.l $112(a2), a2
L063_00001602:
; H063+$00001602: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L063_00001608:
; H063+$00001608: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000160C:
; H063+$0000160C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_0000160E:
; H063+$0000160E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001612:
; H063+$00001612: 47eb01a2  lea.l $1a2(a3), a3
        lea.l $1a2(a3), a3
L063_00001616:
; H063+$00001616: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L063_0000161A:
; H063+$0000161A: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_0000161C:
; H063+$0000161C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00001620:
; H063+$00001620: 45ea0114  lea.l $114(a2), a2
        lea.l $114(a2), a2
L063_00001624:
; H063+$00001624: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L063_0000162A:
; H063+$0000162A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000162E:
; H063+$0000162E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00001630:
; H063+$00001630: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00001632:
; H063+$00001632: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001636:
; H063+$00001636: 47eb01a4  lea.l $1a4(a3), a3
        lea.l $1a4(a3), a3
L063_0000163A:
; H063+$0000163A: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L063_0000163E:
; H063+$0000163E: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00001640:
; H063+$00001640: e344  asl.w #$1, d4
        asl.w #$1, d4
L063_00001642:
; H063+$00001642: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00001646:
; H063+$00001646: 45ea0116  lea.l $116(a2), a2
        lea.l $116(a2), a2
L063_0000164A:
; H063+$0000164A: 37b240002000  move.w (a2, d4.w), (a3, d2.w)
        move.w (a2, d4.w), (a3, d2.w)
L063_00001650:
; H063+$00001650: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L063_00001654:
; H063+$00001654: 6486  bcc.b $15dc
        bcc.b H063+$15DC
L063_00001656:
; H063+$00001656: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L063_0000165A:
; H063+$0000165A: 0c2d0004fffd  cmpi.b #$4, -$3(a5)
        cmpi.b #$4, -$3(a5)
L063_00001660:
; H063+$00001660: 62000018  bhi.w $167a
        bhi.w H063+$167A
L063_00001664:
; H063+$00001664: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001666:
; H063+$00001666: 142dfffd  move.b -$3(a5), d2
        move.b -$3(a5), d2
L063_0000166A:
; H063+$0000166A: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_0000166C:
; H063+$0000166C: 47edffec  lea.l -$14(a5), a3
        lea.l -$14(a5), a3
L063_00001670:
; H063+$00001670: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L063_00001674:
; H063+$00001674: 522dfffd  addq.b #$1, -$3(a5)
        addq.b #$1, -$3(a5)
L063_00001678:
; H063+$00001678: 64e0  bcc.b $165a
        bcc.b H063+$165A
L063_0000167A:
; H063+$0000167A: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L063_0000167E:
; H063+$0000167E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001682:
; H063+$00001682: 426b018a  clr.w $18a(a3)
        clr.w $18a(a3)
L063_00001686:
; H063+$00001686: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000168A:
; H063+$0000168A: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_0000168E:
; H063+$0000168E: 156b011a019c  move.b $11a(a3), $19c(a2)
        move.b $11a(a3), $19c(a2)
L063_00001694:
; H063+$00001694: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001698:
; H063+$00001698: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_0000169C:
; H063+$0000169C: 156b00da01a9  move.b $da(a3), $1a9(a2)
        move.b $da(a3), $1a9(a2)
L063_000016A2:
; H063+$000016A2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000016A6:
; H063+$000016A6: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_000016AA:
; H063+$000016AA: 156b005a019b  move.b $5a(a3), $19b(a2)
        move.b $5a(a3), $19b(a2)
L063_000016B0:
; H063+$000016B0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000016B4:
; H063+$000016B4: 4eb9000018f8  jsr $18f8.l
        jsr (H063+$18F8).l
L063_000016BA:
; H063+$000016BA: 3b40ffec  move.w d0, -$14(a5)
        move.w d0, -$14(a5)
L063_000016BE:
; H063+$000016BE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000016C2:
; H063+$000016C2: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L063_000016C6:
; H063+$000016C6: 66000040  bne.w $1708
        bne.w H063+$1708
L063_000016CA:
; H063+$000016CA: 7400  moveq #$0, d2
        moveq #0, d2
L063_000016CC:
; H063+$000016CC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000016D0:
; H063+$000016D0: 142b019b  move.b $19b(a3), d2
        move.b $19b(a3), d2
L063_000016D4:
; H063+$000016D4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_000016D6:
; H063+$000016D6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000016DA:
; H063+$000016DA: 6100ec78  bsr.w $354
        bsr.w H063+$354
L063_000016DE:
; H063+$000016DE: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L063_000016E0:
; H063+$000016E0: 3800  move.w d0, d4
        move.w d0, d4
L063_000016E2:
; H063+$000016E2: d444  add.w d4, d2
        add.w d4, d2
L063_000016E4:
; H063+$000016E4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000016E8:
; H063+$000016E8: 1742019b  move.b d2, $19b(a3)
        move.b d2, $19b(a3)
L063_000016EC:
; H063+$000016EC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000016F0:
; H063+$000016F0: 4eb9000019b6  jsr $19b6.l
        jsr (H063+$19B6).l
L063_000016F6:
; H063+$000016F6: 3400  move.w d0, d2
        move.w d0, d2
L063_000016F8:
; H063+$000016F8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000016FC:
; H063+$000016FC: d46b01a4  add.w $1a4(a3), d2
        add.w $1a4(a3), d2
L063_00001700:
; H063+$00001700: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001704:
; H063+$00001704: 374201a4  move.w d2, $1a4(a3)
        move.w d2, $1a4(a3)
L063_00001708:
; H063+$00001708: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000170C:
; H063+$0000170C: 6100ed24  bsr.w $432
        bsr.w H063+$432
L063_00001710:
; H063+$00001710: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001714:
; H063+$00001714: 2b6b0150fff8  move.l $150(a3), -$8(a5)
        move.l $150(a3), -$8(a5)
L063_0000171A:
; H063+$0000171A: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L063_0000171E:
; H063+$0000171E: 6700003a  beq.w $175a
        beq.w H063+$175A
L063_00001722:
; H063+$00001722: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001726:
; H063+$00001726: 4a2b003a  tst.b $3a(a3)
        tst.b $3a(a3)
L063_0000172A:
; H063+$0000172A: 67000022  beq.w $174e
        beq.w H063+$174E
L063_0000172E:
; H063+$0000172E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00001732:
; H063+$00001732: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L063_00001736:
; H063+$00001736: 6100ef76  bsr.w $6ae
        bsr.w H063+$6AE
L063_0000173A:
; H063+$0000173A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000173E:
; H063+$0000173E: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L063_00001742:
; H063+$00001742: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L063_00001746:
; H063+$00001746: 486dfff7  pea.l -$9(a5)
        pea.l -$9(a5)
L063_0000174A:
; H063+$0000174A: 6100f00c  bsr.w $758
        bsr.w H063+$758
L063_0000174E:
; H063+$0000174E: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001752:
; H063+$00001752: 2b6b002cfff8  move.l $2c(a3), -$8(a5)
        move.l $2c(a3), -$8(a5)
L063_00001758:
; H063+$00001758: 60c0  bra.b $171a
        bra.b H063+$171A
L063_0000175A:
; H063+$0000175A: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L063_0000175E:
; H063+$0000175E: 67000006  beq.w $1766
        beq.w H063+$1766
L063_00001762:
; H063+$00001762: 426dfff2  clr.w -$e(a5)
        clr.w -$e(a5)
L063_00001766:
; H063+$00001766: 4a2dfff6  tst.b -$a(a5)
        tst.b -$a(a5)
L063_0000176A:
; H063+$0000176A: 67000040  beq.w $17ac
        beq.w H063+$17AC
L063_0000176E:
; H063+$0000176E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001772:
; H063+$00001772: 0c6b1388018c  cmpi.w #$1388, $18c(a3)
        cmpi.w #$1388, $18c(a3)
L063_00001778:
; H063+$00001778: 6400000e  bcc.w $1788
        bcc.w H063+$1788
L063_0000177C:
; H063+$0000177C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001780:
; H063+$00001780: 426b018c  clr.w $18c(a3)
        clr.w $18c(a3)
L063_00001784:
; H063+$00001784: 6000000c  bra.w $1792
        bra.w H063+$1792
L063_00001788:
; H063+$00001788: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000178C:
; H063+$0000178C: 046b1388018c  subi.w #$1388, $18c(a3)
        subi.w #$1388, $18c(a3)
L063_00001792:
; H063+$00001792: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001796:
; H063+$00001796: 342b018c  move.w $18c(a3), d2
        move.w $18c(a3), d2
L063_0000179A:
; H063+$0000179A: b46cfffe  cmp.w -$2(a4), d2
        cmp.w -$2(a4), d2
L063_0000179E:
; H063+$0000179E: 6400000c  bcc.w $17ac
        bcc.w H063+$17AC
L063_000017A2:
; H063+$000017A2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000017A6:
; H063+$000017A6: 376cfffe018c  move.w -$2(a4), $18c(a3)
        move.w -$2(a4), $18c(a3)
L063_000017AC:
; H063+$000017AC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000017B0:
; H063+$000017B0: 6100f0f0  bsr.w $8a2
        bsr.w H063+$8A2
L063_000017B4:
; H063+$000017B4: 7400  moveq #$0, d2
        moveq #0, d2
L063_000017B6:
; H063+$000017B6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000017BA:
; H063+$000017BA: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_000017BE:
; H063+$000017BE: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L063_000017C2:
; H063+$000017C2: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_000017C4:
; H063+$000017C4: 6c000010  bge.w $17d6
        bge.w H063+$17D6
L063_000017C8:
; H063+$000017C8: 7400  moveq #$0, d2
        moveq #0, d2
L063_000017CA:
; H063+$000017CA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000017CE:
; H063+$000017CE: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_000017D2:
; H063+$000017D2: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L063_000017D6:
; H063+$000017D6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000017DA:
; H063+$000017DA: 422b019c  clr.b $19c(a3)
        clr.b $19c(a3)
L063_000017DE:
; H063+$000017DE: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L063_000017E2:
; H063+$000017E2: 0c2d0004fffd  cmpi.b #$4, -$3(a5)
        cmpi.b #$4, -$3(a5)
L063_000017E8:
; H063+$000017E8: 6200002a  bhi.w $1814
        bhi.w H063+$1814
L063_000017EC:
; H063+$000017EC: 7400  moveq #$0, d2
        moveq #0, d2
L063_000017EE:
; H063+$000017EE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000017F2:
; H063+$000017F2: 142b019c  move.b $19c(a3), d2
        move.b $19c(a3), d2
L063_000017F6:
; H063+$000017F6: 7800  moveq #$0, d4
        moveq #0, d4
L063_000017F8:
; H063+$000017F8: 182dfffd  move.b -$3(a5), d4
        move.b -$3(a5), d4
L063_000017FC:
; H063+$000017FC: e344  asl.w #$1, d4
        asl.w #$1, d4
L063_000017FE:
; H063+$000017FE: 47edffec  lea.l -$14(a5), a3
        lea.l -$14(a5), a3
L063_00001802:
; H063+$00001802: d4734000  add.w (a3, d4.w), d2
        add.w (a3, d4.w), d2
L063_00001806:
; H063+$00001806: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000180A:
; H063+$0000180A: 1742019c  move.b d2, $19c(a3)
        move.b d2, $19c(a3)
L063_0000180E:
; H063+$0000180E: 522dfffd  addq.b #$1, -$3(a5)
        addq.b #$1, -$3(a5)
L063_00001812:
; H063+$00001812: 64ce  bcc.b $17e2
        bcc.b H063+$17E2
L063_00001814:
; H063+$00001814: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00001818:
; H063+$00001818: d46dfff0  add.w -$10(a5), d2
        add.w -$10(a5), d2
L063_0000181C:
; H063+$0000181C: d46dfff2  add.w -$e(a5), d2
        add.w -$e(a5), d2
L063_00001820:
; H063+$00001820: 5542  subq.w #$2, d2
        subq.w #$2, d2
L063_00001822:
; H063+$00001822: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001826:
; H063+$00001826: 1742019d  move.b d2, $19d(a3)
        move.b d2, $19d(a3)
L063_0000182A:
; H063+$0000182A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000182E:
; H063+$0000182E: 4a2b0100  tst.b $100(a3)
        tst.b $100(a3)
L063_00001832:
; H063+$00001832: 62000038  bhi.w $186c
        bhi.w H063+$186C
L063_00001836:
; H063+$00001836: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000183A:
; H063+$0000183A: 4a2b0108  tst.b $108(a3)
        tst.b $108(a3)
L063_0000183E:
; H063+$0000183E: 63000014  bls.w $1854
        bls.w H063+$1854
L063_00001842:
; H063+$00001842: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H073+$130A (sub_H073_0000130A)
L063_00001846:
; H063+$00001846: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L063_0000184C:
; H063+$0000184C: 1400  move.b d0, d2
        move.b d0, d2
L063_0000184E:
; H063+$0000184E: 4a02  tst.b d2
        tst.b d2
L063_00001850:
; H063+$00001850: 6600001a  bne.w $186c
        bne.w H063+$186C
L063_00001854:
; H063+$00001854: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001858:
; H063+$00001858: 4a2b0105  tst.b $105(a3)
        tst.b $105(a3)
L063_0000185C:
; H063+$0000185C: 6200000e  bhi.w $186c
        bhi.w H063+$186C
L063_00001860:
; H063+$00001860: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001864:
; H063+$00001864: 4a2b0102  tst.b $102(a3)
        tst.b $102(a3)
L063_00001868:
; H063+$00001868: 6300007a  bls.w $18e4
        bls.w H063+$18E4
L063_0000186C:
; H063+$0000186C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001870:
; H063+$00001870: 0c2b0007005b  cmpi.b #$7, $5b(a3)
        cmpi.b #$7, $5b(a3)
L063_00001876:
; H063+$00001876: 6400006c  bcc.w $18e4
        bcc.w H063+$18E4
L063_0000187A:
; H063+$0000187A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000187E:
; H063+$0000187E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00001882:
; H063+$00001882: 156b010000d2  move.b $100(a3), $d2(a2)
        move.b $100(a3), $d2(a2)
L063_00001888:
; H063+$00001888: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000188A:
; H063+$0000188A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000188E:
; H063+$0000188E: 142b0105  move.b $105(a3), d2
        move.b $105(a3), d2
L063_00001892:
; H063+$00001892: 7800  moveq #$0, d4
        moveq #0, d4
L063_00001894:
; H063+$00001894: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001898:
; H063+$00001898: 182b00d2  move.b $d2(a3), d4
        move.b $d2(a3), d4
L063_0000189C:
; H063+$0000189C: b444  cmp.w d4, d2
        cmp.w d4, d2
L063_0000189E:
; H063+$0000189E: 63000014  bls.w $18b4
        bls.w H063+$18B4
L063_000018A2:
; H063+$000018A2: 7400  moveq #$0, d2
        moveq #0, d2
L063_000018A4:
; H063+$000018A4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000018A8:
; H063+$000018A8: 142b0105  move.b $105(a3), d2
        move.b $105(a3), d2
L063_000018AC:
; H063+$000018AC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000018B0:
; H063+$000018B0: 174200d2  move.b d2, $d2(a3)
        move.b d2, $d2(a3)
L063_000018B4:
; H063+$000018B4: 7400  moveq #$0, d2
        moveq #0, d2
L063_000018B6:
; H063+$000018B6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000018BA:
; H063+$000018BA: 142b0102  move.b $102(a3), d2
        move.b $102(a3), d2
L063_000018BE:
; H063+$000018BE: 7800  moveq #$0, d4
        moveq #0, d4
L063_000018C0:
; H063+$000018C0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000018C4:
; H063+$000018C4: 182b00d2  move.b $d2(a3), d4
        move.b $d2(a3), d4
L063_000018C8:
; H063+$000018C8: b444  cmp.w d4, d2
        cmp.w d4, d2
L063_000018CA:
; H063+$000018CA: 63000014  bls.w $18e0
        bls.w H063+$18E0
L063_000018CE:
; H063+$000018CE: 7400  moveq #$0, d2
        moveq #0, d2
L063_000018D0:
; H063+$000018D0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000018D4:
; H063+$000018D4: 142b0102  move.b $102(a3), d2
        move.b $102(a3), d2
L063_000018D8:
; H063+$000018D8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000018DC:
; H063+$000018DC: 174200d2  move.b d2, $d2(a3)
        move.b d2, $d2(a3)
L063_000018E0:
; H063+$000018E0: 6000000c  bra.w $18ee
        bra.w H063+$18EE
L063_000018E4:
; H063+$000018E4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000018E8:
; H063+$000018E8: 177c000100d2  move.b #$1, $d2(a3)
        move.b #$1, $d2(a3)
L063_000018EE:
; H063+$000018EE: 4e5d  unlk a5
        unlk a5
L063_000018F0:
; H063+$000018F0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000018F2:
; H063+$000018F2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000018F4:
; H063+$000018F4: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_000018F6:
; H063+$000018F6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000018F8 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H063+$16B4
; --------------------------------------------------------------------------
L063_000018F8:
; H063+$000018F8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000018FA:
; H063+$000018FA: 287ae804  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000018FE:
; H063+$000018FE: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_00001902:
; H063+$00001902: 7400  moveq #$0, d2
        moveq #0, d2
L063_00001904:
; H063+$00001904: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001908:
; H063+$00001908: 142b0017  move.b $17(a3), d2
        move.b $17(a3), d2
L063_0000190C:
; H063+$0000190C: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00001910:
; H063+$00001910: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001914:
; H063+$00001914: 60000076  bra.w $198c
        bra.w H063+$198C
L063_00001918:
; H063+$00001918: 3b7cfffcfffc  move.w #$fffc, -$4(a5)
        move.w #$fffc, -$4(a5)
L063_0000191E:
; H063+$0000191E: 4e75  rts 
        rts 
L063_00001920:
; H063+$00001920: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001924:
; H063+$00001924: 5f42  subq.w #$7, d2
        subq.w #$7, d2
L063_00001926:
; H063+$00001926: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_0000192A:
; H063+$0000192A: 4e75  rts 
        rts 
L063_0000192C:
; H063+$0000192C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001930:
; H063+$00001930: 0442000e  subi.w #$e, d2
        subi.w #$e, d2
L063_00001934:
; H063+$00001934: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_00001938:
; H063+$00001938: 4e75  rts 
        rts 
L063_0000193A:
; H063+$0000193A: 3b7c0004fffc  move.w #$4, -$4(a5)
        move.w #$4, -$4(a5)
L063_00001940:
; H063+$00001940: 4e75  rts 
        rts 
L063_00001942:
; H063+$00001942: 3b7c0005fffc  move.w #$5, -$4(a5)
        move.w #$5, -$4(a5)
L063_00001948:
; H063+$00001948: 4e75  rts 
        rts 
L063_0000194A:
; H063+$0000194A: 3b7c0006fffc  move.w #$6, -$4(a5)
        move.w #$6, -$4(a5)
L063_00001950:
; H063+$00001950: 4e75  rts 
        rts 
L063_00001952:
; H063+$00001952: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L063_00001956:
; H063+$00001956: 4e75  rts 
        rts 
; Preserved bytes H063+$00001958..$0000198C; code/data not fully classified.
        dc.w $FFF8,$FFBE,$FFBE,$FFBE,$FFC6,$FFC6,$FFC6,$FFF8
        dc.w $FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFD2
        dc.w $FFD2,$FFD2,$FFD2,$FFE0,$FFE0,$FFE8,$FFE8,$FFE8
        dc.w $FFF0,$FFF0
L063_0000198C:
; H063+$0000198C: 47faffcc  lea.l $195a(pc), a3
        lea.l H063+$195A(pc), a3
L063_00001990:
; H063+$00001990: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00001992:
; H063+$00001992: 0c420018  cmpi.w #$18, d2
        cmpi.w #$18, d2
L063_00001996:
; H063+$00001996: 6302  bls.b $199a
        bls.b H063+$199A
L063_00001998:
; H063+$00001998: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_0000199A:
; H063+$0000199A: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_0000199C:
; H063+$0000199C: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$195A; indici 0..24, default -1.
L063_000019A0:
; H063+$000019A0: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_000019A4:
; H063+$000019A4: 302dfffc  move.w -$4(a5), d0
        move.w -$4(a5), d0
L063_000019A8:
; H063+$000019A8: 60000002  bra.w $19ac
        bra.w H063+$19AC
L063_000019AC:
; H063+$000019AC: 4e5d  unlk a5
        unlk a5
L063_000019AE:
; H063+$000019AE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000019B0:
; H063+$000019B0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000019B2:
; H063+$000019B2: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_000019B4:
; H063+$000019B4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000019B6 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$0526, H063+$16F0, H063+$051A
; --------------------------------------------------------------------------
L063_000019B6:
; H063+$000019B6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000019B8:
; H063+$000019B8: 287ae746  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000019BC:
; H063+$000019BC: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_000019C0:
; H063+$000019C0: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_000019C4:
; H063+$000019C4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_000019C8:
; H063+$000019C8: 6100e85e  bsr.w $228
        bsr.w H063+$228
L063_000019CC:
; H063+$000019CC: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L063_000019D0:
; H063+$000019D0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000019D4:
; H063+$000019D4: 4a2b011b  tst.b $11b(a3)
        tst.b $11b(a3)
L063_000019D8:
; H063+$000019D8: 6700009e  beq.w $1a78
        beq.w H063+$1A78
L063_000019DC:
; H063+$000019DC: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_000019E0:
; H063+$000019E0: 6000007e  bra.w $1a60
        bra.w H063+$1A60
L063_000019E4:
; H063+$000019E4: 3b7cfffefffe  move.w #$fffe, -$2(a5)
        move.w #$fffe, -$2(a5)
L063_000019EA:
; H063+$000019EA: 4e75  rts 
        rts 
L063_000019EC:
; H063+$000019EC: 3b7cfffffffe  move.w #$ffff, -$2(a5)
        move.w #$ffff, -$2(a5)
L063_000019F2:
; H063+$000019F2: 4e75  rts 
        rts 
L063_000019F4:
; H063+$000019F4: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L063_000019FA:
; H063+$000019FA: 4e75  rts 
        rts 
L063_000019FC:
; H063+$000019FC: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001A00:
; H063+$00001A00: 04420010  subi.w #$10, d2
        subi.w #$10, d2
L063_00001A04:
; H063+$00001A04: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00001A08:
; H063+$00001A08: 4e75  rts 
        rts 
L063_00001A0A:
; H063+$00001A0A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001A0E:
; H063+$00001A0E: 04420011  subi.w #$11, d2
        subi.w #$11, d2
L063_00001A12:
; H063+$00001A12: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00001A16:
; H063+$00001A16: 4e75  rts 
        rts 
L063_00001A18:
; H063+$00001A18: 3b7c000efffe  move.w #$e, -$2(a5)
        move.w #$e, -$2(a5)
L063_00001A1E:
; H063+$00001A1E: 4e75  rts 
        rts 
L063_00001A20:
; H063+$00001A20: 4e75  rts 
        rts 
; Preserved bytes H063+$00001A22..$00001A60; code/data not fully classified.
        dc.w $FFFC,$FFC0,$FFC0,$FFC8,$FFC8,$FFC8,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFD0,$FFD8,$FFD8,$FFD8,$FFE6,$FFE6,$FFE6,$FFE6
        dc.w $FFE6,$FFE6,$FFE6,$FFE6,$FFE6,$FFE6,$FFF4
L063_00001A60:
; H063+$00001A60: 47faffc2  lea.l $1a24(pc), a3
        lea.l H063+$1A24(pc), a3
L063_00001A64:
; H063+$00001A64: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00001A66:
; H063+$00001A66: 0c42001d  cmpi.w #$1d, d2
        cmpi.w #$1d, d2
L063_00001A6A:
; H063+$00001A6A: 6302  bls.b $1a6e
        bls.b H063+$1A6E
L063_00001A6C:
; H063+$00001A6C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00001A6E:
; H063+$00001A6E: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00001A70:
; H063+$00001A70: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$1A24; indici 0..29, default -1.
L063_00001A74:
; H063+$00001A74: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00001A78:
; H063+$00001A78: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L063_00001A7C:
; H063+$00001A7C: 60000002  bra.w $1a80
        bra.w H063+$1A80
L063_00001A80:
; H063+$00001A80: 4e5d  unlk a5
        unlk a5
L063_00001A82:
; H063+$00001A82: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001A84:
; H063+$00001A84: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001A86:
; H063+$00001A86: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00001A88:
; H063+$00001A88: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_1B66 [parziale]
; Scopo: Trampolino verso H063+$1B66; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$1B66.
; Chiamanti diretti: H063+$08B0, H065+$3364, H067+$01D6
; --------------------------------------------------------------------------
L063_00001A8A:
; H063+$00001A8A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001A8C:
; H063+$00001A8C: 287ae672  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001A90:
; H063+$00001A90: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_00001A94:
; H063+$00001A94: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00001A98:
; H063+$00001A98: 6100e78e  bsr.w $228
        bsr.w H063+$228
L063_00001A9C:
; H063+$00001A9C: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L063_00001AA0:
; H063+$00001AA0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001AA4:
; H063+$00001AA4: 600000c0  bra.w $1b66
        bra.w H063+$1B66
L063_00001AA8:
; H063+$00001AA8: 3b7cfea2fffe  move.w #$fea2, -$2(a5)
        move.w #$fea2, -$2(a5)
L063_00001AAE:
; H063+$00001AAE: 4e75  rts 
        rts 
L063_00001AB0:
; H063+$00001AB0: 3b7cff06fffe  move.w #$ff06, -$2(a5)
        move.w #$ff06, -$2(a5)
L063_00001AB6:
; H063+$00001AB6: 4e75  rts 
        rts 
L063_00001AB8:
; H063+$00001AB8: 3b7cff6afffe  move.w #$ff6a, -$2(a5)
        move.w #$ff6a, -$2(a5)
L063_00001ABE:
; H063+$00001ABE: 4e75  rts 
        rts 
L063_00001AC0:
; H063+$00001AC0: 3b7c0064fffe  move.w #$64, -$2(a5)
        move.w #$64, -$2(a5)
L063_00001AC6:
; H063+$00001AC6: 4e75  rts 
        rts 
L063_00001AC8:
; H063+$00001AC8: 3b7c00c8fffe  move.w #$c8, -$2(a5)
        move.w #$c8, -$2(a5)
L063_00001ACE:
; H063+$00001ACE: 4e75  rts 
        rts 
L063_00001AD0:
; H063+$00001AD0: 3b7c015efffe  move.w #$15e, -$2(a5)
        move.w #$15e, -$2(a5)
L063_00001AD6:
; H063+$00001AD6: 4e75  rts 
        rts 
L063_00001AD8:
; H063+$00001AD8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001ADC:
; H063+$00001ADC: 04420011  subi.w #$11, d2
        subi.w #$11, d2
L063_00001AE0:
; H063+$00001AE0: c5fc00fa  muls.w #$fa, d2
        muls.w #$fa, d2
L063_00001AE4:
; H063+$00001AE4: 064201f4  addi.w #$1f4, d2
        addi.w #$1f4, d2
L063_00001AE8:
; H063+$00001AE8: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00001AEC:
; H063+$00001AEC: 4e75  rts 
        rts 
L063_00001AEE:
; H063+$00001AEE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001AF2:
; H063+$00001AF2: 04420016  subi.w #$16, d2
        subi.w #$16, d2
L063_00001AF6:
; H063+$00001AF6: c5fc03e8  muls.w #$3e8, d2
        muls.w #$3e8, d2
L063_00001AFA:
; H063+$00001AFA: 064207d0  addi.w #$7d0, d2
        addi.w #$7d0, d2
L063_00001AFE:
; H063+$00001AFE: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00001B02:
; H063+$00001B02: 4e75  rts 
        rts 
L063_00001B04:
; H063+$00001B04: 3b7c1d4cfffe  move.w #$1d4c, -$2(a5)
        move.w #$1d4c, -$2(a5)
L063_00001B0A:
; H063+$00001B0A: 4e75  rts 
        rts 
L063_00001B0C:
; H063+$00001B0C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00001B10:
; H063+$00001B10: 0442001c  subi.w #$1c, d2
        subi.w #$1c, d2
L063_00001B14:
; H063+$00001B14: c5fc0bb8  muls.w #$bb8, d2
        muls.w #$bb8, d2
L063_00001B18:
; H063+$00001B18: 06422328  addi.w #$2328, d2
        addi.w #$2328, d2
L063_00001B1C:
; H063+$00001B1C: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00001B20:
; H063+$00001B20: 4e75  rts 
        rts 
L063_00001B22:
; H063+$00001B22: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_00001B26:
; H063+$00001B26: 4e75  rts 
        rts 
; Preserved bytes H063+$00001B28..$00001B66; code/data not fully classified.
        dc.w $FFF8,$FF7E,$FF7E,$FF7E,$FF86,$FF86,$FF8E,$FF8E
        dc.w $FFF8,$FFF8,$FFF8,$FFF8,$FF96,$FF96,$FF9E,$FF9E
        dc.w $FFA6,$FFAE,$FFAE,$FFAE,$FFAE,$FFAE,$FFC4,$FFC4
        dc.w $FFC4,$FFC4,$FFC4,$FFDA,$FFE2,$FFE2,$FFE2
L063_00001B66:
; H063+$00001B66: 47faffc2  lea.l $1b2a(pc), a3
        lea.l H063+$1B2A(pc), a3
L063_00001B6A:
; H063+$00001B6A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00001B6C:
; H063+$00001B6C: 0c42001d  cmpi.w #$1d, d2
        cmpi.w #$1d, d2
L063_00001B70:
; H063+$00001B70: 6302  bls.b $1b74
        bls.b H063+$1B74
L063_00001B72:
; H063+$00001B72: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00001B74:
; H063+$00001B74: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00001B76:
; H063+$00001B76: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$1B2A; indici 0..29, default -1.
L063_00001B7A:
; H063+$00001B7A: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00001B7E:
; H063+$00001B7E: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L063_00001B82:
; H063+$00001B82: 60000002  bra.w $1b86
        bra.w H063+$1B86
L063_00001B86:
; H063+$00001B86: 4e5d  unlk a5
        unlk a5
L063_00001B88:
; H063+$00001B88: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001B8A:
; H063+$00001B8A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001B8C:
; H063+$00001B8C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00001B8E:
; H063+$00001B8E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00001B90 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H062+$2426, H033+$14E0, H033+$1706, H033+$17A6, H096+$079A
; --------------------------------------------------------------------------
L063_00001B90:
; H063+$00001B90: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001B92:
; H063+$00001B92: 287ae56c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001B96:
; H063+$00001B96: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_00001B9A:
; H063+$00001B9A: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_00001B9E:
; H063+$00001B9E: 0c6d0039fffe  cmpi.w #$39, -$2(a5)
        cmpi.w #$39, -$2(a5)
L063_00001BA4:
; H063+$00001BA4: 62000038  bhi.w $1bde
        bhi.w H063+$1BDE
L063_00001BA8:
; H063+$00001BA8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001BAC:
; H063+$00001BAC: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00001BB0:
; H063+$00001BB0: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L063_00001BB4:
; H063+$00001BB4: 7800  moveq #$0, d4
        moveq #0, d4
L063_00001BB6:
; H063+$00001BB6: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_00001BBA:
; H063+$00001BBA: b86d000c  cmp.w $c(a5), d4
        cmp.w $c(a5), d4
L063_00001BBE:
; H063+$00001BBE: 66000018  bne.w $1bd8
        bne.w H063+$1BD8
L063_00001BC2:
; H063+$00001BC2: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001BC6:
; H063+$00001BC6: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00001BCA:
; H063+$00001BCA: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L063_00001BCE:
; H063+$00001BCE: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L063_00001BD2:
; H063+$00001BD2: 3b7c003afffe  move.w #$3a, -$2(a5)
        move.w #$3a, -$2(a5)
L063_00001BD8:
; H063+$00001BD8: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L063_00001BDC:
; H063+$00001BDC: 60c0  bra.b $1b9e
        bra.b H063+$1B9E
L063_00001BDE:
; H063+$00001BDE: 4e5d  unlk a5
        unlk a5
L063_00001BE0:
; H063+$00001BE0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001BE2:
; H063+$00001BE2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001BE4:
; H063+$00001BE4: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L063_00001BE6:
; H063+$00001BE6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00001BE8 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H056+$0886, H030+$028A, H003+$00F6.
;   - Richiama H056+$0886.
;   - Richiama H030+$028A.
;   - Richiama H003+$00F6.
; Chiamanti diretti: H027+$0BF8, H027+$2592, H012+$2BF4, H096+$2486, H096+$246C, H061+$3E66 e altri 6
; --------------------------------------------------------------------------
L063_00001BE8:
; H063+$00001BE8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001BEA:
; H063+$00001BEA: 287ae514  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001BEE:
; H063+$00001BEE: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_00001BF2:
; H063+$00001BF2: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00001BF6:
; H063+$00001BF6: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L063_00001BFA:
; H063+$00001BFA: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00001BFC:
; H063+$00001BFC: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00001BFE:
; H063+$00001BFE: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H056+$0886 (sub_H056_00000886)
L063_00001C00:
; H063+$00001C00: 4eb900000886  jsr $886.l
        jsr (H056+$886).l
L063_00001C06:
; H063+$00001C06: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L063_00001C0A:
; H063+$00001C0A: 6600001a  bne.w $1c26
        bne.w H063+$1C26
L063_00001C0E:
; H063+$00001C0E: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L063_00001C12:
; H063+$00001C12: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001C14:
; H063+$00001C14: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L063_00001C18:
; H063+$00001C18: 486c0050  pea.l $50(a4)
        pea.l $50(a4)
; -> H030+$028A (sub_H030_0000028A)
L063_00001C1C:
; H063+$00001C1C: 4eb90000028a  jsr $28a.l
        jsr (H030+$28A).l
L063_00001C22:
; H063+$00001C22: 60000092  bra.w $1cb6
        bra.w H063+$1CB6
L063_00001C26:
; H063+$00001C26: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00001C2A:
; H063+$00001C2A: 2b6b0150fffc  move.l $150(a3), -$4(a5)
        move.l $150(a3), -$4(a5)
L063_00001C30:
; H063+$00001C30: 242dfffc  move.l -$4(a5), d2
        move.l -$4(a5), d2
L063_00001C34:
; H063+$00001C34: b4ad000c  cmp.l $c(a5), d2
        cmp.l $c(a5), d2
L063_00001C38:
; H063+$00001C38: 66000014  bne.w $1c4e
        bne.w H063+$1C4E
L063_00001C3C:
; H063+$00001C3C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001C40:
; H063+$00001C40: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L063_00001C44:
; H063+$00001C44: 256b002c0150  move.l $2c(a3), $150(a2)
        move.l $2c(a3), $150(a2)
L063_00001C4A:
; H063+$00001C4A: 60000026  bra.w $1c72
        bra.w H063+$1C72
L063_00001C4E:
; H063+$00001C4E: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_00001C52:
; H063+$00001C52: 6700001e  beq.w $1c72
        beq.w H063+$1C72
L063_00001C56:
; H063+$00001C56: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00001C5A:
; H063+$00001C5A: 242b002c  move.l $2c(a3), d2
        move.l $2c(a3), d2
L063_00001C5E:
; H063+$00001C5E: b4ad000c  cmp.l $c(a5), d2
        cmp.l $c(a5), d2
L063_00001C62:
; H063+$00001C62: 6700000e  beq.w $1c72
        beq.w H063+$1C72
L063_00001C66:
; H063+$00001C66: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00001C6A:
; H063+$00001C6A: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L063_00001C70:
; H063+$00001C70: 60dc  bra.b $1c4e
        bra.b H063+$1C4E
L063_00001C72:
; H063+$00001C72: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_00001C76:
; H063+$00001C76: 6600001a  bne.w $1c92
        bne.w H063+$1C92
L063_00001C7A:
; H063+$00001C7A: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L063_00001C7E:
; H063+$00001C7E: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001C80:
; H063+$00001C80: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001C84:
; H063+$00001C84: 486c0064  pea.l $64(a4)
        pea.l $64(a4)
; -> H030+$028A (sub_H030_0000028A)
L063_00001C88:
; H063+$00001C88: 4eb90000028a  jsr $28a.l
        jsr (H030+$28A).l
L063_00001C8E:
; H063+$00001C8E: 60000026  bra.w $1cb6
        bra.w H063+$1CB6
L063_00001C92:
; H063+$00001C92: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001C96:
; H063+$00001C96: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L063_00001C9A:
; H063+$00001C9A: 256b002c002c  move.l $2c(a3), $2c(a2)
        move.l $2c(a3), $2c(a2)
L063_00001CA0:
; H063+$00001CA0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001CA4:
; H063+$00001CA4: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L063_00001CA8:
; H063+$00001CA8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00001CAC:
; H063+$00001CAC: 7448  moveq #$48, d2
        moveq #72, d2
L063_00001CAE:
; H063+$00001CAE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L063_00001CB0:
; H063+$00001CB0: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L063_00001CB6:
; H063+$00001CB6: 4e5d  unlk a5
        unlk a5
L063_00001CB8:
; H063+$00001CB8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001CBA:
; H063+$00001CBA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001CBC:
; H063+$00001CBC: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_00001CBE:
; H063+$00001CBE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00001CC0 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H003+$0068, H003+$0090.
;   - Richiama H003+$0068.
;   - Richiama H003+$0090.
; Chiamanti diretti: H027+$0C7C, H065+$1E02
; --------------------------------------------------------------------------
L063_00001CC0:
; H063+$00001CC0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001CC2:
; H063+$00001CC2: 287ae43c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001CC6:
; H063+$00001CC6: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L063_00001CCA:
; H063+$00001CCA: 7448  moveq #$48, d2
        moveq #72, d2
L063_00001CCC:
; H063+$00001CCC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_00001CCE:
; H063+$00001CCE: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L063_00001CD4:
; H063+$00001CD4: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L063_00001CDA:
; H063+$00001CDA: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L063_00001CDE:
; H063+$00001CDE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00001CE2:
; H063+$00001CE2: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L063_00001CE6:
; H063+$00001CE6: 7448  moveq #$48, d2
        moveq #72, d2
L063_00001CE8:
; H063+$00001CE8: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L063_00001CEA:
; H063+$00001CEA: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L063_00001CF0:
; H063+$00001CF0: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00001CF4:
; H063+$00001CF4: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L063_00001CF8:
; H063+$00001CF8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00001CFC:
; H063+$00001CFC: 2b6b0150fffc  move.l $150(a3), -$4(a5)
        move.l $150(a3), -$4(a5)
L063_00001D02:
; H063+$00001D02: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_00001D06:
; H063+$00001D06: 66000010  bne.w $1d18
        bne.w H063+$1D18
L063_00001D0A:
; H063+$00001D0A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00001D0E:
; H063+$00001D0E: 276dfff80150  move.l -$8(a5), $150(a3)
        move.l -$8(a5), $150(a3)
L063_00001D14:
; H063+$00001D14: 60000024  bra.w $1d3a
        bra.w H063+$1D3A
L063_00001D18:
; H063+$00001D18: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00001D1C:
; H063+$00001D1C: 4aab002c  tst.l $2c(a3)
        tst.l $2c(a3)
L063_00001D20:
; H063+$00001D20: 6700000e  beq.w $1d30
        beq.w H063+$1D30
L063_00001D24:
; H063+$00001D24: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00001D28:
; H063+$00001D28: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L063_00001D2E:
; H063+$00001D2E: 60e8  bra.b $1d18
        bra.b H063+$1D18
L063_00001D30:
; H063+$00001D30: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00001D34:
; H063+$00001D34: 276dfff8002c  move.l -$8(a5), $2c(a3)
        move.l -$8(a5), $2c(a3)
L063_00001D3A:
; H063+$00001D3A: 4e5d  unlk a5
        unlk a5
L063_00001D3C:
; H063+$00001D3C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001D3E:
; H063+$00001D3E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001D40:
; H063+$00001D40: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_00001D42:
; H063+$00001D42: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00001D44 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H030+$0B6C, H030+$0256, H030+$0B4A.
;   - Richiama H030+$0B6C.
;   - Richiama H030+$0256.
;   - Richiama H030+$0B4A.
; Chiamanti diretti: H065+$2C4C, H027+$147C, H027+$3316, H096+$301E, H096+$3030, H065+$2E92 e altri 48
; --------------------------------------------------------------------------
L063_00001D44:
; H063+$00001D44: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001D46:
; H063+$00001D46: 287ae3b8  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001D4A:
; H063+$00001D4A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_00001D4E:
; H063+$00001D4E: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L063_00001D52:
; H063+$00001D52: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001D54:
; H063+$00001D54: 08020000  btst.b #$0, d2
        btst #$0, d2
L063_00001D58:
; H063+$00001D58: 6702  beq.b $1d5c
        beq.b H063+$1D5C
L063_00001D5A:
; H063+$00001D5A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001D5C:
; H063+$00001D5C: 9ec2  suba.w d2, a7
        suba.w d2, a7
L063_00001D5E:
; H063+$00001D5E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00001D62:
; H063+$00001D62: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L063_00001D66:
; H063+$00001D66: 244f  movea.l a7, a2
        movea.l a7, a2
L063_00001D68:
; H063+$00001D68: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00001D6A:
; H063+$00001D6A: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00001D6C:
; H063+$00001D6C: 51cafffc  dbra d2, $1d6a
        dbra d2, H063+$1D6A
L063_00001D70:
; H063+$00001D70: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001D72:
; H063+$00001D72: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00001D76:
; H063+$00001D76: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L063_00001D7A:
; H063+$00001D7A: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00001D7E:
; H063+$00001D7E: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00001D84:
; H063+$00001D84: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001D86:
; H063+$00001D86: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00001D8A:
; H063+$00001D8A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001D8E:
; H063+$00001D8E: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001D90:
; H063+$00001D90: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L063_00001D94:
; H063+$00001D94: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00001D98:
; H063+$00001D98: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
; -> H030+$0B4A (sub_H030_00000B4A)
L063_00001D9E:
; H063+$00001D9E: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L063_00001DA4:
; H063+$00001DA4: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001DA6:
; H063+$00001DA6: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00001DAA:
; H063+$00001DAA: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L063_00001DAE:
; H063+$00001DAE: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00001DB2:
; H063+$00001DB2: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00001DB8:
; H063+$00001DB8: 4e5d  unlk a5
        unlk a5
L063_00001DBA:
; H063+$00001DBA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001DBC:
; H063+$00001DBC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001DBE:
; H063+$00001DBE: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L063_00001DC0:
; H063+$00001DC0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00001DC2 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H030+$0B6C, H030+$0302, H030+$0B4A.
;   - Richiama H030+$0B6C.
;   - Richiama H030+$0302.
;   - Richiama H030+$0B4A.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H027+$0AD0, H027+$0E80, H027+$0F2E, H027+$13C8, H027+$18F8, H027+$1AA6 e altri 60
; --------------------------------------------------------------------------
L063_00001DC2:
; H063+$00001DC2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001DC4:
; H063+$00001DC4: 287ae33a  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001DC8:
; H063+$00001DC8: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_00001DCC:
; H063+$00001DCC: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L063_00001DD0:
; H063+$00001DD0: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001DD2:
; H063+$00001DD2: 08020000  btst.b #$0, d2
        btst #$0, d2
L063_00001DD6:
; H063+$00001DD6: 6702  beq.b $1dda
        beq.b H063+$1DDA
L063_00001DD8:
; H063+$00001DD8: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001DDA:
; H063+$00001DDA: 9ec2  suba.w d2, a7
        suba.w d2, a7
L063_00001DDC:
; H063+$00001DDC: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00001DE0:
; H063+$00001DE0: 2b4f0010  move.l a7, $10(a5)
        move.l a7, $10(a5)
L063_00001DE4:
; H063+$00001DE4: 244f  movea.l a7, a2
        movea.l a7, a2
L063_00001DE6:
; H063+$00001DE6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00001DE8:
; H063+$00001DE8: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00001DEA:
; H063+$00001DEA: 51cafffc  dbra d2, $1de8
        dbra d2, H063+$1DE8
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00001DEE:
; H063+$00001DEE: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L063_00001DF6:
; H063+$00001DF6: 6600005c  bne.w $1e54
        bne.w H063+$1E54
L063_00001DFA:
; H063+$00001DFA: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_00001DFE:
; H063+$00001DFE: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L063_00001E02:
; H063+$00001E02: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001E06:
; H063+$00001E06: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00001E0A:
; H063+$00001E0A: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00001E10:
; H063+$00001E10: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L063_00001E14:
; H063+$00001E14: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_00001E18:
; H063+$00001E18: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L063_00001E1C:
; H063+$00001E1C: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00001E1E:
; H063+$00001E1E: 4eb900001f34  jsr $1f34.l
        jsr (H063+$1F34).l
L063_00001E24:
; H063+$00001E24: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_00001E28:
; H063+$00001E28: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L063_00001E2C:
; H063+$00001E2C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001E2E:
; H063+$00001E2E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00001E30:
; H063+$00001E30: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001E34:
; H063+$00001E34: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
L063_00001E38:
; H063+$00001E38: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001E3C:
; H063+$00001E3C: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001E3E:
; H063+$00001E3E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00001E42:
; H063+$00001E42: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L063_00001E46:
; H063+$00001E46: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H030+$0302 (trampoline_H030_0470)
L063_00001E4A:
; H063+$00001E4A: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L063_00001E50:
; H063+$00001E50: 60000076  bra.w $1ec8
        bra.w H063+$1EC8
L063_00001E54:
; H063+$00001E54: 4a39000024e2  tst.b $24e2.l
        tst.b (H005+$24E2).l
L063_00001E5A:
; H063+$00001E5A: 6700000c  beq.w $1e68
        beq.w H063+$1E68
L063_00001E5E:
; H063+$00001E5E: 3b7c0012fffe  move.w #$12, -$2(a5)
        move.w #$12, -$2(a5)
L063_00001E64:
; H063+$00001E64: 60000008  bra.w $1e6e
        bra.w H063+$1E6E
L063_00001E68:
; H063+$00001E68: 3b7c0011fffe  move.w #$11, -$2(a5)
        move.w #$11, -$2(a5)
L063_00001E6E:
; H063+$00001E6E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001E72:
; H063+$00001E72: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L063_00001E76:
; H063+$00001E76: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001E7A:
; H063+$00001E7A: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00001E7E:
; H063+$00001E7E: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00001E84:
; H063+$00001E84: 2f2d0016  move.l $16(a5), -(a7)
        move.l $16(a5), -(a7)
L063_00001E88:
; H063+$00001E88: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001E8C:
; H063+$00001E8C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001E90:
; H063+$00001E90: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00001E92:
; H063+$00001E92: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00001E94:
; H063+$00001E94: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00001E96:
; H063+$00001E96: 4eb900001f34  jsr $1f34.l
        jsr (H063+$1F34).l
L063_00001E9C:
; H063+$00001E9C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001EA0:
; H063+$00001EA0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00001EA4:
; H063+$00001EA4: 5442  addq.w #$2, d2
        addq.w #$2, d2
L063_00001EA6:
; H063+$00001EA6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00001EA8:
; H063+$00001EA8: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001EAC:
; H063+$00001EAC: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L063_00001EB0:
; H063+$00001EB0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001EB4:
; H063+$00001EB4: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001EB6:
; H063+$00001EB6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00001EBA:
; H063+$00001EBA: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L063_00001EBE:
; H063+$00001EBE: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H030+$0302 (trampoline_H030_0470)
L063_00001EC2:
; H063+$00001EC2: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L063_00001EC8:
; H063+$00001EC8: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L063_00001ECC:
; H063+$00001ECC: 6700000e  beq.w $1edc
        beq.w H063+$1EDC
; -> H030+$0B4A (sub_H030_00000B4A)
L063_00001ED0:
; H063+$00001ED0: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L063_00001ED6:
; H063+$00001ED6: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
L063_00001EDC:
; H063+$00001EDC: 4e5d  unlk a5
        unlk a5
L063_00001EDE:
; H063+$00001EDE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001EE0:
; H063+$00001EE0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001EE2:
; H063+$00001EE2: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L063_00001EE6:
; H063+$00001EE6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00001EE8 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H030+$0B6C.
;   - Richiama H030+$0B6C.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H027+$045A, H063+$1ED6, H062+$03C8, H027+$1224, H027+$129A, H062+$020C e altri 17
; --------------------------------------------------------------------------
L063_00001EE8:
; H063+$00001EE8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001EEA:
; H063+$00001EEA: 287ae214  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001EEE:
; H063+$00001EEE: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00001EF2:
; H063+$00001EF2: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L063_00001EFA:
; H063+$00001EFA: 6600001c  bne.w $1f18
        bne.w H063+$1F18
L063_00001EFE:
; H063+$00001EFE: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L063_00001F02:
; H063+$00001F02: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00001F06:
; H063+$00001F06: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001F0A:
; H063+$00001F0A: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00001F0E:
; H063+$00001F0E: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00001F14:
; H063+$00001F14: 60000018  bra.w $1f2e
        bra.w H063+$1F2E
L063_00001F18:
; H063+$00001F18: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001F1C:
; H063+$00001F1C: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L063_00001F20:
; H063+$00001F20: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_00001F24:
; H063+$00001F24: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00001F28:
; H063+$00001F28: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00001F2E:
; H063+$00001F2E: 4e5d  unlk a5
        unlk a5
L063_00001F30:
; H063+$00001F30: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001F32:
; H063+$00001F32: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_1F7E [parziale]
; Scopo: Trampolino verso H063+$1F7E; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$1F7E.
;   - Richiama H030+$0256.
;   - Richiama H026+$000C.
; Chiamanti diretti: H063+$1E1E, H063+$1E96, H063+$0EA0, H065+$04DE, H013+$5DE4, H065+$27EC e altri 5
; --------------------------------------------------------------------------
L063_00001F34:
; H063+$00001F34: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001F36:
; H063+$00001F36: 287ae1c8  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001F3A:
; H063+$00001F3A: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_00001F3E:
; H063+$00001F3E: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L063_00001F42:
; H063+$00001F42: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L063_00001F46:
; H063+$00001F46: 6600000c  bne.w $1f54
        bne.w H063+$1F54
L063_00001F4A:
; H063+$00001F4A: 3b7c000cfffe  move.w #$c, -$2(a5)
        move.w #$c, -$2(a5)
L063_00001F50:
; H063+$00001F50: 6000002c  bra.w $1f7e
        bra.w H063+$1F7E
L063_00001F54:
; H063+$00001F54: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L063_00001F58:
; H063+$00001F58: 0c2b00010199  cmpi.b #$1, $199(a3)
        cmpi.b #$1, $199(a3)
L063_00001F5E:
; H063+$00001F5E: 66000018  bne.w $1f78
        bne.w H063+$1F78
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00001F62:
; H063+$00001F62: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L063_00001F6A:
; H063+$00001F6A: 6600000c  bne.w $1f78
        bne.w H063+$1F78
L063_00001F6E:
; H063+$00001F6E: 3b7c000efffe  move.w #$e, -$2(a5)
        move.w #$e, -$2(a5)
L063_00001F74:
; H063+$00001F74: 60000008  bra.w $1f7e
        bra.w H063+$1F7E
L063_00001F78:
; H063+$00001F78: 3b7c000bfffe  move.w #$b, -$2(a5)
        move.w #$b, -$2(a5)
L063_00001F7E:
; H063+$00001F7E: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L063_00001F82:
; H063+$00001F82: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L063_00001F86:
; H063+$00001F86: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L063_00001F8A:
; H063+$00001F8A: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001F8C:
; H063+$00001F8C: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00001F90:
; H063+$00001F90: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00001F94:
; H063+$00001F94: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00001F9A:
; H063+$00001F9A: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L063_00001F9E:
; H063+$00001F9E: 67000030  beq.w $1fd0
        beq.w H063+$1FD0
L063_00001FA2:
; H063+$00001FA2: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00001FA6:
; H063+$00001FA6: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L063_00001FAA:
; H063+$00001FAA: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L063_00001FB0:
; H063+$00001FB0: 3400  move.w d0, d2
        move.w d0, d2
L063_00001FB2:
; H063+$00001FB2: d46d0010  add.w $10(a5), d2
        add.w $10(a5), d2
L063_00001FB6:
; H063+$00001FB6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00001FB8:
; H063+$00001FB8: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L063_00001FBC:
; H063+$00001FBC: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L063_00001FC0:
; H063+$00001FC0: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00001FC2:
; H063+$00001FC2: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00001FC6:
; H063+$00001FC6: 486c008b  pea.l $8b(a4)
        pea.l $8b(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_00001FCA:
; H063+$00001FCA: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00001FD0:
; H063+$00001FD0: 4e5d  unlk a5
        unlk a5
L063_00001FD2:
; H063+$00001FD2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00001FD4:
; H063+$00001FD4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00001FD6:
; H063+$00001FD6: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L063_00001FDA:
; H063+$00001FDA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00001FDC [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H029+$0408, H049+$09D6, H016+$0014, H029+$067A.
;   - Richiama H029+$0408.
;   - Richiama H049+$09D6.
;   - Richiama H016+$0014.
;   - Richiama H029+$067A.
; Chiamanti diretti: H063+$218C, H063+$219E, H063+$21B2, H063+$21C4, H096+$46EE, H096+$36A4 e altri 9
; --------------------------------------------------------------------------
L063_00001FDC:
; H063+$00001FDC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00001FDE:
; H063+$00001FDE: 287ae120  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00001FE2:
; H063+$00001FE2: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L063_00001FE6:
; H063+$00001FE6: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L063_00001FEA:
; H063+$00001FEA: 670000d2  beq.w $20be
        beq.w H063+$20BE
L063_00001FEE:
; H063+$00001FEE: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00001FF2:
; H063+$00001FF2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_00001FF6:
; H063+$00001FF6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001FFA:
; H063+$00001FFA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00001FFE:
; H063+$00001FFE: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
; FLUSSO: Chiama Allocate_GraphicRecord (H029+$0408).
L063_00002002:
; H063+$00002002: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L063_00002008:
; H063+$00002008: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L063_0000200C:
; H063+$0000200C: e742  asl.w #$3, d2
        asl.w #$3, d2
L063_0000200E:
; H063+$0000200E: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L063_00002014:
; H063+$00002014: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L063_00002018:
; H063+$00002018: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_0000201A:
; H063+$0000201A: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L063_0000201E:
; H063+$0000201E: 2f334000  move.l (a3, d4.w), -(a7)
        move.l (a3, d4.w), -(a7)
L063_00002022:
; H063+$00002022: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H049+$09D6 (sub_H049_000009D6)
L063_00002026:
; H063+$00002026: 4eb9000009d6  jsr $9d6.l
        jsr (H049+$9D6).l
L063_0000202C:
; H063+$0000202C: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L063_00002030:
; H063+$00002030: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L063_00002034:
; H063+$00002034: 4853  pea.l (a3)
        pea.l (a3)
L063_00002036:
; H063+$00002036: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00002038:
; H063+$00002038: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000203A:
; H063+$0000203A: 24790000243a  movea.l $243a.l, a2
        movea.l (H005+$243A).l, a2
L063_00002040:
; H063+$00002040: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L063_00002044:
; H063+$00002044: 4853  pea.l (a3)
        pea.l (a3)
L063_00002046:
; H063+$00002046: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L063_0000204A:
; H063+$0000204A: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L063_0000204E:
; H063+$0000204E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00002050:
; H063+$00002050: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00002052:
; H063+$00002052: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00002056:
; H063+$00002056: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_0000205A:
; H063+$0000205A: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L063_0000205E:
; H063+$0000205E: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L063_00002062:
; H063+$00002062: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L063_00002064:
; H063+$00002064: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L063_0000206A:
; H063+$0000206A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L063_0000206E:
; H063+$0000206E: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L063_00002072:
; H063+$00002072: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L063_00002076:
; H063+$00002076: 4853  pea.l (a3)
        pea.l (a3)
L063_00002078:
; H063+$00002078: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000207A:
; H063+$0000207A: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000207C:
; H063+$0000207C: 24790000243a  movea.l $243a.l, a2
        movea.l (H005+$243A).l, a2
L063_00002082:
; H063+$00002082: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L063_00002086:
; H063+$00002086: 4853  pea.l (a3)
        pea.l (a3)
L063_00002088:
; H063+$00002088: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L063_0000208C:
; H063+$0000208C: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L063_00002090:
; H063+$00002090: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00002092:
; H063+$00002092: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00002094:
; H063+$00002094: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00002098:
; H063+$00002098: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_0000209C:
; H063+$0000209C: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L063_000020A0:
; H063+$000020A0: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L063_000020A4:
; H063+$000020A4: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L063_000020A6:
; H063+$000020A6: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L063_000020AC:
; H063+$000020AC: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L063_000020B0:
; H063+$000020B0: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
; FLUSSO: Chiama Free_GraphicRecord (H029+$067A).
L063_000020B4:
; H063+$000020B4: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L063_000020BA:
; H063+$000020BA: 600000b2  bra.w $216e
        bra.w H063+$216E
L063_000020BE:
; H063+$000020BE: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L063_000020C2:
; H063+$000020C2: e742  asl.w #$3, d2
        asl.w #$3, d2
L063_000020C4:
; H063+$000020C4: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L063_000020CA:
; H063+$000020CA: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L063_000020CE:
; H063+$000020CE: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_000020D0:
; H063+$000020D0: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L063_000020D4:
; H063+$000020D4: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L063_000020D8:
; H063+$000020D8: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L063_000020DC:
; H063+$000020DC: 4853  pea.l (a3)
        pea.l (a3)
L063_000020DE:
; H063+$000020DE: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000020E0:
; H063+$000020E0: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000020E2:
; H063+$000020E2: 24790000243a  movea.l $243a.l, a2
        movea.l (H005+$243A).l, a2
L063_000020E8:
; H063+$000020E8: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L063_000020EC:
; H063+$000020EC: 4853  pea.l (a3)
        pea.l (a3)
L063_000020EE:
; H063+$000020EE: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L063_000020F2:
; H063+$000020F2: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L063_000020F6:
; H063+$000020F6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000020F8:
; H063+$000020F8: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000020FA:
; H063+$000020FA: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_000020FE:
; H063+$000020FE: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00002102:
; H063+$00002102: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L063_00002106:
; H063+$00002106: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L063_0000210A:
; H063+$0000210A: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L063_0000210C:
; H063+$0000210C: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L063_00002112:
; H063+$00002112: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L063_00002116:
; H063+$00002116: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L063_0000211A:
; H063+$0000211A: e742  asl.w #$3, d2
        asl.w #$3, d2
L063_0000211C:
; H063+$0000211C: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L063_00002122:
; H063+$00002122: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L063_00002126:
; H063+$00002126: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002128:
; H063+$00002128: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L063_0000212C:
; H063+$0000212C: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L063_00002130:
; H063+$00002130: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L063_00002134:
; H063+$00002134: 4853  pea.l (a3)
        pea.l (a3)
L063_00002136:
; H063+$00002136: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00002138:
; H063+$00002138: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000213A:
; H063+$0000213A: 24790000243a  movea.l $243a.l, a2
        movea.l (H005+$243A).l, a2
L063_00002140:
; H063+$00002140: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L063_00002144:
; H063+$00002144: 4853  pea.l (a3)
        pea.l (a3)
L063_00002146:
; H063+$00002146: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L063_0000214A:
; H063+$0000214A: c4fc0018  mulu.w #$18, d2
        mulu.w #$18, d2
L063_0000214E:
; H063+$0000214E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00002150:
; H063+$00002150: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00002152:
; H063+$00002152: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00002156:
; H063+$00002156: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_0000215A:
; H063+$0000215A: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L063_0000215E:
; H063+$0000215E: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L063_00002162:
; H063+$00002162: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L063_00002164:
; H063+$00002164: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L063_0000216A:
; H063+$0000216A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L063_0000216E:
; H063+$0000216E: 4e5d  unlk a5
        unlk a5
L063_00002170:
; H063+$00002170: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002172:
; H063+$00002172: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002174:
; H063+$00002174: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_00002176:
; H063+$00002176: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002178 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$2AD2, H085+$1318, H085+$1AF8, H063+$27B4, H085+$12F4, H033+$15BA e altri 2
; --------------------------------------------------------------------------
L063_00002178:
; H063+$00002178: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000217A:
; H063+$0000217A: 287adf84  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000217E:
; H063+$0000217E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_00002182:
; H063+$00002182: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L063_00002186:
; H063+$00002186: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00002188:
; H063+$00002188: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000218A:
; H063+$0000218A: 4227  clr.b -(a7)
        clr.b -(a7)
L063_0000218C:
; H063+$0000218C: 6100fe4e  bsr.w $1fdc
        bsr.w H063+$1FDC
L063_00002190:
; H063+$00002190: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L063_00002194:
; H063+$00002194: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00002196:
; H063+$00002196: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_0000219A:
; H063+$0000219A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_0000219E:
; H063+$0000219E: 6100fe3c  bsr.w $1fdc
        bsr.w H063+$1FDC
L063_000021A2:
; H063+$000021A2: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L063_000021A6:
; H063+$000021A6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_000021AA:
; H063+$000021AA: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_000021AE:
; H063+$000021AE: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_000021B2:
; H063+$000021B2: 6100fe28  bsr.w $1fdc
        bsr.w H063+$1FDC
L063_000021B6:
; H063+$000021B6: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L063_000021BA:
; H063+$000021BA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_000021BE:
; H063+$000021BE: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_000021C2:
; H063+$000021C2: 4227  clr.b -(a7)
        clr.b -(a7)
L063_000021C4:
; H063+$000021C4: 6100fe16  bsr.w $1fdc
        bsr.w H063+$1FDC
L063_000021C8:
; H063+$000021C8: 4e5d  unlk a5
        unlk a5
L063_000021CA:
; H063+$000021CA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000021CC:
; H063+$000021CC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000021CE:
; H063+$000021CE: 548f  addq.l #$2, a7
        addq.l #$2, a7
L063_000021D0:
; H063+$000021D0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_22B4 [parziale]
; Scopo: Trampolino verso H063+$22B4; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$22B4.
;   - Richiama H048+$01E8.
;   - Richiama H048+$0DF2.
;   - Richiama H029+$1520.
;   - Richiama H029+$1576.
;   - Richiama H016+$0014.
;   - Richiama H029+$0B94.
; Chiamanti diretti: H027+$2B18, H085+$1B3A, H085+$14E2, H096+$46B2, H096+$37B0, H033+$1698
; --------------------------------------------------------------------------
L063_000021D2:
; H063+$000021D2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000021D4:
; H063+$000021D4: 287adf2a  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000021D8:
; H063+$000021D8: 4e55ffbe  link.w a5, #$ffbe
        link.w a5, #$ffbe
L063_000021DC:
; H063+$000021DC: 600000d6  bra.w $22b4
        bra.w H063+$22B4
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000021E0 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H016+$0014, H048+$01E8, H048+$0DF2, H029+$1520.
;   - Richiama H016+$0014.
;   - Richiama H048+$01E8.
;   - Richiama H048+$0DF2.
;   - Richiama H029+$1520.
;   - Richiama H029+$1576.
;   - Richiama H029+$0B94.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H063+$259A, H063+$2736
; --------------------------------------------------------------------------
L063_000021E0:
; H063+$000021E0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_000021E4:
; H063+$000021E4: 343900000062  move.w $62.l, d2
        move.w (H029+$62).l, d2
L063_000021EA:
; H063+$000021EA: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_000021EE:
; H063+$000021EE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L063_000021F2:
; H063+$000021F2: 3742ffd8  move.w d2, -$28(a3)
        move.w d2, -$28(a3)
L063_000021F6:
; H063+$000021F6: 4a3900000065  tst.b $65.l
        tst.b (H029+$65).l
L063_000021FC:
; H063+$000021FC: 67000016  beq.w $2214
        beq.w H063+$2214
L063_00002200:
; H063+$00002200: 267900003d8e  movea.l $3d8e.l, a3
        movea.l (H005+$3D8E).l, a3
L063_00002206:
; H063+$00002206: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L063_0000220A:
; H063+$0000220A: 256b0010ffbe  move.l $10(a3), -$42(a2)
        move.l $10(a3), -$42(a2)
L063_00002210:
; H063+$00002210: 60000014  bra.w $2226
        bra.w H063+$2226
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L063_00002214:
; H063+$00002214: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L063_0000221A:
; H063+$0000221A: 47eb00b8  lea.l $b8(a3), a3
        lea.l $b8(a3), a3
L063_0000221E:
; H063+$0000221E: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L063_00002222:
; H063+$00002222: 254bffbe  move.l a3, -$42(a2)
        move.l a3, -$42(a2)
L063_00002226:
; H063+$00002226: 343900000062  move.w $62.l, d2
        move.w (H029+$62).l, d2
L063_0000222C:
; H063+$0000222C: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_0000222E:
; H063+$0000222E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L063_00002232:
; H063+$00002232: 47ebffcc  lea.l -$34(a3), a3
        lea.l -$34(a3), a3
L063_00002236:
; H063+$00002236: 4a732000  tst.w (a3, d2.w)
        tst.w (a3, d2.w)
L063_0000223A:
; H063+$0000223A: 6d000070  blt.w $22ac
        blt.w H063+$22AC
L063_0000223E:
; H063+$0000223E: 247900003d8a  movea.l $3d8a.l, a2
        movea.l (H005+$3D8A).l, a2
L063_00002244:
; H063+$00002244: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L063_00002248:
; H063+$00002248: 4853  pea.l (a3)
        pea.l (a3)
L063_0000224A:
; H063+$0000224A: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000224C:
; H063+$0000224C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L063_00002250:
; H063+$00002250: 3f2bffd8  move.w -$28(a3), -(a7)
        move.w -$28(a3), -(a7)
L063_00002254:
; H063+$00002254: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L063_00002258:
; H063+$00002258: 2f2bffbe  move.l -$42(a3), -(a7)
        move.l -$42(a3), -(a7)
L063_0000225C:
; H063+$0000225C: 343900000062  move.w $62.l, d2
        move.w (H029+$62).l, d2
L063_00002262:
; H063+$00002262: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00002264:
; H063+$00002264: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L063_00002268:
; H063+$00002268: 47ebffcc  lea.l -$34(a3), a3
        lea.l -$34(a3), a3
L063_0000226C:
; H063+$0000226C: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L063_00002270:
; H063+$00002270: 5044  addq.w #$8, d4
        addq.w #$8, d4
L063_00002272:
; H063+$00002272: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L063_00002274:
; H063+$00002274: 343900000062  move.w $62.l, d2
        move.w (H029+$62).l, d2
L063_0000227A:
; H063+$0000227A: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_0000227C:
; H063+$0000227C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L063_00002280:
; H063+$00002280: 47ebffc8  lea.l -$38(a3), a3
        lea.l -$38(a3), a3
L063_00002284:
; H063+$00002284: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L063_00002288:
; H063+$00002288: 5044  addq.w #$8, d4
        addq.w #$8, d4
L063_0000228A:
; H063+$0000228A: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L063_0000228C:
; H063+$0000228C: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00002290:
; H063+$00002290: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_00002294:
; H063+$00002294: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L063_00002298:
; H063+$00002298: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L063_0000229C:
; H063+$0000229C: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L063_0000229E:
; H063+$0000229E: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L063_000022A4:
; H063+$000022A4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L063_000022A8:
; H063+$000022A8: 2740ffc2  move.l d0, -$3e(a3)
        move.l d0, -$3e(a3)
L063_000022AC:
; H063+$000022AC: 4e5d  unlk a5
        unlk a5
L063_000022AE:
; H063+$000022AE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000022B0:
; H063+$000022B0: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_000022B2:
; H063+$000022B2: 4ed0  jmp (a0)
        jmp (a0)
L063_000022B4:
; H063+$000022B4: 426dffc6  clr.w -$3a(a5)
        clr.w -$3a(a5)
L063_000022B8:
; H063+$000022B8: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L063_000022BC:
; H063+$000022BC: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_000022C0:
; H063+$000022C0: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_000022C4:
; H063+$000022C4: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L063_000022C8:
; H063+$000022C8: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_000022CC:
; H063+$000022CC: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L063_000022D0:
; H063+$000022D0: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L063_000022D4:
; H063+$000022D4: 946d0016  sub.w $16(a5), d2
        sub.w $16(a5), d2
L063_000022D8:
; H063+$000022D8: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_000022DC:
; H063+$000022DC: 3b42ffec  move.w d2, -$14(a5)
        move.w d2, -$14(a5)
L063_000022E0:
; H063+$000022E0: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L063_000022E4:
; H063+$000022E4: 946d0014  sub.w $14(a5), d2
        sub.w $14(a5), d2
L063_000022E8:
; H063+$000022E8: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_000022EC:
; H063+$000022EC: 3b42ffea  move.w d2, -$16(a5)
        move.w d2, -$16(a5)
L063_000022F0:
; H063+$000022F0: 342dffec  move.w -$14(a5), d2
        move.w -$14(a5), d2
L063_000022F4:
; H063+$000022F4: 4a42  tst.w d2
        tst.w d2
L063_000022F6:
; H063+$000022F6: 6c02  bge.b $22fa
        bge.b H063+$22FA
L063_000022F8:
; H063+$000022F8: 4442  neg.w d2
        neg.w d2
L063_000022FA:
; H063+$000022FA: 382dffea  move.w -$16(a5), d4
        move.w -$16(a5), d4
L063_000022FE:
; H063+$000022FE: 4a44  tst.w d4
        tst.w d4
L063_00002300:
; H063+$00002300: 6c02  bge.b $2304
        bge.b H063+$2304
L063_00002302:
; H063+$00002302: 4444  neg.w d4
        neg.w d4
L063_00002304:
; H063+$00002304: b444  cmp.w d4, d2
        cmp.w d4, d2
L063_00002306:
; H063+$00002306: 5ec2  sgt.b d2
        sgt.b d2
L063_00002308:
; H063+$00002308: 4402  neg.b d2
        neg.b d2
L063_0000230A:
; H063+$0000230A: 1b42fffe  move.b d2, -$2(a5)
        move.b d2, -$2(a5)
L063_0000230E:
; H063+$0000230E: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L063_00002312:
; H063+$00002312: 67000064  beq.w $2378
        beq.w H063+$2378
L063_00002316:
; H063+$00002316: 3b6dfffcffe4  move.w -$4(a5), -$1c(a5)
        move.w -$4(a5), -$1c(a5)
L063_0000231C:
; H063+$0000231C: 3b6dfffaffe2  move.w -$6(a5), -$1e(a5)
        move.w -$6(a5), -$1e(a5)
L063_00002322:
; H063+$00002322: 4a6dffec  tst.w -$14(a5)
        tst.w -$14(a5)
L063_00002326:
; H063+$00002326: 6f00000c  ble.w $2334
        ble.w H063+$2334
L063_0000232A:
; H063+$0000232A: 3b7c0002ffe0  move.w #$2, -$20(a5)
        move.w #$2, -$20(a5)
L063_00002330:
; H063+$00002330: 60000008  bra.w $233a
        bra.w H063+$233A
L063_00002334:
; H063+$00002334: 3b7cfffeffe0  move.w #$fffe, -$20(a5)
        move.w #$fffe, -$20(a5)
L063_0000233A:
; H063+$0000233A: 342dffec  move.w -$14(a5), d2
        move.w -$14(a5), d2
L063_0000233E:
; H063+$0000233E: 4a42  tst.w d2
        tst.w d2
L063_00002340:
; H063+$00002340: 6c02  bge.b $2344
        bge.b H063+$2344
L063_00002342:
; H063+$00002342: 4442  neg.w d2
        neg.w d2
L063_00002344:
; H063+$00002344: 48c2  ext.l d2
        ext.l d2
L063_00002346:
; H063+$00002346: 85fc0002  divs.w #$2, d2
        divs.w #$2, d2
L063_0000234A:
; H063+$0000234A: 3b42ffd2  move.w d2, -$2e(a5)
        move.w d2, -$2e(a5)
L063_0000234E:
; H063+$0000234E: 342dffea  move.w -$16(a5), d2
        move.w -$16(a5), d2
L063_00002352:
; H063+$00002352: 4a42  tst.w d2
        tst.w d2
L063_00002354:
; H063+$00002354: 6c02  bge.b $2358
        bge.b H063+$2358
L063_00002356:
; H063+$00002356: 4442  neg.w d2
        neg.w d2
L063_00002358:
; H063+$00002358: 3b42ffda  move.w d2, -$26(a5)
        move.w d2, -$26(a5)
L063_0000235C:
; H063+$0000235C: 4a6dffea  tst.w -$16(a5)
        tst.w -$16(a5)
L063_00002360:
; H063+$00002360: 6f00000c  ble.w $236e
        ble.w H063+$236E
L063_00002364:
; H063+$00002364: 3b7c0001ffde  move.w #$1, -$22(a5)
        move.w #$1, -$22(a5)
L063_0000236A:
; H063+$0000236A: 60000008  bra.w $2374
        bra.w H063+$2374
L063_0000236E:
; H063+$0000236E: 3b7cffffffde  move.w #$ffff, -$22(a5)
        move.w #$ffff, -$22(a5)
L063_00002374:
; H063+$00002374: 60000060  bra.w $23d6
        bra.w H063+$23D6
L063_00002378:
; H063+$00002378: 3b6dfffaffe4  move.w -$6(a5), -$1c(a5)
        move.w -$6(a5), -$1c(a5)
L063_0000237E:
; H063+$0000237E: 3b6dfffcffe2  move.w -$4(a5), -$1e(a5)
        move.w -$4(a5), -$1e(a5)
L063_00002384:
; H063+$00002384: 4a6dffea  tst.w -$16(a5)
        tst.w -$16(a5)
L063_00002388:
; H063+$00002388: 6f00000c  ble.w $2396
        ble.w H063+$2396
L063_0000238C:
; H063+$0000238C: 3b7c0002ffe0  move.w #$2, -$20(a5)
        move.w #$2, -$20(a5)
L063_00002392:
; H063+$00002392: 60000008  bra.w $239c
        bra.w H063+$239C
L063_00002396:
; H063+$00002396: 3b7cfffeffe0  move.w #$fffe, -$20(a5)
        move.w #$fffe, -$20(a5)
L063_0000239C:
; H063+$0000239C: 342dffea  move.w -$16(a5), d2
        move.w -$16(a5), d2
L063_000023A0:
; H063+$000023A0: 4a42  tst.w d2
        tst.w d2
L063_000023A2:
; H063+$000023A2: 6c02  bge.b $23a6
        bge.b H063+$23A6
L063_000023A4:
; H063+$000023A4: 4442  neg.w d2
        neg.w d2
L063_000023A6:
; H063+$000023A6: 48c2  ext.l d2
        ext.l d2
L063_000023A8:
; H063+$000023A8: 85fc0002  divs.w #$2, d2
        divs.w #$2, d2
L063_000023AC:
; H063+$000023AC: 3b42ffd2  move.w d2, -$2e(a5)
        move.w d2, -$2e(a5)
L063_000023B0:
; H063+$000023B0: 342dffec  move.w -$14(a5), d2
        move.w -$14(a5), d2
L063_000023B4:
; H063+$000023B4: 4a42  tst.w d2
        tst.w d2
L063_000023B6:
; H063+$000023B6: 6c02  bge.b $23ba
        bge.b H063+$23BA
L063_000023B8:
; H063+$000023B8: 4442  neg.w d2
        neg.w d2
L063_000023BA:
; H063+$000023BA: 3b42ffda  move.w d2, -$26(a5)
        move.w d2, -$26(a5)
L063_000023BE:
; H063+$000023BE: 4a6dffec  tst.w -$14(a5)
        tst.w -$14(a5)
L063_000023C2:
; H063+$000023C2: 6f00000c  ble.w $23d0
        ble.w H063+$23D0
L063_000023C6:
; H063+$000023C6: 3b7c0001ffde  move.w #$1, -$22(a5)
        move.w #$1, -$22(a5)
L063_000023CC:
; H063+$000023CC: 60000008  bra.w $23d6
        bra.w H063+$23D6
L063_000023D0:
; H063+$000023D0: 3b7cffffffde  move.w #$ffff, -$22(a5)
        move.w #$ffff, -$22(a5)
L063_000023D6:
; H063+$000023D6: 342dffd2  move.w -$2e(a5), d2
        move.w -$2e(a5), d2
L063_000023DA:
; H063+$000023DA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_000023DC:
; H063+$000023DC: 3b42ffd0  move.w d2, -$30(a5)
        move.w d2, -$30(a5)
L063_000023E0:
; H063+$000023E0: 342dffda  move.w -$26(a5), d2
        move.w -$26(a5), d2
L063_000023E4:
; H063+$000023E4: 48c2  ext.l d2
        ext.l d2
L063_000023E6:
; H063+$000023E6: 85fc0004  divs.w #$4, d2
        divs.w #$4, d2
L063_000023EA:
; H063+$000023EA: 3b42ffdc  move.w d2, -$24(a5)
        move.w d2, -$24(a5)
L063_000023EE:
; H063+$000023EE: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L063_000023F2:
; H063+$000023F2: 4a6dffd0  tst.w -$30(a5)
        tst.w -$30(a5)
L063_000023F6:
; H063+$000023F6: 6f00035c  ble.w $2754
        ble.w H063+$2754
L063_000023FA:
; H063+$000023FA: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_000023FE:
; H063+$000023FE: 48c2  ext.l d2
        ext.l d2
L063_00002400:
; H063+$00002400: 85fc0018  divs.w #$18, d2
        divs.w #$18, d2
L063_00002404:
; H063+$00002404: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L063_00002408:
; H063+$00002408: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_0000240C:
; H063+$0000240C: 48c2  ext.l d2
        ext.l d2
L063_0000240E:
; H063+$0000240E: 85fc0018  divs.w #$18, d2
        divs.w #$18, d2
L063_00002412:
; H063+$00002412: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L063_00002416:
; H063+$00002416: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L063_0000241A:
; H063+$0000241A: 946dfff8  sub.w -$8(a5), d2
        sub.w -$8(a5), d2
L063_0000241E:
; H063+$0000241E: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L063_00002422:
; H063+$00002422: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L063_00002426:
; H063+$00002426: 946dfff6  sub.w -$a(a5), d2
        sub.w -$a(a5), d2
L063_0000242A:
; H063+$0000242A: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L063_0000242E:
; H063+$0000242E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L063_00002432:
; H063+$00002432: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_00002438:
; H063+$00002438: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L063_0000243C:
; H063+$0000243C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_0000243E:
; H063+$0000243E: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00002442:
; H063+$00002442: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_00002448:
; H063+$00002448: 946b0004  sub.w $4(a3), d2
        sub.w $4(a3), d2
L063_0000244C:
; H063+$0000244C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H048+$01E8 (sub_H048_000001E8)
L063_0000244E:
; H063+$0000244E: 4eb9000001e8  jsr $1e8.l
        jsr (H048+$1E8).l
L063_00002454:
; H063+$00002454: 1400  move.b d0, d2
        move.b d0, d2
L063_00002456:
; H063+$00002456: 4a02  tst.b d2
        tst.b d2
L063_00002458:
; H063+$00002458: 67000030  beq.w $248a
        beq.w H063+$248A
L063_0000245C:
; H063+$0000245C: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L063_00002460:
; H063+$00002460: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_00002466:
; H063+$00002466: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L063_0000246A:
; H063+$0000246A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_0000246C:
; H063+$0000246C: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L063_00002470:
; H063+$00002470: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_00002476:
; H063+$00002476: 946b0004  sub.w $4(a3), d2
        sub.w $4(a3), d2
L063_0000247A:
; H063+$0000247A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H048+$01E8 (sub_H048_000001E8)
L063_0000247C:
; H063+$0000247C: 4eb9000001e8  jsr $1e8.l
        jsr (H048+$1E8).l
L063_00002482:
; H063+$00002482: 1400  move.b d0, d2
        move.b d0, d2
L063_00002484:
; H063+$00002484: 4a02  tst.b d2
        tst.b d2
L063_00002486:
; H063+$00002486: 6600004e  bne.w $24d6
        bne.w H063+$24D6
L063_0000248A:
; H063+$0000248A: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_0000248E:
; H063+$0000248E: 4a42  tst.w d2
        tst.w d2
L063_00002490:
; H063+$00002490: 6c02  bge.b $2494
        bge.b H063+$2494
L063_00002492:
; H063+$00002492: 4442  neg.w d2
        neg.w d2
L063_00002494:
; H063+$00002494: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L063_00002498:
; H063+$00002498: 6e00003c  bgt.w $24d6
        bgt.w H063+$24D6
L063_0000249C:
; H063+$0000249C: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_000024A0:
; H063+$000024A0: 4a42  tst.w d2
        tst.w d2
L063_000024A2:
; H063+$000024A2: 6c02  bge.b $24a6
        bge.b H063+$24A6
L063_000024A4:
; H063+$000024A4: 4442  neg.w d2
        neg.w d2
L063_000024A6:
; H063+$000024A6: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L063_000024AA:
; H063+$000024AA: 6e00002a  bgt.w $24d6
        bgt.w H063+$24D6
L063_000024AE:
; H063+$000024AE: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_000024B2:
; H063+$000024B2: 48c2  ext.l d2
        ext.l d2
L063_000024B4:
; H063+$000024B4: 85fc0002  divs.w #$2, d2
        divs.w #$2, d2
L063_000024B8:
; H063+$000024B8: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L063_000024BC:
; H063+$000024BC: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L063_000024C0:
; H063+$000024C0: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_000024C4:
; H063+$000024C4: 48c2  ext.l d2
        ext.l d2
L063_000024C6:
; H063+$000024C6: 85fc0002  divs.w #$2, d2
        divs.w #$2, d2
L063_000024CA:
; H063+$000024CA: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L063_000024CE:
; H063+$000024CE: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L063_000024D2:
; H063+$000024D2: 60000062  bra.w $2536
        bra.w H063+$2536
L063_000024D6:
; H063+$000024D6: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L063_000024DA:
; H063+$000024DA: 6700003a  beq.w $2516
        beq.w H063+$2516
L063_000024DE:
; H063+$000024DE: 4a6dffe8  tst.w -$18(a5)
        tst.w -$18(a5)
L063_000024E2:
; H063+$000024E2: 6c000006  bge.w $24ea
        bge.w H063+$24EA
L063_000024E6:
; H063+$000024E6: 5d6dfff0  subq.w #$6, -$10(a5)
        subq.w #$6, -$10(a5)
L063_000024EA:
; H063+$000024EA: 0c6d0090ffe8  cmpi.w #$90, -$18(a5)
        cmpi.w #$90, -$18(a5)
L063_000024F0:
; H063+$000024F0: 6f000006  ble.w $24f8
        ble.w H063+$24F8
L063_000024F4:
; H063+$000024F4: 5c6dfff0  addq.w #$6, -$10(a5)
        addq.w #$6, -$10(a5)
L063_000024F8:
; H063+$000024F8: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L063_000024FC:
; H063+$000024FC: 6c000006  bge.w $2504
        bge.w H063+$2504
L063_00002500:
; H063+$00002500: 5d6dffee  subq.w #$6, -$12(a5)
        subq.w #$6, -$12(a5)
L063_00002504:
; H063+$00002504: 0c6d0090ffe6  cmpi.w #$90, -$1a(a5)
        cmpi.w #$90, -$1a(a5)
L063_0000250A:
; H063+$0000250A: 6f000006  ble.w $2512
        ble.w H063+$2512
L063_0000250E:
; H063+$0000250E: 5c6dffee  addq.w #$6, -$12(a5)
        addq.w #$6, -$12(a5)
L063_00002512:
; H063+$00002512: 60000022  bra.w $2536
        bra.w H063+$2536
L063_00002516:
; H063+$00002516: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_0000251C:
; H063+$0000251C: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L063_00002520:
; H063+$00002520: 5642  addq.w #$3, d2
        addq.w #$3, d2
L063_00002522:
; H063+$00002522: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L063_00002526:
; H063+$00002526: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_0000252C:
; H063+$0000252C: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L063_00002530:
; H063+$00002530: 5642  addq.w #$3, d2
        addq.w #$3, d2
L063_00002532:
; H063+$00002532: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L063_00002536:
; H063+$00002536: 3f2dfff0  move.w -$10(a5), -(a7)
        move.w -$10(a5), -(a7)
L063_0000253A:
; H063+$0000253A: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L063_0000253E:
; H063+$0000253E: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L063_00002542:
; H063+$00002542: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H048+$0DF2 (sub_H048_00000DF2)
L063_00002546:
; H063+$00002546: 4eb900000df2  jsr $df2.l
        jsr (H048+$DF2).l
; -> H029+$1520 (sub_H029_00001520)
L063_0000254C:
; H063+$0000254C: 4eb900001520  jsr $1520.l
        jsr (H029+$1520).l
L063_00002552:
; H063+$00002552: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L063_00002556:
; H063+$00002556: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_0000255C:
; H063+$0000255C: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L063_00002560:
; H063+$00002560: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_00002564:
; H063+$00002564: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L063_00002568:
; H063+$00002568: 9842  sub.w d2, d4
        sub.w d2, d4
L063_0000256A:
; H063+$0000256A: 3b44ffe8  move.w d4, -$18(a5)
        move.w d4, -$18(a5)
L063_0000256E:
; H063+$0000256E: 3b7cffffffcc  move.w #$ffff, -$34(a5)
        move.w #$ffff, -$34(a5)
L063_00002574:
; H063+$00002574: 3b7cffffffce  move.w #$ffff, -$32(a5)
        move.w #$ffff, -$32(a5)
L063_0000257A:
; H063+$0000257A: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_00002580:
; H063+$00002580: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L063_00002584:
; H063+$00002584: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_00002588:
; H063+$00002588: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L063_0000258C:
; H063+$0000258C: 9842  sub.w d2, d4
        sub.w d2, d4
L063_0000258E:
; H063+$0000258E: 3b44ffe6  move.w d4, -$1a(a5)
        move.w d4, -$1a(a5)
; -> H029+$1576 (sub_H029_00001576)
L063_00002592:
; H063+$00002592: 4eb900001576  jsr $1576.l
        jsr (H029+$1576).l
L063_00002598:
; H063+$00002598: 4855  pea.l (a5)
        pea.l (a5)
L063_0000259A:
; H063+$0000259A: 6100fc44  bsr.w $21e0
        bsr.w H063+$21E0
L063_0000259E:
; H063+$0000259E: 343900000062  move.w $62.l, d2
        move.w (H029+$62).l, d2
L063_000025A4:
; H063+$000025A4: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_000025A6:
; H063+$000025A6: 47edffcc  lea.l -$34(a5), a3
        lea.l -$34(a5), a3
L063_000025AA:
; H063+$000025AA: 37adffe82000  move.w -$18(a5), (a3, d2.w)
        move.w -$18(a5), (a3, d2.w)
L063_000025B0:
; H063+$000025B0: 343900000062  move.w $62.l, d2
        move.w (H029+$62).l, d2
L063_000025B6:
; H063+$000025B6: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_000025B8:
; H063+$000025B8: 47edffc8  lea.l -$38(a5), a3
        lea.l -$38(a5), a3
L063_000025BC:
; H063+$000025BC: 37adffe62000  move.w -$1a(a5), (a3, d2.w)
        move.w -$1a(a5), (a3, d2.w)
L063_000025C2:
; H063+$000025C2: 2f2dffbe  move.l -$42(a5), -(a7)
        move.l -$42(a5), -(a7)
L063_000025C6:
; H063+$000025C6: 342dffe8  move.w -$18(a5), d2
        move.w -$18(a5), d2
L063_000025CA:
; H063+$000025CA: 5042  addq.w #$8, d2
        addq.w #$8, d2
L063_000025CC:
; H063+$000025CC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000025CE:
; H063+$000025CE: 342dffe6  move.w -$1a(a5), d2
        move.w -$1a(a5), d2
L063_000025D2:
; H063+$000025D2: 5042  addq.w #$8, d2
        addq.w #$8, d2
L063_000025D4:
; H063+$000025D4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000025D6:
; H063+$000025D6: 247900003d8a  movea.l $3d8a.l, a2
        movea.l (H005+$3D8A).l, a2
L063_000025DC:
; H063+$000025DC: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L063_000025E0:
; H063+$000025E0: 4853  pea.l (a3)
        pea.l (a3)
L063_000025E2:
; H063+$000025E2: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000025E4:
; H063+$000025E4: 3f2dffd8  move.w -$28(a5), -(a7)
        move.w -$28(a5), -(a7)
L063_000025E8:
; H063+$000025E8: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_000025EC:
; H063+$000025EC: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L063_000025F0:
; H063+$000025F0: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L063_000025F4:
; H063+$000025F4: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L063_000025F8:
; H063+$000025F8: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L063_000025FA:
; H063+$000025FA: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L063_00002600:
; H063+$00002600: 2b40ffc2  move.l d0, -$3e(a5)
        move.l d0, -$3e(a5)
L063_00002604:
; H063+$00002604: 3f2dffe8  move.w -$18(a5), -(a7)
        move.w -$18(a5), -(a7)
L063_00002608:
; H063+$00002608: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L063_0000260C:
; H063+$0000260C: 342dffc6  move.w -$3a(a5), d2
        move.w -$3a(a5), d2
L063_00002610:
; H063+$00002610: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_00002612:
; H063+$00002612: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00002616:
; H063+$00002616: 2f390000243a  move.l $243a.l, -(a7)
        move.l (H005+$243A).l, -(a7)
L063_0000261C:
; H063+$0000261C: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; FLUSSO: Chiama Draw_GraphicTile24 (H029+$0B94).
L063_00002622:
; H063+$00002622: 4eb900000b94  jsr $b94.l
        jsr (H029+$B94).l
L063_00002628:
; H063+$00002628: 342dffd0  move.w -$30(a5), d2
        move.w -$30(a5), d2
L063_0000262C:
; H063+$0000262C: 48c2  ext.l d2
        ext.l d2
L063_0000262E:
; H063+$0000262E: 85fc0006  divs.w #$6, d2
        divs.w #$6, d2
L063_00002632:
; H063+$00002632: 4842  swap d2
        swap d2
L063_00002634:
; H063+$00002634: 4a42  tst.w d2
        tst.w d2
L063_00002636:
; H063+$00002636: 66000016  bne.w $264e
        bne.w H063+$264E
L063_0000263A:
; H063+$0000263A: 526dffc6  addq.w #$1, -$3a(a5)
        addq.w #$1, -$3a(a5)
L063_0000263E:
; H063+$0000263E: 342dffc6  move.w -$3a(a5), d2
        move.w -$3a(a5), d2
L063_00002642:
; H063+$00002642: b46d000e  cmp.w $e(a5), d2
        cmp.w $e(a5), d2
L063_00002646:
; H063+$00002646: 65000006  bcs.w $264e
        bcs.w H063+$264E
L063_0000264A:
; H063+$0000264A: 426dffc6  clr.w -$3a(a5)
        clr.w -$3a(a5)
L063_0000264E:
; H063+$0000264E: 536dffd0  subq.w #$1, -$30(a5)
        subq.w #$1, -$30(a5)
L063_00002652:
; H063+$00002652: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L063_00002656:
; H063+$00002656: d56dffe4  add.w d2, -$1c(a5)
        add.w d2, -$1c(a5)
L063_0000265A:
; H063+$0000265A: 342dffda  move.w -$26(a5), d2
        move.w -$26(a5), d2
L063_0000265E:
; H063+$0000265E: d56dffdc  add.w d2, -$24(a5)
        add.w d2, -$24(a5)
L063_00002662:
; H063+$00002662: 342dffdc  move.w -$24(a5), d2
        move.w -$24(a5), d2
L063_00002666:
; H063+$00002666: b46dffd2  cmp.w -$2e(a5), d2
        cmp.w -$2e(a5), d2
L063_0000266A:
; H063+$0000266A: 6d000014  blt.w $2680
        blt.w H063+$2680
L063_0000266E:
; H063+$0000266E: 342dffd2  move.w -$2e(a5), d2
        move.w -$2e(a5), d2
L063_00002672:
; H063+$00002672: 956dffdc  sub.w d2, -$24(a5)
        sub.w d2, -$24(a5)
L063_00002676:
; H063+$00002676: 342dffde  move.w -$22(a5), d2
        move.w -$22(a5), d2
L063_0000267A:
; H063+$0000267A: d56dffe2  add.w d2, -$1e(a5)
        add.w d2, -$1e(a5)
L063_0000267E:
; H063+$0000267E: 60e2  bra.b $2662
        bra.b H063+$2662
L063_00002680:
; H063+$00002680: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L063_00002684:
; H063+$00002684: 67000012  beq.w $2698
        beq.w H063+$2698
L063_00002688:
; H063+$00002688: 3b6dffe4fffc  move.w -$1c(a5), -$4(a5)
        move.w -$1c(a5), -$4(a5)
L063_0000268E:
; H063+$0000268E: 3b6dffe2fffa  move.w -$1e(a5), -$6(a5)
        move.w -$1e(a5), -$6(a5)
L063_00002694:
; H063+$00002694: 6000000e  bra.w $26a4
        bra.w H063+$26A4
L063_00002698:
; H063+$00002698: 3b6dffe2fffc  move.w -$1e(a5), -$4(a5)
        move.w -$1e(a5), -$4(a5)
L063_0000269E:
; H063+$0000269E: 3b6dffe4fffa  move.w -$1c(a5), -$6(a5)
        move.w -$1c(a5), -$6(a5)
L063_000026A4:
; H063+$000026A4: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_000026AA:
; H063+$000026AA: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L063_000026AE:
; H063+$000026AE: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_000026B2:
; H063+$000026B2: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L063_000026B6:
; H063+$000026B6: 9842  sub.w d2, d4
        sub.w d2, d4
L063_000026B8:
; H063+$000026B8: 3b44ffe8  move.w d4, -$18(a5)
        move.w d4, -$18(a5)
L063_000026BC:
; H063+$000026BC: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_000026C2:
; H063+$000026C2: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L063_000026C6:
; H063+$000026C6: c5fc0018  muls.w #$18, d2
        muls.w #$18, d2
L063_000026CA:
; H063+$000026CA: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L063_000026CE:
; H063+$000026CE: 9842  sub.w d2, d4
        sub.w d2, d4
L063_000026D0:
; H063+$000026D0: 3b44ffe6  move.w d4, -$1a(a5)
        move.w d4, -$1a(a5)
L063_000026D4:
; H063+$000026D4: 4a6dffe8  tst.w -$18(a5)
        tst.w -$18(a5)
L063_000026D8:
; H063+$000026D8: 6d00001e  blt.w $26f8
        blt.w H063+$26F8
L063_000026DC:
; H063+$000026DC: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L063_000026E0:
; H063+$000026E0: 6d000016  blt.w $26f8
        blt.w H063+$26F8
L063_000026E4:
; H063+$000026E4: 0c6d0090ffe8  cmpi.w #$90, -$18(a5)
        cmpi.w #$90, -$18(a5)
L063_000026EA:
; H063+$000026EA: 6e00000c  bgt.w $26f8
        bgt.w H063+$26F8
L063_000026EE:
; H063+$000026EE: 0c6d0090ffe6  cmpi.w #$90, -$1a(a5)
        cmpi.w #$90, -$1a(a5)
L063_000026F4:
; H063+$000026F4: 6f000008  ble.w $26fe
        ble.w H063+$26FE
L063_000026F8:
; H063+$000026F8: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L063_000026FE:
; H063+$000026FE: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L063_00002702:
; H063+$00002702: 6600000a  bne.w $270e
        bne.w H063+$270E
L063_00002706:
; H063+$00002706: 4a6dffd0  tst.w -$30(a5)
        tst.w -$30(a5)
L063_0000270A:
; H063+$0000270A: 6e00fe86  bgt.w $2592
        bgt.w H063+$2592
L063_0000270E:
; H063+$0000270E: 7403  moveq #$3, d2
        moveq #3, d2
L063_00002710:
; H063+$00002710: 947900000062  sub.w $62.l, d2
        sub.w (H029+$62).l, d2
L063_00002716:
; H063+$00002716: 3b42ffd4  move.w d2, -$2c(a5)
        move.w d2, -$2c(a5)
L063_0000271A:
; H063+$0000271A: 3b7c0001ffd6  move.w #$1, -$2a(a5)
        move.w #$1, -$2a(a5)
L063_00002720:
; H063+$00002720: 3f2dffd4  move.w -$2c(a5), -(a7)
        move.w -$2c(a5), -(a7)
L063_00002724:
; H063+$00002724: 342dffd6  move.w -$2a(a5), d2
        move.w -$2a(a5), d2
L063_00002728:
; H063+$00002728: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L063_0000272A:
; H063+$0000272A: 6e000014  bgt.w $2740
        bgt.w H063+$2740
; -> H029+$1576 (sub_H029_00001576)
L063_0000272E:
; H063+$0000272E: 4eb900001576  jsr $1576.l
        jsr (H029+$1576).l
L063_00002734:
; H063+$00002734: 4855  pea.l (a5)
        pea.l (a5)
L063_00002736:
; H063+$00002736: 6100faa8  bsr.w $21e0
        bsr.w H063+$21E0
L063_0000273A:
; H063+$0000273A: 526dffd6  addq.w #$1, -$2a(a5)
        addq.w #$1, -$2a(a5)
L063_0000273E:
; H063+$0000273E: 68e4  bvc.b $2724
        bvc.b H063+$2724
L063_00002740:
; H063+$00002740: 548f  addq.l #$2, a7
        addq.l #$2, a7
L063_00002742:
; H063+$00002742: 423900000065  clr.b $65.l
        clr.b (H029+$65).l
L063_00002748:
; H063+$00002748: 13fc000100000064  move.b #$1, $64.l
        move.b #$1, (H029+$64).l
L063_00002750:
; H063+$00002750: 6000fca0  bra.w $23f2
        bra.w H063+$23F2
L063_00002754:
; H063+$00002754: 4e5d  unlk a5
        unlk a5
L063_00002756:
; H063+$00002756: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002758:
; H063+$00002758: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_0000275A:
; H063+$0000275A: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L063_0000275E:
; H063+$0000275E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002760 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H048+$0230, H048+$0F88, H048+$0FBA, H048+$0DF2.
;   - Richiama H048+$0230.
;   - Richiama H048+$0F88.
;   - Richiama H048+$0FBA.
;   - Richiama H048+$0DF2.
;   - Richiama H043+$190E.
;   - Richiama H048+$0AA8.
;   - Richiama H029+$0D58.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H027+$325E, H085+$2DEE, H085+$2EF8, H085+$3476, H085+$3E3E, H027+$0454 e altri 8
; --------------------------------------------------------------------------
L063_00002760:
; H063+$00002760: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002762:
; H063+$00002762: 287ad99c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002766:
; H063+$00002766: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L063_0000276A:
; H063+$0000276A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L063_0000276E:
; H063+$0000276E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00002770:
; H063+$00002770: 08020000  btst.b #$0, d2
        btst #$0, d2
L063_00002774:
; H063+$00002774: 6702  beq.b $2778
        beq.b H063+$2778
L063_00002776:
; H063+$00002776: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00002778:
; H063+$00002778: 9ec2  suba.w d2, a7
        suba.w d2, a7
L063_0000277A:
; H063+$0000277A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000277E:
; H063+$0000277E: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L063_00002782:
; H063+$00002782: 244f  movea.l a7, a2
        movea.l a7, a2
L063_00002784:
; H063+$00002784: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002786:
; H063+$00002786: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00002788:
; H063+$00002788: 51cafffc  dbra d2, $2786
        dbra d2, H063+$2786
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_0000278C:
; H063+$0000278C: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L063_00002794:
; H063+$00002794: 660001ca  bne.w $2960
        bne.w H063+$2960
L063_00002798:
; H063+$00002798: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L063_0000279C:
; H063+$0000279C: 6700000c  beq.w $27aa
        beq.w H063+$27AA
L063_000027A0:
; H063+$000027A0: 3b7c0016fffa  move.w #$16, -$6(a5)
        move.w #$16, -$6(a5)
L063_000027A6:
; H063+$000027A6: 60000008  bra.w $27b0
        bra.w H063+$27B0
L063_000027AA:
; H063+$000027AA: 3b7c0017fffa  move.w #$17, -$6(a5)
        move.w #$17, -$6(a5)
L063_000027B0:
; H063+$000027B0: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L063_000027B4:
; H063+$000027B4: 6100f9c2  bsr.w $2178
        bsr.w H063+$2178
L063_000027B8:
; H063+$000027B8: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_000027BC:
; H063+$000027BC: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H048+$0230 (sub_H048_00000230)
L063_000027C0:
; H063+$000027C0: 4eb900000230  jsr $230.l
        jsr (H048+$230).l
L063_000027C6:
; H063+$000027C6: 1400  move.b d0, d2
        move.b d0, d2
L063_000027C8:
; H063+$000027C8: 4a02  tst.b d2
        tst.b d2
L063_000027CA:
; H063+$000027CA: 66000028  bne.w $27f4
        bne.w H063+$27F4
L063_000027CE:
; H063+$000027CE: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L063_000027D2:
; H063+$000027D2: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L063_000027D8:
; H063+$000027D8: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L063_000027DA:
; H063+$000027DA: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L063_000027DE:
; H063+$000027DE: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L063_000027E4:
; H063+$000027E4: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L063_000027E6:
; H063+$000027E6: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_000027EA:
; H063+$000027EA: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H048+$0DF2 (sub_H048_00000DF2)
L063_000027EE:
; H063+$000027EE: 4eb900000df2  jsr $df2.l
        jsr (H048+$DF2).l
L063_000027F4:
; H063+$000027F4: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L063_000027F8:
; H063+$000027F8: 67000010  beq.w $280a
        beq.w H063+$280A
L063_000027FC:
; H063+$000027FC: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L063_00002800:
; H063+$00002800: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L063_00002806:
; H063+$00002806: 6000004a  bra.w $2852
        bra.w H063+$2852
L063_0000280A:
; H063+$0000280A: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000280C:
; H063+$0000280C: 143900002475  move.b $2475.l, d2
        move.b (H005+$2475).l, d2
L063_00002812:
; H063+$00002812: 0c420042  cmpi.w #$42, d2
        cmpi.w #$42, d2
L063_00002816:
; H063+$00002816: 67000022  beq.w $283a
        beq.w H063+$283A
L063_0000281A:
; H063+$0000281A: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000281C:
; H063+$0000281C: 143900002475  move.b $2475.l, d2
        move.b (H005+$2475).l, d2
L063_00002822:
; H063+$00002822: 0c420055  cmpi.w #$55, d2
        cmpi.w #$55, d2
L063_00002826:
; H063+$00002826: 67000012  beq.w $283a
        beq.w H063+$283A
L063_0000282A:
; H063+$0000282A: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000282C:
; H063+$0000282C: 143900002471  move.b $2471.l, d2
        move.b (H005+$2471).l, d2
L063_00002832:
; H063+$00002832: 0c420033  cmpi.w #$33, d2
        cmpi.w #$33, d2
L063_00002836:
; H063+$00002836: 66000010  bne.w $2848
        bne.w H063+$2848
L063_0000283A:
; H063+$0000283A: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L063_0000283E:
; H063+$0000283E: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L063_00002844:
; H063+$00002844: 6000000c  bra.w $2852
        bra.w H063+$2852
L063_00002848:
; H063+$00002848: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L063_0000284C:
; H063+$0000284C: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L063_00002852:
; H063+$00002852: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00002856:
; H063+$00002856: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L063_0000285A:
; H063+$0000285A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000285E:
; H063+$0000285E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00002862:
; H063+$00002862: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00002864:
; H063+$00002864: 6100f55c  bsr.w $1dc2
        bsr.w H063+$1DC2
L063_00002868:
; H063+$00002868: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L063_0000286C:
; H063+$0000286C: 6700000e  beq.w $287c
        beq.w H063+$287C
L063_00002870:
; H063+$00002870: 3b7900003df6fff4  move.w $3df6.l, -$c(a5)
        move.w (H005+$3DF6).l, -$c(a5)
L063_00002878:
; H063+$00002878: 60000006  bra.w $2880
        bra.w H063+$2880
L063_0000287C:
; H063+$0000287C: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L063_00002880:
; H063+$00002880: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$0AA8 (sub_H048_00000AA8)
L063_00002884:
; H063+$00002884: 4eb900000aa8  jsr $aa8.l
        jsr (H048+$AA8).l
L063_0000288A:
; H063+$0000288A: 3400  move.w d0, d2
        move.w d0, d2
L063_0000288C:
; H063+$0000288C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_0000288E:
; H063+$0000288E: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00002890:
; H063+$00002890: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L063_00002896:
; H063+$00002896: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L063_0000289A:
; H063+$0000289A: c9fc0003  muls.w #$3, d4
        muls.w #$3, d4
L063_0000289E:
; H063+$0000289E: 3b44fffe  move.w d4, -$2(a5)
        move.w d4, -$2(a5)
L063_000028A2:
; H063+$000028A2: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$0AA8 (sub_H048_00000AA8)
L063_000028A6:
; H063+$000028A6: 4eb900000aa8  jsr $aa8.l
        jsr (H048+$AA8).l
L063_000028AC:
; H063+$000028AC: 3400  move.w d0, d2
        move.w d0, d2
L063_000028AE:
; H063+$000028AE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_000028B0:
; H063+$000028B0: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_000028B2:
; H063+$000028B2: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L063_000028B8:
; H063+$000028B8: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L063_000028BC:
; H063+$000028BC: c9fc0003  muls.w #$3, d4
        muls.w #$3, d4
L063_000028C0:
; H063+$000028C0: 3b44fffc  move.w d4, -$4(a5)
        move.w d4, -$4(a5)
L063_000028C4:
; H063+$000028C4: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L063_000028C8:
; H063+$000028C8: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L063_000028CC:
; H063+$000028CC: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_000028D0:
; H063+$000028D0: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L063_000028D2:
; H063+$000028D2: 62000078  bhi.w $294c
        bhi.w H063+$294C
L063_000028D6:
; H063+$000028D6: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L063_000028DA:
; H063+$000028DA: 0c6d0003fff8  cmpi.w #$3, -$8(a5)
        cmpi.w #$3, -$8(a5)
L063_000028E0:
; H063+$000028E0: 62000064  bhi.w $2946
        bhi.w H063+$2946
L063_000028E4:
; H063+$000028E4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_000028E8:
; H063+$000028E8: e742  asl.w #$3, d2
        asl.w #$3, d2
L063_000028EA:
; H063+$000028EA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000028EC:
; H063+$000028EC: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_000028F0:
; H063+$000028F0: e742  asl.w #$3, d2
        asl.w #$3, d2
L063_000028F2:
; H063+$000028F2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_000028F4:
; H063+$000028F4: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L063_000028F8:
; H063+$000028F8: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_000028FA:
; H063+$000028FA: 1f3c0005  move.b #$5, -(a7)
        move.b #$5, -(a7)
L063_000028FE:
; H063+$000028FE: 2f390000243a  move.l $243a.l, -(a7)
        move.l (H005+$243A).l, -(a7)
L063_00002904:
; H063+$00002904: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; -> H029+$0D58 (sub_H029_00000D58)
L063_0000290A:
; H063+$0000290A: 4eb900000d58  jsr $d58.l
        jsr (H029+$D58).l
L063_00002910:
; H063+$00002910: 7403  moveq #$3, d2
        moveq #3, d2
L063_00002912:
; H063+$00002912: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H036+$0034 (wrapper_Delay)
L063_00002914:
; H063+$00002914: 4eb900000034  jsr $34.l
        jsr (H036+$34).l
L063_0000291A:
; H063+$0000291A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000291E:
; H063+$0000291E: e742  asl.w #$3, d2
        asl.w #$3, d2
L063_00002920:
; H063+$00002920: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00002922:
; H063+$00002922: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00002926:
; H063+$00002926: e742  asl.w #$3, d2
        asl.w #$3, d2
L063_00002928:
; H063+$00002928: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_0000292A:
; H063+$0000292A: 4227  clr.b -(a7)
        clr.b -(a7)
L063_0000292C:
; H063+$0000292C: 4227  clr.b -(a7)
        clr.b -(a7)
L063_0000292E:
; H063+$0000292E: 2f3900003d8a  move.l $3d8a.l, -(a7)
        move.l (H005+$3D8A).l, -(a7)
L063_00002934:
; H063+$00002934: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; -> H029+$0D58 (sub_H029_00000D58)
L063_0000293A:
; H063+$0000293A: 4eb900000d58  jsr $d58.l
        jsr (H029+$D58).l
L063_00002940:
; H063+$00002940: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L063_00002944:
; H063+$00002944: 6494  bcc.b $28da
        bcc.b H063+$28DA
L063_00002946:
; H063+$00002946: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L063_0000294A:
; H063+$0000294A: 6480  bcc.b $28cc
        bcc.b H063+$28CC
L063_0000294C:
; H063+$0000294C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L063_0000294E:
; H063+$0000294E: 4a6dfff4  tst.w -$c(a5)
        tst.w -$c(a5)
L063_00002952:
; H063+$00002952: 66000008  bne.w $295c
        bne.w H063+$295C
; -> H030+$0B4A (sub_H030_00000B4A)
L063_00002956:
; H063+$00002956: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L063_0000295C:
; H063+$0000295C: 6000001a  bra.w $2978
        bra.w H063+$2978
L063_00002960:
; H063+$00002960: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00002964:
; H063+$00002964: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L063_00002968:
; H063+$00002968: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_0000296C:
; H063+$0000296C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00002970:
; H063+$00002970: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00002974:
; H063+$00002974: 6100f44c  bsr.w $1dc2
        bsr.w H063+$1DC2
L063_00002978:
; H063+$00002978: 4e5d  unlk a5
        unlk a5
L063_0000297A:
; H063+$0000297A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_0000297C:
; H063+$0000297C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_0000297E:
; H063+$0000297E: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L063_00002982:
; H063+$00002982: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002984 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; opera su H005+$3DE3 (contesto nativo, 5 nel combattimento).
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H062+$23CA, H061+$41F0, H096+$06DC
; --------------------------------------------------------------------------
L063_00002984:
; H063+$00002984: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002986:
; H063+$00002986: 287ad778  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000298A:
; H063+$0000298A: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_0000298E:
; H063+$0000298E: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_00002992:
; H063+$00002992: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L063_00002996:
; H063+$00002996: 7400  moveq #$0, d2
        moveq #0, d2
L063_00002998:
; H063+$00002998: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_0000299C:
; H063+$0000299C: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_000029A0:
; H063+$000029A0: b46d000c  cmp.w $c(a5), d2
        cmp.w $c(a5), d2
L063_000029A4:
; H063+$000029A4: 65000018  bcs.w $29be
        bcs.w H063+$29BE
L063_000029A8:
; H063+$000029A8: 7400  moveq #$0, d2
        moveq #0, d2
L063_000029AA:
; H063+$000029AA: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_000029AE:
; H063+$000029AE: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_000029B2:
; H063+$000029B2: 946d000c  sub.w $c(a5), d2
        sub.w $c(a5), d2
L063_000029B6:
; H063+$000029B6: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_000029BA:
; H063+$000029BA: 60000016  bra.w $29d2
        bra.w H063+$29D2
L063_000029BE:
; H063+$000029BE: 7400  moveq #$0, d2
        moveq #0, d2
L063_000029C0:
; H063+$000029C0: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_000029C4:
; H063+$000029C4: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_000029C8:
; H063+$000029C8: 382d000c  move.w $c(a5), d4
        move.w $c(a5), d4
L063_000029CC:
; H063+$000029CC: 9842  sub.w d2, d4
        sub.w d2, d4
L063_000029CE:
; H063+$000029CE: 3b44fffe  move.w d4, -$2(a5)
        move.w d4, -$2(a5)
L063_000029D2:
; H063+$000029D2: 0c6d0009fffe  cmpi.w #$9, -$2(a5)
        cmpi.w #$9, -$2(a5)
L063_000029D8:
; H063+$000029D8: 62000018  bhi.w $29f2
        bhi.w H063+$29F2
L063_000029DC:
; H063+$000029DC: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L063_000029E0:
; H063+$000029E0: 6600001e  bne.w $2a00
        bne.w H063+$2A00
L063_000029E4:
; H063+$000029E4: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_000029E8:
; H063+$000029E8: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L063_000029EE:
; H063+$000029EE: 66000010  bne.w $2a00
        bne.w H063+$2A00
L063_000029F2:
; H063+$000029F2: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_000029F6:
; H063+$000029F6: 177c00060197  move.b #$6, $197(a3)
        move.b #$6, $197(a3)
L063_000029FC:
; H063+$000029FC: 60000046  bra.w $2a44
        bra.w H063+$2A44
L063_00002A00:
; H063+$00002A00: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L063_00002A04:
; H063+$00002A04: 6300002c  bls.w $2a32
        bls.w H063+$2A32
L063_00002A08:
; H063+$00002A08: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002A0C:
; H063+$00002A0C: 177c00050197  move.b #$5, $197(a3)
        move.b #$5, $197(a3)
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00002A12:
; H063+$00002A12: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L063_00002A1A:
; H063+$00002A1A: 66000012  bne.w $2a2e
        bne.w H063+$2A2E
L063_00002A1E:
; H063+$00002A1E: 246d000e  movea.l $e(a5), a2
        movea.l $e(a5), a2
L063_00002A22:
; H063+$00002A22: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002A26:
; H063+$00002A26: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00002A2A:
; H063+$00002A2A: 17420010  move.b d2, $10(a3)
        move.b d2, $10(a3)
L063_00002A2E:
; H063+$00002A2E: 60000014  bra.w $2a44
        bra.w H063+$2A44
L063_00002A32:
; H063+$00002A32: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L063_00002A36:
; H063+$00002A36: 6600000c  bne.w $2a44
        bne.w H063+$2A44
L063_00002A3A:
; H063+$00002A3A: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002A3E:
; H063+$00002A3E: 177c00040197  move.b #$4, $197(a3)
        move.b #$4, $197(a3)
L063_00002A44:
; H063+$00002A44: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002A48:
; H063+$00002A48: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L063_00002A4C:
; H063+$00002A4C: 67000068  beq.w $2ab6
        beq.w H063+$2AB6
L063_00002A50:
; H063+$00002A50: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002A54:
; H063+$00002A54: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L063_00002A5A:
; H063+$00002A5A: 6700005a  beq.w $2ab6
        beq.w H063+$2AB6
L063_00002A5E:
; H063+$00002A5E: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002A62:
; H063+$00002A62: 422b0198  clr.b $198(a3)
        clr.b $198(a3)
L063_00002A66:
; H063+$00002A66: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002A6A:
; H063+$00002A6A: 422b01a8  clr.b $1a8(a3)
        clr.b $1a8(a3)
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00002A6E:
; H063+$00002A6E: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L063_00002A76:
; H063+$00002A76: 6600003a  bne.w $2ab2
        bne.w H063+$2AB2
L063_00002A7A:
; H063+$00002A7A: 7400  moveq #$0, d2
        moveq #0, d2
L063_00002A7C:
; H063+$00002A7C: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002A80:
; H063+$00002A80: 142b0199  move.b $199(a3), d2
        move.b $199(a3), d2
L063_00002A84:
; H063+$00002A84: 47f900002a1c  lea.l $2a1c.l, a3
        lea.l (H005+$2A1C).l, a3
L063_00002A8A:
; H063+$00002A8A: 7800  moveq #$0, d4
        moveq #0, d4
L063_00002A8C:
; H063+$00002A8C: 246d000e  movea.l $e(a5), a2
        movea.l $e(a5), a2
L063_00002A90:
; H063+$00002A90: 182a0199  move.b $199(a2), d4
        move.b $199(a2), d4
L063_00002A94:
; H063+$00002A94: 45f900002a1c  lea.l $2a1c.l, a2
        lea.l (H005+$2A1C).l, a2
L063_00002A9A:
; H063+$00002A9A: 7c00  moveq #$0, d6
        moveq #0, d6
L063_00002A9C:
; H063+$00002A9C: 1c324000  move.b (a2, d4.w), d6
        move.b (a2, d4.w), d6
L063_00002AA0:
; H063+$00002AA0: 5346  subq.w #$1, d6
        subq.w #$1, d6
L063_00002AA2:
; H063+$00002AA2: 17862000  move.b d6, (a3, d2.w)
        move.b d6, (a3, d2.w)
L063_00002AA6:
; H063+$00002AA6: 246d000e  movea.l $e(a5), a2
        movea.l $e(a5), a2
L063_00002AAA:
; H063+$00002AAA: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002AAE:
; H063+$00002AAE: 426b0004  clr.w $4(a3)
        clr.w $4(a3)
L063_00002AB2:
; H063+$00002AB2: 6000000e  bra.w $2ac2
        bra.w H063+$2AC2
L063_00002AB6:
; H063+$00002AB6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00002ABA:
; H063+$00002ABA: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00002ABE:
; H063+$00002ABE: 174201a8  move.b d2, $1a8(a3)
        move.b d2, $1a8(a3)
L063_00002AC2:
; H063+$00002AC2: 4e5d  unlk a5
        unlk a5
L063_00002AC4:
; H063+$00002AC4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002AC6:
; H063+$00002AC6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002AC8:
; H063+$00002AC8: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L063_00002ACA:
; H063+$00002ACA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002ACC [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; opera su H005+$3DE3 (contesto nativo, 5 nel combattimento); H005+$3368 (personaggio corrente).
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento); H005+$3368 (personaggio corrente).
; Chiamanti diretti: H027+$2126, H085+$1D30, H085+$3312
; --------------------------------------------------------------------------
L063_00002ACC:
; H063+$00002ACC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002ACE:
; H063+$00002ACE: 287ad630  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002AD2:
; H063+$00002AD2: 4e55ffd6  link.w a5, #$ffd6
        link.w a5, #$ffd6
L063_00002AD6:
; H063+$00002AD6: 7400  moveq #$0, d2
        moveq #0, d2
L063_00002AD8:
; H063+$00002AD8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00002ADC:
; H063+$00002ADC: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L063_00002AE0:
; H063+$00002AE0: 7800  moveq #$0, d4
        moveq #0, d4
L063_00002AE2:
; H063+$00002AE2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00002AE6:
; H063+$00002AE6: 182b0064  move.b $64(a3), d4
        move.b $64(a3), d4
L063_00002AEA:
; H063+$00002AEA: b444  cmp.w d4, d2
        cmp.w d4, d2
L063_00002AEC:
; H063+$00002AEC: 66000016  bne.w $2b04
        bne.w H063+$2B04
L063_00002AF0:
; H063+$00002AF0: 47ec008e  lea.l $8e(a4), a3
        lea.l $8e(a4), a3
L063_00002AF4:
; H063+$00002AF4: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L063_00002AF8:
; H063+$00002AF8: 7428  moveq #$28, d2
        moveq #40, d2
L063_00002AFA:
; H063+$00002AFA: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00002AFC:
; H063+$00002AFC: 57cafffc  dbeq d2, $2afa
        dbeq d2, H063+$2AFA
L063_00002B00:
; H063+$00002B00: 60000012  bra.w $2b14
        bra.w H063+$2B14
L063_00002B04:
; H063+$00002B04: 47ec009e  lea.l $9e(a4), a3
        lea.l $9e(a4), a3
L063_00002B08:
; H063+$00002B08: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L063_00002B0C:
; H063+$00002B0C: 7428  moveq #$28, d2
        moveq #40, d2
L063_00002B0E:
; H063+$00002B0E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00002B10:
; H063+$00002B10: 57cafffc  dbeq d2, $2b0e
        dbeq d2, H063+$2B0E
L063_00002B14:
; H063+$00002B14: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00002B18:
; H063+$00002B18: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00002B1C:
; H063+$00002B1C: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L063_00002B20:
; H063+$00002B20: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00002B24:
; H063+$00002B24: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00002B28:
; H063+$00002B28: 6100f298  bsr.w $1dc2
        bsr.w H063+$1DC2
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00002B2C:
; H063+$00002B2C: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L063_00002B34:
; H063+$00002B34: 6700000c  beq.w $2b42
        beq.w H063+$2B42
; STATO: H005+$3368 = personaggio corrente
L063_00002B38:
; H063+$00002B38: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L063_00002B3E:
; H063+$00002B3E: 6100e240  bsr.w $d80
        bsr.w H063+$D80
L063_00002B42:
; H063+$00002B42: 4e5d  unlk a5
        unlk a5
L063_00002B44:
; H063+$00002B44: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002B46:
; H063+$00002B46: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002B48:
; H063+$00002B48: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00002B4A:
; H063+$00002B4A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_2B72 [parziale]
; Scopo: Trampolino verso H063+$2B72; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$2B72.
; Chiamanti diretti: H085+$1C9E, H085+$3238, H063+$2C78, H096+$38EA, H097+$08CA, H096+$3874 e altri 2
; --------------------------------------------------------------------------
L063_00002B4C:
; H063+$00002B4C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002B4E:
; H063+$00002B4E: 287ad5b0  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002B52:
; H063+$00002B52: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_00002B56:
; H063+$00002B56: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00002B5A:
; H063+$00002B5A: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L063_00002B5E:
; H063+$00002B5E: 6600000c  bne.w $2b6c
        bne.w H063+$2B6C
L063_00002B62:
; H063+$00002B62: 7001  moveq #$1, d0
        moveq #1, d0
L063_00002B64:
; H063+$00002B64: 6000000c  bra.w $2b72
        bra.w H063+$2B72
; Preserved bytes H063+$00002B68..$00002B6C; code/data not fully classified.
        dc.w $6000,$0008
L063_00002B6C:
; H063+$00002B6C: 7000  moveq #$0, d0
        moveq #0, d0
L063_00002B6E:
; H063+$00002B6E: 60000002  bra.w $2b72
        bra.w H063+$2B72
L063_00002B72:
; H063+$00002B72: 4e5d  unlk a5
        unlk a5
L063_00002B74:
; H063+$00002B74: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002B76:
; H063+$00002B76: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002B78:
; H063+$00002B78: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00002B7A:
; H063+$00002B7A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002B7C [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H029+$03E2.
;   - Richiama H029+$03E2.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H027+$07DA, H062+$2712, H096+$39BA, H059+$17FE, H095+$1FCC, H059+$16BE e altri 1
; --------------------------------------------------------------------------
L063_00002B7C:
; H063+$00002B7C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002B7E:
; H063+$00002B7E: 287ad580  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002B82:
; H063+$00002B82: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L063_00002B86:
; H063+$00002B86: 423900002a1c  clr.b $2a1c.l
        clr.b (H005+$2A1C).l
L063_00002B8C:
; H063+$00002B8C: 423900002a1d  clr.b $2a1d.l
        clr.b (H005+$2A1D).l
; STATO: H005+$3364 = testa della lista del party
L063_00002B92:
; H063+$00002B92: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L063_00002B9A:
; H063+$00002B9A: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_00002B9E:
; H063+$00002B9E: 67000038  beq.w $2bd8
        beq.w H063+$2BD8
L063_00002BA2:
; H063+$00002BA2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00002BA6:
; H063+$00002BA6: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L063_00002BAA:
; H063+$00002BAA: 67000020  beq.w $2bcc
        beq.w H063+$2BCC
L063_00002BAE:
; H063+$00002BAE: 7400  moveq #$0, d2
        moveq #0, d2
L063_00002BB0:
; H063+$00002BB0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00002BB4:
; H063+$00002BB4: 142b0199  move.b $199(a3), d2
        move.b $199(a3), d2
L063_00002BB8:
; H063+$00002BB8: 47f900002a1c  lea.l $2a1c.l, a3
        lea.l (H005+$2A1C).l, a3
L063_00002BBE:
; H063+$00002BBE: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
L063_00002BC2:
; H063+$00002BC2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L063_00002BC6:
; H063+$00002BC6: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L063_00002BCC:
; H063+$00002BCC: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00002BD0:
; H063+$00002BD0: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L063_00002BD6:
; H063+$00002BD6: 60c2  bra.b $2b9a
        bra.b H063+$2B9A
L063_00002BD8:
; H063+$00002BD8: 4e5d  unlk a5
        unlk a5
L063_00002BDA:
; H063+$00002BDA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002BDC:
; H063+$00002BDC: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002BDE [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H048+$0F88, H048+$0FBA, H048+$110C, H077+$08AC.
;   - Richiama H048+$0F88.
;   - Richiama H048+$0FBA.
;   - Richiama H048+$110C.
;   - Richiama H077+$08AC.
; Chiamanti diretti: H085+$0B60, H096+$4C54, H096+$3B70, H096+$1398, H096+$41A4, H097+$07D2 e altri 8
; --------------------------------------------------------------------------
L063_00002BDE:
; H063+$00002BDE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002BE0:
; H063+$00002BE0: 287ad51e  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002BE4:
; H063+$00002BE4: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L063_00002BE8:
; H063+$00002BE8: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L063_00002BEC:
; H063+$00002BEC: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L063_00002BF2:
; H063+$00002BF2: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L063_00002BF4:
; H063+$00002BF4: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L063_00002BF8:
; H063+$00002BF8: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L063_00002BFE:
; H063+$00002BFE: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L063_00002C00:
; H063+$00002C00: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L063_00002C04:
; H063+$00002C04: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L063_00002C08:
; H063+$00002C08: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H048+$110C (sub_H048_0000110C)
L063_00002C0C:
; H063+$00002C0C: 4eb90000110c  jsr $110c.l
        jsr (H048+$110C).l
L063_00002C12:
; H063+$00002C12: 1400  move.b d0, d2
        move.b d0, d2
L063_00002C14:
; H063+$00002C14: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_00002C18:
; H063+$00002C18: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00002C1A:
; H063+$00002C1A: 2f3900002ade  move.l $2ade.l, -(a7)
        move.l (H005+$2ADE).l, -(a7)
; -> H077+$08AC (sub_H077_000008AC)
L063_00002C20:
; H063+$00002C20: 4eb9000008ac  jsr $8ac.l
        jsr (H077+$8AC).l
L063_00002C26:
; H063+$00002C26: 7400  moveq #$0, d2
        moveq #0, d2
L063_00002C28:
; H063+$00002C28: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L063_00002C2E:
; H063+$00002C2E: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_00002C32:
; H063+$00002C32: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L063_00002C36:
; H063+$00002C36: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L063_00002C3A:
; H063+$00002C3A: 63000096  bls.w $2cd2
        bls.w H063+$2CD2
L063_00002C3E:
; H063+$00002C3E: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L063_00002C44:
; H063+$00002C44: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L063_00002C48:
; H063+$00002C48: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002C4C:
; H063+$00002C4C: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L063_00002C4E:
; H063+$00002C4E: 62000070  bhi.w $2cc0
        bhi.w H063+$2CC0
L063_00002C52:
; H063+$00002C52: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002C56:
; H063+$00002C56: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002C58:
; H063+$00002C58: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_00002C5A:
; H063+$00002C5A: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L063_00002C60:
; H063+$00002C60: 7800  moveq #$0, d4
        moveq #0, d4
L063_00002C62:
; H063+$00002C62: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_00002C66:
; H063+$00002C66: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00002C68:
; H063+$00002C68: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002C6A:
; H063+$00002C6A: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L063_00002C70:
; H063+$00002C70: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L063_00002C74:
; H063+$00002C74: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L063_00002C78:
; H063+$00002C78: 6100fed2  bsr.w $2b4c
        bsr.w H063+$2B4C
L063_00002C7C:
; H063+$00002C7C: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L063_00002C80:
; H063+$00002C80: 1400  move.b d0, d2
        move.b d0, d2
L063_00002C82:
; H063+$00002C82: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L063_00002C86:
; H063+$00002C86: 182b0199  move.b $199(a3), d4
        move.b $199(a3), d4
L063_00002C8A:
; H063+$00002C8A: b802  cmp.b d2, d4
        cmp.b d2, d4
L063_00002C8C:
; H063+$00002C8C: 6600002c  bne.w $2cba
        bne.w H063+$2CBA
L063_00002C90:
; H063+$00002C90: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L063_00002C94:
; H063+$00002C94: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00002C98:
; H063+$00002C98: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002C9A:
; H063+$00002C9A: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_00002C9C:
; H063+$00002C9C: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L063_00002CA2:
; H063+$00002CA2: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L063_00002CA6:
; H063+$00002CA6: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00002CA8:
; H063+$00002CA8: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002CAA:
; H063+$00002CAA: 45f900002a3e  lea.l $2a3e.l, a2
        lea.l (H005+$2A3E).l, a2
L063_00002CB0:
; H063+$00002CB0: 45f24000  lea.l (a2, d4.w), a2
        lea.l (a2, d4.w), a2
L063_00002CB4:
; H063+$00002CB4: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L063_00002CB8:
; H063+$00002CB8: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L063_00002CBA:
; H063+$00002CBA: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L063_00002CBE:
; H063+$00002CBE: 6488  bcc.b $2c48
        bcc.b H063+$2C48
L063_00002CC0:
; H063+$00002CC0: 548f  addq.l #$2, a7
        addq.l #$2, a7
L063_00002CC2:
; H063+$00002CC2: 3b6dfffcfffe  move.w -$4(a5), -$2(a5)
        move.w -$4(a5), -$2(a5)
L063_00002CC8:
; H063+$00002CC8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00002CCC:
; H063+$00002CCC: 13c200002479  move.b d2, $2479.l
        move.b d2, (H005+$2479).l
L063_00002CD2:
; H063+$00002CD2: 3b6dfffefff8  move.w -$2(a5), -$8(a5)
        move.w -$2(a5), -$8(a5)
L063_00002CD8:
; H063+$00002CD8: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L063_00002CDE:
; H063+$00002CDE: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L063_00002CE2:
; H063+$00002CE2: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002CE6:
; H063+$00002CE6: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L063_00002CE8:
; H063+$00002CE8: 62000028  bhi.w $2d12
        bhi.w H063+$2D12
L063_00002CEC:
; H063+$00002CEC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002CF0:
; H063+$00002CF0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002CF2:
; H063+$00002CF2: 47f900002444  lea.l $2444.l, a3
        lea.l (H005+$2444).l, a3
L063_00002CF8:
; H063+$00002CF8: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L063_00002CFC:
; H063+$00002CFC: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00002CFE:
; H063+$00002CFE: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002D00:
; H063+$00002D00: 45f900002a3e  lea.l $2a3e.l, a2
        lea.l (H005+$2A3E).l, a2
L063_00002D06:
; H063+$00002D06: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L063_00002D0C:
; H063+$00002D0C: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L063_00002D10:
; H063+$00002D10: 64d0  bcc.b $2ce2
        bcc.b H063+$2CE2
L063_00002D12:
; H063+$00002D12: 548f  addq.l #$2, a7
        addq.l #$2, a7
L063_00002D14:
; H063+$00002D14: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L063_00002D18:
; H063+$00002D18: 3f3c005b  move.w #$5b, -(a7)
        move.w #$5b, -(a7)
L063_00002D1C:
; H063+$00002D1C: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
L063_00002D20:
; H063+$00002D20: 6100dc24  bsr.w $946
        bsr.w H063+$946
L063_00002D24:
; H063+$00002D24: 1400  move.b d0, d2
        move.b d0, d2
L063_00002D26:
; H063+$00002D26: 4a02  tst.b d2
        tst.b d2
L063_00002D28:
; H063+$00002D28: 6700008a  beq.w $2db4
        beq.w H063+$2DB4
L063_00002D2C:
; H063+$00002D2C: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L063_00002D32:
; H063+$00002D32: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L063_00002D36:
; H063+$00002D36: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002D3A:
; H063+$00002D3A: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L063_00002D3E:
; H063+$00002D3E: 62000074  bhi.w $2db4
        bhi.w H063+$2DB4
L063_00002D42:
; H063+$00002D42: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L063_00002D46:
; H063+$00002D46: 6600006c  bne.w $2db4
        bne.w H063+$2DB4
L063_00002D4A:
; H063+$00002D4A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002D4E:
; H063+$00002D4E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002D50:
; H063+$00002D50: 47f900002444  lea.l $2444.l, a3
        lea.l (H005+$2444).l, a3
L063_00002D56:
; H063+$00002D56: 7800  moveq #$0, d4
        moveq #0, d4
L063_00002D58:
; H063+$00002D58: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_00002D5C:
; H063+$00002D5C: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00002D5E:
; H063+$00002D5E: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002D60:
; H063+$00002D60: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L063_00002D66:
; H063+$00002D66: 24334000  move.l (a3, d4.w), d2
        move.l (a3, d4.w), d2
L063_00002D6A:
; H063+$00002D6A: b4b900002432  cmp.l $2432.l, d2
        cmp.l (H005+$2432).l, d2
L063_00002D70:
; H063+$00002D70: 6600003c  bne.w $2dae
        bne.w H063+$2DAE
L063_00002D74:
; H063+$00002D74: 7400  moveq #$0, d2
        moveq #0, d2
L063_00002D76:
; H063+$00002D76: 143900002444  move.b $2444.l, d2
        move.b (H005+$2444).l, d2
L063_00002D7C:
; H063+$00002D7C: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_00002D80:
; H063+$00002D80: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002D84:
; H063+$00002D84: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002D86:
; H063+$00002D86: 47f900002444  lea.l $2444.l, a3
        lea.l (H005+$2444).l, a3
L063_00002D8C:
; H063+$00002D8C: 13f3200000002444  move.b (a3, d2.w), $2444.l
        move.b (a3, d2.w), (H005+$2444).l
L063_00002D94:
; H063+$00002D94: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00002D98:
; H063+$00002D98: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002D9A:
; H063+$00002D9A: 47f900002444  lea.l $2444.l, a3
        lea.l (H005+$2444).l, a3
L063_00002DA0:
; H063+$00002DA0: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L063_00002DA4:
; H063+$00002DA4: 17842000  move.b d4, (a3, d2.w)
        move.b d4, (a3, d2.w)
L063_00002DA8:
; H063+$00002DA8: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L063_00002DAE:
; H063+$00002DAE: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L063_00002DB2:
; H063+$00002DB2: 6082  bra.b $2d36
        bra.b H063+$2D36
L063_00002DB4:
; H063+$00002DB4: 302dfff8  move.w -$8(a5), d0
        move.w -$8(a5), d0
L063_00002DB8:
; H063+$00002DB8: 60000002  bra.w $2dbc
        bra.w H063+$2DBC
L063_00002DBC:
; H063+$00002DBC: 4e5d  unlk a5
        unlk a5
L063_00002DBE:
; H063+$00002DBE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002DC0:
; H063+$00002DC0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002DC2:
; H063+$00002DC2: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L063_00002DC4:
; H063+$00002DC4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002DC6 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H048+$0F88, H048+$0FBA, H048+$110C, H077+$08AC.
;   - Richiama H048+$0F88.
;   - Richiama H048+$0FBA.
;   - Richiama H048+$110C.
;   - Richiama H077+$08AC.
; Chiamanti diretti: H027+$04E8, H027+$2474, H027+$3CCC, H027+$3F88, H027+$1772, H096+$1380 e altri 5
; --------------------------------------------------------------------------
L063_00002DC6:
; H063+$00002DC6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002DC8:
; H063+$00002DC8: 287ad336  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002DCC:
; H063+$00002DCC: 4e55fc00  link.w a5, #$fc00
        link.w a5, #$fc00
L063_00002DD0:
; H063+$00002DD0: 3b7c0001fc02  move.w #$1, -$3fe(a5)
        move.w #$1, -$3fe(a5)
L063_00002DD6:
; H063+$00002DD6: 0c6d0028fc02  cmpi.w #$28, -$3fe(a5)
        cmpi.w #$28, -$3fe(a5)
L063_00002DDC:
; H063+$00002DDC: 6200002c  bhi.w $2e0a
        bhi.w H063+$2E0A
L063_00002DE0:
; H063+$00002DE0: 342dfc02  move.w -$3fe(a5), d2
        move.w -$3fe(a5), d2
L063_00002DE4:
; H063+$00002DE4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002DE6:
; H063+$00002DE6: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_00002DE8:
; H063+$00002DE8: 47edfc04  lea.l -$3fc(a5), a3
        lea.l -$3fc(a5), a3
L063_00002DEC:
; H063+$00002DEC: 382dfc02  move.w -$3fe(a5), d4
        move.w -$3fe(a5), d4
L063_00002DF0:
; H063+$00002DF0: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00002DF2:
; H063+$00002DF2: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002DF4:
; H063+$00002DF4: 45f900002a3e  lea.l $2a3e.l, a2
        lea.l (H005+$2A3E).l, a2
L063_00002DFA:
; H063+$00002DFA: 45f24000  lea.l (a2, d4.w), a2
        lea.l (a2, d4.w), a2
L063_00002DFE:
; H063+$00002DFE: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L063_00002E02:
; H063+$00002E02: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L063_00002E04:
; H063+$00002E04: 526dfc02  addq.w #$1, -$3fe(a5)
        addq.w #$1, -$3fe(a5)
L063_00002E08:
; H063+$00002E08: 64cc  bcc.b $2dd6
        bcc.b H063+$2DD6
L063_00002E0A:
; H063+$00002E0A: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_00002E10:
; H063+$00002E10: 177c00010008  move.b #$1, $8(a3)
        move.b #$1, $8(a3)
L063_00002E16:
; H063+$00002E16: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L063_00002E1A:
; H063+$00002E1A: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L063_00002E20:
; H063+$00002E20: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L063_00002E22:
; H063+$00002E22: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L063_00002E26:
; H063+$00002E26: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L063_00002E2C:
; H063+$00002E2C: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L063_00002E2E:
; H063+$00002E2E: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L063_00002E32:
; H063+$00002E32: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L063_00002E36:
; H063+$00002E36: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H048+$110C (sub_H048_0000110C)
L063_00002E3A:
; H063+$00002E3A: 4eb90000110c  jsr $110c.l
        jsr (H048+$110C).l
L063_00002E40:
; H063+$00002E40: 1400  move.b d0, d2
        move.b d0, d2
L063_00002E42:
; H063+$00002E42: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_00002E46:
; H063+$00002E46: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00002E48:
; H063+$00002E48: 2f3900002ade  move.l $2ade.l, -(a7)
        move.l (H005+$2ADE).l, -(a7)
; -> H077+$08AC (sub_H077_000008AC)
L063_00002E4E:
; H063+$00002E4E: 4eb9000008ac  jsr $8ac.l
        jsr (H077+$8AC).l
L063_00002E54:
; H063+$00002E54: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_00002E5A:
; H063+$00002E5A: 422b0008  clr.b $8(a3)
        clr.b $8(a3)
L063_00002E5E:
; H063+$00002E5E: 3b7c0001fc02  move.w #$1, -$3fe(a5)
        move.w #$1, -$3fe(a5)
L063_00002E64:
; H063+$00002E64: 342dfc02  move.w -$3fe(a5), d2
        move.w -$3fe(a5), d2
L063_00002E68:
; H063+$00002E68: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002E6A:
; H063+$00002E6A: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_00002E6C:
; H063+$00002E6C: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L063_00002E72:
; H063+$00002E72: 7800  moveq #$0, d4
        moveq #0, d4
L063_00002E74:
; H063+$00002E74: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_00002E78:
; H063+$00002E78: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00002E7A:
; H063+$00002E7A: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002E7C:
; H063+$00002E7C: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L063_00002E82:
; H063+$00002E82: 24334000  move.l (a3, d4.w), d2
        move.l (a3, d4.w), d2
L063_00002E86:
; H063+$00002E86: b4ad000c  cmp.l $c(a5), d2
        cmp.l $c(a5), d2
L063_00002E8A:
; H063+$00002E8A: 6700001a  beq.w $2ea6
        beq.w H063+$2EA6
L063_00002E8E:
; H063+$00002E8E: 7400  moveq #$0, d2
        moveq #0, d2
L063_00002E90:
; H063+$00002E90: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L063_00002E96:
; H063+$00002E96: 382dfc02  move.w -$3fe(a5), d4
        move.w -$3fe(a5), d4
L063_00002E9A:
; H063+$00002E9A: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00002E9C:
; H063+$00002E9C: 64000008  bcc.w $2ea6
        bcc.w H063+$2EA6
L063_00002EA0:
; H063+$00002EA0: 526dfc02  addq.w #$1, -$3fe(a5)
        addq.w #$1, -$3fe(a5)
L063_00002EA4:
; H063+$00002EA4: 60be  bra.b $2e64
        bra.b H063+$2E64
L063_00002EA6:
; H063+$00002EA6: 342dfc02  move.w -$3fe(a5), d2
        move.w -$3fe(a5), d2
L063_00002EAA:
; H063+$00002EAA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002EAC:
; H063+$00002EAC: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_00002EAE:
; H063+$00002EAE: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L063_00002EB4:
; H063+$00002EB4: 7800  moveq #$0, d4
        moveq #0, d4
L063_00002EB6:
; H063+$00002EB6: 18332001  move.b $1(a3, d2.w), d4
        move.b $1(a3, d2.w), d4
L063_00002EBA:
; H063+$00002EBA: 02840000ffff  andi.l #$ffff, d4
        andi.l #$ffff, d4
L063_00002EC0:
; H063+$00002EC0: e24c  lsr.w #$1, d4
        lsr.w #$1, d4
L063_00002EC2:
; H063+$00002EC2: 3b44fc00  move.w d4, -$400(a5)
        move.w d4, -$400(a5)
L063_00002EC6:
; H063+$00002EC6: 3b7c0001fc02  move.w #$1, -$3fe(a5)
        move.w #$1, -$3fe(a5)
L063_00002ECC:
; H063+$00002ECC: 0c6d0028fc02  cmpi.w #$28, -$3fe(a5)
        cmpi.w #$28, -$3fe(a5)
L063_00002ED2:
; H063+$00002ED2: 6200002c  bhi.w $2f00
        bhi.w H063+$2F00
L063_00002ED6:
; H063+$00002ED6: 342dfc02  move.w -$3fe(a5), d2
        move.w -$3fe(a5), d2
L063_00002EDA:
; H063+$00002EDA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00002EDC:
; H063+$00002EDC: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_00002EDE:
; H063+$00002EDE: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L063_00002EE4:
; H063+$00002EE4: 382dfc02  move.w -$3fe(a5), d4
        move.w -$3fe(a5), d4
L063_00002EE8:
; H063+$00002EE8: 5344  subq.w #$1, d4
        subq.w #$1, d4
L063_00002EEA:
; H063+$00002EEA: e544  asl.w #$2, d4
        asl.w #$2, d4
L063_00002EEC:
; H063+$00002EEC: 45edfc04  lea.l -$3fc(a5), a2
        lea.l -$3fc(a5), a2
L063_00002EF0:
; H063+$00002EF0: 45f24000  lea.l (a2, d4.w), a2
        lea.l (a2, d4.w), a2
L063_00002EF4:
; H063+$00002EF4: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L063_00002EF8:
; H063+$00002EF8: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L063_00002EFA:
; H063+$00002EFA: 526dfc02  addq.w #$1, -$3fe(a5)
        addq.w #$1, -$3fe(a5)
L063_00002EFE:
; H063+$00002EFE: 64cc  bcc.b $2ecc
        bcc.b H063+$2ECC
L063_00002F00:
; H063+$00002F00: 302dfc00  move.w -$400(a5), d0
        move.w -$400(a5), d0
L063_00002F04:
; H063+$00002F04: 60000002  bra.w $2f08
        bra.w H063+$2F08
L063_00002F08:
; H063+$00002F08: 4e5d  unlk a5
        unlk a5
L063_00002F0A:
; H063+$00002F0A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002F0C:
; H063+$00002F0C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002F0E:
; H063+$00002F0E: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_00002F10:
; H063+$00002F10: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002F12 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$0322, H027+$23EA, H027+$3D12, H027+$0466, H062+$2430, H096+$3D0E e altri 28
; --------------------------------------------------------------------------
L063_00002F12:
; H063+$00002F12: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002F14:
; H063+$00002F14: 287ad1ea  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002F18:
; H063+$00002F18: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_00002F1C:
; H063+$00002F1C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00002F20:
; H063+$00002F20: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002F24:
; H063+$00002F24: 426b0004  clr.w $4(a3)
        clr.w $4(a3)
L063_00002F28:
; H063+$00002F28: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00002F2C:
; H063+$00002F2C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002F30:
; H063+$00002F30: 4213  clr.b (a3)
        clr.b (a3)
L063_00002F32:
; H063+$00002F32: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00002F36:
; H063+$00002F36: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002F3A:
; H063+$00002F3A: 422b0009  clr.b $9(a3)
        clr.b $9(a3)
L063_00002F3E:
; H063+$00002F3E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00002F42:
; H063+$00002F42: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002F46:
; H063+$00002F46: 422b0008  clr.b $8(a3)
        clr.b $8(a3)
L063_00002F4A:
; H063+$00002F4A: 7001  moveq #$1, d0
        moveq #1, d0
L063_00002F4C:
; H063+$00002F4C: 60000002  bra.w $2f50
        bra.w H063+$2F50
L063_00002F50:
; H063+$00002F50: 4e5d  unlk a5
        unlk a5
L063_00002F52:
; H063+$00002F52: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002F54:
; H063+$00002F54: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002F56:
; H063+$00002F56: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00002F58:
; H063+$00002F58: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002F5A [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H059+$0FAA, H097+$029E
; --------------------------------------------------------------------------
L063_00002F5A:
; H063+$00002F5A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002F5C:
; H063+$00002F5C: 287ad1a2  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002F60:
; H063+$00002F60: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_00002F64:
; H063+$00002F64: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00002F68:
; H063+$00002F68: 61a8  bsr.b $2f12
        bsr.b H063+$2F12
L063_00002F6A:
; H063+$00002F6A: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L063_00002F6E:
; H063+$00002F6E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00002F72:
; H063+$00002F72: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002F76:
; H063+$00002F76: 4a2b0012  tst.b $12(a3)
        tst.b $12(a3)
L063_00002F7A:
; H063+$00002F7A: 6600001c  bne.w $2f98
        bne.w H063+$2F98
L063_00002F7E:
; H063+$00002F7E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00002F82:
; H063+$00002F82: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_00002F86:
; H063+$00002F86: 177c00010009  move.b #$1, $9(a3)
        move.b #$1, $9(a3)
L063_00002F8C:
; H063+$00002F8C: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L063_00002F90:
; H063+$00002F90: 486c00b2  pea.l $b2(a4)
        pea.l $b2(a4)
L063_00002F94:
; H063+$00002F94: 6100edae  bsr.w $1d44
        bsr.w H063+$1D44
L063_00002F98:
; H063+$00002F98: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L063_00002F9C:
; H063+$00002F9C: 60000002  bra.w $2fa0
        bra.w H063+$2FA0
L063_00002FA0:
; H063+$00002FA0: 4e5d  unlk a5
        unlk a5
L063_00002FA2:
; H063+$00002FA2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00002FA4:
; H063+$00002FA4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00002FA6:
; H063+$00002FA6: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00002FA8:
; H063+$00002FA8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00002FAA [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H073+$130A.
;   - Richiama H073+$130A.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente); H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H085+$1DC8, H085+$1EE0, H085+$20F2, H085+$21A6, H085+$2656, H085+$26DC e altri 13
; --------------------------------------------------------------------------
L063_00002FAA:
; H063+$00002FAA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00002FAC:
; H063+$00002FAC: 287ad152  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00002FB0:
; H063+$00002FB0: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
; STATO: H005+$3368 = personaggio corrente
L063_00002FB4:
; H063+$00002FB4: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00002FBA:
; H063+$00002FBA: 4a2b00fe  tst.b $fe(a3)
        tst.b $fe(a3)
L063_00002FBE:
; H063+$00002FBE: 6600003a  bne.w $2ffa
        bne.w H063+$2FFA
; STATO: H005+$3368 = personaggio corrente
L063_00002FC2:
; H063+$00002FC2: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00002FC8:
; H063+$00002FC8: 4a2b0103  tst.b $103(a3)
        tst.b $103(a3)
L063_00002FCC:
; H063+$00002FCC: 6600002c  bne.w $2ffa
        bne.w H063+$2FFA
; STATO: H005+$3368 = personaggio corrente
L063_00002FD0:
; H063+$00002FD0: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00002FD6:
; H063+$00002FD6: 0c2b00090105  cmpi.b #$9, $105(a3)
        cmpi.b #$9, $105(a3)
L063_00002FDC:
; H063+$00002FDC: 6400001c  bcc.w $2ffa
        bcc.w H063+$2FFA
; STATO: H005+$3368 = personaggio corrente
L063_00002FE0:
; H063+$00002FE0: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00002FE6:
; H063+$00002FE6: 0c2b00080102  cmpi.b #$8, $102(a3)
        cmpi.b #$8, $102(a3)
L063_00002FEC:
; H063+$00002FEC: 6400000c  bcc.w $2ffa
        bcc.w H063+$2FFA
L063_00002FF0:
; H063+$00002FF0: 3b7c0006fff8  move.w #$6, -$8(a5)
        move.w #$6, -$8(a5)
L063_00002FF6:
; H063+$00002FF6: 600001e8  bra.w $31e0
        bra.w H063+$31E0
L063_00002FFA:
; H063+$00002FFA: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L063_00002FFE:
; H063+$00002FFE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00003000:
; H063+$00003000: e942  asl.w #$4, d2
        asl.w #$4, d2
L063_00003002:
; H063+$00003002: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L063_00003008:
; H063+$00003008: 7800  moveq #$0, d4
        moveq #0, d4
L063_0000300A:
; H063+$0000300A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L063_0000300E:
; H063+$0000300E: 600001ba  bra.w $31ca
        bra.w H063+$31CA
L063_00003012:
; H063+$00003012: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L063_00003014:
; H063+$00003014: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_0000301A:
; H063+$0000301A: 142b00fe  move.b $fe(a3), d2
        move.b $fe(a3), d2
L063_0000301E:
; H063+$0000301E: 7800  moveq #$0, d4
        moveq #0, d4
; STATO: H005+$3368 = personaggio corrente
L063_00003020:
; H063+$00003020: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00003026:
; H063+$00003026: 182b0106  move.b $106(a3), d4
        move.b $106(a3), d4
L063_0000302A:
; H063+$0000302A: 48e72800  movem.l d2/d4, -(a7)
        movem.l d2/d4, -(a7)
; STATO: H005+$3368 = personaggio corrente
L063_0000302E:
; H063+$0000302E: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H073+$130A (sub_H073_0000130A)
L063_00003034:
; H063+$00003034: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L063_0000303A:
; H063+$0000303A: 4cdf0014  movem.l (a7)+, d2/d4
        movem.l (a7)+, d2/d4
L063_0000303E:
; H063+$0000303E: 1c00  move.b d0, d6
        move.b d0, d6
L063_00003040:
; H063+$00003040: 024600ff  andi.w #$ff, d6
        andi.w #$ff, d6
L063_00003044:
; H063+$00003044: c8c6  mulu.w d6, d4
        mulu.w d6, d4
L063_00003046:
; H063+$00003046: d444  add.w d4, d2
        add.w d4, d2
L063_00003048:
; H063+$00003048: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_0000304C:
; H063+$0000304C: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L063_0000304E:
; H063+$0000304E: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00003054:
; H063+$00003054: 142b0105  move.b $105(a3), d2
        move.b $105(a3), d2
L063_00003058:
; H063+$00003058: 7800  moveq #$0, d4
        moveq #0, d4
; STATO: H005+$3368 = personaggio corrente
L063_0000305A:
; H063+$0000305A: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00003060:
; H063+$00003060: 182b010d  move.b $10d(a3), d4
        move.b $10d(a3), d4
L063_00003064:
; H063+$00003064: 48e72800  movem.l d2/d4, -(a7)
        movem.l d2/d4, -(a7)
; STATO: H005+$3368 = personaggio corrente
L063_00003068:
; H063+$00003068: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H073+$130A (sub_H073_0000130A)
L063_0000306E:
; H063+$0000306E: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L063_00003074:
; H063+$00003074: 4cdf0014  movem.l (a7)+, d2/d4
        movem.l (a7)+, d2/d4
L063_00003078:
; H063+$00003078: 1c00  move.b d0, d6
        move.b d0, d6
L063_0000307A:
; H063+$0000307A: 024600ff  andi.w #$ff, d6
        andi.w #$ff, d6
L063_0000307E:
; H063+$0000307E: c8c6  mulu.w d6, d4
        mulu.w d6, d4
L063_00003080:
; H063+$00003080: d444  add.w d4, d2
        add.w d4, d2
L063_00003082:
; H063+$00003082: 5142  subq.w #$8, d2
        subq.w #$8, d2
L063_00003084:
; H063+$00003084: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L063_00003088:
; H063+$00003088: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000308C:
; H063+$0000308C: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L063_00003090:
; H063+$00003090: 6f00000c  ble.w $309e
        ble.w H063+$309E
L063_00003094:
; H063+$00003094: 3b6dfffefff8  move.w -$2(a5), -$8(a5)
        move.w -$2(a5), -$8(a5)
L063_0000309A:
; H063+$0000309A: 60000008  bra.w $30a4
        bra.w H063+$30A4
L063_0000309E:
; H063+$0000309E: 3b6dfffcfff8  move.w -$4(a5), -$8(a5)
        move.w -$4(a5), -$8(a5)
L063_000030A4:
; H063+$000030A4: 4e75  rts 
        rts 
L063_000030A6:
; H063+$000030A6: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L063_000030AA:
; H063+$000030AA: 4e75  rts 
        rts 
L063_000030AC:
; H063+$000030AC: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L063_000030AE:
; H063+$000030AE: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_000030B4:
; H063+$000030B4: 142b0103  move.b $103(a3), d2
        move.b $103(a3), d2
L063_000030B8:
; H063+$000030B8: 7800  moveq #$0, d4
        moveq #0, d4
; STATO: H005+$3368 = personaggio corrente
L063_000030BA:
; H063+$000030BA: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_000030C0:
; H063+$000030C0: 182b010b  move.b $10b(a3), d4
        move.b $10b(a3), d4
L063_000030C4:
; H063+$000030C4: 48e72800  movem.l d2/d4, -(a7)
        movem.l d2/d4, -(a7)
; STATO: H005+$3368 = personaggio corrente
L063_000030C8:
; H063+$000030C8: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H073+$130A (sub_H073_0000130A)
L063_000030CE:
; H063+$000030CE: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L063_000030D4:
; H063+$000030D4: 4cdf0014  movem.l (a7)+, d2/d4
        movem.l (a7)+, d2/d4
L063_000030D8:
; H063+$000030D8: 1c00  move.b d0, d6
        move.b d0, d6
L063_000030DA:
; H063+$000030DA: 024600ff  andi.w #$ff, d6
        andi.w #$ff, d6
L063_000030DE:
; H063+$000030DE: c8c6  mulu.w d6, d4
        mulu.w d6, d4
L063_000030E0:
; H063+$000030E0: d444  add.w d4, d2
        add.w d4, d2
L063_000030E2:
; H063+$000030E2: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L063_000030E6:
; H063+$000030E6: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L063_000030E8:
; H063+$000030E8: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_000030EE:
; H063+$000030EE: 142b0102  move.b $102(a3), d2
        move.b $102(a3), d2
L063_000030F2:
; H063+$000030F2: 7800  moveq #$0, d4
        moveq #0, d4
; STATO: H005+$3368 = personaggio corrente
L063_000030F4:
; H063+$000030F4: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_000030FA:
; H063+$000030FA: 182b010a  move.b $10a(a3), d4
        move.b $10a(a3), d4
L063_000030FE:
; H063+$000030FE: 48e72800  movem.l d2/d4, -(a7)
        movem.l d2/d4, -(a7)
; STATO: H005+$3368 = personaggio corrente
L063_00003102:
; H063+$00003102: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H073+$130A (sub_H073_0000130A)
L063_00003108:
; H063+$00003108: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L063_0000310E:
; H063+$0000310E: 4cdf0014  movem.l (a7)+, d2/d4
        movem.l (a7)+, d2/d4
L063_00003112:
; H063+$00003112: 1c00  move.b d0, d6
        move.b d0, d6
L063_00003114:
; H063+$00003114: 024600ff  andi.w #$ff, d6
        andi.w #$ff, d6
L063_00003118:
; H063+$00003118: c8c6  mulu.w d6, d4
        mulu.w d6, d4
L063_0000311A:
; H063+$0000311A: d444  add.w d4, d2
        add.w d4, d2
L063_0000311C:
; H063+$0000311C: 5142  subq.w #$8, d2
        subq.w #$8, d2
L063_0000311E:
; H063+$0000311E: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
; STATO: H005+$3368 = personaggio corrente
L063_00003122:
; H063+$00003122: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00003128:
; H063+$00003128: 4a2b0103  tst.b $103(a3)
        tst.b $103(a3)
L063_0000312C:
; H063+$0000312C: 63000068  bls.w $3196
        bls.w H063+$3196
L063_00003130:
; H063+$00003130: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L063_00003132:
; H063+$00003132: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_00003138:
; H063+$00003138: 142b005f  move.b $5f(a3), d2
        move.b $5f(a3), d2
L063_0000313C:
; H063+$0000313C: 4a42  tst.w d2
        tst.w d2
L063_0000313E:
; H063+$0000313E: 63000056  bls.w $3196
        bls.w H063+$3196
L063_00003142:
; H063+$00003142: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3368 = personaggio corrente
L063_00003144:
; H063+$00003144: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L063_0000314A:
; H063+$0000314A: 142b005f  move.b $5f(a3), d2
        move.b $5f(a3), d2
L063_0000314E:
; H063+$0000314E: 064201f8  addi.w #$1f8, d2
        addi.w #$1f8, d2
L063_00003152:
; H063+$00003152: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L063_00003156:
; H063+$00003156: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_0000315A:
; H063+$0000315A: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_0000315C:
; H063+$0000315C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_00003162:
; H063+$00003162: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L063_00003166:
; H063+$00003166: 60000018  bra.w $3180
        bra.w H063+$3180
L063_0000316A:
; H063+$0000316A: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L063_0000316E:
; H063+$0000316E: 4e75  rts 
        rts 
L063_00003170:
; H063+$00003170: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L063_00003174:
; H063+$00003174: 4e75  rts 
        rts 
L063_00003176:
; H063+$00003176: 4e75  rts 
        rts 
; Preserved bytes H063+$00003178..$00003180; code/data not fully classified.
        dc.w $FFFC,$FFF0,$FFFC,$FFF6
L063_00003180:
; H063+$00003180: 47fafff8  lea.l $317a(pc), a3
        lea.l H063+$317A(pc), a3
L063_00003184:
; H063+$00003184: 0c440002  cmpi.w #$2, d4
        cmpi.w #$2, d4
L063_00003188:
; H063+$00003188: 6302  bls.b $318c
        bls.b H063+$318C
L063_0000318A:
; H063+$0000318A: 78ff  moveq #$ff, d4
        moveq #-1, d4
L063_0000318C:
; H063+$0000318C: e344  asl.w #$1, d4
        asl.w #$1, d4
L063_0000318E:
; H063+$0000318E: 38334000  move.w (a3, d4.w), d4
        move.w (a3, d4.w), d4
; DISPATCH: word relative a H063+$317A; indici 0..2, default -1.
L063_00003192:
; H063+$00003192: 4eb34000  jsr (a3, d4.w)
        jsr (a3, d4.w)
L063_00003196:
; H063+$00003196: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000319A:
; H063+$0000319A: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L063_0000319E:
; H063+$0000319E: 6f00000c  ble.w $31ac
        ble.w H063+$31AC
L063_000031A2:
; H063+$000031A2: 3b6dfffefff8  move.w -$2(a5), -$8(a5)
        move.w -$2(a5), -$8(a5)
L063_000031A8:
; H063+$000031A8: 60000008  bra.w $31b2
        bra.w H063+$31B2
L063_000031AC:
; H063+$000031AC: 3b6dfffcfff8  move.w -$4(a5), -$8(a5)
        move.w -$4(a5), -$8(a5)
L063_000031B2:
; H063+$000031B2: 4e75  rts 
        rts 
L063_000031B4:
; H063+$000031B4: 3b7c000cfff8  move.w #$c, -$8(a5)
        move.w #$c, -$8(a5)
L063_000031BA:
; H063+$000031BA: 4e75  rts 
        rts 
L063_000031BC:
; H063+$000031BC: 4e75  rts 
        rts 
; Preserved bytes H063+$000031BE..$000031CA; code/data not fully classified.
        dc.w $FFFC,$FE52,$FEE6,$FE52,$FEEC,$FFF4
L063_000031CA:
; H063+$000031CA: 47fafff4  lea.l $31c0(pc), a3
        lea.l H063+$31C0(pc), a3
L063_000031CE:
; H063+$000031CE: 0c440004  cmpi.w #$4, d4
        cmpi.w #$4, d4
L063_000031D2:
; H063+$000031D2: 6302  bls.b $31d6
        bls.b H063+$31D6
L063_000031D4:
; H063+$000031D4: 78ff  moveq #$ff, d4
        moveq #-1, d4
L063_000031D6:
; H063+$000031D6: e344  asl.w #$1, d4
        asl.w #$1, d4
L063_000031D8:
; H063+$000031D8: 38334000  move.w (a3, d4.w), d4
        move.w (a3, d4.w), d4
; DISPATCH: word relative a H063+$31C0; indici 0..4, default -1.
L063_000031DC:
; H063+$000031DC: 4eb34000  jsr (a3, d4.w)
        jsr (a3, d4.w)
L063_000031E0:
; H063+$000031E0: 4a39000024d9  tst.b $24d9.l
        tst.b (H005+$24D9).l
L063_000031E6:
; H063+$000031E6: 67000020  beq.w $3208
        beq.w H063+$3208
L063_000031EA:
; H063+$000031EA: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L063_000031EE:
; H063+$000031EE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_000031F0:
; H063+$000031F0: e942  asl.w #$4, d2
        asl.w #$4, d2
L063_000031F2:
; H063+$000031F2: 47f900000066  lea.l $66.l, a3
        lea.l (H005+$66).l, a3
L063_000031F8:
; H063+$000031F8: 0c3300042000  cmpi.b #$4, (a3, d2.w)
        cmpi.b #$4, (a3, d2.w)
L063_000031FE:
; H063+$000031FE: 67000008  beq.w $3208
        beq.w H063+$3208
L063_00003202:
; H063+$00003202: 3b7c0006fff8  move.w #$6, -$8(a5)
        move.w #$6, -$8(a5)
L063_00003208:
; H063+$00003208: 302dfff8  move.w -$8(a5), d0
        move.w -$8(a5), d0
L063_0000320C:
; H063+$0000320C: 60000002  bra.w $3210
        bra.w H063+$3210
L063_00003210:
; H063+$00003210: 4e5d  unlk a5
        unlk a5
L063_00003212:
; H063+$00003212: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00003214:
; H063+$00003214: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00003216:
; H063+$00003216: 548f  addq.l #$2, a7
        addq.l #$2, a7
L063_00003218:
; H063+$00003218: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_3384 [parziale]
; Scopo: Trampolino verso H063+$3384; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$3384.
; Chiamanti diretti: H033+$1328, H012+$32C4, H012+$294C, H057+$2F8E, H065+$1C38, H065+$12E6 e altri 20
; --------------------------------------------------------------------------
L063_0000321A:
; H063+$0000321A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000321C:
; H063+$0000321C: 287acee2  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00003220:
; H063+$00003220: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_00003224:
; H063+$00003224: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
L063_0000322C:
; H063+$0000322C: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_0000322E:
; H063+$0000322E: 143900003de3  move.b $3de3.l, d2
        move.b (H005+$3DE3).l, d2
L063_00003234:
; H063+$00003234: 6000014e  bra.w $3384
        bra.w H063+$3384
L063_00003238:
; H063+$00003238: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L063_0000323C:
; H063+$0000323C: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
L063_00003242:
; H063+$00003242: 4e75  rts 
        rts 
L063_00003244:
; H063+$00003244: 4a39000024c2  tst.b $24c2.l
        tst.b (H005+$24C2).l
L063_0000324A:
; H063+$0000324A: 67000008  beq.w $3254
        beq.w H063+$3254
; -> H044+$0330 (sub_H044_00000330)
L063_0000324E:
; H063+$0000324E: 4eb900000330  jsr $330.l
        jsr (H044+$330).l
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_00003254:
; H063+$00003254: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_0000325A:
; H063+$0000325A: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L063_0000325E:
; H063+$0000325E: 6600001e  bne.w $327e
        bne.w H063+$327E
L063_00003262:
; H063+$00003262: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_00003266:
; H063+$00003266: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_0000326A:
; H063+$0000326A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_0000326E:
; H063+$0000326E: 2f39000027c2  move.l $27c2.l, -(a7)
        move.l (H005+$27C2).l, -(a7)
; -> H042+$0254 (sub_H042_00000254)
L063_00003274:
; H063+$00003274: 4eb900000254  jsr $254.l
        jsr (H042+$254).l
L063_0000327A:
; H063+$0000327A: 6000002e  bra.w $32aa
        bra.w H063+$32AA
L063_0000327E:
; H063+$0000327E: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003280:
; H063+$00003280: 143900002488  move.b $2488.l, d2
        move.b (H005+$2488).l, d2
L063_00003286:
; H063+$00003286: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00003288:
; H063+$00003288: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000328A:
; H063+$0000328A: 143900002487  move.b $2487.l, d2
        move.b (H005+$2487).l, d2
L063_00003290:
; H063+$00003290: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; FLUSSO: Chiama Load_HeadBody (H042+$0D70).
L063_00003292:
; H063+$00003292: 4eb900000d70  jsr $d70.l
        jsr (H042+$D70).l
L063_00003298:
; H063+$00003298: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_0000329C:
; H063+$0000329C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_000032A0:
; H063+$000032A0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H042+$0ED2 (sub_H042_00000ED2)
L063_000032A4:
; H063+$000032A4: 4eb900000ed2  jsr $ed2.l
        jsr (H042+$ED2).l
; STATO: H005+$3368 = personaggio corrente
L063_000032AA:
; H063+$000032AA: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L063_000032B0:
; H063+$000032B0: 6100dace  bsr.w $d80
        bsr.w H063+$D80
L063_000032B4:
; H063+$000032B4: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L063_000032BA:
; H063+$000032BA: 4e75  rts 
        rts 
; -> H044+$0330 (sub_H044_00000330)
L063_000032BC:
; H063+$000032BC: 4eb900000330  jsr $330.l
        jsr (H044+$330).l
L063_000032C2:
; H063+$000032C2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_000032C6:
; H063+$000032C6: 486c00bb  pea.l $bb(a4)
        pea.l $bb(a4)
L063_000032CA:
; H063+$000032CA: 3f3c003b  move.w #$3b, -(a7)
        move.w #$3b, -(a7)
L063_000032CE:
; H063+$000032CE: 4267  clr.w -(a7)
        clr.w -(a7)
L063_000032D0:
; H063+$000032D0: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLUSSO: Chiama Load_Sequence (H042+$0406).
L063_000032D6:
; H063+$000032D6: 4eb900000406  jsr $406.l
        jsr (H042+$406).l
; STATO: H005+$3368 = personaggio corrente
L063_000032DC:
; H063+$000032DC: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L063_000032E2:
; H063+$000032E2: 6100da9c  bsr.w $d80
        bsr.w H063+$D80
L063_000032E6:
; H063+$000032E6: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L063_000032EC:
; H063+$000032EC: 4e75  rts 
        rts 
; -> H044+$0330 (sub_H044_00000330)
L063_000032EE:
; H063+$000032EE: 4eb900000330  jsr $330.l
        jsr (H044+$330).l
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_000032F4:
; H063+$000032F4: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_000032FA:
; H063+$000032FA: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L063_000032FE:
; H063+$000032FE: 66000008  bne.w $3308
        bne.w H063+$3308
; -> H060+$0018 (sub_H060_00000018)
L063_00003302:
; H063+$00003302: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
; STATO: H005+$3368 = personaggio corrente
L063_00003308:
; H063+$00003308: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L063_0000330E:
; H063+$0000330E: 6100da70  bsr.w $d80
        bsr.w H063+$D80
L063_00003312:
; H063+$00003312: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L063_00003318:
; H063+$00003318: 4239000024b2  clr.b $24b2.l
        clr.b (H005+$24B2).l
L063_0000331E:
; H063+$0000331E: 4e75  rts 
        rts 
L063_00003320:
; H063+$00003320: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003322:
; H063+$00003322: 143900002486  move.b $2486.l, d2
        move.b (H005+$2486).l, d2
L063_00003328:
; H063+$00003328: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L063_0000332C:
; H063+$0000332C: 67000016  beq.w $3344
        beq.w H063+$3344
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_00003330:
; H063+$00003330: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_00003336:
; H063+$00003336: 4a6b0270  tst.w $270(a3)
        tst.w $270(a3)
L063_0000333A:
; H063+$0000333A: 66000008  bne.w $3344
        bne.w H063+$3344
; -> H060+$0018 (sub_H060_00000018)
L063_0000333E:
; H063+$0000333E: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
L063_00003344:
; H063+$00003344: 4e75  rts 
        rts 
; -> H044+$0330 (sub_H044_00000330)
L063_00003346:
; H063+$00003346: 4eb900000330  jsr $330.l
        jsr (H044+$330).l
L063_0000334C:
; H063+$0000334C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L063_00003350:
; H063+$00003350: 486c00bf  pea.l $bf(a4)
        pea.l $bf(a4)
L063_00003354:
; H063+$00003354: 3f3c003c  move.w #$3c, -(a7)
        move.w #$3c, -(a7)
L063_00003358:
; H063+$00003358: 4267  clr.w -(a7)
        clr.w -(a7)
L063_0000335A:
; H063+$0000335A: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLUSSO: Chiama Load_Sequence (H042+$0406).
L063_00003360:
; H063+$00003360: 4eb900000406  jsr $406.l
        jsr (H042+$406).l
; STATO: H005+$3368 = personaggio corrente
L063_00003366:
; H063+$00003366: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L063_0000336C:
; H063+$0000336C: 6100da12  bsr.w $d80
        bsr.w H063+$D80
L063_00003370:
; H063+$00003370: 4e75  rts 
        rts 
L063_00003372:
; H063+$00003372: 4e75  rts 
        rts 
; Preserved bytes H063+$00003374..$00003384; code/data not fully classified.
        dc.w $FFFC,$FEC2,$FECE,$FF46,$FFAA,$FF78,$FFFC,$FFD0
L063_00003384:
; H063+$00003384: 47fafff0  lea.l $3376(pc), a3
        lea.l H063+$3376(pc), a3
L063_00003388:
; H063+$00003388: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L063_0000338C:
; H063+$0000338C: 6302  bls.b $3390
        bls.b H063+$3390
L063_0000338E:
; H063+$0000338E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00003390:
; H063+$00003390: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00003392:
; H063+$00003392: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$3376; indici 0..6, default -1.
L063_00003396:
; H063+$00003396: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_0000339A:
; H063+$0000339A: 4e5d  unlk a5
        unlk a5
L063_0000339C:
; H063+$0000339C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_0000339E:
; H063+$0000339E: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_3652 [parziale]
; Scopo: Trampolino verso H063+$3652; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$3652.
; Chiamanti diretti: H063+$32E6, H063+$3312, H063+$32B4, H057+$31E6, H012+$2444, H012+$246C e altri 15
; --------------------------------------------------------------------------
L063_000033A0:
; H063+$000033A0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000033A2:
; H063+$000033A2: 287acd5c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000033A6:
; H063+$000033A6: 4e55ff9e  link.w a5, #$ff9e
        link.w a5, #$ff9e
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_000033AA:
; H063+$000033AA: 0c39000300003de3  cmpi.b #$3, $3de3.l
        cmpi.b #$3, (H005+$3DE3).l
L063_000033B2:
; H063+$000033B2: 66000006  bne.w $33ba
        bne.w H063+$33BA
L063_000033B6:
; H063+$000033B6: 6000029a  bra.w $3652
        bra.w H063+$3652
L063_000033BA:
; H063+$000033BA: 47ec00c3  lea.l $c3(a4), a3
        lea.l $c3(a4), a3
L063_000033BE:
; H063+$000033BE: 45edffca  lea.l -$36(a5), a2
        lea.l -$36(a5), a2
L063_000033C2:
; H063+$000033C2: 7428  moveq #$28, d2
        moveq #40, d2
L063_000033C4:
; H063+$000033C4: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_000033C6:
; H063+$000033C6: 57cafffc  dbeq d2, $33c4
        dbeq d2, H063+$33C4
; STATO: H005+$281C = inizio del blocco coordinate/vista
L063_000033CA:
; H063+$000033CA: 3b790000281cfffe  move.w $281c.l, -$2(a5)
        move.w (H005+$281C).l, -$2(a5)
L063_000033D2:
; H063+$000033D2: 3b790000281efffc  move.w $281e.l, -$4(a5)
        move.w (H005+$281E).l, -$4(a5)
L063_000033DA:
; H063+$000033DA: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_000033DE:
; H063+$000033DE: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L063_000033E2:
; H063+$000033E2: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_000033E4:
; H063+$000033E4: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_000033EA:
; H063+$000033EA: 342b0192  move.w $192(a3), d2
        move.w $192(a3), d2
L063_000033EE:
; H063+$000033EE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_000033F0:
; H063+$000033F0: 4227  clr.b -(a7)
        clr.b -(a7)
L063_000033F2:
; H063+$000033F2: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_000033F6:
; H063+$000033F6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_000033FA:
; H063+$000033FA: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_000033FE:
; H063+$000033FE: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L063_00003404:
; H063+$00003404: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00003408:
; H063+$00003408: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_0000340C:
; H063+$0000340C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_00003412:
; H063+$00003412: 342b0190  move.w $190(a3), d2
        move.w $190(a3), d2
L063_00003416:
; H063+$00003416: c4fc000a  mulu.w #$a, d2
        mulu.w #$a, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_0000341A:
; H063+$0000341A: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_00003420:
; H063+$00003420: d46b018e  add.w $18e(a3), d2
        add.w $18e(a3), d2
L063_00003424:
; H063+$00003424: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L063_0000342A:
; H063+$0000342A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_0000342C:
; H063+$0000342C: 4227  clr.b -(a7)
        clr.b -(a7)
L063_0000342E:
; H063+$0000342E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00003432:
; H063+$00003432: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00003436:
; H063+$00003436: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_0000343A:
; H063+$0000343A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_00003440:
; H063+$00003440: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_00003446:
; H063+$00003446: 4a6b01f6  tst.w $1f6(a3)
        tst.w $1f6(a3)
L063_0000344A:
; H063+$0000344A: 6600008c  bne.w $34d8
        bne.w H063+$34D8
L063_0000344E:
; H063+$0000344E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003452:
; H063+$00003452: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_00003456:
; H063+$00003456: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003458:
; H063+$00003458: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_0000345C:
; H063+$0000345C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_0000345E:
; H063+$0000345E: 4227  clr.b -(a7)
        clr.b -(a7)
L063_00003460:
; H063+$00003460: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00003464:
; H063+$00003464: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00003468:
; H063+$00003468: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_0000346C:
; H063+$0000346C: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L063_00003472:
; H063+$00003472: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003476:
; H063+$00003476: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_0000347A:
; H063+$0000347A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_0000347E:
; H063+$0000347E: 486c00c5  pea.l $c5(a4)
        pea.l $c5(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00003482:
; H063+$00003482: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00003488:
; H063+$00003488: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_0000348C:
; H063+$0000348C: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
L063_00003490:
; H063+$00003490: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003492:
; H063+$00003492: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L063_00003496:
; H063+$00003496: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L063_00003498:
; H063+$00003498: 4227  clr.b -(a7)
        clr.b -(a7)
L063_0000349A:
; H063+$0000349A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_0000349E:
; H063+$0000349E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_000034A2:
; H063+$000034A2: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L063_000034A6:
; H063+$000034A6: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L063_000034AC:
; H063+$000034AC: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_000034B0:
; H063+$000034B0: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_000034B4:
; H063+$000034B4: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_000034B8:
; H063+$000034B8: 486dffa0  pea.l -$60(a5)
        pea.l -$60(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L063_000034BC:
; H063+$000034BC: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_000034C2:
; H063+$000034C2: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_000034C6:
; H063+$000034C6: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_000034CA:
; H063+$000034CA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_000034CE:
; H063+$000034CE: 486c00c7  pea.l $c7(a4)
        pea.l $c7(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_000034D2:
; H063+$000034D2: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_000034D8:
; H063+$000034D8: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_000034DE:
; H063+$000034DE: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L063_000034E2:
; H063+$000034E2: 67000020  beq.w $3504
        beq.w H063+$3504
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_000034E6:
; H063+$000034E6: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_000034EC:
; H063+$000034EC: 342b03fe  move.w $3fe(a3), d2
        move.w $3fe(a3), d2
L063_000034F0:
; H063+$000034F0: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_000034F2:
; H063+$000034F2: 7800  moveq #$0, d4
        moveq #0, d4
L063_000034F4:
; H063+$000034F4: 183900002820  move.b $2820.l, d4
        move.b (H005+$2820).l, d4
L063_000034FA:
; H063+$000034FA: d444  add.w d4, d2
        add.w d4, d2
L063_000034FC:
; H063+$000034FC: 3b42ff9e  move.w d2, -$62(a5)
        move.w d2, -$62(a5)
L063_00003500:
; H063+$00003500: 60000018  bra.w $351a
        bra.w H063+$351A
L063_00003504:
; H063+$00003504: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003506:
; H063+$00003506: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L063_0000350C:
; H063+$0000350C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L063_00003512:
; H063+$00003512: d46b03fe  add.w $3fe(a3), d2
        add.w $3fe(a3), d2
L063_00003516:
; H063+$00003516: 3b42ff9e  move.w d2, -$62(a5)
        move.w d2, -$62(a5)
L063_0000351A:
; H063+$0000351A: 0c6d0008ff9e  cmpi.w #$8, -$62(a5)
        cmpi.w #$8, -$62(a5)
L063_00003520:
; H063+$00003520: 65000006  bcs.w $3528
        bcs.w H063+$3528
L063_00003524:
; H063+$00003524: 516dff9e  subq.w #$8, -$62(a5)
        subq.w #$8, -$62(a5)
L063_00003528:
; H063+$00003528: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_0000352C:
; H063+$0000352C: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_00003530:
; H063+$00003530: 342dff9e  move.w -$62(a5), d2
        move.w -$62(a5), d2
L063_00003534:
; H063+$00003534: e542  asl.w #$2, d2
        asl.w #$2, d2
L063_00003536:
; H063+$00003536: 47f900003db2  lea.l $3db2.l, a3
        lea.l (H005+$3DB2).l, a3
L063_0000353C:
; H063+$0000353C: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00003540:
; H063+$00003540: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00003544:
; H063+$00003544: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_0000354A:
; H063+$0000354A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_0000354E:
; H063+$0000354E: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_00003552:
; H063+$00003552: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00003556:
; H063+$00003556: 486c00c9  pea.l $c9(a4)
        pea.l $c9(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_0000355A:
; H063+$0000355A: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00003560:
; H063+$00003560: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003564:
; H063+$00003564: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_00003568:
; H063+$00003568: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_0000356C:
; H063+$0000356C: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00003570:
; H063+$00003570: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00003576:
; H063+$00003576: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_0000357A:
; H063+$0000357A: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_0000357E:
; H063+$0000357E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00003582:
; H063+$00003582: 486c00cb  pea.l $cb(a4)
        pea.l $cb(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00003586:
; H063+$00003586: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_0000358C:
; H063+$0000358C: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003590:
; H063+$00003590: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_00003594:
; H063+$00003594: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L063_00003598:
; H063+$00003598: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L063_0000359C:
; H063+$0000359C: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_000035A2:
; H063+$000035A2: 4a39000024d2  tst.b $24d2.l
        tst.b (H005+$24D2).l
L063_000035A8:
; H063+$000035A8: 67000018  beq.w $35c2
        beq.w H063+$35C2
L063_000035AC:
; H063+$000035AC: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_000035B0:
; H063+$000035B0: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_000035B4:
; H063+$000035B4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_000035B8:
; H063+$000035B8: 486c00cd  pea.l $cd(a4)
        pea.l $cd(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_000035BC:
; H063+$000035BC: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_000035C2:
; H063+$000035C2: 0c39000200003de3  cmpi.b #$2, $3de3.l
        cmpi.b #$2, (H005+$3DE3).l
L063_000035CA:
; H063+$000035CA: 6600001c  bne.w $35e8
        bne.w H063+$35E8
L063_000035CE:
; H063+$000035CE: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_000035D2:
; H063+$000035D2: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_000035D6:
; H063+$000035D6: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L063_000035DA:
; H063+$000035DA: 486c00cf  pea.l $cf(a4)
        pea.l $cf(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_000035DE:
; H063+$000035DE: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_000035E4:
; H063+$000035E4: 6000003a  bra.w $3620
        bra.w H063+$3620
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L063_000035E8:
; H063+$000035E8: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L063_000035EE:
; H063+$000035EE: 342b0594  move.w $594(a3), d2
        move.w $594(a3), d2
L063_000035F2:
; H063+$000035F2: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_000035F4:
; H063+$000035F4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_000035F8:
; H063+$000035F8: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_000035FE:
; H063+$000035FE: 1400  move.b d0, d2
        move.b d0, d2
L063_00003600:
; H063+$00003600: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_00003604:
; H063+$00003604: 4a42  tst.w d2
        tst.w d2
L063_00003606:
; H063+$00003606: 63000018  bls.w $3620
        bls.w H063+$3620
L063_0000360A:
; H063+$0000360A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_0000360E:
; H063+$0000360E: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L063_00003612:
; H063+$00003612: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L063_00003616:
; H063+$00003616: 486c00d8  pea.l $d8(a4)
        pea.l $d8(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_0000361A:
; H063+$0000361A: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00003620:
; H063+$00003620: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L063_00003624:
; H063+$00003624: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00003628:
; H063+$00003628: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L063_0000362C:
; H063+$0000362C: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L063_00003630:
; H063+$00003630: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L063_00003636:
; H063+$00003636: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L063_0000363A:
; H063+$0000363A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_0000363E:
; H063+$0000363E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00003642:
; H063+$00003642: 4267  clr.w -(a7)
        clr.w -(a7)
L063_00003644:
; H063+$00003644: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003648:
; H063+$00003648: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L063_0000364C:
; H063+$0000364C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L063_00003652:
; H063+$00003652: 4e5d  unlk a5
        unlk a5
L063_00003654:
; H063+$00003654: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00003656:
; H063+$00003656: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00003658 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H044+$0586, H048+$0DF2.
;   - Richiama H044+$0586.
;   - Richiama H048+$0DF2.
; Chiamanti diretti: H095+$25D6, H065+$3046, H059+$1228, H059+$11DA, H096+$3182
; --------------------------------------------------------------------------
L063_00003658:
; H063+$00003658: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000365A:
; H063+$0000365A: 287acaa4  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000365E:
; H063+$0000365E: 4e550000  link.w a5, #$0
        link.w a5, #$0
; -> H044+$0586 (sub_H044_00000586)
L063_00003662:
; H063+$00003662: 4eb900000586  jsr $586.l
        jsr (H044+$586).l
L063_00003668:
; H063+$00003668: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_0000366E:
; H063+$0000366E: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L063_00003672:
; H063+$00003672: 5642  addq.w #$3, d2
        addq.w #$3, d2
L063_00003674:
; H063+$00003674: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00003676:
; H063+$00003676: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L063_0000367C:
; H063+$0000367C: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L063_00003680:
; H063+$00003680: 5642  addq.w #$3, d2
        addq.w #$3, d2
L063_00003682:
; H063+$00003682: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L063_00003684:
; H063+$00003684: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L063_00003688:
; H063+$00003688: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H048+$0DF2 (sub_H048_00000DF2)
L063_0000368C:
; H063+$0000368C: 4eb900000df2  jsr $df2.l
        jsr (H048+$DF2).l
L063_00003692:
; H063+$00003692: 4e5d  unlk a5
        unlk a5
L063_00003694:
; H063+$00003694: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00003696:
; H063+$00003696: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00003698 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H096+$3B2E, H063+$3742, H096+$3D2E, H096+$4178, H096+$1202, H096+$253C e altri 6
; --------------------------------------------------------------------------
L063_00003698:
; H063+$00003698: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_0000369A:
; H063+$0000369A: 287aca64  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000369E:
; H063+$0000369E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_000036A2:
; H063+$000036A2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000036A6:
; H063+$000036A6: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L063_000036AA:
; H063+$000036AA: 67000032  beq.w $36de
        beq.w H063+$36DE
L063_000036AE:
; H063+$000036AE: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_000036B2:
; H063+$000036B2: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L063_000036B6:
; H063+$000036B6: 7400  moveq #$0, d2
        moveq #0, d2
L063_000036B8:
; H063+$000036B8: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_000036BC:
; H063+$000036BC: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_000036C0:
; H063+$000036C0: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_000036C6:
; H063+$000036C6: 7800  moveq #$0, d4
        moveq #0, d4
L063_000036C8:
; H063+$000036C8: 1833280e  move.b $e(a3, d2.l), d4
        move.b $e(a3, d2.l), d4
L063_000036CC:
; H063+$000036CC: 0c440001  cmpi.w #$1, d4
        cmpi.w #$1, d4
L063_000036D0:
; H063+$000036D0: 6300000c  bls.w $36de
        bls.w H063+$36DE
L063_000036D4:
; H063+$000036D4: 7001  moveq #$1, d0
        moveq #1, d0
L063_000036D6:
; H063+$000036D6: 6000000c  bra.w $36e4
        bra.w H063+$36E4
; Preserved bytes H063+$000036DA..$000036DE; code/data not fully classified.
        dc.w $6000,$0008
L063_000036DE:
; H063+$000036DE: 7000  moveq #$0, d0
        moveq #0, d0
L063_000036E0:
; H063+$000036E0: 60000002  bra.w $36e4
        bra.w H063+$36E4
L063_000036E4:
; H063+$000036E4: 4e5d  unlk a5
        unlk a5
L063_000036E6:
; H063+$000036E6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000036E8:
; H063+$000036E8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000036EA:
; H063+$000036EA: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_000036EC:
; H063+$000036EC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000036EE [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H096+$2368
; --------------------------------------------------------------------------
L063_000036EE:
; H063+$000036EE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000036F0:
; H063+$000036F0: 287aca0e  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000036F4:
; H063+$000036F4: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_000036F8:
; H063+$000036F8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000036FC:
; H063+$000036FC: 4aab0154  tst.l $154(a3)
        tst.l $154(a3)
L063_00003700:
; H063+$00003700: 67000022  beq.w $3724
        beq.w H063+$3724
L063_00003704:
; H063+$00003704: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00003708:
; H063+$00003708: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L063_0000370C:
; H063+$0000370C: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000370E:
; H063+$0000370E: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00003712:
; H063+$00003712: 0c420043  cmpi.w #$43, d2
        cmpi.w #$43, d2
L063_00003716:
; H063+$00003716: 6600000c  bne.w $3724
        bne.w H063+$3724
L063_0000371A:
; H063+$0000371A: 7001  moveq #$1, d0
        moveq #1, d0
L063_0000371C:
; H063+$0000371C: 6000000c  bra.w $372a
        bra.w H063+$372A
; Preserved bytes H063+$00003720..$00003724; code/data not fully classified.
        dc.w $6000,$0008
L063_00003724:
; H063+$00003724: 7000  moveq #$0, d0
        moveq #0, d0
L063_00003726:
; H063+$00003726: 60000002  bra.w $372a
        bra.w H063+$372A
L063_0000372A:
; H063+$0000372A: 4e5d  unlk a5
        unlk a5
L063_0000372C:
; H063+$0000372C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_0000372E:
; H063+$0000372E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00003730:
; H063+$00003730: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_00003732:
; H063+$00003732: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00003734 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H029+$0354.
;   - Richiama H029+$0354.
; Chiamanti diretti: H096+$3B82, H096+$3D56, H096+$41B6, H096+$23B6, H059+$0ED6, H059+$0690 e altri 3
; --------------------------------------------------------------------------
L063_00003734:
; H063+$00003734: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00003736:
; H063+$00003736: 287ac9c8  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_0000373A:
; H063+$0000373A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L063_0000373E:
; H063+$0000373E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L063_00003742:
; H063+$00003742: 6100ff54  bsr.w $3698
        bsr.w H063+$3698
L063_00003746:
; H063+$00003746: 1400  move.b d0, d2
        move.b d0, d2
L063_00003748:
; H063+$00003748: 4a02  tst.b d2
        tst.b d2
L063_0000374A:
; H063+$0000374A: 67000036  beq.w $3782
        beq.w H063+$3782
L063_0000374E:
; H063+$0000374E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00003752:
; H063+$00003752: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L063_00003756:
; H063+$00003756: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003758:
; H063+$00003758: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_0000375C:
; H063+$0000375C: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_00003760:
; H063+$00003760: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_00003766:
; H063+$00003766: 1f332810  move.b $10(a3, d2.l), -(a7)
        move.b $10(a3, d2.l), -(a7)
L063_0000376A:
; H063+$0000376A: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_0000376E:
; H063+$0000376E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_00003774:
; H063+$00003774: 1400  move.b d0, d2
        move.b d0, d2
L063_00003776:
; H063+$00003776: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L063_0000377A:
; H063+$0000377A: 0c420014  cmpi.w #$14, d2
        cmpi.w #$14, d2
L063_0000377E:
; H063+$0000377E: 67000018  beq.w $3798
        beq.w H063+$3798
L063_00003782:
; H063+$00003782: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00003786:
; H063+$00003786: 266a0154  movea.l $154(a2), a3
        movea.l $154(a2), a3
L063_0000378A:
; H063+$0000378A: 7400  moveq #$0, d2
        moveq #0, d2
L063_0000378C:
; H063+$0000378C: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_00003790:
; H063+$00003790: 0c420043  cmpi.w #$43, d2
        cmpi.w #$43, d2
L063_00003794:
; H063+$00003794: 6600000c  bne.w $37a2
        bne.w H063+$37A2
L063_00003798:
; H063+$00003798: 7001  moveq #$1, d0
        moveq #1, d0
L063_0000379A:
; H063+$0000379A: 6000000c  bra.w $37a8
        bra.w H063+$37A8
; Preserved bytes H063+$0000379E..$000037A2; code/data not fully classified.
        dc.w $6000,$0008
L063_000037A2:
; H063+$000037A2: 7000  moveq #$0, d0
        moveq #0, d0
L063_000037A4:
; H063+$000037A4: 60000002  bra.w $37a8
        bra.w H063+$37A8
L063_000037A8:
; H063+$000037A8: 4e5d  unlk a5
        unlk a5
L063_000037AA:
; H063+$000037AA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000037AC:
; H063+$000037AC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000037AE:
; H063+$000037AE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L063_000037B0:
; H063+$000037B0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_000037B2 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H029+$0354.
;   - Richiama H029+$0354.
; Chiamanti diretti: H027+$1800, H096+$3B5A, H096+$3D44, H096+$418E, H096+$1218, H097+$1CCC
; --------------------------------------------------------------------------
L063_000037B2:
; H063+$000037B2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_000037B4:
; H063+$000037B4: 287ac94a  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_000037B8:
; H063+$000037B8: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L063_000037BC:
; H063+$000037BC: 422dfff9  clr.b -$7(a5)
        clr.b -$7(a5)
L063_000037C0:
; H063+$000037C0: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_000037C4:
; H063+$000037C4: 2b6b0154fffc  move.l $154(a3), -$4(a5)
        move.l $154(a3), -$4(a5)
L063_000037CA:
; H063+$000037CA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_000037CE:
; H063+$000037CE: 4293  clr.l (a3)
        clr.l (a3)
L063_000037D0:
; H063+$000037D0: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L063_000037D4:
; H063+$000037D4: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_000037D8:
; H063+$000037D8: 670000a0  beq.w $387a
        beq.w H063+$387A
L063_000037DC:
; H063+$000037DC: 7400  moveq #$0, d2
        moveq #0, d2
L063_000037DE:
; H063+$000037DE: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_000037E2:
; H063+$000037E2: 142b0030  move.b $30(a3), d2
        move.b $30(a3), d2
L063_000037E6:
; H063+$000037E6: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L063_000037EA:
; H063+$000037EA: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L063_000037F0:
; H063+$000037F0: 7800  moveq #$0, d4
        moveq #0, d4
L063_000037F2:
; H063+$000037F2: 18332810  move.b $10(a3, d2.l), d4
        move.b $10(a3, d2.l), d4
L063_000037F6:
; H063+$000037F6: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L063_000037FA:
; H063+$000037FA: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_000037FE:
; H063+$000037FE: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_00003800:
; H063+$00003800: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_00003804:
; H063+$00003804: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_0000380A:
; H063+$0000380A: 1400  move.b d0, d2
        move.b d0, d2
L063_0000380C:
; H063+$0000380C: 4a02  tst.b d2
        tst.b d2
L063_0000380E:
; H063+$0000380E: 6700000a  beq.w $381a
        beq.w H063+$381A
L063_00003812:
; H063+$00003812: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00003816:
; H063+$00003816: 26adfffc  move.l -$4(a5), (a3)
        move.l -$4(a5), (a3)
L063_0000381A:
; H063+$0000381A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_0000381E:
; H063+$0000381E: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_00003820:
; H063+$00003820: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_00003824:
; H063+$00003824: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_0000382A:
; H063+$0000382A: 1400  move.b d0, d2
        move.b d0, d2
L063_0000382C:
; H063+$0000382C: 4a02  tst.b d2
        tst.b d2
L063_0000382E:
; H063+$0000382E: 6700004a  beq.w $387a
        beq.w H063+$387A
L063_00003832:
; H063+$00003832: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_00003836:
; H063+$00003836: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_00003838:
; H063+$00003838: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_0000383C:
; H063+$0000383C: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_00003842:
; H063+$00003842: 1400  move.b d0, d2
        move.b d0, d2
L063_00003844:
; H063+$00003844: 4a02  tst.b d2
        tst.b d2
L063_00003846:
; H063+$00003846: 6700000e  beq.w $3856
        beq.w H063+$3856
L063_0000384A:
; H063+$0000384A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_0000384E:
; H063+$0000384E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00003852:
; H063+$00003852: 24ab0180  move.l $180(a3), (a2)
        move.l $180(a3), (a2)
L063_00003856:
; H063+$00003856: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L063_0000385A:
; H063+$0000385A: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L063_0000385C:
; H063+$0000385C: 3f3c0080  move.w #$80, -(a7)
        move.w #$80, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L063_00003860:
; H063+$00003860: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L063_00003866:
; H063+$00003866: 1400  move.b d0, d2
        move.b d0, d2
L063_00003868:
; H063+$00003868: 4a02  tst.b d2
        tst.b d2
L063_0000386A:
; H063+$0000386A: 6700000e  beq.w $387a
        beq.w H063+$387A
L063_0000386E:
; H063+$0000386E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L063_00003872:
; H063+$00003872: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L063_00003876:
; H063+$00003876: 24ab0184  move.l $184(a3), (a2)
        move.l $184(a3), (a2)
L063_0000387A:
; H063+$0000387A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_0000387E:
; H063+$0000387E: 4a93  tst.l (a3)
        tst.l (a3)
L063_00003880:
; H063+$00003880: 6600000c  bne.w $388e
        bne.w H063+$388E
L063_00003884:
; H063+$00003884: 0c6d000afffa  cmpi.w #$a, -$6(a5)
        cmpi.w #$a, -$6(a5)
L063_0000388A:
; H063+$0000388A: 66000008  bne.w $3894
        bne.w H063+$3894
L063_0000388E:
; H063+$0000388E: 1b7c0001fff9  move.b #$1, -$7(a5)
        move.b #$1, -$7(a5)
L063_00003894:
; H063+$00003894: 102dfff9  move.b -$7(a5), d0
        move.b -$7(a5), d0
L063_00003898:
; H063+$00003898: 60000002  bra.w $389c
        bra.w H063+$389C
L063_0000389C:
; H063+$0000389C: 4e5d  unlk a5
        unlk a5
L063_0000389E:
; H063+$0000389E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_000038A0:
; H063+$000038A0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_000038A2:
; H063+$000038A2: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_000038A4:
; H063+$000038A4: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H063+$000038A6..$00003980; code/data not fully classified.
        dc.w $2F0C,$287A,$C856,$4E55,$FFFC,$7448,$2F02,$2F3C
        dc.w $0001,$0000,$4EB9
        dc.l H003+$00000068
        dc.w $2B40,$FFFC,$342D,$0028,$266D,$FFFC,$1742,$0030
        dc.w $342D,$0026,$266D,$FFFC,$1742,$0032,$342D,$0024
        dc.w $266D,$FFFC,$1742,$0033,$342D,$0022,$266D,$FFFC
        dc.w $1742,$0034,$266D,$FFFC,$376D,$0020,$0036,$266D
        dc.w $FFFC,$376D,$001E,$0038,$266D,$FFFC,$176D,$001C
        dc.w $003A,$342D,$001A,$266D,$FFFC,$1742,$003B,$266D
        dc.w $FFFC,$176D,$0018,$003C,$266D,$FFFC,$376D,$0016
        dc.w $003E,$342D,$0014,$266D,$FFFC,$1742,$0040,$266D
        dc.w $FFFC,$376D,$0012,$0042,$342D,$0010,$266D,$FFFC
        dc.w $1742,$0044,$342D,$000E,$266D,$FFFC,$1742,$0045
        dc.w $342D,$000C,$266D,$FFFC,$1742,$0046,$202D,$FFFC
        dc.w $6000,$0002,$4E5D,$285F,$205F,$4FEF,$001E,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00003980 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; opera su H005+$3364 (testa della lista del party).
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H059+$16A2, H059+$0F12, H097+$1916, H059+$106E
; --------------------------------------------------------------------------
L063_00003980:
; H063+$00003980: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00003982:
; H063+$00003982: 287ac77c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00003986:
; H063+$00003986: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L063_0000398A:
; H063+$0000398A: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
; STATO: H005+$3364 = testa della lista del party
L063_0000398E:
; H063+$0000398E: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L063_00003996:
; H063+$00003996: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L063_0000399A:
; H063+$0000399A: 67000078  beq.w $3a14
        beq.w H063+$3A14
L063_0000399E:
; H063+$0000399E: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L063_000039A2:
; H063+$000039A2: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_000039A6:
; H063+$000039A6: 4a2b0015  tst.b $15(a3)
        tst.b $15(a3)
L063_000039AA:
; H063+$000039AA: 6600005c  bne.w $3a08
        bne.w H063+$3A08
L063_000039AE:
; H063+$000039AE: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_000039B2:
; H063+$000039B2: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L063_000039B6:
; H063+$000039B6: 66000050  bne.w $3a08
        bne.w H063+$3A08
L063_000039BA:
; H063+$000039BA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_000039BE:
; H063+$000039BE: 0c2b00050197  cmpi.b #$5, $197(a3)
        cmpi.b #$5, $197(a3)
L063_000039C4:
; H063+$000039C4: 66000042  bne.w $3a08
        bne.w H063+$3A08
L063_000039C8:
; H063+$000039C8: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L063_000039CE:
; H063+$000039CE: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L063_000039D2:
; H063+$000039D2: 67000034  beq.w $3a08
        beq.w H063+$3A08
L063_000039D6:
; H063+$000039D6: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_000039DA:
; H063+$000039DA: 177c00040197  move.b #$4, $197(a3)
        move.b #$4, $197(a3)
L063_000039E0:
; H063+$000039E0: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L063_000039E4:
; H063+$000039E4: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L063_000039E8:
; H063+$000039E8: 422b0010  clr.b $10(a3)
        clr.b $10(a3)
L063_000039EC:
; H063+$000039EC: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L063_000039F0:
; H063+$000039F0: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L063_000039F4:
; H063+$000039F4: 486c00e0  pea.l $e0(a4)
        pea.l $e0(a4)
L063_000039F8:
; H063+$000039F8: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_000039FC:
; H063+$000039FC: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00003A00:
; H063+$00003A00: 6100e3c0  bsr.w $1dc2
        bsr.w H063+$1DC2
L063_00003A04:
; H063+$00003A04: 422d000c  clr.b $c(a5)
        clr.b $c(a5)
L063_00003A08:
; H063+$00003A08: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L063_00003A0C:
; H063+$00003A0C: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L063_00003A12:
; H063+$00003A12: 6082  bra.b $3996
        bra.b H063+$3996
L063_00003A14:
; H063+$00003A14: 102dfffb  move.b -$5(a5), d0
        move.b -$5(a5), d0
L063_00003A18:
; H063+$00003A18: 60000002  bra.w $3a1c
        bra.w H063+$3A1C
L063_00003A1C:
; H063+$00003A1C: 4e5d  unlk a5
        unlk a5
L063_00003A1E:
; H063+$00003A1E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00003A20:
; H063+$00003A20: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00003A22:
; H063+$00003A22: 548f  addq.l #$2, a7
        addq.l #$2, a7
L063_00003A24:
; H063+$00003A24: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00003A26 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H026+$01E0, H008+$01FC.
;   - Richiama H026+$01E0.
;   - Richiama H008+$01FC.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente); H005+$3DE3 (contesto nativo, 5 nel combattimento); H005+$3364 (testa della lista del party).
; Chiamanti diretti: H033+$1344, H012+$24EE, H065+$1300, H065+$1DBE
; --------------------------------------------------------------------------
L063_00003A26:
; H063+$00003A26: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00003A28:
; H063+$00003A28: 287ac6d6  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00003A2C:
; H063+$00003A2C: 4e55ffa2  link.w a5, #$ffa2
        link.w a5, #$ffa2
L063_00003A30:
; H063+$00003A30: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L063_00003A34:
; H063+$00003A34: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00003A36:
; H063+$00003A36: 08020000  btst.b #$0, d2
        btst #$0, d2
L063_00003A3A:
; H063+$00003A3A: 6702  beq.b $3a3e
        beq.b H063+$3A3E
L063_00003A3C:
; H063+$00003A3C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L063_00003A3E:
; H063+$00003A3E: 9ec2  suba.w d2, a7
        suba.w d2, a7
L063_00003A40:
; H063+$00003A40: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L063_00003A44:
; H063+$00003A44: 2b4f0014  move.l a7, $14(a5)
        move.l a7, $14(a5)
L063_00003A48:
; H063+$00003A48: 244f  movea.l a7, a2
        movea.l a7, a2
L063_00003A4A:
; H063+$00003A4A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00003A4C:
; H063+$00003A4C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00003A4E:
; H063+$00003A4E: 51cafffc  dbra d2, $3a4c
        dbra d2, H063+$3A4C
L063_00003A52:
; H063+$00003A52: 1b79000024a2ffa3  move.b $24a2.l, -$5d(a5)
        move.b (H005+$24A2).l, -$5d(a5)
L063_00003A5A:
; H063+$00003A5A: 13ed0010000024d8  move.b $10(a5), $24d8.l
        move.b $10(a5), (H005+$24D8).l
; STATO: H005+$3368 = personaggio corrente
L063_00003A62:
; H063+$00003A62: 23f90000336800002508  move.l $3368.l, $2508.l
        move.l (H005+$3368).l, (H005+$2508).l
L063_00003A6C:
; H063+$00003A6C: 1b7c0020ffff  move.b #$20, -$1(a5)
        move.b #$20, -$1(a5)
L063_00003A72:
; H063+$00003A72: 47ec00ec  lea.l $ec(a4), a3
        lea.l $ec(a4), a3
L063_00003A76:
; H063+$00003A76: 45edffce  lea.l -$32(a5), a2
        lea.l -$32(a5), a2
L063_00003A7A:
; H063+$00003A7A: 7428  moveq #$28, d2
        moveq #40, d2
L063_00003A7C:
; H063+$00003A7C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00003A7E:
; H063+$00003A7E: 57cafffc  dbeq d2, $3a7c
        dbeq d2, H063+$3A7C
L063_00003A82:
; H063+$00003A82: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L063_00003A86:
; H063+$00003A86: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00003A8A:
; H063+$00003A8A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L063_00003A8E:
; H063+$00003A8E: 486c00ee  pea.l $ee(a4)
        pea.l $ee(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00003A92:
; H063+$00003A92: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00003A98:
; H063+$00003A98: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L063_00003A9C:
; H063+$00003A9C: 67000012  beq.w $3ab0
        beq.w H063+$3AB0
L063_00003AA0:
; H063+$00003AA0: 47ec00f0  lea.l $f0(a4), a3
        lea.l $f0(a4), a3
L063_00003AA4:
; H063+$00003AA4: 45edffce  lea.l -$32(a5), a2
        lea.l -$32(a5), a2
L063_00003AA8:
; H063+$00003AA8: 7428  moveq #$28, d2
        moveq #40, d2
L063_00003AAA:
; H063+$00003AAA: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00003AAC:
; H063+$00003AAC: 57cafffc  dbeq d2, $3aaa
        dbeq d2, H063+$3AAA
L063_00003AB0:
; H063+$00003AB0: 0c2d0045ffff  cmpi.b #$45, -$1(a5)
        cmpi.b #$45, -$1(a5)
L063_00003AB6:
; H063+$00003AB6: 670001d6  beq.w $3c8e
        beq.w H063+$3C8E
L063_00003ABA:
; H063+$00003ABA: 0c2d001bffff  cmpi.b #$1b, -$1(a5)
        cmpi.b #$1b, -$1(a5)
L063_00003AC0:
; H063+$00003AC0: 670001cc  beq.w $3c8e
        beq.w H063+$3C8E
L063_00003AC4:
; H063+$00003AC4: 0c2d0053ffff  cmpi.b #$53, -$1(a5)
        cmpi.b #$53, -$1(a5)
L063_00003ACA:
; H063+$00003ACA: 670001c2  beq.w $3c8e
        beq.w H063+$3C8E
L063_00003ACE:
; H063+$00003ACE: 0c2d000dffff  cmpi.b #$d, -$1(a5)
        cmpi.b #$d, -$1(a5)
L063_00003AD4:
; H063+$00003AD4: 670001b8  beq.w $3c8e
        beq.w H063+$3C8E
L063_00003AD8:
; H063+$00003AD8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00003ADC:
; H063+$00003ADC: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L063_00003ADE:
; H063+$00003ADE: 6100d2a0  bsr.w $d80
        bsr.w H063+$D80
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00003AE2:
; H063+$00003AE2: 0c39000200003de3  cmpi.b #$2, $3de3.l
        cmpi.b #$2, (H005+$3DE3).l
L063_00003AEA:
; H063+$00003AEA: 6700000e  beq.w $3afa
        beq.w H063+$3AFA
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00003AEE:
; H063+$00003AEE: 0c39000600003de3  cmpi.b #$6, $3de3.l
        cmpi.b #$6, (H005+$3DE3).l
L063_00003AF6:
; H063+$00003AF6: 6600000c  bne.w $3b04
        bne.w H063+$3B04
L063_00003AFA:
; H063+$00003AFA: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L063_00003B00:
; H063+$00003B00: 60000006  bra.w $3b08
        bra.w H063+$3B08
L063_00003B04:
; H063+$00003B04: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L063_00003B08:
; H063+$00003B08: 4a3900003de3  tst.b $3de3.l
        tst.b (H005+$3DE3).l
L063_00003B0E:
; H063+$00003B0E: 6600000a  bne.w $3b1a
        bne.w H063+$3B1A
L063_00003B12:
; H063+$00003B12: 13fc0001000024a2  move.b #$1, $24a2.l
        move.b #$1, (H005+$24A2).l
L063_00003B1A:
; H063+$00003B1A: 47ec00f6  lea.l $f6(a4), a3
        lea.l $f6(a4), a3
L063_00003B1E:
; H063+$00003B1E: 45edffa4  lea.l -$5c(a5), a2
        lea.l -$5c(a5), a2
L063_00003B22:
; H063+$00003B22: 7428  moveq #$28, d2
        moveq #40, d2
L063_00003B24:
; H063+$00003B24: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L063_00003B26:
; H063+$00003B26: 57cafffc  dbeq d2, $3b24
        dbeq d2, H063+$3B24
L063_00003B2A:
; H063+$00003B2A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003B2E:
; H063+$00003B2E: 486dffa4  pea.l -$5c(a5)
        pea.l -$5c(a5)
L063_00003B32:
; H063+$00003B32: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003B36:
; H063+$00003B36: 486dffce  pea.l -$32(a5)
        pea.l -$32(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L063_00003B3A:
; H063+$00003B3A: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L063_00003B40:
; H063+$00003B40: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L063_00003B44:
; H063+$00003B44: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L063_00003B48:
; H063+$00003B48: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L063_00003B4C:
; H063+$00003B4C: 486dffa4  pea.l -$5c(a5)
        pea.l -$5c(a5)
L063_00003B50:
; H063+$00003B50: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L063_00003B54:
; H063+$00003B54: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L063_00003B58:
; H063+$00003B58: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L063_00003B5C:
; H063+$00003B5C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L063_00003B60:
; H063+$00003B60: 1f2dfffd  move.b -$3(a5), -(a7)
        move.b -$3(a5), -(a7)
L063_00003B64:
; H063+$00003B64: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L063_00003B68:
; H063+$00003B68: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L063_00003B6E:
; H063+$00003B6E: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L063_00003B72:
; H063+$00003B72: 13edffa3000024a2  move.b -$5d(a5), $24a2.l
        move.b -$5d(a5), (H005+$24A2).l
L063_00003B7A:
; H063+$00003B7A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00003B7E:
; H063+$00003B7E: 2b53fff8  move.l (a3), -$8(a5)
        move.l (a3), -$8(a5)
L063_00003B82:
; H063+$00003B82: 4a2dfffe  tst.b -$2(a5)
        tst.b -$2(a5)
L063_00003B86:
; H063+$00003B86: 670000dc  beq.w $3c64
        beq.w H063+$3C64
L063_00003B8A:
; H063+$00003B8A: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003B8C:
; H063+$00003B8C: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L063_00003B90:
; H063+$00003B90: 600000b4  bra.w $3c46
        bra.w H063+$3C46
L063_00003B94:
; H063+$00003B94: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00003B98:
; H063+$00003B98: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
L063_00003B9E:
; H063+$00003B9E: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L063_00003BA2:
; H063+$00003BA2: 6600000a  bne.w $3bae
        bne.w H063+$3BAE
; STATO: H005+$3364 = testa della lista del party
L063_00003BA6:
; H063+$00003BA6: 2b7900003364fff8  move.l $3364.l, -$8(a5)
        move.l (H005+$3364).l, -$8(a5)
L063_00003BAE:
; H063+$00003BAE: 4e75  rts 
        rts 
L063_00003BB0:
; H063+$00003BB0: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L063_00003BB6:
; H063+$00003BB6: 67000024  beq.w $3bdc
        beq.w H063+$3BDC
L063_00003BBA:
; H063+$00003BBA: 4a39000024d8  tst.b $24d8.l
        tst.b (H005+$24D8).l
L063_00003BC0:
; H063+$00003BC0: 6700000e  beq.w $3bd0
        beq.w H063+$3BD0
L063_00003BC4:
; H063+$00003BC4: 2b7900002508fff8  move.l $2508.l, -$8(a5)
        move.l (H005+$2508).l, -$8(a5)
L063_00003BCC:
; H063+$00003BCC: 6000000a  bra.w $3bd8
        bra.w H063+$3BD8
; STATO: H005+$3368 = personaggio corrente
L063_00003BD0:
; H063+$00003BD0: 2b7900003368fff8  move.l $3368.l, -$8(a5)
        move.l (H005+$3368).l, -$8(a5)
L063_00003BD8:
; H063+$00003BD8: 60000054  bra.w $3c2e
        bra.w H063+$3C2E
; STATO: H005+$3364 = testa della lista del party
L063_00003BDC:
; H063+$00003BDC: 2b7900003364fff8  move.l $3364.l, -$8(a5)
        move.l (H005+$3364).l, -$8(a5)
L063_00003BE4:
; H063+$00003BE4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00003BE8:
; H063+$00003BE8: 2413  move.l (a3), d2
        move.l (a3), d2
; STATO: H005+$3364 = testa della lista del party
L063_00003BEA:
; H063+$00003BEA: b4b900003364  cmp.l $3364.l, d2
        cmp.l (H005+$3364).l, d2
L063_00003BF0:
; H063+$00003BF0: 67000024  beq.w $3c16
        beq.w H063+$3C16
L063_00003BF4:
; H063+$00003BF4: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00003BF8:
; H063+$00003BF8: 242b018e  move.l $18e(a3), d2
        move.l $18e(a3), d2
L063_00003BFC:
; H063+$00003BFC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00003C00:
; H063+$00003C00: b493  cmp.l (a3), d2
        cmp.l (a3), d2
L063_00003C02:
; H063+$00003C02: 6700000e  beq.w $3c12
        beq.w H063+$3C12
L063_00003C06:
; H063+$00003C06: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00003C0A:
; H063+$00003C0A: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
L063_00003C10:
; H063+$00003C10: 60e2  bra.b $3bf4
        bra.b H063+$3BF4
L063_00003C12:
; H063+$00003C12: 6000001a  bra.w $3c2e
        bra.w H063+$3C2E
L063_00003C16:
; H063+$00003C16: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00003C1A:
; H063+$00003C1A: 4aab018e  tst.l $18e(a3)
        tst.l $18e(a3)
L063_00003C1E:
; H063+$00003C1E: 6700000e  beq.w $3c2e
        beq.w H063+$3C2E
L063_00003C22:
; H063+$00003C22: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L063_00003C26:
; H063+$00003C26: 2b6b018efff8  move.l $18e(a3), -$8(a5)
        move.l $18e(a3), -$8(a5)
L063_00003C2C:
; H063+$00003C2C: 60e8  bra.b $3c16
        bra.b H063+$3C16
L063_00003C2E:
; H063+$00003C2E: 4e75  rts 
        rts 
L063_00003C30:
; H063+$00003C30: 4e75  rts 
        rts 
; Preserved bytes H063+$00003C32..$00003C46; code/data not fully classified.
        dc.w $FFFC,$FF7C,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FF60
L063_00003C46:
; H063+$00003C46: 47faffec  lea.l $3c34(pc), a3
        lea.l H063+$3C34(pc), a3
L063_00003C4A:
; H063+$00003C4A: 04420048  subi.w #$48, d2
        subi.w #$48, d2
L063_00003C4E:
; H063+$00003C4E: 0c420008  cmpi.w #$8, d2
        cmpi.w #$8, d2
L063_00003C52:
; H063+$00003C52: 6302  bls.b $3c56
        bls.b H063+$3C56
L063_00003C54:
; H063+$00003C54: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00003C56:
; H063+$00003C56: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00003C58:
; H063+$00003C58: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$3C34; indici 0..8, default -1.
L063_00003C5C:
; H063+$00003C5C: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00003C60:
; H063+$00003C60: 60000020  bra.w $3c82
        bra.w H063+$3C82
L063_00003C64:
; H063+$00003C64: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L063_00003C68:
; H063+$00003C68: 67000018  beq.w $3c82
        beq.w H063+$3C82
L063_00003C6C:
; H063+$00003C6C: 0c2d0045ffff  cmpi.b #$45, -$1(a5)
        cmpi.b #$45, -$1(a5)
L063_00003C72:
; H063+$00003C72: 6700000a  beq.w $3c7e
        beq.w H063+$3C7E
L063_00003C76:
; H063+$00003C76: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L063_00003C7A:
; H063+$00003C7A: 66000006  bne.w $3c82
        bne.w H063+$3C82
L063_00003C7E:
; H063+$00003C7E: 42adfff8  clr.l -$8(a5)
        clr.l -$8(a5)
L063_00003C82:
; H063+$00003C82: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L063_00003C86:
; H063+$00003C86: 26adfff8  move.l -$8(a5), (a3)
        move.l -$8(a5), (a3)
L063_00003C8A:
; H063+$00003C8A: 6000fe24  bra.w $3ab0
        bra.w H063+$3AB0
L063_00003C8E:
; H063+$00003C8E: 4239000024d8  clr.b $24d8.l
        clr.b (H005+$24D8).l
L063_00003C94:
; H063+$00003C94: 4e5d  unlk a5
        unlk a5
L063_00003C96:
; H063+$00003C96: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00003C98:
; H063+$00003C98: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00003C9A:
; H063+$00003C9A: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L063_00003C9E:
; H063+$00003C9E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H063_00003CA0 [parziale]
; Scopo: Routine del modulo helper per personaggi, inventario e aggiornamento UI; richiama H048+$0F88, H048+$0FBA.
;   - Richiama H048+$0F88.
;   - Richiama H048+$0FBA.
; Chiamanti diretti: H096+$210E, H096+$21D4, H096+$2278, H096+$34A4, H096+$3468, H096+$1E06 e altri 2
; --------------------------------------------------------------------------
L063_00003CA0:
; H063+$00003CA0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00003CA2:
; H063+$00003CA2: 287ac45c  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00003CA6:
; H063+$00003CA6: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L063_00003CAA:
; H063+$00003CAA: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L063_00003CAE:
; H063+$00003CAE: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L063_00003CB4:
; H063+$00003CB4: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L063_00003CB8:
; H063+$00003CB8: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L063_00003CBC:
; H063+$00003CBC: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L063_00003CC2:
; H063+$00003CC2: 3b40fff8  move.w d0, -$8(a5)
        move.w d0, -$8(a5)
L063_00003CC6:
; H063+$00003CC6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L063_00003CCA:
; H063+$00003CCA: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L063_00003CD0:
; H063+$00003CD0: 3b40fff6  move.w d0, -$a(a5)
        move.w d0, -$a(a5)
L063_00003CD4:
; H063+$00003CD4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L063_00003CD8:
; H063+$00003CD8: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L063_00003CDE:
; H063+$00003CDE: 3b40fff4  move.w d0, -$c(a5)
        move.w d0, -$c(a5)
L063_00003CE2:
; H063+$00003CE2: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00003CE6:
; H063+$00003CE6: 946dfffa  sub.w -$6(a5), d2
        sub.w -$6(a5), d2
L063_00003CEA:
; H063+$00003CEA: 4a42  tst.w d2
        tst.w d2
L063_00003CEC:
; H063+$00003CEC: 6c02  bge.b $3cf0
        bge.b H063+$3CF0
L063_00003CEE:
; H063+$00003CEE: 4442  neg.w d2
        neg.w d2
L063_00003CF0:
; H063+$00003CF0: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L063_00003CF4:
; H063+$00003CF4: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00003CF8:
; H063+$00003CF8: 946dfff8  sub.w -$8(a5), d2
        sub.w -$8(a5), d2
L063_00003CFC:
; H063+$00003CFC: 4a42  tst.w d2
        tst.w d2
L063_00003CFE:
; H063+$00003CFE: 6c02  bge.b $3d02
        bge.b H063+$3D02
L063_00003D00:
; H063+$00003D00: 4442  neg.w d2
        neg.w d2
L063_00003D02:
; H063+$00003D02: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L063_00003D06:
; H063+$00003D06: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L063_00003D0C:
; H063+$00003D0C: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L063_00003D10:
; H063+$00003D10: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L063_00003D14:
; H063+$00003D14: 6600024a  bne.w $3f60
        bne.w H063+$3F60
L063_00003D18:
; H063+$00003D18: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L063_00003D1C:
; H063+$00003D1C: 6000020e  bra.w $3f2c
        bra.w H063+$3F2C
L063_00003D20:
; H063+$00003D20: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00003D24:
; H063+$00003D24: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L063_00003D28:
; H063+$00003D28: 6c00003e  bge.w $3d68
        bge.w H063+$3D68
L063_00003D2C:
; H063+$00003D2C: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00003D30:
; H063+$00003D30: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L063_00003D34:
; H063+$00003D34: 6f000032  ble.w $3d68
        ble.w H063+$3D68
L063_00003D38:
; H063+$00003D38: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003D3C:
; H063+$00003D3C: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L063_00003D40:
; H063+$00003D40: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003D44:
; H063+$00003D44: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003D48:
; H063+$00003D48: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003D4A:
; H063+$00003D4A: 6e00001c  bgt.w $3d68
        bgt.w H063+$3D68
L063_00003D4E:
; H063+$00003D4E: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003D52:
; H063+$00003D52: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L063_00003D56:
; H063+$00003D56: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003D5A:
; H063+$00003D5A: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003D5E:
; H063+$00003D5E: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003D60:
; H063+$00003D60: 6d000006  blt.w $3d68
        blt.w H063+$3D68
L063_00003D64:
; H063+$00003D64: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003D66:
; H063+$00003D66: 6002  bra.b $3d6a
        bra.b H063+$3D6A
L063_00003D68:
; H063+$00003D68: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003D6A:
; H063+$00003D6A: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003D6E:
; H063+$00003D6E: 4e75  rts 
        rts 
L063_00003D70:
; H063+$00003D70: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00003D74:
; H063+$00003D74: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L063_00003D78:
; H063+$00003D78: 6f00003e  ble.w $3db8
        ble.w H063+$3DB8
L063_00003D7C:
; H063+$00003D7C: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00003D80:
; H063+$00003D80: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L063_00003D84:
; H063+$00003D84: 6f000032  ble.w $3db8
        ble.w H063+$3DB8
L063_00003D88:
; H063+$00003D88: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003D8C:
; H063+$00003D8C: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L063_00003D90:
; H063+$00003D90: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003D94:
; H063+$00003D94: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003D98:
; H063+$00003D98: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003D9A:
; H063+$00003D9A: 6e00001c  bgt.w $3db8
        bgt.w H063+$3DB8
L063_00003D9E:
; H063+$00003D9E: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003DA2:
; H063+$00003DA2: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L063_00003DA6:
; H063+$00003DA6: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003DAA:
; H063+$00003DAA: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003DAE:
; H063+$00003DAE: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003DB0:
; H063+$00003DB0: 6d000006  blt.w $3db8
        blt.w H063+$3DB8
L063_00003DB4:
; H063+$00003DB4: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003DB6:
; H063+$00003DB6: 6002  bra.b $3dba
        bra.b H063+$3DBA
L063_00003DB8:
; H063+$00003DB8: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003DBA:
; H063+$00003DBA: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003DBE:
; H063+$00003DBE: 4e75  rts 
        rts 
L063_00003DC0:
; H063+$00003DC0: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00003DC4:
; H063+$00003DC4: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L063_00003DC8:
; H063+$00003DC8: 6f00003e  ble.w $3e08
        ble.w H063+$3E08
L063_00003DCC:
; H063+$00003DCC: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00003DD0:
; H063+$00003DD0: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L063_00003DD4:
; H063+$00003DD4: 6c000032  bge.w $3e08
        bge.w H063+$3E08
L063_00003DD8:
; H063+$00003DD8: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003DDC:
; H063+$00003DDC: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L063_00003DE0:
; H063+$00003DE0: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003DE4:
; H063+$00003DE4: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003DE8:
; H063+$00003DE8: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003DEA:
; H063+$00003DEA: 6e00001c  bgt.w $3e08
        bgt.w H063+$3E08
L063_00003DEE:
; H063+$00003DEE: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003DF2:
; H063+$00003DF2: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L063_00003DF6:
; H063+$00003DF6: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003DFA:
; H063+$00003DFA: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003DFE:
; H063+$00003DFE: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003E00:
; H063+$00003E00: 6d000006  blt.w $3e08
        blt.w H063+$3E08
L063_00003E04:
; H063+$00003E04: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003E06:
; H063+$00003E06: 6002  bra.b $3e0a
        bra.b H063+$3E0A
L063_00003E08:
; H063+$00003E08: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003E0A:
; H063+$00003E0A: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003E0E:
; H063+$00003E0E: 4e75  rts 
        rts 
L063_00003E10:
; H063+$00003E10: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00003E14:
; H063+$00003E14: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L063_00003E18:
; H063+$00003E18: 6c00003e  bge.w $3e58
        bge.w H063+$3E58
L063_00003E1C:
; H063+$00003E1C: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00003E20:
; H063+$00003E20: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L063_00003E24:
; H063+$00003E24: 6c000032  bge.w $3e58
        bge.w H063+$3E58
L063_00003E28:
; H063+$00003E28: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003E2C:
; H063+$00003E2C: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L063_00003E30:
; H063+$00003E30: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003E34:
; H063+$00003E34: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003E38:
; H063+$00003E38: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003E3A:
; H063+$00003E3A: 6e00001c  bgt.w $3e58
        bgt.w H063+$3E58
L063_00003E3E:
; H063+$00003E3E: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003E42:
; H063+$00003E42: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L063_00003E46:
; H063+$00003E46: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003E4A:
; H063+$00003E4A: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003E4E:
; H063+$00003E4E: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003E50:
; H063+$00003E50: 6d000006  blt.w $3e58
        blt.w H063+$3E58
L063_00003E54:
; H063+$00003E54: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003E56:
; H063+$00003E56: 6002  bra.b $3e5a
        bra.b H063+$3E5A
L063_00003E58:
; H063+$00003E58: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003E5A:
; H063+$00003E5A: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003E5E:
; H063+$00003E5E: 4e75  rts 
        rts 
L063_00003E60:
; H063+$00003E60: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00003E64:
; H063+$00003E64: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L063_00003E68:
; H063+$00003E68: 6e00001c  bgt.w $3e86
        bgt.w H063+$3E86
L063_00003E6C:
; H063+$00003E6C: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003E70:
; H063+$00003E70: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L063_00003E74:
; H063+$00003E74: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003E78:
; H063+$00003E78: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003E7C:
; H063+$00003E7C: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003E7E:
; H063+$00003E7E: 6d000006  blt.w $3e86
        blt.w H063+$3E86
L063_00003E82:
; H063+$00003E82: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003E84:
; H063+$00003E84: 6002  bra.b $3e88
        bra.b H063+$3E88
L063_00003E86:
; H063+$00003E86: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003E88:
; H063+$00003E88: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003E8C:
; H063+$00003E8C: 4e75  rts 
        rts 
L063_00003E8E:
; H063+$00003E8E: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00003E92:
; H063+$00003E92: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L063_00003E96:
; H063+$00003E96: 6d00001c  blt.w $3eb4
        blt.w H063+$3EB4
L063_00003E9A:
; H063+$00003E9A: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003E9E:
; H063+$00003E9E: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L063_00003EA2:
; H063+$00003EA2: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003EA6:
; H063+$00003EA6: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003EAA:
; H063+$00003EAA: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003EAC:
; H063+$00003EAC: 6e000006  bgt.w $3eb4
        bgt.w H063+$3EB4
L063_00003EB0:
; H063+$00003EB0: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003EB2:
; H063+$00003EB2: 6002  bra.b $3eb6
        bra.b H063+$3EB6
L063_00003EB4:
; H063+$00003EB4: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003EB6:
; H063+$00003EB6: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003EBA:
; H063+$00003EBA: 4e75  rts 
        rts 
L063_00003EBC:
; H063+$00003EBC: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L063_00003EC0:
; H063+$00003EC0: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L063_00003EC4:
; H063+$00003EC4: 6d00001c  blt.w $3ee2
        blt.w H063+$3EE2
L063_00003EC8:
; H063+$00003EC8: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003ECC:
; H063+$00003ECC: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L063_00003ED0:
; H063+$00003ED0: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003ED4:
; H063+$00003ED4: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003ED8:
; H063+$00003ED8: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003EDA:
; H063+$00003EDA: 6d000006  blt.w $3ee2
        blt.w H063+$3EE2
L063_00003EDE:
; H063+$00003EDE: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003EE0:
; H063+$00003EE0: 6002  bra.b $3ee4
        bra.b H063+$3EE4
L063_00003EE2:
; H063+$00003EE2: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003EE4:
; H063+$00003EE4: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003EE8:
; H063+$00003EE8: 4e75  rts 
        rts 
L063_00003EEA:
; H063+$00003EEA: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L063_00003EEE:
; H063+$00003EEE: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L063_00003EF2:
; H063+$00003EF2: 6e00001c  bgt.w $3f10
        bgt.w H063+$3F10
L063_00003EF6:
; H063+$00003EF6: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L063_00003EFA:
; H063+$00003EFA: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L063_00003EFE:
; H063+$00003EFE: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L063_00003F02:
; H063+$00003F02: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L063_00003F06:
; H063+$00003F06: b842  cmp.w d2, d4
        cmp.w d2, d4
L063_00003F08:
; H063+$00003F08: 6e000006  bgt.w $3f10
        bgt.w H063+$3F10
L063_00003F0C:
; H063+$00003F0C: 7401  moveq #$1, d2
        moveq #1, d2
L063_00003F0E:
; H063+$00003F0E: 6002  bra.b $3f12
        bra.b H063+$3F12
L063_00003F10:
; H063+$00003F10: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003F12:
; H063+$00003F12: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L063_00003F16:
; H063+$00003F16: 4e75  rts 
        rts 
L063_00003F18:
; H063+$00003F18: 4e75  rts 
        rts 
; Preserved bytes H063+$00003F1A..$00003F2C; code/data not fully classified.
        dc.w $FFFC,$FF44,$FE04,$FF72,$FE54,$FFA0,$FEA4,$FFCE
        dc.w $FEF4
L063_00003F2C:
; H063+$00003F2C: 47faffee  lea.l $3f1c(pc), a3
        lea.l H063+$3F1C(pc), a3
L063_00003F30:
; H063+$00003F30: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L063_00003F34:
; H063+$00003F34: 6302  bls.b $3f38
        bls.b H063+$3F38
L063_00003F36:
; H063+$00003F36: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00003F38:
; H063+$00003F38: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00003F3A:
; H063+$00003F3A: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$3F1C; indici 0..7, default -1.
L063_00003F3E:
; H063+$00003F3E: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00003F42:
; H063+$00003F42: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L063_00003F46:
; H063+$00003F46: 66000014  bne.w $3f5c
        bne.w H063+$3F5C
L063_00003F4A:
; H063+$00003F4A: 546dfffe  addq.w #$2, -$2(a5)
        addq.w #$2, -$2(a5)
L063_00003F4E:
; H063+$00003F4E: 0c6d0007fffe  cmpi.w #$7, -$2(a5)
        cmpi.w #$7, -$2(a5)
L063_00003F54:
; H063+$00003F54: 63000006  bls.w $3f5c
        bls.w H063+$3F5C
L063_00003F58:
; H063+$00003F58: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L063_00003F5C:
; H063+$00003F5C: 6000fdb2  bra.w $3d10
        bra.w H063+$3D10
L063_00003F60:
; H063+$00003F60: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L063_00003F64:
; H063+$00003F64: 60000002  bra.w $3f68
        bra.w H063+$3F68
L063_00003F68:
; H063+$00003F68: 4e5d  unlk a5
        unlk a5
L063_00003F6A:
; H063+$00003F6A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00003F6C:
; H063+$00003F6C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00003F6E:
; H063+$00003F6E: 508f  addq.l #$8, a7
        addq.l #$8, a7
L063_00003F70:
; H063+$00003F70: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H063_4042 [parziale]
; Scopo: Trampolino verso H063+$4042; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H063+$4042.
; Chiamanti diretti: H013+$5A0C, H013+$621A
; --------------------------------------------------------------------------
L063_00003F72:
; H063+$00003F72: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L063_00003F74:
; H063+$00003F74: 287ac18a  movea.l $100(pc), a4
        movea.l H063+$100(pc), a4
L063_00003F78:
; H063+$00003F78: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L063_00003F7C:
; H063+$00003F7C: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003F7E:
; H063+$00003F7E: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L063_00003F82:
; H063+$00003F82: 600000be  bra.w $4042
        bra.w H063+$4042
L063_00003F86:
; H063+$00003F86: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003F88:
; H063+$00003F88: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00003F8C:
; H063+$00003F8C: 142b005e  move.b $5e(a3), d2
        move.b $5e(a3), d2
L063_00003F90:
; H063+$00003F90: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L063_00003F94:
; H063+$00003F94: 6200000a  bhi.w $3fa0
        bhi.w H063+$3FA0
L063_00003F98:
; H063+$00003F98: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L063_00003F9C:
; H063+$00003F9C: 60000008  bra.w $3fa6
        bra.w H063+$3FA6
L063_00003FA0:
; H063+$00003FA0: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L063_00003FA6:
; H063+$00003FA6: 4e75  rts 
        rts 
L063_00003FA8:
; H063+$00003FA8: 7400  moveq #$0, d2
        moveq #0, d2
L063_00003FAA:
; H063+$00003FAA: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00003FAE:
; H063+$00003FAE: 142b005d  move.b $5d(a3), d2
        move.b $5d(a3), d2
L063_00003FB2:
; H063+$00003FB2: 60000024  bra.w $3fd8
        bra.w H063+$3FD8
L063_00003FB6:
; H063+$00003FB6: 1b7c0003ffff  move.b #$3, -$1(a5)
        move.b #$3, -$1(a5)
L063_00003FBC:
; H063+$00003FBC: 4e75  rts 
        rts 
L063_00003FBE:
; H063+$00003FBE: 1b7c0004ffff  move.b #$4, -$1(a5)
        move.b #$4, -$1(a5)
L063_00003FC4:
; H063+$00003FC4: 4e75  rts 
        rts 
L063_00003FC6:
; H063+$00003FC6: 1b7c0005ffff  move.b #$5, -$1(a5)
        move.b #$5, -$1(a5)
L063_00003FCC:
; H063+$00003FCC: 4e75  rts 
        rts 
L063_00003FCE:
; H063+$00003FCE: 4e75  rts 
        rts 
; Preserved bytes H063+$00003FD0..$00003FD8; code/data not fully classified.
        dc.w $FFFC,$FFE4,$FFEC,$FFF4
L063_00003FD8:
; H063+$00003FD8: 47fafff8  lea.l $3fd2(pc), a3
        lea.l H063+$3FD2(pc), a3
L063_00003FDC:
; H063+$00003FDC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L063_00003FDE:
; H063+$00003FDE: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L063_00003FE2:
; H063+$00003FE2: 6302  bls.b $3fe6
        bls.b H063+$3FE6
L063_00003FE4:
; H063+$00003FE4: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_00003FE6:
; H063+$00003FE6: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00003FE8:
; H063+$00003FE8: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$3FD2; indici 0..2, default -1.
L063_00003FEC:
; H063+$00003FEC: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00003FF0:
; H063+$00003FF0: 4e75  rts 
        rts 
L063_00003FF2:
; H063+$00003FF2: 1b7c0002ffff  move.b #$2, -$1(a5)
        move.b #$2, -$1(a5)
L063_00003FF8:
; H063+$00003FF8: 4e75  rts 
        rts 
L063_00003FFA:
; H063+$00003FFA: 1b7c0006ffff  move.b #$6, -$1(a5)
        move.b #$6, -$1(a5)
L063_00004000:
; H063+$00004000: 4e75  rts 
        rts 
L063_00004002:
; H063+$00004002: 7400  moveq #$0, d2
        moveq #0, d2
L063_00004004:
; H063+$00004004: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L063_00004008:
; H063+$00004008: 142b005f  move.b $5f(a3), d2
        move.b $5f(a3), d2
L063_0000400C:
; H063+$0000400C: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L063_00004010:
; H063+$00004010: 6600000c  bne.w $401e
        bne.w H063+$401E
L063_00004014:
; H063+$00004014: 1b7c0007ffff  move.b #$7, -$1(a5)
        move.b #$7, -$1(a5)
L063_0000401A:
; H063+$0000401A: 60000008  bra.w $4024
        bra.w H063+$4024
L063_0000401E:
; H063+$0000401E: 1b7c0008ffff  move.b #$8, -$1(a5)
        move.b #$8, -$1(a5)
L063_00004024:
; H063+$00004024: 4e75  rts 
        rts 
L063_00004026:
; H063+$00004026: 1b7c0009ffff  move.b #$9, -$1(a5)
        move.b #$9, -$1(a5)
L063_0000402C:
; H063+$0000402C: 4e75  rts 
        rts 
L063_0000402E:
; H063+$0000402E: 4e75  rts 
        rts 
; Preserved bytes H063+$00004030..$00004042; code/data not fully classified.
        dc.w $FFFC,$FF54,$FFFC,$FFC0,$FFFC,$FFC8,$FFD0,$FFF4
        dc.w $FF76
L063_00004042:
; H063+$00004042: 47faffee  lea.l $4032(pc), a3
        lea.l H063+$4032(pc), a3
L063_00004046:
; H063+$00004046: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L063_0000404A:
; H063+$0000404A: 6302  bls.b $404e
        bls.b H063+$404E
L063_0000404C:
; H063+$0000404C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L063_0000404E:
; H063+$0000404E: e342  asl.w #$1, d2
        asl.w #$1, d2
L063_00004050:
; H063+$00004050: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H063+$4032; indici 0..7, default -1.
L063_00004054:
; H063+$00004054: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L063_00004058:
; H063+$00004058: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L063_0000405C:
; H063+$0000405C: 60000002  bra.w $4060
        bra.w H063+$4060
L063_00004060:
; H063+$00004060: 4e5d  unlk a5
        unlk a5
L063_00004062:
; H063+$00004062: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_00004064:
; H063+$00004064: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L063_00004066:
; H063+$00004066: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L063_00004068:
; H063+$00004068: 4ed0  jmp (a0)
        jmp (a0)
L063_0000406A:
; H063+$0000406A: 4e5d  unlk a5
        unlk a5
L063_0000406C:
; H063+$0000406C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L063_0000406E:
; H063+$0000406E: 4e75  rts 
        rts 
; End H063: $4070 bytes
