// dagx.cpp -- d1-skeleton: exact gate-DAG routing search for a fixed VALUE skeleton (sort5, M_out, I1).
// C++ port of dag.py. Types = 120 strict permutations (sound relaxation for "none <= K").
// Program = c cmps (fixed operand columns) + gates (cmov) + copies (mov); cost = c + #gates + #copies.
// Requirements (partial columns + deadline block) are resolved by a link to a finished node or by a new gate
// (block j <= deadline, cond): S matches P on cond-true types, D on cond-false types. Links only to finished nodes
// (DFS creation order covers every DAG). Leaf: copies = #gates - max #in-place gates (destroyer of X after all other
// uses of X, cmp operands alive at their cmp, acyclic in-block order).
// Bounds: #pairwise-incompatible open requirements (each needs its own new gate); copies lower bound = exact
// max-in-place of the partial DAG (monotone). Pruning: index consistency of a column created in block j
// (it holds x_idx with idx a function of the flag history up to j).
// usage: dagx SKELFILE K [maxsol] [nodelimit]
#include <bits/stdc++.h>
using namespace std;
typedef uint64_t u64; typedef uint8_t u8;
#ifndef NN
#define NN 5
#endif
static const int N = NN, NT = (NN == 5 ? 120 : NN == 4 ? 24 : 6);  // -DNN=4: sort4 sanity check
struct BS { u64 w[2]; };
static inline BS bor(BS a, BS b) { return {{a.w[0] | b.w[0], a.w[1] | b.w[1]}}; }
static inline BS band(BS a, BS b) { return {{a.w[0] & b.w[0], a.w[1] & b.w[1]}}; }
static inline BS bandn(BS a, BS b) { return {{a.w[0] & ~b.w[0], a.w[1] & ~b.w[1]}}; }
static inline bool bz(BS a) { return !(a.w[0] | a.w[1]); }
static inline bool beq(BS a, BS b) { return a.w[0] == b.w[0] && a.w[1] == b.w[1]; }
static inline void bset(BS& a, int i) { a.w[i >> 6] |= 1ULL << (i & 63); }
static inline bool bget(const BS& a, int i) { return a.w[i >> 6] >> (i & 63) & 1; }
struct Col { BS v[N]; };  // v[k] = types where value k (partial: union = constrained types)
static inline BS dom(const Col& c) { BS d = c.v[0]; for (int k = 1; k < N; k++) d = bor(d, c.v[k]); return d; }
static inline bool colEq(const Col& a, const Col& b) { for (int k = 0; k < N; k++) if (!beq(a.v[k], b.v[k])) return false; return true; }
static inline bool matches(const Col& full, const Col& P) { for (int k = 0; k < N; k++) if (!bz(bandn(P.v[k], full.v[k]))) return false; return true; }
static inline bool conflict(const Col& a, const Col& b) {  // some type constrained in both with different values
  BS da = dom(a), db = dom(b), both = band(da, db); if (bz(both)) return false;
  for (int k = 0; k < N; k++) if (!beq(band(a.v[k], both), band(b.v[k], both))) return true; return false; }
static inline Col restrictTo(const Col& c, BS m) { Col r; for (int k = 0; k < N; k++) r.v[k] = band(c.v[k], m); return r; }
static inline Col selectCol(BS t, const Col& S, const Col& D) { Col r; for (int k = 0; k < N; k++) r.v[k] = bor(band(t, S.v[k]), bandn(D.v[k], t)); return r; }

static vector<array<u8, N>> TY;
static int TIDX(const array<u8, N>& x) { return lower_bound(TY.begin(), TY.end(), x) - TY.begin(); }
static int C, K, BUDGET;
static vector<Col> OPA, OPB; static Col TG[N];
static vector<vector<pair<Col, Col>>> ALT;
static vector<vector<Col>> COMMON;  // columns that occur in every alternative pair of a cmp  // alternative operand pairs per cmp (same flags); line "a:b;c:d"
static vector<vector<u8>> F;           // F[j][t], j=1..C: 1 lt 2 gt 0 eq
static BS TS[16][4]; static bool TSok[16][4];
static const char* CN[4] = {"cmovl", "cmovg", "cmovle", "cmovge"};
static vector<vector<BS>> CLS;         // CLS[j] = list of class bitsets at block j
static BS POS[N][N];                   // POS[i][v] = types where x_i == v

