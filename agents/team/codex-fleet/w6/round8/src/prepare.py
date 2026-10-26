"""Prepare private copies. Keep every prior search artifact unchanged."""
from pathlib import Path
import json

s = Path('round7/src/window.py').read_text()
s = s.replace("str(HERE/'round3/src'),", "str(HERE/'round7/src'), str(HERE/'round3/src'),")
s = s.replace("for previous in Path('round7/logs').glob('*_'+seed_match.group(1)+'_w*.log'):",
              "for previous in list(Path('round7/logs').glob('*_'+seed_match.group(1)+'_w*.log')) + list(Path('round8/logs').glob('*_'+seed_match.group(1)+'_w*.log')):")
Path('round8/src/window.py').write_text(s)
s = Path('round7/src/verify.py').read_text().replace('round7/', 'round8/').replace('w6-round7', 'w6-round8')
Path('round8/src/verify.py').write_text(s)

s = Path('round3/src/union.cpp').read_text()
s = s.replace('#include <sys/resource.h>', '#include <sys/resource.h>\n#include <csignal>\nstatic volatile sig_atomic_t stopping;\nstatic void stopped(int){stopping=1;}')
s = s.replace('uint64_t errors[5][9]{};', 'uint64_t errors[5][9]{}; array<int,5> bt,br;')
s = s.replace('inline void score_update(Snap&x,int r)', 'inline void score_update(Snap&x,int r,int t=-1)')
s = s.replace('if(take){x.best[j]=e;', 'if(take){x.bt[j]=t;x.br[j]=r;x.best[j]=e;')
s = s.replace('inline void step(Snap&x,I i){', 'inline void step(Snap&x,I i,int t=-1){')
s = s.replace('score_update(x,i.d);', 'score_update(x,i.d,t);')
a=s.index('void emitnear('); b=s.index('double cpu()',a)
s=s[:a]+'''void emitnear(const vector<I>&p,string path){
  Snap x; x.st=sm.init;x.best.fill(541);x.bt.fill(-1);x.br.fill(0);
  for(int j=0;j<5;j++)for(int w=0;w<9;w++)x.errors[j][w]=sm.mask[w];
  for(int r=0;r<nr;r++)score_update(x,r,-1);
  for(int t=0;t<(int)p.size();t++)if(p[t].o>=0)step(x,p[t],t);
  int k=0;for(auto i:p)k+=i.o>=0;
  ofstream out(path);out<<"# n=5 model=out iset=I1 source=w6-round8 k="<<k
    <<" weak_fail="<<weakfail(x)<<" weak_error_sum="<<cost(x)<<"\\n";
  for(int j=0;j<5;j++)if(x.bt[j]==-1)out<<"out "<<j<<", "<<reg(x.br[j])<<"\\n";
  for(int t=0;t<(int)p.size();t++){
    auto i=p[t];if(i.o>=0)out<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\\n";
    for(int j=0;j<5;j++)if(x.bt[j]==t)out<<"out "<<j<<", "<<reg(x.br[j])<<"\\n";
  }
  cerr<<"NEAR weak_fail="<<weakfail(x)<<" weak_error_sum="<<cost(x)<<" file="<<path<<"\\n";
}
''' + s[b:]
s=s.replace('int main(int argc,char**argv){', 'int main(int argc,char**argv){\n  signal(SIGTERM,stopped);')
s=s.replace('nr=used+1;', 'nr=used+2; assert(nr<=24);')
s=s.replace('Snap initial;initial.st=sm.init;', 'Snap initial;initial.st=sm.init;initial.bt.fill(-1);initial.br.fill(0);')
s=s.replace('step(snap[i+1],cur[i]);', 'step(snap[i+1],cur[i],i);')
s=s.replace('f+=0.15*e+0.0005*e*e;', 'f+=0.0001*e;')
s=s.replace('cpu()-begun>limit)', '(cpu()-begun>limit||stopping))')
s=s.replace('iterations%10000000==0', 'iterations%2000000==0')
s=s.replace('step(x,prop[k]);', 'step(x,prop[k],k);')
s=s.replace('double begun=cpu();', 'set<uint64_t> lowseen; unsigned lowfiles=0;\n  double begun=cpu();\n  cerr<<"INITIAL weak_fail="<<bestfail<<" error_sum="<<besterr<<" registers="<<nr<<" temperature="<<temp<<"\\n";')
needle='    if(!e){valid++;'
s=s.replace(needle, '''    if(weakfail(snap[slots])<=6 && lowfiles<3000 && lowseen.insert(statehash(cur)).second){
      emitnear(cur,prefix+"_le6_"+to_string(++lowfiles)+".s");
    }
''' + needle)
s=s.replace('<<" best_error="<<besterr', '<<" best_fail="<<bestfail<<" lowfiles="<<lowfiles<<" best_error="<<besterr')
Path('round8/src/failure_search.cpp').write_text(s)

rows=json.loads(Path('round7/artifacts/query_ledger.json').read_text())+json.loads(Path('round7/artifacts/refined_ledger.json').read_text())
ranked=[]
for r in rows:
    if r['status']!='UNKNOWN':continue
    events=[]
    for line in Path(r['log']).read_text().splitlines():
        try:e=json.loads(line)
        except ValueError:continue
        if e.get('step')=='solve':events.append(e)
    assert events,r
    r=dict(r,last_variables=events[-1]['variables'],last_clauses=events[-1]['clauses'])
    ranked.append(r)
ranked.sort(key=lambda r:(r['last_clauses'],r['last_variables'],r['name']))
Path('round8/artifacts/smallest40_plan.json').write_text(json.dumps(ranked[:40],indent=2))
print(json.dumps(dict(unknown=len(ranked),chosen=40,first=ranked[0]['name'],last=ranked[39]['name'])))
