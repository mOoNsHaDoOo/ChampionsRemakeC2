# Stato del port asm -> C

Generato da `scripts/port_status.py`: routine delle schede `ROUTINE` di `rebuild/source`, portate se un sorgente di questa cartella ha il marcatore `/* PORT Hnnn+$XXXX */`.

Routine portate: **1107 / 1132**.

| Hunk | Byte | Routine | Portate |
| --- | ---: | ---: | ---: |
| H000 | 600 | 1 | 1 |
| H001 | 664 | 2 | 2 |
| H002 | 572 | 15 | 14 |
| H003 | 316 | 5 | 5 |
| H004 | 24284 | 2 | 2 |
| H005 | 21276 | 1 | 1 |
| H006 | 3020 | 4 | 4 |
| H007 | 3036 | 11 | 11 |
| H008 | 8660 | 21 | 21 |
| H009 | 988 | 3 | 3 |
| H010 | 2488 | 9 | 8 |
| H011 | 7004 | 13 | 13 |
| H012 | 13580 | 34 | 33 |
| H013 | 25244 | 22 | 19 |
| H014 | 224 | 2 | 2 |
| H015 | 1016 | 11 | 9 |
| H016 | 436 | 5 | 5 |
| H017 | 56 | 1 | 1 |
| H018 | 192 | 3 | 3 |
| H019 | 240 | 1 | 1 |
| H020 | 2884 | 6 | 4 |
| H021 | 1632 | 14 | 14 |
| H022 | 328 | 10 | 10 |
| H023 | 140 | 2 | 2 |
| H024 | 268 | 2 | 2 |
| H025 | 264 | 2 | 2 |
| H026 | 1452 | 11 | 11 |
| H027 | 18156 | 102 | 102 |
| H028 | 4488 | 16 | 16 |
| H029 | 6084 | 32 | 32 |
| H030 | 3240 | 18 | 18 |
| H031 | 212 | 4 | 4 |
| H032 | 9352 | 1 | 1 |
| H033 | 8140 | 17 | 17 |
| H034 | 472 | 3 | 3 |
| H035 | 1760 | 6 | 6 |
| H036 | 144 | 2 | 2 |
| H037 | 52 | 2 | 2 |
| H038 | 504 | 5 | 5 |
| H039 | 104 | 2 | 2 |
| H040 | 1632 | 5 | 5 |
| H041 | 240 | 4 | 4 |
| H042 | 4420 | 14 | 14 |
| H043 | 6680 | 32 | 29 |
| H044 | 2668 | 10 | 10 |
| H045 | 828 | 4 | 3 |
| H046 | 724 | 2 | 2 |
| H047 | 5224 | 8 | 8 |
| H048 | 6636 | 21 | 21 |
| H049 | 2992 | 13 | 11 |
| H050 | 136 | 4 | 4 |
| H051 | 256 | 2 | 2 |
| H052 | 316 | 1 | 1 |
| H053 | 504 | 3 | 3 |
| H054 | 52 | 2 | 2 |
| H055 | 180 | 4 | 4 |
| H056 | 2528 | 2 | 2 |
| H057 | 12872 | 33 | 33 |
| H058 | 4720 | 16 | 16 |
| H059 | 6340 | 14 | 14 |
| H060 | 396 | 2 | 2 |
| H061 | 16936 | 35 | 34 |
| H062 | 10496 | 32 | 32 |
| H063 | 16496 | 52 | 52 |
| H064 | 6460 | 28 | 28 |
| H065 | 14268 | 27 | 27 |
| H066 | 13840 | 27 | 26 |
| H067 | 9820 | 22 | 22 |
| H068 | 5788 | 14 | 14 |
| H069 | 232 | 3 | 3 |
| H070 | 6940 | 13 | 13 |
| H071 | 3132 | 5 | 5 |
| H072 | 5404 | 12 | 12 |
| H073 | 4928 | 10 | 10 |
| H074 | 1216 | 4 | 1 |
| H075 | 392 | 4 | 1 |
| H076 | 8 | 1 | 1 |
| H077 | 3100 | 8 | 8 |
| H078 | 8 | 1 | 1 |
| H079 | 148 | 5 | 5 |
| H080 | 1388 | 1 | 1 |
| H081 | 76 | 1 | 1 |
| H082 | 156 | 2 | 2 |
| H083 | 92 | 1 | 1 |
| H084 | 92 | 2 | 2 |
| H085 | 19904 | 85 | 84 |
| H086 | 2088 | 14 | 14 |
| H087 | 1132 | 4 | 4 |
| H088 | 328 | 2 | 2 |
| H089 | 8 | 1 | 1 |
| H090 | 200 | 3 | 3 |
| H091 | 8 | 1 | 1 |
| H092 | 200 | 2 | 2 |
| H093 | 56 | 1 | 1 |
| H094 | 1904 | 11 | 11 |
| H095 | 10484 | 21 | 21 |
| H096 | 19972 | 36 | 36 |
| H097 | 8296 | 15 | 15 |
| H098 | 844 | 4 | 4 |
| H099 | 932 | 2 | 2 |
| H100 | 28 | 1 | 1 |

## Dettaglio

### H000

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0000` | `Entry_InitializeModules` | verificato | h000_entry.c:109 |

### H001

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0058` | `Game_Main` | verificato | h001_main.c:68 |
| `$0066` | `Select_DataPrefix` | verificato | h001_main.c:35 |

### H002

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H002_00000008` | parziale | h002_dos.c:115 |
| `$0014` | `wrapper_Close` | parziale | h002_dos.c:256 |
| `$0026` | `wrapper_CreateDir` | parziale | h002_dos.c:354 |
| `$004A` | `wrapper_DeleteFile` | parziale | h002_dos.c:368 |
| `$0070` | `wrapper_Examine` | parziale | h002_dos.c:379 |
| `$0088` | `wrapper_ExNext` | parziale | h002_dos.c:415 |
| `$00A0` | `wrapper_Info` | parziale | h002_dos.c:223 |
| `$00C0` | `wrapper_IoErr` | parziale |  |
| `$00DC` | `wrapper_Lock` | parziale | h002_dos.c:163 |
| `$00F2` | `wrapper_Open` | parziale | h002_dos.c:271 |
| `$0122` | `wrapper_Read` | parziale | h002_dos.c:295 |
| `$0156` | `wrapper_Seek` | parziale | h002_dos.c:319 |
| `$01A2` | `wrapper_UnLock` | parziale | h002_dos.c:199 |
| `$01CC` | `wrapper_Write` | parziale | h002_dos.c:307 |
| `$01E8` | `wrapper_Execute` | parziale | h002_dos.c:337 |

### H003

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `sub_H003_00000004` | parziale | h003_exec.c:11 |
| `$0068` | `wrapper_AllocMem` | parziale | h003_exec.c:16 |
| `$007E` | `wrapper_AvailMem` | parziale | h003_exec.c:42 |
| `$0090` | `wrapper_CopyMem` | parziale | h003_exec.c:49 |
| `$00F6` | `wrapper_FreeMem` | parziale | h003_exec.c:31 |

### H004

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0C1A` | `module_init_H004` | parziale | h004_init.c:148 |
| `$0C28` | `sub_H004_00000C28` | parziale | h004_init.c:244 |

### H005

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$530A` | `(senza scheda)` | - | h005_data.c:6 |

### H006

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00EC` | `module_init_H006` | parziale | h006.c:35 |
| `$00FA` | `sub_H006_000000FA` | parziale | h006.c:54 |
| `$01AE` | `Initialize_GameEnvironment` | verificato | h006.c:93 |
| `$0914` | `sub_H006_00000914` | parziale | h006.c:262 |

### H007

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$02C0` | `module_init_H007` | parziale | h007.c:19 |
| `$02CE` | `(byte non classificati)` | - | h007.c:40 |
| `$0304` | `sub_H007_00000304` | parziale | h007.c:47 |
| `$0348` | `sub_H007_00000348` | parziale | h007.c:55 |
| `$03CA` | `sub_H007_000003CA` | parziale | h007.c:80 |
| `$04A0` | `sub_H007_000004A0` | parziale | h007.c:119 |
| `$04F2` | `Intro_LoadLBM` | parziale | h007.c:132 |
| `$064E` | `sub_H007_0000064E` | parziale | h007.c:178 |
| `$06B4` | `sub_H007_000006B4` | parziale | h007.c:197 |
| `$06EA` | `sub_H007_000006EA` | parziale | h007.c:241 |
| `$09D8` | `Intro_LoadAndShow` | verificato | h007.c:254 |

### H008

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$009A` | `module_init_H008` | parziale | h008.c:17 |
| `$0102` | `sub_H008_00000102` | parziale | h008.c:566 |
| `$0162` | `sub_H008_00000162` | parziale | h008.c:579 |
| `$01A0` | `sub_H008_000001A0` | parziale | h008.c:28 |
| `$01FC` | `UI_RequestChoice` | parziale | h008.c:338 |
| `$020A` | `sub_H008_0000020A` | parziale | h008.c:61 |
| `$03C8` | `sub_H008_000003C8` | parziale | h008.c:110 |
| `$139E` | `sub_H008_0000139E` | parziale | h008.c:22 |
| `$13C0` | `trampoline_H008_1AF4` | parziale | h008.c:808 |
| `$13CE` | `sub_H008_000013CE` | parziale | h008.c:618 |
| `$1448` | `sub_H008_00001448` | parziale | h008.c:641 |
| `$15DC` | `sub_H008_000015DC` | parziale | h008.c:675 |
| `$164E` | `sub_H008_0000164E` | parziale | h008.c:688 |
| `$16BA` | `sub_H008_000016BA` | parziale | h008.c:712 |
| `$176A` | `sub_H008_0000176A` | parziale | h008.c:721 |
| `$188A` | `sub_H008_0000188A` | parziale | h008.c:733 |
| `$19A8` | `sub_H008_000019A8` | parziale | h008.c:767 |
| `$1A60` | `sub_H008_00001A60` | parziale | h008.c:790 |
| `$203C` | `sub_H008_0000203C` | parziale | h008.c:973 |
| `$20C2` | `sub_H008_000020C2` | parziale | h008.c:990 |
| `$2178` | `sub_H008_00002178` | parziale | h008.c:1011 |

### H009

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0070` | `module_init_H009` | parziale | h009.c:11 |
| `$007E` | `sub_H009_0000007E` | parziale | h009.c:17 |
| `$010C` | `sub_H009_0000010C` | parziale | h009.c:36 |

### H010

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00B6` | `module_init_H010` | parziale | h010_input.c:25 |
| `$00C4` | `sub_H010_000000C4` | parziale | h010_input.c:176 |
| `$0332` | `sub_H010_00000332` | parziale | h010_input.c:235 |
| `$0360` | `sub_H010_00000360` | parziale | h010_input.c:248 |
| `$03AA` | `sub_H010_000003AA` | parziale | h010_input.c:56 |
| `$042E` | `trampoline_H010_0882` | parziale | h010_input.c:130 |
| `$043C` | `sub_H010_0000043C` | parziale | h010_input.c:69 |
| `$0882` | `Poll_IntuitionEvents` | verificato |  |
| `$0974` | `sub_H010_00000974` | parziale | h010_input.c:166 |

