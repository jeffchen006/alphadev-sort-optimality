#define main legacy_main
#include "../../src/search.cpp"
#undef main
#include <bitset>
#include <unordered_set>
#include <sys/resource.h>
struct Column {bitset<541> bad;int at,reg;};
unordered_set<string> lists;
uint64_t tested=0,nearcount=0,kept=0;
array<uint64_t,542> hist{};
vector<Column> options[5];
array<Column,5> output;
bool choose(int j,bitset<541> bad){
  if(j==5)return true;
  sort(options[j].begin(),options[j].end(),[&](const Column&a,const Column&b){return (a.bad|bad).count()<(b.bad|bad).count();});
  for(const auto &x:options[j]){auto next=bad|x.bad;if(next.count()>20)continue;output[j]=x;if(choose(j+1,next))return true;}return false;
}
void evaluate(const Prog&p,const string&prefix,int seed,const string&kind){
  tested++;
  alignas(16) uint8_t r[NR][544],goal[5][544],f[544];
  for(int t=0;t<544;t++){auto a=orders[min(t,540)],b=a;sort(b.begin(),b.end());for(int j=0;j<NR;j++)r[j][t]=j<5?a[j]:7;for(int j=0;j<5;j++)goal[j][t]=b[j];f[t]=0;}
  for(auto &x:options)x.clear();
  auto record=[&](int at,int reg){
    for(int j=0;j<5;j++){
      Column col{};col.at=at;col.reg=reg;int errors=0;
      for(int t=0;t<544;t+=16){
        int mask=(~_mm_movemask_epi8(_mm_cmpeq_epi8(_mm_load_si128((__m128i*)(r[reg]+t)),_mm_load_si128((__m128i*)(goal[j]+t)))))&65535;
        if(t==528)mask&=8191;
        errors+=__builtin_popcount(mask);if(errors>20)break;
        while(mask){int b=__builtin_ctz(mask);col.bad.set(t+b);mask&=mask-1;}
      }
      if(errors>20)continue;
      bool dominated=false;for(auto &x:options[j])if((x.bad&~col.bad).none()){dominated=true;break;}if(dominated)continue;
      auto &v=options[j];v.erase(remove_if(v.begin(),v.end(),[&](const Column&x){return (col.bad&~x.bad).none();}),v.end());v.push_back(col);
    }
  };
  for(int j=0;j<5;j++)record(-1,j);
  for(int at=0;at<(int)p.size();at++){
    auto x=p[at];for(int t=0;t<544;t+=16){
      __m128i a=_mm_load_si128((__m128i*)(r[x.d]+t)),b=_mm_load_si128((__m128i*)(r[x.s]+t)),z=_mm_setzero_si128(),one=_mm_set1_epi8(1),two=_mm_set1_epi8(2);
      if(x.o==MOV)_mm_store_si128((__m128i*)(r[x.d]+t),b);
      else if(x.o==CMP)_mm_store_si128((__m128i*)(f+t),_mm_or_si128(_mm_and_si128(_mm_cmpgt_epi8(b,a),one),_mm_and_si128(_mm_cmpgt_epi8(a,b),two)));
      else{auto fl=_mm_load_si128((__m128i*)(f+t));__m128i mask;
        if(x.o==L)mask=_mm_cmpeq_epi8(fl,one);else if(x.o==G)mask=_mm_cmpeq_epi8(fl,two);else mask=_mm_xor_si128(_mm_cmpeq_epi8(fl,x.o==LE?two:one),_mm_set1_epi8(-1));
        _mm_store_si128((__m128i*)(r[x.d]+t),_mm_blendv_epi8(a,b,mask));}
    }
    if(x.o!=CMP)record(at,x.d);
  }
  if(!choose(0,{}))return;
  bitset<541> bad;for(auto &x:output)bad|=x.bad;hist[bad.count()]++;nearcount++;
  string key;for(auto x:p)for(int z:{x.o,x.d,x.s})key+=char(z);
  if(!lists.insert(key).second)return;
  string file=prefix+"_"+to_string(kept++)+".s";ofstream os(file);
  os<<"# n=5 model=out iset=I1 source=w5-round6-"<<kind<<" seed="<<seed<<" failures="<<bad.count()<<" k="<<p.size()<<"\n";
  for(int j=0;j<5;j++)if(output[j].at<0)os<<"out "<<j<<", "<<regname(output[j].reg)<<"\n";
  for(int at=0;at<(int)p.size();at++){auto x=p[at];os<<names[x.o]<<" "<<regname(x.d)<<", "<<regname(x.s)<<"\n";for(int j=0;j<5;j++)if(output[j].at==at)os<<"out "<<j<<", "<<regname(output[j].reg)<<"\n";}
  ofstream meta(file+".json");meta<<"{\"seed\":"<<seed<<",\"kind\":\""<<kind<<"\",\"failing_orders\":[";bool comma=false;
  for(int t=0;t<541;t++)if(bad[t]){if(comma)meta<<",";comma=true;meta<<"[";for(int j=0;j<5;j++)meta<<(j?",":"")<<orders[t][j];meta<<"]";}meta<<"]}\n";
}
void predicates(Prog&p,int at,int end,const string&prefix,int seed){
  if(at==end){evaluate(p,prefix,seed,"flag");return;}
  auto old=p[at];for(int o:{MOV,L,LE,G,GE}){p[at].o=o;predicates(p,at+1,end,prefix,seed);}p[at]=old;
}
int main(int argc,char**argv){
  rlimit lim{2800ULL*1024*1024,2800ULL*1024*1024};setrlimit(RLIMIT_AS,&lim);init();ifstream files(argv[1]);string file;int seed=0;
  while(files>>file){auto p=read(file);
    if(argc>3&&string(argv[3])=="control"){evaluate(p,argv[2],seed,"control");break;}
    if(argc>3&&string(argv[3])=="pairs"){
      // Fuse two CMOV events at either original gap. The fused write can
      // target either original destination, take any available source, and
      // use any predicate or MOV. Later computations can change freely.
      for(int a=0;a<(int)p.size();a++)if(p[a].o>=L)for(int b=a+1;b<(int)p.size();b++)if(p[b].o>=L){
        Prog q;for(int i=0;i<(int)p.size();i++)if(i!=a&&i!=b)q.push_back(p[i]);
        for(int at:{a,b-1})for(int d:{p[a].d,p[b].d})for(int s=0;s<nreg+1;s++)for(int o:{MOV,L,LE,G,GE}){
          auto z=q;z.insert(z.begin()+at,{o,d,s});evaluate(z,argv[2],seed,"pair");
        }
      }
      printf("SEED index=%d tested=%llu near=%llu retained=%llu\n",seed,(unsigned long long)tested,(unsigned long long)nearcount,(unsigned long long)kept);fflush(stdout);seed++;continue;
    }
    for(int d=0;d<(int)p.size();d++){auto q=p;q.erase(q.begin()+d);evaluate(q,argv[2],seed,"delete");if(p[d].o==CMP){int end=d;while(end<(int)q.size()&&q[end].o!=CMP)end++;predicates(q,d,end,argv[2],seed);}}
    printf("SEED index=%d tested=%llu near=%llu retained=%llu\n",seed,(unsigned long long)tested,(unsigned long long)nearcount,(unsigned long long)kept);fflush(stdout);seed++;
  }
  printf("DONE seeds=%d tested=%llu near=%llu retained=%llu hist=",seed,(unsigned long long)tested,(unsigned long long)nearcount,(unsigned long long)kept);for(int i=0;i<=20;i++)printf("%s%d:%llu",i?",":"",i,(unsigned long long)hist[i]);puts("");
}
