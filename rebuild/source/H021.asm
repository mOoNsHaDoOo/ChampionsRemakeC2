; ============================================================================
; GUIDA DEL MODULO H021
; Adattatori intuition.library.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Adattatori intuition.library: screen, window, IDCMP, pointer e title. Le funzioni sono wrapper sottili attorno agli LVO.
; --------------------------------------------------------------------------
; H021: 1632 original bytes; all offsets are section-relative.
        section H021,code
H021:
; Preserved bytes H021+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H021+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H021_00000008 [parziale]
; Scopo: Routine del modulo adattatori intuition.library; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H000+$0048
; --------------------------------------------------------------------------
L021_00000008:
; H021+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H021+$4(pc), a0
L021_0000000C:
; H021+$0000000C: 216cfff0fffc  move.l -$10(a4), -$4(a0)
        move.l -$10(a4), -$4(a0)
L021_00000012:
; H021+$00000012: 4e75  rts 
        rts 
; Preserved bytes H021+$00000014..$00000030; code/data not fully classified.
        dc.w $206F,$000C,$202F,$0008,$222F,$0004,$2C7A,$FFDE
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FE74
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CurrentTime [parziale]
; Scopo: Adattatore a intuition.library/CurrentTime; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/CurrentTime (LVO -84).
; Chiamanti diretti: H006+$0274, H030+$0A56
; --------------------------------------------------------------------------
L021_00000030:
; H021+$00000030: 206f0008  movea.l $8(a7), a0
        movea.l $8(a7), a0
L021_00000034:
; H021+$00000034: 226f0004  movea.l $4(a7), a1
        movea.l $4(a7), a1
L021_00000038:
; H021+$00000038: 2c7affc6  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_0000003C:
; H021+$0000003C: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L021_00000040:
; H021+$00000040: 508f  addq.l #$8, a7
        addq.l #$8, a7
L021_00000042:
; H021+$00000042: 4eeeffac  jmp -$54(a6) ; intuition.library/CurrentTime
        jmp LVO_intuition_CurrentTime(a6)
; Preserved bytes H021+$00000046..$0000010C; code/data not fully classified.
        dc.w $202F,$000A,$206F,$0006,$322F,$0004,$2C7A,$FFAC
        dc.w $2F57,$000A,$4FEF,$000A,$4EEE,$FFA6,$202F,$0010
        dc.w $222F,$000C,$242F,$0008,$262F,$0004,$2C7A,$FF8C
        dc.w $2F57,$0010,$4FEF,$0010,$4EEE,$FF9A,$206F,$000C
        dc.w $226F,$0008,$302F,$0006,$322F,$0004,$2C7A,$FF6C
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FF94,$206F,$000C
        dc.w $226F,$0008,$302F,$0006,$322F,$0004,$2C7A,$FF4C
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FF8E,$206F,$0006
        dc.w $7000,$102F,$0004,$2C7A,$FF32,$2F57,$0006,$5C8F
        dc.w $4EEE,$FE68,$206F,$0004,$2C7A,$FF20,$2F57,$0004
        dc.w $588F,$4EEE,$FEB6,$206F,$000C,$226F,$0008,$302F
        dc.w $0006,$322F,$0004,$2C7A,$FF02,$2F57,$000C,$4FEF
        dc.w $000C,$4EEE,$FF28
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CloseScreen [parziale]
; Scopo: Adattatore a intuition.library/CloseScreen; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/CloseScreen (LVO -66).
; Chiamanti diretti: H029+$12F0
; --------------------------------------------------------------------------
L021_0000010C:
; H021+$0000010C: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L021_00000110:
; H021+$00000110: 2c7afeee  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_00000114:
; H021+$00000114: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L021_00000118:
; H021+$00000118: 588f  addq.l #$4, a7
        addq.l #$4, a7
