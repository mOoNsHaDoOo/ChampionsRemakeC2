; ============================================================================
; MODULE GUIDE H043
; audio.device subsystem and sound requests.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Audio.device: opening of the device, IOAudio requests, channel queues, vertical callback and software interrupt. The heavy work is left to the soft interrupt H094+$0016.
; --------------------------------------------------------------------------
; H043: 6680 original bytes; all offsets are section-relative.
        section H043,code
H043:
; Preserved bytes H043+$00000000..$000001BC; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$6175,$6469,$6F2E,$6465,$7669,$6365,$0046
        dc.w $4F52,$4D00,$4E41,$4D45,$0053,$4D55,$5300,$5348
        dc.w $4452,$0049,$4E53,$3100,$494E,$5354,$0054,$5241
        dc.w $4B00,$3853,$5658,$0056,$4844,$5200,$424F,$4459
        dc.w $0041,$5441,$4B00,$454E,$564C,$0053,$4F55,$4E44
        dc.w $2F00,$7065,$7269,$6F64,$5461,$626C,$6500,$496E
        dc.w $7365,$7274,$2044,$6973,$6B20,$4F6E,$6520,$696E
        dc.w $2000,$5054,$4348,$0056,$4C55,$4D00,$5341,$4D50
        dc.w $0073,$6F75,$6E64,$4461,$7461,$0053,$6F75,$6E64
        dc.w $5820,$6973,$2071,$7569,$7469,$6E67,$2C20,$6578
        dc.w $6974,$2063,$6F64,$6520,$3D00,$6361,$7374,$0063
        dc.w $6173,$7432,$0063,$6173,$7433,$0063,$6173,$7434
        dc.w $0073,$7769,$7368,$0073,$7065,$6C6C,$0064,$6561
        dc.w $6430,$0064,$6561,$6431,$0064,$6561,$6400,$6465
        dc.w $6164,$3300,$6465,$6164,$3400,$7768,$6973,$6C00
        dc.w $6869,$7400,$6C69,$6768,$7400,$7377,$6973,$6800
        dc.w $7061,$6400,$6269,$6750,$6164,$0066,$6972,$6562
        dc.w $0061,$7272,$6F77,$0074,$7572,$6E00,$6761,$7465
        dc.w $006B,$7279,$6E6E,$0000
        dc.l H043+$00000092
; --------------------------------------------------------------------------
; ROUTINE: module_init_H043 [partial]
; Purpose: Entry of the audio.device subsystem and sound requests module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H043+$19FC.
; Direct callers: H000+$0144
; --------------------------------------------------------------------------
L043_000001BC:
; H043+$000001BC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000001BE:
; H043+$000001BE: 287afff8  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000001C2:
; H043+$000001C2: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_000001C6:
; H043+$000001C6: 60001834  bra.w $19fc
        bra.w H043+$19FC
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H043_165A [partial]
; Purpose: Trampoline to H043+$165A; the actual body is there.
;   - Jumps to the actual body at H043+$165A.
;   - Calls H020+$085A.
;   - Calls H020+$08C2.
;   - Calls H020+$082E.
;   - Calls H010+$0332.
; Direct callers: H043+$0644, H043+$06D2, H043+$023E, H043+$0AAC, H043+$0200
; --------------------------------------------------------------------------
L043_000001CA:
; H043+$000001CA: 6000148e  bra.w $165a
        bra.w H043+$165A
; Preserved bytes H043+$000001CE..$000001D2; code/data not fully classified.
        dc.w $6000,$02E6
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H043_113E [partial]
; Purpose: Trampoline to H043+$113E; the actual body is there.
;   - Jumps to the actual body at H043+$113E.
;   - Calls H026+$003A.
;   - Calls H026+$0188.
;   - Calls H026+$01E0.
;   - Calls H002+$00F2.
;   - Calls H002+$0156.
;   - Calls H026+$0088.
; Direct callers: H043+$0AD6, H043+$0E16, H043+$0E7E, H043+$0EE8
; --------------------------------------------------------------------------
L043_000001D2:
; H043+$000001D2: 60000f6a  bra.w $113e
        bra.w H043+$113E
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_000001D6 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H003+$0068.
;   - Calls H003+$0068.
; Direct callers: H043+$0C9A
; --------------------------------------------------------------------------
L043_000001D6:
; H043+$000001D6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000001D8:
; H043+$000001D8: 287affde  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000001DC:
; H043+$000001DC: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L043_000001E0:
; H043+$000001E0: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L043_000001E4:
; H043+$000001E4: 2f3c00000002  move.l #$2, -(a7)
        move.l #MEMF_CHIP, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L043_000001EA:
; H043+$000001EA: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L043_000001F0:
; H043+$000001F0: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L043_000001F4:
; H043+$000001F4: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L043_000001F8:
; H043+$000001F8: 66000008  bne.w $202
        bne.w H043+$202
L043_000001FC:
; H043+$000001FC: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L043_00000200:
; H043+$00000200: 61c8  bsr.b $1ca
        bsr.b H043+$1CA
L043_00000202:
; H043+$00000202: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L043_00000206:
; H043+$00000206: 60000002  bra.w $20a
        bra.w H043+$20A
L043_0000020A:
; H043+$0000020A: 4e5d  unlk a5
        unlk a5
L043_0000020C:
; H043+$0000020C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_0000020E:
; H043+$0000020E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000210:
; H043+$00000210: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_00000212:
; H043+$00000212: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000214 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H003+$0068.
;   - Calls H003+$0068.
; Direct callers: H043+$05B2, H043+$05CA, H043+$0312, H043+$1388, H043+$0998, H043+$14FC and 5 more
; --------------------------------------------------------------------------
L043_00000214:
; H043+$00000214: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000216:
; H043+$00000216: 287affa0  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_0000021A:
; H043+$0000021A: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L043_0000021E:
; H043+$0000021E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L043_00000222:
; H043+$00000222: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L043_00000228:
; H043+$00000228: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L043_0000022E:
; H043+$0000022E: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L043_00000232:
; H043+$00000232: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L043_00000236:
; H043+$00000236: 66000008  bne.w $240
        bne.w H043+$240
L043_0000023A:
; H043+$0000023A: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L043_0000023E:
; H043+$0000023E: 618a  bsr.b $1ca
        bsr.b H043+$1CA
L043_00000240:
; H043+$00000240: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L043_00000244:
; H043+$00000244: 60000002  bra.w $248
        bra.w H043+$248
L043_00000248:
; H043+$00000248: 4e5d  unlk a5
        unlk a5
L043_0000024A:
; H043+$0000024A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_0000024C:
; H043+$0000024C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_0000024E:
; H043+$0000024E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_00000250:
; H043+$00000250: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000252 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H003+$00F6.
;   - Calls H003+$00F6.
; Direct callers: H043+$08A8, H043+$08B6, H043+$0376, H043+$0560, H043+$056E, H043+$04A8 and 6 more
; --------------------------------------------------------------------------
L043_00000252:
; H043+$00000252: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000254:
; H043+$00000254: 287aff62  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000258:
; H043+$00000258: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_0000025C:
; H043+$0000025C: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L043_00000260:
; H043+$00000260: 4a93  tst.l (a3)
        tst.l (a3)
L043_00000262:
; H043+$00000262: 67000018  beq.w $27c
        beq.w H043+$27C
L043_00000266:
; H043+$00000266: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L043_0000026A:
; H043+$0000026A: 2f13  move.l (a3), -(a7)
        move.l (a3), -(a7)
L043_0000026C:
; H043+$0000026C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L043_00000270:
; H043+$00000270: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L043_00000276:
; H043+$00000276: 266d0010  movea.l $10(a5), a3
        movea.l $10(a5), a3
L043_0000027A:
; H043+$0000027A: 4293  clr.l (a3)
        clr.l (a3)
L043_0000027C:
; H043+$0000027C: 4e5d  unlk a5
        unlk a5
L043_0000027E:
; H043+$0000027E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000280:
; H043+$00000280: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000282:
; H043+$00000282: 508f  addq.l #$8, a7
        addq.l #$8, a7
L043_00000284:
; H043+$00000284: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000286 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H002+$0156.
;   - Calls H002+$0156.
; Direct callers: H043+$125E, H043+$137A, H043+$09D8, H043+$0BFC, H043+$0CEE, H043+$0B98 and 2 more
; --------------------------------------------------------------------------
L043_00000286:
; H043+$00000286: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000288:
; H043+$00000288: 287aff2e  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_0000028C:
; H043+$0000028C: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_00000290:
; H043+$00000290: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_00000294:
; H043+$00000294: 66000024  bne.w $2ba
        bne.w H043+$2BA
L043_00000298:
; H043+$00000298: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_0000029C:
; H043+$0000029C: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L043_000002A0:
; H043+$000002A0: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H002+$0156 (wrapper_Seek)
L043_000002A2:
; H043+$000002A2: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L043_000002A8:
; H043+$000002A8: 2400  move.l d0, d2
        move.l d0, d2
L043_000002AA:
; H043+$000002AA: 0c82ffffffff  cmpi.l #$ffffffff, d2
        cmpi.l #$ffffffff, d2
L043_000002B0:
; H043+$000002B0: 66000008  bne.w $2ba
        bne.w H043+$2BA
L043_000002B4:
; H043+$000002B4: 197c0001fffc  move.b #$1, -$4(a4)
        move.b #$1, -$4(a4)
L043_000002BA:
; H043+$000002BA: 4e5d  unlk a5
        unlk a5
L043_000002BC:
; H043+$000002BC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_000002BE:
; H043+$000002BE: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_000002C0:
; H043+$000002C0: 508f  addq.l #$8, a7
        addq.l #$8, a7
L043_000002C2:
; H043+$000002C2: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_000002C4 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H002+$0122.
;   - Calls H002+$0122.
; Direct callers: H043+$065A, H043+$1282, H043+$12BA, H043+$12D0, H043+$12FA, H043+$1352 and 17 more
; --------------------------------------------------------------------------
L043_000002C4:
; H043+$000002C4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000002C6:
; H043+$000002C6: 287afef0  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000002CA:
; H043+$000002CA: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_000002CE:
; H043+$000002CE: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_000002D2:
; H043+$000002D2: 66000024  bne.w $2f8
        bne.w H043+$2F8
L043_000002D6:
; H043+$000002D6: 2f2d0014  move.l $14(a5), -(a7)
        move.l $14(a5), -(a7)
L043_000002DA:
; H043+$000002DA: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_000002DE:
; H043+$000002DE: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H002+$0122 (wrapper_Read)
L043_000002E2:
; H043+$000002E2: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L043_000002E8:
; H043+$000002E8: 2400  move.l d0, d2
        move.l d0, d2
L043_000002EA:
; H043+$000002EA: b4ad000c  cmp.l $c(a5), d2
        cmp.l $c(a5), d2
L043_000002EE:
; H043+$000002EE: 67000008  beq.w $2f8
        beq.w H043+$2F8
L043_000002F2:
; H043+$000002F2: 197c0001fffc  move.b #$1, -$4(a4)
        move.b #$1, -$4(a4)
L043_000002F8:
; H043+$000002F8: 4e5d  unlk a5
        unlk a5
L043_000002FA:
; H043+$000002FA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_000002FC:
; H043+$000002FC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_000002FE:
; H043+$000002FE: 4fef000c  lea.l $c(a7), a7
        lea.l $c(a7), a7
L043_00000302:
; H043+$00000302: 4ed0  jmp (a0)
        jmp (a0)
; FUNCTION: allocate_message_port
FN_allocate_message_port:
L043_00000304:
; H043+$00000304: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000306:
; H043+$00000306: 287afeb0  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_0000030A:
; H043+$0000030A: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L043_0000030E:
; H043+$0000030E: 7422  moveq #$22, d2
        moveq #34, d2
L043_00000310:
; H043+$00000310: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000312:
; H043+$00000312: 6100ff00  bsr.w $214
        bsr.w H043+$214
L043_00000316:
; H043+$00000316: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L043_0000031A:
; H043+$0000031A: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_0000031E:
; H043+$0000031E: 177c00040020  move.b #$4, $20(a3)
        move.b #$4, $20(a3)
L043_00000324:
; H043+$00000324: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_00000328:
; H043+$00000328: 486b0014  pea.l $14(a3)
        pea.l $14(a3)
; -> H092+$007A (sub_H092_0000007A)
L043_0000032C:
; H043+$0000032C: 4eb90000007a  jsr $7a.l
        jsr (H092+$7A).l
L043_00000332:
; H043+$00000332: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L043_00000336:
; H043+$00000336: 60000002  bra.w $33a
        bra.w H043+$33A
L043_0000033A:
; H043+$0000033A: 4e5d  unlk a5
        unlk a5
L043_0000033C:
; H043+$0000033C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_0000033E:
; H043+$0000033E: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000340 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$0888, H043+$0894
; --------------------------------------------------------------------------
L043_00000340:
; H043+$00000340: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000342:
; H043+$00000342: 287afe74  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000346:
; H043+$00000346: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_0000034A:
; H043+$0000034A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_0000034E:
; H043+$0000034E: 4a93  tst.l (a3)
        tst.l (a3)
L043_00000350:
; H043+$00000350: 6700002e  beq.w $380
        beq.w H043+$380
L043_00000354:
; H043+$00000354: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L043_00000358:
; H043+$00000358: 2652  movea.l (a2), a3
        movea.l (a2), a3
L043_0000035A:
; H043+$0000035A: 177c00ff0008  move.b #$ff, $8(a3)
        move.b #$ff, $8(a3)
L043_00000360:
; H043+$00000360: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L043_00000364:
; H043+$00000364: 2652  movea.l (a2), a3
        movea.l (a2), a3
L043_00000366:
; H043+$00000366: 277cffffffff0014  move.l #$ffffffff, $14(a3)
        move.l #$ffffffff, $14(a3)
L043_0000036E:
; H043+$0000036E: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L043_00000372:
; H043+$00000372: 7422  moveq #$22, d2
        moveq #34, d2
L043_00000374:
; H043+$00000374: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000376:
; H043+$00000376: 6100feda  bsr.w $252
        bsr.w H043+$252
L043_0000037A:
; H043+$0000037A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_0000037E:
; H043+$0000037E: 4293  clr.l (a3)
        clr.l (a3)
L043_00000380:
; H043+$00000380: 4e5d  unlk a5
        unlk a5
