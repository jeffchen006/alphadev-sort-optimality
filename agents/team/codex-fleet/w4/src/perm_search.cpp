#include <bits/stdc++.h>
using namespace std;
using U=__uint128_t;
struct Act{int a,b,pi,cost;};
vector<array<int,5>> ps;int mul[120][120],cc[120];vector<int> pind;vector<Act> acts;
map<array<int,5>,int> idx;
U lt[5][5]; long long nodes[5],found=0; int cap=200000, budget=14;
vector<Act> path; set<array<int,8>> uniq;
U apply(U s,Act a){U l=s&lt[a.a][a.b],r=s&~lt[a.a][a.b],o=l;while(r){int j=(uint64_t)r?__builtin_ctzll((uint64_t)r):64+__builtin_ctzll((uint64_t)(r>>64));r&=r-1;o|=U(1)<<mul[a.pi][j];}return o;}
int pop(U x){return __builtin_popcountll((uint64_t)x)+__builtin_popcountll((uint64_t)(x>>64));}
void emit(){
 for(auto a:path)printf("%d %d %d ",a.a,a.b,a.pi);printf("\n");found++;
}
void dfs(U st,int d,int cost){nodes[d]++;if(found>=cap)return;
 if(d==3){
  if(pop(st)!=2)return;
  for(int a=0;a<5;a++)for(int b=a+1;b<5;b++){
   U l=st&lt[a][b],r=st&~lt[a][b];if(!l||!r)continue;
   int il=(uint64_t)l?__builtin_ctzll((uint64_t)l):64+__builtin_ctzll((uint64_t)(l>>64));
   int ir=(uint64_t)r?__builtin_ctzll((uint64_t)r):64+__builtin_ctzll((uint64_t)(r>>64));
   array<int,5> p;for(int i=0;i<5;i++)p[i]=find(ps[ir].begin(),ps[ir].end(),ps[il][i])-ps[ir].begin();
   int pi=idx[p];if(cost+cc[pi]>budget)continue;
   path.push_back({a,b,pi,cc[pi]});emit();path.pop_back();
  }return;
 }
 int remain=3-d;
 for(auto a:acts){if(cost+a.cost+3*remain>budget)continue;
  U nx=apply(st,a);if(pop(nx)>1<<(3-d))continue;
  // Every stage must reduce the number of physical states.
  if(pop(nx)>=pop(st))continue;
  path.push_back(a);dfs(nx,d+1,cost+a.cost);path.pop_back();
 }
}
int main(int argc,char**argv){if(argc>1)budget=atoi(argv[1]);if(argc>2)cap=atoi(argv[2]);
 array<int,5> p={0,1,2,3,4};do{idx[p]=ps.size();ps.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int i=0;i<120;i++){
  int seen=0,cost=0;for(int j=0;j<5;j++)if(ps[i][j]!=j){cost++;if(!(seen>>j&1)){cost++;int k=j;while(!(seen>>k&1)){seen|=1<<k;k=ps[i][k];}}}cc[i]=cost;
  for(int j=0;j<120;j++){array<int,5> q;for(int k=0;k<5;k++)q[k]=ps[j][ps[i][k]];mul[i][j]=idx[q];}
 }
 for(int a=0;a<5;a++)for(int b=0;b<5;b++)for(int t=0;t<120;t++)if(ps[t][a]<ps[t][b])lt[a][b]|=U(1)<<t;
 for(int a=0;a<5;a++)for(int b=a+1;b<5;b++)for(int i=0;i<120;i++)if(cc[i]>=3&&cc[i]<=budget-9)acts.push_back({a,b,i,cc[i]});
 U initial=0;for(int i=0;i<120;i++)if(ps[i][0]<ps[i][1]&&ps[i][2]<ps[i][3]&&ps[i][3]<ps[i][4])initial|=U(1)<<i;
 dfs(initial,0,0);
 fprintf(stderr,"budget=%d actions=%zu found=%lld nodes=%lld,%lld,%lld,%lld,%lld\n",budget,acts.size(),found,nodes[0],nodes[1],nodes[2],nodes[3],nodes[4]);
}
