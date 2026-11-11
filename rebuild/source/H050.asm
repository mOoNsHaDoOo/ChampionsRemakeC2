; ============================================================================
; GUIDA DEL MODULO H050
; Adattatori Exec per i messaggi.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Adattatori Exec per i messaggi (GetMsg/ReplyMsg/WaitPort).
; --------------------------------------------------------------------------
; H050: 136 original bytes; all offsets are section-relative.
        section H050,code
H050:
; Preserved bytes H050+$00000000..$00000004; code/data not fully classified.
        dc.l H050+$00000000
; --------------------------------------------------------------------------
; ROUTINE: sub_H050_00000004 [parziale]
; Scopo: Routine del modulo adattatori Exec per i messaggi; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$009C
; --------------------------------------------------------------------------
L050_00000004:
; H050+$00000004: 4e75  rts 
        rts 
; Preserved bytes H050+$00000006..$0000002A; code/data not fully classified.
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FE9E,$226F,$0004,$2C78,$0004,$2F57,$0004,$588F
        dc.w $4EEE,$FE7A
; --------------------------------------------------------------------------
; ROUTINE: wrapper_GetMsg [parziale]
; Scopo: Adattatore a exec.library/GetMsg; incapsula la chiamata alla libreria.
;   - Chiama exec.library/GetMsg (LVO -372).
; Chiamanti diretti: H010+$089A
; --------------------------------------------------------------------------
L050_0000002A:
; H050+$0000002A: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L050_0000002E:
; H050+$0000002E: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L050_00000032:
; H050+$00000032: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L050_00000036:
; H050+$00000036: 588f  addq.l #$4, a7
        addq.l #$4, a7
L050_00000038:
; H050+$00000038: 4eeefe8c  jmp -$174(a6) ; exec.library/GetMsg
        jmp LVO_exec_GetMsg(a6)
; Preserved bytes H050+$0000003C..$00000064; code/data not fully classified.
        dc.w $206F,$0008,$226F,$0004,$2C78,$0004,$2F57,$0008
        dc.w $508F,$4EEE,$FE92,$226F,$0004,$2C78,$0004,$2F57
        dc.w $0004,$588F,$4EEE,$FE98
; --------------------------------------------------------------------------
; ROUTINE: wrapper_ReplyMsg [parziale]
; Scopo: Adattatore a exec.library/ReplyMsg; incapsula la chiamata alla libreria.
;   - Chiama exec.library/ReplyMsg (LVO -378).
; Chiamanti diretti: H043+$0790, H010+$095E
; --------------------------------------------------------------------------
L050_00000064:
; H050+$00000064: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L050_00000068:
; H050+$00000068: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L050_0000006C:
; H050+$0000006C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L050_00000070:
; H050+$00000070: 588f  addq.l #$4, a7
        addq.l #$4, a7
L050_00000072:
; H050+$00000072: 4eeefe86  jmp -$17a(a6) ; exec.library/ReplyMsg
        jmp LVO_exec_ReplyMsg(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_WaitPort [parziale]
; Scopo: Adattatore a exec.library/WaitPort; incapsula la chiamata alla libreria.
;   - Chiama exec.library/WaitPort (LVO -384).
; Chiamanti diretti: H010+$098A
; --------------------------------------------------------------------------
L050_00000076:
; H050+$00000076: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L050_0000007A:
; H050+$0000007A: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L050_0000007E:
; H050+$0000007E: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L050_00000082:
; H050+$00000082: 588f  addq.l #$4, a7
        addq.l #$4, a7
L050_00000084:
; H050+$00000084: 4eeefe80  jmp -$180(a6) ; exec.library/WaitPort
        jmp LVO_exec_WaitPort(a6)
; End H050: $88 bytes
