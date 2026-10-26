from pathlib import Path
import itertools,json
source=Path("round5/candidates/macro9one_sort_813.s")
program=[];names={f"P{i}":i for i in range(5)}
for line in source.read_text().splitlines():
 line=line.split("#")[0].strip()
 if not line or line.startswith("out"):continue
 op,d,s=line.replace(",","").split()
 for x in (d,s):
  if x not in names:names[x]=len(names)
 program.append((op,names[d],names[s]))
def run(case):
 r=list(case)+[None]*(len(names)-5);f=None;cols=[]
 for op,d,s in program:
  if op=="cmp":cols.append((r[d],r[s]));f=(r[d]>r[s])-(r[d]<r[s])
  elif op=="mov":r[d]=r[s]
  elif (op=="cmovg" and f>0)or(op=="cmovge" and f>=0)or(op=="cmovl" and f<0)or(op=="cmovle" and f<=0):r[d]=r[s]
 return cols
perms=list(itertools.permutations(range(5)));cols=[run(x) for x in perms]
lines=["# New nine-comparison conditional-transposition skeleton, strict permutations"]
for j in range(9):lines.append(":".join("="+"".join(str(row[j][side]) for row in cols) for side in range(2)))
Path("round5/artifacts/macro9one.skel").write_text("\n".join(lines)+"\n")
# Explicit monotonicity check on the complete finite 0..4 grid.
# A failure disproves that the operand is a min/max expression.
values={x:run(x) for x in itertools.product(range(5),repeat=5)}
witness=None
for x,columns in values.items():
 for i in range(5):
  if x[i]==4:continue
  y=list(x);y[i]+=1;y=tuple(y)
  for j in range(9):
   for side in range(2):
    if columns[j][side]>values[y][j][side]:witness={"comparison":j,"side":side,"input":x,"increased_input":y,"before":columns[j][side],"after":values[y][j][side]};break
   if witness:break
  if witness:break
 if witness:break
Path("round5/artifacts/macro9one_nonmonotone.json").write_text(json.dumps(witness,indent=2))
print(json.dumps(witness))