static int TIDX(const array<u8, N>& x);
static int evf(const string& f, const array<u8, N>& x) {
  if (f[0] == '=') return f[1 + TIDX(x)] - '0';
  int best = -1; size_t p = 0;
  while (p <= f.size()) { size_t q = f.find('|', p); if (q == string::npos) q = f.size();
    int m = 99; for (size_t i = p; i < q; i++) m = min(m, (int)x[f[i] - '0']); best = max(best, m); p = q + 1; }
  return best; }

static bool consistent(const Col& P, int j) {
  BS B[N];
  for (int i = 0; i < N; i++) { BS b = {{0, 0}}; for (int v = 0; v < N; v++) b = bor(b, band(P.v[v], POS[i][v])); B[i] = b; }
  for (const BS& c : CLS[j]) { int cnt = 0; for (int i = 0; i < N; i++) if (!bz(band(B[i], c))) cnt++; if (cnt > 1) return false; }
  return true;
}

struct Node { Col col; Col Pdef; int blk; int D, S, cond; bool fin; };  // Pdef: constraint the node was created for
static vector<Node> nodes;
static int cmpuse[16][2];
struct Item { int kind; int fin_g; Col P; int dl; int slotKind; int a, b; };  // kind 0 req, 1 fin, 2 operand-pair choice for cmp a; slot: 0 cmp(a=j,b=which) 1 out(a=k) 2 gateD(a=g) 3 gateS(a=g)
static long long calls = 0, leaves = 0, nsol = 0, maxsol = 1, nodelimit = -1;
static int bestCost = 1 << 30;
static chrono::steady_clock::time_point runStart;

static void setslot(const Item& it, int x) {
  if (it.slotKind == 0) cmpuse[it.a][it.b] = x;
  else if (it.slotKind == 2) nodes[it.a].D = x;
  else if (it.slotKind == 3) nodes[it.a].S = x;
}

// ---- in-place maximisation over gates with resolved D and S ----
struct Use { int kind; int who; };  // kind 0 gate-D, 1 gate-S, 2 cmp (who = j)
// Cycles can only appear inside one block (cross-block edges go forward), and a valid destroyer of X lies in the
// last block that uses X, so the problem splits into independent per-block problems (small: brute force).
static bool topoMask(int n, const u64* adj, vector<int>* ord) {  // adj[i] = successor mask
  u64 left = (n == 64) ? ~0ULL : ((1ULL << n) - 1); vector<int> o;
  while (left) { int pick = -1;
    for (u64 m = left; m; m &= m - 1) { int i = __builtin_ctzll(m); bool hasPred = false;
      for (u64 q = left; q; q &= q - 1) { int k = __builtin_ctzll(q); if (adj[k] >> i & 1) { hasPred = true; break; } }
      if (!hasPred) { pick = i; break; } }
    if (pick < 0) return false; left &= ~(1ULL << pick); o.push_back(pick); }
  if (ord) *ord = o; return true; }
