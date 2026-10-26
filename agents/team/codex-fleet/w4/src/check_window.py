#!/usr/bin/env python3
import sys,itertools,z3
sys.path.insert(0,'src');import window
p,o,n=window.read('candidates/seed33.s');n.append('S100');w=window.Window(p,o,n,15,33,delta=0)
for t,(op,a,b) in enumerate(p[15:]):
 oo,dd,ss=w.choices[t];w.sol.add(oo[window.OPS.index(op)],dd[n.index(a)],ss[n.index(b)])
for t,outs in o.items():
 if t<=15:continue
 for j,r in outs:
  if j!=2:w.sol.add(w.snap[j][(t-15)*len(n)+n.index(r)])
types=[t for t in itertools.product(range(5),repeat=5) if set(t)==set(range(max(t)+1))];w.batch(types)
w.sol.push();w.sol.add(w.snap[2][18*len(n)+n.index('P2')]);status=w.sol.check();print('forced correct seed, all 541 weak orders:',status,flush=True);assert status==z3.sat;w.sol.pop()
w.sol.push();w.sol.add(w.snap[2][18*len(n)+n.index('P0')]);status=w.sol.check();print('forced wrong median output, all 541 weak orders:',status,flush=True);assert status==z3.unsat;w.sol.pop()
