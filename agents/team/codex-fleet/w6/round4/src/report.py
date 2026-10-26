"""Audit completed enumeration counts and append the round-4 report."""
import hashlib
import itertools
import json
import os
from pathlib import Path
import re

OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
def program(path):
    p=[]
    registers={f'P{j}':j for j in range(5)}
    for line in Path(path).read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line or line.startswith('out '):
            continue
        op,d,s=line.replace(',','').split()
        for r in d,s:
            if r not in registers:
                registers[r]=len(registers)
        p.append((OPS.index(op),registers[d],registers[s]))
    return p,len(registers)+1

def expected(path,mode):
    p,nr=program(path)
    if mode=='cmp2':
        wc=sum(op!=1 for op,_,_ in p)
        wp=wc*(wc-1)//2
        cp=len(p)*(len(p)-1)//2-wp
        return (len(p)-1)*(cp*(5*nr*(nr-1)+nr*nr)+wp*nr*nr)
    writes=[i for i,(op,_,_) in enumerate(p) if op!=1]
    count=0
    for a,b in itertools.combinations(writes,2):
        q=[row for t,row in enumerate(p) if t not in (a,b)]
        if mode=='delete2':
            count+=(len(q)+1)*5*nr*(nr-1)
            continue
        slots=range(len(q)+1) if mode=='flagsall' else sorted({a,b-1})
        alphabet=(5 if mode=='flagswrites' else 4)*nr*(nr-1)
        for t in slots:
            eligible=sum(row[0]==1 for row in q) if mode=='flagsany' else int(any(row[0]==1 for row in q[:t]))
            count+=eligible*(nr*nr-1)*alphabet
    return count

jobs=[]
for artifact in sorted(Path('round4/artifacts').glob('*.json')):
    obj=json.loads(artifact.read_text())
    if isinstance(obj,dict) and 'command' in obj:
        jobs.append(obj)
tables={}
for stem,mode,manifest in [
    ('delete2_even','delete2','all'),('delete2_odd','delete2','all'),
    ('flagsall_even','flagsall','nomov'),('flagsall_odd','flagsall','nomov'),
    ('flagswrites_0','flagswrites','all'),('flagswrites_1','flagswrites','all'),
    ('cmp2_0','cmp2','all'),('cmp2_1','cmp2','all'),
    ('flagsany_0','flagsany','nomov'),('flagsany_1','flagsany','nomov')]:
    log=Path('round4/logs',stem+'.log')
    text=log.read_text()
    job=json.loads(Path('round4/artifacts',stem+'.json').read_text())
    rows=[dict(re.findall(r'(\w+)=([^ ]+)',line)) for line in text.splitlines() if line.startswith('SEED ')]
    for row in rows:
        assert int(row['tried'])==expected(row['path'],mode),(stem,row)
    totals=[dict(re.findall(r'(\w+)=([^ ]+)',line)) for line in text.splitlines() if line.startswith('SUMMARY ')]
    complete=job['exit']==0 and len(totals)==1
    if complete:
        total=totals[0]
        assert int(total['seeds'])==len(rows)
        for key in ('tried','filtered','full','hits'):
            assert int(total[key])==sum(int(row[key]) for row in rows)
        allpaths=Path('round4/artifacts',manifest+'.txt').read_text().splitlines()
        assert len(rows)==len(allpaths)//2
    tables[stem]={'mode':mode,'complete':complete,'rows':rows,'log':str(log),'job':job}

aggregate={}
for mode in ('delete2','flagsall','flagswrites','cmp2','flagsany'):
    group=[v for v in tables.values() if v['mode']==mode]
    rows=[row for v in group for row in v['rows']]
    aggregate[mode]={'complete':all(v['complete'] for v in group),'seeds':len(rows),
                     **{key:sum(int(row[key]) for row in rows) for key in ('tried','filtered','full','hits')},
                     'cpu':sum(float(row['cpu']) for row in rows),
                     'logs':[v['log'] for v in group]}

inventory=json.loads(Path('round4/artifacts/inventory.json').read_text())
for row in inventory:
    assert hashlib.sha256(Path(row['path']).read_bytes()).hexdigest()==row['sha256']
