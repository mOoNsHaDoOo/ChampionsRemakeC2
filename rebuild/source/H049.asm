; ============================================================================
; MODULE GUIDE H049
; Text/glyph drawing, direct blitter and QBSBlit nodes.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Text/glyph drawing, direct blitter and QBSBlit nodes. H049+$0224 programs the custom registers between OwnBlitter and DisownBlitter; H049+$06EC is the callback of the queued blit.
; --------------------------------------------------------------------------
; H049: 2992 original bytes; all offsets are section-relative.
        section H049,code
H049:
; Preserved bytes H049+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H049+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H049_00000008 [partial]
; Purpose: Routine of the text/glyph drawing, direct blitter and QBSBlit nodes module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0084
; --------------------------------------------------------------------------
L049_00000008:
; H049+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H049+$4(pc), a0
L049_0000000C:
; H049+$0000000C: 216cffecfffc  move.l -$14(a4), -$4(a0)
        move.l -$14(a4), -$4(a0)
L049_00000012:
; H049+$00000012: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H049_0082 [partial]
; Purpose: Trampoline to H049+$0082; the actual body is there.
;   - Jumps to the actual body at H049+$0082.
; Direct callers: H011+$09A0
; --------------------------------------------------------------------------
L049_00000014:
; H049+$00000014: 4e550000  link.w a5, #$0
        link.w a5, #$0
L049_00000018:
; H049+$00000018: 584d  addq.w #$4, a5
        addq.w #$4, a5
L049_0000001A:
; H049+$0000001A: 48e73f3a  movem.l d2-d7/a2-a4/a6, -(a7)
        movem.l d2-d7/a2-a4/a6, -(a7)
L049_0000001E:
; H049+$0000001E: 0c6d002e000c  cmpi.w #$2e, $c(a5)
        cmpi.w #$2e, $c(a5)
L049_00000024:
; H049+$00000024: 6c0c  bge.b $32
        bge.b H049+$32
L049_00000026:
; H049+$00000026: 303c0000  move.w #$0, d0
        move.w #$0, d0
L049_0000002A:
; H049+$0000002A: 046d0001000c  subi.w #$1, $c(a5)
        subi.w #$1, $c(a5)
L049_00000030:
; H049+$00000030: 6050  bra.b $82
        bra.b H049+$82
L049_00000032:
; H049+$00000032: 0c6d0074000c  cmpi.w #$74, $c(a5)
        cmpi.w #$74, $c(a5)
L049_00000038:
; H049+$00000038: 6c0c  bge.b $46
        bge.b H049+$46
L049_0000003A:
; H049+$0000003A: 303c0001  move.w #$1, d0
        move.w #$1, d0
L049_0000003E:
; H049+$0000003E: 046d002e000c  subi.w #$2e, $c(a5)
        subi.w #$2e, $c(a5)
L049_00000044:
; H049+$00000044: 603c  bra.b $82
        bra.b H049+$82
L049_00000046:
; H049+$00000046: 0c6d00ba000c  cmpi.w #$ba, $c(a5)
        cmpi.w #$ba, $c(a5)
L049_0000004C:
; H049+$0000004C: 6c0c  bge.b $5a
        bge.b H049+$5A
L049_0000004E:
; H049+$0000004E: 303c0002  move.w #$2, d0
        move.w #$2, d0
L049_00000052:
; H049+$00000052: 046d0074000c  subi.w #$74, $c(a5)
        subi.w #$74, $c(a5)
L049_00000058:
; H049+$00000058: 6028  bra.b $82
        bra.b H049+$82
L049_0000005A:
; H049+$0000005A: 0c6d0100000c  cmpi.w #$100, $c(a5)
        cmpi.w #$100, $c(a5)
L049_00000060:
; H049+$00000060: 6c0c  bge.b $6e
        bge.b H049+$6E
L049_00000062:
; H049+$00000062: 303c0003  move.w #$3, d0
        move.w #$3, d0
L049_00000066:
; H049+$00000066: 046d00ba000c  subi.w #$ba, $c(a5)
        subi.w #$ba, $c(a5)
L049_0000006C:
; H049+$0000006C: 6014  bra.b $82
        bra.b H049+$82
L049_0000006E:
; H049+$0000006E: 0c6d0128000c  cmpi.w #$128, $c(a5)
        cmpi.w #$128, $c(a5)
L049_00000074:
; H049+$00000074: 6c0000a4  bge.w $11a
        bge.w H049+$11A
L049_00000078:
; H049+$00000078: 046d0100000c  subi.w #$100, $c(a5)
        subi.w #$100, $c(a5)
L049_0000007E:
; H049+$0000007E: 303c0004  move.w #$4, d0
        move.w #$4, d0
L049_00000082:
; H049+$00000082: e540  asl.w #$2, d0
        asl.w #$2, d0
L049_00000084:
; H049+$00000084: 206d0004  movea.l $4(a5), a0
        movea.l $4(a5), a0
L049_00000088:
; H049+$00000088: 20300000  move.l (a0, d0.w), d0
        move.l (a0, d0.w), d0
L049_0000008C:
; H049+$0000008C: 6700008c  beq.w $11a
        beq.w H049+$11A
L049_00000090:
; H049+$00000090: 2040  movea.l d0, a0
        movea.l d0, a0
L049_00000092:
; H049+$00000092: 4dfa0920  lea.l $9b4(pc), a6
        lea.l H049+$9B4(pc), a6
L049_00000096:
; H049+$00000096: 28680010  movea.l $10(a0), a4
        movea.l $10(a0), a4
L049_0000009A:
; H049+$0000009A: 302c0000  move.w $0(a4), d0
        move.w $0(a4), d0
L049_0000009E:
; H049+$0000009E: 3d400006  move.w d0, $6(a6)
        move.w d0, $6(a6)
L049_000000A2:
; H049+$000000A2: 3d6d000c0000  move.w $c(a5), $0(a6)
        move.w $c(a5), $0(a6)
L049_000000A8:
; H049+$000000A8: 2068000c  movea.l $c(a0), a0
        movea.l $c(a0), a0
L049_000000AC:
; H049+$000000AC: 20680008  movea.l $8(a0), a0
        movea.l $8(a0), a0
L049_000000B0:
; H049+$000000B0: d0ee0000  adda.w $0(a6), a0
        adda.w $0(a6), a0
L049_000000B4:
; H049+$000000B4: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L049_000000B8:
; H049+$000000B8: 302b0000  move.w $0(a3), d0
        move.w $0(a3), d0
L049_000000BC:
; H049+$000000BC: 3d400004  move.w d0, $4(a6)
        move.w d0, $4(a6)
L049_000000C0:
; H049+$000000C0: 322d000e  move.w $e(a5), d1
        move.w $e(a5), d1
L049_000000C4:
; H049+$000000C4: e741  asl.w #$3, d1
        asl.w #$3, d1
L049_000000C6:
; H049+$000000C6: c0c1  mulu.w d1, d0
        mulu.w d1, d0
L049_000000C8:
; H049+$000000C8: d06d0010  add.w $10(a5), d0
        add.w $10(a5), d0
L049_000000CC:
; H049+$000000CC: 3d400002  move.w d0, $2(a6)
        move.w d0, $2(a6)
L049_000000D0:
; H049+$000000D0: 343c0010  move.w #$10, d2
        move.w #$10, d2
L049_000000D4:
; H049+$000000D4: 323c0004  move.w #$4, d1
        move.w #$4, d1
L049_000000D8:
; H049+$000000D8: 24742008  movea.l $8(a4, d2.w), a2
        movea.l $8(a4, d2.w), a2
L049_000000DC:
; H049+$000000DC: d4ee0000  adda.w $0(a6), a2
        adda.w $0(a6), a2
L049_000000E0:
; H049+$000000E0: 4285  clr.l d5
        clr.l d5
L049_000000E2:
; H049+$000000E2: 22732008  movea.l $8(a3, d2.w), a1
        movea.l $8(a3, d2.w), a1
L049_000000E6:
; H049+$000000E6: d2ee0002  adda.w $2(a6), a1
        adda.w $2(a6), a1
L049_000000EA:
; H049+$000000EA: 4284  clr.l d4
        clr.l d4
L049_000000EC:
; H049+$000000EC: 303c0007  move.w #$7, d0
        move.w #$7, d0
L049_000000F0:
; H049+$000000F0: 1e305000  move.b (a0, d5.w), d7
        move.b (a0, d5.w), d7
L049_000000F4:
; H049+$000000F4: 1c325000  move.b (a2, d5.w), d6
        move.b (a2, d5.w), d6
L049_000000F8:
; H049+$000000F8: cc07  and.b d7, d6
        and.b d7, d6
L049_000000FA:
; H049+$000000FA: 4647  not.w d7
        not.w d7
L049_000000FC:
; H049+$000000FC: ce314000  and.b (a1, d4.w), d7
        and.b (a1, d4.w), d7
L049_00000100:
; H049+$00000100: 8e06  or.b d6, d7
        or.b d6, d7
L049_00000102:
; H049+$00000102: 13874000  move.b d7, (a1, d4.w)
        move.b d7, (a1, d4.w)
L049_00000106:
; H049+$00000106: da6e0006  add.w $6(a6), d5
        add.w $6(a6), d5
L049_0000010A:
; H049+$0000010A: d86e0004  add.w $4(a6), d4
        add.w $4(a6), d4
L049_0000010E:
; H049+$0000010E: 51c8ffe0  dbra d0, $f0
        dbra d0, H049+$F0
L049_00000112:
; H049+$00000112: 04420004  subi.w #$4, d2
        subi.w #$4, d2
L049_00000116:
; H049+$00000116: 51c9ffc0  dbra d1, $d8
        dbra d1, H049+$D8
L049_0000011A:
; H049+$0000011A: 4cdf5cfc  movem.l (a7)+, d2-d7/a2-a4/a6
        movem.l (a7)+, d2-d7/a2-a4/a6
L049_0000011E:
; H049+$0000011E: 594d  subq.w #$4, a5
        subq.w #$4, a5
L049_00000120:
; H049+$00000120: 4e5d  unlk a5
        unlk a5
L049_00000122:
; H049+$00000122: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L049_00000124:
; H049+$00000124: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L049_00000128:
; H049+$00000128: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H049_0198 [partial]
; Purpose: Trampoline to H049+$0198; the actual body is there.
;   - Jumps to the actual body at H049+$0198.
; Direct callers: H034+$01C0
; --------------------------------------------------------------------------
L049_0000012A:
; H049+$0000012A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L049_0000012E:
; H049+$0000012E: 584d  addq.w #$4, a5
        addq.w #$4, a5
