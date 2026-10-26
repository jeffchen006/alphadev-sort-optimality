"""Audit saved class identities, solver records, and strict control logs."""
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import resource
import sys

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parents[1]
BASE = HERE.parent


def rows(path):
    return [json.loads(s) for s in path.read_text().splitlines() if s.strip()] if path.exists() else []


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    queue = json.loads((HERE/'artifacts/queue.json').read_text())
    original = json.loads((BASE/'round4/artifacts/structure_classes.json').read_text())
    by_class = {t['class_id']: t for t in queue}
    assert len(queue) == len(by_class) == len(original) == 306
    for c in original:
        t = by_class[c['class_id']]
        assert t['signature'] == c['signature'] and t['members'] == c['members']
        assert t['queue_index'] in c['members']
        assert hashlib.sha256(Path(t['item']['row']['source']).read_bytes()).hexdigest() == t['item']['source_sha256']
    results = rows(HERE/'artifacts/class_results.jsonl')
    assert len(results) == len({r['class_id'] for r in results})
    for r in results:
        t = by_class[r['class_id']]
        old = t['item']['previous']
        assert r['queue_index'] == t['queue_index']
        assert r['class_signature'] == t['signature']
        assert r['class_members'] == t['members']
        assert r['order'] == old['order'] and r['family'] == old['family']
        assert r['k'] == old['k'] and r['regs'] == old['regs']
        assert r['prefix_length'] == len(t['item']['prefix'])
        assert r['positions'] == old.get('positions')
        assert r['polarity'] == old.get('polarity', False)
        assert r['origin_cuts'] and r['limit_seconds'] == 900
        assert r['seed_cases'] == t['seed_cases']
        assert r['source_sha256'] == t['item']['source_sha256']
        calls = r['stats']['solver_calls']
        for call in calls:
            raw = Path(call['raw_log']).read_text()
            if call['status'] == 'UNSAT':
                assert call['returncode'] == 20 and 's UNSATISFIABLE' in raw
            if call['status'] == 'SAT':
                assert call['returncode'] == 10 and 's SATISFIABLE' in raw
                assert call['cnf_model_checked']
        if r['status'] == 'UNSAT':
            assert calls and calls[-1]['status'] == 'UNSAT'
        if r['status'] == 'UNKNOWN':
            assert not calls or calls[-1]['status'] != 'UNSAT'
    controls = json.loads((HERE/'artifacts/controls.json').read_text())
    ledger = []
    for r in controls + results:
        if not r.get('strict_pass'):
            continue
        for path, model, log in [(r['path'], 'out', r['models'][-1]['judge_log']),
                                 (r['memory_path'], 'mem', r['memory_strict_log'])]:
            p = Path(path)
            data = p.read_bytes()
            retained = HERE/'verified'/p.name
            assert data == retained.read_bytes()
            output = Path(log).read_text()
            assert 'PASS ' in output and '[relaxed+strict]' in output and f'model={model}' in output
            ledger.append(dict(path=path, retained_copy=str(retained), model=model,
                k=r['k'], sha256=hashlib.sha256(data).hexdigest(), judge_log=log, judge_output=output.strip()))
    # Original-query counts use a union of indices, so reruns never double count.
    resolved = {r['queue_index'] for r in rows(BASE/'round3/artifacts/kissat_unknown.jsonl') if r['status']=='UNSAT'}
    resolved.update(r['queue_index'] for r in rows(BASE/'round4/artifacts/top100.jsonl') if r['status']=='UNSAT')
    resolved.update(r['queue_index'] for r in results if r['status']=='UNSAT')
    result = dict(checked_classes=len(original), recorded_results=len(results),
        unrun=306-len(results), statuses=dict(Counter(r['status'] for r in results)),
        status_by_information_filter={str(valid): dict(Counter(r['status'] for r in results if r['weak_filter']['valid']==valid)) for valid in (False, True)},
        original_795_configuration_ledger=dict(UNSAT=94+len(resolved), UNKNOWN=701-len(resolved)),
        controls=len(controls), strict_pass_ledger=ledger,
        candidate_models=sum(len(r.get('models', [])) for r in results),
        note='This audit checks saved identities and raw solver status, not an UNSAT certificate or the encoder semantics.')
    (HERE/'artifacts/audit.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='strict_pass_ledger'}), flush=True)


if __name__ == '__main__':
    main()