### H011

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00FE` | `module_init_H011` | parziale | h011.c:23 |
| `$010C` | `sub_H011_0000010C` | parziale | h011.c:30 |
| `$0162` | `sub_H011_00000162` | parziale | h011.c:42 |
| `$01AA` | `(senza scheda)` | - | h011.c:75 |
| `$0330` | `sub_H011_00000330` | parziale | h011.c:284 |
| `$04A6` | `sub_H011_000004A6` | parziale | h011.c:154 |
| `$04E2` | `sub_H011_000004E2` | parziale | h011.c:110 |
| `$058E` | `sub_H011_0000058E` | parziale | h011.c:334 |
| `$0868` | `sub_H011_00000868` | parziale | h011.c:399 |
| `$09C8` | `sub_H011_000009C8` | parziale | h011.c:120 |
| `$0B78` | `sub_H011_00000B78` | parziale | h011.c:624 |
| `$14EA` | `Load_WallDefinitions` | parziale | h011.c:173 |
| `$1876` | `Load3DMap_GEO` | verificato | h011.c:250 |

### H012

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0178` | `module_init_H012` | parziale | h012.c:39 |
| `$0186` | `trampoline_H012_3004` | parziale |  |
| `$018A` | `ECL_RunAtAddress` | verificato | h012.c:111 |
| `$01FA` | `(senza scheda)` | - | h012.c:164 |
| `$0208` | `sub_H012_00000208` | parziale | h012.c:144 |
| `$05D6` | `(senza scheda)` | - | h012.c:259 |
| `$0688` | `(senza scheda)` | - | h012.c:277 |
| `$0766` | `(senza scheda)` | - | h012.c:312 |
| `$0B18` | `(senza scheda)` | - | h012.c:387 |
| `$0BEA` | `(senza scheda)` | - | h012.c:514 |
| `$14C8` | `(senza scheda)` | - | h012.c:866 |
| `$15AE` | `(senza scheda)` | - | h012.c:589 |
| `$1DDE` | `(senza scheda)` | - | h012.c:816 |
| `$1E90` | `(senza scheda)` | - | h012.c:835 |
| `$1F4C` | `(senza scheda)` | - | h012.c:858 |
| `$1F68` | `(senza scheda)` | - | h012.c:898 |
| `$2358` | `(senza scheda)` | - | h012.c:997 |
| `$2392` | `(senza scheda)` | - | h012.c:1009 |
| `$23D6` | `(senza scheda)` | - | h012.c:1021 |
| `$241C` | `(senza scheda)` | - | h012.c:1035 |
| `$2486` | `(senza scheda)` | - | h012.c:1051 |
| `$2502` | `(senza scheda)` | - | h012.c:1067 |
| `$2596` | `(senza scheda)` | - | h012.c:1082 |
| `$26D6` | `(senza scheda)` | - | h012.c:1244 |
| `$2922` | `sub_H012_00002922` | parziale | h012.c:1309 |
| `$29A6` | `(senza scheda)` | - | h012.c:1334 |
| `$2AAE` | `(senza scheda)` | - | h012.c:1128 |
| `$2ABE` | `(senza scheda)` | - | h012.c:1135 |
| `$2AF6` | `(senza scheda)` | - | h012.c:1144 |
| `$2B64` | `(senza scheda)` | - | h012.c:1158 |
| `$2C28` | `(senza scheda)` | - | h012.c:1189 |
| `$2DF2` | `ECL_DispatchOpcode` | verificato | h012.c:45 |
| `$3020` | `sub_H012_00003020` | parziale | h012.c:1378 |
| `$3150` | `Scenario_MainLoop` | verificato | h012.c:1439 |

### H013

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0506` | `module_init_H013` | parziale | h013.c:24 |
| `$0518` | `trampoline_H013_52E0` | parziale |  |
| `$051C` | `trampoline_H013_58DC` | parziale |  |
| `$0520` | `trampoline_H013_56CE` | parziale |  |
| `$0524` | `sub_H013_00000524` | parziale | h013.c:1091 |
| `$07B2` | `sub_H013_000007B2` | parziale | h013.c:1158 |
| `$08C2` | `trampoline_H013_097C` | parziale | h013.c:1207 |
| `$0982` | `Create_Character` | parziale | h013.c:1381 |
| `$0990` | `sub_H013_00000990` | parziale | h013.c:1239 |
| `$2B9A` | `trampoline_H013_2D70` | parziale | h013.c:794 |
| `$2D76` | `trampoline_H013_2E1A` | parziale | h013.c:106 |
| `$2E44` | `sub_H013_00002E44` | parziale | h013.c:137 |
| `$30DA` | `sub_H013_000030DA` | parziale | h013.c:216 |
| `$31E0` | `trampoline_H013_43E2` | parziale | h013.c:315 |
| `$31EE` | `trampoline_H013_333C` | parziale | h013.c:259 |
| `$43E8` | `sub_H013_000043E8` | parziale | h013.c:637 |
| `$4508` | `sub_H013_00004508` | parziale | h013.c:678 |
| `$4BFC` | `Party_MainMenu` | verificato | h013.c:96 |
| `$4C0A` | `sub_H013_00004C0A` | parziale | h013.c:57 |
| `$52E0` | `Add_CharacterToParty` | parziale | h013.c:2212 |
| `$56CE` | `(senza scheda)` | - | h013.c:1056 |
| `$58DC` | `(senza scheda)` | - | h013.c:1996 |

### H014

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$000A` | `module_init_H014` | parziale | h014.c:8 |
| `$0018` | `sub_H014_00000018` | parziale | h014.c:14 |

### H015

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0042` | `trampoline_H015_0196` | parziale | h015_runtime.c:27 |
| `$0046` | `trampoline_H015_033E` | parziale | h015_runtime.c:41 |
| `$004A` | `sub_H015_0000004A` | parziale | h015_runtime.c:55 |
| `$006E` | `sub_H015_0000006E` | parziale | h015_runtime.c:61 |
| `$00BC` | `sub_H015_000000BC` | parziale | h015_runtime.c:71 |
| `$010C` | `wrapper_SPMul` | parziale | h015_runtime.c:183 |
| `$0122` | `wrapper_SPDiv` | parziale | h015_runtime.c:189 |
| `$0172` | `wrapper_SPFlt` | parziale | h015_runtime.c:200 |
| `$0184` | `sub_H015_00000184` | parziale | h015_runtime.c:206 |
| `$0196` | `Runtime_Start` | verificato |  |
| `$033E` | `Runtime_Cleanup` | verificato |  |

### H016

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H016_00000008` | parziale | h016_gfx.c:5 |
| `$0014` | `wrapper_BltBitMap` | parziale | h016_gfx.c:22 |
| `$0084` | `wrapper_BltClear` | parziale | h016_gfx.c:16 |
| `$00A0` | `wrapper_BltMaskBitMapRastPort` | parziale | h016_gfx.c:39 |
| `$01AC` | `wrapper_WaitTOF` | parziale | h016_gfx.c:32 |

### H017

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `(senza scheda)` | - | h017.c:4 |

### H018

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `sub_H018_00000004` | parziale | h018_libs.c:4 |
| `$0018` | `wrapper_CloseLibrary` | parziale | h018_libs.c:9 |
| `$006A` | `wrapper_OpenLibrary` | parziale | h018_libs.c:15 |

### H019

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H019_00000008` | parziale | h019.c:4 |

### H020

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00BA` | `trampoline_H020_0B38` | parziale | h020_io.c:8 |
| `$00C2` | `sub_H020_000000C2` | parziale |  |
| `$00F0` | `sub_H020_000000F0` | parziale |  |
| `$082E` | `trampoline_H020_0856` | parziale | h020_io.c:30 |
| `$085A` | `sub_H020_0000085A` | parziale | h020_io.c:15 |
| `$08C2` | `sub_H020_000008C2` | parziale | h020_io.c:38 |

### H021

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H021_00000008` | parziale | h021_intuition.c:4 |
| `$0030` | `wrapper_CurrentTime` | parziale | h021_intuition.c:15 |
| `$010C` | `wrapper_CloseScreen` | parziale | h021_intuition.c:32 |
| `$011E` | `wrapper_CloseWorkBench` | parziale | h021_intuition.c:38 |
| `$0184` | `wrapper_OpenScreen` | parziale | h021_intuition.c:44 |
| `$0196` | `wrapper_OpenWorkBench` | parziale | h021_intuition.c:50 |
| `$01D2` | `wrapper_ShowTitle` | parziale | h021_intuition.c:56 |
| `$01FA` | `wrapper_ActivateWindow` | parziale | h021_intuition.c:62 |
| `$0230` | `wrapper_ClearPointer` | parziale | h021_intuition.c:68 |
| `$0242` | `wrapper_CloseWindow` | parziale | h021_intuition.c:74 |
| `$026C` | `wrapper_ModifyIDCMP` | parziale | h021_intuition.c:104 |
| `$029C` | `wrapper_OpenWindow` | parziale | h021_intuition.c:80 |
| `$02EE` | `wrapper_SetPointer` | parziale | h021_intuition.c:96 |
| `$03AE` | `wrapper_AutoRequest` | parziale | h021_intuition.c:86 |

### H022

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H022_00000008` | parziale | h022_view.c:4 |
| `$0014` | `wrapper_FreeColorMap` | parziale | h022_view.c:59 |
| `$0026` | `wrapper_FreeVPortCopLists` | parziale | h022_view.c:65 |
| `$0038` | `wrapper_GetColorMap` | parziale | h022_view.c:23 |
| `$0060` | `wrapper_InitView` | parziale | h022_view.c:29 |
| `$0072` | `wrapper_InitVPort` | parziale | h022_view.c:35 |
| `$0084` | `wrapper_LoadRGB4` | parziale | h022_view.c:14 |
| `$00A0` | `wrapper_LoadView` | parziale | h022_view.c:41 |
| `$00B2` | `wrapper_MakeVPort` | parziale | h022_view.c:47 |
| `$00C8` | `wrapper_MrgCop` | parziale | h022_view.c:53 |

### H023

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `trampoline_H023_007E` | parziale | h023_shared.c:7 |
| `$0010` | `sub_H023_00000010` | parziale | h023_shared.c:14 |

### H024

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$001C` | `module_init_H024` | parziale | h024_screen.c:22 |
| `$002A` | `Open_GameScreen` | verificato | h024_screen.c:38 |

### H025

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$001A` | `module_init_H025` | parziale | h025_window.c:20 |
| `$0028` | `Open_GameWindow` | verificato | h025_window.c:37 |