L049_00000130:
; H049+$00000130: 48e73f3a  movem.l d2-d7/a2-a4/a6, -(a7)
        movem.l d2-d7/a2-a4/a6, -(a7)
L049_00000134:
; H049+$00000134: 0c6d002e000c  cmpi.w #$2e, $c(a5)
        cmpi.w #$2e, $c(a5)
L049_0000013A:
; H049+$0000013A: 6c0c  bge.b $148
        bge.b H049+$148
L049_0000013C:
; H049+$0000013C: 303c0000  move.w #$0, d0
        move.w #$0, d0
L049_00000140:
; H049+$00000140: 046d0001000c  subi.w #$1, $c(a5)
        subi.w #$1, $c(a5)
L049_00000146:
; H049+$00000146: 6050  bra.b $198
        bra.b H049+$198
L049_00000148:
; H049+$00000148: 0c6d0074000c  cmpi.w #$74, $c(a5)
        cmpi.w #$74, $c(a5)
L049_0000014E:
; H049+$0000014E: 6c0c  bge.b $15c
        bge.b H049+$15C
L049_00000150:
; H049+$00000150: 303c0001  move.w #$1, d0
        move.w #$1, d0
L049_00000154:
; H049+$00000154: 046d002e000c  subi.w #$2e, $c(a5)
        subi.w #$2e, $c(a5)
L049_0000015A:
; H049+$0000015A: 603c  bra.b $198
        bra.b H049+$198
L049_0000015C:
; H049+$0000015C: 0c6d00ba000c  cmpi.w #$ba, $c(a5)
        cmpi.w #$ba, $c(a5)
L049_00000162:
; H049+$00000162: 6c0c  bge.b $170
        bge.b H049+$170
L049_00000164:
; H049+$00000164: 303c0002  move.w #$2, d0
        move.w #$2, d0
L049_00000168:
; H049+$00000168: 046d0074000c  subi.w #$74, $c(a5)
        subi.w #$74, $c(a5)
L049_0000016E:
; H049+$0000016E: 6028  bra.b $198
        bra.b H049+$198
L049_00000170:
; H049+$00000170: 0c6d0100000c  cmpi.w #$100, $c(a5)
        cmpi.w #$100, $c(a5)
L049_00000176:
; H049+$00000176: 6c0c  bge.b $184
        bge.b H049+$184
L049_00000178:
; H049+$00000178: 303c0003  move.w #$3, d0
        move.w #$3, d0
L049_0000017C:
; H049+$0000017C: 046d00ba000c  subi.w #$ba, $c(a5)
        subi.w #$ba, $c(a5)
L049_00000182:
; H049+$00000182: 6014  bra.b $198
        bra.b H049+$198
L049_00000184:
; H049+$00000184: 0c6d0128000c  cmpi.w #$128, $c(a5)
        cmpi.w #$128, $c(a5)
L049_0000018A:
; H049+$0000018A: 6c000088  bge.w $214
        bge.w H049+$214
L049_0000018E:
; H049+$0000018E: 046d0100000c  subi.w #$100, $c(a5)
        subi.w #$100, $c(a5)
L049_00000194:
; H049+$00000194: 303c0004  move.w #$4, d0
        move.w #$4, d0
L049_00000198:
; H049+$00000198: e540  asl.w #$2, d0
        asl.w #$2, d0
L049_0000019A:
; H049+$0000019A: 206d0004  movea.l $4(a5), a0
        movea.l $4(a5), a0
L049_0000019E:
; H049+$0000019E: 20300000  move.l (a0, d0.w), d0
        move.l (a0, d0.w), d0
L049_000001A2:
; H049+$000001A2: 67000070  beq.w $214
        beq.w H049+$214
L049_000001A6:
; H049+$000001A6: 2040  movea.l d0, a0
        movea.l d0, a0
L049_000001A8:
; H049+$000001A8: 4dfa080a  lea.l $9b4(pc), a6
        lea.l H049+$9B4(pc), a6
L049_000001AC:
; H049+$000001AC: 28680010  movea.l $10(a0), a4
        movea.l $10(a0), a4
L049_000001B0:
; H049+$000001B0: 302c0000  move.w $0(a4), d0
        move.w $0(a4), d0
L049_000001B4:
; H049+$000001B4: 3d400006  move.w d0, $6(a6)
        move.w d0, $6(a6)
L049_000001B8:
; H049+$000001B8: 3d6d000c0000  move.w $c(a5), $0(a6)
        move.w $c(a5), $0(a6)
L049_000001BE:
; H049+$000001BE: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L049_000001C2:
; H049+$000001C2: 302b0000  move.w $0(a3), d0
        move.w $0(a3), d0
L049_000001C6:
; H049+$000001C6: 3d400004  move.w d0, $4(a6)
        move.w d0, $4(a6)
L049_000001CA:
; H049+$000001CA: 322d000e  move.w $e(a5), d1
        move.w $e(a5), d1
L049_000001CE:
; H049+$000001CE: e741  asl.w #$3, d1
        asl.w #$3, d1
L049_000001D0:
; H049+$000001D0: c0c1  mulu.w d1, d0
        mulu.w d1, d0
L049_000001D2:
; H049+$000001D2: d06d0010  add.w $10(a5), d0
        add.w $10(a5), d0
L049_000001D6:
; H049+$000001D6: 3d400002  move.w d0, $2(a6)
        move.w d0, $2(a6)
L049_000001DA:
; H049+$000001DA: 343c0010  move.w #$10, d2
        move.w #$10, d2
L049_000001DE:
; H049+$000001DE: 323c0004  move.w #$4, d1
        move.w #$4, d1
L049_000001E2:
; H049+$000001E2: 24742008  movea.l $8(a4, d2.w), a2
        movea.l $8(a4, d2.w), a2
L049_000001E6:
; H049+$000001E6: d4ee0000  adda.w $0(a6), a2
        adda.w $0(a6), a2
L049_000001EA:
; H049+$000001EA: 4285  clr.l d5
        clr.l d5
L049_000001EC:
; H049+$000001EC: 22732008  movea.l $8(a3, d2.w), a1
        movea.l $8(a3, d2.w), a1
L049_000001F0:
; H049+$000001F0: d2ee0002  adda.w $2(a6), a1
        adda.w $2(a6), a1
L049_000001F4:
; H049+$000001F4: 4284  clr.l d4
        clr.l d4
L049_000001F6:
; H049+$000001F6: 303c0007  move.w #$7, d0
        move.w #$7, d0
L049_000001FA:
; H049+$000001FA: 13b250004000  move.b (a2, d5.w), (a1, d4.w)
        move.b (a2, d5.w), (a1, d4.w)
L049_00000200:
; H049+$00000200: da6e0006  add.w $6(a6), d5
        add.w $6(a6), d5
L049_00000204:
; H049+$00000204: d86e0004  add.w $4(a6), d4
        add.w $4(a6), d4
L049_00000208:
; H049+$00000208: 51c8fff0  dbra d0, $1fa
        dbra d0, H049+$1FA
L049_0000020C:
; H049+$0000020C: 04420004  subi.w #$4, d2
        subi.w #$4, d2
L049_00000210:
; H049+$00000210: 51c9ffd0  dbra d1, $1e2
        dbra d1, H049+$1E2
L049_00000214:
; H049+$00000214: 4cdf5cfc  movem.l (a7)+, d2-d7/a2-a4/a6
        movem.l (a7)+, d2-d7/a2-a4/a6
L049_00000218:
; H049+$00000218: 594d  subq.w #$4, a5
        subq.w #$4, a5
L049_0000021A:
; H049+$0000021A: 4e5d  unlk a5
        unlk a5
L049_0000021C:
; H049+$0000021C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L049_0000021E:
; H049+$0000021E: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L049_00000222:
; H049+$00000222: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Draw_TextWithBlitter [verified]
; Purpose: Draws text using the blitter directly, with graphics.library arbitration.
;   - Loads $DFF000 into A3 and prepares geometry, masks and bitplanes.
;   - OwnBlitter acquires the resource and WaitBlit waits before programming the registers.
;   - Writes control, masks, pointers, modulos and BLTSIZE.
;   - DisownBlitter releases the resource.
; Direct callers: H030+$0278
; --------------------------------------------------------------------------
L049_00000224:
; H049+$00000224: 4e550000  link.w a5, #$0
        link.w a5, #$0
L049_00000228:
; H049+$00000228: 584d  addq.w #$4, a5
        addq.w #$4, a5
L049_0000022A:
; H049+$0000022A: 48e7071a  movem.l d5-d7/a3-a4/a6, -(a7)
        movem.l d5-d7/a3-a4/a6, -(a7)
; STEP: Hardware base of the custom registers, NOT the base of a library.
L049_0000022E:
; H049+$0000022E: 267c00dff000  movea.l #$dff000, a3
        movea.l #$dff000, a3
L049_00000234:
; H049+$00000234: 49fa0786  lea.l $9bc(pc), a4
        lea.l H049+$9BC(pc), a4
L049_00000238:
; H049+$00000238: 426c0014  clr.w $14(a4)
        clr.w $14(a4)
L049_0000023C:
; H049+$0000023C: 206d0004  movea.l $4(a5), a0
        movea.l $4(a5), a0
L049_00000240:
; H049+$00000240: 6100020c  bsr.w $44e
        bsr.w H049+$44E
L049_00000244:
; H049+$00000244: 4a00  tst.b d0
        tst.b d0
L049_00000246:
; H049+$00000246: 670001e0  beq.w $428
        beq.w H049+$428
L049_0000024A:
; H049+$0000024A: 323c0028  move.w #$28, d1
        move.w #$28, d1
L049_0000024E:
; H049+$0000024E: 926d0010  sub.w $10(a5), d1
        sub.w $10(a5), d1
L049_00000252:
; H049+$00000252: b041  cmp.w d1, d0
        cmp.w d1, d0
L049_00000254:
; H049+$00000254: 6d02  blt.b $258
        blt.b H049+$258
L049_00000256:
; H049+$00000256: 3001  move.w d1, d0
        move.w d1, d0
L049_00000258:
; H049+$00000258: 3940000a  move.w d0, $a(a4)
        move.w d0, $a(a4)
