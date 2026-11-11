; ============================================================================
; GUIDA DEL MODULO H036
; Adattatore dos.library/Delay.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Adattatore dos.library/Delay: converte l'attesa nel formato richiesto e chiama l'LVO.
; --------------------------------------------------------------------------
; H036: 144 original bytes; all offsets are section-relative.
        section H036,code
H036:
; Preserved bytes H036+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H036+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H036_00000008 [parziale]
; Scopo: Routine del modulo adattatore dos.library/Delay; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$0078
; --------------------------------------------------------------------------
L036_00000008:
; H036+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H036+$4(pc), a0
L036_0000000C:
; H036+$0000000C: 216cfff8fffc  move.l -$8(a4), -$4(a0)
        move.l -$8(a4), -$4(a0)
L036_00000012:
; H036+$00000012: 4e75  rts 
        rts 
; Preserved bytes H036+$00000014..$00000034; code/data not fully classified.
        dc.w $222F,$0010,$242F,$000C,$262F,$0008,$282F,$0004
        dc.w $2C7A,$FFDA,$2F57,$0010,$4FEF,$0010,$4EEE,$FF76
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Delay [parziale]
; Scopo: Adattatore a dos.library/Delay; incapsula la chiamata alla libreria.
;   - Chiama dos.library/Delay (LVO -198).
; Chiamanti diretti: H030+$0B60, H007+$066E, H063+$2914, H042+$0BFC, H048+$1546, H030+$0398 e altri 4
; --------------------------------------------------------------------------
L036_00000034:
; H036+$00000034: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L036_00000038:
; H036+$00000038: 2c7affc6  movea.l $0(pc), a6
        movea.l H036+$0(pc), a6
L036_0000003C:
; H036+$0000003C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L036_00000040:
; H036+$00000040: 588f  addq.l #$4, a7
        addq.l #$4, a7
L036_00000042:
; H036+$00000042: 4eeeff3a  jmp -$c6(a6) ; dos.library/Delay
        jmp LVO_dos_Delay(a6)
; Preserved bytes H036+$00000046..$00000090; code/data not fully classified.
        dc.w $222F,$0004,$2C7A,$FFB4,$2F57,$0004,$588F,$4EEE
        dc.w $FF52,$222F,$0004,$2C7A,$FFA2,$2F57,$0004,$588F
        dc.w $4EEE,$FF70,$222F,$0004,$2C7A,$FF90,$2F57,$0004
        dc.w $588F,$4EEE,$FF5E,$222F,$0004,$2C7A,$FF7E,$2F57
        dc.w $0004,$588F,$4EEE,$FF58,$0000
; End H036: $90 bytes
