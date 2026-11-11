; ============================================================================
; GUIDA DEL MODULO H090
; Adattatori Exec per OpenDevice/CloseDevice.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Adattatori Exec per OpenDevice/CloseDevice.
; --------------------------------------------------------------------------
; H090: 200 original bytes; all offsets are section-relative.
        section H090,code
H090:
; Preserved bytes H090+$00000000..$00000004; code/data not fully classified.
        dc.l H090+$00000000
; --------------------------------------------------------------------------
; ROUTINE: sub_H090_00000004 [parziale]
; Scopo: Routine del modulo adattatori Exec per OpenDevice/CloseDevice; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$012C
; --------------------------------------------------------------------------
L090_00000004:
; H090+$00000004: 4e75  rts 
        rts 
; Preserved bytes H090+$00000006..$00000018; code/data not fully classified.
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FE50
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CloseDevice [parziale]
; Scopo: Adattatore a exec.library/CloseDevice; incapsula la chiamata alla libreria.
;   - Chiama exec.library/CloseDevice (LVO -450).
; Chiamanti diretti: H043+$0876
; --------------------------------------------------------------------------
L090_00000018:
; H090+$00000018: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L090_0000001C:
; H090+$0000001C: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L090_00000020:
; H090+$00000020: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L090_00000024:
; H090+$00000024: 588f  addq.l #$4, a7
        addq.l #$4, a7
L090_00000026:
; H090+$00000026: 4eeefe3e  jmp -$1c2(a6) ; exec.library/CloseDevice
        jmp LVO_exec_CloseDevice(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_OpenDevice [parziale]
; Scopo: Adattatore a exec.library/OpenDevice; incapsula la chiamata alla libreria.
;   - Chiama exec.library/OpenDevice (LVO -444).
; Chiamanti diretti: H043+$06C0
; --------------------------------------------------------------------------
L090_0000002A:
; H090+$0000002A: 206f0010  movea.l $10(a7), a0
        movea.l $10(a7), a0
L090_0000002E:
; H090+$0000002E: 202f000c  move.l $c(a7), d0
        move.l $c(a7), d0
L090_00000032:
; H090+$00000032: 226f0008  movea.l $8(a7), a1
        movea.l $8(a7), a1
L090_00000036:
; H090+$00000036: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L090_0000003A:
; H090+$0000003A: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L090_0000003E:
; H090+$0000003E: 2f570010  move.l (a7), $10(a7)
        move.l (a7), $10(a7)
L090_00000042:
; H090+$00000042: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L090_00000046:
; H090+$00000046: 4eeefe44  jmp -$1bc(a6) ; exec.library/OpenDevice
        jmp LVO_exec_OpenDevice(a6)
; Preserved bytes H090+$0000004A..$000000C8; code/data not fully classified.
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FE4A,$226F,$0004,$2C78,$0004,$2F57,$0004,$588F
        dc.w $4EEE,$FE20,$226F,$0004,$2C69,$0014,$2F57,$0004
        dc.w $588F,$4EEE,$FFE2,$226F,$0004,$2C78,$0004,$2F57
        dc.w $0004,$588F,$4EEE,$FE2C,$226F,$0004,$2C78,$0004
        dc.w $2F57,$0004,$588F,$4EEE,$FE38,$226F,$0004,$2C78
        dc.w $0004,$2F57,$0004,$588F,$4EEE,$FE32,$226F,$0004
        dc.w $2C78,$0004,$2F57,$0004,$588F,$4EEE,$FE26
; End H090: $C8 bytes
