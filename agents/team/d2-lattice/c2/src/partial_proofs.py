#!/usr/bin/env python3
"""Check each UNSAT CNF certificate with a separate DRAT checker, serially."""
import argparse
import hashlib
import json
from pathlib import Path
import resource
import subprocess
import time

BIN = Path('/path/to/repo/bin')


def limit():
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024*1024, 2800*1024*1024))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('folder', type=Path)
    ap.add_argument('--timeout', type=int, default=90)
    ap.add_argument('--retry', action='store_true', help='retain accepted checks and retry incomplete checks')
    args = ap.parse_args()
    records = []
    for file in sorted(args.folder.glob('*.json')):
        if file.name.endswith(('.proofcheck.json', '.validation.json')):
            continue
        data = json.loads(file.read_text())
        if not isinstance(data, dict) or data.get('status') != 'UNSATISFIABLE':
            continue
        tag = file.with_suffix('')
        previous = Path(str(tag)+'.proofcheck.json')
        if args.retry and previous.exists():
            old = json.loads(previous.read_text())
            if old.get('verified'):
                records.append(old)
                continue
        cnf, proof = Path(str(tag)+'.cnf'), Path(str(tag)+'.drat')
        if not proof.exists():
            continue
        assert hashlib.sha256(cnf.read_bytes()).hexdigest() == data['cnf_sha256']
        start = time.monotonic()
        record = dict(file=str(file), cnf_sha256=data['cnf_sha256'],
                      proof_sha256=hashlib.sha256(proof.read_bytes()).hexdigest())
        cmd = [str(BIN/'drat-trim'), str(cnf), str(proof), '-t', str(args.timeout)]
        with open(str(tag)+'.proofcheck.log', 'w') as out:
            try:
                p = subprocess.run(cmd, stdout=out, stderr=subprocess.STDOUT,
                                   timeout=args.timeout+5, preexec_fn=limit)
                record['returncode'] = p.returncode
            except subprocess.TimeoutExpired:
                record['returncode'] = 124
        log = Path(str(tag)+'.proofcheck.log').read_text()
        record['verified'] = record['returncode'] == 0 and 's VERIFIED' in log
        record['seconds'] = time.monotonic()-start
        Path(str(tag)+'.proofcheck.json').write_text(json.dumps(record, indent=2)+'\n')
        records.append(record)
        print(json.dumps(record), flush=True)
    (args.folder/'proof_checks.json').write_text(json.dumps(records, indent=2)+'\n')


if __name__ == '__main__':
    main()
