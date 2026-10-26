// enum.cpp -- exhaustive layered BFS for the minimal length of cmov sorting programs.
// enum agent, independent of agents/sat. Model: shared/MODEL.md (relaxed lower-bound model:
// scratch = T (top), initial flags = eq). Every pruning rule is listed in agents/enum/PRUNING.md.
//
// usage: enum N WEAK ISET NS KBOUND THREADS MODE SYM [OUTFILE]
//   N      number of inputs
//   WEAK   1 = all weak order types (Fubini), 0 = strict permutations only (a relaxation, sound for LB)
//   ISET   0 = I0 {mov,cmp,cmovl,cmovg}, 1 = I1 (I0 + cmovle, cmovge)
//   NS     number of scratch registers (R = N + NS). NS >= KBOUND gives the unbounded model.
//   KBOUND f-bound: states with g + h > KBOUND are pruned. Output: minimal depth of a goal state if
//          it is <= KBOUND, else "none<=KBOUND" (= no program of length <= KBOUND).
//   MODE   0 = reg (output j = final P_j), 1 = out (output j = free snapshot of any register at any time)
//   SYM    1 = (MODE 1 only) quotient by input relabelling S_N
#include <bits/stdc++.h>
#include <omp.h>
using namespace std;
typedef uint32_t u32; typedef uint64_t u64; typedef uint8_t u8; typedef unsigned __int128 u128;

static inline u64 mix64(u64 x){ x^=x>>33; x*=0xff51afd7ed558ccdULL; x^=x>>33; x*=0xc4ceb9fe1a85ec53ULL; x^=x>>33; return x; }
static u64 hashBytes(const u8* d, int L){
  u64 h=0x9E3779B97F4A7C15ULL ^ (u64)L; int i=0;
  for(;i+8<=L;i+=8){ u64 v; memcpy(&v,d+i,8); h=mix64(h^v)+(u64)i; }
  u64 v=0; memcpy(&v,d+i,L-i); return mix64(h^v^((u64)(L-i)<<56));
}
static inline u64 hashWords(const u32* d,int K){ u64 h=0x1234567ULL; for(int i=0;i<K;i++) h=mix64(h^((u64)d[i]+((u64)i<<40))); return h; }

static const u32 EMPTY=0xFFFFFFFFu;

// ---------- thread-safe interning of byte vectors (columns, flag vectors); ids are exact ----------
struct Interner {
  int L; static const int SH=256; static const u32 BLK=1u<<16; static const int MAXBLK=1<<16;
  struct Shard { mutex m; vector<u8*> blocks; u32 cnt=0; vector<u32> tab; vector<u32> th; u32 mask=0; };
  Shard* sh;
  explicit Interner(int L_):L(L_){ sh=new Shard[SH]; for(int i=0;i<SH;i++){ sh[i].blocks.reserve(MAXBLK); sh[i].tab.assign(1024,EMPTY); sh[i].th.assign(1024,0); sh[i].mask=1023; } }
  inline const u8* get(u32 id) const { const Shard&s=sh[id&(SH-1)]; u32 li=id>>8; return s.blocks[li/BLK]+(size_t)(li%BLK)*L; }
  u32 intern(const u8* d){ return intern(d,hashBytes(d,L)); }
  u32 intern(const u8* d,u64 h){
    int si=(int)(h&(SH-1)); Shard&s=sh[si]; u32 hh=(u32)(h>>32);
    lock_guard<mutex> g(s.m);
    u32 pos=hh&s.mask;
    while(true){ u32 e=s.tab[pos]; if(e==EMPTY) break; if(s.th[pos]==hh && memcmp(get(e),d,L)==0) return e; pos=(pos+1)&s.mask; }
    u32 li=s.cnt++; if(li>=(1u<<24)-1){ fprintf(stderr,"interner overflow\n"); exit(3); }
    if(li/BLK>=s.blocks.size()) s.blocks.push_back((u8*)malloc((size_t)BLK*L));
    memcpy(s.blocks[li/BLK]+(size_t)(li%BLK)*L,d,L);
    u32 id=(li<<8)|(u32)si; s.tab[pos]=id; s.th[pos]=hh;
    if((u64)s.cnt*2 > (u64)s.mask+1){
      u32 nm=s.mask*2+1; vector<u32> nt(nm+1,EMPTY), nh(nm+1,0);
      for(u32 p=0;p<=s.mask;p++) if(s.tab[p]!=EMPTY){ u32 q=s.th[p]&nm; while(nt[q]!=EMPTY) q=(q+1)&nm; nt[q]=s.tab[p]; nh[q]=s.th[p]; }
      s.tab.swap(nt); s.th.swap(nh); s.mask=nm;
    }
    return id;
  }
  size_t size() const { size_t t=0; for(int i=0;i<SH;i++) t+=sh[i].cnt; return t; }
};

