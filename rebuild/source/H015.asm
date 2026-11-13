; ============================================================================
; MODULE GUIDE H015
; Runtime, support arithmetic and library bases.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Program runtime: saves the context, opens DOS/graphics/intuition/layers/mathffp, tells CLI and Workbench apart and calls the continuation. It also contains small arithmetic services.
; --------------------------------------------------------------------------
; H015: 1016 original bytes; all offsets are section-relative.
        section H015,code
H015:
; Preserved bytes H015+$00000000..$00000042; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.l H015+$0000003E
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H015_0196 [partial]
; Purpose: Trampoline to H015+$0196; the actual body is there.
;   - Jumps to the actual body at H015+$0196.
;   - Calls exec.library/OpenLibrary (LVO -552).
;   - Calls exec.library/OpenLibrary (LVO -552).
;   - Calls exec.library/OpenLibrary (LVO -552).
;   - Calls exec.library/OpenLibrary (LVO -552).
; Direct callers: FN_program_entry (H000+$0000)
; --------------------------------------------------------------------------
L015_00000042:
; H015+$00000042: 60000152  bra.w $196
        bra.w H015+$196
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H015_033E [partial]
; Purpose: Trampoline to H015+$033E; the actual body is there.
;   - Jumps to the actual body at H015+$033E.
;   - Calls dos.library/Close (LVO -36).
;   - Calls exec.library/Forbid (LVO -132).
;   - Calls exec.library/ReplyMsg (LVO -378).
;   - Calls exec.library/CloseLibrary (LVO -414).
; Direct callers: H010+$0354
; --------------------------------------------------------------------------
L015_00000046:
; H015+$00000046: 600002f6  bra.w $33e
        bra.w H015+$33E
; --------------------------------------------------------------------------
; ROUTINE: sub_H015_0000004A [partial]
; Purpose: Routine of the runtime, support arithmetic and library bases module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H023+$0022, H023+$005C, H030+$0A64, H040+$039C, H040+$03F6, H066+$14A8 and 6 more
; --------------------------------------------------------------------------
L015_0000004A:
; H015+$0000004A: 48e73000  movem.l d2-d3, -(a7)
        movem.l d2-d3, -(a7)
L015_0000004E:
; H015+$0000004E: 3401  move.w d1, d2
        move.w d1, d2
L015_00000050:
; H015+$00000050: c4c0  mulu.w d0, d2
        mulu.w d0, d2
L015_00000052:
; H015+$00000052: 2601  move.l d1, d3
        move.l d1, d3
L015_00000054:
; H015+$00000054: 4843  swap d3
        swap d3
L015_00000056:
; H015+$00000056: c6c0  mulu.w d0, d3
        mulu.w d0, d3
L015_00000058:
; H015+$00000058: 4843  swap d3
        swap d3
L015_0000005A:
; H015+$0000005A: 4243  clr.w d3
        clr.w d3
L015_0000005C:
; H015+$0000005C: d483  add.l d3, d2
        add.l d3, d2
L015_0000005E:
; H015+$0000005E: 4840  swap d0
        swap d0
L015_00000060:
; H015+$00000060: c0c1  mulu.w d1, d0
        mulu.w d1, d0
L015_00000062:
; H015+$00000062: 4840  swap d0
        swap d0
L015_00000064:
; H015+$00000064: 4240  clr.w d0
        clr.w d0
L015_00000066:
; H015+$00000066: d082  add.l d2, d0
        add.l d2, d0
L015_00000068:
; H015+$00000068: 4cdf000c  movem.l (a7)+, d2-d3
        movem.l (a7)+, d2-d3
L015_0000006C:
; H015+$0000006C: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H015_0000006E [partial]
; Purpose: Routine of the runtime, support arithmetic and library bases module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H023+$0034, H023+$004E, H023+$006C, H045+$0226, H045+$027C
; --------------------------------------------------------------------------
L015_0000006E:
; H015+$0000006E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L015_00000070:
; H015+$00000070: 2401  move.l d1, d2
        move.l d1, d2
L015_00000072:
; H015+$00000072: 2200  move.l d0, d1
        move.l d0, d1
L015_00000074:
; H015+$00000074: 0c820000ffff  cmpi.l #$ffff, d2
        cmpi.l #$ffff, d2
L015_0000007A:
; H015+$0000007A: 6e1c  bgt.b $98
        bgt.b H015+$98
L015_0000007C:
; H015+$0000007C: 3c41  movea.w d1, a6
        movea.w d1, a6
L015_0000007E:
; H015+$0000007E: 4241  clr.w d1
        clr.w d1
L015_00000080:
; H015+$00000080: 4841  swap d1
        swap d1
