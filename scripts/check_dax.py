#!/usr/bin/env python3
"""Lettore DAX indipendente: elenca i blocchi di un contenitore o ne
estrae uno, per verificare DAX_LoadBlock (H028+$0DD8) del port.

  check_dax.py file.daa                 elenca gli id
  check_dax.py file.daa id uscita.bin   confronta con l'uscita del port

Formato: word dimensione della directory, voci da 9 byte (id, offset long,
dimensione, dimensione compressa), poi i blocchi.  ".dax" e' little-endian
e la directory comprende la sua word.  RLE: 0..$7E n+1 letterali,
$7F..$FE byte ripetuto $100-n volte, $FF ripete il tipo del controllo
precedente (all'inizio: salta il byte).  Il buffer e' dimensione+$100;
le scritture oltre il buffer sono errori (H014) e vengono saltate.
"""
import struct, sys

def entries(path):
    data = open(path, 'rb').read()
    le = path.lower().endswith('.dax')
    fmt = '<' if le else '>'
    dsize = struct.unpack(fmt + 'H', data[:2])[0] + (2 if le else 0)
    pos, out = 2, []
    while True:
        i, off, raw, comp = struct.unpack(fmt + 'BIHH', data[pos:pos + 9])
        out.append((i, off, raw, comp))
        pos += 9
        if pos >= dsize:
            break
    return data, dsize, out

def block(path, want):
    data, dsize, es = entries(path)
    for i, off, raw, comp in es:
        if i == want:
            src = data[dsize + off: dsize + off + comp] + b'\0\0'
            size = raw + 0x100
            dst = bytearray(size)
            si = di = 0
            kind = -1
            while True:
                n = src[si]
                if n <= 0x7E:
                    kind = 0
                elif n <= 0xFE:
                    kind = 1
                if kind == 0:
                    if di + n + 1 <= size:
                        dst[di:di + n + 1] = src[si + 1:si + n + 2]
                    si += n + 2; di += n + 1
                elif kind == 1:
                    for j in range(0x100 - n):
                        if di + j < size:
                            dst[di + j] = src[si + 1]
                    si += 2; di += 0x100 - n
                else:
                    si += 1
                si &= 0xFFFF; di &= 0xFFFF
                if not si < comp:
                    break
            return bytes(dst)
    return None

if len(sys.argv) == 2:
    print(' '.join(str(e[0]) for e in entries(sys.argv[1])[2]))
    sys.exit(0)
exp = block(sys.argv[1], int(sys.argv[2]))
got = open(sys.argv[3], 'rb').read()
diff = sum(1 for a, b in zip(exp, got) if a != b) + abs(len(exp) - len(got))
print('%s #%s: %d byte, %d differenze' % (sys.argv[1], sys.argv[2], len(exp), diff))
sys.exit(1 if diff else 0)
