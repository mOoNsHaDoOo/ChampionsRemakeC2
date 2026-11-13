; ============================================================================
; MODULE GUIDE H086
; Generic IFF parser: chunks and FORM/LIST/PROP/CAT groups.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Generic IFF parser: walks FORM/LIST/PROP/CAT and calls the callbacks registered by the caller.
; --------------------------------------------------------------------------
; H086: 2088 original bytes; all offsets are section-relative.
        section H086,code
H086:
; Preserved bytes H086+$00000000..$00000004; code/data not fully classified.
        dc.l H086+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H086_0822 [partial]
; Purpose: Trampoline to H086+$0822; the actual body is there.
;   - Jumps to the actual body at H086+$0822.
; Direct callers: H000+$00C6
; --------------------------------------------------------------------------
L086_00000004:
; H086+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L086_00000008:
; H086+$00000008: 60000818  bra.w $822
        bra.w H086+$822
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_0000000C [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; calls H098+$0276.
;   - Calls H098+$0276.
; Direct callers: H086+$00F2
; --------------------------------------------------------------------------
L086_0000000C:
; H086+$0000000C: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L086_00000010:
; H086+$00000010: 2b7cfffffffbfffc  move.l #$fffffffb, -$4(a5)
        move.l #$fffffffb, -$4(a5)
L086_00000018:
; H086+$00000018: 4aad0008  tst.l $8(a5)
        tst.l $8(a5)
L086_0000001C:
; H086+$0000001C: 6300003a  bls.w $58
        bls.w H086+$58
L086_00000020:
; H086+$00000020: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_00000024:
; H086+$00000024: 42a7  clr.l -(a7)
        clr.l -(a7)
L086_00000026:
; H086+$00000026: 2f3c00000001  move.l #$1, -(a7)
        move.l #$1, -(a7)
; -> H098+$0276 (sub_H098_00000276)
L086_0000002C:
; H086+$0000002C: 4eb900000276  jsr $276.l
        jsr (H098+$276).l
L086_00000032:
; H086+$00000032: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L086_00000036:
; H086+$00000036: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_0000003A:
; H086+$0000003A: 42a7  clr.l -(a7)
        clr.l -(a7)
L086_0000003C:
; H086+$0000003C: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H098+$0276 (sub_H098_00000276)
L086_0000003E:
; H086+$0000003E: 4eb900000276  jsr $276.l
        jsr (H098+$276).l
L086_00000044:
; H086+$00000044: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_00000048:
; H086+$00000048: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L086_0000004C:
; H086+$0000004C: 6c00000a  bge.w $58
        bge.w H086+$58
L086_00000050:
; H086+$00000050: 2b7cfffffffdfffc  move.l #$fffffffd, -$4(a5)
        move.l #$fffffffd, -$4(a5)
L086_00000058:
; H086+$00000058: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_0000005C:
; H086+$0000005C: 60000002  bra.w $60
        bra.w H086+$60
L086_00000060:
; H086+$00000060: 4e5d  unlk a5
        unlk a5
L086_00000062:
; H086+$00000062: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_00000064:
; H086+$00000064: 588f  addq.l #$4, a7
        addq.l #$4, a7
L086_00000066:
; H086+$00000066: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_00000068 [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; calls H098+$0276.
;   - Calls H098+$0276.
; Direct callers: H086+$0254
; --------------------------------------------------------------------------
L086_00000068:
; H086+$00000068: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L086_0000006C:
; H086+$0000006C: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L086_00000070:
; H086+$00000070: 4aad0008  tst.l $8(a5)
        tst.l $8(a5)
L086_00000074:
; H086+$00000074: 6f00003a  ble.w $b0
        ble.w H086+$B0
L086_00000078:
; H086+$00000078: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_0000007C:
; H086+$0000007C: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
L086_00000080:
; H086+$00000080: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_00000084:
; H086+$00000084: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H098+$0276 (sub_H098_00000276)
L086_00000086:
; H086+$00000086: 4eb900000276  jsr $276.l
        jsr (H098+$276).l
L086_0000008C:
; H086+$0000008C: 2400  move.l d0, d2
        move.l d0, d2
L086_0000008E:
; H086+$0000008E: 0c82ffffffff  cmpi.l #$ffffffff, d2
        cmpi.l #$ffffffff, d2
L086_00000094:
; H086+$00000094: 6600000e  bne.w $a4
        bne.w H086+$A4
L086_00000098:
; H086+$00000098: 2b7cfffffff7fffc  move.l #$fffffff7, -$4(a5)
        move.l #$fffffff7, -$4(a5)
L086_000000A0:
; H086+$000000A0: 6000000e  bra.w $b0
        bra.w H086+$B0
L086_000000A4:
; H086+$000000A4: 242d0008  move.l $8(a5), d2
        move.l $8(a5), d2
L086_000000A8:
; H086+$000000A8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_000000AC:
; H086+$000000AC: d5ab000c  add.l d2, $c(a3)
        add.l d2, $c(a3)
L086_000000B0:
; H086+$000000B0: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_000000B4:
; H086+$000000B4: 60000002  bra.w $b8
        bra.w H086+$B8
L086_000000B8:
; H086+$000000B8: 4e5d  unlk a5
        unlk a5
L086_000000BA:
; H086+$000000BA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_000000BC:
; H086+$000000BC: 508f  addq.l #$8, a7
        addq.l #$8, a7
L086_000000BE:
; H086+$000000BE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_000000C0 [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; calls H098+$0276.
;   - Calls H098+$0276.
; Direct callers: H086+$04D0
; --------------------------------------------------------------------------
L086_000000C0:
; H086+$000000C0: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L086_000000C4:
; H086+$000000C4: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L086_000000C8:
; H086+$000000C8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_000000CC:
; H086+$000000CC: 4293  clr.l (a3)
        clr.l (a3)
L086_000000CE:
; H086+$000000CE: 276d00080004  move.l $8(a5), $4(a3)
        move.l $8(a5), $4(a3)
L086_000000D4:
; H086+$000000D4: 276d00100008  move.l $10(a5), $8(a3)
        move.l $10(a5), $8(a3)
L086_000000DA:
; H086+$000000DA: 42ab000c  clr.l $c(a3)
        clr.l $c(a3)
L086_000000DE:
; H086+$000000DE: 42ab001c  clr.l $1c(a3)
        clr.l $1c(a3)
L086_000000E2:
; H086+$000000E2: 42ab0020  clr.l $20(a3)
        clr.l $20(a3)
L086_000000E6:
; H086+$000000E6: 42ab0014  clr.l $14(a3)
        clr.l $14(a3)
L086_000000EA:
; H086+$000000EA: 42ab0018  clr.l $18(a3)
        clr.l $18(a3)
L086_000000EE:
; H086+$000000EE: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L086_000000F2:
; H086+$000000F2: 6100ff18  bsr.w $c
        bsr.w H086+$C
L086_000000F6:
; H086+$000000F6: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_000000FA:
; H086+$000000FA: 27400010  move.l d0, $10(a3)
        move.l d0, $10(a3)
L086_000000FE:
; H086+$000000FE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_00000102:
; H086+$00000102: 4aab0010  tst.l $10(a3)
        tst.l $10(a3)
L086_00000106:
; H086+$00000106: 6c000010  bge.w $118
        bge.w H086+$118
L086_0000010A:
; H086+$0000010A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_0000010E:
; H086+$0000010E: 2b6b0010fffc  move.l $10(a3), -$4(a5)
        move.l $10(a3), -$4(a5)
L086_00000114:
; H086+$00000114: 60000034  bra.w $14a
        bra.w H086+$14A
L086_00000118:
; H086+$00000118: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_0000011C:
; H086+$0000011C: 0cab000000080010  cmpi.l #$8, $10(a3)
        cmpi.l #$8, $10(a3)
L086_00000124:
; H086+$00000124: 6c00000e  bge.w $134
        bge.w H086+$134
L086_00000128:
; H086+$00000128: 2b7cfffffffcfffc  move.l #$fffffffc, -$4(a5)
        move.l #$fffffffc, -$4(a5)
L086_00000130:
; H086+$00000130: 60000018  bra.w $14a
        bra.w H086+$14A
L086_00000134:
; H086+$00000134: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L086_00000138:
; H086+$00000138: 42a7  clr.l -(a7)
        clr.l -(a7)
L086_0000013A:
; H086+$0000013A: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H098+$0276 (sub_H098_00000276)
L086_00000140:
; H086+$00000140: 4eb900000276  jsr $276.l
        jsr (H098+$276).l
L086_00000146:
; H086+$00000146: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L086_0000014A:
; H086+$0000014A: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_0000014E:
; H086+$0000014E: 60000002  bra.w $152
        bra.w H086+$152
L086_00000152:
; H086+$00000152: 4e5d  unlk a5
        unlk a5
L086_00000154:
; H086+$00000154: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_00000156:
; H086+$00000156: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L086_0000015A:
; H086+$0000015A: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_0000015C [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; calls H039+$000C.
;   - Calls H039+$000C.
; Direct callers: H040+$0234, H040+$02AA, H040+$04E2, H086+$0590
; --------------------------------------------------------------------------
L086_0000015C:
; H086+$0000015C: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L086_00000160:
; H086+$00000160: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L086_00000164:
; H086+$00000164: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_00000168:
; H086+$00000168: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L086_0000016C:
; H086+$0000016C: 268a  move.l a2, (a3)
        move.l a2, (a3)
L086_0000016E:
; H086+$0000016E: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L086_00000172:
; H086+$00000172: 276a00040004  move.l $4(a2), $4(a3)
        move.l $4(a2), $4(a3)
L086_00000178:
; H086+$00000178: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L086_0000017C:
; H086+$0000017C: 276a00080008  move.l $8(a2), $8(a3)
        move.l $8(a2), $8(a3)
L086_00000182:
; H086+$00000182: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L086_00000186:
; H086+$00000186: 276a000c000c  move.l $c(a2), $c(a3)
        move.l $c(a2), $c(a3)
L086_0000018C:
; H086+$0000018C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L086_0000018E:
; H086+$0000018E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H039+$000C (trampoline_H039_0022)
L086_00000192:
; H086+$00000192: 4eb90000000c  jsr $c.l
        jsr (H039+$C).l
L086_00000198:
; H086+$00000198: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L086_0000019A:
; H086+$0000019A: 2400  move.l d0, d2
        move.l d0, d2
L086_0000019C:
; H086+$0000019C: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L086_000001A0:
; H086+$000001A0: d4aa000c  add.l $c(a2), d2
        add.l $c(a2), d2
L086_000001A4:
; H086+$000001A4: 27420010  move.l d2, $10(a3)
        move.l d2, $10(a3)
L086_000001A8:
; H086+$000001A8: 42ab001c  clr.l $1c(a3)
        clr.l $1c(a3)
L086_000001AC:
; H086+$000001AC: 42ab0020  clr.l $20(a3)
        clr.l $20(a3)
L086_000001B0:
; H086+$000001B0: 42ab0014  clr.l $14(a3)
        clr.l $14(a3)
L086_000001B4:
; H086+$000001B4: 42ab0018  clr.l $18(a3)
        clr.l $18(a3)
L086_000001B8:
; H086+$000001B8: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_000001BC:
; H086+$000001BC: 242b0010  move.l $10(a3), d2
        move.l $10(a3), d2
L086_000001C0:
; H086+$000001C0: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_000001C4:
; H086+$000001C4: b4ab0010  cmp.l $10(a3), d2
        cmp.l $10(a3), d2
L086_000001C8:
; H086+$000001C8: 6e000016  bgt.w $1e0
        bgt.w H086+$1E0
L086_000001CC:
; H086+$000001CC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_000001D0:
; H086+$000001D0: 242b0010  move.l $10(a3), d2
        move.l $10(a3), d2
L086_000001D4:
; H086+$000001D4: 028200000001  andi.l #$1, d2
        andi.l #$1, d2
L086_000001DA:
; H086+$000001DA: 4a02  tst.b d2
        tst.b d2
L086_000001DC:
; H086+$000001DC: 6700000a  beq.w $1e8
        beq.w H086+$1E8
L086_000001E0:
; H086+$000001E0: 2b7cfffffff7fffc  move.l #$fffffff7, -$4(a5)
        move.l #$fffffff7, -$4(a5)
L086_000001E8:
; H086+$000001E8: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_000001EC:
; H086+$000001EC: 60000002  bra.w $1f0
        bra.w H086+$1F0
L086_000001F0:
; H086+$000001F0: 4e5d  unlk a5
        unlk a5
L086_000001F2:
; H086+$000001F2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_000001F4:
; H086+$000001F4: 508f  addq.l #$8, a7
        addq.l #$8, a7
L086_000001F6:
; H086+$000001F6: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_000001F8 [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H040+$0276, H040+$057A, H040+$049C, H086+$0684, H086+$0550
; --------------------------------------------------------------------------
L086_000001F8:
; H086+$000001F8: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L086_000001FC:
; H086+$000001FC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_00000200:
; H086+$00000200: 4a93  tst.l (a3)
        tst.l (a3)
L086_00000202:
; H086+$00000202: 6700001c  beq.w $220
        beq.w H086+$220
L086_00000206:
; H086+$00000206: 2b6b000cfffc  move.l $c(a3), -$4(a5)
        move.l $c(a3), -$4(a5)
L086_0000020C:
; H086+$0000020C: 2453  movea.l (a3), a2
        movea.l (a3), a2
L086_0000020E:
; H086+$0000020E: 242dfffc  move.l -$4(a5), d2
        move.l -$4(a5), d2
L086_00000212:
; H086+$00000212: 94aa000c  sub.l $c(a2), d2
        sub.l $c(a2), d2
L086_00000216:
; H086+$00000216: d5aa0020  add.l d2, $20(a2)
        add.l d2, $20(a2)
L086_0000021A:
; H086+$0000021A: 256dfffc000c  move.l -$4(a5), $c(a2)
        move.l -$4(a5), $c(a2)
L086_00000220:
; H086+$00000220: 7000  moveq #$0, d0
        moveq #0, d0
L086_00000222:
; H086+$00000222: 60000002  bra.w $226
        bra.w H086+$226
L086_00000226:
; H086+$00000226: 4e5d  unlk a5
        unlk a5
L086_00000228:
; H086+$00000228: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_0000022A:
; H086+$0000022A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L086_0000022C:
; H086+$0000022C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_0000022E [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; calls H039+$000C, H098+$007C.
;   - Calls H039+$000C.
;   - Calls H098+$007C.
; Direct callers: H086+$0726, H086+$06DE, H086+$07C8, H086+$05CA, H086+$04E4
; --------------------------------------------------------------------------
L086_0000022E:
; H086+$0000022E: 4e55fff4  link.w a5, #$fff4
        link.w a5, #$fff4
L086_00000232:
; H086+$00000232: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_00000236:
; H086+$00000236: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
; -> H039+$000C (trampoline_H039_0022)
L086_0000023A:
; H086+$0000023A: 4eb90000000c  jsr $c.l
        jsr (H039+$C).l
L086_00000240:
; H086+$00000240: 2400  move.l d0, d2
        move.l d0, d2
L086_00000242:
; H086+$00000242: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_00000246:
; H086+$00000246: 282b0018  move.l $18(a3), d4
        move.l $18(a3), d4
L086_0000024A:
; H086+$0000024A: 028400000001  andi.l #$1, d4
        andi.l #$1, d4
L086_00000250:
; H086+$00000250: d484  add.l d4, d2
        add.l d4, d2
L086_00000252:
; H086+$00000252: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L086_00000254:
; H086+$00000254: 6100fe12  bsr.w $68
        bsr.w H086+$68
L086_00000258:
; H086+$00000258: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_0000025C:
; H086+$0000025C: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L086_00000260:
; H086+$00000260: 6700000a  beq.w $26c
        beq.w H086+$26C
L086_00000264:
; H086+$00000264: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_00000268:
; H086+$00000268: 60000180  bra.w $3ea
        bra.w H086+$3EA
L086_0000026C:
; H086+$0000026C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_00000270:
; H086+$00000270: 277cfffffff70014  move.l #$fffffff7, $14(a3)
        move.l #$fffffff7, $14(a3)
L086_00000278:
; H086+$00000278: 42ab001c  clr.l $1c(a3)
        clr.l $1c(a3)
L086_0000027C:
; H086+$0000027C: 42ab0020  clr.l $20(a3)
        clr.l $20(a3)
L086_00000280:
; H086+$00000280: 242b0010  move.l $10(a3), d2
        move.l $10(a3), d2
L086_00000284:
; H086+$00000284: 94ab000c  sub.l $c(a3), d2
        sub.l $c(a3), d2
L086_00000288:
; H086+$00000288: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L086_0000028C:
; H086+$0000028C: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L086_00000290:
; H086+$00000290: 66000012  bne.w $2a4
        bne.w H086+$2A4
L086_00000294:
; H086+$00000294: 42ab0018  clr.l $18(a3)
        clr.l $18(a3)
L086_00000298:
; H086+$00000298: 277cffffffff0014  move.l #$ffffffff, $14(a3)
        move.l #$ffffffff, $14(a3)
L086_000002A0:
; H086+$000002A0: 60000140  bra.w $3e2
        bra.w H086+$3E2
L086_000002A4:
; H086+$000002A4: 0cad00000008fff8  cmpi.l #$8, -$8(a5)
        cmpi.l #$8, -$8(a5)
L086_000002AC:
; H086+$000002AC: 6c00000c  bge.w $2ba
        bge.w H086+$2BA
L086_000002B0:
; H086+$000002B0: 276dfff80018  move.l -$8(a5), $18(a3)
        move.l -$8(a5), $18(a3)
L086_000002B6:
; H086+$000002B6: 6000012a  bra.w $3e2
        bra.w H086+$3E2
L086_000002BA:
; H086+$000002BA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L086_000002BC:
; H086+$000002BC: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
L086_000002C0:
; H086+$000002C0: 45eb0014  lea.l $14(a3), a2
        lea.l $14(a3), a2
L086_000002C4:
; H086+$000002C4: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L086_000002C6:
; H086+$000002C6: 2f3c00000008  move.l #$8, -(a7)
        move.l #$8, -(a7)
; -> H098+$007C (sub_H098_0000007C)
L086_000002CC:
; H086+$000002CC: 4eb90000007c  jsr $7c.l
        jsr (H098+$7C).l
L086_000002D2:
; H086+$000002D2: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L086_000002D4:
; H086+$000002D4: 2b40fff4  move.l d0, -$c(a5)
        move.l d0, -$c(a5)
L086_000002D8:
; H086+$000002D8: 0cadfffffffffff4  cmpi.l #$ffffffff, -$c(a5)
        cmpi.l #$ffffffff, -$c(a5)
L086_000002E0:
; H086+$000002E0: 66000014  bne.w $2f6
        bne.w H086+$2F6
L086_000002E4:
; H086+$000002E4: 277cfffffffd0014  move.l #$fffffffd, $14(a3)
        move.l #$fffffffd, $14(a3)
L086_000002EC:
; H086+$000002EC: 70fd  moveq #$fd, d0
        moveq #-3, d0
L086_000002EE:
; H086+$000002EE: 600000fa  bra.w $3ea
        bra.w H086+$3EA
; Preserved bytes H086+$000002F2..$000002F6; code/data not fully classified.
        dc.w $6000,$0018
L086_000002F6:
; H086+$000002F6: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L086_000002FA:
; H086+$000002FA: 66000010  bne.w $30c
        bne.w H086+$30C
L086_000002FE:
; H086+$000002FE: 277cfffffff70014  move.l #$fffffff7, $14(a3)
        move.l #$fffffff7, $14(a3)
L086_00000306:
; H086+$00000306: 70f7  moveq #$f7, d0
        moveq #-9, d0
L086_00000308:
; H086+$00000308: 600000e0  bra.w $3ea
        bra.w H086+$3EA
L086_0000030C:
; H086+$0000030C: 4a93  tst.l (a3)
        tst.l (a3)
L086_0000030E:
; H086+$0000030E: 66000034  bne.w $344
        bne.w H086+$344
L086_00000312:
; H086+$00000312: 0cab464f524d0014  cmpi.l #$464f524d, $14(a3)
        cmpi.l #$464f524d, $14(a3)
L086_0000031A:
; H086+$0000031A: 67000028  beq.w $344
        beq.w H086+$344
L086_0000031E:
; H086+$0000031E: 0cab4c4953540014  cmpi.l #$4c495354, $14(a3)
        cmpi.l #$4c495354, $14(a3)
L086_00000326:
; H086+$00000326: 6700001c  beq.w $344
        beq.w H086+$344
L086_0000032A:
; H086+$0000032A: 0cab434154200014  cmpi.l #$43415420, $14(a3)
        cmpi.l #$43415420, $14(a3)
L086_00000332:
; H086+$00000332: 67000010  beq.w $344
        beq.w H086+$344
L086_00000336:
; H086+$00000336: 277cfffffffc0014  move.l #$fffffffc, $14(a3)
        move.l #$fffffffc, $14(a3)
L086_0000033E:
; H086+$0000033E: 70fc  moveq #$fc, d0
        moveq #-4, d0
L086_00000340:
; H086+$00000340: 600000a8  bra.w $3ea
        bra.w H086+$3EA
L086_00000344:
; H086+$00000344: 50ab000c  addq.l #$8, $c(a3)
        addq.l #$8, $c(a3)
L086_00000348:
; H086+$00000348: 51adfff8  subq.l #$8, -$8(a5)
        subq.l #$8, -$8(a5)
L086_0000034C:
; H086+$0000034C: 4aab0014  tst.l $14(a3)
        tst.l $14(a3)
L086_00000350:
; H086+$00000350: 6e00000e  bgt.w $360
        bgt.w H086+$360
L086_00000354:
; H086+$00000354: 277cfffffff70014  move.l #$fffffff7, $14(a3)
        move.l #$fffffff7, $14(a3)
L086_0000035C:
; H086+$0000035C: 60000084  bra.w $3e2
        bra.w H086+$3E2
L086_00000360:
; H086+$00000360: 4aab0018  tst.l $18(a3)
        tst.l $18(a3)
L086_00000364:
; H086+$00000364: 6d00000e  blt.w $374
        blt.w H086+$374
L086_00000368:
; H086+$00000368: 242b0018  move.l $18(a3), d2
        move.l $18(a3), d2
L086_0000036C:
; H086+$0000036C: b4adfff8  cmp.l -$8(a5), d2
        cmp.l -$8(a5), d2
L086_00000370:
; H086+$00000370: 6f000014  ble.w $386
        ble.w H086+$386
L086_00000374:
; H086+$00000374: 276dfff80018  move.l -$8(a5), $18(a3)
        move.l -$8(a5), $18(a3)
L086_0000037A:
; H086+$0000037A: 277cfffffff70014  move.l #$fffffff7, $14(a3)
        move.l #$fffffff7, $14(a3)
L086_00000382:
; H086+$00000382: 6000005e  bra.w $3e2
        bra.w H086+$3E2
L086_00000386:
; H086+$00000386: 0cab4c4953540014  cmpi.l #$4c495354, $14(a3)
        cmpi.l #$4c495354, $14(a3)
L086_0000038E:
; H086+$0000038E: 67000026  beq.w $3b6
        beq.w H086+$3B6
L086_00000392:
; H086+$00000392: 0cab464f524d0014  cmpi.l #$464f524d, $14(a3)
        cmpi.l #$464f524d, $14(a3)
L086_0000039A:
; H086+$0000039A: 6700001a  beq.w $3b6
        beq.w H086+$3B6
L086_0000039E:
; H086+$0000039E: 0cab50524f500014  cmpi.l #$50524f50, $14(a3)
        cmpi.l #$50524f50, $14(a3)
L086_000003A6:
; H086+$000003A6: 6700000e  beq.w $3b6
        beq.w H086+$3B6
L086_000003AA:
; H086+$000003AA: 0cab434154200014  cmpi.l #$43415420, $14(a3)
        cmpi.l #$43415420, $14(a3)
L086_000003B2:
; H086+$000003B2: 6600002e  bne.w $3e2
        bne.w H086+$3E2
L086_000003B6:
; H086+$000003B6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L086_000003B8:
; H086+$000003B8: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_000003BC:
; H086+$000003BC: 45eb001c  lea.l $1c(a3), a2
        lea.l $1c(a3), a2
L086_000003C0:
; H086+$000003C0: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
L086_000003C2:
; H086+$000003C2: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L086_000003C8:
; H086+$000003C8: 4eb9000003f2  jsr $3f2.l
        jsr (H086+$3F2).l
L086_000003CE:
; H086+$000003CE: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L086_000003D0:
; H086+$000003D0: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_000003D4:
; H086+$000003D4: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L086_000003D8:
; H086+$000003D8: 67000008  beq.w $3e2
        beq.w H086+$3E2
L086_000003DC:
; H086+$000003DC: 276dfffc0014  move.l -$4(a5), $14(a3)
        move.l -$4(a5), $14(a3)
L086_000003E2:
; H086+$000003E2: 202b0014  move.l $14(a3), d0
        move.l $14(a3), d0
L086_000003E6:
; H086+$000003E6: 60000002  bra.w $3ea
        bra.w H086+$3EA
L086_000003EA:
; H086+$000003EA: 4e5d  unlk a5
        unlk a5
L086_000003EC:
; H086+$000003EC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_000003EE:
; H086+$000003EE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L086_000003F0:
; H086+$000003F0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H086_049E [partial]
; Purpose: Trampoline to H086+$049E; the actual body is there.
;   - Jumps to the actual body at H086+$049E.
; Direct callers: H087+$001E, H087+$00FA, H086+$03C8, H087+$03A8
; --------------------------------------------------------------------------
L086_000003F2:
; H086+$000003F2: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L086_000003F6:
; H086+$000003F6: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L086_000003FA:
; H086+$000003FA: 4aad0008  tst.l $8(a5)
        tst.l $8(a5)
L086_000003FE:
; H086+$000003FE: 6c00000e  bge.w $40e
        bge.w H086+$40E
L086_00000402:
; H086+$00000402: 2b7cfffffffafffc  move.l #$fffffffa, -$4(a5)
        move.l #$fffffffa, -$4(a5)
L086_0000040A:
; H086+$0000040A: 6000008a  bra.w $496
        bra.w H086+$496
L086_0000040E:
; H086+$0000040E: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
; -> H039+$000C (trampoline_H039_0022)
L086_00000412:
; H086+$00000412: 4eb90000000c  jsr $c.l
        jsr (H039+$C).l
L086_00000418:
; H086+$00000418: 2400  move.l d0, d2
        move.l d0, d2
L086_0000041A:
; H086+$0000041A: 282d0008  move.l $8(a5), d4
        move.l $8(a5), d4
L086_0000041E:
; H086+$0000041E: b882  cmp.l d2, d4
        cmp.l d2, d4
L086_00000420:
; H086+$00000420: 6f00000e  ble.w $430
        ble.w H086+$430
L086_00000424:
; H086+$00000424: 2b7cfffffff8fffc  move.l #$fffffff8, -$4(a5)
        move.l #$fffffff8, -$4(a5)
L086_0000042C:
; H086+$0000042C: 60000068  bra.w $496
        bra.w H086+$496
L086_00000430:
; H086+$00000430: 4aad0008  tst.l $8(a5)
        tst.l $8(a5)
L086_00000434:
; H086+$00000434: 6f000060  ble.w $496
        ble.w H086+$496
L086_00000438:
; H086+$00000438: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L086_0000043C:
; H086+$0000043C: 2f2b0008  move.l $8(a3), -(a7)
        move.l $8(a3), -(a7)
L086_00000440:
; H086+$00000440: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L086_00000444:
; H086+$00000444: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
; -> H098+$007C (sub_H098_0000007C)
L086_00000448:
; H086+$00000448: 4eb90000007c  jsr $7c.l
        jsr (H098+$7C).l
L086_0000044E:
; H086+$0000044E: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L086_00000452:
; H086+$00000452: 0cadfffffffffff8  cmpi.l #$ffffffff, -$8(a5)
        cmpi.l #$ffffffff, -$8(a5)
L086_0000045A:
; H086+$0000045A: 6600000e  bne.w $46a
        bne.w H086+$46A
L086_0000045E:
; H086+$0000045E: 2b7cfffffffdfffc  move.l #$fffffffd, -$4(a5)
        move.l #$fffffffd, -$4(a5)
L086_00000466:
; H086+$00000466: 6000002e  bra.w $496
        bra.w H086+$496
L086_0000046A:
; H086+$0000046A: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L086_0000046E:
; H086+$0000046E: 6600000e  bne.w $47e
        bne.w H086+$47E
L086_00000472:
; H086+$00000472: 2b7cfffffff7fffc  move.l #$fffffff7, -$4(a5)
        move.l #$fffffff7, -$4(a5)
L086_0000047A:
; H086+$0000047A: 6000001a  bra.w $496
        bra.w H086+$496
L086_0000047E:
; H086+$0000047E: 242d0008  move.l $8(a5), d2
        move.l $8(a5), d2
L086_00000482:
; H086+$00000482: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L086_00000486:
; H086+$00000486: d5ab000c  add.l d2, $c(a3)
        add.l d2, $c(a3)
L086_0000048A:
; H086+$0000048A: 242d0008  move.l $8(a5), d2
        move.l $8(a5), d2
L086_0000048E:
; H086+$0000048E: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L086_00000492:
; H086+$00000492: d5ab0020  add.l d2, $20(a3)
        add.l d2, $20(a3)
L086_00000496:
; H086+$00000496: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_0000049A:
; H086+$0000049A: 60000002  bra.w $49e
        bra.w H086+$49E
L086_0000049E:
; H086+$0000049E: 4e5d  unlk a5
        unlk a5
L086_000004A0:
; H086+$000004A0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_000004A2:
; H086+$000004A2: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L086_000004A6:
; H086+$000004A6: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H086+$000004A8..$000004BA; code/data not fully classified.
        dc.w $4E55,$0000,$7000,$6000,$0002,$4E5D,$205F,$588F
        dc.w $4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_000004BA [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H040+$0640
; --------------------------------------------------------------------------
L086_000004BA:
; H086+$000004BA: 4e55ffd0  link.w a5, #$ffd0
        link.w a5, #$ffd0
L086_000004BE:
; H086+$000004BE: 2b6d0008ffd4  move.l $8(a5), -$2c(a5)
        move.l $8(a5), -$2c(a5)
L086_000004C4:
; H086+$000004C4: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L086_000004C8:
; H086+$000004C8: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L086_000004CC:
; H086+$000004CC: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_000004D0:
; H086+$000004D0: 6100fbee  bsr.w $c0
        bsr.w H086+$C0
L086_000004D4:
; H086+$000004D4: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_000004D8:
; H086+$000004D8: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L086_000004DC:
; H086+$000004DC: 6600006e  bne.w $54c
        bne.w H086+$54C
L086_000004E0:
; H086+$000004E0: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L086_000004E4:
; H086+$000004E4: 6100fd48  bsr.w $22e
        bsr.w H086+$22E
L086_000004E8:
; H086+$000004E8: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_000004EC:
; H086+$000004EC: 0cad464f524dfffc  cmpi.l #$464f524d, -$4(a5)
        cmpi.l #$464f524d, -$4(a5)
L086_000004F4:
; H086+$000004F4: 66000018  bne.w $50e
        bne.w H086+$50E
L086_000004F8:
; H086+$000004F8: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L086_000004FC:
; H086+$000004FC: 246dffd4  movea.l -$2c(a5), a2
        movea.l -$2c(a5), a2
L086_00000500:
; H086+$00000500: 266a0008  movea.l $8(a2), a3
        movea.l $8(a2), a3
L086_00000504:
; H086+$00000504: 4e93  jsr (a3)
        jsr (a3)
L086_00000506:
; H086+$00000506: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_0000050A:
; H086+$0000050A: 60000040  bra.w $54c
        bra.w H086+$54C
L086_0000050E:
; H086+$0000050E: 0cad4c495354fffc  cmpi.l #$4c495354, -$4(a5)
        cmpi.l #$4c495354, -$4(a5)
L086_00000516:
; H086+$00000516: 66000016  bne.w $52e
        bne.w H086+$52E
L086_0000051A:
; H086+$0000051A: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L086_0000051E:
; H086+$0000051E: 246dffd4  movea.l -$2c(a5), a2
        movea.l -$2c(a5), a2
L086_00000522:
; H086+$00000522: 2652  movea.l (a2), a3
        movea.l (a2), a3
L086_00000524:
; H086+$00000524: 4e93  jsr (a3)
        jsr (a3)
L086_00000526:
; H086+$00000526: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_0000052A:
; H086+$0000052A: 60000020  bra.w $54c
        bra.w H086+$54C
L086_0000052E:
; H086+$0000052E: 0cad43415420fffc  cmpi.l #$43415420, -$4(a5)
        cmpi.l #$43415420, -$4(a5)
L086_00000536:
; H086+$00000536: 66000014  bne.w $54c
        bne.w H086+$54C
L086_0000053A:
; H086+$0000053A: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L086_0000053E:
; H086+$0000053E: 246dffd4  movea.l -$2c(a5), a2
        movea.l -$2c(a5), a2
L086_00000542:
; H086+$00000542: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L086_00000546:
; H086+$00000546: 4e93  jsr (a3)
        jsr (a3)
L086_00000548:
; H086+$00000548: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_0000054C:
; H086+$0000054C: 486dffd8  pea.l -$28(a5)
        pea.l -$28(a5)
L086_00000550:
; H086+$00000550: 6100fca6  bsr.w $1f8
        bsr.w H086+$1F8
L086_00000554:
; H086+$00000554: 2b40ffd0  move.l d0, -$30(a5)
        move.l d0, -$30(a5)
L086_00000558:
; H086+$00000558: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L086_0000055C:
; H086+$0000055C: 6f00000a  ble.w $568
        ble.w H086+$568
L086_00000560:
; H086+$00000560: 2b7cfffffffcfffc  move.l #$fffffffc, -$4(a5)
        move.l #$fffffffc, -$4(a5)
L086_00000568:
; H086+$00000568: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_0000056C:
; H086+$0000056C: 60000002  bra.w $570
        bra.w H086+$570
L086_00000570:
; H086+$00000570: 4e5d  unlk a5
        unlk a5
L086_00000572:
; H086+$00000572: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_00000574:
; H086+$00000574: 508f  addq.l #$8, a7
        addq.l #$8, a7
L086_00000576:
; H086+$00000576: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_00000578 [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H040+$05D2, H086+$06C6
; --------------------------------------------------------------------------
L086_00000578:
; H086+$00000578: 4e55ffce  link.w a5, #$ffce
        link.w a5, #$ffce
L086_0000057C:
; H086+$0000057C: 2b6d0008ffd8  move.l $8(a5), -$28(a5)
        move.l $8(a5), -$28(a5)
L086_00000582:
; H086+$00000582: 1b7c0001ffd3  move.b #$1, -$2d(a5)
        move.b #$1, -$2d(a5)
L086_00000588:
; H086+$00000588: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L086_0000058C:
; H086+$0000058C: 486dffdc  pea.l -$24(a5)
        pea.l -$24(a5)
L086_00000590:
; H086+$00000590: 6100fbca  bsr.w $15c
        bsr.w H086+$15C
L086_00000594:
; H086+$00000594: 2b40ffd4  move.l d0, -$2c(a5)
        move.l d0, -$2c(a5)
L086_00000598:
; H086+$00000598: 4aadffd4  tst.l -$2c(a5)
        tst.l -$2c(a5)
L086_0000059C:
; H086+$0000059C: 6700000a  beq.w $5a8
        beq.w H086+$5A8
L086_000005A0:
; H086+$000005A0: 202dffd4  move.l -$2c(a5), d0
        move.l -$2c(a5), d0
L086_000005A4:
; H086+$000005A4: 6000010e  bra.w $6b4
        bra.w H086+$6B4
L086_000005A8:
; H086+$000005A8: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L086_000005AC:
; H086+$000005AC: 0cab434154200014  cmpi.l #$43415420, $14(a3)
        cmpi.l #$43415420, $14(a3)
L086_000005B4:
; H086+$000005B4: 6600000a  bne.w $5c0
        bne.w H086+$5C0
L086_000005B8:
; H086+$000005B8: 422dffd3  clr.b -$2d(a5)
        clr.b -$2d(a5)
L086_000005BC:
; H086+$000005BC: 60000008  bra.w $5c6
        bra.w H086+$5C6
L086_000005C0:
; H086+$000005C0: 2b6d0008ffe0  move.l $8(a5), -$20(a5)
        move.l $8(a5), -$20(a5)
L086_000005C6:
; H086+$000005C6: 486dffdc  pea.l -$24(a5)
        pea.l -$24(a5)
L086_000005CA:
; H086+$000005CA: 6100fc62  bsr.w $22e
        bsr.w H086+$22E
L086_000005CE:
; H086+$000005CE: 2b40ffd4  move.l d0, -$2c(a5)
        move.l d0, -$2c(a5)
L086_000005D2:
; H086+$000005D2: 0cad50524f50ffd4  cmpi.l #$50524f50, -$2c(a5)
        cmpi.l #$50524f50, -$2c(a5)
L086_000005DA:
; H086+$000005DA: 6600002c  bne.w $608
        bne.w H086+$608
L086_000005DE:
; H086+$000005DE: 4a2dffd3  tst.b -$2d(a5)
        tst.b -$2d(a5)
L086_000005E2:
; H086+$000005E2: 67000018  beq.w $5fc
        beq.w H086+$5FC
L086_000005E6:
; H086+$000005E6: 486dffdc  pea.l -$24(a5)
        pea.l -$24(a5)
L086_000005EA:
; H086+$000005EA: 246dffd8  movea.l -$28(a5), a2
        movea.l -$28(a5), a2
L086_000005EE:
; H086+$000005EE: 266a0004  movea.l $4(a2), a3
        movea.l $4(a2), a3
L086_000005F2:
; H086+$000005F2: 4e93  jsr (a3)
        jsr (a3)
L086_000005F4:
; H086+$000005F4: 2b40ffd4  move.l d0, -$2c(a5)
        move.l d0, -$2c(a5)
L086_000005F8:
; H086+$000005F8: 6000000a  bra.w $604
        bra.w H086+$604
L086_000005FC:
; H086+$000005FC: 2b7cfffffff7ffd4  move.l #$fffffff7, -$2c(a5)
        move.l #$fffffff7, -$2c(a5)
L086_00000604:
; H086+$00000604: 60000062  bra.w $668
        bra.w H086+$668
L086_00000608:
; H086+$00000608: 0cad464f524dffd4  cmpi.l #$464f524d, -$2c(a5)
        cmpi.l #$464f524d, -$2c(a5)
L086_00000610:
; H086+$00000610: 66000018  bne.w $62a
        bne.w H086+$62A
L086_00000614:
; H086+$00000614: 486dffdc  pea.l -$24(a5)
        pea.l -$24(a5)
L086_00000618:
; H086+$00000618: 246dffd8  movea.l -$28(a5), a2
        movea.l -$28(a5), a2
L086_0000061C:
; H086+$0000061C: 266a0008  movea.l $8(a2), a3
        movea.l $8(a2), a3
L086_00000620:
; H086+$00000620: 4e93  jsr (a3)
        jsr (a3)
L086_00000622:
; H086+$00000622: 2b40ffd4  move.l d0, -$2c(a5)
        move.l d0, -$2c(a5)
L086_00000626:
; H086+$00000626: 60000040  bra.w $668
        bra.w H086+$668
L086_0000062A:
; H086+$0000062A: 0cad4c495354ffd4  cmpi.l #$4c495354, -$2c(a5)
        cmpi.l #$4c495354, -$2c(a5)
L086_00000632:
; H086+$00000632: 66000016  bne.w $64a
        bne.w H086+$64A
L086_00000636:
; H086+$00000636: 486dffdc  pea.l -$24(a5)
        pea.l -$24(a5)
L086_0000063A:
; H086+$0000063A: 246dffd8  movea.l -$28(a5), a2
        movea.l -$28(a5), a2
L086_0000063E:
; H086+$0000063E: 2652  movea.l (a2), a3
        movea.l (a2), a3
L086_00000640:
; H086+$00000640: 4e93  jsr (a3)
        jsr (a3)
L086_00000642:
; H086+$00000642: 2b40ffd4  move.l d0, -$2c(a5)
        move.l d0, -$2c(a5)
L086_00000646:
; H086+$00000646: 60000020  bra.w $668
        bra.w H086+$668
L086_0000064A:
; H086+$0000064A: 0cad43415420ffd4  cmpi.l #$43415420, -$2c(a5)
        cmpi.l #$43415420, -$2c(a5)
L086_00000652:
; H086+$00000652: 66000014  bne.w $668
        bne.w H086+$668
L086_00000656:
; H086+$00000656: 486dffdc  pea.l -$24(a5)
        pea.l -$24(a5)
L086_0000065A:
; H086+$0000065A: 246dffd8  movea.l -$28(a5), a2
        movea.l -$28(a5), a2
L086_0000065E:
; H086+$0000065E: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L086_00000662:
; H086+$00000662: 4e93  jsr (a3)
        jsr (a3)
L086_00000664:
; H086+$00000664: 2b40ffd4  move.l d0, -$2c(a5)
        move.l d0, -$2c(a5)
L086_00000668:
; H086+$00000668: 0cad50524f50fff0  cmpi.l #$50524f50, -$10(a5)
        cmpi.l #$50524f50, -$10(a5)
L086_00000670:
; H086+$00000670: 67000006  beq.w $678
        beq.w H086+$678
L086_00000674:
; H086+$00000674: 422dffd3  clr.b -$2d(a5)
        clr.b -$2d(a5)
L086_00000678:
; H086+$00000678: 4aadffd4  tst.l -$2c(a5)
        tst.l -$2c(a5)
L086_0000067C:
; H086+$0000067C: 6700ff48  beq.w $5c6
        beq.w H086+$5C6
L086_00000680:
; H086+$00000680: 486dffdc  pea.l -$24(a5)
        pea.l -$24(a5)
L086_00000684:
; H086+$00000684: 6100fb72  bsr.w $1f8
        bsr.w H086+$1F8
L086_00000688:
; H086+$00000688: 2b40ffce  move.l d0, -$32(a5)
        move.l d0, -$32(a5)
L086_0000068C:
; H086+$0000068C: 4aadffd4  tst.l -$2c(a5)
        tst.l -$2c(a5)
L086_00000690:
; H086+$00000690: 6f00000a  ble.w $69c
        ble.w H086+$69C
L086_00000694:
; H086+$00000694: 2b7cfffffff7ffd4  move.l #$fffffff7, -$2c(a5)
        move.l #$fffffff7, -$2c(a5)
L086_0000069C:
; H086+$0000069C: 0cadffffffffffd4  cmpi.l #$ffffffff, -$2c(a5)
        cmpi.l #$ffffffff, -$2c(a5)
L086_000006A4:
; H086+$000006A4: 66000006  bne.w $6ac
        bne.w H086+$6AC
L086_000006A8:
; H086+$000006A8: 42adffd4  clr.l -$2c(a5)
        clr.l -$2c(a5)
L086_000006AC:
; H086+$000006AC: 202dffd4  move.l -$2c(a5), d0
        move.l -$2c(a5), d0
L086_000006B0:
; H086+$000006B0: 60000002  bra.w $6b4
        bra.w H086+$6B4
L086_000006B4:
; H086+$000006B4: 4e5d  unlk a5
        unlk a5
L086_000006B6:
; H086+$000006B6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_000006B8:
; H086+$000006B8: 508f  addq.l #$8, a7
        addq.l #$8, a7
L086_000006BA:
; H086+$000006BA: 4ed0  jmp (a0)
        jmp (a0)
L086_000006BC:
; H086+$000006BC: 4e550000  link.w a5, #$0
        link.w a5, #$0
L086_000006C0:
; H086+$000006C0: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_000006C4:
; H086+$000006C4: 42a7  clr.l -(a7)
        clr.l -(a7)
L086_000006C6:
; H086+$000006C6: 6100feb0  bsr.w $578
        bsr.w H086+$578
L086_000006CA:
; H086+$000006CA: 60000002  bra.w $6ce
        bra.w H086+$6CE
L086_000006CE:
; H086+$000006CE: 4e5d  unlk a5
        unlk a5
L086_000006D0:
; H086+$000006D0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_000006D2:
; H086+$000006D2: 588f  addq.l #$4, a7
        addq.l #$4, a7
L086_000006D4:
; H086+$000006D4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_000006D6 [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H040+$02C8
; --------------------------------------------------------------------------
L086_000006D6:
; H086+$000006D6: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L086_000006DA:
; H086+$000006DA: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_000006DE:
; H086+$000006DE: 6100fb4e  bsr.w $22e
        bsr.w H086+$22E
L086_000006E2:
; H086+$000006E2: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_000006E6:
; H086+$000006E6: 0cad50524f50fffc  cmpi.l #$50524f50, -$4(a5)
        cmpi.l #$50524f50, -$4(a5)
L086_000006EE:
; H086+$000006EE: 66000014  bne.w $704
        bne.w H086+$704
L086_000006F2:
; H086+$000006F2: 2b7cfffffff7fffc  move.l #$fffffff7, -$4(a5)
        move.l #$fffffff7, -$4(a5)
L086_000006FA:
; H086+$000006FA: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_000006FE:
; H086+$000006FE: 276dfffc0014  move.l -$4(a5), $14(a3)
        move.l -$4(a5), $14(a3)
L086_00000704:
; H086+$00000704: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_00000708:
; H086+$00000708: 60000002  bra.w $70c
        bra.w H086+$70C
L086_0000070C:
; H086+$0000070C: 4e5d  unlk a5
        unlk a5
L086_0000070E:
; H086+$0000070E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_00000710:
; H086+$00000710: 588f  addq.l #$4, a7
        addq.l #$4, a7
L086_00000712:
; H086+$00000712: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_00000714 [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H040+$0252
; --------------------------------------------------------------------------
L086_00000714:
; H086+$00000714: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L086_00000718:
; H086+$00000718: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_0000071C:
; H086+$0000071C: 2b6b0004fff8  move.l $4(a3), -$8(a5)
        move.l $4(a3), -$8(a5)
L086_00000722:
; H086+$00000722: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_00000726:
; H086+$00000726: 6100fb06  bsr.w $22e
        bsr.w H086+$22E
L086_0000072A:
; H086+$0000072A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_0000072E:
; H086+$0000072E: 0cad50524f50fffc  cmpi.l #$50524f50, -$4(a5)
        cmpi.l #$50524f50, -$4(a5)
L086_00000736:
; H086+$00000736: 6600000e  bne.w $746
        bne.w H086+$746
L086_0000073A:
; H086+$0000073A: 2b7cfffffff7fffc  move.l #$fffffff7, -$4(a5)
        move.l #$fffffff7, -$4(a5)
L086_00000742:
; H086+$00000742: 60000062  bra.w $7a6
        bra.w H086+$7A6
L086_00000746:
; H086+$00000746: 0cad464f524dfffc  cmpi.l #$464f524d, -$4(a5)
        cmpi.l #$464f524d, -$4(a5)
L086_0000074E:
; H086+$0000074E: 66000018  bne.w $768
        bne.w H086+$768
L086_00000752:
; H086+$00000752: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_00000756:
; H086+$00000756: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L086_0000075A:
; H086+$0000075A: 266a0008  movea.l $8(a2), a3
        movea.l $8(a2), a3
L086_0000075E:
; H086+$0000075E: 4e93  jsr (a3)
        jsr (a3)
L086_00000760:
; H086+$00000760: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_00000764:
; H086+$00000764: 60000040  bra.w $7a6
        bra.w H086+$7A6
L086_00000768:
; H086+$00000768: 0cad4c495354fffc  cmpi.l #$4c495354, -$4(a5)
        cmpi.l #$4c495354, -$4(a5)
L086_00000770:
; H086+$00000770: 66000016  bne.w $788
        bne.w H086+$788
L086_00000774:
; H086+$00000774: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_00000778:
; H086+$00000778: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L086_0000077C:
; H086+$0000077C: 2652  movea.l (a2), a3
        movea.l (a2), a3
L086_0000077E:
; H086+$0000077E: 4e93  jsr (a3)
        jsr (a3)
L086_00000780:
; H086+$00000780: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_00000784:
; H086+$00000784: 60000020  bra.w $7a6
        bra.w H086+$7A6
L086_00000788:
; H086+$00000788: 0cad43415420fffc  cmpi.l #$43415420, -$4(a5)
        cmpi.l #$43415420, -$4(a5)
L086_00000790:
; H086+$00000790: 66000014  bne.w $7a6
        bne.w H086+$7A6
L086_00000794:
; H086+$00000794: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_00000798:
; H086+$00000798: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L086_0000079C:
; H086+$0000079C: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L086_000007A0:
; H086+$000007A0: 4e93  jsr (a3)
        jsr (a3)
L086_000007A2:
; H086+$000007A2: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_000007A6:
; H086+$000007A6: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_000007AA:
; H086+$000007AA: 276dfffc0014  move.l -$4(a5), $14(a3)
        move.l -$4(a5), $14(a3)
L086_000007B0:
; H086+$000007B0: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_000007B4:
; H086+$000007B4: 60000002  bra.w $7b8
        bra.w H086+$7B8
L086_000007B8:
; H086+$000007B8: 4e5d  unlk a5
        unlk a5
L086_000007BA:
; H086+$000007BA: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_000007BC:
; H086+$000007BC: 588f  addq.l #$4, a7
        addq.l #$4, a7
L086_000007BE:
; H086+$000007BE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H086_000007C0 [partial]
; Purpose: Routine of the generic IFF parser: chunks and FORM/LIST/PROP/CAT groups module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H040+$0500
; --------------------------------------------------------------------------
L086_000007C0:
; H086+$000007C0: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L086_000007C4:
; H086+$000007C4: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L086_000007C8:
; H086+$000007C8: 6100fa64  bsr.w $22e
        bsr.w H086+$22E
L086_000007CC:
; H086+$000007CC: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L086_000007D0:
; H086+$000007D0: 0cad4c495354fffc  cmpi.l #$4c495354, -$4(a5)
        cmpi.l #$4c495354, -$4(a5)
L086_000007D8:
; H086+$000007D8: 67000026  beq.w $800
        beq.w H086+$800
L086_000007DC:
; H086+$000007DC: 0cad464f524dfffc  cmpi.l #$464f524d, -$4(a5)
        cmpi.l #$464f524d, -$4(a5)
L086_000007E4:
; H086+$000007E4: 6700001a  beq.w $800
        beq.w H086+$800
L086_000007E8:
; H086+$000007E8: 0cad50524f50fffc  cmpi.l #$50524f50, -$4(a5)
        cmpi.l #$50524f50, -$4(a5)
L086_000007F0:
; H086+$000007F0: 6700000e  beq.w $800
        beq.w H086+$800
L086_000007F4:
; H086+$000007F4: 0cad43415420fffc  cmpi.l #$43415420, -$4(a5)
        cmpi.l #$43415420, -$4(a5)
L086_000007FC:
; H086+$000007FC: 66000014  bne.w $812
        bne.w H086+$812
L086_00000800:
; H086+$00000800: 2b7cfffffff7fffc  move.l #$fffffff7, -$4(a5)
        move.l #$fffffff7, -$4(a5)
L086_00000808:
; H086+$00000808: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L086_0000080C:
; H086+$0000080C: 276dfffc0014  move.l -$4(a5), $14(a3)
        move.l -$4(a5), $14(a3)
L086_00000812:
; H086+$00000812: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L086_00000816:
; H086+$00000816: 60000002  bra.w $81a
        bra.w H086+$81A
L086_0000081A:
; H086+$0000081A: 4e5d  unlk a5
        unlk a5
L086_0000081C:
; H086+$0000081C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L086_0000081E:
; H086+$0000081E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L086_00000820:
; H086+$00000820: 4ed0  jmp (a0)
        jmp (a0)
L086_00000822:
; H086+$00000822: 4e5d  unlk a5
        unlk a5
L086_00000824:
; H086+$00000824: 4e75  rts 
        rts 
; Preserved bytes H086+$00000826..$00000828; code/data not fully classified.
        dc.w $0000
; End H086: $828 bytes
