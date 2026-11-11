# Champions of Krynn — sorgente riassemblabile v0.6

Questo progetto ricostruisce l'eseguibile `game` contenuto nel campione `cok.lha` analizzato. Il risultato finale verificato è identico byte per byte all'originale: 479.844 byte, SHA-256 `b02db23e0df6decfb2807fa322d302371c22d5079130a2a335060eebcab978a3`.

## Contenuto e limiti

- `game.asm`: include i 101 hunk nell'ordine originale.
- `source/H000.asm` … `H100.asm`: 88.215 istruzioni espresse con mnemonici Motorola e tutte le altre aree preservate con direttive dati.
- `api_lvo.inc`: nomi simbolici per gli offset delle chiamate API già identificate.
- `api_const.inc`: costanti API (IDCMP, WFLG, IECODE, MEMF, MODE, OFFSET, ...)
  generate dai file `.i` dell'NDK 3.2.
- `ndk32/`: sottoinsieme dell'NDK 3.2 usato per i nomi moderni delle costanti
  (`dev/misc/NDK3.2`, SHA-256 dell'archivio
  `96cabd4ad683dced632e147bf86dee0f50dcb1254386216c25c362916a6409bb`).
- `ndk13/`: sottoinsieme dell'NDK 1.3 (headers e `LVO.OFFS`) con cui il gioco
  è stato realmente compilato.
- `tools/gen_api_const.py`, `tools/check_api_lvo.py`,
  `tools/check_api_ndk13.py`, `tools/check_api_const.py`: generazione e
  verifica delle costanti/LVO.

Tutti gli LVO di `api_lvo.inc` coincidono con l'`LVO.OFFS` dell'NDK 1.3.  Il
wrapper `H016+$00A0` è `BltMaskBitMapRastPort` (LVO -636, con maschera);
`BltBitMapRastPort` è invece -606.  Questa distinzione è importante perché
entrambe le funzioni hanno lo stesso nome nella documentazione generica ma
argomenti diversi.
- `labels.json`: corrispondenza fra simboli descrittivi e indirizzi hunk+offset.
- `layout.json`: dimensioni e ordine dei record di rilocazione originali; non contiene payload originali.
- `tools/build.py`, `tools/hunk.py`: assemblaggio, controllo della struttura e ripristino dell'ordine dei record RELOC32.
- `build/verification.json`: risultato della compilazione verificata.

I 74.780 byte non riconosciuti dalla visita statica sono conservati con direttive `dc.w`, `dc.b` e `dc.l` rilocate. Comprendono dati e possono comprendere altro codice ancora da identificare. La presenza del sorgente riassemblabile non significa che sia completata l'interpretazione del gameplay o la separazione definitiva tra codice e dati.

Il progetto non usa `incbin`, non legge il vecchio eseguibile durante il build e non richiede i JSON dell'analisi esterna. Tutti i byte del payload vengono emessi dai sorgenti assembly.

## Compilazione

Richiede Python 3.10+ e `vasmm68k_mot` (backend m68k, sintassi Motorola). La verifica è stata effettuata con vasm 1.9a, backend m68k 2.5f, syntax mot 3.16. Non è una dichiarazione sulla versione più recente disponibile.

Dalla cartella di questo README:

```sh
python3 tools/build.py --vasm /percorso/vasmm68k_mot
```

Se l'assemblatore è nel PATH:

```sh
python3 tools/build.py
```

Le costanti simboliche si rigenerano e si verificano con:

```sh
make api
```

Il comando esegue `gen_api_const.py` sui file `.i` dell'NDK 3.2, confronta
gli LVO di `api_lvo.inc` con gli FD dell'NDK e controlla che ogni immediato
simbolico usato nei sorgenti abbia lo stesso valore del byte originale
riportato nel commento.

Non sono necessari Capstone, Unicorn, un linker, AmigaOS o l'archivio originale per questo build. Il progetto è stato ricompilato anche in una cartella separata contenente soltanto i file qui distribuiti.

L'assemblatore viene invocato con:

```sh
vasmm68k_mot -m68000 -no-opt -spaces -Fhunkexe -kick1hunks -nosym -quiet -o build/game.vasm game.asm
```

`-no-opt` e le dimensioni esplicite conservano le codifiche originarie; `-spaces` abilita gli spazi fra gli operandi. `-kick1hunks` mantiene le rilocazioni nel formato a 32 bit previsto dal campione.

## Due output

`build/game.vasm` è l'eseguibile prodotto direttamente dall'assemblatore. Hunk, payload, dimensioni di allocazione, addendi e posizioni delle rilocazioni coincidono con l'originale. L'ordine di alcuni record/offset RELOC32 è diverso, senza alterare le informazioni destinate al loader.

`build/game` è la serializzazione con l'ordine originale dei record RELOC32. Il passaggio finale copia i payload appena assemblati senza modificarli; controlla prima dimensioni, tipi, attributi e posizioni delle rilocazioni. Questo secondo file deve avere l'hash originale indicato sopra.

Il ripristino dell'ordine non corregge codici macchina o dati differenti. Per impostazione predefinita il build fallisce se il risultato finale non ha l'hash originale.

Non è stato eseguito un avvio completo del gioco ricostruito su Amiga o in un emulatore di AmigaOS. L'identità byte per byte è la verifica svolta qui.

## Modifiche intenzionali

È possibile usare `--allow-modified` per accettare variazioni deliberate del payload. Questo percorso conserva comunque dimensioni dei singoli hunk e posizioni/destinazioni delle rilocazioni; non è un linker generale per aggiunte di codice o spostamenti delle sezioni. Per modifiche di dimensione occorre adeguare il progetto e il controllo del layout.

Le etichette `Hnnn` sono le basi dei relativi hunk. `Lnnn_offset` identifica gli ingressi delle istruzioni; le etichette `FN_...` aggiungono nomi descrittivi alle routine già interpretate. Le note includono bytes originali, indirizzi e chiamate API riconosciute.

## Riferimenti

- [Reference principale richiesta: kb.marrani.lol](https://kb.marrani.lol/)
- [Formato Hunk](https://kb.marrani.lol/dos/hunk-binary-format/)
- [Documentazione vasm](https://sun.hasenbraten.de/vasm/release/vasm.pdf)
- [Mirror del sorgente vasm usato per costruire il tool](https://github.com/alfishe/vasm)

La wiki nel pacchetto di analisi documenta evidenze, ipotesi, chiamate OS, accessi al blitter e formati dati.


## Annotazioni semantiche v0.6

La guida è in `docs/Guida_al_sorgente.md` nel pacchetto generale, con il catalogo `docs/Catalogo_routine.md`. I sorgenti includono 124 schede di routine, note sui blocchi importanti, sui riferimenti globali e sul flusso delle chiamate. I livelli di evidenza distinguono risultati verificati e attribuzioni parziali. La semantica completa del gameplay e dei formati DAA resta aperta.
