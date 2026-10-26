// Masked event routing. Comparisons preserve demanded predicates, not operands.
// One thread. All columns contain all 541 weak orders and unknown scratch = 7.
#include <bits/stdc++.h>
#include <sys/resource.h>
using namespace std;
using U=uint64_t;
constexpr int W=9;
using Mask=array<U,W>;
using Col=array<Mask,3>;
struct Flag{Mask lt{},gt{},un{};bool operator==(const Flag&o)const{return lt==o.lt&&gt==o.gt&&un==o.un;}};
struct CH{size_t operator()(const Col&a)const{U h=0x9747b28c;for(auto &b:a)for(U x:b)h=(h^x)*0x9e3779b97f4a7c15ULL;return h^(h>>32);}};
struct FH{size_t operator()(const Flag&a)const{U h=0x9747b28c;for(auto &b:{a.lt,a.gt,a.un})for(U x:b)h=(h^x)*0x9e3779b97f4a7c15ULL;return h^(h>>32);}};
Mask full(){Mask m;m.fill(~0ULL);m.back()=(1ULL<<(541%64))-1;return m;}
const Mask ALL=full();
Mask readmask(istream&f){string s;f>>s;Mask r{};int k=0;for(auto i=s.rbegin();i!=s.rend();i++,k++){int v=isdigit(*i)?*i-'0':*i-'a'+10;r[k/16]|=U(v)<<((k%16)*4);}return r;}
struct Need{int col;Mask mask;};
struct Event{int op,target;Mask need{};array<Mask,4>expected{},cmask{};bool deleted=false;};
struct Problem{string name;vector<Col>base;vector<Event>ev;vector<vector<Need>>live;vector<array<int,3>>outs;};
Problem readproblem(istream&f){Problem p;int nv,n;f>>p.name>>nv>>n;for(int i=0;i<nv;i++){string s;f>>s;assert(s.size()==541);Col c{};for(int t=0;t<541;t++)for(int b=0;b<3;b++)if((s[t]-'0')>>b&1)c[b][t/64]|=1ULL<<(t%64);p.base.push_back(c);}for(int i=0;i<n;i++){Event e;f>>e.op>>e.target;if(e.op==1)for(int c=0;c<4;c++)e.expected[c]=readmask(f),e.cmask[c]=readmask(f);else e.need=readmask(f);p.ev.push_back(e);}for(int i=0;i<=n;i++){int k;f>>k;vector<Need>v;while(k--){Need r;f>>r.col;r.mask=readmask(f);v.push_back(r);}p.live.push_back(v);}int k;f>>k;while(k--){array<int,3>a;f>>a[0]>>a[1]>>a[2];p.outs.push_back(a);}return p;}
struct Key{vector<int>r;int flag;unsigned done=0;bool operator==(const Key&o)const{return flag==o.flag&&done==o.done&&r==o.r;}};
struct KH{size_t operator()(const Key&a)const{U h=a.flag+a.done*1000003ULL;for(int x:a.r)h=(h^x)*0x9e3779b97f4a7c15ULL;return h^(h>>32);}};
struct Node{Key key;int cost=0,parent=-1,op=-1,d=-1,s=-1;double rank=0;};
struct Search{
 Problem &p;int cap,width,maxregs,maxcols;vector<Col>cols;unordered_map<Col,int,CH>ci;vector<Flag>flags;unordered_map<Flag,int,FH>fi;
 vector<vector<int>>covercache;vector<int>baseids;vector<vector<int>>futureFull;vector<int>futureCmp;
 uint64_t generated=0,candidates=0,cmptried=0,kept=0;bool limited=false,early=false;int peak=0,blank;array<int,5>goalids{};vector<vector<Node>>history;double secondsLimit=10;clock_t beganClock;
 Search(Problem&problem,int c,int w,int r,int mc):p(problem),cap(c),width(w),maxregs(r),maxcols(mc){for(auto &v:p.base)baseids.push_back(intern(v));Col b;for(auto&v:b)v=ALL;blank=intern(b);Flag f;f.un=ALL;fli(f);covercache.resize(p.ev.size()+1);futureCmp.resize(p.ev.size()+1);futureFull.resize(p.ev.size()+1);set<int>ff;int nc=0;for(int i=p.ev.size()-1;i>=0;i--){if(p.ev[i].op==1)nc++;else if(!p.ev[i].deleted&&p.ev[i].need==ALL)ff.insert(baseids[p.ev[i].target]);futureCmp[i]=nc;futureFull[i]=vector<int>(ff.begin(),ff.end());}}
 int intern(const Col&c){auto it=ci.find(c);if(it!=ci.end())return it->second;int id=cols.size();cols.push_back(c);ci.emplace(c,id);return id;}
 int fli(const Flag&f){auto[it,n]=fi.emplace(f,flags.size());if(n)flags.push_back(f);return it->second;}
 bool match(const Col&a,const Col&b,const Mask&m){for(int w=0;w<W;w++)for(int b0=0;b0<3;b0++)if((a[b0][w]^b[b0][w])&m[w])return false;return true;}
 int cover(int pos,int id){auto&c=covercache[pos];if(id>=(int)c.size())c.resize(id+1,-1);int&v=c[id];if(v>=0)return v;v=0;for(int k=0;k<(int)p.live[pos].size();k++)if(match(cols[id],p.base[p.live[pos][k].col],p.live[pos][k].mask))v|=1<<k;return v;}
 int goal(int id){for(int j=0;j<5;j++)if(goalids[j]==id)return j;return -1;}
 bool lower(const Node&n,int pos){int needed=0;for(int id:futureFull[pos]){int g=early?goal(id):-1;if(g>=0&&(n.key.done>>g&1))continue;if(!binary_search(n.key.r.begin(),n.key.r.end(),id))needed++;}return n.cost+futureCmp[pos]+needed<=cap;}
 double score(Node&n,int pos){int current=0,future=0;for(auto id:n.key.r){current+=__builtin_popcount((unsigned)cover(pos,id));for(int q=pos+1;q<=(int)p.ev.size();q++)future+=__builtin_popcount((unsigned)cover(q,id));}return n.cost*10000.0-current*20-future*0.02-n.key.r.size()*0.1;}
 Flag comparison(int a,int b){Flag f;for(int w=0;w<W;w++){U eq=ALL[w],lt=0,gt=0;for(int k=2;k>=0;k--){lt|=eq&~cols[a][k][w]&cols[b][k][w];gt|=eq&cols[a][k][w]&~cols[b][k][w];eq&=~(cols[a][k][w]^cols[b][k][w]);}U un=(cols[a][0][w]&cols[a][1][w]&cols[a][2][w])|(cols[b][0][w]&cols[b][1][w]&cols[b][2][w]);if(a==b&&a!=blank){}f.un[w]=un;f.lt[w]=lt&~un;f.gt[w]=gt&~un;}return f;}
 Mask cond(const Flag&f,int op){Mask m;for(int w=0;w<W;w++)m[w]=op==2?f.lt[w]:op==3?ALL[w]&~(f.gt[w]|f.un[w]):op==4?f.gt[w]:ALL[w]&~(f.lt[w]|f.un[w]);return m;}
 bool cmpok(const Event&e,const Flag&f){for(int c=0;c<4;c++){auto m=cond(f,c+2);for(int w=0;w<W;w++)if(((m[w]^e.expected[c][w])|f.un[w])&e.cmask[c][w])return false;}return true;}
 bool makecol(const Event&e,int d,int s,int op,const Flag&f,Col&v){
  if(op==0)v=cols[s];else {auto m=cond(f,op);for(int w=0;w<W;w++){U diff=0;for(int b=0;b<3;b++)diff|=cols[d][b][w]^cols[s][b][w];U un=f.un[w]&diff;for(int b=0;b<3;b++)v[b][w]=((cols[d][b][w]&~m[w])|(cols[s][b][w]&m[w])|un)&ALL[w];}}
  return match(v,p.base[e.target],e.need);
 }
 bool solve(const string&prefix){beganClock=clock();for(auto o:p.outs)goalids[o[1]]=baseids[o[2]];Node initial;initial.key.flag=0;for(int i=0;i<5;i++)initial.key.r.push_back(baseids[i]);sort(initial.key.r.begin(),initial.key.r.end());history.push_back({initial});
 for(int pos=0;pos<(int)p.ev.size();pos++){
  vector<Node>next;unordered_map<Key,int,KH>dedup;
  auto add=[&](Node n){generated++;sort(n.key.r.begin(),n.key.r.end());if(early){for(int id:n.key.r){int g=goal(id);if(g>=0)n.key.done|=1u<<g;}if(pos+1==(int)p.ev.size()&&n.key.done!=31)return;}if(n.cost>cap||!lower(n,pos+1))return;auto[it,inserted]=dedup.emplace(n.key,next.size());if(!inserted){if(next[it->second].cost>n.cost)next[it->second]=move(n);return;}next.push_back(move(n));};
  for(int ni=0;ni<(int)history.back().size();ni++){
   if(!(ni&127)&&secondsLimit>0&&double(clock()-beganClock)/CLOCKS_PER_SEC>secondsLimit){limited=true;cerr<<"CPU_LIMIT pos="<<pos<<"\n";return false;}
   const auto&old=history.back()[ni];Event e=p.ev[pos];int targetCover=(1<<p.live[pos+1].size())-1;if(early){for(int k=0;k<(int)p.live[pos+1].size();k++){int g=goal(baseids[p.live[pos+1][k].col]);if(g>=0&&(old.key.done>>g&1))targetCover&=~(1<<k);}int g=e.op==1?-1:goal(baseids[e.target]);if(g>=0&&(old.key.done>>g&1))e.need={};}Node n=old;n.parent=ni;n.op=-1;n.d=n.s=-1;const auto&r=old.key.r;int nr=r.size();int cv=0;vector<int>cv0(nr);for(int i=0;i<nr;i++)cv|=cv0[i]=cover(pos+1,r[i]);
   // Skips are permitted only at write events. Comparisons keep their order.
   if(e.op!=1&&(cv&targetCover)==targetCover){bool have=e.deleted;for(int id:r)have|=match(cols[id],p.base[e.target],e.need);if(have)add(n);}
   if(e.deleted)continue;
   if(old.cost+1+futureCmp[pos+1]>cap)continue;
   if(e.op==1){if((cv&targetCover)!=targetCover)continue;unordered_set<int>seen;for(int a=0;a<nr;a++)for(int b=0;b<=a;b++){cmptried++;Flag f=a==b?Flag{}:comparison(r[a],r[b]);Flag rev=f;swap(rev.lt,rev.gt);if(!cmpok(e,f)&&!cmpok(e,rev))continue;int fid=fli(f);if(!seen.insert(fid).second)continue;n=old;n.parent=ni;n.cost++;n.op=1;n.d=a;n.s=b;n.key.flag=fid;add(n);}continue;}
   vector<int>without(nr+1,cv);for(int d=0;d<nr;d++){int v=0;for(int i=0;i<nr;i++)if(i!=d)v|=cv0[i];without[d]=v;}
   const Flag f=flags[old.key.flag];
   for(int d=0;d<=nr;d++){if(d==nr&&nr>=maxregs)continue;if(d<nr&&d&&r[d]==r[d-1])continue;int did=d==nr?blank:r[d];int missing=targetCover&~without[d];
    for(int s=0;s<nr;s++){if(s&&r[s]==r[s-1])continue;if(d==s)continue;for(int op:{0,2,3,4,5}){candidates++;Col v;if(!makecol(e,did,r[s],op,f,v))continue;if(v==cols[did]&&d<nr)continue;
      bool ok=true;for(int k=0;k<(int)p.live[pos+1].size();k++)if(missing>>k&1){auto&need=p.live[pos+1][k];if(!match(v,p.base[need.col],need.mask)){ok=false;break;}}if(!ok)continue;
      int id=intern(v);n=old;n.parent=ni;n.cost++;n.op=op;n.d=d;n.s=s;if(d==nr)n.key.r.push_back(id);else n.key.r[d]=id;add(n);
    }}
   }
   if((int)cols.size()>maxcols||next.size()>2000000){limited=true;cerr<<"RESOURCE_LIMIT pos="<<pos<<" columns="<<cols.size()<<" states="<<next.size()<<"\n";return false;}
   // Bound temporary layer memory as well as retained beam memory.
   if(width&&next.size()>size_t(width)*40){limited=true;for(auto&z:next)z.rank=score(z,pos+1);nth_element(next.begin(),next.begin()+width*10,next.end(),[](const Node&a,const Node&b){return a.rank<b.rank;});next.resize(width*10);dedup.clear();for(int k=0;k<(int)next.size();k++)dedup[next[k].key]=k;}
  }
  peak=max(peak,(int)next.size());
  if(width&&(int)next.size()>width){limited=true;for(auto&n:next)n.rank=score(n,pos+1);nth_element(next.begin(),next.begin()+width,next.end(),[](const Node&a,const Node&b){return a.rank<b.rank;});next.resize(width);}
  kept+=next.size();cout<<"LAYER "<<p.name<<" pos="<<pos<<" states="<<next.size()<<" columns="<<cols.size()<<" generated="<<generated<<"\n";cout.flush();history.push_back(move(next));if(history.back().empty())return false;
 }
 int best=0;for(int i=1;i<(int)history.back().size();i++)if(history.back()[i].cost<history.back()[best].cost)best=i;
 emit(prefix+"_"+p.name+".s",best);return true;
 }
 void emit(const string&path,int best){vector<Node>trace(p.ev.size());for(int t=p.ev.size()-1;t>=0;t--){trace[t]=history[t+1][best];best=trace[t].parent;}
  ofstream f(path);int k=0;for(auto&n:trace)k+=n.op>=0;f<<"# n=5 model=out iset=I1 source=w1-round3-masked-reuse k="<<k<<"\n";vector<pair<int,int>>rr;for(int i=0;i<5;i++)rr.push_back({baseids[i],i});sort(rr.begin(),rr.end());int fresh=5;const char*names[]={"mov","cmp","cmovl","cmovle","cmovg","cmovge"};auto rn=[](int r){return string(r<5?"P":"S")+to_string(r<5?r:r-5);};
  unsigned outputDone=0;for(int pos=0;pos<=(int)p.ev.size();pos++){if(!early)for(auto o:p.outs)if(o[0]==pos){int id=baseids[o[2]],r=-1;for(auto[c,reg]:rr)if(cols[c]==cols[id]){r=reg;break;}assert(r>=0);f<<"out "<<o[1]<<", "<<rn(r)<<"\n";}if(pos==(int)p.ev.size())break;auto n=trace[pos];if(n.op<0)continue;int d=n.d,s=n.s;int rd=d==(int)rr.size()?fresh++:rr[d].second,rs=rr[s].second;f<<names[n.op]<<" "<<rn(rd)<<", "<<rn(rs)<<"\n";
   if(n.op!=1){Col v;auto e=p.ev[pos];e.need={};int did=d==(int)rr.size()?blank:rr[d].first;int fid=history[pos][n.parent].key.flag;bool ok=makecol(e,did,rr[s].first,n.op,flags[fid],v);assert(ok);int id=intern(v);if(d==(int)rr.size())rr.push_back({id,rd});else rr[d]={id,rd};sort(rr.begin(),rr.end());if(early){int g=goal(id);if(g>=0&&!(outputDone>>g&1)){f<<"out "<<g<<", "<<rn(rd)<<"\n";outputDone|=1u<<g;}}}
  }if(early)assert(outputDone==31);cout<<"CANDIDATE file="<<path<<" k="<<k<<"\n";
 }
};
double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+1e-6*r.ru_utime.tv_usec+r.ru_stime.tv_sec+1e-6*r.ru_stime.tv_usec;}
int main(int argc,char**argv){int cap=argc>1?atoi(argv[1]):31,width=argc>2?atoi(argv[2]):2000,first=argc>3?atoi(argv[3]):0,last=argc>4?atoi(argv[4]):143,maxregs=argc>5?atoi(argv[5]):12,maxcols=argc>6?atoi(argv[6]):1000000;string prefix=argc>7?argv[7]:"round3/candidate";int mode=argc>8?atoi(argv[8]):0;double limit=argc>9?atof(argv[9]):10;string input=argc>10?argv[10]:"round3/problems.txt";ifstream f(input);int np;f>>np;for(int i=0;i<np;i++){Problem original=readproblem(f);if(i<first||i>=last)continue;vector<int>deletions={-1};if(mode==1||mode==3||mode==22){deletions.clear();set<int>goals;for(auto o:original.outs)goals.insert(o[2]);int lastcmp=-1;for(int j=0;j<(int)original.ev.size();j++){auto&e=original.ev[j];if(e.op==1){lastcmp=j;continue;}if(goals.count(e.target))continue;bool copy=e.op==0;if(e.op>=2){copy=true;assert(lastcmp>=0);for(int w=0;w<W;w++)if(e.need[w]&~original.ev[lastcmp].expected[e.op-2][w])copy=false;}if(mode!=22||copy)deletions.push_back(j);}}else if(mode==4||mode==5){deletions.clear();set<Col>goals,seen;for(auto o:original.outs)goals.insert(original.base[o[2]]);for(int id=0;id<(int)original.base.size();id++){if(mode==5&&id>=5)break;if(goals.count(original.base[id])||!seen.insert(original.base[id]).second)continue;bool used=false;for(auto&live:original.live)for(auto n:live)if(n.col==id)used=true;if(used)deletions.push_back(id);}}
 for(int deletion:deletions){Problem p=original;if(deletion>=0&&(mode==1||mode==3||mode==22)){int id=p.ev[deletion].target;p.ev[deletion].deleted=true;for(auto&live:p.live)live.erase(remove_if(live.begin(),live.end(),[&](Need n){return n.col==id;}),live.end());}else if(mode==4||mode==5){Col waived=p.base[deletion];for(auto&live:p.live)live.erase(remove_if(live.begin(),live.end(),[&](Need n){return p.base[n.col]==waived;}),live.end());for(auto&e:p.ev)if(e.op!=1&&p.base[e.target]==waived)e.need={};}
 if(mode==9||mode==10||mode==19||mode==20||mode==22){for(auto&e:p.ev)if(e.op==1)e.cmask={};}
 if(mode==2||mode==3||mode==10||mode==20||mode==21||mode==22){for(int pos=0;pos<=(int)p.ev.size();pos++){auto&live=p.live[pos];set<int>needed;for(auto o:p.outs)if(o[0]==pos)needed.insert(o[2]);live.erase(remove_if(live.begin(),live.end(),[&](Need n){return !needed.count(n.col);}),live.end());}}
 double began=cpu();Search s(p,cap,width,maxregs,maxcols);s.early=mode>=19;s.secondsLimit=limit;bool yes=s.solve(prefix+"_d"+to_string(deletion));cout<<"RESULT index="<<i<<" name="<<p.name<<" deletion="<<deletion<<" mode="<<mode<<" status="<<(yes?"CANDIDATE":s.limited?"LIMIT":"NONE")<<" truncated="<<s.limited<<" generated="<<s.generated<<" kept="<<s.kept<<" peak="<<s.peak<<" columns="<<s.cols.size()<<" flags="<<s.flags.size()<<" write_candidates="<<s.candidates<<" cmp_candidates="<<s.cmptried<<" cpu="<<cpu()-began<<"\n";cout.flush();if(yes&&cap<=31)return 0;}}
 return 0;}
