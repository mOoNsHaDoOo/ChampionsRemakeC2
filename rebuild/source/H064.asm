; ============================================================================
; GUIDA DEL MODULO H064
; Handler nativi dei comandi ECL.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Handler nativi dei comandi ECL: EXIT, GOTO, GOSUB, COMPARE, aritmetica, SAVE, LOAD, PRINT, IF, menu, RETURN e altri. La tabella H012+$2F80 collega gli opcode ai gestori.
; --------------------------------------------------------------------------
; H064: 6460 original bytes; all offsets are section-relative.
        section H064,code
H064:
; Preserved bytes H064+$00000000..$000000EE; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$7374
        dc.w $6172,$7420,$7465,$7374,$6368,$6970,$616C,$6C6F
        dc.w $6300,$6578,$6974,$2074,$6573,$7463,$6869,$7061
        dc.w $6C6C,$6F63,$0043,$5049,$4300,$5049,$4300,$0000
        dc.w $0000,$2000,$0000,$5052,$4553,$5320,$4255,$5454
        dc.w $4F4E,$204F,$5220,$5245,$5455,$524E,$2054,$4F20
        dc.w $434F,$4E54,$494E,$5545,$2E00,$5052,$4553,$5320
        dc.w $3C45,$4E54,$4552,$3E2F,$3C52,$4554,$5552,$4E3E
        dc.w $2054,$4F20,$434F,$4E54,$494E,$5545,$0000,$0000
        dc.w $0000,$007E,$0020,$007E,$0000
        dc.l H064+$0000005E
; --------------------------------------------------------------------------
; ROUTINE: module_init_H064 [parziale]
; Scopo: Ingresso del modulo handler nativi dei comandi ECL; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H064+$1936.
; Chiamanti diretti: H000+$022E
; --------------------------------------------------------------------------
L064_000000EE:
; H064+$000000EE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000000F0:
; H064+$000000F0: 287afff8  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_000000F4:
; H064+$000000F4: 4e550000  link.w a5, #$0
        link.w a5, #$0
L064_000000F8:
; H064+$000000F8: 6000183c  bra.w $1936
        bra.w H064+$1936
; Preserved bytes H064+$000000FC..$00000156; code/data not fully classified.
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
; FUNCTION: ECL_0_EXIT
FN_ECL_0_EXIT:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_0 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 0=EXIT.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2A6A, H012+$2E08, H064+$0E92
; --------------------------------------------------------------------------
L064_00000156:
; H064+$00000156: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000158:
; H064+$00000158: 287aff90  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000015C:
; H064+$0000015C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L064_00000160:
; H064+$00000160: 4a39000024bb  tst.b $24bb.l
        tst.b (H005+$24BB).l
L064_00000166:
; H064+$00000166: 67000008  beq.w $170
        beq.w H064+$170
; -> H044+$0330 (sub_H044_00000330)
L064_0000016A:
; H064+$0000016A: 4eb900000330  jsr $330.l
        jsr (H044+$330).l
L064_00000170:
; H064+$00000170: 4a2cffab  tst.b -$55(a4)
        tst.b -$55(a4)
L064_00000174:
; H064+$00000174: 6700000e  beq.w $184
        beq.w H064+$184
; STATO: H005+$3368 = personaggio corrente
L064_00000178:
; H064+$00000178: 23ecffa200003368  move.l -$5e(a4), $3368.l
        move.l -$5e(a4), (H005+$3368).l
L064_00000180:
; H064+$00000180: 422cffab  clr.b -$55(a4)
        clr.b -$55(a4)
L064_00000184:
; H064+$00000184: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_00000188:
; H064+$00000188: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
L064_0000018E:
; H064+$0000018E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L064_00000192:
; H064+$00000192: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L064_00000194:
; H064+$00000194: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L064_0000019A:
; H064+$0000019A: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
L064_000001A0:
; H064+$000001A0: 4239000024bb  clr.b $24bb.l
        clr.b (H005+$24BB).l
L064_000001A6:
; H064+$000001A6: 197c0001ffad  move.b #$1, -$53(a4)
        move.b #$1, -$53(a4)
; STATO: H005+$3DEA = PC logico ECL
L064_000001AC:
; H064+$000001AC: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L064_000001B2:
; H064+$000001B2: 4ab900002388  tst.l $2388.l
        tst.l (H005+$2388).l
L064_000001B8:
; H064+$000001B8: 6700002c  beq.w $1e6
        beq.w H064+$1E6
L064_000001BC:
; H064+$000001BC: 267900002388  movea.l $2388.l, a3
        movea.l (H005+$2388).l, a3
L064_000001C2:
; H064+$000001C2: 23eb000200002384  move.l $2(a3), $2384.l
        move.l $2(a3), (H005+$2384).l
L064_000001CA:
; H064+$000001CA: 2f3900002388  move.l $2388.l, -(a7)
        move.l (H005+$2388).l, -(a7)
L064_000001D0:
; H064+$000001D0: 7406  moveq #$6, d2
        moveq #6, d2
L064_000001D2:
; H064+$000001D2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L064_000001D4:
; H064+$000001D4: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L064_000001DA:
; H064+$000001DA: 23f90000238400002388  move.l $2384.l, $2388.l
        move.l (H005+$2384).l, (H005+$2388).l
L064_000001E4:
; H064+$000001E4: 60cc  bra.b $1b2
        bra.b H064+$1B2
L064_000001E6:
; H064+$000001E6: 33fc00110000334c  move.w #$11, $334c.l
        move.w #$11, (H005+$334C).l
L064_000001EE:
; H064+$000001EE: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L064_000001F6:
; H064+$000001F6: 4239000024bf  clr.b $24bf.l
        clr.b (H005+$24BF).l
L064_000001FC:
; H064+$000001FC: 4e5d  unlk a5
        unlk a5
L064_000001FE:
; H064+$000001FE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000200:
; H064+$00000200: 4e75  rts 
        rts 
; FUNCTION: ECL_1_GOTO
FN_ECL_1_GOTO:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_GOTO [verificato]
; Scopo: Sostituisce il PC logico con il destinatario dell’operando.
;   - Legge un operando e usa ECL_DecodeAddress.
;   - Scrive il nuovo indirizzo in H005+$3DEA.
; Chiamanti diretti: H012+$2E10
; --------------------------------------------------------------------------
L064_00000202:
; H064+$00000202: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000204:
; H064+$00000204: 287afee4  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000208:
; H064+$00000208: 4e550000  link.w a5, #$0
        link.w a5, #$0
L064_0000020C:
; H064+$0000020C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000210:
; H064+$00000210: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000216:
; H064+$00000216: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L064_0000021C:
; H064+$0000021C: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00000222:
; H064+$00000222: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
; STATO: H005+$3DEA = PC logico ECL
L064_00000228:
; H064+$00000228: 33c000003dea  move.w d0, $3dea.l
        move.w d0, (H005+$3DEA).l
L064_0000022E:
; H064+$0000022E: 4e5d  unlk a5
        unlk a5
L064_00000230:
; H064+$00000230: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000232:
; H064+$00000232: 4e75  rts 
        rts 
; FUNCTION: ECL_2_GOSUB
FN_ECL_2_GOSUB:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_GOSUB [parziale]
; Scopo: Legge il destinatario e delega al servizio di chiamata ECL.
;   - Legge un operando.
;   - H061+$3AAC gestisce la prosecuzione/chiamata dello script.
;   - La struttura precisa di tutti i record dello stack ECL resta da completare.
; Chiamanti diretti: H012+$2E18
; --------------------------------------------------------------------------
L064_00000234:
; H064+$00000234: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000236:
; H064+$00000236: 287afeb2  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000023A:
; H064+$0000023A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L064_0000023E:
; H064+$0000023E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000242:
; H064+$00000242: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000248:
; H064+$00000248: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H061+$3AAC (sub_H061_00003AAC)
L064_0000024C:
; H064+$0000024C: 4eb900003aac  jsr $3aac.l
        jsr (H061+$3AAC).l
L064_00000252:
; H064+$00000252: 4e5d  unlk a5
        unlk a5
L064_00000254:
; H064+$00000254: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000256:
; H064+$00000256: 4e75  rts 
        rts 
; FUNCTION: ECL_3_COMPARE
FN_ECL_3_COMPARE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_3 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 3=COMPARE.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E20
; --------------------------------------------------------------------------
L064_00000258:
; H064+$00000258: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_0000025A:
; H064+$0000025A: 287afe8e  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000025E:
; H064+$0000025E: 4e55ff56  link.w a5, #$ff56
        link.w a5, #$ff56
L064_00000262:
; H064+$00000262: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000266:
; H064+$00000266: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_0000026C:
; H064+$0000026C: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000026E:
; H064+$0000026E: 1439000014d2  move.b $14d2.l, d2
        move.b (H061+$14D2).l, d2
L064_00000274:
; H064+$00000274: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L064_00000278:
; H064+$00000278: 64000012  bcc.w $28c
        bcc.w H064+$28C
L064_0000027C:
; H064+$0000027C: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000027E:
; H064+$0000027E: 1439000014d3  move.b $14d3.l, d2
        move.b (H061+$14D3).l, d2
L064_00000284:
; H064+$00000284: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L064_00000288:
; H064+$00000288: 6500004c  bcs.w $2d6
        bcs.w H064+$2D6
L064_0000028C:
; H064+$0000028C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L064_00000290:
; H064+$00000290: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
L064_00000294:
; H064+$00000294: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_00000298:
; H064+$00000298: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
; -> H026+$0188 (sub_H026_00000188)
L064_0000029E:
; H064+$0000029E: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L064_000002A4:
; H064+$000002A4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L064_000002A8:
; H064+$000002A8: 486dff56  pea.l -$aa(a5)
        pea.l -$aa(a5)
L064_000002AC:
; H064+$000002AC: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_000002B0:
; H064+$000002B0: 487900000152  pea.l $152.l
        pea.l (H061+$152).l
; -> H026+$0188 (sub_H026_00000188)
L064_000002B6:
; H064+$000002B6: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L064_000002BC:
; H064+$000002BC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L064_000002C0:
; H064+$000002C0: 486dffa8  pea.l -$58(a5)
        pea.l -$58(a5)
L064_000002C4:
; H064+$000002C4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L064_000002C8:
; H064+$000002C8: 486dff56  pea.l -$aa(a5)
        pea.l -$aa(a5)
; -> H061+$3904 (sub_H061_00003904)
L064_000002CC:
; H064+$000002CC: 4eb900003904  jsr $3904.l
        jsr (H061+$3904).l
L064_000002D2:
; H064+$000002D2: 6000002c  bra.w $300
        bra.w H064+$300
L064_000002D6:
; H064+$000002D6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000002DA:
; H064+$000002DA: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_000002E0:
; H064+$000002E0: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_000002E4:
; H064+$000002E4: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000002E8:
; H064+$000002E8: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_000002EE:
; H064+$000002EE: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L064_000002F2:
; H064+$000002F2: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L064_000002F6:
; H064+$000002F6: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H061+$3A0A (sub_H061_00003A0A)
L064_000002FA:
; H064+$000002FA: 4eb900003a0a  jsr $3a0a.l
        jsr (H061+$3A0A).l
L064_00000300:
; H064+$00000300: 4e5d  unlk a5
        unlk a5
L064_00000302:
; H064+$00000302: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000304:
; H064+$00000304: 4e75  rts 
        rts 
; FUNCTION: ECL_4_ADD__5_SUBTRAT__6_DIVIDE__7_MULTIPLY
FN_ECL_4_ADD__5_SUBTRAT__6_DIVIDE__7_MULTIPLY:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Arithmetic [verificato]
; Scopo: Esegue ADD, SUBTRAT, DIVIDE o MULTIPLY e memorizza il risultato nella destinazione del terzo operando.
;   - Legge tre operandi e valuta i primi due come word.
;   - ADD somma i due valori; SUBTRAT calcola secondo meno primo.
;   - DIVIDE usa DIVU: primo diviso secondo; conserva anche il resto in stato B+$067E.
;   - MULTIPLY usa MULU; il valore scritto dal percorso comune è una word.
;   - Il terzo operando codifica il riferimento di destinazione passato al servizio di scrittura.
; Chiamanti diretti: H012+$2E28
; --------------------------------------------------------------------------
L064_00000306:
; H064+$00000306: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000308:
; H064+$00000308: 287afde0  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000030C:
; H064+$0000030C: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L064_00000310:
; H064+$00000310: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000314:
; H064+$00000314: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_0000031A:
; H064+$0000031A: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L064_00000320:
; H064+$00000320: 0c6d0002fff8  cmpi.w #$2, -$8(a5)
        cmpi.w #$2, -$8(a5)
L064_00000326:
; H064+$00000326: 6e00002a  bgt.w $352
        bgt.w H064+$352
L064_0000032A:
; H064+$0000032A: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L064_0000032E:
; H064+$0000032E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_00000330:
; H064+$00000330: e342  asl.w #$1, d2
        asl.w #$1, d2
L064_00000332:
; H064+$00000332: 47edfffa  lea.l -$6(a5), a3
        lea.l -$6(a5), a3
L064_00000336:
; H064+$00000336: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L064_0000033A:
; H064+$0000033A: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_0000033E:
; H064+$0000033E: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000344:
; H064+$00000344: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L064_00000348:
; H064+$00000348: 37802000  move.w d0, (a3, d2.w)
        move.w d0, (a3, d2.w)
L064_0000034C:
; H064+$0000034C: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L064_00000350:
; H064+$00000350: 68ce  bvc.b $320
        bvc.b H064+$320
L064_00000352:
; H064+$00000352: 1f3900001454  move.b $1454.l, -(a7)
        move.b (H061+$1454).l, -(a7)
L064_00000358:
; H064+$00000358: 1f3900001494  move.b $1494.l, -(a7)
        move.b (H061+$1494).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_0000035E:
; H064+$0000035E: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_00000364:
; H064+$00000364: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L064_00000368:
; H064+$00000368: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$2493 = opcode ECL corrente
L064_0000036A:
; H064+$0000036A: 143900002493  move.b $2493.l, d2
        move.b (H005+$2493).l, d2
L064_00000370:
; H064+$00000370: 6000005e  bra.w $3d0
        bra.w H064+$3D0
L064_00000374:
; H064+$00000374: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_00000378:
; H064+$00000378: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L064_0000037C:
; H064+$0000037C: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L064_00000380:
; H064+$00000380: 4e75  rts 
        rts 
L064_00000382:
; H064+$00000382: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L064_00000386:
; H064+$00000386: 946dfffa  sub.w -$6(a5), d2
        sub.w -$6(a5), d2
L064_0000038A:
; H064+$0000038A: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L064_0000038E:
; H064+$0000038E: 4e75  rts 
        rts 
L064_00000390:
; H064+$00000390: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000392:
; H064+$00000392: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_00000396:
; H064+$00000396: 84edfffc  divu.w -$4(a5), d2
        divu.w -$4(a5), d2
L064_0000039A:
; H064+$0000039A: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L064_0000039E:
; H064+$0000039E: 7400  moveq #$0, d2
        moveq #0, d2
L064_000003A0:
; H064+$000003A0: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_000003A4:
; H064+$000003A4: 84edfffc  divu.w -$4(a5), d2
        divu.w -$4(a5), d2
L064_000003A8:
; H064+$000003A8: 4842  swap d2
        swap d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_000003AA:
; H064+$000003AA: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_000003B0:
; H064+$000003B0: 3742067e  move.w d2, $67e(a3)
        move.w d2, $67e(a3)
L064_000003B4:
; H064+$000003B4: 4e75  rts 
        rts 
L064_000003B6:
; H064+$000003B6: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_000003BA:
; H064+$000003BA: c4edfffc  mulu.w -$4(a5), d2
        mulu.w -$4(a5), d2
L064_000003BE:
; H064+$000003BE: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L064_000003C2:
; H064+$000003C2: 4e75  rts 
        rts 
L064_000003C4:
; H064+$000003C4: 4e75  rts 
        rts 
; Preserved bytes H064+$000003C6..$000003D0; code/data not fully classified.
        dc.w $FFFC,$FFAC,$FFBA,$FFC8,$FFEE
L064_000003D0:
; H064+$000003D0: 47fafff6  lea.l $3c8(pc), a3
        lea.l H064+$3C8(pc), a3
L064_000003D4:
; H064+$000003D4: 5942  subq.w #$4, d2
        subq.w #$4, d2
L064_000003D6:
; H064+$000003D6: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L064_000003DA:
; H064+$000003DA: 6302  bls.b $3de
        bls.b H064+$3DE
L064_000003DC:
; H064+$000003DC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L064_000003DE:
; H064+$000003DE: e342  asl.w #$1, d2
        asl.w #$1, d2
L064_000003E0:
; H064+$000003E0: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H064+$03C8; indici 0..3, default -1.
L064_000003E4:
; H064+$000003E4: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L064_000003E8:
; H064+$000003E8: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L064_000003EC:
; H064+$000003EC: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_000003F0:
; H064+$000003F0: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_000003F6:
; H064+$000003F6: 4e5d  unlk a5
        unlk a5
L064_000003F8:
; H064+$000003F8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_000003FA:
; H064+$000003FA: 4e75  rts 
        rts 
