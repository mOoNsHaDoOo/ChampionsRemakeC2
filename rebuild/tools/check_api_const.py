#!/usr/bin/env python3
"""Check api_const.inc and the symbolic constants used by the rebuild asm.

The original instruction bytes are preserved in the comment above each
instruction.  For every instruction that uses an API symbol this script
evaluates the symbol expression and compares it with the immediate shown in
that comment.  Undefined symbols are reported too.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_INC = ROOT / "api_const.inc"
DEFAULT_SRC = ROOT / "source"

SYMBOL_RE = re.compile(r"(?<![0-9A-Za-z_])([A-Za-z_][A-Za-z0-9_]*)")
IMM_RE = re.compile(r"#([^,;\s]+)")
COMMENT_IMM_RE = re.compile(r"#\$([0-9A-Fa-f]+)")


def parse_inc(path: Path) -> dict[str, int]:
    out: dict[str, int] = {}
    for line in path.read_text().splitlines():
        match = re.match(r"([A-Za-z_]\w*)\s+equ\s+(-?\$?[0-9A-Fa-f]+)",
                         line, re.I)
        if not match:
            continue
        text = match.group(2)
        out[match.group(1)] = int(text.replace("$", "0x"), 0)
    return out


def evaluate(expr: str, values: dict[str, int]) -> int:
    text = expr.strip()
    text = re.sub(r"\$([0-9A-Fa-f]+)", r"0x\1", text)
    names = set(SYMBOL_RE.findall(text))
    for name in names:
        text = re.sub(r"(?<![0-9A-Za-z_])" + re.escape(name) + r"(?![0-9A-Za-z_])",
                      str(values[name]), text)
    if re.search(r"[^0-9A-Fa-fxX()+\-<>&|~ ]", text):
        raise ValueError(expr)
    return int(eval(text, {"__builtins__": {}}, {}))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--inc", type=Path, default=DEFAULT_INC)
    parser.add_argument("--src", type=Path, default=DEFAULT_SRC)
    args = parser.parse_args()

    values = parse_inc(args.inc)
    errors = 0
    checked = 0

    for path in sorted(args.src.glob("*.asm")):
        lines = path.read_text().splitlines()
        for index, line in enumerate(lines):
            stripped = line.strip()
            if stripped.startswith(";"):
                continue
            if "#" not in stripped:
                continue
            for expr in IMM_RE.findall(stripped):
                names = set(SYMBOL_RE.findall(expr))
                api = {n for n in names if n in values}
                if not api:
                    continue
                missing = names - set(values)
                try:
                    value = evaluate(expr, values)
                except (ValueError, KeyError, SyntaxError):
                    print("BAD EXPR %s:%d  %s" % (path.name, index + 1, expr))
                    errors += 1
                    continue
                if missing:
                    print("UNDEFINED %s:%d  %s" % (path.name, index + 1,
                                                   ",".join(sorted(missing))))
                    errors += 1
                    continue
                checked += 1
                comment = lines[index - 1] if index > 0 else ""
                match = COMMENT_IMM_RE.search(comment)
                if match:
                    expected = int(match.group(1), 16)
                    if value != expected:
                        print("MISMATCH %s:%d  %s=%#x comment=%#x" %
                              (path.name, index + 1, expr, value, expected))
                        errors += 1

    print("api_const: %d symbolic immediates checked, %d error(s)" %
          (checked, errors))
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
