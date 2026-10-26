"""Audit every retained control and save exact strict-judge records."""
import hashlib,json,subprocess
from pathlib import Path
ROOT=Path('/path/to/repo')
rows=[]
for p in sorted(list(Path('candidates').glob('*control32_*.s'))+list(Path('verified').glob('*.s'))):
    model='mem' if p.stem.endswith('_mem') else 'out';t=subprocess.run(['nice','-n','10','python3',str(ROOT/'shared/judge.py'),str(p),'--strict','--model',model],capture_output=True,text=True)
    log=Path('logs/audit_'+p.parent.name+'_'+p.stem+'.log');log.write_text(t.stdout+t.stderr)
    ops=[l.split()[0] for l in p.read_text().splitlines() if l.strip() and not l.startswith(('#','out'))]
    rows.append({'path':str(p.resolve()),'model':model,'length':len(ops),'cmp':ops.count('cmp'),'mov':ops.count('mov'),'cmov':sum(x.startswith('cmov') for x in ops),'pass':'PASS' in t.stdout,'log':str(log),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
Path('artifacts/strict_pass_ledger.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps({'tested':len(rows),'passed':sum(r['pass'] for r in rows),'failed':sum(not r['pass'] for r in rows)}),flush=True)
assert all(r['pass'] for r in rows)
