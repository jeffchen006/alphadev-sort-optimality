import itertools,json,subprocess,sys
from analyse import *
manifest=[];judge=[]
for i,j in [(0,1),(0,2),(1,2)]:
    k=next(x for x in range(3) if x not in (i,j))
    for reverse in [False,True]:
        p=['cmp P4, P3','mov S2, P4','cmovle S2, P3','cmovl P3, P4',f'mov S0, P{k}',f'cmp P{i}, P{j}',f'mov S4, P{j}']
        if not reverse:
            p += [f'cmovge P{j}, P{i}',f'cmovl S4, P{i}','cmp S4, S0','cmovg S0, S4',f'cmovge S4, P{k}',f'cmp P{k}, P{j}',f'cmovle P{k}, P{j}',f'cmovg S0, P{j}']
            A='S4';C=f'P{k}'
        else:
            p += [f'cmovle P{j}, P{i}',f'cmovg S4, P{i}','cmp S4, S0','cmovl S0, S4',f'cmovle S4, P{k}',f'cmp P{k}, P{j}',f'cmovge P{k}, P{j}',f'cmovl S0, P{j}']
            A=f'P{k}';C='S4'
        B='S0';D='P3';E='S2';F='S6';tmp=f'P{j}'
        p += [f'mov {F}, {E}',f'cmp {A}, {D}',f'cmovl {tmp}, {A}',f'cmovge {tmp}, {D}',f'out 0, {tmp}',f'cmovle {A}, {D}',f'cmp {F}, {C}',f'cmovg {F}, {A}',f'cmovg {A}, {B}',f'cmovl {E}, {C}',f'out 4, {E}',f'cmovle {C}, {B}',f'cmp {C}, {F}',f'cmovge {B}, {F}',f'cmovge {F}, {C}',f'out 3, {F}',f'cmovg {C}, {B}',f'cmp {B}, {A}',f'cmovg {B}, {A}',f'out 1, {B}',f'cmovge {A}, {C}',f'out 2, {A}']
        for dual in [False,True]:
            q=[]
            for ins in p:
                o,args=ins.split(None,1)
                if dual:
                    o={'cmovl':'cmovg','cmovg':'cmovl','cmovle':'cmovge','cmovge':'cmovle'}.get(o,o)
                    if o=='out':a,b=map(str.strip,args.split(','));args=f'{4-int(a)}, {b}'
                q.append(o+' '+args)
            tag=f's3_{i}{j}_'+('hi' if reverse else 'lo')+('_dual' if dual else '')
            fn=DIR/(tag+'.s');fn.write_text('# n=5 iset=I1 model=out len=32 source=d7 sort3_variants\n'+'\n'.join(q)+'\n')
            r=subprocess.run([sys.executable,'/path/to/repo/shared/judge.py',str(fn),'--strict','--model','out'],capture_output=True,text=True)
            judge.append(dict(file=str(fn.relative_to(ROOT)),rc=r.returncode,result=r.stdout+r.stderr))
            if r.returncode:print('FAIL',tag,r.stdout,r.stderr);continue
            pool,rows=trace(q);pf=DIR/f'pool_{tag}.txt';writepool(pf,pool)
            manifest.append(dict(id=tag,idea='Sort3 uses another initial pair / upper-first / reversed merge',file=str(pf.relative_to(ROOT)),size=len(pool),program=str(fn.relative_to(ROOT))))
(DIR/'variants_manifest.json').write_text(json.dumps(manifest,indent=2));(DIR/'variants_judge.json').write_text(json.dumps(judge,indent=2));print('judge PASS',len(manifest),'/',len(judge),flush=True)
