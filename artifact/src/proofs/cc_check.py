"""cc_check.py — independent re-check of a cube-and-conquer UNSAT claim (sat's agents/sat/cc/<run>/).

Claim: F UNSAT. Argument: (1) S := F + {-C : C leaf cube} is UNSAT (summary proof), and (2) for every leaf C,
F + units(C) is UNSAT. Then F is UNSAT: a model of F satisfies some C (by (1)), contradicting (2).
This script checks, without sat's code:
  glue   : S (summary.cnf) has exactly the clauses of F.cnf plus the negated cubes of cubes.json (as multisets)
  summary: summary.drat -> drat-trim -L -> cake_lpr on summary.cnf
  leaves : for --sample N random leaves (or --all): build F + units(C) here, run check_unsat.sh (cadical LRAT -> cake_lpr)
Usage: python3 -I cc_check.py RUNDIR [--sample N | --all] [--seed S] [--jobs J]
Log: agents/proofs/logs/cc_<run>_<time>.log (+ check_unsat logs per leaf).
"""
import argparse, collections, hashlib, json, os, random, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor

P = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser()
ap.add_argument('run')
ap.add_argument('--sample', type=int, default=0)
ap.add_argument('--all', action='store_true')
ap.add_argument('--seed', type=int, default=1)
ap.add_argument('--jobs', type=int, default=1)
ap.add_argument('--done-only', action='store_true', help='sample only leaves that log.txt reports as cake_lpr VERIFIED')
a = ap.parse_args()
run = os.path.abspath(a.run)
name = os.path.basename(run.rstrip('/'))
logp = os.path.join(P, 'logs', 'cc_%s_%s.log' % (name, time.strftime('%Y%m%d-%H%M%S')))
logf = open(logp, 'w')


def log(m):
    print(m, flush=True)
    logf.write(m + '\n'); logf.flush()


def sha(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        for b in iter(lambda: f.read(1 << 20), b''):
            h.update(b)
    return h.hexdigest()


def read_cnf(p):
    nv, cls, cur = 0, [], []
    for line in open(p):
        if line.startswith('p '):
            nv = int(line.split()[2]); continue
        if line[:1] == 'c' or not line.strip():
            continue
        for t in line.split():
            v = int(t)
            if v == 0:
                cls.append(tuple(cur)); cur = []
            else:
                cur.append(v)
    assert not cur, 'clause without final 0'
    return nv, cls


F_path, S_path = os.path.join(run, 'F.cnf'), os.path.join(run, 'summary.cnf')
log('cc_check run=%s' % run)
log('F.cnf sha256=%s' % sha(F_path))
cubes = json.load(open(os.path.join(run, 'cubes.json')))['leaves']
log('cubes.json sha256=%s leaves=%d' % (sha(os.path.join(run, 'cubes.json')), len(cubes)))
nvF, F = read_cnf(F_path)
ok = True
for C in cubes:
    if len(set(abs(l) for l in C)) != len(C) or any(abs(l) > nvF or l == 0 for l in C):
        log('BAD cube %s' % C); ok = False

# glue
if os.path.exists(S_path):
    log('summary.cnf sha256=%s' % sha(S_path))
    nvS, S = read_cnf(S_path)
    want = collections.Counter(tuple(sorted(c)) for c in F) + collections.Counter(tuple(sorted(-l for l in C)) for C in cubes)
    got = collections.Counter(tuple(sorted(c)) for c in S)
    glue = (want == got) and nvS == nvF
    log('glue summary.cnf == F + negated cubes: %s' % glue)
    ok &= glue
    # summary proof
    D = os.path.join(run, 'summary.drat')
    if os.path.exists(D):
        L = os.path.join(P, 'proofs', 'cc_%s_summary.lrat' % name)
        r = subprocess.run([os.path.join(P, 'tools/bin/drat-trim'), S_path, D, '-L', L, '-w'], capture_output=True, text=True)
        dt = 's VERIFIED' in r.stdout.replace('\r', '\n')
        c = subprocess.run([os.path.join(P, 'tools/bin/cake_lpr'), S_path, L], capture_output=True, text=True)
        cv = c.stdout.strip() == 's VERIFIED UNSAT'
        log('summary.drat sha256=%s drat-trim=%s lrat sha256=%s cake_lpr=%s' % (sha(D), dt, sha(L), c.stdout.strip()))
        os.remove(L)
        ok &= cv
    else:
        log('summary.drat missing'); ok = False
else:
    log('summary.cnf missing'); ok = False

# leaves
os.makedirs(os.path.join(P, 'proofs', 'cc_leaves'), exist_ok=True)
import re
with open(F_path) as f:  # byte-exact rebuild as in sat's cubes.py solve_leaf_lrat
    head = f.readline()
    while head.startswith('c'):
        head = f.readline()
    fbody = f.read()
nvh, nch = map(int, head.split()[2:4])
logged = {}
lp = os.path.join(run, 'log.txt')
if os.path.exists(lp):
    for line in open(lp):
        mm = re.search(r'leaf (\d+)/\d+ .*VERIFIED UNSAT.*cnf_sha256=([0-9a-f]{64})', line)
        if mm:
            logged[int(mm.group(1)) - 1] = mm.group(2)
log('log.txt: %d leaves with cnf_sha256 and cake_lpr VERIFIED' % len(logged))
pool = sorted(logged) if a.done_only else list(range(len(cubes)))
idx = pool if a.all else sorted(random.Random(a.seed).sample(pool, min(a.sample, len(pool))))


def leaf(i):
    p = os.path.join(P, 'proofs', 'cc_leaves', '%s_leaf%05d.cnf' % (name, i))
    with open(p, 'w') as f:
        f.write('p cnf %d %d\n' % (nvh, nch + len(cubes[i])))
        f.write(fbody)
        for l in cubes[i]:
            f.write('%d 0\n' % l)
    hs = sha(p)
    hmsg = ('logged sha256 MATCH' if logged.get(i) == hs else 'logged sha256 MISMATCH') if i in logged else 'not in log'
    r = subprocess.run(['nice', '-n', '10', os.path.join(P, 'check_unsat.sh'), '-t', '3600', p], capture_output=True, text=True)
    res = [l for l in r.stdout.splitlines() if l.startswith('c RESULT')]
    os.remove(p)
    return i, (res[0] if res else 'NO RESULT') + ' | ' + hmsg


nver = 0
with ThreadPoolExecutor(a.jobs) as ex:
    for i, res in ex.map(leaf, idx):
        good = 'VERIFIED_UNSAT' in res and 'MISMATCH' not in res
        nver += good
        ok &= good
        log('leaf %d cube=%s %s' % (i, cubes[i], res))
log('leaves checked %d/%d (of %d), all VERIFIED: %s' % (nver, len(idx), len(cubes), nver == len(idx)))
log('CC_CHECK %s (%s)' % ('PASS' if ok else 'FAIL', 'all leaves' if a.all else 'sample of %d leaves' % len(idx)))
sys.exit(0 if ok else 1)
