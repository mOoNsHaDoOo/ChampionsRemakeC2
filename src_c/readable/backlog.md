# Champions of Krynn port backlog

Reports delivered during the port (from oldest to newest).
Each entry gives the date/time (UTC) of the original message.

## 2026-11-10 11:20

In short: **you cannot use the Pro subscription with the API.** They are two separate products, with separate billing.

**Pro subscription (claude.ai)**
- Covers the use of Claude on the web, desktop and mobile apps.
- Also covers **Claude Code**: sign in with your claude.ai account (`/login` in the terminal) and usage counts against the limits of the Pro plan, with no need for an API key.
- Does **not** include credits or keys for the API.

**Claude API (Claude Console)**
- Has its own account and billing: you pay as you go, per token, by loading prepaid credit.
- To get started:
  1. Go to **platform.claude.com** (the Console, formerly console.anthropic.com) and sign in. You can use the same email, but the credit is separate.
  2. Add a payment method and buy credit under **Billing**.
  3. Create a key under **API Keys**.
  4. Use it in your code or your tools:
     ```bash
     export ANTHROPIC_API_KEY="sk-ant-..."
     ```

**So:**
- If you want to use Claude for programming, Claude Code with the Pro login is the right way and you pay nothing extra.
- If instead you want to integrate Claude into an app or a script of your own, or use a third-party tool that asks for an API key, you have to use the API, at a separate cost.

What exactly do you want to do? Then I can point you to the most suitable path.

---

## 2026-11-10 12:41

I found several definite mismatches between the assembly and the readable C layer (`src_c/readable`), and the worst ones are in the ECL script engine. The project builds cleanly with no warnings, so these are behaviour differences, not compile problems.

**Scope:** there is 286k lines of assembly and 11k lines of C, so I didn't check everything. I compared these routines instruction by instruction: the ECL engine (H061/H064), the menu frame (H044), the tile and text blitters (H049), and save/load (H066). The rest of the C (`actions.c`, `ui.c`, `audio.c`, combat, shop and others) has not been checked.

## ECL script engine (`ecl.c`): serious

**1. Variables are read and written at the wrong place (`ecl.c:154`, `ecl.c:174`).** The original treats script variables as 16-bit words, so variable N lives at byte N×2 (`H061+$2E48`, `$2C3A`). The C uses N as a byte offset, so it reads and writes overlapping, wrong bytes.
- This disagrees with the C itself: `ui.c` reads the state block at byte offsets taken from native code (`$3F2`, which is variable `$1F9`).
- The C also leaves out three things the original handles:
  - Addresses `$3500–$52FF` read and write bytes of the script program itself, so scripts can modify their own code.
  - A set of special addresses (`$EA`, `$B1`, `$FB`, `$FC`, `$33D`, and everything from `$754B` up) map to other game globals.
  - Writes trigger side effects: variables `$FD`/`$FE` set a flag (`$24B5`), variable `$E6` changes the game mode (`$3DE3`), and every write to state block B calls the hook at `$27E2`.

**2. Operand types are decoded wrongly (`ecl.c:145`).** `H061+$184E` folds the high types with `desc - $7D` (the operand reader uses `- $7C`), then picks from a jump table:

| Operand type | Original | C |
|---|---|---|
| 0 | the inline byte | inline byte ✓ |
| 1 | reads a variable | returns the inline byte ✗ |
| 2 | 16-bit constant (high byte first, no offset subtracted) | reads a variable ✗ |
| 3 | reads a variable | 16-bit constant ✗ |
| 4 | the decoded address itself, as a number | reads a variable ✗ |
| 5 | nothing (default case) | 16-bit constant ✗ |
| 0x80 | reads a variable | 0 ✗ |
| 0x81 | the decoded address itself | reads a variable ✗ |

**3. SAVE has its operands reversed (`ecl.c:295`).** `H064+$0468` writes the value of operand 1 into the address given by operand 2. The C writes operand 2's value into operand 1's address. The original also only checks operand 1 to decide on the string path.

**4. COMPARE uses unsigned comparisons in the original (`ecl.c:261`).** `H061+$3A0A` uses unsigned branches (`bcc/bls/bhi/bcs`). The C compares signed values, so results differ for values of `$8000` and above. The original also compares strings when either operand type is 0x80 or higher (via `$3904`); the C skips this.

**5. DIVIDE (`ecl.c:275`).** The original divides unsigned (`divu`) and stores the remainder in state block B at byte `$67E`. The C divides signed and drops the remainder.

**6. Smaller differences:**
- When a string operand's control byte is 0, the original copies the runtime string at `$27(a4)`. The C leaves the string empty (`ecl.c:121`).
- The original's GOSUB stack is an unbounded linked list. The C stack holds 16 entries and silently drops extra calls.
- RETURN with an empty stack runs the full EXIT handler (`H064+$0156`). The C only sets `halted`.

These parts match the assembly exactly:
- the operand reader, including when the program counter advances;
- the 6-bit string decoder;
- address decoding (high byte = third byte of the operand);
- the order of the IF flags;
- the operand count table used to skip instructions (all 66 entries).

## Save/load (`save.c`): fields missing

- **Before saving (`H066+$329C`)**, the original writes:
  - `$3DF6` into state A byte `$1F8`;
  - `$24D5*2 + $24D4` into state A byte `$1FE`;
  - `$246E` into state B byte `$624`.
- **After loading**, it reads them back and finishes with `$3DE2 = $3DE3; $3DE3 = 0`. Note that `$246E` is restored from state B and overrides the header byte.
- `save_game` (`save.c:165`) and `load_game` (`save.c:367`) do none of this.
- The block sizes and order do match: 1 + `$800` + `$800` + `$400` + 8 + 1 + 1 + 3×(2+2) bytes.

## Graphics

- **The tile blitter copies 5 bitplanes; the C copies 4 (`tile8.c:25`, `tile8.c:53`).** `H049+$012A` loops over planes 4 down to 0, and the screen is 5 planes deep (`intuition.c:141`). The C never touches plane 4, so stale pixels there would show through as wrong colours.
  - If DAA record 0xCA really holds 4 planes, plane 4 should at least be cleared.
  - The original also chooses one of 5 sheets by tile-code range (`<$2E`, `<$74`, `<$BA`, `<$100`, `<$128`). The C's `0x14 + value` is correct only because tile `$114` falls in sheet 4.
- **Text is drawn transparent in the C but opaque in the original (`text.c:93`).** `H049+$0224` writes every plane from a foreground/background pen pair (fill or inverted glyph), so the background is always overwritten. The C uses JAM1 with a single pen, so it works only where callers clear the area first, as `ui_draw_inverse_text` and `ui_choice_draw` do.
- In the same routine, x and y are character cells, not pixels, and text is clipped at 40 columns.
- The menu frame in `ui.c` matches H044 for the column/state mapping, the side rows 15–17 gap, and the bottom row. It omits the palette/clear calls at `H044+$01CC–$0200`.

The ECL problems will break almost any script, so I'd fix those first, starting with word addressing and the operand-type table. I can write those fixes if you want.

---

## 2026-11-10 12:46

I've rewritten the ECL engine's memory and operand handling in `src_c/readable/ecl.c` to match the assembly. It builds with no warnings under gcc and clang (`-Wall -Wextra`), and `make check` passes.

`make check` doesn't run any scripts, so I also wrote a standalone test that executes small ECL programs. It covers variable addressing, every operand type, the maths operations, SAVE of numbers and strings, string loading and comparison, the special variables, and RETURN with an empty stack. All of it passes. I haven't run a real game script or the Amiga build.

