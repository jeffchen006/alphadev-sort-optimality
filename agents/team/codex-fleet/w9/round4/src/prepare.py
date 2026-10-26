"""Rank unresolved configurations by a concrete, reproducible baseline test.

The baseline reorders source comparison blocks and deletes one data instruction.
Snapshot selection is a coordinate-descent heuristic, not an exact minimum.
The failure count concerns concrete scratch=7 and is not strict verification.
"""
from collections import Counter, defaultdict
import hashlib
import json
import os
from pathlib import Path
import resource
import sys
import time

sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
OLD=HERE.parent/'round3'
sys.path.append(str(HERE.parent/'round2/src'))
from control import transformed
from order_kissat import CASES,emit,evaluate

ALL=(1<<541)-1
def planes(column):
    return tuple(sum(1<<i for i,v in enumerate(column) if v>>b&1) for b in range(3))
INPUT=[planes([w[r] for w in CASES]) for r in range(5)]
GOALS=[planes([sorted(w)[j] for w in CASES]) for j in range(5)]

def bit_evaluate(p,R):
    regs=INPUT+[(ALL,ALL,ALL)]*(R-5)
    less=greater=0;columns=[];flags=[]
    for op,d,s in p:
        a,b=regs[d],regs[s]
        if op=='cmp':
            equal=ALL;less=greater=0
            for u,v in zip(reversed(a),reversed(b)):
                less|=equal&~u&v;greater|=equal&u&~v;equal&=~(u^v)
            flags.append((less,greater))
        elif op=='mov':regs[d]=b
        else:
            mask={'cmovl':less,'cmovle':ALL^greater,'cmovg':greater,'cmovge':ALL^less}[op]
            regs[d]=tuple(x^((x^y)&mask) for x,y in zip(a,b))
        columns.append(regs[d])
    return columns,flags

def score(p,R):
    columns,_=bit_evaluate(p,R)
    data=[t for t,x in enumerate(p) if x[0]!='cmp']
    errors=[{t:(columns[t][0]^goal[0])|(columns[t][1]^goal[1])|(columns[t][2]^goal[2]) for t in data} for goal in GOALS]
    picked=[min(row,key=lambda t:(row[t].bit_count(),t)) for row in errors]
    # Optimise the union of failures. Keep a deterministic tie preference.
    for _ in range(5):
        changed=False
        for j in range(5):
            rest=0
            for h in range(5):
                if h!=j:rest|=errors[h][picked[h]]
            t=min(data,key=lambda t:((rest|errors[j][t]).bit_count(),errors[j][t].bit_count(),t))
            changed|=t!=picked[j];picked[j]=t
        if not changed:break
    failed=0
    for j,t in enumerate(picked):failed|=errors[j][t]
    return {'failed_orders':failed.bit_count(),
            'failing_cases':[ci for ci in range(541) if failed>>ci&1],
            'per_output_failures':[errors[j][t].bit_count() for j,t in enumerate(picked)],
            'outputs':[(t+1,p[t][1]) for t in picked]}

