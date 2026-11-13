; ============================================================================
; MODULE GUIDE H094
; Audio callback: vertical server and software interrupt.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Audio callbacks: vertical server that calls Cause and soft interrupt that updates queues and requests of the device.
; --------------------------------------------------------------------------
; H094: 1904 original bytes; all offsets are section-relative.
        section H094,code
H094:
; Preserved bytes H094+$00000000..$00000004; code/data not fully classified.
        dc.l H094+$00000000
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Cause [partial]
; Purpose: Adapter to exec.library/Cause; wraps the library call.
;   - Calls exec.library/Cause (LVO -180).
; Direct callers: H000+$013E
; --------------------------------------------------------------------------
L094_00000004:
; H094+$00000004: 4e75  rts 
        rts 
; FUNCTION: audio_vblank_schedule_Cause
FN_audio_vblank_schedule_Cause:
;
; --------------------------------------------------------------------------
; ROUTINE: Audio_VBlankServer [verified]
; Purpose: Short vertical callback that hands the work to a software interrupt.
;   - Loads ExecBase and calls Cause using the node passed in A1.
;   - Returns zero to the system.
; --------------------------------------------------------------------------
L094_00000006:
; H094+$00000006: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
; STEP: Cause hands the audio processing to the registered software interrupt.
L094_0000000A:
; H094+$0000000A: 4eaeff4c  jsr -$b4(a6) ; exec.library/Cause
        jsr LVO_exec_Cause(a6)
L094_0000000E:
; H094+$0000000E: 203c00000000  move.l #$0, d0
        move.l #$0, d0
L094_00000014:
; H094+$00000014: 4e75  rts 
        rts 
; FUNCTION: audio_softinterrupt_worker
FN_audio_softinterrupt_worker:
;
; --------------------------------------------------------------------------
; ROUTINE: Audio_SoftInterrupt [verified]
; Purpose: Updates the sound structures and sends the requests to the device.
;   - Receives the state in A1 and keeps it in A5.
;   - Updates the counter and calls the local queue routines.
;   - The requests use GetMsg and audio.device/BeginIO.
; --------------------------------------------------------------------------
L094_00000016:
; H094+$00000016: 48e70004  movem.l a5, -(a7)
        movem.l a5, -(a7)
L094_0000001A:
; H094+$0000001A: 2a49  movea.l a1, a5
        movea.l a1, a5
L094_0000001C:
; H094+$0000001C: 202d0004  move.l $4(a5), d0
        move.l $4(a5), d0
L094_00000020:
; H094+$00000020: d1ad0000  add.l d0, $0(a5)
        add.l d0, $0(a5)
L094_00000024:
; H094+$00000024: 610000e2  bsr.w $108
        bsr.w H094+$108
L094_00000028:
; H094+$00000028: 61000010  bsr.w $3a
        bsr.w H094+$3A
L094_0000002C:
; H094+$0000002C: 61000476  bsr.w $4a4
        bsr.w H094+$4A4
L094_00000030:
; H094+$00000030: 4cdf2000  movem.l (a7)+, a5
        movem.l (a7)+, a5
L094_00000034:
; H094+$00000034: 303c0000  move.w #$0, d0
        move.w #$0, d0
L094_00000038:
; H094+$00000038: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_0000003A [partial]
; Purpose: Service of the audio callback module: vertical server and software interrupt; uses exec.library/GetMsg, audio.device/BeginIO.
;   - Calls exec.library/GetMsg (LVO -372).
;   - Calls audio.device/BeginIO (LVO -30).
; Direct callers: H094+$0028
; --------------------------------------------------------------------------
L094_0000003A:
; H094+$0000003A: 48e70f18  movem.l d4-d7/a3-a4, -(a7)
        movem.l d4-d7/a3-a4, -(a7)
L094_0000003E:
; H094+$0000003E: 286d0254  movea.l $254(a5), a4
        movea.l $254(a5), a4
L094_00000042:
; H094+$00000042: 4286  clr.l d6
        clr.l d6
L094_00000044:
; H094+$00000044: 42ad0254  clr.l $254(a5)
        clr.l $254(a5)
L094_00000048:
; H094+$00000048: 200c  move.l a4, d0
        move.l a4, d0
L094_0000004A:
; H094+$0000004A: 670000b6  beq.w $102
        beq.w H094+$102
L094_0000004E:
; H094+$0000004E: 082c00000034  btst.b #$0, $34(a4)
        btst #$0, $34(a4)
L094_00000054:
; H094+$00000054: 6624  bne.b $7a
        bne.b H094+$7A
L094_00000056:
; H094+$00000056: 08ac00010034  bclr.b #$1, $34(a4)
        bclr #$1, $34(a4)
L094_0000005C:
; H094+$0000005C: 2006  move.l d6, d0
        move.l d6, d0
L094_0000005E:
; H094+$0000005E: 660c  bne.b $6c
        bne.b H094+$6C
L094_00000060:
; H094+$00000060: 202c0000  move.l $0(a4), d0
        move.l $0(a4), d0
L094_00000064:
; H094+$00000064: 2b400254  move.l d0, $254(a5)
        move.l d0, $254(a5)
L094_00000068:
; H094+$00000068: 2840  movea.l d0, a4
        movea.l d0, a4
L094_0000006A:
; H094+$0000006A: 60dc  bra.b $48
        bra.b H094+$48
L094_0000006C:
; H094+$0000006C: 202c0000  move.l $0(a4), d0
        move.l $0(a4), d0
L094_00000070:
; H094+$00000070: 2046  movea.l d6, a0
        movea.l d6, a0
L094_00000072:
; H094+$00000072: 21400000  move.l d0, $0(a0)
        move.l d0, $0(a0)
L094_00000076:
; H094+$00000076: 2840  movea.l d0, a4
        movea.l d0, a4
L094_00000078:
; H094+$00000078: 60ce  bra.b $48
        bra.b H094+$48
L094_0000007A:
; H094+$0000007A: 2e3c0000000c  move.l #$c, d7
        move.l #$c, d7
L094_00000080:
; H094+$00000080: 283cffffffff  move.l #$ffffffff, d4
        move.l #$ffffffff, d4
L094_00000086:
; H094+$00000086: 2a3c0000000c  move.l #$c, d5
        move.l #$c, d5
L094_0000008C:
; H094+$0000008C: 47f57000  lea.l (a5, d7.w), a3
        lea.l (a5, d7.w), a3
L094_00000090:
; H094+$00000090: 266b0094  movea.l $94(a3), a3
        movea.l $94(a3), a3
L094_00000094:
; H094+$00000094: 200b  move.l a3, d0
        move.l a3, d0
L094_00000096:
; H094+$00000096: 6758  beq.b $f0
        beq.b H094+$F0
L094_00000098:
; H094+$00000098: b8ab0018  cmp.l $18(a3), d4
        cmp.l $18(a3), d4
L094_0000009C:
; H094+$0000009C: 6506  bcs.b $a4
        bcs.b H094+$A4
L094_0000009E:
; H094+$0000009E: 282b0018  move.l $18(a3), d4
        move.l $18(a3), d4
L094_000000A2:
; H094+$000000A2: 2a07  move.l d7, d5
        move.l d7, d5
L094_000000A4:
; H094+$000000A4: 048700000004  subi.l #$4, d7
        subi.l #$4, d7
L094_000000AA:
; H094+$000000AA: 4a47  tst.w d7
        tst.w d7
L094_000000AC:
; H094+$000000AC: 6ade  bpl.b $8c
        bpl.b H094+$8C
L094_000000AE:
; H094+$000000AE: 2e05  move.l d5, d7
        move.l d5, d7
L094_000000B0:
; H094+$000000B0: 47f57000  lea.l (a5, d7.w), a3
        lea.l (a5, d7.w), a3
L094_000000B4:
; H094+$000000B4: 266b0094  movea.l $94(a3), a3
        movea.l $94(a3), a3
L094_000000B8:
; H094+$000000B8: 08ab00010034  bclr.b #$1, $34(a3)
        bclr #$1, $34(a3)
L094_000000BE:
; H094+$000000BE: 206d069c  movea.l $69c(a5), a0
        movea.l $69c(a5), a0
L094_000000C2:
; H094+$000000C2: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L094_000000C6:
; H094+$000000C6: 4eaefe8c  jsr -$174(a6) ; exec.library/GetMsg
        jsr LVO_exec_GetMsg(a6)
L094_000000CA:
; H094+$000000CA: 4a80  tst.l d0
        tst.l d0
L094_000000CC:
; H094+$000000CC: 6734  beq.b $102
        beq.b H094+$102
L094_000000CE:
; H094+$000000CE: 2240  movea.l d0, a1
        movea.l d0, a1
