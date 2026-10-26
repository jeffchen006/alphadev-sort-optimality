#define main unused_main
#include "bitplanes.cpp"
#undef main
#include <sys/resource.h>
// Search a merge of a sorted pair P0<=P1 and triple P2<=P3<=P4.
// Scores use ten strict orders. Zero scores must pass all 76 sorted weak orders.
struct Snap { State<9> st; array<int,5> err; };
Machine<9> sm; Machine<9> fm;
int nr; vector<I> fixedprefix; Machine<9> basefm;
void update(Snap &x,int r) {
  for(int j=0;j<5;j++) {
    int error=0;for(int w=0;w<9;w++){uint64_t d=0;for(int b=0;b<3;b++)d|=x.st.r[r].b[b][w]^sm.goal[j].b[b][w];error+=__builtin_popcountll(d);}
    x.err[j]=min(x.err[j],error);
  }
}
void step(Snap&x,I i){if(i.o<0)return;sm.step(x.st,i);if(i.o!=CMP)update(x,i.d);}
int score(const Snap&x){return accumulate(x.err.begin(),x.err.end(),0);}
double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+1e-6*r.ru_utime.tv_usec+r.ru_stime.tv_sec+1e-6*r.ru_stime.tv_usec;}
bool full(const vector<I>&p){auto x=fm.init;for(auto i:p)if(i.o>=0)fm.step(x,i);return x.done==31;}
void emit(vector<I>p,string path){ofstream f(path);f<<"# n=5 model=out iset=I1 source=w9-integrated-prefix\n";auto x=basefm.init;auto q=fixedprefix;q.insert(q.end(),p.begin(),p.end());for(auto i:q)if(i.o>=0){int old=x.done;basefm.step(x,i);f<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if((x.done^old)>>j&1)f<<"out "<<j<<", "<<reg(i.d)<<"\n";}}

