#!/usr/bin/env python3
"""Collect recorded solver results and strict-judge output without rerunning searches."""
import argparse, collections, hashlib, json, re
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
def jsonlines(path):
 return [json.loads(s) for s in path.read_text().splitlines() if s.strip()] if path.exists() else []

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--append',action='store_true');args=ap.parse_args()
 routes=jsonlines(ROOT/'round3/logs/routes.jsonl')
 sats=jsonlines(ROOT/'round3/logs/sat.jsonl')+jsonlines(ROOT/'round3/logs/extra.jsonl')+jsonlines(ROOT/'round3/logs/followup.jsonl')
 registry=[]
 for path in sorted((ROOT/'round3').rglob('*.s')):
  matches=[];fails=[]
  logs=sorted((ROOT/'round3/logs').glob('*.log'))+sorted((ROOT/'round3').rglob('*.judge.txt'))
  for log in logs:
   for line in log.read_text().splitlines():
    if str(path) not in line:continue
    if line.startswith(('JUDGE PASS ','MEM_JUDGE PASS ','PASS ')):matches.append((str(log.relative_to(ROOT)),line))
    if line.startswith(('JUDGE FAIL ','MEM_JUDGE FAIL ','FAIL ')):fails.append((str(log.relative_to(ROOT)),line))
  ins=[s.strip() for s in path.read_text().splitlines() if s.strip() and not s.lstrip().startswith('#')]
  text=path.read_text();model='mem' if 'model=mem ' in text.splitlines()[0] else 'out'
  length=sum(not s.startswith('out ') for s in ins)
  registry.append(dict(file=str(path.relative_to(ROOT)),model=model,length=length,k=length-(10 if model=='mem' else 0),
   comparisons=sum(s.startswith('cmp ') for s in ins),status='PASS' if matches else 'FAIL' if fails else 'UNRECORDED',judge=matches or fails))
 (ROOT/'round3/logs/judge_registry.json').write_text(json.dumps(registry,indent=2)+'\n')
 routecalls=sum(int(re.search(r'calls=(\d+)',r['result'])[1]) for r in routes if 'calls=' in r['result'])
 summary=dict(routing=dict(cases=len(routes),statuses=dict(collections.Counter(
  re.search(r'RESULT (\w+)',r['result'])[1] if 'RESULT ' in r['result'] else 'UNKNOWN' for r in routes)),
  calls=routecalls,seconds=round(sum(r['seconds'] for r in routes),3)),sat=sats,judge=registry,
  candidate_routing=jsonlines(ROOT/'round3/logs/freecopy_routing.jsonl'),
  source_sha256={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()
   for p in sorted((ROOT/'round3/src').glob('*.py'))})
 (ROOT/'round3/logs/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
 print(json.dumps(dict(routing=summary['routing'],sat_runs=len(sats),
  statuses=dict(collections.Counter(result_status(r) for r in sats)),
  pass_files=sum(r['status']=='PASS' for r in registry)),indent=2))
 if not args.append:return
 if not any('QUEUE_COMPLETE' in s for s in (ROOT/'round3/logs/sat_driver.log').read_text().splitlines()):
  raise SystemExit('The SAT extension queue is not complete; final report not appended.')
 old=json.loads((ROOT/'round2/logs/summary.json').read_text())
 oldtags={r['tag'] for r in old['sat'] if r.get('status')=='TIMEOUT'}
 aliases={'retry_fixed_t5_cadical':'fixed_t5_allorient_exact','retry_flex_R6_cadical':'flex_R6_m0_fixed'}
 groups={tag:[r for r in sats if aliases.get(r['tag'],r['tag'])==tag] for tag in oldtags}
 extended=[r for r in sats if aliases.get(r['tag'],r['tag']) in oldtags]
 def resolved_status(rows):
  st=[result_status(r) for r in rows]
  return next((s for s in ('UNSATISFIABLE','SATISFIABLE','TIMEOUT') if s in st),'UNKNOWN')
 extstatus=dict(collections.Counter(resolved_status(rs) for rs in groups.values() if rs))
 (ROOT/'round3/logs/unresolved_sat.json').write_text(json.dumps(
  {tag:rs for tag,rs in groups.items() if resolved_status(rs) not in ('UNSATISFIABLE','SATISFIABLE')},indent=2)+'\n')
 targets=[r for r in registry if r['status']=='PASS' and r['k']<=31]
 found=(ROOT/'RESULTS.md').read_text().startswith('FOUND ')
 outcome=('A target program passed the strict judge. See the FOUND line at the top of this file.' if found
          else 'An out-model target passed, but the completed FOUND record is absent. Check the judge registry.' if targets
          else 'No program with core k <= 31 passed the strict judge in round 3.')
 lines=['','## Round 3 final SAT results','',outcome,'',
  f"The batch covered {sum(bool(rs) for rs in groups.values())} of the {len(oldtags)} round-2 SAT timeouts in {len(extended)} solver attempts. Final family results were `{extstatus}`.",'',
  'The table records solver results from the round-3 logs. A timeout remains unresolved. ',
  'Every search used one CPU job, `nice -n 19`, and a per-process virtual-memory limit of 2,900 MiB.',
  'The SAT extensions use all 120 strict input orders. The strict judge checks any decoded candidate separately.','',
  '| Run | Result | Configured limit (s) | Wall time (s) | Peak process RSS (KiB) |',
  '| --- | --- | ---: | ---: | ---: |']
 for r in sats:
  lines.append(f"| `{r['tag']}` | {result_status(r)} | {r['timeout']} | {r['seconds']:.1f} | {r.get('max_rss_kib',0)} |")
 lines+=['','The round-3 encodings add necessary value-preservation constraints. Until output rank j is recorded, ',
  'the input value for that rank must remain in some live register on every tested input order. ',
  'The encodings also restrict each output to a conditional move that creates its value. ',
  'A copy can use the earlier source value for its output snapshot. These clauses do not change the stated search model.','',
  '### Additional search models','',
  '- CaDiCaL retries use the fixed-pair exact-operand model and the six-register variable-schedule model. Each has a 300-second solver limit. The CaDiCaL process has a 1,800 MiB virtual-memory cap.',
  '- The new fixed-prefix gate budgets are 17, 18, and 23 conditional moves, with at most 24 minus that count copies. Each has core k <= 31.',
  '- `complete_one_select_g18` allows the third-comparison and residual-tree choices to vary in the adaptive-pair family. It has 18 conditional moves and at most six copies, so core k <= 31.',
  '- The two `freecopy_complete_g18_*` runs allow 18 conditional moves with free copies. These are relaxations for their gate-count budgets. Their decoded programs can exceed k=31.',
  '- If a free-copy run produces a program, `route_candidate.py` minimizes copies for its fixed conditional-move graph. It preserves the selected output nodes and runs the strict judge on the resulting register program.',
  '- A new value skeleton from a free-copy candidate can receive a full k=31 routing search. The driver skips skeletons already present in earlier worker directories. `round3/logs/freecopy_routing.jsonl` records any such conditional follow-up; no file means no follow-up ran.',
  '- `partial_free_finished_R8` permits arbitrary final operands on already finished strict-order histories. It uses eight registers, up to eight data slots per comparison phase, and at most 24 active data instructions. Scratch has a common +infinity origin in the search. Conditional writes before unconditional initialization are allowed.',
  '- `partial_robust_finished_R8` adds a second final-flag case when a finished history compares scratch garbage. Both possible low/nonlow outcomes must give the required outputs. This is an additional restriction; it is not a complete arbitrary-garbage encoding.',
  '- Both finished-history models use complementary `cmovl`/`cmovge` conditions and fixed remaining tree/mask profiles. These are search limits. Only a reference-judge PASS establishes candidate correctness.','',
  '### Every new strict PASS file','',
  '| File | Model | Core k | Comparisons | Judge log |','| --- | --- | ---: | ---: | --- |']
 for r in registry:
  if r['status']=='PASS':
   logs=', '.join('`'+q[0]+'`' for q in r['judge'])
   lines.append(f"| `{r['file']}` | {r['model']} | {r['k']} | {r['comparisons']} | {logs} |")
 seven=[r for r in registry if r['status']=='PASS' and r['model']=='out' and r['comparisons']==7]
 if seven and min(r['k'] for r in seven)<53:
  best=min(seven,key=lambda r:r['k'])
  lines+=['',f"The shortest new seven-comparison strict PASS has core k={best['k']}: `{best['file']}`."]
 lines+=['','`round3/logs/summary.json` records the routing counts, solver rows, and source hashes. ',
  '`round3/logs/judge_registry.json` records the exact strict-judge PASS lines. ',
  'The control programs verify encoding behavior and do not improve the known bound. ',
  'No solver timeout establishes a negative bound. The completed routing results apply only to their exact skeletons.','']
 if '## Round 3 final SAT results' in (ROOT/'RESULTS.md').read_text():
  raise SystemExit('The round-3 final report has already been appended.')
 with (ROOT/'RESULTS.md').open('a') as f:f.write('\n'.join(lines))

def result_status(row):
 found=[]
 for s in row.get('result',[]):
  if s.startswith('{'):
   try:found.append(json.loads(s).get('status','UNKNOWN'))
   except ValueError:pass
 return ', '.join(found) if found else ('ERROR' if row.get('rc') else 'UNKNOWN')

if __name__=='__main__':main()
