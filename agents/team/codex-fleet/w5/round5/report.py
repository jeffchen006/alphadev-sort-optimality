"""Append the final round-5 record after every search and judge job finishes."""
from pathlib import Path
from collections import Counter
import hashlib,json,subprocess,sys
HERE=Path(__file__).resolve().parent
subprocess.run(['nice','-n','19',sys.executable,'-B',str(HERE/'summarize.py')],check=True,capture_output=True)
s=json.loads((HERE/'summary.json').read_text())
for name in ['fuse','retime','free_a','free_b','retimed_free_a','retimed_free_b']:
    assert s[name]['done'] and s[name]['unknown']==0,(name,s[name])
ledger=json.loads((HERE/'verified_integrity.json').read_text())
assert all(r['passed'] and r['intact'] for r in ledger)
assert len(ledger)==len({r['file'] for r in ledger})
assert len(ledger)>=290
assert all(r['k']==32 for r in ledger), 'Handle a shorter PASS result before writing this negative report.'
sat=[]
for path in sorted(HERE.glob('sat_results_*.json')):sat.extend(json.loads(path.read_text()))
assert len(sat)==49,len(sat)
assert all(r['status']!='ERROR' for r in sat)
status=dict(Counter(r['status'] for r in sat))
pair=json.loads((HERE/'pair_audit.json').read_text())
keys={(r['seed'],*r['pair']) for r in pair['rows']}
audit=(HERE/'candidates/fuse_audit.txt').read_text().splitlines()
ops=Counter(line.split()[4] for line in audit)
manifest=json.loads((HERE/'manifest.json').read_text())
retimed=json.loads((HERE/'retimed_manifest.json').read_text())
for row in manifest+retimed:
    assert hashlib.sha256(Path(row['source']).read_bytes()).hexdigest()==row['sha256']
def grouped(names):
    return {k:sum(s[n][k] for n in names) for k in ('seeds','nodes','insertions','leaves','solutions')}
lines=['','', '## Round 5: pair fusion with flag and source rewrites','', '### Purpose','',
'Find k<=31 by sharing the work of two instruction events. Read all previous results first. This round uses a new trace-preserving rewrite search. It does not rerun the excluded network, routing, lattice, or Hamming-distance searches.','',
'No program with k<=31 received a strict judge PASS. The best verified core remains k=32. Its memory version has 42 instructions.','',
'### Terms','',
'A value column lists one register value for each of the 541 weak input orders. A flag column lists each comparison outcome. A terminal state reaches the end of the rewritten program with the required edit counts. A terminal state can still lack required output values. Search-node counts include visits before duplicate states are merged. They are not counts of distinct programs.','',
'### Method','',
'The frozen source set has 143 w6 round-2 variants and the w5 palette form. All 144 cores have k=32. Source paths, instruction lists, and SHA-256 hashes are in `round5/manifest.json`.','',
'The rules remove two distinct instruction events and insert at most one instruction at any gap. Every surviving write keeps its destination and its original full value column. Its opcode can become MOV or any supported CMOV. Its source can use any available register. Thus one fusion can repair many later consumers. The inserted write can construct any original value column. One fresh scratch register is available. Outputs can select new snapshots.','',
'The fixed-flag version preserves each surviving comparison column. It can change comparison operands. The free-flag version compares any available register pair at every surviving comparison. It can change every comparison column. Both operand orders are covered. Instructions with identical full effects share one state. The exact rule set and its limits are in `round5/RULES.md`; the implementation is `round5/src/rewrite.cpp`.','',
'The retiming scan removes one instruction and inserts at most one instruction. It tests moving a conditional operation across comparisons, replacing it with MOV, and repairing later sources and predicates. It retained one changed k=32 form per seed. The shorter-program scan then ran again from all 144 retained forms. Their paths and hashes are in `round5/retimed_manifest.json`.','',
'All search, compiler, simulator-check, and judge jobs use nice level 19. At most two CPU jobs run together. CPU affinity is 76–77. Search and SAT processes have a 2,800 MiB address-space limit. Every new file is inside w5.','',
'### Result','',
f'The CMOV-pair audit tested {pair["pairs"]:,} pairs and {pair["flag_choices"]:,} flag choices. It found {pair["witnesses"]} necessary value witnesses for {len(keys)} different pairs in {len({r[0] for r in keys})} seeds. Each witness also passed with reversed comparison operands and reversed predicates. These are value witnesses only. They do not establish a correct complete program. See `round5/pair_audit.json`.','',
f'The separate alternate-flag audit found {len(audit)} witnesses. Their replacement opcode counts are `{dict(ops)}`. These witnesses only copy a value that is already present. They yielded no shorter complete program in the completed rewrite scans. See `round5/candidates/fuse_audit.txt`.','',
'Every scan in the table finished all its seeds. No seed hit its time or state limit. None of the three shorter-program scans supplied all five output columns.','',
'| Completed scan | Seeds | Search-node visits | Insertions tried | Terminal states |','|---|---:|---:|---:|---:|']
for title,names in [('Fixed flags; two removals and one insertion',['fuse']),('Free comparisons; original seeds',['free_a','free_b']),('Free comparisons; retained retiming forms',['retimed_free_a','retimed_free_b'])]:
    q=grouped(names);lines.append(f'| {title} | {q["seeds"]} | {q["nodes"]:,} | {q["insertions"]:,} | {q["leaves"]:,} |')
