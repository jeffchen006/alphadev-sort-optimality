// enum_out.cpp -- exact minimal length k_out for model M_out(n, R unbounded, I) (MODEL.md §4.3),
// relaxed lower-bound semantics (§2: scratch = T, flags = eq). enum agent; independent of agents/sat.
//
// Search space = "set model" (PRUNING.md, rule S): a state is the SET of distinct non-T columns
// (column = register content as a function of the order type), the flag vector, and the mask of outputs
// already taken. Operations: cmp (cost 1), cmov in place (cost 1), cmov into a copy (= mov + cmov, cost 2).
// The set model has the same optimum as the register model with unbounded registers (PRUNING.md, Lemma S).
//
// usage: enum_out N WEAK ISET KBOUND THREADS SYM [OUTFILE]
//   WEAK 1 = all weak order types, 0 = strict permutations only (sound relaxation for lower bounds)
//   ISET 0 = I0 {cmovl,cmovg}, 1 = I1 (+cmovle, cmovge)
//   SYM  1 = quotient by input relabelling S_N
// Output: "RESULT min=k" (exact minimum, if <= KBOUND) or "RESULT none<=KBOUND" (no program of length <= KBOUND).
#include "common.h"
#include <sys/stat.h>
#include <unistd.h>

static int N, KB, NT, ISET, CMAX, K; static bool WEAK, SYM, NG, HCHECK, NOH2, NOH3; static int CEX=0; // CEXACT=c: exactly c cmps (sort5 case split)
static int NW; static vector<vector<u8>> rk; static vector<int> nDistinct;
static vector<int> sw; static vector<vector<u8>> inv; static vector<vector<int>> pmap;
static vector<vector<u32>> needMask; static vector<vector<u8>> targetCol; static u32 ALLDONE;
static u8 TV; static Interner *cols, *flgs; static u32 TCOL;
static int NCOND; static const char* condName[4]={"cmovl","cmovg","cmovle","cmovge"};
static int NWW; static vector<vector<u64>> tgtEq; // unused placeholder
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
  rec(0);
  if(const char* sub=getenv("SUBSET")){ // restrict W to a subset of order types (relaxation; needs SYM=0)
    vector<int> pick; string ss(sub);
    if(ss.rfind("rand:",0)==0){ int k=atoi(ss.c_str()+5); int seed=atoi(strrchr(ss.c_str(),':')+1); mt19937 g(seed); vector<int> a(rk.size()); iota(a.begin(),a.end(),0); shuffle(a.begin(),a.end(),g); pick.assign(a.begin(),a.begin()+k); sort(pick.begin(),pick.end()); }
    else { stringstream in(ss); string t; while(getline(in,t,',')) pick.push_back(stoi(t)); }
    vector<vector<u8>> r2; vector<int> d2; for(int i: pick){ r2.push_back(rk[i]); d2.push_back(nDistinct[i]); } rk=r2; nDistinct=d2;
    printf("SUBSET:"); for(auto& r: rk){ printf(" "); for(int i=0;i<N;i++) printf("%d",r[i]); } printf("\n"); }
  NW=(int)rk.size();
  for(int w=0;w<NW;w++) if(nDistinct[w]==N){ sw.push_back(w); vector<u8> iv(N); for(int i=0;i<N;i++) iv[rk[w][i]]=(u8)i; inv.push_back(iv); }
  if(const char* sm=getenv("SUBMAX")){ // keep only strict order types where input i is the maximum (relaxation; needs SYM=0)
    int im=atoi(sm); vector<vector<u8>> r2; vector<int> d2;
    for(int w=0;w<NW;w++) if(nDistinct[w]==N && rk[w][im]==N-1){ r2.push_back(rk[w]); d2.push_back(nDistinct[w]); }
    rk=r2; nDistinct=d2; NW=(int)rk.size(); sw.clear(); inv.clear();
    for(int w=0;w<NW;w++){ sw.push_back(w); vector<u8> iv(N); for(int i=0;i<N;i++) iv[rk[w][i]]=(u8)i; inv.push_back(iv); }
    printf("SUBMAX=%d: %d order types\n",im,NW); return; }
  if(getenv("SUBSET")) return;
  map<vector<u8>,int> idx; for(int w=0;w<NW;w++) idx[rk[w]]=w;
  vector<int> sg(N); iota(sg.begin(),sg.end(),0);
  do { vector<int> m(NW); for(int w=0;w<NW;w++){ vector<u8> r2(N); for(int i=0;i<N;i++) r2[i]=rk[w][sg[i]]; m[w]=idx.at(r2); } pmap.push_back(m); }
  while(next_permutation(sg.begin(),sg.end()));
}
static void canonFlags(u8* f){ for(int w=0;w<NW;w++){ if(f[w]==0) continue; if(f[w]==2){ for(int v=0;v<NW;v++) if(f[v]) f[v]=3-f[v]; } return; } }

// a state in raw form
struct Raw { int c; const u8* col[64]; const u8* f; u32 done; u32 g=0; u32 nc=0; }; // nc = cmps used (CEXACT mode) // g = garbage-register count (NG; 7 = unbounded)

static inline u32 doneAfter(u32 done,const u8* col){
  for(int j=0;j<N;j++) if(!(done>>j&1) && memcmp(col,targetCol[j].data(),NW)==0) done|=1u<<j;
  return done; }

// ---------- heuristic (PRUNING.md rules D, H1, H2, H3) ----------
struct HS { vector<u128> keys; vector<u64> bits; };
// exact minimum number of columns of A covering target j on the strict perms (capped at cap)
struct CovCtx { u64 bits[64][2]; int keep[64]; int nk; u64 full0, full1; };
static bool covDfs(const CovCtx& C, u64 c0, u64 c1, int left){
  u64 u0=C.full0&~c0, u1=C.full1&~c1; if(!u0 && !u1) return true; if(left==0) return false;
  int p= u0? __builtin_ctzll(u0) : 64+__builtin_ctzll(u1);
  for(int q=0;q<C.nk;q++){ int x=C.keep[q]; if(!((C.bits[x][p>>6]>>(p&63))&1)) continue; if(covDfs(C,c0|C.bits[x][0],c1|C.bits[x][1],left-1)) return true; }
  return false; }
static int coverMin(const Raw& s, int j, int cap){
  int m=(int)sw.size(); CovCtx C; int nb=0;
  for(int i=0;i<s.c;i++){ u64 b[2]={0,0}; const u8* col=s.col[i]; const u8* t=targetCol[j].data();
    for(int p=0;p<m;p++) if(col[sw[p]]==t[sw[p]]) b[p>>6]|=1ULL<<(p&63);
    if(!b[0] && !b[1]) continue; C.bits[nb][0]=b[0]; C.bits[nb][1]=b[1]; nb++; }
  // drop columns whose cover set is contained in another one (does not change the minimum)
  C.nk=0;
  for(int x=0;x<nb;x++){ bool dom=false; for(int y=0;y<nb && !dom;y++){ if(x==y) continue;
      bool sub=((C.bits[x][0]&~C.bits[y][0])==0)&&((C.bits[x][1]&~C.bits[y][1])==0);
      bool eq=(C.bits[x][0]==C.bits[y][0])&&(C.bits[x][1]==C.bits[y][1]);
      if(sub && (!eq || y<x)) dom=true; }
    if(!dom) C.keep[C.nk++]=x; }
  C.full0=(m>=64)?~0ULL:((1ULL<<m)-1); C.full1=(m>64)?((m==128)?~0ULL:((1ULL<<(m-64))-1)):0;
  for(int k=1;k<cap;k++) if(covDfs(C,0,0,k)) return k;
  return cap;
}
static int heuristic(const Raw& s, HS& hs, int budget=1000){
  const vector<u32>& nm=needMask[s.done];
  for(int w=0;w<NW;w++){ u32 pres=0; for(int i=0;i<s.c;i++){ u8 v=s.col[i][w]; if(v<TV) pres|=1u<<v; } if((pres&nm[w])!=nm[w]) return -1; }
  int und=__builtin_popcount(ALLDONE&~s.done);
  if(und==0) return 0;
  int m=(int)sw.size(); hs.keys.resize(m);
  if(2+3*(s.c+N)>128){ fprintf(stderr,"class key overflow\n"); exit(5); }
  for(int p=0;p<m;p++){ int w=sw[p]; u128 k=s.f[w];
    for(int i=0;i<s.c;i++){ u8 v=s.col[i][w]; k=k*8+((v==TV)?(u128)N:(u128)inv[p][v]); }
    for(int j=0;j<N;j++) if(s.done>>j&1) k=k*8+inv[p][j];
    hs.keys[p]=k; }
  sort(hs.keys.begin(),hs.keys.end()); int best=1,run=1; for(int p=1;p<m;p++){ if(hs.keys[p]==hs.keys[p-1]){ run++; best=max(best,run);} else run=1; }
  int hc=0; while((1<<hc)<best) hc++;
  if(CEX){ int left=CEX-(int)s.nc; if(left<0 || (1<<left)<best) return -1; hc=left; }  // exactly CEX cmps in total
  int cm=NOH2? und : max(und,hc);
  // H3': target j needs a cmov sub-DAG with >= cover(j)-1 gates; all but its own creating gate are non-target gates
  // (they hold t_j(p) at some strict p, so they never equal another target), shared at best: #cmov >= und + max_j(cover_j-2)
  if(hc+cm>budget) return hc+cm;
  // only covers >= need can change the prune decision; with budget=1000 the exact value (capped at 8) is computed
  int need=budget-hc-und+3; // extra >= budget-hc-und+1  <=>  cover >= need
  int cap=min(8,max(need,3));
  int extra=0;
  if(!NOH3) for(int j=0;j<N;j++) if(!(s.done>>j&1)){ int cv=coverMin(s,j,cap); extra=max(extra,cv-2); if(hc+max(cm,und+extra)>budget) break; }
  cm=max(cm,und+extra);
  return hc+cm;
}

