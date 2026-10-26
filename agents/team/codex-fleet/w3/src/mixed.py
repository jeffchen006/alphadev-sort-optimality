"""Generate Ford-Johnson trees whose third comparison uses minima or maxima
as a function of the first two comparison outcomes."""
import itertools,sys,concurrent.futures,subprocess,time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from trees import trees,PS
from batch_dag import key
P=list(itertools.permutations(range(5)))
def logs(x,tree,mask,pad='last',orient='actual'):
 history=2*int(x[0]<x[1])+int(x[2]<x[3]);reverse=(mask>>history)&1
 xx=tuple(-v if reverse else v for v in x)
 out=[(x[0],x[1]),(x[2],x[3])]
 a,b=(0,1) if xx[0]<xx[1] else (1,0);c,d=(2,3) if xx[2]<xx[3] else (3,2)
 A,B=b,d
 if orient.endswith('reflected') and reverse:A,B=B,A
 out.append((x[A],x[B]))
 if xx[b]>xx[d]:a,b,c,d=c,d,a,b
 lab=[a,b,c,d,4];last=None
 while len(out)<7:
  if tree is None:
   if pad=='last':ia,ib=last
   elif pad=='eq':ia=ib=last[0]
   else:ia,ib=divmod(int(pad),5)
  else:ia,ib=tree[:2]
  last=ia,ib;lt=xx[lab[ia]]<xx[lab[ib]]
  A,B=ia,ib
  if orient.startswith('phase'):
   if B==2 or B==4 and A!=2:A,B=B,A
  elif B==4 or B==2:A,B=B,A
  if orient.endswith('reflected') and reverse:A,B=B,A
  out.append((x[lab[A]],x[lab[B]]))
  if tree is not None:tree=tree[2 if lt else 3]
 return out

def generate():
 Path('sk/mixed').mkdir(exist_ok=True)
 ts=trees(tuple(range(15)),4);seen=set();files=[]
 for mask in [6,8,10,12]:
  for ti,tr in enumerate(ts):
   for orient in ['actual','reflected']:
    for pad in ['last','eq']+[str(5*a+b) for a,b in itertools.combinations(range(5),2)]:
     logsall=[logs(x,tr,mask,pad,orient) for x in P]
     sigs=[tuple((a>b)-(a<b) for a,b in row) for row in logsall]
     assert len(set(sigs))==120
     fn=Path(f'sk/mixed/m{mask}_t{ti}_{orient}_{pad}.txt')
     with fn.open('w') as f:
      f.write('# mixed min/max third comparison\n')
      for j in range(7):f.write('='+''.join(str(row[j][0]) for row in logsall)+':='+''.join(str(row[j][1]) for row in logsall)+'\n')
     sig=key(fn)
     if sig in seen:fn.unlink();continue
     seen.add(sig);files.append(fn)
 return files
if __name__=='__main__':
 files=generate();print('unique mixed exact skeletons',len(files),flush=True);start=time.time()
 files.sort(key=lambda p:('last' not in p.name and 'eq' not in p.name,p.name))
 def run(fn):
  log=Path('logs')/(fn.stem+'_k31.mixed')
  with log.open('w') as out:p=subprocess.run(['nice','-n','10','timeout','120','src/dagx',str(fn),'31','1','1500000'],stdout=out,stderr=subprocess.STDOUT)
  lines=log.read_text().splitlines();return fn.name,p.returncode,lines[-1] if lines else 'EMPTY'
 with concurrent.futures.ThreadPoolExecutor(max_workers=4) as ex:
  for fn,rc,res in ex.map(run,files):print(f'{time.time()-start:.1f}s {fn} rc={rc} {res}',flush=True)
