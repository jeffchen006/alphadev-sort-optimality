"""Check all rejection witnesses without the bitset filter implementation."""
import json
import os
from pathlib import Path
import resource
import sys

sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(HERE.parent/'round2/src'))
from order_sat import CASES,family_data


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    cache={};summary=[]
    for name in ('median','unknown'):
        queue=json.loads((HERE/'artifacts'/f'{name}_queue.json').read_text())
        records=json.loads((HERE/'artifacts'/f'{name}_weak_filter.json').read_text())
        rejected=0;valid_sampled=0
        for task,record in zip(queue,records):
            source=record['source']
            if source not in cache:
                cache[source]=family_data(task['row'],list(range(8)))
            flags=[cache[source][j] for j in record['order']]
            if not record['valid']:
                j=record['first_bad_comparison'];witness=record['witness_cases']
                histories=[tuple(flags[h][t] for h in range(j)) for t in witness]
                assert all(h==histories[0] for h in histories)
                candidates=[]
                for left in range(5):
                    for right in range(5):
                        if all((CASES[t][left]>CASES[t][right])-(CASES[t][left]<CASES[t][right])+1==flags[j][t]
                               for t in witness):candidates.append((left,right))
                assert not candidates,(record,candidates)
                rejected+=1
            elif record['queue_index']%13==0:
                for j in range(8):
                    groups={}
                    for t in range(541):groups.setdefault(tuple(flags[h][t] for h in range(j)),[]).append(t)
                    for group in groups.values():
                        assert any(all((CASES[t][left]>CASES[t][right])-(CASES[t][left]<CASES[t][right])+1==flags[j][t]
                                       for t in group) for left in range(5) for right in range(5))
                valid_sampled+=1
        summary.append({'queue':name,'rows':len(records),'rejection_witnesses_checked':rejected,
                        'valid_orders_sampled':valid_sampled,'different_flag_generation':True})
    (HERE/'artifacts/weak_filter_checks.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary),flush=True)


if __name__=='__main__':main()
