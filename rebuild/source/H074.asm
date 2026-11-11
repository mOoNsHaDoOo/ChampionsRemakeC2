; ============================================================================
; GUIDA DEL MODULO H074
; helper di percorso/nome file.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Helper di percorso/nome file: costruzione di nomi, estensioni e chiamate DOS.
; --------------------------------------------------------------------------
; H074: 1216 original bytes; all offsets are section-relative.
        section H074,code
H074:
; Preserved bytes H074+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H074+$00000004
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H074_04B0 [parziale]
; Scopo: Trampolino verso H074+$04B0; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H074+$04B0.
; Chiamanti diretti: H000+$0036
; --------------------------------------------------------------------------
L074_00000008:
; H074+$00000008: 4e550000  link.w a5, #$0
        link.w a5, #$0
L074_0000000C:
; H074+$0000000C: 600004a2  bra.w $4b0
        bra.w H074+$4B0
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H074_0092 [parziale]
; Scopo: Trampolino verso H074+$0092; il corpo effettivo è lì.
;   - Salta al corpo effettivo a H074+$0092.
; Chiamanti diretti: H074+$00B0
; --------------------------------------------------------------------------
L074_00000010:
; H074+$00000010: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L074_00000014:
; H074+$00000014: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L074_00000018:
; H074+$00000018: 4a13  tst.b (a3)
        tst.b (a3)
L074_0000001A:
; H074+$0000001A: 67000006  beq.w $22
        beq.w H074+$22
L074_0000001E:
; H074+$0000001E: 60000072  bra.w $92
        bra.w H074+$92
L074_00000022:
; H074+$00000022: 242b000a  move.l $a(a3), d2
        move.l $a(a3), d2
L074_00000026:
; H074+$00000026: b4ab0016  cmp.l $16(a3), d2
        cmp.l $16(a3), d2
L074_0000002A:
; H074+$0000002A: 6700001e  beq.w $4a
        beq.w H074+$4A
L074_0000002E:
; H074+$0000002E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L074_00000030:
; H074+$00000030: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L074_00000034:
; H074+$00000034: 2f2b0016  move.l $16(a3), -(a7)
        move.l $16(a3), -(a7)
L074_00000038:
; H074+$00000038: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H002+$0156 (wrapper_Seek)
L074_0000003E:
; H074+$0000003E: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L074_00000044:
; H074+$00000044: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_00000046:
; H074+$00000046: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L074_0000004A:
; H074+$0000004A: 242b0016  move.l $16(a3), d2
        move.l $16(a3), d2
L074_0000004E:
; H074+$0000004E: d4ab001e  add.l $1e(a3), d2
        add.l $1e(a3), d2
L074_00000052:
; H074+$00000052: 2742000a  move.l d2, $a(a3)
        move.l d2, $a(a3)
L074_00000056:
; H074+$00000056: 422b0022  clr.b $22(a3)
        clr.b $22(a3)
L074_0000005A:
; H074+$0000005A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L074_0000005C:
; H074+$0000005C: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L074_00000060:
; H074+$00000060: 2f2b000e  move.l $e(a3), -(a7)
        move.l $e(a3), -(a7)
L074_00000064:
; H074+$00000064: 2f2b001e  move.l $1e(a3), -(a7)
        move.l $1e(a3), -(a7)
; -> H002+$01CC (wrapper_Write)
L074_00000068:
; H074+$00000068: 4eb9000001cc  jsr $1cc.l
        jsr (H002+$1CC).l
L074_0000006E:
; H074+$0000006E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_00000070:
; H074+$00000070: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L074_00000074:
; H074+$00000074: 0cadfffffffffffc  cmpi.l #$ffffffff, -$4(a5)
        cmpi.l #$ffffffff, -$4(a5)
L074_0000007C:
; H074+$0000007C: 66000014  bne.w $92
        bne.w H074+$92
L074_00000080:
; H074+$00000080: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L074_00000084:
; H074+$00000084: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H002+$00C0 (wrapper_IoErr)
L074_00000086:
; H074+$00000086: 4eb9000000c0  jsr $c0.l
        jsr (H002+$C0).l
L074_0000008C:
; H074+$0000008C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_0000008E:
; H074+$0000008E: 27400002  move.l d0, $2(a3)
        move.l d0, $2(a3)
L074_00000092:
; H074+$00000092: 4e5d  unlk a5
        unlk a5
L074_00000094:
; H074+$00000094: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L074_00000096:
; H074+$00000096: 588f  addq.l #$4, a7
        addq.l #$4, a7