L015_00000082:
; H015+$00000082: 82c2  divu.w d2, d1
        divu.w d2, d1
L015_00000084:
; H015+$00000084: 2001  move.l d1, d0
        move.l d1, d0
L015_00000086:
; H015+$00000086: 4841  swap d1
        swap d1
L015_00000088:
; H015+$00000088: 300e  move.w a6, d0
        move.w a6, d0
L015_0000008A:
; H015+$0000008A: 80c2  divu.w d2, d0
        divu.w d2, d0
L015_0000008C:
; H015+$0000008C: 3200  move.w d0, d1
        move.w d0, d1
L015_0000008E:
; H015+$0000008E: 4240  clr.w d0
        clr.w d0
L015_00000090:
; H015+$00000090: 4840  swap d0
        swap d0
L015_00000092:
; H015+$00000092: c141  exg.l d0, d1
        exg.l d0, d1
L015_00000094:
; H015+$00000094: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L015_00000096:
; H015+$00000096: 4e75  rts 
        rts 
L015_00000098:
; H015+$00000098: 2001  move.l d1, d0
        move.l d1, d0
L015_0000009A:
; H015+$0000009A: 4240  clr.w d0
        clr.w d0
L015_0000009C:
; H015+$0000009C: 4840  swap d0
        swap d0
L015_0000009E:
; H015+$0000009E: 4841  swap d1
        swap d1
L015_000000A0:
; H015+$000000A0: 4241  clr.w d1
        clr.w d1
L015_000000A2:
; H015+$000000A2: 2c42  movea.l d2, a6
        movea.l d2, a6
L015_000000A4:
; H015+$000000A4: 740f  moveq #$f, d2
        moveq #15, d2
L015_000000A6:
; H015+$000000A6: d281  add.l d1, d1
        add.l d1, d1
L015_000000A8:
; H015+$000000A8: d180  addx.l d0, d0
        addx.l d0, d0
L015_000000AA:
; H015+$000000AA: bdc0  cmpa.l d0, a6
        cmpa.l d0, a6
L015_000000AC:
; H015+$000000AC: 6e04  bgt.b $b2
        bgt.b H015+$B2
L015_000000AE:
; H015+$000000AE: 908e  sub.l a6, d0
        sub.l a6, d0
L015_000000B0:
; H015+$000000B0: 5241  addq.w #$1, d1
        addq.w #$1, d1
L015_000000B2:
; H015+$000000B2: 51cafff2  dbra d2, $a6
        dbra d2, H015+$A6
L015_000000B6:
; H015+$000000B6: c141  exg.l d0, d1
        exg.l d0, d1
L015_000000B8:
; H015+$000000B8: 241f  move.l (a7)+, d2
        move.l (a7)+, d2
L015_000000BA:
; H015+$000000BA: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H015_000000BC [partial]
; Purpose: Routine of the runtime, support arithmetic and library bases module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H087+$00B2, H030+$0A78, H065+$34E8, H070+$1734, H067+$0314, H070+$045C and 11 more
; --------------------------------------------------------------------------
L015_000000BC:
; H015+$000000BC: 3f03  move.w d3, -(a7)
        move.w d3, -(a7)
L015_000000BE:
; H015+$000000BE: 487a0016  pea.l $d6(pc)
        pea.l H015+$D6(pc)
L015_000000C2:
; H015+$000000C2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L015_000000C4:
; H015+$000000C4: 2401  move.l d1, d2
        move.l d1, d2
L015_000000C6:
; H015+$000000C6: 5bc3  smi.b d3
        smi.b d3
L015_000000C8:
; H015+$000000C8: 6a02  bpl.b $cc
        bpl.b H015+$CC
L015_000000CA:
; H015+$000000CA: 4482  neg.l d2
        neg.l d2
L015_000000CC:
; H015+$000000CC: 2200  move.l d0, d1
        move.l d0, d1
L015_000000CE:
; H015+$000000CE: 6aa4  bpl.b $74
        bpl.b H015+$74
L015_000000D0:
; H015+$000000D0: 4481  neg.l d1
        neg.l d1
L015_000000D2:
; H015+$000000D2: 4603  not.b d3
        not.b d3
L015_000000D4:
; H015+$000000D4: 609e  bra.b $74
        bra.b H015+$74
; Preserved bytes H015+$000000D6..$0000010C; code/data not fully classified.
        dc.w $4A03,$6702,$4480,$361F,$4E75,$202F,$0008,$222F
        dc.w $0004,$2C7A,$FF48,$2F57,$0008,$508F,$4EEE,$FFBE
        dc.w $202F,$0008,$222F,$0004,$2C7A,$FF32,$2F57,$0008
        dc.w $508F,$4EEE,$FFB8
