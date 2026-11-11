# NDK 1.3 subset

The game executable was built against the Amiga 1.3 NDK.  This directory keeps
only the headers and the LVO table needed to verify the rebuild:

- `INCLUDES1.3/INCLUDE.I/EXEC/MEMORY.I`, `EXEC/TYPES.I` — MEMF flags, BITDEF.
- `INCLUDES1.3/INCLUDE.I/LIBRARIES/DOS.I` — MODE_*, OFFSET_*, locks.
- `INCLUDES1.3/INCLUDE.I/INTUITION/INTUITION.I`, `SCREENS.I` — IDCMP flags
  (`RAWKEY`, `MOUSEBUTTONS`, ...), window flags (`BORDERLESS`, `RMBTRAP`, ...)
  and screen types.
- `INCLUDES1.3/INCLUDE.I/DEVICES/INPUTEVENT.I` — IECODE_* and IECLASS_*.
- `INCLUDE-STRIP1.3/OFFS1.3/LVO.OFFS` — the 1.3 library vector offsets.

The 1.3 names predate the later aliases: `RAWKEY` instead of `IDCMP_RAWKEY`,
`BORDERLESS`/`RMBTRAP` instead of `WFLG_BORDERLESS`/`WFLG_RMBTRAP`.  The values
are identical; `tools/check_api_ndk13.py` maps the two naming styles.

Source: the `NDK_1.3` distribution provided on the local desktop.  The files
remain under their original Commodore-Amiga copyright.
