#include <bits/stdc++.h>
#include <filesystem>
using namespace std;
struct Ins {int op,d,s;};
using Col=array<int,120>;
using State=array<Col,16>;
vector<array<int,5>> perms;
vector<Ins> code;
const char* names[]={"mov","cmp","cmovl","cmovg","cmovle","cmovge"};
int regid(string s){if(s.back()==',')s.pop_back();return stoi(s.substr(1))+(s[0]=='S'?5:0);}
string rn(int r){return r<5?"P"+to_string(r):"S"+to_string(r-5);}
bool take(int op,int f){return op==2?f<0:op==3?f>0:op==4?f<=0:f>=0;}
bool step(State&r,Col&fl,Ins x,int&done){
 for(int t=0;t<120;t++){
  if(r[x.s][t]<0||(x.op&&r[x.d][t]<0))return false;
  if(x.op==1)fl[t]=(r[x.d][t]>r[x.s][t])-(r[x.d][t]<r[x.s][t]);
  else if(!x.op||take(x.op,fl[t]))r[x.d][t]=r[x.s][t];
 }
 if(x.op!=1){int v=r[x.d][0];bool fixed=true;for(int t=1;t<120;t++)if(r[x.d][t]!=v){fixed=false;break;}if(fixed&&v>=0)done|=1<<v;}
 return true;
}
void emit(const vector<Ins>&a,const string&fn,int output_count=5){
 ofstream f(fn);f<<"# n=5 iset=I1 model=out source=w2_insert_one\n";
 if(output_count<5)f<<"# Partial trace; not a sorting program. Available outputs="<<output_count<<"\n";
 State r;for(auto&c:r)c.fill(-1);for(int i=0;i<5;i++)for(int t=0;t<120;t++)r[i][t]=perms[t][i];Col fl;fl.fill(99);int done=0;
 for(auto x:a){f<<names[x.op]<<' '<<rn(x.d)<<", "<<rn(x.s)<<'\n';int before=done;if(!step(r,fl,x,done))abort();for(int j=0;j<5;j++)if((done&~before)>>j&1)f<<"out "<<j<<", "<<rn(x.d)<<'\n';}
}
int main(int argc,char**argv){
 if(argc<3){cerr<<"usage: insert_one core.s outdir [replace]\n";return 1;}
 bool replace=argc>3&&string(argv[3])=="replace";
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 ifstream f(argv[1]);string line;int maxr=5;
 while(getline(f,line)){istringstream ss(line);string op,d,s;ss>>op>>d>>s;int k=-1;for(int i=0;i<6;i++)if(op==names[i])k=i;if(k<0)continue;code.push_back({k,regid(d),regid(s)});maxr=max({maxr,regid(d)+1,regid(s)+1});}
 filesystem::create_directories(argv[2]);
 State prefix;for(auto&c:prefix)c.fill(-1);for(int i=0;i<5;i++)for(int t=0;t<120;t++)prefix[i][t]=perms[t][i];Col flags;flags.fill(99);int prefix_done=0,ncmp=0;
 long long attempts=0,found=0,partial=0;array<long long,6> score{};
 for(int pos=0;pos<=(int)code.size();pos++){
  if(!replace||pos<(int)code.size())
  for(int op=0;op<6;op++)if((replace&&code[pos].op==1)?op==1:(op!=1&&(op==0||ncmp)))for(int d=0;d<maxr;d++)for(int s=0;s<maxr;s++)if(prefix[s][0]>=0&&(!op||prefix[d][0]>=0)){
   attempts++;State r=prefix;Col fl=flags;int done=prefix_done;Ins add={op,d,s};bool ok=step(r,fl,add,done);
   for(int k=pos+(replace?1:0);ok&&k<(int)code.size();k++)ok=step(r,fl,code[k],done);
   if(!ok)continue;score[__builtin_popcount((unsigned)done)]++;
   if(done==31){vector<Ins> a=code;if(replace)a[pos]=add;else a.insert(a.begin()+pos,add);string path=string(argv[2])+"/one_"+to_string(++found)+".s";emit(a,path);cout<<"CANDIDATE "<<path<<" cost="<<a.size()<<" position="<<pos<<","<<op<<","<<d<<","<<s<<'\n';}
   else if(__builtin_popcount((unsigned)done)==4){vector<Ins> a=code;if(replace)a[pos]=add;else a.insert(a.begin()+pos,add);string path=string(argv[2])+"/partial_"+to_string(++partial)+".s";emit(a,path,4);cout<<"PARTIAL "<<path<<" cost="<<a.size()<<" position="<<pos<<","<<op<<","<<d<<","<<s<<'\n';}
  }
  if(pos==(int)code.size())break;
  if(!step(prefix,flags,code[pos],prefix_done)){cerr<<"undefined source prefix\n";return 2;}if(code[pos].op==1)ncmp++;
 }
 cout<<"ENUMERATION COMPLETE mode="<<(replace?"replace":"insert")<<" attempts="<<attempts<<" candidates="<<found<<" partial="<<partial<<" source_core="<<code.size()<<" output_counts=";for(int i=0;i<6;i++)cout<<i<<":"<<score[i]<<",";cout<<'\n';
}