static int maxInplaceLegacy(vector<int>* outOrder, vector<int>* outIn) {
  int nn = nodes.size();
  vector<int> G; for (int g = N; g < nn; g++) if (nodes[g].D >= 0 && nodes[g].S >= 0) G.push_back(g);
  vector<vector<Use>> U(nn);
  for (int g : G) { U[nodes[g].D].push_back({0, g}); U[nodes[g].S].push_back({1, g}); }
  for (int j = 1; j <= C; j++) for (int w = 0; w < 2; w++) if (cmpuse[j][w] >= 0) U[cmpuse[j][w]].push_back({2, j});
  vector<int> loc(nn, -1);
  vector<vector<int>> GB(C + 1);
  for (int g : G) { loc[g] = GB[nodes[g].blk].size(); GB[nodes[g].blk].push_back(g); }
  int total = 0; if (outIn) outIn->clear(); if (outOrder) outOrder->clear();
  for (int b = 1; b <= C; b++) {
    auto& gb = GB[b]; int n = gb.size(); if (!n) continue;
    if (n > 64) { fprintf(stderr, "block too large\n"); exit(7); }
    vector<u64> adj(n, 0);
    for (int i = 0; i < n; i++) { int g = gb[i]; for (int x : {nodes[g].D, nodes[g].S}) if (x >= N && loc[x] >= 0 && nodes[x].blk == b && nodes[x].D >= 0 && nodes[x].S >= 0) adj[loc[x]] |= 1ULL << i; }
    // candidates in this block: (local index, X, mask of other in-block users of X)
    vector<int> ci, cx; vector<u64> cpred;
    for (int i = 0; i < n; i++) { int g = gb[i], X = nodes[g].D; bool ok = true; u64 pm = 0;
      for (auto& u : U[X]) { if (u.kind == 2) { if (u.who > b) ok = false; }
        else if (u.who != g) { if (nodes[u.who].blk > b) ok = false; else if (nodes[u.who].blk == b) pm |= 1ULL << loc[u.who]; } }
      if (ok) { ci.push_back(i); cx.push_back(X); cpred.push_back(pm); } }
    if (!topoMask(n, adj.data(), nullptr)) return -1;
    int nc = ci.size(), best = 0; vector<int> bestSel, sel; vector<u64> a2 = adj;
    function<void(int)> br = [&](int k) {
      if ((int)sel.size() + (nc - k) <= best && !(best == 0 && bestSel.empty() && sel.empty() && k == nc)) { if ((int)sel.size() + (nc - k) <= best) return; }
      if (k == nc) { if ((int)sel.size() > best || bestSel.empty()) { best = sel.size(); bestSel = sel; } return; }
      bool dupX = false; for (int q : sel) if (cx[q] == cx[k]) { dupX = true; break; }
      if (!dupX) { vector<u64> save = a2; int i = ci[k];
        for (u64 m = cpred[k]; m; m &= m - 1) a2[__builtin_ctzll(m)] |= 1ULL << i;
        if (topoMask(n, a2.data(), nullptr)) { sel.push_back(k); br(k + 1); sel.pop_back(); }
        a2 = save; }
      br(k + 1); };
    br(0);
    total += best;
    if (outIn || outOrder) {
      vector<u64> fa = adj; for (int k : bestSel) { int i = ci[k]; for (u64 m = cpred[k]; m; m &= m - 1) fa[__builtin_ctzll(m)] |= 1ULL << i; if (outIn) outIn->push_back(gb[i]); }
      vector<int> o; topoMask(n, fa.data(), &o); if (outOrder) for (int i : o) outOrder->push_back(gb[i]); }
  }
  return (int)G.size() - total;  // copies among resolved gates
}

