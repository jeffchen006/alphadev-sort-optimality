"""Save exact run counts and append the round-2 result without changing round 1."""
import json
from pathlib import Path
import re

HERE=Path(__file__).resolve().parent
summary={}
def totals(rows,pattern):
    out={}
    for row in rows:
        if row['code']!=0:raise RuntimeError(row)
        mode=pattern(row['name'])
        numbers=dict((key,int(value)) for key,value in re.findall(r'(trials|filterpasses|filters|fullchecks|full)=(\d+)',row['tail'][0]))
        group=out.setdefault(mode,{'runs':0,'trials':0,'filters':0,'full':0,'seconds':0.0})
        group['runs']+=1
        group['trials']+=numbers['trials']
        group['filters']+=numbers.get('filterpasses',numbers.get('filters',0))
        group['full']+=numbers.get('fullchecks',numbers.get('full',0))
        group['seconds']+=row['seconds']
    return out
summary['base']=totals(json.loads((HERE/'batch_results.json').read_text()),lambda n:n.split('_',1)[1])
summary['flags']=totals(json.loads((HERE/'flag_results_cmp_cmov_other.json').read_text()),lambda n:n.rsplit('_',1)[1])
summary['alias']={'runs':0,'trials':0}
for path in sorted((HERE/'logs').glob('[0-9][0-9]_alias.log')):
    m=re.search(r'^WALK_DONE .*aliastrials=(\d+)',path.read_text(),re.M)
    if not m:raise RuntimeError(path)
    summary['alias']['runs']+=1;summary['alias']['trials']+=int(m[1])
summary['walks']=[]
for path in sorted((HERE/'logs').glob('walk_[0-9][0-9].log')):
    data=path.read_text();m=re.search(r'^WALK_DONE (.*)$',data,re.M)
    if not m:raise RuntimeError(path)
    row={'name':path.stem}
    for key,value in re.findall(r'(\w+)=([\d.]+)',m[1]):row[key]=float(value) if '.' in value else int(value)
    row['comparison_histogram']=re.search(r'^CMP_HIST(.*)$',data,re.M)[1].strip()
    summary['walks'].append(row)
ledger=[json.loads(line) for line in (HERE/'verify_ledger.jsonl').read_text().splitlines()]
summary['passes']={row['file']:row for row in ledger}
if (HERE/'comparison_structures.json').exists():
    semantic=json.loads((HERE/'comparison_structures.json').read_text())
    summary['comparison_structures']={k:v for k,v in semantic.items() if k!='rows'}
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')

parts=['\n\n## Round 2: eight-comparison repairs\n',
       '\nNo program with k<=31 received a strict judge PASS in this round.\n',
       '\n### Method\n',
       '\nRead the round-1 result first. Used the 18 immutable w6 representatives and '
       '`verified/palette_c8_k32.s`. The source list is `round2/manifest.json`. '
       'The search did not rerun network enumeration, dagx, lattice search, or the earlier solver exclusions.\n',
       '\nAll round-2 search, compilation, and judge commands used `nice -n 19`. '
       'At most two CPU jobs ran at one time. The inherited CPU affinity was 76-77. '
       'All new files are under this worker folder.\n',
       '\nThe independent simulator from round 1 supplied the filter and full checks. '
       'The filter uses 16 concrete cases. The full check uses all 541 weak orders and conservative unknown values. '
       'The search can choose output snapshots again after each edit. '
       'Each register alphabet includes all seed registers and one fresh register. Self operands are included.\n',
       '\n### CMOV value reuse\n',
       '\nThe 19 seeds contain 382 conditional moves. None is a no-op on all weak orders. '
       'Two conditional-move results already exist in another register. '
       'With zero-based core numbering, they are instruction 8 of `../w6/verified/c8_26e49cf60c846007.s` '
       'and instruction 5 of `../w6/verified/c8_b71830c38f98f13.s`. '
       'Both results equal their source register. The audit is `round2/cmov_audit.json`.\n',
       '\nThe register reuse scan deletes one non-comparison instruction. It then redirects or exchanges '
       'the deleted destination with each other register from the deletion point to each later instruction boundary. '
       'A third form redirects explicit reads only. '
       f'This scan tested {summary["alias"]["trials"]:,} candidates over {summary["alias"]["runs"]} seeds. '
       'It found no shorter core.\n',
       '\n### Bounded repairs\n',
       '\nEach row below completed on all 19 seeds. Counts are candidate tests. '
       'The counts include duplicates across repair neighborhoods.\n',
       '\n| Repair neighborhood | Candidate tests | Filter survivors |\n|---|---:|---:|\n']
