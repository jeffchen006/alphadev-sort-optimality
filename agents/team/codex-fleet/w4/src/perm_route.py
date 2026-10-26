#!/usr/bin/env python3
import sys,itertools,pathlib,os,subprocess,json,concurrent.futures as cf
sys.path.insert(0,'src');import window
perms=list(itertools.permutations(range(5)));p,o,n=window.read('candidates/seed33.s')
base=pathlib.Path('sk/permutations');base.mkdir(exist_ok=True)
lines=list(dict.fromkeys(pathlib.Path('logs/perm_merge28_paths.txt').read_text().splitlines()))
def build(ti,line):
 data=list(map(int,line.split()));prog=p[:15];mapping=['P0','P1','P2','S10','P4'];tmp=300
 for j in range(4):
  a,b,pi=data[3*j:3*j+3];perm=perms[pi];prog.append(('cmp',mapping[a],mapping[b]));seen=set()
  for i in range(5):
   if perm[i]==i or i in seen:continue
   temp='S'+str(tmp);tmp+=1;prog.append(('mov',temp,mapping[i]));k=i
   while perm[k]!=i:
    prog.append(('cmovg',mapping[k],mapping[perm[k]]));seen.add(k);k=perm[k]
   prog.append(('cmovg',mapping[k],temp));seen.add(k)
 names=n+['S'+str(i) for i in range(300,tmp)]
 tr0=window.run(prog,{},(0,1,2,3,4),names)[1][-1][0]
 outs={len(prog):[(tr0[r],r) for r in mapping]}
 fn=base/f'p{ti:03}.s';window.write(fn,prog,outs)
 traces=[window.run(prog,outs,ty,names)[1] for ty in perms];cols=[]
 for i,(op,a,b) in enumerate(prog[15:],15):
  if op=='cmp':cols.append('='+''.join(str(tr[i][0][a]) for tr in traces)+':='+''.join(str(tr[i][0][b]) for tr in traces))
 (base/f'p{ti:03}.txt').write_text('\n'.join(cols)+'\n')
 return ti,len(prog)
for ti,line in enumerate(lines):build(ti,line)
K=int(sys.argv[1]) if len(sys.argv)>1 else 16

def job(ti):
 tag=f'p{ti:03}_k{K}';env=dict(os.environ,INITIAL='sk/merge/initial.txt',HISTORY='sk/merge/history.txt')
 r=subprocess.run(['./merge_dag',str(base/f'p{ti:03}.txt'),str(K),'1','100000000'],env=env,capture_output=True,text=True)
 pathlib.Path('logs/perm_'+tag+'.log').write_text(r.stdout+r.stderr);lines=r.stdout.splitlines()
 if any(l.startswith('SOLUTION') for l in lines):
  raw='# n=5 model=out iset=I1 source=w4-permutation-routing\n'+'\n'.join(f'{op} {a}, {b}' for op,a,b in p[:15])+'\n'+'\n'.join(lines[next(i for i,l in enumerate(lines) if l.startswith('SOLUTION'))+1:lines.index('END')])+'\n'
  import re;mapping={}
  def sub(m):
   r=m.group(0)
   if r not in mapping:mapping[r]='S'+str(len(mapping))
   return mapping[r]
  raw=re.sub(r'S\d+',sub,raw);fn=pathlib.Path('candidates/perm_'+tag+'.s');fn.write_text(raw)
  jr=subprocess.run(['python3','/path/to/repo/shared/judge.py',str(fn),'--strict','--model','out'],capture_output=True,text=True)
  pathlib.Path('logs/perm_'+tag+'.judge').write_text(jr.stdout+jr.stderr)
  return {'tag':tag,'result':lines[-1],'judge':jr.stdout.strip()}
 return {'tag':tag,'result':lines[-1]}
with cf.ThreadPoolExecutor(max_workers=6) as pool:
 for result in pool.map(job,range(len(lines))):print(json.dumps(result),flush=True)