### H026

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H026_05A6` | parziale | h026_string.c:5 |
| `$000C` | `trampoline_H026_0014` | parziale | h026_string.c:103 |
| `$003A` | `sub_H026_0000003A` | parziale | h026_string.c:11 |
| `$0088` | `sub_H026_00000088` | parziale | h026_string.c:30 |
| `$0106` | `sub_H026_00000106` | parziale | h026_string.c:77 |
| `$0188` | `sub_H026_00000188` | parziale | h026_string.c:115 |
| `$01E0` | `sub_H026_000001E0` | parziale | h026_string.c:129 |
| `$0254` | `sub_H026_00000254` | parziale | h026_string.c:205 |
| `$03F6` | `sub_H026_000003F6` | parziale | h026_string.c:149 |
| `$0452` | `sub_H026_00000452` | parziale | h026_string.c:165 |
| `$054E` | `sub_H026_0000054E` | parziale | h026_string.c:185 |

### H027

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0206` | `module_init_H027` | parziale | h027.c:15 |
| `$0214` | `sub_H027_00000214` | parziale | h027.c:535 |
| `$0286` | `sub_H027_00000286` | parziale | h027.c:21 |
| `$02BE` | `trampoline_H027_0306` | parziale | h027.c:159 |
| `$0312` | `sub_H027_00000312` | parziale | h027.c:63 |
| `$0338` | `sub_H027_00000338` | parziale | h027.c:547 |
| `$0364` | `(senza scheda)` | - | h027.c:72 |
| `$0390` | `(senza scheda)` | - | h027.c:80 |
| `$03D6` | `(senza scheda)` | - | h027.c:93 |
| `$0492` | `(senza scheda)` | - | h027.c:1034 |
| `$05C6` | `(senza scheda)` | - | h027.c:121 |
| `$0622` | `(senza scheda)` | - | h027.c:131 |
| `$067C` | `(senza scheda)` | - | h027.c:141 |
| `$06D4` | `(senza scheda)` | - | h027.c:1069 |
| `$07F4` | `(senza scheda)` | - | h027.c:151 |
| `$080A` | `(senza scheda)` | - | h027.c:1097 |
| `$0912` | `(senza scheda)` | - | h027.c:171 |
| `$09A4` | `(senza scheda)` | - | h027.c:185 |
| `$0A00` | `(senza scheda)` | - | h027.c:32 |
| `$0A3E` | `(senza scheda)` | - | h027.c:198 |
| `$0A9E` | `(senza scheda)` | - | h027.c:208 |
| `$0AFE` | `(senza scheda)` | - | h027.c:730 |
| `$0B7A` | `(senza scheda)` | - | h027.c:580 |
| `$0D70` | `(senza scheda)` | - | h027.c:221 |
| `$0DB8` | `(senza scheda)` | - | h027.c:745 |
| `$0E18` | `(senza scheda)` | - | h027.c:234 |
| `$0EC6` | `(senza scheda)` | - | h027.c:251 |
| `$0EFC` | `(senza scheda)` | - | h027.c:937 |
| `$0FCE` | `(senza scheda)` | - | h027.c:1119 |
| `$10CC` | `(senza scheda)` | - | h027.c:258 |
| `$1120` | `(senza scheda)` | - | h027.c:268 |
| `$1162` | `(senza scheda)` | - | h027.c:1144 |
| `$1310` | `(senza scheda)` | - | h027.c:275 |
| `$133C` | `(senza scheda)` | - | h027.c:283 |
| `$1374` | `(senza scheda)` | - | h027.c:293 |
| `$13F4` | `(senza scheda)` | - | h027.c:1267 |
| `$174E` | `sub_H027_0000174E` | parziale | h027.c:1424 |
| `$17DE` | `sub_H027_000017DE` | parziale | h027.c:922 |
| `$1836` | `(senza scheda)` | - | h027.c:1444 |
| `$1878` | `(senza scheda)` | - | h027.c:305 |
| `$18A4` | `(senza scheda)` | - | h027.c:634 |
| `$1956` | `(senza scheda)` | - | h027.c:651 |
| `$1A0A` | `(senza scheda)` | - | h027.c:312 |
| `$1A42` | `(senza scheda)` | - | h027.c:672 |
| `$1B88` | `(senza scheda)` | - | h027.c:701 |
| `$1BFE` | `(senza scheda)` | - | h027.c:321 |
| `$1C7A` | `(senza scheda)` | - | h027.c:332 |
| `$1D0C` | `(senza scheda)` | - | h027.c:343 |
| `$1D3C` | `(senza scheda)` | - | h027.c:350 |
| `$1D80` | `(senza scheda)` | - | h027.c:715 |
| `$1E1A` | `(senza scheda)` | - | h027.c:359 |
| `$1E3C` | `(senza scheda)` | - | h027.c:1457 |
| `$2028` | `(senza scheda)` | - | h027.c:756 |
| `$20DA` | `(senza scheda)` | - | h027.c:779 |
| `$2138` | `(senza scheda)` | - | h027.c:367 |
| `$2182` | `sub_H027_00002182` | parziale | h027.c:556 |
| `$224C` | `(senza scheda)` | - | h027.c:789 |
| `$226C` | `(senza scheda)` | - | h027.c:792 |
| `$228E` | `(senza scheda)` | - | h027.c:802 |
| `$2400` | `(senza scheda)` | - | h027.c:1497 |
| `$25BA` | `(senza scheda)` | - | h027.c:838 |
| `$2646` | `(senza scheda)` | - | h027.c:858 |
| `$266A` | `(senza scheda)` | - | h027.c:1349 |
| `$29E2` | `(senza scheda)` | - | h027.c:1547 |
| `$2B3E` | `(senza scheda)` | - | h027.c:1589 |
| `$2CA6` | `(senza scheda)` | - | h027.c:377 |
| `$2CFA` | `(senza scheda)` | - | h027.c:387 |
| `$2D46` | `(senza scheda)` | - | h027.c:1618 |
| `$2FE2` | `(senza scheda)` | - | h027.c:1699 |
| `$3160` | `(senza scheda)` | - | h027.c:1773 |
| `$3292` | `(senza scheda)` | - | h027.c:1311 |
| `$3612` | `(senza scheda)` | - | h027.c:861 |
| `$3636` | `(senza scheda)` | - | h027.c:1802 |
| `$37C2` | `(senza scheda)` | - | h027.c:795 |
| `$37E4` | `(senza scheda)` | - | h027.c:798 |
| `$3806` | `(senza scheda)` | - | h027.c:864 |
| `$3842` | `(senza scheda)` | - | h027.c:397 |
| `$3916` | `(senza scheda)` | - | h027.c:960 |
| `$3982` | `(senza scheda)` | - | h027.c:1830 |
| `$3A46` | `(senza scheda)` | - | h027.c:42 |
| `$3A84` | `(senza scheda)` | - | h027.c:416 |
| `$3AAA` | `(senza scheda)` | - | h027.c:424 |
| `$3AC8` | `(senza scheda)` | - | h027.c:431 |
| `$3AFC` | `(senza scheda)` | - | h027.c:440 |
| `$3B34` | `(senza scheda)` | - | h027.c:972 |
| `$3BC0` | `(senza scheda)` | - | h027.c:451 |
| `$3C2A` | `(senza scheda)` | - | h027.c:989 |
| `$3C88` | `(senza scheda)` | - | h027.c:1002 |
| `$3D02` | `(senza scheda)` | - | h027.c:461 |
| `$3D28` | `(senza scheda)` | - | h027.c:1740 |
| `$3E6C` | `(senza scheda)` | - | h027.c:470 |
| `$3EB2` | `(senza scheda)` | - | h027.c:477 |
| `$3F1E` | `(senza scheda)` | - | h027.c:489 |
| `$3F72` | `(senza scheda)` | - | h027.c:1013 |
| `$4028` | `(senza scheda)` | - | h027.c:873 |
| `$408A` | `(senza scheda)` | - | h027.c:888 |
| `$4104` | `(senza scheda)` | - | h027.c:903 |
| `$418E` | `(senza scheda)` | - | h027.c:504 |
| `$41AA` | `(senza scheda)` | - | h027.c:511 |
| `$41F6` | `(senza scheda)` | - | h027.c:52 |
| `$420C` | `(senza scheda)` | - | h027.c:519 |
| `$4276` | `sub_H027_00004276` | parziale | h027.c:1860 |

### H028

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$01B8` | `module_init_H028` | parziale | h028_files.c:21 |
| `$01C6` | `Open_WithRetry` | parziale | h028_files.c:49 |
| `$02D0` | `sub_H028_000002D0` | parziale | h028_files.c:30 |
| `$033E` | `sub_H028_0000033E` | parziale | h028_files.c:448 |
| `$0408` | `sub_H028_00000408` | parziale | h028_files.c:89 |
| `$0576` | `sub_H028_00000576` | parziale | h028_files.c:131 |
| `$05FA` | `Open_ResourceFile` | parziale | h028_files.c:148 |
| `$07E0` | `sub_H028_000007E0` | parziale | h028_files.c:470 |
| `$08F0` | `sub_H028_000008F0` | parziale | h028_files.c:502 |
| `$09DC` | `DAX_DecompressRLE` | verificato | h028_files.c:197 |
| `$0B80` | `sub_H028_00000B80` | parziale | h028_files.c:268 |
| `$0C68` | `sub_H028_00000C68` | parziale | h028_files.c:399 |
| `$0D36` | `sub_H028_00000D36` | parziale | h028_files.c:431 |
| `$0D74` | `sub_H028_00000D74` | parziale | h028_files.c:379 |
| `$0DD8` | `DAX_LoadBlock` | verificato | h028_files.c:290 |
| `$1098` | `sub_H028_00001098` | parziale | h028_files.c:525 |

### H029

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0118` | `module_init_H029` | parziale | h029_gfx.c:43 |
| `$0180` | `sub_H029_00000180` | parziale | h029_gfx.c:85 |
| `$01B6` | `sub_H029_000001B6` | parziale | h029_gfx.c:509 |
| `$0234` | `sub_H029_00000234` | parziale | h029_gfx.c:95 |
| `$0312` | `sub_H029_00000312` | parziale | h029_gfx.c:57 |
| `$0354` | `trampoline_H029_036C` | parziale | h029_gfx.c:324 |
| `$0376` | `trampoline_H029_0390` | parziale | h029_gfx.c:330 |
| `$039A` | `trampoline_H029_03B2` | parziale | h029_gfx.c:336 |
| `$03E2` | `sub_H029_000003E2` | parziale | h029_gfx.c:532 |
| `$0408` | `Allocate_GraphicRecord` | verificato | h029_gfx.c:173 |
| `$067A` | `Free_GraphicRecord` | parziale | h029_gfx.c:299 |
| `$0766` | `sub_H029_00000766` | parziale | h029_gfx.c:343 |
| `$091E` | `Populate_GraphicPlanes` | verificato | h029_gfx.c:380 |
| `$0A0E` | `Load_IndexedGraphicRecord` | verificato | h029_gfx.c:406 |
| `$0B94` | `Draw_GraphicTile24` | verificato | h029_gfx.c:658 |
| `$0D58` | `sub_H029_00000D58` | parziale | h029_gfx.c:704 |
| `$0E26` | `trampoline_H029_0E88` | parziale | h029_gfx.c:754 |
| `$0E92` | `trampoline_H029_0EF4` | parziale | h029_gfx.c:767 |
| `$0EFE` | `trampoline_H029_10AC` | parziale | h029_gfx.c:454 |
| `$10B8` | `sub_H029_000010B8` | parziale | h029_gfx.c:562 |
| `$115C` | `sub_H029_0000115C` | parziale | h029_gfx.c:123 |
| `$1206` | `sub_H029_00001206` | parziale | h029_gfx.c:139 |
| `$12BC` | `sub_H029_000012BC` | parziale | h029_gfx.c:161 |
| `$1308` | `sub_H029_00001308` | parziale | h029_gfx.c:230 |
| `$1346` | `Prepare_DisplayResources` | parziale | h029_gfx.c:242 |
| `$148E` | `sub_H029_0000148E` | parziale | h029_gfx.c:539 |
| `$14F6` | `sub_H029_000014F6` | parziale | h029_gfx.c:577 |
| `$1520` | `sub_H029_00001520` | parziale | h029_gfx.c:588 |
| `$1576` | `sub_H029_00001576` | parziale | h029_gfx.c:604 |
| `$16A2` | `sub_H029_000016A2` | parziale | h029_gfx.c:624 |
| `$16DE` | `sub_H029_000016DE` | parziale | h029_gfx.c:642 |
| `$1718` | `sub_H029_00001718` | parziale | h029_gfx.c:731 |

### H030

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0070` | `module_init_H030` | parziale | h030.c:16 |
| `$00B6` | `sub_H030_000000B6` | parziale | h030.c:63 |
| `$019A` | `sub_H030_0000019A` | parziale | h030.c:22 |
| `$0256` | `UI_DrawText` | parziale | h030.c:42 |
| `$028A` | `sub_H030_0000028A` | parziale | h030.c:213 |
| `$0302` | `trampoline_H030_0470` | parziale | h030.c:288 |
| `$0310` | `sub_H030_00000310` | parziale | h030.c:246 |
| `$03B8` | `sub_H030_000003B8` | parziale | h030.c:264 |
| `$03FC` | `sub_H030_000003FC` | parziale | h030.c:272 |
| `$0718` | `sub_H030_00000718` | parziale | h030.c:106 |
| `$09A6` | `sub_H030_000009A6` | parziale | h030.c:369 |
| `$0A40` | `sub_H030_00000A40` | parziale | h030.c:92 |
| `$0AD2` | `sub_H030_00000AD2` | parziale | h030.c:194 |
| `$0B4A` | `sub_H030_00000B4A` | parziale | h030.c:187 |
| `$0B6C` | `sub_H030_00000B6C` | parziale | h030.c:50 |
| `$0BDA` | `(byte non classificati)` | - | h030.c:151 |
| `$0C10` | `sub_H030_00000C10` | parziale | h030.c:161 |
| `$0C84` | `sub_H030_00000C84` | parziale | h030.c:181 |

### H031

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `module_init_H031` | parziale | h031.c:4 |
| `$0012` | `sub_H031_00000012` | parziale | h031.c:10 |
| `$003E` | `sub_H031_0000003E` | parziale | h031.c:23 |
| `$008A` | `sub_H031_0000008A` | parziale | h031.c:38 |

### H032

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `module_init_H032` | parziale | h032.c:6 |

### H033

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00E0` | `module_init_H033` | parziale | h033.c:483 |
| `$00EE` | `trampoline_H033_0164` | parziale | h033.c:31 |
| `$0366` | `sub_H033_00000366` | parziale | h033.c:104 |
| `$056E` | `sub_H033_0000056E` | parziale | h033.c:151 |
| `$06C0` | `sub_H033_000006C0` | parziale | h033.c:189 |
| `$07A4` | `sub_H033_000007A4` | parziale | h033.c:213 |
| `$084C` | `sub_H033_0000084C` | parziale | h033.c:239 |
| `$0C64` | `sub_H033_00000C64` | parziale | h033.c:332 |
| `$0D7C` | `sub_H033_00000D7C` | parziale | h033.c:368 |
| `$11FC` | `sub_H033_000011FC` | parziale | h033.c:821 |
| `$12D4` | `(senza scheda)` | - | h033.c:632 |
| `$1426` | `sub_H033_00001426` | parziale | h033.c:675 |
| `$17E6` | `sub_H033_000017E6` | parziale | h033.c:622 |
| `$1836` | `sub_H033_00001836` | parziale | h033.c:769 |
| `$18EE` | `sub_H033_000018EE` | parziale | h033.c:795 |
| `$1A40` | `(senza scheda)` | - | h033.c:617 |
| `$1A50` | `sub_H033_00001A50` | parziale | h033.c:489 |

