// Exact one/two-instruction repair of an incorrect seed. Every edited
// instruction can use any opcode and any operand in the finite alphabet.
#define main old_search_main
#include "../src/search.cpp"
#undef main
#include "near_score.h"

int main(int argc,char**argv) {
  if(argc<3)return 2;
  init();Prog p=read(argv[1]);string out=argv[2];int nr=nreg+1;
  auto alpha=alphabet(nr);auto began=chrono::steady_clock::now();
  bool keep_near=argc>3&&atoi(argv[3]);NearScore best=score_near(p);
  uint64_t scored=0;
  auto track=[&](const Prog&q) {
    if(!keep_near)return;
    NearScore v=score_near(q);scored++;
    if(v.errors>best.errors||(v.errors==best.errors&&v.failed>=best.failed))return;
    best=v;save_near(q,v,out+"_near.s");
    printf("NEAR errors=%d failed=%d file=%s_near.s\n",v.errors,v.failed,out.c_str());fflush(stdout);
  };
  vector<Fast> pre(p.size()+1);pre[0]=initial;
  for(int i=0;i<(int)p.size();i++){pre[i+1]=pre[i];faststep(pre[i+1],p[i]);}
  Prog q=p;bool found=false;
  for(int i=0;i<(int)p.size()&&!found;i++) {
    Ins oi=p[i];
    for(auto xi:alpha) {
      if(xi==oi)continue;q[i]=xi;
      vector<Fast> modified(q.size()+1);modified[i]=pre[i];
      for(int z=i;z<(int)q.size();z++){modified[z+1]=modified[z];faststep(modified[z+1],q[z]);}
      trials++;
      if(modified[q.size()].have==31) {
        filterpasses++;track(q);if(fullcheck(q).ok){found=true;break;}
      }
      for(int j=i+1;j<(int)p.size()&&!found;j++) {
        Ins oj=p[j];
        for(auto xj:alpha) {
          if(xj==oj)continue;q[j]=xj;trials++;
          if(!fastcheck(q,j,&modified[j]))continue;
          filterpasses++;track(q);if(fullcheck(q).ok){found=true;break;}
        }
        if(found)break;q[j]=oj;
      }
      if(found)break;
    }
    if(found)break;q[i]=oi;
    printf("POSITION i=%d trials=%llu filters=%llu full=%llu\n",i,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks);fflush(stdout);
  }
  if(found){save(q,out+"_k31.s");printf("CANDIDATE file=%s_k31.s\n",out.c_str());}
  printf("DONE trials=%llu filters=%llu full=%llu found=%d seconds=%.3f\n",(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,found,chrono::duration<double>(chrono::steady_clock::now()-began).count());
  if(keep_near)printf("BEST scored=%llu errors=%d failed=%d\n",(unsigned long long)scored,best.errors,best.failed);
}
