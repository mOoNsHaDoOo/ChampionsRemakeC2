; ============================================================================
; GUIDA DEL MODULO H053
; caricamento e gestione di sequenze/sprite per l'interfaccia.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Caricamento e gestione di sequenze/sprite per l'interfaccia. Usa i loader H035 e i servizi di memoria H003.
; --------------------------------------------------------------------------
; H053: 504 original bytes; all offsets are section-relative.
        section H053,code
H053:
; Preserved bytes H053+$00000000..$00000004; code/data not fully classified.
        dc.l H053+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H053 [parziale]
; Scopo: Ingresso del modulo caricamento e gestione di sequenze/sprite per l'interfaccia; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H053+$01F2.
; Chiamanti diretti: H000+$0162
; --------------------------------------------------------------------------
L053_00000004:
; H053+$00000004: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L053_00000006:
; H053+$00000006: 287afff8  movea.l $0(pc), a4
        movea.l H053+$0(pc), a4
L053_0000000A:
; H053+$0000000A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L053_0000000E:
; H053+$0000000E: 600001e2  bra.w $1f2
        bra.w H053+$1F2
; --------------------------------------------------------------------------
; ROUTINE: sub_H053_00000012 [parziale]
; Scopo: Routine del modulo caricamento e gestione di sequenze/sprite per l'interfaccia; richiama H003+$00F6.
;   - Richiama H003+$00F6.
; Chiamanti diretti: H010+$0276, H053+$01B6, H053+$015C, H013+$0BE0, H013+$0E14, H013+$0F78 e altri 4
; --------------------------------------------------------------------------
L053_00000012:
; H053+$00000012: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L053_00000014:
; H053+$00000014: 287affea  movea.l $0(pc), a4
        movea.l H053+$0(pc), a4
L053_00000018:
; H053+$00000018: 4e55fff0  link.w a5, #$fff0
        link.w a5, #$fff0
L053_0000001C:
; H053+$0000001C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L053_00000020:
; H053+$00000020: 2652  movea.l (a2), a3
        movea.l (a2), a3
L053_00000022:
; H053+$00000022: 4aab0192  tst.l $192(a3)
        tst.l $192(a3)
L053_00000026:
; H053+$00000026: 67000014  beq.w $3c
        beq.w H053+$3C
L053_0000002A:
; H053+$0000002A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L053_0000002C:
; H053+$0000002C: 2f2b0192  move.l $192(a3), -(a7)
        move.l $192(a3), -(a7)
L053_00000030:
; H053+$00000030: 7418  moveq #$18, d2
        moveq #24, d2
L053_00000032:
; H053+$00000032: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L053_00000034:
; H053+$00000034: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L053_0000003A:
; H053+$0000003A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L053_0000003C:
; H053+$0000003C: 2b6b0150fff8  move.l $150(a3), -$8(a5)
        move.l $150(a3), -$8(a5)
L053_00000042:
; H053+$00000042: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L053_00000046:
; H053+$00000046: 67000026  beq.w $6e
        beq.w H053+$6E
L053_0000004A:
; H053+$0000004A: 2b6dfff8fffc  move.l -$8(a5), -$4(a5)
        move.l -$8(a5), -$4(a5)
L053_00000050:
; H053+$00000050: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L053_00000054:
; H053+$00000054: 2b6a002cfff8  move.l $2c(a2), -$8(a5)
        move.l $2c(a2), -$8(a5)
L053_0000005A:
; H053+$0000005A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L053_0000005C:
; H053+$0000005C: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L053_00000060:
; H053+$00000060: 7448  moveq #$48, d2
        moveq #72, d2
L053_00000062:
; H053+$00000062: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L053_00000064:
; H053+$00000064: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L053_0000006A:
; H053+$0000006A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L053_0000006C:
; H053+$0000006C: 60d4  bra.b $42
        bra.b H053+$42
L053_0000006E:
; H053+$0000006E: 2b6b00e8fff0  move.l $e8(a3), -$10(a5)
        move.l $e8(a3), -$10(a5)
L053_00000074:
; H053+$00000074: 4aadfff0  tst.l -$10(a5)
        tst.l -$10(a5)
L053_00000078:
; H053+$00000078: 67000026  beq.w $a0
        beq.w H053+$A0
L053_0000007C:
; H053+$0000007C: 2b6dfff0fff4  move.l -$10(a5), -$c(a5)
        move.l -$10(a5), -$c(a5)
L053_00000082:
; H053+$00000082: 246dfff0  movea.l -$10(a5), a2
        movea.l -$10(a5), a2
L053_00000086:
; H053+$00000086: 2b6a0006fff0  move.l $6(a2), -$10(a5)
        move.l $6(a2), -$10(a5)
