"""Audit recorded coverage, preserve exact scopes, and append the round report."""
import argparse,collections,hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent;WORK=HERE.parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--append',action='store_true');a=ap.parse_args()
 bases=json.loads((HERE/'bases.json').read_text());audit=json.loads((HERE/'audit.json').read_text())
 assert audit['status']=='PASS_INTERNAL_AUDIT'
 for b in bases:
  assert hashlib.sha256(Path(b['path']).read_bytes()).hexdigest()==b['sha256']
 batches=[];maxrss=0;coverage={}
 for p in sorted(HERE.glob('*_batch.json')):
  rows=json.loads(p.read_text());indices=[r['index'] for r in rows]
  assert len(indices)==len(set(indices)),p
  for r in rows:
   if 'args' not in r:continue
   args=r['args'];b=bases[r['index']]
   assert r['key']==b['key']
   source=HERE/r['result'];assert json.loads(source.read_text())['status']==r['status']
   expected=b['exclusive'] if args['mode']=='exclusive' else b['median_cone'] if args['mode']=='cone' else sorted(set(b['exclusive'])|set(b['writes'][-args['tail']:]))
   if args['mode']=='schedule' and args['schedule_scope']=='cone':expected=b['median_cone']
   if args['mode']=='schedule' and args['schedule_scope']=='exclusive':expected=b['exclusive']
   assert r['editable']==expected,(p,r['index'])
   if args['unbounded']:
    fresh=r['registers']-len(b['names']);assert fresh in (2*len(expected),2*max(0,len(expected)-1))
    assert fresh>=2*(len(expected)-(0 if args['control'] else 1))
   else:assert r['registers']==len(b['names'])+args['extra']
   if not args['control']:
    mode=args['mode'];scope=args['schedule_scope'] if mode=='schedule' else mode
    family=f'{b["kind"]}_{mode}_{scope}'+(f'_{args["tail"]}' if scope=='tail' else '')+('_arbitrary_names' if args['unbounded'] else f'_fresh{args["extra"]}')
    group=coverage.setdefault(family,{})
    old=group.get(r['index'])
    assert not (old=='UNSAT' and r['status']=='CANDIDATE'),(family,r['index'])
    if old is None or r['status'] in ('UNSAT','CANDIDATE'):group[r['index']]=r['status']
  counts=dict(collections.Counter(r['status'] for r in rows))
  rss=max((r.get('maxrss_kib',0) for r in rows),default=0);maxrss=max(maxrss,rss)
  batches.append(dict(path=str(p),tests=len(rows),counts=counts,
   cpu=sum(r.get('total_cpu',0) for r in rows),indices=indices,maxrss_kib=rss))
 for p in HERE.glob('*.resources'):
  m=re.search(r'Maximum resident set size \(kbytes\):\s*(\d+)',p.read_text())
  if m:maxrss=max(maxrss,int(m[1]))
 ledger=json.loads((HERE/'pass_ledger.json').read_text())
 short=[]
 for r in ledger:
  assert hashlib.sha256(Path(r['path']).read_bytes()).hexdigest()==r['sha256']
  assert r['result']=='PASS' and Path(r['log']).read_text().startswith('PASS '),r
  if r['model']=='out':
   k=sum(bool(z) and not z.startswith(('#','out ')) for z in Path(r['path']).read_text().splitlines())
   if k<=31:short.append(dict(k=k,path=r['path']))
 combined=[]
 for family,group in sorted(coverage.items()):
  kind=family.split('_')[0];expected=sum(b['kind']==kind for b in bases)
  counts=dict(collections.Counter(group.values()));counts['UNATTEMPTED']=expected-len(group)
  combined.append(dict(family=family,expected=expected,counts=counts,indices=group))
 summary=dict(bases=dict(collections.Counter(b['kind'] for b in bases)),batches=batches,combined=combined,
  maxrss_kib=maxrss,strict_pass_files=len(ledger),internal_audit=audit,
  source_hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(HERE.glob('*.py'))},
  budget_overrides=json.loads((HERE/'budget_overrides.json').read_text()))
 (HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
 text=['\n\n# Round 9: median paths with free names and added positions','',
 ('No core with `k <= 31` was found.' if not short else 'FOUND '+str(short))+' The model assumptions are **G1-G4**.',
 'The local rewrite scope is **A11**. The completed arbitrary-name tests',
 'remove **A2** within their stated families. The larger two-added-position',
 'tests retain two fresh names and therefore use **A2**. The smaller',
 'tail-three tests also cover arbitrary names.',
 'No result contradicts an assumption.','',
 'The nine-comparison set contains all 26 bases from `d7-structure/fam32`.',
 'The eight-comparison set contains all 144 bases in the round 4 input ledger.',
 'The instruction census also checked the earlier repair collection: the',
 '15 w6 repairs used in rounds 7-8 have nine comparisons. The w9 repair has',
 'eight comparisons. This round uses actual comparison counts to select bases.',
 'It does not repeat the earlier fixed-position searches on those repairs.','',
 'The completed negative families cover all 26 nine-comparison bases for',
 'median-only edits and six-write tail edits. They also cover all 144',
 'eight-comparison bases for the three-write tail scheduler. These families',
 'permit arbitrary register names. The larger tested families remain unknown.','',
 'An exclusive instruction affects only output 2, the median. The tail tests',
 'also edit the specified last writes in its dependency cone. Each editable',
 'instruction can select any I1 opcode and permitted operands, or be omitted.',
 'The median can use any register at any boundary. The other four outputs',
 'retain their registers and original core boundaries.','',
 'For m editable instructions, the arbitrary-name tests allow 2m fresh names.',
 'Each instruction has two operands. This covers every name that can occur',
 'in the fixed-position family. Fresh names follow their first occurrence.',
 'An untouched scratch register cannot be a correct strict median output.','',
 'For a scheduler with m editable original instructions, the fixed core',
 'contains 32-m instructions. A k=31 budget leaves at most m-1 active free',
 'instructions, including additions. They can mention at most 2(m-1) fresh',
 'names. The first tail-three tests allow 2m fresh names. The final retry',
 'uses the tighter 2(m-1) bound. Both bounds therefore cover',
 'arbitrary names in their stated scheduled family.','',
 'The scheduler adds two optional positions at solver-selected gaps, from the',
 'first editable original instruction through the end. Both can use the same',
 'gap. The solver can also change or omit each selected original instruction.',
 'The total count of retained instructions is at most 31. Fixed output events',
 'can occur before, between, or after additions in their original core gap.',
 'See [round9/METHODS.md](round9/METHODS.md) for the encoding and limits.','',
 '| Run | Tests | UNSAT | Unknown | Scalar candidates | CPU seconds |',
 '| --- | ---: | ---: | ---: | ---: | ---: |']
 for b in batches:
  c=b['counts'];text.append(f'| `{Path(b["path"]).stem}` | {b["tests"]} | {c.get("UNSAT",0)} | {c.get("UNKNOWN",0)} | {c.get("CANDIDATE",0)} | {b["cpu"]:.3f} |')
 text+=['','Each UNSAT entry is a completed negative for its stated finite family.',
 'A limit or failed process is unknown. A family with unresolved entries is',
 'not exhausted. The result ledgers retain the exact indices and arguments.','',
 'The solver uses scratch value 5 and initial equality flags. These are',
 'permitted initial values. Every strict program must work for them.',
 'Thus UNSAT excludes a strict program within the stated family. A scalar',
 'candidate still requires the shared strict judge.','',
 f'The independent scalar audit checked **{audit["value_checks"]:,} register values**,',
 f'**{audit["schedule_traces"]} scheduling traces**, and **{audit["fresh_name_traces"]:,} fresh-name traces**.',
 f'It also checked **{audit.get("budget_checks",0)} instruction-budget cases**.',
 'These checks validate the implementation. They are not a formal certificate.',
 'The positive controls keep the original 32-instruction cores. For scheduled',
 'controls, both added positions are omitted. Every control below passed the',
 'shared strict judge. Its memory form has length 42. Exact judge output,',
 'commands, and hashes are in [round9/pass_ledger.json](round9/pass_ledger.json).','',
  'Combined coverage merges retries of the same finite family.','',
  '| Family | Expected bases | UNSAT | Unknown or unattempted |',
  '| --- | ---: | ---: | ---: |']
 for c in combined:
  counts=c['counts'];text.append(f'| `{c["family"]}` | {c["expected"]} | {counts.get("UNSAT",0)} | {counts.get("UNKNOWN",0)+counts["UNATTEMPTED"]} |')
 text+=['','The smaller scheduler edits three original positions in 140 bases.',
  'It edits four positions in four bases because an earlier median-only',
  'instruction is also editable. Its final unresolved base, c8_b08, returned',
  'UNSAT after 18.122 CPU seconds. This closes that 144-base finite family.','',
  'The first 49 larger scheduling probes had 10-second CPU budgets.',
  'The remaining 95 had 2-second CPU budgets after the first probes all',
  'reached limits. Their saved arguments record the effective budgets.',
  'Longer all-order retries are separate table entries.','',
  'Example strict judge output:','', '```text']
 for stem in ('c9_control_00','c9_control_00_mem','c8_control_00','c8_control_00_mem'):
  text.append((HERE/(stem+'.judge.log')).read_text().strip())
 text+=['```','','Every new strict PASS file is listed below. These controls are not shorter sorters.','']
 for r in sorted(ledger,key=lambda r:r['path']):
  p=Path(r['path']);rel=p.relative_to(WORK)
  k=sum(bool(z) and not z.startswith(('#','out ')) for z in p.read_text().splitlines())
  text.append(f'- [{rel}]({rel}): `{r["model"]}`, length {k}.')
 text+=['','All CPU jobs ran sequentially on one CPU with `nice -n 19`.',
 f'The largest recorded resident memory was **{maxrss:,} KiB**.',
 'Each search had a 2,800 MiB address-space limit. All writes stayed in w1.',
 'Coverage, source hashes, and resource records are indexed in',
 '[round9/summary.json](round9/summary.json).','',
 'These finite local tests do not exclude arbitrary k=31 programs.',
 'No global lower bound or optimality proof is claimed.',
 ('The smallest strict-verified core remains k=32.' if not short else 'A shorter core received strict PASS: '+str(short)), '',
 'Reproduction: `nice -n 19 python3 round9/reproduce.py`.',
 'This round ran the stages separately. The full driver was syntax-checked.',
 'It was not rerun as one command.','']
 report='\n'.join(text);(HERE/'REPORT.md').write_text(report)
 if a.append:
  old=(WORK/'RESULTS.md').read_text();heading='# Round 9: median paths with free names and added positions'
  assert heading not in old,'Round 9 already appended'
  (WORK/'RESULTS.md').write_text(old+report)
 print(json.dumps({k:v for k,v in summary.items() if k not in ('source_hashes','internal_audit','batches','combined')},indent=2))
 print([(Path(b['path']).stem,b['counts']) for b in batches])
if __name__=='__main__':main()
