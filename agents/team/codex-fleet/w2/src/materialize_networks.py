#!/usr/bin/env python3
import json
from pathlib import Path

def name(t):
    mins = [s for s in range(1,32) if t >> s & 1 and
            all(not(t >> (s ^ (1 << i)) & 1) for i in range(5) if s >> i & 1)]
    return '|'.join(''.join(str(i) for i in range(5) if s >> i & 1)
                    for s in sorted(mins, key=lambda s:(s.bit_count(),s)))

records = json.loads(Path('network_manifest.json').read_text())
for r in records:
    fn = Path('sk/net10/n%05d.txt' % r['rank'])
    if fn.exists():
        continue
    fn.write_text('# network line=%d required_terms=%d pool_terms=%d\n' %
                  (r['line'],r['required_terms'],r['pool_terms']) +
                  ''.join('%s:%s\n' % (name(u),name(v))
                          for u,v in r['skeleton']))
print('Materialized',len(records),'skeletons',flush=True)
