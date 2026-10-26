// Enumerate two write deletions and one write insertion.
// The case filters are exact concrete executions. Scratch=7, initial flags=eq.
// Every strictly correct program must pass these necessary filters.
#define main old_local_main
#include "../../src/local.cpp"
#undef main

template<int W> struct QState {
  Col<W> r[16];
  uint64_t lt[W]{},gt[W]{};
  int done=0;
};
template<int W> struct Concrete {
  int nr;
  uint64_t mask[W]{};
  Col<W> goal[5];
  QState<W> init{};
  Concrete(const vector<array<int,5>>& cases,int nreg):nr(nreg) {
    for(int t=0;t<(int)cases.size();t++) {
      int w=t/64; uint64_t bit=1ULL<<(t%64);mask[w]|=bit;
      for(int r=0;r<nr;r++)for(int b=0;b<3;b++)
        if(((r<5?cases[t][r]:7)>>b)&1)init.r[r].b[b][w]|=bit;
      auto a=cases[t];sort(a.begin(),a.end());
      for(int j=0;j<5;j++)for(int b=0;b<3;b++)if(a[j]>>b&1)goal[j].b[b][w]|=bit;
    }
    for(int r=0;r<nr;r++)match(init,r);
  }
  inline void match(QState<W>&x,int r)const {
    for(int j=0;j<5;j++)if(!(x.done>>j&1)) {
      uint64_t d=0;
      for(int w=0;w<W;w++)for(int b=0;b<3;b++)d|=x.r[r].b[b][w]^goal[j].b[b][w];
      if(!d)x.done|=1<<j;
    }
  }
  inline void step(QState<W>&x,I i)const {
    auto&a=x.r[i.d];auto&b=x.r[i.s];
    if(i.o==MOV){a=b;match(x,i.d);return;}
    if(i.o==CMP){
      for(int w=0;w<W;w++){
        uint64_t eq=mask[w],lt=0,gt=0;
        for(int k=2;k>=0;k--){lt|=eq&~a.b[k][w]&b.b[k][w];gt|=eq&a.b[k][w]&~b.b[k][w];eq&=~(a.b[k][w]^b.b[k][w]);}
        x.lt[w]=lt;x.gt[w]=gt;
      }
      return;
    }
    for(int w=0;w<W;w++){
      uint64_t mv=i.o==L?x.lt[w]:i.o==LE?(mask[w]&~x.gt[w]):i.o==G?x.gt[w]:(mask[w]&~x.lt[w]);
      for(int k=0;k<3;k++)a.b[k][w]=(a.b[k][w]&~mv)|(b.b[k][w]&mv);
    }
    match(x,i.d);
  }
  QState<W> run(const vector<I>&p)const{auto x=init;for(auto i:p)step(x,i);return x;}
};

vector<array<int,5>> allcases(){
  vector<array<int,5>>all;
  for(int c=0;c<3125;c++){
    int q=c,mask=0;array<int,5>a;
    for(int j=0;j<5;j++)a[j]=q%5,q/=5,mask|=1<<a[j];
    if(!(mask&(mask+1)))all.push_back(a);
  }
  return all;
}
void emit(const vector<I>&p,const Concrete<9>&m,string path){
  ofstream o(path);o<<"# n=5 model=out iset=I1 source=w6-round4 k="<<p.size()<<"\n";
  auto x=m.init;
  for(int j=0;j<5;j++)if(x.done>>j&1)for(int r=0;r<m.nr;r++){
    if(memcmp(&x.r[r],&m.goal[j],sizeof(Col<9>))==0){o<<"out "<<j<<", "<<reg(r)<<"\n";break;}
  }
  for(auto i:p){int old=x.done;m.step(x,i);o<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";
    for(int j=0;j<5;j++)if((x.done^old)>>j&1)o<<"out "<<j<<", "<<reg(i.d)<<"\n";
  }
}

