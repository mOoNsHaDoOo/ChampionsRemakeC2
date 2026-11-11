; ============================================================================
; GUIDA DEL MODULO H022
; Adattatori graphics.library per view, palette e viewport.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Adattatori graphics.library per View, ViewPort, ColorMap e palette. Le strutture vengono preparate dai moduli chiamanti.
; --------------------------------------------------------------------------
; H022: 328 original bytes; all offsets are section-relative.
        section H022,code
H022:
; Preserved bytes H022+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H022+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H022_00000008 [parziale]
; Scopo: Routine del modulo adattatori graphics.library per view, palette e viewport; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$004E
; --------------------------------------------------------------------------
L022_00000008:
; H022+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H022+$4(pc), a0
L022_0000000C:
; H022+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L022_00000012:
; H022+$00000012: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: wrapper_FreeColorMap [parziale]
; Scopo: Adattatore a graphics.library/FreeColorMap; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/FreeColorMap (LVO -576).
; Chiamanti diretti: H029+$14AA
; --------------------------------------------------------------------------
L022_00000014:
; H022+$00000014: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L022_00000018:
; H022+$00000018: 2c7affe6  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_0000001C:
; H022+$0000001C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L022_00000020:
; H022+$00000020: 588f  addq.l #$4, a7
        addq.l #$4, a7
