/* H077: visual effects of combat and spells. */
#include "h077.h"
#include "h048.h"
#include "globals.h"
#include <string.h>

/* PORT H077+$0004: link/unlk, no effect. */
void h077_init(void)
{
}

/* PORT H077+$0012: sign of v (-1, 0, 1). */
static s16 sign_of(s16 v)
{
    if (v < 0) {
        return -1;
    }
    if (v > 0) {
        return 1;
    }
    return 0;
}

/* PORT H077+$01CC: prepares the line from (x0, y0) to (x1, y1). */
void line_init(CokLine *l)
{
    s16 d;

    l->cx = l->x0;
    l->cy = l->y0;
    d = (s16)(l->x1 - l->x0);
    l->dx = (s16)(d < 0 ? -d : d);
    d = (s16)(l->y1 - l->y0);
    l->dy = (s16)(d < 0 ? -d : d);
    l->sx = sign_of((s16)(l->x1 - l->x0));
    l->sy = sign_of((s16)(l->y1 - l->y0));
    l->err = 0;
    l->cost = 0;
}

/* PORT H077+$0242: one step of the line; 0 if it was already at the end. */
u8 line_step(CokLine *l)
{
    u8 moved = 0;                       /* -$5(a5) */
    s16 ix = 1;                         /* -$2(a5) */
    s16 iy = 1;                         /* -$4(a5) */

    if (l->dx >= l->dy) {
        if (l->cx != l->x1) {
            l->cx = (s16)(l->cx + l->sx);
            ix = (s16)(l->sx + 1);
            l->err = (s16)(l->err + l->dy * 2);
            l->cost = (u8)(l->cost + 2);
            if (l->err >= l->dx) {
                l->err = (s16)(l->err - l->dx * 2);
                l->cy = (s16)(l->cy + l->sy);
                iy = (s16)(l->sy + 1);
                l->cost = (u8)(l->cost + 1);
            }
            moved = 1;
        }
    } else if (l->cy != l->y1) {
        l->cy = (s16)(l->cy + l->sy);
        iy = (s16)(l->sy + 1);
        l->err = (s16)(l->err + l->dx * 2);
        l->cost = (u8)(l->cost + 2);
        if (l->err >= l->dy) {
            l->err = (s16)(l->err - l->dy * 2);
            l->cx = (s16)(l->cx + l->sx);
            ix = (s16)(l->sx + 1);
            l->cost = (u8)(l->cost + 1);
        }
        moved = 1;
    }
    /* $3DD2: direction from the line step: index (dy+1)*4 + (dx+1) */
    l->dir = H005_B(0x3DD2 + iy * 4 + ix);
    return moved;
}

/* Square (x, y), upper part, of the area map. */
static u8 overlay_at(u8 *area, s16 x, s16 y)
{
    return area[0x0A + (s32)y * 0x64 + x * 2 + 1];
}

/*
 * PORT H077+$0378: line of sight from (ox, oy) towards (*tx, *ty) within
 * *dist squares (cost <= 2 * *dist + 1): a second line keeps the
 * height (H005+$3EF4 +1) of the origin and the higher squares (+2)
 * block the view, if the map checks them (+$8 = 0).  If it stops,
 * *tx, *ty and *dist give the point reached and it returns 0; otherwise
 * *dist = cost and 1.
 */
u8 line_of_sight(s16 ox, s16 oy, s16 *tx, s16 *ty, u16 *dist, u8 *area)
{
    u16 limit;                          /* -$34(a5) */
    CokLine l1;                         /* -$18(a5) */
    CokLine l2;                         /* -$30(a5) */
    u8 done;                            /* -$31(a5) */

    limit = (u16)(*dist * 2 + 1);
    l1.x0 = ox;
    l1.y0 = oy;
    l1.x1 = *tx;
    l1.y1 = *ty;
    line_init(&l1);
    l2.x0 = 0;
    /* $3EF5: terrain +1: height of the origin for the line of sight */
    l2.y0 = H005_B(0x3EF4 + (overlay_at(area, ox, oy) - 1) * 4 + 1);
    l2.x1 = (l1.dx > l1.dy) ? l1.dx : l1.dy;
    /* $3EF5: terrain +1: height of the origin for the line of sight */
    l2.y1 = H005_B(0x3EF4 + (overlay_at(area, ox, oy) - 1) * 4 + 1);
    line_init(&l2);
    do {
        if ((area[8] == 0 &&
             l2.cy < H005_B(0x3EF4 + /* $3EF6: terrain +2: height that blocks the line of sight */
                            (overlay_at(area, l1.cx, l1.cy) - 1) * 4 + 2)) ||
            l1.cost > limit) {
            *tx = l1.cx;
            *ty = l1.cy;
            *dist = l1.cost;
            return 0;
        }
        (void)line_step(&l2);
        done = (u8)(line_step(&l1) == 0);
    } while (!done);
    *dist = l1.cost;
    return 1;
}