; FUNCTION: ECL_8_RANDOM
FN_ECL_8_RANDOM:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_8 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 8=RANDOM.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E30
; --------------------------------------------------------------------------
L064_000003FC:
; H064+$000003FC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000003FE:
; H064+$000003FE: 287afcea  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000402:
; H064+$00000402: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L064_00000406:
; H064+$00000406: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_0000040A:
; H064+$0000040A: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000410:
; H064+$00000410: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00000414:
; H064+$00000414: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_0000041A:
; H064+$0000041A: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L064_0000041E:
; H064+$0000041E: 0c6d00fffffe  cmpi.w #$ff, -$2(a5)
        cmpi.w #$ff, -$2(a5)
L064_00000424:
; H064+$00000424: 64000006  bcc.w $42c
        bcc.w H064+$42C
L064_00000428:
; H064+$00000428: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L064_0000042C:
; H064+$0000042C: 1f3900001453  move.b $1453.l, -(a7)
        move.b (H061+$1453).l, -(a7)
L064_00000432:
; H064+$00000432: 1f3900001493  move.b $1493.l, -(a7)
        move.b (H061+$1493).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00000438:
; H064+$00000438: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_0000043E:
; H064+$0000043E: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L064_00000442:
; H064+$00000442: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000444:
; H064+$00000444: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L064_00000448:
; H064+$00000448: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L064_0000044A:
; H064+$0000044A: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L064_00000450:
; H064+$00000450: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_00000454:
; H064+$00000454: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L064_00000458:
; H064+$00000458: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_0000045C:
; H064+$0000045C: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_00000462:
; H064+$00000462: 4e5d  unlk a5
        unlk a5
L064_00000464:
; H064+$00000464: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000466:
; H064+$00000466: 4e75  rts 
        rts 
; FUNCTION: ECL_9_SAVE
FN_ECL_9_SAVE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_SAVE_AssignVariable [verificato]
; Scopo: Implementa l’opcode ECL SAVE come assegnazione a variabile/riferimento.
;   - Legge due operandi.
;   - Ricava la destinazione codificata dal secondo operando.
;   - Memorizza valore numerico o stringa attraverso gli helper del modulo ECL.
;   - Non apre né scrive savgam*.dat: il salvataggio su disco è H066+$3000.
; Chiamanti diretti: H012+$2E38
; --------------------------------------------------------------------------
L064_00000468:
; H064+$00000468: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_0000046A:
; H064+$0000046A: 287afc7e  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000046E:
; H064+$0000046E: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L064_00000472:
; H064+$00000472: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000476:
; H064+$00000476: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_0000047C:
; H064+$0000047C: 1f3900001453  move.b $1453.l, -(a7)
        move.b (H061+$1453).l, -(a7)
L064_00000482:
; H064+$00000482: 1f3900001493  move.b $1493.l, -(a7)
        move.b (H061+$1493).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00000488:
; H064+$00000488: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_0000048E:
; H064+$0000048E: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_00000492:
; H064+$00000492: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000494:
; H064+$00000494: 1439000014d2  move.b $14d2.l, d2
        move.b (H061+$14D2).l, d2
L064_0000049A:
; H064+$0000049A: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L064_0000049E:
; H064+$0000049E: 64000022  bcc.w $4c2
        bcc.w H064+$4C2
L064_000004A2:
; H064+$000004A2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000004A6:
; H064+$000004A6: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_000004AC:
; H064+$000004AC: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L064_000004B0:
; H064+$000004B0: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L064_000004B4:
; H064+$000004B4: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; PASSO: SAVE ECL numerico: memorizzazione di un valore, non salvataggio della partita su disco.
; -> H061+$2BAA (sub_H061_00002BAA)
L064_000004B8:
; H064+$000004B8: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_000004BE:
; H064+$000004BE: 60000016  bra.w $4d6
        bra.w H064+$4D6
L064_000004C2:
; H064+$000004C2: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L064_000004C6:
; H064+$000004C6: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_000004CA:
; H064+$000004CA: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
; PASSO: SAVE ECL stringa: memorizzazione nel riferimento destinazione.
; -> H061+$3012 (sub_H061_00003012)
L064_000004D0:
; H064+$000004D0: 4eb900003012  jsr $3012.l
        jsr (H061+$3012).l
L064_000004D6:
; H064+$000004D6: 4e5d  unlk a5
        unlk a5
L064_000004D8:
; H064+$000004D8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_000004DA:
; H064+$000004DA: 4e75  rts 
        rts 
; FUNCTION: ECL_10_LOAD_CHARACTER
FN_ECL_10_LOAD_CHARACTER:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_10 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 10=LOAD CHARACTER.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E40
; --------------------------------------------------------------------------
L064_000004DC:
; H064+$000004DC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000004DE:
; H064+$000004DE: 287afc0a  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_000004E2:
; H064+$000004E2: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L064_000004E6:
; H064+$000004E6: 197c0001ffab  move.b #$1, -$55(a4)
        move.b #$1, -$55(a4)
L064_000004EC:
; H064+$000004EC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_000004F0:
; H064+$000004F0: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_000004F6:
; H064+$000004F6: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L064_000004FA:
; H064+$000004FA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000004FE:
; H064+$000004FE: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000504:
; H064+$00000504: 1b40fff7  move.b d0, -$9(a5)
        move.b d0, -$9(a5)
; STATO: H005+$3364 = testa della lista del party
L064_00000508:
; H064+$00000508: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L064_00000510:
; H064+$00000510: 1f2dfff7  move.b -$9(a5), -(a7)
        move.b -$9(a5), -(a7)
L064_00000514:
; H064+$00000514: 3f3c0080  move.w #$80, -(a7)
        move.w #$80, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L064_00000518:
; H064+$00000518: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L064_0000051E:
; H064+$0000051E: 1b40fff6  move.b d0, -$a(a5)
        move.b d0, -$a(a5)
L064_00000522:
; H064+$00000522: 1f2dfff7  move.b -$9(a5), -(a7)
        move.b -$9(a5), -(a7)
L064_00000526:
; H064+$00000526: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L064_0000052A:
; H064+$0000052A: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L064_00000530:
; H064+$00000530: 1b40fff7  move.b d0, -$9(a5)
        move.b d0, -$9(a5)
L064_00000534:
; H064+$00000534: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000536:
; H064+$00000536: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L064_0000053A:
; H064+$0000053A: 4a42  tst.w d2
        tst.w d2
L064_0000053C:
; H064+$0000053C: 6300002a  bls.w $568
        bls.w H064+$568
L064_00000540:
; H064+$00000540: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000542:
; H064+$00000542: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L064_00000546:
; H064+$00000546: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L064_0000054A:
; H064+$0000054A: b842  cmp.w d2, d4
        cmp.w d2, d4
L064_0000054C:
; H064+$0000054C: 6400001a  bcc.w $568
        bcc.w H064+$568
L064_00000550:
; H064+$00000550: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L064_00000554:
; H064+$00000554: 67000012  beq.w $568
        beq.w H064+$568
L064_00000558:
; H064+$00000558: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L064_0000055C:
; H064+$0000055C: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L064_00000562:
; H064+$00000562: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L064_00000566:
; H064+$00000566: 60d8  bra.b $540
        bra.b H064+$540
L064_00000568:
; H064+$00000568: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L064_0000056C:
; H064+$0000056C: 67000014  beq.w $582
        beq.w H064+$582
; STATO: H005+$3368 = personaggio corrente
L064_00000570:
; H064+$00000570: 23edfffc00003368  move.l -$4(a5), $3368.l
        move.l -$4(a5), (H005+$3368).l
L064_00000578:
; H064+$00000578: 4239000024b3  clr.b $24b3.l
        clr.b (H005+$24B3).l
L064_0000057E:
; H064+$0000057E: 6000000a  bra.w $58a
        bra.w H064+$58A
L064_00000582:
; H064+$00000582: 13fc0001000024b3  move.b #$1, $24b3.l
        move.b #$1, (H005+$24B3).l
L064_0000058A:
; H064+$0000058A: 4a2dfff6  tst.b -$a(a5)
        tst.b -$a(a5)
L064_0000058E:
; H064+$0000058E: 6700004c  beq.w $5dc
        beq.w H064+$5DC
L064_00000592:
; H064+$00000592: 4a39000024c4  tst.b $24c4.l
        tst.b (H005+$24C4).l
L064_00000598:
; H064+$00000598: 67000042  beq.w $5dc
        beq.w H064+$5DC
L064_0000059C:
; H064+$0000059C: 4a39000024c3  tst.b $24c3.l
        tst.b (H005+$24C3).l
L064_000005A2:
; H064+$000005A2: 67000038  beq.w $5dc
        beq.w H064+$5DC
L064_000005A6:
; H064+$000005A6: 242cffa2  move.l -$5e(a4), d2
        move.l -$5e(a4), d2
; STATO: H005+$3368 = personaggio corrente
L064_000005AA:
; H064+$000005AA: b4b900003368  cmp.l $3368.l, d2
        cmp.l (H005+$3368).l, d2
L064_000005B0:
; H064+$000005B0: 66000006  bne.w $5b8
        bne.w H064+$5B8
L064_000005B4:
; H064+$000005B4: 422cffab  clr.b -$55(a4)
        clr.b -$55(a4)
L064_000005B8:
; H064+$000005B8: 4227  clr.b -(a7)
        clr.b -(a7)
L064_000005BA:
; H064+$000005BA: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H053+$00CA (trampoline_H053_01E8)
L064_000005BE:
; H064+$000005BE: 4eb9000000ca  jsr $ca.l
        jsr (H053+$CA).l
; STATO: H005+$3368 = personaggio corrente
L064_000005C4:
; H064+$000005C4: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L064_000005CA:
; H064+$000005CA: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L064_000005D0:
; H064+$000005D0: 4239000024c4  clr.b $24c4.l
        clr.b (H005+$24C4).l
L064_000005D6:
; H064+$000005D6: 4239000024c3  clr.b $24c3.l
        clr.b (H005+$24C3).l
L064_000005DC:
; H064+$000005DC: 4e5d  unlk a5
        unlk a5
L064_000005DE:
; H064+$000005DE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_000005E0:
; H064+$000005E0: 4e75  rts 
        rts 
; FUNCTION: ECL_12_SETUP_MONSTER
FN_ECL_12_SETUP_MONSTER:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_12 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 12=SETUP MONSTER.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E50
; --------------------------------------------------------------------------
L064_000005E2:
; H064+$000005E2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000005E4:
; H064+$000005E4: 287afb04  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_000005E8:
; H064+$000005E8: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L064_000005EC:
; H064+$000005EC: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_000005F0:
; H064+$000005F0: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_000005F6:
; H064+$000005F6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000005FA:
; H064+$000005FA: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000600:
; H064+$00000600: 13c000002491  move.b d0, $2491.l
        move.b d0, (H005+$2491).l
L064_00000606:
; H064+$00000606: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_0000060A:
; H064+$0000060A: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000610:
; H064+$00000610: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000616:
; H064+$00000616: 37400580  move.w d0, $580(a3)
        move.w d0, $580(a3)
L064_0000061A:
; H064+$0000061A: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_0000061E:
; H064+$0000061E: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000624:
; H064+$00000624: 13c000002490  move.b d0, $2490.l
        move.b d0, (H005+$2490).l
; STATO: H005+$281C = inizio del blocco coordinate/vista
L064_0000062A:
; H064+$0000062A: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L064_00000630:
; H064+$00000630: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
L064_00000636:
; H064+$00000636: 1f3900002820  move.b $2820.l, -(a7)
        move.b (H005+$2820).l, -(a7)
; -> H061+$1C42 (sub_H061_00001C42)
L064_0000063C:
; H064+$0000063C: 4eb900001c42  jsr $1c42.l
        jsr (H061+$1C42).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000642:
; H064+$00000642: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000648:
; H064+$00000648: 37400582  move.w d0, $582(a3)
        move.w d0, $582(a3)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_0000064C:
; H064+$0000064C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000652:
; H064+$00000652: 342b0580  move.w $580(a3), d2
        move.w $580(a3), d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000656:
; H064+$00000656: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_0000065C:
; H064+$0000065C: b46b0582  cmp.w $582(a3), d2
        cmp.w $582(a3), d2
L064_00000660:
; H064+$00000660: 64000014  bcc.w $676
        bcc.w H064+$676
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000664:
; H064+$00000664: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_0000066A:
; H064+$0000066A: 247900003e00  movea.l $3e00.l, a2
        movea.l (H005+$3E00).l, a2
L064_00000670:
; H064+$00000670: 356b05800582  move.w $580(a3), $582(a2)
        move.w $580(a3), $582(a2)
L064_00000676:
; H064+$00000676: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L064_0000067C:
; H064+$0000067C: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000682:
; H064+$00000682: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000688:
; H064+$00000688: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L064_0000068C:
; H064+$0000068C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L064_0000068E:
; H064+$0000068E: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L064_00000694:
; H064+$00000694: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
L064_0000069A:
; H064+$0000069A: 4e5d  unlk a5
        unlk a5
L064_0000069C:
; H064+$0000069C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_0000069E:
; H064+$0000069E: 4e75  rts 
        rts 
; FUNCTION: ECL_11_LOAD_MONSTER
FN_ECL_11_LOAD_MONSTER:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_11 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 11=LOAD MONSTER.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E48
; --------------------------------------------------------------------------
L064_000006A0:
; H064+$000006A0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000006A2:
; H064+$000006A2: 287afa46  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_000006A6:
; H064+$000006A6: 4e55fe1a  link.w a5, #$fe1a
        link.w a5, #$fe1a
; STATO: H005+$3368 = personaggio corrente
L064_000006AA:
; H064+$000006AA: 2b7900003368ffea  move.l $3368.l, -$16(a5)
        move.l (H005+$3368).l, -$16(a5)
L064_000006B2:
; H064+$000006B2: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L064_000006B8:
; H064+$000006B8: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_000006BC:
; H064+$000006BC: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_000006C2:
; H064+$000006C2: 7400  moveq #$0, d2
        moveq #0, d2
L064_000006C4:
; H064+$000006C4: 142cffa7  move.b -$59(a4), d2
        move.b -$59(a4), d2
L064_000006C8:
; H064+$000006C8: 0c42003f  cmpi.w #$3f, d2
        cmpi.w #$3f, d2
L064_000006CC:
; H064+$000006CC: 640003ea  bcc.w $ab8
        bcc.w H064+$AB8
L064_000006D0:
; H064+$000006D0: 42adfff6  clr.l -$a(a5)
        clr.l -$a(a5)
L064_000006D4:
; H064+$000006D4: 42adfff2  clr.l -$e(a5)
        clr.l -$e(a5)
L064_000006D8:
; H064+$000006D8: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000006DC:
; H064+$000006DC: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_000006E2:
; H064+$000006E2: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L064_000006E6:
; H064+$000006E6: 1f2dffff  move.b -$1(a5), -(a7)
        move.b -$1(a5), -(a7)
L064_000006EA:
; H064+$000006EA: 486dffee  pea.l -$12(a5)
        pea.l -$12(a5)
L064_000006EE:
; H064+$000006EE: 486dfe2e  pea.l -$1d2(a5)
        pea.l -$1d2(a5)
L064_000006F2:
; H064+$000006F2: 486dfe22  pea.l -$1de(a5)
        pea.l -$1de(a5)
; -> H061+$1BD6 (sub_H061_00001BD6)
L064_000006F6:
; H064+$000006F6: 4eb900001bd6  jsr $1bd6.l
        jsr (H061+$1BD6).l
L064_000006FC:
; H064+$000006FC: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_00000700:
; H064+$00000700: 0c2b00010199  cmpi.b #$1, $199(a3)
        cmpi.b #$1, $199(a3)
L064_00000706:
; H064+$00000706: 66000098  bne.w $7a0
        bne.w H064+$7A0
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_0000070A:
; H064+$0000070A: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_00000710:
; H064+$00000710: 4a6b03e8  tst.w $3e8(a3)
        tst.w $3e8(a3)
L064_00000714:
; H064+$00000714: 6300008a  bls.w $7a0
        bls.w H064+$7A0
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_00000718:
; H064+$00000718: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_0000071E:
; H064+$0000071E: 0c6b000603e8  cmpi.w #$6, $3e8(a3)
        cmpi.w #$6, $3e8(a3)
L064_00000724:
; H064+$00000724: 6400007a  bcc.w $7a0
        bcc.w H064+$7A0
L064_00000728:
; H064+$00000728: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000072A:
; H064+$0000072A: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_0000072E:
; H064+$0000072E: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_00000732:
; H064+$00000732: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_00000738:
; H064+$00000738: 382b03e8  move.w $3e8(a3), d4
        move.w $3e8(a3), d4
L064_0000073C:
; H064+$0000073C: 5244  addq.w #$1, d4
        addq.w #$1, d4
L064_0000073E:
; H064+$0000073E: c4c4  mulu.w d4, d2
        mulu.w d4, d2
L064_00000740:
; H064+$00000740: e44a  lsr.w #$2, d2
        lsr.w #$2, d2
L064_00000742:
; H064+$00000742: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_00000746:
; H064+$00000746: 174201a8  move.b d2, $1a8(a3)
        move.b d2, $1a8(a3)
L064_0000074A:
; H064+$0000074A: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000074C:
; H064+$0000074C: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_00000750:
; H064+$00000750: 142b0064  move.b $64(a3), d2
        move.b $64(a3), d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_00000754:
; H064+$00000754: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_0000075A:
; H064+$0000075A: 382b03e8  move.w $3e8(a3), d4
        move.w $3e8(a3), d4
