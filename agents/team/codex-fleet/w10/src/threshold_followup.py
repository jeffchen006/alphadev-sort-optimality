#!/usr/bin/env python3
"""Additional two-exception controls and comparison-count coverage. Use nice 19."""
import json
from pathlib import Path
import resource

import threshold_run as work


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    summary = json.loads((work.ROUND/'summary.json').read_text())
    assert summary.get('complete') and len(summary['partitions']) == 254
    summary['complete'] = False
    work.save(summary)
    source = (work.HERE/'programs/exception_0_normalized.s').read_text().splitlines()
    first = next(i for i, line in enumerate(source) if line.startswith('cmp '))
    for name, added, k in [
            ('two_nonlat_destination', ['mov S999, P0', 'cmovl S999, P2', 'cmovg S999, P4'], 35),
            ('two_nonlat_source', ['mov S999, P0', 'cmovl S999, P2',
                                   'mov S998, P4', 'cmovg S998, S999'], 36),
            ('two_nonlat_mov', ['mov S999, P0', 'cmovl S999, P2', 'mov S998, S999'], 35)]:
        path = work.ROUND/(name+'_source.s')
        path.write_text('\n'.join(source[:first+1]+added+source[first+1:])+'\n')
        q = work.query(summary, 'control_'+name, ['--k', str(k), '--free-first',
                       '--fixed', path], 60, 'SATISFIABLE')
        v = json.loads(Path(q['tag']+'.validation.json').read_text())
        assert len(v['nonlattice_full_data_nodes']) == 2 and not v['partial_data_nodes'], v
    work.query(summary, 'reject_second_nonlat', ['--k', '35', '--free-first', '--slots', '1',
               '--fixed', work.ROUND/'two_nonlat_destination_source.s'], 60, 'UNSATISFIABLE')
    for name, source, extra in [
            ('strong_control_pure', 'exception_0_normalized.s', ['--slots', '']),
            ('strong_control_one_exception', 'exception_0_eliminated.s', [])]:
        work.query(summary, name, ['--k', '32', '--free-first', '--fixed',
                   work.HERE/'programs'/source]+extra, 60, 'SATISFIABLE', script='threshold_strong.py')
    work.query(summary, 'n5_k31_strong_c9_all_shapes', [], 600, script='threshold_strong.py')
    for c in range(10, 16):
        work.query(summary, f'n5_k31_strong_c{c}_all_shapes', ['--c', str(c)], 60,
                   script='threshold_strong.py')
    summary['complete'] = True
    work.save(summary)


if __name__ == '__main__':
    main()
