/* Applier of the initialisation tables (see init_data.h). */
#include "init_data.h"
#include "globals.h"

void init_apply(const InitOp *op, size_t n, u8 *bss, size_t bss_size)
{
    size_t i;

    for (i = 0; i < n; ++i, ++op) {
        u8 *p = op->space == INIT_H005 ? &g_h005[op->dst]
                                       : &bss[bss_size - op->dst];

        switch (op->kind) {
        case INIT_STR: {
            /* move.b (a3)+,(a2)+ / dbeq: stops after the NUL or at the limit. */
            size_t len = strlen(op->text) + 1;
            memcpy(p, op->text, len < op->value ? len : op->value);
            break;
        }
        case INIT_BYTES:
            memcpy(p, op->text, op->value);
            break;
        case INIT_WCOPY:
            memmove(p, &g_h005[op->value & 0xFFFF],
                    (size_t)(op->value >> 16) * 2);
            break;
        case INIT_B:
            p[0] = (u8)op->value;
            break;
        case INIT_W:
            COK_PUT16(p, op->value);
            break;
        default:
            COK_PUT16(p, op->value >> 16);
            COK_PUT16(p + 2, op->value);
            break;
        }
    }
}
