#!/usr/bin/env python3
"""Write the final concise report after the routing and audit jobs finish."""
from pathlib import Path
import json,collections,re,hashlib
audit=json.loads(Path('logs/audit.json').read_text())
passes=[]
for p in sorted(Path('logs').glob('*.judge.log')):
    for line in p.read_text().splitlines():
        if line.startswith('PASS '):
            file=line.split()[1];n=int(re.search(r' L=(\d+)',line)[1]);model=re.search(r'model=(\w+)',line)[1]
            passes.append(dict(file=file,length=n,model=model,log=str(p),line=line,sha256=hashlib.sha256(Path(file).read_bytes()).hexdigest()))
Path('logs/judge_registry.json').write_text(json.dumps(passes,indent=2)+'\n')
found=[r for r in passes if r['length']<=(31 if r['model']=='out' else 41)]
intro=['FOUND '+r['file']+' '+r['line'] for r in found] if found else ['No program with core k <= 31 passed the strict judge.']
lines=intro+['',
'## Purpose','',
'Search sort5 programs with nine comparisons and at most 31 core instructions. Use partner values and value sets outside sorting networks.','',
'## Terms','',
'- Core k counts register moves, comparisons, and conditional moves. The memory length is k + 10.','- A value column lists one register value on each of the 120 strict input orders.','- A skeleton fixes the comparison operand columns. A non-lattice column has no min/max term representation on these orders.','- NONE means the routing search completed in its stated representation. LIMIT and TIMEOUT leave the case open.','- A SAT solver searches Boolean assignments. UNSAT concerns the stated encoding. It is not a general sort5 lower bound.','- PASS means the reference judge accepted the file with --strict.','',
'## Method','',
'`src/switch_prefix.cpp` enumerates nine-comparison sequences. One comparison conditionally swaps two disjoint pairs. One pair supplies the comparison operands. The other pair carries partner values. The switch occurs at comparison 2, 3, 4, 5, or 6. Ordinary compare-exchange steps complete the sequence.','',
'`src/two_switch.cpp` adds another partner swap to each one-swap sequence. It retains traces that send all 120 strict orders to one fixed permutation. These traces are skeleton sources. They are not strict-judge candidates.','',
'`src/mutation.cpp` changes one operation in the supplied k=32 functional graph. Each conditional move creates a new value node in this graph. The generator requires comparison histories that distinguish all 120 strict orders. `src/second_mutation.py` repeats the pass on twelve retained graphs.','',
'The canonical form removes input renaming and independent comparison reversal. It does not remove all possible program symmetries. `src/check_canonical.cpp` matched a full 120-renaming reference on 240 seeded cases. This check is not a proof.','',
'`src/dagx.cpp` is the w2 router with its conservative open-requirement bound. It searches moves, conditional moves, register reuse, and output times. `src/route_batch.py` records node and time limits.','',
'`src/pool_sat.py` is the w2 finite-pool router. It permits at most two copies of each permitted column. Its UNSAT results do not close the unrestricted routing cases. Every decoded candidate must pass the strict judge.','',
'Search jobs used nice -n 10. At most eight CPU search jobs ran together. Routing and SAT subprocesses had a 3 GiB address-space limit. See `RUNS.md` for commands.','',
'## Result','',
'Generation counts:','',
'| Family | Retained skeletons |','| --- | ---: |',
'| Partner swap at comparison 2 | 707 |','| Partner swap at comparison 3 | 1,489 |','| Partner swap at comparison 4 | 2,340 |','| Partner swap at comparison 5 | 2,856 |','| Partner swap at comparison 6 | 2,062 |',
'| Two partner swaps | 25,485 |','',
'The separate pair-carry generator retained 513 cases. All 513 occur in the comparison-3 family. The one-swap union has 9,454 cases. Adding five non-lattice functional mutations gives the 9,459-case broad search set.','',
'The two-swap generator tested 170,172 mutations. It found 34,442 traces that sort strict orders. Canonicalization retained 25,485 skeletons. Of these, 651 require at most 17 non-input columns. Removing 90 one-swap cases left 561 priority cases. The other two-swap cases did not receive routing searches.','',
'The first functional pass tested 15,705 mutations. It retained twelve skeletons relative to the control. Five have non-lattice operands. The second pass tested 188,460 mutations. It produced 170 records. Removing 39 first-pass cases and 43 duplicates left 88 skeletons. Sixty-nine have non-lattice operands.','',
'The fixed-graph copy search tested 168 first-pass layouts. Their lengths were k=32 or k=33. It tested two layouts per strict-order sorting graph. One layout merges equal columns. Output nodes remain fixed in each tested layout. This is not a minimum over every possible output choice.','']
fixed=collections.Counter()
for p in Path('logs').glob('mut2_*_fixed.json'):fixed.update({int(k):v for k,v in json.loads(p.read_text())['histogram'].items()})
lines+=['Second-pass fixed-graph layouts: '+', '.join('k='+str(k)+': '+str(v) for k,v in sorted(fixed.items()))+'. No tested layout had k <= 31.','',
'Routing batches:','','| Batch | Cases | Results | Recorded calls |','| --- | ---: | --- | ---: |']
for p in sorted(Path('logs').glob('*/results.jsonl')):
    rows=[json.loads(l) for l in p.read_text().splitlines()];last={r['file']:r for r in rows};h=collections.Counter(r['status'] for r in last.values())
    lines.append('| '+p.parent.name+' | '+str(len(last))+' | '+', '.join(k+' '+str(v) for k,v in sorted(h.items()))+' | '+f"{sum(r.get('calls',0) for r in rows):,}"+' |')
