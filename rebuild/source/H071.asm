; ============================================================================
; GUIDA DEL MODULO H071
; Negozio e acquisto di oggetti.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Negozio: catalogo, acquisto, vendita e aggiornamento dell'inventario.
; --------------------------------------------------------------------------
; H071: 3132 original bytes; all offsets are section-relative.
        section H071,code
H071:
; Preserved bytes H071+$00000000..$0000011C; code/data not fully classified.
        dc.w $0000,$4974,$656D,$733A,$2000,$4275,$7900,$4F76
        dc.w $6572,$4C6F,$6164,$6564,$0020,$6275,$7973,$2000
        dc.w $2062,$7579,$7320,$6120,$0020,$6275,$7973,$2000
        dc.w $2062,$7579,$7320,$6120,$004E,$6F74,$2065,$6E6F
        dc.w $7567,$6820,$4D6F,$6E65,$792E,$0000,$0042,$7579
        dc.w $2056,$6965,$7720,$5461,$6B65,$2050,$6F6F,$6C20
        dc.w $5368,$6172,$6520,$4170,$7072,$6169,$7365,$2045
        dc.w $7869,$7400,$4275,$7920,$5669,$6577,$2050,$6F6F
        dc.w $6C20,$4170,$7072,$6169,$7365,$2045,$7869,$7400
        dc.w $7E59,$6573,$207E,$4E6F,$0041,$7320,$796F,$7520
        dc.w $4C65,$6176,$6520,$7468,$6520,$5368,$6F70,$6B65
        dc.w $6570,$6572,$2073,$6179,$732C,$2027,$4578,$6375
        dc.w $7365,$206D,$6520,$6275,$7420,$796F,$7520,$6861
        dc.w $7665,$204C,$6566,$7420,$536F,$6D65,$204D,$6F6E
        dc.w $6579,$2068,$6572,$652E,$2720,$2000,$446F,$2079
        dc.w $6F75,$2077,$616E,$7420,$746F,$2067,$6F20,$6261
        dc.w $636B,$2061,$6E64,$2067,$6574,$2079,$6F75,$7220
        dc.w $4D6F,$6E65,$793F,$0000
        dc.l H071+$00000002
; --------------------------------------------------------------------------
; ROUTINE: module_init_H071 [parziale]
; Scopo: Ingresso del modulo negozio e acquisto di oggetti; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H071+$0C36.
; Chiamanti diretti: H000+$023A
; --------------------------------------------------------------------------
L071_0000011C:
; H071+$0000011C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L071_0000011E:
; H071+$0000011E: 287afff8  movea.l $118(pc), a4
        movea.l H071+$118(pc), a4
L071_00000122:
; H071+$00000122: 4e550000  link.w a5, #$0
        link.w a5, #$0
L071_00000126:
; H071+$00000126: 60000b0e  bra.w $c36
        bra.w H071+$C36
; --------------------------------------------------------------------------
; ROUTINE: sub_H071_0000012A [parziale]
; Scopo: Routine del modulo negozio e acquisto di oggetti; richiama H045+$01D6, H026+$000C, H026+$0188, H008+$13C0.
;   - Richiama H045+$01D6.
;   - Richiama H026+$000C.
;   - Richiama H026+$0188.
;   - Richiama H008+$13C0.
;   - Richiama H063+$09B2.
;   - Usa lo stato globale: H005+$3E00 (puntatore stato persistente B, 2048 byte).
; Chiamanti diretti: H071+$05AC
; --------------------------------------------------------------------------
L071_0000012A:
; H071+$0000012A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L071_0000012C:
; H071+$0000012C: 287affea  movea.l $118(pc), a4
        movea.l H071+$118(pc), a4
L071_00000130:
; H071+$00000130: 4e55ffd2  link.w a5, #$ffd2
        link.w a5, #$ffd2
L071_00000134:
; H071+$00000134: 2b7900002a3afff8  move.l $2a3a.l, -$8(a5)
        move.l (H005+$2A3A).l, -$8(a5)
L071_0000013C:
; H071+$0000013C: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L071_00000140:
; H071+$00000140: 6700029a  beq.w $3dc
        beq.w H071+$3DC
L071_00000144:
; H071+$00000144: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_00000148:
; H071+$00000148: 4a6b0042  tst.w $42(a3)
        tst.w $42(a3)
L071_0000014C:
; H071+$0000014C: 6600000c  bne.w $15a
        bne.w H071+$15A
L071_00000150:
; H071+$00000150: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_00000154:
; H071+$00000154: 377c00010042  move.w #$1, $42(a3)
        move.w #$1, $42(a3)
L071_0000015A:
; H071+$0000015A: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L071_0000015C:
; H071+$0000015C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L071_00000162:
; H071+$00000162: 342b06da  move.w $6da(a3), d2
        move.w $6da(a3), d2
L071_00000166:
; H071+$00000166: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L071_00000168:
; H071+$00000168: 3b42ffd2  move.w d2, -$2e(a5)
        move.w d2, -$2e(a5)
L071_0000016C:
; H071+$0000016C: 0c6d0002ffd2  cmpi.w #$2, -$2e(a5)
        cmpi.w #$2, -$2e(a5)
L071_00000172:
; H071+$00000172: 6300004e  bls.w $1c2
        bls.w H071+$1C2
L071_00000176:
; H071+$00000176: 0c6d0004ffd2  cmpi.w #$4, -$2e(a5)
        cmpi.w #$4, -$2e(a5)
L071_0000017C:
; H071+$0000017C: 6600000c  bne.w $18a
        bne.w H071+$18A
L071_00000180:
; H071+$00000180: 3b7c0003ffd2  move.w #$3, -$2e(a5)
        move.w #$3, -$2e(a5)
L071_00000186:
; H071+$00000186: 6000003a  bra.w $1c2
        bra.w H071+$1C2
L071_0000018A:
; H071+$0000018A: 0c6d0010ffd2  cmpi.w #$10, -$2e(a5)
        cmpi.w #$10, -$2e(a5)
L071_00000190:
; H071+$00000190: 6600000c  bne.w $19e
        bne.w H071+$19E
L071_00000194:
; H071+$00000194: 3b7c0004ffd2  move.w #$4, -$2e(a5)
        move.w #$4, -$2e(a5)
L071_0000019A:
; H071+$0000019A: 60000026  bra.w $1c2
        bra.w H071+$1C2
L071_0000019E:
; H071+$0000019E: 0c6d0020ffd2  cmpi.w #$20, -$2e(a5)
        cmpi.w #$20, -$2e(a5)
L071_000001A4:
; H071+$000001A4: 6600000c  bne.w $1b2
        bne.w H071+$1B2
L071_000001A8:
; H071+$000001A8: 3b7c0005ffd2  move.w #$5, -$2e(a5)
        move.w #$5, -$2e(a5)
L071_000001AE:
; H071+$000001AE: 60000012  bra.w $1c2
        bra.w H071+$1C2
L071_000001B2:
; H071+$000001B2: 0c6d0040ffd2  cmpi.w #$40, -$2e(a5)
        cmpi.w #$40, -$2e(a5)
L071_000001B8:
; H071+$000001B8: 66000008  bne.w $1c2
        bne.w H071+$1C2
L071_000001BC:
; H071+$000001BC: 3b7c0006ffd2  move.w #$6, -$2e(a5)
        move.w #$6, -$2e(a5)
L071_000001C2:
; H071+$000001C2: 342dffd2  move.w -$2e(a5), d2
        move.w -$2e(a5), d2
L071_000001C6:
; H071+$000001C6: 60000194  bra.w $35c
        bra.w H071+$35C
L071_000001CA:
; H071+$000001CA: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_000001CE:
; H071+$000001CE: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_000001D2:
; H071+$000001D2: 7400  moveq #$0, d2
        moveq #0, d2
L071_000001D4:
; H071+$000001D4: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_000001D8:
; H071+$000001D8: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_000001DC:
; H071+$000001DC: e84a  lsr.w #$4, d2
        lsr.w #$4, d2
L071_000001DE:
; H071+$000001DE: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L071_000001E4:
; H071+$000001E4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_000001E6:
; H071+$000001E6: 4227  clr.b -(a7)
        clr.b -(a7)
