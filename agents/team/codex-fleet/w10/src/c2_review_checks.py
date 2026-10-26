#!/usr/bin/env python3
"""Independent review checks after the four short-pass jobs have finished."""
import json
import os
import shutil

import c2_short as work
import threshold_check


def main():
    assert os.nice(0) >= 19
    dest = work.DEST / 'review_checks'
    dest.mkdir(exist_ok=True)
    report = dict(created=work.stamp(), cube_cover_checks=[],
                  finite_arithmetic_check=threshold_check.check())
    for meta_path in sorted((work.D2 / 'cubes').glob('*.cover.json')):
        meta = json.loads(meta_path.read_text())
        source_cnf = work.D2 / meta['cover_cnf']
        source_proof = work.D2 / meta['cover_proof']
        assert work.sha(source_cnf) == meta['cover_cnf_sha256']
        cnf = dest / source_cnf.name
        proof = dest / source_proof.name
        shutil.copyfile(source_cnf, cnf)
        shutil.copyfile(source_proof, proof)
        run = work.run([work.PROJECT / 'bin/lrat-check', cnf, proof],
                       dest / (meta['case']+'.cover.check.log'), 300)
        text = work.Path(run['log']).read_text()
        verified = run['returncode'] == 0 and any(
            line.strip() == 'c VERIFIED' for line in text.splitlines())
        report['cube_cover_checks'].append(dict(case=meta['case'],
            cubes=meta['cubes'], verified=verified, checker=run,
            cnf_sha256=work.sha(cnf), proof_sha256=work.sha(proof)))
    report['source_hashes'] = {name: work.sha(work.HERE / 'src' / name)
        for name in ('c2_review_checks.py', 'threshold_check.py')}
    work.save(dest / 'report.json', report)
    with (work.HERE / 'RESULTS.md').open('a') as f:
        f.write('\n### C2 independent review checks [A15]\n\n')
        arithmetic = report['finite_arithmetic_check']
        f.write(f"The finite arithmetic check examined {arithmetic['full_columns']} "
                f"full n=3 strict-order columns. It found "
                f"{arithmetic['lattice_columns']} lattice columns. "
                'It reported zero representation disagreements. '
                f"It checked {arithmetic['comparison_cases']} comparison cases and "
                f"{arithmetic['conditional_copy_cases']} conditional-copy cases. "
                'These are finite implementation checks, not a general proof.\n\n')
        for check in report['cube_cover_checks']:
            f.write(f"Independent LRAT coverage check: {check['case']}, "
                    f"{check['cubes']} cubes, "
                    f"{'VERIFIED' if check['verified'] else 'INCOMPLETE'}.\n\n")
        f.write('The coverage certificate checks the split. It does not decide '
                'the position formula or any cube. Copied formulas, certificates, '
                'hashes, and checker logs are in `c2_short/review_checks/`.\n')
    print(json.dumps(report, indent=2))
    assert all(check['verified'] for check in report['cube_cover_checks'])


if __name__ == '__main__':
    main()
