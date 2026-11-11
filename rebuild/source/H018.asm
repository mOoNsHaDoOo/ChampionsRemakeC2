; ============================================================================
; GUIDA DEL MODULO H018
; Adattatori Exec per apertura/chiusura librerie.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; H018: 192 original bytes; all offsets are section-relative.
        section H018,code
H018:
; Preserved bytes H018+$00000000..$00000004; code/data not fully classified.
        dc.l H018+$00000000
; --------------------------------------------------------------------------
; ROUTINE: sub_H018_00000004 [parziale]
; Scopo: Routine del modulo adattatori Exec per apertura/chiusura librerie; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$002A
; --------------------------------------------------------------------------
L018_00000004:
; H018+$00000004: 4e75  rts 
        rts 
; Preserved bytes H018+$00000006..$00000018; code/data not fully classified.
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FE74
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CloseLibrary [parziale]
; Scopo: Adattatore a exec.library/CloseLibrary; incapsula la chiamata alla libreria.
;   - Chiama exec.library/CloseLibrary (LVO -414).
; Chiamanti diretti: H029+$1482, H029+$14E0
; --------------------------------------------------------------------------
L018_00000018:
; H018+$00000018: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L018_0000001C:
; H018+$0000001C: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L018_00000020:
; H018+$00000020: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L018_00000024:
; H018+$00000024: 588f  addq.l #$4, a7
        addq.l #$4, a7
L018_00000026:
; H018+$00000026: 4eeefe62  jmp -$19e(a6) ; exec.library/CloseLibrary
        jmp LVO_exec_CloseLibrary(a6)
; Preserved bytes H018+$0000002A..$0000006A; code/data not fully classified.
        dc.w $206F,$000C,$226F,$0008,$246F,$0004,$2C78,$0004
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FFA6,$206F,$0014
        dc.w $226F,$0010,$246F,$000C,$202F,$0008,$222F,$0004
        dc.w $2C78,$0004,$2F57,$0014,$4FEF,$0014,$4EEE,$FFAC
; --------------------------------------------------------------------------
; ROUTINE: wrapper_OpenLibrary [parziale]
; Scopo: Adattatore a exec.library/OpenLibrary; incapsula la chiamata alla libreria.
;   - Chiama exec.library/OpenLibrary (LVO -552).
; Chiamanti diretti: H029+$1450, H029+$1464
; --------------------------------------------------------------------------
L018_0000006A:
; H018+$0000006A: 226f0008  movea.l $8(a7), a1
        movea.l $8(a7), a1
L018_0000006E:
; H018+$0000006E: 202f0004  move.l $4(a7), d0
        move.l $4(a7), d0
L018_00000072:
; H018+$00000072: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L018_00000076:
; H018+$00000076: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L018_0000007A:
; H018+$0000007A: 508f  addq.l #$8, a7
        addq.l #$8, a7
L018_0000007C:
; H018+$0000007C: 4eeefdd8  jmp -$228(a6) ; exec.library/OpenLibrary
        jmp LVO_exec_OpenLibrary(a6)
; Preserved bytes H018+$00000080..$000000C0; code/data not fully classified.
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FE6E,$226F,$000A,$306F,$0008,$202F,$0004,$2C78
        dc.w $0004,$2F57,$000A,$4FEF,$000A,$4EEE,$FE5C,$226F
        dc.w $0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE,$FE56
; End H018: $C0 bytes
