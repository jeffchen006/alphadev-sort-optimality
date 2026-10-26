#define main generator_main
#include "generate.cpp"
#undef main
// Exact comparison-pair Hamming distance to a finite prior set, modulo the
// same symmetries as the index. A first pair of distinct inputs is required.
int main(int argc,char**argv){
 if(argc<4){cerr<<"usage: distance prior.keys outfile candidate_dir...\n";return 1;}init();
 vector<string> keys;ifstream f(argv[1]);string s;while(getline(f,s))if(s.size()==1920||s.size()==2160)keys.push_back(s);
 vector<unordered_map<string,vector<int>>> index(9);
 for(int id=0;id<(int)keys.size();id++)for(int j=0;j<(int)keys[id].size()/240;j++)index[j][keys[id].substr(240*j,240)].push_back(id);
 vector<int> counts(keys.size()),stamp(keys.size());int tick=0;ofstream out(argv[2]);
 string firstpair;for(int i=0;i<2;i++)for(int t=0;t<120;t++)firstpair+=char('0'+P[t][i]);
 bool commonfirst=true;for(auto&k:keys)if(k.substr(0,240)!=firstpair)commonfirst=false;
 vector<fs::path> files;for(int a=3;a<argc;a++)for(auto&e:fs::directory_iterator(argv[a]))if(e.path().extension()==".txt")files.push_back(e.path());sort(files.begin(),files.end());
 long long n=0;map<pair<int,int>,long long> hist;
 for(auto fn:files){Sk v;if(!readsk(fn,v))continue;int c=v.size()/2,ia=input_index(v[0]),ib=input_index(v[1]);if(ia<0||ib<0||ia==ib)throw runtime_error("first pair");
  int best=0,nearest=-1;
  if(commonfirst)for(int id=0;id<(int)keys.size();id++)if((int)keys[id].size()==240*c){best=1;nearest=id;break;}
  for(int rev=0;rev<2;rev++)for(int pi=0;pi<120;pi++){
   if(((1<<P[pi][ia])|(1<<P[pi][ib]))!=3)continue;tick++;
   for(int j=commonfirst?1:0;j<c;j++){
    string a(120,'0'),b(120,'0');for(int t=0;t<120;t++){int tt=renameT[pi][rev?119-t:t];a[t]='0'+(rev?4-v[2*j][tt]:v[2*j][tt]);b[t]='0'+(rev?4-v[2*j+1][tt]:v[2*j+1][tt]);}if(b<a)swap(a,b);
    auto it=index[j].find(a+b);if(it==index[j].end())continue;
    for(int id:it->second){if((int)keys[id].size()!=240*c)continue;if(stamp[id]!=tick){stamp[id]=tick;counts[id]=commonfirst?1:0;}int score=++counts[id];if(score>best){best=score;nearest=id;}}
   }
  }
  int d=nearest<0?c:c-best;hist[{c,d}]++;
  out<<"{\"file\":\""<<fn.string()<<"\",\"distance\":"<<d<<",\"nearest_id\":"<<nearest<<"}\n";
  if(++n%1000==0)cerr<<"checked="<<n<<'\n';
 }
 for(auto[cd,n]:hist)cout<<"c="<<cd.first<<" distance="<<cd.second<<" count="<<n<<'\n';
}
