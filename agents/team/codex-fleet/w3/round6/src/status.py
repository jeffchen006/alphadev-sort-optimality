#!/usr/bin/env python3
"""Read-only progress for the serial search driver."""
import json
from pathlib import Path
import time
ROOT=Path(__file__).resolve().parents[2]

def main():
    if (ROOT/'round6/FOUND').exists():
        print('FOUND_MARKER '+(ROOT/'round6/FOUND').read_text().strip());return
    if (ROOT/'round6/NEW_BUDGET').exists():
        print('NEW_BUDGET_MARKER '+(ROOT/'round6/NEW_BUDGET').read_text().strip());return
    parts=[]
    for family,expected in [('retry',19),('seven',2),('repeat',2)]:
        plan=ROOT/f'round6/logs/{family}_plan.json'
        total=len(json.loads(plan.read_text())) if plan.exists() else expected
        journal=ROOT/f'round6/logs/{family}.jsonl'
        records=[json.loads(l) for l in journal.read_text().splitlines()] if journal.exists() else []
        done={r['tag'] for r in records if r.get('returncode')==0 and r.get('results')}
        parts.append(f'{family}: {len(done)}/{total}')
    solvers=list((ROOT/'round6/logs').glob('*.solver'))
    if solvers:
        latest=max(solvers,key=lambda p:p.stat().st_mtime)
        minutes=max(0,int((time.time()-latest.stat().st_mtime)//60))
        data=latest.read_text(errors='replace')[:4096]
        status=next((line[2:] for line in data.splitlines() if line.startswith('s ')),None)
        lead=f'Latest solver: {latest.stem}'
        lead+=f' ({status}). ' if status else f' ({minutes} min since its log started). '
    else:lead='No solver log exists. '
    print(lead+'Completed queries — '+', '.join(parts)+'. No k <= 31 PASS.')

if __name__=='__main__':main()
