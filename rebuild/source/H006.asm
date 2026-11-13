; ============================================================================
; MODULE GUIDE H006
; Preparation of environment, paths, state and common resources.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; Prepares paths, assignments, persistent buffers and shared resources. The four main buffers are H005+$3E04 (2048 bytes), H005+$3E00 (2048), H005+$3DFC (1024) and H005+$3DF8 (7680, ECL program).
; --------------------------------------------------------------------------
; H006: 3020 original bytes; all offsets are section-relative.
        section H006,code
H006:
; Preserved bytes H006+$00000000..$000000EC; code/data not fully classified.
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        dc.w $626F,$7264,$6572,$0064,$6630,$3A00,$6466,$303A
        dc.w $5361,$7665,$0053,$6176,$6500,$4173,$7369,$676E
        dc.w $2022,$4469,$736B,$204F,$6E65,$3A22,$2022,$2200
        dc.w $4173,$7369,$676E,$2022,$4469,$736B,$2054,$776F
        dc.w $3A22,$2022,$2200,$4173,$7369,$676E,$2022,$4469
        dc.w $736B,$2054,$6872,$6565,$3A22,$2022,$2200,$4E6F
        dc.w $726D,$4973,$4B69,$6E67,$0000,$0000,$004C,$6F61
        dc.w $6469,$6E67,$2E2E,$2E50,$6C65,$6173,$6520,$5761
        dc.w $6974,$0043,$4F4D,$5350,$5200,$434F,$4D53,$5052
        dc.w $0073,$6B79,$0073,$6B79,$0073,$6B79,$0049,$5445
        dc.w $4D53,$0000,$0000,$0000
        dc.l H006+$00000040
; --------------------------------------------------------------------------
; ROUTINE: module_init_H006 [partial]
; Purpose: Entry of the setup of environment, paths, state and shared resources module; sets the A4 data base and continues into the module body.
;   - Jumps to the actual body at H006+$0BC4.
; Direct callers: H000+$01E6
; --------------------------------------------------------------------------
L006_000000EC:
; H006+$000000EC: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L006_000000EE:
; H006+$000000EE: 287afff8  movea.l $e8(pc), a4
        movea.l H006+$E8(pc), a4
L006_000000F2:
; H006+$000000F2: 4e550000  link.w a5, #$0
        link.w a5, #$0
L006_000000F6:
; H006+$000000F6: 60000acc  bra.w $bc4
        bra.w H006+$BC4
; --------------------------------------------------------------------------
; ROUTINE: sub_H006_000000FA [partial]
; Purpose: Routine of the setup of environment, paths, state and shared resources module; calls H029+$0A0E, H016+$0014, H029+$067A.
;   - Calls H029+$0A0E.
;   - Calls H016+$0014.
;   - Calls H029+$067A.
; Direct callers: H006+$0746
; --------------------------------------------------------------------------
L006_000000FA:
; H006+$000000FA: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L006_000000FC:
; H006+$000000FC: 287affea  movea.l $e8(pc), a4
        movea.l H006+$E8(pc), a4
L006_00000100:
; H006+$00000100: 4e55fff8  link.w a5, #$fff8
        link.w a5, #$fff8
L006_00000104:
; H006+$00000104: 42adfffc  clr.l -$4(a5)
        clr.l -$4(a5)
L006_00000108:
; H006+$00000108: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L006_0000010C:
; H006+$0000010C: 486c0000  pea.l $0(a4)
        pea.l $0(a4)
L006_00000110:
; H006+$00000110: 3f3c0063  move.w #$63, -(a7)
        move.w #$63, -(a7)
L006_00000114:
; H006+$00000114: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_00000118:
; H006+$00000118: 1f3c000d  move.b #$d, -(a7)
        move.b #$d, -(a7)
L006_0000011C:
; H006+$0000011C: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L006_00000120:
; H006+$00000120: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L006_00000126:
; H006+$00000126: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L006_0000012A:
; H006+$0000012A: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L006_0000012E:
; H006+$0000012E: 4853  pea.l (a3)
        pea.l (a3)
L006_00000130:
; H006+$00000130: 4267  clr.w -(a7)
        clr.w -(a7)
L006_00000132:
; H006+$00000132: 4267  clr.w -(a7)
        clr.w -(a7)
L006_00000134:
; H006+$00000134: 247900003348  movea.l $3348.l, a2
        movea.l (H005+$3348).l, a2
L006_0000013A:
; H006+$0000013A: 266a0010  movea.l $10(a2), a3
        movea.l $10(a2), a3
L006_0000013E:
; H006+$0000013E: 4853  pea.l (a3)
        pea.l (a3)
L006_00000140:
; H006+$00000140: 3f3c00a0  move.w #$a0, -(a7)
        move.w #$a0, -(a7)
L006_00000144:
; H006+$00000144: 4267  clr.w -(a7)
        clr.w -(a7)
L006_00000146:
; H006+$00000146: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L006_0000014A:
; H006+$0000014A: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L006_0000014E:
; H006+$0000014E: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L006_00000152:
; H006+$00000152: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L006_00000156:
; H006+$00000156: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L006_00000158:
; H006+$00000158: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L006_0000015E:
; H006+$0000015E: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L006_00000162:
; H006+$00000162: 246dfffc  movea.l -$4(a5), a2
        movea.l -$4(a5), a2
L006_00000166:
; H006+$00000166: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L006_0000016A:
; H006+$0000016A: 4853  pea.l (a3)
        pea.l (a3)
L006_0000016C:
; H006+$0000016C: 4267  clr.w -(a7)
        clr.w -(a7)
L006_0000016E:
; H006+$0000016E: 4267  clr.w -(a7)
        clr.w -(a7)
L006_00000170:
; H006+$00000170: 247900003348  movea.l $3348.l, a2
        movea.l (H005+$3348).l, a2
L006_00000176:
; H006+$00000176: 266a000c  movea.l $c(a2), a3
        movea.l $c(a2), a3
L006_0000017A:
; H006+$0000017A: 4853  pea.l (a3)
        pea.l (a3)
L006_0000017C:
; H006+$0000017C: 3f3c00a0  move.w #$a0, -(a7)
        move.w #$a0, -(a7)
L006_00000180:
; H006+$00000180: 4267  clr.w -(a7)
        clr.w -(a7)
L006_00000182:
; H006+$00000182: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L006_00000186:
; H006+$00000186: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L006_0000018A:
; H006+$0000018A: 1f3c00c0  move.b #$c0, -(a7)
        move.b #$c0, -(a7)
L006_0000018E:
; H006+$0000018E: 1f3c00ff  move.b #$ff, -(a7)
        move.b #$ff, -(a7)
L006_00000192:
; H006+$00000192: 42a7  clr.l -(a7)
        clr.l -(a7)
; -> H016+$0014 (wrapper_BltBitMap)
L006_00000194:
; H006+$00000194: 4eb900000014  jsr $14.l
        jsr (H016+$14).l
L006_0000019A:
; H006+$0000019A: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L006_0000019E:
; H006+$0000019E: 486dfffc  pea.l -$4(a5)
        pea.l -$4(a5)
; FLOW: Calls Free_GraphicRecord (H029+$067A).
L006_000001A2:
; H006+$000001A2: 4eb90000067a  jsr $67a.l
        jsr (H029+$67A).l
L006_000001A8:
; H006+$000001A8: 4e5d  unlk a5
        unlk a5
L006_000001AA:
; H006+$000001AA: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L006_000001AC:
; H006+$000001AC: 4e75  rts 
        rts 
;
; --------------------------------------------------------------------------
; ROUTINE: Initialize_GameEnvironment [verified]
; Purpose: Allocates the state blocks and prepares shared resources of the game.
;   - Sets the save path and the Disk One/Two/Three assignments in the expected branch.
;   - Allocates 2048, 2048 and 1024 bytes of state and 7680 bytes for the ECL buffer.
;   - Sets up the bitmap record and calls the display setup H029+$1346.
;   - Initialises state fields and tables used by the game.
; Direct callers: H001+$010C
; --------------------------------------------------------------------------
L006_000001AE:
; H006+$000001AE: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L006_000001B0:
; H006+$000001B0: 287aff36  movea.l $e8(pc), a4
        movea.l H006+$E8(pc), a4
L006_000001B4:
; H006+$000001B4: 4e55fff2  link.w a5, #$fff2
        link.w a5, #$fff2
; STATE: H005+$246E = resource group selector
L006_000001B8:
; H006+$000001B8: 42390000246e  clr.b $246e.l
        clr.b (H005+$246E).l
L006_000001BE:
; H006+$000001BE: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
; STATE: H005+$3D26 = prefix of the data files
L006_000001C2:
; H006+$000001C2: 487900003d26  pea.l $3d26.l
        pea.l (H005+$3D26).l
