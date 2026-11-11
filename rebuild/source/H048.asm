; ============================================================================
; GUIDA DEL MODULO H048
; Servizi grafici e geometrici usati dal combattimento; dettaglio parziale.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Servizi grafici e geometrici usati dal combattimento: posizioni, riquadri, proiezioni e supporto al disegno degli attori.
; --------------------------------------------------------------------------
; H048: 6636 original bytes; all offsets are section-relative.
        section H048,code
H048:
; Preserved bytes H048+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H048+$00000004
; --------------------------------------------------------------------------
; ROUTINE: module_init_H048 [parziale]
; Scopo: Ingresso del modulo servizi grafici e geometrici usati dal combattimento; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H048+$19E0.
; Chiamanti diretti: H000+$018C
; --------------------------------------------------------------------------
L048_00000008:
; H048+$00000008: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_0000000A:
; H048+$0000000A: 287afff8  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_0000000E:
; H048+$0000000E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_00000012:
; H048+$00000012: 600019cc  bra.w $19e0
        bra.w H048+$19E0
; Preserved bytes H048+$00000016..$00000044; code/data not fully classified.
        dc.w $2F0C,$287A,$FFEA,$4E55,$0000,$3F3C,$00EF,$4879
        dc.l H005+$00003154
        dc.w $3F3C,$00F0,$4227,$4EB9
        dc.l H029+$00000312
        dc.w $13FC,$00FF
        dc.l H005+$0000247B
        dc.w $4E5D,$285F,$4E75
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H048_00B6 [parziale]
; Scopo: Trampolino verso H048+$00B6; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H048+$00B6.
; Chiamanti diretti: H077+$08D4, H048+$065E, H077+$09A0, H048+$11D2, H048+$09DE, H048+$0390 e altri 2
; --------------------------------------------------------------------------
L048_00000044:
; H048+$00000044: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000046:
; H048+$00000046: 287affbc  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_0000004A:
; H048+$0000004A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_0000004E:
; H048+$0000004E: 4a6d0016  tst.w $16(a5)
        tst.w $16(a5)
L048_00000052:
; H048+$00000052: 66000008  bne.w $5c
        bne.w H048+$5C
L048_00000056:
; H048+$00000056: 7000  moveq #$0, d0
        moveq #0, d0
L048_00000058:
; H048+$00000058: 6000005c  bra.w $b6
        bra.w H048+$B6
L048_0000005C:
; H048+$0000005C: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L048_00000060:
; H048+$00000060: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000062:
; H048+$00000062: e942  asl.w #$4, d2
        asl.w #$4, d2
L048_00000064:
; H048+$00000064: 47f900005048  lea.l $5048.l, a3
        lea.l (H005+$5048).l, a3
L048_0000006A:
; H048+$0000006A: 382d0014  move.w $14(a5), d4
        move.w $14(a5), d4
L048_0000006E:
; H048+$0000006E: e544  asl.w #$2, d4
        asl.w #$2, d4
L048_00000070:
; H048+$00000070: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L048_00000074:
; H048+$00000074: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L048_00000078:
; H048+$00000078: 34b34000  move.w (a3, d4.w), (a2)
        move.w (a3, d4.w), (a2)
L048_0000007C:
; H048+$0000007C: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L048_00000080:
; H048+$00000080: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000082:
; H048+$00000082: e942  asl.w #$4, d2
        asl.w #$4, d2
L048_00000084:
; H048+$00000084: 47f900005048  lea.l $5048.l, a3
        lea.l (H005+$5048).l, a3
L048_0000008A:
; H048+$0000008A: 382d0014  move.w $14(a5), d4
        move.w $14(a5), d4
L048_0000008E:
; H048+$0000008E: e544  asl.w #$2, d4
        asl.w #$2, d4
L048_00000090:
; H048+$00000090: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L048_00000094:
; H048+$00000094: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L048_00000098:
; H048+$00000098: 34b34002  move.w $2(a3, d4.w), (a2)
        move.w $2(a3, d4.w), (a2)
L048_0000009C:
; H048+$0000009C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L048_000000A0:
; H048+$000000A0: 4a53  tst.w (a3)
        tst.w (a3)
L048_000000A2:
; H048+$000000A2: 6d00000c  blt.w $b0
        blt.w H048+$B0
L048_000000A6:
; H048+$000000A6: 7001  moveq #$1, d0
        moveq #1, d0
L048_000000A8:
; H048+$000000A8: 6000000c  bra.w $b6
        bra.w H048+$B6
; Preserved bytes H048+$000000AC..$000000B0; code/data not fully classified.
        dc.w $6000,$0008
L048_000000B0:
; H048+$000000B0: 7000  moveq #$0, d0
        moveq #0, d0
L048_000000B2:
; H048+$000000B2: 60000002  bra.w $b6
        bra.w H048+$B6
L048_000000B6:
; H048+$000000B6: 4e5d  unlk a5
        unlk a5
L048_000000B8:
; H048+$000000B8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_000000BA:
; H048+$000000BA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_000000BC:
; H048+$000000BC: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L048_000000C0:
; H048+$000000C0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_000000C2 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H048+$0DD0
; --------------------------------------------------------------------------
L048_000000C2:
; H048+$000000C2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_000000C4:
; H048+$000000C4: 287aff3e  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_000000C8:
; H048+$000000C8: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L048_000000CC:
; H048+$000000CC: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L048_000000D2:
; H048+$000000D2: 7400  moveq #$0, d2
        moveq #0, d2
L048_000000D4:
; H048+$000000D4: 14390000247b  move.b $247b.l, d2
        move.b (H005+$247B).l, d2
L048_000000DA:
; H048+$000000DA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000000DC:
; H048+$000000DC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000000E0:
; H048+$000000E0: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L048_000000E2:
; H048+$000000E2: 62000068  bhi.w $14c
        bhi.w H048+$14C
L048_000000E6:
; H048+$000000E6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000000EA:
; H048+$000000EA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000000EC:
; H048+$000000EC: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000000EE:
; H048+$000000EE: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_000000F4:
; H048+$000000F4: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_000000F8:
; H048+$000000F8: 5344  subq.w #$1, d4
        subq.w #$1, d4
L048_000000FA:
; H048+$000000FA: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L048_000000FE:
; H048+$000000FE: 45f900003154  lea.l $3154.l, a2
        lea.l (H005+$3154).l, a2
L048_00000104:
; H048+$00000104: 3c324800  move.w (a2, d4.l), d6
        move.w (a2, d4.l), d6
L048_00000108:
; H048+$00000108: 247900002ade  movea.l $2ade.l, a2
        movea.l (H005+$2ADE).l, a2
L048_0000010E:
; H048+$0000010E: 9c6a0002  sub.w $2(a2), d6
        sub.w $2(a2), d6
L048_00000112:
; H048+$00000112: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L048_00000116:
; H048+$00000116: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_0000011A:
; H048+$0000011A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000011C:
; H048+$0000011C: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_0000011E:
; H048+$0000011E: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_00000124:
; H048+$00000124: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_00000128:
; H048+$00000128: 5344  subq.w #$1, d4
        subq.w #$1, d4
L048_0000012A:
; H048+$0000012A: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L048_0000012E:
; H048+$0000012E: 45f900003154  lea.l $3154.l, a2
        lea.l (H005+$3154).l, a2
L048_00000134:
; H048+$00000134: 3c324802  move.w $2(a2, d4.l), d6
        move.w $2(a2, d4.l), d6
L048_00000138:
; H048+$00000138: 247900002ade  movea.l $2ade.l, a2
        movea.l (H005+$2ADE).l, a2
L048_0000013E:
; H048+$0000013E: 9c6a0004  sub.w $4(a2), d6
        sub.w $4(a2), d6
L048_00000142:
; H048+$00000142: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L048_00000146:
; H048+$00000146: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L048_0000014A:
; H048+$0000014A: 6490  bcc.b $dc
        bcc.b H048+$DC
L048_0000014C:
; H048+$0000014C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L048_0000014E:
; H048+$0000014E: 4e5d  unlk a5
        unlk a5
L048_00000150:
; H048+$00000150: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000152:
; H048+$00000152: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000154 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$27BC, H085+$283C, H085+$124E, H085+$1332, H048+$05CE, H085+$144A e altri 9
; --------------------------------------------------------------------------
L048_00000154:
; H048+$00000154: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000156:
; H048+$00000156: 287afeac  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_0000015A:
; H048+$0000015A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_0000015E:
; H048+$0000015E: 4a6d0016  tst.w $16(a5)
        tst.w $16(a5)
L048_00000162:
; H048+$00000162: 6d00006c  blt.w $1d0
        blt.w H048+$1D0
L048_00000166:
; H048+$00000166: 0c6d00310016  cmpi.w #$31, $16(a5)
        cmpi.w #$31, $16(a5)
L048_0000016C:
; H048+$0000016C: 6e000062  bgt.w $1d0
        bgt.w H048+$1D0
L048_00000170:
; H048+$00000170: 4a6d0014  tst.w $14(a5)
        tst.w $14(a5)
L048_00000174:
; H048+$00000174: 6d00005a  blt.w $1d0
        blt.w H048+$1D0
L048_00000178:
; H048+$00000178: 0c6d00180014  cmpi.w #$18, $14(a5)
        cmpi.w #$18, $14(a5)
L048_0000017E:
; H048+$0000017E: 6e000050  bgt.w $1d0
        bgt.w H048+$1D0
L048_00000182:
; H048+$00000182: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L048_00000186:
; H048+$00000186: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_0000018A:
; H048+$0000018A: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000190:
; H048+$00000190: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000194:
; H048+$00000194: 382d0016  move.w $16(a5), d4
        move.w $16(a5), d4
L048_00000198:
; H048+$00000198: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_0000019A:
; H048+$0000019A: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_0000019E:
; H048+$0000019E: 7400  moveq #$0, d2
        moveq #0, d2
L048_000001A0:
; H048+$000001A0: 14334001  move.b $1(a3, d4.w), d2
        move.b $1(a3, d4.w), d2
L048_000001A4:
; H048+$000001A4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L048_000001A8:
; H048+$000001A8: 3682  move.w d2, (a3)
        move.w d2, (a3)
L048_000001AA:
; H048+$000001AA: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L048_000001AE:
; H048+$000001AE: c5fc0032  muls.w #$32, d2
        muls.w #$32, d2
L048_000001B2:
; H048+$000001B2: 47f900002bd2  lea.l $2bd2.l, a3
        lea.l (H005+$2BD2).l, a3
L048_000001B8:
; H048+$000001B8: 382d0016  move.w $16(a5), d4
        move.w $16(a5), d4
L048_000001BC:
; H048+$000001BC: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_000001C0:
; H048+$000001C0: 7400  moveq #$0, d2
        moveq #0, d2
L048_000001C2:
; H048+$000001C2: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_000001C6:
; H048+$000001C6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L048_000001CA:
; H048+$000001CA: 3682  move.w d2, (a3)
        move.w d2, (a3)
L048_000001CC:
; H048+$000001CC: 6000000e  bra.w $1dc
        bra.w H048+$1DC
L048_000001D0:
; H048+$000001D0: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L048_000001D4:
; H048+$000001D4: 4253  clr.w (a3)
        clr.w (a3)
L048_000001D6:
; H048+$000001D6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L048_000001DA:
; H048+$000001DA: 4253  clr.w (a3)
        clr.w (a3)
L048_000001DC:
; H048+$000001DC: 4e5d  unlk a5
        unlk a5
L048_000001DE:
; H048+$000001DE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_000001E0:
; H048+$000001E0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_000001E2:
; H048+$000001E2: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L048_000001E6:
; H048+$000001E6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_000001E8 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H048+$067E, H048+$0F20, H048+$07A2, H048+$03B0, H048+$02E0, H063+$244E e altri 3
; --------------------------------------------------------------------------
L048_000001E8:
; H048+$000001E8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_000001EA:
; H048+$000001EA: 287afe18  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_000001EE:
; H048+$000001EE: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_000001F2:
; H048+$000001F2: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L048_000001F6:
; H048+$000001F6: 6d00001e  blt.w $216
        blt.w H048+$216
L048_000001FA:
; H048+$000001FA: 0c6d0006000e  cmpi.w #$6, $e(a5)
        cmpi.w #$6, $e(a5)
L048_00000200:
; H048+$00000200: 6e000014  bgt.w $216
        bgt.w H048+$216
L048_00000204:
; H048+$00000204: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L048_00000208:
; H048+$00000208: 6d00000c  blt.w $216
        blt.w H048+$216
L048_0000020C:
; H048+$0000020C: 0c6d0006000c  cmpi.w #$6, $c(a5)
        cmpi.w #$6, $c(a5)
L048_00000212:
; H048+$00000212: 6f00000c  ble.w $220
        ble.w H048+$220
L048_00000216:
; H048+$00000216: 7000  moveq #$0, d0
        moveq #0, d0
L048_00000218:
; H048+$00000218: 6000000c  bra.w $226
        bra.w H048+$226
; Preserved bytes H048+$0000021C..$00000220; code/data not fully classified.
        dc.w $6000,$0008
L048_00000220:
; H048+$00000220: 7001  moveq #$1, d0
        moveq #1, d0
L048_00000222:
; H048+$00000222: 60000002  bra.w $226
        bra.w H048+$226
L048_00000226:
; H048+$00000226: 4e5d  unlk a5
        unlk a5
L048_00000228:
; H048+$00000228: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_0000022A:
; H048+$0000022A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_0000022C:
; H048+$0000022C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_0000022E:
; H048+$0000022E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000230 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H063+$27C0, H048+$138A, H096+$2204, H096+$224E, H048+$1010, H096+$24BE e altri 3
; --------------------------------------------------------------------------
L048_00000230:
; H048+$00000230: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000232:
; H048+$00000232: 287afdd0  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00000236:
; H048+$00000236: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L048_0000023A:
; H048+$0000023A: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L048_00000240:
; H048+$00000240: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L048_00000244:
; H048+$00000244: 4eb900000aa8  jsr $aa8.l
        jsr (H048+$AA8).l
L048_0000024A:
; H048+$0000024A: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L048_0000024E:
; H048+$0000024E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00000252:
; H048+$00000252: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000254:
; H048+$00000254: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00000258:
; H048+$00000258: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_0000025E:
; H048+$0000025E: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000260:
; H048+$00000260: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_00000264:
; H048+$00000264: 4a44  tst.w d4
        tst.w d4
L048_00000266:
; H048+$00000266: 6600000a  bne.w $272
        bne.w H048+$272
L048_0000026A:
; H048+$0000026A: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L048_0000026E:
; H048+$0000026E: 600000b2  bra.w $322
        bra.w H048+$322
L048_00000272:
; H048+$00000272: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L048_00000276:
; H048+$00000276: 0c6d0003fffe  cmpi.w #$3, -$2(a5)
        cmpi.w #$3, -$2(a5)
L048_0000027C:
; H048+$0000027C: 620000a4  bhi.w $322
        bhi.w H048+$322
L048_00000280:
; H048+$00000280: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00000284:
; H048+$00000284: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000286:
; H048+$00000286: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_0000028A:
; H048+$0000028A: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00000290:
; H048+$00000290: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000292:
; H048+$00000292: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_00000296:
; H048+$00000296: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_00000298:
; H048+$00000298: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L048_0000029C:
; H048+$0000029C: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L048_000002A0:
; H048+$000002A0: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_000002A4:
; H048+$000002A4: 6100fd9e  bsr.w $44
        bsr.w H048+$44
L048_000002A8:
; H048+$000002A8: 1400  move.b d0, d2
        move.b d0, d2
L048_000002AA:
; H048+$000002AA: 4a02  tst.b d2
        tst.b d2
L048_000002AC:
; H048+$000002AC: 6700006c  beq.w $31a
        beq.w H048+$31A
L048_000002B0:
; H048+$000002B0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000002B4:
; H048+$000002B4: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000002B6:
; H048+$000002B6: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000002B8:
; H048+$000002B8: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_000002BE:
; H048+$000002BE: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L048_000002C2:
; H048+$000002C2: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L048_000002C6:
; H048+$000002C6: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_000002C8:
; H048+$000002C8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000002CC:
; H048+$000002CC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000002CE:
; H048+$000002CE: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000002D0:
; H048+$000002D0: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_000002D6:
; H048+$000002D6: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L048_000002DA:
; H048+$000002DA: d86dfff8  add.w -$8(a5), d4
        add.w -$8(a5), d4
L048_000002DE:
; H048+$000002DE: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_000002E0:
; H048+$000002E0: 6100ff06  bsr.w $1e8
        bsr.w H048+$1E8
L048_000002E4:
; H048+$000002E4: 1400  move.b d0, d2
        move.b d0, d2
L048_000002E6:
; H048+$000002E6: 4a02  tst.b d2
        tst.b d2
L048_000002E8:
; H048+$000002E8: 6600001a  bne.w $304
        bne.w H048+$304
L048_000002EC:
; H048+$000002EC: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L048_000002F0:
; H048+$000002F0: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L048_000002F4:
; H048+$000002F4: 6700000a  beq.w $300
        beq.w H048+$300
L048_000002F8:
; H048+$000002F8: 102dfff3  move.b -$d(a5), d0
        move.b -$d(a5), d0
L048_000002FC:
; H048+$000002FC: 6000002c  bra.w $32a
        bra.w H048+$32A
L048_00000300:
; H048+$00000300: 60000018  bra.w $31a
        bra.w H048+$31A
