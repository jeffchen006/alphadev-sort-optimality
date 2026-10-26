#!/usr/bin/env python3
# d7: collect all programs with k <= 32 from agents/team/** (+ board/team), dedupe, write all_k32.txt ("# src=PATH" headers)
import os, re, gzip, sys
ROOTS = ['..', '../../../board/team']
SKIP = re.compile(r'd7-structure/(pools|netsk|fam32/path|codex_work/r\d/pool_)|/sk/|/res/|_mem\.s$|judge/')
INS = re.compile(r'^(mov|cmp|cmovl|cmovle|cmovg|cmovge|cmove|cmovne|xchg)\s')
seen = {}; nfiles = 0
def flush(prog, src):
    k = sum(1 for l in prog if INS.match(l))
    if 7 <= k <= 32:
        key = '\n'.join(prog)
        if key not in seen: seen[key] = src
for root in ROOTS:
    for dp, dn, fn in os.walk(root):
        for f in fn:
            p = os.path.join(dp, f)
            if SKIP.search(p) or not re.search(r'\.(s|txt|gz)$', f): continue
            try:
                if os.path.getsize(p) > 300e6: continue
                op = gzip.open if f.endswith('.gz') else open
                fh = op(p, 'rt', errors='replace'); cur = []; mem = False; nfiles += 1
                for line in fh:
                    line = line.split('#')[0].rstrip() if not line.startswith('#') else line.rstrip()
                    if line.startswith('#'):
                        if cur and not mem: flush(cur, p)
                        cur = []; mem = 'model=mem' in line or 'memplus' in line
                        continue
                    if not line.strip(): continue
                    if INS.match(line.strip()) or line.strip().startswith('out '): cur.append(line.strip())
                if cur and not mem: flush(cur, p)
            except Exception as e:
                print('skip', p, e, file=sys.stderr)
with open('all_k32.txt', 'w') as fo:
    for prog, src in seen.items(): fo.write('# src=%s\n%s\n' % (src, prog))
print(nfiles, 'files', len(seen), 'distinct programs k<=32', file=sys.stderr)
