#include <bits/stdc++.h>
#include <filesystem>
using namespace std;
namespace fs=std::filesystem;
using U=uint64_t;
using Perm=array<int,5>;
using Col=array<unsigned char,120>;
using Sk=vector<Col>;
struct Set { U a=0,b=0; bool operator==(const Set&o)const{return a==o.a&&b==o.b;} };
struct Key { Set s; int left; bool operator==(const Key&o)const{return left==o.left&&s==o.s;} };
struct Hash { size_t operator()(const Key&k)const{return k.s.a^(k.s.b*0x9e3779b97f4a7c15ULL)^(U(k.left)*0x517cc1b727220a95ULL);} };
vector<Perm> P; vector<pair<int,int>> pairs;
int renameT[120][120],trans[10][120],action[10][120][120];
unordered_map<Key,bool,Hash> cache;
unordered_set<string> prior,seen;
vector<int> positions;
int C,maxfiles,specialmode;
int reqcap=100;long long reqfiltered=0;vector<int> pairorder,permorder;
long long prefixes=0,tries=0,paths=0,retained=0,duplicates=0,excluded=0,latticeonly=0,nodes=0;
string outdir;
ofstream manifest;
map<int,long long> reqhist;
struct Step {int pair,perm;};
int card(Set s){return __builtin_popcountll(s.a)+__builtin_popcountll(s.b);}
void put(Set&s,int t){if(t<64)s.a|=1ULL<<t;else s.b|=1ULL<<(t-64);}
template<class F> void each(Set s,F f){for(U m=s.a;m;m&=m-1)f(__builtin_ctzll(m));for(U m=s.b;m;m&=m-1)f(64+__builtin_ctzll(m));}
Set advance(Set s,int j,int pi=-1){Set r;each(s,[&](int t){put(r,pi<0?trans[j][t]:action[j][pi][t]);});return r;}
bool possible(Set s,int left){
 if(card(s)==1)return true;
 if(!left||card(s)>(1<<left))return false;
 Key k{s,left};auto it=cache.find(k);if(it!=cache.end())return it->second;
 for(int j=0;j<10;j++){Set q=advance(s,j);if(q==s)continue;if(possible(q,left-1)){cache[k]=true;return true;}}
 cache[k]=false;return false;
}
bool lattice(const Col&c){
 int tab[32];fill(tab,tab+32,-1);tab[0]=0;tab[31]=1;
 for(int t=0;t<120;t++)for(int h=1;h<5;h++){
  int m=0;for(int i=0;i<5;i++)if(P[t][i]>=h)m|=1<<i;
  int b=c[t]>=h;if(tab[m]>=0&&tab[m]!=b)return false;tab[m]=b;
 }
 for(int m=0;m<32;m++)for(int i=0;i<5;i++)if(tab[m]&&!tab[m|(1<<i)])return false;
 return true;
}
int input_index(const Col&c){for(int i=0;i<5;i++){bool eq=true;for(int t=0;t<120;t++)if(c[t]!=P[t][i]){eq=false;break;}if(eq)return i;}return -1;}
// S5 input relabeling, global value reversal, independent cmp operand reversal.
// Mapping the first two input operands to {0,1} chooses a symmetry section.
// The same section is used for every prior and generated skeleton.
string canonical(const Sk&v){
 int a=input_index(v[0]),b=input_index(v[1]);string best;
 for(int rev=0;rev<2;rev++)for(int pi=0;pi<120;pi++){
  if(a>=0&&b>=0&&a!=b&&((1<<P[pi][a])|(1<<P[pi][b]))!=3)continue;
  string key;key.reserve(v.size()*120);bool worse=false;
  for(int j=0;j<(int)v.size();j+=2){
   string x(120,'0'),y(120,'0');
   for(int t=0;t<120;t++){
    int tt=renameT[pi][rev?119-t:t];
    x[t]='0'+(rev?4-v[j][tt]:v[j][tt]);y[t]='0'+(rev?4-v[j+1][tt]:v[j+1][tt]);
   }
   if(y<x)swap(x,y);key+=x;key+=y;
   if(!best.empty()&&key.compare(0,key.size(),best,0,key.size())>0){worse=true;break;}
  }
  if(!worse&&(best.empty()||key<best))best=move(key);
 }
 return best;
}
int ev(const string&f,int t){
 if(f[0]=='=')return f.at(t+1)-'0';
 int v=-1,m=5;for(char c:f){if(c=='|'){v=max(v,m);m=5;}else if(c>='0'&&c<='4')m=min(m,P[t][c-'0']);else throw runtime_error("formula");}return max(v,m);
}
bool readsk(const fs::path&fn,Sk&v){
 ifstream f(fn);string l;v.clear();
 while(getline(f,l)){
  istringstream ss(l);string w;ss>>w;if(w.empty()||w[0]=='#')continue;
  w=w.substr(0,w.find(';'));auto q=w.find(':');if(q==string::npos)return false;
  try{for(auto s:{w.substr(0,q),w.substr(q+1)}){Col c;for(int t=0;t<120;t++){int z=ev(s,t);if(z<0||z>4)return false;c[t]=z;}v.push_back(c);}}catch(...){return false;}
  if(v.size()>18)return false;
 }
 return v.size()==16||v.size()==18;
}
bool progsk(const fs::path&fn,Sk&v){
 struct Ins{string op,d,s;};vector<Ins> code;ifstream f(fn);string l;
 while(getline(f,l)){istringstream ss(l);Ins x;ss>>x.op>>x.d>>x.s;if(x.op!="mov"&&x.op!="cmp"&&x.op.rfind("cmov",0)!=0)continue;if(x.d.empty()||x.s.empty())return false;if(x.d.back()==',')x.d.pop_back();code.push_back(x);}
 int c=count_if(code.begin(),code.end(),[](auto&x){return x.op=="cmp";});if(c!=8&&c!=9)return false;v.assign(2*c,Col{});
 for(int t=0;t<120;t++){
  map<string,int> r;for(int i=0;i<5;i++)r["P"+to_string(i)]=P[t][i];int fl=0,j=0;
  for(auto x:code){
   if(!r.count(x.s))return false;
   if(x.op=="mov")r[x.d]=r[x.s];
   else if(x.op=="cmp"){if(!r.count(x.d))return false;v[2*j][t]=r[x.d];v[2*j+1][t]=r[x.s];j++;fl=(r[x.d]>r[x.s])-(r[x.d]<r[x.s]);}
   else{bool take=x.op=="cmovl"?fl<0:x.op=="cmovg"?fl>0:x.op=="cmovle"?fl<=0:fl>=0;if(take)r[x.d]=r[x.s];}
  }
 }
 return true;
}
Sk trace(const vector<Step>&seq){
 Sk v;auto state=P;
 for(auto x:seq){Col a,b;auto [aa,bb]=pairs[x.pair];
  for(int t=0;t<120;t++){
   a[t]=state[t][aa];b[t]=state[t][bb];
   if(a[t]>b[t]){auto old=state[t];if(x.perm<0)swap(state[t][aa],state[t][bb]);else for(int k=0;k<5;k++)state[t][k]=old[P[x.perm][k]];}
  }v.push_back(a);v.push_back(b);
 }
 return v;
}
void emit(const vector<Step>&seq){
 paths++;Sk v=trace(seq);set<Col> req(v.begin(),v.end());
 for(int k=0;k<5;k++){Col c;c.fill(k);req.insert(c);}for(int i=0;i<5;i++){Col c;for(int t=0;t<120;t++)c[t]=P[t][i];req.erase(c);}
 if((int)req.size()>reqcap){reqfiltered++;return;}
 int nl=0;for(auto&c:req)if(!lattice(c))nl++;if(!nl){latticeonly++;return;}
 string key=canonical(v);if(prior.count(key)){excluded++;return;}if(!seen.insert(key).second){duplicates++;return;}
 reqhist[req.size()]++;char name[64];snprintf(name,sizeof(name),"s%06lld.txt",retained++);string fn=outdir+"/"+name;ofstream f(fn);
 f<<"# conditional wire permutations; ";for(auto x:seq){auto[a,b]=pairs[x.pair];f<<a<<b<<'/';if(x.perm<0)f<<'-';else for(int k:P[x.perm])f<<k;f<<' ';}f<<'\n';
 for(int j=0;j<C;j++){f<<'=';for(auto z:v[2*j])f<<int(z);f<<":=";for(auto z:v[2*j+1])f<<int(z);f<<'\n';}
 manifest<<"{\"file\":\""<<fn<<"\",\"required\":"<<req.size()<<",\"nonlattice\":"<<nl<<",\"c\":"<<C<<"}\n";manifest.flush();
 ofstream keyfile(fn+".key");keyfile<<key<<'\n';
 if(retained%1000==0)cerr<<"retained="<<retained<<" paths="<<paths<<" prefixes="<<prefixes<<"\n";
}
void suffix(Set s,vector<Step>&seq,int left,int prev){
 nodes++;if(retained>=maxfiles)return;
 if(!left){if(card(s)==1)emit(seq);return;}if(card(s)==1)return;
 for(int j:pairorder){
  auto[a,b]=pairs[j];
  if(prev>=0&&prev>j){auto[c,d]=pairs[prev];if(a!=c&&a!=d&&b!=c&&b!=d)continue;}
  Set q=advance(s,j);if(q==s||!possible(q,left-1))continue;
  seq.push_back({j,-1});suffix(q,seq,left-1,j);seq.pop_back();
 }
}
void prefix(Set s,vector<Step>&seq){
 if(retained>=maxfiles)return;int pos=seq.size()+1,left=C-pos;
 if(card(s)>(1<<(left+1)))return;
 bool special=find(positions.begin(),positions.end(),pos)!=positions.end();
 bool lastspecial=pos==positions.back();
 for(int j:pairorder){
  if(seq.empty()&&j!=0)continue;
  if(!special){
   Set q=advance(s,j);if(q==s)continue;
   seq.push_back({j,-1});prefix(q,seq);seq.pop_back();
  }else{
   auto[a,b]=pairs[j];
   for(int pi:permorder){
    // mode 1: swap compared pair and permute the other three wires.
    if((specialmode==1||(specialmode==2&&!lastspecial))&&(P[pi][a]!=b||P[pi][b]!=a))continue;
    // Exclude the ordinary comparator from the special actions.
    bool ordinary=P[pi][a]==b&&P[pi][b]==a;for(int k=0;k<5;k++)if(k!=a&&k!=b&&P[pi][k]!=k)ordinary=false;
    if(ordinary)continue;
    tries++;Set q=advance(s,j,pi);if(q==s||card(q)>(1<<left))continue;
    seq.push_back({j,pi});
    if(lastspecial){prefixes++;if(possible(q,left))suffix(q,seq,left,-1);}
    else prefix(q,seq);
    seq.pop_back();if(retained>=maxfiles)return;
   }
  }
 }
}
void init(){
 Perm p={0,1,2,3,4};do{P.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int a=0;a<5;a++)for(int b=a+1;b<5;b++)pairs.push_back({a,b});
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){
  Perm q;for(int i=0;i<5;i++)q[i]=P[t][P[pi][i]];renameT[pi][t]=lower_bound(P.begin(),P.end(),q)-P.begin();
 }
 for(int j=0;j<10;j++)for(int t=0;t<120;t++){
  auto[a,b]=pairs[j];auto q=P[t];if(q[a]>q[b])swap(q[a],q[b]);trans[j][t]=lower_bound(P.begin(),P.end(),q)-P.begin();
  for(int pi=0;pi<120;pi++)action[j][pi][t]=P[t][a]>P[t][b]?renameT[pi][t]:t;
 }
}
int main(int argc,char**argv){
 init();
 reqcap=getenv("GEN_REQCAP")?atoi(getenv("GEN_REQCAP")):100;
 for(int j=0;j<10;j++)pairorder.push_back(j);
 for(int pi=1;pi<120;pi++)permorder.push_back(pi);
 if(const char*e=getenv("GEN_SEED")){mt19937 rng(atoi(e));shuffle(pairorder.begin(),pairorder.end(),rng);shuffle(permorder.begin(),permorder.end(),rng);}
 if(argc==3&&string(argv[1])=="--key"){Sk v;if(!readsk(argv[2],v))return 2;cout<<canonical(v)<<'\n';return 0;}
 if(argc==4&&string(argv[1])=="--import-keys"){
  ifstream f(argv[2]);ofstream out(argv[3]);string line;long long read=0;
  while(getline(f,line)){
   if(line.size()!=1920&&line.size()!=2160)continue;
   Sk v(line.size()/120);bool good=true;
   for(int j=0;j<(int)v.size();j++)for(int t=0;t<120;t++){int z=line[120*j+t]-'0';if(z<0||z>4)good=false;v[j][t]=z;}
   if(!good)continue;read++;auto key=canonical(v);if(prior.insert(key).second)out<<key<<'\n';
  }
  cerr<<"imported="<<read<<" unique="<<prior.size()<<'\n';return 0;
 }
 if(argc==4&&string(argv[1])=="--index-list"){
  ifstream list(argv[2]);ofstream out(argv[3]);string fn;long long read=0;
  while(getline(list,fn)){Sk v;bool ok=fs::path(fn).extension()==".s"?progsk(fn,v):readsk(fn,v);if(!ok)continue;read++;auto key=canonical(v);if(prior.insert(key).second)out<<key<<'\n';}
  cerr<<"read="<<read<<" unique="<<prior.size()<<'\n';return 0;
 }
 if(argc>=3&&string(argv[1])=="--index"){
  ofstream out(argv[2]);long long files=0,good=0;
  for(int arg=3;arg<argc;arg++){
   vector<fs::path> fslist;
   if(fs::is_directory(argv[arg])){for(auto&e:fs::recursive_directory_iterator(argv[arg]))if(e.is_regular_file()&&(e.path().extension()==".txt"||e.path().extension()==".s"))fslist.push_back(e.path());}
   else fslist.push_back(argv[arg]);
   sort(fslist.begin(),fslist.end());
   for(auto fn:fslist){Sk v;files++;bool ok=fn.extension()==".s"?progsk(fn,v):readsk(fn,v);if(!ok)continue;good++;auto k=canonical(v);if(prior.insert(k).second)out<<k<<'\n';if(good%10000==0)cerr<<"indexed="<<good<<" unique="<<prior.size()<<'\n';}
  }
  cerr<<"files="<<files<<" good="<<good<<" unique="<<prior.size()<<'\n';return 0;
 }
 if(argc==4&&string(argv[1])=="--compare"){Sk a,b;if(!readsk(argv[2],a)||!readsk(argv[3],b))return 2;cout<<(canonical(a)==canonical(b)?"EQUIVALENT":"DISTINCT")<<'\n';return 0;}
 if(argc<7){cerr<<"usage: generate C positions_csv mode outdir maxfiles prior_keys\n";return 1;}
 C=atoi(argv[1]);string ps=argv[2];replace(ps.begin(),ps.end(),',',' ');istringstream ss(ps);int z;while(ss>>z)positions.push_back(z);
 specialmode=atoi(argv[3]);outdir=argv[4];maxfiles=atoi(argv[5]);ifstream old(argv[6]);string k;while(getline(old,k))prior.insert(k);
 fs::create_directories(outdir);manifest.open(outdir+"/manifest.jsonl");
 Set all{~0ULL,(1ULL<<56)-1};vector<Step> seq;prefix(all,seq);
 cout<<"c="<<C<<" positions="<<argv[2]<<" mode="<<specialmode<<" tries="<<tries<<" prefixes="<<prefixes<<" suffix_nodes="<<nodes<<" paths="<<paths<<" retained="<<retained<<" duplicates="<<duplicates<<" prior_excluded="<<excluded<<" lattice_only="<<latticeonly<<" required_filtered="<<reqfiltered<<" cache="<<cache.size()<<" capped="<<(retained>=maxfiles)<<'\n';
 for(auto[n,c]:reqhist)cout<<"required="<<n<<" count="<<c<<'\n';
}
