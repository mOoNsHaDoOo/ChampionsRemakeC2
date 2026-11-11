; ============================================================================
; GUIDA DEL MODULO H046
; servizi di messaggistica/menu e helper UI.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Servizi di messaggistica/menu e helper UI. Il modulo usa una tabella di dispatch per i tipi di messaggio.
; --------------------------------------------------------------------------
; H046: 724 original bytes; all offsets are section-relative.
        section H046,code
H046:
; Preserved bytes H046+$00000000..$00000004; code/data not fully classified.
        dc.l H046+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H046 [parziale]
; Scopo: Ingresso del modulo servizi di messaggistica/menu e helper UI; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H046+$02CC.
; Chiamanti diretti: H000+$0198
; --------------------------------------------------------------------------
L046_00000004:
; H046+$00000004: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L046_00000006:
; H046+$00000006: 287afff8  movea.l $0(pc), a4
        movea.l H046+$0(pc), a4
L046_0000000A:
; H046+$0000000A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L046_0000000E:
; H046+$0000000E: 600002bc  bra.w $2cc
        bra.w H046+$2CC
; --------------------------------------------------------------------------
; ROUTINE: sub_H046_00000012 [parziale]
; Scopo: Routine del modulo servizi di messaggistica/menu e helper UI; logica locale, nessuna chiamata esterna raggiunta.
;   - Esegue operazioni locali sui dati o sullo stato del modulo.
; Chiamanti diretti: H008+$0958, H008+$08A4, H008+$0EFC, H008+$0E3A
; --------------------------------------------------------------------------
L046_00000012:
; H046+$00000012: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L046_00000014:
; H046+$00000014: 287affea  movea.l $0(pc), a4
        movea.l H046+$0(pc), a4
L046_00000018:
; H046+$00000018: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L046_0000001C:
; H046+$0000001C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L046_00000020:
; H046+$00000020: 946d0012  sub.w $12(a5), d2
        sub.w $12(a5), d2
L046_00000024:
; H046+$00000024: 4a42  tst.w d2
        tst.w d2
L046_00000026:
; H046+$00000026: 6c02  bge.b $2a
        bge.b H046+$2A
L046_00000028:
; H046+$00000028: 4442  neg.w d2
        neg.w d2
L046_0000002A:
; H046+$0000002A: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L046_0000002E:
; H046+$0000002E: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L046_00000032:
; H046+$00000032: 946d0010  sub.w $10(a5), d2
        sub.w $10(a5), d2
L046_00000036:
; H046+$00000036: 4a42  tst.w d2
        tst.w d2
L046_00000038:
; H046+$00000038: 6c02  bge.b $3c
        bge.b H046+$3C
L046_0000003A:
; H046+$0000003A: 4442  neg.w d2
        neg.w d2
L046_0000003C:
; H046+$0000003C: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L046_00000040:
; H046+$00000040: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L046_00000044:
; H046+$00000044: 422dfffd  clr.b -$3(a5)
        clr.b -$3(a5)
L046_00000048:
; H046+$00000048: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L046_0000004C:
; H046+$0000004C: 6600026c  bne.w $2ba
        bne.w H046+$2BA
L046_00000050:
; H046+$00000050: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L046_00000054:
; H046+$00000054: 6000023e  bra.w $294
        bra.w H046+$294
L046_00000058:
; H046+$00000058: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L046_0000005C:
; H046+$0000005C: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L046_00000060:
; H046+$00000060: 6e00001c  bgt.w $7e
        bgt.w H046+$7E
L046_00000064:
; H046+$00000064: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_00000068:
; H046+$00000068: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L046_0000006C:
; H046+$0000006C: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_00000070:
; H046+$00000070: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_00000074:
; H046+$00000074: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_00000076:
; H046+$00000076: 6d000006  blt.w $7e
        blt.w H046+$7E
L046_0000007A:
; H046+$0000007A: 7401  moveq #$1, d2
        moveq #1, d2
L046_0000007C:
; H046+$0000007C: 6002  bra.b $80
        bra.b H046+$80
L046_0000007E:
; H046+$0000007E: 7400  moveq #$0, d2
        moveq #0, d2
L046_00000080:
; H046+$00000080: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_00000084:
; H046+$00000084: 1b7c0048fffc  move.b #$48, -$4(a5)
        move.b #$48, -$4(a5)
L046_0000008A:
; H046+$0000008A: 4e75  rts 
        rts 
