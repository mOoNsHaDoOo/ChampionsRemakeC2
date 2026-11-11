; ============================================================================
; GUIDA DEL MODULO H077
; effetti visivi di combattimento e incantesimi.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Effetti visivi di combattimento e incantesimi: animazioni, proiettili e supporto al disegno degli attori. Usa H048.
; --------------------------------------------------------------------------
; H077: 3100 original bytes; all offsets are section-relative.
        section H077,code
H077:
; Preserved bytes H077+$00000000..$00000004; code/data not fully classified.
        dc.l H077+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H077 [parziale]
; Scopo: Ingresso del modulo effetti visivi di combattimento e incantesimi; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H077+$0C16.
; Chiamanti diretti: H000+$0192
; --------------------------------------------------------------------------
L077_00000004:
; H077+$00000004: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_00000006:
; H077+$00000006: 287afff8  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_0000000A:
; H077+$0000000A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L077_0000000E:
; H077+$0000000E: 60000c06  bra.w $c16
        bra.w H077+$C16
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H077_004C [parziale]
; Scopo: Trampolino verso H077+$004C; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H077+$004C.
; Chiamanti diretti: H077+$0210, H077+$0226
; --------------------------------------------------------------------------
L077_00000012:
; H077+$00000012: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_00000014:
; H077+$00000014: 287affea  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_00000018:
; H077+$00000018: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L077_0000001C:
; H077+$0000001C: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L077_00000020:
; H077+$00000020: 6c00000c  bge.w $2e
        bge.w H077+$2E
L077_00000024:
; H077+$00000024: 3b7cfffffffe  move.w #$ffff, -$2(a5)
        move.w #$ffff, -$2(a5)
L077_0000002A:
; H077+$0000002A: 60000018  bra.w $44
        bra.w H077+$44
L077_0000002E:
; H077+$0000002E: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L077_00000032:
; H077+$00000032: 6f00000c  ble.w $40
        ble.w H077+$40
L077_00000036:
; H077+$00000036: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L077_0000003C:
; H077+$0000003C: 60000006  bra.w $44
        bra.w H077+$44
L077_00000040:
; H077+$00000040: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L077_00000044:
; H077+$00000044: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L077_00000048:
; H077+$00000048: 60000002  bra.w $4c
        bra.w H077+$4C
L077_0000004C:
; H077+$0000004C: 4e5d  unlk a5
        unlk a5
L077_0000004E:
; H077+$0000004E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_00000050:
; H077+$00000050: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L077_00000052:
; H077+$00000052: 548f  addq.l #$2, a7
        addq.l #$2, a7
L077_00000054:
; H077+$00000054: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H077_00000056 [parziale]
; Scopo: Routine del modulo effetti visivi di combattimento e incantesimi; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H077+$0C06
; --------------------------------------------------------------------------
L077_00000056:
; H077+$00000056: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_00000058:
; H077+$00000058: 287affa6  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_0000005C:
; H077+$0000005C: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L077_00000060:
; H077+$00000060: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000062:
; H077+$00000062: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L077_00000068:
; H077+$00000068: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L077_0000006C:
; H077+$0000006C: 63000158  bls.w $1c6
        bls.w H077+$1C6
L077_00000070:
; H077+$00000070: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L077_00000076:
; H077+$00000076: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000078:
; H077+$00000078: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L077_0000007E:
; H077+$0000007E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_00000080:
; H077+$00000080: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L077_00000082:
; H077+$00000082: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000086:
; H077+$00000086: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L077_00000088:
; H077+$00000088: 6200013a  bhi.w $1c4
        bhi.w H077+$1C4
L077_0000008C:
; H077+$0000008C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000090:
; H077+$00000090: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_00000092:
; H077+$00000092: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L077_00000096:
; H077+$00000096: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000098:
; H077+$00000098: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L077_0000009E:
; H077+$0000009E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L077_000000A0:
; H077+$000000A0: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L077_000000A4:
; H077+$000000A4: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L077_000000A6:
; H077+$000000A6: 62000112  bhi.w $1ba
        bhi.w H077+$1BA
L077_000000AA:
; H077+$000000AA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000000AE:
; H077+$000000AE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_000000B0:
; H077+$000000B0: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_000000B2:
; H077+$000000B2: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_000000B8:
; H077+$000000B8: 7800  moveq #$0, d4
        moveq #0, d4
L077_000000BA:
; H077+$000000BA: 18332002  move.b $2(a3, d2.w), d4
        move.b $2(a3, d2.w), d4
L077_000000BE:
; H077+$000000BE: 3b44fff8  move.w d4, -$8(a5)
        move.w d4, -$8(a5)
L077_000000C2:
; H077+$000000C2: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L077_000000C6:
; H077+$000000C6: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_000000C8:
; H077+$000000C8: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_000000CA:
; H077+$000000CA: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_000000D0:
; H077+$000000D0: 7800  moveq #$0, d4
        moveq #0, d4
L077_000000D2:
; H077+$000000D2: 18332002  move.b $2(a3, d2.w), d4
        move.b $2(a3, d2.w), d4
L077_000000D6:
; H077+$000000D6: 3b44fffa  move.w d4, -$6(a5)
        move.w d4, -$6(a5)
L077_000000DA:
; H077+$000000DA: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L077_000000DE:
; H077+$000000DE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_000000E0:
; H077+$000000E0: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_000000E2:
; H077+$000000E2: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_000000E8:
; H077+$000000E8: 7800  moveq #$0, d4
        moveq #0, d4
L077_000000EA:
; H077+$000000EA: 18332001  move.b $1(a3, d2.w), d4
        move.b $1(a3, d2.w), d4
L077_000000EE:
; H077+$000000EE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000000F2:
; H077+$000000F2: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_000000F4:
; H077+$000000F4: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_000000F6:
; H077+$000000F6: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_000000FC:
; H077+$000000FC: 7c00  moveq #$0, d6
        moveq #0, d6
L077_000000FE:
; H077+$000000FE: 1c332001  move.b $1(a3, d2.w), d6
        move.b $1(a3, d2.w), d6
L077_00000102:
; H077+$00000102: b846  cmp.w d6, d4
        cmp.w d6, d4
L077_00000104:
; H077+$00000104: 65000056  bcs.w $15c
        bcs.w H077+$15C
L077_00000108:
; H077+$00000108: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L077_0000010C:
; H077+$0000010C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_0000010E:
; H077+$0000010E: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000110:
; H077+$00000110: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_00000116:
; H077+$00000116: 7800  moveq #$0, d4
        moveq #0, d4
L077_00000118:
; H077+$00000118: 18332001  move.b $1(a3, d2.w), d4
        move.b $1(a3, d2.w), d4
L077_0000011C:
; H077+$0000011C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000120:
; H077+$00000120: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_00000122:
; H077+$00000122: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000124:
; H077+$00000124: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_0000012A:
; H077+$0000012A: 7c00  moveq #$0, d6
        moveq #0, d6
L077_0000012C:
; H077+$0000012C: 1c332001  move.b $1(a3, d2.w), d6
        move.b $1(a3, d2.w), d6
L077_00000130:
; H077+$00000130: b846  cmp.w d6, d4
        cmp.w d6, d4
L077_00000132:
; H077+$00000132: 6600007e  bne.w $1b2
        bne.w H077+$1B2
L077_00000136:
; H077+$00000136: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_0000013A:
; H077+$0000013A: b46dfff8  cmp.w -$8(a5), d2
        cmp.w -$8(a5), d2
L077_0000013E:
; H077+$0000013E: 64000072  bcc.w $1b2
        bcc.w H077+$1B2
L077_00000142:
; H077+$00000142: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000144:
; H077+$00000144: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_00000148:
; H077+$00000148: 02420001  andi.w #$1, d2
        andi.w #$1, d2
L077_0000014C:
; H077+$0000014C: 7800  moveq #$0, d4
        moveq #0, d4
L077_0000014E:
; H077+$0000014E: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L077_00000152:
; H077+$00000152: 02440001  andi.w #$1, d4
        andi.w #$1, d4
L077_00000156:
; H077+$00000156: b444  cmp.w d4, d2
        cmp.w d4, d2
L077_00000158:
; H077+$00000158: 62000058  bhi.w $1b2
        bhi.w H077+$1B2
L077_0000015C:
; H077+$0000015C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000160:
; H077+$00000160: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_00000162:
; H077+$00000162: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000164:
; H077+$00000164: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_0000016A:
; H077+$0000016A: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L077_0000016E:
; H077+$0000016E: 45edfff4  lea.l -$c(a5), a2
        lea.l -$c(a5), a2
L077_00000172:
; H077+$00000172: 24db  move.l (a3)+, (a2)+
        move.l (a3)+, (a2)+
L077_00000174:
; H077+$00000174: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000178:
; H077+$00000178: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_0000017A:
; H077+$0000017A: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_0000017C:
; H077+$0000017C: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_00000182:
; H077+$00000182: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L077_00000186:
; H077+$00000186: 5344  subq.w #$1, d4
        subq.w #$1, d4
L077_00000188:
; H077+$00000188: e544  asl.w #$2, d4
        asl.w #$2, d4
L077_0000018A:
; H077+$0000018A: 45f900002a3e  lea.l $2a3e.l, a2
        lea.l (H005+$2A3E).l, a2
L077_00000190:
; H077+$00000190: 45f24000  lea.l (a2, d4.w), a2
        lea.l (a2, d4.w), a2
