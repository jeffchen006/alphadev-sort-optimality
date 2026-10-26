"""Check artifact coverage and append this round to the result log."""
import hashlib,json,re
from collections import Counter
from pathlib import Path
HERE=Path(__file__).resolve().parent;WORK=HERE.parent
bases=json.loads((HERE/'bases.json').read_text())
for b in bases:assert hashlib.sha256(Path(b['path']).read_bytes()).hexdigest()==b['sha256']
def read(stem):return json.loads((HERE/(stem+'.json')).read_text())
exclusive=read('exclusive_r2');six=read('tail6_r2');eight=read('tail8_r2');schedule=read('schedule_r2');retry=read('schedule_r2_b10_11')
assert all(len(x)==16 and sorted(r['base'] for r in x)==list(range(16)) for x in [exclusive,six,eight,schedule])
final={r['base']:r for r in schedule}
for r in retry:final[r['base']]=r
assert all(r['status']=='UNSAT' for r in exclusive+six+list(final.values()))
checks=read('check_schedule');assert len(checks)==15 and all(r['survivors']==0 for r in checks)
assert 'RESULT NONE' in (HERE/'check_two.log').read_text()
controls=read('schedule_control_r2');assert len(controls)==16 and all(r['status']=='CANDIDATE' for r in controls)
ledger=read('pass_ledger');assert ledger and all(r['result']=='PASS' for r in ledger)
for row in ledger:assert hashlib.sha256(Path(row['path']).read_bytes()).hexdigest()==row['sha256']
summary=dict(assumptions=['G1','G2','G3','G4','A2','A11'],exclusive_counts=dict(Counter(len(b['exclusive']) for b in bases)),searches={},independent_checks=dict(one=checks,two=(HERE/'check_two.log').read_text().splitlines()[-1]),passes=ledger,sources={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in HERE.glob('*.py')})
for name,rows in [('exclusive',exclusive),('tail6',six),('tail8',eight),('schedule',list(final.values()))]:
 summary['searches'][name]=dict(tests=len(rows),statuses=dict(Counter(r['status'] for r in rows)),cpu=sum(r['cpu'] for r in rows),records=rows)
cone=[]
for path in sorted(HERE.glob('all_r2_allcases_b*.json')):cone+=json.loads(path.read_text())
if cone:summary['searches']['full_median_cone']=dict(tests=len(cone),statuses=dict(Counter(r['status'] for r in cone)),cpu=sum(r['cpu'] for r in cone),records=cone)
summary['maxrss_kib']=max((r.get('maxrss_kib',0) for section in summary['searches'].values() for r in section['records']),default=0)
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
mark='# Round 7: median-preserving SAT rewrites'
previous=(WORK/'RESULTS.md').read_text()
prefix=previous.split(mark)[0].rstrip()
lines=['', '',mark,'', 'No core with `k <= 31` was found. Assumptions: **G1-G4, A2, A11**.', '',
'The bases are the first strict-PASS k=32 repairs from round 6: 15 w6',
'representatives and the w9 representative. This round did not repeat the',
'earlier one-edit or sorting-network searches.', '',
'The static dependency analysis found **six bases with one median-only write,',
'nine with two median-only writes, and one with three median-only writes**.',
'A median-only write affects output 2 but no other output. None is a comparison.',
'The three-write case initializes an accumulator and then selects its value',
'twice using existing flags. Most of the median dependency cone is shared',
'with other outputs. See [round7/structure.json](round7/structure.json).', '',
'Each SAT slot chooses any I1 instruction, any source and destination from',
'original registers plus two fresh registers, or an omitted instruction.',
'The median can use any register at any instruction boundary. The other four',
'outputs retain their base registers and events. All instruction and output',
'choices are shared across input cases. No intermediate value column is fixed',
'inside the editable slots.', '',
'| Search | Completed UNSAT tests | Unknown tests | CPU seconds |',
'| --- | ---: | ---: | ---: |']
for label,name in [('Median-only positions','exclusive'),('Last six median-cone writes plus median-only writes','tail6'),('Last eight median-cone writes plus median-only writes','tail8'),('Median-only writes relocated to any gaps','schedule')]:
 x=summary['searches'][name];lines.append(f'| {label} | {x["statuses"].get("UNSAT",0)} | {x["statuses"].get("UNKNOWN",0)} | {x["cpu"]:.3f} |')
