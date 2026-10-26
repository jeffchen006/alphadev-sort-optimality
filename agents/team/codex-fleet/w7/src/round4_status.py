"""Print a short live status without changing the search."""
import json
from pathlib import Path

summary = json.loads(Path('round4/summary.json').read_text())
for key in ['completed_retries', 'retry_statuses', 'combined_checked_UNSAT',
            'combined_unresolved', 'peak_KiB', 'strict_judge_calls']:
    print(f'{key}: {summary[key]}')
heartbeat = None
for line in reversed(Path('round4/run.log').read_text().splitlines()):
    try:
        event = json.loads(line)
    except ValueError:
        continue
    if event.get('step') == 'heartbeat' and heartbeat is None:
        heartbeat = event
    if event.get('step') == 'start':
        print(f"Latest window: {event['window']}; {event['clauses']} initial clauses")
        if heartbeat:
            print(f"Latest heartbeat: {heartbeat['job']}; {heartbeat['elapsed_seconds']} seconds")
        break