L064_0000075E:
; H064+$0000075E: 5244  addq.w #$1, d4
        addq.w #$1, d4
L064_00000760:
; H064+$00000760: c4c4  mulu.w d4, d2
        mulu.w d4, d2
L064_00000762:
; H064+$00000762: e44a  lsr.w #$2, d2
        lsr.w #$2, d2
L064_00000764:
; H064+$00000764: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_00000768:
; H064+$00000768: 17420064  move.b d2, $64(a3)
        move.b d2, $64(a3)
L064_0000076C:
; H064+$0000076C: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000076E:
; H064+$0000076E: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_00000772:
; H064+$00000772: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L064_00000776:
; H064+$00000776: 4a42  tst.w d2
        tst.w d2
L064_00000778:
; H064+$00000778: 67000012  beq.w $78c
        beq.w H064+$78C
L064_0000077C:
; H064+$0000077C: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000077E:
; H064+$0000077E: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_00000782:
; H064+$00000782: 142b0064  move.b $64(a3), d2
        move.b $64(a3), d2
L064_00000786:
; H064+$00000786: 4a42  tst.w d2
        tst.w d2
L064_00000788:
; H064+$00000788: 66000016  bne.w $7a0
        bne.w H064+$7A0
L064_0000078C:
; H064+$0000078C: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_00000790:
; H064+$00000790: 177c000101a8  move.b #$1, $1a8(a3)
        move.b #$1, $1a8(a3)
L064_00000796:
; H064+$00000796: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_0000079A:
; H064+$0000079A: 177c00010064  move.b #$1, $64(a3)
        move.b #$1, $64(a3)
L064_000007A0:
; H064+$000007A0: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_000007A4:
; H064+$000007A4: 4a2b00df  tst.b $df(a3)
        tst.b $df(a3)
L064_000007A8:
; H064+$000007A8: 67000012  beq.w $7bc
        beq.w H064+$7BC
L064_000007AC:
; H064+$000007AC: 48790000248f  pea.l $248f.l
        pea.l (H005+$248F).l
L064_000007B2:
; H064+$000007B2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L064_000007B6:
; H064+$000007B6: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L064_000007BC:
; H064+$000007BC: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L064_000007C0:
; H064+$000007C0: 45edfe40  lea.l -$1c0(a5), a2
        lea.l -$1c0(a5), a2
L064_000007C4:
; H064+$000007C4: 343c00d4  move.w #$d4, d2
        move.w #$d4, d2
L064_000007C8:
; H064+$000007C8: 34db  move.w (a3)+, (a2)+
        move.w (a3)+, (a2)+
L064_000007CA:
; H064+$000007CA: 51cafffc  dbra d2, $7c8
        dbra d2, H064+$7C8
L064_000007CE:
; H064+$000007CE: 2b6dfe2efe26  move.l -$1d2(a5), -$1da(a5)
        move.l -$1d2(a5), -$1da(a5)
L064_000007D4:
; H064+$000007D4: 2b6dfe22fe1a  move.l -$1de(a5), -$1e6(a5)
        move.l -$1de(a5), -$1e6(a5)
L064_000007DA:
; H064+$000007DA: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000007DE:
; H064+$000007DE: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_000007E4:
; H064+$000007E4: 1b40fffe  move.b d0, -$2(a5)
        move.b d0, -$2(a5)
L064_000007E8:
; H064+$000007E8: 7400  moveq #$0, d2
        moveq #0, d2
L064_000007EA:
; H064+$000007EA: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L064_000007EE:
; H064+$000007EE: 4a42  tst.w d2
        tst.w d2
L064_000007F0:
; H064+$000007F0: 66000008  bne.w $7fa
        bne.w H064+$7FA
L064_000007F4:
; H064+$000007F4: 1b7c0001fffe  move.b #$1, -$2(a5)
        move.b #$1, -$2(a5)
L064_000007FA:
; H064+$000007FA: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000007FE:
; H064+$000007FE: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000804:
; H064+$00000804: 1b40fffd  move.b d0, -$3(a5)
        move.b d0, -$3(a5)
; STATO: H005+$3364 = testa della lista del party
L064_00000808:
; H064+$00000808: 2b7900003364fff6  move.l $3364.l, -$a(a5)
        move.l (H005+$3364).l, -$a(a5)
L064_00000810:
; H064+$00000810: 47ec0027  lea.l $27(a4), a3
        lea.l $27(a4), a3
L064_00000814:
; H064+$00000814: 45edfe32  lea.l -$1ce(a5), a2
        lea.l -$1ce(a5), a2
L064_00000818:
; H064+$00000818: 740c  moveq #$c, d2
        moveq #12, d2
L064_0000081A:
; H064+$0000081A: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_0000081C:
; H064+$0000081C: 57cafffc  dbeq d2, $81a
        dbeq d2, H064+$81A
L064_00000820:
; H064+$00000820: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L064_00000824:
; H064+$00000824: 486dfe32  pea.l -$1ce(a5)
        pea.l -$1ce(a5)
L064_00000828:
; H064+$00000828: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000082A:
; H064+$0000082A: 142dfffd  move.b -$3(a5), d2
        move.b -$3(a5), d2
L064_0000082E:
; H064+$0000082E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L064_00000830:
; H064+$00000830: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000832:
; H064+$00000832: 14390000248e  move.b $248e.l, d2
        move.b (H005+$248E).l, d2
L064_00000838:
; H064+$00000838: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H035+$0246 (sub_H035_00000246)
L064_0000083A:
; H064+$0000083A: 4eb900000246  jsr $246.l
        jsr (H035+$246).l
L064_00000840:
; H064+$00000840: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000844:
; H064+$00000844: 4aab018e  tst.l $18e(a3)
        tst.l $18e(a3)
L064_00000848:
; H064+$00000848: 6700000e  beq.w $858
        beq.w H064+$858
L064_0000084C:
; H064+$0000084C: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000850:
; H064+$00000850: 2b6b018efff6  move.l $18e(a3), -$a(a5)
        move.l $18e(a3), -$a(a5)
L064_00000856:
; H064+$00000856: 60e8  bra.b $840
        bra.b H064+$840
L064_00000858:
; H064+$00000858: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_0000085C:
; H064+$0000085C: 276dffee018e  move.l -$12(a5), $18e(a3)
        move.l -$12(a5), $18e(a3)
L064_00000862:
; H064+$00000862: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000866:
; H064+$00000866: 2b6b018efff6  move.l $18e(a3), -$a(a5)
        move.l $18e(a3), -$a(a5)
L064_0000086C:
; H064+$0000086C: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000870:
; H064+$00000870: 17790000248e0143  move.b $248e.l, $143(a3)
        move.b (H005+$248E).l, $143(a3)
L064_00000878:
; H064+$00000878: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_0000087C:
; H064+$0000087C: 42ab018e  clr.l $18e(a3)
        clr.l $18e(a3)
L064_00000880:
; H064+$00000880: 486cffa7  pea.l -$59(a4)
        pea.l -$59(a4)
L064_00000884:
; H064+$00000884: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L064_00000888:
; H064+$00000888: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L064_0000088E:
; H064+$0000088E: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L064_00000892:
; H064+$00000892: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000894:
; H064+$00000894: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L064_00000898:
; H064+$00000898: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L064_0000089C:
; H064+$0000089C: b842  cmp.w d2, d4
        cmp.w d2, d4
L064_0000089E:
; H064+$0000089E: 620001f8  bhi.w $a98
        bhi.w H064+$A98
L064_000008A2:
; H064+$000008A2: 7400  moveq #$0, d2
        moveq #0, d2
L064_000008A4:
; H064+$000008A4: 142cffa7  move.b -$59(a4), d2
        move.b -$59(a4), d2
L064_000008A8:
; H064+$000008A8: 0c42003f  cmpi.w #$3f, d2
        cmpi.w #$3f, d2
L064_000008AC:
; H064+$000008AC: 640001ea  bcc.w $a98
        bcc.w H064+$A98
L064_000008B0:
; H064+$000008B0: 243c000001aa  move.l #$1aa, d2
        move.l #$1aa, d2
L064_000008B6:
; H064+$000008B6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L064_000008B8:
; H064+$000008B8: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L064_000008BE:
; H064+$000008BE: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L064_000008C4:
; H064+$000008C4: 2b40fff2  move.l d0, -$e(a5)
        move.l d0, -$e(a5)
L064_000008C8:
; H064+$000008C8: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_000008CC:
; H064+$000008CC: 276dfff2018e  move.l -$e(a5), $18e(a3)
        move.l -$e(a5), $18e(a3)
L064_000008D2:
; H064+$000008D2: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_000008D6:
; H064+$000008D6: 2b6b018efff6  move.l $18e(a3), -$a(a5)
        move.l $18e(a3), -$a(a5)
L064_000008DC:
; H064+$000008DC: 47edfe40  lea.l -$1c0(a5), a3
        lea.l -$1c0(a5), a3
L064_000008E0:
; H064+$000008E0: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_000008E4:
; H064+$000008E4: 343c00d4  move.w #$d4, d2
        move.w #$d4, d2
L064_000008E8:
; H064+$000008E8: 34db  move.w (a3)+, (a2)+
        move.w (a3)+, (a2)+
L064_000008EA:
; H064+$000008EA: 51cafffc  dbra d2, $8e8
        dbra d2, H064+$8E8
L064_000008EE:
; H064+$000008EE: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_000008F2:
; H064+$000008F2: 17790000248e0143  move.b $248e.l, $143(a3)
        move.b (H005+$248E).l, $143(a3)
L064_000008FA:
; H064+$000008FA: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_000008FE:
; H064+$000008FE: 42ab018e  clr.l $18e(a3)
        clr.l $18e(a3)
L064_00000902:
; H064+$00000902: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000906:
; H064+$00000906: 42ab00e8  clr.l $e8(a3)
        clr.l $e8(a3)
L064_0000090A:
; H064+$0000090A: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_0000090E:
; H064+$0000090E: 42ab0150  clr.l $150(a3)
        clr.l $150(a3)
L064_00000912:
; H064+$00000912: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L064_00000916:
; H064+$00000916: 486cffa7  pea.l -$59(a4)
        pea.l -$59(a4)
L064_0000091A:
; H064+$0000091A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L064_0000091E:
; H064+$0000091E: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L064_00000924:
; H064+$00000924: 4aadfe2e  tst.l -$1d2(a5)
        tst.l -$1d2(a5)
L064_00000928:
; H064+$00000928: 670000ac  beq.w $9d6
        beq.w H064+$9D6
L064_0000092C:
; H064+$0000092C: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000930:
; H064+$00000930: 4aab0150  tst.l $150(a3)
        tst.l $150(a3)
L064_00000934:
; H064+$00000934: 66000046  bne.w $97c
        bne.w H064+$97C
L064_00000938:
; H064+$00000938: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_0000093C:
; H064+$0000093C: 266a0150  movea.l $150(a2), a3
        movea.l $150(a2), a3
L064_00000940:
; H064+$00000940: 7448  moveq #$48, d2
        moveq #72, d2
L064_00000942:
; H064+$00000942: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L064_00000944:
; H064+$00000944: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L064_0000094A:
; H064+$0000094A: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L064_00000950:
; H064+$00000950: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000954:
; H064+$00000954: 27400150  move.l d0, $150(a3)
        move.l d0, $150(a3)
L064_00000958:
; H064+$00000958: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_0000095C:
; H064+$0000095C: 266a0150  movea.l $150(a2), a3
        movea.l $150(a2), a3
L064_00000960:
; H064+$00000960: 246dfe2e  movea.l -$1d2(a5), a2
        movea.l -$1d2(a5), a2
L064_00000964:
; H064+$00000964: 7411  moveq #$11, d2
        moveq #17, d2
L064_00000966:
; H064+$00000966: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L064_00000968:
; H064+$00000968: 51cafffc  dbra d2, $966
        dbra d2, H064+$966
L064_0000096C:
; H064+$0000096C: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_00000970:
; H064+$00000970: 266a0150  movea.l $150(a2), a3
        movea.l $150(a2), a3
L064_00000974:
; H064+$00000974: 42ab002c  clr.l $2c(a3)
        clr.l $2c(a3)
L064_00000978:
; H064+$00000978: 6000004e  bra.w $9c8
        bra.w H064+$9C8
L064_0000097C:
; H064+$0000097C: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000980:
; H064+$00000980: 2b6b0150fe2a  move.l $150(a3), -$1d6(a5)
        move.l $150(a3), -$1d6(a5)
L064_00000986:
; H064+$00000986: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_0000098A:
; H064+$0000098A: 266a0150  movea.l $150(a2), a3
        movea.l $150(a2), a3
L064_0000098E:
; H064+$0000098E: 7448  moveq #$48, d2
        moveq #72, d2
L064_00000990:
; H064+$00000990: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L064_00000992:
; H064+$00000992: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L064_00000998:
; H064+$00000998: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L064_0000099E:
; H064+$0000099E: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_000009A2:
; H064+$000009A2: 27400150  move.l d0, $150(a3)
        move.l d0, $150(a3)
L064_000009A6:
; H064+$000009A6: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_000009AA:
; H064+$000009AA: 266a0150  movea.l $150(a2), a3
        movea.l $150(a2), a3
L064_000009AE:
; H064+$000009AE: 246dfe2e  movea.l -$1d2(a5), a2
        movea.l -$1d2(a5), a2
L064_000009B2:
; H064+$000009B2: 7411  moveq #$11, d2
        moveq #17, d2
L064_000009B4:
; H064+$000009B4: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L064_000009B6:
; H064+$000009B6: 51cafffc  dbra d2, $9b4
        dbra d2, H064+$9B4
L064_000009BA:
; H064+$000009BA: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_000009BE:
; H064+$000009BE: 266a0150  movea.l $150(a2), a3
        movea.l $150(a2), a3
L064_000009C2:
; H064+$000009C2: 276dfe2a002c  move.l -$1d6(a5), $2c(a3)
        move.l -$1d6(a5), $2c(a3)
L064_000009C8:
; H064+$000009C8: 266dfe2e  movea.l -$1d2(a5), a3
        movea.l -$1d2(a5), a3
L064_000009CC:
; H064+$000009CC: 2b6b002cfe2e  move.l $2c(a3), -$1d2(a5)
        move.l $2c(a3), -$1d2(a5)
L064_000009D2:
; H064+$000009D2: 6000ff50  bra.w $924
        bra.w H064+$924
L064_000009D6:
; H064+$000009D6: 2b6dfe26fe2e  move.l -$1da(a5), -$1d2(a5)
        move.l -$1da(a5), -$1d2(a5)
L064_000009DC:
; H064+$000009DC: 4aadfe22  tst.l -$1de(a5)
        tst.l -$1de(a5)
L064_000009E0:
; H064+$000009E0: 670000ac  beq.w $a8e
        beq.w H064+$A8E
L064_000009E4:
; H064+$000009E4: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_000009E8:
; H064+$000009E8: 4aab00e8  tst.l $e8(a3)
        tst.l $e8(a3)
L064_000009EC:
; H064+$000009EC: 66000046  bne.w $a34
        bne.w H064+$A34
L064_000009F0:
; H064+$000009F0: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_000009F4:
; H064+$000009F4: 266a00e8  movea.l $e8(a2), a3
        movea.l $e8(a2), a3
L064_000009F8:
; H064+$000009F8: 740a  moveq #$a, d2
        moveq #10, d2
L064_000009FA:
; H064+$000009FA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L064_000009FC:
; H064+$000009FC: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L064_00000A02:
; H064+$00000A02: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L064_00000A08:
; H064+$00000A08: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000A0C:
; H064+$00000A0C: 274000e8  move.l d0, $e8(a3)
        move.l d0, $e8(a3)
L064_00000A10:
; H064+$00000A10: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_00000A14:
; H064+$00000A14: 266a00e8  movea.l $e8(a2), a3
        movea.l $e8(a2), a3
L064_00000A18:
; H064+$00000A18: 246dfe22  movea.l -$1de(a5), a2
        movea.l -$1de(a5), a2
L064_00000A1C:
; H064+$00000A1C: 7404  moveq #$4, d2
        moveq #4, d2
L064_00000A1E:
; H064+$00000A1E: 36da  move.w (a2)+, (a3)+
        move.w (a2)+, (a3)+
L064_00000A20:
; H064+$00000A20: 51cafffc  dbra d2, $a1e
        dbra d2, H064+$A1E
L064_00000A24:
; H064+$00000A24: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_00000A28:
; H064+$00000A28: 266a00e8  movea.l $e8(a2), a3
        movea.l $e8(a2), a3
L064_00000A2C:
; H064+$00000A2C: 42ab0006  clr.l $6(a3)
        clr.l $6(a3)
L064_00000A30:
; H064+$00000A30: 6000004e  bra.w $a80
        bra.w H064+$A80
L064_00000A34:
; H064+$00000A34: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000A38:
; H064+$00000A38: 2b6b00e8fe1e  move.l $e8(a3), -$1e2(a5)
        move.l $e8(a3), -$1e2(a5)
L064_00000A3E:
; H064+$00000A3E: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_00000A42:
; H064+$00000A42: 266a00e8  movea.l $e8(a2), a3
        movea.l $e8(a2), a3
L064_00000A46:
; H064+$00000A46: 740a  moveq #$a, d2
        moveq #10, d2
