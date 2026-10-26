#!/usr/bin/env python3
"""Audit saved artifacts and append the current round result."""
import collections
import hashlib
import json
import os
from pathlib import Path
import resource
import re

HERE = Path(__file__).resolve().parent
WORKER = HERE.parent


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as src:
        for chunk in iter(lambda: src.read(1024*1024), b''):
            h.update(chunk)
    return h.hexdigest()


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    queries = [json.loads(line) for line in (HERE/'queries.jsonl').read_text().splitlines()]
    jobs = [json.loads(line) for line in (HERE/'jobs.jsonl').read_text().splitlines()]
    assert len({q['tag'] for q in queries}) == len(queries)
    passes = []
    for q in queries:
        assert digest(q['cnf']) == q['cnf_sha256'], q['tag']
        assert digest(HERE/'partial_shapes.py') == q['source_sha256']
        assert digest(HERE/'base_sat.py') == q['base_sha256']
        if q.get('strong_source_sha256'):
            assert digest(HERE/'strong_shapes.py') == q['strong_source_sha256']
        q['solver_statistics'] = {}
        for line in Path(q['tag']+'.solver').read_text().splitlines():
            match = re.match(r'c (conflicts|decisions|propagations):\s+(\d+)', line)
            if match:
                q['solver_statistics'][match[1]] = int(match[2])
        if q.get('validation'):
            v = json.loads(Path(q['validation']).read_text())
            assert len(v['judges']) == 2
            assert v['wrong'] == v['badcmp'] == 0
            for j in v['judges']:
                assert j['returncode'] == 0 and 'PASS ' in j['output']
                assert digest(j['file']) == j['sha256']
                passes.append(dict(query=Path(q['tag']).name, n=v['n'], k=v['k'], **j))
        if q['status'] == 'UNSATISFIABLE':
            prooflog = Path(q['tag']+'.proofcheck.runlog')
            assert q['certificate_verified'] and 's VERIFIED' in prooflog.read_text()
            q['proof_sha256'] = digest(q['tag']+'.drat')
    targets = [q for q in queries if q['n'] == 5 and q['k'] <= 31]
    counts = collections.Counter(q['status'] for q in targets)
    memory = []
    for p in HERE.glob('*.resources'):
        for line in p.read_text().splitlines():
            if 'Maximum resident set size (kbytes):' in line:
                memory.append(int(line.rsplit(':', 1)[1]))
    source_hashes = {p.name: digest(p) for p in HERE.glob('*.py')}
    summary = dict(queries=queries, target_decisions=dict(counts), jobs=jobs, passes=passes,
                   sources=source_hashes, maxrss_kib=max(memory, default=0),
                   summed_child_cpu_seconds=sum(q['child_cpu_seconds'] for q in jobs),
                   all_artifact_hashes_checked=True,
                   transition_audit=json.loads((HERE/'transition_audit.json').read_text()))
    if (HERE/'model_audit.json').exists():
        summary['model_audit'] = json.loads((HERE/'model_audit.json').read_text())
    (HERE/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')
    (HERE/'pass_ledger.json').write_text(json.dumps(passes, indent=2)+'\n')
    lines = ['<!-- ROUND10_BEGIN -->', '# Round 10: three direct partial columns', '',
             'No sort5 program with `k <= 31` has passed the strict judge in this round.',
             'Assumptions: **G1–G4, A15** and the explicit normal forms below.',
             'No assumption was contradicted. No `ASSUMPTION CHALLENGED` line is warranted.', '',
             'A partial column is one written register version with at least one entry',
             'that still holds initial scratch data. Every other written version must',
             'be a min/max function. Comparisons read defined values. The new SAT',
             'encoding leaves all 7,579 lattice shapes free. It has no register cap.',
             'It frees comparison operands, comparison outcomes, sources, destinations,',
             'I1 conditions, block sizes, and output snapshots. No network or term pool',
             'is fixed. No instruction precedes the first comparison.', '',
             'The three worker briefs were read before implementation. This round keeps',
             'undefined entries directly. It does not run w11’s full non-lattice',
             'formulas, w12’s undefined comparisons, or w13’s skeleton routing.',
             'See [round10/SCOPE.md](round10/SCOPE.md) and',
             '[round10/METHODS.md](round10/METHODS.md) for the scope and representation.', '',
             'The main targets require a direct dependency between partial versions.',
             'The existing no-dependency rewrite and d2 result cover the complementary',
             'class. Seven and eight comparisons were not searched again: the existing',
             'lattice-comparison-operand exclusion already covers them in this class.', '',
             '| Target | Comparisons | Orders | Solver CPU seconds | Decision |',
             '| --- | ---: | ---: | ---: | --- |']
    for q in targets:
        lines.append(f'| {Path(q["tag"]).name} | {q["c"]} | {q["orders"]} | '
                     f'{q["solver_cpu_seconds"]:.3f} | {q["status"]} |')
    total_conflicts = sum(q['solver_statistics'].get('conflicts', 0) for q in targets)
    lines += ['', f'Target decisions: {counts.get("UNSATISFIABLE",0)} UNSAT, '
              f'{counts.get("SATISFIABLE",0)} SAT, {counts.get("UNKNOWN",0)} UNKNOWN.',
              f'The target logs record {total_conflicts:,} solver conflicts in total.',
              'Only a completed UNSAT query is an exhaustive negative for its saved formula.',
              'Each limit remains unknown. The three-partial family is not exhausted.', '',
              'The stronger queries require every partial column to have both a defined',
              'and an undefined entry and to be read later. Every comparison must control',
              'a conditional move. They also require different complete flag histories',
              'on different strict input orders. The seven topology masks are the',
              'nonempty subsets of edges 0→1, 0→2, and 1→2. They partition the stronger',
              'three-column dependency family; limited masks remain unknown.', '',
              'Strict-order queries count partial versions on 120 strict orders only.',
              'They can omit a version that is undefined only on ties. They are explicit',
              'subclasses, not a complete replacement for the 541-order query.', '',
              'The independent transition audit tested **96 instruction streams** and',
              '**1,012 opposite-value probes**. Every scalar value and defined bit agreed.',
              'It includes all four I1 conditions, equality comparisons, unknown sources,',
              'partial copies, and overwrites. This is validation evidence, not a proof.', '',
              'The negative controls all completed. A separate DRAT checker accepted',
              'every recorded UNSAT certificate. The controls reject a two-partial bound',
              'for a pinned three-partial program. They also exhaust the two-input,',
              'one-comparison, k=5, exactly-three-partial formula. Its count is zero.',
              'A k=6 control in that class passed the strict judge. These small controls',
              'do not establish a sort5 lower bound.', '',
              'Every new strict PASS file is listed below. Each memory file has length',
              '`k + 2n`. These are controls, not improvements to the sort5 record.', '']
    if 'model_audit' in summary:
        audit = summary['model_audit']
        lines += [f'The SAT-model audit checked {audit["values_checked"]:,} intermediate',
                  f'values and {audit["comparisons_checked"]:,} comparison outcomes against',
                  f'the independent scalar trace of {audit["programs"]} controls. All agreed.', '']
    for p in passes:
        rel = Path(p['file']).relative_to(WORKER)
        lines.append(f'- [{rel}]({rel}): n={p["n"]}, k={p["k"]}, {p["command"][-1]}.')
    lines += ['', 'The exact PASS outputs and hashes are in',
              '[round10/pass_ledger.json](round10/pass_ledger.json). Formula hashes,',
              'certificate records, commands, source hashes, and coverage are in',
              '[round10/summary.json](round10/summary.json).', '',
              f'Largest recorded resident memory: **{summary["maxrss_kib"]:,} KiB**.',
              f'Recorded child CPU use: **{summary["summed_child_cpu_seconds"]:.3f} seconds**.',
              'All CPU jobs ran serially at `nice -n 19`. The encoder address-space limit',
              'was 2,400 MiB. All writes stayed in w1.', '',
              'The smallest strict-verified sort5 core remains k=32. The general A15',
              'statement and global optimality remain open.', '',
              'Reproduction phases: `nice -n 19 python3 round10/run.py controls`,',
              '`primary`, `strong`, and `sweep`. The transition audit is',
              '`nice -n 19 python3 round10/audit.py`. The report command is',
              '`nice -n 19 python3 round10/report.py`. Use a clean output folder before',
              'rerunning a phase; the journals append records.',
              '<!-- ROUND10_END -->']
    results = WORKER/'RESULTS.md'
    old = results.read_text()
    first, last = '<!-- ROUND10_BEGIN -->', '<!-- ROUND10_END -->'
    if first in old:
        a, b = old.index(first), old.index(last)+len(last)
        old = old[:a]+'\n'.join(lines)+old[b:]
    else:
        old += '\n\n'+'\n'.join(lines)+'\n'
    tmp = WORKER/'RESULTS.round10.tmp'
    tmp.write_text(old)
    tmp.replace(results)
    print(json.dumps(dict(queries=len(queries), targets=dict(counts), passes=len(passes),
                          maxrss_kib=summary['maxrss_kib'], hashes_checked=True)), flush=True)


if __name__ == '__main__':
    main()