### H034

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0024` | `module_init_H034` | parziale | h034.c:11 |
| `$0032` | `sub_H034_00000032` | parziale | h034.c:17 |
| `$0178` | `trampoline_H034_01A8` | parziale | h034.c:50 |

### H035

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0032` | `module_init_H035` | parziale | h035.c:13 |
| `$0040` | `sub_H035_00000040` | parziale | h035.c:54 |
| `$019A` | `sub_H035_0000019A` | parziale | h035.c:88 |
| `$01DC` | `sub_H035_000001DC` | parziale | h035.c:97 |
| `$0246` | `sub_H035_00000246` | parziale | h035.c:19 |
| `$0460` | `sub_H035_00000460` | parziale | h035.c:110 |

### H036

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H036_00000008` | parziale | h036.c:5 |
| `$0034` | `wrapper_Delay` | parziale | h036.c:12 |

### H037

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H037_00000008` | parziale | h037.c:5 |
| `$0014` | `wrapper_InitBitMap` | parziale | h037.c:16 |

### H038

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H038_00000008` | parziale | h038.c:5 |
| `$0118` | `wrapper_RectFill` | parziale | h038.c:16 |
| `$013C` | `wrapper_SetAPen` | parziale | h038.c:23 |
| `$016C` | `wrapper_SetBPen` | parziale | h038.c:29 |
| `$01B4` | `sub_H038_000001B4` | parziale | h038.c:36 |

### H039

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H039_0064` | parziale | h039.c:4 |
| `$000C` | `trampoline_H039_0022` | parziale | h039.c:9 |

### H040

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0210` | `trampoline_H040_065C` | parziale | h040.c:20 |
| `$0218` | `IFF_FORM_ILBM` | verificato | h040.c:26 |
| `$04B6` | `IFF_PROP_ILBM` | verificato | h040.c:111 |
| `$05AA` | `IFF_LIST` | verificato | h040.c:142 |
| `$05E4` | `Read_ILBM` | verificato | h040.c:151 |

### H041

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H041_00EC` | parziale | h041.c:5 |
| `$000C` | `sub_H041_0000000C` | parziale | h041.c:11 |
| `$004A` | `(senza scheda)` | - | h041.c:27 |
| `$00BE` | `sub_H041_000000BE` | parziale | h041.c:33 |

### H042

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0146` | `module_init_H042` | parziale | h042_seq.c:25 |
| `$01AE` | `sub_H042_000001AE` | parziale | h042_seq.c:63 |
| `$0254` | `sub_H042_00000254` | parziale | h042_seq.c:85 |
| `$02B2` | `sub_H042_000002B2` | parziale | h042_seq.c:101 |
| `$02D6` | `sub_H042_000002D6` | parziale | h042_seq.c:107 |
| `$0300` | `Free_Sequence` | verificato | h042_seq.c:33 |
| `$03BC` | `sub_H042_000003BC` | parziale | h042_seq.c:113 |
| `$0406` | `Load_Sequence` | parziale | h042_seq.c:122 |
| `$0B80` | `sub_H042_00000B80` | parziale | h042_seq.c:291 |
| `$0D70` | `Load_HeadBody` | parziale | h042_seq.c:344 |
| `$0ED2` | `sub_H042_00000ED2` | parziale | h042_seq.c:374 |
| `$0F50` | `Show3DSprite` | parziale | h042_seq.c:392 |
| `$1006` | `Load_BigPicture` | parziale | h042_seq.c:413 |
| `$10DC` | `sub_H042_000010DC` | parziale | h042_seq.c:438 |

### H043

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$01BC` | `module_init_H043` | parziale | h043_audio.c:17 |
| `$01CA` | `trampoline_H043_165A` | parziale |  |
| `$01D2` | `trampoline_H043_113E` | parziale |  |
| `$01D6` | `sub_H043_000001D6` | parziale | h043_audio.c:56 |
| `$0214` | `sub_H043_00000214` | parziale | h043_audio.c:67 |
| `$0252` | `sub_H043_00000252` | parziale | h043_audio.c:78 |
| `$0286` | `sub_H043_00000286` | parziale | h043_audio.c:87 |
| `$02C4` | `sub_H043_000002C4` | parziale | h043_audio.c:95 |
| `$0304` | `(senza scheda)` | - | h043_audio.c:113 |
| `$0340` | `sub_H043_00000340` | parziale | h043_audio.c:123 |
| `$038A` | `sub_H043_0000038A` | parziale | h043_audio.c:134 |
| `$03CA` | `sub_H043_000003CA` | parziale | h043_audio.c:141 |
| `$0422` | `sub_H043_00000422` | parziale | h043_audio.c:155 |
| `$045E` | `sub_H043_0000045E` | parziale | h043_audio.c:165 |
| `$048E` | `sub_H043_0000048E` | parziale | h043_audio.c:174 |
| `$04B6` | `sub_H043_000004B6` | parziale | h043_audio.c:183 |
| `$0584` | `Audio_Initialize` | verificato | h043_audio.c:680 |
| `$07F6` | `trampoline_H043_15C6` | parziale |  |
| `$07FA` | `sub_H043_000007FA` | parziale | h043_audio.c:228 |
| `$0840` | `Audio_Shutdown` | parziale | h043_audio.c:241 |
| `$08C4` | `sub_H043_000008C4` | parziale | h043_audio.c:263 |
| `$0986` | `sub_H043_00000986` | parziale | h043_audio.c:295 |
| `$0BB2` | `sub_H043_00000BB2` | parziale | h043_audio.c:355 |
| `$0D3A` | `sub_H043_00000D3A` | parziale | h043_audio.c:403 |
| `$0D84` | `sub_H043_00000D84` | parziale | h043_audio.c:414 |
| `$0F50` | `sub_H043_00000F50` | parziale | h043_audio.c:458 |
| `$1058` | `sub_H043_00001058` | parziale | h043_audio.c:503 |
| `$113E` | `sub_H043_0000113E` | parziale | h043_audio.c:538 |
| `$15C6` | `sub_H043_000015C6` | parziale | h043_audio.c:206 |
| `$165A` | `(senza scheda)` | - | h043_audio.c:653 |
| `$169A` | `trampoline_H043_18EC` | parziale | h043_audio.c:665 |
| `$190E` | `Audio_Command` | parziale | h043_audio.c:756 |

### H044

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00BA` | `module_init_H044` | parziale | h044_tiles.c:21 |
| `$00C8` | `trampoline_H044_016C` | parziale | h044_tiles.c:103 |
| `$01C2` | `sub_H044_000001C2` | parziale | h044_tiles.c:143 |
| `$02D8` | `sub_H044_000002D8` | parziale | h044_tiles.c:174 |
| `$0330` | `sub_H044_00000330` | parziale | h044_tiles.c:257 |
| `$0452` | `sub_H044_00000452` | parziale | h044_tiles.c:283 |
| `$0492` | `sub_H044_00000492` | parziale | h044_tiles.c:295 |
| `$0586` | `sub_H044_00000586` | parziale | h044_tiles.c:232 |
| `$068E` | `sub_H044_0000068E` | parziale | h044_tiles.c:187 |
| `$07DE` | `sub_H044_000007DE` | parziale | h044_tiles.c:216 |

### H045

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H045_0336` | parziale | h045.c:5 |
| `$000C` | `trampoline_H045_01CC` | parziale | h045.c:56 |
| `$0014` | `sub_H045_00000014` | parziale |  |
| `$01D6` | `sub_H045_000001D6` | parziale | h045.c:11 |

### H046

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `module_init_H046` | parziale | h046.c:5 |
| `$0012` | `sub_H046_00000012` | parziale | h046.c:11 |

### H047

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00D8` | `module_init_H047` | parziale | h047.c:19 |
| `$00E6` | `trampoline_H047_08D6` | parziale | h047.c:250 |
| `$00F4` | `sub_H047_000000F4` | parziale | h047.c:33 |
| `$0162` | `sub_H047_00000162` | parziale | h047.c:45 |
| `$01EE` | `sub_H047_000001EE` | parziale | h047.c:62 |
| `$02FE` | `sub_H047_000002FE` | parziale | h047.c:92 |
| `$03EE` | `sub_H047_000003EE` | parziale | h047.c:121 |
| `$0688` | `sub_H047_00000688` | parziale | h047.c:197 |

### H048

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `module_init_H048` | parziale | h048.c:12 |
| `$0044` | `trampoline_H048_00B6` | parziale | h048.c:81 |
| `$00C2` | `sub_H048_000000C2` | parziale | h048.c:95 |
| `$0154` | `sub_H048_00000154` | parziale | h048.c:19 |
| `$01E8` | `sub_H048_000001E8` | parziale | h048.c:106 |
| `$0230` | `sub_H048_00000230` | parziale | h048.c:116 |
| `$0334` | `sub_H048_00000334` | parziale | h048.c:151 |
| `$0588` | `sub_H048_00000588` | parziale | h048.c:187 |
| `$0884` | `sub_H048_00000884` | parziale | h048.c:224 |
| `$0956` | `sub_H048_00000956` | parziale | h048.c:244 |
| `$0AA8` | `sub_H048_00000AA8` | parziale | h048.c:271 |
| `$0B1A` | `sub_H048_00000B1A` | parziale | h048.c:290 |
| `$0DF2` | `sub_H048_00000DF2` | parziale | h048.c:362 |
| `$0F88` | `sub_H048_00000F88` | parziale | h048.c:407 |
| `$0FBA` | `sub_H048_00000FBA` | parziale | h048.c:415 |
| `$0FEC` | `sub_H048_00000FEC` | parziale | h048.c:424 |
| `$110C` | `sub_H048_0000110C` | parziale | h048.c:450 |
| `$113E` | `sub_H048_0000113E` | parziale | h048.c:457 |
| `$12F4` | `sub_H048_000012F4` | parziale | h048.c:519 |
| `$16D4` | `sub_H048_000016D4` | parziale | h048.c:610 |
| `$195E` | `sub_H048_0000195E` | parziale | h048.c:670 |

### H049

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H049_00000008` | parziale | h049.c:10 |
| `$0014` | `trampoline_H049_0082` | parziale | h049.c:484 |
| `$012A` | `trampoline_H049_0198` | parziale | h049.c:186 |
| `$0224` | `Draw_TextWithBlitter` | verificato | h049.c:95 |
| `$0438` | `sub_H049_00000438` | parziale | h049.c:35 |
| `$044E` | `trampoline_H049_0450` | parziale | h049.c:45 |
| `$045A` | `Draw_GlyphRowsCPU` | verificato | h049.c:57 |
| `$04AE` | `Queue_BitplaneBlit` | verificato | h049.c:320 |
| `$06EC` | `QueuedBlit_Callback` | verificato |  |
| `$0782` | `QueuedBlit_Cleanup` | verificato |  |
| `$079E` | `sub_H049_0000079E` | parziale | h049.c:304 |
| `$09D6` | `sub_H049_000009D6` | parziale | h049.c:443 |
| `$0A7A` | `trampoline_H049_0A8E` | parziale | h049.c:422 |

