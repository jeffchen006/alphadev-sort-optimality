// Remove a CMP and rebuild its entire write block with reused flags.
// All block write opcodes are free among MOV and four supported CMOVs.
// One chosen write also has unrestricted destination/source operands.
#define main original_main
#include "../../src/search.cpp"
#undef main
#include <sys/resource.h>
uint64_t nodes=0,leaves=0;bool found=false;string output;
void visit(Prog&q,int at,int end,int edit,int nr,const Fast&before){
  if(found)return;
  if(at==end){
    leaves++;trials++;Fast st=before;
    for(int i=end;i<(int)q.size();i++)faststep(st,q[i]);
    if(st.have!=31)return;filterpasses++;
    if(!fullcheck(q).ok)return;
    found=true;string file=output+"_found_k"+to_string(q.size())+".s";save(q,file);
    printf("CANDIDATE file=%s\n",file.c_str());fflush(stdout);return;
  }
  Ins old=q[at];
  for(int o=0;o<6;o++)if(o!=CMP){
    int dlo=at==edit?0:old.d,dhi=at==edit?nr:old.d+1;
    int slo=at==edit?0:old.s,shi=at==edit?nr:old.s+1;
    for(int d=dlo;d<dhi;d++)for(int s=slo;s<shi;s++){
      q[at]={o,d,s};Fast st=before;faststep(st,q[at]);nodes++;
      visit(q,at+1,end,edit,nr,st);if(found)return;
    }
  }
  q[at]=old;
}
int main(int argc,char**argv){
  if(argc<3)return 2;
  rlimit lim{2800ULL*1024*1024,2800ULL*1024*1024};setrlimit(RLIMIT_AS,&lim);
  init();ifstream list(argv[1]);string path;output=argv[2];int seed=0;
  auto began=chrono::steady_clock::now();
  while(list>>path){
    Prog p=read(path);int nr=nreg+1;if(!fullcheck(p).ok)return 3;
    for(int del=0;del<(int)p.size();del++)if(p[del].o==CMP){
      Prog q=p;q.erase(q.begin()+del);int end=del;
      while(end<(int)q.size()&&q[end].o!=CMP)end++;
      Fast pre=initial;for(int i=0;i<del;i++)faststep(pre,q[i]);
      for(int edit=del;edit<end;edit++){
        visit(q,del,end,edit,nr,pre);if(found)return 0;
      }
    }
    printf("SEED index=%d file=%s trials=%llu filters=%llu full=%llu\n",seed++,path.c_str(),(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks);fflush(stdout);
  }
  printf("DONE seeds=%d trials=%llu filters=%llu full=%llu nodes=%llu leaves=%llu seconds=%.3f found=%d\n",seed,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,(unsigned long long)nodes,(unsigned long long)leaves,chrono::duration<double>(chrono::steady_clock::now()-began).count(),found);
}
