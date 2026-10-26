from pathlib import Path
p=Path('round6/src/mem_to_out.py');s=p.read_text().replace('def convert(source,target,evaluate=True):','def convert(source,target,evaluate=True,clean=False):')
s=s.replace(' registers={};loaded=set();stored=set();core=[];snap=[];nextreg=5', ''' if clean:
  live={f'P{i}' for i in range(5)};flags=False;kept=[]
  for op,d,s in reversed(lines):
   if op=='cmp':
    if not flags:continue
    flags=False;live.update((d,s))
   elif d not in live:continue
   elif op=='mov':live.remove(d);live.add(s)
   else:live.add(s);flags=True
   kept.append((op,d,s))
  lines=list(reversed(kept))
 registers={};loaded=set();stored=set();core=[];snap=[];nextreg=5''')
p.write_text(s)
p=Path('round6/src/mine_near.py');s=p.read_text().replace("rows=[];classes={};rawmap={};skipped=0","clean='--clean' in sys.argv\nrows=[];classes={};rawmap={};skipped=0")
s=s.replace("source.stem+'_out.s'","source.stem+('_clean_out.s' if clean else '_out.s')").replace('convert(source,target,evaluate=False)','convert(source,target,evaluate=False,clean=clean)')
s=s.replace("result=dict(scanned=", "result=dict(clean=clean,scanned=")
s=s.replace("Path('round6/artifacts/near_inventory.json')", "Path('round6/artifacts/near_inventory_clean.json' if clean else 'round6/artifacts/near_inventory.json')")
s=s.replace("Path('round6/artifacts/near_representatives.txt')", "Path('round6/artifacts/near_representatives_clean.txt' if clean else 'round6/artifacts/near_representatives.txt')")
p.write_text(s)
