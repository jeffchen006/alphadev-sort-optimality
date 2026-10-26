#!/usr/bin/env python3
"""Build independent cross-checks only for completed, verified d2 cases.

This never imports a peer encoder. It reads only the peer decision metadata.
Run --list to report availability. Use --case NAME to build an independent
case formula, then use prefix_campaign.py with the printed base and directory.
"""
import argparse
import json
from pathlib import Path
from prefix_campaign import HERE
from peer_cases import discover, build

PEER = HERE.parent.parent/'d2-lattice/c2'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--case')
    args = ap.parse_args()
    records, unresolved = discover(PEER)
    dest = HERE/'independent/peer_availability.json'
    dest.write_text(json.dumps(dict(peer_directory=str(PEER/'results'),
                                   verified_unsat_cases=records,
                                   unresolved_peer_cases=unresolved), indent=2)+'\n')
    if not args.case:
        print(json.dumps(dict(available=len(records), cases=records,
                              unresolved_peer_cases=len(unresolved))), flush=True)
        return
    rec = next((r for r in records if r['case'] == args.case), None)
    assert rec is not None, 'The requested peer case is not completed and verified.'
    directory = HERE/'independent/crosscheck'/rec['case']
    directory.mkdir(parents=True, exist_ok=True)
    tag = build(rec, directory, PEER)
    print(json.dumps(dict(base=str(tag), case_directory=str(directory/'cubes'),
                          peer=rec, scope='Independent V1/V2 position case and translated block cube.')),
          flush=True)


if __name__ == '__main__':
    main()
