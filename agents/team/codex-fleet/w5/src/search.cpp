// Independent simulator and correct-program neighbourhood search for sort5.
// SSE lanes hold separate rank inputs. Scratch = 7 is a necessary-condition
// filter. The final checker uses all 541 weak orders and conservative unknowns.
#include <immintrin.h>
#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <random>
#include <set>
#include <string>
#include <vector>
using namespace std;
enum {MOV,CMP,L,LE,G,GE};
const char* names[]={"mov","cmp","cmovl","cmovle","cmovg","cmovge"};
struct Ins {int o,d,s; bool operator==(const Ins&b)const{return o==b.o&&d==b.d&&s==b.s;}};
using Prog=vector<Ins>;
constexpr int NR=16;
struct alignas(16) Fast {__m128i r[NR],lt,gt; unsigned have;};
__m128i targets[5]; Fast initial;
vector<array<int,5>> orders;
uint64_t trials=0, filterpasses=0, fullchecks=0, accepted=0;
int nreg;
mt19937_64 rng;
Prog last_shorter;

void init() {
  for(int c=0;c<3125;c++) {
    int z=c,used=0; array<int,5> a;
    for(int i=0;i<5;i++){a[i]=z%5;z/=5;used|=1<<a[i];}
    if(!(used&(used+1)))orders.push_back(a);
  }
  vector<array<int,5>> perms; array<int,5> p={0,1,2,3,4};
  do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
  // Fixed broad filter: distinct values, duplicates, and both input directions.
  vector<array<int,5>> v;
  for(int i=0;i<12;i++)v.push_back(perms[(i*47)%120]);
  v.push_back({0,0,1,1,2});v.push_back({2,1,1,0,0});
  v.push_back({0,1,0,1,0});v.push_back({1,0,1,0,1});
  alignas(16) uint8_t b[16];
  for(int r=0;r<NR;r++){
    for(int t=0;t<16;t++)b[t]=r<5?v[t][r]:7;
    initial.r[r]=_mm_load_si128((__m128i*)b);
  }
  for(auto &a:v)sort(a.begin(),a.end());
  for(int j=0;j<5;j++){
    for(int t=0;t<16;t++)b[t]=v[t][j];
    targets[j]=_mm_load_si128((__m128i*)b);
  }
  initial.lt=initial.gt=_mm_setzero_si128();initial.have=0;
}
inline void faststep(Fast&st,Ins x){
  __m128i a=st.r[x.d],b=st.r[x.s],m;
  switch(x.o){
  case MOV:st.r[x.d]=b;break;
  case CMP:st.lt=_mm_cmpgt_epi8(b,a);st.gt=_mm_cmpgt_epi8(a,b);return;
  default:
    if(x.o==L)m=st.lt;else if(x.o==G)m=st.gt;
    else if(x.o==LE)m=_mm_xor_si128(st.gt,_mm_set1_epi8(-1));
    else m=_mm_xor_si128(st.lt,_mm_set1_epi8(-1));
    st.r[x.d]=_mm_blendv_epi8(a,b,m);
  }
  a=st.r[x.d];
  for(int j=0;j<5;j++)if(!(st.have&(1u<<j)))
    if(_mm_movemask_epi8(_mm_cmpeq_epi8(a,targets[j]))==65535)st.have|=1u<<j;
}
bool fastcheck(const Prog&p,int lo=0,const Fast*prefix=nullptr){
  Fast st=prefix?*prefix:initial;
  for(int i=lo;i<(int)p.size();i++)faststep(st,p[i]);
  return st.have==31;
}
struct FullResult {bool ok; array<int,5> at,reg;};
FullResult fullcheck(const Prog&p){
  fullchecks++;
  // Unknown=7. cmp with unknown produces unknown flag 3. Conditional writes
  // with unknown flags preserve only equal values. This is conservative.
  uint8_t r[NR][541], f[541], target[5][541];
  for(int t=0;t<541;t++){
    auto a=orders[t];auto b=a;sort(b.begin(),b.end());
    for(int j=0;j<NR;j++)r[j][t]=j<5?a[j]:7;
    for(int j=0;j<5;j++)target[j][t]=b[j]; f[t]=3;
  }
  FullResult out{};out.at.fill(-1);unsigned have=0;
  for(int i=0;i<(int)p.size();i++){
    Ins x=p[i];auto a=r[x.d],b=r[x.s];
    if(x.o==CMP){for(int t=0;t<541;t++)f[t]=x.d==x.s?0:(a[t]==7||b[t]==7)?3:a[t]<b[t]?1:a[t]>b[t]?2:0;continue;}
    if(x.o==MOV)memcpy(a,b,541);
    else for(int t=0;t<541;t++){
      if(f[t]==3){if(a[t]!=b[t])a[t]=7;}
      else if((x.o==L&&f[t]==1)||(x.o==G&&f[t]==2)||(x.o==LE&&f[t]!=2)||(x.o==GE&&f[t]!=1))a[t]=b[t];
    }
    for(int j=0;j<5;j++)if(!(have&(1u<<j))&&!memcmp(a,target[j],541)){
      have|=1u<<j;out.at[j]=i;out.reg[j]=x.d;
    }
  }
  out.ok=have==31;return out;
}
bool valid(const Prog&p){trials++;if(!fastcheck(p))return false;filterpasses++;return fullcheck(p).ok;}
string regname(int r){return r<5?"P"+to_string(r):"S"+to_string(r-5);}
void save(const Prog&p,const string&fn){
  auto q=fullcheck(p);if(!q.ok)abort();
  ofstream f(fn);f<<"# n=5 R=16 iset=I1 model=out source=w5 independent_search k="<<p.size()<<"\n";
  for(int i=0;i<(int)p.size();i++){
    auto x=p[i];f<<names[x.o]<<" "<<regname(x.d)<<", "<<regname(x.s)<<"\n";
    for(int j=0;j<5;j++)if(q.at[j]==i)f<<"out "<<j<<", "<<regname(q.reg[j])<<"\n";
  }
}
Prog read(const string&fn){
  ifstream f(fn);int k;f>>nreg>>k;Prog p;
  for(int i=0;i<k;i++){string op;int d,s;f>>op>>d>>s;int o=0;while(op!=names[o]&&o<5)o++;p.push_back({o,d,s});}
  return p;
}
vector<Ins> alphabet(int nr){vector<Ins>a;for(int o=0;o<6;o++)for(int d=0;d<nr;d++)for(int s=0;s<nr;s++)a.push_back({o,d,s});return a;}
uint64_t hashprog(const Prog&p){uint64_t h=1469598103934665603ULL;int mp[NR];fill(mp,mp+NR,-1);for(int i=0;i<5;i++)mp[i]=i;int nx=5;
  for(auto x:p){if(mp[x.d]<0)mp[x.d]=nx++;if(mp[x.s]<0)mp[x.s]=nx++;for(int a:{x.o,mp[x.d],mp[x.s]})h=(h^a)*1099511628211ULL;}return h;}
