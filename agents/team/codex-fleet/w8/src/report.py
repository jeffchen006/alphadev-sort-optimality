#!/usr/bin/env python3
"""Build the worker report from saved generation, routing, and judge logs."""
from pathlib import Path
import json,collections,hashlib,re

rows=[]
for f in sorted(Path('logs').glob('*/results.jsonl')):
    data=[json.loads(s) for s in f.read_text().splitlines() if s.strip()]
    latest={r['file']:r for r in data}
    rows.append(dict(batch=f.parent.name,cases=len(latest),counts=dict(collections.Counter(r['status'] for r in latest.values())),calls=sum(r.get('calls',0) for r in data),records=data))
passes=[]
for f in sorted(Path('logs').glob('*.judge.log')):
    for line in f.read_text().splitlines():
        if line.startswith('PASS '):passes.append(dict(log=str(f),line=line,program=line.split()[1]))
summary=dict(batches=rows,passes=passes,sources={str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in sorted(Path('src').glob('*')) if f.is_file()})
satrows=[]
for f in sorted(Path('logs').glob('*/sat_results.jsonl')):
    data=[json.loads(s) for s in f.read_text().splitlines() if s.strip()]
    satrows.append(dict(batch=f.parent.name,cases=len(data),counts=dict(collections.Counter(r['status'] for r in data)),records=data))
