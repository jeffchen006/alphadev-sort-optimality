"""Audit query coverage, solver status records, source hashes, and strict PASS files."""
from pathlib import Path
from collections import Counter
import hashlib,json,sys
HERE=Path(__file__).resolve().parent

def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def events(path):
    rows=[]
    for line in Path(path).read_text().splitlines():
        try:rows.append(json.loads(line))
        except ValueError:pass
    return rows

def main():
    manifest=json.loads((HERE/'manifest.json').read_text())
    selection=json.loads((HERE/'selection.json').read_text())
    queue=json.loads((HERE/'queue.json').read_text())
    results=json.loads((HERE/'results.json').read_text())
    progress=json.loads((HERE/'progress.json').read_text())
    ranked=sorted(manifest,key=lambda r:(len({tuple(sorted((d,s))) for o,d,s in r['program'] if o==1}),r['index']))
    selected=[r['index'] for r in ranked[:20]]
    assert selected==[r['seed'] for r in selection['selected']]
    expected={(s,start) for s in selected for start in range(29)}
    assert {(r['seed'],r['start']) for r in queue}==expected and len(queue)==580
    done={(r['seed'],r['start']) for r in results}
    assert len(done)==len(results) and done<=expected
    integrity=[];calls=refined=peak=0
    for row in results:
        assert row['width']==4 and row['replacement']==3
        assert digest(row['log'])==row['log_sha256']
        parsed=events(row['log'])
        solves=[r for r in parsed if r.get('step')=='kissat_result']
        calls+=len(solves);refined+=len(solves)>1
        for event in solves:
            raw=Path(event['raw_log']).read_text()
            peak=max(peak,event['stats']['peak_job_rss_kib'])
            if event['solver_status']=='UNSAT':
                assert event['returncode']==20 and 's UNSATISFIABLE' in raw
            if event['solver_status']=='SAT':
                assert event['returncode']==10 and 's SATISFIABLE' in raw
        if row['status']=='UNSAT':
            assert row['code']==0 and solves[-1]['solver_status']=='UNSAT'
            assert parsed[-1]['status']=='UNSAT'
            assert row['last']['types']==parsed[-1]['types']
            assert all(e['k']==31 and e['registers']==manifest[row['seed']]['registers']+3
                       for e in parsed if e.get('step')=='solve')
            integrity.append(dict(seed=row['seed'],start=row['start'],types=row['last']['types'],
                 log_sha256=row['log_sha256'],cnf_sha256=solves[-1]['cnf_sha256'],
                 solver_log_sha256=digest(solves[-1]['raw_log'])))
    sources=[]
    for row in manifest:
        assert digest(row['source'])==row['sha256']
        sources.append(dict(source=row['source'],sha256=row['sha256']))
    passes=[]
    for line in (HERE/'judge_ledger.jsonl').read_text().splitlines():
        row=json.loads(line)
        assert row['passed'] and row['code']==0 and digest(row['file'])==row['sha256']
        assert Path(row['log']).read_text().startswith('PASS ')
        passes.append(row)
    summary=dict(planned=len(queue),finished=len(results),unstarted=len(expected-done),selected_seeds=selected,
          status_counts=dict(Counter(r['status'] for r in results)),solver_calls=calls,
          queries_with_refinement=refined,query_seconds=sum(r['seconds'] for r in results),
          max_query_seconds=max((r['seconds'] for r in results),default=0),max_observed_job_rss_kib=peak,
          passes=passes,all_jobs_finished=progress['all_jobs_finished'],assumption_tags=['G1','G2','G3','A2','A11'])
    for name,value in [('unsat_integrity',integrity),('source_integrity',sources),('final_summary',summary)]:
        (HERE/f'{name}.json').write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps({k:v for k,v in summary.items() if k!='passes'},indent=2))
    if '--append' in sys.argv:
        assert progress['all_jobs_finished'] and not (HERE/'active.json').exists()
        text=f'''

### Round-9 final result

The batch finished {len(results)} of {len(queue)} planned width-four queries. Status counts: `{summary['status_counts']}`. Unstarted queries: {summary['unstarted']}. Only completed UNSAT results count as bounded exclusions. A limited query remains UNKNOWN.

The sum of query wall times is {summary['query_seconds']:.2f} seconds. The longest query took {summary['max_query_seconds']:.2f} seconds. The maximum observed combined encoder and solver resident memory was {peak:,} KiB. The batch made {calls} solver calls. Counterexample refinement occurred in {refined} queries.

The final audit checked the twenty-source selection and all 29 windows per source. It checked each reported UNSAT against Kissat exit code 20, its UNSAT status line, and the retained log hashes. It checked every source hash and strict PASS file hash. Formula hashes and case counts are in `round9/unsat_integrity.json`. Complete counts and all strict PASS paths are in `round9/final_summary.json`. The judge ledger is `round9/judge_ledger.jsonl`.

The control has strict PASS in both models: `round9/verified/window4_control32.s` (out, k=32) and `round9/verified/window4_control32_mem.s` (mem, L=42). Its judge logs are `round9/logs/judge_window4_control32.log` and `round9/logs/judge_window4_control32_mem.log`.

Assumption tags: [G1,G2,G3,A2,A11]. The result covers this finite local-repair relation and register alphabet. It does not establish a global lower bound. No assumption was contradicted. All round-9 jobs have finished.
'''
        if not any(r.get('strict_pass') for r in results):
            text+='\nNo k<=31 program received a strict judge PASS in this round. The target memory length of at most 41 remains open.\n'
        with (HERE.parent/'RESULTS.md').open('a') as stream:stream.write(text)

if __name__=='__main__':main()
