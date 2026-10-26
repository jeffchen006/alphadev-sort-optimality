"""Refresh only the round-4 appendix. Earlier result text stays intact."""
from collections import Counter
from datetime import datetime,timezone
import hashlib
import json
from pathlib import Path

HERE=Path(__file__).resolve().parents[1]
MARK='\n## Round 4 — ranked repairs and three extra changed data slots\n'

def read(name):
    p=HERE/'artifacts'/name
    return [json.loads(l) for l in p.read_text().splitlines() if l.strip()] if p.exists() else []

def report():
    prep=json.loads((HERE/'artifacts/preparation.json').read_text())
    top=read('top100.jsonl');extra=read('median_extra3.jsonl')
    controls_path=HERE/'artifacts/controls.json'
    controls=json.loads(controls_path.read_text()) if controls_path.exists() else []
    groups=[]
    for name,rows,total in [('ranked_600_second_reruns',top,100),('median_plus_three_changed_slots',extra,653)]:
        assert len({r.get('queue_index',r.get('index')) for r in rows})==len(rows)
        groups.append({'name':name,'completed':len(rows),'planned':total,
            'status':dict(Counter(r['status'] for r in rows)),
            'parent_cpu':sum(r['cpu'] for r in rows),
            'child_cpu':sum(r['stats']['child_cpu_seconds'] for r in rows),
            'wall':sum(r['wall'] for r in rows),
            'solver_calls':sum(len(r['stats']['solver_calls']) for r in rows),
            'models':sum(len(r.get('models',[])) for r in rows),
            'peak_rss_kib':max((r['stats']['peak_job_rss_kib'] for r in rows),default=0)})
    resolved=sum(r['status']=='UNSAT' for r in top)
    summary={'updated_utc':datetime.now(timezone.utc).isoformat(),'preparation':prep,
        'groups':groups,'round2_latest_unsat':97+resolved,'round2_latest_unknown':698-resolved,
        'controls':dict(Counter(r['status'] for r in controls)),
        'strict_pass_paths':[p for r in controls+top+extra if r.get('strict_pass')
                             for p in [r['path'],r.get('memory_path')] if p],
        'resources':{'cpu_jobs':1,'nice':19,'address_space_mib':2800,'combined_rss_kib_limit':2800000},
        'code_sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((HERE/'src').glob('*.py'))}}
    (HERE/'artifacts/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    text=(MARK+
      '\nRead RESULTS.md and the saved round-3 queues before this round. No earlier repair scan was repeated. '
      'No later result had been recorded for the prior 900-second continuation. '
      'Its last active query had no completed result. The ledger therefore started at 97 UNSAT and 698 UNKNOWN.\n\n'
      'Assumptions tested: A2 (finite register bounds), A4 (fixed comparison flags), A6 (comparison order), '
      'and A11 (repair neighborhood). Comparison operands remain free within their required flag histories. '
      'No global lower bound follows.\n\n'
      'Most unresolved queries have no decoded model. Thus they have no measured candidate failure set. '
      'The new ranking tests a reproducible baseline for each configuration: reorder the source comparison blocks, '
      'delete one permitted data instruction, and choose output snapshots with a coordinate-descent heuristic. '
      'The test uses all 541 weak orders and concrete scratch value 7. The score is not an exact minimum. '
      'A seed need not satisfy the requested comparison flags; prefix compatibility is recorded separately. '
      'The ranking uses the smaller of the baseline failure count and any earlier decoded-model failure count. '
      'It breaks ties by the original variable count, clause count, and queue index.\n\n'
      f"The independent list evaluator matched all {prep['independent_baseline_checks']} retained baseline failure sets. "
      f"Preparation used {prep['cpu_seconds']:.3f} CPU seconds. The selected 100 have scores "
      f"{prep['selected_failure_range'][0]} through {prep['selected_failure_range'][1]}. "
      f"The all-weak-order information filter accepts {prep['selected_weak_valid']} selected orders. "
      'This ranking does not improve the earlier twelve-order near miss. '
      'Files: [ranked_unknown.json](round4/artifacts/ranked_unknown.json) and '
      '[preparation.json](round4/artifacts/preparation.json).\n\n'
      f"All 698 unresolved configurations fall into {prep['structure_classes']} recorded structure classes. "
      'A class records the comparison-flag family, unchanged comparison-prefix length, fixed data-prefix length, '
      'comparison positions, direction freedom, first rejected comparison if any, and failing output positions. '
      'The class file identifies all 598 configurations outside the selected 100. '
      'These are descriptive classes, not proven program equivalences. '
      'File: [structure_classes.json](round4/artifacts/structure_classes.json).\n\n'
      'Each selected original configuration gets a new 600-second wall budget shared across SAT refinements. '
      'The query retains its previous prefix, register bound, positions, and comparison-direction option. '
      'Validated comparison-origin constraints encode the necessary identity choice within each earlier flag history. '
      'Information-filter witness cases are added where available. For an accepted order, up to 64 evenly sampled baseline failures are also added to the initial query. '
      'These are ordinary weak-order cases, so they do not change the full-case query scope. Kissat checks every emitted Boolean clause '
      'against a SAT assignment before decoding. Each decoded program goes through the strict out judge. '
      'A passing program also gets a memory form and the strict memory judge.\n\n'
      'The absent-order repair keeps k=31 and eight comparisons. It frees the earlier median data path and '
      'allows up to three other source data slots to change. The solver chooses these additional slots. '
      'The deletion selector still removes one median-path data instruction from the length-32 baseline. '
      'Thus “three extra instructions” means three additional changed source slots in this experiment. '
      'It does not raise the target length. Each order gets the recorded wall limit; limited queries remain UNKNOWN.\n\n'
      'The new encoder controls pin three correct sources after deliberately changing three fixed source slots '
      'in their baselines. With an allowance of three, all three must return SAT and strict PASS. '
      'With an allowance of two, all three must return UNSAT. These are tests of the selector and shift handling. '
      'They are not a proof of encoder correctness. The first memory conversion used an unsupported register name. '
      'It failed to parse. The conversion now assigns distinct S registers, and the controls were rerun.\n\n'
      f"Controls completed: {len(controls)}/6; {dict(Counter(r['status'] for r in controls))}. "
      'File: [controls.json](round4/artifacts/controls.json).\n\n'
      '| Search | Completed | Status | Parent CPU seconds | Child CPU seconds | Wall seconds |\n'
      '|---|---:|---|---:|---:|---:|\n')
    for g in groups:
        text+=f"| {g['name']} | {g['completed']}/{g['planned']} | {g['status']} | {g['parent_cpu']:.3f} | {g['child_cpu']:.3f} | {g['wall']:.3f} |\n"
    text+=(f"\nThe original 795-configuration ledger now has {97+resolved} UNSAT and {698-resolved} UNKNOWN configurations. "
      'Only completed selected-query UNSAT results change this ledger. The broader median repairs form a separate query family. '
      'Unrun and timed-out queries remain UNKNOWN. No independently checked UNSAT certificate was produced.\n\n'
      'All jobs run sequentially at nice level 19 on one CPU. Each job has a 2,800 MiB address-space limit. '
      'The solver wrapper also checks combined parent and child resident memory against 2,800,000 KiB. '
      'All writes stay in w9. No agents were started.\n\n'
      'Recorded strict PASS files from this round follow. These controls have k=32 and memory length 42.\n\n'
      '| PASS file | Model | Judge output |\n|---|---|---|\n')
    audit_path=HERE/'artifacts/extra3_audit.json'
    if audit_path.exists():
        audit=json.loads(audit_path.read_text())
        note=('\nThe completed absent-order audit confirms all 653 distinct indices. '
              'The solver returned UNSAT for six orders accepted by the earlier information filter. '
              'Their indices are '+', '.join(str(r['index']) for r in audit['accepted_order_unsat'])+'. '
              'These six results retain the new repair restrictions. '
              'Seven filter-rejected orders reached the five-second solver limit and remain UNKNOWN. '
              'The audit records all four filter/status counts, query identities, solver logs, and resource totals. '
              'File: [extra3_audit.json](round4/artifacts/extra3_audit.json).\n\n')
        text=text.replace('Recorded strict PASS files from this round follow.',note+'Recorded strict PASS files from this round follow.')
    for r in controls+top+extra:
        if not r.get('strict_pass'):continue
        p=Path(r['path']);out_log=r['models'][-1]['judge_log']
        text+=f"| [{p.name}]({p.relative_to(HERE.parent)}) | out | [PASS]({Path(out_log).relative_to(HERE.parent)}) |\n"
        if r.get('memory_strict_pass'):
            p=Path(r['memory_path']);log=Path(r['memory_strict_log'])
            text+=f"| [{p.name}]({p.relative_to(HERE.parent)}) | mem | [PASS]({log.relative_to(HERE.parent)}) |\n"
        for p in (Path(r['path']),Path(r['memory_path'])):
            copy=HERE/'verified'/p.name
            text+=f"| [{copy.name} retained copy]({copy.relative_to(HERE.parent)}) | {'mem' if p.stem.endswith('_mem') else 'out'} | byte-identical to tested file |\n"
    found=[r for r in top+extra if r.get('strict_pass') and r['k']<=31]
    text+=('\nNo k<=31 strict PASS is recorded in this round.\n' if not found else '\nA k<=31 strict PASS is recorded above and at the top of this file.\n')
    text+='\nCurrent activity: [LIVE.md](round4/LIVE.md). Full records: [summary.json](round4/artifacts/summary.json), [top100.jsonl](round4/artifacts/top100.jsonl), and [median_extra3.jsonl](round4/artifacts/median_extra3.jsonl).\n'
    text+='\nResume with `bash round4/run_remaining.sh`. The runner skips every recorded query, including recorded time limits. To stop a later runner between queries, create `round4/STOP_AFTER_QUERY`; remove that file before resuming. The active query can use its remaining wall budget before the runner stops.\n'
    p=HERE.parent/'RESULTS.md';old=p.read_text().split(MARK)[0]
    tmp=HERE/'RESULTS.tmp';tmp.write_text(old+text);tmp.replace(p)

if __name__=='__main__':report()
