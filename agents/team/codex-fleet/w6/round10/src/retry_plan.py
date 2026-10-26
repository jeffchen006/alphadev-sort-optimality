"""Retry only unresolved fixed-pair scopes; preserve their original logs."""
import json
from pathlib import Path
rows=json.loads(Path('round10/artifacts/singleton_ledger.json').read_text())
failed=[x for x in rows if x['status']=='UNKNOWN_TIMEOUT']
Path('round10/artifacts/retry_manifest.json').write_text(json.dumps(failed,indent=2))
print('unresolved fixed-pair scopes',len(failed),flush=True)
