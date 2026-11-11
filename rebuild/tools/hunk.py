"""Strict reader for HUNK_HEADER executables used by this rebuild."""
from pathlib import Path
import struct

def parse(path):
 blob=Path(path).read_bytes();p=0
 def u():
  nonlocal p
  if p+4>len(blob):raise ValueError('truncated longword')
  v=struct.unpack_from('>I',blob,p)[0];p+=4;return v
 def raw(n):
  nonlocal p
  if p+n>len(blob):raise ValueError('truncated payload')
  v=blob[p:p+n];p+=n;return v
 if u()!=1011:raise ValueError('not HUNK_HEADER')
 names=[]
 while (n:=u()):names.append(raw(n*4))
 table,first,last=u(),u(),u();alloc=[u() for _ in range(last-first+1)]
 hunks=[];current=None;extras=[]
 while p<len(blob):
  full=u();kind=full&0x3fffffff
  if kind in [1001,1002,1003]:
   n=u();current={'index':first+len(hunks),'type':kind,'flags':full&0xc0000000,'size':4*n,'data':raw(4*n) if kind!=1003 else b'\0'*(4*n),'relocations':[]};hunks.append(current)
  elif kind==1004:
   while (n:=u()):
    target=u();offsets=[u() for _ in range(n)];current['relocations'].append({'target':target,'offsets':offsets})
  elif kind in [1000,1009]:extras.append(kind);raw(4*u())
  elif kind==1008:
   extras.append(kind)
   while (n:=u()):raw(n*4);u()
  elif kind==1010:current=None
  else:raise ValueError(f'unsupported record {kind} at {p-4:#x}')
 if len(hunks)!=last-first+1:raise ValueError('hunk count mismatch')
 return {'names':names,'table_size':table,'first':first,'last':last,'allocation_words':alloc,'hunks':hunks,'extra_record_types':extras}

def relocations(h):
 result={}
 for g in h['relocations']:
  for o in g['offsets']:
   if o in result:raise ValueError('duplicate relocation')
   if o<0 or o+4>len(h['data']):raise ValueError('relocation outside payload')
   result[o]=g['target']
 return result

def canonicalize(rebuilt,layout):
 """Serialize rebuilt bytes using the original record grouping; never patch payloads."""
 if rebuilt['names'] or rebuilt['extra_record_types']:raise ValueError('unexpected names/debug/symbol records')
 if any(rebuilt[k]!=layout[k] for k in ['table_size','first','last','allocation_words']):raise ValueError('header mismatch')
 out=bytearray()
 def u(x):out.extend(struct.pack('>I',x))
 u(1011);u(0);u(layout['table_size']);u(layout['first']);u(layout['last'])
 for a in layout['allocation_words']:u(a)
 for built,orig in zip(rebuilt['hunks'],layout['hunks']):
  if built['type']!=orig['type'] or built['size']!=orig['size'] or built['flags']!=orig.get('flags',0):raise ValueError('section type/size mismatch')
  expected={off:g['target'] for g in orig['relocations'] for off in g['offsets']}
  if relocations(built)!=expected:raise ValueError('relocation mismatch')
  u(orig['type']|orig.get('flags',0));u(orig['size']//4);out.extend(built['data'])
  if orig['relocations']:
   u(1004)
   for group in orig['relocations']:
    u(len(group['offsets']));u(group['target'])
    for off in group['offsets']:u(off)
   u(0)
  u(1010)
 return bytes(out)
