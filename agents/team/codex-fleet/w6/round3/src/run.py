"""Run one bounded, single-threaded job and record its actual exit status."""
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

seconds, stem, *command = sys.argv[1:]
limit = 2800 * 1024 * 1024
resource.setrlimit(resource.RLIMIT_AS, (limit, limit))
os.environ['PYTHONDONTWRITEBYTECODE'] = '1'
os.environ['OMP_NUM_THREADS'] = '1'
os.environ['OPENBLAS_NUM_THREADS'] = '1'
# A running batch can accept extra sequential checks at its next job boundary.
# Atomic rename makes one batch own the checks. No extra CPU slot is used.
pending = Path('round3/artifacts/pending_checks.json')
claimed = pending.with_name('checks_claimed_' + str(os.getpid()) + '.json')
try:
    pending.rename(claimed)
except FileNotFoundError:
    pass
else:
    for check in json.loads(claimed.read_text()):
        subprocess.run(['python3','-B','round3/src/run.py',str(check['seconds']),
                        check['name'],*check['command']],check=True)
    claimed.unlink()
began = time.monotonic()
log = Path('round3/logs') / (stem + '.log')
with log.open('w') as out:
    result = subprocess.run(['timeout', '--signal=TERM', '--kill-after=3s',
                             seconds + 's', 'nice', '-n', '19', *command],
                            stdout=out, stderr=subprocess.STDOUT)
row = {'command': command, 'wall_limit': float(seconds),
       'exit': result.returncode, 'seconds': time.monotonic()-began,
       'log': str(log)}
Path('round3/artifacts', stem + '.json').write_text(json.dumps(row, indent=2))
print(json.dumps(row), flush=True)
