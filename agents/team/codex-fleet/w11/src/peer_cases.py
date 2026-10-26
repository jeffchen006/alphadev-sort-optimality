#!/usr/bin/env python3
"""Read d2 decisions and translate their restrictions. No peer encoder imports."""
import json
from pathlib import Path
from independent_c2 import Encoding, Formula, sha


def variant_of(rec):
    value = rec.get('variant', '_v2' if rec['case'].startswith('v2_') else '_v1')
    assert value in ('v1', '_v1', 'v2', '_v2', ''), value
    return 'v2' if value in ('v2', '_v2') else 'v1'


def discover(peer):
    records, unresolved = [], []
    for path in sorted((peer / 'results').glob('*.json')):
        try:
            rec = json.loads(path.read_text())
        except json.JSONDecodeError:
            unresolved.append(dict(file=str(path), status='INCOMPLETE_WRITE'))
            continue
        if rec.get('status') == 'UNSAT' and rec.get('verified') is True:
            assert rec['k'] == 31 and rec['m'] == 31-rec['c']
            m, i, j = rec['m'], rec['i'], rec['j']
            assert (i == j == m) or (0 <= i < m and j == m) or (0 <= i < j < m)
            records.append(dict(file=str(path), case=rec['case'], c=rec['c'],
                                i=i, j=j, k=31, m=m, cube=rec.get('cube'),
                                variant=variant_of(rec), peer_sha256=sha(path)))
        else:
            unresolved.append(dict(file=str(path), case=rec.get('case'),
                                   status=rec.get('status'), verified=rec.get('verified')))
    return records, unresolved


def block_restrictions(sizes, m, c):
    """A size t is exact; a size >=t fixes only t positive block choices."""
    result, start = [], 0
    assert 1 <= len(sizes) <= min(c, 2)
    for block, size in enumerate(sizes):
        lower = isinstance(size, str) and size.startswith('>=')
        count = int(size[2:]) if lower else size
        assert isinstance(count, int) and 0 <= count <= m-start
        result.extend((data, block, True) for data in range(start, start+count))
        if lower:
            assert block == len(sizes)-1
        elif start+count < m:
            result.append((start+count, block, False))
        start += count
    return result


def source_constraints(record, peer):
    rec = json.loads(Path(record['file']).read_text())
    assert sha(record['file']) == record['peer_sha256'], 'Peer decision changed.'
    suffix = '_v2' if record['variant'] == 'v2' else ''
    meta_path = peer / f"base/base_k31_c{record['c']}{suffix}.json"
    meta = json.loads(meta_path.read_text())
    assert rec['base_cnf_sha256'] == meta['cnf_sha256']
    positions = meta['position_choices']
    expected = [positions[0][record['i']], positions[1][record['j']]]
    assert rec['units'][:2] == expected
    extra = rec['units'][2:]
    source = dict(peer_metadata=str(meta_path), peer_metadata_sha256=sha(meta_path),
                  block_units=[], block_sizes=None)
    if record['cube'] is None:
        assert not extra, 'Unrecognized whole-case restrictions.'
        return source
    parent = record['case'].rsplit('_q', 1)[0]
    cube_path = peer / 'cubes' / (parent+'.json')
    cubes = json.loads(cube_path.read_text())
    cube = cubes['cubes'][record['cube']]
    assert (cubes['c'], cubes['i'], cubes['j']) == (record['c'], record['i'], record['j'])
    assert cube['units'] == extra
    # Check a consistent, injective relation between saved peer variable IDs
    # and the semantic block-size labels over the entire peer partition.
    variable_to_block, block_to_variable = {}, {}
    for item in cubes['cubes']:
        semantic = block_restrictions(item['sizes'], record['m'], record['c'])
        assert len(semantic) == len(item['units'])
        for lit, (data, block, positive) in zip(item['units'], semantic):
            assert (lit > 0) == positive
            key = (data, block)
            assert variable_to_block.setdefault(abs(lit), key) == key
            assert block_to_variable.setdefault(key, abs(lit)) == abs(lit)
    source.update(block_units=block_restrictions(cube['sizes'], record['m'], record['c']),
                  block_sizes=cube['sizes'], cube_metadata=str(cube_path),
                  cube_metadata_sha256=sha(cube_path))
    return source


def restrict_case(enc, record, constraints):
    assert enc.k == record['k'] and enc.c == record['c'] and enc.m == record['m']
    selected = {p for p in (record['i'], record['j']) if p < enc.m}
    for p, flag in enumerate(enc.exception):
        enc.f.clause(flag if p in selected else -flag)
    for p in selected:
        for row in enc.outputs:
            enc.f.clause(-row[enc.n+p])
    for data, block, positive in constraints['block_units']:
        value = enc.block[data][block]
        enc.f.clause(value if positive else -value)


def build(record, directory, peer):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    tag = directory / 'base'
    constraints = source_constraints(record, peer)
    if Path(str(tag)+'.json').exists():
        meta = json.loads(Path(str(tag)+'.json').read_text())
        assert meta['crosscheck'] == record
        assert meta['peer_constraints'] == json.loads(json.dumps(constraints))
        assert meta['encoder_sha256'] == sha(Path(__file__).with_name('independent_c2.py'))
        assert meta['cnf_sha256'] == sha(str(tag)+'.cnf')
        return tag
    enc = Encoding(str(tag)+'.cnf', 5, 31, record['c'], 2,
                   lattice_comparands=record['variant'] == 'v1', useful=False)
    restrict_case(enc, record, constraints)
    meta = enc.metadata()
    enc.f.finish()
    meta.update(cnf_sha256=sha(str(tag)+'.cnf'), crosscheck=record,
                peer_constraints=constraints, adapter_sha256=sha(__file__))
    Path(str(tag)+'.json').write_text(json.dumps(meta, indent=2)+'\n')
    return tag


def certify_cube_cover(parent, directory, peer):
    """Certify the translated Boolean cube cover independently of programs."""
    from certify_c2 import solve
    cube_path = peer/'cubes'/(parent+'.json')
    cubes = json.loads(cube_path.read_text())
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    tag = directory/'cover'
    decision = Path(str(tag)+'_answer.json')
    if decision.exists():
        rec = json.loads(decision.read_text())
        assert rec['status'] == 'UNSAT_VERIFIED' and rec['verified']
        assert rec['config']['peer_cube_sha256'] == sha(cube_path)
        return rec
    formula = Formula(str(tag)+'.cnf')
    block = [[formula.var() for _ in range(cubes['c'])] for _ in range(31-cubes['c'])]
    for item in cubes['cubes']:
        restrictions = block_restrictions(item['sizes'], len(block), cubes['c'])
        formula.clause(*(-block[g][b] if positive else block[g][b]
                         for g, b, positive in restrictions))
    formula.finish()
    metadata = dict(encoder_sha256=sha(__file__), cnf_sha256=sha(str(tag)+'.cnf'),
                    config=dict(control='translated cube cover',
                                peer_cube_sha256=sha(cube_path), parent=parent))
    Path(str(tag)+'.json').write_text(json.dumps(metadata)+'\n')
    result = solve(tag, str(tag)+'_answer')
    assert result['status'] == 'UNSAT_VERIFIED'
    return result