L049_0000025C:
; H049+$0000025C: 082d00000011  btst.b #$0, $11(a5)
        btst #$0, $11(a5)
L049_00000262:
; H049+$00000262: 6708  beq.b $26c
        beq.b H049+$26C
L049_00000264:
; H049+$00000264: 397c00ff0000  move.w #$ff, $0(a4)
        move.w #$ff, $0(a4)
L049_0000026A:
; H049+$0000026A: 6006  bra.b $272
        bra.b H049+$272
L049_0000026C:
; H049+$0000026C: 397cffff0000  move.w #$ffff, $0(a4)
        move.w #$ffff, $0(a4)
L049_00000272:
; H049+$00000272: 302d0010  move.w $10(a5), d0
        move.w $10(a5), d0
L049_00000276:
; H049+$00000276: d06c000a  add.w $a(a4), d0
        add.w $a(a4), d0
L049_0000027A:
; H049+$0000027A: 08000000  btst.b #$0, d0
        btst #$0, d0
L049_0000027E:
; H049+$0000027E: 6708  beq.b $288
        beq.b H049+$288
L049_00000280:
; H049+$00000280: 397cff000002  move.w #$ff00, $2(a4)
        move.w #$ff00, $2(a4)
L049_00000286:
; H049+$00000286: 6006  bra.b $28e
        bra.b H049+$28E
L049_00000288:
; H049+$00000288: 397cffff0002  move.w #$ffff, $2(a4)
        move.w #$ffff, $2(a4)
L049_0000028E:
; H049+$0000028E: 06400001  addi.w #$1, d0
        addi.w #$1, d0
L049_00000292:
; H049+$00000292: 08800000  bclr.b #$0, d0
        bclr #$0, d0
L049_00000296:
; H049+$00000296: 322d0010  move.w $10(a5), d1
        move.w $10(a5), d1
L049_0000029A:
; H049+$0000029A: 08810000  bclr.b #$0, d1
        bclr #$0, d1
L049_0000029E:
; H049+$0000029E: 9041  sub.w d1, d0
        sub.w d1, d0
L049_000002A0:
; H049+$000002A0: 39400006  move.w d0, $6(a4)
        move.w d0, $6(a4)
L049_000002A4:
; H049+$000002A4: e240  asr.w #$1, d0
        asr.w #$1, d0
L049_000002A6:
; H049+$000002A6: 06400200  addi.w #$200, d0
        addi.w #$200, d0
L049_000002AA:
; H049+$000002AA: 39400008  move.w d0, $8(a4)
        move.w d0, $8(a4)
L049_000002AE:
; H049+$000002AE: 302d000e  move.w $e(a5), d0
        move.w $e(a5), d0
L049_000002B2:
; H049+$000002B2: e740  asl.w #$3, d0
        asl.w #$3, d0
L049_000002B4:
; H049+$000002B4: c0fc0028  mulu.w #$28, d0
        mulu.w #$28, d0
L049_000002B8:
; H049+$000002B8: d240  add.w d0, d1
        add.w d0, d1
L049_000002BA:
; H049+$000002BA: 39410004  move.w d1, $4(a4)
        move.w d1, $4(a4)
L049_000002BE:
; H049+$000002BE: 4dfafd44  lea.l $4(pc), a6
        lea.l H049+$4(pc), a6
L049_000002C2:
; H049+$000002C2: 2c6efffc  movea.l -$4(a6), a6
        movea.l -$4(a6), a6
; STEP: OwnBlitter: acquires the blitter before the hardware writes.
L049_000002C6:
; H049+$000002C6: 4eaefe38  jsr -$1c8(a6) ; graphics.library/OwnBlitter
        jsr LVO_graphics_OwnBlitter(a6)
L049_000002CA:
; H049+$000002CA: 3e3c0004  move.w #$4, d7
        move.w #$4, d7
L049_000002CE:
; H049+$000002CE: 0f2d000d  btst.l d7, $d(a5)
        btst d7, $d(a5)
L049_000002D2:
; H049+$000002D2: 6610  bne.b $2e4
        bne.b H049+$2E4
L049_000002D4:
; H049+$000002D4: 0f2d000b  btst.l d7, $b(a5)
        btst d7, $b(a5)
L049_000002D8:
; H049+$000002D8: 6604  bne.b $2de
        bne.b H049+$2DE
L049_000002DA:
; H049+$000002DA: 4246  clr.w d6
        clr.w d6
L049_000002DC:
; H049+$000002DC: 6014  bra.b $2f2
        bra.b H049+$2F2
L049_000002DE:
; H049+$000002DE: 3c3cffff  move.w #$ffff, d6
        move.w #$ffff, d6
L049_000002E2:
; H049+$000002E2: 606e  bra.b $352
        bra.b H049+$352
L049_000002E4:
; H049+$000002E4: 0f2d000b  btst.l d7, $b(a5)
        btst d7, $b(a5)
L049_000002E8:
; H049+$000002E8: 6604  bne.b $2ee
        bne.b H049+$2EE
L049_000002EA:
; H049+$000002EA: 4246  clr.w d6
        clr.w d6
L049_000002EC:
; H049+$000002EC: 6064  bra.b $352
        bra.b H049+$352
L049_000002EE:
; H049+$000002EE: 3c3cffff  move.w #$ffff, d6
        move.w #$ffff, d6
L049_000002F2:
; H049+$000002F2: 4dfafd10  lea.l $4(pc), a6
        lea.l H049+$4(pc), a6
L049_000002F6:
; H049+$000002F6: 2c6efffc  movea.l -$4(a6), a6
        movea.l -$4(a6), a6
; STEP: WaitBlit: waits for the previous transfer.
L049_000002FA:
; H049+$000002FA: 4eaeff1c  jsr -$e4(a6) ; graphics.library/WaitBlit
        jsr LVO_graphics_WaitBlit(a6)
L049_000002FE:
; H049+$000002FE: 303c0028  move.w #$28, d0
        move.w #$28, d0
L049_00000302:
; H049+$00000302: 906c0006  sub.w $6(a4), d0
        sub.w $6(a4), d0
L049_00000306:
; H049+$00000306: 37400060  move.w d0, $60(a3)
        move.w d0, $60(a3)
L049_0000030A:
; H049+$0000030A: 37400066  move.w d0, $66(a3)
        move.w d0, $66(a3)
L049_0000030E:
; H049+$0000030E: 376c00000044  move.w $0(a4), $44(a3)
        move.w $0(a4), $44(a3)
L049_00000314:
; H049+$00000314: 376c00020046  move.w $2(a4), $46(a3)
        move.w $2(a4), $46(a3)
L049_0000031A:
; H049+$0000031A: 377c03ca0040  move.w #$3ca, $40(a3)
        move.w #$3ca, $40(a3)
L049_00000320:
; H049+$00000320: 377c00000042  move.w #$0, $42(a3)
        move.w #$0, $42(a3)
L049_00000326:
; H049+$00000326: 377cffff0074  move.w #$ffff, $74(a3)
        move.w #$ffff, $74(a3)
L049_0000032C:
; H049+$0000032C: 37460072  move.w d6, $72(a3)
        move.w d6, $72(a3)
L049_00000330:
; H049+$00000330: 3007  move.w d7, d0
        move.w d7, d0
L049_00000332:
; H049+$00000332: e540  asl.w #$2, d0
        asl.w #$2, d0
L049_00000334:
; H049+$00000334: 226c0010  movea.l $10(a4), a1
        movea.l $10(a4), a1
L049_00000338:
; H049+$00000338: 22710008  movea.l $8(a1, d0.w), a1
        movea.l $8(a1, d0.w), a1
L049_0000033C:
; H049+$0000033C: d2ec0004  adda.w $4(a4), a1
        adda.w $4(a4), a1
L049_00000340:
; H049+$00000340: 27490048  move.l a1, $48(a3)
        move.l a1, $48(a3)
L049_00000344:
; H049+$00000344: 27490054  move.l a1, $54(a3)
        move.l a1, $54(a3)
; STEP: Writing BLTSIZE starts the blit.
L049_00000348:
; H049+$00000348: 376c00080058  move.w $8(a4), $58(a3)
        move.w $8(a4), $58(a3)
L049_0000034E:
; H049+$0000034E: 600000c8  bra.w $418
        bra.w H049+$418
L049_00000352:
; H049+$00000352: 4a6c0014  tst.w $14(a4)
        tst.w $14(a4)
L049_00000356:
; H049+$00000356: 67000086  beq.w $3de
        beq.w H049+$3DE
L049_0000035A:
; H049+$0000035A: 4dfafca8  lea.l $4(pc), a6
        lea.l H049+$4(pc), a6
L049_0000035E:
; H049+$0000035E: 2c6efffc  movea.l -$4(a6), a6
        movea.l -$4(a6), a6
L049_00000362:
; H049+$00000362: 4eaeff1c  jsr -$e4(a6) ; graphics.library/WaitBlit
        jsr LVO_graphics_WaitBlit(a6)
L049_00000366:
; H049+$00000366: 303c0028  move.w #$28, d0
        move.w #$28, d0
L049_0000036A:
; H049+$0000036A: 906c0006  sub.w $6(a4), d0
        sub.w $6(a4), d0
L049_0000036E:
; H049+$0000036E: 37400062  move.w d0, $62(a3)
        move.w d0, $62(a3)
L049_00000372:
; H049+$00000372: 37400060  move.w d0, $60(a3)
        move.w d0, $60(a3)
L049_00000376:
; H049+$00000376: 37400066  move.w d0, $66(a3)
        move.w d0, $66(a3)
L049_0000037A:
; H049+$0000037A: 376c00000044  move.w $0(a4), $44(a3)
        move.w $0(a4), $44(a3)
L049_00000380:
; H049+$00000380: 376c00020046  move.w $2(a4), $46(a3)
        move.w $2(a4), $46(a3)
L049_00000386:
; H049+$00000386: 302c0018  move.w $18(a4), d0
        move.w $18(a4), d0
L049_0000038A:
; H049+$0000038A: b146  eor.w d0, d6
        eor.w d0, d6
L049_0000038C:
; H049+$0000038C: 6708  beq.b $396
        beq.b H049+$396
L049_0000038E:
; H049+$0000038E: 377c073a0040  move.w #$73a, $40(a3)
        move.w #$73a, $40(a3)
