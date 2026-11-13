#!/usr/bin/env python3
"""Minimal 68000 emulator for the data initialisation routines.

Runs a routine of rebuild/source (for example H004+$0C38, body of
H004+$0C1A) and returns the image of H005 that it produces.  It supports only the
subset of instructions used by these routines: for any other
instruction it stops with an error, so the result is never guessed.

Usage: emu68k_init.py HUNK START_OFF OUT.bin
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import hunkbytes

ASM = os.path.join(os.path.dirname(HERE), "rebuild", "source")
H005_SIZE = 0x531C
A4_BSS = 0x10000            # area for the negative offsets of a4 (BSS of the module)

def load_code(hunk):
    code = {}
    reloc = {}
    path = os.path.join(ASM, "H%03d.asm" % hunk)
    last = None
    for line in open(path, encoding="utf-8", errors="replace"):
        m = re.match(r"^; H%03d\+\$([0-9A-F]+): [0-9a-f]+  (.*)$" % hunk, line)
        if m:
            last = int(m.group(1), 16)
            code[last] = m.group(2).strip()
            continue
        # The next line (source) gives the relocation: (H005+$X).l
        if last is not None and line.startswith("        ") and "(H" in line:
            reloc[last] = line.strip()
        last = None if not line.startswith("        ") else last
    return code, reloc

class Emu:
    def __init__(self, hunk):
        self.hunk = hunk
        self.code, self.reloc = load_code(hunk)
        self.data = hunkbytes.load(ASM, hunk)
        base = hunkbytes.reloc(ASM, hunk, self.a4_slot())
        self.a4 = int(base.split("$")[1], 16) if base else 0
        self.h005 = bytearray(H005_SIZE)
        self.bss = bytearray(0x1000)
        self.d = [0] * 8
        self.a = [0] * 8          # symbolic addresses: ('h005', off) / ('hunk', off) / ('bss', off)

    def a4_slot(self):
        # move.l a4,-(a7); movea.l $XX(pc), a4 in the module prologue
        for off, ins in sorted(self.code.items()):
            m = re.match(r"movea\.l \$([0-9a-f]+)\(pc\), a4", ins)
            if m:
                return int(m.group(1), 16)
        raise SystemExit("a4 prologue not found")

    # ---- memory ------------------------------------------------------
    def rd(self, addr, size):
        space, off = addr
        if space == "h005":
            b = self.h005[off:off + size]
        elif space == "hunk":
            b = bytes((self.data.get(off + i) or 0) for i in range(size))
        elif space == "bss":
            b = self.bss[off - A4_BSS + 0x800: off - A4_BSS + 0x800 + size]
        else:
            raise SystemExit("read from %r" % (addr,))
        return int.from_bytes(bytes(b), "big")

    def wr(self, addr, size, val):
        space, off = addr
        val &= (1 << (8 * size)) - 1
        b = val.to_bytes(size, "big")
        if space == "h005":
            if off < 0 or off + size > H005_SIZE:
                raise SystemExit("write outside H005: $%X" % off)
            self.h005[off:off + size] = b
        elif space == "bss":
            i = off - A4_BSS + 0x800
            self.bss[i:i + size] = b
        else:
            raise SystemExit("scrittura in %r" % (addr,))

    def ea(self, text, pc, size):
        """Resolves a memory operand into a symbolic address."""
        t = text.strip()
        m = re.match(r"^\$([0-9a-f]+)\.l$", t)
        if m:
            r = self.reloc.get(pc, "")
            if "H005" not in r and "(H" in r:
                raise SystemExit("non-H005 relocation at $%X: %s" % (pc, r))
            return ("h005", int(m.group(1), 16))
        m = re.match(r"^(-?)\$([0-9a-f]+)\(a4\)$", t)
        if m:
            off = int(m.group(2), 16) * (-1 if m.group(1) else 1)
            return ("bss", A4_BSS + off) if off < 0 else ("hunk", self.a4 + off)
        m = re.match(r"^\(a([0-7])\)\+$", t)
        if m:
            n = int(m.group(1)); addr = self.a[n]
            self.a[n] = (addr[0], addr[1] + size)
            return addr
        m = re.match(r"^\(a([0-7])\)$", t)
        if m:
            return self.a[int(m.group(1))]
        m = re.match(r"^(-?)\$([0-9a-f]+)\(a([0-7])\)$", t)
        if m:
            base = self.a[int(m.group(3))]
            off = int(m.group(2), 16) * (-1 if m.group(1) else 1)
            return (base[0], base[1] + off)
        m = re.match(r"^\(a([0-7]), d([0-7])\.([wl])\)$", t)
        if m:
            base = self.a[int(m.group(1))]
            idx = self.d[int(m.group(2))]
            idx = (idx & 0xFFFF) - (0x10000 if idx & 0x8000 else 0) if m.group(3) == "w" else idx
            return (base[0], base[1] + idx)
        m = re.match(r"^(-?)\$([0-9a-f]+)\(a([0-7]), d([0-7])\.([wl])\)$", t)
        if m:
            base = self.a[int(m.group(3))]
            off = int(m.group(2), 16) * (-1 if m.group(1) else 1)
            idx = self.d[int(m.group(4))]
            idx = (idx & 0xFFFF) - (0x10000 if idx & 0x8000 else 0) if m.group(5) == "w" else idx
            return (base[0], base[1] + off + idx)
        raise SystemExit("unsupported operand at $%X: %s" % (pc, text))

    def src(self, text, pc, size):
        t = text.strip()
        m = re.match(r"^#\$([0-9a-f]+)$", t)
        if m:
            return int(m.group(1), 16)
        m = re.match(r"^d([0-7])$", t)
        if m:
            return self.d[int(m.group(1))] & ((1 << (8 * size)) - 1)
        return self.rd(self.ea(t, pc, size), size)

    def dst_write(self, text, pc, size, val):
        t = text.strip()
        m = re.match(r"^d([0-7])$", t)
        if m:
            n = int(m.group(1)); mask = (1 << (8 * size)) - 1
            self.d[n] = (self.d[n] & ~mask) | (val & mask)
            return
        self.wr(self.ea(t, pc, size), size, val)

    # ---- execution ---------------------------------------------------
    def run(self, start, stop_ins=("unlk a5", "rts")):
        pc = start
        offs = sorted(self.code)
        nxt = {o: offs[i + 1] for i, o in enumerate(offs[:-1])}
        steps = 0
        flags = {"z": 0, "n": 0, "c": 0, "v": 0}
        while True:
            steps += 1
            if steps > 5_000_000:
                raise SystemExit("troppi passi")
            ins = self.code[pc]
            if ins in stop_ins:
                return
            op, _, rest = ins.partition(" ")
            args = [x.strip() for x in re.split(r",(?![^()]*\))", rest)] if rest else []
            size = {"b": 1, "w": 2, "l": 4}.get(op.split(".")[1], 2) if "." in op else 4
            base = op.split(".")[0]
            jump = None
            if base == "lea":
                r = int(args[1][1])
                t = args[0]
                m = re.match(r"^\$([0-9a-f]+)\.l$", t)
                if m:
                    self.a[r] = ("h005", int(m.group(1), 16))
                else:
                    self.a[r] = self.ea(t, pc, 0)
            elif base == "move" or base == "movea":
                v = self.src(args[0], pc, size)
                self.dst_write(args[1], pc, size, v)
                self.setnz(flags, v, size)
            elif base == "moveq":
                v = int(args[0][2:], 16) if not args[0].startswith("#$-") else -int(args[0][3:], 16)
                v = v - 256 if v > 127 else v
                self.d[int(args[1][1])] = v & 0xFFFFFFFF
                self.setnz(flags, v, 4)
            elif base == "clr":
                self.dst_write(args[0], pc, size, 0)
            elif base in ("addq", "subq", "addi", "subi", "add", "sub"):
                v = self.src(args[0], pc, size)
                cur = self.src(args[1], pc, size)
                mask = (1 << (8 * size)) - 1
                if base.startswith("add"):
                    res = cur + v
                    flags["c"] = 1 if res > mask else 0
                else:
                    res = cur - v
                    flags["c"] = 1 if v > cur else 0
                self.dst_write(args[1], pc, size, res & mask)
                self.setnz(flags, res & mask, size)
            elif base in ("andi", "ori", "and", "or"):
                v = self.src(args[0], pc, size)
                cur = self.src(args[1], pc, size)
                res = (cur & v) if base.startswith("and") else (cur | v)
                self.dst_write(args[1], pc, size, res)
                self.setnz(flags, res, size)
                flags["c"] = 0
            elif base == "asl":
                n = int(args[0][2:], 16)
                cur = self.src(args[1], pc, size)
                self.dst_write(args[1], pc, size, cur << n)
            elif base == "muls":
                v = self.src(args[0], pc, 2); v = v - 0x10000 if v & 0x8000 else v
                r = int(args[1][1]); cur = self.d[r] & 0xFFFF
                cur = cur - 0x10000 if cur & 0x8000 else cur
                self.d[r] = (v * cur) & 0xFFFFFFFF
            elif base == "cmpi" or base == "cmp":
                v = self.src(args[0], pc, size)
                cur = self.src(args[1], pc, size)
                mask = (1 << (8 * size)) - 1
                res = (cur - v) & mask
                flags["c"] = 1 if v > cur else 0
                self.setnz(flags, res, size)
            elif base in ("bra", "bhi", "bls", "bcc", "bcs", "beq", "bne"):
                target = int(args[0][1:], 16)
                c, z = flags["c"], flags["z"]
                take = {"bra": True, "bhi": not c and not z, "bls": c or z,
                        "bcc": not c, "bcs": bool(c), "beq": bool(z), "bne": not z}[base]
                if take:
                    jump = target
            elif base in ("dbra", "dbeq"):
                r = int(args[0][1]); target = int(args[1][1:], 16)
                if base == "dbeq" and flags["z"]:
                    pass
                else:
                    cnt = (self.d[r] - 1) & 0xFFFF
                    self.d[r] = (self.d[r] & 0xFFFF0000) | cnt
                    if cnt != 0xFFFF:
                        jump = target
            else:
                raise SystemExit("unsupported instruction at $%X: %s" % (pc, ins))
            pc = jump if jump is not None else nxt[pc]

    @staticmethod
    def setnz(flags, v, size):
        mask = (1 << (8 * size)) - 1
        v &= mask
        flags["z"] = 1 if v == 0 else 0
        flags["n"] = 1 if v >> (8 * size - 1) else 0

if __name__ == "__main__":
    # Usage: emu68k_init.py HUNK START OUT.bin [--bss N]
    #   without --bss: writes the image of H005;
    #   with --bss N: writes the N bytes below a4 (module data, from -N to -1).
    hunk, start, out = int(sys.argv[1]), int(sys.argv[2], 16), sys.argv[3]
    e = Emu(hunk)
    e.run(start)
    if "--bss" in sys.argv:
        n = int(sys.argv[sys.argv.index("--bss") + 1], 16)
        data = bytes(e.bss[0x800 - n:0x800])
        open(out, "wb").write(data)
        print("ok: %d bytes of module data" % n)
    else:
        open(out, "wb").write(bytes(e.h005))
        print("ok: %d non-zero bytes" % sum(1 for b in e.h005 if b))
