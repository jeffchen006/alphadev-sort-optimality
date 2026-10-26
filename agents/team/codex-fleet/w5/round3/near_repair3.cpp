// Three class-preserving replacements: one CMP and two conditional moves.
// Both operands and all four predicates are free in the finite alphabet.
#define main old_search_main
#include "../src/search.cpp"
#undef main
#include "near_score.h"

int main(int argc,char**argv) {
  if(argc<4)return 2;
  init();Prog p=read(argv[1]);string out=argv[2];int first=atoi(argv[3]),nr=nreg+1;
  vector<int> cmp,cmov;
  for(int i=first;i<(int)p.size();i++)if(p[i].o==CMP)cmp.push_back(i);else if(p[i].o>=L)cmov.push_back(i);
  vector<array<int,3>> triples;
  for(int c:cmp)for(int a:cmov)for(int b:cmov)if(a<b) {
    array<int,3> x={c,a,b};sort(x.begin(),x.end());triples.push_back(x);
  }
  vector<Ins> ca,wa;for(auto x:alphabet(nr))if(x.o==CMP)ca.push_back(x);else if(x.o>=L)wa.push_back(x);
  vector<Fast> pre(p.size()+1);pre[0]=initial;
  for(int i=0;i<(int)p.size();i++){pre[i+1]=pre[i];faststep(pre[i+1],p[i]);}
  bool found=false;Prog q=p;NearScore best=score_near(p);uint64_t scored=0;
  auto began=chrono::steady_clock::now();int tn=0;
  for(auto v:triples) {
    int a=v[0],b=v[1],c=v[2];
    auto&aa=p[a].o==CMP?ca:wa;auto&ab=p[b].o==CMP?ca:wa;auto&ac=p[c].o==CMP?ca:wa;
    for(auto xa:aa) {
      if(xa==p[a])continue;q[a]=xa;Fast sa=pre[a];
      for(int i=a;i<b;i++)faststep(sa,q[i]);
      for(auto xb:ab) {
        if(xb==p[b])continue;q[b]=xb;Fast sb=sa;
        for(int i=b;i<c;i++)faststep(sb,q[i]);
        for(auto xc:ac) {
          if(xc==p[c])continue;trials++;q[c]=xc;
          if(!fastcheck(q,c,&sb))continue;filterpasses++;
          auto score=score_near(q);scored++;
          if(score.errors<best.errors||(score.errors==best.errors&&score.failed<best.failed)) {
            best=score;save_near(q,score,out+"_near.s");
            printf("NEAR errors=%d failed=%d file=%s_near.s\n",score.errors,score.failed,out.c_str());fflush(stdout);
          }
          if(!fullcheck(q).ok)continue;
          found=true;save(q,out+"_k31.s");
          printf("CANDIDATE file=%s_k31.s\n",out.c_str());fflush(stdout);break;
        }
        if(found)break;q[c]=p[c];
      }
      if(found)break;q[b]=p[b];
    }
    if(found)break;q[a]=p[a];
    tn++;if(tn%8==0){printf("TRIPLES complete=%d/%zu trials=%llu filters=%llu full=%llu\n",tn,triples.size(),(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks);fflush(stdout);}
  }
  printf("DONE triples=%d/%zu trials=%llu filters=%llu full=%llu found=%d first=%d best_errors=%d best_failed=%d scored=%llu seconds=%.3f\n",tn,triples.size(),(unsigned long long)trials,(unsigned long long)filterpasses,(unsigned long long)fullchecks,found,first,best.errors,best.failed,(unsigned long long)scored,chrono::duration<double>(chrono::steady_clock::now()-began).count());
}