L048_00000304:
; H048+$00000304: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L048_0000030A:
; H048+$0000030A: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L048_0000030E:
; H048+$0000030E: 6600000a  bne.w $31a
        bne.w H048+$31A
L048_00000312:
; H048+$00000312: 102dfff3  move.b -$d(a5), d0
        move.b -$d(a5), d0
L048_00000316:
; H048+$00000316: 60000012  bra.w $32a
        bra.w H048+$32A
L048_0000031A:
; H048+$0000031A: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L048_0000031E:
; H048+$0000031E: 6400ff56  bcc.w $276
        bcc.w H048+$276
L048_00000322:
; H048+$00000322: 102dfff3  move.b -$d(a5), d0
        move.b -$d(a5), d0
L048_00000326:
; H048+$00000326: 60000002  bra.w $32a
        bra.w H048+$32A
L048_0000032A:
; H048+$0000032A: 4e5d  unlk a5
        unlk a5
L048_0000032C:
; H048+$0000032C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_0000032E:
; H048+$0000032E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000330:
; H048+$00000330: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L048_00000332:
; H048+$00000332: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000334 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H029+$16A2, H035+$019A, H035+$0460, H029+$16DE.
;   - Richiama H029+$16A2.
;   - Richiama H035+$019A.
;   - Richiama H035+$0460.
;   - Richiama H029+$16DE.
; Chiamanti diretti: H048+$0F74
; --------------------------------------------------------------------------
L048_00000334:
; H048+$00000334: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000336:
; H048+$00000336: 287afccc  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_0000033A:
; H048+$0000033A: 4e55fff0  link.w a5, #$fff0
        link.w a5, #$fff0
; -> H029+$16A2 (sub_H029_000016A2)
L048_0000033E:
; H048+$0000033E: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
L048_00000344:
; H048+$00000344: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000348:
; H048+$00000348: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000034E:
; H048+$0000034E: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L048_00000352:
; H048+$00000352: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L048_00000356:
; H048+$00000356: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_0000035A:
; H048+$0000035A: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000360:
; H048+$00000360: 946b0004  sub.w $4(a3), d2
        sub.w $4(a3), d2
L048_00000364:
; H048+$00000364: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L048_00000368:
; H048+$00000368: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L048_0000036C:
; H048+$0000036C: 0c6d0003fff6  cmpi.w #$3, -$a(a5)
        cmpi.w #$3, -$a(a5)
L048_00000372:
; H048+$00000372: 62000184  bhi.w $4f8
        bhi.w H048+$4F8
L048_00000376:
; H048+$00000376: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000378:
; H048+$00000378: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000037E:
; H048+$0000037E: 142b0007  move.b $7(a3), d2
        move.b $7(a3), d2
L048_00000382:
; H048+$00000382: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000384:
; H048+$00000384: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L048_00000388:
; H048+$00000388: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L048_0000038C:
; H048+$0000038C: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_00000390:
; H048+$00000390: 6100fcb2  bsr.w $44
        bsr.w H048+$44
L048_00000394:
; H048+$00000394: 1400  move.b d0, d2
        move.b d0, d2
L048_00000396:
; H048+$00000396: 4a02  tst.b d2
        tst.b d2
L048_00000398:
; H048+$00000398: 67000156  beq.w $4f0
        beq.w H048+$4F0
L048_0000039C:
; H048+$0000039C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000003A0:
; H048+$000003A0: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L048_000003A4:
; H048+$000003A4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000003A6:
; H048+$000003A6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000003AA:
; H048+$000003AA: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_000003AE:
; H048+$000003AE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000003B0:
; H048+$000003B0: 6100fe36  bsr.w $1e8
        bsr.w H048+$1E8
L048_000003B4:
; H048+$000003B4: 1400  move.b d0, d2
        move.b d0, d2
L048_000003B6:
; H048+$000003B6: 4a02  tst.b d2
        tst.b d2
L048_000003B8:
; H048+$000003B8: 67000136  beq.w $4f0
        beq.w H048+$4F0
L048_000003BC:
; H048+$000003BC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000003C0:
; H048+$000003C0: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L048_000003C4:
; H048+$000003C4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000003C6:
; H048+$000003C6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000003CA:
; H048+$000003CA: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_000003CE:
; H048+$000003CE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000003D0:
; H048+$000003D0: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_000003D4:
; H048+$000003D4: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_000003D8:
; H048+$000003D8: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_000003DC:
; H048+$000003DC: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000003E2:
; H048+$000003E2: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_000003E6:
; H048+$000003E6: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L048_000003EA:
; H048+$000003EA: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L048_000003EE:
; H048+$000003EE: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_000003F0:
; H048+$000003F0: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_000003F4:
; H048+$000003F4: 7400  moveq #$0, d2
        moveq #0, d2
L048_000003F6:
; H048+$000003F6: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_000003FA:
; H048+$000003FA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000003FC:
; H048+$000003FC: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_000003FE:
; H048+$000003FE: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_00000404:
; H048+$00000404: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_00000408:
; H048+$00000408: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_0000040A:
; H048+$0000040A: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_00000410:
; H048+$00000410: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_00000414:
; H048+$00000414: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_00000418:
; H048+$00000418: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_0000041C:
; H048+$0000041C: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000422:
; H048+$00000422: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000426:
; H048+$00000426: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L048_0000042A:
; H048+$0000042A: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L048_0000042E:
; H048+$0000042E: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00000430:
; H048+$00000430: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_00000434:
; H048+$00000434: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000436:
; H048+$00000436: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_0000043A:
; H048+$0000043A: 382d000c  move.w $c(a5), d4
        move.w $c(a5), d4
L048_0000043E:
; H048+$0000043E: d86dfff8  add.w -$8(a5), d4
        add.w -$8(a5), d4
L048_00000442:
; H048+$00000442: c9fc0064  muls.w #$64, d4
        muls.w #$64, d4
L048_00000446:
; H048+$00000446: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000044C:
; H048+$0000044C: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000450:
; H048+$00000450: 3c2d000e  move.w $e(a5), d6
        move.w $e(a5), d6
L048_00000454:
; H048+$00000454: dc6dfffa  add.w -$6(a5), d6
        add.w -$6(a5), d6
L048_00000458:
; H048+$00000458: e346  asl.w #$1, d6
        asl.w #$1, d6
L048_0000045A:
; H048+$0000045A: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L048_0000045E:
; H048+$0000045E: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000460:
; H048+$00000460: 18336001  move.b $1(a3, d6.w), d4
        move.b $1(a3, d6.w), d4
L048_00000464:
; H048+$00000464: b444  cmp.w d4, d2
        cmp.w d4, d2
L048_00000466:
; H048+$00000466: 67000058  beq.w $4c0
        beq.w H048+$4C0
L048_0000046A:
; H048+$0000046A: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_0000046E:
; H048+$0000046E: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L048_00000472:
; H048+$00000472: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000474:
; H048+$00000474: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00000478:
; H048+$00000478: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_0000047C:
; H048+$0000047C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_0000047E:
; H048+$0000047E: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_00000482:
; H048+$00000482: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_00000486:
; H048+$00000486: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_0000048A:
; H048+$0000048A: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000490:
; H048+$00000490: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000494:
; H048+$00000494: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L048_00000498:
; H048+$00000498: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L048_0000049C:
; H048+$0000049C: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_0000049E:
; H048+$0000049E: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_000004A2:
; H048+$000004A2: 7400  moveq #$0, d2
        moveq #0, d2
L048_000004A4:
; H048+$000004A4: 14334001  move.b $1(a3, d4.w), d2
        move.b $1(a3, d4.w), d2
L048_000004A8:
; H048+$000004A8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000004AA:
; H048+$000004AA: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_000004AC:
; H048+$000004AC: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_000004B2:
; H048+$000004B2: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_000004B6:
; H048+$000004B6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_000004BA:
; H048+$000004BA: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_000004C0:
; H048+$000004C0: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000004C6:
; H048+$000004C6: 4a2b0006  tst.b $6(a3)
        tst.b $6(a3)
L048_000004CA:
; H048+$000004CA: 67000024  beq.w $4f0
        beq.w H048+$4F0
L048_000004CE:
; H048+$000004CE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000004D2:
; H048+$000004D2: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L048_000004D6:
; H048+$000004D6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000004D8:
; H048+$000004D8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000004DC:
; H048+$000004DC: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_000004E0:
; H048+$000004E0: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000004E2:
; H048+$000004E2: 4267  clr.w -(a7)
        clr.w -(a7)
L048_000004E4:
; H048+$000004E4: 4267  clr.w -(a7)
        clr.w -(a7)
L048_000004E6:
; H048+$000004E6: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L048_000004EA:
; H048+$000004EA: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L048_000004F0:
; H048+$000004F0: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L048_000004F4:
; H048+$000004F4: 6400fe76  bcc.w $36c
        bcc.w H048+$36C
L048_000004F8:
; H048+$000004F8: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L048_000004FC:
; H048+$000004FC: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L048_00000500:
; H048+$00000500: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
L048_00000504:
; H048+$00000504: 486dfff2  pea.l -$e(a5)
        pea.l -$e(a5)
L048_00000508:
; H048+$00000508: 6100fc4a  bsr.w $154
        bsr.w H048+$154
L048_0000050C:
; H048+$0000050C: 4a6dfff4  tst.w -$c(a5)
        tst.w -$c(a5)
L048_00000510:
; H048+$00000510: 63000066  bls.w $578
        bls.w H048+$578
L048_00000514:
; H048+$00000514: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L048_00000518:
; H048+$00000518: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000051A:
; H048+$0000051A: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_0000051C:
; H048+$0000051C: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_00000522:
; H048+$00000522: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_00000526:
; H048+$00000526: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L048_0000052A:
; H048+$0000052A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000052C:
; H048+$0000052C: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_0000052E:
; H048+$0000052E: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_00000534:
; H048+$00000534: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_00000538:
; H048+$00000538: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L048_0000053C:
; H048+$0000053C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000053E:
; H048+$0000053E: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00000540:
; H048+$00000540: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L048_00000546:
; H048+$00000546: 26732000  movea.l (a3, d2.w), a3
        movea.l (a3, d2.w), a3
L048_0000054A:
; H048+$0000054A: 266b0192  movea.l $192(a3), a3
        movea.l $192(a3), a3
L048_0000054E:
; H048+$0000054E: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000550:
; H048+$00000550: 142b000b  move.b $b(a3), d2
        move.b $b(a3), d2
L048_00000554:
; H048+$00000554: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000556:
; H048+$00000556: 4267  clr.w -(a7)
        clr.w -(a7)
L048_00000558:
; H048+$00000558: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L048_0000055C:
; H048+$0000055C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000055E:
; H048+$0000055E: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00000560:
; H048+$00000560: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L048_00000566:
; H048+$00000566: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000568:
; H048+$00000568: 26732000  movea.l (a3, d2.w), a3
        movea.l (a3, d2.w), a3
L048_0000056C:
; H048+$0000056C: 182b0143  move.b $143(a3), d4
        move.b $143(a3), d4
L048_00000570:
; H048+$00000570: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L048_00000572:
; H048+$00000572: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
; -> H029+$16DE (sub_H029_000016DE)
L048_00000578:
; H048+$00000578: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L048_0000057E:
; H048+$0000057E: 4e5d  unlk a5
        unlk a5
L048_00000580:
; H048+$00000580: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000582:
; H048+$00000582: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000584:
; H048+$00000584: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_00000586:
; H048+$00000586: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000588 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H035+$019A.
;   - Richiama H035+$019A.
; Chiamanti diretti: H085+$38CC, H048+$08C2, H048+$13B2, H048+$1652, H048+$1090, H062+$1738 e altri 2
; --------------------------------------------------------------------------
L048_00000588:
; H048+$00000588: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_0000058A:
; H048+$0000058A: 287afa78  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_0000058E:
; H048+$0000058E: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L048_00000592:
; H048+$00000592: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L048_00000596:
; H048+$00000596: 6600003a  bne.w $5d2
        bne.w H048+$5D2
L048_0000059A:
; H048+$0000059A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_0000059E:
; H048+$0000059E: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000005A4:
; H048+$000005A4: d46b0002  add.w $2(a3), d2
        add.w $2(a3), d2
L048_000005A8:
; H048+$000005A8: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L048_000005AC:
; H048+$000005AC: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_000005B0:
; H048+$000005B0: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000005B6:
; H048+$000005B6: d46b0004  add.w $4(a3), d2
        add.w $4(a3), d2
L048_000005BA:
; H048+$000005BA: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L048_000005BE:
; H048+$000005BE: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L048_000005C2:
; H048+$000005C2: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L048_000005C6:
; H048+$000005C6: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
L048_000005CA:
; H048+$000005CA: 486dfff4  pea.l -$c(a5)
        pea.l -$c(a5)
L048_000005CE:
; H048+$000005CE: 6100fb84  bsr.w $154
        bsr.w H048+$154
L048_000005D2:
; H048+$000005D2: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L048_000005D6:
; H048+$000005D6: 630001c2  bls.w $79a
        bls.w H048+$79A
L048_000005DA:
; H048+$000005DA: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_000005DE:
; H048+$000005DE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000005E0:
; H048+$000005E0: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000005E2:
; H048+$000005E2: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_000005E8:
; H048+$000005E8: 3b7320000010  move.w (a3, d2.w), $10(a5)
        move.w (a3, d2.w), $10(a5)
L048_000005EE:
; H048+$000005EE: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_000005F2:
; H048+$000005F2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000005F4:
; H048+$000005F4: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000005F6:
; H048+$000005F6: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_000005FC:
; H048+$000005FC: 3b732000000e  move.w (a3, d2.w), $e(a5)
        move.w (a3, d2.w), $e(a5)
L048_00000602:
; H048+$00000602: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_00000606:
; H048+$00000606: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000060C:
; H048+$0000060C: d46b0002  add.w $2(a3), d2
        add.w $2(a3), d2
L048_00000610:
; H048+$00000610: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L048_00000614:
; H048+$00000614: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000618:
; H048+$00000618: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000061E:
; H048+$0000061E: d46b0004  add.w $4(a3), d2
        add.w $4(a3), d2
L048_00000622:
; H048+$00000622: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L048_00000626:
; H048+$00000626: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_0000062A:
; H048+$0000062A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000062C:
; H048+$0000062C: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00000630:
; H048+$00000630: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00000636:
; H048+$00000636: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000638:
; H048+$00000638: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_0000063C:
; H048+$0000063C: 3b44fff2  move.w d4, -$e(a5)
        move.w d4, -$e(a5)
L048_00000640:
; H048+$00000640: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L048_00000644:
; H048+$00000644: 0c6d0003fff6  cmpi.w #$3, -$a(a5)
        cmpi.w #$3, -$a(a5)
L048_0000064A:
; H048+$0000064A: 6200014a  bhi.w $796
        bhi.w H048+$796
L048_0000064E:
; H048+$0000064E: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L048_00000652:
; H048+$00000652: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L048_00000656:
; H048+$00000656: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L048_0000065A:
; H048+$0000065A: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_0000065E:
; H048+$0000065E: 6100f9e4  bsr.w $44
        bsr.w H048+$44
L048_00000662:
; H048+$00000662: 1400  move.b d0, d2
        move.b d0, d2
L048_00000664:
; H048+$00000664: 4a02  tst.b d2
        tst.b d2
L048_00000666:
; H048+$00000666: 67000126  beq.w $78e
        beq.w H048+$78E
L048_0000066A:
; H048+$0000066A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_0000066E:
; H048+$0000066E: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L048_00000672:
; H048+$00000672: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000674:
; H048+$00000674: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000678:
; H048+$00000678: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_0000067C:
; H048+$0000067C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_0000067E:
; H048+$0000067E: 6100fb68  bsr.w $1e8
        bsr.w H048+$1E8
L048_00000682:
; H048+$00000682: 1400  move.b d0, d2
        move.b d0, d2
L048_00000684:
; H048+$00000684: 4a02  tst.b d2
        tst.b d2
L048_00000686:
; H048+$00000686: 67000106  beq.w $78e
        beq.w H048+$78E
L048_0000068A:
; H048+$0000068A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_0000068E:
; H048+$0000068E: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L048_00000692:
; H048+$00000692: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000694:
; H048+$00000694: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000698:
; H048+$00000698: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_0000069C:
; H048+$0000069C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_0000069E:
; H048+$0000069E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000006A2:
; H048+$000006A2: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_000006A6:
; H048+$000006A6: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_000006AA:
; H048+$000006AA: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000006B0:
; H048+$000006B0: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_000006B4:
; H048+$000006B4: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_000006B8:
; H048+$000006B8: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L048_000006BC:
; H048+$000006BC: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_000006BE:
; H048+$000006BE: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_000006C2:
; H048+$000006C2: 7400  moveq #$0, d2
        moveq #0, d2
L048_000006C4:
; H048+$000006C4: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_000006C8:
; H048+$000006C8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000006CA:
; H048+$000006CA: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_000006CC:
; H048+$000006CC: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_000006D2:
; H048+$000006D2: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_000006D6:
; H048+$000006D6: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_000006D8:
; H048+$000006D8: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_000006DE:
; H048+$000006DE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000006E2:
; H048+$000006E2: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_000006E6:
; H048+$000006E6: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_000006EA:
; H048+$000006EA: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000006F0:
; H048+$000006F0: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_000006F4:
; H048+$000006F4: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_000006F8:
; H048+$000006F8: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L048_000006FC:
; H048+$000006FC: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_000006FE:
; H048+$000006FE: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_00000702:
; H048+$00000702: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000704:
; H048+$00000704: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_00000708:
; H048+$00000708: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L048_0000070C:
; H048+$0000070C: d86dfff8  add.w -$8(a5), d4
        add.w -$8(a5), d4