L094_000000D0:
; H094+$000000D0: 337c000b001c  move.w #$b, $1c(a1)
        move.w #$b, $1c(a1)
L094_000000D6:
; H094+$000000D6: 4229001e  clr.b $1e(a1)
        clr.b $1e(a1)
L094_000000DA:
; H094+$000000DA: e445  asr.w #$2, d5
        asr.w #$2, d5
L094_000000DC:
; H094+$000000DC: 4280  clr.l d0
        clr.l d0
L094_000000DE:
; H094+$000000DE: 0bc0  bset.b d5, d0
        bset d5, d0
L094_000000E0:
; H094+$000000E0: 23400018  move.l d0, $18(a1)
        move.l d0, $18(a1)
L094_000000E4:
; H094+$000000E4: 2f0e  move.l a6, -(a7)
        move.l a6, -(a7)
L094_000000E6:
; H094+$000000E6: 2c690014  movea.l $14(a1), a6
        movea.l $14(a1), a6
L094_000000EA:
; H094+$000000EA: 4eaeffe2  jsr -$1e(a6) ; audio.device/BeginIO
        jsr LVO_audio_BeginIO(a6)
L094_000000EE:
; H094+$000000EE: 2c5f  movea.l (a7)+, a6
        movea.l (a7)+, a6
L094_000000F0:
; H094+$000000F0: 41f57000  lea.l (a5, d7.w), a0
        lea.l (a5, d7.w), a0
L094_000000F4:
; H094+$000000F4: 214c0094  move.l a4, $94(a0)
        move.l a4, $94(a0)
L094_000000F8:
; H094+$000000F8: 2c0c  move.l a4, d6
        move.l a4, d6
L094_000000FA:
; H094+$000000FA: 286c0000  movea.l $0(a4), a4
        movea.l $0(a4), a4
L094_000000FE:
; H094+$000000FE: 6000ff48  bra.w $48
        bra.w H094+$48
L094_00000102:
; H094+$00000102: 4cdf18f0  movem.l (a7)+, d4-d7/a3-a4
        movem.l (a7)+, d4-d7/a3-a4
L094_00000106:
; H094+$00000106: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_00000108 [partial]
; Purpose: Routine of the audio callbacks: vertical server and software interrupt module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H094+$0024
; --------------------------------------------------------------------------
L094_00000108:
; H094+$00000108: 48e70108  movem.l d7/a4, -(a7)
        movem.l d7/a4, -(a7)
L094_0000010C:
; H094+$0000010C: 286d06a0  movea.l $6a0(a5), a4
        movea.l $6a0(a5), a4
L094_00000110:
; H094+$00000110: 4287  clr.l d7
        clr.l d7
L094_00000112:
; H094+$00000112: 200c  move.l a4, d0
        move.l a4, d0
L094_00000114:
; H094+$00000114: 676c  beq.b $182
        beq.b H094+$182
L094_00000116:
; H094+$00000116: 082c0000000e  btst.b #$0, $e(a4)
        btst #$0, $e(a4)
L094_0000011C:
; H094+$0000011C: 6704  beq.b $122
        beq.b H094+$122
L094_0000011E:
; H094+$0000011E: 6168  bsr.b $188
        bsr.b H094+$188
L094_00000120:
; H094+$00000120: 601a  bra.b $13c
        bra.b H094+$13C
L094_00000122:
; H094+$00000122: 082c0001000e  btst.b #$1, $e(a4)
        btst #$1, $e(a4)
L094_00000128:
; H094+$00000128: 6706  beq.b $130
        beq.b H094+$130
L094_0000012A:
; H094+$0000012A: 61000264  bsr.w $390
        bsr.w H094+$390
L094_0000012E:
; H094+$0000012E: 600c  bra.b $13c
        bra.b H094+$13C
L094_00000130:
; H094+$00000130: 082c0002000e  btst.b #$2, $e(a4)
        btst #$2, $e(a4)
L094_00000136:
; H094+$00000136: 6704  beq.b $13c
        beq.b H094+$13C
L094_00000138:
; H094+$00000138: 61000256  bsr.w $390
        bsr.w H094+$390
L094_0000013C:
; H094+$0000013C: 082c0004000e  btst.b #$4, $e(a4)
        btst #$4, $e(a4)
L094_00000142:
; H094+$00000142: 6636  bne.b $17a
        bne.b H094+$17A
L094_00000144:
; H094+$00000144: 4a87  tst.l d7
        tst.l d7
L094_00000146:
; H094+$00000146: 6618  bne.b $160
        bne.b H094+$160
L094_00000148:
; H094+$00000148: 206c0000  movea.l $0(a4), a0
        movea.l $0(a4), a0
L094_0000014C:
; H094+$0000014C: 2b4806a0  move.l a0, $6a0(a5)
        move.l a0, $6a0(a5)
L094_00000150:
; H094+$00000150: 226d06a4  movea.l $6a4(a5), a1
        movea.l $6a4(a5), a1
L094_00000154:
; H094+$00000154: 29490000  move.l a1, $0(a4)
        move.l a1, $0(a4)
L094_00000158:
; H094+$00000158: 2b4c06a4  move.l a4, $6a4(a5)
        move.l a4, $6a4(a5)
L094_0000015C:
; H094+$0000015C: 2848  movea.l a0, a4
        movea.l a0, a4
L094_0000015E:
; H094+$0000015E: 60b2  bra.b $112
        bra.b H094+$112
L094_00000160:
; H094+$00000160: 2047  movea.l d7, a0
        movea.l d7, a0
L094_00000162:
; H094+$00000162: 226c0000  movea.l $0(a4), a1
        movea.l $0(a4), a1
L094_00000166:
; H094+$00000166: 21490000  move.l a1, $0(a0)
        move.l a1, $0(a0)
L094_0000016A:
; H094+$0000016A: 206d06a4  movea.l $6a4(a5), a0
        movea.l $6a4(a5), a0
L094_0000016E:
; H094+$0000016E: 29480000  move.l a0, $0(a4)
        move.l a0, $0(a4)
L094_00000172:
; H094+$00000172: 2b4c06a4  move.l a4, $6a4(a5)
        move.l a4, $6a4(a5)
L094_00000176:
; H094+$00000176: 2849  movea.l a1, a4
        movea.l a1, a4
L094_00000178:
; H094+$00000178: 6098  bra.b $112
        bra.b H094+$112
L094_0000017A:
; H094+$0000017A: 2e0c  move.l a4, d7
        move.l a4, d7
L094_0000017C:
; H094+$0000017C: 286c0000  movea.l $0(a4), a4
        movea.l $0(a4), a4
L094_00000180:
; H094+$00000180: 6090  bra.b $112
        bra.b H094+$112
L094_00000182:
; H094+$00000182: 4cdf1080  movem.l (a7)+, d7/a4
        movem.l (a7)+, d7/a4
L094_00000186:
; H094+$00000186: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_00000188 [partial]
; Purpose: Routine of the audio callbacks: vertical server and software interrupt module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H094+$011E
; --------------------------------------------------------------------------
L094_00000188:
; H094+$00000188: 48e70130  movem.l d7/a2-a3, -(a7)
        movem.l d7/a2-a3, -(a7)
L094_0000018C:
; H094+$0000018C: 266c0006  movea.l $6(a4), a3
        movea.l $6(a4), a3
L094_00000190:
; H094+$00000190: 2e3c00000000  move.l #$0, d7
        move.l #$0, d7
L094_00000196:
; H094+$00000196: be6b0000  cmp.w $0(a3), d7
        cmp.w $0(a3), d7
L094_0000019A:
; H094+$0000019A: 6710  beq.b $1ac
        beq.b H094+$1AC
L094_0000019C:
; H094+$0000019C: 3007  move.w d7, d0
        move.w d7, d0
L094_0000019E:
; H094+$0000019E: e540  asl.w #$2, d0
        asl.w #$2, d0
L094_000001A0:
; H094+$000001A0: 24730004  movea.l $4(a3, d0.w), a2
        movea.l $4(a3, d0.w), a2
L094_000001A4:
; H094+$000001A4: 6118  bsr.b $1be
        bsr.b H094+$1BE
L094_000001A6:
; H094+$000001A6: 06470001  addi.w #$1, d7
        addi.w #$1, d7
L094_000001AA:
; H094+$000001AA: 60ea  bra.b $196
        bra.b H094+$196
L094_000001AC:
; H094+$000001AC: 4a2b0048  tst.b $48(a3)
        tst.b $48(a3)
L094_000001B0:
; H094+$000001B0: 6606  bne.b $1b8
        bne.b H094+$1B8
L094_000001B2:
; H094+$000001B2: 08ac0004000e  bclr.b #$4, $e(a4)
        bclr #$4, $e(a4)
