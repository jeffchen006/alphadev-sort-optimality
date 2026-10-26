#!/usr/bin/env python3
"""Read the retry status without changing any search file."""
import json
import re
from pathlib import Path

base = Path('logs/round0430')
summary = json.loads((base / 'summary.json').read_text())
print(f'done={summary["done"]}/47 counts={summary["counts"]} new_NONE={summary["newly_exhausted"]}')
active = base / 'active.json'
if active.exists():
    row = json.loads(active.read_text())
    txt = Path(row['log']).read_text()
    progress = [line for line in txt.splitlines() if line.startswith(('PROGRESS ', 'RESULT '))]
    print(row['file'], progress[-1] if progress else 'starting')
for row in summary['records'][-2:]:
    print(row['file'], row['status'], row['calls'], row['seconds'], 'retained' if row['reused_exhaustive'] else 'new')
