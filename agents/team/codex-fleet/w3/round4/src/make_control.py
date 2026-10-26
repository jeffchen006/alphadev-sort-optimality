from insertion_sat import *
prefix=parse(ROOT/'round4/classes/raw0.s')
rows=[run(prefix,p+(4,)) for p in itertools.permutations(range(4))]
names=sorted(set().union(*(r[0] for r in rows)) - {'P4'})
rankregs=[]
for j in range(4):
 rankregs.append(next(n for n in names if all(row[0][n]==j for row in rows)))
base=[f'{op} {d}, {s}' for op,d,s in prefix if op!='out']
program=['# n=5 model=out iset=I1 source=w3_linear_insertion_control']+base
append=[]
for j,name in enumerate(rankregs):
 append += [f'cmp P4, {name}', f'mov S{100+j}, {name}',f'cmovl S{100+j}, P4', f'out {j}, S{100+j}',f'cmovl P4, {name}']
append += ['out 4, P4']
(ROOT/'round4/programs/linear_control36.s').write_text('\n'.join(program+append)+'\n')
(ROOT/'round4/programs/linear_suffix16.s').write_text('\n'.join(append)+'\n')
print(rankregs)

# Binary insertion control: compare e with b, then with a selected a/c,
# then with d. Select complete output candidates before each flag is lost.
binary=[];nr=120
def select(low,high):
 global nr
 if low==high:return low
 dest=f'S{nr}';nr+=1
 binary.extend([f'mov {dest}, {low}',f'cmovge {dest}, {high}'])
 return dest
binary.append(f'cmp P4, {rankregs[1]}')
pivot=select(rankregs[0],rankregs[2])
orig=rankregs+['P4']
orders=[]
for i in range(5):
 row=list(range(4));row.insert(i,4);orders.append(row)
lo=[select(orig[orders[0][j]],orig[orders[2][j]]) for j in range(5)]
hi=[select(orig[orders[1][j]],orig[orders[3][j]]) for j in range(5)]
binary.append(f'cmp P4, {pivot}')
result=[select(lo[j],hi[j]) for j in range(5)]
for j in range(3):binary.append(f'out {j}, {result[j]}')
binary.append(f'cmp P4, {rankregs[3]}')
r3=select(result[3],rankregs[3]);binary.append(f'out 3, {r3}')
r4=select(rankregs[3],'P4');binary.append(f'out 4, {r4}')
(ROOT/'round4/programs/binary_control49.s').write_text('\n'.join(program+binary)+'\n')
(ROOT/'round4/programs/binary_suffix29.s').write_text('\n'.join(binary)+'\n')
