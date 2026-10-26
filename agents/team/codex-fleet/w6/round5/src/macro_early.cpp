#define W6SEARCH_NO_MAIN
#include "../../round4/src/search.cpp"
int main(){auto cases=allcases();vector<array<int,5>>sub;for(int t=0;t<64;t++)sub.push_back(cases[(173*t+19)%541]);uint64_t files=0,tried=0,filtered=0,full=0,hits=0,valid32=0;auto begin=clock();
 for(auto entry:filesystem::directory_iterator("round5/candidates")){
  string name=entry.path().filename();if(name.rfind("macro8_",0)!=0||entry.path().extension()!=".s")continue;
  int used;auto p=readp(entry.path(),used);if(p.size()!=32)continue;files++;
  Concrete<1>sm(sub,used);Concrete<9>fm(cases,used);auto x=sm.init;
  vector<QState<1>>pre(p.size()+1);pre[0]=x;for(int t=0;t<(int)p.size();t++){pre[t+1]=pre[t];sm.step(pre[t+1],p[t]);}
  if(pre.back().done==31&&fm.run(p).done==31){valid32++;if(valid32<=4)emit(p,fm,"round5/candidates/macro_early32_"+to_string(valid32)+".s");}
  for(int a=0;a<(int)p.size();a++){
   tried++;auto y=pre[a];for(int t=a+1;t<(int)p.size();t++)sm.step(y,p[t]);if(y.done!=31)continue;filtered++;auto q=p;q.erase(q.begin()+a);full++;if(fm.run(q).done!=31)continue;hits++;string path="round5/candidates/macro_early31_"+to_string(hits)+".s";emit(q,fm,path);cout<<"CANDIDATE "<<path<<" source="<<entry.path()<<" delete="<<a<<"\n"<<flush;
  }
 }
 cout<<"SUMMARY files="<<files<<" deletions="<<tried<<" filtered="<<filtered<<" full="<<full<<" hits="<<hits<<" valid32="<<valid32<<" cpu="<<double(clock()-begin)/CLOCKS_PER_SEC<<"\n"<<flush;
}
