; ============================================================================
; MODULE GUIDE H098
; File read/seek backend for the IFF parser.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; File read/seek backend for the IFF parser.
; --------------------------------------------------------------------------
; H098: 844 original bytes; all offsets are section-relative.
        section H098,code
H098:
; Preserved bytes H098+$00000000..$00000018; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000
        dc.l H098+$00000014
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H098_0346 [partial]
; Purpose: Trampoline to H098+$0346; the actual body is there.
;   - Jumps to the actual body at H098+$0346.
; Direct callers: H000+$00C0
; --------------------------------------------------------------------------
L098_00000018:
; H098+$00000018: 4e550000  link.w a5, #$0
        link.w a5, #$0
L098_0000001C:
; H098+$0000001C: 60000328  bra.w $346
        bra.w H098+$346
; Preserved bytes H098+$00000020..$0000007C; code/data not fully classified.
        dc.w $4E55,$0000,$2F2D,$000C,$2F2D,$0008,$4EB9
        dc.l H002+$000000F2
        dc.w $6000,$0002,$4E5D,$205F,$508F,$4ED0,$4E55,$FFF8
        dc.w $42AD,$FFFC,$242D,$0008,$B4B9
        dc.l H098+$00000010
        dc.w $6600,$0010,$2F2D,$0008,$4EB9
        dc.l H098+$0000032A
        dc.w $2B40,$FFFC,$2F2D,$0008,$4EB9
        dc.l H002+$00000014
        dc.w $202D,$FFFC,$6000,$0002,$4E5D,$205F,$588F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H098_0000007C [partial]
; Purpose: Routine of the file read/seek backend for the IFF parser module; calls H002+$0122.
;   - Calls H002+$0122.
; Direct callers: H086+$0448, H086+$02CC
; --------------------------------------------------------------------------
L098_0000007C:
; H098+$0000007C: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L098_00000080:
; H098+$00000080: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L098_00000084:
; H098+$00000084: 242d0010  move.l $10(a5), d2
        move.l $10(a5), d2
L098_00000088:
; H098+$00000088: b4b900000010  cmp.l $10.l, d2
        cmp.l (H098+$10).l, d2
L098_0000008E:
; H098+$0000008E: 66000010  bne.w $a0
        bne.w H098+$A0
L098_00000092:
; H098+$00000092: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L098_00000096:
; H098+$00000096: 4eb9000000d0  jsr $d0.l
        jsr (H098+$D0).l
L098_0000009C:
; H098+$0000009C: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L098_000000A0:
; H098+$000000A0: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L098_000000A4:
; H098+$000000A4: 6d000018  blt.w $be
        blt.w H098+$BE
L098_000000A8:
; H098+$000000A8: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L098_000000AC:
; H098+$000000AC: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L098_000000B0:
; H098+$000000B0: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
; -> H002+$0122 (wrapper_Read)
L098_000000B4:
; H098+$000000B4: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L098_000000BA:
; H098+$000000BA: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L098_000000BE:
; H098+$000000BE: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L098_000000C2:
; H098+$000000C2: 60000002  bra.w $c6
        bra.w H098+$C6
L098_000000C6:
; H098+$000000C6: 4e5d  unlk a5
        unlk a5
L098_000000C8:
; H098+$000000C8: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L098_000000CA:
; H098+$000000CA: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L098_000000CE:
; H098+$000000CE: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H098_000000D0 [partial]
; Purpose: Routine of the file read/seek backend for the IFF parser module; calls H002+$01CC.
;   - Calls H002+$01CC.
; Direct callers: H098+$02DE, H098+$0096
; --------------------------------------------------------------------------
L098_000000D0:
; H098+$000000D0: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L098_000000D4:
; H098+$000000D4: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L098_000000D8:
; H098+$000000D8: 4ab900000010  tst.l $10.l
        tst.l (H098+$10).l
L098_000000DE:
; H098+$000000DE: 67000032  beq.w $112
        beq.w H098+$112
L098_000000E2:
; H098+$000000E2: 4ab90000000c  tst.l $c.l
        tst.l (H098+$C).l
L098_000000E8:
; H098+$000000E8: 67000028  beq.w $112
        beq.w H098+$112
L098_000000EC:
; H098+$000000EC: 4ab900000004  tst.l $4.l
        tst.l (H098+$4).l
L098_000000F2:
; H098+$000000F2: 6f00001e  ble.w $112
        ble.w H098+$112
