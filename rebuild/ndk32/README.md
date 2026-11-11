# NDK 3.2 subset

This directory contains only the files needed to generate and verify the Amiga
API constants and library offsets used by the rebuild.

Source: Aminet `dev/misc/NDK3.2`
(<https://aminet.net/package/dev/misc/NDK3.2>), archive `NDK3.2.lha`,
SHA-256:

```
96cabd4ad683dced632e147bf86dee0f50dcb1254386216c25c362916a6409bb
```

Included files:

- `Include_I/exec/memory.i`, `Include_I/exec/types.i` — MEMF flags and the
  BITDEF macro definition.
- `Include_I/dos/dos.i` — MODE_*, OFFSET_*, locks and access modes.
- `Include_I/intuition/intuition.i`, `intuition/screens.i` — IDCMP_*,
  WFLG_*, screen types.
- `Include_I/devices/inputevent.i` — IECODE_*, IECLASS_*, IEQUALIFIER_*.
- `FD/*.fd` — function descriptors used to verify `api_lvo.inc`.

The NDK files remain under their original copyright/license; they are
included here only as documentation for the API constants used by the
reverse-engineered rebuild.
