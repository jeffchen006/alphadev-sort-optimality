from pathlib import Path
import hashlib,json,subprocess,sys
HERE=Path(__file__).resolve().parent
JUDGE='/path/to/repo/shared/judge.py'
rows=[]
for name in ['near9','near14']:
    path=HERE/'seeds'/f'{name}.s'
    p=subprocess.run(['nice','-n','19',sys.executable,'-B',JUDGE,str(path),'--strict','--model','out'],capture_output=True,text=True)
    log=HERE/'logs'/f'judge_input_{name}.log';log.write_text(p.stdout+p.stderr)
    assert p.returncode!=0 and p.stdout.startswith('FAIL ')
    data=json.loads(path.with_suffix('.json').read_text())
    assert hashlib.sha256(path.read_bytes()).hexdigest()==data['sha256']
    rows.append(dict(file=str(path),source=data['source'],sha256=data['sha256'],failures=len(data['failing_orders']),strict_judge='FAIL',log=str(log)))
(HERE/'input_audit.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps(rows,indent=2))