if cone:
 x=summary['searches']['full_median_cone'];lines.append(f'| Full median cone; all-case encoding attempted; bases 0, 10, 15 | {x["statuses"].get("UNSAT",0)} | {x["statuses"].get("UNKNOWN",0)} | {x["cpu"]:.3f} |')
lines += ['',
'Full-cone bases 0 and 10 reached CPU limits after encoding all 541 cases.',
'Base 15 stopped with `std::bad_alloc` under the 2,800 MiB address-space limit.',
'It has no final solver result. All three full-cone tests remain unknown.', '',
'For relocation, the search removes all m median-only writes and inserts at',
'most m-1 new instructions into any gaps in the retained event stream.',
'It includes two new instructions in the same gap. The hardest case permits',
'29 fixed core instructions plus two arbitrary new instructions. Its initial',
'45-second attempt was unknown. The retry completed UNSAT. Thus the relocation',
'family is exhausted for all 16 bases. This is a finite family result.', '',
'The encoder fixes scratch values at 5 and input ranks at 0 through 4.',
'It fixes initial flags to equality. It allows reads and comparisons of scratch',
'values. Every strict program must work for this initialization. Therefore',
'UNSAT excludes a strict program in the stated instruction and register family.',
'A solver limit is unknown. It is not a negative result. See',
'[round7/METHODS.md](round7/METHODS.md) for the exact scope.', '',
'The independent scalar enumeration matched every zero- and one-instruction',
'relocation result. It tested **'+format(sum(r['raw'] for r in checks),',')+'** raw plans across 15 bases.',
'The separate C++ checker exhausted the two-instruction relocation for base 10:',
'`'+summary['independent_checks']['two']+'`.',
'The transition audit checked 108 fixed and 126 editable instruction cases.',
'These are validation checks, not a formal certificate.', '',
'The gap controls restored the original median-only instructions at k=32.',
'Every control received strict PASS in the register and memory models.',
'The full strict-PASS ledger is [round7/pass_ledger.json](round7/pass_ledger.json).',
'Every new PASS file is listed below. These controls do not improve the length.', '']
for row in ledger:
 p=Path(row['path']).relative_to(WORK);lines.append(f'- [{p}]({p}): `{row["model"]}`, '+('k=32.' if row['model']=='out' else 'length 42.'))
lines += ['',
'All CPU jobs ran sequentially with `nice -n 19` on one CPU.',
'The address-space limit was 2,800 MiB. The largest recorded search resident',
f'memory was {summary["maxrss_kib"]:,} KiB. The records are in [round7/summary.json](round7/summary.json)',
'and the `round7/*.resources` files. No job exceeded 3 GB.', '',
'The completed negatives preserve the other instructions and output events.',
'They do not exclude broader rewrites of shared computation. The tested',
'larger families with solver limits remain unknown. No assumption was',
'contradicted. No global lower bound or optimality proof is claimed.',
'The smallest strict-verified core remains k=32.', '',
'Reproduction: `nice -n 19 python3 round7/reproduce.py`. This round ran its',
'commands separately. The full driver was syntax-checked, not rerun as one job.', '']
(WORK/'RESULTS.md').write_text(prefix+'\n'+'\n'.join(lines))
print(json.dumps({name:{k:v for k,v in s.items() if k!='records'} for name,s in summary['searches'].items()},indent=2))
print('RESULTS.md appended; strict PASS files',len(ledger))
