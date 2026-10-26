#define REWRITE_NO_MAIN
#include "rewrite.cpp"
int main(int argc,char**argv){
  init();uint64_t transitions=0,matches=0,cmpchecks=0;mt19937_64 random(5312026);
  ifstream list(argv[1]);string file;int seeds=0;
  while(list>>file){Prog p=read(file);Rules r(p,nreg+1,"",true);
    assert(r.nv<256&&r.nf<65536);
    for(int iteration=0;iteration<400;iteration++){
      int a=random()%r.nv,b=random()%r.nv,f=random()%r.nf,o=L+random()%4;
      int v=r.sel(f,a,b,o);string expected=r.values[a];bool known=true;
      for(int t=0;t<541;t++){
        int flag=r.flags[f][t];int av=r.values[a][t],bv=r.values[b][t];
        if(flag==3){if(av!=bv){known=false;break;}}
        else {bool take=o==L?flag==1:o==LE?flag==0||flag==1:o==G?flag==2:flag==0||flag==2;if(take)expected[t]=bv;}
      }
      auto it=r.valids.find(expected);int target=known&&it!=r.valids.end()?it->second:-1;
      assert(v==target);transitions++;if(v>=0)matches++;
      int forward=r.pairflag[a*r.nv+b],reverse=r.pairflag[b*r.nv+a];
      assert((forward<0)==(reverse<0));
      if(forward>=0){for(int t=0;t<541;t++){int x=r.flags[forward][t],y=r.flags[reverse][t];assert(x==0?y==0:x+y==3);}cmpchecks++;}
    }
    seeds++;
  }
  printf("CHECK seeds=%d transition_queries=%llu palette_matches=%llu comparison_reversals=%llu failures=0\n",seeds,(unsigned long long)transitions,(unsigned long long)matches,(unsigned long long)cmpchecks);
}
