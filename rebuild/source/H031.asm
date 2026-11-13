; ============================================================================
; MODULE GUIDE H031
; Byte order conversions and on-disk format values.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; H031: 212 original bytes; all offsets are section-relative.
        section H031,code
H031:
; Preserved bytes H031+$00000000..$00000004; code/data not fully classified.
        dc.l H031+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H031 [partial]
; Purpose: Entry of the byte order conversions and on-disk format values module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H031+$00CC.
; Direct callers: H000+$00EA
; --------------------------------------------------------------------------
L031_00000004:
; H031+$00000004: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L031_00000006:
; H031+$00000006: 287afff8  movea.l $0(pc), a4
        movea.l H031+$0(pc), a4
L031_0000000A:
; H031+$0000000A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L031_0000000E:
; H031+$0000000E: 600000bc  bra.w $cc
        bra.w H031+$CC
; --------------------------------------------------------------------------
; ROUTINE: sub_H031_00000012 [partial]
; Purpose: Routine of the byte order conversions and on-disk format values module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H006+$0882, H006+$08C2, H028+$0E92, H028+$0F24, H028+$0F2E, H031+$0056 and 10 more
; --------------------------------------------------------------------------
L031_00000012:
; H031+$00000012: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L031_00000014:
; H031+$00000014: 287affea  movea.l $0(pc), a4
        movea.l H031+$0(pc), a4
L031_00000018:
; H031+$00000018: 4e550000  link.w a5, #$0
        link.w a5, #$0
L031_0000001C:
; H031+$0000001C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L031_00000020:
; H031+$00000020: 3413  move.w (a3), d2
        move.w (a3), d2
L031_00000022:
; H031+$00000022: e04a  lsr.w #$8, d2
        lsr.w #$8, d2
L031_00000024:
; H031+$00000024: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L031_00000028:
; H031+$00000028: 3813  move.w (a3), d4
        move.w (a3), d4
L031_0000002A:
; H031+$0000002A: e14c  lsl.w #$8, d4
        lsl.w #$8, d4
L031_0000002C:
; H031+$0000002C: d444  add.w d4, d2
        add.w d4, d2
L031_0000002E:
; H031+$0000002E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L031_00000032:
; H031+$00000032: 3682  move.w d2, (a3)
        move.w d2, (a3)
L031_00000034:
; H031+$00000034: 4e5d  unlk a5
        unlk a5
L031_00000036:
; H031+$00000036: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L031_00000038:
; H031+$00000038: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L031_0000003A:
; H031+$0000003A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L031_0000003C:
; H031+$0000003C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H031_0000003E [partial]
; Purpose: Routine of the byte order conversions and on-disk format values module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H028+$0F38, H066+$237A
; --------------------------------------------------------------------------
L031_0000003E:
; H031+$0000003E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L031_00000040:
; H031+$00000040: 287affbe  movea.l $0(pc), a4
        movea.l H031+$0(pc), a4
L031_00000044:
; H031+$00000044: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L031_00000048:
; H031+$00000048: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L031_0000004C:
; H031+$0000004C: 2413  move.l (a3), d2
        move.l (a3), d2
L031_0000004E:
; H031+$0000004E: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
L031_00000052:
; H031+$00000052: 486dfffe  pea.l -$2(a5)
        pea.l -$2(a5)
L031_00000056:
; H031+$00000056: 61ba  bsr.b $12
        bsr.b H031+$12
L031_00000058:
; H031+$00000058: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L031_0000005C:
; H031+$0000005C: 2413  move.l (a3), d2
        move.l (a3), d2
L031_0000005E:
; H031+$0000005E: e082  asr.l #$8, d2
        asr.l #$8, d2
L031_00000060:
; H031+$00000060: e082  asr.l #$8, d2
        asr.l #$8, d2
L031_00000062:
; H031+$00000062: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L031_00000066:
; H031+$00000066: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
L031_0000006A:
; H031+$0000006A: 61a6  bsr.b $12
        bsr.b H031+$12