L071_000001E8:
; H071+$000001E8: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_000001EC:
; H071+$000001EC: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_000001F0:
; H071+$000001F0: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_000001F4:
; H071+$000001F4: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_000001FA:
; H071+$000001FA: 4e75  rts 
        rts 
L071_000001FC:
; H071+$000001FC: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000200:
; H071+$00000200: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_00000204:
; H071+$00000204: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000206:
; H071+$00000206: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_0000020A:
; H071+$0000020A: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_0000020E:
; H071+$0000020E: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L071_00000210:
; H071+$00000210: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L071_00000216:
; H071+$00000216: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_00000218:
; H071+$00000218: 4227  clr.b -(a7)
        clr.b -(a7)
L071_0000021A:
; H071+$0000021A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_0000021E:
; H071+$0000021E: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000222:
; H071+$00000222: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_00000226:
; H071+$00000226: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_0000022C:
; H071+$0000022C: 4e75  rts 
        rts 
L071_0000022E:
; H071+$0000022E: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000232:
; H071+$00000232: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_00000236:
; H071+$00000236: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000238:
; H071+$00000238: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_0000023C:
; H071+$0000023C: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000240:
; H071+$00000240: e44a  lsr.w #$2, d2
        lsr.w #$2, d2
L071_00000242:
; H071+$00000242: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L071_00000248:
; H071+$00000248: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_0000024A:
; H071+$0000024A: 4227  clr.b -(a7)
        clr.b -(a7)
L071_0000024C:
; H071+$0000024C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_00000250:
; H071+$00000250: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000254:
; H071+$00000254: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_00000258:
; H071+$00000258: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_0000025E:
; H071+$0000025E: 4e75  rts 
        rts 
L071_00000260:
; H071+$00000260: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000264:
; H071+$00000264: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_00000268:
; H071+$00000268: 7400  moveq #$0, d2
        moveq #0, d2
L071_0000026A:
; H071+$0000026A: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_0000026E:
; H071+$0000026E: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000272:
; H071+$00000272: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L071_00000274:
; H071+$00000274: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L071_0000027A:
; H071+$0000027A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_0000027C:
; H071+$0000027C: 4227  clr.b -(a7)
        clr.b -(a7)
L071_0000027E:
; H071+$0000027E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_00000282:
; H071+$00000282: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000286:
; H071+$00000286: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_0000028A:
; H071+$0000028A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_00000290:
; H071+$00000290: 4e75  rts 
        rts 
L071_00000292:
; H071+$00000292: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000296:
; H071+$00000296: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_0000029A:
; H071+$0000029A: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_0000029E:
; H071+$0000029E: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_000002A2:
; H071+$000002A2: e342  asl.w #$1, d2
        asl.w #$1, d2
L071_000002A4:
; H071+$000002A4: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L071_000002AA:
; H071+$000002AA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_000002AC:
; H071+$000002AC: 4227  clr.b -(a7)
        clr.b -(a7)
L071_000002AE:
; H071+$000002AE: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_000002B2:
; H071+$000002B2: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_000002B6:
; H071+$000002B6: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_000002BA:
; H071+$000002BA: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_000002C0:
; H071+$000002C0: 4e75  rts 
        rts 
L071_000002C2:
; H071+$000002C2: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_000002C6:
; H071+$000002C6: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_000002CA:
; H071+$000002CA: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_000002CE:
; H071+$000002CE: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_000002D2:
; H071+$000002D2: e542  asl.w #$2, d2
        asl.w #$2, d2
L071_000002D4:
; H071+$000002D4: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L071_000002DA:
; H071+$000002DA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_000002DC:
; H071+$000002DC: 4227  clr.b -(a7)
        clr.b -(a7)
L071_000002DE:
; H071+$000002DE: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_000002E2:
; H071+$000002E2: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_000002E6:
; H071+$000002E6: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_000002EA:
; H071+$000002EA: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_000002F0:
; H071+$000002F0: 4e75  rts 
        rts 
L071_000002F2:
; H071+$000002F2: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_000002F6:
; H071+$000002F6: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_000002FA:
; H071+$000002FA: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_000002FE:
; H071+$000002FE: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000302:
; H071+$00000302: e742  asl.w #$3, d2
        asl.w #$3, d2
L071_00000304:
; H071+$00000304: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L071_0000030A:
; H071+$0000030A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_0000030C:
; H071+$0000030C: 4227  clr.b -(a7)
        clr.b -(a7)
L071_0000030E:
; H071+$0000030E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_00000312:
; H071+$00000312: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000316:
; H071+$00000316: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_0000031A:
; H071+$0000031A: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_00000320:
; H071+$00000320: 4e75  rts 
        rts 
L071_00000322:
; H071+$00000322: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000326:
; H071+$00000326: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L071_0000032A:
; H071+$0000032A: 7400  moveq #$0, d2
        moveq #0, d2
L071_0000032C:
; H071+$0000032C: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_00000330:
; H071+$00000330: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000334:
; H071+$00000334: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_00000336:
; H071+$00000336: 4227  clr.b -(a7)
        clr.b -(a7)
L071_00000338:
; H071+$00000338: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_0000033C:
; H071+$0000033C: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_00000340:
; H071+$00000340: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L071_00000344:
; H071+$00000344: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L071_0000034A:
; H071+$0000034A: 4e75  rts 
        rts 
; Preserved bytes H071+$0000034C..$0000035C; code/data not fully classified.
        dc.w $FFD4,$FE7C,$FEAE,$FEE0,$FF12,$FF44,$FF74,$FFA4
L071_0000035C:
; H071+$0000035C: 47fafff0  lea.l $34e(pc), a3
        lea.l H071+$34E(pc), a3
L071_00000360:
; H071+$00000360: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L071_00000364:
; H071+$00000364: 6302  bls.b $368
        bls.b H071+$368
L071_00000366:
; H071+$00000366: 74ff  moveq #$ff, d2
        moveq #-1, d2
L071_00000368:
; H071+$00000368: e342  asl.w #$1, d2
        asl.w #$1, d2
L071_0000036A:
; H071+$0000036A: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H071+$034E; indici 0..6, default -1.
L071_0000036E:
; H071+$0000036E: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L071_00000372:
; H071+$00000372: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_00000376:
; H071+$00000376: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H026+$000C (trampoline_H026_0014)
L071_0000037A:
; H071+$0000037A: 4eb90000000c  jsr $c.l
        jsr (H026+$C).l
L071_00000380:
; H071+$00000380: 3b40ffd6  move.w d0, -$2a(a5)
        move.w d0, -$2a(a5)
L071_00000384:
; H071+$00000384: 426dffd4  clr.w -$2c(a5)
        clr.w -$2c(a5)
L071_00000388:
; H071+$00000388: 342dffd6  move.w -$2a(a5), d2
        move.w -$2a(a5), d2
L071_0000038C:
; H071+$0000038C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L071_0000038E:
; H071+$0000038E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L071_00000390:
; H071+$00000390: 342dffd4  move.w -$2c(a5), d2
        move.w -$2c(a5), d2
L071_00000394:
; H071+$00000394: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L071_00000396:
; H071+$00000396: 6200001e  bhi.w $3b6
        bhi.w H071+$3B6
L071_0000039A:
; H071+$0000039A: 342dffd4  move.w -$2c(a5), d2
        move.w -$2c(a5), d2
L071_0000039E:
; H071+$0000039E: 47edffd8  lea.l -$28(a5), a3
        lea.l -$28(a5), a3
L071_000003A2:
; H071+$000003A2: 382dffd4  move.w -$2c(a5), d4
        move.w -$2c(a5), d4
L071_000003A6:
; H071+$000003A6: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L071_000003AA:
; H071+$000003AA: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L071_000003B0:
; H071+$000003B0: 526dffd4  addq.w #$1, -$2c(a5)
        addq.w #$1, -$2c(a5)
L071_000003B4:
; H071+$000003B4: 64da  bcc.b $390
        bcc.b H071+$390
L071_000003B6:
; H071+$000003B6: 548f  addq.l #$2, a7
        addq.l #$2, a7
