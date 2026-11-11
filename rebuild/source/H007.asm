; ============================================================================
; GUIDA DEL MODULO H007
; Introduzione: immagini LBM, crediti e avvio audio.
; I commenti descrivono l’analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================

; --------------------------------------------------------------------------
; NOTA MODULO
; Percorso introduttivo: carica immagini LBM, mostra crediti e prepara l'audio. Usa il lettore ILBM e i servizi di presentazione.
; --------------------------------------------------------------------------
; H007: 3036 original bytes; all offsets are section-relative.
        section H007,code
H007:
; Preserved bytes H007+$00000000..$000002C0; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$496E,$7365,$7274,$2044,$6973,$6B20,$4F6E
        dc.w $6520,$696E,$2064,$7269,$7665,$2064,$6630,$0062
        dc.w $6173,$6564,$206F,$6E20,$616E,$206F,$7269,$6769
        dc.w $6E61,$6C20,$7374,$6F72,$7920,$6279,$3A00,$4A69
        dc.w $6D20,$5761,$7264,$0056,$6963,$746F,$7220,$5065
        dc.w $6E6D,$616E,$2C00,$616E,$6400,$4461,$7665,$2053
        dc.w $6865,$6C6C,$6579,$0067,$616D,$6520,$6372,$6561
        dc.w $7465,$6420,$6279,$3A00,$5353,$4920,$5370,$6563
        dc.w $6961,$6C20,$5072,$6F6A,$6563,$7473,$0050,$726F
        dc.w $6A65,$6374,$2044,$6972,$6563,$746F,$723A,$0056
        dc.w $6963,$746F,$7220,$5065,$6E6D,$616E,$0050,$726F
        dc.w $6772,$616D,$6D69,$6E67,$004E,$6F72,$6D20,$4B6F
        dc.w $6765,$7200,$5275,$7373,$2042,$726F,$776E,$004D
        dc.w $6963,$6861,$656C,$204D,$634E,$616C,$6C79,$0045
        dc.w $6E63,$6F75,$6E74,$6572,$2044,$6573,$6967,$6E00
        dc.w $4461,$7665,$2053,$6865,$6C6C,$6579,$004D,$6963
        dc.w $6861,$656C,$204D,$616E,$6375,$736F,$004B,$656E
        dc.w $2048,$756D,$7068,$7269,$6573,$0047,$7261,$7068
        dc.w $6963,$2041,$7274,$733A,$004C,$6175,$7261,$2042
        dc.w $6F77,$656E,$2C20,$546F,$6D20,$5761,$686C,$2C20
        dc.w $4672,$6564,$2042,$7574,$7473,$004D,$6172,$6B20
        dc.w $4A6F,$686E,$736F,$6E2C,$2043,$7972,$7573,$204C
        dc.w $756D,$2C20,$5375,$7361,$6E20,$4D61,$6E6C,$6579
        dc.w $0070,$6C61,$7974,$6573,$743A,$0052,$6963,$6B20
        dc.w $5768,$6974,$652C,$2054,$6F6D,$2053,$6368,$756D
        dc.w $6163,$6865,$7200,$4572,$696B,$2046,$6C6F,$6D2C
        dc.w $204A,$6F68,$6E20,$4B69,$726B,$2C20,$4461,$7665
        dc.w $204C,$7563,$6361,$2C00,$446F,$6E20,$4D63,$436C
        dc.w $7572,$652C,$204C,$2E53,$2E57,$6562,$6265,$722C
        dc.w $2052,$6963,$6B20,$5769,$6C73,$6F6E,$004D,$7573
        dc.w $6963,$616C,$2073,$636F,$7265,$3A00,$6A6F,$686E
        dc.w $2068,$616C,$626C,$6965,$6200,$7363,$726E,$3162
        dc.w $2E6C,$626D,$0049,$6E73,$6572,$7420,$4469,$736B
        dc.w $204F,$6E65,$2069,$6E20,$6472,$6976,$6520,$6466
        dc.w $3000,$7363,$726E,$3162,$2E4C,$424D,$0073,$6372
        dc.w $6E32,$2E4C,$424D,$0074,$6578,$7431,$2E4C,$424D
        dc.w $0074,$6578,$7432,$2E4C,$424D,$0000
        dc.l H007+$00000072
; --------------------------------------------------------------------------
; ROUTINE: module_init_H007 [parziale]
; Scopo: Ingresso del modulo introduzione: immagini LBM, crediti e avvio audio; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H007+$0BD6.
; Chiamanti diretti: H000+$01EC
; --------------------------------------------------------------------------
L007_000002C0:
; H007+$000002C0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_000002C2:
; H007+$000002C2: 287afff8  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_000002C6:
; H007+$000002C6: 4e550000  link.w a5, #$0
        link.w a5, #$0
L007_000002CA:
; H007+$000002CA: 6000090a  bra.w $bd6
        bra.w H007+$BD6
; Preserved bytes H007+$000002CE..$00000304; code/data not fully classified.
        dc.w $2F0C,$287A,$FFEA,$4E55,$FFFC,$296D,$000C,$FFD4
        dc.w $2F2D,$000C,$2F3C,$0001,$0002,$4EB9
        dc.l H003+$00000068
        dc.w $2B40,$FFFC,$202D,$FFFC,$6000,$0002,$4E5D,$285F
        dc.w $205F,$588F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H007_00000304 [parziale]
; Scopo: Routine del modulo introduzione: immagini LBM, crediti e avvio audio; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H007+$0426
; --------------------------------------------------------------------------
L007_00000304:
; H007+$00000304: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_00000306:
; H007+$00000306: 287affb4  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_0000030A:
; H007+$0000030A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L007_0000030E:
; H007+$0000030E: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L007_00000312:
; H007+$00000312: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L007_00000316:
; H007+$00000316: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L007_0000031A:
; H007+$0000031A: 3682  move.w d2, (a3)
        move.w d2, (a3)
L007_0000031C:
; H007+$0000031C: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L007_00000320:
; H007+$00000320: 024200f0  andi.w #$f0, d2
        andi.w #$f0, d2
L007_00000324:
; H007+$00000324: e842  asr.w #$4, d2
        asr.w #$4, d2
L007_00000326:
; H007+$00000326: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L007_0000032A:
; H007+$0000032A: 3682  move.w d2, (a3)
        move.w d2, (a3)
L007_0000032C:
; H007+$0000032C: 342d0018  move.w $18(a5), d2
        move.w $18(a5), d2
L007_00000330:
; H007+$00000330: 02420f00  andi.w #$f00, d2
        andi.w #$f00, d2
L007_00000334:
; H007+$00000334: e042  asr.w #$8, d2
        asr.w #$8, d2
L007_00000336:
; H007+$00000336: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L007_0000033A:
; H007+$0000033A: 3682  move.w d2, (a3)
        move.w d2, (a3)
L007_0000033C:
; H007+$0000033C: 4e5d  unlk a5
        unlk a5