L098_000000F6:
; H098+$000000F6: 2f3900000010  move.l $10.l, -(a7)
        move.l (H098+$10).l, -(a7)
L098_000000FC:
; H098+$000000FC: 2f390000000c  move.l $c.l, -(a7)
        move.l (H098+$C).l, -(a7)
L098_00000102:
; H098+$00000102: 2f3900000000  move.l $0.l, -(a7)
        move.l (H098+$0).l, -(a7)
; -> H002+$01CC (wrapper_Write)
L098_00000108:
; H098+$00000108: 4eb9000001cc  jsr $1cc.l
        jsr (H002+$1CC).l
L098_0000010E:
; H098+$0000010E: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L098_00000112:
; H098+$00000112: 42b900000000  clr.l $0.l
        clr.l (H098+$0).l
L098_00000118:
; H098+$00000118: 42b900000004  clr.l $4.l
        clr.l (H098+$4).l
L098_0000011E:
; H098+$0000011E: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L098_00000122:
; H098+$00000122: 60000002  bra.w $126
        bra.w H098+$126
L098_00000126:
; H098+$00000126: 4e5d  unlk a5
        unlk a5
L098_00000128:
; H098+$00000128: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L098_0000012A:
; H098+$0000012A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L098_0000012C:
; H098+$0000012C: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H098+$0000012E..$00000276; code/data not fully classified.
        dc.w $4E55,$FFFC,$2F39
        dc.l H098+$00000010
        dc.w $6196,$2B40,$FFFC,$4AAD,$0010,$6700,$0024,$242D
        dc.w $0010,$B4B9
        dc.l H098+$00000010
        dc.w $6600,$000A,$4AAD,$000C,$6700,$000E,$0CAD,$0000
        dc.w $0003,$0008,$6E00,$0018,$42B9
        dc.l H098+$00000010
        dc.w $42B9
        dc.l H098+$0000000C
        dc.w $42B9
        dc.l H098+$00000008
        dc.w $6000,$001A,$23ED,$0010
        dc.l H098+$00000010
        dc.w $23ED,$000C
        dc.l H098+$0000000C
        dc.w $23ED,$0008
        dc.l H098+$00000008
        dc.w $202D,$FFFC,$6000,$0002,$4E5D,$205F,$4FEF,$000C
        dc.w $4ED0,$4E55,$FFFC,$42AD,$FFFC,$242D,$0010,$B4B9
        dc.l H098+$00000010
        dc.w $6600,$0080,$4AB9
        dc.l H098+$0000000C
        dc.w $6700,$0076,$2439
        dc.l H098+$00000004
        dc.w $D4AD,$0008,$2839
        dc.l H098+$00000008
        dc.w $B882,$6D00,$004A,$2F2D,$000C,$2439
        dc.l H098+$0000000C
        dc.w $D4B9
        dc.l H098+$00000004
        dc.w $2F02,$2F2D,$0008,$4EB9
        dc.l H003+$00000090
        dc.w $242D,$0008,$D5B9
        dc.l H098+$00000004
        dc.w $2439
        dc.l H098+$00000004
        dc.w $B4B9
        dc.l H098+$00000000
        dc.w $6F00,$000C,$23F9
        dc.l H098+$00000004
        dc.l H098+$00000000
        dc.w $42AD,$0008,$6000,$0018,$23F9
        dc.l H098+$00000004
        dc.l H098+$00000000
        dc.w $2F2D,$0010,$6100,$FE9A,$2B40,$FFFC,$4AAD,$0008
        dc.w $6F00,$0022,$4AAD,$FFFC,$6D00,$001A,$2F2D,$0010
        dc.w $2F2D,$000C,$2F2D,$0008,$4EB9
        dc.l H002+$000001CC
        dc.w $2400,$D5AD,$FFFC,$202D,$FFFC,$6000,$0002,$4E5D
        dc.w $205F,$4FEF,$000C,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H098_00000276 [partial]
; Purpose: Routine of the file read/seek backend for the IFF parser module; calls H002+$0156.
;   - Calls H002+$0156.
; Direct callers: H086+$0086, H086+$002C, H086+$003E, H086+$0140
; --------------------------------------------------------------------------
L098_00000276:
; H098+$00000276: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L098_0000027A:
; H098+$0000027A: 2b7cfffffffefffc  move.l #$fffffffe, -$4(a5)
        move.l #$fffffffe, -$4(a5)
