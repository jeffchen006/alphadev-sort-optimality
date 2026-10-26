"""run core_sat on cores listed in a file (one key per line: 'count<TAB>key'), lines [a, b), K, time limit; append jsonl."""
import sys, json, time; sys.path.insert(0, '/path/to/repo/agents/team/d5-extend')
from d5lib import parse_key
import core_sat
fn, a, b, K, tl, out = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), float(sys.argv[5]), sys.argv[6]
R = int(sys.argv[7]) if len(sys.argv) > 7 else 5 + K - 7
lines = open(fn).read().split('\n')
for li in range(a, min(b, len(lines))):
    if not lines[li].strip(): continue
    cnt, key = lines[li].split('\t')
    core = parse_key(key)
    logl = []
    res = core_sat.run(core, K, R=R, log=lambda s: (logl.append(s), print(li, s, flush=True)), maxtime=tl)
    rec = {'line': li, 'count': int(cnt), 'K': K, 'R': R, 'result': res[0], 'types': len(res[1]), 'time': round(res[3], 1), 'prog': res[2], 'key': key}
    with open(out, 'a') as f: f.write(json.dumps(rec) + '\n')
    if res[0] == 'SAT' and K <= 31:
        open('/path/to/repo/board/team/candidates/d5-extend_K%d_line%d.s' % (K, li), 'w').write(res[2])
        print('CANDIDATE', li, flush=True)
