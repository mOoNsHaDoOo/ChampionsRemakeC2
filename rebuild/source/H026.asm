; ============================================================================
; MODULE GUIDE H026
; String and buffer helpers with limits passed by the callers.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; String and buffer helpers: copy with limits, comparison, conversion and handling of terminators. They are not C routines with a complete ABI.
; --------------------------------------------------------------------------
; H026: 1452 original bytes; all offsets are section-relative.
        section H026,code
H026:
; Preserved bytes H026+$00000000..$00000004; code/data not fully classified.
        dc.l H026+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H026_05A6 [partial]
; Purpose: Trampoline to H026+$05A6; the actual body is there.
;   - Jumps to the actual body at H026+$05A6.
; Direct callers: H000+$006C
; --------------------------------------------------------------------------
L026_00000004:
; H026+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L026_00000008:
; H026+$00000008: 6000059c  bra.w $5a6
        bra.w H026+$5A6
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H026_0014 [partial]
; Purpose: Trampoline to H026+$0014; the actual body is there.
;   - Jumps to the actual body at H026+$0014.
; Direct callers: H026+$01F0, H063+$1FAA, H030+$0540, H008+$05FE, H008+$0644, H028+$0458 and 54 more
; --------------------------------------------------------------------------
L026_0000000C:
; H026+$0000000C: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L026_00000010:
; H026+$00000010: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L026_00000014:
; H026+$00000014: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000018:
; H026+$00000018: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L026_0000001C:
; H026+$0000001C: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_00000020:
; H026+$00000020: 67000008  beq.w $2a
        beq.w H026+$2A
L026_00000024:
; H026+$00000024: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_00000028:
; H026+$00000028: 60ea  bra.b $14
        bra.b H026+$14
L026_0000002A:
; H026+$0000002A: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L026_0000002E:
; H026+$0000002E: 60000002  bra.w $32
        bra.w H026+$32
L026_00000032:
; H026+$00000032: 4e5d  unlk a5
        unlk a5