struct Counts {uint64_t tried=0,filtered=0,full=0,hits=0;};
struct Search {
  vector<I>p;
  Concrete<1>sm;
  Concrete<9>fm;
  string prefix;
  Counts c;
  int best_error=99999,best_fail=99999;
  Search(vector<I>program,int nr,const vector<array<int,5>>&sub,const vector<array<int,5>>&all,string name)
    :p(program),sm(sub,nr),fm(all,nr),prefix(name){}
  void accept(const vector<I>&q){
    c.filtered++;
    auto y=fm.run(q);c.full++;
    if(y.done!=31){save_near(q);return;}
    string path=prefix+"_candidate"+to_string(c.hits++)+".s";
    emit(q,fm,path);
    cout<<"CANDIDATE file="<<path<<"\n"<<flush;
  }
  void save_near(const vector<I>&q){
    array<int,5>be,bt,br;array<Col<9>,5>bc;be.fill(9999);auto x=fm.init;
    auto consider=[&](int t,int r){for(int j=0;j<5;j++){
      int e=0;for(int w=0;w<9;w++){uint64_t dif=0;for(int k=0;k<3;k++)dif|=x.r[r].b[k][w]^fm.goal[j].b[k][w];e+=__builtin_popcountll(dif);}
      if(e<be[j])be[j]=e,bt[j]=t,br[j]=r,bc[j]=x.r[r];
    }};
    for(int r=0;r<fm.nr;r++)consider(-1,r);
    for(int t=0;t<(int)q.size();t++){fm.step(x,q[t]);if(q[t].o!=CMP)consider(t,q[t].d);}
    int e=accumulate(be.begin(),be.end(),0),f=0;
    for(int w=0;w<9;w++){uint64_t dif=0;for(int j=0;j<5;j++)for(int k=0;k<3;k++)dif|=bc[j].b[k][w]^fm.goal[j].b[k][w];f+=__builtin_popcountll(dif);}
    if(tie(e,f)>=tie(best_error,best_fail))return;
    best_error=e;best_fail=f;
    ofstream o(prefix+"_near.s");
    o<<"# n=5 model=out iset=I1 source=w6-round4-concrete k="<<q.size()<<" weak_error_sum="<<e<<" weak_fail="<<f<<"\n";
    for(int j=0;j<5;j++)if(bt[j]==-1)o<<"out "<<j<<", "<<reg(br[j])<<"\n";
    for(int t=0;t<(int)q.size();t++){
      auto i=q[t];o<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";
      for(int j=0;j<5;j++)if(bt[j]==t)o<<"out "<<j<<", "<<reg(br[j])<<"\n";
    }
    cout<<"NEAR file="<<prefix<<"_near.s error="<<e<<" failed_orders="<<f<<"\n"<<flush;
  }
  void insertions(const vector<I>&base,const vector<int>&slots,const vector<I>&alphabet){
    auto x=sm.init;
    int last=0;
    for(int t:slots){
      for(;last<t;last++)sm.step(x,base[last]);
      for(auto ins:alphabet){
        auto y=x;sm.step(y,ins);
        for(int i=t;i<(int)base.size();i++)sm.step(y,base[i]);
        c.tried++;
        if(y.done!=31)continue;
        vector<I>q=base;q.insert(q.begin()+t,ins);accept(q);
      }
    }
  }
  void deletion2(bool flags,bool allslots,bool anycmp=false,bool allowmov=false){
    vector<I>alphabet;
    for(int op=0;op<6;op++)if(op!=CMP&&(!flags||allowmov||op!=MOV))
      for(int d=0;d<sm.nr;d++)for(int s=0;s<sm.nr;s++)if(d!=s)alphabet.push_back({op,d,s});
    vector<int>writes;
    for(int t=0;t<(int)p.size();t++)if(p[t].o!=CMP)writes.push_back(t);
    for(int ai=0;ai<(int)writes.size();ai++)for(int bi=ai+1;bi<(int)writes.size();bi++){
      int a=writes[ai],b=writes[bi];
      vector<I>q=p;q.erase(q.begin()+b);q.erase(q.begin()+a);
      vector<int>slots;
      if(!flags||allslots){for(int t=0;t<=(int)q.size();t++)slots.push_back(t);}
      else {slots={a,b-1};if(a==b-1)slots.pop_back();}
      if(!flags){insertions(q,slots,alphabet);continue;}
      for(int t:slots){
        vector<int>cmps;
        if(anycmp){for(int i=0;i<(int)q.size();i++)if(q[i].o==CMP)cmps.push_back(i);}
        else{
          int ci=t-1;while(ci>=0&&q[ci].o!=CMP)ci--;
          if(ci>=0)cmps.push_back(ci);
        }
        for(int ci:cmps){
          I orig=q[ci];
          for(int d=0;d<sm.nr;d++)for(int s=0;s<sm.nr;s++){
            if(d==orig.d&&s==orig.s)continue;
            q[ci]={CMP,d,s};insertions(q,{t},alphabet);
          }
          q[ci]=orig;
        }
      }
    }
  }
  // Additional edit patterns involving a comparison deletion or insertion.
  // Skip the write-only pattern already covered by deletion2(false,...).
  void comparisons2(){
    vector<I>all,cmponly;
    for(int op=0;op<6;op++)for(int d=0;d<sm.nr;d++)for(int s=0;s<sm.nr;s++)if(d!=s||op==CMP){
      all.push_back({op,d,s});if(op==CMP)cmponly.push_back({op,d,s});
    }
    for(int a=0;a<(int)p.size();a++)for(int b=a+1;b<(int)p.size();b++){
      vector<I>q=p;q.erase(q.begin()+b);q.erase(q.begin()+a);
      vector<int>slots;for(int t=0;t<=(int)q.size();t++)slots.push_back(t);
      insertions(q,slots,(p[a].o==CMP||p[b].o==CMP)?all:cmponly);
    }
  }
};