static bool FASTCPL=true,CHECKCPL=false,CACHECPL=true,LEGACYFILL=true;
struct CopyCacheEntry { unsigned char key[128]; unsigned short length=0; int cost=0; };
static CopyCacheEntry copyCache[1024];
static long long copyCacheHits=0,copyCacheMisses=0;
static int cachedCopyBound(vector<int>* outOrder,vector<int>* outIn);
static bool topoFast(int n,const u64* adj,vector<int>* order) {
  u64 pred[64]={};
  for(int i=0;i<n;i++)for(u64 m=adj[i];m;m&=m-1)pred[__builtin_ctzll(m)]|=1ULL<<i;
  u64 left=n==64?~0ULL:((1ULL<<n)-1);
  while(left) {
    int pick=-1;
    for(u64 m=left;m;m&=m-1){int i=__builtin_ctzll(m);if(!(pred[i]&left)){pick=i;break;}}
    if(pick<0)return false;
    left&=~(1ULL<<pick);if(order)order->push_back(pick);
  }
  return true;
}
struct BlockSolver {
  int n,nc,best=0,nbest=0;
  int ci[64],cx[64],sel[64],bestSel[64];u64 pm[64],adj[64];
  void run(int k,int ns,u64 used) {
    if(ns+nc-k<=best && !(best==0 && nbest==0 && ns==0 && k==nc))return;
    if(k==nc){if(ns>best || nbest==0){best=ns;nbest=ns;copy(sel,sel+ns,bestSel);}return;}
    if(!(used>>cx[k]&1)) {
      u64 saved[64];copy(adj,adj+n,saved);int i=ci[k];
      for(u64 m=pm[k];m;m&=m-1)adj[__builtin_ctzll(m)]|=1ULL<<i;
      if(topoFast(n,adj,nullptr)){sel[ns]=k;run(k+1,ns+1,used|(1ULL<<cx[k]));}
      copy(saved,saved+n,adj);
    }
    run(k+1,ns,used);
  }
};
static int maxInplaceFast(vector<int>* outOrder,vector<int>* outIn) {
  int nn=nodes.size();if(nn>63)return maxInplaceLegacy(outOrder,outIn);
  int gb[16][64],ngb[16]={},loc[64],lastCmp[64]={};u64 users[64]={};int ng=0;
  fill(loc,loc+64,-1);
  for(int g=N;g<nn;g++)if(nodes[g].D>=0 && nodes[g].S>=0) {
    int b=nodes[g].blk;loc[g]=ngb[b];gb[b][ngb[b]++]=g;ng++;
    users[nodes[g].D]|=1ULL<<g;users[nodes[g].S]|=1ULL<<g;
  }
  for(int j=1;j<=C;j++)for(int w=0;w<2;w++)if(cmpuse[j][w]>=0)lastCmp[cmpuse[j][w]]=max(lastCmp[cmpuse[j][w]],j);
  if(outIn)outIn->clear();if(outOrder)outOrder->clear();int total=0;
  for(int b=1;b<=C;b++) {
    int n=ngb[b];if(!n)continue;BlockSolver q;q.n=n;q.nc=0;fill(q.adj,q.adj+n,0);
    for(int i=0;i<n;i++) {
      int g=gb[b][i];
      for(int x:{nodes[g].D,nodes[g].S})if(x>=N && loc[x]>=0 && nodes[x].blk==b)q.adj[loc[x]]|=1ULL<<i;
    }
    for(int i=0;i<n;i++) {
      int g=gb[b][i],x=nodes[g].D;bool ok=lastCmp[x]<=b;u64 pm=0;
      for(u64 m=users[x]&~(1ULL<<g);m;m&=m-1) {
        int h=__builtin_ctzll(m);
        if(nodes[h].blk>b)ok=false;
        else if(nodes[h].blk==b)pm|=1ULL<<loc[h];
      }
      if(ok){int k=q.nc++;q.ci[k]=i;q.cx[k]=x;q.pm[k]=pm;}
    }
    if(!topoFast(n,q.adj,nullptr))return -1;
    q.run(0,0,0);total+=q.best;
    if(outIn || outOrder) {
      for(int z=0;z<q.nbest;z++) {
        int k=q.bestSel[z],i=q.ci[k];
        for(u64 m=q.pm[k];m;m&=m-1)q.adj[__builtin_ctzll(m)]|=1ULL<<i;
        if(outIn)outIn->push_back(gb[b][i]);
      }
      vector<int> local;topoFast(n,q.adj,&local);
      if(outOrder)for(int i:local)outOrder->push_back(gb[b][i]);
    }
  }
  return ng-total;
}
static int cachedCopyBound(vector<int>* outOrder,vector<int>* outIn) {
  int nn=nodes.size();
  if(!CACHECPL || outOrder || outIn || nn>63 || 2*C+4*(nn-N)>128)return LEGACYFILL?maxInplaceLegacy(outOrder,outIn):maxInplaceFast(outOrder,outIn);
  unsigned char key[128];int length=0;
  for(int j=1;j<=C;j++)for(int w=0;w<2;w++)key[length++]=(unsigned char)(cmpuse[j][w]+1);
  for(int g=N;g<nn;g++)if(nodes[g].D>=0 && nodes[g].S>=0) {
    key[length++]=g;key[length++]=nodes[g].blk;key[length++]=nodes[g].D+1;key[length++]=nodes[g].S+1;
  }
  u64 hash=1469598103934665603ULL;for(int i=0;i<length;i++)hash=(hash^key[i])*1099511628211ULL;
  CopyCacheEntry& entry=copyCache[hash&1023];
  if(entry.length==length && !memcmp(entry.key,key,length)){copyCacheHits++;return entry.cost;}
  copyCacheMisses++;int value=LEGACYFILL?maxInplaceLegacy(nullptr,nullptr):maxInplaceFast(nullptr,nullptr);
  memcpy(entry.key,key,length);entry.length=length;entry.cost=value;return value;
}