### H050

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `sub_H050_00000004` | parziale | h050.c:4 |
| `$002A` | `wrapper_GetMsg` | parziale | h050.c:9 |
| `$0064` | `wrapper_ReplyMsg` | parziale | h050.c:15 |
| `$0076` | `wrapper_WaitPort` | parziale | h050.c:21 |

### H051

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `sub_H051_00000004` | parziale | h051.c:4 |
| `$004A` | `wrapper_FindTask` | parziale | h051.c:9 |

### H052

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0024` | `trampoline_H052_0114` | parziale | h052.c:7 |

### H053

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `module_init_H053` | parziale | h053.c:7 |
| `$0012` | `sub_H053_00000012` | parziale | h053.c:13 |
| `$00CA` | `trampoline_H053_01E8` | parziale | h053.c:44 |

### H054

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H054_0030` | parziale | h054.c:4 |
| `$000C` | `trampoline_H054_0028` | parziale | h054.c:9 |

### H055

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H055_00000008` | parziale | h055.c:5 |
| `$0014` | `wrapper_AllocRaster` | parziale | h055.c:16 |
| `$002A` | `wrapper_FreeRaster` | parziale | h055.c:28 |
| `$0044` | `wrapper_InitRastPort` | parziale | h055.c:22 |

### H056

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$025A` | `module_init_H056` | parziale | h056.c:8 |
| `$0886` | `sub_H056_00000886` | parziale | h056.c:14 |

### H057

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$05A6` | `module_init_H057` | parziale | h057.c:66 |
| `$05B4` | `sub_H057_000005B4` | parziale | h057.c:73 |
| `$0778` | `trampoline_H057_0788` | parziale | h057.c:129 |
| `$078E` | `sub_H057_0000078E` | parziale | h057.c:135 |
| `$07E8` | `sub_H057_000007E8` | parziale | h057.c:148 |
| `$0878` | `sub_H057_00000878` | parziale | h057.c:164 |
| `$08B4` | `sub_H057_000008B4` | parziale | h057.c:176 |
| `$0AE0` | `sub_H057_00000AE0` | parziale | h057.c:231 |
| `$0C04` | `sub_H057_00000C04` | parziale | h057.c:265 |
| `$0CD4` | `sub_H057_00000CD4` | parziale | h057.c:297 |
| `$11AC` | `sub_H057_000011AC` | parziale | h057.c:420 |
| `$126C` | `sub_H057_0000126C` | parziale | h057.c:441 |
| `$1342` | `sub_H057_00001342` | parziale | h057.c:460 |
| `$1590` | `sub_H057_00001590` | parziale | h057.c:529 |
| `$18D6` | `trampoline_H057_1976` | parziale | h057.c:638 |
| `$18E4` | `sub_H057_000018E4` | parziale | h057.c:626 |
| `$1DD8` | `sub_H057_00001DD8` | parziale | h057.c:740 |
| `$1EE0` | `sub_H057_00001EE0` | parziale | h057.c:779 |
| `$1FD6` | `sub_H057_00001FD6` | parziale | h057.c:814 |
| `$20A0` | `trampoline_H057_2208` | parziale | h057.c:843 |
| `$220E` | `sub_H057_0000220E` | parziale | h057.c:891 |
| `$2368` | `sub_H057_00002368` | parziale | h057.c:930 |
| `$24AE` | `sub_H057_000024AE` | parziale | h057.c:955 |
| `$25AE` | `sub_H057_000025AE` | parziale | h057.c:993 |
| `$27B2` | `sub_H057_000027B2` | parziale | h057.c:1047 |
| `$29DA` | `trampoline_H057_2E8A` | parziale | h057.c:1274 |
| `$29E8` | `trampoline_H057_29FE` | parziale | h057.c:1124 |
| `$2A06` | `sub_H057_00002A06` | parziale | h057.c:1131 |
| `$2AFE` | `sub_H057_00002AFE` | parziale | h057.c:1157 |
| `$2BBA` | `sub_H057_00002BBA` | parziale | h057.c:1179 |
| `$2C08` | `sub_H057_00002C08` | parziale | h057.c:1192 |
| `$2DC8` | `sub_H057_00002DC8` | parziale | h057.c:1250 |
| `$2F3A` | `sub_H057_00002F3A` | parziale | h057.c:1311 |

### H058

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00CE` | `module_init_H058` | parziale | h058.c:25 |
| `$017C` | `trampoline_H058_02C4` | parziale | h058.c:70 |
| `$018A` | `sub_H058_0000018A` | parziale | h058.c:31 |
| `$02F4` | `sub_H058_000002F4` | parziale | h058.c:108 |
| `$052C` | `sub_H058_0000052C` | parziale | h058.c:79 |
| `$05F4` | `sub_H058_000005F4` | parziale | h058.c:219 |
| `$064A` | `sub_H058_0000064A` | parziale | h058.c:188 |
| `$070E` | `sub_H058_0000070E` | parziale | h058.c:235 |
| `$084C` | `sub_H058_0000084C` | parziale | h058.c:271 |
| `$09AA` | `sub_H058_000009AA` | parziale | h058.c:299 |
| `$0B84` | `sub_H058_00000B84` | parziale | h058.c:381 |
| `$0C38` | `sub_H058_00000C38` | parziale | h058.c:412 |
| `$0D2C` | `sub_H058_00000D2C` | parziale | h058.c:439 |
| `$0E80` | `sub_H058_00000E80` | parziale | h058.c:478 |
| `$0F5C` | `sub_H058_00000F5C` | parziale | h058.c:505 |
| `$1014` | `sub_H058_00001014` | parziale | h058.c:537 |

### H059

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0122` | `module_init_H059` | parziale | h059.c:31 |
| `$0130` | `sub_H059_00000130` | parziale | h059.c:37 |
| `$02AA` | `sub_H059_000002AA` | parziale | h059.c:87 |
| `$03BE` | `sub_H059_000003BE` | parziale | h059.c:125 |
| `$0670` | `sub_H059_00000670` | parziale | h059.c:176 |
| `$0726` | `trampoline_H059_07F6` | parziale | h059.c:224 |
| `$0734` | `sub_H059_00000734` | parziale | h059.c:210 |
| `$0CCA` | `sub_H059_00000CCA` | parziale | h059.c:329 |
| `$0E4A` | `sub_H059_00000E4A` | parziale | h059.c:361 |
| `$0EA0` | `sub_H059_00000EA0` | parziale | h059.c:372 |
| `$1110` | `sub_H059_00001110` | parziale | h059.c:439 |
| `$1498` | `Combat_ActorTurn` | parziale | h059.c:556 |
| `$15EE` | `sub_H059_000015EE` | parziale | h059.c:593 |
| `$1782` | `Combat_MainLoop` | parziale | h059.c:636 |

### H060

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$000A` | `module_init_H060` | parziale | h060.c:10 |
| `$0018` | `sub_H060_00000018` | parziale | h060.c:16 |

### H061

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$15C2` | `module_init_H061` | parziale | h061.c:37 |
| `$162A` | `trampoline_H061_1F12` | parziale |  |
| `$162E` | `sub_H061_0000162E` | parziale | h061.c:48 |
| `$1670` | `ECL_ReadOperands` | verificato | h061.c:450 |
| `$184E` | `ECL_EvaluateOperand` | parziale | h061.c:502 |
| `$1928` | `ECL_ResetExecution` | verificato | h061.c:638 |
| `$1ACC` | `ECL_LoadProgram` | verificato | h061.c:688 |
| `$1BD6` | `sub_H061_00001BD6` | parziale | h061.c:715 |
| `$1C42` | `sub_H061_00001C42` | parziale | h061.c:729 |
| `$1D20` | `sub_H061_00001D20` | parziale | h061.c:761 |
| `$1D6E` | `sub_H061_00001D6E` | parziale | h061.c:772 |
| `$1F12` | `sub_H061_00001F12` | parziale | h061.c:58 |
| `$1F3C` | `ECL_DecodeAddress` | verificato | h061.c:64 |
| `$1F6A` | `trampoline_H061_1F9A` | parziale | h061.c:70 |
| `$1FA4` | `sub_H061_00001FA4` | parziale | h061.c:80 |
| `$202C` | `sub_H061_0000202C` | parziale | h061.c:103 |
| `$208E` | `sub_H061_0000208E` | parziale | h061.c:123 |
| `$27E2` | `sub_H061_000027E2` | parziale | h061.c:284 |
| `$2BAA` | `sub_H061_00002BAA` | parziale | h061.c:370 |
| `$2E04` | `sub_H061_00002E04` | parziale | h061.c:234 |
| `$3012` | `sub_H061_00003012` | parziale | h061.c:1164 |
| `$3244` | `sub_H061_00003244` | parziale | h061.c:532 |
| `$33F0` | `sub_H061_000033F0` | parziale | h061.c:584 |
| `$35E2` | `sub_H061_000035E2` | parziale | h061.c:825 |
| `$36E6` | `sub_H061_000036E6` | parziale | h061.c:852 |
| `$3860` | `sub_H061_00003860` | parziale | h061.c:1222 |
| `$3904` | `sub_H061_00003904` | parziale | h061.c:898 |
| `$3A0A` | `sub_H061_00003A0A` | parziale | h061.c:931 |
| `$3AAC` | `sub_H061_00003AAC` | parziale | h061.c:956 |
| `$3B4E` | `trampoline_H061_3BEE` | parziale | h061.c:976 |
| `$3C4C` | `sub_H061_00003C4C` | parziale | h061.c:1021 |
| `$3DBE` | `sub_H061_00003DBE` | parziale | h061.c:1038 |
| `$3E80` | `ECL_SkipInstruction` | verificato | h061.c:1065 |
| `$3FA8` | `sub_H061_00003FA8` | parziale | h061.c:1089 |
| `$4092` | `sub_H061_00004092` | parziale | h061.c:1123 |

### H062

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0106` | `module_init_H062` | parziale | h062.c:17 |
| `$0114` | `sub_H062_00000114` | parziale | h062.c:555 |
| `$021E` | `sub_H062_0000021E` | parziale | h062.c:883 |
| `$02FA` | `sub_H062_000002FA` | parziale | h062.c:777 |
| `$03F2` | `sub_H062_000003F2` | parziale | h062.c:111 |
| `$0452` | `sub_H062_00000452` | parziale | h062.c:124 |
| `$057C` | `sub_H062_0000057C` | parziale | h062.c:425 |
| `$0772` | `sub_H062_00000772` | parziale | h062.c:471 |
| `$083E` | `trampoline_H062_0F04` | parziale | h062.c:531 |
| `$0F24` | `sub_H062_00000F24` | parziale | h062.c:906 |
| `$1038` | `trampoline_H062_1262` | parziale | h062.c:936 |
| `$126C` | `sub_H062_0000126C` | parziale | h062.c:1022 |
| `$12F6` | `sub_H062_000012F6` | parziale | h062.c:581 |
| `$142C` | `sub_H062_0000142C` | parziale | h062.c:618 |
| `$156C` | `sub_H062_0000156C` | parziale | h062.c:22 |
| `$15C6` | `sub_H062_000015C6` | parziale | h062.c:769 |
| `$15F2` | `sub_H062_000015F2` | parziale | h062.c:40 |
| `$1694` | `sub_H062_00001694` | parziale | h062.c:987 |
| `$1780` | `sub_H062_00001780` | parziale | h062.c:65 |
| `$17C0` | `sub_H062_000017C0` | parziale | h062.c:656 |
| `$1898` | `sub_H062_00001898` | parziale | h062.c:1016 |
| `$18AC` | `sub_H062_000018AC` | parziale | h062.c:382 |
| `$1916` | `sub_H062_00001916` | parziale | h062.c:396 |
| `$1952` | `sub_H062_00001952` | parziale | h062.c:168 |
| `$19C2` | `sub_H062_000019C2` | parziale | h062.c:408 |
| `$1A32` | `trampoline_H062_1C04` | parziale | h062.c:238 |
| `$1A40` | `sub_H062_00001A40` | parziale | h062.c:194 |
| `$1A9E` | `sub_H062_00001A9E` | parziale | h062.c:203 |
| `$2188` | `sub_H062_00002188` | parziale | h062.c:675 |
| `$253C` | `sub_H062_0000253C` | parziale | h062.c:76 |
| `$2650` | `sub_H062_00002650` | parziale | h062.c:802 |
| `$2734` | `sub_H062_00002734` | parziale | h062.c:829 |

