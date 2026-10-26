// Add one partner selector to net9_41 and redirect later comparisons or uses.
// Selectors use any already created node. Only non-lattice new columns remain.
#define main recompute_main
#include "canonical_base.cpp"
#undef main

struct G {int op,d,s;};
vector<G> dag;
int eval(const vector<G>& code,Sk& sk,bool& sorts) {
  array<array<int,120>,32> val{};array<int,120> flags{},hist{};
  for(int i=0;i<5;i++)for(int t=0;t<120;t++)val[i][t]=perms[t][i];
  int c=0,nn=5;bool out[5]={};
  for(auto x:code) {
    if(x.op==1){for(int t=0;t<120;t++){
      sk[2*c][t]=val[x.d][t];sk[2*c+1][t]=val[x.s][t];
      flags[t]=(val[x.d][t]>val[x.s][t])-(val[x.d][t]<val[x.s][t]);
      hist[t]=hist[t]*3+flags[t]+1;
    }c++;}
    else{for(int t=0;t<120;t++)val[nn][t]=cond(x.op,flags[t])?val[x.s][t]:val[x.d][t];
      for(int k=0;k<5;k++){bool same=true;for(int t=0;t<120;t++)same&=val[nn][t]==k;out[k]|=same;}nn++;
    }
  }
  sorts=all_of(out,out+5,[](bool x){return x;});return set<int>(hist.begin(),hist.end()).size();
}

bool lattice(const array<int,120>& col) {
  int tab[32]; fill(tab,tab+32,-1); tab[0]=0; tab[31]=1;
  for(int t=0;t<120;t++) for(int h=1;h<5;h++) {
    int m=0; for(int i=0;i<5;i++) if(perms[t][i]>=h) m|=1<<i;
    int b=col[t]>=h; if(tab[m]>=0 && tab[m]!=b) return false; tab[m]=b;
  }
  for(int m=0;m<32;m++) for(int i=0;i<5;i++) if(tab[m]&&!tab[m|1<<i]) return false;
  return true;
}
int main(int argc,char**argv) {
  if(argc!=5) {cerr<<"usage: partner_select program outdir prior_keys excluded_file_list\n";return 1;}
  array<int,5> p={0,1,2,3,4};do{perms.push_back(p);}while(next_permutation(p.begin(),p.end()));
  for(int pi=0;pi<120;pi++)for(int t=0;t<120;t++){
    array<int,5> q;for(int i=0;i<5;i++)q[i]=perms[t][perms[pi][i]];
    rename_type[pi][t]=lower_bound(perms.begin(),perms.end(),q)-perms.begin();
  }
  string line;ifstream cache(argv[3]);while(getline(cache,line))if(!line.empty())old.insert(line);
  ifstream exclusions(argv[4]);int nf=0;while(getline(exclusions,line)){
    Sk sk;if(readsk(line,sk)){old.insert(canonical(sk));nf++;}
  }
  auto original=load(argv[1]);map<int,int> regs;for(int i=0;i<5;i++)regs[i]=i;
  int nn=5;for(auto x:original){if(!x.op)regs[x.d]=regs[x.s];else{
    dag.push_back({x.op,regs[x.d],regs[x.s]});if(x.op!=1)regs[x.d]=nn++;
  }}
  fs::create_directories(argv[2]);ofstream manifest(string(argv[2])+"/manifest.json");manifest<<"[\n";
  ofstream graphs(string(argv[2])+"/valid_graphs.jsonl");
  long long selected=0,attempts=0,viable=0,retained=0,dups=0,prior=0,sorttraces=0;
  array<array<int,120>,32> vals{};array<int,120> flags{};
  for(int i=0;i<5;i++)for(int t=0;t<120;t++)vals[i][t]=perms[t][i];
  int id=5,blk=0;set<array<int,120>> selected_in_block;
  for(int pos=0;pos<(int)dag.size();pos++){
    if(blk){
      for(int d=0;d<id;d++)for(int s=0;s<id;s++)if(d!=s)for(int op=2;op<=5;op++){
        array<int,120> col;for(int t=0;t<120;t++)col[t]=cond(op,flags[t])?vals[s][t]:vals[d][t];
        if(lattice(col)||!selected_in_block.insert(col).second)continue;
        bool exists=false;for(int i=0;i<id;i++)exists|=vals[i]==col;if(exists)continue;
        selected++;
        vector<G> added;added.reserve(dag.size()+1);
        for(int j=0;j<(int)dag.size();j++){
          if(j==pos)added.push_back({op,d,s});auto x=dag[j];
          if(x.d>=id)x.d++;if(x.s>=id)x.s++;added.push_back(x);
        }
        auto check=[&](const vector<G>& code,string recipe){
          attempts++;Sk sk;bool sorts=false;if(eval(code,sk,sorts)!=120)return;viable++;sorttraces+=sorts;
          string k=canonical(sk);if(old.count(k)){prior++;return;}if(!seen.insert(k).second){dups++;return;}
          char name[64];snprintf(name,sizeof(name),"p%06lld.txt",retained++);
          string fn=string(argv[2])+"/"+name;ofstream f(fn);
          f<<"# partner-select pos="<<pos<<" block="<<blk<<" op="<<op<<" d="<<d<<" s="<<s<<" "<<recipe<<" trace_sorts="<<sorts<<'\n';
          for(int c=0;c<9;c++){f<<'=';for(int t=0;t<120;t++)f<<int(sk[2*c][t]);f<<":=";for(int t=0;t<120;t++)f<<int(sk[2*c+1][t]);f<<'\n';}
          if(retained>1)manifest<<",\n";manifest<<"{\"file\":\""<<fn<<"\",\"source_sorts\":"<<sorts<<"}";
          string df=fn.substr(0,fn.size()-4)+".dag";ofstream g(df);for(auto x:code)g<<x.op<<' '<<x.d<<' '<<x.s<<'\n';
          if(sorts){graphs<<'[';bool first=true;for(auto x:code){if(!first)graphs<<',';graphs<<'['<<x.op<<','<<x.d<<','<<x.s<<']';first=false;}graphs<<"]\n";}
        };
        // Replace each downstream comparison operand separately.
        for(int j=pos+1;j<(int)added.size();j++)if(added[j].op==1)for(int side=0;side<2;side++){
          auto code=added;if(side)code[j].s=id;else code[j].d=id;
          check(code,"cmp_index="+to_string(j)+" side="+to_string(side));
        }
        // Replace all later uses of each available value by the new selector.
        for(int from=0;from<id;from++){
          auto code=added;bool used=false;for(int j=pos+1;j<(int)code.size();j++){
            if(code[j].d==from){code[j].d=id;used=true;}if(code[j].s==from){code[j].s=id;used=true;}
          }
          if(used)check(code,"replace_all="+to_string(from));
        }
      }
    }
    auto x=dag[pos];if(x.op==1){blk++;selected_in_block.clear();for(int t=0;t<120;t++)flags[t]=(vals[x.d][t]>vals[x.s][t])-(vals[x.d][t]<vals[x.s][t]);}
    else{for(int t=0;t<120;t++)vals[id][t]=cond(x.op,flags[t])?vals[x.s][t]:vals[x.d][t];id++;}
  }
  manifest<<"\n]\n";
  cout<<"excluded_files="<<nf<<" prior_keys="<<old.size()<<" nonlattice_selectors="<<selected<<" attempts="<<attempts<<" informative="<<viable<<" trace_sorts="<<sorttraces<<" prior="<<prior<<" duplicates="<<dups<<" retained="<<retained<<'\n';
}
