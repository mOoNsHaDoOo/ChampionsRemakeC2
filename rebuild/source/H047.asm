; ============================================================================
; MODULE GUIDE H047
; character icon editor (body, weapons, parts).
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; --------------------------------------------------------------------------
; MODULE NOTE
; Character icon editor: body parts, weapons, shields, colours and confirmation. The strings of the module are the menu entries ('Head', 'Weapon', 'Body', 'Shield', 'Arm', 'Leg', 'Exit').
; --------------------------------------------------------------------------
; H047: 5224 original bytes; all offsets are section-relative.
        section H047,code
H047:
; Preserved bytes H047+$00000000..$000000D8; code/data not fully classified.
        dc.w $0000,$4861,$6972,$0046,$6163,$6500,$4865,$6164
        dc.w $2057,$6561,$706F,$6E20,$4578,$6974,$0057,$6561
        dc.w $706F,$6E20,$426F,$6479,$2078,$7878,$7820,$5368
        dc.w $6965,$6C64,$2041,$726D,$204C,$6567,$2045,$7869
        dc.w $7400,$204B,$6565,$7020,$4578,$6974,$004E,$6578
        dc.w $7420,$5072,$6576,$204B,$6565,$7020,$4578,$6974
        dc.w $0044,$6F6E,$6500,$6F6C,$6400,$7265,$6164,$7920
        dc.w $2020,$6163,$7469,$6F6E,$006E,$6577,$0072,$6561
        dc.w $6479,$2020,$2061,$6374,$696F,$6E00,$426F,$6479
        dc.w $2053,$697A,$6520,$4578,$6974,$0050,$6172,$7473
        dc.w $2031,$7374,$2D63,$6F6C,$6F72,$2032,$6E64,$2D63
        dc.w $6F6C,$6F72,$2053,$697A,$6520,$4578,$6974,$0000
        dc.w $0049,$7320,$7468,$6973,$2069,$636F,$6E20,$6F6B
        dc.w $3F20,$0000
        dc.l H047+$00000002
; --------------------------------------------------------------------------
; ROUTINE: module_init_H047 [partial]
; Purpose: Entry of the character icon editor (body, weapons, parts) module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H047+$145E.
; Direct callers: H000+$01AA
; --------------------------------------------------------------------------
L047_000000D8:
; H047+$000000D8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L047_000000DA:
; H047+$000000DA: 287afff8  movea.l $d4(pc), a4
        movea.l H047+$D4(pc), a4
L047_000000DE:
; H047+$000000DE: 4e550000  link.w a5, #$0
        link.w a5, #$0
L047_000000E2:
; H047+$000000E2: 6000137a  bra.w $145e
        bra.w H047+$145E
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H047_08D6 [partial]
; Purpose: Trampoline to H047+$08D6; the actual body is there.
;   - Jumps to the actual body at H047+$08D6.
;   - Calls H044+$01C2.
;   - Calls H028+$0D36.
;   - Calls H022+$0084.
;   - Calls H066+$0C34.
;   - Calls H030+$0256.
;   - Calls H008+$01FC.
;   - Uses the global state: H005+$3DE3 (native context, 5 in combat); H005+$52F2 (pointer to the game screen); H005+$3368 (current character).
; Direct callers: H057+$2850, H013+$2A96
; --------------------------------------------------------------------------
L047_000000E6:
; H047+$000000E6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L047_000000E8:
; H047+$000000E8: 287affea  movea.l $d4(pc), a4
        movea.l H047+$D4(pc), a4
L047_000000EC:
; H047+$000000EC: 4e55fed6  link.w a5, #$fed6
        link.w a5, #$fed6
L047_000000F0:
; H047+$000000F0: 600007e4  bra.w $8d6
        bra.w H047+$8D6
; --------------------------------------------------------------------------
; ROUTINE: sub_H047_000000F4 [partial]
; Purpose: Routine of the character icon editor (body, weapons, parts) module; calls H035+$0460.
;   - Calls H035+$0460.
; Direct callers: H047+$09EA, H047+$0A7C
; --------------------------------------------------------------------------
L047_000000F4:
; H047+$000000F4: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L047_000000F8:
; H047+$000000F8: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L047_000000FC:
; H047+$000000FC: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L047_00000100:
; H047+$00000100: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000102:
; H047+$00000102: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000104:
; H047+$00000104: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L047_00000108:
; H047+$00000108: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L047_0000010E:
; H047+$0000010E: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_00000112:
; H047+$00000112: 5642  addq.w #$3, d2
        addq.w #$3, d2
L047_00000114:
; H047+$00000114: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_00000116:
; H047+$00000116: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L047_0000011A:
; H047+$0000011A: 4267  clr.w -(a7)
        clr.w -(a7)
L047_0000011C:
; H047+$0000011C: 4267  clr.w -(a7)
        clr.w -(a7)
L047_0000011E:
; H047+$0000011E: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L047_00000122:
; H047+$00000122: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L047_00000128:
; H047+$00000128: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L047_0000012C:
; H047+$0000012C: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L047_00000130:
; H047+$00000130: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000132:
; H047+$00000132: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000134:
; H047+$00000134: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L047_00000138:
; H047+$00000138: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L047_0000013E:
; H047+$0000013E: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_00000142:
; H047+$00000142: 5642  addq.w #$3, d2
        addq.w #$3, d2
L047_00000144:
; H047+$00000144: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_00000146:
; H047+$00000146: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L047_0000014A:
; H047+$0000014A: 4267  clr.w -(a7)
        clr.w -(a7)
L047_0000014C:
; H047+$0000014C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_00000150:
; H047+$00000150: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L047_00000154:
; H047+$00000154: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L047_0000015A:
; H047+$0000015A: 4e5d  unlk a5
        unlk a5
L047_0000015C:
; H047+$0000015C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L047_0000015E:
; H047+$0000015E: 508f  addq.l #$8, a7
        addq.l #$8, a7
L047_00000160:
; H047+$00000160: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H047_00000162 [partial]
; Purpose: Routine of the character icon editor (body, weapons, parts) module; works on H005+$3368 (current character).
;   - Uses the global state: H005+$3368 (current character).
; Direct callers: H047+$03FE, H047+$021E
; --------------------------------------------------------------------------
L047_00000162:
; H047+$00000162: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATE: H005+$3368 = current character
L047_00000166:
; H047+$00000166: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L047_0000016C:
; H047+$0000016C: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000170:
; H047+$00000170: 0c2a0048ffdb  cmpi.b #$48, -$25(a2)
        cmpi.b #$48, -$25(a2)
L047_00000176:
; H047+$00000176: 6600003a  bne.w $1b2
        bne.w H047+$1B2
L047_0000017A:
; H047+$0000017A: 7400  moveq #$0, d2
        moveq #0, d2
L047_0000017C:
; H047+$0000017C: 142b0141  move.b $141(a3), d2
        move.b $141(a3), d2
L047_00000180:
; H047+$00000180: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000184:
; H047+$00000184: 3542fed8  move.w d2, -$128(a2)
        move.w d2, -$128(a2)
L047_00000188:
; H047+$00000188: 7400  moveq #$0, d2
        moveq #0, d2
L047_0000018A:
; H047+$0000018A: 142b0144  move.b $144(a3), d2
        move.b $144(a3), d2
L047_0000018E:
; H047+$0000018E: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L047_00000192:
; H047+$00000192: 66000010  bne.w $1a4
        bne.w H047+$1A4
L047_00000196:
; H047+$00000196: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_0000019A:
; H047+$0000019A: 357c000bfeda  move.w #$b, -$126(a2)
        move.w #$b, -$126(a2)
L047_000001A0:
; H047+$000001A0: 6000000c  bra.w $1ae
        bra.w H047+$1AE
L047_000001A4:
; H047+$000001A4: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_000001A8:
; H047+$000001A8: 357c000dfeda  move.w #$d, -$126(a2)
        move.w #$d, -$126(a2)
L047_000001AE:
; H047+$000001AE: 60000036  bra.w $1e6
        bra.w H047+$1E6
L047_000001B2:
; H047+$000001B2: 7400  moveq #$0, d2
        moveq #0, d2
L047_000001B4:
; H047+$000001B4: 142b0144  move.b $144(a3), d2
        move.b $144(a3), d2
L047_000001B8:
; H047+$000001B8: 0c420001  cmpi.w #$1, d2
        cmpi.w #$1, d2
L047_000001BC:
; H047+$000001BC: 66000010  bne.w $1ce
        bne.w H047+$1CE
L047_000001C0:
; H047+$000001C0: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_000001C4:
; H047+$000001C4: 357c0024feda  move.w #$24, -$126(a2)
        move.w #$24, -$126(a2)
L047_000001CA:
; H047+$000001CA: 6000000c  bra.w $1d8
        bra.w H047+$1D8
L047_000001CE:
; H047+$000001CE: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_000001D2:
; H047+$000001D2: 357c0028feda  move.w #$28, -$126(a2)
        move.w #$28, -$126(a2)
L047_000001D8:
; H047+$000001D8: 7400  moveq #$0, d2
        moveq #0, d2
L047_000001DA:
; H047+$000001DA: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_000001DE:
; H047+$000001DE: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_000001E2:
; H047+$000001E2: 3542fed8  move.w d2, -$128(a2)
        move.w d2, -$128(a2)
L047_000001E6:
; H047+$000001E6: 4e5d  unlk a5
        unlk a5
L047_000001E8:
; H047+$000001E8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L047_000001EA:
; H047+$000001EA: 588f  addq.l #$4, a7
        addq.l #$4, a7
L047_000001EC:
; H047+$000001EC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H047_000001EE [partial]
; Purpose: Routine of the character icon editor (body, weapons, parts) module; works on H005+$2356 (mouse X coordinate); H005+$2354 (mouse Y coordinate).
;   - Uses the global state: H005+$2356 (mouse X coordinate); H005+$2354 (mouse Y coordinate).
; Direct callers: H047+$11C4
; --------------------------------------------------------------------------
L047_000001EE:
; H047+$000001EE: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
; STATE: H005+$2356 = mouse X coordinate
L047_000001F2:
; H047+$000001F2: 343900002356  move.w $2356.l, d2
        move.w (H005+$2356).l, d2
L047_000001F8:
; H047+$000001F8: 48c2  ext.l d2
        ext.l d2
L047_000001FA:
; H047+$000001FA: 85fc0018  divs.w #$18, d2
        divs.w #$18, d2
L047_000001FE:
; H047+$000001FE: 5d42  subq.w #$6, d2
        subq.w #$6, d2
L047_00000200:
; H047+$00000200: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L047_00000204:
; H047+$00000204: 3682  move.w d2, (a3)
        move.w d2, (a3)
; STATE: H005+$2354 = mouse Y coordinate
L047_00000206:
; H047+$00000206: 343900002354  move.w $2354.l, d2
        move.w (H005+$2354).l, d2
L047_0000020C:
; H047+$0000020C: 48c2  ext.l d2
        ext.l d2
L047_0000020E:
; H047+$0000020E: 85fc0018  divs.w #$18, d2
        divs.w #$18, d2
L047_00000212:
; H047+$00000212: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000214:
; H047+$00000214: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L047_00000218:
; H047+$00000218: 3682  move.w d2, (a3)
        move.w d2, (a3)
L047_0000021A:
; H047+$0000021A: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L047_0000021E:
; H047+$0000021E: 6100ff42  bsr.w $162
        bsr.w H047+$162
L047_00000222:
; H047+$00000222: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L047_00000226:
; H047+$00000226: 4a53  tst.w (a3)
        tst.w (a3)
L047_00000228:
; H047+$00000228: 6d000024  blt.w $24e
        blt.w H047+$24E
L047_0000022C:
; H047+$0000022C: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L047_00000230:
; H047+$00000230: 0c530006  cmpi.w #$6, (a3)
        cmpi.w #$6, (a3)
L047_00000234:
; H047+$00000234: 6e000018  bgt.w $24e
        bgt.w H047+$24E
L047_00000238:
; H047+$00000238: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L047_0000023C:
; H047+$0000023C: 4a53  tst.w (a3)
        tst.w (a3)
L047_0000023E:
; H047+$0000023E: 6d00000e  blt.w $24e
        blt.w H047+$24E
L047_00000242:
; H047+$00000242: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L047_00000246:
; H047+$00000246: 0c530006  cmpi.w #$6, (a3)
        cmpi.w #$6, (a3)
L047_0000024A:
; H047+$0000024A: 6f000018  ble.w $264
        ble.w H047+$264
L047_0000024E:
; H047+$0000024E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L047_00000252:
; H047+$00000252: 4253  clr.w (a3)
        clr.w (a3)
L047_00000254:
; H047+$00000254: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L047_00000258:
; H047+$00000258: 4253  clr.w (a3)
        clr.w (a3)
L047_0000025A:
; H047+$0000025A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L047_0000025E:
; H047+$0000025E: 4213  clr.b (a3)
        clr.b (a3)
L047_00000260:
; H047+$00000260: 60000092  bra.w $2f4
        bra.w H047+$2F4
L047_00000264:
; H047+$00000264: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L047_00000268:
; H047+$00000268: 3413  move.w (a3), d2
        move.w (a3), d2
L047_0000026A:
; H047+$0000026A: c5fc0007  muls.w #$7, d2
        muls.w #$7, d2
L047_0000026E:
; H047+$0000026E: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L047_00000272:
; H047+$00000272: d453  add.w (a3), d2
        add.w (a3), d2
L047_00000274:
; H047+$00000274: 5242  addq.w #$1, d2
        addq.w #$1, d2
L047_00000276:
; H047+$00000276: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L047_0000027A:
; H047+$0000027A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L047_0000027E:
; H047+$0000027E: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L047_00000282:
; H047+$00000282: b46bfeda  cmp.w -$126(a3), d2
        cmp.w -$126(a3), d2
L047_00000286:
; H047+$00000286: 6f000018  ble.w $2a0
        ble.w H047+$2A0
L047_0000028A:
; H047+$0000028A: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L047_0000028E:
; H047+$0000028E: 4253  clr.w (a3)
        clr.w (a3)
L047_00000290:
; H047+$00000290: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L047_00000294:
; H047+$00000294: 4253  clr.w (a3)
        clr.w (a3)
L047_00000296:
; H047+$00000296: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L047_0000029A:
; H047+$0000029A: 4213  clr.b (a3)
        clr.b (a3)
L047_0000029C:
; H047+$0000029C: 60000056  bra.w $2f4
        bra.w H047+$2F4
L047_000002A0:
; H047+$000002A0: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L047_000002A4:
; H047+$000002A4: 342bfed8  move.w -$128(a3), d2
        move.w -$128(a3), d2
L047_000002A8:
; H047+$000002A8: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_000002AA:
; H047+$000002AA: 48c2  ext.l d2
        ext.l d2
L047_000002AC:
; H047+$000002AC: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_000002B0:
; H047+$000002B0: 4842  swap d2
        swap d2
