; ============================================================================
; MODULE GUIDE H075
; file open/read helpers.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; --------------------------------------------------------------------------
; MODULE NOTE
; File open/read helpers: open, read and close the files used by the loaders.
; --------------------------------------------------------------------------
; H075: 392 original bytes; all offsets are section-relative.
        section H075,code
H075:
; Preserved bytes H075+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H075+$00000004
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H075_0184 [partial]
; Purpose: Trampoline to H075+$0184; the actual body is there.
;   - Jumps to the actual body at H075+$0184.
; Direct callers: H000+$003C
; --------------------------------------------------------------------------
L075_00000008:
; H075+$00000008: 4e550000  link.w a5, #$0
        link.w a5, #$0
L075_0000000C:
; H075+$0000000C: 60000176  bra.w $184
        bra.w H075+$184
; Preserved bytes H075+$00000010..$000000FE; code/data not fully classified.
        dc.w $4E55,$0000,$4239
        dc.l H075+$00000003
        dc.w $4A39
        dc.l H075+$00000002
        dc.w $6700,$0016,$266D,$0008,$16B9
        dc.l H075+$00000001
        dc.w $4239
        dc.l H075+$00000002
        dc.w $6000,$0038,$2F39
        dc.l H015+$00000012
        dc.w $266D,$0008,$2F0B,$2F3C,$0000,$0001,$4EB9
        dc.l H002+$00000122
        dc.w $2400,$4A82,$6600,$000E,$13FC,$0001
        dc.l H075+$00000003
        dc.w $6000,$000C,$266D,$0008,$13D3
        dc.l H075+$00000001
        dc.w $4E5D,$205F,$588F,$4ED0,$4E55,$FFFC,$4239
        dc.l H075+$00000003
        dc.w $4A39
        dc.l H075+$00000002
        dc.w $6700,$0016,$266D,$0008,$16B9
        dc.l H075+$00000001
        dc.w $4239
        dc.l H075+$00000002
        dc.w $6000,$004A,$2F39
        dc.l H015+$00000012
        dc.w $2F3C,$0000,$0001,$4EB9
        dc.l H002+$000001B4
        dc.w $1400,$4A02,$6700,$002A,$2F39
        dc.l H015+$00000012
        dc.w $266D,$0008,$2F0B,$7401,$2F02,$4EB9
        dc.l H002+$00000122
        dc.w $2B40,$FFFC,$266D,$0008,$13D3
        dc.l H075+$00000001
        dc.w $6000,$0008,$266D,$0008,$4213,$4E5D,$205F,$588F
        dc.w $4ED0,$4E55,$0000,$13FC,$0001
        dc.l H075+$00000002
        dc.w $4E5D,$4E75
; --------------------------------------------------------------------------
; ROUTINE: sub_H075_000000FE [partial]
; Purpose: Routine of the file open/read helpers module; calls H002+$01CC.
;   - Calls H002+$01CC.
; Direct callers: H075+$012C
; --------------------------------------------------------------------------
L075_000000FE:
; H075+$000000FE: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L075_00000102:
; H075+$00000102: 2f390000000e  move.l $e.l, -(a7)
        move.l (H015+$E).l, -(a7)
L075_00000108:
; H075+$00000108: 47ed0008  lea.l $8(a5), a3
        lea.l $8(a5), a3
L075_0000010C:
; H075+$0000010C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L075_0000010E:
; H075+$0000010E: 7401  moveq #$1, d2
        moveq #1, d2
L075_00000110:
; H075+$00000110: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01CC (wrapper_Write)
L075_00000112:
; H075+$00000112: 4eb9000001cc  jsr $1cc.l
        jsr (H002+$1CC).l
L075_00000118:
; H075+$00000118: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L075_0000011C:
; H075+$0000011C: 4e5d  unlk a5
        unlk a5
L075_0000011E:
; H075+$0000011E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L075_00000120:
; H075+$00000120: 548f  addq.l #$2, a7
        addq.l #$2, a7
L075_00000122:
; H075+$00000122: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H075_00000124 [partial]
; Purpose: Routine of the file open/read helpers module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H020+$0850
; --------------------------------------------------------------------------
L075_00000124:
; H075+$00000124: 4e550000  link.w a5, #$0
        link.w a5, #$0
L075_00000128:
; H075+$00000128: 1f3c000a  move.b #$a, -(a7)
        move.b #$a, -(a7)
L075_0000012C:
; H075+$0000012C: 61d0  bsr.b $fe
        bsr.b H075+$FE
L075_0000012E:
; H075+$0000012E: 4e5d  unlk a5
        unlk a5
L075_00000130:
; H075+$00000130: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H075_00000132 [partial]
; Purpose: Routine of the file open/read helpers module; calls H002+$01CC.
;   - Calls H002+$01CC.
; Direct callers: H020+$08B4
; --------------------------------------------------------------------------
L075_00000132:
; H075+$00000132: 4e55fffa  link.w a5, #$fffa
        link.w a5, #$fffa
L075_00000136:
; H075+$00000136: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L075_0000013A:
; H075+$0000013A: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L075_0000013E:
; H075+$0000013E: 382dfffa  move.w -$6(a5), d4
        move.w -$6(a5), d4
L075_00000142:
; H075+$00000142: b842  cmp.w d2, d4
        cmp.w d2, d4
L075_00000144:
; H075+$00000144: 62000018  bhi.w $15e
        bhi.w H075+$15E
L075_00000148:
; H075+$00000148: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L075_0000014C:
; H075+$0000014C: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L075_00000150:
; H075+$00000150: 4a332000  tst.b (a3, d2.w)
        tst.b (a3, d2.w)
L075_00000154:
; H075+$00000154: 67000008  beq.w $15e
        beq.w H075+$15E
L075_00000158:
; H075+$00000158: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L075_0000015C:
; H075+$0000015C: 60dc  bra.b $13a
        bra.b H075+$13A
L075_0000015E:
; H075+$0000015E: 2f390000000e  move.l $e.l, -(a7)
        move.l (H015+$E).l, -(a7)
L075_00000164:
; H075+$00000164: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L075_00000168:
; H075+$00000168: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L075_0000016A:
; H075+$0000016A: 7400  moveq #$0, d2
        moveq #0, d2
L075_0000016C:
; H075+$0000016C: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L075_00000170:
; H075+$00000170: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01CC (wrapper_Write)
L075_00000172:
; H075+$00000172: 4eb9000001cc  jsr $1cc.l
        jsr (H002+$1CC).l
L075_00000178:
; H075+$00000178: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L075_0000017C:
; H075+$0000017C: 4e5d  unlk a5
        unlk a5
L075_0000017E:
; H075+$0000017E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L075_00000180:
; H075+$00000180: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L075_00000182:
; H075+$00000182: 4ed0  jmp (a0)
        jmp (a0)
L075_00000184:
; H075+$00000184: 4e5d  unlk a5
        unlk a5
L075_00000186:
; H075+$00000186: 4e75  rts 
        rts 
; End H075: $188 bytes
