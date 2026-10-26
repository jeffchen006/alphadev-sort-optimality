// Broader condition repairs after deleting a CMOV or a comparison.
// Reuse the independent simulator from round 1. No solver is required.
#define main old_search_main
#include "../src/search.cpp"
#undef main

uint64_t leaves=0;
string output;
bool found=false;
vector<int> positions;

// Enumerate all four legal predicates in the selected comparison block.
// Fast is only a necessary-condition filter; every survivor gets fullcheck.
void predicates(Prog &q, int which, const Fast &before, int start) {
  if(found)return;
  if(which==(int)positions.size()) {
    leaves++;trials++;
    Fast st=before;
    for(int k=start;k<(int)q.size();k++)faststep(st,q[k]);
    if(st.have!=31)return;
    filterpasses++;
    if(!fullcheck(q).ok)return;
    last_shorter=q;found=true;string fn=output+"_k"+to_string(q.size())+".s";save(q,fn);
    printf("CANDIDATE file=%s\n",fn.c_str());fflush(stdout);return;
  }
  int at=positions[which];Fast st=before;
  for(int k=start;k<at;k++)faststep(st,q[k]);
  Ins old=q[at];
  for(int o=L;o<=GE;o++) {
    q[at].o=o;Fast next=st;faststep(next,q[at]);
    predicates(q,which+1,next,at+1);
    if(found)return;
  }
  q[at]=old;
}

void blockpositions(const Prog&q,int first) {
  positions.clear();
  for(int i=first;i<(int)q.size()&&q[i].o!=CMP;i++)
    if(q[i].o>=L)positions.push_back(i);
}

// Delete CMOV; replace one CMP; reselect every predicate before the next CMP.
// The source and destination registers of conditional writes remain fixed.
void remove_cmov(const Prog&p,int nr) {
  for(int del=0;del<(int)p.size()&&!found;del++)if(p[del].o>=L) {
    Prog q=p;q.erase(q.begin()+del);
    Fast pre[96];pre[0]=initial;
    for(int i=0;i<(int)q.size();i++){pre[i+1]=pre[i];faststep(pre[i+1],q[i]);}
    for(int ci=0;ci<(int)q.size()&&!found;ci++)if(q[ci].o==CMP) {
      blockpositions(q,ci+1);Ins old=q[ci];
      for(int d=0;d<nr&&!found;d++)for(int s=0;s<nr&&!found;s++) {
        q[ci]={CMP,d,s};Fast st=pre[ci];faststep(st,q[ci]);
        predicates(q,0,st,ci+1);
      }
      q[ci]=old;
    }
    printf("FLAG_CMOV del=%d trials=%llu filters=%llu full=%llu\n",del,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks);fflush(stdout);
  }
}

// Delete a CMP, keep the preceding flags, reselect the following block's
// predicates. Optionally replace one instruction outside that block using the
// same instruction class. This covers flag reuse plus one operand repair.
void remove_cmp(const Prog&p,int nr) {
  for(int del=0;del<(int)p.size()&&!found;del++)if(p[del].o==CMP) {
    Prog q=p;q.erase(q.begin()+del);blockpositions(q,del);
    vector<bool> inblock(q.size());for(int i:positions)inblock[i]=true;
    Fast pre[96];pre[0]=initial;
    for(int i=0;i<(int)q.size();i++){pre[i+1]=pre[i];faststep(pre[i+1],q[i]);}
    predicates(q,0,pre[del],del);
    for(int edit=0;edit<(int)q.size()&&!found;edit++)if(!inblock[edit]) {
      Ins old=q[edit];int olo=old.o>=L?L:old.o,ohi=old.o>=L?GE:old.o;
      for(int o=olo;o<=ohi&&!found;o++)for(int d=0;d<nr&&!found;d++)for(int s=0;s<nr&&!found;s++) {
        Ins x={o,d,s};if(x==old)continue;q[edit]=x;
        int lo=min(edit,del);Fast st=pre[lo];
        predicates(q,0,st,lo);
      }
      q[edit]=old;
    }
    printf("FLAG_CMP del=%d trials=%llu filters=%llu full=%llu\n",del,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks);fflush(stdout);
  }
}

// Class-preserving two substitutions after one deletion. Skip the two
// neighborhoods already covered by repair3 and cmov3 on CMOV deletions.
void other_edits(const Prog&p,int nr) {
  vector<Ins> alpha[3];
  for(auto x:alphabet(nr))alpha[x.o>=L?2:x.o].push_back(x);
  for(int del=0;del<(int)p.size()&&!found;del++) {
    Prog q=p;q.erase(q.begin()+del);
    Fast pre[96];pre[0]=initial;
    for(int i=0;i<(int)q.size();i++){pre[i+1]=pre[i];faststep(pre[i+1],q[i]);}
    for(int i=0;i<(int)q.size()&&!found;i++) {
      Ins oi=q[i];int ic=oi.o>=L?2:oi.o;
      for(auto xi:alpha[ic]) {
        if(xi==oi)continue;q[i]=xi;
        Fast modified[96];modified[i]=pre[i];
        for(int z=i;z<(int)q.size();z++){modified[z+1]=modified[z];faststep(modified[z+1],q[z]);}
        for(int j=i+1;j<(int)q.size()&&!found;j++) {
          Ins oj=q[j];int jc=oj.o>=L?2:oj.o;
          if(p[del].o>=L&&((ic==2&&jc==2)||(ic==1&&jc==2)||(ic==2&&jc==1)))continue;
          for(auto xj:alpha[jc]) {
            if(xj==oj)continue;trials++;q[j]=xj;
            if(!fastcheck(q,j,&modified[j]))continue;filterpasses++;
            if(fullcheck(q).ok) {
              found=true;last_shorter=q;save(q,output+"_k31.s");
              printf("CANDIDATE del=%d edit=%d,%d file=%s_k31.s\n",del,i,j,output.c_str());fflush(stdout);return;
            }
          }
          q[j]=oj;
        }
        if(found)return;
      }
      q[i]=oi;
    }
    printf("OTHER del=%d trials=%llu filters=%llu full=%llu\n",del,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks);fflush(stdout);
  }
}

#ifndef W5_FLAGS_LIBRARY
int main(int argc,char**argv) {
  if(argc<4){fprintf(stderr,"flags mode seed.txt outputprefix [fresh]\n");return 2;}
  init();Prog p=read(argv[2]);output=argv[3];
  int nr=nreg+(argc>4?atoi(argv[4]):1);
  if(nr>NR||!fullcheck(p).ok)return 3;
  auto start=chrono::steady_clock::now();
  string mode=argv[1];
  if(mode=="cmov")remove_cmov(p,nr);
  else if(mode=="cmp")remove_cmp(p,nr);
  else if(mode=="other")other_edits(p,nr);
  else if(mode=="control") {
    int ci=0;while(p[ci].o!=CMP)ci++;
    Fast st=initial;for(int i=0;i<=ci;i++)faststep(st,p[i]);
    blockpositions(p,ci+1);predicates(p,0,st,ci+1);
    if(!found)return 4;
  }
  else return 2;
  printf("DONE mode=%s trials=%llu filters=%llu full=%llu found=%d seconds=%.3f\n",mode.c_str(),(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,found,chrono::duration<double>(chrono::steady_clock::now()-start).count());
}
#endif
