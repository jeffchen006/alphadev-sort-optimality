// Exact delete-two/insert-one neighbourhood. One CPU; concrete relaxed cases.
// Negative results are for the stated fixed-register edit family only.
#include <bits/stdc++.h>
#include <sys/resource.h>
using namespace std;
using U=uint64_t;
constexpr int MR=40, ML=45;
const char* OPS[]={"mov","cmp","cmovl","cmovle","cmovg","cmovge","out"};
struct Ins {int op,d,s;};
struct Base {string name;int nr;vector<string> names;vector<Ins> code;int k()const{int n=0;for(auto z:code)n+=z.op!=6;return n;}};
struct State {array<uint8_t,MR> r{};int flag=0;};
struct Case {array<uint8_t,5>x,goal;};
struct Match {array<U,5>m{};};
struct Cand {Ins in;Match have;};
struct Result {uint64_t slots=0, raw=0, sims=0, steps=0, cases=0, survivors=0;};
vector<Case> tests;
int auditCases=0;
bool take(int f,int op){return op==2?f<0:op==3?f<=0:op==4?f>0:f>=0;}
void exec(State&st,Ins in){if(in.op==0)st.r[in.d]=st.r[in.s];else if(in.op==1)st.flag=(st.r[in.d]>st.r[in.s])-(st.r[in.d]<st.r[in.s]);else if(take(st.flag,in.op))st.r[in.d]=st.r[in.s];}
State init(const Case&c,int nr){State s;s.r.fill(5);copy(c.x.begin(),c.x.end(),s.r.begin());return s;}
vector<Base> readbases(string path){ifstream f(path);int n;f>>n;vector<Base>bs;while(n--){Base b;int len;f>>b.name>>b.nr>>len;for(int i=0;i<b.nr;i++){string s;f>>s;b.names.push_back(s);}while(len--){Ins z;f>>z.op>>z.d>>z.s;b.code.push_back(z);}bs.push_back(b);}return bs;}
void maketests(){vector<Case>strict,ties;for(int code=0;code<3125;code++){Case c;int q=code,used=0;for(auto&x:c.x){x=q%5;q/=5;used|=1<<x;}if(used&(used+1))continue;c.goal=c.x;sort(c.goal.begin(),c.goal.end());(used==31?strict:ties).push_back(c);}mt19937 rng(20261025);shuffle(strict.begin(),strict.end(),rng);shuffle(ties.begin(),ties.end(),rng);tests=strict;tests.insert(tests.end(),ties.begin(),ties.end());assert(tests.size()==541);}
void note(Match&m,const State&s,const Case&c,int slot,int reg){for(int j=0;j<5;j++)if(s.r[reg]==c.goal[j])m.m[j]|=1ULL<<slot;}
bool valid(const Match&m){for(U x:m.m)if(!x)return false;return true;}
Match both(Match a,const Match&b){for(int j=0;j<5;j++)a.m[j]&=b.m[j];return a;}
struct Prefix {State st;Match seen;bool fixedok=true;};
// Write slots have stable identities independent of the inserted opcode.
// 0..4 = initial inputs; 5 = inserted write; 6+instruction index = base write.
vector<Prefix> prefixes(const vector<Ins>&q,const Case&c,int nr,bool freeout){vector<Prefix>p(q.size()+1);p[0].st=init(c,nr);for(int r=0;r<5;r++)note(p[0].seen,p[0].st,c,r,r);for(int i=0;i<(int)q.size();i++){p[i+1]=p[i];Ins z=q[i];if(z.op==6){if(p[i].st.r[z.s]!=c.goal[z.d])p[i+1].fixedok=false;}else {exec(p[i+1].st,z);if(z.op!=1)note(p[i+1].seen,p[i+1].st,c,6+i,z.d);}}return p;}
Match suffix(const vector<Ins>&q,int gap,const Prefix&p,const Case&c,int action,bool freeout,Result&stat){stat.sims++;State s=p.st;Match m=p.seen;
 if(action>=MR*6){s.flag=action-MR*6-1;}else {int d=action/6,v=action%6;s.r[d]=v;note(m,s,c,5,d);}
 bool ok=p.fixedok;
 for(int i=gap;i<(int)q.size();i++){stat.steps++;Ins z=q[i];if(z.op==6){if(!freeout&&s.r[z.s]!=c.goal[z.d]){return Match{};}}else{exec(s,z);if(freeout&&z.op!=1)note(m,s,c,6+i,z.d);}}
 if(!freeout){if(!ok)return Match{};m.m.fill(1);}return m;
}
int action(const State&s,Ins in){if(in.op==1){int f=(s.r[in.d]>s.r[in.s])-(s.r[in.d]<s.r[in.s]);return MR*6+f+1;}int v=in.op==0||take(s.flag,in.op)?s.r[in.s]:s.r[in.d];return in.d*6+v;}
string regname(const Base&b,int r){return r<b.nr?b.names[r]:"S999";}
vector<Ins> build(const vector<Ins>&q,int gap,Ins in,bool freeout){vector<Ins>v;for(int i=0;i<=(int)q.size();i++){if(i==gap)v.push_back(in);if(i<(int)q.size()&&(!freeout||q[i].op!=6))v.push_back(q[i]);}return v;}
bool checkfree(const vector<Ins>&code,int nr,Match&found){found.m.fill(~0ULL);for(auto c:tests){State s=init(c,nr);Match m;for(int r=0;r<5;r++)note(m,s,c,r,r);for(int i=0;i<(int)code.size();i++){exec(s,code[i]);if(code[i].op!=1)note(m,s,c,5+i,code[i].d);}found=both(found,m);if(!valid(found))return false;}return true;}
bool emit(const Base&b,const vector<Ins>&q,int gap,const Cand&cand,int da,int db,const string&prefix,bool freeout){vector<Ins>v=build(q,gap,cand.in,freeout);Match found;if(freeout&&!checkfree(v,b.nr+1,found))return false;string path=prefix+"_"+b.name+"_"+to_string(da)+"_"+to_string(db)+"_"+to_string(gap)+"_"+to_string(cand.in.op)+"_"+to_string(cand.in.d)+"_"+to_string(cand.in.s)+".s";ofstream f(path);f<<"# n=5 model=out iset=I1 source=w1-round4-edit k="<<b.k()-1<<"\n";
 auto outputs=[&](int slot,int reg){if(freeout)for(int j=0;j<5;j++)if(__builtin_ctzll(found.m[j])==slot)f<<"out "<<j<<", "<<regname(b,reg)<<"\n";};
 for(int r=0;r<5;r++)outputs(r,r);for(int i=0;i<(int)v.size();i++){auto z=v[i];if(z.op==6)f<<"out "<<z.d<<", "<<regname(b,z.s)<<"\n";else{f<<OPS[z.op]<<" "<<regname(b,z.d)<<", "<<regname(b,z.s)<<"\n";if(z.op!=1)outputs(5+i,z.d);}}
 cout<<"CANDIDATE file="<<path<<" k="<<b.k()-1<<" deletion="<<da<<","<<db<<" gap="<<gap<<"\n";cout.flush();return true;}
