"""Record the exact cases behind the conservative near-miss score."""
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from window_sat import read,concrete,CASES,GOALS
p,nr = read('round2/candidates/near14_frozen.s')
cols,states = concrete(p,nr-1)
best = [min(cols,key=lambda c:sum(x != y for x,y in zip(c[2],goal))) for goal in GOALS]
fails = []
for t,case in enumerate(CASES):
    actual = [col[t] for _,_,col in best]
    if actual != sorted(case):
        fails.append({'case':case,'actual':actual,'expected':sorted(case),
                      'strict_order':len(set(case)) == 5})
row = {'failed_orders':len(fails),'strict_failed_orders':sum(x['strict_order'] for x in fails),
       'output_errors':[sum(x != y for x,y in zip(col,goal)) for (_,_,col),goal in zip(best,GOALS)],
       'witnesses':[(t,r) for t,r,col in best],'failures':fails}
assert row['failed_orders'] == 14 and sum(row['output_errors']) == 18
predicted = []
for t,case in enumerate(CASES):
    a,b = sorted((case[0],case[4]))
    c,d,e = sorted((case[1],case[2],case[3]))
    if a < c and b > e and case[2] > c:
        predicted.append(case)
assert predicted == [tuple(x['case']) for x in fails]
row['failure_condition'] = 'min(P0,P4) < min(P1,P2,P3) and max(P0,P4) > max(P1,P2,P3) and P2 > min(P1,P2,P3)'
Path('round3/artifacts/near14_analysis.json').write_text(json.dumps(row,indent=2))
print(json.dumps({k:v for k,v in row.items() if k != 'failures'}),flush=True)
