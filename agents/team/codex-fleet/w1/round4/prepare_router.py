import importlib.util
import hashlib
import json
from pathlib import Path
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('analyze', HERE.parent/'round3/analyze.py')
analyze=importlib.util.module_from_spec(spec)
spec.loader.exec_module(analyze)
rows=json.loads((HERE/'manifest.json').read_text())
problems=[]
reuse_manifest=[]
for row in rows:
    assert hashlib.sha256(Path(row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
    stats,p=analyze.analyze(Path(row['path']))
    assert len(p['events'])==32
    problems.append(p)
    copies=sorted(stats['move_positions']+stats['conditional_copy_positions'])
    writes=[i for i,e in enumerate(p['events']) if e['op']!=1]
    reuse_manifest.append({'name':row['name'],'copies':copies,'writes':writes,
                           'copy_tests':len(copies)*(len(copies)-1),
                           'write_tests':len(writes)*(len(writes)-1)})
analyze.export(problems,HERE/'problems.txt')
(HERE/'reuse_manifest.json').write_text(json.dumps(reuse_manifest,indent=2)+'\n')
control_stats,control=analyze.analyze(HERE/'padded33.s')
analyze.export([control],HERE/'control_problem.txt')
control_copies=sorted(control_stats['move_positions']+control_stats['conditional_copy_positions'])
control_pairs=[(a,b) for a in control_copies for b in control_copies if a!=b]
(HERE/'control_copy_test.json').write_text(json.dumps({'test':control_pairs.index((0,32))})+'\n')
print('EXPORTED',len(problems),'routing bases')
