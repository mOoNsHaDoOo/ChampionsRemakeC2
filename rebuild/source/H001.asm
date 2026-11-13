; ============================================================================
; MODULE GUIDE H001
; Main coordination: environment, introduction, party menu and scenario.
; The comments describe the analysis of the sample; they are not names from the original source.
; Levels: verified / partial. The areas without comments are not to be taken as solved.
; ============================================================================

; --------------------------------------------------------------------------
; MODULE NOTE
; main coordinates environment, introduction, party menu and entry into the scenario. The routines called here are the junctions between the subsystems.
; --------------------------------------------------------------------------
; H001: 664 original bytes; all offsets are section-relative.
        section H001,code
H001:
; Preserved bytes H001+$00000000..$00000058; code/data not fully classified.
        dc.w $0000,$0000,$0000,$6466,$303A,$0000,$0043,$6861
        dc.w $6D70,$696F,$6E73,$206F,$6620,$4B72,$796E,$6E20
        dc.w $7631,$2E30,$2000,$506C,$6179,$2044,$656D,$6F00
        dc.w $4368,$616D,$7069,$6F6E,$7320,$6F66,$204B,$7279
        dc.w $6E6E,$2076,$312E,$3020,$0050,$6C61,$7920,$4465
        dc.w $6D6F,$0000
        dc.l H001+$00000004
; FUNCTION: main_entry
FN_main_entry:
;
; --------------------------------------------------------------------------
; ROUTINE: Game_Main [verified]
; Purpose: Coordinates start-up, party composition menu and game session.
;   - Initialises tables; determines the file prefix and prepares environment and screens.
;   - Normalises the answer to the demo choice: D selects the demonstration branch.
;   - The normal branch calls H013+$4BFC; the demo branch sets resource group 2 and initial value 9.
;   - Moves to the scenario loop H012+$3150; on return it cleans up and offers the initial path again.
; --------------------------------------------------------------------------
L001_00000058:
; H001+$00000058: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L001_0000005A:
; H001+$0000005A: 287afff8  movea.l $54(pc), a4
        movea.l H001+$54(pc), a4
L001_0000005E:
; H001+$0000005E: 4e550000  link.w a5, #$0
        link.w a5, #$0
L001_00000062:
; H001+$00000062: 6000009e  bra.w $102
        bra.w H001+$102
; FUNCTION: select_volume_prefix
FN_select_volume_prefix:
;
; --------------------------------------------------------------------------
; ROUTINE: Select_DataPrefix [verified]
; Purpose: Chooses the path prefix according to the information about the current volume.
;   - Lock on the empty name with mode -2.
;   - Info writes a 36-byte buffer; id_NumBlocks is compared with 1800.
;   - Below the threshold it copies df0: into H005+$3D26, otherwise an empty string.
;   - Frees buffer and lock.
; Direct callers: H001+$0108
; --------------------------------------------------------------------------
L001_00000066:
; H001+$00000066: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L001_00000068:
; H001+$00000068: 287affea  movea.l $54(pc), a4
        movea.l H001+$54(pc), a4
L001_0000006C:
; H001+$0000006C: 4e55fff6  link.w a5, #$fff6
        link.w a5, #$fff6
L001_00000070:
; H001+$00000070: 47ec0000  lea.l $0(a4), a3
        lea.l $0(a4), a3
L001_00000074:
; H001+$00000074: 2f0b  move.l a3, -(a7)
        move.l a3, -(a7)
L001_00000076:
; H001+$00000076: 2f3cfffffffe  move.l #$fffffffe, -(a7)
        move.l #$fffffffe, -(a7)
; -> H002+$00DC (wrapper_Lock)
L001_0000007C:
; H001+$0000007C: 4eb9000000dc  jsr $dc.l
        jsr (H002+$DC).l
L001_00000082:
; H001+$00000082: 2b40fffc  move.l d0, -$4(a5)
        move.l d0, -$4(a5)
L001_00000086:
; H001+$00000086: 7424  moveq #$24, d2
        moveq #36, d2
