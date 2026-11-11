#!/usr/bin/env python3
"""Assemble the self-contained source and restore the original RELOC32 ordering."""
from pathlib import Path
import argparse,hashlib,json,subprocess,shutil,sys
from hunk import parse,canonicalize,relocations
EXPECTED_SHA256='b02db23e0df6decfb2807fa322d302371c22d5079130a2a335060eebcab978a3'
FLAGS=['-m68000','-no-opt','-spaces','-Fhunkexe','-kick1hunks','-nosym','-quiet']

def main():
 parser=argparse.ArgumentParser();parser.add_argument('--vasm',default='vasmm68k_mot',help='path to vasmm68k_mot');parser.add_argument('--allow-modified',action='store_true',help='allow payload changes; section sizes and relocation positions must remain unchanged');args=parser.parse_args()
 root=Path(__file__).resolve().parent.parent;build=root/'build';build.mkdir(exist_ok=True)
 executable=shutil.which(args.vasm)
 if not executable:parser.error('vasmm68k_mot not found; install it or pass --vasm /absolute/path/vasmm68k_mot')
 command=[executable,*FLAGS,'-o',str(build/'game.vasm'),'game.asm']
 subprocess.run(command,cwd=root,check=True)
 rebuilt=parse(build/'game.vasm');layout=json.loads((root/'layout.json').read_text());data=canonicalize(rebuilt,layout);(build/'game').write_bytes(data)
 sha=hashlib.sha256(data).hexdigest();raw=(build/'game.vasm').read_bytes()
 report={'assembler_flags':FLAGS,'assembler_sha256':hashlib.sha256(Path(executable).read_bytes()).hexdigest(),'hunks':len(rebuilt['hunks']),'payload_bytes':sum(h['size'] for h in rebuilt['hunks']),'relocation_positions':sum(len(relocations(h)) for h in rebuilt['hunks']),'raw_assembler_sha256':hashlib.sha256(raw).hexdigest(),'canonical_sha256':sha,'expected_original_sha256':EXPECTED_SHA256,'exact_original_match':sha==EXPECTED_SHA256,'size_bytes':len(data),'source_stats':json.loads((root/'source_stats.json').read_text())}
 (build/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
 print('Hunks:',report['hunks'],'Payload bytes:',report['payload_bytes'],'Relocations:',report['relocation_positions'])
 print('SHA-256:',sha)
 print('Exact match with original:',report['exact_original_match'])
 if not report['exact_original_match'] and not args.allow_modified:raise SystemExit('Build differs from the reference. Inspect build/verification.json; use --allow-modified only for intentional fixed-layout edits.')

if __name__=='__main__':main()