L098_00000282:
; H098+$00000282: 243900000004  move.l $4.l, d2
        move.l (H098+$4).l, d2
L098_00000288:
; H098+$00000288: d4ad000c  add.l $c(a5), d2
        add.l $c(a5), d2
L098_0000028C:
; H098+$0000028C: 2b42fff8  move.l d2, -$8(a5)
        move.l d2, -$8(a5)
L098_00000290:
; H098+$00000290: 242d0010  move.l $10(a5), d2
        move.l $10(a5), d2
L098_00000294:
; H098+$00000294: b4b900000010  cmp.l $10.l, d2
        cmp.l (H098+$10).l, d2
L098_0000029A:
; H098+$0000029A: 6600005a  bne.w $2f6
        bne.w H098+$2F6
L098_0000029E:
; H098+$0000029E: 4ab90000000c  tst.l $c.l
        tst.l (H098+$C).l
L098_000002A4:
; H098+$000002A4: 67000050  beq.w $2f6
        beq.w H098+$2F6
L098_000002A8:
; H098+$000002A8: 4aad0008  tst.l $8(a5)
        tst.l $8(a5)
L098_000002AC:
; H098+$000002AC: 6600002c  bne.w $2da
        bne.w H098+$2DA
L098_000002B0:
; H098+$000002B0: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L098_000002B4:
; H098+$000002B4: 6d000024  blt.w $2da
        blt.w H098+$2DA
L098_000002B8:
; H098+$000002B8: 242dfff8  move.l -$8(a5), d2
        move.l -$8(a5), d2
L098_000002BC:
; H098+$000002BC: b4b900000000  cmp.l $0.l, d2
        cmp.l (H098+$0).l, d2
L098_000002C2:
; H098+$000002C2: 6e000016  bgt.w $2da
        bgt.w H098+$2DA
L098_000002C6:
; H098+$000002C6: 2b7900000004fffc  move.l $4.l, -$4(a5)
        move.l (H098+$4).l, -$4(a5)
L098_000002CE:
; H098+$000002CE: 23edfff800000004  move.l -$8(a5), $4.l
        move.l -$8(a5), (H098+$4).l
L098_000002D6:
; H098+$000002D6: 6000001e  bra.w $2f6
        bra.w H098+$2F6
L098_000002DA:
; H098+$000002DA: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L098_000002DE:
; H098+$000002DE: 6100fdf0  bsr.w $d0
        bsr.w H098+$D0
L098_000002E2:
; H098+$000002E2: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L098_000002E6:
; H098+$000002E6: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L098_000002EA:
; H098+$000002EA: 6d00000a  blt.w $2f6
        blt.w H098+$2F6
L098_000002EE:
; H098+$000002EE: 2b7cfffffffefffc  move.l #$fffffffe, -$4(a5)
        move.l #$fffffffe, -$4(a5)
L098_000002F6:
; H098+$000002F6: 0cadfffffffefffc  cmpi.l #$fffffffe, -$4(a5)
        cmpi.l #$fffffffe, -$4(a5)
L098_000002FE:
; H098+$000002FE: 66000018  bne.w $318
        bne.w H098+$318
L098_00000302:
; H098+$00000302: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L098_00000306:
; H098+$00000306: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L098_0000030A:
; H098+$0000030A: 2f2d0008  move.l $8(a5), -(a7)
        move.l $8(a5), -(a7)
; -> H002+$0156 (wrapper_Seek)
L098_0000030E:
; H098+$0000030E: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L098_00000314:
; H098+$00000314: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L098_00000318:
; H098+$00000318: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L098_0000031C:
; H098+$0000031C: 60000002  bra.w $320
        bra.w H098+$320
L098_00000320:
; H098+$00000320: 4e5d  unlk a5
        unlk a5
L098_00000322:
; H098+$00000322: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L098_00000324:
; H098+$00000324: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L098_00000328:
; H098+$00000328: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H098+$0000032A..$00000346; code/data not fully classified.
        dc.w $4E55,$0000,$2F2D,$0008,$42A7,$42A7,$6100,$FDF6
        dc.w $6000,$0002,$4E5D,$205F,$588F,$4ED0
L098_00000346:
; H098+$00000346: 4e5d  unlk a5
        unlk a5
L098_00000348:
; H098+$00000348: 4e75  rts 
        rts 
; Preserved bytes H098+$0000034A..$0000034C; code/data not fully classified.
        dc.w $0000
; End H098: $34C bytes
