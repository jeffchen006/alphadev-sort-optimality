"""Independent scalar checks and a local-repair handoff for seven failed models."""
from collections import Counter
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path

from analyze import parse, simulate

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'round4'
CASES = [x for x in itertools.product(range(5), repeat=5)
         if set(x) == set(range(max(x)+1))]
spec = importlib.util.spec_from_file_location('w4_conservative',ROOT/'round2/src/window_cnf.py')
conservative = importlib.util.module_from_spec(spec)
spec.loader.exec_module(conservative)


def dependencies(code, case):
    regs = {r:(9,set()) for op,d,s in code for r in (d,s)
            if r.startswith(('P','S'))}
    regs.update({f'P{i}':(v,set()) for i,v in enumerate(case)})
    flag, flagdeps, step = 0, set(), 0
    traces, output = [], {}
    goals = sorted(case)
    for op,d,s in code:
        if op == 'out':
            output[int(d)] = dict(value=regs[s][0],dependencies=sorted(regs[s][1]),
                                  time=step,register=s)
            continue
        a,da = regs[d]
        b,db = regs[s]
        if op == 'cmp':
            flag = (a>b)-(a<b)
            flagdeps = da|db|{step}
        else:
            yes = op == 'mov' or {'cmovl':flag<0,'cmovle':flag<=0,
                                   'cmovg':flag>0,'cmovge':flag>=0}.get(op,False)
            value = b if yes else a
            deps = (db if yes else da)|{step}
            if op != 'mov':
                deps |= flagdeps
            lost = [j for j,g in enumerate(goals) if a == g and value != g]
            regs[d] = value,deps
            absent = [j for j,g in enumerate(goals) if all(v != g for v,_ in regs.values())]
            traces.append(dict(position=step,op=op,destination=d,source=s,
                               value=value,lost_goal_indices=lost,absent_goal_indices=absent))
        step += 1
    return output,traces


