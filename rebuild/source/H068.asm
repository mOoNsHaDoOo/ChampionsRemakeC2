; ============================================================================
; GUIDA DEL MODULO H068
; Esplorazione, scelte di movimento, porte e azioni del party.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Esplorazione: menu Move/Area/Cast/View/Encamp/Search/Look, movimento, porte e azioni del party.
; --------------------------------------------------------------------------
; H068: 5788 original bytes; all offsets are section-relative.
        section H068,code
H068:
; Preserved bytes H068+$00000000..$000000A4; code/data not fully classified.
        dc.w $0000,$4D6F,$7665,$2041,$7265,$6120,$4361,$7374
        dc.w $2056,$6965,$7720,$456E,$6361,$6D70,$2053,$6561
        dc.w $7263,$6820,$4C6F,$6F6B,$004E,$6F74,$2048,$6572
        dc.w $6500,$0000,$4578,$6974,$0000,$004D,$6F76,$6520
        dc.w $456E,$6361,$6D70,$0000,$0045,$7869,$7400,$0000
        dc.w $4261,$7368,$0020,$5069,$636B,$0020,$4B6E,$6F63
        dc.w $6B00,$2045,$7869,$7400,$2045,$7869,$7400,$4C6F
        dc.w $636B,$6564,$2E20,$0000,$0042,$6173,$6800,$2050
        dc.w $6963,$6B00,$204B,$6E6F,$636B,$0020,$4578,$6974
        dc.w $0020,$4578,$6974,$004C,$6F63,$6B65,$642E,$2000
        dc.l H068+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H068 [parziale]
; Scopo: Ingresso del modulo esplorazione, scelte di movimento, porte e azioni del party; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H068+$1696.
; Chiamanti diretti: H000+$0234
; --------------------------------------------------------------------------
L068_000000A4:
; H068+$000000A4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_000000A6:
; H068+$000000A6: 287afff8  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_000000AA:
; H068+$000000AA: 4e550000  link.w a5, #$0
        link.w a5, #$0
L068_000000AE:
; H068+$000000AE: 600015e6  bra.w $1696
        bra.w H068+$1696
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H068_00C0 [parziale]
; Scopo: Trampolino verso H068+$00C0; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H068+$00C0.
; Chiamanti diretti: H068+$1378, H068+$1514
; --------------------------------------------------------------------------
L068_000000B2:
; H068+$000000B2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_000000B4:
; H068+$000000B4: 287affea  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_000000B8:
; H068+$000000B8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L068_000000BC:
; H068+$000000BC: 60000002  bra.w $c0
        bra.w H068+$C0
L068_000000C0:
; H068+$000000C0: 4e5d  unlk a5
        unlk a5
