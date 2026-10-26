// Exact bounded search in the conditional-transposition grammar on distinct inputs.
// Canonical sets identify wire permutations. No rank relabeling is used.
#include <bits/stdc++.h>
#include <sys/resource.h>
using namespace std;using U=uint64_t;
struct Bits{U a=0,b=0;bool operator==(const Bits&x)const{return a==x.a&&b==x.b;}};
struct Hash{size_t operator()(Bits x)const{return x.a^(x.b*0x9e3779b97f4a7c15ULL);}};
struct Op{int a,b,c,d;};
int N,NT,K;double limit,begun;string prefix;
vector<array<int,5>>perms;vector<Op>ops;
uint8_t invn[200][120],invv[200][120][2],ren[120][120];
unordered_map<Bits,int,Hash>failed;
vector<int>path;uint64_t calls=0,edges=0,canonical=0,hits=0;bool stopped=false;
vector<int> ids(Bits x){vector<int>v;while(x.a){int i=__builtin_ctzll(x.a);x.a&=x.a-1;v.push_back(i);}while(x.b){int i=__builtin_ctzll(x.b)+64;x.b&=x.b-1;v.push_back(i);}return v;}
int card(Bits x){return __builtin_popcountll(x.a)+__builtin_popcountll(x.b);}
void put(Bits&x,int i){if(i<64)x.a|=1ULL<<i;else x.b|=1ULL<<(i-64);}
double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+r.ru_utime.tv_usec*1e-6+r.ru_stime.tv_sec+r.ru_stime.tv_usec*1e-6;}
Bits canon(Bits x){canonical++;auto v=ids(x);Bits best={~0ULL,~0ULL};for(int a:v){Bits y;for(int j:v)put(y,ren[a][j]);if(tie(y.b,y.a)<tie(best.b,best.a))best=y;}return best;}
Bits before(Bits x,int o){Bits r;for(int j:ids(x))for(int z=0;z<invn[o][j];z++)put(r,invv[o][j][z]);return r;}
bool solve(Bits s,int left){
 calls++;int n=card(s);if(n==NT)return true;if(!left||n*(1<<left)<NT)return false;
 if(!(calls&4095)){if(cpu()-begun>limit||failed.size()>7000000){stopped=true;return false;}}
 Bits key=canon(s);auto it=failed.find(key);if(it!=failed.end()&&it->second>=left){hits++;return false;}
 vector<pair<int,pair<Bits,int>>>ch;unordered_set<Bits,Hash>seen;
 for(int o=0;o<(int)ops.size();o++){edges++;Bits t=before(s,o);int m=card(t);if(m*(1<<(left-1))<NT)continue;
  if(!(t.a&~s.a)&&!(t.b&~s.b))continue;
  Bits ck=canon(t);if(!seen.insert(ck).second)continue;
  auto i=failed.find(ck);if(i!=failed.end()&&i->second>=left-1)continue;
  ch.push_back({-m,{t,o}});
 }
 stable_sort(ch.begin(),ch.end(),[](auto a,auto b){return a.first<b.first;});
 for(auto v:ch){path.push_back(v.second.second);if(solve(v.second.first,left-1))return true;path.pop_back();if(stopped)return false;}
 auto q=failed.emplace(key,left);if(!q.second)q.first->second=max(q.first->second,left);
 return false;
}
int main(int argc,char**argv){N=atoi(argv[1]);K=atoi(argv[2]);limit=atof(argv[3]);prefix=argv[4];array<int,5>a={0,1,2,3,4};do{perms.push_back(a);}while(next_permutation(a.begin(),a.begin()+N));NT=perms.size();for(int a=0;a<N;a++)for(int b=0;b<N;b++)if(a!=b)for(int c=0;c<N;c++)for(int d=c+1;d<N;d++)ops.push_back({a,b,c,d});
 for(int o=0;o<(int)ops.size();o++)for(int i=0;i<NT;i++){auto p=perms[i];auto op=ops[o];if(p[op.a]>p[op.b])swap(p[op.c],p[op.d]);int j=lower_bound(perms.begin(),perms.end(),p)-perms.begin();assert(invn[o][j]<2);invv[o][j][invn[o][j]++]=i;}
 for(int i=0;i<NT;i++){int r[5];for(int z=0;z<N;z++)r[perms[i][z]]=z;for(int j=0;j<NT;j++){auto b=perms[j];for(int z=0;z<N;z++)b[z]=perms[j][r[z]];ren[i][j]=lower_bound(perms.begin(),perms.end(),b)-perms.begin();}}
 begun=cpu();Bits s;put(s,0);bool ok=solve(s,K);cout<<"RESULT "<<(ok?"FOUND":stopped?"LIMIT":"NONE")<<" n="<<N<<" swaps="<<K<<" calls="<<calls<<" edges="<<edges<<" canonical="<<canonical<<" memo="<<failed.size()<<" hits="<<hits<<" cpu="<<cpu()-begun<<"\n";
 if(ok){ofstream f(prefix+".s");f<<"# n="<<N<<" model=out iset=I1 source=w6-backward-macro\n";reverse(path.begin(),path.end());for(int z:path){auto o=ops[z];f<<"cmp P"<<o.a<<", P"<<o.b<<"\nmov S0, P"<<o.c<<"\ncmovg P"<<o.c<<", P"<<o.d<<"\ncmovg P"<<o.d<<", S0\n";}for(int r=0;r<N;r++)f<<"out "<<r<<", P"<<r<<"\n";}
 return 0;
}
