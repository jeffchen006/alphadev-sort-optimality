// New c=9 rotation skeletons and c=10 delayed repeated-comparison skeletons.
#define main old_main
#include "canonical_base.cpp"
#undef main
using ColV=array<unsigned char,120>;
using VS=vector<ColV>;
bool readv(const string&fn,VS&sk){
 ifstream f(fn);string l;sk.clear();
 while(getline(f,l)){istringstream ss(l);string w;ss>>w;if(w.empty()||w[0]=='#')continue;
  w=w.substr(0,w.find(';'));auto c=w.find(':');if(c==string::npos)return false;
  try{for(auto z:{w.substr(0,c),w.substr(c+1)}){ColV a;for(int t=0;t<120;t++)a[t]=ev(z,t);sk.push_back(a);}}catch(...){return false;}
 }return sk.size()==18||sk.size()==20;
}
string canonv(const VS&v){
 if(v.size()==18){Sk s;copy(v.begin(),v.end(),s.begin());return canonical(s);}
 auto idx=[&](int j){for(int i=0;i<5;i++){bool same=true;for(int t=0;t<120;t++)same&=v[j][t]==perms[t][i];if(same)return i;}return -1;};
 int a=idx(0),b=idx(1),c=idx(2),d=idx(3);bool dis=a>=0&&b>=0&&c>=0&&d>=0&&a!=b&&c!=d&&a!=c&&a!=d&&b!=c&&b!=d;string best;
 for(int pi=0;pi<120;pi++){
  if(a>=0&&b>=0&&a!=b&&((1<<perms[pi][a])|(1<<perms[pi][b]))!=3)continue;
  if(dis&&((1<<perms[pi][c])|(1<<perms[pi][d]))!=12)continue;
  string key;bool worse=false;
  for(int j=0;j<(int)v.size()&&!worse;j+=2){string x,y;for(int t=0;t<120;t++){x+=char('0'+v[j][rename_type[pi][t]]);y+=char('0'+v[j+1][rename_type[pi][t]]);}if(y<x)swap(x,y);key+=x;key+=y;if(!best.empty()&&key.compare(0,key.size(),best,0,key.size())>0)worse=true;}
  if(!worse&&(best.empty()||key<best))best=move(key);
 }return best;
}
bool latticev(const ColV&col){int tab[32];fill(tab,tab+32,-1);tab[0]=0;tab[31]=1;
 for(int t=0;t<120;t++)for(int h=1;h<5;h++){int m=0;for(int i=0;i<5;i++)if(perms[t][i]>=h)m|=1<<i;int b=col[t]>=h;if(tab[m]>=0&&tab[m]!=b)return false;tab[m]=b;}
 for(int m=0;m<32;m++)for(int i=0;i<5;i++)if(tab[m]&&!tab[m|1<<i])return false;return true;
}
int requiredv(const VS&v){set<ColV> req(v.begin(),v.end());for(int k=0;k<5;k++){ColV c;c.fill(k);req.insert(c);}
 for(int i=0;i<5;i++){ColV c;for(int t=0;t<120;t++)c[t]=perms[t][i];req.erase(c);}return req.size();}
bool nonlat(const VS&v){for(auto&c:v)if(!latticev(c))return true;return false;}
vector<string> lines(string fn){vector<string>out;ifstream f(fn);string s;while(getline(f,s))if(!s.empty())out.push_back(s);return out;}
int main(){
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5>q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 unordered_set<string> prior9,prior10;for(auto&s:lines("sk/nonlattice_prior_keys.txt"))prior9.insert(s);
 for(auto&fn:lines("sk/round4_prior_files.txt")){VS v;if(!readv(fn,v))continue;if(v.size()==18)prior9.insert(canonv(v));else if(nonlat(v))prior10.insert(canonv(v));}
 cerr<<"prior9="<<prior9.size()<<" prior10_nonlat="<<prior10.size()<<'\n';
 unordered_set<string> fresh9,fresh10;ofstream m9("sk/round4_rotation.json");m9<<"[\n";
 map<int,int> gates9;int old9=0,dup9=0,ret9=0;
 for(auto&fn:lines("sk/round4_rotation_files.txt")){VS v;if(!readv(fn,v)||v.size()!=18)throw runtime_error("read rotation");auto key=canonv(v);if(prior9.count(key)){old9++;continue;}if(!fresh9.insert(key).second){dup9++;continue;}
  int g=requiredv(v);gates9[g]++;if(ret9++)m9<<",\n";m9<<"{\"file\":\""<<fn<<"\",\"required_gates\":"<<g<<",\"node_limit\":200000}";
 }m9<<"\n]\n";
 cerr<<"rotation retained="<<ret9<<" prior="<<old9<<" duplicate="<<dup9<<'\n';for(auto[g,n]:gates9)cerr<<"rotation_gates="<<g<<" count="<<n<<'\n';
 filesystem::create_directories("sk/round4_repeat10");ofstream m10("sk/round4_repeat10.json");m10<<"[\n";
 int nsource=0,ret10=0,dup10=0,old10=0,attempt10=0;map<int,int> gates10;unordered_set<string> sources;
 for(auto&fn:lines("sk/round4_repeat_sources.txt")){VS v;if(!readv(fn,v)||v.size()!=18||!nonlat(v))continue;if(!sources.insert(canonv(v)).second)continue;nsource++;
  // Insertion position is the number of original comparisons before the repeat.
  // Skip an adjacent repeat; it supplies no new flag interval.
  for(int orig=0;orig<8;orig++)for(int pos=orig+2;pos<=9;pos++){
   VS ext=v;ext.insert(ext.begin()+2*pos,{v[2*orig],v[2*orig+1]});attempt10++;auto key=canonv(ext);
   if(prior10.count(key)){old10++;continue;}if(!fresh10.insert(key).second){dup10++;continue;}
   int g=requiredv(ext);gates10[g]++;char name[100];snprintf(name,sizeof(name),"sk/round4_repeat10/r%06d.txt",ret10);
   ofstream f(name);f<<"# delayed exact repeat source="<<fn<<" original="<<orig+1<<" after="<<pos<<'\n';
   for(int c=0;c<10;c++){f<<'=';for(int t=0;t<120;t++)f<<int(ext[2*c][t]);f<<":=";for(int t=0;t<120;t++)f<<int(ext[2*c+1][t]);f<<'\n';}
   if(ret10++)m10<<",\n";m10<<"{\"file\":\""<<name<<"\",\"source\":\""<<fn<<"\",\"repeat\":"<<orig+1<<",\"after\":"<<pos<<",\"required_gates\":"<<g<<",\"node_limit\":100000}";
  }
 }m10<<"\n]\n";
 cerr<<"repeat sources="<<nsource<<" attempts="<<attempt10<<" retained="<<ret10<<" prior="<<old10<<" duplicate="<<dup10<<'\n';for(auto[g,n]:gates10)cerr<<"repeat_gates="<<g<<" count="<<n<<'\n';
}
