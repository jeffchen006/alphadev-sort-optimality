#!/usr/bin/env python3
"""Stop the local dispatcher at a job boundary, before another solver starts."""
import os
from pathlib import Path
import signal
import sys
if Path('round10/artifacts/PAUSE_DISPATCHER').exists():
    cmd=Path(f'/proc/{os.getppid()}/cmdline').read_bytes().split(b'\0')
    if any(x==b'round10/src/run.py' for x in cmd):
        print('PAUSED BEFORE SOLVER START',flush=True)
        os.kill(os.getppid(),signal.SIGTERM)
        raise SystemExit(75)
    raise RuntimeError('unexpected parent')
os.execv('round10/bin/dagx_safe_real',['round10/bin/dagx_safe_real',*sys.argv[1:]])