L064_00000A48:
; H064+$00000A48: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L064_00000A4A:
; H064+$00000A4A: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L064_00000A50:
; H064+$00000A50: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L064_00000A56:
; H064+$00000A56: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L064_00000A5A:
; H064+$00000A5A: 274000e8  move.l d0, $e8(a3)
        move.l d0, $e8(a3)
L064_00000A5E:
; H064+$00000A5E: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_00000A62:
; H064+$00000A62: 266a00e8  movea.l $e8(a2), a3
        movea.l $e8(a2), a3
L064_00000A66:
; H064+$00000A66: 246dfe22  movea.l -$1de(a5), a2
        movea.l -$1de(a5), a2
L064_00000A6A:
; H064+$00000A6A: 7404  moveq #$4, d2
        moveq #4, d2
L064_00000A6C:
; H064+$00000A6C: 36da  move.w (a2)+, (a3)+
        move.w (a2)+, (a3)+
L064_00000A6E:
; H064+$00000A6E: 51cafffc  dbra d2, $a6c
        dbra d2, H064+$A6C
L064_00000A72:
; H064+$00000A72: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L064_00000A76:
; H064+$00000A76: 266a00e8  movea.l $e8(a2), a3
        movea.l $e8(a2), a3
L064_00000A7A:
; H064+$00000A7A: 276dfe1e0006  move.l -$1e2(a5), $6(a3)
        move.l -$1e2(a5), $6(a3)
L064_00000A80:
; H064+$00000A80: 266dfe22  movea.l -$1de(a5), a3
        movea.l -$1de(a5), a3
L064_00000A84:
; H064+$00000A84: 2b6b0006fe22  move.l $6(a3), -$1de(a5)
        move.l $6(a3), -$1de(a5)
L064_00000A8A:
; H064+$00000A8A: 6000ff50  bra.w $9dc
        bra.w H064+$9DC
L064_00000A8E:
; H064+$00000A8E: 2b6dfe1afe22  move.l -$1e6(a5), -$1de(a5)
        move.l -$1e6(a5), -$1de(a5)
L064_00000A94:
; H064+$00000A94: 6000fdfc  bra.w $892
        bra.w H064+$892
L064_00000A98:
; H064+$00000A98: 48790000248e  pea.l $248e.l
        pea.l (H005+$248E).l
L064_00000A9E:
; H064+$00000A9E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L064_00000AA2:
; H064+$00000AA2: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L064_00000AA8:
; H064+$00000AA8: 13fc0001000024b6  move.b #$1, $24b6.l
        move.b #$1, (H005+$24B6).l
; STATO: H005+$3368 = personaggio corrente
L064_00000AB0:
; H064+$00000AB0: 23edffea00003368  move.l -$16(a5), $3368.l
        move.l -$16(a5), (H005+$3368).l
L064_00000AB8:
; H064+$00000AB8: 4e5d  unlk a5
        unlk a5
L064_00000ABA:
; H064+$00000ABA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000ABC:
; H064+$00000ABC: 4e75  rts 
        rts 
; FUNCTION: ECL_13_APPROACH
FN_ECL_13_APPROACH:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_13 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 13=APPROACH.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E58
; --------------------------------------------------------------------------
L064_00000ABE:
; H064+$00000ABE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000AC0:
; H064+$00000AC0: 287af628  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000AC4:
; H064+$00000AC4: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000AC8:
; H064+$00000AC8: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000ACE:
; H064+$00000ACE: 4a6b0582  tst.w $582(a3)
        tst.w $582(a3)
L064_00000AD2:
; H064+$00000AD2: 63000030  bls.w $b04
        bls.w H064+$B04
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000AD6:
; H064+$00000AD6: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000ADC:
; H064+$00000ADC: 536b0582  subq.w #$1, $582(a3)
        subq.w #$1, $582(a3)
L064_00000AE0:
; H064+$00000AE0: 1f3900002491  move.b $2491.l, -(a7)
        move.b (H005+$2491).l, -(a7)
L064_00000AE6:
; H064+$00000AE6: 1f3900002490  move.b $2490.l, -(a7)
        move.b (H005+$2490).l, -(a7)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000AEC:
; H064+$00000AEC: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000AF2:
; H064+$00000AF2: 342b0582  move.w $582(a3), d2
        move.w $582(a3), d2
L064_00000AF6:
; H064+$00000AF6: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L064_00000AF8:
; H064+$00000AF8: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
; -> H061+$1D6E (sub_H061_00001D6E)
L064_00000AFE:
; H064+$00000AFE: 4eb900001d6e  jsr $1d6e.l
        jsr (H061+$1D6E).l
; STATO: H005+$3DEA = PC logico ECL
L064_00000B04:
; H064+$00000B04: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L064_00000B0A:
; H064+$00000B0A: 4e5d  unlk a5
        unlk a5
L064_00000B0C:
; H064+$00000B0C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000B0E:
; H064+$00000B0E: 4e75  rts 
        rts 
; FUNCTION: ECL_14_PICTURE
FN_ECL_14_PICTURE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_14 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 14=PICTURE.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E60
; --------------------------------------------------------------------------
L064_00000B10:
; H064+$00000B10: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000B12:
; H064+$00000B12: 287af5d6  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000B16:
; H064+$00000B16: 4e55ffac  link.w a5, #$ffac
        link.w a5, #$ffac
L064_00000B1A:
; H064+$00000B1A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000B1E:
; H064+$00000B1E: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000B24:
; H064+$00000B24: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00000B28:
; H064+$00000B28: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000B2E:
; H064+$00000B2E: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L064_00000B32:
; H064+$00000B32: 0c6d00fffffe  cmpi.w #$ff, -$2(a5)
        cmpi.w #$ff, -$2(a5)
L064_00000B38:
; H064+$00000B38: 670000c8  beq.w $c02
        beq.w H064+$C02
L064_00000B3C:
; H064+$00000B3C: 13fc000100002379  move.b #$1, $2379.l
        move.b #$1, (H005+$2379).l
L064_00000B44:
; H064+$00000B44: 13fc0001000024bd  move.b #$1, $24bd.l
        move.b #$1, (H005+$24BD).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000B4C:
; H064+$00000B4C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000B52:
; H064+$00000B52: 0c6b00ff05c2  cmpi.w #$ff, $5c2(a3)
        cmpi.w #$ff, $5c2(a3)
L064_00000B58:
; H064+$00000B58: 66000090  bne.w $bea
        bne.w H064+$BEA
L064_00000B5C:
; H064+$00000B5C: 13fc0001000024bc  move.b #$1, $24bc.l
        move.b #$1, (H005+$24BC).l
L064_00000B64:
; H064+$00000B64: 0c6d0070fffe  cmpi.w #$70, -$2(a5)
        cmpi.w #$70, -$2(a5)
L064_00000B6A:
; H064+$00000B6A: 65000038  bcs.w $ba4
        bcs.w H064+$BA4
L064_00000B6E:
; H064+$00000B6E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama Load_BigPicture (H042+$1006).
L064_00000B72:
; H064+$00000B72: 4eb900001006  jsr $1006.l
        jsr (H042+$1006).l
; -> H042+$10DC (sub_H042_000010DC)
L064_00000B78:
; H064+$00000B78: 4eb9000010dc  jsr $10dc.l
        jsr (H042+$10DC).l
L064_00000B7E:
; H064+$00000B7E: 0c6d0079fffe  cmpi.w #$79, -$2(a5)
        cmpi.w #$79, -$2(a5)
L064_00000B84:
; H064+$00000B84: 6600000c  bne.w $b92
        bne.w H064+$B92
; -> H069+$0012 (sub_H069_00000012)
L064_00000B88:
; H064+$00000B88: 4eb900000012  jsr $12.l
        jsr (H069+$12).l
L064_00000B8E:
; H064+$00000B8E: 6000000a  bra.w $b9a
        bra.w H064+$B9A
L064_00000B92:
; H064+$00000B92: 13fc0001000024ae  move.b #$1, $24ae.l
        move.b #$1, (H005+$24AE).l
L064_00000B9A:
; H064+$00000B9A: 4239000024e1  clr.b $24e1.l
        clr.b (H005+$24E1).l
L064_00000BA0:
; H064+$00000BA0: 60000044  bra.w $be6
        bra.w H064+$BE6
L064_00000BA4:
; H064+$00000BA4: 47ec002c  lea.l $2c(a4), a3
        lea.l $2c(a4), a3
L064_00000BA8:
; H064+$00000BA8: 45edffac  lea.l -$54(a5), a2
        lea.l -$54(a5), a2
L064_00000BAC:
; H064+$00000BAC: 7450  moveq #$50, d2
        moveq #80, d2
L064_00000BAE:
; H064+$00000BAE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00000BB0:
; H064+$00000BB0: 57cafffc  dbeq d2, $bae
        dbeq d2, H064+$BAE
L064_00000BB4:
; H064+$00000BB4: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L064_00000BB8:
; H064+$00000BB8: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L064_00000BBC:
; H064+$00000BBC: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L064_00000BC0:
; H064+$00000BC0: 4267  clr.w -(a7)
        clr.w -(a7)
L064_00000BC2:
; H064+$00000BC2: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLUSSO: Chiama Load_Sequence (H042+$0406).
L064_00000BC8:
; H064+$00000BC8: 4eb900000406  jsr $406.l
        jsr (H042+$406).l
L064_00000BCE:
; H064+$00000BCE: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L064_00000BD2:
; H064+$00000BD2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L064_00000BD6:
; H064+$00000BD6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L064_00000BDA:
; H064+$00000BDA: 2f39000027c2  move.l $27c2.l, -(a7)
        move.l (H005+$27C2).l, -(a7)
; -> H042+$0254 (sub_H042_00000254)
L064_00000BE0:
; H064+$00000BE0: 4eb900000254  jsr $254.l
        jsr (H042+$254).l
L064_00000BE6:
; H064+$00000BE6: 60000016  bra.w $bfe
        bra.w H064+$BFE
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_00000BEA:
; H064+$00000BEA: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_00000BF0:
; H064+$00000BF0: 3f2b05c2  move.w $5c2(a3), -(a7)
        move.w $5c2(a3), -(a7)
L064_00000BF4:
; H064+$00000BF4: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; -> H061+$1D20 (sub_H061_00001D20)
L064_00000BF8:
; H064+$00000BF8: 4eb900001d20  jsr $1d20.l
        jsr (H061+$1D20).l
L064_00000BFE:
; H064+$00000BFE: 6000005c  bra.w $c5c
        bra.w H064+$C5C
L064_00000C02:
; H064+$00000C02: 0c39000400003de2  cmpi.b #$4, $3de2.l
        cmpi.b #$4, (H005+$3DE2).l
L064_00000C0A:
; H064+$00000C0A: 6600000e  bne.w $c1a
        bne.w H064+$C1A
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L064_00000C0E:
; H064+$00000C0E: 0c39000400003de3  cmpi.b #$4, $3de3.l
        cmpi.b #$4, (H005+$3DE3).l
L064_00000C16:
; H064+$00000C16: 66000038  bne.w $c50
        bne.w H064+$C50
L064_00000C1A:
; H064+$00000C1A: 4a39000024bd  tst.b $24bd.l
        tst.b (H005+$24BD).l
L064_00000C20:
; H064+$00000C20: 6600000c  bne.w $c2e
        bne.w H064+$C2E
L064_00000C24:
; H064+$00000C24: 4a39000024ba  tst.b $24ba.l
        tst.b (H005+$24BA).l
L064_00000C2A:
; H064+$00000C2A: 67000024  beq.w $c50
        beq.w H064+$C50
L064_00000C2E:
; H064+$00000C2E: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
; -> H060+$0018 (sub_H060_00000018)
L064_00000C36:
; H064+$00000C36: 4eb900000018  jsr $18.l
        jsr (H060+$18).l
L064_00000C3C:
; H064+$00000C3C: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
L064_00000C42:
; H064+$00000C42: 4239000024ba  clr.b $24ba.l
        clr.b (H005+$24BA).l
L064_00000C48:
; H064+$00000C48: 13fc0001000024bc  move.b #$1, $24bc.l
        move.b #$1, (H005+$24BC).l
L064_00000C50:
; H064+$00000C50: 423900002378  clr.b $2378.l
        clr.b (H005+$2378).l
L064_00000C56:
; H064+$00000C56: 423900002379  clr.b $2379.l
        clr.b (H005+$2379).l
L064_00000C5C:
; H064+$00000C5C: 4e5d  unlk a5
        unlk a5
L064_00000C5E:
; H064+$00000C5E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000C60:
; H064+$00000C60: 4e75  rts 
        rts 
; FUNCTION: ECL_15_INPUT_NUMBER
FN_ECL_15_INPUT_NUMBER:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_15 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 15=INPUT NUMBER.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E68
; --------------------------------------------------------------------------
L064_00000C62:
; H064+$00000C62: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000C64:
; H064+$00000C64: 287af484  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000C68:
; H064+$00000C68: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L064_00000C6C:
; H064+$00000C6C: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000C70:
; H064+$00000C70: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000C76:
; H064+$00000C76: 47ec0030  lea.l $30(a4), a3
        lea.l $30(a4), a3
L064_00000C7A:
; H064+$00000C7A: 45edfffe  lea.l -$2(a5), a2
        lea.l -$2(a5), a2
L064_00000C7E:
; H064+$00000C7E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00000C80:
; H064+$00000C80: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00000C82:
; H064+$00000C82: 1f3900001453  move.b $1453.l, -(a7)
        move.b (H061+$1453).l, -(a7)
L064_00000C88:
; H064+$00000C88: 1f3900001493  move.b $1493.l, -(a7)
        move.b (H061+$1493).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00000C8E:
; H064+$00000C8E: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_00000C94:
; H064+$00000C94: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L064_00000C98:
; H064+$00000C98: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_00000C9C:
; H064+$00000C9C: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L064_00000CA0:
; H064+$00000CA0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L064_00000CA4:
; H064+$00000CA4: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H030+$09A6 (sub_H030_000009A6)
L064_00000CA6:
; H064+$00000CA6: 4eb9000009a6  jsr $9a6.l
        jsr (H030+$9A6).l
L064_00000CAC:
; H064+$00000CAC: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_00000CB0:
; H064+$00000CB0: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L064_00000CB4:
; H064+$00000CB4: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_00000CB8:
; H064+$00000CB8: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_00000CBE:
; H064+$00000CBE: 4e5d  unlk a5
        unlk a5
L064_00000CC0:
; H064+$00000CC0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000CC2:
; H064+$00000CC2: 4e75  rts 
        rts 
; FUNCTION: ECL_16_INPUT_STRING
FN_ECL_16_INPUT_STRING:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_16 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 16=INPUT STRING.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E70
; --------------------------------------------------------------------------
L064_00000CC4:
; H064+$00000CC4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000CC6:
; H064+$00000CC6: 287af422  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000CCA:
; H064+$00000CCA: 4e55ffaa  link.w a5, #$ffaa
        link.w a5, #$ffaa
L064_00000CCE:
; H064+$00000CCE: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000CD2:
; H064+$00000CD2: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000CD8:
; H064+$00000CD8: 47ec0032  lea.l $32(a4), a3
        lea.l $32(a4), a3
L064_00000CDC:
; H064+$00000CDC: 45edfffe  lea.l -$2(a5), a2
        lea.l -$2(a5), a2
L064_00000CE0:
; H064+$00000CE0: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00000CE2:
; H064+$00000CE2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00000CE4:
; H064+$00000CE4: 1f3900001453  move.b $1453.l, -(a7)
        move.b (H061+$1453).l, -(a7)
L064_00000CEA:
; H064+$00000CEA: 1f3900001493  move.b $1493.l, -(a7)
        move.b (H061+$1493).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00000CF0:
; H064+$00000CF0: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_00000CF6:
; H064+$00000CF6: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_00000CFA:
; H064+$00000CFA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_00000CFE:
; H064+$00000CFE: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L064_00000D02:
; H064+$00000D02: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L064_00000D06:
; H064+$00000D06: 4267  clr.w -(a7)
        clr.w -(a7)
L064_00000D08:
; H064+$00000D08: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L064_00000D0C:
; H064+$00000D0C: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L064_00000D10:
; H064+$00000D10: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
; -> H030+$0718 (sub_H030_00000718)
L064_00000D14:
; H064+$00000D14: 4eb900000718  jsr $718.l
        jsr (H030+$718).l
L064_00000D1A:
; H064+$00000D1A: 4a2dffaa  tst.b -$56(a5)
        tst.b -$56(a5)
L064_00000D1E:
; H064+$00000D1E: 66000012  bne.w $d32
        bne.w H064+$D32
L064_00000D22:
; H064+$00000D22: 47ec0034  lea.l $34(a4), a3
        lea.l $34(a4), a3
L064_00000D26:
; H064+$00000D26: 45edffaa  lea.l -$56(a5), a2
        lea.l -$56(a5), a2
L064_00000D2A:
; H064+$00000D2A: 7450  moveq #$50, d2
        moveq #80, d2
L064_00000D2C:
; H064+$00000D2C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00000D2E:
; H064+$00000D2E: 57cafffc  dbeq d2, $d2c
        dbeq d2, H064+$D2C
L064_00000D32:
; H064+$00000D32: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L064_00000D36:
; H064+$00000D36: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L064_00000D3A:
; H064+$00000D3A: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
; -> H061+$3012 (sub_H061_00003012)
L064_00000D3E:
; H064+$00000D3E: 4eb900003012  jsr $3012.l
        jsr (H061+$3012).l
L064_00000D44:
; H064+$00000D44: 4e5d  unlk a5
        unlk a5