L006_000001C8:
; H006+$000001C8: 3f3c0004  move.w #$4, -(a7)
        move.w #$4, -(a7)
L006_000001CC:
; H006+$000001CC: 486c0007  pea.l $7(a4)
        pea.l $7(a4)
; -> H026+$0106 (sub_H026_00000106)
L006_000001D0:
; H006+$000001D0: 4eb900000106  jsr $106.l
        jsr (H026+$106).l
L006_000001D6:
; H006+$000001D6: 1400  move.b d0, d2
        move.b d0, d2
L006_000001D8:
; H006+$000001D8: 0c020001  cmpi.b #$1, d2
        cmpi.b #$1, d2
L006_000001DC:
; H006+$000001DC: 66000018  bne.w $1f6
        bne.w H006+$1F6
L006_000001E0:
; H006+$000001E0: 47ec000c  lea.l $c(a4), a3
        lea.l $c(a4), a3
; STATE: H005+$3CD4 = path of the saved games
L006_000001E4:
; H006+$000001E4: 45f900003cd4  lea.l $3cd4.l, a2
        lea.l (H005+$3CD4).l, a2
L006_000001EA:
; H006+$000001EA: 7450  moveq #$50, d2
        moveq #80, d2
L006_000001EC:
; H006+$000001EC: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L006_000001EE:
; H006+$000001EE: 57cafffc  dbeq d2, $1ec
        dbeq d2, H006+$1EC
L006_000001F2:
; H006+$000001F2: 6000005c  bra.w $250
        bra.w H006+$250
L006_000001F6:
; H006+$000001F6: 47ec0015  lea.l $15(a4), a3
        lea.l $15(a4), a3
; STATE: H005+$3CD4 = path of the saved games
L006_000001FA:
; H006+$000001FA: 45f900003cd4  lea.l $3cd4.l, a2
        lea.l (H005+$3CD4).l, a2
L006_00000200:
; H006+$00000200: 7450  moveq #$50, d2
        moveq #80, d2
L006_00000202:
; H006+$00000202: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L006_00000204:
; H006+$00000204: 57cafffc  dbeq d2, $202
        dbeq d2, H006+$202
L006_00000208:
; H006+$00000208: 47ec001a  lea.l $1a(a4), a3
        lea.l $1a(a4), a3
L006_0000020C:
; H006+$0000020C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_0000020E:
; H006+$0000020E: 7400  moveq #$0, d2
        moveq #0, d2
L006_00000210:
; H006+$00000210: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_00000212:
; H006+$00000212: 7400  moveq #$0, d2
        moveq #0, d2
L006_00000214:
; H006+$00000214: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01E8 (wrapper_Execute)
L006_00000216:
; H006+$00000216: 4eb9000001e8  jsr $1e8.l
        jsr (H002+$1E8).l
L006_0000021C:
; H006+$0000021C: 1b40fff3  move.b d0, -$d(a5)
        move.b d0, -$d(a5)
L006_00000220:
; H006+$00000220: 47ec0030  lea.l $30(a4), a3
        lea.l $30(a4), a3
L006_00000224:
; H006+$00000224: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_00000226:
; H006+$00000226: 7400  moveq #$0, d2
        moveq #0, d2
L006_00000228:
; H006+$00000228: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_0000022A:
; H006+$0000022A: 7400  moveq #$0, d2
        moveq #0, d2
L006_0000022C:
; H006+$0000022C: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01E8 (wrapper_Execute)
L006_0000022E:
; H006+$0000022E: 4eb9000001e8  jsr $1e8.l
        jsr (H002+$1E8).l
L006_00000234:
; H006+$00000234: 1b40fff3  move.b d0, -$d(a5)
        move.b d0, -$d(a5)
L006_00000238:
; H006+$00000238: 47ec0046  lea.l $46(a4), a3
        lea.l $46(a4), a3
L006_0000023C:
; H006+$0000023C: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_0000023E:
; H006+$0000023E: 7400  moveq #$0, d2
        moveq #0, d2
L006_00000240:
; H006+$00000240: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_00000242:
; H006+$00000242: 7400  moveq #$0, d2
        moveq #0, d2
L006_00000244:
; H006+$00000244: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H002+$01E8 (wrapper_Execute)
L006_00000246:
; H006+$00000246: 4eb9000001e8  jsr $1e8.l
        jsr (H002+$1E8).l
L006_0000024C:
; H006+$0000024C: 1b40fff3  move.b d0, -$d(a5)
        move.b d0, -$d(a5)
L006_00000250:
; H006+$00000250: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L006_00000254:
; H006+$00000254: 486c005e  pea.l $5e(a4)
        pea.l $5e(a4)
; -> H028+$02D0 (sub_H028_000002D0)
L006_00000258:
; H006+$00000258: 4eb9000002d0  jsr $2d0.l
        jsr (H028+$2D0).l
L006_0000025E:
; H006+$0000025E: 1400  move.b d0, d2
        move.b d0, d2
L006_00000260:
; H006+$00000260: 4a02  tst.b d2
        tst.b d2
L006_00000262:
; H006+$00000262: 66000016  bne.w $27a
        bne.w H006+$27A
L006_00000266:
; H006+$00000266: 47ecffc0  lea.l -$40(a4), a3
        lea.l -$40(a4), a3
L006_0000026A:
; H006+$0000026A: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_0000026C:
; H006+$0000026C: 47f900000000  lea.l $0.l, a3
        lea.l (H023+$0).l, a3
L006_00000272:
; H006+$00000272: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
; -> H021+$0030 (wrapper_CurrentTime)
L006_00000274:
; H006+$00000274: 4eb900000030  jsr $30.l
        jsr (H021+$30).l
; -> H029+$1206 (sub_H029_00001206)
L006_0000027A:
; H006+$0000027A: 4eb900001206  jsr $1206.l
        jsr (H029+$1206).l
L006_00000280:
; H006+$00000280: 13fc0001000024a2  move.b #$1, $24a2.l
        move.b #$1, (H005+$24A2).l
L006_00000288:
; H006+$00000288: 423900002489  clr.b $2489.l
        clr.b (H005+$2489).l
; STATE: H005+$2356 = mouse X coordinate
L006_0000028E:
; H006+$0000028E: 33fc00a000002356  move.w #$a0, $2356.l
        move.w #$a0, (H005+$2356).l
; STATE: H005+$2354 = mouse Y coordinate
L006_00000296:
; H006+$00000296: 33fc006400002354  move.w #$64, $2354.l
        move.w #$64, (H005+$2354).l
L006_0000029E:
; H006+$0000029E: 427900002352  clr.w $2352.l
        clr.w (H005+$2352).l
L006_000002A4:
; H006+$000002A4: 427900002350  clr.w $2350.l
        clr.w (H005+$2350).l
; STEP: Allocates persistent state A: 2048 bytes, global pointer H005+$3E04.
L006_000002AA:
; H006+$000002AA: 243c00000800  move.l #$800, d2
        move.l #$800, d2
L006_000002B0:
; H006+$000002B0: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_000002B2:
; H006+$000002B2: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L006_000002B8:
; H006+$000002B8: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_000002BE:
; H006+$000002BE: 23c000003e04  move.l d0, $3e04.l
        move.l d0, (H005+$3E04).l
; STEP: Allocates persistent state B: 2048 bytes, pointer H005+$3E00.
L006_000002C4:
; H006+$000002C4: 243c00000800  move.l #$800, d2
        move.l #$800, d2
L006_000002CA:
; H006+$000002CA: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_000002CC:
; H006+$000002CC: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L006_000002D2:
; H006+$000002D2: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L006_000002D8:
; H006+$000002D8: 23c000003e00  move.l d0, $3e00.l
        move.l d0, (H005+$3E00).l
; STEP: Allocates persistent state C: 1024 bytes, pointer H005+$3DFC.
L006_000002DE:
; H006+$000002DE: 243c00000400  move.l #$400, d2
        move.l #$400, d2
L006_000002E4:
; H006+$000002E4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_000002E6:
; H006+$000002E6: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L006_000002EC:
; H006+$000002EC: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
; STATE: H005+$3DFC = pointer to persistent state C, 1024 bytes
L006_000002F2:
; H006+$000002F2: 23c000003dfc  move.l d0, $3dfc.l
        move.l d0, (H005+$3DFC).l
; STEP: Allocates the ECL program buffer: $1E00 = 7680 bytes, pointer H005+$3DF8.
L006_000002F8:
; H006+$000002F8: 243c00001e00  move.l #$1e00, d2
        move.l #$1e00, d2
