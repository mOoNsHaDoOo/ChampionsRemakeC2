#!/usr/bin/env python3
"""Genera src_c/readable/h004_init_data.h dalle costanti di H004+$0C1A.

H004+$0C1A ($0C38..$5ED4) riempie H005 con costanti: copie di stringhe
(lea $X(a4),a3; lea $D,a2; moveq #n,d2; move.b (a3)+,(a2)+; dbeq),
copie di byte, copia di word e valori byte/word/long, anche relativi a un
registro base (lea $D,a3; move #v,o(a3)).  Questo script ne fa blocchi
ordinati; i segmenti con logica (cicli) restano fuori e sono scritti a mano
in h004_init.c, nella stessa posizione.
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import hunkbytes

ROOT = os.path.dirname(HERE)
ASM = os.path.join(ROOT, "rebuild", "source")
OUT = os.path.join(ROOT, "src_c", "readable", "h004_init_data.h")
START, END = 0x0C38, 0x5ED4

def instructions():
    out = []
    for line in open(os.path.join(ASM, "H004.asm"), encoding="utf-8"):
        m = re.match(r"^; H004\+\$0000([0-9A-F]+): [0-9a-f]+  (.*)$", line)
        if m and START <= int(m.group(1), 16) < END:
            out.append((int(m.group(1), 16), m.group(2).strip()))
    return out

def classify(lines):
    ops = []
    i = 0
    g = lambda k: lines[k][1] if k < len(lines) else ""
    base = None
    while i < len(lines):
        off, ins = lines[i]
        m = re.match(r"lea\.l \$([0-9a-f]+)\(a4\), a3$", ins)
        m2 = re.match(r"lea\.l \$([0-9a-f]+)\.l, a2$", g(i + 1))
        if m and m2:
            src, dst = int(m.group(1), 16), int(m2.group(1), 16)
            m3 = re.match(r"moveq #\$([0-9a-f]+), d2$", g(i + 2))
            if m3 and g(i + 3) == "move.b (a3)+, (a2)+" and g(i + 4).startswith("dbeq d2"):
                ops.append(("str", off, dst, src, int(m3.group(1), 16) + 1)); i += 5; base = None; continue
            k = 0
            while g(i + 2 + k) == "move.b (a3)+, (a2)+":
                k += 1
            if k:
                ops.append(("bytes", off, dst, src, k)); i += 2 + k; base = None; continue
        m = re.match(r"lea\.l \$([0-9a-f]+)\.l, a3$", ins)
        if m and m2:
            m3 = re.match(r"moveq #\$([0-9a-f]+), d2$", g(i + 2))
            if m3 and g(i + 3) == "move.w (a3)+, (a2)+" and g(i + 4).startswith("dbra d2"):
                ops.append(("wcopy", off, int(m2.group(1), 16), int(m.group(1), 16), int(m3.group(1), 16) + 1))
                i += 5; base = None; continue
        m = re.match(r"move\.([wbl]) #\$([0-9a-f]+), \$([0-9a-f]+)\.l$", ins)
        if m:
            ops.append((m.group(1), off, int(m.group(3), 16), int(m.group(2), 16), 0)); i += 1; base = None; continue
        m = re.match(r"clr\.([wbl]) \$([0-9a-f]+)\.l$", ins)
        if m:
            ops.append((m.group(1), off, int(m.group(2), 16), 0, 0)); i += 1; base = None; continue
        m = re.match(r"lea\.l \$([0-9a-f]+)\.l, a3$", ins)
        if m:
            nxt = g(i + 1)
            if re.match(r"(move\.[wb] #\$[0-9a-f]+, |clr\.[wb] )(\$[0-9a-f]+)?\(a3\)$", nxt):
                base = int(m.group(1), 16); i += 1; continue
        if base is not None:
            m = re.match(r"move\.([wb]) #\$([0-9a-f]+), (?:\$([0-9a-f]+))?\(a3\)$", ins)
            if m:
                ops.append((m.group(1), off, base + int(m.group(3) or "0", 16), int(m.group(2), 16), 0)); i += 1; continue
            m = re.match(r"clr\.([wb]) (?:\$([0-9a-f]+))?\(a3\)$", ins)
            if m:
                ops.append((m.group(1), off, base + int(m.group(2) or "0", 16), 0, 0)); i += 1; continue
        base = None
        ops.append(("code", off, None, ins, 0)); i += 1
    return ops

def c_bytes(bs):
    out = []
    for b in bs:
        if b == 0x22 or b == 0x5C:
            out.append("\\" + chr(b))
        elif 0x20 <= b < 0x7F:
            out.append(chr(b))
        else:
            out.append("\\%03o" % b)
    return '"' + "".join(out) + '"'

def main():
    data = hunkbytes.load(ASM, 4)
    a4 = int(hunkbytes.reloc(ASM, 4, 0xC16).split("$")[1], 16)
    ops = classify(instructions())
    segs = []
    cur = None
    for o in ops:
        if o[0] == "code":
            cur = None
            continue
        if cur is None:
            cur = {"start": o[1], "ops": []}
            segs.append(cur)
        cur["ops"].append(o)
    lines = ["/*", " * Generato da scripts/gen_h004_init_data.py: costanti di H004+$0C1A",
             " * nell'ordine dell'originale.  Non modificare a mano.", " */",
             "#ifndef COK_H004_INIT_DATA_H", "#define COK_H004_INIT_DATA_H", ""]
    for s in segs:
        lines.append("/* H004+$%04X */" % s["start"])
        lines.append("static const H004InitOp s_init_%04x[] = {" % s["start"])
        for kind, off, dst, val, n in s["ops"]:
            if kind == "str":
                src = a4 + val
                bs = []
                for k in range(n):
                    b = data.get(src + k) or 0
                    bs.append(b)
                    if b == 0:
                        break
                text = bytes(b for b in bs if b != 0)
                lines.append("    { H004_STR, 0x%04X, %d, %s }," % (dst, n, c_bytes(text)))
            elif kind == "bytes":
                bs = bytes((data.get(a4 + val + k) or 0) for k in range(n))
                lines.append("    { H004_BYTES, 0x%04X, %d, %s }," % (dst, n, c_bytes(bs)))
            elif kind == "wcopy":
                lines.append("    { H004_WCOPY, 0x%04X, 0x%X, 0 },  /* da $%04X, %d word */" % (dst, val | (n << 16), val, n))
            else:
                k = {"b": "H004_B", "w": "H004_W", "l": "H004_L"}[kind]
                lines.append("    { %s, 0x%04X, 0x%X, 0 }," % (k, dst, val))
        lines.append("};")
        lines.append("")
    lines.append("#endif")
    open(OUT, "w").write("\n".join(lines) + "\n")
    print("%d segmenti, %d operazioni" % (len(segs), sum(len(s["ops"]) for s in segs)))
    for s in segs:
        print("  $%04X: %d" % (s["start"], len(s["ops"])))

if __name__ == "__main__":
    main()