L049_00000394:
; H049+$00000394: 6006  bra.b $39c
        bra.b H049+$39C
L049_00000396:
; H049+$00000396: 377c07ca0040  move.w #$7ca, $40(a3)
        move.w #$7ca, $40(a3)
L049_0000039C:
; H049+$0000039C: 377c00000042  move.w #$0, $42(a3)
        move.w #$0, $42(a3)
L049_000003A2:
; H049+$000003A2: 377cffff0074  move.w #$ffff, $74(a3)
        move.w #$ffff, $74(a3)
L049_000003A8:
; H049+$000003A8: 3007  move.w d7, d0
        move.w d7, d0
L049_000003AA:
; H049+$000003AA: e540  asl.w #$2, d0
        asl.w #$2, d0
L049_000003AC:
; H049+$000003AC: 226c0010  movea.l $10(a4), a1
        movea.l $10(a4), a1
L049_000003B0:
; H049+$000003B0: 22710008  movea.l $8(a1, d0.w), a1
        movea.l $8(a1, d0.w), a1
L049_000003B4:
; H049+$000003B4: d2ec0004  adda.w $4(a4), a1
        adda.w $4(a4), a1
L049_000003B8:
; H049+$000003B8: 27490048  move.l a1, $48(a3)
        move.l a1, $48(a3)
L049_000003BC:
; H049+$000003BC: 27490054  move.l a1, $54(a3)
        move.l a1, $54(a3)
L049_000003C0:
; H049+$000003C0: 302c0016  move.w $16(a4), d0
        move.w $16(a4), d0
L049_000003C4:
; H049+$000003C4: e540  asl.w #$2, d0
        asl.w #$2, d0
L049_000003C6:
; H049+$000003C6: 226c0010  movea.l $10(a4), a1
        movea.l $10(a4), a1
L049_000003CA:
; H049+$000003CA: 22710008  movea.l $8(a1, d0.w), a1
        movea.l $8(a1, d0.w), a1
L049_000003CE:
; H049+$000003CE: d2ec0004  adda.w $4(a4), a1
        adda.w $4(a4), a1
L049_000003D2:
; H049+$000003D2: 2749004c  move.l a1, $4c(a3)
        move.l a1, $4c(a3)
L049_000003D6:
; H049+$000003D6: 376c00080058  move.w $8(a4), $58(a3)
        move.w $8(a4), $58(a3)
L049_000003DC:
; H049+$000003DC: 603a  bra.b $418
        bra.b H049+$418
L049_000003DE:
; H049+$000003DE: 39470016  move.w d7, $16(a4)
        move.w d7, $16(a4)
L049_000003E2:
; H049+$000003E2: 397c00010014  move.w #$1, $14(a4)
        move.w #$1, $14(a4)
L049_000003E8:
; H049+$000003E8: 39460018  move.w d6, $18(a4)
        move.w d6, $18(a4)
L049_000003EC:
; H049+$000003EC: 3007  move.w d7, d0
        move.w d7, d0
L049_000003EE:
; H049+$000003EE: e540  asl.w #$2, d0
        asl.w #$2, d0
L049_000003F0:
; H049+$000003F0: 226c0010  movea.l $10(a4), a1
        movea.l $10(a4), a1
L049_000003F4:
; H049+$000003F4: 22710008  movea.l $8(a1, d0.w), a1
        movea.l $8(a1, d0.w), a1
L049_000003F8:
; H049+$000003F8: d2ec0004  adda.w $4(a4), a1
        adda.w $4(a4), a1
L049_000003FC:
; H049+$000003FC: 082d00000011  btst.b #$0, $11(a5)
        btst #$0, $11(a5)
L049_00000402:
; H049+$00000402: 6704  beq.b $408
        beq.b H049+$408
L049_00000404:
; H049+$00000404: d2fc0001  adda.w #$1, a1
        adda.w #$1, a1
L049_00000408:
; H049+$00000408: 302c000a  move.w $a(a4), d0
        move.w $a(a4), d0
L049_0000040C:
; H049+$0000040C: 3a3c0028  move.w #$28, d5
        move.w #$28, d5
L049_00000410:
; H049+$00000410: 206d0004  movea.l $4(a5), a0
        movea.l $4(a5), a0
; FLOW: Calls Draw_GlyphRowsCPU (H049+$045A).
L049_00000414:
; H049+$00000414: 61000044  bsr.w $45a
        bsr.w H049+$45A
L049_00000418:
; H049+$00000418: 51cffeb4  dbra d7, $2ce
        dbra d7, H049+$2CE
L049_0000041C:
; H049+$0000041C: 4dfafbe6  lea.l $4(pc), a6
        lea.l H049+$4(pc), a6
L049_00000420:
; H049+$00000420: 2c6efffc  movea.l -$4(a6), a6
        movea.l -$4(a6), a6
; STEP: DisownBlitter: releases exclusive use of the blitter.
L049_00000424:
; H049+$00000424: 4eaefe32  jsr -$1ce(a6) ; graphics.library/DisownBlitter
        jsr LVO_graphics_DisownBlitter(a6)
L049_00000428:
; H049+$00000428: 4cdf58e0  movem.l (a7)+, d5-d7/a3-a4/a6
        movem.l (a7)+, d5-d7/a3-a4/a6
L049_0000042C:
; H049+$0000042C: 594d  subq.w #$4, a5
        subq.w #$4, a5
L049_0000042E:
; H049+$0000042E: 4e5d  unlk a5
        unlk a5
L049_00000430:
; H049+$00000430: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L049_00000432:
; H049+$00000432: 4fef000e  lea.l $e(a7), a7
        lea.l $e(a7), a7
L049_00000436:
; H049+$00000436: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H049_00000438 [partial]
; Purpose: Routine of the text/glyph drawing, direct blitter and QBSBlit nodes module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H030+$0C78
; --------------------------------------------------------------------------
L049_00000438:
; H049+$00000438: 41fa0582  lea.l $9bc(pc), a0
        lea.l H049+$9BC(pc), a0
L049_0000043C:
; H049+$0000043C: 216f0008000c  move.l $8(a7), $c(a0)
        move.l $8(a7), $c(a0)
L049_00000442:
; H049+$00000442: 216f00040010  move.l $4(a7), $10(a0)
        move.l $4(a7), $10(a0)
L049_00000448:
; H049+$00000448: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L049_0000044A:
; H049+$0000044A: 508f  addq.l #$8, a7
        addq.l #$8, a7
L049_0000044C:
; H049+$0000044C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H049_0450 [partial]
; Purpose: Trampoline to H049+$0450; the actual body is there.
;   - Jumps to the actual body at H049+$0450.
; Direct callers: H049+$0240
; --------------------------------------------------------------------------
L049_0000044E:
; H049+$0000044E: 4280  clr.l d0
        clr.l d0
L049_00000450:
; H049+$00000450: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L049_00000452:
; H049+$00000452: 6704  beq.b $458
        beq.b H049+$458
L049_00000454:
; H049+$00000454: 5280  addq.l #$1, d0
        addq.l #$1, d0
L049_00000456:
; H049+$00000456: 60f8  bra.b $450
        bra.b H049+$450
L049_00000458:
; H049+$00000458: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Draw_GlyphRowsCPU [verified]
; Purpose: Writes rows of glyphs into the bitmap using the CPU.
;   - Normalises the character code and computes the index into the font table.
;   - Reads eight rows of the glyph and writes bytes to the destination with stride D5.
;   - The path does not write to the custom registers: it works on the pixel memory.
; Direct callers: H049+$0414
; --------------------------------------------------------------------------
L049_0000045A:
; H049+$0000045A: 48e73820  movem.l d2-d4/a2, -(a7)
        movem.l d2-d4/a2, -(a7)
L049_0000045E:
; H049+$0000045E: 45fa055c  lea.l $9bc(pc), a2
        lea.l H049+$9BC(pc), a2
L049_00000462:
; H049+$00000462: 246a000c  movea.l $c(a2), a2
        movea.l $c(a2), a2
L049_00000466:
; H049+$00000466: 5340  subq.w #$1, d0
        subq.w #$1, d0
L049_00000468:
; H049+$00000468: 6b3e  bmi.b $4a8
        bmi.b H049+$4A8
L049_0000046A:
; H049+$0000046A: 4243  clr.w d3
        clr.w d3
L049_0000046C:
; H049+$0000046C: 1818  move.b (a0)+, d4
        move.b (a0)+, d4
L049_0000046E:
; H049+$0000046E: b83c0060  cmp.b #$60, d4
        cmp.b #$60, d4
L049_00000472:
; H049+$00000472: 6d04  blt.b $478
        blt.b H049+$478
L049_00000474:
; H049+$00000474: 04040020  subi.b #$20, d4
        subi.b #$20, d4
L049_00000478:
; H049+$00000478: 04040020  subi.b #$20, d4
        subi.b #$20, d4
L049_0000047C:
; H049+$0000047C: 1404  move.b d4, d2
        move.b d4, d2
L049_0000047E:
; H049+$0000047E: 0244000f  andi.w #$f, d4
        andi.w #$f, d4
L049_00000482:
; H049+$00000482: 02420030  andi.w #$30, d2
        andi.w #$30, d2
L049_00000486:
; H049+$00000486: e742  asl.w #$3, d2
        asl.w #$3, d2
L049_00000488:
; H049+$00000488: d842  add.w d2, d4
        add.w d2, d4
L049_0000048A:
; H049+$0000048A: 343c0007  move.w #$7, d2
        move.w #$7, d2
L049_0000048E:
; H049+$0000048E: 12324000  move.b (a2, d4.w), d1
        move.b (a2, d4.w), d1
L049_00000492:
; H049+$00000492: bd01  eor.b d6, d1
        eor.b d6, d1
L049_00000494:
; H049+$00000494: 13813000  move.b d1, (a1, d3.w)
        move.b d1, (a1, d3.w)
L049_00000498:
; H049+$00000498: 06440010  addi.w #$10, d4
        addi.w #$10, d4
L049_0000049C:
; H049+$0000049C: d645  add.w d5, d3
        add.w d5, d3
L049_0000049E:
; H049+$0000049E: 51caffee  dbra d2, $48e
        dbra d2, H049+$48E
L049_000004A2:
; H049+$000004A2: d2fc0001  adda.w #$1, a1
        adda.w #$1, a1
L049_000004A6:
; H049+$000004A6: 60be  bra.b $466
        bra.b H049+$466
