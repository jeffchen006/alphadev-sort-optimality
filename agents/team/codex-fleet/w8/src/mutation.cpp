// Functional-DAG mutations of the supplied non-network term-set control.
// This generator does not assume that the mutation itself sorts. It keeps
// skeletons whose comparison histories distinguish all 120 strict orders.
#define main recompute_main
#include "canonical_base.cpp"
#undef main
struct G {int op,d,s;}; // cmp=1; select=2..5. Nodes are fresh after selects.
vector<G> dag;
int eval(const vector<G>&code,Sk&sk, bool&sorts){
 array<array<int,120>,32> val{};for(int i=0;i<5;i++)for(int t=0;t<120;t++)val[i][t]=perms[t][i];
 array<int,120> fl{},hist{};int c=0,nn=5;bool out[5]={};
 for(auto x:code){if(x.op==1){for(int t=0;t<120;t++){int a=val[x.d][t],b=val[x.s][t];sk[2*c][t]=a;sk[2*c+1][t]=b;fl[t]=(a>b)-(a<b);hist[t]=hist[t]*3+fl[t]+1;}c++;}
  else {for(int t=0;t<120;t++)val[nn][t]=cond(x.op,fl[t])?val[x.s][t]:val[x.d][t];for(int k=0;k<5;k++){bool same=true;for(int t=0;t<120;t++)if(val[nn][t]!=k){same=false;break;}if(same)out[k]=true;}nn++;}}
 set<int> hs(hist.begin(),hist.end());sorts=all_of(out,out+5,[](bool b){return b;});return hs.size();
}
int main(int argc,char**argv){
 if(argc<3){cerr<<"usage: mutation program outdir\n";return 1;}
 array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
 for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();}
 int id=5;map<int,int> regs;for(int i=0;i<5;i++)regs[i]=i;
 if(fs::path(argv[1]).extension()==".dag"){ifstream f(argv[1]);G x;while(f>>x.op>>x.d>>x.s)dag.push_back(x);}
 else {auto orig=load(argv[1]);for(auto x:orig){if(x.op==0)regs[x.d]=regs[x.s];else{dag.push_back({x.op,regs[x.d],regs[x.s]});if(x.op!=1)regs[x.d]=id++;}}}
 fs::create_directories(argv[2]);ofstream m(string(argv[2])+"/manifest.json");m<<"[\n";
 ofstream graphs(string(argv[2])+"/valid_graphs.jsonl");
 Sk sk;bool sorts;eval(dag,sk,sorts);old.insert(canonical(sk));long long tries=0,viable=0,direct=0,nnew=0;
 id=5;
 for(int j=0;j<int(dag.size());j++){
  G save=dag[j];
  for(int d=0;d<id;d++)for(int s=0;s<id;s++)if(d!=s)for(int op=(save.op==1?1:2);op<=(save.op==1?1:5);op++){
   if(d==save.d&&s==save.s&&op==save.op)continue;dag[j]={op,d,s};tries++;
   if(eval(dag,sk,sorts)!=120)continue;viable++;direct+=sorts;
   if(sorts){graphs<<"[";bool first=true;for(auto x:dag){if(!first)graphs<<',';graphs<<'['<<x.op<<','<<x.d<<','<<x.s<<']';first=false;}graphs<<"]\n";}
   string k=canonical(sk);if(old.count(k)||!seen.insert(k).second)continue;
   char name[64];snprintf(name,sizeof(name),"m%06lld.txt",nnew++);ofstream f(string(argv[2])+"/"+name);f<<"# mutation instruction="<<j<<" op="<<op<<" d="<<d<<" s="<<s<<" source_trace_sorts="<<sorts<<'\n';
   for(int c=0;c<9;c++){f<<'=';for(int t=0;t<120;t++)f<<int(sk[2*c][t]);f<<":=";for(int t=0;t<120;t++)f<<int(sk[2*c+1][t]);f<<'\n';}
   string dn=string(name);dn.replace(dn.size()-4,4,".dag");ofstream df(string(argv[2])+"/"+dn);for(auto x:dag)df<<x.op<<' '<<x.d<<' '<<x.s<<'\n';
   if(nnew>1)m<<",\n";m<<"{\"file\":\""<<argv[2]<<'/'<<name<<"\",\"source_sorts\":"<<sorts<<"}";
  }
  dag[j]=save;if(save.op!=1)id++;
 }
 m<<"\n]\n";cout<<"mutations="<<tries<<" informative="<<viable<<" source_sorts="<<direct<<" unique_new="<<nnew<<'\n';
}
