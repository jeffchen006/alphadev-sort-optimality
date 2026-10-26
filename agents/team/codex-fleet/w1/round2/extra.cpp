// One extra full conditional-select value in any block of each of the 33 c8 diagrams.
// Distinct-order relaxation. Every old value remains in the fixed target set.
#define PERMS
#define main route_old_main
#include "route.cpp"
#undef main
void rebuild(P&p){
 for(auto&b:p.bl)for(auto&g:b.g){int target=g.t;g=Gate{};g.t=target;
 for(int c=0;c<4;c++){U ds=0,ss=0;for(int d=0;d<p.N;d++){bool dok=true,sok=true;for(int w=0;w<120;w++){int q=(p.v[b.a][w]>p.v[b.b][w])-(p.v[b.a][w]<p.v[b.b][w]);bool take=c==0?q<0:c==1?q<=0:c==2?q>0:q>=0;if(p.v[d][w]!=p.v[g.t][w]){if(take)sok=false;else dok=false;}if(!dok&&!sok)break;}if(dok)ds|=1u<<d;if(sok)ss|=1u<<d;}for(int d=0;d<p.N;d++)if(ds>>d&1){g.src[d]|=ss;for(int s=0;s<p.N;s++)if(ss>>s&1)g.cond[d][s]=c;}}
 }
}
int main(int argc,char**argv){int begin=argc>1?atoi(argv[1]):0,end=argc>2?atoi(argv[2]):33;ifstream f("round2/problems.txt");int n;f>>n;set<int>seen;uint64_t tests=0,states=0;int found=0;auto start=chrono::steady_clock::now();
 for(int i=0;i<n;i++){P base(f,23);if(!seen.insert(base.cls).second||base.cls<begin||base.cls>=end)continue;int oldN=base.N;set<int>pool={0,1,2,3,4};int ncand=0;
  for(int b=0;b<(int)base.bl.size();b++){
   for(auto&g:base.bl[b].g)pool.insert(g.t);
   set<string>candidates;
   for(int d:pool)for(int s:pool){string value;for(int w=0;w<120;w++)value+=base.v[base.bl[b].a][w]>base.v[base.bl[b].b][w]?base.v[s][w]:base.v[d][w];if(find(base.v.begin(),base.v.end(),value)==base.v.end())candidates.insert(value);}
   for(auto &val:candidates){P p=base;p.N++;p.v.push_back(val);p.bit[oldN]=K(1)<<(4*oldN);Gate extra;extra.t=oldN;p.bl[b].g.push_back(extra);rebuild(p);int ans=p.solve();tests++;ncand++;states+=p.states;
    if(ans>=0){cout<<"CANDIDATE class="<<base.cls<<" network="<<base.id<<" block="<<b<<" k="<<8+ans<<" test="<<tests<<endl;P trace=p;trace.states=0;trace.hist.clear();assert(trace.solve(true)==ans);trace.emit("round2/extra_candidate_"+to_string(tests)+"_out.s",ans);found++;}
   }
  }
  cout<<"CLASS "<<base.cls<<" network="<<base.id<<" extra_values="<<ncand<<" cumulative_tests="<<tests<<" states="<<states<<" found="<<found<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<endl;
 }
 cout<<"COMPLETE extra-select classes=["<<begin<<","<<end<<") tests="<<tests<<" states="<<states<<" subset_candidates="<<found<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<endl;
}