L049_000004A8:
; H049+$000004A8: 4cdf041c  movem.l (a7)+, d2-d4/a2
        movem.l (a7)+, d2-d4/a2
L049_000004AC:
; H049+$000004AC: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Queue_BitplaneBlit [verified]
; Purpose: Prepares a node for a blit queued to graphics.library.
;   - Allocates 74 zeroed bytes and fills in geometry, pointers, minterms and masks.
;   - Registers the work callback H049+$06EC and the clean-up H049+$0782.
;   - Queues the node with QBSBlit.
; Direct callers: H029+$0C4E, H029+$0C94, H035+$0662, H042+$0FEC
; --------------------------------------------------------------------------
L049_000004AE:
; H049+$000004AE: 4e550000  link.w a5, #$0
        link.w a5, #$0
L049_000004B2:
; H049+$000004B2: 584d  addq.w #$4, a5
        addq.w #$4, a5
L049_000004B4:
; H049+$000004B4: 48e70020  movem.l a2, -(a7)
        movem.l a2, -(a7)
L049_000004B8:
; H049+$000004B8: 203c0000004a  move.l #$4a, d0
        move.l #$4a, d0
L049_000004BE:
; H049+$000004BE: 223c00010000  move.l #$10000, d1
        move.l #$10000, d1
L049_000004C4:
; H049+$000004C4: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L049_000004C8:
; H049+$000004C8: 4eaeff3a  jsr -$c6(a6) ; exec.library/AllocMem
        jsr LVO_exec_AllocMem(a6)
L049_000004CC:
; H049+$000004CC: 4a80  tst.l d0
        tst.l d0
L049_000004CE:
; H049+$000004CE: 6700020c  beq.w $6dc
        beq.w H049+$6DC
L049_000004D2:
; H049+$000004D2: 2440  movea.l d0, a2
        movea.l d0, a2
L049_000004D4:
; H049+$000004D4: 256d0004001a  move.l $4(a5), $1a(a2)
        move.l $4(a5), $1a(a2)
L049_000004DA:
; H049+$000004DA: 256d001a0012  move.l $1a(a5), $12(a2)
        move.l $1a(a5), $12(a2)
L049_000004E0:
; H049+$000004E0: 4aaa001a  tst.l $1a(a2)
        tst.l $1a(a2)
L049_000004E4:
; H049+$000004E4: 670e  beq.b $4f4
        beq.b H049+$4F4
L049_000004E6:
; H049+$000004E6: 206d0012  movea.l $12(a5), a0
        movea.l $12(a5), a0
L049_000004EA:
; H049+$000004EA: 20680004  movea.l $4(a0), a0
        movea.l $4(a0), a0
L049_000004EE:
; H049+$000004EE: 25480016  move.l a0, $16(a2)
        move.l a0, $16(a2)
L049_000004F2:
; H049+$000004F2: 6008  bra.b $4fc
        bra.b H049+$4FC
L049_000004F4:
; H049+$000004F4: 206d0012  movea.l $12(a5), a0
        movea.l $12(a5), a0
L049_000004F8:
; H049+$000004F8: 25480016  move.l a0, $16(a2)
        move.l a0, $16(a2)
L049_000004FC:
; H049+$000004FC: 4280  clr.l d0
        clr.l d0
L049_000004FE:
; H049+$000004FE: 10280005  move.b $5(a0), d0
        move.b $5(a0), d0
L049_00000502:
; H049+$00000502: 3540001e  move.w d0, $1e(a2)
        move.w d0, $1e(a2)
L049_00000506:
; H049+$00000506: 35400020  move.w d0, $20(a2)
        move.w d0, $20(a2)
L049_0000050A:
; H049+$0000050A: 426a0022  clr.w $22(a2)
        clr.w $22(a2)
L049_0000050E:
; H049+$0000050E: 302d0010  move.w $10(a5), d0
        move.w $10(a5), d0
L049_00000512:
; H049+$00000512: e640  asr.w #$3, d0
        asr.w #$3, d0
L049_00000514:
; H049+$00000514: 08800000  bclr.b #$0, d0
        bclr #$0, d0
L049_00000518:
; H049+$00000518: 35400034  move.w d0, $34(a2)
        move.w d0, $34(a2)
L049_0000051C:
; H049+$0000051C: 206a0016  movea.l $16(a2), a0
        movea.l $16(a2), a0
L049_00000520:
; H049+$00000520: 30280000  move.w $0(a0), d0
        move.w $0(a0), d0
L049_00000524:
; H049+$00000524: c1ed000e  muls.w $e(a5), d0
        muls.w $e(a5), d0
L049_00000528:
; H049+$00000528: d06a0034  add.w $34(a2), d0
        add.w $34(a2), d0
L049_0000052C:
; H049+$0000052C: 25400036  move.l d0, $36(a2)
        move.l d0, $36(a2)
L049_00000530:
; H049+$00000530: 302d0010  move.w $10(a5), d0
        move.w $10(a5), d0
L049_00000534:
; H049+$00000534: d06d000c  add.w $c(a5), d0
        add.w $c(a5), d0
L049_00000538:
; H049+$00000538: 5340  subq.w #$1, d0
        subq.w #$1, d0
L049_0000053A:
; H049+$0000053A: e640  asr.w #$3, d0
        asr.w #$3, d0
L049_0000053C:
; H049+$0000053C: 08800000  bclr.b #$0, d0
        bclr #$0, d0
L049_00000540:
; H049+$00000540: 906a0034  sub.w $34(a2), d0
        sub.w $34(a2), d0
L049_00000544:
; H049+$00000544: 5440  addq.w #$2, d0
        addq.w #$2, d0
L049_00000546:
; H049+$00000546: 35400030  move.w d0, $30(a2)
        move.w d0, $30(a2)
L049_0000054A:
; H049+$0000054A: 35400024  move.w d0, $24(a2)
        move.w d0, $24(a2)
L049_0000054E:
; H049+$0000054E: 302d0010  move.w $10(a5), d0
        move.w $10(a5), d0
L049_00000552:
; H049+$00000552: 0240000f  andi.w #$f, d0
        andi.w #$f, d0
L049_00000556:
; H049+$00000556: 35400032  move.w d0, $32(a2)
        move.w d0, $32(a2)
L049_0000055A:
; H049+$0000055A: 302d0018  move.w $18(a5), d0
        move.w $18(a5), d0
L049_0000055E:
; H049+$0000055E: e640  asr.w #$3, d0
        asr.w #$3, d0
L049_00000560:
; H049+$00000560: 08800000  bclr.b #$0, d0
        bclr #$0, d0
L049_00000564:
; H049+$00000564: 35400026  move.w d0, $26(a2)
        move.w d0, $26(a2)
L049_00000568:
; H049+$00000568: 206d001a  movea.l $1a(a5), a0
        movea.l $1a(a5), a0
L049_0000056C:
; H049+$0000056C: 30280000  move.w $0(a0), d0
        move.w $0(a0), d0
L049_00000570:
; H049+$00000570: c1ed0016  muls.w $16(a5), d0
        muls.w $16(a5), d0
L049_00000574:
; H049+$00000574: d06a0026  add.w $26(a2), d0
        add.w $26(a2), d0
L049_00000578:
; H049+$00000578: 25400028  move.l d0, $28(a2)
        move.l d0, $28(a2)
L049_0000057C:
; H049+$0000057C: 302d0018  move.w $18(a5), d0
        move.w $18(a5), d0
L049_00000580:
; H049+$00000580: d06d000c  add.w $c(a5), d0
        add.w $c(a5), d0
L049_00000584:
; H049+$00000584: 5340  subq.w #$1, d0
        subq.w #$1, d0
L049_00000586:
; H049+$00000586: e640  asr.w #$3, d0
        asr.w #$3, d0
L049_00000588:
; H049+$00000588: 08800000  bclr.b #$0, d0
        bclr #$0, d0
L049_0000058C:
; H049+$0000058C: 906a0026  sub.w $26(a2), d0
        sub.w $26(a2), d0
L049_00000590:
; H049+$00000590: 5440  addq.w #$2, d0
        addq.w #$2, d0
L049_00000592:
; H049+$00000592: 3540002c  move.w d0, $2c(a2)
        move.w d0, $2c(a2)
L049_00000596:
; H049+$00000596: b06a0024  cmp.w $24(a2), d0
        cmp.w $24(a2), d0
L049_0000059A:
; H049+$0000059A: 6f04  ble.b $5a0
        ble.b H049+$5A0
L049_0000059C:
; H049+$0000059C: 35400024  move.w d0, $24(a2)
        move.w d0, $24(a2)
L049_000005A0:
; H049+$000005A0: 302d0018  move.w $18(a5), d0
        move.w $18(a5), d0
L049_000005A4:
; H049+$000005A4: 0240000f  andi.w #$f, d0
        andi.w #$f, d0
L049_000005A8:
; H049+$000005A8: 3540002e  move.w d0, $2e(a2)
        move.w d0, $2e(a2)
L049_000005AC:
; H049+$000005AC: b06a0032  cmp.w $32(a2), d0
        cmp.w $32(a2), d0
L049_000005B0:
; H049+$000005B0: 6f06  ble.b $5b8
        ble.b H049+$5B8
L049_000005B2:
; H049+$000005B2: 08ea00000022  bset.b #$0, $22(a2)
        bset #$0, $22(a2)
L049_000005B8:
; H049+$000005B8: 303cffff  move.w #$ffff, d0
        move.w #$ffff, d0
L049_000005BC:
; H049+$000005BC: 322a002e  move.w $2e(a2), d1
        move.w $2e(a2), d1
L049_000005C0:
; H049+$000005C0: e268  lsr.w d1, d0
        lsr.w d1, d0
L049_000005C2:
; H049+$000005C2: 3540003e  move.w d0, $3e(a2)
        move.w d0, $3e(a2)
L049_000005C6:
; H049+$000005C6: 302d000c  move.w $c(a5), d0
        move.w $c(a5), d0
L049_000005CA:
; H049+$000005CA: 4440  neg.w d0
        neg.w d0
L049_000005CC:
; H049+$000005CC: 906d0018  sub.w $18(a5), d0
        sub.w $18(a5), d0
L049_000005D0:
; H049+$000005D0: 0240000f  andi.w #$f, d0
        andi.w #$f, d0
