from pathlib import Path
import re,concurrent.futures,subprocess,time,collections
cand=[];cnt=collections.Counter()
for p in Path('logs').glob('*.phase'):
 s=p.read_text()
 if 'RESULT LIMIT' not in s:continue
 mask=int(re.search(r'^m(\d+)_',p.name)[1]);cnt[mask]+=1
 if mask:
  stem=p.name.replace('_k31.phase','');cand.append((stem,mask))
print('limited by third-comparison rule',dict(cnt),flush=True)
# Extend four different shape/rule pairs. Prioritize the useful repeated-comparison padding.
cand.sort(key=lambda it:('last' not in it[0],'eq' not in it[0],it[0]))
jobs=[];seen=set()
for stem,mask in cand:
 signature=re.match(r'(m\d+_t\d+_phase_(?:actual|reflected))_',stem)[1]
 if signature in seen:continue
 seen.add(signature);jobs.append(stem)
 if len(jobs)==4:break
print('selected',jobs,flush=True);start=time.time()
def run(stem):
 log=Path(f'logs/{stem}_final_k31.phase')
 with log.open('w') as f:p=subprocess.run(['nice','-n','10','timeout','180','src/dagx',f'sk/phase/{stem}.txt','31','1','100000000'],stdout=f,stderr=subprocess.STDOUT)
 ls=log.read_text().splitlines();return stem,p.returncode,ls[-1] if ls else 'EMPTY'
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as ex:
 for stem,rc,s in ex.map(run,jobs):print(f'{time.time()-start:.1f}s {stem} rc={rc} {s}',flush=True)