L077_00000194:
; H077+$00000194: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L077_00000198:
; H077+$00000198: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L077_0000019A:
; H077+$0000019A: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L077_0000019E:
; H077+$0000019E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_000001A0:
; H077+$000001A0: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_000001A2:
; H077+$000001A2: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_000001A8:
; H077+$000001A8: 45edfff4  lea.l -$c(a5), a2
        lea.l -$c(a5), a2
L077_000001AC:
; H077+$000001AC: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L077_000001B0:
; H077+$000001B0: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L077_000001B2:
; H077+$000001B2: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L077_000001B6:
; H077+$000001B6: 6400fee8  bcc.w $a0
        bcc.w H077+$A0
L077_000001BA:
; H077+$000001BA: 548f  addq.l #$2, a7
        addq.l #$2, a7
L077_000001BC:
; H077+$000001BC: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L077_000001C0:
; H077+$000001C0: 6400fec0  bcc.w $82
        bcc.w H077+$82
L077_000001C4:
; H077+$000001C4: 548f  addq.l #$2, a7
        addq.l #$2, a7
L077_000001C6:
; H077+$000001C6: 4e5d  unlk a5
        unlk a5
L077_000001C8:
; H077+$000001C8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_000001CA:
; H077+$000001CA: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H077_000001CC [parziale]
; Scopo: Routine del modulo effetti visivi di combattimento e incantesimi; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H085+$1402, H085+$1556, H085+$0BF4, H077+$03B2, H077+$0444
; --------------------------------------------------------------------------
L077_000001CC:
; H077+$000001CC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_000001CE:
; H077+$000001CE: 287afe30  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_000001D2:
; H077+$000001D2: 4e550000  link.w a5, #$0
        link.w a5, #$0
L077_000001D6:
; H077+$000001D6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L077_000001DA:
; H077+$000001DA: 3753000e  move.w (a3), $e(a3)
        move.w (a3), $e(a3)
L077_000001DE:
; H077+$000001DE: 376b00020010  move.w $2(a3), $10(a3)
        move.w $2(a3), $10(a3)
L077_000001E4:
; H077+$000001E4: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L077_000001E8:
; H077+$000001E8: 9453  sub.w (a3), d2
        sub.w (a3), d2
L077_000001EA:
; H077+$000001EA: 4a42  tst.w d2
        tst.w d2
L077_000001EC:
; H077+$000001EC: 6c02  bge.b $1f0
        bge.b H077+$1F0
L077_000001EE:
; H077+$000001EE: 4442  neg.w d2
        neg.w d2
L077_000001F0:
; H077+$000001F0: 3742000a  move.w d2, $a(a3)
        move.w d2, $a(a3)
L077_000001F4:
; H077+$000001F4: 342b0006  move.w $6(a3), d2
        move.w $6(a3), d2
L077_000001F8:
; H077+$000001F8: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L077_000001FC:
; H077+$000001FC: 4a42  tst.w d2
        tst.w d2
L077_000001FE:
; H077+$000001FE: 6c02  bge.b $202
        bge.b H077+$202
L077_00000200:
; H077+$00000200: 4442  neg.w d2
        neg.w d2
L077_00000202:
; H077+$00000202: 3742000c  move.w d2, $c(a3)
        move.w d2, $c(a3)
L077_00000206:
; H077+$00000206: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L077_00000208:
; H077+$00000208: 342b0004  move.w $4(a3), d2
        move.w $4(a3), d2
L077_0000020C:
; H077+$0000020C: 9453  sub.w (a3), d2
        sub.w (a3), d2
L077_0000020E:
; H077+$0000020E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L077_00000210:
; H077+$00000210: 6100fe00  bsr.w $12
        bsr.w H077+$12
L077_00000214:
; H077+$00000214: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L077_00000216:
; H077+$00000216: 37400012  move.w d0, $12(a3)
        move.w d0, $12(a3)
L077_0000021A:
; H077+$0000021A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L077_0000021C:
; H077+$0000021C: 342b0006  move.w $6(a3), d2
        move.w $6(a3), d2
L077_00000220:
; H077+$00000220: 946b0002  sub.w $2(a3), d2
        sub.w $2(a3), d2
L077_00000224:
; H077+$00000224: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L077_00000226:
; H077+$00000226: 6100fdea  bsr.w $12
        bsr.w H077+$12
L077_0000022A:
; H077+$0000022A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L077_0000022C:
; H077+$0000022C: 37400014  move.w d0, $14(a3)
        move.w d0, $14(a3)
L077_00000230:
; H077+$00000230: 426b0008  clr.w $8(a3)
        clr.w $8(a3)
L077_00000234:
; H077+$00000234: 422b0016  clr.b $16(a3)
        clr.b $16(a3)
L077_00000238:
; H077+$00000238: 4e5d  unlk a5
        unlk a5
L077_0000023A:
; H077+$0000023A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_0000023C:
; H077+$0000023C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L077_0000023E:
; H077+$0000023E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L077_00000240:
; H077+$00000240: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H077_00000242 [parziale]
; Scopo: Routine del modulo effetti visivi di combattimento e incantesimi; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H085+$1430, H085+$1560, H085+$0E1A, H085+$0F9C, H085+$0C6E, H077+$04C6 e altri 1
; --------------------------------------------------------------------------
L077_00000242:
; H077+$00000242: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_00000244:
; H077+$00000244: 287afdba  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_00000248:
; H077+$00000248: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L077_0000024C:
; H077+$0000024C: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
L077_00000250:
; H077+$00000250: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L077_00000256:
; H077+$00000256: 3b7c0001fffc  move.w #$1, -$4(a5)
        move.w #$1, -$4(a5)
L077_0000025C:
; H077+$0000025C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L077_00000260:
; H077+$00000260: 342b000a  move.w $a(a3), d2
        move.w $a(a3), d2
L077_00000264:
; H077+$00000264: b46b000c  cmp.w $c(a3), d2
        cmp.w $c(a3), d2
L077_00000268:
; H077+$00000268: 6d000074  blt.w $2de
        blt.w H077+$2DE
L077_0000026C:
; H077+$0000026C: 342b000e  move.w $e(a3), d2
        move.w $e(a3), d2
L077_00000270:
; H077+$00000270: b46b0004  cmp.w $4(a3), d2
        cmp.w $4(a3), d2
L077_00000274:
; H077+$00000274: 67000064  beq.w $2da
        beq.w H077+$2DA
L077_00000278:
; H077+$00000278: 342b0012  move.w $12(a3), d2
        move.w $12(a3), d2
L077_0000027C:
; H077+$0000027C: d56b000e  add.w d2, $e(a3)
        add.w d2, $e(a3)
L077_00000280:
; H077+$00000280: 342b0012  move.w $12(a3), d2
        move.w $12(a3), d2
L077_00000284:
; H077+$00000284: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_00000286:
; H077+$00000286: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L077_0000028A:
; H077+$0000028A: 342b000c  move.w $c(a3), d2
        move.w $c(a3), d2
L077_0000028E:
; H077+$0000028E: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000290:
; H077+$00000290: d56b0008  add.w d2, $8(a3)
        add.w d2, $8(a3)
L077_00000294:
; H077+$00000294: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000296:
; H077+$00000296: 142b0016  move.b $16(a3), d2
        move.b $16(a3), d2
L077_0000029A:
; H077+$0000029A: 5442  addq.w #$2, d2
        addq.w #$2, d2
L077_0000029C:
; H077+$0000029C: 17420016  move.b d2, $16(a3)
        move.b d2, $16(a3)
L077_000002A0:
; H077+$000002A0: 342b0008  move.w $8(a3), d2
        move.w $8(a3), d2
L077_000002A4:
; H077+$000002A4: b46b000a  cmp.w $a(a3), d2
        cmp.w $a(a3), d2
L077_000002A8:
; H077+$000002A8: 6d00002a  blt.w $2d4
        blt.w H077+$2D4
L077_000002AC:
; H077+$000002AC: 342b000a  move.w $a(a3), d2
        move.w $a(a3), d2
L077_000002B0:
; H077+$000002B0: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_000002B2:
; H077+$000002B2: 956b0008  sub.w d2, $8(a3)
        sub.w d2, $8(a3)
L077_000002B6:
; H077+$000002B6: 342b0014  move.w $14(a3), d2
        move.w $14(a3), d2
L077_000002BA:
; H077+$000002BA: d56b0010  add.w d2, $10(a3)
        add.w d2, $10(a3)
L077_000002BE:
; H077+$000002BE: 342b0014  move.w $14(a3), d2
        move.w $14(a3), d2
L077_000002C2:
; H077+$000002C2: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_000002C4:
; H077+$000002C4: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L077_000002C8:
; H077+$000002C8: 7400  moveq #$0, d2
        moveq #0, d2
L077_000002CA:
; H077+$000002CA: 142b0016  move.b $16(a3), d2
        move.b $16(a3), d2
L077_000002CE:
; H077+$000002CE: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_000002D0:
; H077+$000002D0: 17420016  move.b d2, $16(a3)
        move.b d2, $16(a3)
L077_000002D4:
; H077+$000002D4: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L077_000002DA:
; H077+$000002DA: 60000070  bra.w $34c
        bra.w H077+$34C
L077_000002DE:
; H077+$000002DE: 342b0010  move.w $10(a3), d2
        move.w $10(a3), d2
L077_000002E2:
; H077+$000002E2: b46b0006  cmp.w $6(a3), d2
        cmp.w $6(a3), d2
L077_000002E6:
; H077+$000002E6: 67000064  beq.w $34c
        beq.w H077+$34C
L077_000002EA:
; H077+$000002EA: 342b0014  move.w $14(a3), d2
        move.w $14(a3), d2
L077_000002EE:
; H077+$000002EE: d56b0010  add.w d2, $10(a3)
        add.w d2, $10(a3)