static long long checkedCopyBounds=0;
static int maxInplace(vector<int>* outOrder,vector<int>* outIn) {
  if(!FASTCPL)return maxInplaceLegacy(outOrder,outIn);
  int fast=cachedCopyBound(outOrder,outIn);
  if(CHECKCPL) {
    vector<int> order,inplace;
    int slow=maxInplaceLegacy(outOrder?&order:nullptr,outIn?&inplace:nullptr);
    checkedCopyBounds++;
    if(fast!=slow || (outOrder && *outOrder!=order) || (outIn && *outIn!=inplace)) {
      fprintf(stderr,"COPY_BOUND_MISMATCH fast=%d legacy=%d checked=%lld\n",fast,slow,checkedCopyBounds);abort();
    }
  }
  return fast;
}

static int ngates() { return (int)nodes.size() - N; }
static int lbOpen(const vector<Item>& st) {
  vector<const Col*> open;
  auto consider = [&](const Col& P, int dl) {
    // free if a finished node matches, or an unfinished node (finishes later) may match: compatible with its Pdef
    bool m = false; for (auto& nd : nodes) if (nd.blk <= dl && (nd.fin ? matches(nd.col, P) : !conflict(nd.Pdef, P))) { m = true; break; }
    if (!m) { bool dup = false; for (auto* q : open) if (colEq(*q, P)) { dup = true; break; } if (!dup) open.push_back(&P); } };
  for (auto& it : st) {
    if (it.kind == 0) consider(it.P, it.dl);
    else if (it.kind == 2) for (auto& c : COMMON[it.a - 1]) consider(c, it.dl);  // operand present in every alternative
  }
  // greedy pairwise-incompatible set, larger domains first
  sort(open.begin(), open.end(), [](const Col* a, const Col* b) { BS da = dom(*a), db = dom(*b);
    return __builtin_popcountll(da.w[0]) + __builtin_popcountll(da.w[1]) > __builtin_popcountll(db.w[0]) + __builtin_popcountll(db.w[1]); });
  vector<const Col*> pk;
  for (auto* p : open) { bool ok = true; for (auto* q : pk) if (!conflict(*p, *q)) { ok = false; break; } if (ok) pk.push_back(p); }
  return pk.size();
}

static string rn(int r) { return r < N ? "P" + to_string(r) : "S" + to_string(r - N); }
static void emit(const vector<int>& order, const vector<int>& inpl) {
  set<int> in(inpl.begin(), inpl.end());
  map<int, string> reg; for (int i = 0; i < N; i++) reg[i] = "P" + to_string(i);
  int nsc = 0; size_t pos = 0; int done = 0;
  for (int j = 1; j <= C; j++) {
    printf("cmp %s, %s\n", reg[cmpuse[j][0]].c_str(), reg[cmpuse[j][1]].c_str());
    while (pos < order.size() && nodes[order[pos]].blk == j) {
      int g = order[pos++]; Node& nd = nodes[g]; string r;
      if (in.count(g)) r = reg[nd.D]; else { r = "S" + to_string(nsc++); printf("mov %s, %s\n", r.c_str(), reg[nd.D].c_str()); }
      printf("%s %s, %s\n", CN[nd.cond], r.c_str(), reg[nd.S].c_str()); reg[g] = r;
      for (int k = 0; k < N; k++) if (!(done >> k & 1) && colEq(nd.col, TG[k])) { done |= 1 << k; printf("out %d, %s\n", k, r.c_str()); }
    }
  }
}