// ---------- open-addressing set of fixed-length u32 keys (one thread per shard) ----------
struct KeySet {
  int K=0; vector<u32> tab; u64 mask=0, cnt=0;
  void init(int K_, u64 cap){ K=K_; mask=cap-1; cnt=0; tab.assign(cap*K,EMPTY); }
  bool insert(const u32* k, u64 h){
    if((cnt+1)*10 > (mask+1)*7) grow();
    u64 p=h&mask;
    while(true){ u32* e=&tab[p*K]; if(e[0]==EMPTY){ memcpy(e,k,K*4); cnt++; return true; } if(memcmp(e,k,K*4)==0) return false; p=(p+1)&mask; }
  }
  void grow(){
    u64 nm=mask*2+1; vector<u32> nt((nm+1)*K,EMPTY);
    for(u64 p=0;p<=mask;p++){ const u32* e=&tab[p*K]; if(e[0]==EMPTY) continue; u64 q=hashWords(e,K)&nm; while(nt[q*K]!=EMPTY) q=(q+1)&nm; memcpy(&nt[q*K],e,K*4); }
    tab.swap(nt); mask=nm;
  }
};

// ---------- problem ----------
static int N, NS, NR, K, ISET, KB, NT, MODE; static bool WEAK, SYM;
static int NW;                       // number of order types
static vector<vector<u8>> rk;        // rk[w][i] = dense rank of x_i in order type w
static vector<int> nDistinct;
static vector<int> sw;               // indices of strict order types
static vector<vector<u8>> inv;       // inv[p][v] = i with rk[sw[p]][i]==v (strict only)
static vector<vector<int>> pmap;     // pmap[s][w] = index of order type w o sigma_s
static vector<vector<u32>> needMask; // needMask[done][w] = values still needed (MODE 1) / all values (MODE 0)
static u8 TV;
static Interner *cols, *flgs;
static u32 TCOL, EQFLAG; static u32 ALLDONE;
static vector<u32> targetId; static vector<vector<u8>> targetCol;
static int NCOND;
static const char* condName[4]={"cmovl","cmovg","cmovle","cmovge"};
static inline bool condHolds(int c,u8 f){ switch(c){ case 0: return f==1; case 1: return f==2; case 2: return f!=2; default: return f!=1; } }
static inline u8 cmpv(u8 a,u8 b){ return a<b?1:(a>b?2:0); }

static void genOrders(){
  vector<u8> r(N);
  function<void(int)> rec=[&](int i){
    if(i==N){ int m=0; for(int j=0;j<N;j++) m=max(m,(int)r[j]+1); vector<bool> seen(m,false); for(int j=0;j<N;j++) seen[r[j]]=true;
      for(int j=0;j<m;j++) if(!seen[j]) return;
      if(!WEAK && m!=N) return;
      rk.push_back(r); nDistinct.push_back(m); return; }
    for(int v=0;v<N;v++){ r[i]=(u8)v; rec(i+1); } };
  rec(0); NW=(int)rk.size();
  for(int w=0;w<NW;w++) if(nDistinct[w]==N){ sw.push_back(w); vector<u8> iv(N); for(int i=0;i<N;i++) iv[rk[w][i]]=(u8)i; inv.push_back(iv); }
  map<vector<u8>,int> idx; for(int w=0;w<NW;w++) idx[rk[w]]=w;
  vector<int> sg(N); iota(sg.begin(),sg.end(),0);
  do { vector<int> m(NW); for(int w=0;w<NW;w++){ vector<u8> r2(N); for(int i=0;i<N;i++) r2[i]=rk[w][sg[i]]; m[w]=idx.at(r2); } pmap.push_back(m); }
  while(next_permutation(sg.begin(),sg.end()));
}

// canonical flag polarity: first non-eq entry is lt. Negating all flags and swapping cmovl<->cmovg,
// cmovle<->cmovge maps programs to programs (I0 and I1 are closed under the swap).
static void canonFlags(u8* f){ for(int w=0;w<NW;w++){ if(f[w]==0) continue; if(f[w]==2){ for(int v=0;v<NW;v++) if(f[v]) f[v]=3-f[v]; } return; } }

