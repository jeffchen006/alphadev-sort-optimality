#include <bits/stdc++.h>
using namespace std;
using Mask=uint32_t;
using Col=array<int8_t,541>;
using BB=bitset<541>;
struct Rule{Mask need, result;};
struct Block{Mask need;vector<Rule> rules;};
int main(){
 ifstream in("codex_work/scan_input.txt");int N,NR;in>>N>>NR;
 array<Col,24> col;int z;
 for(int a=0;a<23;a++)for(int k=0;k<541;k++){in>>z;col[a][k]=z;}
 auto bit=[](int i)->Mask{return i<5?0:1u<<(i-5);};
 vector<array<int,3>> gates;vector<BB> lt(NR),gt(NR);
 for(int r=0;r<NR;r++){int a,b,c;in>>a>>b>>c;gates.push_back({a,b,c});
  for(int k=0;k<541;k++){lt[r][k]=col[a][k]<col[b][k];gt[r][k]=col[a][k]>col[b][k];}}
 auto deciders=[&](int a,int b){BB l,g;for(int k=0;k<541;k++){l[k]=col[a][k]<col[b][k];g[k]=col[a][k]>col[b][k];}
  vector<Rule> rr;
  for(int r=0;r<NR;r++){
   bool yes=false;
   for(auto &f:{l,g})if(((lt[r]&~f).none()&&(gt[r]&f).none())||((gt[r]&~f).none()&&(lt[r]&f).none())){yes=true;break;}
   if(yes){auto t=gates[r];rr.push_back({bit(t[0])|bit(t[1]),bit(t[2])});}}
  return rr;};
 vector<Block> base;map<pair<int,int>,int> bi;
 for(int a=0;a<23;a++)for(int b=a+1;b<23;b++){
  auto rr=deciders(a,b);bi[{a,b}]=base.size();base.push_back({bit(a)|bit(b),rr});}
 // Output term indices in the example pool.
 Mask target=bit(14)|bit(17)|bit(20)|bit(21)|bit(22);
 ofstream out("codex_work/scan_rank.txt");int hits=0;
 auto begin=chrono::steady_clock::now();
 for(int ni=0;ni<N;ni++){
  for(int k=0;k<541;k++){in>>z;col[23][k]=z;}
  auto blocks=base;int nc;in>>nc;
  for(int i=0;i<nc;i++){int p,q,a,b;in>>p>>q>>a>>b;if(p>q)swap(p,q);
   blocks[bi[{p,q}]].rules.push_back({bit(p)|bit(q)|bit(a)|bit(b),bit(23)});}
  int maxdec=0;
  for(int a=0;a<23;a++){auto rr=deciders(a,23);Mask rm=0;for(auto r:rr)rm|=r.result;maxdec=max(maxdec,__builtin_popcount(rm));
   if(!rr.empty())blocks.push_back({bit(a)|bit(23),rr});}
  vector<Mask> layer{0};unordered_set<Mask> seen{0};int best=99;
  for(int d=1;d<=8;d++){
   vector<Mask> next;
   for(auto m:layer){
    for(auto &bl:blocks){if(bl.need&~m)continue;Mask mm=m;
     while(1){Mask old=mm;for(auto r:bl.rules)if(!(r.need&~mm))mm|=r.result;if(old==mm)break;}
     if(mm==m)continue;if((mm&target)==target){best=d;break;}
     if(seen.insert(mm).second)next.push_back(mm);
    }if(best!=99)break;
   }if(best!=99)break;layer.swap(next);if(layer.empty())break;
  }
  out<<ni<<' '<<best<<' '<<maxdec<<' '<<seen.size()<<'\n';
  if(best<=8){hits++;cout<<"HIT "<<ni<<" blocks "<<best<<" maxdec "<<maxdec<<endl;}
  if((ni+1)%500==0)cout<<"scanned "<<ni+1<<" hits "<<hits<<" seconds "<<chrono::duration<double>(chrono::steady_clock::now()-begin).count()<<endl;
 }
 cout<<"DONE "<<N<<" hits "<<hits<<endl;
}
