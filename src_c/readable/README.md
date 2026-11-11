# Port in C dall'assembly

Questa cartella è un port **da zero**, scritto a mano routine per routine
dall'assembly annotato di `rebuild/source`. Non deriva dal vecchio livello
leggibile né dalla decompilazione Ghidra (`src_c/H*.c`).

## Regole

- **Un file per hunk:** `hNNN_<ruolo>.c` con il suo header `hNNN_<ruolo>.h`.
- **Marcatore:** ogni funzione portata ha sopra il commento
  `PORT Hnnn+$XXXX` con l'indirizzo della routine originale.
- **Fedeltà:** il comportamento segue l'assembly. Dove il C deve scostarsi
  (build host, puntatori a 64 bit, accessi fuori dai limiti, runtime del
  compilatore) il commento lo dice esplicitamente.
- **Dati globali:** `globals.h` raccoglie i dati di `H005` e degli altri
  moduli con nomi descrittivi. Ogni variabile riporta il suo offset
  originale; se l'uso non è ancora chiaro, il nome resta l'offset.
- **Convenzione di chiamata:** gli argomenti seguono l'ordine dell'originale
  (il primo argomento è quello all'offset più alto dello stack).
- **Routine mancanti:** quelle non ancora portate stanno in `unported.c`.
  Fermano il programma stampando il loro indirizzo, quindi il port gira
  esattamente fin dove è portato.

## Avanzamento

`PORT_STATUS.md` elenca tutte le routine dell'asm e quali sono portate. Si
rigenera con:

```sh
python3 scripts/port_status.py --check
```

(da eseguire dalla radice del repository, oppure con `make status` da qui).

Ordine di lavoro: l'avvio di `H000+$0000` inizializza 99 moduli in un ordine
fisso, poi entra nel main `H001+$0058`. Il port segue quest'ordine, così il
programma avanza un modulo alla volta.

## Build

Host con CMake e SDL2 (Linux, macOS, Windows):

```sh
cmake -S . -B build-cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build-cmake
./build-cmake/cok
```

SDL2 si installa con `libsdl2-dev` (Debian/Ubuntu), `brew install sdl2`
(macOS) o vcpkg; CMake la cerca come pacchetto CMake e poi con pkg-config.
In alternativa resta il `Makefile` (`make`, `./build/cok`).

Visual Studio 2022, x86 (Win32) e x64 (AMD64):

```bat
windows\get-sdl2-nuget.cmd
cmake --preset vs2022-x64
cmake --build --preset vs2022-x64-release
```

(per x86: `vs2022-x86` e `vs2022-x86-release`). `get-sdl2-nuget.cmd`
scarica da nuget.org i pacchetti `sdl2.nuget` e `sdl2.nuget.redist`
(pacchetti della comunità che ridistribuiscono le librerie ufficiali di
libsdl.org) in `third_party/sdl2-nuget`, con librerie e DLL per Win32 e
x64; CMake li usa da solo e copia `SDL2.dll` accanto a `cok.exe`.
In Visual Studio si può anche aprire la cartella (File > Apri > Cartella):
i preset compaiono nell'elenco delle configurazioni. La soluzione `.sln`
generata è in `build-vs2022-x64` / `build-vs2022-x86`.

Sull'host le librerie di AmigaOS usate dal gioco sono emulate in `host/`
(`host/ndk.h` riproduce strutture e funzioni dell'NDK con gli stessi nomi,
così gli adattatori del gioco sono identici sui due target); lo schermo
è mostrato con SDL2. Variabili utili: `COK_SCALE=n` (ingrandimento),
`COK_SCREENSHOT=file.bmp` (salva l'ultimo fotogramma all'uscita),
`COK_SCREENSHOT_AT=t1,t2,...` (con `COK_SCREENSHOT=base`: salva anche
`base-1.bmp`, `base-2.bmp`, ... ai millisecondi indicati),
`COK_KEYS=ms=Tasto,...` (tasti simulati a tempo, nomi SDL come `P`,
`Return`, `Escape`, `Left`), `SDL_VIDEODRIVER=dummy` (senza finestra),
`COK_DATA=dir` (directory dei
file del gioco, altrimenti quella corrente). Come su AmigaDOS i nomi dei file
non distinguono maiuscole e minuscole e il volume ("df0:", "Disk Two:") è
ignorato. Le richieste di sistema (es. "inserisci il disco") si chiudono con
Invio/R (Retry) o Esc/C (Cancel); senza finestra il programma termina.
Tastiera e mouse arrivano al gioco come eventi IDCMP (RAWKEY con i codici
della tastiera Amiga, MOUSEBUTTONS); il pulsante destro vale come quello
del menu (la finestra ha RMBTRAP).

L'audio (H043) non è ancora portato: le sue routine chiamate finora sono
saltate con un avviso ("routine non ancora portata (saltata)") invece di
fermare il programma.

AmigaOS con SAS/C 6.x: `smake` (ogni nuovo file va aggiunto a `OBJS` nello
`smakefile`).

## Test

`tests/` contiene i test delle singole routine, per esempio:

```sh
cc -std=c99 tests/h015_test.c h015_runtime.c -o h015_test && ./h015_test
```

Le inizializzazioni dei dati sono confrontate byte per byte con
l'emulazione dell'assembly (`scripts/emu68k_init.py`), vedi l'intestazione di
`tests/bss_test.c` e `tests/h004_test.c`. Le tabelle di costanti sono
generate (`scripts/gen_init_data.py`, `scripts/gen_h004_init_data.py`) e
applicate da `init_data.c`; i cicli sono scritti a mano.