bool deletions(const Prog&p,const string&out){
  for(int i=0;i<(int)p.size();i++){Prog q=p;q.erase(q.begin()+i);if(valid(q)){last_shorter=q;string fn=out+"_delete_k"+to_string(q.size())+".s";save(q,fn);printf("CANDIDATE delete=%d k=%zu file=%s\n",i,q.size(),fn.c_str());return true;}}
  return false;
}
// All delete-two, insert-one neighbours, with noncontiguous deletions and
// insertion at each of the 31 gaps. No comparator or operand-order pruning.
bool repair(const Prog&p,int nr,const string&out,int shard,int nshard){
  auto alpha=alphabet(nr);int K=p.size();uint64_t before=trials;
  for(int i=0;i<K;i++)for(int j=i+1;j<K;j++){
    if((i*K+j)%nshard!=shard)continue;
    Prog base;for(int k=0;k<K;k++)if(k!=i&&k!=j)base.push_back(p[k]);
    Fast pre[96];pre[0]=initial;for(int k=0;k<K-2;k++){pre[k+1]=pre[k];faststep(pre[k+1],base[k]);}
    for(int pos=0;pos<=K-2;pos++)for(Ins x:alpha){
      trials++;Fast st=pre[pos];faststep(st,x);for(int k=pos;k<K-2;k++)faststep(st,base[k]);
      if(st.have!=31)continue;filterpasses++;
      Prog q=base;q.insert(q.begin()+pos,x);
      if(fullcheck(q).ok){last_shorter=q;string fn=out+"_repair_k"+to_string(q.size())+".s";save(q,fn);printf("CANDIDATE delete=%d,%d insert=%d,%s,%d,%d k=%zu file=%s\n",i,j,pos,names[x.o],x.d,x.s,q.size(),fn.c_str());return true;}
    }
  }
  printf("REPAIR k=%d nr=%d shard=%d/%d trials=%llu\n",K,nr,shard,nshard,(unsigned long long)(trials-before));fflush(stdout);return false;
}
// Delete a CMOV, then replace one CMP and one surviving CMOV. The CMP may
// compare arbitrary live registers. This changes the value/flag structure.
bool repair3(const Prog&p,int nr,const string&out,int shard,int nshard){
  vector<Ins> cmovs;for(auto x:alphabet(nr))if(x.o>=L)cmovs.push_back(x);
  int K=p.size();uint64_t before=trials;
  for(int del=0;del<K;del++){
    if(p[del].o<L||del%nshard!=shard)continue;
    Prog q=p;q.erase(q.begin()+del);
    Fast pre[96];pre[0]=initial;for(int i=0;i<K-1;i++){pre[i+1]=pre[i];faststep(pre[i+1],q[i]);}
    for(int ci=0;ci<K-1;ci++)if(q[ci].o==CMP){
      Ins oldcmp=q[ci];
      for(int d=0;d<nr;d++)for(int s=0;s<nr;s++){
        Ins cmp={CMP,d,s};if(cmp==oldcmp)continue;q[ci]=cmp;
        // Cache the modified prefix when the second repair lies after the CMP.
        Fast modified[96];modified[ci]=pre[ci];
        for(int i=ci;i<K-1;i++){modified[i+1]=modified[i];faststep(modified[i+1],q[i]);}
        for(int mi=0;mi<K-1;mi++)if(q[mi].o>=L){
          Ins old=q[mi];int lo=mi;
          for(auto x:cmovs){
            if(x==old)continue;trials++;q[mi]=x;
            if(!fastcheck(q,lo,mi>ci?&modified[lo]:&pre[lo]))continue;
            filterpasses++;
            if(fullcheck(q).ok){
              last_shorter=q;string fn=out+"_repair3_k"+to_string(q.size())+".s";save(q,fn);
              printf("CANDIDATE delete=%d cmp=%d cmov=%d k=%zu file=%s\n",del,ci,mi,q.size(),fn.c_str());fflush(stdout);return true;
            }
          }
          q[mi]=old;
        }
      }
      q[ci]=oldcmp;
    }
    printf("REPAIR3 del=%d trials=%llu filterpasses=%llu\n",del,(unsigned long long)(trials-before),(unsigned long long)filterpasses);fflush(stdout);
  }
  printf("REPAIR3_DONE trials=%llu\n",(unsigned long long)(trials-before));return false;
}
// Delete one CMOV and change two surviving CMOVs. Comparisons remain in place,
// but their operand values can change because earlier conditional writes change.
bool repair_cmov3(const Prog&p,int nr,const string&out,int shard,int nshard){
  vector<Ins>alpha;for(auto x:alphabet(nr))if(x.o>=L)alpha.push_back(x);
  int K=p.size();uint64_t before=trials;
  for(int del=0;del<K;del++){
    if(p[del].o<L||del%nshard!=shard)continue;
    Prog q=p;q.erase(q.begin()+del);Fast pre[96];pre[0]=initial;
    for(int i=0;i<K-1;i++){pre[i+1]=pre[i];faststep(pre[i+1],q[i]);}
    for(int i=0;i<K-1;i++)if(q[i].o>=L){
      Ins oldi=q[i];
      for(auto xi:alpha){
        if(xi==oldi)continue;q[i]=xi;Fast modified[96];modified[i]=pre[i];
        for(int z=i;z<K-1;z++){modified[z+1]=modified[z];faststep(modified[z+1],q[z]);}
        for(int j=i+1;j<K-1;j++)if(q[j].o>=L){
          Ins oldj=q[j];
          for(auto xj:alpha){
            if(xj==oldj)continue;trials++;q[j]=xj;
            if(!fastcheck(q,j,&modified[j]))continue;filterpasses++;
            if(fullcheck(q).ok){
              last_shorter=q;string fn=out+"_cmov3_k"+to_string(q.size())+".s";save(q,fn);
              printf("CANDIDATE delete=%d edits=%d,%d k=%zu file=%s\n",del,i,j,q.size(),fn.c_str());fflush(stdout);return true;
            }
          }
          q[j]=oldj;
        }
      }
      q[i]=oldi;
    }
    printf("CMOV3 del=%d trials=%llu filterpasses=%llu\n",del,(unsigned long long)(trials-before),(unsigned long long)filterpasses);fflush(stdout);
  }
  printf("CMOV3_DONE trials=%llu\n",(unsigned long long)(trials-before));return false;
}
// Reverse the value order: reverse input indices and exchange l/g, le/ge.
Prog mirror(const Prog&p){Prog q=p;for(auto&x:q){if(x.d<5)x.d=4-x.d;if(x.s<5)x.s=4-x.s;if(x.o==L)x.o=G;else if(x.o==G)x.o=L;else if(x.o==LE)x.o=GE;else if(x.o==GE)x.o=LE;}return q;}