L047_000002B2:
; H047+$000002B2: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L047_000002B6:
; H047+$000002B6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L047_000002BA:
; H047+$000002BA: 342bfed8  move.w -$128(a3), d2
        move.w -$128(a3), d2
L047_000002BE:
; H047+$000002BE: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_000002C0:
; H047+$000002C0: 48c2  ext.l d2
        ext.l d2
L047_000002C2:
; H047+$000002C2: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_000002C6:
; H047+$000002C6: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L047_000002CA:
; H047+$000002CA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_000002CE:
; H047+$000002CE: 266d0014  movea.l $14(a5), a3
        movea.l $14(a5), a3
L047_000002D2:
; H047+$000002D2: 9553  sub.w d2, (a3)
        sub.w d2, (a3)
L047_000002D4:
; H047+$000002D4: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L047_000002D8:
; H047+$000002D8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L047_000002DC:
; H047+$000002DC: 9553  sub.w d2, (a3)
        sub.w d2, (a3)
L047_000002DE:
; H047+$000002DE: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L047_000002E2:
; H047+$000002E2: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L047_000002E6:
; H047+$000002E6: b46bfed8  cmp.w -$128(a3), d2
        cmp.w -$128(a3), d2
L047_000002EA:
; H047+$000002EA: 57c2  seq.b d2
        seq.b d2
L047_000002EC:
; H047+$000002EC: 4402  neg.b d2
        neg.b d2
L047_000002EE:
; H047+$000002EE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L047_000002F2:
; H047+$000002F2: 1682  move.b d2, (a3)
        move.b d2, (a3)
L047_000002F4:
; H047+$000002F4: 4e5d  unlk a5
        unlk a5
L047_000002F6:
; H047+$000002F6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L047_000002F8:
; H047+$000002F8: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L047_000002FC:
; H047+$000002FC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H047_000002FE [partial]
; Purpose: Routine of the character icon editor (body, weapons, parts) module; calls H035+$0460, H029+$10B8, H066+$0C34.
;   - Calls H035+$0460.
;   - Calls H029+$10B8.
;   - Calls H066+$0C34.
;   - Uses the global state: H005+$3368 (current character).
; Direct callers: H047+$061A, H047+$0636, H047+$05DE, H047+$065C, H047+$0678
; --------------------------------------------------------------------------
L047_000002FE:
; H047+$000002FE: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L047_00000302:
; H047+$00000302: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L047_00000306:
; H047+$00000306: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000308:
; H047+$00000308: 48c2  ext.l d2
        ext.l d2
L047_0000030A:
; H047+$0000030A: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_0000030E:
; H047+$0000030E: 4842  swap d2
        swap d2
L047_00000310:
; H047+$00000310: 5c42  addq.w #$6, d2
        addq.w #$6, d2
L047_00000312:
; H047+$00000312: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L047_00000316:
; H047+$00000316: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L047_0000031A:
; H047+$0000031A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_0000031C:
; H047+$0000031C: 48c2  ext.l d2
        ext.l d2
L047_0000031E:
; H047+$0000031E: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_00000322:
; H047+$00000322: 5242  addq.w #$1, d2
        addq.w #$1, d2
L047_00000324:
; H047+$00000324: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
; STATE: H005+$3368 = current character
L047_00000328:
; H047+$00000328: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L047_0000032E:
; H047+$0000032E: 1b6b0143ffff  move.b $143(a3), -$1(a5)
        move.b $143(a3), -$1(a5)
L047_00000334:
; H047+$00000334: 1b6b0141fffe  move.b $141(a3), -$2(a5)
        move.b $141(a3), -$2(a5)
L047_0000033A:
; H047+$0000033A: 1b6b0142fffd  move.b $142(a3), -$3(a5)
        move.b $142(a3), -$3(a5)
L047_00000340:
; H047+$00000340: 177c000c0143  move.b #$c, $143(a3)
        move.b #$c, $143(a3)
L047_00000346:
; H047+$00000346: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L047_0000034A:
; H047+$0000034A: 17420141  move.b d2, $141(a3)
        move.b d2, $141(a3)
L047_0000034E:
; H047+$0000034E: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_00000352:
; H047+$00000352: 17420142  move.b d2, $142(a3)
        move.b d2, $142(a3)
L047_00000356:
; H047+$00000356: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L047_0000035A:
; H047+$0000035A: 67000020  beq.w $37c
        beq.w H047+$37C
L047_0000035E:
; H047+$0000035E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000360:
; H047+$00000360: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L047_00000364:
; H047+$00000364: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L047_00000368:
; H047+$00000368: 4267  clr.w -(a7)
        clr.w -(a7)
L047_0000036A:
; H047+$0000036A: 4267  clr.w -(a7)
        clr.w -(a7)
L047_0000036C:
; H047+$0000036C: 3f3c0019  move.w #$19, -(a7)
        move.w #$19, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L047_00000370:
; H047+$00000370: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L047_00000376:
; H047+$00000376: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000378:
; H047+$00000378: 60000032  bra.w $3ac
        bra.w H047+$3AC
L047_0000037C:
; H047+$0000037C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_0000037E:
; H047+$0000037E: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L047_00000382:
; H047+$00000382: c5fc0003  muls.w #$3, d2
        muls.w #$3, d2
L047_00000386:
; H047+$00000386: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_00000388:
; H047+$00000388: 342dfff8  move.w -$8(a5), d2
        move.w -$8(a5), d2
L047_0000038C:
; H047+$0000038C: c5fc0003  muls.w #$3, d2
        muls.w #$3, d2
L047_00000390:
; H047+$00000390: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_00000392:
; H047+$00000392: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_00000396:
; H047+$00000396: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_0000039A:
; H047+$0000039A: 1f3c0008  move.b #$8, -(a7)
        move.b #$8, -(a7)
L047_0000039E:
; H047+$0000039E: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; -> H029+$10B8 (sub_H029_000010B8)
L047_000003A4:
; H047+$000003A4: 4eb9000010b8  jsr $10b8.l
        jsr (H029+$10B8).l
L047_000003AA:
; H047+$000003AA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000003AC:
; H047+$000003AC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000003AE:
; H047+$000003AE: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_000003B0:
; H047+$000003B0: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
L047_000003B6:
; H047+$000003B6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000003B8:
; H047+$000003B8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000003BA:
; H047+$000003BA: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L047_000003BE:
; H047+$000003BE: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L047_000003C2:
; H047+$000003C2: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000003C4:
; H047+$000003C4: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000003C6:
; H047+$000003C6: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; -> H035+$0460 (sub_H035_00000460)
L047_000003CA:
; H047+$000003CA: 4eb900000460  jsr $460.l
        jsr (H035+$460).l
L047_000003D0:
; H047+$000003D0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000003D2:
; H047+$000003D2: 176dffff0143  move.b -$1(a5), $143(a3)
        move.b -$1(a5), $143(a3)
L047_000003D8:
; H047+$000003D8: 176dfffe0141  move.b -$2(a5), $141(a3)
        move.b -$2(a5), $141(a3)
L047_000003DE:
; H047+$000003DE: 176dfffd0142  move.b -$3(a5), $142(a3)
        move.b -$3(a5), $142(a3)
L047_000003E4:
; H047+$000003E4: 4e5d  unlk a5
        unlk a5
L047_000003E6:
; H047+$000003E6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L047_000003E8:
; H047+$000003E8: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L047_000003EC:
; H047+$000003EC: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H047_000003EE [partial]
; Purpose: Routine of the character icon editor (body, weapons, parts) module; calls H029+$10B8.
;   - Calls H029+$10B8.
;   - Uses the global state: H005+$3368 (current character).
; Direct callers: H047+$0CD8, H047+$0B4A, H047+$10EE, H047+$1102, H047+$1118, H047+$112C and 5 more
; --------------------------------------------------------------------------
L047_000003EE:
; H047+$000003EE: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
; STATE: H005+$3368 = current character
L047_000003F2:
; H047+$000003F2: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L047_000003F8:
; H047+$000003F8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000003FA:
; H047+$000003FA: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L047_000003FE:
; H047+$000003FE: 6100fd62  bsr.w $162
        bsr.w H047+$162
L047_00000402:
; H047+$00000402: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000404:
; H047+$00000404: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000408:
; H047+$00000408: 342afed8  move.w -$128(a2), d2
        move.w -$128(a2), d2
L047_0000040C:
; H047+$0000040C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_0000040E:
; H047+$0000040E: 48c2  ext.l d2
        ext.l d2
L047_00000410:
; H047+$00000410: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_00000414:
; H047+$00000414: 4842  swap d2
        swap d2
L047_00000416:
; H047+$00000416: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L047_0000041A:
; H047+$0000041A: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_0000041E:
; H047+$0000041E: 342afed8  move.w -$128(a2), d2
        move.w -$128(a2), d2
L047_00000422:
; H047+$00000422: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000424:
; H047+$00000424: 48c2  ext.l d2
        ext.l d2
L047_00000426:
; H047+$00000426: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_0000042A:
; H047+$0000042A: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L047_0000042E:
; H047+$0000042E: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L047_00000432:
; H047+$00000432: d56dfffe  add.w d2, -$2(a5)
        add.w d2, -$2(a5)
L047_00000436:
; H047+$00000436: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_0000043A:
; H047+$0000043A: d56dfffc  add.w d2, -$4(a5)
        add.w d2, -$4(a5)
L047_0000043E:
; H047+$0000043E: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000442:
; H047+$00000442: 342afeda  move.w -$126(a2), d2
        move.w -$126(a2), d2
L047_00000446:
; H047+$00000446: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000448:
; H047+$00000448: 48c2  ext.l d2
        ext.l d2
L047_0000044A:
; H047+$0000044A: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_0000044E:
; H047+$0000044E: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L047_00000452:
; H047+$00000452: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000456:
; H047+$00000456: 342afeda  move.w -$126(a2), d2
        move.w -$126(a2), d2
L047_0000045A:
; H047+$0000045A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_0000045C:
; H047+$0000045C: 48c2  ext.l d2
        ext.l d2
L047_0000045E:
; H047+$0000045E: 85fc0007  divs.w #$7, d2
        divs.w #$7, d2
L047_00000462:
; H047+$00000462: 4842  swap d2
        swap d2
L047_00000464:
; H047+$00000464: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L047_00000468:
; H047+$00000468: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L047_0000046C:
; H047+$0000046C: 6c000008  bge.w $476
        bge.w H047+$476
L047_00000470:
; H047+$00000470: 3b7c0006fffe  move.w #$6, -$2(a5)
        move.w #$6, -$2(a5)
L047_00000476:
; H047+$00000476: 0c6d0006fffe  cmpi.w #$6, -$2(a5)
        cmpi.w #$6, -$2(a5)
L047_0000047C:
; H047+$0000047C: 6f000006  ble.w $484
        ble.w H047+$484
L047_00000480:
; H047+$00000480: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L047_00000484:
; H047+$00000484: 4a6dfffc  tst.w -$4(a5)
        tst.w -$4(a5)
L047_00000488:
; H047+$00000488: 6c000008  bge.w $492
        bge.w H047+$492
L047_0000048C:
; H047+$0000048C: 3b6dfff2fffc  move.w -$e(a5), -$4(a5)
        move.w -$e(a5), -$4(a5)
L047_00000492:
; H047+$00000492: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L047_00000496:
; H047+$00000496: b46dfff2  cmp.w -$e(a5), d2
        cmp.w -$e(a5), d2
L047_0000049A:
; H047+$0000049A: 6f000006  ble.w $4a2
        ble.w H047+$4A2
L047_0000049E:
; H047+$0000049E: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L047_000004A2:
; H047+$000004A2: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L047_000004A6:
; H047+$000004A6: b46dfff2  cmp.w -$e(a5), d2
        cmp.w -$e(a5), d2
L047_000004AA:
; H047+$000004AA: 6600004c  bne.w $4f8
        bne.w H047+$4F8
L047_000004AE:
; H047+$000004AE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_000004B2:
; H047+$000004B2: b46dfff0  cmp.w -$10(a5), d2
        cmp.w -$10(a5), d2
L047_000004B6:
; H047+$000004B6: 6f000040  ble.w $4f8
        ble.w H047+$4F8
L047_000004BA:
; H047+$000004BA: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L047_000004BE:
; H047+$000004BE: 6c00000a  bge.w $4ca
        bge.w H047+$4CA
L047_000004C2:
; H047+$000004C2: 536dfffc  subq.w #$1, -$4(a5)
        subq.w #$1, -$4(a5)
L047_000004C6:
; H047+$000004C6: 60000030  bra.w $4f8
        bra.w H047+$4F8
L047_000004CA:
; H047+$000004CA: 4a6d000e  tst.w $e(a5)
        tst.w $e(a5)
L047_000004CE:
; H047+$000004CE: 6f00000a  ble.w $4da
        ble.w H047+$4DA
L047_000004D2:
; H047+$000004D2: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L047_000004D6:
; H047+$000004D6: 60000020  bra.w $4f8
        bra.w H047+$4F8
L047_000004DA:
; H047+$000004DA: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L047_000004DE:
; H047+$000004DE: 6c00000c  bge.w $4ec
        bge.w H047+$4EC
L047_000004E2:
; H047+$000004E2: 3b6dfff0fffe  move.w -$10(a5), -$2(a5)
        move.w -$10(a5), -$2(a5)
L047_000004E8:
; H047+$000004E8: 6000000e  bra.w $4f8
        bra.w H047+$4F8
L047_000004EC:
; H047+$000004EC: 4a6d0010  tst.w $10(a5)
        tst.w $10(a5)
L047_000004F0:
; H047+$000004F0: 6f000006  ble.w $4f8
        ble.w H047+$4F8
L047_000004F4:
; H047+$000004F4: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L047_000004F8:
; H047+$000004F8: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L047_000004FC:
; H047+$000004FC: c5fc0007  muls.w #$7, d2
        muls.w #$7, d2
L047_00000500:
; H047+$00000500: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L047_00000504:
; H047+$00000504: 5242  addq.w #$1, d2
        addq.w #$1, d2
L047_00000506:
; H047+$00000506: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L047_0000050A:
; H047+$0000050A: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_0000050E:
; H047+$0000050E: 0c2a0048ffdb  cmpi.b #$48, -$25(a2)
        cmpi.b #$48, -$25(a2)
L047_00000514:
; H047+$00000514: 6600000e  bne.w $524
        bne.w H047+$524
L047_00000518:
; H047+$00000518: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L047_0000051C:
; H047+$0000051C: 17420141  move.b d2, $141(a3)
        move.b d2, $141(a3)
L047_00000520:
; H047+$00000520: 6000000a  bra.w $52c
        bra.w H047+$52C
L047_00000524:
; H047+$00000524: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L047_00000528:
; H047+$00000528: 17420142  move.b d2, $142(a3)
        move.b d2, $142(a3)
