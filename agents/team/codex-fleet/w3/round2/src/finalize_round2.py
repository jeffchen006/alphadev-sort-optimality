#!/usr/bin/env python3
"""Append the completed round-2 record after both routing partitions finish."""
import collections,json,re,sys
from pathlib import Path
from report_round2 import main as summarize
ROOT=Path(__file__).resolve().parents[2]
for part,want in [(0,102),(1,101)]:
    fn=ROOT/'round2/logs'/f'retry_routes_{part}.jsonl'
    rows=[json.loads(s) for s in fn.read_text().splitlines()]
    got=sum('file' in r for r in rows)
    assert got==want,(part,got,want)
summarize()
s=json.loads((ROOT/'round2/logs/summary.json').read_text());rt=s['routing'];sat=s['sat']
final={}
for fn in [ROOT/'round2/logs/route_batch.jsonl']+sorted((ROOT/'round2/logs').glob('retry_routes_*.jsonl')):
    for line in fn.read_text().splitlines():
        r=json.loads(line)
        if 'file' not in r:continue
        m=re.search(r'RESULT (\w+)',r['result']);final[r['file']]=m[1] if m else 'TIMEOUT'
unresolved=[f for f,st in sorted(final.items()) if st!='NONE']
(ROOT/'round2/logs/unresolved_routes.txt').write_text('\n'.join(unresolved)+'\n')
passes=[];encs={}
for fn in sorted((ROOT/'round2/logs').glob('*.log')):
    for line in fn.read_text().splitlines():
        if line.startswith('{'):
            r=json.loads(line)
            if r.get('event')=='ENC':encs[r['tag']]=r
        if line.startswith('JUDGE PASS '):
            match=re.match(r'JUDGE PASS (\S+) .* n=(\d+) L=(\d+).*model=(\S+)',line)
            assert match,line
            file,n,k,model=match.groups();passes.append(dict(file=str(Path(file).relative_to(ROOT)),k=int(k),model=model,log=str(fn.relative_to(ROOT)),judge=line))
assert len(passes)==5,passes
(ROOT/'round2/logs/judge_registry.json').write_text(json.dumps(passes,indent=2)+'\n')
counts=collections.Counter(r['status'] for r in sat)
assert counts['UNSATISFIABLE']==16,counts
assert counts['SATISFIABLE']==5,counts
assert counts['TIMEOUT']==11,counts
out=['\n## Round 2 final results\n',
'No program with core k <= 31 passed the strict judge in round 2. The runs below are complete. This final record supersedes the earlier progress counts.\n',
'### New routing searches at k=31\n',
'Each of 1,224 new exact value skeletons received a 400,000-call pass. That pass returned 1,021 NONE results and 203 call limits. Each of the 203 unresolved cases then received a 2,000,000-call pass with a 20 s time limit. No search returned FOUND.\n',
'| Second-pair family | Distinct skeletons | Final NONE | Final limits |\n| --- | ---: | ---: | ---: |']
for family in ['adaptive','fixed']:
    c=rt['families'][family];out.append(f"| {family} | {sum(c.values())} | {c.get('NONE',0)} | {sum(v for k,v in c.items() if k!='NONE')} |")
out += [f"\nTotal: **{rt['statuses'].get('NONE',0)} NONE**, **{len(unresolved)} unresolved**. The logs record {rt['calls']:,} calls across both passes, including repeated work on extended cases.\n",
'The adaptive family covers all 16 minima/maxima truth tables for comparison 3. The fixed family covers rules 0, 6, 8, 10, and 12. Each family tests six residual trees and ten orientation patterns before duplicate removal. The patterns include reversals based on previous flags and two seeded random patterns.\n',
'`round2/logs/route_batch.jsonl` and `round2/logs/retry_routes_{0,1}.jsonl` contain every result. `round2/logs/unresolved_routes.txt` lists the remaining skeletons. `round2/logs/summary.json` records the counts in machine-readable form.\n',
'### SAT register-profile results at k=31\n',
'All rows in this table returned UNSATISFIABLE. The profile gives the number of data instructions after comparisons 1 through 7. The result applies to that register limit, schedule, exact operand family, and arbitrary operand reversal model.\n',
'| Run | Registers | Data profile | Seconds |\n| --- | ---: | --- | ---: |']
for r in sat:
    if r['status']!='UNSATISFIABLE':continue
    tag=r['tag'];e=encs[tag]
    out.append(f"| `{tag}` | {e['registers']} | {','.join(map(str,e['profile']))} | {r['elapsed']:.1f} |")
out += ['\n`partial_profile_0` and `partial_profile_1` permit conditional writes into scratch registers before any unconditional write. These models track a garbage origin. They do not permit that origin in comparison operands or outputs on the 120 tested strict orders. Other profile rows require unconditional initialization.\n',
'### SAT runs that reached time limits\n',
'| Run | Seconds |\n| --- | ---: |']
for r in sat:
    if r['status']=='TIMEOUT':out.append(f"| `{r['tag']}` | {r['elapsed']:.1f} |")
out += ['\nThe two `allorient_exact` runs test one residual tree with all history-dependent operand reversals. Exact operand constraints remain on early finishing paths. The `complete_*_mv5` runs allow 72 choices per initial two-comparison history: a minima/maxima choice and two independently selected residual trees. This gives 72^4 = 26,873,856 tree-profile combinations. These runs allow at most five copies. They do not establish a negative bound.\n',
'The `adaptive_extra_select_g*` runs fix a prefix that copies input 3, conditionally selects input 4 from the first flag, and compares input 2 with that selected value. The solver can add other data operations before comparison 2. These runs allow 19, 20, 21, or 22 conditional moves and at most 24 minus that count copies. They also permit six residual tree choices per initial three-comparison history. All allow arbitrary operand reversals after the fixed prefix.\n',
'The `flex_*` and `partial_flex_R8` runs permit at most eight data instructions after each comparison and at most 24 data instructions in total. SAT selects the schedule. The phase and register limits remain search restrictions. All three runs reached their time limits.\n',
'### Every new strict PASS file\n',
'All five new PASS files are controls with seven comparisons and core k=53. They are not target improvements.\n',
'| File | Model | Core k | Judge log |\n| --- | --- | ---: | --- |']
for p in passes:out.append(f"| `{p['file']}` | {p['model']} | {p['k']} | `{p['log']}` |")
out += ['\n`round2/logs/judge_registry.json` stores the exact PASS lines. No new memory-model candidate was produced because no target out-model candidate passed. The round-1 PASS paths remain listed above.\n',
'### Limits and remaining choices\n',
'The negative results concern the listed exact skeletons and register profiles. They do not exclude all seven-comparison programs. The all-orientation tree-choice models and all three variable-schedule models remain unresolved. The routing limits are listed separately. Conditional scratch initialization remains open outside the two completed profiles.\n',
'Round 2 used at most two CPU search jobs with `nice -n 19`. The searches did not repeat the excluded c=8 controls, lattice searches, network classes, or completed round-1 routing skeletons.\n']
marker='## Round 2 final results'
p=ROOT/'RESULTS.md';assert marker not in p.read_text(),'Final record already exists'
with p.open('a') as f:f.write('\n'.join(out)+'\n')
print('APPENDED_ROUND2',counts,rt)
