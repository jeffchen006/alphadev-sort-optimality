#!/usr/bin/env python3
"""Route a new free-copy candidate skeleton at k=31; skip old skeletons."""
import itertools,json,subprocess,sys,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'src'))
from batch_dag import key

def route(path):
    if (ROOT/'RESULTS.md').read_text().startswith('FOUND '):return
    path=Path(path);program=[]
    for line in path.read_text().splitlines():
        if not line or line.startswith('#'):continue
        op,rest=line.split(None,1);d,s=[v.strip() for v in rest.split(',')]
        program.append((op,d,s))
    traces=[]
    for ty in itertools.permutations(range(5)):
        regs={f'P{i}':ty[i] for i in range(5)};flag=0;trace=[]
        for op,d,s in program:
            if op=='out':continue
            if op=='cmp':
                a,b=regs[d],regs[s];trace.append((a,b));flag=(a>b)-(a<b)
            elif op=='mov' or op=='cmovl' and flag<0 or op=='cmovle' and flag<=0 or op=='cmovg' and flag>0 or op=='cmovge' and flag>=0:
                regs[d]=regs[s]
        traces.append(trace)
    directory=ROOT/'round3/sk';directory.mkdir(exist_ok=True)
    sk=directory/(path.stem+'.txt')
    sk.write_text('# free-copy candidate value skeleton\n'+''.join(
        '='+''.join(str(row[j][0]) for row in traces)+':='+''.join(str(row[j][1]) for row in traces)+'\n'
        for j in range(len(traces[0]))))
    sig=key(sk);duplicate=None
    for directory in [ROOT/'sk',ROOT/'round2/sk',ROOT/'round3/sk']:
        for old in directory.rglob('*.txt'):
            if old==sk:continue
            try:same=key(old)==sig
            except (ValueError,IndexError):same=False
            if same:duplicate=old;break
        if duplicate:break
    row=dict(file=str(sk.relative_to(ROOT)),k=31)
    if duplicate:
        row.update(status='DUPLICATE_SKIPPED',matched=str(duplicate.relative_to(ROOT)))
    else:
        log=ROOT/'round3/logs'/(path.stem+'.dagx');start=time.monotonic()
        with log.open('w') as stream:
            q=subprocess.run(['nice','-n','19','timeout','180',str(ROOT/'src/dagx'),str(sk),'31','1','100000000'],stdout=stream,stderr=subprocess.STDOUT)
        rows=log.read_text().splitlines();result=rows[-1] if rows else 'EMPTY'
        row.update(rc=q.returncode,result=result,seconds=round(time.monotonic()-start,3))
        if 'RESULT FOUND ' in result:
            asm=[s for s in rows if s.startswith(('mov ','cmp ','cmovl ','cmovle ','cmovg ','cmovge ','out '))]
            target=ROOT/'round3/programs'/(path.stem+'_dagx.s')
            target.write_text('# n=5 R=100 iset=I1 model=out source=w3_round3_freecopy_skeleton\n'+'\n'.join(asm)+'\n')
            from candidate import check
            check(target)
            row['candidate']=str(target.relative_to(ROOT))
    with (ROOT/'round3/logs/freecopy_routing.jsonl').open('a') as stream:stream.write(json.dumps(row)+'\n')
    print('FREECOPY_SKELETON_ROUTING',json.dumps(row),flush=True)
