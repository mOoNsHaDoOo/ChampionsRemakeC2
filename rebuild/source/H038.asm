; ============================================================================
; GUIDA DEL MODULO H038
; Adattatori RectFill e selezione delle penne.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Adattatori RectFill, SetAPen e SetBPen; usati dal disegno di riquadri e dal testo.
; --------------------------------------------------------------------------
; H038: 504 original bytes; all offsets are section-relative.
        section H038,code
H038:
; Preserved bytes H038+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H038+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H038_00000008 [parziale]
; Scopo: Routine del modulo adattatori RectFill e selezione delle penne; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$0096
; --------------------------------------------------------------------------
L038_00000008:
; H038+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H038+$4(pc), a0
L038_0000000C:
; H038+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L038_00000012:
; H038+$00000012: 4e75  rts 
        rts 
; Preserved bytes H038+$00000014..$00000118; code/data not fully classified.
        dc.w $206F,$0004,$0268,$FFF7,$0020,$205F,$588F,$4ED0
        dc.w $226F,$0004,$2C7A,$FFD6,$2F57,$0004,$588F,$4EEE
        dc.w $0000,$226F,$0004,$2C7A,$FFC4,$2F57,$0004,$588F
        dc.w $4EEE,$FFD0,$226F,$0008,$302F,$0006,$322F,$0004
        dc.w $2C7A,$FFAA,$2F57,$0008,$508F,$4EEE,$FF0A,$226F
        dc.w $000A,$302F,$0008,$322F,$0006,$342F,$0004,$3602
        dc.w $2C7A,$FF8A,$2F57,$000A,$4FEF,$000A,$4EEE,$FF4C
        dc.w $226F,$000C,$302F,$000A,$322F,$0008,$342F,$0006
        dc.w $362F,$0004,$2C7A,$FF66,$2F57,$000C,$4FEF,$000C
        dc.w $4EEE,$FF4C,$226F,$000C,$242F,$0008,$302F,$0006
        dc.w $322F,$0004,$2C7A,$FF46,$2F57,$000C,$4FEF,$000C
        dc.w $4EEE,$FEB6,$226F,$0008,$302F,$0006,$322F,$0004
        dc.w $2C7A,$FF2A,$2F57,$0008,$508F,$4EEE,$FF10,$226F
        dc.w $000A,$302F,$0008,$206F,$0004,$2C7A,$FF10,$2F57
        dc.w $000A,$4FEF,$000A,$4EEE,$FEB0,$226F,$0008,$302F
        dc.w $0006,$322F,$0004,$2C7A,$FEF4,$2F57,$0008,$508F
        dc.w $4EEE,$FEC2
; --------------------------------------------------------------------------
; ROUTINE: wrapper_RectFill [parziale]
; Scopo: Adattatore a graphics.library/RectFill; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/RectFill (LVO -306).
; Chiamanti diretti: H030+$0BCA, H007+$06DE, H030+$0246, H069+$009C, H011+$05C4, H029+$1108
; --------------------------------------------------------------------------
L038_00000118:
; H038+$00000118: 226f000c  movea.l $c(a7), a1
        movea.l $c(a7), a1
L038_0000011C:
; H038+$0000011C: 302f000a  move.w $a(a7), d0
        move.w $a(a7), d0
L038_00000120:
; H038+$00000120: 322f0008  move.w $8(a7), d1
        move.w $8(a7), d1
L038_00000124:
; H038+$00000124: 342f0006  move.w $6(a7), d2
        move.w $6(a7), d2
L038_00000128:
; H038+$00000128: 362f0004  move.w $4(a7), d3
        move.w $4(a7), d3
L038_0000012C:
; H038+$0000012C: 2c7afed2  movea.l $0(pc), a6
        movea.l H038+$0(pc), a6
L038_00000130:
; H038+$00000130: 2f57000c  move.l (a7), $c(a7)
        move.l (a7), $c(a7)
