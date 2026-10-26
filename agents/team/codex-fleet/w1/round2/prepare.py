import itertools,re,json,pathlib
root=pathlib.Path('/path/to/repo')
perms=list(itertools.permutations(range(5)))
weak=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
assert len(weak)==541
networks=[[(int(a,16),int(b,16)) for a,b in (p.split(':') for p in l.split())] for l in open('networks.txt')]
inputs=[sum(1<<s for s in range(32) if s>>i&1) for i in range(5)]
row={p:i for i,p in enumerate(perms)}
trans=[]
for g in perms:
 for rev in (0,1):trans.append(([row[tuple(4-p[g[j]] if rev else p[g[j]] for j in range(5))] for p in perms],rev))
def canon(cols):
 # Full strings, not fingerprints. Every input renaming, value reversal, operand reversal.
 return min(''.join(min(''.join(str(4-c[i]) if rev else str(c[i]) for i in ids),''.join(str(4-d[i]) if rev else str(d[i]) for i in ids))+max(''.join(str(4-c[i]) if rev else str(c[i]) for i in ids),''.join(str(4-d[i]) if rev else str(d[i]) for i in ids)) for c,d in cols) for ids,rev in trans)
def simulate(seq,modes,cases):
 terms=inputs[:];v=[tuple(w[i] for w in cases) for i in range(5)];stages=[];cols=[];flag=None
 for (a,b),mode in zip(seq,modes):
  ai=terms.index(a);bi=terms.index(b);A=v[ai];B=v[bi]
  if mode==16:
   flag=tuple(x>y for x,y in zip(A,B));cols.append((A,B));X=tuple(min(x,y) for x,y in zip(A,B));Y=tuple(max(x,y) for x,y in zip(A,B))
  else:
   opts=[A,B,tuple(x if f else y for x,y,f in zip(A,B,flag)),tuple(y if f else x for x,y,f in zip(A,B,flag))] if flag is not None else [A,B]
   X=opts[mode//4];Y=opts[mode%4]
  stages.append((ai,bi,X,Y,mode));v.extend([X,Y]);terms.extend([a&b,a|b])
 return v,stages,cols
known={}
for f in (root/'agents/team/codex-fleet/w6/verified').glob('*.s'):
 regs={f'P{i}':tuple(p[i] for p in perms) for i in range(5)};cols=[];flag=None
 for line in f.read_text().splitlines():
  z=line.split('#')[0].replace(',',' ').split()
  if not z or z[0]=='out':continue
  op,d,s=z;A=regs.get(d,tuple([-99]*len(perms)));B=regs[s]
  if op=='mov':regs[d]=B
  elif op=='cmp':cols.append((A,B));flag=tuple((a>b)-(a<b) for a,b in zip(A,B))
  else:regs[d]=tuple(b if (q<0 if op=='cmovl' else q<=0 if op=='cmovle' else q>0 if op=='cmovg' else q>=0) else a for a,b,q in zip(A,B,flag))
 known[canon(cols)]=str(f)
print('known exact canonical structures',len(known),flush=True)
plans=[];classes={};weakfail=0
for l in open('round2/omit8.log'):
 m=re.match(r'FUNCTIONAL network=(\d+) c=8 modes=(.*),',l)
 if not m:continue
 idx=int(m[1]);modes=list(map(int,m[2].split(',')));seq=networks[idx]
 v,st,col=simulate(seq,modes,perms);key=canon(col)
 w,sw,cw=simulate(seq,modes,weak)
 if not all(tuple(sorted(x)[j] for x in weak) in w for j in range(5)):weakfail+=1;continue
 if key not in classes:classes[key]={'id':len(classes),'known':known.get(key),'plans':[]}
 classes[key]['plans'].append(idx)
 terms=[]
 def tid(c):
  if c not in terms:terms.append(c)
  return terms.index(c)
 for c in w[:5]:tid(c)
 flagab=None;blocks=[]
 for ai,bi,X,Y,mode in sw:
  if mode==16:flagab=(tid(w[ai]),tid(w[bi]))
  blocks.append({'cmp':mode==16,'a':flagab[0],'b':flagab[1],'x':tid(X),'y':tid(Y)})
 plans.append({'network':idx,'modes':modes,'class':classes[key]['id'],'known':classes[key]['known'],'terms':terms,'blocks':blocks})
pathlib.Path('round2/plans.json').write_text(json.dumps(plans))
pathlib.Path('round2/classes.json').write_text(json.dumps(list(classes.values()),indent=2))
with open('round2/problems.txt','w') as f:
 f.write(str(len(plans))+'\n')
 for p in plans:
  f.write(f"{p['network']} {len(p['terms'])} {p['class']}\n")
  for c in p['terms']:f.write(''.join(map(str,c))+'\n')
  for b in p['blocks']:f.write(' '.join(str(int(b[k])) for k in ('cmp','a','b','x','y'))+'\n')
print('plans',len(plans),'weak failures',weakfail,'classes',len(classes),'known classes',sum(x['known'] is not None for x in classes.values()),flush=True)
for c in classes.values():print(c,flush=True)