L049_000005D4:
; H049+$000005D4: 323cffff  move.w #$ffff, d1
        move.w #$ffff, d1
L049_000005D8:
; H049+$000005D8: e161  asl.w d0, d1
        asl.w d0, d1
L049_000005DA:
; H049+$000005DA: 35410040  move.w d1, $40(a2)
        move.w d1, $40(a2)
L049_000005DE:
; H049+$000005DE: 302a0032  move.w $32(a2), d0
        move.w $32(a2), d0
L049_000005E2:
; H049+$000005E2: 906a002e  sub.w $2e(a2), d0
        sub.w $2e(a2), d0
L049_000005E6:
; H049+$000005E6: 0240000f  andi.w #$f, d0
        andi.w #$f, d0
L049_000005EA:
; H049+$000005EA: e140  asl.w #$8, d0
        asl.w #$8, d0
L049_000005EC:
; H049+$000005EC: e940  asl.w #$4, d0
        asl.w #$4, d0
L049_000005EE:
; H049+$000005EE: 3540003c  move.w d0, $3c(a2)
        move.w d0, $3c(a2)
L049_000005F2:
; H049+$000005F2: 3540003a  move.w d0, $3a(a2)
        move.w d0, $3a(a2)
L049_000005F6:
; H049+$000005F6: 4280  clr.l d0
        clr.l d0
L049_000005F8:
; H049+$000005F8: 102d0008  move.b $8(a5), d0
        move.b $8(a5), d0
L049_000005FC:
; H049+$000005FC: 4aaa001a  tst.l $1a(a2)
        tst.l $1a(a2)
L049_00000600:
; H049+$00000600: 6706  beq.b $608
        beq.b H049+$608
L049_00000602:
; H049+$00000602: 00400f00  ori.w #$f00, d0
        ori.w #$f00, d0
L049_00000606:
; H049+$00000606: 6004  bra.b $60c
        bra.b H049+$60C
L049_00000608:
; H049+$00000608: 00400700  ori.w #$700, d0
        ori.w #$700, d0
L049_0000060C:
; H049+$0000060C: 816a003a  or.w d0, $3a(a2)
        or.w d0, $3a(a2)
L049_00000610:
; H049+$00000610: 082a00000022  btst.b #$0, $22(a2)
        btst #$0, $22(a2)
L049_00000616:
; H049+$00000616: 672a  beq.b $642
        beq.b H049+$642
L049_00000618:
; H049+$00000618: 04aa000000020036  subi.l #$2, $36(a2)
        subi.l #$2, $36(a2)
L049_00000620:
; H049+$00000620: 302a002e  move.w $2e(a2), d0
        move.w $2e(a2), d0
L049_00000624:
; H049+$00000624: b06a0032  cmp.w $32(a2), d0
        cmp.w $32(a2), d0
L049_00000628:
; H049+$00000628: 6e08  bgt.b $632
        bgt.b H049+$632
L049_0000062A:
; H049+$0000062A: 04aa000000020028  subi.l #$2, $28(a2)
        subi.l #$2, $28(a2)
L049_00000632:
; H049+$00000632: 302a0030  move.w $30(a2), d0
        move.w $30(a2), d0
L049_00000636:
; H049+$00000636: b06a0024  cmp.w $24(a2), d0
        cmp.w $24(a2), d0
L049_0000063A:
; H049+$0000063A: 6606  bne.b $642
        bne.b H049+$642
L049_0000063C:
; H049+$0000063C: 066a00020024  addi.w #$2, $24(a2)
        addi.w #$2, $24(a2)
L049_00000642:
; H049+$00000642: 302a0024  move.w $24(a2), d0
        move.w $24(a2), d0
L049_00000646:
; H049+$00000646: e240  asr.w #$1, d0
        asr.w #$1, d0
L049_00000648:
; H049+$00000648: 322d000a  move.w $a(a5), d1
        move.w $a(a5), d1
L049_0000064C:
; H049+$0000064C: ed41  asl.w #$6, d1
        asl.w #$6, d1
L049_0000064E:
; H049+$0000064E: d041  add.w d1, d0
        add.w d1, d0
L049_00000650:
; H049+$00000650: 35400042  move.w d0, $42(a2)
        move.w d0, $42(a2)
L049_00000654:
; H049+$00000654: 206d001a  movea.l $1a(a5), a0
        movea.l $1a(a5), a0
L049_00000658:
; H049+$00000658: 30280000  move.w $0(a0), d0
        move.w $0(a0), d0
L049_0000065C:
; H049+$0000065C: 906a0024  sub.w $24(a2), d0
        sub.w $24(a2), d0
L049_00000660:
; H049+$00000660: 35400044  move.w d0, $44(a2)
        move.w d0, $44(a2)
L049_00000664:
; H049+$00000664: 35400046  move.w d0, $46(a2)
        move.w d0, $46(a2)
L049_00000668:
; H049+$00000668: 206a0016  movea.l $16(a2), a0
        movea.l $16(a2), a0
L049_0000066C:
; H049+$0000066C: 30280000  move.w $0(a0), d0
        move.w $0(a0), d0
L049_00000670:
; H049+$00000670: 906a0024  sub.w $24(a2), d0
        sub.w $24(a2), d0
L049_00000674:
; H049+$00000674: 35400048  move.w d0, $48(a2)
        move.w d0, $48(a2)
L049_00000678:
; H049+$00000678: 302a002c  move.w $2c(a2), d0
        move.w $2c(a2), d0
L049_0000067C:
; H049+$0000067C: b06a0024  cmp.w $24(a2), d0
        cmp.w $24(a2), d0
L049_00000680:
; H049+$00000680: 6c1c  bge.b $69e
        bge.b H049+$69E
L049_00000682:
; H049+$00000682: 082a00000022  btst.b #$0, $22(a2)
        btst #$0, $22(a2)
L049_00000688:
; H049+$00000688: 6710  beq.b $69a
        beq.b H049+$69A
L049_0000068A:
; H049+$0000068A: 302a002e  move.w $2e(a2), d0
        move.w $2e(a2), d0
L049_0000068E:
; H049+$0000068E: b06a0032  cmp.w $32(a2), d0
        cmp.w $32(a2), d0
L049_00000692:
; H049+$00000692: 6e06  bgt.b $69a
        bgt.b H049+$69A
L049_00000694:
; H049+$00000694: 426a003e  clr.w $3e(a2)
        clr.w $3e(a2)
L049_00000698:
; H049+$00000698: 6004  bra.b $69e
        bra.b H049+$69E
L049_0000069A:
; H049+$0000069A: 426a0040  clr.w $40(a2)
        clr.w $40(a2)
L049_0000069E:
; H049+$0000069E: 43ea0000  lea.l $0(a2), a1
        lea.l $0(a2), a1
L049_000006A2:
; H049+$000006A2: 42a90000  clr.l $0(a1)
        clr.l $0(a1)
L049_000006A6:
; H049+$000006A6: 41fa0044  lea.l $6ec(pc), a0
        lea.l H049+$6EC(pc), a0
L049_000006AA:
; H049+$000006AA: 23480004  move.l a0, $4(a1)
        move.l a0, $4(a1)
L049_000006AE:
; H049+$000006AE: 41fa00d2  lea.l $782(pc), a0
        lea.l H049+$782(pc), a0
L049_000006B2:
; H049+$000006B2: 2348000e  move.l a0, $e(a1)
        move.l a0, $e(a1)
L049_000006B6:
; H049+$000006B6: 137c00400008  move.b #$40, $8(a1)
        move.b #$40, $8(a1)
L049_000006BC:
; H049+$000006BC: 336d000a000a  move.w $a(a5), $a(a1)
        move.w $a(a5), $a(a1)
L049_000006C2:
; H049+$000006C2: 302d000e  move.w $e(a5), d0
        move.w $e(a5), d0
L049_000006C6:
; H049+$000006C6: d06d000a  add.w $a(a5), d0
        add.w $a(a5), d0
L049_000006CA:
; H049+$000006CA: 3340000c  move.w d0, $c(a1)
        move.w d0, $c(a1)
L049_000006CE:
; H049+$000006CE: 4dfaf934  lea.l $4(pc), a6
        lea.l H049+$4(pc), a6
L049_000006D2:
; H049+$000006D2: 2c6efffc  movea.l -$4(a6), a6
        movea.l -$4(a6), a6
; STEP: QBSBlit: queues the node with the two callbacks already set.
L049_000006D6:
; H049+$000006D6: 4eaefeda  jsr -$126(a6) ; graphics.library/QBSBlit
        jsr LVO_graphics_QBSBlit(a6)
L049_000006DA:
; H049+$000006DA: 200a  move.l a2, d0
        move.l a2, d0
L049_000006DC:
; H049+$000006DC: 4cdf0400  movem.l (a7)+, a2
        movem.l (a7)+, a2
L049_000006E0:
; H049+$000006E0: 594d  subq.w #$4, a5
        subq.w #$4, a5
L049_000006E2:
; H049+$000006E2: 4e5d  unlk a5
        unlk a5
L049_000006E4:
; H049+$000006E4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L049_000006E6:
; H049+$000006E6: 4fef001a  lea.l $1a(a7), a7
        lea.l $1a(a7), a7
L049_000006EA:
; H049+$000006EA: 4ed0  jmp (a0)
        jmp (a0)
; FUNCTION: queued_blitter_callback
FN_queued_blitter_callback:
;
; --------------------------------------------------------------------------
; ROUTINE: QueuedBlit_Callback [verified]
; Purpose: Callback of the QBSBlit node that programs the hardware registers.
;   - A1 is the work node and A0 the custom base supplied by the graphics service.
;   - Transfers the node parameters to the blitter and starts the blit with BLTSIZE.
;   - Returns a state used for the continuation of the queue.
; --------------------------------------------------------------------------
L049_000006EC:
; H049+$000006EC: 48e70c28  movem.l d4-d5/a2/a4, -(a7)
        movem.l d4-d5/a2/a4, -(a7)
L049_000006F0:
; H049+$000006F0: 2449  movea.l a1, a2
        movea.l a1, a2
L049_000006F2:
; H049+$000006F2: 316a00440062  move.w $44(a2), $62(a0)
        move.w $44(a2), $62(a0)
L049_000006F8:
; H049+$000006F8: 316a00480060  move.w $48(a2), $60(a0)
        move.w $48(a2), $60(a0)
