// New ten-comparison skeletons: repeat an earlier pair in a c=9 mutation.
// Exclude input-renaming / comparison-reversal equivalents of prior cases.
#define main prior_generator_main
#include "recompute9.cpp"
#undef main
using Pair = pair<array<unsigned char,120>,array<unsigned char,120>>;
using Skeleton = vector<Pair>;
struct Parsed {Skeleton sk; bool alternatives=false;};
static Parsed parse(const fs::path& fn) {
 ifstream f(fn);string line;Parsed p;
 try {while(getline(f,line)) {
  istringstream in(line);string tok;in>>tok;if(tok.empty()||tok[0]=='#')continue;
  p.alternatives |= tok.find(';')!=string::npos;tok=tok.substr(0,tok.find(';'));
  auto sep=tok.find(':');if(sep==string::npos)return {};
  Pair q;for(int t=0;t<120;t++){int a=ev(tok.substr(0,sep),t),b=ev(tok.substr(sep+1),t);
   if(a<0||a>4||b<0||b>4)return {};q.first[t]=a;q.second[t]=b;}
  p.sk.push_back(q);
 }}catch(...){return {};}
 return p;
}
static string key(const Skeleton& sk,bool flags=false) {
 string best;
 for(int pi=0;pi<120;pi++) {
  string k;bool worse=false;
  for(auto&[a,b]:sk){
   string x,y;
   for(int t=0;t<120;t++){int j=rename_type[pi][t];
    if(flags){int v=(a[j]>b[j])-(a[j]<b[j]);x+=char('1'+v);y+=char('1'-v);}
    else{x+=char('0'+a[j]);y+=char('0'+b[j]);}}
   if(flags){
    // With two outcomes, lt/gt and lt/eq give the same selectable masks.
    // Normalize the partition, including this change of outcome labels.
    set<char> outcomes(x.begin(),x.end());
    if(outcomes.size()==1){x=string(120,'0');y=x;x='c'+x;y='c'+y;}
    else if(outcomes.size()==2){char first=x[0];for(char&v:x)v='0'+(v!=first);y=x;x='b'+x;y='b'+y;}
    else{x='t'+x;y='t'+y;}
   }
   if(y<x)swap(x,y);k+=x;if(!flags)k+=y;
   if(!best.empty()&&k.compare(0,k.size(),best,0,k.size())>0){worse=true;break;}
  }
  if(!worse&&(best.empty()||k<best))best=move(k);
 }
 return best;
}
int main(int argc,char**argv){
 if(argc<5){cerr<<"usage: generate source_dir outdir excluded_dir...\n";return 2;}
 cerr<<"FLAG_CLASS_NORMALIZATION selectable_masks_v2\n";
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 unordered_set<string> excluded,alternative_flags,selected;
 for(int arg=3;arg<argc;arg++){
  long long parsed=0,alt=0,files=0;
  for(auto&e:fs::recursive_directory_iterator(argv[arg]))if(e.is_regular_file()&&e.path().extension()==".txt"){
   files++;auto p=parse(e.path());if(p.sk.size()!=10)continue;
   parsed++;excluded.insert(key(p.sk));
   // Each alternative line has the same masks, up to operand reversal.
   // Excluding its entire flag class conservatively skips every alternative.
   if(p.alternatives){alternative_flags.insert(key(p.sk,true));alt++;}
  }
  cerr<<"EXCLUDE folder="<<argv[arg]<<" files="<<files<<" c10="<<parsed<<" alt="<<alt<<" unique="<<excluded.size()<<'\n';
 }
 vector<fs::path> sources;for(auto&e:fs::directory_iterator(argv[1]))if(e.path().extension()==".txt"&&e.path().filename().string()[0]=='r')sources.push_back(e.path());sort(sources.begin(),sources.end());
 fs::path out=argv[2];fs::create_directories(out);ofstream manifest(out/"manifest.tsv");
 manifest<<"file\tsource\trepeated_cmp_1based\tinsert_before_cmp_1based\tcanonical_sha_in_audit\n";
 int count=0,known=0,dup=0,flag_skip=0;map<string,int> seed_counts;
 // Round robin over source skeletons. Prefer long gaps, then other positions.
 vector<pair<int,int>> recipes;
 for(int insert=9;insert>=2;insert--)for(int repeat=0;repeat<insert-1;repeat++)recipes.push_back({repeat,insert});
 for(auto[repeat,insert]:recipes)for(auto src:sources){
  auto base=parse(src).sk;if(base.size()!=9)return 3;
  auto candidate=base;candidate.insert(candidate.begin()+insert,base[repeat]);
  string k=key(candidate);
  if(excluded.count(k)){known++;continue;}
  if(alternative_flags.count(key(candidate,true))){flag_skip++;continue;}
  if(!selected.insert(k).second){dup++;continue;}
  count++;char name[32];snprintf(name,sizeof(name),"q%06d.txt",count);
  ofstream f(out/name);f<<"# source="<<src<<" c=10 repeat_cmp="<<repeat+1<<" insert_before_cmp="<<insert+1<<" assumptions=A4,A6\n";
  for(auto&[a,b]:candidate){f<<'=';for(int t=0;t<120;t++)f<<int(a[t]);f<<":=";for(int t=0;t<120;t++)f<<int(b[t]);f<<'\n';}
  manifest<<name<<'\t'<<src.string()<<'\t'<<repeat+1<<'\t'<<insert+1<<"\tsee_generation_audit.json\n";
  ifstream source(src);string first;getline(source,first);seed_counts[first.substr(0,first.find(" coalesce="))]++;
  cerr<<"NEW "<<name<<" source="<<src.filename()<<" repeat="<<repeat+1<<" before="<<insert+1<<'\n';
  if(count==300)goto done;
 }
 done:
 cerr<<"GENERATION COMPLETE count="<<count<<" sources="<<sources.size()<<" excluded="<<known<<" duplicate="<<dup<<" alternative_flag_skip="<<flag_skip<<'\n';
 for(auto&[s,n]:seed_counts)cerr<<"SEED "<<s<<" count="<<n<<'\n';
 return count==300?0:4;
}
