// Collect operand-distinct nine-comparison conditional-transposition traces.
// A singleton strict image is a search observation, not a strict-judge PASS.
#include <bits/stdc++.h>
#include <sys/resource.h>
#include <filesystem>
using namespace std;
extern "C" void init();
extern "C" void operandkey(const unsigned char*,int,unsigned char*);
struct Op{int a,b,c,d;};
struct Img{uint64_t a,b;};
vector<array<int,5>> perms;vector<Op> ops;uint8_t tr[200][120];
double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+1e-6*r.ru_utime.tv_usec+r.ru_stime.tv_sec+1e-6*r.ru_stime.tv_usec;}
int size(Img x){return __builtin_popcountll(x.a)+__builtin_popcountll(x.b);}
Img apply(Img x,int op){Img y{0,0};for(int h=0;h<2;h++){uint64_t z=h?x.b:x.a;while(z){int i=__builtin_ctzll(z)+64*h;z&=z-1;int j=tr[op][i];if(j<64)y.a|=1ULL<<j;else y.b|=1ULL<<(j-64);}}return y;}
int fitness(Img x){int cnt=size(x),hist[5][5]{};for(int i=0;i<120;i++)if((i<64?x.a>>i:x.b>>(i-64))&1)for(int k=0;k<5;k++)hist[k][perms[i][k]]++;
 int score=4*(cnt-1);for(int k=0;k<5;k++)score+=cnt-*max_element(hist[k],hist[k]+5);return score;}
int nonlocal(const array<int,9>&seq){int n=0;for(int id:seq){auto o=ops[id];n+=!((o.a==o.c&&o.b==o.d)||(o.a==o.d&&o.b==o.c));}return n;}
string columns(const array<int,9>&seq){string data(9*240,0);for(int t=0;t<120;t++){auto p=perms[t];for(int j=0;j<9;j++){auto o=ops[seq[j]];data[(2*j)*120+t]=p[o.a];data[(2*j+1)*120+t]=p[o.b];if(p[o.a]>p[o.b])swap(p[o.c],p[o.d]);}}return data;}
void emit(const string&path,const array<int,9>&seq){ofstream f(path);f<<"# n=5 model=out iset=I1 source=w6-round10-macro-sample\n";Img image{~0ULL,(1ULL<<56)-1};for(int id:seq){auto o=ops[id];f<<"cmp P"<<o.a<<", P"<<o.b<<"\nmov S0, P"<<o.c<<"\ncmovg P"<<o.c<<", P"<<o.d<<"\ncmovg P"<<o.d<<", S0\n";image=apply(image,id);}int ix=image.a?__builtin_ctzll(image.a):64+__builtin_ctzll(image.b);for(int k=0;k<5;k++)f<<"out "<<perms[ix][k]<<", P"<<k<<'\n';}
int main(int argc,char**argv){if(argc!=6){cerr<<"collect_macros OUTDIR CPU_SECONDS RNG_SEED TEMPERATURE SEED_CSV\n";return 1;}
 string dir=argv[1];filesystem::create_directories(dir);double limit=atof(argv[2]),temp=atof(argv[4]);mt19937_64 rng(strtoull(argv[3],0,10));
 array<int,5> p{0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int a=0;a<5;a++)for(int b=0;b<5;b++)if(a!=b)for(int c=0;c<5;c++)for(int d=c+1;d<5;d++)ops.push_back({a,b,c,d});
 for(int op=0;op<200;op++)for(int t=0;t<120;t++){auto q=perms[t];auto o=ops[op];if(q[o.a]>q[o.b])swap(q[o.c],q[o.d]);tr[op][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 init();array<int,9> seed{};ifstream sf(argv[5]);for(int j=0;j<9;j++){int a,b,c,d;sf>>a>>b>>c>>d;bool found=false;for(int i=0;i<200;i++){auto o=ops[i];if(tie(a,b,c,d)==tie(o.a,o.b,o.c,o.d)){seed[j]=i;found=true;break;}}if(!found)return 2;}
 vector<array<int,9>> archive{seed};unordered_set<string> raw,canonical;array<int,9> seq=seed;array<Img,10> pre;pre[0]={~0ULL,(1ULL<<56)-1};
 auto build=[&](int start){for(int j=start;j<9;j++)pre[j+1]=apply(pre[j],seq[j]);};build(0);int cur=fitness(pre[9])+6*max(0,1-nonlocal(seq));
 uint64_t iterations=0,accepted=0,correct_visits=0,resets=0;double began=cpu();ofstream manifest(dir+"/manifest.tsv");manifest<<"file\tnonlocal\titeration\n";
 auto collect=[&](){correct_visits++;string data=columns(seq);if(!raw.insert(data).second)return;string key(2160,0);operandkey((const unsigned char*)data.data(),9,(unsigned char*)key.data());if(!canonical.insert(key).second)return;
  char name[64];snprintf(name,sizeof(name),"m%05zu.s",canonical.size()-1);emit(dir+"/"+name,seq);manifest<<name<<'\t'<<nonlocal(seq)<<'\t'<<iterations<<'\n';manifest.flush();if(archive.size()<4096)archive.push_back(seq);
 };
 if(cur==0)collect();
 for(;iterations<2000000000ULL;iterations++){
  if(!(iterations&16383)&&cpu()-began>=limit)break;
  if(iterations&&iterations%200000==0){seq=archive[rng()%archive.size()];if(rng()%8==0)for(int j=1;j<9;j++)seq[j]=rng()%200;build(0);cur=fitness(pre[9])+6*max(0,1-nonlocal(seq));resets++;}
  auto old=seq;int pos=1+rng()%8,lo=pos,kind=rng()%100;
  if(kind<70)seq[pos]=rng()%200;else if(kind<90){int q=1+rng()%8;swap(seq[pos],seq[q]);lo=min(lo,q);}else{int q=1+rng()%8;seq[pos]=rng()%200;seq[q]=rng()%200;lo=min(lo,q);}
  Img end=pre[lo];for(int j=lo;j<9;j++)end=apply(end,seq[j]);int score=fitness(end)+6*max(0,1-nonlocal(seq));
  if(score>cur&&generate_canonical<double,53>(rng)>=exp((cur-score)/temp)){seq=old;continue;}
  cur=score;accepted++;build(lo);if(cur==0)collect();
  if(canonical.size()>=48){iterations++;break;}
 }
 cout<<"SUMMARY iterations="<<iterations<<" accepted="<<accepted<<" correct_visits="<<correct_visits<<" raw="<<raw.size()<<" operand_classes="<<canonical.size()<<" resets="<<resets<<" cpu="<<cpu()-began<<'\n';
}