L094_000001B8:
; H094+$000001B8: 4cdf0c80  movem.l (a7)+, d7/a2-a3
        movem.l (a7)+, d7/a2-a3
L094_000001BC:
; H094+$000001BC: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_000001BE [partial]
; Purpose: Routine of the audio callbacks: vertical server and software interrupt module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H094+$01A4
; --------------------------------------------------------------------------
L094_000001BE:
; H094+$000001BE: 48e70e00  movem.l d4-d6, -(a7)
        movem.l d4-d6, -(a7)
L094_000001C2:
; H094+$000001C2: 4284  clr.l d4
        clr.l d4
L094_000001C4:
; H094+$000001C4: 202a0000  move.l $0(a2), d0
        move.l $0(a2), d0
L094_000001C8:
; H094+$000001C8: b0ad0000  cmp.l $0(a5), d0
        cmp.l $0(a5), d0
L094_000001CC:
; H094+$000001CC: 620000b4  bhi.w $282
        bhi.w H094+$282
L094_000001D0:
; H094+$000001D0: 206a000e  movea.l $e(a2), a0
        movea.l $e(a2), a0
L094_000001D4:
; H094+$000001D4: b1ea0012  cmpa.l $12(a2), a0
        cmpa.l $12(a2), a0
L094_000001D8:
; H094+$000001D8: 6508  bcs.b $1e2
        bcs.b H094+$1E2
L094_000001DA:
; H094+$000001DA: 0fab0048  bclr.b d7, $48(a3)
        bclr d7, $48(a3)
L094_000001DE:
; H094+$000001DE: 600000a2  bra.w $282
        bra.w H094+$282
L094_000001E2:
; H094+$000001E2: 206a000e  movea.l $e(a2), a0
        movea.l $e(a2), a0
L094_000001E6:
; H094+$000001E6: 4286  clr.l d6
        clr.l d6
L094_000001E8:
; H094+$000001E8: 1c18  move.b (a0)+, d6
        move.b (a0)+, d6
L094_000001EA:
; H094+$000001EA: 4285  clr.l d5
        clr.l d5
L094_000001EC:
; H094+$000001EC: 1a18  move.b (a0)+, d5
        move.b (a0)+, d5
L094_000001EE:
; H094+$000001EE: 2548000e  move.l a0, $e(a2)
        move.l a0, $e(a2)
L094_000001F2:
; H094+$000001F2: bc3c0080  cmp.b #$80, d6
        cmp.b #$80, d6
L094_000001F6:
; H094+$000001F6: 624a  bhi.b $242
        bhi.b H094+$242
L094_000001F8:
; H094+$000001F8: 08050007  btst.b #$7, d5
        btst #$7, d5
L094_000001FC:
; H094+$000001FC: 66c6  bne.b $1c4
        bne.b H094+$1C4
L094_000001FE:
; H094+$000001FE: 4280  clr.l d0
        clr.l d0
L094_00000200:
; H094+$00000200: 3005  move.w d5, d0
        move.w d5, d0
L094_00000202:
; H094+$00000202: 0240003f  andi.w #$3f, d0
        andi.w #$3f, d0
L094_00000206:
; H094+$00000206: e340  asl.w #$1, d0
        asl.w #$1, d0
L094_00000208:
; H094+$00000208: 206d06ac  movea.l $6ac(a5), a0
        movea.l $6ac(a5), a0
L094_0000020C:
; H094+$0000020C: 30300000  move.w (a0, d0.w), d0
        move.w (a0, d0.w), d0
L094_00000210:
; H094+$00000210: d880  add.l d0, d4
        add.l d0, d4
L094_00000212:
; H094+$00000212: 08050006  btst.b #$6, d5
        btst #$6, d5
L094_00000216:
; H094+$00000216: 66ac  bne.b $1c4
        bne.b H094+$1C4
L094_00000218:
; H094+$00000218: bc7c0080  cmp.w #$80, d6
        cmp.w #$80, d6
L094_0000021C:
; H094+$0000021C: 671a  beq.b $238
        beq.b H094+$238
L094_0000021E:
; H094+$0000021E: 61000518  bsr.w $738
        bsr.w H094+$738
L094_00000222:
; H094+$00000222: 4a80  tst.l d0
        tst.l d0
L094_00000224:
; H094+$00000224: 6712  beq.b $238
        beq.b H094+$238
L094_00000226:
; H094+$00000226: 2240  movea.l d0, a1
        movea.l d0, a1
L094_00000228:
; H094+$00000228: 202a0000  move.l $0(a2), d0
        move.l $0(a2), d0
L094_0000022C:
; H094+$0000022C: 23400014  move.l d0, $14(a1)
        move.l d0, $14(a1)
L094_00000230:
; H094+$00000230: d084  add.l d4, d0
        add.l d4, d0
L094_00000232:
; H094+$00000232: 23400018  move.l d0, $18(a1)
        move.l d0, $18(a1)
L094_00000236:
; H094+$00000236: 6150  bsr.b $288
        bsr.b H094+$288
L094_00000238:
; H094+$00000238: d9aa0000  add.l d4, $0(a2)
        add.l d4, $0(a2)
L094_0000023C:
; H094+$0000023C: 4284  clr.l d4
        clr.l d4
L094_0000023E:
; H094+$0000023E: 6000ff84  bra.w $1c4
        bra.w H094+$1C4
L094_00000242:
; H094+$00000242: bc3c0081  cmp.b #$81, d6
        cmp.b #$81, d6
L094_00000246:
; H094+$00000246: 6616  bne.b $25e
        bne.b H094+$25E
L094_00000248:
; H094+$00000248: ba6b0002  cmp.w $2(a3), d5
        cmp.w $2(a3), d5
L094_0000024C:
; H094+$0000024C: 6302  bls.b $250
        bls.b H094+$250
L094_0000024E:
; H094+$0000024E: 4285  clr.l d5
        clr.l d5
L094_00000250:
; H094+$00000250: e545  asl.w #$2, d5
        asl.w #$2, d5
L094_00000252:
; H094+$00000252: 20735024  movea.l $24(a3, d5.w), a0
        movea.l $24(a3, d5.w), a0
L094_00000256:
; H094+$00000256: 25480004  move.l a0, $4(a2)
        move.l a0, $4(a2)
L094_0000025A:
; H094+$0000025A: 6000ff68  bra.w $1c4
        bra.w H094+$1C4
L094_0000025E:
; H094+$0000025E: bc3c0084  cmp.b #$84, d6
        cmp.b #$84, d6
L094_00000262:
; H094+$00000262: 6608  bne.b $26c
        bne.b H094+$26C
L094_00000264:
; H094+$00000264: 15450008  move.b d5, $8(a2)
        move.b d5, $8(a2)
L094_00000268:
; H094+$00000268: 6000ff5a  bra.w $1c4
        bra.w H094+$1C4
L094_0000026C:
; H094+$0000026C: bc3c0088  cmp.b #$88, d6
        cmp.b #$88, d6
L094_00000270:
; H094+$00000270: 6604  bne.b $276
        bne.b H094+$276
L094_00000272:
; H094+$00000272: 6000ff50  bra.w $1c4
        bra.w H094+$1C4
L094_00000276:
; H094+$00000276: bc3c00ff  cmp.b #$ff, d6
        cmp.b #$ff, d6
L094_0000027A:
; H094+$0000027A: 6700ff5e  beq.w $1da
        beq.w H094+$1DA
L094_0000027E:
; H094+$0000027E: 6000ff44  bra.w $1c4
        bra.w H094+$1C4
L094_00000282:
; H094+$00000282: 4cdf0070  movem.l (a7)+, d4-d6
        movem.l (a7)+, d4-d6
L094_00000286:
; H094+$00000286: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_00000288 [partial]
; Purpose: Routine of the audio callbacks: vertical server and software interrupt module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H094+$0236
; --------------------------------------------------------------------------
L094_00000288:
; H094+$00000288: 48e73c08  movem.l d2-d5/a4, -(a7)
        movem.l d2-d5/a4, -(a7)
L094_0000028C:
; H094+$0000028C: 286a0004  movea.l $4(a2), a4
        movea.l $4(a2), a4
L094_00000290:
; H094+$00000290: 286c0006  movea.l $6(a4), a4
        movea.l $6(a4), a4
L094_00000294:
; H094+$00000294: 206c0008  movea.l $8(a4), a0
        movea.l $8(a4), a0
L094_00000298:
; H094+$00000298: 20280008  move.l $8(a0), d0
        move.l $8(a0), d0
L094_0000029C:
; H094+$0000029C: 6770  beq.b $30e
        beq.b H094+$30E