#ifndef W6SEARCH_NO_MAIN
int main(int argc,char**argv){
  if(argc<6){cerr<<"search manifest part parts mode prefix [max-seeds]\n";return 1;}
  ifstream files(argv[1]);int part=atoi(argv[2]),parts=atoi(argv[3]);string mode=argv[4],prefix=argv[5];
  int maxseeds=argc>6?atoi(argv[6]):99999;
  auto all=allcases();vector<array<int,5>>sub;
  for(int t=0;t<64;t++)sub.push_back(all[(173*t+19)%541]);
  string path;Counts total;int n=0,done=0;auto began=clock();
  while(getline(files,path)){
    if(path.empty()||n++%parts!=part)continue;
    if(done>=maxseeds)break;
    int nr;auto p=readp(path,nr);nr++;
    if(nr>16)throw runtime_error("register bound");
    Search s(p,nr,sub,all,prefix+"_seed"+to_string(n-1));
    if(s.fm.run(p).done!=31)throw runtime_error("seed fails concrete control: "+path);
    auto start=clock();
    if(mode=="control"){
      emit(p,s.fm,s.prefix+"_control.s");
      cout<<"CONTROL source="<<path<<" regs="<<nr<<"\n"<<flush;
    }else if(mode=="cmp2")s.comparisons2();
    else s.deletion2(mode!="delete2",mode=="flagsall",mode=="flagsany",mode=="flagswrites");
    done++;
    cout<<"SEED index="<<n-1<<" path="<<path<<" mode="<<mode<<" regs="<<nr
      <<" tried="<<s.c.tried<<" filtered="<<s.c.filtered<<" full="<<s.c.full<<" hits="<<s.c.hits
      <<" best_error="<<s.best_error<<" best_fail="<<s.best_fail
      <<" cpu="<<double(clock()-start)/CLOCKS_PER_SEC<<"\n"<<flush;
    total.tried+=s.c.tried;total.filtered+=s.c.filtered;total.full+=s.c.full;total.hits+=s.c.hits;
  }
  cout<<"SUMMARY mode="<<mode<<" seeds="<<done<<" tried="<<total.tried<<" filtered="<<total.filtered
    <<" full="<<total.full<<" hits="<<total.hits<<" cpu="<<double(clock()-began)/CLOCKS_PER_SEC<<"\n"<<flush;
}
#endif
