; ============================================================================
; GUIDA DEL MODULO H060
; inizializzazione di area/vista e transizioni.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Inizializzazione di area/vista e transizioni: usa la mappa H011, le sequenze H042 e la diagnostica H056.
; --------------------------------------------------------------------------
; H060: 396 original bytes; all offsets are section-relative.
        section H060,code
H060:
; Preserved bytes H060+$00000000..$0000000A; code/data not fully classified.
        dc.w $6C6F,$7374,$0000
        dc.l H060+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H060 [parziale]
; Scopo: Ingresso del modulo inizializzazione di area/vista e transizioni; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H060+$0186.
; Chiamanti diretti: H000+$0186
; --------------------------------------------------------------------------
L060_0000000A:
; H060+$0000000A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L060_0000000C:
; H060+$0000000C: 287afff8  movea.l $6(pc), a4
        movea.l H060+$6(pc), a4
L060_00000010:
; H060+$00000010: 4e550000  link.w a5, #$0
        link.w a5, #$0
L060_00000014:
; H060+$00000014: 60000170  bra.w $186
        bra.w H060+$186
; --------------------------------------------------------------------------
; ROUTINE: sub_H060_00000018 [parziale]
; Scopo: Routine del modulo inizializzazione di area/vista e transizioni; richiama H011+$04E2, H056+$0886, H011+$0B78, H042+$10DC.
;   - Richiama H011+$04E2.
;   - Richiama H056+$0886.
;   - Richiama H011+$0B78.
;   - Richiama H042+$10DC.
;   - Usa lo stato globale: H005+$24D0 (richiesta di uscita dal ciclo scenario); H005+$3E04 (puntatore stato persistente A, 2048 byte); H005+$281C (inizio del blocco coordinate/vista).
; Chiamanti diretti: H063+$333E, H063+$3302, H012+$32D2, H012+$30EC, H012+$33B8, H012+$2972 e altri 6
; --------------------------------------------------------------------------
L060_00000018:
; H060+$00000018: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L060_0000001A:
; H060+$0000001A: 287affea  movea.l $6(pc), a4
        movea.l H060+$6(pc), a4
L060_0000001E:
; H060+$0000001E: 4e55ffda  link.w a5, #$ffda
        link.w a5, #$ffda
L060_00000022:
; H060+$00000022: 426dffe0  clr.w -$20(a5)
        clr.w -$20(a5)
L060_00000026:
; H060+$00000026: 3b7c000fffe2  move.w #$f, -$1e(a5)
        move.w #$f, -$1e(a5)
L060_0000002C:
; H060+$0000002C: 3b7c0004ffe4  move.w #$4, -$1c(a5)
        move.w #$4, -$1c(a5)
L060_00000032:
; H060+$00000032: 3b7c000bffe6  move.w #$b, -$1a(a5)
        move.w #$b, -$1a(a5)
L060_00000038:
; H060+$00000038: 3b7c000dffe8  move.w #$d, -$18(a5)
        move.w #$d, -$18(a5)
L060_0000003E:
; H060+$0000003E: 3b7c0002ffea  move.w #$2, -$16(a5)
        move.w #$2, -$16(a5)
L060_00000044:
; H060+$00000044: 3b7c0009ffec  move.w #$9, -$14(a5)
        move.w #$9, -$14(a5)
L060_0000004A:
; H060+$0000004A: 3b7c000effee  move.w #$e, -$12(a5)
        move.w #$e, -$12(a5)
L060_00000050:
; H060+$00000050: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L060_00000054:
; H060+$00000054: 3b7c000ffff2  move.w #$f, -$e(a5)
        move.w #$f, -$e(a5)
L060_0000005A:
; H060+$0000005A: 3b7c0004fff4  move.w #$4, -$c(a5)
        move.w #$4, -$c(a5)
L060_00000060:
; H060+$00000060: 3b7c000bfff6  move.w #$b, -$a(a5)
        move.w #$b, -$a(a5)