L094_0000029E:
; H094+$0000029E: 3206  move.w d6, d1
        move.w d6, d1
L094_000002A0:
; H094+$000002A0: e541  asl.w #$2, d1
        asl.w #$2, d1
L094_000002A2:
; H094+$000002A2: 206d06a8  movea.l $6a8(a5), a0
        movea.l $6a8(a5), a0
L094_000002A6:
; H094+$000002A6: 22301000  move.l (a0, d1.w), d1
        move.l (a0, d1.w), d1
L094_000002AA:
; H094+$000002AA: 206c0008  movea.l $8(a4), a0
        movea.l $8(a4), a0
L094_000002AE:
; H094+$000002AE: 4282  clr.l d2
        clr.l d2
L094_000002B0:
; H094+$000002B0: 1428000e  move.b $e(a0), d2
        move.b $e(a0), d2
L094_000002B4:
; H094+$000002B4: 26280000  move.l $0(a0), d3
        move.l $0(a0), d3
L094_000002B8:
; H094+$000002B8: 28280004  move.l $4(a0), d4
        move.l $4(a0), d4
L094_000002BC:
; H094+$000002BC: 4285  clr.l d5
        clr.l d5
L094_000002BE:
; H094+$000002BE: 82c0  divu.w d0, d1
        divu.w d0, d1
L094_000002C0:
; H094+$000002C0: 6816  bvc.b $2d8
        bvc.b H094+$2D8
L094_000002C2:
; H094+$000002C2: b47c0001  cmp.w #$1, d2
        cmp.w #$1, d2
L094_000002C6:
; H094+$000002C6: 6f2c  ble.b $2f4
        ble.b H094+$2F4
L094_000002C8:
; H094+$000002C8: da83  add.l d3, d5
        add.l d3, d5
L094_000002CA:
; H094+$000002CA: da84  add.l d4, d5
        add.l d4, d5
L094_000002CC:
; H094+$000002CC: e383  asl.l #$1, d3
        asl.l #$1, d3
L094_000002CE:
; H094+$000002CE: e384  asl.l #$1, d4
        asl.l #$1, d4
L094_000002D0:
; H094+$000002D0: e281  asr.l #$1, d1
        asr.l #$1, d1
L094_000002D2:
; H094+$000002D2: 04420001  subi.w #$1, d2
        subi.w #$1, d2
L094_000002D6:
; H094+$000002D6: 60e6  bra.b $2be
        bra.b H094+$2BE
L094_000002D8:
; H094+$000002D8: b47c0001  cmp.w #$1, d2
        cmp.w #$1, d2
L094_000002DC:
; H094+$000002DC: 6f16  ble.b $2f4
        ble.b H094+$2F4
L094_000002DE:
; H094+$000002DE: b27c0118  cmp.w #$118, d1
        cmp.w #$118, d1
L094_000002E2:
; H094+$000002E2: 6510  bcs.b $2f4
        bcs.b H094+$2F4
L094_000002E4:
; H094+$000002E4: da83  add.l d3, d5
        add.l d3, d5
L094_000002E6:
; H094+$000002E6: da84  add.l d4, d5
        add.l d4, d5
L094_000002E8:
; H094+$000002E8: e383  asl.l #$1, d3
        asl.l #$1, d3
L094_000002EA:
; H094+$000002EA: e384  asl.l #$1, d4
        asl.l #$1, d4
L094_000002EC:
; H094+$000002EC: e241  asr.w #$1, d1
        asr.w #$1, d1
L094_000002EE:
; H094+$000002EE: 04420001  subi.w #$1, d2
        subi.w #$1, d2
L094_000002F2:
; H094+$000002F2: 60e4  bra.b $2d8
        bra.b H094+$2D8
L094_000002F4:
; H094+$000002F4: 20680018  movea.l $18(a0), a0
        movea.l $18(a0), a0
L094_000002F8:
; H094+$000002F8: d1c5  adda.l d5, a0
        adda.l d5, a0
L094_000002FA:
; H094+$000002FA: 23480004  move.l a0, $4(a1)
        move.l a0, $4(a1)
L094_000002FE:
; H094+$000002FE: d1c3  adda.l d3, a0
        adda.l d3, a0
L094_00000300:
; H094+$00000300: 23480008  move.l a0, $8(a1)
        move.l a0, $8(a1)
L094_00000304:
; H094+$00000304: 2343000c  move.l d3, $c(a1)
        move.l d3, $c(a1)
L094_00000308:
; H094+$00000308: 23440010  move.l d4, $10(a1)
        move.l d4, $10(a1)
L094_0000030C:
; H094+$0000030C: 602a  bra.b $338
        bra.b H094+$338
L094_0000030E:
; H094+$0000030E: 3028000c  move.w $c(a0), d0
        move.w $c(a0), d0
L094_00000312:
; H094+$00000312: 223c00369e9a  move.l #$369e9a, d1
        move.l #$369e9a, d1
L094_00000318:
; H094+$00000318: 82c0  divu.w d0, d1
        divu.w d0, d1
L094_0000031A:
; H094+$0000031A: 26280000  move.l $0(a0), d3
        move.l $0(a0), d3
L094_0000031E:
; H094+$0000031E: 28280004  move.l $4(a0), d4
        move.l $4(a0), d4
L094_00000322:
; H094+$00000322: 20680018  movea.l $18(a0), a0
        movea.l $18(a0), a0
L094_00000326:
; H094+$00000326: 23480004  move.l a0, $4(a1)
        move.l a0, $4(a1)
L094_0000032A:
; H094+$0000032A: d1c3  adda.l d3, a0
        adda.l d3, a0
L094_0000032C:
; H094+$0000032C: 23480008  move.l a0, $8(a1)
        move.l a0, $8(a1)
L094_00000330:
; H094+$00000330: 2343000c  move.l d3, $c(a1)
        move.l d3, $c(a1)
L094_00000334:
; H094+$00000334: 23440010  move.l d4, $10(a1)
        move.l d4, $10(a1)
L094_00000338:
; H094+$00000338: 33410020  move.w d1, $20(a1)
        move.w d1, $20(a1)
L094_0000033C:
; H094+$0000033C: 33410022  move.w d1, $22(a1)
        move.w d1, $22(a1)
L094_00000340:
; H094+$00000340: 206c0000  movea.l $0(a4), a0
        movea.l $0(a4), a0
L094_00000344:
; H094+$00000344: 2008  move.l a0, d0
        move.l a0, d0
L094_00000346:
; H094+$00000346: 6606  bne.b $34e
        bne.b H094+$34E
L094_00000348:
; H094+$00000348: 42a9001c  clr.l $1c(a1)
        clr.l $1c(a1)
L094_0000034C:
; H094+$0000034C: 600c  bra.b $35a
        bra.b H094+$35A
L094_0000034E:
; H094+$0000034E: 2348001c  move.l a0, $1c(a1)
        move.l a0, $1c(a1)
L094_00000352:
; H094+$00000352: 42290026  clr.b $26(a1)
        clr.b $26(a1)
L094_00000356:
; H094+$00000356: 42690024  clr.w $24(a1)
        clr.w $24(a1)
L094_0000035A:
; H094+$0000035A: 302b0044  move.w $44(a3), d0
        move.w $44(a3), d0
L094_0000035E:
; H094+$0000035E: 4281  clr.l d1
        clr.l d1
L094_00000360:
; H094+$00000360: 122a0008  move.b $8(a2), d1
        move.b $8(a2), d1
L094_00000364:
; H094+$00000364: c0c1  mulu.w d1, d0
        mulu.w d1, d0
L094_00000366:
; H094+$00000366: 3340002c  move.w d0, $2c(a1)
        move.w d0, $2c(a1)
L094_0000036A:
; H094+$0000036A: 3340002e  move.w d0, $2e(a1)
        move.w d0, $2e(a1)
L094_0000036E:
; H094+$0000036E: 206c0004  movea.l $4(a4), a0
        movea.l $4(a4), a0
L094_00000372:
; H094+$00000372: 2008  move.l a0, d0
        move.l a0, d0
L094_00000374:
; H094+$00000374: 6608  bne.b $37e
        bne.b H094+$37E
L094_00000376:
; H094+$00000376: 42a90028  clr.l $28(a1)
        clr.l $28(a1)
L094_0000037A:
; H094+$0000037A: 6000000e  bra.w $38a
        bra.w H094+$38A
L094_0000037E:
; H094+$0000037E: 23480028  move.l a0, $28(a1)
        move.l a0, $28(a1)
L094_00000382:
; H094+$00000382: 42290032  clr.b $32(a1)
        clr.b $32(a1)
L094_00000386:
; H094+$00000386: 42690030  clr.w $30(a1)
        clr.w $30(a1)
