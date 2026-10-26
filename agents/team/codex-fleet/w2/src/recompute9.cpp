#include <bits/stdc++.h>
#include <filesystem>
using namespace std;
namespace fs=std::filesystem;
// A finite neighbourhood of fam32 programs. Remove two copies by register
// coalescing, then insert one initialized-register conditional move. With
// two removed copies, C=9, G=19, Q=3; with one, C=9, G=19, Q=4.
// The trace need not itself sort: retain
// its comparison skeleton iff its flag histories separate all strict orders.
// dagx subsequently searches all routing in each retained value skeleton.
struct Ins {int op,d,s;}; // mov=0 cmp=1 l=2 g=3 le=4 ge=5
using Reg=array<int,16>;
using Sk=array<array<unsigned char,120>,18>;
vector<array<int,5>> perms;
int rename_type[120][120];
long long attempted=0,complete=0,duplicates=0,excluded=0,direct=0;
long long real_recomputations=0,recompute_new_variants=0;
unordered_set<string> seen,old;
unordered_map<string,int> ids;
bool cond(int op,int flag){return op==2?flag<0:op==3?flag>0:op==4?flag<=0:flag>=0;}
int rid(string s){if(s.back()==',')s.pop_back();return s[0]=='P'?stoi(s.substr(1)):5+stoi(s.substr(1));}
vector<Ins> load(const fs::path&p){
 ifstream f(p); string l; vector<Ins> a;
 map<string,int> ops={{"mov",0},{"cmp",1},{"cmovl",2},{"cmovg",3},{"cmovle",4},{"cmovge",5}};
 while(getline(f,l)){istringstream ss(l);string op,d,s;ss>>op>>d>>s;if(!ops.count(op))continue;a.push_back({ops.at(op),rid(d),rid(s)});}return a;
}
string canonical(const Sk&sk){
 string best;
 // Input permutation and independent comparison reversal are routing symmetries.
 for(int pi=0;pi<120;pi++){
  string key;key.reserve(2160);bool worse=false;
  for(int j=0;j<9&&!worse;j++){
   string a,b;a.reserve(120);b.reserve(120);
   for(int t=0;t<120;t++){a+=char('0'+sk[2*j][rename_type[pi][t]]);b+=char('0'+sk[2*j+1][rename_type[pi][t]]);}
   if(b<a)swap(a,b);key+=a;key+=b;
   if(!best.empty()&&key.compare(0,key.size(),best,0,key.size())>0)worse=true;
  }
  if(!worse&&(best.empty()||key<best))best=move(key);
 }return best;
}
Sk trace(const vector<Ins>&a){Sk sk{};for(int t=0;t<120;t++){Reg r;r.fill(-1);for(int i=0;i<5;i++)r[i]=perms[t][i];int fl=0,j=0;for(auto x:a){if(x.op==0)r[x.d]=r[x.s];else if(x.op==1){sk[2*j][t]=r[x.d];sk[2*j+1][t]=r[x.s];j++;fl=(r[x.d]>r[x.s])-(r[x.d]<r[x.s]);}else if(cond(x.op,fl))r[x.d]=r[x.s];}}return sk;}
int ev(const string&f,int t){if(f[0]=='=')return f.at(t+1)-'0';int v=-1,m=5;for(char c:f){if(c=='|'){v=max(v,m);m=5;}else if(c>='0'&&c<='4')m=min(m,perms[t][c-'0']);else throw runtime_error("bad formula");}return max(v,m);}
bool readsk(const fs::path&fn,Sk&sk){
 ifstream f(fn);string l;int j=0;while(getline(f,l)){istringstream ss(l);string tok;ss>>tok;if(tok.empty()||tok[0]=='#')continue;
  if(j>=9)return false;tok=tok.substr(0,tok.find(';'));auto c=tok.find(':');if(c==string::npos)return false;
  try{for(int t=0;t<120;t++){int a=ev(tok.substr(0,c),t),b=ev(tok.substr(c+1),t);if(a<0||a>4||b<0||b>4)return false;sk[2*j][t]=a;sk[2*j+1][t]=b;}}catch(...){return false;}j++;
 }return j==9;
}
int main(int argc,char**argv){
 if(argc<3){cerr<<"usage: recompute9 fam32 outdir [removed_copies=2] [excluded_skeleton_dir]\n";return 1;}
 int remove_count=argc>3?atoi(argv[3]):2;
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 if(string(argv[1])=="--compare"&&argc==4){Sk a,b;if(!readsk(argv[2],a)||!readsk(argv[3],b))return 2;cout<<(canonical(a)==canonical(b)?"EQUIVALENT":"DISTINCT")<<'\n';return 0;}
 fs::create_directories(argv[2]);ofstream manifest(string(argv[2])+"/manifest.tsv");manifest<<"file\tseed\tremoved_move_a\tremoved_move_b\tinsertion\top\tdest\tsource\tdirect_sorts\trecompute_kind\n";
 ofstream recipes(string(argv[2])+"/all_viable_recipes.tsv");recipes<<"seed\tremoved_move_a\tremoved_move_b\tinsertion\top\tdest\tsource\trecompute_kind\tskeleton_id\tpreviously_tested\n";
 vector<fs::path> files;for(auto&e:fs::directory_iterator(argv[1]))if(e.path().extension()==".s")files.push_back(e.path());sort(files.begin(),files.end());
 for(auto fn:files)old.insert(canonical(trace(load(fn))));
 if(argc>4){long long count=0;for(auto&e:fs::recursive_directory_iterator(argv[4]))if(e.is_regular_file()&&e.path().extension()==".txt"){Sk sk;if(readsk(e.path(),sk)){old.insert(canonical(sk));count++;}}cerr<<"excluded_files="<<count<<" excluded_unique="<<old.size()<<"\n";}
 for(auto fn:files){
  auto original=load(fn);vector<int> copies;for(int i=0;i<(int)original.size();i++)if(!original[i].op)copies.push_back(i);
  if(original.size()!=32||copies.size()!=5){cerr<<"bad seed "<<fn<<"\n";return 2;}
  for(int ca=0;ca<5;ca++)for(int cb=(remove_count==1?5:ca+1);cb<(remove_count==1?6:5);cb++){
   int a=copies[ca],b=(remove_count==1?-1:copies[cb]);array<int,16> alias; iota(alias.begin(),alias.end(),0);vector<Ins> code;
   for(int i=0;i<32;i++){auto x=original[i];if(i==a||i==b){alias[x.d]=alias[x.s];continue;}code.push_back({x.op,alias[x.d],alias[x.s]});}
   // Cache the prefix state and prefix comparison columns at every insertion.
   array<Reg,120> prefix;array<int,120> flags{};array<int,120> histories{};Sk before{};int nj=0;
   for(int t=0;t<120;t++){prefix[t].fill(-1);for(int i=0;i<5;i++)prefix[t][i]=perms[t][i];}
   set<array<unsigned char,120>> historic;
   for(int i=0;i<5;i++){array<unsigned char,120> col;for(int t=0;t<120;t++)col[t]=prefix[t][i];historic.insert(col);}
   int len=code.size();
   for(int pos=0;pos<=len;pos++){
    if(nj){
     vector<int> live;for(int d=0;d<16;d++){bool ok=true;for(int t=0;t<120;t++)if(prefix[t][d]<0)ok=false;if(ok)live.push_back(d);}
     for(int d:live)for(int s:live)if(d!=s)for(int op=2;op<6;op++){
      attempted++;Sk sk=before;array<int,19683> used{};bool ok=true;bool identity=true;
      for(int t=0;t<120&&ok;t++){
       Reg r=prefix[t];int fl=flags[t],h=histories[t],j=nj;
       if(cond(op,fl)){identity &= r[d]==r[s];r[d]=r[s];}
       for(int k=pos;k<len;k++){
        auto x=code[k];if(r[x.s]<0||(x.op&&r[x.d]<0)){ok=false;break;}
        if(x.op==0)r[x.d]=r[x.s];
        else if(x.op==1){sk[2*j][t]=r[x.d];sk[2*j+1][t]=r[x.s];j++;fl=(r[x.d]>r[x.s])-(r[x.d]<r[x.s]);h=3*h+fl+1;}
        else if(cond(x.op,fl))r[x.d]=r[x.s];
       }
       if(ok&&used[h])ok=false;else if(ok)used[h]=1;
      }
      if(!ok||identity)continue;complete++;
      array<unsigned char,120> value;for(int t=0;t<120;t++)value[t]=cond(op,flags[t])?prefix[t][s]:prefix[t][d];
      bool present=false;for(int reg:live){bool same=true;for(int t=0;t<120;t++)if(prefix[t][reg]!=value[t]){same=false;break;}if(same){present=true;break;}}
      string kind=present?"duplicate_existing":historic.count(value)?"recomputed_lost":"new_value";
      if(kind=="recomputed_lost")real_recomputations++;
      string key=canonical(sk);bool known=old.count(key);if(!known&&kind=="recomputed_lost")recompute_new_variants++;
      if(!known&&!ids.count(key))ids[key]=ids.size()+1;
      recipes<<fn.filename().string()<<'\t'<<a<<'\t'<<b<<'\t'<<pos<<'\t'<<op<<'\t'<<d<<'\t'<<s<<'\t'<<kind<<'\t'<<(known?0:ids[key])<<'\t'<<known<<'\n';
      if(known){excluded++;continue;}if(!seen.insert(key).second){duplicates++;continue;}
      int ix=seen.size();char name[64];snprintf(name,sizeof(name),"r%06d.txt",ix);
      ofstream f(string(argv[2])+"/"+name);f<<"# fam32="<<fn.filename()<<" coalesce="<<a<<","<<b<<" recompute="<<pos<<","<<op<<","<<d<<","<<s<<"\n";
      for(int j=0;j<9;j++){f<<'=';for(int t=0;t<120;t++)f<<int(sk[2*j][t]);f<<":=";for(int t=0;t<120;t++)f<<int(sk[2*j+1][t]);f<<'\n';}
      manifest<<name<<'\t'<<fn.filename().string()<<'\t'<<a<<'\t'<<b<<'\t'<<pos<<'\t'<<op<<'\t'<<d<<'\t'<<s<<"\tunchecked\t"<<kind<<'\n';
     }
    }
    if(pos==len)break;auto x=code[pos];
    for(int t=0;t<120;t++){auto&r=prefix[t];if(x.op==0)r[x.d]=r[x.s];else if(x.op==1){before[2*nj][t]=r[x.d];before[2*nj+1][t]=r[x.s];flags[t]=(r[x.d]>r[x.s])-(r[x.d]<r[x.s]);histories[t]=3*histories[t]+flags[t]+1;}else if(cond(x.op,flags[t]))r[x.d]=r[x.s];}
    if(x.op!=1){array<unsigned char,120> col;bool defined=true;for(int t=0;t<120;t++){if(prefix[t][x.d]<0)defined=false;col[t]=prefix[t][x.d];}if(defined)historic.insert(col);}
    if(x.op==1)nj++;
   }
  }
  cerr<<"seed="<<fn.filename()<<" attempted="<<attempted<<" complete="<<complete<<" excluded_base="<<excluded<<" duplicates="<<duplicates<<" new="<<seen.size()<<"\n";
 }
 cerr<<"GENERATION COMPLETE attempted="<<attempted<<" complete="<<complete<<" excluded_base="<<excluded<<" duplicates="<<duplicates<<" new="<<seen.size()<<" real_recomputations="<<real_recomputations<<" recompute_new_variants="<<recompute_new_variants<<"\n";
}
