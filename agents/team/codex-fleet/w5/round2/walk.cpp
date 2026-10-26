// Correct-only walk with condition-block moves and register coalescing.
#define W5_FLAGS_LIBRARY
#include "flags.cpp"
#include <unordered_set>

uint64_t aliastrials=0;
bool aliasrepair(const Prog&p,int nr,const string&out) {
  // Delete one instruction, then alias or exchange its destination with one
  // register over every following interval. This can change many instructions.
  for(int del=0;del<(int)p.size();del++)if(p[del].o!=CMP) {
    int d=p[del].d;
    for(int r=0;r<nr;r++)if(r!=d)for(int type=0;type<3;type++) {
      Prog q=p;q.erase(q.begin()+del);
      for(int end=del;end<(int)q.size();end++) {
        auto&x=q[end];Ins old=x;
        bool destread=x.o==CMP, destwrite=x.o!=CMP;
        // type 0: merge complete register live ranges.
        // type 1: exchange complete register live ranges.
        // type 2: redirect explicit reads only.
        if(type<2||destread){
          if(x.d==d)x.d=r;else if(type==1&&x.d==r)x.d=d;
        }
        if(x.s==d)x.s=r;else if(type==1&&x.s==r)x.s=d;
        if(x==old)continue;
        aliastrials++;
        if(valid(q)) {
          last_shorter=q;save(q,out+"_alias_k31.s");
          printf("CANDIDATE alias del=%d reg=%d type=%d end=%d file=%s_alias_k31.s\n",del,r,type,end,out.c_str());fflush(stdout);return true;
        }
        (void)destwrite;
      }
    }
  }
  return false;
}

int main(int argc,char**argv) {
  if(argc<5){fprintf(stderr,"walk seed.txt outputprefix rng seconds [repair interval]\n");return 2;}
  init();Prog p=read(argv[1]);string out=argv[2];rng.seed(strtoull(argv[3],0,10));
  double seconds=atof(argv[4]);int interval=argc>5?atoi(argv[5]):1000;
  int nr=nreg+1;if(nr>NR||!fullcheck(p).ok)return 3;
  auto start=chrono::steady_clock::now();
  if(deletions(p,out)||aliasrepair(p,nr,out))return 0;
  auto alpha=alphabet(nr);unordered_set<uint64_t>seen;seen.insert(hashprog(p));
  uint64_t moves=0,unique=1,checkpoints=0;
  array<uint64_t,12> histogram{},typeproposals{},typeaccepted{};
  while(chrono::duration<double>(chrono::steady_clock::now()-start).count()<seconds) {
    Prog q=p;int K=q.size(),a=rng()%K,b=rng()%K,ty=rng()%10;
    typeproposals[ty]++;moves++;
    if(ty<3)q[a]=alpha[rng()%alpha.size()];
    else if(ty==3){auto x=q[a];q.erase(q.begin()+a);q.insert(q.begin()+b,x);}
    else if(ty==4)swap(q[a],q[b]);
    else if(ty==5){q[a]=alpha[rng()%alpha.size()];q[b]=alpha[rng()%alpha.size()];}
    else if(ty==6) {
      // Rebuild predicates for a new comparison. Permit multiple simultaneous
      // predicate changes, which a one-instruction walk cannot make directly.
      vector<int>cs;for(int i=0;i<K;i++)if(q[i].o==CMP)cs.push_back(i);
      if(cs.empty())continue;int c=cs[rng()%cs.size()];
      q[c]={CMP,int(rng()%nr),int(rng()%nr)};
      for(int i=c+1;i<K&&q[i].o!=CMP;i++)if(q[i].o>=L)q[i].o=L+rng()%4;
    } else if(ty==7) {
      // Move a conditional write across comparisons and change its predicate.
      if(q[a].o<L)continue;auto x=q[a];x.o=L+rng()%4;
      q.erase(q.begin()+a);q.insert(q.begin()+b,x);
    } else if(ty==8) {
      int x=rng()%nr,y=rng()%nr;
      if(a>b)swap(a,b);
      for(int k=a;k<=b;k++) {
        if(q[k].d==x)q[k].d=y;else if(q[k].d==y)q[k].d=x;
        if(q[k].s==x)q[k].s=y;else if(q[k].s==y)q[k].s=x;
      }
    } else {
      // A three-edit condition-preserving comparison relocation proposal.
      vector<int>cs;for(int i=0;i<K;i++)if(q[i].o==CMP)cs.push_back(i);
      if(cs.size()<2)continue;int c=cs[rng()%cs.size()];
      auto x=q[c];q.erase(q.begin()+c);q.insert(q.begin()+b,x);
      for(int j=0;j<2;j++){int z=rng()%K;if(q[z].o>=L)q[z].o=L+rng()%4;}
    }
    if(q==p||!valid(q))continue;
    accepted++;typeaccepted[ty]++;p=q;
    if(!seen.insert(hashprog(p)).second)continue;
    unique++;int nc=count_if(p.begin(),p.end(),[](Ins x){return x.o==CMP;});
    if(nc<12)histogram[nc]++;
    if(deletions(p,out)){p=last_shorter;break;}
    if(interval&&unique%interval==0) {
      checkpoints++;save(p,out+"_checkpoint.s");
      if(aliasrepair(p,nr,out)){p=last_shorter;break;}
      // Sample a different exact repair class at successive checkpoints.
      if(checkpoints%4==0) {
        if(repair(p,nr,out,0,1)){p=last_shorter;break;}
      } else if(checkpoints%4==1) {
        output=out;found=false;remove_cmp(p,nr);
        if(found){p=last_shorter;break;}
      } else if(checkpoints%4==2) {
        output=out;found=false;remove_cmov(p,nr);
        if(found){p=last_shorter;break;}
      } else {
        if(repair3(p,nr,out,0,1)){p=last_shorter;break;}
      }
    }
    if(unique%1000==0){printf("WALK moves=%llu accepted=%llu unique=%llu checks=%llu trials=%llu\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique,(unsigned long long)checkpoints,(unsigned long long)trials);fflush(stdout);}
  }
  save(p,out+"_final.s");
  printf("WALK_DONE moves=%llu accepted=%llu unique=%llu checkpoints=%llu aliastrials=%llu trials=%llu filterpasses=%llu fullchecks=%llu k=%zu seconds=%.3f\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique,(unsigned long long)checkpoints,(unsigned long long)aliastrials,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,p.size(),chrono::duration<double>(chrono::steady_clock::now()-start).count());
  printf("CMP_HIST");for(int i=0;i<12;i++)if(histogram[i])printf(" %d:%llu",i,(unsigned long long)histogram[i]);printf("\nTYPES");
  for(int i=0;i<10;i++)printf(" %d:%llu/%llu",i,(unsigned long long)typeaccepted[i],(unsigned long long)typeproposals[i]);printf("\n");
}
