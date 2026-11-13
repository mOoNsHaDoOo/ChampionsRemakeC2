; ============================================================================
; MODULE GUIDE H023
; shared initialisation services (called by several modules).
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; H023: 140 original bytes; all offsets are section-relative.
        section H023,code
H023:
; Preserved bytes H023+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H023+$00000004
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H023_007E [partial]
; Purpose: Trampoline to H023+$007E; the actual body is there.
;   - Jumps to the actual body at H023+$007E.
; Direct callers: H000+$0054
; --------------------------------------------------------------------------
L023_00000008:
; H023+$00000008: 4e550000  link.w a5, #$0
        link.w a5, #$0
L023_0000000C:
; H023+$0000000C: 60000070  bra.w $7e
        bra.w H023+$7E
; --------------------------------------------------------------------------
; ROUTINE: sub_H023_00000010 [partial]
; Purpose: Routine of the shared initialisation services (called by several modules) module; calls H015+$004A, H015+$006E.
;   - Calls H015+$004A.
;   - Calls H015+$006E.
; Direct callers: H062+$159E, H009+$0134, H009+$016C, H009+$01AA, H042+$049C, H013+$0AD0 and 9 more
; --------------------------------------------------------------------------
L023_00000010:
; H023+$00000010: 4e550000  link.w a5, #$0
        link.w a5, #$0
L023_00000014:
; H023+$00000014: 243900000000  move.l $0.l, d2
        move.l (H023+$0).l, d2
L023_0000001A:
; H023+$0000001A: 2002  move.l d2, d0
        move.l d2, d0
L023_0000001C:
; H023+$0000001C: 223c01df5e0d  move.l #$1df5e0d, d1
        move.l #$1df5e0d, d1
; -> H015+$004A (sub_H015_0000004A)
L023_00000022:
; H023+$00000022: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L023_00000028:
; H023+$00000028: 2400  move.l d0, d2
        move.l d0, d2
L023_0000002A:
; H023+$0000002A: 5282  addq.l #$1, d2
        addq.l #$1, d2
L023_0000002C:
; H023+$0000002C: 2002  move.l d2, d0
        move.l d2, d0
L023_0000002E:
; H023+$0000002E: 223c05f5e100  move.l #$5f5e100, d1
        move.l #$5f5e100, d1
; -> H015+$006E (sub_H015_0000006E)
L023_00000034:
; H023+$00000034: 4eb90000006e  jsr $6e.l
        jsr (H015+$6E).l
L023_0000003A:
; H023+$0000003A: 23c100000000  move.l d1, $0.l
        move.l d1, (H023+$0).l
L023_00000040:
; H023+$00000040: 243900000000  move.l $0.l, d2
        move.l (H023+$0).l, d2
L023_00000046:
; H023+$00000046: 2002  move.l d2, d0
        move.l d2, d0
L023_00000048:
; H023+$00000048: 223c00002710  move.l #$2710, d1
        move.l #$2710, d1
; -> H015+$006E (sub_H015_0000006E)
L023_0000004E:
; H023+$0000004E: 4eb90000006e  jsr $6e.l
        jsr (H015+$6E).l
L023_00000054:
; H023+$00000054: 2400  move.l d0, d2
        move.l d0, d2
L023_00000056:
; H023+$00000056: 2002  move.l d2, d0
        move.l d2, d0
L023_00000058:
; H023+$00000058: 222d0008  move.l $8(a5), d1
        move.l $8(a5), d1
; -> H015+$004A (sub_H015_0000004A)
L023_0000005C:
; H023+$0000005C: 4eb90000004a  jsr $4a.l
        jsr (H015+$4A).l
L023_00000062:
; H023+$00000062: 2400  move.l d0, d2
        move.l d0, d2
L023_00000064:
; H023+$00000064: 2002  move.l d2, d0
        move.l d2, d0
L023_00000066:
; H023+$00000066: 223c00002710  move.l #$2710, d1
        move.l #$2710, d1
; -> H015+$006E (sub_H015_0000006E)
L023_0000006C:
; H023+$0000006C: 4eb90000006e  jsr $6e.l
        jsr (H015+$6E).l
L023_00000072:
; H023+$00000072: 60000002  bra.w $76
        bra.w H023+$76
L023_00000076:
; H023+$00000076: 4e5d  unlk a5
        unlk a5
L023_00000078:
; H023+$00000078: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L023_0000007A:
; H023+$0000007A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L023_0000007C:
; H023+$0000007C: 4ed0  jmp (a0)
        jmp (a0)
L023_0000007E:
; H023+$0000007E: 23fc0070c4df00000000  move.l #$70c4df, $0.l
        move.l #$70c4df, (H023+$0).l
L023_00000088:
; H023+$00000088: 4e5d  unlk a5
        unlk a5
L023_0000008A:
; H023+$0000008A: 4e75  rts 
        rts 
; End H023: $8C bytes