L077_000002F2:
; H077+$000002F2: 342b0014  move.w $14(a3), d2
        move.w $14(a3), d2
L077_000002F6:
; H077+$000002F6: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_000002F8:
; H077+$000002F8: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L077_000002FC:
; H077+$000002FC: 342b000a  move.w $a(a3), d2
        move.w $a(a3), d2
L077_00000300:
; H077+$00000300: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000302:
; H077+$00000302: d56b0008  add.w d2, $8(a3)
        add.w d2, $8(a3)
L077_00000306:
; H077+$00000306: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000308:
; H077+$00000308: 142b0016  move.b $16(a3), d2
        move.b $16(a3), d2
L077_0000030C:
; H077+$0000030C: 5442  addq.w #$2, d2
        addq.w #$2, d2
L077_0000030E:
; H077+$0000030E: 17420016  move.b d2, $16(a3)
        move.b d2, $16(a3)
L077_00000312:
; H077+$00000312: 342b0008  move.w $8(a3), d2
        move.w $8(a3), d2
L077_00000316:
; H077+$00000316: b46b000c  cmp.w $c(a3), d2
        cmp.w $c(a3), d2
L077_0000031A:
; H077+$0000031A: 6d00002a  blt.w $346
        blt.w H077+$346
L077_0000031E:
; H077+$0000031E: 342b000c  move.w $c(a3), d2
        move.w $c(a3), d2
L077_00000322:
; H077+$00000322: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000324:
; H077+$00000324: 956b0008  sub.w d2, $8(a3)
        sub.w d2, $8(a3)
L077_00000328:
; H077+$00000328: 342b0012  move.w $12(a3), d2
        move.w $12(a3), d2
L077_0000032C:
; H077+$0000032C: d56b000e  add.w d2, $e(a3)
        add.w d2, $e(a3)
L077_00000330:
; H077+$00000330: 342b0012  move.w $12(a3), d2
        move.w $12(a3), d2
L077_00000334:
; H077+$00000334: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_00000336:
; H077+$00000336: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L077_0000033A:
; H077+$0000033A: 7400  moveq #$0, d2
        moveq #0, d2
L077_0000033C:
; H077+$0000033C: 142b0016  move.b $16(a3), d2
        move.b $16(a3), d2
L077_00000340:
; H077+$00000340: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_00000342:
; H077+$00000342: 17420016  move.b d2, $16(a3)
        move.b d2, $16(a3)
L077_00000346:
; H077+$00000346: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L077_0000034C:
; H077+$0000034C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L077_00000350:
; H077+$00000350: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000352:
; H077+$00000352: 45f900003dd2  lea.l $3dd2.l, a2
        lea.l (H005+$3DD2).l, a2
L077_00000358:
; H077+$00000358: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L077_0000035C:
; H077+$0000035C: 45f22000  lea.l (a2, d2.w), a2
        lea.l (a2, d2.w), a2
L077_00000360:
; H077+$00000360: 177240000017  move.b (a2, d4.w), $17(a3)
        move.b (a2, d4.w), $17(a3)
L077_00000366:
; H077+$00000366: 102dfffb  move.b -$5(a5), d0
        move.b -$5(a5), d0
L077_0000036A:
; H077+$0000036A: 60000002  bra.w $36e
        bra.w H077+$36E
L077_0000036E:
; H077+$0000036E: 4e5d  unlk a5
        unlk a5
L077_00000370:
; H077+$00000370: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_00000372:
; H077+$00000372: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L077_00000374:
; H077+$00000374: 588f  addq.l #$4, a7
        addq.l #$4, a7
L077_00000376:
; H077+$00000376: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H077_00000378 [parziale]
; Scopo: Routine del modulo effetti visivi di combattimento e incantesimi; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H077+$0AF0, H085+$0F5E, H096+$3A32, H096+$3F3A, H097+$1AFC
; --------------------------------------------------------------------------
L077_00000378:
; H077+$00000378: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_0000037A:
; H077+$0000037A: 287afc84  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_0000037E:
; H077+$0000037E: 4e55ffcc  link.w a5, #$ffcc
        link.w a5, #$ffcc
L077_00000382:
; H077+$00000382: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L077_00000386:
; H077+$00000386: 3413  move.w (a3), d2
        move.w (a3), d2
L077_00000388:
; H077+$00000388: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_0000038A:
; H077+$0000038A: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_0000038C:
; H077+$0000038C: 3b42ffcc  move.w d2, -$34(a5)
        move.w d2, -$34(a5)
L077_00000390:
; H077+$00000390: 47edffe8  lea.l -$18(a5), a3
        lea.l -$18(a5), a3
L077_00000394:
; H077+$00000394: 36ad001e  move.w $1e(a5), (a3)
        move.w $1e(a5), (a3)
L077_00000398:
; H077+$00000398: 376d001c0002  move.w $1c(a5), $2(a3)
        move.w $1c(a5), $2(a3)
L077_0000039E:
; H077+$0000039E: 246d0018  movea.l $18(a5), a2
        movea.l $18(a5), a2
L077_000003A2:
; H077+$000003A2: 37520004  move.w (a2), $4(a3)
        move.w (a2), $4(a3)
L077_000003A6:
; H077+$000003A6: 246d0014  movea.l $14(a5), a2
        movea.l $14(a5), a2
L077_000003AA:
; H077+$000003AA: 37520006  move.w (a2), $6(a3)
        move.w (a2), $6(a3)
L077_000003AE:
; H077+$000003AE: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
L077_000003B2:
; H077+$000003B2: 6100fe18  bsr.w $1cc
        bsr.w H077+$1CC
L077_000003B6:
; H077+$000003B6: 47edffd0  lea.l -$30(a5), a3
        lea.l -$30(a5), a3
L077_000003BA:
; H077+$000003BA: 4253  clr.w (a3)
        clr.w (a3)
L077_000003BC:
; H077+$000003BC: 342d001c  move.w $1c(a5), d2
        move.w $1c(a5), d2
L077_000003C0:
; H077+$000003C0: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L077_000003C4:
; H077+$000003C4: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L077_000003C8:
; H077+$000003C8: 45ea000a  lea.l $a(a2), a2
        lea.l $a(a2), a2
L077_000003CC:
; H077+$000003CC: 382d001e  move.w $1e(a5), d4
        move.w $1e(a5), d4
L077_000003D0:
; H077+$000003D0: e344  asl.w #$1, d4
        asl.w #$1, d4
L077_000003D2:
; H077+$000003D2: 45f22800  lea.l (a2, d2.l), a2
        lea.l (a2, d2.l), a2
L077_000003D6:
; H077+$000003D6: 7400  moveq #$0, d2
        moveq #0, d2
L077_000003D8:
; H077+$000003D8: 14324001  move.b $1(a2, d4.w), d2
        move.b $1(a2, d4.w), d2
L077_000003DC:
; H077+$000003DC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_000003DE:
; H077+$000003DE: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_000003E0:
; H077+$000003E0: 45f900003ef4  lea.l $3ef4.l, a2
        lea.l (H005+$3EF4).l, a2
L077_000003E6:
; H077+$000003E6: 7800  moveq #$0, d4
        moveq #0, d4
L077_000003E8:
; H077+$000003E8: 18322001  move.b $1(a2, d2.w), d4
        move.b $1(a2, d2.w), d4
L077_000003EC:
; H077+$000003EC: 37440002  move.w d4, $2(a3)
        move.w d4, $2(a3)
L077_000003F0:
; H077+$000003F0: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L077_000003F4:
; H077+$000003F4: b46dfff4  cmp.w -$c(a5), d2
        cmp.w -$c(a5), d2
L077_000003F8:
; H077+$000003F8: 6f00000c  ble.w $406
        ble.w H077+$406
L077_000003FC:
; H077+$000003FC: 376dfff20004  move.w -$e(a5), $4(a3)
        move.w -$e(a5), $4(a3)
L077_00000402:
; H077+$00000402: 60000008  bra.w $40c
        bra.w H077+$40C
L077_00000406:
; H077+$00000406: 376dfff40004  move.w -$c(a5), $4(a3)
        move.w -$c(a5), $4(a3)
L077_0000040C:
; H077+$0000040C: 342d001c  move.w $1c(a5), d2
        move.w $1c(a5), d2
L077_00000410:
; H077+$00000410: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L077_00000414:
; H077+$00000414: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L077_00000418:
; H077+$00000418: 45ea000a  lea.l $a(a2), a2
        lea.l $a(a2), a2
L077_0000041C:
; H077+$0000041C: 382d001e  move.w $1e(a5), d4
        move.w $1e(a5), d4
L077_00000420:
; H077+$00000420: e344  asl.w #$1, d4
        asl.w #$1, d4
L077_00000422:
; H077+$00000422: 45f22800  lea.l (a2, d2.l), a2
        lea.l (a2, d2.l), a2
L077_00000426:
; H077+$00000426: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000428:
; H077+$00000428: 14324001  move.b $1(a2, d4.w), d2
        move.b $1(a2, d4.w), d2
L077_0000042C:
; H077+$0000042C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_0000042E:
; H077+$0000042E: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000430:
; H077+$00000430: 45f900003ef4  lea.l $3ef4.l, a2
        lea.l (H005+$3EF4).l, a2
L077_00000436:
; H077+$00000436: 7800  moveq #$0, d4
        moveq #0, d4
L077_00000438:
; H077+$00000438: 18322001  move.b $1(a2, d2.w), d4
        move.b $1(a2, d2.w), d4
L077_0000043C:
; H077+$0000043C: 37440006  move.w d4, $6(a3)
        move.w d4, $6(a3)