L006_000002FE:
; H006+$000002FE: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_00000300:
; H006+$00000300: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L006_00000306:
; H006+$00000306: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
; STATE: H005+$3DF8 = pointer to the ECL buffer
L006_0000030C:
; H006+$0000030C: 23c000003df8  move.l d0, $3df8.l
        move.l d0, (H005+$3DF8).l
L006_00000312:
; H006+$00000312: 243c00000924  move.l #$924, d2
        move.l #$924, d2
L006_00000318:
; H006+$00000318: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_0000031A:
; H006+$0000031A: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L006_00000320:
; H006+$00000320: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L006_00000326:
; H006+$00000326: 23c00000282e  move.l d0, $282e.l
        move.l d0, (H005+$282E).l
L006_0000032C:
; H006+$0000032C: 243c00000400  move.l #$400, d2
        move.l #$400, d2
L006_00000332:
; H006+$00000332: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L006_00000334:
; H006+$00000334: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L006_0000033A:
; H006+$0000033A: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
; STATE: H005+$282A = pointer to the four GEO data planes
L006_00000340:
; H006+$00000340: 23c00000282a  move.l d0, $282a.l
        move.l d0, (H005+$282A).l
L006_00000346:
; H006+$00000346: 3f3c0008  move.w #$8, -(a7)
        move.w #$8, -(a7)
L006_0000034A:
; H006+$0000034A: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_0000034E:
; H006+$0000034E: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_00000352:
; H006+$00000352: 4267  clr.w -(a7)
        clr.w -(a7)
L006_00000354:
; H006+$00000354: 487900003334  pea.l $3334.l
        pea.l (H005+$3334).l
; FLOW: Calls Allocate_GraphicRecord (H029+$0408).
L006_0000035A:
; H006+$0000035A: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L006_00000360:
; H006+$00000360: 3f3c0030  move.w #$30, -(a7)
        move.w #$30, -(a7)
L006_00000364:
; H006+$00000364: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L006_00000368:
; H006+$00000368: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_0000036C:
; H006+$0000036C: 4267  clr.w -(a7)
        clr.w -(a7)
L006_0000036E:
; H006+$0000036E: 487900003d8a  pea.l $3d8a.l
        pea.l (H005+$3D8A).l
; FLOW: Calls Allocate_GraphicRecord (H029+$0408).
L006_00000374:
; H006+$00000374: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L006_0000037A:
; H006+$0000037A: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L006_0000037E:
; H006+$0000037E: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L006_00000382:
; H006+$00000382: 3f3c0028  move.w #$28, -(a7)
        move.w #$28, -(a7)
L006_00000386:
; H006+$00000386: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_0000038A:
; H006+$0000038A: 48790000332c  pea.l $332c.l
        pea.l (H005+$332C).l
; FLOW: Calls Allocate_GraphicRecord (H029+$0408).
L006_00000390:
; H006+$00000390: 4eb900000408  jsr $408.l
        jsr (H029+$408).l
L006_00000396:
; H006+$00000396: 42b900003d8e  clr.l $3d8e.l
        clr.l (H005+$3D8E).l
; FLOW: Calls Prepare_DisplayResources (H029+$1346).
L006_0000039C:
; H006+$0000039C: 4eb900001346  jsr $1346.l
        jsr (H029+$1346).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_000003A2:
; H006+$000003A2: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_000003A8:
; H006+$000003A8: 377c000303e8  move.w #$3, $3e8(a3)
        move.w #$3, $3e8(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_000003AE:
; H006+$000003AE: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_000003B4:
; H006+$000003B4: 377c000101cc  move.w #$1, $1cc(a3)
        move.w #$1, $1cc(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_000003BA:
