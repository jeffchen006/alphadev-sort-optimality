#define main unused_local_main
#include "../../src/local.cpp"
#undef main
#include <sys/resource.h>

// Restricted four-edit repair: one deletion, two changed comparisons, and one
// changed conditional move. Each comparison changes one operand. The changed
// conditional move retains its destination, but its source and condition vary.
// Results exclude only this neighborhood and the explicitly selected cases.
double cpusec(){rusage r;getrusage(RUSAGE_SELF,&r);return r.ru_utime.tv_sec+1e-6*r.ru_utime.tv_usec+r.ru_stime.tv_sec+1e-6*r.ru_stime.tv_usec;}
int main(int argc,char**argv){
  if(argc<5){cerr<<"doublecmp seed.s prefix cpu-seconds mov-only(0/1) [seed]\n";return 1;}
  int nr;auto p=readp(argv[1],nr);nr++;string prefix=argv[2];
  double limit=atof(argv[3]);bool movonly=atoi(argv[4]);
  mt19937 rng(argc>5?atoi(argv[5]):6701);int mode=argc>6?atoi(argv[6]):0;
  vector<array<int,5>>all,sub,strict;for(int c=0;c<3125;c++){int q=c,mask=0;array<int,5>a;for(int j=0;j<5;j++)a[j]=q%5,q/=5,mask|=1<<a[j];if(!(mask&(mask+1)))all.push_back(a);}
  for(auto a:all){auto b=a;sort(b.begin(),b.end());if(b==array<int,5>{0,1,2,3,4})strict.push_back(a);}
  shuffle(strict.begin(),strict.end(),rng);for(int i=0;i<24;i++)sub.push_back(strict[i]);
  for(int i=0;i<8;i++)sub.push_back(all[(173*i+19)%541]);
  Machine<1> sm;Machine<9> fm;sm.setup(sub,nr);fm.setup(all,nr);
  auto full=fm.init;for(auto i:p)fm.step(full,i);if(full.done!=31){cerr<<"seed fails independent evaluator\n";return 2;}
  vector<int> deletions;for(int d=0;d<(int)p.size();d++)if(p[d].o!=CMP&&(!movonly||p[d].o==MOV))deletions.push_back(d);
  shuffle(deletions.begin(),deletions.end(),rng);
  uint64_t tried=0,filtered=0,groups=0;double begun=cpusec();bool found=false,stopped=false;
  for(int del:deletions){
    auto q=p;q.erase(q.begin()+del);vector<int> cmps,selects;
    for(int i=0;i<(int)q.size();i++){if(q[i].o==CMP)cmps.push_back(i);if(q[i].o>=L||(mode&&q[i].o==MOV))selects.push_back(i);}
    vector<State<1>>pre(q.size()+1);pre[0]=sm.init;for(int i=0;i<(int)q.size();i++){pre[i+1]=pre[i];sm.step(pre[i+1],q[i]);}
    vector<array<int,3>> groupset;
    if(!mode){
      for(int a=0;a<(int)cmps.size();a++)for(int b=a+1;b<(int)cmps.size();b++)for(int c:selects)groupset.push_back({cmps[a],cmps[b],c});
    }else{
      for(int c:cmps)for(int a=0;a<(int)selects.size();a++)for(int b=a+1;b<(int)selects.size();b++)groupset.push_back({c,selects[a],selects[b]});
    }
    shuffle(groupset.begin(),groupset.end(),rng);
    uint64_t before=tried;
    for(auto group:groupset){
      if(cpusec()-begun>limit){stopped=true;break;}
      groups++;
      vector<int> positions={group[0],group[1],group[2]};sort(positions.begin(),positions.end());
      vector<I> choices[3];
      for(int j=0;j<3;j++){
        I old=q[positions[j]];
        if(old.o==CMP && mode){
          for(int d=0;d<nr;d++)for(int s=0;s<nr;s++)if(d!=old.d||s!=old.s)choices[j].push_back({CMP,d,s});
        }else if(old.o==CMP){
          for(int r=0;r<nr;r++){
            if(r!=old.d)choices[j].push_back({CMP,r,old.s});
            if(r!=old.s)choices[j].push_back({CMP,old.d,r});
          }
        }else if(mode){
          for(int src=0;src<nr;src++)if(src!=old.s)choices[j].push_back({old.o,old.d,src});
        }else{
          for(int op:{MOV,L,LE,G,GE})for(int src=0;src<nr;src++)
            if(src!=old.d&&(op!=old.o||src!=old.s))choices[j].push_back({op,old.d,src});
        }
      }
      array<I,3> selected;
      function<void(int,State<1>)> rec=[&](int depth,State<1>x){
        if(found)return;
        if(depth==3){
          tried++;for(int k=positions[2]+1;k<(int)q.size();k++)sm.step(x,q[k]);
          if(x.done!=31)return;filtered++;
          auto candidate=q;for(int j=0;j<3;j++)candidate[positions[j]]=selected[j];
          auto y=fm.init;for(auto in:candidate)fm.step(y,in);if(y.done!=31)return;
          ofstream out(prefix+"_k31.s");out<<"# n=5 model=out iset=I1 source=w6-doublecmp k="<<candidate.size()<<"\n";
          y=fm.init;for(auto in:candidate){int old=y.done;fm.step(y,in);out<<names[in.o]<<" "<<reg(in.d)<<", "<<reg(in.s)<<"\n";for(int j=0;j<5;j++)if((y.done^old)>>j&1)out<<"out "<<j<<", "<<reg(in.d)<<"\n";}
          cout<<"CANDIDATE file="<<prefix<<"_k31.s del="<<del<<" edits="<<positions[0]<<","<<positions[1]<<","<<positions[2]<<"\n";cout.flush();found=true;return;
        }
        for(auto in:choices[depth]){
          auto y=x;sm.step(y,in);selected[depth]=in;
          if(depth<2)for(int k=positions[depth]+1;k<positions[depth+1];k++)sm.step(y,q[k]);
          rec(depth+1,y);if(found)return;
        }
      };
      rec(0,pre[positions[0]]);
      if(found)break;
    }
    cerr<<"DELETION index="<<del<<" tried="<<tried-before<<" total="<<tried<<" filtered="<<filtered<<" groups="<<groups<<" cpu="<<cpusec()-begun<<"\n";
    if(found||stopped)break;
  }
  cout<<"SUMMARY status="<<(found?"CANDIDATE":stopped?"LIMIT":"COMPLETE_NO_HIT")<<" tried="<<tried<<" filtered="<<filtered<<" groups="<<groups<<" cpu="<<cpusec()-begun<<"\n";
}
