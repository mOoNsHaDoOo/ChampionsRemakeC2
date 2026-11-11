#!/usr/bin/env python3
"""Genera tabelle di costanti da una routine di inizializzazione dell'asm.

Uso: gen_init_data.py HUNK START END OUT.h PREFIX

Riconosce, nell'ordine dell'originale, le scritture costanti in H005
($X.l) e nei dati del modulo (-$X(a4)): valori byte/word/long, copie di
stringhe (lea $S(a4),a3; lea D,a2; moveq #n,d2; move.b (a3)+,(a2)+; dbeq),
copie di byte, copie di word dentro H005, e scritture relative a un
registro base (lea D,a3; move #v,o(a3)).  Ogni altra istruzione chiude un
blocco: quei segmenti con logica vanno scritti a mano nel C, nella stessa
posizione.  Stampa i segmenti di logica trovati.
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import hunkbytes

ROOT = os.path.dirname(HERE)
ASM = os.path.join(ROOT, "rebuild", "source")

DST = r"(?:\$([0-9a-f]+)\.l|-\$([0-9a-f]+)\(a4\))"

def dst(m, g1, g2):
    if m.group(g1):
        return ("H005", int(m.group(g1), 16))
    return ("BSS", int(m.group(g2), 16))

def instructions(hunk, start, end):
    out = []
    for line in open(os.path.join(ASM, "H%03d.asm" % hunk), encoding="utf-8"):
        m = re.match(r"^; H%03d\+\$0000([0-9A-F]+): [0-9a-f]+  (.*)$" % hunk, line)
        if m and start <= int(m.group(1), 16) < end:
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
        m2 = re.match(r"lea\.l %s, a2$" % DST, g(i + 1))
        if m and m2:
            src, d = int(m.group(1), 16), dst(m2, 1, 2)
            m3 = re.match(r"moveq #\$([0-9a-f]+), d2$", g(i + 2))
            if m3 and g(i + 3) == "move.b (a3)+, (a2)+" and g(i + 4).startswith("dbeq d2"):
                ops.append(("STR", off, d, src, int(m3.group(1), 16) + 1)); i += 5; base = None; continue
            k = 0
            while g(i + 2 + k) == "move.b (a3)+, (a2)+":
                k += 1
            if k:
                ops.append(("BYTES", off, d, src, k)); i += 2 + k; base = None; continue
        m = re.match(r"lea\.l \$([0-9a-f]+)\.l, a3$", ins)
        if m and m2:
            m3 = re.match(r"moveq #\$([0-9a-f]+), d2$", g(i + 2))
            if m3 and g(i + 3) == "move.w (a3)+, (a2)+" and g(i + 4).startswith("dbra d2"):
                ops.append(("WCOPY", off, dst(m2, 1, 2), int(m.group(1), 16), int(m3.group(1), 16) + 1))
                i += 5; base = None; continue
        m = re.match(r"move\.([wbl]) #\$([0-9a-f]+), %s$" % DST, ins)
        if m:
            ops.append((m.group(1).upper(), off, dst(m, 3, 4), int(m.group(2), 16), 0)); i += 1; base = None; continue
        m = re.match(r"clr\.([wbl]) %s$" % DST, ins)
        if m:
            ops.append((m.group(1).upper(), off, dst(m, 2, 3), 0, 0)); i += 1; base = None; continue
        m = re.match(r"moveq #\$([0-9a-f]+), d2$", ins)
        m2 = re.match(r"move\.l d2, %s$" % DST, g(i + 1))
        if m and m2:
            v = int(m.group(1), 16)
            v = v | 0xFFFFFF00 if v & 0x80 else v
            ops.append(("L", off, dst(m2, 1, 2), v, 0)); i += 2; base = None; continue
        m = re.match(r"lea\.l %s, a3$" % DST, ins)
        if m and re.match(r"(move\.[wb] #\$[0-9a-f]+, |clr\.[wb] )(\$[0-9a-f]+)?\(a3\)$", g(i + 1)):
            base = dst(m, 1, 2); i += 1; continue
        if base is not None:
            m = re.match(r"move\.([wb]) #\$([0-9a-f]+), (?:\$([0-9a-f]+))?\(a3\)$", ins)
            if m:
                o = int(m.group(3) or "0", 16)
                d = (base[0], base[1] + o) if base[0] == "H005" else (base[0], base[1] - o)
                ops.append((m.group(1).upper(), off, d, int(m.group(2), 16), 0)); i += 1; continue
            m = re.match(r"clr\.([wb]) (?:\$([0-9a-f]+))?\(a3\)$", ins)
            if m:
                o = int(m.group(2) or "0", 16)
                d = (base[0], base[1] + o) if base[0] == "H005" else (base[0], base[1] - o)
                ops.append((m.group(1).upper(), off, d, 0, 0)); i += 1; continue
        base = None
        ops.append(("code", off, None, ins, 0)); i += 1
    return ops

def c_bytes(bs):
    out = []
    for b in bs:
        if b in (0x22, 0x5C):
            out.append("\\" + chr(b))
        elif 0x20 <= b < 0x7F:
            out.append(chr(b))
        else:
            out.append("\\%03o" % b)
    return '"' + "".join(out) + '"'

def a4_base(hunk):
    for line in open(os.path.join(ASM, "H%03d.asm" % hunk), encoding="utf-8"):
        m = re.match(r"^; H%03d\+\$[0-9A-F]+: [0-9a-f]+  movea\.l \$([0-9a-f]+)\(pc\), a4$" % hunk, line)
        if m:
            return int(hunkbytes.reloc(ASM, hunk, int(m.group(1), 16)).split("$")[1], 16)
    return None

def main():
    hunk, start, end = int(sys.argv[1]), int(sys.argv[2], 16), int(sys.argv[3], 16)
    out, prefix = sys.argv[4], sys.argv[5]
    data = hunkbytes.load(ASM, hunk)
    a4 = a4_base(hunk)
    ops = classify(instructions(hunk, start, end))
    segs, cur, logic = [], None, []
    for o in ops:
        if o[0] == "code":
            if not logic or logic[-1][1] != prev_code:
                logic.append([o[1], o[1]])
            logic[-1][1] = o[1]
            prev_code = o[1]
            cur = None
            continue
        prev_code = None
        if cur is None:
            cur = {"start": o[1], "ops": []}
            segs.append(cur)
        cur["ops"].append(o)
    guard = "COK_%s_H" % os.path.basename(out).upper().replace(".", "_")
    lines = ["/*", " * Generato da scripts/gen_init_data.py %d %X %X: costanti" % (hunk, start, end),
             " * dell'inizializzazione H%03d nell'ordine dell'originale.  Non modificare a mano." % hunk,
             " */", "#ifndef %s" % guard, "#define %s" % guard, ""]
    for s in segs:
        lines.append("/* H%03d+$%04X */" % (hunk, s["start"]))
        lines.append("static const InitOp %s_%04x[] = {" % (prefix, s["start"]))
        for kind, off, (space, addr), val, n in s["ops"]:
            sp = "INIT_H005" if space == "H005" else "INIT_BSS"
            if kind == "STR":
                bs = []
                for k in range(n):
                    b = data.get(a4 + val + k) or 0
                    bs.append(b)
                    if b == 0:
                        break
                text = bytes(b for b in bs if b)
                lines.append("    { INIT_STR, %s, 0x%04X, %d, %s }," % (sp, addr, n, c_bytes(text)))
            elif kind == "BYTES":
                bs = bytes((data.get(a4 + val + k) or 0) for k in range(n))
                lines.append("    { INIT_BYTES, %s, 0x%04X, %d, %s }," % (sp, addr, n, c_bytes(bs)))
            elif kind == "WCOPY":
                lines.append("    { INIT_WCOPY, %s, 0x%04X, 0x%X, 0 },  /* da $%04X, %d word */" % (sp, addr, val | (n << 16), val, n))
            else:
                lines.append("    { INIT_%s, %s, 0x%04X, 0x%X, 0 }," % (kind, sp, addr, val))
        lines.append("};")
        lines.append("")
    lines.append("#endif")
    open(out, "w").write("\n".join(lines) + "\n")
    print("%s: %d blocchi, %d costanti" % (os.path.basename(out), len(segs), sum(len(s["ops"]) for s in segs)))
    for s in segs:
        print("  blocco $%04X (%d)" % (s["start"], len(s["ops"])))
    for a, b in logic:
        print("  logica $%04X-$%04X" % (a, b))

if __name__ == "__main__":
    main()