L064_00000D46:
; H064+$00000D46: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000D48:
; H064+$00000D48: 4e75  rts 
        rts 
; FUNCTION: ECL_17_PRINT__18_PRINTCLEAR
FN_ECL_17_PRINT__18_PRINTCLEAR:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_17 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 17=PRINT, 18=PRINTCLEAR.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E78
; --------------------------------------------------------------------------
L064_00000D4A:
; H064+$00000D4A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000D4C:
; H064+$00000D4C: 287af39c  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000D50:
; H064+$00000D50: 4e550000  link.w a5, #$0
        link.w a5, #$0
L064_00000D54:
; H064+$00000D54: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000D58:
; H064+$00000D58: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000D5E:
; H064+$00000D5E: 4239000024b9  clr.b $24b9.l
        clr.b (H005+$24B9).l
L064_00000D64:
; H064+$00000D64: 13fc0001000024ce  move.b #$1, $24ce.l
        move.b #$1, (H005+$24CE).l
L064_00000D6C:
; H064+$00000D6C: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000D6E:
; H064+$00000D6E: 1439000014d2  move.b $14d2.l, d2
        move.b (H061+$14D2).l, d2
L064_00000D74:
; H064+$00000D74: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L064_00000D78:
; H064+$00000D78: 64000044  bcc.w $dbe
        bcc.w H064+$DBE
L064_00000D7C:
; H064+$00000D7C: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_00000D80:
; H064+$00000D80: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
L064_00000D86:
; H064+$00000D86: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00000D8A:
; H064+$00000D8A: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000D90:
; H064+$00000D90: 3400  move.w d0, d2
        move.w d0, d2
L064_00000D92:
; H064+$00000D92: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L064_00000D98:
; H064+$00000D98: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L064_00000D9A:
; H064+$00000D9A: 4227  clr.b -(a7)
        clr.b -(a7)
L064_00000D9C:
; H064+$00000D9C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L064_00000DA0:
; H064+$00000DA0: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L064_00000DA4:
; H064+$00000DA4: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L064_00000DA8:
; H064+$00000DA8: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L064_00000DAE:
; H064+$00000DAE: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_00000DB2:
; H064+$00000DB2: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
; -> H063+$0112 (sub_H063_00000112)
L064_00000DB8:
; H064+$00000DB8: 4eb900000112  jsr $112.l
        jsr (H063+$112).l
L064_00000DBE:
; H064+$00000DBE: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$2493 = opcode ECL corrente
L064_00000DC0:
; H064+$00000DC0: 143900002493  move.b $2493.l, d2
        move.b (H005+$2493).l, d2
L064_00000DC6:
; H064+$00000DC6: 0c420011  cmpi.w #$11, d2
        cmpi.w #$11, d2
L064_00000DCA:
; H064+$00000DCA: 6600002e  bne.w $dfa
        bne.w H064+$DFA
L064_00000DCE:
; H064+$00000DCE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_00000DD2:
; H064+$00000DD2: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L064_00000DD6:
; H064+$00000DD6: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L064_00000DDA:
; H064+$00000DDA: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L064_00000DDE:
; H064+$00000DDE: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L064_00000DE2:
; H064+$00000DE2: 4267  clr.w -(a7)
        clr.w -(a7)
L064_00000DE4:
; H064+$00000DE4: 4227  clr.b -(a7)
        clr.b -(a7)
L064_00000DE6:
; H064+$00000DE6: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_00000DEA:
; H064+$00000DEA: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
; -> H030+$0302 (trampoline_H030_0470)
L064_00000DF0:
; H064+$00000DF0: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L064_00000DF6:
; H064+$00000DF6: 6000003c  bra.w $e34
        bra.w H064+$E34
L064_00000DFA:
; H064+$00000DFA: 33fc00110000334c  move.w #$11, $334c.l
        move.w #$11, (H005+$334C).l
L064_00000E02:
; H064+$00000E02: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L064_00000E0A:
; H064+$00000E0A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_00000E0E:
; H064+$00000E0E: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L064_00000E12:
; H064+$00000E12: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L064_00000E16:
; H064+$00000E16: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L064_00000E1A:
; H064+$00000E1A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L064_00000E1E:
; H064+$00000E1E: 4267  clr.w -(a7)
        clr.w -(a7)
L064_00000E20:
; H064+$00000E20: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L064_00000E24:
; H064+$00000E24: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_00000E28:
; H064+$00000E28: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
; -> H030+$0302 (trampoline_H030_0470)
L064_00000E2E:
; H064+$00000E2E: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L064_00000E34:
; H064+$00000E34: 4239000024ce  clr.b $24ce.l
        clr.b (H005+$24CE).l
L064_00000E3A:
; H064+$00000E3A: 4e5d  unlk a5
        unlk a5
L064_00000E3C:
; H064+$00000E3C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000E3E:
; H064+$00000E3E: 4e75  rts 
        rts 
; FUNCTION: ECL_19_RETURN
FN_ECL_19_RETURN:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_RETURN [verificato]
; Scopo: Ripristina un indirizzo di ritorno dal piccolo stack collegato dell’ECL.
;   - Se esiste un nodo in H005+$2388, ne legge la word PC e il link long a +2.
;   - Libera il nodo di 6 byte e aggiorna la testa della lista.
;   - Se lo stack è vuoto richiama il percorso EXIT della VM.
; Chiamanti diretti: H012+$2E80
; --------------------------------------------------------------------------
L064_00000E40:
; H064+$00000E40: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000E42:
; H064+$00000E42: 287af2a6  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000E46:
; H064+$00000E46: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATO: H005+$3DEA = PC logico ECL
L064_00000E4A:
; H064+$00000E4A: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L064_00000E50:
; H064+$00000E50: 4ab900002388  tst.l $2388.l
        tst.l (H005+$2388).l
L064_00000E56:
; H064+$00000E56: 6700003a  beq.w $e92
        beq.w H064+$E92
L064_00000E5A:
; H064+$00000E5A: 267900002388  movea.l $2388.l, a3
        movea.l (H005+$2388).l, a3
; STATO: H005+$3DEA = PC logico ECL
L064_00000E60:
; H064+$00000E60: 33d300003dea  move.w (a3), $3dea.l
        move.w (a3), (H005+$3DEA).l
L064_00000E66:
; H064+$00000E66: 267900002388  movea.l $2388.l, a3
        movea.l (H005+$2388).l, a3
L064_00000E6C:
; H064+$00000E6C: 23eb000200002384  move.l $2(a3), $2384.l
        move.l $2(a3), (H005+$2384).l
L064_00000E74:
; H064+$00000E74: 2f3900002388  move.l $2388.l, -(a7)
        move.l (H005+$2388).l, -(a7)
L064_00000E7A:
; H064+$00000E7A: 7406  moveq #$6, d2
        moveq #6, d2
L064_00000E7C:
; H064+$00000E7C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L064_00000E7E:
; H064+$00000E7E: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L064_00000E84:
; H064+$00000E84: 23f90000238400002388  move.l $2384.l, $2388.l
        move.l (H005+$2384).l, (H005+$2388).l
L064_00000E8E:
; H064+$00000E8E: 60000006  bra.w $e96
        bra.w H064+$E96
; FLUSSO: Chiama ECL_Handler_0 (H064+$0156).
L064_00000E92:
; H064+$00000E92: 6100f2c2  bsr.w $156
        bsr.w H064+$156
L064_00000E96:
; H064+$00000E96: 4e5d  unlk a5
        unlk a5
L064_00000E98:
; H064+$00000E98: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000E9A:
; H064+$00000E9A: 4e75  rts 
        rts 
; FUNCTION: ECL_20_COMPARE_AND
FN_ECL_20_COMPARE_AND:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_20 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 20=COMPARE AND.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E88
; --------------------------------------------------------------------------
L064_00000E9C:
; H064+$00000E9C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000E9E:
; H064+$00000E9E: 287af24a  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000EA2:
; H064+$00000EA2: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L064_00000EA6:
; H064+$00000EA6: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L064_00000EAA:
; H064+$00000EAA: 48790000237e  pea.l $237e.l
        pea.l (H005+$237E).l
L064_00000EB0:
; H064+$00000EB0: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L064_00000EB4:
; H064+$00000EB4: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L064_00000EB6:
; H064+$00000EB6: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L064_00000EBC:
; H064+$00000EBC: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000EC0:
; H064+$00000EC0: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000EC6:
; H064+$00000EC6: 3b7c0001fff6  move.w #$1, -$a(a5)
        move.w #$1, -$a(a5)
L064_00000ECC:
; H064+$00000ECC: 0c6d0004fff6  cmpi.w #$4, -$a(a5)
        cmpi.w #$4, -$a(a5)
L064_00000ED2:
; H064+$00000ED2: 6200002a  bhi.w $efe
        bhi.w H064+$EFE
L064_00000ED6:
; H064+$00000ED6: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L064_00000EDA:
; H064+$00000EDA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_00000EDC:
; H064+$00000EDC: e342  asl.w #$1, d2
        asl.w #$1, d2
L064_00000EDE:
; H064+$00000EDE: 47edfff8  lea.l -$8(a5), a3
        lea.l -$8(a5), a3
L064_00000EE2:
; H064+$00000EE2: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L064_00000EE6:
; H064+$00000EE6: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00000EEA:
; H064+$00000EEA: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000EF0:
; H064+$00000EF0: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L064_00000EF4:
; H064+$00000EF4: 37802000  move.w d0, (a3, d2.w)
        move.w d0, (a3, d2.w)
L064_00000EF8:
; H064+$00000EF8: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L064_00000EFC:
; H064+$00000EFC: 64ce  bcc.b $ecc
        bcc.b H064+$ECC
L064_00000EFE:
; H064+$00000EFE: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L064_00000F02:
; H064+$00000F02: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L064_00000F06:
; H064+$00000F06: 6600001a  bne.w $f22
        bne.w H064+$F22
L064_00000F0A:
; H064+$00000F0A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L064_00000F0E:
; H064+$00000F0E: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L064_00000F12:
; H064+$00000F12: 6600000e  bne.w $f22
        bne.w H064+$F22
L064_00000F16:
; H064+$00000F16: 13fc00010000237e  move.b #$1, $237e.l
        move.b #$1, (H005+$237E).l
L064_00000F1E:
; H064+$00000F1E: 6000000a  bra.w $f2a
        bra.w H064+$F2A
L064_00000F22:
; H064+$00000F22: 13fc00010000237f  move.b #$1, $237f.l
        move.b #$1, (H005+$237F).l
L064_00000F2A:
; H064+$00000F2A: 4e5d  unlk a5
        unlk a5
L064_00000F2C:
; H064+$00000F2C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000F2E:
; H064+$00000F2E: 4e75  rts 
        rts 
; FUNCTION: ECL_22_IF__23_IF__24_IF__25_IF__26_IF__27_IF
FN_ECL_22_IF__23_IF__24_IF__25_IF__26_IF__27_IF:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_22 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 22=IF = , 23=IF <>, 24=IF <, 25=IF >, 26=IF <=, 27=IF >=.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E98
; --------------------------------------------------------------------------
L064_00000F30:
; H064+$00000F30: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000F32:
; H064+$00000F32: 287af1b6  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000F36:
; H064+$00000F36: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
; STATO: H005+$3DEA = PC logico ECL
L064_00000F3A:
; H064+$00000F3A: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L064_00000F40:
; H064+$00000F40: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L064_00000F46:
; H064+$00000F46: 0c6d0006fffe  cmpi.w #$6, -$2(a5)
        cmpi.w #$6, -$2(a5)
L064_00000F4C:
; H064+$00000F4C: 6200003c  bhi.w $f8a
        bhi.w H064+$F8A
L064_00000F50:
; H064+$00000F50: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$2493 = opcode ECL corrente
L064_00000F52:
; H064+$00000F52: 143900002493  move.b $2493.l, d2
        move.b (H005+$2493).l, d2
L064_00000F58:
; H064+$00000F58: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L064_00000F5C:
; H064+$00000F5C: 06440015  addi.w #$15, d4
        addi.w #$15, d4
L064_00000F60:
; H064+$00000F60: b444  cmp.w d4, d2
        cmp.w d4, d2
L064_00000F62:
; H064+$00000F62: 66000020  bne.w $f84
        bne.w H064+$F84
L064_00000F66:
; H064+$00000F66: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L064_00000F6A:
; H064+$00000F6A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_00000F6C:
; H064+$00000F6C: 47f90000237e  lea.l $237e.l, a3
        lea.l (H005+$237E).l, a3
L064_00000F72:
; H064+$00000F72: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L064_00000F76:
; H064+$00000F76: 6600000c  bne.w $f84
        bne.w H064+$F84
; FLUSSO: Chiama ECL_SkipInstruction (H061+$3E80).
L064_00000F7A:
; H064+$00000F7A: 4eb900003e80  jsr $3e80.l
        jsr (FN_ECL_skip_instruction).l
L064_00000F80:
; H064+$00000F80: 60000008  bra.w $f8a
        bra.w H064+$F8A
L064_00000F84:
; H064+$00000F84: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L064_00000F88:
; H064+$00000F88: 64bc  bcc.b $f46
        bcc.b H064+$F46
L064_00000F8A:
; H064+$00000F8A: 4e5d  unlk a5
        unlk a5
L064_00000F8C:
; H064+$00000F8C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00000F8E:
; H064+$00000F8E: 4e75  rts 
        rts 
; FUNCTION: ECL_32_NEWECL
FN_ECL_32_NEWECL:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_32 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 32=NEWECL.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2EB6
; --------------------------------------------------------------------------
L064_00000F90:
; H064+$00000F90: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00000F92:
; H064+$00000F92: 287af156  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00000F96:
; H064+$00000F96: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L064_00000F9A:
; H064+$00000F9A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00000F9E:
; H064+$00000F9E: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00000FA4:
; H064+$00000FA4: 7400  moveq #$0, d2
        moveq #0, d2
L064_00000FA6:
; H064+$00000FA6: 143900002498  move.b $2498.l, d2
        move.b (H005+$2498).l, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_00000FAC:
; H064+$00000FAC: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_00000FB2:
; H064+$00000FB2: 374201e4  move.w d2, $1e4(a3)
        move.w d2, $1e4(a3)
L064_00000FB6:
; H064+$00000FB6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00000FBA:
; H064+$00000FBA: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00000FC0:
; H064+$00000FC0: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L064_00000FC4:
; H064+$00000FC4: 13edffff00002498  move.b -$1(a5), $2498.l
        move.b -$1(a5), (H005+$2498).l
L064_00000FCC:
; H064+$00000FCC: 1f2dffff  move.b -$1(a5), -(a7)
        move.b -$1(a5), -(a7)
; FLUSSO: Chiama ECL_LoadProgram (H061+$1ACC).
L064_00000FD0:
; H064+$00000FD0: 4eb900001acc  jsr $1acc.l
        jsr (H061+$1ACC).l
; FLUSSO: Chiama ECL_ResetExecution (H061+$1928).
L064_00000FD6:
; H064+$00000FD6: 4eb900001928  jsr $1928.l
        jsr (H061+$1928).l
L064_00000FDC:
; H064+$00000FDC: 197c0001ffad  move.b #$1, -$53(a4)
        move.b #$1, -$53(a4)
L064_00000FE2:
; H064+$00000FE2: 197c0001ffac  move.b #$1, -$54(a4)
        move.b #$1, -$54(a4)
L064_00000FE8:
; H064+$00000FE8: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_00000FEC:
; H064+$00000FEC: 487900002378  pea.l $2378.l
        pea.l (H005+$2378).l
L064_00000FF2:
; H064+$00000FF2: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L064_00000FF6:
; H064+$00000FF6: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L064_00000FF8:
; H064+$00000FF8: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L064_00000FFE:
; H064+$00000FFE: 4e5d  unlk a5
        unlk a5
L064_00001000:
; H064+$00001000: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00001002:
; H064+$00001002: 4e75  rts 
        rts 
; FUNCTION: ECL_33_LOAD_FILES__55_LOAD_PIECES
FN_ECL_33_LOAD_FILES__55_LOAD_PIECES:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_LOAD_FILES_or_PIECES [verificato]
; Scopo: Carica risorse di mappa o parti delle pareti secondo l’opcode corrente.
;   - Legge tre operandi numerici.
;   - Per LOAD FILES può caricare una GEO tramite H011+$1876.
;   - Per LOAD PIECES aggiorna gli insiemi WALLDEF tramite H011+$14EA.
;   - I valori speciali $7F e $FF selezionano percorsi dedicati.
; Chiamanti diretti: H012+$2EBE
; --------------------------------------------------------------------------
L064_00001004:
; H064+$00001004: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00001006:
; H064+$00001006: 287af0e2  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000100A:
; H064+$0000100A: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L064_0000100E:
; H064+$0000100E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00001012:
; H064+$00001012: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00001018:
; H064+$00001018: 197c0001ffaa  move.b #$1, -$56(a4)
        move.b #$1, -$56(a4)
L064_0000101E:
; H064+$0000101E: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L064_00001024:
; H064+$00001024: 0c6d0003fff8  cmpi.w #$3, -$8(a5)
        cmpi.w #$3, -$8(a5)
L064_0000102A:
; H064+$0000102A: 6200002a  bhi.w $1056
        bhi.w H064+$1056
L064_0000102E:
; H064+$0000102E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L064_00001032:
; H064+$00001032: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_00001034:
; H064+$00001034: e342  asl.w #$1, d2
        asl.w #$1, d2
