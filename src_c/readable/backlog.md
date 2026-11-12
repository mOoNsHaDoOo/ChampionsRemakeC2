# Backlog del port di Champions of Krynn

Resoconti consegnati durante il port (dal più vecchio al più recente).
Ogni voce riporta data/ora (UTC) del messaggio originale.

## 2026-11-10 11:20

In breve: **non puoi usare l'abbonamento Pro con le API.** Sono due prodotti separati, con fatturazione separata.

**Abbonamento Pro (claude.ai)**
- Copre l'uso di Claude su web, desktop e app mobile.
- Copre anche **Claude Code**: accedi con il tuo account claude.ai (`/login` nel terminale) e l'uso rientra nei limiti del piano Pro, senza bisogno di una chiave API.
- **Non** include crediti né chiavi per l'API.

**API di Claude (Claude Console)**
- Ha un account e una fatturazione a parte: paghi a consumo, per token, caricando credito prepagato.
- Per iniziare:
  1. Vai su **platform.claude.com** (la Console, prima console.anthropic.com) e accedi. Puoi usare la stessa email, ma il credito è separato.
  2. Aggiungi un metodo di pagamento e acquista credito in **Billing**.
  3. Crea una chiave in **API Keys**.
  4. Usala nel tuo codice o nei tuoi strumenti:
     ```bash
     export ANTHROPIC_API_KEY="sk-ant-..."
     ```

**Quindi:**
- Se vuoi usare Claude per programmare, Claude Code con il login Pro è la strada giusta e non paghi nulla in più.
- Se invece vuoi integrare Claude in un'app o in uno script tuo, oppure usare uno strumento di terze parti che chiede una chiave API, devi usare l'API, con un costo a parte.

Cosa vuoi fare di preciso? Così ti indico il percorso più adatto.

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

Ho cancellato `src_c/readable` e ricominciato il port da zero, a mano dall'asm. Per ora sono portate 15 routine su 902: il programma parte, apre le librerie e si ferma alla prima routine mancante, `H005+$530A`, stampando il suo indirizzo.

**Cosa c'è nel nuovo port:**
- **Avvio (`H000+$0000`):** le 99 inizializzazioni dei moduli nell'ordine originale, poi il main.
- **Main (`H001`):**
  - la scelta del prefisso dati: `"df0:"` sotto 1800 blocchi, altrimenti `""`;
  - il prompt `"Champions of Krynn v1.0 "` con `"Play Demo"` (attesa 30 s, tasto predefinito `D`);
  - il ciclo gioco/demo con la verifica di distribuzione.
- **`H002`/`H003`:** gli adattatori DOS (Lock, Info, UnLock) e di memoria, con la conversione di DOSTRUE in 1 come nell'originale.
- **`H015`:** l'apertura e la chiusura delle librerie, e la moltiplicazione e divisione a 32 bit. La divisione con segno lascia il resto positivo, come l'originale.
- **Organizzazione:**
  - un file per hunk, e ogni funzione portata ha il marcatore `PORT Hnnn+$XXXX`;
  - le routine non portate stanno in `unported.c`;
  - i dati globali hanno un nome e, nel commento, il loro offset originale.

**Strumenti:** `scripts/port_status.py` legge tutte le routine dall'asm e i marcatori nei sorgenti, e genera `PORT_STATUS.md` con l'avanzamento per hunk. Nel repository c'è anche `scripts/hunkbytes.py` per leggere byte e stringhe dall'asm.

**Verifiche:**
- Compila senza avvisi con gcc e clang (`-pedantic`).
- Il test di `H015` passa contro i valori calcolati emulando le routine asm.
- Il patch si applica al commit base `9561aac`.
- **Non ho potuto compilare con SAS/C** perché qui non c'è un compilatore Amiga; il codice Amiga usa gli header NDK standard.

**Cose cambiate fuori da `readable/`:**
- `registers.c`, `hunk_runtime.c` e `dos_exec.c` servivano alla build di riferimento Ghidra, non al livello leggibile. Li ho spostati in `src_c/reference_runtime/`, e `build_reference.sh` funziona ancora.
- Ho riapplicato le correzioni di `.gitignore` e del test di runtime.
- I vecchi `CMakeLists.txt`/`CMakePresets.json` erano dentro `readable/` e sono stati cancellati con il resto. Per ora ci sono solo `Makefile` (host) e `smakefile` (SAS/C).
- Il README principale del repository descrive ancora il vecchio livello leggibile: lo aggiorno quando il port sarà più avanti.
- I miei patch precedenti (01–09) riguardavano il vecchio `readable/` e non valgono più.

**Prossimo passo:** continuo nell'ordine di avvio. Viene `H005+$530A`, poi `H004+$0C1A` (inizializzazione di 24 KB di dati), poi `H016`, `H017`, `H018` e così via, finché il programma arriva al main.

Lo zip è in /tmp/claude-0/-home-user/74ed0d1a-ba31-56dc-8643-7b071be4f004/scratchpad:
- cok-port.zip

---

## 2026-11-10 14:47

Il port è arrivato a 125 routine su 910. Il programma ora esegue tutta l'inizializzazione e la prima routine del main, poi si ferma su **H029+$1206**, la routine che apre schermo e finestra.

**Cosa ho fatto (2 commit nuovi su `asm-port`):**

1. **Tutti i 99 init dei moduli sono in C.**
   - Le tabelle di costanti sono generate dall'asm e applicate da un unico `init_data.c`; i cicli sono scritti a mano.
   - Ho confrontato byte per byte con l'emulatore dell'asm H004, H032, H011, H044, H057, H072, H085, H095 e H097: 0 differenze in tutti. Gli altri init, che sono semplici assegnazioni, li ho controllati leggendoli.
   - H004 resta sul suo generatore già verificato, così i suoi cicli non vengono spezzati.

2. **H006+$01AE (Initialize_GameEnvironment)**, insieme ai servizi foglia che usa:
   - adattatori DOS Open/Close/Read/Seek/Execute e CurrentTime di intuition;
   - confronto di stringhe senza maiuscole di H026 (`$003A`, `$0088`, `$0106`);
   - riempimento di byte H029+$0312, scambio dei byte di una word H031+$0012, verifica di esistenza file H028+$02D0;
   - i puntatori che l'originale tiene in H005 (blocchi di stato, buffer ECL, record grafici) sono diventati variabili C.

**Scostamenti dall'asm, tutti documentati nei commenti:**
- Le copie sullo stack prima di un confronto o di un Lock si fermano al NUL, per non leggere oltre gli oggetti C. Il risultato non cambia.
- Sull'host, Execute degli `Assign "Disk …:"` non fa niente e restituisce successo. Lock controlla davvero se il file esiste e i file handle sono una tabella di `FILE *`.

**Non verificato:** non ho compilato nulla con SAS/C perché qui non c'è il compilatore. La build host con gcc (`-Wall -Wextra -pedantic`) non dà warning.

Lo zip contiene le 3 patch a partire da 9561aac, `src_c/readable` e gli script.

**Decisione per te:** da H029+$1206 in poi il codice chiama graphics e intuition (schermo, bitmap, blit, input). Su Amiga è un collegamento diretto alle librerie, ma l'host ha bisogno di un sostituto. Ti consiglio di emulare a livello degli adattatori (H016, H021, H024, H025): bitmap in memoria, salvataggio dello schermo su file, input da script, nessuna dipendenza esterna. L'alternativa è SDL2, con finestra e tastiera reali ma una dipendenza in più. Dimmi quale preferisci; se non indichi niente procedo con la prima.

---

## 2026-11-10 15:01

Ecco **cok-port-2.zip**. Lo zip precedente lo conto come versione 1, quindi d'ora in poi il numero cresce di uno a ogni consegna (`cok-port-3.zip`, …).

Ho aggiunto SDL2 per la build host. Il gioco ora apre lo schermo vero e proprio. Sono 159 routine su 910 e il programma si ferma su **H030+$0C10**, che carica `gothic.lbm`.

**Come funziona l'host:**
- In `src_c/readable/host/` c'è una copia ridotta delle strutture di AmigaOS: `ndk.h` usa gli stessi nomi dell'originale (Screen, Window, BitMap, RastPort, View, ViewPort, ColorMap, RasInfo, Preferences, GfxBase). Accanto ci sono le funzioni di libreria con lo stesso nome (OpenScreen, OpenWindow, LoadRGB4, InitBitMap, AllocRaster, BltClear, InitView, GetColorMap, LoadView, OpenLibrary, FindTask, …).
- Per questo gli adattatori del gioco sono lo stesso codice su Amiga e su host: cambia solo la libreria sotto.
- `host/display.c` converte la bitmap planare in pixel con la palette RGB4 e la mostra in una finestra SDL2. Mostra lo schermo Intuition oppure, dopo `LoadView`, la View personalizzata del gioco.
- Puoi impostare tre variabili d'ambiente:
  - `COK_SCALE=n`: ingrandimento della finestra (3 se non impostata);
  - `COK_SCREENSHOT=f.bmp`: all'uscita salva l'ultimo fotogramma;
  - `SDL_VIDEODRIVER=dummy`: gira senza finestra.
- La build richiede SDL2: `libsdl2-dev` su Debian/Ubuntu, `brew install sdl2` su macOS, MSYS2 su Windows.

**Routine nuove (dall'asm):**
- H029: apertura di schermo e finestra (`$1206`), palette iniziale (`$115C`), caricamento di `pointers.daa` (`$0234`, `$0180`), chiusura (`$12BC`).
- H029: allocazione dei record grafici (`$0408`) e preparazione della View fuori schermo (`$1346`).
- H024 Open_GameScreen e H025 Open_GameWindow.
- Gli adattatori H016, H018, H021, H022, H037, H051, H055 e H084.

**Scostamenti, documentati nei commenti:**
- I puntatori del mouse in `pointers.daa` finiscono in una tabella C a parte. L'originale invece li riscrive come indirizzi a 32 bit dentro il buffer, e sull'host non ci stanno.
- Il record grafico è una struct C con gli stessi campi.
- Sull'host le Preferences danno spostamenti del display pari a 0.

**Limiti attuali:**
- I file dati del gioco non sono in questo ambiente. Quando servono vanno messi nella directory corrente, quindi da qui posso verificare solo fino a dove non vengono letti.
- Non ho compilato nulla con SAS/C. La build host è senza warning e gira senza finestra; ho controllato il file dello screenshot ma non ho guardato l'immagine.

Il prossimo blocco è il caricamento delle immagini ILBM: Open_ResourceFile (H028+$05FA), Read_ILBM (H040+$05E4) e il parser IFF generico di H086. Se mi dici "procedi" riparto da lì.

---

## 2026-11-10 15:07

Ho corretto i tre problemi del log SAS/C. Non posso compilare con SAS/C qui, quindi confermi tu: rilancia `smake` su **cok-port-3.zip** e mandami il nuovo `.err` se esce altro.

**Correzioni per SAS/C:**
- **Warning 63 (`GfxRecord` dichiarato due volte):** la struttura ora sta in un header suo, `gfx_record.h`, incluso da `globals.h`, `unported.h` e `h029_gfx.h`. Non ci sono più dichiarazioni anticipate.
- **Warning 85 (`signed_byte` restituisce `int`):** il valore ora si calcola in una variabile `s16`. Ho corretto anche un caso uguale in `h026_compare`, che sarebbe uscito più avanti.
- **Error 61 (`GfxBase` non definito):** `cok.h` include ora sul target Amiga `graphics/gfxbase.h`, `graphics/view.h` e `intuition/preferences.h`.

Lo smake si ferma al primo errore, quindi possono esserci altri problemi nei file dopo `h029_gfx.c`. Come controllo approssimativo ho ricompilato tutto con gcc in C89 rigoroso, senza warning.

**File del gioco:**
- Li ho estratti nell'area di lavoro.
- AmigaDOS non distingue maiuscole e minuscole, mentre sul disco ci sono nomi come `items` e `BODY1.DAA` e il gioco chiede `ITEMS`. Sull'host la ricerca dei file ora ignora le maiuscole e scarta il volume ("df0:", "Disk Two:").
- Per indicare la cartella dei dati c'è la nuova variabile `COK_DATA=dir`; se manca vale la directory corrente.
- Con i dati veri il gioco arriva fino a H030+$0C10 e si ferma lì come previsto. Il caricamento di `pointers.daa` e di `ITEMS` non l'ho verificato a parte.

**Port nuovo in questa versione:** Open_ResourceFile (H028+$05FA) con le routine stringa di H026 che usa e il requester Retry/CANCEL.
- Sull'host il requester stampa il testo su stderr e aspetta Invio/R (Retry) o Esc/C (Cancel) nella finestra.
- Senza finestra il programma termina invece di riproporre la richiesta all'infinito.
- La routine c'è ma non viene ancora eseguita: la chiama H030+$0C10, che non è ancora portata.

Sono 170 routine su 910. Il prossimo passo è Read_ILBM (H040) con il parser IFF di H086, per caricare `gothic.lbm`. Ora posso anche confrontare la decodifica con i file veri.

---

## 2026-11-10 15:14

Ecco **cok-port-4.zip**, con CMake per tutte le piattaforme e lo script che scarica SDL2 da NuGet per Visual Studio. Visual Studio qui non c'è, quindi il build MSVC non l'ho provato: le prove sono con gcc e MinGW, descritte sotto.

**Visual Studio 2022 (x86 e x64)**, dalla cartella `src_c/readable`:
```bat
windows\get-sdl2-nuget.cmd
cmake --preset vs2022-x64
cmake --build --preset vs2022-x64-release
```
Per x86 i preset sono `vs2022-x86` e `vs2022-x86-release`. Puoi anche aprire la cartella in VS (File > Apri > Cartella) e scegliere il preset dall'elenco, oppure aprire il `.sln` generato in `build-vs2022-x64` o `build-vs2022-x86`.

- **Script NuGet** (`windows/get-sdl2-nuget.ps1`, più il `.cmd` per il doppio clic):
  - Scarica da nuget.org `sdl2.nuget` e `sdl2.nuget.redist`, versione 2.30.10; un'altra si sceglie con `-Version`.
  - Non serve `nuget.exe`.
  - Mette header, `SDL2.lib` e `SDL2.dll` per Win32 e x64 in `third_party/sdl2-nuget`, che è escluso da git.
  - Questi due pacchetti sono della comunità (kosmotema): ridistribuiscono le librerie ufficiali di libsdl.org ma non le pubblica il progetto SDL.
- **`CMakeLists.txt`**:
  - Su Windows usa per prima la SDL2 scaricata, scegliendo l'architettura giusta, e copia `SDL2.dll` accanto a `cok.exe`.
  - Altrimenti cerca il pacchetto CMake di SDL2 (vcpkg, Homebrew, distribuzioni), poi pkg-config.
  - Compila anche il test `h015_test`, che `ctest` esegue.
- **Linux e macOS**: `cmake -S . -B build-cmake && cmake --build build-cmake`. Il `Makefile` resta disponibile.
- **SDL2main**: il display non lo usa più, quindi su Windows il `main` del gioco resta il punto d'ingresso.

**Cosa ho verificato qui:**
- Build CMake su Linux senza warning; `ctest` passa e con i tuoi dati il gioco arriva fino a H030+$0C10.
- Cross-compilazione con MinGW per Windows x64 e x86 (`-Wall -Wextra -pedantic`), con la SDL2 presa proprio dai pacchetti NuGet e lo stesso layout dello script: entrambe generano `cok.exe` e copiano `SDL2.dll`, senza warning.
- Lo script PowerShell non l'ho potuto eseguire. Il layout dei pacchetti che usa l'ho controllato scaricandoli.

**Port:** il punto è lo stesso di prima (170 routine). Ho già analizzato la catena di lettura delle immagini: è il lettore IFF85 di Electronic Arts compilato nel gioco. Da portare ci sono:
- H086: parser dei gruppi e dei chunk;
- H098: I/O con buffer;
- H087: BMHD, CMAP e BODY;
- H040: le callback FORM, PROP e LIST.

Nel port i dati letti dal file (ID, dimensioni, header BMHD) vanno convertiti da big-endian, così funzionano anche su x86 e x64. Al prossimo "procedi" riparto da qui; se il build con VS2022 dà errori, mandami il log.

---

## 2026-11-10 15:38

Mi fermo qui: l'inizializzazione dell'ambiente (H006+$01AE) è completa e il programma arriva all'intro, H007+$09D8. Le routine portate passano da 170 a 230 su 912, e ogni passo è un commit. L'intro richiede input da tastiera e mouse, attese e audio, quindi è un blocco a sé.

**Cosa ho portato, sempre dall'asm:**
- **Lettore IFF/ILBM** di Electronic Arts compilato nel gioco: I/O con buffer (H098), parser dei gruppi e dei chunk (H086, H039), BMHD/CMAP/BODY con ByteRun1 (H087, H088, H054, H099) e Read_ILBM con i suoi callback (H040). Il font `gothic.lbm` si carica.
- **Testo a schermo**: UI_DrawText e il disegno del testo col blitter (H049). L'originale scrive direttamente nei registri `$DFF000`, e il C fa lo stesso: sull'Amiga va all'hardware, sull'host a un piccolo emulatore del blitter (`host/blitter.c`). Il messaggio "LOADING...PLEASE WAIT" compare col font gotico; l'ho controllato su uno screenshot.
- **Risorse grafiche**:
  - lettura dei contenitori DAX con RLE e inversione dei byte per i `.dax` (H028);
  - record grafici: caricamento, liberazione, piani, maschere, ricolorazione (H029);
  - set 8x8 (H034), coppie di sprite 24x24 (H035), bordo (H006+$00FA);
  - BltBitMap, FreeRaster, RectFill e penne, con l'emulazione per l'host.
- **Tabelle dei gestori** in H005 ($25C0 e $2832): ora sono array C di puntatori a funzione. Le 175 routine a cui puntano per ora sono stub che si fermano col loro indirizzo se vengono chiamati.

**Verifiche con i file del gioco:**
- Immagini ILBM: tutte e 7 le `.lbm` sono identiche, byte per byte, a un decoder Python indipendente (`scripts/check_ilbm.py`).
- Contenitori DAX: tutti i 526 blocchi sono identici al lettore di riferimento (`scripts/check_dax.py`). Il riferimento all'inizio era troppo semplice e l'ho riscritto seguendo le regole dell'asm, per esempio il controllo $FF "ripeti il tipo precedente". Non è quindi del tutto indipendente dal port.
- Con `-DCOK_TEST_DATA=<cartella dei dati>`, `ctest` esegue anche i test ILBM: passano 8 test su 8.
- Build Linux e cross-build Windows x64/x86 con MinGW senza warning. SAS/C e Visual Studio non li ho qui: se escono errori, mandami i log.

**Problemi trovati e corretti:**
- Sull'host i percorsi assoluti venivano trattati come relativi alla cartella dei dati; ora sono riconosciuti, comprese le lettere di unità di Windows.
- L'originale legge e scrive un byte oltre i buffer di AllocMem; sull'Amiga finisce nel margine di arrotondamento, in C sarebbe un accesso fuori memoria. Nel port questi accessi restano dentro i buffer, e il commento nel codice lo dice.

**Da sapere:**
- In 33 blocchi (`SPRIT*.DAA`, `pic*.daa`, `pointers.daa`) la decompressione supererebbe il buffer, cioè l'originale darebbe l'errore "uncompress overuns buffer". `pointers.daa` non è un contenitore DAX: lo carica H029+$0234 come file grezzo. Per gli altri suppongo che passino da un altro caricatore, ma non l'ho ancora verificato.
- In H029+$0A0E l'originale scrive due word diverse nello stesso campo `+$04` del record; il port fa lo stesso.
- I set 8x8 hanno 4 piani, gli altri record 5 piani più una palette di 32 colori.

**Prossimo blocco: l'intro (H007+$09D8).**
- Serve l'input: gli eventi IDCMP, cioè tasti e mouse. Sull'host li farei arrivare da SDL2.
- Servono le attese: Delay (H036) e il controllo dei tasti (H010+$042E).
- Serve l'audio di H043, che sull'host andrebbe su SDL2 audio.
- Poi il caricamento delle immagini dell'intro (H007+$04F2) e il puntatore del mouse (SetPointer).

Mi baserei su `host/` come per la grafica: stesse funzioni dell'NDK, implementate con SDL2.

Lo zip numerato lo preparo appena me lo chiedi (sarà `cok-port-5.zip`). Altrimenti, con "procedi", parto con l'intro.

---

## 2026-11-10 15:53

L'intro ora gira dall'inizio alla fine nella build host, tranne l'audio. Il programma poi arriva al prompt "Play / Demo" (H008+$01FC), dove si ferma perché quella routine non è ancora portata. Ti ho mandato **cok-port-5.zip** (lo stato di prima), **cok-port-6.zip** (con l'intro) e `intro-host.png` con sei fotogrammi catturati dalla build host. Sono 258 routine portate su 913.

**Cosa si vede:** logo SSI, l'immagine della luna con la rosa, il titolo "Champions of Krynn", "Dragonlance" e la pagina dei crediti con la cornice di tile 8x8, poi il ciclo ricomincia. Le immagini compaiono con le dissolvenze e un tasto o un clic interrompe l'intro.

