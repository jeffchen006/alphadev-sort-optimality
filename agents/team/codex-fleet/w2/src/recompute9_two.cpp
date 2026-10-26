// Extend verified lost-value recipes with a second conditional move.
#define main original_generator_main
#include "recompute9.cpp"
#undef main
struct Recipe {string seed;int removed,pos,op,d,s;};
struct Trial {int recipe,pos,op,d,s;};
static string regname(int r){return r<5?"P"+to_string(r):"S"+to_string(r-5);}
static const char* opnames[]={"mov","cmp","cmovl","cmovg","cmovle","cmovge"};
static vector<Ins> rebuild(const Recipe& q,const fs::path& seeds){
 auto original=load(seeds/q.seed);array<int,16> alias;iota(alias.begin(),alias.end(),0);vector<Ins> code;
 for(int i=0;i<(int)original.size();i++){auto x=original[i];if(i==q.removed){alias[x.d]=alias[x.s];continue;}code.push_back({x.op,alias[x.d],alias[x.s]});}
 code.insert(code.begin()+q.pos,{q.op,q.d,q.s});return code;
}
static bool evaluate(const vector<Ins>& code,Sk& sk,int inserted){
 array<int,19683> used{};bool changed=false;
 for(int t=0;t<120;t++){
  Reg r;r.fill(-1);for(int i=0;i<5;i++)r[i]=perms[t][i];int fl=0,j=0,h=0;
  for(int i=0;i<(int)code.size();i++){
   auto x=code[i];if(r[x.s]<0 || (x.op && r[x.d]<0))return false;
   if(x.op==0)r[x.d]=r[x.s];
   else if(x.op==1){if(j==9)return false;sk[2*j][t]=r[x.d];sk[2*j+1][t]=r[x.s];j++;fl=(r[x.d]>r[x.s])-(r[x.d]<r[x.s]);h=3*h+fl+1;}
   else if(cond(x.op,fl)){if(i==inserted && r[x.d]!=r[x.s])changed=true;r[x.d]=r[x.s];}
  }
  if(j!=9 || used[h])return false;used[h]=1;
 }
 return changed;
}
static bool check_restoration(const vector<Ins>& code,int pos){
 vector<array<int,120>> historic;array<Reg,120> states;array<int,120> flags{};
 for(int t=0;t<120;t++){states[t].fill(-1);for(int r=0;r<5;r++)states[t][r]=perms[t][r];}
 for(int r=0;r<5;r++){array<int,120> c;for(int t=0;t<120;t++)c[t]=states[t][r];historic.push_back(c);}
 for(int i=0;i<=pos;i++){
  auto x=code[i];array<int,120> value;
  if(i==pos){
   for(int t=0;t<120;t++)value[t]=cond(x.op,flags[t])?states[t][x.s]:states[t][x.d];
   if(find(historic.begin(),historic.end(),value)==historic.end())return false;
   for(int r=0;r<16;r++){bool same=true;for(int t=0;t<120;t++)if(states[t][r]!=value[t])same=false;if(same)return false;}
   return true;
  }
  for(int t=0;t<120;t++){auto& r=states[t];if(x.op==0)r[x.d]=r[x.s];else if(x.op==1)flags[t]=(r[x.d]>r[x.s])-(r[x.d]<r[x.s]);else if(cond(x.op,flags[t]))r[x.d]=r[x.s];value[t]=r[x.d];}
  if(x.op!=1 && *min_element(value.begin(),value.end())>=0)historic.push_back(value);
 }
 return false;
}
int main(int argc,char**argv){
 if(argc<5){cerr<<"usage: recompute9_two fam32 recipes.tsv outdir excluded_dir...\n";return 2;}
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 fs::path seeds=argv[1],out=argv[3];fs::create_directories(out);fs::create_directories(out/"traces");
 for(auto&e:fs::directory_iterator(seeds))if(e.path().extension()==".s")old.insert(canonical(trace(load(e.path()))));
 for(int i=4;i<argc;i++){long long n=0;for(auto&e:fs::recursive_directory_iterator(argv[i]))if(e.is_regular_file()&&e.path().extension()==".txt"){Sk sk;if(readsk(e.path(),sk)){old.insert(canonical(sk));n++;}}cerr<<"EXCLUDE folder="<<argv[i]<<" parsed="<<n<<" unique_total="<<old.size()<<'\n';}
 vector<Recipe> recipes;ifstream in(argv[2]);string line;getline(in,line);
 while(getline(in,line)){vector<string> fields;istringstream ss(line);string x;while(getline(ss,x,'\t'))fields.push_back(x);if(fields.size()<8 || fields[7]!="recomputed_lost")continue;
  Recipe q{fields[0],stoi(fields[1]),stoi(fields[3]),stoi(fields[4]),stoi(fields[5]),stoi(fields[6])};auto code=rebuild(q,seeds);if(!check_restoration(code,q.pos)){cerr<<"Restoration check failed\n";return 3;}recipes.push_back(q);}
 vector<vector<Ins>> codes;map<string,vector<Trial>> groups;mt19937 rng(3252026);
 for(int ri=0;ri<(int)recipes.size();ri++){
  auto code=rebuild(recipes[ri],seeds);codes.push_back(code);auto& trials=groups[recipes[ri].seed];
  // A later second insertion cannot change the checked restoration.
  for(int pos=recipes[ri].pos+1;pos<(int)code.size();pos++)for(int op=2;op<6;op++)for(int d=0;d<9;d++)for(int s=0;s<9;s++)if(d!=s)trials.push_back({ri,pos,op,d,s});
 }
 for(auto& [seed,trials]:groups)shuffle(trials.begin(),trials.end(),rng);
 map<string,size_t> cursor;map<string,int> counts;long long tried=0,viable=0,prior=0,dup=0;int total=0;
 ofstream manifest(out/"manifest.tsv");manifest<<"file\tseed\tremoved_move\trestore_pos\trestore_op\trestore_dest\trestore_source\tsecond_pos\tsecond_op\tsecond_dest\tsecond_source\n";
 while(total<200){bool progress=false;
  for(auto& [seed,trials]:groups){
   while(cursor[seed]<trials.size()){
    Trial a=trials[cursor[seed]++];tried++;auto code=codes[a.recipe];code.insert(code.begin()+a.pos,{a.op,a.d,a.s});Sk sk{};if(!evaluate(code,sk,a.pos))continue;viable++;
    string key=canonical(sk);if(old.count(key)){prior++;continue;}if(!seen.insert(key).second){dup++;continue;}
    total++;counts[seed]++;progress=true;char name[32];snprintf(name,sizeof(name),"t%06d.txt",total);auto q=recipes[a.recipe];
    ofstream f(out/name);f<<"# seed="<<seed<<" actual_lost_value_restored=1 removed="<<q.removed<<" restore="<<q.pos<<','<<q.op<<','<<q.d<<','<<q.s<<" second="<<a.pos<<','<<a.op<<','<<a.d<<','<<a.s<<'\n';
    for(int j=0;j<9;j++){f<<'=';for(int t=0;t<120;t++)f<<int(sk[2*j][t]);f<<":=";for(int t=0;t<120;t++)f<<int(sk[2*j+1][t]);f<<'\n';}
    manifest<<name<<'\t'<<seed<<'\t'<<q.removed<<'\t'<<q.pos<<'\t'<<q.op<<'\t'<<q.d<<'\t'<<q.s<<'\t'<<a.pos<<'\t'<<a.op<<'\t'<<a.d<<'\t'<<a.s<<'\n';
    ofstream tr(out/"traces"/(string(name)+".source"));for(auto x:code)tr<<opnames[x.op]<<' '<<regname(x.d)<<", "<<regname(x.s)<<'\n';
    cerr<<"NEW "<<name<<" seed="<<seed<<" tried="<<tried<<" viable="<<viable<<'\n';break;
   }
   if(total==200)break;
  }
  if(!progress)break;
 }
 cerr<<"GENERATION COMPLETE total="<<total<<" tried="<<tried<<" viable="<<viable<<" prior="<<prior<<" duplicates="<<dup<<" restoration_recipes="<<recipes.size()<<'\n';
 for(auto&[seed,n]:counts)cerr<<"FAMILY "<<seed<<" count="<<n<<'\n';return total==200?0:4;
}
