#include <algorithm>
#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <map>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>
using namespace std;
struct Ins {int o,d,s;};
const string ops[]={"mov","cmp","cmovl","cmovle","cmovg","cmovge"};
string rn(int r){return string(r<5?"P":"S")+to_string(r<5?r:r-5);}
vector<Ins> parse(string path){
 ifstream f(path);string line;map<string,int> names;for(int i=0;i<5;i++)names[rn(i)]=i;
 vector<Ins> p;while(getline(f,line)){line=line.substr(0,line.find('#'));replace(line.begin(),line.end(),',',' ');stringstream s(line);string o,d,v;if(!(s>>o>>d>>v)||o=="out")continue;
  for(auto r:{d,v})if(!names.count(r))names[r]=names.size();
  p.push_back({int(find(ops,ops+6,o)-ops),names[d],names[v]});
 }return p;
}
template<int W> struct State {uint64_t r[7][3][W]{};uint64_t lt[W]{},gt[W]{};int done=0;};
template<int W> struct Sim {
 State<W> init;uint64_t goal[5][3][W]{},mask[W]{};
 Sim(const vector<array<int,5>>& cases){
  for(int t=0;t<(int)cases.size();t++){
   auto x=cases[t];int w=t/64;uint64_t b=1ULL<<(t%64);mask[w]|=b;
   for(int r=0;r<7;r++)for(int k=0;k<3;k++)if(((r<5?x[r]:7)>>k)&1)init.r[r][k][w]|=b;
   sort(x.begin(),x.end());for(int j=0;j<5;j++)for(int k=0;k<3;k++)if((x[j]>>k)&1)goal[j][k][w]|=b;
  }
  for(int r=0;r<7;r++)match(init,r);
 }
 void match(State<W>& x,int r)const{
  for(int j=0;j<5;j++)if(!(x.done>>j&1)){
   uint64_t diff=0;for(int k=0;k<3;k++)for(int w=0;w<W;w++)diff|=x.r[r][k][w]^goal[j][k][w];
   if(!diff)x.done|=1<<j;
  }
 }
 void step(State<W>& x,Ins i)const{
  if(i.o==0){for(int k=0;k<3;k++)for(int w=0;w<W;w++)x.r[i.d][k][w]=x.r[i.s][k][w];match(x,i.d);return;}
  if(i.o==1){for(int w=0;w<W;w++){
   uint64_t eq=mask[w],lt=0,gt=0;
   for(int k=2;k>=0;k--){auto a=x.r[i.d][k][w],b=x.r[i.s][k][w];lt|=eq&~a&b;gt|=eq&a&~b;eq&=~(a^b);}
   x.lt[w]=lt;x.gt[w]=gt;
  }return;}
  for(int w=0;w<W;w++){
   uint64_t condition=i.o==2?x.lt[w]:i.o==3?mask[w]&~x.gt[w]:i.o==4?x.gt[w]:mask[w]&~x.lt[w];
   for(int k=0;k<3;k++)x.r[i.d][k][w]=(x.r[i.d][k][w]&~condition)|(x.r[i.s][k][w]&condition);
  }match(x,i.d);
 }
 bool run(const vector<Ins>& p)const{auto x=init;for(auto i:p)step(x,i);return x.done==31;}
 void emit(const vector<Ins>& p,string path)const{
  ofstream f(path);f<<"# n=5 model=out iset=I1 source=w7-block-reorder k="<<p.size()<<"\n";
  auto x=init;for(auto i:p){int old=x.done;step(x,i);f<<ops[i.o]<<" "<<rn(i.d)<<", "<<rn(i.s)<<"\n";for(int j=0;j<5;j++)if((old^x.done)>>j&1)f<<"out "<<j<<", "<<rn(i.d)<<"\n";}
 }
};
int main(int argc,char**argv){
 bool inside=argc>1&&string(argv[1])=="inside";
 vector<array<int,5>> all,sub;
 for(int a=0;a<3125;a++){int v=a,mask=0;array<int,5>x;for(int j=4;j>=0;j--)x[j]=v%5,v/=5,mask|=1<<x[j];if(!(mask&(mask+1)))all.push_back(x);}
 for(auto x:all)if(x[1]>max(x[0],x[3])&&min(x[2],x[4])>x[1])sub.push_back(x);
 for(int i=0;sub.size()<64;i++){auto x=all[(173*i+19)%541];if(find(sub.begin(),sub.end(),x)==sub.end())sub.push_back(x);}
 Sim<1> fast(sub);Sim<9> full(all);uint64_t leaves=0,filtered=0,hits=0;
 auto near=parse("seeds/near31.s"),repair=parse("seeds/repair32.s");
 if(!full.run(repair)||full.run(near)){cerr<<"control failed\n";return 2;}
 for(int variant=-1;variant<32;variant++){
  const auto &p=variant<0?near:repair;vector<vector<Ins>> blocks;
  for(int t=0;t<(int)p.size();t++){
   if(p[t].o==1)blocks.push_back({});
   if(variant<0||t!=variant)blocks.back().push_back(p[t]);
  }
  vector<Ins> assembled;uint64_t before=leaves;
  auto dfs=[&](auto&& self,unsigned used,State<1> x)->void{
   if(used==(1U<<blocks.size())-1){leaves++;if(x.done!=31)return;filtered++;
    if(full.run(assembled)){hits++;full.emit(assembled,string("candidates/")+(inside?"inside_reorder_":"reorder_")+to_string(hits)+".s");}return;
   }
   if(inside){
    int b=__builtin_popcount(used);auto seq=blocks[b];size_t first=!seq.empty()&&seq[0].o==1;
    vector<int> order(seq.size()-first);iota(order.begin(),order.end(),first);
    do{
     auto y=x;size_t old=assembled.size();
     if(first){fast.step(y,seq[0]);assembled.push_back(seq[0]);}
     for(int j:order){fast.step(y,seq[j]);assembled.push_back(seq[j]);}
     self(self,used|1U<<b,y);assembled.resize(old);
    }while(next_permutation(order.begin(),order.end()));
    return;
   }
   for(int b=0;b<(int)blocks.size();b++)if(!(used>>b&1)){
    auto y=x;size_t old=assembled.size();for(auto i:blocks[b]){fast.step(y,i);assembled.push_back(i);}
    self(self,used|1U<<b,y);assembled.resize(old);
   }
  };
  dfs(dfs,0,fast.init);
  cout<<"variant="<<variant<<" block_orders="<<leaves-before<<" total="<<leaves<<" filtered="<<filtered<<" full_relaxed_hits="<<hits<<"\n"<<flush;
 }
 cout<<"RESULT orders="<<leaves<<" filtered="<<filtered<<" full_relaxed_hits="<<hits<<"\n";
}