int main(int argc,char**argv){
  if(argc<5){fprintf(stderr,"usage: search mode seed.txt outprefix seed [args]\n");return 2;}
  string mode=argv[1],out=argv[3];rng.seed(strtoull(argv[4],0,10));init();Prog p=read(argv[2]);
  if(!fullcheck(p).ok||!fastcheck(p)){fprintf(stderr,"seed failed checker\n");return 3;}
  auto start=chrono::steady_clock::now();
  if(mode=="audit"){
    save(p,out+"_baseline.s");deletions(p,out);
  }else if(mode=="repair"){
    int fresh=argc>5?atoi(argv[5]):1,shard=argc>6?atoi(argv[6]):0,nshard=argc>7?atoi(argv[7]):1;
    deletions(p,out);repair(p,nreg+fresh,out,shard,nshard);
  }else if(mode=="repair3"){
    int fresh=argc>5?atoi(argv[5]):1,shard=argc>6?atoi(argv[6]):0,nshard=argc>7?atoi(argv[7]):1;
    repair3(p,nreg+fresh,out,shard,nshard);
  }else if(mode=="cmov3"){
    int fresh=argc>5?atoi(argv[5]):1,shard=argc>6?atoi(argv[6]):0,nshard=argc>7?atoi(argv[7]):1;
    repair_cmov3(p,nreg+fresh,out,shard,nshard);
  }else if(mode=="walk"){
    double seconds=argc>5?atof(argv[5]):600;int fresh=argc>6?atoi(argv[6]):1;
    int repair_interval=argc>7?atoi(argv[7]):1000;
    int nr=nreg+fresh;auto alpha=alphabet(nr);set<uint64_t>seen;seen.insert(hashprog(p));uint64_t moves=0,unique=1;
    array<uint64_t,40> cmp_hist{};
    // Keep every accepted state correct. Sample replacements, instruction moves,
    // two replacements, and suffix register exchanges. Probe delete-one often.
    while(chrono::duration<double>(chrono::steady_clock::now()-start).count()<seconds){
      Prog q=p;int K=q.size(),a=rng()%K,b=rng()%K,ty=rng()%100;
      if(ty<50)q[a]=alpha[rng()%alpha.size()];
      else if(ty<70){auto x=q[a];q.erase(q.begin()+a);q.insert(q.begin()+b,x);}
      else if(ty<82){swap(q[a],q[b]);}
      else if(ty<92){q[a]=alpha[rng()%alpha.size()];q[b]=alpha[rng()%alpha.size()];}
      else{int x=rng()%nr,y=rng()%nr;for(int k=a;k<K;k++){if(q[k].d==x)q[k].d=y;else if(q[k].d==y)q[k].d=x;if(q[k].s==x)q[k].s=y;else if(q[k].s==y)q[k].s=x;}}
      moves++;
      if(q==p||!valid(q))continue;accepted++;p=q;
      if(seen.insert(hashprog(p)).second){
        unique++;int nc=count_if(p.begin(),p.end(),[](Ins x){return x.o==CMP;});cmp_hist[nc]++;
        if(deletions(p,out)){p=last_shorter;if(p.size()<=31)break;}
        if(unique%1000==0){printf("WALK moves=%llu accepted=%llu unique=%llu trials=%llu\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique,(unsigned long long)trials);fflush(stdout);}
        if(repair_interval&&unique%repair_interval==0){
          save(p,out+"_checkpoint.s");
          if(repair(p,nr,out,0,1)){p=last_shorter;if(p.size()<=31)break;}
        }
      }
    }
    save(p,out+"_final.s");printf("WALK_DONE moves=%llu accepted=%llu unique=%llu\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique);
    printf("CMP_HIST");for(int c=0;c<40;c++)if(cmp_hist[c])printf(" %d:%llu",c,(unsigned long long)cmp_hist[c]);printf("\n");
  }else{fprintf(stderr,"unknown mode\n");return 2;}
  printf("DONE trials=%llu filterpasses=%llu fullchecks=%llu accepted=%llu seconds=%.3f\n",(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,(unsigned long long)accepted,chrono::duration<double>(chrono::steady_clock::now()-start).count());
  return 0;
}
