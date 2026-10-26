"""Wait without a CPU search, then audit results and finish certificate checks."""
import json
import os
import resource
import sys
import time
from controller import BASE, ROOT, CHECKER, digest, launch, report, save
from audit import audit


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    while not (BASE/'logs/final_audit.json').exists():
        time.sleep(5)
    rows=json.loads((BASE/'logs/summary.json').read_text())
    for row in rows:
        if row['status']!='UNSAT_UNCHECKED':continue
        cnf=BASE/'cnf'/f'{row["tag"]}.cnf';proof=cnf.with_suffix('.drat')
        log=BASE/'logs'/f'{row["tag"]}.verify_long.log'
        check=launch([str(CHECKER),str(cnf),str(proof)],log,600)
        verified=check['returncode']==0 and 's VERIFIED' in log.read_text()
        row['certificate_first_check']=row['certificate']
        row['certificate']=dict(returncode=check['returncode'],seconds=check['seconds'],verified=verified,
            cnf=str(cnf),cnf_sha256=digest(cnf),proof_sha256=digest(proof),verification_log=str(log))
        if verified:
            row['status']='UNSAT'
            # Keep the audited standard verification-log path in sync.
            (BASE/'logs'/f'{row["tag"]}.verify.log').write_bytes(log.read_bytes())
        save(BASE/'logs'/f'{row["tag"]}.json',row)
        save(BASE/'logs/summary.json',rows)
    final=report(rows,True)
    audited=audit()
    rows=json.loads((BASE/'logs/summary.json').read_text())
    seconds=sum(sum(e.get('solver_cpu_seconds',0) for e in r['records'][-2:] if e.get('step')=='kissat') for r in rows)
    # Each query's Kissat counter is cumulative. Use only its final solve.
    seconds=sum(next((e.get('solver_cpu_seconds',0) for e in reversed(r['records'])
                      if e.get('step')=='kissat'),0) for r in rows)
    text=(f"\n### Round-5 final certificate audit\n\n"
          f"Completed {final['completed']} of {final['planned']} prepared windows. "
          f"Final statuses: {final['statuses']}. Groups: {final['groups']}. "
          f"Checked target UNSAT certificates: {final['verified_unsat']}. "
          f"Strict decoded-program judges: {final['model_judges']}. "
          f"Recorded Kissat CPU time: {seconds:.3f} seconds. "
          f"Largest sampled combined search resident set: {final['maximum_measured_job_rss_kib']} KiB.\n\n"
          "The independent audit checks all original 112 scopes, every copied seed hash, "
          "retained UNSAT formula/proof hashes, successful certificate-check logs, "
          "solver exit statuses, and strict judge records. Its report is "
          "`round5/logs/independent_audit.json`. Full query records are in `round5/logs/summary.json`.\n\n"
          "Assumptions [G1,G2,G3,G4,A2,A11]. Each exclusion applies only to its stated "
          "four-position window and finite register set. Every search or resource limit remains UNKNOWN. "
          "No global lower bound follows.\n")
    targets=[j for r in rows if r.get('k',99)<=31 for j in r['judges'] if not j['returncode']]
    text+='\nNo k<=31 strict PASS was found.\n' if not targets else '\nTarget strict PASS records appear above.\n'
    with (ROOT/'RESULTS.md').open('a') as f:f.write(text)
    save(BASE/'logs/finish.json',dict(complete=True,final=final,audit=audited,solver_cpu_seconds=seconds))
    print(text,flush=True)


if __name__=='__main__':main()
