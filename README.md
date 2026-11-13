# Champions of Krynn: C port of the Amiga assembly with bugfixes and portability to current systems

This folder is a **from-scratch** C port of the Amiga version of Champions of
Krynn. It was written by converting, with various AIs, routine by routine, from the annotated 68000
assembly in `rebuild/source`. It does not derive from the old readable layer
or from the Ghidra decompilation (`src_c/H*.c`).

While WHDLoad is an amazing piece of software, we have a lovely multitasking OS, so why not run games in workbench ? It has always been my desire to fix the game to run it in KS 3.x with faster CPUs, AGA and all, and it runs on Windows, Linux, OSX, too, anything that is SDL2 compatible.

Bug fixes for Amiga version includes:

* blitter race condition fix (could cause LBM and other image painting bugs on faster CPUs)
* Screenmode promotion fix (with IPrefs set to promote screens running in DBLPAL/DBLNTSC would generate wrong display)

The same sources build two targets:

- **AmigaOS**, with SAS/C 6.x (`smakefile`).
- **Host** (Linux, macOS, Windows), with SDL2: CMake, a plain `Makefile` or
  Visual Studio 2022.

## Status

All the routines of the assembly are ported: `PORT_STATUS.md` reports
**1132 / 1132**. A routine counts as ported when a source file carries its
`PORT Hnnn+$XXXX` marker. A few markers document routines that have no C
function of their own:

- **Trampolines** (`bra.w` stubs) point to the ported routine they jump to.
- **Nested Pascal procedures** are ported inside their parent, or share an
  identical C helper.
- **Compiler runtime I/O** (H002 `IoErr`, H015 start-up and clean-up, parts
  of H020, H074 and H075) is replaced by the C library.
- **Blitter callbacks** of the queued blit (H049) run inside
  `queue_bitplane_blit`.

`unported.c` only holds the three H043 audio entry points, used when the game
is built **without** audio (see below).

The game has been play-tested on the host build with AddressSanitizer. The
tested features are:

- character creation and the party menu;
- the first town, the caravan battle and party defeat;
- treasure, Take and Pool;
- camp: Fix, Rest, Memorize, Order and Drop;
- Turn Undead;
- potions, scrolls and wands, at camp and in combat.

The playtest reports, and the fixes they led to, are kept in `backlog.md`.

## Rules

- **One file per hunk:** `hNNN_<role>.c` with its header `hNNN_<role>.h`.
- **Marker:** every ported function has a comment above it with
  `PORT Hnnn+$XXXX`, the address of the original routine.
- **Faithfulness:** behaviour follows the assembly. Where the C code has to
  differ (host build, 64-bit pointers, out-of-bounds reads, compiler runtime),
  the comment says so explicitly.
- **Calling convention:** arguments keep the original order (the first
  argument is the one at the highest stack offset). A byte push takes a word
  slot. Nested Pascal procedures become C functions that receive their
  parent's frame as a struct.
- **Global data:** `globals.h` maps the data hunk `H005` as a byte image of
  `$531C` bytes with the original big-endian layout (`g_h005`, read with
  `H005_B`/`H005_W`/`H005_L` and written with `H005_SET_*`), because the game
  reads the same addresses as bytes and as words and saves contiguous ranges.
  Original 32-bit pointers are plain C variables. The persistent state blocks
  are `g_state_a` (`$3E04`), `g_state_b` (`$3E00`) and `g_state_c` (`$3DFC`).
- **Records:** characters and monsters (`Character`, `$1AA` bytes), items
  (`CokItem`, `$48`), combat turn blocks (`CokTurn`, `$18`) and effects
  (`CokEffect`, `$0A`) keep the original byte layout in a `b[]` array.
- **Commented accesses:** every read or write of an anonymous array or record
  field (`g_h005`, the state blocks, `->b[]`, the module-local data arrays)
  carries a comment that explains the element, for example
  `/* $3DF6: game speed (0..9) */`. Descriptions starting with `use:` record
  the observed use where the exact meaning is not yet known.
- **Comments and identifiers** are in Italian, as in the rest of the port.

## Build

### Host with CMake and SDL2 (Linux, macOS, Windows)

```sh
cmake -S . -B build-cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build-cmake
./build-cmake/cok
```

