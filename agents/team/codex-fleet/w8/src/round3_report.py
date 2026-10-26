"""Append exact round-three counts. LIMIT, ERROR, and unprocessed cases stay open."""
import collections,datetime,hashlib,json,re
from pathlib import Path

initial=json.loads(Path('sk/round2_all_open_cases.json').read_text())
initial_files={r['file'] for r in initial};assert len(initial_files)==3478
results={};closes=set();passes=[];allrows=[]
for file in sorted(Path('logs').glob('round3*/results.jsonl')):
    rows=[json.loads(l) for l in file.read_text().splitlines()]
    allrows+=rows
    for r in rows:
        cost=r.get('K',r.get('cost'))
        if cost==31 and r['status']=='NONE' and r['file'] in initial_files:
            assert r['returncode']==0
            closes.add(r['file'])
        if r.get('verified'):
            prog=Path(r['program'])
            for path,model in ((prog,'out'),(prog.with_name(prog.stem+'_mem.s'),'mem')):
                judge=Path('logs',path.stem+'.judge.log')
                exact=[l for l in judge.read_text().splitlines() if l.startswith('PASS ')]
                assert len(exact)==1,(str(judge),exact)
                passes.append(dict(file=str(path),model=model,judge=str(judge),line=exact[0],sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
    results[file.parent.name]=dict(cases=len(rows),status=dict(collections.Counter(r['status'] for r in rows)),states=sum(r.get('calls',0) for r in rows),cpu=sum(r.get('cpu',0) for r in rows),seconds=sum(r.get('seconds',0) for r in rows))
openrows=[r for r in initial if r['file'] not in closes]
statusmap=collections.defaultdict(set)
for r in allrows:
    if r.get('K',r.get('cost'))==31:statusmap[r['file']].add(r['status'])
previous={}
for tag in ('round2_rerun','round2_net41'):
    for line in Path('logs',tag,'results.jsonl').read_text().splitlines():
        row=json.loads(line);previous[row['file']]=row
for r in openrows:
    r['round3_statuses']=sorted(statusmap[r['file']])
    older=previous[r['file']]
    r['required_gates']=older['required_gates']
    limits_by_mode={0:older['node_limit']}
    attempts=[x for x in allrows if x['file']==r['file'] and x.get('K',x.get('cost'))==31]
    for x in attempts:limits_by_mode[x['mode']]=max(limits_by_mode.get(x['mode'],0),x['node_limit'])
    r['largest_node_limit_by_mode']=limits_by_mode
    r['recorded_states_round3']=sum(x.get('calls',0) for x in attempts)
prior_audit=json.loads(Path('logs/round2_audit.json').read_text())
combined=dict(prior_audit['verdicts']);combined['NONE']+=len(closes);combined['UNRESOLVED']-=len(closes)
assert sum(combined.values())==prior_audit['canonical_skeletons']
report=dict(remaining_by_required_columns=dict(collections.Counter(r['required_gates'] for r in openrows)),remaining_by_family=dict(collections.Counter(r['file'].split('/')[1] for r in openrows)),recorded_states=sum(r.get('calls',0) for r in allrows),combined_canonical_verdicts=combined,timestamp=datetime.datetime.now(datetime.timezone.utc).isoformat(),assumptions=['A4','A8'],initial_unknown=3478,new_NONE=len(closes),remaining_unknown=len(openrows),closed_files=sorted(closes),batches=results,passes=passes)
Path('logs/round3_audit.json').write_text(json.dumps(report,indent=2)+'\n')
Path('sk/round3_all_open_cases.json').write_text(json.dumps(openrows,indent=2)+'\n')
Path('logs/round3_judge_registry.json').write_text(json.dumps(passes,indent=2)+'\n')
lines=['\n## Round 3: changed search order (supervisor 04:30)', '',f"Report time: {report['timestamp']}.",'','Assumptions tested: [A4, A8]. No assumption contradiction was established.','',
'The round used the permitted search-order alternative. Prior logs had no full-tree size estimate. This report does not infer a full-tree ratio from a limited prefix.', '',
'`src/dagx_order.cpp` adds independent search-order controls. Mode bit 1 resolves the conditional-move operand with more constrained strict orders first. Mode bit 2 visits earlier comparison blocks first. Mode bit 4 reverses the order of the initial comparison-operand requirements. Mode bit 8 resolves output requirements in median-first order. All gate choices remain available. The bound formulas are unchanged. The controls change only the search order. Mode 0 retains the previous traversal.', '',
'All searches ran one process at a time, with nice -n 19 and a 3 GiB address-space limit. The node limit controls each search. There was no wall-time cutoff. State counts include recursive calls pruned at entry and the small limit overrun during return.', '',
'| Batch | Search cases | Status counts | Recorded states | CPU seconds |',
'| --- | ---: | --- | ---: | ---: |']
for tag,x in results.items():lines.append(f"| {tag} | {x['cases']} | {', '.join(f'{k} {v}' for k,v in sorted(x['status'].items()))} | {x['states']:,} | {x['cpu']:.3f} |")
# Report complete-tree comparisons only for the pre-existing negative controls.
lines += ['', 'Ordering checks:', '']
for tag in ('round3_bench','round3_bench2'):
    path=Path('logs',tag,'results.jsonl')
    if not path.exists():continue
    rows=[json.loads(l) for l in path.read_text().splitlines()]
    baseline=[r for r in rows if r['mode']==0 and r['expected']=='NONE']
    assert all(r['status']=='NONE' and r['calls']==r['old_calls'] for r in baseline)
    lines.append(f"- `{tag}`: mode 0 matched the earlier NONE result and exact state count on {len(baseline)} completed negative cases.")
    for mode in sorted({r['mode'] for r in rows} - {0}):
        sample=[r for r in rows if r['mode']==mode and r['expected']=='NONE']
        assert all(r['status']=='NONE' for r in sample)
        new=sum(r['calls'] for r in sample);old=sum(r['old_calls'] for r in sample)
        lines.append(f"- `{tag}`, mode {mode}: the same {len(sample)} negative cases completed. Full-tree states were {new:,}, compared with {old:,} before reordering (ratio {new/old:.6f}).")
lines += ['', 'These completed-case checks support the implementation. They do not prove it correct. Ratios above concern completed negative controls only. A bounded prefix does not estimate a full search-tree size.', '']
if 'round3_order200' in results:
    queue=json.loads(Path('sk/round3_order200.json').read_text());rows=[r for r in allrows if r.get('file') in {q['file'] for q in queue} and r.get('mode')==json.loads(Path('logs/round3_order200/summary.json').read_text())['mode'] and r.get('cost')==31]
    lines+=['','The frozen 200-case queue is `sk/round3_order200.json`. It includes all 167 initial unknown cases that require 15 or 16 non-input columns. Its other 33 cases sample the comparison-3, comparison-4, comparison-5, and comparison-6 partner-swap families. Cases closed by the ordering benchmark were excluded before queue selection. Each case has a 2,000,000-node limit under the selected new order. This is a changed-order rerun, not a claim that every case received 100 times its prior node limit.','', '| Required columns | Cases | Status counts | Recorded states |','| --- | ---: | --- | ---: |']
    for g in sorted({q['required_gates'] for q in queue}):
        rr=[r for r in rows if r['required_gates']==g];ss=collections.Counter(r['status'] for r in rr)
        lines.append(f"| {g} | {len(rr)} | {', '.join(f'{k} {v}' for k,v in sorted(ss.items()))} | {sum(r['calls'] for r in rr):,} |")
    net41=[r for r in rows if r['source_family'].startswith('net9_41_')]
    lines += ['', f"All {len(net41)} net9_41 cases were rerun under mode 13. Their statuses are {dict(collections.Counter(r['status'] for r in net41))}."]
if 'round3_deep200' in results:
    queue=json.loads(Path('sk/round3_deep200.json').read_text())
    assert all(q['node_limit']==100*q['original_node_limit']==10*q['previous_node_limit'] for q in queue)
    lines += ['', f"The 200-case additional queue has prior copy-bound visit ratios from {queue[0]['prior_copy_bound_visit_ratio']:.9f} to {queue[-1]['prior_copy_bound_visit_ratio']:.9f}.", '', 'Additional 100-fold original-limit queue: `sk/round3_deep200.json` contains 200 other unresolved cases. The queue excludes all 200 cases in the main changed-order queue. It ranks cases by the ratio of visits to the exact copy bound to recursive calls in the previous limited run. This ratio is a recorded prefix statistic, not a full-tree size estimate. Each selected case received 2,000,000 states: 100 times its original 20,000-state limit and ten times its round-two 200,000-state limit. Mode 13 supplied the changed order.']
for tag in ('round3_order200','round3_deep200'):
    path=Path('logs',tag,'results.jsonl')
    if not path.exists():continue
    rows=[json.loads(l) for l in path.read_text().splitlines()]
    negative=[r for r in rows if r['status']=='NONE']
    faster=sum(r['calls']<=r['previous_node_limit'] for r in negative)
    lines += ['', f"`{tag}` closed {faster} cases within their previous node limits under the new order. There were {len(negative)} completed negative cases in this batch."]
dedicated=[]
for tag in ('round3_order200','round3_deep200'):
    path=Path('logs',tag,'results.jsonl')
    if path.exists():dedicated.extend(json.loads(l) for l in path.read_text().splitlines())
counts=collections.Counter(r['status'] for r in dedicated)
lines += ['', f"The two dedicated queues searched {len(dedicated)} distinct cases: NONE {counts['NONE']}, LIMIT {counts['LIMIT']}. They recorded {sum(r['calls'] for r in dedicated):,} states. Including the ordering checks, this round recorded {report['recorded_states']:,} states.", '', f"Remaining new unknown cases by required non-input columns: {', '.join(str(g)+': '+str(n) for g,n in sorted(report['remaining_by_required_columns'].items()))}. The unresolved list records the largest node limit tested under each search order."]
lines+=['',f"Relative to the initial 3,478 new unknown skeletons, this round closed {len(closes)} with NONE. The remaining {len(openrows)} are unknown. `logs/round3_audit.json` lists each newly closed file. `sk/round3_all_open_cases.json` preserves every remaining unknown case. The two separately recorded prior-cache matches remain outside this list.",'',
'NONE concerns only the fixed skeleton and the router representation. The router permits non-lattice intermediate columns and unbounded register names. It starts from fully initialized inputs. Its negative search is on 120 strict input orders. It does not close the general nine-comparison search or the garbage-partial-register gap. LIMIT remains unknown.', '', 'New strict control PASS files:','', '| File | Model | Exact judge log |','| --- | --- | --- |']
for p in passes:lines.append(f"| `{p['file']}` | {p['model']} | `{p['judge']}` |")
lines+=['','Exact judge output:','','```text',*[p['line'] for p in passes],'```','',
'The verified controls have k=32 in the out model and length 42 in the memory model. No target improvement was verified.' if not any(r.get('verified') and r.get('actual_cost',32)<=31 for r in allrows) else 'A target candidate passed the strict judge; see the FOUND line at the top of this file.','']
text='\n'.join(lines);dst=Path('RESULTS.md');old=dst.read_text();marker='\n## Round 3: changed search order (supervisor 04:30)'
if marker in old:old=old[:old.index(marker)]
dst.write_text(old+text)
print(json.dumps({k:v for k,v in report.items() if k not in ('closed_files','passes')},indent=2))
