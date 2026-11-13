; ============================================================================
; MODULE GUIDE H002
; Compiler stack adapters to the dos.library API.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Each function is an adapter: it reads the arguments from the stack according to the compiler convention, moves them into the registers required by dos.library, jumps to the LVO and fixes the stack. The first entry copies DOSBase into the data base of the module.
; --------------------------------------------------------------------------
; H002: 572 original bytes; all offsets are section-relative.
        section H002,code
H002:
; Preserved bytes H002+$00000000..$00000008; code/data not fully classified.
        dc.w $0000,$0000
        dc.l H002+$00000004
; --------------------------------------------------------------------------
; ROUTINE: sub_H002_00000008 [partial]
; Purpose: Routine of the compiler stack adapters to the dos.library API module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H000+$0006
; --------------------------------------------------------------------------
L002_00000008:
; H002+$00000008: 41fafffa  lea.l $4(pc), a0
        lea.l H002+$4(pc), a0
L002_0000000C:
; H002+$0000000C: 216cfff8fffc  move.l -$8(a4), -$4(a0)
        move.l -$8(a4), -$4(a0)
L002_00000012:
; H002+$00000012: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Close [partial]
; Purpose: Adapter to dos.library/Close; wraps the library call.
;   - Calls dos.library/Close (LVO -36).
; Direct callers: H007+$0A60, H006+$08FC, H043+$0662, H007+$0588, H030+$0C62, H029+$0306 and 18 more
; --------------------------------------------------------------------------
L002_00000014:
; H002+$00000014: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L002_00000018:
; H002+$00000018: 2c7affe6  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_0000001C:
; H002+$0000001C: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L002_00000020:
; H002+$00000020: 588f  addq.l #$4, a7
        addq.l #$4, a7