assert Path('round4/logs/evaluator_check_fixed.log').read_text().strip()=='CHECK programs=840 scalar_case_steps=15855840 result=MATCH'
control=Path('round4/candidates/check_seed0_control.s')
control_log=Path('round4/logs/control_judge.log')
assert control_log.read_text().startswith('PASS '+str(control)+' [relaxed+strict]')
summary={'aggregate':aggregate,'tables':tables,'jobs':jobs,
         'inventory':inventory,'affinity':sorted(os.sched_getaffinity(0)),
         'strict_controls':[{'path':str(control),'log':str(control_log),
                             'sha256':hashlib.sha256(control.read_bytes()).hexdigest()}]}
assert len(summary['affinity'])==2
Path('round4/artifacts/final_summary.json').write_text(json.dumps(summary,indent=2))

assert not Path('round4/artifacts/FOUND_PENDING').exists(),'Report a strict PASS before finalizing'
assert sum(row['hits'] for row in aggregate.values())==0,'Judge and report all full survivors'
report=['','## Round 4 completion','',
        'No strict PASS with k <= 31 was found. The best verified core remains k=32, or 42 instructions in the memory model.','',
        'All five new enumeration patterns finished. The table reports edit sequences, not unique programs. The case filter is a necessary concrete test. A first-filter survivor must still provide one fixed snapshot per output across all 541 weak orders. No full survivor was found.','',
        '| Pattern | Seeds | Edit sequences | 64-case survivors | 541-case survivors |',
        '|---|---:|---:|---:|---:|']
descriptions={
    'delete2':'Delete two writes; insert one write at any position',
    'flagsall':'No-mov cores: delete two cmovs; insert one cmov anywhere; change its preceding cmp',
    'flagswrites':'All seeds: delete two writes; insert one write at either deleted position; change its preceding cmp',
    'cmp2':'Delete two instructions; insert one instruction anywhere; edit includes a cmp',
    'flagsany':'No-mov cores: delete two cmovs; insert one cmov at either deleted position; change any cmp',
}
for mode,row in aggregate.items():
    assert row['complete']
    report.append(f'| {descriptions[mode]} | {row["seeds"]:,} | {row["tried"]:,} | {row["filtered"]:,} | {row["hits"]:,} |')
report+=['',
         'Here, a write is mov or one of the four supported conditional moves. A changed comparison can use any ordered register pair, including equal operands. Inserted comparisons also permit equal operands. Inserted writes use distinct source and destination registers. Every alphabet includes all used registers and one fresh scratch register. Untouched instructions retain their order. The comparison-edit pattern skips the write-only pattern counted in the first row. Counts can otherwise overlap across rows.','',
         'The flag-source scans change comparison operands. They do not rerun fixed-structure routing. In the last scan, the changed comparison can occur before or after the inserted conditional move. In the preceding-comparison scans, it is the comparison that supplies flags to the inserted write. The comparison must change syntactically. The scans retain eight comparison slots. The general comparison-edit scan permits comparison deletion and insertion. It can therefore change the comparison count.','',
         'All counts were recomputed independently from each seed and edit pattern. Each seed count matched its log. The audit also checked aggregate counts, inventory hashes, the evaluator check, the strict control log, and two-core affinity. See [audit source](round4/src/report.py) and [full result ledger](round4/artifacts/final_summary.json).','',
         'Completed searches are negatives only within their stated register alphabets and edit patterns. No global lower bound is claimed. The scalar comparison is a tested agreement. It is not a proof of evaluator correctness.','',
         'All search and compiler commands used nice level 19. At most two CPU jobs ran at once. Bounded jobs had a 2,800 MiB address-space limit. The process tree remained restricted to two cores. All new files are inside w6. No fixed-structure routing was run.','',
         'Logs for the completed patterns:','']
for mode,row in aggregate.items():
    report.append('- '+descriptions[mode]+': '+', '.join(f'[{Path(p).name}]({p})' for p in row['logs'])+'.')
report+=['',
         'The only new strict PASS file is the k=32 reconstruction control: [out file](round4/candidates/check_seed0_control.s), [judge output](round4/logs/control_judge.log). It does not meet the target.','']
assert '## Round 4 completion' not in Path('RESULTS.md').read_text()
with Path('RESULTS.md').open('a') as f:
    f.write('\n'.join(report))
print(json.dumps({'aggregate':aggregate,'audit':'MATCH'}),flush=True)
