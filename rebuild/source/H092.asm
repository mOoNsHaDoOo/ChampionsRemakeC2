; ============================================================================
; GUIDA DEL MODULO H092
; Helper per liste Exec.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Helper per liste Exec: inserimento, rimozione e scorrimento dei nodi.
; --------------------------------------------------------------------------
; H092: 200 original bytes; all offsets are section-relative.
        section H092,code
H092:
; Preserved bytes H092+$00000000..$00000004; code/data not fully classified.
        dc.l H092+$00000000
; --------------------------------------------------------------------------
; ROUTINE: sub_H092_00000004 [parziale]
; Scopo: Routine del modulo helper per liste Exec; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$00F6
; --------------------------------------------------------------------------
L092_00000004:
; H092+$00000004: 4e75  rts 
        rts 
; Preserved bytes H092+$00000006..$0000007A; code/data not fully classified.
        dc.w $206F,$0008,$226F,$0004,$2C78,$0004,$2F57,$0008
        dc.w $508F,$4EEE,$FF10,$206F,$0008,$226F,$0004,$2C78
        dc.w $0004,$2F57,$0008,$508F,$4EEE,$FF0A,$206F,$0008
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0008,$508F,$4EEE
        dc.w $FEF2,$206F,$0008,$226F,$0004,$2C78,$0004,$2F57
        dc.w $0008,$508F,$4EEE,$FEEC,$206F,$000C,$226F,$0008
        dc.w $246F,$0004,$2C78,$0004,$2F57,$000C,$4FEF,$000C
        dc.w $4EEE,$FF16
; --------------------------------------------------------------------------
; ROUTINE: sub_H092_0000007A [parziale]
; Scopo: Routine del modulo helper per liste Exec; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H043+$032C
; --------------------------------------------------------------------------
L092_0000007A:
; H092+$0000007A: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L092_0000007E:
; H092+$0000007E: 2088  move.l a0, (a0)
        move.l a0, (a0)
L092_00000080:
; H092+$00000080: 5890  addq.l #$4, (a0)
        addq.l #$4, (a0)
L092_00000082:
; H092+$00000082: 42a80004  clr.l $4(a0)
        clr.l $4(a0)
L092_00000086:
; H092+$00000086: 21480008  move.l a0, $8(a0)
        move.l a0, $8(a0)
L092_0000008A:
; H092+$0000008A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L092_0000008C:
; H092+$0000008C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L092_0000008E:
; H092+$0000008E: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H092+$00000090..$000000C8; code/data not fully classified.
        dc.w $206F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FEFE,$226F,$0004,$2C78,$0004,$2F57,$0004,$588F
        dc.w $4EEE,$FF04,$206F,$0004,$2C78,$0004,$2F57,$0004
        dc.w $588F,$4EEE,$FEF8,$0000
; End H092: $C8 bytes
