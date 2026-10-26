from pathlib import Path
import itertools,json
source=Path("round5/candidates/fresh31_near.s");lines=[];registers=set()
for line in source.read_text().splitlines():
 s=line.split("#")[0].strip()
 if not s:continue
 op,d,v=s.replace(",","").split();lines.append((op,d,v));registers.add(v)
 if op!="out":registers.add(d)
def run(case):
 r={name:7 for name in registers};r.update({f"P{i}":case[i] for i in range(5)});f=0;out=[None]*5
 for op,d,v in lines:
  if op=="out":out[int(d)]=r[v]
  elif op=="cmp":f=(r[d]>r[v])-(r[d]<r[v])
  elif op=="mov":r[d]=r[v]
  elif(op=="cmovl" and f<0)or(op=="cmovle" and f<=0)or(op=="cmovg" and f>0)or(op=="cmovge" and f>=0):r[d]=r[v]
 return out
cases=[x for x in itertools.product(range(5),repeat=5) if set(x)==set(range(max(x)+1))];failed=[];mismatch=[]
for x in cases:
 out=run(x);bad=out!=sorted(x);pred=x[1]>max(x[0],x[3]) and min(x[2],x[4])>x[1]
 if bad!=pred:mismatch.append(x)
 if bad:failed.append({"input":x,"actual":out,"expected":sorted(x),"positions":[i for i in range(5) if out[i]!=sorted(x)[i]]})
row={"cases":len(cases),"scratch":7,"initial_flags":"eq","failed":len(failed),"strict_failures":sum(len(set(x["input"]))==5 for x in failed),"predicate_mismatches":mismatch,"failures":failed}
Path("round5/artifacts/near9_analysis.json").write_text(json.dumps(row,indent=2));print(json.dumps(row),flush=True)
assert len(failed)==9 and not mismatch and all(x["positions"]==[2] for x in failed)
text=source.read_text().replace("k=31 weak_fail=9 weak_error_sum=9","k=32 repaired_max_copy")
assert text.count("cmp S1, S2\n")==1
text=text.replace("cmp S1, S2\n","cmp S1, S2\ncmovl P0, S1\n")
Path("round5/candidates/near9_repair32.s").write_text(text)
