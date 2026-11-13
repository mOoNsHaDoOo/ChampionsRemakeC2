; ============================================================================
; MODULE GUIDE H093
; initialisation of the shared custom base.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================
; --------------------------------------------------------------------------
; MODULE NOTE
; Initialisation of the shared custom base; works together with H100.
; --------------------------------------------------------------------------
; H093: 56 original bytes; all offsets are section-relative.
        section H093,code
H093:
; Preserved bytes H093+$00000000..$00000004; code/data not fully classified.
        dc.l H093+$00000000
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H093_0034 [partial]
; Purpose: Trampoline to H093+$0034; the actual body is there.
;   - Jumps to the actual body at H093+$0034.
; Direct callers: H000+$0138
; --------------------------------------------------------------------------
L093_00000004:
; H093+$00000004: 4e550000  link.w a5, #$0
        link.w a5, #$0
L093_00000008:
; H093+$00000008: 6000002a  bra.w $34
        bra.w H093+$34
; Preserved bytes H093+$0000000C..$00000034; code/data not fully classified.
        dc.w $4E55,$0000,$2679
        dc.l H100+$00000000
        dc.w $377C,$8020,$009A,$4E5D,$4E75,$4E55,$0000,$2679
        dc.l H100+$00000000
        dc.w $377C,$0020,$009A,$4E5D,$4E75
L093_00000034:
; H093+$00000034: 4e5d  unlk a5
        unlk a5
L093_00000036:
; H093+$00000036: 4e75  rts 
        rts 
; End H093: $38 bytes
