#include <bits/stdc++.h>
using namespace std;
// Independent bit-plane evaluator. Value 7 means an unknown scratch value.
struct I { int o,d,s; };
enum {MOV,CMP,L,LE,G,GE};
const char *names[]={"mov","cmp","cmovl","cmovle","cmovg","cmovge"};
template<int W> struct Col { uint64_t b[3][W]{}; };
template<int W> struct State { Col<W> r[24]; uint64_t lt[W]{},gt[W]{},unk[W]{}; int done=0; };
template<int W> struct Machine {
  int nr,nt; State<W> init; Col<W> goal[5]; uint64_t mask[W]{};
  void setup(const vector<array<int,5>>& cases,int nreg) {
    nr=nreg;nt=cases.size();
    for(int t=0;t<nt;t++) {
      int w=t/64,b=t%64;uint64_t v=1ULL<<b;mask[w]|=v;
      for(int r=0;r<nr;r++) for(int k=0;k<3;k++) if(((r<5?cases[t][r]:7)>>k)&1) init.r[r].b[k][w]|=v;
      auto a=cases[t];sort(a.begin(),a.end());
      for(int j=0;j<5;j++)for(int k=0;k<3;k++)if((a[j]>>k)&1)goal[j].b[k][w]|=v;
    }
    for(int w=0;w<W;w++)init.unk[w]=mask[w];
    for(int r=0;r<nr;r++) match(init,r);
  }
  inline void match(State<W>& x,int r)const {
    for(int j=0;j<5;j++)if(!(x.done>>j&1)) {
      uint64_t dif=0;
      for(int w=0;w<W;w++)for(int k=0;k<3;k++)dif|=x.r[r].b[k][w]^goal[j].b[k][w];
      if(!dif)x.done|=1<<j;
    }
  }
  inline void step(State<W>& x,I i)const {
    auto &a=x.r[i.d];auto &b=x.r[i.s];
    if(i.o==MOV){a=b;match(x,i.d);return;}
    if(i.o==CMP) {
      for(int w=0;w<W;w++) {
        uint64_t eq=mask[w],lt=0,gt=0;
        for(int k=2;k>=0;k--){lt|=eq&~a.b[k][w]&b.b[k][w];gt|=eq&a.b[k][w]&~b.b[k][w];eq&=~(a.b[k][w]^b.b[k][w]);}
        uint64_t u=(a.b[0][w]&a.b[1][w]&a.b[2][w])|(b.b[0][w]&b.b[1][w]&b.b[2][w]);
        // Comparing the same register has a known equal result.
        if(i.d==i.s)u=0,lt=gt=0;
        x.unk[w]=u;x.lt[w]=lt&~u;x.gt[w]=gt&~u;
      }return;
    }
    for(int w=0;w<W;w++) {
      uint64_t mv=i.o==L?x.lt[w]:i.o==G?x.gt[w]:i.o==LE?(mask[w]&~(x.gt[w]|x.unk[w])):(mask[w]&~(x.lt[w]|x.unk[w]));
      uint64_t dif=(a.b[0][w]^b.b[0][w])|(a.b[1][w]^b.b[1][w])|(a.b[2][w]^b.b[2][w]);
      uint64_t u=x.unk[w]&dif;
      for(int k=0;k<3;k++)a.b[k][w]=((a.b[k][w]&~mv)|(b.b[k][w]&mv)|u)&mask[w];
    }
    match(x,i.d);
  }
};
string reg(int r){return string(r<5?"P":"S")+to_string(r<5?r:r-5);}
vector<I> readp(string path,int &nr){
  ifstream in(path);string line;vector<I>p;map<string,int>regs;nr=5;
  for(int i=0;i<5;i++)regs[reg(i)]=i;
  while(getline(in,line)){auto h=line.find('#');if(h!=string::npos)line.resize(h);for(char &c:line)if(c==',')c=' ';stringstream ss(line);string op,d,s;if(!(ss>>op>>d>>s)||op=="out")continue;
    int o=find(names,names+6,op)-names;if(o==6)throw runtime_error("bad opcode");
    for(string a:{d,s})if(!regs.count(a))regs[a]=nr++;
    p.push_back({o,regs[d],regs[s]});
  }return p;
}
pair<int,int> nearfile(const vector<I>&q,const Machine<9>&fm,string path,int limit){
  array<int,5>best,bt,br;array<Col<9>,5>bc;best.fill(10000);bt.fill(-1);br.fill(0);auto x=fm.init;
  auto consider=[&](int t,int r){for(int j=0;j<5;j++){int e=0;for(int w=0;w<9;w++){uint64_t d=0;for(int b=0;b<3;b++)d|=x.r[r].b[b][w]^fm.goal[j].b[b][w];e+=__builtin_popcountll(d);}if(e<best[j])best[j]=e,bt[j]=t,br[j]=r,bc[j]=x.r[r];}};
  for(int r=0;r<fm.nr;r++)consider(-1,r);for(int t=0;t<(int)q.size();t++){fm.step(x,q[t]);if(q[t].o!=CMP)consider(t,q[t].d);}
  int error=accumulate(best.begin(),best.end(),0),fail=0;for(int w=0;w<9;w++){uint64_t d=0;for(int j=0;j<5;j++)for(int b=0;b<3;b++)d|=bc[j].b[b][w]^fm.goal[j].b[b][w];fail+=__builtin_popcountll(d);}
  if(error>=limit)return {error,fail};
  ofstream out(path);out<<"# n=5 model=out iset=I1 source=w6-local-near k="<<q.size()<<" weak_fail="<<fail<<" weak_error_sum="<<error<<"\n";
  for(int j=0;j<5;j++)if(bt[j]==-1)out<<"out "<<j<<", "<<reg(br[j])<<"\n";
  for(int t=0;t<(int)q.size();t++){auto i=q[t];out<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if(bt[j]==t)out<<"out "<<j<<", "<<reg(br[j])<<"\n";}
  cerr<<"NEAR weak_fail="<<fail<<" weak_error_sum="<<error<<" file="<<path<<"\n";return {error,fail};
}
int main(int argc,char**argv){
  if(argc<3){cerr<<"local seed.s output-prefix [width=3] [first-window=0] [last-window=999]\n";return 1;}
  int nr;auto p=readp(argv[1],nr);nr++;int width=argc>3?atoi(argv[3]):3,first=argc>4?atoi(argv[4]):0,last=argc>5?atoi(argv[5]):999;
  vector<array<int,5>>all,sub;for(int c=0;c<3125;c++){int q=c,used=0;array<int,5>a;for(int j=0;j<5;j++)a[j]=q%5,q/=5,used|=1<<a[j];if(!(used&(used+1)))all.push_back(a);}
  // Deterministic spread, including ties and distinct orders.
  for(int i=0;i<32;i++)sub.push_back(all[(i*173+19)%all.size()]);
  Machine<1> sm;Machine<9> fm;sm.setup(sub,nr);fm.setup(all,nr);
  vector<State<1>>pre(p.size()+1);pre[0]=sm.init;for(int k=0;k<(int)p.size();k++){pre[k+1]=pre[k];sm.step(pre[k+1],p[k]);}
  auto full=fm.init;for(auto i:p)fm.step(full,i);if(full.done!=31){cerr<<"seed fails independent simulator\n";return 2;}
  vector<I>alphabet;for(int o=0;o<6;o++)for(int d=0;d<nr;d++)for(int s=0;s<nr;s++)if(d!=s)alphabet.push_back({o,d,s});
  cerr<<"k="<<p.size()<<" regs="<<nr<<" alphabet="<<alphabet.size()<<" width="<<width<<"\n";
  uint64_t tried=0,filtered=0;vector<I>seq(width-1);bool found=false;int nearbest=99999;
  for(int a=first;a+width<=(int)p.size()&&a<=last&&!found;a++){
    function<void(int,State<1>)> rec=[&](int depth,State<1>x){
      if(found)return;
      if(depth==width-1){tried++;for(int k=a+width;k<(int)p.size();k++)sm.step(x,p[k]);if(x.done!=31)return;filtered++;
        auto y=fm.init;for(int k=0;k<a;k++)fm.step(y,p[k]);for(auto i:seq)fm.step(y,i);for(int k=a+width;k<(int)p.size();k++)fm.step(y,p[k]);
        if(y.done!=31){vector<I>q(p.begin(),p.begin()+a);q.insert(q.end(),seq.begin(),seq.end());q.insert(q.end(),p.begin()+a+width,p.end());nearbest=min(nearbest,nearfile(q,fm,string(argv[2])+"_near.s",nearbest).first);return;}
        vector<I>q(p.begin(),p.begin()+a);q.insert(q.end(),seq.begin(),seq.end());q.insert(q.end(),p.begin()+a+width,p.end());
        ofstream out(string(argv[2])+".s");out<<"# n=5 model=out iset=I1 source=w6-local k="<<q.size()<<"\n";
        auto z=fm.init;for(auto i:q){int old=z.done;fm.step(z,i);out<<names[i.o]<<" "<<reg(i.d)<<", "<<reg(i.s)<<"\n";for(int j=0;j<5;j++)if((z.done^old)>>j&1)out<<"out "<<j<<", "<<reg(i.d)<<"\n";}
        cerr<<"HIT window="<<a<<" k="<<q.size()<<"\n";found=true;return;
      }
      for(auto i:alphabet){seq[depth]=i;auto y=x;sm.step(y,i);rec(depth+1,y);if(found)return;}
    };
    uint64_t before=tried;rec(0,pre[a]);cerr<<"window="<<a<<" tried="<<tried-before<<" filtered_total="<<filtered<<"\n";
  }
  cerr<<"RESULT "<<(found?"HIT":"NONE")<<" tried="<<tried<<" filtered="<<filtered<<"\n";
  return 0;
}
