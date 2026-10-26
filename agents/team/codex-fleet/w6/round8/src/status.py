"""Read existing ledgers. Do not start a search."""
from pathlib import Path
import collections,json
sat=json.loads(Path('round8/artifacts/sat_ledger.json').read_text())
mcmc=json.loads(Path('round8/artifacts/mcmc_ledger.json').read_text())
active=None
logfile=Path('round8/logs/hot_batch.log')
if not logfile.exists():logfile=Path('round8/logs/batch.log')
for line in reversed(logfile.read_text().splitlines()):
    try:row=json.loads(line)
    except ValueError:continue
    if row.get('step')=='starting':active=row['name'];break
print(json.dumps(dict(sat=len(sat),sat_statuses=dict(collections.Counter(r['status'] for r in sat)),
    mcmc=len(mcmc),best_failures=min(r['summary']['best_fail'] for r in mcmc),
    proposals=sum(r['summary']['iterations'] for r in mcmc),
    saved_le6=sum(len(r['saved_le6']) for r in mcmc),active=active)))
if active:
    lines=Path('round8/logs',active+'.log').read_text().splitlines()
    print('\n'.join(lines[-2:]))