L077_00000440:
; H077+$00000440: 486dffd0  pea.l -$30(a5)
        pea.l -$30(a5)
L077_00000444:
; H077+$00000444: 6100fd86  bsr.w $1cc
        bsr.w H077+$1CC
L077_00000448:
; H077+$00000448: 422dffcf  clr.b -$31(a5)
        clr.b -$31(a5)
L077_0000044C:
; H077+$0000044C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L077_00000450:
; H077+$00000450: 4a2b0008  tst.b $8(a3)
        tst.b $8(a3)
L077_00000454:
; H077+$00000454: 6600003c  bne.w $492
        bne.w H077+$492
L077_00000458:
; H077+$00000458: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_0000045C:
; H077+$0000045C: c5fc0064  muls.w #$64, d2
        muls.w #$64, d2
L077_00000460:
; H077+$00000460: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L077_00000464:
; H077+$00000464: 47eb000a  lea.l $a(a3), a3
        lea.l $a(a3), a3
L077_00000468:
; H077+$00000468: 382dfff6  move.w -$a(a5), d4
        move.w -$a(a5), d4
L077_0000046C:
; H077+$0000046C: e344  asl.w #$1, d4
        asl.w #$1, d4
L077_0000046E:
; H077+$0000046E: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L077_00000472:
; H077+$00000472: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000474:
; H077+$00000474: 14334001  move.b $1(a3, d4.w), d2
        move.b $1(a3, d4.w), d2
L077_00000478:
; H077+$00000478: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_0000047A:
; H077+$0000047A: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_0000047C:
; H077+$0000047C: 47f900003ef4  lea.l $3ef4.l, a3
        lea.l (H005+$3EF4).l, a3
L077_00000482:
; H077+$00000482: 7800  moveq #$0, d4
        moveq #0, d4
L077_00000484:
; H077+$00000484: 18332002  move.b $2(a3, d2.w), d4
        move.b $2(a3, d2.w), d4
L077_00000488:
; H077+$00000488: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L077_0000048C:
; H077+$0000048C: b444  cmp.w d4, d2
        cmp.w d4, d2
L077_0000048E:
; H077+$0000048E: 6d000010  blt.w $4a0
        blt.w H077+$4A0
L077_00000492:
; H077+$00000492: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000494:
; H077+$00000494: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L077_00000498:
; H077+$00000498: b46dffcc  cmp.w -$34(a5), d2
        cmp.w -$34(a5), d2
L077_0000049C:
; H077+$0000049C: 63000024  bls.w $4c2
        bls.w H077+$4C2
L077_000004A0:
; H077+$000004A0: 266d0018  movea.l $18(a5), a3
        movea.l $18(a5), a3
L077_000004A4:
; H077+$000004A4: 36adfff6  move.w -$a(a5), (a3)
        move.w -$a(a5), (a3)
L077_000004A8:
; H077+$000004A8: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L077_000004AC:
; H077+$000004AC: 36adfff8  move.w -$8(a5), (a3)
        move.w -$8(a5), (a3)
L077_000004B0:
; H077+$000004B0: 7400  moveq #$0, d2
        moveq #0, d2
L077_000004B2:
; H077+$000004B2: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L077_000004B6:
; H077+$000004B6: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L077_000004BA:
; H077+$000004BA: 3682  move.w d2, (a3)
        move.w d2, (a3)
L077_000004BC:
; H077+$000004BC: 7000  moveq #$0, d0
        moveq #0, d0
L077_000004BE:
; H077+$000004BE: 6000003c  bra.w $4fc
        bra.w H077+$4FC
L077_000004C2:
; H077+$000004C2: 486dffd0  pea.l -$30(a5)
        pea.l -$30(a5)
L077_000004C6:
; H077+$000004C6: 6100fd7a  bsr.w $242
        bsr.w H077+$242
L077_000004CA:
; H077+$000004CA: 1b40ffce  move.b d0, -$32(a5)
        move.b d0, -$32(a5)
L077_000004CE:
; H077+$000004CE: 486dffe8  pea.l -$18(a5)
        pea.l -$18(a5)
L077_000004D2:
; H077+$000004D2: 6100fd6e  bsr.w $242
        bsr.w H077+$242
L077_000004D6:
; H077+$000004D6: 1400  move.b d0, d2
        move.b d0, d2
L077_000004D8:
; H077+$000004D8: 4a02  tst.b d2
        tst.b d2
L077_000004DA:
; H077+$000004DA: 57c2  seq.b d2
        seq.b d2
L077_000004DC:
; H077+$000004DC: 4402  neg.b d2
        neg.b d2
L077_000004DE:
; H077+$000004DE: 1b42ffcf  move.b d2, -$31(a5)
        move.b d2, -$31(a5)
L077_000004E2:
; H077+$000004E2: 4a2dffcf  tst.b -$31(a5)
        tst.b -$31(a5)
L077_000004E6:
; H077+$000004E6: 6700ff64  beq.w $44c
        beq.w H077+$44C
L077_000004EA:
; H077+$000004EA: 7400  moveq #$0, d2
        moveq #0, d2
L077_000004EC:
; H077+$000004EC: 142dfffe  move.b -$2(a5), d2
        move.b -$2(a5), d2
L077_000004F0:
; H077+$000004F0: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L077_000004F4:
; H077+$000004F4: 3682  move.w d2, (a3)
        move.w d2, (a3)
L077_000004F6:
; H077+$000004F6: 7001  moveq #$1, d0
        moveq #1, d0
L077_000004F8:
; H077+$000004F8: 60000002  bra.w $4fc
        bra.w H077+$4FC
L077_000004FC:
; H077+$000004FC: 4e5d  unlk a5
        unlk a5
L077_000004FE:
; H077+$000004FE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_00000500:
; H077+$00000500: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L077_00000502:
; H077+$00000502: 4fef0014  lea.l $14(a7), a7
        lea.l $14(a7), a7
L077_00000506:
; H077+$00000506: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H077_00000508 [parziale]
; Scopo: Routine del modulo effetti visivi di combattimento e incantesimi; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H077+$0A92, H077+$0BD0, H033+$15F8, H096+$0FE4
; --------------------------------------------------------------------------
L077_00000508:
; H077+$00000508: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_0000050A:
; H077+$0000050A: 287afaf4  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_0000050E:
; H077+$0000050E: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L077_00000512:
; H077+$00000512: 4a6d0014  tst.w $14(a5)
        tst.w $14(a5)
L077_00000516:
; H077+$00000516: 6d000042  blt.w $55a
        blt.w H077+$55A
L077_0000051A:
; H077+$0000051A: 0c6d00310014  cmpi.w #$31, $14(a5)
        cmpi.w #$31, $14(a5)
L077_00000520:
; H077+$00000520: 6e000038  bgt.w $55a
        bgt.w H077+$55A
L077_00000524:
; H077+$00000524: 4a6d0012  tst.w $12(a5)
        tst.w $12(a5)
L077_00000528:
; H077+$00000528: 6d000030  blt.w $55a
        blt.w H077+$55A
L077_0000052C:
; H077+$0000052C: 0c6d00180012  cmpi.w #$18, $12(a5)
        cmpi.w #$18, $12(a5)
L077_00000532:
; H077+$00000532: 6e000026  bgt.w $55a
        bgt.w H077+$55A
L077_00000536:
; H077+$00000536: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L077_0000053A:
; H077+$0000053A: 6d00001e  blt.w $55a
        blt.w H077+$55A
L077_0000053E:
; H077+$0000053E: 0c6d00310010  cmpi.w #$31, $10(a5)
        cmpi.w #$31, $10(a5)
L077_00000544:
; H077+$00000544: 6e000014  bgt.w $55a
        bgt.w H077+$55A
L077_00000548:
; H077+$00000548: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L077_0000054C:
; H077+$0000054C: 6d00000c  blt.w $55a
        blt.w H077+$55A
L077_00000550:
; H077+$00000550: 0c6d0018000e  cmpi.w #$18, $e(a5)
        cmpi.w #$18, $e(a5)
L077_00000556:
; H077+$00000556: 6f00000a  ble.w $562
        ble.w H077+$562
L077_0000055A:
; H077+$0000055A: 422dfffb  clr.b -$5(a5)
        clr.b -$5(a5)
L077_0000055E:
; H077+$0000055E: 60000338  bra.w $898
        bra.w H077+$898
L077_00000562:
; H077+$00000562: 0c6d00ff000c  cmpi.w #$ff, $c(a5)
        cmpi.w #$ff, $c(a5)
L077_00000568:
; H077+$00000568: 66000008  bne.w $572
        bne.w H077+$572
L077_0000056C:
; H077+$0000056C: 3b7c0008000c  move.w #$8, $c(a5)
        move.w #$8, $c(a5)
L077_00000572:
; H077+$00000572: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L077_00000576:
; H077+$00000576: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000578:
; H077+$00000578: 47f900003ee2  lea.l $3ee2.l, a3
        lea.l (H005+$3EE2).l, a3
L077_0000057E:
; H077+$0000057E: 382d0014  move.w $14(a5), d4
        move.w $14(a5), d4
L077_00000582:
; H077+$00000582: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L077_00000586:
; H077+$00000586: 3b44fffe  move.w d4, -$2(a5)
        move.w d4, -$2(a5)
L077_0000058A:
; H077+$0000058A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L077_0000058E:
; H077+$0000058E: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000590:
; H077+$00000590: 47f900003ed0  lea.l $3ed0.l, a3
        lea.l (H005+$3ED0).l, a3
