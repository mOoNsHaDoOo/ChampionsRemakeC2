; ============================================================================
; GUIDA DEL MODULO H069
; composizione della vista 3D e servizi di disegno.
; I commenti descrivono l'analisi del campione; non sono nomi del sorgente originale.
; Livelli: verificato / parziale. Le aree non commentate non sono date per risolte.
; ============================================================================
; --------------------------------------------------------------------------
; NOTA MODULO
; Composizione della vista 3D e servizi di disegno: usa i record grafici H029 e le penne H038.
; --------------------------------------------------------------------------
; H069: 232 original bytes; all offsets are section-relative.
        section H069,code
H069:
; Preserved bytes H069+$00000000..$00000004; code/data not fully classified.
        dc.l H069+$00000000
; --------------------------------------------------------------------------
; ROUTINE: module_init_H069 [parziale]
; Scopo: Ingresso del modulo composizione della vista 3D e servizi di disegno; imposta la base dati A4 e prosegue nel corpo del modulo.
;   - Salta al corpo effettivo a H069+$00E0.
; Chiamanti diretti: H000+$0228
; --------------------------------------------------------------------------
L069_00000004:
; H069+$00000004: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L069_00000006:
; H069+$00000006: 287afff8  movea.l $0(pc), a4
        movea.l H069+$0(pc), a4
L069_0000000A:
; H069+$0000000A: 4e550000  link.w a5, #$0
        link.w a5, #$0
L069_0000000E:
; H069+$0000000E: 600000d0  bra.w $e0
        bra.w H069+$E0
; --------------------------------------------------------------------------
; ROUTINE: sub_H069_00000012 [parziale]
; Scopo: Routine del modulo composizione della vista 3D e servizi di disegno; richiama H029+$0E26, H038+$013C, H038+$01B4, H038+$0118.
;   - Richiama H029+$0E26.
;   - Richiama H038+$013C.
;   - Richiama H038+$01B4.
;   - Richiama H038+$0118.
;   - Usa lo stato globale: H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H012+$299A, H064+$0B88, H068+$0BF4, H012+$0B04
; --------------------------------------------------------------------------
L069_00000012:
; H069+$00000012: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L069_00000014:
; H069+$00000014: 287affea  movea.l $0(pc), a4
        movea.l H069+$0(pc), a4
L069_00000018:
; H069+$00000018: 4e55fffc  link.w a5, #$fffc
        link.w a5, #$fffc
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L069_0000001C:
; H069+$0000001C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L069_00000022:
; H069+$00000022: 342b0186  move.w $186(a3), d2
        move.w $186(a3), d2
L069_00000026:
; H069+$00000026: 5242  addq.w #$1, d2
        addq.w #$1, d2
L069_00000028:
; H069+$00000028: 3b42fffe  move.w d2, -$2(a5)
        move.w d2, -$2(a5)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L069_0000002C:
; H069+$0000002C: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L069_00000032:
; H069+$00000032: 342b0188  move.w $188(a3), d2
        move.w $188(a3), d2
L069_00000036:
; H069+$00000036: 5242  addq.w #$1, d2
        addq.w #$1, d2
L069_00000038:
; H069+$00000038: 3b42fffc  move.w d2, -$4(a5)
        move.w d2, -$4(a5)
L069_0000003C:
; H069+$0000003C: 3f2dfffe  move.w -$2(a5), -(a7)
        move.w -$2(a5), -(a7)
L069_00000040:
; H069+$00000040: 3f2dfffc  move.w -$4(a5), -(a7)
        move.w -$4(a5), -(a7)
L069_00000044:
; H069+$00000044: 2f3900003334  move.l $3334.l, -(a7)
        move.l (H005+$3334).l, -(a7)
; -> H029+$0E26 (trampoline_H029_0E88)
L069_0000004A:
; H069+$0000004A: 4eb900000e26  jsr $e26.l
        jsr (H029+$E26).l
L069_00000050:
; H069+$00000050: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L069_00000056:
; H069+$00000056: 3f3c000e  move.w #$e, -(a7)
        move.w #$e, -(a7)
; -> H038+$013C (wrapper_SetAPen)
L069_0000005A:
; H069+$0000005A: 4eb90000013c  jsr $13c.l
        jsr (H038+$13C).l
L069_00000060:
; H069+$00000060: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L069_00000066:
; H069+$00000066: 4267  clr.w -(a7)
        clr.w -(a7)
; -> H038+$01B4 (sub_H038_000001B4)
L069_00000068:
; H069+$00000068: 4eb9000001b4  jsr $1b4.l
        jsr (H038+$1B4).l
L069_0000006E:
; H069+$0000006E: 2f39000052ee  move.l $52ee.l, -(a7)
        move.l (H005+$52EE).l, -(a7)