L022_00000022:
; H022+$00000022: 4eeefdc0  jmp -$240(a6) ; graphics.library/FreeColorMap
        jmp LVO_graphics_FreeColorMap(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_FreeVPortCopLists [parziale]
; Scopo: Adattatore a graphics.library/FreeVPortCopLists; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/FreeVPortCopLists (LVO -540).
; Chiamanti diretti: H029+$14B4
; --------------------------------------------------------------------------
L022_00000026:
; H022+$00000026: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L022_0000002A:
; H022+$0000002A: 2c7affd4  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_0000002E:
; H022+$0000002E: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L022_00000032:
; H022+$00000032: 588f  addq.l #$4, a7
        addq.l #$4, a7
L022_00000034:
; H022+$00000034: 4eeefde4  jmp -$21c(a6) ; graphics.library/FreeVPortCopLists
        jmp LVO_graphics_FreeVPortCopLists(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_GetColorMap [parziale]
; Scopo: Adattatore a graphics.library/GetColorMap; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/GetColorMap (LVO -570).
; Chiamanti diretti: H029+$1424
; --------------------------------------------------------------------------
L022_00000038:
; H022+$00000038: 202f0004  move.l $4(a7), d0
        move.l $4(a7), d0
L022_0000003C:
; H022+$0000003C: 2c7affc2  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_00000040:
; H022+$00000040: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L022_00000044:
; H022+$00000044: 588f  addq.l #$4, a7
        addq.l #$4, a7
L022_00000046:
; H022+$00000046: 4eeefdc6  jmp -$23a(a6) ; graphics.library/GetColorMap
        jmp LVO_graphics_GetColorMap(a6)
; Preserved bytes H022+$0000004A..$00000060; code/data not fully classified.
        dc.w $206F,$0008,$202F,$0004,$2C7A,$FFAC,$2F57,$0008
        dc.w $508F,$4EEE,$FDBA
; --------------------------------------------------------------------------
; ROUTINE: wrapper_InitView [parziale]
; Scopo: Adattatore a graphics.library/InitView; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/InitView (LVO -360).
; Chiamanti diretti: H029+$13A4
; --------------------------------------------------------------------------
L022_00000060:
; H022+$00000060: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L022_00000064:
; H022+$00000064: 2c7aff9a  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_00000068:
; H022+$00000068: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L022_0000006C:
; H022+$0000006C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L022_0000006E:
; H022+$0000006E: 4eeefe98  jmp -$168(a6) ; graphics.library/InitView
        jmp LVO_graphics_InitView(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_InitVPort [parziale]
; Scopo: Adattatore a graphics.library/InitVPort; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/InitVPort (LVO -204).
; Chiamanti diretti: H029+$13EE
; --------------------------------------------------------------------------
L022_00000072:
; H022+$00000072: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L022_00000076:
; H022+$00000076: 2c7aff88  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_0000007A:
; H022+$0000007A: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L022_0000007E:
; H022+$0000007E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L022_00000080:
; H022+$00000080: 4eeeff34  jmp -$cc(a6) ; graphics.library/InitVPort
        jmp LVO_graphics_InitVPort(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_LoadRGB4 [parziale]
; Scopo: Adattatore a graphics.library/LoadRGB4; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/LoadRGB4 (LVO -192).
; Chiamanti diretti: H007+$04E0, H011+$0156, H007+$0488, H044+$01EA, H042+$0288, H029+$11FA e altri 7
; --------------------------------------------------------------------------
L022_00000084:
; H022+$00000084: 206f000a  movea.l $a(a7), a0
        movea.l $a(a7), a0
L022_00000088:
; H022+$00000088: 226f0006  movea.l $6(a7), a1
        movea.l $6(a7), a1
L022_0000008C:
; H022+$0000008C: 302f0004  move.w $4(a7), d0
        move.w $4(a7), d0
L022_00000090:
; H022+$00000090: 2c7aff6e  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_00000094:
; H022+$00000094: 2f57000a  move.l (a7), $a(a7)
        move.l (a7), $a(a7)
L022_00000098:
; H022+$00000098: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L022_0000009C:
; H022+$0000009C: 4eeeff40  jmp -$c0(a6) ; graphics.library/LoadRGB4
        jmp LVO_graphics_LoadRGB4(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_LoadView [parziale]
; Scopo: Adattatore a graphics.library/LoadView; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/LoadView (LVO -222).
; Chiamanti diretti: H029+$16C0, H029+$16FC, H029+$159E, H029+$15B0
; --------------------------------------------------------------------------
L022_000000A0:
; H022+$000000A0: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L022_000000A4:
; H022+$000000A4: 2c7aff5a  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_000000A8:
; H022+$000000A8: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L022_000000AC:
; H022+$000000AC: 588f  addq.l #$4, a7
        addq.l #$4, a7
L022_000000AE:
; H022+$000000AE: 4eeeff22  jmp -$de(a6) ; graphics.library/LoadView
        jmp LVO_graphics_LoadView(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_MakeVPort [parziale]
; Scopo: Adattatore a graphics.library/MakeVPort; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/MakeVPort (LVO -216).
; Chiamanti diretti: H029+$1436
; --------------------------------------------------------------------------
L022_000000B2:
; H022+$000000B2: 206f0008  movea.l $8(a7), a0
        movea.l $8(a7), a0
L022_000000B6:
; H022+$000000B6: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L022_000000BA:
; H022+$000000BA: 2c7aff44  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_000000BE:
; H022+$000000BE: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L022_000000C2:
; H022+$000000C2: 508f  addq.l #$8, a7
        addq.l #$8, a7
L022_000000C4:
; H022+$000000C4: 4eeeff28  jmp -$d8(a6) ; graphics.library/MakeVPort
        jmp LVO_graphics_MakeVPort(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_MrgCop [parziale]
; Scopo: Adattatore a graphics.library/MrgCop; incapsula la chiamata alla libreria.
;   - Chiama graphics.library/MrgCop (LVO -210).
; Chiamanti diretti: H029+$1440
; --------------------------------------------------------------------------
L022_000000C8:
; H022+$000000C8: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L022_000000CC:
; H022+$000000CC: 2c7aff32  movea.l $0(pc), a6
        movea.l H022+$0(pc), a6
L022_000000D0:
; H022+$000000D0: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L022_000000D4:
; H022+$000000D4: 588f  addq.l #$4, a7
        addq.l #$4, a7
L022_000000D6:
; H022+$000000D6: 4eeeff2e  jmp -$d2(a6) ; graphics.library/MrgCop
        jmp LVO_graphics_MrgCop(a6)
; Preserved bytes H022+$000000DA..$00000148; code/data not fully classified.
        dc.w $206F,$0004,$2C7A,$FF20,$2F57,$0004,$588F,$4EEE
        dc.w $FDB4,$206F,$000C,$302F,$000A,$322F,$0008,$342F
        dc.w $0006,$362F,$0004,$2C7A,$FEFE,$2F57,$000C,$4FEF
        dc.w $000C,$4EEE,$FEE0,$206F,$000C,$302F,$000A,$322F
        dc.w $0008,$342F,$0006,$362F,$0004,$2C7A,$FEDA,$2F57
        dc.w $000C,$4FEF,$000C,$4EEE,$FD8A,$206F,$0004,$2C7A
        dc.w $FEC6,$2F57,$0004,$588F,$4EEE,$FE6E,$0000
; End H022: $148 bytes