def main():
    ledger = json.loads((ROOT/'round3/logs/recovered_models.json').read_text())
    rows = []
    tasks = []
    for prior in ledger:
        path = Path(prior['path'])
        assert hashlib.sha256(path.read_bytes()).hexdigest() == prior['sha256']
        code = parse(path)
        failures = []
        wrong_counts = Counter()
        cone_counts, loss_counts = Counter(), Counter()
        all_snapshots = {}
        for ix,x in enumerate(CASES):
            output,snapshots,_ = simulate(code,x)
            for step,r,v in snapshots:
                all_snapshots.setdefault((step,r),[]).append(v)
            if output == sorted(x):
                continue
            wrong = [j for j in range(5) if output[j] != sorted(x)[j]]
            wrong_counts.update(wrong)
            outs,traces = dependencies(code,x)
            cone = set().union(*(set(outs[j]['dependencies']) for j in wrong))
            cone_counts.update(cone)
            loss = {t['position'] for t in traces if set(t['lost_goal_indices'])&set(wrong)}
            loss_counts.update(loss)
            failures.append(dict(case_index=ix,input=x,output=output,goal=sorted(x),
                                 wrong_outputs=wrong,output_dependencies=outs,
                                 value_loss_positions=sorted(loss)))
        parsed,names = conservative.read(path)
        outputs = conservative.read_outputs(path,names)
        conservative_failures = []
        for ix,x in enumerate(CASES):
            states,_ = conservative.concrete(parsed,x,len(names))
            if any(states[t][0][r] != sorted(x)[j] for j,(t,r) in outputs.items()):
                conservative_failures.append(ix)
        assert len(conservative_failures) == prior['failing_weak_orders']
        assert not sum(max(f['input'])<=1 for f in failures)
        # A free output snapshot can improve a stated output without an edit.
        best_snapshot_errors = []
        for j in range(5):
            goal = [sorted(x)[j] for x in CASES]
            candidates = [(sum(a!=b for a,b in zip(column,goal)),step,r)
                          for (step,r),column in all_snapshots.items()]
            best_snapshot_errors.append(min(candidates))
        core = [i for i in code if i[0]!='out']
        comparisons = {i for i,(op,d,s) in enumerate(core) if op=='cmp'}
        writes = set(range(len(core)))-comparisons
        # Rank four-position windows by failing-output dependencies and losses.
        # Require a comparison and two writes; retain non-contiguous windows.
        pool = sorted(set(i for i,_ in cone_counts.most_common(10)) |
                      set(i for i,_ in loss_counts.most_common(6)))
        options = [w for w in itertools.combinations(pool,4)
                   if set(w)&comparisons and len(set(w)&writes)>=2 and w[-1]-w[0]>3]
        def score(w):
            return sum(cone_counts[i]+2*loss_counts[i] for i in w)
        options.sort(key=lambda w:(-score(w),w))
        # Greedy coverage avoids sixteen copies of the same three positions.
        chosen,seen_pairs = [],set()
        while options and len(chosen)<16:
            w = max(options,key=lambda v:(sum(tuple(p) not in seen_pairs for p in itertools.combinations(v,2)),score(v),tuple(-i for i in v)))
            options.remove(w)
            chosen.append(list(w))
            seen_pairs.update(itertools.combinations(w,2))
        registers = {r for op,d,s in core for r in (d,s)}
        copied = BASE/'handoff'/path.name
        copied.write_bytes(path.read_bytes())
        row = dict(tag=prior['tag'],path=str(copied),sha256=prior['sha256'],k=len(core),
                   failing_weak_orders=len(conservative_failures),
                   scalar_failing_weak_orders=len(failures),
                   conservative_failing_case_indices=conservative_failures,
                   failing_strict_orders=sum(len(set(f['input']))==5 for f in failures),
                   failing_binary_orders=0,wrong_output_counts=dict(wrong_counts),
                   best_snapshot_errors=best_snapshot_errors,
                   dependency_position_counts=dict(cone_counts),loss_position_counts=dict(loss_counts),
                   register_count=len(registers),repair_registers=len(registers)+1,
                   selected_windows=chosen,failures=failures,
                   prior_strict_judge=prior['judge'])
        rows.append(row)
        for i,w in enumerate(chosen):
            tasks.append(dict(tag=f'{prior["tag"]}_quad{i:02d}',seed=str(copied),
                              window=w,registers=len(registers)+1,seconds=15,
                              assumptions=['G1','G2','G3','G4','A2','A11']))
    (BASE/'handoff/analysis.json').write_text(json.dumps(rows,indent=2)+'\n')
    (BASE/'repair/tasks.json').write_text(json.dumps(tasks,indent=2)+'\n')
    lines = ['# Seven failed k=31 models: handoff for w7-style repair','',
             'All seven models fail the strict out judge. The conservative evaluator reproduces '
             'every prior failure count. It treats unknown scratch values and flags as undefined. '
             'The independent scalar simulator uses scratch value 9 and initial equal flags. '
             'Its counts describe that one initial state. The strict judge records reject strict correctness.','',
             '| Program | Prior conservative failures | Scalar failures | Scalar strict failures | Wrong output counts |',
             '|---|---:|---:|---:|---|']
    for r in rows:
        lines.append(f'| `{Path(r["path"]).name}` | {r["failing_weak_orders"]} | {r["scalar_failing_weak_orders"]} | {r["failing_strict_orders"]} | `{r["wrong_output_counts"]}` |')
    lines += ['',f'{len(tasks)} non-contiguous four-position windows are ready in `round4/repair/tasks.json`. '
              'Each window can change all six opcodes, both operands, and every output snapshot. '
              'Each seed has one additional register. All other instruction positions remain fixed. '
              'The planned solver is the copied w7 rank-value SAT encoder, with the top-scratch initial-state relaxation. '
              'Every candidate requires the strict judge. Each limit is UNKNOWN. '
              'Completed UNSAT certificates will be checked with drat-trim.', '',
              'The exact failure inputs, output dependencies, value-loss positions, and selected windows '
              'are in `round4/handoff/analysis.json`. The copies of all seven programs are in this directory.', '',
              'Assumptions: [A2,A11]. The finite register set limits the exclusion. '
              'The repair search changes the value skeleton; it does not impose A4, A8, A12, or A15.', '']
    (BASE/'handoff/W7_HANDOFF.md').write_text('\n'.join(lines))
    print(json.dumps({'models':len(rows),'failures':[r['failing_weak_orders'] for r in rows],
                      'scalar_failures':[r['scalar_failing_weak_orders'] for r in rows],
                      'repair_windows':len(tasks)}))


if __name__=='__main__':
    main()