L007_0000033E:
; H007+$0000033E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_00000340:
; H007+$00000340: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L007_00000342:
; H007+$00000342: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L007_00000346:
; H007+$00000346: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H007_00000348 [parziale]
; Scopo: Routine del modulo introduzione: immagini LBM, crediti e avvio audio; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H007+$045C
; --------------------------------------------------------------------------
L007_00000348:
; H007+$00000348: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_0000034A:
; H007+$0000034A: 287aff70  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_0000034E:
; H007+$0000034E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L007_00000352:
; H007+$00000352: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L007_00000356:
; H007+$00000356: 6c000006  bge.w $35e
        bge.w H007+$35E
L007_0000035A:
; H007+$0000035A: 426d0010  clr.w $10(a5)
        clr.w $10(a5)
L007_0000035E:
; H007+$0000035E: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L007_00000362:
; H007+$00000362: 6c000006  bge.w $36a
        bge.w H007+$36A
L007_00000366:
; H007+$00000366: 426d000e  clr.w $e(a5)
        clr.w $e(a5)
L007_0000036A:
; H007+$0000036A: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L007_0000036E:
; H007+$0000036E: 6c000006  bge.w $376
        bge.w H007+$376
L007_00000372:
; H007+$00000372: 426d000c  clr.w $c(a5)
        clr.w $c(a5)
L007_00000376:
; H007+$00000376: 0c6d000f0010  cmpi.w #$f, $10(a5)
        cmpi.w #$f, $10(a5)
L007_0000037C:
; H007+$0000037C: 6f000008  ble.w $386
        ble.w H007+$386
L007_00000380:
; H007+$00000380: 3b7c000f0010  move.w #$f, $10(a5)
        move.w #$f, $10(a5)
L007_00000386:
; H007+$00000386: 0c6d000f000e  cmpi.w #$f, $e(a5)
        cmpi.w #$f, $e(a5)
L007_0000038C:
; H007+$0000038C: 6f000008  ble.w $396
        ble.w H007+$396
L007_00000390:
; H007+$00000390: 3b7c000f000e  move.w #$f, $e(a5)
        move.w #$f, $e(a5)
L007_00000396:
; H007+$00000396: 0c6d000f000c  cmpi.w #$f, $c(a5)
        cmpi.w #$f, $c(a5)
L007_0000039C:
; H007+$0000039C: 6f000008  ble.w $3a6
        ble.w H007+$3A6
L007_000003A0:
; H007+$000003A0: 3b7c000f000c  move.w #$f, $c(a5)
        move.w #$f, $c(a5)
L007_000003A6:
; H007+$000003A6: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L007_000003AA:
; H007+$000003AA: e142  asl.w #$8, d2
        asl.w #$8, d2
L007_000003AC:
; H007+$000003AC: 382d000e  move.w $e(a5), d4
        move.w $e(a5), d4
L007_000003B0:
; H007+$000003B0: e944  asl.w #$4, d4
        asl.w #$4, d4
L007_000003B2:
; H007+$000003B2: d444  add.w d4, d2
        add.w d4, d2
L007_000003B4:
; H007+$000003B4: 382d000c  move.w $c(a5), d4
        move.w $c(a5), d4
L007_000003B8:
; H007+$000003B8: d444  add.w d4, d2
        add.w d4, d2
L007_000003BA:
; H007+$000003BA: 3002  move.w d2, d0
        move.w d2, d0
L007_000003BC:
; H007+$000003BC: 60000002  bra.w $3c0
        bra.w H007+$3C0
L007_000003C0:
; H007+$000003C0: 4e5d  unlk a5
        unlk a5
L007_000003C2:
; H007+$000003C2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_000003C4:
; H007+$000003C4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L007_000003C6:
; H007+$000003C6: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L007_000003C8:
; H007+$000003C8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H007_000003CA [parziale]
; Scopo: Routine del modulo introduzione: immagini LBM, crediti e avvio audio; richiama H016+$01AC, H022+$0084.
;   - Richiama H016+$01AC.
;   - Richiama H022+$0084.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H007+$0B72, H007+$05A4, H007+$0612
; --------------------------------------------------------------------------
L007_000003CA:
; H007+$000003CA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_000003CC:
; H007+$000003CC: 287afeee  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_000003D0:
; H007+$000003D0: 4e55ffb4  link.w a5, #$ffb4
        link.w a5, #$ffb4
L007_000003D4:
; H007+$000003D4: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L007_000003D8:
; H007+$000003D8: 0c6d000ffffe  cmpi.w #$f, -$2(a5)
        cmpi.w #$f, -$2(a5)
L007_000003DE:
; H007+$000003DE: 6e0000b6  bgt.w $496
        bgt.w H007+$496
L007_000003E2:
; H007+$000003E2: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L007_000003E6:
; H007+$000003E6: 67000010  beq.w $3f8
        beq.w H007+$3F8
L007_000003EA:
; H007+$000003EA: 740f  moveq #$f, d2
        moveq #15, d2
L007_000003EC:
; H007+$000003EC: 946dfffe  sub.w -$2(a5), d2
        sub.w -$2(a5), d2
L007_000003F0:
; H007+$000003F0: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L007_000003F4:
; H007+$000003F4: 60000008  bra.w $3fe
        bra.w H007+$3FE
L007_000003F8:
; H007+$000003F8: 3b6dfffefff4  move.w -$2(a5), -$c(a5)
        move.w -$2(a5), -$c(a5)
L007_000003FE:
; H007+$000003FE: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L007_00000402:
; H007+$00000402: 0c6d001ffffc  cmpi.w #$1f, -$4(a5)
        cmpi.w #$1f, -$4(a5)
L007_00000408:
; H007+$00000408: 6e000064  bgt.w $46e
        bgt.w H007+$46E
L007_0000040C:
; H007+$0000040C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L007_00000410:
; H007+$00000410: e342  asl.w #$1, d2
        asl.w #$1, d2
L007_00000412:
; H007+$00000412: 47ecff94  lea.l -$6c(a4), a3
        lea.l -$6c(a4), a3
L007_00000416:
; H007+$00000416: 3f332000  move.w (a3, d2.w), -(a7)
        move.w (a3, d2.w), -(a7)
L007_0000041A:
; H007+$0000041A: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L007_0000041E:
; H007+$0000041E: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L007_00000422:
; H007+$00000422: 486dfff6  pea.l -$a(a5)
        pea.l -$a(a5)
L007_00000426:
; H007+$00000426: 6100fedc  bsr.w $304
        bsr.w H007+$304
L007_0000042A:
; H007+$0000042A: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L007_0000042E:
; H007+$0000042E: 956dfffa  sub.w d2, -$6(a5)
        sub.w d2, -$6(a5)
L007_00000432:
; H007+$00000432: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L007_00000436:
; H007+$00000436: 956dfff6  sub.w d2, -$a(a5)
        sub.w d2, -$a(a5)
L007_0000043A:
; H007+$0000043A: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L007_0000043E:
; H007+$0000043E: 956dfff8  sub.w d2, -$8(a5)
        sub.w d2, -$8(a5)
L007_00000442:
; H007+$00000442: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L007_00000446:
; H007+$00000446: e342  asl.w #$1, d2
        asl.w #$1, d2
L007_00000448:
; H007+$00000448: 47edffb4  lea.l -$4c(a5), a3
        lea.l -$4c(a5), a3
L007_0000044C:
; H007+$0000044C: 48e72010  movem.l d2/a3, -(a7)
        movem.l d2/a3, -(a7)