// ---------- canonical key: [column ids (CMAX slots, EMPTY padded), flag id, done] ----------
struct CS { vector<u8> buf, fb, bestbuf, bestf; vector<u64> hv, besth; };
static atomic<int> maxC{0};
// last key word = flag id (24 bits: shard 8 + local index 16) | done (5 bits) << 24 | garbage count (3 bits) << 29
static inline u32 packFD(u32 fid, const Raw& s){ if(fid>>24){ fprintf(stderr,"flag id overflow\n"); exit(6); } return fid|(s.done<<24)|(s.g<<29); }
static void canonical(const Raw& s, u32* key, CS& cs){
  if(s.c>CMAX){ fprintf(stderr,"CMAX exceeded\n"); exit(6); }
  { int mc=maxC.load(memory_order_relaxed); while(s.c>mc && !maxC.compare_exchange_weak(mc,s.c)); }
  int c=s.c;
  if(!SYM){
    for(int i=0;i<c;i++) key[i]=cols->intern(s.col[i]);
    sort(key,key+c); for(int i=c;i<CMAX;i++) key[i]=EMPTY;
    memcpy(cs.fb.data(),s.f,NW); canonFlags(cs.fb.data()); key[CMAX]=packFD(flgs->intern(cs.fb.data()),s); if(CEX) key[CMAX+1]=s.nc; return;
  }
  int G=(int)pmap.size(); bool have=false;
  cs.buf.resize((size_t)c*NW); cs.hv.resize(c+1);
  for(int g=0;g<G;g++){ const int* pm=pmap[g].data();
    for(int i=0;i<c;i++){ u8* b=&cs.buf[(size_t)i*NW]; const u8* src=s.col[i]; for(int w=0;w<NW;w++) b[w]=src[pm[w]]; cs.hv[i]=hashBytes(b,NW); }
    for(int w=0;w<NW;w++) cs.fb[w]=s.f[pm[w]]; canonFlags(cs.fb.data()); cs.hv[c]=hashBytes(cs.fb.data(),NW);
    sort(cs.hv.begin(),cs.hv.begin()+c);
    if(!have || lexicographical_compare(cs.hv.begin(),cs.hv.begin()+c+1,cs.besth.begin(),cs.besth.begin()+c+1)){
      have=true; cs.besth.assign(cs.hv.begin(),cs.hv.begin()+c+1); cs.bestbuf.assign(cs.buf.begin(),cs.buf.begin()+(size_t)c*NW); cs.bestf=cs.fb; }
  }
  pair<u64,u32> v[64];
  for(int i=0;i<c;i++){ const u8* b=&cs.bestbuf[(size_t)i*NW]; u64 h=hashBytes(b,NW); v[i]={h,cols->intern(b,h)}; }
  sort(v,v+c);
  for(int i=0;i<c;i++) key[i]=v[i].second; for(int i=c;i<CMAX;i++) key[i]=EMPTY;
  key[CMAX]=packFD(flgs->intern(cs.bestf.data()),s); if(CEX) key[CMAX+1]=s.nc;
}
static void decode(const u32* key, Raw& s){
  s.c=0; while(s.c<CMAX && key[s.c]!=EMPTY){ s.col[s.c]=cols->get(key[s.c]); s.c++; }
  s.f=flgs->get(key[CMAX]&0xFFFFFF); s.done=(key[CMAX]>>24)&31; s.g=key[CMAX]>>29; s.nc=CEX? key[CMAX+1] : 0;
}

// ---------- successor generation (PRUNING.md rules S, E1-E4, NG) ----------
// Op kinds: 0 cmp a,b ; 1 cmov in place (D=a in A) ; 2 cmov into a copy of D ; 3 cmov into a garbage register (D = T) ;
// 4 garbage mov (mov X,Y with X,Y never written: two garbage registers). NG=0: 3 has cost 1 and needs no garbage register.
static int LAT=0, ESC=0; // 1: reject non-lattice non-T columns (T-partial columns allowed); 2: also reject T-partial columns
static bool isLattice(const u8* col){
  bool hasT=false; for(int w=0;w<NW;w++) if(col[w]==TV){ hasT=true; break; }
  if(hasT) return LAT==1;
  if(LAT==3) return true;   // 3: reject only T-partial columns (T-elimination lemma), any non-T column allowed
  int8_t g[64]; for(int i=0;i<(1<<N);i++) g[i]=-1;
  for(size_t p=0;p<sw.size();p++){ int w=sw[p]; int idx=inv[p][col[w]]; u32 B=0; // top sets in decreasing value order
    for(int k=0;k<=N;k++){ int8_t val=(B>>idx)&1; if(g[B]<0) g[B]=val; else if(g[B]!=val) return false;
      if(k<N){ int r=N-1-k; B|=1u<<inv[p][r]; } } }
  for(u32 B=0;B<(1u<<N);B++) if(g[B]==1) for(int i=0;i<N;i++) if(!(B>>i&1) && g[B|1u<<i]==0) return false;
  return true; }
static inline u32 gInc(u32 g,int d){ if(g==7) return 7; int v=(int)g+d; return (u32)min(v,7); }
struct Op { int kind; int a, b, c; };
template<class F>
static void forOps(int c, const u8* const* colp, const u8* f, u32 done, u32 g, vector<u8>& tmp, vector<u8>& tf, F&& emit){
  // emit(kind, a, b, cond, newcol or nullptr, newflags or nullptr, newdone, newg, cost)
  bool Tok=!NG || g>=1;               // with NG, T can be read only through a garbage register
  for(int a=0;a<=c;a++) for(int b=a;b<=c;b++){
    if(a==b && a>0) continue;         // one representative of "all eq" (cmp X,X)
    if(a!=b && (a==c||b==c) && !Tok) continue;
    if(a==b) for(int w=0;w<NW;w++) tf[w]=0; else for(int w=0;w<NW;w++) tf[w]=cmpv(colp[a][w],colp[b][w]);
    emit(0,a,b,0,nullptr,tf.data(),done,g,1);
  }
  for(int d=0;d<=c;d++) for(int sr=0;sr<=c;sr++){ if(d==sr) continue;
    if(sr==c && !Tok) continue;
    if(d==c && NG && g==0) continue;  // T destination needs a garbage register (else: garbage mov first)
    const u8* D=colp[d]; const u8* S=colp[sr];
    for(int cd=0;cd<NCOND;cd++){
      bool ch=false, allT=true; for(int w=0;w<NW;w++){ u8 v=condHolds(cd,f[w])?S[w]:D[w]; tmp[w]=v; ch|=(v!=D[w]); allT&=(v==TV); }
      if(!ch || allT) continue;
      u32 gE=g;   // LAT=4: g field (unused when NG=0) counts non-lattice columns created; budget ESC
      if(LAT==4){ bool hT=false; for(int w=0;w<NW;w++) if(tmp[w]==TV){ hT=true; break; } if(hT) continue;
        LAT=2; bool lat=isLattice(tmp.data()); LAT=4; if(!lat){ if((int)g>=ESC) continue; gE=g+1; } }
      else if(LAT && !isLattice(tmp.data())) continue;   // sort5-lab: lattice-only restriction (NOT a relaxation)
      bool exists=false; for(int i=0;i<c;i++) if(memcmp(colp[i],tmp.data(),NW)==0){ exists=true; break; }
      if(exists) continue; // in place = deletion of D (dominated by parent); copy = no change
      u32 nd=doneAfter(done,tmp.data());
      if(d<c){ emit(1,d,sr,cd,tmp.data(),nullptr,nd,gE,1); emit(2,d,sr,cd,tmp.data(),nullptr,nd,gE,2); }
      else if(NG) emit(3,d,sr,cd,tmp.data(),nullptr,nd,gInc(g,-1),1);
      else emit(3,d,sr,cd,tmp.data(),nullptr,nd,gE,1);
    }
  }
  if(NG && g<7) emit(4,0,0,0,nullptr,nullptr,done,gInc(g,2),1);
}
template<class F>
static void successors(const Raw& s, vector<u8>& tmp, vector<u8>& tf, F&& cb){
  const u8* colp[65]; for(int i=0;i<s.c;i++) colp[i]=s.col[i]; colp[s.c]=cols->get(TCOL);
  Raw t;
  forOps(s.c,colp,s.f,s.done,s.g,tmp,tf,[&](int kind,int a,int b,int cd,const u8* nc,const u8* nf,u32 nd,u32 ng,int cost){
    t=s; t.done=nd; t.g=ng; if(kind==0) t.nc=s.nc+1;
    if(kind==0){ canonFlags(const_cast<u8*>(nf)); if(memcmp(s.f,nf,NW)==0) return; t.f=nf; }
    else if(kind==1) t.col[a]=nc;
    else if(kind==2||kind==3) t.col[t.c++]=nc;
    cb(t,cost,Op{kind,a,b,cd});
  });
}

