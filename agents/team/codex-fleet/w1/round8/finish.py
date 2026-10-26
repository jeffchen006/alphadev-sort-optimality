"""Audit search coverage. Append this round only when explicitly requested."""
import argparse,hashlib,json,re
from collections import Counter
from pathlib import Path
HERE=Path(__file__).resolve().parent;WORK=HERE.parent
ap=argparse.ArgumentParser();ap.add_argument('--append',action='store_true');a=ap.parse_args()
bases=json.loads((HERE/'bases.json').read_text())
assert len(bases)==62
for b in bases:assert hashlib.sha256(Path(b['path']).read_bytes()).hexdigest()==b['sha256']
searches={}
for path in sorted(HERE.glob('*_batch.json')):
 rows=json.loads(path.read_text())
 assert len({r['index'] for r in rows})==len(rows),path
 searches[path.stem]=dict(tests=len(rows),statuses=dict(Counter(r['status'] for r in rows)),
  total_cpu=sum(r.get('total_cpu',0) for r in rows),records=rows)
assert len(searches['exclusive_batch']['records'])==62
assert len(searches['control_batch']['records'])==32
assert all(r['status']=='CANDIDATE' for r in searches['control_batch']['records'])
final={r['index']:r for r in searches['exclusive_batch']['records']}
for section in searches.values():
 for r in section['records']:
  if r.get('args',{}).get('mode') not in ('exclusive','tail','cone') or r.get('args',{}).get('control'):continue
  # Wider registers or more editable positions also include the exclusive family.
  if r['status']=='UNSAT':assert set(bases[r['index']]['exclusive'])<=set(r['editable'])
  if r['status']=='UNSAT' or final[r['index']]['status']!='UNSAT':final[r['index']]=r
sympath=HERE/'symmetry.json';closed_sym=[]
if sympath.exists():
 sym=json.loads(sympath.read_text())
 for group in sym['classes']:
  negative=next((i for i in group if final[i]['status']=='UNSAT'),None)
  if negative is None:continue
  for i in group:
   if final[i]['status']!='UNSAT':closed_sym.append(dict(index=i,by=negative))
audit=json.loads((HERE/'audit.json').read_text());assert audit['status']=='PASS_OUTPUT_SELECTOR_AUDIT'
register_audit=json.loads((HERE/'audit_registers.json').read_text())
assert register_audit['status']=='PASS_FIRST_OCCURRENCE_AUDIT'
all_judges=json.loads((HERE/'pass_ledger.json').read_text())
ledger=[r for r in all_judges if r['result']=='PASS']
failed_judges=[r for r in all_judges if r['result']!='PASS']
assert len([r for r in ledger if Path(r['path']).stem.startswith('control_')])==64
for row in ledger:assert hashlib.sha256(Path(row['path']).read_bytes()).hexdigest()==row['sha256']
rss=[]
for path in HERE.glob('*.resources'):
 m=re.search(r'Maximum resident set size \(kbytes\): (\d+)',path.read_text())
 if m:rss.append((int(m[1]),path.name))
result=dict(assumptions=['G1','G2','G3','G4','A11'],bounded_register_assumption='A2',
 bases=62,searches=searches,exclusive_final=dict(Counter(r['status'] for r in final.values())),
 exclusive_records=list(final.values()),symmetry_closed=closed_sym,
 exclusive_unknown=[dict(index=i,key=bases[i]['key']) for i,r in sorted(final.items()) if r['status']!='UNSAT'],
 audit=audit,register_audit=register_audit,passes=ledger,judge_failures=failed_judges,maxrss_kib=max(rss,default=(0,'')),
 sources={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in HERE.glob('*.py')})