L007_00000450:
; H007+$00000450: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L007_00000454:
; H007+$00000454: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L007_00000458:
; H007+$00000458: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L007_0000045C:
; H007+$0000045C: 6100feea  bsr.w $348
        bsr.w H007+$348
L007_00000460:
; H007+$00000460: 4cdf0804  movem.l (a7)+, d2/a3
        movem.l (a7)+, d2/a3
L007_00000464:
; H007+$00000464: 37802000  move.w d0, (a3, d2.w)
        move.w d0, (a3, d2.w)
L007_00000468:
; H007+$00000468: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L007_0000046C:
; H007+$0000046C: 6894  bvc.b $402
        bvc.b H007+$402
; -> H016+$01AC (wrapper_WaitTOF)
L007_0000046E:
; H007+$0000046E: 4eb9000001ac  jsr $1ac.l
        jsr (H016+$1AC).l
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L007_00000474:
; H007+$00000474: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L007_0000047A:
; H007+$0000047A: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L007_0000047E:
; H007+$0000047E: 47edffb4  lea.l -$4c(a5), a3
        lea.l -$4c(a5), a3
L007_00000482:
; H007+$00000482: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L007_00000484:
; H007+$00000484: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L007_00000488:
; H007+$00000488: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L007_0000048E:
; H007+$0000048E: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L007_00000492:
; H007+$00000492: 6800ff44  bvc.w $3d8
        bvc.w H007+$3D8
L007_00000496:
; H007+$00000496: 4e5d  unlk a5
        unlk a5
L007_00000498:
; H007+$00000498: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_0000049A:
; H007+$0000049A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L007_0000049C:
; H007+$0000049C: 548f  addq.l #$2, a7
        addq.l #$2, a7
L007_0000049E:
; H007+$0000049E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H007_000004A0 [parziale]
; Scopo: Routine del modulo introduzione: immagini LBM, crediti e avvio audio; richiama H022+$0084, H016+$01AC.
;   - Richiama H022+$0084.
;   - Richiama H016+$01AC.
;   - Usa lo stato globale: H005+$52F2 (puntatore allo schermo del gioco).
; Chiamanti diretti: H007+$0A7C, H007+$05B4
; --------------------------------------------------------------------------
L007_000004A0:
; H007+$000004A0: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_000004A2:
; H007+$000004A2: 287afe18  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_000004A6:
; H007+$000004A6: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L007_000004AA:
; H007+$000004AA: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L007_000004AE:
; H007+$000004AE: 0c6d001ffffe  cmpi.w #$1f, -$2(a5)
        cmpi.w #$1f, -$2(a5)
L007_000004B4:
; H007+$000004B4: 6e000016  bgt.w $4cc
        bgt.w H007+$4CC
L007_000004B8:
; H007+$000004B8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L007_000004BC:
; H007+$000004BC: e342  asl.w #$1, d2
        asl.w #$1, d2
L007_000004BE:
; H007+$000004BE: 47ecff94  lea.l -$6c(a4), a3
        lea.l -$6c(a4), a3
L007_000004C2:
; H007+$000004C2: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L007_000004C6:
; H007+$000004C6: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L007_000004CA:
; H007+$000004CA: 68e2  bvc.b $4ae
        bvc.b H007+$4AE
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L007_000004CC:
; H007+$000004CC: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L007_000004D2:
; H007+$000004D2: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L007_000004D6:
; H007+$000004D6: 47ecff94  lea.l -$6c(a4), a3
        lea.l -$6c(a4), a3
L007_000004DA:
; H007+$000004DA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L007_000004DC:
; H007+$000004DC: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L007_000004E0:
; H007+$000004E0: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
; -> H016+$01AC (wrapper_WaitTOF)
L007_000004E6:
; H007+$000004E6: 4eb9000001ac  jsr $1ac.l
        jsr (H016+$1AC).l
L007_000004EC:
; H007+$000004EC: 4e5d  unlk a5
        unlk a5
L007_000004EE:
; H007+$000004EE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_000004F0:
; H007+$000004F0: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Intro_LoadLBM [parziale]
; Scopo: Apre un’immagine introduttiva e la inoltra al percorso di caricamento ILBM.
;   - Riceve nome risorsa e messaggio di richiesta disco.
;   - Usa gli helper di apertura file e il lettore grafico.
;   - Il dettaglio di tutti i flag dell’introduzione resta da completare.
; Chiamanti diretti: H007+$0ABE, H007+$0AF2, H007+$0B26, H007+$0B58
; --------------------------------------------------------------------------
L007_000004F2:
; H007+$000004F2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_000004F4:
; H007+$000004F4: 287afdc6  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_000004F8:
; H007+$000004F8: 4e55ff90  link.w a5, #$ff90
        link.w a5, #$ff90
L007_000004FC:
; H007+$000004FC: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L007_00000500:
; H007+$00000500: 5242  addq.w #$1, d2
        addq.w #$1, d2
L007_00000502:
; H007+$00000502: 08020000  btst.b #$0, d2
        btst #$0, d2
L007_00000506:
; H007+$00000506: 6702  beq.b $50a
        beq.b H007+$50A
L007_00000508:
; H007+$00000508: 5242  addq.w #$1, d2
        addq.w #$1, d2
L007_0000050A:
; H007+$0000050A: 9ec2  suba.w d2, a7
        suba.w d2, a7
L007_0000050C:
; H007+$0000050C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L007_00000510:
; H007+$00000510: 2b4f0010  move.l a7, $10(a5)
        move.l a7, $10(a5)
L007_00000514:
; H007+$00000514: 244f  movea.l a7, a2
        movea.l a7, a2
L007_00000516:
; H007+$00000516: 5342  subq.w #$1, d2
        subq.w #$1, d2
L007_00000518:
; H007+$00000518: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L007_0000051A:
; H007+$0000051A: 51cafffc  dbra d2, $518
        dbra d2, H007+$518
L007_0000051E:
; H007+$0000051E: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L007_00000522:
; H007+$00000522: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L007_00000526:
; H007+$00000526: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L007_0000052A:
; H007+$0000052A: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L007_0000052E:
; H007+$0000052E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L007_00000532:
; H007+$00000532: 486cff8e  pea.l -$72(a4)
        pea.l -$72(a4)
; FLUSSO: Chiama Open_ResourceFile (H028+$05FA).
L007_00000536:
; H007+$00000536: 4eb9000005fa  jsr $5fa.l
        jsr (H028+$5FA).l
L007_0000053C:
; H007+$0000053C: 1940ff93  move.b d0, -$6d(a4)
        move.b d0, -$6d(a4)
L007_00000540:
; H007+$00000540: 4aacff8e  tst.l -$72(a4)
        tst.l -$72(a4)
L007_00000544:
; H007+$00000544: 670000fc  beq.w $642
        beq.w H007+$642
L007_00000548:
; H007+$00000548: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L007_0000054C:
; H007+$0000054C: 0c6d0004fffa  cmpi.w #$4, -$6(a5)
        cmpi.w #$4, -$6(a5)
L007_00000552:
; H007+$00000552: 6e000016  bgt.w $56a
        bgt.w H007+$56A
