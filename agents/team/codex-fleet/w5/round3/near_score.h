// Select the minimum-error snapshot for each output on all 541 weak orders.
// This produces incorrect search seeds; no correctness claim follows.
struct NearScore {
  int errors,failed;
  array<int,5> at,reg;
};
NearScore score_near(const Prog&p) {
  uint8_t r[NR][541], f[541], target[5][541], bestcols[5][541];
  NearScore out{};array<int,5> best;best.fill(542);out.at.fill(-1);
  for(int t=0;t<541;t++){
    auto a=orders[t],b=a;sort(b.begin(),b.end());
    for(int j=0;j<NR;j++)r[j][t]=j<5?a[j]:7;
    for(int j=0;j<5;j++)target[j][t]=b[j];f[t]=3;
  }
  auto observe=[&](int at,int reg){
    for(int j=0;j<5;j++){
      int n=0;for(int t=0;t<541;t++)n+=r[reg][t]!=target[j][t];
      if(n>=best[j])continue;best[j]=n;out.at[j]=at;out.reg[j]=reg;
      memcpy(bestcols[j],r[reg],541);
    }
  };
  for(int j=0;j<5;j++)observe(-1,j);
  for(int i=0;i<(int)p.size();i++){
    auto x=p[i];auto a=r[x.d],b=r[x.s];
    if(x.o==CMP){for(int t=0;t<541;t++)f[t]=x.d==x.s?0:(a[t]==7||b[t]==7)?3:a[t]<b[t]?1:a[t]>b[t]?2:0;continue;}
    if(x.o==MOV)memcpy(a,b,541);
    else for(int t=0;t<541;t++){
      if(f[t]==3){if(a[t]!=b[t])a[t]=7;}
      else if((x.o==L&&f[t]==1)||(x.o==G&&f[t]==2)||(x.o==LE&&f[t]!=2)||(x.o==GE&&f[t]!=1))a[t]=b[t];
    }
    observe(i,x.d);
  }
  out.errors=0;for(int j=0;j<5;j++)out.errors+=best[j];
  out.failed=0;for(int t=0;t<541;t++){
    bool bad=false;for(int j=0;j<5;j++)bad|=bestcols[j][t]!=target[j][t];out.failed+=bad;
  }
  return out;
}
void save_near(const Prog&p,const NearScore&score,const string&path) {
  ofstream f(path);f<<"# n=5 iset=I1 model=out source=w5-round3-near k="<<p.size()<<" weak_fail="<<score.failed<<" weak_error_sum="<<score.errors<<"\n";
  for(int j=0;j<5;j++)if(score.at[j]==-1)f<<"out "<<j<<", "<<regname(score.reg[j])<<"\n";
  for(int i=0;i<(int)p.size();i++){
    auto x=p[i];f<<names[x.o]<<" "<<regname(x.d)<<", "<<regname(x.s)<<"\n";
    for(int j=0;j<5;j++)if(score.at[j]==i)f<<"out "<<j<<", "<<regname(score.reg[j])<<"\n";
  }
}