L053_0000008C:
; H053+$0000008C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L053_0000008E:
; H053+$0000008E: 2f2dfff4  move.l -$c(a5), -(a7)
        move.l -$c(a5), -(a7)
L053_00000092:
; H053+$00000092: 740a  moveq #$a, d2
        moveq #10, d2
L053_00000094:
; H053+$00000094: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L053_00000096:
; H053+$00000096: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L053_0000009C:
; H053+$0000009C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L053_0000009E:
; H053+$0000009E: 60d4  bra.b $74
        bra.b H053+$74
L053_000000A0:
; H053+$000000A0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L053_000000A4:
; H053+$000000A4: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L053_000000A6:
; H053+$000000A6: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L053_000000AA:
; H053+$000000AA: 2652  movea.l (a2), a3
        movea.l (a2), a3
L053_000000AC:
; H053+$000000AC: 243c000001aa  move.l #$1aa, d2
        move.l #$1aa, d2
L053_000000B2:
; H053+$000000B2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L053_000000B4:
; H053+$000000B4: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L053_000000BA:
; H053+$000000BA: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L053_000000BE:
; H053+$000000BE: 4293  clr.l (a3)
        clr.l (a3)
L053_000000C0:
; H053+$000000C0: 4e5d  unlk a5
        unlk a5
L053_000000C2:
; H053+$000000C2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L053_000000C4:
; H053+$000000C4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L053_000000C6:
; H053+$000000C6: 588f  addq.l #$4, a7
        addq.l #$4, a7
L053_000000C8:
; H053+$000000C8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H053_01E8 [parziale]
; Scopo: Trampolino verso H053+$01E8; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H053+$01E8.
; Chiamanti diretti: H012+$3272, H013+$502E, H012+$34F6, H013+$2D14, H012+$2AD4, H064+$05BE e altri 6
; --------------------------------------------------------------------------
L053_000000CA:
; H053+$000000CA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L053_000000CC:
; H053+$000000CC: 287aff32  movea.l $0(pc), a4
        movea.l H053+$0(pc), a4
L053_000000D0:
; H053+$000000D0: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
; STATO: H005+$3364 = testa della lista del party
L053_000000D4:
; H053+$000000D4: 4ab900003364  tst.l $3364.l
        tst.l (H005+$3364).l
L053_000000DA:
; H053+$000000DA: 66000006  bne.w $e2
        bne.w H053+$E2
L053_000000DE:
; H053+$000000DE: 60000108  bra.w $1e8
        bra.w H053+$1E8
; STATO: H005+$3364 = testa della lista del party
L053_000000E2:
; H053+$000000E2: 2b7900003364fffc  move.l $3364.l, -$4(a5)
        move.l (H005+$3364).l, -$4(a5)
L053_000000EA:
; H053+$000000EA: 242dfffc  move.l -$4(a5), d2
        move.l -$4(a5), d2
; STATO: H005+$3368 = personaggio corrente
L053_000000EE:
; H053+$000000EE: b4b900003368  cmp.l $3368.l, d2
        cmp.l (H005+$3368).l, d2
L053_000000F4:
; H053+$000000F4: 67000088  beq.w $17e
        beq.w H053+$17E
L053_000000F8:
; H053+$000000F8: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L053_000000FC:
; H053+$000000FC: 242b018e  move.l $18e(a3), d2
        move.l $18e(a3), d2
; STATO: H005+$3368 = personaggio corrente
L053_00000100:
; H053+$00000100: b4b900003368  cmp.l $3368.l, d2
        cmp.l (H005+$3368).l, d2
L053_00000106:
; H053+$00000106: 6700001a  beq.w $122
        beq.w H053+$122
L053_0000010A:
; H053+$0000010A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L053_0000010E:
; H053+$0000010E: 4aab018e  tst.l $18e(a3)
        tst.l $18e(a3)
L053_00000112:
; H053+$00000112: 6700000e  beq.w $122
        beq.w H053+$122
L053_00000116:
; H053+$00000116: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L053_0000011A:
; H053+$0000011A: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
L053_00000120:
; H053+$00000120: 60d6  bra.b $f8
        bra.b H053+$F8
L053_00000122:
; H053+$00000122: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L053_00000126:
; H053+$00000126: 4aab018e  tst.l $18e(a3)
        tst.l $18e(a3)
L053_0000012A:
; H053+$0000012A: 6700004e  beq.w $17a
        beq.w H053+$17A
L053_0000012E:
; H053+$0000012E: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L053_00000132:
; H053+$00000132: 67000012  beq.w $146
        beq.w H053+$146
; STATO: H005+$3368 = personaggio corrente
L053_00000136:
; H053+$00000136: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L053_0000013C:
; H053+$0000013C: 1f2b0143  move.b $143(a3), -(a7)
        move.b $143(a3), -(a7)
