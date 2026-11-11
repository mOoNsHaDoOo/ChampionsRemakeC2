/*
 * Champions of Krynn - port in C dall'assembly 68000 (rebuild/source).
 *
 * Regole del port:
 *   - ogni funzione portata ha sopra il marcatore  PORT Hnnn+$XXXX  con
 *     l'indirizzo della routine originale (vedi scripts/port_status.py);
 *   - il comportamento segue l'assembly; dove il C deve scostarsi (host,
 *     puntatori a 64 bit, accessi fuori dai limiti) il commento lo dice;
 *   - le routine non ancora portate stanno in unported.c e fermano il
 *     programma indicando il loro indirizzo.
 *
 * Convenzione di chiamata originale: argomenti sullo stack nell'ordine di
 * dichiarazione (il primo e' all'offset piu' alto), tolti dal chiamato.
 * Nel C gli argomenti seguono lo stesso ordine.
 */
#ifndef COK_H
#define COK_H

#include <stddef.h>
#include <string.h>

/* Piattaforma: SAS/C (o altro compilatore Amiga) oppure host. */
#if defined(__SASC) || defined(__AMIGA__) || defined(AMIGA)
#define COK_AMIGA 1
#else
#define COK_AMIGA 0
#endif

#if COK_AMIGA
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/view.h>
#include <intuition/preferences.h>
#include <dos/dosextens.h>
typedef unsigned char  u8;
typedef signed char    s8;
typedef unsigned short u16;
typedef signed short   s16;
typedef unsigned long  u32;
typedef signed long    s32;
#else
#include <stdint.h>
#include "host/ndk.h"
typedef uint8_t  u8;
typedef int8_t   s8;
typedef uint16_t u16;
typedef int16_t  s16;
typedef uint32_t u32;
typedef int32_t  s32;
#endif

/* Word e long big-endian dentro i blocchi di byte (formato dei file). */
#define COK_GET16(p)  ((u16)(((const u8 *)(p))[0] << 8 | ((const u8 *)(p))[1]))
#define COK_GET32(p)  ((u32)COK_GET16(p) << 16 | COK_GET16((const u8 *)(p) + 2))
/* Argomento valutato una sola volta (puo' essere una chiamata). */
#define COK_PUT16(p, v) do { u16 cok_w_ = (u16)(v); \
                             u8 *cok_p_ = (u8 *)(p); \
                             cok_p_[0] = (u8)(cok_w_ >> 8); \
                             cok_p_[1] = (u8)cok_w_; } while (0)
#define COK_PUT32(p, v) do { u32 cok_l_ = (u32)(v); \
                             u8 *cok_q_ = (u8 *)(p); \
                             cok_q_[0] = (u8)(cok_l_ >> 24); \
                             cok_q_[1] = (u8)(cok_l_ >> 16); \
                             cok_q_[2] = (u8)(cok_l_ >> 8); \
                             cok_q_[3] = (u8)cok_l_; } while (0)

/* Ferma il programma su una routine non ancora portata (unported.c). */
void cok_unported(const char *where);
/*
 * Routine non ancora portata che si puo' saltare senza fermare il gioco
 * (solo audio): stampa un avviso la prima volta e prosegue.
 */
void cok_unported_skip(const char *where);

#endif
