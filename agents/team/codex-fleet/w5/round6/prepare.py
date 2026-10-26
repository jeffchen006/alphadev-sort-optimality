from pathlib import Path
HERE=Path(__file__).resolve().parent
s=(HERE.parent/'round5/src/rewrite.cpp').read_text()
s=s.replace('#include "../../src/search.cpp"','#include "../../src/search.cpp"\n#include <bitset>')
s=s.replace('unsigned have;','unsigned have;uint64_t seen=0;')
s=s.replace('  void update(State&st){','  void update(State&st){for(int r=0;r<nr;r++)st.seen|=1ULL<<st.r[r];')
s=s.replace('    nv=values.size();','    nv=values.size();assert(nv<64);update(trace[0]);')
s=s.replace('key+=char(st.have);','key+=char(st.have);for(int b=0;b<8;b++)key+=char(st.seen>>(8*b));')
s=s.replace('  void accept(const State&st){leaves++;if(st.have!=31)return;',r'''
  vector<array<bitset<541>,5>> errors;
  unordered_map<uint64_t,array<int,5>> scores;
  unordered_set<string> nearprograms;
  uint64_t qualifying=0,retained=0;
  array<int,21> histogram{};
  void prepare_errors(){
    errors.resize(nv);
    for(int v=0;v<nv;v++)for(int j=0;j<5;j++)for(int t=0;t<541;t++)
      if(values[v][t]!=values[goals[j]][t])errors[v][j].set(t);
  }
  bool choose(int j,uint64_t seen,bitset<541> bad,array<int,5>& selected){
    if(j==5)return true;
    vector<int> choices;
    for(int v=0;v<nv;v++)if((seen>>v)&1){
      if((bad|errors[v][j]).count()>20)continue;
      bool dominated=false;
      for(int w:choices)if((errors[w][j]&~errors[v][j]).none()){dominated=true;break;}
      if(dominated)continue;
      choices.erase(remove_if(choices.begin(),choices.end(),[&](int w){return (errors[v][j]&~errors[w][j]).none();}),choices.end());
      choices.push_back(v);
    }
    sort(choices.begin(),choices.end(),[&](int a,int b){return (bad|errors[a][j]).count()<(bad|errors[b][j]).count();});
    for(int v:choices){selected[j]=v;if(choose(j+1,seen,bad|errors[v][j],selected))return true;}
    return false;
  }
  void collect(const State&st){
    if(path.size()!=31)return;
    auto it=scores.find(st.seen);
    if(it==scores.end()){
      array<int,5> selected;selected.fill(-1);
      if(!choose(0,st.seen,{},selected))selected.fill(-1);
      it=scores.emplace(st.seen,selected).first;
    }
    auto selected=it->second;if(selected[0]<0)return;
    qualifying++;
    string key;for(auto x:path)for(int z:{x.o,x.d,x.s})key+=char(z);
    if(!nearprograms.insert(key).second)return;
    bitset<541> bad;for(int j=0;j<5;j++)bad|=errors[selected[j]][j];histogram[bad.count()]++;
    string fn=out+"_near"+to_string(retained++)+".s";
    ofstream f(fn);f<<"# n=5 R="<<nr<<" model=out iset=I1 source=w5-round6 k=31 failures="<<bad.count()<<"\n";
    State cur=trace[0];array<int,5> when,reg;when.fill(-2);
    auto record=[&](int t){for(int j=0;j<5;j++)if(when[j]==-2)for(int r=0;r<nr;r++)if(cur.r[r]==selected[j]){when[j]=t;reg[j]=r;break;}};
    record(-1);
    for(int t=0;t<(int)path.size();t++){auto x=path[t];if(x.o==CMP)cur.f=pairflag[cur.r[x.d]*nv+cur.r[x.s]];else cur.r[x.d]=sel(cur.f,cur.r[x.d],cur.r[x.s],x.o);record(t);}
    for(int j=0;j<5;j++)if(when[j]==-1)f<<"out "<<j<<", "<<regname(reg[j])<<"\n";
    for(int t=0;t<(int)path.size();t++){auto x=path[t];f<<names[x.o]<<" "<<regname(x.d)<<", "<<regname(x.s)<<"\n";for(int j=0;j<5;j++)if(when[j]==t)f<<"out "<<j<<", "<<regname(reg[j])<<"\n";}
    for(int j=0;j<5;j++)assert(when[j]!=-2);
  }
  void accept(const State&st){leaves++;collect(st);if(st.have!=31)return;''')
s=s.replace('r.audit(audit,index);r.run(nd,ni);','r.prepare_errors();r.audit(audit,index);r.run(nd,ni);printf("NEAR index=%d qualifying=%llu retained=%llu seenhist=%zu hist=",index,(unsigned long long)r.qualifying,(unsigned long long)r.retained,r.scores.size());for(int j=0;j<=20;j++)printf("%s%d:%d",j?",":"",j,r.histogram[j]);printf("\\n");')
(HERE/'src/collect.cpp').write_text(s)