L047_0000052C:
; H047+$0000052C: 7400  moveq #$0, d2
        moveq #0, d2
L047_0000052E:
; H047+$0000052E: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_00000532:
; H047+$00000532: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L047_00000536:
; H047+$00000536: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000538:
; H047+$00000538: 142b0141  move.b $141(a3), d2
        move.b $141(a3), d2
L047_0000053C:
; H047+$0000053C: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L047_00000540:
; H047+$00000540: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L047_00000544:
; H047+$00000544: 670000aa  beq.w $5f0
        beq.w H047+$5F0
L047_00000548:
; H047+$00000548: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_0000054A:
; H047+$0000054A: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L047_0000054E:
; H047+$0000054E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_00000552:
; H047+$00000552: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
L047_00000556:
; H047+$00000556: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L047_0000055A:
; H047+$0000055A: 4227  clr.b -(a7)
        clr.b -(a7)
L047_0000055C:
; H047+$0000055C: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; -> H029+$10B8 (sub_H029_000010B8)
L047_00000562:
; H047+$00000562: 4eb9000010b8  jsr $10b8.l
        jsr (H029+$10B8).l
L047_00000568:
; H047+$00000568: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000056A:
; H047+$0000056A: 3b7c0001fffa  move.w #$1, -$6(a5)
        move.w #$1, -$6(a5)
L047_00000570:
; H047+$00000570: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000574:
; H047+$00000574: 3f2afeda  move.w -$126(a2), -(a7)
        move.w -$126(a2), -(a7)
L047_00000578:
; H047+$00000578: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L047_0000057C:
; H047+$0000057C: b457  cmp.w (a7), d2
        cmp.w (a7), d2
L047_0000057E:
; H047+$0000057E: 6e00006a  bgt.w $5ea
        bgt.w H047+$5EA
L047_00000582:
; H047+$00000582: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000586:
; H047+$00000586: 0c2a0048ffdb  cmpi.b #$48, -$25(a2)
        cmpi.b #$48, -$25(a2)
L047_0000058C:
; H047+$0000058C: 66000020  bne.w $5ae
        bne.w H047+$5AE
L047_00000590:
; H047+$00000590: 3b6dfffafff8  move.w -$6(a5), -$8(a5)
        move.w -$6(a5), -$8(a5)
L047_00000596:
; H047+$00000596: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000598:
; H047+$00000598: 142b0141  move.b $141(a3), d2
        move.b $141(a3), d2
L047_0000059C:
; H047+$0000059C: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L047_000005A0:
; H047+$000005A0: b842  cmp.w d2, d4
        cmp.w d2, d4
L047_000005A2:
; H047+$000005A2: 57c2  seq.b d2
        seq.b d2
L047_000005A4:
; H047+$000005A4: 4402  neg.b d2
        neg.b d2
L047_000005A6:
; H047+$000005A6: 1b42ffef  move.b d2, -$11(a5)
        move.b d2, -$11(a5)
L047_000005AA:
; H047+$000005AA: 6000001c  bra.w $5c8
        bra.w H047+$5C8
L047_000005AE:
; H047+$000005AE: 3b6dfffafff6  move.w -$6(a5), -$a(a5)
        move.w -$6(a5), -$a(a5)
L047_000005B4:
; H047+$000005B4: 7400  moveq #$0, d2
        moveq #0, d2
L047_000005B6:
; H047+$000005B6: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_000005BA:
; H047+$000005BA: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L047_000005BE:
; H047+$000005BE: b842  cmp.w d2, d4
        cmp.w d2, d4
L047_000005C0:
; H047+$000005C0: 57c2  seq.b d2
        seq.b d2
L047_000005C2:
; H047+$000005C2: 4402  neg.b d2
        neg.b d2
L047_000005C4:
; H047+$000005C4: 1b42ffef  move.b d2, -$11(a5)
        move.b d2, -$11(a5)
L047_000005C8:
; H047+$000005C8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000005CA:
; H047+$000005CA: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L047_000005CE:
; H047+$000005CE: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L047_000005D2:
; H047+$000005D2: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L047_000005D6:
; H047+$000005D6: 1f2dffef  move.b -$11(a5), -(a7)
        move.b -$11(a5), -(a7)
L047_000005DA:
; H047+$000005DA: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L047_000005DE:
; H047+$000005DE: 6100fd1e  bsr.w $2fe
        bsr.w H047+$2FE
L047_000005E2:
; H047+$000005E2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000005E4:
; H047+$000005E4: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L047_000005E8:
; H047+$000005E8: 688e  bvc.b $578
        bvc.b H047+$578
L047_000005EA:
; H047+$000005EA: 548f  addq.l #$2, a7
        addq.l #$2, a7
L047_000005EC:
; H047+$000005EC: 60000090  bra.w $67e
        bra.w H047+$67E
L047_000005F0:
; H047+$000005F0: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_000005F4:
; H047+$000005F4: 0c2a0048ffdb  cmpi.b #$48, -$25(a2)
        cmpi.b #$48, -$25(a2)
L047_000005FA:
; H047+$000005FA: 66000044  bne.w $640
        bne.w H047+$640
L047_000005FE:
; H047+$000005FE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000600:
; H047+$00000600: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000604:
; H047+$00000604: 3f2afed8  move.w -$128(a2), -(a7)
        move.w -$128(a2), -(a7)
L047_00000608:
; H047+$00000608: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_0000060C:
; H047+$0000060C: 3f2afed8  move.w -$128(a2), -(a7)
        move.w -$128(a2), -(a7)
L047_00000610:
; H047+$00000610: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L047_00000614:
; H047+$00000614: 4227  clr.b -(a7)
        clr.b -(a7)
L047_00000616:
; H047+$00000616: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L047_0000061A:
; H047+$0000061A: 6100fce2  bsr.w $2fe
        bsr.w H047+$2FE
L047_0000061E:
; H047+$0000061E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000620:
; H047+$00000620: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000622:
; H047+$00000622: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L047_00000626:
; H047+$00000626: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L047_0000062A:
; H047+$0000062A: 3f2dfff6  move.w -$a(a5), -(a7)
        move.w -$a(a5), -(a7)
L047_0000062E:
; H047+$0000062E: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L047_00000632:
; H047+$00000632: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L047_00000636:
; H047+$00000636: 6100fcc6  bsr.w $2fe
        bsr.w H047+$2FE
L047_0000063A:
; H047+$0000063A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000063C:
; H047+$0000063C: 60000040  bra.w $67e
        bra.w H047+$67E
L047_00000640:
; H047+$00000640: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000642:
; H047+$00000642: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000646:
; H047+$00000646: 3f2afed8  move.w -$128(a2), -(a7)
        move.w -$128(a2), -(a7)
L047_0000064A:
; H047+$0000064A: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L047_0000064E:
; H047+$0000064E: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L047_00000652:
; H047+$00000652: 3f2afed8  move.w -$128(a2), -(a7)
        move.w -$128(a2), -(a7)
L047_00000656:
; H047+$00000656: 4227  clr.b -(a7)
        clr.b -(a7)
L047_00000658:
; H047+$00000658: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L047_0000065C:
; H047+$0000065C: 6100fca0  bsr.w $2fe
        bsr.w H047+$2FE
L047_00000660:
; H047+$00000660: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000662:
; H047+$00000662: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000664:
; H047+$00000664: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L047_00000668:
; H047+$00000668: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L047_0000066C:
; H047+$0000066C: 3f2dfff4  move.w -$c(a5), -(a7)
        move.w -$c(a5), -(a7)
L047_00000670:
; H047+$00000670: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L047_00000674:
; H047+$00000674: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L047_00000678:
; H047+$00000678: 6100fc84  bsr.w $2fe
        bsr.w H047+$2FE
L047_0000067C:
; H047+$0000067C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000067E:
; H047+$0000067E: 4e5d  unlk a5
        unlk a5
L047_00000680:
; H047+$00000680: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L047_00000682:
; H047+$00000682: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L047_00000686:
; H047+$00000686: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H047_00000688 [partial]
; Purpose: Routine of the character icon editor (body, weapons, parts) module; calls H016+$0014, H029+$0354, H029+$0EFE, H044+$01C2.
;   - Calls H016+$0014.
;   - Calls H029+$0354.
;   - Calls H029+$0EFE.
;   - Calls H044+$01C2.
;   - Calls H028+$0D36.
;   - Calls H022+$0084.
;   - Calls H066+$0C34.
;   - Uses the global state: H005+$3368 (current character); H005+$3DE3 (native context, 5 in combat); H005+$52F2 (pointer to the game screen).
; Direct callers: H047+$09D8, H047+$139A, H047+$13F6, H047+$140E
; --------------------------------------------------------------------------
L047_00000688:
; H047+$00000688: 4e55ffd8  link.w a5, #$ffd8
        link.w a5, #$ffd8
L047_0000068C:
; H047+$0000068C: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L047_00000690:
; H047+$00000690: 0c6d0001fffc  cmpi.w #$1, -$4(a5)
        cmpi.w #$1, -$4(a5)
L047_00000696:
; H047+$00000696: 620000d2  bhi.w $76a
        bhi.w H047+$76A
L047_0000069A:
; H047+$0000069A: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L047_0000069E:
; H047+$0000069E: e742  asl.w #$3, d2
        asl.w #$3, d2
L047_000006A0:
; H047+$000006A0: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L047_000006A6:
; H047+$000006A6: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L047_000006AA:
; H047+$000006AA: e544  asl.w #$2, d4
        asl.w #$2, d4
L047_000006AC:
; H047+$000006AC: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L047_000006B0:
; H047+$000006B0: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L047_000006B4:
; H047+$000006B4: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L047_000006B8:
; H047+$000006B8: 4853  pea.l (a3)
        pea.l (a3)
L047_000006BA:
; H047+$000006BA: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000006BC:
; H047+$000006BC: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000006BE:
; H047+$000006BE: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_000006C2:
; H047+$000006C2: e742  asl.w #$3, d2
        asl.w #$3, d2
L047_000006C4:
; H047+$000006C4: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L047_000006CA:
; H047+$000006CA: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L047_000006CE:
; H047+$000006CE: e544  asl.w #$2, d4
        asl.w #$2, d4
L047_000006D0:
; H047+$000006D0: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L047_000006D4:
; H047+$000006D4: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L047_000006D8:
; H047+$000006D8: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L047_000006DC:
; H047+$000006DC: 4853  pea.l (a3)
        pea.l (a3)
L047_000006DE:
; H047+$000006DE: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000006E0:
; H047+$000006E0: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000006E2:
; H047+$000006E2: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L047_000006E6:
; H047+$000006E6: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L047_000006EA:
; H047+$000006EA: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L047_000006EE:
; H047+$000006EE: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L047_000006F2:
; H047+$000006F2: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L047_000006F4:
; H047+$000006F4: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L047_000006FA:
; H047+$000006FA: 2b40ffd8  move.l d0, -$28(a5)
        move.l d0, -$28(a5)
L047_000006FE:
; H047+$000006FE: 342d0010  move.w $10(a5), d2
        move.w $10(a5), d2
L047_00000702:
; H047+$00000702: e742  asl.w #$3, d2
        asl.w #$3, d2
L047_00000704:
; H047+$00000704: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L047_0000070A:
; H047+$0000070A: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L047_0000070E:
; H047+$0000070E: e544  asl.w #$2, d4
        asl.w #$2, d4
L047_00000710:
; H047+$00000710: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L047_00000714:
; H047+$00000714: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L047_00000718:
; H047+$00000718: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L047_0000071C:
; H047+$0000071C: 4853  pea.l (a3)
        pea.l (a3)
L047_0000071E:
; H047+$0000071E: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000720:
; H047+$00000720: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000722:
; H047+$00000722: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_00000726:
; H047+$00000726: e742  asl.w #$3, d2
        asl.w #$3, d2
L047_00000728:
; H047+$00000728: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L047_0000072E:
; H047+$0000072E: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L047_00000732:
; H047+$00000732: e544  asl.w #$2, d4
        asl.w #$2, d4
L047_00000734:
; H047+$00000734: 47f32000  lea.l (a3, d2.w), a3
        lea.l (a3, d2.w), a3
L047_00000738:
; H047+$00000738: 26734000  movea.l (a3, d4.w), a3
        movea.l (a3, d4.w), a3
L047_0000073C:
; H047+$0000073C: 266b000c  movea.l $c(a3), a3
        movea.l $c(a3), a3
L047_00000740:
; H047+$00000740: 4853  pea.l (a3)
        pea.l (a3)
L047_00000742:
; H047+$00000742: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000744:
; H047+$00000744: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000746:
; H047+$00000746: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L047_0000074A:
; H047+$0000074A: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L047_0000074E:
; H047+$0000074E: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L047_00000752:
; H047+$00000752: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L047_00000756:
; H047+$00000756: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L047_00000758:
; H047+$00000758: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L047_0000075E:
; H047+$0000075E: 2b40ffd8  move.l d0, -$28(a5)
        move.l d0, -$28(a5)
L047_00000762:
; H047+$00000762: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L047_00000766:
; H047+$00000766: 6400ff28  bcc.w $690
        bcc.w H047+$690
L047_0000076A:
; H047+$0000076A: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L047_0000076E:
; H047+$0000076E: 6700015c  beq.w $8cc
        beq.w H047+$8CC
; STATE: H005+$3368 = current character
L047_00000772:
; H047+$00000772: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L047_00000778:
; H047+$00000778: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L047_0000077C:
; H047+$0000077C: 0c6d000ffffe  cmpi.w #$f, -$2(a5)
        cmpi.w #$f, -$2(a5)
L047_00000782:
; H047+$00000782: 62000028  bhi.w $7ac
        bhi.w H047+$7AC
L047_00000786:
; H047+$00000786: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_0000078A:
; H047+$0000078A: 45edffec  lea.l -$14(a5), a2
        lea.l -$14(a5), a2
L047_0000078E:
; H047+$0000078E: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L047_00000792:
; H047+$00000792: 15842000  move.b d4, (a2, d2.w)
        move.b d4, (a2, d2.w)
L047_00000796:
; H047+$00000796: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_0000079A:
; H047+$0000079A: 45edffdc  lea.l -$24(a5), a2
        lea.l -$24(a5), a2
L047_0000079E:
; H047+$0000079E: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L047_000007A2:
; H047+$000007A2: 15842000  move.b d4, (a2, d2.w)
        move.b d4, (a2, d2.w)
L047_000007A6:
; H047+$000007A6: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L047_000007AA:
; H047+$000007AA: 64d0  bcc.b $77c
        bcc.b H047+$77C
L047_000007AC:
; H047+$000007AC: 3b7c0001fffe  move.w #$1, -$2(a5)
        move.w #$1, -$2(a5)
L047_000007B2:
; H047+$000007B2: 0c6d0006fffe  cmpi.w #$6, -$2(a5)
        cmpi.w #$6, -$2(a5)
