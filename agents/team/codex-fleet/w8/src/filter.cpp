#define main recompute_main
#include "canonical_base.cpp"
#undef main
bool nine(const fs::path&fn){
 ifstream f(fn);string l;int n=0;
 while(getline(f,l)){istringstream ss(l);string w;ss>>w;if(w.empty()||w[0]=='#')continue;if(w.find(':')==string::npos||++n>9)return false;}
 return n==9;
}
int main(int argc,char**argv){
 if(argc<4){cerr<<"usage: filter output_manifest prior_dir new_dir...\n";return 1;}
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 long long prior=0,match=0,dup=0,kept=0;unordered_set<string> own;
 for(auto&e:fs::recursive_directory_iterator(argv[2]))if(e.is_regular_file()&&e.path().extension()==".txt"){
  Sk sk;if(nine(e.path())&&readsk(e.path(),sk)){old.insert(canonical(sk));prior++;if(prior%500==0)cerr<<"read_prior="<<prior<<'\n';}}
 cerr<<"prior_files="<<prior<<" canonical="<<old.size()<<'\n';
 ofstream f(argv[1]);f<<"[\n";
 for(int arg=3;arg<argc;arg++){
  vector<fs::path> files;for(auto&e:fs::recursive_directory_iterator(argv[arg]))if(e.is_regular_file()&&e.path().extension()==".txt")files.push_back(e.path());sort(files.begin(),files.end());
  for(auto&fn:files){Sk sk;if(!readsk(fn,sk))continue;string k=canonical(sk);
   if(old.count(k)){match++;continue;}if(!own.insert(k).second){dup++;continue;}
   if(kept++)f<<",\n";f<<"{\"file\":\""<<fn.string()<<"\"}";
  }
 }
 f<<"\n]\n";cout<<"prior_files="<<prior<<" canonical="<<old.size()<<" excluded="<<match<<" duplicates="<<dup<<" new="<<kept<<'\n';
}