L001_00000088:
; H001+$00000088: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
L001_0000008A:
; H001+$0000008A: 2f3c00010000  move.l #$10000, -(a7)
        move.l #MEMF_CLEAR, -(a7)
; -> H003+$0068 (wrapper_AllocMem)
L001_00000090:
; H001+$00000090: 4eb900000068  jsr $68.l
        jsr (H003+$68).l
L001_00000096:
; H001+$00000096: 2b40fff8  move.l d0, -$8(a5)
        move.l d0, -$8(a5)
L001_0000009A:
; H001+$0000009A: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
L001_0000009E:
; H001+$0000009E: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
; -> H002+$00A0 (wrapper_Info)
L001_000000A2:
; H001+$000000A2: 4eb9000000a0  jsr $a0.l
        jsr (H002+$A0).l
L001_000000A8:
; H001+$000000A8: 1b40fff7  move.b d0, -$9(a5)
        move.b d0, -$9(a5)
L001_000000AC:
; H001+$000000AC: 266dfff8  movea.l -$8(a5), a3
        movea.l -$8(a5), a3
L001_000000B0:
; H001+$000000B0: 0cab00000708000c  cmpi.l #$708, $c(a3)
        cmpi.l #$708, $c(a3)
L001_000000B8:
; H001+$000000B8: 6c000018  bge.w $d2
        bge.w H001+$D2
L001_000000BC:
; H001+$000000BC: 47ec0002  lea.l $2(a4), a3
        lea.l $2(a4), a3
; STATE: H005+$3D26 = prefix of the data files
L001_000000C0:
; H001+$000000C0: 45f900003d26  lea.l $3d26.l, a2
        lea.l (H005+$3D26).l, a2
L001_000000C6:
; H001+$000000C6: 7450  moveq #$50, d2
        moveq #80, d2
L001_000000C8:
; H001+$000000C8: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L001_000000CA:
; H001+$000000CA: 57cafffc  dbeq d2, $c8
        dbeq d2, H001+$C8
L001_000000CE:
; H001+$000000CE: 60000014  bra.w $e4
        bra.w H001+$E4
L001_000000D2:
; H001+$000000D2: 47ec0007  lea.l $7(a4), a3
        lea.l $7(a4), a3
; STATE: H005+$3D26 = prefix of the data files
L001_000000D6:
; H001+$000000D6: 45f900003d26  lea.l $3d26.l, a2
        lea.l (H005+$3D26).l, a2
L001_000000DC:
; H001+$000000DC: 7450  moveq #$50, d2
        moveq #80, d2
L001_000000DE:
; H001+$000000DE: 14db  move.b (a3)+, (a2)+
        move.b (a3)+, (a2)+
L001_000000E0:
; H001+$000000E0: 57cafffc  dbeq d2, $de
        dbeq d2, H001+$DE
L001_000000E4:
; H001+$000000E4: 2f2dfffc  move.l -$4(a5), -(a7)
        move.l -$4(a5), -(a7)
; -> H002+$01A2 (wrapper_UnLock)
L001_000000E8:
; H001+$000000E8: 4eb9000001a2  jsr $1a2.l
        jsr (H002+$1A2).l
L001_000000EE:
; H001+$000000EE: 2f2dfff8  move.l -$8(a5), -(a7)
        move.l -$8(a5), -(a7)
L001_000000F2:
; H001+$000000F2: 7424  moveq #$24, d2
        moveq #36, d2
L001_000000F4:
; H001+$000000F4: 2f02  move.l d2, -(a7)
        move.l d2, -(a7)
; -> H003+$00F6 (wrapper_FreeMem)
L001_000000F6:
; H001+$000000F6: 4eb9000000f6  jsr $f6.l
        jsr (H003+$F6).l
L001_000000FC:
; H001+$000000FC: 4e5d  unlk a5
        unlk a5
L001_000000FE:
; H001+$000000FE: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L001_00000100:
; H001+$00000100: 4e75  rts 
        rts 
