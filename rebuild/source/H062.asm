; ============================================================================
; GUIDA DEL MODULO H062
; Helper ed effetti condivisi del gioco; non tutti i significati sono attribuiti.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Effetti condivisi del gioco: helper per stato, danni, oggetti e presentazione. La mappa completa resta parziale.
; --------------------------------------------------------------------------
; H062: 10496 original bytes; all offsets are section-relative.
        section H062,code
H062:
; Preserved bytes H062+$00000000..$00000106; code/data not fully classified.
        dc.w $0000,$6973,$2055,$6E61,$6666,$6563,$7465,$6400
        dc.w $7761,$6E74,$7320,$746F,$206B,$696C,$6C20,$0073
        dc.w $7461,$7274,$7320,$746F,$2063,$6F75,$6768,$0063
        dc.w $686F,$6B65,$7320,$616E,$6420,$6761,$6773,$2066
        dc.w $726F,$6D20,$6E61,$7573,$6561,$0074,$6861,$6330
        dc.w $0069,$7320,$4375,$7265,$6400,$7461,$6B65,$7320
        dc.w $0020,$706F,$696E,$7473,$206F,$6620,$6461,$6D61
        dc.w $6765,$2000,$7461,$6B65,$7320,$3120,$706F,$696E
        dc.w $7420,$6F66,$2064,$616D,$6167,$6520,$0066,$726F
        dc.w $6D20,$4669,$7265,$0066,$726F,$6D20,$436F,$6C64
        dc.w $0066,$726F,$6D20,$456C,$6563,$7472,$6963,$6974
        dc.w $7900,$6672,$6F6D,$2041,$6369,$6400,$6672,$6F6D
        dc.w $204D,$6167,$6963,$006C,$6F73,$7420,$6120,$7370
        dc.w $656C,$6C00,$476F,$6573,$2044,$6F77,$6E00,$2C20
        dc.w $616E,$6420,$6973,$2044,$7969,$6E67,$0069,$7320
        dc.w $6B69,$6C6C,$6564,$0065,$7870,$6C6F,$6465,$732E
        dc.w $0000
        dc.l H062+$00000002
; --------------------------------------------------------------------------
; ROUTINE: module_init_H062 [parziale]
; Scopo: Ingresso del modulo helper ed effetti condivisi del gioco; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H062+$28FA.
; Chiamanti diretti: H000+$01BC
; --------------------------------------------------------------------------
L062_00000106:
; H062+$00000106: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00000108:
; H062+$00000108: 287afff8  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000010C:
; H062+$0000010C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_00000110:
; H062+$00000110: 600027e8  bra.w $28fa
        bra.w H062+$28FA
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00000114 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$1DC2, H063+$0946, H063+$2760, H063+$1EE8.
;   - Richiama H063+$1DC2.
;   - Richiama H063+$0946.
;   - Richiama H063+$2760.
;   - Richiama H063+$1EE8.
; Chiamanti diretti: H027+$2C30, H085+$3896, H085+$39EA, H085+$3C5A, H085+$3CB2, H027+$1204 e altri 12
; --------------------------------------------------------------------------
L062_00000114:
; H062+$00000114: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00000116:
; H062+$00000116: 287affea  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000011A:
; H062+$0000011A: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L062_0000011E:
; H062+$0000011E: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L062_00000122:
; H062+$00000122: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_00000124:
; H062+$00000124: 08020000  btst.b #$0, d2
        btst #$0, d2
L062_00000128:
; H062+$00000128: 6702  beq.b $12c
        beq.b H062+$12C
L062_0000012A:
; H062+$0000012A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_0000012C:
; H062+$0000012C: 9ec2  suba.w d2, a7
        suba.w d2, a7
L062_0000012E:
; H062+$0000012E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00000132:
; H062+$00000132: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L062_00000136:
; H062+$00000136: 244f  movea.l a7, a2
        movea.l a7, a2
L062_00000138:
; H062+$00000138: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_0000013A:
; H062+$0000013A: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_0000013C:
; H062+$0000013C: 51cafffc  dbra d2, $13a
        dbra d2, H062+$13A
L062_00000140:
; H062+$00000140: 342d001c  move.w $1c(a5), d2
        move.w $1c(a5), d2
L062_00000144:
; H062+$00000144: 13c200002475  move.b d2, $2475.l
        move.b d2, (H005+$2475).l
L062_0000014A:
; H062+$0000014A: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L062_0000014E:
; H062+$0000014E: 486d001e  pea.l $1e(a5)
        pea.l $1e(a5)
L062_00000152:
; H062+$00000152: 4eb90000083e  jsr $83e.l
        jsr (H062+$83E).l
L062_00000158:
; H062+$00000158: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000015A:
; H062+$0000015A: 143900002475  move.b $2475.l, d2
        move.b (H005+$2475).l, d2
L062_00000160:
; H062+$00000160: 4a42  tst.w d2
        tst.w d2
L062_00000162:
; H062+$00000162: 67000014  beq.w $178
        beq.w H062+$178
L062_00000166:
; H062+$00000166: 4a2d0012  tst.b $12(a5)
        tst.b $12(a5)
L062_0000016A:
; H062+$0000016A: 6700002a  beq.w $196
        beq.w H062+$196
L062_0000016E:
; H062+$0000016E: 0c2d00010014  cmpi.b #$1, $14(a5)
        cmpi.b #$1, $14(a5)
L062_00000174:
; H062+$00000174: 66000020  bne.w $196
        bne.w H062+$196
L062_00000178:
; H062+$00000178: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L062_0000017C:
; H062+$0000017C: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L062_00000180:
; H062+$00000180: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L062_00000184:
; H062+$00000184: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_00000188:
; H062+$00000188: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L062_0000018C:
; H062+$0000018C: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L062_00000192:
; H062+$00000192: 6000007e  bra.w $212
        bra.w H062+$212
L062_00000196:
; H062+$00000196: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L062_0000019A:
; H062+$0000019A: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L062_0000019E:
; H062+$0000019E: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_000001A2:
; H062+$000001A2: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_000001A8:
; H062+$000001A8: 1400  move.b d0, d2
        move.b d0, d2
L062_000001AA:
; H062+$000001AA: 4a02  tst.b d2
        tst.b d2
L062_000001AC:
; H062+$000001AC: 67000020  beq.w $1ce
        beq.w H062+$1CE
L062_000001B0:
; H062+$000001B0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_000001B4:
; H062+$000001B4: 4a6b0002  tst.w $2(a3)
        tst.w $2(a3)
L062_000001B8:
; H062+$000001B8: 63000014  bls.w $1ce
        bls.w H062+$1CE
L062_000001BC:
; H062+$000001BC: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L062_000001C0:
; H062+$000001C0: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L062_000001C4:
; H062+$000001C4: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L062_000001C8:
; H062+$000001C8: 4eb900000452  jsr $452.l
        jsr (H062+$452).l
L062_000001CE:
; H062+$000001CE: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L062_000001D2:
; H062+$000001D2: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L062_000001D6:
; H062+$000001D6: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L062_000001DA:
; H062+$000001DA: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L062_000001DE:
; H062+$000001DE: 1f2d0016  move.b $16(a5), -(a7)
        move.b $16(a5), -(a7)
L062_000001E2:
; H062+$000001E2: 4eb9000015f2  jsr $15f2.l
        jsr (H062+$15F2).l
L062_000001E8:
; H062+$000001E8: 7400  moveq #$0, d2
        moveq #0, d2
L062_000001EA:
; H062+$000001EA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_000001EE:
; H062+$000001EE: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L062_000001F2:
; H062+$000001F2: 6700001e  beq.w $212
        beq.w H062+$212
L062_000001F6:
; H062+$000001F6: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L062_000001FA:
; H062+$000001FA: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L062_000001FE:
; H062+$000001FE: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L062_00000202:
; H062+$00000202: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2760 (sub_H063_00002760)
L062_00000206:
; H062+$00000206: 4eb900002760  jsr $2760.l
        jsr (H063+$2760).l
; -> H063+$1EE8 (sub_H063_00001EE8)
L062_0000020C:
; H062+$0000020C: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
L062_00000212:
; H062+$00000212: 4e5d  unlk a5
        unlk a5
L062_00000214:
; H062+$00000214: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00000216:
; H062+$00000216: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00000218:
; H062+$00000218: 4fef0016  lea.l $16(a7), a7
        lea.l $16(a7), a7