### H063

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0104` | `module_init_H063` | parziale | h063.c:24 |
| `$0112` | `sub_H063_00000112` | parziale | h063.c:49 |
| `$016A` | `sub_H063_0000016A` | parziale | h063.c:62 |
| `$0228` | `trampoline_H063_032C` | parziale | h063.c:86 |
| `$0354` | `sub_H063_00000354` | parziale | h063.c:121 |
| `$0432` | `sub_H063_00000432` | parziale | h063.c:251 |
| `$06AE` | `sub_H063_000006AE` | parziale | h063.c:297 |
| `$0758` | `sub_H063_00000758` | parziale | h063.c:316 |
| `$08A2` | `sub_H063_000008A2` | parziale | h063.c:348 |
| `$0946` | `sub_H063_00000946` | parziale | h063.c:371 |
| `$09B2` | `sub_H063_000009B2` | parziale | h063.c:388 |
| `$0D80` | `sub_H063_00000D80` | parziale | h063.c:711 |
| `$0FA0` | `sub_H063_00000FA0` | parziale | h063.c:463 |
| `$103A` | `sub_H063_0000103A` | parziale | h063.c:478 |
| `$1160` | `trampoline_H063_1350` | parziale | h063.c:1218 |
| `$135A` | `sub_H063_0000135A` | parziale | h063.c:1202 |
| `$13BE` | `sub_H063_000013BE` | parziale | h063.c:505 |
| `$18F8` | `sub_H063_000018F8` | parziale | h063.c:161 |
| `$19B6` | `sub_H063_000019B6` | parziale | h063.c:184 |
| `$1A8A` | `trampoline_H063_1B66` | parziale | h063.c:219 |
| `$1B90` | `sub_H063_00001B90` | parziale | h063.c:1082 |
| `$1BE8` | `sub_H063_00001BE8` | parziale | h063.c:823 |
| `$1CC0` | `sub_H063_00001CC0` | parziale | h063.c:989 |
| `$1D44` | `sub_H063_00001D44` | parziale | h063.c:692 |
| `$1DC2` | `sub_H063_00001DC2` | parziale | h063.c:854 |
| `$1EE8` | `sub_H063_00001EE8` | parziale | h063.c:884 |
| `$1F34` | `trampoline_H063_1F7E` | parziale | h063.c:622 |
| `$1FDC` | `sub_H063_00001FDC` | parziale | h063.c:1313 |
| `$2178` | `sub_H063_00002178` | parziale | h063.c:1343 |
| `$21D2` | `trampoline_H063_22B4` | parziale | h063.c:1384 |
| `$21E0` | `sub_H063_000021E0` | parziale | h063.c:1363 |
| `$2760` | `sub_H063_00002760` | parziale | h063.c:1096 |
| `$2984` | `sub_H063_00002984` | parziale | h063.c:1151 |
| `$2ACC` | `sub_H063_00002ACC` | parziale | h063.c:1009 |
| `$2B4C` | `trampoline_H063_2B72` | parziale | h063.c:1528 |
| `$2B7C` | `sub_H063_00002B7C` | parziale | h063.c:1188 |
| `$2BDE` | `sub_H063_00002BDE` | parziale | h063.c:1535 |
| `$2DC6` | `sub_H063_00002DC6` | parziale | h063.c:1257 |
| `$2F12` | `sub_H063_00002F12` | parziale | h063.c:894 |
| `$2F5A` | `sub_H063_00002F5A` | parziale | h063.c:1776 |
| `$2FAA` | `sub_H063_00002FAA` | parziale | h063.c:1026 |
| `$321A` | `trampoline_H063_3384` | parziale | h063.c:768 |
| `$33A0` | `trampoline_H063_3652` | parziale | h063.c:1583 |
| `$3658` | `sub_H063_00003658` | parziale | h063.c:1641 |
| `$3698` | `sub_H063_00003698` | parziale | h063.c:1714 |
| `$36EE` | `sub_H063_000036EE` | parziale | h063.c:1724 |
| `$3734` | `sub_H063_00003734` | parziale | h063.c:1734 |
| `$37B2` | `sub_H063_000037B2` | parziale | h063.c:1285 |
| `$3980` | `sub_H063_00003980` | parziale | h063.c:1752 |
| `$3A26` | `sub_H063_00003A26` | parziale | h063.c:907 |
| `$3CA0` | `sub_H063_00003CA0` | parziale | h063.c:1650 |
| `$3F72` | `trampoline_H063_4042` | parziale | h063.c:645 |

### H064

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00EE` | `module_init_H064` | parziale | h064.c:32 |
| `$0156` | `(senza scheda)` | - | h064.c:42 |
| `$0202` | `ECL_GOTO` | verificato | h064.c:70 |
| `$0234` | `ECL_GOSUB` | parziale | h064.c:77 |
| `$0258` | `(senza scheda)` | - | h064.c:84 |
| `$0306` | `ECL_Arithmetic` | verificato | h064.c:101 |
| `$03FC` | `(senza scheda)` | - | h064.c:140 |
| `$0468` | `ECL_SAVE_AssignVariable` | verificato | h064.c:155 |
| `$04DC` | `(senza scheda)` | - | h064.c:170 |
| `$05E2` | `(senza scheda)` | - | h064.c:309 |
| `$06A0` | `(senza scheda)` | - | h064.c:209 |
| `$0ABE` | `(senza scheda)` | - | h064.c:329 |
| `$0B10` | `(senza scheda)` | - | h064.c:341 |
| `$0C62` | `(senza scheda)` | - | h064.c:389 |
| `$0CC4` | `(senza scheda)` | - | h064.c:399 |
| `$0D4A` | `(senza scheda)` | - | h064.c:415 |
| `$0E40` | `ECL_RETURN` | verificato | h064.c:438 |
| `$0E9C` | `(senza scheda)` | - | h064.c:452 |
| `$0F30` | `(senza scheda)` | - | h064.c:471 |
| `$0F90` | `(senza scheda)` | - | h064.c:490 |
| `$1004` | `ECL_LOAD_FILES_or_PIECES` | verificato | h064.c:509 |
| `$121C` | `(senza scheda)` | - | h064.c:569 |
| `$12CA` | `(senza scheda)` | - | h064.c:590 |
| `$1346` | `(senza scheda)` | - | h064.c:604 |
| `$13AC` | `(senza scheda)` | - | h064.c:619 |
| `$1544` | `(senza scheda)` | - | h064.c:667 |
| `$1748` | `(senza scheda)` | - | h064.c:722 |
| `$17BC` | `(senza scheda)` | - | h064.c:743 |

### H065

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$04AA` | `module_init_H065` | parziale | h065.c:20 |
| `$04B8` | `sub_H065_000004B8` | parziale | h065.c:43 |
| `$0ADE` | `sub_H065_00000ADE` | parziale | h065.c:150 |
| `$0BE6` | `trampoline_H065_0C34` | parziale | h065.c:184 |
| `$0BF4` | `sub_H065_00000BF4` | parziale | h065.c:175 |
| `$10DE` | `trampoline_H065_1100` | parziale | h065.c:255 |
| `$12D6` | `sub_H065_000012D6` | parziale | h065.c:419 |
| `$1636` | `sub_H065_00001636` | parziale | h065.c:495 |
| `$196E` | `sub_H065_0000196E` | parziale | h065.c:555 |
| `$1C48` | `sub_H065_00001C48` | parziale | h065.c:644 |
| `$1D80` | `sub_H065_00001D80` | parziale | h065.c:675 |
| `$1D94` | `sub_H065_00001D94` | parziale | h065.c:950 |
| `$1E2C` | `sub_H065_00001E2C` | parziale | h065.c:682 |
| `$1EE4` | `sub_H065_00001EE4` | parziale | h065.c:706 |
| `$20EC` | `sub_H065_000020EC` | parziale | h065.c:973 |
| `$2308` | `sub_H065_00002308` | parziale | h065.c:1022 |
| `$255A` | `sub_H065_0000255A` | parziale | h065.c:1073 |
| `$2B2E` | `sub_H065_00002B2E` | parziale | h065.c:744 |
| `$2C04` | `sub_H065_00002C04` | parziale | h065.c:770 |
| `$2F82` | `sub_H065_00002F82` | parziale | h065.c:1229 |
| `$32F6` | `sub_H065_000032F6` | parziale | h065.c:911 |
| `$3390` | `trampoline_H065_3474` | parziale | h065.c:302 |
| `$347E` | `sub_H065_0000347E` | parziale | h065.c:935 |
| `$34FC` | `trampoline_H065_35AE` | parziale | h065.c:1305 |
| `$36A6` | `trampoline_H065_36B6` | parziale | h065.c:287 |
| `$36C0` | `trampoline_H065_36D0` | parziale | h065.c:294 |
| `$3702` | `sub_H065_00003702` | parziale | h065.c:340 |

### H066

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$02F0` | `module_init_H066` | parziale | h066.c:27 |
| `$03D0` | `trampoline_H066_0780` | parziale | h066.c:600 |
| `$03DE` | `sub_H066_000003DE` | parziale | h066.c:505 |
| `$0852` | `sub_H066_00000852` | parziale | h066.c:489 |
| `$08E4` | `trampoline_H066_0B88` | parziale | h066.c:238 |
| `$08F2` | `sub_H066_000008F2` | parziale | h066.c:220 |
| `$0BAC` | `sub_H066_00000BAC` | parziale | h066.c:38 |
| `$0C34` | `trampoline_H066_0E5A` | parziale | h066.c:108 |
| `$0C42` | `sub_H066_00000C42` | parziale | h066.c:50 |
| `$0D2A` | `sub_H066_00000D2A` | parziale | h066.c:77 |
| `$0DEA` | `sub_H066_00000DEA` | parziale | h066.c:96 |
| `$1312` | `Delete_CharacterSidecarFiles` | verificato | h066.c:792 |
| `$142E` | `Query_FreeDiskSpace` | parziale | h066.c:286 |
| `$14DC` | `Check_SaveWritable` | parziale | h066.c:316 |
| `$14EA` | `sub_H066_000014EA` | parziale | h066.c:307 |
| `$1640` | `Save_CharacterRecord` | verificato | h066.c:371 |
| `$164E` | `sub_H066_0000164E` | parziale | h066.c:359 |
| `$1B0E` | `Load_CharacterRecord` | verificato | h066.c:623 |
| `$1FDA` | `Load_MonsterRecord` | verificato | h066.c:1128 |
| `$1FE8` | `sub_H066_00001FE8` | parziale | h066.c:1116 |
| `$276E` | `trampoline_H066_27E4` | parziale | h066.c:734 |
| `$27EE` | `sub_H066_000027EE` | parziale | h066.c:753 |
| `$291E` | `Load_GameSlot` | verificato | h066.c:968 |
| `$292C` | `sub_H066_0000292C` | parziale |  |
| `$3000` | `Save_GameSlot` | verificato | h066.c:870 |
| `$300E` | `sub_H066_0000300E` | parziale | h066.c:817 |
| `$30A8` | `sub_H066_000030A8` | parziale | h066.c:841 |

