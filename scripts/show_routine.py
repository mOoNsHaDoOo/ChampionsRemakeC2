#!/usr/bin/env python3
"""Stampa una routine dell'asm seguendo bra/salti in avanti fino a rts.

Uso: show_routine.py HUNK OFFSET [MAX]
Mostra offset, istruzione e, per jsr/lea rilocati, il simbolo di destinazione.
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASM = os.path.join(ROOT, "rebuild", "source")

def load(hunk):
    code, sym = {}, {}
    last = None
    for line in open(os.path.join(ASM, "H%03d.asm" % hunk), encoding="utf-8", errors="replace"):
        m = re.match(r"^; H%03d\+\$([0-9A-F]+): [0-9a-f]+  (.*)$" % hunk, line)
        if m:
            last = int(m.group(1), 16); code[last] = m.group(2).strip(); continue
        if last is not None and line.startswith("        ") and re.search(r"\(H\d{3}\+|FN_|LVO_", line):
            sym[last] = line.strip()
        if not line.startswith("        "):
            last = None
    return code, sym

def main():
    hunk, off = int(sys.argv[1]), int(sys.argv[2], 16)
    limit = int(sys.argv[3]) if len(sys.argv) > 3 else 200
    code, sym = load(hunk)
    offs = sorted(code)
    nxt = {o: offs[i + 1] for i, o in enumerate(offs[:-1])}
    seen = set(); pc = off; n = 0
    todo = [off]
    out = []
    while todo and n < limit:
        pc = todo.pop(0)
        while pc in code and pc not in seen and n < limit:
            seen.add(pc); ins = code[pc]; n += 1
            extra = ""
            if pc in sym and ("jsr" in ins or "jmp" in ins or "lea" in ins or ".l" in ins):
                extra = "   ; " + sym[pc]
            out.append((pc, ins + extra))
            m = re.match(r"(bra|jmp)\.?\w* \$([0-9a-f]+)$", ins)
            if m:
                pc = int(m.group(2), 16); continue
            m = re.match(r"b\w+\.\w \$([0-9a-f]+)$", ins) or re.match(r"db\w+ d\d, \$([0-9a-f]+)$", ins)
            if m:
                t = int(m.group(1), 16)
                if t not in seen:
                    todo.append(t)
            if ins.startswith("rts") or ins.startswith("jmp (a0)"):
                break
            pc = nxt.get(pc)
    for pc, ins in sorted(out):
        print("%04X %s" % (pc, ins))

if __name__ == "__main__":
    main()