/*
 * PORT H077+$0508: is (x1, y1) in the sector of direction dir (0..7,
 * $FF = 8: all) seen from (x0, y0)?  Off the map no; the same square and
 * the adjacent one in that direction yes.  With dir beyond 8 the original
 * returns an uninitialised byte: here 0.
 */
u8 in_direction(s16 x0, s16 y0, s16 x1, s16 y1, u16 dir)
{
    s16 px;                             /* -$2(a5) */
    s16 py;                             /* -$4(a5) */
    s16 x = x1;
    s16 y = y1;

    if (x0 < 0 || x0 > 0x31 || y0 < 0 || y0 > 0x18 ||
        x1 < 0 || x1 > 0x31 || y1 < 0 || y1 > 0x18) {
        return 0;
    }
    if (dir == 0xFF) {
        dir = 8;
    }
    px = (s16)(x0 + H005_W(0x3EE2 + dir * 2)); /* $3EE2: (word) x offset for direction d (step 2) */
    py = (s16)(y0 + H005_W(0x3ED0 + dir * 2)); /* $3ED0: (word) y offset for direction d (step 2) */
    if ((x0 == x1 && y0 == y1) || (px == x1 && py == y1)) {
        return 1;
    }
    switch (dir) {
    case 0:
        return (u8)((x >= px && y <= (s16)(px - x + py)) ||
                    (x <= px && y <= (s16)(x - px + py)));
    case 1:
        return (u8)((x >= px && y <= (s16)(px - x + py)) ||
                    (x >= (s16)(px + py - y) && y <= py));
    case 2:
        return (u8)((x >= (s16)(px + py - y) && y <= py) ||
                    (x >= (s16)(px + y - py) && y >= py));
    case 3:
        return (u8)((x >= (s16)(px + y - py) && y >= py) ||
                    (x >= px && y >= (s16)(x - px + py)));
    case 4:
        return (u8)((x >= px && y >= (s16)(x - px + py)) ||
                    (x <= px && y >= (s16)(px - x + py)));
    case 5:
        return (u8)((x <= px && y >= (s16)(px - x + py)) ||
                    (x <= (s16)(px + py - y) && y >= py));
    case 6:
        return (u8)((x <= (s16)(px + py - y) && y >= py) ||
                    (x <= (s16)(px + y - py) && y <= py));
    case 7:
        return (u8)((x <= (s16)(px + y - py) && y <= py) ||
                    (x <= px && y <= (s16)(x - px + py)));
    case 8:
        return 1;
    default:
        return 0;
    }
}

/*
 * PORT H077+$0056: sorts the area list H005+$2A3E ($2479 entries of 4
 * bytes: combatant, distance, direction) by distance; on a tie the
 * lower direction if it is not diagonal when the other is straight.
 */
static void sort_area_list(void)
{
    u16 i;                              /* -$2(a5) */
    u16 j;                              /* -$4(a5) */
    u16 dj;                             /* -$6(a5) */
    u16 di;                             /* -$8(a5) */
    u8 tmp[4];                          /* -$C(a5) */
    u8 *ei;
    u8 *ej;

    if (H005_B(0x2479) <= 1) { /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        return;
    }
    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (i = 1; i <= (u16)(H005_B(0x2479) - 1); ++i) {
        /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        for (j = (u16)(i + 1); j <= H005_B(0x2479); ++j) {
            /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
            ei = &H005_B(0x2A3E + (i - 1) * 4);
            /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
            ej = &H005_B(0x2A3E + (j - 1) * 4);
            di = ei[2];
            dj = ej[2];
            if (ej[1] < ei[1] ||
                (ej[1] == ei[1] && dj < di && (dj & 1) <= (di & 1))) {
                memcpy(tmp, ei, 4);
                memcpy(ei, ej, 4);
                memcpy(ej, tmp, 4);
            }
        }
    }
}