L047_000007B8:
; H047+$000007B8: 62000084  bhi.w $83e
        bhi.w H047+$83E
L047_000007BC:
; H047+$000007BC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_000007C0:
; H047+$000007C0: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_000007C2:
; H047+$000007C2: 45f900005228  lea.l $5228.l, a2
        lea.l (H005+$5228).l, a2
L047_000007C8:
; H047+$000007C8: 7800  moveq #$0, d4
        moveq #0, d4
L047_000007CA:
; H047+$000007CA: 18322000  move.b (a2, d2.w), d4
        move.b (a2, d2.w), d4
L047_000007CE:
; H047+$000007CE: 45edffdc  lea.l -$24(a5), a2
        lea.l -$24(a5), a2
L047_000007D2:
; H047+$000007D2: 48e70830  movem.l d4/a2-a3, -(a7)
        movem.l d4/a2-a3, -(a7)
L047_000007D6:
; H047+$000007D6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_000007DA:
; H047+$000007DA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_000007DC:
; H047+$000007DC: 43eb0146  lea.l $146(a3), a1
        lea.l $146(a3), a1
L047_000007E0:
; H047+$000007E0: 1f312000  move.b (a1, d2.w), -(a7)
        move.b (a1, d2.w), -(a7)
L047_000007E4:
; H047+$000007E4: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L047_000007E8:
; H047+$000007E8: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L047_000007EE:
; H047+$000007EE: 4cdf0c10  movem.l (a7)+, d4/a2-a3
        movem.l (a7)+, d4/a2-a3
L047_000007F2:
; H047+$000007F2: 15804000  move.b d0, (a2, d4.w)
        move.b d0, (a2, d4.w)
L047_000007F6:
; H047+$000007F6: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_000007FA:
; H047+$000007FA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_000007FC:
; H047+$000007FC: 45f900005228  lea.l $5228.l, a2
        lea.l (H005+$5228).l, a2
L047_00000802:
; H047+$00000802: 7800  moveq #$0, d4
        moveq #0, d4
L047_00000804:
; H047+$00000804: 18322000  move.b (a2, d2.w), d4
        move.b (a2, d2.w), d4
L047_00000808:
; H047+$00000808: 5044  addq.w #$8, d4
        addq.w #$8, d4
L047_0000080A:
; H047+$0000080A: 45edffdc  lea.l -$24(a5), a2
        lea.l -$24(a5), a2
L047_0000080E:
; H047+$0000080E: 48e70830  movem.l d4/a2-a3, -(a7)
        movem.l d4/a2-a3, -(a7)
L047_00000812:
; H047+$00000812: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L047_00000816:
; H047+$00000816: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000818:
; H047+$00000818: 43eb0146  lea.l $146(a3), a1
        lea.l $146(a3), a1
L047_0000081C:
; H047+$0000081C: 1f312000  move.b (a1, d2.w), -(a7)
        move.b (a1, d2.w), -(a7)
L047_00000820:
; H047+$00000820: 3f3c00f0  move.w #$f0, -(a7)
        move.w #$f0, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L047_00000824:
; H047+$00000824: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L047_0000082A:
; H047+$0000082A: 4cdf0c10  movem.l (a7)+, d4/a2-a3
        movem.l (a7)+, d4/a2-a3
L047_0000082E:
; H047+$0000082E: 1400  move.b d0, d2
        move.b d0, d2
L047_00000830:
; H047+$00000830: e80a  lsr.b #$4, d2
        lsr.b #$4, d2
L047_00000832:
; H047+$00000832: 15824000  move.b d2, (a2, d4.w)
        move.b d2, (a2, d4.w)
L047_00000836:
; H047+$00000836: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L047_0000083A:
; H047+$0000083A: 6400ff76  bcc.w $7b2
        bcc.w H047+$7B2
L047_0000083E:
; H047+$0000083E: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000840:
; H047+$00000840: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_00000844:
; H047+$00000844: 0c420020  cmpi.w #$20, d2
        cmpi.w #$20, d2
L047_00000848:
; H047+$00000848: 6c000082  bge.w $8cc
        bge.w H047+$8CC
L047_0000084C:
; H047+$0000084C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_0000084E:
; H047+$0000084E: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L047_00000852:
; H047+$00000852: 45edffec  lea.l -$14(a5), a2
        lea.l -$14(a5), a2
L047_00000856:
; H047+$00000856: 43d7  lea.l (a7), a1
        lea.l (a7), a1
L047_00000858:
; H047+$00000858: 7403  moveq #$3, d2
        moveq #3, d2
L047_0000085A:
; H047+$0000085A: 22da  move.l (a2)+, (a1)+
        move.l (a2)+, (a1)+
L047_0000085C:
; H047+$0000085C: 51cafffc  dbra d2, $85a
        dbra d2, H047+$85A
L047_00000860:
; H047+$00000860: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L047_00000864:
; H047+$00000864: 45edffdc  lea.l -$24(a5), a2
        lea.l -$24(a5), a2
L047_00000868:
; H047+$00000868: 43d7  lea.l (a7), a1
        lea.l (a7), a1
L047_0000086A:
; H047+$0000086A: 7403  moveq #$3, d2
        moveq #3, d2
L047_0000086C:
; H047+$0000086C: 22da  move.l (a2)+, (a1)+
        move.l (a2)+, (a1)+
L047_0000086E:
; H047+$0000086E: 51cafffc  dbra d2, $86c
        dbra d2, H047+$86C
L047_00000872:
; H047+$00000872: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000874:
; H047+$00000874: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_00000878:
; H047+$00000878: e742  asl.w #$3, d2
        asl.w #$3, d2
L047_0000087A:
; H047+$0000087A: 45f900003244  lea.l $3244.l, a2
        lea.l (H005+$3244).l, a2
L047_00000880:
; H047+$00000880: 2f322000  move.l (a2, d2.w), -(a7)
        move.l (a2, d2.w), -(a7)
; -> H029+$0EFE (trampoline_H029_10AC)
L047_00000884:
; H047+$00000884: 4eb900000efe  jsr $efe.l
        jsr (H029+$EFE).l
L047_0000088A:
; H047+$0000088A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000088C:
; H047+$0000088C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_0000088E:
; H047+$0000088E: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L047_00000892:
; H047+$00000892: 45edffec  lea.l -$14(a5), a2
        lea.l -$14(a5), a2
L047_00000896:
; H047+$00000896: 43d7  lea.l (a7), a1
        lea.l (a7), a1
L047_00000898:
; H047+$00000898: 7403  moveq #$3, d2
        moveq #3, d2
L047_0000089A:
; H047+$0000089A: 22da  move.l (a2)+, (a1)+
        move.l (a2)+, (a1)+
L047_0000089C:
; H047+$0000089C: 51cafffc  dbra d2, $89a
        dbra d2, H047+$89A
L047_000008A0:
; H047+$000008A0: 4feffff0  lea.l -$10(a7), a7
        lea.l -$10(a7), a7
L047_000008A4:
; H047+$000008A4: 45edffdc  lea.l -$24(a5), a2
        lea.l -$24(a5), a2
L047_000008A8:
; H047+$000008A8: 43d7  lea.l (a7), a1
        lea.l (a7), a1
L047_000008AA:
; H047+$000008AA: 7403  moveq #$3, d2
        moveq #3, d2
L047_000008AC:
; H047+$000008AC: 22da  move.l (a2)+, (a1)+
        move.l (a2)+, (a1)+
L047_000008AE:
; H047+$000008AE: 51cafffc  dbra d2, $8ac
        dbra d2, H047+$8AC
L047_000008B2:
; H047+$000008B2: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000008B4:
; H047+$000008B4: 342d000e  move.w $e(a5), d2
        move.w $e(a5), d2
L047_000008B8:
; H047+$000008B8: e742  asl.w #$3, d2
        asl.w #$3, d2
L047_000008BA:
; H047+$000008BA: 45f900003244  lea.l $3244.l, a2
        lea.l (H005+$3244).l, a2
L047_000008C0:
; H047+$000008C0: 2f322004  move.l $4(a2, d2.w), -(a7)
        move.l $4(a2, d2.w), -(a7)
; -> H029+$0EFE (trampoline_H029_10AC)
L047_000008C4:
; H047+$000008C4: 4eb900000efe  jsr $efe.l
        jsr (H029+$EFE).l
L047_000008CA:
; H047+$000008CA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000008CC:
; H047+$000008CC: 4e5d  unlk a5
        unlk a5
L047_000008CE:
; H047+$000008CE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L047_000008D0:
; H047+$000008D0: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L047_000008D4:
; H047+$000008D4: 4ed0  jmp (a0)
        jmp (a0)
; STATE: H005+$3DE3 = native context, 5 in combat
L047_000008D6:
; H047+$000008D6: 1b7900003de3ffff  move.b $3de3.l, -$1(a5)
        move.b (H005+$3DE3).l, -$1(a5)
; STATE: H005+$3DE3 = native context, 5 in combat
L047_000008DE:
; H047+$000008DE: 423900003de3  clr.b $3de3.l
        clr.b (H005+$3DE3).l
L047_000008E4:
; H047+$000008E4: 47ec000a  lea.l $a(a4), a3
        lea.l $a(a4), a3
L047_000008E8:
; H047+$000008E8: 45edff08  lea.l -$f8(a5), a2
        lea.l -$f8(a5), a2
L047_000008EC:
; H047+$000008EC: 7428  moveq #$28, d2
        moveq #40, d2
L047_000008EE:
; H047+$000008EE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L047_000008F0:
; H047+$000008F0: 57cafffc  dbeq d2, $8ee
        dbeq d2, H047+$8EE
L047_000008F4:
; H047+$000008F4: 47ec001b  lea.l $1b(a4), a3
        lea.l $1b(a4), a3
L047_000008F8:
; H047+$000008F8: 45edff32  lea.l -$ce(a5), a2
        lea.l -$ce(a5), a2
L047_000008FC:
; H047+$000008FC: 7428  moveq #$28, d2
        moveq #40, d2
L047_000008FE:
; H047+$000008FE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L047_00000900:
; H047+$00000900: 57cafffc  dbeq d2, $8fe
        dbeq d2, H047+$8FE
L047_00000904:
; H047+$00000904: 47ec0040  lea.l $40(a4), a3
        lea.l $40(a4), a3
L047_00000908:
; H047+$00000908: 45edff5c  lea.l -$a4(a5), a2
        lea.l -$a4(a5), a2
L047_0000090C:
; H047+$0000090C: 7428  moveq #$28, d2
        moveq #40, d2
L047_0000090E:
; H047+$0000090E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L047_00000910:
; H047+$00000910: 57cafffc  dbeq d2, $90e
        dbeq d2, H047+$90E
L047_00000914:
; H047+$00000914: 47ec004b  lea.l $4b(a4), a3
        lea.l $4b(a4), a3
L047_00000918:
; H047+$00000918: 45edff86  lea.l -$7a(a5), a2
        lea.l -$7a(a5), a2
L047_0000091C:
; H047+$0000091C: 7428  moveq #$28, d2
        moveq #40, d2
L047_0000091E:
; H047+$0000091E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L047_00000920:
; H047+$00000920: 57cafffc  dbeq d2, $91e
        dbeq d2, H047+$91E
L047_00000924:
; H047+$00000924: 47ec005f  lea.l $5f(a4), a3
        lea.l $5f(a4), a3
L047_00000928:
; H047+$00000928: 45edffb0  lea.l -$50(a5), a2
        lea.l -$50(a5), a2
L047_0000092C:
; H047+$0000092C: 7428  moveq #$28, d2
        moveq #40, d2
L047_0000092E:
; H047+$0000092E: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L047_00000930:
; H047+$00000930: 57cafffc  dbeq d2, $92e
        dbeq d2, H047+$92E
L047_00000934:
; H047+$00000934: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H044+$01C2 (sub_H044_000001C2)
L047_00000938:
; H047+$00000938: 4eb9000001c2  jsr $1c2.l
        jsr (H044+$1C2).l
; -> H028+$0D36 (sub_H028_00000D36)
L047_0000093E:
; H047+$0000093E: 4eb900000d36  jsr $d36.l
        jsr (H028+$D36).l
; STATE: H005+$52F2 = pointer to the game screen
L047_00000944:
; H047+$00000944: 2679000052f2  movea.l $52f2.l, a3
        movea.l (H005+$52F2).l, a3
L047_0000094A:
; H047+$0000094A: 486b002c  pea.l $2c(a3)
        pea.l $2c(a3)
L047_0000094E:
; H047+$0000094E: 47f90000522e  lea.l $522e.l, a3
        lea.l (H005+$522E).l, a3
L047_00000954:
; H047+$00000954: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000956:
; H047+$00000956: 3f3c0020  move.w #$20, -(a7)
        move.w #$20, -(a7)
; -> H022+$0084 (wrapper_LoadRGB4)
L047_0000095A:
; H047+$0000095A: 4eb900000084  jsr $84.l
        jsr (H022+$84).l
L047_00000960:
; H047+$00000960: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_00000962:
; H047+$00000962: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
; STATE: H005+$3368 = current character
L047_00000968:
; H047+$00000968: 267900003368  movea.l $3368.l, a3
        movea.l (H005+$3368).l, a3
L047_0000096E:
; H047+$0000096E: 3b7c0001ffec  move.w #$1, -$14(a5)
        move.w #$1, -$14(a5)
L047_00000974:
; H047+$00000974: 45eb0146  lea.l $146(a3), a2
        lea.l $146(a3), a2
L047_00000978:
; H047+$00000978: 43edffe6  lea.l -$1a(a5), a1
        lea.l -$1a(a5), a1
L047_0000097C:
; H047+$0000097C: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_0000097E:
; H047+$0000097E: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_00000980:
; H047+$00000980: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_00000982:
; H047+$00000982: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000984:
; H047+$00000984: 142b0143  move.b $143(a3), d2
        move.b $143(a3), d2
L047_00000988:
; H047+$00000988: 3b42ffee  move.w d2, -$12(a5)
        move.w d2, -$12(a5)
L047_0000098C:
; H047+$0000098C: 177c000c0143  move.b #$c, $143(a3)
        move.b #$c, $143(a3)
L047_00000992:
; H047+$00000992: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000994:
; H047+$00000994: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_00000996:
; H047+$00000996: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
L047_0000099C:
; H047+$0000099C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000099E:
; H047+$0000099E: 342dffee  move.w -$12(a5), d2
        move.w -$12(a5), d2
L047_000009A2:
; H047+$000009A2: 17420143  move.b d2, $143(a3)
        move.b d2, $143(a3)
L047_000009A6:
; H047+$000009A6: 7400  moveq #$0, d2
        moveq #0, d2
L047_000009A8:
; H047+$000009A8: 142b0141  move.b $141(a3), d2
        move.b $141(a3), d2
L047_000009AC:
; H047+$000009AC: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L047_000009B0:
; H047+$000009B0: 7400  moveq #$0, d2
        moveq #0, d2