; -> H004+$0C28 (sub_H004_00000C28)
L001_00000102:
; H001+$00000102: 4eb900000c28  jsr $c28.l
        jsr (H004+$C28).l
; FLOW: Calls Select_DataPrefix (H001+$0066).
L001_00000108:
; H001+$00000108: 6100ff5c  bsr.w $66
        bsr.w H001+$66
; STEP: Common initialisation: paths, state buffers, bitmaps and shared resources.
; FLOW: Calls Initialize_GameEnvironment (H006+$01AE).
L001_0000010C:
; H001+$0000010C: 4eb9000001ae  jsr $1ae.l
        jsr (H006+$1AE).l
; STEP: Introductory screens and audio initialisation.
; FLOW: Calls Intro_LoadAndShow (H007+$09D8).
L001_00000112:
; H001+$00000112: 4eb9000009d8  jsr $9d8.l
        jsr (H007+$9D8).l
L001_00000118:
; H001+$00000118: 243c00000bb8  move.l #$bb8, d2
        move.l #$bb8, d2
L001_0000011E:
; H001+$0000011E: 23c200002792  move.l d2, $2792.l
        move.l d2, (H005+$2792).l
L001_00000124:
; H001+$00000124: 13fc0044000052fb  move.b #$44, $52fb.l
        move.b #$44, (H005+$52FB).l
L001_0000012C:
; H001+$0000012C: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L001_00000130:
; H001+$00000130: 486c0009  pea.l $9(a4)
        pea.l $9(a4)
L001_00000134:
; H001+$00000134: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L001_00000138:
; H001+$00000138: 486c0022  pea.l $22(a4)
        pea.l $22(a4)
L001_0000013C:
; H001+$0000013C: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L001_00000140:
; H001+$00000140: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L001_00000144:
; H001+$00000144: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L001_00000148:
; H001+$00000148: 4227  clr.b -(a7)
        clr.b -(a7)
L001_0000014A:
; H001+$0000014A: 4227  clr.b -(a7)
        clr.b -(a7)
L001_0000014C:
; H001+$0000014C: 486cfffe  pea.l -$2(a4)
        pea.l -$2(a4)
; FLOW: Calls UI_RequestChoice (H008+$01FC).
L001_00000150:
; H001+$00000150: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L001_00000156:
; H001+$00000156: 1940ffff  move.b d0, -$1(a4)
        move.b d0, -$1(a4)
L001_0000015A:
; H001+$0000015A: 7400  moveq #$0, d2
        moveq #0, d2
L001_0000015C:
; H001+$0000015C: 23c200002792  move.l d2, $2792.l
        move.l d2, (H005+$2792).l
L001_00000162:
; H001+$00000162: 4239000052fb  clr.b $52fb.l
        clr.b (H005+$52FB).l
L001_00000168:
; H001+$00000168: 142cffff  move.b -$1(a4), d2
        move.b -$1(a4), d2
L001_0000016C:
; H001+$0000016C: 0c020061  cmpi.b #$61, d2
        cmpi.b #$61, d2
L001_00000170:
; H001+$00000170: 650a  bcs.b $17c
        bcs.b H001+$17C
L001_00000172:
; H001+$00000172: 0c02007a  cmpi.b #$7a, d2
        cmpi.b #$7a, d2
L001_00000176:
; H001+$00000176: 6204  bhi.b $17c
        bhi.b H001+$17C
L001_00000178:
; H001+$00000178: 0202005f  andi.b #$5f, d2
        andi.b #$5f, d2
L001_0000017C:
; H001+$0000017C: 0c020044  cmpi.b #$44, d2
        cmpi.b #$44, d2
L001_00000180:
; H001+$00000180: 6600000e  bne.w $190
        bne.w H001+$190
; STATE: H005+$24D7 = flag of the demo branch
L001_00000184:
; H001+$00000184: 13fc0001000024d7  move.b #$1, $24d7.l
        move.b #$1, (H005+$24D7).l