L068_000000C2:
; H068+$000000C2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_000000C4:
; H068+$000000C4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L068_000000C6:
; H068+$000000C6: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L068_000000C8:
; H068+$000000C8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_000000CA [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; richiama H029+$0354, H029+$039A.
;   - Richiama H029+$0354.
;   - Richiama H029+$039A.
;   - Usa lo stato globale: H005+$282A (puntatore ai quattro piani dati GEO).
; Chiamanti diretti: H068+$06EA, H068+$0734, H068+$07CC, H068+$0816
; --------------------------------------------------------------------------
L068_000000CA:
; H068+$000000CA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_000000CC:
; H068+$000000CC: 287affd2  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_000000D0:
; H068+$000000D0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L068_000000D4:
; H068+$000000D4: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L068_000000D8:
; H068+$000000D8: 6d00001e  blt.w $f8
        blt.w H068+$F8
L068_000000DC:
; H068+$000000DC: 0c6d000f0010  cmpi.w #$f, $10(a5)
        cmpi.w #$f, $10(a5)
L068_000000E2:
; H068+$000000E2: 6e000014  bgt.w $f8
        bgt.w H068+$F8
L068_000000E6:
; H068+$000000E6: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L068_000000EA:
; H068+$000000EA: 6d00000c  blt.w $f8
        blt.w H068+$F8
L068_000000EE:
; H068+$000000EE: 0c6d000f000e  cmpi.w #$f, $e(a5)
        cmpi.w #$f, $e(a5)
L068_000000F4:
; H068+$000000F4: 6f000006  ble.w $fc
        ble.w H068+$FC
L068_000000F8:
; H068+$000000F8: 600001b4  bra.w $2ae
        bra.w H068+$2AE
L068_000000FC:
; H068+$000000FC: 7400  moveq #$0, d2
        moveq #0, d2
L068_000000FE:
; H068+$000000FE: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L068_00000102:
; H068+$00000102: 60000194  bra.w $298
        bra.w H068+$298
L068_00000106:
; H068+$00000106: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_0000010A:
; H068+$0000010A: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_0000010C:
; H068+$0000010C: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L068_00000112:
; H068+$00000112: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L068_00000116:
; H068+$00000116: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L068_0000011A:
; H068+$0000011A: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L068_0000011E:
; H068+$0000011E: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_00000122:
; H068+$00000122: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_00000126:
; H068+$00000126: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_0000012A:
; H068+$0000012A: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_0000012C:
; H068+$0000012C: 24790000282a  movea.l $282a.l, a2
        movea.l (H005+$282A).l, a2
L068_00000132:
; H068+$00000132: 45ea0300  lea.l $300(a2), a2
        lea.l $300(a2), a2
L068_00000136:
; H068+$00000136: 3c2d0010  move.w $10(a5), d6
        move.w $10(a5), d6
L068_0000013A:
; H068+$0000013A: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L068_0000013E:
; H068+$0000013E: 1f326000  move.b (a2, d6.w), -(a7)
        move.b (a2, d6.w), -(a7)
L068_00000142:
; H068+$00000142: 3f3c003f  move.w #$3f, -(a7)
        move.w #$3f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L068_00000146:
; H068+$00000146: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L068_0000014C:
; H068+$0000014C: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_00000150:
; H068+$00000150: 1f00  move.b d0, -(a7)
        move.b d0, -(a7)
L068_00000152:
; H068+$00000152: 3f3c0040  move.w #$40, -(a7)
        move.w #$40, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L068_00000156:
; H068+$00000156: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L068_0000015C:
; H068+$0000015C: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_00000160:
; H068+$00000160: 17804000  move.b d0, (a3, d4.w)
        move.b d0, (a3, d4.w)
L068_00000164:
; H068+$00000164: 4e75  rts 
        rts 
L068_00000166:
; H068+$00000166: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_0000016A:
; H068+$0000016A: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_0000016C:
; H068+$0000016C: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L068_00000172:
; H068+$00000172: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L068_00000176:
; H068+$00000176: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L068_0000017A:
; H068+$0000017A: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L068_0000017E:
; H068+$0000017E: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_00000182:
; H068+$00000182: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_00000186:
; H068+$00000186: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_0000018A:
; H068+$0000018A: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_0000018C:
; H068+$0000018C: 24790000282a  movea.l $282a.l, a2
        movea.l (H005+$282A).l, a2
L068_00000192:
; H068+$00000192: 45ea0300  lea.l $300(a2), a2
        lea.l $300(a2), a2
L068_00000196:
; H068+$00000196: 3c2d0010  move.w $10(a5), d6
        move.w $10(a5), d6
L068_0000019A:
; H068+$0000019A: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L068_0000019E:
; H068+$0000019E: 1f326000  move.b (a2, d6.w), -(a7)
        move.b (a2, d6.w), -(a7)
L068_000001A2:
; H068+$000001A2: 3f3c00cf  move.w #$cf, -(a7)
        move.w #$cf, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L068_000001A6:
; H068+$000001A6: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L068_000001AC:
; H068+$000001AC: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_000001B0:
; H068+$000001B0: 1f00  move.b d0, -(a7)
        move.b d0, -(a7)
L068_000001B2:
; H068+$000001B2: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L068_000001B6:
; H068+$000001B6: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L068_000001BC:
; H068+$000001BC: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_000001C0:
; H068+$000001C0: 17804000  move.b d0, (a3, d4.w)
        move.b d0, (a3, d4.w)
L068_000001C4:
; H068+$000001C4: 4e75  rts 
        rts 
L068_000001C6:
; H068+$000001C6: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_000001CA:
; H068+$000001CA: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_000001CC:
; H068+$000001CC: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L068_000001D2:
; H068+$000001D2: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L068_000001D6:
; H068+$000001D6: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L068_000001DA:
; H068+$000001DA: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L068_000001DE:
; H068+$000001DE: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_000001E2:
; H068+$000001E2: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_000001E6:
; H068+$000001E6: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_000001EA:
; H068+$000001EA: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_000001EC:
; H068+$000001EC: 24790000282a  movea.l $282a.l, a2
        movea.l (H005+$282A).l, a2
L068_000001F2:
; H068+$000001F2: 45ea0300  lea.l $300(a2), a2
        lea.l $300(a2), a2
L068_000001F6:
; H068+$000001F6: 3c2d0010  move.w $10(a5), d6
        move.w $10(a5), d6
L068_000001FA:
; H068+$000001FA: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L068_000001FE:
; H068+$000001FE: 1f326000  move.b (a2, d6.w), -(a7)
        move.b (a2, d6.w), -(a7)
L068_00000202:
; H068+$00000202: 3f3c00f3  move.w #$f3, -(a7)
        move.w #$f3, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L068_00000206:
; H068+$00000206: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L068_0000020C:
; H068+$0000020C: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_00000210:
; H068+$00000210: 1f00  move.b d0, -(a7)
        move.b d0, -(a7)
L068_00000212:
; H068+$00000212: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L068_00000216:
; H068+$00000216: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L068_0000021C:
; H068+$0000021C: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_00000220:
; H068+$00000220: 17804000  move.b d0, (a3, d4.w)
        move.b d0, (a3, d4.w)
L068_00000224:
; H068+$00000224: 4e75  rts 
        rts 
L068_00000226:
; H068+$00000226: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_0000022A:
; H068+$0000022A: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_0000022C:
; H068+$0000022C: 26790000282a  movea.l $282a.l, a3
        movea.l (H005+$282A).l, a3
L068_00000232:
; H068+$00000232: 47eb0300  lea.l $300(a3), a3
        lea.l $300(a3), a3
L068_00000236:
; H068+$00000236: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L068_0000023A:
; H068+$0000023A: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L068_0000023E:
; H068+$0000023E: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_00000242:
; H068+$00000242: 48e70810  movem.l d4/a3, -(a7)
        movem.l d4/a3, -(a7)
L068_00000246:
; H068+$00000246: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L068_0000024A:
; H068+$0000024A: e942  asl.w #$4, d2
        asl.w #$4, d2
; STATO: H005+$282A = puntatore ai quattro piani dati GEO
L068_0000024C:
; H068+$0000024C: 24790000282a  movea.l $282a.l, a2
        movea.l (H005+$282A).l, a2
L068_00000252:
; H068+$00000252: 45ea0300  lea.l $300(a2), a2
        lea.l $300(a2), a2
L068_00000256:
; H068+$00000256: 3c2d0010  move.w $10(a5), d6
        move.w $10(a5), d6
L068_0000025A:
; H068+$0000025A: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L068_0000025E:
; H068+$0000025E: 1f326000  move.b (a2, d6.w), -(a7)
        move.b (a2, d6.w), -(a7)
L068_00000262:
; H068+$00000262: 3f3c00fc  move.w #$fc, -(a7)
        move.w #$fc, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L068_00000266:
; H068+$00000266: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L068_0000026C:
; H068+$0000026C: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_00000270:
; H068+$00000270: 1f00  move.b d0, -(a7)
        move.b d0, -(a7)
L068_00000272:
; H068+$00000272: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L068_00000276:
; H068+$00000276: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L068_0000027C:
; H068+$0000027C: 4cdf0810  movem.l (a7)+, d4/a3
        movem.l (a7)+, d4/a3
L068_00000280:
; H068+$00000280: 17804000  move.b d0, (a3, d4.w)
        move.b d0, (a3, d4.w)
L068_00000284:
; H068+$00000284: 4e75  rts 
        rts 
L068_00000286:
; H068+$00000286: 4e75  rts 
        rts 
; Preserved bytes H068+$00000288..$00000298; code/data not fully classified.
        dc.w $FFFC,$FF9C,$FFFC,$FF3C,$FFFC,$FEDC,$FFFC,$FE7C
L068_00000298:
; H068+$00000298: 47fafff0  lea.l $28a(pc), a3
        lea.l H068+$28A(pc), a3
L068_0000029C:
; H068+$0000029C: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L068_000002A0:
; H068+$000002A0: 6302  bls.b $2a4
        bls.b H068+$2A4
L068_000002A2:
; H068+$000002A2: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000002A4:
; H068+$000002A4: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000002A6:
; H068+$000002A6: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H068+$028A; indici 0..6, default -1.
L068_000002AA:
; H068+$000002AA: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L068_000002AE:
; H068+$000002AE: 4e5d  unlk a5
        unlk a5
L068_000002B0:
; H068+$000002B0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_000002B2:
; H068+$000002B2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L068_000002B4:
; H068+$000002B4: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L068_000002B6:
; H068+$000002B6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_000002B8 [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; richiama H073+$130A.
;   - Richiama H073+$130A.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H068+$12C6, H068+$1462
; --------------------------------------------------------------------------
L068_000002B8:
; H068+$000002B8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_000002BA:
; H068+$000002BA: 287afde4  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_000002BE:
; H068+$000002BE: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L068_000002C2:
; H068+$000002C2: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
; STATO: H005+$3364 = testa della lista del party
L068_000002C6:
; H068+$000002C6: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L068_000002CE:
; H068+$000002CE: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L068_000002D2:
; H068+$000002D2: 6700005a  beq.w $32e
        beq.w H068+$32E
L068_000002D6:
; H068+$000002D6: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L068_000002DA:
; H068+$000002DA: 66000052  bne.w $32e
        bne.w H068+$32E
L068_000002DE:
; H068+$000002DE: 7400  moveq #$0, d2
        moveq #0, d2
L068_000002E0:
; H068+$000002E0: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L068_000002E4:
; H068+$000002E4: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_000002E8:
; H068+$000002E8: 47eb00fe  lea.l $fe(a3), a3
        lea.l $fe(a3), a3
L068_000002EC:
; H068+$000002EC: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L068_000002F0:
; H068+$000002F0: 6200002a  bhi.w $31c
        bhi.w H068+$31C
L068_000002F4:
; H068+$000002F4: 7400  moveq #$0, d2
        moveq #0, d2
L068_000002F6:
; H068+$000002F6: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L068_000002FA:
; H068+$000002FA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_000002FE:
; H068+$000002FE: 47eb0106  lea.l $106(a3), a3
        lea.l $106(a3), a3
L068_00000302:
; H068+$00000302: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L068_00000306:
; H068+$00000306: 6300001a  bls.w $322
        bls.w H068+$322
L068_0000030A:
; H068+$0000030A: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H073+$130A (sub_H073_0000130A)
L068_0000030E:
; H068+$0000030E: 4eb90000130a  jsr $130a.l
        jsr (H073+$130A).l
L068_00000314:
; H068+$00000314: 1400  move.b d0, d2
        move.b d0, d2
L068_00000316:
; H068+$00000316: 4a02  tst.b d2
        tst.b d2
L068_00000318:
; H068+$00000318: 67000008  beq.w $322
        beq.w H068+$322
L068_0000031C:
; H068+$0000031C: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000322:
; H068+$00000322: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_00000326:
; H068+$00000326: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L068_0000032C:
; H068+$0000032C: 60a0  bra.b $2ce
        bra.b H068+$2CE
L068_0000032E:
; H068+$0000032E: 102dfffb  move.b -$5(a5), d0
        move.b -$5(a5), d0
L068_00000332:
; H068+$00000332: 60000002  bra.w $336
        bra.w H068+$336
L068_00000336:
; H068+$00000336: 4e5d  unlk a5
        unlk a5
L068_00000338:
; H068+$00000338: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_0000033A:
; H068+$0000033A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L068_0000033C:
; H068+$0000033C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L068_0000033E:
; H068+$0000033E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_00000340 [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; richiama H011+$09C8, H062+$156C.
;   - Richiama H011+$09C8.
;   - Richiama H062+$156C.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party); H005+$281C (inizio del blocco coordinate/vista).
; Chiamanti diretti: H068+$13C2, H068+$155E
; --------------------------------------------------------------------------
L068_00000340:
; H068+$00000340: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_00000342:
; H068+$00000342: 287afd5c  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00000346:
; H068+$00000346: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L068_0000034A:
; H068+$0000034A: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
; STATO: H005+$3364 = testa della lista del party
L068_0000034E:
; H068+$0000034E: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L068_00000356:
; H068+$00000356: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L068_0000035A:
; H068+$0000035A: 67000374  beq.w $6d0
        beq.w H068+$6D0
L068_0000035E:
; H068+$0000035E: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L068_00000362:
; H068+$00000362: 6600036c  bne.w $6d0
        bne.w H068+$6D0
L068_00000366:
; H068+$00000366: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_0000036A:
; H068+$0000036A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_0000036C:
; H068+$0000036C: 3f390000281c  move.w $281c.l, -(a7)
        move.w (H005+$281C).l, -(a7)
L068_00000372:
; H068+$00000372: 3f390000281e  move.w $281e.l, -(a7)
        move.w (H005+$281E).l, -(a7)
L068_00000378:
; H068+$00000378: 7400  moveq #$0, d2
        moveq #0, d2
L068_0000037A:
; H068+$0000037A: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L068_00000380:
; H068+$00000380: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$09C8 (sub_H011_000009C8)
L068_00000382:
; H068+$00000382: 4eb9000009c8  jsr $9c8.l
        jsr (H011+$9C8).l
L068_00000388:
; H068+$00000388: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000038A:
; H068+$0000038A: 3400  move.w d0, d2
        move.w d0, d2
L068_0000038C:
; H068+$0000038C: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L068_00000390:
; H068+$00000390: 6600014c  bne.w $4de
        bne.w H068+$4DE
L068_00000394:
; H068+$00000394: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000396:
; H068+$00000396: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L068_0000039A:
; H068+$0000039A: 60000124  bra.w $4c0
        bra.w H068+$4C0
L068_0000039E:
; H068+$0000039E: 7400  moveq #$0, d2
        moveq #0, d2
L068_000003A0:
; H068+$000003A0: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L068_000003A4:
; H068+$000003A4: 0c42005b  cmpi.w #$5b, d2
        cmpi.w #$5b, d2
L068_000003A8:
; H068+$000003A8: 6400000c  bcc.w $3b6
        bcc.w H068+$3B6
L068_000003AC:
; H068+$000003AC: 4239000024e4  clr.b $24e4.l
        clr.b (H005+$24E4).l
L068_000003B2:
; H068+$000003B2: 60000058  bra.w $40c
        bra.w H068+$40C
L068_000003B6:
; H068+$000003B6: 7400  moveq #$0, d2
        moveq #0, d2
L068_000003B8:
; H068+$000003B8: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L068_000003BC:
; H068+$000003BC: 0c420064  cmpi.w #$64, d2
        cmpi.w #$64, d2
L068_000003C0:
; H068+$000003C0: 64000028  bcc.w $3ea
        bcc.w H068+$3EA
L068_000003C4:
; H068+$000003C4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000003C6:
; H068+$000003C6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_000003CA:
; H068+$000003CA: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_000003CE:
; H068+$000003CE: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_000003D4:
; H068+$000003D4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000003D6:
; H068+$000003D6: 3400  move.w d0, d2
        move.w d0, d2
L068_000003D8:
; H068+$000003D8: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L068_000003DC:
; H068+$000003DC: 66000008  bne.w $3e6
        bne.w H068+$3E6
L068_000003E0:
; H068+$000003E0: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_000003E6:
; H068+$000003E6: 60000024  bra.w $40c
        bra.w H068+$40C
L068_000003EA:
; H068+$000003EA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000003EC:
; H068+$000003EC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_000003F0:
; H068+$000003F0: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_000003F4:
; H068+$000003F4: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_000003FA:
; H068+$000003FA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000003FC:
; H068+$000003FC: 3400  move.w d0, d2
        move.w d0, d2
L068_000003FE:
; H068+$000003FE: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L068_00000402:
; H068+$00000402: 62000008  bhi.w $40c
        bhi.w H068+$40C
L068_00000406:
; H068+$00000406: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_0000040C:
; H068+$0000040C: 4e75  rts 
        rts 
L068_0000040E:
; H068+$0000040E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000410:
; H068+$00000410: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000414:
; H068+$00000414: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_00000418:
; H068+$00000418: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_0000041E:
; H068+$0000041E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000420:
; H068+$00000420: 3400  move.w d0, d2
        move.w d0, d2
L068_00000422:
; H068+$00000422: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L068_00000426:
; H068+$00000426: 62000008  bhi.w $430
        bhi.w H068+$430
L068_0000042A:
; H068+$0000042A: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000430:
; H068+$00000430: 4e75  rts 
        rts 
L068_00000432:
; H068+$00000432: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000434:
; H068+$00000434: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000438:
; H068+$00000438: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_0000043C:
; H068+$0000043C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_00000442:
; H068+$00000442: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000444:
; H068+$00000444: 3400  move.w d0, d2
        move.w d0, d2
L068_00000446:
; H068+$00000446: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L068_0000044A:
; H068+$0000044A: 62000008  bhi.w $454
        bhi.w H068+$454
L068_0000044E:
; H068+$0000044E: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000454:
; H068+$00000454: 4e75  rts 
        rts 
L068_00000456:
; H068+$00000456: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000458:
; H068+$00000458: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_0000045C:
; H068+$0000045C: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_00000460:
; H068+$00000460: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_00000466:
; H068+$00000466: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000468:
; H068+$00000468: 3400  move.w d0, d2
        move.w d0, d2
L068_0000046A:
; H068+$0000046A: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L068_0000046E:
; H068+$0000046E: 62000008  bhi.w $478
        bhi.w H068+$478
L068_00000472:
; H068+$00000472: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000478:
; H068+$00000478: 4e75  rts 
        rts 
L068_0000047A:
; H068+$0000047A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000047C:
; H068+$0000047C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000480:
; H068+$00000480: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_00000484:
; H068+$00000484: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_0000048A:
; H068+$0000048A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000048C:
; H068+$0000048C: 3400  move.w d0, d2
        move.w d0, d2
L068_0000048E:
; H068+$0000048E: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L068_00000492:
; H068+$00000492: 62000008  bhi.w $49c
        bhi.w H068+$49C
L068_00000496:
; H068+$00000496: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_0000049C:
; H068+$0000049C: 4e75  rts 
        rts 
L068_0000049E:
; H068+$0000049E: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_000004A4:
; H068+$000004A4: 4e75  rts 
        rts 
L068_000004A6:
; H068+$000004A6: 4239000024e4  clr.b $24e4.l
        clr.b (H005+$24E4).l
L068_000004AC:
; H068+$000004AC: 4e75  rts 
        rts 
; Preserved bytes H068+$000004AE..$000004C0; code/data not fully classified.
        dc.w $FFF6,$FEEE,$FF5E,$FF5E,$FF82,$FF82,$FFA6,$FFCA
        dc.w $FFEE
L068_000004C0:
; H068+$000004C0: 45faffee  lea.l $4b0(pc), a2
        lea.l H068+$4B0(pc), a2
L068_000004C4:
; H068+$000004C4: 04420012  subi.w #$12, d2
        subi.w #$12, d2
L068_000004C8:
; H068+$000004C8: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L068_000004CC:
; H068+$000004CC: 6302  bls.b $4d0
        bls.b H068+$4D0
L068_000004CE:
; H068+$000004CE: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000004D0:
; H068+$000004D0: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000004D2:
; H068+$000004D2: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$04B0; indici 0..7, default -1.
L068_000004D6:
; H068+$000004D6: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_000004DA:
; H068+$000004DA: 600001e6  bra.w $6c2
        bra.w H068+$6C2
L068_000004DE:
; H068+$000004DE: 7400  moveq #$0, d2
        moveq #0, d2
L068_000004E0:
; H068+$000004E0: 142b0011  move.b $11(a3), d2
        move.b $11(a3), d2
L068_000004E4:
; H068+$000004E4: 600001c4  bra.w $6aa
        bra.w H068+$6AA
L068_000004E8:
; H068+$000004E8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000004EA:
; H068+$000004EA: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_000004EE:
; H068+$000004EE: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_000004F2:
; H068+$000004F2: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_000004F8:
; H068+$000004F8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000004FA:
; H068+$000004FA: 3400  move.w d0, d2
        move.w d0, d2
L068_000004FC:
; H068+$000004FC: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L068_00000500:
; H068+$00000500: 66000008  bne.w $50a
        bne.w H068+$50A
L068_00000504:
; H068+$00000504: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_0000050A:
; H068+$0000050A: 4e75  rts 
        rts 
L068_0000050C:
; H068+$0000050C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000050E:
; H068+$0000050E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000512:
; H068+$00000512: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_00000516:
; H068+$00000516: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_0000051C:
; H068+$0000051C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000051E:
; H068+$0000051E: 3400  move.w d0, d2
        move.w d0, d2
L068_00000520:
; H068+$00000520: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L068_00000524:
; H068+$00000524: 62000008  bhi.w $52e
        bhi.w H068+$52E
L068_00000528:
; H068+$00000528: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_0000052E:
; H068+$0000052E: 4e75  rts 
        rts 
L068_00000530:
; H068+$00000530: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000532:
; H068+$00000532: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000536:
; H068+$00000536: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_0000053A:
; H068+$0000053A: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_00000540:
; H068+$00000540: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000542:
; H068+$00000542: 3400  move.w d0, d2
        move.w d0, d2
L068_00000544:
; H068+$00000544: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L068_00000548:
; H068+$00000548: 62000008  bhi.w $552
        bhi.w H068+$552
L068_0000054C:
; H068+$0000054C: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000552:
; H068+$00000552: 4e75  rts 
        rts 
L068_00000554:
; H068+$00000554: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000556:
; H068+$00000556: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L068_0000055A:
; H068+$0000055A: 0c420033  cmpi.w #$33, d2
        cmpi.w #$33, d2
L068_0000055E:
; H068+$0000055E: 64000028  bcc.w $588
        bcc.w H068+$588
L068_00000562:
; H068+$00000562: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000564:
; H068+$00000564: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000568:
; H068+$00000568: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_0000056C:
; H068+$0000056C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_00000572:
; H068+$00000572: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000574:
; H068+$00000574: 3400  move.w d0, d2
        move.w d0, d2
L068_00000576:
; H068+$00000576: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L068_0000057A:
; H068+$0000057A: 62000008  bhi.w $584
        bhi.w H068+$584
L068_0000057E:
; H068+$0000057E: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000584:
; H068+$00000584: 60000058  bra.w $5de
        bra.w H068+$5DE
L068_00000588:
; H068+$00000588: 7400  moveq #$0, d2
        moveq #0, d2
L068_0000058A:
; H068+$0000058A: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L068_0000058E:
; H068+$0000058E: 0c420064  cmpi.w #$64, d2
        cmpi.w #$64, d2
L068_00000592:
; H068+$00000592: 64000028  bcc.w $5bc
        bcc.w H068+$5BC
L068_00000596:
; H068+$00000596: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000598:
; H068+$00000598: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_0000059C:
; H068+$0000059C: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_000005A0:
; H068+$000005A0: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_000005A6:
; H068+$000005A6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000005A8:
; H068+$000005A8: 3400  move.w d0, d2
        move.w d0, d2
L068_000005AA:
; H068+$000005AA: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L068_000005AE:
; H068+$000005AE: 62000008  bhi.w $5b8
        bhi.w H068+$5B8
L068_000005B2:
; H068+$000005B2: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_000005B8:
; H068+$000005B8: 60000024  bra.w $5de
        bra.w H068+$5DE
L068_000005BC:
; H068+$000005BC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000005BE:
; H068+$000005BE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_000005C2:
; H068+$000005C2: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_000005C6:
; H068+$000005C6: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_000005CC:
; H068+$000005CC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000005CE:
; H068+$000005CE: 3400  move.w d0, d2
        move.w d0, d2
L068_000005D0:
; H068+$000005D0: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L068_000005D4:
; H068+$000005D4: 62000008  bhi.w $5de
        bhi.w H068+$5DE
L068_000005D8:
; H068+$000005D8: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_000005DE:
; H068+$000005DE: 4e75  rts 
        rts 
L068_000005E0:
; H068+$000005E0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000005E2:
; H068+$000005E2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_000005E6:
; H068+$000005E6: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_000005EA:
; H068+$000005EA: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_000005F0:
; H068+$000005F0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000005F2:
; H068+$000005F2: 3400  move.w d0, d2
        move.w d0, d2
L068_000005F4:
; H068+$000005F4: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L068_000005F8:
; H068+$000005F8: 62000008  bhi.w $602
        bhi.w H068+$602
L068_000005FC:
; H068+$000005FC: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000602:
; H068+$00000602: 4e75  rts 
        rts 
L068_00000604:
; H068+$00000604: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000606:
; H068+$00000606: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_0000060A:
; H068+$0000060A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_0000060E:
; H068+$0000060E: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_00000614:
; H068+$00000614: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000616:
; H068+$00000616: 3400  move.w d0, d2
        move.w d0, d2
L068_00000618:
; H068+$00000618: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L068_0000061C:
; H068+$0000061C: 62000008  bhi.w $626
        bhi.w H068+$626
L068_00000620:
; H068+$00000620: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000626:
; H068+$00000626: 4e75  rts 
        rts 
L068_00000628:
; H068+$00000628: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000062A:
; H068+$0000062A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_0000062E:
; H068+$0000062E: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_00000632:
; H068+$00000632: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_00000638:
; H068+$00000638: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000063A:
; H068+$0000063A: 3400  move.w d0, d2
        move.w d0, d2
L068_0000063C:
; H068+$0000063C: 0c42000b  cmpi.w #$b, d2
        cmpi.w #$b, d2
L068_00000640:
; H068+$00000640: 62000008  bhi.w $64a
        bhi.w H068+$64A
L068_00000644:
; H068+$00000644: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_0000064A:
; H068+$0000064A: 4e75  rts 
        rts 
L068_0000064C:
; H068+$0000064C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000064E:
; H068+$0000064E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000652:
; H068+$00000652: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_00000656:
; H068+$00000656: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_0000065C:
; H068+$0000065C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000065E:
; H068+$0000065E: 3400  move.w d0, d2
        move.w d0, d2
L068_00000660:
; H068+$00000660: 0c420013  cmpi.w #$13, d2
        cmpi.w #$13, d2
L068_00000664:
; H068+$00000664: 62000008  bhi.w $66e
        bhi.w H068+$66E
L068_00000668:
; H068+$00000668: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_0000066E:
; H068+$0000066E: 4e75  rts 
        rts 
L068_00000670:
; H068+$00000670: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_00000676:
; H068+$00000676: 4e75  rts 
        rts 
L068_00000678:
; H068+$00000678: 4e75  rts 
        rts 
; Preserved bytes H068+$0000067A..$000006AA; code/data not fully classified.
        dc.w $FFFC,$FE6C,$FE6C,$FE6C,$FE6C,$FE6C,$FE90,$FE90
        dc.w $FE90,$FE90,$FE90,$FE90,$FE90,$FE90,$FEB4,$FEB4
        dc.w $FED8,$FF64,$FF64,$FF88,$FFAC,$FFAC,$FFD0,$FFF4
L068_000006AA:
; H068+$000006AA: 45faffd0  lea.l $67c(pc), a2
        lea.l H068+$67C(pc), a2
L068_000006AE:
; H068+$000006AE: 5742  subq.w #$3, d2
        subq.w #$3, d2
L068_000006B0:
; H068+$000006B0: 0c420016  cmpi.w #$16, d2
        cmpi.w #$16, d2
L068_000006B4:
; H068+$000006B4: 6302  bls.b $6b8
        bls.b H068+$6B8
L068_000006B6:
; H068+$000006B6: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000006B8:
; H068+$000006B8: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000006BA:
; H068+$000006BA: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$067C; indici 0..22, default -1.
L068_000006BE:
; H068+$000006BE: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_000006C2:
; H068+$000006C2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_000006C6:
; H068+$000006C6: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L068_000006CC:
; H068+$000006CC: 6000fc88  bra.w $356
        bra.w H068+$356
L068_000006D0:
; H068+$000006D0: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L068_000006D4:
; H068+$000006D4: 67000064  beq.w $73a
        beq.w H068+$73A
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_000006D8:
; H068+$000006D8: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L068_000006DE:
; H068+$000006DE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000006E0:
; H068+$000006E0: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_000006E2:
; H068+$000006E2: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_000006E6:
; H068+$000006E6: 1f2b0004  move.b $4(a3), -(a7)
        move.b $4(a3), -(a7)
L068_000006EA:
; H068+$000006EA: 6100f9de  bsr.w $ca
        bsr.w H068+$CA
L068_000006EE:
; H068+$000006EE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000006F0:
; H068+$000006F0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000006F2:
; H068+$000006F2: 7400  moveq #$0, d2
        moveq #0, d2
L068_000006F4:
; H068+$000006F4: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_000006F8:
; H068+$000006F8: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000006FA:
; H068+$000006FA: 45f900003ee2  lea.l $3ee2.l, a2
        lea.l (H005+$3EE2).l, a2
L068_00000700:
; H068+$00000700: 3813  move.w (a3), d4
        move.w (a3), d4
L068_00000702:
; H068+$00000702: d8722000  add.w (a2, d2.w), d4
        add.w (a2, d2.w), d4
L068_00000706:
; H068+$00000706: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L068_00000708:
; H068+$00000708: 7400  moveq #$0, d2
        moveq #0, d2
L068_0000070A:
; H068+$0000070A: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_0000070E:
; H068+$0000070E: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000710:
; H068+$00000710: 45f900003ed0  lea.l $3ed0.l, a2
        lea.l (H005+$3ED0).l, a2
L068_00000716:
; H068+$00000716: 382b0002  move.w $2(a3), d4
        move.w $2(a3), d4
L068_0000071A:
; H068+$0000071A: d8722000  add.w (a2, d2.w), d4
        add.w (a2, d2.w), d4
L068_0000071E:
; H068+$0000071E: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L068_00000720:
; H068+$00000720: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000722:
; H068+$00000722: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000726:
; H068+$00000726: 5842  addq.w #$4, d2
        addq.w #$4, d2
L068_00000728:
; H068+$00000728: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L068_0000072E:
; H068+$0000072E: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L068_00000732:
; H068+$00000732: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L068_00000734:
; H068+$00000734: 6100f994  bsr.w $ca
        bsr.w H068+$CA
L068_00000738:
; H068+$00000738: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000073A:
; H068+$0000073A: 102dfffb  move.b -$5(a5), d0
        move.b -$5(a5), d0
L068_0000073E:
; H068+$0000073E: 60000002  bra.w $742
        bra.w H068+$742
L068_00000742:
; H068+$00000742: 4e5d  unlk a5
        unlk a5
L068_00000744:
; H068+$00000744: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_00000746:
; H068+$00000746: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_00000748 [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; richiama H062+$156C.
;   - Richiama H062+$156C.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party); H005+$281C (inizio del blocco coordinate/vista).
; Chiamanti diretti: H068+$13D0
; --------------------------------------------------------------------------
L068_00000748:
; H068+$00000748: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_0000074A:
; H068+$0000074A: 287af954  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_0000074E:
; H068+$0000074E: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L068_00000752:
; H068+$00000752: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
; STATO: H005+$3364 = testa della lista del party
L068_00000756:
; H068+$00000756: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L068_0000075E:
; H068+$0000075E: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L068_00000762:
; H068+$00000762: 67000048  beq.w $7ac
        beq.w H068+$7AC
L068_00000766:
; H068+$00000766: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L068_0000076A:
; H068+$0000076A: 66000040  bne.w $7ac
        bne.w H068+$7AC
L068_0000076E:
; H068+$0000076E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_00000772:
; H068+$00000772: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000774:
; H068+$00000774: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000778:
; H068+$00000778: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
; -> H062+$156C (sub_H062_0000156C)
L068_0000077C:
; H068+$0000077C: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L068_00000782:
; H068+$00000782: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000784:
; H068+$00000784: 3400  move.w d0, d2
        move.w d0, d2
L068_00000786:
; H068+$00000786: 7800  moveq #$0, d4
        moveq #0, d4
L068_00000788:
; H068+$00000788: 182b00e1  move.b $e1(a3), d4
        move.b $e1(a3), d4
L068_0000078C:
; H068+$0000078C: b444  cmp.w d4, d2
        cmp.w d4, d2
L068_0000078E:
; H068+$0000078E: 62000010  bhi.w $7a0
        bhi.w H068+$7A0
L068_00000792:
; H068+$00000792: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L068_00000796:
; H068+$00000796: 66000008  bne.w $7a0
        bne.w H068+$7A0
L068_0000079A:
; H068+$0000079A: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L068_000007A0:
; H068+$000007A0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_000007A4:
; H068+$000007A4: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L068_000007AA:
; H068+$000007AA: 60b2  bra.b $75e
        bra.b H068+$75E
L068_000007AC:
; H068+$000007AC: 4239000024e5  clr.b $24e5.l
        clr.b (H005+$24E5).l
L068_000007B2:
; H068+$000007B2: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L068_000007B6:
; H068+$000007B6: 67000064  beq.w $81c
        beq.w H068+$81C
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_000007BA:
; H068+$000007BA: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L068_000007C0:
; H068+$000007C0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000007C2:
; H068+$000007C2: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_000007C4:
; H068+$000007C4: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_000007C8:
; H068+$000007C8: 1f2b0004  move.b $4(a3), -(a7)
        move.b $4(a3), -(a7)
L068_000007CC:
; H068+$000007CC: 6100f8fc  bsr.w $ca
        bsr.w H068+$CA
L068_000007D0:
; H068+$000007D0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000007D2:
; H068+$000007D2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000007D4:
; H068+$000007D4: 7400  moveq #$0, d2
        moveq #0, d2
L068_000007D6:
; H068+$000007D6: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_000007DA:
; H068+$000007DA: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000007DC:
; H068+$000007DC: 45f900003ee2  lea.l $3ee2.l, a2
        lea.l (H005+$3EE2).l, a2
L068_000007E2:
; H068+$000007E2: 3813  move.w (a3), d4
        move.w (a3), d4
L068_000007E4:
; H068+$000007E4: d8722000  add.w (a2, d2.w), d4
        add.w (a2, d2.w), d4
L068_000007E8:
; H068+$000007E8: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L068_000007EA:
; H068+$000007EA: 7400  moveq #$0, d2
        moveq #0, d2
L068_000007EC:
; H068+$000007EC: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_000007F0:
; H068+$000007F0: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000007F2:
; H068+$000007F2: 45f900003ed0  lea.l $3ed0.l, a2
        lea.l (H005+$3ED0).l, a2
L068_000007F8:
; H068+$000007F8: 382b0002  move.w $2(a3), d4
        move.w $2(a3), d4
L068_000007FC:
; H068+$000007FC: d8722000  add.w (a2, d2.w), d4
        add.w (a2, d2.w), d4
L068_00000800:
; H068+$00000800: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L068_00000802:
; H068+$00000802: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000804:
; H068+$00000804: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000808:
; H068+$00000808: 5842  addq.w #$4, d2
        addq.w #$4, d2
L068_0000080A:
; H068+$0000080A: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L068_00000810:
; H068+$00000810: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L068_00000814:
; H068+$00000814: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L068_00000816:
; H068+$00000816: 6100f8b2  bsr.w $ca
        bsr.w H068+$CA
L068_0000081A:
; H068+$0000081A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000081C:
; H068+$0000081C: 102dfffb  move.b -$5(a5), d0
        move.b -$5(a5), d0
L068_00000820:
; H068+$00000820: 60000002  bra.w $824
        bra.w H068+$824
L068_00000824:
; H068+$00000824: 4e5d  unlk a5
        unlk a5
L068_00000826:
; H068+$00000826: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_00000828:
; H068+$00000828: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_0000082A [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H068+$08B2, H068+$0906
; --------------------------------------------------------------------------
L068_0000082A:
; H068+$0000082A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_0000082C:
; H068+$0000082C: 287af872  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00000830:
; H068+$00000830: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L068_00000834:
; H068+$00000834: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L068_00000838:
; H068+$00000838: 0c6d0039fffe  cmpi.w #$39, -$2(a5)
        cmpi.w #$39, -$2(a5)
L068_0000083E:
; H068+$0000083E: 62000026  bhi.w $866
        bhi.w H068+$866
L068_00000842:
; H068+$00000842: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L068_00000846:
; H068+$00000846: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L068_0000084A:
; H068+$0000084A: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L068_0000084E:
; H068+$0000084E: 7800  moveq #$0, d4
        moveq #0, d4
L068_00000850:
; H068+$00000850: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L068_00000854:
; H068+$00000854: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000856:
; H068+$00000856: 142d0010  move.b $10(a5), d2
        move.b $10(a5), d2
L068_0000085A:
; H068+$0000085A: b842  cmp.w d2, d4
        cmp.w d2, d4
L068_0000085C:
; H068+$0000085C: 67000008  beq.w $866
        beq.w H068+$866
L068_00000860:
; H068+$00000860: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L068_00000864:
; H068+$00000864: 60d2  bra.b $838
        bra.b H068+$838
L068_00000866:
; H068+$00000866: 0c6d0039fffe  cmpi.w #$39, -$2(a5)
        cmpi.w #$39, -$2(a5)
L068_0000086C:
; H068+$0000086C: 62000010  bhi.w $87e
        bhi.w H068+$87E
L068_00000870:
; H068+$00000870: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L068_00000874:
; H068+$00000874: 1002  move.b d2, d0
        move.b d2, d0
L068_00000876:
; H068+$00000876: 6000000e  bra.w $886
        bra.w H068+$886
; Preserved bytes H068+$0000087A..$0000087E; code/data not fully classified.
        dc.w $6000,$000A
L068_0000087E:
; H068+$0000087E: 303c00ff  move.w #$ff, d0
        move.w #$ff, d0
L068_00000882:
; H068+$00000882: 60000002  bra.w $886
        bra.w H068+$886
L068_00000886:
; H068+$00000886: 4e5d  unlk a5
        unlk a5
L068_00000888:
; H068+$00000888: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_0000088A:
; H068+$0000088A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L068_0000088C:
; H068+$0000088C: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L068_0000088E:
; H068+$0000088E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_00000890 [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; opera su H005+$3364 (testa della lista del party).
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H068+$12FE, H068+$149A, H068+$08F0
; --------------------------------------------------------------------------
L068_00000890:
; H068+$00000890: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_00000892:
; H068+$00000892: 287af80c  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00000896:
; H068+$00000896: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
; STATO: H005+$3364 = testa della lista del party
L068_0000089A:
; H068+$0000089A: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L068_000008A2:
; H068+$000008A2: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L068_000008A6:
; H068+$000008A6: 67000028  beq.w $8d0
        beq.w H068+$8D0
L068_000008AA:
; H068+$000008AA: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L068_000008AE:
; H068+$000008AE: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L068_000008B2:
; H068+$000008B2: 6100ff76  bsr.w $82a
        bsr.w H068+$82A
L068_000008B6:
; H068+$000008B6: 1400  move.b d0, d2
        move.b d0, d2
L068_000008B8:
; H068+$000008B8: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L068_000008BC:
; H068+$000008BC: 0c4200ff  cmpi.w #$ff, d2
        cmpi.w #$ff, d2
L068_000008C0:
; H068+$000008C0: 6600000e  bne.w $8d0
        bne.w H068+$8D0
L068_000008C4:
; H068+$000008C4: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_000008C8:
; H068+$000008C8: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L068_000008CE:
; H068+$000008CE: 60d2  bra.b $8a2
        bra.b H068+$8A2
L068_000008D0:
; H068+$000008D0: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L068_000008D4:
; H068+$000008D4: 60000002  bra.w $8d8
        bra.w H068+$8D8
L068_000008D8:
; H068+$000008D8: 4e5d  unlk a5
        unlk a5
L068_000008DA:
; H068+$000008DA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_000008DC:
; H068+$000008DC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L068_000008DE:
; H068+$000008DE: 548f  addq.l #$2, a7
        addq.l #$2, a7
L068_000008E0:
; H068+$000008E0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_000008E2 [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H068+$13DE, H068+$1574
; --------------------------------------------------------------------------
L068_000008E2:
; H068+$000008E2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_000008E4:
; H068+$000008E4: 287af7ba  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_000008E8:
; H068+$000008E8: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L068_000008EC:
; H068+$000008EC: 1f3c001f  move.b #$1f, -(a7)
        move.b #$1f, -(a7)
L068_000008F0:
; H068+$000008F0: 619e  bsr.b $890
        bsr.b H068+$890
L068_000008F2:
; H068+$000008F2: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L068_000008F6:
; H068+$000008F6: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L068_000008FA:
; H068+$000008FA: 6700002a  beq.w $926
        beq.w H068+$926
L068_000008FE:
; H068+$000008FE: 1f3c001f  move.b #$1f, -(a7)
        move.b #$1f, -(a7)
L068_00000902:
; H068+$00000902: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L068_00000906:
; H068+$00000906: 6100ff22  bsr.w $82a
        bsr.w H068+$82A
L068_0000090A:
; H068+$0000090A: 1400  move.b d0, d2
        move.b d0, d2
L068_0000090C:
; H068+$0000090C: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L068_00000910:
; H068+$00000910: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L068_00000914:
; H068+$00000914: 47eb001e  lea.l $1e(a3), a3
        lea.l $1e(a3), a3
L068_00000918:
; H068+$00000918: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L068_0000091C:
; H068+$0000091C: 7001  moveq #$1, d0
        moveq #1, d0
L068_0000091E:
; H068+$0000091E: 6000000c  bra.w $92c
        bra.w H068+$92C
; Preserved bytes H068+$00000922..$00000926; code/data not fully classified.
        dc.w $6000,$0008
L068_00000926:
; H068+$00000926: 7000  moveq #$0, d0
        moveq #0, d0
L068_00000928:
; H068+$00000928: 60000002  bra.w $92c
        bra.w H068+$92C
L068_0000092C:
; H068+$0000092C: 4e5d  unlk a5
        unlk a5
L068_0000092E:
; H068+$0000092E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_00000930:
; H068+$00000930: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_00000932 [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; richiama H011+$09C8.
;   - Richiama H011+$09C8.
;   - Usa lo stato globale: H005+$281C (inizio del blocco coordinate/vista); H005+$3E00 (puntatore stato persistente B, 2048 byte).
; Chiamanti diretti: H068+$0EB6
; --------------------------------------------------------------------------
L068_00000932:
; H068+$00000932: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_00000934:
; H068+$00000934: 287af76a  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00000938:
; H068+$00000938: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_0000093C:
; H068+$0000093C: 3b790000281cfffe  move.w $281c.l, -$2(a5)
        move.w (H005+$281C).l, -$2(a5)
L068_00000944:
; H068+$00000944: 3b790000281efffc  move.w $281e.l, -$4(a5)
        move.w (H005+$281E).l, -$4(a5)
L068_0000094C:
; H068+$0000094C: 7400  moveq #$0, d2
        moveq #0, d2
L068_0000094E:
; H068+$0000094E: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L068_00000954:
; H068+$00000954: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000958:
; H068+$00000958: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_0000095E:
; H068+$0000095E: 426b05aa  clr.w $5aa(a3)
        clr.w $5aa(a3)
L068_00000962:
; H068+$00000962: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L068_00000966:
; H068+$00000966: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L068_0000096A:
; H068+$0000096A: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
; -> H011+$09C8 (sub_H011_000009C8)
L068_0000096E:
; H068+$0000096E: 4eb9000009c8  jsr $9c8.l
        jsr (H011+$9C8).l
L068_00000974:
; H068+$00000974: 3400  move.w d0, d2
        move.w d0, d2
L068_00000976:
; H068+$00000976: 4a42  tst.w d2
        tst.w d2
L068_00000978:
; H068+$00000978: 6700009a  beq.w $a14
        beq.w H068+$A14
L068_0000097C:
; H068+$0000097C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L068_00000980:
; H068+$00000980: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000982:
; H068+$00000982: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L068_00000988:
; H068+$00000988: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L068_0000098C:
; H068+$0000098C: d96dfffe  add.w d4, -$2(a5)
        add.w d4, -$2(a5)
L068_00000990:
; H068+$00000990: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L068_00000994:
; H068+$00000994: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000996:
; H068+$00000996: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L068_0000099C:
; H068+$0000099C: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L068_000009A0:
; H068+$000009A0: d96dfffc  add.w d4, -$4(a5)
        add.w d4, -$4(a5)
L068_000009A4:
; H068+$000009A4: 0c6d000ffffe  cmpi.w #$f, -$2(a5)
        cmpi.w #$f, -$2(a5)
L068_000009AA:
; H068+$000009AA: 6f000016  ble.w $9c2
        ble.w H068+$9C2
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_000009AE:
; H068+$000009AE: 33fc000f0000281c  move.w #$f, $281c.l
        move.w #$f, (H005+$281C).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_000009B6:
; H068+$000009B6: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_000009BC:
; H068+$000009BC: 377c000105aa  move.w #$1, $5aa(a3)
        move.w #$1, $5aa(a3)
L068_000009C2:
; H068+$000009C2: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L068_000009C6:
; H068+$000009C6: 6c000014  bge.w $9dc
        bge.w H068+$9DC
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_000009CA:
; H068+$000009CA: 42790000281c  clr.w $281c.l
        clr.w (H005+$281C).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_000009D0:
; H068+$000009D0: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_000009D6:
; H068+$000009D6: 377c000105aa  move.w #$1, $5aa(a3)
        move.w #$1, $5aa(a3)
L068_000009DC:
; H068+$000009DC: 0c6d000ffffc  cmpi.w #$f, -$4(a5)
        cmpi.w #$f, -$4(a5)
L068_000009E2:
; H068+$000009E2: 6f000016  ble.w $9fa
        ble.w H068+$9FA
L068_000009E6:
; H068+$000009E6: 33fc000f0000281e  move.w #$f, $281e.l
        move.w #$f, (H005+$281E).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_000009EE:
; H068+$000009EE: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_000009F4:
; H068+$000009F4: 377c000105aa  move.w #$1, $5aa(a3)
        move.w #$1, $5aa(a3)
L068_000009FA:
; H068+$000009FA: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L068_000009FE:
; H068+$000009FE: 6c000014  bge.w $a14
        bge.w H068+$A14
L068_00000A02:
; H068+$00000A02: 42790000281e  clr.w $281e.l
        clr.w (H005+$281E).l
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000A08:
; H068+$00000A08: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_00000A0E:
; H068+$00000A0E: 377c000105aa  move.w #$1, $5aa(a3)
        move.w #$1, $5aa(a3)
L068_00000A14:
; H068+$00000A14: 4e5d  unlk a5
        unlk a5
L068_00000A16:
; H068+$00000A16: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_00000A18:
; H068+$00000A18: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_00000A1A [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; richiama H043+$190E, H036+$0034, H011+$01AA, H029+$0312.
;   - Richiama H043+$190E.
;   - Richiama H036+$0034.
;   - Richiama H011+$01AA.
;   - Richiama H029+$0312.
;   - Richiama H011+$04E2.
;   - Richiama H029+$0354.
;   - Richiama H058+$064A.
;   - Usa lo stato globale: H005+$281C (inizio del blocco coordinate/vista); H005+$3E00 (puntatore stato persistente B, 2048 byte).
; Chiamanti diretti: H068+$15EA
; --------------------------------------------------------------------------
L068_00000A1A:
; H068+$00000A1A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_00000A1C:
; H068+$00000A1C: 287af682  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00000A20:
; H068+$00000A20: 4e550000  link.w a5, #$0
        link.w a5, #$0
L068_00000A24:
; H068+$00000A24: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L068_00000A28:
; H068+$00000A28: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L068_00000A2E:
; H068+$00000A2E: 7402  moveq #$2, d2
        moveq #2, d2
L068_00000A30:
; H068+$00000A30: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H036+$0034 (wrapper_Delay)
L068_00000A32:
; H068+$00000A32: 4eb900000034  jsr $34.l
        jsr (H036+$34).l
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_00000A38:
; H068+$00000A38: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L068_00000A3E:
; H068+$00000A3E: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000A40:
; H068+$00000A40: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000A44:
; H068+$00000A44: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000A46:
; H068+$00000A46: 45f900003ee2  lea.l $3ee2.l, a2
        lea.l (H005+$3EE2).l, a2
L068_00000A4C:
; H068+$00000A4C: 38322000  move.w (a2, d2.w), d4
        move.w (a2, d2.w), d4
L068_00000A50:
; H068+$00000A50: d953  add.w d4, (a3)
        add.w d4, (a3)
L068_00000A52:
; H068+$00000A52: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000A54:
; H068+$00000A54: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000A58:
; H068+$00000A58: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000A5A:
; H068+$00000A5A: 45f900003ed0  lea.l $3ed0.l, a2
        lea.l (H005+$3ED0).l, a2
L068_00000A60:
; H068+$00000A60: 38322000  move.w (a2, d2.w), d4
        move.w (a2, d2.w), d4
L068_00000A64:
; H068+$00000A64: d96b0002  add.w d4, $2(a3)
        add.w d4, $2(a3)
L068_00000A68:
; H068+$00000A68: 4a53  tst.w (a3)
        tst.w (a3)
L068_00000A6A:
; H068+$00000A6A: 6c000006  bge.w $a72
        bge.w H068+$A72
L068_00000A6E:
; H068+$00000A6E: 36bc000f  move.w #$f, (a3)
        move.w #$f, (a3)
L068_00000A72:
; H068+$00000A72: 0c53000f  cmpi.w #$f, (a3)
        cmpi.w #$f, (a3)
L068_00000A76:
; H068+$00000A76: 6f000004  ble.w $a7c
        ble.w H068+$A7C
L068_00000A7A:
; H068+$00000A7A: 4253  clr.w (a3)
        clr.w (a3)
L068_00000A7C:
; H068+$00000A7C: 4a6b0002  tst.w $2(a3)
        tst.w $2(a3)
L068_00000A80:
; H068+$00000A80: 6c000008  bge.w $a8a
        bge.w H068+$A8A
L068_00000A84:
; H068+$00000A84: 377c000f0002  move.w #$f, $2(a3)
        move.w #$f, $2(a3)
L068_00000A8A:
; H068+$00000A8A: 0c6b000f0002  cmpi.w #$f, $2(a3)
        cmpi.w #$f, $2(a3)
L068_00000A90:
; H068+$00000A90: 6f000006  ble.w $a98
        ble.w H068+$A98
L068_00000A94:
; H068+$00000A94: 426b0002  clr.w $2(a3)
        clr.w $2(a3)
L068_00000A98:
; H068+$00000A98: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000A9A:
; H068+$00000A9A: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000A9C:
; H068+$00000A9C: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000AA0:
; H068+$00000AA0: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000AA2:
; H068+$00000AA2: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000AA6:
; H068+$00000AA6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L068_00000AA8:
; H068+$00000AA8: 4eb9000001aa  jsr $1aa.l
        jsr (H011+$1AA).l
L068_00000AAE:
; H068+$00000AAE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000AB0:
; H068+$00000AB0: 17400005  move.b d0, $5(a3)
        move.b d0, $5(a3)
L068_00000AB4:
; H068+$00000AB4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000AB6:
; H068+$00000AB6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L068_00000ABA:
; H068+$00000ABA: 4879000024e4  pea.l $24e4.l
        pea.l (H005+$24E4).l
L068_00000AC0:
; H068+$00000AC0: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L068_00000AC4:
; H068+$00000AC4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H029+$0312 (sub_H029_00000312)
L068_00000AC8:
; H068+$00000AC8: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L068_00000ACE:
; H068+$00000ACE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000AD0:
; H068+$00000AD0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000AD2:
; H068+$00000AD2: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000AD4:
; H068+$00000AD4: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
; -> H011+$04E2 (sub_H011_000004E2)
L068_00000AD8:
; H068+$00000AD8: 4eb9000004e2  jsr $4e2.l
        jsr (H011+$4E2).l
L068_00000ADE:
; H068+$00000ADE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000AE0:
; H068+$00000AE0: 17400006  move.b d0, $6(a3)
        move.b d0, $6(a3)
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000AE4:
; H068+$00000AE4: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_00000AEA:
; H068+$00000AEA: 342b0594  move.w $594(a3), d2
        move.w $594(a3), d2
L068_00000AEE:
; H068+$00000AEE: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L068_00000AF0:
; H068+$00000AF0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L068_00000AF4:
; H068+$00000AF4: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L068_00000AFA:
; H068+$00000AFA: 1400  move.b d0, d2
        move.b d0, d2
L068_00000AFC:
; H068+$00000AFC: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L068_00000B00:
; H068+$00000B00: 4a42  tst.w d2
        tst.w d2
L068_00000B02:
; H068+$00000B02: 63000014  bls.w $b18
        bls.w H068+$B18
L068_00000B06:
; H068+$00000B06: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000B0A:
; H068+$00000B0A: 1f3c0002  move.b #$2, -(a7)
        move.b #$2, -(a7)
; -> H058+$064A (sub_H058_0000064A)
L068_00000B0E:
; H068+$00000B0E: 4eb90000064a  jsr $64a.l
        jsr (H058+$64A).l
L068_00000B14:
; H068+$00000B14: 60000010  bra.w $b26
        bra.w H068+$B26
L068_00000B18:
; H068+$00000B18: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000B1C:
; H068+$00000B1C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H058+$064A (sub_H058_0000064A)
L068_00000B20:
; H068+$00000B20: 4eb90000064a  jsr $64a.l
        jsr (H058+$64A).l
L068_00000B26:
; H068+$00000B26: 4e5d  unlk a5
        unlk a5
L068_00000B28:
; H068+$00000B28: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_00000B2A:
; H068+$00000B2A: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H068_00000B2C [parziale]
; Scopo: Routine del modulo esplorazione, scelte di movimento, porte e azioni del party; richiama H069+$00A8, H069+$0012, H058+$064A.
;   - Richiama H069+$00A8.
;   - Richiama H069+$0012.
;   - Richiama H058+$064A.
;   - Usa lo stato globale: H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H068+$161C
; --------------------------------------------------------------------------
L068_00000B2C:
; H068+$00000B2C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_00000B2E:
; H068+$00000B2E: 287af570  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00000B32:
; H068+$00000B32: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
; -> H069+$00A8 (sub_H069_000000A8)
L068_00000B36:
; H068+$00000B36: 4eb9000000a8  jsr $a8.l
        jsr (H069+$A8).l
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000B3C:
; H068+$00000B3C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000B42:
; H068+$00000B42: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L068_00000B48:
; H068+$00000B48: 356b018601e0  move.w $186(a3), $1e0(a2)
        move.w $186(a3), $1e0(a2)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000B4E:
; H068+$00000B4E: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000B54:
; H068+$00000B54: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L068_00000B5A:
; H068+$00000B5A: 356b018801e2  move.w $188(a3), $1e2(a2)
        move.w $188(a3), $1e2(a2)
L068_00000B60:
; H068+$00000B60: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000B62:
; H068+$00000B62: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L068_00000B68:
; H068+$00000B68: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000B6A:
; H068+$00000B6A: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000B70:
; H068+$00000B70: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L068_00000B76:
; H068+$00000B76: 382a0186  move.w $186(a2), d4
        move.w $186(a2), d4
L068_00000B7A:
; H068+$00000B7A: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L068_00000B7E:
; H068+$00000B7E: 3b44fffc  move.w d4, -$4(a5)
        move.w d4, -$4(a5)
L068_00000B82:
; H068+$00000B82: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000B84:
; H068+$00000B84: 143900002820  move.b $2820.l, d2
        move.b (H005+$2820).l, d2
L068_00000B8A:
; H068+$00000B8A: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000B8C:
; H068+$00000B8C: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000B92:
; H068+$00000B92: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L068_00000B98:
; H068+$00000B98: 382a0188  move.w $188(a2), d4
        move.w $188(a2), d4
L068_00000B9C:
; H068+$00000B9C: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L068_00000BA0:
; H068+$00000BA0: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L068_00000BA4:
; H068+$00000BA4: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L068_00000BA8:
; H068+$00000BA8: 6c000006  bge.w $bb0
        bge.w H068+$BB0
L068_00000BAC:
; H068+$00000BAC: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L068_00000BB0:
; H068+$00000BB0: 0c6d0025fffc  cmpi.w #$25, -$4(a5)
        cmpi.w #$25, -$4(a5)
L068_00000BB6:
; H068+$00000BB6: 6f000008  ble.w $bc0
        ble.w H068+$BC0
L068_00000BBA:
; H068+$00000BBA: 3b7c0025fffc  move.w #$25, -$4(a5)
        move.w #$25, -$4(a5)
L068_00000BC0:
; H068+$00000BC0: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L068_00000BC4:
; H068+$00000BC4: 6c000006  bge.w $bcc
        bge.w H068+$BCC
L068_00000BC8:
; H068+$00000BC8: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L068_00000BCC:
; H068+$00000BCC: 0c6d000efffa  cmpi.w #$e, -$6(a5)
        cmpi.w #$e, -$6(a5)
L068_00000BD2:
; H068+$00000BD2: 6f000008  ble.w $bdc
        ble.w H068+$BDC
L068_00000BD6:
; H068+$00000BD6: 3b7c000efffa  move.w #$e, -$6(a5)
        move.w #$e, -$6(a5)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000BDC:
; H068+$00000BDC: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L068_00000BE2:
; H068+$00000BE2: 376dfffc0186  move.w -$4(a5), $186(a3)
        move.w -$4(a5), $186(a3)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000BE8:
; H068+$00000BE8: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L068_00000BEE:
; H068+$00000BEE: 376dfffa0188  move.w -$6(a5), $188(a3)
        move.w -$6(a5), $188(a3)
; -> H069+$0012 (sub_H069_00000012)
L068_00000BF4:
; H068+$00000BF4: 4eb900000012  jsr $12.l
        jsr (H069+$12).l
L068_00000BFA:
; H068+$00000BFA: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L068_00000BFE:
; H068+$00000BFE: 1f3c0003  move.b #$3, -(a7)
        move.b #$3, -(a7)
; -> H058+$064A (sub_H058_0000064A)
L068_00000C02:
; H068+$00000C02: 4eb90000064a  jsr $64a.l
        jsr (H058+$64A).l
L068_00000C08:
; H068+$00000C08: 4e5d  unlk a5
        unlk a5
L068_00000C0A:
; H068+$00000C0A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_00000C0C:
; H068+$00000C0C: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Exploration_CommandMenu [verificato]
; Scopo: Legge e smista il comando del menu di esplorazione.
;   - Propone Move, Area, Cast, View, Encamp, Search e Look.
;   - Richiama il menu UI e i sottosistemi mappa, personaggio e riposo.
;   - La routine restituisce la scelta al ciclo scenario.
; Chiamanti diretti: H012+$32FE, H012+$33F2
; --------------------------------------------------------------------------
L068_00000C0E:
; H068+$00000C0E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_00000C10:
; H068+$00000C10: 287af48e  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00000C14:
; H068+$00000C14: 4e55ffc6  link.w a5, #$ffc6
        link.w a5, #$ffc6
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000C18:
; H068+$00000C18: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_00000C1E:
; H068+$00000C1E: 426b0592  clr.w $592(a3)
        clr.w $592(a3)
L068_00000C22:
; H068+$00000C22: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L068_00000C24:
; H068+$00000C24: 143900003de3  move.b $3de3.l, d2
        move.b (H005+$3DE3).l, d2
L068_00000C2A:
; H068+$00000C2A: 600005b4  bra.w $11e0
        bra.w H068+$11E0
L068_00000C2E:
; H068+$00000C2E: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L068_00000C32:
; H068+$00000C32: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L068_00000C36:
; H068+$00000C36: 4a39000024b0  tst.b $24b0.l
        tst.b (H005+$24B0).l
L068_00000C3C:
; H068+$00000C3C: 660001fc  bne.w $e3a
        bne.w H068+$E3A
L068_00000C40:
; H068+$00000C40: 4267  clr.w -(a7)
        clr.w -(a7)
L068_00000C42:
; H068+$00000C42: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L068_00000C46:
; H068+$00000C46: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L068_00000C4A:
; H068+$00000C4A: 486c0002  pea.l $2(a4)
        pea.l $2(a4)
L068_00000C4E:
; H068+$00000C4E: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L068_00000C52:
; H068+$00000C52: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L068_00000C56:
; H068+$00000C56: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L068_00000C5A:
; H068+$00000C5A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L068_00000C5E:
; H068+$00000C5E: 4227  clr.b -(a7)
        clr.b -(a7)
L068_00000C60:
; H068+$00000C60: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L068_00000C64:
; H068+$00000C64: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L068_00000C6A:
; H068+$00000C6A: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L068_00000C6E:
; H068+$00000C6E: 4a2dfffc  tst.b -$4(a5)
        tst.b -$4(a5)
L068_00000C72:
; H068+$00000C72: 660001a6  bne.w $e1a
        bne.w H068+$E1A
L068_00000C76:
; H068+$00000C76: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000C78:
; H068+$00000C78: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L068_00000C7C:
; H068+$00000C7C: 6000017e  bra.w $dfc
        bra.w H068+$DFC
; -> H008+$139E (sub_H008_0000139E)
L068_00000C80:
; H068+$00000C80: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
L068_00000C86:
; H068+$00000C86: 13fc0001000024b0  move.b #$1, $24b0.l
        move.b #$1, (H005+$24B0).l
L068_00000C8E:
; H068+$00000C8E: 4e75  rts 
        rts 
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00000C90:
; H068+$00000C90: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L068_00000C96:
; H068+$00000C96: 4a6b01f6  tst.w $1f6(a3)
        tst.w $1f6(a3)
L068_00000C9A:
; H068+$00000C9A: 6700002c  beq.w $cc8
        beq.w H068+$CC8
L068_00000C9E:
; H068+$00000C9E: 247900000008  movea.l $8.l, a2
        movea.l (H015+$8).l, a2
L068_00000CA4:
; H068+$00000CA4: 266a0008  movea.l $8(a2), a3
        movea.l $8(a2), a3
L068_00000CA8:
; H068+$00000CA8: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L068_00000CAC:
; H068+$00000CAC: 4853  pea.l (a3)
        pea.l (a3)
L068_00000CAE:
; H068+$00000CAE: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L068_00000CB2:
; H068+$00000CB2: 487900002358  pea.l $2358.l
        pea.l (H005+$2358).l
; -> H026+$0106 (sub_H026_00000106)
L068_00000CB8:
; H068+$00000CB8: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L068_00000CBE:
; H068+$00000CBE: 1400  move.b d0, d2
        move.b d0, d2
L068_00000CC0:
; H068+$00000CC0: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L068_00000CC4:
; H068+$00000CC4: 66000034  bne.w $cfa
        bne.w H068+$CFA
L068_00000CC8:
; H068+$00000CC8: 4a3900002825  tst.b $2825.l
        tst.b (H005+$2825).l
L068_00000CCE:
; H068+$00000CCE: 57c2  seq.b d2
        seq.b d2
L068_00000CD0:
; H068+$00000CD0: 4402  neg.b d2
        neg.b d2
L068_00000CD2:
; H068+$00000CD2: 13c200002825  move.b d2, $2825.l
        move.b d2, (H005+$2825).l
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_00000CD8:
; H068+$00000CD8: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L068_00000CDE:
; H068+$00000CDE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000CE0:
; H068+$00000CE0: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000CE2:
; H068+$00000CE2: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000CE6:
; H068+$00000CE6: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000CE8:
; H068+$00000CE8: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000CEC:
; H068+$00000CEC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$0B78 (sub_H011_00000B78)
L068_00000CEE:
; H068+$00000CEE: 4eb900000b78  jsr $b78.l
        jsr (H011+$B78).l
L068_00000CF4:
; H068+$00000CF4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000CF6:
; H068+$00000CF6: 60000016  bra.w $d0e
        bra.w H068+$D0E
L068_00000CFA:
; H068+$00000CFA: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L068_00000CFE:
; H068+$00000CFE: 486c0029  pea.l $29(a4)
        pea.l $29(a4)
L068_00000D02:
; H068+$00000D02: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L068_00000D06:
; H068+$00000D06: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H030+$0AD2 (sub_H030_00000AD2)
L068_00000D08:
; H068+$00000D08: 4eb900000ad2  jsr $ad2.l
        jsr (H030+$AD2).l
L068_00000D0E:
; H068+$00000D0E: 4e75  rts 
        rts 
; STATO: H005+$3368 = personaggio corrente
L068_00000D10:
; H068+$00000D10: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L068_00000D16:
; H068+$00000D16: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L068_00000D1A:
; H068+$00000D1A: 66000010  bne.w $d2c
        bne.w H068+$D2C
L068_00000D1E:
; H068+$00000D1E: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
; -> H057+$0C04 (sub_H057_00000C04)
L068_00000D26:
; H068+$00000D26: 4eb900000c04  jsr $c04.l
        jsr (H057+$C04).l
L068_00000D2C:
; H068+$00000D2C: 4e75  rts 
        rts 
L068_00000D2E:
; H068+$00000D2E: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L068_00000D36:
; H068+$00000D36: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; -> H065+$196E (sub_H065_0000196E)
L068_00000D3A:
; H068+$00000D3A: 4eb90000196e  jsr $196e.l
        jsr (H065+$196E).l
L068_00000D40:
; H068+$00000D40: 4e75  rts 
        rts 
L068_00000D42:
; H068+$00000D42: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L068_00000D48:
; H068+$00000D48: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L068_00000D50:
; H068+$00000D50: 4e75  rts 
        rts 
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000D52:
; H068+$00000D52: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_00000D58:
; H068+$00000D58: 342b0594  move.w $594(a3), d2
        move.w $594(a3), d2
L068_00000D5C:
; H068+$00000D5C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L068_00000D5E:
; H068+$00000D5E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
; -> H029+$0376 (trampoline_H029_0390)
L068_00000D62:
; H068+$00000D62: 4eb900000376  jsr $376.l
        jsr (H029+$376).l
L068_00000D68:
; H068+$00000D68: 1400  move.b d0, d2
        move.b d0, d2
L068_00000D6A:
; H068+$00000D6A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000D6E:
; H068+$00000D6E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_00000D74:
; H068+$00000D74: 37420594  move.w d2, $594(a3)
        move.w d2, $594(a3)
; -> H063+$33A0 (trampoline_H063_3652)
L068_00000D78:
; H068+$00000D78: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_00000D7E:
; H068+$00000D7E: 4e75  rts 
        rts 
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000D80:
; H068+$00000D80: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_00000D86:
; H068+$00000D86: 342b0594  move.w $594(a3), d2
        move.w $594(a3), d2
L068_00000D8A:
; H068+$00000D8A: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L068_00000D8C:
; H068+$00000D8C: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H029+$039A (trampoline_H029_03B2)
L068_00000D90:
; H068+$00000D90: 4eb90000039a  jsr $39a.l
        jsr (H029+$39A).l
L068_00000D96:
; H068+$00000D96: 1400  move.b d0, d2
        move.b d0, d2
L068_00000D98:
; H068+$00000D98: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00000D9C:
; H068+$00000D9C: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L068_00000DA2:
; H068+$00000DA2: 37420594  move.w d2, $594(a3)
        move.w d2, $594(a3)
; -> H063+$33A0 (trampoline_H063_3652)
L068_00000DA6:
; H068+$00000DA6: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_00000DAC:
; H068+$00000DAC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00000DB0:
; H068+$00000DB0: 1f3c0002  move.b #$2, -(a7)
        move.b #$2, -(a7)
; -> H058+$064A (sub_H058_0000064A)
L068_00000DB4:
; H068+$00000DB4: 4eb90000064a  jsr $64a.l
        jsr (H058+$64A).l
; STATO: H005+$3DEA = PC logico ECL
L068_00000DBA:
; H068+$00000DBA: 33f900003df200003dea  move.w $3df2.l, $3dea.l
        move.w (H005+$3DF2).l, (H005+$3DEA).l
L068_00000DC4:
; H068+$00000DC4: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L068_00000DCA:
; H068+$00000DCA: 4e75  rts 
        rts 
L068_00000DCC:
; H068+$00000DCC: 4e75  rts 
        rts 
; Preserved bytes H068+$00000DCE..$00000DFC; code/data not fully classified.
        dc.w $FFFC,$FEC0,$FFFC,$FF40,$FFFC,$FF72,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFB0,$FEB0,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FF82,$FFFC,$FFFC,$FF5E
L068_00000DFC:
; H068+$00000DFC: 47faffd2  lea.l $dd0(pc), a3
        lea.l H068+$DD0(pc), a3
L068_00000E00:
; H068+$00000E00: 04420041  subi.w #$41, d2
        subi.w #$41, d2
L068_00000E04:
; H068+$00000E04: 0c420015  cmpi.w #$15, d2
        cmpi.w #$15, d2
L068_00000E08:
; H068+$00000E08: 6302  bls.b $e0c
        bls.b H068+$E0C
L068_00000E0A:
; H068+$00000E0A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_00000E0C:
; H068+$00000E0C: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000E0E:
; H068+$00000E0E: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H068+$0DD0; indici 0..21, default -1.
L068_00000E12:
; H068+$00000E12: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L068_00000E16:
; H068+$00000E16: 6000001e  bra.w $e36
        bra.w H068+$E36
L068_00000E1A:
; H068+$00000E1A: 1f2dffff  move.b -$1(a5), -(a7)
        move.b -$1(a5), -(a7)
; -> H065+$3390 (trampoline_H065_3474)
L068_00000E1E:
; H068+$00000E1E: 4eb900003390  jsr $3390.l
        jsr (H065+$3390).l
; STATO: H005+$3368 = personaggio corrente
L068_00000E24:
; H068+$00000E24: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L068_00000E2A:
; H068+$00000E2A: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
; -> H063+$33A0 (trampoline_H063_3652)
L068_00000E30:
; H068+$00000E30: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_00000E36:
; H068+$00000E36: 600001f4  bra.w $102c
        bra.w H068+$102C
L068_00000E3A:
; H068+$00000E3A: 4267  clr.w -(a7)
        clr.w -(a7)
L068_00000E3C:
; H068+$00000E3C: 486c0032  pea.l $32(a4)
        pea.l $32(a4)
L068_00000E40:
; H068+$00000E40: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L068_00000E44:
; H068+$00000E44: 486c0034  pea.l $34(a4)
        pea.l $34(a4)
L068_00000E48:
; H068+$00000E48: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L068_00000E4C:
; H068+$00000E4C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L068_00000E50:
; H068+$00000E50: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L068_00000E54:
; H068+$00000E54: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L068_00000E58:
; H068+$00000E58: 4227  clr.b -(a7)
        clr.b -(a7)
L068_00000E5A:
; H068+$00000E5A: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L068_00000E5E:
; H068+$00000E5E: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L068_00000E64:
; H068+$00000E64: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_00000E68:
; H068+$00000E68: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L068_00000E6E:
; H068+$00000E6E: 4a2dfffc  tst.b -$4(a5)
        tst.b -$4(a5)
L068_00000E72:
; H068+$00000E72: 66000036  bne.w $eaa
        bne.w H068+$EAA
L068_00000E76:
; H068+$00000E76: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000E78:
; H068+$00000E78: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L068_00000E7C:
; H068+$00000E7C: 60000010  bra.w $e8e
        bra.w H068+$E8E
L068_00000E80:
; H068+$00000E80: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L068_00000E86:
; H068+$00000E86: 4e75  rts 
        rts 
L068_00000E88:
; H068+$00000E88: 4e75  rts 
        rts 
; Preserved bytes H068+$00000E8A..$00000E8E; code/data not fully classified.
        dc.w $FFFC,$FFF4
L068_00000E8E:
; H068+$00000E8E: 45fafffc  lea.l $e8c(pc), a2
        lea.l H068+$E8C(pc), a2
L068_00000E92:
; H068+$00000E92: 04420045  subi.w #$45, d2
        subi.w #$45, d2
L068_00000E96:
; H068+$00000E96: 4a42  tst.w d2
        tst.w d2
L068_00000E98:
; H068+$00000E98: 6302  bls.b $e9c
        bls.b H068+$E9C
L068_00000E9A:
; H068+$00000E9A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_00000E9C:
; H068+$00000E9C: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00000E9E:
; H068+$00000E9E: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$0E8C; indici 0..0, default -1.
L068_00000EA2:
; H068+$00000EA2: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_00000EA6:
; H068+$00000EA6: 60000184  bra.w $102c
        bra.w H068+$102C
L068_00000EAA:
; H068+$00000EAA: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000EAC:
; H068+$00000EAC: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L068_00000EB0:
; H068+$00000EB0: 60000160  bra.w $1012
        bra.w H068+$1012
L068_00000EB4:
; H068+$00000EB4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000EB6:
; H068+$00000EB6: 6100fa7a  bsr.w $932
        bsr.w H068+$932
L068_00000EBA:
; H068+$00000EBA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000EBC:
; H068+$00000EBC: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L068_00000EC2:
; H068+$00000EC2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H063+$33A0 (trampoline_H063_3652)
L068_00000EC4:
; H068+$00000EC4: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_00000ECA:
; H068+$00000ECA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000ECC:
; H068+$00000ECC: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L068_00000ED0:
; H068+$00000ED0: 4e75  rts 
        rts 
L068_00000ED2:
; H068+$00000ED2: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000ED4:
; H068+$00000ED4: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000ED8:
; H068+$00000ED8: 5842  addq.w #$4, d2
        addq.w #$4, d2
L068_00000EDA:
; H068+$00000EDA: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L068_00000EE0:
; H068+$00000EE0: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L068_00000EE4:
; H068+$00000EE4: 17420004  move.b d2, $4(a3)
        move.b d2, $4(a3)
L068_00000EE8:
; H068+$00000EE8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000EEA:
; H068+$00000EEA: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000EEC:
; H068+$00000EEC: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000EF0:
; H068+$00000EF0: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000EF2:
; H068+$00000EF2: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000EF6:
; H068+$00000EF6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L068_00000EF8:
; H068+$00000EF8: 4eb9000001aa  jsr $1aa.l
        jsr (H011+$1AA).l
L068_00000EFE:
; H068+$00000EFE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000F00:
; H068+$00000F00: 17400005  move.b d0, $5(a3)
        move.b d0, $5(a3)
L068_00000F04:
; H068+$00000F04: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000F06:
; H068+$00000F06: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000F08:
; H068+$00000F08: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000F0C:
; H068+$00000F0C: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000F0E:
; H068+$00000F0E: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000F12:
; H068+$00000F12: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$0B78 (sub_H011_00000B78)
L068_00000F14:
; H068+$00000F14: 4eb900000b78  jsr $b78.l
        jsr (H011+$B78).l
L068_00000F1A:
; H068+$00000F1A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000F1C:
; H068+$00000F1C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H063+$33A0 (trampoline_H063_3652)
L068_00000F1E:
; H068+$00000F1E: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_00000F24:
; H068+$00000F24: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000F26:
; H068+$00000F26: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L068_00000F2A:
; H068+$00000F2A: 4e75  rts 
        rts 
L068_00000F2C:
; H068+$00000F2C: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000F2E:
; H068+$00000F2E: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000F32:
; H068+$00000F32: 5c42  addq.w #$6, d2
        addq.w #$6, d2
L068_00000F34:
; H068+$00000F34: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L068_00000F3A:
; H068+$00000F3A: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L068_00000F3E:
; H068+$00000F3E: 17420004  move.b d2, $4(a3)
        move.b d2, $4(a3)
L068_00000F42:
; H068+$00000F42: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000F44:
; H068+$00000F44: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L068_00000F48:
; H068+$00000F48: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L068_00000F4E:
; H068+$00000F4E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000F50:
; H068+$00000F50: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000F52:
; H068+$00000F52: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000F54:
; H068+$00000F54: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000F58:
; H068+$00000F58: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000F5A:
; H068+$00000F5A: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000F5E:
; H068+$00000F5E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L068_00000F60:
; H068+$00000F60: 4eb9000001aa  jsr $1aa.l
        jsr (H011+$1AA).l
L068_00000F66:
; H068+$00000F66: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000F68:
; H068+$00000F68: 17400005  move.b d0, $5(a3)
        move.b d0, $5(a3)
L068_00000F6C:
; H068+$00000F6C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000F6E:
; H068+$00000F6E: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000F70:
; H068+$00000F70: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000F74:
; H068+$00000F74: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000F76:
; H068+$00000F76: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000F7A:
; H068+$00000F7A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$0B78 (sub_H011_00000B78)
L068_00000F7C:
; H068+$00000F7C: 4eb900000b78  jsr $b78.l
        jsr (H011+$B78).l
L068_00000F82:
; H068+$00000F82: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000F84:
; H068+$00000F84: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H063+$33A0 (trampoline_H063_3652)
L068_00000F86:
; H068+$00000F86: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_00000F8C:
; H068+$00000F8C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000F8E:
; H068+$00000F8E: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L068_00000F92:
; H068+$00000F92: 4e75  rts 
        rts 
L068_00000F94:
; H068+$00000F94: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000F96:
; H068+$00000F96: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000F9A:
; H068+$00000F9A: 5442  addq.w #$2, d2
        addq.w #$2, d2
L068_00000F9C:
; H068+$00000F9C: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L068_00000FA2:
; H068+$00000FA2: 02420007  andi.w #$7, d2
        andi.w #$7, d2
L068_00000FA6:
; H068+$00000FA6: 17420004  move.b d2, $4(a3)
        move.b d2, $4(a3)
L068_00000FAA:
; H068+$00000FAA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000FAC:
; H068+$00000FAC: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L068_00000FB0:
; H068+$00000FB0: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L068_00000FB6:
; H068+$00000FB6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000FB8:
; H068+$00000FB8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000FBA:
; H068+$00000FBA: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000FBC:
; H068+$00000FBC: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000FC0:
; H068+$00000FC0: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000FC2:
; H068+$00000FC2: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000FC6:
; H068+$00000FC6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; FLUSSO: Chiama Map_QueryWall (H011+$01AA).
L068_00000FC8:
; H068+$00000FC8: 4eb9000001aa  jsr $1aa.l
        jsr (H011+$1AA).l
L068_00000FCE:
; H068+$00000FCE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000FD0:
; H068+$00000FD0: 17400005  move.b d0, $5(a3)
        move.b d0, $5(a3)
L068_00000FD4:
; H068+$00000FD4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00000FD6:
; H068+$00000FD6: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_00000FD8:
; H068+$00000FD8: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_00000FDC:
; H068+$00000FDC: 7400  moveq #$0, d2
        moveq #0, d2
L068_00000FDE:
; H068+$00000FDE: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00000FE2:
; H068+$00000FE2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$0B78 (sub_H011_00000B78)
L068_00000FE4:
; H068+$00000FE4: 4eb900000b78  jsr $b78.l
        jsr (H011+$B78).l
L068_00000FEA:
; H068+$00000FEA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000FEC:
; H068+$00000FEC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H063+$33A0 (trampoline_H063_3652)
L068_00000FEE:
; H068+$00000FEE: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_00000FF4:
; H068+$00000FF4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00000FF6:
; H068+$00000FF6: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L068_00000FFA:
; H068+$00000FFA: 4e75  rts 
        rts 
L068_00000FFC:
; H068+$00000FFC: 4e75  rts 
        rts 
; Preserved bytes H068+$00000FFE..$00001012; code/data not fully classified.
        dc.w $FFFC,$FEB4,$FFFC,$FFFC,$FF2C,$FFFC,$FF94,$FFFC
        dc.w $FFFC,$FED2
L068_00001012:
; H068+$00001012: 45faffec  lea.l $1000(pc), a2
        lea.l H068+$1000(pc), a2
L068_00001016:
; H068+$00001016: 04420048  subi.w #$48, d2
        subi.w #$48, d2
L068_0000101A:
; H068+$0000101A: 0c420008  cmpi.w #$8, d2
        cmpi.w #$8, d2
L068_0000101E:
; H068+$0000101E: 6302  bls.b $1022
        bls.b H068+$1022
L068_00001020:
; H068+$00001020: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_00001022:
; H068+$00001022: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00001024:
; H068+$00001024: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$1000; indici 0..8, default -1.
L068_00001028:
; H068+$00001028: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_0000102C:
; H068+$0000102C: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L068_00001030:
; H068+$00001030: 6700fc04  beq.w $c36
        beq.w H068+$C36
L068_00001034:
; H068+$00001034: 4e75  rts 
        rts 
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L068_00001036:
; H068+$00001036: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L068_0000103C:
; H068+$0000103C: 4a6b03ee  tst.w $3ee(a3)
        tst.w $3ee(a3)
L068_00001040:
; H068+$00001040: 67000194  beq.w $11d6
        beq.w H068+$11D6
L068_00001044:
; H068+$00001044: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L068_00001048:
; H068+$00001048: 4a39000024b0  tst.b $24b0.l
        tst.b (H005+$24B0).l
L068_0000104E:
; H068+$0000104E: 66000096  bne.w $10e6
        bne.w H068+$10E6
L068_00001052:
; H068+$00001052: 4267  clr.w -(a7)
        clr.w -(a7)
L068_00001054:
; H068+$00001054: 486c0039  pea.l $39(a4)
        pea.l $39(a4)
L068_00001058:
; H068+$00001058: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L068_0000105C:
; H068+$0000105C: 486c003b  pea.l $3b(a4)
        pea.l $3b(a4)
L068_00001060:
; H068+$00001060: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L068_00001064:
; H068+$00001064: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L068_00001068:
; H068+$00001068: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L068_0000106C:
; H068+$0000106C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L068_00001070:
; H068+$00001070: 4227  clr.b -(a7)
        clr.b -(a7)
L068_00001072:
; H068+$00001072: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L068_00001076:
; H068+$00001076: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L068_0000107C:
; H068+$0000107C: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L068_00001080:
; H068+$00001080: 4a2dfffc  tst.b -$4(a5)
        tst.b -$4(a5)
L068_00001084:
; H068+$00001084: 6600005c  bne.w $10e2
        bne.w H068+$10E2
L068_00001088:
; H068+$00001088: 7400  moveq #$0, d2
        moveq #0, d2
L068_0000108A:
; H068+$0000108A: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L068_0000108E:
; H068+$0000108E: 60000038  bra.w $10c8
        bra.w H068+$10C8
; -> H008+$139E (sub_H008_0000139E)
L068_00001092:
; H068+$00001092: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
L068_00001098:
; H068+$00001098: 13fc0001000024b0  move.b #$1, $24b0.l
        move.b #$1, (H005+$24B0).l
L068_000010A0:
; H068+$000010A0: 4e75  rts 
        rts 
L068_000010A2:
; H068+$000010A2: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L068_000010A8:
; H068+$000010A8: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
L068_000010B0:
; H068+$000010B0: 4e75  rts 
        rts 
L068_000010B2:
; H068+$000010B2: 4e75  rts 
        rts 
; Preserved bytes H068+$000010B4..$000010C8; code/data not fully classified.
        dc.w $FFFC,$FFEC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFDC
L068_000010C8:
; H068+$000010C8: 47faffec  lea.l $10b6(pc), a3
        lea.l H068+$10B6(pc), a3
L068_000010CC:
; H068+$000010CC: 04420045  subi.w #$45, d2
        subi.w #$45, d2
L068_000010D0:
; H068+$000010D0: 0c420008  cmpi.w #$8, d2
        cmpi.w #$8, d2
L068_000010D4:
; H068+$000010D4: 6302  bls.b $10d8
        bls.b H068+$10D8
L068_000010D6:
; H068+$000010D6: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000010D8:
; H068+$000010D8: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000010DA:
; H068+$000010DA: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H068+$10B6; indici 0..8, default -1.
L068_000010DE:
; H068+$000010DE: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L068_000010E2:
; H068+$000010E2: 600000ea  bra.w $11ce
        bra.w H068+$11CE
L068_000010E6:
; H068+$000010E6: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L068_000010EA:
; H068+$000010EA: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L068_000010EE:
; H068+$000010EE: 66000030  bne.w $1120
        bne.w H068+$1120
L068_000010F2:
; H068+$000010F2: 4267  clr.w -(a7)
        clr.w -(a7)
L068_000010F4:
; H068+$000010F4: 486c0047  pea.l $47(a4)
        pea.l $47(a4)
L068_000010F8:
; H068+$000010F8: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L068_000010FC:
; H068+$000010FC: 486c0049  pea.l $49(a4)
        pea.l $49(a4)
L068_00001100:
; H068+$00001100: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L068_00001104:
; H068+$00001104: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L068_00001108:
; H068+$00001108: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L068_0000110C:
; H068+$0000110C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L068_00001110:
; H068+$00001110: 4227  clr.b -(a7)
        clr.b -(a7)
L068_00001112:
; H068+$00001112: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L068_00001116:
; H068+$00001116: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L068_0000111C:
; H068+$0000111C: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_00001120:
; H068+$00001120: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L068_00001126:
; H068+$00001126: 4a2dfffc  tst.b -$4(a5)
        tst.b -$4(a5)
L068_0000112A:
; H068+$0000112A: 66000016  bne.w $1142
        bne.w H068+$1142
L068_0000112E:
; H068+$0000112E: 0c2d0045ffff  cmpi.b #$45, -$1(a5)
        cmpi.b #$45, -$1(a5)
L068_00001134:
; H068+$00001134: 66000008  bne.w $113e
        bne.w H068+$113E
L068_00001138:
; H068+$00001138: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L068_0000113E:
; H068+$0000113E: 6000008e  bra.w $11ce
        bra.w H068+$11CE
L068_00001142:
; H068+$00001142: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L068_00001148:
; H068+$00001148: 7400  moveq #$0, d2
        moveq #0, d2
L068_0000114A:
; H068+$0000114A: 142dffff  move.b -$1(a5), d2
        move.b -$1(a5), d2
L068_0000114E:
; H068+$0000114E: 6000005a  bra.w $11aa
        bra.w H068+$11AA
L068_00001152:
; H068+$00001152: 422b0004  clr.b $4(a3)
        clr.b $4(a3)
L068_00001156:
; H068+$00001156: 4e75  rts 
        rts 
L068_00001158:
; H068+$00001158: 177c00010004  move.b #$1, $4(a3)
        move.b #$1, $4(a3)
L068_0000115E:
; H068+$0000115E: 4e75  rts 
        rts 
L068_00001160:
; H068+$00001160: 177c00020004  move.b #$2, $4(a3)
        move.b #$2, $4(a3)
L068_00001166:
; H068+$00001166: 4e75  rts 
        rts 
L068_00001168:
; H068+$00001168: 177c00030004  move.b #$3, $4(a3)
        move.b #$3, $4(a3)
L068_0000116E:
; H068+$0000116E: 4e75  rts 
        rts 
L068_00001170:
; H068+$00001170: 177c00040004  move.b #$4, $4(a3)
        move.b #$4, $4(a3)
L068_00001176:
; H068+$00001176: 4e75  rts 
        rts 
L068_00001178:
; H068+$00001178: 177c00050004  move.b #$5, $4(a3)
        move.b #$5, $4(a3)
L068_0000117E:
; H068+$0000117E: 4e75  rts 
        rts 
L068_00001180:
; H068+$00001180: 177c00060004  move.b #$6, $4(a3)
        move.b #$6, $4(a3)
L068_00001186:
; H068+$00001186: 4e75  rts 
        rts 
L068_00001188:
; H068+$00001188: 177c00070004  move.b #$7, $4(a3)
        move.b #$7, $4(a3)
L068_0000118E:
; H068+$0000118E: 4e75  rts 
        rts 
L068_00001190:
; H068+$00001190: 4e75  rts 
        rts 
; Preserved bytes H068+$00001192..$000011AA; code/data not fully classified.
        dc.w $FFFC,$FFF4,$FFBE,$FFC4,$FFFC,$FFEC,$FFFC,$FFCC
        dc.w $FFFC,$FFE4,$FFDC,$FFD4
L068_000011AA:
; H068+$000011AA: 45faffe8  lea.l $1194(pc), a2
        lea.l H068+$1194(pc), a2
L068_000011AE:
; H068+$000011AE: 04420047  subi.w #$47, d2
        subi.w #$47, d2
L068_000011B2:
; H068+$000011B2: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L068_000011B6:
; H068+$000011B6: 6302  bls.b $11ba
        bls.b H068+$11BA
L068_000011B8:
; H068+$000011B8: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000011BA:
; H068+$000011BA: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000011BC:
; H068+$000011BC: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$1194; indici 0..10, default -1.
L068_000011C0:
; H068+$000011C0: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_000011C4:
; H068+$000011C4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H063+$33A0 (trampoline_H063_3652)
L068_000011C6:
; H068+$000011C6: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_000011CC:
; H068+$000011CC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000011CE:
; H068+$000011CE: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L068_000011D2:
; H068+$000011D2: 6700fe74  beq.w $1048
        beq.w H068+$1048
L068_000011D6:
; H068+$000011D6: 4e75  rts 
        rts 
L068_000011D8:
; H068+$000011D8: 4e75  rts 
        rts 
; Preserved bytes H068+$000011DA..$000011E0; code/data not fully classified.
        dc.w $FFFC,$FE5A,$FA52
L068_000011E0:
; H068+$000011E0: 47fafffa  lea.l $11dc(pc), a3
        lea.l H068+$11DC(pc), a3
L068_000011E4:
; H068+$000011E4: 5742  subq.w #$3, d2
        subq.w #$3, d2
L068_000011E6:
; H068+$000011E6: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L068_000011EA:
; H068+$000011EA: 6302  bls.b $11ee
        bls.b H068+$11EE
L068_000011EC:
; H068+$000011EC: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000011EE:
; H068+$000011EE: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000011F0:
; H068+$000011F0: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H068+$11DC; indici 0..1, default -1.
L068_000011F4:
; H068+$000011F4: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L068_000011F8:
; H068+$000011F8: 4a39000024b9  tst.b $24b9.l
        tst.b (H005+$24B9).l
L068_000011FE:
; H068+$000011FE: 66000020  bne.w $1220
        bne.w H068+$1220
L068_00001202:
; H068+$00001202: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L068_00001206:
; H068+$00001206: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L068_0000120A:
; H068+$0000120A: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L068_0000120E:
; H068+$0000120E: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
; -> H030+$0B6C (sub_H030_00000B6C)
L068_00001212:
; H068+$00001212: 4eb900000b6c  jsr $b6c.l
        jsr (H030+$B6C).l
L068_00001218:
; H068+$00001218: 13fc0001000024b9  move.b #$1, $24b9.l
        move.b #$1, (H005+$24B9).l
L068_00001220:
; H068+$00001220: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L068_00001224:
; H068+$00001224: 60000002  bra.w $1228
        bra.w H068+$1228
L068_00001228:
; H068+$00001228: 4e5d  unlk a5
        unlk a5
L068_0000122A:
; H068+$0000122A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_0000122C:
; H068+$0000122C: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Exploration_MoveOrDoor [parziale]
; Scopo: Gestisce il percorso di movimento/interazione con le porte.
;   - Costruisce opzioni quali Bash, Pick e Knock in base a stato e disponibilità.
;   - Aggiorna posizione/stato attraverso i rami di comando.
;   - La formula dei controlli e tutti i bit di porta restano da completare.
; Chiamanti diretti: H012+$345A
; --------------------------------------------------------------------------
L068_0000122E:
; H068+$0000122E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L068_00001230:
; H068+$00001230: 287aee6e  movea.l $a0(pc), a4
        movea.l H068+$A0(pc), a4
L068_00001234:
; H068+$00001234: 4e55ffd2  link.w a5, #$ffd2
        link.w a5, #$ffd2
L068_00001238:
; H068+$00001238: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_0000123C:
; H068+$0000123C: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L068_00001242:
; H068+$00001242: 7400  moveq #$0, d2
        moveq #0, d2
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L068_00001244:
; H068+$00001244: 143900003de3  move.b $3de3.l, d2
        move.b (H005+$3DE3).l, d2
L068_0000124A:
; H068+$0000124A: 600003f8  bra.w $1644
        bra.w H068+$1644
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_0000124E:
; H068+$0000124E: 247900003e00  movea.l $3e00.l, a2
        movea.l (H005+$3E00).l, a2
L068_00001254:
; H068+$00001254: 0c6a00ff0592  cmpi.w #$ff, $592(a2)
        cmpi.w #$ff, $592(a2)
L068_0000125A:
; H068+$0000125A: 640003a2  bcc.w $15fe
        bcc.w H068+$15FE
L068_0000125E:
; H068+$0000125E: 13fc0001000024e1  move.b #$1, $24e1.l
        move.b #$1, (H005+$24E1).l
L068_00001266:
; H068+$00001266: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001268:
; H068+$00001268: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L068_0000126A:
; H068+$0000126A: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L068_0000126E:
; H068+$0000126E: 7400  moveq #$0, d2
        moveq #0, d2
L068_00001270:
; H068+$00001270: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L068_00001274:
; H068+$00001274: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$09C8 (sub_H011_000009C8)
L068_00001276:
; H068+$00001276: 4eb9000009c8  jsr $9c8.l
        jsr (H011+$9C8).l
L068_0000127C:
; H068+$0000127C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000127E:
; H068+$0000127E: 3400  move.w d0, d2
        move.w d0, d2
L068_00001280:
; H068+$00001280: 60000346  bra.w $15c8
        bra.w H068+$15C8
L068_00001284:
; H068+$00001284: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L068_0000128A:
; H068+$0000128A: 4e75  rts 
        rts 
L068_0000128C:
; H068+$0000128C: 45ec004e  lea.l $4e(a4), a2
        lea.l $4e(a4), a2
L068_00001290:
; H068+$00001290: 43edffd4  lea.l -$2c(a5), a1
        lea.l -$2c(a5), a1
L068_00001294:
; H068+$00001294: 7428  moveq #$28, d2
        moveq #40, d2
L068_00001296:
; H068+$00001296: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L068_00001298:
; H068+$00001298: 57cafffc  dbeq d2, $1296
        dbeq d2, H068+$1296
L068_0000129C:
; H068+$0000129C: 4a39000024e4  tst.b $24e4.l
        tst.b (H005+$24E4).l
L068_000012A2:
; H068+$000012A2: 67000012  beq.w $12b6
        beq.w H068+$12B6
L068_000012A6:
; H068+$000012A6: 45ec0050  lea.l $50(a4), a2
        lea.l $50(a4), a2
L068_000012AA:
; H068+$000012AA: 43edffd4  lea.l -$2c(a5), a1
        lea.l -$2c(a5), a1
L068_000012AE:
; H068+$000012AE: 7428  moveq #$28, d2
        moveq #40, d2
L068_000012B0:
; H068+$000012B0: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L068_000012B2:
; H068+$000012B2: 57cafffc  dbeq d2, $12b0
        dbeq d2, H068+$12B0
L068_000012B6:
; H068+$000012B6: 4a39000024e5  tst.b $24e5.l
        tst.b (H005+$24E5).l
L068_000012BC:
; H068+$000012BC: 67000030  beq.w $12ee
        beq.w H068+$12EE
L068_000012C0:
; H068+$000012C0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000012C2:
; H068+$000012C2: 1f3c0006  move.b #$6, -(a7)
        move.b #$6, -(a7)
L068_000012C6:
; H068+$000012C6: 6100eff0  bsr.w $2b8
        bsr.w H068+$2B8
L068_000012CA:
; H068+$000012CA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000012CC:
; H068+$000012CC: 1400  move.b d0, d2
        move.b d0, d2
L068_000012CE:
; H068+$000012CE: 4a02  tst.b d2
        tst.b d2
L068_000012D0:
; H068+$000012D0: 6700001c  beq.w $12ee
        beq.w H068+$12EE
L068_000012D4:
; H068+$000012D4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000012D6:
; H068+$000012D6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_000012DA:
; H068+$000012DA: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_000012DE:
; H068+$000012DE: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L068_000012E2:
; H068+$000012E2: 486c0055  pea.l $55(a4)
        pea.l $55(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L068_000012E6:
; H068+$000012E6: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L068_000012EC:
; H068+$000012EC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000012EE:
; H068+$000012EE: 4a39000024e6  tst.b $24e6.l
        tst.b (H005+$24E6).l
L068_000012F4:
; H068+$000012F4: 67000030  beq.w $1326
        beq.w H068+$1326
L068_000012F8:
; H068+$000012F8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000012FA:
; H068+$000012FA: 1f3c001f  move.b #$1f, -(a7)
        move.b #$1f, -(a7)
L068_000012FE:
; H068+$000012FE: 6100f590  bsr.w $890
        bsr.w H068+$890
L068_00001302:
; H068+$00001302: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00001304:
; H068+$00001304: 2400  move.l d0, d2
        move.l d0, d2
L068_00001306:
; H068+$00001306: 4a82  tst.l d2
        tst.l d2
L068_00001308:
; H068+$00001308: 6700001c  beq.w $1326
        beq.w H068+$1326
L068_0000130C:
; H068+$0000130C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000130E:
; H068+$0000130E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_00001312:
; H068+$00001312: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_00001316:
; H068+$00001316: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L068_0000131A:
; H068+$0000131A: 486c005b  pea.l $5b(a4)
        pea.l $5b(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L068_0000131E:
; H068+$0000131E: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L068_00001324:
; H068+$00001324: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00001326:
; H068+$00001326: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001328:
; H068+$00001328: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_0000132C:
; H068+$0000132C: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_00001330:
; H068+$00001330: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L068_00001334:
; H068+$00001334: 486c0062  pea.l $62(a4)
        pea.l $62(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L068_00001338:
; H068+$00001338: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L068_0000133E:
; H068+$0000133E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00001340:
; H068+$00001340: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001342:
; H068+$00001342: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_00001346:
; H068+$00001346: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_0000134A:
; H068+$0000134A: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L068_0000134E:
; H068+$0000134E: 486c0068  pea.l $68(a4)
        pea.l $68(a4)
; -> H026+$0106 (sub_H026_00000106)
L068_00001352:
; H068+$00001352: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L068_00001358:
; H068+$00001358: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000135A:
; H068+$0000135A: 1400  move.b d0, d2
        move.b d0, d2
L068_0000135C:
; H068+$0000135C: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L068_00001360:
; H068+$00001360: 66000022  bne.w $1384
        bne.w H068+$1384
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_00001364:
; H068+$00001364: 45f90000281c  lea.l $281c.l, a2
        lea.l (H005+$281C).l, a2
L068_0000136A:
; H068+$0000136A: 48e70030  movem.l a2-a3, -(a7)
        movem.l a2-a3, -(a7)
L068_0000136E:
; H068+$0000136E: 3f12  move.w (a2), -(a7)
        move.w (a2), -(a7)
L068_00001370:
; H068+$00001370: 3f2a0002  move.w $2(a2), -(a7)
        move.w $2(a2), -(a7)
L068_00001374:
; H068+$00001374: 1f2a0004  move.b $4(a2), -(a7)
        move.b $4(a2), -(a7)
L068_00001378:
; H068+$00001378: 6100ed38  bsr.w $b2
        bsr.w H068+$B2
L068_0000137C:
; H068+$0000137C: 4cdf0c00  movem.l (a7)+, a2-a3
        movem.l (a7)+, a2-a3
L068_00001380:
; H068+$00001380: 600000a4  bra.w $1426
        bra.w H068+$1426
L068_00001384:
; H068+$00001384: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001386:
; H068+$00001386: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L068_0000138A:
; H068+$0000138A: 486c006e  pea.l $6e(a4)
        pea.l $6e(a4)
L068_0000138E:
; H068+$0000138E: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_00001392:
; H068+$00001392: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_00001396:
; H068+$00001396: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L068_0000139A:
; H068+$0000139A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L068_0000139E:
; H068+$0000139E: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L068_000013A2:
; H068+$000013A2: 4227  clr.b -(a7)
        clr.b -(a7)
L068_000013A4:
; H068+$000013A4: 4227  clr.b -(a7)
        clr.b -(a7)
L068_000013A6:
; H068+$000013A6: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L068_000013AA:
; H068+$000013AA: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L068_000013B0:
; H068+$000013B0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000013B2:
; H068+$000013B2: 1b40ffd3  move.b d0, -$2d(a5)
        move.b d0, -$2d(a5)
L068_000013B6:
; H068+$000013B6: 7400  moveq #$0, d2
        moveq #0, d2
L068_000013B8:
; H068+$000013B8: 142dffd3  move.b -$2d(a5), d2
        move.b -$2d(a5), d2
L068_000013BC:
; H068+$000013BC: 6000004e  bra.w $140c
        bra.w H068+$140C
L068_000013C0:
; H068+$000013C0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000013C2:
; H068+$000013C2: 6100ef7c  bsr.w $340
        bsr.w H068+$340
L068_000013C6:
; H068+$000013C6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000013C8:
; H068+$000013C8: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L068_000013CC:
; H068+$000013CC: 4e75  rts 
        rts 
L068_000013CE:
; H068+$000013CE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000013D0:
; H068+$000013D0: 6100f376  bsr.w $748
        bsr.w H068+$748
L068_000013D4:
; H068+$000013D4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000013D6:
; H068+$000013D6: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L068_000013DA:
; H068+$000013DA: 4e75  rts 
        rts 
L068_000013DC:
; H068+$000013DC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000013DE:
; H068+$000013DE: 6100f502  bsr.w $8e2
        bsr.w H068+$8E2
L068_000013E2:
; H068+$000013E2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000013E4:
; H068+$000013E4: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L068_000013E8:
; H068+$000013E8: 4e75  rts 
        rts 
L068_000013EA:
; H068+$000013EA: 4e75  rts 
        rts 
; Preserved bytes H068+$000013EC..$0000140C; code/data not fully classified.
        dc.w $FFFC,$FFD2,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFEE,$FFFC,$FFFC,$FFFC,$FFFC,$FFE0
L068_0000140C:
; H068+$0000140C: 45faffe0  lea.l $13ee(pc), a2
        lea.l H068+$13EE(pc), a2
L068_00001410:
; H068+$00001410: 04420042  subi.w #$42, d2
        subi.w #$42, d2
L068_00001414:
; H068+$00001414: 0c42000e  cmpi.w #$e, d2
        cmpi.w #$e, d2
L068_00001418:
; H068+$00001418: 6302  bls.b $141c
        bls.b H068+$141C
L068_0000141A:
; H068+$0000141A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_0000141C:
; H068+$0000141C: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_0000141E:
; H068+$0000141E: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$13EE; indici 0..14, default -1.
L068_00001422:
; H068+$00001422: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_00001426:
; H068+$00001426: 4e75  rts 
        rts 
L068_00001428:
; H068+$00001428: 45ec0077  lea.l $77(a4), a2
        lea.l $77(a4), a2
L068_0000142C:
; H068+$0000142C: 43edffd4  lea.l -$2c(a5), a1
        lea.l -$2c(a5), a1
L068_00001430:
; H068+$00001430: 7428  moveq #$28, d2
        moveq #40, d2
L068_00001432:
; H068+$00001432: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L068_00001434:
; H068+$00001434: 57cafffc  dbeq d2, $1432
        dbeq d2, H068+$1432
L068_00001438:
; H068+$00001438: 4a39000024e4  tst.b $24e4.l
        tst.b (H005+$24E4).l
L068_0000143E:
; H068+$0000143E: 67000012  beq.w $1452
        beq.w H068+$1452
L068_00001442:
; H068+$00001442: 45ec0079  lea.l $79(a4), a2
        lea.l $79(a4), a2
L068_00001446:
; H068+$00001446: 43edffd4  lea.l -$2c(a5), a1
        lea.l -$2c(a5), a1
L068_0000144A:
; H068+$0000144A: 7428  moveq #$28, d2
        moveq #40, d2
L068_0000144C:
; H068+$0000144C: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L068_0000144E:
; H068+$0000144E: 57cafffc  dbeq d2, $144c
        dbeq d2, H068+$144C
L068_00001452:
; H068+$00001452: 4a39000024e5  tst.b $24e5.l
        tst.b (H005+$24E5).l
L068_00001458:
; H068+$00001458: 67000030  beq.w $148a
        beq.w H068+$148A
L068_0000145C:
; H068+$0000145C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000145E:
; H068+$0000145E: 1f3c0006  move.b #$6, -(a7)
        move.b #$6, -(a7)
L068_00001462:
; H068+$00001462: 6100ee54  bsr.w $2b8
        bsr.w H068+$2B8
L068_00001466:
; H068+$00001466: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00001468:
; H068+$00001468: 1400  move.b d0, d2
        move.b d0, d2
L068_0000146A:
; H068+$0000146A: 4a02  tst.b d2
        tst.b d2
L068_0000146C:
; H068+$0000146C: 6700001c  beq.w $148a
        beq.w H068+$148A
L068_00001470:
; H068+$00001470: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001472:
; H068+$00001472: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_00001476:
; H068+$00001476: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_0000147A:
; H068+$0000147A: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L068_0000147E:
; H068+$0000147E: 486c007e  pea.l $7e(a4)
        pea.l $7e(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L068_00001482:
; H068+$00001482: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L068_00001488:
; H068+$00001488: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000148A:
; H068+$0000148A: 4a39000024e6  tst.b $24e6.l
        tst.b (H005+$24E6).l
L068_00001490:
; H068+$00001490: 67000030  beq.w $14c2
        beq.w H068+$14C2
L068_00001494:
; H068+$00001494: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001496:
; H068+$00001496: 1f3c001f  move.b #$1f, -(a7)
        move.b #$1f, -(a7)
L068_0000149A:
; H068+$0000149A: 6100f3f4  bsr.w $890
        bsr.w H068+$890
L068_0000149E:
; H068+$0000149E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000014A0:
; H068+$000014A0: 2400  move.l d0, d2
        move.l d0, d2
L068_000014A2:
; H068+$000014A2: 4a82  tst.l d2
        tst.l d2
L068_000014A4:
; H068+$000014A4: 6700001c  beq.w $14c2
        beq.w H068+$14C2
L068_000014A8:
; H068+$000014A8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000014AA:
; H068+$000014AA: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_000014AE:
; H068+$000014AE: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_000014B2:
; H068+$000014B2: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L068_000014B6:
; H068+$000014B6: 486c0084  pea.l $84(a4)
        pea.l $84(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L068_000014BA:
; H068+$000014BA: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L068_000014C0:
; H068+$000014C0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000014C2:
; H068+$000014C2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000014C4:
; H068+$000014C4: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_000014C8:
; H068+$000014C8: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_000014CC:
; H068+$000014CC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L068_000014D0:
; H068+$000014D0: 486c008b  pea.l $8b(a4)
        pea.l $8b(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L068_000014D4:
; H068+$000014D4: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L068_000014DA:
; H068+$000014DA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000014DC:
; H068+$000014DC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000014DE:
; H068+$000014DE: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_000014E2:
; H068+$000014E2: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_000014E6:
; H068+$000014E6: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L068_000014EA:
; H068+$000014EA: 486c0091  pea.l $91(a4)
        pea.l $91(a4)
; -> H026+$0106 (sub_H026_00000106)
L068_000014EE:
; H068+$000014EE: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L068_000014F4:
; H068+$000014F4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000014F6:
; H068+$000014F6: 1400  move.b d0, d2
        move.b d0, d2
L068_000014F8:
; H068+$000014F8: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L068_000014FC:
; H068+$000014FC: 66000022  bne.w $1520
        bne.w H068+$1520
; STATO: H005+$281C = inizio del blocco coordinate/vista
L068_00001500:
; H068+$00001500: 45f90000281c  lea.l $281c.l, a2
        lea.l (H005+$281C).l, a2
L068_00001506:
; H068+$00001506: 48e70030  movem.l a2-a3, -(a7)
        movem.l a2-a3, -(a7)
L068_0000150A:
; H068+$0000150A: 3f12  move.w (a2), -(a7)
        move.w (a2), -(a7)
L068_0000150C:
; H068+$0000150C: 3f2a0002  move.w $2(a2), -(a7)
        move.w $2(a2), -(a7)
L068_00001510:
; H068+$00001510: 1f2a0004  move.b $4(a2), -(a7)
        move.b $4(a2), -(a7)
L068_00001514:
; H068+$00001514: 6100eb9c  bsr.w $b2
        bsr.w H068+$B2
L068_00001518:
; H068+$00001518: 4cdf0c00  movem.l (a7)+, a2-a3
        movem.l (a7)+, a2-a3
L068_0000151C:
; H068+$0000151C: 6000009e  bra.w $15bc
        bra.w H068+$15BC
L068_00001520:
; H068+$00001520: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001522:
; H068+$00001522: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L068_00001526:
; H068+$00001526: 486c0097  pea.l $97(a4)
        pea.l $97(a4)
L068_0000152A:
; H068+$0000152A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L068_0000152E:
; H068+$0000152E: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L068_00001532:
; H068+$00001532: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L068_00001536:
; H068+$00001536: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L068_0000153A:
; H068+$0000153A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L068_0000153E:
; H068+$0000153E: 4227  clr.b -(a7)
        clr.b -(a7)
L068_00001540:
; H068+$00001540: 4227  clr.b -(a7)
        clr.b -(a7)
L068_00001542:
; H068+$00001542: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
; FLUSSO: Chiama UI_RequestChoice (H008+$01FC).
L068_00001546:
; H068+$00001546: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L068_0000154C:
; H068+$0000154C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000154E:
; H068+$0000154E: 1b40ffd3  move.b d0, -$2d(a5)
        move.b d0, -$2d(a5)
L068_00001552:
; H068+$00001552: 7400  moveq #$0, d2
        moveq #0, d2
L068_00001554:
; H068+$00001554: 142dffd3  move.b -$2d(a5), d2
        move.b -$2d(a5), d2
L068_00001558:
; H068+$00001558: 60000048  bra.w $15a2
        bra.w H068+$15A2
L068_0000155C:
; H068+$0000155C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000155E:
; H068+$0000155E: 6100ede0  bsr.w $340
        bsr.w H068+$340
L068_00001562:
; H068+$00001562: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00001564:
; H068+$00001564: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L068_00001568:
; H068+$00001568: 4e75  rts 
        rts 
L068_0000156A:
; H068+$0000156A: 4239000024e5  clr.b $24e5.l
        clr.b (H005+$24E5).l
L068_00001570:
; H068+$00001570: 4e75  rts 
        rts 
L068_00001572:
; H068+$00001572: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_00001574:
; H068+$00001574: 6100f36c  bsr.w $8e2
        bsr.w H068+$8E2
L068_00001578:
; H068+$00001578: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000157A:
; H068+$0000157A: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L068_0000157E:
; H068+$0000157E: 4e75  rts 
        rts 
L068_00001580:
; H068+$00001580: 4e75  rts 
        rts 
; Preserved bytes H068+$00001582..$000015A2; code/data not fully classified.
        dc.w $FFFC,$FFD8,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFEE,$FFFC,$FFFC,$FFFC,$FFFC,$FFE6
L068_000015A2:
; H068+$000015A2: 45faffe0  lea.l $1584(pc), a2
        lea.l H068+$1584(pc), a2
L068_000015A6:
; H068+$000015A6: 04420042  subi.w #$42, d2
        subi.w #$42, d2
L068_000015AA:
; H068+$000015AA: 0c42000e  cmpi.w #$e, d2
        cmpi.w #$e, d2
L068_000015AE:
; H068+$000015AE: 6302  bls.b $15b2
        bls.b H068+$15B2
L068_000015B0:
; H068+$000015B0: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000015B2:
; H068+$000015B2: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000015B4:
; H068+$000015B4: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$1584; indici 0..14, default -1.
L068_000015B8:
; H068+$000015B8: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_000015BC:
; H068+$000015BC: 4e75  rts 
        rts 
L068_000015BE:
; H068+$000015BE: 4e75  rts 
        rts 
; Preserved bytes H068+$000015C0..$000015C8; code/data not fully classified.
        dc.w $FFFC,$FCC2,$FCCA,$FE66
L068_000015C8:
; H068+$000015C8: 45fafff8  lea.l $15c2(pc), a2
        lea.l H068+$15C2(pc), a2
L068_000015CC:
; H068+$000015CC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L068_000015CE:
; H068+$000015CE: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L068_000015D2:
; H068+$000015D2: 6302  bls.b $15d6
        bls.b H068+$15D6
L068_000015D4:
; H068+$000015D4: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_000015D6:
; H068+$000015D6: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_000015D8:
; H068+$000015D8: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$15C2; indici 0..2, default -1.
L068_000015DC:
; H068+$000015DC: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_000015E0:
; H068+$000015E0: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L068_000015E4:
; H068+$000015E4: 6700000a  beq.w $15f0
        beq.w H068+$15F0
L068_000015E8:
; H068+$000015E8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_000015EA:
; H068+$000015EA: 6100f42e  bsr.w $a1a
        bsr.w H068+$A1A
L068_000015EE:
; H068+$000015EE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000015F0:
; H068+$000015F0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H063+$33A0 (trampoline_H063_3652)
L068_000015F2:
; H068+$000015F2: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_000015F8:
; H068+$000015F8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_000015FA:
; H068+$000015FA: 6000000c  bra.w $1608
        bra.w H068+$1608
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_000015FE:
; H068+$000015FE: 247900003e00  movea.l $3e00.l, a2
        movea.l (H005+$3E00).l, a2
L068_00001604:
; H068+$00001604: 426a0592  clr.w $592(a2)
        clr.w $592(a2)
L068_00001608:
; H068+$00001608: 4e75  rts 
        rts 
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_0000160A:
; H068+$0000160A: 247900003e00  movea.l $3e00.l, a2
        movea.l (H005+$3E00).l, a2
L068_00001610:
; H068+$00001610: 0c6a00ff0592  cmpi.w #$ff, $592(a2)
        cmpi.w #$ff, $592(a2)
L068_00001616:
; H068+$00001616: 64000018  bcc.w $1630
        bcc.w H068+$1630
L068_0000161A:
; H068+$0000161A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L068_0000161C:
; H068+$0000161C: 6100f50e  bsr.w $b2c
        bsr.w H068+$B2C
L068_00001620:
; H068+$00001620: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_00001622:
; H068+$00001622: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H063+$33A0 (trampoline_H063_3652)
L068_00001624:
; H068+$00001624: 4eb9000033a0  jsr $33a0.l
        jsr (H063+$33A0).l
L068_0000162A:
; H068+$0000162A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L068_0000162C:
; H068+$0000162C: 6000000c  bra.w $163a
        bra.w H068+$163A
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L068_00001630:
; H068+$00001630: 247900003e00  movea.l $3e00.l, a2
        movea.l (H005+$3E00).l, a2
L068_00001636:
; H068+$00001636: 426a0592  clr.w $592(a2)
        clr.w $592(a2)
L068_0000163A:
; H068+$0000163A: 4e75  rts 
        rts 
L068_0000163C:
; H068+$0000163C: 4e75  rts 
        rts 
; Preserved bytes H068+$0000163E..$00001644; code/data not fully classified.
        dc.w $FFFC,$FFCA,$FC0E
L068_00001644:
; H068+$00001644: 45fafffa  lea.l $1640(pc), a2
        lea.l H068+$1640(pc), a2
L068_00001648:
; H068+$00001648: 5742  subq.w #$3, d2
        subq.w #$3, d2
L068_0000164A:
; H068+$0000164A: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L068_0000164E:
; H068+$0000164E: 6302  bls.b $1652
        bls.b H068+$1652
L068_00001650:
; H068+$00001650: 74ff  moveq #$ff, d2
        moveq #-1, d2
L068_00001652:
; H068+$00001652: e342  asl.w #$1, d2
        asl.w #$1, d2
L068_00001654:
; H068+$00001654: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: word relative a H068+$1640; indici 0..1, default -1.
L068_00001658:
; H068+$00001658: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L068_0000165C:
; H068+$0000165C: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLUSSO: Chiama Free_Sequence (H042+$0300).
L068_00001662:
; H068+$00001662: 4eb900000300  jsr $300.l
        jsr (H042+$300).l
L068_00001668:
; H068+$00001668: 4879000027b2  pea.l $27b2.l
        pea.l (H005+$27B2).l
; FLUSSO: Chiama Free_GraphicRecord (H029+$067A).
L068_0000166E:
; H068+$0000166E: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L068_00001674:
; H068+$00001674: 4879000027b8  pea.l $27b8.l
        pea.l (H005+$27B8).l
; FLUSSO: Chiama Free_GraphicRecord (H029+$067A).
L068_0000167A:
; H068+$0000167A: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L068_00001680:
; H068+$00001680: 13fc00ff000027b0  move.b #$ff, $27b0.l
        move.b #$ff, (H005+$27B0).l
L068_00001688:
; H068+$00001688: 13fc00ff000027b6  move.b #$ff, $27b6.l
        move.b #$ff, (H005+$27B6).l
L068_00001690:
; H068+$00001690: 4e5d  unlk a5
        unlk a5
L068_00001692:
; H068+$00001692: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_00001694:
; H068+$00001694: 4e75  rts 
        rts 
L068_00001696:
; H068+$00001696: 4e5d  unlk a5
        unlk a5
L068_00001698:
; H068+$00001698: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L068_0000169A:
; H068+$0000169A: 4e75  rts 
        rts 
; End H068: $169C bytes