L046_0000008C:
; H046+$0000008C: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L046_00000090:
; H046+$00000090: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L046_00000094:
; H046+$00000094: 6d00001c  blt.w $b2
        blt.w H046+$B2
L046_00000098:
; H046+$00000098: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_0000009C:
; H046+$0000009C: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L046_000000A0:
; H046+$000000A0: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_000000A4:
; H046+$000000A4: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_000000A8:
; H046+$000000A8: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_000000AA:
; H046+$000000AA: 6e000006  bgt.w $b2
        bgt.w H046+$B2
L046_000000AE:
; H046+$000000AE: 7401  moveq #$1, d2
        moveq #1, d2
L046_000000B0:
; H046+$000000B0: 6002  bra.b $b4
        bra.b H046+$B4
L046_000000B2:
; H046+$000000B2: 7400  moveq #$0, d2
        moveq #0, d2
L046_000000B4:
; H046+$000000B4: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_000000B8:
; H046+$000000B8: 1b7c004dfffc  move.b #$4d, -$4(a5)
        move.b #$4d, -$4(a5)
L046_000000BE:
; H046+$000000BE: 4e75  rts 
        rts 
L046_000000C0:
; H046+$000000C0: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L046_000000C4:
; H046+$000000C4: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L046_000000C8:
; H046+$000000C8: 6d00001c  blt.w $e6
        blt.w H046+$E6
L046_000000CC:
; H046+$000000CC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_000000D0:
; H046+$000000D0: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L046_000000D4:
; H046+$000000D4: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_000000D8:
; H046+$000000D8: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_000000DC:
; H046+$000000DC: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_000000DE:
; H046+$000000DE: 6d000006  blt.w $e6
        blt.w H046+$E6
L046_000000E2:
; H046+$000000E2: 7401  moveq #$1, d2
        moveq #1, d2
L046_000000E4:
; H046+$000000E4: 6002  bra.b $e8
        bra.b H046+$E8
L046_000000E6:
; H046+$000000E6: 7400  moveq #$0, d2
        moveq #0, d2
L046_000000E8:
; H046+$000000E8: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_000000EC:
; H046+$000000EC: 1b7c0050fffc  move.b #$50, -$4(a5)
        move.b #$50, -$4(a5)
L046_000000F2:
; H046+$000000F2: 4e75  rts 
        rts 
L046_000000F4:
; H046+$000000F4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L046_000000F8:
; H046+$000000F8: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L046_000000FC:
; H046+$000000FC: 6e00001c  bgt.w $11a
        bgt.w H046+$11A
L046_00000100:
; H046+$00000100: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_00000104:
; H046+$00000104: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L046_00000108:
; H046+$00000108: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_0000010C:
; H046+$0000010C: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_00000110:
; H046+$00000110: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_00000112:
; H046+$00000112: 6e000006  bgt.w $11a
        bgt.w H046+$11A
L046_00000116:
; H046+$00000116: 7401  moveq #$1, d2
        moveq #1, d2
L046_00000118:
; H046+$00000118: 6002  bra.b $11c
        bra.b H046+$11C
L046_0000011A:
; H046+$0000011A: 7400  moveq #$0, d2
        moveq #0, d2
L046_0000011C:
; H046+$0000011C: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_00000120:
; H046+$00000120: 1b7c004bfffc  move.b #$4b, -$4(a5)
        move.b #$4b, -$4(a5)
L046_00000126:
; H046+$00000126: 4e75  rts 
        rts 
L046_00000128:
; H046+$00000128: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L046_0000012C:
; H046+$0000012C: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L046_00000130:
; H046+$00000130: 6c00003e  bge.w $170
        bge.w H046+$170
L046_00000134:
; H046+$00000134: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L046_00000138:
; H046+$00000138: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L046_0000013C:
; H046+$0000013C: 6f000032  ble.w $170
        ble.w H046+$170
L046_00000140:
; H046+$00000140: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_00000144:
; H046+$00000144: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L046_00000148:
; H046+$00000148: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_0000014C:
; H046+$0000014C: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_00000150:
; H046+$00000150: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_00000152:
; H046+$00000152: 6e00001c  bgt.w $170
        bgt.w H046+$170
L046_00000156:
; H046+$00000156: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_0000015A:
; H046+$0000015A: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L046_0000015E:
; H046+$0000015E: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_00000162:
; H046+$00000162: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_00000166:
; H046+$00000166: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_00000168:
; H046+$00000168: 6d000006  blt.w $170
        blt.w H046+$170
