// Two repeats in c=8 sources; one repeat in c=10 sources.
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


struct Source { fs::path path; Skeleton sk; };
static bool separates(const Skeleton& sk) {
 set<string> histories;
 for(int t=0;t<120;t++) {string h;for(auto&[a,b]:sk)h+=char('1'+(a[t]>b[t])-(a[t]<b[t]));histories.insert(h);}
 return histories.size()==120;
}
static void save(const fs::path& out,int id,const Source& s,const Skeleton& sk,
                 const vector<pair<int,int>>& repeats,ofstream& manifest) {
 char name[32];snprintf(name,sizeof(name),"q%06d.txt",id);
 ofstream f(out/name);f<<"# source="<<s.path<<" comparisons="<<sk.size()<<" assumptions=A4,A6\n";
 for(auto&[a,b]:sk){f<<'=';for(int t=0;t<120;t++)f<<int(a[t]);f<<":=";for(int t=0;t<120;t++)f<<int(b[t]);f<<'\n';}
 manifest<<name<<'\t'<<s.path.string()<<'\t';
 for(size_t j=0;j<repeats.size();j++){if(j)manifest<<',';manifest<<repeats[j].first+1;}
 manifest<<'\t';for(size_t j=0;j<repeats.size();j++){if(j)manifest<<',';manifest<<repeats[j].second+1;}
 manifest<<'\n';
}
int main(int argc,char**argv) {
 if(argc<5){cerr<<"usage: generate source8.list source10.list outprefix exclude_dir...\n";return 2;}
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 unordered_set<string> excluded[2],alternative_flags[2];
 for(int arg=4;arg<argc;arg++){
  long long files=0,counts[2]={},alts[2]={};
  for(auto&e:fs::recursive_directory_iterator(argv[arg]))if(e.is_regular_file()&&(e.path().extension()==".txt"||e.path().extension()==".skel")){
   files++;auto parsed=parse(e.path());int idx=parsed.sk.size()==10?0:parsed.sk.size()==11?1:-1;if(idx<0)continue;
   counts[idx]++;excluded[idx].insert(key(parsed.sk));
   if(parsed.alternatives){alternative_flags[idx].insert(key(parsed.sk,true));alts[idx]++;}
  }
  cerr<<"EXCLUDE "<<argv[arg]<<" files="<<files<<" c10="<<counts[0]<<" c11="<<counts[1]<<" alt10="<<alts[0]<<" alt11="<<alts[1]<<" unique10="<<excluded[0].size()<<" unique11="<<excluded[1].size()<<'\n';
 }
 vector<Source> sources[2];
 for(int idx=0;idx<2;idx++){
  ifstream f(argv[1+idx]);string line;unordered_set<string> seen;
  while(getline(f,line)){auto sk=parse(line).sk;if(sk.size()!=(idx?10:8)||!separates(sk))continue;
   if(seen.insert(key(sk)).second)sources[idx].push_back({line,sk});}
  cerr<<"SOURCES c="<<(idx?10:8)<<" distinct="<<sources[idx].size()<<'\n';
 }
 for(int idx=0;idx<2;idx++){
  fs::path out=string(argv[3])+(idx?"_c11":"_c10");fs::create_directories(out);ofstream mf(out/"manifest.tsv");
  mf<<"file\tsource\trepeated_cmp_1based\tinsert_before_source_cmp_1based\n";
  unordered_set<string> selected;int count=0,known=0,dup=0,flag_skip=0;
  auto retain=[&](const Source& s,const Skeleton& sk,const vector<pair<int,int>>& recipes){
   string k=key(sk);if(excluded[idx].count(k)){known++;return;}
   if(alternative_flags[idx].count(key(sk,true))){flag_skip++;return;}
   if(!selected.insert(k).second){dup++;return;}
   save(out,++count,s,sk,recipes,mf);
  };
  if(!idx){
   // Slots refer to boundaries in the original c=8 source. Both repeats
   // follow their original comparison. Distinct original pairs come first.
   for(int same=0;same<=1;same++)for(int gap=16;gap>=2;gap--)
    for(int a=8;a>=2;a--)for(int b=8;b>=a;b--)
     for(int r1=0;r1<a-1;r1++)for(int r2=0;r2<b-1;r2++){
      if((r1==r2)!=bool(same)||a-r1+b-r2!=gap)continue;
      for(auto&s:sources[idx]){
       auto sk=s.sk;sk.insert(sk.begin()+b,s.sk[r2]);sk.insert(sk.begin()+a,s.sk[r1]);
       retain(s,sk,{{r1,a},{r2,b}});if(count==300)goto done;
      }
     }
  }else{
   // Cycle positions, rather than using only final repeats.
   for(int repeat=0;repeat<9;repeat++)for(int insert:vector<int>{10,8,6,4,2,9,7,5,3})if(repeat<insert-1)
    for(auto&s:sources[idx]){auto sk=s.sk;sk.insert(sk.begin()+insert,s.sk[repeat]);retain(s,sk,{{repeat,insert}});if(count==300)goto done;}
  }
  done:cerr<<"GENERATION c="<<(idx?11:10)<<" count="<<count<<" known="<<known<<" duplicate="<<dup<<" alternative_flag_skip="<<flag_skip<<'\n';
  if(count!=300)return 4;
 }
 return 0;
}
