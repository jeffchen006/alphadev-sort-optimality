// Independent direct replay. No prefix cache or grouping of insertion effects.
#include <bits/stdc++.h>
using namespace std;
using Mask=array<uint64_t,5>;
struct I {int op,a,b;};
struct B {string name;int nr;vector<I> code;};
vector<array<int,5>> cases;
bool check(const vector<I>&p,const array<int,5>&x,int nr,bool freeout,Mask&intersection){
 int r[40];fill(r,r+40,5);copy(x.begin(),x.end(),r);auto target=x;sort(target.begin(),target.end());
 bool lt=false,eq=true;Mask seen{};
 auto note=[&](int slot,int value){for(int j=0;j<5;j++)if(value==target[j])seen[j]|=1ULL<<slot;};
 if(freeout)for(int j=0;j<5;j++)note(j,r[j]);
 for(int i=0;i<(int)p.size();i++){
  auto z=p[i];
  if(z.op==6){if(r[z.b]!=target[z.a])return false;continue;}
  if(z.op==1){lt=r[z.a]<r[z.b];eq=r[z.a]==r[z.b];continue;}
  bool take=z.op==0 || (z.op==2 && lt) || (z.op==3 && (lt||eq)) || (z.op==4 && !lt&&!eq) || (z.op==5 && !lt);
  if(take)r[z.a]=r[z.b];
  if(freeout)note(5+i,r[z.a]);
 }
 if(freeout)for(int j=0;j<5;j++){intersection[j]&=seen[j];if(!intersection[j])return false;}
 return true;
}
int main(int argc,char**argv){
 if(argc!=5)return 2;ifstream f(argv[1]);int n;f>>n;vector<B>bases;
 while(n--){B b;int len;f>>b.name>>b.nr>>len;for(int i=0;i<b.nr;i++){string s;f>>s;}while(len--){I z;f>>z.op>>z.a>>z.b;b.code.push_back(z);}bases.push_back(b);}
 // Independent lexicographic weak-order generator, distinct cases first.
 for(int m=5;m>=1;m--)for(int v=0;v<3125;v++){
  array<int,5>x;int q=v,used=0;for(int j=4;j>=0;j--){x[j]=q%5;q/=5;used|=1<<x[j];}
  if(used==(1<<m)-1)cases.push_back(x);
 }
 assert(cases.size()==541);bool freeout=atoi(argv[2]),del=atoi(argv[3]);ofstream out(argv[4]);
 for(auto&b:bases){uint64_t tried=0,pass=0;clock_t start=clock();
  for(int d=(del?0:-1);d<(del?31:0);d++){
   vector<I>q;int pos=0;for(auto z:b.code){if(z.op==6){if(!freeout)q.push_back(z);}else{if(pos!=d)q.push_back(z);pos++;}}
   for(int gap=0;gap<=(int)q.size();gap++)for(int op=0;op<6;op++)for(int a=0;a<=b.nr;a++)for(int s=0;s<=b.nr;s++){
    tried++;vector<I>p=q;p.insert(p.begin()+gap,I{op,a,s});Mask mask;mask.fill(~0ULL);bool ok=true;
    for(auto x:cases)if(!check(p,x,b.nr+1,freeout,mask)){ok=false;break;}
    if(!ok)continue;pass++;
    out<<"{\"base\":\""<<b.name<<"\",\"delete\":"<<d<<",\"gap\":"<<gap<<",\"instruction\":["<<op<<","<<a<<","<<s<<"],\"output_masks\":[";
    for(int j=0;j<5;j++){if(j)out<<",";out<<(freeout?mask[j]:0);}out<<"]}\n";
   }
  }
  cout<<"DIRECT "<<b.name<<" raw="<<tried<<" survivors="<<pass<<" cpu="<<double(clock()-start)/CLOCKS_PER_SEC<<"\n";cout.flush();out.flush();
 }
}
