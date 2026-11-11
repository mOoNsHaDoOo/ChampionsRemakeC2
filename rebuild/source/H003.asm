; ============================================================================
; GUIDA DEL MODULO H003
; Adattatori alle API exec.library, memoria e copie.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Come H002, ma per exec.library: AllocMem, FreeMem, CopyMem e servizi di memoria. Gli adattatori non controllano il risultato al posto del chiamante.
; --------------------------------------------------------------------------
; H003: 316 original bytes; all offsets are section-relative.
        section H003,code
H003:
; Preserved bytes H003+$00000000..$00000004; code/data not fully classified.
        dc.l H003+$00000000
; --------------------------------------------------------------------------
; ROUTINE: sub_H003_00000004 [parziale]
; Scopo: Routine del modulo adattatori alle API exec.library, memoria e copie; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$000C
; --------------------------------------------------------------------------
L003_00000004:
; H003+$00000004: 4e75  rts 
        rts 
; Preserved bytes H003+$00000006..$00000068; code/data not fully classified.
        dc.w $202F,$0014,$222F,$0010,$242F,$000C,$206F,$0008
        dc.w $226F,$0004,$2C78,$0004,$2F57,$0014,$4FEF,$0014
        dc.w $4EEE,$FD96,$202F,$0008,$226F,$0004,$2C78,$0004
        dc.w $2F57,$0008,$508F,$4EEE,$FF34,$206F,$0008,$202F
        dc.w $0004,$2C78,$0004,$2F57,$0008,$508F,$4EEE,$FF46
        dc.w $206F,$0004,$2C78,$0004,$2F57,$0004,$588F,$4EEE
        dc.w $FF22
; --------------------------------------------------------------------------
; ROUTINE: wrapper_AllocMem [parziale]
; Scopo: Adattatore a exec.library/AllocMem; incapsula la chiamata alla libreria.
;   - Chiama exec.library/AllocMem (LVO -198).
; Chiamanti diretti: H027+$24E8, H027+$26B4, H085+$2706, H041+$001C, H062+$1606, H027+$0C2C e altri 91
; --------------------------------------------------------------------------
L003_00000068:
; H003+$00000068: 202f0008  move.l $8(a7), d0
        move.l $8(a7), d0
L003_0000006C:
; H003+$0000006C: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L003_00000070:
; H003+$00000070: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L003_00000074:
; H003+$00000074: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L003_00000078:
; H003+$00000078: 508f  addq.l #$8, a7
        addq.l #$8, a7
L003_0000007A:
; H003+$0000007A: 4eeeff3a  jmp -$c6(a6) ; exec.library/AllocMem
        jmp LVO_exec_AllocMem(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_AvailMem [parziale]
; Scopo: Adattatore a exec.library/AvailMem; incapsula la chiamata alla libreria.
;   - Chiama exec.library/AvailMem (LVO -216).
; Chiamanti diretti: H010+$03C2
; --------------------------------------------------------------------------
L003_0000007E:
; H003+$0000007E: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L003_00000082:
; H003+$00000082: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L003_00000086:
; H003+$00000086: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L003_0000008A:
; H003+$0000008A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L003_0000008C:
; H003+$0000008C: 4eeeff28  jmp -$d8(a6) ; exec.library/AvailMem
        jmp LVO_exec_AvailMem(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CopyMem [parziale]
; Scopo: Adattatore a exec.library/CopyMem; incapsula la chiamata alla libreria.
;   - Chiama exec.library/CopyMem (LVO -624).
; Chiamanti diretti: H063+$1CEA, H011+$012A, H007+$05CA, H029+$0B04, H029+$0B2A, H061+$1BAE e altri 40
; --------------------------------------------------------------------------
L003_00000090:
; H003+$00000090: 206f000c  movea.l $c(a7), a0
        movea.l $c(a7), a0
L003_00000094:
; H003+$00000094: 226f0008  movea.l $8(a7), a1
        movea.l $8(a7), a1
L003_00000098:
; H003+$00000098: 202f0004  move.l $4(a7), d0
        move.l $4(a7), d0
L003_0000009C:
; H003+$0000009C: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L003_000000A0:
; H003+$000000A0: 2f57000c  move.l (a7), $c(a7)
        move.l (a7), $c(a7)
L003_000000A4:
; H003+$000000A4: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L003_000000A8:
; H003+$000000A8: 4eeefd90  jmp -$270(a6) ; exec.library/CopyMem
        jmp LVO_exec_CopyMem(a6)
; Preserved bytes H003+$000000AC..$000000F6; code/data not fully classified.
        dc.w $206F,$000C,$226F,$0008,$202F,$0004,$2C78,$0004
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FD8A,$206F,$000C
        dc.w $226F,$0008,$202F,$0004,$2C78,$0004,$2F57,$000C
        dc.w $4FEF,$000C,$4EEE,$FF40,$206F,$0004,$2C78,$0004
        dc.w $2F57,$0004,$588F,$4EEE,$FF1C
; --------------------------------------------------------------------------
; ROUTINE: wrapper_FreeMem [parziale]
; Scopo: Adattatore a exec.library/FreeMem; incapsula la chiamata alla libreria.
;   - Chiama exec.library/FreeMem (LVO -210).
; Chiamanti diretti: H027+$0C8A, H001+$00F6, H042+$0378, H007+$0BA4, H062+$0532, H027+$1644 e altri 61
; --------------------------------------------------------------------------
L003_000000F6:
; H003+$000000F6: 226f0008  movea.l $8(a7), a1
        movea.l $8(a7), a1
L003_000000FA:
; H003+$000000FA: 202f0004  move.l $4(a7), d0
        move.l $4(a7), d0
L003_000000FE:
; H003+$000000FE: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L003_00000102:
; H003+$00000102: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L003_00000106:
; H003+$00000106: 508f  addq.l #$8, a7
        addq.l #$8, a7
L003_00000108:
; H003+$00000108: 4eeeff2e  jmp -$d2(a6) ; exec.library/FreeMem
        jmp LVO_exec_FreeMem(a6)
; Preserved bytes H003+$0000010C..$0000013C; code/data not fully classified.
        dc.w $226F,$000A,$246F,$0006,$302F,$0004,$2C78,$0004
        dc.w $2F57,$000A,$4FEF,$000A,$4EEE,$FFB2,$226F,$0004
        dc.w $2C78,$0004,$2F57,$0004,$588F,$4EEE,$FDEA,$0000
; End H003: $13C bytes