L074_00000098:
; H074+$00000098: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H074_0000009A [parziale]
; Scopo: Routine del modulo helper di percorso/nome file; richiama H002+$0156, H002+$0122, H002+$00C0.
;   - Richiama H002+$0156.
;   - Richiama H002+$0122.
;   - Richiama H002+$00C0.
; Chiamanti diretti: H074+$04A2
; --------------------------------------------------------------------------
L074_0000009A:
; H074+$0000009A: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L074_0000009E:
; H074+$0000009E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L074_000000A2:
; H074+$000000A2: 4a2b0022  tst.b $22(a3)
        tst.b $22(a3)
L074_000000A6:
; H074+$000000A6: 6700000e  beq.w $b6
        beq.w H074+$B6
L074_000000AA:
; H074+$000000AA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L074_000000AC:
; H074+$000000AC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L074_000000B0:
; H074+$000000B0: 6100ff5e  bsr.w $10
        bsr.w H074+$10
L074_000000B4:
; H074+$000000B4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_000000B6:
; H074+$000000B6: 4a13  tst.b (a3)
        tst.b (a3)
L074_000000B8:
; H074+$000000B8: 6700000a  beq.w $c4
        beq.w H074+$C4
L074_000000BC:
; H074+$000000BC: 42ab001a  clr.l $1a(a3)
        clr.l $1a(a3)
L074_000000C0:
; H074+$000000C0: 60000086  bra.w $148
        bra.w H074+$148
L074_000000C4:
; H074+$000000C4: 242b000a  move.l $a(a3), d2
        move.l $a(a3), d2
L074_000000C8:
; H074+$000000C8: b4ad0008  cmp.l $8(a5), d2
        cmp.l $8(a5), d2
L074_000000CC:
; H074+$000000CC: 6700001e  beq.w $ec
        beq.w H074+$EC
L074_000000D0:
; H074+$000000D0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L074_000000D2:
; H074+$000000D2: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L074_000000D6:
; H074+$000000D6: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L074_000000DA:
; H074+$000000DA: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H002+$0156 (wrapper_Seek)
L074_000000E0:
; H074+$000000E0: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L074_000000E6:
; H074+$000000E6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_000000E8:
; H074+$000000E8: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L074_000000EC:
; H074+$000000EC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L074_000000EE:
; H074+$000000EE: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L074_000000F2:
; H074+$000000F2: 2f2b000e  move.l $e(a3), -(a7)
        move.l $e(a3), -(a7)
L074_000000F6:
; H074+$000000F6: 2f2b0012  move.l $12(a3), -(a7)
        move.l $12(a3), -(a7)
; -> H002+$0122 (wrapper_Read)
L074_000000FA:
; H074+$000000FA: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L074_00000100:
; H074+$00000100: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_00000102:
; H074+$00000102: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L074_00000106:
; H074+$00000106: 0cadfffffffffffc  cmpi.l #$ffffffff, -$4(a5)
        cmpi.l #$ffffffff, -$4(a5)
L074_0000010E:
; H074+$0000010E: 6600001a  bne.w $12a
        bne.w H074+$12A
L074_00000112:
; H074+$00000112: 16bc0001  move.b #$1, (a3)
        move.b #$1, (a3)
L074_00000116:
; H074+$00000116: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H002+$00C0 (wrapper_IoErr)
L074_00000118:
; H074+$00000118: 4eb9000000c0  jsr $c0.l
        jsr (H002+$C0).l
L074_0000011E:
; H074+$0000011E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_00000120:
; H074+$00000120: 27400002  move.l d0, $2(a3)
        move.l d0, $2(a3)
L074_00000124:
; H074+$00000124: 2b6b0012fffc  move.l $12(a3), -$4(a5)
        move.l $12(a3), -$4(a5)
L074_0000012A:
; H074+$0000012A: 276d00080016  move.l $8(a5), $16(a3)
        move.l $8(a5), $16(a3)
L074_00000130:
; H074+$00000130: 7400  moveq #$0, d2
        moveq #0, d2
L074_00000132:
; H074+$00000132: 2742001a  move.l d2, $1a(a3)
        move.l d2, $1a(a3)
L074_00000136:
; H074+$00000136: 276dfffc001e  move.l -$4(a5), $1e(a3)
        move.l -$4(a5), $1e(a3)
L074_0000013C:
; H074+$0000013C: 242b0016  move.l $16(a3), d2
        move.l $16(a3), d2
L074_00000140:
; H074+$00000140: d4ab001e  add.l $1e(a3), d2
        add.l $1e(a3), d2
L074_00000144:
; H074+$00000144: 2742000a  move.l d2, $a(a3)
        move.l d2, $a(a3)
