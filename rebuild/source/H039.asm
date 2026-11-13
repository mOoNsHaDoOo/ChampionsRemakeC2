; ============================================================================
; MODULE GUIDE H039
; callback/initialisation services for the IFF parser.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; --------------------------------------------------------------------------
; MODULE NOTE
; Callback/initialisation services for the IFF parser. The functions are called by the ILBM reader and by the start-up chain.
; --------------------------------------------------------------------------
; H039: 104 original bytes; all offsets are section-relative.
        section H039,code
H039:
; Preserved bytes H039+$00000000..$00000004; code/data not fully classified.
        dc.l H039+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H039_0064 [partial]
; Purpose: Trampoline to H039+$0064; the actual body is there.
;   - Jumps to the actual body at H039+$0064.
; Direct callers: H000+$008A
; --------------------------------------------------------------------------
L039_00000004:
; H039+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L039_00000008:
; H039+$00000008: 6000005a  bra.w $64
        bra.w H039+$64
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H039_0022 [partial]
; Purpose: Trampoline to H039+$0022; the actual body is there.
;   - Jumps to the actual body at H039+$0022.
; Direct callers: H086+$0192, H086+$023A, H086+$0412, H087+$0360, H087+$0374
; --------------------------------------------------------------------------
L039_0000000C:
; H039+$0000000C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L039_00000010:
; H039+$00000010: 266d0008  movea.l $8(a5), a3
        movea.l $8(a5), a3
L039_00000014:
; H039+$00000014: 242b0018  move.l $18(a3), d2
        move.l $18(a3), d2
L039_00000018:
; H039+$00000018: 94ab0020  sub.l $20(a3), d2
        sub.l $20(a3), d2
L039_0000001C:
; H039+$0000001C: 2002  move.l d2, d0
        move.l d2, d0
L039_0000001E:
; H039+$0000001E: 60000002  bra.w $22
        bra.w H039+$22
L039_00000022:
; H039+$00000022: 4e5d  unlk a5
        unlk a5
L039_00000024:
; H039+$00000024: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L039_00000026:
; H039+$00000026: 588f  addq.l #$4, a7
        addq.l #$4, a7
L039_00000028:
; H039+$00000028: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H039+$0000002A..$00000064; code/data not fully classified.
        dc.w $4E55,$0000,$242D,$0008,$5282,$0282,$FFFF,$FFFE
        dc.w $2002,$6000,$0002,$4E5D,$205F,$588F,$4ED0,$4E55
        dc.w $0000,$2F2D,$0008,$61D8,$2400,$5082,$2002,$6000
        dc.w $0002,$4E5D,$205F,$588F,$4ED0
L039_00000064:
; H039+$00000064: 4e5d  unlk a5
        unlk a5
L039_00000066:
; H039+$00000066: 4e75  rts 
        rts 
; End H039: $68 bytes