(HERE/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
for name,section in searches.items():print(name,{k:v for k,v in section.items() if k!='records'})
print('EXCLUSIVE FINAL',result['exclusive_final'],'SYMMETRY',closed_sym,'MAXRSS',result['maxrss_kib'])
if not a.append:raise SystemExit(0)
lines=['', '', '# Round 8: median and adjacent-output SAT rewrites', '',
'No core with `k <= 31` was found. The model assumptions are **G1-G4**.',
'The local rewrite scope is **A11**. Tests with only two fresh registers also',
'use **A2**. No result contradicts an assumption.', '',
'The bases are the 15 original w6 k=31 near misses and the 16 strict-PASS',
'k=32 repairs used in round 7. Each base has two tests: outputs (1,2) and',
'outputs (2,3), with zero-based indices. This gives 62 base/pair tests.',
'The other three output registers and events stay fixed. Both selected',
'outputs can use any register at any boundary. The two-output searches do',
'not fix any intermediate value inside the editable positions.', '',
'An exclusive position affects the selected pair and no other output.',
'For outputs (1,2), the exclusive paths contain five to eight instructions.',
'Every such path contains one comparison. For outputs (2,3), the paths',
'contain two to six instructions. Eight of those 31 paths contain a comparison.',
'See [round8/bases.json](round8/bases.json) for exact positions and input hashes.', '',
'Each editable position permits any I1 instruction with freely chosen operands,',
'or an omitted instruction. A repair must omit at least one instruction.',
'A near miss can replace all selected instructions at the same k=31 budget.',
'The tail tests also free the last specified number of writes in the pair',
'dependency cone. Full-cone probes free all instructions in that cone.', '',
'| Run | Tests | UNSAT | Unknown | CPU seconds |',
'| --- | ---: | ---: | ---: | ---: |']
for name,x in searches.items():
 if name=='control_batch':continue
 lines.append(f'| `{name}` | {x["tests"]} | {x["statuses"].get("UNSAT",0)} | {x["statuses"].get("UNKNOWN",0)} | {x["total_cpu"]:.3f} |')
neg=result['exclusive_final'].get('UNSAT',0);unk=62-neg
lines+=['',f'Combining completed negatives, **{neg} of 62 exclusive tests are UNSAT**.',
 f'The other **{unk} tests remain unknown** before any symmetry implications.',
'Only a completed UNSAT test is a negative for its stated finite family.',
'A CPU limit or process failure is unknown. The complete pair family is not',
'claimed exhausted while any case remains unknown.', '',
'The all-order retries encode all 541 weak orders. Other tests add failed',
'weak orders after each SAT model. Scratch values start at 5 and initial',
'flags represent equality. A strict program must work for this initialization.',
'Thus UNSAT excludes strict correctness within the tested instruction family.',
'A scalar survivor is only a candidate until the shared strict judge passes it.', '',
'The unrestricted-register exclusive tests permit 2m fresh registers for m',
'editable instructions. Each instruction has two operands. Thus 2m names',
'cover every new register that can occur in this fixed-position family.',
'Fresh names follow their order of first occurrence. The independent check',
'exhausted **6,561 operand traces** for two editable positions. It matched the',
'naming clauses and verified every renamed representative. This removes A2',
'for completed negatives in this exclusive family. It does not remove A11.', '',
'The exact-template symmetry check found **62 distinct classes**. Input',
'renaming, scratch renaming, value-order reversal, and global comparison',
'reversal therefore closed no additional test. This is a completed dead end.', '',
'The compact encoder computes the unchanged prefix directly. It shares suffix',
'transition variables only when complete register values and flags agree.',
'Each weak order still imposes its own output requirements. See',
'[round8/METHODS.md](round8/METHODS.md) for the encoding and its limits.', '',
'The independent scalar selector audit checked **'+format(sum(r['selector_checks'] for r in audit['records']),',')+'** decisions.',
'It checked fixed and pinned instruction paths with both encoders.',
'Every decision agreed. The controls restore the original k=32 repairs.',
'All 32 controls received strict PASS in the out model and in the memory',
'model. Their memory forms have length 42. These are validation results,',
'not shorter sorters. Exact logs are in [round8/pass_ledger.json](round8/pass_ledger.json).', '',
'Every new strict PASS file is listed below.', '']
for row in ledger:
 p=Path(row['path']).relative_to(WORK)
 lines.append(f'- [{p}]({p}): {row["model"]}.')
lines+=['',
'All CPU jobs ran one at a time on one CPU with `nice -n 19`.',
'Each search had a 2,800 MiB address-space limit. The largest recorded',
f'resident memory was **{result["maxrss_kib"][0]:,} KiB**.',
'Commands, coverage, resource files, and source hashes are indexed in',
'[round8/summary.json](round8/summary.json). All writes stayed in w1.', '',
'These finite local results do not exclude arbitrary k=31 programs.',
'No global lower bound or optimality proof is claimed. The smallest',
'strict-verified core remains k=32.', '',
'Reproduction: `nice -n 19 python3 round8/reproduce.py`.',
'This round ran the stages separately. The full driver was syntax-checked.',
'It was not rerun as a single job.', '']
mark='# Round 8: median and adjacent-output SAT rewrites';old=(WORK/'RESULTS.md').read_text()
prefix=old.split(mark)[0].rstrip()
(WORK/'RESULTS.md').write_text(prefix+'\n'+'\n'.join(lines))