L048_00000710:
; H048+$00000710: c9fc0064  muls.w #$64, d4
        muls.w #$64, d4
L048_00000714:
; H048+$00000714: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000071A:
; H048+$0000071A: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_0000071E:
; H048+$0000071E: 3c2dfffe  move.w -$2(a5), d6
        move.w -$2(a5), d6
L048_00000722:
; H048+$00000722: dc6dfffa  add.w -$6(a5), d6
        add.w -$6(a5), d6
L048_00000726:
; H048+$00000726: e346  asl.w #$1, d6
        asl.w #$1, d6
L048_00000728:
; H048+$00000728: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L048_0000072C:
; H048+$0000072C: 7800  moveq #$0, d4
        moveq #0, d4
L048_0000072E:
; H048+$0000072E: 18336001  move.b $1(a3, d6.w), d4
        move.b $1(a3, d6.w), d4
L048_00000732:
; H048+$00000732: b444  cmp.w d4, d2
        cmp.w d4, d2
L048_00000734:
; H048+$00000734: 67000058  beq.w $78e
        beq.w H048+$78E
L048_00000738:
; H048+$00000738: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_0000073C:
; H048+$0000073C: d46dfffa  add.w -$6(a5), d2
        add.w -$6(a5), d2
L048_00000740:
; H048+$00000740: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000742:
; H048+$00000742: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000746:
; H048+$00000746: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_0000074A:
; H048+$0000074A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_0000074C:
; H048+$0000074C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00000750:
; H048+$00000750: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L048_00000754:
; H048+$00000754: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_00000758:
; H048+$00000758: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000075E:
; H048+$0000075E: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000762:
; H048+$00000762: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_00000766:
; H048+$00000766: d86dfffa  add.w -$6(a5), d4
        add.w -$6(a5), d4
L048_0000076A:
; H048+$0000076A: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_0000076C:
; H048+$0000076C: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_00000770:
; H048+$00000770: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000772:
; H048+$00000772: 14334001  move.b $1(a3, d4.w), d2
        move.b $1(a3, d4.w), d2
L048_00000776:
; H048+$00000776: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000778:
; H048+$00000778: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_0000077A:
; H048+$0000077A: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_00000780:
; H048+$00000780: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_00000784:
; H048+$00000784: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_00000788:
; H048+$00000788: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_0000078E:
; H048+$0000078E: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L048_00000792:
; H048+$00000792: 6400feb0  bcc.w $644
        bcc.w H048+$644
L048_00000796:
; H048+$00000796: 600000e2  bra.w $87a
        bra.w H048+$87A
L048_0000079A:
; H048+$0000079A: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L048_0000079E:
; H048+$0000079E: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L048_000007A2:
; H048+$000007A2: 6100fa44  bsr.w $1e8
        bsr.w H048+$1E8
L048_000007A6:
; H048+$000007A6: 1400  move.b d0, d2
        move.b d0, d2
L048_000007A8:
; H048+$000007A8: 4a02  tst.b d2
        tst.b d2
L048_000007AA:
; H048+$000007AA: 670000ce  beq.w $87a
        beq.w H048+$87A
L048_000007AE:
; H048+$000007AE: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L048_000007B2:
; H048+$000007B2: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L048_000007B6:
; H048+$000007B6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000007BA:
; H048+$000007BA: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_000007BE:
; H048+$000007BE: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000007C4:
; H048+$000007C4: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_000007C8:
; H048+$000007C8: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_000007CC:
; H048+$000007CC: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_000007CE:
; H048+$000007CE: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_000007D2:
; H048+$000007D2: 7400  moveq #$0, d2
        moveq #0, d2
L048_000007D4:
; H048+$000007D4: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_000007D8:
; H048+$000007D8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000007DA:
; H048+$000007DA: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_000007DC:
; H048+$000007DC: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_000007E2:
; H048+$000007E2: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_000007E6:
; H048+$000007E6: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_000007E8:
; H048+$000007E8: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_000007EE:
; H048+$000007EE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000007F2:
; H048+$000007F2: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_000007F6:
; H048+$000007F6: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000007FC:
; H048+$000007FC: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000800:
; H048+$00000800: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_00000804:
; H048+$00000804: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00000806:
; H048+$00000806: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_0000080A:
; H048+$0000080A: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000080C:
; H048+$0000080C: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_00000810:
; H048+$00000810: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L048_00000814:
; H048+$00000814: c9fc0064  muls.w #$64, d4
        muls.w #$64, d4
L048_00000818:
; H048+$00000818: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000081E:
; H048+$0000081E: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000822:
; H048+$00000822: 3c2dfffe  move.w -$2(a5), d6
        move.w -$2(a5), d6
L048_00000826:
; H048+$00000826: e346  asl.w #$1, d6
        asl.w #$1, d6
L048_00000828:
; H048+$00000828: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L048_0000082C:
; H048+$0000082C: 7800  moveq #$0, d4
        moveq #0, d4
L048_0000082E:
; H048+$0000082E: 18336001  move.b $1(a3, d6.w), d4
        move.b $1(a3, d6.w), d4
L048_00000832:
; H048+$00000832: b444  cmp.w d4, d2
        cmp.w d4, d2
L048_00000834:
; H048+$00000834: 67000044  beq.w $87a
        beq.w H048+$87A
L048_00000838:
; H048+$00000838: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L048_0000083C:
; H048+$0000083C: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L048_00000840:
; H048+$00000840: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00000844:
; H048+$00000844: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_00000848:
; H048+$00000848: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000084E:
; H048+$0000084E: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000852:
; H048+$00000852: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_00000856:
; H048+$00000856: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00000858:
; H048+$00000858: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_0000085C:
; H048+$0000085C: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000085E:
; H048+$0000085E: 14334001  move.b $1(a3, d4.w), d2
        move.b $1(a3, d4.w), d2
L048_00000862:
; H048+$00000862: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000864:
; H048+$00000864: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00000866:
; H048+$00000866: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_0000086C:
; H048+$0000086C: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_00000870:
; H048+$00000870: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_00000874:
; H048+$00000874: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_0000087A:
; H048+$0000087A: 4e5d  unlk a5
        unlk a5
L048_0000087C:
; H048+$0000087C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_0000087E:
; H048+$0000087E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000880:
; H048+$00000880: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L048_00000882:
; H048+$00000882: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000884 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H029+$16A2, H035+$0460, H029+$16DE.
;   - Richiama H029+$16A2.
;   - Richiama H035+$0460.
;   - Richiama H029+$16DE.
; Chiamanti diretti: H048+$0EFC, H096+$3056, H096+$2CF2, H096+$45B0, H096+$4A40, H096+$4314 e altri 2
; --------------------------------------------------------------------------
L048_00000884:
; H048+$00000884: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000886:
; H048+$00000886: 287af77c  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_0000088A:
; H048+$0000088A: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
; -> H029+$16A2 (sub_H029_000016A2)
L048_0000088E:
; H048+$0000088E: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
L048_00000894:
; H048+$00000894: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000898:
; H048+$00000898: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000089E:
; H048+$0000089E: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L048_000008A2:
; H048+$000008A2: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L048_000008A6:
; H048+$000008A6: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_000008AA:
; H048+$000008AA: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000008B0:
; H048+$000008B0: 946b0004  sub.w $4(a3), d2
        sub.w $4(a3), d2
L048_000008B4:
; H048+$000008B4: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L048_000008B8:
; H048+$000008B8: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L048_000008BC:
; H048+$000008BC: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L048_000008C0:
; H048+$000008C0: 4267  clr.w -(a7)
        clr.w -(a7)
L048_000008C2:
; H048+$000008C2: 6100fcc4  bsr.w $588
        bsr.w H048+$588
L048_000008C6:
; H048+$000008C6: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L048_000008CA:
; H048+$000008CA: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L048_000008CE:
; H048+$000008CE: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L048_000008D2:
; H048+$000008D2: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_000008D6:
; H048+$000008D6: 6100f87c  bsr.w $154
        bsr.w H048+$154
L048_000008DA:
; H048+$000008DA: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L048_000008DE:
; H048+$000008DE: 63000066  bls.w $946
        bls.w H048+$946
L048_000008E2:
; H048+$000008E2: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_000008E6:
; H048+$000008E6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000008E8:
; H048+$000008E8: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000008EA:
; H048+$000008EA: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_000008F0:
; H048+$000008F0: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_000008F4:
; H048+$000008F4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_000008F8:
; H048+$000008F8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000008FA:
; H048+$000008FA: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000008FC:
; H048+$000008FC: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_00000902:
; H048+$00000902: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_00000906:
; H048+$00000906: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_0000090A:
; H048+$0000090A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000090C:
; H048+$0000090C: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_0000090E:
; H048+$0000090E: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L048_00000914:
; H048+$00000914: 26732000  movea.l (a3, d2.w), a3
        movea.l (a3, d2.w), a3
L048_00000918:
; H048+$00000918: 266b0192  movea.l $192(a3), a3
        movea.l $192(a3), a3
L048_0000091C:
; H048+$0000091C: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000091E:
; H048+$0000091E: 142b000b  move.b $b(a3), d2
        move.b $b(a3), d2
L048_00000922:
; H048+$00000922: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000924:
; H048+$00000924: 4267  clr.w -(a7)
        clr.w -(a7)
L048_00000926:
; H048+$00000926: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_0000092A:
; H048+$0000092A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000092C:
; H048+$0000092C: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_0000092E:
; H048+$0000092E: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L048_00000934:
; H048+$00000934: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000936:
; H048+$00000936: 26732000  movea.l (a3, d2.w), a3
        movea.l (a3, d2.w), a3
L048_0000093A:
; H048+$0000093A: 182b0143  move.b $143(a3), d4
        move.b $143(a3), d4
L048_0000093E:
; H048+$0000093E: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L048_00000940:
; H048+$00000940: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
; -> H029+$16DE (sub_H029_000016DE)
L048_00000946:
; H048+$00000946: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L048_0000094C:
; H048+$0000094C: 4e5d  unlk a5
        unlk a5
L048_0000094E:
; H048+$0000094E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000950:
; H048+$00000950: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000952:
; H048+$00000952: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_00000954:
; H048+$00000954: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000956 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H029+$0312.
;   - Richiama H029+$0312.
; Chiamanti diretti: H048+$193C, H048+$1670, H095+$2004, H095+$23E4, H062+$1752, H096+$0B86
; --------------------------------------------------------------------------
L048_00000956:
; H048+$00000956: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000958:
; H048+$00000958: 287af6aa  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_0000095C:
; H048+$0000095C: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L048_00000960:
; H048+$00000960: 3f3c04e1  move.w #$4e1, -(a7)
        move.w #$4e1, -(a7)
L048_00000964:
; H048+$00000964: 487900002bd2  pea.l $2bd2.l
        pea.l (H005+$2BD2).l
L048_0000096A:
; H048+$0000096A: 3f3c04e2  move.w #$4e2, -(a7)
        move.w #$4e2, -(a7)
L048_0000096E:
; H048+$0000096E: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L048_00000970:
; H048+$00000970: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L048_00000976:
; H048+$00000976: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L048_0000097C:
; H048+$0000097C: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000097E:
; H048+$0000097E: 14390000247b  move.b $247b.l, d2
        move.b (H005+$247B).l, d2
L048_00000984:
; H048+$00000984: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000986:
; H048+$00000986: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_0000098A:
; H048+$0000098A: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L048_0000098C:
; H048+$0000098C: 62000112  bhi.w $aa0
        bhi.w H048+$AA0
L048_00000990:
; H048+$00000990: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_00000994:
; H048+$00000994: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000996:
; H048+$00000996: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_0000099A:
; H048+$0000099A: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_000009A0:
; H048+$000009A0: 7800  moveq #$0, d4
        moveq #0, d4
L048_000009A2:
; H048+$000009A2: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_000009A6:
; H048+$000009A6: 4a44  tst.w d4
        tst.w d4
L048_000009A8:
; H048+$000009A8: 630000ee  bls.w $a98
        bls.w H048+$A98
L048_000009AC:
; H048+$000009AC: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L048_000009B0:
; H048+$000009B0: 0c6d0003fffc  cmpi.w #$3, -$4(a5)
        cmpi.w #$3, -$4(a5)
L048_000009B6:
; H048+$000009B6: 62000080  bhi.w $a38
        bhi.w H048+$A38
L048_000009BA:
; H048+$000009BA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000009BE:
; H048+$000009BE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000009C0:
; H048+$000009C0: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_000009C4:
; H048+$000009C4: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_000009CA:
; H048+$000009CA: 7800  moveq #$0, d4
        moveq #0, d4
L048_000009CC:
; H048+$000009CC: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_000009D0:
; H048+$000009D0: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_000009D2:
; H048+$000009D2: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L048_000009D6:
; H048+$000009D6: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L048_000009DA:
; H048+$000009DA: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_000009DE:
; H048+$000009DE: 6100f664  bsr.w $44
        bsr.w H048+$44
L048_000009E2:
; H048+$000009E2: 1400  move.b d0, d2
        move.b d0, d2
L048_000009E4:
; H048+$000009E4: 4a02  tst.b d2
        tst.b d2
L048_000009E6:
; H048+$000009E6: 67000048  beq.w $a30
        beq.w H048+$A30
L048_000009EA:
; H048+$000009EA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000009EE:
; H048+$000009EE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000009F0:
; H048+$000009F0: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_000009F4:
; H048+$000009F4: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_000009FA:
; H048+$000009FA: 38332802  move.w $2(a3, d2.l), d4
        move.w $2(a3, d2.l), d4
L048_000009FE:
; H048+$000009FE: d86dfff8  add.w -$8(a5), d4
        add.w -$8(a5), d4
L048_00000A02:
; H048+$00000A02: c9fc0032  muls.w #$32, d4
        muls.w #$32, d4
L048_00000A06:
; H048+$00000A06: 47f900002bd2  lea.l $2bd2.l, a3
        lea.l (H005+$2BD2).l, a3
L048_00000A0C:
; H048+$00000A0C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_00000A10:
; H048+$00000A10: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000A12:
; H048+$00000A12: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00000A16:
; H048+$00000A16: 45f900003154  lea.l $3154.l, a2
        lea.l (H005+$3154).l, a2
L048_00000A1C:
; H048+$00000A1C: 3c322800  move.w (a2, d2.l), d6
        move.w (a2, d2.l), d6
L048_00000A20:
; H048+$00000A20: dc6dfffa  add.w -$6(a5), d6
        add.w -$6(a5), d6
L048_00000A24:
; H048+$00000A24: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L048_00000A28:
; H048+$00000A28: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_00000A2C:
; H048+$00000A2C: 17826000  move.b d2, (a3, d6.w)
        move.b d2, (a3, d6.w)
L048_00000A30:
; H048+$00000A30: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L048_00000A34:
; H048+$00000A34: 6400ff7a  bcc.w $9b0
        bcc.w H048+$9B0
L048_00000A38:
; H048+$00000A38: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_00000A3C:
; H048+$00000A3C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000A3E:
; H048+$00000A3E: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_00000A40:
; H048+$00000A40: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_00000A46:
; H048+$00000A46: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_00000A4A:
; H048+$00000A4A: 5344  subq.w #$1, d4
        subq.w #$1, d4
L048_00000A4C:
; H048+$00000A4C: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L048_00000A50:
; H048+$00000A50: 45f900003154  lea.l $3154.l, a2
        lea.l (H005+$3154).l, a2
L048_00000A56:
; H048+$00000A56: 3c324800  move.w (a2, d4.l), d6
        move.w (a2, d4.l), d6
L048_00000A5A:
; H048+$00000A5A: 247900002ade  movea.l $2ade.l, a2
        movea.l (H005+$2ADE).l, a2
L048_00000A60:
; H048+$00000A60: 9c6a0002  sub.w $2(a2), d6
        sub.w $2(a2), d6
L048_00000A64:
; H048+$00000A64: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L048_00000A68:
; H048+$00000A68: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_00000A6C:
; H048+$00000A6C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000A6E:
; H048+$00000A6E: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_00000A70:
; H048+$00000A70: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_00000A76:
; H048+$00000A76: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L048_00000A7A:
; H048+$00000A7A: 5344  subq.w #$1, d4
        subq.w #$1, d4
L048_00000A7C:
; H048+$00000A7C: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L048_00000A80:
; H048+$00000A80: 45f900003154  lea.l $3154.l, a2
        lea.l (H005+$3154).l, a2
L048_00000A86:
; H048+$00000A86: 3c324802  move.w $2(a2, d4.l), d6
        move.w $2(a2, d4.l), d6
L048_00000A8A:
; H048+$00000A8A: 247900002ade  movea.l $2ade.l, a2
        movea.l (H005+$2ADE).l, a2
L048_00000A90:
; H048+$00000A90: 9c6a0004  sub.w $4(a2), d6
        sub.w $4(a2), d6
L048_00000A94:
; H048+$00000A94: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L048_00000A98:
; H048+$00000A98: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L048_00000A9C:
; H048+$00000A9C: 6400fee8  bcc.w $986
        bcc.w H048+$986
L048_00000AA0:
; H048+$00000AA0: 548f  addq.l #$2, a7
        addq.l #$2, a7
L048_00000AA2:
; H048+$00000AA2: 4e5d  unlk a5
        unlk a5