// ---------- incremental heuristic (same value as heuristic(), PRUNING.md H1-H3', D) ----------
// Per expanded state: value counts per order type, index contents, class keys without flags, cover bitsets.
struct PCtx {
  int c, m, und; u32 done;
  vector<array<u8,8>> cnt;            // cnt[w][v]: #columns holding value v at w
  vector<vector<u8>> idx;             // idx[i][p]: input index held by column i at strict perm p (N = T)
  vector<u128> full; vector<vector<u128>> wo;  // class key over all columns / without column i (flags excluded)
  u64 bits[65][8][2];                 // bits[i][j]: strict perms where column i equals target j
  int extraParent;                    // max_j(cover_j-2) of the parent (columns unchanged by cmp)
  vector<u128> keys;
};
static inline u8 idxOf(const u8* col,int p){ u8 v=col[sw[p]]; return v==TV? (u8)N : inv[p][v]; }
static void colBits(const u8* col, u64 out[8][2]){ // at strict perm p, value v equals target v (rank) and no other
  int m=(int)sw.size(); for(int j=0;j<N;j++) out[j][0]=out[j][1]=0;
  for(int p=0;p<m;p++){ u8 v=col[sw[p]]; if(v<N) out[v][p>>6]|=1ULL<<(p&63); } }
static int coverMinBits(const u64 (*bl)[8][2], int nb, int j, int cap){
  int m=(int)sw.size(); CovCtx C; int k=0;
  for(int i=0;i<nb;i++){ if(!bl[i][j][0] && !bl[i][j][1]) continue; C.bits[k][0]=bl[i][j][0]; C.bits[k][1]=bl[i][j][1]; k++; }
  C.nk=0;
  for(int x=0;x<k;x++){ bool dom=false; for(int y=0;y<k && !dom;y++){ if(x==y) continue;
      bool sub=((C.bits[x][0]&~C.bits[y][0])==0)&&((C.bits[x][1]&~C.bits[y][1])==0);
      bool eq=(C.bits[x][0]==C.bits[y][0])&&(C.bits[x][1]==C.bits[y][1]);
      if(sub && (!eq || y<x)) dom=true; }
    if(!dom) C.keep[C.nk++]=x; }
  C.full0=(m>=64)?~0ULL:((1ULL<<m)-1); C.full1=(m>64)?((m==128)?~0ULL:((1ULL<<(m-64))-1)):0;
  for(int q=1;q<cap;q++) if(covDfs(C,0,0,q)) return q;
  return cap;
}
static int maxClass(vector<u128>& keys){ // largest number of equal keys (exact; open addressing)
  u128 tk[256]; int tc[256]; bool used[256]={false}; int best=1;
  for(u128 k: keys){ u64 h=mix64((u64)k ^ mix64((u64)(k>>64))); int q=(int)(h&255);
    while(used[q] && tk[q]!=k) q=(q+1)&255;
    if(!used[q]){ used[q]=true; tk[q]=k; tc[q]=1; } else { tc[q]++; if(tc[q]>best) best=tc[q]; } }
  return best; }
static void buildPCtx(const Raw& s, PCtx& P){
  P.c=s.c; P.m=(int)sw.size(); P.done=s.done; P.und=__builtin_popcount(ALLDONE&~s.done);
  P.cnt.assign(NW,array<u8,8>{}); for(int i=0;i<s.c;i++) for(int w=0;w<NW;w++){ u8 v=s.col[i][w]; if(v<TV) P.cnt[w][v]++; }
  P.idx.assign(s.c,vector<u8>(P.m)); for(int i=0;i<s.c;i++) for(int p=0;p<P.m;p++) P.idx[i][p]=idxOf(s.col[i],p);
  if(2+3*(s.c+1+N)>128){ fprintf(stderr,"class key overflow\n"); exit(5); }
  P.full.assign(P.m,0); P.wo.assign(s.c,vector<u128>(P.m,0));
  for(int p=0;p<P.m;p++){ u128 base=0; for(int j=0;j<N;j++) if(s.done>>j&1) base=base*8+inv[p][j];
    u128 k=base; for(int i=0;i<s.c;i++) k=k*8+P.idx[i][p]; P.full[p]=k;
    for(int x=0;x<s.c;x++){ u128 kk=base; for(int i=0;i<s.c;i++) if(i!=x) kk=kk*8+P.idx[i][p]; P.wo[x][p]=kk; } }
  for(int i=0;i<s.c;i++) colBits(s.col[i],P.bits[i]);
  P.extraParent=0;
  if(!NOH3) for(int j=0;j<N;j++) if(!(s.done>>j&1)) P.extraParent=max(P.extraParent,coverMinBits(P.bits,s.c,j,8)-2);
  P.keys.resize(P.m);
}
// h of a successor. kind 0: flags nf; 1: column i replaced by M; 2/3: M appended; 4: unchanged. -1 = dead.
static int hInc(const Raw& s, PCtx& P, int kind, int i, const u8* M, const u8* nf, u32 nd, int budget){
  int und=__builtin_popcount(ALLDONE&~nd); if(und==0) return 0;
  const u8* f= kind==0? nf : s.f;
  if(kind==1){ const vector<u32>& nm=needMask[nd]; const u8* D=s.col[i];
    for(int w=0;w<NW;w++){ u8 dv=D[w]; if(M[w]!=dv && dv<TV && ((nm[w]>>dv)&1) && P.cnt[w][dv]==1) return -1; } }
  int m=P.m;
  for(int p=0;p<m;p++){ u128 k;
    if(kind==1) k=P.wo[i][p]*8+idxOf(M,p); else if(kind==2||kind==3) k=P.full[p]*8+idxOf(M,p); else k=P.full[p]*8;
    P.keys[p]=k*4+f[sw[p]]; }
  int best=maxClass(P.keys); int hc=0; while((1<<hc)<best) hc++;
  if(CEX){ int left=CEX-(int)s.nc-(kind==0?1:0); if(left<0 || (1<<left)<best) return -1; hc=left; }
  int cm=NOH2? und : max(und,hc); if(hc+cm>budget) return hc+cm;
  int extra=0;
  if(NOH3) extra=0; else if(kind==0||kind==4) extra=P.extraParent;
  else {
    int need=budget-hc-und+3; int cap=min(8,max(need,3));
    u64 nb[8][2]; colBits(M,nb);
    static thread_local u64 bl[65][8][2]; int c=P.c;
    memcpy(bl,P.bits,sizeof(u64)*16*c);
    int nbc=c; if(kind==1) memcpy(bl[i],nb,sizeof(nb)); else { memcpy(bl[c],nb,sizeof(nb)); nbc=c+1; }
    for(int j=0;j<N;j++) if(!(nd>>j&1)){ int cv=coverMinBits(bl,nbc,j,cap); extra=max(extra,cv-2); if(hc+max(cm,und+extra)>budget) break; }
  }
  cm=max(cm,und+extra);
  return hc+cm;
}
template<class F>
static void successorsH(const Raw& s, PCtx& P, int budget1, vector<u8>& tmp, vector<u8>& tf, F&& cb){
  // budget1 = KB - g: successors with cost + h > budget1 are dropped
  buildPCtx(s,P);
  const u8* colp[65]; for(int i=0;i<s.c;i++) colp[i]=s.col[i]; colp[s.c]=cols->get(TCOL);
  Raw t;
  forOps(s.c,colp,s.f,s.done,s.g,tmp,tf,[&](int kind,int a,int b,int cd,const u8* nc,const u8* nf,u32 nd,u32 ng,int cost){
    if(cost>budget1) return;
    if(kind==0){ canonFlags(const_cast<u8*>(nf)); if(memcmp(s.f,nf,NW)==0) return; }
    int h=hInc(s,P,kind,a,nc,nf,nd,budget1-cost); if(h<0 || cost+h>budget1) return;
    t=s; t.done=nd; t.g=ng; if(kind==0) t.nc=s.nc+1;
    if(kind==0) t.f=nf; else if(kind==1) t.col[a]=nc; else if(kind==2||kind==3) t.col[t.c++]=nc;
    cb(t,cost,h);
  });
}

