#!/usr/bin/env python3
"""Rebuilds the bytes of a hunk from rebuild/source/Hnnn.asm.

Uses the comment lines '; Hnnn+$OFFSET: HEX  ...' (code) and the blocks
'Preserved bytes Hnnn+$A..$B' followed by dc.w/dc.l/dc.b (data).
Usage: hunkbytes.py SRC_DIR HUNK OFFSET [LEN] | --str HUNK OFFSET | --ptr HUNK OFFSET
"""
import re, sys, os

def load(src, hunk):
    path = os.path.join(src, "H%03d.asm" % hunk)
    mem = {}
    pos = None
    ins = re.compile(r"^; H%03d\+\$([0-9A-Fa-f]+): ([0-9a-f]+)\s" % hunk)
    pres = re.compile(r"Preserved bytes H%03d\+\$([0-9A-Fa-f]+)\.\." % hunk)
    for line in open(path, encoding="utf-8", errors="replace"):
        m = ins.match(line)
        if m:
            off = int(m.group(1), 16); hx = m.group(2)
            for i in range(0, len(hx), 2):
                mem[off + i // 2] = int(hx[i:i + 2], 16)
            pos = None
            continue
        m = pres.search(line)
        if m:
            pos = int(m.group(1), 16); continue
        s = line.strip()
        if pos is not None and s.startswith("dc."):
            kind, rest = s[3], s[4:].strip()
            for item in [x.strip() for x in rest.split(",") if x.strip()]:
                if item.startswith("$"):
                    v = int(item[1:], 16)
                    n = {"b": 1, "w": 2, "l": 4}[kind]
                elif kind == "l":            # relocation: Hnnn+$X -> 4 placeholder bytes
                    v, n = None, 4
                else:
                    continue
                for i in range(n):
                    mem[pos + i] = None if v is None else (v >> (8 * (n - 1 - i))) & 0xFF
                pos += n
        elif pos is not None and s and not s.startswith(";") and not s.startswith("dc."):
            pos = None
    return mem

def reloc(src, hunk, off):
    path = os.path.join(src, "H%03d.asm" % hunk)
    pres = re.compile(r"Preserved bytes H%03d\+\$([0-9A-Fa-f]+)\.\." % hunk)
    pos = None
    for line in open(path, encoding="utf-8", errors="replace"):
        m = pres.search(line)
        if m:
            pos = int(m.group(1), 16); continue
        s = line.strip()
        if pos is not None and s.startswith("dc."):
            kind, rest = s[3], s[4:].strip()
            for item in [x.strip() for x in rest.split(",") if x.strip()]:
                n = {"b": 1, "w": 2, "l": 4}[kind]
                if pos == off and kind == "l" and not item.startswith("$"):
                    return item
                pos += n
        elif pos is not None and s and not s.startswith(";"):
            pos = None
    return None

if __name__ == "__main__":
    src = sys.argv[1]
    if sys.argv[2] == "--str":
        h, o = int(sys.argv[3]), int(sys.argv[4], 16)
        mem = load(src, h); out = []
        while mem.get(o) not in (0, None) and len(out) < 200:
            out.append(chr(mem[o])); o += 1
        print(repr("".join(out)))
    elif sys.argv[2] == "--ptr":
        print(reloc(src, int(sys.argv[3]), int(sys.argv[4], 16)))
    else:
        h, o = int(sys.argv[2]), int(sys.argv[3], 16)
        n = int(sys.argv[4], 16) if len(sys.argv) > 4 else 16
        mem = load(src, h)
        print(" ".join("??" if mem.get(o + i) is None else "%02X" % mem[o + i] for i in range(n)))
