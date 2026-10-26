// Correct-program walks with random restarts and flag-removal proposals.
#define main original_main
#include "../../src/search.cpp"
#undef main
#include <unordered_set>
#include <sys/resource.h>

int main(int argc,char**argv){
  if(argc<6)return 2;
  rlimit lim{2800ULL*1024*1024,2800ULL*1024*1024};setrlimit(RLIMIT_AS,&lim);
  init();rng.seed(strtoull(argv[4],nullptr,10));
  ifstream in(argv[1]);vector<Prog>seeds;vector<int>nrs;string path;
  while(in>>path){seeds.push_back(read(path));nrs.push_back(nreg+1);if(!fullcheck(seeds.back()).ok)return 3;}
  string out=argv[2];double seconds=atof(argv[3]);int restart_at=atoi(argv[5]);
  uint64_t moves=0,unique=0,restarts=0,local=0,flagsproposals=0,flagsaccepted=0;
  array<uint64_t,40>hist{};array<uint64_t,16>proposals{},takes{};
  unordered_set<uint64_t>seen;vector<Prog>archive;
  auto began=chrono::steady_clock::now();
  Prog p;int nr=0;size_t active=0;
  auto reset=[&](){active=rng()%seeds.size();p=seeds[active];nr=nrs[active];local=0;restarts++;};
  reset();
  while(chrono::duration<double>(chrono::steady_clock::now()-began).count()<seconds){
    if(local>=uint64_t(restart_at))reset();
    Prog q=p;int K=q.size(),a=rng()%K,b=rng()%K,ty=rng()%16;proposals[ty]++;moves++;
    auto randomwrite=[&](){int op=rng()%5;return Ins{op==0?MOV:L+op-1,int(rng()%nr),int(rng()%nr)};};
    auto randomins=[&](){return Ins{int(rng()%6),int(rng()%nr),int(rng()%nr)};};
    if(ty<5)q[a]=randomins();
    else if(ty==5){auto x=q[a];q.erase(q.begin()+a);q.insert(q.begin()+b,x);}
    else if(ty==6)swap(q[a],q[b]);
    else if(ty==7){q[a]=randomins();q[b]=randomins();}
    else if(ty==8){
      int x=rng()%nr,y=rng()%nr;if(a>b)swap(a,b);
      for(int z=a;z<=b;z++){
        if(q[z].d==x)q[z].d=y;else if(q[z].d==y)q[z].d=x;
        if(q[z].s==x)q[z].s=y;else if(q[z].s==y)q[z].s=x;
      }
    }else{
      vector<int>cs;for(int i=0;i<K;i++)if(q[i].o==CMP)cs.push_back(i);
      if(cs.empty())continue;int ci=cs[rng()%cs.size()];
      if(ty==9){
        q[ci]={CMP,int(rng()%nr),int(rng()%nr)};
        for(int i=ci+1;i<K&&q[i].o!=CMP;i++)if(q[i].o>=L)q[i].o=L+rng()%4;
      }else if(ty==10){
        if(q[a].o<L)continue;auto x=q[a];x.o=L+rng()%4;
        q.erase(q.begin()+a);q.insert(q.begin()+b,x);
      }else if(ty==11){
        // Remove one comparison at fixed length by replacing it with a write.
        // Simultaneously alter following predicates and one write source.
        flagsproposals++;q[ci]=randomwrite();
        for(int i=ci+1;i<K&&q[i].o!=CMP;i++)if(q[i].o>=L){
          q[i].o=L+rng()%4;if(rng()%3==0)q[i].s=rng()%nr;
        }
      }else if(ty==12){
        // Trade a CMP for a write at a different position, retain k=32.
        flagsproposals++;q.erase(q.begin()+ci);q.insert(q.begin()+b,randomwrite());
        for(int j=0;j<3;j++){int z=rng()%K;if(q[z].o>=L)q[z].o=L+rng()%4;}
      }else if(ty==13){
        // Invert comparison and every predicate in its block in one move.
        swap(q[ci].d,q[ci].s);
        for(int i=ci+1;i<K&&q[i].o!=CMP;i++){
          int &o=q[i].o;if(o==L)o=G;else if(o==G)o=L;else if(o==LE)o=GE;else if(o==GE)o=LE;
        }
      }else if(ty==14){
        // Move one comparison, then alter up to three affected predicates.
        auto x=q[ci];q.erase(q.begin()+ci);q.insert(q.begin()+b,x);
        for(int j=0;j<3;j++){int z=rng()%K;if(q[z].o>=L)q[z].o=L+rng()%4;}
      }else{
        // Rename a suffix source to an equivalent value through sampled repair.
        int x=rng()%nr,y=rng()%nr;
        for(int z=a;z<K;z++)if(q[z].s==x)q[z].s=y;
        if(q[b].o!=CMP)q[b]=randomwrite();
      }
    }
    if(q==p||!valid(q))continue;
    accepted++;takes[ty]++;if(ty==11||ty==12)flagsaccepted++;p=q;local++;
    if(!seen.insert(hashprog(p)).second)continue;
    unique++;int nc=count_if(p.begin(),p.end(),[](Ins x){return x.o==CMP;});hist[nc]++;
    if(deletions(p,out)){p=last_shorter;break;}
    if(unique%5000==0){
      save(p,out+"_checkpoint.s");
      printf("WALK moves=%llu accepted=%llu unique=%llu restarts=%llu active=%zu trials=%llu c=%d\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique,(unsigned long long)restarts,active,(unsigned long long)trials,nc);fflush(stdout);
    }
    if(unique%20000==0)save(p,out+"_sample"+to_string(unique/20000)+".s");
  }
  save(p,out+"_final.s");
  printf("DONE moves=%llu accepted=%llu unique=%llu restarts=%llu flagsproposals=%llu flagsaccepted=%llu trials=%llu filters=%llu full=%llu k=%zu seconds=%.3f\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique,(unsigned long long)restarts,(unsigned long long)flagsproposals,(unsigned long long)flagsaccepted,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,p.size(),chrono::duration<double>(chrono::steady_clock::now()-began).count());
  printf("CMP_HIST");for(int i=0;i<40;i++)if(hist[i])printf(" %d:%llu",i,(unsigned long long)hist[i]);puts("");
  printf("TYPES");for(int i=0;i<16;i++)printf(" %d:%llu/%llu",i,(unsigned long long)takes[i],(unsigned long long)proposals[i]);puts("");
}
