"""Use one CPU slot for an ordered set of bounded repair queries."""
import argparse
import json
from pathlib import Path
import subprocess

ap = argparse.ArgumentParser()
ap.add_argument('group', choices=['near','zero','enumerate','neighbours','rank_extra','union'])
a = ap.parse_args()
records = []
def run(seconds, name, command):
    subprocess.run(['python3','-B','round3/src/run.py',str(seconds),name,*command],check=True)
    row = json.loads(Path('round3/artifacts',name+'.json').read_text())
    records.append(row)
    Path('round3/artifacts',a.group+'_batch.json').write_text(json.dumps(records,indent=2))
    return row

def sat(seed, name, seconds=120, extra=()):
    target = f'round3/candidates/{name}.s'
    run(seconds,name,['python3','-B','round3/src/satrep.py',str(seed),target,*extra])
    if Path(target).exists():
        row = run(30,name+'_judge',['python3','-B',
            '/path/to/repo/shared/judge.py',
            target,'--strict','--model','out'])
        if row['exit'] == 0 and 'PASS ' in Path(row['log']).read_text():
            Path('round3/artifacts/FOUND_PENDING').write_text(target+'\n')
            raise SystemExit(0)

if a.group == 'near':
    seed = 'round2/candidates/near14_frozen.s'
    for name,sec,extra in [
        ('near14_typed6',180,['--typed','--fixed-dest','--changes','6','--change-cmp']),
        ('near14_free_dest4',150,['--typed','--changes','4','--change-cmp','--random-seed','8303']),
        ('near14_full5',180,['--changes','5','--change-cmp','--random-seed','8304']),
        ('near14_typed8',150,['--typed','--fixed-dest','--changes','8','--change-cmp','--random-seed','8305']),
    ]:
        sat(seed,name,sec,extra)
elif a.group == 'enumerate':
    run(90,'near14_scoreone',['./round3/neighbours','round2/candidates/near14_frozen.s',
                            'round3/candidates/n14','scoreone'])
    for seed in sorted(Path('round3/candidates').glob('nomov_*.s')):
        run(20,seed.stem+'_deletions',['./round3/neighbours',str(seed),
            'round3/candidates/'+seed.stem,'delete'])
    run(240,'near14_two',['./round3/neighbours','round2/candidates/near14_frozen.s',
                         'round3/candidates/n14','two'])
elif a.group == 'zero':
    # The internal no-op search chooses which conditional move to delete.
    for n,seed in enumerate(sorted(Path('round3/candidates').glob('nomov_*.s'))):
        if '_del' in seed.stem:
            continue
        name = f'zero{n}_sources5'
        run(90,name,['python3','-B','round2/src/source_slots_sat.py',str(seed),
                    f'round3/candidates/{name}.s','--changes','5','--prefix','0'])
        target = Path(f'round3/candidates/{name}.s')
        if target.exists():
            run(30,name+'_judge',['python3','-B',
                '/path/to/repo/shared/judge.py',
                str(target),'--strict','--model','out'])
elif a.group == 'neighbours':
    seeds = sorted(Path('round3/candidates').glob('n14_neighbour*.s'))
    for n,seed in enumerate(seeds[1:],1):
        sat(seed,f'neighbour{n}_rank6',90,
            ['--rank','--typed','--fixed-dest','--changes','6','--change-cmp',
             '--random-seed',str(8400+n)])
elif a.group == 'rank_extra':
    near = 'round2/candidates/near14_frozen.s'
    for name,seed,sec,extra in [
        ('rank_near14_full4',near,150,['--changes','4','--change-cmp']),
        ('rank_near14_fresh5',near,150,['--typed','--fixed-dest','--fresh','1','--changes','5','--change-cmp']),
        ('rank_near14_merge16',near,150,['--typed','--prefix','15','--changes','0','--change-cmp']),
        ('rank_del27_typed7','round3/candidates/nomov_4c02da04dce39b74_del27.s',150,
         ['--typed','--fixed-dest','--changes','7','--change-cmp']),
        ('rank_del27_full5','round3/candidates/nomov_4c02da04dce39b74_del27.s',120,
         ['--changes','5','--change-cmp']),
    ]:
        sat(seed,name,sec,['--rank',*extra])
else:
    run(15,'near14_analysis',['python3','-B','round3/src/near_analysis.py'])
    row = run(35,'union_build',['g++','-O3','-march=native','-std=c++17',
                               'round3/src/union.cpp','-o','round3/union'])
    assert row['exit'] == 0
    run(300,'union31',['./round3/union','round2/candidates/near14_frozen.s',
                      'round3/candidates/union31','31','0.7','1.5','180','8821','9','0'])
    for path in sorted(Path('round3/candidates').glob('union31*.s')):
        row = run(30,path.stem+'_judge',['python3','-B',
            '/path/to/repo/shared/judge.py',
            str(path),'--strict','--model','out'])
        if row['exit'] == 0 and 'PASS ' in Path(row['log']).read_text():
            Path('round3/artifacts/FOUND_PENDING').write_text(str(path)+'\n')
            raise SystemExit(0)