lines+=['','The batches overlap. A later NONE closes an earlier limited search for the same skeleton. Interrupted processes can have unreported calls. The table does not count those calls.','',
'Finite-pool SAT batches:','','| Batch | Cases | Results |','| --- | ---: | --- |']
for p in sorted(Path('logs').glob('*/sat_results.jsonl')):
    rows=[json.loads(l) for l in p.read_text().splitlines()];h=collections.Counter(r['status'] for r in rows)
    lines.append('| '+p.parent.name+' | '+str(len(rows))+' | '+', '.join(k+' '+str(v) for k,v in sorted(h.items()))+' |')
lines+=['','The first finite-pool k=31 target also returned UNSAT. Its log is `logs/priority17_sat.log`. Its pool has 23 columns. The free-copy gate lower bound is 18.','',
'Final canonical audit:','',
'- Selected source records: '+f"{audit['source_records']:,}"+'.','- Distinct selected skeletons: '+f"{audit['canonical_skeletons']:,}"+'.',
'- New skeletons relative to the cached corpus: '+f"{audit['new_skeletons']:,}"+'.','- New-case routing status: '+', '.join(k+' '+str(v) for k,v in sorted(audit['new_verdicts'].items()))+'.',
'- Routing status: '+', '.join(k+' '+str(v) for k,v in sorted(audit['verdicts'].items()))+'.',
'- Recorded routing calls: '+f"{audit['recorded_calls']:,}"+'.',
'- Prior canonical keys: '+str(audit['prior_canonical_keys'])+'. Selected skeletons that match the cache: '+str(audit['prior_matches'])+'.','',
'`logs/audit.json` contains the final counts and prior matches. `sk/open_cases.json` contains unresolved new skeletons and their recorded statuses. Prior matches are listed separately. Eighteen matched cases were excluded before deeper routing. Two first-pass mutation skeletons had already received bounded routing rechecks. The SAT batches include all twenty prior-matching mutation cases as rechecks.','',
'The prior check reads nine-comparison .txt files from d1 and w2. It includes linked files. It reads the first pair on a line with alternatives. It does not enumerate all alternative combinations.','',
'Every strict PASS file:','','| File | Model | Length | Judge log |','| --- | --- | ---: | --- |']
for r in passes:lines.append('| `'+r['file']+'` | '+r['model']+' | '+str(r['length'])+' | `'+r['log']+'` |')
lines+=['','These PASS files are controls. They match k=32 or memory length 42. They do not improve AlphaDev\'s length. `logs/judge_registry.json` stores exact PASS lines and file hashes.','',
'Dead ends:','',
'- Early broad corpus scans were cancelled. The later filter replaces them. Cancelled scans give no negative result.','- Single-operation and two-operation functional mutations gave no tested fixed-graph layout below k=32.','- Finite-pool SAT checks found no target candidate. Their negative scope remains the permitted pool and copy limit.','- Some routing cases reached node or time limits. They remain open.','',
'## Limits','',
'The generators cover the stated partner-swap sequences and functional mutations. They do not cover every nine-comparison program. Sorting the 120 strict orders does not establish correctness on ties or arbitrary scratch state.','',
'The router starts from the five input columns. It creates fully defined conditional-move values. It does not search programs that keep scratch registers only partly initialized.','',
'Only a strict-judge PASS establishes candidate correctness here. The judge checks all 541 weak orders and arbitrary scratch values and flags. A completed routing result concerns its fixed skeleton representation. It is not a general sort5 lower bound.','',
'## Conclusion','',
'No target improvement was verified. The shortest verified register controls have k=32. Their memory versions have length 42. The unresolved cases remain available for later searches.','']
if found:
    lines=[l.replace('No target improvement was verified.','A target program passed the strict judge.') for l in lines]
Path('RESULTS.md').write_text('\n'.join(lines));print('WROTE RESULTS.md; strict PASS files',len(passes),'targets',len(found))
