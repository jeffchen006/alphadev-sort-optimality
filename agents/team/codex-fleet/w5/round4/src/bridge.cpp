// Correct-only walk through lengths 32..34, with deletion probes on copies.
#define main original_main
#include "../../src/search.cpp"
#undef main
#include <unordered_set>
#include <sys/resource.h>
int main(int argc,char**argv){
  if(argc<6)return 2;
  rlimit lim{2800ULL*1024*1024,2800ULL*1024*1024};setrlimit(RLIMIT_AS,&lim);
  init();rng.seed(strtoull(argv[4],nullptr,10));
  ifstream list(argv[1]);string path;vector<Prog>seeds;int nr=0;
  while(list>>path){seeds.push_back(read(path));nr=max(nr,nreg+2);if(!fullcheck(seeds.back()).ok)return 3;}
  string out=argv[2];double seconds=atof(argv[3]);int interval=atoi(argv[5]);
  uint64_t moves=0,unique=0,resets=0,probes=0,down32=0,local=0;
  uint64_t hist[40][40]={};unordered_set<uint64_t>seen;
  auto alpha=alphabet(nr);auto began=chrono::steady_clock::now();
  Prog p=seeds[rng()%seeds.size()];
  while(chrono::duration<double>(chrono::steady_clock::now()-began).count()<seconds){
    if(local>10000){p=seeds[rng()%seeds.size()];local=0;resets++;}
    Prog q=p;int K=q.size(),a=rng()%K,b=rng()%K,ty=rng()%100;
    if(ty<32)q[a]=alpha[rng()%alpha.size()];
    else if(ty<44){auto x=q[a];q.erase(q.begin()+a);q.insert(q.begin()+b,x);}
    else if(ty<52)swap(q[a],q[b]);
    else if(ty<60){q[a]=alpha[rng()%alpha.size()];q[b]=alpha[rng()%alpha.size()];}
    else if(ty<68){
      vector<int>cs;for(int i=0;i<K;i++)if(q[i].o==CMP)cs.push_back(i);
      if(cs.empty())continue;int ci=cs[rng()%cs.size()];
      q[ci]={CMP,int(rng()%nr),int(rng()%nr)};
      for(int i=ci+1;i<K&&q[i].o!=CMP;i++)if(q[i].o>=L)q[i].o=L+rng()%4;
    }else if(ty<80){if(K==34)continue;q.insert(q.begin()+(rng()%(K+1)),alpha[rng()%alpha.size()]);}
    else if(ty<90){q.erase(q.begin()+a);}
    else if(ty<95){
      int x=rng()%nr,y=rng()%nr;if(a>b)swap(a,b);
      for(int i=a;i<=b;i++){
        if(q[i].d==x)q[i].d=y;else if(q[i].d==y)q[i].d=x;
        if(q[i].s==x)q[i].s=y;else if(q[i].s==y)q[i].s=x;
      }
    }else{
      if(q[a].o!=CMP)continue;swap(q[a].d,q[a].s);
      for(int i=a+1;i<K&&q[i].o!=CMP;i++){
        int&o=q[i].o;if(o==L)o=G;else if(o==G)o=L;else if(o==LE)o=GE;else if(o==GE)o=LE;
      }
    }
    moves++;if(q==p||!valid(q))continue;accepted++;local++;p=q;
    if(p.size()<=31){save(p,out+"_found_k"+to_string(p.size())+".s");break;}
    if(!seen.insert(hashprog(p)).second)continue;unique++;
    int nc=count_if(p.begin(),p.end(),[](Ins x){return x.o==CMP;});hist[p.size()][nc]++;
    if(unique%interval==0){
      probes++;Prog down=p;
      bool changed=true;
      while(changed){changed=false;
        // Exhaustive single deletion at each reached program, in random order.
        vector<int>ix(down.size());for(int i=0;i<(int)ix.size();i++)ix[i]=i;shuffle(ix.begin(),ix.end(),rng);
        for(int del:ix){Prog z=down;z.erase(z.begin()+del);if(!valid(z))continue;down=z;changed=true;break;}
      }
      if(down.size()<=31){p=down;save(p,out+"_found_k"+to_string(p.size())+".s");break;}
      if(down.size()==32){
        down32++;if(rng()%4==0)p=down;
        if(down32%200==0)save(down,out+"_short_sample"+to_string(down32/200)+".s");
      }
    }
    if(unique%10000==0){
      save(p,out+"_checkpoint.s");
      printf("BRIDGE moves=%llu accepted=%llu unique=%llu probes=%llu down32=%llu k=%zu c=%d trials=%llu resets=%llu\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique,(unsigned long long)probes,(unsigned long long)down32,p.size(),nc,(unsigned long long)trials,(unsigned long long)resets);fflush(stdout);
    }
  }
  save(p,out+"_final.s");
  printf("DONE moves=%llu accepted=%llu unique=%llu probes=%llu down32=%llu trials=%llu filters=%llu full=%llu k=%zu seconds=%.3f resets=%llu\n",(unsigned long long)moves,(unsigned long long)accepted,(unsigned long long)unique,(unsigned long long)probes,(unsigned long long)down32,(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,p.size(),chrono::duration<double>(chrono::steady_clock::now()-began).count(),(unsigned long long)resets);
  printf("HIST");for(int k=0;k<40;k++)for(int c=0;c<40;c++)if(hist[k][c])printf(" k%d,c%d:%llu",k,c,(unsigned long long)hist[k][c]);puts("");
}