Result search(const Base&b,int freeout,string prefix,int pairfirst,int pairlast,bool stopfound){Result stats;int pairindex=0;for(int da=0;da<b.k();da++)for(int db=da+1;db<b.k();db++,pairindex++){if(pairindex<pairfirst||pairindex>=pairlast)continue;vector<Ins>q;int core=0;for(auto z:b.code){if(z.op==6){if(!freeout)q.push_back(z);}else{if(core!=da&&core!=db)q.push_back(z);core++;}}assert(q.size()<=37);
 vector<vector<Prefix>>pc;pc.push_back(prefixes(q,tests[0],b.nr+1,freeout));
 for(int gap=0;gap<=(int)q.size();gap++){stats.slots++;vector<Cand>cs;for(int op=0;op<6;op++)for(int d=0;d<=b.nr;d++)for(int s=0;s<=b.nr;s++){Cand c;c.in={op,d,s};c.have.m.fill(~0ULL);cs.push_back(c);}stats.raw+=cs.size();
  for(int t=0;t<(int)tests.size()&&!cs.empty();t++){stats.cases++;if(t>=(int)pc.size())pc.push_back(prefixes(q,tests[t],b.nr+1,freeout));const Prefix&p=pc[t][gap];if(!freeout&&!p.fixedok){cs.clear();break;}
   array<Match,MR*6+3>cache;array<bool,MR*6+3>has{};int count=0;
   for(auto c:cs){int a=action(p.st,c.in);if(!has[a]){cache[a]=suffix(q,gap,p,tests[t],a,freeout,stats);has[a]=true;}c.have=both(c.have,cache[a]);if(valid(c.have))cs[count++]=c;}cs.resize(count);
   if(t<auditCases){U hash=1469598103934665603ULL;for(auto c:cs){for(int x:{c.in.op,c.in.d,c.in.s})hash=(hash^x)*1099511628211ULL;for(U x:c.have.m)hash=(hash^x)*1099511628211ULL;}cout<<"AUDIT "<<b.name<<" "<<pairindex<<" "<<gap<<" "<<t<<" "<<cs.size()<<" "<<hash<<"\n";}
  }
  for(auto c:cs){stats.survivors++;if(emit(b,q,gap,c,da,db,prefix,freeout)&&stopfound)return stats;}
 }
 if((pairindex+1)%32==0){cout<<"PROGRESS "<<b.name<<" pairs="<<pairindex+1<<" slots="<<stats.slots<<" sims="<<stats.sims<<"\n";cout.flush();}
 }return stats;}
int main(int argc,char**argv){string file=argc>1?argv[1]:"round4/bases.txt";int first=argc>2?atoi(argv[2]):0,last=argc>3?atoi(argv[3]):170,freeout=argc>4?atoi(argv[4]):0,pf=argc>5?atoi(argv[5]):0,pl=argc>6?atoi(argv[6]):496;string prefix=argc>7?argv[7]:"round4/edit";bool stop=argc>8?atoi(argv[8]):true;auditCases=argc>9?atoi(argv[9]):0;rlimit mem{2800ULL*1024*1024,2800ULL*1024*1024};setrlimit(RLIMIT_AS,&mem);maketests();if(file=="--dump-cases"){for(auto c:tests){for(auto x:c.x)cout<<int(x)<<" ";cout<<"\n";}return 0;}auto bases=readbases(file);for(int i=first;i<min(last,(int)bases.size());i++){clock_t start=clock();Result r=search(bases[i],freeout,prefix,pf,pl,stop);cout<<"RESULT index="<<i<<" name="<<bases[i].name<<" mode="<<(freeout?"freeout":"fixedout")<<" pairfirst="<<pf<<" pairlast="<<pl<<" status="<<(r.survivors?"CANDIDATE":"NONE")<<" slots="<<r.slots<<" raw="<<r.raw<<" sims="<<r.sims<<" steps="<<r.steps<<" case_slots="<<r.cases<<" survivors="<<r.survivors<<" cpu="<<double(clock()-start)/CLOCKS_PER_SEC<<"\n";cout.flush();if(r.survivors&&stop)return 0;}}