; H006+$000003BA: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_000003C0:
; H006+$000003C0: 426b01e4  clr.w $1e4(a3)
        clr.w $1e4(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_000003C4:
; H006+$000003C4: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_000003CA:
; H006+$000003CA: 377c000203f2  move.w #$2, $3f2(a3)
        move.w #$2, $3f2(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_000003D0:
; H006+$000003D0: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_000003D6:
; H006+$000003D6: 377c000203f4  move.w #$2, $3f4(a3)
        move.w #$2, $3f4(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_000003DC:
; H006+$000003DC: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_000003E2:
; H006+$000003E2: 377c000203f6  move.w #$2, $3f6(a3)
        move.w #$2, $3f6(a3)
L006_000003E8:
; H006+$000003E8: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L006_000003EC:
; H006+$000003EC: 0c6c001cfffe  cmpi.w #$1c, -$2(a4)
        cmpi.w #$1c, -$2(a4)
L006_000003F2:
; H006+$000003F2: 62000028  bhi.w $41c
        bhi.w H006+$41C
L006_000003F6:
; H006+$000003F6: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_000003FA:
; H006+$000003FA: e742  asl.w #$3, d2
        asl.w #$3, d2
L006_000003FC:
; H006+$000003FC: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L006_00000402:
; H006+$00000402: 42b32000  clr.l (a3, d2.w)
        clr.l (a3, d2.w)
L006_00000406:
; H006+$00000406: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_0000040A:
; H006+$0000040A: e742  asl.w #$3, d2
        asl.w #$3, d2
L006_0000040C:
; H006+$0000040C: 47f900003244  lea.l $3244.l, a3
        lea.l (H005+$3244).l, a3
L006_00000412:
; H006+$00000412: 42b32004  clr.l $4(a3, d2.w)
        clr.l $4(a3, d2.w)
L006_00000416:
; H006+$00000416: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_0000041A:
; H006+$0000041A: 64d0  bcc.b $3ec
        bcc.b H006+$3EC
L006_0000041C:
; H006+$0000041C: 397c0001fffe  move.w #$1, -$2(a4)
        move.w #$1, -$2(a4)
L006_00000422:
; H006+$00000422: 0c6c0002fffe  cmpi.w #$2, -$2(a4)
        cmpi.w #$2, -$2(a4)
L006_00000428:
; H006+$00000428: 62000032  bhi.w $45c
        bhi.w H006+$45C
L006_0000042C:
; H006+$0000042C: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000430:
; H006+$00000430: 5342  subq.w #$1, d2
        subq.w #$1, d2
L006_00000432:
; H006+$00000432: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L006_00000436:
; H006+$00000436: 47f9000027b0  lea.l $27b0.l, a3
        lea.l (H005+$27B0).l, a3
L006_0000043C:
; H006+$0000043C: 17bc00ff2800  move.b #$ff, (a3, d2.l)
        move.b #$ff, (a3, d2.l)
L006_00000442:
; H006+$00000442: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000446:
; H006+$00000446: 5342  subq.w #$1, d2
        subq.w #$1, d2
L006_00000448:
; H006+$00000448: c5fc0006  muls.w #$6, d2
        muls.w #$6, d2
L006_0000044C:
; H006+$0000044C: 47f9000027b0  lea.l $27b0.l, a3
        lea.l (H005+$27B0).l, a3
L006_00000452:
; H006+$00000452: 42b32802  clr.l $2(a3, d2.l)
        clr.l $2(a3, d2.l)
L006_00000456:
; H006+$00000456: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_0000045A:
; H006+$0000045A: 64c6  bcc.b $422
        bcc.b H006+$422
L006_0000045C:
; H006+$0000045C: 42b9000027c2  clr.l $27c2.l
        clr.l (H005+$27C2).l
L006_00000462:
; H006+$00000462: 42b9000027c6  clr.l $27c6.l
        clr.l (H005+$27C6).l
L006_00000468:
; H006+$00000468: 397c0002fffe  move.w #$2, -$2(a4)
        move.w #$2, -$2(a4)
L006_0000046E:
; H006+$0000046E: 0c6c0008fffe  cmpi.w #$8, -$2(a4)
        cmpi.w #$8, -$2(a4)
L006_00000474:
; H006+$00000474: 6200002c  bhi.w $4a2
        bhi.w H006+$4A2
L006_00000478:
; H006+$00000478: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_0000047C:
; H006+$0000047C: 5542  subq.w #$2, d2
        subq.w #$2, d2
L006_0000047E:
; H006+$0000047E: e342  asl.w #$1, d2
        asl.w #$1, d2
L006_00000480:
; H006+$00000480: 47f9000027da  lea.l $27da.l, a3
        lea.l (H005+$27DA).l, a3
L006_00000486:
; H006+$00000486: 42732000  clr.w (a3, d2.w)
        clr.w (a3, d2.w)
L006_0000048A:
; H006+$0000048A: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_0000048E:
; H006+$0000048E: 5542  subq.w #$2, d2
        subq.w #$2, d2
L006_00000490:
; H006+$00000490: e542  asl.w #$2, d2
        asl.w #$2, d2
L006_00000492:
; H006+$00000492: 47f9000027e8  lea.l $27e8.l, a3
        lea.l (H005+$27E8).l, a3
L006_00000498:
; H006+$00000498: 42b32000  clr.l (a3, d2.w)
        clr.l (a3, d2.w)
L006_0000049C:
; H006+$0000049C: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_000004A0:
; H006+$000004A0: 64cc  bcc.b $46e
        bcc.b H006+$46E
L006_000004A2:
; H006+$000004A2: 4279000027bc  clr.w $27bc.l
        clr.w (H005+$27BC).l
L006_000004A8:
; H006+$000004A8: 42b900002798  clr.l $2798.l
        clr.l (H005+$2798).l
L006_000004AE:
; H006+$000004AE: 42b900002a3a  clr.l $2a3a.l
        clr.l (H005+$2A3A).l
L006_000004B4:
; H006+$000004B4: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; STATE: H005+$281C = start of the coordinates/view block
L006_000004B8:
; H006+$000004B8: 48790000281c  pea.l $281c.l
        pea.l (H005+$281C).l
L006_000004BE:
; H006+$000004BE: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L006_000004C2:
; H006+$000004C2: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_000004C4:
; H006+$000004C4: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
; STATE: H005+$281C = start of the coordinates/view block
L006_000004CA:
; H006+$000004CA: 33fc00070000281c  move.w #$7, $281c.l
        move.w #$7, (H005+$281C).l
L006_000004D2:
; H006+$000004D2: 33fc000d0000281e  move.w #$d, $281e.l
        move.w #$d, (H005+$281E).l
L006_000004DA:
; H006+$000004DA: 423900002820  clr.b $2820.l
        clr.b (H005+$2820).l
L006_000004E0:
; H006+$000004E0: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L006_000004E4:
; H006+$000004E4: 4879000024e4  pea.l $24e4.l
        pea.l (H005+$24E4).l
L006_000004EA:
; H006+$000004EA: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L006_000004EE:
; H006+$000004EE: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_000004F2:
; H006+$000004F2: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
; STATE: H005+$2810 = three state elements of the wall sets
L006_000004F8:
; H006+$000004F8: 427900002810  clr.w $2810.l
        clr.w (H005+$2810).l
L006_000004FE:
; H006+$000004FE: 33fc000100002812  move.w #$1, $2812.l
        move.w #$1, (H005+$2812).l
L006_00000506:
; H006+$00000506: 397c0002fffe  move.w #$2, -$2(a4)
        move.w #$2, -$2(a4)
L006_0000050C:
; H006+$0000050C: 0c6c0003fffe  cmpi.w #$3, -$2(a4)
        cmpi.w #$3, -$2(a4)
L006_00000512:
; H006+$00000512: 62000030  bhi.w $544
        bhi.w H006+$544
L006_00000516:
; H006+$00000516: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_0000051A:
; H006+$0000051A: 5342  subq.w #$1, d2
        subq.w #$1, d2
L006_0000051C:
; H006+$0000051C: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATE: H005+$2810 = three state elements of the wall sets
L006_0000051E:
; H006+$0000051E: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L006_00000524:
; H006+$00000524: 37bcffff2000  move.w #$ffff, (a3, d2.w)
        move.w #$ffff, (a3, d2.w)
L006_0000052A:
; H006+$0000052A: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_0000052E:
; H006+$0000052E: 5342  subq.w #$1, d2
        subq.w #$1, d2
L006_00000530:
; H006+$00000530: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATE: H005+$2810 = three state elements of the wall sets
L006_00000532:
; H006+$00000532: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L006_00000538:
; H006+$00000538: 37bcffff2002  move.w #$ffff, $2(a3, d2.w)
        move.w #$ffff, $2(a3, d2.w)
L006_0000053E:
; H006+$0000053E: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_00000542:
; H006+$00000542: 64c8  bcc.b $50c
        bcc.b H006+$50C
L006_00000544:
; H006+$00000544: 13fc0001000024d4  move.b #$1, $24d4.l
        move.b #$1, (H005+$24D4).l
L006_0000054C:
; H006+$0000054C: 13fc0001000024d5  move.b #$1, $24d5.l
        move.b #$1, (H005+$24D5).l
L006_00000554:
; H006+$00000554: 4239000024d2  clr.b $24d2.l
        clr.b (H005+$24D2).l
L006_0000055A:
; H006+$0000055A: 13fc0001000024ce  move.b #$1, $24ce.l
        move.b #$1, (H005+$24CE).l
L006_00000562:
; H006+$00000562: 4239000024d1  clr.b $24d1.l
        clr.b (H005+$24D1).l
L006_00000568:
; H006+$00000568: 427900003dde  clr.w $3dde.l
        clr.w (H005+$3DDE).l
; STATE: H005+$3364 = head of the party list
L006_0000056E:
; H006+$0000056E: 42b900003364  clr.l $3364.l
        clr.l (H005+$3364).l
; STATE: H005+$3368 = current character
L006_00000574:
; H006+$00000574: 42b900003368  clr.l $3368.l
        clr.l (H005+$3368).l
; STATE: H005+$3DEA = logical ECL PC
L006_0000057A:
; H006+$0000057A: 33fc350000003dea  move.w #$3500, $3dea.l
        move.w #$3500, (H005+$3DEA).l
L006_00000582:
; H006+$00000582: 33fc000400003df6  move.w #$4, $3df6.l
        move.w #$4, (H005+$3DF6).l
; STATE: H005+$24D7 = flag of the demo branch
L006_0000058A:
; H006+$0000058A: 4239000024d7  clr.b $24d7.l
        clr.b (H005+$24D7).l
L006_00000590:
; H006+$00000590: 13fc00010000246d  move.b #$1, $246d.l
        move.b #$1, (H005+$246D).l
L006_00000598:
; H006+$00000598: 423900002825  clr.b $2825.l
        clr.b (H005+$2825).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L006_0000059E:
; H006+$0000059E: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L006_000005A4:
; H006+$000005A4: 426b067c  clr.w $67c(a3)
        clr.w $67c(a3)
L006_000005A8:
; H006+$000005A8: 33fc000100002796  move.w #$1, $2796.l
        move.w #$1, (H005+$2796).l
L006_000005B0:
; H006+$000005B0: 4239000024c1  clr.b $24c1.l
        clr.b (H005+$24C1).l
L006_000005B6:
; H006+$000005B6: 4239000024e2  clr.b $24e2.l
        clr.b (H005+$24E2).l
L006_000005BC:
; H006+$000005BC: 423900002497  clr.b $2497.l
        clr.b (H005+$2497).l
L006_000005C2:
; H006+$000005C2: 4239000024bf  clr.b $24bf.l
        clr.b (H005+$24BF).l
L006_000005C8:
; H006+$000005C8: 4239000024be  clr.b $24be.l
        clr.b (H005+$24BE).l
L006_000005CE:
; H006+$000005CE: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
; STATE: H005+$24D0 = request to exit the scenario loop
L006_000005D4:
; H006+$000005D4: 4239000024d0  clr.b $24d0.l
        clr.b (H005+$24D0).l
L006_000005DA:
; H006+$000005DA: 13fc0001000024a6  move.b #$1, $24a6.l
        move.b #$1, (H005+$24A6).l
L006_000005E2:
; H006+$000005E2: 4239000024ba  clr.b $24ba.l
        clr.b (H005+$24BA).l
L006_000005E8:
; H006+$000005E8: 4239000024a4  clr.b $24a4.l
        clr.b (H005+$24A4).l
L006_000005EE:
; H006+$000005EE: 47ec0069  lea.l $69(a4), a3
        lea.l $69(a4), a3
L006_000005F2:
; H006+$000005F2: 45f9000027a6  lea.l $27a6.l, a2
        lea.l (H005+$27A6).l, a2
L006_000005F8:
; H006+$000005F8: 7408  moveq #$8, d2
        moveq #8, d2
L006_000005FA:
; H006+$000005FA: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L006_000005FC:
; H006+$000005FC: 57cafffc  dbeq d2, $5fa
        dbeq d2, H006+$5FA
L006_00000600:
; H006+$00000600: 47ec006b  lea.l $6b(a4), a3
        lea.l $6b(a4), a3
L006_00000604:
; H006+$00000604: 45f90000279c  lea.l $279c.l, a2
        lea.l (H005+$279C).l, a2
L006_0000060A:
; H006+$0000060A: 7408  moveq #$8, d2
        moveq #8, d2
L006_0000060C:
; H006+$0000060C: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L006_0000060E:
; H006+$0000060E: 57cafffc  dbeq d2, $60c
        dbeq d2, H006+$60C
L006_00000612:
; H006+$00000612: 13fc00ff00002486  move.b #$ff, $2486.l
        move.b #$ff, (H005+$2486).l
L006_0000061A:
; H006+$0000061A: 13fc00ff00002485  move.b #$ff, $2485.l
        move.b #$ff, (H005+$2485).l
L006_00000622:
; H006+$00000622: 4239000024a3  clr.b $24a3.l
        clr.b (H005+$24A3).l
L006_00000628:
; H006+$00000628: 13fc00e80000247e  move.b #$e8, $247e.l
        move.b #$e8, (H005+$247E).l
L006_00000630:
; H006+$00000630: 13fc00db0000247f  move.b #$db, $247f.l
        move.b #$db, (H005+$247F).l
L006_00000638:
; H006+$00000638: 4239000024b4  clr.b $24b4.l
        clr.b (H005+$24B4).l
L006_0000063E:
; H006+$0000063E: 4239000024d8  clr.b $24d8.l
        clr.b (H005+$24D8).l
L006_00000644:
; H006+$00000644: 13fc0001000024c6  move.b #$1, $24c6.l
        move.b #$1, (H005+$24C6).l
L006_0000064C:
; H006+$0000064C: 13fc00ff00002484  move.b #$ff, $2484.l
        move.b #$ff, (H005+$2484).l
L006_00000654:
; H006+$00000654: 4239000024ad  clr.b $24ad.l
        clr.b (H005+$24AD).l
L006_0000065A:
; H006+$0000065A: 4239000024cf  clr.b $24cf.l
        clr.b (H005+$24CF).l
L006_00000660:
; H006+$00000660: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
; STATE: H005+$3DE3 = native context, 5 in combat
L006_00000668:
; H006+$00000668: 13fc000400003de3  move.b #$4, $3de3.l
        move.b #$4, (H005+$3DE3).l
L006_00000670:
; H006+$00000670: 423900003de2  clr.b $3de2.l
        clr.b (H005+$3DE2).l
L006_00000676:
; H006+$00000676: 13fc0001000024a7  move.b #$1, $24a7.l
        move.b #$1, (H005+$24A7).l
L006_0000067E:
; H006+$0000067E: 4239000024e0  clr.b $24e0.l
        clr.b (H005+$24E0).l
L006_00000684:
; H006+$00000684: 4239000024ae  clr.b $24ae.l
        clr.b (H005+$24AE).l
L006_0000068A:
; H006+$0000068A: 42b90000280c  clr.l $280c.l
        clr.l (H005+$280C).l
L006_00000690:
; H006+$00000690: 42b900002808  clr.l $2808.l
        clr.l (H005+$2808).l
L006_00000696:
; H006+$00000696: 42b900002804  clr.l $2804.l
        clr.l (H005+$2804).l
L006_0000069C:
; H006+$0000069C: 42b900003360  clr.l $3360.l
        clr.l (H005+$3360).l
L006_000006A2:
; H006+$000006A2: 4239000024b1  clr.b $24b1.l
        clr.b (H005+$24B1).l
L006_000006A8:
; H006+$000006A8: 4239000024cb  clr.b $24cb.l
        clr.b (H005+$24CB).l
L006_000006AE:
; H006+$000006AE: 4239000024cc  clr.b $24cc.l
        clr.b (H005+$24CC).l
L006_000006B4:
; H006+$000006B4: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L006_000006BA:
; H006+$000006BA: 42390000249e  clr.b $249e.l
        clr.b (H005+$249E).l
L006_000006C0:
; H006+$000006C0: 4239000024da  clr.b $24da.l
        clr.b (H005+$24DA).l
L006_000006C6:
; H006+$000006C6: 3f3c004f  move.w #$4f, -(a7)
        move.w #$4f, -(a7)
L006_000006CA:
; H006+$000006CA: 487900000016  pea.l $16.l
        pea.l (H005+$16).l
L006_000006D0:
; H006+$000006D0: 3f3c0050  move.w #$50, -(a7)
        move.w #$50, -(a7)
L006_000006D4:
; H006+$000006D4: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_000006D6:
; H006+$000006D6: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L006_000006DC:
; H006+$000006DC: 427900000014  clr.w $14.l
        clr.w (H005+$14).l
; -> H030+$0C10 (sub_H030_00000C10)
L006_000006E2:
; H006+$000006E2: 4eb900000c10  jsr $c10.l
        jsr (H030+$C10).l
; -> H008+$139E (sub_H008_0000139E)
L006_000006E8:
; H006+$000006E8: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
L006_000006EE:
; H006+$000006EE: 4267  clr.w -(a7)
        clr.w -(a7)
L006_000006F0:
; H006+$000006F0: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L006_000006F4:
; H006+$000006F4: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L006_000006F8:
; H006+$000006F8: 4267  clr.w -(a7)
        clr.w -(a7)
L006_000006FA:
; H006+$000006FA: 3f3c0015  move.w #$15, -(a7)
        move.w #$15, -(a7)
L006_000006FE:
; H006+$000006FE: 486c006d  pea.l $6d(a4)
        pea.l $6d(a4)
; FLOW: Calls UI_DrawText (H030+$0256).
L006_00000702:
; H006+$00000702: 4eb900000256  jsr $256.l
        jsr (H030+$256).l
L006_00000708:
; H006+$00000708: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L006_0000070C:
; H006+$0000070C: 0c6c0004fffe  cmpi.w #$4, -$2(a4)
        cmpi.w #$4, -$2(a4)
L006_00000712:
; H006+$00000712: 62000018  bhi.w $72c
        bhi.w H006+$72C
L006_00000716:
; H006+$00000716: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_0000071A:
; H006+$0000071A: e542  asl.w #$2, d2
        asl.w #$2, d2
L006_0000071C:
; H006+$0000071C: 47f900003338  lea.l $3338.l, a3
        lea.l (H005+$3338).l, a3
L006_00000722:
; H006+$00000722: 42b32000  clr.l (a3, d2.w)
        clr.l (a3, d2.w)
L006_00000726:
; H006+$00000726: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_0000072A:
; H006+$0000072A: 64e0  bcc.b $70c
        bcc.b H006+$70C
L006_0000072C:
; H006+$0000072C: 1f3c00ca  move.b #$ca, -(a7)
        move.b #$ca, -(a7)
L006_00000730:
; H006+$00000730: 1f3c0004  move.b #$4, -(a7)
        move.b #$4, -(a7)
; -> H034+$0032 (sub_H034_00000032)
L006_00000734:
; H006+$00000734: 4eb900000032  jsr $32.l
        jsr (H034+$32).l
L006_0000073A:
; H006+$0000073A: 1f3c00cb  move.b #$cb, -(a7)
        move.b #$cb, -(a7)
L006_0000073E:
; H006+$0000073E: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H034+$0032 (sub_H034_00000032)
L006_00000740:
; H006+$00000740: 4eb900000032  jsr $32.l
        jsr (H034+$32).l
L006_00000746:
; H006+$00000746: 6100f9b2  bsr.w $fa
        bsr.w H006+$FA
L006_0000074A:
; H006+$0000074A: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L006_0000074E:
; H006+$0000074E: 0c6c000bfffe  cmpi.w #$b, -$2(a4)
        cmpi.w #$b, -$2(a4)
L006_00000754:
; H006+$00000754: 62000024  bhi.w $77a
        bhi.w H006+$77A
L006_00000758:
; H006+$00000758: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L006_0000075C:
; H006+$0000075C: 486c0083  pea.l $83(a4)
        pea.l $83(a4)
L006_00000760:
; H006+$00000760: 3f2cfffe  move.w -$2(a4), -(a7)
        move.w -$2(a4), -(a7)
L006_00000764:
; H006+$00000764: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000768:
; H006+$00000768: 0642000d  addi.w #$d, d2
        addi.w #$d, d2
L006_0000076C:
; H006+$0000076C: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H035+$0246 (sub_H035_00000246)
L006_0000076E:
; H006+$0000076E: 4eb900000246  jsr $246.l
        jsr (H035+$246).l
L006_00000774:
; H006+$00000774: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_00000778:
; H006+$00000778: 64d4  bcc.b $74e
        bcc.b H006+$74E
L006_0000077A:
; H006+$0000077A: 397c0019fffe  move.w #$19, -$2(a4)
        move.w #$19, -$2(a4)
L006_00000780:
; H006+$00000780: 0c6c001cfffe  cmpi.w #$1c, -$2(a4)
        cmpi.w #$1c, -$2(a4)
L006_00000786:
; H006+$00000786: 6200001e  bhi.w $7a6
        bhi.w H006+$7A6
L006_0000078A:
; H006+$0000078A: 3f3c0006  move.w #$6, -(a7)
        move.w #$6, -(a7)
L006_0000078E:
; H006+$0000078E: 486c008a  pea.l $8a(a4)
        pea.l $8a(a4)
L006_00000792:
; H006+$00000792: 3f2cfffe  move.w -$2(a4), -(a7)
        move.w -$2(a4), -(a7)
L006_00000796:
; H006+$00000796: 3f2cfffe  move.w -$2(a4), -(a7)
        move.w -$2(a4), -(a7)
; -> H035+$0246 (sub_H035_00000246)
L006_0000079A:
; H006+$0000079A: 4eb900000246  jsr $246.l
        jsr (H035+$246).l
L006_000007A0:
; H006+$000007A0: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_000007A4:
; H006+$000007A4: 64da  bcc.b $780
        bcc.b H006+$780
L006_000007A6:
; H006+$000007A6: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L006_000007AA:
; H006+$000007AA: 486c0091  pea.l $91(a4)
        pea.l $91(a4)
L006_000007AE:
; H006+$000007AE: 3f3c00fa  move.w #$fa, -(a7)
        move.w #$fa, -(a7)
L006_000007B2:
; H006+$000007B2: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_000007B6:
; H006+$000007B6: 4227  clr.b -(a7)
        clr.b -(a7)
L006_000007B8:
; H006+$000007B8: 48790000280c  pea.l $280c.l
        pea.l (H005+$280C).l
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L006_000007BE:
; H006+$000007BE: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L006_000007C4:
; H006+$000007C4: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L006_000007C8:
; H006+$000007C8: 486c0095  pea.l $95(a4)
        pea.l $95(a4)
L006_000007CC:
; H006+$000007CC: 3f3c00fb  move.w #$fb, -(a7)
        move.w #$fb, -(a7)
L006_000007D0:
; H006+$000007D0: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_000007D4:
; H006+$000007D4: 4227  clr.b -(a7)
        clr.b -(a7)
L006_000007D6:
; H006+$000007D6: 487900002808  pea.l $2808.l
        pea.l (H005+$2808).l
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L006_000007DC:
; H006+$000007DC: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L006_000007E2:
; H006+$000007E2: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L006_000007E6:
; H006+$000007E6: 486c0099  pea.l $99(a4)
        pea.l $99(a4)
L006_000007EA:
; H006+$000007EA: 3f3c00fc  move.w #$fc, -(a7)
        move.w #$fc, -(a7)
L006_000007EE:
; H006+$000007EE: 3f3c0001  move.w #$1, -(a7)
        move.w #$1, -(a7)
L006_000007F2:
; H006+$000007F2: 1f3c000d  move.b #$d, -(a7)
        move.b #$d, -(a7)
L006_000007F6:
; H006+$000007F6: 487900002804  pea.l $2804.l
        pea.l (H005+$2804).l
; FLOW: Calls Load_IndexedGraphicRecord (H029+$0A0E).
L006_000007FC:
; H006+$000007FC: 4eb900000a0e  jsr $a0e.l
        jsr (H029+$A0E).l
L006_00000802:
; H006+$00000802: 47ec009d  lea.l $9d(a4), a3
        lea.l $9d(a4), a3
L006_00000806:
; H006+$00000806: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_00000808:
; H006+$00000808: 2f3c000003ed  move.l #MODE_OLDFILE, -(a7)
        move.l #MODE_OLDFILE, -(a7)
; -> H002+$00F2 (wrapper_Open)
L006_0000080E:
; H006+$0000080E: 4eb9000000f2  jsr $f2.l
        jsr (H002+$F2).l
L006_00000814:
; H006+$00000814: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L006_00000818:
; H006+$00000818: 4aadfff8  tst.l -$8(a5)
        tst.l -$8(a5)
L006_0000081C:
; H006+$0000081C: 670000e4  beq.w $902
        beq.w H006+$902
L006_00000820:
; H006+$00000820: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L006_00000824:
; H006+$00000824: 2f3c00000002  move.l #$2, -(a7)
        move.l #$2, -(a7)
L006_0000082A:
; H006+$0000082A: 2f3cffffffff  move.l #$ffffffff, -(a7)
        move.l #$ffffffff, -(a7)
; -> H002+$0156 (wrapper_Seek)
L006_00000830:
; H006+$00000830: 4eb900000156  jsr $156.l
        jsr (H002+$156).l
L006_00000836:
; H006+$00000836: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L006_0000083A:
; H006+$0000083A: 426cfffe  clr.w -$2(a4)
        clr.w -$2(a4)
L006_0000083E:
; H006+$0000083E: 0c6c0080fffe  cmpi.w #$80, -$2(a4)
        cmpi.w #$80, -$2(a4)
L006_00000844:
; H006+$00000844: 620000b2  bhi.w $8f8
        bhi.w H006+$8F8
L006_00000848:
; H006+$00000848: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L006_0000084C:
; H006+$0000084C: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000850:
; H006+$00000850: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L006_00000854:
; H006+$00000854: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L006_0000085A:
; H006+$0000085A: 47f32800  lea.l (a3, d2.l), a3
        lea.l (a3, d2.l), a3
L006_0000085E:
; H006+$0000085E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_00000860:
; H006+$00000860: 2f3c00000005  move.l #$5, -(a7)
        move.l #$5, -(a7)
; -> H002+$0122 (wrapper_Read)
L006_00000866:
; H006+$00000866: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L006_0000086C:
; H006+$0000086C: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L006_00000870:
; H006+$00000870: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000874:
; H006+$00000874: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L006_00000878:
; H006+$00000878: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L006_0000087E:
; H006+$0000087E: 48732804  pea.l $4(a3, d2.l)
        pea.l $4(a3, d2.l)
; -> H031+$0012 (sub_H031_00000012)
L006_00000882:
; H006+$00000882: 4eb900000012  jsr $12.l
        jsr (H031+$12).l
L006_00000888:
; H006+$00000888: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L006_0000088C:
; H006+$0000088C: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000890:
; H006+$00000890: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L006_00000894:
; H006+$00000894: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L006_0000089A:
; H006+$0000089A: 47f32806  lea.l $6(a3, d2.l), a3
        lea.l $6(a3, d2.l), a3
L006_0000089E:
; H006+$0000089E: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_000008A0:
; H006+$000008A0: 2f3c00000007  move.l #$7, -(a7)
        move.l #$7, -(a7)
; -> H002+$0122 (wrapper_Read)
L006_000008A6:
; H006+$000008A6: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L006_000008AC:
; H006+$000008AC: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L006_000008B0:
; H006+$000008B0: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_000008B4:
; H006+$000008B4: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L006_000008B8:
; H006+$000008B8: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L006_000008BE:
; H006+$000008BE: 4873280c  pea.l $c(a3, d2.l)
        pea.l $c(a3, d2.l)
; -> H031+$0012 (sub_H031_00000012)
L006_000008C2:
; H006+$000008C2: 4eb900000012  jsr $12.l
        jsr (H031+$12).l
L006_000008C8:
; H006+$000008C8: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L006_000008CC:
; H006+$000008CC: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_000008D0:
; H006+$000008D0: c5fc0012  muls.w #$12, d2
        muls.w #$12, d2
L006_000008D4:
; H006+$000008D4: 47f90000336c  lea.l $336c.l, a3
        lea.l (H005+$336C).l, a3
L006_000008DA:
; H006+$000008DA: 47f3280e  lea.l $e(a3, d2.l), a3
        lea.l $e(a3, d2.l), a3
L006_000008DE:
; H006+$000008DE: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L006_000008E0:
; H006+$000008E0: 2f3c00000004  move.l #$4, -(a7)
        move.l #$4, -(a7)
; -> H002+$0122 (wrapper_Read)
L006_000008E6:
; H006+$000008E6: 4eb900000122  jsr $122.l
        jsr (H002+$122).l
L006_000008EC:
; H006+$000008EC: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L006_000008F0:
; H006+$000008F0: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_000008F4:
; H006+$000008F4: 6400ff48  bcc.w $83e
        bcc.w H006+$83E
L006_000008F8:
; H006+$000008F8: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H002+$0014 (wrapper_Close)
L006_000008FC:
; H006+$000008FC: 4eb900000014  jsr $14.l
        jsr (H002+$14).l
; -> H027+$4276 (sub_H027_00004276)
L006_00000902:
; H006+$00000902: 4eb900004276  jsr $4276.l
        jsr (H027+$4276).l
; -> H033+$1A50 (sub_H033_00001A50)
L006_00000908:
; H006+$00000908: 4eb900001a50  jsr $1a50.l
        jsr (H033+$1A50).l
L006_0000090E:
; H006+$0000090E: 4e5d  unlk a5
        unlk a5
L006_00000910:
; H006+$00000910: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L006_00000912:
; H006+$00000912: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H006_00000914 [partial]
; Purpose: Routine of the setup of environment, paths, state and shared resources module; calls H029+$0312, H008+$139E.
;   - Calls H029+$0312.
;   - Calls H008+$139E.
;   - Uses the global state: H005+$3E04 (pointer to persistent state A, 2048 bytes); H005+$3E00 (pointer to persistent state B, 2048 bytes); H005+$3DFC (pointer to persistent state C, 1024 bytes).
; Direct callers: H001+$021C
; --------------------------------------------------------------------------
L006_00000914:
; H006+$00000914: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L006_00000916:
; H006+$00000916: 287af7d0  movea.l $e8(pc), a4
        movea.l H006+$E8(pc), a4
L006_0000091A:
; H006+$0000091A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L006_0000091E:
; H006+$0000091E: 3f3c07ff  move.w #$7ff, -(a7)
        move.w #$7ff, -(a7)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_00000922:
; H006+$00000922: 2f3900003e04  move.l $3e04.l, -(a7)
        move.l (H005+$3E04).l, -(a7)
L006_00000928:
; H006+$00000928: 3f3c0800  move.w #$800, -(a7)
        move.w #$800, -(a7)
L006_0000092C:
; H006+$0000092C: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_0000092E:
; H006+$0000092E: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_00000934:
; H006+$00000934: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_0000093A:
; H006+$0000093A: 377c000303e8  move.w #$3, $3e8(a3)
        move.w #$3, $3e8(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_00000940:
; H006+$00000940: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_00000946:
; H006+$00000946: 377c000101cc  move.w #$1, $1cc(a3)
        move.w #$1, $1cc(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_0000094C:
; H006+$0000094C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_00000952:
; H006+$00000952: 426b01e4  clr.w $1e4(a3)
        clr.w $1e4(a3)
L006_00000956:
; H006+$00000956: 3f3c07ff  move.w #$7ff, -(a7)
        move.w #$7ff, -(a7)
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L006_0000095A:
; H006+$0000095A: 2f3900003e00  move.l $3e00.l, -(a7)
        move.l (H005+$3E00).l, -(a7)
L006_00000960:
; H006+$00000960: 3f3c0800  move.w #$800, -(a7)
        move.w #$800, -(a7)
L006_00000964:
; H006+$00000964: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_00000966:
; H006+$00000966: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L006_0000096C:
; H006+$0000096C: 3f3c03ff  move.w #$3ff, -(a7)
        move.w #$3ff, -(a7)
; STATE: H005+$3DFC = pointer to persistent state C, 1024 bytes
L006_00000970:
; H006+$00000970: 2f3900003dfc  move.l $3dfc.l, -(a7)
        move.l (H005+$3DFC).l, -(a7)
L006_00000976:
; H006+$00000976: 3f3c0400  move.w #$400, -(a7)
        move.w #$400, -(a7)
L006_0000097A:
; H006+$0000097A: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_0000097C:
; H006+$0000097C: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L006_00000982:
; H006+$00000982: 3f3c1dff  move.w #$1dff, -(a7)
        move.w #$1dff, -(a7)
; STATE: H005+$3DF8 = pointer to the ECL buffer
L006_00000986:
; H006+$00000986: 2f3900003df8  move.l $3df8.l, -(a7)
        move.l (H005+$3DF8).l, -(a7)
L006_0000098C:
; H006+$0000098C: 3f3c1dff  move.w #$1dff, -(a7)
        move.w #$1dff, -(a7)
L006_00000990:
; H006+$00000990: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_00000992:
; H006+$00000992: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L006_00000998:
; H006+$00000998: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
; STATE: H005+$281C = start of the coordinates/view block
L006_0000099C:
; H006+$0000099C: 48790000281c  pea.l $281c.l
        pea.l (H005+$281C).l
L006_000009A2:
; H006+$000009A2: 3f3c0007  move.w #$7, -(a7)
        move.w #$7, -(a7)
L006_000009A6:
; H006+$000009A6: 4227  clr.b -(a7)
        clr.b -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_000009A8:
; H006+$000009A8: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
; STATE: H005+$281C = start of the coordinates/view block
L006_000009AE:
; H006+$000009AE: 33fc00070000281c  move.w #$7, $281c.l
        move.w #$7, (H005+$281C).l
L006_000009B6:
; H006+$000009B6: 33fc000d0000281e  move.w #$d, $281e.l
        move.w #$d, (H005+$281E).l
L006_000009BE:
; H006+$000009BE: 13fc000200002820  move.b #$2, $2820.l
        move.b #$2, (H005+$2820).l
L006_000009C6:
; H006+$000009C6: 3f3c0002  move.w #$2, -(a7)
        move.w #$2, -(a7)
L006_000009CA:
; H006+$000009CA: 4879000024e4  pea.l $24e4.l
        pea.l (H005+$24E4).l
L006_000009D0:
; H006+$000009D0: 3f3c0003  move.w #$3, -(a7)
        move.w #$3, -(a7)
L006_000009D4:
; H006+$000009D4: 1f3c0001  move.b #$1, -(a7)
        move.b #$1, -(a7)
; -> H029+$0312 (sub_H029_00000312)
L006_000009D8:
; H006+$000009D8: 4eb900000312  jsr $312.l
        jsr (H029+$312).l
L006_000009DE:
; H006+$000009DE: 13fc0001000024a2  move.b #$1, $24a2.l
        move.b #$1, (H005+$24A2).l
; STATE: H005+$2810 = three state elements of the wall sets
L006_000009E6:
; H006+$000009E6: 427900002810  clr.w $2810.l
        clr.w (H005+$2810).l
L006_000009EC:
; H006+$000009EC: 33fc000100002812  move.w #$1, $2812.l
        move.w #$1, (H005+$2812).l
L006_000009F4:
; H006+$000009F4: 397c0002fffe  move.w #$2, -$2(a4)
        move.w #$2, -$2(a4)
L006_000009FA:
; H006+$000009FA: 0c6c0003fffe  cmpi.w #$3, -$2(a4)
        cmpi.w #$3, -$2(a4)
L006_00000A00:
; H006+$00000A00: 62000030  bhi.w $a32
        bhi.w H006+$A32
L006_00000A04:
; H006+$00000A04: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000A08:
; H006+$00000A08: 5342  subq.w #$1, d2
        subq.w #$1, d2
L006_00000A0A:
; H006+$00000A0A: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATE: H005+$2810 = three state elements of the wall sets
L006_00000A0C:
; H006+$00000A0C: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L006_00000A12:
; H006+$00000A12: 37bcffff2000  move.w #$ffff, (a3, d2.w)
        move.w #$ffff, (a3, d2.w)
L006_00000A18:
; H006+$00000A18: 342cfffe  move.w -$2(a4), d2
        move.w -$2(a4), d2
L006_00000A1C:
; H006+$00000A1C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L006_00000A1E:
; H006+$00000A1E: e542  asl.w #$2, d2
        asl.w #$2, d2
; STATE: H005+$2810 = three state elements of the wall sets
L006_00000A20:
; H006+$00000A20: 47f900002810  lea.l $2810.l, a3
        lea.l (H005+$2810).l, a3
L006_00000A26:
; H006+$00000A26: 37bcffff2002  move.w #$ffff, $2(a3, d2.w)
        move.w #$ffff, $2(a3, d2.w)
L006_00000A2C:
; H006+$00000A2C: 526cfffe  addq.w #$1, -$2(a4)
        addq.w #$1, -$2(a4)
L006_00000A30:
; H006+$00000A30: 64c8  bcc.b $9fa
        bcc.b H006+$9FA
L006_00000A32:
; H006+$00000A32: 4239000024d2  clr.b $24d2.l
        clr.b (H005+$24D2).l
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_00000A38:
; H006+$00000A38: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_00000A3E:
; H006+$00000A3E: 377c000203f2  move.w #$2, $3f2(a3)
        move.w #$2, $3f2(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_00000A44:
; H006+$00000A44: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_00000A4A:
; H006+$00000A4A: 377c000203f4  move.w #$2, $3f4(a3)
        move.w #$2, $3f4(a3)
; STATE: H005+$3E04 = pointer to persistent state A, 2048 bytes
L006_00000A50:
; H006+$00000A50: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L006_00000A56:
; H006+$00000A56: 377c000203f6  move.w #$2, $3f6(a3)
        move.w #$2, $3f6(a3)
L006_00000A5C:
; H006+$00000A5C: 13fc0001000024ce  move.b #$1, $24ce.l
        move.b #$1, (H005+$24CE).l
L006_00000A64:
; H006+$00000A64: 4239000024d1  clr.b $24d1.l
        clr.b (H005+$24D1).l
L006_00000A6A:
; H006+$00000A6A: 427900003dde  clr.w $3dde.l
        clr.w (H005+$3DDE).l
; STATE: H005+$3364 = head of the party list
L006_00000A70:
; H006+$00000A70: 42b900003364  clr.l $3364.l
        clr.l (H005+$3364).l
; STATE: H005+$3368 = current character
L006_00000A76:
; H006+$00000A76: 42b900003368  clr.l $3368.l
        clr.l (H005+$3368).l
; STATE: H005+$3DEA = logical ECL PC
L006_00000A7C:
; H006+$00000A7C: 33fc350000003dea  move.w #$3500, $3dea.l
        move.w #$3500, (H005+$3DEA).l
L006_00000A84:
; H006+$00000A84: 33fc000400003df6  move.w #$4, $3df6.l
        move.w #$4, (H005+$3DF6).l
; STATE: H005+$246E = resource group selector
L006_00000A8C:
; H006+$00000A8C: 13fc00010000246e  move.b #$1, $246e.l
        move.b #$1, (H005+$246E).l
L006_00000A94:
; H006+$00000A94: 13fc00010000246d  move.b #$1, $246d.l
        move.b #$1, (H005+$246D).l
L006_00000A9C:
; H006+$00000A9C: 423900002825  clr.b $2825.l
        clr.b (H005+$2825).l
; STATE: H005+$3E00 = pointer to persistent state B, 2048 bytes
L006_00000AA2:
; H006+$00000AA2: 267900003e00  movea.l $3e00.l, a3
        movea.l (H005+$3E00).l, a3
L006_00000AA8:
; H006+$00000AA8: 426b067c  clr.w $67c(a3)
        clr.w $67c(a3)
L006_00000AAC:
; H006+$00000AAC: 33fc000100002796  move.w #$1, $2796.l
        move.w #$1, (H005+$2796).l
L006_00000AB4:
; H006+$00000AB4: 4239000024c1  clr.b $24c1.l
        clr.b (H005+$24C1).l
L006_00000ABA:
; H006+$00000ABA: 4239000024e2  clr.b $24e2.l
        clr.b (H005+$24E2).l
L006_00000AC0:
; H006+$00000AC0: 423900002497  clr.b $2497.l
        clr.b (H005+$2497).l
L006_00000AC6:
; H006+$00000AC6: 4239000024bf  clr.b $24bf.l
        clr.b (H005+$24BF).l
L006_00000ACC:
; H006+$00000ACC: 4239000024be  clr.b $24be.l
        clr.b (H005+$24BE).l
L006_00000AD2:
; H006+$00000AD2: 4239000024bd  clr.b $24bd.l
        clr.b (H005+$24BD).l
; STATE: H005+$24D0 = request to exit the scenario loop
L006_00000AD8:
; H006+$00000AD8: 4239000024d0  clr.b $24d0.l
        clr.b (H005+$24D0).l
L006_00000ADE:
; H006+$00000ADE: 13fc0001000024a6  move.b #$1, $24a6.l
        move.b #$1, (H005+$24A6).l
L006_00000AE6:
; H006+$00000AE6: 4239000024ba  clr.b $24ba.l
        clr.b (H005+$24BA).l
L006_00000AEC:
; H006+$00000AEC: 4239000024a4  clr.b $24a4.l
        clr.b (H005+$24A4).l
L006_00000AF2:
; H006+$00000AF2: 47ec00a3  lea.l $a3(a4), a3
        lea.l $a3(a4), a3
L006_00000AF6:
; H006+$00000AF6: 45f9000027a6  lea.l $27a6.l, a2
        lea.l (H005+$27A6).l, a2
L006_00000AFC:
; H006+$00000AFC: 7408  moveq #$8, d2
        moveq #8, d2
L006_00000AFE:
; H006+$00000AFE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L006_00000B00:
; H006+$00000B00: 57cafffc  dbeq d2, $afe
        dbeq d2, H006+$AFE
L006_00000B04:
; H006+$00000B04: 47ec00a5  lea.l $a5(a4), a3
        lea.l $a5(a4), a3
L006_00000B08:
; H006+$00000B08: 45f90000279c  lea.l $279c.l, a2
        lea.l (H005+$279C).l, a2
L006_00000B0E:
; H006+$00000B0E: 7408  moveq #$8, d2
        moveq #8, d2
L006_00000B10:
; H006+$00000B10: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L006_00000B12:
; H006+$00000B12: 57cafffc  dbeq d2, $b10
        dbeq d2, H006+$B10
L006_00000B16:
; H006+$00000B16: 13fc00ff00002486  move.b #$ff, $2486.l
        move.b #$ff, (H005+$2486).l
L006_00000B1E:
; H006+$00000B1E: 13fc00ff00002485  move.b #$ff, $2485.l
        move.b #$ff, (H005+$2485).l
L006_00000B26:
; H006+$00000B26: 4239000024a3  clr.b $24a3.l
        clr.b (H005+$24A3).l
L006_00000B2C:
; H006+$00000B2C: 13fc00e80000247e  move.b #$e8, $247e.l
        move.b #$e8, (H005+$247E).l
L006_00000B34:
; H006+$00000B34: 13fc00db0000247f  move.b #$db, $247f.l
        move.b #$db, (H005+$247F).l
L006_00000B3C:
; H006+$00000B3C: 4239000024b4  clr.b $24b4.l
        clr.b (H005+$24B4).l
L006_00000B42:
; H006+$00000B42: 13fc0001000024c6  move.b #$1, $24c6.l
        move.b #$1, (H005+$24C6).l
L006_00000B4A:
; H006+$00000B4A: 13fc00ff00002484  move.b #$ff, $2484.l
        move.b #$ff, (H005+$2484).l
L006_00000B52:
; H006+$00000B52: 4239000024ad  clr.b $24ad.l
        clr.b (H005+$24AD).l
L006_00000B58:
; H006+$00000B58: 4239000024cf  clr.b $24cf.l
        clr.b (H005+$24CF).l
; -> H008+$139E (sub_H008_0000139E)
L006_00000B5E:
; H006+$00000B5E: 4eb90000139e  jsr $139e.l
        jsr (H008+$139E).l
L006_00000B64:
; H006+$00000B64: 13fc000100002483  move.b #$1, $2483.l
        move.b #$1, (H005+$2483).l
; STATE: H005+$3DE3 = native context, 5 in combat
L006_00000B6C:
; H006+$00000B6C: 13fc000400003de3  move.b #$4, $3de3.l
        move.b #$4, (H005+$3DE3).l
L006_00000B74:
; H006+$00000B74: 423900003de2  clr.b $3de2.l
        clr.b (H005+$3DE2).l
L006_00000B7A:
; H006+$00000B7A: 13fc0001000024a7  move.b #$1, $24a7.l
        move.b #$1, (H005+$24A7).l
L006_00000B82:
; H006+$00000B82: 4239000024e0  clr.b $24e0.l
        clr.b (H005+$24E0).l
L006_00000B88:
; H006+$00000B88: 4239000024b1  clr.b $24b1.l
        clr.b (H005+$24B1).l
L006_00000B8E:
; H006+$00000B8E: 42b900003360  clr.l $3360.l
        clr.l (H005+$3360).l
L006_00000B94:
; H006+$00000B94: 4239000024cb  clr.b $24cb.l
        clr.b (H005+$24CB).l
L006_00000B9A:
; H006+$00000B9A: 4239000024cc  clr.b $24cc.l
        clr.b (H005+$24CC).l
L006_00000BA0:
; H006+$00000BA0: 4239000024b0  clr.b $24b0.l
        clr.b (H005+$24B0).l
L006_00000BA6:
; H006+$00000BA6: 42390000249e  clr.b $249e.l
        clr.b (H005+$249E).l
L006_00000BAC:
; H006+$00000BAC: 4239000024d8  clr.b $24d8.l
        clr.b (H005+$24D8).l
L006_00000BB2:
; H006+$00000BB2: 4239000024da  clr.b $24da.l
        clr.b (H005+$24DA).l
L006_00000BB8:
; H006+$00000BB8: 4239000024ae  clr.b $24ae.l
        clr.b (H005+$24AE).l
L006_00000BBE:
; H006+$00000BBE: 4e5d  unlk a5
        unlk a5
L006_00000BC0:
; H006+$00000BC0: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L006_00000BC2:
; H006+$00000BC2: 4e75  rts 
        rts 
L006_00000BC4:
; H006+$00000BC4: 4e5d  unlk a5
        unlk a5
L006_00000BC6:
; H006+$00000BC6: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L006_00000BC8:
; H006+$00000BC8: 4e75  rts 
        rts 
; Preserved bytes H006+$00000BCA..$00000BCC; code/data not fully classified.
        dc.w $0000
; End H006: $BCC bytes