**Cosa ho portato, dall'asm:**
- **Intro (H007):**
  - caricamento delle immagini con dissolvenza in entrata e in uscita (16 passi, uno per quadro);
  - attesa di N secondi interrompibile da un tasto;
  - pulizia dello schermo e pagina dei crediti (26 testi estratti dall'asm);
  - il puntatore del mouse viene nascosto e poi ripristinato.
- **Input (H010):**
  - lettura degli eventi della finestra: tasti e pulsanti del mouse;
  - conversione dei codici tastiera Amiga in caratteri, con la tabella decodificata dai byte non classificati. Frecce e tastierino diventano le cifre di direzione;
  - tasti speciali Shift, Ctrl e Alt (Alt+a/m/q/x danno 1..4);
  - pulsante sinistro = Invio, destro = Esc;
  - attesa di un tasto (H010+$0974).
- **Grafica:**
  - tile 8x8 (H034+$0178, H049+$012A);
  - cornice dello schermo e dei crediti (H044);
  - cancellazione di aree di testo (H030+$0B6C);
  - palette del gioco (H011+$010C);
  - rilascio delle immagini (H042+$0300).
- **Adattatori:** GetMsg, ReplyMsg, WaitPort, Delay, WaitTOF, SetPointer, AvailMem.

**Sull'host (SDL2):**
- Tastiera e mouse diventano messaggi come quelli che Intuition darebbe al gioco, con i codici della tastiera Amiga.
- Delay e WaitTOF regolano la velocità a 50 e 60 Hz.
- Il cursore di sistema si nasconde quando il gioco imposta un puntatore vuoto.
- `COK_SCREENSHOT_AT=t1,t2,...` (insieme a `COK_SCREENSHOT=base`) salva fotogrammi ai millisecondi indicati; è così che ho preso quelli che ti ho mandato.

**Da sapere:**
- **Audio non portato.** H043 è un modulo di circa 1.800 righe e i due comandi musicali dell'intro (H043+$0584, H043+$190E) vengono saltati con un avviso su stderr invece di fermare il programma. È l'unico caso in cui una routine mancante non blocca il gioco; è scritto anche nel README.
- **Alt+C** (mostra la memoria libera, H010+$03AA) non è ancora portato e ferma il programma se lo premi.
- **Interruzione col tasto:** non l'ho potuta provare qui perché la build gira senza finestra. Ho verificato la logica sull'asm.
- **Build:** Linux senza warning; cross-build Windows x64 e x86 con MinGW senza warning; `ctest` 8 su 8. SAS/C e Visual Studio non li ho qui, quindi mandami i log se escono errori.

Al prossimo "procedi" vado avanti col prompt "Play / Demo" (H008+$01FC) e poi col menu principale. L'audio lo porto a parte (H043 più un emulatore del chip audio su SDL2); dimmi tu se preferisci farlo prima.

---

## 2026-11-10 16:01

Il prompt Play/Demo funziona: dopo l'intro compare "CHAMPIONS OF KRYNN V1.0" con "PLAY" e "DEMO" in fondo allo schermo e risponde a tastiera, mouse e tempo massimo. Ti ho mandato **cok-port-7.zip** e la schermata del prompt presa dalla build host. Le routine portate sono 267 su 913.

**Comportamento verificato sulla build host:**

| Ingresso | Risultato |
|---|---|
| nessun tasto per 30 secondi | sceglie Demo, come l'originale, e il gioco arriva a H011+$04A6 |
| P | sceglie Play e il gioco arriva a H009+$010C, la verifica della copia |
| Esc durante l'intro, poi freccia destra e Invio | l'intro si interrompe, "DEMO" passa in negativo e viene scelto |

Ho controllato le schermate: titolo in magenta, voce selezionata in negativo, iniziale in bianco, resto in verde.

**UI_RequestChoice (H008+$01FC):** il prompt usa il motore generale delle scelte del gioco, che servirà anche per tutti i menu, quindi l'ho portato intero:
- divisione delle opzioni in voci, una per ogni iniziale maiuscola o cifra;
- disegno della riga 24;
- tasti: lettere, Invio, Esc, '4'/'6' per scorrere, le cifre, Alt+a/m/q/x;
- clic sulla riga delle opzioni e sulle aree del gioco;
- forma del puntatore, animazione delle immagini, tempo massimo.

Le sotto-procedure dell'originale leggono le variabili della procedura che le chiama attraverso il suo frame; nel C queste variabili sono una struttura passata per puntatore.

**Errore corretto:** nel C scritto all'inizio, H001 chiamava il prompt con gli argomenti in ordine inverso. Ora l'ordine è quello dell'asm.

**Altro portato:** il cambio della forma del puntatore (H029+$01B6), il disegno di una serie di caratteri (H030+$00B6), l'ora in centesimi di secondo (H030+$0A40), H029+$03E2 e ModifyIDCMP.

**Sull'host:**
- La finestra tiene la posizione del mouse, come MouseX/MouseY dell'Amiga.
- Il gioco controlla l'input in un ciclo continuo; nell'host c'è una pausa di 1 ms quando non arrivano eventi, così non occupa tutta la CPU.
- Nuovo `COK_KEYS="ms=Tasto,..."` per simulare tasti a tempo nei test senza finestra, per esempio `COK_KEYS=1500=Escape,5000=P`.
- Il puntatore del mouse resta il cursore di sistema: lo sprite del gioco non è disegnato.

**Limiti noti:**
- I rami che servono solo in combattimento, nella mappa o con il party sono portati, ma chiamano routine ancora mancanti (H046+$0012, H048+$0AA8, H042+$0B80/$0254, la struttura dei personaggi). Se vengono raggiunti, il programma si ferma indicando quale manca. Dal prompt non vengono raggiunti.
- Due punti in cui l'originale ha un comportamento non definito, ora resi definiti e annotati nei commenti:
  - clic sul titolo: l'originale restituisce un valore dallo stack mai scritto, il C restituisce 0;
  - una lettera che non è l'inizio di nessuna voce: l'originale la cerca senza limite, il C si ferma a 20 voci.
- Build: Linux, cross-build Windows x64 e x86 e controllo C89 senza warning; `ctest` 8 su 8. SAS/C e Visual Studio non li ho qui: se escono errori mandami i log.

**Prossimo passo, a tua scelta:**
1. **Play**: la verifica della copia (H009+$010C) e poi il menu principale (H013+$4BFC: creazione del party, caricamento delle partite salvate).
2. **Demo**: H011+$04A6 e il ciclo della demo (H012+$3150).

Al prossimo "procedi" vado con Play, salvo indicazioni diverse.

---

## 2026-11-10 16:08

Con "Play" il gioco ora passa la verifica del manuale e arriva alla soglia del menu principale (H013+$4BFC), dove si ferma perché il menu non è ancora portato. Ti ho mandato **cok-port-8.zip** e la schermata della verifica; le routine portate sono 273 su 913.

**La verifica del manuale (H009+$010C):**
- È la protezione dalla copia: chiede una parola di una pagina del manuale ("the best quartex" o "tavern tale", scelta a caso).
- La legge con l'input di testo, che accetta caratteri da spazio a 'z', backspace e Invio/Esc ed è mostrato in giallo dopo "Enter".
- L'eseguibile nei tuoi dati è una **versione già craccata**: il testo dice "broken by the best quartex" e i salti dopo il confronto della risposta sono stati sostituiti da `nop`. Qualunque parola viene quindi accettata, e il port fa lo stesso.
- La routine calcola comunque la somma di controllo $3F8F che il main verifica.
- Prova con tasti simulati: la domanda compare dentro la cornice delle tre lune ("of tavern tale # 41, type any word, page 47"); dopo "WORD" e Invio il gioco prosegue.

**Portato in questo passo:**
- tabella delle 50 domande con le risposte codificate (H049+$079E) e decodifica della risposta (H009+$007E);
- generatore casuale del gioco (H023+$0010);
- inserimento di stringa (H026+$0254);
- input di una riga di testo (H030+$0718);
- la cornice dello schermo (H044+$01C2), ora usabile anche da altri moduli.

Build Linux, Windows x64/x86 (MinGW) e controllo C89 senza warning.

**Prossimo blocco: il menu principale.** Le voci sono "Create New Character", "Add Character to Party", "Load Saved Game", "BEGIN Adventuring", "Exit to Workbench" e le altre; ognuna si abilita o disabilita in base al party. Per mostrarlo serve il motore dei menu a elenco di H008 (da $13C0 a $2178), che il gioco usa per tutte le liste:
- disegno delle voci, abilitate in un colore e disabilitate in un altro;
- scorrimento a pagine con "Next" e "Prev";
- selezione con le frecce e con il mouse;
- domanda Sì/No ($203C);
- creazione e liberazione delle liste ($20C2/$2178).

Con il party vuoto all'avvio sono abilitate solo "Create New Character", "Load Saved Game" ed "Exit to Workbench". La prima schermata del menu richiede quindi solo il motore e la cornice, non il riquadro del party (H063). Le singole funzioni restano stub finché non le porto: prima la creazione del personaggio (H013+$0982), poi il caricamento delle partite salvate.

Al prossimo "procedi" parto dal motore dei menu.

---

## 2026-11-10 16:21

Il menu principale funziona, e "Exit to Workbench" ora chiude il gioco in modo pulito. Ti ho mandato **cok-port-9.zip** e la schermata del menu presa dalla build host. Sono 298 routine portate su 913.

**Cosa si vede:** dopo Play e la verifica del manuale compare "CHOOSE A FUNCTION Select". Con il party vuoto ci sono solo "Create New Character", "Add Character to Party", "Load Saved Game" ed "Exit to Workbench", come nell'originale.

**Provato con i tasti simulati:**
- le frecce spostano la selezione, e dalla prima voce la freccia su salta all'ultima;
- su "Exit to Workbench", Invio chiede "QUIT TO WORKBENCH Yes No" con "No" preselezionato;
- Y libera tutte le risorse e il programma termina con codice 0;
- Invio su "Create New Character" porta alla creazione del personaggio (H013+$0982), che non è ancora portata e quindi ferma il programma.

**Portato dall'asm:**
- **Menu principale (H013+$4BFC):**
  - 12 voci, abilitate in base al party e al personaggio corrente;
  - funzione scelta in base alla lettera iniziale della voce;
  - il trucco nascosto 'J': attiva o disattiva "Free training" se il terzo argomento della riga di comando è la parola di H005+$2358. Per questo il `main` ora conserva argc/argv.
- **Motore dei menu a elenco di H008**, usato da tutte le liste del gioco: righe di intestazione non selezionabili, pagine con "Next"/"Prev", frecce e tastierino, clic per selezionare e doppio clic per scegliere, opzione "Exit". Più la domanda Sì/No e la creazione e liberazione delle liste.
- **Uscita (H010+$0332 e $00C4):** libera le risorse e la View fuori schermo, chiude schermo e finestra, rimuove gli Assign se il gioco è installato su disco fisso, poi chiude il runtime.

**Errori trovati con AddressSanitizer e corretti:**
- Decompressione DAX: in alcuni blocchi l'ultima sequenza da copiare dichiara più byte di quelli presenti, e l'originale li legge oltre il buffer. Ora si copiano solo i byte presenti e il resto resta a zero.
- `SetPointer` dell'host leggeva la parte finale dello sprite del puntatore, oltre gli 8 byte allocati dall'intro.
- Freccia su dalla prima voce: l'originale legge da un puntatore nullo (il byte all'indirizzo $2A, nella tabella dei vettori della CPU, normalmente diverso da zero) e così salta all'ultima voce. Nel C un nodo nullo conta come riga di intestazione, con lo stesso effetto.

Dopo queste correzioni l'intro completa e la sessione fino all'uscita girano senza errori sotto ASan/UBSan.

**Non verificato e limiti:**
- L'audio è ancora saltato con un avviso.
- Le funzioni del menu non ancora portate fermano il programma indicando quale manca: creazione, aggiunta e rimozione di personaggi, caricamento e salvataggio, BEGIN.
- Build Linux e Windows x64/x86 (MinGW) e controllo C89 senza warning; `ctest` 8 su 8. SAS/C e Visual Studio non li ho qui.

**Prossimo passo, a tua scelta:**
1. **Create New Character (H013+$0982):** razza, sesso, classe, allineamento, tiro dei punteggi, nome, ritratto. È il percorso naturale da una partita nuova e richiede la struttura dei personaggi (+$18E per il successivo, ecc.).
2. **Load Saved Game (H066+$291E):** se hai dei salvataggi da usare, porta più in fretta all'avventura.

Con il prossimo "procedi" parto da Create New Character.

---

## 2026-11-10 16:43

Ho portato Create New Character e ti mando **cok-port-10.zip**. Sull'host funziona dal menu principale fino all'allineamento, poi si ferma: dopo l'allineamento il gioco calcola l'età e chiama la schermata del personaggio (H065+$04B8), che non è ancora portata.

**Cosa funziona già:**
- I cinque menu, come nell'originale:
  - **Razza:** imposta gli effetti di razza.
  - **Sesso.**
  - **Classe:** mostra solo le classi ammesse dalla razza e imposta livelli ed esperienza iniziali.
  - **Divinità:** appare solo se il personaggio ha livelli da chierico.
  - **Allineamento:** mostra solo quelli ammessi da classe e divinità. Ad esempio, con Paladine compaiono Lawful, Neutral e Chaotic Good.
- Esc in un menu libera il personaggio e torna al menu principale.
- È scritto anche tutto il calcolo che viene dopo, ma finché mancano la schermata e le altre routine sotto non posso provarlo:
  - età;
  - caratteristiche: il migliore di 6 tiri di 3d6+1, con i limiti di età, razza, sesso e classe;
  - punti ferita, denaro, nome e richiesta di salvataggio;
  - tiri salvezza, abilità da ladro e incantesimi da chierico.

**Struttura del personaggio:** il nuovo `character.h` tiene i $1AA byte del record con gli offset originali. I puntatori sono campi separati, perché sull'host occupano 8 byte invece di 4:
- `+$E8` effetti;
- `+$150` oggetti;
- `+$154..+$184` oggetti pronti all'uso;
- `+$18E` personaggio successivo;
- `+$192` blocco di $18 byte.

**Dove ho seguito l'asm anche se sembra un errore (è scritto nei commenti):**
- **Correzioni di razza sulle caratteristiche:** non si applicano mai. Il codice usa il contatore del menu delle razze, che a quel punto vale sempre 7.
- **Bonus di costituzione al primo tiro salvezza (H073+$0BA8):** viene sommato una volta per ognuna delle 8 classi.
- **Due valori che l'originale non inizializza:** il bonus delle abilità da ladro e la maschera della divinità per un valore non previsto. L'originale usa quello che resta nello stack; qui partono da 0. Sono gli unici due punti in cui il C si discosta dall'asm.

**Verifiche:**
- La build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning.
- ctest passa 8 test su 8.
- Ho fatto tre percorsi diversi nei menu più l'annullamento con Esc sotto ASan/UBSan, senza errori.
- Lo zip si ricompila da solo.
- Non ho compilato con SAS/C. Se dà errori mandami lo `smake.err`.

**Cosa manca per finire la creazione, in ordine:**
1. **H065+$04B8:** la schermata del personaggio, con $0ADE, $0BF4, $10DE e le dipendenze in H063 e H044. Serve anche a View Character.
2. **H013+$58DC:** l'addestramento, che durante la creazione gira con il flag $24CF.
3. **H028+$0D36 e H047+$00E6:** le routine chiamate dopo il nome. H047+$00E6 dovrebbe essere la scelta della figura.
4. **H066+$1640:** il salvataggio del personaggio su disco.

Se vuoi procedo con la schermata del personaggio.

---

## 2026-11-10 16:51

Ho portato la schermata del personaggio e ti mando **cok-port-11.zip**. In Create New Character, dopo l'allineamento, ora compaiono la scheda e i valori delle caratteristiche tirate. Poi il programma si ferma su **H013+$58DC**, la schermata di addestramento, che non è ancora portata. Siamo a 335 routine portate su 914.

**Cosa mostra la scheda (H065+$04B8):**
- **Intestazione:** nome, stato, sesso, età, allineamento, razza.
- **Classe:** con la divinità per i chierici, l'ordine dei cavalieri e il titolo "of the Crown/Sword/Rose".
- **Valori principali:** livelli per classe ed esperienza.
- **Caratteristiche:** STR/INT/WIS/DEX/CON/CHA, con la percentuale della forza 18 e un `*` quando il valore attuale è diverso dal massimo.
- **Denaro.**
- **Combattimento:** punti ferita, classe d'armatura, ingombro, THAC0, movimento e danno nel formato "NdM+K".
- **Oggetti pronti negli slot 0 e 2.**

Nello screenshot (Qualinesti Elf, chierico di Paladine) punti ferita, movimento e danno valgono ancora 0. È corretto anche nell'originale: la scheda viene disegnata prima dei tiri, e quei valori si calcolano dopo.

**Routine nuove dall'asm:**
- **H065:** $04B8, $0ADE, $0BE6 con la procedura annidata $0BF4, e $10DE.
- **H044+$068E:** la cornice della scheda.
- **H063+$13BE:** il ricalcolo dei valori derivati, che serve a tutto il gioco. Usa le routine di slot degli oggetti pronti, bonus di forza e destrezza, arma, armatura, classe d'armatura, ingombro e movimento ($016A, $0228, $0354, $0432, $06AE, $0758, $08A2, $18F8, $19B6, $1A8A).
- **H063, altre:** spazi iniziali ($0112), ricerca di un effetto ($0946), nome degli oggetti con plurali e quantità ($09B2), CA ($0FA0), punti ferita ($103A), nome del personaggio ($1F34).
- **`character.h`:** gli oggetti pronti all'uso sono ora un array di 13 puntatori da `+$154` a `+$184`.

**Dove ho seguito l'asm anche se sembra un errore (è nei commenti):**
- In H063+$13BE c'è un flag sempre a 0, quindi il ramo "-5000 di ingombro" non viene mai eseguito.
- In H063+$0228, con forza oltre 25 l'originale restituisce un valore non inizializzato; qui 0.

**Verifiche:** la build Linux e quelle MinGW x64/x86 non danno warning, il controllo C89 è pulito e ctest passa 8 test su 8. Ho fatto tre percorsi di creazione sotto ASan/UBSan senza errori. Non ho compilato con SAS/C: se dà errori mandami lo `smake.err`.

**Prossimo passo:** H013+$58DC, l'addestramento (circa 670 istruzioni). È la stessa routine della voce "Train Character" del menu principale; nella creazione gira con il flag $24CF. Dopo restano H028+$0D36, H047+$00E6 e il salvataggio H066+$1640. Se vuoi procedo con l'addestramento.

---

## 2026-11-10 17:01

Ho corretto l'errore di SAS/C: ti mando **cok-port-12.zip**, ma non ho potuto compilarlo con SAS/C.

**Causa:** su Amiga `intuition/intuition.h` dichiara già `struct MenuItem`, cioè le voci dei menu di Intuition. Il tipo del port in `h008.h` aveva lo stesso nome, quindi SAS/C dava "Error 63: already declared".

**Correzione:** ho rinominato il tipo in `CokMenuItem` in `h008.h`, `h008.c` e `h013.c`, gli unici tre file che lo usavano. Il comportamento non cambia.

Ho controllato i nomi delle altre struct del port contro le strutture dell'NDK presenti nel repository, e solo `BitMapHeader` coincide. Lo dichiara datatypes (`pictureclass.h`), che il port non include, quindi oggi non dà errori.

Le build host e il controllo C89 non danno warning e ctest passa 8 test su 8. Se SAS/C si ferma su un altro file, mandami il nuovo `smake.err`.

Se la build Amiga passa, il passo successivo è sempre l'addestramento (H013+$58DC).

---

## 2026-11-10 18:28

Ho portato l'addestramento: ti mando **cok-port-13.zip**. Ora Create New Character arriva fino alla domanda "Reroll stats?" e alla richiesta del nome. Dopo il nome il programma si ferma su **H028+$0D36**, non ancora portata. Siamo a 342 routine portate su 915.

**Addestramento (H013+$58DC):**
- **Dal menu principale (voce T):** controlla che il personaggio sia cosciente e che abbia esperienza sufficiente secondo la tabella H005+$1946. Controlla anche che la classe si possa addestrare lì (maschera +$550 dello stato B). Poi mostra "X will become: a level N …", chiede "Do you wish to train?" e alza i livelli.
- **Dentro la creazione:** gira senza messaggi né domande e viene ripetuto finché nessuna classe può più salire. Poi assegna gli incantesimi iniziali del mago e tira i punti ferita.
- **Esempi:**
  - Un guerriero con 2001 XP iniziali parte dal livello 2, con 23 PF (screenshot).
  - Un chierico di Paladine con 2000 XP resta al livello 1, perché per lui il livello 2 richiede 4000 XP.