L026_00000034:
; H026+$00000034: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_00000036:
; H026+$00000036: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L026_00000038:
; H026+$00000038: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_0000003A [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H026+$0156, H026+$0162, H030+$097E, H043+$1158, H043+$12DC, H043+$0ACA
; --------------------------------------------------------------------------
L026_0000003A:
; H026+$0000003A: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L026_0000003E:
; H026+$0000003E: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L026_00000042:
; H026+$00000042: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000046:
; H026+$00000046: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L026_0000004A:
; H026+$0000004A: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_0000004E:
; H026+$0000004E: 67000030  beq.w $80
        beq.w H026+$80
L026_00000052:
; H026+$00000052: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000056:
; H026+$00000056: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L026_0000005A:
; H026+$0000005A: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_0000005E:
; H026+$0000005E: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L026_00000062:
; H026+$00000062: 1c324000  move.b (a2, d4.w), d6
        move.b (a2, d4.w), d6
L026_00000066:
; H026+$00000066: 0c060061  cmpi.b #$61, d6
        cmpi.b #$61, d6
L026_0000006A:
; H026+$0000006A: 650a  bcs.b $76
        bcs.b H026+$76
L026_0000006C:
; H026+$0000006C: 0c06007a  cmpi.b #$7a, d6
        cmpi.b #$7a, d6
L026_00000070:
; H026+$00000070: 6204  bhi.b $76
        bhi.b H026+$76
L026_00000072:
; H026+$00000072: 0206005f  andi.b #$5f, d6
        andi.b #$5f, d6
L026_00000076:
; H026+$00000076: 17862000  move.b d6, (a3, d2.w)
        move.b d6, (a3, d2.w)
L026_0000007A:
; H026+$0000007A: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_0000007E:
; H026+$0000007E: 60c2  bra.b $42
        bra.b H026+$42
L026_00000080:
; H026+$00000080: 4e5d  unlk a5
        unlk a5
L026_00000082:
; H026+$00000082: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_00000084:
; H026+$00000084: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L026_00000086:
; H026+$00000086: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_00000088 [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H026+$0176, H009+$037E, H009+$03A4, H043+$0FAC, H043+$129A, H043+$132C and 14 more
; --------------------------------------------------------------------------
L026_00000088:
; H026+$00000088: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L026_0000008C:
; H026+$0000008C: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L026_00000090:
; H026+$00000090: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000094:
; H026+$00000094: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_00000098:
; H026+$00000098: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_0000009C:
; H026+$0000009C: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L026_000000A0:
; H026+$000000A0: 1c332000  move.b (a3, d2.w), d6
        move.b (a3, d2.w), d6
L026_000000A4:
; H026+$000000A4: bc324000  cmp.b (a2, d4.w), d6
        cmp.b (a2, d4.w), d6
L026_000000A8:
; H026+$000000A8: 66000020  bne.w $ca
        bne.w H026+$CA
L026_000000AC:
; H026+$000000AC: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_000000B0:
; H026+$000000B0: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_000000B4:
; H026+$000000B4: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_000000B8:
; H026+$000000B8: 66000008  bne.w $c2
        bne.w H026+$C2
L026_000000BC:
; H026+$000000BC: 7001  moveq #$1, d0
        moveq #1, d0
L026_000000BE:
; H026+$000000BE: 6000003c  bra.w $fc
        bra.w H026+$FC
L026_000000C2:
; H026+$000000C2: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_000000C6:
; H026+$000000C6: 60000006  bra.w $ce
        bra.w H026+$CE
L026_000000CA:
; H026+$000000CA: 60000004  bra.w $d0
        bra.w H026+$D0
L026_000000CE:
; H026+$000000CE: 60c0  bra.b $90
        bra.b H026+$90
L026_000000D0:
; H026+$000000D0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_000000D4:
; H026+$000000D4: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_000000D8:
; H026+$000000D8: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_000000DC:
; H026+$000000DC: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L026_000000E0:
; H026+$000000E0: 1c332000  move.b (a3, d2.w), d6
        move.b (a3, d2.w), d6
L026_000000E4:
; H026+$000000E4: bc324000  cmp.b (a2, d4.w), d6
        cmp.b (a2, d4.w), d6
L026_000000E8:
; H026+$000000E8: 6300000c  bls.w $f6
        bls.w H026+$F6
L026_000000EC:
; H026+$000000EC: 7002  moveq #$2, d0
        moveq #2, d0
L026_000000EE:
; H026+$000000EE: 6000000c  bra.w $fc
        bra.w H026+$FC
; Preserved bytes H026+$000000F2..$000000F6; code/data not fully classified.
        dc.w $6000,$0008
L026_000000F6:
; H026+$000000F6: 7000  moveq #$0, d0
        moveq #0, d0
L026_000000F8:
; H026+$000000F8: 60000002  bra.w $fc
        bra.w H026+$FC
L026_000000FC:
; H026+$000000FC: 4e5d  unlk a5
        unlk a5
L026_000000FE:
; H026+$000000FE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_00000100:
; H026+$00000100: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L026_00000104:
; H026+$00000104: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_00000106 [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H006+$01D0, H028+$0690, H028+$06DE, H035+$02B4, H035+$02D4, H029+$0A78 and 21 more
; --------------------------------------------------------------------------
L026_00000106:
; H026+$00000106: 4e550000  link.w a5, #$0
        link.w a5, #$0
L026_0000010A:
; H026+$0000010A: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L026_0000010E:
; H026+$0000010E: 5242  addq.w #$1, d2
        addq.w #$1, d2
L026_00000110:
; H026+$00000110: 08020000  btst.b #$0, d2
        btst #$0, d2
L026_00000114:
; H026+$00000114: 6702  beq.b $118
        beq.b H026+$118
L026_00000116:
; H026+$00000116: 5242  addq.w #$1, d2
        addq.w #$1, d2
L026_00000118:
; H026+$00000118: 9ec2  suba.w d2, a7
        suba.w d2, a7
L026_0000011A:
; H026+$0000011A: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_0000011E:
; H026+$0000011E: 2b4f000e  move.l a7, $e(a5)
        move.l a7, $e(a5)
L026_00000122:
; H026+$00000122: 244f  movea.l a7, a2
        movea.l a7, a2
L026_00000124:
; H026+$00000124: 5342  subq.w #$1, d2
        subq.w #$1, d2
L026_00000126:
; H026+$00000126: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L026_00000128:
; H026+$00000128: 51cafffc  dbra d2, $126
        dbra d2, H026+$126
L026_0000012C:
; H026+$0000012C: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L026_00000130:
; H026+$00000130: 5242  addq.w #$1, d2
        addq.w #$1, d2
L026_00000132:
; H026+$00000132: 08020000  btst.b #$0, d2
        btst #$0, d2
L026_00000136:
; H026+$00000136: 6702  beq.b $13a
        beq.b H026+$13A
L026_00000138:
; H026+$00000138: 5242  addq.w #$1, d2
        addq.w #$1, d2
L026_0000013A:
; H026+$0000013A: 9ec2  suba.w d2, a7
        suba.w d2, a7
L026_0000013C:
; H026+$0000013C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L026_00000140:
; H026+$00000140: 2b4f0008  move.l a7, $8(a5)
        move.l a7, $8(a5)
L026_00000144:
; H026+$00000144: 244f  movea.l a7, a2
        movea.l a7, a2
L026_00000146:
; H026+$00000146: 5342  subq.w #$1, d2
        subq.w #$1, d2
L026_00000148:
; H026+$00000148: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L026_0000014A:
; H026+$0000014A: 51cafffc  dbra d2, $148
        dbra d2, H026+$148
L026_0000014E:
; H026+$0000014E: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L026_00000152:
; H026+$00000152: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L026_00000156:
; H026+$00000156: 6100fee2  bsr.w $3a
        bsr.w H026+$3A
L026_0000015A:
; H026+$0000015A: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L026_0000015E:
; H026+$0000015E: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L026_00000162:
; H026+$00000162: 6100fed6  bsr.w $3a
        bsr.w H026+$3A
L026_00000166:
; H026+$00000166: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L026_0000016A:
; H026+$0000016A: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L026_0000016E:
; H026+$0000016E: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L026_00000172:
; H026+$00000172: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
L026_00000176:
; H026+$00000176: 6100ff10  bsr.w $88
        bsr.w H026+$88
L026_0000017A:
; H026+$0000017A: 60000002  bra.w $17e
        bra.w H026+$17E
L026_0000017E:
; H026+$0000017E: 4e5d  unlk a5
        unlk a5
L026_00000180:
; H026+$00000180: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_00000182:
; H026+$00000182: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L026_00000186:
; H026+$00000186: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_00000188 [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$059E, H043+$05FC, H028+$06B0, H028+$06C8, H009+$0186, H009+$019C and 131 more
; --------------------------------------------------------------------------
L026_00000188:
; H026+$00000188: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L026_0000018C:
; H026+$0000018C: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L026_00000190:
; H026+$00000190: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000194:
; H026+$00000194: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L026_00000198:
; H026+$00000198: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_0000019C:
; H026+$0000019C: 6700002c  beq.w $1ca
        beq.w H026+$1CA
L026_000001A0:
; H026+$000001A0: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L026_000001A4:
; H026+$000001A4: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_000001A8:
; H026+$000001A8: b842  cmp.w d2, d4
        cmp.w d2, d4
L026_000001AA:
; H026+$000001AA: 6400001e  bcc.w $1ca
        bcc.w H026+$1CA
L026_000001AE:
; H026+$000001AE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_000001B2:
; H026+$000001B2: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_000001B6:
; H026+$000001B6: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_000001BA:
; H026+$000001BA: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L026_000001BE:
; H026+$000001BE: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L026_000001C4:
; H026+$000001C4: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_000001C8:
; H026+$000001C8: 60c6  bra.b $190
        bra.b H026+$190
L026_000001CA:
; H026+$000001CA: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_000001CE:
; H026+$000001CE: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_000001D2:
; H026+$000001D2: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L026_000001D6:
; H026+$000001D6: 4e5d  unlk a5
        unlk a5
L026_000001D8:
; H026+$000001D8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_000001DA:
; H026+$000001DA: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L026_000001DE:
; H026+$000001DE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_000001E0 [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H056+$07D8, H062+$2288, H062+$229E, H056+$0948, H056+$095E, H056+$0974 and 281 more
; --------------------------------------------------------------------------
L026_000001E0:
; H026+$000001E0: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L026_000001E4:
; H026+$000001E4: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L026_000001E8:
; H026+$000001E8: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L026_000001EC:
; H026+$000001EC: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L026_000001F0:
; H026+$000001F0: 6100fe1a  bsr.w $c
        bsr.w H026+$C
L026_000001F4:
; H026+$000001F4: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L026_000001F8:
; H026+$000001F8: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_000001FC:
; H026+$000001FC: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L026_00000200:
; H026+$00000200: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_00000204:
; H026+$00000204: 67000032  beq.w $238
        beq.w H026+$238
L026_00000208:
; H026+$00000208: 342d0012  move.w $12(a5), d2
        move.w $12(a5), d2
L026_0000020C:
; H026+$0000020C: b46dfffc  cmp.w -$4(a5), d2
        cmp.w -$4(a5), d2
L026_00000210:
; H026+$00000210: 62000006  bhi.w $218
        bhi.w H026+$218
L026_00000214:
; H026+$00000214: 60000028  bra.w $23e
        bra.w H026+$23E
L026_00000218:
; H026+$00000218: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L026_0000021C:
; H026+$0000021C: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_00000220:
; H026+$00000220: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_00000224:
; H026+$00000224: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L026_00000228:
; H026+$00000228: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L026_0000022E:
; H026+$0000022E: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L026_00000232:
; H026+$00000232: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_00000236:
; H026+$00000236: 60c0  bra.b $1f8
        bra.b H026+$1F8
L026_00000238:
; H026+$00000238: 60000004  bra.w $23e
        bra.w H026+$23E
; Preserved bytes H026+$0000023C..$0000023E; code/data not fully classified.
        dc.w $60BA
L026_0000023E:
; H026+$0000023E: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L026_00000242:
; H026+$00000242: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_00000246:
; H026+$00000246: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L026_0000024A:
; H026+$0000024A: 4e5d  unlk a5
        unlk a5
L026_0000024C:
; H026+$0000024C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_0000024E:
; H026+$0000024E: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L026_00000252:
; H026+$00000252: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_00000254 [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H063+$100E, H014+$007A, H014+$0092, H009+$0294, H009+$0306, H063+$112C and 22 more
; --------------------------------------------------------------------------
L026_00000254:
; H026+$00000254: 4e55fff0  link.w a5, #$fff0
        link.w a5, #$fff0
L026_00000258:
; H026+$00000258: 3f2d000e  move.w $e(a5), -(a7)
        move.w $e(a5), -(a7)
L026_0000025C:
; H026+$0000025C: 2f2d000a  move.l $a(a5), -(a7)
        move.l $a(a5), -(a7)
L026_00000260:
; H026+$00000260: 6100fdaa  bsr.w $c
        bsr.w H026+$C
L026_00000264:
; H026+$00000264: 3b40fffe  move.w d0, -$2(a5)
        move.w d0, -$2(a5)
L026_00000268:
; H026+$00000268: 3f2d0014  move.w $14(a5), -(a7)
        move.w $14(a5), -(a7)
L026_0000026C:
; H026+$0000026C: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L026_00000270:
; H026+$00000270: 6100fd9a  bsr.w $c
        bsr.w H026+$C
L026_00000274:
; H026+$00000274: 3b40fffc  move.w d0, -$4(a5)
        move.w d0, -$4(a5)
L026_00000278:
; H026+$00000278: 342d0014  move.w $14(a5), d2
        move.w $14(a5), d2
L026_0000027C:
; H026+$0000027C: 3b42fffa  move.w d2, -$6(a5)
        move.w d2, -$6(a5)
L026_00000280:
; H026+$00000280: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L026_00000284:
; H026+$00000284: 946d0008  sub.w $8(a5), d2
        sub.w $8(a5), d2
L026_00000288:
; H026+$00000288: 5242  addq.w #$1, d2
        addq.w #$1, d2
L026_0000028A:
; H026+$0000028A: 3b42fff8  move.w d2, -$8(a5)
        move.w d2, -$8(a5)
L026_0000028E:
; H026+$0000028E: 3b6dfffcfff6  move.w -$4(a5), -$a(a5)
        move.w -$4(a5), -$a(a5)
L026_00000294:
; H026+$00000294: 342dfff6  move.w -$a(a5), d2
        move.w -$a(a5), d2
L026_00000298:
; H026+$00000298: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L026_0000029C:
; H026+$0000029C: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L026_000002A0:
; H026+$000002A0: 342d0008  move.w $8(a5), d2
        move.w $8(a5), d2
L026_000002A4:
; H026+$000002A4: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L026_000002A8:
; H026+$000002A8: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L026_000002AC:
; H026+$000002AC: 65000022  bcs.w $2d0
        bcs.w H026+$2D0
L026_000002B0:
; H026+$000002B0: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L026_000002B4:
; H026+$000002B4: 946d0008  sub.w $8(a5), d2
        sub.w $8(a5), d2
L026_000002B8:
; H026+$000002B8: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L026_000002BC:
; H026+$000002BC: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L026_000002C0:
; H026+$000002C0: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L026_000002C4:
; H026+$000002C4: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L026_000002C8:
; H026+$000002C8: 426dfff8  clr.w -$8(a5)
        clr.w -$8(a5)
L026_000002CC:
; H026+$000002CC: 6000004c  bra.w $31a
        bra.w H026+$31A
L026_000002D0:
; H026+$000002D0: 342d0008  move.w $8(a5), d2
        move.w $8(a5), d2
L026_000002D4:
; H026+$000002D4: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L026_000002D8:
; H026+$000002D8: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L026_000002DC:
; H026+$000002DC: b46dfffa  cmp.w -$6(a5), d2
        cmp.w -$6(a5), d2
L026_000002E0:
; H026+$000002E0: 65000038  bcs.w $31a
        bcs.w H026+$31A
L026_000002E4:
; H026+$000002E4: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L026_000002E8:
; H026+$000002E8: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L026_000002EC:
; H026+$000002EC: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L026_000002F0:
; H026+$000002F0: 342d0008  move.w $8(a5), d2
        move.w $8(a5), d2
L026_000002F4:
; H026+$000002F4: d46dfffe  add.w -$2(a5), d2
        add.w -$2(a5), d2
L026_000002F8:
; H026+$000002F8: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L026_000002FC:
; H026+$000002FC: 9842  sub.w d2, d4
        sub.w d2, d4
L026_000002FE:
; H026+$000002FE: 3b44fff8  move.w d4, -$8(a5)
        move.w d4, -$8(a5)
L026_00000302:
; H026+$00000302: 342d0008  move.w $8(a5), d2
        move.w $8(a5), d2
L026_00000306:
; H026+$00000306: d46dfff8  add.w -$8(a5), d2
        add.w -$8(a5), d2
L026_0000030A:
; H026+$0000030A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L026_0000030C:
; H026+$0000030C: 3b42fff6  move.w d2, -$a(a5)
        move.w d2, -$a(a5)
L026_00000310:
; H026+$00000310: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L026_00000314:
; H026+$00000314: 5342  subq.w #$1, d2
        subq.w #$1, d2
L026_00000316:
; H026+$00000316: 3b42fff4  move.w d2, -$c(a5)
        move.w d2, -$c(a5)
L026_0000031A:
; H026+$0000031A: 3b6dfff6fff0  move.w -$a(a5), -$10(a5)
        move.w -$a(a5), -$10(a5)
L026_00000320:
; H026+$00000320: 3b6dfff4fff2  move.w -$c(a5), -$e(a5)
        move.w -$c(a5), -$e(a5)
L026_00000326:
; H026+$00000326: 4a6dfff8  tst.w -$8(a5)
        tst.w -$8(a5)
L026_0000032A:
; H026+$0000032A: 63000026  bls.w $352
        bls.w H026+$352
L026_0000032E:
; H026+$0000032E: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L026_00000332:
; H026+$00000332: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L026_00000336:
; H026+$00000336: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L026_0000033A:
; H026+$0000033A: 246d0010  movea.l $10(a5), a2
        movea.l $10(a5), a2
L026_0000033E:
; H026+$0000033E: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L026_00000344:
; H026+$00000344: 536dfff2  subq.w #$1, -$e(a5)
        subq.w #$1, -$e(a5)
L026_00000348:
; H026+$00000348: 536dfff0  subq.w #$1, -$10(a5)
        subq.w #$1, -$10(a5)
L026_0000034C:
; H026+$0000034C: 536dfff8  subq.w #$1, -$8(a5)
        subq.w #$1, -$8(a5)
L026_00000350:
; H026+$00000350: 60d4  bra.b $326
        bra.b H026+$326
L026_00000352:
; H026+$00000352: 3b6d0008fff2  move.w $8(a5), -$e(a5)
        move.w $8(a5), -$e(a5)
L026_00000358:
; H026+$00000358: 426dfff0  clr.w -$10(a5)
        clr.w -$10(a5)
L026_0000035C:
; H026+$0000035C: 4a6dfffe  tst.w -$2(a5)
        tst.w -$2(a5)
L026_00000360:
; H026+$00000360: 63000026  bls.w $388
        bls.w H026+$388
L026_00000364:
; H026+$00000364: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L026_00000368:
; H026+$00000368: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L026_0000036C:
; H026+$0000036C: 382dfff0  move.w -$10(a5), d4
        move.w -$10(a5), d4
L026_00000370:
; H026+$00000370: 246d000a  movea.l $a(a5), a2
        movea.l $a(a5), a2
L026_00000374:
; H026+$00000374: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L026_0000037A:
; H026+$0000037A: 526dfff2  addq.w #$1, -$e(a5)
        addq.w #$1, -$e(a5)
L026_0000037E:
; H026+$0000037E: 526dfff0  addq.w #$1, -$10(a5)
        addq.w #$1, -$10(a5)
L026_00000382:
; H026+$00000382: 536dfffe  subq.w #$1, -$2(a5)
        subq.w #$1, -$2(a5)
L026_00000386:
; H026+$00000386: 60d4  bra.b $35c
        bra.b H026+$35C
L026_00000388:
; H026+$00000388: 4e5d  unlk a5
        unlk a5
L026_0000038A:
; H026+$0000038A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_0000038C:
; H026+$0000038C: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L026_00000390:
; H026+$00000390: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H026+$00000392..$000003F6; code/data not fully classified.
        dc.w $4E55,$FFFC,$426D,$FFFE,$3B6D,$0008,$FFFC,$342D
        dc.w $FFFE,$266D,$000A,$4A33,$2000,$6700,$003E,$342D
        dc.w $0014,$B46D,$FFFC,$6600,$0012,$342D,$FFFC,$266D
        dc.w $0010,$4233,$2000,$6000,$0022,$342D,$FFFC,$266D
        dc.w $0010,$382D,$FFFE,$246D,$000A,$17B2,$4000,$2000
        dc.w $526D,$FFFC,$526D,$FFFE,$60B4,$4E5D,$205F,$4FEF
        dc.w $000E,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_000003F6 [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H028+$04A4, H028+$054E, H063+$0AEA, H030+$0828, H066+$1CF4, H013+$55BC and 6 more
; --------------------------------------------------------------------------
L026_000003F6:
; H026+$000003F6: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L026_000003FA:
; H026+$000003FA: 342d000a  move.w $a(a5), d2
        move.w $a(a5), d2
L026_000003FE:
; H026+$000003FE: d46d0008  add.w $8(a5), d2
        add.w $8(a5), d2
L026_00000402:
; H026+$00000402: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L026_00000406:
; H026+$00000406: 3b6d000afffc  move.w $a(a5), -$4(a5)
        move.w $a(a5), -$4(a5)
L026_0000040C:
; H026+$0000040C: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000410:
; H026+$00000410: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L026_00000414:
; H026+$00000414: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_00000418:
; H026+$00000418: 67000022  beq.w $43c
        beq.w H026+$43C
L026_0000041C:
; H026+$0000041C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L026_00000420:
; H026+$00000420: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L026_00000424:
; H026+$00000424: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_00000428:
; H026+$00000428: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L026_0000042C:
; H026+$0000042C: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L026_00000432:
; H026+$00000432: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_00000436:
; H026+$00000436: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L026_0000043A:
; H026+$0000043A: 60d0  bra.b $40c
        bra.b H026+$40C
L026_0000043C:
; H026+$0000043C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L026_00000440:
; H026+$00000440: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L026_00000444:
; H026+$00000444: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L026_00000448:
; H026+$00000448: 4e5d  unlk a5
        unlk a5
L026_0000044A:
; H026+$0000044A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_0000044C:
; H026+$0000044C: 4fef000a  lea.l $a(a7), a7
        lea.l $a(a7), a7
L026_00000450:
; H026+$00000450: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_00000452 [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H035+$029E, H029+$0A62, H028+$0488, H028+$0532, H057+$318A, H066+$1B76 and 9 more
; --------------------------------------------------------------------------
L026_00000452:
; H026+$00000452: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L026_00000456:
; H026+$00000456: 3b6d000afffe  move.w $a(a5), -$2(a5)
        move.w $a(a5), -$2(a5)
L026_0000045C:
; H026+$0000045C: 426dfffc  clr.w -$4(a5)
        clr.w -$4(a5)
L026_00000460:
; H026+$00000460: 4a6d0008  tst.w $8(a5)
        tst.w $8(a5)
L026_00000464:
; H026+$00000464: 63000044  bls.w $4aa
        bls.w H026+$4AA
L026_00000468:
; H026+$00000468: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_0000046C:
; H026+$0000046C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L026_00000470:
; H026+$00000470: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_00000474:
; H026+$00000474: 67000034  beq.w $4aa
        beq.w H026+$4AA
L026_00000478:
; H026+$00000478: 342d0016  move.w $16(a5), d2
        move.w $16(a5), d2
L026_0000047C:
; H026+$0000047C: 382dfffc  move.w -$4(a5), d4
        move.w -$4(a5), d4
L026_00000480:
; H026+$00000480: b842  cmp.w d2, d4
        cmp.w d2, d4
L026_00000482:
; H026+$00000482: 64000026  bcc.w $4aa
        bcc.w H026+$4AA
L026_00000486:
; H026+$00000486: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L026_0000048A:
; H026+$0000048A: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L026_0000048E:
; H026+$0000048E: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L026_00000492:
; H026+$00000492: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L026_00000496:
; H026+$00000496: 17b240002000  move.b (a2, d4.w), (a3, d2.w)
        move.b (a2, d4.w), (a3, d2.w)
L026_0000049C:
; H026+$0000049C: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_000004A0:
; H026+$000004A0: 526dfffc  addq.w #$1, -$4(a5)
        addq.w #$1, -$4(a5)
L026_000004A4:
; H026+$000004A4: 536d0008  subq.w #$1, $8(a5)
        subq.w #$1, $8(a5)
L026_000004A8:
; H026+$000004A8: 60b6  bra.b $460
        bra.b H026+$460
L026_000004AA:
; H026+$000004AA: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L026_000004AE:
; H026+$000004AE: 266d0012  movea.l $12(a5), a3
        movea.l $12(a5), a3
L026_000004B2:
; H026+$000004B2: 42332000  clr.b (a3, d2.w)
        clr.b (a3, d2.w)
L026_000004B6:
; H026+$000004B6: 4e5d  unlk a5
        unlk a5
L026_000004B8:
; H026+$000004B8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_000004BA:
; H026+$000004BA: 4fef0010  lea.l $10(a7), a7
        lea.l $10(a7), a7
L026_000004BE:
; H026+$000004BE: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H026+$000004C0..$0000054E; code/data not fully classified.
        dc.w $4E55,$FFFA,$3B6D,$000A,$FFFE,$342D,$FFFE,$B46D
        dc.w $0008,$6200,$006A,$426D,$FFFC,$3B6D,$FFFE,$FFFA
        dc.w $342D,$FFFC,$266D,$000C,$4A33,$2000,$6600,$000A
        dc.w $302D,$FFFE,$6000,$004E,$342D,$FFFA,$266D,$0012
        dc.w $4A33,$2000,$6600,$0008,$70FF,$6000,$0038,$342D
        dc.w $FFFA,$266D,$0012,$382D,$FFFC,$246D,$000C,$1C33
        dc.w $2000,$BC32,$4000,$6700,$0006,$6000,$000C,$526D
        dc.w $FFFC,$526D,$FFFA,$60A8,$526D,$FFFE,$608C,$70FF
        dc.w $6000,$0002,$4E5D,$205F,$4FEF,$0010,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H026_0000054E [partial]
; Purpose: Routine of the string and buffer helpers with limits passed by the callers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H028+$0446, H066+$1CDA, H066+$05EE
; --------------------------------------------------------------------------
L026_0000054E:
; H026+$0000054E: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L026_00000552:
; H026+$00000552: 3b6d000afffe  move.w $a(a5), -$2(a5)
        move.w $a(a5), -$2(a5)
L026_00000558:
; H026+$00000558: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_0000055C:
; H026+$0000055C: b46d0008  cmp.w $8(a5), d2
        cmp.w $8(a5), d2
L026_00000560:
; H026+$00000560: 62000034  bhi.w $596
        bhi.w H026+$596
L026_00000564:
; H026+$00000564: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000568:
; H026+$00000568: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_0000056C:
; H026+$0000056C: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L026_00000570:
; H026+$00000570: 67000024  beq.w $596
        beq.w H026+$596
L026_00000574:
; H026+$00000574: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L026_00000578:
; H026+$00000578: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L026_0000057C:
; H026+$0000057C: 18332000  move.b (a3, d2.w), d4
        move.b (a3, d2.w), d4
L026_00000580:
; H026+$00000580: b82d000c  cmp.b $c(a5), d4
        cmp.b $c(a5), d4
L026_00000584:
; H026+$00000584: 6600000a  bne.w $590
        bne.w H026+$590
L026_00000588:
; H026+$00000588: 302dfffe  move.w -$2(a5), d0
        move.w -$2(a5), d0
L026_0000058C:
; H026+$0000058C: 6000000e  bra.w $59c
        bra.w H026+$59C
L026_00000590:
; H026+$00000590: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L026_00000594:
; H026+$00000594: 60c2  bra.b $558
        bra.b H026+$558
L026_00000596:
; H026+$00000596: 70ff  moveq #$ff, d0
        moveq #-1, d0
L026_00000598:
; H026+$00000598: 60000002  bra.w $59c
        bra.w H026+$59C
L026_0000059C:
; H026+$0000059C: 4e5d  unlk a5
        unlk a5
L026_0000059E:
; H026+$0000059E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L026_000005A0:
; H026+$000005A0: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L026_000005A4:
; H026+$000005A4: 4ed0  jmp (a0)
        jmp (a0)
L026_000005A6:
; H026+$000005A6: 4e5d  unlk a5
        unlk a5
L026_000005A8:
; H026+$000005A8: 4e75  rts 
        rts 
; Preserved bytes H026+$000005AA..$000005AC; code/data not fully classified.
        dc.w $0000
; End H026: $5AC bytes
