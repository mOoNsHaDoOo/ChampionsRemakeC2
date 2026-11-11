; ============================================================================
; GUIDA DEL MODULO H044
; disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI. Chiama ripetutamente il loader H034 e i servizi di presentazione H030/H022.
; --------------------------------------------------------------------------
; H044: 2668 original bytes; all offsets are section-relative.
        section H044,code
H044:
; Preserved bytes H044+$00000000..$000000BA; code/data not fully classified.
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
        dc.w $0000,$0000,$0000
        dc.l H044+$000000B6
; --------------------------------------------------------------------------
; ROUTINE: module_init_H044 [parziale]
; Scopo: Ingresso del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H044+$084A.
; Chiamanti diretti: H000+$0150
; --------------------------------------------------------------------------
L044_000000BA:
; H044+$000000BA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_000000BC:
; H044+$000000BC: 287afff8  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_000000C0:
; H044+$000000C0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L044_000000C4:
; H044+$000000C4: 60000784  bra.w $84a
        bra.w H044+$84A
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H044_016C [parziale]
; Scopo: Trampolino verso H044+$016C; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H044+$016C.
;   - Richiama H034+$0178.
; Chiamanti diretti: H044+$0218, H044+$06D8, H044+$04C4, H044+$05D0
; --------------------------------------------------------------------------
L044_000000C8:
; H044+$000000C8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_000000CA:
; H044+$000000CA: 287affea  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_000000CE:
; H044+$000000CE: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L044_000000D2:
; H044+$000000D2: 3b6d000cfffe  move.w $c(a5), -$2(a5)
        move.w $c(a5), -$2(a5)
L044_000000D8:
; H044+$000000D8: 0c6d0008000c  cmpi.w #$8, $c(a5)
        cmpi.w #$8, $c(a5)
L044_000000DE:
; H044+$000000DE: 6600000a  bne.w $ea
        bne.w H044+$EA
L044_000000E2:
; H044+$000000E2: 426d000c  clr.w $c(a5)
        clr.w $c(a5)
L044_000000E6:
; H044+$000000E6: 60000026  bra.w $10e
        bra.w H044+$10E
L044_000000EA:
; H044+$000000EA: 0c6d0013000c  cmpi.w #$13, $c(a5)
        cmpi.w #$13, $c(a5)
L044_000000F0:
; H044+$000000F0: 6600000c  bne.w $fe
        bne.w H044+$FE
L044_000000F4:
; H044+$000000F4: 3b7c0001000c  move.w #$1, $c(a5)
        move.w #$1, $c(a5)
L044_000000FA:
; H044+$000000FA: 60000012  bra.w $10e
        bra.w H044+$10E
L044_000000FE:
; H044+$000000FE: 0c6d001e000c  cmpi.w #$1e, $c(a5)
        cmpi.w #$1e, $c(a5)
L044_00000104:
; H044+$00000104: 66000008  bne.w $10e
        bne.w H044+$10E
L044_00000108:
; H044+$00000108: 3b7c0002000c  move.w #$2, $c(a5)
        move.w #$2, $c(a5)
L044_0000010E:
; H044+$0000010E: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L044_00000112:
; H044+$00000112: 60000058  bra.w $16c
        bra.w H044+$16C
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L044_00000116:
; H044+$00000116: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L044_0000011C:
; H044+$0000011C: 342b03f2  move.w $3f2(a3), d2
        move.w $3f2(a3), d2
L044_00000120:
; H044+$00000120: 0642000a  addi.w #$a, d2
        addi.w #$a, d2
L044_00000124:
; H044+$00000124: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L044_00000128:
; H044+$00000128: 4e75  rts 
        rts 
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L044_0000012A:
; H044+$0000012A: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L044_00000130:
; H044+$00000130: 342b03f4  move.w $3f4(a3), d2
        move.w $3f4(a3), d2
L044_00000134:
; H044+$00000134: 5c42  addq.w #$6, d2
        addq.w #$6, d2
L044_00000136:
; H044+$00000136: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L044_0000013A:
; H044+$0000013A: 4e75  rts 
        rts 
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L044_0000013C:
; H044+$0000013C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L044_00000142:
; H044+$00000142: 342b03f6  move.w $3f6(a3), d2
        move.w $3f6(a3), d2
L044_00000146:
; H044+$00000146: 0642000e  addi.w #$e, d2
        addi.w #$e, d2
L044_0000014A:
; H044+$0000014A: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L044_0000014E:
; H044+$0000014E: 4e75  rts 
        rts 
L044_00000150:
; H044+$00000150: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L044_00000154:
; H044+$00000154: 47ecffd6  lea.l -$2a(a4), a3
        lea.l -$2a(a4), a3
L044_00000158:
; H044+$00000158: 7800  moveq #$0, d4
        moveq #0, d4
L044_0000015A:
; H044+$0000015A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_0000015E:
; H044+$0000015E: 3b44fffc  move.w d4, -$4(a5)
        move.w d4, -$4(a5)
L044_00000162:
; H044+$00000162: 4e75  rts 
        rts 
; Preserved bytes H044+$00000164..$0000016C; code/data not fully classified.
        dc.w $FFEA,$FFB0,$FFC4,$FFD6
L044_0000016C:
; H044+$0000016C: 47fafff8  lea.l $166(pc), a3
        lea.l H044+$166(pc), a3
L044_00000170:
; H044+$00000170: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L044_00000174:
; H044+$00000174: 6302  bls.b $178
        bls.b H044+$178
L044_00000176:
; H044+$00000176: 74ff  moveq #$ff, d2
        moveq #-1, d2
L044_00000178:
; H044+$00000178: e342  asl.w #$1, d2
        asl.w #$1, d2
L044_0000017A:
; H044+$0000017A: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H044+$0166; indici 0..2, default -1.
L044_0000017E:
; H044+$0000017E: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L044_00000182:
; H044+$00000182: 0c6d0008fffe  cmpi.w #$8, -$2(a5)
        cmpi.w #$8, -$2(a5)
L044_00000188:
; H044+$00000188: 64000014  bcc.w $19e
        bcc.w H044+$19E
L044_0000018C:
; H044+$0000018C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L044_00000190:
; H044+$00000190: 47ecffd6  lea.l -$2a(a4), a3
        lea.l -$2a(a4), a3
L044_00000194:
; H044+$00000194: 7800  moveq #$0, d4
        moveq #0, d4
L044_00000196:
; H044+$00000196: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_0000019A:
; H044+$0000019A: 3b44fffc  move.w d4, -$4(a5)
        move.w d4, -$4(a5)
L044_0000019E:
; H044+$0000019E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000001A2:
; H044+$000001A2: 4267  clr.w -(a7)
        clr.w -(a7)
