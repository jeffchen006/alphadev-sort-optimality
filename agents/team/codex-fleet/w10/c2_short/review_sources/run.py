#!/usr/bin/env python3
# C2 case runner (d2-lattice). Case (c, i, j) = base_k31_c{c}.cnf + unit clauses position_choices[0][i], position_choices[1][j]
# (i, j = exception positions, m = k-c = sentinel "absent"; i < j < m, or j = m, or i = j = m) -- same cases as w10 partition().
# Solver: CaDiCaL with LRAT proof; UNSAT counts only if lrat-check prints "c VERIFIED". SAT: model checked against the
# CNF, decoded with the encoder, judged strictly. Timeout = UNKNOWN (left for cube splitting).
# usage: run.py --cs 9,10 --workers 12 --limit 1800 [--cases i:j,...]
import sys, os, json, time, hashlib, argparse, subprocess, itertools, resource
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, as_completed
ROOT = Path('/path/to/repo'); BIN = ROOT / 'bin'
C2 = Path(__file__).resolve().parent.parent; BASE = C2 / 'base'; RES = C2 / 'results'; TMP = C2 / 'tmp'; PROOF = C2 / 'proofs'
def sha(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        for b in iter(lambda: f.read(1 << 20), b''): h.update(b)
    return h.hexdigest()
def cases(c, k=31):
    m = k - c
    yield (m, m)
    for i in range(m): yield (i, m)
    for i in range(m):
        for j in range(i + 1, m): yield (i, j)
VAR = ''   # '' = v1 (w10 encoder), '_v2' = exceptions may be cmp operands
def name(c, i, j): return ('v2_' if VAR else '') + f'c{c}_{i:02d}_{j:02d}'
def limits():
    resource.setrlimit(resource.RLIMIT_AS, (16 << 30, 16 << 30)); os.nice(10)
def solve(c, i, j, limit, var='', k=31, extra=None, q=None, keep=True):
    global VAR; VAR = var
    base = json.loads((BASE / f'base_k{k}_c{c}{var}.json').read_text())
    units = [base['position_choices'][0][i], base['position_choices'][1][j]] + list(extra or [])
    nm = name(c, i, j) + (f'_q{q:03d}' if q is not None else ''); cnf = TMP / (nm + '.cnf'); prf = TMP / (nm + '.lrat'); log = TMP / (nm + '.log')
    with open(BASE / f'base_k{k}_c{c}{var}.cnf', 'rb') as inp, open(cnf, 'wb') as out:
        inp.readline(); out.write(f"p cnf {base['variables']} {base['clauses'] + len(units)}\n".encode())
        while True:
            b = inp.read(1 << 20)
            if not b: break
            out.write(b)
        for u in units: out.write(f'{u} 0\n'.encode())
    rec = dict(case=nm, variant=var or '_v1', cube=q, c=c, k=k, i=i, j=j, m=k - c, units=units, base_cnf_sha256=base['cnf_sha256'],
               encoder_sha256=base['encoder_sha256'], cnf_sha256=sha(cnf), limit=limit, solver='cadical 3.0.1 --lrat')
    t0 = time.time()
    with open(log, 'w') as lf:
        p = subprocess.run([str(BIN / 'cadical'), '-t', str(limit), '--lrat=true', '--binary=false', str(cnf), str(prf)],
                           stdout=lf, stderr=subprocess.STDOUT, preexec_fn=limits)
    rec['solve_seconds'] = time.time() - t0; rec['returncode'] = p.returncode
    rec['status'] = {10: 'SAT', 20: 'UNSAT'}.get(p.returncode, 'UNKNOWN')
    if rec['status'] == 'UNSAT':
        t1 = time.time()
        q = subprocess.run([str(BIN / 'lrat-check'), str(cnf), str(prf)], capture_output=True, text=True, preexec_fn=limits)
        rec['check_seconds'] = time.time() - t1
        rec['verified'] = q.returncode == 0 and any(l.strip() == 'c VERIFIED' for l in q.stdout.splitlines())
        rec['proof_bytes'] = prf.stat().st_size; rec['proof_sha256'] = sha(prf)
        rec['checker_tail'] = q.stdout.splitlines()[-3:]
        # keep every proof and case CNF for the judge's re-check (zstd; sha256 above is of the uncompressed files)
        PROOF.mkdir(exist_ok=True)
        if rec['verified'] and not keep:
            prf.unlink(); cnf.unlink(); rec['proof_kept'] = False
        for f in ((prf, cnf) if (keep or not rec['verified']) else ()):
            subprocess.run(['zstd', '-q', '-T1', '-3', '--rm', '-f', str(f), '-o', str(PROOF / (f.name + '.zst'))], preexec_fn=limits)
        if keep or not rec['verified']: rec['proof_file'] = str(PROOF / (prf.name + '.zst')); rec['cnf_file'] = str(PROOF / (cnf.name + '.zst'))
    elif rec['status'] == 'SAT':
        lits = []
        for l in log.read_text().splitlines():
            if l.startswith('v '): lits += [int(x) for x in l[2:].split() if int(x)]
        model = {x for x in lits if x > 0}
        ok = True
        with open(cnf) as f:
            next(f)
            for l in f:
                cl = [int(x) for x in l.split()[:-1]]
                if not any((x in model) if x > 0 else (-x not in model) for x in cl): ok = False; break
        rec['assignment_checked'] = ok
        sys.path.insert(0, str(C2 / 'src'))
        if var: from threshold_cmpx import ThresholdEncoding
        else: from threshold_sat import ThresholdEncoding
        enc = ThresholdEncoding(5, k, c, list(itertools.permutations(range(5))), None, True, None, None, True)
        prog = C2 / 'found' ; prog.mkdir(exist_ok=True); sfile = prog / (nm + '.s')
        sfile.write_text(enc.decode(lits))
        j1 = subprocess.run([sys.executable, str(ROOT / 'shared/judge.py'), str(sfile), '--strict', '--model', 'out'], capture_output=True, text=True)
        rec['judge_out'] = j1.stdout[-500:]; rec['program'] = str(sfile)
    else:
        prf.unlink(missing_ok=True); cnf.unlink(missing_ok=True)
    log.unlink(missing_ok=True) if rec['status'] != 'SAT' else None
    (RES / (nm + '.json')).write_text(json.dumps(rec) + '\n')
    return rec
def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--cs', default='9'); ap.add_argument('--workers', type=int, default=12)
    ap.add_argument('--limit', type=int, default=1800); ap.add_argument('--cases', default=None); ap.add_argument('--redo-unknown', action='store_true'); ap.add_argument('--variant', default='v1'); ap.add_argument('--cubes', default=None); ap.add_argument('--nokeep', action='store_true')
    a = ap.parse_args(); RES.mkdir(exist_ok=True); TMP.mkdir(exist_ok=True)
    global VAR; VAR = '' if a.variant == 'v1' else '_v2'
    todo = []
    for c in map(int, a.cs.split(',')):
        lst = [tuple(map(int, x.split(':'))) for x in a.cases.split(',')] if a.cases else list(cases(c))
        for i, j in lst:
            r = RES / (name(c, i, j) + '.json')
            if r.exists():
                st = json.loads(r.read_text())
                if st['status'] == 'UNSAT' and st.get('verified'): continue
                if st['status'] == 'UNKNOWN' and not a.redo_unknown: continue
                if st['status'] == 'SAT': continue
            todo.append((c, i, j))
    if a.cubes:   # run the cubes of one case: cubes/<case>.json
        cf = json.loads((C2 / 'cubes' / (a.cubes + '.json')).read_text()); todo = []
        for q, cu in enumerate(cf['cubes']):
            r = RES / (a.cubes + f'_q{q:03d}.json')
            if r.exists() and json.loads(r.read_text())['status'] in ('SAT', 'UNSAT') : continue
            todo.append((cf['c'], cf['i'], cf['j'], cu['units'], q))
    else: todo = [(c, i, j, None, None) for c, i, j in todo]
    print(f'{len(todo)} cases, {a.workers} workers, limit {a.limit}s', flush=True)
    t0 = time.time()
    with ProcessPoolExecutor(a.workers) as ex:
        fs = {ex.submit(solve, c, i, j, a.limit, VAR, 31, e, q, not a.nokeep): (c, i, j, q) for c, i, j, e, q in todo}
        for f in as_completed(fs):
            r = f.result()
            print(f"{time.time()-t0:8.0f}s {r['case']} {r['status']} {r.get('verified','')} solve={r['solve_seconds']:.0f}s check={r.get('check_seconds',0):.0f}s", flush=True)
            if r['status'] == 'SAT': print('*** SAT', r.get('program'), r.get('judge_out'), flush=True)
if __name__ == '__main__': main()