; -> H035+$01DC (sub_H035_000001DC)
L053_00000140:
; H053+$00000140: 4eb9000001dc  jsr $1dc.l
        jsr (H035+$1DC).l
; STATO: H005+$3368 = personaggio corrente
L053_00000146:
; H053+$00000146: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L053_0000014C:
; H053+$0000014C: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L053_00000150:
; H053+$00000150: 256b018e018e  move.l $18e(a3), $18e(a2)
        move.l $18e(a3), $18e(a2)
; STATO: H005+$3368 = personaggio corrente
L053_00000156:
; H053+$00000156: 487900003368  pea.l $3368.l
        pea.l (H005+$3368).l
L053_0000015C:
; H053+$0000015C: 6100feb4  bsr.w $12
        bsr.w H053+$12
; STATO: H005+$3368 = personaggio corrente
L053_00000160:
; H053+$00000160: 23edfffc00003368  move.l -$4(a5), $3368.l
        move.l -$4(a5), (H005+$3368).l
L053_00000168:
; H053+$00000168: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L053_0000016C:
; H053+$0000016C: 6600000c  bne.w $17a
        bne.w H053+$17A
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L053_00000170:
; H053+$00000170: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L053_00000176:
; H053+$00000176: 536b067c  subq.w #$1, $67c(a3)
        subq.w #$1, $67c(a3)
L053_0000017A:
; H053+$0000017A: 60000058  bra.w $1d4
        bra.w H053+$1D4
L053_0000017E:
; H053+$0000017E: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L053_00000182:
; H053+$00000182: 67000012  beq.w $196
        beq.w H053+$196
; STATO: H005+$3368 = personaggio corrente
L053_00000186:
; H053+$00000186: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L053_0000018C:
; H053+$0000018C: 1f2b0143  move.b $143(a3), -(a7)
        move.b $143(a3), -(a7)
; -> H035+$01DC (sub_H035_000001DC)
L053_00000190:
; H053+$00000190: 4eb9000001dc  jsr $1dc.l
        jsr (H035+$1DC).l
; STATO: H005+$3368 = personaggio corrente
L053_00000196:
; H053+$00000196: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
; STATO: H005+$3364 = testa della lista del party
L053_0000019C:
; H053+$0000019C: 23eb018e00003364  move.l $18e(a3), $3364.l
        move.l $18e(a3), (H005+$3364).l
; STATO: H005+$3368 = personaggio corrente
L053_000001A4:
; H053+$000001A4: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L053_000001AA:
; H053+$000001AA: 2b6b018efffc  move.l $18e(a3), -$4(a5)
        move.l $18e(a3), -$4(a5)
; STATO: H005+$3368 = personaggio corrente
L053_000001B0:
; H053+$000001B0: 487900003368  pea.l $3368.l
        pea.l (H005+$3368).l
L053_000001B6:
; H053+$000001B6: 6100fe5a  bsr.w $12
        bsr.w H053+$12
; STATO: H005+$3368 = personaggio corrente
L053_000001BA:
; H053+$000001BA: 23edfffc00003368  move.l -$4(a5), $3368.l
        move.l -$4(a5), (H005+$3368).l
L053_000001C2:
; H053+$000001C2: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L053_000001C6:
; H053+$000001C6: 6600000c  bne.w $1d4
        bne.w H053+$1D4
; STATO: H005+$3E00 = puntatore stato persistente B, 2048 byte
L053_000001CA:
; H053+$000001CA: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L053_000001D0:
; H053+$000001D0: 536b067c  subq.w #$1, $67c(a3)
        subq.w #$1, $67c(a3)
; STATO: H005+$3368 = personaggio corrente
L053_000001D4:
; H053+$000001D4: 4ab900003368  tst.l $3368.l
        tst.l (H005+$3368).l
L053_000001DA:
; H053+$000001DA: 6600000c  bne.w $1e8
        bne.w H053+$1E8
; STATO: H005+$3364 = testa della lista del party; H005+$3368 = personaggio corrente
L053_000001DE:
; H053+$000001DE: 23f90000336400003368  move.l $3364.l, $3368.l
        move.l (H005+$3364).l, (H005+$3368).l
L053_000001E8:
; H053+$000001E8: 4e5d  unlk a5
        unlk a5
L053_000001EA:
; H053+$000001EA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L053_000001EC:
; H053+$000001EC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L053_000001EE:
; H053+$000001EE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L053_000001F0:
; H053+$000001F0: 4ed0  jmp (a0)
        jmp (a0)
L053_000001F2:
; H053+$000001F2: 4e5d  unlk a5
        unlk a5
L053_000001F4:
; H053+$000001F4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L053_000001F6:
; H053+$000001F6: 4e75  rts 
        rts 
; End H053: $1F8 bytes