static int curCpl = 0, CPLSLACK = 999;
static int SPLITN = 1, SPLITI = 0, SPLITD = 6, depth = 0; static long long splitIdx = 0;
static void rec(vector<Item>& st) {
  calls++;
  if(calls%5000000==0) {printf("PROGRESS calls=%lld leaves=%lld gates=%d seconds=%.1f\n",calls,leaves,ngates(),chrono::duration<double>(chrono::steady_clock::now()-runStart).count());fflush(stdout);}
  if (nsol >= maxsol) return;
  if (nodelimit > 0 && calls > nodelimit) return;
  if (st.empty()) {
    leaves++;
    vector<int> order, inpl; int cp = maxInplace(&order, &inpl);
    if (cp < 0) return;
    int cost = C + ngates() + cp;
    if (cost <= K) { nsol++; bestCost = min(bestCost, cost);
      printf("SOLUTION cost=%d gates=%d copies=%d calls=%lld\n", cost, ngates(), cp, calls); emit(order, inpl); printf("END\n"); fflush(stdout); }
    return;
  }
  Item it = st.back(); st.pop_back();
  if (it.kind == 2) {  // choose one alternative operand pair of cmp it.a
    int j = it.a;
    for (auto& [ca, cb] : ALT[j - 1]) {
      size_t sz = st.size();
      for (int w = 1; w >= 0; w--) { Item r; r.kind = 0; r.P = w ? cb : ca; r.dl = j - 1; r.slotKind = 0; r.a = j; r.b = w; st.push_back(r); }
      rec(st); st.resize(sz);
      if (nsol >= maxsol) break;
    }
    st.push_back(it); return;
  }
  if (it.kind == 1) {
    Node& nd = nodes[it.fin_g];
    Col M = selectCol(TS[nd.blk][nd.cond], nodes[nd.S].col, nodes[nd.D].col);
    if (!colEq(M, nodes[nd.D].col) && !colEq(M, nodes[nd.S].col)) {
      nd.col = M; nd.fin = true; rec(st); nodes[it.fin_g].fin = false; }
    st.push_back(it); return;
  }
  int lbo = lbOpen(st);
  if (ngates() + lbo > BUDGET) { st.push_back(it); return; }
  // process split: subtrees at decision depth SPLITD are dealt round-robin to parts
  if (SPLITN > 1 && depth == SPLITD) { long long id = splitIdx++; if (id % SPLITN != SPLITI) { st.push_back(it); return; } }
  // copies lower bound is monotone: reuse the parent value; recompute exactly only when slack is small
  int cpl = curCpl;
  if (BUDGET - ngates() - lbo - cpl <= CPLSLACK) cpl = maxInplace(nullptr, nullptr);
  int savedCpl = curCpl; curCpl = cpl < 0 ? 0 : cpl;
  if (cpl < 0) { curCpl = savedCpl; st.push_back(it); return; }
  // (a) link
  for (int x = 0; x < (int)nodes.size(); x++) {
    if (!nodes[x].fin || nodes[x].blk > it.dl || !matches(nodes[x].col, it.P)) continue;
    if (ngates() + lbo + cpl > BUDGET) break;
    setslot(it, x); depth++; rec(st); depth--; setslot(it, -1);
    if (nsol >= maxsol) { curCpl = savedCpl; st.push_back(it); return; }
  }
  // (b) new gate
  bool newok = ngates() + 1 + lbo + cpl <= BUDGET;
  if (!newok && ngates() + max(1, lbo) + cpl <= BUDGET) {
    st.push_back(it);
    int allOpen = lbOpen(st);
    st.pop_back();
    newok = ngates() + max(1, allOpen) + cpl <= BUDGET;
  }
  if (newok) {
    int g = nodes.size();
    for (int j = it.dl; j >= 1; j--) {
      if (!consistent(it.P, j)) break;  // classes only get coarser for smaller j
      for (int cd = 0; cd < 4; cd++) { if (!TSok[j][cd]) continue;
        BS t = TS[j][cd];
        Col PS = restrictTo(it.P, t); BS all = NT > 64 ? BS{{~0ULL, (1ULL << (NT - 64)) - 1}} : BS{{(1ULL << NT) - 1, 0}}; Col PD = restrictTo(it.P, bandn(all, t));
        if (bz(dom(PS)) || bz(dom(PD))) continue;
        Node nd; nd.blk = j; nd.D = -1; nd.S = -1; nd.cond = cd; nd.fin = false; nd.Pdef = it.P; nodes.push_back(nd);
        setslot(it, g);
        Item f; f.kind = 1; f.fin_g = g;
        Item rd; rd.kind = 0; rd.P = PD; rd.dl = j; rd.slotKind = 2; rd.a = g;
        Item rs; rs.kind = 0; rs.P = PS; rs.dl = j; rs.slotKind = 3; rs.a = g;
        size_t sz = st.size(); st.push_back(f); st.push_back(rd); st.push_back(rs);
        depth++; rec(st); depth--;
        st.resize(sz); setslot(it, -1); nodes.pop_back();
        if (nsol >= maxsol) { curCpl = savedCpl; st.push_back(it); return; }
      }
    }
  }
  curCpl = savedCpl;
  st.push_back(it);
}