static inline u32 doneAfter(u32 done,const u8* col){ // MODE 1: a target column present in a register = output taken
  if(MODE!=1) return done;
  for(int j=0;j<N;j++) if(!(done>>j&1) && memcmp(col,targetCol[j].data(),NW)==0) done|=1u<<j;
  return done; }

// ---------- heuristic: -1 = dead, else h = hcmp + hwrites (both admissible, disjoint instruction kinds) ----------
struct HS { vector<u128> keys; };
static int heuristic(const u8* const* cp, const u8* f, u32 done, HS& hs){
  const vector<u32>& nm=needMask[done];
  for(int w=0;w<NW;w++){ u32 pres=0; for(int r=0;r<NR;r++){ u8 v=cp[r][w]; if(v<TV) pres|=1u<<v; } if((pres&nm[w])!=nm[w]) return -1; }
  int hw=0;
  if(MODE==0){ for(int j=0;j<N;j++) if(memcmp(cp[j],targetCol[j].data(),NW)!=0) hw++; }
  else hw=__builtin_popcount(ALLDONE&~done);
  if(hw==0) return 0;
  int m=(int)sw.size(); hs.keys.resize(m);
  // all-T registers carry index N for every perm: they do not split classes, skip them (keeps the key in 128 bits)
  bool isT[40]; int bits=2+(MODE==1?3*N:0); const u8* Td=cols->get(TCOL);
  for(int r=0;r<NR;r++){ isT[r]=(memcmp(cp[r],Td,NW)==0); if(!isT[r]) bits+=3; }
  if(bits>128){ fprintf(stderr,"class key overflow\n"); exit(5); }
  for(int p=0;p<m;p++){ int w=sw[p]; u128 k=f[w];
    for(int r=0;r<NR;r++){ if(isT[r]) continue; u8 v=cp[r][w]; k=k*8+((v==TV)?(u128)N:(u128)inv[p][v]); }
    if(MODE==1) for(int j=0;j<N;j++) if(done>>j&1) k=k*8+inv[p][j];
    hs.keys[p]=k; }
  sort(hs.keys.begin(),hs.keys.end()); int best=1,run=1; for(int p=1;p<m;p++){ if(hs.keys[p]==hs.keys[p-1]){ run++; best=max(best,run);} else run=1; }
  int hc=0; while((1<<hc)<best) hc++;
  return hc+hw;
}

// ---------- canonical key [regs..., flagId, done] ----------
static inline bool regLess(u32 a,u32 b){ bool ta=(a==TCOL), tb=(b==TCOL); if(ta!=tb) return tb; return a<b; }
struct CS { vector<u8> buf, fb, bestbuf, bestf; vector<u64> hv, besth; vector<int> ord; };
// cp: raw column data per register, ids: known ids (EMPTY = unknown), f: raw flags (any polarity)
static void canonical(const u8* const* cp, const u32* ids, const u8* f, u32 done, u32* key, CS& cs){
  if(!(MODE==1 && SYM)){
    for(int r=0;r<NR;r++) key[r]=(ids[r]!=EMPTY)?ids[r]:cols->intern(cp[r]);
    memcpy(cs.fb.data(),f,NW); canonFlags(cs.fb.data()); key[NR]=flgs->intern(cs.fb.data()); key[NR+1]=done;
    if(MODE==0) sort(key+N,key+NR,regLess); else sort(key,key+NR,regLess);
    return;
  }
  // quotient by S_N x register renaming x flag polarity: choose sigma minimising (sorted column hashes, flag hash)
  int G=(int)pmap.size(); bool have=false;
  for(int s=0;s<G;s++){ const int* pm=pmap[s].data();
    for(int r=0;r<NR;r++){ u8* b=&cs.buf[(size_t)r*NW]; for(int w=0;w<NW;w++) b[w]=cp[r][pm[w]]; cs.hv[r]=hashBytes(b,NW); }
    for(int w=0;w<NW;w++) cs.fb[w]=f[pm[w]]; canonFlags(cs.fb.data()); cs.hv[NR]=hashBytes(cs.fb.data(),NW);
    sort(cs.hv.begin(),cs.hv.begin()+NR);
    if(!have || lexicographical_compare(cs.hv.begin(),cs.hv.begin()+NR+1,cs.besth.begin(),cs.besth.begin()+NR+1)){
      have=true; cs.besth.assign(cs.hv.begin(),cs.hv.begin()+NR+1); cs.bestbuf=cs.buf; cs.bestf=cs.fb; }
  }
  // order registers of the chosen image by (hash, id) -- any deterministic order is fine
  vector<pair<u64,u32>> v(NR);
  for(int r=0;r<NR;r++){ const u8* b=&cs.bestbuf[(size_t)r*NW]; u64 h=hashBytes(b,NW); v[r]={h,cols->intern(b,h)}; }
  sort(v.begin(),v.end());
  for(int r=0;r<NR;r++) key[r]=v[r].second;
  key[NR]=flgs->intern(cs.bestf.data()); key[NR+1]=done;
}

