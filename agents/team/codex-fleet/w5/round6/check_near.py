"""Cross-check emitted weak-order failure sets using the reference interpreter."""
from pathlib import Path
import importlib.util,json,sys
HERE=Path(__file__).resolve().parent
source=Path('/path/to/repo/shared/judge.py')
spec=importlib.util.spec_from_file_location('judge',source)
judge=importlib.util.module_from_spec(spec);spec.loader.exec_module(judge)
paths=sorted(p for p in (HERE/'near').glob('*.s') if 'control' not in p.name)
if '--control' in sys.argv:paths=sorted((HERE/'near').glob('*control*.s'))
rows=[]
for path in paths:
    hdr,p=judge.parse(path.read_text());registers=judge.regs(5,p);bad=[]
    for case in judge.weak_orders(5):
        state={r:case[int(r[1:])] if r[0]=='P' else 5 for r in registers}
        result=judge.run_concrete(p,state,(1,0))
        if judge.outputs(result,result['_out'],5)!=sorted(case):bad.append(case)
    expected=json.loads(path.with_suffix('.s.json').read_text())
    assert {tuple(x) for x in expected['failing_orders']}==set(bad),(path,len(bad),expected)
    assert len(bad)<=20
    rows.append(dict(file=str(path),failures=len(bad),meta=str(path.with_suffix('.s.json'))))
    print(json.dumps(rows[-1]),flush=True)
(HERE/('control_manifest.json' if '--control' in sys.argv else 'near_manifest.json')).write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps(dict(status='CHECKED',programs=len(rows),cases=len(rows)*541)))
