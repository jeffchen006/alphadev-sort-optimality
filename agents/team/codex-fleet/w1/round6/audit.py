"""Check exact enumeration ledgers, input hashes, classifications, and judge logs."""
import hashlib
import importlib.util
import itertools
import json
import re
from collections import Counter
from pathlib import Path

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
ROOT=WORK.parents[3]
spec=importlib.util.spec_from_file_location('judge',ROOT/'shared/judge.py')
judge=importlib.util.module_from_spec(spec)
spec.loader.exec_module(judge)
bases=json.loads((HERE/'manifest.json').read_text())
analysis=json.loads((HERE/'analysis.json').read_text())
cases=judge.weak_orders(5)
summary={'assumptions':['G1','G2','G3','G4','A11'], 'searches':{}, 'classification':[], 'passes':[]}

def run(code,x,nr,collect=False):
    r=list(x)+[-100-i for i in range(nr-5)]
    lt,eq=False,True
    seen_cmp=False
    out={}
    history=[]
    trace=[r.copy()]
    for op,a,b in code:
        if op==6:
            out[a]=r[b]
            continue
        if op==1:
            # A negative value identifies arbitrary initial scratch data.
            assert r[a]>=0 and r[b]>=0, ('garbage comparison',code,x)
            lt,eq=r[a]<r[b],r[a]==r[b]
            seen_cmp=True
            history.append((lt,eq))
        elif op>=2:
            assert seen_cmp, ('initial flag dependency',code)
            if (op==2 and lt) or (op==3 and (lt or eq)) or (op==4 and not lt and not eq) or (op==5 and not lt):
                r[a]=r[b]
        elif op==0:
            r[a]=r[b]
        trace.append(r.copy())
    got=[out.get(j,r[j]) for j in range(5)]
    assert all(v>=0 for v in got), ('garbage output',code,x)
    return got,history,trace

for b,a in zip(bases,analysis):
    assert hashlib.sha256(Path(b['path']).read_bytes()).hexdigest()==b['sha256']
    assert b['k']==31
    failed=[]
    for i,x in enumerate(cases):
        got,flags,trace=run(b['code'],x,len(b['registers']))
        if got!=sorted(x):failed.append(i)
    assert failed==[f['case'] for f in a['failures']]
    if b['index']<15:
        # Each failed pivot is strictly above exactly two original inputs.
        # It is strictly below the other two. Both pair-internal ties are free.
        possible=[]
        fs=set(failed)
        for pivot in range(5):
            others=[i for i in range(5) if i!=pivot]
            for low in itertools.combinations(others,2):
                high=tuple(i for i in others if i not in low)
                predicted={i for i,x in enumerate(cases) if all(x[l]<x[pivot] for l in low) and all(x[pivot]<x[h] for h in high)}
                if predicted==fs:possible.append(dict(pivot=pivot,low=low,high=high))
        assert len(possible)==1
        condition=possible[0]
    else:
        condition='min(x0,x1)<x2<min(x3,x4) and max(x0,x1)>=max(x3,x4)'
        predicted={i for i,x in enumerate(cases) if min(x[0],x[1])<x[2]<min(x[3],x[4]) and max(x[0],x[1])>=max(x[3],x[4])}
        assert predicted==set(failed)
    summary['classification'].append(dict(base=b['name'],condition=condition,failed_orders=len(failed),
        distinct_failures=a['strict_failures'],failed_outputs=a['failed_outputs'],
        loss_times=dict(Counter(str(w['first_absent_time']) for f in a['failures'] for w in f['wrong'])),
        garbage_comparisons=0,garbage_outputs=0))