labels={'repair':'Delete one; then delete two and insert one at every gap',
        'repair3':'Delete CMOV; change one CMP and one surviving CMOV',
        'cmov3':'Delete CMOV; change two surviving CMOVs'}
for key,row in summary['base'].items():parts.append(f'| {labels[key]} | {row["trials"]:,} | {row["filters"]:,} |\n')
labels={'other':'Remaining deletion plus two class-preserving substitutions',
        'cmp':'Delete CMP; reselect following predicates; optional one class-preserving substitution outside that block',
        'cmov':'Delete CMOV; replace one CMP; reselect every predicate before the next CMP'}
for key,row in summary['flags'].items():parts.append(f'| {labels[key]} | {row["trials"]:,} | {row["filters"]:,} |\n')
parts+=['\nThe remaining-substitution scan covers MOV/MOV, MOV/CMP, MOV/CMOV, and CMP/CMP repairs after CMOV deletion. '
        'After MOV or CMP deletion it covers every pair of the three instruction classes. '
        'A CMOV substitution can select any of the four legal conditions. '
        'The other two classes retain their opcode. '
        'The flag scans can change more than three instruction lines when a block has several conditional moves.\n',
        '\nNo candidate in these scans passed the full simulator. '
        'Logs are `round2/logs/[00-18]_{repair,repair3,cmov3}.log` '
        'and `round2/logs/[00-18]_flag_{other,cmp,cmov}.log`.\n',
        '\n### Correct-program walks\n',
        '\nEvery accepted state passed the independent full check. '
        'Distinct-list counts use 64-bit hashes after scratch-register name normalization. '
        'Each new normalized instruction list received a deletion check. '
        'Every 2,000 new lists received the register reuse scan and one rotating repair scan. '
        'The rotating scans were flag reuse after CMP deletion, flag repair after CMOV deletion, '
        'CMP/CMOV repair, and two-delete/one-insert repair. '
        'Extra moves can change all predicates in a comparison block, move a CMOV across a CMP, '
        'move a CMP, or exchange registers over a bounded interval.\n',
        '\n| Run | Proposals | Accepted transitions | Distinct instruction lists | Repair checkpoints | Candidate tests |\n|---|---:|---:|---:|---:|---:|\n']
for row in summary['walks']:
    parts.append(f'| {row["name"]} | {row["moves"]:,} | {row["accepted"]:,} | {row["unique"]:,} | {row["checkpoints"]:,} | {row["trials"]:,} |\n')
if 'comparison_structures' in summary:
    sem=summary['comparison_structures']
    parts.append(f'\nThe retained-state audit identifies {sem["seed_classes"]} comparison structures in the seed set and '
                 f'{sem["new_walk_classes"]} additional structures in the eight saved walk states over all weak orders. '
                 f'On the 120 distinct-value input orders, {sem["new_walk_classes_distinct"]} saved structures are outside the seed classes. '
                 'This comparison uses all 541 weak orders and identifies input renaming, value-order reversal, '
                 'and reversal of individual comparisons. It covers the saved states only. '
                 'The structure identifiers and file paths are in `round2/comparison_structures.json`.\n')
parts+=['\nThe walks `walk_03` and `walk_15` start from the two seeds with duplicate CMOV results. '
        'The walk `walk_07` starts from the two-MOV representative. The walk `walk_18` starts from the palette route. '
        'The walks found no core with k<=31. Parameters are in `round2/walk_batch.py`. '
        'Detailed counts are in `round2/summary.json`.\n',
        '\n### Strict judge results\n',
        '\nThe predicate enumerator returned a positive control for each seed. '
        'All 19 controls passed both strict judges. The final walk states and their last checkpoints also passed both strict judges. '
        'Every result below has k=32 in the out model or L=42 in the memory model. '
        'The complete judge text is in `round2/logs/judge_<stem>.log` and `round2/verify_ledger.jsonl`.\n',
        '\n| PASS file | Model | Length |\n|---|---|---:|\n']
for file,row in sorted(summary['passes'].items()):
    rel=Path(file).relative_to(HERE.parent);length=re.search(r'\bL=(\d+)',row['output'])[1]
    parts.append(f'| [{rel}]({rel}) | {row["model"]} | {length} |\n')
parts+=['\n### Limits\n',
        '\nThese results concern finite edit alphabets and sampled correct-program walks. '
        'The conservative unknown-value check can reject valid programs that depend on correlations involving scratch values. '
        'No lower bound for arbitrary programs follows. The total-length target of 41 remains open.\n']
with (HERE.parent/'RESULTS.md').open('a') as f:f.write(''.join(parts))
print(json.dumps({key:value for key,value in summary.items() if key!='passes'},indent=2))
