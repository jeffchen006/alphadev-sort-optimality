// Trace-preserving flag and source rewrites. See round5/RULES.md.
#define main legacy_main
#include "../../src/search.cpp"
#include <bitset>
#undef main
#include <unordered_map>
#include <unordered_set>
#include <sys/resource.h>
#include <cassert>
struct State {array<int,NR> r;int f;unsigned have;uint64_t seen=0;};
struct Rules {
  Prog p,path,best;int nr,nv,nf,remove_count,insert_count;string out;
  bool freeflags=false,limited=false;int capseconds=90;
  unordered_set<string> memo;vector<int> pairflag;
  chrono::steady_clock::time_point started;
  vector<string> values,flags;unordered_map<string,int> valids,flagids;
  vector<int> want,cmpflag,goals;vector<State> trace;
  vector<int> selecttab,cmptab;
  uint64_t nodes=0,insertions=0,leaves=0,solutions=0,rewritten=0,keepfails=0;
  uint64_t deltypes[3]={},pairtypes[9]={};
  int bestscore=-1,pathchanges=0;bool shorter=false;vector<int> deleted;
  int internval(const string&v){auto it=valids.find(v);if(it!=valids.end())return it->second;int id=values.size();values.push_back(v);valids.emplace(v,id);return id;}
  int internflag(const string&v){auto it=flagids.find(v);if(it!=flagids.end())return it->second;int id=flags.size();flags.push_back(v);flagids.emplace(v,id);return id;}
  string compare(int a,int b){string result(541,0);for(int i=0;i<541;i++){int x=values[a][i],y=values[b][i];if(x==y)result[i]=0;else if(x>=8||y>=8)return "";else result[i]=x<y?1:2;}return result;}
  string selectvalue(int a,int b,int f,int o){if(o==MOV)return values[b];string result=values[a];for(int i=0;i<541;i++){int z=flags[f][i];if(z==3){if(values[a][i]!=values[b][i])return "";}else if((o==L&&z==1)||(o==LE&&z!=2)||(o==G&&z==2)||(o==GE&&z!=1))result[i]=values[b][i];}return result;}
  int sel(int f,int a,int b,int o) {
    if(o==MOV)return b;
    int &v=selecttab[(((f*nv+a)*nv+b)*4)+(o-2)];
    if(v==-2){string result=selectvalue(a,b,f,o);auto it=valids.find(result);v=it==valids.end()?-1:it->second;}
    return v;
  }
  int rel(int f,int a,int b)const{return cmptab[(f*nv+a)*nv+b];}
  void update(State&st){for(int r=0;r<nr;r++)st.seen|=1ULL<<st.r[r];for(int j=0;j<5;j++)for(int r=0;r<nr;r++)if(st.r[r]==goals[j]){st.have|=1u<<j;break;}}
  Rules(const Prog&pp,int n,const string&output,bool ff=false):p(pp),nr(n),out(output),freeflags(ff){
    State st{};st.have=0;
    for(int r=0;r<nr;r++){string v(541,char(8+r));if(r<5)for(int t=0;t<541;t++)v[t]=orders[t][r];st.r[r]=internval(v);}
    st.f=internflag(string(541,3));trace.push_back(st);
    for(auto x:p){
      if(x.o==CMP){string fl=compare(st.r[x.d],st.r[x.s]);assert(!fl.empty());st.f=internflag(fl);want.push_back(-1);cmpflag.push_back(st.f);}
      else {string v=selectvalue(st.r[x.d],st.r[x.s],st.f,x.o);assert(!v.empty());st.r[x.d]=internval(v);want.push_back(st.r[x.d]);cmpflag.push_back(-1);}
      trace.push_back(st);
    }
    for(int j=0;j<5;j++){string v(541,0);for(int t=0;t<541;t++){auto a=orders[t];sort(a.begin(),a.end());v[t]=a[j];}goals.push_back(internval(v));}
    nv=values.size();assert(nv<64);update(trace[0]);
    if(freeflags){
      pairflag.resize(nv*nv,-1);
      for(int a=0;a<nv;a++)for(int b=0;b<nv;b++){string fl=compare(a,b);if(!fl.empty())pairflag[a*nv+b]=internflag(fl);}
    }
    nf=flags.size();
    selecttab.resize(nf*nv*nv*4,-2);cmptab.resize(nf*nv*nv);
    if(freeflags)return;
    for(int a=0;a<nv;a++)for(int b=0;b<nv;b++){
      string fl=compare(a,b);
      for(int f=0;f<nf;f++){
        cmptab[(f*nv+a)*nv+b]=!fl.empty()&&fl==flags[f];
        for(int o=L;o<=GE;o++){string v=selectvalue(a,b,f,o);auto it=valids.find(v);selecttab[(((f*nv+a)*nv+b)*4)+(o-2)]=it==valids.end()?-1:it->second;}
      }
    }
    update(trace[0]);
  }
  bool synthwrite(const State&st,int d,int target,Ins&x,int at=-1){
    if(at>=0&&p[at].o!=CMP&&sel(st.f,st.r[d],st.r[p[at].s],p[at].o)==target){x=p[at];return true;}
    for(int s=0;s<nr;s++)if(st.r[s]==target){x={MOV,d,s};return true;}
    for(int s=0;s<nr;s++)for(int o=L;o<=GE;o++)if(sel(st.f,st.r[d],st.r[s],o)==target){x={o,d,s};return true;}
    return false;
  }
  bool synthcmp(const State&st,int f,Ins&x,int at=-1){
    if(at>=0&&rel(f,st.r[p[at].d],st.r[p[at].s])){x=p[at];return true;}
    for(int d=0;d<nr;d++)for(int s=0;s<nr;s++)if(rel(f,st.r[d],st.r[s])){x={CMP,d,s};return true;}return false;
  }
  bool keep(int at,const State&st,State&next,Ins&x){next=st;
    if(p[at].o==CMP){if(!synthcmp(st,cmpflag[at],x,at))return false;next.f=cmpflag[at];}
    else {if(!synthwrite(st,p[at].d,want[at],x,at))return false;next.r[x.d]=want[at];}
    update(next);return true;
  }
  int classof(int i){return p[i].o==CMP?1:p[i].o==MOV?0:2;}