L077_00000596:
; H077+$00000596: 382d0012  move.w $12(a5), d4
        move.w $12(a5), d4
L077_0000059A:
; H077+$0000059A: d8732000  add.w (a3, d2.w), d4
        add.w (a3, d2.w), d4
L077_0000059E:
; H077+$0000059E: 3b44fffc  move.w d4, -$4(a5)
        move.w d4, -$4(a5)
L077_000005A2:
; H077+$000005A2: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L077_000005A6:
; H077+$000005A6: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L077_000005AA:
; H077+$000005AA: 6600000e  bne.w $5ba
        bne.w H077+$5BA
L077_000005AE:
; H077+$000005AE: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L077_000005B2:
; H077+$000005B2: b46d000e  cmp.w $e(a5), d2
        cmp.w $e(a5), d2
L077_000005B6:
; H077+$000005B6: 6700001a  beq.w $5d2
        beq.w H077+$5D2
L077_000005BA:
; H077+$000005BA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000005BE:
; H077+$000005BE: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L077_000005C2:
; H077+$000005C2: 66000018  bne.w $5dc
        bne.w H077+$5DC
L077_000005C6:
; H077+$000005C6: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L077_000005CA:
; H077+$000005CA: b46d000e  cmp.w $e(a5), d2
        cmp.w $e(a5), d2
L077_000005CE:
; H077+$000005CE: 6600000c  bne.w $5dc
        bne.w H077+$5DC
L077_000005D2:
; H077+$000005D2: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L077_000005D8:
; H077+$000005D8: 600002be  bra.w $898
        bra.w H077+$898
L077_000005DC:
; H077+$000005DC: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L077_000005E0:
; H077+$000005E0: 600002a0  bra.w $882
        bra.w H077+$882
L077_000005E4:
; H077+$000005E4: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_000005E8:
; H077+$000005E8: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_000005EC:
; H077+$000005EC: 6d000018  blt.w $606
        blt.w H077+$606
L077_000005F0:
; H077+$000005F0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000005F4:
; H077+$000005F4: 946d0010  sub.w $10(a5), d2
        sub.w $10(a5), d2
L077_000005F8:
; H077+$000005F8: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_000005FC:
; H077+$000005FC: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000600:
; H077+$00000600: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000602:
; H077+$00000602: 6f000024  ble.w $628
        ble.w H077+$628
L077_00000606:
; H077+$00000606: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_0000060A:
; H077+$0000060A: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_0000060E:
; H077+$0000060E: 6e00001c  bgt.w $62c
        bgt.w H077+$62C
L077_00000612:
; H077+$00000612: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_00000616:
; H077+$00000616: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L077_0000061A:
; H077+$0000061A: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000061E:
; H077+$0000061E: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000622:
; H077+$00000622: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000624:
; H077+$00000624: 6e000006  bgt.w $62c
        bgt.w H077+$62C
L077_00000628:
; H077+$00000628: 7401  moveq #$1, d2
        moveq #1, d2
L077_0000062A:
; H077+$0000062A: 6002  bra.b $62e
        bra.b H077+$62E
L077_0000062C:
; H077+$0000062C: 7400  moveq #$0, d2
        moveq #0, d2
L077_0000062E:
; H077+$0000062E: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_00000632:
; H077+$00000632: 4e75  rts 
        rts 
L077_00000634:
; H077+$00000634: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_00000638:
; H077+$00000638: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_0000063C:
; H077+$0000063C: 6d000018  blt.w $656
        blt.w H077+$656
L077_00000640:
; H077+$00000640: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000644:
; H077+$00000644: 946d0010  sub.w $10(a5), d2
        sub.w $10(a5), d2
L077_00000648:
; H077+$00000648: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000064C:
; H077+$0000064C: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000650:
; H077+$00000650: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000652:
; H077+$00000652: 6f000024  ble.w $678
        ble.w H077+$678
L077_00000656:
; H077+$00000656: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_0000065A:
; H077+$0000065A: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000065E:
; H077+$0000065E: 946d000e  sub.w $e(a5), d2
        sub.w $e(a5), d2
L077_00000662:
; H077+$00000662: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_00000666:
; H077+$00000666: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000668:
; H077+$00000668: 6d000012  blt.w $67c
        blt.w H077+$67C
L077_0000066C:
; H077+$0000066C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_00000670:
; H077+$00000670: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_00000674:
; H077+$00000674: 6e000006  bgt.w $67c
        bgt.w H077+$67C
L077_00000678:
; H077+$00000678: 7401  moveq #$1, d2
        moveq #1, d2
L077_0000067A:
; H077+$0000067A: 6002  bra.b $67e
        bra.b H077+$67E
L077_0000067C:
; H077+$0000067C: 7400  moveq #$0, d2
        moveq #0, d2
L077_0000067E:
; H077+$0000067E: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_00000682:
; H077+$00000682: 4e75  rts 
        rts 
L077_00000684:
; H077+$00000684: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000688:
; H077+$00000688: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000068C:
; H077+$0000068C: 946d000e  sub.w $e(a5), d2
        sub.w $e(a5), d2
L077_00000690:
; H077+$00000690: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_00000694:
; H077+$00000694: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000696:
; H077+$00000696: 6d00000e  blt.w $6a6
        blt.w H077+$6A6
L077_0000069A:
; H077+$0000069A: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_0000069E:
; H077+$0000069E: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_000006A2:
; H077+$000006A2: 6f000024  ble.w $6c8
        ble.w H077+$6C8
L077_000006A6:
; H077+$000006A6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000006AA:
; H077+$000006AA: d46d000e  add.w $e(a5), d2
        add.w $e(a5), d2
L077_000006AE:
; H077+$000006AE: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L077_000006B2:
; H077+$000006B2: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_000006B6:
; H077+$000006B6: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_000006B8:
; H077+$000006B8: 6d000012  blt.w $6cc
        blt.w H077+$6CC
L077_000006BC:
; H077+$000006BC: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_000006C0:
; H077+$000006C0: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_000006C4:
; H077+$000006C4: 6d000006  blt.w $6cc
        blt.w H077+$6CC
L077_000006C8:
; H077+$000006C8: 7401  moveq #$1, d2
        moveq #1, d2
L077_000006CA:
; H077+$000006CA: 6002  bra.b $6ce
        bra.b H077+$6CE
L077_000006CC:
; H077+$000006CC: 7400  moveq #$0, d2
        moveq #0, d2
L077_000006CE:
; H077+$000006CE: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_000006D2:
; H077+$000006D2: 4e75  rts 
        rts 
L077_000006D4:
; H077+$000006D4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000006D8:
; H077+$000006D8: d46d000e  add.w $e(a5), d2
        add.w $e(a5), d2
L077_000006DC:
; H077+$000006DC: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L077_000006E0:
; H077+$000006E0: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_000006E4:
; H077+$000006E4: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_000006E6:
; H077+$000006E6: 6d00000e  blt.w $6f6
        blt.w H077+$6F6
L077_000006EA:
; H077+$000006EA: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_000006EE:
; H077+$000006EE: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_000006F2:
; H077+$000006F2: 6c000024  bge.w $718
        bge.w H077+$718
L077_000006F6:
; H077+$000006F6: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_000006FA:
; H077+$000006FA: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_000006FE:
; H077+$000006FE: 6d00001c  blt.w $71c
        blt.w H077+$71C
L077_00000702:
; H077+$00000702: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_00000706:
; H077+$00000706: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L077_0000070A:
; H077+$0000070A: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000070E:
; H077+$0000070E: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000712:
; H077+$00000712: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000714:
; H077+$00000714: 6d000006  blt.w $71c
        blt.w H077+$71C
L077_00000718:
; H077+$00000718: 7401  moveq #$1, d2
        moveq #1, d2
L077_0000071A:
; H077+$0000071A: 6002  bra.b $71e
        bra.b H077+$71E
L077_0000071C:
; H077+$0000071C: 7400  moveq #$0, d2
        moveq #0, d2
L077_0000071E:
; H077+$0000071E: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_00000722:
; H077+$00000722: 4e75  rts 
        rts 
L077_00000724:
; H077+$00000724: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_00000728:
; H077+$00000728: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_0000072C:
; H077+$0000072C: 6d000018  blt.w $746
        blt.w H077+$746
L077_00000730:
; H077+$00000730: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_00000734:
; H077+$00000734: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L077_00000738:
; H077+$00000738: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000073C:
; H077+$0000073C: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000740:
; H077+$00000740: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000742:
; H077+$00000742: 6c000024  bge.w $768
        bge.w H077+$768
L077_00000746:
; H077+$00000746: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_0000074A:
; H077+$0000074A: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_0000074E:
; H077+$0000074E: 6e00001c  bgt.w $76c
        bgt.w H077+$76C
L077_00000752:
; H077+$00000752: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000756:
; H077+$00000756: 946d0010  sub.w $10(a5), d2
        sub.w $10(a5), d2
L077_0000075A:
; H077+$0000075A: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000075E:
; H077+$0000075E: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000762:
; H077+$00000762: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000764:
; H077+$00000764: 6d000006  blt.w $76c
        blt.w H077+$76C
L077_00000768:
; H077+$00000768: 7401  moveq #$1, d2
        moveq #1, d2
L077_0000076A:
; H077+$0000076A: 6002  bra.b $76e
        bra.b H077+$76E
L077_0000076C:
; H077+$0000076C: 7400  moveq #$0, d2
        moveq #0, d2
L077_0000076E:
; H077+$0000076E: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_00000772:
; H077+$00000772: 4e75  rts 
        rts 
L077_00000774:
; H077+$00000774: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_00000778:
; H077+$00000778: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_0000077C:
; H077+$0000077C: 6e000018  bgt.w $796
        bgt.w H077+$796
