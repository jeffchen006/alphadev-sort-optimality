#define main unused_main
#include "bitplanes.cpp"
#undef main
#include <sys/resource.h>
double cpu(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+1e-6*r.ru_utime.tv_usec+r.ru_stime.tv_sec+1e-6*r.ru_stime.tv_usec;}
int main(int argc,char**argv){
 if(argc<3)return 1;int nr;auto p=readp(argv[1],nr);nr++;string output=argv[2];
 vector<array<int,5>>all,sub;for(int c=0;c<3125;c++){int q=c,m=0;array<int,5>a;for(int j=0;j<5;j++)a[j]=q%5,q/=5,m|=1<<a[j];if(!(m&(m+1)))all.push_back(a);}
 for(int i=0;i<64;i++)sub.push_back(all[(i*173+19)%541]);
 Machine<1>sm;Machine<9>fm;sm.setup(sub,nr);fm.setup(all,nr);vector<State<1>>pre(p.size()+1);pre[0]=sm.init;
 for(int t=0;t<(int)p.size();t++){pre[t+1]=pre[t];sm.step(pre[t+1],p[t]);}
 vector<I>alphabet;for(int o=0;o<6;o++)for(int d=0;d<nr;d++)for(int s=0;s<nr;s++)if(o==CMP||d!=s)alphabet.push_back({o,d,s});
 uint64_t singles=0,pairs=0,filtered=0,full=0;double start=cpu();
 auto accept=[&](vector<I>q){filtered++;auto y=fm.init;for(auto i:q)fm.step(y,i);if(y.done!=31)return;full++;ofstream f(output+"_candidate.s");f<<"# n=5 model=out iset=I1 source=w9-two-edit-repair\n";y=fm.init;for(auto i:q){int old=y.done;fm.step(y,i);f<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if((old^y.done)>>j&1)f<<"out "<<j<<", "<<reg(i.d)<<"\n";}};
 for(int a=0;a<(int)p.size();a++){
  for(auto ia:alphabet){auto q=p;q[a]=ia;auto x=pre[a];sm.step(x,ia);auto y=x;for(int t=a+1;t<(int)p.size();t++)sm.step(y,p[t]);singles++;if(y.done==31)accept(q);
   for(int b=a+1;b<(int)p.size();b++){
    for(auto ib:alphabet){auto z=x;sm.step(z,ib);for(int t=b+1;t<(int)p.size();t++)sm.step(z,p[t]);pairs++;if(z.done!=31)continue;q[b]=ib;accept(q);q[b]=p[b];}
    sm.step(x,p[b]);
   }
  }
  cerr<<"POSITION "<<a<<" pairs="<<pairs<<" filtered="<<filtered<<" full="<<full<<" cpu="<<cpu()-start<<"\n";
 }
 cout<<"SUMMARY registers="<<nr<<" alphabet="<<alphabet.size()<<" singles="<<singles<<" pairs="<<pairs<<" filtered="<<filtered<<" full="<<full<<" cpu="<<cpu()-start<<"\n";
}