  vector<array<bitset<541>,5>> errors;
  unordered_map<uint64_t,array<int,5>> scores;
  unordered_set<string> nearprograms;
  uint64_t qualifying=0,retained=0;
  array<int,21> histogram{};
  void prepare_errors(){
    errors.resize(nv);
    for(int v=0;v<nv;v++)for(int j=0;j<5;j++)for(int t=0;t<541;t++)
      if(values[v][t]!=values[goals[j]][t])errors[v][j].set(t);
  }
  bool choose(int j,uint64_t seen,bitset<541> bad,array<int,5>& selected){
    if(j==5)return true;
    vector<int> choices;
    for(int v=0;v<nv;v++)if((seen>>v)&1){
      if((bad|errors[v][j]).count()>20)continue;
      bool dominated=false;
      for(int w:choices)if((errors[w][j]&~errors[v][j]).none()){dominated=true;break;}
      if(dominated)continue;
      choices.erase(remove_if(choices.begin(),choices.end(),[&](int w){return (errors[v][j]&~errors[w][j]).none();}),choices.end());
      choices.push_back(v);
    }
    sort(choices.begin(),choices.end(),[&](int a,int b){return (bad|errors[a][j]).count()<(bad|errors[b][j]).count();});
    for(int v:choices){selected[j]=v;if(choose(j+1,seen,bad|errors[v][j],selected))return true;}
    return false;
  }
  void collect(const State&st){
    if(path.size()!=31)return;
    auto it=scores.find(st.seen);
    if(it==scores.end()){
      array<int,5> selected;selected.fill(-1);
      if(!choose(0,st.seen,{},selected))selected.fill(-1);
      it=scores.emplace(st.seen,selected).first;
    }
    auto selected=it->second;if(selected[0]<0)return;
    qualifying++;
    string key;for(auto x:path)for(int z:{x.o,x.d,x.s})key+=char(z);
    if(!nearprograms.insert(key).second)return;
    bitset<541> bad;for(int j=0;j<5;j++)bad|=errors[selected[j]][j];histogram[bad.count()]++;
    string fn=out+"_near"+to_string(retained++)+".s";
    ofstream f(fn);f<<"# n=5 R="<<nr<<" model=out iset=I1 source=w5-round6 k=31 failures="<<bad.count()<<"\n";
    State cur=trace[0];array<int,5> when,reg;when.fill(-2);
    auto record=[&](int t){for(int j=0;j<5;j++)if(when[j]==-2)for(int r=0;r<nr;r++)if(cur.r[r]==selected[j]){when[j]=t;reg[j]=r;break;}};
    record(-1);
    for(int t=0;t<(int)path.size();t++){auto x=path[t];if(x.o==CMP)cur.f=pairflag[cur.r[x.d]*nv+cur.r[x.s]];else cur.r[x.d]=sel(cur.f,cur.r[x.d],cur.r[x.s],x.o);record(t);}
    for(int j=0;j<5;j++)if(when[j]==-1)f<<"out "<<j<<", "<<regname(reg[j])<<"\n";
    for(int t=0;t<(int)path.size();t++){auto x=path[t];f<<names[x.o]<<" "<<regname(x.d)<<", "<<regname(x.s)<<"\n";for(int j=0;j<5;j++)if(when[j]==t)f<<"out "<<j<<", "<<regname(reg[j])<<"\n";}
    for(int j=0;j<5;j++)assert(when[j]!=-2);
  }
  void accept(const State&st){leaves++;collect(st);if(st.have!=31)return;solutions++;
    assert(path.size()<=p.size()-remove_count+insert_count);
    if(path==p)return;
    rewritten++;int score=1000000*pathchanges;
    // Prefer examples with many changed instructions, to exercise repairs.
    for(int i=0;i<(int)min(path.size(),p.size());i++)if(!(path[i]==p[i]))score++;
    if(score>bestscore){bestscore=score;best=path;}
    if(path.size()<32&&!shorter){
      if(fullcheck(path).ok){shorter=true;save(path,out+"_found_k"+to_string(path.size())+".s");printf("CANDIDATE %s_found_k%zu.s\n",out.c_str(),path.size());fflush(stdout);}
    }
  }
  void dfs(int at,int del,int ins,const State&st){
    nodes++;if(shorter||limited)return;
    if(freeflags){
      if((nodes&65535)==0&&(memo.size()>=3000000||chrono::duration<double>(chrono::steady_clock::now()-started).count()>capseconds)){limited=true;return;}
      string key;key.reserve(nr+7);key+=char(at);key+=char(del);key+=char(ins);key+=char(st.have);for(int b=0;b<8;b++)key+=char(st.seen>>(8*b));key+=char(st.f&255);key+=char(st.f>>8);
      for(int r=0;r<nr;r++)key+=char(st.r[r]);
      if(!memo.insert(key).second)return;
    }
    if((int)p.size()-at<remove_count-del)return;
    if(at==(int)p.size()&&del==remove_count){if(ins==insert_count){accept(st);return;}if(st.have==31){accept(st);if(shorter)return;}}
    // The insertion can use either operand order of every original flag column.
    // Reversed comparisons plus reversed predicates produce the same state.
    if(ins<insert_count){
      for(int d=0;d<nr;d++){
        bool seen[256]={};
        for(int s=0;s<nr;s++)for(int o=0;o<=GE;o++)if(o!=CMP){
          int v=sel(st.f,st.r[d],st.r[s],o);if(v<0||seen[v])continue;seen[v]=true;
          if(v==st.r[d])continue; // An inserted no-op is equivalent to no insertion.
          State next=st;next.r[d]=v;update(next);insertions++;path.push_back({o,d,s});
          dfs(at,del,ins+1,next);path.pop_back();if(shorter)return;
        }
      }
      if(freeflags){
        vector<bool> seen(nf);
        for(int d=0;d<nr;d++)for(int s=0;s<nr;s++){
          int f=pairflag[st.r[d]*nv+st.r[s]];if(f<0||f==st.f||seen[f])continue;seen[f]=true;
          State next=st;next.f=f;insertions++;path.push_back({CMP,d,s});dfs(at,del,ins+1,next);path.pop_back();if(shorter||limited)return;
        }
      }else for(int f=1;f<nf;f++)if(f!=st.f){Ins x;if(!synthcmp(st,f,x))continue;State next=st;next.f=f;insertions++;path.push_back(x);dfs(at,del,ins+1,next);path.pop_back();if(shorter)return;}
    }
    if(at==(int)p.size())return;
    State next;Ins x;
    if(freeflags&&p[at].o==CMP){
      vector<bool> seen(nf);
      for(int d=0;d<nr;d++)for(int s=0;s<nr;s++){
        int f=pairflag[st.r[d]*nv+st.r[s]];if(f<0||seen[f])continue;seen[f]=true;
        next=st;next.f=f;path.push_back({CMP,d,s});pathchanges+=(f!=cmpflag[at]);dfs(at+1,del,ins,next);pathchanges-=(f!=cmpflag[at]);path.pop_back();if(shorter||limited)return;
      }
    }else if(keep(at,st,next,x)){path.push_back(x);pathchanges+=(p[at].o>=L&&st.f!=trace[at].f);dfs(at+1,del,ins,next);pathchanges-=(p[at].o>=L&&st.f!=trace[at].f);path.pop_back();}else keepfails++;
    if(del<remove_count){deleted.push_back(at);deltypes[classof(at)]++;if(deleted.size()==2)pairtypes[classof(deleted[0])*3+classof(at)]++;dfs(at+1,del+1,ins,st);deleted.pop_back();}
  }
  void run(int nd,int ni){remove_count=nd;insert_count=ni;started=chrono::steady_clock::now();dfs(0,0,0,trace[0]);}
  void audit(ofstream&f,int seed){
    if(freeflags)return;
    for(int at=0;at<(int)p.size();at++)if(p[at].o>=L){
      int original=trace[at].f;
      for(int flag=1;flag<nf;flag++)if(flag!=original){State st=trace[at];st.f=flag;Ins x;
        if(synthwrite(st,p[at].d,want[at],x))f<<seed<<" "<<at<<" "<<original<<" "<<flag<<" "<<names[x.o]<<" "<<x.d<<" "<<x.s<<"\n";
      }
    }
  }
};
#ifndef REWRITE_NO_MAIN
int main(int argc,char**argv){
  if(argc<5){fprintf(stderr,"rewrite list outputprefix remove insert [start end]\n");return 2;}
  rlimit lim{2800ULL*1024*1024,2800ULL*1024*1024};setrlimit(RLIMIT_AS,&lim);init();
  ifstream list(argv[1]);string file;int nd=atoi(argv[3]),ni=atoi(argv[4]),index=0,start=argc>5?atoi(argv[5]):0,end=argc>6?atoi(argv[6]):100000;
  ofstream audit(string(argv[2])+"_audit.txt");auto began=chrono::steady_clock::now();
  while(list>>file){if(index<start){index++;continue;}if(index>=end)break;
    Prog p=read(file);assert(fullcheck(p).ok);Rules r(p,nreg+1,string(argv[2])+"_"+to_string(index),argc>7&&atoi(argv[7]));r.prepare_errors();r.audit(audit,index);r.run(nd,ni);printf("NEAR index=%d qualifying=%llu retained=%llu seenhist=%zu hist=",index,(unsigned long long)r.qualifying,(unsigned long long)r.retained,r.scores.size());for(int j=0;j<=20;j++)printf("%s%d:%d",j?",":"",j,r.histogram[j]);printf("\n");
    if(!r.best.empty()&&r.best.size()>=32){assert(fullcheck(r.best).ok);save(r.best,r.out+"_neutral.s");}
    printf("SEED index=%d values=%d flags=%d nodes=%llu insertions=%llu leaves=%llu solutions=%llu rewritten=%llu keepfails=%llu found=%d complete=%d memo=%zu seconds=%.3f\n",index,r.nv,r.nf,(unsigned long long)r.nodes,(unsigned long long)r.insertions,(unsigned long long)r.leaves,(unsigned long long)r.solutions,(unsigned long long)r.rewritten,(unsigned long long)r.keepfails,r.shorter,!r.limited,r.memo.size(),chrono::duration<double>(chrono::steady_clock::now()-began).count());fflush(stdout);
    if(r.shorter)return 0;index++;
  }
  printf("DONE remove=%d insert=%d start=%d end=%d seconds=%.3f\n",nd,ni,start,index,chrono::duration<double>(chrono::steady_clock::now()-began).count());
}
#endif
