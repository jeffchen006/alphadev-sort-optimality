#!/usr/bin/env python3
"""Serial follow-up using the proved garbage-removal relaxation. Use nice 19."""
import json
from pathlib import Path
import resource
import sys

import round4_run as runner

HERE = Path(__file__).resolve().parents[1]
ROUND = HERE/'round4full'
runner.ROUND = ROUND


def save(summary):
    (ROUND/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')
    lines = ['<!-- ROUND4_FULL_BEGIN -->',
             '## Round 4 extension: full columns after garbage removal [A4, A15]', '',
             'The construction in `round4/ONE_COLUMN_LEMMA.md` maps the three-partial-column',
             'gap into full programs with at most three non-lattice written columns.',
             'Comparison operands and required output columns remain lattice.',
             'The extension searches this larger, fully defined class. Its method is in',
             '`round4full/METHOD.md`. A limit means UNKNOWN.', '',
             '| query | k | bound | flags | solver result | program count |',
             '|---|---:|---:|---|---|---:|']
    passes, found = [], []
    for q in summary['queries']:
        tag = Path(q['tag'])
        count = q['exhaustive_program_count']
        lines.append(f"| {tag.name} | {q['k']} | {q['bound']} | "
                     f"{'fixed' if q['flag_program'] else 'free'} | {q['status']} | "
                     f"{count if count is not None else 'unknown'} |")
        validation = Path(str(tag)+'.validation.json')
        if validation.exists():
            v = json.loads(validation.read_text())
            if len(v['judges']) == 2 and all(x['returncode'] == 0 and 'PASS ' in x['output'] for x in v['judges']):
                files = [str(Path(x['file']).relative_to(HERE)) for x in v['judges']]
                passes.append((q['k'], files))
                if q['k'] <= 31:
                    found.append(f"FOUND k={q['k']} n=5 out={files[0]} mem={files[1]} strict=PASS")
    lines += ['', 'Strict judge PASS files in this extension:', '']
    lines += [f'- k={k}: `{files[0]}` and `{files[1]}`.' for k, files in passes]
    lines += ['', 'Certificate records:', '']
    lines += [f"- `{Path(p['log']).name}`: {p['checker_status']}."
              for p in summary['certificates']]
    lines += ['', 'Counts apply to the saved formulas. Fixed flag outcomes cover one family.',
              'The free-outcome query has c=9, the first input pair fixed, and input and',
              'comparison symmetries. Both queries use 120 strict orders and free block sizes.',
              'They do not cover comparisons of undefined scratch values, data before the',
              'first comparison, or other comparison counts. The general A15 claim remains open.',
              '<!-- ROUND4_FULL_END -->']
    path = HERE/'RESULTS.md'
    text = path.read_text()
    begin, end = '<!-- ROUND4_FULL_BEGIN -->', '<!-- ROUND4_FULL_END -->'
    if begin in text:
        a, b = text.index(begin), text.index(end)+len(end)
        text = text[:a]+'\n'.join(lines)+text[b:]
    else:
        text += '\n'+'\n'.join(lines)+'\n'
    for line in reversed(found):
        if line not in text:
            text = line+'\n'+text
    temporary = HERE/'RESULTS.full.tmp'
    temporary.write_text(text)
    temporary.replace(path)


def query(summary, name, extra, seconds=600, expected=None):
    tag = ROUND/name
    cmd = [sys.executable, HERE/'src/full_gap.py', '--tag', tag,
           '--timeout', str(seconds), '--proof']+extra
    execution = runner.run(cmd, name, seconds+45)
    assert execution['returncode'] == 0, execution
    q = json.loads(Path(str(tag)+'.json').read_text())
    if expected:
        assert q['status'] == expected, q
    if q['status'] == 'SATISFIABLE':
        checked = runner.run([sys.executable, HERE/'src/partial_validate.py', str(tag)+'.s'],
                             name+'.judge', 90)
        q['validation_returncode'] = checked['returncode']
    summary['queries'].append(q)
    save(summary)
    if q['status'] == 'SATISFIABLE':
        assert q['validation_returncode'] == 0, 'SAT candidate failed strict verification; refine on weak orders'
    if q['status'] == 'UNSATISFIABLE':
        summary['certificates'].append(runner.check_proof(Path(str(tag)+'.cnf'),
                                                        Path(str(tag)+'.drat'), name,
                                                        30 if expected else 300))
        save(summary)


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    assert (HERE/'round4/final_report.json').exists(), 'Finish and audit the preceding serial queue first'
    ROUND.mkdir(exist_ok=True)
    summary = dict(queries=[], certificates=[])
    save(summary)
    for name, source, bound, expected in [
            ('control_one_exception', 'exception_0_eliminated.s', '3', 'SATISFIABLE'),
            ('control_pure', 'exception_0_normalized.s', '0', 'SATISFIABLE'),
            ('reject_nonlat_bound0', 'exception_0_eliminated.s', '0', 'UNSATISFIABLE')]:
        query(summary, name, ['--k', '32', '--free-first', '--bound', bound,
                              '--fixed', str(HERE/'programs'/source)],
              seconds=60, expected=expected)
    query(summary, 'n5_k31_full3_fixedflags', ['--free-first', '--flag-program',
                                            str(HERE/'programs/exception_0_original.s')])
    query(summary, 'n5_k31_full3_freeflags', [])
    summary['complete'] = True
    save(summary)


if __name__ == '__main__':
    main()
