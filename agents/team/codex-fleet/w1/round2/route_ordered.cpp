// Exact fixed-value block routing on all 541 weak orders. I1 conditions.
#include <bits/stdc++.h>
using namespace std;using K=__uint128_t;using U=uint32_t;
struct H{size_t operator()(K k)const{uint64_t a=k,b=k>>64;return (a^(b*0x9e3779b97f4a7c15ULL));}};
using Layer=unordered_map<K,int,H>;
struct Gate{int t;U src[23]{};int cond[23][23]{};};struct Block{int cmp,a,b,x,y;Gate g[2];};
struct P{
 int id,N,cls,cap;vector<string>v;vector<Block>bl;K bit[23];uint64_t states=0;int peak=0;vector<Layer>hist;
 P(istream&f,int cap_):cap(cap_){f>>id>>N>>cls;assert(N<=23);v.resize(N);for(auto&s:v)f>>s;bl.resize(9);for(auto&b:bl)f>>b.cmp>>b.a>>b.b>>b.x>>b.y;
 for(int i=0;i<N;i++)bit[i]=K(1)<<(4*i);
 for(auto &b:bl)for(int o=0;o<2;o++){auto &g=b.g[o];g.t=o?b.y:b.x;
  for(int c=0;c<4;c++){U ds=0,ss=0;for(int d=0;d<N;d++){bool dok=true,sok=true;for(int w=0;w<541;w++){int q=(v[b.a][w]>v[b.b][w])-(v[b.a][w]<v[b.b][w]);bool take=c==0?q<0:c==1?q<=0:c==2?q>0:q>=0;if(v[d][w]!=v[g.t][w]){if(take)sok=false;else dok=false;}}if(dok)ds|=1u<<d;if(sok)ss|=1u<<d;}for(int d=0;d<N;d++)if(ds>>d&1){g.src[d]|=ss;for(int s=0;s<N;s++)if(ss>>s&1)g.cond[d][s]=c;}}
 }
 }
 U have(K k){U h=0;for(int i=0;i<N;i++)if((k>>(4*i))&15)h|=1u<<i;return h;}
 void put(Layer&l,K k,int cost){if(cost>cap)return;auto[it,n]=l.emplace(k,cost);if(!n&&cost<it->second)it->second=cost;}
 struct Ch{int d,s,t,c;bool paid,skip;};
 vector<pair<K,pair<int,Ch>>> choices(K key,int cost,const Gate&g){vector<pair<K,pair<int,Ch>>>r;U h=have(key);if(h>>g.t&1){r.push_back({key,{cost,{-1,-1,g.t,0,false,true}}});return r;}
 bool paid=false;for(U m=h;m;m&=m-1){int d=__builtin_ctz(m);U src=g.src[d]&h;if(!src)continue;int s=__builtin_ctz(src),c=g.cond[d][s];r.push_back({key-bit[d]+bit[g.t],{cost+1,{d,s,g.t,c,false,false}}});if(!paid){r.push_back({key+bit[g.t],{cost+2,{d,s,g.t,c,true,false}}});paid=true;}}
 return r;}
 U required(int j){U need=0,made=0;for(int k=j+1;k<9;k++){auto &b=bl[k];if(b.cmp){if(!(made>>b.a&1))need|=1u<<b.a;if(!(made>>b.b&1))need|=1u<<b.b;}made|=(1u<<b.x)|(1u<<b.y);}return need;}
 int solve(bool trace=false){Layer layer;K start=0;for(int i=0;i<5;i++)start+=bit[i];layer[start]=0;if(trace)hist.push_back(layer);
 for(int j=0;j<9;j++){auto &b=bl[j];Layer next;U need=required(j);for(auto[key,cost]:layer){U h=have(key);if(b.cmp&&(!(h>>b.a&1)||!(h>>b.b&1)))continue;
  for(int o=0;o<2;o++)for(auto [mid,p]:choices(key,cost,b.g[o]))if(p.first<=cap)for(auto [end,q]:choices(mid,p.first,b.g[1-o]))if((have(end)&need)==need)put(next,end,q.first);
 }layer.swap(next);states+=layer.size();peak=max(peak,(int)layer.size());if(trace)hist.push_back(layer);if(layer.empty())return -1;}
 int best=999;for(auto[k,c]:layer)best=min(best,c);return best;
 }
 void emit(string path,int best){K current=0;for(auto[k,c]:hist[9])if(c==best){current=k;break;}int cost=best;array<array<Ch,2>,9>plan;
 for(int j=8;j>=0;j--){bool found=false;for(auto [prev,q]:hist[j]){for(int o=0;o<2&&!found;o++)for(auto[mid,p]:choices(prev,q,bl[j].g[o])){for(auto[end,r]:choices(mid,p.first,bl[j].g[1-o]))if(end==current&&r.first==cost){plan[j]={p.second,r.second};current=prev;cost=q;found=true;break;}if(found)break;}if(found)break;}assert(found);}
 vector<int>regs={0,1,2,3,4};auto rn=[](int r){return r<5?"P"+to_string(r):"S"+to_string(r-5);};auto reg=[&](int t){auto it=find(regs.begin(),regs.end(),t);assert(it!=regs.end());return int(it-regs.begin());};
 ofstream f(path);f<<"# n=5 R=32 iset=I1 model=out source=w1_round2_omission_reuse\n";const char*cn[]={"cmovl","cmovle","cmovg","cmovge"};
 vector<array<int,5>>weak;for(int code=0;code<3125;code++){int q=code,mask=0;array<int,5>w;for(int j=4;j>=0;j--){w[j]=q%5;q/=5;mask|=1<<w[j];}if(!(mask&(mask+1)))weak.push_back(w);}string goals[5];for(auto w:weak){sort(w.begin(),w.end());for(int j=0;j<5;j++)goals[j]+=char('0'+w[j]);}int done=0;
 for(int j=0;j<9;j++){auto&b=bl[j];if(b.cmp)f<<"cmp "<<rn(reg(b.a))<<", "<<rn(reg(b.b))<<"\n";for(auto c:plan[j]){if(c.skip)continue;int d=reg(c.d),s=reg(c.s);if(c.paid){int fresh=regs.size();regs.push_back(c.d);f<<"mov "<<rn(fresh)<<", "<<rn(d)<<"\n";d=fresh;}f<<cn[c.c]<<" "<<rn(d)<<", "<<rn(s)<<"\n";regs[d]=c.t;for(int k=0;k<5;k++)if(!(done>>k&1)&&v[c.t]==goals[k]){f<<"out "<<k<<", "<<rn(d)<<"\n";done|=1<<k;}}}assert(done==31);
 }
};
int main(int argc,char**argv){int cap=argc>1?atoi(argv[1]):23;int limit=argc>2?atoi(argv[2]):99999;int emit=argc>3?atoi(argv[3]):-1;ifstream f("round2/problems.txt");int n;f>>n;map<int,int>hist;auto st=chrono::steady_clock::now();uint64_t states=0;for(int i=0;i<n;i++){P p(f,cap);if(i>=limit)continue;int ans=p.solve(i==emit);hist[ans]++;states+=p.states;cout<<"PLAN index="<<i<<" network="<<p.id<<" class="<<p.cls<<" cost="<<ans<<" k="<<(ans<0?-1:8+ans)<<" states="<<p.states<<" peak="<<p.peak<<endl;if(i==emit&&ans>=0)p.emit("round2/witness_out.s",ans);}for(auto[c,n]:hist)cout<<"COST "<<c<<" plans="<<n<<endl;cout<<"states="<<states<<" seconds="<<chrono::duration<double>(chrono::steady_clock::now()-st).count()<<endl;}