L001_0000018C:
; H001+$0000018C: 60000008  bra.w $196
        bra.w H001+$196
; STATE: H005+$24D7 = flag of the demo branch
L001_00000190:
; H001+$00000190: 4239000024d7  clr.b $24d7.l
        clr.b (H005+$24D7).l
; STATE: H005+$24D7 = flag of the demo branch
L001_00000196:
; H001+$00000196: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L001_0000019C:
; H001+$0000019C: 6600003a  bne.w $1d8
        bne.w H001+$1D8
; -> H009+$010C (sub_H009_0000010C)
L001_000001A0:
; H001+$000001A0: 4eb90000010c  jsr $10c.l
        jsr (H009+$10C).l
L001_000001A6:
; H001+$000001A6: 1400  move.b d0, d2
        move.b d0, d2
L001_000001A8:
; H001+$000001A8: 4a02  tst.b d2
        tst.b d2
L001_000001AA:
; H001+$000001AA: 66000008  bne.w $1b4
        bne.w H001+$1B4
; -> H010+$0332 (sub_H010_00000332)
L001_000001AE:
; H001+$000001AE: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
L001_000001B4:
; H001+$000001B4: 0c793f8f00000000  cmpi.w #$3f8f, $0.l
        cmpi.w #$3f8f, (H009+$0).l
L001_000001BC:
; H001+$000001BC: 67000008  beq.w $1c6
        beq.w H001+$1C6
; -> H010+$0332 (sub_H010_00000332)
L001_000001C0:
; H001+$000001C0: 4eb900000332  jsr $332.l
        jsr (H010+$332).l
; STATE: H005+$246E = resource group selector
L001_000001C6:
; H001+$000001C6: 13fc00010000246e  move.b #$1, $246e.l
        move.b #$1, (H005+$246E).l
; STEP: The menu also allows Load/Save; the return leads to the scenario loop.
; FLOW: Calls Party_MainMenu (H013+$4BFC).
L001_000001CE:
; H001+$000001CE: 4eb900004bfc  jsr $4bfc.l
        jsr (H013+$4BFC).l
L001_000001D4:
; H001+$000001D4: 60000012  bra.w $1e8
        bra.w H001+$1E8
; STATE: H005+$246E = resource group selector
L001_000001D8:
; H001+$000001D8: 13fc00020000246e  move.b #$2, $246e.l
        move.b #$2, (H005+$246E).l
L001_000001E0:
; H001+$000001E0: 33fc000900003df6  move.w #$9, $3df6.l
        move.w #$9, (H005+$3DF6).l
L001_000001E8:
; H001+$000001E8: 7400  moveq #$0, d2
        moveq #0, d2
L001_000001EA:
; H001+$000001EA: 143900002829  move.b $2829.l, d2
        move.b (H005+$2829).l, d2
L001_000001F0:
; H001+$000001F0: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L001_000001F2:
; H001+$000001F2: 7400  moveq #$0, d2
        moveq #0, d2
L001_000001F4:
; H001+$000001F4: 143900002828  move.b $2828.l, d2
        move.b (H005+$2828).l, d2
L001_000001FA:
; H001+$000001FA: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L001_000001FC:
; H001+$000001FC: 7400  moveq #$0, d2
        moveq #0, d2
L001_000001FE:
; H001+$000001FE: 143900002827  move.b $2827.l, d2
        move.b (H005+$2827).l, d2
L001_00000204:
; H001+$00000204: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L001_00000206:
; H001+$00000206: 7400  moveq #$0, d2
        moveq #0, d2
L001_00000208:
; H001+$00000208: 143900002826  move.b $2826.l, d2
        move.b (H005+$2826).l, d2
L001_0000020E:
; H001+$0000020E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H011+$04A6 (sub_H011_000004A6)
L001_00000210:
; H001+$00000210: 4eb9000004a6  jsr $4a6.l
        jsr (H011+$4A6).l
; STEP: Entry into the native scenario loop, after the selection of the resources.
; FLOW: Calls Scenario_MainLoop (H012+$3150).
L001_00000216:
; H001+$00000216: 4eb900003150  jsr $3150.l
        jsr (H012+$3150).l
