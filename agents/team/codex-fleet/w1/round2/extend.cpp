// Exhaustive flag omission in the round-1 9-stage SSA diagrams.
// Each omitted stage independently selects A, B, sel(flag,A,B), or sel(flag,B,A)
// for each output. All earlier values remain available (unbounded SSA registers).
#include <bits/stdc++.h>
using namespace std; using U=uint32_t;using B=__uint128_t;
const B ALL=(B(1)<<120)-1;
struct Col{B p[3]{};bool operator==(const Col&o)const{return p[0]==o.p[0]&&p[1]==o.p[1]&&p[2]==o.p[2];}};
Col sel(B f,const Col&a,const Col&b){Col z;for(int i=0;i<3;i++)z.p[i]=(f&a.p[i])|((ALL^f)&b.p[i]);return z;}
B gt(const Col&a,const Col&b){B eq=ALL,r=0;for(int i=2;i>=0;i--){r|=eq&a.p[i]&~b.p[i];eq&=~(a.p[i]^b.p[i]);}return r;}
int pop(B x){return __builtin_popcountll((uint64_t)x)+__builtin_popcountll((uint64_t)(x>>64));}
struct Net{int a[9],b[9];};vector<Net> nets;Col initial[5],goal[5];
uint64_t nodes[10]{},prunes[10]{},leaves=0,wins=0;int C,nindex; int extended=1;int modes[9];Net *netp;
// A class is a set of strict orders with identical comparison history.
vector<B> refine(const vector<B>&cl,B flag,int remaining){vector<B>r;int bound=1<<remaining;for(B x:cl){B a=x&flag,b=x&~flag;if(pop(a)>bound||pop(b)>bound)return {};if(a)r.push_back(a);if(b)r.push_back(b);}return r;}
void dfs(int j,int used,Col*v,B flag,bool hasflag,const vector<B>&cl){
 nodes[j]++;if(used>C||used+9-j<C)return;
 if(j==9){leaves++;int found=0;for(int k=0;k<5;k++)for(int t=0;t<23;t++)if(v[t]==goal[k]){found++;break;}if(found==5){wins++;cout<<"FUNCTIONAL network="<<nindex<<" c="<<C<<" modes=";for(int m:modes)cout<<m<<",";cout<<endl;}return;}
 auto a=v[netp->a[j]],b=v[netp->b[j]];
 if(used<C){B f=gt(a,b);auto nc=refine(cl,f,C-used-1);if(!nc.empty()){
  v[5+2*j]=sel(f,b,a);v[6+2*j]=sel(f,a,b);modes[j]=16;dfs(j+1,used+1,v,f,true,nc);
 }else prunes[j]++;}
 if(used+8-j>=C){
  struct Opt{Col col;int d,s;};
  vector<Opt> local={{a,netp->a[j],netp->a[j]},{b,netp->b[j],netp->b[j]}};
  if(hasflag){local.push_back({sel(flag,a,b),netp->b[j],netp->a[j]});local.push_back({sel(flag,b,a),netp->a[j],netp->b[j]});}
  auto unique=[](vector<Opt> x){vector<Opt>r;for(auto &q:x){bool dup=false;for(auto &p:r)if(p.col==q.col){dup=true;break;}if(!dup)r.push_back(q);}return r;};
  local=unique(local);
  vector<Opt> all;
  for(int d=0;d<5+2*j;d++)for(int s=0;s<5+2*j;s++)if(hasflag||d==s)all.push_back({hasflag?sel(flag,v[s],v[d]):v[d],d,s});
  all=unique(all);
  set<pair<array<B,3>,array<B,3>>> seen;
  auto branch=[&](const Opt&x,const Opt&y){
   pair<array<B,3>,array<B,3>> key;copy(x.col.p,x.col.p+3,key.first.begin());copy(y.col.p,y.col.p+3,key.second.begin());if(!seen.insert(key).second)return;
   v[5+2*j]=x.col;v[6+2*j]=y.col;modes[j]=1000+(x.d*32+x.s)*1024+(y.d*32+y.s);dfs(j+1,used,v,flag,hasflag,cl);
  };
  for(auto &x:all)for(auto &y:(extended==2?all:local))branch(x,y);
  if(extended==1)for(auto &x:local)for(auto &y:all)branch(x,y);

 }
}
int main(int argc,char**argv){C=argc>1?atoi(argv[1]):8;int begin=argc>2?atoi(argv[2]):0,end=argc>3?atoi(argv[3]):14904;extended=argc>4?atoi(argv[4]):1;
 if(C<7){cout<<"EXCLUDED c="<<C<<" because 2^c < 120 comparison histories on distinct inputs"<<endl;return 0;}
 array<int,5>w={0,1,2,3,4};int t=0;do{for(int i=0;i<5;i++)for(int p=0;p<3;p++)if(w[i]>>p&1)initial[i].p[p]|=B(1)<<t;for(int i=0;i<5;i++)for(int p=0;p<3;p++)if(i>>p&1)goal[i].p[p]|=B(1)<<t;t++;}while(next_permutation(w.begin(),w.end()));
 ifstream in("networks.txt");string line;while(getline(in,line)){Net n;vector<U>terms;for(int i=0;i<5;i++){U x=0;for(int s=0;s<32;s++)if(s>>i&1)x|=1u<<s;terms.push_back(x);}istringstream ss(line);string x;int j=0;while(ss>>x){auto pos=x.find(':');U a=stoul(x.substr(0,pos),0,16),b=stoul(x.substr(pos+1),0,16);n.a[j]=find(terms.begin(),terms.end(),a)-terms.begin();n.b[j]=find(terms.begin(),terms.end(),b)-terms.begin();assert(n.a[j]<5+2*j&&n.b[j]<5+2*j);terms.push_back(a&b);terms.push_back(a|b);j++;}assert(j==9);nets.push_back(n);}
 auto start=chrono::steady_clock::now();for(nindex=begin;nindex<min(end,int(nets.size()));nindex++){netp=&nets[nindex];Col vals[23];copy(initial,initial+5,vals);dfs(0,0,vals,0,false,{ALL});if((nindex+1)%100==0)cerr<<"c="<<C<<" done="<<nindex+1<<" nodes="<<accumulate(nodes,nodes+10,uint64_t(0))<<" leaves="<<leaves<<" wins="<<wins<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<endl;}
 cout<<"COMPLETE c="<<C<<" begin="<<begin<<" end="<<nindex<<" leaves="<<leaves<<" functional="<<wins<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<endl;for(int j=0;j<=9;j++)cout<<"depth="<<j<<" nodes="<<nodes[j]<<" class_prunes="<<prunes[j]<<endl;
}