L077_00000780:
; H077+$00000780: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000784:
; H077+$00000784: 946d0010  sub.w $10(a5), d2
        sub.w $10(a5), d2
L077_00000788:
; H077+$00000788: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000078C:
; H077+$0000078C: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000790:
; H077+$00000790: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000792:
; H077+$00000792: 6c000024  bge.w $7b8
        bge.w H077+$7B8
L077_00000796:
; H077+$00000796: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_0000079A:
; H077+$0000079A: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000079E:
; H077+$0000079E: 946d000e  sub.w $e(a5), d2
        sub.w $e(a5), d2
L077_000007A2:
; H077+$000007A2: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_000007A6:
; H077+$000007A6: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_000007A8:
; H077+$000007A8: 6e000012  bgt.w $7bc
        bgt.w H077+$7BC
L077_000007AC:
; H077+$000007AC: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_000007B0:
; H077+$000007B0: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_000007B4:
; H077+$000007B4: 6d000006  blt.w $7bc
        blt.w H077+$7BC
L077_000007B8:
; H077+$000007B8: 7401  moveq #$1, d2
        moveq #1, d2
L077_000007BA:
; H077+$000007BA: 6002  bra.b $7be
        bra.b H077+$7BE
L077_000007BC:
; H077+$000007BC: 7400  moveq #$0, d2
        moveq #0, d2
L077_000007BE:
; H077+$000007BE: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_000007C2:
; H077+$000007C2: 4e75  rts 
        rts 
L077_000007C4:
; H077+$000007C4: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000007C8:
; H077+$000007C8: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_000007CC:
; H077+$000007CC: 946d000e  sub.w $e(a5), d2
        sub.w $e(a5), d2
L077_000007D0:
; H077+$000007D0: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_000007D4:
; H077+$000007D4: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_000007D6:
; H077+$000007D6: 6e00000e  bgt.w $7e6
        bgt.w H077+$7E6
L077_000007DA:
; H077+$000007DA: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_000007DE:
; H077+$000007DE: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_000007E2:
; H077+$000007E2: 6c000024  bge.w $808
        bge.w H077+$808
L077_000007E6:
; H077+$000007E6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_000007EA:
; H077+$000007EA: d46d000e  add.w $e(a5), d2
        add.w $e(a5), d2
L077_000007EE:
; H077+$000007EE: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L077_000007F2:
; H077+$000007F2: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_000007F6:
; H077+$000007F6: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_000007F8:
; H077+$000007F8: 6e000012  bgt.w $80c
        bgt.w H077+$80C
L077_000007FC:
; H077+$000007FC: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_00000800:
; H077+$00000800: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_00000804:
; H077+$00000804: 6e000006  bgt.w $80c
        bgt.w H077+$80C
L077_00000808:
; H077+$00000808: 7401  moveq #$1, d2
        moveq #1, d2
L077_0000080A:
; H077+$0000080A: 6002  bra.b $80e
        bra.b H077+$80E
L077_0000080C:
; H077+$0000080C: 7400  moveq #$0, d2
        moveq #0, d2
L077_0000080E:
; H077+$0000080E: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_00000812:
; H077+$00000812: 4e75  rts 
        rts 
L077_00000814:
; H077+$00000814: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000818:
; H077+$00000818: d46d000e  add.w $e(a5), d2
        add.w $e(a5), d2
L077_0000081C:
; H077+$0000081C: 946dfffc  sub.w -$4(a5), d2
        sub.w -$4(a5), d2
L077_00000820:
; H077+$00000820: 382d0010  move.w $10(a5), d4
        move.w $10(a5), d4
L077_00000824:
; H077+$00000824: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000826:
; H077+$00000826: 6e00000e  bgt.w $836
        bgt.w H077+$836
L077_0000082A:
; H077+$0000082A: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L077_0000082E:
; H077+$0000082E: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L077_00000832:
; H077+$00000832: 6f000024  ble.w $858
        ble.w H077+$858
L077_00000836:
; H077+$00000836: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_0000083A:
; H077+$0000083A: b46dfffe  cmp.w -$2(a5), d2
        cmp.w -$2(a5), d2
L077_0000083E:
; H077+$0000083E: 6e00001c  bgt.w $85c
        bgt.w H077+$85C
L077_00000842:
; H077+$00000842: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L077_00000846:
; H077+$00000846: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L077_0000084A:
; H077+$0000084A: d46dfffc  add.w -$4(a5), d2
        add.w -$4(a5), d2
L077_0000084E:
; H077+$0000084E: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L077_00000852:
; H077+$00000852: b842  cmp.w d2, d4
        cmp.w d2, d4
L077_00000854:
; H077+$00000854: 6e000006  bgt.w $85c
        bgt.w H077+$85C
L077_00000858:
; H077+$00000858: 7401  moveq #$1, d2
        moveq #1, d2
L077_0000085A:
; H077+$0000085A: 6002  bra.b $85e
        bra.b H077+$85E
L077_0000085C:
; H077+$0000085C: 7400  moveq #$0, d2
        moveq #0, d2
L077_0000085E:
; H077+$0000085E: 1b42fffb  move.b d2, -$5(a5)
        move.b d2, -$5(a5)
L077_00000862:
; H077+$00000862: 4e75  rts 
        rts 
L077_00000864:
; H077+$00000864: 1b7c0001fffb  move.b #$1, -$5(a5)
        move.b #$1, -$5(a5)
L077_0000086A:
; H077+$0000086A: 4e75  rts 
        rts 
L077_0000086C:
; H077+$0000086C: 4e75  rts 
        rts 
; Preserved bytes H077+$0000086E..$00000882; code/data not fully classified.
        dc.w $FFFC,$FD74,$FDC4,$FE14,$FE64,$FEB4,$FF04,$FF54
        dc.w $FFA4,$FFF4
L077_00000882:
; H077+$00000882: 47faffec  lea.l $870(pc), a3
        lea.l H077+$870(pc), a3
L077_00000886:
; H077+$00000886: 0c420008  cmpi.w #$8, d2
        cmpi.w #$8, d2
L077_0000088A:
; H077+$0000088A: 6302  bls.b $88e
        bls.b H077+$88E
L077_0000088C:
; H077+$0000088C: 74ff  moveq #$ff, d2
        moveq #-1, d2
L077_0000088E:
; H077+$0000088E: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000890:
; H077+$00000890: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H077+$0870; indici 0..8, default -1.
L077_00000894:
; H077+$00000894: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L077_00000898:
; H077+$00000898: 102dfffb  move.b -$5(a5), d0
        move.b -$5(a5), d0
L077_0000089C:
; H077+$0000089C: 60000002  bra.w $8a0
        bra.w H077+$8A0
L077_000008A0:
; H077+$000008A0: 4e5d  unlk a5
        unlk a5
L077_000008A2:
; H077+$000008A2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_000008A4:
; H077+$000008A4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L077_000008A6:
; H077+$000008A6: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L077_000008AA:
; H077+$000008AA: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H077_000008AC [parziale]
; Scopo: Routine del modulo effetti visivi di combattimento e incantesimi; richiama H048+$0044.
;   - Richiama H048+$0044.
; Chiamanti diretti: H027+$1A8A, H027+$1E8C, H027+$22DA, H027+$2B86, H027+$31C2, H063+$2E4E e altri 11
; --------------------------------------------------------------------------
L077_000008AC:
; H077+$000008AC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L077_000008AE:
; H077+$000008AE: 287af750  movea.l $0(pc), a4
        movea.l H077+$0(pc), a4
L077_000008B2:
; H077+$000008B2: 4e55ffc6  link.w a5, #$ffc6
        link.w a5, #$ffc6
L077_000008B6:
; H077+$000008B6: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L077_000008BA:
; H077+$000008BA: 0c6d0003fffa  cmpi.w #$3, -$6(a5)
        cmpi.w #$3, -$6(a5)
L077_000008C0:
; H077+$000008C0: 62000066  bhi.w $928
        bhi.w H077+$928
L077_000008C4:
; H077+$000008C4: 3f2d0010  move.w $10(a5), -(a7)
        move.w $10(a5), -(a7)
L077_000008C8:
; H077+$000008C8: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L077_000008CC:
; H077+$000008CC: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L077_000008D0:
; H077+$000008D0: 486dffea  pea.l -$16(a5)
        pea.l -$16(a5)
; -> H048+$0044 (trampoline_H048_00B6)
L077_000008D4:
; H077+$000008D4: 4eb900000044  jsr $44.l
        jsr (H048+$44).l
L077_000008DA:
; H077+$000008DA: 1400  move.b d0, d2
        move.b d0, d2
L077_000008DC:
; H077+$000008DC: 4a02  tst.b d2
        tst.b d2
L077_000008DE:
; H077+$000008DE: 67000032  beq.w $912
        beq.w H077+$912
L077_000008E2:
; H077+$000008E2: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_000008E6:
; H077+$000008E6: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_000008E8:
; H077+$000008E8: 47edffe2  lea.l -$1e(a5), a3
        lea.l -$1e(a5), a3
L077_000008EC:
; H077+$000008EC: 382d0018  move.w $18(a5), d4
        move.w $18(a5), d4
L077_000008F0:
; H077+$000008F0: d86dffec  add.w -$14(a5), d4
        add.w -$14(a5), d4
L077_000008F4:
; H077+$000008F4: 37842000  move.w d4, (a3, d2.w)
        move.w d4, (a3, d2.w)