L031_0000006C:
; H031+$0000006C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L031_00000070:
; H031+$00000070: 382dfffe  move.w -$2(a5), d4
        move.w -$2(a5), d4
L031_00000074:
; H031+$00000074: 7c10  moveq #$10, d6
        moveq #16, d6
L031_00000076:
; H031+$00000076: edac  lsl.l d6, d4
        lsl.l d6, d4
L031_00000078:
; H031+$00000078: 8842  or.w d2, d4
        or.w d2, d4
L031_0000007A:
; H031+$0000007A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L031_0000007E:
; H031+$0000007E: 2684  move.l d4, (a3)
        move.l d4, (a3)
L031_00000080:
; H031+$00000080: 4e5d  unlk a5
        unlk a5
L031_00000082:
; H031+$00000082: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L031_00000084:
; H031+$00000084: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L031_00000086:
; H031+$00000086: 588f  addq.l #$4, a7
        addq.l #$4, a7
L031_00000088:
; H031+$00000088: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H031_0000008A [partial]
; Purpose: Routine of the byte order conversions and on-disk format values module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H012+$0DA4, H012+$0DC2, H066+$2152, H066+$21FE, H066+$2214, H066+$22FC and 4 more
; --------------------------------------------------------------------------
L031_0000008A:
; H031+$0000008A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L031_0000008C:
; H031+$0000008C: 287aff72  movea.l $0(pc), a4
        movea.l H031+$0(pc), a4
L031_00000090:
; H031+$00000090: 4e550000  link.w a5, #$0
        link.w a5, #$0
L031_00000094:
; H031+$00000094: 7400  moveq #$0, d2
        moveq #0, d2
L031_00000096:
; H031+$00000096: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L031_0000009A:
; H031+$0000009A: 0c420080  cmpi.w #$80, d2
        cmpi.w #$80, d2
L031_0000009E:
; H031+$0000009E: 64000012  bcc.w $b2
        bcc.w H031+$B2
L031_000000A2:
; H031+$000000A2: 7400  moveq #$0, d2
        moveq #0, d2
L031_000000A4:
; H031+$000000A4: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L031_000000A8:
; H031+$000000A8: 3002  move.w d2, d0
        move.w d2, d0
L031_000000AA:
; H031+$000000AA: 60000016  bra.w $c2
        bra.w H031+$C2
; Preserved bytes H031+$000000AE..$000000B2; code/data not fully classified.
        dc.w $6000,$0012
L031_000000B2:
; H031+$000000B2: 7400  moveq #$0, d2
        moveq #0, d2
L031_000000B4:
; H031+$000000B4: 142d000c  move.b $c(a5), d2
        move.b $c(a5), d2
L031_000000B8:
; H031+$000000B8: 04420100  subi.w #$100, d2
        subi.w #$100, d2
L031_000000BC:
; H031+$000000BC: 3002  move.w d2, d0
        move.w d2, d0
L031_000000BE:
; H031+$000000BE: 60000002  bra.w $c2
        bra.w H031+$C2
L031_000000C2:
; H031+$000000C2: 4e5d  unlk a5
        unlk a5
L031_000000C4:
; H031+$000000C4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L031_000000C6:
; H031+$000000C6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L031_000000C8:
; H031+$000000C8: 548f  addq.l #$2, a7
        addq.l #$2, a7
L031_000000CA:
; H031+$000000CA: 4ed0  jmp (a0)
        jmp (a0)
L031_000000CC:
; H031+$000000CC: 4e5d  unlk a5
        unlk a5
L031_000000CE:
; H031+$000000CE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L031_000000D0:
; H031+$000000D0: 4e75  rts 
        rts 
; Preserved bytes H031+$000000D2..$000000D4; code/data not fully classified.
        dc.w $0000
; End H031: $D4 bytes
