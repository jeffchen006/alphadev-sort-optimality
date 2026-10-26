#!/usr/bin/env python3
"""judge: independent re-check of one C2 case (d2-lattice runner output).
usage: checkcase.py CASE_JSON [CASE_JSON ...]   (results/<case>.json written by c2/src/run.py)
Steps: (1) rebuild the base CNF from the ORIGINAL w10 encoder (V1) or d2's threshold_cmpx (V2); compare with base json;
(2) build case CNF = base + 2 unit clauses; compare sha256 with the record; (3) decompress proof, compare sha256;
(4) run bin/lrat-check; print one line: case, verdict. Uses one core. Temp files in TMP."""
import sys, json, hashlib, itertools, subprocess, os, time
from pathlib import Path
ROOT = Path('/path/to/repo')
W10 = ROOT / 'agents/team/codex-fleet/w10/src'
C2 = ROOT / 'agents/team/d2-lattice/c2'
TMP = ROOT / 'agents/team/judge/dira/tmp'; TMP.mkdir(exist_ok=True)
BASES = {}


def sha(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        for b in iter(lambda: f.read(1 << 20), b''):
            h.update(b)
    return h.hexdigest()


def base(c, v2, k=31):
    key = (c, v2, k)
    if key in BASES:
        return BASES[key]
    if v2:
        sys.path.insert(0, str(C2 / 'src')); from threshold_cmpx import ThresholdEncoding
    else:
        sys.path.insert(0, str(W10)); from threshold_sat import ThresholdEncoding
    enc = ThresholdEncoding(5, k, c, list(itertools.permutations(range(5))), None, True, None, None, True)
    p = TMP / f'base_k{k}_c{c}{"_v2" if v2 else ""}_{os.getpid()}.cnf'
    enc.dimacs(p)
    BASES[key] = (p, enc.nv, len(enc.cs), enc.positions, sha(p))
    return BASES[key]


def check(js):
    rec = json.loads(Path(js).read_text())
    nm = rec['case']; c = rec['c']; k = rec.get('k', 31); v2 = rec.get('variant') == '_v2'
    if rec['status'] != 'UNSAT':
        return f'{nm} status={rec["status"]} (not an UNSAT case)'
    p, nv, ncl, pos, bsha = base(c, v2, k)
    if bsha != rec['base_cnf_sha256']:
        return f'{nm} BASE-MISMATCH'
    units = [pos[0][rec['i']] if rec['i'] < rec['m'] else None, pos[1][rec['j']] if rec['j'] < rec['m'] else None]
    # d2 convention: position_choices[0][i], [1][j] where index m = sentinel (absent)
    units = [pos[0][rec['i']], pos[1][rec['j']]]
    if units != rec['units']:
        return f'{nm} UNITS-MISMATCH {units} vs {rec["units"]}'
    cnf = TMP / (nm + '.cnf')
    with open(p, 'rb') as inp, open(cnf, 'wb') as out:
        inp.readline(); out.write(f'p cnf {nv} {ncl + 2}\n'.encode())
        while True:
            b = inp.read(1 << 20)
            if not b: break
            out.write(b)
        for u in units: out.write(f'{u} 0\n'.encode())
    if sha(cnf) != rec['cnf_sha256']:
        cnf.unlink(); return f'{nm} CASE-CNF-SHA-MISMATCH'
    z = C2 / 'proofs' / (nm + '.lrat.zst')
    if not z.exists():
        cnf.unlink(); return f'{nm} NO-PROOF-FILE (recorded verified={rec.get("verified")})'
    lrat = TMP / (nm + '.lrat')
    subprocess.run(['zstd', '-q', '-d', '-f', str(z), '-o', str(lrat)], check=True)
    if sha(lrat) != rec['proof_sha256']:
        cnf.unlink(); lrat.unlink(); return f'{nm} PROOF-SHA-MISMATCH'
    t0 = time.time()
    q = subprocess.run([str(ROOT / 'bin/lrat-check'), str(cnf), str(lrat)], capture_output=True, text=True)
    ok = q.returncode == 0 and any(l.strip() == 'c VERIFIED' for l in q.stdout.splitlines())
    cnf.unlink(); lrat.unlink(); p.unlink()
    return f'{nm} {"VERIFIED" if ok else "NOT-VERIFIED " + q.stdout[-200:]} check_s={time.time() - t0:.0f}'


if __name__ == '__main__':
    os.nice(10)
    for js in sys.argv[1:]:
        print(check(js), flush=True)