L046_0000016C:
; H046+$0000016C: 7401  moveq #$1, d2
        moveq #1, d2
L046_0000016E:
; H046+$0000016E: 6002  bra.b $172
        bra.b H046+$172
L046_00000170:
; H046+$00000170: 7400  moveq #$0, d2
        moveq #0, d2
L046_00000172:
; H046+$00000172: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_00000176:
; H046+$00000176: 1b7c0049fffc  move.b #$49, -$4(a5)
        move.b #$49, -$4(a5)
L046_0000017C:
; H046+$0000017C: 4e75  rts 
        rts 
L046_0000017E:
; H046+$0000017E: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L046_00000182:
; H046+$00000182: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L046_00000186:
; H046+$00000186: 6f00003e  ble.w $1c6
        ble.w H046+$1C6
L046_0000018A:
; H046+$0000018A: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L046_0000018E:
; H046+$0000018E: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L046_00000192:
; H046+$00000192: 6f000032  ble.w $1c6
        ble.w H046+$1C6
L046_00000196:
; H046+$00000196: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_0000019A:
; H046+$0000019A: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L046_0000019E:
; H046+$0000019E: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_000001A2:
; H046+$000001A2: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_000001A6:
; H046+$000001A6: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_000001A8:
; H046+$000001A8: 6e00001c  bgt.w $1c6
        bgt.w H046+$1C6
L046_000001AC:
; H046+$000001AC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_000001B0:
; H046+$000001B0: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L046_000001B4:
; H046+$000001B4: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_000001B8:
; H046+$000001B8: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_000001BC:
; H046+$000001BC: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_000001BE:
; H046+$000001BE: 6d000006  blt.w $1c6
        blt.w H046+$1C6
L046_000001C2:
; H046+$000001C2: 7401  moveq #$1, d2
        moveq #1, d2
L046_000001C4:
; H046+$000001C4: 6002  bra.b $1c8
        bra.b H046+$1C8
L046_000001C6:
; H046+$000001C6: 7400  moveq #$0, d2
        moveq #0, d2
L046_000001C8:
; H046+$000001C8: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_000001CC:
; H046+$000001CC: 1b7c0051fffc  move.b #$51, -$4(a5)
        move.b #$51, -$4(a5)
L046_000001D2:
; H046+$000001D2: 4e75  rts 
        rts 
L046_000001D4:
; H046+$000001D4: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L046_000001D8:
; H046+$000001D8: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L046_000001DC:
; H046+$000001DC: 6f00003e  ble.w $21c
        ble.w H046+$21C
L046_000001E0:
; H046+$000001E0: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L046_000001E4:
; H046+$000001E4: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L046_000001E8:
; H046+$000001E8: 6c000032  bge.w $21c
        bge.w H046+$21C
L046_000001EC:
; H046+$000001EC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_000001F0:
; H046+$000001F0: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L046_000001F4:
; H046+$000001F4: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_000001F8:
; H046+$000001F8: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_000001FC:
; H046+$000001FC: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_000001FE:
; H046+$000001FE: 6e00001c  bgt.w $21c
        bgt.w H046+$21C
L046_00000202:
; H046+$00000202: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_00000206:
; H046+$00000206: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L046_0000020A:
; H046+$0000020A: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_0000020E:
; H046+$0000020E: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_00000212:
; H046+$00000212: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_00000214:
; H046+$00000214: 6d000006  blt.w $21c
        blt.w H046+$21C
L046_00000218:
; H046+$00000218: 7401  moveq #$1, d2
        moveq #1, d2
L046_0000021A:
; H046+$0000021A: 6002  bra.b $21e
        bra.b H046+$21E
L046_0000021C:
; H046+$0000021C: 7400  moveq #$0, d2
        moveq #0, d2
L046_0000021E:
; H046+$0000021E: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_00000222:
; H046+$00000222: 1b7c004ffffc  move.b #$4f, -$4(a5)
        move.b #$4f, -$4(a5)
L046_00000228:
; H046+$00000228: 4e75  rts 
        rts 
L046_0000022A:
; H046+$0000022A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L046_0000022E:
; H046+$0000022E: b46d0010  cmp.w $10(a5), d2
        cmp.w $10(a5), d2
L046_00000232:
; H046+$00000232: 6c00003e  bge.w $272
        bge.w H046+$272
