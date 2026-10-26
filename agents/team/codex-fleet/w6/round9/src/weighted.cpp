// Weighted full-case search. Unknown value 7 is conservative scratch data.
#define main unused_local_main
#include "../../src/local.cpp"
#undef main
#include <sys/resource.h>
#include <csignal>
using Mask = array<uint64_t,9>;
static volatile sig_atomic_t stopping=0;
static void stop(int){stopping=1;}
static double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+r.ru_stime.tv_sec+1e-6*(r.ru_utime.tv_usec+r.ru_stime.tv_usec);}
struct Snapshot {
  State<9> state;
  array<Mask,5> error{};
  array<int,5> weighted{},raw{},time{},source{};
};
struct Metrics {int fail=0,errors=0,focus_fail=0,median_error=0,median_lost=0;double fitness=0;};
Machine<9> machine;
Mask focus{};
int nr,focus_weight=4,median_weight=2,lost_weight=4;
bool memory_model;
Mask difference(const Col<9>&a,const Col<9>&b){Mask m;for(int w=0;w<9;w++)m[w]=(a.b[0][w]^b.b[0][w])|(a.b[1][w]^b.b[1][w])|(a.b[2][w]^b.b[2][w]);return m;}
int count(const Mask&m){int n=0;for(auto x:m)n+=__builtin_popcountll(x);return n;}
int weighted_count(const Mask&m){int n=0;for(int w=0;w<9;w++)n+=__builtin_popcountll(m[w])+(focus_weight-1)*__builtin_popcountll(m[w]&focus[w]);return n;}
void consider(Snapshot&x,int r,int t){
  for(int j=0;j<5;j++)if(x.weighted[j]){
    auto m=difference(x.state.r[r],machine.goal[j]);int c=weighted_count(m);
    bool take=c<x.weighted[j];
    if(c==x.weighted[j]){
      Mask old{},next{};
      for(int w=0;w<9;w++){for(int z=0;z<5;z++)if(z!=j)old[w]|=x.error[z][w];next[w]=old[w]|m[w];old[w]|=x.error[j][w];}
      take=weighted_count(next)<weighted_count(old);
    }
    if(take){x.weighted[j]=c;x.error[j]=m;x.raw[j]=count(m);x.time[j]=t;x.source[j]=r;}
  }
}
void step(Snapshot&x,I i,int t){machine.step(x.state,i);if(i.o!=CMP&&!memory_model)consider(x,i.d,t);}
Snapshot initial(){
  Snapshot x;x.state=machine.init;x.weighted.fill(100000);x.raw.fill(541);x.time.fill(-1);x.source.fill(0);
  for(int j=0;j<5;j++)for(int w=0;w<9;w++)x.error[j][w]=machine.mask[w];
  if(!memory_model)for(int r=0;r<nr;r++)consider(x,r,-1);
  return x;
}
Metrics metrics(const Snapshot&x){
  auto errors=x.error;auto raw=x.raw;
  if(memory_model)for(int j=0;j<5;j++){errors[j]=difference(x.state.r[j],machine.goal[j]);raw[j]=count(errors[j]);}
  Metrics m;Mask any{},lost=errors[2];
  for(int w=0;w<9;w++)for(int j=0;j<5;j++)any[w]|=errors[j][w];
  // Once a value disappears from every cell, later moves cannot recreate it.
  // In the out model an earlier chosen median snapshot also preserves it.
  for(int r=0;r<nr;r++){auto d=difference(x.state.r[r],machine.goal[2]);for(int w=0;w<9;w++)lost[w]&=d[w];}
  m.fail=count(any);m.errors=accumulate(raw.begin(),raw.end(),0);m.median_error=raw[2];m.median_lost=count(lost);
  for(int w=0;w<9;w++)m.focus_fail+=__builtin_popcountll(any[w]&focus[w]);
  m.fitness=weighted_count(any)+median_weight*m.median_error+lost_weight*m.median_lost+0.001*m.errors;
  return m;
}
Snapshot execute(const vector<I>&p){auto x=initial();for(int t=0;t<(int)p.size();t++)if(p[t].o>=0)step(x,p[t],t);return x;}
string regname(int r){return reg(r);}
void emit(const vector<I>&p,const string&path){
  auto x=execute(p);auto m=metrics(x);int length=0;for(auto i:p)length+=i.o>=0;
  ofstream f(path);f<<"# n=5 model="<<(memory_model?"mem":"out")<<" iset=I1 source=w6-round9 length="<<length
    <<" weak_fail="<<m.fail<<" weak_error_sum="<<m.errors<<" focus_fail="<<m.focus_fail
    <<" median_error="<<m.median_error<<" median_lost="<<m.median_lost<<" fitness="<<setprecision(12)<<m.fitness<<"\n";
  if(!memory_model)for(int j=0;j<5;j++)if(x.time[j]==-1)f<<"out "<<j<<", "<<regname(x.source[j])<<"\n";
  for(int t=0;t<(int)p.size();t++){
    auto i=p[t];if(i.o>=0)f<<names[i.o]<<" "<<regname(i.d)<<", "<<regname(i.s)<<"\n";
    if(!memory_model)for(int j=0;j<5;j++)if(x.time[j]==t)f<<"out "<<j<<", "<<regname(x.source[j])<<"\n";
  }
}
uint64_t hashp(const vector<I>&p){uint64_t h=1469598103934665603ULL;for(auto i:p)if(i.o>=0)h=(h^(i.o*1024+i.d*32+i.s))*1099511628211ULL;return h;}
bool legal(I i){if(i.o<0)return true;if(i.d<0||i.d>=nr||i.s<0||i.s>=nr)return false;if(!memory_model)return true;return i.o==MOV?!(i.d<5&&i.s<5):i.d>=5&&i.s>=5;}
int main(int argc,char**argv){
  if(argc!=11){cerr<<"weighted seed.s prefix out|mem seconds random-seed temperature focus-weight median-weight lost-weight extra-registers\n";return 1;}
  signal(SIGTERM,stop);signal(SIGINT,stop);
  string prefix=argv[2];memory_model=string(argv[3])=="mem";double seconds=atof(argv[4]),temperature=atof(argv[6]);
  mt19937_64 rng(strtoull(argv[5],nullptr,10));focus_weight=atoi(argv[7]);median_weight=atoi(argv[8]);lost_weight=atoi(argv[9]);
  int used;auto seed=readp(argv[1],used);nr=used+atoi(argv[10]);assert(nr<=24);int slots=memory_model?41:31;
  if(seconds==0)slots=seed.size();
  assert((int)seed.size()==slots);for(auto i:seed)assert(legal(i));
  vector<array<int,5>> cases;
  for(int c=0;c<3125;c++){int q=c,mask=0;array<int,5>a;for(int j=0;j<5;j++)a[j]=q%5,q/=5,mask|=1<<a[j];if(!(mask&(mask+1)))cases.push_back(a);}
  machine.setup(cases,nr);
  auto sx=execute(seed);if(memory_model){for(int j=0;j<5;j++)sx.error[j]=difference(sx.state.r[j],machine.goal[j]);}
  for(int w=0;w<9;w++)for(int j=0;j<5;j++)focus[w]|=sx.error[j][w];
  cerr<<"CONFIG mode="<<(memory_model?"mem":"out")<<" slots="<<slots<<" registers="<<nr<<" focus_count="<<count(focus)<<" focus_weight="<<focus_weight<<" median_weight="<<median_weight<<" lost_weight="<<lost_weight<<" temperature="<<temperature<<"\n";
  cerr<<"FOCUS inputs=";for(int t=0;t<541;t++)if(focus[t/64]>>(t%64)&1){for(auto a:cases[t])cerr<<a;cerr<<",";}cerr<<"\n";
  vector<I>cur=seed,prop;vector<Snapshot>snap(slots+1);snap[0]=initial();
  auto rebuild=[&](int lo){for(int t=lo;t<slots;t++){snap[t+1]=snap[t];if(cur[t].o>=0)step(snap[t+1],cur[t],t);}};
  rebuild(0);auto current=metrics(snap.back());auto best=current;double bestfitness=current.fitness;
  emit(cur,prefix+"_best_fail.s");emit(cur,prefix+"_best_objective.s");
  vector<pair<double,vector<I>>> archive{{bestfitness,seed}};unordered_set<uint64_t>archivehash{hashp(seed)},lowhash;int lowfiles=0;
  auto randomins=[&](){I i;do{i={int(rng()%6),int(rng()%nr),int(rng()%nr)};}while(!legal(i));return i;};
  uint64_t iterations=0,accepted=0,resets=0,positive=0;double began=cpu(),laststatus=began;
  while(true){
    if(!(iterations&4095)){
      double now=cpu();if(now-began>=seconds||stopping)break;
      if(now-laststatus>=20){cerr<<"STATUS iterations="<<iterations<<" accepted="<<accepted<<" fail="<<current.fail<<" focus="<<current.focus_fail<<" median_lost="<<current.median_lost<<" fitness="<<current.fitness<<" best_fail="<<best.fail<<" best_fitness="<<bestfitness<<" cpu="<<now-began<<"\n";laststatus=now;}
    }
    ++iterations;
    if(iterations%2000000==0){cur=archive[rng()%archive.size()].second;rebuild(0);current=metrics(snap.back());resets++;}
    prop=cur;int a=rng()%slots,b=rng()%slots,lo=a,mv=rng()%100;
    if(mv<15){if(prop[a].o<0)prop[a]=randomins();else prop[a].o=rng()%6;}
    else if(mv<36){if(prop[a].o<0)continue;if(rng()&1)prop[a].d=rng()%nr;else prop[a].s=rng()%nr;}
    else if(mv<44)prop[a]=randomins();
    else if(mv<50){if(prop[a].o<0)prop[a]=randomins();else prop[a].o=-1;}
    else if(mv<59){swap(prop[a],prop[b]);lo=min(a,b);}
    else if(mv<67){if(a<b)rotate(prop.begin()+a,prop.begin()+a+1,prop.begin()+b+1);else if(a>b)rotate(prop.begin()+b,prop.begin()+a,prop.begin()+a+1);lo=min(a,b);}
    else if(mv<75){int x=rng()%nr,y=rng()%nr;if(x==y)continue;for(int t=a;t<slots;t++){if(prop[t].d==x)prop[t].d=y;else if(prop[t].d==y)prop[t].d=x;if(prop[t].s==x)prop[t].s=y;else if(prop[t].s==y)prop[t].s=x;}}
    else if(mv<82){if(prop[a].o!=CMP)continue;swap(prop[a].d,prop[a].s);for(int t=a+1;t<slots&&prop[t].o!=CMP;t++)if(prop[t].o>=L)prop[t].o=prop[t].o==L?G:prop[t].o==G?L:prop[t].o==LE?GE:LE;}
    else if(mv<90){prop[a]=randomins();prop[b]=randomins();lo=min(a,b);}
    else{
      vector<int>comparisons;for(int t=0;t<slots;t++)if(prop[t].o==CMP)comparisons.push_back(t);if(comparisons.empty())continue;
      a=comparisons[rng()%comparisons.size()];lo=a;
      if(rng()&1)prop[a].d=rng()%nr;else prop[a].s=rng()%nr;
      for(int t=a+1;t<slots&&prop[t].o!=CMP;t++)if(prop[t].o>=L&&(rng()&1)){if(rng()&1)prop[t].o=L+rng()%4;else prop[t].s=rng()%nr;}
    }
    bool ok=true;int comparisons=0;for(auto i:prop){ok&=legal(i);comparisons+=i.o==CMP;}if(!ok||comparisons<7||comparisons>10)continue;
    auto x=snap[lo];for(int t=lo;t<slots;t++)if(prop[t].o>=0)step(x,prop[t],t);auto candidate=metrics(x);
    // Each restart changes heat; all weak orders keep positive objective weight.
    double heat=temperature*array<double,4>{0.5,1.,2.,4.}[(resets/3)%4];
    double u=(rng()>>11)*(1./9007199254740992.);
    if(candidate.fitness>current.fitness&&u>=exp((current.fitness-candidate.fitness)/heat))continue;
    cur=move(prop);current=candidate;accepted++;rebuild(lo);
    if(pair(current.fail,current.errors)<pair(best.fail,best.errors)){best=current;emit(cur,prefix+"_best_fail.s");cerr<<"BEST_FAIL fail="<<best.fail<<" errors="<<best.errors<<" iteration="<<iterations<<"\n";}
    bool improved=current.fitness<bestfitness;
    if(improved){bestfitness=current.fitness;emit(cur,prefix+"_best_objective.s");cerr<<"BEST_OBJECTIVE fitness="<<bestfitness<<" fail="<<current.fail<<" iteration="<<iterations<<"\n";}
    if((improved||accepted%4096==0)&&current.fitness<=archive.back().first+4&&archivehash.insert(hashp(cur)).second){
      archive.push_back({current.fitness,cur});stable_sort(archive.begin(),archive.end(),[](auto&a,auto&b){return a.first<b.first;});
      if(archive.size()>128){archivehash.erase(hashp(archive.back().second));archive.pop_back();}
    }
    if(current.fail<=6&&lowfiles<3000&&lowhash.insert(hashp(cur)).second)emit(cur,prefix+"_le6_"+to_string(++lowfiles)+".s");
    if(current.fail==0){emit(cur,prefix+"_zero.s");positive++;break;}
  }
  cout<<"SUMMARY iterations="<<iterations<<" accepted="<<accepted<<" resets="<<resets<<" archive="<<archive.size()<<" best_fail="<<best.fail<<" best_error="<<best.errors<<" best_fitness="<<setprecision(12)<<bestfitness<<" lowfiles="<<lowfiles<<" zero_candidates="<<positive<<" cpu="<<cpu()-began<<"\n";
}
