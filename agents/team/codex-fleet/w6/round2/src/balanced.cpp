#define main unused_local_main
#include "../../src/local.cpp"
#undef main
#include <sys/resource.h>
// Stochastic search with the independent bit-plane evaluator.
// Search cases: all 120 strict orders plus 40 weak orders. Validate zero scores
// on all 541 weak orders before saving or accepting a zero-score program.
struct Snap {State<3> st;array<int,5> best;};
Machine<3> sm;Machine<9> fm;
int nr;
inline void score_update(Snap& x,int r){
  for(int j=0;j<5;j++)if(x.best[j]){
    int e=0;for(int w=0;w<3;w++){uint64_t dif=0;for(int b=0;b<3;b++)dif|=x.st.r[r].b[b][w]^sm.goal[j].b[b][w];e+=__builtin_popcountll(dif);}
    x.best[j]=min(x.best[j],e);
  }
}
inline void step(Snap&x,I i){sm.step(x.st,i);if(i.o!=CMP)score_update(x,i.d);}
inline int cost(Snap&x){return accumulate(x.best.begin(),x.best.end(),0);}
bool fullcheck(const vector<I>&p){auto x=fm.init;for(auto i:p)if(i.o>=0)fm.step(x,i);return x.done==31;}
uint64_t statehash(const vector<I>&p){uint64_t h=1469598103934665603ULL;for(auto i:p)if(i.o>=0)h=(h^(i.o*1024+i.d*32+i.s))*1099511628211ULL;return h;}
void emit(const vector<I>&p,string path){ofstream out(path);int k=0;for(auto i:p)k+=i.o>=0;out<<"# n=5 model=out iset=I1 source=w6-packed k="<<k<<"\n";auto x=fm.init;for(auto i:p)if(i.o>=0){int old=x.done;fm.step(x,i);out<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if((x.done^old)>>j&1)out<<"out "<<j<<", "<<reg(i.d)<<"\n";}}
void emitnear(const vector<I>&p,string path){
  array<int,5>best,bt,br;best.fill(10000);bt.fill(-1);br.fill(0);array<Col<9>,5>bc;
  auto x=fm.init;
  auto consider=[&](int t,int r){for(int j=0;j<5;j++){int e=0;for(int w=0;w<9;w++){uint64_t d=0;for(int b=0;b<3;b++)d|=x.r[r].b[b][w]^fm.goal[j].b[b][w];e+=__builtin_popcountll(d);}if(e<best[j])best[j]=e,bt[j]=t,br[j]=r,bc[j]=x.r[r];}};
  for(int r=0;r<nr;r++)consider(-1,r);for(int t=0;t<(int)p.size();t++)if(p[t].o>=0){fm.step(x,p[t]);if(p[t].o!=CMP)consider(t,p[t].d);}
  int fail=0;for(int w=0;w<9;w++){uint64_t d=0;for(int j=0;j<5;j++)for(int b=0;b<3;b++)d|=bc[j].b[b][w]^fm.goal[j].b[b][w];fail+=__builtin_popcountll(d);}
  ofstream out(path);int k=0;for(auto i:p)k+=i.o>=0;out<<"# n=5 model=out iset=I1 source=w6-packed-near k="<<k<<" weak_fail="<<fail<<" weak_error_sum="<<accumulate(best.begin(),best.end(),0)<<"\n";
  for(int j=0;j<5;j++)if(bt[j]==-1)out<<"out "<<j<<", "<<reg(br[j])<<"\n";
  for(int t=0;t<(int)p.size();t++){auto i=p[t];if(i.o>=0)out<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if(bt[j]==t)out<<"out "<<j<<", "<<reg(br[j])<<"\n";}
  cerr<<"NEAR weak_fail="<<fail<<" weak_error_sum="<<accumulate(best.begin(),best.end(),0)<<" file="<<path<<"\n";
}
double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+1e-6*r.ru_utime.tv_usec+r.ru_stime.tv_sec+1e-6*r.ru_stime.tv_usec;}
int main(int argc,char**argv){
  if(argc<8){cerr<<"packed seed.s prefix slots temperature lambda cpu-seconds seed [maxcmp=8]\n";return 1;}
  string prefix=argv[2];int slots=atoi(argv[3]),maxcmp=argc>8?atoi(argv[8]):8;double temp=atof(argv[4]),lam=atof(argv[5]),limit=atof(argv[6]);mt19937_64 rng(strtoull(argv[7],nullptr,10));
  int used;auto start=readp(argv[1],used);nr=used+2;
  vector<vector<I>> archive;
  for(auto entry:filesystem::directory_iterator("verified"))if(entry.path().extension()==".s") {
    int used2;auto q=readp(entry.path(),used2);nr=max(nr,used2+2);archive.push_back(q);
  }
  for(auto entry:filesystem::directory_iterator("round2/verified"))if(entry.path().extension()==".s") {
    int used2;auto q=readp(entry.path(),used2);nr=max(nr,used2+2);archive.push_back(q);
  }
  vector<array<int,5>>all,sub;for(int c=0;c<3125;c++){int q=c,mask=0;array<int,5>a;for(int j=0;j<5;j++)a[j]=q%5,q/=5,mask|=1<<a[j];if(!(mask&(mask+1)))all.push_back(a);}
  for(auto a:all){auto s=a;sort(s.begin(),s.end());if(s==array<int,5>{0,1,2,3,4})sub.push_back(a);}
  for(int i=0;i<40;i++)sub.push_back(all[(173*i+19)%541]);
  sm.setup(sub,nr);fm.setup(all,nr);Snap initial;initial.st=sm.init;initial.best.fill(sub.size());for(int r=0;r<nr;r++)score_update(initial,r);
  if(!fullcheck(start)){cerr<<"seed is not correct on independent evaluator\n";return 2;}
  // If slots are too short, start with the least damaging single deletion.
  if((int)start.size()>slots){int be=99999;vector<I>bp;for(int a=0;a<(int)start.size();a++){auto q=start;q.erase(q.begin()+a);Snap x=initial;for(auto i:q)step(x,i);int e=cost(x);if(e<be)be=e,bp=q;}start=bp;cerr<<"initial deletion error="<<be<<"\n";}
  start.resize(slots,I{-1,0,0});vector<I>cur=start,prop;vector<Snap>snap(slots+1);snap[0]=initial;
  auto build=[&](int from){for(int i=from;i<slots;i++){snap[i+1]=snap[i];if(cur[i].o>=0)step(snap[i+1],cur[i]);}};build(0);
  auto length=[](const vector<I>&p){int l=0;for(auto i:p)l+=i.o>=0;return l;};
  auto fitness=[](const Snap&x){double f=0;for(int e:x.best)f+=e+0.05*e*e;return f;};
  double cc=fitness(snap[slots])+lam*length(cur);int best=999,besterr=cost(snap[slots]);uint64_t iterations=0,accepted=0,valid=0;set<uint64_t>seen;
  if(besterr)emitnear(cur,prefix+"_near.s");
  auto randins=[&](){int d=rng()%nr,s=rng()%(nr-1);if(s>=d)s++;return I{int(rng()%6),d,s};};
  
  auto signature=[&](const vector<I>&p){
    auto st=sm.init;uint64_t h=1469598103934665603ULL;
    for(auto i:p)if(i.o>=0){
      if(i.o==CMP) {
        // Symmetric operands, same value signature regardless of register names.
        auto a=st.r[i.d],b=st.r[i.s];
        if(memcmp(&a,&b,sizeof(a))>0)swap(a,b);
        for(int bit=0;bit<3;bit++)for(int w=0;w<3;w++) {
          h=(h^a.b[bit][w])*1099511628211ULL;
          h=(h^b.b[bit][w])*1099511628211ULL;
        }
      }
      sm.step(st,i);
    }return h;
  };
  unordered_map<uint64_t,uint64_t> visits;
  set<uint64_t> structural;
  for(auto q:archive)structural.insert(signature(q));
  uint64_t curhash=signature(cur);double novelty=argc>9?atof(argv[9]):4.;
  uint64_t resets=0,newstructures=0;
  double begun=cpu();
  for(;;iterations++){
    if(!(iterations&4095)&&cpu()-begun>limit)break;
    if(iterations && iterations%1000000==0){
      start=archive[rng()%archive.size()];
      // Explore 31-slot and 33-slot states, and permit distant restarts.
      while((int)start.size()>slots){
        vector<vector<I>> deletions;vector<double> weights;
        double minimum=1e9;
        for(int k=0;k<(int)start.size();k++) {
          auto q=start;q.erase(q.begin()+k);Snap x=initial;for(auto i:q)if(i.o>=0)step(x,i);
          double f=fitness(x);minimum=min(minimum,f);deletions.push_back(q);weights.push_back(f);
        }
        for(auto &f:weights)f=exp(-(f-minimum)/(temp*8));
        discrete_distribution<int> pick(weights.begin(),weights.end());start=deletions[pick(rng)];
      }
      start.resize(slots,I{-1,0,0});cur=start;build(0);
      cc=fitness(snap[slots])+lam*length(cur);curhash=signature(cur);resets++;
    }
    prop=cur;int a=rng()%slots,b=rng()%slots,lo=a,mv=rng()%100;
    if(mv<20){if(prop[a].o<0)prop[a]=randins();else prop[a].o=rng()%6;}
    else if(mv<42){if(prop[a].o<0)continue;if(rng()&1)prop[a].d=rng()%nr;else prop[a].s=rng()%nr;}
    else if(mv<50){prop[a]=randins();}
    else if(mv<58){prop[a].o=prop[a].o<0?int(rng()%6):-1;}
    else if(mv<66){swap(prop[a],prop[b]);lo=min(a,b);}
    else if(mv<74){auto q=prop[a];if(a<b)rotate(prop.begin()+a,prop.begin()+a+1,prop.begin()+b+1);else if(a>b)rotate(prop.begin()+b,prop.begin()+a,prop.begin()+a+1);prop[b]=q;lo=min(a,b);}
    else if(mv<84){int x=rng()%nr,y=rng()%nr;if(x==y)continue;for(int k=a;k<slots;k++){if(prop[k].d==x)prop[k].d=y;else if(prop[k].d==y)prop[k].d=x;if(prop[k].s==x)prop[k].s=y;else if(prop[k].s==y)prop[k].s=x;}}
    else if(mv<90){if(prop[a].o!=CMP)continue;swap(prop[a].d,prop[a].s);for(int k=a+1;k<slots&&prop[k].o!=CMP;k++)if(prop[k].o>=L)prop[k].o=prop[k].o==L?G:prop[k].o==G?L:prop[k].o==LE?GE:LE;}
    else if(mv<96) {prop[a]=randins();prop[b]=randins();lo=min(a,b);}
    else {
      // Change a comparison operand and several associated selects together.
      vector<int> cmp;for(int j=0;j<slots;j++)if(prop[j].o==CMP)cmp.push_back(j);
      if(cmp.empty())continue;a=cmp[rng()%cmp.size()];lo=a;
      if(rng()&1)prop[a].d=rng()%nr;else prop[a].s=rng()%nr;
      int end=a+1;while(end<slots&&prop[end].o!=CMP)end++;
      for(int j=a+1;j<end;j++)if(prop[j].o>=L && (rng()%2)) {
        if(rng()&1)prop[j].o=L+rng()%4;else prop[j].s=rng()%nr;
      }
    }
    int nc=0;for(auto i:prop)nc+=i.o==CMP;if(nc>maxcmp||nc<7)continue;
    Snap x=snap[lo];for(int k=lo;k<slots;k++)if(prop[k].o>=0)step(x,prop[k]);int e=cost(x),len=length(prop);double pc=fitness(x)+lam*len;
    uint64_t ph=0;
    double novelty_cur=0,novelty_prop=0;
    if(cost(snap[slots])==0)novelty_cur=novelty*log1p(visits[curhash]);
    if(e==0){ph=signature(prop);novelty_prop=novelty*log1p(visits[ph]);}
    double u=(rng()>>11)*(1./9007199254740992.);
    if(pc+novelty_prop>cc+novelty_cur&&u>=exp((cc+novelty_cur-pc-novelty_prop)/temp))continue;
    if(e==0&&!fullcheck(prop))continue;
    cur=prop;cc=pc;accepted++;build(lo);if(!e){curhash=ph;visits[ph]++;}
    if(e<besterr){besterr=e;cerr<<"ERROR "<<e<<" iteration="<<iterations<<"\n";emitnear(cur,prefix+"_near.s");}
    if(!e){valid++;
      if(structural.insert(curhash).second){
        newstructures++;
        string path=prefix+"_structure_"+to_string(newstructures)+".s";
        emit(cur,path);
        if(len<=32&&archive.size()<3000)archive.push_back(cur);
        cout<<"STRUCTURE k="<<len<<" iteration="<<iterations<<" file="<<path<<"\n";cout.flush();
      }
      auto q=cur;
      if(len<best||valid%1000==1){
        // Deletion checks use all 541 weak orders and unknown initial scratch.
        for(int a=0;a<slots;a++)if(q[a].o>=0){auto old=q[a];q[a].o=-1;if(!fullcheck(q))q[a]=old;}
        int reduced=length(q);
        if(reduced<best){best=reduced;string path=prefix+"_k"+to_string(reduced)+".s";emit(q,path);cout<<"CANDIDATE k="<<reduced<<" iteration="<<iterations<<" file="<<path<<"\n";cout.flush();}
        if(reduced<=31)break;
      }
      if(len<=32&&valid%100000==1&&seen.insert(statehash(q)).second){string path=prefix+"_sample_"+to_string(seen.size())+".s";emit(q,path);}
    }
    if(!(iterations&1048575)){cerr<<"STATUS iterations="<<iterations<<" accepted="<<accepted<<" error="<<e<<" best="<<best<<" cpu="<<cpu()-begun<<"\n";}
  }
  cout<<"SUMMARY iterations="<<iterations<<" accepted="<<accepted<<" correct_visits="<<valid<<" best="<<best<<" best_error="<<besterr<<" cpu="<<cpu()-begun<<" newstructures="<<newstructures<<" resets="<<resets<<" archive="<<archive.size()<<" samples="<<seen.size()<<"\n";
}