**Altre routine nuove:**
- **H073+$05AE:** ricalcola i valori legati al livello (THAC0 base, livello massimo, tiri salvezza, abilità da ladro, oggetti che non si possono più tenere pronti).
- **H073+$0012:** slot e incantesimi conosciuti per tutte le classi.
- **Funzioni di supporto:** H063+$3F72 (riga della tabella dell'esperienza), H029+$039A e H030+$0AD2/$0B4A (messaggio a tempo sulla riga 24).

**Cosa resta stub:** H065+$34FC, la scelta interattiva di un nuovo incantesimo del mago quando sale di livello. Si usa solo dalla voce "Train" del menu, non nella creazione.

**Dove ho seguito l'asm anche se sembra un errore (è nei commenti):**
- Nel secondo ciclo dell'addestramento la riga della tabella e il livello sono quelli rimasti dall'ultima classe del ciclo precedente.
- H063+$3F72 restituisce un valore non inizializzato per le classi 1 e 3; qui 0.

**Verifiche:**
- La build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning; ctest passa 8 test su 8.
- Ho fatto tre creazioni sotto ASan/UBSan senza errori: guerriero, chierico e mago con un nuovo tiro.
- Non ho compilato con SAS/C. Se dà errori mandami lo `smake.err`.

Per completare la creazione mancano:
1. **H028+$0D36:** chiamata subito dopo il nome. È lunga solo 17 istruzioni, ma ne chiama di più grandi.
2. **H047+$00E6:** la scelta della figura del personaggio.
3. **H066+$1640:** il salvataggio su disco.

Se vuoi procedo con queste tre, in quest'ordine.

---

## 2026-11-10 18:37

Ho portato H028+$0D36 e ti mando **cok-port-14.zip**. Ora Create New Character va oltre il nome e si ferma su **H047+$00E6**, non ancora portata. Siamo a 347 routine portate su 916.

**Cosa fa H028+$0D36:** carica una sola volta, controllando il flag -$F9, le due immagini delle schermate dei personaggi, `charS.LBM` e `charT.LBM`.

**Routine nuove dall'asm:**
- **H028+$0C68:** per ogni file crea una nuova BitMap e legge l'immagine con Read_ILBM.
  - Copia i 32 colori in H005+$522E.
  - Mette il colore 0 in H005+$523E e poi azzera il colore 0.
  - Sull'host i colori del lettore sono word native, quindi li scrivo in H005 in big-endian. È lo stesso risultato del CopyMem di 64 byte sull'Amiga.
- **H041+$000C, $004A, $00BE:** l'allocatore che salva la dimensione nella long prima del blocco, e la relativa liberazione.
  - Toglie lo stub che usava la liberazione delle due schermate (H028+$0D74).

**Verifica del caricamento (con gdb, al punto in cui il programma si ferma):**
- Entrambe le bitmap risultano 320×200 a 5 piani, come nel BMHD del file.
- In H005+$522E c'è la palette di charT con il colore 0 a nero.
- In H005+$523E c'è `0x555`, cioè il colore 0 originale di charT.

**Altre verifiche:**
- La build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning.
- Ho dovuto cambiare `dax_test`, perché `h028_files.c` ora usa il lettore ILBM: compila anche `h041.c` e ha uno stub del lettore. Con questa modifica ctest passa 8 test su 8.
- Ho fatto una creazione completa fino al nome sotto ASan/UBSan, senza errori.
- Non ho compilato con SAS/C. Se dà errori mandami lo `smake.err`.

Il prossimo passo è **H047+$00E6**, la scelta della figura del personaggio. È un trampolino verso $08D6, circa 440 istruzioni, che usa gli sprite di H035 e le schermate appena caricate. Se vuoi procedo con quella.

---

## 2026-11-10 18:44

Il tuo log mostra che la build SAS/C linka (`SLINK Complete`). Ho corretto i warning che segnalava e ti mando **cok-port-15.zip**. Non l'ho ricompilato con SAS/C.

- **Warning 217** ("macro invocation may call function multiple times", in h007, h013 e h063): `COK_PUT16` e `COK_PUT32` valutavano due volte il valore. Quando il valore era una chiamata, per esempio `max_age(...)` o `str_damage_bonus(c)`, la funzione veniva chiamata due volte. Ora le macro mettono argomenti e puntatore in variabili temporanee, quindi valutano tutto una sola volta.
- **Warning 84** (`SELECTED`): `intuition/iobsolete.h` definisce già `SELECTED` come flag dei gadget. In `h008.c` la macro del port ora si chiama `CHOICE_SELECTED`.
- **Warning 63** (`struct Character` già dichiarata): `globals.h` ora include `character.h` invece di ridichiarare la struct.

Nessuna modifica cambia il comportamento. La build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning e ctest passa 8 test su 8. Una creazione rifatta con la build normale arriva come prima fino a H047+$00E6.

Se SAS/C dà ancora warning mandami il nuovo `smake.err`. Il prossimo passo è la scelta della figura del personaggio, **H047+$00E6**.

---

## 2026-11-10 19:01

Ho portato l'editor dell'icona (H047+$00E6) e ti mando **cok-port-16.zip**. Ora Create New Character arriva fino in fondo: nome, icona, "Is this icon ok?" e "Save TAS?". Rispondendo No il gioco torna al menu principale. Rispondendo Sì si ferma, perché il salvataggio (**H066+$1640**) è ancora uno stub. Siamo a 363 routine portate su 916.

**Editor dell'icona (H047+$00E6, corpo a $08D6):** è una macchina a sei stati, ognuno con il suo menu.
1. Parts / 1st-color / 2nd-color / Size / Exit (oppure Body / Size / Exit per le icone intere).
2. Head / Weapon.
3. Scelta della parte da colorare: in quel menu la voce "xxxx" diventa Hair o Face.
4. Dimensione.
5. Next / Prev / Keep per il colore.
6. Griglia 7×N delle teste o dei corpi, scelti con frecce, tastierino o mouse.

Mostra la coppia di pose "old" e "new" (ready/action). Exit dal primo menu conferma le modifiche, poi viene chiesto "Is this icon ok?".

**Altre routine nuove:**
- **H066+$0C34:** compone l'icona 24×24 ritagliando testa e corpo da charS/charT e la ricolora con le coppie di colori del personaggio (+$146). Usa le procedure $0BAC, $0C42, $0D2A e $0DEA.
- **H035+$01DC / $0460:** liberano e disegnano un set 24×24 attraverso la maschera.
- **H029+$10B8:** riempie un rettangolo di celle 8×8.
- **H016+$00A0:** wrapper di BltMaskBitMapRastPort, con l'emulazione sull'host. Sull'host copia la sorgente dove la maschera è a 1, cioè l'effetto del minterm $E0 usato dal gioco.

**Restano stub:** H049+$04AE e $09D6, usate solo per il disegno in combattimento e con scala > 3.

**Scostamento dall'originale (è nei commenti):** nell'editor una variabile di stato (-$24) non è inizializzata prima del primo menu; qui parte da 0.

**Verifiche sull'host:**
- **Funzioni dell'editor:** la griglia mostra le 13 teste con la selezione evidenziata. Freccia destra + Invio cambia la testa. Next cambia il colore dei capelli (rosso → magenta → marrone). Size e il ritorno ai menu con Esc funzionano.
- **ASan/UBSan:** un percorso completo dalla creazione all'editor e ritorno al menu principale, senza errori.
- **Build:** Linux, MinGW x64/x86 e il controllo C89 non danno warning; ctest passa 8 test su 8.
- **SAS/C:** non l'ho compilato. Se dà errori mandami lo `smake.err`.

L'ultimo pezzo della creazione è **H066+$1640, Save_CharacterRecord**: circa 480 istruzioni, con la scrittura del record su disco e i file collegati. Se vuoi procedo con quello.

---

## 2026-11-10 19:15

Ho portato il salvataggio del personaggio (H066+$1640) e ti mando **cok-port-17.zip**: Create New Character ora arriva fino in fondo e scrive il personaggio su disco. Siamo a 377 routine portate su 916. Non l'ho compilato con SAS/C: se dà errori mandami lo `smake.err`.

**Cosa scrive (nella directory dei salvataggi H005+$3CD4):**
- `nome.who` con il record di $1AA byte (oppure `nome.sav` se si passa un nome di file);
- `nome.swg` con gli oggetti, $48 byte ciascuno, solo se il personaggio ne ha;
- `nome.fx` con gli effetti, $0A byte ciascuno.

Il nome del file viene dal nome del personaggio: si tolgono i caratteri ` .*,?/#:;|` e si tengono al massimo 8 caratteri.

**Controlli prima di scrivere:**
- **Directory di salvataggio:** se mancano il disco o la directory, il gioco chiede di inserire il disco o crea la directory.
- **Spazio libero:** se non basta, mostra "Can't save. No room on this disk." e chiede "Lose character? / Ok, try another disk".
- **Prova di scrittura:** crea e cancella un file di prova (`testfilename`).
- **File già esistente:** chiede "Overwrite NOME?". Rispondendo No chiede un nome nuovo, che diventa anche il nome del personaggio, come nell'originale.

**Verifiche:**
- **Elfo guerriero:** produce `TAS.who` di 426 byte con la stessa struttura di `L.who` dei dati originali. Il suo `.fx` è identico byte per byte a `L.fx`.
- **Cavaliere:** produce `KNT.swg` di 216 byte. Contiene gli stessi tre oggetti iniziali (Plate Mail, Shield, Long Sword), nello stesso ordine e con gli stessi pesi, di `CHRDATA1.swg` originale.
- **Overwrite:** con Sì riscrive i file; con No e il nome "BOB" crea `BOB.who`, con il personaggio rinominato BOB.
- **Build e test:** la build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning e ctest passa 8 test su 8. Il percorso con il nome nuovo è stato rifatto sotto ASan/UBSan senza errori.

**Differenze rispetto all'originale (sono nei commenti):**
- I campi puntatore del record e dei nodi (+$E8, +$150…, i link "successivo") vengono scritti a 0. L'originale ci scriveva gli indirizzi in memoria, che il caricamento non usa.
- Dopo il nome nuovo, l'originale ricontrolla l'esistenza su un buffer che ormai contiene la domanda "Overwrite …": l'ho mantenuto così.
- In H028+$033E l'originale legge il nome del volume dopo aver liberato il blocco che lo contiene; qui lo copio prima di liberarlo.

**Altre routine nuove:**
- H028+$033E, $07E0, $08F0: nome del volume, rimozione di caratteri, nome del file.
- H030+$028A: messaggio che resta finché non si preme un tasto.
- Wrapper DOS CreateDir, DeleteFile ed Examine, con le versioni host.

**Modifiche all'host:**
- Lock ora trova anche le directory, anche su Windows.
- Info riporta i blocchi liberi.

Il passo naturale è **Add Character to Party** (H013+$0518 → $52E0), che carica un personaggio salvato con Load_CharacterRecord (H066+$1B0E): permette di rileggere i file appena scritti.

---

## 2026-11-10 19:23

Ho portato Add Character to Party e ti mando **cok-port-18.zip**. Il menu principale ora carica i personaggi salvati e li mostra nel party, con nome, CA e PF. Siamo a 386 routine portate su 916.

**Cosa fa:**
- Mostra l'elenco dei personaggi salvati ("Add a character:"): i file `.WHO` di $1AA byte nella directory dei salvataggi, esclusi quelli già nel party.
- Il personaggio scelto viene caricato e segnato con `* `.
- Viene aggiunto solo se rispetta le regole del gioco. Se non le rispetta, il segno viene tolto e compare il messaggio:
  - non deve essere già nel party;
  - al massimo 6 personaggi giocanti e 8 membri in tutto;
  - niente paladino in un party con membri malvagi ("paladins do not join with evil scum");
  - al massimo 3 ranger ("too many rangers in party");
  - niente personaggio malvagio con un paladino ("<nome> will tolerate no evil!").
- Si continua finché non si esce con Esc/Exit o il party è pieno.

**Routine nuove dall'asm:**
- **H013+$52E0:** Add_CharacterToParty.
- **H066+$1B0E (Load_CharacterRecord):** legge il record, poi gli oggetti da `.swg` e gli effetti da `.fx`, e ricalcola i valori derivati.
- **H066+$03D0/$03DE:** elenco dei personaggi salvati.
- **H066+$0852:** apertura del file senza la sostituzione del disco.
- **H066+$27EE:** aggiunta in coda al party, con il primo posto icona libero.
- **H063+$0D80:** elenco del party nel menu principale, insieme all'area cliccabile.
- **H063+$1D44:** messaggio a tempo sulla riga 24; prende il posto dello stub usato dall'addestramento.

**Host:** i lock ora ricordano il percorso, ed Examine/ExNext scandiscono davvero le directory (dirent; `_findfirst` su Windows, compilato con MinGW ma non provato su Windows).

**Dove ho seguito l'asm anche se sembra un errore (è nei commenti):**
- Per un personaggio rifiutato viene liberato solo il record: oggetti ed effetti già caricati restano allocati.
- Due variabili non sono inizializzate prima della prima scelta nell'originale: il flag "with_exit" del menu e il contatore dei membri. Qui partono da 0.
- La stringa "from saved game …" viene composta ma non è mai usata.

**Verifiche:**
- L'elenco mostra L (personaggio dei dati originali), BOB, TAS e KNT. Aggiungendoli, il menu principale mostra il party con CA e PF e abilita Drop/Modify/View/Remove/Save/Begin.
- Il giro con tutti e quattro è stato fatto anche sotto ASan/UBSan, senza errori.
- I divieti del party (paladini, ranger, allineamenti malvagi) non li ho provati: tutti e quattro i personaggi sono stati accettati, quindi nessun messaggio di rifiuto è comparso.
- La build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning e ctest passa 8 test su 8.
- Non ho compilato con SAS/C: se dà errori mandami lo `smake.err`.

Con un party, nel menu restano da portare View Character (H065+$3702/$196E), Drop, Modify, Remove, Save Current Game e BEGIN Adventuring. Dimmi da quale proseguire.

---

## 2026-11-10 19:24

Questo `smake.err` è identico byte per byte a quello che mi avevi mandato prima della versione 15, quindi viene da una build dei sorgenti vecchi. Non riguarda cok-port-18.

Lo si vede dal contenuto:

- **Warning 84** cita `#define SELECTED` alla riga 138 di `h008.c`. Dalla versione 15 quella riga è `#define CHOICE_SELECTED`.
- **Warning 63** cita `struct Character;` alla riga 73 di `globals.h`. Dalla 15 lì c'è `#include "character.h"`.
- **Warning 217** viene dalla vecchia `COK_PUT16`, che valutava due volte l'argomento. Ora usa le variabili temporanee `cok_w_`/`cok_p_`.
- **Dimensione del programma:** il link riporta 164076 byte di codice, come allora. Con le routine aggiunte nella 16, 17 e 18 (editor dell'icona, salvataggio, caricamento, party) dovrebbe essere più grande.

Probabilmente hai compilato in una directory con una versione precedente, oppure `smake` non ha ricompilato perché i `.o` risultavano più recenti dei sorgenti.

Per una build pulita della 18, estrai **cok-port-18.zip** in una directory nuova, oppure cancella i vecchi `.o`:

```bash
cd cok-port/src_c/readable
```

```bash
delete #?.o cok
```

```bash
smake
```

Poi mandami il nuovo `smake.err`. Se compila, dimmi da quale voce del menu proseguire: View Character, Drop, Modify, Remove, Save Current Game o BEGIN Adventuring.

---

## 2026-11-10 19:27

Ho corretto l'unico warning che restava nel log e ti mando **cok-port-19.zip**.

Questo log viene dalla versione nuova. I warning corretti nella 15 (SELECTED, macro PUT, `struct Character`) non ci sono più, e il programma è cresciuto da 164076 a 178684 byte di codice.

Il warning era il **63** in `unported.h`: alla riga 219 c'era `struct GfxRecord;`, ma la struct è già definita in `gfx_record.h`. Ho tolto la dichiarazione e `unported.h` ora include direttamente `gfx_record.h`. Il comportamento non cambia.

La build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning e ctest passa 8 test su 8. Non ho ricompilato con SAS/C: se il nuovo `smake.err` mostra altro, mandamelo.

Dimmi da quale voce del menu del party proseguire: View Character, Drop, Modify, Remove, Save Current Game o BEGIN Adventuring.

---

## 2026-11-10 19:33

Ho portato View Character e ti mando **cok-port-20.zip**: dal menu del party si sceglie un personaggio, se ne vede la scheda e si torna al menu. Le funzioni del sottomenu (Items, Trade, Drop) non sono ancora portate: sceglierle ferma il programma. Siamo a 392 routine portate su 916.

**Come funziona:**
1. Dal menu principale si sceglie View Character.
2. Compare "Pick Character" (H065+$3702), dove si sceglie il personaggio. I tasti speciali passano al precedente o al successivo del party, con il giro dal primo all'ultimo; un clic su un nome sceglie direttamente quel personaggio.
3. Si apre la scheda del personaggio con un menu (H065+$196E) che contiene solo le voci disponibili per lui:
   - Items, se ha oggetti;
   - Spells, se ha incantesimi memorizzati;
   - Trade e Drop, se ha denaro;
   - Heal e Cure, che però nell'originale non compaiono mai, perché le due funzioni di controllo ($36A6/$36C0) restituiscono sempre 0;
   - Exit.
4. All'uscita la schermata viene ridisegnata secondo il modo di gioco (H063+$321A). Nel menu del party è la cornice; gli altri modi (vista, combattimento, accampamento) usano routine ancora non portate.

**Correzione a codice esistente:** lo stub di H042+$0254 aveva la firma sbagliata. Nell'asm prende quattro argomenti (word, word, byte, puntatore) e viene chiamato con il risultato di H042+$0B80. Ho corretto entrambi gli stub e la chiamata in H008.

**Cosa resta stub nel sottomenu di View:**
- **Items (H065+$255A):** circa 355 istruzioni; usa altre routine di H065 e H033.
- **Spells (H065+$34FC):** circa 117 istruzioni.
- **Trade (H065+$12D6) e Drop (H065+$1636):** circa 200 istruzioni ciascuno; usano H067.

**Verifiche:**
- Con L aggiunto al party, View mostra la sua scheda (Paladine Cleric, 40 Steel) con il menu "Trade Drop Exit", ed Exit torna al menu principale.
- Il giro è stato fatto anche sotto ASan/UBSan, senza errori.
- La build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning e ctest passa 8 test su 8.
- Non ho compilato con SAS/C: se dà errori mandami lo `smake.err`.

Se vuoi completare View, il passo più utile è **Items**: il cavaliere KNT ha i suoi tre oggetti iniziali per provarlo. In alternativa posso passare alle altre voci del menu (Drop, Modify, Remove, Save Current Game, BEGIN Adventuring).

---

## 2026-11-10 19:42

Ti mando **cok-port-21.zip** con la schermata Items di View Character. Funzionano Ready, Drop, Halve e Join; Use, Trade, Sell e Id sono ancora stub, e sceglierli ferma il programma. Siamo a 407 routine portate su 916.

**La schermata (H065+$255A):**
- In alto "<Nome>'s Items" e "Ready Item".
- Sotto, l'elenco degli oggetti con Yes/No (pronto o no) e il nome composto.
- Il menu mostra solo i comandi validi in quel momento:
  - Ready (View Ready in modalità debug);
  - Use: solo in combattimento o accampamento;
  - Trade: non in combattimento;
  - Drop;
  - Halve: con meno di 16 oggetti;
  - Join;
  - Sell e Id: solo in città;
  - Exit.

**Comandi portati:**
- **Ready (H065+$2C04):** prepara o toglie l'oggetto. Un oggetto maledetto non si toglie ("It's Cursed"). Gli altri impedimenti hanno il loro messaggio:
  - "Wrong Class";
  - "already using <oggetto>" (slot occupato);
  - "Your hands are full!";
  - "Wrong Magical Order" (pergamene);
  - "Usable Only By Kender".
- **Drop:** un oggetto pronto non si può lasciare ("Must be unreadied"). Per le pergamene magiche c'è una conferma. Poi "Your <oggetto> will be gone forever / Drop It?".
- **Halve:** divide la quantità in un nuovo oggetto, oppure "Can't halve that".
- **Join:** riunisce gli oggetti uguali, al massimo 255 per oggetto.

**Routine di supporto nuove:**
- **H063+$1BE8:** cancella un oggetto dalla lista.
- **H056+$0886:** traccia di debug, attiva solo con $24D2.
- **H033+$17E6:** riconosce le pergamene.
- **H030+$0302:** testo a capo automatico, con "Press any key to continue" a pagina piena.
- **H044+$07DE:** cornice della schermata.

**Differenze rispetto all'originale (sono nei commenti):**
- **Lista degli oggetti nel menu:** l'originale passa la lista degli oggetti direttamente al motore dei menu, perché i primi $30 byte di un oggetto hanno la forma di una voce. In C le struct sono diverse. Per questo costruisco una lista di voci speculare, e la voce scelta corrisponde all'oggetto nella stessa posizione. L'indice del cursore resta lo stesso dell'originale.
- **Comando Use in combattimento:** con il modo $3DE3 = 5, l'originale legge il blocco +$192 del personaggio anche quando è nullo. Qui un blocco nullo conta come 0.

**Altri stub:**
- Gli effetti degli oggetti magici quando diventano pronti (H062+$03F2, $1A32, $0452): si raggiungono solo con oggetti magici.

**Verifiche:**
- **Ready e scheda:** con KNT gli oggetti sono Plate Mail, Shield e Long Sword. Dopo Ready su armatura e scudo, la CA scende a 1, l'ingombro sale a 565 e il movimento passa a 6. La Plate Mail compare nella riga dello slot 2: l'ho verificato sul file `items` dei dati originali, dove ha davvero slot 2.
- **ASan/UBSan:** un giro con Ready, Join e Drop (lo scudo: ingombro 515, CA 2) senza errori.
- **Build e test:** la build Linux, le build MinGW x64/x86 e il controllo C89 non danno warning e ctest passa 8 test su 8.
- **SAS/C:** non l'ho compilato. Se dà errori mandami lo `smake.err`.

Per completare Items mancano Use (H065+$2F82, con gli incantesimi di H033), Trade (H065+$1D94), Sell e Id, che però servono in città. Dimmi se proseguire con queste o passare ad altre voci del menu del party.

---

## 2026-11-10 20:04

Ti ho mandato **cok-port-22.zip**, con il comando Use della schermata oggetti (H065+$2F82) portato fedelmente dall'asm. Dato che Use chiama il lancio degli incantesimi, ho portato anche la parte di H033 che lo gestisce. Il conteggio passa a 428 routine portate su 917 (commit `4a46ad2`). Su SAS/C e Visual Studio non posso compilare da qui: mandami il log.

**Cosa ho portato**
- **H065:**
  - Use (`use_item`).
  - La scelta dell'incantesimo `choose_spell_of_kind` ($34FC), che sostituisce lo stub chiamato anche da H013 e dal menu Spells.
- **H033:**
  - costruzione degli elenchi degli incantesimi: in memoria, grimorio, pergamene, da scegliere, da memorizzare ($0366–$0D7C);
  - menu Cast/Memorize/Scribe/Learn ($00EE) e scelta dei bersagli ($12D4);
  - lancio vero e proprio ($1426), rimozione dell'incantesimo dalla pergamena ($1836) e messaggio "casts" ($18EE).
- **H063:** messaggi nella zona di testo ($1DC2, $1EE8), $2F12 e la scelta di un membro del party "Cast Spell on whom" ($3A26).
- **H062 e H073:** H062+$1780 (toglie gli effetti $19) e le due routine H073+$1294/$12AE, che restituiscono sempre $11.
- **Dati:** le tabelle che H033 legge in H085 ora sono variabili C dichiarate in `h085.h`. Anche i puntatori di H005 $2508, $251C, $2520 e $2770 sono variabili globali C.

**Cosa resta come stub**
Le routine usate solo in combattimento (H048, H077+$508, H063+$1B90/$2178/$21D2/$3658, H044+$492) sono stub. Lo stesso vale per i gestori dei singoli incantesimi H085+$xxxx: il programma si ferma lì.

**Una differenza dall'originale:** nell'asm il contatore delle pergamene H085+$4 non ha limite e, dopo $31 voci, scrive sopra le tabelle successive di H085. In C mi fermo alla fine della tabella, per non corrompere la memoria sull'host.

**Test**
- **Come ho provato:** Use compare solo durante l'avventura ($3DE3 = 2..4), quindi dal menu principale non si raggiunge ancora. L'ho provato con una modifica temporanea, che non è nel commit, e con dati di prova in cui ho dato ai personaggi una pergamena (Bless e Cure Light Wounds) o un oggetto magico.
- **Pergamena:** compare il menu "Spells on Scroll" con l'intestazione "1st Level". Col cavaliere esce "KNT oops!". Col chierico L il lancio va avanti fino al gestore di Bless (H085+$1C60), che non è portato.
- **Oggetto magico:** compaiono "KNT uses an item" e il nome dell'oggetto, poi "Cast Spell on whom Select Exit". Select arriva al gestore di Cure Light Wounds (H085+$1CB8), anche questo non portato.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8 e ASan pulito sia sul flusso normale sia sui due percorsi di Use.

Il prossimo passo naturale sono gli effetti degli incantesimi in H085, per far funzionare davvero Bless e Cure Light Wounds. In alternativa ci sono i comandi Trade, Sell e Id degli oggetti, o le voci rimaste del menu principale.

---

## 2026-11-10 20:37

Ti ho mandato **cok-port-23.zip**: il menu principale ora è completo tranne Begin Adventuring, insieme ai comandi rimasti di View e Items. Degli effetti degli incantesimi ho portato solo una prima parte: il motore comune che serve a quasi tutti gli altri incantesimi resta da fare. Siamo a 483 routine portate su 923, con le patch fino alla 0030. Su SAS/C e Visual Studio non posso compilare da qui: mandami il log.

**Menu principale**
- **Drop Character:** chiede conferma due volte, cancella i file .who/.swg/.fx e toglie il personaggio dal party. Provato: Garin è stato rimosso.
- **Modify Character:** Add, Subtract, Keep ed Exit su caratteristiche, punti ferita e nome, con i limiti di razza e classe. Provato: Subtract su STR abbassa la forza eccezionale da 18(51) a 18(48), Esc ripristina tutto.
- **Knight Change Classes:** portato ma non provato. Dal menu compare solo quando Train è attivo, e nei dati di prova non lo è.
- **Save Current Game:** scrive `savgamX.dat` e i file `CHRDATXn`, poi cancella i .who dei personaggi. Il file prodotto ha la stessa dimensione e lo stesso formato dell'originale (5481 byte).
- **Load Saved Game:** carica sia il salvataggio fatto da noi sia quello originale A, con i suoi 6 personaggi.
  - Il caricamento della mappa 3D e dell'immagine grande (H011+$1876, H011+$14EA, H042+$1006) serve solo all'avventura. Sono stub che segnalano e proseguono, non bloccano.

**View e Items**
- **Trade e Drop del denaro (View):** portati insieme alle routine delle monete di H067, al parser di numeri H045+$000C e al messaggio d'errore H014+$0018. Il personaggio del salvataggio non aveva denaro, quindi non li ho provati.
- **Trade di un oggetto (Items):** provato, la Plate Mail passa a Istan.
- **Sell e Id (Items):** portati ma non provati, perché compaiono solo nei negozi.

**Effetti degli incantesimi**
- **Funzionano e li ho provati:**
  - Cure Light Wounds: KNT passa da 10 a 13 PF.
  - Enlarge: la forza va a 18(00) con "is stronger".
- **Portati ma non provati:**
  - Cure Serious Wounds.
  - Cure Disease e Neutralize Poison: si appoggiano alla rimozione degli effetti e al ricalcolo delle caratteristiche (H062+$0452 e H062+$1A32), che ora sostituiscono anche gli stub usati da Ready.
  - Strength: provato solo su un cavaliere, dove non ha effetto (vedi sotto).
- **Cosa manca:** Bless, Detect Magic, Protection, Resist, Invisibility, Prayer, Haste e quasi tutti gli altri passano da H085+$07B6. Restano circa 2300 istruzioni, in parte grafica del combattimento in H049 e H029. È il passo successivo; finché non c'è, quegli incantesimi si fermano sullo stub "routine non ancora portata".

**Valori non inizializzati nell'asm, qui messi a 0**
- Il bonus di Strength per un personaggio senza classi adatte: per questo su un cavaliere non succede nulla.
- La costituzione fuori dall'intervallo 3–19.
- L'ordine di cavalleria diverso da Corona e Spada.
- Il tipo di moneta sconosciuto.
- Il livello d'incantatore per una classe oltre 4.

**Prove**
- Compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8 (ho corretto lo stub di `dax_test`).
- ASan pulito su Load, View, Save, Modify e Drop, e sui percorsi di Use.
- Use l'ho provato come nella versione 22: dal menu non è raggiungibile, quindi ho usato una modifica temporanea, non committata.

---

## 2026-11-10 20:56

Ti ho mandato **cok-port-24.zip**: H085+$07B6 è portato insieme alla sua catena non grafica, e con lui una cinquantina di gestori degli incantesimi. Gli effetti che i personaggi hanno già addosso invece sono quasi tutti ancora stub: un incantesimo si ferma lì se il bersaglio ha uno di quegli effetti. Siamo a 552 routine portate su 975 (commit `87123b7`, patch fino alla 0031). Su SAS/C e Visual Studio non posso compilare da qui: mandami il log.

**Il motore (H085+$07B6)**
Per ogni bersaglio fa il tiro salvezza (H062+$142C), il tiro per colpire quando serve (H062+$12F6), il danno e poi l'effetto con la sua durata. Il danno passa da H062+$2188 (con i messaggi "takes … points of damage from …", "Goes Down", "is killed") e da H063+$2984. L'effetto lo applica H062+$0114. Sotto ci sono:
- gli eventi degli effetti (H062+$083E), con la tabella dei 25 eventi;
- l'attivazione di un singolo effetto (H062+$057C);
- la resistenza alla magia (H062+$0772);
- la rimozione degli effetti quando un personaggio cade (H062+$17C0);
- il messaggio dell'effetto (H063+$2760);
- H063+$1B90 (toglie l'incantesimo lanciato), che sostituisce il suo stub.

**Incantesimi portati**
- **Chierico:** Bless, Curse, Cause Light/Serious Wounds, Resist Cold e Resist Fire, Silence, Slow Poison, Snake Charm, Spiritual Hammer, Cure/Cause Blindness, Cause Disease, Prayer, Remove Curse, Bestow Curse, Sticks to Snakes.
- **Mago:** Burning Hands, Charm Person, Reduce, Friends, Magic Missile, Shield, Shocking Grasp, Sleep, Knock, Mirror Image, Ray of Enfeeblement, Blink, Haste, Slow, Confusion, Fire Shield, Fumble, Ice Storm, Minor Globe.
- **Comuni:** Detect Magic, Protection, Invisibility.
- **Senza nome (classe 4):** i gestori degli incantesimi dei mostri.

**Cosa resta come stub**
- **Gestori degli incantesimi:** Hold Person, Stinking Cloud, Lightning Bolt, Fireball, Charm Monsters, Dimension Door, Fear e Poison sono solo da combattimento e restano stub. Anche Dispel Magic (H085+$3ED4) resta stub, ma lì è una mia scelta di priorità: è grosso, non è solo da combattimento, e conviene farlo subito.
- **Grafica e posizioni del combattimento:** H029, H048, H049, H077, H063+$2178/$2BDE. Fuori dal combattimento non vengono mai chiamate.
- **Gestori degli effetti (H027, tabella H005+$2832):** è il prossimo livello, 108 gestori. Ho portato solo quelli che i personaggi di prova attivano subito: gli effetti $12 e $5F (H027+$0A00 e $3A46, con il loro helper $0286) e $5C (H027+$41F6, che non fa nulla). Senza questi, Bless si fermava su H027+$3A46.

**Valori non inizializzati nell'asm, qui messi a 0**
- Il valore della forza nell'incantesimo dei mostri H085+$331E quando la forza non sale.
- Il caso di H063+$2FAA con una classe oltre 4.

**Prove**
- **Bless dalla pergamena di L:** compare "L is Blessed" e la pergamena passa da 3 a 2 incantesimi.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **ASan:** pulito sia su Bless sia sull'oggetto magico. Come nelle versioni precedenti ho usato la modifica temporanea per far comparire Use, non committata.

Il passo naturale successivo sono i gestori degli effetti di H027: la maggior parte è sotto le 60 istruzioni, ma sono tanti. In alternativa posso fare prima Dispel Magic.

---

## 2026-11-10 21:03

Ti ho mandato **cok-port-25.zip**. H085+$07B6 era già stato portato in cok-port-24 (commit `87123b7`), quindi non l'ho rifatto. Sono andato avanti con quello che il motore chiama e che mancava ancora: i gestori degli effetti di H027, nella tabella H005+$2832. Il contatore segna ora 596 routine portate su 1017; il totale è salito perché lo script conta anche le routine scoperte con i nuovi tag (commit `07d9a80`, patch fino alla 0032). Su SAS/C e Visual Studio non posso compilare da qui: mandami il log.

**Gestori portati (una cinquantina)**
Il motore li chiama quando un effetto si applica, si toglie, o quando scatta un evento come danno, tiro salvezza o tiro per colpire.
- **Modificatori di danno e tiri:** i bonus al tiro salvezza e al tiro per colpire (effetti 1, 2, 8, 9, $21, $24, $39, $76, $77), il danno dimezzato o raddoppiato da fuoco e freddo ($A, $14, $1D, $32, $36), la cecità ($21) e il veleno lento ($F).
- **Effetti con messaggio:** Mirror Image che perde un'immagine ($1C, "lost an image"), il silenzio ($15) e l'invecchiamento ($27).
- **Annullamento di effetti e incantesimi in arrivo:** $3B, $3F, $49 e $59–$63.
- **Fine del turno:** i gestori che chiudono il turno di combattimento ($1B, $1F, $33–$35, $6A).
- **Oggetti magici:** il vettore $2A0E, che aggiunge o toglie l'effetto quando un oggetto viene preparato o tolto (effetto +$45).
- **Effetti vuoti:** quelli che nell'originale non fanno nulla.

Ho anche spostato H062+$15C6 (tiro dei dadi del danno) in `h062.c`, perché lo usano sia H027 sia H085.

**Cosa resta**
- **47 gestori di H027 restano stub.** Sono soprattutto da combattimento: aree della mappa, bersaglio del turno, la lista di personaggi in H005+$16, oppure dipendono da routine non portate di altri moduli (H062+$2650, H063+$2B7C).
- **Un problema per il combattimento:** diversi di questi gestori salvano un puntatore a personaggio dentro il blocco +$192 (all'offset +$C). Sull'host, con puntatori a 64 bit, quei 4 byte non bastano. Prima di portarli va deciso come rappresentarlo.
- **Gestori degli incantesimi ancora stub:** Dispel Magic (H085+$3ED4, 329 istruzioni) e quelli solo da combattimento (Hold Person, Fireball, Lightning Bolt, Stinking Cloud, Fear, Charm Monsters, Dimension Door, Poison).

**Prove**
- **ASan:** pulito sia su Bless dalla pergamena di L sia sull'oggetto magico di KNT, e nessuno dei due arriva più a uno stub.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **Use:** come prima, l'ho fatto comparire con la modifica temporanea, non committata.

Come passo successivo propongo Dispel Magic, che non è solo da combattimento. Poi conviene decidere come rappresentare i puntatori nel blocco +$192, prima di portare i gestori di combattimento.

---

## 2026-11-10 21:13

Ti ho mandato **cok-port-26.zip** con Dispel Magic (H085+$3ED4) portato. Ho provato solo la prima parte (gli effetti sul bersaglio): la parte sulle nubi è portata ma non provata, perché per ora non esistono mai nubi. Siamo a 598 routine portate su 1018 (commit `4f08813`, patch fino alla 0033). Su SAS/C e Visual Studio non posso compilare da qui: mandami il log.

**Cosa fa la routine (due parti)**
- **Effetti sul bersaglio:** per ogni bersaglio prova a togliere gli effetti con durata (+$4 < $FF) del primo bersaglio, come nell'asm. La probabilità dipende dal livello d'incantatore contro il livello dell'effetto (+$4 & $0F): +5% per livello sopra, −2% per livello sotto, 50% alla pari. Se ne toglie almeno uno mostra "is affected".
- **Nubi:** nelle 9 caselle attorno a $2518/$251A legge la mappa di combattimento e, sulle caselle con nube ($1E), dissolve gli effetti nube ($28) del loro lanciatore. Poi ridisegna con H048+$0DF2, che è uno stub di combattimento.

**Cosa ho cambiato per farla girare**
- **H048+$0154 portata:** è la lettura di una casella della mappa. Va portata perché nell'originale la seconda parte gira anche fuori dal combattimento.
- **Mappa di combattimento (H005+$2ADE):** ora è una variabile C (`g_combat_area`) al posto dello stub `g_h005_2ade_area()`, che fermava il programma. La alloca H095, il modulo che prepara il combattimento, non ancora portato.
- **Lista delle nubi (H005+$2514):** è una variabile C (`g_clouds`) con il record di $22 byte. Owner e next sono puntatori C, il resto sta nei byte come nell'originale. Per ora resta vuota, perché Stinking Cloud (che crea le nubi) non è portato.

**Una differenza dall'originale:** senza mappa di combattimento l'asm legge da $2ADE = 0, cioè dalla memoria bassa dell'Amiga. Sull'host questo farebbe crashare, quindi in quel caso la casella vale 0: fuori dal combattimento non ci sono nubi da dissolvere.

**Prove**
- **Dispel Magic da un oggetto magico su KNT:** ho dato durata 3 al suo effetto $12. L'effetto viene dissolto e compare "KNT is affected".
- **ASan:** pulito sulla stessa prova.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **Use:** come prima, l'ho fatto comparire con la modifica temporanea, non committata.

Restano gli incantesimi e i gestori di effetti solo da combattimento. Prima di quelli conviene decidere come rappresentare i puntatori a personaggio salvati nel blocco +$192 (offset +$C), che sull'host a 64 bit non entrano nei 4 byte.

---

## 2026-11-10 21:15

Dispel Magic (H085+$3ED4) è già portato: è in **cok-port-26.zip**, che ti ho mandato nel messaggio precedente (commit `4f08813`). Non c'è altro da fare su quella routine, quindi non l'ho toccata di nuovo.

L'ho provato da un oggetto magico su KNT: il suo effetto $12 (con durata 3) viene dissolto e compare "KNT is affected", con ASan pulito. La parte sulle nubi invece è portata ma non provata, perché per ora la lista delle nubi è sempre vuota.

Se il messaggio di prima era un invio ripetuto, dimmi come proseguire tra queste strade:

1. **Puntatori nel blocco +$192 (offset +$C):** prima di toccare il codice di combattimento va deciso come rappresentare i puntatori a personaggio salvati lì, perché sull'host a 64 bit non entrano nei 4 byte. Da questo dipendono quasi tutti i 47 gestori di H027 ancora stub e diversi incantesimi.
2. **Incantesimi solo da combattimento:** Hold Person, Stinking Cloud, Fireball, Lightning Bolt, Fear, Charm Monsters, Dimension Door e Poison. Richiedono anche H048 e H077 (figure e aree del combattimento).
3. **Altro fuori dal combattimento:** per esempio l'audio (H043) o altre schermate.

Per il log di SAS/C della versione 26 resto in attesa.

---

## 2026-11-10 21:22

Ti ho mandato **cok-port-27.zip**. Ho fatto il passo che sblocca il codice di combattimento: il blocco del turno +$192 ora è una struct, e ho portato altri gestori di effetti di H027. Il contatore segna ora 626 routine portate su 1040; il totale è salito perché lo script conta anche le routine scoperte con i nuovi tag (commit `2a3f9de`, patch fino alla 0034). Su SAS/C e Visual Studio non posso compilare da qui: mandami il log.

**Il blocco del turno (+$192)**
- **Cosa ho verificato:** in tutto l'asm l'unico campo longword del blocco è +$C, un puntatore al personaggio bersaglio. Tutti gli altri accessi sono a byte o word.
- **Come l'ho reso:** il blocco ora è `CokTurn` in `character.h`, con i $18 byte originali in `b[]` e il puntatore in un campo separato, `target`. I 4 byte in +$C..+$F restano inutilizzati, e il resto del codice accede ai byte con `block_192->b[...]` come prima.
- **Altre variabili che contengono puntatori**, ora variabili C:
  - H005+$2A14 (`g_h005_2a14`), il bersaglio del turno in esame;
  - H005+$2B32 (`g_combatants[40]`), i combattenti per numero;
  - H005+$16 (`g_h005_0016[20]`), i personaggi a terra.

**Nuove routine**
- **Routine di appoggio:**
  - H062+$02FA, che manda a terra un personaggio;
  - H062+$2650, che lo rimette in piedi;
  - H063+$2B7C, che conta i combattenti attivi per lato;
  - H027+$0214, che paralizza il bersaglio del turno;
  - H027+$2182, che avvelena il bersaglio del turno;
  - H027+$0338, il bonus +1.
- **Gestori di effetti**, 24 in più:
  - $16 (morte per veleno);
  - $17 (Spiritual Hammer, che dà e toglie il martello);
  - $2B e $2C (debolezza e malattia);
  - $3D e $3E (fuoco ridotto e rigenerazione);
  - $40, $41, $56 e $57 (veleni);
  - $42 ("gets zapped!");
  - $45, $51 e $58 (paralisi);
  - $1A, $30, $31, $3A, $44, $72, $73 e $75.
- **H048+$16D4 (posizionamento sulla mappa):** resta stub, ma restituisce 1 fuori dal combattimento come nell'asm. Così il ritorno in piedi funziona anche fuori dal combattimento.

**Una stranezza dell'originale che ho mantenuto:** nel gestore $17, dopo aver dato il martello, la ricerca lascia selezionato l'oggetto che lo segue, non il martello. È quello che fa l'asm.

**Prove**
- **ASan:** pulito su Bless e Dispel Magic da oggetto, e nessuno dei due si ferma più su uno stub.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **Use:** l'ho fatto comparire con la modifica temporanea, non committata.
- **Nuovi gestori:** non provati, perché scattano solo in combattimento o con effetti che i personaggi di prova non hanno.

**Cosa resta in H027**
Restano 25 gestori stub: $0492, $06D4, $080A, $0EFC, $0FCE, $1162, $13F4, $1836, $1E3C, $2400, $266A, $29E2, $2B3E, $2D46, $2FE2, $3160, $3292, $3636, $3916, $3982, $3B34, $3C2A, $3C88, $3D28 e $3F72. Sono quasi tutti legati al combattimento. Usano la lista $250C, la tabella $2AE2 e le nubi, e routine di H063 non portate ($2DC6, $1160, $135A, $37B2, $21D2). Il prossimo passo naturale è continuare con questi, partendo dalle routine di H063 che servono a più gestori.

---

## 2026-11-10 (cok-port-28)

Ti ho mandato **cok-port-28.zip** con le routine di H063 che servivano ai gestori degli effetti, gli 11 gestori di H027 che le usano e il nuovo `backlog.md`. Il contatore segna 642 routine portate su 1051; il totale è salito perché lo script conta anche le routine scoperte con i nuovi tag. Su SAS/C e Visual Studio non posso compilare da qui: mandami il log.

**backlog.md**
- È in `src_c/readable/backlog.md` e contiene tutti i miei 42 resoconti di questa sessione, ricavati dalla cronologia, in ordine di data, ognuno con data e ora del messaggio originale.
- Ci sono anche i primi messaggi non legati al port (per esempio quello su abbonamento Pro e API), perché mi avevi chiesto di metterci tutto.
- D'ora in poi aggiungo lì ogni nuovo resoconto, a partire da questo.

**Routine di H063 portate**
- **$135A:** il personaggio è indifeso? Controlla gli effetti elencati in H005+$4066..$4069.
- **$1160:** pannello del combattente a destra (nome, "Hitpoints", "AC", arma pronta, stato, "(Helpless)", "(Casting)").
- **$2DC6:** distanza fra due combattenti sulla mappa del combattimento. Salva e ripristina la tabella H005+$2A3E come nell'asm.
- **$37B2:** arma con cui si combatte, dalla mano (+$154) o dalle munizioni (+$180/+$184).
- **Esportate:** $016A, $0354 e $19B6 (correzioni di destrezza e forza, già portate ma statiche) ora sono visibili agli altri moduli.

**Gestori di H027 portati (11)**
- **Combattimento:**
  - effetto 7 (attacco naturale: da vicino 1d6+2 più la forza, a distanza 1d4+1 più la destrezza);
  - effetto $1E (nube: "is coughing");
  - effetti $5D, $64 e $66 (danno dimezzato o annullato secondo l'arma);
  - effetto $69 (danno extra a distanza 1);
  - effetto $70 (chi colpisce da vicino "gets zapped").
- **Stati della mente:**
  - $B (charme, cambio di lato);
  - $D ("goes mad!");
  - $20 ("Arises in a new form");
  - $23 (confusione: fugge, resta confuso, va in berserk o si infuria, poi un tiro salvezza).

**Valori non inizializzati nell'asm, qui messi a 0**
- Nell'effetto 7 l'originale somma la parola non inizializzata del frame quando il personaggio non ha un'arma in mano.

**Prove**
- **ASan:** pulito su Bless e Dispel Magic da oggetto (la modifica temporanea per Use non è committata).
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **Nuovi gestori:** non provati, perché scattano solo in combattimento, che non è ancora raggiungibile.

**Cosa resta**
- **Gestori H027 (14):** $13F4, $1836, $1E3C, $2400, $266A, $29E2, $2B3E, $2D46, $2FE2, $3160, $3292, $3636, $3982 e $3D28. Usano le nubi, la lista H005+$250C, la tabella H005+$2AE2, H062+$2734 e la grafica del combattimento.
- **Routine di H063 di grafica del combattimento:** $1FDC, $2178, $21D2 e $3CA0. Restano stub.

---

## 2026-11-10 (cok-port-29)

Ho portato gli ultimi 14 gestori di effetti di H027: la tabella H005+$2832 non punta più a nessuno stub di H027. Routine portate: 659 su 1065.

**Gestori portati**
- **Nubi e acido:**
  - $13F4 (effetto $28): "The air clears a little...", la nube si dissolve e le caselle tornano come prima;
  - $266A (effetto $46): "dissolves into acid!", crea una pozza d'acido;
  - $3292 (effetto $50): "The acid drains away..", la pozza si asciuga.
- **Difese:**
  - $1836 (effetto $29) e $174E: "Avoids it", schiva le armi senza bonus magico;
  - $29E2 (effetto $47): "reflects the spell", rimanda l'incantesimo al lanciatore;
  - $2400 (effetto $43): "loses his weapon", l'arma finisce nella lista H005+$3360.
- **Paura e fetore:**
  - $2B3E (effetto $48) e $3636 (effetto $52): "is terrified" / "is afraid", il bersaglio fugge;
  - $3160 (effetto $4F): "emits an evil stench".
- **Berserk:** $2FE2 (effetto $4D, "goes berserk") e $3D28 (effetto $6B, stessa cosa senza messaggio).
- **Esplosioni e richiami:**
  - $1E3C (effetto $3C): "explodes!", 3d6 e stordimento a chi è attorno;
  - $2D46 (effetto $4C): "gates in", fa entrare in campo i rinforzi.
- **Costituzione:** $3982 (effetto $5E), bonus da +1 a +5 secondo la costituzione.

**Altre routine nuove**
- **H062+$2734:** fa esplodere i personaggi a terra della lista H005+$16 ("explodes.", 1d6 a chi è attorno).
- **H029+$0376:** XOR di un byte (`xor_byte`).

**Nuovi dati globali**
- `g_acid_pools` ($250C): pozze d'acido, con lo stesso record delle nubi.
- `g_dropped_items` ($3360): armi perse, con un nuovo struct `CokDropped`.
- H006 ora azzera `g_dropped_items` al posto della long in H005.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Dimensione dei record:** nubi, pozze e armi perse sono allocate e liberate con la dimensione del record C. L'asm usa $22 e $50 byte; in C i puntatori sono più grandi.
- **H062+$2734:** l'asm scrive anche su una voce vuota (NULL) della lista; qui la salto.
- **$2D46 a fine lista:** l'asm legge un personaggio NULL quando la lista finisce; qui la tratto come il ritorno al lanciatore.
- **Valori non inizializzati, qui messi a 0:**
  - in $266A, la direzione usata quando la casella vale $1F;
  - in $3982, il bonus per una costituzione fuori tabella.

**Comportamenti dell'asm mantenuti così come sono**
- **$2D46:** con una casella fuori mappa non passa alla direzione successiva. Se il personaggio di riferimento è sul bordo, il ciclo non finisce mai.
- **$29E2:** l'animazione e il cambio di bersaglio si ripetono per ogni bersaglio, anche per quelli non sostituiti.
- **$266A:** contando le pozze già esistenti, salta l'ultimo record della lista.
- **$3160:** l'effetto $76 va a chi emette il fetore, non alla vittima.

**Prove**
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **ASan:** pulito in una sessione di prova sul menu principale.
- **Nuovi gestori:** non provati, perché scattano solo in combattimento, che non è ancora raggiungibile.

**Cosa resta**
- **Stub del combattimento:** grafica di H048 (posizioni, aree), H077, H063 $2178/$21D2 e H043+$190E.
- **Allocazione delle nubi:** non è ancora portata. Chi la porterà deve usare `sizeof(CokCloud)`.

---

## 2026-11-10 (cok-port-30)

Ho portato la grafica del combattimento: mappa, vista 7x7, figure, cursore, cadute, aree e linea di vista, proiettili e doppio buffer. Routine portate: 705 su 1065 (prima 659).

**H048: mappa e figure del combattimento (19 routine, tutte quelle del modulo)**
- **Forme e vista:**
  - $0044 (casella i di una forma, tabella H005+$5048);
  - $00C2 (coordinate nella vista);
  - $01E8 (dentro la vista 7x7);
  - $0230 (combattente visibile, tutto o in parte).
- **Disegno:**
  - $0334 (casella con cursore e figura);
  - $0588 (terreno sotto un combattente);
  - $0884 (casella e chi la occupa);
  - $0B1A (sposta e ridisegna la vista);
  - $0DF2 (centra la vista su una casella, era lo stub `h048_0df2`).
- **Combattenti:**
  - $0956 (tabella di occupazione H005+$2BD2);
  - $0AA8 (numero del combattente);
  - $0F88 e $0FBA (posizione);
  - $0FEC (cambia fotogramma);
  - $110C (forma);
  - $113E (esamina le caselle in una direzione);
  - $12F4 (caduta: suono, animazione, corpo sulla mappa);
  - $16D4 (piazza un combattente);
  - $195E (cursore sul combattente).

**H077: aree e linea di vista (tutte le routine)**
- **Linea:** $0012, $01CC e $0242 (linea di Bresenham con costo 2 per passo, +1 in diagonale).
- **Visibilità:**
  - $0378 (linea di vista con le altezze di H005+$3EF4);
  - $0508 (settore di una direzione).
- **Lista dei combattenti:**
  - $0056 (ordina la lista H005+$2A3E);
  - $08AC (riempie la lista con chi è nell'area).
- **Correzione:** nel C la chiamata `h077_08ac(h048_110c(...), area)` era sbagliata. H048+$110C prende solo il personaggio; le altre quattro word restano sullo stack come argomenti di H077+$08AC, che ne ha sei: x, y, raggio, direzione, forma e mappa. Ora è `find_in_area(x, y, raggio, dir, combatant_size(c), area)` in tutti i chiamanti (H027, H062, H063).

**H063**
- **Proiettili:**
  - $1FDC e $2178 (fotogrammi del proiettile in $243A, anche specchiati);
  - $21D2 con la procedura annidata $21E0 (animazione del proiettile con le due View alternate).
- **Combattimento:**
  - $2B4C (lato opposto, spostata qui da H085);
  - $2BDE (nemici vicini, con il bersaglio preferito $2432 in testa);
  - $3658 (ridisegna il combattimento);
  - $3CA0 (direzione da un combattente all'altro).
- **Mappa:** $33A0 (riga di stato: coordinate, direzione, ora, " camping"/" search").

**H029, H035, H044, H049**
- **H029, doppio buffer:**
  - $14F6 (aspetta lo schermo in primo piano);
  - $1520 (copia lo schermo fuori schermo);
  - $1576 (scambia le View);
  - $16A2 e $16DE (inizio e fine di un aggiornamento annidato).
- **H029, tile 24x24:** $0B94, e $0D58 (stessa cosa con salvataggio dello sfondo).
- **H035+$019A:** tile della mappa.
- **H044+$0586:** cornice del combattimento.
- **H049+$04AE:** blit hardware piano per piano, con o senza maschera.
- **H049+$09D6 e $0A7A:** specchio orizzontale di un record grafico.

**Dati nuovi**
- **Strutture:**
  - `g_bodies[8]` (corpi sulla mappa, H005+$2AE2), struct `CokBody`; gli effetti di H027 ora usano questa al posto di H005_L;
  - `g_h005_2432` (bersaglio preferito);
  - `g_gfx_3304[2]` (fotogrammi della caduta);
  - `g_h029_m8` (View mostrata).
- **Host:** ho aggiunto `IntuitionBase->FirstScreen`. Lo imposta OpenScreen e lo azzera CloseScreen. Sull'Amiga c'è il nuovo include `<intuition/intuitionbase.h>`.
- **Firme corrette:**
  - H049+$09D6 ora è `mirror_gfx_record(src, dst)` nell'ordine di push: prima la sorgente;
  - H029+$0D58 ora è `draw_tile24_saving` (prima era uno stub).

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **H049+$04AE:** l'originale accoda un bltnode con QBSBlit e programma il blitter al passaggio del raggio. Qui scrivo gli stessi registri subito, piano per piano, con OwnBlitter/WaitBlit, come nella routine di testo già portata.
- **H048+$12F4, controllo iniziale:** legge una voce non inizializzata (-$6), fuori tabella se vale 0, e non trova mai il personaggio; qui è omesso.
- **H048+$12F4, nono corpo:** l'originale lo scriverebbe sopra i combattenti; qui non viene registrato.
- **H048+$0AA8:** con $247B = 0 l'originale scorre oltre la tabella; qui la ricerca si ferma a 40.
- **H077+$0508:** per una direzione oltre 8 restituisce un byte non inizializzato; qui 0.

**Comportamenti dell'asm mantenuti così come sono**
- **H049+$04AE, pixel in più:** con una destinazione non allineata a 8 pixel azzera ALWM e disegna 8 pixel del fotogramma vicino. Nel gioco le destinazioni sono sempre multiple di 8.
- **H048+$16D4:** scrive la casella a ogni giro del ciclo finché non trova un corpo.
- **H063+$3CA0:** cicla per sempre se nessun settore contiene la direzione.

**Prove**
- **Blit hardware:** test sull'host. H049+$04AE con il blitter emulato coincide con BltMaskBitMapRastPort e BltBitMap in 999 casi: larghezze 8/16/24, sorgente e destinazione multiple di 8, con e senza maschera.
- **Specchio:** H049+$09D6 testato su un record 24x24 (immagine e maschera), 0 differenze.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **ASan:** pulito sul menu principale.
- **Nuove routine nel gioco:** non provate, perché il combattimento non è ancora raggiungibile.

**Cosa resta**
- **Stub:** H043+$190E (audio) resta uno stub che salta.
- **Da portare:** chi carica $3304, $243A e $332C e chi prepara la mappa del combattimento, cioè l'avvio del combattimento in H095/H096/H097.

---

## 2026-11-10 (cok-port-31)

Ho portato l'avvio del combattimento, H095+$2496, che lo script (H059) chiama a ogni battaglia. Routine portate: 732 su 1066 (prima 705).

**H095: avvio del combattimento (tutte le 14 routine del modulo)**
- **$2496 `start_combat`, l'avvio:**
  - libera le immagini della mappa ($27B2, $27B8, $2798) e scrive "A battle begins...";
  - azzera lo stato del combattimento: nubi, pozze, corpi, armi perse, $2432, $2510, $335C;
  - costruisce la mappa, prepara i turni e schiera i combattenti;
  - alloca le icone $243A, centra la vista sul primo e ridisegna;
  - copia i colori nella View fuori schermo, lancia gli eventi 8 e $16 per tutti e calcola la forza dei nemici;
  - passa al contesto 5.
- **$1630 (mappa):** carica i set di tile (DungCom o WildCom, più RandCom) e alloca la mappa di $9CE byte.
- **Mappa del dungeon:**
  - $083A con le procedure annidate $0848, $0912, $09A4 e $0CD4: un blocco 7x5 per ogni casella attorno al party (colonne -6..6, righe -2..2), con pavimento, pareti e porte del dungeon;
  - $06F2/$0700: pareti fra due caselle;
  - $0392: casella del blocco;
  - $0422: alberi e cespugli nei blocchi all'aperto.
- **Mappa all'aperto:**
  - $1576: mappa libera;
  - $1076: alberi alti e oggetti;
  - $121A/$1228: erba e terreno.
- **Turni:** $1790, con il blocco del turno di ogni personaggio, la direzione iniziale e l'IA di chi è fuori combattimento.
- **Schieramento:**
  - $1FC2: punti di partenza dei due lati e griglie di schieramento;
  - $1A7A: ricerca a spirale con cambio di griglia;
  - $1914: prova una casella;
  - $18CC: fuori dalla griglia.

**Altre routine**
- **H011:**
  - $0162 (dentro la mappa 16x16);
  - $01AA (parete di un lato);
  - $04E2 (byte del piano GEO 2);
  - $09C8 (porta di un lato).
- **H029+$1718:** copia i 32 colori dello schermo nella View fuori schermo, leggendoli dalla lista Copper della View di Intuition.
- **H035+$0040:** carica un set di tile 24x24 nel set $332C.
- **H096+$37C2:** forza dei nemici in H005+$2481.

**Host**
- **View di Intuition:** `GfxBase->ActiView` all'avvio è una View senza ViewPort, quindi il display mostra lo schermo.
- **Lista Copper:** quella View ha una lista Copper con le MOVE COLOR00..31 dello schermo in primo piano. La aggiornano OpenScreen e LoadRGB4. Così H029+$1718 è portata com'è.
- **`struct cprlist`:** ora è definita nell'ndk dell'host.

**Errore trovato col test reale e corretto**
- **Problema:** dopo lo schieramento `$247B` vale numero di combattenti + 1 (come nell'originale), quindi H048+$0DF2 legge una voce vuota di $2B32.
- **Originale:** legge +$198 dalla memoria bassa e scarta la voce perché la sua forma è 0.
- **Qui:** la voce NULL si salta (deviazione documentata nel codice).

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **H010+$0360:** resta uno stub. È il messaggio "Start range error in Load24x24Set" sulla console, cioè il writeln del runtime Pascal (H020/H074/H075). Si raggiunge solo con un indice oltre $27, che le chiamate di H095 non usano.
- **Valori non inizializzati, qui messi a 0:**
  - le tile dei casi senza valore in $09A4 e $0CD4;
  - in $1A7A, l'esito quando si esce dalla griglia senza cambiarla;
  - in H011+$01AA, la parete di una direzione dispari.
- **Schieramento:** oltre 8 corpi non si registrano.

**Prove**
- **Test temporaneo (non committato):** con `COK_TEST_COMBAT`, "Begin adventuring" carica il personaggio L e chiama `start_combat()`, con `$3DE3 = 1` come nell'esplorazione.
  - All'aperto: mappa con alberi, cespugli e oggetti, il personaggio schierato, cornice del combattimento e "A battle begins...".
  - Nel dungeon: solo pavimento, perché nel menu i piani GEO non sono caricati.
  - ASan pulito in entrambi i casi.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Cosa resta**
- **Script che chiama l'avvio:** H059.
- **Ciclo del combattimento:** H096/H097 (turni, attacchi, IA, menu del combattimento).
- **Fine del combattimento.**
- **Audio:** H043+$190E.

---

## 2026-11-10 (cok-port-32)

La richiesta ripeteva "procedi con l'avvio del combattimento", che era già consegnato in cok-port-31. Ho quindi portato il passo successivo: il ciclo del combattimento (H059+$1782, Combat_MainLoop), che il comando COMBAT dello script (H012+$0766) chiama e che a sua volta chiama l'avvio. Routine portate: 760 su 1066 (prima 732).

**H059: ciclo del combattimento (tutte le 13 routine)**
- **$1782 `combat_main_loop`, il ciclo principale:**
  - prima del ciclo: contesto 5, gestore $276C (bersaglio in combattimento), avvio (H095) ed evento $18 per tutti;
  - a ogni round, finché restano entrambi i lati: inizio del round, ordine dei turni, turno di ognuno con le esplosioni dei caduti, fine del round;
  - alla fine: pulizia.
- **$0130:** ordine dei turni per iniziativa (+$4 del turno; a parità, a caso) nella tabella H005+$2392, ora `g_turn_order[72]`.
- **$1498:** turno di un attore (eventi 7, $F e $15, cursore, stato; automatico o col menu).
- **$1110:** turno del giocatore.
  - Comandi: Move, View, Aim, Use, Cast, Turn, Yell, Done.
  - Tasti speciali: tutti in automatico, magia on/off, $4DE8.
- **$03BE:** menu del turno.
- **$0726 con $0734:** movimento/attacco con le frecce del tastierino: costo delle caselle, "Flee:", "can't go there"; Esc annulla.
- **$0670:** attacco da vicino ("Not with that weapon").
- **$0EA0:** sottomenu Done: Guard, Delay, Quit, Bandage, Auto, Speed, Exit.
- **$0CCA:** velocità del gioco.
- **$0E4A:** controllo automatico.
- **$15EE:** fine del round:
  - un minuto di gioco, contatore dei round ed evento $13;
  - acido delle pozze; chi sta morendo muore dopo 10 round; "Your Teammate is Dying";
  - fine se un lato sparisce o dopo $2477 round, con "Continue Battle:".
- **$02AA:** pulizia: nubi, pozze, incantati, effetti legati, mappa, icone.

**Aiutanti portati**
- **H058, orologio di gioco:**
  - $064A (avanza il tempo);
  - $052C (riporti, invecchiamento);
  - $017C e $018A (icone della cornice a ogni ora);
  - $02F4 (durata degli effetti a passi di 10).
- **H062:**
  - $021E (Yell, "wants to kill");
  - $1038 (nubi: "starts to cough", "chokes and gags from nausea"; acido);
  - $0F24 (proprietario della nube);
  - $1694 (caduta con messaggio);
  - $1898 (vuota);
  - $17C0 ora è esportata.
- **H063:**
  - $3698 e $3734 (arma a distanza, uso da vicino);
  - $36EE (arma di tipo $43);
  - $3980 (bende, "is bandaged");
  - $2F5A (Guard, "Guarding").

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Tabella dei turni:** l'originale azzera 40 voci di $2392 ma scorre fino a $48; oltre la 40 coincide con $2432... Qui la tabella ha 72 voci; la lista chiusa da NULL non le supera.
- **Delay ($0EA0):** non legge la voce $48 fuori tabella.
- **H062+$0F24:** legge dirs[count] oltre la copia per valore (stack); qui il byte seguente di H005+$5022.
- **H063+$3734:** senza arma l'originale legge +$30 da NULL; qui no.
- **H058+$018A:** con un indice non previsto tile e colonna non inizializzate; qui 0.

**Stub nuovi (H096/H097, il prossimo passo)**
- **H096:**
  - inizio round $02CE;
  - attacco $38DC, $1340, $20E6, $2182;
  - fuga $10FA;
  - passo $0C3C e $099C;
  - $11D4, Aim $4448, Cast $3100, Turn $160A, $4DE8;
  - bersaglio $2A6C.
- **H097:** turno automatico $1D68.

**Prove**
- **Test temporaneo (non committato):** `combat_main_loop()` dal menu esegue avvio, controllo dei lati e pulizia con ASan pulito. Con il solo party non ci sono nemici, quindi i round non partono (per quelli servono H096/H097).
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Cosa resta**
- **H096:** azioni e attacchi.
- **H097:** IA.
- **H012+$0766:** il comando COMBAT dello script.
- **Audio.**

---

## 2026-11-10 (cok-port-33)

Primo passo di "Begin adventuring e la mappa del gioco": il cuore dell'interprete degli script ECL. Routine portate: 790 su 1066 (prima 760).

**Il piano, perché è un pezzo grande**
- **Mole:** dopo il menu principale il gioco entra in H012+$3150, il ciclo dell'esplorazione. Con l'interprete ECL e i suoi ~60 comandi (H064, H012), il menu e il movimento (H068), le aree (H061) e la vista 3D (H057, H011, H049, H042) fanno circa 22.700 istruzioni in 225 routine.
- **Consegne:**
  1. interprete (questa);
  2. comandi ECL di H064;
  3. comandi ECL di H012 e il ciclo $3150;
  4. menu, movimento e vista 3D.

**Correzione**
- **Begin adventuring:** il menu principale chiamava ancora lo stub `h028_0d74`, che fermava il programma, anche se H028+$0D74 era già portata come `free_char_screens`. Ora chiama quella.

**H061: servizi della VM ECL (33 routine su 34)**
- **Operandi:**
  - $1670 (lettura con descrittori; stringhe immediate e da variabile);
  - $184E (valore: byte, word, variabile, indirizzo);
  - $1F12 e $1F3C (indirizzi, base $4B00);
  - $1F6A (caratteri).
- **Stringhe:**
  - $3244 (testo compresso a 6 bit, quattro caratteri ogni tre byte);
  - $33F0 (stringa dalle variabili);
  - $162E (accoda un carattere).
- **Variabili:**
  - $1FA4 (zona: stato A $000.., stato B $3100.., stato C $2F00.., programma $3500.., registri speciali $754B..);
  - $2E04 e $2BAA (lettura e scrittura);
  - $208E e $27E2 (variabili dello stato B che leggono e scrivono il personaggio corrente: incantesimi, IA, valori, denaro, stato, lato, punti ferita, muri del dungeon);
  - $202C (posizione nel party).
- **Area:**
  - $1928 (inizio del programma: flag, PC $3500, pila vuota, i cinque ingressi $3DF4..$3DEC, azzeramento delle variabili dell'area);
  - $1ACC (carica il blocco ECLn.dax, "Loading...Please Wait").
- **Comandi di supporto:**
  - $3AAC (GOSUB, con la pila $2388);
  - $3E80 (salta un comando);
  - $3904 e $3A0A (confronti, risultati in $237E..$2383);
  - $3B4E (passo avanti nella mappa 16x16);
  - $1C42 (caselle libere davanti);
  - $36E6 e $35E2 (menu ECL con le scorciatoie '~').
- **Altro:**
  - $1BD6 (carica un mostro);
  - $1D20 e $1D6E (immagini dell'evento: sprite, PIC, testa+corpo);
  - $3DBE (oggetti distrutti);
  - $3FA8 (velocità minima e massima del party);
  - $4092 (messaggio del danno, "is hit for", "dies.").
- **Non ancora portata:** $3C4C, che scala il denaro con l'aritmetica reale del runtime H015.

**H012**
- **$018A `run_ecl`:** esegue il programma da un indirizzo finché un comando non lo ferma o non si lascia l'area.
- **$2DF2:** dispatcher dei 66 codici. I gestori di H064 (27) e di H012 (26) sono stub con nome, per le prossime consegne.

**H064:** i dati del modulo (personaggio salvato, flag della VM, testo) sono globali C.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Valori non inizializzati, qui messi a 0:**
  - i casi senza valore delle variabili speciali e dei registri;
  - i primi byte del testo a 6 bit.
- **$3FA8:** con il party vuoto l'originale legge un NULL; qui esce senza cambiare nulla.
- **Codice morto mantenuto:** i casi dei registri speciali con indirizzo basso non sono mai raggiungibili (quegli indirizzi cadono nello stato A).

**Prove**
- **Test temporaneo (non committato) con i dati veri:**
  - carica il programma dell'area iniziale ($24) da ECL1.DAX ed esegue $1928: i cinque ingressi ($365A, $365B, $3658, $3659, $3514) cadono nel programma;
  - da $3514 dodici comandi saltati con $3E80 si susseguono con lunghezze coerenti (LOAD_FILES $21 di 7 byte, poi le PRINT $11/$12 con testo a 6 bit);
  - ASan pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** i gestori dei comandi ECL di H064.

---

## 2026-11-10 (cok-port-34)

Secondo passo di "Begin adventuring": i gestori dei comandi ECL di H064. Routine portate: 825 (prima 790; il totale ora conta 1087 voci).

**H064: tutti i 27 gestori**
- **Controllo del flusso:**
  - $00 EXIT, $01 GOTO, $02 GOSUB, $13 RETURN (senza pila diventa EXIT);
  - $16..$1B IF (=, <>, <, >, <=, >=: se falso salta il comando seguente).
- **Confronti e calcoli:**
  - $03 COMPARE (stringhe se un operando lo è, altrimenti valori);
  - $14 COMPARE AND;
  - $04..$07 ADD, SUB, DIV, MUL (resto della divisione in $3E00+$67E);
  - $08 RANDOM;
  - $2F/$30 AND/OR bit a bit.
- **Variabili:**
  - $09 SAVE (valore o stringa);
  - $2A GETTABLE, $35 SETTABLE;
  - $0F INPUT NUMBER, $10 INPUT STRING.
- **Testo e menu:**
  - $11 PRINT e $12 PRINTCLEAR (finestra di testo con impaginazione);
  - $15 menu verticale (lista "Select");
  - $2B menu orizzontale con le scorciatoie '~' ("PRESS BUTTON OR RETURN TO CONTINUE." diventa la versione con Invio).
- **Personaggi e mostri:**
  - $0A LOAD CHARACTER (con il bit 7 il personaggio lascia il party);
  - $0B LOAD MONSTER (n copie con oggetti ed effetti, figure CPIC, punti ferita scalati con la difficoltà, al massimo $3F mostri);
  - $1C CLEAR MONSTERS (svuota anche il tesoro $2A3A);
  - $1D PARTY STRENGTH.
- **Incontro e immagini:**
  - $0C APPROACH e $0D (sprite e ritratto alla distanza dell'incontro);
  - $0E PICTURE (immagine grande, PIC o testa+corpo; $FF chiude).
- **Aree e mappa:**
  - $20 NEWECL (carica il programma di un'altra area);
  - $21 LOAD FILES e $37 LOAD PIECES (mappa GEO del dungeon e definizioni dei muri).

**Aiutanti portati**
- **H061:** $3012 (stringa nelle variabili) e $3860 (lista ECL con titolo "Select").
- **H030+$09A6:** chiede un numero.
- **H044:** $0330 (cornice dell'esplorazione) e $0452 (cornice all'aperto). Prima erano gli stub `h044_0330`/`h044_0452` chiamati dal menu principale e da H063.
- **H028+$1098:** disco dei dati, raggiunto dalle variabili dello stato B.
- **Nuovo globale:** `g_treasure_items` ($2A3A).

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **DIV con divisore 0:** sul 68000 genera un'eccezione; qui risultato 0 e resto invariato.
- **LOAD MONSTER:** le copie del mostro si fanno copiando il record C del personaggio (i $1AA byte dell'originale), poi si azzerano successivo, oggetti ed effetti come nell'originale.

**Restano stub, per il passo della vista**
- **Immagini (H042):** $0406, $0254, $1006, $10DC, $0F50.
- **Mappa e vista:** H011+$1876 (mappa GEO), H011+$14EA (muri), H060+$0018 (ridisegno della vista), H069+$0012.

**Prove con i dati veri** (test temporaneo, non committato)
- **Come:** il programma ECL dell'area iniziale ($24, ECL1.DAX) viene eseguito da `run_ecl`. Solo nel binario di test gli stub delle immagini erano non fatali.
- **Comandi eseguiti:** LOAD FILES, PICTURE, PRINTCLEAR/PRINT, GOSUB, menu orizzontale, RETURN, di nuovo testo, GOSUB e RETURN, due SAVE.
- **Testo:** a video compare "AT THE INN OF THE LAST HOME IN SOLACE, A BRAVE BAND GATHERS IN PREPARATION FOR A GRIM JOURNEY...", impaginato. È scritto sopra il menu perché la cornice dell'esplorazione non è ancora disegnata dal ciclo.
- **Arresto:** si ferma sul comando $3D, un gestore di H012 (prossimo passo).
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** i gestori ECL di H012 (26) e il ciclo dell'esplorazione H012+$3150.

---

## 2026-11-10 (cok-port-35)

**Richiesta:** "ok compila su sasc, procedi con i comandi ECL di H064". I comandi di H064 erano già in cok-port-34, quindi questo passo porta i comandi ECL di H012.

**Comandi ECL di H012 portati** (25 su 26, in `h012.c`, collegati al dispatcher `ecl_execute`)
- **Party e personaggi:**
  - $1E PARTY SURVEY ($01FA): minimo, massimo e media sul party (livello, valori +$E0.., velocità) o presenza di un effetto;
  - $22 ($05D6): c'è un ranger/guaritore (classe 4 o $A);
  - $32 ($1E90): qualcuno porta un oggetto del tipo dato;
  - $3B ($2596): cerca un incantesimo memorizzato (posizione e personaggio);
  - $3F ($2AF6): il personaggio corrente ha l'effetto dato;
  - $40 ($2B64): toglie a tutti gli oggetti del tipo dato;
  - $39 ($2486): sceglie il personaggio corrente;
  - $36 ($2502): aggiunge un PNG con la sua IA;
  - $3E ($2ABE): il personaggio corrente lascia il party;
  - $41 EXPERIENCE ($2C28): punti esperienza divisi per le classi.
- **Incontri e combattimento:**
  - $23 SURPRISE ($0688);
  - $24 COMBAT ($0766): combattimento (H059) o scena speciale, poi contesto 3/4 e ridisegno;
  - $29 ENCOUNTER ($15AE): COMBAT/WAIT/FLEE/PARLAY o ADVANCE, avvicinamento, "Both sides wait.", "The monsters flee.";
  - $2C PARLAY ($1DDE): HAUGHTY/SLY/NICE/MEEK/ABUSIVE;
  - $2E DAMAGE ($1F68): danno con tiro salvezza o tiro per colpire, "The entire party is killed!".
- **Tesoro:** $27 TREASURE ($0BEA): monete e oggetti dal blocco di ITEMn.DAX (record di $3F byte) o casuali (tabelle di H012).
- **Flusso e schermo:**
  - $25 ON GOTO e $26 ON GOSUB ($0B18);
  - $2D ($26D6): azioni speciali (vista, animazione, suono, muro, passo avanti);
  - $31 ($2358) chiude le immagini, $33 ($23D6) a capo, $34 ($2392) avanza il tempo, $3A ($1F4C) pausa, $3C ($2AAE) nulla;
  - $3D ($241C): ridisegna la schermata dell'esplorazione;
  - $38 ($29A6): menu del party (H013+$4BFC) o accampamento ($2922, portato anche questo).

**Aiutanti portati**
- **H031+$008A:** byte con segno.
- **H062+$126C:** tiro per colpire dei comandi ECL.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **PARLAY senza scelta valida:** l'originale legge oltre i cinque valori; qui 0.
- **EXPERIENCE con nessuna classe:** l'originale divide per 0 (eccezione del 68000); qui nessun punto.
- **$3C:** l'originale non avanza il PC (ripeterebbe il comando all'infinito); lasciato identico.

**Restano stub**
- **$28 ($14C8):** usa i reali di H015 e H061+$3C4C (soldi), non ancora portati.
- **Nuovi stub:** H042+$0300, H070+$1958, H071+$092C, H072+$120C, H066+$276E, H067+$1292, H057+$2F3A.
- **Ciclo dell'esplorazione:** H012+$3150, e H011+$04A6 (il ciclo del gioco), al quale arriva NEWECL.

**Prove con i dati veri** (test temporaneo, non committato)
- **Come:** i programmi ECL di 10 aree di ECL1.DAX ($10, $11, $12, $20, $21, $22, $24, $30, $31, $32) eseguiti da `run_ecl` col binario ASan; solo nel test gli stub delle immagini e del suono erano non fatali.
- **Comandi di H012 eseguiti:** $25 ON GOTO, $2D azioni speciali, $38 menu del party, $3D ridisegno, oltre a quelli di H064.
- **Arresto:** le aree arrivano a NEWECL e al ciclo del gioco H011+$04A6 (non portato); $11 e $12 restano nel menu del party in attesa di tasti.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** il ciclo dell'esplorazione H012+$3150 e il ciclo del gioco H011+$04A6.

---

## 2026-11-11 (cok-port-36)

**Richiesta:** "ok compila su sasc, procedi con il ciclo dell'esplorazione". Insieme è arrivato il log di SAS/C (smake.err) di cok-port-35: compilazione e link riusciti, con 7 warning, corretti qui.

**Ciclo dell'esplorazione (H012)**
- **$3150 `explore_loop`:**
  - Carica il programma ECL dell'area ($3E04+$1E4; $24 all'inizio, $39 nella dimostrazione) ed esegue l'ingresso $3DEC.
  - Poi ripete finché il party non è perduto ($24D0):
    - menu dei comandi;
    - Encamp ($2922);
    - ricerca e sguardo (un giro di $3DF2 con $594 = 1);
    - il passo, seguito dagli ingressi $3DF2/$3DF4;
    - i cambi di area.
  - Alla fine toglie tutti dal party.
- **$3020 (statica `enter_area`):** ingresso in una nuova area dopo NEWECL. Libera le immagini ed esegue $3DEC, $3DF4 e $3DF2 finché un comando chiede un'altra area.
- **H011+$04A6 `set_view_start`:** memorizza i quattro byte di partenza della vista. Prima era lo stub `h011_04a6`.
- **`h001_main.c`:** ora chiama `set_view_start` ed `explore_loop` al posto degli stub.

**H068 portato per intero** (esplorazione, menu, passi e porte)
- **$0C0E `explore_command_menu`:**
  - nel dungeon: "Move Area Cast View Encamp Search Look"; in Move le frecce danno passo, rotazioni e dietro-front;
  - all'aperto: "Move Encamp"; in Move le 8 direzioni del tastierino;
  - "Area" mostra la mappa (fuori dall'area serve la parola di $2358 in argv[2]); altrimenti "Not Here".
- **$122E `explore_move_or_door`:** passo libero oppure porta chiusa ("Locked. " con Bash/Pick/Knock/Exit); all'aperto il passo sulla mappa grande.
- **Aiutanti:**
  - $00CA apre la porta (piano GEO 3);
  - $00B2 vuoto nell'originale;
  - $02B8 classe nel party;
  - $0340 Bash (tabelle di forza);
  - $0748 Pick (+$E1);
  - $082A/$0890/$08E2 Knock (incantesimo $1F);
  - $0932 uscita dal bordo della mappa;
  - $0A1A passo nel dungeon;
  - $0B2C passo all'aperto.

**Altri portati**
- **H069+$0012 e $00A8:** segno del party sulla mappa all'aperto (disegna e ripristina lo sfondo). Prima lo stub `h069_0012`.
- **H029+$0E26 e $0E92:** salvano e ripristinano una cella dello schermo nel record.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Menu all'aperto con $3E04+$3EE nullo:** l'originale restituisce un byte non inizializzato; qui 0.
- **Comando Area:** l'originale legge argv[2] in ogni caso; qui solo se esiste (come in H013).

**Correzioni**
- **Stub superfluo in cok-port-35:** lo stub `h042_0300` era inutile, perché H042+$0300 era già portato come `release_picture_set`. COMBAT ora usa quello.
- **Warning di SAS/C di cok-port-35:**
  - 85, valore restituito di tipo int: h048 `shape_cell`/`combatant_index`, h095 `place_in_spiral`. Aggiunti i cast.
  - 217, macro che chiama una funzione più volte: h048 `combatant_x`/`combatant_y`, h063 righe 1130-1131. L'indice si legge una volta in una variabile.

**Restano stub**
- **H011+$0B78:** vista 3D del dungeon.
- **H057+$0C04:** lancio di incantesimi.
- **H042:** immagini.
- **H060+$0018:** ridisegno della vista.
- **H066+$1FDA:** usato da un evento del dungeon.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Come:**
  - stub di immagini, suono e vista non fatali;
  - tasti inviati quando un menu attende;
  - log dei menu.
- **Città:** "Begin adventuring" porta nel ciclo. Solace mostra il menu ECL "Inn Hall Commandant Armoury Next Leave".
- **All'aperto:**
  - Leave fa NEWECL nell'area $10 (contesto 3) e compare il menu dei comandi "Move Encamp";
  - Move e le frecce spostano il segno del party;
  - la nuova casella avvia l'evento vero ("As you top a rise, you spot a caravan under attack...").
- **Dungeon** (partenza forzata nell'area $30, contesto 4):
  - compare "Move Area Cast View Encamp Search Look";
  - da 7,13: su → 7,12; destra + su → 8,13 verso est; due volte sinistra + su → 7,13 verso ovest; dietro-front + su → 8,13;
  - Search e Area rispondono;
  - un evento più avanti si ferma su H066+$1FDA (non portato).
- **ASan:** pulito in tutte le prove.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** la vista 3D del dungeon (H011+$0B78 e aiutanti), il ridisegno H060+$0018 e le immagini di H042.

---

## 2026-11-11 (cok-port-37)

**Richiesta:** "ok compila su sasc, procedi con la vista 3D del dungeon". Durante il lavoro è arrivata la domanda "ora dovrei essere in grado di fare begin adventuring su mappa non disegnata?".
- **Risposta:** con cok-port-36 no. Gli stub delle immagini (H042) erano fatali, quindi il gioco si fermava su H042+$10DC subito dopo l'avvio, e la mappa GEO non veniva caricata. Questa consegna risolve entrambe le cose.

**Vista 3D e mappe (H011)**
- **$1876 `load_geo_map`:** carica la mappa GEOn.dax: quattro piani da $100 byte in $282A, registrata in $3E04+$18A. Se manca: "Unable to load geo in Load3DMap.".
- **$14EA `load_wall_defs`:**
  - carica le definizioni WALLDEFn.dax nelle posizioni 1..3 del buffer $282E (blocchi di $30C byte, cinque muri da $9C tessere);
  - sposta le tessere da $3EBC in su al set della posizione;
  - carica i set 8x8 (id*10+k se il blocco ne ha più d'uno) e ricorda id e posizione in $2810;
  - se manca: "Unable to load nnnn from WALLDEFn".
- **$0B78 `draw_3d_view`:**
  - con la mappa attiva ($2825) disegna la mappa dall'alto;
  - altrimenti disegna lo sfondo e i muri delle caselle a distanza 2, 1 e 0, dal fondo verso il party, con i pezzi 0..9 (frontali, laterali e giunti);
  - alla fine mostra il buffer e ricarica la palette.
- **Aiutanti:**
  - $0868: pezzo di muro, rettangolo di tessere 8x8 dalle tabelle del modulo; la tessera 0 è trasparente;
  - $058E: cielo del colore $2829, sole secondo ora e direzione, immagine verso nord, pavimento;
  - $0330: mappa dall'alto 11x11.
- **H049+$0014 `draw_8x8_tile_masked`:** tessera 8x8 con la maschera del set.
- **H060+$0018 `refresh_view`:** sceglie il colore del cielo dalla tabella locale ($3E04+$1FA/$1FC secondo il bit 7 della casella), toglie la mappa se l'area la vieta ($1F6) e ridisegna la vista; all'aperto ridisegna l'immagine (H042+$10DC).
- **H010+$0360 `console_writeln`:** il writeln del runtime (H020) sulla console, qui con stdio. Prima era uno stub fatale, usato anche da H035.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Colore del cielo:** un indice oltre la tabella leggerebbe lo stack; qui 0.

**Immagini (H042) non fatali**
- **Quali:** $0254, $0406, $0B80, $0D70, $0ED2, $0F50, $1006 e $10DC ora sono saltati con un messaggio sulla console, come già l'audio H043.
- **Effetto:** si può esplorare senza le immagini degli eventi.
- **Restano fatali:** le routine non grafiche, per esempio Cast (H057+$0C04), Encamp (H057+$2F3A) e H066+$1FDA.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Come:** l'ingresso dell'area $30 esce subito senza LOAD FILES (dipende dallo stato del gioco), quindi per la prova si caricano GEO 48, WALLDEF 1 (posizioni 1-2, set 8x8 11 e 12) e WALLDEF 23 (posizione 3).
- **Vista 3D:**
  - mostra cielo con nuvole verso nord, pavimento di ciottoli, muri di pietra e porte di legno su tre distanze;
  - girando e camminando (7,13 → 7,12 → 8,12 → 7,12 → 6,12) cambia coerentemente;
  - davanti agli edifici scattano gli eventi ECL: "YOU SEE A SIGN. GARGATH INN", "THE TRENCHER TAVERN".
- **Area:** mostra la mappa dall'alto della città con la freccia del party.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** le immagini di H042 (eventi, ritratti, immagine grande e mappa all'aperto), poi Cast (H057+$0C04) ed Encamp (H057+$2F3A).

---

## 2026-11-11 (cok-port-38)

**Richiesta:** "ok compila su sasc, procedi con le immagini di H042".

**H042 portato per intero** (le routine rimaste)
- **$0406 `load_sequence` (Load_Sequence):**
  - carica una sequenza (PIC, FINAL, SPRIT e altre) da name+disco.daa nell'insieme $27BC;
  - directory: word della dimensione, poi voci da 6 byte (id, un byte, offset long);
  - intestazione compressa ByteRun1: righe, unità, w4, w6, fotogrammi, palette di 32 colori per $52AE, dimensioni compresse;
  - il primo fotogramma va in `g_pic_rec_27c2`; con due fotogrammi il secondo è subito in `g_pic_rec_27c6`, salvato come XOR del primo; con più fotogrammi restano compressi in `g_pic_buffers`;
  - PIC e FINAL non hanno trasparenza e, senza $24D4, un solo fotogramma;
  - mostra "Loading...Please Wait" se $24D4.
- **$0B80 `sequence_frame`:** restituisce il record del fotogramma. Il primo e l'ultimo decodificato vengono restituiti dopo una pausa di 11 tick; gli altri si decomprimono e si combinano in XOR col primo.
- **Ritratti e sprite:**
  - $0D70 `load_head_body`: HEAD/BODYn.daa, solo se cambiano;
  - $0ED2 `draw_head_body`: testa, e il corpo 5 celle sotto ($02B2/$02D6);
  - $0F50 `show_3d_sprite`: fotogramma 1..3 mascherato nella vista; fuori intervallo "Illegal range in Show3DSprite." e uscita.
- **Immagine grande e mappa all'aperto:**
  - $1006 `load_big_picture`: BIGPICn.daa in $2798, con la palette in $526E;
  - $10DC `show_big_picture`: l'immagine nella cornice dell'aperto;
  - $0254 `show_picture`: record nella cella (x, y) con la palette $52AE.
- **Aiutanti statici:** $01AE copia specchiata del record; $03BC XOR fra bitmap.

**Altri portati ed esportati**
- **H020+$085A `console_write` e $082E `console_newline`:** write/writeln del runtime, qui con stdio. `console_writeln` (H010+$0360) ora li usa.
- **Già portate, ora pubbliche:** `dax_open` (H028+$0B80) e `transfer_gfx_planes` (H029+$091E).

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Più di 6 fotogrammi:** leggerebbero oltre l'intestazione di $56 byte; qui al massimo 6.
- **Immagini specchiate a caso:** fedele all'originale. Il flag $-2 di H042 viene da H023+$0010 (numero casuale 0/1) e, se vale 1, i record vengono specchiati in orizzontale.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Sequencer di prova:** ora invia un tasto per ogni nuovo menu.
- **Immagini viste:**
  - all'avvio, l'immagine grande della locanda di Solace col testo;
  - la mappa di Krynn con le località (BIGPIC) e il segno del party;
  - il ritratto di Sir Karl (PIC);
  - la via di Solace sopra il menu della città;
  - all'aperto, l'immagine della carovana attaccata dai draconici.
- **Arresto:** subito dopo il gioco si ferma su H066+$1FDA (non grafica).
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** H066+$1FDA (incontro all'aperto), poi Encamp (H057+$2F3A) e Cast (H057+$0C04).

---

## 2026-11-11 (cok-port-39)

**Richiesta:** "ok compila su sasc, procedi con H066+$1FDA".

**Portato: H066+$1FDA (Load_MonsterRecord)** — `load_monster_record(id, c)`, corpo a $206A, chiamato da LOAD MONSTER tramite `load_monster` di H061.
- **Record del mostro (MONnCHA.dax), in formato PC:**
  - nome (15 caratteri);
  - 15 blocchi copiati in posizioni spostate;
  - sei byte con segno allargati a word (+$58, +$116, +$118, +$18A, +$1A4, +$1A6);
  - word e long girati (+$62, +$11E, +$13C, +$F0..+$FC, +$18C).
- **Puntatori:** quelli del record (effetti, oggetti, successivo, blocco del turno) vengono azzerati.
- **Errore:** se il record manca, "Unable to load monster" e uscita.
- **Effetti (MONnSPC.dax):** voci da 9 byte.
- **Oggetti (MONnITM.dax):** record da $3F byte, convertiti come nel comando TREASURE.
- **$24A4:** vale 1 durante il caricamento di effetti e oggetti.
- **Aiutante:** $1FE8, nome del file "MON" + disco + parte.

**Dove mi discosto dall'asm (documentato nel codice)**
- **Oggetti pronti (+$154..):** nell'originale restano i byte del file; qui sono vuoti.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Mostro caricato:** dopo l'immagine della carovana, LOAD MONSTER carica il mostro 1, "BAAZ" (il draconico), con un effetto.
- **Arresto:** il gioco arriva al combattimento e si ferma su H096+$02CE (IA del combattimento, non portata).
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** le routine di H096 usate dal combattimento (IA dei mostri), poi Encamp (H057+$2F3A) e Cast (H057+$0C04).

---

## 2026-11-11 (cok-port-40)

**Richiesta:** "ok compila su sasc, procedi con le routine di H096".

**H096 portato per intero** (34 routine: azioni, attacchi, mira e incantesimi del combattimento)
- **Inizio turno:**
  - $02CE `combat_prepare_turn`: blocco del turno, iniziativa (d6 + destrezza, -6 se sorpresi), punti movimento;
  - $11D4 `combat_attacks`: attacchi del round, con la cadenza delle armi a distanza;
  - $0200 arrotondamento;
  - $023E movimento.
- **Movimento:**
  - $099C `combat_step`: passo col costo del terreno;
  - $0C3C `combat_leave_attacks`: attacchi di chi si allontana da un nemico;
  - $08B2 attacchi di opportunità;
  - $10FA `combat_flee`: "Got Away" o "Escape is blocked".
- **Attacco:**
  - $2182 `combat_attack`: orientamenti e figure, proiettile, risoluzione, munizioni; le armi da lancio esaurite finiscono nel tesoro dopo l'ultima lanciata, nuovo globale `g_thrown_tail` ($335C);
  - $1BE0: tiri, danno e messaggi, "slays helpless";
  - $0434 danno, con la pugnalata alle spalle ($3358);
  - $0530 messaggi ("Hitting for n points of damage", "and Misses", "goes down", "is killed", "lost a spell");
  - $251C penalità di distanza;
  - $1340 `combat_sweep` (spazzata);
  - $20E6 `record_attack`;
  - $1562 può attaccare;
  - $3492 animazione dei proiettili per tipo d'arma.
- **Turn Undead ($160A):** tabella locale 7x13 generata dalle istruzioni asm, con le stesse anomalie dell'originale; $1B04 trova il non morto.
- **Mira:**
  - $4448 `aim_target`, con le annidate $4456 e $4530: Next/Prev/Manual/Target/Center/Exit;
  - $39D0 riga "Range =" e menu;
  - $3DBA cursore manuale;
  - $3C48 conferma e attacco;
  - $38DC `confirm_attack` ("Attack Ally:").
- **Incantesimi in combattimento:**
  - $3100 `combat_cast` ("Begins Casting" e riordino dei turni);
  - $2A6C `combat_spell_targets` (vettore $276C): bersagli singoli, multipli, a dadi vita, ad area;
  - $284C bersaglio;
  - $25DA bersaglio di cura;
  - $4B86 bersaglio dell'IA.
- **Altri:** $3852 movimento dei nemici; $4DE8 sempre 0.
- **Struttura nuova:** `CokAim` (mira: personaggio, x, y) al posto del buffer di byte in H059.

**Altri portati**
- **H033+$11FC `spell_range`:** gittata dell'incantesimo.
- **H046+$0012 `cursor_direction`:** tasto di direzione verso il cursore. Serviva al Move in combattimento.
- **H063+$1FDC:** `copy_sprite_frame` ora è esportata.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Arma pronta mancante:** l'originale legge +$30 dall'indirizzo 0; qui il controllo si salta.
- **Turn Undead fuori tabella:** un indice oltre la tabella legge lo stack; qui vale $6363 (mai riuscito).
- **Bersagli degli incantesimi, nessuno scelto:** l'originale legge la voce prima di $2520; qui la posizione resta quella di prima.
- **Mira:** con l'elenco vuoto si resta su chi mira; con Manual su una casella vuota non si legge da NULL.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Arresto senza IA:** il combattimento della carovana parte e si ferma su H097+$1D68 (IA dei mostri, non portata).
- **Prova con l'IA saltata:**
  - compare il menu del turno "Move View Aim Use Done";
  - Move sposta il personaggio sulla mappa (Move Left 12 → 8);
  - Aim mostra "Range = n" e "Next Prev Manual Center Exit" e scorre i bersagli;
  - Target non compare perché i draconici sono fuori gittata.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** H097, l'IA dei mostri (13 routine, circa 2000 righe di asm).

---

## 2026-11-11 (cok-port-41)

**Richiesta:** "ok compila su sasc, procedi con H097".

**H097 portato per intero** (IA dei combattenti guidati dal computer)
- **$1D68 `monster_turn`:** il turno del mostro, nell'ordine:
  - tasti;
  - sequenza di movimento (+$17);
  - morale ("flees in panic");
  - oggetto magico;
  - incantesimo in corso;
  - Turn Undead;
  - incantesimo;
  - scelta delle armi;
  - attacco o fine turno.
- **$00B0 tasti durante il turno dei mostri ($5305):**
  - '2' "Magic On/Off";
  - spazio toglie il controllo automatico al party;
  - 4 chiama H096+$4DE8.
- **Morale e fine turno:**
  - $043A: "is forced to flee", tiri contro ferite e forza del gruppo, fuga (togliendo gli effetti $4A/$4B) o "Surrenders";
  - $0244: fine turno o guardia.
- **Oggetti e incantesimi:**
  - $0620 con l'annidata $062E: l'incantesimo è utile? (nemici nella gittata, nessun alleato colpito dall'area);
  - $0890 oggetto magico;
  - $0A04 Turn Undead;
  - $0A88 incantesimo memorizzato.
- **Armi:** $0C14 scelta (da lancio o a distanza con munizioni, mischia, scudo, mani +$188); $02B2 valore dell'arma.
- **Movimento:**
  - $142C passo verso il bersaglio o in fuga, con le sequenze della tabella del modulo; "Move/Attack, Move Left = n";
  - $11EE il passo è possibile? (costo, nuvole, acido).
- **$18D2 attacco:** bersaglio nella gittata in vista o un nemico vicino, spazzata o attacco normale.
- **Esportate per H097:**
  - da H096: `movement_points`, `can_attack`, `find_undead`, `find_heal_target`, `enemy_distance_points`, `ai_pick_target`;
  - da H065: `use_item`.

**Correzioni trovate giocando**
- **H048 `combatant_falls` (bug di porting):** il globale `g_gfx_3304` non veniva mai caricato.
  - Causa: $3304 è il posto $18 della tabella dei set di sprite $3244, cioè `g_sprite_sets[0x18]`, non un globale separato.
  - Effetto: ASan segnalava un accesso a NULL quando un combattente cadeva.
  - Correzione: il globale è stato rimosso e il codice usa la tabella.
- **Host (`host/graphics.c`):** AllocRaster alloca 4 byte in più.
  - Causa: il blitter emulato, con una sorgente non allineata alla word, legge una word oltre la fine dell'ultima riga.
  - Sull'Amiga quella lettura è innocua; qui ASan la segnalava ridisegnando la casella del corpo caduto.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **H097+$0620:** dove l'originale restituisce un registro non impostato, qui 0.
- **H097+$0A04:** il tipo massimo passato a H096+$1B04 nell'originale non è inizializzato; qui $FF.
- **H097+$043A:** con il massimo dei punti ferita a 0 l'originale divide per 0; qui il mostro conta come illeso.
- **H097+$18D2:** il bersaglio NULL non viene letto.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Battaglia della carovana,** con "Done → Guard" a ogni turno del giocatore:
  - i Baaz si avvicinano (Move Left 12 → 4);
  - attaccano ("Baaz attacks L, hitting for 4 points of damage", "and misses", "(from behind) hitting for 5 points");
  - i punti ferita di L scendono da 12 a 5.
- **Arresto:** a fine combattimento il gioco si ferma su H070+$1958 (scena dopo il combattimento, non portata).
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** H070+$1958 (fine del combattimento), poi Encamp (H057+$2F3A) e Cast (H057+$0C04).

---

## 2026-11-11 (cok-port-42)

**Richiesta:** "ok compila su sasc, procedi con H070+$1958".

**H070 portato per intero** (fine del combattimento)
- **$1958 `combat_end`:**
  - gli oggetti caduti tornano a chi li aveva ($18BE);
  - esito ($0778): sconfitta $24D0, vittoria $24C0, fuga; gli effetti del combattimento vengono tolti; chi era fuggito o svenuto si rialza; chi non c'è più esce dal party;
  - i nemici vengono tolti dal party ($152E);
  - se il party c'è ancora:
    - quote dei PNG, "takes and hides his/her share" ($165C);
    - schermata dell'esito ($0B9E: "The party has fled.", "You have lost the fight.", "The party has won.", "Each character receives n experience points.");
    - schermata del tesoro ($1136);
  - se il party è distrutto: "The monsters rejoice for the party has been destroyed.".
- **Esperienza:**
  - $0280: valore dei nemici sconfitti; le loro monete nella cassa e i loro oggetti nel tesoro; valore della cassa e degli oggetti magici; diviso per i personaggi;
  - $0558: assegnazione col 10% per la caratteristica principale della classe, metà o un terzo alle classi multiple.
- **Tesoro:**
  - $1136 menu View/Take/Pool/Share/Detect/Exit, con conferma se resta tesoro;
  - $0F8A Take (Money/Items);
  - $0E94/$0DE0 elenco "Items:" e Take.
- **H067:**
  - $0794 Pool;
  - $086E;
  - $08CC Share (nei limiti del carico);
  - $0D0A;
  - $0F72 Take Money ("Select type of coin", "How much ... will you take?");
  - $11F4 c'è tesoro?
- **H071+$047C `take_item`:** il personaggio corrente prende l'oggetto, salvo "OverLoaded".
- **H006+$0914 `reset_game_state`:** azzera lo stato per una nuova partita, chiamato da `h001_main` dopo l'esplorazione.
- **Esportate:** `item_overloads` (H065+$32F6). Per l'elenco del tesoro si costruisce una lista di voci di menu, come in H065.

**Dove mi discosto dall'asm (tutto documentato nel codice)**
- **Esperienza con divisore 0:** l'originale va in eccezione; qui il totale.
- **Share senza personaggi del giocatore:** l'originale divide per 0; qui nessuna divisione.
- **Rimozione dal party (sconfitta):** dove l'originale legge il successivo di un personaggio già tolto, qui lo legge prima.
- **Take Money:** l'elenco si libera anche uscendo senza scelta.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Sconfitta:** la battaglia della carovana (L da solo contro i Baaz) finisce con il party distrutto.
  - Compaiono "The monsters rejoice for the party has been destroyed." e "Press any key to continue".
  - Lo stato si azzera e il gioco riparte dalla verifica del manuale.
- **Non provato:** il ramo della vittoria (esperienza, tesoro, Take, Pool, Share), perché un personaggio solo non vince questa battaglia.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

**Prossimo passo:** Encamp (H057+$2F3A) e Cast (H057+$0C04).

---

## v43: Encamp (H057+$2F3A) e Cast (H057+$0C04)

**Portato**
- **h057.c** (tutto il modulo tranne l'inizializzazione, gia' presente):
  - $2F3A `encamp`: menu "Save View Magic Rest Alter Fix Exit" nel contesto 2; all'uscita ricarica l'immagine PIC della zona e annulla lo studio in attesa;
  - $0C04 `cast_spells` (Cast), con $0AE0 (si puo' usare la magia?);
  - menu Magic ($1DD8): Cast, Memorize ($1342), Scribe ($1590), Display ($18D6, elenco degli effetti con la procedura annidata $18E4), Rest ($11AC);
  - $05B4 tempo di studio, $078E/$07E8/$0878 annullano lo studio in attesa, $08B4 posti liberi, $0CD4 tabella dei posti e incantesimi bonus, $126C ordinamento;
  - menu Alter ($27B2): Order ($220E con $1EE0, $1FD6, $20A0), Drop ($2368), Speed ($25AE), Icon, Pics, Level ($24AE);
  - Fix ($29DA con le annidate $29E8, $2A06, $2AFE, $2BBA, $2C08, $2DC8).
- **h058.c:** il riposo:
  - $1014 `rest_party` (a passi di 5 minuti, interrompibile, con incontri casuali);
  - $05F4, $070E, $084C (riga "Rest Time"), $09AA (menu "Rest Days Hours Mins Add Subtract Exit");
  - $0B84 (cura ogni $120 passi), $0C38 e $0D2C (memorizza e trascrive), $0E80, $0F5C.
- **H044+$0492 `draw_memorize_frame`:** cornice della scelta degli incantesimi da memorizzare, che serviva a Memorize.
- **Chiamanti collegati:** `ecl_camp_entry` (H012) chiama `encamp`; il menu del dungeon (H068, 'C') chiama `cast_spells`. Tolti gli stub h057_2f3a, h057_0c04 e h044_0492.

**Dove mi discosto dall'asm (documentato nel codice)**
- **Fix, H057+$2C08:** il contatore locale -$2(a5) non e' inizializzato nell'originale; qui parte da 0.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Percorso:** Leave, poi Encamp dal menu "Move Encamp".
- **Magic:**
  - Memorize: grimorio con la tabella "Cleric Spells 3 / Special Spells 1", scelta di Resist Cold, conferma;
  - Display: "<No Spell Effects>";
  - Cast: nessun incantesimo pronto;
  - Scribe: "has no copyable scrolls".
- **Rest:** "Rest Time 00 04 15", piu' 2 ore con Hours/Add; dopo il riposo il tempo e' 06:15 e compare "L has memorized Resist Cold".
- **Altro:** Alter, Save (scelta della partita), uscita dal campo e rientro.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **Non provato:** Fix con il party ferito, Drop e Order con piu' personaggi.

---

## v44: H066+$276E (aggiunge un PNG al party)

**Portato**
- **H066+$276E `add_npc`:** se il party non ha piu' di 7 membri (stato B +$67C), alloca il personaggio, carica il record dei mostri npc (H066+$1FDA), scrive il numero in +$11C, lo aggiunge al party (H066+$27EE) e carica le icone "CPIC" npc nel suo posto (+$143, H035+$0246).
- **Chiamante:** il comando ECL $36 (`ecl_add_npc`, H012+$2502) chiama `add_npc`; tolto lo stub h066_276e.

**Prove con i dati veri** (binario ASan di test con un aggancio temporaneo, non committato, che chiama `add_npc(1)` entrando al campo)
- Il Baaz (record 1) entra nel party come secondo membro e diventa corrente; View mostra la sua scheda (Fighter livello 2, 9/9 punti ferita, Steel 5).
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

---

## v45: H067+$1292 (oggetto casuale)

**Portato**
- **H067+$1292 `random_item`:** crea un oggetto casuale del tipo dato per il tesoro casuale dei comandi ECL.
  - **Armi, armature e simili** (tipi $01..$25, $32, $3B, $46, $47; parte $144E): bonus +1 (90%) o +2 da $125A, nome, peso (+$3E) e valore (+$42) per tipo.
  - **Pergamene $27 (MU, rosse o bianche) e $28 (da chierico)** (parte $17FA): 1..3 incantesimi dalle tabelle di word di H005 ($1476..$1552).
  - **Oggetti speciali** dal modello locale di 7 record (-$7C(a5)): pozioni ($30, $35), bacchetta ($34), e il giavellotto speciale (tipo 7, 1 su 5).
- **Chiamante:** il tesoro casuale dei comandi ECL (H012) chiama `random_item`; tolto lo stub h067_1292.

**Prove con i dati veri** (binario ASan di test con un aggancio temporaneo, non committato, che genera ogni tipo da 1 a $47 tre volte e ne costruisce il nome)
- Armi e armature con peso e valore per tipo (Plate Mail 450/2500, Arrows 4/75, Bracers bonus 4 e 6000).
- "Red MU Scroll" e "White MU Scroll" con 2-3 incantesimi; "Cler Scroll 1/2/3 Spells"; Potion; Wand; Ring; il giavellotto speciale (valore 1500).
- I tipi senza ramo restano vuoti, come nell'originale.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

---

## v46: H071+$092C (il negozio)

**Portato**
- **H071+$092C `shop`:** il negozio (contesto 1), menu "Buy View Take Pool Share Appraise Exit" ("Buy View Pool Appraise Exit" se la cassa e' vuota). Uscendo con denaro nella cassa il negoziante chiede di tornare a prenderlo (H030+$0302, H061+$36E6).
- **H071+$0572 Buy:** prezzo = valore scalato dal bit piu' alto del byte basso di g_state_b +$6DA; paga il personaggio (tutto in acciaio, H067+$032A) o la cassa (H067+$02AE/$0374); "<nome> buys (a) <oggetto>", "Not enough Money.".
- **H071+$012A:** elenco "Items:" con i prezzi allineati a destra su 30 colonne; i nomi si ricompongono dopo. Come in H070, per il menu a elenco si usa una lista di voci con gli stessi nomi.
- **H067+$1D7C `appraise_gems` (Appraise):** valuta una a una gemme e gioielli; Sell o Keep.
- **H067+$03BC:** il personaggio riceve l'acciaio; se sovraccarico il resto va nella cassa.
- **Esportata:** `wealth_in_steel` (H065+$347E).
- **Chiamante:** il comando ECL del negozio (H012) chiama `shop`; tolto lo stub h071_092c.

**Dove mi discosto dall'asm (documentato nel codice)**
- **Buy:** se g_state_b +$6DA non ha bit accesi l'originale usa un indice non inizializzato; qui 0.
- **Elenco:** un nome vuoto farebbe copiare 64K byte all'originale; qui nulla.
- **Uguale all'originale, da notare:** con Keep, se il personaggio non ha oggetti la gemma creata non viene agganciata (resta solo nella variabile locale).

**Prove con i dati veri** (binario ASan di test, non committato)
- **Armoury** dal menu iniziale: elenco degli oggetti con i prezzi (Ring Mail 8, Short Bow 10, 1 Diamond 500).
- **Buy** della Ring Mail: "L buys a Ring Mail".
- **Appraise:** "No Gems or Jewelry". View ed Exit.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **Non provato:** Appraise con gemme vere, uscita con denaro nella cassa.

**Correzione per SAS/C (warning 94 in h070.c, riga 754):** in `combat_end` la variabile `special` non era mai assegnata e serviva solo al `(void)`; tolte la dichiarazione e il `(void)`.

---

## v47: H072+$120C (il tempio)

**Portato** (h072.c, tutto il modulo)
- **$120C `temple`:** menu "Heal View (Take) Pool (Share) Appraise Exit" nel contesto 1; uscendo con denaro nella cassa un sacerdote chiede se tornare a prenderlo.
- **$0EBE Heal:** elenco delle cure ("<nome>, how can we help you?", "Heal Exit").
- **$0312:** "cast cure anyway: " quando il personaggio non ne ha bisogno.
- **$036C:** "<cura> will only cost N steel pieces." e "pay for cure"; paga il personaggio o la cassa, altrimenti "not enough money.".
- **Le cure:**
  - $050A Cure Blindness (500);
  - $05AA Cure Disease (500, i 6 effetti di -$C(a4));
  - $06BC le ferite: leggere 50, gravi 175, critiche 300, Heal 2500;
  - $0910 Raise Dead (2750);
  - $0C04 Neutralize Poison (500);
  - $0D24 Remove Curse (1750, con l'azione dell'incantesimo in $2668);
  - $0E0A Stone to Flesh (1000).
- **Chiamante:** il comando ECL del tempio (H012) chiama `temple`; tolto lo stub h072_120c.

**Dove mi discosto dall'asm (documentato nel codice)**
- **Heal ($06BC, caso 4):** l'originale tira 1d4 solo se si paga, ma la cura (punti ferita massimi meno il tiro, piu' la rimozione degli effetti) avviene comunque, con la variabile -$2(a5) non inizializzata. Qui la variabile vale 0: senza pagare il personaggio viene curato del tutto, come accadrebbe nell'originale con quel valore.
- **Uguale all'originale, da notare:** in Raise Dead la divisione e la sottrazione dei punti ferita massimi si ripetono per ogni classe del personaggio; l'elenco ha 10 voci, quindi "exit" non compare.

**Prove con i dati veri** (binario ASan di test, non committato)
- **Percorso:** Next, poi Temple dal menu della citta'.
- **Heal:** l'elenco mostra le 10 cure; scelta di Cure Light Wounds: "Cure Light Wounds will only cost 50 steel pieces.", "pay for cure" (No).
- **Uscita:** dal tempio senza denaro nella cassa.
- **ASan:** pulito.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.
- **Non provato:** le cure pagate su un personaggio che ne ha bisogno.

---

## v48: H012+$14C8 (comando ECL $28, ROB)

**Portato**
- **H012+$14C8 `ecl_rob`:** tre operandi.
  - Il personaggio corrente (primo operando 0) o tutto il party perde il secondo operando per cento di monete, gemme e gioielli.
  - Ogni oggetto ha il terzo operando per cento di andare distrutto (H061+$3DBE, gia' portata).
- **H061+$3C4C `scale_money`:** moltiplica +$F0..+$FC per la quota che resta, (100 - p) / 100, troncando.
- **H015+$010C/$0122/$0172/$0184:** i salti del runtime a mathffp.library (SPMul, SPDiv, SPFlt, SPFix), con i numeri FFP tenuti come u32 (`CokReal`).
  - Su Amiga chiamano la libreria, gia' aperta da H015 (MathBase): niente aritmetica float in C, quindi lo smakefile non ha bisogno di librerie matematiche.
  - Sull'host convertono da e verso FFP e calcolano in singola precisione IEEE (stessi 24 bit di mantissa).
  - Ordine dei registri di SPDiv (D1 divisore, D0 dividendo) dalla documentazione di kb.marrani.lol.
- **Dispatcher:** il comando $28 del dispatcher di H012 chiama `ecl_rob`; tolto lo stub h012_14c8.

**Dove mi discosto dall'asm**
- **Arrotondamento sull'host:** la documentazione non dice come arrotonda mathffp, quindi una differenza dalla libreria Amiga e' possibile solo nell'ultimo bit dei risultati.

**Prove**
- **FFP sull'host** (programma di prova): 1,0 = $80000041, 100 = $C8000047, 70/100 = $B3333340; il 70% di 0, 5, 10, 15, 20 da' 0, 3, 7, 10, 14; il 25% di 1234 da' 308.
- **Non provato in gioco:** serve uno script ECL che usi ROB.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

---

## v49: H033+$1A40 e gestori di H085 ($15FE, $172A con $0BB2, $363E, $38AA)

**Correzione per SAS/C (warning 625, "proper math library has not been included")**
- **Causa:** in v48 i salti a mathffp di h015_runtime.c usavano una union con FLOAT.
- **Correzione:** ora usano prototipi propri con LONG e `#pragma libcall MathBase`, agli stessi offset e registri del NDK (SPFix $1E 001, SPFlt $24 001, SPMul $4E 0102, SPDiv $54 0102). Nel C per Amiga non resta nessun tipo float.

**Portato**
- **H033+$1A40 `spell_no_effect`:** azione vuota di 18 incantesimi della tabella $25C0.
- **H085+$15FE `spell_fireball`:** dadi da 6 pari al livello del lanciatore (per $40: 1d3*2+1) su chi e' entro 2 caselle dal punto scelto.
- **H085+$172A `effect_breath`** (effetti $06/$53 freddo, $68 fuoco): soffio del drago.
  - Cariche in +$4; scelta del bersaglio.
  - Solo se tutti i colpiti sono avversari: messaggio "breathes cold/Fire", animazione, danno pari ai punti ferita massimi del drago (tiro salvezza 3).
- **H085+$0BB2 (con le annidate $0BC0, $0C04, $0C62):** area del soffio.
  - La linea verso il bersaglio si prolunga fino alla lunghezza (8/7/9) e si ferma alla linea di vista.
  - Raccoglie i combattenti lungo la linea; con larghezza 3 anche lungo le due linee verso i lati della punta, con $FF quelli entro 3 caselle.
- **H085+$363E `spell_event_9`:** effetto sul bersaglio del turno ed evento 9, poi il gestore dell'effetto $40 se l'effetto non e' stato annullato.
- **H085+$38AA `spell_teleport`:** "teleports" sul punto scelto.
- **Esportati da H077:** `CokLine`, `line_init` ($01CC) e `line_step` ($0242).

**Dove mi discosto dall'asm (documentato nel codice)**
- **$0BB2, distanza -$114(a5):** non e' inizializzata nell'originale ma viene passata alla linea di vista; qui $FFFF, cioe' nessun limite, perche' la lunghezza e' gia' limitata dal prolungamento.
- **$0BB2, direzione -$112(a5):** non inizializzata se la linea non incontra nessuno; qui 0.
- **$0C62:** con l'elenco dei colpiti pieno l'originale scriverebbe oltre le 30 voci; qui si ferma.
- **$363E:** l'oggetto passato al gestore dell'effetto $40 e' -$4(a5), non inizializzato; qui NULL.

**Prove**
- **Battaglia della carovana** (ASan): nessun errore; le tabelle dei gestori sono a posto.
- **Non provato:** il soffio, la palla di fuoco e il teletrasporto, che non compaiono nella prima battaglia.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

---

## v50: incantesimi di H085 ($2338, $26C0, $31B4, $33A8, $3758, $3936)

**Portato**
- **$1A6C:** l'effetto dell'incantesimo corrente su ogni bersaglio, dall'ultimo al primo.
  - Dal secondo in poi con il suono 2 e il proiettile dal lanciatore.
  - Tiro salvezza con bonus, salvo per $4F/$51 sull'ultimo bersaglio; la razza 7 resiste sempre a $17 e $31.
- **$2338 `spell_hold_person`:** "is held", con un malus al tiro salvezza che dipende dal numero di bersagli.
- **$26C0 `spell_stinking_cloud`:** "Creates a noxious cloud".
  - Un record in g_clouds ($2514) e l'effetto $28 per toglierlo.
  - Le 4 caselle diventano $1E se il terreno lo consente, salvando il contenuto precedente.
  - I combattenti nelle caselle entrano nella nube (H062+$1038).
- **$3758 `spell_charm_monster`:** "is charmed", poi il gestore dell'effetto $B.
- **$3936 `spell_fear`:** paura a cono (area del soffio, larghezza 3, lunghezza 6).
  - Chi fallisce il tiro salvezza 4 "runs in terror" (effetto $6F), fugge e passa al computer (+$EC = $B3).
  - Gli altri "is unaffected".
- **$31B4 `spell_lightning_bolt`:** fulmine, livello del lanciatore dadi da 6 (tipo $C).
  - $1234 colpisce la casella e segnala i muri.
  - $1306 traccia il fulmine per 7 caselle oltre il punto e rimbalza sui muri invertendo la direzione.
- **$33A8 `spell_bolt_20`:** scarica, 1d6+20 sul punto e poi 20 lungo 3 caselle senza rimbalzo.

**Dove mi discosto dall'asm (documentato nel codice)**
- **$2338:** con piu' di 4 bersagli il malus resta non inizializzato; qui 0.
- **$33A8:** il flag del primo colpo non e' inizializzato e non serve dopo; qui 0.
- **$1306:** il combattente -$42(a5) non e' inizializzato se la linea parte gia' sulla casella finale; qui 0.

**Prove**
- **Battaglia della carovana** (ASan): nessun errore.
- **Non provato:** questi incantesimi, che non compaiono nella prima battaglia.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

---

## v51: gestori di effetto di H085 ($431A, $442E, $4628, $4798, $4A02)

**Portato** (tratto $431A..$4D1A, non classificato nel sorgente: disassemblato dai byte grezzi con objdump m68k)
- **$431A `effect_fireball` (effetto $4E):** "throws a fireball", palla di fuoco $2F da 15d6 sul bersaglio scelto; poi l'effetto si toglie.
- **$442E `effect_poison_breath` (effetto $54):** "breathes poison", nell'area di raggio 3 attorno al punto (tipo $20).
- **$4628 `effect_lightning_breath` (effetto $55):** "Breathes!", fulmine di 10 caselle senza rimbalzo (tipo $24).
- **$4798 `effect_acid_breath` (effetto $5A):** "breathes acid", cono stretto (larghezza 1, lunghezza 6; tipo $30), solo se colpisce soltanto avversari.
- **$4A02 `effect_eye_attack` (effetto $04):** agisce nel 75% dei turni.
  - Con le cariche e il 25%: soffio accecante su un avversario adiacente ("Breathes!", 10 o 20 di danno e "is blinded").
  - Altrimenti fino a due "Fires An Energy Bolt!" (1d8+2).
- **Comune ai soffi:** danno pari ai punti ferita massimi del mostro, tiro salvezza 3, cariche in +$4 (3 senza $247C).
- **Stato:** in H085 non restano stub.

**Dove mi discosto dall'asm**
- **$4628:** il flag del primo colpo -$1(a5) non e' inizializzato nell'originale; qui 0.

**Prove**
- **Battaglia della carovana** (ASan): nessun errore.
- **Non provato:** questi mostri, che non compaiono nella prima battaglia.
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

---

## v52: H010+$03AA (tasto 'c', memoria libera)

**Portato**
- **H010+$03AA `show_free_memory`:** il tasto di debug 'c' mostra "max free block is NNNNNNNN bytes." in alto a sinistra (riga 1, colore 15), con AvailMem(MEMF_LARGEST) (H003+$007E).
  - Il testo sta nel buffer di modulo -$52(a4).
  - Tolto lo stub h010_03aa.
- **Stub rimasti:** solo l'audio di H043 ($0584, $0840, $190E), che si salta senza fermare il programma.

**Prove**
- **Controlli:** compilazione senza warning, controllo C89, build MinGW x86 e x64, ctest 8/8.

---

## v53: audio SoundX (H043 e H094), compilato solo con COK_AUDIO

**Come si compila**
- **`smake`:** compila come prima, senza audio. I comandi audio sono gli stub di unported.c, che non fanno nulla.
- **`smake AUDIO`:** compila anche l'audio. I sei moduli coinvolti (h043_audio, h079, h090, h092, h094, unported) si compilano con `DEFINE=COK_AUDIO` in oggetti separati `*_a.o` (OBJNAME), cosi' le due build non si mescolano; poi collega `cok`.
- **Host:** `make AUDIO=1` compila con `-DCOK_AUDIO` in build-audio/.

**Portato** (tutto dentro `#ifdef COK_AUDIO`)
- **H043, caricamento e gestione** (lettore SMUS/8SVX "SoundX"):
  - $0584 avvio: SOUND/periodTable con $80 periodi e $40 durate; due porte; audio.device con la maschera dei canali $F; 16 richieste CMD_WRITE rese libere con ReplyMsg; server del VBlank che fa partire l'interrupt software;
  - $0840 chiusura;
  - $190E comandi: $FF ferma, 0/1 disabilita/abilita, $FE libera e ricarica, $FD precarica i suoni 1..$16, altrimenti suona il suono numero n;
  - $113E carica un oggetto per nome da SOUND/nome o da SOUND/soundData (FORM SMUS, 8SVX, INST, ENVL, con NAME facoltativo);
  - $0986/$0BB2/$0D84/$0D3A i parser IFF, $04B6 e seguenti la liberazione, $0F50/$1058 le liste attivi/caricati, $15C6 stop, $165A l'errore "SoundX is quiting".
- **H094, il lettore** (assembly scritto a mano nell'originale):
  - $0006 server del VBlank (Cause); $0016 interrupt software (orologio del tempo);
  - $0108/$0188/$01BE lettura delle tracce SMUS: note, pause, legature, accordi, cambio di strumento $81, volume $84, fine $FF;
  - $0288 avvio di una nota: ottava dal periodo, o samplesPerSec;
  - $0390 suoni singoli 8SVX/INST;
  - $003A assegnazione delle 4 voci (la piu' vicina alla fine con ADCMD_FINISH);
  - $04A4 inviluppi PTCH/VLUM e richieste CMD_WRITE (parte iniziale 1 ciclo, parte ripetuta senza fine) e ADCMD_PERVOL;
  - $0738 note libere.
- **Adattatori Exec:** H079 (AddIntServer, Disable, Enable, RemIntServer), H090 (OpenDevice, CloseDevice), H092 (NewList).
- **H020+$08C2 `console_write_int`:** intero allineato a destra, per il messaggio d'errore; compilato sempre.

**Host (solo con COK_AUDIO, per ora muto)**
- host/ndk.h ha i tipi Exec che servono (Node, List, porte con coda, IORequest, IOAudio, Interrupt).
- host/audio.c:
  - OpenDevice riesce; BeginIO completa subito la richiesta (torna alla porta delle risposte);
  - il server del VBlank gira a 50 Hz dal refresh del display, mai fra Disable ed Enable;
  - Cause esegue subito l'interrupt software.
- GetMsg/ReplyMsg gestiscono anche le porte diverse da IDCMP.

**Dove mi discosto dall'asm (documentato nel codice)**
- **Porta di risposta dell'apertura in $0584:** variabile locale non inizializzata nell'originale; qui azzerata.
- **Nome di INS1 lungo $28 byte:** nell'originale non e' terminato; qui il buffer parte azzerato.
- **VHDR piu' lungo di $14 byte:** qui si legge $14 e si salta il resto, invece di scrivere oltre il record.
- **Note senza strumento (H094 $0288):** qui restano mute; l'originale leggerebbe da indirizzi nulli.
- **samplesPerSec 0 in $0390:** l'originale dividerebbe per zero; qui il quoziente resta il dividendo.
- **Cambio di strumento $81 con indice pari al numero degli strumenti:** l'originale legge oltre la tabella; qui l'indice e' limitato a 0..7.

**Prove con i dati veri** (ASan, `make AUDIO=1`, audio muto)
- **Caricamento:** periodTable e i 55 oggetti di soundData (forme d'onda, inviluppi, strumenti IN1..IN7, campioni, il brano KRYNN); $FE libera e $FD ricarica.
- **Riproduzione:** durante intro e battaglia il lettore manda 358 richieste (83 CMD_WRITE, 192 ADCMD_PERVOL, 83 ADCMD_FINISH), con periodi e lunghezze coerenti fra le ottave.
- **Errore trovato e corretto:** gli identificatori IFF a 4 byte non erano terminati; nell'originale il byte seguente e' una variabile azzerata apposta.
- **ASan:** pulito.
- **Controlli:** le build host con e senza COK_AUDIO, il controllo C89 con e senza COK_AUDIO, MinGW x86 e x64 e ctest 8/8 sono puliti.
- **Non provato:** l'Amiga reale (`smake AUDIO`) e il suono vero sull'host (emulazione SDL di Paula: prossimo passo).

---

## v54: suono sull'host (audio.device emulato con SDL2, solo con COK_AUDIO)

**Stato del port**
- Gli stub di gioco sono finiti; in unported.c restano solo quelli dell'audio, usati senza COK_AUDIO.
- Le 25 routine senza marcatore PORT sono procedure annidate gia' incluse nei loro chiamanti (H066+$292C, H085+$3EE2), trampolini (H012, H013, H043, H061, H074) e corpi del runtime che il C ha gia' (H002, H015, H020, H045, H049 blitter, H074, H075).

**Portato** (host/audio.c, solo con `make AUDIO=1`; la build Amiga usa il vero audio.device)
- **audio.device** come i 4 canali di Paula:
  - una coda di CMD_WRITE per canale (dati a 8 bit con segno, lunghezza, periodo e volume con ADIOF_PERVOL, cicli: 0 = senza fine);
  - ADCMD_PERVOL cambia periodo e volume del suono in corso;
  - ADCMD_FINISH interrompe il suono in corso e fa partire il seguente in coda;
  - CMD_FLUSH svuota il canale.
- **Mixer** nel callback di SDL a 44100 Hz stereo: clock PAL 3546895 Hz, volume 0..64, canali 0+3 a sinistra e 1+2 a destra.
- **Richieste finite:** tornano alla loro porta solo nel thread principale (BeginIO e VBlank), sotto il lock dell'audio di SDL.
- **Senza audio SDL:** le richieste si completano subito, come in v53.
- **Differenza solo dell'host:** togliendo il server del VBlank (comando $FE, chiusura) i canali si svuotano, perche' H043 libera subito i campioni. Paula continuerebbe a leggerli senza danni; il callback dell'host no.

**Prove** (ASan, driver "disk" di SDL che scrive l'uscita audio su file)
- **Intro senza tasti:** la musica KRYNN suona per 44 secondi di fila (RMS medio circa 6000). Le frequenze dominanti sono note: 328 Hz (Mi4), 390 (Sol4), 490 (Si4), 519 (Do5), con le armoniche dispari delle onde quadre.
- **Intro saltata e battaglia:** musica all'avvio e poi i suoni della battaglia.
- **ASan:** pulito.
- **Controlli:**
  - build host senza audio e con `make AUDIO=1` senza warning;
  - controllo C89 con COK_AUDIO;
  - MinGW x86 e x64 (anche il controllo di sintassi con COK_AUDIO e gli header SDL);
  - ctest 8/8.

---

## v55: collaudo dei percorsi mai provati (nessuna modifica al codice)

**Vittoria in battaglia** (battaglia della carovana; gancio di prova temporaneo, non committato: ogni colpo abbatte un mostro, il personaggio non subisce danni; L in Auto)
- **Fine della battaglia:** "Continue Battle:" compare quando i nemici rimasti sono 0 ($2A1D, H059+$15EE); con No la battaglia finisce.
- **Esperienza:** "The party has won. Each character receives 652 experience points."
- **Tesoro:** schermata con l'immagine e "Steel 20". Take porta a "Select type of coin" e "How much steel will you take?"; poi Pool e Share; il menu diventa "View Pool Exit" quando non resta nulla; View e Items funzionano.
- **ASan:** pulito.

**Incantesimi in combattimento**
- **Percorso:** al campo Memorize (3 incantesimi), Rest, poi la battaglia: il menu diventa "Move View Aim Use Cast Done".
- **Lancio:** Cast, scelta di Resist Cold, mira (Target); "(Casting)", "L casts a spell", "Spell : Resist Cold", "L is cold-resistant".
- **ASan:** pulito.

**Da chiarire: l'oggetto "Plate Mail 3 Spells"**
- **I file:** L.swg, BOB.swg e TAS.swg (dati di prova copiati il 10/11, non dai dischi originali) hanno ciascuno un solo oggetto, una Plate Mail (nome $2F/$24, peso 450, pronta) con sopra campi di pergamena: tipo $27, +$32 = $66 ("3 Spells"), incantesimi 01 03.
- **KNT.swg** (salvato dal port il 10/11 alle 20:33) ha un solo oggetto, la Plate Mail di tipo $24 con incantesimi 02 23.
- **Confronto:** i personaggi pronti CHRDATA1..6 hanno oggetti coerenti, e la creazione (H013+$07B2) da' tre oggetti (Plate Mail, spada, scudo) a chi ha livelli in +$105.
- **Verifiche:** H013+$07B2, il salvataggio (H066+$1640) e il caricamento (H066+$1B0E) portati corrispondono all'asm. Nell'asm nessuna routine scrive tipo $27 o +$32 in un oggetto esistente: il tipo si scrive solo nella creazione degli oggetti iniziali, nella generazione casuale (H067+$1292, oggetto nuovo) e nella lettura del tesoro da file (H012).
- **Ipotesi:** quei personaggi sono stati prodotti in sessioni di prova precedenti da una versione del port con un errore poi corretto, oppure da un gancio di prova.
- **Da fare:** creare un personaggio nuovo con la build attuale (cavaliere, che riceve la Plate Mail), salvarlo e controllare il .swg; confronto con salvataggi creati dal gioco originale.

---

## v56: verifica del cavaliere e causa di "Plate Mail 3 Spells" (nessuna modifica al codice)

**Cavaliere creato con la build attuale** (ASan)
- **Creazione:** Create New Character, Human, maschio, Knight, allineamento, "Reroll stats?" No, nome KTST, editor dell'icona, "Save KTST?" Yes.
- **KTST.swg:** tre oggetti coerenti, byte per byte come CHRDATA1.swg: Plate Mail (tipo $24, nome 00 2F 24, peso 450), scudo ($25, peso 60), spada ($12, peso 50).
- **ASan:** pulito.

**Causa dell'oggetto "Plate Mail 3 Spells": dati di prova fabbricati in una sessione precedente, non un bug del port**
- **Origine:** il 10/11 alle 19:54 UTC, per collaudare l'uso delle pergamene, uno script di prova ha preso il record della Plate Mail di KNT e ci ha scritto sopra tipo $27, +$32 = $66, +$44 = 1, +$45 = 3 (+$3A = 1). Poi lo ha salvato come unico oggetto di TAS, BOB, L e KNT.
- **Verifica:** e' esattamente l'ibrido trovato; data e contenuto coincidono.
- **Dati di prova corretti** (fuori dal repository): in L, BOB e TAS l'oggetto ora e' una pergamena da chierico coerente (tipo $28, nome $66/$27/$26, peso 25, incantesimi 1 e 3, pronta). Nella scheda di L appare "Cler Scroll 3 Spells", con Use disponibile.

---

## v57: collaudo di Fix con un chierico nuovo (nessuna modifica al codice)

**Personaggio nuovo:** su consiglio dell'utente non si usa piu' L. CLR e' un chierico umano creato con la build attuale (AC 10, HP 13). Party: il solo CLR.

**Percorso** (ASan, gancio di prova che limita i danni a CLR perche' resti ad almeno 1 HP)
- Leave dalla citta', battaglia della carovana in Auto, "Continue Battle" No, tesoro Exit.
- "Do you want to go back and claim your treasure?" No; "Will you help us reach the outpost?" No.
- Encamp; View, Fix, di nuovo View.

**Risultato**
- **HP:** CLR scende a 1/13 in battaglia; dopo Fix la scheda mostra 11/13.
- **Calcolo:** nessuna cura memorizzata; 3 posti di livello 1 (+$124), quindi pool 3d8 = 10 e danno residuo 2.
- **Orologio di gioco:** passa da 12:11 a 16:41, cioe' 4:30 di riposo, come nell'asm (H057+$2C08).
  - Il tempo vale $F0 + 3*$F = 285 minuti; il danno 12 e' minore di extra $1B, quindi il tempo si divide per 27/12 = 2, con minimo $10E = 270 minuti.
- **Timer del riposo:** $24F4..$2501 viene salvato e ripristinato, come nell'asm.
- **ASan:** pulito.

**Sconfitta del party** (verificata per caso, senza il limite ai danni)
- CLR, da solo, viene abbattuto.
- Appare "The monsters rejoice for the party has been destroyed" e il gioco aspetta un tasto qualsiasi, senza menu. E' il comportamento atteso, non un blocco.

**Harness di prova** (fuori dal repository)
- **Passi condizionali:** `?testo:TASTO` aspetta un menu con quel testo; `*testo:TASTO` preme il tasto finche' i menu nuovi lo contengono.
- **Shot:** salva uno screenshot del menu corrente.
- Con questi passi le sequenze non perdono piu' la sincronia sulle pagine di testo di lunghezza variabile.

---

## v58: collaudo di Order e Drop con due personaggi nuovi (nessuna modifica al codice)

**Party:** CLR (chierico, AC 10, HP 13) e KTST (cavaliere, AC 10, HP 15), entrambi creati con la build attuale. Aggiunti con Add Character to Party; l'elenco mostra L, KTST, BOB, TAS, CLR, KNT con "*" accanto agli aggiunti.

**Percorso** (ASan): Begin, Leave, Encamp, Alter ("Order Drop Speed Icon Pics Level Exit"), Order, Drop.

**Order**
- Il corrente e' KTST, scritto in bianco: draw_party (H063+$0D80) usa la penna $0F per il corrente e il colore dello stato per gli altri.
- **Select:** "KTST has been selected", il menu diventa "Place Exit".
- **Freccia giu':** KTST era l'ultimo e passa in testa (KTST, CLR), come nell'asm (H057+$1FD6: dalla coda in testa).
- **Place:** si torna a "Select Exit"; Exit riporta al menu Alter.

**Drop**
- "KTST will be gone", "Drop from party? Yes No", Yes.
- KTST esce dal party e resta solo CLR; il riquadro del party e il menu del campo si ridisegnano correttamente.

**ASan:** pulito.

**Harness di prova:** il passo Shot non consuma piu' il menu corrente, cosi' un passo condizionale puo' seguirlo subito.

---

## v59: collaudo di Turn Undead (nessuna modifica al codice)

**Personaggi pronti dei dischi** (CHRDATA1..6)
- Hanno solo equipaggiamento normale (armature, scudi, armi, frecce); MOLLY ha l'oggetto di tipo $43.
- Nessuna pergamena e nessun oggetto magico: non servono al collaudo di pergamene e oggetti magici.

**Mostri non morti nei file del gioco** (MON1CHA.dax, campo +$DF letto con load_monster_record)
- SKELETON (26) tipo 1, ZOMBIE (31) tipo 2, GHOUL (7) tipo 3, GHAST (6) tipo 6.
- Gli altri 31 mostri di MON1 hanno +$DF = 0.

**Collaudo** (ASan, solo CLR, chierico di livello 1)
- Un gancio di prova sostituisce i mostri della battaglia della carovana con SKELETON, mostro reale dei file del gioco. I danni a CLR sono limitati perche' resti ad almeno 1 HP; i mostri muoiono al primo colpo solo dopo il Turn.
- **Menu:** compare "Move View Aim Turn Done". Turn appare perche' load_monster (H064) conta i non morti in $248F e il turno di CLR ha +$13 < $248F. Nella carovana normale il menu e' "Move View Aim Done", corretto perche' non ci sono non morti.
- **Esito:** "CLR turns undead...", poi per ogni scheletro "SKELETON is turned" e gli scheletri fuggono. Dopo l'uso Turn sparisce dal menu (+$13 incrementato).
- **Tre prove:** il tiro 1d20 e' unico per l'azione e il valore di tabella per tipo 1 e livello 1 e' 10.
  - tiro 18: due scheletri scacciati;
  - tiro 13: due scacciati;
  - tiro 7: "Nothing Happens...".
- **ASan:** pulito in tutte le prove.

**Restano:** uso delle pergamene e oggetti magici in combattimento. Servono oggetti veri del gioco (tesori o negozi), non dati costruiti a mano.

---

## v60: collaudo di pergamene, pozioni e oggetti magici; correzione di Take Items (H070+$0E94)

**Correzione: h070 take_items** (H070+$0E94)
- Nell'asm indice (-$10), scelta (-$4) e cursore (-$E) si inizializzano una sola volta, prima del ciclo ($0E9E..$0EAA; il ciclo riparte da $0EAE).
- Il C li azzerava a ogni giro, quindi dopo un Take la selezione tornava alla prima riga invece di restare dov'era. Ora l'inizializzazione e' fuori dal ciclo.

**Oggetti dei tesori del gioco** (ITEM1.DAX, dump letto come ecl_treasure, H012 comando TREASURE)
- **Blocchi con oggetti magici:** 17, 32..39, 48..51, 53.
- **Blocco 17:** Scroll Cler 3 Spells (tipo $28, incantesimi $43 $3A $45), due White MU Scroll e due Red MU Scroll 3 Spells, Potion of Healing, Wand of Magic Missiles (5 cariche, incantesimo $41), frecce e dardi.

**Collaudo** (ASan, solo CLR; ganci di prova fuori dal repository, oggetti tutti dai file del gioco)
- **Tesoro e Take**
  - Un gancio mette il blocco 17 nel tesoro della carovana. Il tesoro elenca gli oggetti; Take Items prende la pozione e la pergamena, e la selezione resta sulla riga dopo il Take.
  - Nota: 'I' su "Money Items Exit" lascia selezionata la 2a opzione ($2483) e in "Take Exit" la 2a e' Exit. Invio quindi esce, anche nell'asm; si prende con T.
- **Al campo**
  - **Use senza Ready:** "Must be Readied" (H065+$28D2).
  - **Pozione:** Ready, poi Use; HP da 1/13 a 8/13, la pozione sparisce (ingombro da 90 a 80).
  - **Pergamena:** Ready, poi Use; "Spells on Scroll", 4th Level: Neutralize Poison, Cure Serious Wounds, Protection Evil 10' Radius.
  - **Cure Serious Wounds** su CLR ("Cast Spell on whom"): HP 13/13, l'oggetto diventa "Scroll Cler 2 Spells" e l'incantesimo sparisce dalla pergamena.
  - **Immagine del campo:** dopo View il fuoco riappare dopo un attimo. E' l'animazione di ui_request_choice ($069E), che ridisegna dopo l'attesa del fotogramma; anche all'ingresso del campo il riquadro e' vuoto per un attimo.
- **In combattimento** (bacchetta e pergamena date a CLR all'inizio della battaglia con take_item, H071+$047C)
  - Il menu diventa "Move View Aim Use Done"; Use mostra "Ready Use Drop Halve Join Exit".
  - **Bacchetta:** Ready, poi Use; "Item Wand of Magic Missiles", Aim (Next Prev Manual Target Center Exit), Next su un Baaz, Target.
  - **Cariche:** da 5 a 4. In Auto l'IA usa la bacchetta da sola: da 4 a 3 a 2.
  - **Mira:** senza nemici in vista Next resta su CLR e Target lo colpisce ("CLR takes 6 points of damage from magic"). Errore della sequenza di prova, non del port.
  - **Pergamena:** Cure Serious Wounds su CLR, HP da 1 a 5; sulla pergamena restano gli incantesimi 43 00 45.
- **ASan:** pulito in tutte le prove.

---

## v61: commenti a ogni accesso dei dati anonimi, README in inglese, marcatori PORT completi, correzione H029

**Commenti ai dati anonimi**
- **Cosa e' commentato:** ogni lettura e scrittura degli array anonimi ha un commento che spiega l'elemento. Comprende g_h005 (H005_B/W/L, H005_SET_*), g_state_a/b/c, g_ecl_buffer, i campi b[] dei record e gli array dei moduli.
  - Campi dei record: Character pg+, CokItem ogg+, CokTurn turno+, CokEffect eff+, CokCloud nube+.
  - Array dei moduli: g_hNNN_bss/data.
  - Esempio: `/* $3DF6: (word) velocita' del gioco 0..9 (pausa dei messaggi) */`.
- **Glossario:** 586 voci ricavate solo dal codice e dall'asm. Dove il significato non e' certo la descrizione inizia con "uso:".
- **Come sono applicati**
  - Accessi trovati con l'AST di clang (libclang), quindi col tipo del record anche dentro le macro: 7080 accessi, 4513 righe commentate.
  - In fondo alla riga se c'e' spazio, altrimenti sulla riga sopra.
  - Commentate anche le #define con offset fissi (CHOICE_SELECTED, SPELL_B, POS_X, ...) e a mano gli accessi a base variabile (tabelle per classe, terreno, eta').
- **Verifiche**
  - I file oggetto compilati prima e dopo sono identici byte per byte, tranne h029_gfx.c (correzione sotto).
  - Build host, AUDIO, C89, CMake x86_64/i686, MinGW: puliti. ctest 8/8.

**Correzione: H029+$1210 scriveva in H005 invece che in H024**
- `move.w #$10F, (H024+$4).l` scrive in H024+$4, cioe' -$14(a4) di H024 (A4 = H024+$18), il Type della NewScreen di Open_GameScreen.
- Il C scriveva `H005_SET_W(0x0004, 0x010F)`, cioe' sopra la parola alta del valore della moneta 2 (long a H005+$4, valore 5).
- Effetti dell'errore:
  - lo schermo si apriva senza SCREENQUIET ($100);
  - il valore della moneta 2 diventava $010F0005.
- Ora scrive `g_h024_m14 = 0x010F`, cioe' Type = CUSTOMSCREEN | SCREENQUIET, ed e' esportata da h024_screen.h.

**Marcatori PORT: 1132 / 1132**
- PORT_STATUS.md contava 1107 routine. Le 25 senza marcatore hanno ora un `PORT Hnnn+$XXXX` che spiega dove sono:
  - **8 trampolini** (bra.w): H012+$0186, H013+$0518/$051C/$0520, H043+$01CA/$01D2/$07F6, H061+$162A. Il marcatore sta sulla routine di arrivo.
  - **Procedure annidate o inline**:
    - H010+$0882 (corpo di Poll_IntuitionEvents);
    - H045+$0014;
    - H066+$292C, identica a H066+$30A8 game_file_path;
    - H085+$3EE2, dispel_roll.
  - **Callback del blitter H049+$06EC/$0782:** dentro queue_bitplane_blit.
  - **Runtime del compilatore sostituito da stdio:** H002+$00C0 IoErr, H015+$0196/$033E, H020+$00C2/$00F0, H074+$0010/$009A/$0450, H075+$00FE/$0124/$0132.
- H056+$0268 (nomi degli opcode ECL per il debug) non e' tra le routine dell'analisi; nell'asm nessuno la chiama.

**Stranezze dell'originale trovate scrivendo il glossario** (port fedele, nessuna modifica)
- L'effetto $36 (H027+$1C7A) testa $24A3 (partita salvata) dove il gemello $32 testa $24A5 (esito del tiro salvezza). Annotato nel commento.
- In write_state_b_hook (H061) il caso 0, che pone $24C3, sembra irraggiungibile.

**README.md** riscritto in inglese e aggiornato: stato completo, audio con COK_AUDIO, convenzione dei commenti, build SAS/C (smake / smake AUDIO).

---

## v62: collaudo di Save e Load (nessuna modifica al codice)

**Save** (ASan, CLR dopo la carovana, con pozione e pergamena dal tesoro)
- **Al campo:** Save, poi "Save Which Game: A B C D E F G H I J", A, poi "exit to workbench" No.
- **Stato al salvataggio:** CLR 1/13 HP, esperienza 2717, 70 steel, ingombro 90; pozione e pergamena non pronte; 07,13 N, ore 12:11.
- **File scritti:**
  - savgamA.dat (5481 byte);
  - CHRDATA1.sav (426) e CHRDATA1.swg (144 = 2 oggetti da $48);
  - CLR.who cancellato (H066+$3000).
- **Nomi dei file:** i personaggi pronti dei dischi si chiamano CHRDATA1..6, proprio come la partita A. Il party pronto e' dunque la partita A, e salvare in A lo sostituisce.

**Load** (secondo avvio dai file salvati)
- **Menu col party vuoto:** "Create New Character, Add Character to Party, Load Saved Game, Exit to Workbench".
- **Caricamento:** "Load Which Game: A" offre solo le partite esistenti. Dopo A il party contiene CLR (AC 10, HP 1).
- **Begin Adventuring:** mappa all'aperto col party; al campo 07,13 N, ore 12:11. CLR come al salvataggio (1/13, 2717, 70 steel, ingombro 90, stessi oggetti non pronti).
- **Eventi:** il passo che nella partita nuova apriva la battaglia della carovana ora esegue solo gli script del passo (3655, 37BE) e torna al menu di movimento. Lo stato degli eventi e' stato ripristinato.

**Andata e ritorno:** carica A, poi subito Save in B.
- CHRDATB1.sav e .swg sono identici byte per byte a CHRDATA1.
- savgamB.dat differisce da savgamA.dat in 3 byte, tutti attesi:
  - A+$279: contatore dei salvataggi da Encamp, da 1 a 2;
  - $3DE2: contesto precedente, da 4 a 2, per il percorso della sessione dopo il caricamento;
  - nome del file del personaggio: "CHRDATA1" / "CHRDATB1".
- **Disposizione di savgam<x>.dat**, letta da H066+$3000:
  - $246E (1 byte), stato A ($800), stato B ($800), stato C ($400);
  - $281C (8 byte), $3DE2, $3DE3, i 3 posti di $2810 (2+2 byte ciascuno);
  - il numero dei personaggi (word) e i nomi (8 x $2A).

**ASan:** pulito in tutte le prove.

---

## v63: Save e Load con due personaggi e dal menu principale (nessuna modifica al codice)

**Save Current Game dal menu principale** (ASan; party CLR + KTST, partita non ancora cominciata)
- **Comandi:** "Save Which Game" e poi C.
- **File scritti:** savgamC.dat, CHRDATC1.sav (CLR, senza oggetti, quindi senza .swg), CHRDATC2.sav e CHRDATC2.swg (KTST, 3 oggetti, 216 byte). CLR.who e KTST.who sono cancellati.
- **Oggetti di KTST:** .swg identico a KTST.swg.
- **Record dei personaggi:** rispetto ai .who cambiano solo campi che si ricalcolano quando il personaggio entra nel party:
  - +$DB livello massimo, da 0 a 1;
  - +$143 posto dell'icona, da $0A creazione a 0/1 nel party;
  - +$18C ingombro di KTST, da 10 a 570 (450 + 60 + 50 + 10 di monete).

**Load**
- "Load Which Game: A C" elenca le partite esistenti.
- **Partita C:** il party torna come CLR (10/13) e KTST (10/15), nello stesso ordine.
- **Begin Adventuring:** riparte l'introduzione, ed e' giusto perche' la partita era stata salvata prima di cominciare.

**Andata e ritorno: carica C, poi Save in D**
- CHRDATD1.sav, CHRDATD2.sav e .swg sono identici byte per byte a quelli di C.
- savgamD.dat differisce da savgamC.dat solo nei due nomi dei file ("CHRDATC1/2" e "CHRDATD1/2", offset $141F e $1449).

**ASan:** pulito.

---

## v64: collaudo della scorta della carovana, dell'avamposto, del Commandant e della Hall (nessuna modifica al codice)

**Percorso** (ASan, party CLR + KTST; gancio di prova: i mostri muoiono al primo colpo, il party resta ad almeno 1 HP)
- Leave, la battaglia della carovana con i due personaggi in Auto, "Continue Battle" No, tesoro Exit, "go back and claim your treasure?" No.
- **Testi dopo la battaglia**
  - "All of the draconians are slain save one, who rips a book from a dead man's hands. He turns to...", col ritratto del draconiano;
  - poi, sulla mappa: "One of the surviving women comes up. 'Brave warriors, will you help us reach the outpost?'". Risposta: **Yes**.
- **Dopo il Yes:** "Congratulations the party gains experience!". Si carica la nuova area (ECL area 11, RUN 3514) e appare l'avamposto: immagine della citta', "Where do you wish to go", menu "Inn Hall Commandant Armoury Next Leave".

**Commandant**
- Col ritratto di Sir Karl, testo che scorre lettera per lettera:
  - "You enter the office to the sounds of battle. Sir Karl drives his sword through the Commandant who collapses. The body then writhes and becomes a stone. Sir Karl murmurs, 'I was afraid...'";
  - "As you report, his face grows gray. 'This is much worse than...'";
  - "'We have a patrol in Throtl. Caramon leads it. Find him. Tell him he is desperately needed here. The imposter has emptied this outpost of troops. I know you are inexperienced...'".
- Poi si torna al menu dell'avamposto.

**Hall** (addestramento)
- Mostra il menu dei personaggi con in piu' "Train Character" e "Knight Change Classes".
- **Train su CLR:** "Pick Character", poi "Not Enough Experience". CLR ha 3358 punti di esperienza ed e' di livello 1.
  - Per il chierico la riga della tabella e' 0 o 1 secondo la divinita' (+$5E <= 4: riga 0; H063+$3F72), e la soglia del livello 2 della riga 0 e' 4000 (H005+$1946).
  - L'asm di Train (H013+$5A26..$5A4C) usa riga * $9A e indice (livello+1)-2 come il C.
  - La tabella e' verificata byte per byte con l'emulazione dell'asm. Il messaggio e' quindi quello dell'originale.
- **Modify su KTST:** "KTST can't be modified.", corretto per un personaggio gia' in gioco (+$DC).
- **View di CLR:** 1/13 HP, esperienza 3358, 70 steel.

**ASan:** pulito in tutte le prove.

**Harness di prova** (fuori dal repository)
- La build ASan di prova ora si fa su una copia del sorgente (srccopy). I ganci si applicano li', e gli annotamenti vengono tolti solo dalla copia.
- Il passo `*testo:TASTO|testo2:TASTO2` accetta piu' alternative, e la riga dei passi va fino a 159 caratteri.
- I messaggi di show_message finiscono nel log ("MSG ...").

---

## v65: segno del party sulla mappa all'aperto (contorno di RectFill sull'host); collaudo dell'avamposto e del viaggio

**Correzione host: RectFill con AREAOUTLINE** (segnalata dall'utente: sull'Amiga il segno del party sulla mappa e' diverso)
- **Il segno:** H069+$0012 disegna la cella del party con SetAPen($E), poi H038+$01B4 (SetOPen: AOlPen = 0, Flags |= AREAOUTLINE), poi RectFill.
- **Sull'Amiga:** con AREAOUTLINE RectFill ridisegna il bordo del rettangolo con AOlPen, e il segno e' un quadrato giallo con il bordo nero.
- **Sull'host:** RectFill ignorava il flag (il commento supponeva AOlPen sempre uguale a FgPen, vero solo per H030) e disegnava un quadrato tutto giallo.
- **Correzione:** host/graphics.c RectFill ridisegna ora il bordo con AOlPen quando AREAOUTLINE e' attivo, rispettando il taglio ai bordi della bitmap.
  - Per H030 (fill_text_cells e clear_text_cells, OPen = APen) il risultato non cambia.
  - Il codice del gioco e la build Amiga non cambiano.
- **Da confermare sull'Amiga:** il segno deve essere una cella 8x8 gialla con il bordo nero di un pixel.

**Avamposto** (ASan, party CLR + KTST dopo la scorta)
- **Inn:** "Welcome, we have plenty of space for you." e il campo.
  - Rest: "Rest Time" con Days/Hours/Mins/Add/Subtract; 2 giorni.
  - CLR e KTST passano da 1 a 3 HP (+1 al giorno); l'ora resta 12:08 (48 ore).
- **Armoury:** "Buy View Pool Appraise Exit".
  - Esc non esce: nell'asm la tabella dei tasti (H071+$0B9A, subi.w #$41 / cmpi.w #$15) copre solo 'A'..'V', e il tasto 0 va nel caso di default. Si esce con E, come nell'originale.
- **Next:** "Vault Temple Bar Prev Leave".
- **Bar:** "Have a drink Relax Leave"; "What will you drink?" Beer Ale Wine Mead Whiskey; "You hear tavern tale 19." (rimando all'Adventurer's Journal).
- **Vault:** "Deposit Withdraw View balance Exit"; "You have 000 steel pieces".
- **Leave:** mappa all'aperto, "You are near an outpost. Do you enter?". Con No si passa al movimento.

**Viaggio:** con le frecce il segno del party si sposta sulla mappa verso nord, accanto a Throtl, fino al bordo della mappa. Ogni passo esegue gli script ECL del passo (3655, 37BE).

**ASan:** pulito.

---
