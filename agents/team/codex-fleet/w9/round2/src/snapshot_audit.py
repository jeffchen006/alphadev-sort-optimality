"""Check all free output snapshots in each replayed SAT program."""
import json
from pathlib import Path
import subprocess
from order_sat import HERE,ROOT,CASES,evaluate,emit
from orders import read

def main():
    records=[]
    for path in sorted((HERE/'candidates').glob('model_replay*.s')):
        p,R=read(path);cols,_=evaluate(p,R);out=[];errors=[];exact=[]
        for j in range(5):
            goal=tuple(sorted(w)[j] for w in CASES)
            eligible=[t for t,x in enumerate(p) if x[0]!='cmp']
            t=min(eligible,key=lambda t:sum(a!=b for a,b in zip(cols[t],goal)))
            out.append((t+1,p[t][1]));errors.append(sum(a!=b for a,b in zip(cols[t],goal)))
            exact.append(errors[-1]==0)
        failed=sum(any(cols[t-1][ci]!=sorted(w)[j] for j,(t,r) in enumerate(out)) for ci,w in enumerate(CASES))
        row={'source':str(path),'best_output_errors':errors,'best_snapshot_failed_orders':failed,
             'all_outputs_available':all(exact)}
        if all(exact) or failed<12:
            dest=path.with_stem('snapshot_'+path.stem);emit(p,out,dest)
            log=HERE/'logs'/f'{dest.stem}_strict.log'
            with log.open('w') as stream:
                result=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),str(dest),'--strict','--model','out'],stdout=stream,stderr=subprocess.STDOUT)
            row.update(path=str(dest),judge_log=str(log),strict_pass=result.returncode==0 and 'PASS' in log.read_text())
        records.append(row);print(json.dumps(row),flush=True)
    (HERE/'artifacts/snapshot_audit.json').write_text(json.dumps(records,indent=2)+'\n')

if __name__=='__main__':main()
