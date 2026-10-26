"""Judge every emitted control in sequence. No worker processes or threads."""
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path('/path/to/repo')
pattern = sys.argv[1] if len(sys.argv) > 1 else 'round3/control32_d-1_*.s'
rows = []
for source in sorted(Path('.').glob(pattern)):
    start = time.monotonic()
    result = subprocess.run(['nice', '-n', '19', 'python3', str(ROOT/'shared/judge.py'),
                             str(source), '--strict', '--model', 'out'],
                            capture_output=True, text=True)
    log = source.with_suffix('.judge.log')
    log.write_text(result.stdout + result.stderr)
    ok = result.returncode == 0 and result.stdout.startswith('PASS ')
    rows.append({'file': str(source), 'pass': ok, 'log': str(log),
                 'seconds': time.monotonic() - start})
    print(result.stdout.strip(), flush=True)
    if not ok:
        raise SystemExit(result.stdout + result.stderr)
Path('round3/control_judges.json').write_text(json.dumps(rows, indent=2) + '\n')
print('COMPLETE controls', len(rows), 'strict_PASS', sum(r['pass'] for r in rows), flush=True)
