#define main recompute_main
#include "canonical_base.cpp"
#undef main
bool latticeCol(const array<unsigned char,120>&c){
 int tab[32];fill(tab,tab+32,-1);tab[0]=0;tab[31]=1;
 for(int t=0;t<120;t++)for(int h=1;h<5;h++){int m=0;for(int i=0;i<5;i++)if(perms[t][i]>=h)m|=1<<i;int b=c[t]>=h;if(tab[m]>=0&&tab[m]!=b)return false;tab[m]=b;}
 for(int m=0;m<32;m++)for(int i=0;i<5;i++)if(tab[m]&&!tab[m|1<<i])return false;return true;
}
bool hasNonlattice(const Sk&sk){for(auto&c:sk)if(!latticeCol(c))return true;return false;}
bool inputColumn(const array<unsigned char,120>&c){for(int i=0;i<5;i++){bool same=true;for(int t=0;t<120;t++)if(c[t]!=perms[t][i]){same=false;break;}if(same)return true;}return false;}
bool explicitNine(const fs::path&fn){ifstream f(fn);string l;int n=0;bool explicitcol=false;
 while(getline(f,l)){istringstream ss(l);string w;ss>>w;if(w.empty()||w[0]=='#')continue;if(w.find(':')==string::npos||++n>9)return false;if(w.find('=')!=string::npos)explicitcol=true;}
 return n==9&&explicitcol;
}
int main(int argc,char**argv){
 if(argc<4){cerr<<"usage: nonlattice_filter manifest priorroot new_dir...\n";return 1;}
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 int pc=0,ec=0,nlc=0,ex=0,du=0,kept=0,skipped_lattice=0;unordered_set<string> own;
 auto prior=[&](const fs::path&root){for(auto&e:fs::recursive_directory_iterator(root))if(e.is_regular_file()&&e.path().extension()==".txt"){
  pc++;if(pc%5000==0)cerr<<"scanned="<<pc<<" explicit_nine="<<ec<<" nonlattice="<<nlc<<'\n';if(!explicitNine(e.path()))continue;ec++;Sk sk;if(readsk(e.path(),sk)&&inputColumn(sk[0])&&inputColumn(sk[1])&&hasNonlattice(sk)){old.insert(canonical(sk));nlc++;}}};
 if(fs::is_regular_file(argv[2])){ifstream cached(argv[2]);string key;while(getline(cached,key))if(!key.empty())old.insert(key);}
 else {prior(argv[2]);
 fs::path w2="/path/to/repo/agents/team/codex-fleet/w2/sk";if(fs::exists(w2))prior(w2);}
 ofstream cache("sk/nonlattice_prior_keys.txt");for(auto&key:old)cache<<key<<'\n';cache.close();
 cerr<<"prior_files="<<pc<<" explicit_nine="<<ec<<" nonlattice="<<nlc<<" canonical="<<old.size()<<'\n';
 ofstream f(argv[1]);f<<"[\n";
 for(int arg=3;arg<argc;arg++){vector<fs::path> files;for(auto&e:fs::recursive_directory_iterator(argv[arg]))if(e.is_regular_file()&&e.path().extension()==".txt")files.push_back(e.path());sort(files.begin(),files.end());
  for(auto&fn:files){Sk sk;if(!readsk(fn,sk))continue;if(!hasNonlattice(sk)){skipped_lattice++;continue;}string key=canonical(sk);if(old.count(key)){ex++;continue;}if(!own.insert(key).second){du++;continue;}
   if(kept++)f<<",\n";f<<"{\"file\":\""<<fn.string()<<"\"}";
  }}
 f<<"\n]\n";cout<<"prior_files="<<pc<<" explicit_nine="<<ec<<" nonlattice="<<nlc<<" canonical="<<old.size()<<" excluded="<<ex<<" duplicates="<<du<<" skipped_lattice="<<skipped_lattice<<" new="<<kept<<'\n';
}