for mode in ['fixed','free','relocate_fixed','relocate_free']:
    def read(path):return [json.loads(s) for s in path.read_text().splitlines()]
    rows=read(HERE/f'{mode}.jsonl')
    other=read(HERE/f'check_{mode}.jsonl')
    assert rows==other,(mode,'independent ledgers differ')
    logs=[]
    for line in (HERE/f'{mode}.log').read_text().splitlines():
        assert line.startswith('RESULT '),line
        logs.append(dict(re.findall(r'(\w+)=(\S+)',line)))
    assert len(logs)==16
    for b,l in zip(bases,logs):
        assert l['name']==b['name']
        gaps=(31 if 'free' in mode else 36) if 'relocate' in mode else (32 if 'free' in mode else 37)
        slots=gaps*(31 if 'relocate' in mode else 1)
        assert int(l['slots'])==slots
        assert int(l['raw'])==slots*6*(len(b['registers'])+1)**2
        assert int(l['survivors'])==sum(r['base']==b['name'] for r in rows)
    counts={k:sum(int(l[k]) for l in logs) for k in ['slots','raw','sims','steps','case_slots','survivors']}
    counts['cpu']=sum(float(l['cpu']) for l in logs)
    counts['independent_cpu']=sum(float(re.search(r'cpu=(\S+)',line)[1]) for line in (HERE/f'check_{mode}.log').read_text().splitlines())
    counts['opcodes']=dict(Counter(['mov','cmp','cmovl','cmovle','cmovg','cmovge'][r['instruction'][0]] for r in rows))
    counts['fresh_operands']=sum(any(v>=len(bases[int(r['base'][1:])]['registers']) for v in r['instruction'][1:]) for r in rows)
    if 'relocate' in mode:assert not rows
    summary['searches'][mode]=counts

# Describe one checked repair per base. This uses the fixed-output first edit.
fixed=[json.loads(s) for s in (HERE/'fixed.jsonl').read_text().splitlines()]
for b,a,s in zip(bases,analysis,summary['classification']):
    own=[r for r in fixed if r['base']==b['name']]
    s['repair_register_pairs']=sorted({tuple(r['instruction'][1:]) for r in own})
    s['repair_core_gaps']=sorted({sum(z[0]!=6 for z in b['code'][:r['gap']]) for r in own})
    edit=next(r for r in fixed if r['base']==b['name'])
    q=list(b['code']);q.insert(edit['gap'],edit['instruction'])
    needed_copies=0;changed_predicates=0;changed_cases=[]
    for i,x in enumerate(cases):
        old,oldflags,trace=run(b['code'],x,len(b['registers']))
        new,newflags,_=run(q,x,len(b['registers'])+1)
        assert new==sorted(x)
        changed_predicates+=oldflags!=newflags
        if oldflags!=newflags:changed_cases.append(i)
        if old!=sorted(x):
            core_gap=sum(z[0]!=6 for z in b['code'][:edit['gap']])
            source=trace[core_gap][edit['instruction'][2]]
            wrong=next(j for j in range(5) if old[j]!=sorted(x)[j])
            needed_copies+=source==sorted(x)[wrong]
    s['first_repair']=edit
    s['first_repair_source_is_needed_value_on_failures']=needed_copies
    s['first_repair_changes_comparison_history_on_orders']=changed_predicates
    assert not changed_cases or changed_cases==[f['case'] for f in a['failures']]

ledger=json.loads((HERE/'pass_ledger.json').read_text())
assert len(ledger)==730+32,len(ledger)
assert len({r['path'] for r in ledger})==len(ledger)
for row in ledger:
    p=Path(row['path'])
    assert hashlib.sha256(p.read_bytes()).hexdigest()==row['sha256']
    log=Path(row['log']).read_text()
    assert row['result']=='PASS' and log.startswith('PASS '+str(p)+' [relaxed+strict] '),(p,log)
    assert ('model='+row['model']) in log
    _,prog=judge.parse(p.read_text())
    cost=sum(op!='out' for op,a,b,ln in prog)
    assert cost==(32 if row['model']=='out' else 42)
    summary['passes'].append(dict(path=str(p),model=row['model'],cost=cost,log=row['log'],sha256=row['sha256']))
summary['source_hashes']={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in HERE.glob('*.py')}
summary['source_hashes'].update({p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in HERE.glob('*.cpp')})
summary['max_recorded_search_rss_kib']=max(int(m[1]) for p in HERE.glob('*.resources') if (m:=re.search(r'Maximum resident set size \(kbytes\): (\d+)',p.read_text())))
summary['status']='COMPLETE; no k<=31; all 730 inserted cores strict PASS; 32 memory forms strict PASS'
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(summary['status'])
for mode,v in summary['searches'].items():print(mode,v)
for a in summary['classification']:print(a['base'],a['condition'],'copies_needed',a['first_repair_source_is_needed_value_on_failures'],'changed_histories',a['first_repair_changes_comparison_history_on_orders'])
print('MAX_RSS_KIB',summary['max_recorded_search_rss_kib'])