L007_00000556:
; H007+$00000556: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L007_0000055A:
; H007+$0000055A: e542  asl.w #$2, d2
        asl.w #$2, d2
L007_0000055C:
; H007+$0000055C: 47ecffe0  lea.l -$20(a4), a3
        lea.l -$20(a4), a3
L007_00000560:
; H007+$00000560: 42b32000  clr.l (a3, d2.w)
        clr.l (a3, d2.w)
L007_00000564:
; H007+$00000564: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L007_00000568:
; H007+$00000568: 68e2  bvc.b $54c
        bvc.b H007+$54C
L007_0000056A:
; H007+$0000056A: 2f2cff8e  move.l -$72(a4), -(a7)
        move.l -$72(a4), -(a7)
L007_0000056E:
; H007+$0000056E: 486cffd8  pea.l -$28(a4)
        pea.l -$28(a4)
L007_00000572:
; H007+$00000572: 486dff94  pea.l -$6c(a5)
        pea.l -$6c(a5)
L007_00000576:
; H007+$00000576: 487afd56  pea.l $2ce(pc)
        pea.l H007+$2CE(pc)
; FLUSSO: Chiama Read_ILBM (H040+$05E4).
L007_0000057A:
; H007+$0000057A: 4eb9000005e4  jsr $5e4.l
        jsr (H040+$5E4).l
L007_00000580:
; H007+$00000580: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L007_00000584:
; H007+$00000584: 2f2cff8e  move.l -$72(a4), -(a7)
        move.l -$72(a4), -(a7)
; -> H002+$0014 (wrapper_Close)
L007_00000588:
; H007+$00000588: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L007_0000058E:
; H007+$0000058E: 0cadfffffffefffc  cmpi.l #$fffffffe, -$4(a5)
        cmpi.l #$fffffffe, -$4(a5)
L007_00000596:
; H007+$00000596: 6d00009c  blt.w $634
        blt.w H007+$634
L007_0000059A:
; H007+$0000059A: 4a2d000e  tst.b $e(a5)
        tst.b $e(a5)
L007_0000059E:
; H007+$0000059E: 6700000c  beq.w $5ac
        beq.w H007+$5AC
L007_000005A2:
; H007+$000005A2: 4227  clr.b -(a7)
        clr.b -(a7)
L007_000005A4:
; H007+$000005A4: 6100fe24  bsr.w $3ca
        bsr.w H007+$3CA
L007_000005A8:
; H007+$000005A8: 6000000e  bra.w $5b8
        bra.w H007+$5B8
L007_000005AC:
; H007+$000005AC: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L007_000005B0:
; H007+$000005B0: 67000006  beq.w $5b8
        beq.w H007+$5B8
L007_000005B4:
; H007+$000005B4: 6100feea  bsr.w $4a0
        bsr.w H007+$4A0
L007_000005B8:
; H007+$000005B8: 47edffba  lea.l -$46(a5), a3
        lea.l -$46(a5), a3
L007_000005BC:
; H007+$000005BC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L007_000005BE:
; H007+$000005BE: 47ecff94  lea.l -$6c(a4), a3
        lea.l -$6c(a4), a3
L007_000005C2:
; H007+$000005C2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L007_000005C4:
; H007+$000005C4: 2f3c00000040  move.l #$40, -(a7)
        move.l #$40, -(a7)
; -> H003+$0090 (wrapper_CopyMem)
L007_000005CA:
; H007+$000005CA: 4eb900000090  jsr $90.l
        jsr (H003+$90).l
L007_000005D0:
; H007+$000005D0: 486cffd8  pea.l -$28(a4)
        pea.l -$28(a4)
L007_000005D4:
; H007+$000005D4: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000005D6:
; H007+$000005D6: 4267  clr.w -(a7)
        clr.w -(a7)
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L007_000005D8:
; H007+$000005D8: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L007_000005DE:
; H007+$000005DE: 486b00b8  pea.l $b8(a3)
        pea.l $b8(a3)
L007_000005E2:
; H007+$000005E2: 3f2d001c  move.w $1c(a5), -(a7)
        move.w $1c(a5), -(a7)
L007_000005E6:
; H007+$000005E6: 3f2d001a  move.w $1a(a5), -(a7)
        move.w $1a(a5), -(a7)
L007_000005EA:
; H007+$000005EA: 3f2d0018  move.w $18(a5), -(a7)
        move.w $18(a5), -(a7)
L007_000005EE:
; H007+$000005EE: 3f2d0016  move.w $16(a5), -(a7)
        move.w $16(a5), -(a7)
L007_000005F2:
; H007+$000005F2: 1f3c00ca  move.b #$ca, -(a7)
        move.b #$ca, -(a7)
L007_000005F6:
; H007+$000005F6: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L007_000005FA:
; H007+$000005FA: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L007_000005FC:
; H007+$000005FC: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L007_00000602:
; H007+$00000602: 2b40ff90  move.l d0, -$70(a5)
        move.l d0, -$70(a5)
L007_00000606:
; H007+$00000606: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L007_0000060A:
; H007+$0000060A: 6700000e  beq.w $61a
        beq.w H007+$61A
L007_0000060E:
; H007+$0000060E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L007_00000612:
; H007+$00000612: 6100fdb6  bsr.w $3ca
        bsr.w H007+$3CA
L007_00000616:
; H007+$00000616: 6000001c  bra.w $634
        bra.w H007+$634
; STATO: H005+$52F2 = puntatore allo schermo del gioco
L007_0000061A:
; H007+$0000061A: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L007_00000620:
; H007+$00000620: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L007_00000624:
; H007+$00000624: 47ecff94  lea.l -$6c(a4), a3
        lea.l -$6c(a4), a3
L007_00000628:
; H007+$00000628: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L007_0000062A:
; H007+$0000062A: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L007_0000062E:
; H007+$0000062E: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L007_00000634:
; H007+$00000634: 2f2cffe0  move.l -$20(a4), -(a7)
        move.l -$20(a4), -(a7)
L007_00000638:
; H007+$00000638: 2f2cffd4  move.l -$2c(a4), -(a7)
        move.l -$2c(a4), -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L007_0000063C:
; H007+$0000063C: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L007_00000642:
; H007+$00000642: 4e5d  unlk a5
        unlk a5
L007_00000644:
; H007+$00000644: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_00000646:
; H007+$00000646: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L007_00000648:
; H007+$00000648: 4fef0012  lea.l $12(a7), a7
        lea.l $12(a7), a7
L007_0000064C:
; H007+$0000064C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H007_0000064E [parziale]
; Scopo: Routine del modulo introduzione: immagini LBM, crediti e avvio audio; richiama H036+$0034, H010+$042E.
;   - Richiama H036+$0034.
;   - Richiama H010+$042E.
;   - Usa lo stato globale: H005+$5305 (byte del tasto/azione pendente).
; Chiamanti diretti: H007+$09E6, H007+$0AC6, H007+$0AFA, H007+$0B2E, H007+$0B60, H007+$0B82
; --------------------------------------------------------------------------
L007_0000064E:
; H007+$0000064E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_00000650:
; H007+$00000650: 287afc6a  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_00000654:
; H007+$00000654: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L007_00000658:
; H007+$00000658: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L007_0000065C:
; H007+$0000065C: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L007_00000660:
; H007+$00000660: c4fc000a  mulu.w #$a, d2
        mulu.w #$a, d2