Install SDL2 with `libsdl2-dev` (Debian/Ubuntu), `brew install sdl2` (macOS)
or vcpkg. CMake looks for it as a CMake package first, then with pkg-config.
The plain `Makefile` also works (`make`, then `./build/cok`).

### Visual Studio 2022, x86 (Win32) and x64 (AMD64)

```bat
windows\get-sdl2-nuget.cmd
cmake --preset vs2022-x64
cmake --build --preset vs2022-x64-release
```

For x86, use `vs2022-x86` and `vs2022-x86-release`. `get-sdl2-nuget.cmd`
downloads the `sdl2.nuget` and `sdl2.nuget.redist` packages from nuget.org
into `third_party/sdl2-nuget`. These are community packages that
redistribute the official libsdl.org libraries, with libraries and DLLs for
Win32 and x64. CMake picks them up and copies `SDL2.dll` next to `cok.exe`.

Visual Studio can also open the folder directly (File > Open > Folder), and
the presets then appear in the configuration list. The generated `.sln` is
in `build-vs2022-x64` / `build-vs2022-x86`.

### AmigaOS with SAS/C 6.x

```sh
smake          # game without audio
smake AUDIO    # game with audio (DEFINE=COK_AUDIO)
```

Every new source file must be added to `OBJS` in the `smakefile`. FFP math
uses `mathffp.library` through `#pragma libcall` (no float types), so no
math library needs to be linked.

## Audio

Audio is a critical part, so it is optional and isolated behind the
`COK_AUDIO` define:

- `smake AUDIO` on the Amiga, `make AUDIO=1` with the Makefile.
- With `COK_AUDIO`, H043 (the "SoundX" IFF SMUS player with 8SVX samples) and
  H094 (the vertical-blank server and software interrupt) are compiled with
  their Exec helpers (H079, H090, H092).
- Without it, the three H043 entry points in `unported.c` do nothing.
- On the host, `host/audio.c` emulates `audio.device` with SDL2: four Paula
  channels at the PAL clock, mixed at 44100 Hz, with completed requests
  handed back on the main thread.

## Host environment

On the host, the AmigaOS libraries used by the game are emulated in `host/`.
`host/ndk.h` reproduces NDK structures and functions with the same names, so
the game's library adapters are identical on both targets. The screen is
shown with SDL2.

Useful variables:

- `COK_DATA=dir`: directory of the game files (default: the current one).
- `COK_SCALE=n`: window scale.
- `COK_SCREENSHOT=file.bmp`: saves the last frame on exit.
- `COK_SCREENSHOT_AT=t1,t2,...`: with `COK_SCREENSHOT=base`, also saves
  `base-1.bmp`, `base-2.bmp`, ... at the given milliseconds.
- `COK_KEYS=ms=Key,...`: timed simulated keys, with SDL names such as `P`,
  `Return`, `Escape`, `Left`.
- `SDL_VIDEODRIVER=dummy`: runs without a window.

**File names and system requesters**
- As on AmigaDOS, file names are case-insensitive and the volume name
  ("df0:", "Disk Two:") is ignored.
- System requesters (e.g. "insert disk") are answered with Return/R (Retry)
  or Esc/C (Cancel). Without a window the program exits.

**Input**
- Keyboard and mouse reach the game as IDCMP events: RAWKEY with Amiga
  keyboard codes, and MOUSEBUTTONS.
- The right mouse button acts as the menu button, because the window has
  RMBTRAP.

## Tests

`tests/` holds tests for single routines, for example:

```sh
cc -std=c99 tests/h015_test.c h015_runtime.c -o h015_test && ./h015_test
```

With CMake they are built by default (`COK_BUILD_TESTS`) and run with
`ctest`.

Data initialisation is compared byte by byte with an emulation of the
assembly (`scripts/emu68k_init.py`); see the headers of `tests/bss_test.c`
and `tests/h004_test.c`. The constant tables are generated
(`scripts/gen_init_data.py`, `scripts/gen_h004_init_data.py`) and applied by
`init_data.c`; the loops are written by hand.

## Port status report

`PORT_STATUS.md` lists every routine of the assembly and the file and line
of its port. It is regenerated from the repository root with:

```sh
python3 scripts/port_status.py --check
```

or with `make status` from this folder.
