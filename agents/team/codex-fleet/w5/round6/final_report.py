"""Append final statuses only after every planned pair query has a record."""
from pathlib import Path
from collections import Counter
import hashlib,json,subprocess,sys
HERE=Path(__file__).resolve().parent
subprocess.run(['nice','-n','19',sys.executable,'-B',str(HERE/'summarize.py')],check=True,capture_output=True)
s=json.loads((HERE/'summary.json').read_text())
for name in ['collect_orig_a','collect_orig_b','collect_retimed']:
    assert s[name]['done'] and s[name]['unknown']==0
for name in ['near_flags','near_pairs']:assert s[name]['done']
results={}
for seed in ['near9','near14']:
    rows=[]
    for path in HERE.glob(seed+'_slots_*.json'):rows.extend(json.loads(path.read_text()))
    assert len(rows)==465 and {x['index'] for x in rows}==set(range(465)),(seed,len(rows))
    assert all(x['status']in ['UNSAT','UNKNOWN_WALL_LIMIT','CANDIDATE'] for x in rows)
    results[seed]=dict(queries=len(rows),status=dict(Counter(x['status'] for x in rows)),rows=rows)
judges=s['judges'];assert len(judges)>=6 and all(x['passed'] and x['intact'] for x in judges)
for name in ['manifest.json','retimed_manifest.json']:
    for row in json.loads((HERE.parent/'round5'/name).read_text()):
        assert hashlib.sha256(Path(row['source']).read_bytes()).hexdigest()==row['sha256']
s['slot_repairs']=results
focused=json.loads((HERE/'focused_results.json').read_text())
assert len(focused)==4 and all(x['status'] in ['UNSAT','UNKNOWN_WALL_LIMIT','CANDIDATE','SKIPPED_ALREADY_COMPLETE'] for x in focused)
s['focused_repairs']=focused
s['effective_pair_status']={}
for seed,data in results.items():
    status={tuple(x['slots']):x['status'] for x in data['rows']}
    for row in focused:
        if row['seed']==seed and row['status']=='UNSAT':status[tuple(row['slots'])]='UNSAT'
    s['effective_pair_status'][seed]=dict(Counter(status.values()))
symbolic=json.loads((HERE/'symbolic_input_check.json').read_text())
assert len(symbolic)==2 and all(x['executions']==2164 and x['unresolved_scratch_comparisons']==x['garbage_outputs']==0 for x in symbolic)
s['symbolic_input_check']=symbolic
s['full_position_repair']=dict(seed='near9',status='UNKNOWN_WALL_LIMIT',seconds=180,exit_code=124,log=str(HERE/'logs/near9_predicates_sat.log'))
s['all_jobs_finished']=True
(HERE/'final_summary.json').write_text(json.dumps(s,indent=2)+'\n')
lines=['','','### Round-6 final SAT result','',
'All 930 fixed-pair queries have finished or reached their wall limit. The table counts individual queries. Each UNSAT entry excludes only its stated position pair, free-predicate rules, finite register alphabet, and encoded weak orders. UNKNOWN entries give no exclusion.','',
'| Input | Position-pair queries | UNSAT | UNKNOWN wall limit | Proposals |',
'|---|---:|---:|---:|---:|']
for seed,r in results.items():
    c=r['status'];lines.append(f'| {seed} | {r["queries"]} | {c.get("UNSAT",0)} | {c.get("UNKNOWN_WALL_LIMIT",0)} | {c.get("CANDIDATE",0)} |')
lines+=['',
'The nine-order full-position query also remains UNKNOWN at its 180-second wall limit. No complete exclusion of either expanded repair neighborhood follows. The scratch value is 7 and initial flags are equal in SAT. A successful relaxed proposal still needs both strict judges.','',
'The separate guide-input audit checked 4,328 symbolic executions: both seeds, all 541 weak orders, and all four initial flag states. Distinct scratch symbols caused no unresolved comparisons and reached no output. The observed failure sets still had exactly nine and 14 weak orders. See `round6/symbolic_input_check.json`.','',
'Four selected unresolved position pairs received longer checks with all 541 weak orders and a 60-second wall limit. The individual refinements are listed below. Their counts overlap the short-query table.','',
'| Input | Free positions, zero-based | Refinement result |',
'|---|---|---|']
for row in focused:lines.append(f'| {row["seed"]} | {row["slots"]} | {row["status"]} |')
lines+=['',
'Every new strict PASS file is listed below. The controls have k=32 and memory length 42. The variable two-slot control changes predicates outside the two free slots and passed both strict judges. The reference scorer check covers all 541 weak orders of the known 14-order failure. These checks are test results, not an encoding proof.','',
'| Strict PASS file | Model | Length | Judge log |',
'|---|---|---:|---|']
for row in sorted(judges,key=lambda x:x['file']):
    path=Path(row['file']);rel=path.relative_to(HERE.parent);length=row['k']+(10 if row['model']=='mem' else 0)
    log=Path(row['log']).relative_to(HERE.parent)
    lines.append(f'| [{path.name}]({rel}) | {row["model"]} | {length} | `{log}` |')
lines+=['','### Round-6 limits','',
'The completed terminal scans cover their finite original-value columns and effect-state representatives. The independent scans cover their stated deletions, fusion positions, and register choices. None is a search over arbitrary programs. A completed UNSAT result is a bounded negative. A wall limit is UNKNOWN. No global lower bound follows.','',
'### Round-6 conclusion','']
short=[x for x in judges if x['k']<=31]
if short:
    lines.append('A strict PASS program meets k<=31. See the FOUND line at the top and the PASS files above.')
else:
    lines.append('No k<=31 program received a strict judge PASS. The target memory length of at most 41 remains open. All round-6 jobs have finished.')
lines+=['','The final commands, status counts, source integrity checks, strict PASS hashes, and logs are in `round6/final_summary.json`.','']
path=HERE.parent/'RESULTS.md';txt=path.read_text();assert '### Round-6 final SAT result'not in txt
path.write_text(txt+'\n'.join(lines))
print(json.dumps(dict(all_jobs_finished=True,counts={k:v['status']for k,v in results.items()},strict_pass_files=len(judges),shorter_passes=len(short))))
