"""After the batch, recover a known k=32 program through four free positions."""
import json
import os
import resource
from controller import BASE, ROOT, digest, run_task, save
from audit import audit
from reference_window import read


def main():
    assert (BASE/'logs/finish.json').exists(), 'Wait for all batch and certificate jobs'
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    seed=ROOT/'round3/candidates/control32.s';_,nr=read(seed)
    task=dict(tag='free_positive32',seed=str(seed),seed_sha256=digest(seed),registers=nr,
              window=[0,8,14,24],seconds=120,group='control',all_cases=True)
    row=run_task(task)
    controls=BASE/'logs/controls.json';rows=json.loads(controls.read_text());rows.append(row);save(controls,rows)
    audited=audit()
    accounting={'solver_only_seconds':0.0,'early_child_counter_seconds':0.0}
    for result in json.loads((BASE/'logs/summary.json').read_text()):
        last=next((e for e in reversed(result['records']) if e.get('step')=='kissat'),{})
        key='solver_only_seconds' if last.get('cpu_counter')=='solver_only' else 'early_child_counter_seconds'
        accounting[key]+=last.get('solver_cpu_seconds',0)
    accounting={k:round(v,3) for k,v in accounting.items()}
    save(BASE/'logs/cpu_accounting.json',accounting)
    text='\n### Round-5 free-position positive control\n\n'
    if row['status']=='PASS':
        text+='The additional control leaves four non-contiguous instruction positions free on all 541 weak orders. '
        text+='It allows all six opcodes and both operands. The remaining instructions stay fixed. '
        text+='The solver recovered a strict out PASS at k=32. This is a control, not a target result.\n\n'
        for e in row['records']:
            if e.get('step')=='model_judge' and e['returncode']==0:
                text+=f'- PASS file: `{e["path"]}`. Judge log: `{e["path"]}.judge`.\n'
        for j in row['judges']:
            if j['returncode']==0:text+=f'- PASS file: `{j["path"]}`. Judge log: `{j["log"]}`.\n'
    else:
        text+=f"The additional control ended with status {row['status']}. No shorter result follows.\n"
    text+='\nThe independent audit includes this control. Scope: [G1,G2,G3,G4,A2,A11].\n'
    text+=(f"\nCPU-counter clarification: later solver-only counters total {accounting['solver_only_seconds']:.3f} seconds. "
           f"Earlier child counters total {accounting['early_child_counter_seconds']:.3f} seconds. "
           "The earlier counters include a small, inseparable checkpoint-audit overhead. "
           "Thus the aggregate printed above is recorded child CPU time, not an exact pure Kissat total.\n")
    with (ROOT/'RESULTS.md').open('a') as f:f.write(text)
    save(BASE/'logs/postcheck.json',dict(row=row,audit=audited))
    print(text,flush=True)


if __name__=='__main__':main()