// successors of key at depth d with d+1+h <= KB
template<class F>
static void expand(const u32* key, int d, HS& hs, CS& cs, vector<u8>& tmp, vector<u8>& tf, F&& cb){
  const u8* cp[40]; for(int r=0;r<NR;r++) cp[r]=cols->get(key[r]);
  const u8* f=flgs->get(key[NR]); u32 done=key[NR+1];
  // candidate registers: in MODE 1 all registers are interchangeable -> one representative per distinct content;
  // in MODE 0 the P registers are distinct and scratch registers are interchangeable.
  int reps[40], nr=0;
  for(int r=0;r<NR;r++){ bool dup=false; if(MODE==1 || r>=N){ for(int q=(MODE==1?0:N);q<r;q++) if(key[q]==key[r]){ dup=true; break; } } if(!dup) reps[nr++]=r; }
  u32 nid[40]; const u8* ncp[40]; u32 nk[40];
  for(int ia=0;ia<nr;ia++) for(int ib=ia+1;ib<nr;ib++){ int a=reps[ia], b=reps[ib];
    for(int w=0;w<NW;w++) tf[w]=cmpv(cp[a][w],cp[b][w]);
    canonFlags(tf.data()); if(memcmp(tf.data(),f,NW)==0) continue;
    int h=heuristic(cp,tf.data(),done,hs); if(h<0 || d+1+h>KB) continue;
    for(int r=0;r<NR;r++) nid[r]=key[r];
    canonical(cp,nid,tf.data(),done,nk,cs); cb(nk,h);
  }
  for(int id=0;id<nr;id++) for(int is=0;is<nr;is++){ int dst=reps[id], src=reps[is]; if(src==dst) continue;
    for(int c=-1;c<NCOND;c++){
      if(c<0){ if(key[dst]==key[src]) continue; memcpy(tmp.data(),cp[src],NW); }
      else { bool ch=false; for(int w=0;w<NW;w++){ u8 v=condHolds(c,f[w])?cp[src][w]:cp[dst][w]; tmp[w]=v; ch|=(v!=cp[dst][w]); } if(!ch) continue; }
      for(int r=0;r<NR;r++){ ncp[r]=cp[r]; nid[r]=key[r]; } ncp[dst]=tmp.data(); nid[dst]=(c<0)?key[src]:EMPTY;
      u32 nd=doneAfter(done,tmp.data());
      int h=heuristic(ncp,f,nd,hs); if(h<0 || d+1+h>KB) continue;
      canonical(ncp,nid,f,nd,nk,cs); cb(nk,h);
    }
  }
}

// ---------- concrete replay for program recovery ----------
static string regName(int r){ return r<N? "P"+to_string(r) : "S"+to_string(r-N); }
struct Conc { vector<vector<u8>> c; vector<u8> f; u32 done; };
static void concKey(const Conc& s, u32* key, CS& cs){
  const u8* cp[40]; u32 ids[40]; for(int r=0;r<NR;r++){ cp[r]=s.c[r].data(); ids[r]=EMPTY; }
  canonical(cp,ids,s.f.data(),s.done,key,cs); }

