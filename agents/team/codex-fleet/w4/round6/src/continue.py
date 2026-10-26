"""Start further checks only after the first serial campaign releases its lock."""
import fcntl
from pathlib import Path
import os
import subprocess
import sys

BASE = Path(__file__).resolve().parents[1]


if __name__ == '__main__':
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    lock = (BASE/'logs/controller.lock').open('r+')
    fcntl.flock(lock, fcntl.LOCK_EX)
    # The first controller has exited. Every following CPU job is serial.
    for command, log in [
        ([sys.executable,'-B',str(BASE/'src/symbolic_control.py')], BASE/'logs/symbolic_controller.log'),
        ([sys.executable,'-B',str(BASE/'src/audit.py')], BASE/'logs/audit.log'),
        ([sys.executable,'-B',str(BASE/'extra/src/controller.py')], BASE/'extra/logs/controller.log'),
        ([sys.executable,'-B',str(BASE/'extra/src/audit.py')], BASE/'extra/logs/audit.log')
    ]:
        with log.open('w') as stream:
            result = subprocess.run(command, stdout=stream, stderr=subprocess.STDOUT)
        if result.returncode:
            print(f'Failed command: {command}; log: {log}', flush=True)
            raise SystemExit(result.returncode)
    print('All serial search and audit jobs have completed.', flush=True)