; --------------------------------------------------------------------------
; ROUTINE: wrapper_SPMul [partial]
; Purpose: Adapter to mathffp.library/SPMul; wraps the library call.
;   - Calls mathffp.library/SPMul (LVO -78).
; Direct callers: H061+$3C70, H061+$3CA2, H061+$3CD4, H061+$3D06, H061+$3D38, H061+$3D6A and 1 more
; --------------------------------------------------------------------------
L015_0000010C:
; H015+$0000010C: 202f0008  move.l $8(a7), d0
        move.l $8(a7), d0
L015_00000110:
; H015+$00000110: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L015_00000114:
; H015+$00000114: 2c7aff1c  movea.l $32(pc), a6
        movea.l H015+$32(pc), a6
L015_00000118:
; H015+$00000118: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L015_0000011C:
; H015+$0000011C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L015_0000011E:
; H015+$0000011E: 4eeeffb2  jmp -$4e(a6) ; mathffp.library/SPMul
        jmp LVO_mathffp_SPMul(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_SPDiv [partial]
; Purpose: Adapter to mathffp.library/SPDiv; wraps the library call.
;   - Calls mathffp.library/SPDiv (LVO -84).
; Direct callers: H012+$1522
; --------------------------------------------------------------------------
L015_00000122:
; H015+$00000122: 202f0008  move.l $8(a7), d0
        move.l $8(a7), d0
L015_00000126:
; H015+$00000126: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L015_0000012A:
; H015+$0000012A: 2c7aff06  movea.l $32(pc), a6
        movea.l H015+$32(pc), a6
L015_0000012E:
; H015+$0000012E: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L015_00000132:
; H015+$00000132: 508f  addq.l #$8, a7
        addq.l #$8, a7
L015_00000134:
; H015+$00000134: 4eeeffac  jmp -$54(a6) ; mathffp.library/SPDiv
        jmp LVO_mathffp_SPDiv(a6)
; Preserved bytes H015+$00000138..$00000172; code/data not fully classified.
        dc.w $202F,$0008,$222F,$0004,$2C7A,$FEF0,$2F57,$0008
        dc.w $508F,$4EEE,$FFD6,$202F,$0004,$2C7A,$FEDE,$2F57
        dc.w $0004,$588F,$4EEE,$FFC4,$202F,$0004,$2C7A,$FECC
        dc.w $2F57,$0004,$588F,$4EEE,$FFCA
; --------------------------------------------------------------------------
; ROUTINE: wrapper_SPFlt [partial]
; Purpose: Adapter to mathffp.library/SPFlt; wraps the library call.
;   - Calls mathffp.library/SPFlt (LVO -36).
; Direct callers: H012+$1506, H012+$1514, H061+$3C62, H061+$3C94, H061+$3CC6, H061+$3CF8 and 3 more
; --------------------------------------------------------------------------
L015_00000172:
; H015+$00000172: 202f0004  move.l $4(a7), d0
        move.l $4(a7), d0
L015_00000176:
; H015+$00000176: 2c7afeba  movea.l $32(pc), a6
        movea.l H015+$32(pc), a6
L015_0000017A:
; H015+$0000017A: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L015_0000017E:
; H015+$0000017E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L015_00000180:
; H015+$00000180: 4eeeffdc  jmp -$24(a6) ; mathffp.library/SPFlt
        jmp LVO_mathffp_SPFlt(a6)
; --------------------------------------------------------------------------
; ROUTINE: sub_H015_00000184 [partial]
; Purpose: Service of the runtime, support arithmetic and library bases module; uses mathffp.library/SPFix, exec.library/OpenLibrary, exec.library/FindTask, dos.library/Input, dos.library/Output, exec.library/WaitPort, exec.library/GetMsg, dos.library/CurrentDir, dos.library/Open, dos.library/Close, exec.library/Forbid, exec.library/ReplyMsg, exec.library/CloseLibrary.
;   - Calls mathffp.library/SPFix (LVO -30).
;   - Calls exec.library/OpenLibrary (LVO -552).
;   - Calls exec.library/OpenLibrary (LVO -552).
;   - Calls exec.library/OpenLibrary (LVO -552).
; Direct callers: H061+$3C7A, H061+$3CAC, H061+$3CDE, H061+$3D10, H061+$3D42, H061+$3D74 and 1 more
; --------------------------------------------------------------------------
L015_00000184:
; H015+$00000184: 202f0004  move.l $4(a7), d0
        move.l $4(a7), d0
L015_00000188:
; H015+$00000188: 2c7afea8  movea.l $32(pc), a6
        movea.l H015+$32(pc), a6
L015_0000018C:
; H015+$0000018C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L015_00000190:
; H015+$00000190: 588f  addq.l #$4, a7
        addq.l #$4, a7
L015_00000192:
; H015+$00000192: 4eeeffe2  jmp -$1e(a6) ; mathffp.library/SPFix
        jmp LVO_mathffp_SPFix(a6)
; FUNCTION: runtime_start
FN_runtime_start:
;
; --------------------------------------------------------------------------
; ROUTINE: Runtime_Start [verified]
; Purpose: Prepares the library bases, current process and CLI/Workbench environment.
;   - Saves the initial stack, D0 and A0; reads ExecBase from $4.
;   - Opens DOS, graphics, intuition, layers and mathffp with minimum version zero.
;   - FindTask(NULL) and pr_CLI tell CLI and Workbench apart.
;   - Calls the continuation saved in A5: the start-up goes back to the H000 sequence.
; --------------------------------------------------------------------------
L015_00000196:
; H015+$00000196: 2a5f  movea.l (a7)+, a5
        movea.l (a7)+, a5
L015_00000198:
; H015+$00000198: 47fafea4  lea.l $3e(pc), a3
        lea.l H015+$3E(pc), a3
L015_0000019C:
; H015+$0000019C: 274fffdc  move.l a7, -$24(a3)
        move.l a7, -$24(a3)
L015_000001A0:
; H015+$000001A0: 2748ffe4  move.l a0, -$1c(a3)
        move.l a0, -$1c(a3)
L015_000001A4:
; H015+$000001A4: 2740ffe0  move.l d0, -$20(a3)
        move.l d0, -$20(a3)
L015_000001A8:
; H015+$000001A8: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L015_000001AC:
; H015+$000001AC: 274efffc  move.l a6, -$4(a3)
        move.l a6, -$4(a3)
L015_000001B0:
; H015+$000001B0: 7000  moveq #$0, d0
        moveq #0, d0
L015_000001B2:
; H015+$000001B2: 43fa01e2  lea.l $396(pc), a1
        lea.l H015+$396(pc), a1
L015_000001B6:
; H015+$000001B6: 4eaefdd8  jsr -$228(a6) ; exec.library/OpenLibrary
        jsr LVO_exec_OpenLibrary(a6)
L015_000001BA:
; H015+$000001BA: 2740fff8  move.l d0, -$8(a3)
        move.l d0, -$8(a3)
L015_000001BE:
; H015+$000001BE: 7000  moveq #$0, d0
        moveq #0, d0
L015_000001C0:
; H015+$000001C0: 43fa01e0  lea.l $3a2(pc), a1
        lea.l H015+$3A2(pc), a1
L015_000001C4:
; H015+$000001C4: 4eaefdd8  jsr -$228(a6) ; exec.library/OpenLibrary
        jsr LVO_exec_OpenLibrary(a6)
L015_000001C8:
; H015+$000001C8: 2740ffec  move.l d0, -$14(a3)
        move.l d0, -$14(a3)
L015_000001CC:
; H015+$000001CC: 7000  moveq #$0, d0
        moveq #0, d0
L015_000001CE:
; H015+$000001CE: 43fa01e3  lea.l $3b3(pc), a1
        lea.l H015+$3B3(pc), a1
L015_000001D2:
; H015+$000001D2: 4eaefdd8  jsr -$228(a6) ; exec.library/OpenLibrary
        jsr LVO_exec_OpenLibrary(a6)
L015_000001D6:
; H015+$000001D6: 2740fff0  move.l d0, -$10(a3)
        move.l d0, -$10(a3)
L015_000001DA:
; H015+$000001DA: 7000  moveq #$0, d0
        moveq #0, d0
L015_000001DC:
; H015+$000001DC: 43fa01e7  lea.l $3c5(pc), a1
        lea.l H015+$3C5(pc), a1
L015_000001E0:
; H015+$000001E0: 4eaefdd8  jsr -$228(a6) ; exec.library/OpenLibrary
        jsr LVO_exec_OpenLibrary(a6)
L015_000001E4:
; H015+$000001E4: 2740ffe8  move.l d0, -$18(a3)
        move.l d0, -$18(a3)
L015_000001E8:
; H015+$000001E8: 7000  moveq #$0, d0
        moveq #0, d0
L015_000001EA:
; H015+$000001EA: 43fa01e8  lea.l $3d4(pc), a1
        lea.l H015+$3D4(pc), a1
L015_000001EE:
; H015+$000001EE: 4eaefdd8  jsr -$228(a6) ; exec.library/OpenLibrary
        jsr LVO_exec_OpenLibrary(a6)
L015_000001F2:
; H015+$000001F2: 2740fff4  move.l d0, -$c(a3)
        move.l d0, -$c(a3)
L015_000001F6:
; H015+$000001F6: 93c9  suba.l a1, a1
        suba.l a1, a1
L015_000001F8:
; H015+$000001F8: 4eaefeda  jsr -$126(a6) ; exec.library/FindTask
        jsr LVO_exec_FindTask(a6)
L015_000001FC:
; H015+$000001FC: 2840  movea.l d0, a4
        movea.l d0, a4
L015_000001FE:
; H015+$000001FE: 4aac00ac  tst.l $ac(a4)
        tst.l $ac(a4)
L015_00000202:
; H015+$00000202: 670000c6  beq.w $2ca
        beq.w H015+$2CA
L015_00000206:
; H015+$00000206: 9efc0080  suba.w #$80, a7
        suba.w #$80, a7
L015_0000020A:
; H015+$0000020A: 204f  movea.l a7, a0
        movea.l a7, a0
L015_0000020C:
; H015+$0000020C: 2748ffca  move.l a0, -$36(a3)
        move.l a0, -$36(a3)
L015_00000210:
; H015+$00000210: 9efc0100  suba.w #$100, a7
        suba.w #$100, a7
L015_00000214:
; H015+$00000214: 224f  movea.l a7, a1
        movea.l a7, a1
L015_00000216:
; H015+$00000216: 7000  moveq #$0, d0
        moveq #0, d0
L015_00000218:
; H015+$00000218: 323c00fe  move.w #$fe, d1
        move.w #$fe, d1
L015_0000021C:
; H015+$0000021C: 246c00ac  movea.l $ac(a4), a2
        movea.l $ac(a4), a2
L015_00000220:
; H015+$00000220: d5ca  adda.l a2, a2
        adda.l a2, a2
L015_00000222:
; H015+$00000222: d5ca  adda.l a2, a2
        adda.l a2, a2
L015_00000224:
; H015+$00000224: 242a0034  move.l $34(a2), d2
        move.l $34(a2), d2
L015_00000228:
; H015+$00000228: e58a  lsl.l #$2, d2
        lsl.l #$2, d2
L015_0000022A:
; H015+$0000022A: 2742ffd8  move.l d2, -$28(a3)
        move.l d2, -$28(a3)
L015_0000022E:
; H015+$0000022E: 246a0010  movea.l $10(a2), a2
        movea.l $10(a2), a2
L015_00000232:
; H015+$00000232: d5ca  adda.l a2, a2
        adda.l a2, a2
L015_00000234:
; H015+$00000234: d5ca  adda.l a2, a2
        adda.l a2, a2
L015_00000236:
; H015+$00000236: 20c9  move.l a1, (a0)+
        move.l a1, (a0)+
L015_00000238:
; H015+$00000238: 5240  addq.w #$1, d0
        addq.w #$1, d0
L015_0000023A:
; H015+$0000023A: 7400  moveq #$0, d2
        moveq #0, d2
L015_0000023C:
; H015+$0000023C: 141a  move.b (a2)+, d2
        move.b (a2)+, d2
L015_0000023E:
; H015+$0000023E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L015_00000240:
; H015+$00000240: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L015_00000242:
; H015+$00000242: 5341  subq.w #$1, d1
        subq.w #$1, d1
L015_00000244:
; H015+$00000244: 51cafffa  dbra d2, $240
        dbra d2, H015+$240
L015_00000248:
; H015+$00000248: 4219  clr.b (a1)+
        clr.b (a1)+
L015_0000024A:
; H015+$0000024A: 5341  subq.w #$1, d1
        subq.w #$1, d1
L015_0000024C:
; H015+$0000024C: 242bffe0  move.l -$20(a3), d2
        move.l -$20(a3), d2
L015_00000250:
; H015+$00000250: 246bffe4  movea.l -$1c(a3), a2
        movea.l -$1c(a3), a2
L015_00000254:
; H015+$00000254: 6054  bra.b $2aa
        bra.b H015+$2AA
L015_00000256:
; H015+$00000256: 0c070020  cmpi.b #$20, d7
        cmpi.b #$20, d7
L015_0000025A:
; H015+$0000025A: 634e  bls.b $2aa
        bls.b H015+$2AA
L015_0000025C:
; H015+$0000025C: 0c400020  cmpi.w #$20, d0
        cmpi.w #$20, d0
L015_00000260:
; H015+$00000260: 644e  bcc.b $2b0
        bcc.b H015+$2B0
L015_00000262:
; H015+$00000262: 5240  addq.w #$1, d0
        addq.w #$1, d0
L015_00000264:
; H015+$00000264: 20c9  move.l a1, (a0)+
        move.l a1, (a0)+
L015_00000266:
; H015+$00000266: 0c070022  cmpi.b #$22, d7
        cmpi.b #$22, d7
L015_0000026A:
; H015+$0000026A: 6622  bne.b $28e
        bne.b H015+$28E
L015_0000026C:
; H015+$0000026C: 12c7  move.b d7, (a1)+
        move.b d7, (a1)+
L015_0000026E:
; H015+$0000026E: 5341  subq.w #$1, d1
        subq.w #$1, d1
L015_00000270:
; H015+$00000270: 6204  bhi.b $276
        bhi.b H015+$276
L015_00000272:
; H015+$00000272: 4219  clr.b (a1)+
        clr.b (a1)+
L015_00000274:
; H015+$00000274: 603a  bra.b $2b0
        bra.b H015+$2B0
L015_00000276:
; H015+$00000276: 1e1a  move.b (a2)+, d7
        move.b (a2)+, d7
L015_00000278:
; H015+$00000278: 5382  subq.l #$1, d2
        subq.l #$1, d2
L015_0000027A:
; H015+$0000027A: 6f0a  ble.b $286
        ble.b H015+$286
L015_0000027C:
; H015+$0000027C: 0c070022  cmpi.b #$22, d7
        cmpi.b #$22, d7
L015_00000280:
; H015+$00000280: 66ea  bne.b $26c
        bne.b H015+$26C
L015_00000282:
; H015+$00000282: 12c7  move.b d7, (a1)+
        move.b d7, (a1)+
L015_00000284:
; H015+$00000284: 5341  subq.w #$1, d1
        subq.w #$1, d1
L015_00000286:
; H015+$00000286: 4219  clr.b (a1)+
        clr.b (a1)+
L015_00000288:
; H015+$00000288: 5341  subq.w #$1, d1
        subq.w #$1, d1
L015_0000028A:
; H015+$0000028A: 6324  bls.b $2b0
        bls.b H015+$2B0
L015_0000028C:
; H015+$0000028C: 601c  bra.b $2aa
        bra.b H015+$2AA
L015_0000028E:
; H015+$0000028E: 12c7  move.b d7, (a1)+
        move.b d7, (a1)+
L015_00000290:
; H015+$00000290: 5341  subq.w #$1, d1
        subq.w #$1, d1
L015_00000292:
; H015+$00000292: 6204  bhi.b $298
        bhi.b H015+$298
L015_00000294:
; H015+$00000294: 4219  clr.b (a1)+
        clr.b (a1)+
L015_00000296:
; H015+$00000296: 6018  bra.b $2b0
        bra.b H015+$2B0
L015_00000298:
; H015+$00000298: 1e1a  move.b (a2)+, d7
        move.b (a2)+, d7
L015_0000029A:
; H015+$0000029A: 5382  subq.l #$1, d2
        subq.l #$1, d2
L015_0000029C:
; H015+$0000029C: 6f06  ble.b $2a4
        ble.b H015+$2A4
L015_0000029E:
; H015+$0000029E: 0c070020  cmpi.b #$20, d7
        cmpi.b #$20, d7
L015_000002A2:
; H015+$000002A2: 62ea  bhi.b $28e
        bhi.b H015+$28E
L015_000002A4:
; H015+$000002A4: 4219  clr.b (a1)+
        clr.b (a1)+
L015_000002A6:
; H015+$000002A6: 5341  subq.w #$1, d1
        subq.w #$1, d1
L015_000002A8:
; H015+$000002A8: 6306  bls.b $2b0
        bls.b H015+$2B0
L015_000002AA:
; H015+$000002AA: 1e1a  move.b (a2)+, d7
        move.b (a2)+, d7
L015_000002AC:
; H015+$000002AC: 5382  subq.l #$1, d2
        subq.l #$1, d2
L015_000002AE:
; H015+$000002AE: 6ea6  bgt.b $256
        bgt.b H015+$256
L015_000002B0:
; H015+$000002B0: 3740ffce  move.w d0, -$32(a3)
        move.w d0, -$32(a3)
L015_000002B4:
; H015+$000002B4: 2c6bfff8  movea.l -$8(a3), a6
        movea.l -$8(a3), a6
L015_000002B8:
; H015+$000002B8: 4eaeffca  jsr -$36(a6) ; dos.library/Input
        jsr LVO_dos_Input(a6)
L015_000002BC:
; H015+$000002BC: 2740ffd4  move.l d0, -$2c(a3)
        move.l d0, -$2c(a3)
L015_000002C0:
; H015+$000002C0: 4eaeffc4  jsr -$3c(a6) ; dos.library/Output
        jsr LVO_dos_Output(a6)
L015_000002C4:
; H015+$000002C4: 2740ffd0  move.l d0, -$30(a3)
        move.l d0, -$30(a3)
L015_000002C8:
; H015+$000002C8: 606e  bra.b $338
        bra.b H015+$338
L015_000002CA:
; H015+$000002CA: 276c0084ffd8  move.l $84(a4), -$28(a3)
        move.l $84(a4), -$28(a3)
L015_000002D0:
; H015+$000002D0: 41ec005c  lea.l $5c(a4), a0
        lea.l $5c(a4), a0
L015_000002D4:
; H015+$000002D4: 4eaefe80  jsr -$180(a6) ; exec.library/WaitPort
        jsr LVO_exec_WaitPort(a6)
L015_000002D8:
; H015+$000002D8: 41ec005c  lea.l $5c(a4), a0
        lea.l $5c(a4), a0
L015_000002DC:
; H015+$000002DC: 4eaefe8c  jsr -$174(a6) ; exec.library/GetMsg
        jsr LVO_exec_GetMsg(a6)
L015_000002E0:
; H015+$000002E0: 2740ffc6  move.l d0, -$3a(a3)
        move.l d0, -$3a(a3)
L015_000002E4:
; H015+$000002E4: 2440  movea.l d0, a2
        movea.l d0, a2
L015_000002E6:
; H015+$000002E6: 2c7afd4e  movea.l $36(pc), a6
        movea.l H015+$36(pc), a6
L015_000002EA:
; H015+$000002EA: 246a0024  movea.l $24(a2), a2
        movea.l $24(a2), a2
L015_000002EE:
; H015+$000002EE: 222a0000  move.l $0(a2), d1
        move.l $0(a2), d1
L015_000002F2:
; H015+$000002F2: 4eaeff82  jsr -$7e(a6) ; dos.library/CurrentDir
        jsr LVO_dos_CurrentDir(a6)
L015_000002F6:
; H015+$000002F6: 206a0004  movea.l $4(a2), a0
        movea.l $4(a2), a0
L015_000002FA:
; H015+$000002FA: 2e0f  move.l a7, d7
        move.l a7, d7
L015_000002FC:
; H015+$000002FC: 9efc0100  suba.w #$100, a7
        suba.w #$100, a7
L015_00000300:
; H015+$00000300: 224f  movea.l a7, a1
        movea.l a7, a1
L015_00000302:
; H015+$00000302: 45fa00e0  lea.l $3e4(pc), a2
        lea.l H015+$3E4(pc), a2
L015_00000306:
; H015+$00000306: 7010  moveq #$10, d0
        moveq #16, d0
L015_00000308:
; H015+$00000308: 12da  move.b (a2)+, (a1)+
        move.b (a2)+, (a1)+
L015_0000030A:
; H015+$0000030A: 51c8fffc  dbra d0, $308
        dbra d0, H015+$308
L015_0000030E:
; H015+$0000030E: 707f  moveq #$7f, d0
        moveq #127, d0
L015_00000310:
; H015+$00000310: 12d8  move.b (a0)+, (a1)+
        move.b (a0)+, (a1)+
L015_00000312:
; H015+$00000312: 57c8fffc  dbeq d0, $310
        dbeq d0, H015+$310
L015_00000316:
; H015+$00000316: 4219  clr.b (a1)+
        clr.b (a1)+
L015_00000318:
; H015+$00000318: 220f  move.l a7, d1
        move.l a7, d1
L015_0000031A:
; H015+$0000031A: 243c000003ed  move.l #MODE_OLDFILE, d2
        move.l #MODE_OLDFILE, d2
L015_00000320:
; H015+$00000320: 4eaeffe2  jsr -$1e(a6) ; dos.library/Open
        jsr LVO_dos_Open(a6)
L015_00000324:
; H015+$00000324: 2740ffd4  move.l d0, -$2c(a3)
        move.l d0, -$2c(a3)
L015_00000328:
; H015+$00000328: 2740ffd0  move.l d0, -$30(a3)
        move.l d0, -$30(a3)
L015_0000032C:
; H015+$0000032C: e588  lsl.l #$2, d0
        lsl.l #$2, d0
L015_0000032E:
; H015+$0000032E: 2040  movea.l d0, a0
        movea.l d0, a0
L015_00000330:
; H015+$00000330: 2968000800a4  move.l $8(a0), $a4(a4)
        move.l $8(a0), $a4(a4)
L015_00000336:
; H015+$00000336: 2e47  movea.l d7, a7
        movea.l d7, a7
L015_00000338:
; H015+$00000338: 49fafd04  lea.l $3e(pc), a4
        lea.l H015+$3E(pc), a4
L015_0000033C:
; H015+$0000033C: 4e95  jsr (a5)
        jsr (a5)
; FUNCTION: runtime_cleanup
FN_runtime_cleanup:
;
; --------------------------------------------------------------------------
; ROUTINE: Runtime_Cleanup [verified]
; Purpose: Restores the environment after the program returns.
;   - Restores the initial stack.
;   - In the Workbench path it closes the console and replies to the start-up message.
;   - Closes the five libraries and returns the final code.
; --------------------------------------------------------------------------
L015_0000033E:
; H015+$0000033E: 2e7afcda  movea.l $1a(pc), a7
        movea.l H015+$1A(pc), a7
L015_00000342:
; H015+$00000342: 203afcc0  move.l $4(pc), d0
        move.l H015+$4(pc), d0
L015_00000346:
; H015+$00000346: 671c  beq.b $364
        beq.b H015+$364
L015_00000348:
; H015+$00000348: 2c7afcec  movea.l $36(pc), a6
        movea.l H015+$36(pc), a6
L015_0000034C:
; H015+$0000034C: 223afcc0  move.l $e(pc), d1
        move.l H015+$E(pc), d1
L015_00000350:
; H015+$00000350: 4eaeffdc  jsr -$24(a6) ; dos.library/Close
        jsr LVO_dos_Close(a6)
L015_00000354:
; H015+$00000354: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L015_00000358:
; H015+$00000358: 4eaeff7c  jsr -$84(a6) ; exec.library/Forbid
        jsr LVO_exec_Forbid(a6)
L015_0000035C:
; H015+$0000035C: 227afca6  movea.l $4(pc), a1
        movea.l H015+$4(pc), a1
L015_00000360:
; H015+$00000360: 4eaefe86  jsr -$17a(a6) ; exec.library/ReplyMsg
        jsr LVO_exec_ReplyMsg(a6)
L015_00000364:
; H015+$00000364: 227afcd0  movea.l $36(pc), a1
        movea.l H015+$36(pc), a1
L015_00000368:
; H015+$00000368: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L015_0000036C:
; H015+$0000036C: 4eaefe62  jsr -$19e(a6) ; exec.library/CloseLibrary
        jsr LVO_exec_CloseLibrary(a6)
L015_00000370:
; H015+$00000370: 227afcb8  movea.l $2a(pc), a1
        movea.l H015+$2A(pc), a1
L015_00000374:
; H015+$00000374: 4eaefe62  jsr -$19e(a6) ; exec.library/CloseLibrary
        jsr LVO_exec_CloseLibrary(a6)
L015_00000378:
; H015+$00000378: 227afcb4  movea.l $2e(pc), a1
        movea.l H015+$2E(pc), a1
L015_0000037C:
; H015+$0000037C: 4eaefe62  jsr -$19e(a6) ; exec.library/CloseLibrary
        jsr LVO_exec_CloseLibrary(a6)
L015_00000380:
; H015+$00000380: 227afca4  movea.l $26(pc), a1
        movea.l H015+$26(pc), a1
L015_00000384:
; H015+$00000384: 4eaefe62  jsr -$19e(a6) ; exec.library/CloseLibrary
        jsr LVO_exec_CloseLibrary(a6)
L015_00000388:
; H015+$00000388: 227afca8  movea.l $32(pc), a1
        movea.l H015+$32(pc), a1
L015_0000038C:
; H015+$0000038C: 4eaefe62  jsr -$19e(a6) ; exec.library/CloseLibrary
        jsr LVO_exec_CloseLibrary(a6)
L015_00000390:
; H015+$00000390: 203afc6e  move.l $0(pc), d0
        move.l H015+$0(pc), d0
L015_00000394:
; H015+$00000394: 4e75  rts 
        rts 
; Preserved bytes H015+$00000396..$000003F8; code/data not fully classified.
        dc.w $646F,$732E,$6C69,$6272,$6172,$7900,$6772,$6170
        dc.w $6869,$6373,$2E6C,$6962,$7261,$7279,$0069,$6E74
        dc.w $7569,$7469,$6F6E,$2E6C,$6962,$7261,$7279,$006C
        dc.w $6179,$6572,$732E,$6C69,$6272,$6172,$7900,$6D61
        dc.w $7468,$6666,$702E,$6C69,$6272,$6172,$7900,$5241
        dc.w $573A,$3130,$2F31,$302F,$3332,$302F,$3830,$2F00
        dc.w $0000
; End H015: $3F8 bytes