int main(int argc, char** argv) {
  if (argc < 3) { fprintf(stderr, "usage: dagx SKELFILE K [maxsol] [nodelimit]\n"); return 1; }
  printf("ROUTER conservative_open_bound v1\n");
  if(getenv("FASTCPL"))FASTCPL=atoi(getenv("FASTCPL"));
  if(getenv("LEGACYFILL"))LEGACYFILL=atoi(getenv("LEGACYFILL"));
  printf("COPY_CACHE_FILL legacy=%d\n",LEGACYFILL);
  if(getenv("CACHECPL"))CACHECPL=atoi(getenv("CACHECPL"));
  CHECKCPL=getenv("CHECKCPL") && atoi(getenv("CHECKCPL"));
  printf("ROUTER_COPY_IMPL stack_v1 enabled=%d check=%d\n",FASTCPL,CHECKCPL);
  K = atoi(argv[2]); if (argc > 3) maxsol = atoll(argv[3]); if (argc > 4) nodelimit = atoll(argv[4]);
  if (getenv("CPLSLACK")) CPLSLACK = atoi(getenv("CPLSLACK"));
  if (const char* e = getenv("SPLIT")) { sscanf(e, "%d/%d@%d", &SPLITI, &SPLITN, &SPLITD); }  // SPLIT=i/n@depth
  array<u8, N> p; for (int i = 0; i < N; i++) p[i] = i;
  do TY.push_back(p); while (next_permutation(p.begin(), p.end()));
  ifstream in(argv[1]); string w; vector<pair<string, string>> sk;
  // line forms: "a:b" (lattice formulas: max over '|' terms of min over digits) or "=<120 digits>:<120 digits>"
  // (explicit operand columns: value at the t-th permutation in lexicographic order)
  vector<vector<pair<string, string>>> skalt;
  while (in >> w) { if (w[0] == '#') { getline(in, w); continue; }
    vector<pair<string, string>> al; stringstream ss(w); string part;
    while (getline(ss, part, ';')) { size_t c = part.find(':'); al.push_back({part.substr(0, c), part.substr(c + 1)}); }
    sk.push_back(al[0]); skalt.push_back(al); }
  C = sk.size(); BUDGET = K - C;
  auto mk = [&](function<int(int)> f) { Col c; for (int k = 0; k < N; k++) c.v[k] = {{0, 0}}; for (int t = 0; t < NT; t++) bset(c.v[f(t)], t); return c; };
  F.assign(C + 1, vector<u8>(NT, 0));
  for (int j = 0; j < C; j++) {
    Col a = mk([&](int t) { return evf(sk[j].first, TY[t]); }), b = mk([&](int t) { return evf(sk[j].second, TY[t]); });
    OPA.push_back(a); OPB.push_back(b);
    ALT.push_back({});
    for (auto& [fa, fb] : skalt[j]) {
      Col x = mk([&](int t) { return evf(fa, TY[t]); }), y = mk([&](int t) { return evf(fb, TY[t]); });
      int dir = 0;  // +1 same flags, -1 reversed
      for (int t = 0; t < NT; t++) { int va = evf(sk[j].first, TY[t]), vb = evf(sk[j].second, TY[t]), xa = evf(fa, TY[t]), xb = evf(fb, TY[t]);
        int f0 = (va > vb) - (va < vb), f1 = (xa > xb) - (xa < xb);
        int d = f0 == f1 ? 1 : f0 == -f1 ? -1 : 0; if (f0 == 0 && f1 == 0) continue;
        if (d == 0 || (dir && d != dir)) { fprintf(stderr, "alternative %s:%s of cmp %d has other flags\n", fa.c_str(), fb.c_str(), j + 1); return 1; } dir = d; }
      if (dir == -1) swap(x, y);
      ALT.back().push_back({x, y}); }
    for (int t = 0; t < NT; t++) { int va = evf(sk[j].first, TY[t]), vb = evf(sk[j].second, TY[t]); F[j + 1][t] = va < vb ? 1 : va > vb ? 2 : 0; }
  }
  COMMON.assign(C, {});
  for (int j = 0; j < C; j++) for (const Col& x : {ALT[j][0].first, ALT[j][0].second}) {
    bool all = true; for (auto& [a, b] : ALT[j]) if (!colEq(a, x) && !colEq(b, x)) { all = false; break; }
    if (all) COMMON[j].push_back(x); }
  for (int k = 0; k < N; k++) TG[k] = mk([&](int t) { auto s = TY[t]; sort(s.begin(), s.end()); return (int)s[k]; });
  for (int i = 0; i < N; i++) for (int v = 0; v < N; v++) { POS[i][v] = {{0, 0}}; for (int t = 0; t < NT; t++) if (TY[t][i] == v) bset(POS[i][v], t); }
  for (int j = 1; j <= C; j++) { bool eq = false; for (int t = 0; t < NT; t++) eq |= F[j][t] == 0;
    for (int cd = 0; cd < 4; cd++) { BS b = {{0, 0}}; for (int t = 0; t < NT; t++) { u8 f = F[j][t]; bool h = cd == 0 ? f == 1 : cd == 1 ? f == 2 : cd == 2 ? f != 2 : f != 1; if (h) bset(b, t); }
      TS[j][cd] = b; TSok[j][cd] = cd < 2 || eq; } }
  CLS.assign(C + 1, {});
  for (int j = 0; j <= C; j++) { map<vector<u8>, BS> m; for (int t = 0; t < NT; t++) { vector<u8> h; for (int i = 1; i <= j; i++) h.push_back(F[i][t]); auto it = m.find(h); if (it == m.end()) { BS b = {{0, 0}}; bset(b, t); m[h] = b; } else bset(it->second, t); }
    for (auto& [h, b] : m) CLS[j].push_back(b); }
  for (int i = 0; i < N; i++) { Node nd; nd.col = mk([&](int t) { return (int)TY[t][i]; }); nd.blk = 0; nd.D = nd.S = -1; nd.cond = -1; nd.fin = true; nodes.push_back(nd); }
  for (int j = 0; j < 16; j++) cmpuse[j][0] = cmpuse[j][1] = -1;
  vector<Item> st;
  int rootOrder=getenv("ROOTORDER")?atoi(getenv("ROOTORDER")):0;
  printf("ROOT_ORDER mode=%d\n",rootOrder);
  auto addOutputs=[&]() {
    vector<int> ranks;
    if(rootOrder==2 || rootOrder==4) {for(int k=0;k<N;k++)ranks.push_back(k);stable_sort(ranks.begin(),ranks.end(),[](int a,int b){return abs(2*a-(N-1))>abs(2*b-(N-1));});}
    else for(int k=0;k<N;k++)ranks.push_back(k);
    for(int k:ranks){Item it;it.kind=0;it.P=TG[k];it.dl=C;it.slotKind=1;it.a=k;st.push_back(it);}
  };
  auto addComparisons=[&]() {
    for(int step=0;step<C;step++) {
      int j=(rootOrder==1 || rootOrder==4)?step+1:C-step;
      if(ALT[j-1].size()>1){Item it;it.kind=2;it.a=j;it.dl=j-1;st.push_back(it);continue;}
      for(int w=1;w>=0;w--){Item it;it.kind=0;it.P=w?OPB[j-1]:OPA[j-1];it.dl=j-1;it.slotKind=0;it.a=j;it.b=w;st.push_back(it);}
    }
  };
  if(rootOrder==2 || rootOrder==3 || rootOrder==4) {addComparisons();addOutputs();}
  else {addOutputs();addComparisons();}
  printf("skeleton c=%d K=%d budget(gates+copies)=%d lb(root)=%d classes(c)=%zu\n", C, K, BUDGET, lbOpen(st), CLS[C].size()); fflush(stdout);
  auto t0 = chrono::steady_clock::now();
  runStart=t0;
  rec(st);
  double sec = chrono::duration<double>(chrono::steady_clock::now() - t0).count();
  printf("COPY_BOUND_CHECKS count=%lld cache_hits=%lld cache_misses=%lld\n",checkedCopyBounds,copyCacheHits,copyCacheMisses);
  bool lim = nodelimit > 0 && calls > nodelimit;
  printf("RESULT %s K=%d calls=%lld leaves=%lld sols=%lld best=%d time=%.1fs%s\n", nsol ? "FOUND" : (lim ? "LIMIT" : "NONE"), K, calls, leaves, nsol, nsol ? bestCost : -1, sec, lim ? " (node limit hit: not exhaustive)" : "");
}