L064_00001036:
; H064+$00001036: 47edfffa  lea.l -$6(a5), a3
        lea.l -$6(a5), a3
L064_0000103A:
; H064+$0000103A: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L064_0000103E:
; H064+$0000103E: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00001042:
; H064+$00001042: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00001048:
; H064+$00001048: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L064_0000104C:
; H064+$0000104C: 37802000  move.w d0, (a3, d2.w)
        move.w d0, (a3, d2.w)
L064_00001050:
; H064+$00001050: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L064_00001054:
; H064+$00001054: 64ce  bcc.b $1024
        bcc.b H064+$1024
L064_00001056:
; H064+$00001056: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$2493 = opcode ECL corrente
L064_00001058:
; H064+$00001058: 143900002493  move.b $2493.l, d2
        move.b (H005+$2493).l, d2
L064_0000105E:
; H064+$0000105E: 0c420021  cmpi.w #$21, d2
        cmpi.w #$21, d2
L064_00001062:
; H064+$00001062: 6600004e  bne.w $10b2
        bne.w H064+$10B2
L064_00001066:
; H064+$00001066: 197c0001ffa8  move.b #$1, -$58(a4)
        move.b #$1, -$58(a4)
L064_0000106C:
; H064+$0000106C: 0c6d00fffffa  cmpi.w #$ff, -$6(a5)
        cmpi.w #$ff, -$6(a5)
L064_00001072:
; H064+$00001072: 6700003a  beq.w $10ae
        beq.w H064+$10AE
L064_00001076:
; H064+$00001076: 0c6d007ffffa  cmpi.w #$7f, -$6(a5)
        cmpi.w #$7f, -$6(a5)
L064_0000107C:
; H064+$0000107C: 67000030  beq.w $10ae
        beq.w H064+$10AE
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_00001080:
; H064+$00001080: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_00001086:
; H064+$00001086: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L064_0000108A:
; H064+$0000108A: 67000022  beq.w $10ae
        beq.w H064+$10AE
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_0000108E:
; H064+$0000108E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_00001094:
; H064+$00001094: 376dfffa018a  move.w -$6(a5), $18a(a3)
        move.w -$6(a5), $18a(a3)
L064_0000109A:
; H064+$0000109A: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; FLUSSO: Chiama Load3DMap_GEO (H011+$1876).
L064_0000109E:
; H064+$0000109E: 4eb900001876  jsr $1876.l
        jsr (H011+$1876).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L064_000010A4:
; H064+$000010A4: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L064_000010AA:
; H064+$000010AA: 426b0592  clr.w $592(a3)
        clr.w $592(a3)
L064_000010AE:
; H064+$000010AE: 60000116  bra.w $11c6
        bra.w H064+$11C6
L064_000010B2:
; H064+$000010B2: 197c0001ffa9  move.b #$1, -$57(a4)
        move.b #$1, -$57(a4)
L064_000010B8:
; H064+$000010B8: 0c6d007ffffa  cmpi.w #$7f, -$6(a5)
        cmpi.w #$7f, -$6(a5)
L064_000010BE:
; H064+$000010BE: 66000012  bne.w $10d2
        bne.w H064+$10D2
L064_000010C2:
; H064+$000010C2: 4267  clr.w -(a7)
        clr.w -(a7)
L064_000010C4:
; H064+$000010C4: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama Load_WallDefinitions (H011+$14EA).
L064_000010C8:
; H064+$000010C8: 4eb9000014ea  jsr $14ea.l
        jsr (H011+$14EA).l
L064_000010CE:
; H064+$000010CE: 600000f6  bra.w $11c6
        bra.w H064+$11C6
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_000010D2:
; H064+$000010D2: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_000010D8:
; H064+$000010D8: 4a6b01ce  tst.w $1ce(a3)
        tst.w $1ce(a3)
L064_000010DC:
; H064+$000010DC: 67000076  beq.w $1154
        beq.w H064+$1154
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L064_000010E0:
; H064+$000010E0: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L064_000010E6:
; H064+$000010E6: 4a6b01d0  tst.w $1d0(a3)
        tst.w $1d0(a3)
L064_000010EA:
; H064+$000010EA: 67000068  beq.w $1154
        beq.w H064+$1154
L064_000010EE:
; H064+$000010EE: 0c6d00fffffa  cmpi.w #$ff, -$6(a5)
        cmpi.w #$ff, -$6(a5)
L064_000010F4:
; H064+$000010F4: 67000014  beq.w $110a
        beq.w H064+$110A
L064_000010F8:
; H064+$000010F8: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L064_000010FC:
; H064+$000010FC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama Load_WallDefinitions (H011+$14EA).
L064_00001100:
; H064+$00001100: 4eb9000014ea  jsr $14ea.l
        jsr (H011+$14EA).l
L064_00001106:
; H064+$00001106: 60000012  bra.w $111a
        bra.w H064+$111A
; STATO: H005+$2810 = tre elementi di stato degli insiemi pareti
L064_0000110A:
; H064+$0000110A: 33fcffff00002810  move.w #$ffff, $2810.l
        move.w #$ffff, (H005+$2810).l
L064_00001112:
; H064+$00001112: 33fcffff00002812  move.w #$ffff, $2812.l
        move.w #$ffff, (H005+$2812).l
L064_0000111A:
; H064+$0000111A: 0c6d00fffffe  cmpi.w #$ff, -$2(a5)
        cmpi.w #$ff, -$2(a5)
L064_00001120:
; H064+$00001120: 6700001e  beq.w $1140
        beq.w H064+$1140
L064_00001124:
; H064+$00001124: 0c6d007ffffe  cmpi.w #$7f, -$2(a5)
        cmpi.w #$7f, -$2(a5)
L064_0000112A:
; H064+$0000112A: 67000014  beq.w $1140
        beq.w H064+$1140
L064_0000112E:
; H064+$0000112E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L064_00001132:
; H064+$00001132: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama Load_WallDefinitions (H011+$14EA).
L064_00001136:
; H064+$00001136: 4eb9000014ea  jsr $14ea.l
        jsr (H011+$14EA).l
L064_0000113C:
; H064+$0000113C: 60000012  bra.w $1150
        bra.w H064+$1150
L064_00001140:
; H064+$00001140: 33fcffff00002818  move.w #$ffff, $2818.l
        move.w #$ffff, (H005+$2818).l
L064_00001148:
; H064+$00001148: 33fcffff0000281a  move.w #$ffff, $281a.l
        move.w #$ffff, (H005+$281A).l
L064_00001150:
; H064+$00001150: 60000074  bra.w $11c6
        bra.w H064+$11C6
L064_00001154:
; H064+$00001154: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L064_0000115A:
; H064+$0000115A: 0c6d0003fff8  cmpi.w #$3, -$8(a5)
        cmpi.w #$3, -$8(a5)
L064_00001160:
; H064+$00001160: 62000064  bhi.w $11c6
        bhi.w H064+$11C6
L064_00001164:
; H064+$00001164: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L064_00001168:
; H064+$00001168: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_0000116A:
; H064+$0000116A: e342  asl.w #$1, d2
        asl.w #$1, d2
L064_0000116C:
; H064+$0000116C: 47edfffa  lea.l -$6(a5), a3
        lea.l -$6(a5), a3
L064_00001170:
; H064+$00001170: 0c7300ff2000  cmpi.w #$ff, (a3, d2.w)
        cmpi.w #$ff, (a3, d2.w)
L064_00001176:
; H064+$00001176: 67000020  beq.w $1198
        beq.w H064+$1198
L064_0000117A:
; H064+$0000117A: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L064_0000117E:
; H064+$0000117E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_00001180:
; H064+$00001180: e342  asl.w #$1, d2
        asl.w #$1, d2
L064_00001182:
; H064+$00001182: 47edfffa  lea.l -$6(a5), a3
        lea.l -$6(a5), a3
L064_00001186:
; H064+$00001186: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L064_0000118A:
; H064+$0000118A: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; FLUSSO: Chiama Load_WallDefinitions (H011+$14EA).
L064_0000118E:
; H064+$0000118E: 4eb9000014ea  jsr $14ea.l
        jsr (H011+$14EA).l
L064_00001194:
; H064+$00001194: 6000002a  bra.w $11c0
        bra.w H064+$11C0
L064_00001198:
; H064+$00001198: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L064_0000119C:
; H064+$0000119C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_0000119E:
; H064+$0000119E: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATO: H005+$2810 = tre elementi di stato degli insiemi pareti
L064_000011A0:
; H064+$000011A0: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L064_000011A6:
; H064+$000011A6: 37bcffff2000  move.w #$ffff, (a3, d2.w)
        move.w #$ffff, (a3, d2.w)
L064_000011AC:
; H064+$000011AC: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L064_000011B0:
; H064+$000011B0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_000011B2:
; H064+$000011B2: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATO: H005+$2810 = tre elementi di stato degli insiemi pareti
L064_000011B4:
; H064+$000011B4: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L064_000011BA:
; H064+$000011BA: 37bcffff2002  move.w #$ffff, $2(a3, d2.w)
        move.w #$ffff, $2(a3, d2.w)
L064_000011C0:
; H064+$000011C0: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L064_000011C4:
; H064+$000011C4: 6494  bcc.b $115a
        bcc.b H064+$115A
L064_000011C6:
; H064+$000011C6: 4a2cffa9  tst.b -$57(a4)
        tst.b -$57(a4)
L064_000011CA:
; H064+$000011CA: 6700004a  beq.w $1216
        beq.w H064+$1216
L064_000011CE:
; H064+$000011CE: 4a2cffa8  tst.b -$58(a4)
        tst.b -$58(a4)
L064_000011D2:
; H064+$000011D2: 67000042  beq.w $1216
        beq.w H064+$1216
L064_000011D6:
; H064+$000011D6: 0c39000300003de2  cmpi.b #$3, $3de2.l
        cmpi.b #$3, (H005+$3DE2).l
L064_000011DE:
; H064+$000011DE: 66000036  bne.w $1216
        bne.w H064+$1216
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L064_000011E2:
; H064+$000011E2: 0c39000300003de3  cmpi.b #$3, $3de3.l
        cmpi.b #$3, (H005+$3DE3).l
L064_000011EA:
; H064+$000011EA: 67000024  beq.w $1210
        beq.w H064+$1210
L064_000011EE:
; H064+$000011EE: 4a39000024b2  tst.b $24b2.l
        tst.b (H005+$24B2).l
L064_000011F4:
; H064+$000011F4: 6700001a  beq.w $1210
        beq.w H064+$1210
; -> H044+$0330 (sub_H044_00000330)
L064_000011F8:
; H064+$000011F8: 4eb900000330  jsr $330.l
        jsr (H044+$330).l
; STATO: H005+$3368 = personaggio corrente
L064_000011FE:
; H064+$000011FE: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L064_00001204:
; H064+$00001204: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
; -> H063+$33A0 (trampoline_H063_3652)
L064_0000120A:
; H064+$0000120A: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L064_00001210:
; H064+$00001210: 4239000024b2  clr.b $24b2.l
        clr.b (H005+$24B2).l
L064_00001216:
; H064+$00001216: 4e5d  unlk a5
        unlk a5
L064_00001218:
; H064+$00001218: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_0000121A:
; H064+$0000121A: 4e75  rts 
        rts 
; FUNCTION: ECL_47_AND__48_OR
FN_ECL_47_AND__48_OR:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_47 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 47=AND, 48=OR.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2F12
; --------------------------------------------------------------------------
L064_0000121C:
; H064+$0000121C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_0000121E:
; H064+$0000121E: 287aeeca  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_00001222:
; H064+$00001222: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L064_00001226:
; H064+$00001226: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_0000122A:
; H064+$0000122A: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_00001230:
; H064+$00001230: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00001234:
; H064+$00001234: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_0000123A:
; H064+$0000123A: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L064_0000123E:
; H064+$0000123E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00001242:
; H064+$00001242: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00001248:
; H064+$00001248: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_0000124C:
; H064+$0000124C: 1f3900001454  move.b $1454.l, -(a7)
        move.b (H061+$1454).l, -(a7)
L064_00001252:
; H064+$00001252: 1f3900001494  move.b $1494.l, -(a7)
        move.b (H061+$1494).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00001258:
; H064+$00001258: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_0000125E:
; H064+$0000125E: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L064_00001262:
; H064+$00001262: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$2493 = opcode ECL corrente
L064_00001264:
; H064+$00001264: 143900002493  move.b $2493.l, d2
        move.b (H005+$2493).l, d2
L064_0000126A:
; H064+$0000126A: 0c42002f  cmpi.w #$2f, d2
        cmpi.w #$2f, d2
L064_0000126E:
; H064+$0000126E: 66000020  bne.w $1290
        bne.w H064+$1290
L064_00001272:
; H064+$00001272: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_00001276:
; H064+$00001276: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L064_00001278:
; H064+$00001278: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L064_0000127C:
; H064+$0000127C: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L064_00001282:
; H064+$00001282: 1400  move.b d0, d2
        move.b d0, d2
L064_00001284:
; H064+$00001284: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L064_00001288:
; H064+$00001288: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L064_0000128C:
; H064+$0000128C: 6000001c  bra.w $12aa
        bra.w H064+$12AA
L064_00001290:
; H064+$00001290: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_00001294:
; H064+$00001294: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L064_00001296:
; H064+$00001296: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L064_0000129A:
; H064+$0000129A: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L064_000012A0:
; H064+$000012A0: 1400  move.b d0, d2
        move.b d0, d2
L064_000012A2:
; H064+$000012A2: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L064_000012A6:
; H064+$000012A6: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L064_000012AA:
; H064+$000012AA: 4267  clr.w -(a7)
        clr.w -(a7)
L064_000012AC:
; H064+$000012AC: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H061+$3A0A (sub_H061_00003A0A)
L064_000012B0:
; H064+$000012B0: 4eb900003a0a  jsr $3a0a.l
        jsr (H061+$3A0A).l
L064_000012B6:
; H064+$000012B6: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L064_000012BA:
; H064+$000012BA: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_000012BE:
; H064+$000012BE: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_000012C4:
; H064+$000012C4: 4e5d  unlk a5
        unlk a5
L064_000012C6:
; H064+$000012C6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_000012C8:
; H064+$000012C8: 4e75  rts 
        rts 
; FUNCTION: ECL_42_GETTABLE
FN_ECL_42_GETTABLE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_42 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 42=GETTABLE.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2EF0
; --------------------------------------------------------------------------
L064_000012CA:
; H064+$000012CA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000012CC:
; H064+$000012CC: 287aee1c  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_000012D0:
; H064+$000012D0: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L064_000012D4:
; H064+$000012D4: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_000012D8:
; H064+$000012D8: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_000012DE:
; H064+$000012DE: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L064_000012E4:
; H064+$000012E4: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_000012EA:
; H064+$000012EA: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_000012F0:
; H064+$000012F0: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L064_000012F4:
; H064+$000012F4: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_000012F8:
; H064+$000012F8: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_000012FE:
; H064+$000012FE: 3b40fff6  move.w d0, -$a(a5)
        move.w d0, -$a(a5)
L064_00001302:
; H064+$00001302: 1f3900001454  move.b $1454.l, -(a7)
        move.b (H061+$1454).l, -(a7)
L064_00001308:
; H064+$00001308: 1f3900001494  move.b $1494.l, -(a7)
        move.b (H061+$1494).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_0000130E:
; H064+$0000130E: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_00001314:
; H064+$00001314: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_00001318:
; H064+$00001318: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L064_0000131C:
; H064+$0000131C: d46dfff6  add.w -$a(a5), d2
        add.w -$a(a5), d2
L064_00001320:
; H064+$00001320: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L064_00001324:
; H064+$00001324: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H061+$2E04 (sub_H061_00002E04)
L064_00001328:
; H064+$00001328: 4eb900002e04  jsr $2e04.l
        jsr (H061+$2E04).l
L064_0000132E:
; H064+$0000132E: 3b40fff8  move.w d0, -$8(a5)
        move.w d0, -$8(a5)
L064_00001332:
; H064+$00001332: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L064_00001336:
; H064+$00001336: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_0000133A:
; H064+$0000133A: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_00001340:
; H064+$00001340: 4e5d  unlk a5
        unlk a5
L064_00001342:
; H064+$00001342: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00001344:
; H064+$00001344: 4e75  rts 
        rts 
; FUNCTION: ECL_53_SAVE_TABLE
FN_ECL_53_SAVE_TABLE:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_53 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 53=SAVE TABLE.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2F32
; --------------------------------------------------------------------------
L064_00001346:
; H064+$00001346: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00001348:
; H064+$00001348: 287aeda0  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000134C:
; H064+$0000134C: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L064_00001350:
; H064+$00001350: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00001354:
; H064+$00001354: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_0000135A:
; H064+$0000135A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_0000135E:
; H064+$0000135E: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00001364:
; H064+$00001364: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L064_00001368:
; H064+$00001368: 1f3900001453  move.b $1453.l, -(a7)
        move.b (H061+$1453).l, -(a7)
L064_0000136E:
; H064+$0000136E: 1f3900001493  move.b $1493.l, -(a7)
        move.b (H061+$1493).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00001374:
; H064+$00001374: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_0000137A:
; H064+$0000137A: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_0000137E:
; H064+$0000137E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00001382:
; H064+$00001382: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00001388:
; H064+$00001388: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L064_0000138C:
; H064+$0000138C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L064_00001390:
; H064+$00001390: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L064_00001394:
; H064+$00001394: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L064_00001398:
; H064+$00001398: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L064_0000139C:
; H064+$0000139C: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_000013A0:
; H064+$000013A0: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_000013A6:
; H064+$000013A6: 4e5d  unlk a5
        unlk a5
L064_000013A8:
; H064+$000013A8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_000013AA:
; H064+$000013AA: 4e75  rts 
        rts 
; FUNCTION: ECL_21_VERTICAL_MENU
FN_ECL_21_VERTICAL_MENU:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_21 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 21=VERTICAL MENU.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2E90
; --------------------------------------------------------------------------
L064_000013AC:
; H064+$000013AC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000013AE:
; H064+$000013AE: 287aed3a  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_000013B2:
; H064+$000013B2: 4e55feec  link.w a5, #$feec
        link.w a5, #$feec
L064_000013B6:
; H064+$000013B6: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L064_000013BE:
; H064+$000013BE: 4239000024b9  clr.b $24b9.l
        clr.b (H005+$24B9).l
L064_000013C4:
; H064+$000013C4: 1b7c0001feef  move.b #$1, -$111(a5)
        move.b #$1, -$111(a5)
L064_000013CA:
; H064+$000013CA: 47ec0036  lea.l $36(a4), a3
        lea.l $36(a4), a3
L064_000013CE:
; H064+$000013CE: 45edfef2  lea.l -$10e(a5), a2
        lea.l -$10e(a5), a2
L064_000013D2:
; H064+$000013D2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_000013D4:
; H064+$000013D4: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_000013D6:
; H064+$000013D6: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L064_000013DC:
; H064+$000013DC: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_000013E0:
; H064+$000013E0: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_000013E6:
; H064+$000013E6: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L064_000013EC:
; H064+$000013EC: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_000013F2:
; H064+$000013F2: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_000013F8:
; H064+$000013F8: 3b40feec  move.w d0, -$114(a5)
        move.w d0, -$114(a5)
L064_000013FC:
; H064+$000013FC: 47f900000052  lea.l $52.l, a3
        lea.l (H061+$52).l, a3
L064_00001402:
; H064+$00001402: 45edfefc  lea.l -$104(a5), a2
        lea.l -$104(a5), a2
L064_00001406:
; H064+$00001406: 743f  moveq #$3f, d2
        moveq #63, d2
L064_00001408:
; H064+$00001408: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L064_0000140A:
; H064+$0000140A: 51cafffc  dbra d2, $1408
        dbra d2, H064+$1408
L064_0000140E:
; H064+$0000140E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00001412:
; H064+$00001412: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_00001418:
; H064+$00001418: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
; STATO: H005+$3DEA = PC logico ECL
L064_0000141C:
; H064+$0000141C: 537900003dea  subq.w #$1, $3dea.l
        subq.w #$1, (H005+$3DEA).l
L064_00001422:
; H064+$00001422: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00001426:
; H064+$00001426: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_0000142C:
; H064+$0000142C: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L064_00001430:
; H064+$00001430: 486dfef8  pea.l -$108(a5)
        pea.l -$108(a5)
; -> H008+$20C2 (sub_H008_000020C2)
L064_00001434:
; H064+$00001434: 4eb9000020c2  jsr $20c2.l
        jsr (H008+$20C2).l
L064_0000143A:
; H064+$0000143A: 2b6dfef8fef4  move.l -$108(a5), -$10c(a5)
        move.l -$108(a5), -$10c(a5)
L064_00001440:
; H064+$00001440: 33fc00010000334e  move.w #$1, $334e.l
        move.w #$1, (H005+$334E).l
L064_00001448:
; H064+$00001448: 33fc00110000334c  move.w #$11, $334c.l
        move.w #$11, (H005+$334C).l
L064_00001450:
; H064+$00001450: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_00001454:
; H064+$00001454: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L064_00001458:
; H064+$00001458: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L064_0000145C:
; H064+$0000145C: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L064_00001460:
; H064+$00001460: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L064_00001464:
; H064+$00001464: 4267  clr.w -(a7)
        clr.w -(a7)
L064_00001466:
; H064+$00001466: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L064_0000146A:
; H064+$0000146A: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_0000146E:
; H064+$0000146E: 486dfefc  pea.l -$104(a5)
        pea.l -$104(a5)
; -> H030+$0302 (trampoline_H030_0470)
L064_00001472:
; H064+$00001472: 4eb900000302  jsr $302.l
        jsr (H030+$302).l
L064_00001478:
; H064+$00001478: 4aadfef8  tst.l -$108(a5)
        tst.l -$108(a5)
L064_0000147C:
; H064+$0000147C: 6700003e  beq.w $14bc
        beq.w H064+$14BC
L064_00001480:
; H064+$00001480: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L064_00001484:
; H064+$00001484: 2f2dfef8  move.l -$108(a5), -(a7)
        move.l -$108(a5), -(a7)
L064_00001488:
; H064+$00001488: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L064_0000148C:
; H064+$0000148C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_0000148E:
; H064+$0000148E: e142  asl.w #$8, d2
        asl.w #$8, d2
L064_00001490:
; H064+$00001490: 47f900000052  lea.l $52.l, a3
        lea.l (H061+$52).l, a3
L064_00001496:
; H064+$00001496: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_0000149A:
; H064+$0000149A: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; -> H026+$0188 (sub_H026_00000188)
L064_0000149E:
; H064+$0000149E: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L064_000014A4:
; H064+$000014A4: 266dfef8  movea.l -$108(a5), a3
        movea.l -$108(a5), a3
L064_000014A8:
; H064+$000014A8: 422b002a  clr.b $2a(a3)
        clr.b $2a(a3)
L064_000014AC:
; H064+$000014AC: 266dfef8  movea.l -$108(a5), a3
        movea.l -$108(a5), a3
L064_000014B0:
; H064+$000014B0: 2b6b002cfef8  move.l $2c(a3), -$108(a5)
        move.l $2c(a3), -$108(a5)
L064_000014B6:
; H064+$000014B6: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L064_000014BA:
; H064+$000014BA: 60bc  bra.b $1478
        bra.b H064+$1478
L064_000014BC:
; H064+$000014BC: 2b6dfef4fef8  move.l -$10c(a5), -$108(a5)
        move.l -$10c(a5), -$108(a5)
L064_000014C2:
; H064+$000014C2: 426dfef0  clr.w -$110(a5)
        clr.w -$110(a5)
L064_000014C6:
; H064+$000014C6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_000014CA:
; H064+$000014CA: 486dfef2  pea.l -$10e(a5)
        pea.l -$10e(a5)
L064_000014CE:
; H064+$000014CE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_000014D2:
; H064+$000014D2: 486dfef2  pea.l -$10e(a5)
        pea.l -$10e(a5)
L064_000014D6:
; H064+$000014D6: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L064_000014DA:
; H064+$000014DA: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L064_000014DE:
; H064+$000014DE: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L064_000014E2:
; H064+$000014E2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_000014E6:
; H064+$000014E6: 34390000334c  move.w $334c.l, d2
        move.w (H005+$334C).l, d2
L064_000014EC:
; H064+$000014EC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L064_000014EE:
; H064+$000014EE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L064_000014F0:
; H064+$000014F0: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L064_000014F4:
; H064+$000014F4: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L064_000014F8:
; H064+$000014F8: 2f2dfef8  move.l -$108(a5), -(a7)
        move.l -$108(a5), -(a7)
L064_000014FC:
; H064+$000014FC: 4227  clr.b -(a7)
        clr.b -(a7)
L064_000014FE:
; H064+$000014FE: 486dfeef  pea.l -$111(a5)
        pea.l -$111(a5)
L064_00001502:
; H064+$00001502: 486dfef0  pea.l -$110(a5)
        pea.l -$110(a5)
L064_00001506:
; H064+$00001506: 486dfef8  pea.l -$108(a5)
        pea.l -$108(a5)
; -> H061+$3860 (sub_H061_00003860)
L064_0000150A:
; H064+$0000150A: 4eb900003860  jsr $3860.l
        jsr (H061+$3860).l
L064_00001510:
; H064+$00001510: 3f2dfeec  move.w -$114(a5), -(a7)
        move.w -$114(a5), -(a7)