L048_00000AA4:
; H048+$00000AA4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000AA6:
; H048+$00000AA6: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000AA8 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H085+$38C4, H048+$0F96, H048+$0FC8, H048+$111A, H048+$16F2, H048+$1978 e altri 16
; --------------------------------------------------------------------------
L048_00000AA8:
; H048+$00000AA8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000AAA:
; H048+$00000AAA: 287af558  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00000AAE:
; H048+$00000AAE: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L048_00000AB2:
; H048+$00000AB2: 422dffff  clr.b -$1(a5)
        clr.b -$1(a5)
L048_00000AB6:
; H048+$00000AB6: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L048_00000ABA:
; H048+$00000ABA: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L048_00000ABE:
; H048+$00000ABE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00000AC2:
; H048+$00000AC2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000AC4:
; H048+$00000AC4: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00000AC6:
; H048+$00000AC6: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L048_00000ACC:
; H048+$00000ACC: 28332000  move.l (a3, d2.w), d4
        move.l (a3, d2.w), d4
L048_00000AD0:
; H048+$00000AD0: b8ad000c  cmp.l $c(a5), d4
        cmp.l $c(a5), d4
L048_00000AD4:
; H048+$00000AD4: 66000008  bne.w $ade
        bne.w H048+$ADE
L048_00000AD8:
; H048+$00000AD8: 1b7c0001ffff  move.b #$1, -$1(a5)
        move.b #$1, -$1(a5)
L048_00000ADE:
; H048+$00000ADE: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L048_00000AE2:
; H048+$00000AE2: 66000012  bne.w $af6
        bne.w H048+$AF6
L048_00000AE6:
; H048+$00000AE6: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000AE8:
; H048+$00000AE8: 14390000247b  move.b $247b.l, d2
        move.b (H005+$247B).l, d2
L048_00000AEE:
; H048+$00000AEE: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L048_00000AF2:
; H048+$00000AF2: b842  cmp.w d2, d4
        cmp.w d2, d4
L048_00000AF4:
; H048+$00000AF4: 66c4  bne.b $aba
        bne.b H048+$ABA
L048_00000AF6:
; H048+$00000AF6: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L048_00000AFA:
; H048+$00000AFA: 6700000e  beq.w $b0a
        beq.w H048+$B0A
L048_00000AFE:
; H048+$00000AFE: 302dfffc  move.w -$4(a5), d0
        move.w -$4(a5), d0
L048_00000B02:
; H048+$00000B02: 6000000c  bra.w $b10
        bra.w H048+$B10
; Preserved bytes H048+$00000B06..$00000B0A; code/data not fully classified.
        dc.w $6000,$0008
L048_00000B0A:
; H048+$00000B0A: 7000  moveq #$0, d0
        moveq #0, d0
L048_00000B0C:
; H048+$00000B0C: 60000002  bra.w $b10
        bra.w H048+$B10
L048_00000B10:
; H048+$00000B10: 4e5d  unlk a5
        unlk a5
