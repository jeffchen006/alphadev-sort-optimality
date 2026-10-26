#define main search_main
#include "search.cpp"
#undef main
namespace reference {
#include "reference_sim.h"
}
int main(int argc,char**argv){
  init();rng.seed(55005);Prog seed=read(argv[1]);int nr=nreg+1;
  reference::Task task;reference::task_init(&task,5,11,reference::MOD_OUT,0,"I1");
  auto alpha=alphabet(nr);uint64_t pass=0;int checks=argc>2?atoi(argv[2]):10000;
  for(int it=0;it<checks;it++){
    Prog q=seed;int changes=rng()%5;
    for(int k=0;k<changes;k++)q[rng()%q.size()]=alpha[rng()%alpha.size()];
    reference::Ins rp[96];
    int map[]={reference::MOV,reference::CMP,reference::CMOVL,reference::CMOVLE,reference::CMOVG,reference::CMOVGE};
    for(int i=0;i<(int)q.size();i++)rp[i]={(uint8_t)map[q[i].o],(uint8_t)q[i].d,(uint8_t)q[i].s};
    bool own=fullcheck(q).ok,ref=reference::wrong(&task,rp,q.size(),nullptr)==0,fast=fastcheck(q);
    if(own!=ref||(own&&!fast)){
      fprintf(stderr,"DIFFERENCE it=%d own=%d ref=%d fast=%d\n",it,own,ref,fast);return 2;
    }
    pass+=own;
  }
  printf("CROSSCHECK checks=%d correct=%llu disagreements=0\n",checks,(unsigned long long)pass);
}