L044_000001A4:
; H044+$000001A4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_000001A8:
; H044+$000001A8: 06420114  addi.w #$114, d2
        addi.w #$114, d2
L044_000001AC:
; H044+$000001AC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L044_000001AE:
; H044+$000001AE: 4227  clr.b -(a7)
        clr.b -(a7)
L044_000001B0:
; H044+$000001B0: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_000001B2:
; H044+$000001B2: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_000001B8:
; H044+$000001B8: 4e5d  unlk a5
        unlk a5
L044_000001BA:
; H044+$000001BA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_000001BC:
; H044+$000001BC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L044_000001BE:
; H044+$000001BE: 548f  addq.l #$2, a7
        addq.l #$2, a7
L044_000001C0:
; H044+$000001C0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_000001C2 [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H022+$0084, H030+$0B6C, H034+$0178.
;   - Richiama H022+$0084.
;   - Richiama H030+$0B6C.
;   - Richiama H034+$0178.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H009+$011A, H044+$02E6, H013+$4DB8, H063+$323C, H044+$033C, H044+$045E e altri 11
; --------------------------------------------------------------------------
L044_000001C2:
; H044+$000001C2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_000001C4:
; H044+$000001C4: 287afef0  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_000001C8:
; H044+$000001C8: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L044_000001CC:
; H044+$000001CC: 33fc0f0f000052c8  move.w #$f0f, $52c8.l
        move.w #$f0f, (H005+$52C8).l
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L044_000001D4:
; H044+$000001D4: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L044_000001DA:
; H044+$000001DA: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L044_000001DE:
; H044+$000001DE: 47f9000052ae  lea.l $52ae.l, a3
        lea.l (H005+$52AE).l, a3
L044_000001E4:
; H044+$000001E4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L044_000001E6:
; H044+$000001E6: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L044_000001EA:
; H044+$000001EA: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L044_000001F0:
; H044+$000001F0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L044_000001F4:
; H044+$000001F4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L044_000001F8:
; H044+$000001F8: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L044_000001FC:
; H044+$000001FC: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L044_00000200:
; H044+$00000200: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L044_00000206:
; H044+$00000206: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_0000020A:
; H044+$0000020A: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_00000210:
; H044+$00000210: 62000010  bhi.w $222
        bhi.w H044+$222
L044_00000214:
; H044+$00000214: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000218:
; H044+$00000218: 6100feae  bsr.w $c8
        bsr.w H044+$C8
L044_0000021C:
; H044+$0000021C: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_00000220:
; H044+$00000220: 64e8  bcc.b $20a
        bcc.b H044+$20A
L044_00000222:
; H044+$00000222: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L044_00000226:
; H044+$00000226: 0c6d0017fffc  cmpi.w #$17, -$4(a5)
        cmpi.w #$17, -$4(a5)
L044_0000022C:
; H044+$0000022C: 62000076  bhi.w $2a4
        bhi.w H044+$2A4
L044_00000230:
; H044+$00000230: 0c6d000efffc  cmpi.w #$e, -$4(a5)
        cmpi.w #$e, -$4(a5)
L044_00000236:
; H044+$00000236: 6300001e  bls.w $256
        bls.w H044+$256
L044_0000023A:
; H044+$0000023A: 0c6d0012fffc  cmpi.w #$12, -$4(a5)
        cmpi.w #$12, -$4(a5)
L044_00000240:
; H044+$00000240: 64000014  bcc.w $256
        bcc.w H044+$256
L044_00000244:
; H044+$00000244: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L044_00000248:
; H044+$00000248: 6700000c  beq.w $256
        beq.w H044+$256
L044_0000024C:
; H044+$0000024C: 3b7c0004fffa  move.w #$4, -$6(a5)
        move.w #$4, -$6(a5)
L044_00000252:
; H044+$00000252: 60000014  bra.w $268
        bra.w H044+$268
L044_00000256:
; H044+$00000256: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_0000025A:
; H044+$0000025A: 47ecffbe  lea.l -$42(a4), a3
        lea.l -$42(a4), a3
L044_0000025E:
; H044+$0000025E: 7800  moveq #$0, d4
        moveq #0, d4
L044_00000260:
; H044+$00000260: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_00000264:
; H044+$00000264: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L044_00000268:
; H044+$00000268: 4267  clr.w -(a7)
        clr.w -(a7)
L044_0000026A:
; H044+$0000026A: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_0000026E:
; H044+$0000026E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L044_00000272:
; H044+$00000272: 06420114  addi.w #$114, d2
        addi.w #$114, d2
L044_00000276:
; H044+$00000276: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L044_00000278:
; H044+$00000278: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000027A:
; H044+$0000027A: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000027C:
; H044+$0000027C: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000282:
; H044+$00000282: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L044_00000286:
; H044+$00000286: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_0000028A:
; H044+$0000028A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L044_0000028E:
; H044+$0000028E: 06420114  addi.w #$114, d2
        addi.w #$114, d2
L044_00000292:
; H044+$00000292: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L044_00000294:
; H044+$00000294: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000296:
; H044+$00000296: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000298:
; H044+$00000298: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000029E:
; H044+$0000029E: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L044_000002A2:
; H044+$000002A2: 6482  bcc.b $226
        bcc.b H044+$226
L044_000002A4:
; H044+$000002A4: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_000002A8:
; H044+$000002A8: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_000002AE:
; H044+$000002AE: 6200001e  bhi.w $2ce
        bhi.w H044+$2CE
L044_000002B2:
; H044+$000002B2: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000002B6:
; H044+$000002B6: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L044_000002BA:
; H044+$000002BA: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_000002BE:
; H044+$000002BE: 4227  clr.b -(a7)
        clr.b -(a7)
L044_000002C0:
; H044+$000002C0: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_000002C2:
; H044+$000002C2: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_000002C8:
; H044+$000002C8: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_000002CC:
; H044+$000002CC: 64da  bcc.b $2a8
        bcc.b H044+$2A8
L044_000002CE:
; H044+$000002CE: 4e5d  unlk a5
        unlk a5
L044_000002D0:
; H044+$000002D0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_000002D2:
; H044+$000002D2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L044_000002D4:
; H044+$000002D4: 548f  addq.l #$2, a7
        addq.l #$2, a7
L044_000002D6:
; H044+$000002D6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_000002D8 [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H034+$0178.
;   - Richiama H034+$0178.
; Chiamanti diretti: H007+$06F4
; --------------------------------------------------------------------------
L044_000002D8:
; H044+$000002D8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_000002DA:
; H044+$000002DA: 287afdda  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_000002DE:
; H044+$000002DE: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L044_000002E2:
; H044+$000002E2: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L044_000002E6:
; H044+$000002E6: 6100feda  bsr.w $1c2
        bsr.w H044+$1C2
L044_000002EA:
; H044+$000002EA: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_000002EE:
; H044+$000002EE: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_000002F4:
; H044+$000002F4: 62000034  bhi.w $32a
        bhi.w H044+$32A
L044_000002F8:
; H044+$000002F8: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000002FC:
; H044+$000002FC: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L044_00000300:
; H044+$00000300: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_00000304:
; H044+$00000304: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000306:
; H044+$00000306: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000308:
; H044+$00000308: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000030E:
; H044+$0000030E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000312:
; H044+$00000312: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L044_00000316:
; H044+$00000316: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_0000031A:
; H044+$0000031A: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000031C:
; H044+$0000031C: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000031E:
; H044+$0000031E: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000324:
; H044+$00000324: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_00000328:
; H044+$00000328: 64c4  bcc.b $2ee
        bcc.b H044+$2EE
L044_0000032A:
; H044+$0000032A: 4e5d  unlk a5
        unlk a5
L044_0000032C:
; H044+$0000032C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_0000032E:
; H044+$0000032E: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_00000330 [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H034+$0178.
;   - Richiama H034+$0178.
; Chiamanti diretti: H063+$324E, H063+$32BC, H063+$32EE, H063+$3346, H013+$5124, H013+$50F2 e altri 3
; --------------------------------------------------------------------------
L044_00000330:
; H044+$00000330: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_00000332:
; H044+$00000332: 287afd82  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_00000336:
; H044+$00000336: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L044_0000033A:
; H044+$0000033A: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000033C:
; H044+$0000033C: 6100fe84  bsr.w $1c2
        bsr.w H044+$1C2
L044_00000340:
; H044+$00000340: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_00000344:
; H044+$00000344: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_0000034A:
; H044+$0000034A: 6200001e  bhi.w $36a
        bhi.w H044+$36A
L044_0000034E:
; H044+$0000034E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000352:
; H044+$00000352: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L044_00000356:
; H044+$00000356: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_0000035A:
; H044+$0000035A: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000035C:
; H044+$0000035C: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000035E:
; H044+$0000035E: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000364:
; H044+$00000364: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_00000368:
; H044+$00000368: 64da  bcc.b $344
        bcc.b H044+$344
L044_0000036A:
; H044+$0000036A: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L044_0000036E:
; H044+$0000036E: 0c6d0010fffc  cmpi.w #$10, -$4(a5)
        cmpi.w #$10, -$4(a5)
L044_00000374:
; H044+$00000374: 6200002e  bhi.w $3a4
        bhi.w H044+$3A4
L044_00000378:
; H044+$00000378: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L044_0000037C:
; H044+$0000037C: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_00000380:
; H044+$00000380: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_00000384:
; H044+$00000384: 47ecffac  lea.l -$54(a4), a3
        lea.l -$54(a4), a3
L044_00000388:
; H044+$00000388: 7800  moveq #$0, d4
        moveq #0, d4
L044_0000038A:
; H044+$0000038A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_0000038E:
; H044+$0000038E: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_00000392:
; H044+$00000392: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_00000394:
; H044+$00000394: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000396:
; H044+$00000396: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000398:
; H044+$00000398: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000039E:
; H044+$0000039E: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L044_000003A2:
; H044+$000003A2: 64ca  bcc.b $36e
        bcc.b H044+$36E
L044_000003A4:
; H044+$000003A4: 3b7c0002fffe  move.w #$2, -$2(a5)
        move.w #$2, -$2(a5)
L044_000003AA:
; H044+$000003AA: 0c6d000efffe  cmpi.w #$e, -$2(a5)
        cmpi.w #$e, -$2(a5)
L044_000003B0:
; H044+$000003B0: 62000034  bhi.w $3e6
        bhi.w H044+$3E6
L044_000003B4:
; H044+$000003B4: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000003B8:
; H044+$000003B8: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L044_000003BC:
; H044+$000003BC: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_000003C0:
; H044+$000003C0: 4227  clr.b -(a7)
        clr.b -(a7)
L044_000003C2:
; H044+$000003C2: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_000003C4:
; H044+$000003C4: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_000003CA:
; H044+$000003CA: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000003CE:
; H044+$000003CE: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L044_000003D2:
; H044+$000003D2: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_000003D6:
; H044+$000003D6: 4227  clr.b -(a7)
        clr.b -(a7)
L044_000003D8:
; H044+$000003D8: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_000003DA:
; H044+$000003DA: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_000003E0:
; H044+$000003E0: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_000003E4:
; H044+$000003E4: 64c4  bcc.b $3aa
        bcc.b H044+$3AA
L044_000003E6:
; H044+$000003E6: 3b7c0002fffc  move.w #$2, -$4(a5)
        move.w #$2, -$4(a5)
L044_000003EC:
; H044+$000003EC: 0c6d000efffc  cmpi.w #$e, -$4(a5)
        cmpi.w #$e, -$4(a5)
L044_000003F2:
; H044+$000003F2: 62000058  bhi.w $44c
        bhi.w H044+$44C
L044_000003F6:
; H044+$000003F6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L044_000003FA:
; H044+$000003FA: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_000003FE:
; H044+$000003FE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_00000402:
; H044+$00000402: 5542  subq.w #$2, d2
        subq.w #$2, d2
L044_00000404:
; H044+$00000404: 47ecff86  lea.l -$7a(a4), a3
        lea.l -$7a(a4), a3
L044_00000408:
; H044+$00000408: 7800  moveq #$0, d4
        moveq #0, d4
L044_0000040A:
; H044+$0000040A: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_0000040E:
; H044+$0000040E: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_00000412:
; H044+$00000412: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_00000414:
; H044+$00000414: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000416:
; H044+$00000416: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000418:
; H044+$00000418: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000041E:
; H044+$0000041E: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L044_00000422:
; H044+$00000422: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_00000426:
; H044+$00000426: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_0000042A:
; H044+$0000042A: 5542  subq.w #$2, d2
        subq.w #$2, d2
L044_0000042C:
; H044+$0000042C: 47ecff86  lea.l -$7a(a4), a3
        lea.l -$7a(a4), a3
L044_00000430:
; H044+$00000430: 7800  moveq #$0, d4
        moveq #0, d4
L044_00000432:
; H044+$00000432: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_00000436:
; H044+$00000436: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_0000043A:
; H044+$0000043A: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_0000043C:
; H044+$0000043C: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000043E:
; H044+$0000043E: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000440:
; H044+$00000440: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000446:
; H044+$00000446: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L044_0000044A:
; H044+$0000044A: 64a0  bcc.b $3ec
        bcc.b H044+$3EC
L044_0000044C:
; H044+$0000044C: 4e5d  unlk a5
        unlk a5
L044_0000044E:
; H044+$0000044E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_00000450:
; H044+$00000450: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_00000452 [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H034+$0178.
;   - Richiama H034+$0178.
; Chiamanti diretti: H013+$50E8, H042+$10F2, H072+$0FFC
; --------------------------------------------------------------------------
L044_00000452:
; H044+$00000452: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_00000454:
; H044+$00000454: 287afc60  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_00000458:
; H044+$00000458: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L044_0000045C:
; H044+$0000045C: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000045E:
; H044+$0000045E: 6100fd62  bsr.w $1c2
        bsr.w H044+$1C2
L044_00000462:
; H044+$00000462: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_00000466:
; H044+$00000466: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_0000046C:
; H044+$0000046C: 6200001e  bhi.w $48c
        bhi.w H044+$48C
L044_00000470:
; H044+$00000470: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000474:
; H044+$00000474: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L044_00000478:
; H044+$00000478: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_0000047C:
; H044+$0000047C: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000047E:
; H044+$0000047E: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000480:
; H044+$00000480: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000486:
; H044+$00000486: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_0000048A:
; H044+$0000048A: 64da  bcc.b $466
        bcc.b H044+$466
L044_0000048C:
; H044+$0000048C: 4e5d  unlk a5
        unlk a5
L044_0000048E:
; H044+$0000048E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_00000490:
; H044+$00000490: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_00000492 [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H030+$0B6C, H034+$0178.
;   - Richiama H030+$0B6C.
;   - Richiama H034+$0178.
; Chiamanti diretti: H065+$35FC
; --------------------------------------------------------------------------
L044_00000492:
; H044+$00000492: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_00000494:
; H044+$00000494: 287afc20  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_00000498:
; H044+$00000498: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L044_0000049C:
; H044+$0000049C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L044_000004A0:
; H044+$000004A0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L044_000004A4:
; H044+$000004A4: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L044_000004A8:
; H044+$000004A8: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L044_000004AC:
; H044+$000004AC: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L044_000004B2:
; H044+$000004B2: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_000004B6:
; H044+$000004B6: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_000004BC:
; H044+$000004BC: 62000010  bhi.w $4ce
        bhi.w H044+$4CE
L044_000004C0:
; H044+$000004C0: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000004C4:
; H044+$000004C4: 6100fc02  bsr.w $c8
        bsr.w H044+$C8
L044_000004C8:
; H044+$000004C8: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_000004CC:
; H044+$000004CC: 64e8  bcc.b $4b6
        bcc.b H044+$4B6
L044_000004CE:
; H044+$000004CE: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L044_000004D2:
; H044+$000004D2: 0c6d0017fffc  cmpi.w #$17, -$4(a5)
        cmpi.w #$17, -$4(a5)
L044_000004D8:
; H044+$000004D8: 62000052  bhi.w $52c
        bhi.w H044+$52C
L044_000004DC:
; H044+$000004DC: 4267  clr.w -(a7)
        clr.w -(a7)
L044_000004DE:
; H044+$000004DE: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_000004E2:
; H044+$000004E2: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_000004E6:
; H044+$000004E6: 47ecffbe  lea.l -$42(a4), a3
        lea.l -$42(a4), a3
L044_000004EA:
; H044+$000004EA: 7800  moveq #$0, d4
        moveq #0, d4
L044_000004EC:
; H044+$000004EC: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_000004F0:
; H044+$000004F0: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_000004F4:
; H044+$000004F4: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_000004F6:
; H044+$000004F6: 4227  clr.b -(a7)
        clr.b -(a7)
L044_000004F8:
; H044+$000004F8: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_000004FA:
; H044+$000004FA: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000500:
; H044+$00000500: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L044_00000504:
; H044+$00000504: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_00000508:
; H044+$00000508: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_0000050C:
; H044+$0000050C: 47ecff94  lea.l -$6c(a4), a3
        lea.l -$6c(a4), a3
L044_00000510:
; H044+$00000510: 7800  moveq #$0, d4
        moveq #0, d4
L044_00000512:
; H044+$00000512: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_00000516:
; H044+$00000516: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_0000051A:
; H044+$0000051A: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_0000051C:
; H044+$0000051C: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000051E:
; H044+$0000051E: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000520:
; H044+$00000520: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000526:
; H044+$00000526: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L044_0000052A:
; H044+$0000052A: 64a6  bcc.b $4d2
        bcc.b H044+$4D2
L044_0000052C:
; H044+$0000052C: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_00000530:
; H044+$00000530: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_00000536:
; H044+$00000536: 6200001e  bhi.w $556
        bhi.w H044+$556
L044_0000053A:
; H044+$0000053A: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_0000053E:
; H044+$0000053E: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L044_00000542:
; H044+$00000542: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_00000546:
; H044+$00000546: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000548:
; H044+$00000548: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000054A:
; H044+$0000054A: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000550:
; H044+$00000550: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_00000554:
; H044+$00000554: 64da  bcc.b $530
        bcc.b H044+$530
L044_00000556:
; H044+$00000556: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_0000055A:
; H044+$0000055A: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_00000560:
; H044+$00000560: 6200001e  bhi.w $580
        bhi.w H044+$580
L044_00000564:
; H044+$00000564: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000568:
; H044+$00000568: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L044_0000056C:
; H044+$0000056C: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_00000570:
; H044+$00000570: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000572:
; H044+$00000572: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000574:
; H044+$00000574: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000057A:
; H044+$0000057A: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_0000057E:
; H044+$0000057E: 64da  bcc.b $55a
        bcc.b H044+$55A
L044_00000580:
; H044+$00000580: 4e5d  unlk a5
        unlk a5
L044_00000582:
; H044+$00000582: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_00000584:
; H044+$00000584: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_00000586 [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H030+$0B6C, H022+$0084, H034+$0178.
;   - Richiama H030+$0B6C.
;   - Richiama H022+$0084.
;   - Richiama H034+$0178.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H063+$3662
; --------------------------------------------------------------------------
L044_00000586:
; H044+$00000586: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_00000588:
; H044+$00000588: 287afb2c  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_0000058C:
; H044+$0000058C: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L044_00000590:
; H044+$00000590: 4267  clr.w -(a7)
        clr.w -(a7)
L044_00000592:
; H044+$00000592: 4267  clr.w -(a7)
        clr.w -(a7)
L044_00000594:
; H044+$00000594: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L044_00000598:
; H044+$00000598: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L044_0000059C:
; H044+$0000059C: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L044_000005A2:
; H044+$000005A2: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L044_000005A8:
; H044+$000005A8: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L044_000005AC:
; H044+$000005AC: 47f90000522e  lea.l $522e.l, a3
        lea.l (H005+$522E).l, a3
L044_000005B2:
; H044+$000005B2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L044_000005B4:
; H044+$000005B4: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L044_000005B8:
; H044+$000005B8: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L044_000005BE:
; H044+$000005BE: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_000005C2:
; H044+$000005C2: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_000005C8:
; H044+$000005C8: 62000010  bhi.w $5da
        bhi.w H044+$5DA
L044_000005CC:
; H044+$000005CC: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000005D0:
; H044+$000005D0: 6100faf6  bsr.w $c8
        bsr.w H044+$C8
L044_000005D4:
; H044+$000005D4: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_000005D8:
; H044+$000005D8: 64e8  bcc.b $5c2
        bcc.b H044+$5C2
L044_000005DA:
; H044+$000005DA: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L044_000005DE:
; H044+$000005DE: 0c6d0016fffc  cmpi.w #$16, -$4(a5)
        cmpi.w #$16, -$4(a5)
L044_000005E4:
; H044+$000005E4: 62000078  bhi.w $65e
        bhi.w H044+$65E
L044_000005E8:
; H044+$000005E8: 4267  clr.w -(a7)
        clr.w -(a7)
L044_000005EA:
; H044+$000005EA: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_000005EE:
; H044+$000005EE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_000005F2:
; H044+$000005F2: 47ecff6e  lea.l -$92(a4), a3
        lea.l -$92(a4), a3
L044_000005F6:
; H044+$000005F6: 7800  moveq #$0, d4
        moveq #0, d4
L044_000005F8:
; H044+$000005F8: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_000005FC:
; H044+$000005FC: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_00000600:
; H044+$00000600: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_00000602:
; H044+$00000602: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000604:
; H044+$00000604: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000606:
; H044+$00000606: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000060C:
; H044+$0000060C: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L044_00000610:
; H044+$00000610: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_00000614:
; H044+$00000614: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_00000618:
; H044+$00000618: 47ecff6e  lea.l -$92(a4), a3
        lea.l -$92(a4), a3
L044_0000061C:
; H044+$0000061C: 7800  moveq #$0, d4
        moveq #0, d4
L044_0000061E:
; H044+$0000061E: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_00000622:
; H044+$00000622: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_00000626:
; H044+$00000626: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_00000628:
; H044+$00000628: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000062A:
; H044+$0000062A: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000062C:
; H044+$0000062C: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000632:
; H044+$00000632: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L044_00000636:
; H044+$00000636: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_0000063A:
; H044+$0000063A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_0000063E:
; H044+$0000063E: 47ecff6e  lea.l -$92(a4), a3
        lea.l -$92(a4), a3
L044_00000642:
; H044+$00000642: 7800  moveq #$0, d4
        moveq #0, d4
L044_00000644:
; H044+$00000644: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_00000648:
; H044+$00000648: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_0000064C:
; H044+$0000064C: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_0000064E:
; H044+$0000064E: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000650:
; H044+$00000650: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000652:
; H044+$00000652: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000658:
; H044+$00000658: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L044_0000065C:
; H044+$0000065C: 6480  bcc.b $5de
        bcc.b H044+$5DE
L044_0000065E:
; H044+$0000065E: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_00000662:
; H044+$00000662: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_00000668:
; H044+$00000668: 6200001e  bhi.w $688
        bhi.w H044+$688
L044_0000066C:
; H044+$0000066C: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000670:
; H044+$00000670: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L044_00000674:
; H044+$00000674: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_00000678:
; H044+$00000678: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000067A:
; H044+$0000067A: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000067C:
; H044+$0000067C: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000682:
; H044+$00000682: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_00000686:
; H044+$00000686: 64da  bcc.b $662
        bcc.b H044+$662
L044_00000688:
; H044+$00000688: 4e5d  unlk a5
        unlk a5
L044_0000068A:
; H044+$0000068A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_0000068C:
; H044+$0000068C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_0000068E [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H030+$0B6C, H022+$0084, H034+$0178.
;   - Richiama H030+$0B6C.
;   - Richiama H022+$0084.
;   - Richiama H034+$0178.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H065+$04CA
; --------------------------------------------------------------------------
L044_0000068E:
; H044+$0000068E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_00000690:
; H044+$00000690: 287afa24  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_00000694:
; H044+$00000694: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L044_00000698:
; H044+$00000698: 4267  clr.w -(a7)
        clr.w -(a7)
L044_0000069A:
; H044+$0000069A: 4267  clr.w -(a7)
        clr.w -(a7)
L044_0000069C:
; H044+$0000069C: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L044_000006A0:
; H044+$000006A0: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L044_000006A4:
; H044+$000006A4: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L044_000006AA:
; H044+$000006AA: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L044_000006B0:
; H044+$000006B0: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L044_000006B4:
; H044+$000006B4: 47f9000052ae  lea.l $52ae.l, a3
        lea.l (H005+$52AE).l, a3
L044_000006BA:
; H044+$000006BA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L044_000006BC:
; H044+$000006BC: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L044_000006C0:
; H044+$000006C0: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L044_000006C6:
; H044+$000006C6: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_000006CA:
; H044+$000006CA: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_000006D0:
; H044+$000006D0: 62000068  bhi.w $73a
        bhi.w H044+$73A
L044_000006D4:
; H044+$000006D4: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000006D8:
; H044+$000006D8: 6100f9ee  bsr.w $c8
        bsr.w H044+$C8
L044_000006DC:
; H044+$000006DC: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000006E0:
; H044+$000006E0: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L044_000006E4:
; H044+$000006E4: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_000006E8:
; H044+$000006E8: 4227  clr.b -(a7)
        clr.b -(a7)
L044_000006EA:
; H044+$000006EA: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_000006EC:
; H044+$000006EC: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_000006F2:
; H044+$000006F2: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_000006F6:
; H044+$000006F6: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L044_000006FA:
; H044+$000006FA: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_000006FE:
; H044+$000006FE: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000700:
; H044+$00000700: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000702:
; H044+$00000702: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000708:
; H044+$00000708: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_0000070C:
; H044+$0000070C: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L044_00000710:
; H044+$00000710: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_00000714:
; H044+$00000714: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000716:
; H044+$00000716: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000718:
; H044+$00000718: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000071E:
; H044+$0000071E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000722:
; H044+$00000722: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L044_00000726:
; H044+$00000726: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_0000072A:
; H044+$0000072A: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000072C:
; H044+$0000072C: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000072E:
; H044+$0000072E: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000734:
; H044+$00000734: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_00000738:
; H044+$00000738: 6490  bcc.b $6ca
        bcc.b H044+$6CA
L044_0000073A:
; H044+$0000073A: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L044_0000073E:
; H044+$0000073E: 0c6d0016fffc  cmpi.w #$16, -$4(a5)
        cmpi.w #$16, -$4(a5)
L044_00000744:
; H044+$00000744: 62000052  bhi.w $798
        bhi.w H044+$798
L044_00000748:
; H044+$00000748: 4267  clr.w -(a7)
        clr.w -(a7)
L044_0000074A:
; H044+$0000074A: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_0000074E:
; H044+$0000074E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_00000752:
; H044+$00000752: 47ecff56  lea.l -$aa(a4), a3
        lea.l -$aa(a4), a3
L044_00000756:
; H044+$00000756: 7800  moveq #$0, d4
        moveq #0, d4
L044_00000758:
; H044+$00000758: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_0000075C:
; H044+$0000075C: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_00000760:
; H044+$00000760: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_00000762:
; H044+$00000762: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000764:
; H044+$00000764: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000766:
; H044+$00000766: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000076C:
; H044+$0000076C: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L044_00000770:
; H044+$00000770: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_00000774:
; H044+$00000774: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_00000778:
; H044+$00000778: 47ecff56  lea.l -$aa(a4), a3
        lea.l -$aa(a4), a3
L044_0000077C:
; H044+$0000077C: 7800  moveq #$0, d4
        moveq #0, d4
L044_0000077E:
; H044+$0000077E: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_00000782:
; H044+$00000782: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_00000786:
; H044+$00000786: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_00000788:
; H044+$00000788: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000078A:
; H044+$0000078A: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000078C:
; H044+$0000078C: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000792:
; H044+$00000792: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L044_00000796:
; H044+$00000796: 64a6  bcc.b $73e
        bcc.b H044+$73E
L044_00000798:
; H044+$00000798: 3b7c0009fffc  move.w #$9, -$4(a5)
        move.w #$9, -$4(a5)
L044_0000079E:
; H044+$0000079E: 0c6d0013fffc  cmpi.w #$13, -$4(a5)
        cmpi.w #$13, -$4(a5)
L044_000007A4:
; H044+$000007A4: 62000032  bhi.w $7d8
        bhi.w H044+$7D8
L044_000007A8:
; H044+$000007A8: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L044_000007AC:
; H044+$000007AC: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L044_000007B0:
; H044+$000007B0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L044_000007B4:
; H044+$000007B4: 04420009  subi.w #$9, d2
        subi.w #$9, d2
L044_000007B8:
; H044+$000007B8: 47ecff4a  lea.l -$b6(a4), a3
        lea.l -$b6(a4), a3
L044_000007BC:
; H044+$000007BC: 7800  moveq #$0, d4
        moveq #0, d4
L044_000007BE:
; H044+$000007BE: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L044_000007C2:
; H044+$000007C2: 06440114  addi.w #$114, d4
        addi.w #$114, d4
L044_000007C6:
; H044+$000007C6: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L044_000007C8:
; H044+$000007C8: 4227  clr.b -(a7)
        clr.b -(a7)
L044_000007CA:
; H044+$000007CA: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_000007CC:
; H044+$000007CC: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_000007D2:
; H044+$000007D2: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L044_000007D6:
; H044+$000007D6: 64c6  bcc.b $79e
        bcc.b H044+$79E
L044_000007D8:
; H044+$000007D8: 4e5d  unlk a5
        unlk a5
L044_000007DA:
; H044+$000007DA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_000007DC:
; H044+$000007DC: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H044_000007DE [parziale]
; Scopo: Routine del modulo disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI; richiama H034+$0178.
;   - Richiama H034+$0178.
; Chiamanti diretti: H065+$27D6, H065+$3606
; --------------------------------------------------------------------------
L044_000007DE:
; H044+$000007DE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L044_000007E0:
; H044+$000007E0: 287af8d4  movea.l $b6(pc), a4
        movea.l H044+$B6(pc), a4
L044_000007E4:
; H044+$000007E4: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L044_000007E8:
; H044+$000007E8: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L044_000007EC:
; H044+$000007EC: 6100f9d4  bsr.w $1c2
        bsr.w H044+$1C2
L044_000007F0:
; H044+$000007F0: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L044_000007F4:
; H044+$000007F4: 0c6d0027fffe  cmpi.w #$27, -$2(a5)
        cmpi.w #$27, -$2(a5)
L044_000007FA:
; H044+$000007FA: 6200001e  bhi.w $81a
        bhi.w H044+$81A
L044_000007FE:
; H044+$000007FE: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L044_00000802:
; H044+$00000802: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L044_00000806:
; H044+$00000806: 3f3c0114  move.w #$114, -(a7)
        move.w #$114, -(a7)
L044_0000080A:
; H044+$0000080A: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000080C:
; H044+$0000080C: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000080E:
; H044+$0000080E: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000814:
; H044+$00000814: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L044_00000818:
; H044+$00000818: 64da  bcc.b $7f4
        bcc.b H044+$7F4
L044_0000081A:
; H044+$0000081A: 4267  clr.w -(a7)
        clr.w -(a7)
L044_0000081C:
; H044+$0000081C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L044_00000820:
; H044+$00000820: 3f3c0117  move.w #$117, -(a7)
        move.w #$117, -(a7)
L044_00000824:
; H044+$00000824: 4227  clr.b -(a7)
        clr.b -(a7)
L044_00000826:
; H044+$00000826: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_00000828:
; H044+$00000828: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_0000082E:
; H044+$0000082E: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L044_00000832:
; H044+$00000832: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L044_00000836:
; H044+$00000836: 3f3c0117  move.w #$117, -(a7)
        move.w #$117, -(a7)
L044_0000083A:
; H044+$0000083A: 4227  clr.b -(a7)
        clr.b -(a7)
L044_0000083C:
; H044+$0000083C: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H034+$0178 (trampoline_H034_01A8)
L044_0000083E:
; H044+$0000083E: 4eb900000178  jsr $178.l
        jsr (H034+$178).l
L044_00000844:
; H044+$00000844: 4e5d  unlk a5
        unlk a5
L044_00000846:
; H044+$00000846: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_00000848:
; H044+$00000848: 4e75  rts 
        rts 
L044_0000084A:
; H044+$0000084A: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L044_0000084E:
; H044+$0000084E: 0c6c0027fffe  cmpi.w #$27, -$2(a4)
        cmpi.w #$27, -$2(a4)
L044_00000854:
; H044+$00000854: 62000014  bhi.w $86a
        bhi.w H044+$86A
L044_00000858:
; H044+$00000858: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_0000085C:
; H044+$0000085C: 47ecffd6  lea.l -$2a(a4), a3
        lea.l -$2a(a4), a3
L044_00000860:
; H044+$00000860: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L044_00000864:
; H044+$00000864: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_00000868:
; H044+$00000868: 64e4  bcc.b $84e
        bcc.b H044+$84E
L044_0000086A:
; H044+$0000086A: 197c0001ffdd  move.b #$1, -$23(a4)
        move.b #$1, -$23(a4)
L044_00000870:
; H044+$00000870: 197c0002ffdf  move.b #$2, -$21(a4)
        move.b #$2, -$21(a4)
L044_00000876:
; H044+$00000876: 197c0001ffe8  move.b #$1, -$18(a4)
        move.b #$1, -$18(a4)
L044_0000087C:
; H044+$0000087C: 197c0002ffea  move.b #$2, -$16(a4)
        move.b #$2, -$16(a4)
L044_00000882:
; H044+$00000882: 197c0001fff3  move.b #$1, -$d(a4)
        move.b #$1, -$d(a4)
L044_00000888:
; H044+$00000888: 197c0002fff5  move.b #$2, -$b(a4)
        move.b #$2, -$b(a4)
L044_0000088E:
; H044+$0000088E: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L044_00000892:
; H044+$00000892: 0c6c0017fffe  cmpi.w #$17, -$2(a4)
        cmpi.w #$17, -$2(a4)
L044_00000898:
; H044+$00000898: 62000016  bhi.w $8b0
        bhi.w H044+$8B0
L044_0000089C:
; H044+$0000089C: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_000008A0:
; H044+$000008A0: 47ecffbe  lea.l -$42(a4), a3
        lea.l -$42(a4), a3
L044_000008A4:
; H044+$000008A4: 17bc00042000  move.b #$4, (a3, d2.w)
        move.b #$4, (a3, d2.w)
L044_000008AA:
; H044+$000008AA: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_000008AE:
; H044+$000008AE: 64e2  bcc.b $892
        bcc.b H044+$892
L044_000008B0:
; H044+$000008B0: 422cffbe  clr.b -$42(a4)
        clr.b -$42(a4)
L044_000008B4:
; H044+$000008B4: 197c0003ffbf  move.b #$3, -$41(a4)
        move.b #$3, -$41(a4)
L044_000008BA:
; H044+$000008BA: 197c0005ffcd  move.b #$5, -$33(a4)
        move.b #$5, -$33(a4)
L044_000008C0:
; H044+$000008C0: 422cffce  clr.b -$32(a4)
        clr.b -$32(a4)
L044_000008C4:
; H044+$000008C4: 197c0003ffcf  move.b #$3, -$31(a4)
        move.b #$3, -$31(a4)
L044_000008CA:
; H044+$000008CA: 197c0005ffd4  move.b #$5, -$2c(a4)
        move.b #$5, -$2c(a4)
L044_000008D0:
; H044+$000008D0: 422cffd5  clr.b -$2b(a4)
        clr.b -$2b(a4)
L044_000008D4:
; H044+$000008D4: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L044_000008D8:
; H044+$000008D8: 0c6c0010fffe  cmpi.w #$10, -$2(a4)
        cmpi.w #$10, -$2(a4)
L044_000008DE:
; H044+$000008DE: 62000016  bhi.w $8f6
        bhi.w H044+$8F6
L044_000008E2:
; H044+$000008E2: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_000008E6:
; H044+$000008E6: 47ecffac  lea.l -$54(a4), a3
        lea.l -$54(a4), a3
L044_000008EA:
; H044+$000008EA: 17bc00042000  move.b #$4, (a3, d2.w)
        move.b #$4, (a3, d2.w)
L044_000008F0:
; H044+$000008F0: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_000008F4:
; H044+$000008F4: 64e2  bcc.b $8d8
        bcc.b H044+$8D8
L044_000008F6:
; H044+$000008F6: 422cffac  clr.b -$54(a4)
        clr.b -$54(a4)
L044_000008FA:
; H044+$000008FA: 197c0003ffad  move.b #$3, -$53(a4)
        move.b #$3, -$53(a4)
L044_00000900:
; H044+$00000900: 197c0005ffbb  move.b #$5, -$45(a4)
        move.b #$5, -$45(a4)
L044_00000906:
; H044+$00000906: 422cffbc  clr.b -$44(a4)
        clr.b -$44(a4)
L044_0000090A:
; H044+$0000090A: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L044_0000090E:
; H044+$0000090E: 0c6c0017fffe  cmpi.w #$17, -$2(a4)
        cmpi.w #$17, -$2(a4)
L044_00000914:
; H044+$00000914: 62000016  bhi.w $92c
        bhi.w H044+$92C
L044_00000918:
; H044+$00000918: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_0000091C:
; H044+$0000091C: 47ecff94  lea.l -$6c(a4), a3
        lea.l -$6c(a4), a3
L044_00000920:
; H044+$00000920: 17bc00042000  move.b #$4, (a3, d2.w)
        move.b #$4, (a3, d2.w)
L044_00000926:
; H044+$00000926: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_0000092A:
; H044+$0000092A: 64e2  bcc.b $90e
        bcc.b H044+$90E
L044_0000092C:
; H044+$0000092C: 422cff94  clr.b -$6c(a4)
        clr.b -$6c(a4)
L044_00000930:
; H044+$00000930: 197c0003ff95  move.b #$3, -$6b(a4)
        move.b #$3, -$6b(a4)
L044_00000936:
; H044+$00000936: 197c0005ffa3  move.b #$5, -$5d(a4)
        move.b #$5, -$5d(a4)
L044_0000093C:
; H044+$0000093C: 422cffa4  clr.b -$5c(a4)
        clr.b -$5c(a4)
L044_00000940:
; H044+$00000940: 197c0003ffa5  move.b #$3, -$5b(a4)
        move.b #$3, -$5b(a4)
L044_00000946:
; H044+$00000946: 197c0005ffaa  move.b #$5, -$56(a4)
        move.b #$5, -$56(a4)
L044_0000094C:
; H044+$0000094C: 422cffab  clr.b -$55(a4)
        clr.b -$55(a4)
L044_00000950:
; H044+$00000950: 397c0002fffe  move.w #$2, -$2(a4)
        move.w #$2, -$2(a4)
L044_00000956:
; H044+$00000956: 0c6c000efffe  cmpi.w #$e, -$2(a4)
        cmpi.w #$e, -$2(a4)
L044_0000095C:
; H044+$0000095C: 62000018  bhi.w $976
        bhi.w H044+$976
L044_00000960:
; H044+$00000960: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_00000964:
; H044+$00000964: 5542  subq.w #$2, d2
        subq.w #$2, d2
L044_00000966:
; H044+$00000966: 47ecff86  lea.l -$7a(a4), a3
        lea.l -$7a(a4), a3
L044_0000096A:
; H044+$0000096A: 17bc00042000  move.b #$4, (a3, d2.w)
        move.b #$4, (a3, d2.w)
L044_00000970:
; H044+$00000970: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_00000974:
; H044+$00000974: 64e0  bcc.b $956
        bcc.b H044+$956
L044_00000976:
; H044+$00000976: 422cff86  clr.b -$7a(a4)
        clr.b -$7a(a4)
L044_0000097A:
; H044+$0000097A: 197c0003ff87  move.b #$3, -$79(a4)
        move.b #$3, -$79(a4)
L044_00000980:
; H044+$00000980: 197c0005ff91  move.b #$5, -$6f(a4)
        move.b #$5, -$6f(a4)
L044_00000986:
; H044+$00000986: 422cff92  clr.b -$6e(a4)
        clr.b -$6e(a4)
L044_0000098A:
; H044+$0000098A: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L044_0000098E:
; H044+$0000098E: 0c6c0016fffe  cmpi.w #$16, -$2(a4)
        cmpi.w #$16, -$2(a4)
L044_00000994:
; H044+$00000994: 62000016  bhi.w $9ac
        bhi.w H044+$9AC
L044_00000998:
; H044+$00000998: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_0000099C:
; H044+$0000099C: 47ecff6e  lea.l -$92(a4), a3
        lea.l -$92(a4), a3
L044_000009A0:
; H044+$000009A0: 17bc00042000  move.b #$4, (a3, d2.w)
        move.b #$4, (a3, d2.w)
L044_000009A6:
; H044+$000009A6: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_000009AA:
; H044+$000009AA: 64e2  bcc.b $98e
        bcc.b H044+$98E
L044_000009AC:
; H044+$000009AC: 422cff6e  clr.b -$92(a4)
        clr.b -$92(a4)
L044_000009B0:
; H044+$000009B0: 197c0003ff6f  move.b #$3, -$91(a4)
        move.b #$3, -$91(a4)
L044_000009B6:
; H044+$000009B6: 197c0005ff83  move.b #$5, -$7d(a4)
        move.b #$5, -$7d(a4)
L044_000009BC:
; H044+$000009BC: 422cff84  clr.b -$7c(a4)
        clr.b -$7c(a4)
L044_000009C0:
; H044+$000009C0: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L044_000009C4:
; H044+$000009C4: 0c6c0016fffe  cmpi.w #$16, -$2(a4)
        cmpi.w #$16, -$2(a4)
L044_000009CA:
; H044+$000009CA: 62000016  bhi.w $9e2
        bhi.w H044+$9E2
L044_000009CE:
; H044+$000009CE: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_000009D2:
; H044+$000009D2: 47ecff56  lea.l -$aa(a4), a3
        lea.l -$aa(a4), a3
L044_000009D6:
; H044+$000009D6: 17bc00042000  move.b #$4, (a3, d2.w)
        move.b #$4, (a3, d2.w)
L044_000009DC:
; H044+$000009DC: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_000009E0:
; H044+$000009E0: 64e2  bcc.b $9c4
        bcc.b H044+$9C4
L044_000009E2:
; H044+$000009E2: 422cff56  clr.b -$aa(a4)
        clr.b -$aa(a4)
L044_000009E6:
; H044+$000009E6: 197c0003ff57  move.b #$3, -$a9(a4)
        move.b #$3, -$a9(a4)
L044_000009EC:
; H044+$000009EC: 197c0005ff5d  move.b #$5, -$a3(a4)
        move.b #$5, -$a3(a4)
L044_000009F2:
; H044+$000009F2: 422cff5e  clr.b -$a2(a4)
        clr.b -$a2(a4)
L044_000009F6:
; H044+$000009F6: 197c0003ff5f  move.b #$3, -$a1(a4)
        move.b #$3, -$a1(a4)
L044_000009FC:
; H044+$000009FC: 197c0005ff65  move.b #$5, -$9b(a4)
        move.b #$5, -$9b(a4)
L044_00000A02:
; H044+$00000A02: 422cff66  clr.b -$9a(a4)
        clr.b -$9a(a4)
L044_00000A06:
; H044+$00000A06: 197c0003ff67  move.b #$3, -$99(a4)
        move.b #$3, -$99(a4)
L044_00000A0C:
; H044+$00000A0C: 197c0005ff69  move.b #$5, -$97(a4)
        move.b #$5, -$97(a4)
L044_00000A12:
; H044+$00000A12: 422cff6a  clr.b -$96(a4)
        clr.b -$96(a4)
L044_00000A16:
; H044+$00000A16: 197c0003ff6b  move.b #$3, -$95(a4)
        move.b #$3, -$95(a4)
L044_00000A1C:
; H044+$00000A1C: 197c0005ff6c  move.b #$5, -$94(a4)
        move.b #$5, -$94(a4)
L044_00000A22:
; H044+$00000A22: 397c0009fffe  move.w #$9, -$2(a4)
        move.w #$9, -$2(a4)
L044_00000A28:
; H044+$00000A28: 0c6c0013fffe  cmpi.w #$13, -$2(a4)
        cmpi.w #$13, -$2(a4)
L044_00000A2E:
; H044+$00000A2E: 6200001a  bhi.w $a4a
        bhi.w H044+$A4A
L044_00000A32:
; H044+$00000A32: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L044_00000A36:
; H044+$00000A36: 04420009  subi.w #$9, d2
        subi.w #$9, d2
L044_00000A3A:
; H044+$00000A3A: 47ecff4a  lea.l -$b6(a4), a3
        lea.l -$b6(a4), a3
L044_00000A3E:
; H044+$00000A3E: 17bc00042000  move.b #$4, (a3, d2.w)
        move.b #$4, (a3, d2.w)
L044_00000A44:
; H044+$00000A44: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L044_00000A48:
; H044+$00000A48: 64de  bcc.b $a28
        bcc.b H044+$A28
L044_00000A4A:
; H044+$00000A4A: 197c0003ff4a  move.b #$3, -$b6(a4)
        move.b #$3, -$b6(a4)
L044_00000A50:
; H044+$00000A50: 197c0005ff50  move.b #$5, -$b0(a4)
        move.b #$5, -$b0(a4)
L044_00000A56:
; H044+$00000A56: 422cff51  clr.b -$af(a4)
        clr.b -$af(a4)
L044_00000A5A:
; H044+$00000A5A: 197c0003ff52  move.b #$3, -$ae(a4)
        move.b #$3, -$ae(a4)
L044_00000A60:
; H044+$00000A60: 197c0005ff54  move.b #$5, -$ac(a4)
        move.b #$5, -$ac(a4)
L044_00000A66:
; H044+$00000A66: 4e5d  unlk a5
        unlk a5
L044_00000A68:
; H044+$00000A68: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L044_00000A6A:
; H044+$00000A6A: 4e75  rts 
        rts 
; End H044: $A6C bytes
