#include <algorithm>
#include <array>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>
using namespace std;
using Col=__uint128_t;
const Col MASK=(Col(1)<<72)-1;
int rid(string s){if(s.back()==',')s.pop_back();return s[0]=='P'?stoi(s.substr(1)):5+stoi(s.substr(1));}
int main(){
 vector<array<int,4>> perms;array<int,4>a={0,1,2,3};
 do{perms.push_back(a);}while(next_permutation(a.begin(),a.end()));
 map<vector<Col>,int> classes;vector<long> counts;vector<int> comparisons;
 vector<Col> r(128);vector<bool> written(128);Col lo=0,eq=MASK;
 string line,full,prefix;int k=0,c=0;long n=0;
 auto reset=[&](){Col garbage=0;for(int t=0;t<24;t++)garbage|=Col(4)<<(3*t);
  fill(r.begin(),r.end(),garbage);fill(written.begin(),written.end(),false);
  for(int j=0;j<4;j++){written[j]=true;r[j]=0;for(int t=0;t<24;t++)r[j]|=Col(perms[t][j])<<(3*t);}
  lo=0;eq=MASK;full=prefix="";k=c=0;};
 auto finish=[&](){if(full.empty())return;n++;
  vector<Col> key;for(int j=0;j<128;j++)if(written[j])key.push_back(r[j]);
  sort(key.begin(),key.end());key.push_back(lo);key.push_back(eq);
  auto it=classes.find(key);int id;
  if(it==classes.end()){id=classes.size();classes[key]=id;counts.push_back(0);comparisons.push_back(c);
   ofstream f("round5/classes/p"+to_string(id)+".s");f<<"# n=5 model=out iset=I1 prefix14_class="<<id<<"\n"<<prefix;
   ofstream g("round5/classes/p"+to_string(id)+"_sort4.s");g<<"# n=4 model=out iset=I1\n"<<full;
  }else id=it->second;
  counts[id]++;
 };
 reset();
 while(getline(cin,line)){
  if(line.rfind("# prog",0)==0){finish();reset();continue;}
  if(line.empty()||line[0]=='#')continue;
  full+=line+"\n";
  istringstream ss(line);string op,d,s;ss>>op>>d>>s;
  if(op=="out")continue;
  k++;if(k>14)continue;
  prefix+=line+"\n";int x=rid(d),y=rid(s);
  if(op=="mov"){r[x]=r[y];written[x]=true;}
  else if(op=="cmp"){c++;lo=eq=0;for(int t=0;t<24;t++){
   int u=(r[x]>>(3*t))&7,v=(r[y]>>(3*t))&7;
   if(u<v)lo|=Col(7)<<(3*t);if(u==v)eq|=Col(7)<<(3*t);
  }}else{Col take=op=="cmovl"?lo:op=="cmovle"?(lo|eq):op=="cmovg"?(MASK^(lo|eq)):(MASK^lo);
   r[x]=(r[x]&~take)|(r[y]&take);written[x]=true;}
 }
 finish();ofstream out("round5/logs/prefix_classes.tsv");
 for(int id=0;id<(int)counts.size();id++)out<<id<<'\t'<<counts[id]<<'\t'<<comparisons[id]<<'\n';
 cout<<"programs "<<n<<" prefix14_classes "<<classes.size()<<'\n';
}