L047_000009B2:
; H047+$000009B2: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_000009B6:
; H047+$000009B6: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L047_000009BA:
; H047+$000009BA: 7400  moveq #$0, d2
        moveq #0, d2
L047_000009BC:
; H047+$000009BC: 142b0144  move.b $144(a3), d2
        move.b $144(a3), d2
L047_000009C0:
; H047+$000009C0: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L047_000009C4:
; H047+$000009C4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000009C6:
; H047+$000009C6: 7400  moveq #$0, d2
        moveq #0, d2
L047_000009C8:
; H047+$000009C8: 142b0143  move.b $143(a3), d2
        move.b $143(a3), d2
L047_000009CC:
; H047+$000009CC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_000009CE:
; H047+$000009CE: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L047_000009D2:
; H047+$000009D2: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L047_000009D6:
; H047+$000009D6: 4855  pea.l (a5)
        pea.l (a5)
L047_000009D8:
; H047+$000009D8: 6100fcae  bsr.w $688
        bsr.w H047+$688
L047_000009DC:
; H047+$000009DC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000009DE:
; H047+$000009DE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000009E0:
; H047+$000009E0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_000009E4:
; H047+$000009E4: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L047_000009E8:
; H047+$000009E8: 4855  pea.l (a5)
        pea.l (a5)
L047_000009EA:
; H047+$000009EA: 6100f708  bsr.w $f4
        bsr.w H047+$F4
L047_000009EE:
; H047+$000009EE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000009F0:
; H047+$000009F0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000009F2:
; H047+$000009F2: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L047_000009F6:
; H047+$000009F6: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L047_000009FA:
; H047+$000009FA: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L047_000009FE:
; H047+$000009FE: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000A00:
; H047+$00000A00: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_00000A04:
; H047+$00000A04: 486c0064  pea.l $64(a4)
        pea.l $64(a4)
; FLOW: Calls UI_DrawText (H030+$0256).
L047_00000A08:
; H047+$00000A08: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L047_00000A0E:
; H047+$00000A0E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000A10:
; H047+$00000A10: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000A12:
; H047+$00000A12: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_00000A16:
; H047+$00000A16: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L047_00000A1A:
; H047+$00000A1A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L047_00000A1E:
; H047+$00000A1E: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000A20:
; H047+$00000A20: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L047_00000A24:
; H047+$00000A24: 486c0068  pea.l $68(a4)
        pea.l $68(a4)
; FLOW: Calls UI_DrawText (H030+$0256).
L047_00000A28:
; H047+$00000A28: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L047_00000A2E:
; H047+$00000A2E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000A30:
; H047+$00000A30: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000A32:
; H047+$00000A32: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L047_00000A36:
; H047+$00000A36: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L047_00000A3A:
; H047+$00000A3A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L047_00000A3E:
; H047+$00000A3E: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000A40:
; H047+$00000A40: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_00000A44:
; H047+$00000A44: 486c0077  pea.l $77(a4)
        pea.l $77(a4)
; FLOW: Calls UI_DrawText (H030+$0256).
L047_00000A48:
; H047+$00000A48: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L047_00000A4E:
; H047+$00000A4E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000A50:
; H047+$00000A50: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000A52:
; H047+$00000A52: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_00000A56:
; H047+$00000A56: 3f3c0010  move.w #$10, -(a7)
        move.w #$10, -(a7)
L047_00000A5A:
; H047+$00000A5A: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L047_00000A5E:
; H047+$00000A5E: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000A60:
; H047+$00000A60: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
L047_00000A64:
; H047+$00000A64: 486c007b  pea.l $7b(a4)
        pea.l $7b(a4)
; FLOW: Calls UI_DrawText (H030+$0256).
L047_00000A68:
; H047+$00000A68: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L047_00000A6E:
; H047+$00000A6E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000A70:
; H047+$00000A70: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000A72:
; H047+$00000A72: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_00000A76:
; H047+$00000A76: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L047_00000A7A:
; H047+$00000A7A: 4855  pea.l (a5)
        pea.l (a5)
L047_00000A7C:
; H047+$00000A7C: 6100f676  bsr.w $f4
        bsr.w H047+$F4
L047_00000A80:
; H047+$00000A80: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000A82:
; H047+$00000A82: 0c6d0006ffec  cmpi.w #$6, -$14(a5)
        cmpi.w #$6, -$14(a5)
L047_00000A88:
; H047+$00000A88: 57c2  seq.b d2
        seq.b d2
L047_00000A8A:
; H047+$00000A8A: 4402  neg.b d2
        neg.b d2
L047_00000A8C:
; H047+$00000A8C: 1b42fedd  move.b d2, -$123(a5)
        move.b d2, -$123(a5)
L047_00000A90:
; H047+$00000A90: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000A92:
; H047+$00000A92: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_00000A96:
; H047+$00000A96: 0c420020  cmpi.w #$20, d2
        cmpi.w #$20, d2
L047_00000A9A:
; H047+$00000A9A: 6d000016  blt.w $ab2
        blt.w H047+$AB2
L047_00000A9E:
; H047+$00000A9E: 45ec008a  lea.l $8a(a4), a2
        lea.l $8a(a4), a2
L047_00000AA2:
; H047+$00000AA2: 43edfede  lea.l -$122(a5), a1
        lea.l -$122(a5), a1
L047_00000AA6:
; H047+$00000AA6: 7428  moveq #$28, d2
        moveq #40, d2
L047_00000AA8:
; H047+$00000AA8: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L047_00000AAA:
; H047+$00000AAA: 57cafffc  dbeq d2, $aa8
        dbeq d2, H047+$AA8
L047_00000AAE:
; H047+$00000AAE: 60000012  bra.w $ac2
        bra.w H047+$AC2
L047_00000AB2:
; H047+$00000AB2: 45ec0099  lea.l $99(a4), a2
        lea.l $99(a4), a2
L047_00000AB6:
; H047+$00000AB6: 43edfede  lea.l -$122(a5), a1
        lea.l -$122(a5), a1
L047_00000ABA:
; H047+$00000ABA: 7428  moveq #$28, d2
        moveq #40, d2
L047_00000ABC:
; H047+$00000ABC: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L047_00000ABE:
; H047+$00000ABE: 57cafffc  dbeq d2, $abc
        dbeq d2, H047+$ABC
L047_00000AC2:
; H047+$00000AC2: 0c6d0006ffec  cmpi.w #$6, -$14(a5)
        cmpi.w #$6, -$14(a5)
L047_00000AC8:
; H047+$00000AC8: 57c2  seq.b d2
        seq.b d2
L047_00000ACA:
; H047+$00000ACA: 4402  neg.b d2
        neg.b d2
L047_00000ACC:
; H047+$00000ACC: 1942ffff  move.b d2, -$1(a4)
        move.b d2, -$1(a4)
L047_00000AD0:
; H047+$00000AD0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000AD2:
; H047+$00000AD2: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000AD4:
; H047+$00000AD4: 486c00bd  pea.l $bd(a4)
        pea.l $bd(a4)
L047_00000AD8:
; H047+$00000AD8: 342dffec  move.w -$14(a5), d2
        move.w -$14(a5), d2
L047_00000ADC:
; H047+$00000ADC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000ADE:
; H047+$00000ADE: c5fc002a  muls.w #$2a, d2
        muls.w #$2a, d2
L047_00000AE2:
; H047+$00000AE2: 45edfede  lea.l -$122(a5), a2
        lea.l -$122(a5), a2
L047_00000AE6:
; H047+$00000AE6: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L047_00000AEA:
; H047+$00000AEA: 48722800  pea.l (a2, d2.l)
        pea.l (a2, d2.l)
L047_00000AEE:
; H047+$00000AEE: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L047_00000AF2:
; H047+$00000AF2: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L047_00000AF6:
; H047+$00000AF6: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L047_00000AFA:
; H047+$00000AFA: 1f2dfedd  move.b -$123(a5), -(a7)
        move.b -$123(a5), -(a7)
L047_00000AFE:
; H047+$00000AFE: 4227  clr.b -(a7)
        clr.b -(a7)
L047_00000B00:
; H047+$00000B00: 486dfff6  pea.l -$a(a5)
        pea.l -$a(a5)
; FLOW: Calls UI_RequestChoice (H008+$01FC).
L047_00000B04:
; H047+$00000B04: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L047_00000B0A:
; H047+$00000B0A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000B0C:
; H047+$00000B0C: 1b40fff7  move.b d0, -$9(a5)
        move.b d0, -$9(a5)
L047_00000B10:
; H047+$00000B10: 4a2dfedd  tst.b -$123(a5)
        tst.b -$123(a5)
L047_00000B14:
; H047+$00000B14: 6600000a  bne.w $b20
        bne.w H047+$B20
L047_00000B18:
; H047+$00000B18: 4a2dfff6  tst.b -$a(a5)
        tst.b -$a(a5)
L047_00000B1C:
; H047+$00000B1C: 66000868  bne.w $1386
        bne.w H047+$1386
L047_00000B20:
; H047+$00000B20: 342dffec  move.w -$14(a5), d2
        move.w -$14(a5), d2
L047_00000B24:
; H047+$00000B24: 60000848  bra.w $136e
        bra.w H047+$136E
L047_00000B28:
; H047+$00000B28: 3b7c0001ffdc  move.w #$1, -$24(a5)
        move.w #$1, -$24(a5)
L047_00000B2E:
; H047+$00000B2E: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000B30:
; H047+$00000B30: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L047_00000B34:
; H047+$00000B34: 60000152  bra.w $c88
        bra.w H047+$C88
L047_00000B38:
; H047+$00000B38: 1b7c0057ffdb  move.b #$57, -$25(a5)
        move.b #$57, -$25(a5)
L047_00000B3E:
; H047+$00000B3E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000B40:
; H047+$00000B40: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000B42:
; H047+$00000B42: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000B44:
; H047+$00000B44: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L047_00000B48:
; H047+$00000B48: 4855  pea.l (a5)
        pea.l (a5)
L047_00000B4A:
; H047+$00000B4A: 6100f8a2  bsr.w $3ee
        bsr.w H047+$3EE
L047_00000B4E:
; H047+$00000B4E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000B50:
; H047+$00000B50: 3b7c0006ffec  move.w #$6, -$14(a5)
        move.w #$6, -$14(a5)
L047_00000B56:
; H047+$00000B56: 4e75  rts 
        rts 
L047_00000B58:
; H047+$00000B58: 3b7c0002ffec  move.w #$2, -$14(a5)
        move.w #$2, -$14(a5)
L047_00000B5E:
; H047+$00000B5E: 4e75  rts 
        rts 
L047_00000B60:
; H047+$00000B60: 3b7c0003ffec  move.w #$3, -$14(a5)
        move.w #$3, -$14(a5)
L047_00000B66:
; H047+$00000B66: 422dffe3  clr.b -$1d(a5)
        clr.b -$1d(a5)
L047_00000B6A:
; H047+$00000B6A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000B6C:
; H047+$00000B6C: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L047_00000B70:
; H047+$00000B70: 486dff32  pea.l -$ce(a5)
        pea.l -$ce(a5)
L047_00000B74:
; H047+$00000B74: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L047_00000B78:
; H047+$00000B78: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H026+$03F6 (sub_H026_000003F6)
L047_00000B7C:
; H047+$00000B7C: 4eb9000003f6  jsr $3f6.l
        jsr (H026+$3F6).l
L047_00000B82:
; H047+$00000B82: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000B84:
; H047+$00000B84: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000B86:
; H047+$00000B86: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L047_00000B8A:
; H047+$00000B8A: 486dff32  pea.l -$ce(a5)
        pea.l -$ce(a5)
L047_00000B8E:
; H047+$00000B8E: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L047_00000B92:
; H047+$00000B92: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L047_00000B96:
; H047+$00000B96: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; -> H026+$0254 (sub_H026_00000254)
L047_00000B9A:
; H047+$00000B9A: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L047_00000BA0:
; H047+$00000BA0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000BA2:
; H047+$00000BA2: 4e75  rts 
        rts 
L047_00000BA4:
; H047+$00000BA4: 3b7c0003ffec  move.w #$3, -$14(a5)
        move.w #$3, -$14(a5)
L047_00000BAA:
; H047+$00000BAA: 1b7c0001ffe3  move.b #$1, -$1d(a5)
        move.b #$1, -$1d(a5)
L047_00000BB0:
; H047+$00000BB0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000BB2:
; H047+$00000BB2: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L047_00000BB6:
; H047+$00000BB6: 486dff32  pea.l -$ce(a5)
        pea.l -$ce(a5)
L047_00000BBA:
; H047+$00000BBA: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L047_00000BBE:
; H047+$00000BBE: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
; -> H026+$03F6 (sub_H026_000003F6)
L047_00000BC2:
; H047+$00000BC2: 4eb9000003f6  jsr $3f6.l
        jsr (H026+$3F6).l
L047_00000BC8:
; H047+$00000BC8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000BCA:
; H047+$00000BCA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000BCC:
; H047+$00000BCC: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L047_00000BD0:
; H047+$00000BD0: 486dff32  pea.l -$ce(a5)
        pea.l -$ce(a5)
L047_00000BD4:
; H047+$00000BD4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L047_00000BD8:
; H047+$00000BD8: 486c0005  pea.l $5(a4)
        pea.l $5(a4)
L047_00000BDC:
; H047+$00000BDC: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
; -> H026+$0254 (sub_H026_00000254)
L047_00000BE0:
; H047+$00000BE0: 4eb900000254  jsr $254.l
        jsr (H026+$254).l
L047_00000BE6:
; H047+$00000BE6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000BE8:
; H047+$00000BE8: 4e75  rts 
        rts 
L047_00000BEA:
; H047+$00000BEA: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000BEC:
; H047+$00000BEC: 142b0144  move.b $144(a3), d2
        move.b $144(a3), d2
L047_00000BF0:
; H047+$00000BF0: 0c420002  cmpi.w #$2, d2
        cmpi.w #$2, d2
L047_00000BF4:
; H047+$00000BF4: 66000034  bne.w $c2a
        bne.w H047+$C2A
L047_00000BF8:
; H047+$00000BF8: 177c00010144  move.b #$1, $144(a3)
        move.b #$1, $144(a3)
L047_00000BFE:
; H047+$00000BFE: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000C00:
; H047+$00000C00: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_00000C04:
; H047+$00000C04: 0c420024  cmpi.w #$24, d2
        cmpi.w #$24, d2
L047_00000C08:
; H047+$00000C08: 65000008  bcs.w $c12
        bcs.w H047+$C12
L047_00000C0C:
; H047+$00000C0C: 177c00240142  move.b #$24, $142(a3)
        move.b #$24, $142(a3)
L047_00000C12:
; H047+$00000C12: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000C14:
; H047+$00000C14: 142b0141  move.b $141(a3), d2
        move.b $141(a3), d2
