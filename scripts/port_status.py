#!/usr/bin/env python3
"""Stato del port asm -> C di src_c/readable.

Legge le routine dalle schede '; ROUTINE: nome [livello]' di
rebuild/source/Hnnn.asm (l'etichetta Lnnn_OFFSET che segue da' l'offset) e
cerca nei sorgenti C i marcatori

    /* PORT Hnnn+$XXXX */

posti sopra ogni funzione portata.  Scrive src_c/readable/PORT_STATUS.md.
Uso: scripts/port_status.py [--check]  (--check: esce con 1 se un marcatore
non corrisponde a nessuna routine dell'asm).
"""
import glob, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASM = os.path.join(ROOT, "rebuild", "source")
SRC = os.path.join(ROOT, "src_c", "readable")

def labels():
    """Offset di tutte le etichette di codice Lnnn_OFFSET per hunk."""
    out = {}
    for path in sorted(glob.glob(os.path.join(ASM, "H[0-9][0-9][0-9].asm"))):
        hunk = int(os.path.basename(path)[1:4])
        for line in open(path, encoding="utf-8", errors="replace"):
            m = re.match(r"L(\d{3})_([0-9A-F]{8}):", line)
            if m:
                out.setdefault(hunk, set()).add(int(m.group(2), 16))
    return out

def preserved():
    """Intervalli 'Preserved bytes' (codice non classificato) per hunk."""
    out = {}
    for path in sorted(glob.glob(os.path.join(ASM, "H[0-9][0-9][0-9].asm"))):
        hunk = int(os.path.basename(path)[1:4])
        for line in open(path, encoding="utf-8", errors="replace"):
            m = re.search(r"Preserved bytes H\d{3}\+\$([0-9A-F]+)\.\.\$([0-9A-F]+)", line)
            if m:
                out.setdefault(hunk, []).append((int(m.group(1), 16),
                                                 int(m.group(2), 16)))
    return out

def routines():
    out = {}
    for path in sorted(glob.glob(os.path.join(ASM, "H[0-9][0-9][0-9].asm"))):
        hunk = int(os.path.basename(path)[1:4])
        size = 0
        pending = None
        for line in open(path, encoding="utf-8", errors="replace"):
            m = re.match(r"; H\d+: (\d+) original bytes", line)
            if m:
                size = int(m.group(1))
            m = re.match(r"; ROUTINE: (\S+) \[(\w+)\]", line)
            if m:
                pending = (m.group(1), m.group(2))
                continue
            m = re.match(r"L(\d{3})_([0-9A-F]{8}):", line)
            if m and pending:
                off = int(m.group(2), 16)
                out.setdefault(hunk, {"size": size, "routines": []})
                out[hunk]["routines"].append((off, pending[0], pending[1]))
                pending = None
        out.setdefault(hunk, {"size": size, "routines": []})
        out[hunk]["size"] = size
    return out

def ported():
    marks = {}
    for path in sorted(glob.glob(os.path.join(SRC, "*.c"))):
        for n, line in enumerate(open(path, encoding="utf-8", errors="replace"), 1):
            for m in re.finditer(r"PORT H(\d{3})\+\$([0-9A-Fa-f]+)", line):
                key = (int(m.group(1)), int(m.group(2), 16))
                marks[key] = "%s:%d" % (os.path.basename(path), n)
    return marks

def main():
    rs = routines()
    marks = ported()
    labs = labels()
    known = {(h, off) for h, d in rs.items() for off, _, _ in d["routines"]}
    # Routine portate che l'analisi non ha schedato: valide se l'offset e'
    # un'etichetta di codice dell'asm.
    for (h, off) in sorted(marks):
        if (h, off) not in known and off in labs.get(h, set()):
            rs[h]["routines"].append((off, "(senza scheda)", "-"))
            rs[h]["routines"].sort()
            known.add((h, off))
    # Routine trovate dentro byte che l'analisi non ha classificato
    # (disassemblate a mano nel port).
    pres = preserved()
    for (h, off) in sorted(marks):
        if (h, off) not in known and any(a <= off < b for a, b in pres.get(h, [])):
            rs[h]["routines"].append((off, "(byte non classificati)", "-"))
            rs[h]["routines"].sort()
            known.add((h, off))
    unknown = sorted(k for k in marks if k not in known)
    total = sum(len(d["routines"]) for d in rs.values())
    done = sum(1 for k in marks if k in known)
    lines = ["# Stato del port asm -> C", "",
             "Generato da `scripts/port_status.py`: routine delle schede `ROUTINE` "
             "di `rebuild/source`, portate se un sorgente di questa cartella ha il "
             "marcatore `/* PORT Hnnn+$XXXX */`.", "",
             "Routine portate: **%d / %d**." % (done, total), "",
             "| Hunk | Byte | Routine | Portate |", "| --- | ---: | ---: | ---: |"]
    for h in sorted(rs):
        d = rs[h]
        n = len(d["routines"])
        p = sum(1 for off, _, _ in d["routines"] if (h, off) in marks)
        lines.append("| H%03d | %d | %d | %d |" % (h, d["size"], n, p))
    lines += ["", "## Dettaglio", ""]
    for h in sorted(rs):
        d = rs[h]
        if not d["routines"]:
            continue
        lines.append("### H%03d" % h)
        lines.append("")
        lines.append("| Offset | Nome nell'analisi | Analisi | Port |")
        lines.append("| --- | --- | --- | --- |")
        for off, name, level in d["routines"]:
            where = marks.get((h, off), "")
            lines.append("| `$%04X` | `%s` | %s | %s |" % (off, name, level, where))
        lines.append("")
    if unknown:
        lines += ["## Marcatori senza routine nell'asm", ""]
        lines += ["- `H%03d+$%04X` (%s)" % (h, o, marks[(h, o)]) for h, o in unknown]
    with open(os.path.join(SRC, "PORT_STATUS.md"), "w") as f:
        f.write("\n".join(lines) + "\n")
    print("ported %d/%d routines" % (done, total))
    if "--check" in sys.argv and unknown:
        for h, o in unknown:
            print("marker without routine: H%03d+$%04X (%s)" % (h, o, marks[(h, o)]))
        sys.exit(1)

if __name__ == "__main__":
    main()