L077_000008F8:
; H077+$000008F8: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_000008FC:
; H077+$000008FC: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_000008FE:
; H077+$000008FE: 47edffda  lea.l -$26(a5), a3
        lea.l -$26(a5), a3
L077_00000902:
; H077+$00000902: 382d0016  move.w $16(a5), d4
        move.w $16(a5), d4
L077_00000906:
; H077+$00000906: d86dffea  add.w -$16(a5), d4
        add.w -$16(a5), d4
L077_0000090A:
; H077+$0000090A: 37842000  move.w d4, (a3, d2.w)
        move.w d4, (a3, d2.w)
L077_0000090E:
; H077+$0000090E: 60000012  bra.w $922
        bra.w H077+$922
L077_00000912:
; H077+$00000912: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_00000916:
; H077+$00000916: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000918:
; H077+$00000918: 47edffe2  lea.l -$1e(a5), a3
        lea.l -$1e(a5), a3
L077_0000091C:
; H077+$0000091C: 37bcffff2000  move.w #$ffff, (a3, d2.w)
        move.w #$ffff, (a3, d2.w)
L077_00000922:
; H077+$00000922: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L077_00000926:
; H077+$00000926: 6492  bcc.b $8ba
        bcc.b H077+$8BA
L077_00000928:
; H077+$00000928: 423900002479  clr.b $2479.l
        clr.b (H005+$2479).l
L077_0000092E:
; H077+$0000092E: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L077_00000934:
; H077+$00000934: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000936:
; H077+$00000936: 14390000247b  move.b $247b.l, d2
        move.b (H005+$247B).l, d2
L077_0000093C:
; H077+$0000093C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L077_0000093E:
; H077+$0000093E: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000942:
; H077+$00000942: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L077_00000944:
; H077+$00000944: 620002be  bhi.w $c04
        bhi.w H077+$C04
L077_00000948:
; H077+$00000948: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_0000094C:
; H077+$0000094C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_0000094E:
; H077+$0000094E: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L077_00000952:
; H077+$00000952: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L077_00000958:
; H077+$00000958: 7800  moveq #$0, d4
        moveq #0, d4
L077_0000095A:
; H077+$0000095A: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L077_0000095E:
; H077+$0000095E: 4a44  tst.w d4
        tst.w d4
L077_00000960:
; H077+$00000960: 6300029a  bls.w $bfc
        bls.w H077+$BFC
L077_00000964:
; H077+$00000964: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
L077_00000968:
; H077+$00000968: 3b7c00ffffc6  move.w #$ff, -$3a(a5)
        move.w #$ff, -$3a(a5)
L077_0000096E:
; H077+$0000096E: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L077_00000972:
; H077+$00000972: 0c6d0003fff8  cmpi.w #$3, -$8(a5)
        cmpi.w #$3, -$8(a5)
L077_00000978:
; H077+$00000978: 6200009c  bhi.w $a16
        bhi.w H077+$A16
L077_0000097C:
; H077+$0000097C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L077_00000980:
; H077+$00000980: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_00000982:
; H077+$00000982: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L077_00000986:
; H077+$00000986: 47f900003154  lea.l $3154.l, a3
        lea.l (H005+$3154).l, a3
L077_0000098C:
; H077+$0000098C: 7800  moveq #$0, d4
        moveq #0, d4
L077_0000098E:
; H077+$0000098E: 18332805  move.b $5(a3, d2.l), d4
        move.b $5(a3, d2.l), d4
L077_00000992:
; H077+$00000992: 3f04  move.w d4, -(a7)
        move.w d4, -(a7)
L077_00000994:
; H077+$00000994: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L077_00000998:
; H077+$00000998: 486dffec  pea.l -$14(a5)
        pea.l -$14(a5)
L077_0000099C:
; H077+$0000099C: 486dffea  pea.l -$16(a5)
        pea.l -$16(a5)
; -> H048+$0044 (trampoline_H048_00B6)
L077_000009A0:
; H077+$000009A0: 4eb900000044  jsr $44.l
        jsr (H048+$44).l
L077_000009A6:
; H077+$000009A6: 1400  move.b d0, d2
        move.b d0, d2
L077_000009A8:
; H077+$000009A8: 4a02  tst.b d2
        tst.b d2
L077_000009AA:
; H077+$000009AA: 67000052  beq.w $9fe
        beq.w H077+$9FE
L077_000009AE:
; H077+$000009AE: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_000009B2:
; H077+$000009B2: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_000009B4:
; H077+$000009B4: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L077_000009B8:
; H077+$000009B8: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L077_000009BC:
; H077+$000009BC: 5344  subq.w #$1, d4
        subq.w #$1, d4
L077_000009BE:
; H077+$000009BE: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L077_000009C2:
; H077+$000009C2: 45f900003154  lea.l $3154.l, a2
        lea.l (H005+$3154).l, a2
L077_000009C8:
; H077+$000009C8: 3c324800  move.w (a2, d4.l), d6
        move.w (a2, d4.l), d6
L077_000009CC:
; H077+$000009CC: dc6dffec  add.w -$14(a5), d6
        add.w -$14(a5), d6
L077_000009D0:
; H077+$000009D0: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L077_000009D4:
; H077+$000009D4: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_000009D8:
; H077+$000009D8: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_000009DA:
; H077+$000009DA: 47edffca  lea.l -$36(a5), a3
        lea.l -$36(a5), a3
L077_000009DE:
; H077+$000009DE: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L077_000009E2:
; H077+$000009E2: 5344  subq.w #$1, d4
        subq.w #$1, d4
L077_000009E4:
; H077+$000009E4: c9fc0006  muls.w #$6, d4
        muls.w #$6, d4
L077_000009E8:
; H077+$000009E8: 45f900003154  lea.l $3154.l, a2
        lea.l (H005+$3154).l, a2
L077_000009EE:
; H077+$000009EE: 3c324802  move.w $2(a2, d4.l), d6
        move.w $2(a2, d4.l), d6
L077_000009F2:
; H077+$000009F2: dc6dffea  add.w -$16(a5), d6
        add.w -$16(a5), d6
L077_000009F6:
; H077+$000009F6: 37862000  move.w d6, (a3, d2.w)
        move.w d6, (a3, d2.w)
L077_000009FA:
; H077+$000009FA: 60000012  bra.w $a0e
        bra.w H077+$A0E
L077_000009FE:
; H077+$000009FE: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_00000A02:
; H077+$00000A02: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000A04:
; H077+$00000A04: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L077_00000A08:
; H077+$00000A08: 37bcffff2000  move.w #$ffff, (a3, d2.w)
        move.w #$ffff, (a3, d2.w)
L077_00000A0E:
; H077+$00000A0E: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L077_00000A12:
; H077+$00000A12: 6400ff5e  bcc.w $972
        bcc.w H077+$972
L077_00000A16:
; H077+$00000A16: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L077_00000A1A:
; H077+$00000A1A: 0c6d0003fff8  cmpi.w #$3, -$8(a5)
        cmpi.w #$3, -$8(a5)
L077_00000A20:
; H077+$00000A20: 6200010e  bhi.w $b30
        bhi.w H077+$B30
L077_00000A24:
; H077+$00000A24: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_00000A28:
; H077+$00000A28: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000A2A:
; H077+$00000A2A: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L077_00000A2E:
; H077+$00000A2E: 4a732000  tst.w (a3, d2.w)
        tst.w (a3, d2.w)
L077_00000A32:
; H077+$00000A32: 6d0000f4  blt.w $b28
        blt.w H077+$B28
L077_00000A36:
; H077+$00000A36: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L077_00000A3A:
; H077+$00000A3A: 0c6d0003fffa  cmpi.w #$3, -$6(a5)
        cmpi.w #$3, -$6(a5)
L077_00000A40:
; H077+$00000A40: 620000e6  bhi.w $b28
        bhi.w H077+$B28
L077_00000A44:
; H077+$00000A44: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_00000A48:
; H077+$00000A48: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000A4A:
; H077+$00000A4A: 47edffe2  lea.l -$1e(a5), a3
        lea.l -$1e(a5), a3
L077_00000A4E:
; H077+$00000A4E: 4a732000  tst.w (a3, d2.w)
        tst.w (a3, d2.w)
L077_00000A52:
; H077+$00000A52: 6d0000cc  blt.w $b20
        blt.w H077+$B20
L077_00000A56:
; H077+$00000A56: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_00000A5A:
; H077+$00000A5A: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000A5C:
; H077+$00000A5C: 47edffe2  lea.l -$1e(a5), a3
        lea.l -$1e(a5), a3
L077_00000A60:
; H077+$00000A60: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000A64:
; H077+$00000A64: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_00000A68:
; H077+$00000A68: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000A6A:
; H077+$00000A6A: 47edffda  lea.l -$26(a5), a3
        lea.l -$26(a5), a3
L077_00000A6E:
; H077+$00000A6E: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000A72:
; H077+$00000A72: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_00000A76:
; H077+$00000A76: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000A78:
; H077+$00000A78: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L077_00000A7C:
; H077+$00000A7C: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000A80:
; H077+$00000A80: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_00000A84:
; H077+$00000A84: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000A86:
; H077+$00000A86: 47edffca  lea.l -$36(a5), a3
        lea.l -$36(a5), a3
L077_00000A8A:
; H077+$00000A8A: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000A8E:
; H077+$00000A8E: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L077_00000A92:
; H077+$00000A92: 6100fa74  bsr.w $508
        bsr.w H077+$508
L077_00000A96:
; H077+$00000A96: 1400  move.b d0, d2
        move.b d0, d2
L077_00000A98:
; H077+$00000A98: 4a02  tst.b d2
        tst.b d2
