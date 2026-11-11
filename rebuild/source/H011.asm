; ============================================================================
; GUIDA DEL MODULO H011
; Griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Mappa e vista 3D: carica GEO<gruppo>.dax e WALLDEF<gruppo>.dax, indicizza la griglia 16x16 con y*16+x e compone la vista. I dati GEO hanno 256 byte per area; i WALLDEF sono blocchi da 780 o 1560 byte.
; --------------------------------------------------------------------------
; H011: 7004 original bytes; all offsets are section-relative.
        section H011,code
H011:
; Preserved bytes H011+$00000000..$000000FE; code/data not fully classified.
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
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$5741,$4C4C
        dc.w $4445,$4600,$2E64,$6178,$0055,$6E61,$626C,$6520
        dc.w $746F,$206C,$6F61,$6420,$0020,$6672,$6F6D,$2000
        dc.w $4745,$4F00,$2E64,$6178,$0055,$6E61,$626C,$6520
        dc.w $746F,$206C,$6F61,$6420,$6765,$6F20,$696E,$204C
        dc.w $6F61,$6433,$444D,$6170,$2E00
        dc.l H011+$000000AC
; --------------------------------------------------------------------------
; ROUTINE: module_init_H011 [parziale]
; Scopo: Ingresso del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H011+$1A02.
; Chiamanti diretti: H000+$0180
; --------------------------------------------------------------------------
L011_000000FE:
; H011+$000000FE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_00000100:
; H011+$00000100: 287afff8  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_00000104:
; H011+$00000104: 4e550000  link.w a5, #$0
        link.w a5, #$0