L043_00000382:
; H043+$00000382: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000384:
; H043+$00000384: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000386:
; H043+$00000386: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_00000388:
; H043+$00000388: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_0000038A [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$0400, H043+$0534
; --------------------------------------------------------------------------
L043_0000038A:
; H043+$0000038A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_0000038C:
; H043+$0000038C: 287afe2a  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000390:
; H043+$00000390: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_00000394:
; H043+$00000394: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000398:
; H043+$00000398: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
L043_0000039C:
; H043+$0000039C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_000003A0:
; H043+$000003A0: 242b0012  move.l $12(a3), d2
        move.l $12(a3), d2
L043_000003A4:
; H043+$000003A4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_000003A8:
; H043+$000003A8: 282b000a  move.l $a(a3), d4
        move.l $a(a3), d4
L043_000003AC:
; H043+$000003AC: 9484  sub.l d4, d2
        sub.l d4, d2
L043_000003AE:
; H043+$000003AE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_000003B0:
; H043+$000003B0: 6100fea0  bsr.w $252
        bsr.w H043+$252
L043_000003B4:
; H043+$000003B4: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
L043_000003B8:
; H043+$000003B8: 7416  moveq #$16, d2
        moveq #22, d2
L043_000003BA:
; H043+$000003BA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_000003BC:
; H043+$000003BC: 6100fe94  bsr.w $252
        bsr.w H043+$252
L043_000003C0:
; H043+$000003C0: 4e5d  unlk a5
        unlk a5
L043_000003C2:
; H043+$000003C2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_000003C4:
; H043+$000003C4: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_000003C6:
; H043+$000003C6: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_000003C8:
; H043+$000003C8: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_000003CA [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$04E2
; --------------------------------------------------------------------------
L043_000003CA:
; H043+$000003CA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000003CC:
; H043+$000003CC: 287afdea  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000003D0:
; H043+$000003D0: 4e55fffe  link.w a5, #$fffe
        link.w a5, #$fffe
L043_000003D4:
; H043+$000003D4: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L043_000003D8:
; H043+$000003D8: 6700003e  beq.w $418
        beq.w H043+$418
L043_000003DC:
; H043+$000003DC: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L043_000003E0:
; H043+$000003E0: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L043_000003E4:
; H043+$000003E4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_000003E8:
; H043+$000003E8: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L043_000003EA:
; H043+$000003EA: 6c00001c  bge.w $408
        bge.w H043+$408
L043_000003EE:
; H043+$000003EE: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L043_000003F2:
; H043+$000003F2: e542  asl.w #$2, d2
        asl.w #$2, d2
L043_000003F4:
; H043+$000003F4: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_000003F8:
; H043+$000003F8: 47eb0004  lea.l $4(a3), a3
        lea.l $4(a3), a3
L043_000003FC:
; H043+$000003FC: 2f332000  move.l (a3, d2.w), -(a7)
        move.l (a3, d2.w), -(a7)
L043_00000400:
; H043+$00000400: 6188  bsr.b $38a
        bsr.b H043+$38A
L043_00000402:
; H043+$00000402: 526dfffe  addq.w #$1, -$2(a5)
        addq.w #$1, -$2(a5)
L043_00000406:
; H043+$00000406: 60d8  bra.b $3e0
        bra.b H043+$3E0
L043_00000408:
; H043+$00000408: 426dfffe  clr.w -$2(a5)
        clr.w -$2(a5)
L043_0000040C:
; H043+$0000040C: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
L043_00000410:
; H043+$00000410: 744a  moveq #$4a, d2
        moveq #74, d2
L043_00000412:
; H043+$00000412: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000414:
; H043+$00000414: 6100fe3c  bsr.w $252
        bsr.w H043+$252
L043_00000418:
; H043+$00000418: 4e5d  unlk a5
        unlk a5
L043_0000041A:
; H043+$0000041A: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_0000041C:
; H043+$0000041C: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_0000041E:
; H043+$0000041E: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_00000420:
; H043+$00000420: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000422 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$0518
; --------------------------------------------------------------------------
L043_00000422:
; H043+$00000422: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000424:
; H043+$00000424: 287afd92  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000428:
; H043+$00000428: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_0000042C:
; H043+$0000042C: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L043_00000430:
; H043+$00000430: 67000022  beq.w $454
        beq.w H043+$454
L043_00000434:
; H043+$00000434: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000438:
; H043+$00000438: 486b0018  pea.l $18(a3)
        pea.l $18(a3)
L043_0000043C:
; H043+$0000043C: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000440:
; H043+$00000440: 2f2b0014  move.l $14(a3), -(a7)
        move.l $14(a3), -(a7)
L043_00000444:
; H043+$00000444: 6100fe0c  bsr.w $252
        bsr.w H043+$252
L043_00000448:
; H043+$00000448: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
L043_0000044C:
; H043+$0000044C: 741c  moveq #$1c, d2
        moveq #28, d2
L043_0000044E:
; H043+$0000044E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000450:
; H043+$00000450: 6100fe00  bsr.w $252
        bsr.w H043+$252
L043_00000454:
; H043+$00000454: 4e5d  unlk a5
        unlk a5
L043_00000456:
; H043+$00000456: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000458:
; H043+$00000458: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_0000045A:
; H043+$0000045A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_0000045C:
; H043+$0000045C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_0000045E [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$0550
; --------------------------------------------------------------------------
L043_0000045E:
; H043+$0000045E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000460:
; H043+$00000460: 287afd56  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000464:
; H043+$00000464: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_00000468:
; H043+$00000468: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L043_0000046C:
; H043+$0000046C: 67000016  beq.w $484
        beq.w H043+$484
L043_00000470:
; H043+$00000470: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
L043_00000474:
; H043+$00000474: 7400  moveq #$0, d2
        moveq #0, d2
L043_00000476:
; H043+$00000476: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_0000047A:
; H043+$0000047A: 3413  move.w (a3), d2
        move.w (a3), d2
L043_0000047C:
; H043+$0000047C: 5482  addq.l #$2, d2
        addq.l #$2, d2
L043_0000047E:
; H043+$0000047E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000480:
; H043+$00000480: 6100fdd0  bsr.w $252
        bsr.w H043+$252
L043_00000484:
; H043+$00000484: 4e5d  unlk a5
        unlk a5
L043_00000486:
; H043+$00000486: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000488:
; H043+$00000488: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_0000048A:
; H043+$0000048A: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_0000048C:
; H043+$0000048C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_0000048E [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$04FE
; --------------------------------------------------------------------------
L043_0000048E:
; H043+$0000048E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000490:
; H043+$00000490: 287afd26  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000494:
; H043+$00000494: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_00000498:
; H043+$00000498: 4aad000c  tst.l $c(a5)
        tst.l $c(a5)
L043_0000049C:
; H043+$0000049C: 6700000e  beq.w $4ac
        beq.w H043+$4AC
L043_000004A0:
; H043+$000004A0: 486d000c  pea.l $c(a5)
        pea.l $c(a5)
L043_000004A4:
; H043+$000004A4: 7418  moveq #$18, d2
        moveq #24, d2
L043_000004A6:
; H043+$000004A6: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_000004A8:
; H043+$000004A8: 6100fda8  bsr.w $252
        bsr.w H043+$252
L043_000004AC:
; H043+$000004AC: 4e5d  unlk a5
        unlk a5
L043_000004AE:
; H043+$000004AE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_000004B0:
; H043+$000004B0: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_000004B2:
; H043+$000004B2: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_000004B4:
; H043+$000004B4: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_000004B6 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$081A, H043+$0834, H043+$14DC
; --------------------------------------------------------------------------
L043_000004B6:
; H043+$000004B6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000004B8:
; H043+$000004B8: 287afcfe  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000004BC:
; H043+$000004BC: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
L043_000004C0:
; H043+$000004C0: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L043_000004C4:
; H043+$000004C4: 2652  movea.l (a2), a3
        movea.l (a2), a3
L043_000004C6:
; H043+$000004C6: 2b53fffc  move.l (a3), -$4(a5)
        move.l (a3), -$4(a5)
L043_000004CA:
; H043+$000004CA: 246d000c  movea.l $c(a5), a2
        movea.l $c(a5), a2
L043_000004CE:
; H043+$000004CE: 2652  movea.l (a2), a3
        movea.l (a2), a3
L043_000004D0:
; H043+$000004D0: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_000004D4:
; H043+$000004D4: 08020000  btst.b #$0, d2
        btst #$0, d2
L043_000004D8:
; H043+$000004D8: 67000012  beq.w $4ec
        beq.w H043+$4EC
L043_000004DC:
; H043+$000004DC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000004DE:
; H043+$000004DE: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L043_000004E2:
; H043+$000004E2: 6100fee6  bsr.w $3ca
        bsr.w H043+$3CA
L043_000004E6:
; H043+$000004E6: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_000004E8:
; H043+$000004E8: 6000006c  bra.w $556
        bra.w H043+$556
L043_000004EC:
; H043+$000004EC: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_000004F0:
; H043+$000004F0: 08020001  btst.b #$1, d2
        btst #$1, d2
L043_000004F4:
; H043+$000004F4: 67000010  beq.w $506
        beq.w H043+$506
L043_000004F8:
; H043+$000004F8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000004FA:
; H043+$000004FA: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L043_000004FE:
; H043+$000004FE: 618e  bsr.b $48e
        bsr.b H043+$48E
L043_00000500:
; H043+$00000500: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_00000502:
; H043+$00000502: 60000052  bra.w $556
        bra.w H043+$556
L043_00000506:
; H043+$00000506: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_0000050A:
; H043+$0000050A: 08020002  btst.b #$2, d2
        btst #$2, d2
L043_0000050E:
; H043+$0000050E: 67000012  beq.w $522
        beq.w H043+$522
L043_00000512:
; H043+$00000512: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000514:
; H043+$00000514: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L043_00000518:
; H043+$00000518: 6100ff08  bsr.w $422
        bsr.w H043+$422
L043_0000051C:
; H043+$0000051C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_0000051E:
; H043+$0000051E: 60000036  bra.w $556
        bra.w H043+$556
L043_00000522:
; H043+$00000522: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_00000526:
; H043+$00000526: 08020005  btst.b #$5, d2
        btst #$5, d2
L043_0000052A:
; H043+$0000052A: 67000012  beq.w $53e
        beq.w H043+$53E
L043_0000052E:
; H043+$0000052E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000530:
; H043+$00000530: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L043_00000534:
; H043+$00000534: 6100fe54  bsr.w $38a
        bsr.w H043+$38A
L043_00000538:
; H043+$00000538: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_0000053A:
; H043+$0000053A: 6000001a  bra.w $556
        bra.w H043+$556
L043_0000053E:
; H043+$0000053E: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_00000542:
; H043+$00000542: 08020006  btst.b #$6, d2
        btst #$6, d2
L043_00000546:
; H043+$00000546: 6700000e  beq.w $556
        beq.w H043+$556
L043_0000054A:
; H043+$0000054A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_0000054C:
; H043+$0000054C: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L043_00000550:
; H043+$00000550: 6100ff0c  bsr.w $45e
        bsr.w H043+$45E
L043_00000554:
; H043+$00000554: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_00000556:
; H043+$00000556: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000558:
; H043+$00000558: 486b000a  pea.l $a(a3)
        pea.l $a(a3)
L043_0000055C:
; H043+$0000055C: 7428  moveq #$28, d2
        moveq #40, d2
L043_0000055E:
; H043+$0000055E: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000560:
; H043+$00000560: 6100fcf0  bsr.w $252
        bsr.w H043+$252
L043_00000564:
; H043+$00000564: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_00000566:
; H043+$00000566: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L043_0000056A:
; H043+$0000056A: 7410  moveq #$10, d2
        moveq #16, d2
L043_0000056C:
; H043+$0000056C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_0000056E:
; H043+$0000056E: 6100fce2  bsr.w $252
        bsr.w H043+$252
L043_00000572:
; H043+$00000572: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000576:
; H043+$00000576: 26adfffc  move.l -$4(a5), (a3)
        move.l -$4(a5), (a3)
L043_0000057A:
; H043+$0000057A: 4e5d  unlk a5
        unlk a5
L043_0000057C:
; H043+$0000057C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_0000057E:
; H043+$0000057E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000580:
; H043+$00000580: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_00000582:
; H043+$00000582: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Audio_Initialize [verified]
; Purpose: Prepares the sound subsystem and the callbacks.
;   - Loads the period table and the sound state.
;   - Opens audio.device and prepares the IOAudio requests.
;   - Registers the vertical interrupt and the software node called with Cause.
; Direct callers: H007+$09EE, H012+$07D2, H012+$080E, H012+$0836, H012+$0878, H012+$08B4, H012+$08DC, H012+$0904, H012+$093C, H012+$0964 ...
; --------------------------------------------------------------------------
L043_00000584:
; H043+$00000584: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000586:
; H043+$00000586: 287afc30  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_0000058A:
; H043+$0000058A: 4e55ffae  link.w a5, #$ffae
        link.w a5, #$ffae
L043_0000058E:
; H043+$0000058E: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00000592:
; H043+$00000592: 486cffa8  pea.l -$58(a4)
        pea.l -$58(a4)
L043_00000596:
; H043+$00000596: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L043_0000059A:
; H043+$0000059A: 486c0049  pea.l $49(a4)
        pea.l $49(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000059E:
; H043+$0000059E: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000005A4:
; H043+$000005A4: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L043_000005A8:
; H043+$000005A8: 66000246  bne.w $7f0
        bne.w H043+$7F0
L043_000005AC:
; H043+$000005AC: 2f3c000006b0  move.l #$6b0, -(a7)
        move.l #$6b0, -(a7)
L043_000005B2:
; H043+$000005B2: 6100fc60  bsr.w $214
        bsr.w H043+$214
L043_000005B6:
; H043+$000005B6: 2940ff76  move.l d0, -$8a(a4)
        move.l d0, -$8a(a4)
L043_000005BA:
; H043+$000005BA: 7401  moveq #$1, d2
        moveq #1, d2
L043_000005BC:
; H043+$000005BC: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000005C0:
; H043+$000005C0: 27420004  move.l d2, $4(a3)
        move.l d2, $4(a3)
L043_000005C4:
; H043+$000005C4: 2f3c00000280  move.l #$280, -(a7)
        move.l #$280, -(a7)
L043_000005CA:
; H043+$000005CA: 6100fc48  bsr.w $214
        bsr.w H043+$214
L043_000005CE:
; H043+$000005CE: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000005D2:
; H043+$000005D2: 274006a8  move.l d0, $6a8(a3)
        move.l d0, $6a8(a3)
L043_000005D6:
; H043+$000005D6: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000005DA:
; H043+$000005DA: 242b06a8  move.l $6a8(a3), d2
        move.l $6a8(a3), d2
L043_000005DE:
; H043+$000005DE: 068200000200  addi.l #$200, d2
        addi.l #$200, d2
L043_000005E4:
; H043+$000005E4: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000005E8:
; H043+$000005E8: 274206ac  move.l d2, $6ac(a3)
        move.l d2, $6ac(a3)
L043_000005EC:
; H043+$000005EC: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000005F0:
; H043+$000005F0: 486dffb2  pea.l -$4e(a5)
        pea.l -$4e(a5)
L043_000005F4:
; H043+$000005F4: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000005F8:
; H043+$000005F8: 486cffa8  pea.l -$58(a4)
        pea.l -$58(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000005FC:
; H043+$000005FC: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00000602:
; H043+$00000602: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00000606:
; H043+$00000606: 486dffb2  pea.l -$4e(a5)
        pea.l -$4e(a5)
L043_0000060A:
; H043+$0000060A: 3f3c000b  move.w #$b, -(a7)
        move.w #$b, -(a7)
L043_0000060E:
; H043+$0000060E: 486c0050  pea.l $50(a4)
        pea.l $50(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L043_00000612:
; H043+$00000612: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L043_00000618:
; H043+$00000618: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_0000061C:
; H043+$0000061C: 486dffb2  pea.l -$4e(a5)
        pea.l -$4e(a5)
L043_00000620:
; H043+$00000620: 3f3c0013  move.w #$13, -(a7)
        move.w #$13, -(a7)
L043_00000624:
; H043+$00000624: 486c005c  pea.l $5c(a4)
        pea.l $5c(a4)
L043_00000628:
; H043+$00000628: 4227  clr.b -(a7)
        clr.b -(a7)
L043_0000062A:
; H043+$0000062A: 486dffae  pea.l -$52(a5)
        pea.l -$52(a5)
; FLOW: Calls Open_ResourceFile (H028+$05FA).
L043_0000062E:
; H043+$0000062E: 4eb9000005fa  jsr $5fa.l
        jsr (H028+$5FA).l
L043_00000634:
; H043+$00000634: 1940fffa  move.b d0, -$6(a4)
        move.b d0, -$6(a4)
L043_00000638:
; H043+$00000638: 4aadffae  tst.l -$52(a5)
        tst.l -$52(a5)
L043_0000063C:
; H043+$0000063C: 6600000a  bne.w $648
        bne.w H043+$648
L043_00000640:
; H043+$00000640: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L043_00000644:
; H043+$00000644: 6100fb84  bsr.w $1ca
        bsr.w H043+$1CA
L043_00000648:
; H043+$00000648: 2f2dffae  move.l -$52(a5), -(a7)
        move.l -$52(a5), -(a7)
L043_0000064C:
; H043+$0000064C: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000650:
; H043+$00000650: 2f2b06a8  move.l $6a8(a3), -(a7)
        move.l $6a8(a3), -(a7)
L043_00000654:
; H043+$00000654: 2f3c00000280  move.l #$280, -(a7)
        move.l #$280, -(a7)
L043_0000065A:
; H043+$0000065A: 6100fc68  bsr.w $2c4
        bsr.w H043+$2C4
L043_0000065E:
; H043+$0000065E: 2f2dffae  move.l -$52(a5), -(a7)
        move.l -$52(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L043_00000662:
; H043+$00000662: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L043_00000668:
; H043+$00000668: 6100fc9a  bsr.w $304
        bsr.w H043+$304
L043_0000066C:
; H043+$0000066C: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000670:
; H043+$00000670: 27400698  move.l d0, $698(a3)
        move.l d0, $698(a3)
L043_00000674:
; H043+$00000674: 6100fc8e  bsr.w $304
        bsr.w H043+$304
L043_00000678:
; H043+$00000678: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000067C:
; H043+$0000067C: 2740069c  move.l d0, $69c(a3)
        move.l d0, $69c(a3)
L043_00000680:
; H043+$00000680: 1b7c000fffff  move.b #$f, -$1(a5)
        move.b #$f, -$1(a5)
L043_00000686:
; H043+$00000686: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000068A:
; H043+$0000068A: 47eb0008  lea.l $8(a3), a3
        lea.l $8(a3), a3
L043_0000068E:
; H043+$0000068E: 177c007f0009  move.b #$7f, $9(a3)
        move.b #$7f, $9(a3)
L043_00000694:
; H043+$00000694: 45edffdc  lea.l -$24(a5), a2
        lea.l -$24(a5), a2
L043_00000698:
; H043+$00000698: 274a000e  move.l a2, $e(a3)
        move.l a2, $e(a3)
L043_0000069C:
; H043+$0000069C: 45edffff  lea.l -$1(a5), a2
        lea.l -$1(a5), a2
L043_000006A0:
; H043+$000006A0: 274a0022  move.l a2, $22(a3)
        move.l a2, $22(a3)
L043_000006A4:
; H043+$000006A4: 7401  moveq #$1, d2
        moveq #1, d2
L043_000006A6:
; H043+$000006A6: 27420026  move.l d2, $26(a3)
        move.l d2, $26(a3)
L043_000006AA:
; H043+$000006AA: 47ec0000  lea.l $0(a4), a3
        lea.l $0(a4), a3
L043_000006AE:
; H043+$000006AE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000006B0:
; H043+$000006B0: 7400  moveq #$0, d2
        moveq #0, d2
L043_000006B2:
; H043+$000006B2: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_000006B4:
; H043+$000006B4: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000006B8:
; H043+$000006B8: 47eb0008  lea.l $8(a3), a3
        lea.l $8(a3), a3
L043_000006BC:
; H043+$000006BC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000006BE:
; H043+$000006BE: 42a7  clr.l -(a7)
        clr.l -(a7)
; STEP: OpenDevice for audio.device; checks the returned code.
; -> H090+$002A (wrapper_OpenDevice)
L043_000006C0:
; H043+$000006C0: 4eb90000002a  jsr $2a.l
        jsr (H090+$2A).l
L043_000006C6:
; H043+$000006C6: 2400  move.l d0, d2
        move.l d0, d2
L043_000006C8:
; H043+$000006C8: 4a82  tst.l d2
        tst.l d2
L043_000006CA:
; H043+$000006CA: 6700000a  beq.w $6d6
        beq.w H043+$6D6
L043_000006CE:
; H043+$000006CE: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_000006D2:
; H043+$000006D2: 6100faf6  bsr.w $1ca
        bsr.w H043+$1CA
L043_000006D6:
; H043+$000006D6: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000006DA:
; H043+$000006DA: 246cff76  movea.l -$8a(a4), a2
        movea.l -$8a(a4), a2
L043_000006DE:
; H043+$000006DE: 256b001c0090  move.l $1c(a3), $90(a2)
        move.l $1c(a3), $90(a2)
L043_000006E4:
; H043+$000006E4: 197c0001fffd  move.b #$1, -$3(a4)
        move.b #$1, -$3(a4)
L043_000006EA:
; H043+$000006EA: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000006EE:
; H043+$000006EE: 47eb004c  lea.l $4c(a3), a3
        lea.l $4c(a3), a3
L043_000006F2:
; H043+$000006F2: 246cff76  movea.l -$8a(a4), a2
        movea.l -$8a(a4), a2
L043_000006F6:
; H043+$000006F6: 276a069c000e  move.l $69c(a2), $e(a3)
        move.l $69c(a2), $e(a3)
L043_000006FC:
; H043+$000006FC: 246cff76  movea.l -$8a(a4), a2
        movea.l -$8a(a4), a2
L043_00000700:
; H043+$00000700: 276a00900014  move.l $90(a2), $14(a3)
        move.l $90(a2), $14(a3)
L043_00000706:
; H043+$00000706: 42ab0018  clr.l $18(a3)
        clr.l $18(a3)
L043_0000070A:
; H043+$0000070A: 377c0008001c  move.w #$8, $1c(a3)
        move.w #$8, $1c(a3)
L043_00000710:
; H043+$00000710: 177c0001001e  move.b #$1, $1e(a3)
        move.b #$1, $1e(a3)
L043_00000716:
; H043+$00000716: 422b001f  clr.b $1f(a3)
        clr.b $1f(a3)
L043_0000071A:
; H043+$0000071A: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000071E:
; H043+$0000071E: 246cff76  movea.l -$8a(a4), a2
        movea.l -$8a(a4), a2
L043_00000722:
; H043+$00000722: 356b0028006c  move.w $28(a3), $6c(a2)
        move.w $28(a3), $6c(a2)
L043_00000728:
; H043+$00000728: 426dffda  clr.w -$26(a5)
        clr.w -$26(a5)
L043_0000072C:
; H043+$0000072C: 0c6d0010ffda  cmpi.w #$10, -$26(a5)
        cmpi.w #$10, -$26(a5)
L043_00000732:
; H043+$00000732: 6c000068  bge.w $79c
        bge.w H043+$79C
L043_00000736:
; H043+$00000736: 342dffda  move.w -$26(a5), d2
        move.w -$26(a5), d2
L043_0000073A:
; H043+$0000073A: c5fc0044  muls.w #$44, d2
        muls.w #$44, d2
L043_0000073E:
; H043+$0000073E: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000742:
; H043+$00000742: 47eb0258  lea.l $258(a3), a3
        lea.l $258(a3), a3
L043_00000746:
; H043+$00000746: 246cff76  movea.l -$8a(a4), a2
        movea.l -$8a(a4), a2
L043_0000074A:
; H043+$0000074A: 45ea004c  lea.l $4c(a2), a2
        lea.l $4c(a2), a2
L043_0000074E:
; H043+$0000074E: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L043_00000752:
; H043+$00000752: 7410  moveq #$10, d2
        moveq #16, d2
L043_00000754:
; H043+$00000754: 26da  move.l (a2)+, (a3)+
        move.l (a2)+, (a3)+
L043_00000756:
; H043+$00000756: 51cafffc  dbra d2, $754
        dbra d2, H043+$754
L043_0000075A:
; H043+$0000075A: 342dffda  move.w -$26(a5), d2
        move.w -$26(a5), d2
L043_0000075E:
; H043+$0000075E: c5fc0044  muls.w #$44, d2
        muls.w #$44, d2
L043_00000762:
; H043+$00000762: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000766:
; H043+$00000766: 47eb0258  lea.l $258(a3), a3
        lea.l $258(a3), a3
L043_0000076A:
; H043+$0000076A: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L043_0000076E:
; H043+$0000076E: 377c0003001c  move.w #$3, $1c(a3)
        move.w #$3, $1c(a3)
L043_00000774:
; H043+$00000774: 177c0010001e  move.b #$10, $1e(a3)
        move.b #$10, $1e(a3)
L043_0000077A:
; H043+$0000077A: 342dffda  move.w -$26(a5), d2
        move.w -$26(a5), d2
L043_0000077E:
; H043+$0000077E: c5fc0044  muls.w #$44, d2
        muls.w #$44, d2
L043_00000782:
; H043+$00000782: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000786:
; H043+$00000786: 47eb0258  lea.l $258(a3), a3
        lea.l $258(a3), a3
L043_0000078A:
; H043+$0000078A: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L043_0000078E:
; H043+$0000078E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H050+$0064 (wrapper_ReplyMsg)
L043_00000790:
; H043+$00000790: 4eb900000064  jsr $64.l
        jsr (H050+$64).l
L043_00000796:
; H043+$00000796: 526dffda  addq.w #$1, -$26(a5)
        addq.w #$1, -$26(a5)
L043_0000079A:
; H043+$0000079A: 6090  bra.b $72c
        bra.b H043+$72C
L043_0000079C:
; H043+$0000079C: 422cff83  clr.b -$7d(a4)
        clr.b -$7d(a4)
L043_000007A0:
; H043+$000007A0: 197c0002ff82  move.b #$2, -$7e(a4)
        move.b #$2, -$7e(a4)
L043_000007A6:
; H043+$000007A6: 42acff84  clr.l -$7c(a4)
        clr.l -$7c(a4)
L043_000007AA:
; H043+$000007AA: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000007AE:
; H043+$000007AE: 294bff88  move.l a3, -$78(a4)
        move.l a3, -$78(a4)
L043_000007B2:
; H043+$000007B2: 47f900000016  lea.l $16.l, a3
        lea.l (FN_audio_softinterrupt_worker).l, a3
L043_000007B8:
; H043+$000007B8: 294bff8c  move.l a3, -$74(a4)
        move.l a3, -$74(a4)
L043_000007BC:
; H043+$000007BC: 422cff99  clr.b -$67(a4)
        clr.b -$67(a4)
L043_000007C0:
; H043+$000007C0: 197c0002ff98  move.b #$2, -$68(a4)
        move.b #$2, -$68(a4)
L043_000007C6:
; H043+$000007C6: 42acff9a  clr.l -$66(a4)
        clr.l -$66(a4)
L043_000007CA:
; H043+$000007CA: 47ecff7a  lea.l -$86(a4), a3
        lea.l -$86(a4), a3
L043_000007CE:
; H043+$000007CE: 294bff9e  move.l a3, -$62(a4)
        move.l a3, -$62(a4)
L043_000007D2:
; H043+$000007D2: 47f900000006  lea.l $6.l, a3
        lea.l (FN_audio_vblank_schedule_Cause).l, a3
L043_000007D8:
; H043+$000007D8: 294bffa2  move.l a3, -$5e(a4)
        move.l a3, -$5e(a4)
L043_000007DC:
; H043+$000007DC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_000007E0:
; H043+$000007E0: 486cff90  pea.l -$70(a4)
        pea.l -$70(a4)
; STEP: Registers the vertical server that will call Cause on the software node.
; -> H079+$0006 (wrapper_AddIntServer)
L043_000007E4:
; H043+$000007E4: 4eb900000006  jsr $6.l
        jsr (H079+$6).l
L043_000007EA:
; H043+$000007EA: 197c0001fffe  move.b #$1, -$2(a4)
        move.b #$1, -$2(a4)
L043_000007F0:
; H043+$000007F0: 4e5d  unlk a5
        unlk a5
L043_000007F2:
; H043+$000007F2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_000007F4:
; H043+$000007F4: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H043_15C6 [partial]
; Purpose: Trampoline to H043+$15C6; the actual body is there.
;   - Jumps to the actual body at H043+$15C6.
;   - Calls H079+$002E.
;   - Calls H079+$0036.
;   - Calls H020+$085A.
;   - Calls H020+$08C2.
;   - Calls H020+$082E.
;   - Calls H010+$0332.
; Direct callers: H043+$0804, H043+$1072
; --------------------------------------------------------------------------
L043_000007F6:
; H043+$000007F6: 60000dce  bra.w $15c6
        bra.w H043+$15C6
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_000007FA [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$0860, H043+$196A
; --------------------------------------------------------------------------
L043_000007FA:
; H043+$000007FA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000007FC:
; H043+$000007FC: 287af9ba  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000800:
; H043+$00000800: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_00000804:
; H043+$00000804: 61f0  bsr.b $7f6
        bsr.b H043+$7F6
L043_00000806:
; H043+$00000806: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000080A:
; H043+$0000080A: 4aab06a0  tst.l $6a0(a3)
        tst.l $6a0(a3)
L043_0000080E:
; H043+$0000080E: 67000010  beq.w $820
        beq.w H043+$820
L043_00000812:
; H043+$00000812: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000816:
; H043+$00000816: 486b06a0  pea.l $6a0(a3)
        pea.l $6a0(a3)
L043_0000081A:
; H043+$0000081A: 6100fc9a  bsr.w $4b6
        bsr.w H043+$4B6
L043_0000081E:
; H043+$0000081E: 60e6  bra.b $806
        bra.b H043+$806
L043_00000820:
; H043+$00000820: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000824:
; H043+$00000824: 4aab06a4  tst.l $6a4(a3)
        tst.l $6a4(a3)
L043_00000828:
; H043+$00000828: 67000010  beq.w $83a
        beq.w H043+$83A
L043_0000082C:
; H043+$0000082C: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000830:
; H043+$00000830: 486b06a4  pea.l $6a4(a3)
        pea.l $6a4(a3)
L043_00000834:
; H043+$00000834: 6100fc80  bsr.w $4b6
        bsr.w H043+$4B6
L043_00000838:
; H043+$00000838: 60e6  bra.b $820
        bra.b H043+$820
L043_0000083A:
; H043+$0000083A: 4e5d  unlk a5
        unlk a5
L043_0000083C:
; H043+$0000083C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_0000083E:
; H043+$0000083E: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Audio_Shutdown [partial]
; Purpose: Stops the audio and releases the resources of the subsystem.
;   - Removes the interrupt server in the expected path.
;   - Closes audio.device if open and frees the allocated state/requests.
; Direct callers: H010+$033C, H013+$51D8, H043+$1686
; --------------------------------------------------------------------------
L043_00000840:
; H043+$00000840: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000842:
; H043+$00000842: 287af974  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000846:
; H043+$00000846: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_0000084A:
; H043+$0000084A: 4a2cfffe  tst.b -$2(a4)
        tst.b -$2(a4)
L043_0000084E:
; H043+$0000084E: 6700006e  beq.w $8be
        beq.w H043+$8BE
L043_00000852:
; H043+$00000852: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00000856:
; H043+$00000856: 486cff90  pea.l -$70(a4)
        pea.l -$70(a4)
; -> H079+$004E (wrapper_RemIntServer)
L043_0000085A:
; H043+$0000085A: 4eb90000004e  jsr $4e.l
        jsr (H079+$4E).l
L043_00000860:
; H043+$00000860: 6198  bsr.b $7fa
        bsr.b H043+$7FA
L043_00000862:
; H043+$00000862: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000866:
; H043+$00000866: 4aab0090  tst.l $90(a3)
        tst.l $90(a3)
L043_0000086A:
; H043+$0000086A: 67000016  beq.w $882
        beq.w H043+$882
L043_0000086E:
; H043+$0000086E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000870:
; H043+$00000870: 45eb0008  lea.l $8(a3), a2
        lea.l $8(a3), a2
L043_00000874:
; H043+$00000874: 2f0a  move.l a2, -(a7)
        move.l a2, -(a7)
; -> H090+$0018 (wrapper_CloseDevice)
L043_00000876:
; H043+$00000876: 4eb900000018  jsr $18.l
        jsr (H090+$18).l
L043_0000087C:
; H043+$0000087C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_0000087E:
; H043+$0000087E: 42ab0090  clr.l $90(a3)
        clr.l $90(a3)
L043_00000882:
; H043+$00000882: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000884:
; H043+$00000884: 486b069c  pea.l $69c(a3)
        pea.l $69c(a3)
L043_00000888:
; H043+$00000888: 6100fab6  bsr.w $340
        bsr.w H043+$340
L043_0000088C:
; H043+$0000088C: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_0000088E:
; H043+$0000088E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000890:
; H043+$00000890: 486b0698  pea.l $698(a3)
        pea.l $698(a3)
L043_00000894:
; H043+$00000894: 6100faaa  bsr.w $340
        bsr.w H043+$340
L043_00000898:
; H043+$00000898: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_0000089A:
; H043+$0000089A: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000089E:
; H043+$0000089E: 486b06a8  pea.l $6a8(a3)
        pea.l $6a8(a3)
L043_000008A2:
; H043+$000008A2: 2f3c00000280  move.l #$280, -(a7)
        move.l #$280, -(a7)
L043_000008A8:
; H043+$000008A8: 6100f9a8  bsr.w $252
        bsr.w H043+$252
L043_000008AC:
; H043+$000008AC: 486cff76  pea.l -$8a(a4)
        pea.l -$8a(a4)
L043_000008B0:
; H043+$000008B0: 2f3c000006b0  move.l #$6b0, -(a7)
        move.l #$6b0, -(a7)
L043_000008B6:
; H043+$000008B6: 6100f99a  bsr.w $252
        bsr.w H043+$252
L043_000008BA:
; H043+$000008BA: 422cfffe  clr.b -$2(a4)
        clr.b -$2(a4)
L043_000008BE:
; H043+$000008BE: 4e5d  unlk a5
        unlk a5
L043_000008C0:
; H043+$000008C0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_000008C2:
; H043+$000008C2: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_000008C4 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$107E
; --------------------------------------------------------------------------
L043_000008C4:
; H043+$000008C4: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000008C6:
; H043+$000008C6: 287af8f0  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000008CA:
; H043+$000008CA: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L043_000008CE:
; H043+$000008CE: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_000008D2:
; H043+$000008D2: 660000a8  bne.w $97c
        bne.w H043+$97C
L043_000008D6:
; H043+$000008D6: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L043_000008DA:
; H043+$000008DA: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L043_000008DE:
; H043+$000008DE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_000008E2:
; H043+$000008E2: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L043_000008E4:
; H043+$000008E4: 6c000078  bge.w $95e
        bge.w H043+$95E
L043_000008E8:
; H043+$000008E8: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L043_000008EC:
; H043+$000008EC: e542  asl.w #$2, d2
        asl.w #$2, d2
L043_000008EE:
; H043+$000008EE: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_000008F2:
; H043+$000008F2: 47eb0004  lea.l $4(a3), a3
        lea.l $4(a3), a3
L043_000008F6:
; H043+$000008F6: 2b732000fff6  move.l (a3, d2.w), -$a(a5)
        move.l (a3, d2.w), -$a(a5)
L043_000008FC:
; H043+$000008FC: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L043_00000900:
; H043+$00000900: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L043_00000904:
; H043+$00000904: 256b000a000e  move.l $a(a3), $e(a2)
        move.l $a(a3), $e(a2)
L043_0000090A:
; H043+$0000090A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L043_0000090E:
; H043+$0000090E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000912:
; H043+$00000912: b46b0002  cmp.w $2(a3), d2
        cmp.w $2(a3), d2
L043_00000916:
; H043+$00000916: 6d000010  blt.w $928
        blt.w H043+$928
L043_0000091A:
; H043+$0000091A: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_0000091E:
; H043+$0000091E: 2b6b0024fffc  move.l $24(a3), -$4(a5)
        move.l $24(a3), -$4(a5)
L043_00000924:
; H043+$00000924: 60000016  bra.w $93c
        bra.w H043+$93C
L043_00000928:
; H043+$00000928: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L043_0000092C:
; H043+$0000092C: e542  asl.w #$2, d2
        asl.w #$2, d2
L043_0000092E:
; H043+$0000092E: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000932:
; H043+$00000932: 47eb0024  lea.l $24(a3), a3
        lea.l $24(a3), a3
L043_00000936:
; H043+$00000936: 2b732000fffc  move.l (a3, d2.w), -$4(a5)
        move.l (a3, d2.w), -$4(a5)
L043_0000093C:
; H043+$0000093C: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L043_00000940:
; H043+$00000940: 276dfffc0004  move.l -$4(a5), $4(a3)
        move.l -$4(a5), $4(a3)
L043_00000946:
; H043+$00000946: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L043_0000094A:
; H043+$0000094A: 6700000a  beq.w $956
        beq.w H043+$956
L043_0000094E:
; H043+$0000094E: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_00000952:
; H043+$00000952: 526b0004  addq.w #$1, $4(a3)
        addq.w #$1, $4(a3)
L043_00000956:
; H043+$00000956: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L043_0000095A:
; H043+$0000095A: 6000ff7e  bra.w $8da
        bra.w H043+$8DA
L043_0000095E:
; H043+$0000095E: 7401  moveq #$1, d2
        moveq #1, d2
L043_00000960:
; H043+$00000960: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000964:
; H043+$00000964: 3813  move.w (a3), d4
        move.w (a3), d4
L043_00000966:
; H043+$00000966: 4a44  tst.w d4
        tst.w d4
L043_00000968:
; H043+$00000968: 6a06  bpl.b $970
        bpl.b H043+$970
L043_0000096A:
; H043+$0000096A: 4444  neg.w d4
        neg.w d4
L043_0000096C:
; H043+$0000096C: e86a  lsr.w d4, d2
        lsr.w d4, d2
L043_0000096E:
; H043+$0000096E: 6002  bra.b $972
        bra.b H043+$972
L043_00000970:
; H043+$00000970: e96a  lsl.w d4, d2
        lsl.w d4, d2
L043_00000972:
; H043+$00000972: 5342  subq.w #$1, d2
        subq.w #$1, d2
L043_00000974:
; H043+$00000974: 266d000c  movea.l $c(a5), a3
        movea.l $c(a5), a3
L043_00000978:
; H043+$00000978: 17420048  move.b d2, $48(a3)
        move.b d2, $48(a3)
L043_0000097C:
; H043+$0000097C: 4e5d  unlk a5
        unlk a5
L043_0000097E:
; H043+$0000097E: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000980:
; H043+$00000980: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000982:
; H043+$00000982: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_00000984:
; H043+$00000984: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000986 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H026+$0088, H026+$003A.
;   - Calls H026+$0088.
;   - Calls H026+$003A.
; Direct callers: H043+$13D8
; --------------------------------------------------------------------------
L043_00000986:
; H043+$00000986: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000988:
; H043+$00000988: 287af82e  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_0000098C:
; H043+$0000098C: 4e55ffb8  link.w a5, #$ffb8
        link.w a5, #$ffb8
L043_00000990:
; H043+$00000990: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L043_00000994:
; H043+$00000994: 744a  moveq #$4a, d2
        moveq #74, d2
L043_00000996:
; H043+$00000996: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000998:
; H043+$00000998: 6100f87a  bsr.w $214
        bsr.w H043+$214
L043_0000099C:
; H043+$0000099C: 2b40ffc2  move.l d0, -$3e(a5)
        move.l d0, -$3e(a5)
L043_000009A0:
; H043+$000009A0: 266dffc2  movea.l -$3e(a5), a3
        movea.l -$3e(a5), a3
L043_000009A4:
; H043+$000009A4: 377c00400044  move.w #$40, $44(a3)
        move.w #$40, $44(a3)
L043_000009AA:
; H043+$000009AA: 0cad00000008000c  cmpi.l #$8, $c(a5)
        cmpi.l #$8, $c(a5)
L043_000009B2:
; H043+$000009B2: 6d0001ec  blt.w $ba0
        blt.w H043+$BA0
L043_000009B6:
; H043+$000009B6: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_000009BA:
; H043+$000009BA: 660001e4  bne.w $ba0
        bne.w H043+$BA0
L043_000009BE:
; H043+$000009BE: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L043_000009C2:
; H043+$000009C2: 028200000001  andi.l #$1, d2
        andi.l #$1, d2
L043_000009C8:
; H043+$000009C8: 4a02  tst.b d2
        tst.b d2
L043_000009CA:
; H043+$000009CA: 67000014  beq.w $9e0
        beq.w H043+$9E0
L043_000009CE:
; H043+$000009CE: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_000009D2:
; H043+$000009D2: 2f3c00000001  move.l #$1, -(a7)
        move.l #$1, -(a7)
L043_000009D8:
; H043+$000009D8: 6100f8ac  bsr.w $286
        bsr.w H043+$286
L043_000009DC:
; H043+$000009DC: 53ad000c  subq.l #$1, $c(a5)
        subq.l #$1, $c(a5)
L043_000009E0:
; H043+$000009E0: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_000009E4:
; H043+$000009E4: 47edfffa  lea.l -$6(a5), a3
        lea.l -$6(a5), a3
L043_000009E8:
; H043+$000009E8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000009EA:
; H043+$000009EA: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_000009F0:
; H043+$000009F0: 6100f8d2  bsr.w $2c4
        bsr.w H043+$2C4
L043_000009F4:
; H043+$000009F4: 59ad000c  subq.l #$4, $c(a5)
        subq.l #$4, $c(a5)
L043_000009F8:
; H043+$000009F8: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_000009FC:
; H043+$000009FC: 47edfff6  lea.l -$a(a5), a3
        lea.l -$a(a5), a3
L043_00000A00:
; H043+$00000A00: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000A02:
; H043+$00000A02: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_00000A08:
; H043+$00000A08: 6100f8ba  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000A0C:
; H043+$00000A0C: 59ad000c  subq.l #$4, $c(a5)
        subq.l #$4, $c(a5)
L043_00000A10:
; H043+$00000A10: 242dfff6  move.l -$a(a5), d2
        move.l -$a(a5), d2
L043_00000A14:
; H043+$00000A14: 95ad000c  sub.l d2, $c(a5)
        sub.l d2, $c(a5)
L043_00000A18:
; H043+$00000A18: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000A1C:
; H043+$00000A1C: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000A20:
; H043+$00000A20: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000A24:
; H043+$00000A24: 486c001c  pea.l $1c(a4)
        pea.l $1c(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000A28:
; H043+$00000A28: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000A2E:
; H043+$00000A2E: 1400  move.b d0, d2
        move.b d0, d2
L043_00000A30:
; H043+$00000A30: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000A34:
; H043+$00000A34: 66000030  bne.w $a66
        bne.w H043+$A66
L043_00000A38:
; H043+$00000A38: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000A3C:
; H043+$00000A3C: 47edfff2  lea.l -$e(a5), a3
        lea.l -$e(a5), a3
L043_00000A40:
; H043+$00000A40: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000A42:
; H043+$00000A42: 7404  moveq #$4, d2
        moveq #4, d2
L043_00000A44:
; H043+$00000A44: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000A46:
; H043+$00000A46: 6100f87c  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000A4A:
; H043+$00000A4A: 7400  moveq #$0, d2
        moveq #0, d2
L043_00000A4C:
; H043+$00000A4C: 342dfff2  move.w -$e(a5), d2
        move.w -$e(a5), d2
L043_00000A50:
; H043+$00000A50: 84fc0044  divu.w #$44, d2
        divu.w #$44, d2
L043_00000A54:
; H043+$00000A54: 02820000ffff  andi.l #$ffff, d2
        andi.l #$ffff, d2
L043_00000A5A:
; H043+$00000A5A: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000A5E:
; H043+$00000A5E: 27420004  move.l d2, $4(a3)
        move.l d2, $4(a3)
L043_00000A62:
; H043+$00000A62: 60000138  bra.w $b9c
        bra.w H043+$B9C
L043_00000A66:
; H043+$00000A66: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000A6A:
; H043+$00000A6A: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000A6E:
; H043+$00000A6E: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000A72:
; H043+$00000A72: 486c0021  pea.l $21(a4)
        pea.l $21(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000A76:
; H043+$00000A76: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000A7C:
; H043+$00000A7C: 1400  move.b d0, d2
        move.b d0, d2
L043_00000A7E:
; H043+$00000A7E: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000A82:
; H043+$00000A82: 6600007e  bne.w $b02
        bne.w H043+$B02
L043_00000A86:
; H043+$00000A86: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000A8A:
; H043+$00000A8A: 47edffee  lea.l -$12(a5), a3
        lea.l -$12(a5), a3
L043_00000A8E:
; H043+$00000A8E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000A90:
; H043+$00000A90: 7404  moveq #$4, d2
        moveq #4, d2
L043_00000A92:
; H043+$00000A92: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000A94:
; H043+$00000A94: 6100f82e  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000A98:
; H043+$00000A98: 59adfff6  subq.l #$4, -$a(a5)
        subq.l #$4, -$a(a5)
L043_00000A9C:
; H043+$00000A9C: 0cad00000028fff6  cmpi.l #$28, -$a(a5)
        cmpi.l #$28, -$a(a5)
L043_00000AA4:
; H043+$00000AA4: 6f00000a  ble.w $ab0
        ble.w H043+$AB0
L043_00000AA8:
; H043+$00000AA8: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00000AAC:
; H043+$00000AAC: 6100f71c  bsr.w $1ca
        bsr.w H043+$1CA
L043_00000AB0:
; H043+$00000AB0: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000AB4:
; H043+$00000AB4: 47edffc6  lea.l -$3a(a5), a3
        lea.l -$3a(a5), a3
L043_00000AB8:
; H043+$00000AB8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000ABA:
; H043+$00000ABA: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000ABE:
; H043+$00000ABE: 6100f804  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000AC2:
; H043+$00000AC2: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00000AC6:
; H043+$00000AC6: 486dffc6  pea.l -$3a(a5)
        pea.l -$3a(a5)
; -> H026+$003A (sub_H026_0000003A)
L043_00000ACA:
; H043+$00000ACA: 4eb90000003a  jsr $3a.l
        jsr (H026+$3A).l
L043_00000AD0:
; H043+$00000AD0: 486dffc6  pea.l -$3a(a5)
        pea.l -$3a(a5)
L043_00000AD4:
; H043+$00000AD4: 4227  clr.b -(a7)
        clr.b -(a7)
L043_00000AD6:
; H043+$00000AD6: 6100f6fa  bsr.w $1d2
        bsr.w H043+$1D2
L043_00000ADA:
; H043+$00000ADA: 2b40ffba  move.l d0, -$46(a5)
        move.l d0, -$46(a5)
L043_00000ADE:
; H043+$00000ADE: 266dffc2  movea.l -$3e(a5), a3
        movea.l -$3e(a5), a3
L043_00000AE2:
; H043+$00000AE2: 342b0002  move.w $2(a3), d2
        move.w $2(a3), d2
L043_00000AE6:
; H043+$00000AE6: e542  asl.w #$2, d2
        asl.w #$2, d2
L043_00000AE8:
; H043+$00000AE8: 266dffc2  movea.l -$3e(a5), a3
        movea.l -$3e(a5), a3
L043_00000AEC:
; H043+$00000AEC: 47eb0024  lea.l $24(a3), a3
        lea.l $24(a3), a3
L043_00000AF0:
; H043+$00000AF0: 27adffba2000  move.l -$46(a5), (a3, d2.w)
        move.l -$46(a5), (a3, d2.w)
L043_00000AF6:
; H043+$00000AF6: 266dffc2  movea.l -$3e(a5), a3
        movea.l -$3e(a5), a3
L043_00000AFA:
; H043+$00000AFA: 526b0002  addq.w #$1, $2(a3)
        addq.w #$1, $2(a3)
L043_00000AFE:
; H043+$00000AFE: 6000009c  bra.w $b9c
        bra.w H043+$B9C
L043_00000B02:
; H043+$00000B02: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000B06:
; H043+$00000B06: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000B0A:
; H043+$00000B0A: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000B0E:
; H043+$00000B0E: 486c002b  pea.l $2b(a4)
        pea.l $2b(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000B12:
; H043+$00000B12: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000B18:
; H043+$00000B18: 1400  move.b d0, d2
        move.b d0, d2
L043_00000B1A:
; H043+$00000B1A: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000B1E:
; H043+$00000B1E: 66000070  bne.w $b90
        bne.w H043+$B90
L043_00000B22:
; H043+$00000B22: 7416  moveq #$16, d2
        moveq #22, d2
L043_00000B24:
; H043+$00000B24: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000B26:
; H043+$00000B26: 6100f6ec  bsr.w $214
        bsr.w H043+$214
L043_00000B2A:
; H043+$00000B2A: 2b40ffbe  move.l d0, -$42(a5)
        move.l d0, -$42(a5)
L043_00000B2E:
; H043+$00000B2E: 266dffbe  movea.l -$42(a5), a3
        movea.l -$42(a5), a3
L043_00000B32:
; H043+$00000B32: 177c00800008  move.b #$80, $8(a3)
        move.b #$80, $8(a3)
L043_00000B38:
; H043+$00000B38: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000B3C:
; H043+$00000B3C: 6100f6d6  bsr.w $214
        bsr.w H043+$214
L043_00000B40:
; H043+$00000B40: 266dffbe  movea.l -$42(a5), a3
        movea.l -$42(a5), a3
L043_00000B44:
; H043+$00000B44: 2740000a  move.l d0, $a(a3)
        move.l d0, $a(a3)
L043_00000B48:
; H043+$00000B48: 266dffbe  movea.l -$42(a5), a3
        movea.l -$42(a5), a3
L043_00000B4C:
; H043+$00000B4C: 242b000a  move.l $a(a3), d2
        move.l $a(a3), d2
L043_00000B50:
; H043+$00000B50: d4adfff6  add.l -$a(a5), d2
        add.l -$a(a5), d2
L043_00000B54:
; H043+$00000B54: 266dffbe  movea.l -$42(a5), a3
        movea.l -$42(a5), a3
L043_00000B58:
; H043+$00000B58: 27420012  move.l d2, $12(a3)
        move.l d2, $12(a3)
L043_00000B5C:
; H043+$00000B5C: 266dffc2  movea.l -$3e(a5), a3
        movea.l -$3e(a5), a3
L043_00000B60:
; H043+$00000B60: 3413  move.w (a3), d2
        move.w (a3), d2
L043_00000B62:
; H043+$00000B62: e542  asl.w #$2, d2
        asl.w #$2, d2
L043_00000B64:
; H043+$00000B64: 266dffc2  movea.l -$3e(a5), a3
        movea.l -$3e(a5), a3
L043_00000B68:
; H043+$00000B68: 47eb0004  lea.l $4(a3), a3
        lea.l $4(a3), a3
L043_00000B6C:
; H043+$00000B6C: 27adffbe2000  move.l -$42(a5), (a3, d2.w)
        move.l -$42(a5), (a3, d2.w)
L043_00000B72:
; H043+$00000B72: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000B76:
; H043+$00000B76: 266dffbe  movea.l -$42(a5), a3
        movea.l -$42(a5), a3
L043_00000B7A:
; H043+$00000B7A: 2f2b000a  move.l $a(a3), -(a7)
        move.l $a(a3), -(a7)
L043_00000B7E:
; H043+$00000B7E: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000B82:
; H043+$00000B82: 6100f740  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000B86:
; H043+$00000B86: 266dffc2  movea.l -$3e(a5), a3
        movea.l -$3e(a5), a3
L043_00000B8A:
; H043+$00000B8A: 5253  addq.w #$1, (a3)
        addq.w #$1, (a3)
L043_00000B8C:
; H043+$00000B8C: 6000000e  bra.w $b9c
        bra.w H043+$B9C
L043_00000B90:
; H043+$00000B90: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000B94:
; H043+$00000B94: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000B98:
; H043+$00000B98: 6100f6ec  bsr.w $286
        bsr.w H043+$286
L043_00000B9C:
; H043+$00000B9C: 6000fe0c  bra.w $9aa
        bra.w H043+$9AA
L043_00000BA0:
; H043+$00000BA0: 202dffc2  move.l -$3e(a5), d0
        move.l -$3e(a5), d0
L043_00000BA4:
; H043+$00000BA4: 60000002  bra.w $ba8
        bra.w H043+$BA8
L043_00000BA8:
; H043+$00000BA8: 4e5d  unlk a5
        unlk a5
L043_00000BAA:
; H043+$00000BAA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000BAC:
; H043+$00000BAC: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000BAE:
; H043+$00000BAE: 508f  addq.l #$8, a7
        addq.l #$8, a7
L043_00000BB0:
; H043+$00000BB0: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000BB2 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H026+$0088.
;   - Calls H026+$0088.
; Direct callers: H043+$141A
; --------------------------------------------------------------------------
L043_00000BB2:
; H043+$00000BB2: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000BB4:
; H043+$00000BB4: 287af602  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000BB8:
; H043+$00000BB8: 4e55ffee  link.w a5, #$ffee
        link.w a5, #$ffee
L043_00000BBC:
; H043+$00000BBC: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L043_00000BC0:
; H043+$00000BC0: 2f3c0000001c  move.l #$1c, -(a7)
        move.l #$1c, -(a7)
L043_00000BC6:
; H043+$00000BC6: 6100f64c  bsr.w $214
        bsr.w H043+$214
L043_00000BCA:
; H043+$00000BCA: 2b40ffee  move.l d0, -$12(a5)
        move.l d0, -$12(a5)
L043_00000BCE:
; H043+$00000BCE: 0cad00000008000c  cmpi.l #$8, $c(a5)
        cmpi.l #$8, $c(a5)
L043_00000BD6:
; H043+$00000BD6: 6d00013e  blt.w $d16
        blt.w H043+$D16
L043_00000BDA:
; H043+$00000BDA: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_00000BDE:
; H043+$00000BDE: 66000136  bne.w $d16
        bne.w H043+$D16
L043_00000BE2:
; H043+$00000BE2: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L043_00000BE6:
; H043+$00000BE6: 028200000001  andi.l #$1, d2
        andi.l #$1, d2
L043_00000BEC:
; H043+$00000BEC: 4a02  tst.b d2
        tst.b d2
L043_00000BEE:
; H043+$00000BEE: 67000014  beq.w $c04
        beq.w H043+$C04
L043_00000BF2:
; H043+$00000BF2: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000BF6:
; H043+$00000BF6: 2f3c00000001  move.l #$1, -(a7)
        move.l #$1, -(a7)
L043_00000BFC:
; H043+$00000BFC: 6100f688  bsr.w $286
        bsr.w H043+$286
L043_00000C00:
; H043+$00000C00: 53ad000c  subq.l #$1, $c(a5)
        subq.l #$1, $c(a5)
L043_00000C04:
; H043+$00000C04: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000C08:
; H043+$00000C08: 47edfffa  lea.l -$6(a5), a3
        lea.l -$6(a5), a3
L043_00000C0C:
; H043+$00000C0C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000C0E:
; H043+$00000C0E: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_00000C14:
; H043+$00000C14: 6100f6ae  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000C18:
; H043+$00000C18: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000C1C:
; H043+$00000C1C: 47edfff6  lea.l -$a(a5), a3
        lea.l -$a(a5), a3
L043_00000C20:
; H043+$00000C20: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000C22:
; H043+$00000C22: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_00000C28:
; H043+$00000C28: 6100f69a  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000C2C:
; H043+$00000C2C: 51ad000c  subq.l #$8, $c(a5)
        subq.l #$8, $c(a5)
L043_00000C30:
; H043+$00000C30: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000C34:
; H043+$00000C34: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000C38:
; H043+$00000C38: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000C3C:
; H043+$00000C3C: 486c0035  pea.l $35(a4)
        pea.l $35(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000C40:
; H043+$00000C40: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000C46:
; H043+$00000C46: 1400  move.b d0, d2
        move.b d0, d2
L043_00000C48:
; H043+$00000C48: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000C4C:
; H043+$00000C4C: 6600001e  bne.w $c6c
        bne.w H043+$C6C
L043_00000C50:
; H043+$00000C50: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000C54:
; H043+$00000C54: 2f2dffee  move.l -$12(a5), -(a7)
        move.l -$12(a5), -(a7)
L043_00000C58:
; H043+$00000C58: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000C5C:
; H043+$00000C5C: 6100f666  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000C60:
; H043+$00000C60: 242dfff6  move.l -$a(a5), d2
        move.l -$a(a5), d2
L043_00000C64:
; H043+$00000C64: 95ad000c  sub.l d2, $c(a5)
        sub.l d2, $c(a5)
L043_00000C68:
; H043+$00000C68: 600000a8  bra.w $d12
        bra.w H043+$D12
L043_00000C6C:
; H043+$00000C6C: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000C70:
; H043+$00000C70: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000C74:
; H043+$00000C74: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000C78:
; H043+$00000C78: 486c003a  pea.l $3a(a4)
        pea.l $3a(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000C7C:
; H043+$00000C7C: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000C82:
; H043+$00000C82: 1400  move.b d0, d2
        move.b d0, d2
L043_00000C84:
; H043+$00000C84: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000C88:
; H043+$00000C88: 6600003c  bne.w $cc6
        bne.w H043+$CC6
L043_00000C8C:
; H043+$00000C8C: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L043_00000C90:
; H043+$00000C90: 276dfff60014  move.l -$a(a5), $14(a3)
        move.l -$a(a5), $14(a3)
L043_00000C96:
; H043+$00000C96: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000C9A:
; H043+$00000C9A: 6100f53a  bsr.w $1d6
        bsr.w H043+$1D6
L043_00000C9E:
; H043+$00000C9E: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L043_00000CA2:
; H043+$00000CA2: 27400018  move.l d0, $18(a3)
        move.l d0, $18(a3)
L043_00000CA6:
; H043+$00000CA6: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000CAA:
; H043+$00000CAA: 266dffee  movea.l -$12(a5), a3
        movea.l -$12(a5), a3
L043_00000CAE:
; H043+$00000CAE: 2f2b0018  move.l $18(a3), -(a7)
        move.l $18(a3), -(a7)
L043_00000CB2:
; H043+$00000CB2: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000CB6:
; H043+$00000CB6: 6100f60c  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000CBA:
; H043+$00000CBA: 242dfff6  move.l -$a(a5), d2
        move.l -$a(a5), d2
L043_00000CBE:
; H043+$00000CBE: 95ad000c  sub.l d2, $c(a5)
        sub.l d2, $c(a5)
L043_00000CC2:
; H043+$00000CC2: 6000004e  bra.w $d12
        bra.w H043+$D12
L043_00000CC6:
; H043+$00000CC6: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000CCA:
; H043+$00000CCA: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000CCE:
; H043+$00000CCE: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000CD2:
; H043+$00000CD2: 486c003f  pea.l $3f(a4)
        pea.l $3f(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000CD6:
; H043+$00000CD6: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000CDC:
; H043+$00000CDC: 1400  move.b d0, d2
        move.b d0, d2
L043_00000CDE:
; H043+$00000CDE: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000CE2:
; H043+$00000CE2: 6600001a  bne.w $cfe
        bne.w H043+$CFE
L043_00000CE6:
; H043+$00000CE6: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000CEA:
; H043+$00000CEA: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000CEE:
; H043+$00000CEE: 6100f596  bsr.w $286
        bsr.w H043+$286
L043_00000CF2:
; H043+$00000CF2: 242dfff6  move.l -$a(a5), d2
        move.l -$a(a5), d2
L043_00000CF6:
; H043+$00000CF6: 95ad000c  sub.l d2, $c(a5)
        sub.l d2, $c(a5)
L043_00000CFA:
; H043+$00000CFA: 60000016  bra.w $d12
        bra.w H043+$D12
L043_00000CFE:
; H043+$00000CFE: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000D02:
; H043+$00000D02: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000D06:
; H043+$00000D06: 6100f57e  bsr.w $286
        bsr.w H043+$286
L043_00000D0A:
; H043+$00000D0A: 242dfff6  move.l -$a(a5), d2
        move.l -$a(a5), d2
L043_00000D0E:
; H043+$00000D0E: 95ad000c  sub.l d2, $c(a5)
        sub.l d2, $c(a5)
L043_00000D12:
; H043+$00000D12: 6000feba  bra.w $bce
        bra.w H043+$BCE
L043_00000D16:
; H043+$00000D16: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_00000D1A:
; H043+$00000D1A: 6700000c  beq.w $d28
        beq.w H043+$D28
L043_00000D1E:
; H043+$00000D1E: 7000  moveq #$0, d0
        moveq #0, d0
L043_00000D20:
; H043+$00000D20: 6000000e  bra.w $d30
        bra.w H043+$D30
; Preserved bytes H043+$00000D24..$00000D28; code/data not fully classified.
        dc.w $6000,$000A
L043_00000D28:
; H043+$00000D28: 202dffee  move.l -$12(a5), d0
        move.l -$12(a5), d0
L043_00000D2C:
; H043+$00000D2C: 60000002  bra.w $d30
        bra.w H043+$D30
L043_00000D30:
; H043+$00000D30: 4e5d  unlk a5
        unlk a5
L043_00000D32:
; H043+$00000D32: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000D34:
; H043+$00000D34: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000D36:
; H043+$00000D36: 508f  addq.l #$8, a7
        addq.l #$8, a7
L043_00000D38:
; H043+$00000D38: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000D3A [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; local logic, no external call reached.
;   - Performs local operations on the data or on the state of the module.
; Direct callers: H043+$149E
; --------------------------------------------------------------------------
L043_00000D3A:
; H043+$00000D3A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000D3C:
; H043+$00000D3C: 287af47a  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000D40:
; H043+$00000D40: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L043_00000D44:
; H043+$00000D44: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L043_00000D48:
; H043+$00000D48: 5482  addq.l #$2, d2
        addq.l #$2, d2
L043_00000D4A:
; H043+$00000D4A: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000D4C:
; H043+$00000D4C: 6100f4c6  bsr.w $214
        bsr.w H043+$214
L043_00000D50:
; H043+$00000D50: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L043_00000D54:
; H043+$00000D54: 242d000c  move.l $c(a5), d2
        move.l $c(a5), d2
L043_00000D58:
; H043+$00000D58: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_00000D5C:
; H043+$00000D5C: 3682  move.w d2, (a3)
        move.w d2, (a3)
L043_00000D5E:
; H043+$00000D5E: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000D62:
; H043+$00000D62: 242dfffc  move.l -$4(a5), d2
        move.l -$4(a5), d2
L043_00000D66:
; H043+$00000D66: 5482  addq.l #$2, d2
        addq.l #$2, d2
L043_00000D68:
; H043+$00000D68: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000D6A:
; H043+$00000D6A: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
L043_00000D6E:
; H043+$00000D6E: 6100f554  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000D72:
; H043+$00000D72: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L043_00000D76:
; H043+$00000D76: 60000002  bra.w $d7a
        bra.w H043+$D7A
L043_00000D7A:
; H043+$00000D7A: 4e5d  unlk a5
        unlk a5
L043_00000D7C:
; H043+$00000D7C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000D7E:
; H043+$00000D7E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000D80:
; H043+$00000D80: 508f  addq.l #$8, a7
        addq.l #$8, a7
L043_00000D82:
; H043+$00000D82: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000D84 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H026+$0088.
;   - Calls H026+$0088.
; Direct callers: H043+$145C
; --------------------------------------------------------------------------
L043_00000D84:
; H043+$00000D84: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000D86:
; H043+$00000D86: 287af430  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000D8A:
; H043+$00000D8A: 4e55ffca  link.w a5, #$ffca
        link.w a5, #$ffca
L043_00000D8E:
; H043+$00000D8E: 422dfffe  clr.b -$2(a5)
        clr.b -$2(a5)
L043_00000D92:
; H043+$00000D92: 7418  moveq #$18, d2
        moveq #24, d2
L043_00000D94:
; H043+$00000D94: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_00000D96:
; H043+$00000D96: 6100f47c  bsr.w $214
        bsr.w H043+$214
L043_00000D9A:
; H043+$00000D9A: 2b40fff2  move.l d0, -$e(a5)
        move.l d0, -$e(a5)
L043_00000D9E:
; H043+$00000D9E: 0cad00000008000c  cmpi.l #$8, $c(a5)
        cmpi.l #$8, $c(a5)
L043_00000DA6:
; H043+$00000DA6: 6d000186  blt.w $f2e
        blt.w H043+$F2E
L043_00000DAA:
; H043+$00000DAA: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_00000DAE:
; H043+$00000DAE: 6600017e  bne.w $f2e
        bne.w H043+$F2E
L043_00000DB2:
; H043+$00000DB2: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000DB6:
; H043+$00000DB6: 47edfffa  lea.l -$6(a5), a3
        lea.l -$6(a5), a3
L043_00000DBA:
; H043+$00000DBA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000DBC:
; H043+$00000DBC: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_00000DC2:
; H043+$00000DC2: 6100f500  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000DC6:
; H043+$00000DC6: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000DCA:
; H043+$00000DCA: 47edfff6  lea.l -$a(a5), a3
        lea.l -$a(a5), a3
L043_00000DCE:
; H043+$00000DCE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000DD0:
; H043+$00000DD0: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_00000DD6:
; H043+$00000DD6: 6100f4ec  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000DDA:
; H043+$00000DDA: 51ad000c  subq.l #$8, $c(a5)
        subq.l #$8, $c(a5)
L043_00000DDE:
; H043+$00000DDE: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000DE2:
; H043+$00000DE2: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000DE6:
; H043+$00000DE6: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000DEA:
; H043+$00000DEA: 486c0070  pea.l $70(a4)
        pea.l $70(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000DEE:
; H043+$00000DEE: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000DF4:
; H043+$00000DF4: 1400  move.b d0, d2
        move.b d0, d2
L043_00000DF6:
; H043+$00000DF6: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000DFA:
; H043+$00000DFA: 6600004a  bne.w $e46
        bne.w H043+$E46
L043_00000DFE:
; H043+$00000DFE: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000E02:
; H043+$00000E02: 47edffca  lea.l -$36(a5), a3
        lea.l -$36(a5), a3
L043_00000E06:
; H043+$00000E06: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000E08:
; H043+$00000E08: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000E0C:
; H043+$00000E0C: 6100f4b6  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000E10:
; H043+$00000E10: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L043_00000E14:
; H043+$00000E14: 4227  clr.b -(a7)
        clr.b -(a7)
L043_00000E16:
; H043+$00000E16: 6100f3ba  bsr.w $1d2
        bsr.w H043+$1D2
L043_00000E1A:
; H043+$00000E1A: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000E1E:
; H043+$00000E1E: 2740000c  move.l d0, $c(a3)
        move.l d0, $c(a3)
L043_00000E22:
; H043+$00000E22: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000E26:
; H043+$00000E26: 4aab000c  tst.l $c(a3)
        tst.l $c(a3)
L043_00000E2A:
; H043+$00000E2A: 67000016  beq.w $e42
        beq.w H043+$E42
L043_00000E2E:
; H043+$00000E2E: 246dfff2  movea.l -$e(a5), a2
        movea.l -$e(a5), a2
L043_00000E32:
; H043+$00000E32: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L043_00000E36:
; H043+$00000E36: 242b0006  move.l $6(a3), d2
        move.l $6(a3), d2
L043_00000E3A:
; H043+$00000E3A: 5482  addq.l #$2, d2
        addq.l #$2, d2
L043_00000E3C:
; H043+$00000E3C: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000E40:
; H043+$00000E40: 2682  move.l d2, (a3)
        move.l d2, (a3)
L043_00000E42:
; H043+$00000E42: 600000de  bra.w $f22
        bra.w H043+$F22
L043_00000E46:
; H043+$00000E46: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000E4A:
; H043+$00000E4A: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000E4E:
; H043+$00000E4E: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000E52:
; H043+$00000E52: 486c0075  pea.l $75(a4)
        pea.l $75(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000E56:
; H043+$00000E56: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000E5C:
; H043+$00000E5C: 1400  move.b d0, d2
        move.b d0, d2
L043_00000E5E:
; H043+$00000E5E: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000E62:
; H043+$00000E62: 6600004c  bne.w $eb0
        bne.w H043+$EB0
L043_00000E66:
; H043+$00000E66: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000E6A:
; H043+$00000E6A: 47edffca  lea.l -$36(a5), a3
        lea.l -$36(a5), a3
L043_00000E6E:
; H043+$00000E6E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000E70:
; H043+$00000E70: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000E74:
; H043+$00000E74: 6100f44e  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000E78:
; H043+$00000E78: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L043_00000E7C:
; H043+$00000E7C: 4227  clr.b -(a7)
        clr.b -(a7)
L043_00000E7E:
; H043+$00000E7E: 6100f352  bsr.w $1d2
        bsr.w H043+$1D2
L043_00000E82:
; H043+$00000E82: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000E86:
; H043+$00000E86: 27400010  move.l d0, $10(a3)
        move.l d0, $10(a3)
L043_00000E8A:
; H043+$00000E8A: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000E8E:
; H043+$00000E8E: 4aab0010  tst.l $10(a3)
        tst.l $10(a3)
L043_00000E92:
; H043+$00000E92: 67000018  beq.w $eac
        beq.w H043+$EAC
L043_00000E96:
; H043+$00000E96: 246dfff2  movea.l -$e(a5), a2
        movea.l -$e(a5), a2
L043_00000E9A:
; H043+$00000E9A: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L043_00000E9E:
; H043+$00000E9E: 242b0006  move.l $6(a3), d2
        move.l $6(a3), d2
L043_00000EA2:
; H043+$00000EA2: 5482  addq.l #$2, d2
        addq.l #$2, d2
L043_00000EA4:
; H043+$00000EA4: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000EA8:
; H043+$00000EA8: 27420004  move.l d2, $4(a3)
        move.l d2, $4(a3)
L043_00000EAC:
; H043+$00000EAC: 60000074  bra.w $f22
        bra.w H043+$F22
L043_00000EB0:
; H043+$00000EB0: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000EB4:
; H043+$00000EB4: 486dfffa  pea.l -$6(a5)
        pea.l -$6(a5)
L043_00000EB8:
; H043+$00000EB8: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00000EBC:
; H043+$00000EBC: 486c007a  pea.l $7a(a4)
        pea.l $7a(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00000EC0:
; H043+$00000EC0: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000EC6:
; H043+$00000EC6: 1400  move.b d0, d2
        move.b d0, d2
L043_00000EC8:
; H043+$00000EC8: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000ECC:
; H043+$00000ECC: 66000048  bne.w $f16
        bne.w H043+$F16
L043_00000ED0:
; H043+$00000ED0: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000ED4:
; H043+$00000ED4: 47edffca  lea.l -$36(a5), a3
        lea.l -$36(a5), a3
L043_00000ED8:
; H043+$00000ED8: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00000EDA:
; H043+$00000EDA: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000EDE:
; H043+$00000EDE: 6100f3e4  bsr.w $2c4
        bsr.w H043+$2C4
L043_00000EE2:
; H043+$00000EE2: 486dffca  pea.l -$36(a5)
        pea.l -$36(a5)
L043_00000EE6:
; H043+$00000EE6: 4227  clr.b -(a7)
        clr.b -(a7)
L043_00000EE8:
; H043+$00000EE8: 6100f2e8  bsr.w $1d2
        bsr.w H043+$1D2
L043_00000EEC:
; H043+$00000EEC: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000EF0:
; H043+$00000EF0: 27400014  move.l d0, $14(a3)
        move.l d0, $14(a3)
L043_00000EF4:
; H043+$00000EF4: 266dfff2  movea.l -$e(a5), a3
        movea.l -$e(a5), a3
L043_00000EF8:
; H043+$00000EF8: 4aab0014  tst.l $14(a3)
        tst.l $14(a3)
L043_00000EFC:
; H043+$00000EFC: 67000014  beq.w $f12
        beq.w H043+$F12
L043_00000F00:
; H043+$00000F00: 246dfff2  movea.l -$e(a5), a2
        movea.l -$e(a5), a2
L043_00000F04:
; H043+$00000F04: 266a0014  movea.l $14(a2), a3
        movea.l $14(a2), a3
L043_00000F08:
; H043+$00000F08: 246dfff2  movea.l -$e(a5), a2
        movea.l -$e(a5), a2
L043_00000F0C:
; H043+$00000F0C: 256b00060008  move.l $6(a3), $8(a2)
        move.l $6(a3), $8(a2)
L043_00000F12:
; H043+$00000F12: 6000000e  bra.w $f22
        bra.w H043+$F22
L043_00000F16:
; H043+$00000F16: 2f2d0010  move.l $10(a5), -(a7)
        move.l $10(a5), -(a7)
L043_00000F1A:
; H043+$00000F1A: 2f2dfff6  move.l -$a(a5), -(a7)
        move.l -$a(a5), -(a7)
L043_00000F1E:
; H043+$00000F1E: 6100f366  bsr.w $286
        bsr.w H043+$286
L043_00000F22:
; H043+$00000F22: 242dfff6  move.l -$a(a5), d2
        move.l -$a(a5), d2
L043_00000F26:
; H043+$00000F26: 95ad000c  sub.l d2, $c(a5)
        sub.l d2, $c(a5)
L043_00000F2A:
; H043+$00000F2A: 6000fe72  bra.w $d9e
        bra.w H043+$D9E
L043_00000F2E:
; H043+$00000F2E: 202dfff2  move.l -$e(a5), d0
        move.l -$e(a5), d0
L043_00000F32:
; H043+$00000F32: 60000002  bra.w $f36
        bra.w H043+$F36
L043_00000F36:
; H043+$00000F36: 4e5d  unlk a5
        unlk a5
L043_00000F38:
; H043+$00000F38: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00000F3A:
; H043+$00000F3A: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00000F3C:
; H043+$00000F3C: 508f  addq.l #$8, a7
        addq.l #$8, a7
L043_00000F3E:
; H043+$00000F3E: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H043+$00000F40..$00000F50; code/data not fully classified.
        dc.w $2F0C,$287A,$F274,$4E55,$0000,$4E5D,$285F,$4E75
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00000F50 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H079+$002E, H026+$0088, H079+$0036.
;   - Calls H079+$002E.
;   - Calls H026+$0088.
;   - Calls H079+$0036.
; Direct callers: H043+$1162, H043+$1366
; --------------------------------------------------------------------------
L043_00000F50:
; H043+$00000F50: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00000F52:
; H043+$00000F52: 287af264  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00000F56:
; H043+$00000F56: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
L043_00000F5A:
; H043+$00000F5A: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L043_00000F5E:
; H043+$00000F5E: 422dfff3  clr.b -$d(a5)
        clr.b -$d(a5)
; -> H079+$002E (wrapper_Disable)
L043_00000F62:
; H043+$00000F62: 4eb90000002e  jsr $2e.l
        jsr (H079+$2E).l
L043_00000F68:
; H043+$00000F68: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000F6C:
; H043+$00000F6C: 2b6b06a0fff8  move.l $6a0(a3), -$8(a5)
        move.l $6a0(a3), -$8(a5)
L043_00000F72:
; H043+$00000F72: 42adfff4  clr.l -$c(a5)
        clr.l -$c(a5)
L043_00000F76:
; H043+$00000F76: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L043_00000F7A:
; H043+$00000F7A: 66000012  bne.w $f8e
        bne.w H043+$F8E
L043_00000F7E:
; H043+$00000F7E: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00000F82:
; H043+$00000F82: 2b6b06a4fff8  move.l $6a4(a3), -$8(a5)
        move.l $6a4(a3), -$8(a5)
L043_00000F88:
; H043+$00000F88: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L043_00000F8E:
; H043+$00000F8E: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L043_00000F92:
; H043+$00000F92: 670000ac  beq.w $1040
        beq.w H043+$1040
L043_00000F96:
; H043+$00000F96: 246dfff8  movea.l -$8(a5), a2
        movea.l -$8(a5), a2
L043_00000F9A:
; H043+$00000F9A: 266a000a  movea.l $a(a2), a3
        movea.l $a(a2), a3
L043_00000F9E:
; H043+$00000F9E: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00000FA2:
; H043+$00000FA2: 4853  pea.l (a3)
        pea.l (a3)
L043_00000FA4:
; H043+$00000FA4: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00000FA8:
; H043+$00000FA8: 2f2d000c  move.l $c(a5), -(a7)
        move.l $c(a5), -(a7)
; -> H026+$0088 (sub_H026_00000088)
L043_00000FAC:
; H043+$00000FAC: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00000FB2:
; H043+$00000FB2: 1400  move.b d0, d2
        move.b d0, d2
L043_00000FB4:
; H043+$00000FB4: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00000FB8:
; H043+$00000FB8: 66000050  bne.w $100a
        bne.w H043+$100A
L043_00000FBC:
; H043+$00000FBC: 2b6dfff8fffc  move.l -$8(a5), -$4(a5)
        move.l -$8(a5), -$4(a5)
L043_00000FC2:
; H043+$00000FC2: 4aadfff4  tst.l -$c(a5)
        tst.l -$c(a5)
L043_00000FC6:
; H043+$00000FC6: 6600002a  bne.w $ff2
        bne.w H043+$FF2
L043_00000FCA:
; H043+$00000FCA: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L043_00000FCE:
; H043+$00000FCE: 67000012  beq.w $fe2
        beq.w H043+$FE2
L043_00000FD2:
; H043+$00000FD2: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L043_00000FD6:
; H043+$00000FD6: 246cff76  movea.l -$8a(a4), a2
        movea.l -$8a(a4), a2
L043_00000FDA:
; H043+$00000FDA: 255306a4  move.l (a3), $6a4(a2)
        move.l (a3), $6a4(a2)
L043_00000FDE:
; H043+$00000FDE: 6000000e  bra.w $fee
        bra.w H043+$FEE
L043_00000FE2:
; H043+$00000FE2: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L043_00000FE6:
; H043+$00000FE6: 246cff76  movea.l -$8a(a4), a2
        movea.l -$8a(a4), a2
L043_00000FEA:
; H043+$00000FEA: 255306a0  move.l (a3), $6a0(a2)
        move.l (a3), $6a0(a2)
L043_00000FEE:
; H043+$00000FEE: 6000000c  bra.w $ffc
        bra.w H043+$FFC
L043_00000FF2:
; H043+$00000FF2: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L043_00000FF6:
; H043+$00000FF6: 246dfff4  movea.l -$c(a5), a2
        movea.l -$c(a5), a2
L043_00000FFA:
; H043+$00000FFA: 2493  move.l (a3), (a2)
        move.l (a3), (a2)
L043_00000FFC:
; H043+$00000FFC: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L043_00001000:
; H043+$00001000: 4293  clr.l (a3)
        clr.l (a3)
L043_00001002:
; H043+$00001002: 42adfff8  clr.l -$8(a5)
        clr.l -$8(a5)
L043_00001006:
; H043+$00001006: 60000034  bra.w $103c
        bra.w H043+$103C
L043_0000100A:
; H043+$0000100A: 2b6dfff8fff4  move.l -$8(a5), -$c(a5)
        move.l -$8(a5), -$c(a5)
L043_00001010:
; H043+$00001010: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L043_00001014:
; H043+$00001014: 2b53fff8  move.l (a3), -$8(a5)
        move.l (a3), -$8(a5)
L043_00001018:
; H043+$00001018: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L043_0000101C:
; H043+$0000101C: 6600001e  bne.w $103c
        bne.w H043+$103C
L043_00001020:
; H043+$00001020: 4a2dfff3  tst.b -$d(a5)
        tst.b -$d(a5)
L043_00001024:
; H043+$00001024: 66000016  bne.w $103c
        bne.w H043+$103C
L043_00001028:
; H043+$00001028: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000102C:
; H043+$0000102C: 2b6b06a4fff8  move.l $6a4(a3), -$8(a5)
        move.l $6a4(a3), -$8(a5)
L043_00001032:
; H043+$00001032: 42adfff4  clr.l -$c(a5)
        clr.l -$c(a5)
L043_00001036:
; H043+$00001036: 1b7c0001fff3  move.b #$1, -$d(a5)
        move.b #$1, -$d(a5)
L043_0000103C:
; H043+$0000103C: 6000ff50  bra.w $f8e
        bra.w H043+$F8E
; -> H079+$0036 (wrapper_Enable)
L043_00001040:
; H043+$00001040: 4eb900000036  jsr $36.l
        jsr (H079+$36).l
L043_00001046:
; H043+$00001046: 202dfffc  move.l -$4(a5), d0
        move.l -$4(a5), d0
L043_0000104A:
; H043+$0000104A: 60000002  bra.w $104e
        bra.w H043+$104E
L043_0000104E:
; H043+$0000104E: 4e5d  unlk a5
        unlk a5
L043_00001050:
; H043+$00001050: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00001052:
; H043+$00001052: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00001054:
; H043+$00001054: 588f  addq.l #$4, a7
        addq.l #$4, a7
L043_00001056:
; H043+$00001056: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_00001058 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H079+$002E, H079+$0036.
;   - Calls H079+$002E.
;   - Calls H079+$0036.
; Direct callers: H043+$158E, H043+$1548, H043+$155C
; --------------------------------------------------------------------------
L043_00001058:
; H043+$00001058: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_0000105A:
; H043+$0000105A: 287af15c  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_0000105E:
; H043+$0000105E: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L043_00001062:
; H043+$00001062: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L043_00001066:
; H043+$00001066: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_0000106A:
; H043+$0000106A: 08020000  btst.b #$0, d2
        btst #$0, d2
L043_0000106E:
; H043+$0000106E: 67000012  beq.w $1082
        beq.w H043+$1082
L043_00001072:
; H043+$00001072: 6100f782  bsr.w $7f6
        bsr.w H043+$7F6
L043_00001076:
; H043+$00001076: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L043_0000107A:
; H043+$0000107A: 2f2b0006  move.l $6(a3), -(a7)
        move.l $6(a3), -(a7)
L043_0000107E:
; H043+$0000107E: 6100f844  bsr.w $8c4
        bsr.w H043+$8C4
; -> H079+$002E (wrapper_Disable)
L043_00001082:
; H043+$00001082: 4eb90000002e  jsr $2e.l
        jsr (H079+$2E).l
L043_00001088:
; H043+$00001088: 4a2d000c  tst.b $c(a5)
        tst.b $c(a5)
L043_0000108C:
; H043+$0000108C: 6700008a  beq.w $1118
        beq.w H043+$1118
L043_00001090:
; H043+$00001090: 7400  moveq #$0, d2
        moveq #0, d2
L043_00001092:
; H043+$00001092: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L043_00001096:
; H043+$00001096: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_0000109A:
; H043+$0000109A: 06420010  addi.w #$10, d2
        addi.w #$10, d2
L043_0000109E:
; H043+$0000109E: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L043_000010A2:
; H043+$000010A2: 1742000e  move.b d2, $e(a3)
        move.b d2, $e(a3)
L043_000010A6:
; H043+$000010A6: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000010AA:
; H043+$000010AA: 246d000e  movea.l $e(a5), a2
        movea.l $e(a5), a2
L043_000010AE:
; H043+$000010AE: 24ab06a0  move.l $6a0(a3), (a2)
        move.l $6a0(a3), (a2)
L043_000010B2:
; H043+$000010B2: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000010B6:
; H043+$000010B6: 276d000e06a0  move.l $e(a5), $6a0(a3)
        move.l $e(a5), $6a0(a3)
L043_000010BC:
; H043+$000010BC: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L043_000010C0:
; H043+$000010C0: 142b000e  move.b $e(a3), d2
        move.b $e(a3), d2
L043_000010C4:
; H043+$000010C4: 08020000  btst.b #$0, d2
        btst #$0, d2
L043_000010C8:
; H043+$000010C8: 6700004a  beq.w $1114
        beq.w H043+$1114
L043_000010CC:
; H043+$000010CC: 266d000e  movea.l $e(a5), a3
        movea.l $e(a5), a3
L043_000010D0:
; H043+$000010D0: 2b6b0006fffc  move.l $6(a3), -$4(a5)
        move.l $6(a3), -$4(a5)
L043_000010D6:
; H043+$000010D6: 426dfffa  clr.w -$6(a5)
        clr.w -$6(a5)
L043_000010DA:
; H043+$000010DA: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L043_000010DE:
; H043+$000010DE: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_000010E2:
; H043+$000010E2: b453  cmp.w (a3), d2
        cmp.w (a3), d2
L043_000010E4:
; H043+$000010E4: 6c00002e  bge.w $1114
        bge.w H043+$1114
L043_000010E8:
; H043+$000010E8: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L043_000010EC:
; H043+$000010EC: e542  asl.w #$2, d2
        asl.w #$2, d2
L043_000010EE:
; H043+$000010EE: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_000010F2:
; H043+$000010F2: 47eb0004  lea.l $4(a3), a3
        lea.l $4(a3), a3
L043_000010F6:
; H043+$000010F6: 2b732000fff6  move.l (a3, d2.w), -$a(a5)
        move.l (a3, d2.w), -$a(a5)
L043_000010FC:
; H043+$000010FC: 4aadfff6  tst.l -$a(a5)
        tst.l -$a(a5)
L043_00001100:
; H043+$00001100: 6700000c  beq.w $110e
        beq.w H043+$110E
L043_00001104:
; H043+$00001104: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00001108:
; H043+$00001108: 246dfff6  movea.l -$a(a5), a2
        movea.l -$a(a5), a2
L043_0000110C:
; H043+$0000110C: 2493  move.l (a3), (a2)
        move.l (a3), (a2)
L043_0000110E:
; H043+$0000110E: 526dfffa  addq.w #$1, -$6(a5)
        addq.w #$1, -$6(a5)
L043_00001112:
; H043+$00001112: 60c6  bra.b $10da
        bra.b H043+$10DA
L043_00001114:
; H043+$00001114: 60000018  bra.w $112e
        bra.w H043+$112E
L043_00001118:
; H043+$00001118: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000111C:
; H043+$0000111C: 246d000e  movea.l $e(a5), a2
        movea.l $e(a5), a2
L043_00001120:
; H043+$00001120: 24ab06a4  move.l $6a4(a3), (a2)
        move.l $6a4(a3), (a2)
L043_00001124:
; H043+$00001124: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00001128:
; H043+$00001128: 276d000e06a4  move.l $e(a5), $6a4(a3)
        move.l $e(a5), $6a4(a3)
; -> H079+$0036 (wrapper_Enable)
L043_0000112E:
; H043+$0000112E: 4eb900000036  jsr $36.l
        jsr (H079+$36).l
L043_00001134:
; H043+$00001134: 4e5d  unlk a5
        unlk a5
L043_00001136:
; H043+$00001136: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00001138:
; H043+$00001138: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_0000113A:
; H043+$0000113A: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L043_0000113C:
; H043+$0000113C: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_0000113E [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H026+$003A, H026+$0188, H026+$01E0, H002+$00F2.
;   - Calls H026+$003A.
;   - Calls H026+$0188.
;   - Calls H026+$01E0.
;   - Calls H002+$00F2.
;   - Calls H002+$0156.
;   - Calls H026+$0088.
;   - Calls H002+$0014.
; Direct callers: H043+$19B4, H043+$19EA
; --------------------------------------------------------------------------
L043_0000113E:
; H043+$0000113E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_00001140:
; H043+$00001140: 287af076  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00001144:
; H043+$00001144: 4e55ff94  link.w a5, #$ff94
        link.w a5, #$ff94
L043_00001148:
; H043+$00001148: 422dff95  clr.b -$6b(a5)
        clr.b -$6b(a5)
L043_0000114C:
; H043+$0000114C: 42adff96  clr.l -$6a(a5)
        clr.l -$6a(a5)
L043_00001150:
; H043+$00001150: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00001154:
; H043+$00001154: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H026+$003A (sub_H026_0000003A)
L043_00001158:
; H043+$00001158: 4eb90000003a  jsr $3a.l
        jsr (H026+$3A).l
L043_0000115E:
; H043+$0000115E: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001162:
; H043+$00001162: 6100fdec  bsr.w $f50
        bsr.w H043+$F50
L043_00001166:
; H043+$00001166: 2b40ff96  move.l d0, -$6a(a5)
        move.l d0, -$6a(a5)
L043_0000116A:
; H043+$0000116A: 4aadff96  tst.l -$6a(a5)
        tst.l -$6a(a5)
L043_0000116E:
; H043+$0000116E: 66000416  bne.w $1586
        bne.w H043+$1586
L043_00001172:
; H043+$00001172: 42adff9a  clr.l -$66(a5)
        clr.l -$66(a5)
L043_00001176:
; H043+$00001176: 422dffaa  clr.b -$56(a5)
        clr.b -$56(a5)
L043_0000117A:
; H043+$0000117A: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_0000117E:
; H043+$0000117E: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L043_00001182:
; H043+$00001182: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00001186:
; H043+$00001186: 486cffa8  pea.l -$58(a4)
        pea.l -$58(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000118A:
; H043+$0000118A: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00001190:
; H043+$00001190: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00001194:
; H043+$00001194: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L043_00001198:
; H043+$00001198: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_0000119C:
; H043+$0000119C: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H026+$01E0 (sub_H026_000001E0)
L043_000011A0:
; H043+$000011A0: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L043_000011A6:
; H043+$000011A6: 47edffd4  lea.l -$2c(a5), a3
        lea.l -$2c(a5), a3
L043_000011AA:
; H043+$000011AA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000011AC:
; H043+$000011AC: 2f3c000003ed  move.l #MODE_OLDFILE, -(a7)
        move.l #MODE_OLDFILE, -(a7)
; -> H002+$00F2 (wrapper_Open)
L043_000011B2:
; H043+$000011B2: 4eb9000000f2  jsr $f2.l
        jsr (H002+$F2).l
L043_000011B8:
; H043+$000011B8: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L043_000011BC:
; H043+$000011BC: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L043_000011C0:
; H043+$000011C0: 66000058  bne.w $121a
        bne.w H043+$121A
L043_000011C4:
; H043+$000011C4: 4a2cffff  tst.b -$1(a4)
        tst.b -$1(a4)
L043_000011C8:
; H043+$000011C8: 66000050  bne.w $121a
        bne.w H043+$121A
L043_000011CC:
; H043+$000011CC: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000011D0:
; H043+$000011D0: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L043_000011D4:
; H043+$000011D4: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000011D8:
; H043+$000011D8: 486cffa8  pea.l -$58(a4)
        pea.l -$58(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000011DC:
; H043+$000011DC: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000011E2:
; H043+$000011E2: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000011E6:
; H043+$000011E6: 486dffd4  pea.l -$2c(a5)
        pea.l -$2c(a5)
L043_000011EA:
; H043+$000011EA: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L043_000011EE:
; H043+$000011EE: 486c007f  pea.l $7f(a4)
        pea.l $7f(a4)
; -> H026+$01E0 (sub_H026_000001E0)
L043_000011F2:
; H043+$000011F2: 4eb9000001e0  jsr $1e0.l
        jsr (H026+$1E0).l
L043_000011F8:
; H043+$000011F8: 47edffd4  lea.l -$2c(a5), a3
        lea.l -$2c(a5), a3
L043_000011FC:
; H043+$000011FC: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000011FE:
; H043+$000011FE: 2f3c000003ed  move.l #MODE_OLDFILE, -(a7)
        move.l #MODE_OLDFILE, -(a7)
; -> H002+$00F2 (wrapper_Open)
L043_00001204:
; H043+$00001204: 4eb9000000f2  jsr $f2.l
        jsr (H002+$F2).l
L043_0000120A:
; H043+$0000120A: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L043_0000120E:
; H043+$0000120E: 197c0001ffff  move.b #$1, -$1(a4)
        move.b #$1, -$1(a4)
L043_00001214:
; H043+$00001214: 1b7c0001ff95  move.b #$1, -$6b(a5)
        move.b #$1, -$6b(a5)
L043_0000121A:
; H043+$0000121A: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L043_0000121E:
; H043+$0000121E: 6600000c  bne.w $122c
        bne.w H043+$122C
L043_00001222:
; H043+$00001222: 197c0001fffc  move.b #$1, -$4(a4)
        move.b #$1, -$4(a4)
L043_00001228:
; H043+$00001228: 60000350  bra.w $157a
        bra.w H043+$157A
L043_0000122C:
; H043+$0000122C: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001230:
; H043+$00001230: 42a7  clr.l -(a7)
        clr.l -(a7)
L043_00001232:
; H043+$00001232: 2f3c00000001  move.l #$1, -(a7)
        move.l #$1, -(a7)
; -> H002+$0156 (wrapper_Seek)
L043_00001238:
; H043+$00001238: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L043_0000123E:
; H043+$0000123E: 2b40ffa2  move.l d0, -$5e(a5)
        move.l d0, -$5e(a5)
L043_00001242:
; H043+$00001242: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001246:
; H043+$00001246: 42a7  clr.l -(a7)
        clr.l -(a7)
L043_00001248:
; H043+$00001248: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H002+$0156 (wrapper_Seek)
L043_0000124E:
; H043+$0000124E: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L043_00001254:
; H043+$00001254: 2b40ffa2  move.l d0, -$5e(a5)
        move.l d0, -$5e(a5)
L043_00001258:
; H043+$00001258: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_0000125C:
; H043+$0000125C: 42a7  clr.l -(a7)
        clr.l -(a7)
L043_0000125E:
; H043+$0000125E: 6100f026  bsr.w $286
        bsr.w H043+$286
L043_00001262:
; H043+$00001262: 4aadffa2  tst.l -$5e(a5)
        tst.l -$5e(a5)
L043_00001266:
; H043+$00001266: 6f0002fc  ble.w $1564
        ble.w H043+$1564
L043_0000126A:
; H043+$0000126A: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_0000126E:
; H043+$0000126E: 660002f4  bne.w $1564
        bne.w H043+$1564
L043_00001272:
; H043+$00001272: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001276:
; H043+$00001276: 47edffa6  lea.l -$5a(a5), a3
        lea.l -$5a(a5), a3
L043_0000127A:
; H043+$0000127A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_0000127C:
; H043+$0000127C: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_00001282:
; H043+$00001282: 6100f040  bsr.w $2c4
        bsr.w H043+$2C4
L043_00001286:
; H043+$00001286: 59adffa2  subq.l #$4, -$5e(a5)
        subq.l #$4, -$5e(a5)
L043_0000128A:
; H043+$0000128A: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_0000128E:
; H043+$0000128E: 486dffa6  pea.l -$5a(a5)
        pea.l -$5a(a5)
L043_00001292:
; H043+$00001292: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001296:
; H043+$00001296: 486c0012  pea.l $12(a4)
        pea.l $12(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_0000129A:
; H043+$0000129A: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_000012A0:
; H043+$000012A0: 1400  move.b d0, d2
        move.b d0, d2
L043_000012A2:
; H043+$000012A2: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_000012A6:
; H043+$000012A6: 6600005e  bne.w $1306
        bne.w H043+$1306
L043_000012AA:
; H043+$000012AA: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_000012AE:
; H043+$000012AE: 47edff9e  lea.l -$62(a5), a3
        lea.l -$62(a5), a3
L043_000012B2:
; H043+$000012B2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000012B4:
; H043+$000012B4: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_000012BA:
; H043+$000012BA: 6100f008  bsr.w $2c4
        bsr.w H043+$2C4
L043_000012BE:
; H043+$000012BE: 59adffa2  subq.l #$4, -$5e(a5)
        subq.l #$4, -$5e(a5)
L043_000012C2:
; H043+$000012C2: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_000012C6:
; H043+$000012C6: 47edffac  lea.l -$54(a5), a3
        lea.l -$54(a5), a3
L043_000012CA:
; H043+$000012CA: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000012CC:
; H043+$000012CC: 2f2dff9e  move.l -$62(a5), -(a7)
        move.l -$62(a5), -(a7)
L043_000012D0:
; H043+$000012D0: 6100eff2  bsr.w $2c4
        bsr.w H043+$2C4
L043_000012D4:
; H043+$000012D4: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000012D8:
; H043+$000012D8: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
; -> H026+$003A (sub_H026_0000003A)
L043_000012DC:
; H043+$000012DC: 4eb90000003a  jsr $3a.l
        jsr (H026+$3A).l
L043_000012E2:
; H043+$000012E2: 242dff9e  move.l -$62(a5), d2
        move.l -$62(a5), d2
L043_000012E6:
; H043+$000012E6: 95adffa2  sub.l d2, -$5e(a5)
        sub.l d2, -$5e(a5)
L043_000012EA:
; H043+$000012EA: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_000012EE:
; H043+$000012EE: 47edffa6  lea.l -$5a(a5), a3
        lea.l -$5a(a5), a3
L043_000012F2:
; H043+$000012F2: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000012F4:
; H043+$000012F4: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_000012FA:
; H043+$000012FA: 6100efc8  bsr.w $2c4
        bsr.w H043+$2C4
L043_000012FE:
; H043+$000012FE: 59adffa2  subq.l #$4, -$5e(a5)
        subq.l #$4, -$5e(a5)
L043_00001302:
; H043+$00001302: 60000018  bra.w $131c
        bra.w H043+$131C
L043_00001306:
; H043+$00001306: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_0000130A:
; H043+$0000130A: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L043_0000130E:
; H043+$0000130E: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00001312:
; H043+$00001312: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H026+$0188 (sub_H026_00000188)
L043_00001316:
; H043+$00001316: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000131C:
; H043+$0000131C: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001320:
; H043+$00001320: 486dffa6  pea.l -$5a(a5)
        pea.l -$5a(a5)
L043_00001324:
; H043+$00001324: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001328:
; H043+$00001328: 486c000d  pea.l $d(a4)
        pea.l $d(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_0000132C:
; H043+$0000132C: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00001332:
; H043+$00001332: 1400  move.b d0, d2
        move.b d0, d2
L043_00001334:
; H043+$00001334: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00001338:
; H043+$00001338: 67000008  beq.w $1342
        beq.w H043+$1342
L043_0000133C:
; H043+$0000133C: 197c0001fffc  move.b #$1, -$4(a4)
        move.b #$1, -$4(a4)
L043_00001342:
; H043+$00001342: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001346:
; H043+$00001346: 47edff9e  lea.l -$62(a5), a3
        lea.l -$62(a5), a3
L043_0000134A:
; H043+$0000134A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_0000134C:
; H043+$0000134C: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_00001352:
; H043+$00001352: 6100ef70  bsr.w $2c4
        bsr.w H043+$2C4
L043_00001356:
; H043+$00001356: 59adffa2  subq.l #$4, -$5e(a5)
        subq.l #$4, -$5e(a5)
L043_0000135A:
; H043+$0000135A: 242dff9e  move.l -$62(a5), d2
        move.l -$62(a5), d2
L043_0000135E:
; H043+$0000135E: 95adffa2  sub.l d2, -$5e(a5)
        sub.l d2, -$5e(a5)
L043_00001362:
; H043+$00001362: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L043_00001366:
; H043+$00001366: 6100fbe8  bsr.w $f50
        bsr.w H043+$F50
L043_0000136A:
; H043+$0000136A: 2400  move.l d0, d2
        move.l d0, d2
L043_0000136C:
; H043+$0000136C: 4a82  tst.l d2
        tst.l d2
L043_0000136E:
; H043+$0000136E: 67000012  beq.w $1382
        beq.w H043+$1382
L043_00001372:
; H043+$00001372: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001376:
; H043+$00001376: 2f2dff9e  move.l -$62(a5), -(a7)
        move.l -$62(a5), -(a7)
L043_0000137A:
; H043+$0000137A: 6100ef0a  bsr.w $286
        bsr.w H043+$286
L043_0000137E:
; H043+$0000137E: 600001e0  bra.w $1560
        bra.w H043+$1560
L043_00001382:
; H043+$00001382: 2f3c00000010  move.l #$10, -(a7)
        move.l #$10, -(a7)
L043_00001388:
; H043+$00001388: 6100ee8a  bsr.w $214
        bsr.w H043+$214
L043_0000138C:
; H043+$0000138C: 2b40ff96  move.l d0, -$6a(a5)
        move.l d0, -$6a(a5)
L043_00001390:
; H043+$00001390: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001394:
; H043+$00001394: 47edffa6  lea.l -$5a(a5), a3
        lea.l -$5a(a5), a3
L043_00001398:
; H043+$00001398: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_0000139A:
; H043+$0000139A: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
L043_000013A0:
; H043+$000013A0: 6100ef22  bsr.w $2c4
        bsr.w H043+$2C4
L043_000013A4:
; H043+$000013A4: 59adff9e  subq.l #$4, -$62(a5)
        subq.l #$4, -$62(a5)
L043_000013A8:
; H043+$000013A8: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_000013AC:
; H043+$000013AC: 66000122  bne.w $14d0
        bne.w H043+$14D0
L043_000013B0:
; H043+$000013B0: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_000013B4:
; H043+$000013B4: 486dffa6  pea.l -$5a(a5)
        pea.l -$5a(a5)
L043_000013B8:
; H043+$000013B8: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_000013BC:
; H043+$000013BC: 486c0017  pea.l $17(a4)
        pea.l $17(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_000013C0:
; H043+$000013C0: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_000013C6:
; H043+$000013C6: 1400  move.b d0, d2
        move.b d0, d2
L043_000013C8:
; H043+$000013C8: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_000013CC:
; H043+$000013CC: 66000024  bne.w $13f2
        bne.w H043+$13F2
L043_000013D0:
; H043+$000013D0: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_000013D4:
; H043+$000013D4: 2f2dff9e  move.l -$62(a5), -(a7)
        move.l -$62(a5), -(a7)
L043_000013D8:
; H043+$000013D8: 6100f5ac  bsr.w $986
        bsr.w H043+$986
L043_000013DC:
; H043+$000013DC: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_000013E0:
; H043+$000013E0: 27400006  move.l d0, $6(a3)
        move.l d0, $6(a3)
L043_000013E4:
; H043+$000013E4: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_000013E8:
; H043+$000013E8: 177c0001000e  move.b #$1, $e(a3)
        move.b #$1, $e(a3)
L043_000013EE:
; H043+$000013EE: 600000ce  bra.w $14be
        bra.w H043+$14BE
L043_000013F2:
; H043+$000013F2: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_000013F6:
; H043+$000013F6: 486dffa6  pea.l -$5a(a5)
        pea.l -$5a(a5)
L043_000013FA:
; H043+$000013FA: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_000013FE:
; H043+$000013FE: 486c0030  pea.l $30(a4)
        pea.l $30(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00001402:
; H043+$00001402: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00001408:
; H043+$00001408: 1400  move.b d0, d2
        move.b d0, d2
L043_0000140A:
; H043+$0000140A: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_0000140E:
; H043+$0000140E: 66000024  bne.w $1434
        bne.w H043+$1434
L043_00001412:
; H043+$00001412: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001416:
; H043+$00001416: 2f2dff9e  move.l -$62(a5), -(a7)
        move.l -$62(a5), -(a7)
L043_0000141A:
; H043+$0000141A: 6100f796  bsr.w $bb2
        bsr.w H043+$BB2
L043_0000141E:
; H043+$0000141E: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_00001422:
; H043+$00001422: 27400006  move.l d0, $6(a3)
        move.l d0, $6(a3)
L043_00001426:
; H043+$00001426: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_0000142A:
; H043+$0000142A: 177c0004000e  move.b #$4, $e(a3)
        move.b #$4, $e(a3)
L043_00001430:
; H043+$00001430: 6000008c  bra.w $14be
        bra.w H043+$14BE
L043_00001434:
; H043+$00001434: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001438:
; H043+$00001438: 486dffa6  pea.l -$5a(a5)
        pea.l -$5a(a5)
L043_0000143C:
; H043+$0000143C: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001440:
; H043+$00001440: 486c0026  pea.l $26(a4)
        pea.l $26(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00001444:
; H043+$00001444: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_0000144A:
; H043+$0000144A: 1400  move.b d0, d2
        move.b d0, d2
L043_0000144C:
; H043+$0000144C: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00001450:
; H043+$00001450: 66000024  bne.w $1476
        bne.w H043+$1476
L043_00001454:
; H043+$00001454: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_00001458:
; H043+$00001458: 2f2dff9e  move.l -$62(a5), -(a7)
        move.l -$62(a5), -(a7)
L043_0000145C:
; H043+$0000145C: 6100f926  bsr.w $d84
        bsr.w H043+$D84
L043_00001460:
; H043+$00001460: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_00001464:
; H043+$00001464: 27400006  move.l d0, $6(a3)
        move.l d0, $6(a3)
L043_00001468:
; H043+$00001468: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_0000146C:
; H043+$0000146C: 177c0002000e  move.b #$2, $e(a3)
        move.b #$2, $e(a3)
L043_00001472:
; H043+$00001472: 6000004a  bra.w $14be
        bra.w H043+$14BE
L043_00001476:
; H043+$00001476: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_0000147A:
; H043+$0000147A: 486dffa6  pea.l -$5a(a5)
        pea.l -$5a(a5)
L043_0000147E:
; H043+$0000147E: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001482:
; H043+$00001482: 486c0044  pea.l $44(a4)
        pea.l $44(a4)
; -> H026+$0088 (sub_H026_00000088)
L043_00001486:
; H043+$00001486: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_0000148C:
; H043+$0000148C: 1400  move.b d0, d2
        move.b d0, d2
L043_0000148E:
; H043+$0000148E: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_00001492:
; H043+$00001492: 66000024  bne.w $14b8
        bne.w H043+$14B8
L043_00001496:
; H043+$00001496: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L043_0000149A:
; H043+$0000149A: 2f2dff9e  move.l -$62(a5), -(a7)
        move.l -$62(a5), -(a7)
L043_0000149E:
; H043+$0000149E: 6100f89a  bsr.w $d3a
        bsr.w H043+$D3A
L043_000014A2:
; H043+$000014A2: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_000014A6:
; H043+$000014A6: 27400006  move.l d0, $6(a3)
        move.l d0, $6(a3)
L043_000014AA:
; H043+$000014AA: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_000014AE:
; H043+$000014AE: 177c0040000e  move.b #$40, $e(a3)
        move.b #$40, $e(a3)
L043_000014B4:
; H043+$000014B4: 60000008  bra.w $14be
        bra.w H043+$14BE
L043_000014B8:
; H043+$000014B8: 197c0001fffc  move.b #$1, -$4(a4)
        move.b #$1, -$4(a4)
L043_000014BE:
; H043+$000014BE: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_000014C2:
; H043+$000014C2: 4aab0006  tst.l $6(a3)
        tst.l $6(a3)
L043_000014C6:
; H043+$000014C6: 66000008  bne.w $14d0
        bne.w H043+$14D0
L043_000014CA:
; H043+$000014CA: 197c0001fffc  move.b #$1, -$4(a4)
        move.b #$1, -$4(a4)
L043_000014D0:
; H043+$000014D0: 4a2cfffc  tst.b -$4(a4)
        tst.b -$4(a4)
L043_000014D4:
; H043+$000014D4: 67000014  beq.w $14ea
        beq.w H043+$14EA
L043_000014D8:
; H043+$000014D8: 486dff96  pea.l -$6a(a5)
        pea.l -$6a(a5)
L043_000014DC:
; H043+$000014DC: 6100efd8  bsr.w $4b6
        bsr.w H043+$4B6
L043_000014E0:
; H043+$000014E0: 7000  moveq #$0, d0
        moveq #0, d0
L043_000014E2:
; H043+$000014E2: 600000b6  bra.w $159a
        bra.w H043+$159A
; Preserved bytes H043+$000014E6..$000014EA; code/data not fully classified.
        dc.w $6000,$0078
L043_000014EA:
; H043+$000014EA: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_000014EE:
; H043+$000014EE: 526b0004  addq.w #$1, $4(a3)
        addq.w #$1, $4(a3)
L043_000014F2:
; H043+$000014F2: 266dff96  movea.l -$6a(a5), a3
        movea.l -$6a(a5), a3
L043_000014F6:
; H043+$000014F6: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_000014F8:
; H043+$000014F8: 7428  moveq #$28, d2
        moveq #40, d2
L043_000014FA:
; H043+$000014FA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L043_000014FC:
; H043+$000014FC: 6100ed16  bsr.w $214
        bsr.w H043+$214
L043_00001500:
; H043+$00001500: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_00001502:
; H043+$00001502: 2740000a  move.l d0, $a(a3)
        move.l d0, $a(a3)
L043_00001506:
; H043+$00001506: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L043_00001508:
; H043+$00001508: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_0000150C:
; H043+$0000150C: 2f2b000a  move.l $a(a3), -(a7)
        move.l $a(a3), -(a7)
L043_00001510:
; H043+$00001510: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00001514:
; H043+$00001514: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
; -> H026+$0188 (sub_H026_00000188)
L043_00001518:
; H043+$00001518: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000151E:
; H043+$0000151E: 265f  movea.l (a7)+, a3
        movea.l (a7)+, a3
L043_00001520:
; H043+$00001520: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_00001524:
; H043+$00001524: 486dffac  pea.l -$54(a5)
        pea.l -$54(a5)
L043_00001528:
; H043+$00001528: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_0000152C:
; H043+$0000152C: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
; -> H026+$0088 (sub_H026_00000088)
L043_00001530:
; H043+$00001530: 4eb900000088  jsr $88.l
        jsr (H026+$88).l
L043_00001536:
; H043+$00001536: 1400  move.b d0, d2
        move.b d0, d2
L043_00001538:
; H043+$00001538: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L043_0000153C:
; H043+$0000153C: 66000018  bne.w $1556
        bne.w H043+$1556
L043_00001540:
; H043+$00001540: 2f2dff96  move.l -$6a(a5), -(a7)
        move.l -$6a(a5), -(a7)
L043_00001544:
; H043+$00001544: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L043_00001548:
; H043+$00001548: 6100fb0e  bsr.w $1058
        bsr.w H043+$1058
L043_0000154C:
; H043+$0000154C: 2b6dff96ff9a  move.l -$6a(a5), -$66(a5)
        move.l -$6a(a5), -$66(a5)
L043_00001552:
; H043+$00001552: 6000000c  bra.w $1560
        bra.w H043+$1560
L043_00001556:
; H043+$00001556: 2f2dff96  move.l -$6a(a5), -(a7)
        move.l -$6a(a5), -(a7)
L043_0000155A:
; H043+$0000155A: 4227  clr.b -(a7)
        clr.b -(a7)
L043_0000155C:
; H043+$0000155C: 6100fafa  bsr.w $1058
        bsr.w H043+$1058
L043_00001560:
; H043+$00001560: 6000fd00  bra.w $1262
        bra.w H043+$1262
L043_00001564:
; H043+$00001564: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L043_00001568:
; H043+$00001568: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
L043_0000156E:
; H043+$0000156E: 4a2dff95  tst.b -$6b(a5)
        tst.b -$6b(a5)
L043_00001572:
; H043+$00001572: 67000006  beq.w $157a
        beq.w H043+$157A
L043_00001576:
; H043+$00001576: 422cffff  clr.b -$1(a4)
        clr.b -$1(a4)
L043_0000157A:
; H043+$0000157A: 202dff9a  move.l -$66(a5), d0
        move.l -$66(a5), d0
L043_0000157E:
; H043+$0000157E: 6000001a  bra.w $159a
        bra.w H043+$159A
; Preserved bytes H043+$00001582..$00001586; code/data not fully classified.
        dc.w $6000,$0016
L043_00001586:
; H043+$00001586: 2f2dff96  move.l -$6a(a5), -(a7)
        move.l -$6a(a5), -(a7)
L043_0000158A:
; H043+$0000158A: 1f2d000c  move.b $c(a5), -(a7)
        move.b $c(a5), -(a7)
L043_0000158E:
; H043+$0000158E: 6100fac8  bsr.w $1058
        bsr.w H043+$1058
L043_00001592:
; H043+$00001592: 202dff96  move.l -$6a(a5), d0
        move.l -$6a(a5), d0
L043_00001596:
; H043+$00001596: 60000002  bra.w $159a
        bra.w H043+$159A
L043_0000159A:
; H043+$0000159A: 4e5d  unlk a5
        unlk a5
L043_0000159C:
; H043+$0000159C: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_0000159E:
; H043+$0000159E: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_000015A0:
; H043+$000015A0: 5c8f  addq.l #$6, a7
        addq.l #$6, a7
L043_000015A2:
; H043+$000015A2: 4ed0  jmp (a0)
        jmp (a0)
; Preserved bytes H043+$000015A4..$000015C6; code/data not fully classified.
        dc.w $2F0C,$287A,$EC10,$4E55,$0000,$3F3C,$0027,$2F2D
        dc.w $000C,$4EB9
        dc.l H026+$0000003A
        dc.w $4E5D,$285F,$205F,$588F,$4ED0
; --------------------------------------------------------------------------
; ROUTINE: sub_H043_000015C6 [partial]
; Purpose: Routine of the audio.device subsystem and sound requests module; calls H079+$002E, H079+$0036, H020+$085A, H020+$08C2.
;   - Calls H079+$002E.
;   - Calls H079+$0036.
;   - Calls H020+$085A.
;   - Calls H020+$08C2.
;   - Calls H020+$082E.
;   - Calls H010+$0332.
; Direct callers: H043+$1922, H043+$1932
; --------------------------------------------------------------------------
L043_000015C6:
; H043+$000015C6: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_000015C8:
; H043+$000015C8: 287aebee  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000015CC:
; H043+$000015CC: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
; -> H079+$002E (wrapper_Disable)
L043_000015D0:
; H043+$000015D0: 4eb90000002e  jsr $2e.l
        jsr (H079+$2E).l
L043_000015D6:
; H043+$000015D6: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_000015DA:
; H043+$000015DA: 2b6b06a0fffc  move.l $6a0(a3), -$4(a5)
        move.l $6a0(a3), -$4(a5)
L043_000015E0:
; H043+$000015E0: 4aadfffc  tst.l -$4(a5)
        tst.l -$4(a5)
L043_000015E4:
; H043+$000015E4: 67000026  beq.w $160c
        beq.w H043+$160C
L043_000015E8:
; H043+$000015E8: 7401  moveq #$1, d2
        moveq #1, d2
L043_000015EA:
; H043+$000015EA: e94a  lsl.w #$4, d2
        lsl.w #$4, d2
L043_000015EC:
; H043+$000015EC: 383c00ff  move.w #$ff, d4
        move.w #$ff, d4
L043_000015F0:
; H043+$000015F0: 9842  sub.w d2, d4
        sub.w d2, d4
L043_000015F2:
; H043+$000015F2: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_000015F6:
; H043+$000015F6: c82b000e  and.b $e(a3), d4
        and.b $e(a3), d4
L043_000015FA:
; H043+$000015FA: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_000015FE:
; H043+$000015FE: 1744000e  move.b d4, $e(a3)
        move.b d4, $e(a3)
L043_00001602:
; H043+$00001602: 266dfffc  movea.l -$4(a5), a3
        movea.l -$4(a5), a3
L043_00001606:
; H043+$00001606: 2b53fffc  move.l (a3), -$4(a5)
        move.l (a3), -$4(a5)
L043_0000160A:
; H043+$0000160A: 60d4  bra.b $15e0
        bra.b H043+$15E0
L043_0000160C:
; H043+$0000160C: 3b7c0003fffa  move.w #$3, -$6(a5)
        move.w #$3, -$6(a5)
L043_00001612:
; H043+$00001612: 4a6dfffa  tst.w -$6(a5)
        tst.w -$6(a5)
L043_00001616:
; H043+$00001616: 6d00002e  blt.w $1646
        blt.w H043+$1646
L043_0000161A:
; H043+$0000161A: 342dfffa  move.w -$6(a5), d2
        move.w -$6(a5), d2
L043_0000161E:
; H043+$0000161E: e542  asl.w #$2, d2
        asl.w #$2, d2
L043_00001620:
; H043+$00001620: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_00001624:
; H043+$00001624: 47eb0094  lea.l $94(a3), a3
        lea.l $94(a3), a3
L043_00001628:
; H043+$00001628: 2b732000fff6  move.l (a3, d2.w), -$a(a5)
        move.l (a3, d2.w), -$a(a5)
L043_0000162E:
; H043+$0000162E: 4aadfff6  tst.l -$a(a5)
        tst.l -$a(a5)
L043_00001632:
; H043+$00001632: 6700000c  beq.w $1640
        beq.w H043+$1640
L043_00001636:
; H043+$00001636: 7400  moveq #$0, d2
        moveq #0, d2
L043_00001638:
; H043+$00001638: 266dfff6  movea.l -$a(a5), a3
        movea.l -$a(a5), a3
L043_0000163C:
; H043+$0000163C: 27420018  move.l d2, $18(a3)
        move.l d2, $18(a3)
L043_00001640:
; H043+$00001640: 536dfffa  subq.w #$1, -$6(a5)
        subq.w #$1, -$6(a5)
L043_00001644:
; H043+$00001644: 60cc  bra.b $1612
        bra.b H043+$1612
L043_00001646:
; H043+$00001646: 266cff76  movea.l -$8a(a4), a3
        movea.l -$8a(a4), a3
L043_0000164A:
; H043+$0000164A: 42ab0254  clr.l $254(a3)
        clr.l $254(a3)
; -> H079+$0036 (wrapper_Enable)
L043_0000164E:
; H043+$0000164E: 4eb900000036  jsr $36.l
        jsr (H079+$36).l
L043_00001654:
; H043+$00001654: 4e5d  unlk a5
        unlk a5
L043_00001656:
; H043+$00001656: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00001658:
; H043+$00001658: 4e75  rts 
        rts 
L043_0000165A:
; H043+$0000165A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_0000165C:
; H043+$0000165C: 287aeb5a  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00001660:
; H043+$00001660: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_00001664:
; H043+$00001664: 3f3c001e  move.w #$1e, -(a7)
        move.w #$1e, -(a7)
L043_00001668:
; H043+$00001668: 486c0089  pea.l $89(a4)
        pea.l $89(a4)
; -> H020+$085A (sub_H020_0000085A)
L043_0000166C:
; H043+$0000166C: 4eb90000085a  jsr $85a.l
        jsr (H020+$85A).l
L043_00001672:
; H043+$00001672: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L043_00001676:
; H043+$00001676: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
; -> H020+$08C2 (sub_H020_000008C2)
L043_0000167A:
; H043+$0000167A: 4eb9000008c2  jsr $8c2.l
        jsr (H020+$8C2).l
; -> H020+$082E (trampoline_H020_0856)
L043_00001680:
; H043+$00001680: 4eb90000082e  jsr $82e.l
        jsr (H020+$82E).l
; FLOW: Calls Audio_Shutdown (H043+$0840).
L043_00001686:
; H043+$00001686: 6100f1b8  bsr.w $840
        bsr.w H043+$840
; -> H010+$0332 (sub_H010_00000332)
L043_0000168A:
; H043+$0000168A: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L043_00001690:
; H043+$00001690: 4e5d  unlk a5
        unlk a5
L043_00001692:
; H043+$00001692: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00001694:
; H043+$00001694: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_00001696:
; H043+$00001696: 548f  addq.l #$2, a7
        addq.l #$2, a7
L043_00001698:
; H043+$00001698: 4ed0  jmp (a0)
        jmp (a0)
; --------------------------------------------------------------------------
; ROUTINE: trampoline_H043_18EC [partial]
; Purpose: Trampoline to H043+$18EC; the actual body is there.
;   - Jumps to the actual body at H043+$18EC.
; Direct callers: H043+$19AA, H043+$19DE
; --------------------------------------------------------------------------
L043_0000169A:
; H043+$0000169A: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L043_0000169C:
; H043+$0000169C: 287aeb1a  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_000016A0:
; H043+$000016A0: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_000016A4:
; H043+$000016A4: 342d000c  move.w $c(a5), d2
        move.w $c(a5), d2
L043_000016A8:
; H043+$000016A8: 60000242  bra.w $18ec
        bra.w H043+$18EC
L043_000016AC:
; H043+$000016AC: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000016B0:
; H043+$000016B0: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000016B4:
; H043+$000016B4: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_000016B8:
; H043+$000016B8: 486c00a8  pea.l $a8(a4)
        pea.l $a8(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000016BC:
; H043+$000016BC: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000016C2:
; H043+$000016C2: 4e75  rts 
        rts 
L043_000016C4:
; H043+$000016C4: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000016C8:
; H043+$000016C8: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000016CC:
; H043+$000016CC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_000016D0:
; H043+$000016D0: 486c00ad  pea.l $ad(a4)
        pea.l $ad(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000016D4:
; H043+$000016D4: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000016DA:
; H043+$000016DA: 4e75  rts 
        rts 
L043_000016DC:
; H043+$000016DC: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000016E0:
; H043+$000016E0: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000016E4:
; H043+$000016E4: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_000016E8:
; H043+$000016E8: 486c00b3  pea.l $b3(a4)
        pea.l $b3(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000016EC:
; H043+$000016EC: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000016F2:
; H043+$000016F2: 4e75  rts 
        rts 
L043_000016F4:
; H043+$000016F4: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000016F8:
; H043+$000016F8: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000016FC:
; H043+$000016FC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001700:
; H043+$00001700: 486c00b9  pea.l $b9(a4)
        pea.l $b9(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_00001704:
; H043+$00001704: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000170A:
; H043+$0000170A: 4e75  rts 
        rts 
L043_0000170C:
; H043+$0000170C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001710:
; H043+$00001710: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001714:
; H043+$00001714: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001718:
; H043+$00001718: 486c00bf  pea.l $bf(a4)
        pea.l $bf(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000171C:
; H043+$0000171C: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00001722:
; H043+$00001722: 4e75  rts 
        rts 
L043_00001724:
; H043+$00001724: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001728:
; H043+$00001728: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_0000172C:
; H043+$0000172C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001730:
; H043+$00001730: 486c00c5  pea.l $c5(a4)
        pea.l $c5(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_00001734:
; H043+$00001734: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000173A:
; H043+$0000173A: 4e75  rts 
        rts 
L043_0000173C:
; H043+$0000173C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001740:
; H043+$00001740: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001744:
; H043+$00001744: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001748:
; H043+$00001748: 486c00cb  pea.l $cb(a4)
        pea.l $cb(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000174C:
; H043+$0000174C: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00001752:
; H043+$00001752: 4e75  rts 
        rts 
L043_00001754:
; H043+$00001754: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001758:
; H043+$00001758: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_0000175C:
; H043+$0000175C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001760:
; H043+$00001760: 486c00d1  pea.l $d1(a4)
        pea.l $d1(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_00001764:
; H043+$00001764: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000176A:
; H043+$0000176A: 4e75  rts 
        rts 
L043_0000176C:
; H043+$0000176C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001770:
; H043+$00001770: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001774:
; H043+$00001774: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001778:
; H043+$00001778: 486c00d7  pea.l $d7(a4)
        pea.l $d7(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000177C:
; H043+$0000177C: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00001782:
; H043+$00001782: 4e75  rts 
        rts 
L043_00001784:
; H043+$00001784: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001788:
; H043+$00001788: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_0000178C:
; H043+$0000178C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001790:
; H043+$00001790: 486c00dc  pea.l $dc(a4)
        pea.l $dc(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_00001794:
; H043+$00001794: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000179A:
; H043+$0000179A: 4e75  rts 
        rts 
L043_0000179C:
; H043+$0000179C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000017A0:
; H043+$000017A0: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000017A4:
; H043+$000017A4: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_000017A8:
; H043+$000017A8: 486c00e2  pea.l $e2(a4)
        pea.l $e2(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000017AC:
; H043+$000017AC: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000017B2:
; H043+$000017B2: 4e75  rts 
        rts 
L043_000017B4:
; H043+$000017B4: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000017B8:
; H043+$000017B8: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000017BC:
; H043+$000017BC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_000017C0:
; H043+$000017C0: 486c00e8  pea.l $e8(a4)
        pea.l $e8(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000017C4:
; H043+$000017C4: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000017CA:
; H043+$000017CA: 4e75  rts 
        rts 
L043_000017CC:
; H043+$000017CC: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000017D0:
; H043+$000017D0: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000017D4:
; H043+$000017D4: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L043_000017D8:
; H043+$000017D8: 486c00ee  pea.l $ee(a4)
        pea.l $ee(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000017DC:
; H043+$000017DC: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000017E2:
; H043+$000017E2: 4e75  rts 
        rts 
L043_000017E4:
; H043+$000017E4: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000017E8:
; H043+$000017E8: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000017EC:
; H043+$000017EC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_000017F0:
; H043+$000017F0: 486c00f2  pea.l $f2(a4)
        pea.l $f2(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000017F4:
; H043+$000017F4: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000017FA:
; H043+$000017FA: 4e75  rts 
        rts 
L043_000017FC:
; H043+$000017FC: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001800:
; H043+$00001800: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001804:
; H043+$00001804: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001808:
; H043+$00001808: 486c00f8  pea.l $f8(a4)
        pea.l $f8(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000180C:
; H043+$0000180C: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00001812:
; H043+$00001812: 4e75  rts 
        rts 
L043_00001814:
; H043+$00001814: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001818:
; H043+$00001818: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_0000181C:
; H043+$0000181C: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L043_00001820:
; H043+$00001820: 486c00fe  pea.l $fe(a4)
        pea.l $fe(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_00001824:
; H043+$00001824: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000182A:
; H043+$0000182A: 4e75  rts 
        rts 
L043_0000182C:
; H043+$0000182C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001830:
; H043+$00001830: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001834:
; H043+$00001834: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L043_00001838:
; H043+$00001838: 486c0102  pea.l $102(a4)
        pea.l $102(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000183C:
; H043+$0000183C: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00001842:
; H043+$00001842: 4e75  rts 
        rts 
L043_00001844:
; H043+$00001844: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001848:
; H043+$00001848: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_0000184C:
; H043+$0000184C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001850:
; H043+$00001850: 486c0109  pea.l $109(a4)
        pea.l $109(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_00001854:
; H043+$00001854: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000185A:
; H043+$0000185A: 4e75  rts 
        rts 
L043_0000185C:
; H043+$0000185C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001860:
; H043+$00001860: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001864:
; H043+$00001864: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001868:
; H043+$00001868: 486c010f  pea.l $10f(a4)
        pea.l $10f(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000186C:
; H043+$0000186C: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_00001872:
; H043+$00001872: 4e75  rts 
        rts 
L043_00001874:
; H043+$00001874: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001878:
; H043+$00001878: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_0000187C:
; H043+$0000187C: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001880:
; H043+$00001880: 486c0115  pea.l $115(a4)
        pea.l $115(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_00001884:
; H043+$00001884: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_0000188A:
; H043+$0000188A: 4e75  rts 
        rts 
L043_0000188C:
; H043+$0000188C: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_00001890:
; H043+$00001890: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_00001894:
; H043+$00001894: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L043_00001898:
; H043+$00001898: 486c011a  pea.l $11a(a4)
        pea.l $11a(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_0000189C:
; H043+$0000189C: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000018A2:
; H043+$000018A2: 4e75  rts 
        rts 
L043_000018A4:
; H043+$000018A4: 3f2d0012  move.w $12(a5), -(a7)
        move.w $12(a5), -(a7)
L043_000018A8:
; H043+$000018A8: 2f2d000e  move.l $e(a5), -(a7)
        move.l $e(a5), -(a7)
L043_000018AC:
; H043+$000018AC: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_000018B0:
; H043+$000018B0: 486c011f  pea.l $11f(a4)
        pea.l $11f(a4)
; -> H026+$0188 (sub_H026_00000188)
L043_000018B4:
; H043+$000018B4: 4eb900000188  jsr $188.l
        jsr (H026+$188).l
L043_000018BA:
; H043+$000018BA: 4e75  rts 
        rts 
L043_000018BC:
; H043+$000018BC: 4e75  rts 
        rts 
; Preserved bytes H043+$000018BE..$000018EC; code/data not fully classified.
        dc.w $FFFC,$FDEC,$FE04,$FE1C,$FE34,$FE4C,$FE64,$FE7C
        dc.w $FE94,$FEAC,$FEC4,$FEDC,$FEF4,$FF0C,$FF24,$FF3C
        dc.w $FF54,$FF6C,$FF84,$FF9C,$FFB4,$FFCC,$FFE4
L043_000018EC:
; H043+$000018EC: 47faffd2  lea.l $18c0(pc), a3
        lea.l H043+$18C0(pc), a3
L043_000018F0:
; H043+$000018F0: 5542  subq.w #$2, d2
        subq.w #$2, d2
L043_000018F2:
; H043+$000018F2: 0c420015  cmpi.w #$15, d2
        cmpi.w #$15, d2
L043_000018F6:
; H043+$000018F6: 6302  bls.b $18fa
        bls.b H043+$18FA
L043_000018F8:
; H043+$000018F8: 74ff  moveq #$ff, d2
        moveq #-1, d2
L043_000018FA:
; H043+$000018FA: e342  asl.w #$1, d2
        asl.w #$1, d2
L043_000018FC:
; H043+$000018FC: 34332000  move.w (a3, d2.w), d2
        move.w (a3, d2.w), d2
; DISPATCH: words relative to H043+$18C0; indices 0..21, default -1.
L043_00001900:
; H043+$00001900: 4eb32000  jsr (a3, d2.w)
        jsr (a3, d2.w)
L043_00001904:
; H043+$00001904: 4e5d  unlk a5
        unlk a5
L043_00001906:
; H043+$00001906: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00001908:
; H043+$00001908: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_0000190A:
; H043+$0000190A: 508f  addq.l #$8, a7
        addq.l #$8, a7
L043_0000190C:
; H043+$0000190C: 4ed0  jmp (a0)
        jmp (a0)
;
; --------------------------------------------------------------------------
; ROUTINE: Audio_Command [partial]
; Purpose: Dispatches a sound command/request.
;   - Handles special values for stop, activation and other operations.
;   - For the normal identifiers it prepares the name/resource and the playback request.
;   - The complete mapping between ID and sound is not established yet.
; Direct callers: H007+$0A76, H007+$0BB8, H007+$0BC2, H012+$07C2, H012+$07FE, H012+$0826, H012+$0868, H012+$08A4, H012+$08CC, H012+$08F4 ...
; --------------------------------------------------------------------------
L043_0000190E:
; H043+$0000190E: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
; FUNCTION: sound_control_body
FN_sound_control_body:
L043_00001910:
; H043+$00001910: 287ae8a6  movea.l $1b8(pc), a4
        movea.l H043+$1B8(pc), a4
L043_00001914:
; H043+$00001914: 4e550000  link.w a5, #$0
        link.w a5, #$0
L043_00001918:
; H043+$00001918: 0c6d00ff000c  cmpi.w #$ff, $c(a5)
        cmpi.w #$ff, $c(a5)
L043_0000191E:
; H043+$0000191E: 6600000a  bne.w $192a
        bne.w H043+$192A
L043_00001922:
; H043+$00001922: 6100fca2  bsr.w $15c6
        bsr.w H043+$15C6
L043_00001926:
; H043+$00001926: 600000ca  bra.w $19f2
        bra.w H043+$19F2
L043_0000192A:
; H043+$0000192A: 4a6d000c  tst.w $c(a5)
        tst.w $c(a5)
L043_0000192E:
; H043+$0000192E: 6600000e  bne.w $193e
        bne.w H043+$193E
L043_00001932:
; H043+$00001932: 6100fc92  bsr.w $15c6
        bsr.w H043+$15C6
L043_00001936:
; H043+$00001936: 422cfffb  clr.b -$5(a4)
        clr.b -$5(a4)
L043_0000193A:
; H043+$0000193A: 600000b6  bra.w $19f2
        bra.w H043+$19F2
L043_0000193E:
; H043+$0000193E: 0c6d0001000c  cmpi.w #$1, $c(a5)
        cmpi.w #$1, $c(a5)
L043_00001944:
; H043+$00001944: 6600000c  bne.w $1952
        bne.w H043+$1952
L043_00001948:
; H043+$00001948: 197c0001fffb  move.b #$1, -$5(a4)
        move.b #$1, -$5(a4)
L043_0000194E:
; H043+$0000194E: 600000a2  bra.w $19f2
        bra.w H043+$19F2
L043_00001952:
; H043+$00001952: 0c6d00fe000c  cmpi.w #$fe, $c(a5)
        cmpi.w #$fe, $c(a5)
L043_00001958:
; H043+$00001958: 66000026  bne.w $1980
        bne.w H043+$1980
L043_0000195C:
; H043+$0000195C: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001960:
; H043+$00001960: 486cff90  pea.l -$70(a4)
        pea.l -$70(a4)
; -> H079+$004E (wrapper_RemIntServer)
L043_00001964:
; H043+$00001964: 4eb90000004e  jsr $4e.l
        jsr (H079+$4E).l
L043_0000196A:
; H043+$0000196A: 6100ee8e  bsr.w $7fa
        bsr.w H043+$7FA
L043_0000196E:
; H043+$0000196E: 3f3c0005  move.w #$5, -(a7)
        move.w #$5, -(a7)
L043_00001972:
; H043+$00001972: 486cff90  pea.l -$70(a4)
        pea.l -$70(a4)
; -> H079+$0006 (wrapper_AddIntServer)
L043_00001976:
; H043+$00001976: 4eb900000006  jsr $6.l
        jsr (H079+$6).l
L043_0000197C:
; H043+$0000197C: 60000074  bra.w $19f2
        bra.w H043+$19F2
L043_00001980:
; H043+$00001980: 0c6d00fd000c  cmpi.w #$fd, $c(a5)
        cmpi.w #$fd, $c(a5)
L043_00001986:
; H043+$00001986: 6600003e  bne.w $19c6
        bne.w H043+$19C6
L043_0000198A:
; H043+$0000198A: 3b7c0001000c  move.w #$1, $c(a5)
        move.w #$1, $c(a5)
L043_00001990:
; H043+$00001990: 0c6d0016000c  cmpi.w #$16, $c(a5)
        cmpi.w #$16, $c(a5)
L043_00001996:
; H043+$00001996: 6200002a  bhi.w $19c2
        bhi.w H043+$19C2
L043_0000199A:
; H043+$0000199A: 422cfffc  clr.b -$4(a4)
        clr.b -$4(a4)
L043_0000199E:
; H043+$0000199E: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000019A2:
; H043+$000019A2: 486cffd0  pea.l -$30(a4)
        pea.l -$30(a4)
L043_000019A6:
; H043+$000019A6: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L043_000019AA:
; H043+$000019AA: 6100fcee  bsr.w $169a
        bsr.w H043+$169A
L043_000019AE:
; H043+$000019AE: 486cffd0  pea.l -$30(a4)
        pea.l -$30(a4)
L043_000019B2:
; H043+$000019B2: 4227  clr.b -(a7)
        clr.b -(a7)
L043_000019B4:
; H043+$000019B4: 6100f788  bsr.w $113e
        bsr.w H043+$113E
L043_000019B8:
; H043+$000019B8: 2940ff72  move.l d0, -$8e(a4)
        move.l d0, -$8e(a4)
L043_000019BC:
; H043+$000019BC: 526d000c  addq.w #$1, $c(a5)
        addq.w #$1, $c(a5)
L043_000019C0:
; H043+$000019C0: 64ce  bcc.b $1990
        bcc.b H043+$1990
L043_000019C2:
; H043+$000019C2: 6000002e  bra.w $19f2
        bra.w H043+$19F2
L043_000019C6:
; H043+$000019C6: 4a2cfffb  tst.b -$5(a4)
        tst.b -$5(a4)
L043_000019CA:
; H043+$000019CA: 67000026  beq.w $19f2
        beq.w H043+$19F2
L043_000019CE:
; H043+$000019CE: 422cfffc  clr.b -$4(a4)
        clr.b -$4(a4)
L043_000019D2:
; H043+$000019D2: 3f3c0027  move.w #$27, -(a7)
        move.w #$27, -(a7)
L043_000019D6:
; H043+$000019D6: 486cffd0  pea.l -$30(a4)
        pea.l -$30(a4)
L043_000019DA:
; H043+$000019DA: 3f2d000c  move.w $c(a5), -(a7)
        move.w $c(a5), -(a7)
L043_000019DE:
; H043+$000019DE: 6100fcba  bsr.w $169a
        bsr.w H043+$169A
L043_000019E2:
; H043+$000019E2: 486cffd0  pea.l -$30(a4)
        pea.l -$30(a4)
L043_000019E6:
; H043+$000019E6: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
L043_000019EA:
; H043+$000019EA: 6100f752  bsr.w $113e
        bsr.w H043+$113E
L043_000019EE:
; H043+$000019EE: 2940ff72  move.l d0, -$8e(a4)
        move.l d0, -$8e(a4)
L043_000019F2:
; H043+$000019F2: 4e5d  unlk a5
        unlk a5
L043_000019F4:
; H043+$000019F4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_000019F6:
; H043+$000019F6: 205f  movea.l (a7)+, a0
        movea.l (a7)+, a0
L043_000019F8:
; H043+$000019F8: 548f  addq.l #$2, a7
        addq.l #$2, a7
L043_000019FA:
; H043+$000019FA: 4ed0  jmp (a0)
        jmp (a0)
L043_000019FC:
; H043+$000019FC: 197c0001fffb  move.b #$1, -$5(a4)
        move.b #$1, -$5(a4)
L043_00001A02:
; H043+$00001A02: 422cfffe  clr.b -$2(a4)
        clr.b -$2(a4)
L043_00001A06:
; H043+$00001A06: 422cfffd  clr.b -$3(a4)
        clr.b -$3(a4)
L043_00001A0A:
; H043+$00001A0A: 42acff76  clr.l -$8a(a4)
        clr.l -$8a(a4)
L043_00001A0E:
; H043+$00001A0E: 422cffff  clr.b -$1(a4)
        clr.b -$1(a4)
L043_00001A12:
; H043+$00001A12: 4e5d  unlk a5
        unlk a5
L043_00001A14:
; H043+$00001A14: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L043_00001A16:
; H043+$00001A16: 4e75  rts 
        rts 
; End H043: $1A18 bytes
