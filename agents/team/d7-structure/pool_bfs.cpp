// d7: exact BFS over register programs whose every register value is a term of a given POOL (columns over 541 weak
// orders). Registers interchangeable (M_out, outs free). Moves: mov, cmp, cmovX (result must be a pool term).
// Scratch registers start empty (a cmov into an empty register = conditional copy, same cost as mov -> mov only).
// usage: pool_bfs POOLFILE K R   (POOLFILE: one term per line, 541 ints; first 5 = inputs x0..x4)
#include <bits/stdc++.h>
using namespace std;
typedef unsigned char u8;
int NT = 541, NP, K, R;
vector<vector<u8>> col;
map<vector<u8>, int> idx;
int outterm[5];
struct St { u8 r[12]; u8 fa, fb; uint32_t mask; };
static inline uint64_t key(const St &s, uint64_t &k2) {
  uint64_t a = 0; for (int i = 0; i < 12; i++) a = a << 5 | (s.r[i] == 255 ? 31 : s.r[i]);  // pool <= 27 terms
  uint64_t b = s.fa; b = b << 8 | s.fb; b = b << 32 | s.mask; k2 = b; return a;
}
struct H { size_t operator()(const pair<uint64_t, uint64_t> &p) const { return p.first * 0x9e3779b97f4a7c15ULL ^ p.second; } };
// cmov table: res[(fa*NP+fb)*4+c][d][s]
unordered_map<uint64_t, short> memo;
int cmovres(int fa, int fb, int c, int d, int s) {
  uint64_t k = (((uint64_t)fa * 256 + fb) * 4 + c) * 65536 + d * 256 + s;
  auto it = memo.find(k); if (it != memo.end()) return it->second;
  vector<u8> v(NT); const auto &A = col[fa], &B = col[fb], &D = col[d], &S = col[s];
  for (int t = 0; t < NT; t++) {
    int f = (A[t] > B[t]) - (A[t] < B[t]);
    bool mv = c == 0 ? f < 0 : c == 1 ? f <= 0 : c == 2 ? f > 0 : f >= 0;
    v[t] = mv ? S[t] : D[t];
  }
  auto j = idx.find(v); int r = j == idx.end() ? -1 : j->second;
  memo[k] = r; return r;
}
void norm(St &s) { sort(s.r, s.r + R); }
int main(int argc, char **argv) {
  FILE *f = fopen(argv[1], "r"); K = atoi(argv[2]); R = argc > 3 ? atoi(argv[3]) : 0;
  int x;
  vector<u8> cur;
  while (fscanf(f, "%d", &x) == 1) { cur.push_back(x); if ((int)cur.size() == NT) { if (!idx.count(cur)) { idx[cur] = col.size(); col.push_back(cur); } cur.clear(); } }
  NP = col.size(); fprintf(stderr, "pool %d terms\n", NP);
  // expected outputs: sorted ranks; compute from inputs
  for (int j = 0; j < 5; j++) {
    vector<u8> v(NT);
    for (int t = 0; t < NT; t++) { u8 a[5]; for (int i = 0; i < 5; i++) a[i] = col[i][t]; sort(a, a + 5); v[t] = a[j]; }
    outterm[j] = idx.count(v) ? idx[v] : -1;
    if (outterm[j] < 0) { fprintf(stderr, "output %d not in pool\n", j); return 1; }
  }
  // rules: flag (a<b), cond, d, s -> r (pool, r != d)
  int NB = NP - 5; if (NB > 24) {  // <= 29 pool terms: 5-bit key (sentinel 31), 32-bit masks still fit
    fprintf(stderr, "pool too big\n"); return 1; }
  auto bit = [&](int t) -> uint32_t { return t < 5 ? 0u : 1u << (t - 5); };
  uint32_t OUTM = 0; for (int j = 0; j < 5; j++) OUTM |= bit(outterm[j]);
  struct Rule { uint32_t need; int r; };
  vector<vector<Rule>> fr(NP * NP);
  long nrules = 0;
  for (int a = 0; a < NP; a++) for (int b = a + 1; b < NP; b++) for (int d = 0; d < NP; d++) for (int q = 0; q < NP; q++) {
    if (d == q) continue;
    for (int c = 0; c < 4; c++) { int r = cmovres(a, b, c, d, q); if (r < 0 || r == d || r < 5) continue;
      fr[a * NP + b].push_back({bit(a) | bit(b) | bit(d) | bit(q), r}); nrules++; }
  }
  fprintf(stderr, "rules %ld\n", nrules);
  // antichain reduction: per flag and result keep minimal need masks
  auto reduce = [&](vector<Rule> &v) { vector<Rule> o; sort(v.begin(), v.end(), [](const Rule &x, const Rule &y) { return __builtin_popcount(x.need) < __builtin_popcount(y.need); });
    for (auto &u : v) { bool dom = false; for (auto &w : o) if (w.r == u.r && !(w.need & ~u.need)) { dom = true; break; } if (!dom) o.push_back(u); } v.swap(o); };
  vector<Rule> allr; for (int f2 = 0; f2 < NP * NP; f2++) { reduce(fr[f2]); for (auto &u : fr[f2]) allr.push_back(u); }
  reduce(allr); fprintf(stderr, "reduced rules %zu\n", allr.size());
  vector<u8> remC(1u << NB, 99);
  auto closure = [&](uint32_t m, int a, int b) { if (a == 255) return m; if ((bit(a) | bit(b)) & ~m) return m; bool ch = true;
    while (ch) { ch = false; for (auto &u : fr[a * NP + b]) if (!(u.need & ~m) && !(m & bit(u.r))) { m |= bit(u.r); ch = true; } } return m; };
  for (long mm = (1L << NB) - 1; mm >= 0; mm--) { uint32_t m = mm;  // supersets have larger value? no: use popcount-free trick: m | bit > m
    if ((m & OUTM) == OUTM) { remC[m] = 0; continue; }
    int bc = 99; for (auto &u : allr) if (!(u.need & ~m) && !(m & bit(u.r))) { int v = remC[m | bit(u.r)]; if (v + 1 < bc) bc = v + 1; }
    remC[m] = bc; }
  unordered_map<uint32_t, u8> remBm;
  function<int(uint32_t)> remBf = [&](uint32_t m) -> int {
    if ((m & OUTM) == OUTM) return 0;
    auto it = remBm.find(m); if (it != remBm.end()) return it->second;
    int bb = 99; for (int a = 0; a < NP; a++) for (int b = a + 1; b < NP; b++) { if ((bit(a) | bit(b)) & ~m) continue; uint32_t m2 = closure(m, a, b); if (m2 != m) { int v = remBf(m2) + 1; if (v < bb) bb = v; } }
    remBm[m] = bb; return bb; };
  fprintf(stderr, "root: min creations %d, min cmp blocks %d\n", remC[0], remBf(0));
  { // judge fix: each mov adds <= 1 register; movs <= K - creations - cmps, so R >= 5 + K - remC - remB suffices
    int Rneed = 5 + K - remC[0] - remBf(0); if (Rneed > R) R = Rneed;
    if (R > 12) { printf("ABORT R needed %d > 12\n", R); return 2; }
    printf("R = %d (auto: 5 + K - creations - blocks = %d) [v2-live]\n", R, Rneed); fflush(stdout); }

  // Necessary liveness condition, checked on all distinct-input cases.
  // A rank not yet emitted must occur in a current register on every case.
  // Neither cmp nor a later copy/select can restore a lost value.
  vector<int> strictcases;
  for (int t=0;t<NT;t++) { set<u8> v;for(int j=0;j<5;j++)v.insert(col[j][t]);if(v.size()==5)strictcases.push_back(t); }
  const int NW=(strictcases.size()+63)/64;
  vector<vector<vector<uint64_t>>> cov(NP,vector<vector<uint64_t>>(5,vector<uint64_t>(NW)));
  vector<uint64_t> full(NW,~0ULL);if(strictcases.size()%64)full.back()=(1ULL<<(strictcases.size()%64))-1;
  for(int p=0;p<NP;p++)for(int j=0;j<5;j++)for(int k=0;k<(int)strictcases.size();k++)
    if(col[p][strictcases[k]]==j)cov[p][j][k/64]|=1ULL<<(k%64);
  unordered_map<uint32_t,u8> alivecache;
  auto alive = [&](const St &s) {
    uint32_t have=0;for(int i=0;i<R;i++)if(s.r[i]!=255)have|=1u<<s.r[i];
    u8 ok=0;auto it=alivecache.find(have);
    if(it!=alivecache.end())ok=it->second;
    else {
      for(int j=0;j<5;j++) {
        bool good=true;
        for(int k=0;k<NW;k++) {
          uint64_t u=0;uint32_t m=have;
          while(m){int p=__builtin_ctz(m);m&=m-1;u|=cov[p][j][k];}
          if(u!=full[k]){good=false;break;}
        }
        if(good)ok|=1<<j;
      }
      alivecache[have]=ok;
    }
    for(int j=0;j<5;j++)if(!(ok>>j&1) && !(s.mask&bit(outterm[j])))return false;
    return true;
  };
  St s0; memset(&s0, 255, sizeof s0); for (int i = 0; i < 5; i++) s0.r[i] = i; s0.mask = 0; norm(s0);
  vector<St> layer{s0}; vector<vector<St>> hist; vector<vector<int>> par; hist.push_back(layer); par.push_back({-1}); int curp = 0; vector<int> npar;
  unordered_set<pair<uint64_t, uint64_t>, H> seen;
  auto addmask = [&](St &s) { for (int i = 0; i < R; i++) if (s.r[i] != 255) s.mask |= bit(s.r[i]); };
  for (int depth = 1; depth <= K; depth++) {
    vector<St> next; npar.clear();
    auto push = [&](St s) {
      norm(s); addmask(s);
      if (!alive(s)) return;
      if (remC[s.mask] + depth > K) return; int h = remC[s.mask] + remBf(closure(s.mask, s.fa, s.fb));
      if (depth + h > K) return;
      if ((s.mask & OUTM) == OUTM && depth < K + 1) {
        static int nf = 0; if (nf++ < 3) { printf("FOUND depth %d path:\n", depth);
          vector<St> path{s}; int p = curp; for (int L2 = depth - 1; L2 >= 0; L2--) { path.push_back(hist[L2][p]); p = par[L2][p]; }
          reverse(path.begin(), path.end());
          for (auto &q : path) { printf("  regs"); for (int i = 0; i < R; i++) if (q.r[i] != 255) printf(" %d", q.r[i]); if (q.fa != 255) printf("  flag %d:%d", q.fa, q.fb); printf("\n"); }
          fflush(stdout); } }
      uint64_t k2, k1 = key(s, k2);
      if (seen.insert({k1, k2}).second) { next.push_back(s); npar.push_back(curp); }
    };
    for (curp = 0; curp < (int)layer.size(); curp++) { const St &s = layer[curp];
      if ((s.mask & OUTM) == OUTM) continue;
      int nr = 0; while (nr < R && s.r[nr] != 255) nr++;
      // mov: dest = any existing reg (overwrite) or a new reg
      for (int d = 0; d <= nr && d < R; d++) for (int q = 0; q < nr; q++) {
        if (d == q || (d < nr && s.r[d] == s.r[q])) continue;
        St t = s; t.r[d] = s.r[q]; push(t);
      }
      // drop a register for free? no: overwriting costs; but a dead reg is harmless.
      // cmp
      for (int a = 0; a < nr; a++) for (int b = a + 1; b < nr; b++) {
        if (s.r[a] == s.r[b]) continue;
        St t = s; t.fa = min(s.r[a], s.r[b]); t.fb = max(s.r[a], s.r[b]);
        if (t.fa == s.fa && t.fb == s.fb) continue;
        push(t);
      }
      // cmov
      if (s.fa != 255) for (int d = 0; d < nr; d++) for (int q = 0; q < nr; q++) {
        if (s.r[d] == s.r[q]) continue;
        for (int c = 0; c < 4; c++) {
          int r = cmovres(s.fa, s.fb, c, s.r[d], s.r[q]);
          if (r < 0 || r == s.r[d]) continue;
          St t = s; t.r[d] = r; push(t);
        }
      }
    }
    fprintf(stderr, "depth %d states %zu seen %zu\n", depth, next.size(), seen.size());
    if (seen.size() > 80000000) { printf("ABORT state limit at depth %d\n", depth); return 2; }
    layer.swap(next); hist.push_back(layer); par.push_back(npar);
    bool found = false; for (auto &s : layer) if ((s.mask & OUTM) == OUTM) found = true;
    if (found) { printf("MIN k = %d\n", depth); return 0; }
    if (layer.empty()) break;
  }
  printf("NONE <= %d\n", K);
}
