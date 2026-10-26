// Independent forward enumeration of raw-source chains on strict interleavings.
// Five initial accumulator choices are free. Each stage can select an original
// entry on either branch. More than one useful assignment at one strict flag
// resets both branches to original entries, so a one-assignment plan from a
// different free initial entry has no greater cost.
#include <bits/stdc++.h>
using namespace std;
int main(){
 vector<array<int,5>> cases;array<int,5> a={0,1,2,3,4};
 do{if(a[0]<a[1]&&a[2]<a[3]&&a[3]<a[4])cases.push_back(a);}while(next_permutation(a.begin(),a.end()));
 assert(cases.size()==10);array<uint32_t,5> input{},goal{};
 for(int w=0;w<10;w++)for(int j=0;j<5;j++){
  input[j]|=uint32_t(cases[w][j])<<(3*w);goal[j]|=uint32_t(j)<<(3*w);
 }
 vector<pair<int,int>> pairs;for(int i=0;i<2;i++)for(int j=2;j<5;j++)pairs.emplace_back(i,j);
 array<array<uint32_t,2>,6> masks{};
 for(int p=0;p<6;p++)for(int w=0;w<10;w++)masks[p][cases[w][pairs[p].first]<cases[w][pairs[p].second]]|=7u<<(3*w);
 array<int,6> order={0,1,2,3,4,5};int index=0,functional=0,best=999;uint64_t states=0;clock_t st=clock();
 ofstream out("round5/forward_distinct.tsv");
 do{
  unordered_map<uint32_t,uint8_t> current;
  for(auto col:input)current[col]=0;
  for(int p:order){
   auto next=current;
   for(auto [col,cost]:current)if(cost<4)for(uint32_t mask:masks[p])for(auto src:input){
    uint32_t val=(col&~mask)|(src&mask);auto [it,inserted]=next.emplace(val,cost+1);
    if(!inserted&&it->second>cost+1)it->second=cost+1;
   }
   current.swap(next);states+=current.size();
  }
  int total=0;bool good=true;out<<index;
  for(auto col:goal){auto it=current.find(col);int c=it==current.end()?99:it->second;out<<'\t'<<c;total+=c;good&=c<99;}
  out<<'\n';if(good){functional++;best=min(best,total);}index++;
 }while(next_permutation(order.begin(),order.end()));
 cout<<"COMPLETE orders="<<index<<" functional="<<functional<<" best="<<best<<" states="<<states<<" cpu="<<double(clock()-st)/CLOCKS_PER_SEC<<endl;
}