L049_000006FE:
; H049+$000006FE: 216a00460064  move.l $46(a2), $64(a0)
        move.l $46(a2), $64(a0)
L049_00000704:
; H049+$00000704: 216a003e0044  move.l $3e(a2), $44(a0)
        move.l $3e(a2), $44(a0)
L049_0000070A:
; H049+$0000070A: 216a003a0040  move.l $3a(a2), $40(a0)
        move.l $3a(a2), $40(a0)
L049_00000710:
; H049+$00000710: 046a00010020  subi.w #$1, $20(a2)
        subi.w #$1, $20(a2)
L049_00000716:
; H049+$00000716: 6a0a  bpl.b $722
        bpl.b H049+$722
L049_00000718:
; H049+$00000718: 49fa0064  lea.l $77e(pc), a4
        lea.l H049+$77E(pc), a4
L049_0000071C:
; H049+$0000071C: 288a  move.l a2, (a4)
        move.l a2, (a4)
L049_0000071E:
; H049+$0000071E: 4280  clr.l d0
        clr.l d0
L049_00000720:
; H049+$00000720: 6054  bra.b $776
        bra.b H049+$776
L049_00000722:
; H049+$00000722: 382a0020  move.w $20(a2), d4
        move.w $20(a2), d4
L049_00000726:
; H049+$00000726: 48c4  ext.l d4
        ext.l d4
L049_00000728:
; H049+$00000728: 2a04  move.l d4, d5
        move.l d4, d5
L049_0000072A:
; H049+$0000072A: e585  asl.l #$2, d5
        asl.l #$2, d5
L049_0000072C:
; H049+$0000072C: 202a001a  move.l $1a(a2), d0
        move.l $1a(a2), d0
L049_00000730:
; H049+$00000730: 6608  bne.b $73a
        bne.b H049+$73A
L049_00000732:
; H049+$00000732: 317cffff0074  move.w #$ffff, $74(a0)
        move.w #$ffff, $74(a0)
L049_00000738:
; H049+$00000738: 6008  bra.b $742
        bra.b H049+$742
L049_0000073A:
; H049+$0000073A: d0aa0028  add.l $28(a2), d0
        add.l $28(a2), d0
L049_0000073E:
; H049+$0000073E: 21400050  move.l d0, $50(a0)
        move.l d0, $50(a0)
L049_00000742:
; H049+$00000742: 222a0012  move.l $12(a2), d1
        move.l $12(a2), d1
L049_00000746:
; H049+$00000746: 2845  movea.l d5, a4
        movea.l d5, a4
L049_00000748:
; H049+$00000748: d9c1  adda.l d1, a4
        adda.l d1, a4
L049_0000074A:
; H049+$0000074A: 202c0008  move.l $8(a4), d0
        move.l $8(a4), d0
L049_0000074E:
; H049+$0000074E: d0aa0028  add.l $28(a2), d0
        add.l $28(a2), d0
L049_00000752:
; H049+$00000752: 2140004c  move.l d0, $4c(a0)
        move.l d0, $4c(a0)
L049_00000756:
; H049+$00000756: 222a0016  move.l $16(a2), d1
        move.l $16(a2), d1
L049_0000075A:
; H049+$0000075A: 2845  movea.l d5, a4
        movea.l d5, a4
L049_0000075C:
; H049+$0000075C: d9c1  adda.l d1, a4
        adda.l d1, a4
L049_0000075E:
; H049+$0000075E: 202c0008  move.l $8(a4), d0
        move.l $8(a4), d0
L049_00000762:
; H049+$00000762: d0aa0036  add.l $36(a2), d0
        add.l $36(a2), d0
L049_00000766:
; H049+$00000766: 21400048  move.l d0, $48(a0)
        move.l d0, $48(a0)
L049_0000076A:
; H049+$0000076A: 21400054  move.l d0, $54(a0)
        move.l d0, $54(a0)
L049_0000076E:
; H049+$0000076E: 316a00420058  move.w $42(a2), $58(a0)
        move.w $42(a2), $58(a0)
L049_00000774:
; H049+$00000774: 7001  moveq #$1, d0
        moveq #1, d0
L049_00000776:
; H049+$00000776: 4cdf1430  movem.l (a7)+, d4-d5/a2/a4
        movem.l (a7)+, d4-d5/a2/a4
L049_0000077A:
; H049+$0000077A: 4a80  tst.l d0
        tst.l d0
L049_0000077C:
; H049+$0000077C: 4e75  rts 
        rts 
; Preserved bytes H049+$0000077E..$00000782; code/data not fully classified.
        dc.w $4E71,$4E71
; FUNCTION: queued_blitter_cleanup
FN_queued_blitter_cleanup:
;
; --------------------------------------------------------------------------
; ROUTINE: QueuedBlit_Cleanup [verified]
; Purpose: Clean-up callback of the queued node.
;   - Retrieves the kept pointer and frees the 74 bytes of the node with FreeMem.
; --------------------------------------------------------------------------
L049_00000782:
; H049+$00000782: 48e70042  movem.l a1/a6, -(a7)
        movem.l a1/a6, -(a7)
L049_00000786:
; H049+$00000786: 227afff6  movea.l $77e(pc), a1
        movea.l H049+$77E(pc), a1
L049_0000078A:
; H049+$0000078A: 203c0000004a  move.l #$4a, d0
        move.l #$4a, d0
L049_00000790:
; H049+$00000790: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L049_00000794:
; H049+$00000794: 4eaeff2e  jsr -$d2(a6) ; graphics.library/MrgCop
        jsr LVO_graphics_MrgCop(a6)
L049_00000798:
; H049+$00000798: 4cdf4200  movem.l (a7)+, a1/a6
        movem.l (a7)+, a1/a6
L049_0000079C:
; H049+$0000079C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H049_0000079E [partial]
; Purpose: Routine of the text/glyph drawing, direct blitter and QBSBlit nodes module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H009+$01EA
; --------------------------------------------------------------------------
L049_0000079E:
; H049+$0000079E: 302f0004  move.w $4(a7), d0
        move.w $4(a7), d0
L049_000007A2:
; H049+$000007A2: 43fa0040  lea.l $7e4(pc), a1
        lea.l H049+$7E4(pc), a1
L049_000007A6:
; H049+$000007A6: 41fa0111  lea.l $8b9(pc), a0
        lea.l H049+$8B9(pc), a0
L049_000007AA:
; H049+$000007AA: c0fc0005  mulu.w #$5, d0
        mulu.w #$5, d0
L049_000007AE:
; H049+$000007AE: d0c0  adda.w d0, a0
        adda.w d0, a0
L049_000007B0:
; H049+$000007B0: 4280  clr.l d0
        clr.l d0
L049_000007B2:
; H049+$000007B2: 10280000  move.b $0(a0), d0
        move.b $0(a0), d0
L049_000007B6:
; H049+$000007B6: 33400004  move.w d0, $4(a1)
        move.w d0, $4(a1)
L049_000007BA:
; H049+$000007BA: 10280001  move.b $1(a0), d0
        move.b $1(a0), d0
L049_000007BE:
; H049+$000007BE: 33400006  move.w d0, $6(a1)
        move.w d0, $6(a1)
L049_000007C2:
; H049+$000007C2: 10280002  move.b $2(a0), d0
        move.b $2(a0), d0
L049_000007C6:
; H049+$000007C6: 33400008  move.w d0, $8(a1)
        move.w d0, $8(a1)
L049_000007CA:
; H049+$000007CA: 10280003  move.b $3(a0), d0
        move.b $3(a0), d0
L049_000007CE:
; H049+$000007CE: 3340000a  move.w d0, $a(a1)
        move.w d0, $a(a1)
L049_000007D2:
; H049+$000007D2: 10280004  move.b $4(a0), d0
        move.b $4(a0), d0
L049_000007D6:
; H049+$000007D6: 41fa0018  lea.l $7f0(pc), a0
        lea.l H049+$7F0(pc), a0
L049_000007DA:
; H049+$000007DA: d0c0  adda.w d0, a0
        adda.w d0, a0
L049_000007DC:
; H049+$000007DC: 23480000  move.l a0, $0(a1)
        move.l a0, $0(a1)
L049_000007E0:
; H049+$000007E0: 2009  move.l a1, d0
        move.l a1, d0
L049_000007E2:
; H049+$000007E2: 4e75  rts 
        rts 
; Preserved bytes H049+$000007E4..$000009D6; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0FFD,$01F7
        dc.w $0802,$F90B,$07FE,$0A00,$09F9,$0BF9,$05FF,$060E
        dc.w $0602,$F704,$FBF9,$02FD,$0907,$060C,$0B05,$04F9
        dc.w $FBF6,$F704,$0A09,$01FB,$060A,$FC05,$0B08,$0C07
        dc.w $FFFA,$01FA,$0005,$F607,$090E,$0605,$0508,$01FE
        dc.w $0809,$08F6,$0702,$0407,$09FC,$FB04,$FC07,$FA08
        dc.w $F6F4,$05F4,$0002,$010A,$F702,$FBFF,$FC10,$FAF8
        dc.w $05F9,$0404,$0708,$FB04,$0100,$08FD,$0505,$FA05
        dc.w $0CFB,$0807,$F703,$0908,$07FF,$FC09,$08FC,$0603
        dc.w $0800,$0CFA,$FE07,$F9FC,$070B,$0606,$F7FD,$08FD
        dc.w $F907,$FC07,$F60B,$FA07,$FD00,$0AF9,$06F7,$07F6
        dc.w $0BFA,$F8FB,$FB08,$0706,$FC0A,$F607,$F90D,$FF0A
        dc.w $FE0A,$FF03,$FB02,$FE01,$FA08,$F9F8,$FB08,$09FE
        dc.w $0101,$0EFF,$0605,$011A,$0200,$0902,$1A04,$0207
        dc.w $031A,$0206,$0906,$1A02,$0802,$071B,$030A,$0108
        dc.w $1B02,$0D07,$0C1C,$020F,$070E,$1D03,$1102,$101D
        dc.w $0414,$0713,$1E06,$1807,$141E,$031E,$0618,$1F04
        dc.w $2104,$1A1F,$0525,$031C,$1F04,$2A02,$1D1F,$042E
        dc.w $061E,$2002,$3207,$2120,$0534,$0523,$2005,$3909
        dc.w $2420,$043E,$0427,$2105,$4204,$3423,$0547,$0139
        dc.w $2403,$4C02,$4226,$054F,$0843,$2607,$5402,$4A28
        dc.w $045B,$0101,$2C03,$5F02,$032C,$0362,$0405,$2C05
        dc.w $6504,$092C,$056A,$020B,$2C04,$6F06,$0E2D,$0473
        dc.w $020F,$2D06,$7705,$112D,$037D,$0613,$2D06,$8003
        dc.w $142D,$0586,$0815,$2D02,$8B03,$172D,$038D,$0719
        dc.w $2D06,$9005,$1F2E,$0596,$0220,$2E06,$9B09,$242F
        dc.w $05A1,$0428,$2F04,$A608,$292F,$02AA,$042B,$2F05
        dc.w $AC04,$2C2F,$04B1,$082F,$3004,$B506,$3230,$05B9
        dc.w $0234,$3003,$BE04,$3530,$05C1,$0236,$3003,$C600
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000
; --------------------------------------------------------------------------
; ROUTINE: sub_H049_000009D6 [partial]
; Purpose: Routine of the text/glyph drawing, direct blitter and QBSBlit nodes module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H063+$2026, H035+$05E6, H042+$0232
; --------------------------------------------------------------------------
L049_000009D6:
; H049+$000009D6: 4e550000  link.w a5, #$0
        link.w a5, #$0
