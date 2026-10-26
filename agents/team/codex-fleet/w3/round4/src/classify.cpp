#include <algorithm>
#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>
using namespace std;
__uint128_t all=((__uint128_t(1)<<72)-1); vector<array<int,4>> perms;
int rid(string s){if(s.back()==',')s.pop_back();return s[0]=='P'?stoi(s.substr(1)):5+stoi(s.substr(1));}
int main(int argc,char**argv){bool write_representatives=argc==1;array<int,4>a={0,1,2,3};do{perms.push_back(a);}while(next_permutation(a.begin(),a.end()));
 map<vector<__uint128_t>,int> classes; vector<__uint128_t> r(50); vector<bool> defined(50);__uint128_t lo=0,eq=all;string line,prog;long n=0;map<int,long> counts; vector<__uint128_t> key;
 auto reset=[&](){fill(r.begin(),r.end(),0); for(int t=0;t<24;t++)r[0]|=__uint128_t(4)<<(3*t); fill(r.begin(),r.end(),r[0]); fill(defined.begin(),defined.end(),false); for(int j=0;j<4;j++)defined[j]=true;for(int j=0;j<4;j++){r[j]=0;for(int t=0;t<24;t++)r[j]|=__uint128_t(perms[t][j])<<(3*t);}lo=0;eq=all;prog="";};
 auto finish=[&](){if(prog.empty())return;n++;key.clear();for(int j=0;j<50;j++)if(defined[j])key.push_back(r[j]);sort(key.begin(),key.end());key.push_back(lo);key.push_back(eq);auto it=classes.find(key);int c;if(it==classes.end()){c=classes.size();classes[key]=c;if(write_representatives){ofstream f("round4/classes/raw"+to_string(c)+".s");f<<"# n=4 model=out iset=I1 source=sort4_collection\n"<<prog;}}else c=it->second;counts[c]++;};
 reset();while(getline(cin,line)){if(line.rfind("# prog",0)==0){finish();reset();continue;}if(line.empty()||line[0]=='#')continue;prog+=line+"\n";istringstream ss(line);string op,d,s;ss>>op>>d>>s;if(op=="out")continue;int x=rid(d),y=rid(s);if(op=="mov"){r[x]=r[y];defined[x]=true;}else if(op=="cmp"){lo=eq=0;for(int t=0;t<24;t++){int u=(r[x]>>(3*t))&7,v=(r[y]>>(3*t))&7;if(u<v)lo|=__uint128_t(7)<<(3*t);if(u==v)eq|=__uint128_t(7)<<(3*t);}}else{__uint128_t take=op=="cmovl"?lo:op=="cmovle"?(lo|eq):op=="cmovg"?(all^(lo|eq)):(all^lo);r[x]=(r[x]&~take)|(r[y]&take);defined[x]=true;}}
 finish();ofstream f("round4/logs/raw_classes.tsv");for(auto [c,k]:counts)f<<c<<"\t"<<k<<"\n";cout<<"programs "<<n<<" raw_state_classes "<<classes.size()<<"\n";
}
