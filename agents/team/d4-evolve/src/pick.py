# dedupe programs (canonical scratch names, no NOP), group by failing set, write one per group (diverse), fw <= MAX
import sys, re; sys.path.insert(0, '../../sort5-lab/tools'); import d4eval as E
src, mx, out = sys.argv[1], int(sys.argv[2]), sys.argv[3]
text = open(src).read().split('# prog')
seen, groups = set(), {}
for blk in text[1:]:
    head, _, body = blk.partition('\n')
    m = re.search(r'fail_weak=(\d+)', head)
    if not m or int(m.group(1)) > mx: continue
    p = E.parse_text(body)
    if not p: continue
    p = p[0]
    ren = {}
    def r(x):
        if x[0] == 'S' and len(x) > 1:
            ren.setdefault(x, 'S%d' % len(ren)); return ren[x]
        return x
    p = [(o, r(a), r(b)) for o, a, b in p]
    key = tuple(p)
    if key in seen: continue
    seen.add(key)
    fails = tuple(e for e in E.orders(5) if E.run(p, 5, e) != sorted(e))
    skel = tuple((a, b) for o, a, b in p if o == 'cmp')
    groups.setdefault((fails, skel), []).append(p)
print('distinct', len(seen), 'groups', len(groups), file=sys.stderr)
with open(out, 'w') as f:
    for (fails, skel), ps in sorted(groups.items(), key=lambda kv: len(kv[0][0])):
        f.write('# prog fw=%d group=%d\n' % (len(fails), len(ps)) + E.fmt(ps[0]) + '\n')