L062_0000021C:
; H062+$0000021C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_0000021E [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$135A, H026+$01E0.
;   - Richiama H063+$135A.
;   - Richiama H026+$01E0.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H059+$125E
; --------------------------------------------------------------------------
L062_0000021E:
; H062+$0000021E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00000220:
; H062+$00000220: 287afee0  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00000224:
; H062+$00000224: 4e55ffaa  link.w a5, #$ffaa
        link.w a5, #$ffaa
L062_00000228:
; H062+$00000228: 23ed000c00002432  move.l $c(a5), $2432.l
        move.l $c(a5), (H005+$2432).l
; STATO: H005+$3364 = testa della lista del party
L062_00000230:
; H062+$00000230: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L062_00000238:
; H062+$00000238: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L062_0000023C:
; H062+$0000023C: 670000b2  beq.w $2f0
        beq.w H062+$2F0
L062_00000240:
; H062+$00000240: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00000244:
; H062+$00000244: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L062_00000248:
; H062+$00000248: 66000098  bne.w $2e2
        bne.w H062+$2E2
L062_0000024C:
; H062+$0000024C: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000024E:
; H062+$0000024E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00000252:
; H062+$00000252: 142b0013  move.b $13(a3), d2
        move.b $13(a3), d2
L062_00000256:
; H062+$00000256: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L062_0000025A:
; H062+$0000025A: 63000086  bls.w $2e2
        bls.w H062+$2E2
L062_0000025E:
; H062+$0000025E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00000262:
; H062+$00000262: 142b0199  move.b $199(a3), d2
        move.b $199(a3), d2
L062_00000266:
; H062+$00000266: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_0000026A:
; H062+$0000026A: b42b0199  cmp.b $199(a3), d2
        cmp.b $199(a3), d2
L062_0000026E:
; H062+$0000026E: 67000072  beq.w $2e2
        beq.w H062+$2E2
L062_00000272:
; H062+$00000272: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H063+$135A (sub_H063_0000135A)
L062_00000276:
; H062+$00000276: 4eb90000135a  jsr $135a.l
        jsr (H063+$135A).l
L062_0000027C:
; H062+$0000027C: 1400  move.b d0, d2
        move.b d0, d2
L062_0000027E:
; H062+$0000027E: 4a02  tst.b d2
        tst.b d2
L062_00000280:
; H062+$00000280: 66000060  bne.w $2e2
        bne.w H062+$2E2
L062_00000284:
; H062+$00000284: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L062_00000288:
; H062+$00000288: 1f3c0004  move.b #$4, -(a7)
        move.b #$4, -(a7)
L062_0000028C:
; H062+$0000028C: 4267  clr.w -(a7)
        clr.w -(a7)
L062_0000028E:
; H062+$0000028E: 4eb90000142c  jsr $142c.l
        jsr (H062+$142C).l
L062_00000294:
; H062+$00000294: 1400  move.b d0, d2
        move.b d0, d2
L062_00000296:
; H062+$00000296: 4a02  tst.b d2
        tst.b d2
L062_00000298:
; H062+$00000298: 66000048  bne.w $2e2
        bne.w H062+$2E2
L062_0000029C:
; H062+$0000029C: 47ec000e  lea.l $e(a4), a3
        lea.l $e(a4), a3
L062_000002A0:
; H062+$000002A0: 45edffaa  lea.l -$56(a5), a2
        lea.l -$56(a5), a2
L062_000002A4:
; H062+$000002A4: 7450  moveq #$50, d2
        moveq #80, d2
L062_000002A6:
; H062+$000002A6: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_000002A8:
; H062+$000002A8: 57cafffc  dbeq d2, $2a6
        dbeq d2, H062+$2A6
L062_000002AC:
; H062+$000002AC: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_000002B0:
; H062+$000002B0: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
L062_000002B4:
; H062+$000002B4: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L062_000002B8:
; H062+$000002B8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L062_000002BC:
; H062+$000002BC: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_000002C2:
; H062+$000002C2: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L062_000002C6:
; H062+$000002C6: 3f3c005b  move.w #$5b, -(a7)
        move.w #$5b, -(a7)
L062_000002CA:
; H062+$000002CA: 4267  clr.w -(a7)
        clr.w -(a7)
L062_000002CC:
; H062+$000002CC: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L062_000002D0:
; H062+$000002D0: 4227  clr.b -(a7)
        clr.b -(a7)
L062_000002D2:
; H062+$000002D2: 4227  clr.b -(a7)
        clr.b -(a7)
L062_000002D4:
; H062+$000002D4: 4227  clr.b -(a7)
        clr.b -(a7)
L062_000002D6:
; H062+$000002D6: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_000002DA:
; H062+$000002DA: 486dffaa  pea.l -$56(a5)
        pea.l -$56(a5)
L062_000002DE:
; H062+$000002DE: 6100fe34  bsr.w $114
        bsr.w H062+$114
L062_000002E2:
; H062+$000002E2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_000002E6:
; H062+$000002E6: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L062_000002EC:
; H062+$000002EC: 6000ff4a  bra.w $238
        bra.w H062+$238
L062_000002F0:
; H062+$000002F0: 4e5d  unlk a5
        unlk a5
L062_000002F2:
; H062+$000002F2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000002F4:
; H062+$000002F4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000002F6:
; H062+$000002F6: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_000002F8:
; H062+$000002F8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000002FA [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$1DC2, H048+$12F4, H030+$0B4A, H063+$1EE8.
;   - Richiama H063+$1DC2.
;   - Richiama H048+$12F4.
;   - Richiama H030+$0B4A.
;   - Richiama H063+$1EE8.
;   - Richiama H063+$0D80.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento); H005+$3368 (personaggio corrente).
; Chiamanti diretti: H027+$0B36, H027+$1EA4, H027+$4168, H027+$223C
; --------------------------------------------------------------------------
L062_000002FA:
; H062+$000002FA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000002FC:
; H062+$000002FC: 287afe04  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00000300:
; H062+$00000300: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_00000304:
; H062+$00000304: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L062_00000308:
; H062+$00000308: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_0000030A:
; H062+$0000030A: 08020000  btst.b #$0, d2
        btst #$0, d2
L062_0000030E:
; H062+$0000030E: 6702  beq.b $312
        beq.b H062+$312
L062_00000310:
; H062+$00000310: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_00000312:
; H062+$00000312: 9ec2  suba.w d2, a7
        suba.w d2, a7
L062_00000314:
; H062+$00000314: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00000318:
; H062+$00000318: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L062_0000031C:
; H062+$0000031C: 244f  movea.l a7, a2
        movea.l a7, a2
L062_0000031E:
; H062+$0000031E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00000320:
; H062+$00000320: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_00000322:
; H062+$00000322: 51cafffc  dbra d2, $320
        dbra d2, H062+$320
L062_00000326:
; H062+$00000326: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_0000032A:
; H062+$0000032A: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L062_0000032E:
; H062+$0000032E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000332:
; H062+$00000332: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_00000336:
; H062+$00000336: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L062_00000338:
; H062+$00000338: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L062_0000033E:
; H062+$0000033E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00000342:
; H062+$00000342: 0c2b00070197  cmpi.b #$7, $197(a3)
        cmpi.b #$7, $197(a3)
L062_00000348:
; H062+$00000348: 6700001e  beq.w $368
        beq.w H062+$368
L062_0000034C:
; H062+$0000034C: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00000350:
; H062+$00000350: 0c2b00060197  cmpi.b #$6, $197(a3)
        cmpi.b #$6, $197(a3)
L062_00000356:
; H062+$00000356: 67000010  beq.w $368
        beq.w H062+$368
L062_0000035A:
; H062+$0000035A: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_0000035E:
; H062+$0000035E: 0c2b00080197  cmpi.b #$8, $197(a3)
        cmpi.b #$8, $197(a3)
L062_00000364:
; H062+$00000364: 66000006  bne.w $36c
        bne.w H062+$36C
L062_00000368:
; H062+$00000368: 6000007c  bra.w $3e6
        bra.w H062+$3E6
L062_0000036C:
; H062+$0000036C: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00000370:
; H062+$00000370: 176d00120197  move.b $12(a5), $197(a3)
        move.b $12(a5), $197(a3)
L062_00000376:
; H062+$00000376: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_0000037A:
; H062+$0000037A: 422b0198  clr.b $198(a3)
        clr.b $198(a3)
L062_0000037E:
; H062+$0000037E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00000382:
; H062+$00000382: 422b01a8  clr.b $1a8(a3)
        clr.b $1a8(a3)
L062_00000386:
; H062+$00000386: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_0000038A:
; H062+$0000038A: 4eb9000017c0  jsr $17c0.l
        jsr (H062+$17C0).l
L062_00000390:
; H062+$00000390: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L062_00000394:
; H062+$00000394: 486d0014  pea.l $14(a5)
        pea.l $14(a5)
L062_00000398:
; H062+$00000398: 4eb90000083e  jsr $83e.l
        jsr (H062+$83E).l
L062_0000039E:
; H062+$0000039E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000003A2:
; H062+$000003A2: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L062_000003A6:
; H062+$000003A6: 6600001a  bne.w $3c2
        bne.w H062+$3C2
L062_000003AA:
; H062+$000003AA: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000003AE:
; H062+$000003AE: 0c2b000a0197  cmpi.b #$a, $197(a3)
        cmpi.b #$a, $197(a3)
L062_000003B4:
; H062+$000003B4: 6700000c  beq.w $3c2
        beq.w H062+$3C2
L062_000003B8:
; H062+$000003B8: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$12F4 (sub_H048_000012F4)
L062_000003BC:
; H062+$000003BC: 4eb9000012f4  jsr $12f4.l
        jsr (H048+$12F4).l
; -> H030+$0B4A (sub_H030_00000B4A)
L062_000003C2:
; H062+$000003C2: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
; -> H063+$1EE8 (sub_H063_00001EE8)
L062_000003C8:
; H062+$000003C8: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L062_000003CE:
; H062+$000003CE: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L062_000003D6:
; H062+$000003D6: 6700000e  beq.w $3e6
        beq.w H062+$3E6
; STATO: H005+$3368 = personaggio corrente
L062_000003DA:
; H062+$000003DA: 2f3900003368  move.l $3368.l, -(a7)
        move.l (H005+$3368).l, -(a7)
; -> H063+$0D80 (sub_H063_00000D80)
L062_000003E0:
; H062+$000003E0: 4eb900000d80  jsr $d80.l
        jsr (H063+$D80).l
L062_000003E6:
; H062+$000003E6: 4e5d  unlk a5
        unlk a5
L062_000003E8:
; H062+$000003E8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000003EA:
; H062+$000003EA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000003EC:
; H062+$000003EC: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L062_000003F0:
; H062+$000003F0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000003F2 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$113A, H027+$1150, H085+$25EE, H085+$36AC, H085+$372C, H085+$37CE e altri 10
; --------------------------------------------------------------------------
L062_000003F2:
; H062+$000003F2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000003F4:
; H062+$000003F4: 287afd0c  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_000003F8:
; H062+$000003F8: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_000003FC:
; H062+$000003FC: 4a39000024e0  tst.b $24e0.l
        tst.b (H005+$24E0).l
L062_00000402:
; H062+$00000402: 6700001a  beq.w $41e
        beq.w H062+$41E
L062_00000406:
; H062+$00000406: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_0000040A:
; H062+$0000040A: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_0000040E:
; H062+$0000040E: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L062_00000412:
; H062+$00000412: 267900002a0e  movea.l $2a0e.l, a3
        movea.l (H005+$2A0E).l, a3
L062_00000418:
; H062+$00000418: 4e93  jsr (a3)
        jsr (a3)
L062_0000041A:
; H062+$0000041A: 6000002a  bra.w $446
        bra.w H062+$446
L062_0000041E:
; H062+$0000041E: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L062_00000422:
; H062+$00000422: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00000424:
; H062+$00000424: e542  asl.w #$2, d2
        asl.w #$2, d2
L062_00000426:
; H062+$00000426: 47f900002832  lea.l $2832.l, a3
        lea.l (H005+$2832).l, a3
L062_0000042C:
; H062+$0000042C: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L062_00000430:
; H062+$00000430: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_00000434:
; H062+$00000434: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00000438:
; H062+$00000438: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L062_0000043C:
; H062+$0000043C: 26732000  movea.l (a3, d2.w), a3
        movea.l (a3, d2.w), a3
L062_00000440:
; H062+$00000440: 4e93  jsr (a3)
        jsr (a3)
L062_00000442:
; H062+$00000442: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L062_00000446:
; H062+$00000446: 4e5d  unlk a5
        unlk a5
L062_00000448:
; H062+$00000448: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_0000044A:
; H062+$0000044A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000044C:
; H062+$0000044C: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L062_00000450:
; H062+$00000450: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00000452 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H003+$00F6.
;   - Richiama H003+$00F6.
; Chiamanti diretti: H027+$08CA, H027+$0B48, H027+$0B62, H027+$0EB4, H027+$1072, H027+$1084 e altri 41
; --------------------------------------------------------------------------
L062_00000452:
; H062+$00000452: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00000454:
; H062+$00000454: 287afcac  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00000458:
; H062+$00000458: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L062_0000045C:
; H062+$0000045C: 2b6d000cfff8  move.l $c(a5), -$8(a5)
        move.l $c(a5), -$8(a5)
L062_00000462:
; H062+$00000462: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L062_00000466:
; H062+$00000466: 66000038  bne.w $4a0
        bne.w H062+$4A0
L062_0000046A:
; H062+$0000046A: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000046E:
; H062+$0000046E: 2b6b00e8fff8  move.l $e8(a3), -$8(a5)
        move.l $e8(a3), -$8(a5)
L062_00000474:
; H062+$00000474: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L062_00000478:
; H062+$00000478: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L062_0000047C:
; H062+$0000047C: 67000022  beq.w $4a0
        beq.w H062+$4A0
L062_00000480:
; H062+$00000480: 7400  moveq #$0, d2
        moveq #0, d2
L062_00000482:
; H062+$00000482: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_00000486:
; H062+$00000486: 1413  move.b (a3), d2
        move.b (a3), d2
L062_00000488:
; H062+$00000488: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L062_0000048C:
; H062+$0000048C: 67000012  beq.w $4a0
        beq.w H062+$4A0
L062_00000490:
; H062+$00000490: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L062_00000494:
; H062+$00000494: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_00000498:
; H062+$00000498: 2b6b0006fff8  move.l $6(a3), -$8(a5)
        move.l $6(a3), -$8(a5)
L062_0000049E:
; H062+$0000049E: 60d8  bra.b $478
        bra.b H062+$478
L062_000004A0:
; H062+$000004A0: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L062_000004A4:
; H062+$000004A4: 66000006  bne.w $4ac
        bne.w H062+$4AC
L062_000004A8:
; H062+$000004A8: 600000c6  bra.w $570
        bra.w H062+$570
L062_000004AC:
; H062+$000004AC: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_000004B0:
; H062+$000004B0: 4a2b0005  tst.b $5(a3)
        tst.b $5(a3)
L062_000004B4:
; H062+$000004B4: 67000016  beq.w $4cc
        beq.w H062+$4CC
L062_000004B8:
; H062+$000004B8: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L062_000004BC:
; H062+$000004BC: 486d0012  pea.l $12(a5)
        pea.l $12(a5)
L062_000004C0:
; H062+$000004C0: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L062_000004C4:
; H062+$000004C4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L062_000004C8:
; H062+$000004C8: 6100ff28  bsr.w $3f2
        bsr.w H062+$3F2
L062_000004CC:
; H062+$000004CC: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_000004D0:
; H062+$000004D0: 242b00e8  move.l $e8(a3), d2
        move.l $e8(a3), d2
L062_000004D4:
; H062+$000004D4: b4adfff8  cmp.l -$8(a5), d2
        cmp.l -$8(a5), d2
L062_000004D8:
; H062+$000004D8: 66000014  bne.w $4ee
        bne.w H062+$4EE
L062_000004DC:
; H062+$000004DC: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_000004E0:
; H062+$000004E0: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L062_000004E4:
; H062+$000004E4: 256b000600e8  move.l $6(a3), $e8(a2)
        move.l $6(a3), $e8(a2)
L062_000004EA:
; H062+$000004EA: 6000003e  bra.w $52a
        bra.w H062+$52A
L062_000004EE:
; H062+$000004EE: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_000004F2:
; H062+$000004F2: 2b6b00e8fffc  move.l $e8(a3), -$4(a5)
        move.l $e8(a3), -$4(a5)
L062_000004F8:
; H062+$000004F8: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L062_000004FC:
; H062+$000004FC: 6700001e  beq.w $51c
        beq.w H062+$51C
L062_00000500:
; H062+$00000500: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00000504:
; H062+$00000504: 242b0006  move.l $6(a3), d2
        move.l $6(a3), d2
L062_00000508:
; H062+$00000508: b4adfff8  cmp.l -$8(a5), d2
        cmp.l -$8(a5), d2
L062_0000050C:
; H062+$0000050C: 6700000e  beq.w $51c
        beq.w H062+$51C
L062_00000510:
; H062+$00000510: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00000514:
; H062+$00000514: 2b6b0006fffc  move.l $6(a3), -$4(a5)
        move.l $6(a3), -$4(a5)
L062_0000051A:
; H062+$0000051A: 60dc  bra.b $4f8
        bra.b H062+$4F8
L062_0000051C:
; H062+$0000051C: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_00000520:
; H062+$00000520: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L062_00000524:
; H062+$00000524: 256b00060006  move.l $6(a3), $6(a2)
        move.l $6(a3), $6(a2)
L062_0000052A:
; H062+$0000052A: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L062_0000052E:
; H062+$0000052E: 740a  moveq #$a, d2
        moveq #10, d2
L062_00000530:
; H062+$00000530: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L062_00000532:
; H062+$00000532: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L062_00000538:
; H062+$00000538: 0c6d000e0010  cmpi.w #$e, $10(a5)
        cmpi.w #$e, $10(a5)
L062_0000053E:
; H062+$0000053E: 66000010  bne.w $550
        bne.w H062+$550
L062_00000542:
; H062+$00000542: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_00000546:
; H062+$00000546: 1f3c0005  move.b #$5, -(a7)
        move.b #$5, -(a7)
L062_0000054A:
; H062+$0000054A: 4eb900001a32  jsr $1a32.l
        jsr (H062+$1A32).l
L062_00000550:
; H062+$00000550: 0c6d000c0010  cmpi.w #$c, $10(a5)
        cmpi.w #$c, $10(a5)
L062_00000556:
; H062+$00000556: 6700000c  beq.w $564
        beq.w H062+$564
L062_0000055A:
; H062+$0000055A: 0c6d00260010  cmpi.w #$26, $10(a5)
        cmpi.w #$26, $10(a5)
L062_00000560:
; H062+$00000560: 6600000e  bne.w $570
        bne.w H062+$570
L062_00000564:
; H062+$00000564: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_00000568:
; H062+$00000568: 4227  clr.b -(a7)
        clr.b -(a7)
L062_0000056A:
; H062+$0000056A: 4eb900001a32  jsr $1a32.l
        jsr (H062+$1A32).l
L062_00000570:
; H062+$00000570: 4e5d  unlk a5
        unlk a5
L062_00000572:
; H062+$00000572: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00000574:
; H062+$00000574: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00000576:
; H062+$00000576: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L062_0000057A:
; H062+$0000057A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_0000057C [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$0946, H048+$0F88, H048+$0FBA, H048+$110C.
;   - Richiama H063+$0946.
;   - Richiama H048+$0F88.
;   - Richiama H048+$0FBA.
;   - Richiama H048+$110C.
;   - Richiama H077+$08AC.
;   - Richiama H048+$0AA8.
;   - Usa lo stato globale: H005+$3364 (testa della lista del party); H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H062+$085A, H062+$0866, H062+$0874, H062+$0880, H062+$088C, H062+$0898 e altri 127
; --------------------------------------------------------------------------
L062_0000057C:
; H062+$0000057C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000057E:
; H062+$0000057E: 287afb82  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00000582:
; H062+$00000582: 4e55ff50  link.w a5, #$ff50
        link.w a5, #$ff50
L062_00000586:
; H062+$00000586: 422dff57  clr.b -$a9(a5)
        clr.b -$a9(a5)
; STATO: H005+$3364 = testa della lista del party
L062_0000058A:
; H062+$0000058A: 2b7900003364ff5c  move.l $3364.l, -$a4(a5)
        move.l (H005+$3364).l, -$a4(a5)
L062_00000592:
; H062+$00000592: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00000596:
; H062+$00000596: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L062_00000598:
; H062+$00000598: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L062_0000059C:
; H062+$0000059C: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_000005A0:
; H062+$000005A0: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_000005A6:
; H062+$000005A6: 1400  move.b d0, d2
        move.b d0, d2
L062_000005A8:
; H062+$000005A8: 4a02  tst.b d2
        tst.b d2
L062_000005AA:
; H062+$000005AA: 6700000c  beq.w $5b8
        beq.w H062+$5B8
L062_000005AE:
; H062+$000005AE: 1b7c0001ff57  move.b #$1, -$a9(a5)
        move.b #$1, -$a9(a5)
L062_000005B4:
; H062+$000005B4: 60000198  bra.w $74e
        bra.w H062+$74E
L062_000005B8:
; H062+$000005B8: 0c6d0015000c  cmpi.w #$15, $c(a5)
        cmpi.w #$15, $c(a5)
L062_000005BE:
; H062+$000005BE: 67000020  beq.w $5e0
        beq.w H062+$5E0
L062_000005C2:
; H062+$000005C2: 0c6d002d000c  cmpi.w #$2d, $c(a5)
        cmpi.w #$2d, $c(a5)
L062_000005C8:
; H062+$000005C8: 67000016  beq.w $5e0
        beq.w H062+$5E0
L062_000005CC:
; H062+$000005CC: 0c6d002e000c  cmpi.w #$2e, $c(a5)
        cmpi.w #$2e, $c(a5)
L062_000005D2:
; H062+$000005D2: 6700000c  beq.w $5e0
        beq.w H062+$5E0
L062_000005D6:
; H062+$000005D6: 0c6d0031000c  cmpi.w #$31, $c(a5)
        cmpi.w #$31, $c(a5)
L062_000005DC:
; H062+$000005DC: 66000170  bne.w $74e
        bne.w H062+$74E
L062_000005E0:
; H062+$000005E0: 3b7c0001ff50  move.w #$1, -$b0(a5)
        move.w #$1, -$b0(a5)
L062_000005E6:
; H062+$000005E6: 0c6d0028ff50  cmpi.w #$28, -$b0(a5)
        cmpi.w #$28, -$b0(a5)
L062_000005EC:
; H062+$000005EC: 6200002c  bhi.w $61a
        bhi.w H062+$61A
L062_000005F0:
; H062+$000005F0: 342dff50  move.w -$b0(a5), d2
        move.w -$b0(a5), d2
L062_000005F4:
; H062+$000005F4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_000005F6:
; H062+$000005F6: e542  asl.w #$2, d2
        asl.w #$2, d2
L062_000005F8:
; H062+$000005F8: 47edff60  lea.l -$a0(a5), a3
        lea.l -$a0(a5), a3
L062_000005FC:
; H062+$000005FC: 382dff50  move.w -$b0(a5), d4
        move.w -$b0(a5), d4
L062_00000600:
; H062+$00000600: 5344  subq.w #$1, d4
        subq.w #$1, d4
L062_00000602:
; H062+$00000602: e544  asl.w #$2, d4
        asl.w #$2, d4
L062_00000604:
; H062+$00000604: 45f900002a3e  lea.l $2a3e.l, a2
        lea.l (H005+$2A3E).l, a2
L062_0000060A:
; H062+$0000060A: 45f24000  lea.l (a2, d4.w), a2
        lea.l (a2, d4.w), a2
L062_0000060E:
; H062+$0000060E: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L062_00000612:
; H062+$00000612: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L062_00000614:
; H062+$00000614: 526dff50  addq.w #$1, -$b0(a5)
        addq.w #$1, -$b0(a5)
L062_00000618:
; H062+$00000618: 64cc  bcc.b $5e6
        bcc.b H062+$5E6
L062_0000061A:
; H062+$0000061A: 4aadff5c  tst.l -$a4(a5)
        tst.l -$a4(a5)
L062_0000061E:
; H062+$0000061E: 670000f4  beq.w $714
        beq.w H062+$714
L062_00000622:
; H062+$00000622: 4a2dff57  tst.b -$a9(a5)
        tst.b -$a9(a5)
L062_00000626:
; H062+$00000626: 660000ec  bne.w $714
        bne.w H062+$714
L062_0000062A:
; H062+$0000062A: 2f2dff5c  move.l -$a4(a5), -(a7)
        move.l -$a4(a5), -(a7)
L062_0000062E:
; H062+$0000062E: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L062_00000632:
; H062+$00000632: 486dff58  pea.l -$a8(a5)
        pea.l -$a8(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_00000636:
; H062+$00000636: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_0000063C:
; H062+$0000063C: 1400  move.b d0, d2
        move.b d0, d2
L062_0000063E:
; H062+$0000063E: 4a02  tst.b d2
        tst.b d2
L062_00000640:
; H062+$00000640: 670000c4  beq.w $706
        beq.w H062+$706
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L062_00000644:
; H062+$00000644: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L062_0000064C:
; H062+$0000064C: 660000b2  bne.w $700
        bne.w H062+$700
L062_00000650:
; H062+$00000650: 0c6d0031000c  cmpi.w #$31, $c(a5)
        cmpi.w #$31, $c(a5)
L062_00000656:
; H062+$00000656: 6600000c  bne.w $664
        bne.w H062+$664
L062_0000065A:
; H062+$0000065A: 3b7c0006ff52  move.w #$6, -$ae(a5)
        move.w #$6, -$ae(a5)
L062_00000660:
; H062+$00000660: 60000008  bra.w $66a
        bra.w H062+$66A
L062_00000664:
; H062+$00000664: 3b7c0001ff52  move.w #$1, -$ae(a5)
        move.w #$1, -$ae(a5)
L062_0000066A:
; H062+$0000066A: 2f2dff5c  move.l -$a4(a5), -(a7)
        move.l -$a4(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L062_0000066E:
; H062+$0000066E: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L062_00000674:
; H062+$00000674: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_00000676:
; H062+$00000676: 2f2dff5c  move.l -$a4(a5), -(a7)
        move.l -$a4(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L062_0000067A:
; H062+$0000067A: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L062_00000680:
; H062+$00000680: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_00000682:
; H062+$00000682: 3f2dff52  move.w -$ae(a5), -(a7)
        move.w -$ae(a5), -(a7)
L062_00000686:
; H062+$00000686: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L062_0000068A:
; H062+$0000068A: 2f2dff5c  move.l -$a4(a5), -(a7)
        move.l -$a4(a5), -(a7)
; -> H048+$110C (sub_H048_0000110C)
L062_0000068E:
; H062+$0000068E: 4eb90000110c  jsr $110c.l
        jsr (H048+$110C).l
L062_00000694:
; H062+$00000694: 1400  move.b d0, d2
        move.b d0, d2
L062_00000696:
; H062+$00000696: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L062_0000069A:
; H062+$0000069A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L062_0000069C:
; H062+$0000069C: 2f3900002ade  move.l $2ade.l, -(a7)
        move.l (H005+$2ADE).l, -(a7)
; -> H077+$08AC (sub_H077_000008AC)
L062_000006A2:
; H062+$000006A2: 4eb9000008ac  jsr $8ac.l
        jsr (H077+$8AC).l
L062_000006A8:
; H062+$000006A8: 3b7c0001ff54  move.w #$1, -$ac(a5)
        move.w #$1, -$ac(a5)
L062_000006AE:
; H062+$000006AE: 7400  moveq #$0, d2
        moveq #0, d2
L062_000006B0:
; H062+$000006B0: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L062_000006B6:
; H062+$000006B6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L062_000006B8:
; H062+$000006B8: 342dff54  move.w -$ac(a5), d2
        move.w -$ac(a5), d2
L062_000006BC:
; H062+$000006BC: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L062_000006BE:
; H062+$000006BE: 6200003a  bhi.w $6fa
        bhi.w H062+$6FA
L062_000006C2:
; H062+$000006C2: 342dff54  move.w -$ac(a5), d2
        move.w -$ac(a5), d2
L062_000006C6:
; H062+$000006C6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_000006C8:
; H062+$000006C8: e542  asl.w #$2, d2
        asl.w #$2, d2
L062_000006CA:
; H062+$000006CA: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L062_000006D0:
; H062+$000006D0: 7800  moveq #$0, d4
        moveq #0, d4
L062_000006D2:
; H062+$000006D2: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_000006D6:
; H062+$000006D6: 2f04  move.l d4, -(a7)
        move.l d4, -(a7)
L062_000006D8:
; H062+$000006D8: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_000006DC:
; H062+$000006DC: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
; -> H048+$0AA8 (sub_H048_00000AA8)
L062_000006DE:
; H062+$000006DE: 4eb900000aa8  jsr $aa8.l
        jsr (H048+$AA8).l
L062_000006E4:
; H062+$000006E4: 281f  move.l (a7)+, d4
        move.l (a7)+, d4
L062_000006E6:
; H062+$000006E6: 3400  move.w d0, d2
        move.w d0, d2
L062_000006E8:
; H062+$000006E8: b842  cmp.w d2, d4
        cmp.w d2, d4
L062_000006EA:
; H062+$000006EA: 66000008  bne.w $6f4
        bne.w H062+$6F4
L062_000006EE:
; H062+$000006EE: 1b7c0001ff57  move.b #$1, -$a9(a5)
        move.b #$1, -$a9(a5)
L062_000006F4:
; H062+$000006F4: 526dff54  addq.w #$1, -$ac(a5)
        addq.w #$1, -$ac(a5)
L062_000006F8:
; H062+$000006F8: 64be  bcc.b $6b8
        bcc.b H062+$6B8
L062_000006FA:
; H062+$000006FA: 548f  addq.l #$2, a7
        addq.l #$2, a7
L062_000006FC:
; H062+$000006FC: 60000008  bra.w $706
        bra.w H062+$706
L062_00000700:
; H062+$00000700: 1b7c0001ff57  move.b #$1, -$a9(a5)
        move.b #$1, -$a9(a5)
L062_00000706:
; H062+$00000706: 266dff5c  movea.l -$a4(a5), a3
        movea.l -$a4(a5), a3
L062_0000070A:
; H062+$0000070A: 2b6b018eff5c  move.l $18e(a3), -$a4(a5)
        move.l $18e(a3), -$a4(a5)
L062_00000710:
; H062+$00000710: 6000ff08  bra.w $61a
        bra.w H062+$61A
L062_00000714:
; H062+$00000714: 3b7c0001ff50  move.w #$1, -$b0(a5)
        move.w #$1, -$b0(a5)
L062_0000071A:
; H062+$0000071A: 0c6d0028ff50  cmpi.w #$28, -$b0(a5)
        cmpi.w #$28, -$b0(a5)
L062_00000720:
; H062+$00000720: 6200002c  bhi.w $74e
        bhi.w H062+$74E
L062_00000724:
; H062+$00000724: 342dff50  move.w -$b0(a5), d2
        move.w -$b0(a5), d2
L062_00000728:
; H062+$00000728: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_0000072A:
; H062+$0000072A: e542  asl.w #$2, d2
        asl.w #$2, d2
L062_0000072C:
; H062+$0000072C: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L062_00000732:
; H062+$00000732: 382dff50  move.w -$b0(a5), d4
        move.w -$b0(a5), d4
L062_00000736:
; H062+$00000736: 5344  subq.w #$1, d4
        subq.w #$1, d4
L062_00000738:
; H062+$00000738: e544  asl.w #$2, d4
        asl.w #$2, d4
L062_0000073A:
; H062+$0000073A: 45edff60  lea.l -$a0(a5), a2
        lea.l -$a0(a5), a2
L062_0000073E:
; H062+$0000073E: 45f24000  lea.l (a2, d4.w), a2
        lea.l (a2, d4.w), a2
L062_00000742:
; H062+$00000742: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L062_00000746:
; H062+$00000746: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L062_00000748:
; H062+$00000748: 526dff50  addq.w #$1, -$b0(a5)
        addq.w #$1, -$b0(a5)
L062_0000074C:
; H062+$0000074C: 64cc  bcc.b $71a
        bcc.b H062+$71A
L062_0000074E:
; H062+$0000074E: 4a2dff57  tst.b -$a9(a5)
        tst.b -$a9(a5)
L062_00000752:
; H062+$00000752: 67000014  beq.w $768
        beq.w H062+$768
L062_00000756:
; H062+$00000756: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L062_0000075A:
; H062+$0000075A: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_0000075E:
; H062+$0000075E: 2f2dff58  move.l -$a8(a5), -(a7)
        move.l -$a8(a5), -(a7)
L062_00000762:
; H062+$00000762: 4227  clr.b -(a7)
        clr.b -(a7)
L062_00000764:
; H062+$00000764: 6100fc8c  bsr.w $3f2
        bsr.w H062+$3F2
L062_00000768:
; H062+$00000768: 4e5d  unlk a5
        unlk a5
L062_0000076A:
; H062+$0000076A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_0000076C:
; H062+$0000076C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000076E:
; H062+$0000076E: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L062_00000770:
; H062+$00000770: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00000772 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H029+$0354, H063+$2FAA.
;   - Richiama H029+$0354.
;   - Richiama H063+$2FAA.
; Chiamanti diretti: H062+$09CA, H062+$0ACA
; --------------------------------------------------------------------------
L062_00000772:
; H062+$00000772: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00000774:
; H062+$00000774: 287af98c  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00000778:
; H062+$00000778: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L062_0000077C:
; H062+$0000077C: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000077E:
; H062+$0000077E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00000782:
; H062+$00000782: 142b0196  move.b $196(a3), d2
        move.b $196(a3), d2
L062_00000786:
; H062+$00000786: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L062_0000078A:
; H062+$0000078A: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L062_0000078E:
; H062+$0000078E: 670000a4  beq.w $834
        beq.w H062+$834
L062_00000792:
; H062+$00000792: 7400  moveq #$0, d2
        moveq #0, d2
L062_00000794:
; H062+$00000794: 143900002475  move.b $2475.l, d2
        move.b (H005+$2475).l, d2
L062_0000079A:
; H062+$0000079A: 4a42  tst.w d2
        tst.w d2
L062_0000079C:
; H062+$0000079C: 67000096  beq.w $834
        beq.w H062+$834
L062_000007A0:
; H062+$000007A0: 7400  moveq #$0, d2
        moveq #0, d2
L062_000007A2:
; H062+$000007A2: 143900002474  move.b $2474.l, d2
        move.b (H005+$2474).l, d2
L062_000007A8:
; H062+$000007A8: 4a42  tst.w d2
        tst.w d2
L062_000007AA:
; H062+$000007AA: 6700001e  beq.w $7ca
        beq.w H062+$7CA
L062_000007AE:
; H062+$000007AE: 1f3900002473  move.b $2473.l, -(a7)
        move.b (H005+$2473).l, -(a7)
L062_000007B4:
; H062+$000007B4: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L062_000007B8:
; H062+$000007B8: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L062_000007BE:
; H062+$000007BE: 1400  move.b d0, d2
        move.b d0, d2
L062_000007C0:
; H062+$000007C0: 4a02  tst.b d2
        tst.b d2
L062_000007C2:
; H062+$000007C2: 66000006  bne.w $7ca
        bne.w H062+$7CA
L062_000007C6:
; H062+$000007C6: 6000006c  bra.w $834
        bra.w H062+$834
L062_000007CA:
; H062+$000007CA: 7400  moveq #$0, d2
        moveq #0, d2
L062_000007CC:
; H062+$000007CC: 143900002471  move.b $2471.l, d2
        move.b (H005+$2471).l, d2
L062_000007D2:
; H062+$000007D2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H063+$2FAA (sub_H063_00002FAA)
L062_000007D4:
; H062+$000007D4: 4eb900002faa  jsr $2faa.l
        jsr (H063+$2FAA).l
L062_000007DA:
; H062+$000007DA: 3b40fffa  move.w d0, -$6(a5)
        move.w d0, -$6(a5)
L062_000007DE:
; H062+$000007DE: 740b  moveq #$b, d2
        moveq #11, d2
L062_000007E0:
; H062+$000007E0: 946dfffa  sub.w -$6(a5), d2
        sub.w -$6(a5), d2
L062_000007E4:
; H062+$000007E4: c4fc0005  mulu.w #$5, d2
        mulu.w #$5, d2
L062_000007E8:
; H062+$000007E8: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L062_000007EC:
; H062+$000007EC: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L062_000007F0:
; H062+$000007F0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_000007F4:
; H062+$000007F4: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
L062_000007F8:
; H062+$000007F8: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L062_000007FE:
; H062+$000007FE: 3400  move.w d0, d2
        move.w d0, d2
L062_00000800:
; H062+$00000800: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L062_00000804:
; H062+$00000804: 6200002e  bhi.w $834
        bhi.w H062+$834
L062_00000808:
; H062+$00000808: 423900002474  clr.b $2474.l
        clr.b (H005+$2474).l
L062_0000080E:
; H062+$0000080E: 7400  moveq #$0, d2
        moveq #0, d2
L062_00000810:
; H062+$00000810: 143900002475  move.b $2475.l, d2
        move.b (H005+$2475).l, d2
L062_00000816:
; H062+$00000816: 0c42005b  cmpi.w #$5b, d2
        cmpi.w #$5b, d2
L062_0000081A:
; H062+$0000081A: 67000018  beq.w $834
        beq.w H062+$834
L062_0000081E:
; H062+$0000081E: 7400  moveq #$0, d2
        moveq #0, d2
L062_00000820:
; H062+$00000820: 143900002475  move.b $2475.l, d2
        move.b (H005+$2475).l, d2
L062_00000826:
; H062+$00000826: 0c420052  cmpi.w #$52, d2
        cmpi.w #$52, d2
L062_0000082A:
; H062+$0000082A: 67000008  beq.w $834
        beq.w H062+$834
L062_0000082E:
; H062+$0000082E: 423900002475  clr.b $2475.l
        clr.b (H005+$2475).l
L062_00000834:
; H062+$00000834: 4e5d  unlk a5
        unlk a5
L062_00000836:
; H062+$00000836: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00000838:
; H062+$00000838: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000083A:
; H062+$0000083A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_0000083C:
; H062+$0000083C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H062_0F04 [parziale]
; Scopo: Trampolino verso H062+$0F04; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H062+$0F04.
; Chiamanti diretti: H085+$3686, H062+$21A4, H062+$0152, H062+$2206, H062+$0398, H085+$3170 e altri 26
; --------------------------------------------------------------------------
L062_0000083E:
; H062+$0000083E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00000840:
; H062+$00000840: 287af8c0  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00000844:
; H062+$00000844: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L062_00000848:
; H062+$00000848: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L062_0000084C:
; H062+$0000084C: 600006b6  bra.w $f04
        bra.w H062+$F04
L062_00000850:
; H062+$00000850: 4e75  rts 
        rts 
L062_00000852:
; H062+$00000852: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000856:
; H062+$00000856: 3f3c0025  move.w #$25, -(a7)
        move.w #$25, -(a7)
L062_0000085A:
; H062+$0000085A: 6100fd20  bsr.w $57c
        bsr.w H062+$57C
L062_0000085E:
; H062+$0000085E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000862:
; H062+$00000862: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
L062_00000866:
; H062+$00000866: 6100fd14  bsr.w $57c
        bsr.w H062+$57C
L062_0000086A:
; H062+$0000086A: 4e75  rts 
        rts 
L062_0000086C:
; H062+$0000086C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000870:
; H062+$00000870: 3f3c0058  move.w #$58, -(a7)
        move.w #$58, -(a7)
L062_00000874:
; H062+$00000874: 6100fd06  bsr.w $57c
        bsr.w H062+$57C
L062_00000878:
; H062+$00000878: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000087C:
; H062+$0000087C: 3f3c0057  move.w #$57, -(a7)
        move.w #$57, -(a7)
L062_00000880:
; H062+$00000880: 6100fcfa  bsr.w $57c
        bsr.w H062+$57C
L062_00000884:
; H062+$00000884: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000888:
; H062+$00000888: 3f3c0056  move.w #$56, -(a7)
        move.w #$56, -(a7)
L062_0000088C:
; H062+$0000088C: 6100fcee  bsr.w $57c
        bsr.w H062+$57C
L062_00000890:
; H062+$00000890: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000894:
; H062+$00000894: 3f3c0051  move.w #$51, -(a7)
        move.w #$51, -(a7)
L062_00000898:
; H062+$00000898: 6100fce2  bsr.w $57c
        bsr.w H062+$57C
L062_0000089C:
; H062+$0000089C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008A0:
; H062+$000008A0: 3f3c0045  move.w #$45, -(a7)
        move.w #$45, -(a7)
L062_000008A4:
; H062+$000008A4: 6100fcd6  bsr.w $57c
        bsr.w H062+$57C
L062_000008A8:
; H062+$000008A8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008AC:
; H062+$000008AC: 3f3c0040  move.w #$40, -(a7)
        move.w #$40, -(a7)
L062_000008B0:
; H062+$000008B0: 6100fcca  bsr.w $57c
        bsr.w H062+$57C
L062_000008B4:
; H062+$000008B4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008B8:
; H062+$000008B8: 3f3c0041  move.w #$41, -(a7)
        move.w #$41, -(a7)
L062_000008BC:
; H062+$000008BC: 6100fcbe  bsr.w $57c
        bsr.w H062+$57C
L062_000008C0:
; H062+$000008C0: 4e75  rts 
        rts 
L062_000008C2:
; H062+$000008C2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008C6:
; H062+$000008C6: 3f3c0045  move.w #$45, -(a7)
        move.w #$45, -(a7)
L062_000008CA:
; H062+$000008CA: 6100fcb0  bsr.w $57c
        bsr.w H062+$57C
L062_000008CE:
; H062+$000008CE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008D2:
; H062+$000008D2: 3f3c0040  move.w #$40, -(a7)
        move.w #$40, -(a7)
L062_000008D6:
; H062+$000008D6: 6100fca4  bsr.w $57c
        bsr.w H062+$57C
L062_000008DA:
; H062+$000008DA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008DE:
; H062+$000008DE: 3f3c0041  move.w #$41, -(a7)
        move.w #$41, -(a7)
L062_000008E2:
; H062+$000008E2: 6100fc98  bsr.w $57c
        bsr.w H062+$57C
L062_000008E6:
; H062+$000008E6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008EA:
; H062+$000008EA: 3f3c0051  move.w #$51, -(a7)
        move.w #$51, -(a7)
L062_000008EE:
; H062+$000008EE: 6100fc8c  bsr.w $57c
        bsr.w H062+$57C
L062_000008F2:
; H062+$000008F2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000008F6:
; H062+$000008F6: 3f3c0056  move.w #$56, -(a7)
        move.w #$56, -(a7)
L062_000008FA:
; H062+$000008FA: 6100fc80  bsr.w $57c
        bsr.w H062+$57C
L062_000008FE:
; H062+$000008FE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000902:
; H062+$00000902: 3f3c0057  move.w #$57, -(a7)
        move.w #$57, -(a7)
L062_00000906:
; H062+$00000906: 6100fc74  bsr.w $57c
        bsr.w H062+$57C
L062_0000090A:
; H062+$0000090A: 4e75  rts 
        rts 
L062_0000090C:
; H062+$0000090C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000910:
; H062+$00000910: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L062_00000914:
; H062+$00000914: 6100fc66  bsr.w $57c
        bsr.w H062+$57C
L062_00000918:
; H062+$00000918: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000091C:
; H062+$0000091C: 3f3c001d  move.w #$1d, -(a7)
        move.w #$1d, -(a7)
L062_00000920:
; H062+$00000920: 6100fc5a  bsr.w $57c
        bsr.w H062+$57C
L062_00000924:
; H062+$00000924: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000928:
; H062+$00000928: 3f3c004b  move.w #$4b, -(a7)
        move.w #$4b, -(a7)
L062_0000092C:
; H062+$0000092C: 6100fc4e  bsr.w $57c
        bsr.w H062+$57C
L062_00000930:
; H062+$00000930: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000934:
; H062+$00000934: 3f3c0069  move.w #$69, -(a7)
        move.w #$69, -(a7)
L062_00000938:
; H062+$00000938: 6100fc42  bsr.w $57c
        bsr.w H062+$57C
L062_0000093C:
; H062+$0000093C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000940:
; H062+$00000940: 3f3c0072  move.w #$72, -(a7)
        move.w #$72, -(a7)
L062_00000944:
; H062+$00000944: 6100fc36  bsr.w $57c
        bsr.w H062+$57C
L062_00000948:
; H062+$00000948: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000094C:
; H062+$0000094C: 3f3c0073  move.w #$73, -(a7)
        move.w #$73, -(a7)
L062_00000950:
; H062+$00000950: 6100fc2a  bsr.w $57c
        bsr.w H062+$57C
L062_00000954:
; H062+$00000954: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000958:
; H062+$00000958: 3f3c0075  move.w #$75, -(a7)
        move.w #$75, -(a7)
L062_0000095C:
; H062+$0000095C: 6100fc1e  bsr.w $57c
        bsr.w H062+$57C
L062_00000960:
; H062+$00000960: 4e75  rts 
        rts 
L062_00000962:
; H062+$00000962: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000966:
; H062+$00000966: 3f3c003b  move.w #$3b, -(a7)
        move.w #$3b, -(a7)
L062_0000096A:
; H062+$0000096A: 6100fc10  bsr.w $57c
        bsr.w H062+$57C
L062_0000096E:
; H062+$0000096E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000972:
; H062+$00000972: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L062_00000976:
; H062+$00000976: 6100fc04  bsr.w $57c
        bsr.w H062+$57C
L062_0000097A:
; H062+$0000097A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000097E:
; H062+$0000097E: 3f3c0029  move.w #$29, -(a7)
        move.w #$29, -(a7)
L062_00000982:
; H062+$00000982: 6100fbf8  bsr.w $57c
        bsr.w H062+$57C
L062_00000986:
; H062+$00000986: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000098A:
; H062+$0000098A: 3f3c0064  move.w #$64, -(a7)
        move.w #$64, -(a7)
L062_0000098E:
; H062+$0000098E: 6100fbec  bsr.w $57c
        bsr.w H062+$57C
L062_00000992:
; H062+$00000992: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000996:
; H062+$00000996: 3f3c0067  move.w #$67, -(a7)
        move.w #$67, -(a7)
L062_0000099A:
; H062+$0000099A: 6100fbe0  bsr.w $57c
        bsr.w H062+$57C
L062_0000099E:
; H062+$0000099E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000009A2:
; H062+$000009A2: 3f3c005d  move.w #$5d, -(a7)
        move.w #$5d, -(a7)
L062_000009A6:
; H062+$000009A6: 6100fbd4  bsr.w $57c
        bsr.w H062+$57C
L062_000009AA:
; H062+$000009AA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000009AE:
; H062+$000009AE: 3f3c0065  move.w #$65, -(a7)
        move.w #$65, -(a7)
L062_000009B2:
; H062+$000009B2: 6100fbc8  bsr.w $57c
        bsr.w H062+$57C
L062_000009B6:
; H062+$000009B6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000009BA:
; H062+$000009BA: 3f3c0070  move.w #$70, -(a7)
        move.w #$70, -(a7)
L062_000009BE:
; H062+$000009BE: 6100fbbc  bsr.w $57c
        bsr.w H062+$57C
L062_000009C2:
; H062+$000009C2: 4e75  rts 
        rts 
L062_000009C4:
; H062+$000009C4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_000009C8:
; H062+$000009C8: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L062_000009CA:
; H062+$000009CA: 6100fda6  bsr.w $772
        bsr.w H062+$772
L062_000009CE:
; H062+$000009CE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000009D2:
; H062+$000009D2: 3f3c0047  move.w #$47, -(a7)
        move.w #$47, -(a7)
L062_000009D6:
; H062+$000009D6: 6100fba4  bsr.w $57c
        bsr.w H062+$57C
L062_000009DA:
; H062+$000009DA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000009DE:
; H062+$000009DE: 3f3c003b  move.w #$3b, -(a7)
        move.w #$3b, -(a7)
L062_000009E2:
; H062+$000009E2: 6100fb98  bsr.w $57c
        bsr.w H062+$57C
L062_000009E6:
; H062+$000009E6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000009EA:
; H062+$000009EA: 3f3c003d  move.w #$3d, -(a7)
        move.w #$3d, -(a7)
L062_000009EE:
; H062+$000009EE: 6100fb8c  bsr.w $57c
        bsr.w H062+$57C
L062_000009F2:
; H062+$000009F2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000009F6:
; H062+$000009F6: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_000009FA:
; H062+$000009FA: 6100fb80  bsr.w $57c
        bsr.w H062+$57C
L062_000009FE:
; H062+$000009FE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A02:
; H062+$00000A02: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L062_00000A06:
; H062+$00000A06: 6100fb74  bsr.w $57c
        bsr.w H062+$57C
L062_00000A0A:
; H062+$00000A0A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A0E:
; H062+$00000A0E: 3f3c0066  move.w #$66, -(a7)
        move.w #$66, -(a7)
L062_00000A12:
; H062+$00000A12: 6100fb68  bsr.w $57c
        bsr.w H062+$57C
L062_00000A16:
; H062+$00000A16: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A1A:
; H062+$00000A1A: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L062_00000A1E:
; H062+$00000A1E: 6100fb5c  bsr.w $57c
        bsr.w H062+$57C
L062_00000A22:
; H062+$00000A22: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A26:
; H062+$00000A26: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L062_00000A2A:
; H062+$00000A2A: 6100fb50  bsr.w $57c
        bsr.w H062+$57C
L062_00000A2E:
; H062+$00000A2E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A32:
; H062+$00000A32: 3f3c0062  move.w #$62, -(a7)
        move.w #$62, -(a7)
L062_00000A36:
; H062+$00000A36: 6100fb44  bsr.w $57c
        bsr.w H062+$57C
L062_00000A3A:
; H062+$00000A3A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A3E:
; H062+$00000A3E: 3f3c0049  move.w #$49, -(a7)
        move.w #$49, -(a7)
L062_00000A42:
; H062+$00000A42: 6100fb38  bsr.w $57c
        bsr.w H062+$57C
L062_00000A46:
; H062+$00000A46: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A4A:
; H062+$00000A4A: 3f3c003f  move.w #$3f, -(a7)
        move.w #$3f, -(a7)
L062_00000A4E:
; H062+$00000A4E: 6100fb2c  bsr.w $57c
        bsr.w H062+$57C
L062_00000A52:
; H062+$00000A52: 4e75  rts 
        rts 
L062_00000A54:
; H062+$00000A54: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A58:
; H062+$00000A58: 3f3c0033  move.w #$33, -(a7)
        move.w #$33, -(a7)
L062_00000A5C:
; H062+$00000A5C: 6100fb1e  bsr.w $57c
        bsr.w H062+$57C
L062_00000A60:
; H062+$00000A60: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A64:
; H062+$00000A64: 3f3c0034  move.w #$34, -(a7)
        move.w #$34, -(a7)
L062_00000A68:
; H062+$00000A68: 6100fb12  bsr.w $57c
        bsr.w H062+$57C
L062_00000A6C:
; H062+$00000A6C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A70:
; H062+$00000A70: 3f3c0035  move.w #$35, -(a7)
        move.w #$35, -(a7)
L062_00000A74:
; H062+$00000A74: 6100fb06  bsr.w $57c
        bsr.w H062+$57C
L062_00000A78:
; H062+$00000A78: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A7C:
; H062+$00000A7C: 3f3c001f  move.w #$1f, -(a7)
        move.w #$1f, -(a7)
L062_00000A80:
; H062+$00000A80: 6100fafa  bsr.w $57c
        bsr.w H062+$57C
L062_00000A84:
; H062+$00000A84: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A88:
; H062+$00000A88: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L062_00000A8C:
; H062+$00000A8C: 6100faee  bsr.w $57c
        bsr.w H062+$57C
L062_00000A90:
; H062+$00000A90: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000A94:
; H062+$00000A94: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L062_00000A98:
; H062+$00000A98: 6100fae2  bsr.w $57c
        bsr.w H062+$57C
L062_00000A9C:
; H062+$00000A9C: 4e75  rts 
        rts 
L062_00000A9E:
; H062+$00000A9E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000AA2:
; H062+$00000AA2: 3f3c0052  move.w #$52, -(a7)
        move.w #$52, -(a7)
L062_00000AA6:
; H062+$00000AA6: 6100fad4  bsr.w $57c
        bsr.w H062+$57C
L062_00000AAA:
; H062+$00000AAA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000AAE:
; H062+$00000AAE: 3f3c0059  move.w #$59, -(a7)
        move.w #$59, -(a7)
L062_00000AB2:
; H062+$00000AB2: 6100fac8  bsr.w $57c
        bsr.w H062+$57C
L062_00000AB6:
; H062+$00000AB6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000ABA:
; H062+$00000ABA: 3f3c0038  move.w #$38, -(a7)
        move.w #$38, -(a7)
L062_00000ABE:
; H062+$00000ABE: 6100fabc  bsr.w $57c
        bsr.w H062+$57C
L062_00000AC2:
; H062+$00000AC2: 4e75  rts 
        rts 
L062_00000AC4:
; H062+$00000AC4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00000AC8:
; H062+$00000AC8: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L062_00000ACA:
; H062+$00000ACA: 6100fca6  bsr.w $772
        bsr.w H062+$772
L062_00000ACE:
; H062+$00000ACE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000AD2:
; H062+$00000AD2: 3f3c0047  move.w #$47, -(a7)
        move.w #$47, -(a7)
L062_00000AD6:
; H062+$00000AD6: 6100faa4  bsr.w $57c
        bsr.w H062+$57C
L062_00000ADA:
; H062+$00000ADA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000ADE:
; H062+$00000ADE: 3f3c0074  move.w #$74, -(a7)
        move.w #$74, -(a7)
L062_00000AE2:
; H062+$00000AE2: 6100fa98  bsr.w $57c
        bsr.w H062+$57C
L062_00000AE6:
; H062+$00000AE6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000AEA:
; H062+$00000AEA: 3f3c005c  move.w #$5c, -(a7)
        move.w #$5c, -(a7)
L062_00000AEE:
; H062+$00000AEE: 6100fa8c  bsr.w $57c
        bsr.w H062+$57C
L062_00000AF2:
; H062+$00000AF2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000AF6:
; H062+$00000AF6: 3f3c003b  move.w #$3b, -(a7)
        move.w #$3b, -(a7)
L062_00000AFA:
; H062+$00000AFA: 6100fa80  bsr.w $57c
        bsr.w H062+$57C
L062_00000AFE:
; H062+$00000AFE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B02:
; H062+$00000B02: 3f3c005f  move.w #$5f, -(a7)
        move.w #$5f, -(a7)
L062_00000B06:
; H062+$00000B06: 6100fa74  bsr.w $57c
        bsr.w H062+$57C
L062_00000B0A:
; H062+$00000B0A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B0E:
; H062+$00000B0E: 3f3c0060  move.w #$60, -(a7)
        move.w #$60, -(a7)
L062_00000B12:
; H062+$00000B12: 6100fa68  bsr.w $57c
        bsr.w H062+$57C
L062_00000B16:
; H062+$00000B16: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B1A:
; H062+$00000B1A: 3f3c0061  move.w #$61, -(a7)
        move.w #$61, -(a7)
L062_00000B1E:
; H062+$00000B1E: 6100fa5c  bsr.w $57c
        bsr.w H062+$57C
L062_00000B22:
; H062+$00000B22: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B26:
; H062+$00000B26: 3f3c0062  move.w #$62, -(a7)
        move.w #$62, -(a7)
L062_00000B2A:
; H062+$00000B2A: 6100fa50  bsr.w $57c
        bsr.w H062+$57C
L062_00000B2E:
; H062+$00000B2E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B32:
; H062+$00000B32: 3f3c0063  move.w #$63, -(a7)
        move.w #$63, -(a7)
L062_00000B36:
; H062+$00000B36: 6100fa44  bsr.w $57c
        bsr.w H062+$57C
L062_00000B3A:
; H062+$00000B3A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B3E:
; H062+$00000B3E: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L062_00000B42:
; H062+$00000B42: 6100fa38  bsr.w $57c
        bsr.w H062+$57C
L062_00000B46:
; H062+$00000B46: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B4A:
; H062+$00000B4A: 3f3c003f  move.w #$3f, -(a7)
        move.w #$3f, -(a7)
L062_00000B4E:
; H062+$00000B4E: 6100fa2c  bsr.w $57c
        bsr.w H062+$57C
L062_00000B52:
; H062+$00000B52: 4e75  rts 
        rts 
L062_00000B54:
; H062+$00000B54: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B58:
; H062+$00000B58: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L062_00000B5C:
; H062+$00000B5C: 6100fa1e  bsr.w $57c
        bsr.w H062+$57C
L062_00000B60:
; H062+$00000B60: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B64:
; H062+$00000B64: 3f3c0076  move.w #$76, -(a7)
        move.w #$76, -(a7)
L062_00000B68:
; H062+$00000B68: 6100fa12  bsr.w $57c
        bsr.w H062+$57C
L062_00000B6C:
; H062+$00000B6C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B70:
; H062+$00000B70: 3f3c0077  move.w #$77, -(a7)
        move.w #$77, -(a7)
L062_00000B74:
; H062+$00000B74: 6100fa06  bsr.w $57c
        bsr.w H062+$57C
L062_00000B78:
; H062+$00000B78: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B7C:
; H062+$00000B7C: 3f3c0039  move.w #$39, -(a7)
        move.w #$39, -(a7)
L062_00000B80:
; H062+$00000B80: 6100f9fa  bsr.w $57c
        bsr.w H062+$57C
L062_00000B84:
; H062+$00000B84: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B88:
; H062+$00000B88: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_00000B8C:
; H062+$00000B8C: 6100f9ee  bsr.w $57c
        bsr.w H062+$57C
L062_00000B90:
; H062+$00000B90: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000B94:
; H062+$00000B94: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L062_00000B98:
; H062+$00000B98: 6100f9e2  bsr.w $57c
        bsr.w H062+$57C
L062_00000B9C:
; H062+$00000B9C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BA0:
; H062+$00000BA0: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L062_00000BA4:
; H062+$00000BA4: 6100f9d6  bsr.w $57c
        bsr.w H062+$57C
L062_00000BA8:
; H062+$00000BA8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BAC:
; H062+$00000BAC: 3f3c0024  move.w #$24, -(a7)
        move.w #$24, -(a7)
L062_00000BB0:
; H062+$00000BB0: 6100f9ca  bsr.w $57c
        bsr.w H062+$57C
L062_00000BB4:
; H062+$00000BB4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BB8:
; H062+$00000BB8: 3f3c0031  move.w #$31, -(a7)
        move.w #$31, -(a7)
L062_00000BBC:
; H062+$00000BBC: 6100f9be  bsr.w $57c
        bsr.w H062+$57C
L062_00000BC0:
; H062+$00000BC0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BC4:
; H062+$00000BC4: 3f3c001a  move.w #$1a, -(a7)
        move.w #$1a, -(a7)
L062_00000BC8:
; H062+$00000BC8: 6100f9b2  bsr.w $57c
        bsr.w H062+$57C
L062_00000BCC:
; H062+$00000BCC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BD0:
; H062+$00000BD0: 3f3c004b  move.w #$4b, -(a7)
        move.w #$4b, -(a7)
L062_00000BD4:
; H062+$00000BD4: 6100f9a6  bsr.w $57c
        bsr.w H062+$57C
L062_00000BD8:
; H062+$00000BD8: 4e75  rts 
        rts 
L062_00000BDA:
; H062+$00000BDA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BDE:
; H062+$00000BDE: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L062_00000BE2:
; H062+$00000BE2: 6100f998  bsr.w $57c
        bsr.w H062+$57C
L062_00000BE6:
; H062+$00000BE6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BEA:
; H062+$00000BEA: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L062_00000BEE:
; H062+$00000BEE: 6100f98c  bsr.w $57c
        bsr.w H062+$57C
L062_00000BF2:
; H062+$00000BF2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000BF6:
; H062+$00000BF6: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L062_00000BFA:
; H062+$00000BFA: 6100f980  bsr.w $57c
        bsr.w H062+$57C
L062_00000BFE:
; H062+$00000BFE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C02:
; H062+$00000C02: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L062_00000C06:
; H062+$00000C06: 6100f974  bsr.w $57c
        bsr.w H062+$57C
L062_00000C0A:
; H062+$00000C0A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C0E:
; H062+$00000C0E: 3f3c002d  move.w #$2d, -(a7)
        move.w #$2d, -(a7)
L062_00000C12:
; H062+$00000C12: 6100f968  bsr.w $57c
        bsr.w H062+$57C
L062_00000C16:
; H062+$00000C16: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C1A:
; H062+$00000C1A: 3f3c002e  move.w #$2e, -(a7)
        move.w #$2e, -(a7)
L062_00000C1E:
; H062+$00000C1E: 6100f95c  bsr.w $57c
        bsr.w H062+$57C
L062_00000C22:
; H062+$00000C22: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C26:
; H062+$00000C26: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L062_00000C2A:
; H062+$00000C2A: 6100f950  bsr.w $57c
        bsr.w H062+$57C
L062_00000C2E:
; H062+$00000C2E: 4e75  rts 
        rts 
L062_00000C30:
; H062+$00000C30: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C34:
; H062+$00000C34: 3f3c005e  move.w #$5e, -(a7)
        move.w #$5e, -(a7)
L062_00000C38:
; H062+$00000C38: 6100f942  bsr.w $57c
        bsr.w H062+$57C
L062_00000C3C:
; H062+$00000C3C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C40:
; H062+$00000C40: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L062_00000C44:
; H062+$00000C44: 6100f936  bsr.w $57c
        bsr.w H062+$57C
L062_00000C48:
; H062+$00000C48: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C4C:
; H062+$00000C4C: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L062_00000C50:
; H062+$00000C50: 6100f92a  bsr.w $57c
        bsr.w H062+$57C
L062_00000C54:
; H062+$00000C54: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C58:
; H062+$00000C58: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_00000C5C:
; H062+$00000C5C: 6100f91e  bsr.w $57c
        bsr.w H062+$57C
L062_00000C60:
; H062+$00000C60: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C64:
; H062+$00000C64: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L062_00000C68:
; H062+$00000C68: 6100f912  bsr.w $57c
        bsr.w H062+$57C
L062_00000C6C:
; H062+$00000C6C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C70:
; H062+$00000C70: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L062_00000C74:
; H062+$00000C74: 6100f906  bsr.w $57c
        bsr.w H062+$57C
L062_00000C78:
; H062+$00000C78: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C7C:
; H062+$00000C7C: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L062_00000C80:
; H062+$00000C80: 6100f8fa  bsr.w $57c
        bsr.w H062+$57C
L062_00000C84:
; H062+$00000C84: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C88:
; H062+$00000C88: 3f3c0024  move.w #$24, -(a7)
        move.w #$24, -(a7)
L062_00000C8C:
; H062+$00000C8C: 6100f8ee  bsr.w $57c
        bsr.w H062+$57C
L062_00000C90:
; H062+$00000C90: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000C94:
; H062+$00000C94: 3f3c002d  move.w #$2d, -(a7)
        move.w #$2d, -(a7)
L062_00000C98:
; H062+$00000C98: 6100f8e2  bsr.w $57c
        bsr.w H062+$57C
L062_00000C9C:
; H062+$00000C9C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CA0:
; H062+$00000CA0: 3f3c002e  move.w #$2e, -(a7)
        move.w #$2e, -(a7)
L062_00000CA4:
; H062+$00000CA4: 6100f8d6  bsr.w $57c
        bsr.w H062+$57C
L062_00000CA8:
; H062+$00000CA8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CAC:
; H062+$00000CAC: 3f3c0031  move.w #$31, -(a7)
        move.w #$31, -(a7)
L062_00000CB0:
; H062+$00000CB0: 6100f8ca  bsr.w $57c
        bsr.w H062+$57C
L062_00000CB4:
; H062+$00000CB4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CB8:
; H062+$00000CB8: 3f3c003d  move.w #$3d, -(a7)
        move.w #$3d, -(a7)
L062_00000CBC:
; H062+$00000CBC: 6100f8be  bsr.w $57c
        bsr.w H062+$57C
L062_00000CC0:
; H062+$00000CC0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CC4:
; H062+$00000CC4: 3f3c0063  move.w #$63, -(a7)
        move.w #$63, -(a7)
L062_00000CC8:
; H062+$00000CC8: 6100f8b2  bsr.w $57c
        bsr.w H062+$57C
L062_00000CCC:
; H062+$00000CCC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CD0:
; H062+$00000CD0: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L062_00000CD4:
; H062+$00000CD4: 6100f8a6  bsr.w $57c
        bsr.w H062+$57C
L062_00000CD8:
; H062+$00000CD8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CDC:
; H062+$00000CDC: 3f3c0036  move.w #$36, -(a7)
        move.w #$36, -(a7)
L062_00000CE0:
; H062+$00000CE0: 6100f89a  bsr.w $57c
        bsr.w H062+$57C
L062_00000CE4:
; H062+$00000CE4: 4e75  rts 
        rts 
L062_00000CE6:
; H062+$00000CE6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CEA:
; H062+$00000CEA: 3f3c0044  move.w #$44, -(a7)
        move.w #$44, -(a7)
L062_00000CEE:
; H062+$00000CEE: 6100f88c  bsr.w $57c
        bsr.w H062+$57C
L062_00000CF2:
; H062+$00000CF2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000CF6:
; H062+$00000CF6: 3f3c0043  move.w #$43, -(a7)
        move.w #$43, -(a7)
L062_00000CFA:
; H062+$00000CFA: 6100f880  bsr.w $57c
        bsr.w H062+$57C
L062_00000CFE:
; H062+$00000CFE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D02:
; H062+$00000D02: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L062_00000D06:
; H062+$00000D06: 6100f874  bsr.w $57c
        bsr.w H062+$57C
L062_00000D0A:
; H062+$00000D0A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D0E:
; H062+$00000D0E: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
L062_00000D12:
; H062+$00000D12: 6100f868  bsr.w $57c
        bsr.w H062+$57C
L062_00000D16:
; H062+$00000D16: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D1A:
; H062+$00000D1A: 3f3c0046  move.w #$46, -(a7)
        move.w #$46, -(a7)
L062_00000D1E:
; H062+$00000D1E: 6100f85c  bsr.w $57c
        bsr.w H062+$57C
L062_00000D22:
; H062+$00000D22: 4e75  rts 
        rts 
L062_00000D24:
; H062+$00000D24: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D28:
; H062+$00000D28: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L062_00000D2C:
; H062+$00000D2C: 6100f84e  bsr.w $57c
        bsr.w H062+$57C
L062_00000D30:
; H062+$00000D30: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D34:
; H062+$00000D34: 3f3c0055  move.w #$55, -(a7)
        move.w #$55, -(a7)
L062_00000D38:
; H062+$00000D38: 6100f842  bsr.w $57c
        bsr.w H062+$57C
L062_00000D3C:
; H062+$00000D3C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D40:
; H062+$00000D40: 3f3c0054  move.w #$54, -(a7)
        move.w #$54, -(a7)
L062_00000D44:
; H062+$00000D44: 6100f836  bsr.w $57c
        bsr.w H062+$57C
L062_00000D48:
; H062+$00000D48: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D4C:
; H062+$00000D4C: 3f3c0053  move.w #$53, -(a7)
        move.w #$53, -(a7)
L062_00000D50:
; H062+$00000D50: 6100f82a  bsr.w $57c
        bsr.w H062+$57C
L062_00000D54:
; H062+$00000D54: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D58:
; H062+$00000D58: 3f3c004e  move.w #$4e, -(a7)
        move.w #$4e, -(a7)
L062_00000D5C:
; H062+$00000D5C: 6100f81e  bsr.w $57c
        bsr.w H062+$57C
L062_00000D60:
; H062+$00000D60: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D64:
; H062+$00000D64: 3f3c004a  move.w #$4a, -(a7)
        move.w #$4a, -(a7)
L062_00000D68:
; H062+$00000D68: 6100f812  bsr.w $57c
        bsr.w H062+$57C
L062_00000D6C:
; H062+$00000D6C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D70:
; H062+$00000D70: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L062_00000D74:
; H062+$00000D74: 6100f806  bsr.w $57c
        bsr.w H062+$57C
L062_00000D78:
; H062+$00000D78: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D7C:
; H062+$00000D7C: 3f3c005a  move.w #$5a, -(a7)
        move.w #$5a, -(a7)
L062_00000D80:
; H062+$00000D80: 6100f7fa  bsr.w $57c
        bsr.w H062+$57C
L062_00000D84:
; H062+$00000D84: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D88:
; H062+$00000D88: 3f3c0068  move.w #$68, -(a7)
        move.w #$68, -(a7)
L062_00000D8C:
; H062+$00000D8C: 6100f7ee  bsr.w $57c
        bsr.w H062+$57C
L062_00000D90:
; H062+$00000D90: 4e75  rts 
        rts 
L062_00000D92:
; H062+$00000D92: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000D96:
; H062+$00000D96: 3f3c004f  move.w #$4f, -(a7)
        move.w #$4f, -(a7)
L062_00000D9A:
; H062+$00000D9A: 6100f7e0  bsr.w $57c
        bsr.w H062+$57C
L062_00000D9E:
; H062+$00000D9E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DA2:
; H062+$00000DA2: 3f3c004c  move.w #$4c, -(a7)
        move.w #$4c, -(a7)
L062_00000DA6:
; H062+$00000DA6: 6100f7d4  bsr.w $57c
        bsr.w H062+$57C
L062_00000DAA:
; H062+$00000DAA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DAE:
; H062+$00000DAE: 3f3c0048  move.w #$48, -(a7)
        move.w #$48, -(a7)
L062_00000DB2:
; H062+$00000DB2: 6100f7c8  bsr.w $57c
        bsr.w H062+$57C
L062_00000DB6:
; H062+$00000DB6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DBA:
; H062+$00000DBA: 3f3c0042  move.w #$42, -(a7)
        move.w #$42, -(a7)
L062_00000DBE:
; H062+$00000DBE: 6100f7bc  bsr.w $57c
        bsr.w H062+$57C
L062_00000DC2:
; H062+$00000DC2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DC6:
; H062+$00000DC6: 3f3c0030  move.w #$30, -(a7)
        move.w #$30, -(a7)
L062_00000DCA:
; H062+$00000DCA: 6100f7b0  bsr.w $57c
        bsr.w H062+$57C
L062_00000DCE:
; H062+$00000DCE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DD2:
; H062+$00000DD2: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
L062_00000DD6:
; H062+$00000DD6: 6100f7a4  bsr.w $57c
        bsr.w H062+$57C
L062_00000DDA:
; H062+$00000DDA: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DDE:
; H062+$00000DDE: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L062_00000DE2:
; H062+$00000DE2: 6100f798  bsr.w $57c
        bsr.w H062+$57C
L062_00000DE6:
; H062+$00000DE6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DEA:
; H062+$00000DEA: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L062_00000DEE:
; H062+$00000DEE: 6100f78c  bsr.w $57c
        bsr.w H062+$57C
L062_00000DF2:
; H062+$00000DF2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000DF6:
; H062+$00000DF6: 3f3c004d  move.w #$4d, -(a7)
        move.w #$4d, -(a7)
L062_00000DFA:
; H062+$00000DFA: 6100f780  bsr.w $57c
        bsr.w H062+$57C
L062_00000DFE:
; H062+$00000DFE: 4e75  rts 
        rts 
L062_00000E00:
; H062+$00000E00: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E04:
; H062+$00000E04: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
L062_00000E08:
; H062+$00000E08: 6100f772  bsr.w $57c
        bsr.w H062+$57C
L062_00000E0C:
; H062+$00000E0C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E10:
; H062+$00000E10: 3f3c0025  move.w #$25, -(a7)
        move.w #$25, -(a7)
L062_00000E14:
; H062+$00000E14: 6100f766  bsr.w $57c
        bsr.w H062+$57C
L062_00000E18:
; H062+$00000E18: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E1C:
; H062+$00000E1C: 3f3c002f  move.w #$2f, -(a7)
        move.w #$2f, -(a7)
L062_00000E20:
; H062+$00000E20: 6100f75a  bsr.w $57c
        bsr.w H062+$57C
L062_00000E24:
; H062+$00000E24: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E28:
; H062+$00000E28: 3f3c0059  move.w #$59, -(a7)
        move.w #$59, -(a7)
L062_00000E2C:
; H062+$00000E2C: 6100f74e  bsr.w $57c
        bsr.w H062+$57C
L062_00000E30:
; H062+$00000E30: 4e75  rts 
        rts 
L062_00000E32:
; H062+$00000E32: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E36:
; H062+$00000E36: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_00000E3A:
; H062+$00000E3A: 6100f740  bsr.w $57c
        bsr.w H062+$57C
L062_00000E3E:
; H062+$00000E3E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E42:
; H062+$00000E42: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L062_00000E46:
; H062+$00000E46: 6100f734  bsr.w $57c
        bsr.w H062+$57C
L062_00000E4A:
; H062+$00000E4A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E4E:
; H062+$00000E4E: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L062_00000E52:
; H062+$00000E52: 6100f728  bsr.w $57c
        bsr.w H062+$57C
L062_00000E56:
; H062+$00000E56: 4e75  rts 
        rts 
L062_00000E58:
; H062+$00000E58: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E5C:
; H062+$00000E5C: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L062_00000E60:
; H062+$00000E60: 6100f71a  bsr.w $57c
        bsr.w H062+$57C
L062_00000E64:
; H062+$00000E64: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E68:
; H062+$00000E68: 3f3c002a  move.w #$2a, -(a7)
        move.w #$2a, -(a7)
L062_00000E6C:
; H062+$00000E6C: 6100f70e  bsr.w $57c
        bsr.w H062+$57C
L062_00000E70:
; H062+$00000E70: 4e75  rts 
        rts 
L062_00000E72:
; H062+$00000E72: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E76:
; H062+$00000E76: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
L062_00000E7A:
; H062+$00000E7A: 6100f700  bsr.w $57c
        bsr.w H062+$57C
L062_00000E7E:
; H062+$00000E7E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E82:
; H062+$00000E82: 3f3c0038  move.w #$38, -(a7)
        move.w #$38, -(a7)
L062_00000E86:
; H062+$00000E86: 6100f6f4  bsr.w $57c
        bsr.w H062+$57C
L062_00000E8A:
; H062+$00000E8A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E8E:
; H062+$00000E8E: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L062_00000E92:
; H062+$00000E92: 6100f6e8  bsr.w $57c
        bsr.w H062+$57C
L062_00000E96:
; H062+$00000E96: 4e75  rts 
        rts 
L062_00000E98:
; H062+$00000E98: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000E9C:
; H062+$00000E9C: 3f3c0032  move.w #$32, -(a7)
        move.w #$32, -(a7)
L062_00000EA0:
; H062+$00000EA0: 6100f6da  bsr.w $57c
        bsr.w H062+$57C
L062_00000EA4:
; H062+$00000EA4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000EA8:
; H062+$00000EA8: 3f3c0036  move.w #$36, -(a7)
        move.w #$36, -(a7)
L062_00000EAC:
; H062+$00000EAC: 6100f6ce  bsr.w $57c
        bsr.w H062+$57C
L062_00000EB0:
; H062+$00000EB0: 4e75  rts 
        rts 
L062_00000EB2:
; H062+$00000EB2: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000EB6:
; H062+$00000EB6: 3f3c0023  move.w #$23, -(a7)
        move.w #$23, -(a7)
L062_00000EBA:
; H062+$00000EBA: 6100f6c0  bsr.w $57c
        bsr.w H062+$57C
L062_00000EBE:
; H062+$00000EBE: 4e75  rts 
        rts 
L062_00000EC0:
; H062+$00000EC0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_00000EC4:
; H062+$00000EC4: 3f3c0052  move.w #$52, -(a7)
        move.w #$52, -(a7)
L062_00000EC8:
; H062+$00000EC8: 6100f6b2  bsr.w $57c
        bsr.w H062+$57C
L062_00000ECC:
; H062+$00000ECC: 4e75  rts 
        rts 
L062_00000ECE:
; H062+$00000ECE: 4e75  rts 
        rts 
; Preserved bytes H062+$00000ED0..$00000F04; code/data not fully classified.
        dc.w $FFFC,$F97E,$F980,$F99A,$F9F0,$FA3A,$FA90,$FAF2
        dc.w $FB82,$FBCC,$FBF2,$FC82,$FD08,$FD5E,$FE14,$FE52
        dc.w $FEC0,$FF2E,$FF60,$FF86,$FFA0,$FFC6,$FFE0,$FFFC
        dc.w $FFFC,$FFEE
L062_00000F04:
; H062+$00000F04: 47faffcc  lea.l $ed2(pc), a3
        lea.l H062+$ED2(pc), a3
L062_00000F08:
; H062+$00000F08: 0c420018  cmpi.w #$18, d2
        cmpi.w #$18, d2
L062_00000F0C:
; H062+$00000F0C: 6302  bls.b $f10
        bls.b H062+$F10
L062_00000F0E:
; H062+$00000F0E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_00000F10:
; H062+$00000F10: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00000F12:
; H062+$00000F12: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$0ED2; indici 0..24, default -1.
L062_00000F16:
; H062+$00000F16: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_00000F1A:
; H062+$00000F1A: 4e5d  unlk a5
        unlk a5
L062_00000F1C:
; H062+$00000F1C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00000F1E:
; H062+$00000F1E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00000F20:
; H062+$00000F20: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L062_00000F22:
; H062+$00000F22: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00000F24 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; opera su H005+$3364 (testa della lista del party).
;   - Usa lo stato globale: H005+$3364 (testa della lista del party).
; Chiamanti diretti: H062+$111C, H062+$11CA
; --------------------------------------------------------------------------
L062_00000F24:
; H062+$00000F24: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00000F26:
; H062+$00000F26: 287af1da  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00000F2A:
; H062+$00000F2A: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L062_00000F2E:
; H062+$00000F2E: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L062_00000F32:
; H062+$00000F32: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_00000F34:
; H062+$00000F34: 08020000  btst.b #$0, d2
        btst #$0, d2
L062_00000F38:
; H062+$00000F38: 6702  beq.b $f3c
        beq.b H062+$F3C
L062_00000F3A:
; H062+$00000F3A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_00000F3C:
; H062+$00000F3C: 9ec2  suba.w d2, a7
        suba.w d2, a7
L062_00000F3E:
; H062+$00000F3E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00000F42:
; H062+$00000F42: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L062_00000F46:
; H062+$00000F46: 244f  movea.l a7, a2
        movea.l a7, a2
L062_00000F48:
; H062+$00000F48: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00000F4A:
; H062+$00000F4A: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_00000F4C:
; H062+$00000F4C: 51cafffc  dbra d2, $f4a
        dbra d2, H062+$F4A
L062_00000F50:
; H062+$00000F50: 2b6d0014fffc  move.l $14(a5), -$4(a5)
        move.l $14(a5), -$4(a5)
L062_00000F56:
; H062+$00000F56: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
L062_00000F5A:
; H062+$00000F5A: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L062_00000F5E:
; H062+$00000F5E: 670000ac  beq.w $100c
        beq.w H062+$100C
L062_00000F62:
; H062+$00000F62: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L062_00000F66:
; H062+$00000F66: 660000a4  bne.w $100c
        bne.w H062+$100C
L062_00000F6A:
; H062+$00000F6A: 3b7c0001fff8  move.w #$1, -$8(a5)
        move.w #$1, -$8(a5)
L062_00000F70:
; H062+$00000F70: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L062_00000F74:
; H062+$00000F74: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L062_00000F78:
; H062+$00000F78: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L062_00000F7A:
; H062+$00000F7A: 62000078  bhi.w $ff4
        bhi.w H062+$FF4
L062_00000F7E:
; H062+$00000F7E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L062_00000F82:
; H062+$00000F82: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00000F84:
; H062+$00000F84: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00000F88:
; H062+$00000F88: 47eb0012  lea.l $12(a3), a3
        lea.l $12(a3), a3
L062_00000F8C:
; H062+$00000F8C: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L062_00000F90:
; H062+$00000F90: 6700005c  beq.w $fee
        beq.w H062+$FEE
L062_00000F94:
; H062+$00000F94: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L062_00000F98:
; H062+$00000F98: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00000F9C:
; H062+$00000F9C: 7800  moveq #$0, d4
        moveq #0, d4
L062_00000F9E:
; H062+$00000F9E: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00000FA2:
; H062+$00000FA2: e344  asl.w #$1, d4
        asl.w #$1, d4
L062_00000FA4:
; H062+$00000FA4: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L062_00000FAA:
; H062+$00000FAA: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L062_00000FAE:
; H062+$00000FAE: 342a001c  move.w $1c(a2), d2
        move.w $1c(a2), d2
L062_00000FB2:
; H062+$00000FB2: d4734000  add.w (a3, d4.w), d2
        add.w (a3, d4.w), d2
L062_00000FB6:
; H062+$00000FB6: b46d001a  cmp.w $1a(a5), d2
        cmp.w $1a(a5), d2
L062_00000FBA:
; H062+$00000FBA: 66000032  bne.w $fee
        bne.w H062+$FEE
L062_00000FBE:
; H062+$00000FBE: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L062_00000FC2:
; H062+$00000FC2: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00000FC6:
; H062+$00000FC6: 7800  moveq #$0, d4
        moveq #0, d4
L062_00000FC8:
; H062+$00000FC8: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00000FCC:
; H062+$00000FCC: e344  asl.w #$1, d4
        asl.w #$1, d4
L062_00000FCE:
; H062+$00000FCE: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L062_00000FD4:
; H062+$00000FD4: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L062_00000FD8:
; H062+$00000FD8: 342a001e  move.w $1e(a2), d2
        move.w $1e(a2), d2
L062_00000FDC:
; H062+$00000FDC: d4734000  add.w (a3, d4.w), d2
        add.w (a3, d4.w), d2
L062_00000FE0:
; H062+$00000FE0: b46d0018  cmp.w $18(a5), d2
        cmp.w $18(a5), d2
L062_00000FE4:
; H062+$00000FE4: 66000008  bne.w $fee
        bne.w H062+$FEE
L062_00000FE8:
; H062+$00000FE8: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L062_00000FEE:
; H062+$00000FEE: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L062_00000FF2:
; H062+$00000FF2: 6480  bcc.b $f74
        bcc.b H062+$F74
L062_00000FF4:
; H062+$00000FF4: 548f  addq.l #$2, a7
        addq.l #$2, a7
L062_00000FF6:
; H062+$00000FF6: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L062_00000FFA:
; H062+$00000FFA: 6600000c  bne.w $1008
        bne.w H062+$1008
L062_00000FFE:
; H062+$00000FFE: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00001002:
; H062+$00001002: 2b6b0004fffc  move.l $4(a3), -$4(a5)
        move.l $4(a3), -$4(a5)
L062_00001008:
; H062+$00001008: 6000ff50  bra.w $f5a
        bra.w H062+$F5A
L062_0000100C:
; H062+$0000100C: 4a2dfffb  tst.b -$5(a5)
        tst.b -$5(a5)
L062_00001010:
; H062+$00001010: 67000010  beq.w $1022
        beq.w H062+$1022
L062_00001014:
; H062+$00001014: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00001018:
; H062+$00001018: 2013  move.l (a3), d0
        move.l (a3), d0
L062_0000101A:
; H062+$0000101A: 60000010  bra.w $102c
        bra.w H062+$102C
; Preserved bytes H062+$0000101E..$00001022; code/data not fully classified.
        dc.w $6000,$000C
; STATO: H005+$3364 = testa della lista del party
L062_00001022:
; H062+$00001022: 203900003364  move.l $3364.l, d0
        move.l (H005+$3364).l, d0
L062_00001028:
; H062+$00001028: 60000002  bra.w $102c
        bra.w H062+$102C
L062_0000102C:
; H062+$0000102C: 4e5d  unlk a5
        unlk a5
L062_0000102E:
; H062+$0000102E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001030:
; H062+$00001030: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001032:
; H062+$00001032: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L062_00001036:
; H062+$00001036: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H062_1262 [parziale]
; Scopo: Trampolino verso H062+$1262; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H062+$1262.
; Chiamanti diretti: H085+$2BC2, H059+$1646, H059+$0C34, H097+$18B2
; --------------------------------------------------------------------------
L062_00001038:
; H062+$00001038: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000103A:
; H062+$0000103A: 287af0c6  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000103E:
; H062+$0000103E: 4e55ffec  link.w a5, #$ffec
        link.w a5, #$ffec
L062_00001042:
; H062+$00001042: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001046:
; H062+$00001046: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L062_0000104A:
; H062+$0000104A: 66000006  bne.w $1052
        bne.w H062+$1052
L062_0000104E:
; H062+$0000104E: 60000212  bra.w $1262
        bra.w H062+$1262
L062_00001052:
; H062+$00001052: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00001056:
; H062+$00001056: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L062_0000105A:
; H062+$0000105A: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
L062_0000105E:
; H062+$0000105E: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L062_00001062:
; H062+$00001062: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
L062_00001066:
; H062+$00001066: 486dfff1  pea.l -$f(a5)
        pea.l -$f(a5)
; -> H048+$113E (sub_H048_0000113E)
L062_0000106A:
; H062+$0000106A: 4eb90000113e  jsr $113e.l
        jsr (H048+$113E).l
L062_00001070:
; H062+$00001070: 4a2dfff2  tst.b -$e(a5)
        tst.b -$e(a5)
L062_00001074:
; H062+$00001074: 670001c6  beq.w $123c
        beq.w H062+$123C
L062_00001078:
; H062+$00001078: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L062_0000107C:
; H062+$0000107C: 670001be  beq.w $123c
        beq.w H062+$123C
L062_00001080:
; H062+$00001080: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00001084:
; H062+$00001084: 3f3c001f  move.w #$1f, -(a7)
        move.w #$1f, -(a7)
L062_00001088:
; H062+$00001088: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_0000108C:
; H062+$0000108C: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_00001092:
; H062+$00001092: 1400  move.b d0, d2
        move.b d0, d2
L062_00001094:
; H062+$00001094: 4a02  tst.b d2
        tst.b d2
L062_00001096:
; H062+$00001096: 660001a4  bne.w $123c
        bne.w H062+$123C
L062_0000109A:
; H062+$0000109A: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_0000109E:
; H062+$0000109E: 3f3c0063  move.w #$63, -(a7)
        move.w #$63, -(a7)
L062_000010A2:
; H062+$000010A2: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_000010A6:
; H062+$000010A6: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_000010AC:
; H062+$000010AC: 1400  move.b d0, d2
        move.b d0, d2
L062_000010AE:
; H062+$000010AE: 4a02  tst.b d2
        tst.b d2
L062_000010B0:
; H062+$000010B0: 6600018a  bne.w $123c
        bne.w H062+$123C
L062_000010B4:
; H062+$000010B4: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000010B8:
; H062+$000010B8: 3f3c003f  move.w #$3f, -(a7)
        move.w #$3f, -(a7)
L062_000010BC:
; H062+$000010BC: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_000010C0:
; H062+$000010C0: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_000010C6:
; H062+$000010C6: 1400  move.b d0, d2
        move.b d0, d2
L062_000010C8:
; H062+$000010C8: 4a02  tst.b d2
        tst.b d2
L062_000010CA:
; H062+$000010CA: 66000170  bne.w $123c
        bne.w H062+$123C
L062_000010CE:
; H062+$000010CE: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000010D2:
; H062+$000010D2: 4227  clr.b -(a7)
        clr.b -(a7)
L062_000010D4:
; H062+$000010D4: 4267  clr.w -(a7)
        clr.w -(a7)
L062_000010D6:
; H062+$000010D6: 4eb90000142c  jsr $142c.l
        jsr (H062+$142C).l
L062_000010DC:
; H062+$000010DC: 1b40fff3  move.b d0, -$d(a5)
        move.b d0, -$d(a5)
L062_000010E0:
; H062+$000010E0: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L062_000010E4:
; H062+$000010E4: 670000b0  beq.w $1196
        beq.w H062+$1196
; STATO: H005+$3368 = personaggio corrente
L062_000010E8:
; H062+$000010E8: 2b7900003368ffec  move.l $3368.l, -$14(a5)
        move.l (H005+$3368).l, -$14(a5)
L062_000010F0:
; H062+$000010F0: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L062_000010F4:
; H062+$000010F4: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L062_000010FA:
; H062+$000010FA: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_000010FC:
; H062+$000010FC: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L062_00001100:
; H062+$00001100: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L062_00001106:
; H062+$00001106: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_00001108:
; H062+$00001108: 2f3900002514  move.l $2514.l, -(a7)
        move.l (H005+$2514).l, -(a7)
L062_0000110E:
; H062+$0000110E: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L062_00001112:
; H062+$00001112: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L062_00001116:
; H062+$00001116: 487900005022  pea.l $5022.l
        pea.l (H005+$5022).l
L062_0000111C:
; H062+$0000111C: 6100fe06  bsr.w $f24
        bsr.w H062+$F24
; STATO: H005+$3368 = personaggio corrente
L062_00001120:
; H062+$00001120: 23c000003368  move.l d0, $3368.l
        move.l d0, (H005+$3368).l
L062_00001126:
; H062+$00001126: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_0000112A:
; H062+$0000112A: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L062_0000112E:
; H062+$0000112E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_00001132:
; H062+$00001132: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L062_00001136:
; H062+$00001136: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L062_0000113C:
; H062+$0000113C: 3400  move.w d0, d2
        move.w d0, d2
L062_0000113E:
; H062+$0000113E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_00001140:
; H062+$00001140: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L062_00001142:
; H062+$00001142: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L062_00001146:
; H062+$00001146: 4227  clr.b -(a7)
        clr.b -(a7)
L062_00001148:
; H062+$00001148: 4227  clr.b -(a7)
        clr.b -(a7)
L062_0000114A:
; H062+$0000114A: 1f2dfff3  move.b -$d(a5), -(a7)
        move.b -$d(a5), -(a7)
L062_0000114E:
; H062+$0000114E: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L062_00001152:
; H062+$00001152: 486c001d  pea.l $1d(a4)
        pea.l $1d(a4)
L062_00001156:
; H062+$00001156: 6100efbc  bsr.w $114
        bsr.w H062+$114
L062_0000115A:
; H062+$0000115A: 42adfff4  clr.l -$c(a5)
        clr.l -$c(a5)
L062_0000115E:
; H062+$0000115E: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00001162:
; H062+$00001162: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L062_00001166:
; H062+$00001166: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_0000116A:
; H062+$0000116A: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_00001170:
; H062+$00001170: 1400  move.b d0, d2
        move.b d0, d2
L062_00001172:
; H062+$00001172: 4a02  tst.b d2
        tst.b d2
L062_00001174:
; H062+$00001174: 67000014  beq.w $118a
        beq.w H062+$118A
L062_00001178:
; H062+$00001178: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L062_0000117C:
; H062+$0000117C: 486d000e  pea.l $e(a5)
        pea.l $e(a5)
L062_00001180:
; H062+$00001180: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L062_00001184:
; H062+$00001184: 4227  clr.b -(a7)
        clr.b -(a7)
L062_00001186:
; H062+$00001186: 6100f26a  bsr.w $3f2
        bsr.w H062+$3F2
; STATO: H005+$3368 = personaggio corrente
L062_0000118A:
; H062+$0000118A: 23edffec00003368  move.l -$14(a5), $3368.l
        move.l -$14(a5), (H005+$3368).l
L062_00001192:
; H062+$00001192: 600000a8  bra.w $123c
        bra.w H062+$123C
; STATO: H005+$3368 = personaggio corrente
L062_00001196:
; H062+$00001196: 2b7900003368ffec  move.l $3368.l, -$14(a5)
        move.l (H005+$3368).l, -$14(a5)
L062_0000119E:
; H062+$0000119E: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L062_000011A2:
; H062+$000011A2: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L062_000011A8:
; H062+$000011A8: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_000011AA:
; H062+$000011AA: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L062_000011AE:
; H062+$000011AE: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L062_000011B4:
; H062+$000011B4: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_000011B6:
; H062+$000011B6: 2f3900002514  move.l $2514.l, -(a7)
        move.l (H005+$2514).l, -(a7)
L062_000011BC:
; H062+$000011BC: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L062_000011C0:
; H062+$000011C0: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L062_000011C4:
; H062+$000011C4: 487900005022  pea.l $5022.l
        pea.l (H005+$5022).l
L062_000011CA:
; H062+$000011CA: 6100fd58  bsr.w $f24
        bsr.w H062+$F24
; STATO: H005+$3368 = personaggio corrente
L062_000011CE:
; H062+$000011CE: 23c000003368  move.l d0, $3368.l
        move.l d0, (H005+$3368).l
L062_000011D4:
; H062+$000011D4: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000011D8:
; H062+$000011D8: 3f3c001f  move.w #$1f, -(a7)
        move.w #$1f, -(a7)
L062_000011DC:
; H062+$000011DC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_000011E0:
; H062+$000011E0: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L062_000011E4:
; H062+$000011E4: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L062_000011EA:
; H062+$000011EA: 3400  move.w d0, d2
        move.w d0, d2
L062_000011EC:
; H062+$000011EC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_000011EE:
; H062+$000011EE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L062_000011F0:
; H062+$000011F0: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L062_000011F4:
; H062+$000011F4: 4227  clr.b -(a7)
        clr.b -(a7)
L062_000011F6:
; H062+$000011F6: 4227  clr.b -(a7)
        clr.b -(a7)
L062_000011F8:
; H062+$000011F8: 1f2dfff3  move.b -$d(a5), -(a7)
        move.b -$d(a5), -(a7)
L062_000011FC:
; H062+$000011FC: 3f3c001b  move.w #$1b, -(a7)
        move.w #$1b, -(a7)
L062_00001200:
; H062+$00001200: 486c002d  pea.l $2d(a4)
        pea.l $2d(a4)
L062_00001204:
; H062+$00001204: 6100ef0e  bsr.w $114
        bsr.w H062+$114
L062_00001208:
; H062+$00001208: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_0000120C:
; H062+$0000120C: 3f3c001f  move.w #$1f, -(a7)
        move.w #$1f, -(a7)
L062_00001210:
; H062+$00001210: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_00001214:
; H062+$00001214: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_0000121A:
; H062+$0000121A: 1400  move.b d0, d2
        move.b d0, d2
L062_0000121C:
; H062+$0000121C: 4a02  tst.b d2
        tst.b d2
L062_0000121E:
; H062+$0000121E: 67000014  beq.w $1234
        beq.w H062+$1234
L062_00001222:
; H062+$00001222: 3f3c001f  move.w #$1f, -(a7)
        move.w #$1f, -(a7)
L062_00001226:
; H062+$00001226: 486d000e  pea.l $e(a5)
        pea.l $e(a5)
L062_0000122A:
; H062+$0000122A: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L062_0000122E:
; H062+$0000122E: 4227  clr.b -(a7)
        clr.b -(a7)
L062_00001230:
; H062+$00001230: 6100f1c0  bsr.w $3f2
        bsr.w H062+$3F2
; STATO: H005+$3368 = personaggio corrente
L062_00001234:
; H062+$00001234: 23edffec00003368  move.l -$14(a5), $3368.l
        move.l -$14(a5), (H005+$3368).l
L062_0000123C:
; H062+$0000123C: 4a2dfff1  tst.b -$f(a5)
        tst.b -$f(a5)
L062_00001240:
; H062+$00001240: 67000020  beq.w $1262
        beq.w H062+$1262
L062_00001244:
; H062+$00001244: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00001248:
; H062+$00001248: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_0000124C:
; H062+$0000124C: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L062_00001250:
; H062+$00001250: 4eb9000015c6  jsr $15c6.l
        jsr (H062+$15C6).l
L062_00001256:
; H062+$00001256: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_00001258:
; H062+$00001258: 4227  clr.b -(a7)
        clr.b -(a7)
L062_0000125A:
; H062+$0000125A: 4227  clr.b -(a7)
        clr.b -(a7)
L062_0000125C:
; H062+$0000125C: 4eb900002188  jsr $2188.l
        jsr (H062+$2188).l
L062_00001262:
; H062+$00001262: 4e5d  unlk a5
        unlk a5
L062_00001264:
; H062+$00001264: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001266:
; H062+$00001266: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001268:
; H062+$00001268: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L062_0000126A:
; H062+$0000126A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_0000126C [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H012+$2268
; --------------------------------------------------------------------------
L062_0000126C:
; H062+$0000126C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000126E:
; H062+$0000126E: 287aee92  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00001272:
; H062+$00001272: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L062_00001276:
; H062+$00001276: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L062_0000127A:
; H062+$0000127A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_0000127E:
; H062+$0000127E: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L062_00001282:
; H062+$00001282: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L062_00001288:
; H062+$00001288: 33c000002a1a  move.w d0, $2a1a.l
        move.w d0, (H005+$2A1A).l
L062_0000128E:
; H062+$0000128E: 0c79000100002a1a  cmpi.w #$1, $2a1a.l
        cmpi.w #$1, (H005+$2A1A).l
L062_00001296:
; H062+$00001296: 6f00004c  ble.w $12e4
        ble.w H062+$12E4
L062_0000129A:
; H062+$0000129A: 0c79001400002a1a  cmpi.w #$14, $2a1a.l
        cmpi.w #$14, (H005+$2A1A).l
L062_000012A2:
; H062+$000012A2: 6600000a  bne.w $12ae
        bne.w H062+$12AE
L062_000012A6:
; H062+$000012A6: 33fc006400002a1a  move.w #$64, $2a1a.l
        move.w #$64, (H005+$2A1A).l
L062_000012AE:
; H062+$000012AE: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L062_000012B2:
; H062+$000012B2: 486d000e  pea.l $e(a5)
        pea.l $e(a5)
L062_000012B6:
; H062+$000012B6: 6100f586  bsr.w $83e
        bsr.w H062+$83E
L062_000012BA:
; H062+$000012BA: 4a7900002a1a  tst.w $2a1a.l
        tst.w (H005+$2A1A).l
L062_000012C0:
; H062+$000012C0: 6d000022  blt.w $12e4
        blt.w H062+$12E4
L062_000012C4:
; H062+$000012C4: 343900002a1a  move.w $2a1a.l, d2
        move.w (H005+$2A1A).l, d2
L062_000012CA:
; H062+$000012CA: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L062_000012CE:
; H062+$000012CE: 7800  moveq #$0, d4
        moveq #0, d4
L062_000012D0:
; H062+$000012D0: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_000012D4:
; H062+$000012D4: 182b019c  move.b $19c(a3), d4
        move.b $19c(a3), d4
L062_000012D8:
; H062+$000012D8: b444  cmp.w d4, d2
        cmp.w d4, d2
L062_000012DA:
; H062+$000012DA: 63000008  bls.w $12e4
        bls.w H062+$12E4
L062_000012DE:
; H062+$000012DE: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L062_000012E4:
; H062+$000012E4: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L062_000012E8:
; H062+$000012E8: 60000002  bra.w $12ec
        bra.w H062+$12EC
L062_000012EC:
; H062+$000012EC: 4e5d  unlk a5
        unlk a5
L062_000012EE:
; H062+$000012EE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000012F0:
; H062+$000012F0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000012F2:
; H062+$000012F2: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L062_000012F4:
; H062+$000012F4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000012F6 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H056+$0886.
;   - Richiama H056+$0886.
;   - Usa lo stato globale: H005+$3E00 (puntatore stato persistente B, 2048 byte).
; Chiamanti diretti: H085+$0934, H096+$1F3A
; --------------------------------------------------------------------------
L062_000012F6:
; H062+$000012F6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000012F8:
; H062+$000012F8: 287aee08  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_000012FC:
; H062+$000012FC: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L062_00001300:
; H062+$00001300: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L062_00001304:
; H062+$00001304: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_00001308:
; H062+$00001308: 4eb900001780  jsr $1780.l
        jsr (H062+$1780).l
L062_0000130E:
; H062+$0000130E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_00001312:
; H062+$00001312: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L062_00001316:
; H062+$00001316: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L062_0000131C:
; H062+$0000131C: 33c000002a1a  move.w d0, $2a1a.l
        move.w d0, (H005+$2A1A).l
L062_00001322:
; H062+$00001322: 0c79000100002a1a  cmpi.w #$1, $2a1a.l
        cmpi.w #$1, (H005+$2A1A).l
L062_0000132A:
; H062+$0000132A: 6f0000ec  ble.w $1418
        ble.w H062+$1418
L062_0000132E:
; H062+$0000132E: 0c79001400002a1a  cmpi.w #$14, $2a1a.l
        cmpi.w #$14, (H005+$2A1A).l
L062_00001336:
; H062+$00001336: 6600000a  bne.w $1342
        bne.w H062+$1342
L062_0000133A:
; H062+$0000133A: 33fc006400002a1a  move.w #$64, $2a1a.l
        move.w #$64, (H005+$2A1A).l
L062_00001342:
; H062+$00001342: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_00001346:
; H062+$00001346: 486d0012  pea.l $12(a5)
        pea.l $12(a5)
L062_0000134A:
; H062+$0000134A: 6100f4f2  bsr.w $83e
        bsr.w H062+$83E
L062_0000134E:
; H062+$0000134E: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L062_00001352:
; H062+$00001352: 486d000e  pea.l $e(a5)
        pea.l $e(a5)
L062_00001356:
; H062+$00001356: 6100f4e6  bsr.w $83e
        bsr.w H062+$83E
L062_0000135A:
; H062+$0000135A: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000135E:
; H062+$0000135E: 4a2b0199  tst.b $199(a3)
        tst.b $199(a3)
L062_00001362:
; H062+$00001362: 66000012  bne.w $1376
        bne.w H062+$1376
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L062_00001366:
; H062+$00001366: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L062_0000136C:
; H062+$0000136C: 3b6b06e2fffe  move.w $6e2(a3), -$2(a5)
        move.w $6e2(a3), -$2(a5)
L062_00001372:
; H062+$00001372: 6000000e  bra.w $1382
        bra.w H062+$1382
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L062_00001376:
; H062+$00001376: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L062_0000137C:
; H062+$0000137C: 3b6b06e0fffe  move.w $6e0(a3), -$2(a5)
        move.w $6e0(a3), -$2(a5)
L062_00001382:
; H062+$00001382: 243c000001f4  move.l #$1f4, d2
        move.l #$1f4, d2
L062_00001388:
; H062+$00001388: 60000028  bra.w $13b2
        bra.w H062+$13B2
L062_0000138C:
; H062+$0000138C: 546dfffe  addq.w #$2, -$2(a5)
        addq.w #$2, -$2(a5)
L062_00001390:
; H062+$00001390: 4e75  rts 
        rts 
L062_00001392:
; H062+$00001392: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L062_00001396:
; H062+$00001396: 4e75  rts 
        rts 
L062_00001398:
; H062+$00001398: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L062_0000139C:
; H062+$0000139C: 4e75  rts 
        rts 
L062_0000139E:
; H062+$0000139E: 556dfffe  subq.w #$2, -$2(a5)
        subq.w #$2, -$2(a5)
L062_000013A2:
; H062+$000013A2: 4e75  rts 
        rts 
L062_000013A4:
; H062+$000013A4: 4e75  rts 
        rts 
; Preserved bytes H062+$000013A6..$000013B2; code/data not fully classified.
        dc.w $FFFC,$FFE4,$FFEA,$FFFC,$FFF0,$FFF6
L062_000013B2:
; H062+$000013B2: 47fafff4  lea.l $13a8(pc), a3
        lea.l H062+$13A8(pc), a3
L062_000013B6:
; H062+$000013B6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_000013B8:
; H062+$000013B8: 0c420004  cmpi.w #$4, d2
        cmpi.w #$4, d2
L062_000013BC:
; H062+$000013BC: 6302  bls.b $13c0
        bls.b H062+$13C0
L062_000013BE:
; H062+$000013BE: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_000013C0:
; H062+$000013C0: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_000013C2:
; H062+$000013C2: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$13A8; indici 0..4, default -1.
L062_000013C6:
; H062+$000013C6: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_000013CA:
; H062+$000013CA: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L062_000013CE:
; H062+$000013CE: 486c0049  pea.l $49(a4)
        pea.l $49(a4)
L062_000013D2:
; H062+$000013D2: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_000013D6:
; H062+$000013D6: 1f2b019b  move.b $19b(a3), -(a7)
        move.b $19b(a3), -(a7)
L062_000013DA:
; H062+$000013DA: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_000013DE:
; H062+$000013DE: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L062_000013E0:
; H062+$000013E0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L062_000013E4:
; H062+$000013E4: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
; -> H056+$0886 (sub_H056_00000886)
L062_000013E6:
; H062+$000013E6: 4eb900000886  jsr $886.l
        jsr (H056+$886).l
L062_000013EC:
; H062+$000013EC: 4a7900002a1a  tst.w $2a1a.l
        tst.w (H005+$2A1A).l
L062_000013F2:
; H062+$000013F2: 6d000024  blt.w $1418
        blt.w H062+$1418
L062_000013F6:
; H062+$000013F6: 7400  moveq #$0, d2
        moveq #0, d2
L062_000013F8:
; H062+$000013F8: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_000013FC:
; H062+$000013FC: 142b019b  move.b $19b(a3), d2
        move.b $19b(a3), d2
L062_00001400:
; H062+$00001400: d47900002a1a  add.w $2a1a.l, d2
        add.w (H005+$2A1A).l, d2
L062_00001406:
; H062+$00001406: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L062_0000140A:
; H062+$0000140A: b46d000c  cmp.w $c(a5), d2
        cmp.w $c(a5), d2
L062_0000140E:
; H062+$0000140E: 6d000008  blt.w $1418
        blt.w H062+$1418
L062_00001412:
; H062+$00001412: 1b7c0001fffd  move.b #$1, -$3(a5)
        move.b #$1, -$3(a5)
L062_00001418:
; H062+$00001418: 102dfffd  move.b -$3(a5), d0
        move.b -$3(a5), d0
L062_0000141C:
; H062+$0000141C: 60000002  bra.w $1420
        bra.w H062+$1420
L062_00001420:
; H062+$00001420: 4e5d  unlk a5
        unlk a5
L062_00001422:
; H062+$00001422: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001424:
; H062+$00001424: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001426:
; H062+$00001426: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L062_0000142A:
; H062+$0000142A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_0000142C [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; opera su H005+$3E04 (puntatore stato persistente A, 2048 byte).
;   - Usa lo stato globale: H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H027+$1F9A, H027+$2C04, H027+$3226, H085+$202C, H085+$3866, H085+$39B0 e altri 15
; --------------------------------------------------------------------------
L062_0000142C:
; H062+$0000142C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000142E:
; H062+$0000142E: 287aecd2  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00001432:
; H062+$00001432: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L062_00001436:
; H062+$00001436: 13fc0001000024a5  move.b #$1, $24a5.l
        move.b #$1, (H005+$24A5).l
L062_0000143E:
; H062+$0000143E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_00001442:
; H062+$00001442: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L062_00001446:
; H062+$00001446: 4eb90000156c  jsr $156c.l
        jsr (H062+$156C).l
L062_0000144C:
; H062+$0000144C: 13c000002476  move.b d0, $2476.l
        move.b d0, (H005+$2476).l
L062_00001452:
; H062+$00001452: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001454:
; H062+$00001454: 143900002476  move.b $2476.l, d2
        move.b (H005+$2476).l, d2
L062_0000145A:
; H062+$0000145A: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L062_0000145E:
; H062+$0000145E: 6600000c  bne.w $146c
        bne.w H062+$146C
L062_00001462:
; H062+$00001462: 4239000024a5  clr.b $24a5.l
        clr.b (H005+$24A5).l
L062_00001468:
; H062+$00001468: 600000ee  bra.w $1558
        bra.w H062+$1558
L062_0000146C:
; H062+$0000146C: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000146E:
; H062+$0000146E: 143900002476  move.b $2476.l, d2
        move.b (H005+$2476).l, d2
L062_00001474:
; H062+$00001474: 0c420014  cmpi.w #$14, d2
        cmpi.w #$14, d2
L062_00001478:
; H062+$00001478: 6600000e  bne.w $1488
        bne.w H062+$1488
L062_0000147C:
; H062+$0000147C: 13fc0001000024a5  move.b #$1, $24a5.l
        move.b #$1, (H005+$24A5).l
L062_00001484:
; H062+$00001484: 600000d2  bra.w $1558
        bra.w H062+$1558
L062_00001488:
; H062+$00001488: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_0000148C:
; H062+$0000148C: 4a2b0103  tst.b $103(a3)
        tst.b $103(a3)
L062_00001490:
; H062+$00001490: 63000064  bls.w $14f6
        bls.w H062+$14F6
L062_00001494:
; H062+$00001494: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001496:
; H062+$00001496: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_0000149A:
; H062+$0000149A: 142b005f  move.b $5f(a3), d2
        move.b $5f(a3), d2
L062_0000149E:
; H062+$0000149E: 4a42  tst.w d2
        tst.w d2
L062_000014A0:
; H062+$000014A0: 63000054  bls.w $14f6
        bls.w H062+$14F6
L062_000014A4:
; H062+$000014A4: 7400  moveq #$0, d2
        moveq #0, d2
L062_000014A6:
; H062+$000014A6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000014AA:
; H062+$000014AA: 142b005f  move.b $5f(a3), d2
        move.b $5f(a3), d2
L062_000014AE:
; H062+$000014AE: 064201f8  addi.w #$1f8, d2
        addi.w #$1f8, d2
L062_000014B2:
; H062+$000014B2: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L062_000014B6:
; H062+$000014B6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L062_000014BA:
; H062+$000014BA: e342  asl.w #$1, d2
        asl.w #$1, d2
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L062_000014BC:
; H062+$000014BC: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L062_000014C2:
; H062+$000014C2: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L062_000014C6:
; H062+$000014C6: 60000018  bra.w $14e0
        bra.w H062+$14E0
L062_000014CA:
; H062+$000014CA: 536d000c  subq.w #$1, $c(a5)
        subq.w #$1, $c(a5)
L062_000014CE:
; H062+$000014CE: 4e75  rts 
        rts 
L062_000014D0:
; H062+$000014D0: 526d000c  addq.w #$1, $c(a5)
        addq.w #$1, $c(a5)
L062_000014D4:
; H062+$000014D4: 4e75  rts 
        rts 
L062_000014D6:
; H062+$000014D6: 4e75  rts 
        rts 
; Preserved bytes H062+$000014D8..$000014E0; code/data not fully classified.
        dc.w $FFFC,$FFF0,$FFFC,$FFF6
L062_000014E0:
; H062+$000014E0: 47fafff8  lea.l $14da(pc), a3
        lea.l H062+$14DA(pc), a3
L062_000014E4:
; H062+$000014E4: 0c440002  cmpi.w #$2, d4
        cmpi.w #$2, d4
L062_000014E8:
; H062+$000014E8: 6302  bls.b $14ec
        bls.b H062+$14EC
L062_000014EA:
; H062+$000014EA: 78ff  moveq #$ff, d4
        moveq #-1, d4
L062_000014EC:
; H062+$000014EC: e344  asl.w #$1, d4
        asl.w #$1, d4
L062_000014EE:
; H062+$000014EE: 38334000  move.w (a3, d4.w), d4
        move.w (a3, d4.w), d4
; DISPATCH: word relative a H062+$14DA; indici 0..2, default -1.
L062_000014F2:
; H062+$000014F2: 4eb34000  jsr (a3, d4.w)
        jsr (a3, d4.w)
L062_000014F6:
; H062+$000014F6: 7400  moveq #$0, d2
        moveq #0, d2
L062_000014F8:
; H062+$000014F8: 143900002476  move.b $2476.l, d2
        move.b (H005+$2476).l, d2
L062_000014FE:
; H062+$000014FE: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00001502:
; H062+$00001502: d46b018a  add.w $18a(a3), d2
        add.w $18a(a3), d2
L062_00001506:
; H062+$00001506: d46d000c  add.w $c(a5), d2
        add.w $c(a5), d2
L062_0000150A:
; H062+$0000150A: 13c200002476  move.b d2, $2476.l
        move.b d2, (H005+$2476).l
L062_00001510:
; H062+$00001510: 13ed000e00002a13  move.b $e(a5), $2a13.l
        move.b $e(a5), (H005+$2A13).l
L062_00001518:
; H062+$00001518: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L062_0000151C:
; H062+$0000151C: 486d0010  pea.l $10(a5)
        pea.l $10(a5)
L062_00001520:
; H062+$00001520: 6100f31c  bsr.w $83e
        bsr.w H062+$83E
L062_00001524:
; H062+$00001524: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001526:
; H062+$00001526: 143900002476  move.b $2476.l, d2
        move.b (H005+$2476).l, d2
L062_0000152C:
; H062+$0000152C: 7800  moveq #$0, d4
        moveq #0, d4
L062_0000152E:
; H062+$0000152E: 182d000e  move.b $e(a5), d4
        move.b $e(a5), d4
L062_00001532:
; H062+$00001532: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00001536:
; H062+$00001536: 47eb00d4  lea.l $d4(a3), a3
        lea.l $d4(a3), a3
L062_0000153A:
; H062+$0000153A: 7c00  moveq #$0, d6
        moveq #0, d6
L062_0000153C:
; H062+$0000153C: 1c334000  move.b (a3, d4.w), d6
        move.b (a3, d4.w), d6
L062_00001540:
; H062+$00001540: b446  cmp.w d6, d2
        cmp.w d6, d2
L062_00001542:
; H062+$00001542: 6500000e  bcs.w $1552
        bcs.w H062+$1552
L062_00001546:
; H062+$00001546: 13fc0001000024a5  move.b #$1, $24a5.l
        move.b #$1, (H005+$24A5).l
L062_0000154E:
; H062+$0000154E: 60000008  bra.w $1558
        bra.w H062+$1558
L062_00001552:
; H062+$00001552: 4239000024a5  clr.b $24a5.l
        clr.b (H005+$24A5).l
L062_00001558:
; H062+$00001558: 1039000024a5  move.b $24a5.l, d0
        move.b (H005+$24A5).l, d0
L062_0000155E:
; H062+$0000155E: 60000002  bra.w $1562
        bra.w H062+$1562
L062_00001562:
; H062+$00001562: 4e5d  unlk a5
        unlk a5
L062_00001564:
; H062+$00001564: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001566:
; H062+$00001566: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001568:
; H062+$00001568: 508f  addq.l #$8, a7
        addq.l #$8, a7
L062_0000156A:
; H062+$0000156A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_0000156C [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H023+$0010.
;   - Richiama H023+$0010.
; Chiamanti diretti: H027+$0A12, H027+$0E3C, H027+$1174, H027+$2420, H027+$29F4, H027+$2D0C e altri 140
; --------------------------------------------------------------------------
L062_0000156C:
; H062+$0000156C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000156E:
; H062+$0000156E: 287aeb92  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00001572:
; H062+$00001572: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L062_00001576:
; H062+$00001576: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L062_0000157A:
; H062+$0000157A: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L062_0000157E:
; H062+$0000157E: 63000034  bls.w $15b4
        bls.w H062+$15B4
L062_00001582:
; H062+$00001582: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L062_00001588:
; H062+$00001588: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L062_0000158C:
; H062+$0000158C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L062_00001590:
; H062+$00001590: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L062_00001592:
; H062+$00001592: 6200001e  bhi.w $15b2
        bhi.w H062+$15B2
L062_00001596:
; H062+$00001596: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001598:
; H062+$00001598: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_0000159C:
; H062+$0000159C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H023+$0010 (sub_H023_00000010)
L062_0000159E:
; H062+$0000159E: 4eb900000010  jsr $10.l
        jsr (H023+$10).l
L062_000015A4:
; H062+$000015A4: 2400  move.l d0, d2
        move.l d0, d2
L062_000015A6:
; H062+$000015A6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_000015A8:
; H062+$000015A8: d56dfffc  add.w d2, -$4(a5)
        add.w d2, -$4(a5)
L062_000015AC:
; H062+$000015AC: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L062_000015B0:
; H062+$000015B0: 64da  bcc.b $158c
        bcc.b H062+$158C
L062_000015B2:
; H062+$000015B2: 548f  addq.l #$2, a7
        addq.l #$2, a7
L062_000015B4:
; H062+$000015B4: 302dfffc  move.w -$4(a5), d0
        move.w -$4(a5), d0
L062_000015B8:
; H062+$000015B8: 60000002  bra.w $15bc
        bra.w H062+$15BC
L062_000015BC:
; H062+$000015BC: 4e5d  unlk a5
        unlk a5
L062_000015BE:
; H062+$000015BE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000015C0:
; H062+$000015C0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000015C2:
; H062+$000015C2: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_000015C4:
; H062+$000015C4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000015C6 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$0516, H027+$1B62, H027+$1F64, H027+$23D2, H027+$3BF8, H085+$1D5C e altri 10
; --------------------------------------------------------------------------
L062_000015C6:
; H062+$000015C6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000015C8:
; H062+$000015C8: 287aeb38  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_000015CC:
; H062+$000015CC: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_000015D0:
; H062+$000015D0: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L062_000015D4:
; H062+$000015D4: 13c200002470  move.b d2, $2470.l
        move.b d2, (H005+$2470).l
L062_000015DA:
; H062+$000015DA: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L062_000015DE:
; H062+$000015DE: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L062_000015E2:
; H062+$000015E2: 6188  bsr.b $156c
        bsr.b H062+$156C
L062_000015E4:
; H062+$000015E4: 60000002  bra.w $15e8
        bra.w H062+$15E8
L062_000015E8:
; H062+$000015E8: 4e5d  unlk a5
        unlk a5
L062_000015EA:
; H062+$000015EA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000015EC:
; H062+$000015EC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000015EE:
; H062+$000015EE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_000015F0:
; H062+$000015F0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000015F2 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H003+$0068.
;   - Richiama H003+$0068.
; Chiamanti diretti: H027+$086A, H027+$0882, H027+$089A, H027+$08B6, H027+$102E, H027+$1048 e altri 30
; --------------------------------------------------------------------------
L062_000015F2:
; H062+$000015F2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000015F4:
; H062+$000015F4: 287aeb0c  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_000015F8:
; H062+$000015F8: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L062_000015FC:
; H062+$000015FC: 740a  moveq #$a, d2
        moveq #10, d2
L062_000015FE:
; H062+$000015FE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L062_00001600:
; H062+$00001600: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L062_00001606:
; H062+$00001606: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L062_0000160C:
; H062+$0000160C: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L062_00001610:
; H062+$00001610: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00001614:
; H062+$00001614: 4aab00e8  tst.l $e8(a3)
        tst.l $e8(a3)
L062_00001618:
; H062+$00001618: 66000010  bne.w $162a
        bne.w H062+$162A
L062_0000161C:
; H062+$0000161C: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00001620:
; H062+$00001620: 276dfffc00e8  move.l -$4(a5), $e8(a3)
        move.l -$4(a5), $e8(a3)
L062_00001626:
; H062+$00001626: 6000002e  bra.w $1656
        bra.w H062+$1656
L062_0000162A:
; H062+$0000162A: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_0000162E:
; H062+$0000162E: 2b6b00e8fff8  move.l $e8(a3), -$8(a5)
        move.l $e8(a3), -$8(a5)
L062_00001634:
; H062+$00001634: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_00001638:
; H062+$00001638: 4aab0006  tst.l $6(a3)
        tst.l $6(a3)
L062_0000163C:
; H062+$0000163C: 6700000e  beq.w $164c
        beq.w H062+$164C
L062_00001640:
; H062+$00001640: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_00001644:
; H062+$00001644: 2b6b0006fff8  move.l $6(a3), -$8(a5)
        move.l $6(a3), -$8(a5)
L062_0000164A:
; H062+$0000164A: 60e8  bra.b $1634
        bra.b H062+$1634
L062_0000164C:
; H062+$0000164C: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_00001650:
; H062+$00001650: 276dfffc0006  move.l -$4(a5), $6(a3)
        move.l -$4(a5), $6(a3)
L062_00001656:
; H062+$00001656: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_0000165A:
; H062+$0000165A: 42ab0006  clr.l $6(a3)
        clr.l $6(a3)
L062_0000165E:
; H062+$0000165E: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L062_00001662:
; H062+$00001662: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00001666:
; H062+$00001666: 1682  move.b d2, (a3)
        move.b d2, (a3)
L062_00001668:
; H062+$00001668: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_0000166C:
; H062+$0000166C: 376d00100002  move.w $10(a5), $2(a3)
        move.w $10(a5), $2(a3)
L062_00001672:
; H062+$00001672: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00001676:
; H062+$00001676: 176d000c0005  move.b $c(a5), $5(a3)
        move.b $c(a5), $5(a3)
L062_0000167C:
; H062+$0000167C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L062_00001680:
; H062+$00001680: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L062_00001684:
; H062+$00001684: 17420004  move.b d2, $4(a3)
        move.b d2, $4(a3)
L062_00001688:
; H062+$00001688: 4e5d  unlk a5
        unlk a5
L062_0000168A:
; H062+$0000168A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_0000168C:
; H062+$0000168C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000168E:
; H062+$0000168E: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L062_00001692:
; H062+$00001692: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00001694 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H048+$0AA8, H048+$195E, H063+$1DC2, H048+$0588.
;   - Richiama H048+$0AA8.
;   - Richiama H048+$195E.
;   - Richiama H063+$1DC2.
;   - Richiama H048+$0588.
;   - Richiama H048+$0956.
;   - Richiama H063+$2F12.
; Chiamanti diretti: H097+$05FC, H096+$1A42, H096+$11A4
; --------------------------------------------------------------------------
L062_00001694:
; H062+$00001694: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00001696:
; H062+$00001696: 287aea6a  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000169A:
; H062+$0000169A: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L062_0000169E:
; H062+$0000169E: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L062_000016A2:
; H062+$000016A2: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_000016A4:
; H062+$000016A4: 08020000  btst.b #$0, d2
        btst #$0, d2
L062_000016A8:
; H062+$000016A8: 6702  beq.b $16ac
        beq.b H062+$16AC
L062_000016AA:
; H062+$000016AA: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_000016AC:
; H062+$000016AC: 9ec2  suba.w d2, a7
        suba.w d2, a7
L062_000016AE:
; H062+$000016AE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_000016B2:
; H062+$000016B2: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L062_000016B6:
; H062+$000016B6: 244f  movea.l a7, a2
        movea.l a7, a2
L062_000016B8:
; H062+$000016B8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_000016BA:
; H062+$000016BA: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_000016BC:
; H062+$000016BC: 51cafffc  dbra d2, $16ba
        dbra d2, H062+$16BA
L062_000016C0:
; H062+$000016C0: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000016C4:
; H062+$000016C4: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L062_000016C8:
; H062+$000016C8: 66000006  bne.w $16d0
        bne.w H062+$16D0
L062_000016CC:
; H062+$000016CC: 600000a6  bra.w $1774
        bra.w H062+$1774
L062_000016D0:
; H062+$000016D0: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$0AA8 (sub_H048_00000AA8)
L062_000016D4:
; H062+$000016D4: 4eb900000aa8  jsr $aa8.l
        jsr (H048+$AA8).l
L062_000016DA:
; H062+$000016DA: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L062_000016DE:
; H062+$000016DE: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_000016E2:
; H062+$000016E2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L062_000016E6:
; H062+$000016E6: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H048+$195E (sub_H048_0000195E)
L062_000016E8:
; H062+$000016E8: 4eb90000195e  jsr $195e.l
        jsr (H048+$195E).l
L062_000016EE:
; H062+$000016EE: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_000016F2:
; H062+$000016F2: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L062_000016F6:
; H062+$000016F6: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000016FA:
; H062+$000016FA: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_000016FE:
; H062+$000016FE: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L062_00001702:
; H062+$00001702: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L062_00001708:
; H062+$00001708: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_0000170C:
; H062+$0000170C: 422b0198  clr.b $198(a3)
        clr.b $198(a3)
L062_00001710:
; H062+$00001710: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00001714:
; H062+$00001714: 176d00120197  move.b $12(a5), $197(a3)
        move.b $12(a5), $197(a3)
L062_0000171A:
; H062+$0000171A: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_0000171E:
; H062+$0000171E: 0c2b00030197  cmpi.b #$3, $197(a3)
        cmpi.b #$3, $197(a3)
L062_00001724:
; H062+$00001724: 6700000a  beq.w $1730
        beq.w H062+$1730
L062_00001728:
; H062+$00001728: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_0000172C:
; H062+$0000172C: 422b01a8  clr.b $1a8(a3)
        clr.b $1a8(a3)
L062_00001730:
; H062+$00001730: 4267  clr.w -(a7)
        clr.w -(a7)
L062_00001732:
; H062+$00001732: 4267  clr.w -(a7)
        clr.w -(a7)
L062_00001734:
; H062+$00001734: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
; -> H048+$0588 (sub_H048_00000588)
L062_00001738:
; H062+$00001738: 4eb900000588  jsr $588.l
        jsr (H048+$588).l
L062_0000173E:
; H062+$0000173E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L062_00001742:
; H062+$00001742: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00001744:
; H062+$00001744: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L062_00001748:
; H062+$00001748: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L062_0000174E:
; H062+$0000174E: 42332805  clr.b $5(a3, d2.l)
        clr.b $5(a3, d2.l)
; -> H048+$0956 (sub_H048_00000956)
L062_00001752:
; H062+$00001752: 4eb900000956  jsr $956.l
        jsr (H048+$956).l
L062_00001758:
; H062+$00001758: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L062_0000175C:
; H062+$0000175C: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L062_00001762:
; H062+$00001762: 1400  move.b d0, d2
        move.b d0, d2
L062_00001764:
; H062+$00001764: 4a02  tst.b d2
        tst.b d2
L062_00001766:
; H062+$00001766: 6700000c  beq.w $1774
        beq.w H062+$1774
L062_0000176A:
; H062+$0000176A: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_0000176E:
; H062+$0000176E: 4eb9000017c0  jsr $17c0.l
        jsr (H062+$17C0).l
L062_00001774:
; H062+$00001774: 4e5d  unlk a5
        unlk a5
L062_00001776:
; H062+$00001776: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001778:
; H062+$00001778: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000177A:
; H062+$0000177A: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L062_0000177E:
; H062+$0000177E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00001780 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$0946.
;   - Richiama H063+$0946.
; Chiamanti diretti: H062+$1308, H096+$1CD0, H033+$16EE
; --------------------------------------------------------------------------
L062_00001780:
; H062+$00001780: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00001782:
; H062+$00001782: 287ae97e  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00001786:
; H062+$00001786: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L062_0000178A:
; H062+$0000178A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000178E:
; H062+$0000178E: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
L062_00001792:
; H062+$00001792: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_00001796:
; H062+$00001796: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_0000179C:
; H062+$0000179C: 1400  move.b d0, d2
        move.b d0, d2
L062_0000179E:
; H062+$0000179E: 4a02  tst.b d2
        tst.b d2
L062_000017A0:
; H062+$000017A0: 67000014  beq.w $17b6
        beq.w H062+$17B6
L062_000017A4:
; H062+$000017A4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_000017A8:
; H062+$000017A8: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
L062_000017AC:
; H062+$000017AC: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L062_000017B0:
; H062+$000017B0: 6100eca0  bsr.w $452
        bsr.w H062+$452
L062_000017B4:
; H062+$000017B4: 60d4  bra.b $178a
        bra.b H062+$178A
L062_000017B6:
; H062+$000017B6: 4e5d  unlk a5
        unlk a5
L062_000017B8:
; H062+$000017B8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000017BA:
; H062+$000017BA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000017BC:
; H062+$000017BC: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_000017BE:
; H062+$000017BE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000017C0 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$0946.
;   - Richiama H063+$0946.
; Chiamanti diretti: H062+$038A, H062+$24EC, H059+$0374, H096+$085E, H062+$176E
; --------------------------------------------------------------------------
L062_000017C0:
; H062+$000017C0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000017C2:
; H062+$000017C2: 287ae93e  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_000017C6:
; H062+$000017C6: 4e55ffda  link.w a5, #$ffda
        link.w a5, #$ffda
L062_000017CA:
; H062+$000017CA: 3b7c0003ffda  move.w #$3, -$26(a5)
        move.w #$3, -$26(a5)
L062_000017D0:
; H062+$000017D0: 3b7c000bffdc  move.w #$b, -$24(a5)
        move.w #$b, -$24(a5)
L062_000017D6:
; H062+$000017D6: 3b7c0015ffde  move.w #$15, -$22(a5)
        move.w #$15, -$22(a5)
L062_000017DC:
; H062+$000017DC: 3b7c0017ffe0  move.w #$17, -$20(a5)
        move.w #$17, -$20(a5)
L062_000017E2:
; H062+$000017E2: 3b7c001bffe2  move.w #$1b, -$1e(a5)
        move.w #$1b, -$1e(a5)
L062_000017E8:
; H062+$000017E8: 3b7c001effe4  move.w #$1e, -$1c(a5)
        move.w #$1e, -$1c(a5)
L062_000017EE:
; H062+$000017EE: 3b7c001fffe6  move.w #$1f, -$1a(a5)
        move.w #$1f, -$1a(a5)
L062_000017F4:
; H062+$000017F4: 3b7c0033ffe8  move.w #$33, -$18(a5)
        move.w #$33, -$18(a5)
L062_000017FA:
; H062+$000017FA: 3b7c0034ffea  move.w #$34, -$16(a5)
        move.w #$34, -$16(a5)
L062_00001800:
; H062+$00001800: 3b7c0035ffec  move.w #$35, -$14(a5)
        move.w #$35, -$14(a5)
L062_00001806:
; H062+$00001806: 3b7c005bffee  move.w #$5b, -$12(a5)
        move.w #$5b, -$12(a5)
L062_0000180C:
; H062+$0000180C: 3b7c006afff0  move.w #$6a, -$10(a5)
        move.w #$6a, -$10(a5)
L062_00001812:
; H062+$00001812: 3b7c006bfff2  move.w #$6b, -$e(a5)
        move.w #$6b, -$e(a5)
L062_00001818:
; H062+$00001818: 3b7c006ffff4  move.w #$6f, -$c(a5)
        move.w #$6f, -$c(a5)
L062_0000181E:
; H062+$0000181E: 3b7c0076fff6  move.w #$76, -$a(a5)
        move.w #$76, -$a(a5)
L062_00001824:
; H062+$00001824: 3b7c0077fff8  move.w #$77, -$8(a5)
        move.w #$77, -$8(a5)
L062_0000182A:
; H062+$0000182A: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L062_00001830:
; H062+$00001830: 0c6d0010fffe  cmpi.w #$10, -$2(a5)
        cmpi.w #$10, -$2(a5)
L062_00001836:
; H062+$00001836: 62000022  bhi.w $185a
        bhi.w H062+$185A
L062_0000183A:
; H062+$0000183A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000183E:
; H062+$0000183E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L062_00001842:
; H062+$00001842: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00001844:
; H062+$00001844: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00001846:
; H062+$00001846: 47edffda  lea.l -$26(a5), a3
        lea.l -$26(a5), a3
L062_0000184A:
; H062+$0000184A: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L062_0000184E:
; H062+$0000184E: 42a7  clr.l -(a7)
        clr.l -(a7)
L062_00001850:
; H062+$00001850: 6100ec00  bsr.w $452
        bsr.w H062+$452
L062_00001854:
; H062+$00001854: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L062_00001858:
; H062+$00001858: 64d6  bcc.b $1830
        bcc.b H062+$1830
L062_0000185A:
; H062+$0000185A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L062_0000185E:
; H062+$0000185E: 3f3c004d  move.w #$4d, -(a7)
        move.w #$4d, -(a7)
L062_00001862:
; H062+$00001862: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_00001866:
; H062+$00001866: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_0000186C:
; H062+$0000186C: 1400  move.b d0, d2
        move.b d0, d2
L062_0000186E:
; H062+$0000186E: 4a02  tst.b d2
        tst.b d2
L062_00001870:
; H062+$00001870: 6700001c  beq.w $188e
        beq.w H062+$188E
L062_00001874:
; H062+$00001874: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001876:
; H062+$00001876: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_0000187A:
; H062+$0000187A: 142b00ec  move.b $ec(a3), d2
        move.b $ec(a3), d2
L062_0000187E:
; H062+$0000187E: 0c4200b3  cmpi.w #$b3, d2
        cmpi.w #$b3, d2
L062_00001882:
; H062+$00001882: 6600000a  bne.w $188e
        bne.w H062+$188E
L062_00001886:
; H062+$00001886: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_0000188A:
; H062+$0000188A: 422b0199  clr.b $199(a3)
        clr.b $199(a3)
L062_0000188E:
; H062+$0000188E: 4e5d  unlk a5
        unlk a5
L062_00001890:
; H062+$00001890: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001892:
; H062+$00001892: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001894:
; H062+$00001894: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_00001896:
; H062+$00001896: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00001898 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H097+$0454
; --------------------------------------------------------------------------
L062_00001898:
; H062+$00001898: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000189A:
; H062+$0000189A: 287ae866  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000189E:
; H062+$0000189E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_000018A2:
; H062+$000018A2: 4e5d  unlk a5
        unlk a5
L062_000018A4:
; H062+$000018A4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000018A6:
; H062+$000018A6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000018A8:
; H062+$000018A8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_000018AA:
; H062+$000018AA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000018AC [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$0946, H063+$1DC2.
;   - Richiama H063+$0946.
;   - Richiama H063+$1DC2.
; Chiamanti diretti: H085+$2DCE, H085+$2ED8, H085+$3266, H085+$0A3A, H085+$0A58, H085+$30CC
; --------------------------------------------------------------------------
L062_000018AC:
; H062+$000018AC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000018AE:
; H062+$000018AE: 287ae852  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_000018B2:
; H062+$000018B2: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L062_000018B6:
; H062+$000018B6: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L062_000018BA:
; H062+$000018BA: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000018BE:
; H062+$000018BE: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L062_000018C2:
; H062+$000018C2: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_000018C6:
; H062+$000018C6: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_000018CC:
; H062+$000018CC: 1400  move.b d0, d2
        move.b d0, d2
L062_000018CE:
; H062+$000018CE: 4a02  tst.b d2
        tst.b d2
L062_000018D0:
; H062+$000018D0: 67000032  beq.w $1904
        beq.w H062+$1904
L062_000018D4:
; H062+$000018D4: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000018D8:
; H062+$000018D8: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L062_000018DC:
; H062+$000018DC: 486c004f  pea.l $4f(a4)
        pea.l $4f(a4)
L062_000018E0:
; H062+$000018E0: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_000018E4:
; H062+$000018E4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L062_000018E8:
; H062+$000018E8: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L062_000018EE:
; H062+$000018EE: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000018F2:
; H062+$000018F2: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L062_000018F6:
; H062+$000018F6: 2f2dfffa  move.l -$6(a5), -(a7)
        move.l -$6(a5), -(a7)
L062_000018FA:
; H062+$000018FA: 6100eb56  bsr.w $452
        bsr.w H062+$452
L062_000018FE:
; H062+$000018FE: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L062_00001904:
; H062+$00001904: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L062_00001908:
; H062+$00001908: 60000002  bra.w $190c
        bra.w H062+$190C
L062_0000190C:
; H062+$0000190C: 4e5d  unlk a5
        unlk a5
L062_0000190E:
; H062+$0000190E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001910:
; H062+$00001910: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001912:
; H062+$00001912: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L062_00001914:
; H062+$00001914: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00001916 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H062+$1A0C
; --------------------------------------------------------------------------
L062_00001916:
; H062+$00001916: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00001918:
; H062+$00001918: 287ae7e8  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000191C:
; H062+$0000191C: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L062_00001920:
; H062+$00001920: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L062_00001924:
; H062+$00001924: 06420064  addi.w #$64, d2
        addi.w #$64, d2
L062_00001928:
; H062+$00001928: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L062_0000192C:
; H062+$0000192C: 0c6d0012000e  cmpi.w #$12, $e(a5)
        cmpi.w #$12, $e(a5)
L062_00001932:
; H062+$00001932: 6600000c  bne.w $1940
        bne.w H062+$1940
L062_00001936:
; H062+$00001936: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_0000193A:
; H062+$0000193A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_0000193C:
; H062+$0000193C: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L062_00001940:
; H062+$00001940: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L062_00001944:
; H062+$00001944: 60000002  bra.w $1948
        bra.w H062+$1948
L062_00001948:
; H062+$00001948: 4e5d  unlk a5
        unlk a5
L062_0000194A:
; H062+$0000194A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_0000194C:
; H062+$0000194C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000194E:
; H062+$0000194E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_00001950:
; H062+$00001950: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00001952 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H029+$0354.
;   - Richiama H029+$0354.
; Chiamanti diretti: H062+$1DA2, H062+$1E80, H062+$1EB0
; --------------------------------------------------------------------------
L062_00001952:
; H062+$00001952: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00001954:
; H062+$00001954: 287ae7ac  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00001958:
; H062+$00001958: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_0000195C:
; H062+$0000195C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00001960:
; H062+$00001960: 4253  clr.w (a3)
        clr.w (a3)
L062_00001962:
; H062+$00001962: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_00001966:
; H062+$00001966: 1f2b0004  move.b $4(a3), -(a7)
        move.b $4(a3), -(a7)
L062_0000196A:
; H062+$0000196A: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L062_0000196E:
; H062+$0000196E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L062_00001974:
; H062+$00001974: 1400  move.b d0, d2
        move.b d0, d2
L062_00001976:
; H062+$00001976: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L062_0000197A:
; H062+$0000197A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_0000197E:
; H062+$0000197E: 3682  move.w d2, (a3)
        move.w d2, (a3)
L062_00001980:
; H062+$00001980: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00001984:
; H062+$00001984: 0c530065  cmpi.w #$65, (a3)
        cmpi.w #$65, (a3)
L062_00001988:
; H062+$00001988: 6200001c  bhi.w $19a6
        bhi.w H062+$19A6
L062_0000198C:
; H062+$0000198C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00001990:
; H062+$00001990: 3413  move.w (a3), d2
        move.w (a3), d2
L062_00001992:
; H062+$00001992: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00001994:
; H062+$00001994: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00001998:
; H062+$00001998: 3682  move.w d2, (a3)
        move.w d2, (a3)
L062_0000199A:
; H062+$0000199A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_0000199E:
; H062+$0000199E: 36bc0012  move.w #$12, (a3)
        move.w #$12, (a3)
L062_000019A2:
; H062+$000019A2: 60000012  bra.w $19b6
        bra.w H062+$19B6
L062_000019A6:
; H062+$000019A6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000019AA:
; H062+$000019AA: 3413  move.w (a3), d2
        move.w (a3), d2
L062_000019AC:
; H062+$000019AC: 04420064  subi.w #$64, d2
        subi.w #$64, d2
L062_000019B0:
; H062+$000019B0: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000019B4:
; H062+$000019B4: 3682  move.w d2, (a3)
        move.w d2, (a3)
L062_000019B6:
; H062+$000019B6: 4e5d  unlk a5
        unlk a5
L062_000019B8:
; H062+$000019B8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000019BA:
; H062+$000019BA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_000019BC:
; H062+$000019BC: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L062_000019C0:
; H062+$000019C0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_000019C2 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H085+$3338, H085+$1F7C, H085+$2D68
; --------------------------------------------------------------------------
L062_000019C2:
; H062+$000019C2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_000019C4:
; H062+$000019C4: 287ae73c  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_000019C8:
; H062+$000019C8: 4e55fff0  link.w a5, #$fff0
        link.w a5, #$fff0
L062_000019CC:
; H062+$000019CC: 7400  moveq #$0, d2
        moveq #0, d2
L062_000019CE:
; H062+$000019CE: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000019D2:
; H062+$000019D2: 142b0010  move.b $10(a3), d2
        move.b $10(a3), d2
L062_000019D6:
; H062+$000019D6: 382d0012  move.w $12(a5), d4
        move.w $12(a5), d4
L062_000019DA:
; H062+$000019DA: b842  cmp.w d2, d4
        cmp.w d2, d4
L062_000019DC:
; H062+$000019DC: 62000020  bhi.w $19fe
        bhi.w H062+$19FE
L062_000019E0:
; H062+$000019E0: 0c6d00120012  cmpi.w #$12, $12(a5)
        cmpi.w #$12, $12(a5)
L062_000019E6:
; H062+$000019E6: 66000032  bne.w $1a1a
        bne.w H062+$1A1A
L062_000019EA:
; H062+$000019EA: 7400  moveq #$0, d2
        moveq #0, d2
L062_000019EC:
; H062+$000019EC: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000019F0:
; H062+$000019F0: 142b001d  move.b $1d(a3), d2
        move.b $1d(a3), d2
L062_000019F4:
; H062+$000019F4: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L062_000019F8:
; H062+$000019F8: b842  cmp.w d2, d4
        cmp.w d2, d4
L062_000019FA:
; H062+$000019FA: 6300001e  bls.w $1a1a
        bls.w H062+$1A1A
L062_000019FE:
; H062+$000019FE: 1b7c0001fff1  move.b #$1, -$f(a5)
        move.b #$1, -$f(a5)
L062_00001A04:
; H062+$00001A04: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L062_00001A08:
; H062+$00001A08: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L062_00001A0C:
; H062+$00001A0C: 6100ff08  bsr.w $1916
        bsr.w H062+$1916
L062_00001A10:
; H062+$00001A10: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_00001A14:
; H062+$00001A14: 3680  move.w d0, (a3)
        move.w d0, (a3)
L062_00001A16:
; H062+$00001A16: 60000006  bra.w $1a1e
        bra.w H062+$1A1E
L062_00001A1A:
; H062+$00001A1A: 422dfff1  clr.b -$f(a5)
        clr.b -$f(a5)
L062_00001A1E:
; H062+$00001A1E: 102dfff1  move.b -$f(a5), d0
        move.b -$f(a5), d0
L062_00001A22:
; H062+$00001A22: 60000002  bra.w $1a26
        bra.w H062+$1A26
L062_00001A26:
; H062+$00001A26: 4e5d  unlk a5
        unlk a5
L062_00001A28:
; H062+$00001A28: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00001A2A:
; H062+$00001A2A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001A2C:
; H062+$00001A2C: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L062_00001A30:
; H062+$00001A30: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H062_1C04 [parziale]
; Scopo: Trampolino verso H062+$1C04; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H062+$1C04.
;   - Richiama H029+$0354.
;   - Richiama H063+$0946.
;   - Richiama H029+$03E2.
; Chiamanti diretti: H085+$206A, H085+$20D2, H085+$339C, H085+$1FD0, H085+$2DAE, H085+$0A98 e altri 8
; --------------------------------------------------------------------------
L062_00001A32:
; H062+$00001A32: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00001A34:
; H062+$00001A34: 287ae6cc  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00001A38:
; H062+$00001A38: 4e55ffe2  link.w a5, #$ffe2
        link.w a5, #$ffe2
L062_00001A3C:
; H062+$00001A3C: 600001c6  bra.w $1c04
        bra.w H062+$1C04
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00001A40 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H062+$1D44, H062+$1E86, H062+$1EB6, H062+$1E56
; --------------------------------------------------------------------------
L062_00001A40:
; H062+$00001A40: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_00001A44:
; H062+$00001A44: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001A48:
; H062+$00001A48: 342bfff0  move.w -$10(a3), d2
        move.w -$10(a3), d2
L062_00001A4C:
; H062+$00001A4C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001A50:
; H062+$00001A50: b46bfff2  cmp.w -$e(a3), d2
        cmp.w -$e(a3), d2
L062_00001A54:
; H062+$00001A54: 62000024  bhi.w $1a7a
        bhi.w H062+$1A7A
L062_00001A58:
; H062+$00001A58: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001A5C:
; H062+$00001A5C: 0c6b0012fff0  cmpi.w #$12, -$10(a3)
        cmpi.w #$12, -$10(a3)
L062_00001A62:
; H062+$00001A62: 66000032  bne.w $1a96
        bne.w H062+$1A96
L062_00001A66:
; H062+$00001A66: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001A6A:
; H062+$00001A6A: 342bffec  move.w -$14(a3), d2
        move.w -$14(a3), d2
L062_00001A6E:
; H062+$00001A6E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001A72:
; H062+$00001A72: b46bffee  cmp.w -$12(a3), d2
        cmp.w -$12(a3), d2
L062_00001A76:
; H062+$00001A76: 6300001e  bls.w $1a96
        bls.w H062+$1A96
L062_00001A7A:
; H062+$00001A7A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001A7E:
; H062+$00001A7E: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L062_00001A82:
; H062+$00001A82: 356bfff0fff2  move.w -$10(a3), -$e(a2)
        move.w -$10(a3), -$e(a2)
L062_00001A88:
; H062+$00001A88: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001A8C:
; H062+$00001A8C: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L062_00001A90:
; H062+$00001A90: 356bffecffee  move.w -$14(a3), -$12(a2)
        move.w -$14(a3), -$12(a2)
L062_00001A96:
; H062+$00001A96: 4e5d  unlk a5
        unlk a5
L062_00001A98:
; H062+$00001A98: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001A9A:
; H062+$00001A9A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L062_00001A9C:
; H062+$00001A9C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00001A9E [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H029+$0354, H063+$0946, H029+$03E2.
;   - Richiama H029+$0354.
;   - Richiama H063+$0946.
;   - Richiama H029+$03E2.
; Chiamanti diretti: H062+$1F4E, H062+$1FD4
; --------------------------------------------------------------------------
L062_00001A9E:
; H062+$00001A9E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L062_00001AA2:
; H062+$00001AA2: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001AA4:
; H062+$00001AA4: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L062_00001AA8:
; H062+$00001AA8: 47f900005026  lea.l $5026.l, a3
        lea.l (H005+$5026).l, a3
L062_00001AAE:
; H062+$00001AAE: 7800  moveq #$0, d4
        moveq #0, d4
L062_00001AB0:
; H062+$00001AB0: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00001AB4:
; H062+$00001AB4: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_00001AB8:
; H062+$00001AB8: b444  cmp.w d4, d2
        cmp.w d4, d2
L062_00001ABA:
; H062+$00001ABA: 6500001a  bcs.w $1ad6
        bcs.w H062+$1AD6
L062_00001ABE:
; H062+$00001ABE: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001AC0:
; H062+$00001AC0: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L062_00001AC4:
; H062+$00001AC4: 47f900005026  lea.l $5026.l, a3
        lea.l (H005+$5026).l, a3
L062_00001ACA:
; H062+$00001ACA: 7800  moveq #$0, d4
        moveq #0, d4
L062_00001ACC:
; H062+$00001ACC: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00001AD0:
; H062+$00001AD0: 5344  subq.w #$1, d4
        subq.w #$1, d4
L062_00001AD2:
; H062+$00001AD2: 3b44000c  move.w d4, $c(a5)
        move.w d4, $c(a5)
L062_00001AD6:
; H062+$00001AD6: 0c2d0004000e  cmpi.b #$4, $e(a5)
        cmpi.b #$4, $e(a5)
L062_00001ADC:
; H062+$00001ADC: 66000032  bne.w $1b10
        bne.w H062+$1B10
L062_00001AE0:
; H062+$00001AE0: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001AE4:
; H062+$00001AE4: 266b000e  movea.l $e(a3), a3
        movea.l $e(a3), a3
L062_00001AE8:
; H062+$00001AE8: 4a2b00dc  tst.b $dc(a3)
        tst.b $dc(a3)
L062_00001AEC:
; H062+$00001AEC: 6700001e  beq.w $1b0c
        beq.w H062+$1B0C
L062_00001AF0:
; H062+$00001AF0: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001AF4:
; H062+$00001AF4: 266b000e  movea.l $e(a3), a3
        movea.l $e(a3), a3
L062_00001AF8:
; H062+$00001AF8: 142b010a  move.b $10a(a3), d2
        move.b $10a(a3), d2
L062_00001AFC:
; H062+$00001AFC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001B00:
; H062+$00001B00: 266b000e  movea.l $e(a3), a3
        movea.l $e(a3), a3
L062_00001B04:
; H062+$00001B04: b42b00dc  cmp.b $dc(a3), d2
        cmp.b $dc(a3), d2
L062_00001B08:
; H062+$00001B08: 66000006  bne.w $1b10
        bne.w H062+$1B10
L062_00001B0C:
; H062+$00001B0C: 526d000c  addq.w #$1, $c(a5)
        addq.w #$1, $c(a5)
L062_00001B10:
; H062+$00001B10: 0c2d0002000e  cmpi.b #$2, $e(a5)
        cmpi.b #$2, $e(a5)
L062_00001B16:
; H062+$00001B16: 67000016  beq.w $1b2e
        beq.w H062+$1B2E
L062_00001B1A:
; H062+$00001B1A: 0c2d0004000e  cmpi.b #$4, $e(a5)
        cmpi.b #$4, $e(a5)
L062_00001B20:
; H062+$00001B20: 6700000c  beq.w $1b2e
        beq.w H062+$1B2E
L062_00001B24:
; H062+$00001B24: 0c2d0007000e  cmpi.b #$7, $e(a5)
        cmpi.b #$7, $e(a5)
L062_00001B2A:
; H062+$00001B2A: 66000096  bne.w $1bc2
        bne.w H062+$1BC2
L062_00001B2E:
; H062+$00001B2E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001B32:
; H062+$00001B32: 342bfff2  move.w -$e(a3), d2
        move.w -$e(a3), d2
L062_00001B36:
; H062+$00001B36: 6000006c  bra.w $1ba4
        bra.w H062+$1BA4
L062_00001B3A:
; H062+$00001B3A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001B3E:
; H062+$00001B3E: 342bfff2  move.w -$e(a3), d2
        move.w -$e(a3), d2
L062_00001B42:
; H062+$00001B42: 0442000e  subi.w #$e, d2
        subi.w #$e, d2
L062_00001B46:
; H062+$00001B46: c4ed000c  mulu.w $c(a5), d2
        mulu.w $c(a5), d2
L062_00001B4A:
; H062+$00001B4A: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001B4E:
; H062+$00001B4E: d56bfffc  add.w d2, -$4(a3)
        add.w d2, -$4(a3)
L062_00001B52:
; H062+$00001B52: 4e75  rts 
        rts 
L062_00001B54:
; H062+$00001B54: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_00001B58:
; H062+$00001B58: c4fc0005  mulu.w #$5, d2
        mulu.w #$5, d2
L062_00001B5C:
; H062+$00001B5C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001B60:
; H062+$00001B60: d56bfffc  add.w d2, -$4(a3)
        add.w d2, -$4(a3)
L062_00001B64:
; H062+$00001B64: 4e75  rts 
        rts 
L062_00001B66:
; H062+$00001B66: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_00001B6A:
; H062+$00001B6A: c4fc0006  mulu.w #$6, d2
        mulu.w #$6, d2
L062_00001B6E:
; H062+$00001B6E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001B72:
; H062+$00001B72: d56bfffc  add.w d2, -$4(a3)
        add.w d2, -$4(a3)
L062_00001B76:
; H062+$00001B76: 4e75  rts 
        rts 
L062_00001B78:
; H062+$00001B78: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_00001B7C:
; H062+$00001B7C: c4fc0007  mulu.w #$7, d2
        mulu.w #$7, d2
L062_00001B80:
; H062+$00001B80: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001B84:
; H062+$00001B84: d56bfffc  add.w d2, -$4(a3)
        add.w d2, -$4(a3)
L062_00001B88:
; H062+$00001B88: 4e75  rts 
        rts 
L062_00001B8A:
; H062+$00001B8A: 4e75  rts 
        rts 
; Preserved bytes H062+$00001B8C..$00001BA4; code/data not fully classified.
        dc.w $FFFC,$FFAC,$FFAC,$FFAC,$FFAC,$FFAC,$FFC6,$FFD8
        dc.w $FFD8,$FFD8,$FFEA,$FFEA
L062_00001BA4:
; H062+$00001BA4: 47faffe8  lea.l $1b8e(pc), a3
        lea.l H062+$1B8E(pc), a3
L062_00001BA8:
; H062+$00001BA8: 0442000f  subi.w #$f, d2
        subi.w #$f, d2
L062_00001BAC:
; H062+$00001BAC: 0c42000a  cmpi.w #$a, d2
        cmpi.w #$a, d2
L062_00001BB0:
; H062+$00001BB0: 6302  bls.b $1bb4
        bls.b H062+$1BB4
L062_00001BB2:
; H062+$00001BB2: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_00001BB4:
; H062+$00001BB4: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00001BB6:
; H062+$00001BB6: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$1B8E; indici 0..10, default -1.
L062_00001BBA:
; H062+$00001BBA: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_00001BBE:
; H062+$00001BBE: 6000003c  bra.w $1bfc
        bra.w H062+$1BFC
L062_00001BC2:
; H062+$00001BC2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001BC6:
; H062+$00001BC6: 0c6b000ffff2  cmpi.w #$f, -$e(a3)
        cmpi.w #$f, -$e(a3)
L062_00001BCC:
; H062+$00001BCC: 63000014  bls.w $1be2
        bls.w H062+$1BE2
L062_00001BD0:
; H062+$00001BD0: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_00001BD4:
; H062+$00001BD4: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00001BD6:
; H062+$00001BD6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001BDA:
; H062+$00001BDA: d56bfffc  add.w d2, -$4(a3)
        add.w d2, -$4(a3)
L062_00001BDE:
; H062+$00001BDE: 6000001c  bra.w $1bfc
        bra.w H062+$1BFC
L062_00001BE2:
; H062+$00001BE2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001BE6:
; H062+$00001BE6: 0c6b000ffff2  cmpi.w #$f, -$e(a3)
        cmpi.w #$f, -$e(a3)
L062_00001BEC:
; H062+$00001BEC: 6600000e  bne.w $1bfc
        bne.w H062+$1BFC
L062_00001BF0:
; H062+$00001BF0: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L062_00001BF4:
; H062+$00001BF4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L062_00001BF8:
; H062+$00001BF8: d56bfffc  add.w d2, -$4(a3)
        add.w d2, -$4(a3)
L062_00001BFC:
; H062+$00001BFC: 4e5d  unlk a5
        unlk a5
L062_00001BFE:
; H062+$00001BFE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00001C00:
; H062+$00001C00: 508f  addq.l #$8, a7
        addq.l #$8, a7
L062_00001C02:
; H062+$00001C02: 4ed0  jmp (a0)
        jmp (a0)
L062_00001C04:
; H062+$00001C04: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L062_00001C08:
; H062+$00001C08: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L062_00001C0C:
; H062+$00001C0C: 426dffec  clr.w -$14(a5)
        clr.w -$14(a5)
L062_00001C10:
; H062+$00001C10: 3b7c00fffff8  move.w #$ff, -$8(a5)
        move.w #$ff, -$8(a5)
L062_00001C16:
; H062+$00001C16: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001C1A:
; H062+$00001C1A: 2b6b0150ffe2  move.l $150(a3), -$1e(a5)
        move.l $150(a3), -$1e(a5)
L062_00001C20:
; H062+$00001C20: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001C22:
; H062+$00001C22: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L062_00001C26:
; H062+$00001C26: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00001C28:
; H062+$00001C28: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001C2C:
; H062+$00001C2C: 47eb0010  lea.l $10(a3), a3
        lea.l $10(a3), a3
L062_00001C30:
; H062+$00001C30: 7800  moveq #$0, d4
        moveq #0, d4
L062_00001C32:
; H062+$00001C32: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00001C36:
; H062+$00001C36: 3b44fff2  move.w d4, -$e(a5)
        move.w d4, -$e(a5)
L062_00001C3A:
; H062+$00001C3A: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001C3C:
; H062+$00001C3C: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001C40:
; H062+$00001C40: 142b001d  move.b $1d(a3), d2
        move.b $1d(a3), d2
L062_00001C44:
; H062+$00001C44: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L062_00001C48:
; H062+$00001C48: 4aadffe2  tst.l -$1e(a5)
        tst.l -$1e(a5)
L062_00001C4C:
; H062+$00001C4C: 67000124  beq.w $1d72
        beq.w H062+$1D72
L062_00001C50:
; H062+$00001C50: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001C52:
; H062+$00001C52: 266dffe2  movea.l -$1e(a5), a3
        movea.l -$1e(a5), a3
L062_00001C56:
; H062+$00001C56: 142b0046  move.b $46(a3), d2
        move.b $46(a3), d2
L062_00001C5A:
; H062+$00001C5A: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L062_00001C5E:
; H062+$00001C5E: 63000104  bls.w $1d64
        bls.w H062+$1D64
L062_00001C62:
; H062+$00001C62: 266dffe2  movea.l -$1e(a5), a3
        movea.l -$1e(a5), a3
L062_00001C66:
; H062+$00001C66: 4a2b003a  tst.b $3a(a3)
        tst.b $3a(a3)
L062_00001C6A:
; H062+$00001C6A: 670000f8  beq.w $1d64
        beq.w H062+$1D64
L062_00001C6E:
; H062+$00001C6E: 266dffe2  movea.l -$1e(a5), a3
        movea.l -$1e(a5), a3
L062_00001C72:
; H062+$00001C72: 1f2b0046  move.b $46(a3), -(a7)
        move.b $46(a3), -(a7)
L062_00001C76:
; H062+$00001C76: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L062_00001C7A:
; H062+$00001C7A: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L062_00001C80:
; H062+$00001C80: 1400  move.b d0, d2
        move.b d0, d2
L062_00001C82:
; H062+$00001C82: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L062_00001C86:
; H062+$00001C86: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L062_00001C8A:
; H062+$00001C8A: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001C8C:
; H062+$00001C8C: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L062_00001C90:
; H062+$00001C90: 600000be  bra.w $1d50
        bra.w H062+$1D50
L062_00001C94:
; H062+$00001C94: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L062_00001C98:
; H062+$00001C98: 60000090  bra.w $1d2a
        bra.w H062+$1D2A
L062_00001C9C:
; H062+$00001C9C: 3b7c0012fff0  move.w #$12, -$10(a5)
        move.w #$12, -$10(a5)
L062_00001CA2:
; H062+$00001CA2: 3b7c0064ffec  move.w #$64, -$14(a5)
        move.w #$64, -$14(a5)
L062_00001CA8:
; H062+$00001CA8: 4e75  rts 
        rts 
L062_00001CAA:
; H062+$00001CAA: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001CAC:
; H062+$00001CAC: 266dffe2  movea.l -$1e(a5), a3
        movea.l -$1e(a5), a3
L062_00001CB0:
; H062+$00001CB0: 142b0045  move.b $45(a3), d2
        move.b $45(a3), d2
L062_00001CB4:
; H062+$00001CB4: 60000052  bra.w $1d08
        bra.w H062+$1D08
L062_00001CB8:
; H062+$00001CB8: 3b7c0012fff0  move.w #$12, -$10(a5)
        move.w #$12, -$10(a5)
L062_00001CBE:
; H062+$00001CBE: 3b7c0064ffec  move.w #$64, -$14(a5)
        move.w #$64, -$14(a5)
L062_00001CC4:
; H062+$00001CC4: 4e75  rts 
        rts 
L062_00001CC6:
; H062+$00001CC6: 3b7c0013fff0  move.w #$13, -$10(a5)
        move.w #$13, -$10(a5)
L062_00001CCC:
; H062+$00001CCC: 4e75  rts 
        rts 
L062_00001CCE:
; H062+$00001CCE: 3b7c0014fff0  move.w #$14, -$10(a5)
        move.w #$14, -$10(a5)
L062_00001CD4:
; H062+$00001CD4: 4e75  rts 
        rts 
L062_00001CD6:
; H062+$00001CD6: 3b7c0015fff0  move.w #$15, -$10(a5)
        move.w #$15, -$10(a5)
L062_00001CDC:
; H062+$00001CDC: 4e75  rts 
        rts 
L062_00001CDE:
; H062+$00001CDE: 3b7c0016fff0  move.w #$16, -$10(a5)
        move.w #$16, -$10(a5)
L062_00001CE4:
; H062+$00001CE4: 4e75  rts 
        rts 
L062_00001CE6:
; H062+$00001CE6: 3b7c0017fff0  move.w #$17, -$10(a5)
        move.w #$17, -$10(a5)
L062_00001CEC:
; H062+$00001CEC: 4e75  rts 
        rts 
L062_00001CEE:
; H062+$00001CEE: 3b7c0018fff0  move.w #$18, -$10(a5)
        move.w #$18, -$10(a5)
L062_00001CF4:
; H062+$00001CF4: 4e75  rts 
        rts 
L062_00001CF6:
; H062+$00001CF6: 4e75  rts 
        rts 
; Preserved bytes H062+$00001CF8..$00001D08; code/data not fully classified.
        dc.w $FFFC,$FFBE,$FFCC,$FFD4,$FFDC,$FFE4,$FFEC,$FFF4
L062_00001D08:
; H062+$00001D08: 47fafff0  lea.l $1cfa(pc), a3
        lea.l H062+$1CFA(pc), a3
L062_00001D0C:
; H062+$00001D0C: 0c420006  cmpi.w #$6, d2
        cmpi.w #$6, d2
L062_00001D10:
; H062+$00001D10: 6302  bls.b $1d14
        bls.b H062+$1D14
L062_00001D12:
; H062+$00001D12: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_00001D14:
; H062+$00001D14: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00001D16:
; H062+$00001D16: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$1CFA; indici 0..6, default -1.
L062_00001D1A:
; H062+$00001D1A: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_00001D1E:
; H062+$00001D1E: 4e75  rts 
        rts 
L062_00001D20:
; H062+$00001D20: 4e75  rts 
        rts 
; Preserved bytes H062+$00001D22..$00001D2A; code/data not fully classified.
        dc.w $FFFC,$FF78,$FFFC,$FF86
L062_00001D2A:
; H062+$00001D2A: 47fafff8  lea.l $1d24(pc), a3
        lea.l H062+$1D24(pc), a3
L062_00001D2E:
; H062+$00001D2E: 5742  subq.w #$3, d2
        subq.w #$3, d2
L062_00001D30:
; H062+$00001D30: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L062_00001D34:
; H062+$00001D34: 6302  bls.b $1d38
        bls.b H062+$1D38
L062_00001D36:
; H062+$00001D36: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_00001D38:
; H062+$00001D38: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00001D3A:
; H062+$00001D3A: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$1D24; indici 0..2, default -1.
L062_00001D3E:
; H062+$00001D3E: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_00001D42:
; H062+$00001D42: 4855  pea.l (a5)
        pea.l (a5)
L062_00001D44:
; H062+$00001D44: 6100fcfa  bsr.w $1a40
        bsr.w H062+$1A40
L062_00001D48:
; H062+$00001D48: 4e75  rts 
        rts 
L062_00001D4A:
; H062+$00001D4A: 4e75  rts 
        rts 
; Preserved bytes H062+$00001D4C..$00001D50; code/data not fully classified.
        dc.w $FFFC,$FF46
L062_00001D50:
; H062+$00001D50: 47fafffc  lea.l $1d4e(pc), a3
        lea.l H062+$1D4E(pc), a3
L062_00001D54:
; H062+$00001D54: 4a42  tst.w d2
        tst.w d2
L062_00001D56:
; H062+$00001D56: 6302  bls.b $1d5a
        bls.b H062+$1D5A
L062_00001D58:
; H062+$00001D58: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_00001D5A:
; H062+$00001D5A: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00001D5C:
; H062+$00001D5C: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$1D4E; indici 0..0, default -1.
L062_00001D60:
; H062+$00001D60: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_00001D64:
; H062+$00001D64: 266dffe2  movea.l -$1e(a5), a3
        movea.l -$1e(a5), a3
L062_00001D68:
; H062+$00001D68: 2b6b002cffe2  move.l $2c(a3), -$1e(a5)
        move.l $2c(a3), -$1e(a5)
L062_00001D6E:
; H062+$00001D6E: 6000fed8  bra.w $1c48
        bra.w H062+$1C48
L062_00001D72:
; H062+$00001D72: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001D74:
; H062+$00001D74: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L062_00001D78:
; H062+$00001D78: 600003ee  bra.w $2168
        bra.w H062+$2168
L062_00001D7C:
; H062+$00001D7C: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00001D80:
; H062+$00001D80: 3f3c0026  move.w #$26, -(a7)
        move.w #$26, -(a7)
L062_00001D84:
; H062+$00001D84: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_00001D88:
; H062+$00001D88: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_00001D8E:
; H062+$00001D8E: 1400  move.b d0, d2
        move.b d0, d2
L062_00001D90:
; H062+$00001D90: 4a02  tst.b d2
        tst.b d2
L062_00001D92:
; H062+$00001D92: 670000c6  beq.w $1e5a
        beq.w H062+$1E5A
L062_00001D96:
; H062+$00001D96: 2f2dffe8  move.l -$18(a5), -(a7)
        move.l -$18(a5), -(a7)
L062_00001D9A:
; H062+$00001D9A: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
L062_00001D9E:
; H062+$00001D9E: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L062_00001DA2:
; H062+$00001DA2: 6100fbae  bsr.w $1952
        bsr.w H062+$1952
L062_00001DA6:
; H062+$00001DA6: 0c6d0012fff2  cmpi.w #$12, -$e(a5)
        cmpi.w #$12, -$e(a5)
L062_00001DAC:
; H062+$00001DAC: 620000a6  bhi.w $1e54
        bhi.w H062+$1E54
L062_00001DB0:
; H062+$00001DB0: 0c6d0064ffee  cmpi.w #$64, -$12(a5)
        cmpi.w #$64, -$12(a5)
L062_00001DB6:
; H062+$00001DB6: 6400009c  bcc.w $1e54
        bcc.w H062+$1E54
L062_00001DBA:
; H062+$00001DBA: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L062_00001DBE:
; H062+$00001DBE: d46dfff0  add.w -$10(a5), d2
        add.w -$10(a5), d2
L062_00001DC2:
; H062+$00001DC2: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L062_00001DC6:
; H062+$00001DC6: 0c6d0012fff0  cmpi.w #$12, -$10(a5)
        cmpi.w #$12, -$10(a5)
L062_00001DCC:
; H062+$00001DCC: 63000086  bls.w $1e54
        bls.w H062+$1E54
L062_00001DD0:
; H062+$00001DD0: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001DD4:
; H062+$00001DD4: 4a2b0100  tst.b $100(a3)
        tst.b $100(a3)
L062_00001DD8:
; H062+$00001DD8: 6200003e  bhi.w $1e18
        bhi.w H062+$1E18
L062_00001DDC:
; H062+$00001DDC: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001DE0:
; H062+$00001DE0: 4a2b0108  tst.b $108(a3)
        tst.b $108(a3)
L062_00001DE4:
; H062+$00001DE4: 62000032  bhi.w $1e18
        bhi.w H062+$1E18
L062_00001DE8:
; H062+$00001DE8: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001DEC:
; H062+$00001DEC: 4a2b0105  tst.b $105(a3)
        tst.b $105(a3)
L062_00001DF0:
; H062+$00001DF0: 62000026  bhi.w $1e18
        bhi.w H062+$1E18
L062_00001DF4:
; H062+$00001DF4: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001DF8:
; H062+$00001DF8: 4a2b010d  tst.b $10d(a3)
        tst.b $10d(a3)
L062_00001DFC:
; H062+$00001DFC: 6200001a  bhi.w $1e18
        bhi.w H062+$1E18
L062_00001E00:
; H062+$00001E00: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001E04:
; H062+$00001E04: 4a2b0102  tst.b $102(a3)
        tst.b $102(a3)
L062_00001E08:
; H062+$00001E08: 6200000e  bhi.w $1e18
        bhi.w H062+$1E18
L062_00001E0C:
; H062+$00001E0C: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001E10:
; H062+$00001E10: 4a2b010a  tst.b $10a(a3)
        tst.b $10a(a3)
L062_00001E14:
; H062+$00001E14: 63000038  bls.w $1e4e
        bls.w H062+$1E4E
L062_00001E18:
; H062+$00001E18: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001E1A:
; H062+$00001E1A: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001E1E:
; H062+$00001E1E: 142b001c  move.b $1c(a3), d2
        move.b $1c(a3), d2
L062_00001E22:
; H062+$00001E22: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L062_00001E26:
; H062+$00001E26: 04440012  subi.w #$12, d4
        subi.w #$12, d4
L062_00001E2A:
; H062+$00001E2A: c8fc000a  mulu.w #$a, d4
        mulu.w #$a, d4
L062_00001E2E:
; H062+$00001E2E: d444  add.w d4, d2
        add.w d4, d2
L062_00001E30:
; H062+$00001E30: 3b42ffec  move.w d2, -$14(a5)
        move.w d2, -$14(a5)
L062_00001E34:
; H062+$00001E34: 0c6d0064ffec  cmpi.w #$64, -$14(a5)
        cmpi.w #$64, -$14(a5)
L062_00001E3A:
; H062+$00001E3A: 63000008  bls.w $1e44
        bls.w H062+$1E44
L062_00001E3E:
; H062+$00001E3E: 3b7c0064ffec  move.w #$64, -$14(a5)
        move.w #$64, -$14(a5)
L062_00001E44:
; H062+$00001E44: 3b7c0012fff0  move.w #$12, -$10(a5)
        move.w #$12, -$10(a5)
L062_00001E4A:
; H062+$00001E4A: 60000008  bra.w $1e54
        bra.w H062+$1E54
L062_00001E4E:
; H062+$00001E4E: 3b7c0012fff0  move.w #$12, -$10(a5)
        move.w #$12, -$10(a5)
L062_00001E54:
; H062+$00001E54: 4855  pea.l (a5)
        pea.l (a5)
L062_00001E56:
; H062+$00001E56: 6100fbe8  bsr.w $1a40
        bsr.w H062+$1A40
L062_00001E5A:
; H062+$00001E5A: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00001E5E:
; H062+$00001E5E: 3f3c0071  move.w #$71, -(a7)
        move.w #$71, -(a7)
L062_00001E62:
; H062+$00001E62: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_00001E66:
; H062+$00001E66: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_00001E6C:
; H062+$00001E6C: 1400  move.b d0, d2
        move.b d0, d2
L062_00001E6E:
; H062+$00001E6E: 4a02  tst.b d2
        tst.b d2
L062_00001E70:
; H062+$00001E70: 67000018  beq.w $1e8a
        beq.w H062+$1E8A
L062_00001E74:
; H062+$00001E74: 2f2dffe8  move.l -$18(a5), -(a7)
        move.l -$18(a5), -(a7)
L062_00001E78:
; H062+$00001E78: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
L062_00001E7C:
; H062+$00001E7C: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L062_00001E80:
; H062+$00001E80: 6100fad0  bsr.w $1952
        bsr.w H062+$1952
L062_00001E84:
; H062+$00001E84: 4855  pea.l (a5)
        pea.l (a5)
L062_00001E86:
; H062+$00001E86: 6100fbb8  bsr.w $1a40
        bsr.w H062+$1A40
L062_00001E8A:
; H062+$00001E8A: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00001E8E:
; H062+$00001E8E: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L062_00001E92:
; H062+$00001E92: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_00001E96:
; H062+$00001E96: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_00001E9C:
; H062+$00001E9C: 1400  move.b d0, d2
        move.b d0, d2
L062_00001E9E:
; H062+$00001E9E: 4a02  tst.b d2
        tst.b d2
L062_00001EA0:
; H062+$00001EA0: 67000018  beq.w $1eba
        beq.w H062+$1EBA
L062_00001EA4:
; H062+$00001EA4: 2f2dffe8  move.l -$18(a5), -(a7)
        move.l -$18(a5), -(a7)
L062_00001EA8:
; H062+$00001EA8: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
L062_00001EAC:
; H062+$00001EAC: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L062_00001EB0:
; H062+$00001EB0: 6100faa0  bsr.w $1952
        bsr.w H062+$1952
L062_00001EB4:
; H062+$00001EB4: 4855  pea.l (a5)
        pea.l (a5)
L062_00001EB6:
; H062+$00001EB6: 6100fb88  bsr.w $1a40
        bsr.w H062+$1A40
L062_00001EBA:
; H062+$00001EBA: 0c6d00fffff8  cmpi.w #$ff, -$8(a5)
        cmpi.w #$ff, -$8(a5)
L062_00001EC0:
; H062+$00001EC0: 6700001a  beq.w $1edc
        beq.w H062+$1EDC
L062_00001EC4:
; H062+$00001EC4: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L062_00001EC8:
; H062+$00001EC8: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001ECC:
; H062+$00001ECC: 17420011  move.b d2, $11(a3)
        move.b d2, $11(a3)
L062_00001ED0:
; H062+$00001ED0: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001ED4:
; H062+$00001ED4: 422b001c  clr.b $1c(a3)
        clr.b $1c(a3)
L062_00001ED8:
; H062+$00001ED8: 6000001a  bra.w $1ef4
        bra.w H062+$1EF4
L062_00001EDC:
; H062+$00001EDC: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L062_00001EE0:
; H062+$00001EE0: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001EE4:
; H062+$00001EE4: 17420011  move.b d2, $11(a3)
        move.b d2, $11(a3)
L062_00001EE8:
; H062+$00001EE8: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L062_00001EEC:
; H062+$00001EEC: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001EF0:
; H062+$00001EF0: 1742001c  move.b d2, $1c(a3)
        move.b d2, $1c(a3)
L062_00001EF4:
; H062+$00001EF4: 4e75  rts 
        rts 
L062_00001EF6:
; H062+$00001EF6: 426dfff4  clr.w -$c(a5)
        clr.w -$c(a5)
L062_00001EFA:
; H062+$00001EFA: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001EFC:
; H062+$00001EFC: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001F00:
; H062+$00001F00: 142b0064  move.b $64(a3), d2
        move.b $64(a3), d2
L062_00001F04:
; H062+$00001F04: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L062_00001F08:
; H062+$00001F08: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001F0C:
; H062+$00001F0C: 246d000e  movea.l $e(a5), a2
        movea.l $e(a5), a2
L062_00001F10:
; H062+$00001F10: 156b01230064  move.b $123(a3), $64(a2)
        move.b $123(a3), $64(a2)
L062_00001F16:
; H062+$00001F16: 422dffe7  clr.b -$19(a5)
        clr.b -$19(a5)
L062_00001F1A:
; H062+$00001F1A: 0c2d0007ffe7  cmpi.b #$7, -$19(a5)
        cmpi.b #$7, -$19(a5)
L062_00001F20:
; H062+$00001F20: 620000be  bhi.w $1fe0
        bhi.w H062+$1FE0
L062_00001F24:
; H062+$00001F24: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001F26:
; H062+$00001F26: 142dffe7  move.b -$19(a5), d2
        move.b -$19(a5), d2
L062_00001F2A:
; H062+$00001F2A: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001F2E:
; H062+$00001F2E: 47eb0106  lea.l $106(a3), a3
        lea.l $106(a3), a3
L062_00001F32:
; H062+$00001F32: 7800  moveq #$0, d4
        moveq #0, d4
L062_00001F34:
; H062+$00001F34: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00001F38:
; H062+$00001F38: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L062_00001F3C:
; H062+$00001F3C: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L062_00001F40:
; H062+$00001F40: 63000010  bls.w $1f52
        bls.w H062+$1F52
L062_00001F44:
; H062+$00001F44: 1f2dffe7  move.b -$19(a5), -(a7)
        move.b -$19(a5), -(a7)
L062_00001F48:
; H062+$00001F48: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L062_00001F4C:
; H062+$00001F4C: 4855  pea.l (a5)
        pea.l (a5)
L062_00001F4E:
; H062+$00001F4E: 6100fb4e  bsr.w $1a9e
        bsr.w H062+$1A9E
L062_00001F52:
; H062+$00001F52: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001F54:
; H062+$00001F54: 142dffe7  move.b -$19(a5), d2
        move.b -$19(a5), d2
L062_00001F58:
; H062+$00001F58: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001F5C:
; H062+$00001F5C: 47eb00fe  lea.l $fe(a3), a3
        lea.l $fe(a3), a3
L062_00001F60:
; H062+$00001F60: 7800  moveq #$0, d4
        moveq #0, d4
L062_00001F62:
; H062+$00001F62: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00001F66:
; H062+$00001F66: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L062_00001F6A:
; H062+$00001F6A: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L062_00001F6E:
; H062+$00001F6E: 63000006  bls.w $1f76
        bls.w H062+$1F76
L062_00001F72:
; H062+$00001F72: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L062_00001F76:
; H062+$00001F76: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001F78:
; H062+$00001F78: 142dffe7  move.b -$19(a5), d2
        move.b -$19(a5), d2
L062_00001F7C:
; H062+$00001F7C: 47f900005026  lea.l $5026.l, a3
        lea.l (H005+$5026).l, a3
L062_00001F82:
; H062+$00001F82: 7800  moveq #$0, d4
        moveq #0, d4
L062_00001F84:
; H062+$00001F84: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00001F88:
; H062+$00001F88: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L062_00001F8C:
; H062+$00001F8C: b444  cmp.w d4, d2
        cmp.w d4, d2
L062_00001F8E:
; H062+$00001F8E: 63000018  bls.w $1fa8
        bls.w H062+$1FA8
L062_00001F92:
; H062+$00001F92: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001F94:
; H062+$00001F94: 142dffe7  move.b -$19(a5), d2
        move.b -$19(a5), d2
L062_00001F98:
; H062+$00001F98: 47f900005026  lea.l $5026.l, a3
        lea.l (H005+$5026).l, a3
L062_00001F9E:
; H062+$00001F9E: 7800  moveq #$0, d4
        moveq #0, d4
L062_00001FA0:
; H062+$00001FA0: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L062_00001FA4:
; H062+$00001FA4: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L062_00001FA8:
; H062+$00001FA8: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001FAA:
; H062+$00001FAA: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001FAE:
; H062+$00001FAE: 142b00dc  move.b $dc(a3), d2
        move.b $dc(a3), d2
L062_00001FB2:
; H062+$00001FB2: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L062_00001FB6:
; H062+$00001FB6: b842  cmp.w d2, d4
        cmp.w d2, d4
L062_00001FB8:
; H062+$00001FB8: 6300001e  bls.w $1fd8
        bls.w H062+$1FD8
L062_00001FBC:
; H062+$00001FBC: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001FBE:
; H062+$00001FBE: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001FC2:
; H062+$00001FC2: 142b00dc  move.b $dc(a3), d2
        move.b $dc(a3), d2
L062_00001FC6:
; H062+$00001FC6: 956dfffa  sub.w d2, -$6(a5)
        sub.w d2, -$6(a5)
L062_00001FCA:
; H062+$00001FCA: 1f2dffe7  move.b -$19(a5), -(a7)
        move.b -$19(a5), -(a7)
L062_00001FCE:
; H062+$00001FCE: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L062_00001FD2:
; H062+$00001FD2: 4855  pea.l (a5)
        pea.l (a5)
L062_00001FD4:
; H062+$00001FD4: 6100fac8  bsr.w $1a9e
        bsr.w H062+$1A9E
L062_00001FD8:
; H062+$00001FD8: 522dffe7  addq.b #$1, -$19(a5)
        addq.b #$1, -$19(a5)
L062_00001FDC:
; H062+$00001FDC: 6400ff3c  bcc.w $1f1a
        bcc.w H062+$1F1A
L062_00001FE0:
; H062+$00001FE0: 7400  moveq #$0, d2
        moveq #0, d2
L062_00001FE2:
; H062+$00001FE2: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L062_00001FE6:
; H062+$00001FE6: 84edfff4  divu.w -$c(a5), d2
        divu.w -$c(a5), d2
L062_00001FEA:
; H062+$00001FEA: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L062_00001FEE:
; H062+$00001FEE: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00001FF2:
; H062+$00001FF2: 486b0064  pea.l $64(a3)
        pea.l $64(a3)
L062_00001FF6:
; H062+$00001FF6: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L062_00001FFA:
; H062+$00001FFA: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L062_00002000:
; H062+$00002000: 7400  moveq #$0, d2
        moveq #0, d2
L062_00002002:
; H062+$00002002: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002006:
; H062+$00002006: 142b0064  move.b $64(a3), d2
        move.b $64(a3), d2
L062_0000200A:
; H062+$0000200A: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L062_0000200E:
; H062+$0000200E: 63000020  bls.w $2030
        bls.w H062+$2030
L062_00002012:
; H062+$00002012: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002016:
; H062+$00002016: 486b01a8  pea.l $1a8(a3)
        pea.l $1a8(a3)
L062_0000201A:
; H062+$0000201A: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000201C:
; H062+$0000201C: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002020:
; H062+$00002020: 142b0064  move.b $64(a3), d2
        move.b $64(a3), d2
L062_00002024:
; H062+$00002024: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L062_00002028:
; H062+$00002028: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H029+$03E2 (sub_H029_000003E2)
L062_0000202A:
; H062+$0000202A: 4eb9000003e2  jsr $3e2.l
        jsr (H029+$3E2).l
L062_00002030:
; H062+$00002030: 7400  moveq #$0, d2
        moveq #0, d2
L062_00002032:
; H062+$00002032: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002036:
; H062+$00002036: 142b0064  move.b $64(a3), d2
        move.b $64(a3), d2
L062_0000203A:
; H062+$0000203A: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L062_0000203E:
; H062+$0000203E: 64000052  bcc.w $2092
        bcc.w H062+$2092
L062_00002042:
; H062+$00002042: 7400  moveq #$0, d2
        moveq #0, d2
L062_00002044:
; H062+$00002044: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002048:
; H062+$00002048: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L062_0000204C:
; H062+$0000204C: 7800  moveq #$0, d4
        moveq #0, d4
L062_0000204E:
; H062+$0000204E: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002052:
; H062+$00002052: 182b0064  move.b $64(a3), d4
        move.b $64(a3), d4
L062_00002056:
; H062+$00002056: 3c2dfffe  move.w -$2(a5), d6
        move.w -$2(a5), d6
L062_0000205A:
; H062+$0000205A: 9c44  sub.w d4, d6
        sub.w d4, d6
L062_0000205C:
; H062+$0000205C: b446  cmp.w d6, d2
        cmp.w d6, d2
L062_0000205E:
; H062+$0000205E: 6300002a  bls.w $208a
        bls.w H062+$208A
L062_00002062:
; H062+$00002062: 7400  moveq #$0, d2
        moveq #0, d2
L062_00002064:
; H062+$00002064: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002068:
; H062+$00002068: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L062_0000206C:
; H062+$0000206C: 7800  moveq #$0, d4
        moveq #0, d4
L062_0000206E:
; H062+$0000206E: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002072:
; H062+$00002072: 182b0064  move.b $64(a3), d4
        move.b $64(a3), d4
L062_00002076:
; H062+$00002076: 3c2dfffe  move.w -$2(a5), d6
        move.w -$2(a5), d6
L062_0000207A:
; H062+$0000207A: 9c44  sub.w d4, d6
        sub.w d4, d6
L062_0000207C:
; H062+$0000207C: 9446  sub.w d6, d2
        sub.w d6, d2
L062_0000207E:
; H062+$0000207E: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002082:
; H062+$00002082: 174201a8  move.b d2, $1a8(a3)
        move.b d2, $1a8(a3)
L062_00002086:
; H062+$00002086: 6000000a  bra.w $2092
        bra.w H062+$2092
L062_0000208A:
; H062+$0000208A: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_0000208E:
; H062+$0000208E: 422b01a8  clr.b $1a8(a3)
        clr.b $1a8(a3)
L062_00002092:
; H062+$00002092: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L062_00002096:
; H062+$00002096: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_0000209A:
; H062+$0000209A: 17420019  move.b d2, $19(a3)
        move.b d2, $19(a3)
L062_0000209E:
; H062+$0000209E: 7400  moveq #$0, d2
        moveq #0, d2
L062_000020A0:
; H062+$000020A0: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_000020A4:
; H062+$000020A4: 142b0019  move.b $19(a3), d2
        move.b $19(a3), d2
L062_000020A8:
; H062+$000020A8: 0c420014  cmpi.w #$14, d2
        cmpi.w #$14, d2
L062_000020AC:
; H062+$000020AC: 65000038  bcs.w $20e6
        bcs.w H062+$20E6
L062_000020B0:
; H062+$000020B0: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000020B4:
; H062+$000020B4: 3f3c003e  move.w #$3e, -(a7)
        move.w #$3e, -(a7)
L062_000020B8:
; H062+$000020B8: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_000020BC:
; H062+$000020BC: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_000020C2:
; H062+$000020C2: 1400  move.b d0, d2
        move.b d0, d2
L062_000020C4:
; H062+$000020C4: 4a02  tst.b d2
        tst.b d2
L062_000020C6:
; H062+$000020C6: 6600001a  bne.w $20e2
        bne.w H062+$20E2
L062_000020CA:
; H062+$000020CA: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000020CE:
; H062+$000020CE: 3f3c003e  move.w #$3e, -(a7)
        move.w #$3e, -(a7)
L062_000020D2:
; H062+$000020D2: 3f3c003c  move.w #$3c, -(a7)
        move.w #$3c, -(a7)
L062_000020D6:
; H062+$000020D6: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L062_000020DA:
; H062+$000020DA: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L062_000020DE:
; H062+$000020DE: 6100f512  bsr.w $15f2
        bsr.w H062+$15F2
L062_000020E2:
; H062+$000020E2: 60000010  bra.w $20f4
        bra.w H062+$20F4
L062_000020E6:
; H062+$000020E6: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_000020EA:
; H062+$000020EA: 3f3c003e  move.w #$3e, -(a7)
        move.w #$3e, -(a7)
L062_000020EE:
; H062+$000020EE: 42a7  clr.l -(a7)
        clr.l -(a7)
L062_000020F0:
; H062+$000020F0: 6100e360  bsr.w $452
        bsr.w H062+$452
L062_000020F4:
; H062+$000020F4: 4e75  rts 
        rts 
L062_000020F6:
; H062+$000020F6: 4e75  rts 
        rts 
L062_000020F8:
; H062+$000020F8: 4e75  rts 
        rts 
L062_000020FA:
; H062+$000020FA: 0c6d00fffff8  cmpi.w #$ff, -$8(a5)
        cmpi.w #$ff, -$8(a5)
L062_00002100:
; H062+$00002100: 67000012  beq.w $2114
        beq.w H062+$2114
L062_00002104:
; H062+$00002104: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L062_00002108:
; H062+$00002108: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_0000210C:
; H062+$0000210C: 17420017  move.b d2, $17(a3)
        move.b d2, $17(a3)
L062_00002110:
; H062+$00002110: 6000000e  bra.w $2120
        bra.w H062+$2120
L062_00002114:
; H062+$00002114: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L062_00002118:
; H062+$00002118: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_0000211C:
; H062+$0000211C: 17420017  move.b d2, $17(a3)
        move.b d2, $17(a3)
L062_00002120:
; H062+$00002120: 4e75  rts 
        rts 
L062_00002122:
; H062+$00002122: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L062_00002126:
; H062+$00002126: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L062_0000212A:
; H062+$0000212A: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
; -> H063+$0946 (sub_H063_00000946)
L062_0000212E:
; H062+$0000212E: 4eb900000946  jsr $946.l
        jsr (H063+$946).l
L062_00002134:
; H062+$00002134: 1400  move.b d0, d2
        move.b d0, d2
L062_00002136:
; H062+$00002136: 4a02  tst.b d2
        tst.b d2
L062_00002138:
; H062+$00002138: 67000010  beq.w $214a
        beq.w H062+$214A
L062_0000213C:
; H062+$0000213C: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000213E:
; H062+$0000213E: 266dffe8  movea.l -$18(a5), a3
        movea.l -$18(a5), a3
L062_00002142:
; H062+$00002142: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L062_00002146:
; H062+$00002146: d56dfff2  add.w d2, -$e(a5)
        add.w d2, -$e(a5)
L062_0000214A:
; H062+$0000214A: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L062_0000214E:
; H062+$0000214E: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L062_00002152:
; H062+$00002152: 1742001b  move.b d2, $1b(a3)
        move.b d2, $1b(a3)
L062_00002156:
; H062+$00002156: 4e75  rts 
        rts 
L062_00002158:
; H062+$00002158: 4e75  rts 
        rts 
; Preserved bytes H062+$0000215A..$00002168; code/data not fully classified.
        dc.w $FFFC,$FC20,$FF9A,$FF9C,$FF9E,$FD9A,$FFC6
L062_00002168:
; H062+$00002168: 47fafff2  lea.l $215c(pc), a3
        lea.l H062+$215C(pc), a3
L062_0000216C:
; H062+$0000216C: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L062_00002170:
; H062+$00002170: 6302  bls.b $2174
        bls.b H062+$2174
L062_00002172:
; H062+$00002172: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_00002174:
; H062+$00002174: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00002176:
; H062+$00002176: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$215C; indici 0..5, default -1.
L062_0000217A:
; H062+$0000217A: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_0000217E:
; H062+$0000217E: 4e5d  unlk a5
        unlk a5
L062_00002180:
; H062+$00002180: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00002182:
; H062+$00002182: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00002184:
; H062+$00002184: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L062_00002186:
; H062+$00002186: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00002188 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H045+$01D6, H063+$0112, H026+$01E0, H029+$0354.
;   - Richiama H045+$01D6.
;   - Richiama H063+$0112.
;   - Richiama H026+$01E0.
;   - Richiama H029+$0354.
;   - Richiama H063+$2760.
;   - Richiama H063+$2984.
;   - Richiama H063+$1DC2.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H027+$0964, H027+$19A8, H027+$1B6E, H027+$1F70, H027+$23DE, H027+$3FF0 e altri 4
; --------------------------------------------------------------------------
L062_00002188:
; H062+$00002188: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000218A:
; H062+$0000218A: 287adf76  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000218E:
; H062+$0000218E: 4e55ff5a  link.w a5, #$ff5a
        link.w a5, #$ff5a
L062_00002192:
; H062+$00002192: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L062_00002196:
; H062+$00002196: 13c200002474  move.b d2, $2474.l
        move.b d2, (H005+$2474).l
L062_0000219C:
; H062+$0000219C: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L062_000021A0:
; H062+$000021A0: 486d0012  pea.l $12(a5)
        pea.l $12(a5)
L062_000021A4:
; H062+$000021A4: 6100e698  bsr.w $83e
        bsr.w H062+$83E
L062_000021A8:
; H062+$000021A8: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L062_000021AC:
; H062+$000021AC: 67000050  beq.w $21fe
        beq.w H062+$21FE
L062_000021B0:
; H062+$000021B0: 7400  moveq #$0, d2
        moveq #0, d2
L062_000021B2:
; H062+$000021B2: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L062_000021B6:
; H062+$000021B6: 6000002a  bra.w $21e2
        bra.w H062+$21E2
L062_000021BA:
; H062+$000021BA: 423900002474  clr.b $2474.l
        clr.b (H005+$2474).l
L062_000021C0:
; H062+$000021C0: 4e75  rts 
        rts 
L062_000021C2:
; H062+$000021C2: 7400  moveq #$0, d2
        moveq #0, d2
L062_000021C4:
; H062+$000021C4: 143900002474  move.b $2474.l, d2
        move.b (H005+$2474).l, d2
L062_000021CA:
; H062+$000021CA: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L062_000021D0:
; H062+$000021D0: e24a  lsr.w #$1, d2
        lsr.w #$1, d2
L062_000021D2:
; H062+$000021D2: 13c200002474  move.b d2, $2474.l
        move.b d2, (H005+$2474).l
L062_000021D8:
; H062+$000021D8: 4e75  rts 
        rts 
L062_000021DA:
; H062+$000021DA: 4e75  rts 
        rts 
; Preserved bytes H062+$000021DC..$000021E2; code/data not fully classified.
        dc.w $FFFC,$FFDC,$FFE4
L062_000021E2:
; H062+$000021E2: 47fafffa  lea.l $21de(pc), a3
        lea.l H062+$21DE(pc), a3
L062_000021E6:
; H062+$000021E6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_000021E8:
; H062+$000021E8: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L062_000021EC:
; H062+$000021EC: 6302  bls.b $21f0
        bls.b H062+$21F0
L062_000021EE:
; H062+$000021EE: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_000021F0:
; H062+$000021F0: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_000021F2:
; H062+$000021F2: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$21DE; indici 0..1, default -1.
L062_000021F6:
; H062+$000021F6: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_000021FA:
; H062+$000021FA: 6000000e  bra.w $220a
        bra.w H062+$220A
L062_000021FE:
; H062+$000021FE: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L062_00002202:
; H062+$00002202: 486d0012  pea.l $12(a5)
        pea.l $12(a5)
L062_00002206:
; H062+$00002206: 6100e636  bsr.w $83e
        bsr.w H062+$83E
L062_0000220A:
; H062+$0000220A: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000220C:
; H062+$0000220C: 143900002474  move.b $2474.l, d2
        move.b (H005+$2474).l, d2
L062_00002212:
; H062+$00002212: 4a42  tst.w d2
        tst.w d2
L062_00002214:
; H062+$00002214: 6300031a  bls.w $2530
        bls.w H062+$2530
L062_00002218:
; H062+$00002218: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000221C:
; H062+$0000221C: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L062_00002220:
; H062+$00002220: 6700030e  beq.w $2530
        beq.w H062+$2530
L062_00002224:
; H062+$00002224: 7400  moveq #$0, d2
        moveq #0, d2
L062_00002226:
; H062+$00002226: 143900002474  move.b $2474.l, d2
        move.b (H005+$2474).l, d2
L062_0000222C:
; H062+$0000222C: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L062_00002230:
; H062+$00002230: 67000076  beq.w $22a8
        beq.w H062+$22A8
L062_00002234:
; H062+$00002234: 47ec0058  lea.l $58(a4), a3
        lea.l $58(a4), a3
L062_00002238:
; H062+$00002238: 45edffae  lea.l -$52(a5), a2
        lea.l -$52(a5), a2
L062_0000223C:
; H062+$0000223C: 7450  moveq #$50, d2
        moveq #80, d2
L062_0000223E:
; H062+$0000223E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_00002240:
; H062+$00002240: 57cafffc  dbeq d2, $223e
        dbeq d2, H062+$223E
L062_00002244:
; H062+$00002244: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_00002248:
; H062+$00002248: 486dff5c  pea.l -$a4(a5)
        pea.l -$a4(a5)
L062_0000224C:
; H062+$0000224C: 7400  moveq #$0, d2
        moveq #0, d2
L062_0000224E:
; H062+$0000224E: 143900002474  move.b $2474.l, d2
        move.b (H005+$2474).l, d2
L062_00002254:
; H062+$00002254: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L062_00002256:
; H062+$00002256: 4227  clr.b -(a7)
        clr.b -(a7)
L062_00002258:
; H062+$00002258: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_0000225C:
; H062+$0000225C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L062_00002260:
; H062+$00002260: 1f3c0020  move.b #$20, -(a7)
        move.b #$20, -(a7)
; -> H045+$01D6 (sub_H045_000001D6)
L062_00002264:
; H062+$00002264: 4eb9000001d6  jsr $1d6.l
        jsr (H045+$1D6).l
L062_0000226A:
; H062+$0000226A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_0000226E:
; H062+$0000226E: 486dff5c  pea.l -$a4(a5)
        pea.l -$a4(a5)
; -> H063+$0112 (sub_H063_00000112)
L062_00002272:
; H062+$00002272: 4eb900000112  jsr $112.l
        jsr (H063+$112).l
L062_00002278:
; H062+$00002278: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_0000227C:
; H062+$0000227C: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_00002280:
; H062+$00002280: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_00002284:
; H062+$00002284: 486dff5c  pea.l -$a4(a5)
        pea.l -$a4(a5)
; -> H026+$01E0 (sub_H026_000001E0)
L062_00002288:
; H062+$00002288: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_0000228E:
; H062+$0000228E: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_00002292:
; H062+$00002292: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_00002296:
; H062+$00002296: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L062_0000229A:
; H062+$0000229A: 486c005f  pea.l $5f(a4)
        pea.l $5f(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L062_0000229E:
; H062+$0000229E: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_000022A4:
; H062+$000022A4: 60000012  bra.w $22b8
        bra.w H062+$22B8
L062_000022A8:
; H062+$000022A8: 47ec0072  lea.l $72(a4), a3
        lea.l $72(a4), a3
L062_000022AC:
; H062+$000022AC: 45edffae  lea.l -$52(a5), a2
        lea.l -$52(a5), a2
L062_000022B0:
; H062+$000022B0: 7450  moveq #$50, d2
        moveq #80, d2
L062_000022B2:
; H062+$000022B2: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_000022B4:
; H062+$000022B4: 57cafffc  dbeq d2, $22b2
        dbeq d2, H062+$22B2
L062_000022B8:
; H062+$000022B8: 1f3900002473  move.b $2473.l, -(a7)
        move.b (H005+$2473).l, -(a7)
L062_000022BE:
; H062+$000022BE: 3f3c00f7  move.w #$f7, -(a7)
        move.w #$f7, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L062_000022C2:
; H062+$000022C2: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L062_000022C8:
; H062+$000022C8: 1400  move.b d0, d2
        move.b d0, d2
L062_000022CA:
; H062+$000022CA: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L062_000022CE:
; H062+$000022CE: 60000086  bra.w $2356
        bra.w H062+$2356
L062_000022D2:
; H062+$000022D2: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_000022D6:
; H062+$000022D6: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_000022DA:
; H062+$000022DA: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L062_000022DE:
; H062+$000022DE: 486c008b  pea.l $8b(a4)
        pea.l $8b(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L062_000022E2:
; H062+$000022E2: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_000022E8:
; H062+$000022E8: 4e75  rts 
        rts 
L062_000022EA:
; H062+$000022EA: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_000022EE:
; H062+$000022EE: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_000022F2:
; H062+$000022F2: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L062_000022F6:
; H062+$000022F6: 486c0095  pea.l $95(a4)
        pea.l $95(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L062_000022FA:
; H062+$000022FA: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_00002300:
; H062+$00002300: 4e75  rts 
        rts 
L062_00002302:
; H062+$00002302: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_00002306:
; H062+$00002306: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_0000230A:
; H062+$0000230A: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L062_0000230E:
; H062+$0000230E: 486c009f  pea.l $9f(a4)
        pea.l $9f(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L062_00002312:
; H062+$00002312: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_00002318:
; H062+$00002318: 4e75  rts 
        rts 
L062_0000231A:
; H062+$0000231A: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_0000231E:
; H062+$0000231E: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_00002322:
; H062+$00002322: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L062_00002326:
; H062+$00002326: 486c00b0  pea.l $b0(a4)
        pea.l $b0(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L062_0000232A:
; H062+$0000232A: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_00002330:
; H062+$00002330: 4e75  rts 
        rts 
L062_00002332:
; H062+$00002332: 4e75  rts 
        rts 
; Preserved bytes H062+$00002334..$00002356; code/data not fully classified.
        dc.w $FFFC,$FF9C,$FFB4,$FFFC,$FFCC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFE4
L062_00002356:
; H062+$00002356: 47faffde  lea.l $2336(pc), a3
        lea.l H062+$2336(pc), a3
L062_0000235A:
; H062+$0000235A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_0000235C:
; H062+$0000235C: 0c42000f  cmpi.w #$f, d2
        cmpi.w #$f, d2
L062_00002360:
; H062+$00002360: 6302  bls.b $2364
        bls.b H062+$2364
L062_00002362:
; H062+$00002362: 74ff  moveq #$ff, d2
        moveq #-1, d2
L062_00002364:
; H062+$00002364: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00002366:
; H062+$00002366: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H062+$2336; indici 0..15, default -1.
L062_0000236A:
; H062+$0000236A: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L062_0000236E:
; H062+$0000236E: 1f3900002473  move.b $2473.l, -(a7)
        move.b (H005+$2473).l, -(a7)
L062_00002374:
; H062+$00002374: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L062_00002378:
; H062+$00002378: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L062_0000237E:
; H062+$0000237E: 1400  move.b d0, d2
        move.b d0, d2
L062_00002380:
; H062+$00002380: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L062_00002384:
; H062+$00002384: 7800  moveq #$0, d4
        moveq #0, d4
L062_00002386:
; H062+$00002386: 183900002473  move.b $2473.l, d4
        move.b (H005+$2473).l, d4
L062_0000238C:
; H062+$0000238C: b444  cmp.w d4, d2
        cmp.w d4, d2
L062_0000238E:
; H062+$0000238E: 66000018  bne.w $23a8
        bne.w H062+$23A8
L062_00002392:
; H062+$00002392: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_00002396:
; H062+$00002396: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_0000239A:
; H062+$0000239A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_0000239E:
; H062+$0000239E: 486c00ba  pea.l $ba(a4)
        pea.l $ba(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L062_000023A2:
; H062+$000023A2: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_000023A8:
; H062+$000023A8: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_000023AC:
; H062+$000023AC: 4227  clr.b -(a7)
        clr.b -(a7)
L062_000023AE:
; H062+$000023AE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_000023B2:
; H062+$000023B2: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; -> H063+$2760 (sub_H063_00002760)
L062_000023B6:
; H062+$000023B6: 4eb900002760  jsr $2760.l
        jsr (H063+$2760).l
L062_000023BC:
; H062+$000023BC: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_000023C0:
; H062+$000023C0: 7400  moveq #$0, d2
        moveq #0, d2
L062_000023C2:
; H062+$000023C2: 143900002474  move.b $2474.l, d2
        move.b (H005+$2474).l, d2
L062_000023C8:
; H062+$000023C8: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H063+$2984 (sub_H063_00002984)
L062_000023CA:
; H062+$000023CA: 4eb900002984  jsr $2984.l
        jsr (H063+$2984).l
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L062_000023D0:
; H062+$000023D0: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L062_000023D8:
; H062+$000023D8: 66000060  bne.w $243a
        bne.w H062+$243A
L062_000023DC:
; H062+$000023DC: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L062_000023E0:
; H062+$000023E0: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L062_000023E4:
; H062+$000023E4: 422b0001  clr.b $1(a3)
        clr.b $1(a3)
L062_000023E8:
; H062+$000023E8: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L062_000023EC:
; H062+$000023EC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L062_000023F0:
; H062+$000023F0: 7400  moveq #$0, d2
        moveq #0, d2
L062_000023F2:
; H062+$000023F2: 1413  move.b (a3), d2
        move.b (a3), d2
L062_000023F4:
; H062+$000023F4: 4a42  tst.w d2
        tst.w d2
L062_000023F6:
; H062+$000023F6: 63000042  bls.w $243a
        bls.w H062+$243A
L062_000023FA:
; H062+$000023FA: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_000023FE:
; H062+$000023FE: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L062_00002402:
; H062+$00002402: 486c00c5  pea.l $c5(a4)
        pea.l $c5(a4)
L062_00002406:
; H062+$00002406: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L062_0000240A:
; H062+$0000240A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L062_0000240E:
; H062+$0000240E: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L062_00002414:
; H062+$00002414: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_00002418:
; H062+$00002418: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L062_0000241C:
; H062+$0000241C: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L062_00002420:
; H062+$00002420: 7400  moveq #$0, d2
        moveq #0, d2
L062_00002422:
; H062+$00002422: 1413  move.b (a3), d2
        move.b (a3), d2
L062_00002424:
; H062+$00002424: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H063+$1B90 (sub_H063_00001B90)
L062_00002426:
; H062+$00002426: 4eb900001b90  jsr $1b90.l
        jsr (H063+$1B90).l
L062_0000242C:
; H062+$0000242C: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; -> H063+$2F12 (sub_H063_00002F12)
L062_00002430:
; H062+$00002430: 4eb900002f12  jsr $2f12.l
        jsr (H063+$2F12).l
L062_00002436:
; H062+$00002436: 1b40ff5b  move.b d0, -$a5(a5)
        move.b d0, -$a5(a5)
L062_0000243A:
; H062+$0000243A: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000243E:
; H062+$0000243E: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L062_00002442:
; H062+$00002442: 660000e6  bne.w $252a
        bne.w H062+$252A
L062_00002446:
; H062+$00002446: 47ec00d2  lea.l $d2(a4), a3
        lea.l $d2(a4), a3
L062_0000244A:
; H062+$0000244A: 45edffae  lea.l -$52(a5), a2
        lea.l -$52(a5), a2
L062_0000244E:
; H062+$0000244E: 7450  moveq #$50, d2
        moveq #80, d2
L062_00002450:
; H062+$00002450: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_00002452:
; H062+$00002452: 57cafffc  dbeq d2, $2450
        dbeq d2, H062+$2450
L062_00002456:
; H062+$00002456: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000245A:
; H062+$0000245A: 0c2b00050197  cmpi.b #$5, $197(a3)
        cmpi.b #$5, $197(a3)
L062_00002460:
; H062+$00002460: 66000018  bne.w $247a
        bne.w H062+$247A
L062_00002464:
; H062+$00002464: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_00002468:
; H062+$00002468: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_0000246C:
; H062+$0000246C: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L062_00002470:
; H062+$00002470: 486c00dc  pea.l $dc(a4)
        pea.l $dc(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L062_00002474:
; H062+$00002474: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L062_0000247A:
; H062+$0000247A: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000247E:
; H062+$0000247E: 0c2b00060197  cmpi.b #$6, $197(a3)
        cmpi.b #$6, $197(a3)
L062_00002484:
; H062+$00002484: 6700001e  beq.w $24a4
        beq.w H062+$24A4
L062_00002488:
; H062+$00002488: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000248C:
; H062+$0000248C: 0c2b00080197  cmpi.b #$8, $197(a3)
        cmpi.b #$8, $197(a3)
L062_00002492:
; H062+$00002492: 67000010  beq.w $24a4
        beq.w H062+$24A4
L062_00002496:
; H062+$00002496: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000249A:
; H062+$0000249A: 0c2b00070197  cmpi.b #$7, $197(a3)
        cmpi.b #$7, $197(a3)
L062_000024A0:
; H062+$000024A0: 66000012  bne.w $24b4
        bne.w H062+$24B4
L062_000024A4:
; H062+$000024A4: 47ec00eb  lea.l $eb(a4), a3
        lea.l $eb(a4), a3
L062_000024A8:
; H062+$000024A8: 45edffae  lea.l -$52(a5), a2
        lea.l -$52(a5), a2
L062_000024AC:
; H062+$000024AC: 7450  moveq #$50, d2
        moveq #80, d2
L062_000024AE:
; H062+$000024AE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_000024B0:
; H062+$000024B0: 57cafffc  dbeq d2, $24ae
        dbeq d2, H062+$24AE
L062_000024B4:
; H062+$000024B4: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_000024B8:
; H062+$000024B8: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_000024BC:
; H062+$000024BC: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
L062_000024C0:
; H062+$000024C0: 34390000334c  move.w $334c.l, d2
        move.w (H005+$334C).l, d2
L062_000024C6:
; H062+$000024C6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_000024C8:
; H062+$000024C8: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L062_000024CA:
; H062+$000024CA: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L062_000024CC:
; H062+$000024CC: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L062_000024D2:
; H062+$000024D2: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L062_000024DA:
; H062+$000024DA: 6700000c  beq.w $24e8
        beq.w H062+$24E8
; -> H030+$0B4A (sub_H030_00000B4A)
L062_000024DE:
; H062+$000024DE: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L062_000024E4:
; H062+$000024E4: 60000044  bra.w $252a
        bra.w H062+$252A
L062_000024E8:
; H062+$000024E8: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L062_000024EC:
; H062+$000024EC: 6100f2d2  bsr.w $17c0
        bsr.w H062+$17C0
L062_000024F0:
; H062+$000024F0: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L062_000024F4:
; H062+$000024F4: 486d0012  pea.l $12(a5)
        pea.l $12(a5)
L062_000024F8:
; H062+$000024F8: 6100e344  bsr.w $83e
        bsr.w H062+$83E
L062_000024FC:
; H062+$000024FC: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_00002500:
; H062+$00002500: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L062_00002504:
; H062+$00002504: 6600001e  bne.w $2524
        bne.w H062+$2524
L062_00002508:
; H062+$00002508: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L062_0000250C:
; H062+$0000250C: 0c2b000a0197  cmpi.b #$a, $197(a3)
        cmpi.b #$a, $197(a3)
L062_00002512:
; H062+$00002512: 67000010  beq.w $2524
        beq.w H062+$2524
L062_00002516:
; H062+$00002516: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
; -> H048+$12F4 (sub_H048_000012F4)
L062_0000251A:
; H062+$0000251A: 4eb9000012f4  jsr $12f4.l
        jsr (H048+$12F4).l
L062_00002520:
; H062+$00002520: 60000008  bra.w $252a
        bra.w H062+$252A
; -> H030+$0B4A (sub_H030_00000B4A)
L062_00002524:
; H062+$00002524: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
; -> H063+$1EE8 (sub_H063_00001EE8)
L062_0000252A:
; H062+$0000252A: 4eb900001ee8  jsr $1ee8.l
        jsr (H063+$1EE8).l
L062_00002530:
; H062+$00002530: 4e5d  unlk a5
        unlk a5
L062_00002532:
; H062+$00002532: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_00002534:
; H062+$00002534: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_00002536:
; H062+$00002536: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L062_0000253A:
; H062+$0000253A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_0000253C [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; opera su H005+$3DE3 (contesto nativo, 5 nel combattimento).
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H027+$2112, H085+$3456, H085+$3E1E, H085+$1D1C, H085+$32FE, H057+$2E4A e altri 5
; --------------------------------------------------------------------------
L062_0000253C:
; H062+$0000253C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_0000253E:
; H062+$0000253E: 287adbc2  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00002542:
; H062+$00002542: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L062_00002546:
; H062+$00002546: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L062_0000254A:
; H062+$0000254A: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_0000254E:
; H062+$0000254E: 4a2b0197  tst.b $197(a3)
        tst.b $197(a3)
L062_00002552:
; H062+$00002552: 6700002c  beq.w $2580
        beq.w H062+$2580
L062_00002556:
; H062+$00002556: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_0000255A:
; H062+$0000255A: 0c2b00010197  cmpi.b #$1, $197(a3)
        cmpi.b #$1, $197(a3)
L062_00002560:
; H062+$00002560: 6700001e  beq.w $2580
        beq.w H062+$2580
L062_00002564:
; H062+$00002564: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00002568:
; H062+$00002568: 0c2b00040197  cmpi.b #$4, $197(a3)
        cmpi.b #$4, $197(a3)
L062_0000256E:
; H062+$0000256E: 67000010  beq.w $2580
        beq.w H062+$2580
L062_00002572:
; H062+$00002572: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00002576:
; H062+$00002576: 0c2b00050197  cmpi.b #$5, $197(a3)
        cmpi.b #$5, $197(a3)
L062_0000257C:
; H062+$0000257C: 660000c0  bne.w $263e
        bne.w H062+$263E
L062_00002580:
; H062+$00002580: 7400  moveq #$0, d2
        moveq #0, d2
L062_00002582:
; H062+$00002582: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00002586:
; H062+$00002586: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L062_0000258A:
; H062+$0000258A: 7800  moveq #$0, d4
        moveq #0, d4
L062_0000258C:
; H062+$0000258C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00002590:
; H062+$00002590: 182b0064  move.b $64(a3), d4
        move.b $64(a3), d4
L062_00002594:
; H062+$00002594: b444  cmp.w d4, d2
        cmp.w d4, d2
L062_00002596:
; H062+$00002596: 6400000a  bcc.w $25a2
        bcc.w H062+$25A2
L062_0000259A:
; H062+$0000259A: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L062_0000259E:
; H062+$0000259E: 6600000a  bne.w $25aa
        bne.w H062+$25AA
L062_000025A2:
; H062+$000025A2: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L062_000025A6:
; H062+$000025A6: 66000096  bne.w $263e
        bne.w H062+$263E
L062_000025AA:
; H062+$000025AA: 7400  moveq #$0, d2
        moveq #0, d2
L062_000025AC:
; H062+$000025AC: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000025B0:
; H062+$000025B0: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L062_000025B4:
; H062+$000025B4: d46d000e  add.w $e(a5), d2
        add.w $e(a5), d2
L062_000025B8:
; H062+$000025B8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000025BC:
; H062+$000025BC: 174201a8  move.b d2, $1a8(a3)
        move.b d2, $1a8(a3)
L062_000025C0:
; H062+$000025C0: 7400  moveq #$0, d2
        moveq #0, d2
L062_000025C2:
; H062+$000025C2: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000025C6:
; H062+$000025C6: 142b01a8  move.b $1a8(a3), d2
        move.b $1a8(a3), d2
L062_000025CA:
; H062+$000025CA: 7800  moveq #$0, d4
        moveq #0, d4
L062_000025CC:
; H062+$000025CC: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000025D0:
; H062+$000025D0: 182b0064  move.b $64(a3), d4
        move.b $64(a3), d4
L062_000025D4:
; H062+$000025D4: b444  cmp.w d4, d2
        cmp.w d4, d2
L062_000025D6:
; H062+$000025D6: 63000010  bls.w $25e8
        bls.w H062+$25E8
L062_000025DA:
; H062+$000025DA: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000025DE:
; H062+$000025DE: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L062_000025E2:
; H062+$000025E2: 156b006401a8  move.b $64(a3), $1a8(a2)
        move.b $64(a3), $1a8(a2)
L062_000025E8:
; H062+$000025E8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000025EC:
; H062+$000025EC: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L062_000025F0:
; H062+$000025F0: 66000046  bne.w $2638
        bne.w H062+$2638
L062_000025F4:
; H062+$000025F4: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_000025F8:
; H062+$000025F8: 0c2b00050197  cmpi.b #$5, $197(a3)
        cmpi.b #$5, $197(a3)
L062_000025FE:
; H062+$000025FE: 6600000c  bne.w $260c
        bne.w H062+$260C
L062_00002602:
; H062+$00002602: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00002606:
; H062+$00002606: 177c00040197  move.b #$4, $197(a3)
        move.b #$4, $197(a3)
L062_0000260C:
; H062+$0000260C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00002610:
; H062+$00002610: 0c2b00040197  cmpi.b #$4, $197(a3)
        cmpi.b #$4, $197(a3)
L062_00002616:
; H062+$00002616: 66000020  bne.w $2638
        bne.w H062+$2638
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L062_0000261A:
; H062+$0000261A: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L062_00002622:
; H062+$00002622: 67000014  beq.w $2638
        beq.w H062+$2638
L062_00002626:
; H062+$00002626: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_0000262A:
; H062+$0000262A: 422b0197  clr.b $197(a3)
        clr.b $197(a3)
L062_0000262E:
; H062+$0000262E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L062_00002632:
; H062+$00002632: 177c00010198  move.b #$1, $198(a3)
        move.b #$1, $198(a3)
L062_00002638:
; H062+$00002638: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L062_0000263E:
; H062+$0000263E: 102dffff  move.b -$1(a5), d0
        move.b -$1(a5), d0
L062_00002642:
; H062+$00002642: 60000002  bra.w $2646
        bra.w H062+$2646
L062_00002646:
; H062+$00002646: 4e5d  unlk a5
        unlk a5
L062_00002648:
; H062+$00002648: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_0000264A:
; H062+$0000264A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000264C:
; H062+$0000264C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L062_0000264E:
; H062+$0000264E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00002650 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H048+$0F88, H048+$0FBA, H048+$16D4, H048+$195E.
;   - Richiama H048+$0F88.
;   - Richiama H048+$0FBA.
;   - Richiama H048+$16D4.
;   - Richiama H048+$195E.
;   - Richiama H063+$2760.
;   - Richiama H063+$2B7C.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H027+$084A, H027+$100E, H027+$2F68
; --------------------------------------------------------------------------
L062_00002650:
; H062+$00002650: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00002652:
; H062+$00002652: 287adaae  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_00002656:
; H062+$00002656: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L062_0000265A:
; H062+$0000265A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L062_0000265E:
; H062+$0000265E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_00002660:
; H062+$00002660: 08020000  btst.b #$0, d2
        btst #$0, d2
L062_00002664:
; H062+$00002664: 6702  beq.b $2668
        beq.b H062+$2668
L062_00002666:
; H062+$00002666: 5242  addq.w #$1, d2
        addq.w #$1, d2
L062_00002668:
; H062+$00002668: 9ec2  suba.w d2, a7
        suba.w d2, a7
L062_0000266A:
; H062+$0000266A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L062_0000266E:
; H062+$0000266E: 2b4f000c  move.l a7, $c(a5)
        move.l a7, $c(a5)
L062_00002672:
; H062+$00002672: 244f  movea.l a7, a2
        movea.l a7, a2
L062_00002674:
; H062+$00002674: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00002676:
; H062+$00002676: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L062_00002678:
; H062+$00002678: 51cafffc  dbra d2, $2676
        dbra d2, H062+$2676
L062_0000267C:
; H062+$0000267C: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_00002680:
; H062+$00002680: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L062_00002684:
; H062+$00002684: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L062_0000268A:
; H062+$0000268A: 1f00  move.b d0, -(a7)
        move.b d0, -(a7)
L062_0000268C:
; H062+$0000268C: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L062_00002690:
; H062+$00002690: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L062_00002696:
; H062+$00002696: 1f00  move.b d0, -(a7)
        move.b d0, -(a7)
L062_00002698:
; H062+$00002698: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H048+$16D4 (sub_H048_000016D4)
L062_0000269C:
; H062+$0000269C: 4eb9000016d4  jsr $16d4.l
        jsr (H048+$16D4).l
L062_000026A2:
; H062+$000026A2: 1400  move.b d0, d2
        move.b d0, d2
L062_000026A4:
; H062+$000026A4: 4a02  tst.b d2
        tst.b d2
L062_000026A6:
; H062+$000026A6: 6700007a  beq.w $2722
        beq.w H062+$2722
L062_000026AA:
; H062+$000026AA: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000026AE:
; H062+$000026AE: 422b0197  clr.b $197(a3)
        clr.b $197(a3)
L062_000026B2:
; H062+$000026B2: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000026B6:
; H062+$000026B6: 177c00010198  move.b #$1, $198(a3)
        move.b #$1, $198(a3)
L062_000026BC:
; H062+$000026BC: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L062_000026C0:
; H062+$000026C0: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L062_000026C4:
; H062+$000026C4: 174201a8  move.b d2, $1a8(a3)
        move.b d2, $1a8(a3)
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L062_000026C8:
; H062+$000026C8: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L062_000026D0:
; H062+$000026D0: 6600002a  bne.w $26fc
        bne.w H062+$26FC
L062_000026D4:
; H062+$000026D4: 1b79000024c6ffff  move.b $24c6.l, -$1(a5)
        move.b (H005+$24C6).l, -$1(a5)
L062_000026DC:
; H062+$000026DC: 13fc0001000024c6  move.b #$1, $24c6.l
        move.b #$1, (H005+$24C6).l
L062_000026E4:
; H062+$000026E4: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_000026E8:
; H062+$000026E8: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L062_000026EC:
; H062+$000026EC: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H048+$195E (sub_H048_0000195E)
L062_000026EE:
; H062+$000026EE: 4eb90000195e  jsr $195e.l
        jsr (H048+$195E).l
L062_000026F4:
; H062+$000026F4: 13edffff000024c6  move.b -$1(a5), $24c6.l
        move.b -$1(a5), (H005+$24C6).l
L062_000026FC:
; H062+$000026FC: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L062_00002700:
; H062+$00002700: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L062_00002704:
; H062+$00002704: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L062_00002708:
; H062+$00002708: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H063+$2760 (sub_H063_00002760)
L062_0000270C:
; H062+$0000270C: 4eb900002760  jsr $2760.l
        jsr (H063+$2760).l
; -> H063+$2B7C (sub_H063_00002B7C)
L062_00002712:
; H062+$00002712: 4eb900002b7c  jsr $2b7c.l
        jsr (H063+$2B7C).l
L062_00002718:
; H062+$00002718: 7001  moveq #$1, d0
        moveq #1, d0
L062_0000271A:
; H062+$0000271A: 6000000c  bra.w $2728
        bra.w H062+$2728
; Preserved bytes H062+$0000271E..$00002722; code/data not fully classified.
        dc.w $6000,$0008
L062_00002722:
; H062+$00002722: 7000  moveq #$0, d0
        moveq #0, d0
L062_00002724:
; H062+$00002724: 60000002  bra.w $2728
        bra.w H062+$2728
L062_00002728:
; H062+$00002728: 4e5d  unlk a5
        unlk a5
L062_0000272A:
; H062+$0000272A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_0000272C:
; H062+$0000272C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L062_0000272E:
; H062+$0000272E: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L062_00002732:
; H062+$00002732: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H062_00002734 [parziale]
; Scopo: Routine del modulo helper ed effetti condivisi del gioco; richiama H063+$1DC2, H048+$0F88, H048+$0FBA, H048+$110C.
;   - Richiama H063+$1DC2.
;   - Richiama H048+$0F88.
;   - Richiama H048+$0FBA.
;   - Richiama H048+$110C.
;   - Richiama H077+$08AC.
;   - Richiama H048+$12F4.
;   - Richiama H029+$0312.
; Chiamanti diretti: H027+$200C, H059+$1858, H096+$2028
; --------------------------------------------------------------------------
L062_00002734:
; H062+$00002734: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L062_00002736:
; H062+$00002736: 287ad9ca  movea.l $102(pc), a4
        movea.l H062+$102(pc), a4
L062_0000273A:
; H062+$0000273A: 4e55ffe6  link.w a5, #$ffe6
        link.w a5, #$ffe6
L062_0000273E:
; H062+$0000273E: 423900002473  clr.b $2473.l
        clr.b (H005+$2473).l
L062_00002744:
; H062+$00002744: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L062_0000274A:
; H062+$0000274A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L062_0000274E:
; H062+$0000274E: b47900000014  cmp.w $14.l, d2
        cmp.w (H005+$14).l, d2
L062_00002754:
; H062+$00002754: 62000178  bhi.w $28ce
        bhi.w H062+$28CE
L062_00002758:
; H062+$00002758: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L062_0000275C:
; H062+$0000275C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_0000275E:
; H062+$0000275E: e542  asl.w #$2, d2
        asl.w #$2, d2
L062_00002760:
; H062+$00002760: 47f900000016  lea.l $16.l, a3
        lea.l (H005+$16).l, a3
L062_00002766:
; H062+$00002766: 2b732000fff8  move.l (a3, d2.w), -$8(a5)
        move.l (a3, d2.w), -$8(a5)
L062_0000276C:
; H062+$0000276C: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L062_00002770:
; H062+$00002770: 67000138  beq.w $28aa
        beq.w H062+$28AA
L062_00002774:
; H062+$00002774: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L062_00002778:
; H062+$00002778: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L062_0000277C:
; H062+$0000277C: 486c00f5  pea.l $f5(a4)
        pea.l $f5(a4)
L062_00002780:
; H062+$00002780: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L062_00002784:
; H062+$00002784: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H063+$1DC2 (sub_H063_00001DC2)
L062_00002788:
; H062+$00002788: 4eb900001dc2  jsr $1dc2.l
        jsr (H063+$1DC2).l
L062_0000278E:
; H062+$0000278E: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H048+$0F88 (sub_H048_00000F88)
L062_00002792:
; H062+$00002792: 4eb900000f88  jsr $f88.l
        jsr (H048+$F88).l
L062_00002798:
; H062+$00002798: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_0000279A:
; H062+$0000279A: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H048+$0FBA (sub_H048_00000FBA)
L062_0000279E:
; H062+$0000279E: 4eb900000fba  jsr $fba.l
        jsr (H048+$FBA).l
L062_000027A4:
; H062+$000027A4: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_000027A6:
; H062+$000027A6: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_000027AA:
; H062+$000027AA: 3f3c00ff  move.w #$ff, -(a7)
        move.w #$ff, -(a7)
L062_000027AE:
; H062+$000027AE: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H048+$110C (sub_H048_0000110C)
L062_000027B2:
; H062+$000027B2: 4eb90000110c  jsr $110c.l
        jsr (H048+$110C).l
L062_000027B8:
; H062+$000027B8: 1400  move.b d0, d2
        move.b d0, d2
L062_000027BA:
; H062+$000027BA: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L062_000027BE:
; H062+$000027BE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L062_000027C0:
; H062+$000027C0: 2f3900002ade  move.l $2ade.l, -(a7)
        move.l (H005+$2ADE).l, -(a7)
; -> H077+$08AC (sub_H077_000008AC)
L062_000027C6:
; H062+$000027C6: 4eb9000008ac  jsr $8ac.l
        jsr (H077+$8AC).l
L062_000027CC:
; H062+$000027CC: 7400  moveq #$0, d2
        moveq #0, d2
L062_000027CE:
; H062+$000027CE: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L062_000027D4:
; H062+$000027D4: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L062_000027D8:
; H062+$000027D8: 630000d0  bls.w $28aa
        bls.w H062+$28AA
L062_000027DC:
; H062+$000027DC: 7400  moveq #$0, d2
        moveq #0, d2
L062_000027DE:
; H062+$000027DE: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L062_000027E4:
; H062+$000027E4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_000027E6:
; H062+$000027E6: 3b42ffe6  move.w d2, -$1a(a5)
        move.w d2, -$1a(a5)
L062_000027EA:
; H062+$000027EA: 3b7c0002fffc  move.w #$2, -$4(a5)
        move.w #$2, -$4(a5)
L062_000027F0:
; H062+$000027F0: 7400  moveq #$0, d2
        moveq #0, d2
L062_000027F2:
; H062+$000027F2: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L062_000027F8:
; H062+$000027F8: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L062_000027FA:
; H062+$000027FA: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L062_000027FE:
; H062+$000027FE: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L062_00002800:
; H062+$00002800: 6200002e  bhi.w $2830
        bhi.w H062+$2830
L062_00002804:
; H062+$00002804: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L062_00002808:
; H062+$00002808: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_0000280A:
; H062+$0000280A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_0000280C:
; H062+$0000280C: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_0000280E:
; H062+$0000280E: 47edffe8  lea.l -$18(a5), a3
        lea.l -$18(a5), a3
L062_00002812:
; H062+$00002812: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L062_00002816:
; H062+$00002816: 5344  subq.w #$1, d4
        subq.w #$1, d4
L062_00002818:
; H062+$00002818: e544  asl.w #$2, d4
        asl.w #$2, d4
L062_0000281A:
; H062+$0000281A: 45f900002a3e  lea.l $2a3e.l, a2
        lea.l (H005+$2A3E).l, a2
L062_00002820:
; H062+$00002820: 7c00  moveq #$0, d6
        moveq #0, d6
L062_00002822:
; H062+$00002822: 1c324000  move.b (a2, d4.w), d6
        move.b (a2, d4.w), d6
L062_00002826:
; H062+$00002826: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L062_0000282A:
; H062+$0000282A: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L062_0000282E:
; H062+$0000282E: 64ca  bcc.b $27fa
        bcc.b H062+$27FA
L062_00002830:
; H062+$00002830: 548f  addq.l #$2, a7
        addq.l #$2, a7
L062_00002832:
; H062+$00002832: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L062_00002838:
; H062+$00002838: 3f2dffe6  move.w -$1a(a5), -(a7)
        move.w -$1a(a5), -(a7)
L062_0000283C:
; H062+$0000283C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L062_00002840:
; H062+$00002840: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L062_00002842:
; H062+$00002842: 62000064  bhi.w $28a8
        bhi.w H062+$28A8
L062_00002846:
; H062+$00002846: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L062_0000284A:
; H062+$0000284A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_0000284C:
; H062+$0000284C: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_0000284E:
; H062+$0000284E: 47edffe8  lea.l -$18(a5), a3
        lea.l -$18(a5), a3
L062_00002852:
; H062+$00002852: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L062_00002856:
; H062+$00002856: 5344  subq.w #$1, d4
        subq.w #$1, d4
L062_00002858:
; H062+$00002858: e544  asl.w #$2, d4
        asl.w #$2, d4
L062_0000285A:
; H062+$0000285A: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L062_00002860:
; H062+$00002860: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L062_00002864:
; H062+$00002864: 0c2b000a0197  cmpi.b #$a, $197(a3)
        cmpi.b #$a, $197(a3)
L062_0000286A:
; H062+$0000286A: 67000036  beq.w $28a2
        beq.w H062+$28A2
L062_0000286E:
; H062+$0000286E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L062_00002872:
; H062+$00002872: 5342  subq.w #$1, d2
        subq.w #$1, d2
L062_00002874:
; H062+$00002874: e342  asl.w #$1, d2
        asl.w #$1, d2
L062_00002876:
; H062+$00002876: 47edffe8  lea.l -$18(a5), a3
        lea.l -$18(a5), a3
L062_0000287A:
; H062+$0000287A: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L062_0000287E:
; H062+$0000287E: 5344  subq.w #$1, d4
        subq.w #$1, d4
L062_00002880:
; H062+$00002880: e544  asl.w #$2, d4
        asl.w #$2, d4
L062_00002882:
; H062+$00002882: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L062_00002888:
; H062+$00002888: 2f334000  move.l (a3, d4.w), -(a7)
        move.l (a3, d4.w), -(a7)
L062_0000288C:
; H062+$0000288C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L062_00002890:
; H062+$00002890: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L062_00002894:
; H062+$00002894: 6100ed30  bsr.w $15c6
        bsr.w H062+$15C6
L062_00002898:
; H062+$00002898: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L062_0000289A:
; H062+$0000289A: 4227  clr.b -(a7)
        clr.b -(a7)
L062_0000289C:
; H062+$0000289C: 4227  clr.b -(a7)
        clr.b -(a7)
L062_0000289E:
; H062+$0000289E: 6100f8e8  bsr.w $2188
        bsr.w H062+$2188
L062_000028A2:
; H062+$000028A2: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L062_000028A6:
; H062+$000028A6: 6494  bcc.b $283c
        bcc.b H062+$283C
L062_000028A8:
; H062+$000028A8: 548f  addq.l #$2, a7
        addq.l #$2, a7
L062_000028AA:
; H062+$000028AA: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_000028AE:
; H062+$000028AE: 422b0198  clr.b $198(a3)
        clr.b $198(a3)
L062_000028B2:
; H062+$000028B2: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L062_000028B6:
; H062+$000028B6: 177c00060197  move.b #$6, $197(a3)
        move.b #$6, $197(a3)
L062_000028BC:
; H062+$000028BC: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H048+$12F4 (sub_H048_000012F4)
L062_000028C0:
; H062+$000028C0: 4eb9000012f4  jsr $12f4.l
        jsr (H048+$12F4).l
L062_000028C6:
; H062+$000028C6: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L062_000028CA:
; H062+$000028CA: 6000fe7e  bra.w $274a
        bra.w H062+$274A
L062_000028CE:
; H062+$000028CE: 4a7900000014  tst.w $14.l
        tst.w (H005+$14).l
L062_000028D4:
; H062+$000028D4: 6300001e  bls.w $28f4
        bls.w H062+$28F4
L062_000028D8:
; H062+$000028D8: 427900000014  clr.w $14.l
        clr.w (H005+$14).l
L062_000028DE:
; H062+$000028DE: 3f3c004f  move.w #$4f, -(a7)
        move.w #$4f, -(a7)
L062_000028E2:
; H062+$000028E2: 487900000016  pea.l $16.l
        pea.l (H005+$16).l
L062_000028E8:
; H062+$000028E8: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L062_000028EC:
; H062+$000028EC: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L062_000028EE:
; H062+$000028EE: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L062_000028F4:
; H062+$000028F4: 4e5d  unlk a5
        unlk a5
L062_000028F6:
; H062+$000028F6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000028F8:
; H062+$000028F8: 4e75  rts 
        rts 
L062_000028FA:
; H062+$000028FA: 4e5d  unlk a5
        unlk a5
L062_000028FC:
; H062+$000028FC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L062_000028FE:
; H062+$000028FE: 4e75  rts 
        rts 
; End H062: $2900 bytes