L047_00000C18:
; H047+$00000C18: 0c42000b  cmpi.w #$b, d2
        cmpi.w #$b, d2
L047_00000C1C:
; H047+$00000C1C: 65000008  bcs.w $c26
        bcs.w H047+$C26
L047_00000C20:
; H047+$00000C20: 177c000b0141  move.b #$b, $141(a3)
        move.b #$b, $141(a3)
L047_00000C26:
; H047+$00000C26: 60000008  bra.w $c30
        bra.w H047+$C30
L047_00000C2A:
; H047+$00000C2A: 177c00020144  move.b #$2, $144(a3)
        move.b #$2, $144(a3)
L047_00000C30:
; H047+$00000C30: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000C32:
; H047+$00000C32: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_00000C34:
; H047+$00000C34: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
L047_00000C3A:
; H047+$00000C3A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000C3C:
; H047+$00000C3C: 4e75  rts 
        rts 
L047_00000C3E:
; H047+$00000C3E: 4e75  rts 
        rts 
; Preserved bytes H047+$00000C40..$00000C88; code/data not fully classified.
        dc.w $FFFC,$FF1E,$FF62,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FEF6,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FF16,$FFFC,$FFFC,$FFA8
L047_00000C88:
; H047+$00000C88: 45faffb8  lea.l $c42(pc), a2
        lea.l H047+$C42(pc), a2
L047_00000C8C:
; H047+$00000C8C: 04420031  subi.w #$31, d2
        subi.w #$31, d2
L047_00000C90:
; H047+$00000C90: 0c420022  cmpi.w #$22, d2
        cmpi.w #$22, d2
L047_00000C94:
; H047+$00000C94: 6302  bls.b $c98
        bls.b H047+$C98
L047_00000C96:
; H047+$00000C96: 74ff  moveq #$ff, d2
        moveq #-1, d2
L047_00000C98:
; H047+$00000C98: e342  asl.w #$1, d2
        asl.w #$1, d2
L047_00000C9A:
; H047+$00000C9A: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: words relative to H047+$0C42; indices 0..34, default -1.
L047_00000C9E:
; H047+$00000C9E: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L047_00000CA2:
; H047+$00000CA2: 4e75  rts 
        rts 
L047_00000CA4:
; H047+$00000CA4: 3b7c0002ffdc  move.w #$2, -$24(a5)
        move.w #$2, -$24(a5)
L047_00000CAA:
; H047+$00000CAA: 0c2d0045fff7  cmpi.b #$45, -$9(a5)
        cmpi.b #$45, -$9(a5)
L047_00000CB0:
; H047+$00000CB0: 6700000a  beq.w $cbc
        beq.w H047+$CBC
L047_00000CB4:
; H047+$00000CB4: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L047_00000CB8:
; H047+$00000CB8: 6600000c  bne.w $cc6
        bne.w H047+$CC6
L047_00000CBC:
; H047+$00000CBC: 3b7c0001ffec  move.w #$1, -$14(a5)
        move.w #$1, -$14(a5)
L047_00000CC2:
; H047+$00000CC2: 60000020  bra.w $ce4
        bra.w H047+$CE4
L047_00000CC6:
; H047+$00000CC6: 1b6dfff7ffdb  move.b -$9(a5), -$25(a5)
        move.b -$9(a5), -$25(a5)
L047_00000CCC:
; H047+$00000CCC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000CCE:
; H047+$00000CCE: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000CD0:
; H047+$00000CD0: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00000CD2:
; H047+$00000CD2: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L047_00000CD6:
; H047+$00000CD6: 4855  pea.l (a5)
        pea.l (a5)
L047_00000CD8:
; H047+$00000CD8: 6100f714  bsr.w $3ee
        bsr.w H047+$3EE
L047_00000CDC:
; H047+$00000CDC: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000CDE:
; H047+$00000CDE: 3b7c0006ffec  move.w #$6, -$14(a5)
        move.w #$6, -$14(a5)
L047_00000CE4:
; H047+$00000CE4: 4e75  rts 
        rts 
L047_00000CE6:
; H047+$00000CE6: 3b7c0003ffdc  move.w #$3, -$24(a5)
        move.w #$3, -$24(a5)
L047_00000CEC:
; H047+$00000CEC: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000CEE:
; H047+$00000CEE: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L047_00000CF2:
; H047+$00000CF2: 60000072  bra.w $d66
        bra.w H047+$D66
L047_00000CF6:
; H047+$00000CF6: 3b7c0006ffe4  move.w #$6, -$1c(a5)
        move.w #$6, -$1c(a5)
L047_00000CFC:
; H047+$00000CFC: 4e75  rts 
        rts 
L047_00000CFE:
; H047+$00000CFE: 3b7c0001ffe4  move.w #$1, -$1c(a5)
        move.w #$1, -$1c(a5)
L047_00000D04:
; H047+$00000D04: 4e75  rts 
        rts 
L047_00000D06:
; H047+$00000D06: 3b7c0004ffe4  move.w #$4, -$1c(a5)
        move.w #$4, -$1c(a5)
L047_00000D0C:
; H047+$00000D0C: 4e75  rts 
        rts 
L047_00000D0E:
; H047+$00000D0E: 3b7c0004ffe4  move.w #$4, -$1c(a5)
        move.w #$4, -$1c(a5)
L047_00000D14:
; H047+$00000D14: 4e75  rts 
        rts 
L047_00000D16:
; H047+$00000D16: 3b7c0005ffe4  move.w #$5, -$1c(a5)
        move.w #$5, -$1c(a5)
L047_00000D1C:
; H047+$00000D1C: 4e75  rts 
        rts 
L047_00000D1E:
; H047+$00000D1E: 3b7c0002ffe4  move.w #$2, -$1c(a5)
        move.w #$2, -$1c(a5)
L047_00000D24:
; H047+$00000D24: 4e75  rts 
        rts 
L047_00000D26:
; H047+$00000D26: 3b7c0003ffe4  move.w #$3, -$1c(a5)
        move.w #$3, -$1c(a5)
L047_00000D2C:
; H047+$00000D2C: 4e75  rts 
        rts 
L047_00000D2E:
; H047+$00000D2E: 3b7c0001ffe4  move.w #$1, -$1c(a5)
        move.w #$1, -$1c(a5)
L047_00000D34:
; H047+$00000D34: 4e75  rts 
        rts 
; Preserved bytes H047+$00000D36..$00000D66; code/data not fully classified.
        dc.w $FFF6,$FFE6,$FFC6,$FFF6,$FFF6,$FFF6,$FFD6,$FFF6
        dc.w $FFCE,$FFF6,$FFF6,$FFF6,$FFEE,$FFF6,$FFF6,$FFF6
        dc.w $FFF6,$FFF6,$FFF6,$FFDE,$FFF6,$FFF6,$FFF6,$FFBE
L047_00000D66:
; H047+$00000D66: 45faffd0  lea.l $d38(pc), a2
        lea.l H047+$D38(pc), a2
L047_00000D6A:
; H047+$00000D6A: 04420041  subi.w #$41, d2
        subi.w #$41, d2
L047_00000D6E:
; H047+$00000D6E: 0c420016  cmpi.w #$16, d2
        cmpi.w #$16, d2
L047_00000D72:
; H047+$00000D72: 6302  bls.b $d76
        bls.b H047+$D76
L047_00000D74:
; H047+$00000D74: 74ff  moveq #$ff, d2
        moveq #-1, d2
L047_00000D76:
; H047+$00000D76: e342  asl.w #$1, d2
        asl.w #$1, d2
L047_00000D78:
; H047+$00000D78: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: words relative to H047+$0D38; indices 0..22, default -1.
L047_00000D7C:
; H047+$00000D7C: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L047_00000D80:
; H047+$00000D80: 0c2d0045fff7  cmpi.b #$45, -$9(a5)
        cmpi.b #$45, -$9(a5)
L047_00000D86:
; H047+$00000D86: 6700000a  beq.w $d92
        beq.w H047+$D92
L047_00000D8A:
; H047+$00000D8A: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L047_00000D8E:
; H047+$00000D8E: 6600000c  bne.w $d9c
        bne.w H047+$D9C
L047_00000D92:
; H047+$00000D92: 3b7c0001ffec  move.w #$1, -$14(a5)
        move.w #$1, -$14(a5)
L047_00000D98:
; H047+$00000D98: 60000008  bra.w $da2
        bra.w H047+$DA2
L047_00000D9C:
; H047+$00000D9C: 3b7c0005ffec  move.w #$5, -$14(a5)
        move.w #$5, -$14(a5)
L047_00000DA2:
; H047+$00000DA2: 4e75  rts 
        rts 
L047_00000DA4:
; H047+$00000DA4: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000DA6:
; H047+$00000DA6: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L047_00000DAA:
; H047+$00000DAA: 60000104  bra.w $eb0
        bra.w H047+$EB0
L047_00000DAE:
; H047+$00000DAE: 177c00020144  move.b #$2, $144(a3)
        move.b #$2, $144(a3)
L047_00000DB4:
; H047+$00000DB4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000DB6:
; H047+$00000DB6: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_00000DB8:
; H047+$00000DB8: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
L047_00000DBE:
; H047+$00000DBE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000DC0:
; H047+$00000DC0: 4e75  rts 
        rts 
L047_00000DC2:
; H047+$00000DC2: 177c00010144  move.b #$1, $144(a3)
        move.b #$1, $144(a3)
L047_00000DC8:
; H047+$00000DC8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000DCA:
; H047+$00000DCA: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_00000DCC:
; H047+$00000DCC: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
L047_00000DD2:
; H047+$00000DD2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000DD4:
; H047+$00000DD4: 4e75  rts 
        rts 
L047_00000DD6:
; H047+$00000DD6: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000DD8:
; H047+$00000DD8: 142b0144  move.b $144(a3), d2
        move.b $144(a3), d2
L047_00000DDC:
; H047+$00000DDC: 3b42fff0  move.w d2, -$10(a5)
        move.w d2, -$10(a5)
L047_00000DE0:
; H047+$00000DE0: 3b7c0001ffec  move.w #$1, -$14(a5)
        move.w #$1, -$14(a5)
L047_00000DE6:
; H047+$00000DE6: 1b7c0020fff7  move.b #$20, -$9(a5)
        move.b #$20, -$9(a5)
L047_00000DEC:
; H047+$00000DEC: 4e75  rts 
        rts 
L047_00000DEE:
; H047+$00000DEE: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L047_00000DF2:
; H047+$00000DF2: 17420144  move.b d2, $144(a3)
        move.b d2, $144(a3)
L047_00000DF6:
; H047+$00000DF6: 3b7c0001ffec  move.w #$1, -$14(a5)
        move.w #$1, -$14(a5)
L047_00000DFC:
; H047+$00000DFC: 1b7c0020fff7  move.b #$20, -$9(a5)
        move.b #$20, -$9(a5)
L047_00000E02:
; H047+$00000E02: 4e75  rts 
        rts 
L047_00000E04:
; H047+$00000E04: 4e75  rts 
        rts 
; Preserved bytes H047+$00000E06..$00000EB0; code/data not fully classified.
        dc.w $FFFC,$FFE6,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFE6,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFCE,$FFA6,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFBA
L047_00000EB0:
; H047+$00000EB0: 45faff56  lea.l $e08(pc), a2
        lea.l H047+$E08(pc), a2
L047_00000EB4:
; H047+$00000EB4: 0c420053  cmpi.w #$53, d2
        cmpi.w #$53, d2
L047_00000EB8:
; H047+$00000EB8: 6302  bls.b $ebc
        bls.b H047+$EBC
L047_00000EBA:
; H047+$00000EBA: 74ff  moveq #$ff, d2
        moveq #-1, d2
L047_00000EBC:
; H047+$00000EBC: e342  asl.w #$1, d2
        asl.w #$1, d2
L047_00000EBE:
; H047+$00000EBE: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: words relative to H047+$0E08; indices 0..83, default -1.
L047_00000EC2:
; H047+$00000EC2: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L047_00000EC6:
; H047+$00000EC6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000EC8:
; H047+$00000EC8: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_00000ECA:
; H047+$00000ECA: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
L047_00000ED0:
; H047+$00000ED0: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000ED2:
; H047+$00000ED2: 4e75  rts 
        rts 
L047_00000ED4:
; H047+$00000ED4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000ED6:
; H047+$00000ED6: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L047_00000EDA:
; H047+$00000EDA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000EDC:
; H047+$00000EDC: 45eb0146  lea.l $146(a3), a2
        lea.l $146(a3), a2
L047_00000EE0:
; H047+$00000EE0: 1f322000  move.b (a2, d2.w), -(a7)
        move.b (a2, d2.w), -(a7)
L047_00000EE4:
; H047+$00000EE4: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L047_00000EE8:
; H047+$00000EE8: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L047_00000EEE:
; H047+$00000EEE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000EF0:
; H047+$00000EF0: 1400  move.b d0, d2
        move.b d0, d2
L047_00000EF2:
; H047+$00000EF2: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L047_00000EF6:
; H047+$00000EF6: 3b42ffe0  move.w d2, -$20(a5)
        move.w d2, -$20(a5)
L047_00000EFA:
; H047+$00000EFA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000EFC:
; H047+$00000EFC: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L047_00000F00:
; H047+$00000F00: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000F02:
; H047+$00000F02: 45eb0146  lea.l $146(a3), a2
        lea.l $146(a3), a2
L047_00000F06:
; H047+$00000F06: 1f322000  move.b (a2, d2.w), -(a7)
        move.b (a2, d2.w), -(a7)
L047_00000F0A:
; H047+$00000F0A: 3f3c00f0  move.w #$f0, -(a7)
        move.w #$f0, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L047_00000F0E:
; H047+$00000F0E: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L047_00000F14:
; H047+$00000F14: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000F16:
; H047+$00000F16: 1400  move.b d0, d2
        move.b d0, d2
L047_00000F18:
; H047+$00000F18: e80a  lsr.b #$4, d2
        lsr.b #$4, d2
L047_00000F1A:
; H047+$00000F1A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L047_00000F1E:
; H047+$00000F1E: 3b42ffde  move.w d2, -$22(a5)
        move.w d2, -$22(a5)
L047_00000F22:
; H047+$00000F22: 7400  moveq #$0, d2
        moveq #0, d2
L047_00000F24:
; H047+$00000F24: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L047_00000F28:
; H047+$00000F28: 60000194  bra.w $10be
        bra.w H047+$10BE
L047_00000F2C:
; H047+$00000F2C: 4a2dffe3  tst.b -$1d(a5)
        tst.b -$1d(a5)
L047_00000F30:
; H047+$00000F30: 6700001a  beq.w $f4c
        beq.w H047+$F4C
L047_00000F34:
; H047+$00000F34: 342dffde  move.w -$22(a5), d2
        move.w -$22(a5), d2
L047_00000F38:
; H047+$00000F38: 5242  addq.w #$1, d2
        addq.w #$1, d2