L049_000009DA:
; H049+$000009DA: 584d  addq.w #$4, a5
        addq.w #$4, a5
L049_000009DC:
; H049+$000009DC: 48e73f38  movem.l d2-d7/a2-a4, -(a7)
        movem.l d2-d7/a2-a4, -(a7)
L049_000009E0:
; H049+$000009E0: 49fa00cc  lea.l $aae(pc), a4
        lea.l H049+$AAE(pc), a4
L049_000009E4:
; H049+$000009E4: 303a00c6  move.w $aac(pc), d0
        move.w H049+$AAC(pc), d0
L049_000009E8:
; H049+$000009E8: 6728  beq.b $a12
        beq.b H049+$A12
L049_000009EA:
; H049+$000009EA: 41fa00c0  lea.l $aac(pc), a0
        lea.l H049+$AAC(pc), a0
L049_000009EE:
; H049+$000009EE: 4250  clr.w (a0)
        clr.w (a0)
L049_000009F0:
; H049+$000009F0: 4240  clr.w d0
        clr.w d0
L049_000009F2:
; H049+$000009F2: 7400  moveq #$0, d2
        moveq #0, d2
L049_000009F4:
; H049+$000009F4: 7607  moveq #$7, d3
        moveq #7, d3
L049_000009F6:
; H049+$000009F6: 0500  btst.l d2, d0
        btst d2, d0
L049_000009F8:
; H049+$000009F8: 6604  bne.b $9fe
        bne.b H049+$9FE
L049_000009FA:
; H049+$000009FA: 0781  bclr.b d3, d1
        bclr d3, d1
L049_000009FC:
; H049+$000009FC: 6002  bra.b $a00
        bra.b H049+$A00
L049_000009FE:
; H049+$000009FE: 07c1  bset.b d3, d1
        bset d3, d1
L049_00000A00:
; H049+$00000A00: 5242  addq.w #$1, d2
        addq.w #$1, d2
L049_00000A02:
; H049+$00000A02: 51cbfff2  dbra d3, $9f6
        dbra d3, H049+$9F6
L049_00000A06:
; H049+$00000A06: 19810000  move.b d1, (a4, d0.w)
        move.b d1, (a4, d0.w)
L049_00000A0A:
; H049+$00000A0A: 5240  addq.w #$1, d0
        addq.w #$1, d0
L049_00000A0C:
; H049+$00000A0C: b07c0100  cmp.w #$100, d0
        cmp.w #$100, d0
L049_00000A10:
; H049+$00000A10: 66e0  bne.b $9f2
        bne.b H049+$9F2
L049_00000A12:
; H049+$00000A12: 4aad0008  tst.l $8(a5)
        tst.l $8(a5)
L049_00000A16:
; H049+$00000A16: 6754  beq.b $a6c
        beq.b H049+$A6C
L049_00000A18:
; H049+$00000A18: 4aad0004  tst.l $4(a5)
        tst.l $4(a5)
L049_00000A1C:
; H049+$00000A1C: 674e  beq.b $a6c
        beq.b H049+$A6C
L049_00000A1E:
; H049+$00000A1E: 246d0008  movea.l $8(a5), a2
        movea.l $8(a5), a2
L049_00000A22:
; H049+$00000A22: 266d0004  movea.l $4(a5), a3
        movea.l $4(a5), a3
L049_00000A26:
; H049+$00000A26: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L049_00000A2A:
; H049+$00000A2A: 362b0000  move.w $0(a3), d3
        move.w $0(a3), d3
L049_00000A2E:
; H049+$00000A2E: 202a000c  move.l $c(a2), d0
        move.l $c(a2), d0
L049_00000A32:
; H049+$00000A32: 671a  beq.b $a4e
        beq.b H049+$A4E
L049_00000A34:
; H049+$00000A34: 202b000c  move.l $c(a3), d0
        move.l $c(a3), d0
L049_00000A38:
; H049+$00000A38: 6714  beq.b $a4e
        beq.b H049+$A4E
L049_00000A3A:
; H049+$00000A3A: 206a000c  movea.l $c(a2), a0
        movea.l $c(a2), a0
L049_00000A3E:
; H049+$00000A3E: 20680008  movea.l $8(a0), a0
        movea.l $8(a0), a0
L049_00000A42:
; H049+$00000A42: 226b000c  movea.l $c(a3), a1
        movea.l $c(a3), a1
L049_00000A46:
; H049+$00000A46: 22690008  movea.l $8(a1), a1
        movea.l $8(a1), a1
L049_00000A4A:
; H049+$00000A4A: 6100002e  bsr.w $a7a
        bsr.w H049+$A7A
L049_00000A4E:
; H049+$00000A4E: 246a0010  movea.l $10(a2), a2
        movea.l $10(a2), a2
L049_00000A52:
; H049+$00000A52: 266b0010  movea.l $10(a3), a3
        movea.l $10(a3), a3
L049_00000A56:
; H049+$00000A56: 7804  moveq #$4, d4
        moveq #4, d4
L049_00000A58:
; H049+$00000A58: 3004  move.w d4, d0
        move.w d4, d0
L049_00000A5A:
; H049+$00000A5A: e540  asl.w #$2, d0
        asl.w #$2, d0
L049_00000A5C:
; H049+$00000A5C: 20720008  movea.l $8(a2, d0.w), a0
        movea.l $8(a2, d0.w), a0
L049_00000A60:
; H049+$00000A60: 22730008  movea.l $8(a3, d0.w), a1
        movea.l $8(a3, d0.w), a1
L049_00000A64:
; H049+$00000A64: 61000014  bsr.w $a7a
        bsr.w H049+$A7A
L049_00000A68:
; H049+$00000A68: 51ccffee  dbra d4, $a58
        dbra d4, H049+$A58
L049_00000A6C:
; H049+$00000A6C: 4cdf1cfc  movem.l (a7)+, d2-d7/a2-a4
        movem.l (a7)+, d2-d7/a2-a4
L049_00000A70:
; H049+$00000A70: 594d  subq.w #$4, a5
        subq.w #$4, a5
L049_00000A72:
; H049+$00000A72: 4e5d  unlk a5
        unlk a5
L049_00000A74:
; H049+$00000A74: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L049_00000A76:
; H049+$00000A76: 508f  addq.l #$8, a7
        addq.l #$8, a7
L049_00000A78:
; H049+$00000A78: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H049_0A8E [partial]
; Purpose: Trampoline to H049+$0A8E; the actual body is there.
;   - Jumps to the actual body at H049+$0A8E.
; Direct callers: H049+$0A4A, H049+$0A64
; --------------------------------------------------------------------------
L049_00000A7A:
; H049+$00000A7A: 4280  clr.l d0
        clr.l d0
L049_00000A7C:
; H049+$00000A7C: 08020000  btst.b #$0, d2
        btst #$0, d2
L049_00000A80:
; H049+$00000A80: 6708  beq.b $a8a
        beq.b H049+$A8A
L049_00000A82:
; H049+$00000A82: 7a01  moveq #$1, d5
        moveq #1, d5
L049_00000A84:
; H049+$00000A84: 3c02  move.w d2, d6
        move.w d2, d6
L049_00000A86:
; H049+$00000A86: 5246  addq.w #$1, d6
        addq.w #$1, d6
L049_00000A88:
; H049+$00000A88: 6004  bra.b $a8e
        bra.b H049+$A8E
L049_00000A8A:
; H049+$00000A8A: 4245  clr.w d5
        clr.w d5
L049_00000A8C:
; H049+$00000A8C: 3c02  move.w d2, d6
        move.w d2, d6
L049_00000A8E:
; H049+$00000A8E: 3e03  move.w d3, d7
        move.w d3, d7
L049_00000A90:
; H049+$00000A90: 5347  subq.w #$1, d7
        subq.w #$1, d7
L049_00000A92:
; H049+$00000A92: 3202  move.w d2, d1
        move.w d2, d1
L049_00000A94:
; H049+$00000A94: 5341  subq.w #$1, d1
        subq.w #$1, d1
L049_00000A96:
; H049+$00000A96: d2c2  adda.w d2, a1
        adda.w d2, a1
L049_00000A98:
; H049+$00000A98: 1018  move.b (a0)+, d0
        move.b (a0)+, d0
L049_00000A9A:
; H049+$00000A9A: 13340000  move.b (a4, d0.w), -(a1)
        move.b (a4, d0.w), -(a1)
L049_00000A9E:
; H049+$00000A9E: 51c9fff8  dbra d1, $a98
        dbra d1, H049+$A98
L049_00000AA2:
; H049+$00000AA2: d0c5  adda.w d5, a0
        adda.w d5, a0
L049_00000AA4:
; H049+$00000AA4: d2c6  adda.w d6, a1
        adda.w d6, a1
L049_00000AA6:
; H049+$00000AA6: 51cfffea  dbra d7, $a92
        dbra d7, H049+$A92
L049_00000AAA:
; H049+$00000AAA: 4e75  rts 
        rts 
; Preserved bytes H049+$00000AAC..$00000BB0; code/data not fully classified.
        dc.w $4E71,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000
; End H049: $BB0 bytes
