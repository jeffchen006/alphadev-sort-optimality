#!/usr/bin/env python3
"""Report incomplete C2 work explicitly. A prefix closes only after both children."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
from prefix_campaign import HERE, report


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--append', action='store_true')
    args = ap.parse_args()
    expected = [dict(c=c, prefix_count=105) for c in range(1, 16)]
    summaries = []
    # Keep revisions separate; do not add counts for overlapping classes.
    for revision in ('cases', 'cases_v2'):
        rows = []
        for c in range(1, 16):
            path = HERE/f'independent/{revision}/c{c}/state.json'
            if path.exists():
                state = json.loads(path.read_text())
                counts = {}
                for node in state['nodes'].values():
                    status = node['status']
                    counts[status] = counts.get(status, 0)+1
                memo = {}
                def closed(name):
                    if name not in memo:
                        node = state['nodes'][name]
                        memo[name] = (node['status'] == 'UNSAT_VERIFIED' or
                            (node['status'] == 'BRANCHED' and
                             all(closed(ch) for ch in node['children'])))
                    return memo[name]
                done = sum(closed(name) for name in state['roots'])
                rows.append(dict(c=c, roots=105, closed_roots=done,
                                 open_roots=105-done, leaf_statuses=counts))
            else:
                rows.append(dict(c=c, roots=105, closed_roots=0, open_roots=105,
                                 leaf_statuses={'NOT_STARTED': 105}))
        summaries.append(dict(revision=revision, comparison_counts=rows,
                              closed_roots=sum(r['closed_roots'] for r in rows),
                              open_roots=sum(r['open_roots'] for r in rows)))
    result = dict(time=datetime.now(timezone.utc).isoformat(),
                  full_root_count=1575, required_comparison_counts=expected,
                  revisions=summaries, complete=False,
                  c0='Separate no-comparison relaxation with checked DRAT certificate; reduction needs review.',
                  review='Normal forms and encoder need judge review.',
                  peer_results=list(map(str, (HERE.parent.parent/'d2-lattice/c2/results').glob('*.json'))))
    dest = HERE/'independent/global_status.json'
    dest.write_text(json.dumps(result, indent=2)+'\n')
    if args.append:
        with (HERE/'RESULTS.md').open('a') as out:
            for rev in summaries:
                out.write(f"\n{result['time']}: {rev['revision']} prefix roots decided "
                          f"{rev['closed_roots']} / remaining {rev['open_roots']} / "
                          f"unknown {rev['open_roots']} (1575 roots over c=1..15).\n")
    print(json.dumps(dict(time=result['time'], revisions=[
        {k:v for k,v in r.items() if k != 'comparison_counts'} for r in summaries],
        peer_cases_available=len(result['peer_results']))), flush=True)


if __name__ == '__main__':
    main()