L060_00000066:
; H060+$00000066: 3b7c000dfff8  move.w #$d, -$8(a5)
        move.w #$d, -$8(a5)
L060_0000006C:
; H060+$0000006C: 3b7c0002fffa  move.w #$2, -$6(a5)
        move.w #$2, -$6(a5)
L060_00000072:
; H060+$00000072: 3b7c0009fffc  move.w #$9, -$4(a5)
        move.w #$9, -$4(a5)
L060_00000078:
; H060+$00000078: 3b7c000efffe  move.w #$e, -$2(a5)
        move.w #$e, -$2(a5)
L060_0000007E:
; H060+$0000007E: 7400  moveq #$0, d2
        moveq #0, d2
L060_00000080:
; H060+$00000080: 143900002486  move.b $2486.l, d2
        move.b (H005+$2486).l, d2
L060_00000086:
; H060+$00000086: 0c420009  cmpi.w #$9, d2
        cmpi.w #$9, d2
L060_0000008A:
; H060+$0000008A: 66000008  bne.w $94
        bne.w H060+$94
L060_0000008E:
; H060+$0000008E: 4239000024e1  clr.b $24e1.l
        clr.b (H005+$24E1).l
; STATO: H005+$24D0 = richiesta di uscita dal ciclo scenario
L060_00000094:
; H060+$00000094: 4a39000024d0  tst.b $24d0.l
        tst.b (H005+$24D0).l
L060_0000009A:
; H060+$0000009A: 67000006  beq.w $a2
        beq.w H060+$A2
L060_0000009E:
; H060+$0000009E: 600000e0  bra.w $180
        bra.w H060+$180
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L060_000000A2:
; H060+$000000A2: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L060_000000A8:
; H060+$000000A8: 4a6b01cc  tst.w $1cc(a3)
        tst.w $1cc(a3)
L060_000000AC:
; H060+$000000AC: 670000bc  beq.w $16a
        beq.w H060+$16A
; STATO: H005+$281C = inizio del blocco coordinate/vista
L060_000000B0:
; H060+$000000B0: 47f90000281c  lea.l $281c.l, a3
        lea.l (H005+$281C).l, a3
L060_000000B6:
; H060+$000000B6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L060_000000B8:
; H060+$000000B8: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L060_000000BA:
; H060+$000000BA: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
; -> H011+$04E2 (sub_H011_000004E2)
L060_000000BE:
; H060+$000000BE: 4eb9000004e2  jsr $4e2.l
        jsr (H011+$4E2).l
L060_000000C4:
; H060+$000000C4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L060_000000C6:
; H060+$000000C6: 17400006  move.b d0, $6(a3)
        move.b d0, $6(a3)
L060_000000CA:
; H060+$000000CA: 7400  moveq #$0, d2
        moveq #0, d2
L060_000000CC:
; H060+$000000CC: 142b0006  move.b $6(a3), d2
        move.b $6(a3), d2
L060_000000D0:
; H060+$000000D0: 0c42007f  cmpi.w #$7f, d2
        cmpi.w #$7f, d2
L060_000000D4:
; H060+$000000D4: 63000020  bls.w $f6
        bls.w H060+$F6
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L060_000000D8:
; H060+$000000D8: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L060_000000DE:
; H060+$000000DE: 342a01fc  move.w $1fc(a2), d2
        move.w $1fc(a2), d2
L060_000000E2:
; H060+$000000E2: e342  asl.w #$1, d2
        asl.w #$1, d2
L060_000000E4:
; H060+$000000E4: 45edffe0  lea.l -$20(a5), a2
        lea.l -$20(a5), a2
L060_000000E8:
; H060+$000000E8: 38322000  move.w (a2, d2.w), d4
        move.w (a2, d2.w), d4
L060_000000EC:
; H060+$000000EC: 13c400002829  move.b d4, $2829.l
        move.b d4, (H005+$2829).l
L060_000000F2:
; H060+$000000F2: 6000001c  bra.w $110
        bra.w H060+$110
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L060_000000F6:
; H060+$000000F6: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L060_000000FC:
; H060+$000000FC: 342a01fa  move.w $1fa(a2), d2
        move.w $1fa(a2), d2
