#!/usr/bin/env python3
"""Decoder ILBM indipendente (Python) per verificare Read_ILBM del port.

Uso: check_ilbm.py file.lbm uscita_del_port.bin
Produce lo stesso formato di src_c/readable/tests/ilbm_test.c (larghezza in
byte per riga, righe, piani (max 5), colori RGB4, piani) e confronta.
"""
import struct, sys

def decode(path):
    data = open(path, 'rb').read()
    assert data[0:4] == b'FORM' and data[8:12] == b'ILBM', 'non FORM ILBM'
    pos, end = 12, 8 + struct.unpack('>I', data[4:8])[0]
    bmhd = cmap = body = None
    while pos + 8 <= end:
        cid, size = data[pos:pos + 4], struct.unpack('>I', data[pos + 4:pos + 8])[0]
        chunk = data[pos + 8:pos + 8 + size]
        if cid == b'BMHD': bmhd = struct.unpack('>HHhhBBBBHBBhh', chunk[:20])
        elif cid == b'CMAP': cmap = chunk
        elif cid == b'BODY': body = chunk; break
        pos += 8 + size + (size & 1)
    w, h, _, _, nplanes, masking, comp = bmhd[:7]
    rb = ((w + 15) >> 4) << 1
    depth = min(nplanes, 5)
    planes = [bytearray() for _ in range(depth)]
    src = 0
    for _ in range(h):
        for p in range(nplanes + (1 if masking == 1 else 0)):
            row = bytearray()
            if comp == 0:
                row = body[src:src + rb]; src += rb
            else:
                while len(row) < rb:
                    n = body[src]; src += 1
                    if n < 128:
                        row += body[src:src + n + 1]; src += n + 1
                    elif n != 128:
                        row += bytes([body[src]]) * (257 - n); src += 1
            if p < depth:
                planes[p] += row[:rb]
    ncol = min(len(cmap) // 3, 32) if cmap else 0
    cols = [((cmap[i*3] >> 4) << 8) | ((cmap[i*3+1] >> 4) << 4) | (cmap[i*3+2] >> 4)
            for i in range(ncol)]
    out = struct.pack('>HHH', rb, h, depth) + bytes([ncol])
    out += b''.join(struct.pack('>H', c) for c in cols)
    return out + b''.join(bytes(p) for p in planes)

exp = decode(sys.argv[1])
got = open(sys.argv[2], 'rb').read()
diff = sum(1 for a, b in zip(exp, got) if a != b) + abs(len(exp) - len(got))
print('%s: %d byte, %d differenze' % (sys.argv[1], len(exp), diff))
sys.exit(1 if diff else 0)