L094_0000038A:
; H094+$0000038A: 4cdf103c  movem.l (a7)+, d2-d5/a4
        movem.l (a7)+, d2-d5/a4
L094_0000038E:
; H094+$0000038E: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_00000390 [partial]
; Purpose: Routine of the audio callbacks: vertical server and software interrupt module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H094+$012A, H094+$0138
; --------------------------------------------------------------------------
L094_00000390:
; H094+$00000390: 48e73c38  movem.l d2-d5/a2-a4, -(a7)
        movem.l d2-d5/a2-a4, -(a7)
L094_00000394:
; H094+$00000394: 08ac0004000e  bclr.b #$4, $e(a4)
        bclr #$4, $e(a4)
L094_0000039A:
; H094+$0000039A: 6100039c  bsr.w $738
        bsr.w H094+$738
L094_0000039E:
; H094+$0000039E: 4a80  tst.l d0
        tst.l d0
L094_000003A0:
; H094+$000003A0: 670000fc  beq.w $49e
        beq.w H094+$49E
L094_000003A4:
; H094+$000003A4: 2440  movea.l d0, a2
        movea.l d0, a2
L094_000003A6:
; H094+$000003A6: 082c0001000e  btst.b #$1, $e(a4)
        btst #$1, $e(a4)
L094_000003AC:
; H094+$000003AC: 660a  bne.b $3b8
        bne.b H094+$3B8
L094_000003AE:
; H094+$000003AE: 42aa001c  clr.l $1c(a2)
        clr.l $1c(a2)
L094_000003B2:
; H094+$000003B2: 42aa0028  clr.l $28(a2)
        clr.l $28(a2)
L094_000003B6:
; H094+$000003B6: 603e  bra.b $3f6
        bra.b H094+$3F6
L094_000003B8:
; H094+$000003B8: 286c0006  movea.l $6(a4), a4
        movea.l $6(a4), a4
L094_000003BC:
; H094+$000003BC: 206c0000  movea.l $0(a4), a0
        movea.l $0(a4), a0
L094_000003C0:
; H094+$000003C0: 2008  move.l a0, d0
        move.l a0, d0
L094_000003C2:
; H094+$000003C2: 6606  bne.b $3ca
        bne.b H094+$3CA
L094_000003C4:
; H094+$000003C4: 42aa001c  clr.l $1c(a2)
        clr.l $1c(a2)
L094_000003C8:
; H094+$000003C8: 600c  bra.b $3d6
        bra.b H094+$3D6
L094_000003CA:
; H094+$000003CA: 2548001c  move.l a0, $1c(a2)
        move.l a0, $1c(a2)
L094_000003CE:
; H094+$000003CE: 422a0026  clr.b $26(a2)
        clr.b $26(a2)
L094_000003D2:
; H094+$000003D2: 426a0024  clr.w $24(a2)
        clr.w $24(a2)
L094_000003D6:
; H094+$000003D6: 206c0004  movea.l $4(a4), a0
        movea.l $4(a4), a0
L094_000003DA:
; H094+$000003DA: 2008  move.l a0, d0
        move.l a0, d0
L094_000003DC:
; H094+$000003DC: 6608  bne.b $3e6
        bne.b H094+$3E6
L094_000003DE:
; H094+$000003DE: 42aa0028  clr.l $28(a2)
        clr.l $28(a2)
L094_000003E2:
; H094+$000003E2: 6000000e  bra.w $3f2
        bra.w H094+$3F2
L094_000003E6:
; H094+$000003E6: 25480028  move.l a0, $28(a2)
        move.l a0, $28(a2)
L094_000003EA:
; H094+$000003EA: 422a0032  clr.b $32(a2)
        clr.b $32(a2)
L094_000003EE:
; H094+$000003EE: 426a0030  clr.w $30(a2)
        clr.w $30(a2)
L094_000003F2:
; H094+$000003F2: 286c0014  movea.l $14(a4), a4
        movea.l $14(a4), a4
L094_000003F6:
; H094+$000003F6: 256d00000014  move.l $0(a5), $14(a2)
        move.l $0(a5), $14(a2)
L094_000003FC:
; H094+$000003FC: 266c0006  movea.l $6(a4), a3
        movea.l $6(a4), a3
L094_00000400:
; H094+$00000400: 302b000c  move.w $c(a3), d0
        move.w $c(a3), d0
L094_00000404:
; H094+$00000404: 6606  bne.b $40c
        bne.b H094+$40C
L094_00000406:
; H094+$00000406: 203c000007d0  move.l #$7d0, d0
        move.l #$7d0, d0
L094_0000040C:
; H094+$0000040C: 223c00369e9a  move.l #$369e9a, d1
        move.l #$369e9a, d1
L094_00000412:
; H094+$00000412: 82c0  divu.w d0, d1
        divu.w d0, d1
L094_00000414:
; H094+$00000414: 4282  clr.l d2
        clr.l d2
L094_00000416:
; H094+$00000416: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L094_0000041A:
; H094+$0000041A: 262b0000  move.l $0(a3), d3
        move.l $0(a3), d3
L094_0000041E:
; H094+$0000041E: 282b0004  move.l $4(a3), d4
        move.l $4(a3), d4
L094_00000422:
; H094+$00000422: 4285  clr.l d5
        clr.l d5
L094_00000424:
; H094+$00000424: b47c0001  cmp.w #$1, d2
        cmp.w #$1, d2
L094_00000428:
; H094+$00000428: 6f0e  ble.b $438
        ble.b H094+$438
L094_0000042A:
; H094+$0000042A: da83  add.l d3, d5
        add.l d3, d5
L094_0000042C:
; H094+$0000042C: da84  add.l d4, d5
        add.l d4, d5
L094_0000042E:
; H094+$0000042E: e383  asl.l #$1, d3
        asl.l #$1, d3
L094_00000430:
; H094+$00000430: e384  asl.l #$1, d4
        asl.l #$1, d4
L094_00000432:
; H094+$00000432: 04420001  subi.w #$1, d2
        subi.w #$1, d2
L094_00000436:
; H094+$00000436: 60ec  bra.b $424
        bra.b H094+$424
L094_00000438:
; H094+$00000438: 206b0018  movea.l $18(a3), a0
        movea.l $18(a3), a0
L094_0000043C:
; H094+$0000043C: d1c5  adda.l d5, a0
        adda.l d5, a0
L094_0000043E:
; H094+$0000043E: 25480004  move.l a0, $4(a2)
        move.l a0, $4(a2)
L094_00000442:
; H094+$00000442: d1c3  adda.l d3, a0
        adda.l d3, a0
L094_00000444:
; H094+$00000444: 25480008  move.l a0, $8(a2)
        move.l a0, $8(a2)
L094_00000448:
; H094+$00000448: 2543000c  move.l d3, $c(a2)
        move.l d3, $c(a2)
L094_0000044C:
; H094+$0000044C: 25440010  move.l d4, $10(a2)
        move.l d4, $10(a2)
L094_00000450:
; H094+$00000450: 257cffffffff0018  move.l #$ffffffff, $18(a2)
        move.l #$ffffffff, $18(a2)
L094_00000458:
; H094+$00000458: 4aab0004  tst.l $4(a3)
        tst.l $4(a3)
L094_0000045C:
; H094+$0000045C: 661c  bne.b $47a
        bne.b H094+$47A
L094_0000045E:
; H094+$0000045E: 202d0004  move.l $4(a5), d0
        move.l $4(a5), d0
L094_00000462:
; H094+$00000462: c0fc003c  mulu.w #$3c, d0
        mulu.w #$3c, d0
L094_00000466:
; H094+$00000466: 262b0000  move.l $0(a3), d3
        move.l $0(a3), d3
L094_0000046A:
; H094+$0000046A: c0c3  mulu.w d3, d0
        mulu.w d3, d0
L094_0000046C:
; H094+$0000046C: 80eb000c  divu.w $c(a3), d0
        divu.w $c(a3), d0
L094_00000470:
; H094+$00000470: 48c0  ext.l d0
        ext.l d0
L094_00000472:
; H094+$00000472: d0ad0000  add.l $0(a5), d0
        add.l $0(a5), d0
L094_00000476:
; H094+$00000476: 25400018  move.l d0, $18(a2)
        move.l d0, $18(a2)
L094_0000047A:
; H094+$0000047A: 35410020  move.w d1, $20(a2)
        move.w d1, $20(a2)
L094_0000047E:
; H094+$0000047E: 35410022  move.w d1, $22(a2)
        move.w d1, $22(a2)
L094_00000482:
; H094+$00000482: 202b0010  move.l $10(a3), d0
        move.l $10(a3), d0
L094_00000486:
; H094+$00000486: b0bc00010000  cmp.l #$10000, d0
        cmp.l #$10000, d0
