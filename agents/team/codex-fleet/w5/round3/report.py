"""Append the completed round-3 result. Preserve rounds 1 and 2."""
from pathlib import Path
import hashlib
import json
import re

HERE = Path(__file__).resolve().parent


def counts(name):
    log = HERE/'logs'/(name+'.log')
    text = log.read_text()
    done = next(line for line in text.splitlines() if line.startswith('DONE '))
    result = {key: float(value) if '.' in value else int(value)
              for key, value in re.findall(r'(\w+)=([0-9.]+)', done)}
    result['log'] = str(log.relative_to(HERE.parent))
    return result


manifest = json.loads((HERE/'manifest.json').read_text())
summary = dict(
    sources=len(manifest),
    mov_histogram={str(m): sum(row['mov'] == m for row in manifest) for m in range(6)},
    scans={name: counts(name) for name in ['two_mov_insert', 'two_mov_source_insert',
           'near14_exact2', 'near30_exact2', 'near14_exact2_scored', 'near14_suffix_cmp2cmov']},
    solver_jobs=json.loads((HERE/'standalone_status.json').read_text()),
    batch=json.loads((HERE/'solver_batch.json').read_text()),
    second_batch=json.loads((HERE/'second_batch.json').read_text()),
    encoder_check=json.loads((HERE/'logs/rank_transition_check.log').read_text()),
)
assert len(summary['batch']) == 5
assert summary['second_batch'][-1]['name'] == 'rank_near14_general3'
if (HERE/'extra_solver.json').exists():
    summary['extra_solver'] = json.loads((HERE/'extra_solver.json').read_text())
ledger = [json.loads(line) for line in (HERE/'judge_ledger.jsonl').read_text().splitlines()]
summary['passes'] = list({row['file']: row for row in ledger if row['passed']}.values())
summary['found'] = [row for row in summary['passes'] if row['model'] == 'out' and row['k'] <= 31]
assert not summary['found'], 'A short program was found; write its positive result first.'
summary['source_hashes'] = {str(path): hashlib.sha256(path.read_bytes()).hexdigest()
                             for path in HERE.glob('*.py')}
summary['source_hashes'].update({str(path): hashlib.sha256(path.read_bytes()).hexdigest()
                                for path in HERE.glob('*.cpp')})
for seed in ['near14_frozen', 'b31a_near']:
    path = HERE.parent.parent/'w6/round2/candidates'/(seed+'.s')
    summary.setdefault('near_seed_hashes', {})[str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
(HERE/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')

text = '''

### Round-3 completed result

No k<=31 program received a strict judge PASS. No new near-miss improved the 14-case seed.

The additional finite suffix scan changes one CMP and two conditional moves. The first 15 instructions stay fixed. Each changed CMP can choose either operand. Each changed conditional move can choose either operand and any of the four conditions. The scan uses all seed registers and one fresh register. Outputs can select new snapshots. All 264 eligible instruction triples finished. The scan tested 2,203,428,480 candidates. None passed the 16-case concrete filter. See `round3/logs/near14_suffix_cmp2cmov.log`.

The near-miss scoring check rescored the 638 filter survivors from the 14-case seed's two-instruction repair scan. It selected the least-error snapshot for each output on all 541 weak orders. None improved the seed's 18 output errors across 14 failed weak orders. This check repeats the 109,394,660 candidate enumeration for scoring. Its counts overlap the earlier scan. See `round3/logs/near14_exact2_scored.log`.

The second SAT transition encoding represents concrete ranks with three bits. It uses the same instruction selectors as the first encoder. Its transition relation is separate. A scalar execution check covered 80 random programs and 400 input cases. All 7,200 instruction-result values matched. The solver rejected 80 deliberately wrong result bits. These checks validate sampled behavior; they are not a proof of the encoder.

The solver results below include all completed queries and time limits. Each query uses a fixed finite register alphabet. Initial scratch values are one top sentinel, and initial flags are equal. Outputs are free snapshots except where stated. UNSAT concerns only the stated query. A time limit is unknown.

| Query | Result | Seconds or wall limit | Log |
|---|---|---:|---|
| 14-case seed; at most two complete instruction changes | UNSAT, 26 weak orders | 143.23 | `round3/logs/near14_general2.log` |
| 14-case seed; at most three complete instruction changes | unknown, time limit | 900 | `round3/logs/near14_general3.log` |
'''
labels = {
    'near14_sources_all': '14-case seed; all sources, CMP operands, and predicates free; write destinations and classes fixed',
    'near14_suffix4': '14-case seed; at most four complete suffix changes; first 15 instructions and output snapshots fixed',
    'near14_classes4': '14-case seed; at most four changes with instruction classes fixed',
    'near30_general3': '30-case seed; at most three complete instruction changes',
    'near14_general4': '14-case seed; at most four complete instruction changes',
    'rank_near14_general3': '14-case seed; at most three complete changes; three-bit transition encoder',
    'rank_near14_suffix6': '14-case seed; at most six complete suffix changes; first 15 instructions and output snapshots fixed; three-bit encoder',
}
jobs = summary['batch'] + [summary['second_batch'][-1]] + summary.get('extra_solver', [])
for row in jobs:
    name = row['name']
    log = str(Path(row['log']).relative_to(HERE.parent))
    status = 'unknown, time limit' if row['status'] == 'TIMEOUT' else row['status']
    duration = row['cap'] if row['status'] == 'TIMEOUT' else round(row['seconds'], 2)
    text += f'| {labels[name]} | {status} | {duration} | `{log}` |\n'
text += '''
Every new strict PASS file is listed below. Both controls retain k=32. Their memory versions retain 42 instructions. They do not meet the requested length of 41.

| PASS file | Model | Length | Judge log |
|---|---|---:|---|
'''
for row in sorted(summary['passes'], key=lambda r: r['file']):
    file = str(Path(row['file']).relative_to(HERE.parent))
    log = str(Path(row['log']).relative_to(HERE.parent))
    text += f'| [{file}]({file}) | {row["model"]} | {row["k"]+(10 if row["model"] == "mem" else 0)} | `{log}` |\n'
text += '''
The conservative full simulator can reject programs that depend on correlations involving scratch values. No such rejected candidate is treated as a strict PASS. The 16-case filter is a concrete necessary-condition check with scratch=7 and equal initial flags. No global lower bound follows from these bounded searches. The requested shorter program remains unfound in this round.

All scan counts, solver commands, source hashes, and retained strict PASS paths are in `round3/summary.json`. The judge ledger is `round3/judge_ledger.jsonl`. All round-3 processes have finished.
'''
results = HERE.parent/'RESULTS.md'
original = results.read_text()
assert '### Round-3 completed result' not in original
original = original.replace('This round is in progress. No k<=31 program has received a strict judge PASS.',
                            'This round completed. No k<=31 program received a strict judge PASS.')
original = original.replace('A three-instruction query and further source and suffix repairs are running. A timeout will be recorded as unknown.',
                            'The three-instruction query and further source and suffix repairs ran with wall limits. The completed results appear below.')
results.write_text(original+text)
print(json.dumps(dict(passes=len(summary['passes']), found=len(summary['found']),
                      scans=summary['scans'], solver_results=[(r['name'], r['status']) for r in jobs]), indent=2))