L046_00000236:
; H046+$00000236: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L046_0000023A:
; H046+$0000023A: b46d0012  cmp.w $12(a5), d2
        cmp.w $12(a5), d2
L046_0000023E:
; H046+$0000023E: 6c000032  bge.w $272
        bge.w H046+$272
L046_00000242:
; H046+$00000242: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_00000246:
; H046+$00000246: c5fc026a  muls.w #$26a, d2
        muls.w #$26a, d2
L046_0000024A:
; H046+$0000024A: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_0000024E:
; H046+$0000024E: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_00000252:
; H046+$00000252: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_00000254:
; H046+$00000254: 6e00001c  bgt.w $272
        bgt.w H046+$272
L046_00000258:
; H046+$00000258: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L046_0000025C:
; H046+$0000025C: c5fc006a  muls.w #$6a, d2
        muls.w #$6a, d2
L046_00000260:
; H046+$00000260: 85fc0100  divs.w #$100, d2
        divs.w #$100, d2
L046_00000264:
; H046+$00000264: 382dfff8  move.w -$8(a5), d4
        move.w -$8(a5), d4
L046_00000268:
; H046+$00000268: b842  cmp.w d2, d4
        cmp.w d2, d4
L046_0000026A:
; H046+$0000026A: 6d000006  blt.w $272
        blt.w H046+$272
L046_0000026E:
; H046+$0000026E: 7401  moveq #$1, d2
        moveq #1, d2
L046_00000270:
; H046+$00000270: 6002  bra.b $274
        bra.b H046+$274
L046_00000272:
; H046+$00000272: 7400  moveq #$0, d2
        moveq #0, d2
L046_00000274:
; H046+$00000274: 1b42fffd  move.b d2, -$3(a5)
        move.b d2, -$3(a5)
L046_00000278:
; H046+$00000278: 1b7c0047fffc  move.b #$47, -$4(a5)
        move.b #$47, -$4(a5)
L046_0000027E:
; H046+$0000027E: 4e75  rts 
        rts 
L046_00000280:
; H046+$00000280: 4e75  rts 
        rts 
; Preserved bytes H046+$00000282..$00000294; code/data not fully classified.
        dc.w $FFFC,$FDD4,$FEA4,$FE08,$FEFA,$FE3C,$FF50,$FE70
        dc.w $FFA6
L046_00000294:
; H046+$00000294: 47faffee  lea.l $284(pc), a3
        lea.l H046+$284(pc), a3
L046_00000298:
; H046+$00000298: 0c420007  cmpi.w #$7, d2
        cmpi.w #$7, d2
L046_0000029C:
; H046+$0000029C: 6302  bls.b $2a0
        bls.b H046+$2A0
L046_0000029E:
; H046+$0000029E: 74ff  moveq #$ff, d2
        moveq #-1, d2
L046_000002A0:
; H046+$000002A0: e342  asl.w #$1, d2
        asl.w #$1, d2
L046_000002A2:
; H046+$000002A2: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: word relative a H046+$0284; indici 0..7, default -1.
L046_000002A6:
; H046+$000002A6: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L046_000002AA:
; H046+$000002AA: 4a2dfffd  tst.b -$3(a5)
        tst.b -$3(a5)
L046_000002AE:
; H046+$000002AE: 66000006  bne.w $2b6
        bne.w H046+$2B6
L046_000002B2:
; H046+$000002B2: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L046_000002B6:
; H046+$000002B6: 6000fd90  bra.w $48
        bra.w H046+$48
L046_000002BA:
; H046+$000002BA: 102dfffc  move.b -$4(a5), d0
        move.b -$4(a5), d0
L046_000002BE:
; H046+$000002BE: 60000002  bra.w $2c2
        bra.w H046+$2C2
L046_000002C2:
; H046+$000002C2: 4e5d  unlk a5
        unlk a5
L046_000002C4:
; H046+$000002C4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L046_000002C6:
; H046+$000002C6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L046_000002C8:
; H046+$000002C8: 508f  addq.l #$8, a7
        addq.l #$8, a7
L046_000002CA:
; H046+$000002CA: 4ed0  jmp (a0)
        jmp (a0)
L046_000002CC:
; H046+$000002CC: 4e5d  unlk a5
        unlk a5
L046_000002CE:
; H046+$000002CE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L046_000002D0:
; H046+$000002D0: 4e75  rts 
        rts 
; Preserved bytes H046+$000002D2..$000002D4; code/data not fully classified.
        dc.w $0000
; End H046: $2D4 bytes