L071_000003B8:
; H071+$000003B8: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_000003BC:
; H071+$000003BC: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L071_000003C0:
; H071+$000003C0: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L071_000003C4:
; H071+$000003C4: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
; -> H026+$0188 (sub_H026_00000188)
L071_000003C8:
; H071+$000003C8: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L071_000003CE:
; H071+$000003CE: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_000003D2:
; H071+$000003D2: 2b6b002cfff8  move.l $2c(a3), -$8(a5)
        move.l $2c(a3), -$8(a5)
L071_000003D8:
; H071+$000003D8: 6000fd62  bra.w $13c
        bra.w H071+$13C
L071_000003DC:
; H071+$000003DC: 2b7900002a3afffc  move.l $2a3a.l, -$4(a5)
        move.l (H005+$2A3A).l, -$4(a5)
L071_000003E4:
; H071+$000003E4: 423900002483  clr.b $2483.l
        clr.b (H005+$2483).l
L071_000003EA:
; H071+$000003EA: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L071_000003EE:
; H071+$000003EE: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L071_000003F2:
; H071+$000003F2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L071_000003F6:
; H071+$000003F6: 486c0008  pea.l $8(a4)
        pea.l $8(a4)
L071_000003FA:
; H071+$000003FA: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L071_000003FE:
; H071+$000003FE: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_00000402:
; H071+$00000402: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L071_00000406:
; H071+$00000406: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L071_0000040A:
; H071+$0000040A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L071_0000040E:
; H071+$0000040E: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L071_00000412:
; H071+$00000412: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L071_00000416:
; H071+$00000416: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L071_0000041A:
; H071+$0000041A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L071_0000041E:
; H071+$0000041E: 486cffff  pea.l -$1(a4)
        pea.l -$1(a4)
L071_00000422:
; H071+$00000422: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L071_00000426:
; H071+$00000426: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H008+$13C0 (trampoline_H008_1AF4)
L071_0000042A:
; H071+$0000042A: 4eb9000013c0  jsr $13c0.l
        jsr (H008+$13C0).l
L071_00000430:
; H071+$00000430: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L071_00000434:
; H071+$00000434: 1680  move.b d0, (a3)
        move.b d0, (a3)
L071_00000436:
; H071+$00000436: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L071_0000043A:
; H071+$0000043A: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L071_0000043E:
; H071+$0000043E: 2493  move.l (a3), (a2)
        move.l (a3), (a2)
L071_00000440:
; H071+$00000440: 2b7900002a3afff8  move.l $2a3a.l, -$8(a5)
        move.l (H005+$2A3A).l, -$8(a5)
L071_00000448:
; H071+$00000448: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L071_0000044C:
; H071+$0000044C: 67000022  beq.w $470
        beq.w H071+$470
L071_00000450:
; H071+$00000450: 42a7  clr.l -(a7)
        clr.l -(a7)
L071_00000452:
; H071+$00000452: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L071_00000456:
; H071+$00000456: 4267  clr.w -(a7)
        clr.w -(a7)
L071_00000458:
; H071+$00000458: 4267  clr.w -(a7)
        clr.w -(a7)
L071_0000045A:
; H071+$0000045A: 4227  clr.b -(a7)
        clr.b -(a7)
L071_0000045C:
; H071+$0000045C: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$09B2 (sub_H063_000009B2)
L071_0000045E:
; H071+$0000045E: 4eb9000009b2  jsr $9b2.l
        jsr (H063+$9B2).l
L071_00000464:
; H071+$00000464: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_00000468:
; H071+$00000468: 2b6b002cfff8  move.l $2c(a3), -$8(a5)
        move.l $2c(a3), -$8(a5)
L071_0000046E:
; H071+$0000046E: 60d8  bra.b $448
        bra.b H071+$448
L071_00000470:
; H071+$00000470: 4e5d  unlk a5
        unlk a5
L071_00000472:
; H071+$00000472: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L071_00000474:
; H071+$00000474: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L071_00000476:
; H071+$00000476: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L071_0000047A:
; H071+$0000047A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H071_0000047C [parziale]
; Scopo: Routine del modulo negozio e acquisto di oggetti; richiama H065+$32F6, H063+$1D44, H003+$0068, H063+$13BE.
;   - Richiama H065+$32F6.
;   - Richiama H063+$1D44.
;   - Richiama H003+$0068.
;   - Richiama H063+$13BE.
;   - Usa lo stato globale: H005+$3368 (personaggio corrente).
; Chiamanti diretti: H070+$1918, H071+$06FA, H071+$081C, H070+$0EEC
; --------------------------------------------------------------------------
L071_0000047C:
; H071+$0000047C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L071_0000047E:
; H071+$0000047E: 287afc98  movea.l $118(pc), a4
        movea.l H071+$118(pc), a4
L071_00000482:
; H071+$00000482: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
; STATO: H005+$3368 = personaggio corrente
L071_00000486:
; H071+$00000486: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
L071_0000048C:
; H071+$0000048C: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H065+$32F6 (sub_H065_000032F6)
L071_00000490:
; H071+$00000490: 4eb9000032f6  jsr $32f6.l
        jsr (H065+$32F6).l
L071_00000496:
; H071+$00000496: 1400  move.b d0, d2
        move.b d0, d2
L071_00000498:
; H071+$00000498: 4a02  tst.b d2
        tst.b d2
L071_0000049A:
; H071+$0000049A: 6700001c  beq.w $4b8
        beq.w H071+$4B8
