; ============================================================================
; MODULE GUIDE H100
; Initialisation of a slot with the custom base $DFF000.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Initialisation of a slot with the custom base $DFF000.
; --------------------------------------------------------------------------
; H100: 28 original bytes; all offsets are section-relative.
        section H100,code
H100:
; Preserved bytes H100+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H100+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H100_00000008 [partial]
; Purpose: Routine of the initialisation of a slot with the custom base $DFF000 module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0132
; --------------------------------------------------------------------------
L100_00000008:
; H100+$00000008: 4e550000  link.w a5, #$0
        link.w a5, #$0
L100_0000000C:
; H100+$0000000C: 23fc00dff00000000000  move.l #$dff000, $0.l
        move.l #$dff000, (H100+$0).l
L100_00000016:
; H100+$00000016: 4e5d  unlk a5
        unlk a5
L100_00000018:
; H100+$00000018: 4e75  rts 
        rts 
; Preserved bytes H100+$0000001A..$0000001C; code/data not fully classified.
        dc.w $0000
; End H100: $1C bytes
