; ============================================================================
; GUIDA DEL MODULO H083
; inizializzazione di un puntatore globale.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Inizializzazione di un puntatore globale usato dai moduli successivi.
; --------------------------------------------------------------------------
; H083: 92 original bytes; all offsets are section-relative.
        section H083,code
H083:
; Preserved bytes H083+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H083+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H083_00000008 [parziale]
; Scopo: Routine del modulo inizializzazione di un puntatore globale; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$010E
; --------------------------------------------------------------------------
L083_00000008:
; H083+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H083+$4(pc), a0
L083_0000000C:
; H083+$0000000C: 216cfff0fffc  move.l -$10(a4), -$4(a0)
        move.l -$10(a4), -$4(a0)
L083_00000012:
; H083+$00000012: 4e75  rts 
        rts 
; Preserved bytes H083+$00000014..$0000005C; code/data not fully classified.
        dc.w $206F,$0004,$2C7A,$FFE6,$2F57,$0004,$588F,$4EEE
        dc.w $FE6E,$206F,$0004,$2C7A,$FFD4,$2F57,$0004,$588F
        dc.w $4EEE,$FFDC,$202F,$0004,$2C7A,$FFC2,$2F57,$0004
        dc.w $588F,$4EEE,$FE62,$206F,$0004,$2C7A,$FFB0,$2F57
        dc.w $0004,$588F,$4EEE,$FE5C
; End H083: $5C bytes
