#!/usr/bin/env python3
"""Run the new A15 jobs serially, after the one-hour sort4 retry.

Launch with nice -n 19. Do not start while sort4 is running.
Every child has an address-space limit below 3 GB.
"""
import hashlib
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parents[1]
PROJECT = HERE.parents[3]
ROUND = HERE/'round4'


def save(summary):
    (ROUND/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')
    lines = ['<!-- ROUND4_LIVE_BEGIN -->',
             '### Round 4 live result record [A4, A15]', '',
             'This block is updated after each completed query. A limit means UNKNOWN.',
             'The general A15 claim remains open unless a counterexample is separately established.', '',
             'Sort4 one-hour retry: '+summary['sort4']['status']+'.',
             'Sort4 verified upper bound in this worker: k=20, c=5, unless a new strict PASS is listed below.', '',
             '| query | n | k | c | mode | solver result | exhaustive satisfying-program count |',
             '|---|---:|---:|---:|---|---|---:|']
    passes, found = [], []
    for result in summary['queries']:
        tag = Path(result['tag'])
        count = result['exhaustive_program_count']
        lines.append(f"| {tag.name} | {result['n']} | {result['k']} | {result['c']} | "
                     f"{result['mode']} | {result['status']} | {count if count is not None else 'unknown'} |")
        validation = Path(str(tag)+'.validation.json')
        if validation.exists():
            value = json.loads(validation.read_text())
            judges = value.get('judges', [])
            if len(judges) == 2 and all(x['returncode'] == 0 and 'PASS' in x['output'] for x in judges):
                files = [str(Path(x['file']).relative_to(HERE)) for x in judges]
                passes.append((result['k'], files))
                if result['n'] == 5 and result['k'] <= 31:
                    found.append(f"FOUND k={result['k']} n=5 out={files[0]} mem={files[1]} strict=PASS")
    lines += ['', 'A zero count applies only to the saved bounded formula.',
              'The formula scope and remaining limits are in `round4/METHOD.md`.', '']
    if passes:
        lines += ['New strict judge PASS files in this round:', '']
        lines += [f'- k={k}: `{files[0]}` and `{files[1]}`.' for k, files in passes]
        lines += ['']
    lines += ['Certificate records completed so far:', '']
    lines += [f"- `{Path(x['log']).name}`: "
              f"{'VERIFIED' if x['verified'] else x['checker_status']}."
              for x in summary['certificates']]
    lines += ['', '<!-- ROUND4_LIVE_END -->']
    path = HERE/'RESULTS.md'
    text = path.read_text()
    begin, end = '<!-- ROUND4_LIVE_BEGIN -->', '<!-- ROUND4_LIVE_END -->'
    if begin in text:
        a, b = text.index(begin), text.index(end)+len(end)
        text = text[:a]+'\n'.join(lines)+text[b:]
    else:
        text += '\n'+'\n'.join(lines)+'\n'
    for entry in reversed(found):
        if entry not in text:
            text = entry+'\n'+text
    temporary = HERE/'RESULTS.round4.tmp'
    temporary.write_text(text)
    temporary.replace(path)


def file_hash(path):
    value = hashlib.sha256()
    with path.open('rb') as source:
        for chunk in iter(lambda: source.read(1024*1024), b''):
            value.update(chunk)
    return value.hexdigest()


def run(command, name, timeout):
    log = ROUND/(name+'.runlog')
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    start = time.monotonic()
    with log.open('w') as out:
        p = subprocess.Popen(list(map(str, command)), stdout=out,
                             stderr=subprocess.STDOUT, start_new_session=True)
        try:
            code = p.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            # Kill the encoder and any solver it launched before another job.
            os.killpg(p.pid, signal.SIGTERM)
            try:
                p.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(p.pid, signal.SIGKILL)
                p.wait()
            code = 124
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record = dict(command=list(map(str, command)), returncode=code,
                  elapsed_seconds=time.monotonic()-start,
                  cpu_seconds=(after.ru_utime-before.ru_utime)+
                              (after.ru_stime-before.ru_stime),
                  maxrss_kib=after.ru_maxrss, log=str(log))
    with (ROUND/'campaign.log').open('a') as out:
        out.write(json.dumps(record)+'\n')
    print(json.dumps(record), flush=True)
    return record


def gap(name, *extra, timeout=300, expected=None):
    tag = ROUND/name
    cmd = [sys.executable, HERE/'src/partial_gap.py', '--tag', tag,
           '--timeout', str(timeout), '--proof']+list(extra)
    execution = run(cmd, name, timeout+45)
    result_path = Path(str(tag)+'.json')
    assert execution['returncode'] == 0 and result_path.exists(), execution
    result = json.loads(result_path.read_text())
    if expected:
        assert result['status'] == expected, result
    if result['status'] == 'SATISFIABLE':
        validation = run([sys.executable, HERE/'src/partial_validate.py', str(tag)+'.s'],
                         name+'.judge', 90)
        result['validation_returncode'] = validation['returncode']
    return result


def check_proof(cnf, proof, name, seconds):
    cmd = [PROJECT/'bin/drat-trim', cnf, proof, '-t', str(seconds)]
    record = run(cmd, name+'.proofcheck', seconds+15)
    log = Path(record['log']).read_text()
    record.update(cnf_sha256=file_hash(cnf),
                  proof_sha256=file_hash(proof),
                  verified=record['returncode'] == 0 and 's VERIFIED' in log,
                  checker_status=next((x for x in log.splitlines() if x.startswith('s ')),
                                      'UNKNOWN'))
    (ROUND/(name+'.proofcheck.json')).write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)
    return record


