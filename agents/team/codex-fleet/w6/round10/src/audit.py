"""Audit scope integrity and independently check source comparison columns."""
import collections
import hashlib
import itertools
import json
from pathlib import Path
import re
import generate as g
import numpy as np

def scalar_columns(fn,garbage):
    code=[]
    for line in fn.read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line or line.startswith('out'):continue
        op,args=line.split(None,1);d,s=map(str.strip,args.split(','));code.append((op,d,s))
    result=[]
    for values in itertools.permutations(range(5)):
        regs=collections.defaultdict(lambda:garbage);regs.update({f'P{i}':x for i,x in enumerate(values)})
        flag=0;cols=[]
        for op,d,s in code:
            if op=='cmp':
                cols.append((regs[d],regs[s]));flag=(regs[d]>regs[s])-(regs[d]<regs[s])
            elif op=='mov':regs[d]=regs[s]
            elif {'cmovl':flag<0,'cmovle':flag<=0,'cmovg':flag>0,'cmovge':flag>=0}[op]:regs[d]=regs[s]
        result.append(cols)
    return np.array(result,dtype=np.int64).transpose(1,2,0)

def masks(a,b):
    f=(a>b).astype(np.int8)-(a<b).astype(np.int8)
    return {bytes(x) for x in (f<0,f>0,f<=0,f>=0) if np.any(x) and not np.all(x)}

def nonlattice_witness(col):
    known={}
    for t,inputs in enumerate(g.P):
        for threshold in range(1,5):
            support=sum(1<<i for i,x in enumerate(inputs) if x>=threshold)
            bit=int(col[t]>=threshold)
            if support in known and known[support][0]!=bit:
                return {'support':support,'first':known[support][1:],'second':[t,threshold,int(col[t])]}
            known[support]=(bit,t,threshold,int(col[t]))
    return None

initial=json.loads(Path('round10/artifacts/manifest.json').read_text())
expanded=json.loads(Path('round10/artifacts/expanded_manifest.json').read_text())
single=json.loads(Path('round10/artifacts/singleton_inventory.json').read_text())
inventfile=Path('round10/artifacts/invented_all_manifest.json')
invented=json.loads(inventfile.read_text()) if inventfile.exists() else []
sources=sorted({x['seed'] for x in initial+expanded+invented})
source_cache={};witnesses={};checks=0
for source in sources:
    fn=Path(source);code,names=g.load(fn);traced=g.trace(code,names)
    if traced is None:continue
    sk=traced[0]
    for garbage in [-2147483648,0,2147483647]:
        independent=scalar_columns(fn,garbage)
        assert np.array_equal(independent,sk),(source,garbage)
        checks+=int(independent.size)
    source_cache[source]=sk
    witnesses[source]=next((dict(comparison=j,side=s,witness=w) for j,pair in enumerate(sk) for s,c in enumerate(pair) if (w:=nonlattice_witness(c))),None)

alternative_checks=0;files_checked=0
for x in initial+expanded+single+invented:
    fn=Path(x['file']);assert hashlib.sha256(fn.read_bytes()).hexdigest()==x['sha256'],str(fn)
    lines=[l.strip() for l in fn.read_text().splitlines() if l.strip() and not l.startswith('#')]
    assert len(lines)==10
    seed=source_cache[x['seed']];pos=x['insert'];repeat=x['repeat']
    for j,line in enumerate(lines):
        for alt in line.split(';'):
            pair=np.array([g.column(v) for v in alt.split(':')])
            if j==pos:
                assert masks(*pair)==masks(*seed[repeat]),(str(fn),j)
                alternative_checks+=1
            else:
                assert np.array_equal(pair,seed[j-(j>pos)]),(str(fn),j)
    files_checked+=1

ledgers=[];scope_results={};all_records=[]
for name in ['ledger','pilot_ledger','macro_ledger','singleton_ledger','invented_ledger','retry_ledger']:
    fn=Path('round10/artifacts')/(name+'.json')
    if not fn.exists():continue
    rows=json.loads(fn.read_text());ledgers.append((str(fn),len(rows)));all_records+=rows
    for x in rows:
        if x['status']=='FOUND' and not any(all(m['pass'] for m in q['models'].values()) for q in x.get('judges',[])):
            x['status']='CANDIDATE_STRICT_FAIL'
        file=Path(x['file']);assert file.exists()
        if x.get('sha256'):assert hashlib.sha256(file.read_bytes()).hexdigest()==x['sha256']
        txt=Path(x['log']).read_text()
        if x['status']=='NONE':
            assert x['exit_code']==0 and 'RESULT NONE K=31' in txt
            assert x['node_limit'] is None
        elif x['status']=='UNKNOWN_TIMEOUT':assert x['result'] is None
        scope_results.setdefault(str(file),[]).append(x['status'])
distinct_none=sum('NONE' in x for x in scope_results.values())
unresolved=sum('NONE' not in x and 'FOUND' not in x for x in scope_results.values())
calls=sum(int(m[1]) for x in all_records if x['status']=='NONE' and (m:=re.search(r'calls=(\d+)',x['result'])))
pass_paths=[]
for jl in sorted(Path('round10/logs').glob('*judge.log')):
    text=jl.read_text()
    if text.startswith('PASS '):
        m=re.match(r'PASS (.*?) \[',text);assert m
        fn=Path(m[1]);assert fn.exists()
        pass_paths.append(dict(file=str(fn),log=str(jl),sha256=hashlib.sha256(fn.read_bytes()).hexdigest()))
summary=dict(source_programs=len(source_cache),comparison_value_checks=checks,source_nonlattice_witnesses=witnesses,
             scope_files_checked=files_checked,repeat_operand_choices_checked=alternative_checks,
             ledgers=ledgers,routing_records=len(all_records),routing_statuses=dict(collections.Counter(x['status'] for x in all_records)),
             distinct_scopes=len(scope_results),distinct_exhaustive_none=distinct_none,distinct_unresolved=unresolved,
             completed_none_calls=calls,routing_cpu_seconds=sum(x['cpu_seconds'] for x in all_records),routing_wall_seconds=sum(x['wall_seconds'] for x in all_records),
             peak_routing_rss_kib=max(x['max_rss_kib'] for x in all_records),pass_paths=pass_paths,
             hashes={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(Path('round10/src').glob('*')) if p.is_file()},
             assumptions=['A4','A6'],global_lower_bound=False)
Path('round10/artifacts/audit.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k not in ['hashes','source_nonlattice_witnesses','pass_paths']},indent=2))