L048_00000B12:
; H048+$00000B12: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000B14:
; H048+$00000B14: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000B16:
; H048+$00000B16: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_00000B18:
; H048+$00000B18: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000B1A [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H029+$16A2, H035+$019A, H029+$16DE.
;   - Richiama H029+$16A2.
;   - Richiama H035+$019A.
;   - Richiama H029+$16DE.
; Chiamanti diretti: H048+$0E40
; --------------------------------------------------------------------------
L048_00000B1A:
; H048+$00000B1A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000B1C:
; H048+$00000B1C: 287af4e6  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00000B20:
; H048+$00000B20: 4e55ffe8  link.w a5, #$ffe8
        link.w a5, #$ffe8
L048_00000B24:
; H048+$00000B24: 422dffe9  clr.b -$17(a5)
        clr.b -$17(a5)
L048_00000B28:
; H048+$00000B28: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000B2E:
; H048+$00000B2E: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L048_00000B32:
; H048+$00000B32: 5642  addq.w #$3, d2
        addq.w #$3, d2
L048_00000B34:
; H048+$00000B34: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L048_00000B38:
; H048+$00000B38: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000B3E:
; H048+$00000B3E: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L048_00000B42:
; H048+$00000B42: 5642  addq.w #$3, d2
        addq.w #$3, d2
L048_00000B44:
; H048+$00000B44: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L048_00000B48:
; H048+$00000B48: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000B4A:
; H048+$00000B4A: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L048_00000B4E:
; H048+$00000B4E: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L048_00000B52:
; H048+$00000B52: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000B54:
; H048+$00000B54: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L048_00000B58:
; H048+$00000B58: 0c4200ff  cmpi.w #$ff, d2
        cmpi.w #$ff, d2
L048_00000B5C:
; H048+$00000B5C: 66000006  bne.w $b64
        bne.w H048+$B64
L048_00000B60:
; H048+$00000B60: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L048_00000B64:
; H048+$00000B64: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L048_00000B68:
; H048+$00000B68: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L048_00000B6C:
; H048+$00000B6C: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L048_00000B70:
; H048+$00000B70: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L048_00000B74:
; H048+$00000B74: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L048_00000B78:
; H048+$00000B78: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L048_00000B7C:
; H048+$00000B7C: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_00000B80:
; H048+$00000B80: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L048_00000B84:
; H048+$00000B84: 3b42ffec  move.w d2, -$14(a5)
        move.w d2, -$14(a5)
L048_00000B88:
; H048+$00000B88: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_00000B8C:
; H048+$00000B8C: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L048_00000B90:
; H048+$00000B90: 3b42ffea  move.w d2, -$16(a5)
        move.w d2, -$16(a5)
L048_00000B94:
; H048+$00000B94: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000B96:
; H048+$00000B96: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L048_00000B9A:
; H048+$00000B9A: 0c4200ff  cmpi.w #$ff, d2
        cmpi.w #$ff, d2
L048_00000B9E:
; H048+$00000B9E: 6700003a  beq.w $bda
        beq.w H048+$BDA
L048_00000BA2:
; H048+$00000BA2: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_00000BA6:
; H048+$00000BA6: b46dfff0  cmp.w -$10(a5), d2
        cmp.w -$10(a5), d2
L048_00000BAA:
; H048+$00000BAA: 6d00002e  blt.w $bda
        blt.w H048+$BDA
L048_00000BAE:
; H048+$00000BAE: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_00000BB2:
; H048+$00000BB2: b46dffee  cmp.w -$12(a5), d2
        cmp.w -$12(a5), d2
L048_00000BB6:
; H048+$00000BB6: 6e000022  bgt.w $bda
        bgt.w H048+$BDA
L048_00000BBA:
; H048+$00000BBA: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000BBE:
; H048+$00000BBE: b46dffec  cmp.w -$14(a5), d2
        cmp.w -$14(a5), d2
L048_00000BC2:
; H048+$00000BC2: 6d000016  blt.w $bda
        blt.w H048+$BDA
L048_00000BC6:
; H048+$00000BC6: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000BCA:
; H048+$00000BCA: b46dffea  cmp.w -$16(a5), d2
        cmp.w -$16(a5), d2
L048_00000BCE:
; H048+$00000BCE: 6e00000a  bgt.w $bda
        bgt.w H048+$BDA
L048_00000BD2:
; H048+$00000BD2: 102dffe9  move.b -$17(a5), d0
        move.b -$17(a5), d0
L048_00000BD6:
; H048+$00000BD6: 60000210  bra.w $de8
        bra.w H048+$DE8
; -> H029+$16A2 (sub_H029_000016A2)
L048_00000BDA:
; H048+$00000BDA: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
L048_00000BE0:
; H048+$00000BE0: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_00000BE4:
; H048+$00000BE4: b46dfff0  cmp.w -$10(a5), d2
        cmp.w -$10(a5), d2
L048_00000BE8:
; H048+$00000BE8: 6c000022  bge.w $c0c
        bge.w H048+$C0C
L048_00000BEC:
; H048+$00000BEC: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_00000BF0:
; H048+$00000BF0: b46dfff4  cmp.w -$c(a5), d2
        cmp.w -$c(a5), d2
L048_00000BF4:
; H048+$00000BF4: 6c000012  bge.w $c08
        bge.w H048+$C08
L048_00000BF8:
; H048+$00000BF8: 0c6d0003fff4  cmpi.w #$3, -$c(a5)
        cmpi.w #$3, -$c(a5)
L048_00000BFE:
; H048+$00000BFE: 6f000008  ble.w $c08
        ble.w H048+$C08
L048_00000C02:
; H048+$00000C02: 536dfff4  subq.w #$1, -$c(a5)
        subq.w #$1, -$c(a5)
L048_00000C06:
; H048+$00000C06: 60e4  bra.b $bec
        bra.b H048+$BEC
L048_00000C08:
; H048+$00000C08: 6000002a  bra.w $c34
        bra.w H048+$C34
L048_00000C0C:
; H048+$00000C0C: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_00000C10:
; H048+$00000C10: b46dffee  cmp.w -$12(a5), d2
        cmp.w -$12(a5), d2
L048_00000C14:
; H048+$00000C14: 6f00001e  ble.w $c34
        ble.w H048+$C34
L048_00000C18:
; H048+$00000C18: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L048_00000C1C:
; H048+$00000C1C: b46dfff4  cmp.w -$c(a5), d2
        cmp.w -$c(a5), d2
L048_00000C20:
; H048+$00000C20: 6f000012  ble.w $c34
        ble.w H048+$C34
L048_00000C24:
; H048+$00000C24: 0c6d002efff4  cmpi.w #$2e, -$c(a5)
        cmpi.w #$2e, -$c(a5)
L048_00000C2A:
; H048+$00000C2A: 6c000008  bge.w $c34
        bge.w H048+$C34
L048_00000C2E:
; H048+$00000C2E: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L048_00000C32:
; H048+$00000C32: 60e4  bra.b $c18
        bra.b H048+$C18
L048_00000C34:
; H048+$00000C34: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000C38:
; H048+$00000C38: b46dffec  cmp.w -$14(a5), d2
        cmp.w -$14(a5), d2
L048_00000C3C:
; H048+$00000C3C: 6c000022  bge.w $c60
        bge.w H048+$C60
L048_00000C40:
; H048+$00000C40: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000C44:
; H048+$00000C44: b46dfff2  cmp.w -$e(a5), d2
        cmp.w -$e(a5), d2
L048_00000C48:
; H048+$00000C48: 6c000012  bge.w $c5c
        bge.w H048+$C5C
L048_00000C4C:
; H048+$00000C4C: 0c6d0003fff2  cmpi.w #$3, -$e(a5)
        cmpi.w #$3, -$e(a5)
L048_00000C52:
; H048+$00000C52: 6f000008  ble.w $c5c
        ble.w H048+$C5C
L048_00000C56:
; H048+$00000C56: 536dfff2  subq.w #$1, -$e(a5)
        subq.w #$1, -$e(a5)
L048_00000C5A:
; H048+$00000C5A: 60e4  bra.b $c40
        bra.b H048+$C40
L048_00000C5C:
; H048+$00000C5C: 6000002a  bra.w $c88
        bra.w H048+$C88
L048_00000C60:
; H048+$00000C60: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000C64:
; H048+$00000C64: b46dffea  cmp.w -$16(a5), d2
        cmp.w -$16(a5), d2
L048_00000C68:
; H048+$00000C68: 6f00001e  ble.w $c88
        ble.w H048+$C88
L048_00000C6C:
; H048+$00000C6C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000C70:
; H048+$00000C70: b46dfff2  cmp.w -$e(a5), d2
        cmp.w -$e(a5), d2
L048_00000C74:
; H048+$00000C74: 6f000012  ble.w $c88
        ble.w H048+$C88
L048_00000C78:
; H048+$00000C78: 0c6d0015fff2  cmpi.w #$15, -$e(a5)
        cmpi.w #$15, -$e(a5)
L048_00000C7E:
; H048+$00000C7E: 6c000008  bge.w $c88
        bge.w H048+$C88
L048_00000C82:
; H048+$00000C82: 526dfff2  addq.w #$1, -$e(a5)
        addq.w #$1, -$e(a5)
L048_00000C86:
; H048+$00000C86: 60e4  bra.b $c6c
        bra.b H048+$C6C
L048_00000C88:
; H048+$00000C88: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L048_00000C8C:
; H048+$00000C8C: 5742  subq.w #$3, d2
        subq.w #$3, d2
L048_00000C8E:
; H048+$00000C8E: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000C94:
; H048+$00000C94: 37420002  move.w d2, $2(a3)
        move.w d2, $2(a3)
L048_00000C98:
; H048+$00000C98: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_00000C9C:
; H048+$00000C9C: 5742  subq.w #$3, d2
        subq.w #$3, d2
L048_00000C9E:
; H048+$00000C9E: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000CA4:
; H048+$00000CA4: 37420004  move.w d2, $4(a3)
        move.w d2, $4(a3)
L048_00000CA8:
; H048+$00000CA8: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L048_00000CAC:
; H048+$00000CAC: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000CB2:
; H048+$00000CB2: 3b6b0004fff2  move.w $4(a3), -$e(a5)
        move.w $4(a3), -$e(a5)
L048_00000CB8:
; H048+$00000CB8: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L048_00000CBC:
; H048+$00000CBC: 0c6d0006fff6  cmpi.w #$6, -$a(a5)
        cmpi.w #$6, -$a(a5)
L048_00000CC2:
; H048+$00000CC2: 6e00010c  bgt.w $dd0
        bgt.w H048+$DD0
L048_00000CC6:
; H048+$00000CC6: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L048_00000CCA:
; H048+$00000CCA: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000CD0:
; H048+$00000CD0: 3b6b0002fff4  move.w $2(a3), -$c(a5)
        move.w $2(a3), -$c(a5)
L048_00000CD6:
; H048+$00000CD6: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L048_00000CDA:
; H048+$00000CDA: 0c6d0006fff8  cmpi.w #$6, -$8(a5)
        cmpi.w #$6, -$8(a5)
L048_00000CE0:
; H048+$00000CE0: 6e0000de  bgt.w $dc0
        bgt.w H048+$DC0
L048_00000CE4:
; H048+$00000CE4: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L048_00000CE8:
; H048+$00000CE8: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L048_00000CEC:
; H048+$00000CEC: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_00000CF0:
; H048+$00000CF0: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_00000CF4:
; H048+$00000CF4: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000CFA:
; H048+$00000CFA: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000CFE:
; H048+$00000CFE: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L048_00000D02:
; H048+$00000D02: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00000D04:
; H048+$00000D04: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_00000D08:
; H048+$00000D08: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000D0A:
; H048+$00000D0A: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_00000D0E:
; H048+$00000D0E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000D10:
; H048+$00000D10: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00000D12:
; H048+$00000D12: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_00000D18:
; H048+$00000D18: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_00000D1C:
; H048+$00000D1C: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_00000D1E:
; H048+$00000D1E: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_00000D24:
; H048+$00000D24: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_00000D28:
; H048+$00000D28: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_00000D2C:
; H048+$00000D2C: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000D32:
; H048+$00000D32: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000D36:
; H048+$00000D36: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L048_00000D3A:
; H048+$00000D3A: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00000D3C:
; H048+$00000D3C: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_00000D40:
; H048+$00000D40: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000D42:
; H048+$00000D42: 14334000  move.b (a3, d4.w), d2
        move.b (a3, d4.w), d2
L048_00000D46:
; H048+$00000D46: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L048_00000D4A:
; H048+$00000D4A: c9fc0064  muls.w #$64, d4
        muls.w #$64, d4
L048_00000D4E:
; H048+$00000D4E: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000D54:
; H048+$00000D54: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000D58:
; H048+$00000D58: 3c2dfff4  move.w -$c(a5), d6
        move.w -$c(a5), d6
L048_00000D5C:
; H048+$00000D5C: e346  asl.w #$1, d6
        asl.w #$1, d6
L048_00000D5E:
; H048+$00000D5E: 47f34800  lea.l (a3, d4.l), a3
        lea.l (a3, d4.l), a3
L048_00000D62:
; H048+$00000D62: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000D64:
; H048+$00000D64: 18336001  move.b $1(a3, d6.w), d4
        move.b $1(a3, d6.w), d4
L048_00000D68:
; H048+$00000D68: b444  cmp.w d4, d2
        cmp.w d4, d2
L048_00000D6A:
; H048+$00000D6A: 67000044  beq.w $db0
        beq.w H048+$DB0
L048_00000D6E:
; H048+$00000D6E: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L048_00000D72:
; H048+$00000D72: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L048_00000D76:
; H048+$00000D76: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_00000D7A:
; H048+$00000D7A: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_00000D7E:
; H048+$00000D7E: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000D84:
; H048+$00000D84: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_00000D88:
; H048+$00000D88: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L048_00000D8C:
; H048+$00000D8C: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00000D8E:
; H048+$00000D8E: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_00000D92:
; H048+$00000D92: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000D94:
; H048+$00000D94: 14334001  move.b $1(a3, d4.w), d2
        move.b $1(a3, d4.w), d2
L048_00000D98:
; H048+$00000D98: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000D9A:
; H048+$00000D9A: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00000D9C:
; H048+$00000D9C: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_00000DA2:
; H048+$00000DA2: 1f332003  move.b $3(a3, d2.w), -(a7)
        move.b $3(a3, d2.w), -(a7)
L048_00000DA6:
; H048+$00000DA6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H035+$019A (sub_H035_0000019A)
L048_00000DAA:
; H048+$00000DAA: 4eb90000019a  jsr $19a.l
        jsr (H035+$19A).l
L048_00000DB0:
; H048+$00000DB0: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L048_00000DB4:
; H048+$00000DB4: 526dfff4  addq.w #$1, -$c(a5)
        addq.w #$1, -$c(a5)
L048_00000DB8:
; H048+$00000DB8: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L048_00000DBC:
; H048+$00000DBC: 6800ff1c  bvc.w $cda
        bvc.w H048+$CDA
L048_00000DC0:
; H048+$00000DC0: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L048_00000DC4:
; H048+$00000DC4: 526dfff2  addq.w #$1, -$e(a5)
        addq.w #$1, -$e(a5)
L048_00000DC8:
; H048+$00000DC8: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L048_00000DCC:
; H048+$00000DCC: 6800feee  bvc.w $cbc
        bvc.w H048+$CBC
L048_00000DD0:
; H048+$00000DD0: 6100f2f0  bsr.w $c2
        bsr.w H048+$C2
L048_00000DD4:
; H048+$00000DD4: 1b7c0001ffe9  move.b #$1, -$17(a5)
        move.b #$1, -$17(a5)
; -> H029+$16DE (sub_H029_000016DE)
L048_00000DDA:
; H048+$00000DDA: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L048_00000DE0:
; H048+$00000DE0: 102dffe9  move.b -$17(a5), d0
        move.b -$17(a5), d0
L048_00000DE4:
; H048+$00000DE4: 60000002  bra.w $de8
        bra.w H048+$DE8
L048_00000DE8:
; H048+$00000DE8: 4e5d  unlk a5
        unlk a5
L048_00000DEA:
; H048+$00000DEA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000DEC:
; H048+$00000DEC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000DEE:
; H048+$00000DEE: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L048_00000DF0:
; H048+$00000DF0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000DF2 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H029+$16A2, H035+$0460, H029+$16DE.
;   - Richiama H029+$16A2.
;   - Richiama H035+$0460.
;   - Richiama H029+$16DE.
; Chiamanti diretti: H085+$3910, H085+$16F2, H048+$19BC, H027+$29B6, H063+$27EE, H085+$2AFE e altri 21
; --------------------------------------------------------------------------
L048_00000DF2:
; H048+$00000DF2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000DF4:
; H048+$00000DF4: 287af20e  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00000DF8:
; H048+$00000DF8: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
; -> H029+$16A2 (sub_H029_000016A2)
L048_00000DFC:
; H048+$00000DFC: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
L048_00000E02:
; H048+$00000E02: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_00000E06:
; H048+$00000E06: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_00000E08:
; H048+$00000E08: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L048_00000E0E:
; H048+$00000E0E: 382d0012  move.w $12(a5), d4
        move.w $12(a5), d4
L048_00000E12:
; H048+$00000E12: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L048_00000E16:
; H048+$00000E16: 3b44fff8  move.w d4, -$8(a5)
        move.w d4, -$8(a5)
L048_00000E1A:
; H048+$00000E1A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L048_00000E1E:
; H048+$00000E1E: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_00000E20:
; H048+$00000E20: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L048_00000E26:
; H048+$00000E26: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L048_00000E2A:
; H048+$00000E2A: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L048_00000E2E:
; H048+$00000E2E: 3b44fff6  move.w d4, -$a(a5)
        move.w d4, -$a(a5)
L048_00000E32:
; H048+$00000E32: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L048_00000E36:
; H048+$00000E36: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L048_00000E3A:
; H048+$00000E3A: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L048_00000E3E:
; H048+$00000E3E: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L048_00000E40:
; H048+$00000E40: 6100fcd8  bsr.w $b1a
        bsr.w H048+$B1A
L048_00000E44:
; H048+$00000E44: 1400  move.b d0, d2
        move.b d0, d2
L048_00000E46:
; H048+$00000E46: 4a02  tst.b d2
        tst.b d2
L048_00000E48:
; H048+$00000E48: 670000aa  beq.w $ef4
        beq.w H048+$EF4
L048_00000E4C:
; H048+$00000E4C: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L048_00000E52:
; H048+$00000E52: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000E54:
; H048+$00000E54: 14390000247b  move.b $247b.l, d2
        move.b (H005+$247B).l, d2
L048_00000E5A:
; H048+$00000E5A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000E5C:
; H048+$00000E5C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_00000E60:
; H048+$00000E60: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L048_00000E62:
; H048+$00000E62: 6200008e  bhi.w $ef2
        bhi.w H048+$EF2
L048_00000E66:
; H048+$00000E66: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_00000E6A:
; H048+$00000E6A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000E6C:
; H048+$00000E6C: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00000E6E:
; H048+$00000E6E: 47f900002b32  lea.l $2b32.l, a3
        lea.l (H005+$2B32).l, a3
L048_00000E74:
; H048+$00000E74: 2b732000fffc  move.l (a3, d2.w), -$4(a5)
        move.l (a3, d2.w), -$4(a5)
L048_00000E7A:
; H048+$00000E7A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L048_00000E7E:
; H048+$00000E7E: 4a2b0198  tst.b $198(a3)
        tst.b $198(a3)
L048_00000E82:
; H048+$00000E82: 67000066  beq.w $eea
        beq.w H048+$EEA
L048_00000E86:
; H048+$00000E86: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_00000E8A:
; H048+$00000E8A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000E8C:
; H048+$00000E8C: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00000E90:
; H048+$00000E90: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00000E96:
; H048+$00000E96: 7800  moveq #$0, d4
        moveq #0, d4
L048_00000E98:
; H048+$00000E98: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_00000E9C:
; H048+$00000E9C: 4a44  tst.w d4
        tst.w d4
L048_00000E9E:
; H048+$00000E9E: 6300004a  bls.w $eea
        bls.w H048+$EEA
L048_00000EA2:
; H048+$00000EA2: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_00000EA6:
; H048+$00000EA6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000EA8:
; H048+$00000EA8: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_00000EAA:
; H048+$00000EAA: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_00000EB0:
; H048+$00000EB0: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_00000EB4:
; H048+$00000EB4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_00000EB8:
; H048+$00000EB8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000EBA:
; H048+$00000EBA: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_00000EBC:
; H048+$00000EBC: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_00000EC2:
; H048+$00000EC2: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_00000EC6:
; H048+$00000EC6: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L048_00000ECA:
; H048+$00000ECA: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_00000ECE:
; H048+$00000ECE: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000ED0:
; H048+$00000ED0: 142b000b  move.b $b(a3), d2
        move.b $b(a3), d2
L048_00000ED4:
; H048+$00000ED4: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000ED6:
; H048+$00000ED6: 4267  clr.w -(a7)
        clr.w -(a7)
L048_00000ED8:
; H048+$00000ED8: 7400  moveq #$0, d2
        moveq #0, d2
L048_00000EDA:
; H048+$00000EDA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L048_00000EDE:
; H048+$00000EDE: 142b0143  move.b $143(a3), d2
        move.b $143(a3), d2
L048_00000EE2:
; H048+$00000EE2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L048_00000EE4:
; H048+$00000EE4: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L048_00000EEA:
; H048+$00000EEA: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L048_00000EEE:
; H048+$00000EEE: 6400ff6c  bcc.w $e5c
        bcc.w H048+$E5C
L048_00000EF2:
; H048+$00000EF2: 548f  addq.l #$2, a7
        addq.l #$2, a7
L048_00000EF4:
; H048+$00000EF4: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L048_00000EF8:
; H048+$00000EF8: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L048_00000EFC:
; H048+$00000EFC: 6100f986  bsr.w $884
        bsr.w H048+$884
L048_00000F00:
; H048+$00000F00: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L048_00000F04:
; H048+$00000F04: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000F0A:
; H048+$00000F0A: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L048_00000F0E:
; H048+$00000F0E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000F10:
; H048+$00000F10: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L048_00000F14:
; H048+$00000F14: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00000F1A:
; H048+$00000F1A: 946b0004  sub.w $4(a3), d2
        sub.w $4(a3), d2
L048_00000F1E:
; H048+$00000F1E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00000F20:
; H048+$00000F20: 6100f2c6  bsr.w $1e8
        bsr.w H048+$1E8
L048_00000F24:
; H048+$00000F24: 1400  move.b d0, d2
        move.b d0, d2
L048_00000F26:
; H048+$00000F26: 4a02  tst.b d2
        tst.b d2
L048_00000F28:
; H048+$00000F28: 66000042  bne.w $f6c
        bne.w H048+$F6C
L048_00000F2C:
; H048+$00000F2C: 0c6d0031fff8  cmpi.w #$31, -$8(a5)
        cmpi.w #$31, -$8(a5)
L048_00000F32:
; H048+$00000F32: 6f00000c  ble.w $f40
        ble.w H048+$F40
L048_00000F36:
; H048+$00000F36: 3b7c0031fff8  move.w #$31, -$8(a5)
        move.w #$31, -$8(a5)
L048_00000F3C:
; H048+$00000F3C: 6000000e  bra.w $f4c
        bra.w H048+$F4C
L048_00000F40:
; H048+$00000F40: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L048_00000F44:
; H048+$00000F44: 6c000006  bge.w $f4c
        bge.w H048+$F4C
L048_00000F48:
; H048+$00000F48: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L048_00000F4C:
; H048+$00000F4C: 0c6d0018fff6  cmpi.w #$18, -$a(a5)
        cmpi.w #$18, -$a(a5)
L048_00000F52:
; H048+$00000F52: 6f00000c  ble.w $f60
        ble.w H048+$F60
L048_00000F56:
; H048+$00000F56: 3b7c0018fff6  move.w #$18, -$a(a5)
        move.w #$18, -$a(a5)
L048_00000F5C:
; H048+$00000F5C: 6000000e  bra.w $f6c
        bra.w H048+$F6C
L048_00000F60:
; H048+$00000F60: 4a6dfff6  tst.w -$a(a5)
        tst.w -$a(a5)
L048_00000F64:
; H048+$00000F64: 6c000006  bge.w $f6c
        bge.w H048+$F6C
L048_00000F68:
; H048+$00000F68: 426dfff6  clr.w -$a(a5)
        clr.w -$a(a5)
L048_00000F6C:
; H048+$00000F6C: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L048_00000F70:
; H048+$00000F70: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L048_00000F74:
; H048+$00000F74: 6100f3be  bsr.w $334
        bsr.w H048+$334
; -> H029+$16DE (sub_H029_000016DE)
L048_00000F78:
; H048+$00000F78: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L048_00000F7E:
; H048+$00000F7E: 4e5d  unlk a5
        unlk a5
L048_00000F80:
; H048+$00000F80: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000F82:
; H048+$00000F82: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000F84:
; H048+$00000F84: 508f  addq.l #$8, a7
        addq.l #$8, a7
L048_00000F86:
; H048+$00000F86: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000F88 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$1A52, H027+$1E54, H027+$22A2, H027+$2A64, H027+$2ADE, H027+$2AFA e altri 53
; --------------------------------------------------------------------------
L048_00000F88:
; H048+$00000F88: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000F8A:
; H048+$00000F8A: 287af078  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00000F8E:
; H048+$00000F8E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_00000F92:
; H048+$00000F92: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_00000F96:
; H048+$00000F96: 6100fb10  bsr.w $aa8
        bsr.w H048+$AA8
L048_00000F9A:
; H048+$00000F9A: 3400  move.w d0, d2
        move.w d0, d2
L048_00000F9C:
; H048+$00000F9C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000F9E:
; H048+$00000F9E: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00000FA2:
; H048+$00000FA2: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00000FA8:
; H048+$00000FA8: 30332800  move.w (a3, d2.l), d0
        move.w (a3, d2.l), d0
L048_00000FAC:
; H048+$00000FAC: 60000002  bra.w $fb0
        bra.w H048+$FB0
L048_00000FB0:
; H048+$00000FB0: 4e5d  unlk a5
        unlk a5
L048_00000FB2:
; H048+$00000FB2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000FB4:
; H048+$00000FB4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000FB6:
; H048+$00000FB6: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_00000FB8:
; H048+$00000FB8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000FBA [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$1A60, H027+$1E62, H027+$22B0, H027+$2A76, H027+$2AEC, H027+$2B08 e altri 53
; --------------------------------------------------------------------------
L048_00000FBA:
; H048+$00000FBA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000FBC:
; H048+$00000FBC: 287af046  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00000FC0:
; H048+$00000FC0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_00000FC4:
; H048+$00000FC4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_00000FC8:
; H048+$00000FC8: 6100fade  bsr.w $aa8
        bsr.w H048+$AA8
L048_00000FCC:
; H048+$00000FCC: 3400  move.w d0, d2
        move.w d0, d2
L048_00000FCE:
; H048+$00000FCE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00000FD0:
; H048+$00000FD0: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00000FD4:
; H048+$00000FD4: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00000FDA:
; H048+$00000FDA: 30332802  move.w $2(a3, d2.l), d0
        move.w $2(a3, d2.l), d0
L048_00000FDE:
; H048+$00000FDE: 60000002  bra.w $fe2
        bra.w H048+$FE2
L048_00000FE2:
; H048+$00000FE2: 4e5d  unlk a5
        unlk a5
L048_00000FE4:
; H048+$00000FE4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00000FE6:
; H048+$00000FE6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00000FE8:
; H048+$00000FE8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_00000FEA:
; H048+$00000FEA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_00000FEC [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H029+$16A2, H035+$0460, H029+$16DE.
;   - Richiama H029+$16A2.
;   - Richiama H035+$0460.
;   - Richiama H029+$16DE.
; Chiamanti diretti: H096+$226A, H096+$229C, H096+$24EA, H096+$2504, H033+$1624, H033+$16CA e altri 3
; --------------------------------------------------------------------------
L048_00000FEC:
; H048+$00000FEC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00000FEE:
; H048+$00000FEE: 287af014  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00000FF2:
; H048+$00000FF2: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
; -> H029+$16A2 (sub_H029_000016A2)
L048_00000FF6:
; H048+$00000FF6: 4eb9000016a2  jsr $16a2.l
        jsr (H029+$16A2).l
L048_00000FFC:
; H048+$00000FFC: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L048_00001000:
; H048+$00001000: 6100faa6  bsr.w $aa8
        bsr.w H048+$AA8
L048_00001004:
; H048+$00001004: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L048_00001008:
; H048+$00001008: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L048_0000100C:
; H048+$0000100C: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L048_00001010:
; H048+$00001010: 6100f21e  bsr.w $230
        bsr.w H048+$230
L048_00001014:
; H048+$00001014: 1400  move.b d0, d2
        move.b d0, d2
L048_00001016:
; H048+$00001016: 4a02  tst.b d2
        tst.b d2
L048_00001018:
; H048+$00001018: 6600002a  bne.w $1044
        bne.w H048+$1044
L048_0000101C:
; H048+$0000101C: 4a39000024c6  tst.b $24c6.l
        tst.b (H005+$24C6).l
L048_00001022:
; H048+$00001022: 67000020  beq.w $1044
        beq.w H048+$1044
L048_00001026:
; H048+$00001026: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L048_0000102A:
; H048+$0000102A: 6100ff5c  bsr.w $f88
        bsr.w H048+$F88
L048_0000102E:
; H048+$0000102E: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L048_00001030:
; H048+$00001030: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L048_00001034:
; H048+$00001034: 6184  bsr.b $fba
        bsr.b H048+$FBA
L048_00001036:
; H048+$00001036: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L048_00001038:
; H048+$00001038: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L048_0000103C:
; H048+$0000103C: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L048_00001040:
; H048+$00001040: 6100fdb0  bsr.w $df2
        bsr.w H048+$DF2
L048_00001044:
; H048+$00001044: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L048_00001048:
; H048+$00001048: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_0000104C:
; H048+$0000104C: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000104E:
; H048+$0000104E: 142b000b  move.b $b(a3), d2
        move.b $b(a3), d2
L048_00001052:
; H048+$00001052: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L048_00001058:
; H048+$00001058: e44a  lsr.w #$2, d2
        lsr.w #$2, d2
L048_0000105A:
; H048+$0000105A: 7800  moveq #$0, d4
        moveq #0, d4
L048_0000105C:
; H048+$0000105C: 182d0010  move.b $10(a5), d4
        move.b $10(a5), d4
L048_00001060:
; H048+$00001060: 02840000ffff  andi.l #$ffff, d4
        andi.l #$ffff, d4
L048_00001066:
; H048+$00001066: e44c  lsr.w #$2, d4
        lsr.w #$2, d4
L048_00001068:
; H048+$00001068: b444  cmp.w d4, d2
        cmp.w d4, d2
L048_0000106A:
; H048+$0000106A: 66000012  bne.w $107e
        bne.w H048+$107E
L048_0000106E:
; H048+$0000106E: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L048_00001072:
; H048+$00001072: 6600000a  bne.w $107e
        bne.w H048+$107E
L048_00001076:
; H048+$00001076: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L048_0000107A:
; H048+$0000107A: 67000018  beq.w $1094
        beq.w H048+$1094
L048_0000107E:
; H048+$0000107E: 4a39000024c6  tst.b $24c6.l
        tst.b (H005+$24C6).l
L048_00001084:
; H048+$00001084: 6700000e  beq.w $1094
        beq.w H048+$1094
L048_00001088:
; H048+$00001088: 4267  clr.w -(a7)
        clr.w -(a7)
L048_0000108A:
; H048+$0000108A: 4267  clr.w -(a7)
        clr.w -(a7)
L048_0000108C:
; H048+$0000108C: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L048_00001090:
; H048+$00001090: 6100f4f6  bsr.w $588
        bsr.w H048+$588
L048_00001094:
; H048+$00001094: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L048_00001098:
; H048+$00001098: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_0000109C:
; H048+$0000109C: 176d0010000b  move.b $10(a5), $b(a3)
        move.b $10(a5), $b(a3)
L048_000010A2:
; H048+$000010A2: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L048_000010A6:
; H048+$000010A6: 66000052  bne.w $10fa
        bne.w H048+$10FA
L048_000010AA:
; H048+$000010AA: 4a39000024c6  tst.b $24c6.l
        tst.b (H005+$24C6).l
L048_000010B0:
; H048+$000010B0: 67000048  beq.w $10fa
        beq.w H048+$10FA
L048_000010B4:
; H048+$000010B4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000010B8:
; H048+$000010B8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000010BA:
; H048+$000010BA: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000010BC:
; H048+$000010BC: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_000010C2:
; H048+$000010C2: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_000010C6:
; H048+$000010C6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000010CA:
; H048+$000010CA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000010CC:
; H048+$000010CC: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000010CE:
; H048+$000010CE: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_000010D4:
; H048+$000010D4: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L048_000010D8:
; H048+$000010D8: 7400  moveq #$0, d2
        moveq #0, d2
L048_000010DA:
; H048+$000010DA: 142d0010  move.b $10(a5), d2
        move.b $10(a5), d2
L048_000010DE:
; H048+$000010DE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000010E0:
; H048+$000010E0: 7400  moveq #$0, d2
        moveq #0, d2
L048_000010E2:
; H048+$000010E2: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L048_000010E6:
; H048+$000010E6: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000010E8:
; H048+$000010E8: 7400  moveq #$0, d2
        moveq #0, d2
L048_000010EA:
; H048+$000010EA: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L048_000010EE:
; H048+$000010EE: 142b0143  move.b $143(a3), d2
        move.b $143(a3), d2
L048_000010F2:
; H048+$000010F2: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L048_000010F4:
; H048+$000010F4: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
; -> H029+$16DE (sub_H029_000016DE)
L048_000010FA:
; H048+$000010FA: 4eb9000016de  jsr $16de.l
        jsr (H029+$16DE).l
L048_00001100:
; H048+$00001100: 4e5d  unlk a5
        unlk a5
L048_00001102:
; H048+$00001102: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00001104:
; H048+$00001104: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00001106:
; H048+$00001106: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L048_0000110A:
; H048+$0000110A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_0000110C [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H027+$1A76, H027+$1E78, H027+$22C6, H027+$2B72, H027+$31AE, H063+$2E3A e altri 6
; --------------------------------------------------------------------------
L048_0000110C:
; H048+$0000110C: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_0000110E:
; H048+$0000110E: 287aeef4  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00001112:
; H048+$00001112: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_00001116:
; H048+$00001116: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_0000111A:
; H048+$0000111A: 6100f98c  bsr.w $aa8
        bsr.w H048+$AA8
L048_0000111E:
; H048+$0000111E: 3400  move.w d0, d2
        move.w d0, d2
L048_00001120:
; H048+$00001120: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001122:
; H048+$00001122: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00001126:
; H048+$00001126: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_0000112C:
; H048+$0000112C: 10332805  move.b $5(a3, d2.l), d0
        move.b $5(a3, d2.l), d0
L048_00001130:
; H048+$00001130: 60000002  bra.w $1134
        bra.w H048+$1134
L048_00001134:
; H048+$00001134: 4e5d  unlk a5
        unlk a5
L048_00001136:
; H048+$00001136: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00001138:
; H048+$00001138: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_0000113A:
; H048+$0000113A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_0000113C:
; H048+$0000113C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_0000113E [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H048+$1774, H062+$106A, H096+$02FC, H095+$19FA, H059+$0A7C, H097+$125A
; --------------------------------------------------------------------------
L048_0000113E:
; H048+$0000113E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00001140:
; H048+$00001140: 287aeec2  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00001144:
; H048+$00001144: 4e55ffea  link.w a5, #$ffea
        link.w a5, #$ffea
L048_00001148:
; H048+$00001148: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L048_0000114C:
; H048+$0000114C: 4253  clr.w (a3)
        clr.w (a3)
L048_0000114E:
; H048+$0000114E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L048_00001152:
; H048+$00001152: 36bc0017  move.w #$17, (a3)
        move.w #$17, (a3)
L048_00001156:
; H048+$00001156: 3b7c0001fff6  move.w #$1, -$a(a5)
        move.w #$1, -$a(a5)
L048_0000115C:
; H048+$0000115C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L048_00001160:
; H048+$00001160: 4213  clr.b (a3)
        clr.b (a3)
L048_00001162:
; H048+$00001162: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L048_00001166:
; H048+$00001166: 4213  clr.b (a3)
        clr.b (a3)
L048_00001168:
; H048+$00001168: 2f2d001e  move.l $1e(a5), -(a7)
        move.l $1e(a5), -(a7)
L048_0000116C:
; H048+$0000116C: 6100f93a  bsr.w $aa8
        bsr.w H048+$AA8
L048_00001170:
; H048+$00001170: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L048_00001174:
; H048+$00001174: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00001178:
; H048+$00001178: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000117A:
; H048+$0000117A: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_0000117E:
; H048+$0000117E: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00001184:
; H048+$00001184: 3b732800fff0  move.w (a3, d2.l), -$10(a5)
        move.w (a3, d2.l), -$10(a5)
L048_0000118A:
; H048+$0000118A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_0000118E:
; H048+$0000118E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001190:
; H048+$00001190: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00001194:
; H048+$00001194: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_0000119A:
; H048+$0000119A: 3b732802ffee  move.w $2(a3, d2.l), -$12(a5)
        move.w $2(a3, d2.l), -$12(a5)
L048_000011A0:
; H048+$000011A0: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L048_000011A4:
; H048+$000011A4: 0c6d0003fffe  cmpi.w #$3, -$2(a5)
        cmpi.w #$3, -$2(a5)
L048_000011AA:
; H048+$000011AA: 6200013c  bhi.w $12e8
        bhi.w H048+$12E8
L048_000011AE:
; H048+$000011AE: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000011B2:
; H048+$000011B2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000011B4:
; H048+$000011B4: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_000011B8:
; H048+$000011B8: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_000011BE:
; H048+$000011BE: 7800  moveq #$0, d4
        moveq #0, d4
L048_000011C0:
; H048+$000011C0: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_000011C4:
; H048+$000011C4: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_000011C6:
; H048+$000011C6: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L048_000011CA:
; H048+$000011CA: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L048_000011CE:
; H048+$000011CE: 486dffea  pea.l -$16(a5)
        pea.l -$16(a5)
L048_000011D2:
; H048+$000011D2: 6100ee70  bsr.w $44
        bsr.w H048+$44
L048_000011D6:
; H048+$000011D6: 1400  move.b d0, d2
        move.b d0, d2
L048_000011D8:
; H048+$000011D8: 4a02  tst.b d2
        tst.b d2
L048_000011DA:
; H048+$000011DA: 67000104  beq.w $12e0
        beq.w H048+$12E0
L048_000011DE:
; H048+$000011DE: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L048_000011E2:
; H048+$000011E2: d46dffec  add.w -$14(a5), d2
        add.w -$14(a5), d2
L048_000011E6:
; H048+$000011E6: 382d001c  move.w $1c(a5), d4
        move.w $1c(a5), d4
L048_000011EA:
; H048+$000011EA: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_000011EC:
; H048+$000011EC: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L048_000011F2:
; H048+$000011F2: d4734000  add.w (a3, d4.w), d2
        add.w (a3, d4.w), d2
L048_000011F6:
; H048+$000011F6: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L048_000011FA:
; H048+$000011FA: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L048_000011FE:
; H048+$000011FE: d46dffea  add.w -$16(a5), d2
        add.w -$16(a5), d2
L048_00001202:
; H048+$00001202: 382d001c  move.w $1c(a5), d4
        move.w $1c(a5), d4
L048_00001206:
; H048+$00001206: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00001208:
; H048+$00001208: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L048_0000120E:
; H048+$0000120E: d4734000  add.w (a3, d4.w), d2
        add.w (a3, d4.w), d2
L048_00001212:
; H048+$00001212: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L048_00001216:
; H048+$00001216: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L048_0000121A:
; H048+$0000121A: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L048_0000121E:
; H048+$0000121E: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L048_00001222:
; H048+$00001222: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_00001226:
; H048+$00001226: 6100ef2c  bsr.w $154
        bsr.w H048+$154
L048_0000122A:
; H048+$0000122A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_0000122E:
; H048+$0000122E: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L048_00001232:
; H048+$00001232: 66000006  bne.w $123a
        bne.w H048+$123A
L048_00001236:
; H048+$00001236: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L048_0000123A:
; H048+$0000123A: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L048_0000123E:
; H048+$0000123E: 6300000a  bls.w $124a
        bls.w H048+$124A
L048_00001242:
; H048+$00001242: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L048_00001246:
; H048+$00001246: 36adfffa  move.w -$6(a5), (a3)
        move.w -$6(a5), (a3)
L048_0000124A:
; H048+$0000124A: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L048_0000124E:
; H048+$0000124E: 6700000c  beq.w $125c
        beq.w H048+$125C
L048_00001252:
; H048+$00001252: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L048_00001256:
; H048+$00001256: 4a53  tst.w (a3)
        tst.w (a3)
L048_00001258:
; H048+$00001258: 6600000c  bne.w $1266
        bne.w H048+$1266
L048_0000125C:
; H048+$0000125C: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L048_00001260:
; H048+$00001260: 4253  clr.w (a3)
        clr.w (a3)
L048_00001262:
; H048+$00001262: 6000007c  bra.w $12e0
        bra.w H048+$12E0
L048_00001266:
; H048+$00001266: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L048_0000126A:
; H048+$0000126A: 6000005a  bra.w $12c6
        bra.w H048+$12C6
L048_0000126E:
; H048+$0000126E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L048_00001272:
; H048+$00001272: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L048_00001276:
; H048+$00001276: 4e75  rts 
        rts 
L048_00001278:
; H048+$00001278: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L048_0000127C:
; H048+$0000127C: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L048_00001280:
; H048+$00001280: 4e75  rts 
        rts 
L048_00001282:
; H048+$00001282: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L048_00001286:
; H048+$00001286: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001288:
; H048+$00001288: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_0000128A:
; H048+$0000128A: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_00001290:
; H048+$00001290: 7800  moveq #$0, d4
        moveq #0, d4
L048_00001292:
; H048+$00001292: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L048_00001296:
; H048+$00001296: b86dfff6  cmp.w -$a(a5), d4
        cmp.w -$a(a5), d4
L048_0000129A:
; H048+$0000129A: 65000022  bcs.w $12be
        bcs.w H048+$12BE
L048_0000129E:
; H048+$0000129E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L048_000012A2:
; H048+$000012A2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000012A4:
; H048+$000012A4: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_000012A6:
; H048+$000012A6: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_000012AC:
; H048+$000012AC: 7800  moveq #$0, d4
        moveq #0, d4
L048_000012AE:
; H048+$000012AE: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L048_000012B2:
; H048+$000012B2: 3b44fff6  move.w d4, -$a(a5)
        move.w d4, -$a(a5)
L048_000012B6:
; H048+$000012B6: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L048_000012BA:
; H048+$000012BA: 36adfff8  move.w -$8(a5), (a3)
        move.w -$8(a5), (a3)
L048_000012BE:
; H048+$000012BE: 4e75  rts 
        rts 
; Preserved bytes H048+$000012C0..$000012C6; code/data not fully classified.
        dc.w $FFC0,$FFB6,$FFAC
L048_000012C6:
; H048+$000012C6: 47fafffa  lea.l $12c2(pc), a3
        lea.l H048+$12C2(pc), a3
L048_000012CA:
; H048+$000012CA: 0442001d  subi.w #$1d, d2
        subi.w #$1d, d2
L048_000012CE:
; H048+$000012CE: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L048_000012D2:
; H048+$000012D2: 6302  bls.b $12d6
        bls.b H048+$12D6
L048_000012D4:
; H048+$000012D4: 74ff  moveq #$ff, d2
        moveq #-1, d2
L048_000012D6:
; H048+$000012D6: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000012D8:
; H048+$000012D8: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H048+$12C2; indici 0..1, default -1.
L048_000012DC:
; H048+$000012DC: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L048_000012E0:
; H048+$000012E0: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L048_000012E4:
; H048+$000012E4: 6400febe  bcc.w $11a4
        bcc.w H048+$11A4
L048_000012E8:
; H048+$000012E8: 4e5d  unlk a5
        unlk a5
L048_000012EA:
; H048+$000012EA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_000012EC:
; H048+$000012EC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_000012EE:
; H048+$000012EE: 4fef0016  lea.l $16(a7), a7
        lea.l $16(a7), a7
L048_000012F2:
; H048+$000012F2: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_000012F4 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H043+$190E, H030+$0B4A, H029+$0D58, H036+$0034.
;   - Richiama H043+$190E.
;   - Richiama H030+$0B4A.
;   - Richiama H029+$0D58.
;   - Richiama H036+$0034.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H062+$28C0, H062+$03BC, H062+$251A, H096+$0890, H096+$1A72
; --------------------------------------------------------------------------
L048_000012F4:
; H048+$000012F4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_000012F6:
; H048+$000012F6: 287aed0c  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_000012FA:
; H048+$000012FA: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L048_000012FE:
; H048+$000012FE: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L048_00001306:
; H048+$00001306: 67000016  beq.w $131e
        beq.w H048+$131E
L048_0000130A:
; H048+$0000130A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L048_0000130E:
; H048+$0000130E: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
; -> H030+$0B4A (sub_H030_00000B4A)
L048_00001314:
; H048+$00001314: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L048_0000131A:
; H048+$0000131A: 600003ae  bra.w $16ca
        bra.w H048+$16CA
L048_0000131E:
; H048+$0000131E: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L048_00001324:
; H048+$00001324: 0c6d0009fffc  cmpi.w #$9, -$4(a5)
        cmpi.w #$9, -$4(a5)
L048_0000132A:
; H048+$0000132A: 64000024  bcc.w $1350
        bcc.w H048+$1350
L048_0000132E:
; H048+$0000132E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_00001332:
; H048+$00001332: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001334:
; H048+$00001334: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_00001338:
; H048+$00001338: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_0000133E:
; H048+$0000133E: 28332800  move.l (a3, d2.l), d4
        move.l (a3, d2.l), d4
L048_00001342:
; H048+$00001342: b8ad000c  cmp.l $c(a5), d4
        cmp.l $c(a5), d4
L048_00001346:
; H048+$00001346: 67000008  beq.w $1350
        beq.w H048+$1350
L048_0000134A:
; H048+$0000134A: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L048_0000134E:
; H048+$0000134E: 60d4  bra.b $1324
        bra.b H048+$1324
L048_00001350:
; H048+$00001350: 0c6d0009fffc  cmpi.w #$9, -$4(a5)
        cmpi.w #$9, -$4(a5)
L048_00001356:
; H048+$00001356: 64000006  bcc.w $135e
        bcc.w H048+$135E
L048_0000135A:
; H048+$0000135A: 6000036e  bra.w $16ca
        bra.w H048+$16CA
L048_0000135E:
; H048+$0000135E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_00001362:
; H048+$00001362: 6100f744  bsr.w $aa8
        bsr.w H048+$AA8
L048_00001366:
; H048+$00001366: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L048_0000136A:
; H048+$0000136A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_0000136E:
; H048+$0000136E: 6100fc18  bsr.w $f88
        bsr.w H048+$F88
L048_00001372:
; H048+$00001372: 3b40fff4  move.w d0, -$c(a5)
        move.w d0, -$c(a5)
L048_00001376:
; H048+$00001376: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_0000137A:
; H048+$0000137A: 6100fc3e  bsr.w $fba
        bsr.w H048+$FBA
L048_0000137E:
; H048+$0000137E: 3b40fff2  move.w d0, -$e(a5)
        move.w d0, -$e(a5)
L048_00001382:
; H048+$00001382: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_00001386:
; H048+$00001386: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L048_0000138A:
; H048+$0000138A: 6100eea4  bsr.w $230
        bsr.w H048+$230
L048_0000138E:
; H048+$0000138E: 1400  move.b d0, d2
        move.b d0, d2
L048_00001390:
; H048+$00001390: 4a02  tst.b d2
        tst.b d2
L048_00001392:
; H048+$00001392: 66000016  bne.w $13aa
        bne.w H048+$13AA
L048_00001396:
; H048+$00001396: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L048_0000139A:
; H048+$0000139A: 3f2dfff2  move.w -$e(a5), -(a7)
        move.w -$e(a5), -(a7)
L048_0000139E:
; H048+$0000139E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L048_000013A2:
; H048+$000013A2: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L048_000013A6:
; H048+$000013A6: 6100fa4a  bsr.w $df2
        bsr.w H048+$DF2
L048_000013AA:
; H048+$000013AA: 4267  clr.w -(a7)
        clr.w -(a7)
L048_000013AC:
; H048+$000013AC: 4267  clr.w -(a7)
        clr.w -(a7)
L048_000013AE:
; H048+$000013AE: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L048_000013B2:
; H048+$000013B2: 6100f1d4  bsr.w $588
        bsr.w H048+$588
L048_000013B6:
; H048+$000013B6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000013BA:
; H048+$000013BA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000013BC:
; H048+$000013BC: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_000013C0:
; H048+$000013C0: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_000013C6:
; H048+$000013C6: 7800  moveq #$0, d4
        moveq #0, d4
L048_000013C8:
; H048+$000013C8: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_000013CC:
; H048+$000013CC: 6000006c  bra.w $143a
        bra.w H048+$143A
L048_000013D0:
; H048+$000013D0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L048_000013D4:
; H048+$000013D4: 4a2b00db  tst.b $db(a3)
        tst.b $db(a3)
L048_000013D8:
; H048+$000013D8: 66000030  bne.w $140a
        bne.w H048+$140A
L048_000013DC:
; H048+$000013DC: 7400  moveq #$0, d2
        moveq #0, d2
L048_000013DE:
; H048+$000013DE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L048_000013E2:
; H048+$000013E2: 142b0123  move.b $123(a3), d2
        move.b $123(a3), d2
L048_000013E6:
; H048+$000013E6: 0c420003  cmpi.w #$3, d2
        cmpi.w #$3, d2
L048_000013EA:
; H048+$000013EA: 6c000010  bge.w $13fc
        bge.w H048+$13FC
L048_000013EE:
; H048+$000013EE: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L048_000013F2:
; H048+$000013F2: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L048_000013F8:
; H048+$000013F8: 6000000c  bra.w $1406
        bra.w H048+$1406
L048_000013FC:
; H048+$000013FC: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L048_00001400:
; H048+$00001400: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L048_00001406:
; H048+$00001406: 6000000c  bra.w $1414
        bra.w H048+$1414
L048_0000140A:
; H048+$0000140A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L048_0000140E:
; H048+$0000140E: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L048_00001414:
; H048+$00001414: 4e75  rts 
        rts 
L048_00001416:
; H048+$00001416: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L048_0000141A:
; H048+$0000141A: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L048_00001420:
; H048+$00001420: 4e75  rts 
        rts 
L048_00001422:
; H048+$00001422: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L048_00001426:
; H048+$00001426: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L048_0000142C:
; H048+$0000142C: 4e75  rts 
        rts 
L048_0000142E:
; H048+$0000142E: 4e75  rts 
        rts 
; Preserved bytes H048+$00001430..$0000143A; code/data not fully classified.
        dc.w $FFFC,$FF9E,$FFE4,$FFE4,$FFF0
L048_0000143A:
; H048+$0000143A: 47fafff6  lea.l $1432(pc), a3
        lea.l H048+$1432(pc), a3
L048_0000143E:
; H048+$0000143E: 5344  subq.w #$1, d4
        subq.w #$1, d4
L048_00001440:
; H048+$00001440: 0c440003  cmpi.w #$3, d4
        cmpi.w #$3, d4
L048_00001444:
; H048+$00001444: 6302  bls.b $1448
        bls.b H048+$1448
L048_00001446:
; H048+$00001446: 78ff  moveq #$ff, d4
        moveq #-1, d4
L048_00001448:
; H048+$00001448: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_0000144A:
; H048+$0000144A: 38334000  move.w (a3, d4.w), d4
        move.w (a3, d4.w), d4
; DISPATCH: word relative a H048+$1432; indici 0..3, default -1.
L048_0000144E:
; H048+$0000144E: 4eb34000  jsr (a3, d4.w)
        jsr (a3, d4.w)
L048_00001452:
; H048+$00001452: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L048_00001456:
; H048+$00001456: 0c6d0008fffa  cmpi.w #$8, -$6(a5)
        cmpi.w #$8, -$6(a5)
L048_0000145C:
; H048+$0000145C: 620000f6  bhi.w $1554
        bhi.w H048+$1554
L048_00001460:
; H048+$00001460: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L048_00001464:
; H048+$00001464: 0c6d0003fffc  cmpi.w #$3, -$4(a5)
        cmpi.w #$3, -$4(a5)
L048_0000146A:
; H048+$0000146A: 620000d6  bhi.w $1542
        bhi.w H048+$1542
L048_0000146E:
; H048+$0000146E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_00001472:
; H048+$00001472: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001474:
; H048+$00001474: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00001478:
; H048+$00001478: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_0000147E:
; H048+$0000147E: 7800  moveq #$0, d4
        moveq #0, d4
L048_00001480:
; H048+$00001480: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L048_00001484:
; H048+$00001484: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_00001486:
; H048+$00001486: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L048_0000148A:
; H048+$0000148A: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_0000148E:
; H048+$0000148E: 486dfff6  pea.l -$a(a5)
        pea.l -$a(a5)
L048_00001492:
; H048+$00001492: 6100ebb0  bsr.w $44
        bsr.w H048+$44
L048_00001496:
; H048+$00001496: 1400  move.b d0, d2
        move.b d0, d2
L048_00001498:
; H048+$00001498: 4a02  tst.b d2
        tst.b d2
L048_0000149A:
; H048+$0000149A: 6700009e  beq.w $153a
        beq.w H048+$153A
L048_0000149E:
; H048+$0000149E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000014A2:
; H048+$000014A2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000014A4:
; H048+$000014A4: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000014A6:
; H048+$000014A6: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_000014AC:
; H048+$000014AC: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L048_000014B0:
; H048+$000014B0: d86dfff8  add.w -$8(a5), d4
        add.w -$8(a5), d4
L048_000014B4:
; H048+$000014B4: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_000014B6:
; H048+$000014B6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000014BA:
; H048+$000014BA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000014BC:
; H048+$000014BC: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000014BE:
; H048+$000014BE: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_000014C4:
; H048+$000014C4: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L048_000014C8:
; H048+$000014C8: d86dfff6  add.w -$a(a5), d4
        add.w -$a(a5), d4
L048_000014CC:
; H048+$000014CC: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_000014CE:
; H048+$000014CE: 6100ed18  bsr.w $1e8
        bsr.w H048+$1E8
L048_000014D2:
; H048+$000014D2: 1400  move.b d0, d2
        move.b d0, d2
L048_000014D4:
; H048+$000014D4: 4a02  tst.b d2
        tst.b d2
L048_000014D6:
; H048+$000014D6: 67000062  beq.w $153a
        beq.w H048+$153A
L048_000014DA:
; H048+$000014DA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000014DE:
; H048+$000014DE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000014E0:
; H048+$000014E0: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000014E2:
; H048+$000014E2: 47f900003104  lea.l $3104.l, a3
        lea.l (H005+$3104).l, a3
L048_000014E8:
; H048+$000014E8: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L048_000014EC:
; H048+$000014EC: d86dfff8  add.w -$8(a5), d4
        add.w -$8(a5), d4
L048_000014F0:
; H048+$000014F0: c9fc0018  muls.w #$18, d4
        muls.w #$18, d4
L048_000014F4:
; H048+$000014F4: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_000014F6:
; H048+$000014F6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000014FA:
; H048+$000014FA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000014FC:
; H048+$000014FC: e342  asl.w #$1, d2
        asl.w #$1, d2
L048_000014FE:
; H048+$000014FE: 47f9000030b4  lea.l $30b4.l, a3
        lea.l (H005+$30B4).l, a3
L048_00001504:
; H048+$00001504: 38332000  move.w (a3, d2.w), d4
        move.w (a3, d2.w), d4
L048_00001508:
; H048+$00001508: d86dfff6  add.w -$a(a5), d4
        add.w -$a(a5), d4
L048_0000150C:
; H048+$0000150C: c9fc0018  muls.w #$18, d4
        muls.w #$18, d4
L048_00001510:
; H048+$00001510: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L048_00001512:
; H048+$00001512: 4227  clr.b -(a7)
        clr.b -(a7)
L048_00001514:
; H048+$00001514: 1f3c0005  move.b #$5, -(a7)
        move.b #$5, -(a7)
L048_00001518:
; H048+$00001518: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000151A:
; H048+$0000151A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L048_0000151E:
; H048+$0000151E: 02420001  andi.w #$1, d2
        andi.w #$1, d2
L048_00001522:
; H048+$00001522: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00001524:
; H048+$00001524: 47f900003304  lea.l $3304.l, a3
        lea.l (H005+$3304).l, a3
L048_0000152A:
; H048+$0000152A: 2f332000  move.l (a3, d2.w), -(a7)
        move.l (a3, d2.w), -(a7)
L048_0000152E:
; H048+$0000152E: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; -> H029+$0D58 (sub_H029_00000D58)
L048_00001534:
; H048+$00001534: 4eb900000d58  jsr $d58.l
        jsr (H029+$D58).l
L048_0000153A:
; H048+$0000153A: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L048_0000153E:
; H048+$0000153E: 6400ff24  bcc.w $1464
        bcc.w H048+$1464
L048_00001542:
; H048+$00001542: 7401  moveq #$1, d2
        moveq #1, d2
L048_00001544:
; H048+$00001544: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H036+$0034 (wrapper_Delay)
L048_00001546:
; H048+$00001546: 4eb900000034  jsr $34.l
        jsr (H036+$34).l
L048_0000154C:
; H048+$0000154C: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L048_00001550:
; H048+$00001550: 6400ff04  bcc.w $1456
        bcc.w H048+$1456
L048_00001554:
; H048+$00001554: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L048_00001558:
; H048+$00001558: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_0000155C:
; H048+$0000155C: 4a2b0015  tst.b $15(a3)
        tst.b $15(a3)
L048_00001560:
; H048+$00001560: 660000e2  bne.w $1644
        bne.w H048+$1644
L048_00001564:
; H048+$00001564: 7400  moveq #$0, d2
        moveq #0, d2
L048_00001566:
; H048+$00001566: 14390000247a  move.b $247a.l, d2
        move.b (H005+$247A).l, d2
L048_0000156C:
; H048+$0000156C: 5242  addq.w #$1, d2
        addq.w #$1, d2
L048_0000156E:
; H048+$0000156E: 13c20000247a  move.b d2, $247a.l
        move.b d2, (H005+$247A).l
L048_00001574:
; H048+$00001574: 7400  moveq #$0, d2
        moveq #0, d2
L048_00001576:
; H048+$00001576: 14390000247a  move.b $247a.l, d2
        move.b (H005+$247A).l, d2
L048_0000157C:
; H048+$0000157C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000157E:
; H048+$0000157E: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_00001582:
; H048+$00001582: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_00001588:
; H048+$00001588: 382dfff2  move.w -$e(a5), d4
        move.w -$e(a5), d4
L048_0000158C:
; H048+$0000158C: c9fc0064  muls.w #$64, d4
        muls.w #$64, d4
L048_00001590:
; H048+$00001590: 247900002ade  movea.l $2ade.l, a2
        movea.l (H005+$2ADE).l, a2
L048_00001596:
; H048+$00001596: 45ea000a  lea.l $a(a2), a2
        lea.l $a(a2), a2
L048_0000159A:
; H048+$0000159A: 3c2dfff4  move.w -$c(a5), d6
        move.w -$c(a5), d6
L048_0000159E:
; H048+$0000159E: e346  asl.w #$1, d6
        asl.w #$1, d6
L048_000015A0:
; H048+$000015A0: 45f24800  lea.l (a2, d4.l), a2
        lea.l (a2, d4.l), a2
L048_000015A4:
; H048+$000015A4: 17b260012808  move.b $1(a2, d6.w), $8(a3, d2.l)
        move.b $1(a2, d6.w), $8(a3, d2.l)
L048_000015AA:
; H048+$000015AA: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_000015AE:
; H048+$000015AE: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_000015B2:
; H048+$000015B2: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000015B8:
; H048+$000015B8: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_000015BC:
; H048+$000015BC: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L048_000015C0:
; H048+$000015C0: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_000015C2:
; H048+$000015C2: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_000015C6:
; H048+$000015C6: 7400  moveq #$0, d2
        moveq #0, d2
L048_000015C8:
; H048+$000015C8: 14334001  move.b $1(a3, d4.w), d2
        move.b $1(a3, d4.w), d2
L048_000015CC:
; H048+$000015CC: 0c42001e  cmpi.w #$1e, d2
        cmpi.w #$1e, d2
L048_000015D0:
; H048+$000015D0: 67000024  beq.w $15f6
        beq.w H048+$15F6
L048_000015D4:
; H048+$000015D4: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L048_000015D8:
; H048+$000015D8: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_000015DC:
; H048+$000015DC: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000015E2:
; H048+$000015E2: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_000015E6:
; H048+$000015E6: 382dfff4  move.w -$c(a5), d4
        move.w -$c(a5), d4
L048_000015EA:
; H048+$000015EA: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_000015EC:
; H048+$000015EC: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_000015F0:
; H048+$000015F0: 17bc001f4001  move.b #$1f, $1(a3, d4.w)
        move.b #$1f, $1(a3, d4.w)
L048_000015F6:
; H048+$000015F6: 7400  moveq #$0, d2
        moveq #0, d2
L048_000015F8:
; H048+$000015F8: 14390000247a  move.b $247a.l, d2
        move.b (H005+$247A).l, d2
L048_000015FE:
; H048+$000015FE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001600:
; H048+$00001600: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_00001604:
; H048+$00001604: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_0000160A:
; H048+$0000160A: 27ad000c2800  move.l $c(a5), (a3, d2.l)
        move.l $c(a5), (a3, d2.l)
L048_00001610:
; H048+$00001610: 7400  moveq #$0, d2
        moveq #0, d2
L048_00001612:
; H048+$00001612: 14390000247a  move.b $247a.l, d2
        move.b (H005+$247A).l, d2
L048_00001618:
; H048+$00001618: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000161A:
; H048+$0000161A: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_0000161E:
; H048+$0000161E: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_00001624:
; H048+$00001624: 37adfff42804  move.w -$c(a5), $4(a3, d2.l)
        move.w -$c(a5), $4(a3, d2.l)
L048_0000162A:
; H048+$0000162A: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000162C:
; H048+$0000162C: 14390000247a  move.b $247a.l, d2
        move.b (H005+$247A).l, d2
L048_00001632:
; H048+$00001632: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001634:
; H048+$00001634: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_00001638:
; H048+$00001638: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_0000163E:
; H048+$0000163E: 37adfff22806  move.w -$e(a5), $6(a3, d2.l)
        move.w -$e(a5), $6(a3, d2.l)
; -> H030+$0B4A (sub_H030_00000B4A)
L048_00001644:
; H048+$00001644: 4eb900000b4a  jsr $b4a.l
        jsr (H030+$B4A).l
L048_0000164A:
; H048+$0000164A: 4267  clr.w -(a7)
        clr.w -(a7)
L048_0000164C:
; H048+$0000164C: 4267  clr.w -(a7)
        clr.w -(a7)
L048_0000164E:
; H048+$0000164E: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L048_00001652:
; H048+$00001652: 6100ef34  bsr.w $588
        bsr.w H048+$588
L048_00001656:
; H048+$00001656: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L048_0000165A:
; H048+$0000165A: 6100f44c  bsr.w $aa8
        bsr.w H048+$AA8
L048_0000165E:
; H048+$0000165E: 3400  move.w d0, d2
        move.w d0, d2
L048_00001660:
; H048+$00001660: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001662:
; H048+$00001662: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00001666:
; H048+$00001666: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_0000166C:
; H048+$0000166C: 42332805  clr.b $5(a3, d2.l)
        clr.b $5(a3, d2.l)
L048_00001670:
; H048+$00001670: 6100f2e4  bsr.w $956
        bsr.w H048+$956
L048_00001674:
; H048+$00001674: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000167A:
; H048+$0000167A: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L048_0000167E:
; H048+$0000167E: 5642  addq.w #$3, d2
        addq.w #$3, d2
L048_00001680:
; H048+$00001680: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00001682:
; H048+$00001682: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_00001688:
; H048+$00001688: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L048_0000168C:
; H048+$0000168C: 5642  addq.w #$3, d2
        addq.w #$3, d2
L048_0000168E:
; H048+$0000168E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_00001690:
; H048+$00001690: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L048_00001694:
; H048+$00001694: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L048_00001698:
; H048+$00001698: 6100f758  bsr.w $df2
        bsr.w H048+$DF2
L048_0000169C:
; H048+$0000169C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L048_000016A0:
; H048+$000016A0: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_000016A4:
; H048+$000016A4: 426b0004  clr.w $4(a3)
        clr.w $4(a3)
L048_000016A8:
; H048+$000016A8: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L048_000016AC:
; H048+$000016AC: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_000016B0:
; H048+$000016B0: 422b0008  clr.b $8(a3)
        clr.b $8(a3)
L048_000016B4:
; H048+$000016B4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L048_000016B8:
; H048+$000016B8: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_000016BC:
; H048+$000016BC: 4213  clr.b (a3)
        clr.b (a3)
L048_000016BE:
; H048+$000016BE: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L048_000016C2:
; H048+$000016C2: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_000016C6:
; H048+$000016C6: 422b0009  clr.b $9(a3)
        clr.b $9(a3)
L048_000016CA:
; H048+$000016CA: 4e5d  unlk a5
        unlk a5
L048_000016CC:
; H048+$000016CC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_000016CE:
; H048+$000016CE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_000016D0:
; H048+$000016D0: 588f  addq.l #$4, a7
        addq.l #$4, a7
L048_000016D2:
; H048+$000016D2: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_000016D4 [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; richiama H029+$0354, H029+$0312.
;   - Richiama H029+$0354.
;   - Richiama H029+$0312.
;   - Usa lo stato globale: H005+$3DE3 (contesto nativo, 5 nel combattimento).
; Chiamanti diretti: H085+$38E8, H062+$269C, H059+$0788
; --------------------------------------------------------------------------
L048_000016D4:
; H048+$000016D4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_000016D6:
; H048+$000016D6: 287ae92c  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_000016DA:
; H048+$000016DA: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
; STATO: H005+$3DE3 = contesto nativo, 5 nel combattimento
L048_000016DE:
; H048+$000016DE: 0c39000500003de3  cmpi.b #$5, $3de3.l
        cmpi.b #$5, (H005+$3DE3).l
L048_000016E6:
; H048+$000016E6: 6600025c  bne.w $1944
        bne.w H048+$1944
L048_000016EA:
; H048+$000016EA: 422dfff4  clr.b -$c(a5)
        clr.b -$c(a5)
L048_000016EE:
; H048+$000016EE: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L048_000016F2:
; H048+$000016F2: 6100f3b4  bsr.w $aa8
        bsr.w H048+$AA8
L048_000016F6:
; H048+$000016F6: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L048_000016FA:
; H048+$000016FA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000016FE:
; H048+$000016FE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001700:
; H048+$00001700: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00001704:
; H048+$00001704: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_0000170A:
; H048+$0000170A: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L048_0000170E:
; H048+$0000170E: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L048_00001712:
; H048+$00001712: 1f2a00d3  move.b $d3(a2), -(a7)
        move.b $d3(a2), -(a7)
L048_00001716:
; H048+$00001716: 3f3c007f  move.w #$7f, -(a7)
        move.w #$7f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L048_0000171A:
; H048+$0000171A: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L048_00001720:
; H048+$00001720: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L048_00001724:
; H048+$00001724: 17802805  move.b d0, $5(a3, d2.l)
        move.b d0, $5(a3, d2.l)
L048_00001728:
; H048+$00001728: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_0000172C:
; H048+$0000172C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000172E:
; H048+$0000172E: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00001732:
; H048+$00001732: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00001738:
; H048+$00001738: 7800  moveq #$0, d4
        moveq #0, d4
L048_0000173A:
; H048+$0000173A: 182d0010  move.b $10(a5), d4
        move.b $10(a5), d4
L048_0000173E:
; H048+$0000173E: 37842800  move.w d4, (a3, d2.l)
        move.w d4, (a3, d2.l)
L048_00001742:
; H048+$00001742: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_00001746:
; H048+$00001746: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001748:
; H048+$00001748: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_0000174C:
; H048+$0000174C: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_00001752:
; H048+$00001752: 7800  moveq #$0, d4
        moveq #0, d4
L048_00001754:
; H048+$00001754: 182d000e  move.b $e(a5), d4
        move.b $e(a5), d4
L048_00001758:
; H048+$00001758: 37842802  move.w d4, $2(a3, d2.l)
        move.w d4, $2(a3, d2.l)
L048_0000175C:
; H048+$0000175C: 2f2d0012  move.l $12(a5), -(a7)
        move.l $12(a5), -(a7)
L048_00001760:
; H048+$00001760: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L048_00001764:
; H048+$00001764: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L048_00001768:
; H048+$00001768: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L048_0000176C:
; H048+$0000176C: 486dfff6  pea.l -$a(a5)
        pea.l -$a(a5)
L048_00001770:
; H048+$00001770: 486dfff5  pea.l -$b(a5)
        pea.l -$b(a5)
L048_00001774:
; H048+$00001774: 6100f9c8  bsr.w $113e
        bsr.w H048+$113E
L048_00001778:
; H048+$00001778: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L048_0000177C:
; H048+$0000177C: 66000026  bne.w $17a4
        bne.w H048+$17A4
L048_00001780:
; H048+$00001780: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L048_00001784:
; H048+$00001784: 6700001e  beq.w $17a4
        beq.w H048+$17A4
L048_00001788:
; H048+$00001788: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L048_0000178C:
; H048+$0000178C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000178E:
; H048+$0000178E: e542  asl.w #$2, d2
        asl.w #$2, d2
L048_00001790:
; H048+$00001790: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L048_00001796:
; H048+$00001796: 7800  moveq #$0, d4
        moveq #0, d4
L048_00001798:
; H048+$00001798: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L048_0000179C:
; H048+$0000179C: 0c4400ff  cmpi.w #$ff, d4
        cmpi.w #$ff, d4
L048_000017A0:
; H048+$000017A0: 6600001a  bne.w $17bc
        bne.w H048+$17BC
L048_000017A4:
; H048+$000017A4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L048_000017A8:
; H048+$000017A8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000017AA:
; H048+$000017AA: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_000017AE:
; H048+$000017AE: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_000017B4:
; H048+$000017B4: 42332805  clr.b $5(a3, d2.l)
        clr.b $5(a3, d2.l)
L048_000017B8:
; H048+$000017B8: 60000186  bra.w $1940
        bra.w H048+$1940
L048_000017BC:
; H048+$000017BC: 1b7c0001fff4  move.b #$1, -$c(a5)
        move.b #$1, -$c(a5)
L048_000017C2:
; H048+$000017C2: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L048_000017C6:
; H048+$000017C6: 67000174  beq.w $193c
        beq.w H048+$193C
L048_000017CA:
; H048+$000017CA: 246d0012  movea.l $12(a5), a2
        movea.l $12(a5), a2
L048_000017CE:
; H048+$000017CE: 266a0192  movea.l $192(a2), a3
        movea.l $192(a2), a3
L048_000017D2:
; H048+$000017D2: 4a2b0015  tst.b $15(a3)
        tst.b $15(a3)
L048_000017D6:
; H048+$000017D6: 66000164  bne.w $193c
        bne.w H048+$193C
L048_000017DA:
; H048+$000017DA: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L048_000017E0:
; H048+$000017E0: 7400  moveq #$0, d2
        moveq #0, d2
L048_000017E2:
; H048+$000017E2: 14390000247a  move.b $247a.l, d2
        move.b (H005+$247A).l, d2
L048_000017E8:
; H048+$000017E8: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_000017EA:
; H048+$000017EA: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000017EE:
; H048+$000017EE: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L048_000017F0:
; H048+$000017F0: 62000092  bhi.w $1884
        bhi.w H048+$1884
L048_000017F4:
; H048+$000017F4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000017F8:
; H048+$000017F8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000017FA:
; H048+$000017FA: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_000017FE:
; H048+$000017FE: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_00001804:
; H048+$00001804: 28332800  move.l (a3, d2.l), d4
        move.l (a3, d2.l), d4
L048_00001808:
; H048+$00001808: b8ad0012  cmp.l $12(a5), d4
        cmp.l $12(a5), d4
L048_0000180C:
; H048+$0000180C: 6600006e  bne.w $187c
        bne.w H048+$187C
L048_00001810:
; H048+$00001810: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00001814:
; H048+$00001814: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001816:
; H048+$00001816: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_0000181A:
; H048+$0000181A: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_00001820:
; H048+$00001820: 7800  moveq #$0, d4
        moveq #0, d4
L048_00001822:
; H048+$00001822: 18332808  move.b $8(a3, d2.l), d4
        move.b $8(a3, d2.l), d4
L048_00001826:
; H048+$00001826: 0c44001f  cmpi.w #$1f, d4
        cmpi.w #$1f, d4
L048_0000182A:
; H048+$0000182A: 6700001c  beq.w $1848
        beq.w H048+$1848
L048_0000182E:
; H048+$0000182E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00001832:
; H048+$00001832: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001834:
; H048+$00001834: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_00001838:
; H048+$00001838: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_0000183E:
; H048+$0000183E: 7800  moveq #$0, d4
        moveq #0, d4
L048_00001840:
; H048+$00001840: 18332808  move.b $8(a3, d2.l), d4
        move.b $8(a3, d2.l), d4
L048_00001844:
; H048+$00001844: 3b44fff8  move.w d4, -$8(a5)
        move.w d4, -$8(a5)
L048_00001848:
; H048+$00001848: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_0000184C:
; H048+$0000184C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_0000184E:
; H048+$0000184E: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_00001852:
; H048+$00001852: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_00001858:
; H048+$00001858: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L048_0000185C:
; H048+$0000185C: 48732800  pea.l (a3, d2.l)
        pea.l (a3, d2.l)
L048_00001860:
; H048+$00001860: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_00001864:
; H048+$00001864: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001866:
; H048+$00001866: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_0000186A:
; H048+$0000186A: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_00001870:
; H048+$00001870: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L048_00001874:
; H048+$00001874: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L048_00001876:
; H048+$00001876: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L048_0000187C:
; H048+$0000187C: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L048_00001880:
; H048+$00001880: 6400ff68  bcc.w $17ea
        bcc.w H048+$17EA
L048_00001884:
; H048+$00001884: 548f  addq.l #$2, a7
        addq.l #$2, a7
L048_00001886:
; H048+$00001886: 422dfff7  clr.b -$9(a5)
        clr.b -$9(a5)
L048_0000188A:
; H048+$0000188A: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L048_00001890:
; H048+$00001890: 7400  moveq #$0, d2
        moveq #0, d2
L048_00001892:
; H048+$00001892: 14390000247a  move.b $247a.l, d2
        move.b (H005+$247A).l, d2
L048_00001898:
; H048+$00001898: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L048_0000189A:
; H048+$0000189A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_0000189E:
; H048+$0000189E: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L048_000018A0:
; H048+$000018A0: 62000098  bhi.w $193a
        bhi.w H048+$193A
L048_000018A4:
; H048+$000018A4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000018A8:
; H048+$000018A8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000018AA:
; H048+$000018AA: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_000018AE:
; H048+$000018AE: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_000018B4:
; H048+$000018B4: 4ab32800  tst.l (a3, d2.l)
        tst.l (a3, d2.l)
L048_000018B8:
; H048+$000018B8: 67000048  beq.w $1902
        beq.w H048+$1902
L048_000018BC:
; H048+$000018BC: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000018C0:
; H048+$000018C0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000018C2:
; H048+$000018C2: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_000018C6:
; H048+$000018C6: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_000018CC:
; H048+$000018CC: 7800  moveq #$0, d4
        moveq #0, d4
L048_000018CE:
; H048+$000018CE: 182d0010  move.b $10(a5), d4
        move.b $10(a5), d4
L048_000018D2:
; H048+$000018D2: 3c332804  move.w $4(a3, d2.l), d6
        move.w $4(a3, d2.l), d6
L048_000018D6:
; H048+$000018D6: bc44  cmp.w d4, d6
        cmp.w d4, d6
L048_000018D8:
; H048+$000018D8: 66000028  bne.w $1902
        bne.w H048+$1902
L048_000018DC:
; H048+$000018DC: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L048_000018E0:
; H048+$000018E0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_000018E2:
; H048+$000018E2: c5fc000a  muls.w #$a, d2
        muls.w #$a, d2
L048_000018E6:
; H048+$000018E6: 47f900002ae2  lea.l $2ae2.l, a3
        lea.l (H005+$2AE2).l, a3
L048_000018EC:
; H048+$000018EC: 7800  moveq #$0, d4
        moveq #0, d4
L048_000018EE:
; H048+$000018EE: 182d000e  move.b $e(a5), d4
        move.b $e(a5), d4
L048_000018F2:
; H048+$000018F2: 3c332806  move.w $6(a3, d2.l), d6
        move.w $6(a3, d2.l), d6
L048_000018F6:
; H048+$000018F6: bc44  cmp.w d4, d6
        cmp.w d4, d6
L048_000018F8:
; H048+$000018F8: 66000008  bne.w $1902
        bne.w H048+$1902
L048_000018FC:
; H048+$000018FC: 1b7c0001fff7  move.b #$1, -$9(a5)
        move.b #$1, -$9(a5)
L048_00001902:
; H048+$00001902: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L048_00001906:
; H048+$00001906: 6600002a  bne.w $1932
        bne.w H048+$1932
L048_0000190A:
; H048+$0000190A: 7400  moveq #$0, d2
        moveq #0, d2
L048_0000190C:
; H048+$0000190C: 142d000e  move.b $e(a5), d2
        move.b $e(a5), d2
L048_00001910:
; H048+$00001910: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L048_00001914:
; H048+$00001914: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000191A:
; H048+$0000191A: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L048_0000191E:
; H048+$0000191E: 7800  moveq #$0, d4
        moveq #0, d4
L048_00001920:
; H048+$00001920: 182d0010  move.b $10(a5), d4
        move.b $10(a5), d4
L048_00001924:
; H048+$00001924: e344  asl.w #$1, d4
        asl.w #$1, d4
L048_00001926:
; H048+$00001926: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L048_0000192A:
; H048+$0000192A: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L048_0000192E:
; H048+$0000192E: 17824001  move.b d2, $1(a3, d4.w)
        move.b d2, $1(a3, d4.w)
L048_00001932:
; H048+$00001932: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L048_00001936:
; H048+$00001936: 6400ff62  bcc.w $189a
        bcc.w H048+$189A
L048_0000193A:
; H048+$0000193A: 548f  addq.l #$2, a7
        addq.l #$2, a7
L048_0000193C:
; H048+$0000193C: 6100f018  bsr.w $956
        bsr.w H048+$956
L048_00001940:
; H048+$00001940: 60000008  bra.w $194a
        bra.w H048+$194A
L048_00001944:
; H048+$00001944: 1b7c0001fff4  move.b #$1, -$c(a5)
        move.b #$1, -$c(a5)
L048_0000194A:
; H048+$0000194A: 102dfff4  move.b -$c(a5), d0
        move.b -$c(a5), d0
L048_0000194E:
; H048+$0000194E: 60000002  bra.w $1952
        bra.w H048+$1952
L048_00001952:
; H048+$00001952: 4e5d  unlk a5
        unlk a5
L048_00001954:
; H048+$00001954: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_00001956:
; H048+$00001956: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_00001958:
; H048+$00001958: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L048_0000195C:
; H048+$0000195C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H048_0000195E [parziale]
; Scopo: Routine del modulo servizi grafici e geometrici usati dal combattimento; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H062+$26EE, H096+$3BF4, H059+$1544, H059+$1460, H059+$1408, H096+$31A4 e altri 2
; --------------------------------------------------------------------------
L048_0000195E:
; H048+$0000195E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L048_00001960:
; H048+$00001960: 287ae6a2  movea.l $4(pc), a4
        movea.l H048+$4(pc), a4
L048_00001964:
; H048+$00001964: 4e550000  link.w a5, #$0
        link.w a5, #$0
L048_00001968:
; H048+$00001968: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_0000196E:
; H048+$0000196E: 176d000c0006  move.b $c(a5), $6(a3)
        move.b $c(a5), $6(a3)
L048_00001974:
; H048+$00001974: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L048_00001978:
; H048+$00001978: 6100f12e  bsr.w $aa8
        bsr.w H048+$AA8
L048_0000197C:
; H048+$0000197C: 3400  move.w d0, d2
        move.w d0, d2
L048_0000197E:
; H048+$0000197E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L048_00001980:
; H048+$00001980: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L048_00001984:
; H048+$00001984: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L048_0000198A:
; H048+$0000198A: 247900002ade  movea.l $2ade.l, a2
        movea.l (H005+$2ADE).l, a2
L048_00001990:
; H048+$00001990: 157328050007  move.b $5(a3, d2.l), $7(a2)
        move.b $5(a3, d2.l), $7(a2)
L048_00001996:
; H048+$00001996: 4a39000024c6  tst.b $24c6.l
        tst.b (H005+$24C6).l
L048_0000199C:
; H048+$0000199C: 67000022  beq.w $19c0
        beq.w H048+$19C0
L048_000019A0:
; H048+$000019A0: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L048_000019A4:
; H048+$000019A4: 6100f5e2  bsr.w $f88
        bsr.w H048+$F88
L048_000019A8:
; H048+$000019A8: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L048_000019AA:
; H048+$000019AA: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L048_000019AE:
; H048+$000019AE: 6100f60a  bsr.w $fba
        bsr.w H048+$FBA
L048_000019B2:
; H048+$000019B2: 3f00  move.w d0, -(a7)
        move.w d0, -(a7)
L048_000019B4:
; H048+$000019B4: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L048_000019B8:
; H048+$000019B8: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L048_000019BC:
; H048+$000019BC: 6100f434  bsr.w $df2
        bsr.w H048+$DF2
L048_000019C0:
; H048+$000019C0: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000019C6:
; H048+$000019C6: 422b0006  clr.b $6(a3)
        clr.b $6(a3)
L048_000019CA:
; H048+$000019CA: 267900002ade  movea.l $2ade.l, a3
        movea.l (H005+$2ADE).l, a3
L048_000019D0:
; H048+$000019D0: 177c00010007  move.b #$1, $7(a3)
        move.b #$1, $7(a3)
L048_000019D6:
; H048+$000019D6: 4e5d  unlk a5
        unlk a5
L048_000019D8:
; H048+$000019D8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_000019DA:
; H048+$000019DA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L048_000019DC:
; H048+$000019DC: 508f  addq.l #$8, a7
        addq.l #$8, a7
L048_000019DE:
; H048+$000019DE: 4ed0  jmp (a0)
        jmp (a0)
L048_000019E0:
; H048+$000019E0: 7400  moveq #$0, d2
        moveq #0, d2
L048_000019E2:
; H048+$000019E2: 2942fffc  move.l d2, -$4(a4)
        move.l d2, -$4(a4)
L048_000019E6:
; H048+$000019E6: 4e5d  unlk a5
        unlk a5
L048_000019E8:
; H048+$000019E8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L048_000019EA:
; H048+$000019EA: 4e75  rts 
        rts 
; End H048: $19EC bytes