static vector<string> recover(const vector<vector<u32>>& chain, CS& cs){
  Conc s; s.c.assign(NR,vector<u8>(NW,TV)); s.f.assign(NW,0); s.done=0;
  for(int i=0;i<N;i++) for(int w=0;w<NW;w++) s.c[i][w]=rk[w][i];
  vector<string> prog; u32 kk[40];
  concKey(s,kk,cs); if(memcmp(kk,chain[0].data(),K*4)!=0){ fprintf(stderr,"recover: root mismatch\n"); exit(4); }
  for(size_t st=1;st<chain.size();st++){
    bool ok=false;
    for(int a=0;a<NR && !ok;a++) for(int b=0;b<NR && !ok;b++){ if(a==b) continue;
      { Conc t=s; for(int w=0;w<NW;w++) t.f[w]=cmpv(s.c[a][w],s.c[b][w]); concKey(t,kk,cs);
        if(memcmp(kk,chain[st].data(),K*4)==0){ s=t; prog.push_back("cmp "+regName(a)+", "+regName(b)); ok=true; continue; } }
      for(int c=-1;c<NCOND && !ok;c++){ Conc t=s;
        if(c<0) t.c[a]=s.c[b]; else for(int w=0;w<NW;w++) t.c[a][w]=condHolds(c,s.f[w])?s.c[b][w]:s.c[a][w];
        t.done=doneAfter(s.done,t.c[a].data()); concKey(t,kk,cs);
        if(memcmp(kk,chain[st].data(),K*4)==0){ prog.push_back(string(c<0?"mov":condName[c])+" "+regName(a)+", "+regName(b));
          for(int j=0;j<N;j++) if((t.done>>j&1) && !(s.done>>j&1)) prog.push_back("out "+to_string(j)+", "+regName(a));
          s=t; ok=true; } }
    }
    if(!ok){ fprintf(stderr,"recover: step %zu failed\n",st); exit(4); }
  }
  return prog;
}

