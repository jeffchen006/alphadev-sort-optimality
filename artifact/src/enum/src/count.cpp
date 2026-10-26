// count.cpp -- count the instruction sequences of length exactly K that sort (enum agent).
// Model "reg" (MODEL §1): registers P0..P{n-1}, S0..S{R-n-1}; outputs = final P_j; relaxed semantics (scratch = T,
// flags = eq). Exact memoised DP over raw (non-canonical) states: count(s, r) = sum over instructions of count(s', r-1).
// Pruning: only an admissible bound (hcmp + #P_j wrong, PRUNING.md H1/H2'), so counts are exact.
// usage: count N R ISET K WEAK NOUNINIT
//   NOUNINIT 1 = forbid reading a never-written register (Ullrich-Hack search rule), 0 = allow (reads give T)
#include <bits/stdc++.h>
using namespace std;
typedef uint8_t u8; typedef uint64_t u64; typedef unsigned __int128 u128; typedef uint32_t u32;
static int N, R, ISET, K, NW; static bool WEAK, NOUNINIT, CMPORD; static u8 TV;
static vector<vector<u8>> rk; static vector<int> sw; static vector<vector<u8>> inv; static vector<vector<u8>> tgt;
static int NCOND; static inline bool condHolds(int c,u8 f){ switch(c){ case 0: return f==1; case 1: return f==2; case 2: return f!=2; default: return f!=1; } }
static inline u8 cmpv(u8 a,u8 b){ return a<b?1:(a>b?2:0); }
// state: R columns (NW bytes each) + flags (NW) + init mask (1 byte)
struct H { size_t operator()(const string& s) const { return hash<string>()(s); } };
static unordered_map<string,u64,H> memo[64];
static int heur(const string& s){
  const u8* c=(const u8*)s.data(); const u8* f=c+R*NW; int hw=0;
  for(int j=0;j<N;j++) if(memcmp(c+j*NW,tgt[j].data(),NW)) hw++;
  if(hw==0) return 0;
  // dead: some value of w missing from all registers
  for(int w=0;w<NW;w++){ u32 pres=0, need=0; for(int j=0;j<N;j++) need|=1u<<tgt[j][w]; for(int r=0;r<R;r++){ u8 v=c[r*NW+w]; if(v<TV) pres|=1u<<v; } if((pres&need)!=need) return 99; }
  int m=sw.size(); vector<u128> keys(m);
  for(int p=0;p<m;p++){ int w=sw[p]; u128 k=f[w]; for(int r=0;r<R;r++){ u8 v=c[r*NW+w]; k=k*8+(v==TV? N : inv[p][v]); } keys[p]=k; }
  sort(keys.begin(),keys.end()); int best=1,run=1; for(int p=1;p<m;p++){ if(keys[p]==keys[p-1]){ run++; best=max(best,run);} else run=1; }
  int hc=0; while((1<<hc)<best) hc++;
  return hc+max(hw,hc);
}
static u64 cnt(const string& s, int r){
  const u8* c=(const u8*)s.data(); bool goal=true; for(int j=0;j<N;j++) if(memcmp(c+j*NW,tgt[j].data(),NW)) goal=false;
  if(r==0) return goal?1:0;
  if(heur(s)>r) return 0;
  auto it=memo[r].find(s); if(it!=memo[r].end()) return it->second;
  u64 tot=0; u8 init=(u8)s[R*NW+NW];
  string t;
  for(int a=0;a<R;a++) for(int b=0;b<R;b++){ if(a==b) continue;
    if(NOUNINIT && !((init>>b)&1)) continue;           // source must be initialised
    // cmp a,b
    if((!NOUNINIT || ((init>>a)&1)) && (!CMPORD || a<b)){ t=s; u8* tf=(u8*)&t[R*NW]; for(int w=0;w<NW;w++) tf[w]=cmpv(c[a*NW+w],c[b*NW+w]); tot+=cnt(t,r-1); }
    // mov a,b
    { t=s; memcpy(&t[a*NW],&s[b*NW],NW); t[R*NW+NW]=(char)(init|(1<<a)); tot+=cnt(t,r-1); }
    for(int cd=0;cd<NCOND;cd++){
      if(NOUNINIT && !((init>>a)&1)) continue;          // a cmov reads its destination
      t=s; const u8* f=c+R*NW; for(int w=0;w<NW;w++) if(condHolds(cd,f[w])) t[a*NW+w]=s[b*NW+w];
      tot+=cnt(t,r-1); }
  }
  memo[r][s]=tot; return tot;
}
int main(int argc,char** argv){
  if(argc<7){ fprintf(stderr,"usage: count N R ISET K WEAK NOUNINIT\n"); return 1; }
  N=atoi(argv[1]); R=atoi(argv[2]); ISET=atoi(argv[3]); K=atoi(argv[4]); WEAK=atoi(argv[5]); NOUNINIT=atoi(argv[6]); CMPORD=argc>7&&atoi(argv[7]);
  TV=N; NCOND=ISET?4:2;
  vector<u8> r(N); function<void(int)> rec=[&](int i){ if(i==N){ int m=0; for(int j=0;j<N;j++) m=max(m,(int)r[j]+1); set<int> s(r.begin(),r.end()); if((int)s.size()!=m) return; if(!WEAK && m!=N) return; rk.push_back(r); return; } for(int v=0;v<N;v++){ r[i]=v; rec(i+1);} };
  rec(0); NW=rk.size();
  for(int w=0;w<NW;w++){ set<int> s(rk[w].begin(),rk[w].end()); if((int)s.size()==N){ sw.push_back(w); vector<u8> iv(N); for(int i=0;i<N;i++) iv[rk[w][i]]=i; inv.push_back(iv);} }
  tgt.assign(N,vector<u8>(NW)); for(int w=0;w<NW;w++){ vector<u8> s=rk[w]; sort(s.begin(),s.end()); for(int j=0;j<N;j++) tgt[j][w]=s[j]; }
  string s0(R*NW+NW+1,0); for(int i=0;i<R;i++) for(int w=0;w<NW;w++) s0[i*NW+w]=(char)(i<N? rk[w][i] : TV);
  s0[R*NW+NW]=(char)((1<<N)-1);
  u64 c=cnt(s0,K); size_t ms=0; for(int i=0;i<=K;i++) ms+=memo[i].size();
  printf("count: N=%d R=%d I%d K=%d WEAK=%d NOUNINIT=%d CMPORD=%d -> %llu programs (memo states %zu)\n",N,R,ISET,K,(int)WEAK,(int)NOUNINIT,(int)CMPORD,(unsigned long long)c,ms);
}
