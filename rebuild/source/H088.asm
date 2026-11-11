; ============================================================================
; GUIDA DEL MODULO H088
; UnPackRow ByteRun1 con aggiornamento dei puntatori.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; UnPackRow ByteRun1: decompressione RLE delle righe ILBM con aggiornamento dei puntatori.
; --------------------------------------------------------------------------
; H088: 328 original bytes; all offsets are section-relative.
        section H088,code
H088:
; Preserved bytes H088+$00000000..$00000004; code/data not fully classified.
        dc.l H088+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H088_0142 [parziale]
; Scopo: Trampolino verso H088+$0142; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H088+$0142.
; Chiamanti diretti: H000+$00D2
; --------------------------------------------------------------------------
L088_00000004:
; H088+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L088_00000008:
; H088+$00000008: 60000138  bra.w $142
        bra.w H088+$142
;
; --------------------------------------------------------------------------
; ROUTINE: UnPackRow_ByteRun1 [verificato]
; Scopo: Decomprimi una riga con ByteRun1/PackBits, aggiornando i due puntatori.
;   - Controllo con segno non negativo: copia controllo+1 byte.
;   - Controllo negativo diverso da -128: ripete il byte successivo 1-controllo volte.
;   - -128 è un comando senza output.
;   - Aggiorna sorgente e destinazione attraverso parametri puntatore-a-puntatore.
;   - È distinto dal RLE DAX: i due formati hanno conteggi delle ripetizioni diversi.
; Chiamanti diretti: H042+$0728, H042+$0846, H042+$09A4, H042+$0C8A, H087+$0434
; --------------------------------------------------------------------------
L088_0000000C:
; H088+$0000000C: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L088_00000010:
; H088+$00000010: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L088_00000014:
; H088+$00000014: 2b53fffc  move.l (a3), -$4(a5)
        move.l (a3), -$4(a5)
L088_00000018:
; H088+$00000018: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L088_0000001C:
; H088+$0000001C: 2b53fff8  move.l (a3), -$8(a5)
        move.l (a3), -$8(a5)
L088_00000020:
; H088+$00000020: 1b7c0001fff4  move.b #$1, -$c(a5)
        move.b #$1, -$c(a5)
L088_00000026:
; H088+$00000026: 4a6d0008  tst.w $8(a5)
        tst.w $8(a5)
L088_0000002A:
; H088+$0000002A: 6e00000a  bgt.w $36
        bgt.w H088+$36
L088_0000002E:
; H088+$0000002E: 422dfff4  clr.b -$c(a5)
        clr.b -$c(a5)
L088_00000032:
; H088+$00000032: 600000ec  bra.w $120
        bra.w H088+$120
L088_00000036:
; H088+$00000036: 536d000a  subq.w #$1, $a(a5)
        subq.w #$1, $a(a5)
L088_0000003A:
; H088+$0000003A: 4a6d000a  tst.w $a(a5)
        tst.w $a(a5)
L088_0000003E:
; H088+$0000003E: 6c000006  bge.w $46
        bge.w H088+$46
L088_00000042:
; H088+$00000042: 600000dc  bra.w $120
        bra.w H088+$120
L088_00000046:
; H088+$00000046: 7400  moveq #$0, d2
        moveq #0, d2
L088_00000048:
; H088+$00000048: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L088_0000004C:
; H088+$0000004C: 1413  move.b (a3), d2
        move.b (a3), d2
L088_0000004E:
; H088+$0000004E: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L088_00000052:
; H088+$00000052: 52adfffc  addq.l #$1, -$4(a5)
        addq.l #$1, -$4(a5)
L088_00000056:
; H088+$00000056: 0c6d007ffff6  cmpi.w #$7f, -$a(a5)
        cmpi.w #$7f, -$a(a5)
L088_0000005C:
; H088+$0000005C: 6f00000e  ble.w $6c
        ble.w H088+$6C
L088_00000060:
; H088+$00000060: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L088_00000064:
; H088+$00000064: 04420100  subi.w #$100, d2
        subi.w #$100, d2
L088_00000068:
; H088+$00000068: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L088_0000006C:
; H088+$0000006C: 4a6dfff6  tst.w -$a(a5)
        tst.w -$a(a5)
L088_00000070:
; H088+$00000070: 6d00004e  blt.w $c0
        blt.w H088+$C0
L088_00000074:
; H088+$00000074: 526dfff6  addq.w #$1, -$a(a5)
        addq.w #$1, -$a(a5)
L088_00000078:
; H088+$00000078: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L088_0000007C:
; H088+$0000007C: 956d000a  sub.w d2, $a(a5)
        sub.w d2, $a(a5)
L088_00000080:
; H088+$00000080: 4a6d000a  tst.w $a(a5)
        tst.w $a(a5)
L088_00000084:
; H088+$00000084: 6c000006  bge.w $8c
        bge.w H088+$8C
L088_00000088:
; H088+$00000088: 60000096  bra.w $120
        bra.w H088+$120
L088_0000008C:
; H088+$0000008C: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L088_00000090:
; H088+$00000090: 956d0008  sub.w d2, $8(a5)
        sub.w d2, $8(a5)
L088_00000094:
; H088+$00000094: 4a6d0008  tst.w $8(a5)
        tst.w $8(a5)
