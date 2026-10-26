#!/usr/bin/env python3
"""Reuse the independently audited initial-pool inclusion witnesses."""
import hashlib
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]

def main():
    old=json.loads((ROOT/'round5/logs/gate_bound_transfer.json').read_text())
    audit=json.loads((ROOT/'round5/logs/gate_bound_transfer_audit.json').read_text())
    verified=[]
    for gates in (9,10,11):
        path=ROOT/f'round6/logs/class21_gate{gates}_sinks.drat_check'
        if path.exists() and 's VERIFIED' in path.read_text():verified.append(gates)
    assert verified
    gates=max(verified);minimum=gates+1
    proof=ROOT/f'round6/logs/class21_gate{gates}_sinks.drat_check'
    # The older audit format is retained verbatim as evidence.
    bounds={str(row['class_id']):minimum for row in old['covered']}
    result=dict(reference_class=21,minimum_gates=minimum,covered_preserved_classes=len(bounds),
                covered_programs=sum(r['programs'] for r in old['covered']),
                transfer_witnesses=old['covered'],previous_audit=audit,
                proof_check=str(proof.relative_to(ROOT)),
                cnf_sha256=hashlib.sha256((ROOT/f'round6/logs/class21_gate{gates}_sinks.cnf').read_bytes()).hexdigest())
    (ROOT/'round6/logs/checked_gate_bounds.json').write_text(json.dumps(bounds,indent=2)+'\n')
    (ROOT/'round6/logs/gate_bound_transfer.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('transfer_witnesses','previous_audit')}),flush=True)

if __name__=='__main__':main()