summary['sat_batches']=satrows
Path('logs/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
target_passes=[r for r in passes if ((m:=re.search(r' L=(\d+).*model=(out|mem)',r['line'])) and int(m[1])<=(31 if m[2]=='out' else 41))]
lines=([('FOUND '+r['program']+'; '+r['line']) for r in target_passes] if target_passes else ['No program with core k <= 31 has passed the strict judge.'])+['',
'## Purpose','',
'Search nine-comparison sort5 programs that use partner values. A partner is the other value from an earlier sorted pair. Its route can depend on a later comparison.','',
'## Terms','',
'Core k counts register mov, cmp, and conditional-move instructions. A value column gives one register value on each of the 120 strict input orders. A skeleton fixes the comparison operand columns. NONE means the routing search completed in its stated representation. LIMIT and TIMEOUT give no negative bound. PASS means the strict reference judge accepted the file.','',
'## Method','',
'The main generator uses one comparison that conditionally swaps two disjoint pairs. One pair supplies the comparison operands. The other pair carries partner values. The generator places this step at comparison 2, 3, 4, 5, or 6. Ordinary compare-exchange steps complete the nine-comparison sequence. Each retained sequence sends all 120 strict input orders to one fixed permutation. Each retained skeleton contains an operand outside the monotone min/max model.','',
'Input renaming and independent comparison reversal remove duplicate skeletons. The generator tests whether a column has a monotone Boolean threshold table. A column that fails this test has no min/max term representation on these test orders. The routing search uses explicit columns and does not assume a sorting-network term set.','',
'`src/partner_networks.py` also enumerates all six-comparator completions after two sorted pairs and a pair-carry comparison of the maxima or minima. `src/switch_prefix.cpp` implements the wider conditional-swap generator. `src/mutation.cpp` changes one operand pair or condition in the functional graph of the supplied k=32 control. The mutation need not itself sort; its comparison history must distinguish all 120 strict orders.','',
'`src/nonlattice_filter.cpp` excludes matching nine-comparison skeletons from the d1 and w2 corpora. It skips prior skeletons that have only lattice operands. Such skeletons cannot match a new non-lattice operand set. It reads the first operand pair from a line with alternatives. It does not enumerate every combination of alternatives.','',
'`src/dagx.cpp` is a local copy of the conservative open-requirement-bound router from w2. It searches conditional moves, copies, register reuse, and output snapshots. `src/pool_sat.py` is a local finite-pool SAT router from w2. Its negative results apply only to its value pool and at most two copies per value.','',
'All searches use `nice -n 10`. At most eight CPU jobs run at once. Each routing subprocess has a 3 GiB address-space limit. No search writes outside this worker folder.','',
'## Result','',
'Generation logs:','']
for f in ['partner_generation.log','switch2_generation.log','switch3_generation.log','switch4_generation.log','switch5_generation.log','switch6_generation.log','two_switch_generation.log','mutation_generation.log','nonlattice_filter.log']:
    p=Path('logs')/f
    if p.exists():
        text=p.read_text().strip()
        lines.append('- `'+str(p)+'`: '+(text.splitlines()[-1] if text else 'in progress'))
lines+=['','Routing results:','','| Batch | Cases | Results | Recursive calls |','| --- | ---: | --- | ---: |']
for r in rows:lines.append('| '+r['batch']+' | '+str(r['cases'])+' | '+', '.join(k+' '+str(v) for k,v in sorted(r['counts'].items()))+' | '+f"{r['calls']:,}"+' |')
lines+=['','Each `logs/<batch>/results.jsonl` file records the source path, status, and call count. Repeated search passes are included in the call totals. The batches can overlap. The final audit uses canonical skeleton keys when it reports distinct cases.','',
'The fixed-prefix finite-pool SAT control returned SAT and passed both strict judges. The first k=31 finite-pool target returned UNSAT after 5,555 conflicts. Its pool contains 23 columns. Its free-copy gate lower bound is 18. This is a finite-pool result.','',
'Every strict PASS file:','','| File | Judge log |','| --- | --- |']
if satrows:
    lines[-4:-4]=['Finite-pool SAT batches:','']+[('- '+r['batch']+': '+str(r['cases'])+' cases; '+', '.join(k+' '+str(v) for k,v in sorted(r['counts'].items()))) for r in satrows]+['']
for r in passes:lines.append('| `'+r['program']+'` | `'+r['log']+'` |')
lines+=['','All listed PASS files are controls at core k=32 or memory length 42. They do not improve AlphaDev\'s length. Exact judge lines are in `logs/summary.json`.','',
'## Limits','',
'The generators cover one conditional partner swap and the stated functional mutations. They do not cover all non-lattice programs. All routing tables use strict input orders. Any decoded candidate must also pass the strict judge on all 541 weak orders and arbitrary scratch values and flags. A completed NONE result is a routing-search result for the stated skeleton representation. It is not a general sort5 lower bound.','',
'Two broad prior-corpus filters were cancelled and replaced by the non-lattice filter. Their logs end with CANCELLED. They supply no negative result. A source trace that sorts the 120 strict orders is not a verified program.','',
'## Conclusion','',
'No target improvement was verified. Retain the limited cases as open searches. The controls passed both models, and the report separates completed routing searches from limits.','']
extra=['Additional generation and routing details:','',
'- The five conditional-swap generators retain 707, 1,489, 2,340, 2,856, and 2,062 skeletons for switch positions 2 through 6. The 513 pair-carry skeletons are included in the comparison-3 family. The combined one-swap set has 9,459 distinct non-lattice skeletons after seven lattice mutation cases are removed.','- The two-swap generator tests 170,172 mutations of 9,454 source skeletons. It finds 34,442 traces that sort all strict orders. Input renaming and comparison reversal reduce them to 25,485 skeletons. The low-column selection has 651 cases. Removing 90 one-swap cases leaves 561 cases.','- The first functional mutation pass tests 15,705 mutations. It retains 12 skeletons relative to the control. Five contain non-lattice operands. The second pass tests 188,460 mutations of those twelve graphs. It produces 170 records. Removing 39 first-pass cases and 43 duplicate records leaves 88 skeletons. Of those, 69 contain non-lattice operands.','- Copy placement for the 84 first-pass graphs that sort strict orders tests both the original graph and a graph with equal value columns merged. The 168 layouts have costs 32 or 33. This merging uses the strict-order tables; it does not establish tie correctness. One cost-32 control passed both strict judges.','- `logs/canonical_check.log` records agreement between the faster canonical form and the full 120-renaming reference on 240 seeded cases. This is a check of the implementation, not a proof.','- `src/audit.py` merges routing statuses by canonical skeleton. A completed NONE takes precedence over an earlier limit. Finite-pool SAT results do not close an unrestricted routing case. `sk/open_cases.json` records the remaining cases.','']
fixed=collections.Counter()
for f in Path('logs').glob('mut2_*_fixed.json'):
    fixed.update({int(k):v for k,v in json.loads(f.read_text())['histogram'].items()})
if fixed:extra+=['Second-pass fixed-graph layouts: '+', '.join('k='+str(k)+': '+str(v) for k,v in sorted(fixed.items()))+'.','']
audit=Path('logs/audit.json')
if audit.exists():
    d=json.loads(audit.read_text());extra+=['Current canonical audit: '+str(d['canonical_skeletons'])+' skeletons; '+', '.join(k+' '+str(v) for k,v in sorted(d['verdicts'].items()))+'. The recorded routing call count is '+f"{d['recorded_calls']:,}"+'. A killed process can have unreported calls.','']
    if d['prior_cache_available']:extra+=['The prior-corpus cache has '+str(d['prior_canonical_keys'])+' canonical keys. It matches '+str(d['prior_matches'])+' selected skeletons. `logs/audit.json` lists every match. The other selected skeletons are new relative to that cached corpus and its first-alternative parsing rule.','']
at=lines.index('## Limits');lines[at:at]=extra
if target_passes:
    lines=[l.replace('No target improvement was verified.','A target program passed the strict judge.').replace("All listed PASS files are controls at core k=32 or memory length 42. They do not improve AlphaDev's length.","The PASS table includes the verified target program and the controls.") for l in lines]
Path('RESULTS.md').write_text('\n'.join(lines))
print(json.dumps(dict(batches=[{k:v for k,v in r.items() if k!='records'} for r in rows],strict_passes=len(passes)),indent=2))