; -> H006+$0914 (sub_H006_00000914)
L001_0000021C:
; H001+$0000021C: 4eb900000914  jsr $914.l
        jsr (H006+$914).l
; STATE: H005+$24D7 = flag of the demo branch
L001_00000222:
; H001+$00000222: 4a39000024d7  tst.b $24d7.l
        tst.b (H005+$24D7).l
L001_00000228:
; H001+$00000228: 6700005e  beq.w $288
        beq.w H001+$288
; STATE: H005+$246E = resource group selector
L001_0000022C:
; H001+$0000022C: 42390000246e  clr.b $246e.l
        clr.b (H005+$246E).l
; FLOW: Calls Intro_LoadAndShow (H007+$09D8).
L001_00000232:
; H001+$00000232: 4eb9000009d8  jsr $9d8.l
        jsr (H007+$9D8).l
L001_00000238:
; H001+$00000238: 243c000003e8  move.l #$3e8, d2
        move.l #$3e8, d2
L001_0000023E:
; H001+$0000023E: 23c200002792  move.l d2, $2792.l
        move.l d2, (H005+$2792).l
L001_00000244:
; H001+$00000244: 13fc0044000052fb  move.b #$44, $52fb.l
        move.b #$44, (H005+$52FB).l
L001_0000024C:
; H001+$0000024C: 3f3c0018  move.w #$18, -(a7)
        move.w #$18, -(a7)
L001_00000250:
; H001+$00000250: 486c002c  pea.l $2c(a4)
        pea.l $2c(a4)
L001_00000254:
; H001+$00000254: 3f3c0009  move.w #$9, -(a7)
        move.w #$9, -(a7)
L001_00000258:
; H001+$00000258: 486c0045  pea.l $45(a4)
        pea.l $45(a4)
L001_0000025C:
; H001+$0000025C: 3f3c000d  move.w #$d, -(a7)
        move.w #$d, -(a7)
L001_00000260:
; H001+$00000260: 3f3c000a  move.w #$a, -(a7)
        move.w #$a, -(a7)
L001_00000264:
; H001+$00000264: 3f3c000f  move.w #$f, -(a7)
        move.w #$f, -(a7)
L001_00000268:
; H001+$00000268: 4227  clr.b -(a7)
        clr.b -(a7)
L001_0000026A:
; H001+$0000026A: 4227  clr.b -(a7)
        clr.b -(a7)
L001_0000026C:
; H001+$0000026C: 486cfffe  pea.l -$2(a4)
        pea.l -$2(a4)
; FLOW: Calls UI_RequestChoice (H008+$01FC).
L001_00000270:
; H001+$00000270: 4eb9000001fc  jsr $1fc.l
        jsr (H008+$1FC).l
L001_00000276:
; H001+$00000276: 1940ffff  move.b d0, -$1(a4)
        move.b d0, -$1(a4)
L001_0000027A:
; H001+$0000027A: 7400  moveq #$0, d2
        moveq #0, d2
L001_0000027C:
; H001+$0000027C: 23c200002792  move.l d2, $2792.l
        move.l d2, (H005+$2792).l
L001_00000282:
; H001+$00000282: 4239000052fb  clr.b $52fb.l
        clr.b (H005+$52FB).l
L001_00000288:
; H001+$00000288: 7400  moveq #$0, d2
        moveq #0, d2
L001_0000028A:
; H001+$0000028A: 4a02  tst.b d2
        tst.b d2
L001_0000028C:
; H001+$0000028C: 6700feda  beq.w $168
        beq.w H001+$168
L001_00000290:
; H001+$00000290: 4e5d  unlk a5
        unlk a5
L001_00000292:
; H001+$00000292: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L001_00000294:
; H001+$00000294: 4e75  rts 
        rts 
; Preserved bytes H001+$00000296..$00000298; code/data not fully classified.
        dc.w $0000
; End H001: $298 bytes