**What changed:**
- **Variable addressing:** variable N is now the 16-bit word at byte N×2, as the original does. The script-program region (`$3500–$52FF`, byte-sized, scripts can modify it) and the special addresses (`$754B` and up, which map to the party's position and facing) are now handled.
- **Side effects of writes:**
  - Writing variable `$FD`/`$FE` sets the flag at `$24B5`.
  - Changing variable `$E6` switches the game mode byte (`$3DE3` to 3 or 4) and saves the old one.
  - Writing the special addresses updates the position/facing and sets `$24B7`/`$24B8`.
- **Operand types:** the reader and the evaluator now each use their own folding of the high types (`-$7C` and `-$7D`, as in the original). Type `5`/`0x81` now also loads a string from the given address.
- **SAVE:** operands are now in the original order (value first, then destination). String SAVE writes one character per word plus a terminating zero; address `$3100` is the current character's name, up to 15 characters.
- **COMPARE:**
  - Numbers are compared unsigned.
  - If either operand is a string type, it now compares the strings ignoring case, as `H026+$0106` does.
- **DIVIDE:** unsigned, and the remainder goes into state block B at byte `$67E`. MULTIPLY no longer risks signed overflow.
- **RETURN** with an empty stack now behaves like EXIT, and EXIT clears the GOSUB stack.
- **Header:** I added `ecl_var_read`/`ecl_var_write` to `ecl_exec.h` so other modules can use the same variable logic.

**Still not done, each marked in the code:**
- Reads and writes to state block B skip the hooks `H061+$208E` and `$27E2`, which map some of those variables onto the current character's fields. Those routines are about 1.9 KB of assembly and need porting separately.
- An inline string with a control byte of 0 should copy a string stored at `H061+$27(a4)`, but I couldn't identify its contents, so it stays empty.
- The GOSUB stack is still capped at 16 entries; the original's is unlimited.

I worked on a local copy of your zip, so nothing has been committed anywhere. Apply the patch from the root of your repository:
```bash
git apply ecl-fix.patch
```

Next on the list are the save/load fields in `save.c`, then the 5-bitplane tile copy. Want me to continue with those?

Files are in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- ecl-fix.patch
- ecl_vm_test.c

---

## 2026-11-10 12:49

I've added the fields the original game syncs around saving and loading to `src_c/readable/save.c`. It builds cleanly with gcc and clang. A direct test of the new code passes, but I couldn't test a full save→load round trip, because the host build crashes on its first file operation (details at the end).

**Before saving** (from `H066+$329C`), these globals are now copied into the state blocks:
- `$3DF6` (demo scenario) goes into state A at byte `$1F8`.
- `$24D5 * 2 + $24D4` goes into state A at byte `$1FE`.
- `$246E` (resource group) goes into state B at byte `$624`.

**After loading** (from `H066+$2CE4`, `$2F48` and `$2FEA`), they're read back:
- `$24D5` is set to the word at `$1FE` shifted right by 1, and `$24D4` to its lowest bit.
- `$3DF6` is restored from the word at `$1F8`.
- The word at `$67C` in state B is set to 0.
- `$246E` is taken from the word at `$624` in state B. This overrides the resource-group byte in the file header, as the original does.
- Finally, the saved game mode (`$3DE3`) is moved into "previous mode" (`$3DE2`) and the current mode is set to 0. No C code reads the mode after a load, so this doesn't affect anything else.

The test sets the globals, runs the pre-save copy, scrambles everything, runs the post-load copy, and checks that each value comes back.

**Still not done:** after loading, the original also reloads the wall sets and view, or else shows screen `$79`, and then redraws (`H066+$2F58–$2FE4`). Those are native graphics routines that the C doesn't have yet, so I left a comment there instead.

**Existing problem you should know about:** in the host build, `save_game` crashes on the first DOS call. On the host, `dos_Open`/`dos_Read` call through `DOSBase`, which is NULL there. My change didn't cause this, and the Amiga build isn't affected, but on the host save/load can't work until those calls get host implementations.

Apply the patch from the root of your repository, on top of the ECL patch:
```bash
git apply save-fix.patch
```

The last item from the review is the tile blitter, which copies 4 bitplanes where the original copies 5. Should I fix that next, or look at the host DOS crash first?

Files are in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- save-fix.patch
- save_sync_test.c

---

## 2026-11-10 12:51

I've fixed the tile blitter in `src_c/readable/tile8.c`, and the bug turned out to be narrower than I said in the review. The C was reading the tile data correctly; it just wasn't clearing the fifth bitplane.

**What the assembly shows:**
- **Sheet BitMap:** `H029+$0408` always allocates the sheet BitMap with 5 planes and zero-fills every one of them.
- **Record layout:** `H029+$0A0E` picks the layout from a 3-character file-name prefix (almost certainly `8X8`).
  - On a match, the data starts right after the 9-byte header and fills 4 planes.
  - Other records carry a 64-byte palette and fill 5 planes starting at `0x49`.
- **The C's loader is right:** its 38 columns × 4 planes only fits the 4-plane layout. Plane 4 of the menu sheet is therefore all zeros.
- **The blit:** `H049+$012A` copies all 5 planes, so drawing a tile clears plane 4 of that 8×8 cell on the 5-plane screen. The C copied only 4 planes, so whatever was already in plane 4 stayed there and could show through as wrong colours.

**The fix:** `tile8_draw` now writes all 5 planes, up to the screen's depth. Planes the record doesn't have are written as zero, matching the original's empty plane. The loader is unchanged; I added comments recording the layout rules above.

**Testing:**
- The host build is clean with gcc and clang, and `make check` passes.
- The draw code only compiles for Amiga, so I built `tile8.c` with `COK_AMIGA=1` on the host and drew into a fake 5-plane screen. The 4 data planes copy correctly, plane 4 of the cell is cleared, and neighbouring bytes are untouched.
- The same test against the old `tile8.c` fails on plane 4, so it catches the bug.
- I haven't run it on real Amiga hardware.

Apply it from the root of your repository, after the earlier two patches:
```bash
git apply tile8-fix.patch
```

That finishes the items from the review. One related point is still open: text drawing is transparent in the C but opaque in the original, so text can leave old pixels behind unless the caller clears the area first. There's also the host-build crash in save/load (`DOSBase` is NULL). Want me to take either of those next?

Files are in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- tile8-fix.patch
- tile8_draw_test.c

---

## 2026-11-10 12:55

Text drawing is now opaque like the original. Every character cell is filled with the background pen and the glyph pixels with the foreground pen, so text no longer leaves old pixels behind.

**What the assembly shows:**
- **Arguments:** every game text call goes through `H030+$0256`, which passes (string, length, background, foreground, row, column) straight to `H049+$0224`.
- **Per-plane rule:** for each plane, the foreground and background pen bits choose between filling with 0, filling with 1, the glyph, or the inverted glyph. That works out to "glyph pixel ? foreground : background" for every pixel in the cell.
- **Background pen:** the calls I checked ("Loading...Please Wait" at `H006+$06EE` and the party menu in H063) pass background 0. Highlighted items use a non-zero background.

**What changed:**
- **`text_font_draw_bg(text, x, y, pen, bg_pen, maxlen)`** is new.
  - It fills the line's cells with the background pen and then draws the glyphs on top in the foreground pen.
  - It forces the plane mask to `$FF` so all 5 planes are written.
  - Lines are clipped at column 40, as the original does (`40 - x`).
- **`text_font_draw`** keeps its signature and now calls the new function with background 0. None of the ~30 existing call sites needed changing.
- **`ui_draw_inverse_text`** in `ui.c` now uses the new function directly, instead of filling a rectangle and then drawing over it.
- **Glyph lookup** now uses the low 6 bits of the character code, like `H049+$045A`. Before, any code outside 32–95 became a space; now it maps to the same glyph as in the original.
- **Kept on purpose:** `maxlen` still limits the text, even though the original ignores its length argument and always draws to the end of the string. The C menu code relies on `maxlen` to draw single words of an option.

**Testing:**
- The host build is clean with gcc and clang, and `make check` passes.
- The drawing code only compiles for Amiga, so I built `text.c` with `COK_AMIGA=1` and routed the graphics calls (SetAPen, SetDrMd, RectFill, BltTemplate) to stubs that draw into a fake 5-plane screen. I compared the result against an independent model of `H049+$0224`, plane by plane.
- The cases covered normal text, the "Loading" call, a highlighted item, both pens non-zero, a line longer than 40 columns, and unusual characters. All matched.
- The same test fails on every case with the old `text.c`.
- Not checked on real Amiga hardware.

Any text the C previously drew transparently over a picture will now get a black box behind it. That matches the original, but it's the place to look if a screen suddenly looks different.

Apply it from the root of your repository, after the earlier patches:
```bash
git apply text-fix.patch
```

That leaves the host-build crash in save/load (`DOSBase` is NULL on the host). Want me to look at that next?

Files are in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- text-fix.patch
- text_draw_test.c

---

## 2026-11-10 13:00

I've fixed the host `DOSBase` crash. Save/load and character load/save now work in the host build. The save→load round trip that used to segfault passes, and I also tested a two-character party.

**Cause:** in the host build (`COK_AMIGA=0`) the `dos_*` macros in `dos.h` still called through `DOSBase` plus the library offset, and `DOSBase` is NULL on the host. Only SAS/C remapped them to real functions. It hit `save_game`, `load_game`, `save_game_exists`, `character_load`/`character_save` and `io_read_all`/`io_write_all`. The host data loader already used stdio, which is why the game got as far as it did.

**What changed:**
- **`include/amiga/dos/dos.h`:**
  - On Amiga builds the macros are unchanged.
  - On the host, `dos_Open`, `Close`, `Read`, `Write`, `Seek`, `DeleteFile` and `IoErr` now go to host functions.
  - It now includes `cok/platform.h` itself, so `COK_AMIGA` is always defined at that point.
- **New `readable/dos_host.c`** implements those calls with stdio while keeping AmigaDOS behaviour:
  - A file handle is a number from 1 up (from a table of 32 open files); 0 means failure.
  - `Close` and `DeleteFile` return -1 for success and 0 for failure.
  - `Seek` returns the previous position.
  - Opening for read/write creates the file if it's missing and doesn't truncate it.
  - `IoErr` returns AmigaDOS error codes, for example 205 for "object not found".
- **Where save files go:** relative paths are tried under `COK_DATA_DIR` first, the same way the host data loader works. Reads fall back to the current directory.
  - Like AmigaDOS, it doesn't create folders, so the `SAVE/` folder must already exist. If it doesn't, saving prints an error instead of crashing.
- **Build files:** `dos_host.c` is added to `CMakeLists.txt` and `build_reference.sh`. The Makefile picks it up automatically, and `smakefile` doesn't need it.

**Testing:**
- The host builds with gcc and clang are clean, and `make check` passes.
- No host code path references `DOSBase` any more. Seven wrappers in `dos_exec.c` (Lock, Examine, Info and similar) still do, but nothing on the host calls them.
- The save→load round trip passes, both from the current directory and with `COK_DATA_DIR` set. `savgamZ.dat` comes out at 5481 bytes, the original format's size.
- With a two-character party, it writes `savgamY.dat` plus a `.sav`, `.swg` and `.fx` file per character. Both characters load back with their names and levels, in the right order.
- The host DOS functions pass checks for writing, seeking, reading to end of file, opening read/write, the error code for a missing file, invalid handles, and deleting.
- Not tested on Amiga hardware. Amiga builds still use the original macros.

**Existing problem, not fixed:** `build_reference.sh` compiles and links again with gcc and clang, but its `runtime_test` crashes in the decompiled `sub_H013_00000982`. It crashes the same way with all my changes removed, so it's unrelated to DOS. I can look at it if you want.

Apply it from the root of your repository, after the earlier patches:
```bash
git apply dos-host-fix.patch
```

Files are in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- dos-host-fix.patch
- dos_host_test.c

---

## 2026-11-10 13:19

The `runtime_test` crash is fixed. The bug was in the test, not in the decompiled code, and `build_reference.sh` now finishes with "runtime H013/H059: OK" under both gcc and clang.

**Cause:**
- **The decompiled routine is correct:** `sub_H013_00004F6C` is `tst.b -$210(a5)` followed by a call to `$0982` only if that byte is non-zero, and the C matches the assembly exactly.
- **The test's A5 was wrong:** on the 68000, a routine's locals sit below A5. The test passed the start of its zeroed 1024-byte buffer as A5, so `A5 - 0x210` read 528 bytes *before* the buffer.
- **Why it crashed:** that out-of-bounds byte happened to be non-zero. So instead of returning early as the test intends, the routine ran the full `$0982` routine, which isn't set up for that, and crashed.

**Fix:** the test now sets A5 64 bytes below the top of the buffer, the same convention `registers_init()` uses, so `A5 - 0x210` falls inside the zeroed frame. It's a six-line change to `tests/runtime_test.c`; nothing else changed.

**Testing:**
- `build_reference.sh` passes with gcc and clang.
- Under AddressSanitizer and UndefinedBehaviorSanitizer (gcc), the old test reports a `global-buffer-overflow` at exactly that read in `sub_H013_00004F6C`. The fixed test runs clean.
- I couldn't use clang for the sanitizer run because its sanitizer runtime isn't installed here. The script's relocatable link (`-r`) also doesn't work with sanitizers, so for that run I linked the test directly from the script's objects.

This runtime test needs the DOS host patch to link, so apply it after the earlier ones, from the root of your repository:
```bash
git apply runtime-test-fix.patch
```

That's everything from the original review fixed, apart from the native routines I flagged as not yet ported. Each patch is separate, so you can apply them in order:

```bash
git apply ecl-fix.patch
```
```bash
git apply save-fix.patch
```
```bash
git apply tile8-fix.patch
```
```bash
git apply text-fix.patch
```
```bash
git apply dos-host-fix.patch
```
```bash
git apply runtime-test-fix.patch
```

Files are in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- runtime-test-fix.patch
- ecl-fix.patch
- save-fix.patch
- tile8-fix.patch
- text-fix.patch
- dos-host-fix.patch

---

## 2026-11-10 13:23

I've zipped everything, including the `.gitignore` fix.

**`.gitignore`:** the bare `cok` line, meant for the built binary, also matched the `src_c/include/cok/` header folder. That's why `src_c/include/cok/tile8.h` was never committed, so a fresh clone of your repository doesn't build, with or without my changes.
- I added `!cok/` right after it, so files named `cok` (or `cok.exe`, `cok_readable`) are still ignored anywhere, but folders named `cok` aren't.
- I also added `cok_audio`, which `smake AUDIO` produces.
- With git's own ignore check, the headers in `src_c/include/cok/` are no longer ignored, while `src_c/readable/cok`, `build/cok`, `cok_audio`, `cok.exe` and `*.o` still are.
- This is patch 07, which also adds the missing `tile8.h`. After applying it, commit `tile8.h` so other clones get it.

**What's in the zip:**
- `patches/`: seven patches to apply in order (01 ECL, 02 save, 03 tile blitter, 04 text, 05 host DOS, 06 runtime test, 07 `.gitignore` plus `tile8.h`), and `all-fixes.patch` with all of them in one file.
- `source/`: your full source tree at commit `9561aac` with every fix applied. It has no `.git` folder and no build outputs.
- `changed-files/`: only the 14 changed or new files, at their repository paths, if you'd rather copy files than apply patches.
- `tests/`: the standalone tests I wrote during the review.
- `README.md`: what each patch fixes, the apply order, what's still not ported, and how to run the tests.

**Verification, from a clean clone of your repository:**
- Applying the seven patches one by one gives exactly the same files as `all-fixes.patch` and as `source/` (checked with `diff -r`).
- From `source/` without any extra files: host builds are clean with gcc and clang, `make check` passes, and `build_reference.sh` prints "runtime H013/H059: OK" with both compilers.
- All five bundled tests pass when built with the README's commands.
- Nothing has been run on real Amiga hardware.

To apply everything to your repository at once, from its root:
```bash
git apply cok-fixes/patches/all-fixes.patch
```

The zip is 2.8 MB and is in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- cok-fixes.zip

---

## 2026-11-10 13:30

I fixed one part of `audio.c` (the envelopes) and stopped there. Everything else wrong in `audio.c` and `actions.c` would mean porting whole routines from the assembly, and that needs your go-ahead.

**Fixed: `audio.c` envelopes (patch 08)**, following `H094+$050C..$0614`:
- **Period envelope, `FF xx`:** it's now a 4-byte command. After `FF` comes an opcode byte (0 = end the note, 1 = stop the envelope, anything else = "set"), and the new period is the next two bytes. The C used to read 3 bytes, using the opcode as the high byte, so it read the rest of the envelope out of step.
- **Volume envelope:** the level is now `scale * v >> 6`, capped at `$4000`, where `scale` is the voice's word `$2C`. The C used to hard-code 64. The delta is a 16-bit signed difference divided by the count, as in the original.
- **Step order:** both envelopes now add `delta` before decrementing the count (`subi.b #1` / `bhi`), matching the original.
- **Envelope order:** the period envelope runs before the volume envelope. On `FF 00`, the note ends straight away and the volume envelope is skipped that tick.
- **Testing:**
  - The host build is clean and `make check` passes.
  - A new test runs crafted envelope bytecode through `audio.c` compiled in its Amiga+audio configuration. All checks pass on the new code; the old code fails 6 of them.
  - The three warnings in that configuration were already in the original file.
  - Not checked on real Amiga hardware.
- **Still missing:** `scale` should be track volume × note velocity, but the voice setup still passes 64 (see below).

**Needs a port instead of a fix:**
- **`audio.c` note setup (`H094+$0288`/`$0390`):**
  - The original picks an octave from the 8SVX header (`samplesPerHiCycle`, `ctOctave`, period threshold `$118`) and builds one-shot/repeat segments. The period table comes from `H043+$05D2`.
  - The C uses its own length/period rule (minimum 124) and its own volume formula (`64 * dynamic / 127`), neither of which is in the assembly.
  - Its playback model (`cycle`/`data_len`) would have to change with it.
- **`actions.c` LOAD FILES / LOAD PIECES (`H064+$1004`):**
  - The original evaluates the operands, so variables work. LOAD FILES loads block `op1` from `GEO<resource group>.dax`. LOAD PIECES fills wall slots 1–3 through `H011+$14EA`, with `$FF`/`$7F` as special values.
  - The C merges the two opcodes, uses the raw operand bytes, and uses the operand as the file-name digit.
  - A faithful version needs the three-slot wall model, which `view3d.c` doesn't have.
- **`actions.c` ECL menus (`H064+$13AC`/`$1544`):**
  - The originals read 3 or 2 operands, then a variable number of item strings, and store the chosen item in a variable.
  - The C reads no operands, so any script with a menu goes out of step after it.
- **Placeholders:**
  - `party_cast_spell`, `party_view_map`, `party_search`, `party_look`, `party_encamp`, `party_open_area_map` and the combat helpers print debug text or do minimal work. There's no original logic in them to fix.
  - Each would be a separate port.

---

## 2026-11-10 13:39

I've fixed one part of `audio.c` (the envelopes) and stopped before the larger ports. Each of the four turned out to sit on top of other code the C also reconstructed loosely, so I want to agree the order with you before going further. Nothing in `actions.c` has changed yet. The updated zip is attached.

**Fixed: `audio.c` envelopes (patch 08)**, following `H094+$050C..$0614`:
- **Period envelope:** `FF xx hi lo` is now read as 4 bytes. The C used to read 3, so it fell out of step with the envelope data.
- **Volume envelope:** the level is `$2C * v >> 6`, capped at `$4000`, instead of a hard-coded 64.
- **Step order:** both envelopes add `delta` before decrementing the count.
- **Envelope order:** the period envelope runs first, and `FF 00` ends the note straight away.
- **Testing:** a new envelope test passes on the new code and fails on the old one, and `make check` passes. Not tested on Amiga hardware.

**The four ports depend on code below them that's also not faithful:**
- **ECL menus:**
  - What the original stores is now clear: the vertical menu stores the 0-based index, and Esc/E stores the row highlighted at that moment. The horizontal menu stores the 0-based position of the hotkey, or `$FF`.
  - Showing them correctly needs four layers rebuilt first:
    - the key translation in `H010`, because the C returns Amiga raw codes for the cursor keys;
    - `UI_RequestChoice` (`H008+$01FC`), because the C port uses the arrows itself and returns the wrong thing in its first parameter;
    - the text window `H030+$0302`;
    - the list menu `H008+$1AF4`.
- **LOAD FILES/PIECES:**
  - The file is `GEO<resource group>.dax` with the operand as the block, and there are three WALLDEF slots.
  - `view3d.c` has only one wall set, so this needs `H011+$14EA` and the view model.
- **Audio note setup:**
  - The octave/period/volume rules come from the 8SVX header and a period table built in `H043+$05D2`.
  - The C's own playback model has to be replaced along with it.
- **Placeholder commands:** each is a separate port.

Everything I read is in `PORTING_NOTES.md` in the zip, with offsets, so none of it needs re-reading. `tools/hunkbytes.py` reads bytes and strings from the `.asm` files; that's how I resolved the menu strings (`"Select"`, `" Next"`, `"PRESS <ENTER>/<RETURN> TO CONTINUE"` and so on). It also confirmed that the two string literals I'd left empty in the ECL fix really are empty, so that fix is exact. I didn't need kb.marrani.lol for any of this.

Unless you'd prefer a different order, I'll build from the bottom up:
1. `H010` key translation;
2. `H008+$01FC` `UI_RequestChoice`;
3. `H030+$0302`/`$0B6C`;
4. `H008+$1AF4` list menu;
5. then the two ECL menus, LOAD FILES/PIECES with `H011`, the audio note setup, and finally the placeholder commands.

That replaces some existing C UI code (`ui_request_choice*`, `ui_list_menu`) rather than patching it. Should I go ahead?

---

## 2026-11-10 14:04

The first five steps are ported (input, `UI_RequestChoice`, text window, list menu, ECL menus), and ECL scripts with menus now stay in step. They're in patch 09 of the zip I've sent. I stopped before LOAD FILES/PIECES because doing it faithfully means porting the whole 3D-view module, and I want your go-ahead on that first.

All 12 tests pass from the bundled source tree, along with the build, `make check` and the reference build. Nothing has been run on real Amiga hardware.

**What patch 09 changes, step by step:**
- **Input (`H010`, `H007+$064E`):**
  - The original's key codes: lowercase letters, cursor keys as `8/2/6/4` (as on the numeric keypad), Del = `$10`, Alt+A/M/Q/X = 1–4, Alt+C shows free memory.
  - Left mouse button = Enter, right button = Esc.
  - The timed wait returns 0 if the key arrives on the very last step, as the original does.
- **`UI_RequestChoice` (`H008+$01FC`)**, in a new file `choice.c`:
  - Choices start at each capital letter or digit, not at spaces, and hotkeys are always highlighted.
  - The selected choice is remembered between calls, as in the original.
  - Digits turn into direction codes using the original table, so a list can be moved with the cursor keys.
  - Mouse clicks are handled on the option row, the party list, the 3D view and lists.
  - INTUITICKS is switched on while it waits, and there's a prompt timeout.
- **Text window (`H030+$0302`):** word wrap that keeps punctuation with its word, a "Press any key to continue" page break when the window fills, and optional slow text.
- **List menu (`H008+$1AF4`):** header rows that are skipped, wrapping within the page, Next/Prev paging, Esc/E to leave, and select on the second click with the mouse.
- **ECL menus (`H064+$13AC/$1544`, `H061+$36E6`):** both read exactly the original's operands and store the original value. The vertical menu stores the 0-based row (or the current row on cancel); the horizontal one stores the hotkey's position, or `$FF`.
- **Creation menus:**
  - Pick Race/Gender/Class/God/Alignment now use the original layout: the title is a header row inside the list, items are indented by two spaces, the option is "Select" plus "Exit", and the original titles are used.
  - Add Character uses its own original layout.

**Still stubs or unverified in this area:**
- **Not yet ported:** palette cycling (`H042`) and the combat-map pointer and clicks (`H046`/`H048`). They're stubs marked with their original addresses.
- **Load Game list:** I haven't found its original call, so it still uses the creation layout.
- **Add Character's exit option:** the original passes an uninitialised value, so I pass 0.
- **Waiting loop:** it pauses one tick per empty poll instead of busy-polling, because the C's audio fallback needs that loop.

**Decision for the next step:** `H011` (about 7 KB) holds both the GEO/WALLDEF loaders *and* the 3D-view drawing that `view3d.c` claims to reconstruct. `view3d.c` uses a simplified model with one wall set, while the original has three slots, and the ECL handler loads into those slots. Fixing only the loaders would load data the C drawing code never reads. So for step 6 I'd port `H011` as a whole, loaders and 3D view, replacing that part of `view3d.c`.

Should I go ahead with the full `H011` port, or only the loaders and the ECL handler, leaving the C 3D view as it is for now?

The zip is in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- cok-fixes.zip

---

## 2026-11-10 14:19

I deleted `src_c/readable` and started the port again from scratch, by hand from the asm. So far 15 routines out of 902 are ported: the program starts, opens the libraries and stops at the first missing routine, `H005+$530A`, printing its address.

**What is in the new port:**
- **Start-up (`H000+$0000`):** the 99 module initialisations in the original order, then main.
- **Main (`H001`):**
  - the choice of the data prefix: `"df0:"` below 1800 blocks, otherwise `""`;
  - the prompt `"Champions of Krynn v1.0 "` with `"Play Demo"` (30 s wait, default key `D`);
  - the game/demo loop with the distribution check.
- **`H002`/`H003`:** the DOS (Lock, Info, UnLock) and memory adapters, with the conversion of DOSTRUE into 1 as in the original.
- **`H015`:** opening and closing of the libraries, and 32-bit multiplication and division. The signed division leaves the remainder positive, like the original.
- **Organisation:**
  - one file per hunk, and every ported function has the marker `PORT Hnnn+$XXXX`;
  - the routines not yet ported are in `unported.c`;
  - the global data have a name and, in the comment, their original offset.

**Tools:** `scripts/port_status.py` reads all the routines from the asm and the markers in the sources, and generates `PORT_STATUS.md` with the progress per hunk. The repository also has `scripts/hunkbytes.py` to read bytes and strings from the asm.

**Checks:**
- Compiles without warnings with gcc and clang (`-pedantic`).
- The `H015` test passes against the values computed by emulating the asm routines.
- The patch applies to the base commit `9561aac`.
- **I could not compile with SAS/C** because there is no Amiga compiler here; the Amiga code uses the standard NDK headers.

**Things changed outside `readable/`:**
- `registers.c`, `hunk_runtime.c` and `dos_exec.c` were used by the Ghidra reference build, not by the readable layer. I moved them to `src_c/reference_runtime/`, and `build_reference.sh` still works.
- I re-applied the fixes to `.gitignore` and to the runtime test.
- The old `CMakeLists.txt`/`CMakePresets.json` were inside `readable/` and were deleted with the rest. For now there are only `Makefile` (host) and `smakefile` (SAS/C).
- The main README of the repository still describes the old readable layer: I will update it when the port is further along.
- My previous patches (01–09) concerned the old `readable/` and no longer apply.

**Next step:** I continue in start-up order. Next comes `H005+$530A`, then `H004+$0C1A` (initialisation of 24 KB of data), then `H016`, `H017`, `H018` and so on, until the program reaches main.

The zip is in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- cok-port.zip

---

## 2026-11-10 14:47

The port has reached 125 routines out of 910. The program now runs the whole initialisation and the first routine of main, then stops at **H029+$1206**, the routine that opens screen and window.

**What I did (2 new commits on `asm-port`):**

1. **All 99 module inits are in C.**
   - The constant tables are generated from the asm and applied by a single `init_data.c`; the loops are written by hand.
   - I compared H004, H032, H011, H044, H057, H072, H085, H095 and H097 byte by byte with the asm emulator: 0 differences in all of them. The other inits, which are simple assignments, I checked by reading them.
   - H004 stays on its already verified generator, so its loops are not split up.

2. **H006+$01AE (Initialize_GameEnvironment)**, together with the leaf services it uses:
   - DOS Open/Close/Read/Seek/Execute adapters and intuition's CurrentTime;
   - case-insensitive string comparison of H026 (`$003A`, `$0088`, `$0106`);
   - byte fill H029+$0312, byte swap of a word H031+$0012, file existence check H028+$02D0;
   - the pointers that the original keeps in H005 (state blocks, ECL buffer, graphic records) have become C variables.

**Deviations from the asm, all documented in the comments:**
- The copies on the stack before a comparison or a Lock stop at the NUL, so as not to read past the C objects. The result does not change.
- On the host, Execute of the `Assign "Disk …:"` does nothing and returns success. Lock really checks whether the file exists and the file handles are a table of `FILE *`.

**Not verified:** I compiled nothing with SAS/C because the compiler is not here. The host build with gcc (`-Wall -Wextra -pedantic`) gives no warnings.

The zip contains the 3 patches starting from 9561aac, `src_c/readable` and the scripts.

**Decision for you:** from H029+$1206 on, the code calls graphics and intuition (screen, bitmap, blit, input). On the Amiga this is a direct link to the libraries, but the host needs a replacement. I suggest emulating at the level of the adapters (H016, H021, H024, H025): bitmaps in memory, saving the screen to a file, input from a script, no external dependency. The alternative is SDL2, with a real window and keyboard but one more dependency. Tell me which you prefer; if you say nothing I go ahead with the first.

---

## 2026-11-10 15:01

Here is **cok-port-2.zip**. I count the previous zip as version 1, so from now on the number grows by one with every delivery (`cok-port-3.zip`, …).

I added SDL2 for the host build. The game now opens the real screen. There are 159 routines out of 910 and the program stops at **H030+$0C10**, which loads `gothic.lbm`.

**How the host works:**
- In `src_c/readable/host/` there is a reduced copy of the AmigaOS structures: `ndk.h` uses the same names as the original (Screen, Window, BitMap, RastPort, View, ViewPort, ColorMap, RasInfo, Preferences, GfxBase). Next to it are the library functions with the same names (OpenScreen, OpenWindow, LoadRGB4, InitBitMap, AllocRaster, BltClear, InitView, GetColorMap, LoadView, OpenLibrary, FindTask, …).
- For this reason the game adapters are the same code on Amiga and on the host: only the library underneath changes.
- `host/display.c` converts the planar bitmap into pixels with the RGB4 palette and shows it in an SDL2 window. It shows the Intuition screen or, after `LoadView`, the custom View of the game.
- You can set three environment variables:
  - `COK_SCALE=n`: magnification of the window (3 if not set);
  - `COK_SCREENSHOT=f.bmp`: on exit, saves the last frame;
  - `SDL_VIDEODRIVER=dummy`: runs without a window.
- The build needs SDL2: `libsdl2-dev` on Debian/Ubuntu, `brew install sdl2` on macOS, MSYS2 on Windows.

**New routines (from the asm):**
- H029: opening of screen and window (`$1206`), initial palette (`$115C`), loading of `pointers.daa` (`$0234`, `$0180`), closing (`$12BC`).
- H029: allocation of the graphic records (`$0408`) and preparation of the off-screen View (`$1346`).
- H024 Open_GameScreen and H025 Open_GameWindow.
- The adapters H016, H018, H021, H022, H037, H051, H055 and H084.

**Deviations, documented in the comments:**
- The mouse pointers in `pointers.daa` end up in a separate C table. The original instead rewrites them as 32-bit addresses inside the buffer, and on the host they do not fit.
- The graphic record is a C struct with the same fields.
- On the host the Preferences give display offsets of 0.

**Current limits:**
- The game data files are not in this environment. When needed they go in the current directory, so from here I can only check up to the point where they are not read.
- I compiled nothing with SAS/C. The host build has no warnings and runs without a window; I checked the screenshot file but did not look at the picture.

The next block is the loading of the ILBM pictures: Open_ResourceFile (H028+$05FA), Read_ILBM (H040+$05E4) and the generic IFF parser of H086. If you tell me "proceed" I start again from there.

---

## 2026-11-10 15:07

I fixed the three problems of the SAS/C log. I cannot compile with SAS/C here, so you confirm: rerun `smake` on **cok-port-3.zip** and send me the new `.err` if anything else comes up.

**Fixes for SAS/C:**
- **Warning 63 (`GfxRecord` declared twice):** the structure is now in its own header, `gfx_record.h`, included by `globals.h`, `unported.h` and `h029_gfx.h`. There are no more forward declarations.
- **Warning 85 (`signed_byte` returns `int`):** the value is now computed in an `s16` variable. I also fixed an identical case in `h026_compare`, which would have come up later.
- **Error 61 (`GfxBase` undefined):** on the Amiga target `cok.h` now includes `graphics/gfxbase.h`, `graphics/view.h` and `intuition/preferences.h`.

smake stops at the first error, so there may be other problems in the files after `h029_gfx.c`. As a rough check I recompiled everything with gcc in strict C89, without warnings.

**Game files:**
- I extracted them into the work area.
- AmigaDOS does not tell upper and lower case apart, while the disk has names like `items` and `BODY1.DAA` and the game asks for `ITEMS`. On the host the file lookup now ignores case and drops the volume ("df0:", "Disk Two:").
- To point to the data folder there is the new variable `COK_DATA=dir`; if it is missing the current directory is used.
- With the real data the game gets as far as H030+$0C10 and stops there as expected. I did not check the loading of `pointers.daa` and `ITEMS` separately.

**Newly ported in this version:** Open_ResourceFile (H028+$05FA) with the H026 string routines it uses and the Retry/CANCEL requester.
- On the host the requester prints the text on stderr and waits for Enter/R (Retry) or Esc/C (Cancel) in the window.
- Without a window the program exits instead of repeating the request forever.
- The routine is there but is not run yet: it is called by H030+$0C10, which is not ported yet.

There are 170 routines out of 910. The next step is Read_ILBM (H040) with the IFF parser of H086, to load `gothic.lbm`. Now I can also compare the decoding with the real files.

---

## 2026-11-10 15:14

Here is **cok-port-4.zip**, with CMake for all platforms and the script that downloads SDL2 from NuGet for Visual Studio. Visual Studio is not here, so I have not tried the MSVC build: the tests are with gcc and MinGW, described below.

**Visual Studio 2022 (x86 and x64)**, from the `src_c/readable` folder:
```bat
windows\get-sdl2-nuget.cmd
cmake --preset vs2022-x64
cmake --build --preset vs2022-x64-release
```
For x86 the presets are `vs2022-x86` and `vs2022-x86-release`. You can also open the folder in VS (File > Open > Folder) and choose the preset from the list, or open the generated `.sln` in `build-vs2022-x64` or `build-vs2022-x86`.

- **NuGet script** (`windows/get-sdl2-nuget.ps1`, plus the `.cmd` for double-clicking):
  - Downloads `sdl2.nuget` and `sdl2.nuget.redist`, version 2.30.10, from nuget.org; another one is chosen with `-Version`.
  - `nuget.exe` is not needed.
  - Puts headers, `SDL2.lib` and `SDL2.dll` for Win32 and x64 in `third_party/sdl2-nuget`, which is excluded from git.
  - These two packages are community packages (kosmotema): they redistribute the official libraries from libsdl.org but are not published by the SDL project.
- **`CMakeLists.txt`**:
  - On Windows it first uses the downloaded SDL2, choosing the right architecture, and copies `SDL2.dll` next to `cok.exe`.
  - Otherwise it looks for the SDL2 CMake package (vcpkg, Homebrew, distributions), then pkg-config.
  - It also builds the `h015_test` test, which `ctest` runs.
- **Linux and macOS**: `cmake -S . -B build-cmake && cmake --build build-cmake`. The `Makefile` is still available.
- **SDL2main**: the display no longer uses it, so on Windows the game's `main` stays the entry point.

**What I checked here:**
- CMake build on Linux without warnings; `ctest` passes and with your data the game gets as far as H030+$0C10.
- Cross-compilation with MinGW for Windows x64 and x86 (`-Wall -Wextra -pedantic`), with SDL2 taken from the NuGet packages themselves and the same layout as the script: both produce `cok.exe` and copy `SDL2.dll`, without warnings.
- I could not run the PowerShell script. I checked the layout of the packages it uses by downloading them.

**Port:** the point is the same as before (170 routines). I have already analysed the picture reading chain: it is Electronic Arts' IFF85 reader compiled into the game. To be ported:
- H086: parser of groups and chunks;
- H098: buffered I/O;
- H087: BMHD, CMAP and BODY;
- H040: the FORM, PROP and LIST callbacks.

In the port the data read from the file (IDs, sizes, BMHD header) must be converted from big-endian, so that they also work on x86 and x64. At the next "proceed" I start again from here; if the VS2022 build gives errors, send me the log.

---

## 2026-11-10 15:38

I stop here: the environment initialisation (H006+$01AE) is complete and the program reaches the intro, H007+$09D8. The ported routines go from 170 to 230 out of 912, and each step is a commit. The intro needs keyboard and mouse input, waits and audio, so it is a block of its own.

**What I ported, always from the asm:**
- **IFF/ILBM reader** by Electronic Arts compiled into the game: buffered I/O (H098), parser of groups and chunks (H086, H039), BMHD/CMAP/BODY with ByteRun1 (H087, H088, H054, H099) and Read_ILBM with its callbacks (H040). The `gothic.lbm` font loads.
- **On-screen text**: UI_DrawText and the drawing of text with the blitter (H049). The original writes directly into the `$DFF000` registers, and the C does the same: on the Amiga it goes to the hardware, on the host to a small blitter emulator (`host/blitter.c`). The message "LOADING...PLEASE WAIT" appears in the gothic font; I checked it on a screenshot.
- **Graphic resources**:
  - reading of the DAX containers with RLE and byte reversal for the `.dax` (H028);
  - graphic records: loading, freeing, planes, masks, recolouring (H029);
  - 8x8 sets (H034), pairs of 24x24 sprites (H035), border (H006+$00FA);
  - BltBitMap, FreeRaster, RectFill and pens, with the emulation for the host.
- **Handler tables** in H005 ($25C0 and $2832): they are now C arrays of function pointers. For now the 175 routines they point to are stubs that stop with their address if they are called.

**Checks with the game files:**
- ILBM pictures: all 7 `.lbm` are identical, byte for byte, to an independent Python decoder (`scripts/check_ilbm.py`).
- DAX containers: all 526 blocks are identical to the reference reader (`scripts/check_dax.py`). At first the reference was too simple and I rewrote it following the rules of the asm, for example the $FF control "repeat the previous type". So it is not fully independent of the port.
- With `-DCOK_TEST_DATA=<data folder>`, `ctest` also runs the ILBM tests: 8 tests out of 8 pass.
- Linux build and Windows x64/x86 cross-build with MinGW without warnings. I do not have SAS/C and Visual Studio here: if errors come up, send me the logs.

**Problems found and fixed:**
- On the host, absolute paths were treated as relative to the data folder; now they are recognised, including Windows drive letters.
- The original reads and writes one byte past the AllocMem buffers; on the Amiga it falls into the rounding margin, in C it would be an out-of-bounds access. In the port these accesses stay inside the buffers, and the comment in the code says so.

**Good to know:**
- In 33 blocks (`SPRIT*.DAA`, `pic*.daa`, `pointers.daa`) the decompression would overrun the buffer, that is the original would give the error "uncompress overuns buffer". `pointers.daa` is not a DAX container: H029+$0234 loads it as a raw file. For the others I assume they go through another loader, but I have not checked it yet.
- In H029+$0A0E the original writes two different words into the same field `+$04` of the record; the port does the same.
- The 8x8 sets have 4 planes, the other records 5 planes plus a 32-colour palette.

**Next block: the intro (H007+$09D8).**
- Input is needed: the IDCMP events, that is keys and mouse. On the host I would deliver them from SDL2.
- Waits are needed: Delay (H036) and the key check (H010+$042E).
- The audio of H043 is needed, which on the host would go to SDL2 audio.
- Then the loading of the intro pictures (H007+$04F2) and the mouse pointer (SetPointer).

I would build on `host/` as for the graphics: the same NDK functions, implemented with SDL2.

I will prepare the numbered zip as soon as you ask me (it will be `cok-port-5.zip`). Otherwise, with "proceed", I start on the intro.

---

## 2026-11-10 15:53

The intro now runs from start to finish in the host build, except for the audio. The program then reaches the "Play / Demo" prompt (H008+$01FC), where it stops because that routine is not ported yet. I sent you **cok-port-5.zip** (the previous state), **cok-port-6.zip** (with the intro) and `intro-host.png` with six frames captured from the host build. 258 routines out of 913 are ported.

**What you see:** the SSI logo, the picture of the moon with the rose, the title "Champions of Krynn", "Dragonlance" and the credits page with the frame of 8x8 tiles, then the loop starts again. The pictures appear with the fades and a key or a click interrupts the intro.

**What I ported, from the asm:**
- **Intro (H007):**
  - loading of the pictures with fade-in and fade-out (16 steps, one per frame);
  - wait of N seconds that a key can interrupt;
  - clearing of the screen and credits page (26 texts extracted from the asm);
  - the mouse pointer is hidden and then restored.
- **Input (H010):**
  - reading of the window events: keys and mouse buttons;
  - conversion of the Amiga keyboard codes into characters, with the table decoded from the unclassified bytes. Arrows and keypad become the direction digits;
  - special keys Shift, Ctrl and Alt (Alt+a/m/q/x give 1..4);
  - left button = Enter, right = Esc;
  - wait for a key (H010+$0974).
- **Graphics:**
  - 8x8 tiles (H034+$0178, H049+$012A);
  - frame of the screen and of the credits (H044);
  - clearing of text areas (H030+$0B6C);
  - game palette (H011+$010C);
  - release of the pictures (H042+$0300).
- **Adapters:** GetMsg, ReplyMsg, WaitPort, Delay, WaitTOF, SetPointer, AvailMem.

**On the host (SDL2):**
- Keyboard and mouse become messages like the ones Intuition would give the game, with the Amiga keyboard codes.
- Delay and WaitTOF set the speed at 50 and 60 Hz.
- The system cursor is hidden when the game sets an empty pointer.
- `COK_SCREENSHOT_AT=t1,t2,...` (together with `COK_SCREENSHOT=base`) saves frames at the given milliseconds; that is how I took the ones I sent you.

**Good to know:**
- **Audio not ported.** H043 is a module of about 1,800 lines and the two music commands of the intro (H043+$0584, H043+$190E) are skipped with a warning on stderr instead of stopping the program. It is the only case where a missing routine does not block the game; it is also written in the README.
- **Alt+C** (shows the free memory, H010+$03AA) is not ported yet and stops the program if you press it.
- **Interruption with a key:** I could not try it here because the build runs without a window. I checked the logic on the asm.
- **Build:** Linux without warnings; Windows x64 and x86 cross-build with MinGW without warnings; `ctest` 8 out of 8. I do not have SAS/C and Visual Studio here, so send me the logs if errors come up.

At the next "proceed" I go on with the "Play / Demo" prompt (H008+$01FC) and then with the main menu. I will port the audio separately (H043 plus an emulator of the audio chip on SDL2); tell me if you prefer to do it first.

---

## 2026-11-10 16:01

The Play/Demo prompt works: after the intro "CHAMPIONS OF KRYNN V1.0" appears with "PLAY" and "DEMO" at the bottom of the screen and responds to keyboard, mouse and timeout. I sent you **cok-port-7.zip** and the screenshot of the prompt taken from the host build. 267 routines out of 913 are ported.

**Behaviour verified on the host build:**

| Input | Result |
|---|---|
| no key for 30 seconds | chooses Demo, like the original, and the game reaches H011+$04A6 |
| P | chooses Play and the game reaches H009+$010C, the copy check |
| Esc during the intro, then right arrow and Enter | the intro is interrupted, "DEMO" turns inverse and is chosen |

I checked the screenshots: title in magenta, selected item in inverse, initial in white, rest in green.

**UI_RequestChoice (H008+$01FC):** the prompt uses the general choice engine of the game, which will also be needed for all the menus, so I ported it whole:
- split of the options into items, one for each capital initial or digit;
- drawing of row 24;
- keys: letters, Enter, Esc, '4'/'6' to scroll, the digits, Alt+a/m/q/x;
- click on the options row and on the game areas;
- pointer shape, animation of the pictures, timeout.

The sub-procedures of the original read the variables of the calling procedure through its frame; in the C these variables are a structure passed by pointer.

**Bug fixed:** in the C written at the start, H001 called the prompt with the arguments in reverse order. Now the order is the one of the asm.

**Also ported:** the change of the pointer shape (H029+$01B6), the drawing of a series of characters (H030+$00B6), the time in hundredths of a second (H030+$0A40), H029+$03E2 and ModifyIDCMP.

**On the host:**
- The window keeps the mouse position, like MouseX/MouseY on the Amiga.
- The game checks the input in a continuous loop; the host has a 1 ms pause when no events arrive, so it does not take all the CPU.
- New `COK_KEYS="ms=Key,..."` to simulate timed keys in the tests without a window, for example `COK_KEYS=1500=Escape,5000=P`.
- The mouse pointer stays the system cursor: the game sprite is not drawn.

**Known limits:**
- The branches needed only in combat, on the map or with the party are ported, but call routines that are still missing (H046+$0012, H048+$0AA8, H042+$0B80/$0254, the character structure). If they are reached, the program stops saying which one is missing. From the prompt they are not reached.
- Two points where the original has undefined behaviour, now made defined and noted in the comments:
  - click on the title: the original returns a value from the stack that was never written, the C returns 0;
  - a letter that is not the start of any item: the original searches for it without limit, the C stops at 20 items.
- Build: Linux, Windows x64 and x86 cross-build and C89 check without warnings; `ctest` 8 out of 8. I do not have SAS/C and Visual Studio here: if errors come up send me the logs.

**Next step, your choice:**
1. **Play**: the copy check (H009+$010C) and then the main menu (H013+$4BFC: party creation, loading of saved games).
2. **Demo**: H011+$04A6 and the demo loop (H012+$3150).

At the next "proceed" I go with Play, unless told otherwise.

---

## 2026-11-10 16:08

With "Play" the game now passes the manual check and reaches the threshold of the main menu (H013+$4BFC), where it stops because the menu is not ported yet. I sent you **cok-port-8.zip** and the screenshot of the check; 273 routines out of 913 are ported.

**The manual check (H009+$010C):**
- It is the copy protection: it asks for a word from a page of the manual ("the best quartex" or "tavern tale", chosen at random).
- It reads it with the text input, which accepts characters from space to 'z', backspace and Enter/Esc and is shown in yellow after "Enter".
- The executable in your data is an **already cracked version**: the text says "broken by the best quartex" and the jumps after the comparison of the answer have been replaced by `nop`. So any word is accepted, and the port does the same.
- The routine still computes the $3F8F checksum that main verifies.
- Test with simulated keys: the question appears inside the frame of the three moons ("of tavern tale # 41, type any word, page 47"); after "WORD" and Enter the game goes on.

**Ported in this step:**
- table of the 50 questions with the encoded answers (H049+$079E) and decoding of the answer (H009+$007E);
- random generator of the game (H023+$0010);
- string insertion (H026+$0254);
- input of a line of text (H030+$0718);
- the screen frame (H044+$01C2), now usable by other modules too.

Linux, Windows x64/x86 (MinGW) build and C89 check without warnings.

**Next block: the main menu.** The items are "Create New Character", "Add Character to Party", "Load Saved Game", "BEGIN Adventuring", "Exit to Workbench" and the others; each one is enabled or disabled according to the party. To show it the list menu engine of H008 (from $13C0 to $2178) is needed, which the game uses for all the lists:
- drawing of the items, enabled in one colour and disabled in another;
- scrolling by pages with "Next" and "Prev";
- selection with the arrows and with the mouse;
- Yes/No question ($203C);
- creation and freeing of the lists ($20C2/$2178).

With the empty party at start-up only "Create New Character", "Load Saved Game" and "Exit to Workbench" are enabled. So the first screen of the menu needs only the engine and the frame, not the party box (H063). The single functions stay stubs until I port them: first the character creation (H013+$0982), then the loading of the saved games.

At the next "proceed" I start from the menu engine.

---

## 2026-11-10 16:21

The main menu works, and "Exit to Workbench" now closes the game cleanly. I sent you **cok-port-9.zip** and the screenshot of the menu taken from the host build. 298 routines out of 913 are ported.

**What you see:** after Play and the manual check "CHOOSE A FUNCTION Select" appears. With the empty party there are only "Create New Character", "Add Character to Party", "Load Saved Game" and "Exit to Workbench", like in the original.

**Tried with simulated keys:**
- the arrows move the selection, and from the first item the up arrow jumps to the last;
- on "Exit to Workbench", Enter asks "QUIT TO WORKBENCH Yes No" with "No" preselected;
- Y frees all the resources and the program ends with code 0;
- Enter on "Create New Character" leads to the character creation (H013+$0982), which is not ported yet and so stops the program.

**Ported from the asm:**
- **Main menu (H013+$4BFC):**
  - 12 items, enabled according to the party and the current character;
  - function chosen according to the initial letter of the item;
  - the hidden 'J' cheat: turns "Free training" on or off if the third command-line argument is the word at H005+$2358. For this `main` now keeps argc/argv.
- **List menu engine of H008**, used by all the lists of the game: non-selectable header rows, pages with "Next"/"Prev", arrows and keypad, click to select and double click to choose, "Exit" option. Plus the Yes/No question and the creation and freeing of the lists.
- **Exit (H010+$0332 and $00C4):** frees the resources and the off-screen View, closes screen and window, removes the Assigns if the game is installed on a hard disk, then closes the runtime.

**Bugs found with AddressSanitizer and fixed:**
- DAX decompression: in some blocks the last sequence to copy declares more bytes than are present, and the original reads them past the buffer. Now only the bytes present are copied and the rest stays zero.
- The host `SetPointer` read the final part of the pointer sprite, past the 8 bytes allocated by the intro.
- Up arrow from the first item: the original reads from a null pointer (the byte at address $2A, in the CPU vector table, normally non-zero) and so jumps to the last item. In the C a null node counts as a header row, with the same effect.

After these fixes the complete intro and the session up to the exit run without errors under ASan/UBSan.

**Not verified and limits:**
- The audio is still skipped with a warning.
- The menu functions not yet ported stop the program saying which one is missing: creation, adding and removing characters, loading and saving, BEGIN.
- Linux and Windows x64/x86 (MinGW) build and C89 check without warnings; `ctest` 8 out of 8. I do not have SAS/C and Visual Studio here.

**Next step, your choice:**
1. **Create New Character (H013+$0982):** race, sex, class, alignment, roll of the scores, name, portrait. It is the natural path from a new game and needs the character structure (+$18E for the next one, etc.).
2. **Load Saved Game (H066+$291E):** if you have saves to use, it leads to the adventure faster.

With the next "proceed" I start from Create New Character.

---

## 2026-11-10 16:43

I ported Create New Character and I am sending you **cok-port-10.zip**. On the host it works from the main menu up to the alignment, then it stops: after the alignment the game computes the age and calls the character screen (H065+$04B8), which is not ported yet.

**What already works:**
- The five menus, like in the original:
  - **Race:** sets the race effects.
  - **Sex.**
  - **Class:** shows only the classes allowed by the race and sets the initial levels and experience.
  - **Deity:** appears only if the character has cleric levels.
  - **Alignment:** shows only those allowed by class and deity. For example, with Paladine Lawful, Neutral and Chaotic Good appear.
- Esc in a menu frees the character and goes back to the main menu.
- All the computation that comes after is also written, but while the screen and the other routines below are missing I cannot try it:
  - age;
  - ability scores: the best of 6 rolls of 3d6+1, with the limits of age, race, sex and class;
  - hit points, money, name and request to save;
  - saving throws, thief skills and cleric spells.

**Character structure:** the new `character.h` holds the $1AA bytes of the record with the original offsets. The pointers are separate fields, because on the host they take 8 bytes instead of 4:
- `+$E8` effects;
- `+$150` items;
- `+$154..+$184` items ready for use;
- `+$18E` next character;
- `+$192` block of $18 bytes.

**Where I followed the asm even though it looks like a bug (it is written in the comments):**
- **Race adjustments to the ability scores:** they are never applied. The code uses the counter of the race menu, which at that point is always 7.
- **Constitution bonus to the first saving throw (H073+$0BA8):** it is added once for each of the 8 classes.
- **Two values the original does not initialise:** the bonus of the thief skills and the deity mask for an unexpected value. The original uses whatever is left on the stack; here they start from 0. These are the only two points where the C deviates from the asm.

**Checks:**
- The Linux build, the MinGW x64/x86 builds and the C89 check give no warnings.
- ctest passes 8 tests out of 8.
- I did three different paths through the menus plus the cancel with Esc under ASan/UBSan, without errors.
- The zip rebuilds on its own.
- I did not compile with SAS/C. If it gives errors send me the `smake.err`.

**What is missing to finish the creation, in order:**
1. **H065+$04B8:** the character screen, with $0ADE, $0BF4, $10DE and the dependencies in H063 and H044. It is also needed by View Character.
2. **H013+$58DC:** the training, which during the creation runs with the $24CF flag.
3. **H028+$0D36 and H047+$00E6:** the routines called after the name. H047+$00E6 should be the choice of the figure.
4. **H066+$1640:** the saving of the character to disk.

If you want I proceed with the character screen.

---

## 2026-11-10 16:51

I ported the character screen and I am sending you **cok-port-11.zip**. In Create New Character, after the alignment, the sheet and the values of the rolled ability scores now appear. Then the program stops at **H013+$58DC**, the training screen, which is not ported yet. We are at 335 routines ported out of 914.

**What the sheet shows (H065+$04B8):**
- **Header:** name, status, sex, age, alignment, race.
- **Class:** with the deity for clerics, the knightly order and the title "of the Crown/Sword/Rose".
- **Main values:** levels per class and experience.
- **Ability scores:** STR/INT/WIS/DEX/CON/CHA, with the percentage of strength 18 and a `*` when the current value differs from the maximum.
- **Money.**
- **Combat:** hit points, armour class, encumbrance, THAC0, movement and damage in the "NdM+K" format.
- **Ready items in slots 0 and 2.**

In the screenshot (Qualinesti Elf, cleric of Paladine) hit points, movement and damage are still 0. This is correct in the original too: the sheet is drawn before the rolls, and those values are computed afterwards.

**New routines from the asm:**
- **H065:** $04B8, $0ADE, $0BE6 with the nested procedure $0BF4, and $10DE.
- **H044+$068E:** the frame of the sheet.
- **H063+$13BE:** the recomputation of the derived values, which the whole game needs. It uses the routines for the ready item slots, strength and dexterity bonuses, weapon, armour, armour class, encumbrance and movement ($016A, $0228, $0354, $0432, $06AE, $0758, $08A2, $18F8, $19B6, $1A8A).
- **H063, others:** leading spaces ($0112), search for an effect ($0946), item names with plurals and quantities ($09B2), AC ($0FA0), hit points ($103A), character name ($1F34).
- **`character.h`:** the items ready for use are now an array of 13 pointers from `+$154` to `+$184`.

**Where I followed the asm even though it looks like a bug (it is in the comments):**
- In H063+$13BE there is a flag that is always 0, so the "-5000 encumbrance" branch is never run.
- In H063+$0228, with strength above 25 the original returns an uninitialised value; here 0.

**Checks:** the Linux build and the MinGW x64/x86 ones give no warnings, the C89 check is clean and ctest passes 8 tests out of 8. I did three creation paths under ASan/UBSan without errors. I did not compile with SAS/C: if it gives errors send me the `smake.err`.

**Next step:** H013+$58DC, the training (about 670 instructions). It is the same routine as the "Train Character" item of the main menu; in the creation it runs with the $24CF flag. After that H028+$0D36, H047+$00E6 and the save H066+$1640 remain. If you want I proceed with the training.

---

## 2026-11-10 17:01

I fixed the SAS/C error: I am sending you **cok-port-12.zip**, but I could not compile it with SAS/C.

**Cause:** on the Amiga `intuition/intuition.h` already declares `struct MenuItem`, that is the items of the Intuition menus. The port type in `h008.h` had the same name, so SAS/C gave "Error 63: already declared".

**Fix:** I renamed the type to `CokMenuItem` in `h008.h`, `h008.c` and `h013.c`, the only three files that used it. The behaviour does not change.

I checked the names of the other structs of the port against the NDK structures present in the repository, and only `BitMapHeader` matches. It is declared by datatypes (`pictureclass.h`), which the port does not include, so today it gives no errors.

The host builds and the C89 check give no warnings and ctest passes 8 tests out of 8. If SAS/C stops on another file, send me the new `smake.err`.

If the Amiga build passes, the next step is still the training (H013+$58DC).

---

## 2026-11-10 18:28

I ported the training: I am sending you **cok-port-13.zip**. Create New Character now gets as far as the question "Reroll stats?" and the request for the name. After the name the program stops at **H028+$0D36**, not yet ported. We are at 342 routines ported out of 915.

**Training (H013+$58DC):**
- **From the main menu (item T):** checks that the character is conscious and has enough experience according to the table H005+$1946. It also checks that the class can be trained there (mask +$550 of state B). Then it shows "X will become: a level N …", asks "Do you wish to train?" and raises the levels.
- **Inside the creation:** it runs without messages or questions and is repeated until no class can go up any more. Then it assigns the initial mage spells and rolls the hit points.
- **Examples:**
  - A fighter with 2001 initial XP starts at level 2, with 23 HP (screenshot).
  - A cleric of Paladine with 2000 XP stays at level 1, because for him level 2 requires 4000 XP.

**Other new routines:**
- **H073+$05AE:** recomputes the values tied to the level (base THAC0, maximum level, saving throws, thief skills, items that can no longer be kept ready).
- **H073+$0012:** slots and known spells for all classes.
- **Support functions:** H063+$3F72 (row of the experience table), H029+$039A and H030+$0AD2/$0B4A (timed message on row 24).

**What stays a stub:** H065+$34FC, the interactive choice of a new mage spell when going up a level. It is used only from the "Train" item of the menu, not in the creation.

**Where I followed the asm even though it looks like a bug (it is in the comments):**
- In the second loop of the training the table row and the level are the ones left over from the last class of the previous loop.
- H063+$3F72 returns an uninitialised value for classes 1 and 3; here 0.

**Checks:**
- The Linux build, the MinGW x64/x86 builds and the C89 check give no warnings; ctest passes 8 tests out of 8.
- I did three creations under ASan/UBSan without errors: fighter, cleric and mage with a reroll.
- I did not compile with SAS/C. If it gives errors send me the `smake.err`.

To complete the creation these are missing:
1. **H028+$0D36:** called right after the name. It is only 17 instructions long, but it calls bigger ones.
2. **H047+$00E6:** the choice of the character's figure.
3. **H066+$1640:** the saving to disk.

If you want I proceed with these three, in this order.

---

## 2026-11-10 18:37

I ported H028+$0D36 and I am sending you **cok-port-14.zip**. Create New Character now goes past the name and stops at **H047+$00E6**, not yet ported. We are at 347 routines ported out of 916.

**What H028+$0D36 does:** it loads, only once, checking the flag -$F9, the two pictures of the character screens, `charS.LBM` and `charT.LBM`.

**New routines from the asm:**
- **H028+$0C68:** for each file it creates a new BitMap and reads the picture with Read_ILBM.
  - Copies the 32 colours into H005+$522E.
  - Puts colour 0 into H005+$523E and then clears colour 0.
  - On the host the reader's colours are native words, so I write them into H005 in big-endian. It is the same result as the 64-byte CopyMem on the Amiga.
- **H041+$000C, $004A, $00BE:** the allocator that saves the size in the long before the block, and the matching free.
  - Removes the stub that the freeing of the two screens used (H028+$0D74).

**Check of the loading (with gdb, at the point where the program stops):**
- Both bitmaps are 320×200 with 5 planes, as in the BMHD of the file.
- H005+$522E holds the charT palette with colour 0 set to black.
- H005+$523E holds `0x555`, that is the original colour 0 of charT.

**Other checks:**
- The Linux build, the MinGW x64/x86 builds and the C89 check give no warnings.
- I had to change `dax_test`, because `h028_files.c` now uses the ILBM reader: it also compiles `h041.c` and has a stub of the reader. With this change ctest passes 8 tests out of 8.
- I did a complete creation up to the name under ASan/UBSan, without errors.
- I did not compile with SAS/C. If it gives errors send me the `smake.err`.

The next step is **H047+$00E6**, the choice of the character's figure. It is a trampoline to $08D6, about 440 instructions, which uses the H035 sprites and the screens just loaded. If you want I proceed with that.

---

## 2026-11-10 18:44

Your log shows that the SAS/C build links (`SLINK Complete`). I fixed the warnings it reported and I am sending you **cok-port-15.zip**. I did not recompile it with SAS/C.

- **Warning 217** ("macro invocation may call function multiple times", in h007, h013 and h063): `COK_PUT16` and `COK_PUT32` evaluated the value twice. When the value was a call, for example `max_age(...)` or `str_damage_bonus(c)`, the function was called twice. Now the macros put arguments and pointer into temporary variables, so they evaluate everything only once.
- **Warning 84** (`SELECTED`): `intuition/iobsolete.h` already defines `SELECTED` as a gadget flag. In `h008.c` the port macro is now called `CHOICE_SELECTED`.
- **Warning 63** (`struct Character` already declared): `globals.h` now includes `character.h` instead of declaring the struct again.

No change alters the behaviour. The Linux build, the MinGW x64/x86 builds and the C89 check give no warnings and ctest passes 8 tests out of 8. A creation redone with the normal build gets as far as H047+$00E6 as before.

If SAS/C still gives warnings send me the new `smake.err`. The next step is the choice of the character's figure, **H047+$00E6**.

---

## 2026-11-10 19:01

I ported the icon editor (H047+$00E6) and I am sending you **cok-port-16.zip**. Create New Character now gets all the way to the end: name, icon, "Is this icon ok?" and "Save TAS?". Answering No the game goes back to the main menu. Answering Yes it stops, because the saving (**H066+$1640**) is still a stub. We are at 363 routines ported out of 916.

**Icon editor (H047+$00E6, body at $08D6):** it is a six-state machine, each with its own menu.
1. Parts / 1st-color / 2nd-color / Size / Exit (or Body / Size / Exit for whole icons).
2. Head / Weapon.
3. Choice of the part to colour: in that menu the item "xxxx" becomes Hair or Face.
4. Size.
5. Next / Prev / Keep for the colour.
6. 7×N grid of the heads or bodies, chosen with arrows, keypad or mouse.

It shows the pair of "old" and "new" poses (ready/action). Exit from the first menu confirms the changes, then "Is this icon ok?" is asked.

**Other new routines:**
- **H066+$0C34:** composes the 24×24 icon by cutting head and body out of charS/charT and recolours it with the character's colour pairs (+$146). It uses the procedures $0BAC, $0C42, $0D2A and $0DEA.
- **H035+$01DC / $0460:** free and draw a 24×24 set through the mask.
- **H029+$10B8:** fills a rectangle of 8×8 cells.
- **H016+$00A0:** wrapper of BltMaskBitMapRastPort, with the emulation on the host. On the host it copies the source where the mask is 1, that is the effect of the $E0 minterm used by the game.

**Still stubs:** H049+$04AE and $09D6, used only for drawing in combat and with scale > 3.

**Deviation from the original (it is in the comments):** in the editor a state variable (-$24) is not initialised before the first menu; here it starts from 0.

**Checks on the host:**
- **Editor functions:** the grid shows the 13 heads with the selection highlighted. Right arrow + Enter changes the head. Next changes the hair colour (red → magenta → brown). Size and the return to the menus with Esc work.
- **ASan/UBSan:** a complete path from the creation to the editor and back to the main menu, without errors.
- **Build:** Linux, MinGW x64/x86 and the C89 check give no warnings; ctest passes 8 tests out of 8.
- **SAS/C:** I did not compile it. If it gives errors send me the `smake.err`.

The last piece of the creation is **H066+$1640, Save_CharacterRecord**: about 480 instructions, with the writing of the record to disk and the related files. If you want I proceed with that.

---

## 2026-11-10 19:15

I ported the saving of the character (H066+$1640) and I am sending you **cok-port-17.zip**: Create New Character now gets all the way to the end and writes the character to disk. We are at 377 routines ported out of 916. I did not compile it with SAS/C: if it gives errors send me the `smake.err`.

**What it writes (in the save directory H005+$3CD4):**
- `name.who` with the $1AA-byte record (or `name.sav` if a file name is passed);
- `name.swg` with the items, $48 bytes each, only if the character has any;
- `name.fx` with the effects, $0A bytes each.

The file name comes from the character's name: the characters ` .*,?/#:;|` are removed and at most 8 characters are kept.

**Checks before writing:**
- **Save directory:** if the disk or the directory is missing, the game asks to insert the disk or creates the directory.
- **Free space:** if it is not enough, it shows "Can't save. No room on this disk." and asks "Lose character? / Ok, try another disk".
- **Write test:** creates and deletes a test file (`testfilename`).
- **File already existing:** asks "Overwrite NAME?". Answering No it asks for a new name, which also becomes the character's name, as in the original.

**Checks:**
- **Elf fighter:** produces a 426-byte `TAS.who` with the same structure as `L.who` of the original data. Its `.fx` is identical byte for byte to `L.fx`.
- **Knight:** produces a 216-byte `KNT.swg`. It contains the same three initial items (Plate Mail, Shield, Long Sword), in the same order and with the same weights, as the original `CHRDATA1.swg`.
- **Overwrite:** with Yes it rewrites the files; with No and the name "BOB" it creates `BOB.who`, with the character renamed BOB.
- **Build and tests:** the Linux build, the MinGW x64/x86 builds and the C89 check give no warnings and ctest passes 8 tests out of 8. The path with the new name was redone under ASan/UBSan without errors.

**Differences from the original (they are in the comments):**
- The pointer fields of the record and of the nodes (+$E8, +$150…, the "next" links) are written as 0. The original wrote the memory addresses there, which the loading does not use.
- After the new name, the original checks the existence again on a buffer that by then contains the question "Overwrite …": I kept it that way.
- In H028+$033E the original reads the volume name after freeing the block that contains it; here I copy it before freeing it.

**Other new routines:**
- H028+$033E, $07E0, $08F0: volume name, removal of characters, file name.
- H030+$028A: message that stays until a key is pressed.
- DOS wrappers CreateDir, DeleteFile and Examine, with the host versions.

**Changes to the host:**
- Lock now also finds directories, on Windows too.
- Info reports the free blocks.

The natural step is **Add Character to Party** (H013+$0518 → $52E0), which loads a saved character with Load_CharacterRecord (H066+$1B0E): it lets you read back the files just written.

---

## 2026-11-10 19:23

I ported Add Character to Party and I am sending you **cok-port-18.zip**. The main menu now loads the saved characters and shows them in the party, with name, AC and HP. We are at 386 routines ported out of 916.

**What it does:**
- Shows the list of saved characters ("Add a character:"): the $1AA-byte `.WHO` files in the save directory, except those already in the party.
- The chosen character is loaded and marked with `* `.
- It is added only if it respects the rules of the game. If it does not, the mark is removed and the message appears:
  - it must not already be in the party;
  - at most 6 player characters and 8 members in all;
  - no paladin in a party with evil members ("paladins do not join with evil scum");
  - at most 3 rangers ("too many rangers in party");
  - no evil character with a paladin ("<name> will tolerate no evil!").
- It goes on until you leave with Esc/Exit or the party is full.

**New routines from the asm:**
- **H013+$52E0:** Add_CharacterToParty.
- **H066+$1B0E (Load_CharacterRecord):** reads the record, then the items from `.swg` and the effects from `.fx`, and recomputes the derived values.
- **H066+$03D0/$03DE:** list of the saved characters.
- **H066+$0852:** opening of the file without the disk swap.
- **H066+$27EE:** append to the party, with the first free icon slot.
- **H063+$0D80:** list of the party in the main menu, together with the clickable area.
- **H063+$1D44:** timed message on row 24; it replaces the stub used by the training.

**Host:** the locks now remember the path, and Examine/ExNext really scan the directories (dirent; `_findfirst` on Windows, compiled with MinGW but not tried on Windows).

**Where I followed the asm even though it looks like a bug (it is in the comments):**
- For a rejected character only the record is freed: items and effects already loaded stay allocated.
- Two variables are not initialised before the first choice in the original: the "with_exit" flag of the menu and the member counter. Here they start from 0.
- The string "from saved game …" is composed but never used.

**Checks:**
- The list shows L (character of the original data), BOB, TAS and KNT. Adding them, the main menu shows the party with AC and HP and enables Drop/Modify/View/Remove/Save/Begin.
- The run with all four was also done under ASan/UBSan, without errors.
- I did not try the party restrictions (paladins, rangers, evil alignments): all four characters were accepted, so no rejection message appeared.
- The Linux build, the MinGW x64/x86 builds and the C89 check give no warnings and ctest passes 8 tests out of 8.
- I did not compile with SAS/C: if it gives errors send me the `smake.err`.

With a party, the menu items still to be ported are View Character (H065+$3702/$196E), Drop, Modify, Remove, Save Current Game and BEGIN Adventuring. Tell me which one to continue with.

---

## 2026-11-10 19:24

This `smake.err` is identical byte for byte to the one you sent me before version 15, so it comes from a build of the old sources. It does not concern cok-port-18.

You can see it from the content:

- **Warning 84** cites `#define SELECTED` at line 138 of `h008.c`. Since version 15 that line is `#define CHOICE_SELECTED`.
- **Warning 63** cites `struct Character;` at line 73 of `globals.h`. Since 15 there is `#include "character.h"` there.
- **Warning 217** comes from the old `COK_PUT16`, which evaluated the argument twice. Now it uses the temporary variables `cok_w_`/`cok_p_`.
- **Program size:** the link reports 164076 bytes of code, as back then. With the routines added in 16, 17 and 18 (icon editor, saving, loading, party) it should be bigger.

You probably compiled in a directory with a previous version, or `smake` did not recompile because the `.o` files were newer than the sources.

For a clean build of 18, extract **cok-port-18.zip** into a new directory, or delete the old `.o` files:

```bash
cd cok-port/src_c/readable
```

```bash
delete #?.o cok
```

```bash
smake
```

Then send me the new `smake.err`. If it compiles, tell me which menu item to continue with: View Character, Drop, Modify, Remove, Save Current Game or BEGIN Adventuring.

---

## 2026-11-10 19:27

I fixed the only warning left in the log and I am sending you **cok-port-19.zip**.

This log comes from the new version. The warnings fixed in 15 (SELECTED, PUT macros, `struct Character`) are no longer there, and the program has grown from 164076 to 178684 bytes of code.

The warning was **63** in `unported.h`: at line 219 there was `struct GfxRecord;`, but the struct is already defined in `gfx_record.h`. I removed the declaration and `unported.h` now includes `gfx_record.h` directly. The behaviour does not change.

The Linux build, the MinGW x64/x86 builds and the C89 check give no warnings and ctest passes 8 tests out of 8. I did not recompile with SAS/C: if the new `smake.err` shows anything else, send it to me.

Tell me which item of the party menu to continue with: View Character, Drop, Modify, Remove, Save Current Game or BEGIN Adventuring.

---

## 2026-11-10 19:33

I ported View Character and I am sending you **cok-port-20.zip**: from the party menu you choose a character, see their sheet and go back to the menu. The functions of the submenu (Items, Trade, Drop) are not ported yet: choosing them stops the program. We are at 392 routines ported out of 916.

**How it works:**
1. From the main menu you choose View Character.
2. "Pick Character" (H065+$3702) appears, where you choose the character. The special keys move to the previous or next member of the party, wrapping from the first to the last; a click on a name directly chooses that character.
3. The character sheet opens with a menu (H065+$196E) that contains only the items available for that character:
   - Items, if they have items;
   - Spells, if they have memorised spells;
   - Trade and Drop, if they have money;
   - Heal and Cure, which however never appear in the original, because the two check functions ($36A6/$36C0) always return 0;
   - Exit.
4. On exit the screen is redrawn according to the game mode (H063+$321A). In the party menu it is the frame; the other modes (view, combat, camp) use routines not yet ported.

**Fix to existing code:** the stub of H042+$0254 had the wrong signature. In the asm it takes four arguments (word, word, byte, pointer) and is called with the result of H042+$0B80. I fixed both stubs and the call in H008.

**What stays a stub in the View submenu:**
- **Items (H065+$255A):** about 355 instructions; uses other routines of H065 and H033.
- **Spells (H065+$34FC):** about 117 instructions.
- **Trade (H065+$12D6) and Drop (H065+$1636):** about 200 instructions each; they use H067.

**Checks:**
- With L added to the party, View shows their sheet (Paladine Cleric, 40 Steel) with the menu "Trade Drop Exit", and Exit goes back to the main menu.
- The run was also done under ASan/UBSan, without errors.
- The Linux build, the MinGW x64/x86 builds and the C89 check give no warnings and ctest passes 8 tests out of 8.
- I did not compile with SAS/C: if it gives errors send me the `smake.err`.

If you want to complete View, the most useful step is **Items**: the knight KNT has his three initial items to try it. Alternatively I can move to the other menu items (Drop, Modify, Remove, Save Current Game, BEGIN Adventuring).

---

## 2026-11-10 19:42

I am sending you **cok-port-21.zip** with the Items screen of View Character. Ready, Drop, Halve and Join work; Use, Trade, Sell and Id are still stubs, and choosing them stops the program. We are at 407 routines ported out of 916.

**The screen (H065+$255A):**
- At the top "<Name>'s Items" and "Ready Item".
- Below, the list of items with Yes/No (ready or not) and the composed name.
- The menu shows only the commands valid at that moment:
  - Ready (View Ready in debug mode);
  - Use: only in combat or in camp;
  - Trade: not in combat;
  - Drop;
  - Halve: with fewer than 16 items;
  - Join;
  - Sell and Id: only in town;
  - Exit.

**Ported commands:**
- **Ready (H065+$2C04):** readies or unreadies the item. A cursed item cannot be removed ("It's Cursed"). The other obstacles have their own message:
  - "Wrong Class";
  - "already using <item>" (slot occupied);
  - "Your hands are full!";
  - "Wrong Magical Order" (scrolls);
  - "Usable Only By Kender".
- **Drop:** a ready item cannot be dropped ("Must be unreadied"). For magic scrolls there is a confirmation. Then "Your <item> will be gone forever / Drop It?".
- **Halve:** splits the quantity into a new item, or "Can't halve that".
- **Join:** joins identical items, at most 255 per item.

**New support routines:**
- **H063+$1BE8:** deletes an item from the list.
- **H056+$0886:** debug trace, active only with $24D2.
- **H033+$17E6:** recognises the scrolls.
- **H030+$0302:** text with automatic wrapping, with "Press any key to continue" when the page is full.
- **H044+$07DE:** frame of the screen.

**Differences from the original (they are in the comments):**
- **List of items in the menu:** the original passes the list of items directly to the menu engine, because the first $30 bytes of an item have the shape of a menu entry. In C the structs are different. For this reason I build a mirror list of entries, and the chosen entry corresponds to the item in the same position. The cursor index stays the same as in the original.
- **Use command in combat:** with mode $3DE3 = 5, the original reads the +$192 block of the character even when it is null. Here a null block counts as 0.

**Other stubs:**
- The effects of the magic items when they become ready (H062+$03F2, $1A32, $0452): they are reached only with magic items.

**Checks:**
- **Ready and sheet:** with KNT the items are Plate Mail, Shield and Long Sword. After Ready on armour and shield, the AC drops to 1, the encumbrance rises to 565 and the movement goes to 6. The Plate Mail appears in the row of slot 2: I checked it in the `items` file of the original data, where it really has slot 2.
- **ASan/UBSan:** a run with Ready, Join and Drop (the shield: encumbrance 515, AC 2) without errors.
- **Build and tests:** the Linux build, the MinGW x64/x86 builds and the C89 check give no warnings and ctest passes 8 tests out of 8.
- **SAS/C:** I did not compile it. If it gives errors send me the `smake.err`.

To complete Items, Use (H065+$2F82, with the H033 spells), Trade (H065+$1D94), Sell and Id are missing; the last two, however, are needed in town. Tell me whether to continue with these or move to other items of the party menu.

---

## 2026-11-10 20:04

I sent you **cok-port-22.zip**, with the Use command of the items screen (H065+$2F82) ported faithfully from the asm. Since Use calls the spell casting, I also ported the part of H033 that handles it. The count goes to 428 routines ported out of 917 (commit `4a46ad2`). I cannot compile with SAS/C and Visual Studio from here: send me the log.

**What I ported**
- **H065:**
  - Use (`use_item`).
  - The spell choice `choose_spell_of_kind` ($34FC), which replaces the stub also called by H013 and by the Spells menu.
- **H033:**
  - building of the spell lists: memorised, spellbook, scrolls, to choose, to memorise ($0366–$0D7C);
  - Cast/Memorize/Scribe/Learn menu ($00EE) and choice of the targets ($12D4);
  - the actual casting ($1426), removal of the spell from the scroll ($1836) and "casts" message ($18EE).
- **H063:** messages in the text area ($1DC2, $1EE8), $2F12 and the choice of a party member "Cast Spell on whom" ($3A26).
- **H062 and H073:** H062+$1780 (removes the $19 effects) and the two routines H073+$1294/$12AE, which always return $11.
- **Data:** the tables that H033 reads in H085 are now C variables declared in `h085.h`. The H005 pointers $2508, $251C, $2520 and $2770 are also global C variables.

**What stays a stub**
The routines used only in combat (H048, H077+$508, H063+$1B90/$2178/$21D2/$3658, H044+$492) are stubs. The same goes for the handlers of the single spells H085+$xxxx: the program stops there.

**One difference from the original:** in the asm the scroll counter H085+$4 has no limit and, after $31 entries, writes over the following H085 tables. In C I stop at the end of the table, so as not to corrupt memory on the host.

**Tests**
- **How I tested:** Use appears only during the adventure ($3DE3 = 2..4), so it cannot be reached from the main menu yet. I tried it with a temporary change, which is not in the commit, and with test data in which I gave the characters a scroll (Bless and Cure Light Wounds) or a magic item.
- **Scroll:** the menu "Spells on Scroll" appears with the header "1st Level". With the knight "KNT oops!" comes out. With the cleric L the casting goes on up to the Bless handler (H085+$1C60), which is not ported.
- **Magic item:** "KNT uses an item" and the name of the item appear, then "Cast Spell on whom Select Exit". Select reaches the Cure Light Wounds handler (H085+$1CB8), also not ported.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8 and ASan clean both on the normal flow and on the two Use paths.

The natural next step is the spell effects in H085, to make Bless and Cure Light Wounds really work. Alternatively there are the Trade, Sell and Id commands of the items, or the remaining items of the main menu.

---

## 2026-11-10 20:37

I sent you **cok-port-23.zip**: the main menu is now complete except for Begin Adventuring, together with the remaining commands of View and Items. Of the spell effects I ported only a first part: the common engine that almost all the other spells need is still to be done. We are at 483 routines ported out of 923, with the patches up to 0030. I cannot compile with SAS/C and Visual Studio from here: send me the log.

**Main menu**
- **Drop Character:** asks for confirmation twice, deletes the .who/.swg/.fx files and removes the character from the party. Tried: Garin was removed.
- **Modify Character:** Add, Subtract, Keep and Exit on ability scores, hit points and name, with the race and class limits. Tried: Subtract on STR lowers the exceptional strength from 18(51) to 18(48), Esc restores everything.
- **Knight Change Classes:** ported but not tried. In the menu it appears only when Train is active, and in the test data it is not.
- **Save Current Game:** writes `savgamX.dat` and the `CHRDATXn` files, then deletes the .who of the characters. The file produced has the same size and the same format as the original (5481 bytes).
- **Load Saved Game:** loads both the save made by us and the original A, with its 6 characters.
  - The loading of the 3D map and of the big picture (H011+$1876, H011+$14EA, H042+$1006) is needed only by the adventure. They are stubs that report and go on, they do not block.

**View and Items**
- **Trade and Drop of money (View):** ported together with the H067 coin routines, the number parser H045+$000C and the error message H014+$0018. The character of the save had no money, so I did not try them.
- **Trade of an item (Items):** tried, the Plate Mail goes to Istan.
- **Sell and Id (Items):** ported but not tried, because they appear only in the shops.

**Spell effects**
- **They work and I tried them:**
  - Cure Light Wounds: KNT goes from 10 to 13 HP.
  - Enlarge: the strength goes to 18(00) with "is stronger".
- **Ported but not tried:**
  - Cure Serious Wounds.
  - Cure Disease and Neutralize Poison: they rely on the removal of the effects and on the recomputation of the ability scores (H062+$0452 and H062+$1A32), which now also replace the stubs used by Ready.
  - Strength: tried only on a knight, where it has no effect (see below).
- **What is missing:** Bless, Detect Magic, Protection, Resist, Invisibility, Prayer, Haste and almost all the others go through H085+$07B6. About 2300 instructions remain, partly combat graphics in H049 and H029. It is the next step; until it is there, those spells stop on the "routine not yet ported" stub.

**Values not initialised in the asm, set to 0 here**
- The Strength bonus for a character without suitable classes: that is why nothing happens on a knight.
- The constitution outside the range 3–19.
- The knightly order other than Crown and Sword.
- The unknown coin type.
- The caster level for a class above 4.

**Tests**
- Compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8 (I fixed the `dax_test` stub).
- ASan clean on Load, View, Save, Modify and Drop, and on the Use paths.
- I tried Use as in version 22: it cannot be reached from the menu, so I used a temporary change, not committed.

---

## 2026-11-10 20:56

I sent you **cok-port-24.zip**: H085+$07B6 is ported together with its non-graphic chain, and with it about fifty spell handlers. The effects that the characters already have on them, on the other hand, are almost all still stubs: a spell stops there if the target has one of those effects. We are at 552 routines ported out of 975 (commit `87123b7`, patches up to 0031). I cannot compile with SAS/C and Visual Studio from here: send me the log.

**The engine (H085+$07B6)**
For each target it does the saving throw (H062+$142C), the to-hit roll when needed (H062+$12F6), the damage and then the effect with its duration. The damage goes through H062+$2188 (with the messages "takes … points of damage from …", "Goes Down", "is killed") and H063+$2984. The effect is applied by H062+$0114. Below there are:
- the events of the effects (H062+$083E), with the table of the 25 events;
- the activation of a single effect (H062+$057C);
- the magic resistance (H062+$0772);
- the removal of the effects when a character falls (H062+$17C0);
- the message of the effect (H063+$2760);
- H063+$1B90 (removes the cast spell), which replaces its stub.

**Ported spells**
- **Cleric:** Bless, Curse, Cause Light/Serious Wounds, Resist Cold and Resist Fire, Silence, Slow Poison, Snake Charm, Spiritual Hammer, Cure/Cause Blindness, Cause Disease, Prayer, Remove Curse, Bestow Curse, Sticks to Snakes.
- **Mage:** Burning Hands, Charm Person, Reduce, Friends, Magic Missile, Shield, Shocking Grasp, Sleep, Knock, Mirror Image, Ray of Enfeeblement, Blink, Haste, Slow, Confusion, Fire Shield, Fumble, Ice Storm, Minor Globe.
- **Common:** Detect Magic, Protection, Invisibility.
- **Without a name (class 4):** the handlers of the monster spells.

**What stays a stub**
- **Spell handlers:** Hold Person, Stinking Cloud, Lightning Bolt, Fireball, Charm Monsters, Dimension Door, Fear and Poison are combat-only and stay stubs. Dispel Magic (H085+$3ED4) also stays a stub, but there it is my choice of priority: it is big, it is not combat-only, and it is worth doing right away.
- **Combat graphics and positions:** H029, H048, H049, H077, H063+$2178/$2BDE. Outside combat they are never called.
- **Effect handlers (H027, table H005+$2832):** it is the next level, 108 handlers. I ported only those that the test characters trigger right away: effects $12 and $5F (H027+$0A00 and $3A46, with their helper $0286) and $5C (H027+$41F6, which does nothing). Without these, Bless stopped at H027+$3A46.

**Values not initialised in the asm, set to 0 here**
- The strength value in the monster spell H085+$331E when the strength does not go up.
- The case of H063+$2FAA with a class above 4.

**Tests**
- **Bless from L's scroll:** "L is Blessed" appears and the scroll goes from 3 to 2 spells.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **ASan:** clean both on Bless and on the magic item. As in the previous versions I used the temporary change to make Use appear, not committed.

The natural next step are the effect handlers of H027: most of them are under 60 instructions, but there are many. Alternatively I can do Dispel Magic first.

---

## 2026-11-10 21:03

I sent you **cok-port-25.zip**. H085+$07B6 had already been ported in cok-port-24 (commit `87123b7`), so I did not redo it. I went on with what the engine calls and was still missing: the effect handlers of H027, in the table H005+$2832. The counter now shows 596 routines ported out of 1017; the total went up because the script also counts the routines discovered with the new tags (commit `07d9a80`, patches up to 0032). I cannot compile with SAS/C and Visual Studio from here: send me the log.

**Ported handlers (about fifty)**
The engine calls them when an effect is applied, removed, or when an event such as damage, saving throw or to-hit roll fires.
- **Damage and roll modifiers:** the bonuses to the saving throw and to the to-hit roll (effects 1, 2, 8, 9, $21, $24, $39, $76, $77), the damage halved or doubled by fire and cold ($A, $14, $1D, $32, $36), blindness ($21) and slow poison ($F).
- **Effects with a message:** Mirror Image losing an image ($1C, "lost an image"), silence ($15) and ageing ($27).
- **Cancelling of incoming effects and spells:** $3B, $3F, $49 and $59–$63.
- **End of turn:** the handlers that close the combat turn ($1B, $1F, $33–$35, $6A).
- **Magic items:** the vector $2A0E, which adds or removes the effect when an item is readied or unreadied (effect +$45).
- **Empty effects:** those that do nothing in the original.

I also moved H062+$15C6 (roll of the damage dice) into `h062.c`, because both H027 and H085 use it.

**What remains**
- **47 handlers of H027 stay stubs.** They are mostly combat ones: map areas, target of the turn, the list of characters in H005+$16, or they depend on unported routines of other modules (H062+$2650, H063+$2B7C).
- **A problem for combat:** several of these handlers save a pointer to a character inside the +$192 block (at offset +$C). On the host, with 64-bit pointers, those 4 bytes are not enough. Before porting them we have to decide how to represent it.
- **Spell handlers still stubs:** Dispel Magic (H085+$3ED4, 329 instructions) and the combat-only ones (Hold Person, Fireball, Lightning Bolt, Stinking Cloud, Fear, Charm Monsters, Dimension Door, Poison).

**Tests**
- **ASan:** clean both on Bless from L's scroll and on KNT's magic item, and neither of the two reaches a stub any more.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **Use:** as before, I made it appear with the temporary change, not committed.

As the next step I propose Dispel Magic, which is not combat-only. Then it is worth deciding how to represent the pointers in the +$192 block, before porting the combat handlers.

---

## 2026-11-10 21:13

I sent you **cok-port-26.zip** with Dispel Magic (H085+$3ED4) ported. I tried only the first part (the effects on the target): the part about the clouds is ported but not tried, because for now clouds never exist. We are at 598 routines ported out of 1018 (commit `4f08813`, patches up to 0033). I cannot compile with SAS/C and Visual Studio from here: send me the log.

**What the routine does (two parts)**
- **Effects on the target:** for each target it tries to remove the effects with a duration (+$4 < $FF) of the first target, as in the asm. The probability depends on the caster level against the level of the effect (+$4 & $0F): +5% per level above, −2% per level below, 50% when equal. If it removes at least one it shows "is affected".
- **Clouds:** in the 9 squares around $2518/$251A it reads the combat map and, on the squares with a cloud ($1E), dispels the cloud effects ($28) of their caster. Then it redraws with H048+$0DF2, which is a combat stub.

**What I changed to make it run**
- **H048+$0154 ported:** it is the reading of a map square. It has to be ported because in the original the second part also runs outside combat.
- **Combat map (H005+$2ADE):** it is now a C variable (`g_combat_area`) instead of the stub `g_h005_2ade_area()`, which stopped the program. It is allocated by H095, the module that prepares combat, not yet ported.
- **List of the clouds (H005+$2514):** it is a C variable (`g_clouds`) with the $22-byte record. Owner and next are C pointers, the rest is kept in the bytes as in the original. For now it stays empty, because Stinking Cloud (which creates the clouds) is not ported.

**One difference from the original:** without a combat map the asm reads from $2ADE = 0, that is from the low memory of the Amiga. On the host this would crash, so in that case the square is 0: outside combat there are no clouds to dispel.

**Tests**
- **Dispel Magic from a magic item on KNT:** I gave his effect $12 a duration of 3. The effect is dispelled and "KNT is affected" appears.
- **ASan:** clean on the same test.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **Use:** as before, I made it appear with the temporary change, not committed.

The combat-only spells and effect handlers remain. Before those it is worth deciding how to represent the character pointers saved in the +$192 block (offset +$C), which on the 64-bit host do not fit in the 4 bytes.

---

## 2026-11-10 21:15

Dispel Magic (H085+$3ED4) is already ported: it is in **cok-port-26.zip**, which I sent you in the previous message (commit `4f08813`). There is nothing else to do on that routine, so I did not touch it again.

I tried it from a magic item on KNT: his effect $12 (with duration 3) is dispelled and "KNT is affected" appears, with ASan clean. The part about the clouds, on the other hand, is ported but not tried, because for now the list of the clouds is always empty.

If the previous message was a repeated send, tell me how to continue among these paths:

1. **Pointers in the +$192 block (offset +$C):** before touching the combat code we have to decide how to represent the character pointers saved there, because on the 64-bit host they do not fit in the 4 bytes. Almost all the 47 H027 handlers that are still stubs and several spells depend on this.
2. **Combat-only spells:** Hold Person, Stinking Cloud, Fireball, Lightning Bolt, Fear, Charm Monsters, Dimension Door and Poison. They also need H048 and H077 (combat figures and areas).
3. **Other things outside combat:** for example the audio (H043) or other screens.

I am still waiting for the SAS/C log of version 26.

---

## 2026-11-10 21:22

I sent you **cok-port-27.zip**. I took the step that unblocks the combat code: the turn block +$192 is now a struct, and I ported more effect handlers of H027. The counter now shows 626 routines ported out of 1040; the total went up because the script also counts the routines discovered with the new tags (commit `2a3f9de`, patches up to 0034). I cannot compile with SAS/C and Visual Studio from here: send me the log.

**The turn block (+$192)**
- **What I checked:** in the whole asm the only longword field of the block is +$C, a pointer to the target character. All the other accesses are byte or word.
- **How I represented it:** the block is now `CokTurn` in `character.h`, with the original $18 bytes in `b[]` and the pointer in a separate field, `target`. The 4 bytes at +$C..+$F stay unused, and the rest of the code accesses the bytes with `block_192->b[...]` as before.
- **Other variables that contain pointers**, now C variables:
  - H005+$2A14 (`g_h005_2a14`), the target of the turn under examination;
  - H005+$2B32 (`g_combatants[40]`), the combatants by number;
  - H005+$16 (`g_h005_0016[20]`), the downed characters.

**New routines**
- **Support routines:**
  - H062+$02FA, which knocks a character down;
  - H062+$2650, which puts them back on their feet;
  - H063+$2B7C, which counts the active combatants per side;
  - H027+$0214, which paralyses the target of the turn;
  - H027+$2182, which poisons the target of the turn;
  - H027+$0338, the +1 bonus.
- **Effect handlers**, 24 more:
  - $16 (death by poison);
  - $17 (Spiritual Hammer, which gives and takes away the hammer);
  - $2B and $2C (weakness and disease);
  - $3D and $3E (reduced fire and regeneration);
  - $40, $41, $56 and $57 (poisons);
  - $42 ("gets zapped!");
  - $45, $51 and $58 (paralysis);
  - $1A, $30, $31, $3A, $44, $72, $73 and $75.
- **H048+$16D4 (placement on the map):** stays a stub, but returns 1 outside combat as in the asm. This way getting back on one's feet also works outside combat.

**An oddity of the original that I kept:** in handler $17, after giving the hammer, the search leaves selected the item that follows it, not the hammer. That is what the asm does.

**Tests**
- **ASan:** clean on Bless and Dispel Magic from an item, and neither of the two stops on a stub any more.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **Use:** I made it appear with the temporary change, not committed.
- **New handlers:** not tried, because they fire only in combat or with effects that the test characters do not have.

**What remains in H027**
25 handlers stay stubs: $0492, $06D4, $080A, $0EFC, $0FCE, $1162, $13F4, $1836, $1E3C, $2400, $266A, $29E2, $2B3E, $2D46, $2FE2, $3160, $3292, $3636, $3916, $3982, $3B34, $3C2A, $3C88, $3D28 and $3F72. Almost all are tied to combat. They use the list $250C, the table $2AE2 and the clouds, and unported routines of H063 ($2DC6, $1160, $135A, $37B2, $21D2). The natural next step is to continue with these, starting from the H063 routines that several handlers need.

---

## 2026-11-10 (cok-port-28)

I sent you **cok-port-28.zip** with the H063 routines that the effect handlers needed, the 11 H027 handlers that use them and the new `backlog.md`. The counter shows 642 routines ported out of 1051; the total went up because the script also counts the routines discovered with the new tags. I cannot compile with SAS/C and Visual Studio from here: send me the log.

**backlog.md**
- It is in `src_c/readable/backlog.md` and contains all my 42 reports of this session, taken from the history, in date order, each with the date and time of the original message.
- It also has the first messages not related to the port (for example the one about the Pro subscription and the API), because you had asked me to put everything in it.
- From now on I add every new report there, starting with this one.

**Ported H063 routines**
- **$135A:** is the character helpless? Checks the effects listed in H005+$4066..$4069.
- **$1160:** panel of the combatant on the right (name, "Hitpoints", "AC", ready weapon, status, "(Helpless)", "(Casting)").
- **$2DC6:** distance between two combatants on the combat map. Saves and restores the table H005+$2A3E as in the asm.
- **$37B2:** weapon used for fighting, from the hand (+$154) or from the ammunition (+$180/+$184).
- **Exported:** $016A, $0354 and $19B6 (dexterity and strength adjustments, already ported but static) are now visible to the other modules.

**Ported H027 handlers (11)**
- **Combat:**
  - effect 7 (natural attack: in melee 1d6+2 plus strength, at range 1d4+1 plus dexterity);
  - effect $1E (cloud: "is coughing");
  - effects $5D, $64 and $66 (damage halved or cancelled depending on the weapon);
  - effect $69 (extra damage at distance 1);
  - effect $70 (whoever hits in melee "gets zapped").
- **States of mind:**
  - $B (charm, change of side);
  - $D ("goes mad!");
  - $20 ("Arises in a new form");
  - $23 (confusion: flees, stays confused, goes berserk or becomes enraged, then a saving throw).

**Values not initialised in the asm, set to 0 here**
- In effect 7 the original adds the uninitialised word of the frame when the character has no weapon in hand.

**Tests**
- **ASan:** clean on Bless and Dispel Magic from an item (the temporary change for Use is not committed).
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **New handlers:** not tried, because they fire only in combat, which cannot be reached yet.

**What remains**
- **H027 handlers (14):** $13F4, $1836, $1E3C, $2400, $266A, $29E2, $2B3E, $2D46, $2FE2, $3160, $3292, $3636, $3982 and $3D28. They use the clouds, the list H005+$250C, the table H005+$2AE2, H062+$2734 and the combat graphics.
- **H063 combat graphics routines:** $1FDC, $2178, $21D2 and $3CA0. They stay stubs.

---

## 2026-11-10 (cok-port-29)

I ported the last 14 effect handlers of H027: the table H005+$2832 no longer points to any H027 stub. Routines ported: 659 out of 1065.

**Ported handlers**
- **Clouds and acid:**
  - $13F4 (effect $28): "The air clears a little...", the cloud dissolves and the squares go back to how they were;
  - $266A (effect $46): "dissolves into acid!", creates a pool of acid;
  - $3292 (effect $50): "The acid drains away..", the pool dries up.
- **Defences:**
  - $1836 (effect $29) and $174E: "Avoids it", dodges weapons without a magic bonus;
  - $29E2 (effect $47): "reflects the spell", sends the spell back to the caster;
  - $2400 (effect $43): "loses his weapon", the weapon ends up in the list H005+$3360.
- **Fear and stench:**
  - $2B3E (effect $48) and $3636 (effect $52): "is terrified" / "is afraid", the target flees;
  - $3160 (effect $4F): "emits an evil stench".
- **Berserk:** $2FE2 (effect $4D, "goes berserk") and $3D28 (effect $6B, same thing without a message).
- **Explosions and summoning:**
  - $1E3C (effect $3C): "explodes!", 3d6 and stunning to those around;
  - $2D46 (effect $4C): "gates in", brings the reinforcements onto the field.
- **Constitution:** $3982 (effect $5E), bonus from +1 to +5 according to the constitution.

**Other new routines**
- **H062+$2734:** makes the downed characters of the list H005+$16 explode ("explodes.", 1d6 to those around).
- **H029+$0376:** XOR of a byte (`xor_byte`).

**New global data**
- `g_acid_pools` ($250C): acid pools, with the same record as the clouds.
- `g_dropped_items` ($3360): lost weapons, with a new struct `CokDropped`.
- H006 now clears `g_dropped_items` instead of the long in H005.

**Where I deviate from the asm (all documented in the code)**
- **Record size:** clouds, pools and lost weapons are allocated and freed with the size of the C record. The asm uses $22 and $50 bytes; in C the pointers are bigger.
- **H062+$2734:** the asm also writes to an empty (NULL) entry of the list; here I skip it.
- **$2D46 at the end of the list:** the asm reads a NULL character when the list ends; here I treat it as the return to the caster.
- **Uninitialised values, set to 0 here:**
  - in $266A, the direction used when the square is $1F;
  - in $3982, the bonus for a constitution outside the table.

**Behaviours of the asm kept as they are**
- **$2D46:** with a square outside the map it does not move on to the next direction. If the reference character is on the edge, the loop never ends.
- **$29E2:** the animation and the change of target are repeated for every target, also for those not replaced.
- **$266A:** when counting the pools that already exist, it skips the last record of the list.
- **$3160:** effect $76 goes to whoever emits the stench, not to the victim.

**Tests**
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **ASan:** clean in a test session on the main menu.
- **New handlers:** not tried, because they fire only in combat, which cannot be reached yet.

**What remains**
- **Combat stubs:** H048 graphics (positions, areas), H077, H063 $2178/$21D2 and H043+$190E.
- **Cloud allocation:** not ported yet. Whoever ports it must use `sizeof(CokCloud)`.

---

## 2026-11-10 (cok-port-30)

I ported the combat graphics: map, 7x7 view, figures, cursor, falls, areas and line of sight, projectiles and double buffer. Routines ported: 705 out of 1065 (before 659).

**H048: combat map and figures (19 routines, all of the module)**
- **Shapes and view:**
  - $0044 (square i of a shape, table H005+$5048);
  - $00C2 (coordinates in the view);
  - $01E8 (inside the 7x7 view);
  - $0230 (combatant visible, wholly or in part).
- **Drawing:**
  - $0334 (square with cursor and figure);
  - $0588 (terrain under a combatant);
  - $0884 (square and whoever occupies it);
  - $0B1A (moves and redraws the view);
  - $0DF2 (centres the view on a square, it was the stub `h048_0df2`).
- **Combatants:**
  - $0956 (occupancy table H005+$2BD2);
  - $0AA8 (number of the combatant);
  - $0F88 and $0FBA (position);
  - $0FEC (changes frame);
  - $110C (shape);
  - $113E (examines the squares in one direction);
  - $12F4 (fall: sound, animation, body on the map);
  - $16D4 (places a combatant);
  - $195E (cursor on the combatant).

**H077: areas and line of sight (all the routines)**
- **Line:** $0012, $01CC and $0242 (Bresenham line with cost 2 per step, +1 on the diagonal).
- **Visibility:**
  - $0378 (line of sight with the heights of H005+$3EF4);
  - $0508 (sector of a direction).
- **List of the combatants:**
  - $0056 (sorts the list H005+$2A3E);
  - $08AC (fills the list with those inside the area).
- **Fix:** in the C the call `h077_08ac(h048_110c(...), area)` was wrong. H048+$110C takes only the character; the other four words stay on the stack as arguments of H077+$08AC, which has six: x, y, radius, direction, shape and map. Now it is `find_in_area(x, y, radius, dir, combatant_size(c), area)` in all the callers (H027, H062, H063).

**H063**
- **Projectiles:**
  - $1FDC and $2178 (frames of the projectile in $243A, also mirrored);
  - $21D2 with the nested procedure $21E0 (animation of the projectile with the two alternating Views).
- **Combat:**
  - $2B4C (opposite side, moved here from H085);
  - $2BDE (nearby enemies, with the preferred target $2432 first);
  - $3658 (redraws the combat);
  - $3CA0 (direction from one combatant to the other).
- **Map:** $33A0 (status line: coordinates, direction, time, " camping"/" search").

**H029, H035, H044, H049**
- **H029, double buffer:**
  - $14F6 (waits for the screen in front);
  - $1520 (copies the off-screen screen);
  - $1576 (swaps the Views);
  - $16A2 and $16DE (start and end of a nested update).
- **H029, 24x24 tiles:** $0B94, and $0D58 (same thing with saving of the background).
- **H035+$019A:** map tile.
- **H044+$0586:** combat frame.
- **H049+$04AE:** hardware blit plane by plane, with or without mask.
- **H049+$09D6 and $0A7A:** horizontal mirror of a graphic record.

**New data**
- **Structures:**
  - `g_bodies[8]` (bodies on the map, H005+$2AE2), struct `CokBody`; the H027 effects now use this instead of H005_L;
  - `g_h005_2432` (preferred target);
  - `g_gfx_3304[2]` (frames of the fall);
  - `g_h029_m8` (View shown).
- **Host:** I added `IntuitionBase->FirstScreen`. OpenScreen sets it and CloseScreen clears it. On the Amiga there is the new include `<intuition/intuitionbase.h>`.
- **Fixed signatures:**
  - H049+$09D6 is now `mirror_gfx_record(src, dst)` in push order: first the source;
  - H029+$0D58 is now `draw_tile24_saving` (before it was a stub).

**Where I deviate from the asm (all documented in the code)**
- **H049+$04AE:** the original queues a bltnode with QBSBlit and programs the blitter when the beam passes. Here I write the same registers right away, plane by plane, with OwnBlitter/WaitBlit, as in the text routine already ported.
- **H048+$12F4, initial check:** reads an uninitialised entry (-$6), outside the table if it is 0, and never finds the character; here it is omitted.
- **H048+$12F4, ninth body:** the original would write it over the combatants; here it is not recorded.
- **H048+$0AA8:** with $247B = 0 the original runs past the table; here the search stops at 40.
- **H077+$0508:** for a direction above 8 it returns an uninitialised byte; here 0.

**Behaviours of the asm kept as they are**
- **H049+$04AE, extra pixels:** with a destination not aligned to 8 pixels it clears ALWM and draws 8 pixels of the nearby frame. In the game the destinations are always multiples of 8.
- **H048+$16D4:** writes the square at every iteration of the loop until it finds a body.
- **H063+$3CA0:** loops forever if no sector contains the direction.

**Tests**
- **Hardware blit:** test on the host. H049+$04AE with the emulated blitter matches BltMaskBitMapRastPort and BltBitMap in 999 cases: widths 8/16/24, source and destination multiples of 8, with and without mask.
- **Mirror:** H049+$09D6 tested on a 24x24 record (picture and mask), 0 differences.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **ASan:** clean on the main menu.
- **New routines in the game:** not tried, because combat cannot be reached yet.

**What remains**
- **Stubs:** H043+$190E (audio) stays a stub that is skipped.
- **To be ported:** whoever loads $3304, $243A and $332C and whoever prepares the combat map, that is the combat start-up in H095/H096/H097.

---

## 2026-11-10 (cok-port-31)

I ported the combat start-up, H095+$2496, which the script (H059) calls at every battle. Routines ported: 732 out of 1066 (before 705).

**H095: combat start-up (all 14 routines of the module)**
- **$2496 `start_combat`, the start-up:**
  - frees the map pictures ($27B2, $27B8, $2798) and writes "A battle begins...";
  - clears the combat state: clouds, pools, bodies, lost weapons, $2432, $2510, $335C;
  - builds the map, prepares the turns and deploys the combatants;
  - allocates the icons $243A, centres the view on the first one and redraws;
  - copies the colours into the off-screen View, fires events 8 and $16 for everybody and computes the strength of the enemies;
  - switches to context 5.
- **$1630 (map):** loads the tile sets (DungCom or WildCom, plus RandCom) and allocates the $9CE-byte map.
- **Dungeon map:**
  - $083A with the nested procedures $0848, $0912, $09A4 and $0CD4: a 7x5 block for each square around the party (columns -6..6, rows -2..2), with dungeon floor, walls and doors;
  - $06F2/$0700: walls between two squares;
  - $0392: square of the block;
  - $0422: trees and bushes in the outdoor blocks.
- **Outdoor map:**
  - $1576: free map;
  - $1076: tall trees and objects;
  - $121A/$1228: grass and terrain.
- **Turns:** $1790, with the turn block of each character, the initial direction and the AI of those out of combat.
- **Deployment:**
  - $1FC2: starting points of the two sides and deployment grids;
  - $1A7A: spiral search with change of grid;
  - $1914: tries a square;
  - $18CC: outside the grid.

**Other routines**
- **H011:**
  - $0162 (inside the 16x16 map);
  - $01AA (wall of a side);
  - $04E2 (byte of GEO plane 2);
  - $09C8 (door of a side).
- **H029+$1718:** copies the 32 colours of the screen into the off-screen View, reading them from the Copper list of the Intuition View.
- **H035+$0040:** loads a 24x24 tile set into the set $332C.
- **H096+$37C2:** strength of the enemies in H005+$2481.

**Host**
- **Intuition View:** at start-up `GfxBase->ActiView` is a View without a ViewPort, so the display shows the screen.
- **Copper list:** that View has a Copper list with the MOVE COLOR00..31 of the front screen. OpenScreen and LoadRGB4 update it. This way H029+$1718 is ported as it is.
- **`struct cprlist`:** it is now defined in the host ndk.

**Bug found with the real test and fixed**
- **Problem:** after the deployment `$247B` holds the number of combatants + 1 (as in the original), so H048+$0DF2 reads an empty entry of $2B32.
- **Original:** reads +$198 from low memory and discards the entry because its shape is 0.
- **Here:** the NULL entry is skipped (deviation documented in the code).

**Where I deviate from the asm (all documented in the code)**
- **H010+$0360:** stays a stub. It is the message "Start range error in Load24x24Set" on the console, that is the writeln of the Pascal runtime (H020/H074/H075). It is reached only with an index above $27, which the H095 calls do not use.
- **Uninitialised values, set to 0 here:**
  - the tiles of the cases without a value in $09A4 and $0CD4;
  - in $1A7A, the outcome when leaving the grid without changing it;
  - in H011+$01AA, the wall of an odd direction.
- **Deployment:** beyond 8 bodies they are not recorded.

**Tests**
- **Temporary test (not committed):** with `COK_TEST_COMBAT`, "Begin adventuring" loads the character L and calls `start_combat()`, with `$3DE3 = 1` as in exploration.
  - Outdoors: map with trees, bushes and objects, the character deployed, combat frame and "A battle begins...".
  - In the dungeon: only floor, because in the menu the GEO planes are not loaded.
  - ASan clean in both cases.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**What remains**
- **Script that calls the start-up:** H059.
- **Combat loop:** H096/H097 (turns, attacks, AI, combat menu).
- **End of combat.**
- **Audio:** H043+$190E.

---

## 2026-11-10 (cok-port-32)

The request repeated "proceed with the combat start-up", which had already been delivered in cok-port-31. So I ported the next step: the combat loop (H059+$1782, Combat_MainLoop), which the COMBAT command of the script (H012+$0766) calls and which in turn calls the start-up. Routines ported: 760 out of 1066 (before 732).

**H059: combat loop (all 13 routines)**
- **$1782 `combat_main_loop`, the main loop:**
  - before the loop: context 5, handler $276C (target in combat), start-up (H095) and event $18 for everybody;
  - at every round, as long as both sides remain: start of the round, order of the turns, turn of each one with the explosions of the fallen, end of the round;
  - at the end: clean-up.
- **$0130:** order of the turns by initiative (+$4 of the turn; on a tie, at random) in the table H005+$2392, now `g_turn_order[72]`.
- **$1498:** turn of an actor (events 7, $F and $15, cursor, status; automatic or with the menu).
- **$1110:** turn of the player.
  - Commands: Move, View, Aim, Use, Cast, Turn, Yell, Done.
  - Special keys: everybody on automatic, magic on/off, $4DE8.
- **$03BE:** turn menu.
- **$0726 with $0734:** movement/attack with the keypad arrows: cost of the squares, "Flee:", "can't go there"; Esc cancels.
- **$0670:** melee attack ("Not with that weapon").
- **$0EA0:** Done submenu: Guard, Delay, Quit, Bandage, Auto, Speed, Exit.
- **$0CCA:** game speed.
- **$0E4A:** automatic control.
- **$15EE:** end of the round:
  - one minute of game time, round counter and event $13;
  - acid of the pools; whoever is dying dies after 10 rounds; "Your Teammate is Dying";
  - end if a side disappears or after $2477 rounds, with "Continue Battle:".
- **$02AA:** clean-up: clouds, pools, charmed creatures, linked effects, map, icons.

**Ported helpers**
- **H058, game clock:**
  - $064A (advances the time);
  - $052C (carries, ageing);
  - $017C and $018A (icons of the frame at every hour);
  - $02F4 (duration of the effects in steps of 10).
- **H062:**
  - $021E (Yell, "wants to kill");
  - $1038 (clouds: "starts to cough", "chokes and gags from nausea"; acid);
  - $0F24 (owner of the cloud);
  - $1694 (fall with message);
  - $1898 (empty);
  - $17C0 is now exported.
- **H063:**
  - $3698 and $3734 (ranged weapon, use in melee);
  - $36EE (weapon of type $43);
  - $3980 (bandages, "is bandaged");
  - $2F5A (Guard, "Guarding").

**Where I deviate from the asm (all documented in the code)**
- **Turn table:** the original clears 40 entries of $2392 but runs up to $48; beyond entry 40 it overlaps $2432... Here the table has 72 entries; the NULL-terminated list does not go past them.
- **Delay ($0EA0):** does not read entry $48 outside the table.
- **H062+$0F24:** reads dirs[count] past the copy passed by value (stack); here the following byte of H005+$5022.
- **H063+$3734:** without a weapon the original reads +$30 from NULL; here it does not.
- **H058+$018A:** with an unexpected index, tile and column are uninitialised; here 0.

**New stubs (H096/H097, the next step)**
- **H096:**
  - round start $02CE;
  - attack $38DC, $1340, $20E6, $2182;
  - flight $10FA;
  - step $0C3C and $099C;
  - $11D4, Aim $4448, Cast $3100, Turn $160A, $4DE8;
  - target $2A6C.
- **H097:** automatic turn $1D68.

**Tests**
- **Temporary test (not committed):** `combat_main_loop()` from the menu runs start-up, check of the sides and clean-up with ASan clean. With only the party there are no enemies, so the rounds do not start (for those H096/H097 are needed).
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**What remains**
- **H096:** actions and attacks.
- **H097:** AI.
- **H012+$0766:** the COMBAT command of the script.
- **Audio.**

---

## 2026-11-10 (cok-port-33)

First step of "Begin adventuring and the game map": the heart of the ECL script interpreter. Routines ported: 790 out of 1066 (before 760).

**The plan, because it is a big piece**
- **Size:** after the main menu the game enters H012+$3150, the exploration loop. With the ECL interpreter and its ~60 commands (H064, H012), the menu and the movement (H068), the areas (H061) and the 3D view (H057, H011, H049, H042) they come to about 22,700 instructions in 225 routines.
- **Deliveries:**
  1. interpreter (this one);
  2. ECL commands of H064;
  3. ECL commands of H012 and the $3150 loop;
  4. menu, movement and 3D view.

**Fix**
- **Begin adventuring:** the main menu still called the stub `h028_0d74`, which stopped the program, even though H028+$0D74 had already been ported as `free_char_screens`. Now it calls that.

**H061: ECL VM services (33 routines out of 34)**
- **Operands:**
  - $1670 (reading with descriptors; immediate strings and strings from variables);
  - $184E (value: byte, word, variable, address);
  - $1F12 and $1F3C (addresses, base $4B00);
  - $1F6A (characters).
- **Strings:**
  - $3244 (6-bit compressed text, four characters every three bytes);
  - $33F0 (string from the variables);
  - $162E (appends a character).
- **Variables:**
  - $1FA4 (zone: state A $000.., state B $3100.., state C $2F00.., program $3500.., special registers $754B..);
  - $2E04 and $2BAA (reading and writing);
  - $208E and $27E2 (state B variables that read and write the current character: spells, AI, values, money, status, side, hit points, dungeon walls);
  - $202C (position in the party).
- **Area:**
  - $1928 (start of the program: flags, PC $3500, empty stack, the five entries $3DF4..$3DEC, clearing of the area variables);
  - $1ACC (loads the ECLn.dax block, "Loading...Please Wait").
- **Support commands:**
  - $3AAC (GOSUB, with the stack $2388);
  - $3E80 (skips a command);
  - $3904 and $3A0A (comparisons, results in $237E..$2383);
  - $3B4E (step forward on the 16x16 map);
  - $1C42 (free squares ahead);
  - $36E6 and $35E2 (ECL menu with the '~' shortcuts).
- **Other:**
  - $1BD6 (loads a monster);
  - $1D20 and $1D6E (pictures of the event: sprite, PIC, head+body);
  - $3DBE (destroyed items);
  - $3FA8 (minimum and maximum speed of the party);
  - $4092 (damage message, "is hit for", "dies.").
- **Not yet ported:** $3C4C, which scales the money with the real arithmetic of the H015 runtime.

**H012**
- **$018A `run_ecl`:** runs the program from an address until a command stops it or the area is left.
- **$2DF2:** dispatcher of the 66 codes. The handlers of H064 (27) and of H012 (26) are named stubs, for the next deliveries.

**H064:** the data of the module (saved character, VM flags, text) are C globals.

**Where I deviate from the asm (all documented in the code)**
- **Uninitialised values, set to 0 here:**
  - the cases without a value of the special variables and of the registers;
  - the first bytes of the 6-bit text.
- **$3FA8:** with the empty party the original reads a NULL; here it exits without changing anything.
- **Dead code kept:** the cases of the special registers with a low address can never be reached (those addresses fall into state A).

**Tests**
- **Temporary test (not committed) with the real data:**
  - loads the program of the initial area ($24) from ECL1.DAX and runs $1928: the five entries ($365A, $365B, $3658, $3659, $3514) fall inside the program;
  - from $3514 twelve commands skipped with $3E80 follow one another with consistent lengths (LOAD_FILES $21 of 7 bytes, then the PRINT $11/$12 with 6-bit text);
  - ASan clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** the handlers of the ECL commands of H064.

---

## 2026-11-10 (cok-port-34)

Second step of "Begin adventuring": the handlers of the ECL commands of H064. Routines ported: 825 (before 790; the total now counts 1087 entries).

**H064: all 27 handlers**
- **Flow control:**
  - $00 EXIT, $01 GOTO, $02 GOSUB, $13 RETURN (without a stack it becomes EXIT);
  - $16..$1B IF (=, <>, <, >, <=, >=: if false it skips the following command).
- **Comparisons and calculations:**
  - $03 COMPARE (strings if an operand is one, otherwise values);
  - $14 COMPARE AND;
  - $04..$07 ADD, SUB, DIV, MUL (remainder of the division in $3E00+$67E);
  - $08 RANDOM;
  - $2F/$30 bitwise AND/OR.
- **Variables:**
  - $09 SAVE (value or string);
  - $2A GETTABLE, $35 SETTABLE;
  - $0F INPUT NUMBER, $10 INPUT STRING.
- **Text and menus:**
  - $11 PRINT and $12 PRINTCLEAR (text window with pagination);
  - $15 vertical menu ("Select" list);
  - $2B horizontal menu with the '~' shortcuts ("PRESS BUTTON OR RETURN TO CONTINUE." becomes the version with Enter).
- **Characters and monsters:**
  - $0A LOAD CHARACTER (with bit 7 the character leaves the party);
  - $0B LOAD MONSTER (n copies with items and effects, CPIC figures, hit points scaled with the difficulty, at most $3F monsters);
  - $1C CLEAR MONSTERS (also empties the treasure $2A3A);
  - $1D PARTY STRENGTH.
- **Encounter and pictures:**
  - $0C APPROACH and $0D (sprite and portrait at the distance of the encounter);
  - $0E PICTURE (big picture, PIC or head+body; $FF closes).
- **Areas and map:**
  - $20 NEWECL (loads the program of another area);
  - $21 LOAD FILES and $37 LOAD PIECES (GEO map of the dungeon and definitions of the walls).

**Ported helpers**
- **H061:** $3012 (string in the variables) and $3860 (ECL list with the "Select" title).
- **H030+$09A6:** asks for a number.
- **H044:** $0330 (exploration frame) and $0452 (outdoor frame). Before they were the stubs `h044_0330`/`h044_0452` called by the main menu and by H063.
- **H028+$1098:** data disk, reached by the state B variables.
- **New global:** `g_treasure_items` ($2A3A).

**Where I deviate from the asm (all documented in the code)**
- **DIV with divisor 0:** on the 68000 it raises an exception; here result 0 and remainder unchanged.
- **LOAD MONSTER:** the copies of the monster are made by copying the C record of the character (the $1AA bytes of the original), then next, items and effects are cleared as in the original.

**Still stubs, for the view step**
- **Pictures (H042):** $0406, $0254, $1006, $10DC, $0F50.
- **Map and view:** H011+$1876 (GEO map), H011+$14EA (walls), H060+$0018 (redraw of the view), H069+$0012.

**Tests with the real data** (temporary test, not committed)
- **How:** the ECL program of the initial area ($24, ECL1.DAX) is run by `run_ecl`. Only in the test binary the picture stubs were non-fatal.
- **Commands run:** LOAD FILES, PICTURE, PRINTCLEAR/PRINT, GOSUB, horizontal menu, RETURN, text again, GOSUB and RETURN, two SAVE.
- **Text:** on screen "AT THE INN OF THE LAST HOME IN SOLACE, A BRAVE BAND GATHERS IN PREPARATION FOR A GRIM JOURNEY..." appears, paginated. It is written over the menu because the exploration frame is not yet drawn by the loop.
- **Stop:** it stops at command $3D, an H012 handler (next step).
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** the ECL handlers of H012 (26) and the exploration loop H012+$3150.

---

## 2026-11-10 (cok-port-35)

**Request:** "ok it compiles on sasc, proceed with the ECL commands of H064". The H064 commands were already in cok-port-34, so this step ports the ECL commands of H012.

**Ported ECL commands of H012** (25 out of 26, in `h012.c`, connected to the `ecl_execute` dispatcher)
- **Party and characters:**
  - $1E PARTY SURVEY ($01FA): minimum, maximum and average over the party (level, values +$E0.., speed) or presence of an effect;
  - $22 ($05D6): is there a ranger/healer (class 4 or $A);
  - $32 ($1E90): somebody carries an item of the given type;
  - $3B ($2596): looks for a memorised spell (position and character);
  - $3F ($2AF6): the current character has the given effect;
  - $40 ($2B64): takes the items of the given type away from everybody;
  - $39 ($2486): chooses the current character;
  - $36 ($2502): adds an NPC with its AI;
  - $3E ($2ABE): the current character leaves the party;
  - $41 EXPERIENCE ($2C28): experience points divided among the classes.
- **Encounters and combat:**
  - $23 SURPRISE ($0688);
  - $24 COMBAT ($0766): combat (H059) or special scene, then context 3/4 and redraw;
  - $29 ENCOUNTER ($15AE): COMBAT/WAIT/FLEE/PARLAY or ADVANCE, approach, "Both sides wait.", "The monsters flee.";
  - $2C PARLAY ($1DDE): HAUGHTY/SLY/NICE/MEEK/ABUSIVE;
  - $2E DAMAGE ($1F68): damage with saving throw or to-hit roll, "The entire party is killed!".
- **Treasure:** $27 TREASURE ($0BEA): coins and items from the block of ITEMn.DAX ($3F-byte records) or random (H012 tables).
- **Flow and screen:**
  - $25 ON GOTO and $26 ON GOSUB ($0B18);
  - $2D ($26D6): special actions (view, animation, sound, wall, step forward);
  - $31 ($2358) closes the pictures, $33 ($23D6) newline, $34 ($2392) advances the time, $3A ($1F4C) pause, $3C ($2AAE) nothing;
  - $3D ($241C): redraws the exploration screen;
  - $38 ($29A6): party menu (H013+$4BFC) or camp ($2922, ported as well).

**Ported helpers**
- **H031+$008A:** signed byte.
- **H062+$126C:** to-hit roll of the ECL commands.

**Where I deviate from the asm (all documented in the code)**
- **PARLAY without a valid choice:** the original reads past the five values; here 0.
- **EXPERIENCE with no class:** the original divides by 0 (68000 exception); here no points.
- **$3C:** the original does not advance the PC (it would repeat the command forever); left identical.

**Still stubs**
- **$28 ($14C8):** uses the H015 reals and H061+$3C4C (money), not yet ported.
- **New stubs:** H042+$0300, H070+$1958, H071+$092C, H072+$120C, H066+$276E, H067+$1292, H057+$2F3A.
- **Exploration loop:** H012+$3150, and H011+$04A6 (the game loop), which NEWECL reaches.

**Tests with the real data** (temporary test, not committed)
- **How:** the ECL programs of 10 areas of ECL1.DAX ($10, $11, $12, $20, $21, $22, $24, $30, $31, $32) run by `run_ecl` with the ASan binary; only in the test the picture and sound stubs were non-fatal.
- **H012 commands run:** $25 ON GOTO, $2D special actions, $38 party menu, $3D redraw, besides those of H064.
- **Stop:** the areas reach NEWECL and the game loop H011+$04A6 (not ported); $11 and $12 stay in the party menu waiting for keys.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** the exploration loop H012+$3150 and the game loop H011+$04A6.

---

## 2026-11-11 (cok-port-36)

**Request:** "ok it compiles on sasc, proceed with the exploration loop". Together with it came the SAS/C log (smake.err) of cok-port-35: compilation and link succeeded, with 7 warnings, fixed here.

**Exploration loop (H012)**
- **$3150 `explore_loop`:**
  - Loads the ECL program of the area ($3E04+$1E4; $24 at the start, $39 in the demo) and runs the entry $3DEC.
  - Then it repeats until the party is lost ($24D0):
    - command menu;
    - Encamp ($2922);
    - search and look (a pass of $3DF2 with $594 = 1);
    - the step, followed by the entries $3DF2/$3DF4;
    - the changes of area.
  - At the end it removes everybody from the party.
- **$3020 (static `enter_area`):** entry into a new area after NEWECL. Frees the pictures and runs $3DEC, $3DF4 and $3DF2 until a command asks for another area.
- **H011+$04A6 `set_view_start`:** stores the four starting bytes of the view. Before it was the stub `h011_04a6`.
- **`h001_main.c`:** now calls `set_view_start` and `explore_loop` instead of the stubs.

**H068 ported entirely** (exploration, menu, steps and doors)
- **$0C0E `explore_command_menu`:**
  - in the dungeon: "Move Area Cast View Encamp Search Look"; in Move the arrows give step, turns and about-face;
  - outdoors: "Move Encamp"; in Move the 8 directions of the keypad;
  - "Area" shows the map (outside the area the word at $2358 in argv[2] is needed); otherwise "Not Here".
- **$122E `explore_move_or_door`:** free step or closed door ("Locked. " with Bash/Pick/Knock/Exit); outdoors the step on the big map.
- **Helpers:**
  - $00CA opens the door (GEO plane 3);
  - $00B2 empty in the original;
  - $02B8 class in the party;
  - $0340 Bash (strength tables);
  - $0748 Pick (+$E1);
  - $082A/$0890/$08E2 Knock (spell $1F);
  - $0932 exit from the edge of the map;
  - $0A1A step in the dungeon;
  - $0B2C step outdoors.

**Others ported**
- **H069+$0012 and $00A8:** party marker on the outdoor map (draws and restores the background). Before it was the stub `h069_0012`.
- **H029+$0E26 and $0E92:** save and restore a cell of the screen in the record.

**Where I deviate from the asm (all documented in the code)**
- **Outdoor menu with $3E04+$3EE null:** the original returns an uninitialised byte; here 0.
- **Area command:** the original reads argv[2] in any case; here only if it exists (as in H013).

**Fixes**
- **Superfluous stub in cok-port-35:** the stub `h042_0300` was useless, because H042+$0300 had already been ported as `release_picture_set`. COMBAT now uses that.
- **SAS/C warnings of cok-port-35:**
  - 85, return value of type int: h048 `shape_cell`/`combatant_index`, h095 `place_in_spiral`. Casts added.
  - 217, macro that calls a function several times: h048 `combatant_x`/`combatant_y`, h063 lines 1130-1131. The index is read once into a variable.

**Still stubs**
- **H011+$0B78:** 3D view of the dungeon.
- **H057+$0C04:** spell casting.
- **H042:** pictures.
- **H060+$0018:** redraw of the view.
- **H066+$1FDA:** used by a dungeon event.

**Tests with the real data** (ASan test binary, not committed)
- **How:**
  - non-fatal picture, sound and view stubs;
  - keys sent when a menu is waiting;
  - log of the menus.
- **Town:** "Begin adventuring" leads into the loop. Solace shows the ECL menu "Inn Hall Commandant Armoury Next Leave".
- **Outdoors:**
  - Leave does NEWECL into area $10 (context 3) and the command menu "Move Encamp" appears;
  - Move and the arrows move the party marker;
  - the new square starts the real event ("As you top a rise, you spot a caravan under attack...").
- **Dungeon** (start forced in area $30, context 4):
  - "Move Area Cast View Encamp Search Look" appears;
  - from 7,13: up → 7,12; right + up → 8,13 facing east; left twice + up → 7,13 facing west; about-face + up → 8,13;
  - Search and Area respond;
  - an event further on stops at H066+$1FDA (not ported).
- **ASan:** clean in all the tests.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** the 3D view of the dungeon (H011+$0B78 and helpers), the redraw H060+$0018 and the pictures of H042.

---

## 2026-11-11 (cok-port-37)

**Request:** "ok it compiles on sasc, proceed with the 3D view of the dungeon". During the work the question "should I now be able to do begin adventuring on a map that is not drawn?" arrived.
- **Answer:** with cok-port-36, no. The picture stubs (H042) were fatal, so the game stopped at H042+$10DC right after the start, and the GEO map was not loaded. This delivery solves both things.

**3D view and maps (H011)**
- **$1876 `load_geo_map`:** loads the GEOn.dax map: four planes of $100 bytes in $282A, registered in $3E04+$18A. If it is missing: "Unable to load geo in Load3DMap.".
- **$14EA `load_wall_defs`:**
  - loads the WALLDEFn.dax definitions into positions 1..3 of the buffer $282E (blocks of $30C bytes, five walls of $9C tiles);
  - moves the tiles from $3EBC upwards to the set of the position;
  - loads the 8x8 sets (id*10+k if the block has more than one) and remembers id and position in $2810;
  - if it is missing: "Unable to load nnnn from WALLDEFn".
- **$0B78 `draw_3d_view`:**
  - with the map active ($2825) it draws the map from above;
  - otherwise it draws the background and the walls of the squares at distance 2, 1 and 0, from the back towards the party, with the pieces 0..9 (front, side and joints);
  - at the end it shows the buffer and reloads the palette.
- **Helpers:**
  - $0868: piece of wall, rectangle of 8x8 tiles from the tables of the module; tile 0 is transparent;
  - $058E: sky of colour $2829, sun according to time and direction, picture towards north, floor;
  - $0330: 11x11 map from above.
- **H049+$0014 `draw_8x8_tile_masked`:** 8x8 tile with the mask of the set.
- **H060+$0018 `refresh_view`:** chooses the sky colour from the local table ($3E04+$1FA/$1FC according to bit 7 of the square), removes the map if the area forbids it ($1F6) and redraws the view; outdoors it redraws the picture (H042+$10DC).
- **H010+$0360 `console_writeln`:** the writeln of the runtime (H020) on the console, here with stdio. Before it was a fatal stub, also used by H035.

**Where I deviate from the asm (all documented in the code)**
- **Sky colour:** an index past the table would read the stack; here 0.

**Pictures (H042) non-fatal**
- **Which:** $0254, $0406, $0B80, $0D70, $0ED2, $0F50, $1006 and $10DC are now skipped with a message on the console, like the H043 audio already.
- **Effect:** you can explore without the event pictures.
- **Still fatal:** the non-graphic routines, for example Cast (H057+$0C04), Encamp (H057+$2F3A) and H066+$1FDA.

**Tests with the real data** (ASan test binary, not committed)
- **How:** the entry of area $30 exits right away without LOAD FILES (it depends on the game state), so for the test GEO 48, WALLDEF 1 (positions 1-2, 8x8 sets 11 and 12) and WALLDEF 23 (position 3) are loaded.
- **3D view:**
  - shows sky with clouds towards north, cobblestone floor, stone walls and wooden doors at three distances;
  - turning and walking (7,13 → 7,12 → 8,12 → 7,12 → 6,12) it changes consistently;
  - in front of the buildings the ECL events fire: "YOU SEE A SIGN. GARGATH INN", "THE TRENCHER TAVERN".
- **Area:** shows the map of the town from above with the party arrow.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** the pictures of H042 (events, portraits, big picture and outdoor map), then Cast (H057+$0C04) and Encamp (H057+$2F3A).

---

## 2026-11-11 (cok-port-38)

**Request:** "ok it compiles on sasc, proceed with the pictures of H042".

**H042 ported entirely** (the remaining routines)
- **$0406 `load_sequence` (Load_Sequence):**
  - loads a sequence (PIC, FINAL, SPRIT and others) from name+disk.daa into the set $27BC;
  - directory: word of the size, then 6-byte entries (id, one byte, long offset);
  - ByteRun1-compressed header: rows, units, w4, w6, frames, 32-colour palette for $52AE, compressed sizes;
  - the first frame goes into `g_pic_rec_27c2`; with two frames the second goes straight into `g_pic_rec_27c6`, stored as an XOR with the first; with more frames they stay compressed in `g_pic_buffers`;
  - PIC and FINAL have no transparency and, without $24D4, a single frame;
  - shows "Loading...Please Wait" if $24D4.
- **$0B80 `sequence_frame`:** returns the record of the frame. The first and the last decoded are returned after a pause of 11 ticks; the others are decompressed and combined by XOR with the first.
- **Portraits and sprites:**
  - $0D70 `load_head_body`: HEAD/BODYn.daa, only if they change;
  - $0ED2 `draw_head_body`: head, and the body 5 cells below ($02B2/$02D6);
  - $0F50 `show_3d_sprite`: frame 1..3 masked into the view; out of range "Illegal range in Show3DSprite." and exit.
- **Big picture and outdoor map:**
  - $1006 `load_big_picture`: BIGPICn.daa into $2798, with the palette in $526E;
  - $10DC `show_big_picture`: the picture in the outdoor frame;
  - $0254 `show_picture`: record in the cell (x, y) with the palette $52AE.
- **Static helpers:** $01AE mirrored copy of the record; $03BC XOR between bitmaps.

**Others ported and exported**
- **H020+$085A `console_write` and $082E `console_newline`:** write/writeln of the runtime, here with stdio. `console_writeln` (H010+$0360) now uses them.
- **Already ported, now public:** `dax_open` (H028+$0B80) and `transfer_gfx_planes` (H029+$091E).

**Where I deviate from the asm (all documented in the code)**
- **More than 6 frames:** they would read past the $56-byte header; here at most 6.
- **Randomly mirrored pictures:** faithful to the original. The flag $-2 of H042 comes from H023+$0010 (random number 0/1) and, if it is 1, the records are mirrored horizontally.

**Tests with the real data** (ASan test binary, not committed)
- **Test sequencer:** it now sends a key for every new menu.
- **Pictures seen:**
  - at start-up, the big picture of the Solace inn with the text;
  - the map of Krynn with the places (BIGPIC) and the party marker;
  - the portrait of Sir Karl (PIC);
  - the street of Solace above the town menu;
  - outdoors, the picture of the caravan attacked by the draconians.
- **Stop:** right after, the game stops at H066+$1FDA (not graphic).
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** H066+$1FDA (outdoor encounter), then Encamp (H057+$2F3A) and Cast (H057+$0C04).

---

## 2026-11-11 (cok-port-39)

**Request:** "ok it compiles on sasc, proceed with H066+$1FDA".

**Ported: H066+$1FDA (Load_MonsterRecord)** — `load_monster_record(id, c)`, body at $206A, called by LOAD MONSTER through `load_monster` of H061.
- **Monster record (MONnCHA.dax), in PC format:**
  - name (15 characters);
  - 15 blocks copied to shifted positions;
  - six signed bytes widened to words (+$58, +$116, +$118, +$18A, +$1A4, +$1A6);
  - words and longs byte-swapped (+$62, +$11E, +$13C, +$F0..+$FC, +$18C).
- **Pointers:** those of the record (effects, items, next, turn block) are cleared.
- **Error:** if the record is missing, "Unable to load monster" and exit.
- **Effects (MONnSPC.dax):** 9-byte entries.
- **Items (MONnITM.dax):** $3F-byte records, converted as in the TREASURE command.
- **$24A4:** is 1 during the loading of effects and items.
- **Helper:** $1FE8, file name "MON" + disk + part.

**Where I deviate from the asm (documented in the code)**
- **Ready items (+$154..):** in the original the bytes of the file stay there; here they are empty.

**Tests with the real data** (ASan test binary, not committed)
- **Monster loaded:** after the caravan picture, LOAD MONSTER loads monster 1, "BAAZ" (the draconian), with one effect.
- **Stop:** the game reaches combat and stops at H096+$02CE (combat AI, not ported).
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** the H096 routines used by combat (monster AI), then Encamp (H057+$2F3A) and Cast (H057+$0C04).

---

## 2026-11-11 (cok-port-40)

**Request:** "ok it compiles on sasc, proceed with the routines of H096".

**H096 ported entirely** (34 routines: combat actions, attacks, aiming and spells)
- **Start of turn:**
  - $02CE `combat_prepare_turn`: turn block, initiative (d6 + dexterity, -6 if surprised), movement points;
  - $11D4 `combat_attacks`: attacks of the round, with the rate of the ranged weapons;
  - $0200 rounding;
  - $023E movement.
- **Movement:**
  - $099C `combat_step`: step with the cost of the terrain;
  - $0C3C `combat_leave_attacks`: attacks on whoever moves away from an enemy;
  - $08B2 attacks of opportunity;
  - $10FA `combat_flee`: "Got Away" or "Escape is blocked".
- **Attack:**
  - $2182 `combat_attack`: facings and figures, projectile, resolution, ammunition; thrown weapons that run out end up in the treasure after the last one thrown, new global `g_thrown_tail` ($335C);
  - $1BE0: rolls, damage and messages, "slays helpless";
  - $0434 damage, with the backstab ($3358);
  - $0530 messages ("Hitting for n points of damage", "and Misses", "goes down", "is killed", "lost a spell");
  - $251C range penalty;
  - $1340 `combat_sweep` (sweep);
  - $20E6 `record_attack`;
  - $1562 can attack;
  - $3492 animation of the projectiles by weapon type.
- **Turn Undead ($160A):** local 7x13 table generated from the asm instructions, with the same anomalies as the original; $1B04 finds the undead.
- **Aiming:**
  - $4448 `aim_target`, with the nested $4456 and $4530: Next/Prev/Manual/Target/Center/Exit;
  - $39D0 "Range =" line and menu;
  - $3DBA manual cursor;
  - $3C48 confirmation and attack;
  - $38DC `confirm_attack` ("Attack Ally:").
- **Spells in combat:**
  - $3100 `combat_cast` ("Begins Casting" and reordering of the turns);
  - $2A6C `combat_spell_targets` (vector $276C): single, multiple, hit-dice and area targets;
  - $284C target;
  - $25DA healing target;
  - $4B86 AI target.
- **Others:** $3852 movement of the enemies; $4DE8 always 0.
- **New structure:** `CokAim` (aiming: character, x, y) instead of the byte buffer in H059.

**Others ported**
- **H033+$11FC `spell_range`:** range of the spell.
- **H046+$0012 `cursor_direction`:** direction key towards the cursor. Move in combat needed it.
- **H063+$1FDC:** `copy_sprite_frame` is now exported.

**Where I deviate from the asm (all documented in the code)**
- **Missing ready weapon:** the original reads +$30 from address 0; here the check is skipped.
- **Turn Undead outside the table:** an index past the table reads the stack; here it is $6363 (never succeeds).
- **Spell targets, none chosen:** the original reads the entry before $2520; here the position stays as before.
- **Aiming:** with the empty list it stays on the one aiming; with Manual on an empty square it does not read from NULL.

**Tests with the real data** (ASan test binary, not committed)
- **Stop without AI:** the caravan combat starts and stops at H097+$1D68 (monster AI, not ported).
- **Test with the AI skipped:**
  - the turn menu "Move View Aim Use Done" appears;
  - Move moves the character on the map (Move Left 12 → 8);
  - Aim shows "Range = n" and "Next Prev Manual Center Exit" and cycles through the targets;
  - Target does not appear because the draconians are out of range.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** H097, the monster AI (13 routines, about 2000 lines of asm).

---

## 2026-11-11 (cok-port-41)

**Request:** "ok it compiles on sasc, proceed with H097".

**H097 ported entirely** (AI of the computer-controlled combatants)
- **$1D68 `monster_turn`:** the turn of the monster, in this order:
  - keys;
  - movement sequence (+$17);
  - morale ("flees in panic");
  - magic item;
  - spell in progress;
  - Turn Undead;
  - spell;
  - choice of the weapons;
  - attack or end of turn.
- **$00B0 keys during the monsters' turn ($5305):**
  - '2' "Magic On/Off";
  - space takes the automatic control away from the party;
  - 4 calls H096+$4DE8.
- **Morale and end of turn:**
  - $043A: "is forced to flee", rolls against wounds and group strength, flight (removing the effects $4A/$4B) or "Surrenders";
  - $0244: end of turn or guard.
- **Items and spells:**
  - $0620 with the nested $062E: is the spell useful? (enemies in range, no ally hit by the area);
  - $0890 magic item;
  - $0A04 Turn Undead;
  - $0A88 memorised spell.
- **Weapons:** $0C14 choice (thrown or ranged with ammunition, melee, shield, hands +$188); $02B2 value of the weapon.
- **Movement:**
  - $142C step towards the target or in flight, with the sequences of the module's table; "Move/Attack, Move Left = n";
  - $11EE is the step possible? (cost, clouds, acid).
- **$18D2 attack:** target in range in sight or a nearby enemy, sweep or normal attack.
- **Exported for H097:**
  - from H096: `movement_points`, `can_attack`, `find_undead`, `find_heal_target`, `enemy_distance_points`, `ai_pick_target`;
  - from H065: `use_item`.

**Fixes found while playing**
- **H048 `combatant_falls` (porting bug):** the global `g_gfx_3304` was never loaded.
  - Cause: $3304 is slot $18 of the sprite set table $3244, that is `g_sprite_sets[0x18]`, not a separate global.
  - Effect: ASan reported a NULL access when a combatant fell.
  - Fix: the global was removed and the code uses the table.
- **Host (`host/graphics.c`):** AllocRaster allocates 4 bytes more.
  - Cause: the emulated blitter, with a source not aligned to a word, reads one word past the end of the last row.
  - On the Amiga that read is harmless; here ASan reported it when redrawing the square of the fallen body.

**Where I deviate from the asm (all documented in the code)**
- **H097+$0620:** where the original returns a register that was not set, here 0.
- **H097+$0A04:** the maximum type passed to H096+$1B04 is not initialised in the original; here $FF.
- **H097+$043A:** with maximum hit points at 0 the original divides by 0; here the monster counts as unhurt.
- **H097+$18D2:** the NULL target is not read.

**Tests with the real data** (ASan test binary, not committed)
- **Caravan battle,** with "Done → Guard" at every turn of the player:
  - the Baaz come closer (Move Left 12 → 4);
  - they attack ("Baaz attacks L, hitting for 4 points of damage", "and misses", "(from behind) hitting for 5 points");
  - L's hit points go down from 12 to 5.
- **Stop:** at the end of combat the game stops at H070+$1958 (scene after combat, not ported).
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** H070+$1958 (end of combat), then Encamp (H057+$2F3A) and Cast (H057+$0C04).

---

## 2026-11-11 (cok-port-42)

**Request:** "ok it compiles on sasc, proceed with H070+$1958".

**H070 ported entirely** (end of combat)
- **$1958 `combat_end`:**
  - the dropped items go back to whoever had them ($18BE);
  - outcome ($0778): defeat $24D0, victory $24C0, flight; the combat effects are removed; whoever had fled or fainted gets up again; whoever is gone leaves the party;
  - the enemies are removed from the party ($152E);
  - if the party is still there:
    - shares of the NPCs, "takes and hides his/her share" ($165C);
    - outcome screen ($0B9E: "The party has fled.", "You have lost the fight.", "The party has won.", "Each character receives n experience points.");
    - treasure screen ($1136);
  - if the party is destroyed: "The monsters rejoice for the party has been destroyed.".
- **Experience:**
  - $0280: value of the defeated enemies; their coins into the pool and their items into the treasure; value of the pool and of the magic items; divided among the characters;
  - $0558: assignment with 10% for the prime requisite of the class, half or a third to multi-class characters.
- **Treasure:**
  - $1136 View/Take/Pool/Share/Detect/Exit menu, with confirmation if treasure is left;
  - $0F8A Take (Money/Items);
  - $0E94/$0DE0 "Items:" list and Take.
- **H067:**
  - $0794 Pool;
  - $086E;
  - $08CC Share (within the load limits);
  - $0D0A;
  - $0F72 Take Money ("Select type of coin", "How much ... will you take?");
  - $11F4 is there treasure?
- **H071+$047C `take_item`:** the current character takes the item, unless "OverLoaded".
- **H006+$0914 `reset_game_state`:** clears the state for a new game, called by `h001_main` after the exploration.
- **Exported:** `item_overloads` (H065+$32F6). For the treasure list a list of menu entries is built, as in H065.

**Where I deviate from the asm (all documented in the code)**
- **Experience with divisor 0:** the original raises an exception; here the total.
- **Share without player characters:** the original divides by 0; here no division.
- **Removal from the party (defeat):** where the original reads the next pointer of a character already removed, here it reads it before.
- **Take Money:** the list is also freed when leaving without a choice.

**Tests with the real data** (ASan test binary, not committed)
- **Defeat:** the caravan battle (L alone against the Baaz) ends with the party destroyed.
  - "The monsters rejoice for the party has been destroyed." and "Press any key to continue" appear.
  - The state is cleared and the game starts again from the manual check.
- **Not tried:** the victory branch (experience, treasure, Take, Pool, Share), because a single character does not win this battle.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

**Next step:** Encamp (H057+$2F3A) and Cast (H057+$0C04).

---

## v43: Encamp (H057+$2F3A) and Cast (H057+$0C04)

**Ported**
- **h057.c** (the whole module except the initialisation, already present):
  - $2F3A `encamp`: menu "Save View Magic Rest Alter Fix Exit" in context 2; on exit it reloads the PIC picture of the zone and cancels the pending study;
  - $0C04 `cast_spells` (Cast), with $0AE0 (can magic be used?);
  - Magic menu ($1DD8): Cast, Memorize ($1342), Scribe ($1590), Display ($18D6, list of the effects with the nested procedure $18E4), Rest ($11AC);
  - $05B4 study time, $078E/$07E8/$0878 cancel the pending study, $08B4 free slots, $0CD4 table of the slots and bonus spells, $126C sorting;
  - Alter menu ($27B2): Order ($220E with $1EE0, $1FD6, $20A0), Drop ($2368), Speed ($25AE), Icon, Pics, Level ($24AE);
  - Fix ($29DA with the nested $29E8, $2A06, $2AFE, $2BBA, $2C08, $2DC8).
- **h058.c:** resting:
  - $1014 `rest_party` (in steps of 5 minutes, can be interrupted, with random encounters);
  - $05F4, $070E, $084C ("Rest Time" line), $09AA (menu "Rest Days Hours Mins Add Subtract Exit");
  - $0B84 (heals every $120 steps), $0C38 and $0D2C (memorises and scribes), $0E80, $0F5C.
- **H044+$0492 `draw_memorize_frame`:** frame of the choice of the spells to memorise, which Memorize needed.
- **Callers connected:** `ecl_camp_entry` (H012) calls `encamp`; the dungeon menu (H068, 'C') calls `cast_spells`. The stubs h057_2f3a, h057_0c04 and h044_0492 removed.

**Where I deviate from the asm (documented in the code)**
- **Fix, H057+$2C08:** the local counter -$2(a5) is not initialised in the original; here it starts from 0.

**Tests with the real data** (ASan test binary, not committed)
- **Path:** Leave, then Encamp from the "Move Encamp" menu.
- **Magic:**
  - Memorize: spellbook with the table "Cleric Spells 3 / Special Spells 1", choice of Resist Cold, confirmation;
  - Display: "<No Spell Effects>";
  - Cast: no spell ready;
  - Scribe: "has no copyable scrolls".
- **Rest:** "Rest Time 00 04 15", plus 2 hours with Hours/Add; after the rest the time is 06:15 and "L has memorized Resist Cold" appears.
- **Other:** Alter, Save (choice of the game), leaving the camp and coming back.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **Not tried:** Fix with the party wounded, Drop and Order with several characters.

---

## v44: H066+$276E (adds an NPC to the party)

**Ported**
- **H066+$276E `add_npc`:** if the party has no more than 7 members (state B +$67C), it allocates the character, loads the npc monster record (H066+$1FDA), writes the number into +$11C, adds it to the party (H066+$27EE) and loads the npc "CPIC" icons into its slot (+$143, H035+$0246).
- **Caller:** the ECL command $36 (`ecl_add_npc`, H012+$2502) calls `add_npc`; the stub h066_276e removed.

**Tests with the real data** (ASan test binary with a temporary hook, not committed, which calls `add_npc(1)` when entering the camp)
- The Baaz (record 1) joins the party as the second member and becomes current; View shows its sheet (Fighter level 2, 9/9 hit points, Steel 5).
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

---

## v45: H067+$1292 (random item)

**Ported**
- **H067+$1292 `random_item`:** creates a random item of the given type for the random treasure of the ECL commands.
  - **Weapons, armour and similar** (types $01..$25, $32, $3B, $46, $47; part $144E): bonus +1 (90%) or +2 from $125A, name, weight (+$3E) and value (+$42) by type.
  - **Scrolls $27 (MU, red or white) and $28 (cleric)** (part $17FA): 1..3 spells from the word tables of H005 ($1476..$1552).
  - **Special items** from the local template of 7 records (-$7C(a5)): potions ($30, $35), wand ($34), and the special javelin (type 7, 1 in 5).
- **Caller:** the random treasure of the ECL commands (H012) calls `random_item`; the stub h067_1292 removed.

**Tests with the real data** (ASan test binary with a temporary hook, not committed, which generates every type from 1 to $47 three times and builds its name)
- Weapons and armour with weight and value by type (Plate Mail 450/2500, Arrows 4/75, Bracers bonus 4 and 6000).
- "Red MU Scroll" and "White MU Scroll" with 2-3 spells; "Cler Scroll 1/2/3 Spells"; Potion; Wand; Ring; the special javelin (value 1500).
- The types without a branch stay empty, as in the original.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

---

## v46: H071+$092C (the shop)

**Ported**
- **H071+$092C `shop`:** the shop (context 1), menu "Buy View Take Pool Share Appraise Exit" ("Buy View Pool Appraise Exit" if the pool is empty). When leaving with money in the pool the shopkeeper asks you to come back for it (H030+$0302, H061+$36E6).
- **H071+$0572 Buy:** price = value scaled by the highest bit of the low byte of g_state_b +$6DA; the character pays (all in steel, H067+$032A) or the pool does (H067+$02AE/$0374); "<name> buys (a) <item>", "Not enough Money.".
- **H071+$012A:** "Items:" list with the prices right-aligned on 30 columns; the names are rebuilt afterwards. As in H070, a list of entries with the same names is used for the list menu.
- **H067+$1D7C `appraise_gems` (Appraise):** appraises gems and jewellery one by one; Sell or Keep.
- **H067+$03BC:** the character receives the steel; if overloaded the rest goes into the pool.
- **Exported:** `wealth_in_steel` (H065+$347E).
- **Caller:** the ECL command of the shop (H012) calls `shop`; the stub h071_092c removed.

**Where I deviate from the asm (documented in the code)**
- **Buy:** if g_state_b +$6DA has no bit set the original uses an uninitialised index; here 0.
- **List:** an empty name would make the original copy 64K bytes; here nothing.
- **Same as the original, worth noting:** with Keep, if the character has no items the gem created is not linked (it stays only in the local variable).

**Tests with the real data** (ASan test binary, not committed)
- **Armoury** from the initial menu: list of the items with the prices (Ring Mail 8, Short Bow 10, 1 Diamond 500).
- **Buy** of the Ring Mail: "L buys a Ring Mail".
- **Appraise:** "No Gems or Jewelry". View and Exit.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **Not tried:** Appraise with real gems, leaving with money in the pool.

**Fix for SAS/C (warning 94 in h070.c, line 754):** in `combat_end` the variable `special` was never assigned and only served the `(void)`; the declaration and the `(void)` removed.

---

## v47: H072+$120C (the temple)

**Ported** (h072.c, the whole module)
- **$120C `temple`:** menu "Heal View (Take) Pool (Share) Appraise Exit" in context 1; when leaving with money in the pool a priest asks whether you will come back for it.
- **$0EBE Heal:** list of the cures ("<name>, how can we help you?", "Heal Exit").
- **$0312:** "cast cure anyway: " when the character does not need it.
- **$036C:** "<cure> will only cost N steel pieces." and "pay for cure"; the character or the pool pays, otherwise "not enough money.".
- **The cures:**
  - $050A Cure Blindness (500);
  - $05AA Cure Disease (500, the 6 effects of -$C(a4));
  - $06BC the wounds: light 50, serious 175, critical 300, Heal 2500;
  - $0910 Raise Dead (2750);
  - $0C04 Neutralize Poison (500);
  - $0D24 Remove Curse (1750, with the action of the spell in $2668);
  - $0E0A Stone to Flesh (1000).
- **Caller:** the ECL command of the temple (H012) calls `temple`; the stub h072_120c removed.

**Where I deviate from the asm (documented in the code)**
- **Heal ($06BC, case 4):** the original rolls 1d4 only if you pay, but the healing (maximum hit points minus the roll, plus the removal of the effects) happens anyway, with the variable -$2(a5) uninitialised. Here the variable is 0: without paying the character is healed completely, as would happen in the original with that value.
- **Same as the original, worth noting:** in Raise Dead the division and subtraction of the maximum hit points are repeated for each class of the character; the list has 10 entries, so "exit" does not appear.

**Tests with the real data** (ASan test binary, not committed)
- **Path:** Next, then Temple from the town menu.
- **Heal:** the list shows the 10 cures; choice of Cure Light Wounds: "Cure Light Wounds will only cost 50 steel pieces.", "pay for cure" (No).
- **Exit:** from the temple without money in the pool.
- **ASan:** clean.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.
- **Not tried:** the paid cures on a character who needs them.

---

## v48: H012+$14C8 (ECL command $28, ROB)

**Ported**
- **H012+$14C8 `ecl_rob`:** three operands.
  - The current character (first operand 0) or the whole party loses the second operand per cent of coins, gems and jewellery.
  - Each item has the third operand per cent of being destroyed (H061+$3DBE, already ported).
- **H061+$3C4C `scale_money`:** multiplies +$F0..+$FC by the share that remains, (100 - p) / 100, truncating.
- **H015+$010C/$0122/$0172/$0184:** the runtime jumps to mathffp.library (SPMul, SPDiv, SPFlt, SPFix), with the FFP numbers kept as u32 (`CokReal`).
  - On the Amiga they call the library, already opened by H015 (MathBase): no float arithmetic in C, so the smakefile does not need math libraries.
  - On the host they convert from and to FFP and compute in IEEE single precision (the same 24 bits of mantissa).
  - Register order of SPDiv (D1 divisor, D0 dividend) from the documentation at kb.marrani.lol.
- **Dispatcher:** command $28 of the H012 dispatcher calls `ecl_rob`; the stub h012_14c8 removed.

**Where I deviate from the asm**
- **Rounding on the host:** the documentation does not say how mathffp rounds, so a difference from the Amiga library is possible only in the last bit of the results.

**Tests**
- **FFP on the host** (test program): 1.0 = $80000041, 100 = $C8000047, 70/100 = $B3333340; 70% of 0, 5, 10, 15, 20 gives 0, 3, 7, 10, 14; 25% of 1234 gives 308.
- **Not tried in the game:** it needs an ECL script that uses ROB.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

---

## v49: H033+$1A40 and handlers of H085 ($15FE, $172A with $0BB2, $363E, $38AA)

**Fix for SAS/C (warning 625, "proper math library has not been included")**
- **Cause:** in v48 the jumps to mathffp in h015_runtime.c used a union with FLOAT.
- **Fix:** they now use their own prototypes with LONG and `#pragma libcall MathBase`, at the same offsets and registers as the NDK (SPFix $1E 001, SPFlt $24 001, SPMul $4E 0102, SPDiv $54 0102). No float type is left in the C for the Amiga.

**Ported**
- **H033+$1A40 `spell_no_effect`:** empty action of 18 spells of the table $25C0.
- **H085+$15FE `spell_fireball`:** d6 dice equal to the caster level (for $40: 1d3*2+1) on whoever is within 2 squares of the chosen point.
- **H085+$172A `effect_breath`** (effects $06/$53 cold, $68 fire): dragon breath.
  - Charges in +$4; choice of the target.
  - Only if all those hit are opponents: message "breathes cold/Fire", animation, damage equal to the maximum hit points of the dragon (saving throw 3).
- **H085+$0BB2 (with the nested $0BC0, $0C04, $0C62):** area of the breath.
  - The line towards the target is extended up to the length (8/7/9) and stops at the line of sight.
  - It collects the combatants along the line; with width 3 also along the two lines towards the sides of the tip, with $FF those within 3 squares.
- **H085+$363E `spell_event_9`:** effect on the target of the turn and event 9, then the handler of effect $40 if the effect was not cancelled.
- **H085+$38AA `spell_teleport`:** "teleports" to the chosen point.
- **Exported from H077:** `CokLine`, `line_init` ($01CC) and `line_step` ($0242).

**Where I deviate from the asm (documented in the code)**
- **$0BB2, distance -$114(a5):** it is not initialised in the original but it is passed to the line of sight; here $FFFF, that is no limit, because the length is already limited by the extension.
- **$0BB2, direction -$112(a5):** not initialised if the line meets nobody; here 0.
- **$0C62:** with the list of those hit full the original would write past the 30 entries; here it stops.
- **$363E:** the item passed to the handler of effect $40 is -$4(a5), not initialised; here NULL.

**Tests**
- **Caravan battle** (ASan): no errors; the handler tables are in order.
- **Not tried:** the breath, the fireball and the teleport, which do not appear in the first battle.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

---

## v50: spells of H085 ($2338, $26C0, $31B4, $33A8, $3758, $3936)

**Ported**
- **$1A6C:** the effect of the current spell on each target, from the last to the first.
  - From the second on with sound 2 and the projectile from the caster.
  - Saving throw with bonus, except for $4F/$51 on the last target; race 7 always resists $17 and $31.
- **$2338 `spell_hold_person`:** "is held", with a penalty to the saving throw that depends on the number of targets.
- **$26C0 `spell_stinking_cloud`:** "Creates a noxious cloud".
  - A record in g_clouds ($2514) and effect $28 to remove it.
  - The 4 squares become $1E if the terrain allows it, saving the previous content.
  - The combatants in the squares enter the cloud (H062+$1038).
- **$3758 `spell_charm_monster`:** "is charmed", then the handler of effect $B.
- **$3936 `spell_fear`:** cone of fear (breath area, width 3, length 6).
  - Whoever fails saving throw 4 "runs in terror" (effect $6F), flees and goes to the computer (+$EC = $B3).
  - The others "is unaffected".
- **$31B4 `spell_lightning_bolt`:** lightning bolt, caster level d6 dice (type $C).
  - $1234 hits the square and reports the walls.
  - $1306 traces the bolt for 7 squares past the point and bounces off the walls reversing the direction.
- **$33A8 `spell_bolt_20`:** discharge, 1d6+20 on the point and then 20 along 3 squares without bouncing.

**Where I deviate from the asm (documented in the code)**
- **$2338:** with more than 4 targets the penalty stays uninitialised; here 0.
- **$33A8:** the first-hit flag is not initialised and is not needed afterwards; here 0.
- **$1306:** the combatant -$42(a5) is not initialised if the line already starts on the final square; here 0.

**Tests**
- **Caravan battle** (ASan): no errors.
- **Not tried:** these spells, which do not appear in the first battle.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

---

## v51: effect handlers of H085 ($431A, $442E, $4628, $4798, $4A02)

**Ported** (range $431A..$4D1A, not classified in the source: disassembled from the raw bytes with objdump m68k)
- **$431A `effect_fireball` (effect $4E):** "throws a fireball", fireball $2F of 15d6 on the chosen target; then the effect is removed.
- **$442E `effect_poison_breath` (effect $54):** "breathes poison", in the area of radius 3 around the point (type $20).
- **$4628 `effect_lightning_breath` (effect $55):** "Breathes!", lightning bolt of 10 squares without bouncing (type $24).
- **$4798 `effect_acid_breath` (effect $5A):** "breathes acid", narrow cone (width 1, length 6; type $30), only if it hits opponents only.
- **$4A02 `effect_eye_attack` (effect $04):** acts in 75% of the turns.
  - With the charges and 25%: blinding breath on an adjacent opponent ("Breathes!", 10 or 20 damage and "is blinded").
  - Otherwise up to two "Fires An Energy Bolt!" (1d8+2).
- **Common to the breaths:** damage equal to the maximum hit points of the monster, saving throw 3, charges in +$4 (3 without $247C).
- **Status:** no stubs are left in H085.

**Where I deviate from the asm**
- **$4628:** the first-hit flag -$1(a5) is not initialised in the original; here 0.

**Tests**
- **Caravan battle** (ASan): no errors.
- **Not tried:** these monsters, which do not appear in the first battle.
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

---

## v52: H010+$03AA ('c' key, free memory)

**Ported**
- **H010+$03AA `show_free_memory`:** the debug key 'c' shows "max free block is NNNNNNNN bytes." at the top left (row 1, colour 15), with AvailMem(MEMF_LARGEST) (H003+$007E).
  - The text is in the module buffer -$52(a4).
  - The stub h010_03aa removed.
- **Stubs left:** only the H043 audio ($0584, $0840, $190E), which is skipped without stopping the program.

**Tests**
- **Checks:** compilation without warnings, C89 check, MinGW x86 and x64 builds, ctest 8/8.

---

## v53: SoundX audio (H043 and H094), compiled only with COK_AUDIO

**How to build**
- **`smake`:** builds as before, without audio. The audio commands are the stubs of unported.c, which do nothing.
- **`smake AUDIO`:** also builds the audio. The six modules involved (h043_audio, h079, h090, h092, h094, unported) are compiled with `DEFINE=COK_AUDIO` into separate `*_a.o` objects (OBJNAME), so the two builds do not mix; then it links `cok`.
- **Host:** `make AUDIO=1` compiles with `-DCOK_AUDIO` in build-audio/.

**Ported** (all inside `#ifdef COK_AUDIO`)
- **H043, loading and management** (SMUS/8SVX "SoundX" player):
  - $0584 start-up: SOUND/periodTable with $80 periods and $40 durations; two ports; audio.device with the channel mask $F; 16 CMD_WRITE requests made free with ReplyMsg; VBlank server that starts the software interrupt;
  - $0840 shutdown;
  - $190E commands: $FF stops, 0/1 disables/enables, $FE frees and reloads, $FD preloads sounds 1..$16, otherwise plays sound number n;
  - $113E loads an object by name from SOUND/name or from SOUND/soundData (FORM SMUS, 8SVX, INST, ENVL, with optional NAME);
  - $0986/$0BB2/$0D84/$0D3A the IFF parsers, $04B6 and following the freeing, $0F50/$1058 the active/loaded lists, $15C6 stop, $165A the error "SoundX is quiting".
- **H094, the player** (hand-written assembly in the original):
  - $0006 VBlank server (Cause); $0016 software interrupt (tempo clock);
  - $0108/$0188/$01BE reading of the SMUS tracks: notes, rests, ties, chords, instrument change $81, volume $84, end $FF;
  - $0288 start of a note: octave from the period, or samplesPerSec;
  - $0390 single 8SVX/INST sounds;
  - $003A assignment of the 4 voices (the one closest to the end with ADCMD_FINISH);
  - $04A4 PTCH/VLUM envelopes and CMD_WRITE requests (initial part 1 cycle, repeated part endless) and ADCMD_PERVOL;
  - $0738 free notes.
- **Exec adapters:** H079 (AddIntServer, Disable, Enable, RemIntServer), H090 (OpenDevice, CloseDevice), H092 (NewList).
- **H020+$08C2 `console_write_int`:** right-aligned integer, for the error message; always compiled.

**Host (only with COK_AUDIO, silent for now)**
- host/ndk.h has the Exec types that are needed (Node, List, ports with a queue, IORequest, IOAudio, Interrupt).
- host/audio.c:
  - OpenDevice succeeds; BeginIO completes the request immediately (it goes back to the reply port);
  - the VBlank server runs at 50 Hz from the display refresh, never between Disable and Enable;
  - Cause runs the software interrupt immediately.
- GetMsg/ReplyMsg also handle ports other than IDCMP.

**Where I deviate from the asm (documented in the code)**
- **Reply port of the opening in $0584:** local variable not initialised in the original; cleared here.
- **INS1 name $28 bytes long:** in the original it is not terminated; here the buffer starts cleared.
- **VHDR longer than $14 bytes:** here $14 bytes are read and the rest is skipped, instead of writing past the record.
- **Notes without an instrument (H094 $0288):** here they stay silent; the original would read from null addresses.
- **samplesPerSec 0 in $0390:** the original would divide by zero; here the quotient stays the dividend.
- **Instrument change $81 with an index equal to the number of instruments:** the original reads past the table; here the index is limited to 0..7.

**Tests with the real data** (ASan, `make AUDIO=1`, silent audio)
- **Loading:** periodTable and the 55 objects of soundData (waveforms, envelopes, instruments IN1..IN7, samples, the KRYNN song); $FE frees and $FD reloads.
- **Playback:** during intro and battle the player sends 358 requests (83 CMD_WRITE, 192 ADCMD_PERVOL, 83 ADCMD_FINISH), with periods and lengths consistent across the octaves.
- **Bug found and fixed:** the 4-byte IFF identifiers were not terminated; in the original the following byte is a variable cleared on purpose.
- **ASan:** clean.
- **Checks:** the host builds with and without COK_AUDIO, the C89 check with and without COK_AUDIO, MinGW x86 and x64 and ctest 8/8 are clean.
- **Not tried:** the real Amiga (`smake AUDIO`) and real sound on the host (SDL emulation of Paula: next step).

---

## v54: sound on the host (audio.device emulated with SDL2, only with COK_AUDIO)

**Status of the port**
- The game stubs are finished; in unported.c only the audio ones remain, used without COK_AUDIO.
- The 25 routines without a PORT marker are nested procedures already included in their callers (H066+$292C, H085+$3EE2), trampolines (H012, H013, H043, H061, H074) and runtime bodies that the C already has (H002, H015, H020, H045, H049 blitter, H074, H075).

**Ported** (host/audio.c, only with `make AUDIO=1`; the Amiga build uses the real audio.device)
- **audio.device** as the 4 channels of Paula:
  - a queue of CMD_WRITE per channel (signed 8-bit data, length, period and volume with ADIOF_PERVOL, cycles: 0 = endless);
  - ADCMD_PERVOL changes period and volume of the sound in progress;
  - ADCMD_FINISH interrupts the sound in progress and starts the next one in the queue;
  - CMD_FLUSH empties the channel.
- **Mixer** in the SDL callback at 44100 Hz stereo: PAL clock 3546895 Hz, volume 0..64, channels 0+3 on the left and 1+2 on the right.
- **Finished requests:** they go back to their port only in the main thread (BeginIO and VBlank), under the SDL audio lock.
- **Without SDL audio:** the requests complete immediately, as in v53.
- **Host-only difference:** removing the VBlank server (command $FE, shutdown) empties the channels, because H043 frees the samples right away. Paula would keep reading them without harm; the host callback would not.

**Tests** (ASan, SDL "disk" driver that writes the audio output to a file)
- **Intro without keys:** the KRYNN music plays for 44 seconds straight (average RMS about 6000). The dominant frequencies are notes: 328 Hz (E4), 390 (G4), 490 (B4), 519 (C5), with the odd harmonics of the square waves.
- **Intro skipped and battle:** music at start-up and then the sounds of the battle.
- **ASan:** clean.
- **Checks:**
  - host build without audio and with `make AUDIO=1` without warnings;
  - C89 check with COK_AUDIO;
  - MinGW x86 and x64 (also the syntax check with COK_AUDIO and the SDL headers);
  - ctest 8/8.

---

## v55: testing of the paths never tried (no code changes)

**Victory in battle** (caravan battle; temporary test hook, not committed: every hit downs a monster, the character takes no damage; L on Auto)
- **End of the battle:** "Continue Battle:" appears when the enemies left are 0 ($2A1D, H059+$15EE); with No the battle ends.
- **Experience:** "The party has won. Each character receives 652 experience points."
- **Treasure:** screen with the picture and "Steel 20". Take leads to "Select type of coin" and "How much steel will you take?"; then Pool and Share; the menu becomes "View Pool Exit" when nothing is left; View and Items work.
- **ASan:** clean.

**Spells in combat**
- **Path:** at the camp Memorize (3 spells), Rest, then the battle: the menu becomes "Move View Aim Use Cast Done".
- **Casting:** Cast, choice of Resist Cold, aiming (Target); "(Casting)", "L casts a spell", "Spell : Resist Cold", "L is cold-resistant".
- **ASan:** clean.

**To be clarified: the item "Plate Mail 3 Spells"**
- **The files:** L.swg, BOB.swg and TAS.swg (test data copied on 10/11, not from the original disks) each have a single item, a Plate Mail (name $2F/$24, weight 450, ready) with scroll fields on top: type $27, +$32 = $66 ("3 Spells"), spells 01 03.
- **KNT.swg** (saved by the port on 10/11 at 20:33) has a single item, the Plate Mail of type $24 with spells 02 23.
- **Comparison:** the ready-made characters CHRDATA1..6 have consistent items, and the creation (H013+$07B2) gives three items (Plate Mail, sword, shield) to whoever has levels in +$105.
- **Checks:** the ported H013+$07B2, saving (H066+$1640) and loading (H066+$1B0E) match the asm. In the asm no routine writes type $27 or +$32 into an existing item: the type is written only in the creation of the initial items, in the random generation (H067+$1292, new item) and in the reading of the treasure from file (H012).
- **Hypothesis:** those characters were produced in previous test sessions by a version of the port with a bug that was later fixed, or by a test hook.
- **To do:** create a new character with the current build (a knight, who receives the Plate Mail), save it and check the .swg; comparison with saves created by the original game.

---

## v56: check of the knight and cause of "Plate Mail 3 Spells" (no code changes)

**Knight created with the current build** (ASan)
- **Creation:** Create New Character, Human, male, Knight, alignment, "Reroll stats?" No, name KTST, icon editor, "Save KTST?" Yes.
- **KTST.swg:** three consistent items, byte for byte like CHRDATA1.swg: Plate Mail (type $24, name 00 2F 24, weight 450), shield ($25, weight 60), sword ($12, weight 50).
- **ASan:** clean.

**Cause of the "Plate Mail 3 Spells" item: test data fabricated in a previous session, not a bug of the port**
- **Origin:** on 10/11 at 19:54 UTC, to test the use of the scrolls, a test script took the record of KNT's Plate Mail and wrote over it type $27, +$32 = $66, +$44 = 1, +$45 = 3 (+$3A = 1). Then it saved it as the only item of TAS, BOB, L and KNT.
- **Check:** it is exactly the hybrid that was found; date and content match.
- **Test data fixed** (outside the repository): in L, BOB and TAS the item is now a consistent cleric scroll (type $28, name $66/$27/$26, weight 25, spells 1 and 3, ready). L's sheet shows "Cler Scroll 3 Spells", with Use available.

---

## v57: testing of Fix with a new cleric (no code changes)

**New character:** on the user's advice L is no longer used. CLR is a human cleric created with the current build (AC 10, HP 13). Party: CLR alone.

**Path** (ASan, test hook that limits the damage to CLR so that they stay at 1 HP at least)
- Leave from the town, caravan battle on Auto, "Continue Battle" No, treasure Exit.
- "Do you want to go back and claim your treasure?" No; "Will you help us reach the outpost?" No.
- Encamp; View, Fix, View again.

**Result**
- **HP:** CLR goes down to 1/13 in battle; after Fix the sheet shows 11/13.
- **Computation:** no cure memorised; 3 level-1 slots (+$124), so pool 3d8 = 10 and residual damage 2.
- **Game clock:** goes from 12:11 to 16:41, that is 4:30 of rest, as in the asm (H057+$2C08).
  - The time is $F0 + 3*$F = 285 minutes; the damage 12 is less than extra $1B, so the time is divided by 27/12 = 2, with a minimum of $10E = 270 minutes.
- **Rest timer:** $24F4..$2501 is saved and restored, as in the asm.
- **ASan:** clean.

**Defeat of the party** (checked by chance, without the damage limit)
- CLR, alone, is struck down.
- "The monsters rejoice for the party has been destroyed" appears and the game waits for any key, without a menu. It is the expected behaviour, not a hang.

**Test harness** (outside the repository)
- **Conditional steps:** `?text:KEY` waits for a menu with that text; `*text:KEY` presses the key as long as the new menus contain it.
- **Shot:** saves a screenshot of the current menu.
- With these steps the sequences no longer lose sync on text pages of variable length.

---

## v58: testing of Order and Drop with two new characters (no code changes)

**Party:** CLR (cleric, AC 10, HP 13) and KTST (knight, AC 10, HP 15), both created with the current build. Added with Add Character to Party; the list shows L, KTST, BOB, TAS, CLR, KNT with "*" next to the ones added.

**Path** (ASan): Begin, Leave, Encamp, Alter ("Order Drop Speed Icon Pics Level Exit"), Order, Drop.

**Order**
- The current one is KTST, written in white: draw_party (H063+$0D80) uses pen $0F for the current one and the status colour for the others.
- **Select:** "KTST has been selected", the menu becomes "Place Exit".
- **Down arrow:** KTST was the last and moves to the top (KTST, CLR), as in the asm (H057+$1FD6: from the tail to the head).
- **Place:** back to "Select Exit"; Exit goes back to the Alter menu.

**Drop**
- "KTST will be gone", "Drop from party? Yes No", Yes.
- KTST leaves the party and only CLR remains; the party box and the camp menu are redrawn correctly.

**ASan:** clean.

**Test harness:** the Shot step no longer consumes the current menu, so a conditional step can follow it right away.

---

## v59: testing of Turn Undead (no code changes)

**Ready-made characters on the disks** (CHRDATA1..6)
- They only have normal equipment (armour, shields, weapons, arrows); MOLLY has the item of type $43.
- No scrolls and no magic items: they are of no use for testing scrolls and magic items.

**Undead monsters in the game files** (MON1CHA.dax, field +$DF read with load_monster_record)
- SKELETON (26) type 1, ZOMBIE (31) type 2, GHOUL (7) type 3, GHAST (6) type 6.
- The other 31 monsters of MON1 have +$DF = 0.

**Testing** (ASan, CLR alone, level 1 cleric)
- A test hook replaces the monsters of the caravan battle with SKELETON, a real monster from the game files. The damage to CLR is limited so that they stay at 1 HP at least; the monsters die at the first hit only after the Turn.
- **Menu:** "Move View Aim Turn Done" appears. Turn appears because load_monster (H064) counts the undead in $248F and CLR's turn has +$13 < $248F. In the normal caravan the menu is "Move View Aim Done", correct because there are no undead.
- **Outcome:** "CLR turns undead...", then for each skeleton "SKELETON is turned" and the skeletons flee. After use Turn disappears from the menu (+$13 incremented).
- **Three tests:** the 1d20 roll is a single one for the action and the table value for type 1 and level 1 is 10.
  - roll 18: two skeletons turned;
  - roll 13: two turned;
  - roll 7: "Nothing Happens...".
- **ASan:** clean in all the tests.

**Remaining:** use of scrolls and magic items in combat. Real game items are needed (treasures or shops), not data built by hand.

---

## v60: testing of scrolls, potions and magic items; fix of Take Items (H070+$0E94)

**Fix: h070 take_items** (H070+$0E94)
- In the asm index (-$10), choice (-$4) and cursor (-$E) are initialised only once, before the loop ($0E9E..$0EAA; the loop restarts from $0EAE).
- The C cleared them at every iteration, so after a Take the selection went back to the first row instead of staying where it was. Now the initialisation is outside the loop.

**Items of the game's treasures** (ITEM1.DAX, dump read like ecl_treasure, H012 TREASURE command)
- **Blocks with magic items:** 17, 32..39, 48..51, 53.
- **Block 17:** Scroll Cler 3 Spells (type $28, spells $43 $3A $45), two White MU Scroll and two Red MU Scroll 3 Spells, Potion of Healing, Wand of Magic Missiles (5 charges, spell $41), arrows and bolts.

**Testing** (ASan, CLR alone; test hooks outside the repository, all items from the game files)
- **Treasure and Take**
  - A hook puts block 17 into the treasure of the caravan. The treasure lists the items; Take Items takes the potion and the scroll, and the selection stays on the row after the Take.
  - Note: 'I' on "Money Items Exit" leaves the 2nd option selected ($2483) and in "Take Exit" the 2nd is Exit. So Enter exits, in the asm too; you take with T.
- **At the camp**
  - **Use without Ready:** "Must be Readied" (H065+$28D2).
  - **Potion:** Ready, then Use; HP from 1/13 to 8/13, the potion disappears (encumbrance from 90 to 80).
  - **Scroll:** Ready, then Use; "Spells on Scroll", 4th Level: Neutralize Poison, Cure Serious Wounds, Protection Evil 10' Radius.
  - **Cure Serious Wounds** on CLR ("Cast Spell on whom"): HP 13/13, the item becomes "Scroll Cler 2 Spells" and the spell disappears from the scroll.
  - **Camp picture:** after View the fire reappears after a moment. It is the animation of ui_request_choice ($069E), which redraws after waiting for the frame; on entering the camp the box is also empty for a moment.
- **In combat** (wand and scroll given to CLR at the start of the battle with take_item, H071+$047C)
  - The menu becomes "Move View Aim Use Done"; Use shows "Ready Use Drop Halve Join Exit".
  - **Wand:** Ready, then Use; "Item Wand of Magic Missiles", Aim (Next Prev Manual Target Center Exit), Next on a Baaz, Target.
  - **Charges:** from 5 to 4. On Auto the AI uses the wand by itself: from 4 to 3 to 2.
  - **Aiming:** with no enemies in sight Next stays on CLR and Target hits them ("CLR takes 6 points of damage from magic"). A mistake of the test sequence, not of the port.
  - **Scroll:** Cure Serious Wounds on CLR, HP from 1 to 5; the scroll keeps the spells 43 00 45.
- **ASan:** clean in all the tests.

---

## v61: comments on every access to the anonymous data, README in English, complete PORT markers, H029 fix

**Comments on the anonymous data**
- **What is commented:** every read and write of the anonymous arrays has a comment that explains the element. It covers g_h005 (H005_B/W/L, H005_SET_*), g_state_a/b/c, g_ecl_buffer, the b[] fields of the records and the module arrays.
  - Record fields: Character ch+, CokItem item+, CokTurn turn+, CokEffect eff+, CokCloud cloud+.
  - Module arrays: g_hNNN_bss/data.
  - Example: `/* $3DF6: (word) game speed 0..9 (message pause) */`.
- **Glossary:** 586 entries derived only from the code and the asm. Where the meaning is not certain the description starts with "use:".
- **How they are applied**
  - Accesses found with the clang AST (libclang), so with the record type even inside the macros: 7080 accesses, 4513 lines commented.
  - At the end of the line if there is room, otherwise on the line above.
  - Also commented: the #defines with fixed offsets (CHOICE_SELECTED, SPELL_B, POS_X, ...) and, by hand, the accesses with a variable base (tables per class, terrain, age).
- **Checks**
  - The object files compiled before and after are identical byte for byte, except h029_gfx.c (fix below).
  - Host, AUDIO, C89, CMake x86_64/i686, MinGW builds: clean. ctest 8/8.

**Fix: H029+$1210 wrote into H005 instead of H024**
- `move.w #$10F, (H024+$4).l` writes into H024+$4, that is -$14(a4) of H024 (A4 = H024+$18), the Type of the NewScreen of Open_GameScreen.
- The C wrote `H005_SET_W(0x0004, 0x010F)`, that is over the high word of the value of coin 2 (long at H005+$4, value 5).
- Effects of the bug:
  - the screen opened without SCREENQUIET ($100);
  - the value of coin 2 became $010F0005.
- Now it writes `g_h024_m14 = 0x010F`, that is Type = CUSTOMSCREEN | SCREENQUIET, and it is exported by h024_screen.h.

**PORT markers: 1132 / 1132**
- PORT_STATUS.md counted 1107 routines. The 25 without a marker now have a `PORT Hnnn+$XXXX` that explains where they are:
  - **8 trampolines** (bra.w): H012+$0186, H013+$0518/$051C/$0520, H043+$01CA/$01D2/$07F6, H061+$162A. The marker is on the target routine.
  - **Nested or inline procedures**:
    - H010+$0882 (body of Poll_IntuitionEvents);
    - H045+$0014;
    - H066+$292C, identical to H066+$30A8 game_file_path;
    - H085+$3EE2, dispel_roll.
  - **Blitter callbacks H049+$06EC/$0782:** inside queue_bitplane_blit.
  - **Compiler runtime replaced by stdio:** H002+$00C0 IoErr, H015+$0196/$033E, H020+$00C2/$00F0, H074+$0010/$009A/$0450, H075+$00FE/$0124/$0132.
- H056+$0268 (names of the ECL opcodes for debugging) is not among the routines of the analysis; in the asm nobody calls it.

**Oddities of the original found while writing the glossary** (faithful port, no changes)
- Effect $36 (H027+$1C7A) tests $24A3 (saved game) where its twin $32 tests $24A5 (outcome of the saving throw). Noted in the comment.
- In write_state_b_hook (H061) case 0, which sets $24C3, looks unreachable.

**README.md** rewritten in English and updated: complete status, audio with COK_AUDIO, comment convention, SAS/C build (smake / smake AUDIO).

---

## v62: testing of Save and Load (no code changes)

**Save** (ASan, CLR after the caravan, with potion and scroll from the treasure)
- **At the camp:** Save, then "Save Which Game: A B C D E F G H I J", A, then "exit to workbench" No.
- **State at saving:** CLR 1/13 HP, experience 2717, 70 steel, encumbrance 90; potion and scroll not ready; 07,13 N, time 12:11.
- **Files written:**
  - savgamA.dat (5481 bytes);
  - CHRDATA1.sav (426) and CHRDATA1.swg (144 = 2 items of $48);
  - CLR.who deleted (H066+$3000).
- **File names:** the ready-made characters on the disks are called CHRDATA1..6, exactly like game A. So the ready-made party is game A, and saving into A replaces it.

**Load** (second start from the saved files)
- **Menu with the empty party:** "Create New Character, Add Character to Party, Load Saved Game, Exit to Workbench".
- **Loading:** "Load Which Game: A" offers only the existing games. After A the party contains CLR (AC 10, HP 1).
- **Begin Adventuring:** outdoor map with the party; at the camp 07,13 N, time 12:11. CLR as at saving (1/13, 2717, 70 steel, encumbrance 90, same items not ready).
- **Events:** the step that in the new game opened the caravan battle now runs only the step scripts (3655, 37BE) and goes back to the movement menu. The state of the events was restored.

**Round trip:** load A, then Save into B right away.
- CHRDATB1.sav and .swg are identical byte for byte to CHRDATA1.
- savgamB.dat differs from savgamA.dat in 3 bytes, all expected:
  - A+$279: counter of the saves from Encamp, from 1 to 2;
  - $3DE2: previous context, from 4 to 2, for the session path after loading;
  - name of the character file: "CHRDATA1" / "CHRDATB1".
- **Layout of savgam<x>.dat**, read by H066+$3000:
  - $246E (1 byte), state A ($800), state B ($800), state C ($400);
  - $281C (8 bytes), $3DE2, $3DE3, the 3 slots of $2810 (2+2 bytes each);
  - the number of characters (word) and the names (8 x $2A).

**ASan:** clean in all the tests.

---

## v63: Save and Load with two characters and from the main menu (no code changes)

**Save Current Game from the main menu** (ASan; party CLR + KTST, game not yet started)
- **Commands:** "Save Which Game" and then C.
- **Files written:** savgamC.dat, CHRDATC1.sav (CLR, without items, so without .swg), CHRDATC2.sav and CHRDATC2.swg (KTST, 3 items, 216 bytes). CLR.who and KTST.who are deleted.
- **KTST's items:** .swg identical to KTST.swg.
- **Character records:** compared with the .who only fields that are recomputed when the character joins the party change:
  - +$DB maximum level, from 0 to 1;
  - +$143 icon slot, from $0A at creation to 0/1 in the party;
  - +$18C KTST's encumbrance, from 10 to 570 (450 + 60 + 50 + 10 of coins).

**Load**
- "Load Which Game: A C" lists the existing games.
- **Game C:** the party comes back as CLR (10/13) and KTST (10/15), in the same order.
- **Begin Adventuring:** the introduction starts again, and this is right because the game had been saved before starting.

**Round trip: load C, then Save into D**
- CHRDATD1.sav, CHRDATD2.sav and .swg are identical byte for byte to those of C.
- savgamD.dat differs from savgamC.dat only in the two file names ("CHRDATC1/2" and "CHRDATD1/2", offsets $141F and $1449).

**ASan:** clean.

---

## v64: testing of the caravan escort, the outpost, the Commandant and the Hall (no code changes)

**Path** (ASan, party CLR + KTST; test hook: the monsters die at the first hit, the party stays at 1 HP at least)
- Leave, the caravan battle with the two characters on Auto, "Continue Battle" No, treasure Exit, "go back and claim your treasure?" No.
- **Texts after the battle**
  - "All of the draconians are slain save one, who rips a book from a dead man's hands. He turns to...", with the portrait of the draconian;
  - then, on the map: "One of the surviving women comes up. 'Brave warriors, will you help us reach the outpost?'". Answer: **Yes**.
- **After the Yes:** "Congratulations the party gains experience!". The new area is loaded (ECL area 11, RUN 3514) and the outpost appears: picture of the town, "Where do you wish to go", menu "Inn Hall Commandant Armoury Next Leave".

**Commandant**
- With the portrait of Sir Karl, text that scrolls letter by letter:
  - "You enter the office to the sounds of battle. Sir Karl drives his sword through the Commandant who collapses. The body then writhes and becomes a stone. Sir Karl murmurs, 'I was afraid...'";
  - "As you report, his face grows gray. 'This is much worse than...'";
  - "'We have a patrol in Throtl. Caramon leads it. Find him. Tell him he is desperately needed here. The imposter has emptied this outpost of troops. I know you are inexperienced...'".
- Then back to the outpost menu.

**Hall** (training)
- Shows the character menu with "Train Character" and "Knight Change Classes" in addition.
- **Train on CLR:** "Pick Character", then "Not Enough Experience". CLR has 3358 experience points and is level 1.
  - For the cleric the table row is 0 or 1 according to the deity (+$5E <= 4: row 0; H063+$3F72), and the level 2 threshold of row 0 is 4000 (H005+$1946).
  - The asm of Train (H013+$5A26..$5A4C) uses row * $9A and index (level+1)-2 like the C.
  - The table is checked byte for byte with the emulation of the asm. So the message is the one of the original.
- **Modify on KTST:** "KTST can't be modified.", correct for a character already in play (+$DC).
- **View of CLR:** 1/13 HP, experience 3358, 70 steel.

**ASan:** clean in all the tests.

**Test harness** (outside the repository)
- The ASan test build is now done on a copy of the source (srccopy). The hooks are applied there, and the annotations are removed only from the copy.
- The step `*text:KEY|text2:KEY2` accepts several alternatives, and the step line goes up to 159 characters.
- The show_message messages end up in the log ("MSG ...").

---

## v65: party marker on the outdoor map (RectFill outline on the host); testing of the outpost and of the journey

**Host fix: RectFill with AREAOUTLINE** (reported by the user: on the Amiga the party marker on the map is different)
- **The marker:** H069+$0012 draws the party cell with SetAPen($E), then H038+$01B4 (SetOPen: AOlPen = 0, Flags |= AREAOUTLINE), then RectFill.
- **On the Amiga:** with AREAOUTLINE RectFill redraws the border of the rectangle with AOlPen, and the marker is a yellow square with a black border.
- **On the host:** RectFill ignored the flag (the comment assumed AOlPen always equal to FgPen, true only for H030) and drew an all-yellow square.
- **Fix:** host/graphics.c RectFill now redraws the border with AOlPen when AREAOUTLINE is set, respecting the clipping at the edges of the bitmap.
  - For H030 (fill_text_cells and clear_text_cells, OPen = APen) the result does not change.
  - The game code and the Amiga build do not change.
- **To be confirmed on the Amiga:** the marker must be a yellow 8x8 cell with a one-pixel black border.

**Outpost** (ASan, party CLR + KTST after the escort)
- **Inn:** "Welcome, we have plenty of space for you." and the camp.
  - Rest: "Rest Time" with Days/Hours/Mins/Add/Subtract; 2 days.
  - CLR and KTST go from 1 to 3 HP (+1 per day); the time stays 12:08 (48 hours).
- **Armoury:** "Buy View Pool Appraise Exit".
  - Esc does not exit: in the asm the key table (H071+$0B9A, subi.w #$41 / cmpi.w #$15) covers only 'A'..'V', and key 0 goes to the default case. You exit with E, as in the original.
- **Next:** "Vault Temple Bar Prev Leave".
- **Bar:** "Have a drink Relax Leave"; "What will you drink?" Beer Ale Wine Mead Whiskey; "You hear tavern tale 19." (reference to the Adventurer's Journal).
- **Vault:** "Deposit Withdraw View balance Exit"; "You have 000 steel pieces".
- **Leave:** outdoor map, "You are near an outpost. Do you enter?". With No you go to the movement.

**Journey:** with the arrows the party marker moves on the map towards north, next to Throtl, up to the edge of the map. Each step runs the ECL scripts of the step (3655, 37BE).

**ASan:** clean.

---

## v66: wrong colours of the big pictures with fast CPUs (BltClear without waiting in H029 Allocate_GraphicRecord)

**Reported by the user:** on FS-UAE (A1200, 68040, Kickstart 3.2) the big pictures and the portraits sometimes appear with wrong colours; the frame and the text are right. The defect is intermittent: sometimes only part of the map, sometimes a portrait right the first time and wrong the second.

**Analysis** (debugger on FS-UAE)
- The colour registers are right: 0..15 the interface palette, 16..31 the picture one.
- On the screen the 5th plane of the picture is empty, so every pixel loses bit 4 and takes a colour 0..15.
- The block loaded into Fast RAM has all 5 planes; in the record in Chip RAM planes 0..3 are the same and the 5th is empty.
- The record is allocated by H029+$0408: every plane is cleared with BltClear(flags = 0), which does not wait for the last blit. Right after, transfer_gfx_planes (H029+$091E) copies the planes with CopyMem.
- With a fast CPU the copy reaches the 5th plane before the blitter has finished clearing it, and the blitter clears it again.
- The defect is in the original: on a 68000 the blitter always finishes first. In FS-UAE with cpu_speed=max it depends on the speed of the emulator.
- **Confirmation:** with uae_immediate_blits = true the defect disappears in all the tests.

**Fix:** H029 allocate_gfx_record calls BltClear with flags = 1 (wait for the end of the blit), for the planes of the picture and for the mask.
- On the host BltClear is synchronous: the result does not change.
- **To be confirmed on the Amiga:** with cpu_speed=max and without immediate_blits the pictures must always have the right colours.

---

## v67: display flashing on Kickstart 3.x with DblPAL in DEVS:Monitors (off-screen View without ViewExtra)

**Reported by the user:** on FS-UAE (A1200, Kickstart 3.2) with DblPAL.monitor in DEVS:Monitors the display flashes, gets distorted and recovers continuously, except while the text is being written with Delay. Removing DblPAL the defect disappears.

**Analysis** (debugger on FS-UAE)
- The FS-UAE log shows BEAMCON0 alternating between $0020 (PAL, 15 kHz) and $1B88 (DblPAL, 31 kHz) hundreds of times.
- A watchpoint on GfxBase->current_monitor shows the game task calling LoadView alternating two Views: one sets the monitor to DblPAL.monitor, the other to pal.monitor.
- The two Views are g_offscreen_view, built by H029+$1346 with InitView/MakeVPort/MrgCop without a ViewExtra, and g_saved_view, that is the Intuition View.
- On graphics.library V36+ LoadView shows a View without a ViewExtra with the default monitor of GfxBase, which with DblPAL installed is DblPAL. So the swap of the Views in begin_screen_update/end_screen_update and swap_display_view changes BEAMCON0 at every call.
- The defect is in the original: on Kickstart 1.3 the default monitor did not exist.

**Fix:** new H022 adapters graphics_attach_view_mode and graphics_detach_view_mode (Amiga only, empty on the host).
- prepare_display_resources gives the off-screen View a ViewExtra with the MonitorSpec and a ViewPortExtra (nominal DisplayClip, VideoControl) with the ModeID of the game screen, read with GetVPModeID. This way the two Views always use the same monitor, PAL or NTSC. It must be done before MakeVPort/MrgCop.
- If the ModeID is not available PAL or NTSC is used according to GfxBase->DisplayFlags; on graphics.library < 36 nothing changes.
- release_display_resources frees ViewPortExtra, MonitorSpec and ViewExtra after FreeColorMap and FreeVPortCopLists.

**To be confirmed on the Amiga** (built only for the host):
- The SAS/C build must find graphics/videocontrol.h, displayinfo.h, gfxnodes.h, monitor.h and modeid.h.
- With DblPAL.monitor in DEVS:Monitors the display must no longer flash and the off-screen picture must stay aligned as before.
- On leaving the game there must be no memory leaks (order of the GfxFree calls with respect to FreeColorMap).

---

## v68: off-screen View aligned with the Intuition View (DblPAL with Mode Promotion); smakefile with scoptions and WITH file

**Reported by the user:** on FS-UAE (A1200, 68040, Kickstart/OS 3.2.3, Workbench on UAEGFX, all monitors in DEVS:Monitors, Mode Promotion on) the picture still flashes after v67: in the camp at the Inn only a stretched slice of the screen is shown, continuously; it stops while ECL writes text with Delay.

**Analysis** (lab with the same setup, FS-UAE log and Copper lists dumped after MrgCop)
- The game screen is opened with a 1.3 NewScreen: GetVPModeID returns 0 (default monitor). With Mode Promotion and DblPAL installed Intuition shows it with DblPAL: as soon as the game is in front BEAMCON0 goes to $1B88 ("dblscan", 29 kHz) and stays there.
- v67 gives the off-screen View the monitor of mode 0 (DblPAL.monitor), but DxOffset/DyOffset come from Preferences (129/44, PAL 15 kHz coordinates) and the DisplayClip is the nominal one of mode 0.
- Copper lists: off-screen DIWSTRT=2C81 DIWSTOP=BC0A DDFSTRT=0038, Intuition DIWSTRT=334B DIWSTOP=C3EB DDFSTRT=0018 (BPLCON0 D201, FMODE C003 in both). Every LoadView in begin_screen_update/end_screen_update and swap_display_view changes display window and fetch start: the picture jumps, and FS-UAE with auto zoom enlarges the narrow window. No swap happens while text is written with Delay.

**Fix:** H022 attach_like_intuition, called first by graphics_attach_view_mode (Amiga only).
- Monitor from the ViewExtra of the Intuition View (GfxBase->ActiView), opened by name.
- DisplayClip, display handle and sprite resolutions (VTAG_SPRITERESN, VTAG_DEFSPRITERESN) from the ColorMap of the game screen with VideoControl.
- View DxOffset/DyOffset from the Intuition View.
- If something is missing the v67 code is used; on graphics.library < 36 nothing changes.

**Checked on the Amiga** (lab, SAS/C 6.58):
- 3.2.3 + P96 + Mode Promotion: the two Copper lists are equal (334B/C3EB/0018/0068/D201/0100/C003, BPLCON3 0C81); the game stays in DblPAL; Inn and camp are stable (290 frames at 5 fps).
- 3.1 with all monitors and Mode Promotion: equal (DblPAL). 3.1 without monitors: equal (2C81/F4C1/0038/00D8/5200, offsets 129/44 as before).

**smakefile:** smake failed at the link with "slink: Command too long". The objects are split into OBJS1..OBJS13, the cok and AUDIO rules write cok.lnk with short echo lines and run slink WITH cok.lnk; clean removes cok.lnk. The compiler options moved to scoptions (CFLAGS empty). Checked: smake clean + smake (0 warnings) and smake clean + smake AUDIO.

---
