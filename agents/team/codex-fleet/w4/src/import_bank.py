#!/usr/bin/env python3
import pathlib,re,sys,itertools,collections
sys.path.insert(0,'src');import window
root=pathlib.Path('/path/to/repo/agents/team/d4-evolve/codex/work')
base=pathlib.Path('sk/bank');base.mkdir(exist_ok=True)
seen=set();meta=[]
for fn in root.glob('permutation*exact.txt'):
 text=fn.read_text();chunks=re.split(r'(?=^# prog)',text,flags=re.M)
 for ii,ch in enumerate(chunks):
  if not ch.strip():continue
  tmp=base/'temp.s';tmp.write_text(ch);p,o,n=window.read(tmp);ps=list(itertools.permutations(range(5)));traces=[window.run(p,o,ty,n)[1] for ty in ps]
  cs=[i for i,(op,_,_) in enumerate(p) if op=='cmp'];cols=[];hist=[]
  for i in cs:
   _,a,b=p[i];ca=''.join(str(tr[i][0][a]) for tr in traces);cb=''.join(str(tr[i][0][b]) for tr in traces);cols.append('='+ca+':='+cb)
   hist.append(tuple(tr[i+1][1] for tr in traces))
  key=tuple(cols)
  if key in seen:continue
  seen.add(key)
  classes=len(set(zip(*hist)))
  tag=f'b{len(meta):03}';(base/(tag+'.s')).write_text(ch);(base/(tag+'.txt')).write_text('\n'.join(cols)+'\n')
  meta.append({'tag':tag,'source':fn.name,'chunk':ii,'header':ch.splitlines()[0],'classes':classes})
print('unique',len(meta),'classes',collections.Counter(m['classes'] for m in meta));(base/'meta.json').write_text(__import__('json').dumps(meta,indent=2));tmp.unlink()
