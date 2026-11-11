#!/usr/bin/env python3
"""Compare the API constants used by the rebuild with the NDK 1.3 includes.

The game was built with the 1.3 NDK.  Later NDKs rename some constants
(IDCMP_RAWKEY instead of RAWKEY, WFLG_RMBTRAP instead of RMBTRAP) but keep
the values.  This script checks that every symbolic immediate used in the
asm has the same value in the 1.3 headers, and reports symbols introduced
after 1.3.

Usage:
    python3 tools/check_api_ndk13.py --ndk13 /path/to/NDK_1.3
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_NDK13 = ROOT / "ndk13"
DEFAULT_INC = ROOT / "api_const.inc"
DEFAULT_SRC = ROOT / "source"

INCLUDE_FILES = [
    "EXEC/MEMORY.I",
    "EXEC/TYPES.I",
    "LIBRARIES/DOS.I",
    "INTUITION/INTUITION.I",
    "INTUITION/SCREENS.I",
    "DEVICES/INPUTEVENT.I",
]

EQU_RE = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s+(EQU|SET)\s+([^;*]+)",
                    re.I)
BITDEF_RE = re.compile(r"^\s*BITDEF\s+([A-Za-z_][A-Za-z0-9_]*)\s*,\s*"
                       r"([A-Za-z_][A-Za-z0-9_]*)\s*,\s*([0-9]+)", re.I)
HEX_RE = re.compile(r"\$([0-9A-Fa-f]+)")
SYMBOL_RE = re.compile(r"(?<![0-9A-Za-z_])([A-Za-z_][A-Za-z0-9_]*)")
IMM_RE = re.compile(r"#([^,;\s]+)")


class EvalError(Exception):
    pass


def evaluate(expr: str, known: dict[str, int]) -> int:
    text = HEX_RE.sub(lambda m: "0x" + m.group(1), expr.strip())
    if re.search(r"[^0-9A-Fa-fxX()+\-<>&|~ ]", text):
        raise EvalError(expr)
    names = set(SYMBOL_RE.findall(text))
    for name in names:
        if name not in known:
            raise EvalError("unknown " + name)
        text = re.sub(r"(?<![0-9A-Za-z_])" + re.escape(name) +
                      r"(?![0-9A-Za-z_])", str(known[name]), text)
    return int(eval(text, {"__builtins__": {}}, {}))


def parse_ndk13(root: Path) -> dict[str, int]:
    known: dict[str, int] = {}
    base = root / "INCLUDES1.3" / "INCLUDE.I"
    for rel in INCLUDE_FILES:
        path = base / rel
        if not path.exists():
            continue
        for raw in path.read_text(errors="replace").splitlines():
            line = raw.strip()
            if not line or line.startswith("*") or line.startswith(";"):
                continue
            match = BITDEF_RE.match(line)
            if match:
                prefix, name, bit = match.groups()
                bit = int(bit)
                known[(prefix + "B_" + name).upper()] = bit
                known[(prefix + "F_" + name).upper()] = 1 << bit
                continue
            match = EQU_RE.match(line)
            if not match:
                continue
            symbol, kind, expr = match.groups()
            if kind.upper() == "SET":
                continue
            try:
                known[symbol.upper()] = evaluate(expr, known)
            except EvalError:
                continue
    return known


def parse_inc(path: Path) -> dict[str, int]:
    out: dict[str, int] = {}
    for line in path.read_text().splitlines():
        match = re.match(r"([A-Za-z_]\w*)\s+equ\s+(-?\$?[0-9A-Fa-f]+)",
                         line, re.I)
        if match:
            out[match.group(1)] = int(match.group(2).replace("$", "0x"), 0)
    return out


def used_symbols(src: Path, values: dict[str, int]) -> set[str]:
    used: set[str] = set()
    for path in sorted(src.glob("*.asm")):
        for line in path.read_text().splitlines():
            stripped = line.strip()
            if stripped.startswith(";") or "#" not in stripped:
                continue
            for expr in IMM_RE.findall(stripped):
                for name in SYMBOL_RE.findall(expr):
                    if name in values:
                        used.add(name)
    return used


def ndk13_lookup(symbol: str, ndk: dict[str, int]) -> tuple[str | None, int | None]:
    candidates = [symbol]
    if symbol.startswith("IDCMP_"):
        candidates.append(symbol[6:])
    if symbol.startswith("WFLG_"):
        candidates.append(symbol[5:])
    for name in candidates:
        key = name.upper()
        if key in ndk:
            return name, ndk[key]
    return None, None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ndk13", type=Path, default=DEFAULT_NDK13)
    parser.add_argument("--inc", type=Path, default=DEFAULT_INC)
    parser.add_argument("--src", type=Path, default=DEFAULT_SRC)
    args = parser.parse_args()

    if not (args.ndk13 / "INCLUDES1.3").exists():
        print("NDK 1.3 not found: %s" % args.ndk13)
        return 2

    ndk = parse_ndk13(args.ndk13)
    values = parse_inc(args.inc)
    used = used_symbols(args.src, values)

    errors = 0
    missing = 0
    for symbol in sorted(used):
        name, value = ndk13_lookup(symbol, ndk)
        if name is None:
            print("AFTER-1.3 %-32s %s" % (symbol, values[symbol]))
            missing += 1
            continue
        if value != values[symbol]:
            print("MISMATCH  %-32s rebuild=%s NDK1.3=%s" %
                  (symbol, values[symbol], value))
            errors += 1

    print("NDK 1.3 constants: %d used, %d error(s), %d after-1.3" %
          (len(used), errors, missing))
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
