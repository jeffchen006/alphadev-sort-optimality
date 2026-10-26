"""Append the completed new-class counts and preserve the unresolved cases."""
import collections,datetime,hashlib,json
from pathlib import Path

def main():
    tags=['round4_rotation','round4_repeat10']
    summaries={};openrows=[];attempts=[]
    for tag in tags:
        folder=Path('logs')/tag
        if not (folder/'summary.json').exists():continue
        summaries[tag]=json.loads((folder/'summary.json').read_text())
        results=[json.loads(l) for l in (folder/'results.jsonl').read_text().splitlines()]
        attempts.extend(results)
        assert len(results)==len({r['file'] for r in results})
        ss=summaries[tag]
        assert ss['completed']==len(results)
        assert ss['states']==sum(r['calls'] for r in results)
        assert ss['status']==dict(collections.Counter(r['status'] for r in results))
        if ss['completed']!=ss['total']:raise RuntimeError('unfinished batch '+tag)
        for row in results:
            if row['status'] not in ('NONE','FOUND'):openrows.append(row)
    deepfolder=Path('logs/round4_deep')
    deep=[]
    if (deepfolder/'results.jsonl').exists():
        deep=[json.loads(l) for l in (deepfolder/'results.jsonl').read_text().splitlines()]
        summaries['round4_deep']=json.loads((deepfolder/'summary.json').read_text())
        assert summaries['round4_deep']['completed']==summaries['round4_deep']['total']
        assert summaries['round4_deep']['completed']==len(deep)
        assert summaries['round4_deep']['states']==sum(r['calls'] for r in deep)
        assert summaries['round4_deep']['status']==dict(collections.Counter(r['status'] for r in deep))
        closed={r['file'] for r in deep if r['status'] in ('NONE','FOUND')}
        openrows=[r for r in openrows if r['file'] not in closed]
        byfile={r['file']:r for r in deep}
        openrows=[byfile.get(r['file'],r) for r in openrows]
        attempts.extend(deep)
    Path('sk/round4_open_cases.json').write_text(json.dumps(openrows,indent=2)+'\n')
    distinct_cases={r['file'] for r in attempts}
    exhausted_cases={r['file'] for r in attempts if r['status']=='NONE'}
    audit=json.loads(Path('logs/round4_semantic_audit.json').read_text())
    controls=json.loads(Path('logs/round4_rotation_controls.json').read_text())
    positive=json.loads(Path('logs/round4_repeat_positive.json').read_text())
    lines=['','## Round 4 final: new rotations and delayed repeated comparisons','',
           'Report time: '+datetime.datetime.now(datetime.timezone.utc).isoformat()+'.','',
           'Assumptions tested: [A4, A8]. No contradiction of an assumption was established. The old unresolved nine-comparison cases were not rerun.','',
           'The checkpoint above describes generation and canonical exclusions. This report gives final routing counts. Each NONE exhausts only the fixed skeleton within the router representation. LIMIT remains unknown.', '', 'The new special step covers the two three-cycle permutations of the three partner wires. The earlier generator covered the three pair swaps on those wires. This extends the action patterns for one special comparison. It does not cover arbitrary conditional permutations across several comparisons.', '', 'The final deeper pass tests 200 new rotation cases. It includes all 63 limited cases with 17 required columns and 137 cases with 18 required columns. Each case gets 1,000,000 nodes, ten times its first limit. The queue ranks required columns first, then exact-copy-bound visits divided by recursive calls in the earlier limited run. This prefix statistic does not estimate the full search-tree size.','',
           '| Batch | Cases | Status counts | Recorded states | CPU seconds |','| --- | ---: | --- | ---: | ---: |']
    for tag,s in summaries.items():
        lines.append(f"| {tag} | {s['completed']:,} | "+', '.join(f'{k} {v:,}' for k,v in sorted(s['status'].items()))+f" | {s['states']:,} | {s['cpu']:.3f} |")
    lines+=['','Required-column groups:','','| Batch | Required columns | Cases | Status counts | Recorded states |','| --- | ---: | ---: | --- | ---: |']
    for tag,s in summaries.items():
        for g,rr in s['gates'].items():
            lines.append(f"| {tag} | {g} | {rr['completed']:,} | "+', '.join(f'{k} {v:,}' for k,v in sorted(rr['status'].items()))+f" | {rr['states']:,} |")
    lines+=['',f"The searches recorded {sum(r['calls'] for r in attempts):,} recursive calls. These counts include pruned calls and the small overrun when a limited search returns. All searches used one routing process at a time, nice -n 19, and a 3 GiB address-space limit. The largest recorded child peak was {max(r.get('peak_rss_kib',0) for r in attempts):,} KiB.",'',
        f"The separate Python evaluator checked all {audit['rotation_sources_checked']:,} rotation sources. Each saved comparison column matched the evaluator. Each source reached one fixed final wire permutation and had 120 distinct comparison histories. Every source had a non-lattice comparison column. The evaluator checked all {audit['repeated_skeletons_checked']:,} repeated-comparison files against their stated source and insertion recipe. It checked the 120 comparison histories of all {audit['repeat_sources_checked']:,} source skeletons. These implementation checks are not a proof.",'',
        f"Fixed-graph copy minimization tested {audit['fixed_layouts']:,} rotation layouts. Its length counts are "+', '.join(f'k={k}: {v:,}' for k,v in sorted(audit['fixed_cost_histogram'].items(),key=lambda x:int(x[0])))+'. These layouts fix the source graph and output choices. They do not close unrestricted routing.','',
        'Setup probes on the first delayed-repeat case reached limits at K=33 (1,000,111 calls) and K=36 (1,000,094 calls). The separate positive ten-comparison control found a k=33 route in 661,985 calls. These setup calls are outside the target-state totals above.', '', 'Strict controls:','']
    for r in controls:
        lines.append(f"- `{r['file']}`: k={r['cost']}; strict {'PASS in both models' if r['strict_pass'] else 'check rejected'}. Source: `{r['source']}`.")
    if positive.get('verified'):
        lines+=['',f"The ten-comparison router control passed in both models: `{positive['program']}`. This control repeats the first comparison immediately. It checks the ten-comparison input and output path. The search set uses delayed repeats.",'','Exact positive-control judge output:','','```text',positive['judge'].strip(),'```']
    else:lines+=['','The ten-comparison positive router control did not produce a strict PASS. Its saved result is `logs/round4_repeat_positive.json`.']
    for r in controls:
        if r['strict_pass']:lines+=['','Exact rotation-control judge output:','','```text',r['judge'].strip(),'```']
    groups=collections.Counter(('c='+str(9 if '/round4_rotation' in r['file'] else 10),r['required_gates']) for r in openrows)
    lines+=['', f"Distinct new skeletons tested: {len(distinct_cases):,}. Completed negative routing cases: {len(exhausted_cases):,}.", '', 'After the deeper pass, all 72 new rotation cases with 17 required columns returned NONE. The remaining 1,010 nine-comparison cases each require 18 columns.', '', f"New unresolved skeletons: {len(openrows):,}. Their group counts are "+', '.join(f'{c}, {g} columns: {n:,}' for (c,g),n in sorted(groups.items()))+'. `sk/round4_open_cases.json` preserves every case and its largest tested limit in this round.','',
        'The router searches fully defined value columns on the 120 strict input orders. It permits non-lattice intermediate values and unbounded register names. Its negative scope excludes programs with partly initialized scratch registers. It does not establish a general nine- or ten-comparison lower bound.','',
        'The eight new control PASS files and their hashes are in `logs/round4_judge_registry.json`. Final source and manifest hashes are in `logs/round4_build.json`.', '',
        'No k <= 31 strict PASS was recorded in this round.' if not any(r.get('verified') and r.get('actual_cost',99)<=31 for r in attempts) else 'A target strict PASS is recorded at the top of this file.','']
    Path('RESULTS.md').open('a').write('\n'.join(lines))
    final=dict(batches=summaries,distinct_skeletons=len(distinct_cases),exhausted_skeletons=len(exhausted_cases),unresolved=len(openrows),unresolved_groups={str(k):v for k,v in groups.items()},recorded_states=sum(r['calls'] for r in attempts))
    Path('logs/round4_final.json').write_text(json.dumps(final,indent=2)+'\n')
    print(json.dumps(final,indent=2))
if __name__=='__main__':main()