L074_00000148:
; H074+$00000148: 4e5d  unlk a5
        unlk a5
L074_0000014A:
; H074+$0000014A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L074_0000014C:
; H074+$0000014C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L074_0000014E:
; H074+$0000014E: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H074+$00000150..$00000450; code/data not fully classified.
        dc.w $4E55,$0000,$266D,$0008,$4A2B,$0022,$6700,$000E
        dc.w $2F0B,$2F2D,$0008,$6100,$FEA8,$265F,$2F0B,$2F2B
        dc.w $0006,$4EB9
        dc.l H002+$00000014
        dc.w $265F,$2F0B,$2F2B,$000E,$2F2B,$0012,$4EB9
        dc.l H003+$000000F6
        dc.w $265F,$4E5D,$205F,$588F,$4ED0,$4E55,$FFFE,$266D
        dc.w $0008,$2F0B,$4EB9
        dc.l H002+$0000004A
        dc.w $1B40,$FFFF,$4E5D,$205F,$5C8F,$4ED0,$4E55,$FFFC
        dc.w $266D,$0010,$4213,$422B,$0001,$7400,$2742,$0002
        dc.w $7400,$2742,$000A,$2779
        dc.l H074+$00000000
        dc.w $0012,$2F0B,$2F2B,$0012,$42A7,$4EB9
        dc.l H003+$00000068
        dc.w $265F,$2740,$000E,$7400,$2742,$0016,$7400,$2742
        dc.w $001A,$7400,$2742,$001E,$422B,$0022,$4AAB,$000E
        dc.w $6600,$000A,$16BC,$0002,$6000,$00A0,$4A2D,$0008
        dc.w $6700,$003A,$2F0B,$246D,$000A,$2F0A,$2F3C,$0000
        dc.w $03EE,$4EB9
        dc.l H002+$000000F2
        dc.w $265F,$2740,$0006,$4AAB,$0006,$6600,$0014,$16BC
        dc.w $0001,$2F0B,$4EB9
        dc.l H002+$000000C0
        dc.w $265F,$2740,$0002,$6000,$0048,$2F0B,$246D,$000A
        dc.w $2F0A,$2F3C,$0000,$03ED,$4EB9
        dc.l H002+$000000F2
        dc.w $265F,$2740,$0006,$4AAB,$0006,$6600,$0018,$16BC
        dc.w $0001,$2F0B,$4EB9
        dc.l H002+$000000C0
        dc.w $265F,$2740,$0002,$6000,$0010,$2F0B,$2F2D,$0010
        dc.w $42A7,$6100,$FE0C,$265F,$4A13,$6700,$0014,$2F0B
        dc.w $2F2B,$000E,$2F2B,$0012,$4EB9
        dc.l H003+$000000F6
        dc.w $265F,$4E5D,$205F,$4FEF,$000C,$4ED0,$4E55,$0000
        dc.w $266D,$000C,$242D,$0008,$B4AB,$0016,$6500,$0024
        dc.w $242B,$0016,$D4AB,$001E,$282D,$0008,$B882,$6400
        dc.w $0012,$242D,$0008,$94AB,$0016,$2742,$001A,$6000
        dc.w $0012,$2F0B,$2F2D,$000C,$2F2D,$0008,$6100,$FDA4
        dc.w $265F,$4E5D,$205F,$508F,$4ED0,$4E55,$0000,$266D
        dc.w $000C,$242B,$0016,$D4AB,$001A,$246D,$0008,$2482
        dc.w $4E5D,$205F,$508F,$4ED0,$4E55,$FFFC,$266D,$000C
        dc.w $242B,$001E,$B4AB,$0012,$6400,$0014,$242B,$0016
        dc.w $D4AB,$001E,$246D,$0008,$2482,$6000,$003A,$2F0B
        dc.w $2F2B,$0006,$42A7,$2F3C,$0000,$0001,$4EB9
        dc.l H002+$00000156
        dc.w $265F,$2B40,$FFFC,$2F0B,$2F2B,$0006,$2F2B,$000A
        dc.w $2F3C,$FFFF,$FFFF,$4EB9
        dc.l H002+$00000156
        dc.w $265F,$246D,$0008,$2480,$4E5D,$205F,$508F,$4ED0
        dc.w $4E55,$FFFE,$2F2D,$000C,$486D,$FFFE,$4EB9
        dc.l H074+$000003E4
        dc.w $2F2D,$000C,$486D,$FFFF,$4EB9
        dc.l H074+$000003E4
        dc.w $266D,$0008,$36AD,$FFFE,$4E5D,$205F,$508F,$4ED0
        dc.w $4E55,$FFFE,$3B6D,$0008,$FFFE,$2F2D,$000A,$1F2D
        dc.w $FFFE,$4EB9
        dc.l H074+$00000450
        dc.w $2F2D,$000A,$1F2D,$FFFF,$4EB9
        dc.l H074+$00000450
        dc.w $4E5D,$205F,$5C8F,$4ED0,$4E55,$FFFC,$266D,$000C
        dc.w $242B,$001A,$B4AB,$001E,$6400,$0042,$242B,$000E
        dc.w $D4AB,$001A,$2B42,$FFFC,$246D,$FFFC,$226D,$0008
        dc.w $1292,$52AB,$001A,$242B,$001A,$B4AB,$0012,$6600
        dc.w $0018,$2F0B,$2F2D,$000C,$242B,$0016,$D4AB,$001A
        dc.w $2F02,$6100,$FC6A,$265F,$6000,$0012,$16BC,$0001
        dc.w $177C,$0001,$0001,$246D,$0008,$4212,$4E5D,$205F
        dc.w $508F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H074_00000450 [parziale]
