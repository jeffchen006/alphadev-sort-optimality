// Search conditional transpositions. Compare operands and swapped wires are independent.
#include <bits/stdc++.h>
#include <sys/resource.h>
using namespace std;
using U=uint64_t;
struct Op {int a,b,c,d;};
vector<array<int,5>> P; vector<Op> ops;
uint8_t tr[200][120];
struct Img{U a=0,b=0;};
bool operator<(Img x,Img y){return tie(x.a,x.b)<tie(y.a,y.b);}
int count(Img x){return __builtin_popcountll(x.a)+__builtin_popcountll(x.b);}
Img apply(Img x,int op){Img r;while(x.a){int i=__builtin_ctzll(x.a);x.a&=x.a-1;int j=tr[op][i];if(j<64)r.a|=1ULL<<j;else r.b|=1ULL<<(j-64);}while(x.b){int i=__builtin_ctzll(x.b)+64;x.b&=x.b-1;int j=tr[op][i];if(j<64)r.a|=1ULL<<j;else r.b|=1ULL<<(j-64);}return r;}
vector<int> indices(Img x){vector<int> r;for(int i=0;i<120;i++)if((i<64?x.a>>i:x.b>>(i-64))&1)r.push_back(i);return r;}
double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+r.ru_utime.tv_usec*1e-6+r.ru_stime.tv_sec+r.ru_stime.tv_usec*1e-6;}
int n,seq[12],best[12];
int nonlocal_count(int *s){int z=0;for(int i=0;i<n;i++){auto o=ops[s[i]];z+=!((o.a==o.c&&o.b==o.d)||(o.a==o.d&&o.b==o.c));}return z;}
int fitness(Img x){auto ids=indices(x);int sums[5][5]{};for(int id:ids)for(int r=0;r<5;r++)sums[r][P[id][r]]++;int h=0;for(int r=0;r<5;r++)h+=ids.size()-*max_element(sums[r],sums[r]+5);return 4*(ids.size()-1)+h;}
void emit(string path,int *s){ofstream f(path);f<<"# n=5 model=out iset=I1 source=w6-round5-macro\n";for(int t=0;t<n;t++){auto o=ops[s[t]];f<<"cmp P"<<o.a<<", P"<<o.b<<"\nmov S0, P"<<o.c<<"\ncmovg P"<<o.c<<", P"<<o.d<<"\ncmovg P"<<o.d<<", S0\n";}Img x={~0ULL,(1ULL<<56)-1};for(int t=0;t<n;t++)x=apply(x,s[t]);auto p=P[indices(x)[0]];for(int r=0;r<5;r++)f<<"out "<<p[r]<<", P"<<r<<"\n";}
int main(int argc,char**argv){string prefix=argv[1];double limit=atof(argv[2]);U seed=strtoull(argv[3],0,10);n=argc>4?atoi(argv[4]):8;mt19937_64 rng(seed);array<int,5>a={0,1,2,3,4};do{P.push_back(a);}while(next_permutation(a.begin(),a.end()));for(int a=0;a<5;a++)for(int b=0;b<5;b++)if(a!=b)for(int c=0;c<5;c++)for(int d=c+1;d<5;d++)ops.push_back({a,b,c,d});for(int j=0;j<200;j++)for(int i=0;i<120;i++){auto p=P[i];auto o=ops[j];if(p[o.a]>p[o.b])swap(p[o.c],p[o.d]);tr[j][i]=lower_bound(P.begin(),P.end(),p)-P.begin();}
vector<array<int,12>> archive;set<Img> seen;array<Img,13> pre;pre[0]={~0ULL,(1ULL<<56)-1};auto build=[&](int k){for(int j=k;j<n;j++)pre[j+1]=apply(pre[j],seq[j]);};// Explicitly locate the initial canonical compare/swap.
int first=0;for(int j=0;j<200;j++)if(ops[j].a==0&&ops[j].b==1&&ops[j].c==0&&ops[j].d==1)first=j;
int bestscore=99999,cur=0;U iterations=0,accepted=0,resets=0;double began=cpu();
for(;;iterations++){if(!(iterations&16383)&&cpu()-began>limit)break;if(iterations%100000==0){for(int j=0;j<n;j++)seq[j]=rng()%200;seq[0]=first;if(!archive.empty()&&rng()%4){auto p=archive[rng()%archive.size()];copy(p.begin(),p.begin()+n,seq);}build(0);cur=fitness(pre[n])+6*max(0,2-nonlocal_count(seq));resets++;}
int old[12];copy(seq,seq+n,old);int pos=1+rng()%(n-1),kind=rng()%100,lo=pos;if(kind<65){seq[pos]=rng()%200;}else if(kind<85){int q=1+rng()%(n-1);swap(seq[pos],seq[q]);lo=min(pos,q);}else{int q=1+rng()%(n-1);seq[pos]=rng()%200;seq[q]=rng()%200;lo=min(pos,q);}Img x=pre[lo];for(int j=lo;j<n;j++)x=apply(x,seq[j]);int sc=fitness(x)+6*max(0,2-nonlocal_count(seq));double temp=0.4+2.0*(rng()%10)/9.;bool accept=sc<=cur||generate_canonical<double,53>(rng)<exp((cur-sc)/temp);if(!accept){copy(old,old+n,seq);continue;}cur=sc;accepted++;build(lo);
if(sc<bestscore){bestscore=sc;copy(seq,seq+n,best);emit(prefix+"_near.s",seq);cout<<"BEST score="<<sc<<" states="<<count(x)<<" iterations="<<iterations<<" cpu="<<cpu()-began<<"\n";cout.flush();}
if(count(x)<=3&&seen.insert(x).second&&archive.size()<3000){array<int,12>p{};copy(seq,seq+n,p.begin());archive.push_back(p);emit(prefix+"_state"+to_string(archive.size())+".s",seq);}
if(sc==0){emit(prefix+"_sort_"+to_string(archive.size())+".s",seq);cout<<"CANDIDATE instructions="<<n*4<<" nonlocal="<<nonlocal_count(seq)<<" cpu="<<cpu()-began<<"\n"<<flush; if(archive.size()>40)break;}}
cout<<"SUMMARY iterations="<<iterations<<" accepted="<<accepted<<" resets="<<resets<<" bestscore="<<bestscore<<" states="<<seen.size()<<" cpu="<<cpu()-began<<"\n";
}