/*
 * PORT H077+$08AC: fills the list H005+$2A3E with the combatants (with a
 * shape) that a square of shape size at (x, y) sees, in sector dir
 * ($FF all) and within radius: for each one number, minimum distance and
 * direction (dir, or the first from 0 that contains it); then sorts it.
 */
void find_in_area(s16 x, s16 y, u16 radius, u16 dir, u16 size, u8 *area)
{
    u16 n;                              /* -$2(a5) */
    u16 d;                              /* -$4(a5) */
    u16 i;                              /* -$6(a5) */
    u16 j;                              /* -$8(a5) */
    u16 bi = 0;                         /* -$A(a5) */
    u16 bj = 0;                         /* -$C(a5) */
    u8 found;                           /* -$D(a5) */
    s16 tx;                             /* -$10(a5) */
    s16 ty;                             /* -$12(a5) */
    s16 dx;                             /* -$14(a5) */
    s16 dy;                             /* -$16(a5) */
    s16 ox[4];                          /* -$1E(a5) */
    s16 oy[4];                          /* -$26(a5) */
    s16 kx[4];                          /* -$2E(a5) */
    s16 ky[4];                          /* -$36(a5) */
    u16 dist;                           /* -$38(a5) */
    u16 best;                           /* -$3A(a5) */
    u16 m;

    for (i = 0; i <= 3; ++i) {
        if (shape_cell(size, i, &dx, &dy)) {
            ox[i] = (s16)(x + dx);
            oy[i] = (s16)(y + dy);
        } else {
            ox[i] = -1;
        }
    }
    H005_B(0x2479) = 0; /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
    for (n = 1; n <= H005_B(0x247B); ++n) {
        /* $3159: combatant positions +5: shape/size (0 = off the map) */
        if (H005_B(0x3154 + (n - 1) * 6 + 5) == 0) {
            continue;
        }
        found = 0;
        best = 0xFF;
        for (j = 0; j <= 3; ++j) {
            /* $3159: combatant positions +5: shape/size (0 = off the map) */
            if (shape_cell(H005_B(0x3154 + (n - 1) * 6 + 5), j, &dx, &dy)) {
                /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
                kx[j] = (s16)(H005_W(0x3154 + (n - 1) * 6) + dx);
                /* $3156: combatant positions +2: row on the map (word) */
                ky[j] = (s16)(H005_W(0x3154 + (n - 1) * 6 + 2) + dy);
            } else {
                kx[j] = -1;
            }
        }
        for (j = 0; j <= 3; ++j) {
            if (kx[j] < 0) {
                continue;
            }
            for (i = 0; i <= 3; ++i) {
                if (ox[i] < 0 ||
                    !in_direction(ox[i], oy[i], kx[j], ky[j], dir)) {
                    continue;
                }
                tx = kx[j];
                ty = ky[j];
                dist = radius;
                if (line_of_sight(ox[i], oy[i], &tx, &ty, &dist, area)) {
                    found = 1;
                    if (dist < best) {
                        best = dist;
                        bi = i;
                        bj = j;
                    }
                }
            }
        }
        if (!found) {
            continue;
        }
        ++H005_B(0x2479); /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        m = (u16)(H005_B(0x2479) - 1);
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        H005_B(0x2A3E + m * 4) = (u8)n;
        /* $2A3F: area list, byte 1: distance (cost, half = squares) */
        H005_B(0x2A3E + m * 4 + 1) = (u8)best;
        d = 0;
        if (dir < 8) {
            d = dir;
        } else {
            while (!in_direction(ox[bi], oy[bi], kx[bj], ky[bj], d)) {
                ++d;
            }
        }
        /* $2A40: area list, byte 2: direction towards the combatant */
        H005_B(0x2A3E + m * 4 + 2) = (u8)d;
    }
    sort_area_list();
}