; Scopo: Routine del modulo helper di percorso/nome file; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H020+$089C, H020+$0846
; --------------------------------------------------------------------------
L074_00000450:
; H074+$00000450: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L074_00000454:
; H074+$00000454: 266d000a  movea.l $a(a5), a3
        movea.l $a(a5), a3
L074_00000458:
; H074+$00000458: 177c00010022  move.b #$1, $22(a3)
        move.b #$1, $22(a3)
L074_0000045E:
; H074+$0000045E: 242b000e  move.l $e(a3), d2
        move.l $e(a3), d2
L074_00000462:
; H074+$00000462: d4ab001a  add.l $1a(a3), d2
        add.l $1a(a3), d2
L074_00000466:
; H074+$00000466: 2b42fffc  move.l d2, -$4(a5)
        move.l d2, -$4(a5)
L074_0000046A:
; H074+$0000046A: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L074_0000046E:
; H074+$0000046E: 14ad0008  move.b $8(a5), (a2)
        move.b $8(a5), (a2)
L074_00000472:
; H074+$00000472: 242b001a  move.l $1a(a3), d2
        move.l $1a(a3), d2
L074_00000476:
; H074+$00000476: b4ab001e  cmp.l $1e(a3), d2
        cmp.l $1e(a3), d2
L074_0000047A:
; H074+$0000047A: 66000006  bne.w $482
        bne.w H074+$482
L074_0000047E:
; H074+$0000047E: 52ab001e  addq.l #$1, $1e(a3)
        addq.l #$1, $1e(a3)
L074_00000482:
; H074+$00000482: 52ab001a  addq.l #$1, $1a(a3)
        addq.l #$1, $1a(a3)
L074_00000486:
; H074+$00000486: 242b001a  move.l $1a(a3), d2
        move.l $1a(a3), d2
L074_0000048A:
; H074+$0000048A: b4ab0012  cmp.l $12(a3), d2
        cmp.l $12(a3), d2
L074_0000048E:
; H074+$0000048E: 66000018  bne.w $4a8
        bne.w H074+$4A8
L074_00000492:
; H074+$00000492: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L074_00000494:
; H074+$00000494: 2f2d000a  move.l $a(a5), -(a7)
        move.l $a(a5), -(a7)
L074_00000498:
; H074+$00000498: 242b0016  move.l $16(a3), d2
        move.l $16(a3), d2
L074_0000049C:
; H074+$0000049C: d4ab001a  add.l $1a(a3), d2
        add.l $1a(a3), d2
L074_000004A0:
; H074+$000004A0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L074_000004A2:
; H074+$000004A2: 6100fbf6  bsr.w $9a
        bsr.w H074+$9A
L074_000004A6:
; H074+$000004A6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L074_000004A8:
; H074+$000004A8: 4e5d  unlk a5
        unlk a5
L074_000004AA:
; H074+$000004AA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L074_000004AC:
; H074+$000004AC: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L074_000004AE:
; H074+$000004AE: 4ed0  jmp (a0)
        jmp (a0)
L074_000004B0:
; H074+$000004B0: 243c00000400  move.l #$400, d2
        move.l #$400, d2
L074_000004B6:
; H074+$000004B6: 23c200000000  move.l d2, $0.l
        move.l d2, (H074+$0).l
L074_000004BC:
; H074+$000004BC: 4e5d  unlk a5
        unlk a5
L074_000004BE:
; H074+$000004BE: 4e75  rts 
        rts 
; End H074: $4C0 bytes
