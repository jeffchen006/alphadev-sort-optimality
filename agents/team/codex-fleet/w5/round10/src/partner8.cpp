#include <bits/stdc++.h>
#include <filesystem>
using namespace std;
using U = uint64_t;
struct Bits { U a=0,b=0; bool operator==(const Bits&o) const{return a==o.a&&b==o.b;} };
struct Key { Bits s; int left,partners; bool operator==(const Key&o)const{return s==o.s&&left==o.left&&partners==o.partners;} };
struct Hash { size_t operator()(const Key&k)const{return k.s.a^(k.s.b*0x9e3779b97f4a7c15ULL)^(U(k.left*8+k.partners)*0x517cc1b727220a95ULL);} };
struct Step { int a,b,c=-1,d=-1,e=-1,rot=0; bool swapkey=true; };
vector<array<int,5>> perms;
vector<Step> steps;
int trans[110][120],ren[120][120];
unordered_map<Key,bool,Hash> memo;
unordered_set<string> seen;
long long calls=0,walks=0,paths=0,dups=0,written=0,maxfiles=10000,maxcalls=100000000;
bool limited=false;
string outdir;
ofstream manifest;
void applyStep(array<int,5>&q,const Step&x){
 if(q[x.a]<=q[x.b])return;
 if(x.swapkey)swap(q[x.a],q[x.b]);
 if(x.c<0)return;
 if(!x.rot)swap(q[x.c],q[x.d]);
 else {int a=q[x.c],b=q[x.d],c=q[x.e];if(x.rot==1){q[x.c]=b;q[x.d]=c;q[x.e]=a;}else{q[x.c]=c;q[x.d]=a;q[x.e]=b;}}
}
int card(Bits s){return __builtin_popcountll(s.a)+__builtin_popcountll(s.b);}
void put(Bits&s,int i){if(i<64)s.a|=1ULL<<i;else s.b|=1ULL<<(i-64);}
Bits advance(Bits s,int op){Bits q;for(U m=s.a;m;m&=m-1)put(q,trans[op][__builtin_ctzll(m)]);for(U m=s.b;m;m&=m-1)put(q,trans[op][64+__builtin_ctzll(m)]);return q;}
bool possible(Bits s,int left,int partners){
 if(partners<0||partners>left||card(s)>(1<<left))return false;
 if(!left)return card(s)==1&&partners==0;
 if(card(s)==1)return false;
 Key k{s,left,partners};auto it=memo.find(k);if(it!=memo.end())return it->second;
 if(++calls>maxcalls){limited=true;return false;}
 bool yes=false;
 vector<pair<int,int>> order;
 for(int op=0;op<int(steps.size());op++)if((steps[op].c>=0)==(partners==left)||partners>0){
   int p=steps[op].c>=0;if(p>partners)continue;
   Bits q=advance(s,op);if(q==s||card(q)>(1<<(left-1)))continue;
   order.push_back({card(q),op});
 }
 sort(order.begin(),order.end());
 for(auto[n,op]:order){Bits q=advance(s,op);if(possible(q,left-1,partners-(steps[op].c>=0))){yes=true;break;}if(limited)return false;}
 if(memo.size()<4000000)memo.emplace(k,yes);
 return yes;
}
bool lattice(const string&c){int tab[32];fill(tab,tab+32,-1);tab[0]=0;tab[31]=1;
 for(int t=0;t<120;t++)for(int h=1;h<5;h++){int m=0;for(int i=0;i<5;i++)if(perms[t][i]>=h)m|=1<<i;int b=c[t]-'0'>=h;if(tab[m]>=0&&tab[m]!=b)return false;tab[m]=b;}
 for(int m=0;m<32;m++)for(int i=0;i<5;i++)if(tab[m]&&!tab[m|1<<i])return false;return true;
}
string canonical(const vector<pair<string,string>>&sk){string best;
 for(int pi=0;pi<120;pi++)for(int reverse=0;reverse<2;reverse++){
  string key;bool worse=false;
  for(auto&[aa,bb]:sk){string a,b;for(int t=0;t<120;t++){int u=reverse?119-ren[pi][t]:ren[pi][t];a+=reverse?char('4'-(aa[u]-'0')):aa[u];b+=reverse?char('4'-(bb[u]-'0')):bb[u];}if(b<a)swap(a,b);key+=a;key+=b;
   if(!best.empty()&&key.compare(0,key.size(),best,0,key.size())>0){worse=true;break;}}
  if(!worse&&(best.empty()||key<best))best=move(key);
 }return best;
}
void emit(const vector<int>&seq){
 paths++;vector<pair<string,string>> sk;auto state=perms;set<string> required,inputs;
 for(int i=0;i<5;i++){string c;for(auto&p:perms)c+=char('0'+p[i]);inputs.insert(c);}
 for(int op:seq){auto x=steps[op];string a,b;for(auto&q:state){a+=char('0'+q[x.a]);b+=char('0'+q[x.b]);applyStep(q,x);}sk.push_back({a,b});required.insert(a);required.insert(b);}
 for(int i=0;i<5;i++)required.insert(string(120,char('0'+i)));for(auto&c:inputs)required.erase(c);
 int nl=0;for(auto&c:required)nl+=!lattice(c);if(!nl)return;
 auto key=canonical(sk);if(!seen.insert(key).second){dups++;return;}
 char name[64];snprintf(name,sizeof(name),"p%06lld.txt",written++);ofstream f(outdir+"/"+name);f<<"# c8 two-or-more companion permutations; ";for(int op:seq){auto x=steps[op];f<<x.a<<x.b;if(!x.swapkey)f<<'n';if(x.c>=0){f<<'/'<<x.c<<x.d;if(x.rot)f<<x.e<<'r'<<x.rot;}f<<' ';}f<<'\n';for(auto&[a,b]:sk)f<<'='<<a<<":="<<b<<'\n';
 manifest<<"{\"file\":\""<<name<<"\",\"required\":"<<required.size()<<",\"nonlattice\":"<<nl<<",\"action_count\":"<<steps.size()<<",\"ops\":[";for(size_t i=0;i<seq.size();i++)manifest<<(i?",":"")<<seq[i];manifest<<"]}\n";manifest.flush();
 if(written%100==0)cout<<"progress written="<<written<<" paths="<<paths<<" calls="<<calls<<" memo="<<memo.size()<<endl;
}
void walk(Bits s,vector<int>&seq,int left,int partners){
 if(limited||written>=maxfiles){limited=true;return;}walks++;
 if(!left){if(card(s)==1&&partners==0)emit(seq);return;}
 vector<pair<int,int>> order;for(int op=0;op<int(steps.size());op++){int p=steps[op].c>=0;if(p>partners||partners-p>left-1)continue;Bits q=advance(s,op);if(q==s||card(q)>(1<<(left-1)))continue;order.push_back({card(q),op});}sort(order.begin(),order.end());
 for(auto[n,op]:order){Bits q=advance(s,op);if(possible(q,left-1,partners-(steps[op].c>=0))){seq.push_back(op);walk(q,seq,left-1,partners-(steps[op].c>=0));seq.pop_back();}if(limited)return;}
}
int main(int argc,char**argv){
 if(argc<4){cerr<<"partner8 outdir partner_count maxfiles [maxcalls]\n";return 1;}outdir=argv[1];int np=atoi(argv[2]);maxfiles=atoll(argv[3]);if(argc>4)maxcalls=atoll(argv[4]);filesystem::create_directories(outdir);manifest.open(outdir+"/manifest.jsonl");
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int a=0;a<5;a++)for(int b=a+1;b<5;b++){steps.push_back({a,b});for(int c=0;c<5;c++)for(int d=c+1;d<5;d++)if(c!=a&&c!=b&&d!=a&&d!=b)steps.push_back({a,b,c,d});}
 if(argc>5&&atoi(argv[5]))for(int a=0;a<5;a++)for(int b=a+1;b<5;b++){vector<int> r;for(int i=0;i<5;i++)if(i!=a&&i!=b)r.push_back(i);for(int rot=1;rot<=2;rot++)steps.push_back({a,b,r[0],r[1],r[2],rot});}
 if(argc>5&&atoi(argv[5])>=2){int before=steps.size();for(int i=0;i<before;i++)if(steps[i].c>=0){auto x=steps[i];x.swapkey=false;steps.push_back(x);}}
 for(int op=0;op<int(steps.size());op++)for(int t=0;t<120;t++){auto q=perms[t];applyStep(q,steps[op]);trans[op][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];ren[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 int first=argc>6?atoi(argv[6]):0;
 if(first<0||first>=int(steps.size()))return 2;
 Bits full{~0ULL,(1ULL<<56)-1};vector<int> seq{first};Bits initial=advance(full,first);walk(initial,seq,7,np-(steps[first].c>=0));
 cout<<"RESULT "<<(limited?"LIMIT":"COMPLETE")<<" partners="<<np<<" written="<<written<<" paths="<<paths<<" duplicates="<<dups<<" calls="<<calls<<" walks="<<walks<<" memo="<<memo.size()<<endl;
}