// ---------- recovery: replay in the set model with concrete register names ----------
struct Conc { vector<vector<u8>> col; vector<string> reg; vector<u8> f; u32 done; u32 g=0; vector<string> gh; };
static Raw rawOf(const Conc& s){ Raw r; r.c=(int)s.col.size(); for(int i=0;i<r.c;i++) r.col[i]=s.col[i].data(); r.f=s.f.data(); r.done=s.done; r.g=s.g; return r; }
static vector<string> recover(const vector<vector<u32>>& chain, const vector<int>& cost, CS& cs){
  Conc s; s.f.assign(NW,0); s.done=0;
  for(int i=0;i<N;i++){ vector<u8> col(NW); for(int w=0;w<NW;w++) col[w]=rk[w][i]; s.col.push_back(col); s.reg.push_back("P"+to_string(i)); }
  int nextS=0; vector<string> prog; vector<u32> kk(K); vector<u8> tmp(NW), tf(NW), Tc(NW,TV);
  { Raw r=rawOf(s); canonical(r,kk.data(),cs); if(memcmp(kk.data(),chain[0].data(),K*4)){ fprintf(stderr,"root mismatch\n"); exit(4);} }
  for(size_t st=1;st<chain.size();st++){
    int c=(int)s.col.size(); const u8* colp[65]; for(int i=0;i<c;i++) colp[i]=s.col[i].data(); colp[c]=Tc.data();
    // name of a T register to read: a garbage register (NG) or a never-written one
    string Tname= !s.gh.empty()? s.gh.back() : "S"+to_string(nextS+2);
    auto rn=[&](int i){ return i<c? s.reg[i] : Tname; };
    bool ok=false; Conc best; vector<string> lines;
    forOps(c,colp,s.f.data(),s.done,s.g,tmp,tf,[&](int kind,int a,int b,int cd,const u8* nc,const u8* nf,u32 nd,u32 ng,int cst){
      if(ok || cst!=cost[st]) return;
      // the concrete op: cmp keeps real polarity (both orders tried)
      for(int ord=0;ord<(kind==0?2:1) && !ok;ord++){
        Conc t=s; t.done=nd; t.g=ng; vector<string> L; string dst;
        if(kind==0){ int x=ord?b:a, y=ord?a:b; if(a==b){ for(int w=0;w<NW;w++) t.f[w]=0; L.push_back("cmp "+rn(0)+", "+rn(0)); }
          else { for(int w=0;w<NW;w++) t.f[w]=cmpv(colp[x][w],colp[y][w]); L.push_back("cmp "+rn(x)+", "+rn(y)); } }
        else if(kind==1){ t.col[a].assign(nc,nc+NW); dst=s.reg[a]; L.push_back(string(condName[cd])+" "+dst+", "+rn(b)); }
        else if(kind==2){ dst="S"+to_string(nextS); t.col.push_back(vector<u8>(nc,nc+NW)); t.reg.push_back(dst);
          L.push_back("mov "+dst+", "+rn(a)); L.push_back(string(condName[cd])+" "+dst+", "+rn(b)); }
        else if(kind==3){ if(NG){ dst=t.gh.back(); t.gh.pop_back(); } else dst="S"+to_string(nextS);
          t.col.push_back(vector<u8>(nc,nc+NW)); t.reg.push_back(dst); L.push_back(string(condName[cd])+" "+dst+", "+rn(b)); }
        else { string x="S"+to_string(nextS), y="S"+to_string(nextS+1); L.push_back("mov "+x+", "+y); t.gh.push_back(y); t.gh.push_back(x); }
        Raw r=rawOf(t); canonical(r,kk.data(),cs);
        if(!memcmp(kk.data(),chain[st].data(),K*4)){
          for(int j=0;j<N;j++) if((t.done>>j&1) && !(s.done>>j&1)) L.push_back("out "+to_string(j)+", "+dst);
          ok=true; best=t; lines=L; }
      }
    });
    if(!ok){ fprintf(stderr,"recover: step %zu failed\n",st); exit(4); }
    for(auto& l: lines){ prog.push_back(l); for(int q=nextS;q<nextS+3;q++) if(l.find("S"+to_string(q)+",")!=string::npos || (l.size()>=3 && l.substr(l.rfind(' ')+1)=="S"+to_string(q))) nextS=max(nextS,q+1); }
    s=best;
  }
  return prog;
}

