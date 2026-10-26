#!/usr/bin/env python3
"""Free-predicate selector DAG with charged copies and separate execution order.

Graph outputs are sinks. Execution need not place those outputs last. Each
selector copies its default, or consumes one live parent register. Untouched
common-high scratch defaults have unlimited multiplicity. Comparisons are free.
This is a data relaxation, not an assembly synthesis or strict-judge result.
"""
import argparse
import json
import os
from pathlib import Path
import resource
import sys
import time
from pysat.card import CardEnc,EncType
from gate_bound import Circuit,PERMS,parse,run,ROOT
from solver import solve

class PhysicalDAG(Circuit):
    def __init__(self,prefix,gates,types,copies):
        super().__init__(prefix,gates,types,physical_roots=True)
        self.copy_budget=copies;self.sentinel=self.names.index('S99')
        G=gates;B=self.B
        states=[run(prefix,t)[0] for t in types]
        assert not any(all(st.get(n,5)==j for st in states)
                       for n in self.names for j in range(5))
        # Rank-trace normalization removes all outgoing output edges. The
        # graph order then places those five nodes last; execution is separate.
        first=G-5
        for j in range(5):
            self.cl(self.out[j][B+first+j])
            for earlier in range(first,first+j):
                self.cl(-self.dst[first+j][B+earlier])
                self.cl(-self.src[first+j][B+earlier])
        self.action=[self.vec(3) for _ in range(G)] # copy, consume D, consume S
        for xs in self.action:self.eo(xs)
        ca=CardEnc.atmost([x[0] for x in self.action],bound=copies,
                         top_id=self.nv,encoding=EncType.seqcounter)
        self.nv=max(self.nv,ca.nv);self.cs+=ca.clauses
        self.order={(a,b):self.new() for a in range(G) for b in range(a+1,G)}
        for a in range(G):
            for b in range(a+1,G):
                for c in range(b+1,G):
                    ab=self.before(a,b);bc=self.before(b,c);ac=self.before(a,c)
                    self.cl(-ab,-bc,ac);self.cl(ab,bc,-ac)
        for g in range(G):
            for side in (self.dst[g],self.src[g]):
                for x in range(B,B+g):self.cl(-side[x],self.before(x-B,g))
            for action,side in ((self.action[g][1],self.dst[g]),
                                (self.action[g][2],self.src[g])):
                for x in range(B+g):
                    if x==self.sentinel:continue
                    for h in range(G):
                        if h==g or x>=B+h:continue
                        for user in (self.dst[h],self.src[h]):
                            self.cl(-action,-side[x],-user[x],self.before(h,g))

    def before(self,a,b):
        assert a!=b
        return self.order[a,b] if a<b else -self.order[b,a]

    def fix_graph(self,saved):
        """Fix graph and free predicates, but solve storage and execution."""
        assert saved['names']==self.names
        assert len(saved['graph'])==self.gates
        for g,gate in enumerate(saved['graph']):
            d,s=gate['default'],gate['source'];take=gate['take']
            if d==s:
                s=self.sentinel if d!=self.sentinel else 0
                take=[False]*len(self.types)
            if d>s:d,s=s,d;take=[not x for x in take]
            self.cl(self.dst[g][d]);self.cl(self.src[g][s])
            for t,bit in enumerate(take):self.cl(self.take[g][t] if bit else -self.take[g][t])
        for j,x in enumerate(saved['outputs']):self.cl(self.out[j][x])

    def check_physical(self,model):
        dag=self.check(model);yes={x for x in model if x>0}
        order=sorted(range(self.gates),key=lambda g:sum(
            self.before(h,g) in yes if self.before(h,g)>0 else -self.before(h,g) not in yes
            for h in range(self.gates) if h!=g))
        rank={g:i for i,g in enumerate(order)}
        assert all((self.before(a,b) in yes)==(rank[a]<rank[b])
                   for a in range(self.gates) for b in range(a+1,self.gates))
        initial=[tuple(run(self.prefix,t)[0].get(n,5) for t in self.types) for n in self.names]
        cols=list(initial);live=set(range(self.B));mapping={x:x for x in live}
        graph=[];actions=[];copies=0
        for g in order:
            gate=dag['graph'][g];d=mapping[gate['default']];s=mapping[gate['source']]
            assert d in live and s in live
            take=list(gate['take'])
            action=next(i for i,x in enumerate(self.action[g]) if x in yes)
            if action==0:
                col=cols[d];graph.append(dict(default=0,source=d,mov=True,
                                              take=[True]*len(self.types),column=col))
                cols.append(col);d=len(cols)-1;live.add(d);copies+=1
            elif action==2:d,s=s,d;take=[not x for x in take]
            col=tuple(cols[s][t] if take[t] else cols[d][t] for t in range(len(self.types)))
            assert col==tuple(gate['column'])
            if d!=self.sentinel:live.remove(d)
            graph.append(dict(default=d,source=s,mov=False,take=take,column=col))
            cols.append(col);mapping[self.B+g]=len(cols)-1;live.add(len(cols)-1)
            actions.append(action)
        outputs=[mapping[x] for x in dag['outputs']]
        assert copies<=self.copy_budget
        assert all(cols[x]==(j,)*len(self.types) for j,x in enumerate(outputs))
        return dict(types=self.types,names=self.names,graph=graph,outputs=outputs,
                    dag_order=order,dag_actions=actions,copies=copies)