L094_0000048C:
; H094+$0000048C: 6d06  blt.b $494
        blt.b H094+$494
L094_0000048E:
; H094+$0000048E: 303c4000  move.w #$4000, d0
        move.w #$4000, d0
L094_00000492:
; H094+$00000492: 6002  bra.b $496
        bra.b H094+$496
L094_00000494:
; H094+$00000494: e488  lsr.l #$2, d0
        lsr.l #$2, d0
L094_00000496:
; H094+$00000496: 3540002c  move.w d0, $2c(a2)
        move.w d0, $2c(a2)
L094_0000049A:
; H094+$0000049A: 3540002e  move.w d0, $2e(a2)
        move.w d0, $2e(a2)
L094_0000049E:
; H094+$0000049E: 4cdf1c3c  movem.l (a7)+, d2-d5/a2-a4
        movem.l (a7)+, d2-d5/a2-a4
L094_000004A2:
; H094+$000004A2: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_000004A4 [partial]
; Purpose: Service of the audio callback module: vertical server and software interrupt; uses exec.library/GetMsg, audio.device/BeginIO.
;   - Calls exec.library/GetMsg (LVO -372).
;   - Calls audio.device/BeginIO (LVO -30).
;   - Calls exec.library/GetMsg (LVO -372).
;   - Calls audio.device/BeginIO (LVO -30).
; Direct callers: H094+$002C
; --------------------------------------------------------------------------
L094_000004A4:
; H094+$000004A4: 48e72308  movem.l d2/d6-d7/a4, -(a7)
        movem.l d2/d6-d7/a4, -(a7)
L094_000004A8:
; H094+$000004A8: 2e3c0000000c  move.l #$c, d7
        move.l #$c, d7
L094_000004AE:
; H094+$000004AE: 2c3c00000008  move.l #$8, d6
        move.l #$8, d6
L094_000004B4:
; H094+$000004B4: 49f57000  lea.l (a5, d7.w), a4
        lea.l (a5, d7.w), a4
L094_000004B8:
; H094+$000004B8: 286c0094  movea.l $94(a4), a4
        movea.l $94(a4), a4
L094_000004BC:
; H094+$000004BC: 200c  move.l a4, d0
        move.l a4, d0
L094_000004BE:
; H094+$000004BE: 67000266  beq.w $726
        beq.w H094+$726
L094_000004C2:
; H094+$000004C2: 202c0018  move.l $18(a4), d0
        move.l $18(a4), d0
L094_000004C6:
; H094+$000004C6: b0ad0000  cmp.l $0(a5), d0
        cmp.l $0(a5), d0
L094_000004CA:
; H094+$000004CA: 6440  bcc.b $50c
        bcc.b H094+$50C
L094_000004CC:
; H094+$000004CC: 08ac00010034  bclr.b #$1, $34(a4)
        bclr #$1, $34(a4)
L094_000004D2:
; H094+$000004D2: 49f57000  lea.l (a5, d7.w), a4
        lea.l (a5, d7.w), a4
L094_000004D6:
; H094+$000004D6: 42ac0094  clr.l $94(a4)
        clr.l $94(a4)
L094_000004DA:
; H094+$000004DA: 206d069c  movea.l $69c(a5), a0
        movea.l $69c(a5), a0
L094_000004DE:
; H094+$000004DE: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L094_000004E2:
; H094+$000004E2: 4eaefe8c  jsr -$174(a6) ; exec.library/GetMsg
        jsr LVO_exec_GetMsg(a6)
L094_000004E6:
; H094+$000004E6: 4a80  tst.l d0
        tst.l d0
L094_000004E8:
; H094+$000004E8: 67000248  beq.w $732
        beq.w H094+$732
L094_000004EC:
; H094+$000004EC: 2240  movea.l d0, a1
        movea.l d0, a1
L094_000004EE:
; H094+$000004EE: 23460018  move.l d6, $18(a1)
        move.l d6, $18(a1)
L094_000004F2:
; H094+$000004F2: 337c000b001c  move.w #$b, $1c(a1)
        move.w #$b, $1c(a1)
L094_000004F8:
; H094+$000004F8: 4229001e  clr.b $1e(a1)
        clr.b $1e(a1)
L094_000004FC:
; H094+$000004FC: 2f0e  move.l a6, -(a7)
        move.l a6, -(a7)
L094_000004FE:
; H094+$000004FE: 2c690014  movea.l $14(a1), a6
        movea.l $14(a1), a6
L094_00000502:
; H094+$00000502: 4eaeffe2  jsr -$1e(a6) ; audio.device/BeginIO
        jsr LVO_audio_BeginIO(a6)
L094_00000506:
; H094+$00000506: 2c5f  movea.l (a7)+, a6
        movea.l (a7)+, a6
L094_00000508:
; H094+$00000508: 6000021c  bra.w $726
        bra.w H094+$726
L094_0000050C:
; H094+$0000050C: 202c001c  move.l $1c(a4), d0
        move.l $1c(a4), d0
L094_00000510:
; H094+$00000510: 67000064  beq.w $576
        beq.w H094+$576
L094_00000514:
; H094+$00000514: 322c0022  move.w $22(a4), d1
        move.w $22(a4), d1
L094_00000518:
; H094+$00000518: d26c0024  add.w $24(a4), d1
        add.w $24(a4), d1
L094_0000051C:
; H094+$0000051C: 39410022  move.w d1, $22(a4)
        move.w d1, $22(a4)
L094_00000520:
; H094+$00000520: 042c00010026  subi.b #$1, $26(a4)
        subi.b #$1, $26(a4)
L094_00000526:
; H094+$00000526: 624e  bhi.b $576
        bhi.b H094+$576
L094_00000528:
; H094+$00000528: 2040  movea.l d0, a0
        movea.l d0, a0
L094_0000052A:
; H094+$0000052A: 4281  clr.l d1
        clr.l d1
L094_0000052C:
; H094+$0000052C: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L094_0000052E:
; H094+$0000052E: b23c00ff  cmp.b #$ff, d1
        cmp.b #$ff, d1
L094_00000532:
; H094+$00000532: 661c  bne.b $550
        bne.b H094+$550
L094_00000534:
; H094+$00000534: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L094_00000536:
; H094+$00000536: 6794  beq.b $4cc
        beq.b H094+$4CC
L094_00000538:
; H094+$00000538: b23c0001  cmp.b #$1, d1
        cmp.b #$1, d1
L094_0000053C:
; H094+$0000053C: 6606  bne.b $544
        bne.b H094+$544
L094_0000053E:
; H094+$0000053E: 42ac001c  clr.l $1c(a4)
        clr.l $1c(a4)
L094_00000542:
; H094+$00000542: 6032  bra.b $576
        bra.b H094+$576
L094_00000544:
; H094+$00000544: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L094_00000546:
; H094+$00000546: e141  asl.w #$8, d1
        asl.w #$8, d1
L094_00000548:
; H094+$00000548: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L094_0000054A:
; H094+$0000054A: 39410022  move.w d1, $22(a4)
        move.w d1, $22(a4)
L094_0000054E:
; H094+$0000054E: 60da  bra.b $52a
        bra.b H094+$52A
L094_00000550:
; H094+$00000550: b23c00fe  cmp.b #$fe, d1
        cmp.b #$fe, d1
L094_00000554:
; H094+$00000554: 6610  bne.b $566
        bne.b H094+$566
L094_00000556:
; H094+$00000556: 4281  clr.l d1
        clr.l d1
L094_00000558:
; H094+$00000558: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L094_0000055A:
; H094+$0000055A: 068100000001  addi.l #$1, d1
        addi.l #$1, d1
L094_00000560:
; H094+$00000560: e381  asl.l #$1, d1
        asl.l #$1, d1
L094_00000562:
; H094+$00000562: 91c1  suba.l d1, a0
        suba.l d1, a0
L094_00000564:
; H094+$00000564: 60c4  bra.b $52a
        bra.b H094+$52A
L094_00000566:
; H094+$00000566: 1018  move.b (a0)+, d0
        move.b (a0)+, d0
L094_00000568:
; H094+$00000568: 4880  ext.w d0
        ext.w d0
L094_0000056A:
; H094+$0000056A: 39400024  move.w d0, $24(a4)
        move.w d0, $24(a4)
L094_0000056E:
; H094+$0000056E: 19410026  move.b d1, $26(a4)
        move.b d1, $26(a4)
L094_00000572:
; H094+$00000572: 2948001c  move.l a0, $1c(a4)
        move.l a0, $1c(a4)
L094_00000576:
; H094+$00000576: 202c0028  move.l $28(a4), d0
        move.l $28(a4), d0