### H067

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$01BA` | `module_init_H067` | parziale | h067.c:20 |
| `$01C8` | `sub_H067_000001C8` | parziale | h067.c:25 |
| `$01F2` | `sub_H067_000001F2` | parziale | h067.c:31 |
| `$0212` | `sub_H067_00000212` | parziale | h067.c:37 |
| `$0232` | `sub_H067_00000232` | parziale | h067.c:190 |
| `$02AE` | `sub_H067_000002AE` | parziale | h067.c:213 |
| `$032A` | `sub_H067_0000032A` | parziale | h067.c:227 |
| `$0374` | `sub_H067_00000374` | parziale | h067.c:238 |
| `$03BC` | `sub_H067_000003BC` | parziale | h067.c:250 |
| `$044E` | `sub_H067_0000044E` | parziale | h067.c:44 |
| `$06F8` | `sub_H067_000006F8` | parziale | h067.c:103 |
| `$0794` | `sub_H067_00000794` | parziale | h067.c:281 |
| `$086E` | `sub_H067_0000086E` | parziale | h067.c:302 |
| `$08CC` | `sub_H067_000008CC` | parziale | h067.c:317 |
| `$0C8C` | `sub_H067_00000C8C` | parziale | h067.c:120 |
| `$0D0A` | `sub_H067_00000D0A` | parziale | h067.c:394 |
| `$0DCA` | `sub_H067_00000DCA` | parziale | h067.c:134 |
| `$0F72` | `sub_H067_00000F72` | parziale | h067.c:415 |
| `$11F4` | `sub_H067_000011F4` | parziale | h067.c:487 |
| `$125A` | `sub_H067_0000125A` | parziale | h067.c:506 |
| `$1292` | `sub_H067_00001292` | parziale | h067.c:781 |
| `$1D7C` | `sub_H067_00001D7C` | parziale | h067.c:907 |

### H068

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00A4` | `module_init_H068` | parziale | h068.c:27 |
| `$00B2` | `trampoline_H068_00C0` | parziale | h068.c:33 |
| `$00CA` | `sub_H068_000000CA` | parziale | h068.c:44 |
| `$02B8` | `sub_H068_000002B8` | parziale | h068.c:73 |
| `$0340` | `sub_H068_00000340` | parziale | h068.c:92 |
| `$0748` | `sub_H068_00000748` | parziale | h068.c:180 |
| `$082A` | `sub_H068_0000082A` | parziale | h068.c:200 |
| `$0890` | `sub_H068_00000890` | parziale | h068.c:214 |
| `$08E2` | `sub_H068_000008E2` | parziale | h068.c:227 |
| `$0932` | `sub_H068_00000932` | parziale | h068.c:243 |
| `$0A1A` | `sub_H068_00000A1A` | parziale | h068.c:278 |
| `$0B2C` | `sub_H068_00000B2C` | parziale | h068.c:308 |
| `$0C0E` | `Exploration_CommandMenu` | verificato | h068.c:491 |
| `$122E` | `Exploration_MoveOrDoor` | parziale | h068.c:577 |

### H069

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `module_init_H069` | parziale | h069.c:8 |
| `$0012` | `sub_H069_00000012` | parziale | h069.c:14 |
| `$00A8` | `sub_H069_000000A8` | parziale | h069.c:32 |

### H070

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0272` | `module_init_H070` | parziale | h070.c:31 |
| `$0280` | `sub_H070_00000280` | parziale | h070.c:51 |
| `$0558` | `trampoline_H070_076E` | parziale | h070.c:113 |
| `$0778` | `sub_H070_00000778` | parziale | h070.c:160 |
| `$0B9E` | `sub_H070_00000B9E` | parziale | h070.c:285 |
| `$0DE0` | `sub_H070_00000DE0` | parziale | h070.c:375 |
| `$0E94` | `sub_H070_00000E94` | parziale | h070.c:395 |
| `$0F8A` | `sub_H070_00000F8A` | parziale | h070.c:439 |
| `$1136` | `sub_H070_00001136` | parziale | h070.c:489 |
| `$152E` | `sub_H070_0000152E` | parziale | h070.c:587 |
| `$165C` | `sub_H070_0000165C` | parziale | h070.c:629 |
| `$18BE` | `sub_H070_000018BE` | parziale | h070.c:685 |
| `$1958` | `sub_H070_00001958` | parziale | h070.c:711 |

### H071

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$011C` | `module_init_H071` | parziale | h071.c:18 |
| `$012A` | `sub_H071_0000012A` | parziale | h071.c:103 |
| `$047C` | `sub_H071_0000047C` | parziale | h071.c:24 |
| `$0572` | `sub_H071_00000572` | parziale | h071.c:176 |
| `$092C` | `sub_H071_0000092C` | parziale | h071.c:247 |

### H072

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0304` | `module_init_H072` | parziale | h072.c:29 |
| `$0312` | `sub_H072_00000312` | parziale | h072.c:36 |
| `$036C` | `sub_H072_0000036C` | parziale | h072.c:52 |
| `$050A` | `sub_H072_0000050A` | parziale | h072.c:94 |
| `$05AA` | `sub_H072_000005AA` | parziale | h072.c:111 |
| `$06BC` | `trampoline_H072_08EE` | parziale | h072.c:141 |
| `$0910` | `sub_H072_00000910` | parziale | h072.c:200 |
| `$0C04` | `sub_H072_00000C04` | parziale | h072.c:280 |
| `$0D24` | `sub_H072_00000D24` | parziale | h072.c:313 |
| `$0E0A` | `sub_H072_00000E0A` | parziale | h072.c:341 |
| `$0EBE` | `sub_H072_00000EBE` | parziale | h072.c:360 |
| `$120C` | `sub_H072_0000120C` | parziale | h072.c:431 |

### H073

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `module_init_H073` | parziale | h073.c:6 |
| `$0012` | `sub_H073_00000012` | parziale | h073.c:296 |
| `$05AE` | `sub_H073_000005AE` | parziale | h073.c:411 |
| `$09BA` | `sub_H073_000009BA` | parziale | h073.c:12 |
| `$0BA8` | `sub_H073_00000BA8` | parziale | h073.c:70 |
| `$0FC8` | `sub_H073_00000FC8` | parziale | h073.c:178 |
| `$1294` | `trampoline_H073_12A4` | parziale | h073.c:150 |
| `$12AE` | `trampoline_H073_12BE` | parziale | h073.c:157 |
| `$12C8` | `trampoline_H073_12D8` | parziale | h073.c:164 |
| `$130A` | `sub_H073_0000130A` | parziale | h073.c:171 |

### H074

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `trampoline_H074_04B0` | parziale | h074_path.c:6 |
| `$0010` | `trampoline_H074_0092` | parziale |  |
| `$009A` | `sub_H074_0000009A` | parziale |  |
| `$0450` | `sub_H074_00000450` | parziale |  |

### H075

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `trampoline_H075_0184` | parziale | h075_file.c:4 |
| `$00FE` | `sub_H075_000000FE` | parziale |  |
| `$0124` | `sub_H075_00000124` | parziale |  |
| `$0132` | `sub_H075_00000132` | parziale |  |

### H076

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `(senza scheda)` | - | h076.c:4 |

### H077

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `module_init_H077` | parziale | h077.c:7 |
| `$0012` | `trampoline_H077_004C` | parziale | h077.c:12 |
| `$0056` | `sub_H077_00000056` | parziale | h077.c:186 |
| `$01CC` | `sub_H077_000001CC` | parziale | h077.c:24 |
| `$0242` | `sub_H077_00000242` | parziale | h077.c:41 |
| `$0378` | `sub_H077_00000378` | parziale | h077.c:86 |
| `$0508` | `sub_H077_00000508` | parziale | h077.c:129 |
| `$08AC` | `sub_H077_000008AC` | parziale | h077.c:220 |

### H078

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `(senza scheda)` | - | h078.c:4 |

### H079

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `sub_H079_00000004` | parziale | h079.c:4 |
| `$0006` | `wrapper_AddIntServer` | parziale | h079.c:14 |
| `$002E` | `wrapper_Disable` | parziale | h079.c:20 |
| `$0036` | `wrapper_Enable` | parziale | h079.c:26 |
| `$004E` | `wrapper_RemIntServer` | parziale | h079.c:32 |

### H080

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0058` | `(senza scheda)` | - | h080.c:4 |

### H081

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `(senza scheda)` | - | h081.c:4 |

### H082

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H082_00000008` | parziale | h082.c:5 |
| `$0074` | `wrapper_FreeCprList` | parziale | h082.c:16 |

### H083

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H083_00000008` | parziale | h083.c:5 |

### H084

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H084_00000008` | parziale | h084.c:5 |
| `$002A` | `wrapper_GetPrefs` | parziale | h084.c:16 |

### H085

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0664` | `module_init_H085` | parziale | h085.c:26 |
| `$0672` | `trampoline_H085_078A` | parziale | h085.c:122 |
| `$07B6` | `sub_H085_000007B6` | parziale | h085.c:239 |
| `$0A1A` | `sub_H085_00000A1A` | parziale | h085.c:64 |
| `$0AB2` | `sub_H085_00000AB2` | parziale | h085.c:307 |
| `$0BB2` | `trampoline_H085_0D50` | parziale | h085.c:1115 |
| `$0BC0` | `sub_H085_00000BC0` | parziale | h085.c:1058 |
| `$0C04` | `trampoline_H085_0C58` | parziale | h085.c:1068 |
| `$0C62` | `sub_H085_00000C62` | parziale | h085.c:1084 |
| `$1234` | `sub_H085_00001234` | parziale | h085.c:1595 |
| `$1306` | `sub_H085_00001306` | parziale | h085.c:1623 |
| `$15FE` | `(senza scheda)` | - | h085.c:1020 |
| `$172A` | `(byte non classificati)` | - | h085.c:1242 |
| `$1A6C` | `sub_H085_00001A6C` | parziale | h085.c:1359 |
| `$1C60` | `(senza scheda)` | - | h085.c:327 |
| `$1C86` | `(senza scheda)` | - | h085.c:333 |
| `$1CB8` | `(senza scheda)` | - | h085.c:51 |
| `$1D3C` | `(senza scheda)` | - | h085.c:340 |
| `$1D78` | `(senza scheda)` | - | h085.c:346 |
| `$1DA6` | `(senza scheda)` | - | h085.c:352 |
| `$1DE4` | `(senza scheda)` | - | h085.c:359 |
| `$1EBA` | `(senza scheda)` | - | h085.c:160 |
| `$1FFA` | `(senza scheda)` | - | h085.c:381 |
| `$2090` | `(senza scheda)` | - | h085.c:400 |
| `$20DE` | `(senza scheda)` | - | h085.c:408 |
| `$2144` | `(senza scheda)` | - | h085.c:417 |
| `$2172` | `(senza scheda)` | - | h085.c:423 |
| `$21C8` | `(senza scheda)` | - | h085.c:436 |
| `$2338` | `(senza scheda)` | - | h085.c:1404 |
| `$23B8` | `(senza scheda)` | - | h085.c:477 |
| `$23E6` | `(senza scheda)` | - | h085.c:483 |
| `$2414` | `(senza scheda)` | - | h085.c:489 |
| `$24C6` | `(senza scheda)` | - | h085.c:511 |
| `$25B8` | `(senza scheda)` | - | h085.c:532 |
| `$25FA` | `(senza scheda)` | - | h085.c:539 |
| `$2628` | `(senza scheda)` | - | h085.c:545 |
| `$2692` | `(senza scheda)` | - | h085.c:555 |
| `$26C0` | `(senza scheda)` | - | h085.c:1435 |
| `$2BD4` | `(senza scheda)` | - | h085.c:195 |
| `$2DBA` | `(senza scheda)` | - | h085.c:561 |
| `$2DFA` | `(senza scheda)` | - | h085.c:569 |
| `$2E28` | `(senza scheda)` | - | h085.c:85 |
| `$2E40` | `(senza scheda)` | - | h085.c:575 |
| `$2E70` | `(senza scheda)` | - | h085.c:581 |
| `$2EC4` | `(senza scheda)` | - | h085.c:591 |
| `$2FCE` | `(senza scheda)` | - | h085.c:625 |
| `$2FFC` | `(senza scheda)` | - | h085.c:631 |
| `$302A` | `sub_H085_0000302A` | parziale | h085.c:638 |
| `$318A` | `(senza scheda)` | - | h085.c:667 |
| `$31B4` | `(senza scheda)` | - | h085.c:1718 |
| `$3224` | `(senza scheda)` | - | h085.c:673 |
| `$3252` | `(senza scheda)` | - | h085.c:679 |
| `$3298` | `(senza scheda)` | - | h085.c:57 |
| `$331E` | `(senza scheda)` | - | h085.c:688 |
| `$33A8` | `(senza scheda)` | - | h085.c:1733 |
| `$3402` | `(senza scheda)` | - | h085.c:703 |
| `$3430` | `(senza scheda)` | - | h085.c:897 |
| `$3482` | `(senza scheda)` | - | h085.c:717 |
| `$34B0` | `(senza scheda)` | - | h085.c:723 |
| `$34F0` | `(senza scheda)` | - | h085.c:730 |
| `$3552` | `(senza scheda)` | - | h085.c:92 |
| `$363E` | `(senza scheda)` | - | h085.c:1322 |
| `$36B8` | `(senza scheda)` | - | h085.c:744 |
| `$3758` | `(senza scheda)` | - | h085.c:1541 |
| `$37E2` | `(senza scheda)` | - | h085.c:761 |
| `$38AA` | `(senza scheda)` | - | h085.c:1342 |
| `$3936` | `(senza scheda)` | - | h085.c:1558 |
| `$3A5E` | `(senza scheda)` | - | h085.c:782 |
| `$3C06` | `(senza scheda)` | - | h085.c:826 |
| `$3D0A` | `(senza scheda)` | - | h085.c:849 |
| `$3D46` | `(senza scheda)` | - | h085.c:855 |
| `$3D74` | `(senza scheda)` | - | h085.c:861 |
| `$3DA0` | `(senza scheda)` | - | h085.c:867 |
| `$3DCC` | `(senza scheda)` | - | h085.c:873 |
| `$3DF8` | `(senza scheda)` | - | h085.c:903 |
| `$3E4A` | `(senza scheda)` | - | h085.c:879 |
| `$3E78` | `(senza scheda)` | - | h085.c:885 |
| `$3EA6` | `(senza scheda)` | - | h085.c:891 |
| `$3ED4` | `(senza scheda)` | - | h085.c:928 |
| `$3EE2` | `sub_H085_00003EE2` | parziale |  |
| `$431A` | `(byte non classificati)` | - | h085.c:1791 |
| `$442E` | `(byte non classificati)` | - | h085.c:1815 |
| `$4628` | `(byte non classificati)` | - | h085.c:1854 |
| `$4798` | `(byte non classificati)` | - | h085.c:1892 |
| `$4A02` | `(byte non classificati)` | - | h085.c:1937 |

