; ============================================================================
; GUIDA DEL MODULO H054
; Calcolo dello spazio raster per riga.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Calcolo dello spazio raster per riga: converte larghezza e profondita' in byte per riga.
; --------------------------------------------------------------------------
; H054: 52 original bytes; all offsets are section-relative.
        section H054,code
H054:
; Preserved bytes H054+$00000000..$00000004; code/data not fully classified.
        dc.l H054+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H054_0030 [parziale]
; Scopo: Trampolino verso H054+$0030; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H054+$0030.
; Chiamanti diretti: H000+$00BA
; --------------------------------------------------------------------------
L054_00000004:
; H054+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L054_00000008:
; H054+$00000008: 60000026  bra.w $30
        bra.w H054+$30
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H054_0028 [parziale]
; Scopo: Trampolino verso H054+$0028; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H054+$0028.
; Chiamanti diretti: H040+$0380, H087+$017E
; --------------------------------------------------------------------------
L054_0000000C:
; H054+$0000000C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L054_00000010:
; H054+$00000010: 342d0008  move.w $8(a5), d2
        move.w $8(a5), d2
L054_00000014:
; H054+$00000014: 0642000f  addi.w #$f, d2
        addi.w #$f, d2
L054_00000018:
; H054+$00000018: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L054_0000001E:
; H054+$0000001E: e84a  lsr.w #$4, d2
        lsr.w #$4, d2
L054_00000020:
; H054+$00000020: e342  asl.w #$1, d2
        asl.w #$1, d2
L054_00000022:
; H054+$00000022: 3002  move.w d2, d0
        move.w d2, d0
L054_00000024:
; H054+$00000024: 60000002  bra.w $28
        bra.w H054+$28
L054_00000028:
; H054+$00000028: 4e5d  unlk a5
        unlk a5
L054_0000002A:
; H054+$0000002A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L054_0000002C:
; H054+$0000002C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L054_0000002E:
; H054+$0000002E: 4ed0  jmp (a0)
        jmp (a0)
L054_00000030:
; H054+$00000030: 4e5d  unlk a5
        unlk a5
L054_00000032:
; H054+$00000032: 4e75  rts 
        rts 
; End H054: $34 bytes
