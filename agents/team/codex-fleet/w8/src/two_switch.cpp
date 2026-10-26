#define main switch_main
#include "switch_prefix.cpp"
#undef main
int main(int argc,char**argv){
 if(argc<3){cerr<<"usage: two_switch outdir source_dir...\n";return 1;}
 outdir=argv[1];filesystem::create_directories(outdir);manifest.open(outdir+"/manifest.json");manifest<<"[\n";
 array<int,5> p={0,1,2,3,4};do{P.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int a=0;a<5;a++)for(int b=a+1;b<5;b++)pairs.push_back({a,b});
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=P[t][P[pi][i]];renameT[pi][t]=lower_bound(P.begin(),P.end(),q)-P.begin();}
 long long attempts=0,valid=0,sourcecount=0;
 for(int arg=2;arg<argc;arg++)for(auto&e:filesystem::directory_iterator(argv[arg]))if(e.path().extension()==".txt"){
  ifstream f(e.path());string l;getline(f,l);if(l.rfind("# one partner switch;",0)!=0)continue;
  istringstream ss(l.substr(21));string tok;vector<Step> seq;
  while(ss>>tok){if(tok.size()!=2&&tok.size()!=5)continue;Step x{tok[0]-'0',tok[1]-'0'};if(tok.size()==5){x.c=tok[3]-'0';x.d=tok[4]-'0';}seq.push_back(x);}
  if(seq.size()!=9)continue;sourcecount++;
  for(int pos=1;pos<8;pos++)if(seq[pos].c<0){Step save=seq[pos];
   for(auto[c,d]:pairs){if(c==save.a||c==save.b||d==save.a||d==save.b)continue;seq[pos].c=c;seq[pos].d=d;attempts++;
    auto state=P;for(auto x:seq)for(auto&q:state)if(q[x.a]>q[x.b]){swap(q[x.a],q[x.b]);if(x.c>=0)swap(q[x.c],q[x.d]);}
    bool same=true;for(int i=1;i<120;i++)if(state[i]!=state[0]){same=false;break;}
    if(same){valid++;emit(seq);}
   }seq[pos]=save;
  }
 }
 manifest<<"\n]\n";
 cout<<"source_skeletons="<<sourcecount<<" mutations="<<attempts<<" strict_sort_traces="<<valid<<" retained="<<retained<<" duplicates="<<duplicates<<" lattice_only="<<latticeonly<<" too_large="<<large<<'\n';
 for(auto[n,c]:requiredhist)cout<<"required="<<n<<" count="<<c<<'\n';
}