L088_00000098:
; H088+$00000098: 6c000006  bge.w $a0
        bge.w H088+$A0
L088_0000009C:
; H088+$0000009C: 60000082  bra.w $120
        bra.w H088+$120
L088_000000A0:
; H088+$000000A0: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L088_000000A4:
; H088+$000000A4: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L088_000000A8:
; H088+$000000A8: 1493  move.b (a3), (a2)
        move.b (a3), (a2)
L088_000000AA:
; H088+$000000AA: 52adfff8  addq.l #$1, -$8(a5)
        addq.l #$1, -$8(a5)
L088_000000AE:
; H088+$000000AE: 52adfffc  addq.l #$1, -$4(a5)
        addq.l #$1, -$4(a5)
L088_000000B2:
; H088+$000000B2: 536dfff6  subq.w #$1, -$a(a5)
        subq.w #$1, -$a(a5)
L088_000000B6:
; H088+$000000B6: 4a6dfff6  tst.w -$a(a5)
        tst.w -$a(a5)
L088_000000BA:
; H088+$000000BA: 6ee4  bgt.b $a0
        bgt.b H088+$A0
L088_000000BC:
; H088+$000000BC: 6000005e  bra.w $11c
        bra.w H088+$11C
; PASSO: Valore -128: nessun output; gli altri controlli negativi generano una ripetizione.
L088_000000C0:
; H088+$000000C0: 0c6dff80fff6  cmpi.w #$ff80, -$a(a5)
        cmpi.w #$ff80, -$a(a5)
L088_000000C6:
; H088+$000000C6: 67000054  beq.w $11c
        beq.w H088+$11C
L088_000000CA:
; H088+$000000CA: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L088_000000CE:
; H088+$000000CE: 4442  neg.w d2
        neg.w d2
L088_000000D0:
; H088+$000000D0: 5242  addq.w #$1, d2
        addq.w #$1, d2
L088_000000D2:
; H088+$000000D2: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L088_000000D6:
; H088+$000000D6: 536d000a  subq.w #$1, $a(a5)
        subq.w #$1, $a(a5)
L088_000000DA:
; H088+$000000DA: 4a6d000a  tst.w $a(a5)
        tst.w $a(a5)
L088_000000DE:
; H088+$000000DE: 6c000006  bge.w $e6
        bge.w H088+$E6
L088_000000E2:
; H088+$000000E2: 6000003c  bra.w $120
        bra.w H088+$120
L088_000000E6:
; H088+$000000E6: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L088_000000EA:
; H088+$000000EA: 956d0008  sub.w d2, $8(a5)
        sub.w d2, $8(a5)
L088_000000EE:
; H088+$000000EE: 4a6d0008  tst.w $8(a5)
        tst.w $8(a5)
L088_000000F2:
; H088+$000000F2: 6c000006  bge.w $fa
        bge.w H088+$FA
L088_000000F6:
; H088+$000000F6: 60000028  bra.w $120
        bra.w H088+$120
L088_000000FA:
; H088+$000000FA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L088_000000FE:
; H088+$000000FE: 1b53fff5  move.b (a3), -$b(a5)
        move.b (a3), -$b(a5)
L088_00000102:
; H088+$00000102: 52adfffc  addq.l #$1, -$4(a5)
        addq.l #$1, -$4(a5)
L088_00000106:
; H088+$00000106: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L088_0000010A:
; H088+$0000010A: 16adfff5  move.b -$b(a5), (a3)
        move.b -$b(a5), (a3)
L088_0000010E:
; H088+$0000010E: 52adfff8  addq.l #$1, -$8(a5)
        addq.l #$1, -$8(a5)
L088_00000112:
; H088+$00000112: 536dfff6  subq.w #$1, -$a(a5)
        subq.w #$1, -$a(a5)
L088_00000116:
; H088+$00000116: 4a6dfff6  tst.w -$a(a5)
        tst.w -$a(a5)
L088_0000011A:
; H088+$0000011A: 6eea  bgt.b $106
        bgt.b H088+$106
L088_0000011C:
; H088+$0000011C: 6000ff08  bra.w $26
        bra.w H088+$26
L088_00000120:
; H088+$00000120: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L088_00000124:
; H088+$00000124: 26adfffc  move.l -$4(a5), (a3)
        move.l -$4(a5), (a3)
L088_00000128:
; H088+$00000128: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L088_0000012C:
; H088+$0000012C: 26adfff8  move.l -$8(a5), (a3)
        move.l -$8(a5), (a3)
L088_00000130:
; H088+$00000130: 102dfff4  move.b -$c(a5), d0
        move.b -$c(a5), d0
L088_00000134:
; H088+$00000134: 60000002  bra.w $138
        bra.w H088+$138
L088_00000138:
; H088+$00000138: 4e5d  unlk a5
        unlk a5
L088_0000013A:
; H088+$0000013A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L088_0000013C:
; H088+$0000013C: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L088_00000140:
; H088+$00000140: 4ed0  jmp (a0)
        jmp (a0)
L088_00000142:
; H088+$00000142: 4e5d  unlk a5
        unlk a5
L088_00000144:
; H088+$00000144: 4e75  rts 
        rts 
; Preserved bytes H088+$00000146..$00000148; code/data not fully classified.
        dc.w $0000
; End H088: $148 bytes