L069_00000074:
; H069+$00000074: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L069_00000078:
; H069+$00000078: e742  asl.w #$3, d2
        asl.w #$3, d2
L069_0000007A:
; H069+$0000007A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L069_0000007C:
; H069+$0000007C: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L069_00000080:
; H069+$00000080: e742  asl.w #$3, d2
        asl.w #$3, d2
L069_00000082:
; H069+$00000082: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L069_00000084:
; H069+$00000084: 342dfffe  move.w -$2(a5), d2
        move.w -$2(a5), d2
L069_00000088:
; H069+$00000088: 5242  addq.w #$1, d2
        addq.w #$1, d2
L069_0000008A:
; H069+$0000008A: e742  asl.w #$3, d2
        asl.w #$3, d2
L069_0000008C:
; H069+$0000008C: 5342  subq.w #$1, d2
        subq.w #$1, d2
L069_0000008E:
; H069+$0000008E: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L069_00000090:
; H069+$00000090: 342dfffc  move.w -$4(a5), d2
        move.w -$4(a5), d2
L069_00000094:
; H069+$00000094: 5242  addq.w #$1, d2
        addq.w #$1, d2
L069_00000096:
; H069+$00000096: e742  asl.w #$3, d2
        asl.w #$3, d2
L069_00000098:
; H069+$00000098: 5342  subq.w #$1, d2
        subq.w #$1, d2
L069_0000009A:
; H069+$0000009A: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; -> H038+$0118 (wrapper_RectFill)
L069_0000009C:
; H069+$0000009C: 4eb900000118  jsr $118.l
        jsr (H038+$118).l
L069_000000A2:
; H069+$000000A2: 4e5d  unlk a5
        unlk a5
L069_000000A4:
; H069+$000000A4: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L069_000000A6:
; H069+$000000A6: 4e75  rts 
        rts 
; --------------------------------------------------------------------------
; ROUTINE: sub_H069_000000A8 [parziale]
; Scopo: Routine del modulo composizione della vista 3D e servizi di disegno; richiama H029+$0E92.
;   - Richiama H029+$0E92.
;   - Usa lo stato globale: H005+$3E04 (puntatore stato persistente A, 2048 byte).
; Chiamanti diretti: H068+$0B36
; --------------------------------------------------------------------------
L069_000000A8:
; H069+$000000A8: 2f0c  move.l a4, -(a7)
        move.l a4, -(a7)
L069_000000AA:
; H069+$000000AA: 287aff54  movea.l $0(pc), a4
        movea.l H069+$0(pc), a4
L069_000000AE:
; H069+$000000AE: 4e550000  link.w a5, #$0
        link.w a5, #$0
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L069_000000B2:
; H069+$000000B2: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L069_000000B8:
; H069+$000000B8: 342b0186  move.w $186(a3), d2
        move.w $186(a3), d2
L069_000000BC:
; H069+$000000BC: 5242  addq.w #$1, d2
        addq.w #$1, d2
L069_000000BE:
; H069+$000000BE: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
; STATO: H005+$3E04 = puntatore stato persistente A, 2048 byte
L069_000000C0:
; H069+$000000C0: 267900003e04  movea.l $3e04.l, a3
        movea.l (H005+$3E04).l, a3
L069_000000C6:
; H069+$000000C6: 342b0188  move.w $188(a3), d2
        move.w $188(a3), d2
L069_000000CA:
; H069+$000000CA: 5242  addq.w #$1, d2
        addq.w #$1, d2
L069_000000CC:
; H069+$000000CC: 3f02  move.w d2, -(a7)
        move.w d2, -(a7)
L069_000000CE:
; H069+$000000CE: 2f3900003334  move.l $3334.l, -(a7)
        move.l (H005+$3334).l, -(a7)
; -> H029+$0E92 (trampoline_H029_0EF4)
L069_000000D4:
; H069+$000000D4: 4eb900000e92  jsr $e92.l
        jsr (H029+$E92).l
L069_000000DA:
; H069+$000000DA: 4e5d  unlk a5
        unlk a5
L069_000000DC:
; H069+$000000DC: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L069_000000DE:
; H069+$000000DE: 4e75  rts 
        rts 
L069_000000E0:
; H069+$000000E0: 4e5d  unlk a5
        unlk a5
L069_000000E2:
; H069+$000000E2: 285f  movea.l (a7)+, a4
        movea.l (a7)+, a4
L069_000000E4:
; H069+$000000E4: 4e75  rts 
        rts 
; Preserved bytes H069+$000000E6..$000000E8; code/data not fully classified.
        dc.w $0000
; End H069: $E8 bytes