L064_00001514:
; H064+$00001514: 3f2dfef0  move.w -$110(a5), -(a7)
        move.w -$110(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_00001518:
; H064+$00001518: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_0000151E:
; H064+$0000151E: 486dfef8  pea.l -$108(a5)
        pea.l -$108(a5)
; -> H008+$2178 (sub_H008_00002178)
L064_00001522:
; H064+$00001522: 4eb900002178  jsr $2178.l
        jsr (H008+$2178).l
L064_00001528:
; H064+$00001528: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_0000152C:
; H064+$0000152C: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L064_00001530:
; H064+$00001530: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L064_00001534:
; H064+$00001534: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L064_00001538:
; H064+$00001538: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L064_0000153E:
; H064+$0000153E: 4e5d  unlk a5
        unlk a5
L064_00001540:
; H064+$00001540: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00001542:
; H064+$00001542: 4e75  rts 
        rts 
; FUNCTION: ECL_43_HORIZONTAL_MENU
FN_ECL_43_HORIZONTAL_MENU:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_43 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 43=HORIZONTAL MENU.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2EF8
; --------------------------------------------------------------------------
L064_00001544:
; H064+$00001544: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_00001546:
; H064+$00001546: 287aeba2  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000154A:
; H064+$0000154A: 4e55ffbc  link.w a5, #$ffbc
        link.w a5, #$ffbc
L064_0000154E:
; H064+$0000154E: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L064_00001556:
; H064+$00001556: 47ec007f  lea.l $7f(a4), a3
        lea.l $7f(a4), a3
L064_0000155A:
; H064+$0000155A: 45edfff8  lea.l -$8(a5), a2
        lea.l -$8(a5), a2
L064_0000155E:
; H064+$0000155E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00001560:
; H064+$00001560: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_00001562:
; H064+$00001562: 47ec0081  lea.l $81(a4), a3
        lea.l $81(a4), a3
L064_00001566:
; H064+$00001566: 45edffc4  lea.l -$3c(a5), a2
        lea.l -$3c(a5), a2
L064_0000156A:
; H064+$0000156A: 7432  moveq #$32, d2
        moveq #50, d2
L064_0000156C:
; H064+$0000156C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_0000156E:
; H064+$0000156E: 57cafffc  dbeq d2, $156c
        dbeq d2, H064+$156C
L064_00001572:
; H064+$00001572: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_00001576:
; H064+$00001576: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_0000157C:
; H064+$0000157C: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L064_00001582:
; H064+$00001582: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00001588:
; H064+$00001588: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_0000158E:
; H064+$0000158E: 3b40ffc2  move.w d0, -$3e(a5)
        move.w d0, -$3e(a5)
L064_00001592:
; H064+$00001592: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; FLUSSO: Chiama ECL_EvaluateOperand (H061+$184E).
L064_00001596:
; H064+$00001596: 4eb90000184e  jsr $184e.l
        jsr (H061+$184E).l
L064_0000159C:
; H064+$0000159C: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
; STATO: H005+$3DEA = PC logico ECL
L064_000015A0:
; H064+$000015A0: 537900003dea  subq.w #$1, $3dea.l
        subq.w #$1, (H005+$3DEA).l
L064_000015A6:
; H064+$000015A6: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_000015AA:
; H064+$000015AA: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_000015B0:
; H064+$000015B0: 47ec0083  lea.l $83(a4), a3
        lea.l $83(a4), a3
L064_000015B4:
; H064+$000015B4: 45edffc4  lea.l -$3c(a5), a2
        lea.l -$3c(a5), a2
L064_000015B8:
; H064+$000015B8: 7432  moveq #$32, d2
        moveq #50, d2
L064_000015BA:
; H064+$000015BA: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L064_000015BC:
; H064+$000015BC: 57cafffc  dbeq d2, $15ba
        dbeq d2, H064+$15BA
L064_000015C0:
; H064+$000015C0: 0c6d0001fffe  cmpi.w #$1, -$2(a5)
        cmpi.w #$1, -$2(a5)
L064_000015C6:
; H064+$000015C6: 66000052  bne.w $161a
        bne.w H064+$161A
L064_000015CA:
; H064+$000015CA: 1b7c0001ffc1  move.b #$1, -$3f(a5)
        move.b #$1, -$3f(a5)
L064_000015D0:
; H064+$000015D0: 3b7c000fffbe  move.w #$f, -$42(a5)
        move.w #$f, -$42(a5)
L064_000015D6:
; H064+$000015D6: 3b7c000fffbc  move.w #$f, -$44(a5)
        move.w #$f, -$44(a5)
L064_000015DC:
; H064+$000015DC: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_000015E0:
; H064+$000015E0: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
L064_000015E6:
; H064+$000015E6: 3f3c0023  move.w #$23, -(a7)
        move.w #$23, -(a7)
L064_000015EA:
; H064+$000015EA: 486c0038  pea.l $38(a4)
        pea.l $38(a4)
; -> H026+$0106 (sub_H026_00000106)
L064_000015EE:
; H064+$000015EE: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L064_000015F4:
; H064+$000015F4: 1400  move.b d0, d2
        move.b d0, d2
L064_000015F6:
; H064+$000015F6: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L064_000015FA:
; H064+$000015FA: 6600001a  bne.w $1616
        bne.w H064+$1616
L064_000015FE:
; H064+$000015FE: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_00001602:
; H064+$00001602: 487900000052  pea.l $52.l
        pea.l (H061+$52).l
L064_00001608:
; H064+$00001608: 3f3c0022  move.w #$22, -(a7)
        move.w #$22, -(a7)
L064_0000160C:
; H064+$0000160C: 486c005c  pea.l $5c(a4)
        pea.l $5c(a4)
; -> H026+$0188 (sub_H026_00000188)
L064_00001610:
; H064+$00001610: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L064_00001616:
; H064+$00001616: 60000012  bra.w $162a
        bra.w H064+$162A
L064_0000161A:
; H064+$0000161A: 422dffc1  clr.b -$3f(a5)
        clr.b -$3f(a5)
L064_0000161E:
; H064+$0000161E: 3b7c000fffbe  move.w #$f, -$42(a5)
        move.w #$f, -$42(a5)
L064_00001624:
; H064+$00001624: 3b7c000affbc  move.w #$a, -$44(a5)
        move.w #$a, -$44(a5)
L064_0000162A:
; H064+$0000162A: 4a39000024bd  tst.b $24bd.l
        tst.b (H005+$24BD).l
L064_00001630:
; H064+$00001630: 67000010  beq.w $1642
        beq.w H064+$1642
L064_00001634:
; H064+$00001634: 4a39000024bc  tst.b $24bc.l
        tst.b (H005+$24BC).l
L064_0000163A:
; H064+$0000163A: 67000006  beq.w $1642
        beq.w H064+$1642
L064_0000163E:
; H064+$0000163E: 7401  moveq #$1, d2
        moveq #1, d2
L064_00001640:
; H064+$00001640: 6002  bra.b $1644
        bra.b H064+$1644
L064_00001642:
; H064+$00001642: 7400  moveq #$0, d2
        moveq #0, d2
L064_00001644:
; H064+$00001644: 1b42ffc0  move.b d2, -$40(a5)
        move.b d2, -$40(a5)
L064_00001648:
; H064+$00001648: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L064_0000164E:
; H064+$0000164E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L064_00001652:
; H064+$00001652: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_00001654:
; H064+$00001654: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L064_00001656:
; H064+$00001656: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_0000165A:
; H064+$0000165A: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L064_0000165C:
; H064+$0000165C: 62000058  bhi.w $16b6
        bhi.w H064+$16B6
L064_00001660:
; H064+$00001660: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L064_00001664:
; H064+$00001664: 486dffc4  pea.l -$3c(a5)
        pea.l -$3c(a5)
L064_00001668:
; H064+$00001668: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_0000166C:
; H064+$0000166C: 486c0085  pea.l $85(a4)
        pea.l $85(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L064_00001670:
; H064+$00001670: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L064_00001676:
; H064+$00001676: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L064_0000167A:
; H064+$0000167A: 486dffc4  pea.l -$3c(a5)
        pea.l -$3c(a5)
L064_0000167E:
; H064+$0000167E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L064_00001682:
; H064+$00001682: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_00001684:
; H064+$00001684: e142  asl.w #$8, d2
        asl.w #$8, d2
L064_00001686:
; H064+$00001686: 47f900000052  lea.l $52.l, a3
        lea.l (H061+$52).l, a3
L064_0000168C:
; H064+$0000168C: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_00001690:
; H064+$00001690: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; -> H026+$01E0 (sub_H026_000001E0)
L064_00001694:
; H064+$00001694: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L064_0000169A:
; H064+$0000169A: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L064_0000169E:
; H064+$0000169E: 486dffc4  pea.l -$3c(a5)
        pea.l -$3c(a5)
L064_000016A2:
; H064+$000016A2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_000016A6:
; H064+$000016A6: 486c0087  pea.l $87(a4)
        pea.l $87(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L064_000016AA:
; H064+$000016AA: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L064_000016B0:
; H064+$000016B0: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L064_000016B4:
; H064+$000016B4: 64a0  bcc.b $1656
        bcc.b H064+$1656
L064_000016B6:
; H064+$000016B6: 548f  addq.l #$2, a7
        addq.l #$2, a7
L064_000016B8:
; H064+$000016B8: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L064_000016BC:
; H064+$000016BC: 486dffc4  pea.l -$3c(a5)
        pea.l -$3c(a5)
L064_000016C0:
; H064+$000016C0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_000016C4:
; H064+$000016C4: 486c0089  pea.l $89(a4)
        pea.l $89(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L064_000016C8:
; H064+$000016C8: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L064_000016CE:
; H064+$000016CE: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L064_000016D2:
; H064+$000016D2: 486dffc4  pea.l -$3c(a5)
        pea.l -$3c(a5)
L064_000016D6:
; H064+$000016D6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L064_000016DA:
; H064+$000016DA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L064_000016DC:
; H064+$000016DC: e142  asl.w #$8, d2
        asl.w #$8, d2
L064_000016DE:
; H064+$000016DE: 47f900000052  lea.l $52.l, a3
        lea.l (H061+$52).l, a3
L064_000016E4:
; H064+$000016E4: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L064_000016E8:
; H064+$000016E8: 48732000  pea.l (a3, d2.w)
        pea.l (a3, d2.w)
; -> H026+$01E0 (sub_H026_000001E0)
L064_000016EC:
; H064+$000016EC: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L064_000016F2:
; H064+$000016F2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L064_000016F6:
; H064+$000016F6: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L064_000016FA:
; H064+$000016FA: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L064_000016FE:
; H064+$000016FE: 486dffc4  pea.l -$3c(a5)
        pea.l -$3c(a5)
L064_00001702:
; H064+$00001702: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L064_00001706:
; H064+$00001706: 3f2dffbc  move.w -$44(a5), -(a7)
        move.w -$44(a5), -(a7)
L064_0000170A:
; H064+$0000170A: 3f2dffbe  move.w -$42(a5), -(a7)
        move.w -$42(a5), -(a7)
L064_0000170E:
; H064+$0000170E: 1f2dffc1  move.b -$3f(a5), -(a7)
        move.b -$3f(a5), -(a7)
L064_00001712:
; H064+$00001712: 1f2dffc0  move.b -$40(a5), -(a7)
        move.b -$40(a5), -(a7)
; -> H061+$36E6 (sub_H061_000036E6)
L064_00001716:
; H064+$00001716: 4eb9000036e6  jsr $36e6.l
        jsr (H061+$36E6).l
L064_0000171C:
; H064+$0000171C: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L064_00001720:
; H064+$00001720: 3f2dffc2  move.w -$3e(a5), -(a7)
        move.w -$3e(a5), -(a7)
L064_00001724:
; H064+$00001724: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_00001728:
; H064+$00001728: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_0000172E:
; H064+$0000172E: 4267  clr.w -(a7)
        clr.w -(a7)
L064_00001730:
; H064+$00001730: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L064_00001734:
; H064+$00001734: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L064_00001738:
; H064+$00001738: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L064_0000173C:
; H064+$0000173C: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L064_00001742:
; H064+$00001742: 4e5d  unlk a5
        unlk a5
L064_00001744:
; H064+$00001744: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00001746:
; H064+$00001746: 4e75  rts 
        rts 
; FUNCTION: ECL_28_CLEARMONSTERS
FN_ECL_28_CLEARMONSTERS:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_28 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 28=CLEARMONSTERS.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2EA0
; --------------------------------------------------------------------------
L064_00001748:
; H064+$00001748: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_0000174A:
; H064+$0000174A: 287ae99e  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_0000174E:
; H064+$0000174E: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
; STATO: H005+$3DEA = PC logico ECL
L064_00001752:
; H064+$00001752: 527900003dea  addq.w #$1, $3dea.l
        addq.w #$1, (H005+$3DEA).l
L064_00001758:
; H064+$00001758: 42390000248f  clr.b $248f.l
        clr.b (H005+$248F).l
L064_0000175E:
; H064+$0000175E: 422cffa7  clr.b -$59(a4)
        clr.b -$59(a4)
L064_00001762:
; H064+$00001762: 4239000024b6  clr.b $24b6.l
        clr.b (H005+$24B6).l
L064_00001768:
; H064+$00001768: 13fc00080000248e  move.b #$8, $248e.l
        move.b #$8, (H005+$248E).l
L064_00001770:
; H064+$00001770: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L064_00001774:
; H064+$00001774: 487900002a1e  pea.l $2a1e.l
        pea.l (H005+$2A1E).l
L064_0000177A:
; H064+$0000177A: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L064_0000177E:
; H064+$0000177E: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L064_00001780:
; H064+$00001780: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L064_00001786:
; H064+$00001786: 4ab900002a3a  tst.l $2a3a.l
        tst.l (H005+$2A3A).l
L064_0000178C:
; H064+$0000178C: 67000028  beq.w $17b6
        beq.w H064+$17B6
L064_00001790:
; H064+$00001790: 267900002a3a  movea.l $2a3a.l, a3
        movea.l (H005+$2A3A).l, a3
L064_00001796:
; H064+$00001796: 2b6b002cfffc  move.l $2c(a3), -$4(a5)
        move.l $2c(a3), -$4(a5)
L064_0000179C:
; H064+$0000179C: 2f3900002a3a  move.l $2a3a.l, -(a7)
        move.l (H005+$2A3A).l, -(a7)
L064_000017A2:
; H064+$000017A2: 7448  moveq #$48, d2
        moveq #72, d2
L064_000017A4:
; H064+$000017A4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L064_000017A6:
; H064+$000017A6: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L064_000017AC:
; H064+$000017AC: 23edfffc00002a3a  move.l -$4(a5), $2a3a.l
        move.l -$4(a5), (H005+$2A3A).l
L064_000017B4:
; H064+$000017B4: 60d0  bra.b $1786
        bra.b H064+$1786
L064_000017B6:
; H064+$000017B6: 4e5d  unlk a5
        unlk a5
L064_000017B8:
; H064+$000017B8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_000017BA:
; H064+$000017BA: 4e75  rts 
        rts 
; FUNCTION: ECL_29_PARTYSTRENGTH
FN_ECL_29_PARTYSTRENGTH:
;
; --------------------------------------------------------------------------
; ROUTINE: ECL_Handler_29 [nome verificato; semantica parziale]
; Scopo: Gestore ECL collegato dalla tabella di esecuzione: 29=PARTYSTRENGTH.
;   - Il collegamento opcode/nome/indirizzo è verificato incrociando H056 e H012.
;   - I singoli effetti sui campi e tutti i parametri di questo gestore non sono ancora commentati integralmente.
; Chiamanti diretti: H012+$2EA8
; --------------------------------------------------------------------------
L064_000017BC:
; H064+$000017BC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L064_000017BE:
; H064+$000017BE: 287ae92a  movea.l $ea(pc), a4
        movea.l H064+$EA(pc), a4
L064_000017C2:
; H064+$000017C2: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L064_000017C6:
; H064+$000017C6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; FLUSSO: Chiama ECL_ReadOperands (H061+$1670).
L064_000017CA:
; H064+$000017CA: 4eb900001670  jsr $1670.l
        jsr (FN_ECL_read_operands).l
L064_000017D0:
; H064+$000017D0: 422dfffa  clr.b -$6(a5)
        clr.b -$6(a5)
; STATO: H005+$3364 = testa della lista del party
L064_000017D4:
; H064+$000017D4: 2b7900003364fff4  move.l $3364.l, -$c(a5)
        move.l (H005+$3364).l, -$c(a5)
L064_000017DC:
; H064+$000017DC: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L064_000017E0:
; H064+$000017E0: 67000126  beq.w $1908
        beq.w H064+$1908
L064_000017E4:
; H064+$000017E4: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_000017E8:
; H064+$000017E8: 1b6b01a8ffff  move.b $1a8(a3), -$1(a5)
        move.b $1a8(a3), -$1(a5)
L064_000017EE:
; H064+$000017EE: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_000017F2:
; H064+$000017F2: 1b6b019cfffb  move.b $19c(a3), -$5(a5)
        move.b $19c(a3), -$5(a5)
L064_000017F8:
; H064+$000017F8: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_000017FC:
; H064+$000017FC: 1b6b019bfffe  move.b $19b(a3), -$2(a5)
        move.b $19b(a3), -$2(a5)
L064_00001802:
; H064+$00001802: 7400  moveq #$0, d2
        moveq #0, d2
L064_00001804:
; H064+$00001804: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_00001808:
; H064+$00001808: 142b0103  move.b $103(a3), d2
        move.b $103(a3), d2
L064_0000180C:
; H064+$0000180C: 7800  moveq #$0, d4
        moveq #0, d4
L064_0000180E:
; H064+$0000180E: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_00001812:
; H064+$00001812: 182b010b  move.b $10b(a3), d4
        move.b $10b(a3), d4
L064_00001816:
; H064+$00001816: 48e72800  movem.l d2/d4, -(a7)
        movem.l d2/d4, -(a7)
L064_0000181A:
; H064+$0000181A: 2f2dfff4  move.l -$c(a5), -(a7)
        move.l -$c(a5), -(a7)
; -> H073+$130A (sub_H073_0000130A)
L064_0000181E:
; H064+$0000181E: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L064_00001824:
; H064+$00001824: 4cdf0014  movem.l (a7)+, d2/d4
        movem.l (a7)+, d2/d4
L064_00001828:
; H064+$00001828: 1c00  move.b d0, d6
        move.b d0, d6
L064_0000182A:
; H064+$0000182A: 024600ff  andi.w #$ff, d6
        andi.w #$ff, d6
L064_0000182E:
; H064+$0000182E: c8c6  mulu.w d6, d4
        mulu.w d6, d4
L064_00001830:
; H064+$00001830: d444  add.w d4, d2
        add.w d4, d2
L064_00001832:
; H064+$00001832: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L064_00001836:
; H064+$00001836: 7400  moveq #$0, d2
        moveq #0, d2
L064_00001838:
; H064+$00001838: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_0000183C:
; H064+$0000183C: 142b00fe  move.b $fe(a3), d2
        move.b $fe(a3), d2
L064_00001840:
; H064+$00001840: 7800  moveq #$0, d4
        moveq #0, d4
L064_00001842:
; H064+$00001842: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_00001846:
; H064+$00001846: 182b0106  move.b $106(a3), d4
        move.b $106(a3), d4
L064_0000184A:
; H064+$0000184A: 48e72800  movem.l d2/d4, -(a7)
        movem.l d2/d4, -(a7)
L064_0000184E:
; H064+$0000184E: 2f2dfff4  move.l -$c(a5), -(a7)
        move.l -$c(a5), -(a7)
; -> H073+$130A (sub_H073_0000130A)
L064_00001852:
; H064+$00001852: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L064_00001858:
; H064+$00001858: 4cdf0014  movem.l (a7)+, d2/d4
        movem.l (a7)+, d2/d4
L064_0000185C:
; H064+$0000185C: 1c00  move.b d0, d6
        move.b d0, d6
L064_0000185E:
; H064+$0000185E: 024600ff  andi.w #$ff, d6
        andi.w #$ff, d6
L064_00001862:
; H064+$00001862: c8c6  mulu.w d6, d4
        mulu.w d6, d4
L064_00001864:
; H064+$00001864: d444  add.w d4, d2
        add.w d4, d2
L064_00001866:
; H064+$00001866: 1b42fffc  move.b d2, -$4(a5)
        move.b d2, -$4(a5)
L064_0000186A:
; H064+$0000186A: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000186C:
; H064+$0000186C: 142dfffb  move.b -$5(a5), d2
        move.b -$5(a5), d2
L064_00001870:
; H064+$00001870: 0c42003c  cmpi.w #$3c, d2
        cmpi.w #$3c, d2
L064_00001874:
; H064+$00001874: 63000014  bls.w $188a
        bls.w H064+$188A
L064_00001878:
; H064+$00001878: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000187A:
; H064+$0000187A: 142dfffb  move.b -$5(a5), d2
        move.b -$5(a5), d2
L064_0000187E:
; H064+$0000187E: 0442003c  subi.w #$3c, d2
        subi.w #$3c, d2
L064_00001882:
; H064+$00001882: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L064_00001886:
; H064+$00001886: 60000006  bra.w $188e
        bra.w H064+$188E
L064_0000188A:
; H064+$0000188A: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
L064_0000188E:
; H064+$0000188E: 7400  moveq #$0, d2
        moveq #0, d2
L064_00001890:
; H064+$00001890: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L064_00001894:
; H064+$00001894: 0c420027  cmpi.w #$27, d2
        cmpi.w #$27, d2
L064_00001898:
; H064+$00001898: 63000014  bls.w $18ae
        bls.w H064+$18AE
L064_0000189C:
; H064+$0000189C: 7400  moveq #$0, d2
        moveq #0, d2
L064_0000189E:
; H064+$0000189E: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L064_000018A2:
; H064+$000018A2: 04420027  subi.w #$27, d2
        subi.w #$27, d2
L064_000018A6:
; H064+$000018A6: 1b42fffe  move.b d2, -$2(a5)
        move.b d2, -$2(a5)
L064_000018AA:
; H064+$000018AA: 60000006  bra.w $18b2
        bra.w H064+$18B2
L064_000018AE:
; H064+$000018AE: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L064_000018B2:
; H064+$000018B2: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L064_000018B6:
; H064+$000018B6: 7400  moveq #$0, d2
        moveq #0, d2
L064_000018B8:
; H064+$000018B8: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L064_000018BC:
; H064+$000018BC: 7800  moveq #$0, d4
        moveq #0, d4
L064_000018BE:
; H064+$000018BE: 182dfffb  move.b -$5(a5), d4
        move.b -$5(a5), d4
L064_000018C2:
; H064+$000018C2: c8fc0005  mulu.w #$5, d4
        mulu.w #$5, d4
L064_000018C6:
; H064+$000018C6: d444  add.w d4, d2
        add.w d4, d2
L064_000018C8:
; H064+$000018C8: 7800  moveq #$0, d4
        moveq #0, d4
L064_000018CA:
; H064+$000018CA: 182dfffe  move.b -$2(a5), d4
        move.b -$2(a5), d4
L064_000018CE:
; H064+$000018CE: c8fc0005  mulu.w #$5, d4
        mulu.w #$5, d4
L064_000018D2:
; H064+$000018D2: d444  add.w d4, d2
        add.w d4, d2
L064_000018D4:
; H064+$000018D4: 7800  moveq #$0, d4
        moveq #0, d4
L064_000018D6:
; H064+$000018D6: 182dfffd  move.b -$3(a5), d4
        move.b -$3(a5), d4
L064_000018DA:
; H064+$000018DA: e744  asl.w #$3, d4
        asl.w #$3, d4
L064_000018DC:
; H064+$000018DC: d444  add.w d4, d2
        add.w d4, d2
L064_000018DE:
; H064+$000018DE: 7800  moveq #$0, d4
        moveq #0, d4
L064_000018E0:
; H064+$000018E0: 182dfffc  move.b -$4(a5), d4
        move.b -$4(a5), d4
L064_000018E4:
; H064+$000018E4: e544  asl.w #$2, d4
        asl.w #$2, d4
L064_000018E6:
; H064+$000018E6: d444  add.w d4, d2
        add.w d4, d2
L064_000018E8:
; H064+$000018E8: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L064_000018EE:
; H064+$000018EE: 84fc000a  divu.w #$a, d2
        divu.w #$a, d2
L064_000018F2:
; H064+$000018F2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L064_000018F4:
; H064+$000018F4: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L064_000018FA:
; H064+$000018FA: 266dfff4  movea.l -$c(a5), a3
        movea.l -$c(a5), a3
L064_000018FE:
; H064+$000018FE: 2b6b018efff4  move.l $18e(a3), -$c(a5)
        move.l $18e(a3), -$c(a5)
L064_00001904:
; H064+$00001904: 6000fed6  bra.w $17dc
        bra.w H064+$17DC
L064_00001908:
; H064+$00001908: 1f3900001452  move.b $1452.l, -(a7)
        move.b (H061+$1452).l, -(a7)
L064_0000190E:
; H064+$0000190E: 1f3900001492  move.b $1492.l, -(a7)
        move.b (H061+$1492).l, -(a7)
; FLUSSO: Chiama ECL_DecodeAddress (H061+$1F3C).
L064_00001914:
; H064+$00001914: 4eb900001f3c  jsr $1f3c.l
        jsr (H061+$1F3C).l
L064_0000191A:
; H064+$0000191A: 3b40fff8  move.w d0, -$8(a5)
        move.w d0, -$8(a5)
L064_0000191E:
; H064+$0000191E: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L064_00001922:
; H064+$00001922: 7400  moveq #$0, d2
        moveq #0, d2
L064_00001924:
; H064+$00001924: 142dfffa  move.b -$6(a5), d2
        move.b -$6(a5), d2
L064_00001928:
; H064+$00001928: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H061+$2BAA (sub_H061_00002BAA)
L064_0000192A:
; H064+$0000192A: 4eb900002baa  jsr $2baa.l
        jsr (H061+$2BAA).l
L064_00001930:
; H064+$00001930: 4e5d  unlk a5
        unlk a5
L064_00001932:
; H064+$00001932: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_00001934:
; H064+$00001934: 4e75  rts 
        rts 
L064_00001936:
; H064+$00001936: 4e5d  unlk a5
        unlk a5
L064_00001938:
; H064+$00001938: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L064_0000193A:
; H064+$0000193A: 4e75  rts 
        rts 
; End H064: $193C bytes