L007_00000664:
; H007+$00000664: 3b42000c  move.w d2, $c(a5)
        move.w d2, $c(a5)
L007_00000668:
; H007+$00000668: 2f3c00000005  move.l #$5, -(a7)
        move.l #$5, -(a7)
; -> H036+$0034 (wrapper_Delay)
L007_0000066E:
; H007+$0000066E: 4eb900000034  jsr $34.l
        jsr (H036+$34).l
L007_00000674:
; H007+$00000674: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
; -> H010+$042E (trampoline_H010_0882)
L007_00000678:
; H007+$00000678: 4eb90000042e  jsr $42e.l
        jsr (H010+$42E).l
; STATO: H005+$5305 = byte del tasto/azione pendente
L007_0000067E:
; H007+$0000067E: 4a3900005305  tst.b $5305.l
        tst.b (H005+$5305).l
L007_00000684:
; H007+$00000684: 6600000c  bne.w $692
        bne.w H007+$692
L007_00000688:
; H007+$00000688: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L007_0000068C:
; H007+$0000068C: b46d000c  cmp.w $c(a5), d2
        cmp.w $c(a5), d2
L007_00000690:
; H007+$00000690: 65d6  bcs.b $668
        bcs.b H007+$668
L007_00000692:
; H007+$00000692: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L007_00000696:
; H007+$00000696: b46d000c  cmp.w $c(a5), d2
        cmp.w $c(a5), d2
L007_0000069A:
; H007+$0000069A: 55c2  scs.b d2
        scs.b d2
L007_0000069C:
; H007+$0000069C: 4402  neg.b d2
        neg.b d2
L007_0000069E:
; H007+$0000069E: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L007_000006A2:
; H007+$000006A2: 102dfffd  move.b -$3(a5), d0
        move.b -$3(a5), d0
L007_000006A6:
; H007+$000006A6: 60000002  bra.w $6aa
        bra.w H007+$6AA
L007_000006AA:
; H007+$000006AA: 4e5d  unlk a5
        unlk a5
L007_000006AC:
; H007+$000006AC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_000006AE:
; H007+$000006AE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L007_000006B0:
; H007+$000006B0: 548f  addq.l #$2, a7
        addq.l #$2, a7
L007_000006B2:
; H007+$000006B2: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H007_000006B4 [parziale]
; Scopo: Routine del modulo introduzione: immagini LBM, crediti e avvio audio; richiama H038+$013C, H038+$0118.
;   - Richiama H038+$013C.
;   - Richiama H038+$0118.
; Chiamanti diretti: H007+$0B76, H007+$0BAA
; --------------------------------------------------------------------------
L007_000006B4:
; H007+$000006B4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_000006B6:
; H007+$000006B6: 287afc04  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_000006BA:
; H007+$000006BA: 4e550000  link.w a5, #$0
        link.w a5, #$0
L007_000006BE:
; H007+$000006BE: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L007_000006C4:
; H007+$000006C4: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H038+$013C (wrapper_SetAPen)
L007_000006C6:
; H007+$000006C6: 4eb90000013c  jsr $13c.l
        jsr (H038+$13C).l
L007_000006CC:
; H007+$000006CC: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L007_000006D2:
; H007+$000006D2: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000006D4:
; H007+$000006D4: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000006D6:
; H007+$000006D6: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L007_000006DA:
; H007+$000006DA: 3f3c00c8  move.w #$c8, -(a7)
        move.w #$c8, -(a7)
; -> H038+$0118 (wrapper_RectFill)
L007_000006DE:
; H007+$000006DE: 4eb900000118  jsr $118.l
        jsr (H038+$118).l
L007_000006E4:
; H007+$000006E4: 4e5d  unlk a5
        unlk a5
L007_000006E6:
; H007+$000006E6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_000006E8:
; H007+$000006E8: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H007_000006EA [parziale]
; Scopo: Routine del modulo introduzione: immagini LBM, crediti e avvio audio; richiama H044+$02D8, H030+$0256.
;   - Richiama H044+$02D8.
;   - Richiama H030+$0256.
; Chiamanti diretti: H007+$0B7A
; --------------------------------------------------------------------------
L007_000006EA:
; H007+$000006EA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_000006EC:
; H007+$000006EC: 287afbce  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_000006F0:
; H007+$000006F0: 4e550000  link.w a5, #$0
        link.w a5, #$0
; -> H044+$02D8 (sub_H044_000002D8)
L007_000006F4:
; H007+$000006F4: 4eb9000002d8  jsr $2d8.l
        jsr (H044+$2D8).l
