// Exact sub-comparator copy routing. Full terms after every cmov.
// All four I1 conditions, either output first, arbitrary live destinations and sources.
// A paid copy uses a fresh register. Register names have no semantic effect.
#include <bits/stdc++.h>
#include <omp.h>
using namespace std;
using U=uint32_t; using Key=__uint128_t;
struct KH { size_t operator()(Key k) const { uint64_t a=k,b=k>>64; a^=b*0x9e3779b97f4a7c15ULL; a^=a>>30; a*=0xbf58476d1ce4e5b9ULL; return a^(a>>27); } };
using Layer=unordered_map<Key,uint8_t,KH>;
struct Gate { int t; U src[23]{}; int cond[23][23]{}; };
struct Block { int a,b; Gate g[2]; U need=0; };
struct Problem {
  vector<U> terms; vector<array<int,5>> weak;
  vector<vector<uint8_t>> vals;
  Block blk[9]; Key bits[23]; int cap; uint64_t states=0,peak=0;
  vector<pair<U,U>> seq;
  vector<Layer> history;
  Problem(vector<pair<U,U>> sq,int q):cap(q),seq(sq) {
    for(int i=0;i<5;i++) { U t=0; for(int s=0;s<32;s++) if(s>>i&1)t|=1u<<s; terms.push_back(t); }
    for(auto [a,b]:seq) for(U t:{a&b,a|b}) if(find(terms.begin(),terms.end(),t)==terms.end())terms.push_back(t);
    assert(terms.size()==23);
    for(int i=0;i<23;i++)bits[i]=Key(1)<<(4*i);
    for(int code=0;code<3125;code++) { int n=code;array<int,5>w;int mask=0;for(auto &v:w){v=n%5;n/=5;mask|=1<<v;} if((mask&(mask+1))==0)weak.push_back(w); }
    assert(weak.size()==541);
    for(U t:terms) {
      vector<uint8_t> v;
      for(auto w:weak) { int out=0;for(int level=1;level<=4;level++){int s=0;for(int i=0;i<5;i++)if(w[i]>=level)s|=1<<i;if(t>>s&1)out=level;}v.push_back(out); }
      vals.push_back(v);
    }
    auto id=[&](U t){return find(terms.begin(),terms.end(),t)-terms.begin();};
    for(int j=0;j<9;j++) {
      auto &[a,b,g,need]=blk[j]; a=id(seq[j].first);b=id(seq[j].second);
      g[0].t=id(seq[j].first&seq[j].second);g[1].t=id(seq[j].first|seq[j].second);
      for(auto &gg:g) for(int c=0;c<4;c++) {
        U ds=0,ss=0;
        for(int d=0;d<23;d++) {
          bool dok=true,sok=true;
          for(int w=0;w<541;w++) {int f=(vals[a][w]>vals[b][w])-(vals[a][w]<vals[b][w]);bool take=c==0?f<0:c==1?f<=0:c==2?f>0:f>=0;
            if(vals[d][w]!=vals[gg.t][w]){if(take)sok=false;else dok=false;}
          }
          if(dok)ds|=1u<<d;if(sok)ss|=1u<<d;
        }
        for(int d=0;d<23;d++)if(ds>>d&1){gg.src[d]|=ss;for(int s=0;s<23;s++)if(ss>>s&1)gg.cond[d][s]=c;}
      }
      for(int k=j+1;k<9;k++)need|=(1u<<id(seq[k].first))|(1u<<id(seq[k].second));
    }
  }
  U present(Key k) const {U m=0;for(int i=0;i<23;i++)if((k>>(4*i))&15)m|=1u<<i;return m;}
  void push(Layer &l,Key k,int q) {auto [it,fresh]=l.emplace(k,q);if(!fresh && q<it->second)it->second=q;}
  Layer step(const Layer &from,Gate const &g,U need) {
    Layer to;
    for(auto [key,q]:from) {
      U have=present(key); bool feasible=false;
      for(U m=have;m;m&=m-1){int d=__builtin_ctz(m);if(!(g.src[d]&have))continue;feasible=true;
        Key n=key-bits[d]+bits[g.t];if((present(n)&need)==need)push(to,n,q);
      }
      if(feasible && q<cap){Key n=key+bits[g.t];if((present(n)&need)==need)push(to,n,q+1);}
    }
    states+=to.size();peak=max<uint64_t>(peak,to.size());return to;
  }
  int solve(bool trace=false) {
    Layer layer;Key initial=0;for(int i=0;i<5;i++)initial+=bits[i];layer[initial]=0;
    if(trace)history.push_back(layer);
    U made=31;
    for(int j=0;j<9;j++) {
      Layer next;
      for(int order=0;order<2;order++) {
        Gate const &g0=blk[j].g[order],&g1=blk[j].g[1-order];
        U need=blk[j].need&made;
        Layer mid=step(layer,g0,need);
        Layer end=step(mid,g1,need|(blk[j].need&(1u<<g0.t)));
        for(auto [key,q]:end)push(next,key,q);
      }
      layer.swap(next); made|=(1u<<blk[j].g[0].t)|(1u<<blk[j].g[1].t);
      if(trace)history.push_back(layer);
      // No term is produced twice. Each future cmp operand must remain present.
      if(layer.empty())return -1;
    }
    int best=99;for(auto [key,q]:layer)best=min(best,int(q));return best;
  }
  struct Choice { int d,s,c,t;bool paid; };
  vector<pair<pair<Key,int>,Choice>> choices(Key key,int q,Gate const &g) {
    vector<pair<pair<Key,int>,Choice>> v;U have=present(key);bool paid=false;
    for(U m=have;m;m&=m-1){int d=__builtin_ctz(m);U sources=g.src[d]&have;if(!sources)continue;int s=__builtin_ctz(sources);int c=g.cond[d][s];
      v.push_back({{key-bits[d]+bits[g.t],q},{d,s,c,g.t,false}});
      if(q<cap && !paid){v.push_back({{key+bits[g.t],q+1},{d,s,c,g.t,true}});paid=true;}
    }
    return v;
  }
  void emit(string path,int best) {
    Key current=0;for(auto [key,q]:history[9])if(q==best){current=key;break;}
    vector<array<Choice,2>> plan(9);int cost=best;
    for(int j=8;j>=0;j--) {
      bool found=false;
      for(auto [prev,q]:history[j]) {
        for(int o=0;o<2 && !found;o++)for(auto [mid,c0]:choices(prev,q,blk[j].g[o])) {
          for(auto [end,c1]:choices(mid.first,mid.second,blk[j].g[1-o])) if(end.first==current && end.second==cost) {
            plan[j]={c0,c1};current=prev;cost=q;found=true;break;
          }
          if(found)break;
        }
        if(found)break;
      }
      assert(found);
    }
    vector<int> regs={0,1,2,3,4};ofstream f(path);
    auto rn=[](int r){return r<5?"P"+to_string(r):"S"+to_string(r-5);};
    auto reg=[&](int t){auto it=find(regs.begin(),regs.end(),t);assert(it!=regs.end());return int(it-regs.begin());};
    f<<"# n=5 R="<<5+best<<" iset=I1 model=out source=w1_exhaustive_copy_reuse\n";
    const char *cn[]={"cmovl","cmovle","cmovg","cmovge"};int outmask=0;
    for(int j=0;j<9;j++) {
      f<<"cmp "<<rn(reg(blk[j].a))<<", "<<rn(reg(blk[j].b))<<"\n";
      for(auto c:plan[j]) {
        int d=reg(c.d),s=reg(c.s);
        if(c.paid){int fresh=regs.size();regs.push_back(c.d);f<<"mov "<<rn(fresh)<<", "<<rn(d)<<"\n";d=fresh;}
        f<<cn[c.c]<<" "<<rn(d)<<", "<<rn(s)<<"\n";regs[d]=c.t;
        for(int k=0;k<5;k++){U t=0;for(int s=0;s<32;s++)if(__builtin_popcount((unsigned)s)>=5-k)t|=1u<<s;
          if(terms[c.t]==t && !(outmask>>k&1)){f<<"out "<<k<<", "<<rn(d)<<"\n";outmask|=1<<k;}}
      }
    }
    assert(outmask==31);
  }
};
int main(int argc,char**argv) {
  string fname=argc>1?argv[1]:"networks.txt";int cap=argc>2?atoi(argv[2]):4;
  int limit=argc>3?atoi(argv[3]):INT_MAX,threads=argc>4?atoi(argv[4]):1;
  ifstream f(fname);string line;vector<vector<pair<U,U>>> all;
  while(getline(f,line) && (int)all.size()<limit){istringstream s(line);string p;vector<pair<U,U>>sq;while(s>>p){auto i=p.find(':');sq.push_back({stoul(p.substr(0,i),0,16),stoul(p.substr(i+1),0,16)});}assert(sq.size()==9);all.push_back(sq);}
  if(argc>5){int index=atoi(argv[5]);Problem p(all.at(index),cap);int best=p.solve(true);assert(best>=0);p.emit("witness_out.s",best);cout<<"emitted index="<<index<<" moves="<<best<<endl;return 0;}
  omp_set_num_threads(threads);vector<int> results(all.size());uint64_t totalstates=0,peak=0;int complete=0;
  auto start=chrono::steady_clock::now();
#pragma omp parallel for schedule(dynamic,1)
  for(int i=0;i<(int)all.size();i++) {
    Problem p(all[i],cap);int ans=p.solve();results[i]=ans;
#pragma omp critical
    {
      totalstates+=p.states;peak=max(peak,p.peak);++complete;
      if(ans>=0 || complete%100==0)cerr<<"done="<<complete<<" index="<<i<<" min_moves="<<ans<<" states="<<totalstates<<" peak="<<peak<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<endl;
    }
  }
  map<int,int> hist;for(int v:results)hist[v]++;
  for(auto [v,n]:hist)cout<<"min_moves="<<v<<" networks="<<n<<" cap="<<cap<<"\n";
  cout<<"states="<<totalstates<<" peak="<<peak<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<endl;
  ofstream rf("reuse_results_q"+to_string(cap)+".txt");for(int i=0;i<(int)results.size();i++)rf<<i<<" "<<results[i]<<"\n";
}
