#define main unused_local_main
#include "../../src/local.cpp"
#undef main
#include <sys/resource.h>

template<int W> void execute(const Machine<W>&m,State<W>&x,const vector<I>&p,int a){for(int t=a;t<(int)p.size();t++)m.step(x,p[t]);}
void emit(const vector<I>&p,const Machine<9>&m,string file){
  ofstream o(file);o<<"# n=5 model=out iset=I1 source=w6-round3 k="<<p.size()<<"\n";auto x=m.init;
  for(auto i:p){int old=x.done;m.step(x,i);o<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if((old^x.done)>>j&1)o<<"out "<<j<<", "<<reg(i.d)<<"\n";}
}
int main(int argc,char**argv){
  if(argc<4){cerr<<"neighbours seed prefix mode [delete/one/two]\n";return 1;}
  int used;auto p=readp(argv[1],used);int nr=used+1;string prefix=argv[2],mode=argv[3];
  vector<array<int,5>>all,sub;for(int c=0;c<3125;c++){int q=c,mask=0;array<int,5>a;for(int j=0;j<5;j++)a[j]=q%5,q/=5,mask|=1<<a[j];if(!(mask&(mask+1)))all.push_back(a);}
  for(int t=0;t<32;t++)sub.push_back(all[(t*173+19)%541]);
  Machine<1>sm;Machine<9>fm;sm.setup(sub,nr);fm.setup(all,nr);
  vector<State<1>>pre(p.size()+1);pre[0]=sm.init;for(int t=0;t<(int)p.size();t++){pre[t+1]=pre[t];sm.step(pre[t+1],p[t]);}
  uint64_t tried=0,filtered=0,full=0;int best=99999,saved=0;bool hit=false;
  struct N {int e,fail;uint64_t h;vector<I> p;};vector<N> neighbours;
  auto score=[&](const vector<I>&q){
    auto x=fm.init;array<int,5>be;array<Col<9>,5>bc;be.fill(99999);uint64_t h=1469598103934665603ULL;
    auto consider=[&](int r){for(int j=0;j<5;j++){int e=0;for(int w=0;w<9;w++){uint64_t dif=0;for(int b=0;b<3;b++)dif|=x.r[r].b[b][w]^fm.goal[j].b[b][w];e+=__builtin_popcountll(dif);}if(e<be[j])be[j]=e,bc[j]=x.r[r];}};
    for(int r=0;r<nr;r++)consider(r);
    for(auto i:q){if(i.o==CMP){auto a=x.r[i.d],b=x.r[i.s];if(memcmp(&a,&b,sizeof(a))>0)swap(a,b);for(int w=0;w<9;w++)for(int bit=0;bit<3;bit++)h=(h^a.b[bit][w])*1099511628211ULL,h=(h^b.b[bit][w])*1099511628211ULL;}
      fm.step(x,i);if(i.o!=CMP)consider(i.d);}
    int error=accumulate(be.begin(),be.end(),0),fail=0;for(int w=0;w<9;w++){uint64_t dif=0;for(int j=0;j<5;j++)for(int bit=0;bit<3;bit++)dif|=bc[j].b[bit][w]^fm.goal[j].b[bit][w];fail+=__builtin_popcountll(dif);}
    if(error==0){emit(q,fm,prefix+"_PASS_candidate.s");hit=true;}
    if(error>60)return;
    for(auto &n:neighbours)if(n.h==h){if(error<n.e)n={error,fail,h,q};return;}
    neighbours.push_back({error,fail,h,q});sort(neighbours.begin(),neighbours.end(),[](const N&a,const N&b){return tie(a.e,a.fail)<tie(b.e,b.fail);});if(neighbours.size()>24)neighbours.pop_back();
  };
  auto check=[&](const vector<I>&q,bool force,string name){
    auto x=fm.init;execute(fm,x,q,0);full++;
    if(x.done==31){emit(q,fm,name+"_PASS_candidate.s");hit=true;cerr<<"CANDIDATE file="<<name<<"_PASS_candidate.s\n";return;}
    auto e=nearfile(q,fm,name+".s",force?99999:best);if(e.first<best){best=e.first;saved++;cerr<<"BEST error="<<best<<" fail="<<e.second<<" file="<<name<<".s\n";}
  };
  if(mode=="delete"){
    for(int d=0;d<(int)p.size();d++)if(p[d].o>=L){auto q=p;q.erase(q.begin()+d);tried++;check(q,true,prefix+"_del"+to_string(d));}
  }else{
    vector<I>alphabet;for(int o=0;o<6;o++)for(int d=0;d<nr;d++)for(int s=0;s<nr;s++)if(d!=s)alphabet.push_back({o,d,s});
    int nc=count_if(p.begin(),p.end(),[](I i){return i.o==CMP;});
    for(int a=0;a<(int)p.size()&&!hit;a++)for(auto ia:alphabet){
      int ca=nc+(ia.o==CMP)-(p[a].o==CMP);if(ca<7||ca>8)continue;
      auto q=p;q[a]=ia;auto x=pre[a];sm.step(x,ia);
      if(mode=="scoreone"){
        tried++;score(q);
      }else if(mode=="one"){
        tried++;execute(sm,x,q,a+1);if(x.done!=31)continue;filtered++;check(q,false,prefix+"_one"+to_string(a));
      }else{
        for(int b=a+1;b<(int)p.size()&&!hit;b++){
          for(auto ib:alphabet){
            int cb=ca+(ib.o==CMP)-(p[b].o==CMP);if(cb<7||cb>8)continue;
            auto y=x;sm.step(y,ib);execute(sm,y,p,b+1);tried++;if(y.done!=31)continue;filtered++;
            q[b]=ib;check(q,false,prefix+"_two"+to_string(a)+"_"+to_string(b));q[b]=p[b];if(hit)break;
          }
          sm.step(x,p[b]);
        }
      }
    }
  }
  for(int n=0;n<(int)neighbours.size();n++){auto &v=neighbours[n];string f=prefix+"_neighbour"+to_string(n)+".s";nearfile(v.p,fm,f,99999);cout<<"NEIGHBOUR index="<<n<<" error="<<v.e<<" fail="<<v.fail<<" hash="<<hex<<v.h<<dec<<" file="<<f<<"\n";}
  cout<<"SUMMARY mode="<<mode<<" tried="<<tried<<" filtered="<<filtered<<" full="<<full<<" best_error="<<best<<" saved="<<saved<<" hit="<<hit<<"\n";
}
