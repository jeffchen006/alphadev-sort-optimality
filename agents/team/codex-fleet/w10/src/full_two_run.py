#!/usr/bin/env python3
"""Sharpen the partial-three reduction to two full exceptions. Use nice 19."""
import json
import resource

import full_run as work


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    summary = json.loads((work.ROUND/'summary.json').read_text())
    assert summary.get('complete') and len(summary['queries']) == 5, 'Finish the first full-column run first'
    summary['complete'] = False
    summary['reduction'] = 'q original undefined-containing versions -> at most max(0,q-1) full non-lattice versions'
    work.save(summary)
    work.query(summary, 'n5_k31_full2_fixedflags', ['--bound', '2', '--free-first',
               '--flag-program', str(work.HERE/'programs/exception_0_original.s')])
    work.query(summary, 'n5_k31_full2_freeflags', ['--bound', '2'])
    summary['complete'] = True
    work.save(summary)


if __name__ == '__main__':
    main()
