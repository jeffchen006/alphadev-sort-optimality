"""Count failed orders and try full-order output snapshots for every target model."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

from reference_window import OPS, CASES, GOALS, read, concrete
from search import emit

BASE = Path(__file__).resolve().parents[1]
WORKER = BASE.parent
PROJECT = WORKER.parents[3]


def parse_outputs(path):
    names = {f'P{i}':i for i in range(5)}
    snapshots = [None]*5
    time = 0
    for line in Path(path).read_text().splitlines():
        line = line.partition('#')[0].strip()
        if not line:
            continue
        op, d, s = line.replace(',', ' ').split()
        if op == 'out':
            snapshots[int(d)] = (time, names[s])
        else:
            for r in [d,s]:
                if r not in names:
                    names[r] = len(names)
            time += 1
    assert all(s is not None for s in snapshots)
    return snapshots


def exact_top_failures(program, nr, snapshots):
    failures = []
    for index, case in enumerate(CASES):
        rs = list(case)+[5]*(nr-5)
        flag = 0
        history = [rs[:]]
        for op,d,s in program:
            if op == 0:
                rs[d] = rs[s]
            elif op == 1:
                flag = (rs[d]>rs[s])-(rs[d]<rs[s])
            elif (flag<0 if op==2 else flag<=0 if op==3 else flag>0 if op==4 else flag>=0):
                rs[d] = rs[s]
            history.append(rs[:])
        result = [history[t][r] for t,r in snapshots]
        if result != sorted(case):
            failures.append(index)
    return failures


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    rows = []
    for folder in [BASE, BASE/'extra', BASE/'partial']:
        for path in sorted((folder/'candidates').glob('*.model*.s')):
            p, used = read(path)
            if len(p) > 31:
                continue
            snapshots = parse_outputs(path)
            cols, states = concrete(p,used)
            exact = exact_top_failures(p, used, snapshots)
            conservative = [i for i in range(541)
                            if any(states[t][0][r][i] != GOALS[j][i]
                                   for j,(t,r) in enumerate(snapshots))]
            minimum = [min(sum(v!=w for v,w in zip(c,g)) for _,_,c in cols) for g in GOALS]
            witnesses = [next(((t+1,r) for t,r,c in cols if c==g),None) for g in GOALS]
            judge = Path(str(path)+'.judge').read_text()
            row = dict(path=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                       core_sha256=hashlib.sha256(repr(p).encode()).hexdigest(),
                       k=len(p), exact_equal_flags_top5_failures=len(exact),
                       exact_failure_indices=exact, conservative_failures=len(conservative),
                       best_snapshot_error_counts=minimum, judge=judge)
            if all(w is not None for w in witnesses):
                alternate = folder/'candidates'/(path.stem+'_best_outputs.s')
                emit(p, witnesses, alternate)
                checked = subprocess.run([sys.executable,'-B',str(PROJECT/'shared/judge.py'),
                                          str(alternate),'--strict','--model','out'],
                                         capture_output=True,text=True)
                Path(str(alternate)+'.judge').write_text(checked.stdout+checked.stderr)
                row['alternate_judge'] = checked.stdout+checked.stderr
                if not checked.returncode and checked.stdout.startswith('PASS '):
                    memory = alternate.with_name(alternate.stem+'_mem.s')
                    subprocess.run([sys.executable,'-B',str(WORKER/'src/to_mem.py'),
                                    str(alternate),str(memory)],check=True)
                    checked_mem = subprocess.run([sys.executable,'-B',str(PROJECT/'shared/judge.py'),
                                                  str(memory),'--strict','--model','mem'],
                                                 capture_output=True,text=True)
                    Path(str(memory)+'.judge').write_text(checked_mem.stdout+checked_mem.stderr)
                    assert not checked_mem.returncode and checked_mem.stdout.startswith('PASS ')
                    row['alternate_memory_judge'] = checked_mem.stdout+checked_mem.stderr
                    results = WORKER/'RESULTS.md'
                    results.write_text(f'FOUND k={len(p)} strict out and mem PASS: {alternate}\n\n'+results.read_text())
            rows.append(row)
    report = dict(models=len(rows), strict_passes=sum(r['judge'].startswith('PASS ') or
                                                   r.get('alternate_judge','').startswith('PASS ') for r in rows),
                  unique_cores=len({r['core_sha256'] for r in rows}),
                  minimum_equal_flags_failure_count=min((r['exact_equal_flags_top5_failures'] for r in rows),default=None),
                  assumptions=['G1','G2','G3','G4','A2','A4','A11'], records=rows)
    (BASE/'logs/model_analysis.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k!='records'}),flush=True)


if __name__ == '__main__':
    main()
