// Two MOV deletions, with one arbitrary insertion. Reuse the independent w5
// simulator. All outputs can choose new snapshots after the edit.
#define main old_search_main
#include "../src/search.cpp"
#undef main

bool scan(const Prog&p,int nr,const string&out,bool source_repair) {
  auto alpha=alphabet(nr);
  for(int i=0;i<(int)p.size();i++)if(p[i].o==MOV)
    for(int j=i+1;j<(int)p.size();j++)if(p[j].o==MOV) {
      Prog b=p;b.erase(b.begin()+j);b.erase(b.begin()+i);
      if(valid(b)) {save(b,out+"_delete2_k30.s");return true;}
      // With source_repair, change one surviving source register as well.
      // CMP may change either operand; writes retain their destination/opcode.
      vector<pair<int,Ins>> edits;
      edits.push_back({-1,{MOV,0,0}});
      if(source_repair)for(int pos=0;pos<(int)b.size();pos++) {
        Ins old=b[pos];
        for(int r=0;r<nr;r++) {
          if(r!=old.s)edits.push_back({pos,{old.o,old.d,r}});
          if(old.o==CMP&&r!=old.d)edits.push_back({pos,{CMP,r,old.s}});
        }
      }
      Prog base=b;
      for(auto edit:edits) {
      b=base;if(edit.first>=0)b[edit.first]=edit.second;
      vector<Fast> pre(b.size()+1);pre[0]=initial;
      for(int z=0;z<(int)b.size();z++){pre[z+1]=pre[z];faststep(pre[z+1],b[z]);}
      for(int gap=0;gap<=(int)b.size();gap++)for(auto x:alpha) {
        trials++;Fast st=pre[gap];faststep(st,x);
        for(int z=gap;z<(int)b.size();z++)faststep(st,b[z]);
        if(st.have!=31)continue;filterpasses++;
        Prog q=b;q.insert(q.begin()+gap,x);
        if(!fullcheck(q).ok)continue;
        string fn=out+"_insert_k31.s";save(q,fn);
        printf("CANDIDATE delete=%d,%d edit=%d gap=%d op=%s d=%d s=%d file=%s\n",i,j,edit.first,gap,names[x.o],x.d,x.s,fn.c_str());return true;
      }
      }
    }
  return false;
}
int main(int argc,char**argv) {
  if(argc<3)return 2;
  init();ifstream list(argv[1]);string seed,out;int count=0;bool found=false;
  auto began=chrono::steady_clock::now();
  while(list>>seed>>out) {
    Prog p=read(seed);if(!fullcheck(p).ok)return 3;
    uint64_t t=trials,f=filterpasses,c=fullchecks;
    found=scan(p,nreg+1,out,argc>3&&atoi(argv[3]));count++;
    printf("SEED index=%d file=%s trials=%llu filters=%llu full=%llu found=%d\n",count,seed.c_str(),(unsigned long long)(trials-t),(unsigned long long)(filterpasses-f),(unsigned long long)(fullchecks-c),found);fflush(stdout);
    if(found)break;
  }
  printf("DONE seeds=%d trials=%llu filters=%llu full=%llu found=%d seconds=%.3f\n",count,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,found,chrono::duration<double>(chrono::steady_clock::now()-began).count());
  return 0;
}