L077_00000A9A:
; H077+$00000A9A: 67000084  beq.w $b20
        beq.w H077+$B20
L077_00000A9E:
; H077+$00000A9E: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_00000AA2:
; H077+$00000AA2: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000AA4:
; H077+$00000AA4: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L077_00000AA8:
; H077+$00000AA8: 3b732000fff0  move.w (a3, d2.w), -$10(a5)
        move.w (a3, d2.w), -$10(a5)
L077_00000AAE:
; H077+$00000AAE: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L077_00000AB2:
; H077+$00000AB2: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000AB4:
; H077+$00000AB4: 47edffca  lea.l -$36(a5), a3
        lea.l -$36(a5), a3
L077_00000AB8:
; H077+$00000AB8: 3b732000ffee  move.w (a3, d2.w), -$12(a5)
        move.w (a3, d2.w), -$12(a5)
L077_00000ABE:
; H077+$00000ABE: 3b6d0014ffc8  move.w $14(a5), -$38(a5)
        move.w $14(a5), -$38(a5)
L077_00000AC4:
; H077+$00000AC4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_00000AC8:
; H077+$00000AC8: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000ACA:
; H077+$00000ACA: 47edffe2  lea.l -$1e(a5), a3
        lea.l -$1e(a5), a3
L077_00000ACE:
; H077+$00000ACE: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000AD2:
; H077+$00000AD2: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L077_00000AD6:
; H077+$00000AD6: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000AD8:
; H077+$00000AD8: 47edffda  lea.l -$26(a5), a3
        lea.l -$26(a5), a3
L077_00000ADC:
; H077+$00000ADC: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000AE0:
; H077+$00000AE0: 486dfff0  pea.l -$10(a5)
        pea.l -$10(a5)
L077_00000AE4:
; H077+$00000AE4: 486dffee  pea.l -$12(a5)
        pea.l -$12(a5)
L077_00000AE8:
; H077+$00000AE8: 486dffc8  pea.l -$38(a5)
        pea.l -$38(a5)
L077_00000AEC:
; H077+$00000AEC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L077_00000AF0:
; H077+$00000AF0: 6100f886  bsr.w $378
        bsr.w H077+$378
L077_00000AF4:
; H077+$00000AF4: 1400  move.b d0, d2
        move.b d0, d2
L077_00000AF6:
; H077+$00000AF6: 4a02  tst.b d2
        tst.b d2
L077_00000AF8:
; H077+$00000AF8: 67000026  beq.w $b20
        beq.w H077+$B20
L077_00000AFC:
; H077+$00000AFC: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L077_00000B02:
; H077+$00000B02: 342dffc8  move.w -$38(a5), d2
        move.w -$38(a5), d2
L077_00000B06:
; H077+$00000B06: b46dffc6  cmp.w -$3a(a5), d2
        cmp.w -$3a(a5), d2
L077_00000B0A:
; H077+$00000B0A: 64000014  bcc.w $b20
        bcc.w H077+$B20
L077_00000B0E:
; H077+$00000B0E: 3b6dffc8ffc6  move.w -$38(a5), -$3a(a5)
        move.w -$38(a5), -$3a(a5)
L077_00000B14:
; H077+$00000B14: 3b6dfffafff6  move.w -$6(a5), -$a(a5)
        move.w -$6(a5), -$a(a5)
L077_00000B1A:
; H077+$00000B1A: 3b6dfff8fff4  move.w -$8(a5), -$c(a5)
        move.w -$8(a5), -$c(a5)
L077_00000B20:
; H077+$00000B20: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L077_00000B24:
; H077+$00000B24: 6400ff14  bcc.w $a3a
        bcc.w H077+$A3A
L077_00000B28:
; H077+$00000B28: 526dfff8  addq.w #$1, -$8(a5)
        addq.w #$1, -$8(a5)
L077_00000B2C:
; H077+$00000B2C: 6400feec  bcc.w $a1a
        bcc.w H077+$A1A
L077_00000B30:
; H077+$00000B30: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L077_00000B34:
; H077+$00000B34: 670000c6  beq.w $bfc
        beq.w H077+$BFC
L077_00000B38:
; H077+$00000B38: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000B3A:
; H077+$00000B3A: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L077_00000B40:
; H077+$00000B40: 5242  addq.w #$1, d2
        addq.w #$1, d2
L077_00000B42:
; H077+$00000B42: 13c200002479  move.b d2, $2479.l
        move.b d2, (H005+$2479).l
L077_00000B48:
; H077+$00000B48: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000B4A:
; H077+$00000B4A: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L077_00000B50:
; H077+$00000B50: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_00000B52:
; H077+$00000B52: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000B54:
; H077+$00000B54: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_00000B5A:
; H077+$00000B5A: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L077_00000B5E:
; H077+$00000B5E: 17842000  move.b d4, (a3, d2.w)
        move.b d4, (a3, d2.w)
L077_00000B62:
; H077+$00000B62: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000B64:
; H077+$00000B64: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L077_00000B6A:
; H077+$00000B6A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_00000B6C:
; H077+$00000B6C: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000B6E:
; H077+$00000B6E: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_00000B74:
; H077+$00000B74: 382dffc6  move.w -$3a(a5), d4
        move.w -$3a(a5), d4
L077_00000B78:
; H077+$00000B78: 17842001  move.b d4, $1(a3, d2.w)
        move.b d4, $1(a3, d2.w)
L077_00000B7C:
; H077+$00000B7C: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L077_00000B80:
; H077+$00000B80: 0c6d00080012  cmpi.w #$8, $12(a5)
        cmpi.w #$8, $12(a5)
L077_00000B86:
; H077+$00000B86: 6400000c  bcc.w $b94
        bcc.w H077+$B94
L077_00000B8A:
; H077+$00000B8A: 3b6d0012fffc  move.w $12(a5), -$4(a5)
        move.w $12(a5), -$4(a5)
L077_00000B90:
; H077+$00000B90: 60000050  bra.w $be2
        bra.w H077+$BE2
L077_00000B94:
; H077+$00000B94: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L077_00000B98:
; H077+$00000B98: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000B9A:
; H077+$00000B9A: 47edffe2  lea.l -$1e(a5), a3
        lea.l -$1e(a5), a3
L077_00000B9E:
; H077+$00000B9E: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000BA2:
; H077+$00000BA2: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L077_00000BA6:
; H077+$00000BA6: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000BA8:
; H077+$00000BA8: 47edffda  lea.l -$26(a5), a3
        lea.l -$26(a5), a3
L077_00000BAC:
; H077+$00000BAC: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000BB0:
; H077+$00000BB0: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L077_00000BB4:
; H077+$00000BB4: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000BB6:
; H077+$00000BB6: 47edffd2  lea.l -$2e(a5), a3
        lea.l -$2e(a5), a3
L077_00000BBA:
; H077+$00000BBA: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000BBE:
; H077+$00000BBE: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L077_00000BC2:
; H077+$00000BC2: e342  asl.w #$1, d2
        asl.w #$1, d2
L077_00000BC4:
; H077+$00000BC4: 47edffca  lea.l -$36(a5), a3
        lea.l -$36(a5), a3
L077_00000BC8:
; H077+$00000BC8: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L077_00000BCC:
; H077+$00000BCC: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L077_00000BD0:
; H077+$00000BD0: 6100f936  bsr.w $508
        bsr.w H077+$508
L077_00000BD4:
; H077+$00000BD4: 1400  move.b d0, d2
        move.b d0, d2
L077_00000BD6:
; H077+$00000BD6: 4a02  tst.b d2
        tst.b d2
L077_00000BD8:
; H077+$00000BD8: 66000008  bne.w $be2
        bne.w H077+$BE2
L077_00000BDC:
; H077+$00000BDC: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L077_00000BE0:
; H077+$00000BE0: 60b2  bra.b $b94
        bra.b H077+$B94
L077_00000BE2:
; H077+$00000BE2: 7400  moveq #$0, d2
        moveq #0, d2
L077_00000BE4:
; H077+$00000BE4: 143900002479  move.b $2479.l, d2
        move.b (H005+$2479).l, d2
L077_00000BEA:
; H077+$00000BEA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L077_00000BEC:
; H077+$00000BEC: e542  asl.w #$2, d2
        asl.w #$2, d2
L077_00000BEE:
; H077+$00000BEE: 47f900002a3e  lea.l $2a3e.l, a3
        lea.l (H005+$2A3E).l, a3
L077_00000BF4:
; H077+$00000BF4: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L077_00000BF8:
; H077+$00000BF8: 17842002  move.b d4, $2(a3, d2.w)
        move.b d4, $2(a3, d2.w)
L077_00000BFC:
; H077+$00000BFC: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L077_00000C00:
; H077+$00000C00: 6400fd3c  bcc.w $93e
        bcc.w H077+$93E
L077_00000C04:
; H077+$00000C04: 548f  addq.l #$2, a7
        addq.l #$2, a7
L077_00000C06:
; H077+$00000C06: 6100f44e  bsr.w $56
        bsr.w H077+$56
L077_00000C0A:
; H077+$00000C0A: 4e5d  unlk a5
        unlk a5
L077_00000C0C:
; H077+$00000C0C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_00000C0E:
; H077+$00000C0E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L077_00000C10:
; H077+$00000C10: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L077_00000C14:
; H077+$00000C14: 4ed0  jmp (a0)
        jmp (a0)
L077_00000C16:
; H077+$00000C16: 4e5d  unlk a5
        unlk a5
L077_00000C18:
; H077+$00000C18: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L077_00000C1A:
; H077+$00000C1A: 4e75  rts 
        rts 
; End H077: $C1C bytes