def deduplicate_cnf(source, target):
    """Remove repeated literals, true clauses, and repeated clauses only."""
    start = time.monotonic()
    unique = set()
    raw, true_clauses, repeated_clauses = 0, 0, 0
    with source.open() as inp:
        header = inp.readline().split()
        assert header[:2] == ['p', 'cnf']
        variables, declared = map(int, header[2:])
        for line in inp:
            entries = list(map(int, line.split()))
            assert entries[-1] == 0 and 0 not in entries[:-1]
            raw += 1
            lits = set(entries[:-1])
            if any(-x in lits for x in lits):
                true_clauses += 1
                continue
            clause = tuple(sorted(lits))
            if clause in unique:
                repeated_clauses += 1
            else:
                unique.add(clause)
    assert raw == declared
    with target.open('w') as out:
        out.write(f'p cnf {variables} {len(unique)}\n')
        for clause in sorted(unique):
            out.write(' '.join(map(str, clause))+' 0\n')
    result = dict(source=str(source), target=str(target), raw_clauses=raw,
                  unique_clauses=len(unique), true_clauses=true_clauses,
                  repeated_clauses=repeated_clauses,
                  source_sha256=file_hash(source), target_sha256=file_hash(target),
                  elapsed_seconds=time.monotonic()-start,
                  relation='Identical conjunction after removal of repetitions and true clauses')
    target.with_suffix('.normalization.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result), flush=True)
    return result


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    # The gate can observe the new path just before its small JSON write.
    for attempt in range(50):
        try:
            retry = json.loads((ROUND/'sort4_retry.json').read_text())
            break
        except json.JSONDecodeError:
            if attempt == 49:
                raise
            time.sleep(0.1)
    assert retry['status'] in ('UNKNOWN', 'UNSATISFIABLE', 'SATISFIABLE')
    summary = dict(sort4=retry, queries=[], certificates=[])
    save(summary)
    if retry['status'] == 'SATISFIABLE':
        # Rebuild only to decode this solver's assignment; no second SAT run.
        sys.path.insert(0, str(HERE/'src'))
        from partial_sym import SymEncoding
        import itertools
        enc = SymEncoding(4, 19, 5, list(itertools.permutations(range(4))),
                          'partial', first_pair=True, must_partial=True, origin=True)
        enc.strengthen()
        model = [int(x) for line in (ROUND/'sort4_retry.solver').read_text().splitlines()
                 if line.startswith('v ') for x in line[2:].split() if int(x)]
        yes = {x for x in model if x > 0}
        assert all(any((x in yes) if x > 0 else (-x not in yes) for x in cl)
                   for cl in enc.cs)
        (ROUND/'sort4_retry.s').write_text(enc.decode(model))
        run([sys.executable, HERE/'src/partial_validate.py', ROUND/'sort4_retry.s'],
            'sort4_retry.judge', 90)
        del enc
    # Controls exercise the exact partial-column counter and guarded lattice test.
    common = ['--k', '32', '--c', '9', '--free-first']
    controls = [
        ('gap_control_partial', 'gap', 'exception_0_original.s', '3', 'SATISFIABLE'),
        ('gap_control_pure', 'pure', 'exception_0_normalized.s', '3', 'SATISFIABLE'),
        ('gap_reject_partial_bound1', 'gap', 'exception_0_original.s', '1', 'UNSATISFIABLE'),
        ('gap_reject_partial_pure', 'pure', 'exception_0_original.s', '3', 'UNSATISFIABLE'),
        ('gap_reject_nonlattice', 'gap', 'c8_guard_0_0.s', '3', 'UNSATISFIABLE'),
        ('arbitrary_control_c8', 'arbitrary', 'c8_guard_0_0.s', '3', 'SATISFIABLE')]
    for name, mode, filename, bound, expected in controls:
        extra = list(common)
        if filename.startswith('c8'):
            extra[extra.index('9')] = '8'
        result = gap(name, *extra, '--mode', mode, '--bound', bound,
                      '--fixed', str(HERE/'programs'/filename),
                      timeout=60, expected=expected)
        summary['queries'].append(result)
        if result['status'] == 'UNSATISFIABLE':
            tag = ROUND/name
            summary['certificates'].append(check_proof(Path(str(tag)+'.cnf'),
                                                       Path(str(tag)+'.drat'), name, 30))
        save(summary)
    save(summary)
    # New scope: all 22 data-block assignments and all 1..3 partial-node choices
    # are free. Only flag columns are fixed in the first query. No block query
    # completed in round 2 is repeated here.
    jobs = [
        ('n5_k31_gap3_fixedflags_freeblocks',
         ['--mode', 'gap', '--free-first', '--flag-program',
          str(HERE/'programs/exception_0_original.s')], 600),
        ('n5_k31_gap3_freeflags', ['--mode', 'gap'], 600),
        ('n5_k31_arbitrary3_fixedflags_freeblocks',
         ['--mode', 'arbitrary', '--free-first', '--flag-program',
          str(HERE/'programs/exception_0_original.s')], 600),
        ('n5_k31_c8_arbitrary3_fixedflags_freeblocks',
         ['--mode', 'arbitrary', '--c', '8', '--free-first', '--flag-program',
          str(HERE/'programs/c8_guard_0_0.s')], 600)]
    for name, extra, seconds in jobs:
        result = gap(name, *extra, timeout=seconds)
        summary['queries'].append(result)
        save(summary)
        if result['status'] == 'UNSATISFIABLE':
            tag = ROUND/name
            summary['certificates'].append(check_proof(Path(str(tag)+'.cnf'),
                                                       Path(str(tag)+'.drat'), name, 600))
            save(summary)
        if name == 'n5_k31_gap3_fixedflags_freeblocks' and result['status'] == 'UNKNOWN':
            # Eight new block vectors. The ninth was already UNSAT without
            # the three-column cap in round 2, so it is not solved again.
            base = [3, 6, 2, 2, 2, 2, 2, 2, 2]
            for removed in range(9):
                if removed == 1:
                    continue
                counts = list(base)
                counts[removed] -= 1
                subname = 'n5_k31_gap3_delete_block'+str(removed)
                extra = ['--mode', 'gap', '--free-first', '--flag-program',
                         str(HERE/'programs/exception_0_original.s'), '--blocks',
                         ','.join(map(str, counts))]
                subresult = gap(subname, *extra, timeout=120)
                summary['queries'].append(subresult)
                save(summary)
                if subresult['status'] == 'UNSATISFIABLE':
                    subtag = ROUND/subname
                    summary['certificates'].append(check_proof(Path(str(subtag)+'.cnf'),
                                                               Path(str(subtag)+'.drat'),
                                                               subname, 120))
                    save(summary)
    # This retry verifies the existing certificate; it does not repeat synthesis.
    # Keep it after the new sort5 work requested in the latest round.
    old = HERE/'round2/n5_k31_partial_flags_blocks'
    checked = check_proof(Path(str(old)+'.cnf'), Path(str(old)+'.drat'),
                          old.name+'_long', 1800)
    summary['certificates'].append(checked)
    if not checked['verified']:
        dedup = ROUND/(old.name+'_dedup.cnf')
        summary['certificate_normalization'] = deduplicate_cnf(Path(str(old)+'.cnf'), dedup)
        summary['certificates'].append(check_proof(dedup, Path(str(old)+'.drat'),
                                                   old.name+'_dedup', 300))
    save(summary)


if __name__ == '__main__':
    main()