L094_0000057A:
; H094+$0000057A: 6700009c  beq.w $618
        beq.w H094+$618
L094_0000057E:
; H094+$0000057E: 322c002e  move.w $2e(a4), d1
        move.w $2e(a4), d1
L094_00000582:
; H094+$00000582: d26c0030  add.w $30(a4), d1
        add.w $30(a4), d1
L094_00000586:
; H094+$00000586: 3941002e  move.w d1, $2e(a4)
        move.w d1, $2e(a4)
L094_0000058A:
; H094+$0000058A: 042c00010032  subi.b #$1, $32(a4)
        subi.b #$1, $32(a4)
L094_00000590:
; H094+$00000590: 62000086  bhi.w $618
        bhi.w H094+$618
L094_00000594:
; H094+$00000594: 2040  movea.l d0, a0
        movea.l d0, a0
L094_00000596:
; H094+$00000596: 4281  clr.l d1
        clr.l d1
L094_00000598:
; H094+$00000598: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L094_0000059A:
; H094+$0000059A: b23c00ff  cmp.b #$ff, d1
        cmp.b #$ff, d1
L094_0000059E:
; H094+$0000059E: 660c  bne.b $5ac
        bne.b H094+$5AC
L094_000005A0:
; H094+$000005A0: 1210  move.b (a0), d1
        move.b (a0), d1
L094_000005A2:
; H094+$000005A2: 6700ff28  beq.w $4cc
        beq.w H094+$4CC
L094_000005A6:
; H094+$000005A6: 42ac0028  clr.l $28(a4)
        clr.l $28(a4)
L094_000005AA:
; H094+$000005AA: 606c  bra.b $618
        bra.b H094+$618
L094_000005AC:
; H094+$000005AC: b23c00fe  cmp.b #$fe, d1
        cmp.b #$fe, d1
L094_000005B0:
; H094+$000005B0: 6610  bne.b $5c2
        bne.b H094+$5C2
L094_000005B2:
; H094+$000005B2: 4281  clr.l d1
        clr.l d1
L094_000005B4:
; H094+$000005B4: 1218  move.b (a0)+, d1
        move.b (a0)+, d1
L094_000005B6:
; H094+$000005B6: 068100000001  addi.l #$1, d1
        addi.l #$1, d1
L094_000005BC:
; H094+$000005BC: e381  asl.l #$1, d1
        asl.l #$1, d1
L094_000005BE:
; H094+$000005BE: 91c1  suba.l d1, a0
        suba.l d1, a0
L094_000005C0:
; H094+$000005C0: 60d4  bra.b $596
        bra.b H094+$596
L094_000005C2:
; H094+$000005C2: 4280  clr.l d0
        clr.l d0
L094_000005C4:
; H094+$000005C4: 1018  move.b (a0)+, d0
        move.b (a0)+, d0
L094_000005C6:
; H094+$000005C6: 6b18  bmi.b $5e0
        bmi.b H094+$5E0
L094_000005C8:
; H094+$000005C8: 4282  clr.l d2
        clr.l d2
L094_000005CA:
; H094+$000005CA: 342c002c  move.w $2c(a4), d2
        move.w $2c(a4), d2
L094_000005CE:
; H094+$000005CE: c4c0  mulu.w d0, d2
        mulu.w d0, d2
L094_000005D0:
; H094+$000005D0: ec82  asr.l #$6, d2
        asr.l #$6, d2
L094_000005D2:
; H094+$000005D2: b47c4000  cmp.w #$4000, d2
        cmp.w #$4000, d2
L094_000005D6:
; H094+$000005D6: 6f04  ble.b $5dc
        ble.b H094+$5DC
L094_000005D8:
; H094+$000005D8: 343c4000  move.w #$4000, d2
        move.w #$4000, d2
L094_000005DC:
; H094+$000005DC: 3002  move.w d2, d0
        move.w d2, d0
L094_000005DE:
; H094+$000005DE: 600a  bra.b $5ea
        bra.b H094+$5EA
L094_000005E0:
; H094+$000005E0: 044000c0  subi.w #$c0, d0
        subi.w #$c0, d0
L094_000005E4:
; H094+$000005E4: e140  asl.w #$8, d0
        asl.w #$8, d0
L094_000005E6:
; H094+$000005E6: d06c002e  add.w $2e(a4), d0
        add.w $2e(a4), d0
L094_000005EA:
; H094+$000005EA: 4a01  tst.b d1
        tst.b d1
L094_000005EC:
; H094+$000005EC: 6606  bne.b $5f4
        bne.b H094+$5F4
L094_000005EE:
; H094+$000005EE: 3940002e  move.w d0, $2e(a4)
        move.w d0, $2e(a4)
L094_000005F2:
; H094+$000005F2: 60a2  bra.b $596
        bra.b H094+$596
L094_000005F4:
; H094+$000005F4: 19410032  move.b d1, $32(a4)
        move.b d1, $32(a4)
L094_000005F8:
; H094+$000005F8: b23c0001  cmp.b #$1, d1
        cmp.b #$1, d1
L094_000005FC:
; H094+$000005FC: 660a  bne.b $608
        bne.b H094+$608
L094_000005FE:
; H094+$000005FE: 3940002e  move.w d0, $2e(a4)
        move.w d0, $2e(a4)
L094_00000602:
; H094+$00000602: 426c0030  clr.w $30(a4)
        clr.w $30(a4)
L094_00000606:
; H094+$00000606: 600c  bra.b $614
        bra.b H094+$614
L094_00000608:
; H094+$00000608: 906c002e  sub.w $2e(a4), d0
        sub.w $2e(a4), d0
L094_0000060C:
; H094+$0000060C: 48c0  ext.l d0
        ext.l d0
L094_0000060E:
; H094+$0000060E: 81c1  divs.w d1, d0
        divs.w d1, d0
L094_00000610:
; H094+$00000610: 39400030  move.w d0, $30(a4)
        move.w d0, $30(a4)
L094_00000614:
; H094+$00000614: 29480028  move.l a0, $28(a4)
        move.l a0, $28(a4)
L094_00000618:
; H094+$00000618: 082c00020034  btst.b #$2, $34(a4)
        btst #$2, $34(a4)
L094_0000061E:
; H094+$0000061E: 6652  bne.b $672
        bne.b H094+$672
L094_00000620:
; H094+$00000620: 4aac001c  tst.l $1c(a4)
        tst.l $1c(a4)
L094_00000624:
; H094+$00000624: 6608  bne.b $62e
        bne.b H094+$62E
L094_00000626:
; H094+$00000626: 4aac0028  tst.l $28(a4)
        tst.l $28(a4)
L094_0000062A:
; H094+$0000062A: 670000fa  beq.w $726
        beq.w H094+$726
L094_0000062E:
; H094+$0000062E: 206d069c  movea.l $69c(a5), a0
        movea.l $69c(a5), a0
L094_00000632:
; H094+$00000632: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L094_00000636:
; H094+$00000636: 4eaefe8c  jsr -$174(a6) ; exec.library/GetMsg
        jsr LVO_exec_GetMsg(a6)
L094_0000063A:
; H094+$0000063A: 4a80  tst.l d0
        tst.l d0
L094_0000063C:
; H094+$0000063C: 670000f4  beq.w $732
        beq.w H094+$732
L094_00000640:
; H094+$00000640: 2240  movea.l d0, a1
        movea.l d0, a1
L094_00000642:
; H094+$00000642: 23460018  move.l d6, $18(a1)
        move.l d6, $18(a1)
L094_00000646:
; H094+$00000646: 337c000c001c  move.w #$c, $1c(a1)
        move.w #$c, $1c(a1)
L094_0000064C:
; H094+$0000064C: 137c0010001e  move.b #$10, $1e(a1)
        move.b #$10, $1e(a1)
L094_00000652:
; H094+$00000652: 336c0022002a  move.w $22(a4), $2a(a1)
        move.w $22(a4), $2a(a1)
L094_00000658:
; H094+$00000658: 4240  clr.w d0
        clr.w d0
L094_0000065A:
; H094+$0000065A: 102c002e  move.b $2e(a4), d0
        move.b $2e(a4), d0
L094_0000065E:
; H094+$0000065E: 3340002c  move.w d0, $2c(a1)
        move.w d0, $2c(a1)
L094_00000662:
; H094+$00000662: 2f0e  move.l a6, -(a7)
        move.l a6, -(a7)
L094_00000664:
; H094+$00000664: 2c690014  movea.l $14(a1), a6
        movea.l $14(a1), a6
L094_00000668:
; H094+$00000668: 4eaeffe2  jsr -$1e(a6) ; audio.device/BeginIO
        jsr LVO_audio_BeginIO(a6)
