#!/usr/bin/env python3
"""Complete the certificate inventory after the separate revision-2 replay."""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess

from certify_c2 import CHECKER
from independent_c2 import sha
from prefix_campaign import HERE
from replay_c2 import replay_record


def main():
    prior = HERE/'logs/replay_revision2.log'
    audited = [json.loads(line) for line in prior.read_text().splitlines() if line.strip()]
    assert len(audited) == 4 and all(item['reran_checker'] for item in audited)
    assert sum(item['counts']['UNSAT_VERIFIED'] for item in audited) == 314
    # A prior auxiliary pass stopped on a JSON list, after it had checked some
    # certificates. Keep those checks. Complete the remainder here.
    previous = set()
    old = HERE/'logs/replay_other_certificates.log'
    if old.exists():
        for line in old.read_text().splitlines():
            if line.startswith('{'):
                item = json.loads(line)
                if item.get('status') == 'REPLAY_VERIFIED':
                    previous.add(item['record'])
    folders = ['cases', 'cases_v2', 'controls', 'controls_v2', 'sort3_controls',
               'peer_adapter_controls', 'no_comparison']
    inventory, counts = [], {}
    base_hashes = {}
    for group in folders:
        counts[group] = 0
        for path in sorted((HERE/'independent'/group).rglob('*.json')):
            record = json.loads(path.read_text())
            if not isinstance(record, dict) or record.get('status') != 'UNSAT_VERIFIED':
                continue
            if group == 'no_comparison':
                formula, proof = path.with_suffix('.cnf'), path.with_suffix('.drat')
                assert sha(formula) == record['cnf_sha256']
                assert sha(proof) == record['proof_sha256']
                proc = subprocess.run([str(CHECKER), str(formula), str(proof)],
                                      capture_output=True, text=True)
                assert proc.returncode == 0 and 's VERIFIED' in proc.stdout.splitlines()
                how = 'CHECKER_RERUN'
            elif group == 'cases_v2':
                base = Path(record['base'])
                meta_path = Path(str(base)+'.json')
                meta = json.loads(meta_path.read_text())
                if str(base) not in base_hashes:
                    base_hashes[str(base)] = sha(str(base)+'.cnf')
                assert base_hashes[str(base)] == meta['cnf_sha256']
                assert record['verified'] and sha(record['tag']+'.drat') == record['proof_sha256']
                assert record['checker_sha256'] == sha(CHECKER)
                how = 'SEPARATE_REVISION2_REPLAY'
            elif str(path.relative_to(HERE)) in previous:
                how = 'PRIOR_AUXILIARY_REPLAY'
            else:
                assert replay_record(path, True) == 'UNSAT_VERIFIED'
                how = 'CHECKER_RERUN'
            counts[group] += 1
            inventory.append(dict(group=group, record=str(path), record_sha256=sha(path),
                                  cnf_sha256=record['cnf_sha256'],
                                  proof_sha256=record['proof_sha256'], verification=how))
            print(json.dumps(dict(record=str(path), status='AUDITED', verification=how)), flush=True)
    assert counts['cases_v2'] == 314
    result = dict(time=datetime.now(timezone.utc).isoformat(),
                  total=len(inventory), counts=counts, certificates=inventory,
                  checker=str(CHECKER), checker_sha256=sha(CHECKER),
                  separate_target_replay=str(prior), target_replay_sha256=sha(prior))
    (HERE/'independent/CERTIFICATE_MANIFEST.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({key:value for key,value in result.items() if key != 'certificates'}), flush=True)


if __name__ == '__main__':
    main()
