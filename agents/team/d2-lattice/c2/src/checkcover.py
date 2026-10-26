#!/usr/bin/env python3
# Certified cube coverage: the CNF {NOT cube : cube in cubes} is UNSAT  <=>  every assignment satisfies some cube.
# Proof: cadical LRAT + bin/lrat-check ("c VERIFIED"). usage: checkcover.py cubes/<case>.json
import sys, json, subprocess, hashlib
from pathlib import Path
BIN = Path('/path/to/repo/bin')
f = Path(sys.argv[1]); d = json.loads(f.read_text())
cubes = [cu['units'] for cu in d['cubes']]
nv = max(abs(x) for cu in cubes for x in cu)
cnf = f.with_suffix('.cover.cnf'); prf = f.with_suffix('.cover.lrat')
cnf.write_text(f'p cnf {nv} {len(cubes)}\n' + ''.join(' '.join(str(-x) for x in cu) + ' 0\n' for cu in cubes))
r = subprocess.run([str(BIN / 'cadical'), '-q', '--lrat=true', '--binary=false', str(cnf), str(prf)], capture_output=True, text=True)
q = subprocess.run([str(BIN / 'lrat-check'), str(cnf), str(prf)], capture_output=True, text=True)
ok = r.returncode == 20 and any(l.strip() == 'c VERIFIED' for l in q.stdout.splitlines())
out = dict(case=d['case'], cubes=len(cubes), cover_cnf=str(cnf), cover_cnf_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest(),
           cover_proof=str(prf), solver_rc=r.returncode, verified=ok)
f.with_suffix('.cover.json').write_text(json.dumps(out) + '\n'); print(json.dumps(out))
sys.exit(0 if ok else 1)
