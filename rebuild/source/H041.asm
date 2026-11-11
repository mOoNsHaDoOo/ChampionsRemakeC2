; ============================================================================
; GUIDA DEL MODULO H041
; Memoria per le immagini: blocco preceduto dalla dimensione di allocazione.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Memoria per immagini: il blocco e' preceduto dalla dimensione di allocazione, usata per liberarlo correttamente.
; --------------------------------------------------------------------------
; H041: 240 original bytes; all offsets are section-relative.
        section H041,code
H041:
; Preserved bytes H041+$00000000..$00000004; code/data not fully classified.
        dc.l H041+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H041_00EC [parziale]
; Scopo: Trampolino verso H041+$00EC; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H041+$00EC.
; Chiamanti diretti: H000+$00E4
; --------------------------------------------------------------------------
L041_00000004:
; H041+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L041_00000008:
; H041+$00000008: 600000e2  bra.w $ec
        bra.w H041+$EC
; --------------------------------------------------------------------------
; ROUTINE: sub_H041_0000000C [parziale]
; Scopo: Routine del modulo memoria per le immagini: blocco preceduto dalla dimensione di allocazione; richiama H003+$0068.
;   - Richiama H003+$0068.
; Chiamanti diretti: H041+$0058
; --------------------------------------------------------------------------
L041_0000000C:
; H041+$0000000C: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L041_00000010:
; H041+$00000010: 58ad000c  addq.l #$4, $c(a5)
        addq.l #$4, $c(a5)
L041_00000014:
; H041+$00000014: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L041_00000018:
; H041+$00000018: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L041_0000001C:
; H041+$0000001C: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L041_00000022:
; H041+$00000022: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L041_00000026:
; H041+$00000026: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L041_0000002A:
; H041+$0000002A: 6700000e  beq.w $3a
        beq.w H041+$3A
L041_0000002E:
; H041+$0000002E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L041_00000032:
; H041+$00000032: 26ad000c  move.l $c(a5), (a3)
        move.l $c(a5), (a3)
L041_00000036:
; H041+$00000036: 58adfffc  addq.l #$4, -$4(a5)
        addq.l #$4, -$4(a5)
L041_0000003A:
; H041+$0000003A: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L041_0000003E:
; H041+$0000003E: 60000002  bra.w $42
        bra.w H041+$42
L041_00000042:
; H041+$00000042: 4e5d  unlk a5
        unlk a5
L041_00000044:
; H041+$00000044: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L041_00000046:
; H041+$00000046: 508f  addq.l #$8, a7
        addq.l #$8, a7
L041_00000048:
; H041+$00000048: 4ed0  jmp (a0)
        jmp (a0)
L041_0000004A:
; H041+$0000004A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L041_0000004E:
; H041+$0000004E: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L041_00000052:
; H041+$00000052: 2f3c00010003  move.l #$10003, -(a7)
        move.l #$10003, -(a7)
L041_00000058:
; H041+$00000058: 61b2  bsr.b $c
        bsr.b H041+$C
L041_0000005A:
; H041+$0000005A: 60000002  bra.w $5e
        bra.w H041+$5E
L041_0000005E:
; H041+$0000005E: 4e5d  unlk a5
        unlk a5
L041_00000060:
; H041+$00000060: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L041_00000062:
; H041+$00000062: 588f  addq.l #$4, a7
        addq.l #$4, a7
L041_00000064:
; H041+$00000064: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H041+$00000066..$000000BE; code/data not fully classified.
        dc.w $4E55,$0000,$2F2D,$0008,$2F3C,$0000,$0003,$6196
        dc.w $6000,$0002,$4E5D,$205F,$588F,$4ED0,$4E55,$0000
        dc.w $2F2D,$0008,$2F3C,$0001,$0001,$6100,$FF7A,$6000
        dc.w $0002,$4E5D,$205F,$588F,$4ED0,$4E55,$0000,$2F2D
        dc.w $0008,$2F3C,$0000,$0001,$6100,$FF5C,$6000,$0002
        dc.w $4E5D,$205F,$588F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H041_000000BE [parziale]
; Scopo: Routine del modulo memoria per le immagini: blocco preceduto dalla dimensione di allocazione; richiama H003+$00F6.
;   - Richiama H003+$00F6.
; Chiamanti diretti: H028+$0D96, H028+$0DBA
; --------------------------------------------------------------------------
L041_000000BE:
; H041+$000000BE: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L041_000000C2:
; H041+$000000C2: 4aad0008  tst.l $8(a5)
        tst.l $8(a5)
L041_000000C6:
; H041+$000000C6: 6700001c  beq.w $e4
        beq.w H041+$E4
L041_000000CA:
; H041+$000000CA: 242d0008  move.l $8(a5), d2
        move.l $8(a5), d2
L041_000000CE:
; H041+$000000CE: 5982  subq.l #$4, d2
        subq.l #$4, d2
L041_000000D0:
; H041+$000000D0: 2b42fffc  move.l d2, -$4(a5)
        move.l d2, -$4(a5)
L041_000000D4:
; H041+$000000D4: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L041_000000D8:
; H041+$000000D8: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L041_000000DC:
; H041+$000000DC: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L041_000000DE:
; H041+$000000DE: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L041_000000E4:
; H041+$000000E4: 4e5d  unlk a5
        unlk a5
L041_000000E6:
; H041+$000000E6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L041_000000E8:
; H041+$000000E8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L041_000000EA:
; H041+$000000EA: 4ed0  jmp (a0)
        jmp (a0)
L041_000000EC:
; H041+$000000EC: 4e5d  unlk a5
        unlk a5
L041_000000EE:
; H041+$000000EE: 4e75  rts 
        rts 
; End H041: $F0 bytes