int main(int argc,char** argv){
  if(argc<7){ fprintf(stderr,"usage: enum_out N WEAK ISET KBOUND THREADS SYM [OUTFILE]\n"); return 1; }
  N=atoi(argv[1]); WEAK=atoi(argv[2]); ISET=atoi(argv[3]); KB=atoi(argv[4]); NT=atoi(argv[5]); SYM=atoi(argv[6]);
  string outp=argc>7?argv[7]:""; NG=getenv("NG")&&atoi(getenv("NG")); HCHECK=getenv("HCHECK")&&atoi(getenv("HCHECK")); NOH2=getenv("NOH2")&&atoi(getenv("NOH2")); NOH3=getenv("NOH3")&&atoi(getenv("NOH3")); LAT=getenv("LAT")?atoi(getenv("LAT")):0; ESC=getenv("ESC")?atoi(getenv("ESC")):0; if(LAT==4&&NG){fprintf(stderr,"LAT=4 needs NG=0\n");return 1;}
  TV=(u8)N; NCOND=ISET?4:2; ALLDONE=(1u<<N)-1; CMAX=min(N+KB,60); if(getenv("CMAX")) CMAX=min(CMAX,atoi(getenv("CMAX"))); CEX=getenv("CEXACT")?atoi(getenv("CEXACT")):0; K=CMAX+1+(CEX?1:0); // CMAX exceeded => abort (exit 6), never silent
  if(getenv("VLOAD")) KS_LOAD=atoi(getenv("VLOAD"));
  if(N>5){ fprintf(stderr,"N<=5 (done mask packed in 5 bits)\n"); return 1; }
  omp_set_num_threads(NT);
  genOrders();
  cols=new Interner(NW); flgs=new Interner(NW);
  { vector<u8> t(NW,TV); TCOL=cols->intern(t.data()); }
  targetCol.assign(N,vector<u8>(NW));
  for(int w=0;w<NW;w++){ vector<u8> s=rk[w]; sort(s.begin(),s.end()); for(int j=0;j<N;j++) targetCol[j][w]=s[j]; }
  needMask.assign(1u<<N,vector<u32>(NW,0));
  for(u32 dn=0;dn<(1u<<N);dn++) for(int w=0;w<NW;w++) for(int j=0;j<N;j++) if(!(dn>>j&1)) needMask[dn][w]|=1u<<targetCol[j][w];
  printf("enum_out: NG=%d N=%d WEAK=%d ISET=I%d KBOUND=%d SYM=%d orders=%d strict=%zu threads=%d (R unbounded, model out, set semantics)\n",
         (int)NG,N,(int)WEAK,ISET,KB,(int)SYM,NW,sw.size(),NT);
  if(const char* tf=getenv("TRACE")){ // admissibility check of h along a given register program (PRUNING.md)
    ifstream in(tf); string line; map<string,vector<u8>> reg; set<string> written; vector<u8> f(NW,0); u32 done=0;
    vector<pair<string,pair<string,string>>> prog;
    while(getline(in,line)){ auto h=line.find('#'); if(h!=string::npos) line=line.substr(0,h);
      stringstream ss(line); string op,a,b; if(!(ss>>op)) continue; ss>>a>>b; if(!a.empty()&&a.back()==',') a.pop_back();
      if(op=="out") continue; prog.push_back({op,{a,b}}); }
    for(int i=0;i<N;i++){ vector<u8> col(NW); for(int w=0;w<NW;w++) col[w]=rk[w][i]; reg["P"+to_string(i)]=col; written.insert("P"+to_string(i)); }
    auto get=[&](const string& r)->vector<u8>{ auto it=reg.find(r); return it==reg.end()? vector<u8>(NW,TV) : it->second; };
    int L=(int)prog.size(), bad=0; HS hs;
    for(int t=0;t<=L;t++){
      // set-model state = distinct non-T register columns
      vector<vector<u8>> cl; int nonT=0, wT=0;
      for(auto& kv: reg){ bool allT=true; for(u8 v: kv.second) if(v!=TV) allT=false; if(allT){ if(written.count(kv.first)) wT++; continue; } nonT++;
        bool dup=false; for(auto& c: cl) if(c==kv.second) dup=true; if(!dup) cl.push_back(kv.second); }
      Raw r; r.c=(int)cl.size(); for(int i=0;i<r.c;i++) r.col[i]=cl[i].data(); r.f=f.data(); r.done=done;
      int phi=nonT-r.c+wT; int h=heuristic(r,hs);
      bool ok=(h>=0 && h<=L-t+phi); if(!ok) bad++;
      printf("TRACE t=%d h=%d rem=%d phi=%d %s\n",t,h,L-t,phi,ok?"ok":"VIOLATION");
      if(t==L) break;
      auto& in_=prog[t]; string op=in_.first, a=in_.second.first, b=in_.second.second;
      vector<u8> A=get(a), B=get(b);
      if(op=="cmp"){ for(int w=0;w<NW;w++) f[w]=cmpv(A[w],B[w]); }
      else if(op=="mov"){ reg[a]=B; written.insert(a); }
      else { int cd=-1; for(int c=0;c<4;c++) if(op==condName[c]) cd=c; if(cd<0||cd>=NCOND){ fprintf(stderr,"bad op %s\n",op.c_str()); return 2; }
        for(int w=0;w<NW;w++) if(condHolds(cd,f[w])) A[w]=B[w]; reg[a]=A; written.insert(a); }
      for(auto& kv: reg) done=doneAfter(done,kv.second.data());
    }
    printf("TRACE done=%u (all=%u) violations=%d\n",done,ALLDONE,bad); return bad?1:0; }
  CS cs0; cs0.fb.resize(NW);
  Conc s0; s0.f.assign(NW,0); s0.done=0;
  for(int i=0;i<N;i++){ vector<u8> col(NW); for(int w=0;w<NW;w++) col[w]=rk[w][i]; s0.col.push_back(col); }
  if(const char* pf=getenv("PREFIX")){ // start from the state after the first t instructions of a register program (FILE:t)
    string ps(pf); size_t cpos=ps.rfind(':'); string fn=ps.substr(0,cpos); int tmax=atoi(ps.c_str()+cpos+1);
    ifstream in(fn); string line; map<string,vector<u8>> reg; vector<u8> f(NW,0); int t=0;
    for(int i=0;i<N;i++) reg["P"+to_string(i)]=s0.col[i];
    while(t<tmax && getline(in,line)){ auto hh=line.find('#'); if(hh!=string::npos) line=line.substr(0,hh);
      stringstream ss(line); string op,a,b; if(!(ss>>op)) continue; ss>>a>>b; if(!a.empty()&&a.back()==',') a.pop_back(); if(op=="out") continue;
      auto get=[&](const string& r)->vector<u8>{ auto it=reg.find(r); if(it==reg.end()){ fprintf(stderr,"PREFIX reads unwritten %s\n",r.c_str()); exit(2);} return it->second; };
      if(op=="cmp"){ auto A=get(a), B=get(b); for(int w=0;w<NW;w++) f[w]=cmpv(A[w],B[w]); }
      else if(op=="mov") reg[a]=get(b);
      else { int cd=-1; for(int c=0;c<4;c++) if(op==condName[c]) cd=c; auto A=get(a), B=get(b); for(int w=0;w<NW;w++) if(condHolds(cd,f[w])) A[w]=B[w]; reg[a]=A; }
      for(auto& kv: reg) s0.done=doneAfter(s0.done,kv.second.data());
      t++; }
    s0.col.clear(); for(auto& kv: reg){ bool allT=true, dup=false; for(u8 v: kv.second) if(v!=TV) allT=false; for(auto& c: s0.col) if(c==kv.second) dup=true; if(!allT && !dup) s0.col.push_back(kv.second); }
    s0.f=f; printf("PREFIX %s: %d instructions, %zu columns, done=%u\n",fn.c_str(),t,s0.col.size(),s0.done); }
  for(auto& c: s0.col) s0.done=doneAfter(s0.done,c.data());   // SUBMAX: an input column can already be an output
  vector<u32> root(K); { Raw r=rawOf(s0); canonical(r,root.data(),cs0); HS hs; int h=heuristic(r,hs); printf("h(root)=%d\n",h); if(h>KB){ printf("RESULT none<=%d (root pruned)\n",KB); return 0; } }

  // stored keys are packed: 3 bytes per column id (0xFFFFFF = empty slot), 4 bytes for the flag/done/garbage word
  const bool P3=getenv("PACK3")&&atoi(getenv("PACK3"));   // 3-byte column ids (aborts if > 2^24 columns); default 4 bytes
  const int PK=P3? (3*CMAX+4+3)/4 : K;
  auto pack=[&](const u32* k, u32* out){ if(!P3){ memcpy(out,k,K*4); return; } u8* o=(u8*)out; memset(out,0,PK*4);
    for(int i=0;i<CMAX;i++){ u32 v=k[i]; if(v==EMPTY) v=0xFFFFFF; else if(v>=0xFFFFFF){ fprintf(stderr,"column id overflow (>24 bits)\n"); exit(6); }
      o[3*i]=(u8)v; o[3*i+1]=(u8)(v>>8); o[3*i+2]=(u8)(v>>16); }
    memcpy(o+3*CMAX,&k[CMAX],4); };
  auto unpack=[&](const u32* in, u32* k){ if(!P3){ memcpy(k,in,K*4); return; } const u8* o=(const u8*)in;
    for(int i=0;i<CMAX;i++){ u32 v=o[3*i]|((u32)o[3*i+1]<<8)|((u32)o[3*i+2]<<16); k[i]=(v==0xFFFFFF)?EMPTY:v; }
    memcpy(&k[CMAX],o+3*CMAX,4); };
  const int NB=1024; const bool REC=!getenv("NOREC"); const int S=PK+(REC?2:0);  // candidate = packed key (+ parent)
  if(const char* EXD=getenv("EXTDIR")){  // ---------- disk-based layered BFS (low RSS, resumable per depth) ----------
    string D=EXD; auto P=[&](const string& x){ return D+"/"+x; };
    for(string x: {string(""),string("/v"),string("/c2"),string("/cand"),string("/L"),string("/cert")}) mkdir((D+x).c_str(),0755);
    const int W=PK; const size_t RB=(size_t)W*4;
    auto rd=[&](const string& f){ vector<u32> v; FILE* fi=fopen(f.c_str(),"rb"); if(!fi) return v; fseek(fi,0,SEEK_END); long n=ftell(fi); fseek(fi,0,SEEK_SET);
      v.resize(n/4); if(n && fread(v.data(),1,n,fi)!=(size_t)n){ fprintf(stderr,"read error %s\n",f.c_str()); exit(9); } fclose(fi); return v; };
    auto wr=[&](const string& f, const void* d, size_t n){ FILE* fo=fopen(f.c_str(),"wb"); if(!fo){ fprintf(stderr,"open %s failed\n",f.c_str()); exit(9); }
      if(n && fwrite(d,1,n,fo)!=n){ fprintf(stderr,"write error %s\n",f.c_str()); exit(9); } fclose(fo); };
    auto app=[&](const string& f, const void* d, size_t n){ if(!n) return; FILE* fo=fopen(f.c_str(),"ab"); if(!fo||fwrite(d,1,n,fo)!=n){ fprintf(stderr,"append error %s\n",f.c_str()); exit(9); } fclose(fo); };
    auto sortUnique=[&](vector<u32>& v){ size_t n=v.size()/W; vector<u32> ix(n); iota(ix.begin(),ix.end(),0);
      sort(ix.begin(),ix.end(),[&](u32 a,u32 b){ return memcmp(&v[(size_t)a*W],&v[(size_t)b*W],RB)<0; });
      vector<u32> o; o.reserve(v.size()); for(size_t i=0;i<n;i++){ const u32* k=&v[(size_t)ix[i]*W]; if(i && memcmp(k,&o[o.size()-W],RB)==0) continue; o.insert(o.end(),k,k+W); }
      v.swap(o); };
    auto diff=[&](const vector<u32>& a, const vector<u32>& b){ vector<u32> o; size_t i=0,j=0,na=a.size()/W,nb=b.size()/W;
      while(i<na){ if(j>=nb){ o.insert(o.end(),&a[i*W],&a[i*W]+W); i++; continue; } int c=memcmp(&a[i*W],&b[j*W],RB);
        if(c<0){ o.insert(o.end(),&a[i*W],&a[i*W]+W); i++; } else if(c>0) j++; else { i++; j++; } } return o; };
    auto merge2=[&](const vector<u32>& a, const vector<u32>& b){ vector<u32> o; o.reserve(a.size()+b.size()); size_t i=0,j=0,na=a.size()/W,nb=b.size()/W;
      while(i<na||j<nb){ if(j>=nb || (i<na && memcmp(&a[i*W],&b[j*W],RB)<0)){ o.insert(o.end(),&a[i*W],&a[i*W]+W); i++; } else { o.insert(o.end(),&b[j*W],&b[j*W]+W); j++; } } return o; };
    auto certRecs=[&](const vector<u32>& keys, int g){ vector<u8> o; vector<u32> uk(K);
      for(size_t x=0;x+W<=keys.size();x+=W){ unpack(&keys[x],uk.data()); int c=0; while(c<CMAX && uk[c]!=EMPTY) c++;
        u32 w=uk[CMAX]; u8 hd[8]={(u8)g,(u8)((w>>24)&31),(u8)(w>>29),(u8)c,0,0,0,0}; u32 fid=w&0xFFFFFF; memcpy(hd+4,&fid,4);
        o.insert(o.end(),hd,hd+8); o.insert(o.end(),(u8*)uk.data(),(u8*)uk.data()+4*c); } return o; };
    auto Lf=[&](int d,int b){ return P("L/"+to_string(d)+"_"+to_string(b)); };
    auto Cf=[&](int d,int b){ return P("cert/"+to_string(d)+"_"+to_string(b)); };
    auto dumpInterners=[&](){ FILE* f=fopen(P("cols.bin.tmp").c_str(),"wb"); cols->dump(f); fclose(f); rename(P("cols.bin.tmp").c_str(),P("cols.bin").c_str());
      f=fopen(P("flags.bin.tmp").c_str(),"wb"); flgs->dump(f); fclose(f); rename(P("flags.bin.tmp").c_str(),P("flags.bin").c_str()); };
    int d0=0; u64 total=0;
    { FILE* m=fopen(P("meta").c_str(),"r");
      if(m){ if(fscanf(m,"%d %llu",&d0,(unsigned long long*)&total)!=2){ fprintf(stderr,"bad meta\n"); exit(9); } fclose(m);
        if(FILE* fz=fopen(P("final").c_str(),"r")){ int dd; if(fscanf(fz,"%d",&dd)==1 && dd==d0+1){ // finish the renames of an interrupted commit
            for(int b=0;b<NB;b++) for(string x: {string("v/")+to_string(b), string("c2/")+to_string(b)}) { string a=P(x)+".new"; if(access(a.c_str(),F_OK)==0) rename(a.c_str(),P(x).c_str()); }
            for(int b=0;b<NB;b++){ string a=Lf(dd,b)+".new"; if(access(a.c_str(),F_OK)==0) rename(a.c_str(),Lf(dd,b).c_str()); a=Cf(dd,b)+".new"; if(access(a.c_str(),F_OK)==0) rename(a.c_str(),Cf(dd,b).c_str()); }
            u64 t2=0; for(int b=0;b<NB;b++){ FILE* fi=fopen(Lf(dd,b).c_str(),"rb"); if(fi){ fseek(fi,0,SEEK_END); t2+=ftell(fi)/RB; fclose(fi);} }
            if(FILE* fc=fopen(P("cols.bin.new").c_str(),"r")){ fclose(fc); rename(P("cols.bin.new").c_str(),P("cols.bin").c_str()); rename(P("flags.bin.new").c_str(),P("flags.bin").c_str()); }
            d0=dd; total+=t2; m=fopen(P("meta.tmp").c_str(),"w"); fprintf(m,"%d %llu\n",d0,(unsigned long long)total); fclose(m); rename(P("meta.tmp").c_str(),P("meta").c_str()); }
          fclose(fz); remove(P("final").c_str()); }
        FILE* f=fopen(P("cols.bin").c_str(),"rb"); cols->load(f); fclose(f); f=fopen(P("flags.bin").c_str(),"rb"); flgs->load(f); fclose(f);
        printf("EXT resume at depth %d (total %llu)\n",d0,(unsigned long long)total); }
      else { vector<u32> pr(W); pack(root.data(),pr.data()); int b=(int)(hashWords(pr.data(),W)>>54);
        wr(Lf(0,b),pr.data(),RB); wr(P("v/"+to_string(b)),pr.data(),RB); auto cr=certRecs(pr,0); wr(Cf(0,b),cr.data(),cr.size());
        total=1; dumpInterners(); m=fopen(P("meta").c_str(),"w"); fprintf(m,"0 1\n"); fclose(m); } }
    for(int b=0;b<NB;b++){ remove(P("cand/1_"+to_string(b)).c_str()); remove(P("cand/2_"+to_string(b)).c_str()); }
    auto t0=chrono::steady_clock::now(); int found=-1;
    const u64 CH=getenv("CHUNK")? strtoull(getenv("CHUNK"),0,10) : 500000ULL;
    for(int d=d0; d<KB && found<0; d++){
      // expansion of layer d, chunk by chunk; candidates appended to per-bucket files
      vector<u32> chunk; int bnext=0;
      while(bnext<NB){
        chunk.clear(); while(bnext<NB && chunk.size()/W<CH){ auto v=rd(Lf(d,bnext)); chunk.insert(chunk.end(),v.begin(),v.end()); bnext++; }
        u64 M=chunk.size()/W; if(!M) continue;
        vector<vector<vector<u32>>> c1(NT, vector<vector<u32>>(NB)), c2(NT, vector<vector<u32>>(NB));
        #pragma omp parallel
        { int th=omp_get_thread_num(); CS cs; cs.fb.resize(NW); vector<u8> tmp(NW), tf(NW); Raw s; vector<u32> nk(K), uk(K), pk(W); PCtx PC;
          #pragma omp for schedule(dynamic,16)
          for(u64 i=0;i<M;i++){ unpack(&chunk[i*W],uk.data()); decode(uk.data(),s);
            successorsH(s,PC,KB-d,tmp,tf,[&](const Raw& t,int cost,int){ canonical(t,nk.data(),cs); pack(nk.data(),pk.data());
              auto& bv=(cost==1?c1:c2)[th][hashWords(pk.data(),W)>>54]; bv.insert(bv.end(),pk.begin(),pk.end()); }); } }
        #pragma omp parallel for schedule(dynamic,4)
        for(int b=0;b<NB;b++){ for(int x=0;x<2;x++){ vector<u32> all; for(int th=0;th<NT;th++){ auto& v=(x?c2:c1)[th][b]; all.insert(all.end(),v.begin(),v.end()); vector<u32>().swap(v); }
            sortUnique(all); app(P("cand/"+to_string(x+1)+"_"+to_string(b)),all.data(),all.size()*4); } }
      }
      for(int b=0;b<NB;b++){ string sb=to_string(b); remove((P("v/"+sb)+".new").c_str()); remove((P("c2/"+sb)+".new").c_str()); remove((Lf(d+1,b)+".new").c_str()); remove((Cf(d+1,b)+".new").c_str()); }
      // finalize layer d+1 bucket by bucket
      atomic<u64> tot{0}; atomic<int> goal{0}; u64 candBytes=0;
      for(int b=0;b<NB;b++) for(int x=1;x<=2;x++){ FILE* fi=fopen(P("cand/"+to_string(x)+"_"+to_string(b)).c_str(),"rb"); if(fi){ fseek(fi,0,SEEK_END); candBytes+=ftell(fi); fclose(fi);} }
      #pragma omp parallel for schedule(dynamic,1)
      for(int b=0;b<NB;b++){
        string sb=to_string(b); auto A=rd(P("cand/1_"+sb)); auto CR=rd(P("c2/"+sb)); auto B=rd(P("cand/2_"+sb));
        if(A.empty() && CR.empty() && B.empty()){ wr(P("c2/"+sb)+".new",nullptr,0); wr(Lf(d+1,b)+".new",nullptr,0); wr(Cf(d+1,b)+".new",nullptr,0); continue; }
        auto V=rd(P("v/"+sb));
        A.insert(A.end(),CR.begin(),CR.end()); vector<u32>().swap(CR); sortUnique(A); auto NEW1=diff(A,V); vector<u32>().swap(A);
        sortUnique(B); auto B2=diff(B,V); vector<u32>().swap(B); auto NEWC2=diff(B2,NEW1); vector<u32>().swap(B2);
        if(!NEW1.empty()){ auto Vn=merge2(V,NEW1); vector<u32>().swap(V); wr(P("v/"+sb)+".new",Vn.data(),Vn.size()*4); }  // unchanged bucket: no rewrite
        wr(P("c2/"+sb)+".new",NEWC2.data(),NEWC2.size()*4);
        wr(Lf(d+1,b)+".new",NEW1.data(),NEW1.size()*4);
        auto cr=certRecs(NEW1,d+1); wr(Cf(d+1,b)+".new",cr.data(),cr.size());
        vector<u32> uk(K); for(size_t x=0;x+W<=NEW1.size();x+=W){ unpack(&NEW1[x],uk.data()); if(((uk[CMAX]>>24)&31)==ALLDONE) goal=1; }
        tot+=NEW1.size()/W; }
      if(goal){ found=d+1; printf("depth %d: goal state found\n",d+1); break; }
      // commit: marker, renames, interners, meta
      { FILE* fz=fopen(P("final").c_str(),"w"); fprintf(fz,"%d\n",d+1); fclose(fz); }
      { FILE* f=fopen(P("cols.bin.new").c_str(),"wb"); cols->dump(f); fclose(f); f=fopen(P("flags.bin.new").c_str(),"wb"); flgs->dump(f); fclose(f); }
      for(int b=0;b<NB;b++){ string sb=to_string(b); rename((P("v/"+sb)+".new").c_str(),P("v/"+sb).c_str()); rename((P("c2/"+sb)+".new").c_str(),P("c2/"+sb).c_str());
        rename((Lf(d+1,b)+".new").c_str(),Lf(d+1,b).c_str()); rename((Cf(d+1,b)+".new").c_str(),Cf(d+1,b).c_str());
        remove(P("cand/1_"+sb).c_str()); remove(P("cand/2_"+sb).c_str()); }
      rename(P("cols.bin.new").c_str(),P("cols.bin").c_str()); rename(P("flags.bin.new").c_str(),P("flags.bin").c_str());
      total+=tot; { FILE* m=fopen(P("meta.tmp").c_str(),"w"); fprintf(m,"%d %llu\n",d+1,(unsigned long long)total); fclose(m); rename(P("meta.tmp").c_str(),P("meta").c_str()); }
      remove(P("final").c_str());
      for(int b=0;b<NB;b++) remove(Lf(d,b).c_str());
      double el=chrono::duration<double>(chrono::steady_clock::now()-t0).count();
      printf("depth %d: %llu new states (total=%llu cols=%zu flags=%zu maxcols=%d cand=%.1fGB) %.1fs\n",d+1,(unsigned long long)tot.load(),(unsigned long long)total,cols->size(),flgs->size(),maxC.load(),candBytes/1e9,el); fflush(stdout);
    }
    if(found>=0){ printf("RESULT min=%d (EXT mode: no program recovery)\n",found); return 0; }
    printf("RESULT none<=%d  (no M_out program of length <= %d; N=%d R=unbounded I%d WEAK=%d)\n",KB,KB,N,ISET,(int)WEAK);
    if(const char* CO=getenv("CERTOUT")){ // final text certificate (format v1) from the per-depth binary records
      if(WEAK){ fprintf(stderr,"CERTOUT needs WEAK=0\n"); return 2; }
      string rules=string("W,P,")+(SYM?"G,":"")+"S,D,H1,und"+(NOH2?"":",H2")+(NOH3?"":",H3p")+",E"+(NG?",NG":"");
      vector<u64> off(Interner::SH+1,0); int tsi=TCOL&255; u32 tli=TCOL>>8;
      for(int si=0;si<Interner::SH;si++) off[si+1]=off[si]+cols->sh[si].cnt-(si==tsi?1:0);
      auto dense=[&](u32 id)->u64{ int si=id&255; u32 li=id>>8; return off[si]+li-((si==tsi && li>tli)?1:0); };
      FILE* fo=fopen(CO,"w");
      string head="cert n="+to_string(N)+" W="+to_string(NW)+" iset=I"+to_string(ISET)+" K="+to_string(KB)+" model=out-set ng="+to_string((int)NG)+" rules="+rules+"\nW";
      for(int w=0;w<NW;w++){ head+=' '; for(int i=0;i<N;i++) head+=(char)('0'+rk[w][i]); }
      head+="\nC "+to_string(off[Interner::SH])+"\n"; fwrite(head.data(),1,head.size(),fo);
      { string cb; u64 x=0; for(int si=0;si<Interner::SH;si++) for(u32 li=0;li<cols->sh[si].cnt;li++){ u32 id=(li<<8)|(u32)si; if(id==TCOL) continue;
          cb+=to_string(x++)+" "; const u8* c=cols->get(id); for(int w=0;w<NW;w++) cb+=(char)('0'+c[w]); cb+='\n';
          if(cb.size()>(1u<<24)){ fwrite(cb.data(),1,cb.size(),fo); cb.clear(); } } fwrite(cb.data(),1,cb.size(),fo); }
      string sh="S "+to_string(total)+"\n"; fwrite(sh.data(),1,sh.size(),fo); u64 nrec=0;
      for(int g=0;g<=KB;g++){ for(int b0=0;b0<NB;b0+=NT){ int nb=min(NT,NB-b0); vector<string> outs(nb);
          #pragma omp parallel for schedule(dynamic,1)
          for(int q=0;q<nb;q++){ auto v=rd(Cf(g,b0+q)); const u8* p=(const u8*)v.data(); size_t len=v.size()*4, x=0; string& o=outs[q]; char tb[32];
            while(x+8<=len){ const u8* r=p+x; u32 fid; memcpy(&fid,r+4,4); const u8* f=flgs->get(fid);
              snprintf(tb,sizeof tb,"%u ",r[0]); o+=tb; for(int w=0;w<NW;w++) o+=(char)('0'+f[w]);
              snprintf(tb,sizeof tb," %u %u",r[1],NG?r[2]:0); o+=tb;
              for(int i=0;i<r[3];i++){ u32 id; memcpy(&id,r+8+4*i,4); snprintf(tb,sizeof tb," %llu",(unsigned long long)dense(id)); o+=tb; }
              o+='\n'; x+=8+4*(size_t)r[3]; } }
          for(int q=0;q<nb;q++){ fwrite(outs[q].data(),1,outs[q].size(),fo); nrec+=count(outs[q].begin(),outs[q].end(),'\n'); } } }
      fclose(fo);
      if(nrec!=total){ fprintf(stderr,"record count mismatch %llu %llu\n",(unsigned long long)nrec,(unsigned long long)total); return 8; }
      printf("CERTOUT %s: %llu states, %llu columns (next: certend.sh, then pigz)\n",CO,(unsigned long long)total,(unsigned long long)off[Interner::SH]); }
    return 0;
  }
  u64 vcap=getenv("VCAP")? strtoull(getenv("VCAP"),0,10) : (1ULL<<10); // initial slots per bucket (power of 2)
  vector<KeySet> visited(NB); for(auto& v: visited) v.init(PK,vcap);
  // a layer = per-bucket key vectors (+ parents (cost<<62 | bucket<<40 | offset) if REC)
  struct Layer { vector<vector<u32>> bk; vector<vector<u64>> bp; };
  vector<Layer> layers(1); layers[0].bk.assign(NB,{}); layers[0].bp.assign(NB,{});
  { vector<u32> pr(PK); pack(root.data(),pr.data()); u64 h=hashWords(pr.data(),PK); int b=(int)(h>>54); bool nw0; visited[b].tg[visited[b].findOrInsert(pr.data(),h,nw0)]=0;
    layers[0].bk[b]=pr; if(REC) layers[0].bp[b].push_back(0); }
  // streaming certificate (env CERTSTREAM=prefix): binary records per kept state, written layer by layer;
  // record = g u8, done u8, gamma u8, c u8, flag id u32, column ids u32 x c (interner ids; remapped in the final pass)
  const char* CSTR=getenv("CERTSTREAM"); FILE* cst=nullptr; u64 cstN=0;
  if(CSTR){ if(WEAK){ fprintf(stderr,"CERTSTREAM needs WEAK=0\n"); return 2; } cst=fopen((string(CSTR)+".states.bin").c_str(),"wb"); }
  auto dumpLayer=[&](Layer& Lr, int g){
    if(!cst) return; vector<vector<u8>> out(NB);
    for(int b0=0;b0<NB;b0+=64){   // 64 buckets at a time: bounded extra memory
    #pragma omp parallel for schedule(dynamic,1)
    for(int b=b0;b<b0+64;b++){ vector<u32> uk(K); auto& v=Lr.bk[b]; auto& o=out[b];
      for(size_t x=0;x+PK<=v.size();x+=PK){ unpack(&v[x],uk.data()); int c=0; while(c<CMAX && uk[c]!=EMPTY) c++;
        u32 w=uk[CMAX]; u8 hd[8]={(u8)g,(u8)((w>>24)&31),(u8)(w>>29),(u8)c,0,0,0,0}; u32 fid=w&0xFFFFFF; memcpy(hd+4,&fid,4);
        o.insert(o.end(),hd,hd+8); o.insert(o.end(),(u8*)uk.data(),(u8*)uk.data()+4*c); } }
    for(int b=b0;b<b0+64;b++){ fwrite(out[b].data(),1,out[b].size(),cst); vector<u8>().swap(out[b]); } }
    for(int b=0;b<NB;b++) cstN+=Lr.bk[b].size()/PK; fflush(cst); };
  dumpLayer(layers[0],0);
  int found=-1; u64 foundIdx=0, nGoals=0, total=1; auto t0=chrono::steady_clock::now();
  vector<vector<u32>> carryB(NB);   // cost-2 candidates (tag = next layer) for the next layer
  const u64 CH=getenv("CHUNK")? strtoull(getenv("CHUNK"),0,10) : 2000000ULL; // states expanded per chunk (bounds memory)
  for(int d=0; d<KB && found<0; d++){
    Layer& L=layers[d]; vector<u64> pre(NB+1,0); for(int b=0;b<NB;b++) pre[b+1]=pre[b]+L.bk[b].size()/PK; u64 M=pre[NB];
    layers.emplace_back(); Layer& NL=layers.back(); Layer& Lc=layers[d]; NL.bk.assign(NB,{}); NL.bp.assign(NB,{});
    const u8 tag1=(u8)((d+1)&255), tag2=(u8)((d+2)&255);
    // carry: cost-2 candidates from layer d-1 still tagged d+1 belong to layer d+1
    #pragma omp parallel for schedule(dynamic,1)
    for(int b=0;b<NB;b++){ auto& v=carryB[b];   // carry entries are distinct (each was new when stored)
      for(size_t o=0;o<v.size();o+=S){ const u32* k=&v[o]; bool nw; u64 sl=visited[b].findOrInsert(k,hashWords(k,PK),nw);
        if(!nw && visited[b].tg[sl]==tag1){ NL.bk[b].insert(NL.bk[b].end(),k,k+PK); if(REC) NL.bp[b].push_back((u64)v[o+PK]|((u64)v[o+PK+1]<<32)); } }
      vector<u32>().swap(v); }
    vector<vector<u32>> c2B(NB);
    for(u64 c0=0;c0<M;c0+=CH){ u64 c1e=min(M,c0+CH);
      vector<vector<vector<u32>>> c1(NT, vector<vector<u32>>(NB)), c2(NT, vector<vector<u32>>(NB));
      #pragma omp parallel
      { int th=omp_get_thread_num(); HS hs; CS cs; cs.fb.resize(NW); vector<u8> tmp(NW), tf(NW); Raw s; vector<u32> nk(K), uk(K), pk(PK); PCtx P;
        #pragma omp for schedule(dynamic,16)
        for(u64 i=c0;i<c1e;i++){
          int bb=(int)(upper_bound(pre.begin(),pre.end(),i)-pre.begin())-1; u64 oo=i-pre[bb];
          unpack(&Lc.bk[bb][oo*PK],uk.data()); decode(uk.data(),s);
          successorsH(s,P,KB-d,tmp,tf,[&](const Raw& t,int cost,int h){
            if(HCHECK){ int h2=heuristic(t,hs,KB-d-cost); if(!((h<=KB-d-cost && h2==h) || (h>KB-d-cost && h2>KB-d-cost))){ fprintf(stderr,"HCHECK mismatch %d %d\n",h,h2); exit(7);} }
            canonical(t,nk.data(),cs); pack(nk.data(),pk.data()); u64 hh=hashWords(pk.data(),PK);
            auto& b=(cost==1?c1:c2)[th][hh>>54]; size_t o=b.size(); b.resize(o+S); memcpy(&b[o],pk.data(),PK*4);
            if(REC){ u64 par=((u64)cost<<62)|((u64)bb<<40)|oo; b[o+PK]=(u32)par; b[o+PK+1]=(u32)(par>>32); } });
        }
      }
      #pragma omp parallel for schedule(dynamic,1)
      for(int b=0;b<NB;b++){
        for(int th=0;th<NT;th++){ auto& v=c1[th][b];
          for(size_t o=0;o<v.size();o+=S){ const u32* k=&v[o]; bool nw; u64 sl=visited[b].findOrInsert(k,hashWords(k,PK),nw);
            if(nw || visited[b].tg[sl]==tag2){ visited[b].tg[sl]=tag1; NL.bk[b].insert(NL.bk[b].end(),k,k+PK); if(REC) NL.bp[b].push_back((u64)v[o+PK]|((u64)v[o+PK+1]<<32)); } }
          vector<u32>().swap(v); }
        for(int th=0;th<NT;th++){ auto& v=c2[th][b];
          for(size_t o=0;o<v.size();o+=S){ const u32* k=&v[o]; bool nw; u64 sl=visited[b].findOrInsert(k,hashWords(k,PK),nw);
            if(nw){ visited[b].tg[sl]=tag2; c2B[b].insert(c2B[b].end(),&v[o],&v[o]+S); } }
          vector<u32>().swap(v); }
      }
    }
    carryB.swap(c2B);
    dumpLayer(NL,d+1);
    if(!REC){ for(int b=0;b<NB;b++) vector<u32>().swap(Lc.bk[b]); }
    u64 tot=0;
    for(int b=0;b<NB;b++){ u64 nb_=NL.bk[b].size()/PK; vector<u32> gk(K); for(u64 o=0;o<nb_;o++) if((unpack(&NL.bk[b][o*PK],gk.data()),((gk[CMAX]>>24)&31)==ALLDONE)){ if(found<0){ found=d+1; foundIdx=((u64)b<<40)|o; } nGoals++; } tot+=nb_; }
    total+=tot;
    double el=chrono::duration<double>(chrono::steady_clock::now()-t0).count();
    printf("depth %d: %llu new states (total=%llu cols=%zu flags=%zu maxcols=%d) %.1fs\n",d+1,(unsigned long long)tot,(unsigned long long)total,cols->size(),flgs->size(),maxC.load(),el); fflush(stdout);
  }
  if(found<0){ printf("RESULT none<=%d  (no M_out program of length <= %d; N=%d R=unbounded I%d WEAK=%d)\n",KB,KB,N,ISET,(int)WEAK);
    if(cst){ fclose(cst);
      string rules=string("W,P,")+(SYM?"G,":"")+"S,D,H1,und"+(NOH2?"":",H2")+(NOH3?"":",H3p")+",E"+(NG?",NG":"");
      // dense column index: interner order (shard, local index), all-T column skipped
      vector<u64> off(Interner::SH+1,0); int tsi=TCOL&255; u32 tli=TCOL>>8;
      for(int si=0;si<Interner::SH;si++) off[si+1]=off[si]+cols->sh[si].cnt-(si==tsi?1:0);
      auto dense=[&](u32 id)->u64{ int si=id&255; u32 li=id>>8; return off[si]+li-((si==tsi && li>tli)?1:0); };
      string fn=string(CSTR)+".cert"; FILE* fo=fopen(fn.c_str(),"w");
      string head="cert n="+to_string(N)+" W="+to_string(NW)+" iset=I"+to_string(ISET)+" K="+to_string(KB)+" model=out-set ng="+to_string((int)NG)+" rules="+rules+"\nW";
      for(int w=0;w<NW;w++){ head+=' '; for(int i=0;i<N;i++) head+=(char)('0'+rk[w][i]); }
      head+="\nC "+to_string(off[Interner::SH])+"\n"; fwrite(head.data(),1,head.size(),fo);
      { string cb; u64 x=0; for(int si=0;si<Interner::SH;si++) for(u32 li=0;li<cols->sh[si].cnt;li++){ u32 id=(li<<8)|(u32)si; if(id==TCOL) continue;
          if(dense(id)!=x){ fprintf(stderr,"dense index bug\n"); exit(8); }
          cb+=to_string(x++)+" "; const u8* c=cols->get(id); for(int w=0;w<NW;w++) cb+=(char)('0'+c[w]); cb+='\n';
          if(cb.size()>(1u<<24)){ fwrite(cb.data(),1,cb.size(),fo); cb.clear(); } }
        fwrite(cb.data(),1,cb.size(),fo); }
      string sh="S "+to_string(cstN)+"\n"; fwrite(sh.data(),1,sh.size(),fo);
      FILE* fi=fopen((string(CSTR)+".states.bin").c_str(),"rb"); const size_t CHB=1ULL<<30; vector<u8> buf; size_t keep=0; u64 nrec=0;
      while(true){ buf.resize(keep+CHB); size_t got=fread(buf.data()+keep,1,CHB,fi); size_t len=keep+got; if(len==0) break;
        vector<size_t> rs; size_t p=0; while(p+8<=len){ size_t rl=8+4*(size_t)buf[p+3]; if(p+rl>len) break; rs.push_back(p); p+=rl; }
        int nt=omp_get_max_threads(); vector<string> outs(nt); size_t R=rs.size();
        #pragma omp parallel for schedule(static,1)
        for(int t=0;t<nt;t++){ size_t a=R*t/nt, e=R*(t+1)/nt; string& o=outs[t]; char tb[32];
          for(size_t r=a;r<e;r++){ const u8* q=&buf[rs[r]]; u32 fid; memcpy(&fid,q+4,4); const u8* f=flgs->get(fid);
            snprintf(tb,sizeof tb,"%u ",q[0]); o+=tb; for(int w=0;w<NW;w++) o+=(char)('0'+f[w]);
            snprintf(tb,sizeof tb," %u %u",q[1],NG?q[2]:0); o+=tb;
            for(int i=0;i<q[3];i++){ u32 id; memcpy(&id,q+8+4*i,4); snprintf(tb,sizeof tb," %llu",(unsigned long long)dense(id)); o+=tb; }
            o+='\n'; } }
        for(int t=0;t<nt;t++) fwrite(outs[t].data(),1,outs[t].size(),fo);
        nrec+=R; keep=len-p; memmove(buf.data(),buf.data()+p,keep); if(got==0) break; }
      fclose(fi); fclose(fo);
      if(nrec!=cstN){ fprintf(stderr,"record count mismatch %llu %llu\n",(unsigned long long)nrec,(unsigned long long)cstN); exit(8); }
      printf("CERTSTREAM %s: %llu states, %llu columns (next: certend.sh, then pigz)\n",fn.c_str(),(unsigned long long)cstN,(unsigned long long)off[Interner::SH]); }
    if(const char* cf=getenv("CERT")){ // certificate format v1 (agents/lean-reflect/CERT_FORMAT.md): all kept states with their g
      if(!REC || WEAK){ fprintf(stderr,"CERT needs recovery mode (no NOREC) and WEAK=0\n"); return 2; }
      string rules=string("W,P,")+(SYM?"G,":"")+"S,D,H1,und"+(NOH2?"":",H2")+(NOH3?"":",H3p")+",E"+(NG?",NG":"");
      unordered_map<u32,u32> fid; vector<u32> order; string body; u64 ns=0; vector<u32> uk(K); char buf[64];
      for(size_t d=0; d<layers.size(); d++) for(int b=0;b<NB;b++){ auto& v=layers[d].bk[b]; for(size_t o=0;o+PK<=v.size();o+=PK){
        unpack(&v[o],uk.data()); Raw r; decode(uk.data(),r);
        snprintf(buf,sizeof buf,"%zu ",d); body+=buf; for(int w=0;w<NW;w++) body+=(char)('0'+r.f[w]);
        snprintf(buf,sizeof buf," %u %u",r.done,NG?r.g:0); body+=buf;
        for(int i=0;i<r.c;i++){ u32 id=uk[i]; auto it=fid.find(id); u32 x; if(it==fid.end()){ x=(u32)order.size(); fid[id]=x; order.push_back(id); } else x=it->second;
          snprintf(buf,sizeof buf," %u",x); body+=buf; }
        body+='\n'; ns++; } }
      string head="cert n="+to_string(N)+" W="+to_string(NW)+" iset=I"+to_string(ISET)+" K="+to_string(KB)+" model=out-set ng="+to_string((int)NG)+" rules="+rules+"\nW";
      for(int w=0;w<NW;w++){ head+=' '; for(int i=0;i<N;i++) head+=(char)('0'+rk[w][i]); }
      head+="\nC "+to_string(order.size())+"\n";
      for(size_t x=0;x<order.size();x++){ head+=to_string(x)+" "; const u8* c=cols->get(order[x]); for(int w=0;w<NW;w++) head+=(char)('0'+c[w]); head+='\n'; }
      head+="S "+to_string(ns)+"\n";
      FILE* fo=fopen(cf,"w"); fwrite(head.data(),1,head.size(),fo); fwrite(body.data(),1,body.size(),fo); fclose(fo);
      printf("CERT %s: %llu states, %zu columns (sha256/END line appended by enum/certend.sh)\n",cf,(unsigned long long)ns,order.size()); }
    return 0; }
  printf("RESULT min=%d goal_states_at_min=%llu\n",found,(unsigned long long)nGoals);
  if(!REC){ printf("(NOREC: no program recovery)\n"); return 0; }
  vector<vector<u32>> chain; vector<int> costs; { u64 idx=foundIdx; int d=found;
    vector<int> depths; vector<u64> idxs; vector<int> cs_;
    while(true){ depths.push_back(d); idxs.push_back(idx); if(d==0) break; int b=(int)(idx>>40); u64 o=idx&((1ULL<<40)-1);
      u64 p=layers[d].bp[b][o]; int cost=(int)(p>>62); cs_.push_back(cost); idx=p&((1ULL<<62)-1); d-=cost; }
    costs.assign(1,0); for(int q=(int)cs_.size()-1;q>=0;q--) costs.push_back(cs_[q]);
    for(int q=(int)depths.size()-1;q>=0;q--){ int b=(int)(idxs[q]>>40); u64 o=idxs[q]&((1ULL<<40)-1); vector<u32> uk(K); unpack(&layers[depths[q]].bk[b][o*PK],uk.data()); chain.push_back(uk); } }
  vector<string> prog=recover(chain,costs,cs0);
  int nreg=0; { set<string> rs; for(auto& l: prog){ auto p=l.find(' '); string a=l.substr(p+1); for(auto& tok: {a.substr(0,a.find(',')), a.substr(a.find(',')+2)}) if(tok[0]=='P'||tok[0]=='S') rs.insert(tok); } nreg=(int)rs.size(); }
  string hdr="# n="+to_string(N)+" R="+to_string(max(nreg,N))+" iset=I"+to_string(ISET)+" model=out source=agents/enum/src/enum_out.cpp (set-model BFS, "+(WEAK?"weak orders":"strict perms")+")";
  printf("%s\n",hdr.c_str()); for(auto& l: prog) printf("%s\n",l.c_str());
  if(!outp.empty()){ FILE* fo=fopen(outp.c_str(),"w"); fprintf(fo,"%s\n",hdr.c_str()); for(auto& l: prog) fprintf(fo,"%s\n",l.c_str()); fclose(fo); }
  return 0;
}