L038_00000134:
; H038+$00000134: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L038_00000138:
; H038+$00000138: 4eeefece  jmp -$132(a6) ; graphics.library/RectFill
        jmp LVO_graphics_RectFill(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_SetAPen [parziale]
; Scopo: Adattatore a graphics.library/SetAPen; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/SetAPen (LVO -342).
; Chiamanti diretti: H030+$0B7E, H007+$06C6, H030+$0202, H069+$005A, H011+$05A8, H029+$10D0
; --------------------------------------------------------------------------
L038_0000013C:
; H038+$0000013C: 226f0006  movea.l $6(a7), a1
        movea.l $6(a7), a1
L038_00000140:
; H038+$00000140: 302f0004  move.w $4(a7), d0
        move.w $4(a7), d0
L038_00000144:
; H038+$00000144: 2c7afeba  movea.l $0(pc), a6
        movea.l H038+$0(pc), a6
L038_00000148:
; H038+$00000148: 2f570006  move.l (a7), $6(a7)
        move.l (a7), $6(a7)
L038_0000014C:
; H038+$0000014C: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L038_0000014E:
; H038+$0000014E: 4eeefeaa  jmp -$156(a6) ; graphics.library/SetAPen
        jmp LVO_graphics_SetAPen(a6)
; Preserved bytes H038+$00000152..$0000016C; code/data not fully classified.
        dc.w $206F,$000A,$216F,$0006,$0008,$302F,$0004,$1140
        dc.w $001D,$205F,$4FEF,$000A,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_SetBPen [parziale]
; Scopo: Adattatore a graphics.library/SetBPen; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/SetBPen (LVO -348).
; Chiamanti diretti: H030+$0B8C
; --------------------------------------------------------------------------
L038_0000016C:
; H038+$0000016C: 226f0006  movea.l $6(a7), a1
        movea.l $6(a7), a1
L038_00000170:
; H038+$00000170: 302f0004  move.w $4(a7), d0
        move.w $4(a7), d0
L038_00000174:
; H038+$00000174: 2c7afe8a  movea.l $0(pc), a6
        movea.l H038+$0(pc), a6
L038_00000178:
; H038+$00000178: 2f570006  move.l (a7), $6(a7)
        move.l (a7), $6(a7)
L038_0000017C:
; H038+$0000017C: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L038_0000017E:
; H038+$0000017E: 4eeefea4  jmp -$15c(a6) ; graphics.library/SetBPen
        jmp LVO_graphics_SetBPen(a6)
; Preserved bytes H038+$00000182..$000001B4; code/data not fully classified.
        dc.w $226F,$0006,$102F,$0004,$2C7A,$FE74,$2F57,$0006
        dc.w $5C8F,$4EEE,$FE9E,$206F,$0006,$316F,$0004,$0022
        dc.w $0068,$0001,$0020,$117C,$000F,$001F,$205F,$5C8F
        dc.w $4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H038_000001B4 [parziale]
; Scopo: Routine del modulo adattatori RectFill e selezione delle penne; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H030+$0B9A, H030+$0212, H069+$0068
; --------------------------------------------------------------------------
L038_000001B4:
; H038+$000001B4: 206f0006  movea.l $6(a7), a0
        movea.l $6(a7), a0
L038_000001B8:
; H038+$000001B8: 302f0004  move.w $4(a7), d0
        move.w $4(a7), d0
L038_000001BC:
; H038+$000001BC: 1140001b  move.b d0, $1b(a0)
        move.b d0, $1b(a0)
L038_000001C0:
; H038+$000001C0: 006800080020  ori.w #$8, $20(a0)
        ori.w #$8, $20(a0)
L038_000001C6:
; H038+$000001C6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L038_000001C8:
; H038+$000001C8: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L038_000001CA:
; H038+$000001CA: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H038+$000001CC..$000001F8; code/data not fully classified.
        dc.w $206F,$0006,$116F,$0004,$0018,$205F,$5C8F,$4ED0
        dc.w $226F,$0008,$302F,$0006,$322F,$0004,$2C7A,$FE16
        dc.w $2F57,$0008,$508F,$4EEE,$FEBC,$0000
; End H038: $1F8 bytes
