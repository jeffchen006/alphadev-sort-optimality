"""Group exact comparison outcome tables under input and order symmetries."""
import collections
import hashlib
import itertools
import json
from pathlib import Path

CASES = [w for w in itertools.product(range(5), repeat=5)
         if set(w) == set(range(max(w) + 1))]
INDEX = {w: i for i, w in enumerate(CASES)}
STRICT = [i for i, w in enumerate(CASES) if len(set(w)) == 5]
REVERSE = str.maketrans('012', '210')
rows = json.loads(Path('round3/analysis.json').read_text())
groups = {'strict': {}, 'weak': {}}
transforms = {}
for row in rows:
    flags = row['comparison_signs']
    first = flags[0]
    pairs = [(a, b) for a in range(5) for b in range(a + 1, 5)
             if all(first[t] == ('0' if w[a] < w[b] else '2' if w[a] > w[b] else '1')
                    for t, w in enumerate(CASES))
             or all(first[t] == ('2' if w[a] < w[b] else '0' if w[a] > w[b] else '1')
                    for t, w in enumerate(CASES))]
    assert len(pairs) == 1
    a, b = pairs[0]
    if (a, b) not in transforms:
        maps = []
        for perm in itertools.permutations(range(5)):
            if {perm[a], perm[b]} != {0, 1}:
                continue
            for rev in (False, True):
                maps.append([INDEX[tuple(max(w) - w[perm[j]] if rev else w[perm[j]]
                                         for j in range(5))] for w in CASES])
        assert len(maps) == 24
        transforms[a, b] = maps
    keys = {'strict': None, 'weak': None}
    for indices in transforms[a, b]:
        for kind, subset in [('weak', range(541)), ('strict', STRICT)]:
            key = tuple(min(s, s.translate(REVERSE))
                        for f in flags for s in [''.join(f[indices[t]] for t in subset)])
            if keys[kind] is None or key < keys[kind]:
                keys[kind] = key
    for kind, key in keys.items():
        if key not in groups[kind]:
            groups[kind][key] = {'id': len(groups[kind]),
                                 'sha256': hashlib.sha256(''.join(key).encode()).hexdigest(),
                                 'programs': []}
        groups[kind][key]['programs'].append(row['name'])
summary = {kind: list(g.values()) for kind, g in groups.items()}
Path('round3/predicate_classes.json').write_text(json.dumps(summary, indent=2) + '\n')
for kind, classes in summary.items():
    print(kind, 'exact outcome classes', len(classes), 'size histogram',
          dict(sorted(collections.Counter(len(c['programs']) for c in classes).items())))
    for c in classes:
        print(kind, 'class', c['id'], 'size', len(c['programs']), 'example', c['programs'][0])
