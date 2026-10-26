// Compare the packed concrete interpreter with an independent scalar execution.
#define W6SEARCH_NO_MAIN
#include "search.cpp"

template<int W> void check(const vector<I>&p,int nr,const vector<array<int,5>>&cases,uint64_t&steps){
  Concrete<W> m(cases,nr);auto x=m.init;
  vector<array<int,16>>r(cases.size());
  vector<int>lt(cases.size(),0),gt(cases.size(),0);
  vector<array<int,5>>goals=cases;
  for(int t=0;t<(int)cases.size();t++){
    for(int k=0;k<nr;k++)r[t][k]=k<5?cases[t][k]:7;
    sort(goals[t].begin(),goals[t].end());
  }
  int done=0;
  auto match=[&](int k){
    for(int j=0;j<5;j++){
      bool ok=true;
      for(int t=0;t<(int)cases.size();t++)ok&=r[t][k]==goals[t][j];
      if(ok)done|=1<<j;
    }
  };
  for(int k=0;k<nr;k++)match(k);
  if(done!=x.done)throw runtime_error("initial done mismatch");
  for(auto i:p){
    m.step(x,i);
    for(int t=0;t<(int)cases.size();t++){
      int a=r[t][i.d],b=r[t][i.s];
      if(i.o==MOV)r[t][i.d]=b;
      else if(i.o==CMP)lt[t]=a<b,gt[t]=a>b;
      else{
        bool yes=i.o==L?lt[t]:i.o==LE?!gt[t]:i.o==G?gt[t]:!lt[t];
        if(yes)r[t][i.d]=b;
      }
      for(int k=0;k<nr;k++){
        int got=0;for(int z=0;z<3;z++)got|=((x.r[k].b[z][t/64]>>(t%64))&1)<<z;
        if(got!=r[t][k])throw runtime_error("value mismatch");
      }
      if(int((x.lt[t/64]>>(t%64))&1)!=lt[t]||int((x.gt[t/64]>>(t%64))&1)!=gt[t])
        throw runtime_error("flags mismatch");
      steps++;
    }
    if(i.o!=CMP)match(i.d);
    if(done!=x.done)throw runtime_error("snapshot mismatch");
  }
}
int main(){
  mt19937 rng(904221);auto all=allcases();vector<array<int,5>>sub;
  for(int t=0;t<64;t++)sub.push_back(all[(173*t+19)%541]);
  int programs=0;uint64_t steps=0;
  ifstream in("round4/artifacts/all.txt");string path;
  while(getline(in,path)){
    int used;auto p=readp(path,used);int nr=used+1;
    check<9>(p,nr,all,steps);check<1>(p,nr,sub,steps);programs++;
    // Test a deletion pair, an insertion, and changed comparison operands.
    for(int it=0;it<4;it++){
      auto q=p;vector<int>w;
      for(int t=0;t<(int)q.size();t++)if(q[t].o!=CMP)w.push_back(t);
      shuffle(w.begin(),w.end(),rng);int a=w[0],b=w[1];if(a>b)swap(a,b);
      q.erase(q.begin()+b);q.erase(q.begin()+a);
      int pos=rng()%(q.size()+1),op=rng()%5;if(op>=1)op++;
      q.insert(q.begin()+pos,{op,int(rng()%nr),int(rng()%nr)});
      if(it%2){int ci=pos-1;while(ci>=0&&q[ci].o!=CMP)ci--;
        if(ci>=0)q[ci]={CMP,int(rng()%nr),int(rng()%nr)};}
      check<9>(q,nr,all,steps);check<1>(q,nr,sub,steps);programs++;
    }
  }
  cout<<"CHECK programs="<<programs<<" scalar_case_steps="<<steps<<" result=MATCH\n";
}
