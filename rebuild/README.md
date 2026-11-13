# Champions of Krynn — reassemblable source v0.6

This project rebuilds the `game` executable contained in the analysed `cok.lha` sample. The verified final result is byte-for-byte identical to the original: 479,844 bytes, SHA-256 `b02db23e0df6decfb2807fa322d302371c22d5079130a2a335060eebcab978a3`.

## Contents and limits

- `game.asm`: includes the 101 hunks in the original order.
- `source/H000.asm` … `H100.asm`: 88,215 instructions expressed with Motorola mnemonics and all the other areas preserved with data directives.
- `api_lvo.inc`: symbolic names for the offsets of the API calls already identified.
- `api_const.inc`: API constants (IDCMP, WFLG, IECODE, MEMF, MODE, OFFSET, ...)
  generated from the `.i` files of the NDK 3.2.
- `ndk32/`: subset of the NDK 3.2 used for the modern names of the constants
  (`dev/misc/NDK3.2`, SHA-256 of the archive
  `96cabd4ad683dced632e147bf86dee0f50dcb1254386216c25c362916a6409bb`).
- `ndk13/`: subset of the NDK 1.3 (headers and `LVO.OFFS`) with which the game
  was actually compiled.
- `tools/gen_api_const.py`, `tools/check_api_lvo.py`,
  `tools/check_api_ndk13.py`, `tools/check_api_const.py`: generation and
  checking of the constants/LVOs.

All the LVOs of `api_lvo.inc` match the `LVO.OFFS` of the NDK 1.3.  The
wrapper `H016+$00A0` is `BltMaskBitMapRastPort` (LVO -636, with mask);
`BltBitMapRastPort` is -606 instead.  This distinction matters because
both functions have the same name in the generic documentation but
different arguments.
- `labels.json`: mapping between descriptive symbols and hunk+offset addresses.
- `layout.json`: sizes and order of the original relocation records; it contains no original payload.
- `tools/build.py`, `tools/hunk.py`: assembly, structure check and restoring of the order of the RELOC32 records.
- `build/verification.json`: result of the verified build.

The 74,780 bytes not recognised by the static walk are kept with relocated `dc.w`, `dc.b` and `dc.l` directives. They include data and may include more code still to be identified. Having the reassemblable source does not mean that the interpretation of the gameplay or the final separation between code and data is complete.

The project does not use `incbin`, does not read the old executable during the build and does not need the JSON files of the external analysis. All the payload bytes are emitted from the assembly sources.

## Building

Requires Python 3.10+ and `vasmm68k_mot` (m68k backend, Motorola syntax). The check was done with vasm 1.9a, m68k backend 2.5f, syntax mot 3.16. This is not a statement about the most recent version available.

From the folder of this README:

```sh
python3 tools/build.py --vasm /path/to/vasmm68k_mot
```

If the assembler is in the PATH:

```sh
python3 tools/build.py
```

The symbolic constants are regenerated and checked with:

```sh
make api
```

The command runs `gen_api_const.py` on the `.i` files of the NDK 3.2, compares
the LVOs of `api_lvo.inc` with the FDs of the NDK and checks that every symbolic
immediate used in the sources has the same value as the original byte
reported in the comment.

Capstone, Unicorn, a linker, AmigaOS or the original archive are not needed for this build. The project was also rebuilt in a separate folder containing only the files distributed here.

The assembler is invoked with:

```sh
vasmm68k_mot -m68000 -no-opt -spaces -Fhunkexe -kick1hunks -nosym -quiet -o build/game.vasm game.asm
```

`-no-opt` and the explicit sizes keep the original encodings; `-spaces` enables spaces between the operands. `-kick1hunks` keeps the relocations in the 32-bit format expected by the sample.

## Two outputs

`build/game.vasm` is the executable produced directly by the assembler. Hunks, payload, allocation sizes, addends and relocation positions match the original. The order of some RELOC32 records/offsets is different, without changing the information meant for the loader.

`build/game` is the serialisation with the original order of the RELOC32 records. The final step copies the freshly assembled payloads without changing them; it first checks sizes, types, attributes and relocation positions. This second file must have the original hash given above.

Restoring the order does not fix different machine code or data. By default the build fails if the final result does not have the original hash.

A full start of the rebuilt game on an Amiga or in an AmigaOS emulator was not done. Byte-for-byte identity is the check carried out here.

## Intentional changes

`--allow-modified` can be used to accept deliberate changes of the payload. This path still keeps the sizes of the single hunks and the positions/targets of the relocations; it is not a general linker for added code or moved sections. For size changes the project and the layout check have to be adapted.

The `Hnnn` labels are the bases of the respective hunks. `Lnnn_offset` identifies the instruction entry points; the `FN_...` labels add descriptive names to the routines already interpreted. The notes include original bytes, addresses and recognised API calls.

## References

- [Main reference requested: kb.marrani.lol](https://kb.marrani.lol/)
- [Hunk format](https://kb.marrani.lol/dos/hunk-binary-format/)
- [vasm documentation](https://sun.hasenbraten.de/vasm/release/vasm.pdf)
- [Mirror of the vasm source used to build the tool](https://github.com/alfishe/vasm)

The wiki in the analysis package documents evidence, hypotheses, OS calls, blitter accesses and data formats.


## Semantic annotations v0.6

The guide is in `docs/Guida_al_sorgente.md` in the general package, with the catalogue `docs/Catalogo_routine.md`. The sources include 124 routine cards, notes on the important blocks, on the global references and on the call flow. The evidence levels distinguish verified results and partial attributions. The full semantics of the gameplay and of the DAA formats remains open.