lines += ['',f'The retiming scan visited {s["retime"]["nodes"]:,} nodes. It had {s["retime"]["solutions"]:,} successful edit paths, including paths that reconstruct the original instruction list. Of these paths, {s["retime"]["rewritten"]:,} changed the instruction list. These counts include duplicate programs. The 144 retained forms passed both strict judges.','',
'The independent transition check sampled all 144 seeds. It checked 57,600 conditional-move queries and 39,655 comparison reversals. No mismatch occurred. The exact relaxed SAT-candidate evaluator also matched the reference scalar interpreter on 32 random programs, 256 input cases, and 41,472 register values. These are test results, not proofs of the implementation. Logs: `round5/logs/check.log` and `round5/logs/test_relaxed.log`. The duplicate-CMOV removal control passed both strict judges at k=32 and memory length 42.','',
'The SAT repair tested all 49 audited pairs from the 13 seeds with a witness. It first tested one shortest pair per seed, then tested the remaining 36 pairs. It deleted both CMOVs and inserted one write at the earlier gap. It freed write sources, write opcodes, and comparison operands in the surrounding window. Surviving write destinations stayed fixed. The inserted write had a free destination. These queries could create new intermediate value columns. Outside instructions and comparison positions stayed fixed. Outputs were free snapshots.','',
f'SAT status counts: `{status}`. Each query had a 15-second wall limit. An UNSAT result excludes only its stated finite query. A wall limit is UNKNOWN. Commands, windows, encoded case counts, and logs are in `round5/sat_results_*.json` and `round5/logs/fusion_sat_*.log`. The k=32 SAT control passed both strict judges.','',
f'The final judge ledger contains {len(ledger)} strict PASS files. Every out file below has k=32. Every corresponding memory file has 42 instructions. Each path, model, hash, and judge log is also in `round5/verified_integrity.json`.','',
'| Out PASS file | Memory PASS file |','|---|---|']
files={r['file']:r for r in ledger}
for row in sorted((r for r in ledger if r['model']=='out'),key=lambda r:r['file']):
    out=Path(row['file']);mem=out.with_name(out.stem+'_mem.s');assert str(mem) in files
    lines.append(f'| [{out.name}](round5/verified/{out.name}) | [{mem.name}](round5/verified/{mem.name}) |')
lines += ['', '### Limits','',
'The completed rewrite scans cover their finite value sets and edit pattern. They preserve the full value column of every surviving write. They exclude neither new value functions nor arbitrary changes to intermediate computations. Comparisons with unresolved scratch relations are outside the rewrite rules. The SAT queries fix scratch to 7 and initial flags to equal. A solver timeout gives no exclusion. No global instruction lower bound follows.','',
'### Conclusion','',
'The apparent pair savings did not produce a strict PASS core with k<=31. The target memory length of at most 41 remains open. All round-5 jobs have finished.','']
results=HERE.parent/'RESULTS.md'
assert '## Round 5:' not in results.read_text()
results.write_text(results.read_text()+'\n'.join(lines))
print(json.dumps(dict(appended=True,strict_pass_files=len(ledger),sat_status=status)))
