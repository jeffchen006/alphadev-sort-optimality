#!/usr/bin/env python3
"""Check variant, case-tag, and cube translation without running a peer encoder."""
import itertools
import json
from pathlib import Path
import tempfile
from types import SimpleNamespace

from independent_c2 import Formula, sha
from peer_cases import block_restrictions, variant_of, restrict_case, source_constraints, discover
from prefix_campaign import HERE, roots
from certify_c2 import solve


def certificate(tag, formula, config):
    formula.finish()
    metadata = dict(encoder_sha256=sha(__file__), cnf_sha256=sha(str(tag)+'.cnf'),
                    config=config)
    Path(str(tag)+'.json').write_text(json.dumps(metadata)+'\n')
    record = solve(tag, str(tag)+'_answer')
    assert record['status'] == 'UNSAT_VERIFIED'
    return record


def main():
    folder = HERE/'independent/peer_adapter_controls'
    folder.mkdir(parents=True, exist_ok=True)
    assert variant_of(dict(case='v2_c7_00_01', variant='_v2')) == 'v2'
    assert variant_of(dict(case='c9_00_01', variant='_v1')) == 'v1'
    assert variant_of(dict(case='v2_c7_00_01')) == 'v2'
    assert block_restrictions([2, '>=2'], 8, 4) == [
        (0, 0, True), (1, 0, True), (2, 0, False),
        (2, 1, True), (3, 1, True)]
    assert block_restrictions([0, 0], 8, 4) == [(0, 0, False), (0, 1, False)]
    assert block_restrictions([8], 8, 4) == [(g, 0, True) for g in range(8)]
    clauses = []
    fake = SimpleNamespace(n=5, k=31, c=9, m=22,
                           exception=list(range(100, 122)),
                           outputs=[list(range(200+30*r, 227+30*r)) for r in range(5)],
                           block=[[1000+9*g+b for b in range(9)] for g in range(22)],
                           f=SimpleNamespace(clause=lambda *xs: clauses.append(xs)))
    restrict_case(fake, dict(k=31, c=9, m=22, i=3, j=22),
                  dict(block_units=[(0, 0, True), (1, 0, False)]))
    assert clauses[:22] == [(100+p if p == 3 else -(100+p),) for p in range(22)]
    assert clauses[22:27] == [(-row[8],) for row in fake.outputs]
    assert clauses[27:] == [(1000,), (-1009,)]

    # Prefix completeness uses only the first instruction selectors. Negating
    # every saved prefix must be inconsistent with their one-hot constraints.
    tag = folder/'prefix_cover'
    f = Formula(str(tag)+'.cnf')
    op, src, dst = f.one(5), f.one(5), f.one(6)
    f.eq(op[0], dst[-1])
    prefixes = roots(dict(config=dict(n=5), op=[op], src=[src], dst=[dst]))
    assert len(prefixes) == 105
    for prefix in prefixes:
        f.clause(*(-lit for lit in prefix['units']))
    certificate(tag, f, dict(control='all 105 first-data prefixes cover the selector domain'))

    # Read only the semantic sizes in the real peer cube table. Build a new
    # formula over our own block variables and prove that the cubes cover all
    # Boolean assignments. No program-model constraints are needed here.
    peer = HERE.parent.parent/'d2-lattice/c2/cubes/c10_21_21.json'
    data = json.loads(peer.read_text())
    # Fixture decisions are isolated from the actual peer results directory.
    # They test the adapter only and are not search decisions.
    with tempfile.TemporaryDirectory(prefix='fixtures_', dir=folder) as temporary:
        fixture = Path(temporary)
        for subdir in ('base', 'results', 'cubes'):
            (fixture/subdir).mkdir()
        original = peer.parent.parent
        (fixture/'cubes'/peer.name).write_text(peer.read_text())
        for variant, suffix in [('v1', ''), ('v2', '_v2')]:
            name = f'base_k31_c10{suffix}.json'
            metadata = json.loads((original/'base'/name).read_text())
            (fixture/'base'/name).write_text(json.dumps(metadata))
            choices = metadata['position_choices']
            case = ('v2_' if variant == 'v2' else '')+'c10_21_21'
            record = dict(case=case, variant='_'+variant, cube=None, c=10, k=31,
                          i=21, j=21, m=21, status='UNSAT', verified=True,
                          units=[choices[0][21], choices[1][21]],
                          base_cnf_sha256=metadata['cnf_sha256'], synthetic_fixture=True)
            path = fixture/'results'/(case+'.json')
            path.write_text(json.dumps(record))
        # Check first, middle, and last real block-prefix cube descriptions.
        metadata = json.loads((fixture/'base/base_k31_c10.json').read_text())
        for index in (0, 6, 42):
            case = f'c10_21_21_q{index:03d}'
            record = dict(case=case, variant='_v1', cube=index, c=10, k=31,
                          i=21, j=21, m=21, status='UNSAT', verified=True,
                          units=[metadata['position_choices'][0][21],
                                 metadata['position_choices'][1][21]]+data['cubes'][index]['units'],
                          base_cnf_sha256=metadata['cnf_sha256'], synthetic_fixture=True)
            (fixture/'results'/(case+'.json')).write_text(json.dumps(record))
        records, unresolved = discover(fixture)
        assert len(records) == 5 and not unresolved
        for record in records:
            translated = source_constraints(record, fixture)
            if record['cube'] is None:
                assert not translated['block_units']
            else:
                assert translated['block_sizes'] == data['cubes'][record['cube']]['sizes']
    tag = folder/'peer_block_cover'
    f = Formula(str(tag)+'.cnf')
    block = [[f.var() for b in range(data['c'])] for g in range(31-data['c'])]
    for cube in data['cubes']:
        semantic = block_restrictions(cube['sizes'], len(block), data['c'])
        f.clause(*(-block[g][b] if positive else block[g][b]
                   for g, b, positive in semantic))
    certificate(tag, f, dict(control='translated peer block-prefix cover',
                            peer_cube_metadata=str(peer), peer_sha256=sha(peer)))
    print(json.dumps(dict(status='CONTROLS_PASS', prefix_roots=105,
                          peer_cubes=len(data['cubes']), checked_certificates=2)), flush=True)


if __name__ == '__main__':
    main()