L021_0000011A:
; H021+$0000011A: 4eeeffbe  jmp -$42(a6) ; intuition.library/CloseScreen
        jmp LVO_intuition_CloseScreen(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CloseWorkBench [parziale]
; Scopo: Adattatore a intuition.library/CloseWorkBench; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/CloseWorkBench (LVO -78).
; Chiamanti diretti: H029+$127C
; --------------------------------------------------------------------------
L021_0000011E:
; H021+$0000011E: 2c7afee0  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_00000122:
; H021+$00000122: 4eeeffb2  jmp -$4e(a6) ; intuition.library/CloseWorkBench
        jmp LVO_intuition_CloseWorkBench(a6)
; Preserved bytes H021+$00000126..$00000184; code/data not fully classified.
        dc.w $206F,$0004,$2C7A,$FED4,$2F57,$0004,$588F,$4EEE
        dc.w $FFA0,$206F,$000C,$302F,$000A,$322F,$0008,$226F
        dc.w $0004,$2C7A,$FEB6,$2F57,$000C,$4FEF,$000C,$4EEE
        dc.w $FE56,$206F,$0004,$2C7A,$FEA2,$2F57,$0004,$588F
        dc.w $4EEE,$FE86,$206F,$0008,$302F,$0006,$322F,$0004
        dc.w $2C7A,$FE88,$2F57,$0008,$508F,$4EEE,$FF5E
; --------------------------------------------------------------------------
; ROUTINE: wrapper_OpenScreen [parziale]
; Scopo: Adattatore a intuition.library/OpenScreen; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/OpenScreen (LVO -198).
; Chiamanti diretti: H024+$00CC
; --------------------------------------------------------------------------
L021_00000184:
; H021+$00000184: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L021_00000188:
; H021+$00000188: 2c7afe76  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_0000018C:
; H021+$0000018C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L021_00000190:
; H021+$00000190: 588f  addq.l #$4, a7
        addq.l #$4, a7
L021_00000192:
; H021+$00000192: 4eeeff3a  jmp -$c6(a6) ; intuition.library/OpenScreen
        jmp LVO_intuition_OpenScreen(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_OpenWorkBench [parziale]
; Scopo: Adattatore a intuition.library/OpenWorkBench; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/OpenWorkBench (LVO -210).
; Chiamanti diretti: H029+$12F6
; --------------------------------------------------------------------------
L021_00000196:
; H021+$00000196: 2c7afe68  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_0000019A:
; H021+$0000019A: 4eeeff2e  jmp -$d2(a6) ; intuition.library/OpenWorkBench
        jmp LVO_intuition_OpenWorkBench(a6)
; Preserved bytes H021+$0000019E..$000001D2; code/data not fully classified.
        dc.w $2C7A,$FE60,$4EEE,$FE80,$2C7A,$FE58,$4EEE,$FE7A
        dc.w $206F,$0004,$2C7A,$FE4C,$2F57,$0004,$588F,$4EEE
        dc.w $FF0A,$206F,$0004,$2C7A,$FE3A,$2F57,$0004,$588F
        dc.w $4EEE,$FF04
; --------------------------------------------------------------------------
; ROUTINE: wrapper_ShowTitle [parziale]
; Scopo: Adattatore a intuition.library/ShowTitle; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/ShowTitle (LVO -282).
; Chiamanti diretti: H029+$123A
; --------------------------------------------------------------------------
L021_000001D2:
; H021+$000001D2: 206f0006  movea.l $6(a7), a0
        movea.l $6(a7), a0
L021_000001D6:
; H021+$000001D6: 7000  moveq #$0, d0
        moveq #0, d0
L021_000001D8:
; H021+$000001D8: 102f0004  move.b $4(a7), d0
        move.b $4(a7), d0
L021_000001DC:
; H021+$000001DC: 2c7afe22  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_000001E0:
; H021+$000001E0: 2f570006  move.l (a7), $6(a7)
        move.l (a7), $6(a7)
L021_000001E4:
; H021+$000001E4: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L021_000001E6:
; H021+$000001E6: 4eeefee6  jmp -$11a(a6) ; intuition.library/ShowTitle
        jmp LVO_intuition_ShowTitle(a6)
; Preserved bytes H021+$000001EA..$000001FA; code/data not fully classified.
        dc.w $2C7A,$FE14,$4EEE,$FEB0,$2C7A,$FE0C,$4EEE,$FEAA
; --------------------------------------------------------------------------
; ROUTINE: wrapper_ActivateWindow [parziale]
; Scopo: Adattatore a intuition.library/ActivateWindow; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/ActivateWindow (LVO -450).
; Chiamanti diretti: H029+$1290
; --------------------------------------------------------------------------
L021_000001FA:
; H021+$000001FA: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L021_000001FE:
; H021+$000001FE: 2c7afe00  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_00000202:
; H021+$00000202: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L021_00000206:
; H021+$00000206: 588f  addq.l #$4, a7
        addq.l #$4, a7
L021_00000208:
; H021+$00000208: 4eeefe3e  jmp -$1c2(a6) ; intuition.library/ActivateWindow
        jmp LVO_intuition_ActivateWindow(a6)
; Preserved bytes H021+$0000020C..$00000230; code/data not fully classified.
        dc.w $206F,$0004,$2C7A,$FDEE,$2F57,$0004,$588F,$4EEE
        dc.w $FE9E,$206F,$0004,$2C7A,$FDDC,$2F57,$0004,$588F
        dc.w $4EEE,$FFD0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_ClearPointer [parziale]
; Scopo: Adattatore a intuition.library/ClearPointer; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/ClearPointer (LVO -60).
; Chiamanti diretti: H007+$0B94, H029+$01AA
; --------------------------------------------------------------------------
L021_00000230:
; H021+$00000230: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L021_00000234:
; H021+$00000234: 2c7afdca  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_00000238:
; H021+$00000238: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L021_0000023C:
; H021+$0000023C: 588f  addq.l #$4, a7
        addq.l #$4, a7
L021_0000023E:
; H021+$0000023E: 4eeeffc4  jmp -$3c(a6) ; intuition.library/ClearPointer
        jmp LVO_intuition_ClearPointer(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CloseWindow [parziale]
; Scopo: Adattatore a intuition.library/CloseWindow; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/CloseWindow (LVO -72).
; Chiamanti diretti: H029+$12E4
; --------------------------------------------------------------------------
L021_00000242:
; H021+$00000242: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L021_00000246:
; H021+$00000246: 2c7afdb8  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_0000024A:
; H021+$0000024A: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L021_0000024E:
; H021+$0000024E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L021_00000250:
; H021+$00000250: 4eeeffb8  jmp -$48(a6) ; intuition.library/CloseWindow
        jmp LVO_intuition_CloseWindow(a6)
; Preserved bytes H021+$00000254..$0000026C; code/data not fully classified.
        dc.w $206F,$0006,$7000,$102F,$0004,$2C7A,$FDA0,$2F57
        dc.w $0006,$5C8F,$4EEE,$FE92
; --------------------------------------------------------------------------
; ROUTINE: wrapper_ModifyIDCMP [parziale]
; Scopo: Adattatore a intuition.library/ModifyIDCMP; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/ModifyIDCMP (LVO -150).
; Chiamanti diretti: H008+$05D0, H008+$1384, H008+$0F72
; --------------------------------------------------------------------------
L021_0000026C:
; H021+$0000026C: 206f0008  movea.l $8(a7), a0
        movea.l $8(a7), a0
L021_00000270:
; H021+$00000270: 202f0004  move.l $4(a7), d0
        move.l $4(a7), d0
L021_00000274:
; H021+$00000274: 2c7afd8a  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_00000278:
; H021+$00000278: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L021_0000027C:
; H021+$0000027C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L021_0000027E:
; H021+$0000027E: 4eeeff6a  jmp -$96(a6) ; intuition.library/ModifyIDCMP
        jmp LVO_intuition_ModifyIDCMP(a6)
; Preserved bytes H021+$00000282..$0000029C; code/data not fully classified.
        dc.w $206F,$0008,$302F,$0006,$322F,$0004,$2C7A,$FD70
        dc.w $2F57,$0008,$508F,$4EEE,$FF58
; --------------------------------------------------------------------------
; ROUTINE: wrapper_OpenWindow [parziale]
; Scopo: Adattatore a intuition.library/OpenWindow; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/OpenWindow (LVO -204).
; Chiamanti diretti: H025+$00B6
; --------------------------------------------------------------------------
L021_0000029C:
; H021+$0000029C: 206f0004  movea.l $4(a7), a0
        movea.l $4(a7), a0
L021_000002A0:
; H021+$000002A0: 2c7afd5e  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_000002A4:
; H021+$000002A4: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L021_000002A8:
; H021+$000002A8: 588f  addq.l #$4, a7
        addq.l #$4, a7
L021_000002AA:
; H021+$000002AA: 4eeeff34  jmp -$cc(a6) ; intuition.library/OpenWindow
        jmp LVO_intuition_OpenWindow(a6)
; Preserved bytes H021+$000002AE..$000002EE; code/data not fully classified.
        dc.w $206F,$0004,$2C7A,$FD4C,$2F57,$0004,$588F,$4EEE
        dc.w $FE38,$206F,$0006,$7000,$102F,$0004,$2C7A,$FD34
        dc.w $2F57,$0006,$5C8F,$4EEE,$FF16,$206F,$0008,$226F
        dc.w $0004,$2C7A,$FD1E,$2F57,$0008,$508F,$4EEE,$FEFE
; --------------------------------------------------------------------------
; ROUTINE: wrapper_SetPointer [parziale]
; Scopo: Adattatore a intuition.library/SetPointer; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/SetPointer (LVO -270).
; Chiamanti diretti: H007+$0A34, H029+$0222
; --------------------------------------------------------------------------
L021_000002EE:
; H021+$000002EE: 206f0010  movea.l $10(a7), a0
        movea.l $10(a7), a0
L021_000002F2:
; H021+$000002F2: 226f000c  movea.l $c(a7), a1
        movea.l $c(a7), a1
L021_000002F6:
; H021+$000002F6: 302f000a  move.w $a(a7), d0
        move.w $a(a7), d0
L021_000002FA:
; H021+$000002FA: 322f0008  move.w $8(a7), d1
        move.w $8(a7), d1
L021_000002FE:
; H021+$000002FE: 342f0006  move.w $6(a7), d2
        move.w $6(a7), d2
L021_00000302:
; H021+$00000302: 362f0004  move.w $4(a7), d3
        move.w $4(a7), d3
L021_00000306:
; H021+$00000306: 2c7afcf8  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_0000030A:
; H021+$0000030A: 2f570010  move.l (a7), $10(a7)
        move.l (a7), $10(a7)
L021_0000030E:
; H021+$0000030E: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L021_00000312:
; H021+$00000312: 4eeefef2  jmp -$10e(a6) ; intuition.library/SetPointer
        jmp LVO_intuition_SetPointer(a6)
; Preserved bytes H021+$00000316..$000003AE; code/data not fully classified.
        dc.w $206F,$000C,$226F,$0008,$246F,$0004,$2C7A,$FCDC
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FEEC,$206F,$0008
        dc.w $302F,$0006,$322F,$0004,$2C7A,$FCC0,$2F57,$0008
        dc.w $508F,$4EEE,$FEE0,$2C7A,$FCB2,$4EEE,$FEDA,$206F
        dc.w $0004,$2C7A,$FCA6,$2F57,$0004,$588F,$4EEE,$FED4
        dc.w $206F,$000C,$302F,$000A,$322F,$0008,$342F,$0006
        dc.w $362F,$0004,$2C7A,$FC84,$2F57,$000C,$4FEF,$000C
        dc.w $4EEE,$FEC2,$206F,$0004,$2C7A,$FC70,$2F57,$0004
        dc.w $588F,$4EEE,$FECE,$206F,$0004,$2C7A,$FC5E,$2F57
        dc.w $0004,$588F,$4EEE,$FEC8
; --------------------------------------------------------------------------
; ROUTINE: wrapper_AutoRequest [parziale]
; Scopo: Adattatore a intuition.library/AutoRequest; incapsula la chiamata alla libreria.
;   - Chiama intuition.library/AutoRequest (LVO -348).
; Chiamanti diretti: H028+$02B6
; --------------------------------------------------------------------------
L021_000003AE:
; H021+$000003AE: 206f001c  movea.l $1c(a7), a0
        movea.l $1c(a7), a0
L021_000003B2:
; H021+$000003B2: 226f0018  movea.l $18(a7), a1
        movea.l $18(a7), a1
L021_000003B6:
; H021+$000003B6: 246f0014  movea.l $14(a7), a2
        movea.l $14(a7), a2
L021_000003BA:
; H021+$000003BA: 266f0010  movea.l $10(a7), a3
        movea.l $10(a7), a3
L021_000003BE:
; H021+$000003BE: 202f000c  move.l $c(a7), d0
        move.l $c(a7), d0
L021_000003C2:
; H021+$000003C2: 222f0008  move.l $8(a7), d1
        move.l $8(a7), d1
L021_000003C6:
; H021+$000003C6: 342f0006  move.w $6(a7), d2
        move.w $6(a7), d2
L021_000003CA:
; H021+$000003CA: 362f0004  move.w $4(a7), d3
        move.w $4(a7), d3
L021_000003CE:
; H021+$000003CE: 2c7afc30  movea.l $0(pc), a6
        movea.l H021+$0(pc), a6
L021_000003D2:
; H021+$000003D2: 2f57001c  move.l (a7), $1c(a7)
        move.l (a7), $1c(a7)
L021_000003D6:
; H021+$000003D6: 4fef001c  lea.l $1c(a7), a7
        lea.l $1c(a7), a7
L021_000003DA:
; H021+$000003DA: 4eeefea4  jmp -$15c(a6) ; intuition.library/AutoRequest
        jmp LVO_intuition_AutoRequest(a6)
; Preserved bytes H021+$000003DE..$00000660; code/data not fully classified.
        dc.w $206F,$0018,$226F,$0014,$246F,$0010,$266F,$000C
        dc.w $202F,$0008,$322F,$0006,$342F,$0004,$2C7A,$FC04
        dc.w $2F57,$0018,$4FEF,$0018,$4EEE,$FE98,$206F,$0008
        dc.w $226F,$0004,$2C7A,$FBEC,$2F57,$0008,$508F,$4EEE
        dc.w $FF88,$206F,$0004,$2C7A,$FBDA,$2F57,$0004,$588F
        dc.w $4EEE,$FE8C,$206F,$0004,$2C7A,$FBC8,$2F57,$0004
        dc.w $588F,$4EEE,$FF76,$206F,$0008,$226F,$0004,$2C7A
        dc.w $FBB2,$2F57,$0008,$508F,$4EEE,$FF10,$206F,$0004
        dc.w $2C7A,$FBA0,$2F57,$0004,$588F,$4EEE,$FFCA,$206F
        dc.w $0006,$302F,$0004,$2C7A,$FB8A,$2F57,$0006,$5C8F
        dc.w $4EEE,$FF70,$206F,$0006,$302F,$0004,$2C7A,$FB74
        dc.w $2F57,$0006,$5C8F,$4EEE,$FF4C,$206F,$0006,$302F
        dc.w $0004,$2C7A,$FB5E,$2F57,$0006,$5C8F,$4EEE,$FF40
        dc.w $206F,$0008,$226F,$0004,$2C7A,$FB48,$2F57,$0008
        dc.w $508F,$4EEE,$FEF8,$302F,$0004,$0240,$001F,$205F
        dc.w $548F,$4ED0,$302F,$0004,$EA48,$0240,$003F,$205F
        dc.w $548F,$4ED0,$302F,$0004,$720B,$E268,$0240,$001F
        dc.w $205F,$548F,$4ED0,$206F,$000C,$226F,$0008,$246F
        dc.w $0004,$2C7A,$FAFE,$2F57,$000C,$4FEF,$000C,$4EEE
        dc.w $FE32,$206F,$000A,$226F,$0006,$302F,$0004,$2C7A
        dc.w $FAE2,$2F57,$000A,$4FEF,$000A,$4EEE,$FFD6,$206F
        dc.w $0010,$226F,$000C,$302F,$000A,$322F,$0008,$246F
        dc.w $0004,$2C7A,$FABE,$2F57,$0010,$4FEF,$0010,$4EEE
        dc.w $FE4A,$206F,$0016,$226F,$0012,$246F,$000E,$302F
        dc.w $000C,$322F,$000A,$342F,$0008,$362F,$0006,$382F
        dc.w $0004,$2C7A,$FA8E,$2F57,$0016,$4FEF,$0016,$4EEE
        dc.w $FF64,$206F,$0018,$226F,$0014,$246F,$0010,$302F
        dc.w $000E,$322F,$000C,$342F,$000A,$362F,$0008,$382F
        dc.w $0006,$3A2F,$0004,$48C5,$2C7A,$FA58,$2F57,$0018
        dc.w $4FEF,$0018,$4EEE,$FE2C,$206F,$000C,$226F,$0008
        dc.w $246F,$0004,$2C7A,$FA3C,$2F57,$000C,$4FEF,$000C
        dc.w $4EEE,$FF52,$206F,$000C,$226F,$0008,$246F,$0004
        dc.w $2C7A,$FA20,$2F57,$000C,$4FEF,$000C,$4EEE,$FF46
        dc.w $206F,$000C,$226F,$0008,$246F,$0004,$2C7A,$FA04
        dc.w $2F57,$000C,$4FEF,$000C,$4EEE,$FF22,$206F,$000E
        dc.w $226F,$000A,$246F,$0006,$302F,$0004,$48C0,$2C7A
        dc.w $F9E2,$2F57,$000E,$4FEF,$000E,$4EEE,$FE50,$206F
        dc.w $0008,$226F,$0004,$2C7A,$F9CA,$2F57,$0008,$508F
        dc.w $4EEE,$FF1C,$206F,$000A,$226F,$0006,$302F,$0004
        dc.w $48C0,$2C7A,$F9AE,$2F57,$000A,$4FEF,$000A,$4EEE
        dc.w $FE44
; End H021: $660 bytes
