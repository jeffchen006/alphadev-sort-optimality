"""Independent parser and scalar simulator for the supplied near miss."""
import itertools, json
from pathlib import Path

def parse(path):
    result=[]
    for line in Path(path).read_text().splitlines():
        words=line.partition('#')[0].replace(',',' ').split()
        if words:result.append(tuple(words))
    return result

def simulate(code,inputs,garbage=9,flags=0):
    names={r for o,d,s in code for r in (d,s) if r.startswith(('P','S'))}
    regs={r:garbage for r in names};regs.update({f'P{i}':v for i,v in enumerate(inputs)})
    output=[None]*5;snapshots=[];comparisons=[];step=0
    for op,d,s in code:
        if op=='out':output[int(d)]=regs[s];continue
        if op=='cmp':
            comparisons.append((step,regs[d],regs[s]));flags=(regs[d]>regs[s])-(regs[d]<regs[s])
        elif op=='mov':regs[d]=regs[s]
        elif {'cmovl':flags<0,'cmovle':flags<=0,'cmovg':flags>0,'cmovge':flags>=0}[op]:regs[d]=regs[s]
        if op!='cmp':snapshots.append((step,d,regs[d]))
        step+=1
    return output,snapshots,comparisons

def memory_version(source,target):
    code=parse(source)
    names=sorted({r for o,d,s in code for r in ((s,) if o=='out' else (d,s))})
    mapping={r:f'S{i}' for i,r in enumerate(names)}
    lines=['# n=5 model=mem iset=I1 source=w7-conversion']
    lines.extend(f'mov {mapping[f"P{i}"]}, P{i}' for i in range(5))
    for op,d,s in code:
        lines.append(f'mov P{d}, {mapping[s]}' if op=='out' else f'{op} {mapping[d]}, {mapping[s]}')
    Path(target).write_text('\n'.join(lines)+'\n')

if __name__=='__main__':
    cases=[x for x in itertools.product(range(5),repeat=5) if set(x)==set(range(max(x)+1))]
    code=parse('seeds/near31.s');failed=[];columns={};cmpcols={};mismatches=[]
    for x in cases:
        output,snapshots,comparisons=simulate(code,x)
        for t,r,v in snapshots:columns.setdefault((t,r),[]).append(v)
        for t,a,b in comparisons:cmpcols.setdefault(t,[]).append((a,b))
        wrong=output!=sorted(x)
        predicate=x[1]>max(x[0],x[3]) and min(x[2],x[4])>x[1]
        if wrong!=predicate:mismatches.append(x)
        if wrong:failed.append({'input':x,'output':output,'goal':sorted(x),'wrong_outputs':[j for j in range(5) if output[j]!=sorted(x)[j]]})
    snapshots=[]
    for (t,r),col in columns.items():
        errors=[sum(v!=sorted(x)[j] for v,x in zip(col,cases)) for j in range(5)]
        snapshots.append({'step':t,'register':r,'errors':errors})
    report={'cases':len(cases),'failed_orders':len(failed),'failed_strict_orders':sum(len(set(y['input']))==5 for y in failed),'predicate':'x1 > max(x0,x3) and min(x2,x4) > x1','predicate_mismatches':mismatches,'failures':failed,'snapshots':snapshots}
    Path('artifacts/near_analysis.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k not in ('snapshots','failures')}))
    strict=list(itertools.permutations(range(5)))
    for seed in ('near31','repair32'):
        code=parse(f'seeds/{seed}.s');rows=[simulate(code,x)[2] for x in strict]
        lines=[]
        for i in range(len(rows[0])):
            lines.append('='+''.join(str(row[i][1]) for row in rows)+':='+''.join(str(row[i][2]) for row in rows))
        Path(f'artifacts/{seed}.skel').write_text('\n'.join(lines)+'\n')
    memory_version('seeds/repair32.s','verified/repair32_mem.s')