L002_00000022:
; H002+$00000022: 4eeeffdc  jmp -$24(a6) ; dos.library/Close
        jmp LVO_dos_Close(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_CreateDir [partial]
; Purpose: Adapter to dos.library/CreateDir; wraps the library call.
;   - Calls dos.library/CreateDir (LVO -120).
; Direct callers: H066+$0B64
; --------------------------------------------------------------------------
L002_00000026:
; H002+$00000026: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L002_0000002A:
; H002+$0000002A: 2c7affd4  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_0000002E:
; H002+$0000002E: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L002_00000032:
; H002+$00000032: 588f  addq.l #$4, a7
        addq.l #$4, a7
L002_00000034:
; H002+$00000034: 4eeeff88  jmp -$78(a6) ; dos.library/CreateDir
        jmp LVO_dos_CreateDir(a6)
; Preserved bytes H002+$00000038..$0000004A; code/data not fully classified.
        dc.w $222F,$0004,$2C7A,$FFC2,$2F57,$0004,$588F,$4EEE
        dc.w $FF82
; --------------------------------------------------------------------------
; ROUTINE: wrapper_DeleteFile [partial]
; Purpose: Adapter to dos.library/DeleteFile; wraps the library call.
;   - Calls dos.library/DeleteFile (LVO -72).
; Direct callers: H066+$13AA, H066+$13E2, H066+$141A, H066+$1A1A, H066+$162A, H066+$1A98
; --------------------------------------------------------------------------
L002_0000004A:
; H002+$0000004A: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L002_0000004E:
; H002+$0000004E: 2c7affb0  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_00000052:
; H002+$00000052: 4eaeffb8  jsr -$48(a6) ; dos.library/DeleteFile
        jsr LVO_dos_DeleteFile(a6)
L002_00000056:
; H002+$00000056: 4400  neg.b d0
        neg.b d0
L002_00000058:
; H002+$00000058: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L002_0000005A:
; H002+$0000005A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L002_0000005C:
; H002+$0000005C: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H002+$0000005E..$00000070; code/data not fully classified.
        dc.w $222F,$0004,$2C7A,$FF9C,$2F57,$0004,$588F,$4EEE
        dc.w $FFA0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Examine [partial]
; Purpose: Adapter to dos.library/Examine; wraps the library call.
;   - Calls dos.library/Examine (LVO -102).
; Direct callers: H066+$0442, H028+$03BC
; --------------------------------------------------------------------------
L002_00000070:
; H002+$00000070: 222f0008  move.l $8(a7), d1
        move.l $8(a7), d1
L002_00000074:
; H002+$00000074: 242f0004  move.l $4(a7), d2
        move.l $4(a7), d2
L002_00000078:
; H002+$00000078: 2c7aff86  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_0000007C:
; H002+$0000007C: 4eaeff9a  jsr -$66(a6) ; dos.library/Examine
        jsr LVO_dos_Examine(a6)
L002_00000080:
; H002+$00000080: 4400  neg.b d0
        neg.b d0
L002_00000082:
; H002+$00000082: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L002_00000084:
; H002+$00000084: 508f  addq.l #$8, a7
        addq.l #$8, a7
L002_00000086:
; H002+$00000086: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_ExNext [partial]
; Purpose: Adapter to dos.library/ExNext; wraps the library call.
;   - Calls dos.library/ExNext (LVO -108).
; Direct callers: H066+$0458
; --------------------------------------------------------------------------
L002_00000088:
; H002+$00000088: 222f0008  move.l $8(a7), d1
        move.l $8(a7), d1
L002_0000008C:
; H002+$0000008C: 242f0004  move.l $4(a7), d2
        move.l $4(a7), d2
L002_00000090:
; H002+$00000090: 2c7aff6e  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_00000094:
; H002+$00000094: 4eaeff94  jsr -$6c(a6) ; dos.library/ExNext
        jsr LVO_dos_ExNext(a6)
L002_00000098:
; H002+$00000098: 4400  neg.b d0
        neg.b d0
L002_0000009A:
; H002+$0000009A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L002_0000009C:
; H002+$0000009C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L002_0000009E:
; H002+$0000009E: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Info [partial]
; Purpose: Adapter to dos.library/Info; wraps the library call.
;   - Calls dos.library/Info (LVO -114).
; Direct callers: H001+$00A2, H066+$148C
; --------------------------------------------------------------------------
L002_000000A0:
; H002+$000000A0: 222f0008  move.l $8(a7), d1
        move.l $8(a7), d1
L002_000000A4:
; H002+$000000A4: 242f0004  move.l $4(a7), d2
        move.l $4(a7), d2
L002_000000A8:
; H002+$000000A8: 2c7aff56  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_000000AC:
; H002+$000000AC: 4eaeff8e  jsr -$72(a6) ; dos.library/Info
        jsr LVO_dos_Info(a6)
L002_000000B0:
; H002+$000000B0: 4400  neg.b d0
        neg.b d0
L002_000000B2:
; H002+$000000B2: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L002_000000B4:
; H002+$000000B4: 508f  addq.l #$8, a7
        addq.l #$8, a7
L002_000000B6:
; H002+$000000B6: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H002+$000000B8..$000000C0; code/data not fully classified.
        dc.w $2C7A,$FF46,$4EEE,$FFCA
; --------------------------------------------------------------------------
; ROUTINE: wrapper_IoErr [partial]
; Purpose: Adapter to dos.library/IoErr; wraps the library call.
;   - Calls dos.library/IoErr (LVO -132).
; Direct callers: H074+$0118, H074+$0086
; --------------------------------------------------------------------------
L002_000000C0:
; H002+$000000C0: 2c7aff3e  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_000000C4:
; H002+$000000C4: 4eeeff7c  jmp -$84(a6) ; dos.library/IoErr
        jmp LVO_dos_IoErr(a6)
; Preserved bytes H002+$000000C8..$000000DC; code/data not fully classified.
        dc.w $222F,$0004,$2C7A,$FF32,$4EAE,$FF28,$4400,$205F
        dc.w $588F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Lock [partial]
; Purpose: Adapter to dos.library/Lock; wraps the library call.
;   - Calls dos.library/Lock (LVO -84).
; Direct callers: H001+$007C, H028+$0308, H066+$147A, H066+$0430, H028+$03AA, H066+$0A62
; --------------------------------------------------------------------------
L002_000000DC:
; H002+$000000DC: 222f0008  move.l $8(a7), d1
        move.l $8(a7), d1
L002_000000E0:
; H002+$000000E0: 242f0004  move.l $4(a7), d2
        move.l $4(a7), d2
L002_000000E4:
; H002+$000000E4: 2c7aff1a  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_000000E8:
; H002+$000000E8: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L002_000000EC:
; H002+$000000EC: 508f  addq.l #$8, a7
        addq.l #$8, a7
L002_000000EE:
; H002+$000000EE: 4eeeffac  jmp -$54(a6) ; dos.library/Lock
        jmp LVO_dos_Lock(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Open [partial]
; Purpose: Adapter to dos.library/Open; wraps the library call.
;   - Calls dos.library/Open (LVO -30).
; Direct callers: H006+$080E, H029+$024A, H028+$05CC, H043+$11B2, H043+$1204, H066+$050C and 5 more
; --------------------------------------------------------------------------
L002_000000F2:
; H002+$000000F2: 222f0008  move.l $8(a7), d1
        move.l $8(a7), d1
L002_000000F6:
; H002+$000000F6: 242f0004  move.l $4(a7), d2
        move.l $4(a7), d2
L002_000000FA:
; H002+$000000FA: 2c7aff04  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_000000FE:
; H002+$000000FE: 2f570008  move.l (a7), $8(a7)
        move.l (a7), $8(a7)
L002_00000102:
; H002+$00000102: 508f  addq.l #$8, a7
        addq.l #$8, a7
L002_00000104:
; H002+$00000104: 4eeeffe2  jmp -$1e(a6) ; dos.library/Open
        jmp LVO_dos_Open(a6)
; Preserved bytes H002+$00000108..$00000122; code/data not fully classified.
        dc.w $2C7A,$FEF6,$4EEE,$FFC4,$222F,$0004,$2C7A,$FEEA
        dc.w $2F57,$0004,$588F,$4EEE,$FF2E
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Read [partial]
; Purpose: Adapter to dos.library/Read; wraps the library call.
;   - Calls dos.library/Read (LVO -42).
; Direct callers: H006+$0866, H006+$08A6, H006+$08E6, H043+$02E2, H029+$02B0, H098+$00B4 and 32 more
; --------------------------------------------------------------------------
L002_00000122:
; H002+$00000122: 222f000c  move.l $c(a7), d1
        move.l $c(a7), d1
L002_00000126:
; H002+$00000126: 242f0008  move.l $8(a7), d2
        move.l $8(a7), d2
L002_0000012A:
; H002+$0000012A: 262f0004  move.l $4(a7), d3
        move.l $4(a7), d3
L002_0000012E:
; H002+$0000012E: 2c7afed0  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_00000132:
; H002+$00000132: 2f57000c  move.l (a7), $c(a7)
        move.l (a7), $c(a7)
L002_00000136:
; H002+$00000136: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L002_0000013A:
; H002+$0000013A: 4eeeffd6  jmp -$2a(a6) ; dos.library/Read
        jmp LVO_dos_Read(a6)
; Preserved bytes H002+$0000013E..$00000156; code/data not fully classified.
        dc.w $222F,$0008,$242F,$0004,$2C7A,$FEB8,$4EAE,$FFB2
        dc.w $4400,$205F,$508F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Seek [partial]
; Purpose: Adapter to dos.library/Seek; wraps the library call.
;   - Calls dos.library/Seek (LVO -66).
; Direct callers: H006+$0830, H029+$0268, H029+$027E, H098+$030E, H028+$0FA2, H043+$1238 and 9 more
; --------------------------------------------------------------------------
L002_00000156:
; H002+$00000156: 222f000c  move.l $c(a7), d1
        move.l $c(a7), d1
L002_0000015A:
; H002+$0000015A: 242f0008  move.l $8(a7), d2
        move.l $8(a7), d2
L002_0000015E:
; H002+$0000015E: 262f0004  move.l $4(a7), d3
        move.l $4(a7), d3
L002_00000162:
; H002+$00000162: 2c7afe9c  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_00000166:
; H002+$00000166: 2f57000c  move.l (a7), $c(a7)
        move.l (a7), $c(a7)
L002_0000016A:
; H002+$0000016A: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L002_0000016E:
; H002+$0000016E: 4eeeffbe  jmp -$42(a6) ; dos.library/Seek
        jmp LVO_dos_Seek(a6)
; Preserved bytes H002+$00000172..$000001A2; code/data not fully classified.
        dc.w $222F,$0008,$242F,$0004,$2C7A,$FE84,$4EAE,$FF4C
        dc.w $4400,$205F,$508F,$4ED0,$222F,$0008,$242F,$0004
        dc.w $2C7A,$FE6C,$4EAE,$FF46,$4400,$205F,$508F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_UnLock [partial]
; Purpose: Adapter to dos.library/UnLock; wraps the library call.
;   - Calls dos.library/UnLock (LVO -90).
; Direct callers: H001+$00E8, H028+$031E, H066+$14C4, H028+$03CA, H066+$0B7A, H066+$075E
; --------------------------------------------------------------------------
L002_000001A2:
; H002+$000001A2: 222f0004  move.l $4(a7), d1
        move.l $4(a7), d1
L002_000001A6:
; H002+$000001A6: 2c7afe58  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_000001AA:
; H002+$000001AA: 2f570004  move.l (a7), $4(a7)
        move.l (a7), $4(a7)
L002_000001AE:
; H002+$000001AE: 588f  addq.l #$4, a7
        addq.l #$4, a7
L002_000001B0:
; H002+$000001B0: 4eeeffa6  jmp -$5a(a6) ; dos.library/UnLock
        jmp LVO_dos_UnLock(a6)
; Preserved bytes H002+$000001B4..$000001CC; code/data not fully classified.
        dc.w $222F,$0008,$242F,$0004,$2C7A,$FE42,$4EAE,$FF34
        dc.w $4400,$205F,$508F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Write [partial]
; Purpose: Adapter to dos.library/Write; wraps the library call.
;   - Calls dos.library/Write (LVO -48).
; Direct callers: H098+$0108, H075+$0172, H075+$0112, H074+$0068, H066+$32EA, H066+$3306 and 12 more
; --------------------------------------------------------------------------
L002_000001CC:
; H002+$000001CC: 222f000c  move.l $c(a7), d1
        move.l $c(a7), d1
L002_000001D0:
; H002+$000001D0: 242f0008  move.l $8(a7), d2
        move.l $8(a7), d2
L002_000001D4:
; H002+$000001D4: 262f0004  move.l $4(a7), d3
        move.l $4(a7), d3
L002_000001D8:
; H002+$000001D8: 2c7afe26  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_000001DC:
; H002+$000001DC: 2f57000c  move.l (a7), $c(a7)
        move.l (a7), $c(a7)
L002_000001E0:
; H002+$000001E0: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L002_000001E4:
; H002+$000001E4: 4eeeffd0  jmp -$30(a6) ; dos.library/Write
        jmp LVO_dos_Write(a6)
; --------------------------------------------------------------------------
; ROUTINE: wrapper_Execute [partial]
; Purpose: Adapter to dos.library/Execute; wraps the library call.
;   - Calls dos.library/Execute (LVO -222).
; Direct callers: H006+$0216, H006+$022E, H006+$0246, H010+$02F2, H010+$030A, H010+$0322
; --------------------------------------------------------------------------
L002_000001E8:
; H002+$000001E8: 222f000c  move.l $c(a7), d1
        move.l $c(a7), d1
L002_000001EC:
; H002+$000001EC: 242f0008  move.l $8(a7), d2
        move.l $8(a7), d2
L002_000001F0:
; H002+$000001F0: 262f0004  move.l $4(a7), d3
        move.l $4(a7), d3
L002_000001F4:
; H002+$000001F4: 2c7afe0a  movea.l $0(pc), a6
        movea.l H002+$0(pc), a6
L002_000001F8:
; H002+$000001F8: 4eaeff22  jsr -$de(a6) ; dos.library/Execute
        jsr LVO_dos_Execute(a6)
L002_000001FC:
; H002+$000001FC: 4400  neg.b d0
        neg.b d0
L002_000001FE:
; H002+$000001FE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L002_00000200:
; H002+$00000200: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L002_00000204:
; H002+$00000204: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H002+$00000206..$0000023C; code/data not fully classified.
        dc.w $222F,$0004,$2C7A,$FDF4,$2F57,$0004,$588F,$4EEE
        dc.w $FF6A,$222F,$0004,$2C7A,$FDE2,$2F57,$0004,$588F
        dc.w $4EEE,$FF64,$222F,$0004,$2C7A,$FDD0,$2F57,$0004
        dc.w $588F,$4EEE,$FF40
; End H002: $23C bytes
