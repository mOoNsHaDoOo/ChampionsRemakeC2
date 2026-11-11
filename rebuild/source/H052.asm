; ============================================================================
; GUIDA DEL MODULO H052
; inizializzazione di uno slot di stato.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Inizializzazione di uno slot di stato: prepara una struttura globale usata dai moduli successivi.
; --------------------------------------------------------------------------
; H052: 316 original bytes; all offsets are section-relative.
        section H052,code
H052:
; Preserved bytes H052+$00000000..$00000024; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.l H052+$00000020
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H052_0114 [parziale]
; Scopo: Trampolino verso H052+$0114; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H052+$0114.
; Chiamanti diretti: H000+$00FC
; --------------------------------------------------------------------------
L052_00000024:
; H052+$00000024: 4e550000  link.w a5, #$0
        link.w a5, #$0
L052_00000028:
; H052+$00000028: 600000ea  bra.w $114
        bra.w H052+$114
; Preserved bytes H052+$0000002C..$00000114; code/data not fully classified.
        dc.w $4E55,$FFD8,$242D,$0008,$5682,$0282,$FFFF,$FFFC
        dc.w $2B42,$0008,$47F9
        dc.l H052+$00000000
        dc.w $45ED,$FFE0,$7407,$24DB,$51CA,$FFFC,$2B6D,$0008
        dc.w $FFFC,$47ED,$FFE0,$2F0B,$4EB9
        dc.l H003+$00000056
        dc.w $2B40,$FFD8,$242D,$FFD8,$0802,$001F,$6700,$0008
        dc.w $7000,$6000,$007C,$266D,$FFD8,$2B6B,$0010,$FFDC
        dc.w $266D,$FFDC,$246D,$FFD8,$276A,$0018,$003A,$242B
        dc.w $003A,$D4AD,$0008,$2742,$003E,$276B,$003E,$0036
        dc.w $177C,$0001,$0008,$342D,$0010,$1742,$0009,$276D
        dc.w $0012,$000A,$2F0B,$486B,$004A,$4EB9
        dc.l H092+$0000007A
        dc.w $265F,$2F0B,$486B,$004A,$2F2D,$FFD8,$4EB9
        dc.l H092+$00000006
        dc.w $265F,$2F0B,$2F2D,$FFDC,$2F2D,$000C,$42A7,$4EB9
        dc.l H051+$00000006
        dc.w $265F,$202D,$FFDC,$6000,$0002,$4E5D,$205F,$4FEF
        dc.w $000E,$4ED0,$4E55,$0000,$2F2D,$0008,$4EB9
        dc.l H051+$00000084
        dc.w $4E5D,$205F,$588F,$4ED0
L052_00000114:
; H052+$00000114: 47f900000000  lea.l $0.l, a3
        lea.l (H052+$0).l, a3
L052_0000011A:
; H052+$0000011A: 377c0002000e  move.w #$2, $e(a3)
        move.w #$2, $e(a3)
L052_00000120:
; H052+$00000120: 277c000100010010  move.l #$10001, $10(a3)
        move.l #$10001, $10(a3)
L052_00000128:
; H052+$00000128: 745c  moveq #$5c, d2
        moveq #92, d2
L052_0000012A:
; H052+$0000012A: 27420014  move.l d2, $14(a3)
        move.l d2, $14(a3)
L052_0000012E:
; H052+$0000012E: 277c000100000018  move.l #$10000, $18(a3)
        move.l #$10000, $18(a3)
L052_00000136:
; H052+$00000136: 4e5d  unlk a5
        unlk a5
L052_00000138:
; H052+$00000138: 4e75  rts 
        rts 
; Preserved bytes H052+$0000013A..$0000013C; code/data not fully classified.
        dc.w $0000
; End H052: $13C bytes