def normalize_saved(saved):
    """Fold mov aliases; remove output reads by fresh sentinel defaults."""
    B=len(saved['names']);sent=saved['names'].index('S99');mapping={x:x for x in range(B)}
    graph=[]
    for i,gate in enumerate(saved['graph']):
        d=mapping[gate['default']];s=mapping[gate['source']]
        if gate.get('mov',False):mapping[B+i]=s
        else:
            graph.append(dict(default=d,source=s,take=gate['take']))
            mapping[B+i]=B+len(graph)-1
    outputs=[mapping[x] for x in saved['outputs']];targets=set(outputs)
    assert len(targets)==5 and all(x>=B for x in targets)
    permutation=[B+g for g in range(len(graph)) if B+g not in targets]+outputs
    index={x:x for x in range(B)};index.update({x:B+i for i,x in enumerate(permutation)})
    normalized=[]
    for old in permutation:
        gate=graph[old-B]
        normalized.append(dict(default=index[sent if gate['default'] in targets else gate['default']],
                               source=index[sent if gate['source'] in targets else gate['source']],
                               take=gate['take']))
    return dict(types=saved['types'],names=saved['names'],graph=normalized,
                outputs=[index[x] for x in outputs])

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser();ap.add_argument('prefix');ap.add_argument('--gates',type=int,required=True)
    ap.add_argument('--copies',type=int,required=True);ap.add_argument('--tag',required=True)
    ap.add_argument('--timeout',type=int,default=1200);ap.add_argument('--proof',action='store_true')
    ap.add_argument('--fix-graph');ap.add_argument('--force-double-consume',action='store_true')
    args=ap.parse_args();start=time.monotonic()
    enc=PhysicalDAG(parse(args.prefix),args.gates,PERMS,args.copies)
    if args.fix_graph:
        saved=normalize_saved(json.loads(Path(args.fix_graph).read_text()));enc.fix_graph(saved)
        if args.force_double_consume:
            users={}
            for g,gate in enumerate(saved['graph']):
                d,s=gate['default'],gate['source']
                if d==s:continue
                for x in (d,s):
                    if x!=enc.sentinel:users.setdefault(x,[]).append((g,1 if x==min(d,s) else 2))
            x=next(x for x,ls in users.items() if len(ls)>=2)
            for g,side in users[x][:2]:enc.cl(enc.action[g][side])
    print(json.dumps(dict(event='ENC',gates=args.gates,copies=args.copies,base=enc.B,
                         fixed_graph=bool(args.fix_graph),double_consume=args.force_double_consume,
                         types=len(PERMS),variables=enc.nv,clauses=len(enc.cs),
                         encode_seconds=round(time.monotonic()-start,3))),flush=True)
    tag=ROOT/'round6/logs'/args.tag
    status,model,elapsed=solve(enc,tag,args.timeout,1,'kissat',args.proof)
    print(json.dumps(dict(event='RESULT',result=status,solve_seconds=elapsed,
                         peak_self_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                         peak_child_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)),flush=True)
    if status=='SATISFIABLE':
        checked=enc.check_physical(model)
        Path(str(tag)+'.graph.json').write_text(json.dumps(checked,indent=2)+'\n')
        print('INDEPENDENT_PHYSICAL_DAG_CHECK PASS',len(checked['graph']),flush=True)
    if args.force_double_consume:assert status=='UNSATISFIABLE'
    elif args.fix_graph:assert status=='SATISFIABLE'

if __name__=='__main__':main()