int main(int argc,char** argv){
  if(argc<9){ fprintf(stderr,"usage: enum N WEAK ISET NS KBOUND THREADS MODE SYM [OUTFILE]\n"); return 1; }
  N=atoi(argv[1]); WEAK=atoi(argv[2]); ISET=atoi(argv[3]); NS=atoi(argv[4]); KB=atoi(argv[5]); NT=atoi(argv[6]);
  MODE=atoi(argv[7]); SYM=atoi(argv[8]); string outp=argc>9?argv[9]:"";
  NR=N+NS; K=NR+2; TV=(u8)N; NCOND=ISET?4:2; ALLDONE=(1u<<N)-1;
  if(NR>38 || N>7){ fprintf(stderr,"too many registers\n"); return 1; }
  if(SYM && MODE!=1){ fprintf(stderr,"SYM needs MODE 1\n"); return 1; }
  omp_set_num_threads(NT);
  genOrders();
  cols=new Interner(NW); flgs=new Interner(NW);
  { vector<u8> t(NW,TV); TCOL=cols->intern(t.data()); vector<u8> e(NW,0); EQFLAG=flgs->intern(e.data()); }
  targetCol.assign(N,vector<u8>(NW)); targetId.resize(N);
  for(int w=0;w<NW;w++){ vector<u8> s=rk[w]; sort(s.begin(),s.end()); for(int j=0;j<N;j++) targetCol[j][w]=s[j]; }
  for(int j=0;j<N;j++) targetId[j]=cols->intern(targetCol[j].data());
  needMask.assign(1u<<N,vector<u32>(NW,0));
  for(u32 dn=0;dn<(1u<<N);dn++) for(int w=0;w<NW;w++) for(int j=0;j<N;j++) if(MODE==0 || !(dn>>j&1)) needMask[dn][w]|=1u<<targetCol[j][w];
  printf("enum: N=%d WEAK=%d ISET=I%d NS=%d R=%d KBOUND=%d MODE=%s SYM=%d orders=%d strict=%zu threads=%d\n",
         N,(int)WEAK,ISET,NS,NR,KB,MODE?"out":"reg",(int)SYM,NW,sw.size(),NT);

  CS cs0; cs0.buf.resize((size_t)NR*NW); cs0.fb.resize(NW); cs0.hv.resize(NR+1);
  vector<u32> root(K);
  { Conc s; s.c.assign(NR,vector<u8>(NW,TV)); s.f.assign(NW,0); s.done=0; for(int i=0;i<N;i++) for(int w=0;w<NW;w++) s.c[i][w]=rk[w][i];
    concKey(s,root.data(),cs0);
    HS hs; const u8* cp[40]; for(int r=0;r<NR;r++) cp[r]=s.c[r].data(); int h=heuristic(cp,s.f.data(),0,hs); printf("h(root)=%d\n",h);
    if(h>KB){ printf("RESULT none<=%d (root pruned)\n",KB); return 0; } }

  const int NB=1024;
  vector<KeySet> visited(NB); for(auto& v: visited) v.init(K,1<<10);
  struct Layer { vector<u32> keys; vector<u64> par; };
  vector<Layer> layers(1); layers[0].keys=root; layers[0].par.push_back(0);
  { u64 h=hashWords(root.data(),K); visited[h>>54].insert(root.data(),h); }
  int found=-1; u64 foundIdx=0; u64 nGoals=0, total=1; auto t0=chrono::steady_clock::now();
  auto isGoal=[&](const u32* k){ if(MODE==1) return k[NR+1]==ALLDONE; for(int j=0;j<N;j++) if(k[j]!=targetId[j]) return false; return true; };
  for(int d=0; d<KB && found<0; d++){
    Layer& L=layers[d]; u64 M=L.par.size(); if(M==0) break;
    int S=K+2;
    vector<vector<vector<u32>>> buf(NT, vector<vector<u32>>(NB));
    #pragma omp parallel
    { int t=omp_get_thread_num(); HS hs; CS cs; cs.buf.resize((size_t)NR*NW); cs.fb.resize(NW); cs.hv.resize(NR+1); vector<u8> tmp(NW), tf(NW);
      #pragma omp for schedule(dynamic,64)
      for(u64 i=0;i<M;i++){
        expand(&L.keys[i*K],d,hs,cs,tmp,tf,[&](const u32* nk,int){ u64 h=hashWords(nk,K); auto& b=buf[t][h>>54]; size_t o=b.size(); b.resize(o+S); memcpy(&b[o],nk,K*4); b[o+K]=(u32)i; b[o+K+1]=(u32)(i>>32); });
      }
    }
    vector<vector<u32>> nb(NB); vector<vector<u64>> np(NB);
    #pragma omp parallel for schedule(dynamic,1)
    for(int b=0;b<NB;b++){
      for(int t=0;t<NT;t++){ auto& v=buf[t][b]; for(size_t o=0;o<v.size();o+=S){ const u32* k=&v[o]; u64 h=hashWords(k,K);
          if(visited[b].insert(k,h)){ nb[b].insert(nb[b].end(),k,k+K); np[b].push_back((u64)v[o+K]|((u64)v[o+K+1]<<32)); } }
        vector<u32>().swap(v); }
    }
    layers.emplace_back(); Layer& NL=layers.back();
    vector<size_t> off(NB+1,0); for(int b=0;b<NB;b++) off[b+1]=off[b]+np[b].size(); size_t tot=off[NB];
    NL.keys.resize(tot*K); NL.par.resize(tot);
    #pragma omp parallel for schedule(dynamic,1)
    for(int b=0;b<NB;b++){ memcpy(&NL.keys[off[b]*K],nb[b].data(),nb[b].size()*4); memcpy(&NL.par[off[b]],np[b].data(),np[b].size()*8); vector<u32>().swap(nb[b]); vector<u64>().swap(np[b]); }
    for(u64 i=0;i<tot;i++) if(isGoal(&NL.keys[i*K])){ if(found<0){ found=d+1; foundIdx=i; } nGoals++; }
    total+=tot;
    double el=chrono::duration<double>(chrono::steady_clock::now()-t0).count();
    printf("depth %d: %zu new states (total=%llu cols=%zu flags=%zu) %.1fs\n",d+1,tot,(unsigned long long)total,cols->size(),flgs->size(),el); fflush(stdout);
  }
  if(found<0){ printf("RESULT none<=%d  (no program of length <= %d; N=%d R=%d I%d MODE=%s WEAK=%d)\n",KB,KB,N,NR,ISET,MODE?"out":"reg",(int)WEAK); return 0; }
  printf("RESULT min=%d goal_states_at_min=%llu\n",found,(unsigned long long)nGoals);
  vector<vector<u32>> chain(found+1); u64 idx=foundIdx;
  for(int d=found; d>=0; d--){ chain[d].assign(&layers[d].keys[idx*K],&layers[d].keys[idx*K]+K); idx=layers[d].par[idx]; }
  vector<string> prog=recover(chain,cs0);
  string hdr="# n="+to_string(N)+" R="+to_string(NR)+" iset=I"+to_string(ISET)+" model="+(MODE?"out":"reg")+" source=agents/enum/src/enum.cpp (BFS, "+(WEAK?"weak orders":"strict perms")+")";
  printf("%s\n",hdr.c_str()); for(auto& s: prog) printf("%s\n",s.c_str());
  if(!outp.empty()){ FILE* fo=fopen(outp.c_str(),"w"); fprintf(fo,"%s\n",hdr.c_str()); for(auto& s: prog) fprintf(fo,"%s\n",s.c_str()); fclose(fo); }
  return 0;
}
