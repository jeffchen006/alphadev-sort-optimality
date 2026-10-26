#include <bits/stdc++.h>
using namespace std;
using U = uint32_t;
using State = array<U,5>;
struct Hash { size_t operator()(State const &a) const { size_t h=0; for(U x:a) h=(h^x)*0x9e3779b97f4a7c15ULL; return h; } };
struct Edge { int to; U a,b; };
struct Node { State ch; vector<Edge> e; uint64_t paths=0, suffix=0; };
vector<Node> lev[10];
array<pair<U,U>,9> seq;
map<array<pair<U,U>,9>,uint64_t> dags;
uint64_t emitted=0;
FILE *out;
void emit(int d,int n) {
  if(d==9) {
    auto key=seq; sort(key.begin(),key.end()); dags[key]++;
    for(auto [a,b]:seq) fprintf(out,"%08x:%08x ",a,b);
    fprintf(out,"\n"); ++emitted; return;
  }
  for(auto e:lev[d][n].e) if(lev[d+1][e.to].suffix) { seq[d]={e.a,e.b}; emit(d+1,e.to); }
}
int main(int argc,char**argv) {
  string prefix=argc>1?argv[1]:"networks";
  State x{},target{};
  for(int i=0;i<5;i++) for(int s=0;s<32;s++) if(s>>i&1) x[i]|=1u<<s;
  for(int j=0;j<5;j++) for(int s=0;s<32;s++) if(__builtin_popcount((unsigned)s)>=5-j) target[j]|=1u<<s;
  sort(x.begin(),x.end()); sort(target.begin(),target.end());
  lev[0].push_back({x,{},1,0});
  for(int d=0;d<9;d++) {
    unordered_map<State,int,Hash> ids;
    for(auto &node:lev[d]) for(int i=0;i<5;i++) for(int j=i+1;j<5;j++) {
      // Input labels are symmetric; select the first pair only at depth zero.
      if(d==0 && !(i==0 && j==1)) continue;
      U a=node.ch[i],b=node.ch[j],mn=a&b,mx=a|b;
      if(mn==a || mn==b) continue; // redundant comparator, impossible in an optimal nine-comparator network
      State ch=node.ch; ch[i]=mn; ch[j]=mx; sort(ch.begin(),ch.end());
      auto [it,fresh]=ids.emplace(ch,lev[d+1].size());
      if(fresh) lev[d+1].push_back({ch,{},0,0});
      lev[d+1][it->second].paths+=node.paths;
      node.e.push_back({it->second,min(a,b),max(a,b)});
    }
    uint64_t paths=0,edges=0,sorted_paths=0; for(auto &n:lev[d+1]) {paths+=n.paths;if(n.ch==target)sorted_paths+=n.paths;}
    for(auto &n:lev[d]) edges+=n.e.size();
    cout<<"depth="<<d+1<<" channel_states="<<lev[d+1].size()<<" incoming_edges="<<edges<<" prefix_sequences="<<paths<<" sorting_sequences="<<sorted_paths<<endl;
  }
  uint64_t wins=0;
  for(auto &n:lev[9]) if(n.ch==target) { n.suffix=1; wins+=n.paths; }
  for(int d=8;d>=0;d--) {
    uint64_t good=0,edges=0;
    for(auto &n:lev[d]) { for(auto e:n.e) if(lev[d+1][e.to].suffix) { n.suffix+=lev[d+1][e.to].suffix; edges++; } if(n.suffix) good++; }
    cout<<"viable_depth="<<d<<" channel_states="<<good<<" outgoing_edges="<<edges<<endl;
  }
  out=fopen((prefix+".txt").c_str(),"w"); emit(0,0); fclose(out);
  assert(wins==emitted && wins==lev[0][0].suffix);
  ofstream df(prefix+"_dags.txt");
  for(auto &[key,count]:dags) { df<<count; for(auto [a,b]:key) df<<" "<<hex<<setw(8)<<setfill('0')<<a<<":"<<setw(8)<<b<<dec; df<<"\n"; }
  cout<<"sorting_sequences_first_pair_fixed="<<wins<<" all_first_pairs="<<10*wins<<" distinct_comparator_DAGs_first_pair_fixed="<<dags.size()<<endl;
}