L047_00000F3A:
; H047+$00000F3A: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L047_00000F40:
; H047+$00000F40: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L047_00000F44:
; H047+$00000F44: 3b42ffde  move.w d2, -$22(a5)
        move.w d2, -$22(a5)
L047_00000F48:
; H047+$00000F48: 60000016  bra.w $f60
        bra.w H047+$F60
L047_00000F4C:
; H047+$00000F4C: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L047_00000F50:
; H047+$00000F50: 5242  addq.w #$1, d2
        addq.w #$1, d2
L047_00000F52:
; H047+$00000F52: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L047_00000F58:
; H047+$00000F58: 0242000f  andi.w #$f, d2
        andi.w #$f, d2
L047_00000F5C:
; H047+$00000F5C: 3b42ffe0  move.w d2, -$20(a5)
        move.w d2, -$20(a5)
L047_00000F60:
; H047+$00000F60: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L047_00000F64:
; H047+$00000F64: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000F66:
; H047+$00000F66: 45eb0146  lea.l $146(a3), a2
        lea.l $146(a3), a2
L047_00000F6A:
; H047+$00000F6A: 382dffde  move.w -$22(a5), d4
        move.w -$22(a5), d4
L047_00000F6E:
; H047+$00000F6E: e94c  lsl.w #$4, d4
        lsl.w #$4, d4
L047_00000F70:
; H047+$00000F70: d86dffe0  add.w -$20(a5), d4
        add.w -$20(a5), d4
L047_00000F74:
; H047+$00000F74: 15842000  move.b d4, (a2, d2.w)
        move.b d4, (a2, d2.w)
L047_00000F78:
; H047+$00000F78: 4e75  rts 
        rts 
L047_00000F7A:
; H047+$00000F7A: 4a2dffe3  tst.b -$1d(a5)
        tst.b -$1d(a5)
L047_00000F7E:
; H047+$00000F7E: 67000026  beq.w $fa6
        beq.w H047+$FA6
L047_00000F82:
; H047+$00000F82: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000F84:
; H047+$00000F84: 342dffde  move.w -$22(a5), d2
        move.w -$22(a5), d2
L047_00000F88:
; H047+$00000F88: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000F8A:
; H047+$00000F8A: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L047_00000F8C:
; H047+$00000F8C: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L047_00000F90:
; H047+$00000F90: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L047_00000F96:
; H047+$00000F96: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000F98:
; H047+$00000F98: 1400  move.b d0, d2
        move.b d0, d2
L047_00000F9A:
; H047+$00000F9A: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L047_00000F9E:
; H047+$00000F9E: 3b42ffde  move.w d2, -$22(a5)
        move.w d2, -$22(a5)
L047_00000FA2:
; H047+$00000FA2: 60000022  bra.w $fc6
        bra.w H047+$FC6
L047_00000FA6:
; H047+$00000FA6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00000FA8:
; H047+$00000FA8: 342dffe0  move.w -$20(a5), d2
        move.w -$20(a5), d2
L047_00000FAC:
; H047+$00000FAC: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000FAE:
; H047+$00000FAE: 1f02  move.b d2, -(a7)
        move.b d2, -(a7)
L047_00000FB0:
; H047+$00000FB0: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H029+$0354 (trampoline_H029_036C)
L047_00000FB4:
; H047+$00000FB4: 4eb900000354  jsr $354.l
        jsr (H029+$354).l
L047_00000FBA:
; H047+$00000FBA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00000FBC:
; H047+$00000FBC: 1400  move.b d0, d2
        move.b d0, d2
L047_00000FBE:
; H047+$00000FBE: 024200ff  andi.w #$ff, d2
        andi.w #$ff, d2
L047_00000FC2:
; H047+$00000FC2: 3b42ffe0  move.w d2, -$20(a5)
        move.w d2, -$20(a5)
L047_00000FC6:
; H047+$00000FC6: 342dffe4  move.w -$1c(a5), d2
        move.w -$1c(a5), d2
L047_00000FCA:
; H047+$00000FCA: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00000FCC:
; H047+$00000FCC: 45eb0146  lea.l $146(a3), a2
        lea.l $146(a3), a2
L047_00000FD0:
; H047+$00000FD0: 382dffde  move.w -$22(a5), d4
        move.w -$22(a5), d4
L047_00000FD4:
; H047+$00000FD4: e94c  lsl.w #$4, d4
        lsl.w #$4, d4
L047_00000FD6:
; H047+$00000FD6: d86dffe0  add.w -$20(a5), d4
        add.w -$20(a5), d4
L047_00000FDA:
; H047+$00000FDA: 15842000  move.b d4, (a2, d2.w)
        move.b d4, (a2, d2.w)
L047_00000FDE:
; H047+$00000FDE: 4e75  rts 
        rts 
L047_00000FE0:
; H047+$00000FE0: 45eb0146  lea.l $146(a3), a2
        lea.l $146(a3), a2
L047_00000FE4:
; H047+$00000FE4: 43edffe6  lea.l -$1a(a5), a1
        lea.l -$1a(a5), a1
L047_00000FE8:
; H047+$00000FE8: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_00000FEA:
; H047+$00000FEA: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_00000FEC:
; H047+$00000FEC: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_00000FEE:
; H047+$00000FEE: 3b6dffdcffec  move.w -$24(a5), -$14(a5)
        move.w -$24(a5), -$14(a5)
L047_00000FF4:
; H047+$00000FF4: 1b7c0020fff7  move.b #$20, -$9(a5)
        move.b #$20, -$9(a5)
L047_00000FFA:
; H047+$00000FFA: 4e75  rts 
        rts 
L047_00000FFC:
; H047+$00000FFC: 45edffe6  lea.l -$1a(a5), a2
        lea.l -$1a(a5), a2
L047_00001000:
; H047+$00001000: 43eb0146  lea.l $146(a3), a1
        lea.l $146(a3), a1
L047_00001004:
; H047+$00001004: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_00001006:
; H047+$00001006: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_00001008:
; H047+$00001008: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_0000100A:
; H047+$0000100A: 3b6dffdcffec  move.w -$24(a5), -$14(a5)
        move.w -$24(a5), -$14(a5)
L047_00001010:
; H047+$00001010: 1b7c0020fff7  move.b #$20, -$9(a5)
        move.b #$20, -$9(a5)
L047_00001016:
; H047+$00001016: 4e75  rts 
        rts 
L047_00001018:
; H047+$00001018: 4e75  rts 
        rts 
; Preserved bytes H047+$0000101A..$000010BE; code/data not fully classified.
        dc.w $FFFC,$FFE0,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFE0,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFC4,$FFFC,$FFFC,$FF10
        dc.w $FFFC,$FF5E
L047_000010BE:
; H047+$000010BE: 45faff5c  lea.l $101c(pc), a2
        lea.l H047+$101C(pc), a2
L047_000010C2:
; H047+$000010C2: 0c420050  cmpi.w #$50, d2
        cmpi.w #$50, d2
L047_000010C6:
; H047+$000010C6: 6302  bls.b $10ca
        bls.b H047+$10CA
L047_000010C8:
; H047+$000010C8: 74ff  moveq #$ff, d2
        moveq #-1, d2
L047_000010CA:
; H047+$000010CA: e342  asl.w #$1, d2
        asl.w #$1, d2
L047_000010CC:
; H047+$000010CC: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: words relative to H047+$101C; indices 0..80, default -1.
L047_000010D0:
; H047+$000010D0: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L047_000010D4:
; H047+$000010D4: 4e75  rts 
        rts 
L047_000010D6:
; H047+$000010D6: 7400  moveq #$0, d2
        moveq #0, d2
L047_000010D8:
; H047+$000010D8: 142dfff7  move.b -$9(a5), d2
        move.b -$9(a5), d2
L047_000010DC:
; H047+$000010DC: 6000020e  bra.w $12ec
        bra.w H047+$12EC
L047_000010E0:
; H047+$000010E0: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000010E2:
; H047+$000010E2: 3f3cffff  move.w #$ffff, -(a7)
        move.w #$ffff, -(a7)
L047_000010E6:
; H047+$000010E6: 3f3cffff  move.w #$ffff, -(a7)
        move.w #$ffff, -(a7)
L047_000010EA:
; H047+$000010EA: 4227  clr.b -(a7)
        clr.b -(a7)
L047_000010EC:
; H047+$000010EC: 4855  pea.l (a5)
        pea.l (a5)
L047_000010EE:
; H047+$000010EE: 6100f2fe  bsr.w $3ee
        bsr.w H047+$3EE
L047_000010F2:
; H047+$000010F2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000010F4:
; H047+$000010F4: 4e75  rts 
        rts 
L047_000010F6:
; H047+$000010F6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000010F8:
; H047+$000010F8: 4267  clr.w -(a7)
        clr.w -(a7)
L047_000010FA:
; H047+$000010FA: 3f3cffff  move.w #$ffff, -(a7)
        move.w #$ffff, -(a7)
L047_000010FE:
; H047+$000010FE: 4227  clr.b -(a7)
        clr.b -(a7)
L047_00001100:
; H047+$00001100: 4855  pea.l (a5)
        pea.l (a5)
L047_00001102:
; H047+$00001102: 6100f2ea  bsr.w $3ee
        bsr.w H047+$3EE
L047_00001106:
; H047+$00001106: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00001108:
; H047+$00001108: 4e75  rts 
        rts 
L047_0000110A:
; H047+$0000110A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_0000110C:
; H047+$0000110C: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_00001110:
; H047+$00001110: 3f3cffff  move.w #$ffff, -(a7)
        move.w #$ffff, -(a7)
L047_00001114:
; H047+$00001114: 4227  clr.b -(a7)
        clr.b -(a7)
L047_00001116:
; H047+$00001116: 4855  pea.l (a5)
        pea.l (a5)
L047_00001118:
; H047+$00001118: 6100f2d4  bsr.w $3ee
        bsr.w H047+$3EE
L047_0000111C:
; H047+$0000111C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000111E:
; H047+$0000111E: 4e75  rts 
        rts 
L047_00001120:
; H047+$00001120: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00001122:
; H047+$00001122: 3f3cffff  move.w #$ffff, -(a7)
        move.w #$ffff, -(a7)
L047_00001126:
; H047+$00001126: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00001128:
; H047+$00001128: 4227  clr.b -(a7)
        clr.b -(a7)
L047_0000112A:
; H047+$0000112A: 4855  pea.l (a5)
        pea.l (a5)
L047_0000112C:
; H047+$0000112C: 6100f2c0  bsr.w $3ee
        bsr.w H047+$3EE
L047_00001130:
; H047+$00001130: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00001132:
; H047+$00001132: 4e75  rts 
        rts 
L047_00001134:
; H047+$00001134: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00001136:
; H047+$00001136: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_0000113A:
; H047+$0000113A: 4267  clr.w -(a7)
        clr.w -(a7)
L047_0000113C:
; H047+$0000113C: 4227  clr.b -(a7)
        clr.b -(a7)
L047_0000113E:
; H047+$0000113E: 4855  pea.l (a5)
        pea.l (a5)
L047_00001140:
; H047+$00001140: 6100f2ac  bsr.w $3ee
        bsr.w H047+$3EE
L047_00001144:
; H047+$00001144: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00001146:
; H047+$00001146: 4e75  rts 
        rts 
L047_00001148:
; H047+$00001148: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_0000114A:
; H047+$0000114A: 3f3cffff  move.w #$ffff, -(a7)
        move.w #$ffff, -(a7)
L047_0000114E:
; H047+$0000114E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_00001152:
; H047+$00001152: 4227  clr.b -(a7)
        clr.b -(a7)
L047_00001154:
; H047+$00001154: 4855  pea.l (a5)
        pea.l (a5)
L047_00001156:
; H047+$00001156: 6100f296  bsr.w $3ee
        bsr.w H047+$3EE
L047_0000115A:
; H047+$0000115A: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000115C:
; H047+$0000115C: 4e75  rts 
        rts 
L047_0000115E:
; H047+$0000115E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00001160:
; H047+$00001160: 4267  clr.w -(a7)
        clr.w -(a7)
L047_00001162:
; H047+$00001162: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_00001166:
; H047+$00001166: 4227  clr.b -(a7)
        clr.b -(a7)
L047_00001168:
; H047+$00001168: 4855  pea.l (a5)
        pea.l (a5)
L047_0000116A:
; H047+$0000116A: 6100f282  bsr.w $3ee
        bsr.w H047+$3EE
L047_0000116E:
; H047+$0000116E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00001170:
; H047+$00001170: 4e75  rts 
        rts 
L047_00001172:
; H047+$00001172: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00001174:
; H047+$00001174: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_00001178:
; H047+$00001178: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L047_0000117C:
; H047+$0000117C: 4227  clr.b -(a7)
        clr.b -(a7)
L047_0000117E:
; H047+$0000117E: 4855  pea.l (a5)
        pea.l (a5)
L047_00001180:
; H047+$00001180: 6100f26c  bsr.w $3ee
        bsr.w H047+$3EE
L047_00001184:
; H047+$00001184: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00001186:
; H047+$00001186: 4e75  rts 
        rts 
L047_00001188:
; H047+$00001188: 4a390000249e  tst.b $249e.l
        tst.b (H005+$249E).l
L047_0000118E:
; H047+$0000118E: 6700005a  beq.w $11ea
        beq.w H047+$11EA
; STATE: H005+$2356 = mouse X coordinate
L047_00001192:
; H047+$00001192: 0c79002800002356  cmpi.w #$28, $2356.l
        cmpi.w #$28, (H005+$2356).l
L047_0000119A:
; H047+$0000119A: 6c000018  bge.w $11b4
        bge.w H047+$11B4
; STATE: H005+$2354 = mouse Y coordinate
L047_0000119E:
; H047+$0000119E: 0c7900c000002354  cmpi.w #$c0, $2354.l
        cmpi.w #$c0, (H005+$2354).l
L047_000011A6:
; H047+$000011A6: 6d00000c  blt.w $11b4
        blt.w H047+$11B4
L047_000011AA:
; H047+$000011AA: 1b7c0001fed7  move.b #$1, -$129(a5)
        move.b #$1, -$129(a5)
L047_000011B0:
; H047+$000011B0: 60000034  bra.w $11e6
        bra.w H047+$11E6
L047_000011B4:
; H047+$000011B4: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000011B6:
; H047+$000011B6: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L047_000011BA:
; H047+$000011BA: 486dfff8  pea.l -$8(a5)
        pea.l -$8(a5)
L047_000011BE:
; H047+$000011BE: 486dfed7  pea.l -$129(a5)
        pea.l -$129(a5)
L047_000011C2:
; H047+$000011C2: 4855  pea.l (a5)
        pea.l (a5)
L047_000011C4:
; H047+$000011C4: 6100f028  bsr.w $1ee
        bsr.w H047+$1EE