L011_00000108:
; H011+$00000108: 600018f8  bra.w $1a02
        bra.w H011+$1A02
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_0000010C [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; richiama H003+$0090, H022+$0084.
;   - Richiama H003+$0090.
;   - Richiama H022+$0084.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H007+$0BAE, H011+$14DC
; --------------------------------------------------------------------------
L011_0000010C:
; H011+$0000010C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_0000010E:
; H011+$0000010E: 287affea  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_00000112:
; H011+$00000112: 4e550000  link.w a5, #$0
        link.w a5, #$0
L011_00000116:
; H011+$00000116: 47f9000052ae  lea.l $52ae.l, a3
        lea.l (H005+$52AE).l, a3
L011_0000011C:
; H011+$0000011C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_0000011E:
; H011+$0000011E: 47ecff54  lea.l -$ac(a4), a3
        lea.l -$ac(a4), a3
L011_00000122:
; H011+$00000122: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_00000124:
; H011+$00000124: 2f3c00000040  move.l #$40, -(a7)
        move.l #$40, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L011_0000012A:
; H011+$0000012A: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L011_00000130:
; H011+$00000130: 397c0aaaff76  move.w #$aaa, -$8a(a4)
        move.w #$aaa, -$8a(a4)
L011_00000136:
; H011+$00000136: 397c0555ff78  move.w #$555, -$88(a4)
        move.w #$555, -$88(a4)
L011_0000013C:
; H011+$0000013C: 397c0fffff7a  move.w #$fff, -$86(a4)
        move.w #$fff, -$86(a4)
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L011_00000142:
; H011+$00000142: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L011_00000148:
; H011+$00000148: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L011_0000014C:
; H011+$0000014C: 47ecff54  lea.l -$ac(a4), a3
        lea.l -$ac(a4), a3
L011_00000150:
; H011+$00000150: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_00000152:
; H011+$00000152: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L011_00000156:
; H011+$00000156: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L011_0000015C:
; H011+$0000015C: 4e5d  unlk a5
        unlk a5
L011_0000015E:
; H011+$0000015E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_00000160:
; H011+$00000160: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_00000162 [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H011+$04F4, H011+$01BC, H011+$0C88, H011+$0DDC, H011+$09DA
; --------------------------------------------------------------------------
L011_00000162:
; H011+$00000162: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_00000164:
; H011+$00000164: 287aff94  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_00000168:
; H011+$00000168: 4e550000  link.w a5, #$0
        link.w a5, #$0
L011_0000016C:
; H011+$0000016C: 0c6d000f000e  cmpi.w #$f, $e(a5)
        cmpi.w #$f, $e(a5)
L011_00000172:
; H011+$00000172: 6e00001c  bgt.w $190
        bgt.w H011+$190
L011_00000176:
; H011+$00000176: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L011_0000017A:
; H011+$0000017A: 6d000014  blt.w $190
        blt.w H011+$190
L011_0000017E:
; H011+$0000017E: 0c6d000f000c  cmpi.w #$f, $c(a5)
        cmpi.w #$f, $c(a5)
L011_00000184:
; H011+$00000184: 6e00000a  bgt.w $190
        bgt.w H011+$190
L011_00000188:
; H011+$00000188: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L011_0000018C:
; H011+$0000018C: 6c00000c  bge.w $19a
        bge.w H011+$19A
L011_00000190:
; H011+$00000190: 7000  moveq #$0, d0
        moveq #0, d0
L011_00000192:
; H011+$00000192: 6000000c  bra.w $1a0
        bra.w H011+$1A0
; Preserved bytes H011+$00000196..$0000019A; code/data not fully classified.
        dc.w $6000,$0008
L011_0000019A:
; H011+$0000019A: 7001  moveq #$1, d0
        moveq #1, d0
L011_0000019C:
; H011+$0000019C: 60000002  bra.w $1a0
        bra.w H011+$1A0
L011_000001A0:
; H011+$000001A0: 4e5d  unlk a5
        unlk a5
L011_000001A2:
; H011+$000001A2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_000001A4:
; H011+$000001A4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_000001A6:
; H011+$000001A6: 588f  addq.l #$4, a7
        addq.l #$4, a7
L011_000001A8:
; H011+$000001A8: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Map_QueryWall [verificato; bit completi ancora parziali]
; Scopo: Interroga un valore di parete/cella nella mappa 16x16 per la direzione richiesta.
;   - Normalizza le due coordinate nel range 0..15 nei percorsi previsti.
;   - Calcola l’indice y*16+x nel buffer H005+$282A.
;   - I rami selezionano nibble/bit dei dati di mappa in base alla direzione.
;   - La routine non definisce da sola tutte le regole di attraversabilità.
; Chiamanti diretti: H011+$03E2, H011+$03FE, H011+$041A, H011+$0436, H011+$0A5C, H011+$0C78, H011+$0CA0, H011+$0D36, H011+$0DCC, H011+$0DF4 ...
; --------------------------------------------------------------------------
L011_000001AA:
; H011+$000001AA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_000001AC:
; H011+$000001AC: 287aff4c  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_000001B0:
; H011+$000001B0: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L011_000001B4:
; H011+$000001B4: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L011_000001B8:
; H011+$000001B8: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L011_000001BC:
; H011+$000001BC: 61a4  bsr.b $162
        bsr.b H011+$162
L011_000001BE:
; H011+$000001BE: 1400  move.b d0, d2
        move.b d0, d2
L011_000001C0:
; H011+$000001C0: 4a02  tst.b d2
        tst.b d2
L011_000001C2:
; H011+$000001C2: 66000026  bne.w $1ea
        bne.w H011+$1EA
L011_000001C6:
; H011+$000001C6: 7400  moveq #$0, d2
        moveq #0, d2
L011_000001C8:
; H011+$000001C8: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
L011_000001CE:
; H011+$000001CE: 4a42  tst.w d2
        tst.w d2
L011_000001D0:
; H011+$000001D0: 67000012  beq.w $1e4
        beq.w H011+$1E4
L011_000001D4:
; H011+$000001D4: 7400  moveq #$0, d2
        moveq #0, d2
L011_000001D6:
; H011+$000001D6: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
L011_000001DC:
; H011+$000001DC: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L011_000001E0:
; H011+$000001E0: 66000008  bne.w $1ea
        bne.w H011+$1EA
L011_000001E4:
; H011+$000001E4: 7000  moveq #$0, d0
        moveq #0, d0
L011_000001E6:
; H011+$000001E6: 6000013e  bra.w $326
        bra.w H011+$326
L011_000001EA:
; H011+$000001EA: 0c6d000f0010  cmpi.w #$f, $10(a5)
        cmpi.w #$f, $10(a5)
L011_000001F0:
; H011+$000001F0: 6f00000a  ble.w $1fc
        ble.w H011+$1FC
L011_000001F4:
; H011+$000001F4: 426d0010  clr.w $10(a5)
        clr.w $10(a5)
L011_000001F8:
; H011+$000001F8: 60000010  bra.w $20a
        bra.w H011+$20A
L011_000001FC:
; H011+$000001FC: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L011_00000200:
; H011+$00000200: 6c000008  bge.w $20a
        bge.w H011+$20A
L011_00000204:
; H011+$00000204: 3b7c000f0010  move.w #$f, $10(a5)
        move.w #$f, $10(a5)
L011_0000020A:
; H011+$0000020A: 0c6d000f000e  cmpi.w #$f, $e(a5)
        cmpi.w #$f, $e(a5)
L011_00000210:
; H011+$00000210: 6f00000a  ble.w $21c
        ble.w H011+$21C
L011_00000214:
; H011+$00000214: 426d000e  clr.w $e(a5)
        clr.w $e(a5)
L011_00000218:
; H011+$00000218: 60000010  bra.w $22a
        bra.w H011+$22A
L011_0000021C:
; H011+$0000021C: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L011_00000220:
; H011+$00000220: 6c000008  bge.w $22a
        bge.w H011+$22A
L011_00000224:
; H011+$00000224: 3b7c000f000e  move.w #$f, $e(a5)
        move.w #$f, $e(a5)
L011_0000022A:
; H011+$0000022A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_0000022E:
; H011+$0000022E: 600000d8  bra.w $308
        bra.w H011+$308
; PASSO: Indice della griglia: una coordinata viene moltiplicata per 16, poi si aggiunge l’altra.
L011_00000232:
; H011+$00000232: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000236:
; H011+$00000236: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000238:
; H011+$00000238: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_0000023E:
; H011+$0000023E: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_00000242:
; H011+$00000242: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00000246:
; H011+$00000246: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_0000024A:
; H011+$0000024A: 3f3c00f0  move.w #$f0, -(a7)
        move.w #$f0, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_0000024E:
; H011+$0000024E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_00000254:
; H011+$00000254: 1400  move.b d0, d2
        move.b d0, d2
L011_00000256:
; H011+$00000256: e80a  lsr.b #$4, d2
        lsr.b #$4, d2
L011_00000258:
; H011+$00000258: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_0000025C:
; H011+$0000025C: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_00000260:
; H011+$00000260: 4e75  rts 
        rts 
L011_00000262:
; H011+$00000262: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000266:
; H011+$00000266: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000268:
; H011+$00000268: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_0000026E:
; H011+$0000026E: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_00000272:
; H011+$00000272: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00000276:
; H011+$00000276: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_0000027A:
; H011+$0000027A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_0000027E:
; H011+$0000027E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_00000284:
; H011+$00000284: 1400  move.b d0, d2
        move.b d0, d2
L011_00000286:
; H011+$00000286: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_0000028A:
; H011+$0000028A: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_0000028E:
; H011+$0000028E: 4e75  rts 
        rts 
L011_00000290:
; H011+$00000290: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000294:
; H011+$00000294: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000296:
; H011+$00000296: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_0000029C:
; H011+$0000029C: 47eb0100  lea.l $100(a3), a3
        lea.l $100(a3), a3
L011_000002A0:
; H011+$000002A0: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_000002A4:
; H011+$000002A4: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_000002A8:
; H011+$000002A8: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_000002AC:
; H011+$000002AC: 3f3c00f0  move.w #$f0, -(a7)
        move.w #$f0, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_000002B0:
; H011+$000002B0: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_000002B6:
; H011+$000002B6: 1400  move.b d0, d2
        move.b d0, d2
L011_000002B8:
; H011+$000002B8: e80a  lsr.b #$4, d2
        lsr.b #$4, d2
L011_000002BA:
; H011+$000002BA: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_000002BE:
; H011+$000002BE: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_000002C2:
; H011+$000002C2: 4e75  rts 
        rts 
L011_000002C4:
; H011+$000002C4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_000002C8:
; H011+$000002C8: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_000002CA:
; H011+$000002CA: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_000002D0:
; H011+$000002D0: 47eb0100  lea.l $100(a3), a3
        lea.l $100(a3), a3
L011_000002D4:
; H011+$000002D4: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_000002D8:
; H011+$000002D8: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_000002DC:
; H011+$000002DC: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_000002E0:
; H011+$000002E0: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_000002E4:
; H011+$000002E4: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_000002EA:
; H011+$000002EA: 1400  move.b d0, d2
        move.b d0, d2
L011_000002EC:
; H011+$000002EC: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_000002F0:
; H011+$000002F0: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_000002F4:
; H011+$000002F4: 4e75  rts 
        rts 
L011_000002F6:
; H011+$000002F6: 4e75  rts 
        rts 
; Preserved bytes H011+$000002F8..$00000308; code/data not fully classified.
        dc.w $FFFC,$FF38,$FFFC,$FF68,$FFFC,$FF96,$FFFC,$FFCA
L011_00000308:
; H011+$00000308: 47fafff0  lea.l $2fa(pc), a3
        lea.l H011+$2FA(pc), a3
L011_0000030C:
; H011+$0000030C: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L011_00000310:
; H011+$00000310: 6302  bls.b $314
        bls.b H011+$314
L011_00000312:
; H011+$00000312: 74ff  moveq #$ff, d2
        moveq #-1, d2
L011_00000314:
; H011+$00000314: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000316:
; H011+$00000316: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H011+$02FA; indici 0..6, default -1.
L011_0000031A:
; H011+$0000031A: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L011_0000031E:
; H011+$0000031E: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L011_00000322:
; H011+$00000322: 60000002  bra.w $326
        bra.w H011+$326
L011_00000326:
; H011+$00000326: 4e5d  unlk a5
        unlk a5
L011_00000328:
; H011+$00000328: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_0000032A:
; H011+$0000032A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_0000032C:
; H011+$0000032C: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L011_0000032E:
; H011+$0000032E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_00000330 [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; richiama H034+$0178.
;   - Richiama H034+$0178.
; Chiamanti diretti: H011+$0BA4
; --------------------------------------------------------------------------
L011_00000330:
; H011+$00000330: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_00000332:
; H011+$00000332: 287afdc6  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_00000336:
; H011+$00000336: 4e55ff9c  link.w a5, #$ff9c
        link.w a5, #$ff9c
L011_0000033A:
; H011+$0000033A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L011_0000033E:
; H011+$0000033E: 5b42  subq.w #$5, d2
        subq.w #$5, d2
L011_00000340:
; H011+$00000340: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L011_00000344:
; H011+$00000344: 4a6dfff6  tst.w -$a(a5)
        tst.w -$a(a5)
L011_00000348:
; H011+$00000348: 6c000006  bge.w $350
        bge.w H011+$350
L011_0000034C:
; H011+$0000034C: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L011_00000350:
; H011+$00000350: 0c6d0005fff6  cmpi.w #$5, -$a(a5)
        cmpi.w #$5, -$a(a5)
L011_00000356:
; H011+$00000356: 6f000008  ble.w $360
        ble.w H011+$360
L011_0000035A:
; H011+$0000035A: 3b7c0005fff6  move.w #$5, -$a(a5)
        move.w #$5, -$a(a5)
L011_00000360:
; H011+$00000360: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L011_00000364:
; H011+$00000364: 946dfff6  sub.w -$a(a5), d2
        sub.w -$a(a5), d2
L011_00000368:
; H011+$00000368: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_0000036C:
; H011+$0000036C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000370:
; H011+$00000370: 5b42  subq.w #$5, d2
        subq.w #$5, d2
L011_00000372:
; H011+$00000372: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L011_00000376:
; H011+$00000376: 4a6dfff4  tst.w -$c(a5)
        tst.w -$c(a5)
L011_0000037A:
; H011+$0000037A: 6c000006  bge.w $382
        bge.w H011+$382
L011_0000037E:
; H011+$0000037E: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L011_00000382:
; H011+$00000382: 0c6d0005fff4  cmpi.w #$5, -$c(a5)
        cmpi.w #$5, -$c(a5)
L011_00000388:
; H011+$00000388: 6f000008  ble.w $392
        ble.w H011+$392
L011_0000038C:
; H011+$0000038C: 3b7c0005fff4  move.w #$5, -$c(a5)
        move.w #$5, -$c(a5)
L011_00000392:
; H011+$00000392: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000396:
; H011+$00000396: 946dfff4  sub.w -$c(a5), d2
        sub.w -$c(a5), d2
L011_0000039A:
; H011+$0000039A: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L011_0000039E:
; H011+$0000039E: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L011_000003A2:
; H011+$000003A2: 0c6d000afff8  cmpi.w #$a, -$8(a5)
        cmpi.w #$a, -$8(a5)
L011_000003A8:
; H011+$000003A8: 6e0000ca  bgt.w $474
        bgt.w H011+$474
L011_000003AC:
; H011+$000003AC: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_000003B0:
; H011+$000003B0: d46dfff4  add.w -$c(a5), d2
        add.w -$c(a5), d2
L011_000003B4:
; H011+$000003B4: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L011_000003B8:
; H011+$000003B8: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L011_000003BC:
; H011+$000003BC: 0c6d000afffa  cmpi.w #$a, -$6(a5)
        cmpi.w #$a, -$6(a5)
L011_000003C2:
; H011+$000003C2: 6e0000a8  bgt.w $46c
        bgt.w H011+$46C
L011_000003C6:
; H011+$000003C6: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_000003CA:
; H011+$000003CA: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L011_000003CE:
; H011+$000003CE: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L011_000003D2:
; H011+$000003D2: 3b7c0104ffee  move.w #$104, -$12(a5)
        move.w #$104, -$12(a5)
L011_000003D8:
; H011+$000003D8: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L011_000003DC:
; H011+$000003DC: 3f2dfff0  move.w -$10(a5), -(a7)
        move.w -$10(a5), -(a7)
L011_000003E0:
; H011+$000003E0: 4267  clr.w -(a7)
        clr.w -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_000003E2:
; H011+$000003E2: 6100fdc6  bsr.w $1aa
        bsr.w H011+$1AA
L011_000003E6:
; H011+$000003E6: 3400  move.w d0, d2
        move.w d0, d2
L011_000003E8:
; H011+$000003E8: 4a42  tst.w d2
        tst.w d2
L011_000003EA:
; H011+$000003EA: 63000006  bls.w $3f2
        bls.w H011+$3F2
L011_000003EE:
; H011+$000003EE: 526dffee  addq.w #$1, -$12(a5)
        addq.w #$1, -$12(a5)
L011_000003F2:
; H011+$000003F2: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L011_000003F6:
; H011+$000003F6: 3f2dfff0  move.w -$10(a5), -(a7)
        move.w -$10(a5), -(a7)
L011_000003FA:
; H011+$000003FA: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_000003FE:
; H011+$000003FE: 6100fdaa  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000402:
; H011+$00000402: 3400  move.w d0, d2
        move.w d0, d2
L011_00000404:
; H011+$00000404: 4a42  tst.w d2
        tst.w d2
L011_00000406:
; H011+$00000406: 63000006  bls.w $40e
        bls.w H011+$40E
L011_0000040A:
; H011+$0000040A: 546dffee  addq.w #$2, -$12(a5)
        addq.w #$2, -$12(a5)
L011_0000040E:
; H011+$0000040E: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L011_00000412:
; H011+$00000412: 3f2dfff0  move.w -$10(a5), -(a7)
        move.w -$10(a5), -(a7)
L011_00000416:
; H011+$00000416: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_0000041A:
; H011+$0000041A: 6100fd8e  bsr.w $1aa
        bsr.w H011+$1AA
L011_0000041E:
; H011+$0000041E: 3400  move.w d0, d2
        move.w d0, d2
L011_00000420:
; H011+$00000420: 4a42  tst.w d2
        tst.w d2
L011_00000422:
; H011+$00000422: 63000006  bls.w $42a
        bls.w H011+$42A
L011_00000426:
; H011+$00000426: 586dffee  addq.w #$4, -$12(a5)
        addq.w #$4, -$12(a5)
L011_0000042A:
; H011+$0000042A: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L011_0000042E:
; H011+$0000042E: 3f2dfff0  move.w -$10(a5), -(a7)
        move.w -$10(a5), -(a7)
L011_00000432:
; H011+$00000432: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000436:
; H011+$00000436: 6100fd72  bsr.w $1aa
        bsr.w H011+$1AA
L011_0000043A:
; H011+$0000043A: 3400  move.w d0, d2
        move.w d0, d2
L011_0000043C:
; H011+$0000043C: 4a42  tst.w d2
        tst.w d2
L011_0000043E:
; H011+$0000043E: 63000006  bls.w $446
        bls.w H011+$446
L011_00000442:
; H011+$00000442: 506dffee  addq.w #$8, -$12(a5)
        addq.w #$8, -$12(a5)
L011_00000446:
; H011+$00000446: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_0000044A:
; H011+$0000044A: 5642  addq.w #$3, d2
        addq.w #$3, d2
L011_0000044C:
; H011+$0000044C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_0000044E:
; H011+$0000044E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_00000452:
; H011+$00000452: 5642  addq.w #$3, d2
        addq.w #$3, d2
L011_00000454:
; H011+$00000454: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000456:
; H011+$00000456: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_0000045A:
; H011+$0000045A: 4227  clr.b -(a7)
        clr.b -(a7)
L011_0000045C:
; H011+$0000045C: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L011_0000045E:
; H011+$0000045E: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L011_00000464:
; H011+$00000464: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L011_00000468:
; H011+$00000468: 6800ff52  bvc.w $3bc
        bvc.w H011+$3BC
L011_0000046C:
; H011+$0000046C: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L011_00000470:
; H011+$00000470: 6800ff30  bvc.w $3a2
        bvc.w H011+$3A2
L011_00000474:
; H011+$00000474: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000478:
; H011+$00000478: 5642  addq.w #$3, d2
        addq.w #$3, d2
L011_0000047A:
; H011+$0000047A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_0000047C:
; H011+$0000047C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00000480:
; H011+$00000480: 5642  addq.w #$3, d2
        addq.w #$3, d2
L011_00000482:
; H011+$00000482: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000484:
; H011+$00000484: 7400  moveq #$0, d2
        moveq #0, d2
L011_00000486:
; H011+$00000486: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_0000048A:
; H011+$0000048A: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L011_0000048C:
; H011+$0000048C: 06420100  addi.w #$100, d2
        addi.w #$100, d2
L011_00000490:
; H011+$00000490: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000492:
; H011+$00000492: 4227  clr.b -(a7)
        clr.b -(a7)
L011_00000494:
; H011+$00000494: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L011_00000496:
; H011+$00000496: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L011_0000049C:
; H011+$0000049C: 4e5d  unlk a5
        unlk a5
L011_0000049E:
; H011+$0000049E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_000004A0:
; H011+$000004A0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_000004A2:
; H011+$000004A2: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L011_000004A4:
; H011+$000004A4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_000004A6 [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H001+$0210
; --------------------------------------------------------------------------
L011_000004A6:
; H011+$000004A6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_000004A8:
; H011+$000004A8: 287afc50  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_000004AC:
; H011+$000004AC: 4e550000  link.w a5, #$0
        link.w a5, #$0
L011_000004B0:
; H011+$000004B0: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L011_000004B4:
; H011+$000004B4: 13c200002829  move.b d2, $2829.l
        move.b d2, (H005+$2829).l
L011_000004BA:
; H011+$000004BA: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L011_000004BE:
; H011+$000004BE: 13c200002828  move.b d2, $2828.l
        move.b d2, (H005+$2828).l
L011_000004C4:
; H011+$000004C4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_000004C8:
; H011+$000004C8: 13c200002827  move.b d2, $2827.l
        move.b d2, (H005+$2827).l
L011_000004CE:
; H011+$000004CE: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_000004D2:
; H011+$000004D2: 13c200002826  move.b d2, $2826.l
        move.b d2, (H005+$2826).l
L011_000004D8:
; H011+$000004D8: 4e5d  unlk a5
        unlk a5
L011_000004DA:
; H011+$000004DA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_000004DC:
; H011+$000004DC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_000004DE:
; H011+$000004DE: 508f  addq.l #$8, a7
        addq.l #$8, a7
L011_000004E0:
; H011+$000004E0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_000004E2 [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; opera su H005+$282A (puntatore ai quattro piani dati GEO).
;   - Usa lo stato globale: H005+$282A (puntatore ai quattro piani dati GEO).
; Chiamanti diretti: H060+$00BE, H012+$3062, H011+$05D6, H012+$2772, H068+$0AD8, H061+$3C10 e altri 1
; --------------------------------------------------------------------------
L011_000004E2:
; H011+$000004E2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_000004E4:
; H011+$000004E4: 287afc14  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_000004E8:
; H011+$000004E8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L011_000004EC:
; H011+$000004EC: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L011_000004F0:
; H011+$000004F0: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L011_000004F4:
; H011+$000004F4: 6100fc6c  bsr.w $162
        bsr.w H011+$162
L011_000004F8:
; H011+$000004F8: 1400  move.b d0, d2
        move.b d0, d2
L011_000004FA:
; H011+$000004FA: 4a02  tst.b d2
        tst.b d2
L011_000004FC:
; H011+$000004FC: 66000026  bne.w $524
        bne.w H011+$524
L011_00000500:
; H011+$00000500: 7400  moveq #$0, d2
        moveq #0, d2
L011_00000502:
; H011+$00000502: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
L011_00000508:
; H011+$00000508: 4a42  tst.w d2
        tst.w d2
L011_0000050A:
; H011+$0000050A: 67000012  beq.w $51e
        beq.w H011+$51E
L011_0000050E:
; H011+$0000050E: 7400  moveq #$0, d2
        moveq #0, d2
L011_00000510:
; H011+$00000510: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
L011_00000516:
; H011+$00000516: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L011_0000051A:
; H011+$0000051A: 66000008  bne.w $524
        bne.w H011+$524
L011_0000051E:
; H011+$0000051E: 7000  moveq #$0, d0
        moveq #0, d0
L011_00000520:
; H011+$00000520: 60000062  bra.w $584
        bra.w H011+$584
L011_00000524:
; H011+$00000524: 0c6d000f000e  cmpi.w #$f, $e(a5)
        cmpi.w #$f, $e(a5)
L011_0000052A:
; H011+$0000052A: 6f00000a  ble.w $536
        ble.w H011+$536
L011_0000052E:
; H011+$0000052E: 426d000e  clr.w $e(a5)
        clr.w $e(a5)
L011_00000532:
; H011+$00000532: 60000010  bra.w $544
        bra.w H011+$544
L011_00000536:
; H011+$00000536: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L011_0000053A:
; H011+$0000053A: 6c000008  bge.w $544
        bge.w H011+$544
L011_0000053E:
; H011+$0000053E: 3b7c000f000e  move.w #$f, $e(a5)
        move.w #$f, $e(a5)
L011_00000544:
; H011+$00000544: 0c6d000f000c  cmpi.w #$f, $c(a5)
        cmpi.w #$f, $c(a5)
L011_0000054A:
; H011+$0000054A: 6f000006  ble.w $552
        ble.w H011+$552
L011_0000054E:
; H011+$0000054E: 426d000c  clr.w $c(a5)
        clr.w $c(a5)
L011_00000552:
; H011+$00000552: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L011_00000556:
; H011+$00000556: 6c000008  bge.w $560
        bge.w H011+$560
L011_0000055A:
; H011+$0000055A: 3b7c000f000c  move.w #$f, $c(a5)
        move.w #$f, $c(a5)
L011_00000560:
; H011+$00000560: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000564:
; H011+$00000564: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000566:
; H011+$00000566: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_0000056C:
; H011+$0000056C: 47eb0200  lea.l $200(a3), a3
        lea.l $200(a3), a3
L011_00000570:
; H011+$00000570: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L011_00000574:
; H011+$00000574: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00000578:
; H011+$00000578: 7400  moveq #$0, d2
        moveq #0, d2
L011_0000057A:
; H011+$0000057A: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L011_0000057E:
; H011+$0000057E: 3002  move.w d2, d0
        move.w d2, d0
L011_00000580:
; H011+$00000580: 60000002  bra.w $584
        bra.w H011+$584
L011_00000584:
; H011+$00000584: 4e5d  unlk a5
        unlk a5
L011_00000586:
; H011+$00000586: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_00000588:
; H011+$00000588: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_0000058A:
; H011+$0000058A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L011_0000058C:
; H011+$0000058C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_0000058E [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; richiama H038+$013C, H038+$0118, H016+$00A0, H016+$0014.
;   - Richiama H038+$013C.
;   - Richiama H038+$0118.
;   - Richiama H016+$00A0.
;   - Richiama H016+$0014.
;   - Usa lo stato globale: H005+$281C (inizio del blocco coordinate/vista); H005+$3E04 (puntatore stato persistente A, 2048 byte); H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H011+$0BB4
; --------------------------------------------------------------------------
L011_0000058E:
; H011+$0000058E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_00000590:
; H011+$00000590: 287afb68  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_00000594:
; H011+$00000594: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L011_00000598:
; H011+$00000598: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L011_0000059E:
; H011+$0000059E: 7400  moveq #$0, d2
        moveq #0, d2
L011_000005A0:
; H011+$000005A0: 143900002829  move.b $2829.l, d2
        move.b (H005+$2829).l, d2
L011_000005A6:
; H011+$000005A6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H038+$013C (wrapper_SetAPen)
L011_000005A8:
; H011+$000005A8: 4eb90000013c  jsr $13c.l
        jsr (H038+$13C).l
L011_000005AE:
; H011+$000005AE: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L011_000005B4:
; H011+$000005B4: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L011_000005B8:
; H011+$000005B8: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L011_000005BC:
; H011+$000005BC: 3f3c0070  move.w #$70, -(a7)
        move.w #$70, -(a7)
L011_000005C0:
; H011+$000005C0: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
; -> H038+$0118 (wrapper_RectFill)
L011_000005C4:
; H011+$000005C4: 4eb900000118  jsr $118.l
        jsr (H038+$118).l
; STATO: H005+$281C = inizio del blocco coordinate/vista
L011_000005CA:
; H011+$000005CA: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L011_000005D0:
; H011+$000005D0: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
L011_000005D6:
; H011+$000005D6: 6100ff0a  bsr.w $4e2
        bsr.w H011+$4E2
L011_000005DA:
; H011+$000005DA: 3400  move.w d0, d2
        move.w d0, d2
L011_000005DC:
; H011+$000005DC: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L011_000005E0:
; H011+$000005E0: 6400023e  bcc.w $820
        bcc.w H011+$820
L011_000005E4:
; H011+$000005E4: 7400  moveq #$0, d2
        moveq #0, d2
L011_000005E6:
; H011+$000005E6: 143900002829  move.b $2829.l, d2
        move.b (H005+$2829).l, d2
L011_000005EC:
; H011+$000005EC: 0c42000b  cmpi.w #$b, d2
        cmpi.w #$b, d2
L011_000005F0:
; H011+$000005F0: 6600022e  bne.w $820
        bne.w H011+$820
L011_000005F4:
; H011+$000005F4: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L011_000005F8:
; H011+$000005F8: 3b7c0002fff8  move.w #$2, -$8(a5)
        move.w #$2, -$8(a5)
L011_000005FE:
; H011+$000005FE: 3b7c000afff6  move.w #$a, -$a(a5)
        move.w #$a, -$a(a5)
L011_00000604:
; H011+$00000604: 3b7c000cfff4  move.w #$c, -$c(a5)
        move.w #$c, -$c(a5)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L011_0000060A:
; H011+$0000060A: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L011_00000610:
; H011+$00000610: 3b6b0192fffe  move.w $192(a3), -$2(a5)
        move.w $192(a3), -$2(a5)
L011_00000616:
; H011+$00000616: 3b7c03e7fff2  move.w #$3e7, -$e(a5)
        move.w #$3e7, -$e(a5)
L011_0000061C:
; H011+$0000061C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000620:
; H011+$00000620: 6000010e  bra.w $730
        bra.w H011+$730
L011_00000624:
; H011+$00000624: 7400  moveq #$0, d2
        moveq #0, d2
L011_00000626:
; H011+$00000626: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L011_0000062C:
; H011+$0000062C: 6000004e  bra.w $67c
        bra.w H011+$67C
L011_00000630:
; H011+$00000630: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L011_00000634:
; H011+$00000634: 5742  subq.w #$3, d2
        subq.w #$3, d2
L011_00000636:
; H011+$00000636: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L011_0000063A:
; H011+$0000063A: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_0000063E:
; H011+$0000063E: 5a42  addq.w #$5, d2
        addq.w #$5, d2
L011_00000640:
; H011+$00000640: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L011_00000644:
; H011+$00000644: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L011_00000648:
; H011+$00000648: 4e75  rts 
        rts 
L011_0000064A:
; H011+$0000064A: 0c6d0002fffe  cmpi.w #$2, -$2(a5)
        cmpi.w #$2, -$2(a5)
L011_00000650:
; H011+$00000650: 6300001e  bls.w $670
        bls.w H011+$670
L011_00000654:
; H011+$00000654: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_00000658:
; H011+$00000658: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L011_0000065C:
; H011+$0000065C: 5742  subq.w #$3, d2
        subq.w #$3, d2
L011_0000065E:
; H011+$0000065E: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L011_00000662:
; H011+$00000662: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_00000666:
; H011+$00000666: 5a42  addq.w #$5, d2
        addq.w #$5, d2
L011_00000668:
; H011+$00000668: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L011_0000066C:
; H011+$0000066C: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L011_00000670:
; H011+$00000670: 4e75  rts 
        rts 
L011_00000672:
; H011+$00000672: 4e75  rts 
        rts 
; Preserved bytes H011+$00000674..$0000067C; code/data not fully classified.
        dc.w $FFFC,$FFBA,$FFFC,$FFD4
L011_0000067C:
; H011+$0000067C: 47fafff8  lea.l $676(pc), a3
        lea.l H011+$676(pc), a3
L011_00000680:
; H011+$00000680: 5542  subq.w #$2, d2
        subq.w #$2, d2
L011_00000682:
; H011+$00000682: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L011_00000686:
; H011+$00000686: 6302  bls.b $68a
        bls.b H011+$68A
L011_00000688:
; H011+$00000688: 74ff  moveq #$ff, d2
        moveq #-1, d2
L011_0000068A:
; H011+$0000068A: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000068C:
; H011+$0000068C: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H011+$0676; indici 0..2, default -1.
L011_00000690:
; H011+$00000690: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L011_00000694:
; H011+$00000694: 4e75  rts 
        rts 
L011_00000696:
; H011+$00000696: 7400  moveq #$0, d2
        moveq #0, d2
L011_00000698:
; H011+$00000698: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L011_0000069E:
; H011+$0000069E: 6000004e  bra.w $6ee
        bra.w H011+$6EE
L011_000006A2:
; H011+$000006A2: 3b6dfffafff2  move.w -$6(a5), -$e(a5)
        move.w -$6(a5), -$e(a5)
L011_000006A8:
; H011+$000006A8: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_000006AC:
; H011+$000006AC: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L011_000006B0:
; H011+$000006B0: 0442000d  subi.w #$d, d2
        subi.w #$d, d2
L011_000006B4:
; H011+$000006B4: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L011_000006B8:
; H011+$000006B8: 4e75  rts 
        rts 
L011_000006BA:
; H011+$000006BA: 0c6d0010fffe  cmpi.w #$10, -$2(a5)
        cmpi.w #$10, -$2(a5)
L011_000006C0:
; H011+$000006C0: 64000020  bcc.w $6e2
        bcc.w H011+$6E2
L011_000006C4:
; H011+$000006C4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_000006C8:
; H011+$000006C8: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L011_000006CC:
; H011+$000006CC: 5142  subq.w #$8, d2
        subq.w #$8, d2
L011_000006CE:
; H011+$000006CE: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L011_000006D2:
; H011+$000006D2: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_000006D6:
; H011+$000006D6: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L011_000006DA:
; H011+$000006DA: 0442000d  subi.w #$d, d2
        subi.w #$d, d2
L011_000006DE:
; H011+$000006DE: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L011_000006E2:
; H011+$000006E2: 4e75  rts 
        rts 
L011_000006E4:
; H011+$000006E4: 4e75  rts 
        rts 
; Preserved bytes H011+$000006E6..$000006EE; code/data not fully classified.
        dc.w $FFFC,$FFD2,$FFFC,$FFBA
L011_000006EE:
; H011+$000006EE: 47fafff8  lea.l $6e8(pc), a3
        lea.l H011+$6E8(pc), a3
L011_000006F2:
; H011+$000006F2: 5942  subq.w #$4, d2
        subq.w #$4, d2
L011_000006F4:
; H011+$000006F4: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L011_000006F8:
; H011+$000006F8: 6302  bls.b $6fc
        bls.b H011+$6FC
L011_000006FA:
; H011+$000006FA: 74ff  moveq #$ff, d2
        moveq #-1, d2
L011_000006FC:
; H011+$000006FC: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000006FE:
; H011+$000006FE: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H011+$06E8; indici 0..2, default -1.
L011_00000702:
; H011+$00000702: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L011_00000706:
; H011+$00000706: 4e75  rts 
        rts 
L011_00000708:
; H011+$00000708: 4e75  rts 
        rts 
; Preserved bytes H011+$0000070A..$00000730; code/data not fully classified.
        dc.w $FFFC,$FF18,$FF18,$FF18,$FF18,$FF18,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FF8A,$FF8A,$FF8A
        dc.w $FF8A,$FF8A,$FF8A
L011_00000730:
; H011+$00000730: 47faffda  lea.l $70c(pc), a3
        lea.l H011+$70C(pc), a3
L011_00000734:
; H011+$00000734: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00000736:
; H011+$00000736: 0c420011  cmpi.w #$11, d2
        cmpi.w #$11, d2
L011_0000073A:
; H011+$0000073A: 6302  bls.b $73e
        bls.b H011+$73E
L011_0000073C:
; H011+$0000073C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L011_0000073E:
; H011+$0000073E: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000740:
; H011+$00000740: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H011+$070C; indici 0..17, default -1.
L011_00000744:
; H011+$00000744: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L011_00000748:
; H011+$00000748: 0c6d03e7fff2  cmpi.w #$3e7, -$e(a5)
        cmpi.w #$3e7, -$e(a5)
L011_0000074E:
; H011+$0000074E: 67000062  beq.w $7b2
        beq.w H011+$7B2
L011_00000752:
; H011+$00000752: 247900002808  movea.l $2808.l, a2
        movea.l (H005+$2808).l, a2
L011_00000758:
; H011+$00000758: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L011_0000075C:
; H011+$0000075C: 4853  pea.l (a3)
        pea.l (a3)
L011_0000075E:
; H011+$0000075E: 4267  clr.w -(a7)
        clr.w -(a7)
L011_00000760:
; H011+$00000760: 4267  clr.w -(a7)
        clr.w -(a7)
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L011_00000762:
; H011+$00000762: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L011_00000768:
; H011+$00000768: 486b0054  pea.l $54(a3)
        pea.l $54(a3)
L011_0000076C:
; H011+$0000076C: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_00000770:
; H011+$00000770: e742  asl.w #$3, d2
        asl.w #$3, d2
L011_00000772:
; H011+$00000772: 06420018  addi.w #$18, d2
        addi.w #$18, d2
L011_00000776:
; H011+$00000776: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000778:
; H011+$00000778: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L011_0000077C:
; H011+$0000077C: e742  asl.w #$3, d2
        asl.w #$3, d2
L011_0000077E:
; H011+$0000077E: 06420018  addi.w #$18, d2
        addi.w #$18, d2
L011_00000782:
; H011+$00000782: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000784:
; H011+$00000784: 267900002808  movea.l $2808.l, a3
        movea.l (H005+$2808).l, a3
L011_0000078A:
; H011+$0000078A: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L011_0000078E:
; H011+$0000078E: e742  asl.w #$3, d2
        asl.w #$3, d2
L011_00000790:
; H011+$00000790: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000792:
; H011+$00000792: 267900002808  movea.l $2808.l, a3
        movea.l (H005+$2808).l, a3
L011_00000798:
; H011+$00000798: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L011_0000079A:
; H011+$0000079A: 1f3c00e0  move.b #$e0, -(a7)
        move.b #$e0, -(a7)
L011_0000079E:
; H011+$0000079E: 247900002808  movea.l $2808.l, a2
        movea.l (H005+$2808).l, a2
L011_000007A4:
; H011+$000007A4: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L011_000007A8:
; H011+$000007A8: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
; -> H016+$00A0 (wrapper_BltMaskBitMapRastPort)
L011_000007AC:
; H011+$000007AC: 4eb9000000a0  jsr $a0.l
        jsr (H016+$A0).l
L011_000007B2:
; H011+$000007B2: 7400  moveq #$0, d2
        moveq #0, d2
L011_000007B4:
; H011+$000007B4: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L011_000007BA:
; H011+$000007BA: 4a42  tst.w d2
        tst.w d2
L011_000007BC:
; H011+$000007BC: 66000062  bne.w $820
        bne.w H011+$820
L011_000007C0:
; H011+$000007C0: 24790000280c  movea.l $280c.l, a2
        movea.l (H005+$280C).l, a2
L011_000007C6:
; H011+$000007C6: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L011_000007CA:
; H011+$000007CA: 4853  pea.l (a3)
        pea.l (a3)
L011_000007CC:
; H011+$000007CC: 4267  clr.w -(a7)
        clr.w -(a7)
L011_000007CE:
; H011+$000007CE: 4267  clr.w -(a7)
        clr.w -(a7)
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L011_000007D0:
; H011+$000007D0: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L011_000007D6:
; H011+$000007D6: 486b0054  pea.l $54(a3)
        pea.l $54(a3)
L011_000007DA:
; H011+$000007DA: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_000007DE:
; H011+$000007DE: e742  asl.w #$3, d2
        asl.w #$3, d2
L011_000007E0:
; H011+$000007E0: 06420018  addi.w #$18, d2
        addi.w #$18, d2
L011_000007E4:
; H011+$000007E4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_000007E6:
; H011+$000007E6: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_000007EA:
; H011+$000007EA: e742  asl.w #$3, d2
        asl.w #$3, d2
L011_000007EC:
; H011+$000007EC: 06420018  addi.w #$18, d2
        addi.w #$18, d2
L011_000007F0:
; H011+$000007F0: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_000007F2:
; H011+$000007F2: 26790000280c  movea.l $280c.l, a3
        movea.l (H005+$280C).l, a3
L011_000007F8:
; H011+$000007F8: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L011_000007FC:
; H011+$000007FC: e742  asl.w #$3, d2
        asl.w #$3, d2
L011_000007FE:
; H011+$000007FE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000800:
; H011+$00000800: 26790000280c  movea.l $280c.l, a3
        movea.l (H005+$280C).l, a3
L011_00000806:
; H011+$00000806: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L011_00000808:
; H011+$00000808: 1f3c00e0  move.b #$e0, -(a7)
        move.b #$e0, -(a7)
L011_0000080C:
; H011+$0000080C: 24790000280c  movea.l $280c.l, a2
        movea.l (H005+$280C).l, a2
L011_00000812:
; H011+$00000812: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L011_00000816:
; H011+$00000816: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
; -> H016+$00A0 (wrapper_BltMaskBitMapRastPort)
L011_0000081A:
; H011+$0000081A: 4eb9000000a0  jsr $a0.l
        jsr (H016+$A0).l
L011_00000820:
; H011+$00000820: 247900002804  movea.l $2804.l, a2
        movea.l (H005+$2804).l, a2
L011_00000826:
; H011+$00000826: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L011_0000082A:
; H011+$0000082A: 4853  pea.l (a3)
        pea.l (a3)
L011_0000082C:
; H011+$0000082C: 4267  clr.w -(a7)
        clr.w -(a7)
L011_0000082E:
; H011+$0000082E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L011_00000832:
; H011+$00000832: 2479000052f2  movea.l $52f2.l, a2
        movea.l (H005+$52F2).l, a2
L011_00000838:
; H011+$00000838: 266a0058  movea.l $58(a2), a3
        movea.l $58(a2), a3
L011_0000083C:
; H011+$0000083C: 4853  pea.l (a3)
        pea.l (a3)
L011_0000083E:
; H011+$0000083E: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L011_00000842:
; H011+$00000842: 3f3c0043  move.w #$43, -(a7)
        move.w #$43, -(a7)
L011_00000846:
; H011+$00000846: 3f3c0058  move.w #$58, -(a7)
        move.w #$58, -(a7)
L011_0000084A:
; H011+$0000084A: 3f3c002d  move.w #$2d, -(a7)
        move.w #$2d, -(a7)
L011_0000084E:
; H011+$0000084E: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L011_00000852:
; H011+$00000852: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L011_00000856:
; H011+$00000856: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L011_00000858:
; H011+$00000858: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L011_0000085E:
; H011+$0000085E: 2b40ffec  move.l d0, -$14(a5)
        move.l d0, -$14(a5)
L011_00000862:
; H011+$00000862: 4e5d  unlk a5
        unlk a5
L011_00000864:
; H011+$00000864: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_00000866:
; H011+$00000866: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_00000868 [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; richiama H049+$0014.
;   - Richiama H049+$0014.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H011+$1314, H011+$134A, H011+$110A, H011+$1140, H011+$0CD8, H011+$0CF6 e altri 12
; --------------------------------------------------------------------------
L011_00000868:
; H011+$00000868: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_0000086A:
; H011+$0000086A: 287af88e  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_0000086E:
; H011+$0000086E: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L011_00000872:
; H011+$00000872: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000876:
; H011+$00000876: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000878:
; H011+$00000878: 47ecffe4  lea.l -$1c(a4), a3
        lea.l -$1c(a4), a3
L011_0000087C:
; H011+$0000087C: 3b732000fff6  move.w (a3, d2.w), -$a(a5)
        move.w (a3, d2.w), -$a(a5)
L011_00000882:
; H011+$00000882: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000886:
; H011+$00000886: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000888:
; H011+$00000888: 47ecffd0  lea.l -$30(a4), a3
        lea.l -$30(a4), a3
L011_0000088C:
; H011+$0000088C: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L011_00000890:
; H011+$00000890: d86d0012  add.w $12(a5), d4
        add.w $12(a5), d4
L011_00000894:
; H011+$00000894: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_00000896:
; H011+$00000896: 3b44fffe  move.w d4, -$2(a5)
        move.w d4, -$2(a5)
L011_0000089A:
; H011+$0000089A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_0000089E:
; H011+$0000089E: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000008A0:
; H011+$000008A0: 47ecffbc  lea.l -$44(a4), a3
        lea.l -$44(a4), a3
L011_000008A4:
; H011+$000008A4: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L011_000008A8:
; H011+$000008A8: d86d0010  add.w $10(a5), d4
        add.w $10(a5), d4
L011_000008AC:
; H011+$000008AC: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_000008AE:
; H011+$000008AE: 3b44fffc  move.w d4, -$4(a5)
        move.w d4, -$4(a5)
L011_000008B2:
; H011+$000008B2: 7400  moveq #$0, d2
        moveq #0, d2
L011_000008B4:
; H011+$000008B4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_000008B8:
; H011+$000008B8: 84fc0005  divu.w #$5, d2
        divu.w #$5, d2
L011_000008BC:
; H011+$000008BC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L011_000008BE:
; H011+$000008BE: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L011_000008C2:
; H011+$000008C2: 7400  moveq #$0, d2
        moveq #0, d2
L011_000008C4:
; H011+$000008C4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_000008C8:
; H011+$000008C8: 84fc0005  divu.w #$5, d2
        divu.w #$5, d2
L011_000008CC:
; H011+$000008CC: 4842  swap d2
        swap d2
L011_000008CE:
; H011+$000008CE: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L011_000008D2:
; H011+$000008D2: 3b6d0010fff8  move.w $10(a5), -$8(a5)
        move.w $10(a5), -$8(a5)
L011_000008D8:
; H011+$000008D8: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L011_000008DC:
; H011+$000008DC: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_000008E0:
; H011+$000008E0: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L011_000008E2:
; H011+$000008E2: 6e0000d8  bgt.w $9bc
        bgt.w H011+$9BC
L011_000008E6:
; H011+$000008E6: 3b6d0012fffa  move.w $12(a5), -$6(a5)
        move.w $12(a5), -$6(a5)
L011_000008EC:
; H011+$000008EC: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L011_000008F0:
; H011+$000008F0: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_000008F4:
; H011+$000008F4: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L011_000008F6:
; H011+$000008F6: 6e0000ba  bgt.w $9b2
        bgt.w H011+$9B2
L011_000008FA:
; H011+$000008FA: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L011_000008FE:
; H011+$000008FE: 6d0000a6  blt.w $9a6
        blt.w H011+$9A6
L011_00000902:
; H011+$00000902: 0c6d000afff8  cmpi.w #$a, -$8(a5)
        cmpi.w #$a, -$8(a5)
L011_00000908:
; H011+$00000908: 6e00009c  bgt.w $9a6
        bgt.w H011+$9A6
L011_0000090C:
; H011+$0000090C: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L011_00000910:
; H011+$00000910: 6d000094  blt.w $9a6
        blt.w H011+$9A6
L011_00000914:
; H011+$00000914: 0c6d000afffa  cmpi.w #$a, -$6(a5)
        cmpi.w #$a, -$6(a5)
L011_0000091A:
; H011+$0000091A: 6e00008a  bgt.w $9a6
        bgt.w H011+$9A6
L011_0000091E:
; H011+$0000091E: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L011_00000922:
; H011+$00000922: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00000924:
; H011+$00000924: c5fc030c  muls.w #$30c, d2
        muls.w #$30c, d2
L011_00000928:
; H011+$00000928: 26790000282e  movea.l $282e.l, a3
        movea.l (H005+$282E).l, a3
L011_0000092E:
; H011+$0000092E: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L011_00000932:
; H011+$00000932: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_00000934:
; H011+$00000934: c9fc009c  muls.w #$9c, d4
        muls.w #$9c, d4
L011_00000938:
; H011+$00000938: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L011_0000093C:
; H011+$0000093C: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L011_00000940:
; H011+$00000940: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L011_00000944:
; H011+$00000944: 7800  moveq #$0, d4
        moveq #0, d4
L011_00000946:
; H011+$00000946: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L011_0000094A:
; H011+$0000094A: 4a44  tst.w d4
        tst.w d4
L011_0000094C:
; H011+$0000094C: 63000058  bls.w $9a6
        bls.w H011+$9A6
L011_00000950:
; H011+$00000950: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_00000954:
; H011+$00000954: 5642  addq.w #$3, d2
        addq.w #$3, d2
L011_00000956:
; H011+$00000956: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000958:
; H011+$00000958: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_0000095C:
; H011+$0000095C: 5642  addq.w #$3, d2
        addq.w #$3, d2
L011_0000095E:
; H011+$0000095E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000960:
; H011+$00000960: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L011_00000964:
; H011+$00000964: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00000966:
; H011+$00000966: c5fc030c  muls.w #$30c, d2
        muls.w #$30c, d2
L011_0000096A:
; H011+$0000096A: 26790000282e  movea.l $282e.l, a3
        movea.l (H005+$282E).l, a3
L011_00000970:
; H011+$00000970: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L011_00000974:
; H011+$00000974: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_00000976:
; H011+$00000976: c9fc009c  muls.w #$9c, d4
        muls.w #$9c, d4
L011_0000097A:
; H011+$0000097A: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L011_0000097E:
; H011+$0000097E: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L011_00000982:
; H011+$00000982: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L011_00000986:
; H011+$00000986: 7800  moveq #$0, d4
        moveq #0, d4
L011_00000988:
; H011+$00000988: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L011_0000098C:
; H011+$0000098C: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L011_0000098E:
; H011+$0000098E: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L011_00000994:
; H011+$00000994: 2f2b0058  move.l $58(a3), -(a7)
        move.l $58(a3), -(a7)
L011_00000998:
; H011+$00000998: 47f900003338  lea.l $3338.l, a3
        lea.l (H005+$3338).l, a3
L011_0000099E:
; H011+$0000099E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H049+$0014 (trampoline_H049_0082)
L011_000009A0:
; H011+$000009A0: 4eb900000014  jsr $14.l
        jsr (H049+$14).l
L011_000009A6:
; H011+$000009A6: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L011_000009AA:
; H011+$000009AA: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L011_000009AE:
; H011+$000009AE: 6800ff40  bvc.w $8f0
        bvc.w H011+$8F0
L011_000009B2:
; H011+$000009B2: 548f  addq.l #$2, a7
        addq.l #$2, a7
L011_000009B4:
; H011+$000009B4: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L011_000009B8:
; H011+$000009B8: 6800ff22  bvc.w $8dc
        bvc.w H011+$8DC
L011_000009BC:
; H011+$000009BC: 548f  addq.l #$2, a7
        addq.l #$2, a7
L011_000009BE:
; H011+$000009BE: 4e5d  unlk a5
        unlk a5
L011_000009C0:
; H011+$000009C0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_000009C2:
; H011+$000009C2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_000009C4:
; H011+$000009C4: 508f  addq.l #$8, a7
        addq.l #$8, a7
L011_000009C6:
; H011+$000009C6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_000009C8 [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; richiama H029+$0354.
;   - Richiama H029+$0354.
;   - Usa lo stato globale: H005+$282A (puntatore ai quattro piani dati GEO).
; Chiamanti diretti: H068+$1276, H068+$096E, H068+$0382, H095+$0734
; --------------------------------------------------------------------------
L011_000009C8:
; H011+$000009C8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_000009CA:
; H011+$000009CA: 287af72e  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_000009CE:
; H011+$000009CE: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L011_000009D2:
; H011+$000009D2: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L011_000009D6:
; H011+$000009D6: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L011_000009DA:
; H011+$000009DA: 6100f786  bsr.w $162
        bsr.w H011+$162
L011_000009DE:
; H011+$000009DE: 1400  move.b d0, d2
        move.b d0, d2
L011_000009E0:
; H011+$000009E0: 4a02  tst.b d2
        tst.b d2
L011_000009E2:
; H011+$000009E2: 66000026  bne.w $a0a
        bne.w H011+$A0A
L011_000009E6:
; H011+$000009E6: 7400  moveq #$0, d2
        moveq #0, d2
L011_000009E8:
; H011+$000009E8: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
L011_000009EE:
; H011+$000009EE: 4a42  tst.w d2
        tst.w d2
L011_000009F0:
; H011+$000009F0: 67000012  beq.w $a04
        beq.w H011+$A04
L011_000009F4:
; H011+$000009F4: 7400  moveq #$0, d2
        moveq #0, d2
L011_000009F6:
; H011+$000009F6: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
L011_000009FC:
; H011+$000009FC: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L011_00000A00:
; H011+$00000A00: 66000008  bne.w $a0a
        bne.w H011+$A0A
L011_00000A04:
; H011+$00000A04: 7000  moveq #$0, d0
        moveq #0, d0
L011_00000A06:
; H011+$00000A06: 60000166  bra.w $b6e
        bra.w H011+$B6E
L011_00000A0A:
; H011+$00000A0A: 0c6d000f0010  cmpi.w #$f, $10(a5)
        cmpi.w #$f, $10(a5)
L011_00000A10:
; H011+$00000A10: 6f00000a  ble.w $a1c
        ble.w H011+$A1C
L011_00000A14:
; H011+$00000A14: 426d0010  clr.w $10(a5)
        clr.w $10(a5)
L011_00000A18:
; H011+$00000A18: 60000010  bra.w $a2a
        bra.w H011+$A2A
L011_00000A1C:
; H011+$00000A1C: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L011_00000A20:
; H011+$00000A20: 6c000008  bge.w $a2a
        bge.w H011+$A2A
L011_00000A24:
; H011+$00000A24: 3b7c000f0010  move.w #$f, $10(a5)
        move.w #$f, $10(a5)
L011_00000A2A:
; H011+$00000A2A: 0c6d000f000e  cmpi.w #$f, $e(a5)
        cmpi.w #$f, $e(a5)
L011_00000A30:
; H011+$00000A30: 6f00000a  ble.w $a3c
        ble.w H011+$A3C
L011_00000A34:
; H011+$00000A34: 426d000e  clr.w $e(a5)
        clr.w $e(a5)
L011_00000A38:
; H011+$00000A38: 60000010  bra.w $a4a
        bra.w H011+$A4A
L011_00000A3C:
; H011+$00000A3C: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L011_00000A40:
; H011+$00000A40: 6c000008  bge.w $a4a
        bge.w H011+$A4A
L011_00000A44:
; H011+$00000A44: 3b7c000f000e  move.w #$f, $e(a5)
        move.w #$f, $e(a5)
L011_00000A4A:
; H011+$00000A4A: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L011_00000A50:
; H011+$00000A50: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L011_00000A54:
; H011+$00000A54: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L011_00000A58:
; H011+$00000A58: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000A5C:
; H011+$00000A5C: 6100f74c  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000A60:
; H011+$00000A60: 3400  move.w d0, d2
        move.w d0, d2
L011_00000A62:
; H011+$00000A62: 4a42  tst.w d2
        tst.w d2
L011_00000A64:
; H011+$00000A64: 63000100  bls.w $b66
        bls.w H011+$B66
L011_00000A68:
; H011+$00000A68: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000A6C:
; H011+$00000A6C: 600000e2  bra.w $b50
        bra.w H011+$B50
L011_00000A70:
; H011+$00000A70: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000A74:
; H011+$00000A74: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000A76:
; H011+$00000A76: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_00000A7C:
; H011+$00000A7C: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L011_00000A80:
; H011+$00000A80: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_00000A84:
; H011+$00000A84: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00000A88:
; H011+$00000A88: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_00000A8C:
; H011+$00000A8C: 3f3c00c0  move.w #$c0, -(a7)
        move.w #$c0, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_00000A90:
; H011+$00000A90: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_00000A96:
; H011+$00000A96: 1400  move.b d0, d2
        move.b d0, d2
L011_00000A98:
; H011+$00000A98: ec0a  lsr.b #$6, d2
        lsr.b #$6, d2
L011_00000A9A:
; H011+$00000A9A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_00000A9E:
; H011+$00000A9E: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_00000AA2:
; H011+$00000AA2: 4e75  rts 
        rts 
L011_00000AA4:
; H011+$00000AA4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000AA8:
; H011+$00000AA8: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000AAA:
; H011+$00000AAA: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_00000AB0:
; H011+$00000AB0: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L011_00000AB4:
; H011+$00000AB4: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_00000AB8:
; H011+$00000AB8: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00000ABC:
; H011+$00000ABC: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_00000AC0:
; H011+$00000AC0: 3f3c0030  move.w #$30, -(a7)
        move.w #$30, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_00000AC4:
; H011+$00000AC4: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_00000ACA:
; H011+$00000ACA: 1400  move.b d0, d2
        move.b d0, d2
L011_00000ACC:
; H011+$00000ACC: e80a  lsr.b #$4, d2
        lsr.b #$4, d2
L011_00000ACE:
; H011+$00000ACE: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_00000AD2:
; H011+$00000AD2: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_00000AD6:
; H011+$00000AD6: 4e75  rts 
        rts 
L011_00000AD8:
; H011+$00000AD8: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000ADC:
; H011+$00000ADC: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000ADE:
; H011+$00000ADE: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_00000AE4:
; H011+$00000AE4: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L011_00000AE8:
; H011+$00000AE8: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_00000AEC:
; H011+$00000AEC: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00000AF0:
; H011+$00000AF0: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_00000AF4:
; H011+$00000AF4: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_00000AF8:
; H011+$00000AF8: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_00000AFE:
; H011+$00000AFE: 1400  move.b d0, d2
        move.b d0, d2
L011_00000B00:
; H011+$00000B00: e40a  lsr.b #$2, d2
        lsr.b #$2, d2
L011_00000B02:
; H011+$00000B02: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_00000B06:
; H011+$00000B06: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_00000B0A:
; H011+$00000B0A: 4e75  rts 
        rts 
L011_00000B0C:
; H011+$00000B0C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00000B10:
; H011+$00000B10: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00000B12:
; H011+$00000B12: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_00000B18:
; H011+$00000B18: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L011_00000B1C:
; H011+$00000B1C: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L011_00000B20:
; H011+$00000B20: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00000B24:
; H011+$00000B24: 1f334000  move.b (a3, d4.w), -(a7)
        move.b (a3, d4.w), -(a7)
L011_00000B28:
; H011+$00000B28: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L011_00000B2C:
; H011+$00000B2C: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L011_00000B32:
; H011+$00000B32: 1400  move.b d0, d2
        move.b d0, d2
L011_00000B34:
; H011+$00000B34: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L011_00000B38:
; H011+$00000B38: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_00000B3C:
; H011+$00000B3C: 4e75  rts 
        rts 
L011_00000B3E:
; H011+$00000B3E: 4e75  rts 
        rts 
; Preserved bytes H011+$00000B40..$00000B50; code/data not fully classified.
        dc.w $FFFC,$FFCA,$FFFC,$FF96,$FFFC,$FF62,$FFFC,$FF2E
L011_00000B50:
; H011+$00000B50: 47fafff0  lea.l $b42(pc), a3
        lea.l H011+$B42(pc), a3
L011_00000B54:
; H011+$00000B54: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L011_00000B58:
; H011+$00000B58: 6302  bls.b $b5c
        bls.b H011+$B5C
L011_00000B5A:
; H011+$00000B5A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L011_00000B5C:
; H011+$00000B5C: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000B5E:
; H011+$00000B5E: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H011+$0B42; indici 0..6, default -1.
L011_00000B62:
; H011+$00000B62: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L011_00000B66:
; H011+$00000B66: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L011_00000B6A:
; H011+$00000B6A: 60000002  bra.w $b6e
        bra.w H011+$B6E
L011_00000B6E:
; H011+$00000B6E: 4e5d  unlk a5
        unlk a5
L011_00000B70:
; H011+$00000B70: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_00000B72:
; H011+$00000B72: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_00000B74:
; H011+$00000B74: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L011_00000B76:
; H011+$00000B76: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H011_00000B78 [parziale]
; Scopo: Routine del modulo griglia 16x16, caricamento GEO/WALLDEF e servizi della vista 3D; richiama H029+$1718, H029+$16A2, H029+$16DE.
;   - Richiama H029+$1718.
;   - Richiama H029+$16A2.
;   - Richiama H029+$16DE.
; Chiamanti diretti: H060+$015E, H068+$0CEE, H068+$0F7C, H068+$0FE4, H068+$0F14
; --------------------------------------------------------------------------
L011_00000B78:
; H011+$00000B78: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_00000B7A:
; H011+$00000B7A: 287af57e  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_00000B7E:
; H011+$00000B7E: 4e55ffde  link.w a5, #$ffde
        link.w a5, #$ffde
; -> H029+$1718 (sub_H029_00001718)
L011_00000B82:
; H011+$00000B82: 4eb900001718  jsr $1718.l
        jsr (H029+$1718).l
; -> H029+$16A2 (sub_H029_000016A2)
L011_00000B88:
; H011+$00000B88: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
L011_00000B8E:
; H011+$00000B8E: 4a3900002825  tst.b $2825.l
        tst.b (H005+$2825).l
L011_00000B94:
; H011+$00000B94: 67000016  beq.w $bac
        beq.w H011+$BAC
L011_00000B98:
; H011+$00000B98: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L011_00000B9C:
; H011+$00000B9C: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L011_00000BA0:
; H011+$00000BA0: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L011_00000BA4:
; H011+$00000BA4: 6100f78a  bsr.w $330
        bsr.w H011+$330
L011_00000BA8:
; H011+$00000BA8: 6000092c  bra.w $14d6
        bra.w H011+$14D6
L011_00000BAC:
; H011+$00000BAC: 13fc00ff00002486  move.b #$ff, $2486.l
        move.b #$ff, (H005+$2486).l
L011_00000BB4:
; H011+$00000BB4: 6100f9d8  bsr.w $58e
        bsr.w H011+$58E
L011_00000BB8:
; H011+$00000BB8: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000BBC:
; H011+$00000BBC: 5c42  addq.w #$6, d2
        addq.w #$6, d2
L011_00000BBE:
; H011+$00000BBE: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L011_00000BC4:
; H011+$00000BC4: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L011_00000BC8:
; H011+$00000BC8: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L011_00000BCC:
; H011+$00000BCC: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000BD0:
; H011+$00000BD0: 5842  addq.w #$4, d2
        addq.w #$4, d2
L011_00000BD2:
; H011+$00000BD2: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L011_00000BD8:
; H011+$00000BD8: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L011_00000BDC:
; H011+$00000BDC: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L011_00000BE0:
; H011+$00000BE0: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000BE4:
; H011+$00000BE4: 5442  addq.w #$2, d2
        addq.w #$2, d2
L011_00000BE6:
; H011+$00000BE6: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L011_00000BEC:
; H011+$00000BEC: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L011_00000BF0:
; H011+$00000BF0: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L011_00000BF4:
; H011+$00000BF4: 3b6d0010fff6  move.w $10(a5), -$a(a5)
        move.w $10(a5), -$a(a5)
L011_00000BFA:
; H011+$00000BFA: 3b6d000efff4  move.w $e(a5), -$c(a5)
        move.w $e(a5), -$c(a5)
L011_00000C00:
; H011+$00000C00: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000C04:
; H011+$00000C04: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000C06:
; H011+$00000C06: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00000C0C:
; H011+$00000C0C: 3b732000fff2  move.w (a3, d2.w), -$e(a5)
        move.w (a3, d2.w), -$e(a5)
L011_00000C12:
; H011+$00000C12: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00000C16:
; H011+$00000C16: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000C18:
; H011+$00000C18: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00000C1E:
; H011+$00000C1E: 3b732000fff0  move.w (a3, d2.w), -$10(a5)
        move.w (a3, d2.w), -$10(a5)
L011_00000C24:
; H011+$00000C24: 3b7c0002fff8  move.w #$2, -$8(a5)
        move.w #$2, -$8(a5)
L011_00000C2A:
; H011+$00000C2A: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_00000C2E:
; H011+$00000C2E: c5edfff8  muls.w -$8(a5), d2
        muls.w -$8(a5), d2
L011_00000C32:
; H011+$00000C32: d56dfff6  add.w d2, -$a(a5)
        add.w d2, -$a(a5)
L011_00000C36:
; H011+$00000C36: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L011_00000C3A:
; H011+$00000C3A: c5edfff8  muls.w -$8(a5), d2
        muls.w -$8(a5), d2
L011_00000C3E:
; H011+$00000C3E: d56dfff4  add.w d2, -$c(a5)
        add.w d2, -$c(a5)
L011_00000C42:
; H011+$00000C42: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_00000C46:
; H011+$00000C46: 6000083a  bra.w $1482
        bra.w H011+$1482
L011_00000C4A:
; H011+$00000C4A: 3b6dfff6ffee  move.w -$a(a5), -$12(a5)
        move.w -$a(a5), -$12(a5)
L011_00000C50:
; H011+$00000C50: 3b6dfff4ffec  move.w -$c(a5), -$14(a5)
        move.w -$c(a5), -$14(a5)
L011_00000C56:
; H011+$00000C56: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_00000C5A:
; H011+$00000C5A: 426dffe8  clr.w -$18(a5)
        clr.w -$18(a5)
L011_00000C5E:
; H011+$00000C5E: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L011_00000C62:
; H011+$00000C62: 0c6d0004ffea  cmpi.w #$4, -$16(a5)
        cmpi.w #$4, -$16(a5)
L011_00000C68:
; H011+$00000C68: 64000134  bcc.w $d9e
        bcc.w H011+$D9E
L011_00000C6C:
; H011+$00000C6C: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000C70:
; H011+$00000C70: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000C74:
; H011+$00000C74: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000C78:
; H011+$00000C78: 6100f530  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000C7C:
; H011+$00000C7C: 3b40ffe6  move.w d0, -$1a(a5)
        move.w d0, -$1a(a5)
L011_00000C80:
; H011+$00000C80: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000C84:
; H011+$00000C84: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000C88:
; H011+$00000C88: 6100f4d8  bsr.w $162
        bsr.w H011+$162
L011_00000C8C:
; H011+$00000C8C: 1400  move.b d0, d2
        move.b d0, d2
L011_00000C8E:
; H011+$00000C8E: 4a02  tst.b d2
        tst.b d2
L011_00000C90:
; H011+$00000C90: 6600001e  bne.w $cb0
        bne.w H011+$CB0
L011_00000C94:
; H011+$00000C94: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000C98:
; H011+$00000C98: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000C9C:
; H011+$00000C9C: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000CA0:
; H011+$00000CA0: 6100f508  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000CA4:
; H011+$00000CA4: 3400  move.w d0, d2
        move.w d0, d2
L011_00000CA6:
; H011+$00000CA6: 4a42  tst.w d2
        tst.w d2
L011_00000CA8:
; H011+$00000CA8: 66000006  bne.w $cb0
        bne.w H011+$CB0
L011_00000CAC:
; H011+$00000CAC: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L011_00000CB0:
; H011+$00000CB0: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L011_00000CB4:
; H011+$00000CB4: 67000048  beq.w $cfe
        beq.w H011+$CFE
L011_00000CB8:
; H011+$00000CB8: 4a6dffe0  tst.w -$20(a5)
        tst.w -$20(a5)
L011_00000CBC:
; H011+$00000CBC: 6300001e  bls.w $cdc
        bls.w H011+$CDC
L011_00000CC0:
; H011+$00000CC0: 342cffba  move.w -$46(a4), d2
        move.w -$46(a4), d2
L011_00000CC4:
; H011+$00000CC4: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000CC8:
; H011+$00000CC8: 5242  addq.w #$1, d2
        addq.w #$1, d2
L011_00000CCA:
; H011+$00000CCA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000CCC:
; H011+$00000CCC: 3f2cffa6  move.w -$5a(a4), -(a7)
        move.w -$5a(a4), -(a7)
L011_00000CD0:
; H011+$00000CD0: 3f2dffe0  move.w -$20(a5), -(a7)
        move.w -$20(a5), -(a7)
L011_00000CD4:
; H011+$00000CD4: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L011_00000CD8:
; H011+$00000CD8: 6100fb8e  bsr.w $868
        bsr.w H011+$868
L011_00000CDC:
; H011+$00000CDC: 3b6dffe6ffe0  move.w -$1a(a5), -$20(a5)
        move.w -$1a(a5), -$20(a5)
L011_00000CE2:
; H011+$00000CE2: 342cffa8  move.w -$58(a4), d2
        move.w -$58(a4), d2
L011_00000CE6:
; H011+$00000CE6: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000CEA:
; H011+$00000CEA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000CEC:
; H011+$00000CEC: 3f2cff94  move.w -$6c(a4), -(a7)
        move.w -$6c(a4), -(a7)
L011_00000CF0:
; H011+$00000CF0: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L011_00000CF4:
; H011+$00000CF4: 4267  clr.w -(a7)
        clr.w -(a7)
L011_00000CF6:
; H011+$00000CF6: 6100fb70  bsr.w $868
        bsr.w H011+$868
L011_00000CFA:
; H011+$00000CFA: 60000066  bra.w $d62
        bra.w H011+$D62
L011_00000CFE:
; H011+$00000CFE: 4a6dffe0  tst.w -$20(a5)
        tst.w -$20(a5)
L011_00000D02:
; H011+$00000D02: 6300005a  bls.w $d5e
        bls.w H011+$D5E
L011_00000D06:
; H011+$00000D06: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000D0A:
; H011+$00000D0A: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000D0C:
; H011+$00000D0C: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00000D12:
; H011+$00000D12: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00000D16:
; H011+$00000D16: 98732000  sub.w (a3, d2.w), d4
        sub.w (a3, d2.w), d4
L011_00000D1A:
; H011+$00000D1A: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L011_00000D1C:
; H011+$00000D1C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000D20:
; H011+$00000D20: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000D22:
; H011+$00000D22: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00000D28:
; H011+$00000D28: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00000D2C:
; H011+$00000D2C: 98732000  sub.w (a3, d2.w), d4
        sub.w (a3, d2.w), d4
L011_00000D30:
; H011+$00000D30: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L011_00000D32:
; H011+$00000D32: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000D36:
; H011+$00000D36: 6100f472  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000D3A:
; H011+$00000D3A: 3400  move.w d0, d2
        move.w d0, d2
L011_00000D3C:
; H011+$00000D3C: 4a42  tst.w d2
        tst.w d2
L011_00000D3E:
; H011+$00000D3E: 6700001e  beq.w $d5e
        beq.w H011+$D5E
L011_00000D42:
; H011+$00000D42: 342cffba  move.w -$46(a4), d2
        move.w -$46(a4), d2
L011_00000D46:
; H011+$00000D46: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000D4A:
; H011+$00000D4A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L011_00000D4C:
; H011+$00000D4C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000D4E:
; H011+$00000D4E: 3f2cffa6  move.w -$5a(a4), -(a7)
        move.w -$5a(a4), -(a7)
L011_00000D52:
; H011+$00000D52: 3f2dffe0  move.w -$20(a5), -(a7)
        move.w -$20(a5), -(a7)
L011_00000D56:
; H011+$00000D56: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L011_00000D5A:
; H011+$00000D5A: 6100fb0c  bsr.w $868
        bsr.w H011+$868
L011_00000D5E:
; H011+$00000D5E: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L011_00000D62:
; H011+$00000D62: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_00000D66:
; H011+$00000D66: 556dffe8  subq.w #$2, -$18(a5)
        subq.w #$2, -$18(a5)
L011_00000D6A:
; H011+$00000D6A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000D6E:
; H011+$00000D6E: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000D70:
; H011+$00000D70: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00000D76:
; H011+$00000D76: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00000D7A:
; H011+$00000D7A: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00000D7E:
; H011+$00000D7E: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00000D82:
; H011+$00000D82: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000D86:
; H011+$00000D86: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000D88:
; H011+$00000D88: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00000D8E:
; H011+$00000D8E: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00000D92:
; H011+$00000D92: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00000D96:
; H011+$00000D96: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_00000D9A:
; H011+$00000D9A: 6000fec6  bra.w $c62
        bra.w H011+$C62
L011_00000D9E:
; H011+$00000D9E: 3b6dfff6ffee  move.w -$a(a5), -$12(a5)
        move.w -$a(a5), -$12(a5)
L011_00000DA4:
; H011+$00000DA4: 3b6dfff4ffec  move.w -$c(a5), -$14(a5)
        move.w -$c(a5), -$14(a5)
L011_00000DAA:
; H011+$00000DAA: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_00000DAE:
; H011+$00000DAE: 426dffe8  clr.w -$18(a5)
        clr.w -$18(a5)
L011_00000DB2:
; H011+$00000DB2: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L011_00000DB6:
; H011+$00000DB6: 0c6d0004ffea  cmpi.w #$4, -$16(a5)
        cmpi.w #$4, -$16(a5)
L011_00000DBC:
; H011+$00000DBC: 64000134  bcc.w $ef2
        bcc.w H011+$EF2
L011_00000DC0:
; H011+$00000DC0: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000DC4:
; H011+$00000DC4: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000DC8:
; H011+$00000DC8: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000DCC:
; H011+$00000DCC: 6100f3dc  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000DD0:
; H011+$00000DD0: 3b40ffe6  move.w d0, -$1a(a5)
        move.w d0, -$1a(a5)
L011_00000DD4:
; H011+$00000DD4: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000DD8:
; H011+$00000DD8: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000DDC:
; H011+$00000DDC: 6100f384  bsr.w $162
        bsr.w H011+$162
L011_00000DE0:
; H011+$00000DE0: 1400  move.b d0, d2
        move.b d0, d2
L011_00000DE2:
; H011+$00000DE2: 4a02  tst.b d2
        tst.b d2
L011_00000DE4:
; H011+$00000DE4: 6600001e  bne.w $e04
        bne.w H011+$E04
L011_00000DE8:
; H011+$00000DE8: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000DEC:
; H011+$00000DEC: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000DF0:
; H011+$00000DF0: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000DF4:
; H011+$00000DF4: 6100f3b4  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000DF8:
; H011+$00000DF8: 3400  move.w d0, d2
        move.w d0, d2
L011_00000DFA:
; H011+$00000DFA: 4a42  tst.w d2
        tst.w d2
L011_00000DFC:
; H011+$00000DFC: 66000006  bne.w $e04
        bne.w H011+$E04
L011_00000E00:
; H011+$00000E00: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L011_00000E04:
; H011+$00000E04: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L011_00000E08:
; H011+$00000E08: 67000048  beq.w $e52
        beq.w H011+$E52
L011_00000E0C:
; H011+$00000E0C: 4a6dffe0  tst.w -$20(a5)
        tst.w -$20(a5)
L011_00000E10:
; H011+$00000E10: 6300001e  bls.w $e30
        bls.w H011+$E30
L011_00000E14:
; H011+$00000E14: 342cffba  move.w -$46(a4), d2
        move.w -$46(a4), d2
L011_00000E18:
; H011+$00000E18: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000E1C:
; H011+$00000E1C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00000E1E:
; H011+$00000E1E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000E20:
; H011+$00000E20: 3f2cffa6  move.w -$5a(a4), -(a7)
        move.w -$5a(a4), -(a7)
L011_00000E24:
; H011+$00000E24: 3f2dffe0  move.w -$20(a5), -(a7)
        move.w -$20(a5), -(a7)
L011_00000E28:
; H011+$00000E28: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L011_00000E2C:
; H011+$00000E2C: 6100fa3a  bsr.w $868
        bsr.w H011+$868
L011_00000E30:
; H011+$00000E30: 3b6dffe6ffe0  move.w -$1a(a5), -$20(a5)
        move.w -$1a(a5), -$20(a5)
L011_00000E36:
; H011+$00000E36: 342cffa8  move.w -$58(a4), d2
        move.w -$58(a4), d2
L011_00000E3A:
; H011+$00000E3A: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000E3E:
; H011+$00000E3E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000E40:
; H011+$00000E40: 3f2cff94  move.w -$6c(a4), -(a7)
        move.w -$6c(a4), -(a7)
L011_00000E44:
; H011+$00000E44: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L011_00000E48:
; H011+$00000E48: 4267  clr.w -(a7)
        clr.w -(a7)
L011_00000E4A:
; H011+$00000E4A: 6100fa1c  bsr.w $868
        bsr.w H011+$868
L011_00000E4E:
; H011+$00000E4E: 60000066  bra.w $eb6
        bra.w H011+$EB6
L011_00000E52:
; H011+$00000E52: 4a6dffe0  tst.w -$20(a5)
        tst.w -$20(a5)
L011_00000E56:
; H011+$00000E56: 6300005a  bls.w $eb2
        bls.w H011+$EB2
L011_00000E5A:
; H011+$00000E5A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00000E5E:
; H011+$00000E5E: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000E60:
; H011+$00000E60: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00000E66:
; H011+$00000E66: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00000E6A:
; H011+$00000E6A: 98732000  sub.w (a3, d2.w), d4
        sub.w (a3, d2.w), d4
L011_00000E6E:
; H011+$00000E6E: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L011_00000E70:
; H011+$00000E70: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00000E74:
; H011+$00000E74: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000E76:
; H011+$00000E76: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00000E7C:
; H011+$00000E7C: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00000E80:
; H011+$00000E80: 98732000  sub.w (a3, d2.w), d4
        sub.w (a3, d2.w), d4
L011_00000E84:
; H011+$00000E84: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L011_00000E86:
; H011+$00000E86: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000E8A:
; H011+$00000E8A: 6100f31e  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000E8E:
; H011+$00000E8E: 3400  move.w d0, d2
        move.w d0, d2
L011_00000E90:
; H011+$00000E90: 4a42  tst.w d2
        tst.w d2
L011_00000E92:
; H011+$00000E92: 6700001e  beq.w $eb2
        beq.w H011+$EB2
L011_00000E96:
; H011+$00000E96: 342cffba  move.w -$46(a4), d2
        move.w -$46(a4), d2
L011_00000E9A:
; H011+$00000E9A: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000E9E:
; H011+$00000E9E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00000EA0:
; H011+$00000EA0: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000EA2:
; H011+$00000EA2: 3f2cffa6  move.w -$5a(a4), -(a7)
        move.w -$5a(a4), -(a7)
L011_00000EA6:
; H011+$00000EA6: 3f2dffe0  move.w -$20(a5), -(a7)
        move.w -$20(a5), -(a7)
L011_00000EAA:
; H011+$00000EAA: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L011_00000EAE:
; H011+$00000EAE: 6100f9b8  bsr.w $868
        bsr.w H011+$868
L011_00000EB2:
; H011+$00000EB2: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L011_00000EB6:
; H011+$00000EB6: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_00000EBA:
; H011+$00000EBA: 546dffe8  addq.w #$2, -$18(a5)
        addq.w #$2, -$18(a5)
L011_00000EBE:
; H011+$00000EBE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00000EC2:
; H011+$00000EC2: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000EC4:
; H011+$00000EC4: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00000ECA:
; H011+$00000ECA: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00000ECE:
; H011+$00000ECE: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00000ED2:
; H011+$00000ED2: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00000ED6:
; H011+$00000ED6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00000EDA:
; H011+$00000EDA: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000EDC:
; H011+$00000EDC: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00000EE2:
; H011+$00000EE2: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00000EE6:
; H011+$00000EE6: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00000EEA:
; H011+$00000EEA: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_00000EEE:
; H011+$00000EEE: 6000fec6  bra.w $db6
        bra.w H011+$DB6
L011_00000EF2:
; H011+$00000EF2: 3b6dfff6ffee  move.w -$a(a5), -$12(a5)
        move.w -$a(a5), -$12(a5)
L011_00000EF8:
; H011+$00000EF8: 3b6dfff4ffec  move.w -$c(a5), -$14(a5)
        move.w -$c(a5), -$14(a5)
L011_00000EFE:
; H011+$00000EFE: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_00000F02:
; H011+$00000F02: 426dffe8  clr.w -$18(a5)
        clr.w -$18(a5)
L011_00000F06:
; H011+$00000F06: 0c6d0003ffea  cmpi.w #$3, -$16(a5)
        cmpi.w #$3, -$16(a5)
L011_00000F0C:
; H011+$00000F0C: 6400009c  bcc.w $faa
        bcc.w H011+$FAA
L011_00000F10:
; H011+$00000F10: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000F14:
; H011+$00000F14: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000F18:
; H011+$00000F18: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000F1C:
; H011+$00000F1C: 6100f28c  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000F20:
; H011+$00000F20: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L011_00000F24:
; H011+$00000F24: 4a6dffe4  tst.w -$1c(a5)
        tst.w -$1c(a5)
L011_00000F28:
; H011+$00000F28: 67000044  beq.w $f6e
        beq.w H011+$F6E
L011_00000F2C:
; H011+$00000F2C: 4a6dffea  tst.w -$16(a5)
        tst.w -$16(a5)
L011_00000F30:
; H011+$00000F30: 66000020  bne.w $f52
        bne.w H011+$F52
L011_00000F34:
; H011+$00000F34: 342cffaa  move.w -$56(a4), d2
        move.w -$56(a4), d2
L011_00000F38:
; H011+$00000F38: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000F3C:
; H011+$00000F3C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000F3E:
; H011+$00000F3E: 3f2cff96  move.w -$6a(a4), -(a7)
        move.w -$6a(a4), -(a7)
L011_00000F42:
; H011+$00000F42: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_00000F46:
; H011+$00000F46: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L011_00000F4A:
; H011+$00000F4A: 6100f91c  bsr.w $868
        bsr.w H011+$868
L011_00000F4E:
; H011+$00000F4E: 6000001e  bra.w $f6e
        bra.w H011+$F6E
L011_00000F52:
; H011+$00000F52: 342cffaa  move.w -$56(a4), d2
        move.w -$56(a4), d2
L011_00000F56:
; H011+$00000F56: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000F5A:
; H011+$00000F5A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00000F5C:
; H011+$00000F5C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000F5E:
; H011+$00000F5E: 3f2cff96  move.w -$6a(a4), -(a7)
        move.w -$6a(a4), -(a7)
L011_00000F62:
; H011+$00000F62: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_00000F66:
; H011+$00000F66: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L011_00000F6A:
; H011+$00000F6A: 6100f8fc  bsr.w $868
        bsr.w H011+$868
L011_00000F6E:
; H011+$00000F6E: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_00000F72:
; H011+$00000F72: 556dffe8  subq.w #$2, -$18(a5)
        subq.w #$2, -$18(a5)
L011_00000F76:
; H011+$00000F76: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000F7A:
; H011+$00000F7A: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000F7C:
; H011+$00000F7C: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00000F82:
; H011+$00000F82: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00000F86:
; H011+$00000F86: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00000F8A:
; H011+$00000F8A: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00000F8E:
; H011+$00000F8E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00000F92:
; H011+$00000F92: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00000F94:
; H011+$00000F94: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00000F9A:
; H011+$00000F9A: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00000F9E:
; H011+$00000F9E: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00000FA2:
; H011+$00000FA2: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_00000FA6:
; H011+$00000FA6: 6000ff5e  bra.w $f06
        bra.w H011+$F06
L011_00000FAA:
; H011+$00000FAA: 3b6dfff6ffee  move.w -$a(a5), -$12(a5)
        move.w -$a(a5), -$12(a5)
L011_00000FB0:
; H011+$00000FB0: 3b6dfff4ffec  move.w -$c(a5), -$14(a5)
        move.w -$c(a5), -$14(a5)
L011_00000FB6:
; H011+$00000FB6: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_00000FBA:
; H011+$00000FBA: 426dffe8  clr.w -$18(a5)
        clr.w -$18(a5)
L011_00000FBE:
; H011+$00000FBE: 0c6d0003ffea  cmpi.w #$3, -$16(a5)
        cmpi.w #$3, -$16(a5)
L011_00000FC4:
; H011+$00000FC4: 6400009c  bcc.w $1062
        bcc.w H011+$1062
L011_00000FC8:
; H011+$00000FC8: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00000FCC:
; H011+$00000FCC: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00000FD0:
; H011+$00000FD0: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00000FD4:
; H011+$00000FD4: 6100f1d4  bsr.w $1aa
        bsr.w H011+$1AA
L011_00000FD8:
; H011+$00000FD8: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L011_00000FDC:
; H011+$00000FDC: 4a6dffe4  tst.w -$1c(a5)
        tst.w -$1c(a5)
L011_00000FE0:
; H011+$00000FE0: 67000044  beq.w $1026
        beq.w H011+$1026
L011_00000FE4:
; H011+$00000FE4: 4a6dffea  tst.w -$16(a5)
        tst.w -$16(a5)
L011_00000FE8:
; H011+$00000FE8: 66000020  bne.w $100a
        bne.w H011+$100A
L011_00000FEC:
; H011+$00000FEC: 342cffac  move.w -$54(a4), d2
        move.w -$54(a4), d2
L011_00000FF0:
; H011+$00000FF0: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00000FF4:
; H011+$00000FF4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00000FF6:
; H011+$00000FF6: 3f2cff98  move.w -$68(a4), -(a7)
        move.w -$68(a4), -(a7)
L011_00000FFA:
; H011+$00000FFA: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_00000FFE:
; H011+$00000FFE: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L011_00001002:
; H011+$00001002: 6100f864  bsr.w $868
        bsr.w H011+$868
L011_00001006:
; H011+$00001006: 6000001e  bra.w $1026
        bra.w H011+$1026
L011_0000100A:
; H011+$0000100A: 342cffac  move.w -$54(a4), d2
        move.w -$54(a4), d2
L011_0000100E:
; H011+$0000100E: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00001012:
; H011+$00001012: 5242  addq.w #$1, d2
        addq.w #$1, d2
L011_00001014:
; H011+$00001014: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00001016:
; H011+$00001016: 3f2cff98  move.w -$68(a4), -(a7)
        move.w -$68(a4), -(a7)
L011_0000101A:
; H011+$0000101A: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_0000101E:
; H011+$0000101E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L011_00001022:
; H011+$00001022: 6100f844  bsr.w $868
        bsr.w H011+$868
L011_00001026:
; H011+$00001026: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_0000102A:
; H011+$0000102A: 546dffe8  addq.w #$2, -$18(a5)
        addq.w #$2, -$18(a5)
L011_0000102E:
; H011+$0000102E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00001032:
; H011+$00001032: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001034:
; H011+$00001034: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_0000103A:
; H011+$0000103A: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_0000103E:
; H011+$0000103E: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001042:
; H011+$00001042: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00001046:
; H011+$00001046: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_0000104A:
; H011+$0000104A: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000104C:
; H011+$0000104C: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00001052:
; H011+$00001052: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00001056:
; H011+$00001056: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_0000105A:
; H011+$0000105A: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_0000105E:
; H011+$0000105E: 6000ff5e  bra.w $fbe
        bra.w H011+$FBE
L011_00001062:
; H011+$00001062: 4e75  rts 
        rts 
L011_00001064:
; H011+$00001064: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00001068:
; H011+$00001068: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000106A:
; H011+$0000106A: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00001070:
; H011+$00001070: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L011_00001074:
; H011+$00001074: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001078:
; H011+$00001078: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_0000107C:
; H011+$0000107C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00001080:
; H011+$00001080: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001082:
; H011+$00001082: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00001088:
; H011+$00001088: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_0000108C:
; H011+$0000108C: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001090:
; H011+$00001090: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00001094:
; H011+$00001094: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00001098:
; H011+$00001098: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000109A:
; H011+$0000109A: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_000010A0:
; H011+$000010A0: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L011_000010A4:
; H011+$000010A4: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000010A8:
; H011+$000010A8: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_000010AC:
; H011+$000010AC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_000010B0:
; H011+$000010B0: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000010B2:
; H011+$000010B2: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_000010B8:
; H011+$000010B8: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_000010BC:
; H011+$000010BC: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000010C0:
; H011+$000010C0: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_000010C4:
; H011+$000010C4: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_000010C8:
; H011+$000010C8: 3b7cfffaffe8  move.w #$fffa, -$18(a5)
        move.w #$fffa, -$18(a5)
L011_000010CE:
; H011+$000010CE: 0c6d0003ffea  cmpi.w #$3, -$16(a5)
        cmpi.w #$3, -$16(a5)
L011_000010D4:
; H011+$000010D4: 640000aa  bcc.w $1180
        bcc.w H011+$1180
L011_000010D8:
; H011+$000010D8: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_000010DC:
; H011+$000010DC: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_000010E0:
; H011+$000010E0: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_000010E4:
; H011+$000010E4: 6100f0c4  bsr.w $1aa
        bsr.w H011+$1AA
L011_000010E8:
; H011+$000010E8: 3b40ffe6  move.w d0, -$1a(a5)
        move.w d0, -$1a(a5)
L011_000010EC:
; H011+$000010EC: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L011_000010F0:
; H011+$000010F0: 6700001c  beq.w $110e
        beq.w H011+$110E
L011_000010F4:
; H011+$000010F4: 342cffae  move.w -$52(a4), d2
        move.w -$52(a4), d2
L011_000010F8:
; H011+$000010F8: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_000010FC:
; H011+$000010FC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_000010FE:
; H011+$000010FE: 3f2cff9a  move.w -$66(a4), -(a7)
        move.w -$66(a4), -(a7)
L011_00001102:
; H011+$00001102: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L011_00001106:
; H011+$00001106: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L011_0000110A:
; H011+$0000110A: 6100f75c  bsr.w $868
        bsr.w H011+$868
L011_0000110E:
; H011+$0000110E: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00001112:
; H011+$00001112: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00001116:
; H011+$00001116: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_0000111A:
; H011+$0000111A: 6100f08e  bsr.w $1aa
        bsr.w H011+$1AA
L011_0000111E:
; H011+$0000111E: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L011_00001122:
; H011+$00001122: 4a6dffe4  tst.w -$1c(a5)
        tst.w -$1c(a5)
L011_00001126:
; H011+$00001126: 6700001c  beq.w $1144
        beq.w H011+$1144
L011_0000112A:
; H011+$0000112A: 342cffb0  move.w -$50(a4), d2
        move.w -$50(a4), d2
L011_0000112E:
; H011+$0000112E: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00001132:
; H011+$00001132: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00001134:
; H011+$00001134: 3f2cff9c  move.w -$64(a4), -(a7)
        move.w -$64(a4), -(a7)
L011_00001138:
; H011+$00001138: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_0000113C:
; H011+$0000113C: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_00001140:
; H011+$00001140: 6100f726  bsr.w $868
        bsr.w H011+$868
L011_00001144:
; H011+$00001144: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_00001148:
; H011+$00001148: 566dffe8  addq.w #$3, -$18(a5)
        addq.w #$3, -$18(a5)
L011_0000114C:
; H011+$0000114C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00001150:
; H011+$00001150: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001152:
; H011+$00001152: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00001158:
; H011+$00001158: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_0000115C:
; H011+$0000115C: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001160:
; H011+$00001160: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00001164:
; H011+$00001164: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00001168:
; H011+$00001168: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000116A:
; H011+$0000116A: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00001170:
; H011+$00001170: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00001174:
; H011+$00001174: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001178:
; H011+$00001178: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_0000117C:
; H011+$0000117C: 6000ff50  bra.w $10ce
        bra.w H011+$10CE
L011_00001180:
; H011+$00001180: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00001184:
; H011+$00001184: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001186:
; H011+$00001186: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_0000118C:
; H011+$0000118C: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L011_00001190:
; H011+$00001190: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001194:
; H011+$00001194: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00001198:
; H011+$00001198: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_0000119C:
; H011+$0000119C: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000119E:
; H011+$0000119E: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_000011A4:
; H011+$000011A4: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_000011A8:
; H011+$000011A8: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000011AC:
; H011+$000011AC: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_000011B0:
; H011+$000011B0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_000011B4:
; H011+$000011B4: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000011B6:
; H011+$000011B6: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_000011BC:
; H011+$000011BC: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L011_000011C0:
; H011+$000011C0: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000011C4:
; H011+$000011C4: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_000011C8:
; H011+$000011C8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_000011CC:
; H011+$000011CC: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000011CE:
; H011+$000011CE: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_000011D4:
; H011+$000011D4: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_000011D8:
; H011+$000011D8: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000011DC:
; H011+$000011DC: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_000011E0:
; H011+$000011E0: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_000011E4:
; H011+$000011E4: 3b7c0006ffe8  move.w #$6, -$18(a5)
        move.w #$6, -$18(a5)
L011_000011EA:
; H011+$000011EA: 0c6d0003ffea  cmpi.w #$3, -$16(a5)
        cmpi.w #$3, -$16(a5)
L011_000011F0:
; H011+$000011F0: 640000aa  bcc.w $129c
        bcc.w H011+$129C
L011_000011F4:
; H011+$000011F4: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_000011F8:
; H011+$000011F8: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_000011FC:
; H011+$000011FC: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00001200:
; H011+$00001200: 6100efa8  bsr.w $1aa
        bsr.w H011+$1AA
L011_00001204:
; H011+$00001204: 3b40ffe6  move.w d0, -$1a(a5)
        move.w d0, -$1a(a5)
L011_00001208:
; H011+$00001208: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L011_0000120C:
; H011+$0000120C: 6700001c  beq.w $122a
        beq.w H011+$122A
L011_00001210:
; H011+$00001210: 342cffae  move.w -$52(a4), d2
        move.w -$52(a4), d2
L011_00001214:
; H011+$00001214: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00001218:
; H011+$00001218: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_0000121A:
; H011+$0000121A: 3f2cff9a  move.w -$66(a4), -(a7)
        move.w -$66(a4), -(a7)
L011_0000121E:
; H011+$0000121E: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L011_00001222:
; H011+$00001222: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L011_00001226:
; H011+$00001226: 6100f640  bsr.w $868
        bsr.w H011+$868
L011_0000122A:
; H011+$0000122A: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_0000122E:
; H011+$0000122E: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00001232:
; H011+$00001232: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00001236:
; H011+$00001236: 6100ef72  bsr.w $1aa
        bsr.w H011+$1AA
L011_0000123A:
; H011+$0000123A: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L011_0000123E:
; H011+$0000123E: 4a6dffe4  tst.w -$1c(a5)
        tst.w -$1c(a5)
L011_00001242:
; H011+$00001242: 6700001c  beq.w $1260
        beq.w H011+$1260
L011_00001246:
; H011+$00001246: 342cffb2  move.w -$4e(a4), d2
        move.w -$4e(a4), d2
L011_0000124A:
; H011+$0000124A: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_0000124E:
; H011+$0000124E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00001250:
; H011+$00001250: 3f2cff9e  move.w -$62(a4), -(a7)
        move.w -$62(a4), -(a7)
L011_00001254:
; H011+$00001254: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_00001258:
; H011+$00001258: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L011_0000125C:
; H011+$0000125C: 6100f60a  bsr.w $868
        bsr.w H011+$868
L011_00001260:
; H011+$00001260: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_00001264:
; H011+$00001264: 576dffe8  subq.w #$3, -$18(a5)
        subq.w #$3, -$18(a5)
L011_00001268:
; H011+$00001268: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_0000126C:
; H011+$0000126C: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000126E:
; H011+$0000126E: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00001274:
; H011+$00001274: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00001278:
; H011+$00001278: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_0000127C:
; H011+$0000127C: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_00001280:
; H011+$00001280: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00001284:
; H011+$00001284: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001286:
; H011+$00001286: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_0000128C:
; H011+$0000128C: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_00001290:
; H011+$00001290: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001294:
; H011+$00001294: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_00001298:
; H011+$00001298: 6000ff50  bra.w $11ea
        bra.w H011+$11EA
L011_0000129C:
; H011+$0000129C: 4e75  rts 
        rts 
L011_0000129E:
; H011+$0000129E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_000012A2:
; H011+$000012A2: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000012A4:
; H011+$000012A4: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_000012AA:
; H011+$000012AA: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L011_000012AE:
; H011+$000012AE: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000012B2:
; H011+$000012B2: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_000012B6:
; H011+$000012B6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_000012BA:
; H011+$000012BA: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000012BC:
; H011+$000012BC: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_000012C2:
; H011+$000012C2: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L011_000012C6:
; H011+$000012C6: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000012CA:
; H011+$000012CA: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_000012CE:
; H011+$000012CE: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_000012D2:
; H011+$000012D2: 3b7cfff9ffe8  move.w #$fff9, -$18(a5)
        move.w #$fff9, -$18(a5)
L011_000012D8:
; H011+$000012D8: 0c6d0002ffea  cmpi.w #$2, -$16(a5)
        cmpi.w #$2, -$16(a5)
L011_000012DE:
; H011+$000012DE: 640000aa  bcc.w $138a
        bcc.w H011+$138A
L011_000012E2:
; H011+$000012E2: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_000012E6:
; H011+$000012E6: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_000012EA:
; H011+$000012EA: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_000012EE:
; H011+$000012EE: 6100eeba  bsr.w $1aa
        bsr.w H011+$1AA
L011_000012F2:
; H011+$000012F2: 3b40ffe6  move.w d0, -$1a(a5)
        move.w d0, -$1a(a5)
L011_000012F6:
; H011+$000012F6: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L011_000012FA:
; H011+$000012FA: 6700001c  beq.w $1318
        beq.w H011+$1318
L011_000012FE:
; H011+$000012FE: 342cffb4  move.w -$4c(a4), d2
        move.w -$4c(a4), d2
L011_00001302:
; H011+$00001302: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00001306:
; H011+$00001306: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_00001308:
; H011+$00001308: 3f2cffa0  move.w -$60(a4), -(a7)
        move.w -$60(a4), -(a7)
L011_0000130C:
; H011+$0000130C: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L011_00001310:
; H011+$00001310: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L011_00001314:
; H011+$00001314: 6100f552  bsr.w $868
        bsr.w H011+$868
L011_00001318:
; H011+$00001318: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_0000131C:
; H011+$0000131C: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_00001320:
; H011+$00001320: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00001324:
; H011+$00001324: 6100ee84  bsr.w $1aa
        bsr.w H011+$1AA
L011_00001328:
; H011+$00001328: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L011_0000132C:
; H011+$0000132C: 4a6dffe4  tst.w -$1c(a5)
        tst.w -$1c(a5)
L011_00001330:
; H011+$00001330: 6700001c  beq.w $134e
        beq.w H011+$134E
L011_00001334:
; H011+$00001334: 342cffb6  move.w -$4a(a4), d2
        move.w -$4a(a4), d2
L011_00001338:
; H011+$00001338: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_0000133C:
; H011+$0000133C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_0000133E:
; H011+$0000133E: 3f2cffa2  move.w -$5e(a4), -(a7)
        move.w -$5e(a4), -(a7)
L011_00001342:
; H011+$00001342: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_00001346:
; H011+$00001346: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L011_0000134A:
; H011+$0000134A: 6100f51c  bsr.w $868
        bsr.w H011+$868
L011_0000134E:
; H011+$0000134E: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_00001352:
; H011+$00001352: 5e6dffe8  addq.w #$7, -$18(a5)
        addq.w #$7, -$18(a5)
L011_00001356:
; H011+$00001356: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_0000135A:
; H011+$0000135A: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000135C:
; H011+$0000135C: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00001362:
; H011+$00001362: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00001366:
; H011+$00001366: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_0000136A:
; H011+$0000136A: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_0000136E:
; H011+$0000136E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_00001372:
; H011+$00001372: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001374:
; H011+$00001374: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_0000137A:
; H011+$0000137A: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_0000137E:
; H011+$0000137E: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001382:
; H011+$00001382: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_00001386:
; H011+$00001386: 6000ff50  bra.w $12d8
        bra.w H011+$12D8
L011_0000138A:
; H011+$0000138A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_0000138E:
; H011+$0000138E: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001390:
; H011+$00001390: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_00001396:
; H011+$00001396: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L011_0000139A:
; H011+$0000139A: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_0000139E:
; H011+$0000139E: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_000013A2:
; H011+$000013A2: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L011_000013A6:
; H011+$000013A6: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000013A8:
; H011+$000013A8: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_000013AE:
; H011+$000013AE: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L011_000013B2:
; H011+$000013B2: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000013B6:
; H011+$000013B6: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_000013BA:
; H011+$000013BA: 426dffea  clr.w -$16(a5)
        clr.w -$16(a5)
L011_000013BE:
; H011+$000013BE: 3b7c0007ffe8  move.w #$7, -$18(a5)
        move.w #$7, -$18(a5)
L011_000013C4:
; H011+$000013C4: 0c6d0002ffea  cmpi.w #$2, -$16(a5)
        cmpi.w #$2, -$16(a5)
L011_000013CA:
; H011+$000013CA: 640000aa  bcc.w $1476
        bcc.w H011+$1476
L011_000013CE:
; H011+$000013CE: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_000013D2:
; H011+$000013D2: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_000013D6:
; H011+$000013D6: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_000013DA:
; H011+$000013DA: 6100edce  bsr.w $1aa
        bsr.w H011+$1AA
L011_000013DE:
; H011+$000013DE: 3b40ffe6  move.w d0, -$1a(a5)
        move.w d0, -$1a(a5)
L011_000013E2:
; H011+$000013E2: 4a6dffe6  tst.w -$1a(a5)
        tst.w -$1a(a5)
L011_000013E6:
; H011+$000013E6: 6700001c  beq.w $1404
        beq.w H011+$1404
L011_000013EA:
; H011+$000013EA: 342cffb4  move.w -$4c(a4), d2
        move.w -$4c(a4), d2
L011_000013EE:
; H011+$000013EE: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_000013F2:
; H011+$000013F2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_000013F4:
; H011+$000013F4: 3f2cffa0  move.w -$60(a4), -(a7)
        move.w -$60(a4), -(a7)
L011_000013F8:
; H011+$000013F8: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L011_000013FC:
; H011+$000013FC: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L011_00001400:
; H011+$00001400: 6100f466  bsr.w $868
        bsr.w H011+$868
L011_00001404:
; H011+$00001404: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_00001408:
; H011+$00001408: 3f2dffec  move.w -$14(a5), -(a7)
        move.w -$14(a5), -(a7)
L011_0000140C:
; H011+$0000140C: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L011_00001410:
; H011+$00001410: 6100ed98  bsr.w $1aa
        bsr.w H011+$1AA
L011_00001414:
; H011+$00001414: 3b40ffe4  move.w d0, -$1c(a5)
        move.w d0, -$1c(a5)
L011_00001418:
; H011+$00001418: 4a6dffe4  tst.w -$1c(a5)
        tst.w -$1c(a5)
L011_0000141C:
; H011+$0000141C: 6700001c  beq.w $143a
        beq.w H011+$143A
L011_00001420:
; H011+$00001420: 342cffb8  move.w -$48(a4), d2
        move.w -$48(a4), d2
L011_00001424:
; H011+$00001424: d46dffe8  add.w -$18(a5), d2
        add.w -$18(a5), d2
L011_00001428:
; H011+$00001428: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L011_0000142A:
; H011+$0000142A: 3f2cffa4  move.w -$5c(a4), -(a7)
        move.w -$5c(a4), -(a7)
L011_0000142E:
; H011+$0000142E: 3f2dffe4  move.w -$1c(a5), -(a7)
        move.w -$1c(a5), -(a7)
L011_00001432:
; H011+$00001432: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L011_00001436:
; H011+$00001436: 6100f430  bsr.w $868
        bsr.w H011+$868
L011_0000143A:
; H011+$0000143A: 526dffea  addq.w #$1, -$16(a5)
        addq.w #$1, -$16(a5)
L011_0000143E:
; H011+$0000143E: 5f6dffe8  subq.w #$7, -$18(a5)
        subq.w #$7, -$18(a5)
L011_00001442:
; H011+$00001442: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00001446:
; H011+$00001446: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001448:
; H011+$00001448: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_0000144E:
; H011+$0000144E: 382dffee  move.w -$12(a5), d4
        move.w -$12(a5), d4
L011_00001452:
; H011+$00001452: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_00001456:
; H011+$00001456: 3b44ffee  move.w d4, -$12(a5)
        move.w d4, -$12(a5)
L011_0000145A:
; H011+$0000145A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_0000145E:
; H011+$0000145E: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001460:
; H011+$00001460: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_00001466:
; H011+$00001466: 382dffec  move.w -$14(a5), d4
        move.w -$14(a5), d4
L011_0000146A:
; H011+$0000146A: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_0000146E:
; H011+$0000146E: 3b44ffec  move.w d4, -$14(a5)
        move.w d4, -$14(a5)
L011_00001472:
; H011+$00001472: 6000ff50  bra.w $13c4
        bra.w H011+$13C4
L011_00001476:
; H011+$00001476: 4e75  rts 
        rts 
L011_00001478:
; H011+$00001478: 4e75  rts 
        rts 
; Preserved bytes H011+$0000147A..$00001482; code/data not fully classified.
        dc.w $FFFC,$FE22,$FBE8,$F7CE
L011_00001482:
; H011+$00001482: 47fafff8  lea.l $147c(pc), a3
        lea.l H011+$147C(pc), a3
L011_00001486:
; H011+$00001486: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L011_0000148A:
; H011+$0000148A: 6302  bls.b $148e
        bls.b H011+$148E
L011_0000148C:
; H011+$0000148C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L011_0000148E:
; H011+$0000148E: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_00001490:
; H011+$00001490: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H011+$147C; indici 0..2, default -1.
L011_00001494:
; H011+$00001494: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L011_00001498:
; H011+$00001498: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_0000149C:
; H011+$0000149C: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000149E:
; H011+$0000149E: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L011_000014A4:
; H011+$000014A4: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L011_000014A8:
; H011+$000014A8: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000014AC:
; H011+$000014AC: 3b44fff6  move.w d4, -$a(a5)
        move.w d4, -$a(a5)
L011_000014B0:
; H011+$000014B0: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L011_000014B4:
; H011+$000014B4: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_000014B6:
; H011+$000014B6: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L011_000014BC:
; H011+$000014BC: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L011_000014C0:
; H011+$000014C0: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L011_000014C4:
; H011+$000014C4: 3b44fff4  move.w d4, -$c(a5)
        move.w d4, -$c(a5)
L011_000014C8:
; H011+$000014C8: 536dfff8  subq.w #$1, -$8(a5)
        subq.w #$1, -$8(a5)
L011_000014CC:
; H011+$000014CC: 0c6dfffffff8  cmpi.w #$ffff, -$8(a5)
        cmpi.w #$ffff, -$8(a5)
L011_000014D2:
; H011+$000014D2: 6e00f76e  bgt.w $c42
        bgt.w H011+$C42
; -> H029+$16DE (sub_H029_000016DE)
L011_000014D6:
; H011+$000014D6: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L011_000014DC:
; H011+$000014DC: 6100ec2e  bsr.w $10c
        bsr.w H011+$10C
L011_000014E0:
; H011+$000014E0: 4e5d  unlk a5
        unlk a5
L011_000014E2:
; H011+$000014E2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_000014E4:
; H011+$000014E4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_000014E6:
; H011+$000014E6: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L011_000014E8:
; H011+$000014E8: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Load_WallDefinitions [parziale]
; Scopo: Carica una definizione WALLDEF per uno degli insiemi della vista 3D.
;   - Accetta un indice di insieme compreso fra 1 e 3.
;   - Compone WALLDEF<gruppo>.dax e carica il blocco richiesto.
;   - Usa 780 byte ($030C) come unità per controllare dimensione/range.
;   - Adatta i dati alle tabelle usate per disegnare la vista.
; Chiamanti diretti: H061+$2AF4, H061+$2B28, H061+$2B5C, H064+$10C8, H064+$1100, H064+$1136, H064+$118E, H066+$2FCA
; --------------------------------------------------------------------------
L011_000014EA:
; H011+$000014EA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_000014EC:
; H011+$000014EC: 287aec0c  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_000014F0:
; H011+$000014F0: 4e55ff42  link.w a5, #$ff42
        link.w a5, #$ff42
L011_000014F4:
; H011+$000014F4: 0c6d0001000c  cmpi.w #$1, $c(a5)
        cmpi.w #$1, $c(a5)
L011_000014FA:
; H011+$000014FA: 6500000c  bcs.w $1508
        bcs.w H011+$1508
L011_000014FE:
; H011+$000014FE: 0c6d0003000c  cmpi.w #$3, $c(a5)
        cmpi.w #$3, $c(a5)
L011_00001504:
; H011+$00001504: 63000006  bls.w $150c
        bls.w H011+$150C
L011_00001508:
; H011+$00001508: 60000362  bra.w $186c
        bra.w H011+$186C
L011_0000150C:
; H011+$0000150C: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_00001510:
; H011+$00001510: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
L011_00001514:
; H011+$00001514: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$246E = selettore del gruppo risorse
L011_00001516:
; H011+$00001516: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L011_0000151C:
; H011+$0000151C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L011_0000151E:
; H011+$0000151E: 4227  clr.b -(a7)
        clr.b -(a7)
L011_00001520:
; H011+$00001520: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L011_00001524:
; H011+$00001524: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L011_00001528:
; H011+$00001528: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L011_0000152C:
; H011+$0000152C: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L011_00001532:
; H011+$00001532: 47ec0000  lea.l $0(a4), a3
        lea.l $0(a4), a3
L011_00001536:
; H011+$00001536: 45edff96  lea.l -$6a(a5), a2
        lea.l -$6a(a5), a2
L011_0000153A:
; H011+$0000153A: 7450  moveq #$50, d2
        moveq #80, d2
L011_0000153C:
; H011+$0000153C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L011_0000153E:
; H011+$0000153E: 57cafffc  dbeq d2, $153c
        dbeq d2, H011+$153C
L011_00001542:
; H011+$00001542: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_00001546:
; H011+$00001546: 486dff96  pea.l -$6a(a5)
        pea.l -$6a(a5)
L011_0000154A:
; H011+$0000154A: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_0000154E:
; H011+$0000154E: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L011_00001552:
; H011+$00001552: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L011_00001558:
; H011+$00001558: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_0000155C:
; H011+$0000155C: 486dff96  pea.l -$6a(a5)
        pea.l -$6a(a5)
L011_00001560:
; H011+$00001560: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_00001564:
; H011+$00001564: 486c0008  pea.l $8(a4)
        pea.l $8(a4)
L011_00001568:
; H011+$00001568: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L011_0000156C:
; H011+$0000156C: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L011_00001570:
; H011+$00001570: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
; FLUSSO: Chiama DAX_LoadBlock (H028+$0DD8).
L011_00001574:
; H011+$00001574: 4eb900000dd8  jsr $dd8.l
        jsr (FN_DAX_load_block).l
L011_0000157A:
; H011+$0000157A: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L011_0000157E:
; H011+$0000157E: 67000018  beq.w $1598
        beq.w H011+$1598
L011_00001582:
; H011+$00001582: 7400  moveq #$0, d2
        moveq #0, d2
L011_00001584:
; H011+$00001584: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00001588:
; H011+$00001588: 84fc030c  divu.w #$30c, d2
        divu.w #$30c, d2
L011_0000158C:
; H011+$0000158C: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_00001590:
; H011+$00001590: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L011_00001594:
; H011+$00001594: 63000092  bls.w $1628
        bls.w H011+$1628
L011_00001598:
; H011+$00001598: 47ec000d  lea.l $d(a4), a3
        lea.l $d(a4), a3
L011_0000159C:
; H011+$0000159C: 45edff44  lea.l -$bc(a5), a2
        lea.l -$bc(a5), a2
L011_000015A0:
; H011+$000015A0: 7450  moveq #$50, d2
        moveq #80, d2
L011_000015A2:
; H011+$000015A2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L011_000015A4:
; H011+$000015A4: 57cafffc  dbeq d2, $15a2
        dbeq d2, H011+$15A2
L011_000015A8:
; H011+$000015A8: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_000015AC:
; H011+$000015AC: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
L011_000015B0:
; H011+$000015B0: 7400  moveq #$0, d2
        moveq #0, d2
L011_000015B2:
; H011+$000015B2: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_000015B6:
; H011+$000015B6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L011_000015B8:
; H011+$000015B8: 4227  clr.b -(a7)
        clr.b -(a7)
L011_000015BA:
; H011+$000015BA: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L011_000015BE:
; H011+$000015BE: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_000015C2:
; H011+$000015C2: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L011_000015C6:
; H011+$000015C6: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L011_000015CC:
; H011+$000015CC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_000015D0:
; H011+$000015D0: 486dff44  pea.l -$bc(a5)
        pea.l -$bc(a5)
L011_000015D4:
; H011+$000015D4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_000015D8:
; H011+$000015D8: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L011_000015DC:
; H011+$000015DC: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L011_000015E2:
; H011+$000015E2: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_000015E6:
; H011+$000015E6: 486dff44  pea.l -$bc(a5)
        pea.l -$bc(a5)
L011_000015EA:
; H011+$000015EA: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L011_000015EE:
; H011+$000015EE: 486c001d  pea.l $1d(a4)
        pea.l $1d(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L011_000015F2:
; H011+$000015F2: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L011_000015F8:
; H011+$000015F8: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_000015FC:
; H011+$000015FC: 486dff44  pea.l -$bc(a5)
        pea.l -$bc(a5)
L011_00001600:
; H011+$00001600: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_00001604:
; H011+$00001604: 486dff96  pea.l -$6a(a5)
        pea.l -$6a(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L011_00001608:
; H011+$00001608: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L011_0000160E:
; H011+$0000160E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_00001612:
; H011+$00001612: 486dff44  pea.l -$bc(a5)
        pea.l -$bc(a5)
; -> H010+$0360 (sub_H010_00000360)
L011_00001616:
; H011+$00001616: 4eb900000360  jsr $360.l
        jsr (H010+$360).l
; -> H010+$0974 (sub_H010_00000974)
L011_0000161C:
; H011+$0000161C: 4eb900000974  jsr $974.l
        jsr (H010+$974).l
; -> H010+$0332 (sub_H010_00000332)
L011_00001622:
; H011+$00001622: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L011_00001628:
; H011+$00001628: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_0000162C:
; H011+$0000162C: e342  asl.w #$1, d2
        asl.w #$1, d2
L011_0000162E:
; H011+$0000162E: 47f900003ec6  lea.l $3ec6.l, a3
        lea.l (H005+$3EC6).l, a3
L011_00001634:
; H011+$00001634: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L011_00001638:
; H011+$00001638: 987900003ec8  sub.w $3ec8.l, d4
        sub.w (H005+$3EC8).l, d4
L011_0000163E:
; H011+$0000163E: 3b44fff6  move.w d4, -$a(a5)
        move.w d4, -$a(a5)
L011_00001642:
; H011+$00001642: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L011_00001646:
; H011+$00001646: 3b7c0001fff2  move.w #$1, -$e(a5)
        move.w #$1, -$e(a5)
L011_0000164C:
; H011+$0000164C: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L011_00001650:
; H011+$00001650: 266dfffa  movea.l -$6(a5), a3
        movea.l -$6(a5), a3
L011_00001654:
; H011+$00001654: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00001658:
; H011+$00001658: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_0000165A:
; H011+$0000165A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_0000165E:
; H011+$0000165E: d46dfff2  add.w -$e(a5), d2
        add.w -$e(a5), d2
L011_00001662:
; H011+$00001662: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00001664:
; H011+$00001664: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00001666:
; H011+$00001666: c5fc030c  muls.w #$30c, d2
        muls.w #$30c, d2
L011_0000166A:
; H011+$0000166A: 26790000282e  movea.l $282e.l, a3
        movea.l (H005+$282E).l, a3
L011_00001670:
; H011+$00001670: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L011_00001674:
; H011+$00001674: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_00001676:
; H011+$00001676: 243c0000030c  move.l #$30c, d2
        move.l #$30c, d2
L011_0000167C:
; H011+$0000167C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L011_0000167E:
; H011+$0000167E: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L011_00001684:
; H011+$00001684: 066d030cfff8  addi.w #$30c, -$8(a5)
        addi.w #$30c, -$8(a5)
L011_0000168A:
; H011+$0000168A: 526dfff2  addq.w #$1, -$e(a5)
        addq.w #$1, -$e(a5)
L011_0000168E:
; H011+$0000168E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_00001692:
; H011+$00001692: 04420100  subi.w #$100, d2
        subi.w #$100, d2
L011_00001696:
; H011+$00001696: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L011_0000169A:
; H011+$0000169A: b842  cmp.w d2, d4
        cmp.w d2, d4
L011_0000169C:
; H011+$0000169C: 65ae  bcs.b $164c
        bcs.b H011+$164C
L011_0000169E:
; H011+$0000169E: 2f2dfffa  move.l -$6(a5), -(a7)
        move.l -$6(a5), -(a7)
L011_000016A2:
; H011+$000016A2: 7400  moveq #$0, d2
        moveq #0, d2
L011_000016A4:
; H011+$000016A4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L011_000016A8:
; H011+$000016A8: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L011_000016AA:
; H011+$000016AA: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L011_000016B0:
; H011+$000016B0: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_000016B4:
; H011+$000016B4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_000016B6:
; H011+$000016B6: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L011_000016BA:
; H011+$000016BA: 3b7c0001fff2  move.w #$1, -$e(a5)
        move.w #$1, -$e(a5)
L011_000016C0:
; H011+$000016C0: 3f2dffee  move.w -$12(a5), -(a7)
        move.w -$12(a5), -(a7)
L011_000016C4:
; H011+$000016C4: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_000016C8:
; H011+$000016C8: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L011_000016CA:
; H011+$000016CA: 62000176  bhi.w $1842
        bhi.w H011+$1842
L011_000016CE:
; H011+$000016CE: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_000016D2:
; H011+$000016D2: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_000016D6:
; H011+$000016D6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_000016D8:
; H011+$000016D8: 4a42  tst.w d2
        tst.w d2
L011_000016DA:
; H011+$000016DA: 6300015e  bls.w $183a
        bls.w H011+$183A
L011_000016DE:
; H011+$000016DE: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_000016E2:
; H011+$000016E2: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_000016E6:
; H011+$000016E6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_000016E8:
; H011+$000016E8: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L011_000016EC:
; H011+$000016EC: 6400014c  bcc.w $183a
        bcc.w H011+$183A
L011_000016F0:
; H011+$000016F0: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_000016F4:
; H011+$000016F4: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_000016F8:
; H011+$000016F8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_000016FA:
; H011+$000016FA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_000016FC:
; H011+$000016FC: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATO: H005+$2810 = tre elementi di stato degli insiemi pareti
L011_000016FE:
; H011+$000016FE: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L011_00001704:
; H011+$00001704: 37bcffff2000  move.w #$ffff, (a3, d2.w)
        move.w #$ffff, (a3, d2.w)
L011_0000170A:
; H011+$0000170A: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_0000170E:
; H011+$0000170E: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_00001712:
; H011+$00001712: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00001714:
; H011+$00001714: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00001716:
; H011+$00001716: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATO: H005+$2810 = tre elementi di stato degli insiemi pareti
L011_00001718:
; H011+$00001718: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L011_0000171E:
; H011+$0000171E: 37bcffff2002  move.w #$ffff, $2(a3, d2.w)
        move.w #$ffff, $2(a3, d2.w)
L011_00001724:
; H011+$00001724: 3b7c0001fff4  move.w #$1, -$c(a5)
        move.w #$1, -$c(a5)
L011_0000172A:
; H011+$0000172A: 0c6d0005fff4  cmpi.w #$5, -$c(a5)
        cmpi.w #$5, -$c(a5)
L011_00001730:
; H011+$00001730: 620000c2  bhi.w $17f4
        bhi.w H011+$17F4
L011_00001734:
; H011+$00001734: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L011_00001738:
; H011+$00001738: 0c6d009bfff0  cmpi.w #$9b, -$10(a5)
        cmpi.w #$9b, -$10(a5)
L011_0000173E:
; H011+$0000173E: 620000ac  bhi.w $17ec
        bhi.w H011+$17EC
L011_00001742:
; H011+$00001742: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_00001746:
; H011+$00001746: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_0000174A:
; H011+$0000174A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_0000174C:
; H011+$0000174C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_0000174E:
; H011+$0000174E: c5fc030c  muls.w #$30c, d2
        muls.w #$30c, d2
L011_00001752:
; H011+$00001752: 26790000282e  movea.l $282e.l, a3
        movea.l (H005+$282E).l, a3
L011_00001758:
; H011+$00001758: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L011_0000175C:
; H011+$0000175C: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_0000175E:
; H011+$0000175E: c9fc009c  muls.w #$9c, d4
        muls.w #$9c, d4
L011_00001762:
; H011+$00001762: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L011_00001766:
; H011+$00001766: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L011_0000176A:
; H011+$0000176A: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L011_0000176E:
; H011+$0000176E: 7800  moveq #$0, d4
        moveq #0, d4
L011_00001770:
; H011+$00001770: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L011_00001774:
; H011+$00001774: b87900003ebc  cmp.w $3ebc.l, d4
        cmp.w (H005+$3EBC).l, d4
L011_0000177A:
; H011+$0000177A: 65000068  bcs.w $17e4
        bcs.w H011+$17E4
L011_0000177E:
; H011+$0000177E: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_00001782:
; H011+$00001782: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_00001786:
; H011+$00001786: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00001788:
; H011+$00001788: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_0000178A:
; H011+$0000178A: c5fc030c  muls.w #$30c, d2
        muls.w #$30c, d2
L011_0000178E:
; H011+$0000178E: 26790000282e  movea.l $282e.l, a3
        movea.l (H005+$282E).l, a3
L011_00001794:
; H011+$00001794: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L011_00001798:
; H011+$00001798: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_0000179A:
; H011+$0000179A: c9fc009c  muls.w #$9c, d4
        muls.w #$9c, d4
L011_0000179E:
; H011+$0000179E: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L011_000017A2:
; H011+$000017A2: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L011_000017A6:
; H011+$000017A6: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L011_000017AA:
; H011+$000017AA: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L011_000017AE:
; H011+$000017AE: d86d000c  add.w $c(a5), d4
        add.w $c(a5), d4
L011_000017B2:
; H011+$000017B2: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_000017B4:
; H011+$000017B4: 5344  subq.w #$1, d4
        subq.w #$1, d4
L011_000017B6:
; H011+$000017B6: c9fc030c  muls.w #$30c, d4
        muls.w #$30c, d4
L011_000017BA:
; H011+$000017BA: 24790000282e  movea.l $282e.l, a2
        movea.l (H005+$282E).l, a2
L011_000017C0:
; H011+$000017C0: 3c2dfff4  move.w -$c(a5), d6
        move.w -$c(a5), d6
L011_000017C4:
; H011+$000017C4: 5346  subq.w #$1, d6
        subq.w #$1, d6
L011_000017C6:
; H011+$000017C6: cdfc009c  muls.w #$9c, d6
        muls.w #$9c, d6
L011_000017CA:
; H011+$000017CA: 45f24800  lea.l (a2, d4.l), a2
        lea.l (a2, d4.l), a2
L011_000017CE:
; H011+$000017CE: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L011_000017D2:
; H011+$000017D2: 45f26800  lea.l (a2, d6.l), a2
        lea.l (a2, d6.l), a2
L011_000017D6:
; H011+$000017D6: 7c00  moveq #$0, d6
        moveq #0, d6
L011_000017D8:
; H011+$000017D8: 1c324000  move.b (a2, d4.w), d6
        move.b (a2, d4.w), d6
L011_000017DC:
; H011+$000017DC: dc6dfff6  add.w -$a(a5), d6
        add.w -$a(a5), d6
L011_000017E0:
; H011+$000017E0: 17862000  move.b d6, (a3, d2.w)
        move.b d6, (a3, d2.w)
L011_000017E4:
; H011+$000017E4: 526dfff0  addq.w #$1, -$10(a5)
        addq.w #$1, -$10(a5)
L011_000017E8:
; H011+$000017E8: 6400ff4e  bcc.w $1738
        bcc.w H011+$1738
L011_000017EC:
; H011+$000017EC: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L011_000017F0:
; H011+$000017F0: 6400ff38  bcc.w $172a
        bcc.w H011+$172A
L011_000017F4:
; H011+$000017F4: 0c6d0001ffee  cmpi.w #$1, -$12(a5)
        cmpi.w #$1, -$12(a5)
L011_000017FA:
; H011+$000017FA: 63000026  bls.w $1822
        bls.w H011+$1822
L011_000017FE:
; H011+$000017FE: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00001802:
; H011+$00001802: c4fc000a  mulu.w #$a, d2
        mulu.w #$a, d2
L011_00001806:
; H011+$00001806: d46dfff2  add.w -$e(a5), d2
        add.w -$e(a5), d2
L011_0000180A:
; H011+$0000180A: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L011_0000180C:
; H011+$0000180C: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_00001810:
; H011+$00001810: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_00001814:
; H011+$00001814: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00001816:
; H011+$00001816: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
; -> H034+$0032 (sub_H034_00000032)
L011_00001818:
; H011+$00001818: 4eb900000032  jsr $32.l
        jsr (H034+$32).l
L011_0000181E:
; H011+$0000181E: 6000001a  bra.w $183a
        bra.w H011+$183A
L011_00001822:
; H011+$00001822: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L011_00001826:
; H011+$00001826: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L011_00001828:
; H011+$00001828: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L011_0000182C:
; H011+$0000182C: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L011_00001830:
; H011+$00001830: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_00001832:
; H011+$00001832: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
; -> H034+$0032 (sub_H034_00000032)
L011_00001834:
; H011+$00001834: 4eb900000032  jsr $32.l
        jsr (H034+$32).l
L011_0000183A:
; H011+$0000183A: 526dfff2  addq.w #$1, -$e(a5)
        addq.w #$1, -$e(a5)
L011_0000183E:
; H011+$0000183E: 6400fe84  bcc.w $16c4
        bcc.w H011+$16C4
L011_00001842:
; H011+$00001842: 548f  addq.l #$2, a7
        addq.l #$2, a7
L011_00001844:
; H011+$00001844: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_00001848:
; H011+$00001848: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_0000184A:
; H011+$0000184A: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATO: H005+$2810 = tre elementi di stato degli insiemi pareti
L011_0000184C:
; H011+$0000184C: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L011_00001852:
; H011+$00001852: 37ad000e2000  move.w $e(a5), (a3, d2.w)
        move.w $e(a5), (a3, d2.w)
L011_00001858:
; H011+$00001858: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L011_0000185C:
; H011+$0000185C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L011_0000185E:
; H011+$0000185E: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATO: H005+$2810 = tre elementi di stato degli insiemi pareti
L011_00001860:
; H011+$00001860: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L011_00001866:
; H011+$00001866: 37ad000c2002  move.w $c(a5), $2(a3, d2.w)
        move.w $c(a5), $2(a3, d2.w)
L011_0000186C:
; H011+$0000186C: 4e5d  unlk a5
        unlk a5
L011_0000186E:
; H011+$0000186E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_00001870:
; H011+$00001870: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_00001872:
; H011+$00001872: 588f  addq.l #$4, a7
        addq.l #$4, a7
L011_00001874:
; H011+$00001874: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Load3DMap_GEO [verificato]
; Scopo: Carica una mappa GEO e distribuisce i dati nei buffer della mappa.
;   - Compone GEO<gruppo>.dax e richiede l’ID passato.
;   - Nel campione ogni blocco è lungo 1026 byte.
;   - Salta i primi due byte e copia porzioni da 256 byte nel buffer H005+$282A.
;   - La semantica completa dei singoli bit delle celle resta aperta.
; Chiamanti diretti: H064+$109E, H066+$2F7A
; --------------------------------------------------------------------------
L011_00001876:
; H011+$00001876: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L011_00001878:
; H011+$00001878: 287ae880  movea.l $fa(pc), a4
        movea.l H011+$FA(pc), a4
L011_0000187C:
; H011+$0000187C: 4e55ff9e  link.w a5, #$ff9e
        link.w a5, #$ff9e
L011_00001880:
; H011+$00001880: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L011_00001884:
; H011+$00001884: 486dffa4  pea.l -$5c(a5)
        pea.l -$5c(a5)
L011_00001888:
; H011+$00001888: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$246E = selettore del gruppo risorse
L011_0000188A:
; H011+$0000188A: 14390000246e  move.b $246e.l, d2
        move.b (H005+$246E).l, d2
L011_00001890:
; H011+$00001890: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L011_00001892:
; H011+$00001892: 4227  clr.b -(a7)
        clr.b -(a7)
L011_00001894:
; H011+$00001894: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L011_00001898:
; H011+$00001898: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L011_0000189C:
; H011+$0000189C: 1f3c0030  move.b #$30, -(a7)
        move.b #$30, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L011_000018A0:
; H011+$000018A0: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L011_000018A6:
; H011+$000018A6: 47ec0024  lea.l $24(a4), a3
        lea.l $24(a4), a3
L011_000018AA:
; H011+$000018AA: 45edffae  lea.l -$52(a5), a2
        lea.l -$52(a5), a2
L011_000018AE:
; H011+$000018AE: 7450  moveq #$50, d2
        moveq #80, d2
L011_000018B0:
; H011+$000018B0: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L011_000018B2:
; H011+$000018B2: 57cafffc  dbeq d2, $18b0
        dbeq d2, H011+$18B0
L011_000018B6:
; H011+$000018B6: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_000018BA:
; H011+$000018BA: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L011_000018BE:
; H011+$000018BE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L011_000018C2:
; H011+$000018C2: 486dffa4  pea.l -$5c(a5)
        pea.l -$5c(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L011_000018C6:
; H011+$000018C6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L011_000018CC:
; H011+$000018CC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L011_000018D0:
; H011+$000018D0: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L011_000018D4:
; H011+$000018D4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L011_000018D8:
; H011+$000018D8: 486c0028  pea.l $28(a4)
        pea.l $28(a4)
L011_000018DC:
; H011+$000018DC: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L011_000018E0:
; H011+$000018E0: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L011_000018E4:
; H011+$000018E4: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
; FLUSSO: Chiama DAX_LoadBlock (H028+$0DD8).
L011_000018E8:
; H011+$000018E8: 4eb900000dd8  jsr $dd8.l
        jsr (FN_DAX_load_block).l
L011_000018EE:
; H011+$000018EE: 4a6dffac  tst.w -$54(a5)
        tst.w -$54(a5)
L011_000018F2:
; H011+$000018F2: 6600001c  bne.w $1910
        bne.w H011+$1910
L011_000018F6:
; H011+$000018F6: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
L011_000018FA:
; H011+$000018FA: 486c002d  pea.l $2d(a4)
        pea.l $2d(a4)
; -> H010+$0360 (sub_H010_00000360)
L011_000018FE:
; H011+$000018FE: 4eb900000360  jsr $360.l
        jsr (H010+$360).l
; -> H010+$0974 (sub_H010_00000974)
L011_00001904:
; H011+$00001904: 4eb900000974  jsr $974.l
        jsr (H010+$974).l
; -> H010+$0332 (sub_H010_00000332)
L011_0000190A:
; H011+$0000190A: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L011_00001910:
; H011+$00001910: 3b7c0002ffa6  move.w #$2, -$5a(a5)
        move.w #$2, -$5a(a5)
L011_00001916:
; H011+$00001916: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L011_0000191A:
; H011+$0000191A: 266dffa8  movea.l -$58(a5), a3
        movea.l -$58(a5), a3
L011_0000191E:
; H011+$0000191E: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_00001922:
; H011+$00001922: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_00001924:
; H011+$00001924: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_0000192A:
; H011+$0000192A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_0000192C:
; H011+$0000192C: 243c00000100  move.l #$100, d2
        move.l #$100, d2
L011_00001932:
; H011+$00001932: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L011_00001934:
; H011+$00001934: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L011_0000193A:
; H011+$0000193A: 066d0100ffa6  addi.w #$100, -$5a(a5)
        addi.w #$100, -$5a(a5)
L011_00001940:
; H011+$00001940: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L011_00001944:
; H011+$00001944: 266dffa8  movea.l -$58(a5), a3
        movea.l -$58(a5), a3
L011_00001948:
; H011+$00001948: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_0000194C:
; H011+$0000194C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_0000194E:
; H011+$0000194E: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_00001954:
; H011+$00001954: 47eb0100  lea.l $100(a3), a3
        lea.l $100(a3), a3
L011_00001958:
; H011+$00001958: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_0000195A:
; H011+$0000195A: 243c00000100  move.l #$100, d2
        move.l #$100, d2
L011_00001960:
; H011+$00001960: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L011_00001962:
; H011+$00001962: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L011_00001968:
; H011+$00001968: 066d0100ffa6  addi.w #$100, -$5a(a5)
        addi.w #$100, -$5a(a5)
L011_0000196E:
; H011+$0000196E: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L011_00001972:
; H011+$00001972: 266dffa8  movea.l -$58(a5), a3
        movea.l -$58(a5), a3
L011_00001976:
; H011+$00001976: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_0000197A:
; H011+$0000197A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_0000197C:
; H011+$0000197C: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_00001982:
; H011+$00001982: 47eb0200  lea.l $200(a3), a3
        lea.l $200(a3), a3
L011_00001986:
; H011+$00001986: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_00001988:
; H011+$00001988: 243c00000100  move.l #$100, d2
        move.l #$100, d2
L011_0000198E:
; H011+$0000198E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L011_00001990:
; H011+$00001990: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L011_00001996:
; H011+$00001996: 066d0100ffa6  addi.w #$100, -$5a(a5)
        addi.w #$100, -$5a(a5)
L011_0000199C:
; H011+$0000199C: 342dffa6  move.w -$5a(a5), d2
        move.w -$5a(a5), d2
L011_000019A0:
; H011+$000019A0: 266dffa8  movea.l -$58(a5), a3
        movea.l -$58(a5), a3
L011_000019A4:
; H011+$000019A4: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L011_000019A8:
; H011+$000019A8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L011_000019AA:
; H011+$000019AA: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L011_000019B0:
; H011+$000019B0: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L011_000019B4:
; H011+$000019B4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L011_000019B6:
; H011+$000019B6: 243c00000100  move.l #$100, d2
        move.l #$100, d2
L011_000019BC:
; H011+$000019BC: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L011_000019BE:
; H011+$000019BE: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L011_000019C4:
; H011+$000019C4: 2f2dffa8  move.l -$58(a5), -(a7)
        move.l -$58(a5), -(a7)
L011_000019C8:
; H011+$000019C8: 7400  moveq #$0, d2
        moveq #0, d2
L011_000019CA:
; H011+$000019CA: 342dffac  move.w -$54(a5), d2
        move.w -$54(a5), d2
L011_000019CE:
; H011+$000019CE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L011_000019D0:
; H011+$000019D0: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L011_000019D6:
; H011+$000019D6: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L011_000019DC:
; H011+$000019DC: 376d000c018a  move.w $c(a5), $18a(a3)
        move.w $c(a5), $18a(a3)
L011_000019E2:
; H011+$000019E2: 4e5d  unlk a5
        unlk a5
L011_000019E4:
; H011+$000019E4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_000019E6:
; H011+$000019E6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L011_000019E8:
; H011+$000019E8: 548f  addq.l #$2, a7
        addq.l #$2, a7
L011_000019EA:
; H011+$000019EA: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H011+$000019EC..$00001A02; code/data not fully classified.
        dc.w $2F0C,$287A,$E70A,$4E55,$0000,$4EB9
        dc.l H044+$00000330
        dc.w $4E5D,$285F,$4E75
L011_00001A02:
; H011+$00001A02: 426cffe4  clr.w -$1c(a4)
        clr.w -$1c(a4)
L011_00001A06:
; H011+$00001A06: 397c0002ffe6  move.w #$2, -$1a(a4)
        move.w #$2, -$1a(a4)
L011_00001A0C:
; H011+$00001A0C: 397c0006ffe8  move.w #$6, -$18(a4)
        move.w #$6, -$18(a4)
L011_00001A12:
; H011+$00001A12: 397c000affea  move.w #$a, -$16(a4)
        move.w #$a, -$16(a4)
L011_00001A18:
; H011+$00001A18: 397c0016ffec  move.w #$16, -$14(a4)
        move.w #$16, -$14(a4)
L011_00001A1E:
; H011+$00001A1E: 397c0026ffee  move.w #$26, -$12(a4)
        move.w #$26, -$12(a4)
L011_00001A24:
; H011+$00001A24: 397c0036fff0  move.w #$36, -$10(a4)
        move.w #$36, -$10(a4)
L011_00001A2A:
; H011+$00001A2A: 397c006efff2  move.w #$6e, -$e(a4)
        move.w #$6e, -$e(a4)
L011_00001A30:
; H011+$00001A30: 397c0084fff4  move.w #$84, -$c(a4)
        move.w #$84, -$c(a4)
L011_00001A36:
; H011+$00001A36: 397c009afff6  move.w #$9a, -$a(a4)
        move.w #$9a, -$a(a4)
L011_00001A3C:
; H011+$00001A3C: 397c0001ffd0  move.w #$1, -$30(a4)
        move.w #$1, -$30(a4)
L011_00001A42:
; H011+$00001A42: 397c0001ffd2  move.w #$1, -$2e(a4)
        move.w #$1, -$2e(a4)
L011_00001A48:
; H011+$00001A48: 397c0001ffd4  move.w #$1, -$2c(a4)
        move.w #$1, -$2c(a4)
L011_00001A4E:
; H011+$00001A4E: 397c0003ffd6  move.w #$3, -$2a(a4)
        move.w #$3, -$2a(a4)
L011_00001A54:
; H011+$00001A54: 397c0002ffd8  move.w #$2, -$28(a4)
        move.w #$2, -$28(a4)
L011_00001A5A:
; H011+$00001A5A: 397c0002ffda  move.w #$2, -$26(a4)
        move.w #$2, -$26(a4)
L011_00001A60:
; H011+$00001A60: 397c0007ffdc  move.w #$7, -$24(a4)
        move.w #$7, -$24(a4)
L011_00001A66:
; H011+$00001A66: 397c0002ffde  move.w #$2, -$22(a4)
        move.w #$2, -$22(a4)
L011_00001A6C:
; H011+$00001A6C: 397c0002ffe0  move.w #$2, -$20(a4)
        move.w #$2, -$20(a4)
L011_00001A72:
; H011+$00001A72: 397c0001ffe2  move.w #$1, -$1e(a4)
        move.w #$1, -$1e(a4)
L011_00001A78:
; H011+$00001A78: 397c0002ffbc  move.w #$2, -$44(a4)
        move.w #$2, -$44(a4)
L011_00001A7E:
; H011+$00001A7E: 397c0004ffbe  move.w #$4, -$42(a4)
        move.w #$4, -$42(a4)
L011_00001A84:
; H011+$00001A84: 397c0004ffc0  move.w #$4, -$40(a4)
        move.w #$4, -$40(a4)
L011_00001A8A:
; H011+$00001A8A: 397c0004ffc2  move.w #$4, -$3e(a4)
        move.w #$4, -$3e(a4)
L011_00001A90:
; H011+$00001A90: 397c0008ffc4  move.w #$8, -$3c(a4)
        move.w #$8, -$3c(a4)
L011_00001A96:
; H011+$00001A96: 397c0008ffc6  move.w #$8, -$3a(a4)
        move.w #$8, -$3a(a4)
L011_00001A9C:
; H011+$00001A9C: 397c0008ffc8  move.w #$8, -$38(a4)
        move.w #$8, -$38(a4)
L011_00001AA2:
; H011+$00001AA2: 397c000bffca  move.w #$b, -$36(a4)
        move.w #$b, -$36(a4)
L011_00001AA8:
; H011+$00001AA8: 397c000bffcc  move.w #$b, -$34(a4)
        move.w #$b, -$34(a4)
L011_00001AAE:
; H011+$00001AAE: 397c0002ffce  move.w #$2, -$32(a4)
        move.w #$2, -$32(a4)
L011_00001AB4:
; H011+$00001AB4: 397c0005ffa8  move.w #$5, -$58(a4)
        move.w #$5, -$58(a4)
L011_00001ABA:
; H011+$00001ABA: 397c0004ffaa  move.w #$4, -$56(a4)
        move.w #$4, -$56(a4)
L011_00001AC0:
; H011+$00001AC0: 397c0006ffac  move.w #$6, -$54(a4)
        move.w #$6, -$54(a4)
L011_00001AC6:
; H011+$00001AC6: 397c0004ffae  move.w #$4, -$52(a4)
        move.w #$4, -$52(a4)
L011_00001ACC:
; H011+$00001ACC: 397c0002ffb0  move.w #$2, -$50(a4)
        move.w #$2, -$50(a4)
L011_00001AD2:
; H011+$00001AD2: 397c0007ffb2  move.w #$7, -$4e(a4)
        move.w #$7, -$4e(a4)
L011_00001AD8:
; H011+$00001AD8: 397c0002ffb4  move.w #$2, -$4c(a4)
        move.w #$2, -$4c(a4)
L011_00001ADE:
; H011+$00001ADE: 426cffb6  clr.w -$4a(a4)
        clr.w -$4a(a4)
L011_00001AE2:
; H011+$00001AE2: 397c0009ffb8  move.w #$9, -$48(a4)
        move.w #$9, -$48(a4)
L011_00001AE8:
; H011+$00001AE8: 397c0005ffba  move.w #$5, -$46(a4)
        move.w #$5, -$46(a4)
L011_00001AEE:
; H011+$00001AEE: 397c0004ff94  move.w #$4, -$6c(a4)
        move.w #$4, -$6c(a4)
L011_00001AF4:
; H011+$00001AF4: 397c0003ff96  move.w #$3, -$6a(a4)
        move.w #$3, -$6a(a4)
L011_00001AFA:
; H011+$00001AFA: 397c0003ff98  move.w #$3, -$68(a4)
        move.w #$3, -$68(a4)
L011_00001B00:
; H011+$00001B00: 397c0003ff9a  move.w #$3, -$66(a4)
        move.w #$3, -$66(a4)
L011_00001B06:
; H011+$00001B06: 397c0001ff9c  move.w #$1, -$64(a4)
        move.w #$1, -$64(a4)
L011_00001B0C:
; H011+$00001B0C: 397c0001ff9e  move.w #$1, -$62(a4)
        move.w #$1, -$62(a4)
L011_00001B12:
; H011+$00001B12: 397c0001ffa0  move.w #$1, -$60(a4)
        move.w #$1, -$60(a4)
L011_00001B18:
; H011+$00001B18: 426cffa2  clr.w -$5e(a4)
        clr.w -$5e(a4)
L011_00001B1C:
; H011+$00001B1C: 426cffa4  clr.w -$5c(a4)
        clr.w -$5c(a4)
L011_00001B20:
; H011+$00001B20: 397c0004ffa6  move.w #$4, -$5a(a4)
        move.w #$4, -$5a(a4)
L011_00001B26:
; H011+$00001B26: 422cfff8  clr.b -$8(a4)
        clr.b -$8(a4)
L011_00001B2A:
; H011+$00001B2A: 197c0011fff9  move.b #$11, -$7(a4)
        move.b #$11, -$7(a4)
L011_00001B30:
; H011+$00001B30: 197c0022fffa  move.b #$22, -$6(a4)
        move.b #$22, -$6(a4)
L011_00001B36:
; H011+$00001B36: 197c0012fffb  move.b #$12, -$5(a4)
        move.b #$12, -$5(a4)
L011_00001B3C:
; H011+$00001B3C: 197c0001fffc  move.b #$1, -$4(a4)
        move.b #$1, -$4(a4)
L011_00001B42:
; H011+$00001B42: 197c0021fffd  move.b #$21, -$3(a4)
        move.b #$21, -$3(a4)
L011_00001B48:
; H011+$00001B48: 197c0030fffe  move.b #$30, -$2(a4)
        move.b #$30, -$2(a4)
L011_00001B4E:
; H011+$00001B4E: 197c0033ffff  move.b #$33, -$1(a4)
        move.b #$33, -$1(a4)
L011_00001B54:
; H011+$00001B54: 4e5d  unlk a5
        unlk a5
L011_00001B56:
; H011+$00001B56: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L011_00001B58:
; H011+$00001B58: 4e75  rts 
        rts 
; Preserved bytes H011+$00001B5A..$00001B5C; code/data not fully classified.
        dc.w $0000
; End H011: $1B5C bytes