def reordered(row,order,cache):
    source=row['source']
    if source not in cache:cache[source]=transformed(row)
    p,R,old=cache[source]
    starts=[t for t,x in enumerate(p) if x[0]=='cmp']+[len(p)]
    blocks={j:p[starts[i]:starts[i+1]] for i,j in enumerate(old)}
    q=[x for j in order for x in blocks[j]]
    return q,R,old

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    start=time.process_time()
    queue=json.loads((OLD/'artifacts/unknown_queue.json').read_text())
    filters=json.loads((OLD/'artifacts/unknown_weak_filter.json').read_text())
    reruns=[json.loads(x) for x in (OLD/'artifacts/kissat_unknown.jsonl').read_text().splitlines()]
    excluded={r['queue_index'] for r in reruns if r['status']=='UNSAT'}
    cache={};ranked=[];classmap=defaultdict(list)
    for item in queue:
        i=item['queue_index']
        if i in excluded:continue
        previous=item['previous'];order=previous['order'];q,R,old=reordered(item['row'],order,cache)
        prefix=[tuple(x) for x in item['prefix']]
        choices=[]
        if len(q)==32:
            for deleted,x in enumerate(q):
                if x[0]=='cmp' or deleted<len(prefix):continue
                p=q[:deleted]+q[deleted+1:]
                if previous.get('positions') is not None and [t for t,x in enumerate(p) if x[0]=='cmp']!=previous['positions']:continue
                choices.append((deleted,p))
        elif len(q)==31:choices=[(None,q)]
        compatible=[(d,p) for d,p in choices if p[:len(prefix)]==prefix]
        # A baseline need not satisfy all flag constraints. This is a ranking,
        # and its compatibility with retained data and placements is explicit.
        candidates=compatible or choices
        if not candidates:
            candidates=[(None,q)]
        best=None
        for d,p in candidates:
            s=score(p,R);key=(s['failed_orders'],sum(s['per_output_failures']),d if d is not None else -1)
            if best is None or key<best[0]:best=(key,d,p,s)
        _,deleted,p,s=best
        # Check the bit-plane evaluator independently on each retained seed.
        cols,_=evaluate(p,R)
        actual=[ci for ci,w in enumerate(CASES) if any(cols[t-1][ci]!=sorted(w)[j] for j,(t,r) in enumerate(s['outputs']))]
        assert actual==s['failing_cases']
        models=previous.get('models',[])
        model_errors=[m['output_failed_orders'] for m in models if 'output_failed_orders' in m]
        f=filters[i]
        common=next((j for j,(a,b) in enumerate(zip(order,old)) if a!=b),8)
        signature=(previous['family'],common,len(prefix),tuple(previous.get('positions') or ()),
                   previous.get('polarity',False),f.get('first_bad_comparison'),
                   tuple(j for j,n in enumerate(s['per_output_failures']) if n))
        row={'queue_index':i,'family':previous['family'],'order':order,
             'baseline':p,'baseline_deleted_slot':deleted,'baseline_k':len(p),
             'baseline_matches_prefix':p[:len(prefix)]==prefix,'baseline_score':s,
             'recorded_model_min_failed_orders':min(model_errors) if model_errors else None,
             'ranking_failures':min([s['failed_orders']]+model_errors),
             'weak_filter_valid':f['valid'],'structure_class':list(signature),
             'source_sha256':item['source_sha256'],'old_variables':previous['variables'],
             'old_clauses':previous['clauses'],'common_comparisons':common,
             'prefix_length':len(prefix),'regs':previous['regs']}
        ranked.append(row);classmap[signature].append(i)
    assert len(ranked)==698
    ranked.sort(key=lambda r:(r['ranking_failures'],r['old_variables'],r['old_clauses'],r['queue_index']))
    for rank,row in enumerate(ranked):row['rank']=rank
    (HERE/'artifacts/ranked_unknown.json').write_text(json.dumps(ranked,indent=2)+'\n')
    selected=ranked[:100];selected_set={r['queue_index'] for r in selected}
    classes=[{'class_id':i,'signature':list(key),'members':values,'count':len(values),
              'selected_count':sum(v in selected_set for v in values)}
             for i,(key,values) in enumerate(sorted(classmap.items(),key=lambda x:repr(x[0])))]
    (HERE/'artifacts/structure_classes.json').write_text(json.dumps(classes,indent=2)+'\n')
    summary={'unresolved':len(ranked),'selected':100,'selected_weak_valid':sum(r['weak_filter_valid'] for r in selected),
             'selected_failure_range':[min(r['ranking_failures'] for r in selected),max(r['ranking_failures'] for r in selected)],
             'selected_failure_counts':dict(Counter(r['ranking_failures'] for r in selected)),
             'structure_classes':len(classes),'other_configurations':len(ranked)-100,
             'other_family_counts':dict(Counter(r['family'] for r in ranked[100:])),
             'all_weak_valid':sum(r['weak_filter_valid'] for r in ranked),
             'independent_baseline_checks':len(ranked),'cpu_seconds':time.process_time()-start,
             'ranking_method':'Minimum of recorded decoded-model errors and reordered-source deletion baseline; snapshot heuristic; concrete scratch=7; no claim of SAT compatibility or exact minimum'}
    (HERE/'artifacts/preparation.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary),flush=True)

if __name__=='__main__':main()