int main(int argc,char**argv){
  if(argc<7){cerr<<"merge_search seed output slots regs seconds rngseed [temp=.25] [duplicates=0]\n";return 1;}
  int used;auto seed=readp(argv[1],used);string output=argv[2];int slots=atoi(argv[3]);nr=atoi(argv[4]);double seconds=atof(argv[5]),temp=argc>7?atof(argv[7]):.25;int dup=argc>8?atoi(argv[8]):0;mt19937_64 rng(strtoull(argv[6],nullptr,10));
  vector<array<int,5>>cases,strict;
  for(int code=0;code<3125;code++){int q=code,m=0;array<int,5>a;for(int i=0;i<5;i++)a[i]=q%5,q/=5,m|=1<<a[i];if(m&(m+1))continue;cases.push_back(a);if(m==31)strict.push_back(a);}
  sm.setup(cases,nr);fm.setup(cases,nr);
  int split=0,ncmp=0;
  for(;split<(int)seed.size();split++)if(seed[split].o==CMP&&++ncmp==5)break;
  fixedprefix.assign(seed.begin(),seed.begin()+split);seed.erase(seed.begin(),seed.begin()+split);
  slots=31-split;cout<<"PREFIX k="<<split<<" slots="<<slots<<" regs="<<nr<<"\n";cout.flush();
  ofstream pf(output+"_prefix.s");for(auto i:fixedprefix)pf<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";pf.close();
  basefm=fm;
  for(auto i:fixedprefix){sm.step(sm.init,i);fm.step(fm.init,i);}
  // Failing seeds are allowed in this full-weak-order repair search.
  Snap initial;initial.st=sm.init;initial.err.fill(541);for(int r=0;r<nr;r++)update(initial,r);for(int j=0;j<5;j++)if(sm.init.done>>j&1)initial.err[j]=0;
  auto evaluate=[&](const vector<I>&p){auto x=initial;for(auto i:p)step(x,i);return score(x);};
  vector<vector<I>>starts;
  if((int)seed.size()>slots){for(int i=0;i<(int)seed.size();i++)if(seed[i].o!=CMP){auto q=seed;q.erase(q.begin()+i);q.resize(slots,I{-1,0,0});starts.push_back(q);}}else{seed.resize(slots,I{-1,0,0});starts.push_back(seed);}
  vector<I>cur,prop,bestp;vector<Snap>sn(slots+1);sn[0]=initial;int best=999,e=999;long long it=0,accepted=0,zeros=0,restarts=0;double begin=cpu();auto wallstart=chrono::steady_clock::now();
  auto build=[&](int lo){for(int i=lo;i<slots;i++){sn[i+1]=sn[i];step(sn[i+1],cur[i]);}};
  auto randins=[&](){int d=rng()%nr,s=rng()%nr;return I{int(rng()%6),d,s};};
  for(;;it++){
    if(!(it&65535)&&(cpu()-begin>=seconds || chrono::duration<double>(chrono::steady_clock::now()-wallstart).count()>=120))break;
    if(cur.empty()||rng()%300000==0){cur=starts[rng()%starts.size()];build(0);e=score(sn.back());restarts++;}
    prop=cur;int a=rng()%slots,b=rng()%slots,lo=a,mv=rng()%100;
    if(mv<23){if(prop[a].o<0)prop[a]=randins();else if(rng()&1)prop[a].d=rng()%nr;else prop[a].s=rng()%nr;}
    else if(mv<40){if(prop[a].o<0)prop[a]=randins();else prop[a].o=rng()%6;}
    else if(mv<50){prop[a]=randins();}
    else if(mv<62){swap(prop[a],prop[b]);lo=min(a,b);}
    else if(mv<70){if(a<b)rotate(prop.begin()+a,prop.begin()+a+1,prop.begin()+b+1);else if(b<a)rotate(prop.begin()+b,prop.begin()+a,prop.begin()+a+1);lo=min(a,b);}
    else if(mv<81){int x=rng()%nr,y=rng()%nr;for(int k=a;k<slots;k++){if(prop[k].d==x)prop[k].d=y;else if(prop[k].d==y)prop[k].d=x;if(prop[k].s==x)prop[k].s=y;else if(prop[k].s==y)prop[k].s=x;}}
    else if(mv<89){if(prop[a].o!=CMP)continue;swap(prop[a].d,prop[a].s);for(int k=a+1;k<slots&&prop[k].o!=CMP;k++)if(prop[k].o>=L)prop[k].o=prop[k].o==L?G:prop[k].o==G?L:prop[k].o==LE?GE:LE;}
    else if(mv<95){prop[a]=randins();prop[b]=randins();lo=min(a,b);}
    else prop[a].o=prop[a].o<0?int(rng()%6):-1;
    int nc=0;for(auto i:prop)nc+=i.o==CMP;if(nc!=4)continue;
    auto x=sn[lo];for(int k=lo;k<slots;k++)step(x,prop[k]);int ne=score(x);
    if(ne>e&&(rng()>>11)*(1./9007199254740992.)>=exp((e-ne)/temp))continue;
    if(!ne){zeros++;if(!full(prop))continue;emit(prop,output+"_merge.s");cout<<"CANDIDATE slots="<<slots<<" iter="<<it<<" cpu="<<cpu()-begin<<"\n";break;}
    cur=prop;e=ne;accepted++;build(lo);
    if(e<best){best=e;bestp=cur;cerr<<"BEST "<<e<<" iter="<<it<<" cpu="<<cpu()-begin<<"\n";ofstream f(output+"_near.txt");for(auto i:cur)if(i.o>=0)f<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";}
  }
  cout<<"SUMMARY iterations="<<it<<" accepted="<<accepted<<" strict_zeros="<<zeros<<" best_errors="<<best<<" restarts="<<restarts<<" cpu="<<cpu()-begin<<" cases="<<cases.size()<<"\n";
}