L047_000011C8:
; H047+$000011C8: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000011CA:
; H047+$000011CA: 4a2dfed7  tst.b -$129(a5)
        tst.b -$129(a5)
L047_000011CE:
; H047+$000011CE: 66000016  bne.w $11e6
        bne.w H047+$11E6
L047_000011D2:
; H047+$000011D2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000011D4:
; H047+$000011D4: 3f2dfffa  move.w -$6(a5), -(a7)
        move.w -$6(a5), -(a7)
L047_000011D8:
; H047+$000011D8: 3f2dfff8  move.w -$8(a5), -(a7)
        move.w -$8(a5), -(a7)
L047_000011DC:
; H047+$000011DC: 4227  clr.b -(a7)
        clr.b -(a7)
L047_000011DE:
; H047+$000011DE: 4855  pea.l (a5)
        pea.l (a5)
L047_000011E0:
; H047+$000011E0: 6100f20c  bsr.w $3ee
        bsr.w H047+$3EE
L047_000011E4:
; H047+$000011E4: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000011E6:
; H047+$000011E6: 60000008  bra.w $11f0
        bra.w H047+$11F0
L047_000011EA:
; H047+$000011EA: 1b7c0001fed7  move.b #$1, -$129(a5)
        move.b #$1, -$129(a5)
L047_000011F0:
; H047+$000011F0: 4a2dfed7  tst.b -$129(a5)
        tst.b -$129(a5)
L047_000011F4:
; H047+$000011F4: 67000028  beq.w $121e
        beq.w H047+$121E
L047_000011F8:
; H047+$000011F8: 0c2d0048ffdb  cmpi.b #$48, -$25(a5)
        cmpi.b #$48, -$25(a5)
L047_000011FE:
; H047+$000011FE: 66000010  bne.w $1210
        bne.w H047+$1210
L047_00001202:
; H047+$00001202: 7400  moveq #$0, d2
        moveq #0, d2
L047_00001204:
; H047+$00001204: 142b0141  move.b $141(a3), d2
        move.b $141(a3), d2
L047_00001208:
; H047+$00001208: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L047_0000120C:
; H047+$0000120C: 6000000c  bra.w $121a
        bra.w H047+$121A
L047_00001210:
; H047+$00001210: 7400  moveq #$0, d2
        moveq #0, d2
L047_00001212:
; H047+$00001212: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_00001216:
; H047+$00001216: 3b42fff2  move.w d2, -$e(a5)
        move.w d2, -$e(a5)
L047_0000121A:
; H047+$0000121A: 426dffec  clr.w -$14(a5)
        clr.w -$14(a5)
L047_0000121E:
; H047+$0000121E: 4e75  rts 
        rts 
L047_00001220:
; H047+$00001220: 0c2d0048ffdb  cmpi.b #$48, -$25(a5)
        cmpi.b #$48, -$25(a5)
L047_00001226:
; H047+$00001226: 6600000e  bne.w $1236
        bne.w H047+$1236
L047_0000122A:
; H047+$0000122A: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L047_0000122E:
; H047+$0000122E: 17420141  move.b d2, $141(a3)
        move.b d2, $141(a3)
L047_00001232:
; H047+$00001232: 6000000a  bra.w $123e
        bra.w H047+$123E
L047_00001236:
; H047+$00001236: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L047_0000123A:
; H047+$0000123A: 17420142  move.b d2, $142(a3)
        move.b d2, $142(a3)
L047_0000123E:
; H047+$0000123E: 426dffec  clr.w -$14(a5)
        clr.w -$14(a5)
L047_00001242:
; H047+$00001242: 4e75  rts 
        rts 
L047_00001244:
; H047+$00001244: 4e75  rts 
        rts 
; Preserved bytes H047+$00001246..$000012EC; code/data not fully classified.
        dc.w $FFFC,$FFD8,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FF40,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FFFC
        dc.w $FFFC,$FFFC,$FFFC,$FFFC,$FFFC,$FF40,$FFFC,$FFFC
        dc.w $FE98,$FEAE,$FEC2,$FFFC,$FED8,$FFFC,$FEEC,$FFFC
        dc.w $FF00,$FF16,$FF2A
L047_000012EC:
; H047+$000012EC: 45faff5a  lea.l $1248(pc), a2
        lea.l H047+$1248(pc), a2
L047_000012F0:
; H047+$000012F0: 0c420051  cmpi.w #$51, d2
        cmpi.w #$51, d2
L047_000012F4:
; H047+$000012F4: 6302  bls.b $12f8
        bls.b H047+$12F8
L047_000012F6:
; H047+$000012F6: 74ff  moveq #$ff, d2
        moveq #-1, d2
L047_000012F8:
; H047+$000012F8: e342  asl.w #$1, d2
        asl.w #$1, d2
L047_000012FA:
; H047+$000012FA: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: words relative to H047+$1248; indices 0..81, default -1.
L047_000012FE:
; H047+$000012FE: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L047_00001302:
; H047+$00001302: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00001304:
; H047+$00001304: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H066+$0C34 (trampoline_H066_0E5A)
L047_00001306:
; H047+$00001306: 4eb900000c34  jsr $c34.l
        jsr (H066+$C34).l
L047_0000130C:
; H047+$0000130C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_0000130E:
; H047+$0000130E: 4a6dffec  tst.w -$14(a5)
        tst.w -$14(a5)
L047_00001312:
; H047+$00001312: 66000048  bne.w $135c
        bne.w H047+$135C
L047_00001316:
; H047+$00001316: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00001318:
; H047+$00001318: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L047_0000131C:
; H047+$0000131C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L047_00001320:
; H047+$00001320: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
L047_00001324:
; H047+$00001324: 3f3c0012  move.w #$12, -(a7)
        move.w #$12, -(a7)
L047_00001328:
; H047+$00001328: 4227  clr.b -(a7)
        clr.b -(a7)
L047_0000132A:
; H047+$0000132A: 2f3900003d8e  move.l $3d8e.l, -(a7)
        move.l (H005+$3D8E).l, -(a7)
; -> H029+$10B8 (sub_H029_000010B8)
L047_00001330:
; H047+$00001330: 4eb9000010b8  jsr $10b8.l
        jsr (H029+$10B8).l
L047_00001336:
; H047+$00001336: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_00001338:
; H047+$00001338: 7400  moveq #$0, d2
        moveq #0, d2
L047_0000133A:
; H047+$0000133A: 142b0142  move.b $142(a3), d2
        move.b $142(a3), d2
L047_0000133E:
; H047+$0000133E: 0c420020  cmpi.w #$20, d2
        cmpi.w #$20, d2
L047_00001342:
; H047+$00001342: 6500000c  bcs.w $1350
        bcs.w H047+$1350
L047_00001346:
; H047+$00001346: 3b7c0001ffec  move.w #$1, -$14(a5)
        move.w #$1, -$14(a5)
L047_0000134C:
; H047+$0000134C: 60000008  bra.w $1356
        bra.w H047+$1356
L047_00001350:
; H047+$00001350: 3b7c0002ffec  move.w #$2, -$14(a5)
        move.w #$2, -$14(a5)
L047_00001356:
; H047+$00001356: 1b7c0020fff7  move.b #$20, -$9(a5)
        move.b #$20, -$9(a5)
L047_0000135C:
; H047+$0000135C: 4e75  rts 
        rts 
L047_0000135E:
; H047+$0000135E: 4e75  rts 
        rts 
; Preserved bytes H047+$00001360..$0000136E; code/data not fully classified.
        dc.w $FFFC,$F7C6,$F942,$F984,$FA42,$FB72,$FD74
L047_0000136E:
; H047+$0000136E: 45fafff2  lea.l $1362(pc), a2
        lea.l H047+$1362(pc), a2
L047_00001372:
; H047+$00001372: 5342  subq.w #$1, d2
        subq.w #$1, d2
L047_00001374:
; H047+$00001374: 0c420005  cmpi.w #$5, d2
        cmpi.w #$5, d2
L047_00001378:
; H047+$00001378: 6302  bls.b $137c
        bls.b H047+$137C
L047_0000137A:
; H047+$0000137A: 74ff  moveq #$ff, d2
        moveq #-1, d2
L047_0000137C:
; H047+$0000137C: e342  asl.w #$1, d2
        asl.w #$1, d2
L047_0000137E:
; H047+$0000137E: 34322000  move.w (a2, d2.w), d2
        move.w (a2, d2.w), d2
; DISPATCH: words relative to H047+$1362; indices 0..5, default -1.
L047_00001382:
; H047+$00001382: 4eb22000  jsr (a2, d2.w)
        jsr (a2, d2.w)
L047_00001386:
; H047+$00001386: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_00001388:
; H047+$00001388: 7400  moveq #$0, d2
        moveq #0, d2
L047_0000138A:
; H047+$0000138A: 142b0143  move.b $143(a3), d2
        move.b $143(a3), d2
L047_0000138E:
; H047+$0000138E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_00001390:
; H047+$00001390: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L047_00001394:
; H047+$00001394: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L047_00001398:
; H047+$00001398: 4855  pea.l (a5)
        pea.l (a5)
L047_0000139A:
; H047+$0000139A: 6100f2ec  bsr.w $688
        bsr.w H047+$688
L047_0000139E:
; H047+$0000139E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000013A0:
; H047+$000013A0: 0c6d0001ffdc  cmpi.w #$1, -$24(a5)
        cmpi.w #$1, -$24(a5)
L047_000013A6:
; H047+$000013A6: 6600f6c8  bne.w $a70
        bne.w H047+$A70
L047_000013AA:
; H047+$000013AA: 0c2d0045fff7  cmpi.b #$45, -$9(a5)
        cmpi.b #$45, -$9(a5)
L047_000013B0:
; H047+$000013B0: 6700000a  beq.w $13bc
        beq.w H047+$13BC
L047_000013B4:
; H047+$000013B4: 4a2dfff7  tst.b -$9(a5)
        tst.b -$9(a5)
L047_000013B8:
; H047+$000013B8: 6600f6b6  bne.w $a70
        bne.w H047+$A70
L047_000013BC:
; H047+$000013BC: 342dfff4  move.w -$c(a5), d2
        move.w -$c(a5), d2
L047_000013C0:
; H047+$000013C0: 17420141  move.b d2, $141(a3)
        move.b d2, $141(a3)
L047_000013C4:
; H047+$000013C4: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L047_000013C8:
; H047+$000013C8: 17420142  move.b d2, $142(a3)
        move.b d2, $142(a3)
L047_000013CC:
; H047+$000013CC: 342dfff0  move.w -$10(a5), d2
        move.w -$10(a5), d2
L047_000013D0:
; H047+$000013D0: 17420144  move.b d2, $144(a3)
        move.b d2, $144(a3)
L047_000013D4:
; H047+$000013D4: 45edffe6  lea.l -$1a(a5), a2
        lea.l -$1a(a5), a2
L047_000013D8:
; H047+$000013D8: 43eb0146  lea.l $146(a3), a1
        lea.l $146(a3), a1
L047_000013DC:
; H047+$000013DC: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_000013DE:
; H047+$000013DE: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_000013E0:
; H047+$000013E0: 32da  move.w (a2)+, (a1)+
        move.w (a2)+, (a1)+
L047_000013E2:
; H047+$000013E2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000013E4:
; H047+$000013E4: 7400  moveq #$0, d2
        moveq #0, d2
L047_000013E6:
; H047+$000013E6: 142b0143  move.b $143(a3), d2
        move.b $143(a3), d2
L047_000013EA:
; H047+$000013EA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_000013EC:
; H047+$000013EC: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L047_000013F0:
; H047+$000013F0: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L047_000013F4:
; H047+$000013F4: 4855  pea.l (a5)
        pea.l (a5)
L047_000013F6:
; H047+$000013F6: 6100f290  bsr.w $688
        bsr.w H047+$688
L047_000013FA:
; H047+$000013FA: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L047_000013FC:
; H047+$000013FC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L047_000013FE:
; H047+$000013FE: 3f3c000c  move.w #$c, -(a7)
        move.w #$c, -(a7)
L047_00001402:
; H047+$00001402: 7400  moveq #$0, d2
        moveq #0, d2
L047_00001404:
; H047+$00001404: 142b0143  move.b $143(a3), d2
        move.b $143(a3), d2
L047_00001408:
; H047+$00001408: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L047_0000140A:
; H047+$0000140A: 4227  clr.b -(a7)
        clr.b -(a7)
L047_0000140C:
; H047+$0000140C: 4855  pea.l (a5)
        pea.l (a5)
L047_0000140E:
; H047+$0000140E: 6100f278  bsr.w $688
        bsr.w H047+$688
L047_00001412:
; H047+$00001412: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
; -> H008+$139E (sub_H008_0000139E)
L047_00001414:
; H047+$00001414: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
L047_0000141A:
; H047+$0000141A: 1f3c000c  move.b #$c, -(a7)
        move.b #$c, -(a7)
; -> H035+$01DC (sub_H035_000001DC)
L047_0000141E:
; H047+$0000141E: 4eb9000001dc  jsr $1dc.l
        jsr (H035+$1DC).l
L047_00001424:
; H047+$00001424: 3f3c0011  move.w #$11, -(a7)
        move.w #$11, -(a7)
L047_00001428:
; H047+$00001428: 486c00bf  pea.l $bf(a4)
        pea.l $bf(a4)
L047_0000142C:
; H047+$0000142C: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L047_00001430:
; H047+$00001430: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L047_00001434:
; H047+$00001434: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
; -> H008+$203C (sub_H008_0000203C)
L047_00001438:
; H047+$00001438: 4eb90000203c  jsr $203c.l
        jsr (H008+$203C).l
L047_0000143E:
; H047+$0000143E: 1b40fff7  move.b d0, -$9(a5)
        move.b d0, -$9(a5)
L047_00001442:
; H047+$00001442: 0c2d0059fff7  cmpi.b #$59, -$9(a5)
        cmpi.b #$59, -$9(a5)
L047_00001448:
; H047+$00001448: 6600f516  bne.w $960
        bne.w H047+$960
; STATE: H005+$3DE3 = native context, 5 in combat
L047_0000144C:
; H047+$0000144C: 13edffff00003de3  move.b -$1(a5), $3de3.l
        move.b -$1(a5), (H005+$3DE3).l
L047_00001454:
; H047+$00001454: 422cffff  clr.b -$1(a4)
        clr.b -$1(a4)
L047_00001458:
; H047+$00001458: 4e5d  unlk a5
        unlk a5
L047_0000145A:
; H047+$0000145A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L047_0000145C:
; H047+$0000145C: 4e75  rts 
        rts 
L047_0000145E:
; H047+$0000145E: 422cffff  clr.b -$1(a4)
        clr.b -$1(a4)
L047_00001462:
; H047+$00001462: 4e5d  unlk a5
        unlk a5
L047_00001464:
; H047+$00001464: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L047_00001466:
; H047+$00001466: 4e75  rts 
        rts 
; End H047: $1468 bytes