L071_0000049E:
; H071+$0000049E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_000004A2:
; H071+$000004A2: 486c000c  pea.l $c(a4)
        pea.l $c(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L071_000004A6:
; H071+$000004A6: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L071_000004AC:
; H071+$000004AC: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L071_000004B0:
; H071+$000004B0: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L071_000004B4:
; H071+$000004B4: 600000b2  bra.w $568
        bra.w H071+$568
L071_000004B8:
; H071+$000004B8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L071_000004BC:
; H071+$000004BC: 4213  clr.b (a3)
        clr.b (a3)
; STATO: H005+$3368 = personaggio corrente
L071_000004BE:
; H071+$000004BE: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L071_000004C4:
; H071+$000004C4: 2b6b0150fffc  move.l $150(a3), -$4(a5)
        move.l $150(a3), -$4(a5)
L071_000004CA:
; H071+$000004CA: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L071_000004CE:
; H071+$000004CE: 6600003e  bne.w $50e
        bne.w H071+$50E
L071_000004D2:
; H071+$000004D2: 7448  moveq #$48, d2
        moveq #72, d2
L071_000004D4:
; H071+$000004D4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_000004D6:
; H071+$000004D6: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L071_000004DC:
; H071+$000004DC: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L071_000004E2:
; H071+$000004E2: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L071_000004E6:
; H071+$000004E6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L071_000004EA:
; H071+$000004EA: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L071_000004EE:
; H071+$000004EE: 7411  moveq #$11, d2
        moveq #17, d2
L071_000004F0:
; H071+$000004F0: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L071_000004F2:
; H071+$000004F2: 51cafffc  dbra d2, $4f0
        dbra d2, H071+$4F0
L071_000004F6:
; H071+$000004F6: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_000004FA:
; H071+$000004FA: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
; STATO: H005+$3368 = personaggio corrente
L071_000004FE:
; H071+$000004FE: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L071_00000504:
; H071+$00000504: 276dfffc0150  move.l -$4(a5), $150(a3)
        move.l -$4(a5), $150(a3)
L071_0000050A:
; H071+$0000050A: 60000050  bra.w $55c
        bra.w H071+$55C
L071_0000050E:
; H071+$0000050E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000512:
; H071+$00000512: 4aab002c  tst.l $2c(a3)
        tst.l $2c(a3)
L071_00000516:
; H071+$00000516: 6700000e  beq.w $526
        beq.w H071+$526
L071_0000051A:
; H071+$0000051A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_0000051E:
; H071+$0000051E: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L071_00000524:
; H071+$00000524: 60e8  bra.b $50e
        bra.b H071+$50E
L071_00000526:
; H071+$00000526: 7448  moveq #$48, d2
        moveq #72, d2
L071_00000528:
; H071+$00000528: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L071_0000052A:
; H071+$0000052A: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L071_00000530:
; H071+$00000530: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L071_00000536:
; H071+$00000536: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L071_0000053A:
; H071+$0000053A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L071_0000053E:
; H071+$0000053E: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L071_00000542:
; H071+$00000542: 7411  moveq #$11, d2
        moveq #17, d2
L071_00000544:
; H071+$00000544: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L071_00000546:
; H071+$00000546: 51cafffc  dbra d2, $544
        dbra d2, H071+$544
L071_0000054A:
; H071+$0000054A: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L071_0000054E:
; H071+$0000054E: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L071_00000552:
; H071+$00000552: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000556:
; H071+$00000556: 276dfff8002c  move.l -$8(a5), $2c(a3)
        move.l -$8(a5), $2c(a3)
; STATO: H005+$3368 = personaggio corrente
L071_0000055C:
; H071+$0000055C: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$13BE (sub_H063_000013BE)
L071_00000562:
; H071+$00000562: 4eb9000013be  jsr $13be.l
        jsr (H063+$13BE).l
L071_00000568:
; H071+$00000568: 4e5d  unlk a5
        unlk a5
L071_0000056A:
; H071+$0000056A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L071_0000056C:
; H071+$0000056C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L071_0000056E:
; H071+$0000056E: 508f  addq.l #$8, a7
        addq.l #$8, a7
L071_00000570:
; H071+$00000570: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H071_00000572 [parziale]
; Scopo: Routine del modulo negozio e acquisto di oggetti; richiama H044+$01C2, H029+$0354, H065+$347E, H067+$032A.
;   - Richiama H044+$01C2.
;   - Richiama H029+$0354.
;   - Richiama H065+$347E.
;   - Richiama H067+$032A.
;   - Richiama H026+$0188.
;   - Richiama H026+$01E0.
;   - Richiama H063+$1D44.
;   - Usa lo stato globale: H005+$3E00 (puntatore stato persistente B, 2048 byte); H005+$3368 (personaggio corrente).
; Chiamanti diretti: H071+$0A3A
; --------------------------------------------------------------------------
L071_00000572:
; H071+$00000572: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L071_00000574:
; H071+$00000574: 287afba2  movea.l $118(pc), a4
        movea.l H071+$118(pc), a4
L071_00000578:
; H071+$00000578: 4e55ffe6  link.w a5, #$ffe6
        link.w a5, #$ffe6
L071_0000057C:
; H071+$0000057C: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L071_00000580:
; H071+$00000580: 2b7900002a3affe8  move.l $2a3a.l, -$18(a5)
        move.l (H005+$2A3A).l, -$18(a5)
L071_00000588:
; H071+$00000588: 426dffe6  clr.w -$1a(a5)
        clr.w -$1a(a5)
L071_0000058C:
; H071+$0000058C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L071_00000590:
; H071+$00000590: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
L071_00000596:
; H071+$00000596: 197c0001ffff  move.b #$1, -$1(a4)
        move.b #$1, -$1(a4)
L071_0000059C:
; H071+$0000059C: 486dfffb  pea.l -$5(a5)
        pea.l -$5(a5)
L071_000005A0:
; H071+$000005A0: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
L071_000005A4:
; H071+$000005A4: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
L071_000005A8:
; H071+$000005A8: 486dffe6  pea.l -$1a(a5)
        pea.l -$1a(a5)
L071_000005AC:
; H071+$000005AC: 6100fb7c  bsr.w $12a
        bsr.w H071+$12A
L071_000005B0:
; H071+$000005B0: 0c2d0042fffb  cmpi.b #$42, -$5(a5)
        cmpi.b #$42, -$5(a5)
L071_000005B6:
; H071+$000005B6: 67000016  beq.w $5ce
        beq.w H071+$5CE
L071_000005BA:
; H071+$000005BA: 0c2d000dfffb  cmpi.b #$d, -$5(a5)
        cmpi.b #$d, -$5(a5)
L071_000005C0:
; H071+$000005C0: 6700000c  beq.w $5ce
        beq.w H071+$5CE
L071_000005C4:
; H071+$000005C4: 1b7c0001fffa  move.b #$1, -$6(a5)
        move.b #$1, -$6(a5)
L071_000005CA:
; H071+$000005CA: 60000352  bra.w $91e
        bra.w H071+$91E
L071_000005CE:
; H071+$000005CE: 422dfffa  clr.b -$6(a5)
        clr.b -$6(a5)
L071_000005D2:
; H071+$000005D2: 426dfff2  clr.w -$e(a5)
        clr.w -$e(a5)
L071_000005D6:
; H071+$000005D6: 0c6d0007fff2  cmpi.w #$7, -$e(a5)
        cmpi.w #$7, -$e(a5)
L071_000005DC:
; H071+$000005DC: 62000042  bhi.w $620
        bhi.w H071+$620
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L071_000005E0:
; H071+$000005E0: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L071_000005E6:
; H071+$000005E6: 342b06da  move.w $6da(a3), d2
        move.w $6da(a3), d2
L071_000005EA:
; H071+$000005EA: 7800  moveq #$0, d4
        moveq #0, d4
L071_000005EC:
; H071+$000005EC: 986dfff2  sub.w -$e(a5), d4
        sub.w -$e(a5), d4
L071_000005F0:
; H071+$000005F0: 4a44  tst.w d4
        tst.w d4
L071_000005F2:
; H071+$000005F2: 6a06  bpl.b $5fa
        bpl.b H071+$5FA
L071_000005F4:
; H071+$000005F4: 4444  neg.w d4
        neg.w d4
L071_000005F6:
; H071+$000005F6: e82a  lsr.b d4, d2
        lsr.b d4, d2
L071_000005F8:
; H071+$000005F8: 6002  bra.b $5fc
        bra.b H071+$5FC
L071_000005FA:
; H071+$000005FA: e92a  lsl.b d4, d2
        lsl.b d4, d2
L071_000005FC:
; H071+$000005FC: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L071_000005FE:
; H071+$000005FE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L071_00000602:
; H071+$00000602: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L071_00000608:
; H071+$00000608: 1400  move.b d0, d2
        move.b d0, d2
L071_0000060A:
; H071+$0000060A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L071_0000060E:
; H071+$0000060E: 4a42  tst.w d2
        tst.w d2
L071_00000610:
; H071+$00000610: 63000008  bls.w $61a
        bls.w H071+$61A
L071_00000614:
; H071+$00000614: 3b6dfff2fff4  move.w -$e(a5), -$c(a5)
        move.w -$e(a5), -$c(a5)
L071_0000061A:
; H071+$0000061A: 526dfff2  addq.w #$1, -$e(a5)
        addq.w #$1, -$e(a5)
L071_0000061E:
; H071+$0000061E: 64b6  bcc.b $5d6
        bcc.b H071+$5D6
L071_00000620:
; H071+$00000620: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L071_00000624:
; H071+$00000624: 6000009a  bra.w $6c0
        bra.w H071+$6C0
L071_00000628:
; H071+$00000628: 7400  moveq #$0, d2
        moveq #0, d2
L071_0000062A:
; H071+$0000062A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_0000062E:
; H071+$0000062E: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000632:
; H071+$00000632: e84a  lsr.w #$4, d2
        lsr.w #$4, d2
L071_00000634:
; H071+$00000634: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L071_00000638:
; H071+$00000638: 4e75  rts 
        rts 
L071_0000063A:
; H071+$0000063A: 7400  moveq #$0, d2
        moveq #0, d2
L071_0000063C:
; H071+$0000063C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000640:
; H071+$00000640: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000644:
; H071+$00000644: e64a  lsr.w #$3, d2
        lsr.w #$3, d2
L071_00000646:
; H071+$00000646: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L071_0000064A:
; H071+$0000064A: 4e75  rts 
        rts 
L071_0000064C:
; H071+$0000064C: 7400  moveq #$0, d2
        moveq #0, d2
L071_0000064E:
; H071+$0000064E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000652:
; H071+$00000652: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000656:
; H071+$00000656: e44a  lsr.w #$2, d2
        lsr.w #$2, d2
L071_00000658:
; H071+$00000658: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L071_0000065C:
; H071+$0000065C: 4e75  rts 
        rts 
L071_0000065E:
; H071+$0000065E: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000660:
; H071+$00000660: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000664:
; H071+$00000664: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000668:
; H071+$00000668: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L071_0000066A:
; H071+$0000066A: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L071_0000066E:
; H071+$0000066E: 4e75  rts 
        rts 
L071_00000670:
; H071+$00000670: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000674:
; H071+$00000674: 3b6b0042fff8  move.w $42(a3), -$8(a5)
        move.w $42(a3), -$8(a5)
L071_0000067A:
; H071+$0000067A: 4e75  rts 
        rts 
L071_0000067C:
; H071+$0000067C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000680:
; H071+$00000680: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000684:
; H071+$00000684: e342  asl.w #$1, d2
        asl.w #$1, d2
L071_00000686:
; H071+$00000686: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L071_0000068A:
; H071+$0000068A: 4e75  rts 
        rts 
L071_0000068C:
; H071+$0000068C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000690:
; H071+$00000690: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_00000694:
; H071+$00000694: e542  asl.w #$2, d2
        asl.w #$2, d2
L071_00000696:
; H071+$00000696: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L071_0000069A:
; H071+$0000069A: 4e75  rts 
        rts 
L071_0000069C:
; H071+$0000069C: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_000006A0:
; H071+$000006A0: 342b0042  move.w $42(a3), d2
        move.w $42(a3), d2
L071_000006A4:
; H071+$000006A4: e742  asl.w #$3, d2
        asl.w #$3, d2
L071_000006A6:
; H071+$000006A6: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L071_000006AA:
; H071+$000006AA: 4e75  rts 
        rts 
L071_000006AC:
; H071+$000006AC: 4e75  rts 
        rts 
; Preserved bytes H071+$000006AE..$000006C0; code/data not fully classified.
        dc.w $FFFC,$FF78,$FF8A,$FF9C,$FFAE,$FFC0,$FFCC,$FFDC
        dc.w $FFEC
L071_000006C0:
; H071+$000006C0: 47faffee  lea.l $6b0(pc), a3
        lea.l H071+$6B0(pc), a3
L071_000006C4:
; H071+$000006C4: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L071_000006C8:
; H071+$000006C8: 6302  bls.b $6cc
        bls.b H071+$6CC
L071_000006CA:
; H071+$000006CA: 74ff  moveq #$ff, d2
        moveq #-1, d2
L071_000006CC:
; H071+$000006CC: e342  asl.w #$1, d2
        asl.w #$1, d2
L071_000006CE:
; H071+$000006CE: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H071+$06B0; indici 0..7, default -1.
L071_000006D2:
; H071+$000006D2: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
; STATO: H005+$3368 = personaggio corrente
L071_000006D6:
; H071+$000006D6: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H065+$347E (sub_H065_0000347E)
L071_000006DC:
; H071+$000006DC: 4eb90000347e  jsr $347e.l
        jsr (H065+$347E).l
L071_000006E2:
; H071+$000006E2: 3b40fff6  move.w d0, -$a(a5)
        move.w d0, -$a(a5)
L071_000006E6:
; H071+$000006E6: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L071_000006EA:
; H071+$000006EA: b46dfff6  cmp.w -$a(a5), d2
        cmp.w -$a(a5), d2
L071_000006EE:
; H071+$000006EE: 620000f8  bhi.w $7e8
        bhi.w H071+$7E8
L071_000006F2:
; H071+$000006F2: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L071_000006F6:
; H071+$000006F6: 486dffed  pea.l -$13(a5)
        pea.l -$13(a5)
L071_000006FA:
; H071+$000006FA: 6100fd80  bsr.w $47c
        bsr.w H071+$47C
L071_000006FE:
; H071+$000006FE: 4a2dffed  tst.b -$13(a5)
        tst.b -$13(a5)
L071_00000702:
; H071+$00000702: 660000e0  bne.w $7e4
        bne.w H071+$7E4
L071_00000706:
; H071+$00000706: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L071_0000070A:
; H071+$0000070A: 946dfff8  sub.w -$8(a5), d2
        sub.w -$8(a5), d2
L071_0000070E:
; H071+$0000070E: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L071_00000712:
; H071+$00000712: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
; -> H067+$032A (sub_H067_0000032A)
L071_00000716:
; H071+$00000716: 4eb90000032a  jsr $32a.l
        jsr (H067+$32A).l
L071_0000071C:
; H071+$0000071C: 7400  moveq #$0, d2
        moveq #0, d2
L071_0000071E:
; H071+$0000071E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_00000722:
; H071+$00000722: 142b0040  move.b $40(a3), d2
        move.b $40(a3), d2
L071_00000726:
; H071+$00000726: 4a42  tst.w d2
        tst.w d2
L071_00000728:
; H071+$00000728: 63000060  bls.w $78a
        bls.w H071+$78A
L071_0000072C:
; H071+$0000072C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_00000730:
; H071+$00000730: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_00000736:
; H071+$00000736: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; STATO: H005+$3368 = personaggio corrente
L071_0000073A:
; H071+$0000073A: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H026+$0188 (sub_H026_00000188)
L071_00000740:
; H071+$00000740: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L071_00000746:
; H071+$00000746: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_0000074A:
; H071+$0000074A: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_00000750:
; H071+$00000750: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L071_00000754:
; H071+$00000754: 486c0017  pea.l $17(a4)
        pea.l $17(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L071_00000758:
; H071+$00000758: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_0000075E:
; H071+$0000075E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_00000762:
; H071+$00000762: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_00000768:
; H071+$00000768: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_0000076C:
; H071+$0000076C: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L071_00000770:
; H071+$00000770: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_00000776:
; H071+$00000776: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_0000077A:
; H071+$0000077A: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
; -> H063+$1D44 (sub_H063_00001D44)
L071_00000780:
; H071+$00000780: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L071_00000786:
; H071+$00000786: 6000005c  bra.w $7e4
        bra.w H071+$7E4
L071_0000078A:
; H071+$0000078A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_0000078E:
; H071+$0000078E: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_00000794:
; H071+$00000794: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; STATO: H005+$3368 = personaggio corrente
L071_00000798:
; H071+$00000798: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H026+$0188 (sub_H026_00000188)
L071_0000079E:
; H071+$0000079E: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L071_000007A4:
; H071+$000007A4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_000007A8:
; H071+$000007A8: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_000007AE:
; H071+$000007AE: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L071_000007B2:
; H071+$000007B2: 486c001e  pea.l $1e(a4)
        pea.l $1e(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L071_000007B6:
; H071+$000007B6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_000007BC:
; H071+$000007BC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_000007C0:
; H071+$000007C0: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_000007C6:
; H071+$000007C6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_000007CA:
; H071+$000007CA: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L071_000007CE:
; H071+$000007CE: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_000007D4:
; H071+$000007D4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_000007D8:
; H071+$000007D8: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
; -> H063+$1D44 (sub_H063_00001D44)
L071_000007DE:
; H071+$000007DE: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L071_000007E4:
; H071+$000007E4: 60000138  bra.w $91e
        bra.w H071+$91E
L071_000007E8:
; H071+$000007E8: 4fefffe4  lea.l -$1c(a7), a7
        lea.l -$1c(a7), a7
L071_000007EC:
; H071+$000007EC: 47f900002a1e  lea.l $2a1e.l, a3
        lea.l (H005+$2A1E).l, a3
L071_000007F2:
; H071+$000007F2: 45d7  lea.l (a7), a2
        lea.l (a7), a2
L071_000007F4:
; H071+$000007F4: 7406  moveq #$6, d2
        moveq #6, d2
L071_000007F6:
; H071+$000007F6: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L071_000007F8:
; H071+$000007F8: 51cafffc  dbra d2, $7f6
        dbra d2, H071+$7F6
; -> H067+$02AE (sub_H067_000002AE)
L071_000007FC:
; H071+$000007FC: 4eb9000002ae  jsr $2ae.l
        jsr (H067+$2AE).l
L071_00000802:
; H071+$00000802: 2b40ffee  move.l d0, -$12(a5)
        move.l d0, -$12(a5)
L071_00000806:
; H071+$00000806: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000808:
; H071+$00000808: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L071_0000080C:
; H071+$0000080C: b4adffee  cmp.l -$12(a5), d2
        cmp.l -$12(a5), d2
L071_00000810:
; H071+$00000810: 6e0000fe  bgt.w $910
        bgt.w H071+$910
L071_00000814:
; H071+$00000814: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L071_00000818:
; H071+$00000818: 486dffed  pea.l -$13(a5)
        pea.l -$13(a5)
L071_0000081C:
; H071+$0000081C: 6100fc5e  bsr.w $47c
        bsr.w H071+$47C
L071_00000820:
; H071+$00000820: 4a2dffed  tst.b -$13(a5)
        tst.b -$13(a5)
L071_00000824:
; H071+$00000824: 660000e6  bne.w $90c
        bne.w H071+$90C
L071_00000828:
; H071+$00000828: 7400  moveq #$0, d2
        moveq #0, d2
L071_0000082A:
; H071+$0000082A: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L071_0000082E:
; H071+$0000082E: 282dffee  move.l -$12(a5), d4
        move.l -$12(a5), d4
L071_00000832:
; H071+$00000832: 9882  sub.l d2, d4
        sub.l d2, d4
L071_00000834:
; H071+$00000834: 2b44ffee  move.l d4, -$12(a5)
        move.l d4, -$12(a5)
L071_00000838:
; H071+$00000838: 242dffee  move.l -$12(a5), d2
        move.l -$12(a5), d2
L071_0000083C:
; H071+$0000083C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H067+$0374 (sub_H067_00000374)
L071_0000083E:
; H071+$0000083E: 4eb900000374  jsr $374.l
        jsr (H067+$374).l
L071_00000844:
; H071+$00000844: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000846:
; H071+$00000846: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L071_0000084A:
; H071+$0000084A: 142b0040  move.b $40(a3), d2
        move.b $40(a3), d2
L071_0000084E:
; H071+$0000084E: 4a42  tst.w d2
        tst.w d2
L071_00000850:
; H071+$00000850: 63000060  bls.w $8b2
        bls.w H071+$8B2
L071_00000854:
; H071+$00000854: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_00000858:
; H071+$00000858: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_0000085E:
; H071+$0000085E: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; STATO: H005+$3368 = personaggio corrente
L071_00000862:
; H071+$00000862: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H026+$0188 (sub_H026_00000188)
L071_00000868:
; H071+$00000868: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L071_0000086E:
; H071+$0000086E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_00000872:
; H071+$00000872: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_00000878:
; H071+$00000878: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L071_0000087C:
; H071+$0000087C: 486c0027  pea.l $27(a4)
        pea.l $27(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L071_00000880:
; H071+$00000880: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_00000886:
; H071+$00000886: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_0000088A:
; H071+$0000088A: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_00000890:
; H071+$00000890: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_00000894:
; H071+$00000894: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L071_00000898:
; H071+$00000898: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_0000089E:
; H071+$0000089E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_000008A2:
; H071+$000008A2: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
; -> H063+$1D44 (sub_H063_00001D44)
L071_000008A8:
; H071+$000008A8: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L071_000008AE:
; H071+$000008AE: 6000005c  bra.w $90c
        bra.w H071+$90C
L071_000008B2:
; H071+$000008B2: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_000008B6:
; H071+$000008B6: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_000008BC:
; H071+$000008BC: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; STATO: H005+$3368 = personaggio corrente
L071_000008C0:
; H071+$000008C0: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H026+$0188 (sub_H026_00000188)
L071_000008C6:
; H071+$000008C6: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L071_000008CC:
; H071+$000008CC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_000008D0:
; H071+$000008D0: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_000008D6:
; H071+$000008D6: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L071_000008DA:
; H071+$000008DA: 486c002e  pea.l $2e(a4)
        pea.l $2e(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L071_000008DE:
; H071+$000008DE: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_000008E4:
; H071+$000008E4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_000008E8:
; H071+$000008E8: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
L071_000008EE:
; H071+$000008EE: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_000008F2:
; H071+$000008F2: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L071_000008F6:
; H071+$000008F6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L071_000008FC:
; H071+$000008FC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L071_00000900:
; H071+$00000900: 487900003c82  pea.l $3c82.l
        pea.l (H005+$3C82).l
; -> H063+$1D44 (sub_H063_00001D44)
L071_00000906:
; H071+$00000906: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L071_0000090C:
; H071+$0000090C: 60000010  bra.w $91e
        bra.w H071+$91E
L071_00000910:
; H071+$00000910: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L071_00000914:
; H071+$00000914: 486c0037  pea.l $37(a4)
        pea.l $37(a4)
; -> H063+$1D44 (sub_H063_00001D44)
L071_00000918:
; H071+$00000918: 4eb900001d44  jsr $1d44.l
        jsr (H063+$1D44).l
L071_0000091E:
; H071+$0000091E: 4a2dfffa  tst.b -$6(a5)
        tst.b -$6(a5)
L071_00000922:
; H071+$00000922: 6700fc78  beq.w $59c
        beq.w H071+$59C
L071_00000926:
; H071+$00000926: 4e5d  unlk a5
        unlk a5
L071_00000928:
; H071+$00000928: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L071_0000092A:
; H071+$0000092A: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H071_0000092C [parziale]
; Scopo: Routine del modulo negozio e acquisto di oggetti; richiama H063+$321A, H063+$0D80, H029+$0312, H063+$09B2.
;   - Richiama H063+$321A.
;   - Richiama H063+$0D80.
;   - Richiama H029+$0312.
;   - Richiama H063+$09B2.
;   - Richiama H067+$11F4.
;   - Richiama H026+$0188.
;   - Richiama H008+$01FC.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento); H005+$3368 (personaggio corrente).
; Chiamanti diretti: H012+$07D8
; --------------------------------------------------------------------------
L071_0000092C:
; H071+$0000092C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L071_0000092E:
; H071+$0000092E: 287af7e8  movea.l $118(pc), a4
        movea.l H071+$118(pc), a4
L071_00000932:
; H071+$00000932: 4e55ffc8  link.w a5, #$ffc8
        link.w a5, #$ffc8
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L071_00000936:
; H071+$00000936: 13fc000100003de3  move.b #$1, $3de3.l
        move.b #$1, (H005+$3DE3).l
L071_0000093E:
; H071+$0000093E: 4239000024c2  clr.b $24c2.l
        clr.b (H005+$24C2).l
; -> H063+$321A (trampoline_H063_3384)
L071_00000944:
; H071+$00000944: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L071_0000094A:
; H071+$0000094A: 13fc0001000024c2  move.b #$1, $24c2.l
        move.b #$1, (H005+$24C2).l
; STATO: H005+$3368 = personaggio corrente
L071_00000952:
; H071+$00000952: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L071_00000958:
; H071+$00000958: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L071_0000095E:
; H071+$0000095E: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L071_00000962:
; H071+$00000962: 487900002a1e  pea.l $2a1e.l
        pea.l (H005+$2A1E).l
L071_00000968:
; H071+$00000968: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L071_0000096C:
; H071+$0000096C: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L071_0000096E:
; H071+$0000096E: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L071_00000974:
; H071+$00000974: 47ec0049  lea.l $49(a4), a3
        lea.l $49(a4), a3
L071_00000978:
; H071+$00000978: 45edffd4  lea.l -$2c(a5), a2
        lea.l -$2c(a5), a2
L071_0000097C:
; H071+$0000097C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L071_0000097E:
; H071+$0000097E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L071_00000980:
; H071+$00000980: 4239000024e3  clr.b $24e3.l
        clr.b (H005+$24E3).l
L071_00000986:
; H071+$00000986: 422dffd2  clr.b -$2e(a5)
        clr.b -$2e(a5)
L071_0000098A:
; H071+$0000098A: 2b7900002a3affc8  move.l $2a3a.l, -$38(a5)
        move.l (H005+$2A3A).l, -$38(a5)
L071_00000992:
; H071+$00000992: 4aadffc8  tst.l -$38(a5)
        tst.l -$38(a5)
L071_00000996:
; H071+$00000996: 67000022  beq.w $9ba
        beq.w H071+$9BA
L071_0000099A:
; H071+$0000099A: 42a7  clr.l -(a7)
        clr.l -(a7)
L071_0000099C:
; H071+$0000099C: 2f2dffc8  move.l -$38(a5), -(a7)
        move.l -$38(a5), -(a7)
L071_000009A0:
; H071+$000009A0: 4267  clr.w -(a7)
        clr.w -(a7)
L071_000009A2:
; H071+$000009A2: 4267  clr.w -(a7)
        clr.w -(a7)
L071_000009A4:
; H071+$000009A4: 4227  clr.b -(a7)
        clr.b -(a7)
L071_000009A6:
; H071+$000009A6: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$09B2 (sub_H063_000009B2)
L071_000009A8:
; H071+$000009A8: 4eb9000009b2  jsr $9b2.l
        jsr (H063+$9B2).l
L071_000009AE:
; H071+$000009AE: 266dffc8  movea.l -$38(a5), a3
        movea.l -$38(a5), a3
L071_000009B2:
; H071+$000009B2: 2b6b002cffc8  move.l $2c(a3), -$38(a5)
        move.l $2c(a3), -$38(a5)
L071_000009B8:
; H071+$000009B8: 60d8  bra.b $992
        bra.b H071+$992
L071_000009BA:
; H071+$000009BA: 486dffd0  pea.l -$30(a5)
        pea.l -$30(a5)
L071_000009BE:
; H071+$000009BE: 486dffcf  pea.l -$31(a5)
        pea.l -$31(a5)
; -> H067+$11F4 (sub_H067_000011F4)
L071_000009C2:
; H071+$000009C2: 4eb9000011f4  jsr $11f4.l
        jsr (H067+$11F4).l
L071_000009C8:
; H071+$000009C8: 4a2dffd0  tst.b -$30(a5)
        tst.b -$30(a5)
L071_000009CC:
; H071+$000009CC: 6700001c  beq.w $9ea
        beq.w H071+$9EA
L071_000009D0:
; H071+$000009D0: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_000009D4:
; H071+$000009D4: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L071_000009D8:
; H071+$000009D8: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L071_000009DC:
; H071+$000009DC: 486c004b  pea.l $4b(a4)
        pea.l $4b(a4)
; -> H026+$0188 (sub_H026_00000188)
L071_000009E0:
; H071+$000009E0: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L071_000009E6:
; H071+$000009E6: 60000018  bra.w $a00
        bra.w H071+$A00
L071_000009EA:
; H071+$000009EA: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_000009EE:
; H071+$000009EE: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L071_000009F2:
; H071+$000009F2: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L071_000009F6:
; H071+$000009F6: 486c0072  pea.l $72(a4)
        pea.l $72(a4)
; -> H026+$0188 (sub_H026_00000188)
L071_000009FA:
; H071+$000009FA: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L071_00000A00:
; H071+$00000A00: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L071_00000A04:
; H071+$00000A04: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L071_00000A08:
; H071+$00000A08: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_00000A0C:
; H071+$00000A0C: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L071_00000A10:
; H071+$00000A10: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L071_00000A14:
; H071+$00000A14: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_00000A18:
; H071+$00000A18: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L071_00000A1C:
; H071+$00000A1C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L071_00000A20:
; H071+$00000A20: 4227  clr.b -(a7)
        clr.b -(a7)
L071_00000A22:
; H071+$00000A22: 486dffd3  pea.l -$2d(a5)
        pea.l -$2d(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L071_00000A26:
; H071+$00000A26: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L071_00000A2C:
; H071+$00000A2C: 1b40ffd1  move.b d0, -$2f(a5)
        move.b d0, -$2f(a5)
L071_00000A30:
; H071+$00000A30: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000A32:
; H071+$00000A32: 142dffd1  move.b -$2f(a5), d2
        move.b -$2f(a5), d2
L071_00000A36:
; H071+$00000A36: 60000162  bra.w $b9a
        bra.w H071+$B9A
L071_00000A3A:
; H071+$00000A3A: 6100fb36  bsr.w $572
        bsr.w H071+$572
L071_00000A3E:
; H071+$00000A3E: 4e75  rts 
        rts 
L071_00000A40:
; H071+$00000A40: 486dffd3  pea.l -$2d(a5)
        pea.l -$2d(a5)
; -> H065+$196E (sub_H065_0000196E)
L071_00000A44:
; H071+$00000A44: 4eb90000196e  jsr $196e.l
        jsr (H065+$196E).l
L071_00000A4A:
; H071+$00000A4A: 4e75  rts 
        rts 
; -> H067+$0F72 (sub_H067_00000F72)
L071_00000A4C:
; H071+$00000A4C: 4eb900000f72  jsr $f72.l
        jsr (H067+$F72).l
L071_00000A52:
; H071+$00000A52: 4e75  rts 
        rts 
L071_00000A54:
; H071+$00000A54: 4a2dffd3  tst.b -$2d(a5)
        tst.b -$2d(a5)
L071_00000A58:
; H071+$00000A58: 6600000c  bne.w $a66
        bne.w H071+$A66
; -> H067+$0794 (sub_H067_00000794)
L071_00000A5C:
; H071+$00000A5C: 4eb900000794  jsr $794.l
        jsr (H067+$794).l
L071_00000A62:
; H071+$00000A62: 6000000c  bra.w $a70
        bra.w H071+$A70
L071_00000A66:
; H071+$00000A66: 1f2dffd1  move.b -$2f(a5), -(a7)
        move.b -$2f(a5), -(a7)
; -> H065+$3390 (trampoline_H065_3474)
L071_00000A6A:
; H071+$00000A6A: 4eb900003390  jsr $3390.l
        jsr (H065+$3390).l
L071_00000A70:
; H071+$00000A70: 4e75  rts 
        rts 
; -> H067+$08CC (sub_H067_000008CC)
L071_00000A72:
; H071+$00000A72: 4eb9000008cc  jsr $8cc.l
        jsr (H067+$8CC).l
L071_00000A78:
; H071+$00000A78: 4e75  rts 
        rts 
L071_00000A7A:
; H071+$00000A7A: 486dffcd  pea.l -$33(a5)
        pea.l -$33(a5)
; -> H067+$1D7C (sub_H067_00001D7C)
L071_00000A7E:
; H071+$00000A7E: 4eb900001d7c  jsr $1d7c.l
        jsr (H067+$1D7C).l
L071_00000A84:
; H071+$00000A84: 4e75  rts 
        rts 
L071_00000A86:
; H071+$00000A86: 486dffd0  pea.l -$30(a5)
        pea.l -$30(a5)
L071_00000A8A:
; H071+$00000A8A: 486dffcf  pea.l -$31(a5)
        pea.l -$31(a5)
; -> H067+$11F4 (sub_H067_000011F4)
L071_00000A8E:
; H071+$00000A8E: 4eb9000011f4  jsr $11f4.l
        jsr (H067+$11F4).l
L071_00000A94:
; H071+$00000A94: 4a2dffd0  tst.b -$30(a5)
        tst.b -$30(a5)
L071_00000A98:
; H071+$00000A98: 670000bc  beq.w $b56
        beq.w H071+$B56
L071_00000A9C:
; H071+$00000A9C: 47ec008e  lea.l $8e(a4), a3
        lea.l $8e(a4), a3
L071_00000AA0:
; H071+$00000AA0: 45edffd6  lea.l -$2a(a5), a2
        lea.l -$2a(a5), a2
L071_00000AA4:
; H071+$00000AA4: 7428  moveq #$28, d2
        moveq #40, d2
L071_00000AA6:
; H071+$00000AA6: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L071_00000AA8:
; H071+$00000AA8: 57cafffc  dbeq d2, $aa6
        dbeq d2, H071+$AA6
L071_00000AAC:
; H071+$00000AAC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L071_00000AB0:
; H071+$00000AB0: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L071_00000AB4:
; H071+$00000AB4: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L071_00000AB8:
; H071+$00000AB8: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L071_00000ABC:
; H071+$00000ABC: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_00000AC0:
; H071+$00000AC0: 4267  clr.w -(a7)
        clr.w -(a7)
L071_00000AC2:
; H071+$00000AC2: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L071_00000AC6:
; H071+$00000AC6: 3f3c0052  move.w #$52, -(a7)
        move.w #$52, -(a7)
L071_00000ACA:
; H071+$00000ACA: 486c0097  pea.l $97(a4)
        pea.l $97(a4)
; -> H030+$0302 (trampoline_H030_0470)
L071_00000ACE:
; H071+$00000ACE: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L071_00000AD4:
; H071+$00000AD4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L071_00000AD8:
; H071+$00000AD8: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L071_00000ADC:
; H071+$00000ADC: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L071_00000AE0:
; H071+$00000AE0: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L071_00000AE4:
; H071+$00000AE4: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L071_00000AE8:
; H071+$00000AE8: 4267  clr.w -(a7)
        clr.w -(a7)
L071_00000AEA:
; H071+$00000AEA: 4227  clr.b -(a7)
        clr.b -(a7)
L071_00000AEC:
; H071+$00000AEC: 3f3c002a  move.w #$2a, -(a7)
        move.w #$2a, -(a7)
L071_00000AF0:
; H071+$00000AF0: 486c00ea  pea.l $ea(a4)
        pea.l $ea(a4)
; -> H030+$0302 (trampoline_H030_0470)
L071_00000AF4:
; H071+$00000AF4: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L071_00000AFA:
; H071+$00000AFA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L071_00000AFE:
; H071+$00000AFE: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L071_00000B02:
; H071+$00000B02: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L071_00000B06:
; H071+$00000B06: 486dffd6  pea.l -$2a(a5)
        pea.l -$2a(a5)
L071_00000B0A:
; H071+$00000B0A: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L071_00000B0E:
; H071+$00000B0E: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L071_00000B12:
; H071+$00000B12: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L071_00000B16:
; H071+$00000B16: 4227  clr.b -(a7)
        clr.b -(a7)
L071_00000B18:
; H071+$00000B18: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H061+$36E6 (sub_H061_000036E6)
L071_00000B1A:
; H071+$00000B1A: 4eb9000036e6  jsr $36e6.l
        jsr (H061+$36E6).l
L071_00000B20:
; H071+$00000B20: 1b40ffce  move.b d0, -$32(a5)
        move.b d0, -$32(a5)
L071_00000B24:
; H071+$00000B24: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000B26:
; H071+$00000B26: 142dffce  move.b -$32(a5), d2
        move.b -$32(a5), d2
L071_00000B2A:
; H071+$00000B2A: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L071_00000B2E:
; H071+$00000B2E: 6600000c  bne.w $b3c
        bne.w H071+$B3C
L071_00000B32:
; H071+$00000B32: 1b7c0001ffd2  move.b #$1, -$2e(a5)
        move.b #$1, -$2e(a5)
L071_00000B38:
; H071+$00000B38: 60000018  bra.w $b52
        bra.w H071+$B52
L071_00000B3C:
; H071+$00000B3C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L071_00000B40:
; H071+$00000B40: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L071_00000B44:
; H071+$00000B44: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L071_00000B48:
; H071+$00000B48: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L071_00000B4C:
; H071+$00000B4C: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L071_00000B52:
; H071+$00000B52: 60000008  bra.w $b5c
        bra.w H071+$B5C
L071_00000B56:
; H071+$00000B56: 1b7c0001ffd2  move.b #$1, -$2e(a5)
        move.b #$1, -$2e(a5)
L071_00000B5C:
; H071+$00000B5C: 4e75  rts 
        rts 
L071_00000B5E:
; H071+$00000B5E: 1f2dffd1  move.b -$2f(a5), -(a7)
        move.b -$2f(a5), -(a7)
; -> H065+$3390 (trampoline_H065_3474)
L071_00000B62:
; H071+$00000B62: 4eb900003390  jsr $3390.l
        jsr (H065+$3390).l
L071_00000B68:
; H071+$00000B68: 4e75  rts 
        rts 
L071_00000B6A:
; H071+$00000B6A: 4e75  rts 
        rts 
; Preserved bytes H071+$00000B6C..$00000B9A; code/data not fully classified.
        dc.w $FFFC,$FF0C,$FECC,$FFFC,$FFFC,$FF18,$FFFC,$FFFC
        dc.w $FFF0,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FEE6,$FFFC,$FFFC,$FF04,$FEDE,$FFFC,$FED2
L071_00000B9A:
; H071+$00000B9A: 47faffd2  lea.l $b6e(pc), a3
        lea.l H071+$B6E(pc), a3
L071_00000B9E:
; H071+$00000B9E: 04420041  subi.w #$41, d2
        subi.w #$41, d2
L071_00000BA2:
; H071+$00000BA2: 0c420015  cmpi.w #$15, d2
        cmpi.w #$15, d2
L071_00000BA6:
; H071+$00000BA6: 6302  bls.b $baa
        bls.b H071+$BAA
L071_00000BA8:
; H071+$00000BA8: 74ff  moveq #$ff, d2
        moveq #-1, d2
L071_00000BAA:
; H071+$00000BAA: e342  asl.w #$1, d2
        asl.w #$1, d2
L071_00000BAC:
; H071+$00000BAC: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H071+$0B6E; indici 0..21, default -1.
L071_00000BB0:
; H071+$00000BB0: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L071_00000BB4:
; H071+$00000BB4: 7400  moveq #$0, d2
        moveq #0, d2
L071_00000BB6:
; H071+$00000BB6: 142dffd1  move.b -$2f(a5), d2
        move.b -$2f(a5), d2
L071_00000BBA:
; H071+$00000BBA: 60000046  bra.w $c02
        bra.w H071+$C02
; -> H063+$321A (trampoline_H063_3384)
L071_00000BBE:
; H071+$00000BBE: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L071_00000BC4:
; H071+$00000BC4: 4e75  rts 
        rts 
L071_00000BC6:
; H071+$00000BC6: 4a2dffcd  tst.b -$33(a5)
        tst.b -$33(a5)
L071_00000BCA:
; H071+$00000BCA: 67000008  beq.w $bd4
        beq.w H071+$BD4
; -> H063+$321A (trampoline_H063_3384)
L071_00000BCE:
; H071+$00000BCE: 4eb90000321a  jsr $321a.l
        jsr (H063+$321A).l
L071_00000BD4:
; H071+$00000BD4: 4e75  rts 
        rts 
L071_00000BD6:
; H071+$00000BD6: 4e75  rts 
        rts 
; Preserved bytes H071+$00000BD8..$00000C02; code/data not fully classified.
        dc.w $FFFC,$FFEC,$FFE4,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFE4
L071_00000C02:
; H071+$00000C02: 47faffd6  lea.l $bda(pc), a3
        lea.l H071+$BDA(pc), a3
L071_00000C06:
; H071+$00000C06: 04420041  subi.w #$41, d2
        subi.w #$41, d2
L071_00000C0A:
; H071+$00000C0A: 0c420013  cmpi.w #$13, d2
        cmpi.w #$13, d2
L071_00000C0E:
; H071+$00000C0E: 6302  bls.b $c12
        bls.b H071+$C12
L071_00000C10:
; H071+$00000C10: 74ff  moveq #$ff, d2
        moveq #-1, d2
L071_00000C12:
; H071+$00000C12: e342  asl.w #$1, d2
        asl.w #$1, d2
L071_00000C14:
; H071+$00000C14: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H071+$0BDA; indici 0..19, default -1.
L071_00000C18:
; H071+$00000C18: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
; STATO: H005+$3368 = personaggio corrente
L071_00000C1C:
; H071+$00000C1C: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L071_00000C22:
; H071+$00000C22: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L071_00000C28:
; H071+$00000C28: 4a2dffd2  tst.b -$2e(a5)
        tst.b -$2e(a5)
L071_00000C2C:
; H071+$00000C2C: 6700fd8c  beq.w $9ba
        beq.w H071+$9BA
L071_00000C30:
; H071+$00000C30: 4e5d  unlk a5
        unlk a5
L071_00000C32:
; H071+$00000C32: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L071_00000C34:
; H071+$00000C34: 4e75  rts 
        rts 
L071_00000C36:
; H071+$00000C36: 4e5d  unlk a5
        unlk a5
L071_00000C38:
; H071+$00000C38: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L071_00000C3A:
; H071+$00000C3A: 4e75  rts 
        rts 
; End H071: $C3C bytes
