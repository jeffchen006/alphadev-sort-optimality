#define W6SEARCH_NO_MAIN
#include "../../round4/src/search.cpp"
int main(int argc,char**argv){
 int used;auto p=readp(argv[1],used);int nr=used+1;string prefix=argv[2];auto all=allcases();vector<array<int,5>>sub;for(int t=0;t<64;t++)sub.push_back(all[(173*t+19)%541]);Search work(p,nr,sub,all,prefix);
 vector<QState<1>>pre(p.size()+1);pre[0]=work.sm.init;for(int t=0;t<(int)p.size();t++){pre[t+1]=pre[t];work.sm.step(pre[t+1],p[t]);}
 vector<I>alphabet;for(int o=0;o<6;o++)for(int d=0;d<nr;d++)for(int s=0;s<nr;s++)if(o==CMP||d!=s)alphabet.push_back({o,d,s});
 auto start=clock();uint64_t single=0,pairs=0;
 for(int a=0;a<(int)p.size();a++)for(auto ia:alphabet){auto q=p;q[a]=ia;auto x=pre[a];work.sm.step(x,ia);auto y=x;for(int t=a+1;t<(int)p.size();t++)work.sm.step(y,p[t]);single++;work.c.tried++;if(y.done==31)work.accept(q);
  for(int b=a+1;b<(int)p.size();b++){
   for(auto ib:alphabet){auto z=x;work.sm.step(z,ib);for(int t=b+1;t<(int)p.size();t++)work.sm.step(z,p[t]);pairs++;work.c.tried++;if(z.done!=31)continue;q[b]=ib;work.accept(q);q[b]=p[b];}
   work.sm.step(x,p[b]);
  }
 }
 work.save_near(p);
 cout<<"SUMMARY registers="<<nr<<" alphabet="<<alphabet.size()<<" singles="<<single<<" pairs="<<pairs<<" tried="<<work.c.tried<<" filtered="<<work.c.filtered<<" full="<<work.c.full<<" hits="<<work.c.hits<<" best_error="<<work.best_error<<" best_fail="<<work.best_fail<<" cpu="<<double(clock()-start)/CLOCKS_PER_SEC<<"\n";
}
