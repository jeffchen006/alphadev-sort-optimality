// c=9: a conditional permutation can mix compared values and partner values.
// Each special step moves >=3 wires. All selections use one comparison flag.
#include <bits/stdc++.h>
#include <filesystem>
using namespace std;
using U=uint64_t;
struct Set { U a=0,b=0;bool operator==(const Set&o)const{return a==o.a&&b==o.b;} };
struct Key { Set s;int n;bool operator==(const Key&o)const{return n==o.n&&s==o.s;} };
struct Hash { size_t operator()(const Key&k)const{return k.s.a^(k.s.b*0x9e3779b97f4a7c15ULL)^(U(k.n)*0x517cc1b727220a95ULL);} };
struct Step {int pair,action=-1;};
vector<array<int,5>> P,actions;
vector<pair<int,int>> pairs;
int trans[10][120],special[10][120][120],renameT[120][120];
unordered_map<Key,bool,Hash> cache;
unordered_set<string> seen;
ofstream manifest;
string outdir;
long long paths=0,prefixes=0,nodes=0,duplicates=0,latticeonly=0,large=0,retained=0,clears=0;
map<int,long long> requiredhist,supporthist;
int card(Set s){return __builtin_popcountll(s.a)+__builtin_popcountll(s.b);}
void put(Set&s,int i){if(i<64)s.a|=1ULL<<i;else s.b|=1ULL<<(i-64);}
Set advanceSet(Set s,const int*table){Set r;for(U m=s.a;m;m&=m-1)put(r,table[__builtin_ctzll(m)]);for(U m=s.b;m;m&=m-1)put(r,table[64+__builtin_ctzll(m)]);return r;}
bool possible(Set s,int n){
 if(card(s)==1)return true;if(!n||card(s)>(1<<n))return false;
 Key k{s,n};auto it=cache.find(k);if(it!=cache.end())return it->second;
 bool answer=false;
 for(int j=0;j<10;j++){Set q=advanceSet(s,trans[j]);if(q==s)continue;if(possible(q,n-1)){answer=true;break;}}
 if(cache.size()>=2000000){cache.clear();clears++;}
 cache[k]=answer;return answer;
}
bool lattice(const string&c){int tab[32];fill(tab,tab+32,-1);tab[0]=0;tab[31]=1;
 for(int t=0;t<120;t++)for(int h=1;h<5;h++){int m=0;for(int i=0;i<5;i++)if(P[t][i]>=h)m|=1<<i;int b=c[t]-'0'>=h;if(tab[m]>=0&&tab[m]!=b)return false;tab[m]=b;}
 for(int m=0;m<32;m++)for(int i=0;i<5;i++)if(tab[m]&&!tab[m|1<<i])return false;return true;
}
string canonical(const vector<pair<string,string>>&sk){string best;
 auto idx=[&](const string&c){for(int i=0;i<5;i++){bool same=true;for(int t=0;t<120;t++)same&=c[t]-'0'==P[t][i];if(same)return i;}return -1;};
 int ia=idx(sk[0].first),ib=idx(sk[0].second),ic=idx(sk[1].first),id=idx(sk[1].second);
 bool disjoint=ia>=0&&ib>=0&&ic>=0&&id>=0&&ia!=ib&&ic!=id&&ic!=ia&&ic!=ib&&id!=ia&&id!=ib;
 for(int pi=0;pi<120;pi++){
  if(ia>=0&&ib>=0&&ia!=ib&&((1<<P[pi][ia])|(1<<P[pi][ib]))!=3)continue;
  if(disjoint&&((1<<P[pi][ic])|(1<<P[pi][id]))!=12)continue;
  string k;bool worse=false;
  for(auto&[aa,bb]:sk){string a,b;for(int t=0;t<120;t++){a+=aa[renameT[pi][t]];b+=bb[renameT[pi][t]];}if(b<a)swap(a,b);k+=a;k+=b;
   if(!best.empty()&&k.compare(0,k.size(),best,0,k.size())>0){worse=true;break;}}
  if(!worse&&(best.empty()||k<best))best=move(k);
 }return best;
}
void emit(const vector<Step>&seq){
 paths++;vector<pair<string,string>> sk;set<string> req,inputs;
 for(int i=0;i<5;i++){string c;for(auto&p:P)c+=char('0'+p[i]);inputs.insert(c);}
 auto state=P;int moved=0;
 for(auto x:seq){auto[a,b]=pairs[x.pair];string ca,cb;
  for(auto&q:state){ca+=char('0'+q[a]);cb+=char('0'+q[b]);if(q[a]>q[b]){
   if(x.action<0)swap(q[a],q[b]);else {auto old=q;for(int i=0;i<5;i++)q[i]=old[actions[x.action][i]];}
  }}
  if(x.action>=0)for(int i=0;i<5;i++)moved+=actions[x.action][i]!=i;
  sk.push_back({ca,cb});req.insert(ca);req.insert(cb);
 }
 for(int t=1;t<120;t++)if(state[t]!=state[0])throw runtime_error("bad completion");
 for(int i=0;i<5;i++)req.insert(string(120,'0'+i));for(auto&c:inputs)req.erase(c);
 requiredhist[req.size()]++;if(req.size()>22){large++;return;}
 int nl=0;for(auto&c:req)if(!lattice(c))nl++;if(!nl){latticeonly++;return;}
 string key=canonical(sk);if(!seen.insert(key).second){duplicates++;return;}
 char name[64];snprintf(name,sizeof(name),"s%06lld.txt",retained++);ofstream f(outdir+"/"+name);
 f<<"# conditional multiselect; ";for(auto x:seq){auto[a,b]=pairs[x.pair];f<<a<<b;if(x.action>=0){f<<'/';for(int z:actions[x.action])f<<z;}f<<' ';}f<<'\n';
 for(auto&[a,b]:sk)f<<'='<<a<<":="<<b<<'\n';
 if(retained>1)manifest<<",\n";manifest<<"{\"file\":\""<<outdir<<'/'<<name<<"\",\"required_gates\":"<<req.size()<<",\"nonlattice\":"<<nl<<",\"moved_wires\":"<<moved<<"}";manifest.flush();
 supporthist[moved]++;
}
void suffix(Set s,vector<Step>&seq,int left,int prev){
 nodes++;if(!left){if(card(s)==1)emit(seq);return;}
 if(card(s)==1)return;
 for(int j=0;j<10;j++){auto[a,b]=pairs[j];
  if(prev>=0&&prev>j){auto[c,d]=pairs[prev];if(a!=c&&a!=d&&b!=c&&b!=d)continue;}
  Set q=advanceSet(s,trans[j]);if(q==s||!possible(q,left-1))continue;
  seq.push_back({j});suffix(q,seq,left-1,j);seq.pop_back();}
}
void prefix(Set s,vector<Step>&seq,int position){
 if(int(seq.size())==position-1){
  for(int j=0;j<10;j++)for(int ac=0;ac<120;ac++){
   int moved=0;for(int i=0;i<5;i++)moved+=actions[ac][i]!=i;if(moved<3)continue;
   auto[a,b]=pairs[j];
   // Earlier rounds cover swap(a,b) plus a disjoint partner permutation.
   if(actions[ac][a]==b&&actions[ac][b]==a)continue;
   seq.push_back({j,ac});Set q=advanceSet(s,special[j][ac]);prefixes++;
   if(possible(q,9-position))suffix(q,seq,9-position,-1);seq.pop_back();
  }return;
 }
 for(int j=0;j<10;j++){
  if(seq.empty()&&j!=0)continue;
  Set q=advanceSet(s,trans[j]);if(q==s)continue;
  seq.push_back({j});prefix(q,seq,position);seq.pop_back();
 }
}
int main(int argc,char**argv){
 if(argc!=3){cerr<<"usage: multiselect_prefix position outdir\n";return 1;}
 int pos=atoi(argv[1]);if(pos<2||pos>8)return 2;
 outdir=argv[2];filesystem::create_directories(outdir);manifest.open(outdir+"/manifest.json");manifest<<"[\n";
 array<int,5> p={0,1,2,3,4};do{P.push_back(p);actions.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int a=0;a<5;a++)for(int b=a+1;b<5;b++)pairs.push_back({a,b});
 for(int j=0;j<10;j++)for(int t=0;t<120;t++){
  auto q=P[t];auto[a,b]=pairs[j];if(q[a]>q[b])swap(q[a],q[b]);trans[j][t]=lower_bound(P.begin(),P.end(),q)-P.begin();
  for(int ac=0;ac<120;ac++){q=P[t];if(q[a]>q[b]){auto old=q;for(int i=0;i<5;i++)q[i]=old[actions[ac][i]];}special[j][ac][t]=lower_bound(P.begin(),P.end(),q)-P.begin();}
 }
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=P[t][P[pi][i]];renameT[pi][t]=lower_bound(P.begin(),P.end(),q)-P.begin();}
 Set all;for(int t=0;t<120;t++)put(all,t);vector<Step> seq;prefix(all,seq,pos);manifest<<"\n]\n";
 cout<<"position="<<pos<<" prefixes="<<prefixes<<" nodes="<<nodes<<" completions="<<paths<<" retained="<<retained<<" duplicates="<<duplicates<<" lattice_only="<<latticeonly<<" too_large="<<large<<" cache="<<cache.size()<<" cache_clears="<<clears<<'\n';
 for(auto[n,c]:requiredhist)cout<<"required="<<n<<" count="<<c<<'\n';
 for(auto[n,c]:supporthist)cout<<"moved_wires="<<n<<" retained="<<c<<'\n';
}
