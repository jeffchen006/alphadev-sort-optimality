#define main unused_local_main
#include "local.cpp"
#undef main
// Semantic fingerprints identify operand-column skeletons up to input renaming,
// comparison reversal, and reversal of the total value order.
int main(int argc,char **argv){
  vector<array<int,5>>cases;array<int,5>a{0,1,2,3,4};do cases.push_back(a);while(next_permutation(a.begin(),a.end()));
  map<array<int,5>,int>row;for(int t=0;t<120;t++)row[cases[t]]=t;
  Machine<2> m;m.setup(cases,24);
  vector<array<int,5>>weak;for(int c=0;c<3125;c++){int q=c,used=0;array<int,5>b;for(int j=0;j<5;j++)b[j]=q%5,q/=5,used|=1<<b[j];if(!(used&(used+1)))weak.push_back(b);}
  Machine<9> wm;wm.setup(weak,24);
  set<uint64_t>seen,rawseen;long total=0,eligible=0,skipped=0;int best=999;
  filesystem::create_directories("artifacts/skeletons");
  auto process=[&](const vector<string>&lines){
    if(lines.empty())return;total++;vector<I>p;map<string,int>regs;for(int j=0;j<5;j++)regs[reg(j)]=j;int nr=5,nc=0;
    for(auto line:lines){for(char &c:line)if(c==',')c=' ';stringstream ss(line);string op,d,s;ss>>op>>d>>s;
      int o=find(names,names+6,op)-names;if(o==6)continue;
      for(string r:{d,s})if(!regs.count(r))regs[r]=nr++;
      p.push_back({o,regs[d],regs[s]});nc+=o==CMP;
    }
    if(p.size()>32||nc>8)return;eligible++;best=min(best,(int)p.size());
    auto st=m.init;vector<array<array<int,120>,2>>cols;
    for(auto i:p){if(i.o==CMP){array<array<int,120>,2>cc;for(int side=0;side<2;side++)for(int t=0;t<120;t++){int v=0;auto &c=st.r[side?i.s:i.d];for(int b=0;b<3;b++)v|=((c.b[b][t/64]>>(t%64))&1)<<b;cc[side][t]=v;}cols.push_back(cc);}m.step(st,i);}
    uint64_t raw=1469598103934665603ULL;for(auto &cc:cols)for(auto &ss:cc)for(int v:ss)raw=(raw^v)*1099511628211ULL;if(!rawseen.insert(raw).second)return;
    int fa=-1,fb=-1;for(int r=0;r<5;r++){bool eq0=true,eq1=true;for(int t=0;t<120;t++)eq0&=cols[0][0][t]==cases[t][r],eq1&=cols[0][1][t]==cases[t][r];if(eq0)fa=r;if(eq1)fb=r;}
    if(fa<0||fb<0||fa==fb){skipped++;return;}
    uint64_t hash=~0ULL;array<int,5>g{0,1,2,3,4};
    do{if(!((g[fa]==0&&g[fb]==1)||(g[fa]==1&&g[fb]==0)))continue;
      for(int rev=0;rev<2;rev++){
        array<int,120>mp;for(int t=0;t<120;t++){array<int,5>b;for(int j=0;j<5;j++)b[j]=rev?4-cases[t][g[j]]:cases[t][g[j]];mp[t]=row[b];}
        uint64_t h=1469598103934665603ULL;for(auto &cc:cols){array<string,2>s;for(int side=0;side<2;side++)for(int t=0;t<120;t++){int v=cc[side][mp[t]];s[side]+=char(rev?4-v:v);}if(s[1]<s[0])swap(s[0],s[1]);for(auto &s0:s)for(unsigned char c:s0)h=(h^c)*1099511628211ULL;}
        hash=min(hash,h);
      }
    }while(next_permutation(g.begin(),g.end()));
    if(!seen.insert(hash).second)return;
    ostringstream stem;stem<<"artifacts/skeletons/c8_"<<hex<<hash;ofstream sk(stem.str()+".skel");sk<<"# w6 semantic skeleton k="<<dec<<p.size()<<"\n";
    for(auto &cc:cols){for(int side=0;side<2;side++){if(side)sk<<":";sk<<"=";for(int v:cc[side])sk<<v;}sk<<"\n";}
    ofstream out(stem.str()+".s");out<<"# n=5 model=out iset=I1 source=w6-c8-collection k="<<p.size()<<"\n";auto x=wm.init;
    for(auto i:p){int old=x.done;wm.step(x,i);out<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if((x.done^old)>>j&1)out<<"out "<<j<<", "<<reg(i.d)<<"\n";}
    if(x.done!=31){cerr<<"independent weak-order check failed for "<<stem.str()<<"\n";exit(2);}
    cout<<"NEW hash="<<hex<<hash<<dec<<" k="<<p.size()<<" cmp="<<nc<<" representative="<<stem.str()<<".s\n";cout.flush();
  };
  for(int f=1;f<argc;f++){ifstream in(argv[f]);string line;vector<string>lines;while(getline(in,line)){if(line.rfind("# prog",0)==0){process(lines);lines.clear();}else if(!line.empty()&&line[0]!='#'&&line.rfind("out",0)!=0)lines.push_back(line);}process(lines);}
  cout<<"SUMMARY programs="<<total<<" eligible_k32_c8="<<eligible<<" raw_skeleton_fingerprints="<<rawseen.size()<<" skeleton_fingerprints="<<seen.size()<<" skipped="<<skipped<<" best="<<best<<"\n";
}
