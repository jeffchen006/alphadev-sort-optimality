import os,gzip,re,json,collections,glob,random,itertools,importlib.util
ROOT='codex_work/r4'
try:os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
except (AttributeError,OSError):pass
def instructions(lines):
    return [l.strip() for l in lines if l.strip() and not l.lstrip().startswith('#')]
def summary(prog):
    ct=collections.Counter(p.split()[0] for p in prog);blocks=[];prefix=0
    for p in prog:
        op=p.split()[0]
        if op=='out':continue
        if op=='cmp':blocks.append(0)
        elif blocks:blocks[-1]+=1
        else:prefix+=1
    return {'c':ct['cmp'],'g':sum(v for k,v in ct.items() if k.startswith('cmov')),'v':ct['mov'],'w':sum(v for k,v in ct.items() if k=='mov' or k.startswith('cmov')),'prefix':prefix,'blocks':blocks}
families={p:summary(instructions(open(p))) for p in glob.glob('fam32/*.s')}
special={p:summary(instructions(open(p))) for p in ['../d4-evolve/codex/work/position33_valid.txt','codex_work/r3/avoid_a_copy_33.s','../../upper/progs/alphadev_sort3_free.s','../../upper/progs/alphadev_sort4_free.s']}
counts=collections.Counter();patterns=collections.Counter();bad_blocks=collections.Counter();samples=[];rng=random.Random(741);N=0
def consume(prog):
    global N
    if not prog:return
    s=summary(prog);N+=1;counts[(s['c'],s['g'],s['v'])]+=1
    patterns[(s['prefix'],tuple(s['blocks']))]+=1
    bad_blocks[min(s['blocks'],default=-1)]+=1
    if len(samples)<100:samples.append(prog)
    else:
        i=rng.randrange(N)
        if i<100:samples[i]=prog
with gzip.open('../../upper/runs/r4/s5k32_coll.txt.gz','rt') as f:
    prog=[]
    for line in f:
        if line.startswith('# prog'):
            consume(prog);prog=[]
        elif line.strip() and not line.startswith('#'):prog.append(line.strip())
    consume(prog)
out={'families':families,'special':special,'collection_programs':N,'collection_counts':[(list(k),v) for k,v in counts.items()],'collection_min_block_writes':dict(bad_blocks),'collection_patterns':[(list(k),v) for k,v in patterns.items()]}
json.dump(out,open(ROOT+'/audit.json','w'),indent=2)
with open(ROOT+'/sample100.txt','w') as f:
    for p in samples:f.write('# prog len='+str(sum(not x.startswith('out ') for x in p))+'\n'+'\n'.join(p)+'\n')
print('collection',N,'counts',counts,'minimum block write counts',bad_blocks,'patterns',len(patterns),flush=True)
print('family counts',collections.Counter((s['c'],s['g'],s['v']) for s in families.values()),flush=True)
print('family block minima',collections.Counter(min(s['blocks']) for s in families.values()),flush=True)
for p,s in special.items():print(p,s,flush=True)
# Validate a deterministic sample of 30 c=9/10/11 programs from individual files.
spec=importlib.util.spec_from_file_location('judge','/path/to/repo/shared/judge.py');judge=importlib.util.module_from_spec(spec);spec.loader.exec_module(judge)
files=glob.glob('../../upper/runs/r4/*.s');rng.shuffle(files);chosen={9:[],10:[],11:[]}
for p in files:
    text=open(p).read();prog=instructions(text.splitlines());ss=summary(prog)
    if ss['c'] not in chosen or len(chosen[ss['c']])>=10:continue
    try:hdr,parsed=judge.parse(text)
    except Exception:continue
    if hdr.get('n')!='5' or hdr.get('iset','I1')!='I1':continue
    ok,info,err=judge.judge(text,strict=True,model='out',seeds=0,quiet=True)
    if ok:chosen[ss['c']].append({'file':p,**ss})
    if all(len(v)==10 for v in chosen.values()):break
json.dump(chosen,open(ROOT+'/random_checked.json','w'),indent=2)
print('strict random-file sample', {c:[s['w'] for s in v] for c,v in chosen.items()},flush=True)