L060_00000100:
; H060+$00000100: e342  asl.w #$1, d2
        asl.w #$1, d2
L060_00000102:
; H060+$00000102: 45edffe0  lea.l -$20(a5), a2
        lea.l -$20(a5), a2
L060_00000106:
; H060+$00000106: 38322000  move.w (a2, d2.w), d4
        move.w (a2, d2.w), d4
L060_0000010A:
; H060+$0000010A: 13c400002829  move.b d4, $2829.l
        move.b d4, (H005+$2829).l
L060_00000110:
; H060+$00000110: 13fc000800002826  move.b #$8, $2826.l
        move.b #$8, (H005+$2826).l
L060_00000118:
; H060+$00000118: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L060_0000011A:
; H060+$0000011A: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L060_0000011E:
; H060+$0000011E: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L060_00000122:
; H060+$00000122: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L060_00000128:
; H060+$00000128: 342a01f6  move.w $1f6(a2), d2
        move.w $1f6(a2), d2
L060_0000012C:
; H060+$0000012C: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L060_0000012E:
; H060+$0000012E: 4227  clr.b -(a7)
        clr.b -(a7)
L060_00000130:
; H060+$00000130: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H056+$0886 (sub_H056_00000886)
L060_00000132:
; H060+$00000132: 4eb900000886  jsr $886.l
        jsr (H056+$886).l
L060_00000138:
; H060+$00000138: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L060_0000013A:
; H060+$0000013A: 247900003e04  movea.l $3e04.l, a2
        movea.l (H005+$3E04).l, a2
L060_00000140:
; H060+$00000140: 4a6a01f6  tst.w $1f6(a2)
        tst.w $1f6(a2)
L060_00000144:
; H060+$00000144: 67000008  beq.w $14e
        beq.w H060+$14E
L060_00000148:
; H060+$00000148: 423900002825  clr.b $2825.l
        clr.b (H005+$2825).l
L060_0000014E:
; H060+$0000014E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L060_00000150:
; H060+$00000150: 3f13  move.w (a3), -(a7)
        move.w (a3), -(a7)
L060_00000152:
; H060+$00000152: 3f2b0002  move.w $2(a3), -(a7)
        move.w $2(a3), -(a7)
L060_00000156:
; H060+$00000156: 7400  moveq #$0, d2
        moveq #0, d2
L060_00000158:
; H060+$00000158: 142b0004  move.b $4(a3), d2
        move.b $4(a3), d2
L060_0000015C:
; H060+$0000015C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$0B78 (sub_H011_00000B78)
L060_0000015E:
; H060+$0000015E: 4eb900000b78  jsr $b78.l
        jsr (H011+$B78).l
L060_00000164:
; H060+$00000164: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L060_00000166:
; H060+$00000166: 60000012  bra.w $17a
        bra.w H060+$17A
L060_0000016A:
; H060+$0000016A: 4a39000024e1  tst.b $24e1.l
        tst.b (H005+$24E1).l
L060_00000170:
; H060+$00000170: 67000008  beq.w $17a
        beq.w H060+$17A
; -> H042+$10DC (sub_H042_000010DC)
L060_00000174:
; H060+$00000174: 4eb9000010dc  jsr $10dc.l
        jsr (H042+$10DC).l
L060_0000017A:
; H060+$0000017A: 4239000024e1  clr.b $24e1.l
        clr.b (H005+$24E1).l
L060_00000180:
; H060+$00000180: 4e5d  unlk a5
        unlk a5
L060_00000182:
; H060+$00000182: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L060_00000184:
; H060+$00000184: 4e75  rts 
        rts 
L060_00000186:
; H060+$00000186: 4e5d  unlk a5
        unlk a5
L060_00000188:
; H060+$00000188: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L060_0000018A:
; H060+$0000018A: 4e75  rts 
        rts 
; End H060: $18C bytes
