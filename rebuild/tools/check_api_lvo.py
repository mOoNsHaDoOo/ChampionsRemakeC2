#!/usr/bin/env python3
"""Verify api_lvo.inc against the NDK 3.2 FD files.

api_lvo.inc contains the offsets actually used by the rebuilt binary.  This
check confirms them against the official NDK 3.2 function descriptors and
reports any difference, so an NDK change cannot silently alter a call.

Usage:
    python3 tools/check_api_lvo.py
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_FD = ROOT / "ndk32" / "FD"
DEFAULT_INC = ROOT / "api_lvo.inc"

LIBS = {
    "dos": "dos_lib.fd",
    "exec": "exec_lib.fd",
    "graphics": "graphics_lib.fd",
    "intuition": "intuition_lib.fd",
    "mathffp": "mathffp_lib.fd",
}

# Offsets verified from the original call sites that differ from NDK 3.2.
# The rebuilt binary is authoritative: these are kept as documented
# overrides instead of being silently replaced by the NDK values.
OVERRIDES = {
    "LVO_audio_BeginIO": "audio.device vector, not an FD library entry",
}


def parse_fd(path: Path) -> dict[str, int]:
    out: dict[str, int] = {}
    bias = None
    index = 0
    for raw in path.read_text(errors="replace").splitlines():
        line = raw.strip()
        if line.startswith("##bias"):
            bias = int(line.split()[1])
            continue
        if not line or line.startswith("*") or line.startswith("##"):
            continue
        match = re.match(r"([A-Za-z_][A-Za-z0-9_]*)\s*\(", line)
        if match and bias is not None:
            out[match.group(1)] = -(bias + 6 * index)
            index += 1
    return out


def parse_inc(path: Path) -> dict[str, int]:
    out: dict[str, int] = {}
    for line in path.read_text().splitlines():
        match = re.match(r"(LVO_\w+)\s+equ\s+(-?\d+)", line)
        if match:
            out[match.group(1)] = int(match.group(2))
    return out


LIB_MAP = {
    "dos.library": "dos",
    "exec.library": "exec",
    "graphics.library": "graphics",
    "intuition.library": "intuition",
    "mathffp.library": "mathffp",
}


def parse_ndk13_lvo(path: Path) -> dict[str, int]:
    out: dict[str, int] = {}
    section = None
    for raw in path.read_text(errors="replace").splitlines():
        line = raw.strip()
        match = re.match(r"\*+\s*([a-z0-9_.+ -]+?)\s*\*+$", line, re.I)
        if match:
            section = match.group(1).strip().lower()
            continue
        if section not in LIB_MAP:
            continue
        match = re.match(
            r"^\s*(-?\d+)\s+\$[0-9A-Fa-f]+\s+(-\$[0-9A-Fa-f]+)\s+"
            r"([A-Za-z_][A-Za-z0-9_]*)\(", line)
        if not match:
            continue
        name = match.group(3)
        offset = -int(match.group(2)[2:], 16)
        out["LVO_%s_%s" % (LIB_MAP[section], name)] = offset
    return out


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fd", type=Path, default=DEFAULT_FD)
    parser.add_argument("--inc", type=Path, default=DEFAULT_INC)
    parser.add_argument("--ndk13", type=Path,
                        default=ROOT / "ndk13" / "INCLUDE-STRIP1.3" /
                        "OFFS1.3" / "LVO.OFFS")
    args = parser.parse_args()

    ndk: dict[str, int] = {}
    for lib, filename in LIBS.items():
        for name, offset in parse_fd(args.fd / filename).items():
            ndk["LVO_%s_%s" % (lib, name)] = offset

    used = parse_inc(args.inc)
    errors = 0
    checked = 0
    for symbol, value in sorted(used.items()):
        if symbol in OVERRIDES:
            print("OVERRIDE %-36s %6d  (%s)" %
                  (symbol, value, OVERRIDES[symbol]))
            continue
        if symbol not in ndk:
            print("UNKNOWN  %-36s %6d  (not in NDK 3.2 FD)" %
                  (symbol, value))
            errors += 1
            continue
        checked += 1
        if ndk[symbol] != value:
            print("MISMATCH %-36s %6d  NDK=%d" %
                  (symbol, value, ndk[symbol]))
            errors += 1

    print("LVO checked against NDK 3.2: %d OK, %d error(s), %d override(s)" %
          (checked, errors, len(OVERRIDES)))

    if args.ndk13.exists():
        ndk13 = parse_ndk13_lvo(args.ndk13)
        ok13 = 0
        err13 = 0
        for symbol, value in sorted(used.items()):
            if symbol in OVERRIDES:
                continue
            if symbol not in ndk13:
                print("NDK1.3 UNKNOWN %-36s %6d" % (symbol, value))
                err13 += 1
                continue
            if ndk13[symbol] != value:
                same = [n for n, v in ndk13.items() if v == value]
                print("NDK1.3 MISMATCH %-34s %6d  NDK=%d  offset is %s" %
                      (symbol, value, ndk13[symbol], ",".join(same) or "?"))
                err13 += 1
                continue
            ok13 += 1
        print("LVO checked against NDK 1.3: %d OK, %d error(s)" %
              (ok13, err13))
        errors += err13

    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
