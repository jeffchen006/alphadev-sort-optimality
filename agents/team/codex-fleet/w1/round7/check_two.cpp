// Independent scalar exhaustive check: remove the three median-only writes,
// insert any two I1 instructions at any gaps, free median output snapshots.
#include <bits/stdc++.h>
#include <sys/resource.h>
using namespace std;using U=uint64_t;
struct I{int o,d,s;};struct S{array<int,12>r;int f;};
struct W{array<int,5>x,g;};
struct P{S s;U m;bool ok;};
int R;vector<I>q;vector<W>tests;
bool take(int op,int f){return op==0||op==2&&f<0||op==3&&f<=0||op==4&&f>0||op==5&&f>=0;}
void ins(S&st,I z){if(z.o==1)st.f=(st.r[z.d]>st.r[z.s])-(st.r[z.d]<st.r[z.s]);else if(take(z.o,st.f))st.r[z.d]=st.r[z.s];}
void note(P&p,const W&w,int slot,int r){if(p.s.r[r]==w.g[2])p.m|=U(1)<<slot;}
void fixed(P&p,const W&w,I z,int slot){if(z.o==6){if(p.s.r[z.s]!=w.g[z.d])p.ok=false;}else{ins(p.s,z);if(z.o!=1)note(p,w,slot,z.d);}}
int action(const S&s,I z){if(z.o==1)return R*6+1+(s.r[z.d]>s.r[z.s])-(s.r[z.d]<s.r[z.s]);return z.d*6+(take(z.o,s.f)?s.r[z.s]:s.r[z.d]);}
void act(P&p,const W&w,int a,int slot){if(a>=R*6)p.s.f=a-R*6-1;else{int d=a/6;p.s.r[d]=a%6;note(p,w,slot,d);}}
int main(int argc,char**argv){
 rlimit m{2800ULL*1024*1024,2800ULL*1024*1024};setrlimit(RLIMIT_AS,&m);
 ifstream in(argv[1]);int n;in>>R>>n;while(n--){I z;in>>z.o>>z.d>>z.s;q.push_back(z);}assert(R+(int)q.size()+2<64);
 for(int code=0;code<3125;code++){W w;int c=code,mask=0;for(int&i:w.x){i=c%5;c/=5;mask|=1<<i;}if(mask&(mask+1))continue;w.g=w.x;sort(w.g.begin(),w.g.end());tests.push_back(w);}
 mt19937 rng(271010);shuffle(tests.begin(),tests.end(),rng);stable_sort(tests.begin(),tests.end(),[](W a,W b){auto strict=[](W w){set<int>x(w.x.begin(),w.x.end());return x.size()==5;};return strict(a)>strict(b);});assert(tests.size()==541);
 vector<I>ops;for(int o=0;o<6;o++)for(int d=0;d<R;d++)for(int s=0;s<R;s++)ops.push_back({o,d,s});
 struct C{uint16_t a,b;U mask;};unsigned long long raw=0,simulations=0,slots=0,case_slots=0;clock_t start=clock();
 for(int g=0;g<=(int)q.size();g++)for(int h=g;h<=(int)q.size();h++){
  slots++;vector<C>cs;cs.reserve(ops.size()*ops.size());for(int a=0;a<(int)ops.size();a++)for(int b=0;b<(int)ops.size();b++)cs.push_back({(uint16_t)a,(uint16_t)b,~U(0)});raw+=cs.size();
  for(auto w:tests){if(cs.empty())break;case_slots++;P pre;pre.s.r.fill(5);pre.s.f=0;pre.m=0;pre.ok=true;copy(w.x.begin(),w.x.end(),pre.s.r.begin());for(int r=0;r<R;r++)note(pre,w,r,r);
   for(int t=0;t<g;t++)fixed(pre,w,q[t],R+t);
   if(!pre.ok){cs.clear();break;}
   int A=R*6+3;vector<P>mid(A);vector<bool>mh(A);vector<vector<U>>cache(A,vector<U>(A));vector<vector<bool>>ch(A,vector<bool>(A));size_t keep=0;
   for(auto c:cs){int a=action(pre.s,ops[c.a]);
    if(!mh[a]){P p=pre;act(p,w,a,R+g);for(int t=g;t<h;t++)fixed(p,w,q[t],R+1+t);mid[a]=p;mh[a]=true;}
    P const&p=mid[a];if(!p.ok)continue;int b=action(p.s,ops[c.b]);
    if(!ch[a][b]){P z=p;act(z,w,b,R+1+h);for(int t=h;t<(int)q.size();t++)fixed(z,w,q[t],R+2+t);cache[a][b]=z.ok?z.m:0;ch[a][b]=true;simulations++;}
    c.mask&=cache[a][b];if(c.mask)cs[keep++]=c;
   }cs.resize(keep);
  }
  if(!cs.empty()){cerr<<"SURVIVORS "<<g<<" "<<h<<" "<<cs.size()<<"\n";return 1;}
  if(h==(int)q.size())cout<<"PROGRESS first_gap="<<g<<" raw="<<raw<<" simulations="<<simulations<<" cpu="<<double(clock()-start)/CLOCKS_PER_SEC<<endl;
 }
 cout<<"RESULT NONE slots="<<slots<<" raw="<<raw<<" simulations="<<simulations<<" case_slots="<<case_slots<<" cpu="<<double(clock()-start)/CLOCKS_PER_SEC<<endl;
}