L094_0000066C:
; H094+$0000066C: 2c5f  movea.l (a7)+, a6
        movea.l (a7)+, a6
L094_0000066E:
; H094+$0000066E: 600000b6  bra.w $726
        bra.w H094+$726
L094_00000672:
; H094+$00000672: 08ac00020034  bclr.b #$2, $34(a4)
        bclr #$2, $34(a4)
L094_00000678:
; H094+$00000678: 4aac000c  tst.l $c(a4)
        tst.l $c(a4)
L094_0000067C:
; H094+$0000067C: 6752  beq.b $6d0
        beq.b H094+$6D0
L094_0000067E:
; H094+$0000067E: 206d069c  movea.l $69c(a5), a0
        movea.l $69c(a5), a0
L094_00000682:
; H094+$00000682: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L094_00000686:
; H094+$00000686: 4eaefe8c  jsr -$174(a6) ; exec.library/GetMsg
        jsr LVO_exec_GetMsg(a6)
L094_0000068A:
; H094+$0000068A: 4a80  tst.l d0
        tst.l d0
L094_0000068C:
; H094+$0000068C: 670000a4  beq.w $732
        beq.w H094+$732
L094_00000690:
; H094+$00000690: 2240  movea.l d0, a1
        movea.l d0, a1
L094_00000692:
; H094+$00000692: 23460018  move.l d6, $18(a1)
        move.l d6, $18(a1)
L094_00000696:
; H094+$00000696: 337c0003001c  move.w #$3, $1c(a1)
        move.w #$3, $1c(a1)
L094_0000069C:
; H094+$0000069C: 137c0010001e  move.b #$10, $1e(a1)
        move.b #$10, $1e(a1)
L094_000006A2:
; H094+$000006A2: 236c00040022  move.l $4(a4), $22(a1)
        move.l $4(a4), $22(a1)
L094_000006A8:
; H094+$000006A8: 236c000c0026  move.l $c(a4), $26(a1)
        move.l $c(a4), $26(a1)
L094_000006AE:
; H094+$000006AE: 336c0022002a  move.w $22(a4), $2a(a1)
        move.w $22(a4), $2a(a1)
L094_000006B4:
; H094+$000006B4: 4240  clr.w d0
        clr.w d0
L094_000006B6:
; H094+$000006B6: 102c002e  move.b $2e(a4), d0
        move.b $2e(a4), d0
L094_000006BA:
; H094+$000006BA: 3340002c  move.w d0, $2c(a1)
        move.w d0, $2c(a1)
L094_000006BE:
; H094+$000006BE: 337c0001002e  move.w #$1, $2e(a1)
        move.w #$1, $2e(a1)
L094_000006C4:
; H094+$000006C4: 2f0e  move.l a6, -(a7)
        move.l a6, -(a7)
L094_000006C6:
; H094+$000006C6: 2c690014  movea.l $14(a1), a6
        movea.l $14(a1), a6
L094_000006CA:
; H094+$000006CA: 4eaeffe2  jsr -$1e(a6) ; audio.device/BeginIO
        jsr LVO_audio_BeginIO(a6)
L094_000006CE:
; H094+$000006CE: 2c5f  movea.l (a7)+, a6
        movea.l (a7)+, a6
L094_000006D0:
; H094+$000006D0: 4aac0010  tst.l $10(a4)
        tst.l $10(a4)
L094_000006D4:
; H094+$000006D4: 6750  beq.b $726
        beq.b H094+$726
L094_000006D6:
; H094+$000006D6: 206d069c  movea.l $69c(a5), a0
        movea.l $69c(a5), a0
L094_000006DA:
; H094+$000006DA: 2c780004  movea.l $4.w, a6
        movea.l $4.w, a6
L094_000006DE:
; H094+$000006DE: 4eaefe8c  jsr -$174(a6) ; exec.library/GetMsg
        jsr LVO_exec_GetMsg(a6)
L094_000006E2:
; H094+$000006E2: 4a80  tst.l d0
        tst.l d0
L094_000006E4:
; H094+$000006E4: 674c  beq.b $732
        beq.b H094+$732
L094_000006E6:
; H094+$000006E6: 2240  movea.l d0, a1
        movea.l d0, a1
L094_000006E8:
; H094+$000006E8: 23460018  move.l d6, $18(a1)
        move.l d6, $18(a1)
L094_000006EC:
; H094+$000006EC: 337c0003001c  move.w #$3, $1c(a1)
        move.w #$3, $1c(a1)
L094_000006F2:
; H094+$000006F2: 137c0010001e  move.b #$10, $1e(a1)
        move.b #$10, $1e(a1)
L094_000006F8:
; H094+$000006F8: 236c00080022  move.l $8(a4), $22(a1)
        move.l $8(a4), $22(a1)
L094_000006FE:
; H094+$000006FE: 236c00100026  move.l $10(a4), $26(a1)
        move.l $10(a4), $26(a1)
L094_00000704:
; H094+$00000704: 336c0022002a  move.w $22(a4), $2a(a1)
        move.w $22(a4), $2a(a1)
L094_0000070A:
; H094+$0000070A: 4240  clr.w d0
        clr.w d0
L094_0000070C:
; H094+$0000070C: 102c002e  move.b $2e(a4), d0
        move.b $2e(a4), d0
L094_00000710:
; H094+$00000710: 3340002c  move.w d0, $2c(a1)
        move.w d0, $2c(a1)
L094_00000714:
; H094+$00000714: 337c0000002e  move.w #$0, $2e(a1)
        move.w #$0, $2e(a1)
L094_0000071A:
; H094+$0000071A: 2f0e  move.l a6, -(a7)
        move.l a6, -(a7)
L094_0000071C:
; H094+$0000071C: 2c690014  movea.l $14(a1), a6
        movea.l $14(a1), a6
L094_00000720:
; H094+$00000720: 4eaeffe2  jsr -$1e(a6) ; audio.device/BeginIO
        jsr LVO_audio_BeginIO(a6)
L094_00000724:
; H094+$00000724: 2c5f  movea.l (a7)+, a6
        movea.l (a7)+, a6
L094_00000726:
; H094+$00000726: e286  asr.l #$1, d6
        asr.l #$1, d6
L094_00000728:
; H094+$00000728: 048700000004  subi.l #$4, d7
        subi.l #$4, d7
L094_0000072E:
; H094+$0000072E: 6a00fd84  bpl.w $4b4
        bpl.w H094+$4B4
L094_00000732:
; H094+$00000732: 4cdf10c4  movem.l (a7)+, d2/d6-d7/a4
        movem.l (a7)+, d2/d6-d7/a4
L094_00000736:
; H094+$00000736: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H094_00000738 [partial]
; Purpose: Routine of the audio callbacks: vertical server and software interrupt module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H094+$039A, H094+$021E
; --------------------------------------------------------------------------
L094_00000738:
; H094+$00000738: 303c0008  move.w #$8, d0
        move.w #$8, d0
L094_0000073C:
; H094+$0000073C: 41ed00a4  lea.l $a4(a5), a0
        lea.l $a4(a5), a0
L094_00000740:
; H094+$00000740: 4a40  tst.w d0
        tst.w d0
L094_00000742:
; H094+$00000742: 6728  beq.b $76c
        beq.b H094+$76C
L094_00000744:
; H094+$00000744: 082800010034  btst.b #$1, $34(a0)
        btst #$1, $34(a0)
L094_0000074A:
; H094+$0000074A: 6616  bne.b $762
        bne.b H094+$762
L094_0000074C:
; H094+$0000074C: 117c00070034  move.b #$7, $34(a0)
        move.b #$7, $34(a0)
L094_00000752:
; H094+$00000752: 226d0254  movea.l $254(a5), a1
        movea.l $254(a5), a1
L094_00000756:
; H094+$00000756: 21490000  move.l a1, $0(a0)
        move.l a1, $0(a0)
L094_0000075A:
; H094+$0000075A: 2b480254  move.l a0, $254(a5)
        move.l a0, $254(a5)
L094_0000075E:
; H094+$0000075E: 2008  move.l a0, d0
        move.l a0, d0
L094_00000760:
; H094+$00000760: 600c  bra.b $76e
        bra.b H094+$76E
L094_00000762:
; H094+$00000762: d0fc0036  adda.w #$36, a0
        adda.w #$36, a0
L094_00000766:
; H094+$00000766: 04400001  subi.w #$1, d0
        subi.w #$1, d0
L094_0000076A:
; H094+$0000076A: 60d4  bra.b $740
        bra.b H094+$740
L094_0000076C:
; H094+$0000076C: 4280  clr.l d0
        clr.l d0
L094_0000076E:
; H094+$0000076E: 4e75  rts 
        rts 
; End H094: $770 bytes