L007_000006FA:
; H007+$000006FA: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L007_000006FE:
; H007+$000006FE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L007_00000702:
; H007+$00000702: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L007_00000706:
; H007+$00000706: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000708:
; H007+$00000708: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L007_0000070C:
; H007+$0000070C: 486c001d  pea.l $1d(a4)
        pea.l $1d(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000710:
; H007+$00000710: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000716:
; H007+$00000716: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L007_0000071A:
; H007+$0000071A: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_0000071E:
; H007+$0000071E: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_00000722:
; H007+$00000722: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000724:
; H007+$00000724: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L007_00000728:
; H007+$00000728: 486c003c  pea.l $3c(a4)
        pea.l $3c(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_0000072C:
; H007+$0000072C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000732:
; H007+$00000732: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L007_00000736:
; H007+$00000736: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_0000073A:
; H007+$0000073A: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_0000073E:
; H007+$0000073E: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000740:
; H007+$00000740: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_00000744:
; H007+$00000744: 486c0045  pea.l $45(a4)
        pea.l $45(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000748:
; H007+$00000748: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000074E:
; H007+$0000074E: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L007_00000752:
; H007+$00000752: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000756:
; H007+$00000756: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L007_0000075A:
; H007+$0000075A: 4267  clr.w -(a7)
        clr.w -(a7)
L007_0000075C:
; H007+$0000075C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000760:
; H007+$00000760: 486c0054  pea.l $54(a4)
        pea.l $54(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000764:
; H007+$00000764: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000076A:
; H007+$0000076A: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L007_0000076E:
; H007+$0000076E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000772:
; H007+$00000772: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_00000776:
; H007+$00000776: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000778:
; H007+$00000778: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_0000077C:
; H007+$0000077C: 486c0058  pea.l $58(a4)
        pea.l $58(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000780:
; H007+$00000780: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000786:
; H007+$00000786: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_0000078A:
; H007+$0000078A: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L007_0000078E:
; H007+$0000078E: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L007_00000792:
; H007+$00000792: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000794:
; H007+$00000794: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L007_00000798:
; H007+$00000798: 486c0065  pea.l $65(a4)
        pea.l $65(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_0000079C:
; H007+$0000079C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000007A2:
; H007+$000007A2: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L007_000007A6:
; H007+$000007A6: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L007_000007AA:
; H007+$000007AA: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_000007AE:
; H007+$000007AE: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000007B0:
; H007+$000007B0: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_000007B4:
; H007+$000007B4: 486c0076  pea.l $76(a4)
        pea.l $76(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000007B8:
; H007+$000007B8: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000007BE:
; H007+$000007BE: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_000007C2:
; H007+$000007C2: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L007_000007C6:
; H007+$000007C6: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_000007CA:
; H007+$000007CA: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000007CC:
; H007+$000007CC: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L007_000007D0:
; H007+$000007D0: 486c008b  pea.l $8b(a4)
        pea.l $8b(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000007D4:
; H007+$000007D4: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000007DA:
; H007+$000007DA: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_000007DE:
; H007+$000007DE: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L007_000007E2:
; H007+$000007E2: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_000007E6:
; H007+$000007E6: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000007E8:
; H007+$000007E8: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L007_000007EC:
; H007+$000007EC: 486c009d  pea.l $9d(a4)
        pea.l $9d(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000007F0:
; H007+$000007F0: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000007F6:
; H007+$000007F6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_000007FA:
; H007+$000007FA: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L007_000007FE:
; H007+$000007FE: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_00000802:
; H007+$00000802: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000804:
; H007+$00000804: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L007_00000808:
; H007+$00000808: 486c00ab  pea.l $ab(a4)
        pea.l $ab(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_0000080C:
; H007+$0000080C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000812:
; H007+$00000812: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_00000816:
; H007+$00000816: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L007_0000081A:
; H007+$0000081A: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_0000081E:
; H007+$0000081E: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000820:
; H007+$00000820: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L007_00000824:
; H007+$00000824: 486c00b7  pea.l $b7(a4)
        pea.l $b7(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000828:
; H007+$00000828: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000082E:
; H007+$0000082E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_00000832:
; H007+$00000832: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L007_00000836:
; H007+$00000836: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_0000083A:
; H007+$0000083A: 4267  clr.w -(a7)
        clr.w -(a7)
L007_0000083C:
; H007+$0000083C: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L007_00000840:
; H007+$00000840: 486c00c2  pea.l $c2(a4)
        pea.l $c2(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000844:
; H007+$00000844: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000084A:
; H007+$0000084A: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_0000084E:
; H007+$0000084E: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_00000852:
; H007+$00000852: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_00000856:
; H007+$00000856: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000858:
; H007+$00000858: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L007_0000085C:
; H007+$0000085C: 486c00cd  pea.l $cd(a4)
        pea.l $cd(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000860:
; H007+$00000860: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000866:
; H007+$00000866: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_0000086A:
; H007+$0000086A: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L007_0000086E:
; H007+$0000086E: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_00000872:
; H007+$00000872: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000874:
; H007+$00000874: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L007_00000878:
; H007+$00000878: 486c00dd  pea.l $dd(a4)
        pea.l $dd(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_0000087C:
; H007+$0000087C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000882:
; H007+$00000882: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_00000886:
; H007+$00000886: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L007_0000088A:
; H007+$0000088A: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_0000088E:
; H007+$0000088E: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000890:
; H007+$00000890: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_00000894:
; H007+$00000894: 486c00ee  pea.l $ee(a4)
        pea.l $ee(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000898:
; H007+$00000898: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000089E:
; H007+$0000089E: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_000008A2:
; H007+$000008A2: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L007_000008A6:
; H007+$000008A6: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_000008AA:
; H007+$000008AA: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000008AC:
; H007+$000008AC: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L007_000008B0:
; H007+$000008B0: 486c00fb  pea.l $fb(a4)
        pea.l $fb(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000008B4:
; H007+$000008B4: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000008BA:
; H007+$000008BA: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_000008BE:
; H007+$000008BE: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_000008C2:
; H007+$000008C2: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_000008C6:
; H007+$000008C6: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000008C8:
; H007+$000008C8: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L007_000008CC:
; H007+$000008CC: 486c010b  pea.l $10b(a4)
        pea.l $10b(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000008D0:
; H007+$000008D0: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000008D6:
; H007+$000008D6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_000008DA:
; H007+$000008DA: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_000008DE:
; H007+$000008DE: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_000008E2:
; H007+$000008E2: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000008E4:
; H007+$000008E4: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L007_000008E8:
; H007+$000008E8: 486c0119  pea.l $119(a4)
        pea.l $119(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000008EC:
; H007+$000008EC: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000008F2:
; H007+$000008F2: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_000008F6:
; H007+$000008F6: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L007_000008FA:
; H007+$000008FA: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_000008FE:
; H007+$000008FE: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000900:
; H007+$00000900: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L007_00000904:
; H007+$00000904: 486c0127  pea.l $127(a4)
        pea.l $127(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000908:
; H007+$00000908: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000090E:
; H007+$0000090E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_00000912:
; H007+$00000912: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L007_00000916:
; H007+$00000916: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_0000091A:
; H007+$0000091A: 4267  clr.w -(a7)
        clr.w -(a7)
L007_0000091C:
; H007+$0000091C: 3f3c0025  move.w #$25, -(a7)
        move.w #$25, -(a7)
L007_00000920:
; H007+$00000920: 486c0149  pea.l $149(a4)
        pea.l $149(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000924:
; H007+$00000924: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000092A:
; H007+$0000092A: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_0000092E:
; H007+$0000092E: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L007_00000932:
; H007+$00000932: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_00000936:
; H007+$00000936: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000938:
; H007+$00000938: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L007_0000093C:
; H007+$0000093C: 486c016f  pea.l $16f(a4)
        pea.l $16f(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000940:
; H007+$00000940: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000946:
; H007+$00000946: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_0000094A:
; H007+$0000094A: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L007_0000094E:
; H007+$0000094E: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_00000952:
; H007+$00000952: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000954:
; H007+$00000954: 3f3c001a  move.w #$1a, -(a7)
        move.w #$1a, -(a7)
L007_00000958:
; H007+$00000958: 486c0179  pea.l $179(a4)
        pea.l $179(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_0000095C:
; H007+$0000095C: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_00000962:
; H007+$00000962: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_00000966:
; H007+$00000966: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L007_0000096A:
; H007+$0000096A: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_0000096E:
; H007+$0000096E: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000970:
; H007+$00000970: 3f3c0021  move.w #$21, -(a7)
        move.w #$21, -(a7)
L007_00000974:
; H007+$00000974: 486c0194  pea.l $194(a4)
        pea.l $194(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000978:
; H007+$00000978: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000097E:
; H007+$0000097E: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_00000982:
; H007+$00000982: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_00000986:
; H007+$00000986: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_0000098A:
; H007+$0000098A: 4267  clr.w -(a7)
        clr.w -(a7)
L007_0000098C:
; H007+$0000098C: 3f3c0024  move.w #$24, -(a7)
        move.w #$24, -(a7)
L007_00000990:
; H007+$00000990: 486c01b6  pea.l $1b6(a4)
        pea.l $1b6(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_00000994:
; H007+$00000994: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_0000099A:
; H007+$0000099A: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L007_0000099E:
; H007+$0000099E: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L007_000009A2:
; H007+$000009A2: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L007_000009A6:
; H007+$000009A6: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000009A8:
; H007+$000009A8: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_000009AC:
; H007+$000009AC: 486c01db  pea.l $1db(a4)
        pea.l $1db(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000009B0:
; H007+$000009B0: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000009B6:
; H007+$000009B6: 3f3c0014  move.w #$14, -(a7)
        move.w #$14, -(a7)
L007_000009BA:
; H007+$000009BA: 3f3c0016  move.w #$16, -(a7)
        move.w #$16, -(a7)
L007_000009BE:
; H007+$000009BE: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L007_000009C2:
; H007+$000009C2: 4267  clr.w -(a7)
        clr.w -(a7)
L007_000009C4:
; H007+$000009C4: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L007_000009C8:
; H007+$000009C8: 486c01ea  pea.l $1ea(a4)
        pea.l $1ea(a4)
; FLUSSO: Chiama UI_DrawText (H030+$0256).
L007_000009CC:
; H007+$000009CC: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L007_000009D2:
; H007+$000009D2: 4e5d  unlk a5
        unlk a5
L007_000009D4:
; H007+$000009D4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_000009D6:
; H007+$000009D6: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Intro_LoadAndShow [verificato]
; Scopo: Gestisce schermate introduttive, risorse LBM e avvio dell’audio.
;   - Inizializza il sottosistema sonoro.
;   - Verifica la disponibilità del disco richiesto.
;   - Carica scrn1b.LBM, scrn2.LBM, text1.LBM e text2.LBM attraverso H007+$04F2.
;   - Visualizza schermate/crediti e attende gli eventi previsti dal flusso.
; Chiamanti diretti: H001+$0112, H001+$0232
; --------------------------------------------------------------------------
L007_000009D8:
; H007+$000009D8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L007_000009DA:
; H007+$000009DA: 287af8e0  movea.l $2bc(pc), a4
        movea.l H007+$2BC(pc), a4
L007_000009DE:
; H007+$000009DE: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L007_000009E2:
; H007+$000009E2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L007_000009E6:
; H007+$000009E6: 6100fc66  bsr.w $64e
        bsr.w H007+$64E
L007_000009EA:
; H007+$000009EA: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
; FLUSSO: Chiama Audio_Initialize (H043+$0584).
L007_000009EE:
; H007+$000009EE: 4eb900000584  jsr $584.l
        jsr (H043+$584).l
L007_000009F4:
; H007+$000009F4: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L007_000009F8:
; H007+$000009F8: 660001b0  bne.w $baa
        bne.w H007+$BAA
L007_000009FC:
; H007+$000009FC: 4879000027bc  pea.l $27bc.l
        pea.l (H005+$27BC).l
; FLUSSO: Chiama Free_Sequence (H042+$0300).
L007_00000A02:
; H007+$00000A02: 4eb900000300  jsr $300.l
        jsr (H042+$300).l
L007_00000A08:
; H007+$00000A08: 2f3c00000008  move.l #$8, -(a7)
        move.l #$8, -(a7)
L007_00000A0E:
; H007+$00000A0E: 2f3c00010002  move.l #$10002, -(a7)
        move.l #$10002, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L007_00000A14:
; H007+$00000A14: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L007_00000A1A:
; H007+$00000A1A: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
; STATO: H005+$52F6 = puntatore alla finestra del gioco
L007_00000A1E:
; H007+$00000A1E: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
L007_00000A24:
; H007+$00000A24: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L007_00000A28:
; H007+$00000A28: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L007_00000A2C:
; H007+$00000A2C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L007_00000A30:
; H007+$00000A30: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000A32:
; H007+$00000A32: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H021+$02EE (wrapper_SetPointer)
L007_00000A34:
; H007+$00000A34: 4eb9000002ee  jsr $2ee.l
        jsr (H021+$2EE).l
L007_00000A3A:
; H007+$00000A3A: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L007_00000A3E:
; H007+$00000A3E: 486c01f8  pea.l $1f8(a4)
        pea.l $1f8(a4)
L007_00000A42:
; H007+$00000A42: 3f3c001c  move.w #$1c, -(a7)
        move.w #$1c, -(a7)
L007_00000A46:
; H007+$00000A46: 486c0203  pea.l $203(a4)
        pea.l $203(a4)
L007_00000A4A:
; H007+$00000A4A: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L007_00000A4E:
; H007+$00000A4E: 486cff8e  pea.l -$72(a4)
        pea.l -$72(a4)
; FLUSSO: Chiama Open_ResourceFile (H028+$05FA).
L007_00000A52:
; H007+$00000A52: 4eb9000005fa  jsr $5fa.l
        jsr (H028+$5FA).l
L007_00000A58:
; H007+$00000A58: 1940ff93  move.b d0, -$6d(a4)
        move.b d0, -$6d(a4)
L007_00000A5C:
; H007+$00000A5C: 2f2cff8e  move.l -$72(a4), -(a7)
        move.l -$72(a4), -(a7)
; -> H002+$0014 (wrapper_Close)
L007_00000A60:
; H007+$00000A60: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L007_00000A66:
; H007+$00000A66: 0c39000200003d79  cmpi.b #$2, $3d79.l
        cmpi.b #$2, (H005+$3D79).l
L007_00000A6E:
; H007+$00000A6E: 6700000c  beq.w $a7c
        beq.w H007+$A7C
L007_00000A72:
; H007+$00000A72: 3f3c0017  move.w #$17, -(a7)
        move.w #$17, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L007_00000A76:
; H007+$00000A76: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L007_00000A7C:
; H007+$00000A7C: 6100fa22  bsr.w $4a0
        bsr.w H007+$4A0
L007_00000A80:
; H007+$00000A80: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L007_00000A84:
; H007+$00000A84: 0c6d0003fffc  cmpi.w #$3, -$4(a5)
        cmpi.w #$3, -$4(a5)
L007_00000A8A:
; H007+$00000A8A: 67000102  beq.w $b8e
        beq.w H007+$B8E
L007_00000A8E:
; H007+$00000A8E: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L007_00000A92:
; H007+$00000A92: 660000fa  bne.w $b8e
        bne.w H007+$B8E
L007_00000A96:
; H007+$00000A96: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L007_00000A9A:
; H007+$00000A9A: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L007_00000A9E:
; H007+$00000A9E: 6600002e  bne.w $ace
        bne.w H007+$ACE
L007_00000AA2:
; H007+$00000AA2: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000AA4:
; H007+$00000AA4: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000AA6:
; H007+$00000AA6: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L007_00000AAA:
; H007+$00000AAA: 3f3c00c8  move.w #$c8, -(a7)
        move.w #$c8, -(a7)
L007_00000AAE:
; H007+$00000AAE: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L007_00000AB2:
; H007+$00000AB2: 486c0220  pea.l $220(a4)
        pea.l $220(a4)
L007_00000AB6:
; H007+$00000AB6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L007_00000ABA:
; H007+$00000ABA: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; FLUSSO: Chiama Intro_LoadLBM (H007+$04F2).
L007_00000ABE:
; H007+$00000ABE: 6100fa32  bsr.w $4f2
        bsr.w H007+$4F2
L007_00000AC2:
; H007+$00000AC2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000AC6:
; H007+$00000AC6: 6100fb86  bsr.w $64e
        bsr.w H007+$64E
L007_00000ACA:
; H007+$00000ACA: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L007_00000ACE:
; H007+$00000ACE: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L007_00000AD2:
; H007+$00000AD2: 6600002e  bne.w $b02
        bne.w H007+$B02
L007_00000AD6:
; H007+$00000AD6: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000AD8:
; H007+$00000AD8: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000ADA:
; H007+$00000ADA: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L007_00000ADE:
; H007+$00000ADE: 3f3c00c8  move.w #$c8, -(a7)
        move.w #$c8, -(a7)
L007_00000AE2:
; H007+$00000AE2: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L007_00000AE6:
; H007+$00000AE6: 486c022b  pea.l $22b(a4)
        pea.l $22b(a4)
L007_00000AEA:
; H007+$00000AEA: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L007_00000AEE:
; H007+$00000AEE: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; FLUSSO: Chiama Intro_LoadLBM (H007+$04F2).
L007_00000AF2:
; H007+$00000AF2: 6100f9fe  bsr.w $4f2
        bsr.w H007+$4F2
L007_00000AF6:
; H007+$00000AF6: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000AFA:
; H007+$00000AFA: 6100fb52  bsr.w $64e
        bsr.w H007+$64E
L007_00000AFE:
; H007+$00000AFE: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L007_00000B02:
; H007+$00000B02: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L007_00000B06:
; H007+$00000B06: 6600002e  bne.w $b36
        bne.w H007+$B36
L007_00000B0A:
; H007+$00000B0A: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L007_00000B0E:
; H007+$00000B0E: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L007_00000B12:
; H007+$00000B12: 3f3c00f0  move.w #$f0, -(a7)
        move.w #$f0, -(a7)
L007_00000B16:
; H007+$00000B16: 3f3c0058  move.w #$58, -(a7)
        move.w #$58, -(a7)
L007_00000B1A:
; H007+$00000B1A: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L007_00000B1E:
; H007+$00000B1E: 486c0235  pea.l $235(a4)
        pea.l $235(a4)
L007_00000B22:
; H007+$00000B22: 4227  clr.b -(a7)
        clr.b -(a7)
L007_00000B24:
; H007+$00000B24: 4227  clr.b -(a7)
        clr.b -(a7)
; FLUSSO: Chiama Intro_LoadLBM (H007+$04F2).
L007_00000B26:
; H007+$00000B26: 6100f9ca  bsr.w $4f2
        bsr.w H007+$4F2
L007_00000B2A:
; H007+$00000B2A: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000B2E:
; H007+$00000B2E: 6100fb1e  bsr.w $64e
        bsr.w H007+$64E
L007_00000B32:
; H007+$00000B32: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L007_00000B36:
; H007+$00000B36: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L007_00000B3A:
; H007+$00000B3A: 6600002c  bne.w $b68
        bne.w H007+$B68
L007_00000B3E:
; H007+$00000B3E: 4267  clr.w -(a7)
        clr.w -(a7)
L007_00000B40:
; H007+$00000B40: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L007_00000B44:
; H007+$00000B44: 3f3c0140  move.w #$140, -(a7)
        move.w #$140, -(a7)
L007_00000B48:
; H007+$00000B48: 3f3c0058  move.w #$58, -(a7)
        move.w #$58, -(a7)
L007_00000B4C:
; H007+$00000B4C: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L007_00000B50:
; H007+$00000B50: 486c023f  pea.l $23f(a4)
        pea.l $23f(a4)
L007_00000B54:
; H007+$00000B54: 4227  clr.b -(a7)
        clr.b -(a7)
L007_00000B56:
; H007+$00000B56: 4227  clr.b -(a7)
        clr.b -(a7)
; FLUSSO: Chiama Intro_LoadLBM (H007+$04F2).
L007_00000B58:
; H007+$00000B58: 6100f998  bsr.w $4f2
        bsr.w H007+$4F2
L007_00000B5C:
; H007+$00000B5C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000B60:
; H007+$00000B60: 6100faec  bsr.w $64e
        bsr.w H007+$64E
L007_00000B64:
; H007+$00000B64: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L007_00000B68:
; H007+$00000B68: 4a2dffff  tst.b -$1(a5)
        tst.b -$1(a5)
L007_00000B6C:
; H007+$00000B6C: 6600001c  bne.w $b8a
        bne.w H007+$B8A
L007_00000B70:
; H007+$00000B70: 4227  clr.b -(a7)
        clr.b -(a7)
L007_00000B72:
; H007+$00000B72: 6100f856  bsr.w $3ca
        bsr.w H007+$3CA
L007_00000B76:
; H007+$00000B76: 6100fb3c  bsr.w $6b4
        bsr.w H007+$6B4
L007_00000B7A:
; H007+$00000B7A: 6100fb6e  bsr.w $6ea
        bsr.w H007+$6EA
L007_00000B7E:
; H007+$00000B7E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L007_00000B82:
; H007+$00000B82: 6100faca  bsr.w $64e
        bsr.w H007+$64E
L007_00000B86:
; H007+$00000B86: 1b40ffff  move.b d0, -$1(a5)
        move.b d0, -$1(a5)
L007_00000B8A:
; H007+$00000B8A: 6000fef8  bra.w $a84
        bra.w H007+$A84
; STATO: H005+$52F6 = puntatore alla finestra del gioco
L007_00000B8E:
; H007+$00000B8E: 2f39000052f6  move.l $52f6.l, -(a7)
        move.l (H005+$52F6).l, -(a7)
; -> H021+$0230 (wrapper_ClearPointer)
L007_00000B94:
; H007+$00000B94: 4eb900000230  jsr $230.l
        jsr (H021+$230).l
L007_00000B9A:
; H007+$00000B9A: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L007_00000B9E:
; H007+$00000B9E: 2f3c00000008  move.l #$8, -(a7)
        move.l #$8, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L007_00000BA4:
; H007+$00000BA4: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L007_00000BAA:
; H007+$00000BAA: 6100fb08  bsr.w $6b4
        bsr.w H007+$6B4
; -> H011+$010C (sub_H011_0000010C)
L007_00000BAE:
; H007+$00000BAE: 4eb90000010c  jsr $10c.l
        jsr (H011+$10C).l
L007_00000BB4:
; H007+$00000BB4: 3f3c00fe  move.w #$fe, -(a7)
        move.w #$fe, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L007_00000BB8:
; H007+$00000BB8: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L007_00000BBE:
; H007+$00000BBE: 3f3c00fd  move.w #$fd, -(a7)
        move.w #$fd, -(a7)
; FLUSSO: Chiama Audio_Command (H043+$190E).
L007_00000BC2:
; H007+$00000BC2: 4eb90000190e  jsr $190e.l
        jsr (H043+$190E).l
L007_00000BC8:
; H007+$00000BC8: 13fc0001000024c9  move.b #$1, $24c9.l
        move.b #$1, (H005+$24C9).l
L007_00000BD0:
; H007+$00000BD0: 4e5d  unlk a5
        unlk a5
L007_00000BD2:
; H007+$00000BD2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_00000BD4:
; H007+$00000BD4: 4e75  rts 
        rts 
L007_00000BD6:
; H007+$00000BD6: 4e5d  unlk a5
        unlk a5
L007_00000BD8:
; H007+$00000BD8: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L007_00000BDA:
; H007+$00000BDA: 4e75  rts 
        rts 
; End H007: $BDC bytes
