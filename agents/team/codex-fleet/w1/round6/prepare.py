"""Inventory and classify the requested failures. No previous search is rerun."""
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
WORK = HERE.parent
ROOT = WORK.parents[3]
spec = importlib.util.spec_from_file_location('judge', ROOT / 'shared/judge.py')
judge = importlib.util.module_from_spec(spec)
spec.loader.exec_module(judge)
OPS = ['mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge', 'out']
cases = judge.weak_orders(5)
inv = json.loads((WORK.parent / 'w6/round6/artifacts/near_inventory.json').read_text())
paths = [WORK.parent / 'w6' / r['file'] for r in inv['representatives']]
paths.append(WORK.parent / 'w9/candidates/residual_b_near31_out.s')
rows = []
analyses = []
for index, path in enumerate(paths):
    hdr, prog = judge.parse(path.read_text())
    names = [f'P{i}' for i in range(5)]
    for op, a, b, ln in prog:
        for r in ([b] if op == 'out' else [a,b]):
            if r not in names: names.append(r)
    code = [(OPS.index(op), int(a) if op == 'out' else names.index(a), names.index(b))
            for op,a,b,ln in prog]
    rows.append(dict(index=index, name=f'b{index:02d}', path=str(path),
                     sha256=hashlib.sha256(path.read_bytes()).hexdigest(), registers=names,
                     code=code, k=sum(z[0] != 6 for z in code)))
    fails = []
    for ci, values in enumerate(cases):
        st = {r: values[int(r[1:])] if r.startswith('P') else 5 for r in names}
        flags = (1,0)
        out = {}
        trace = [dict(st)]
        output_states = {}
        core = 0
        for op,a,b,ln in prog:
            if op == 'out':
                out[a] = st[b]
                output_states[int(a)] = (core, dict(st))
                continue
            if op == 'mov': st[a] = st[b]
            elif op == 'cmp': flags = (int(st[a] == st[b]), int(st[a] < st[b]))
            elif judge.cond(op,flags): st[a] = st[b]
            core += 1
            trace.append(dict(st))
        got = judge.outputs(st,out,5)
        target = sorted(values)
        if got == target: continue
        wrong = []
        for j in range(5):
            if got[j] == target[j]: continue
            t, state = output_states.get(j,(core,st))
            loss = next((i for i,s in enumerate(trace) if target[j] not in s.values()),None)
            wrong.append(dict(output=j, got=got[j], need=target[j], output_time=t,
                              available_at_output=[r for r in names if state[r] == target[j]],
                              first_absent_time=loss,
                              last_present=[r for r in names if trace[loss-1][r]==target[j]] if loss else [],
                              available_snapshots=[(i,r) for i,s in enumerate(trace) for r in names if s[r]==target[j]]))
        fails.append(dict(case=ci,input=values,got=got,expected=target,wrong=wrong))
    assert len(fails)==(9 if index<15 else 12), (path,len(fails))
    # Find every simple original-input predicate that holds on ALL failed cases.
    predicates=[]
    for a,b in itertools.combinations(range(5),2):
        for symbol,fn in [('<',lambda x,y:x<y),('<=',lambda x,y:x<=y),('>',lambda x,y:x>y),('>=',lambda x,y:x>=y),('==',lambda x,y:x==y)]:
            mask={i for i,v in enumerate(cases) if fn(v[a],v[b])}
            if all(f['case'] in mask for f in fails): predicates.append((f'x{a}{symbol}x{b}',mask))
    implied=set.intersection(*(m for _,m in predicates)) if predicates else set(range(541))
    minimal=None
    if implied=={f['case'] for f in fails}:
        for n in range(1,len(predicates)+1):
            for ids in itertools.combinations(range(len(predicates)),n):
                if set.intersection(*(predicates[i][1] for i in ids))==implied:
                    minimal=[predicates[i][0] for i in ids]; break
            if minimal: break
    analyses.append(dict(index=index,path=str(path),failed_orders=len(fails),
                         strict_failures=sum(len(set(f['input']))==5 for f in fails),
                         failed_outputs=dict(Counter(str(w['output']) for f in fails for w in f['wrong'])),
                         common_predicates=[p for p,m in predicates],exact_conjunction=minimal,
                         failures=fails))
(HERE/'manifest.json').write_text(json.dumps(rows,indent=2)+'\n')
(HERE/'analysis.json').write_text(json.dumps(analyses,indent=2)+'\n')
with (HERE/'bases.txt').open('w') as f:
    print(len(rows),file=f)
    for r in rows:
        print(r['name'],len(r['registers']),len(r['code']),file=f)
        print(*r['registers'],file=f)
        for z in r['code']: print(*z,file=f)
for a in analyses:
    print(a['index'],a['failed_orders'],'strict',a['strict_failures'],'outputs',a['failed_outputs'],
          'condition',a['exact_conjunction'], 'losses',dict(Counter(w['first_absent_time'] for f in a['failures'] for w in f['wrong'])))