### H086

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H086_0822` | parziale | h086.c:12 |
| `$000C` | `sub_H086_0000000C` | parziale | h086.c:18 |
| `$0068` | `sub_H086_00000068` | parziale | h086.c:37 |
| `$00C0` | `sub_H086_000000C0` | parziale | h086.c:52 |
| `$015C` | `sub_H086_0000015C` | parziale | h086.c:77 |
| `$01F8` | `sub_H086_000001F8` | parziale | h086.c:97 |
| `$022E` | `sub_H086_0000022E` | parziale | h086.c:111 |
| `$03F2` | `trampoline_H086_049E` | parziale | h086.c:174 |
| `$04BA` | `sub_H086_000004BA` | parziale | h086.c:216 |
| `$0578` | `sub_H086_00000578` | parziale | h086.c:238 |
| `$06BC` | `(senza scheda)` | - | h086.c:281 |
| `$06D6` | `sub_H086_000006D6` | parziale | h086.c:287 |
| `$0714` | `sub_H086_00000714` | parziale | h086.c:300 |
| `$07C0` | `sub_H086_000007C0` | parziale | h086.c:317 |

### H087

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H087_0468` | parziale | h087.c:6 |
| `$000C` | `trampoline_H087_0028` | parziale | h087.c:12 |
| `$009C` | `sub_H087_0000009C` | parziale | h087.c:39 |
| `$0166` | `Read_ILBM_BODY` | verificato | h087.c:65 |

### H088

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H088_0142` | parziale | h088.c:4 |
| `$000C` | `UnPackRow_ByteRun1` | verificato | h088.c:10 |

### H089

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `(senza scheda)` | - | h089.c:4 |

### H090

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `sub_H090_00000004` | parziale | h090.c:4 |
| `$0018` | `wrapper_CloseDevice` | parziale | h090.c:14 |
| `$002A` | `wrapper_OpenDevice` | parziale | h090.c:20 |

### H091

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `(senza scheda)` | - | h091.c:4 |

### H092

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `sub_H092_00000004` | parziale | h092.c:4 |
| `$007A` | `sub_H092_0000007A` | parziale | h092.c:10 |

### H093

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `trampoline_H093_0034` | parziale | h093.c:4 |

### H094

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0004` | `wrapper_Cause` | parziale | h094.c:9 |
| `$0006` | `Audio_VBlankServer` | verificato | h094.c:583 |
| `$0016` | `Audio_SoftInterrupt` | verificato | h094.c:567 |
| `$003A` | `sub_H094_0000003A` | parziale | h094.c:360 |
| `$0108` | `sub_H094_00000108` | parziale | h094.c:325 |
| `$0188` | `sub_H094_00000188` | parziale | h094.c:222 |
| `$01BE` | `sub_H094_000001BE` | parziale | h094.c:169 |
| `$0288` | `sub_H094_00000288` | parziale | h094.c:85 |
| `$0390` | `sub_H094_00000390` | parziale | h094.c:237 |
| `$04A4` | `sub_H094_000004A4` | parziale | h094.c:415 |
| `$0738` | `sub_H094_00000738` | parziale | h094.c:66 |

### H095

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0384` | `module_init_H095` | parziale | h095.c:23 |
| `$0392` | `sub_H095_00000392` | parziale | h095.c:62 |
| `$0422` | `sub_H095_00000422` | parziale | h095.c:78 |
| `$06F2` | `trampoline_H095_07B6` | parziale | h095.c:151 |
| `$0700` | `sub_H095_00000700` | parziale | h095.c:130 |
| `$083A` | `trampoline_H095_0F9C` | parziale | h095.c:365 |
| `$0848` | `sub_H095_00000848` | parziale | h095.c:165 |
| `$0912` | `sub_H095_00000912` | parziale | h095.c:188 |
| `$09A4` | `sub_H095_000009A4` | parziale | h095.c:201 |
| `$0CD4` | `sub_H095_00000CD4` | parziale | h095.c:286 |
| `$1076` | `sub_H095_00001076` | parziale | h095.c:397 |
| `$121A` | `trampoline_H095_13F0` | parziale | h095.c:447 |
| `$1228` | `sub_H095_00001228` | parziale | h095.c:425 |
| `$1576` | `sub_H095_00001576` | parziale | h095.c:477 |
| `$1630` | `sub_H095_00001630` | parziale | h095.c:490 |
| `$1790` | `sub_H095_00001790` | parziale | h095.c:528 |
| `$18CC` | `sub_H095_000018CC` | parziale | h095.c:560 |
| `$1914` | `sub_H095_00001914` | parziale | h095.c:573 |
| `$1A7A` | `sub_H095_00001A7A` | parziale | h095.c:604 |
| `$1FC2` | `sub_H095_00001FC2` | parziale | h095.c:738 |
| `$2496` | `sub_H095_00002496` | parziale | h095.c:850 |

### H096

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$01F2` | `module_init_H096` | parziale | h096.c:32 |
| `$0200` | `sub_H096_00000200` | parziale | h096.c:73 |
| `$023E` | `sub_H096_0000023E` | parziale | h096.c:85 |
| `$02CE` | `sub_H096_000002CE` | parziale | h096.c:108 |
| `$0434` | `sub_H096_00000434` | parziale | h096.c:154 |
| `$0530` | `trampoline_H096_057E` | parziale | h096.c:177 |
| `$08B2` | `sub_H096_000008B2` | parziale | h096.c:262 |
| `$099C` | `sub_H096_0000099C` | parziale | h096.c:288 |
| `$0C3C` | `sub_H096_00000C3C` | parziale | h096.c:352 |
| `$10FA` | `sub_H096_000010FA` | parziale | h096.c:465 |
| `$11D4` | `sub_H096_000011D4` | parziale | h096.c:495 |
| `$1340` | `sub_H096_00001340` | parziale | h096.c:541 |
| `$1562` | `trampoline_H096_1600` | parziale | h096.c:599 |
| `$160A` | `sub_H096_0000160A` | parziale | h096.c:682 |
| `$1B04` | `sub_H096_00001B04` | parziale | h096.c:655 |
| `$1BE0` | `sub_H096_00001BE0` | parziale | h096.c:751 |
| `$20E6` | `sub_H096_000020E6` | parziale | h096.c:875 |
| `$2182` | `sub_H096_00002182` | parziale | h096.c:894 |
| `$251C` | `sub_H096_0000251C` | parziale | h096.c:984 |
| `$25DA` | `sub_H096_000025DA` | parziale | h096.c:1011 |
| `$284C` | `sub_H096_0000284C` | parziale | h096.c:1071 |
| `$2A6C` | `(senza scheda)` | - | h096.c:1152 |
| `$3100` | `sub_H096_00003100` | parziale | h096.c:1298 |
| `$3358` | `sub_H096_00003358` | parziale | h096.c:1366 |
| `$3492` | `sub_H096_00003492` | parziale | h096.c:1396 |
| `$37C2` | `sub_H096_000037C2` | parziale | h096.c:38 |
| `$3852` | `sub_H096_00003852` | parziale | h096.c:1465 |
| `$38DC` | `sub_H096_000038DC` | parziale | h096.c:1486 |
| `$39D0` | `sub_H096_000039D0` | parziale | h096.c:1513 |
| `$3C48` | `sub_H096_00003C48` | parziale | h096.c:1571 |
| `$3DBA` | `sub_H096_00003DBA` | parziale | h096.c:1608 |
| `$4448` | `trampoline_H096_46E4` | parziale | h096.c:1816 |
| `$4456` | `sub_H096_00004456` | parziale | h096.c:1761 |
| `$4530` | `sub_H096_00004530` | parziale | h096.c:1780 |
| `$4B86` | `sub_H096_00004B86` | parziale | h096.c:1941 |
| `$4DE8` | `trampoline_H096_4DF8` | parziale | h096.c:2011 |

### H097

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$00A2` | `module_init_H097` | parziale | h097.c:27 |
| `$00B0` | `sub_H097_000000B0` | parziale | h097.c:46 |
| `$0244` | `sub_H097_00000244` | parziale | h097.c:98 |
| `$02B2` | `sub_H097_000002B2` | parziale | h097.c:111 |
| `$043A` | `sub_H097_0000043A` | parziale | h097.c:155 |
| `$0620` | `trampoline_H097_075C` | parziale | h097.c:233 |
| `$062E` | `trampoline_H097_0650` | parziale | h097.c:209 |
| `$0890` | `sub_H097_00000890` | parziale | h097.c:270 |
| `$0A04` | `sub_H097_00000A04` | parziale | h097.c:311 |
| `$0A88` | `sub_H097_00000A88` | parziale | h097.c:330 |
| `$0C14` | `sub_H097_00000C14` | parziale | h097.c:380 |
| `$11EE` | `sub_H097_000011EE` | parziale | h097.c:518 |
| `$142C` | `sub_H097_0000142C` | parziale | h097.c:569 |
| `$18D2` | `sub_H097_000018D2` | parziale | h097.c:671 |
| `$1D68` | `sub_H097_00001D68` | parziale | h097.c:791 |

### H098

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0018` | `trampoline_H098_0346` | parziale | h098.c:17 |
| `$007C` | `sub_H098_0000007C` | parziale | h098.c:23 |
| `$00D0` | `sub_H098_000000D0` | parziale | h098.c:37 |
| `$0276` | `sub_H098_00000276` | parziale | h098.c:52 |

### H099

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$010E` | `trampoline_H099_03A0` | parziale | h099.c:4 |
| `$01B0` | `trampoline_H099_01CE` | parziale | h099.c:9 |

### H100

| Offset | Nome nell'analisi | Analisi | Port |
| --- | --- | --- | --- |
| `$0008` | `sub_H100_00000008` | parziale | h100_custom.c:7 |

