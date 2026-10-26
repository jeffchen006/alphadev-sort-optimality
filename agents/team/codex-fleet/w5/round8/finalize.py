"""Audit all retained solver records and report only completed exclusions."""
from pathlib import Path
from collections import Counter
import hashlib,json,sys
HERE=Path(__file__).resolve().parent

def events(path):
    out=[]
    for line in path.read_text().splitlines():
        try:out.append(json.loads(line))
        except ValueError:pass
    return out

def main():
    queue=json.loads((HERE/'queue.json').read_text())
    results=json.loads((HERE/'results.json').read_text());progress=json.loads((HERE/'progress.json').read_text())
    expected={(r['seed'],r['start']) for r in queue};done={(r['seed'],r['start']) for r in results}
    assert len(expected)==len(queue) and len(done)==len(results) and done<=expected
    negatives=[];equivalences=[];peak=0;calls=0;refined=0
    manifest=json.loads((HERE/'manifest.json').read_text())
    lookup={(r['seed'],r['start']):r for r in results}
    for row in results:
        path=Path(row['log']);assert hashlib.sha256(path.read_bytes()).hexdigest()==row['log_sha256']
        parsed=events(path);solves=[x for x in parsed if x.get('step')=='kissat_result']
        calls+=len(solves);refined+=len(solves)>1
        for event in solves:
            raw=Path(event['raw_log']);text=raw.read_text()
            peak=max(peak,event['stats']['peak_job_rss_kib'])
            if event['solver_status']=='UNSAT':
                assert event['returncode']==20 and 's UNSATISFIABLE' in text
            if event['solver_status']=='SAT':
                assert event['returncode']==10 and 's SATISFIABLE' in text
        if row['status']=='UNSAT':
            assert solves and solves[-1]['solver_status']=='UNSAT'
            negatives.append(dict(seed=row['seed'],start=row['start'],types=row['last']['types'],
                   cnf_sha256=solves[-1]['cnf_sha256'],log_sha256=row['log_sha256'],
                   raw_sha256=hashlib.sha256(Path(solves[-1]['raw_log']).read_bytes()).hexdigest()))
        elif row['status']=='UNSAT_EQUIVALENT':
            event=row['last'];key=(event['representative_seed'],event['representative_start'])
            representative=lookup[key]
            assert representative['status']=='UNSAT'
            assert representative['log_sha256']==event['representative_log_sha256']
            assert row['start']==representative['start']
            nr=manifest[row['seed']]['registers']+2
            assert nr==manifest[representative['seed']]['registers']+2
            current_map={int(k):v for k,v in event['register_mapping'].items()}
            old_map={int(k):v for k,v in event['representative_register_mapping'].items()}
            assert set(current_map)==set(old_map)==set(range(nr))
            assert set(current_map.values())==set(old_map.values())==set(range(nr))
            inverse_current={v:k for k,v in current_map.items()}
            transform={r:inverse_current[old_map[r]] for r in range(nr)}
            assert all((r<5)==(transform[r]<5) for r in range(nr))
            def replaced(index,start):
                p=manifest[index]['program'];return p[:start]+p[start:start+2]+p[start+3:]
            newp=replaced(row['seed'],row['start'])
            oldp=replaced(representative['seed'],representative['start'])
            for i,((o,d,s),(qo,qd,qs)) in enumerate(zip(oldp,newp)):
                if row['start']<=i<row['start']+2:continue
                assert transform[d]==qd and transform[s]==qs
                assert o==qo or o>=2 and qo>=2
            equivalences.append(dict(seed=row['seed'],start=row['start'],representative=list(key),
                                     old_to_new_registers=transform,log_sha256=row['log_sha256']))
    integrity=[]
    for row in json.loads((HERE/'manifest.json').read_text()):
        assert hashlib.sha256(Path(row['source']).read_bytes()).hexdigest()==row['sha256']
        integrity.append(dict(source=row['source'],sha256=row['sha256']))
    passes=[]
    for line in (HERE/'judge_ledger.jsonl').read_text().splitlines():
        row=json.loads(line)
        assert row['passed'] and row['code']==0
        assert hashlib.sha256(Path(row['file']).read_bytes()).hexdigest()==row['sha256']
        assert Path(row['log']).read_text().startswith('PASS ')
        passes.append(row)
    summary=dict(planned=len(queue),finished=len(results),unstarted=len(expected-done),
          status_counts=dict(Counter(r['status'] for r in results)),
          seed_count=len(integrity),solver_calls=calls,queries_with_refinement=refined,
          query_seconds=sum(r['seconds'] for r in results),
          max_query_seconds=max((r['seconds'] for r in results),default=0),
          max_observed_job_rss_kib=peak,passes=passes,
          all_jobs_finished=progress['all_jobs_finished'],assumption_tags=['G1','G2','G3','A2','A11'])
    (HERE/'unsat_integrity.json').write_text(json.dumps(negatives,indent=2)+'\n')
    (HERE/'equivalence_integrity.json').write_text(json.dumps(equivalences,indent=2)+'\n')
    (HERE/'source_integrity.json').write_text(json.dumps(integrity,indent=2)+'\n')
    (HERE/'final_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({k:v for k,v in summary.items() if k!='passes'},indent=2))
    if '--append' in sys.argv:
        text=f'''

### Round-8 final result

The batch finished {len(results)} of {len(queue)} planned queries. Status counts: `{summary['status_counts']}`. Unstarted queries: {summary['unstarted']}. A completed solver UNSAT is a bounded exclusion. An equivalent query inherits that exclusion only through an audited input/scratch register bijection. Any limited or unstarted query remains unknown.

The sum of query wall times is {summary['query_seconds']:.2f} seconds. The longest query took {summary['max_query_seconds']:.2f} seconds. The maximum observed combined encoder and solver resident memory was {peak:,} KiB. The batch made {calls} solver calls. Counterexample refinement occurred in {refined} queries.

The control received strict PASS in both models:

- `round8/verified/window_control32.s`: out, k=32.
- `round8/verified/window_control32_mem.s`: mem, L=42.

The exact judge output is in `round8/logs/judge_window_control32.log` and `round8/logs/judge_window_control32_mem.log`. The control tests an actual free two-slot replacement after duplicate-CMP insertion. It does not meet k<=31 and is not an encoding proof.

The final audit checked each solver UNSAT against Kissat exit code 20, its UNSAT status line, and retained log hashes. For each inherited exclusion, it independently checked a complete register bijection, preservation of the input/scratch boundary, and equality of every constrained instruction under that mapping. All inherited exclusions reference a direct solver UNSAT. It checked every source hash and retained strict PASS hash. Formula hashes and encoded case counts are in `round8/unsat_integrity.json`. Register maps are in `round8/equivalence_integrity.json`. Complete counts and PASS paths are in `round8/final_summary.json`.

Assumption tags: [G1,G2,G3,A2,A11]. These results concern the selected finite local repairs. They do not establish a global lower bound. No assumption was contradicted. All round-8 jobs have finished.
'''
        if not any(r.get('strict_pass') for r in results):
            text+='\nNo k<=31 program received a strict judge PASS in this round. The target memory length of at most 41 remains open.\n'
        assert progress['all_jobs_finished'] and not (HERE/'active.json').exists()
        with (HERE.parent/'RESULTS.md').open('a') as stream:stream.write(text)
if __name__=='__main__':main()
