"""Keep all follow-up search and verification jobs serial."""
import fcntl
from pathlib import Path
import os
import subprocess
import sys

BASE = Path(__file__).resolve().parents[1]
ROUND = BASE.parent


if __name__ == '__main__':
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    lock = (ROUND/'extra/logs/controller.lock').open('r+')
    fcntl.flock(lock, fcntl.LOCK_EX)
    for command, log in [
        ([sys.executable,'-B',str(ROUND/'extra/src/audit.py')], ROUND/'extra/logs/audit.log'),
        ([sys.executable,'-B',str(BASE/'src/controller.py')], BASE/'logs/controller.log'),
        ([sys.executable,'-B',str(BASE/'src/audit.py')], BASE/'logs/audit.log'),
        ([sys.executable,'-B',str(ROUND/'src/postscan.py')], ROUND/'logs/postscan.log')
        ,([sys.executable,'-B',str(ROUND/'src/report.py')], ROUND/'logs/report.log')
    ]:
        with log.open('w') as stream:
            result = subprocess.run(command,stdout=stream,stderr=subprocess.STDOUT)
        if result.returncode:
            print(f'Failed command: {command}; log: {log}',flush=True)
            raise SystemExit(result.returncode)
    print('All search, audit, and model-analysis jobs have completed.',flush=True)
