"""Create a known positive delete-two/insert-one control and judge the results."""
import json
from pathlib import Path
HERE=Path(__file__).resolve().parent
row=json.loads((HERE/'manifest.json').read_text())[0]
row['name']='padded33'
row['registers'].append('S990')
row['code'].append([0,len(row['registers'])-1,0])
with (HERE/'control.txt').open('w') as f:
    print(1,file=f)
    print(row['name'],len(row['registers']),len(row['code']),file=f)
    print(*row['registers'],file=f)
    for z in row['code']: print(*z,file=f)
with (HERE/'padded33.s').open('w') as f:
    print('# n=5 model=out iset=I1 source=w1-round4-control k=33',file=f)
    ops=['mov','cmp','cmovl','cmovle','cmovg','cmovge','out']
    for op,d,s in row['code']:
        if op==6: print(f'out {d}, {row["registers"][s]}',file=f)
        else: print(f'{ops[op]} {row["registers"][d]}, {row["registers"][s]}',file=f)
print('CONTROL input core=33, pair index 31 deletes core positions 0 and 32')
