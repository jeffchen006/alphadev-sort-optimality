// complete.cpp -- d5-extend: complete a fixed c-cmp prefix skeleton (explicit columns, 120 perms) by R more cmps whose
// operands come from POOL = V2 (min/max closure depth 2 of the prefix operand columns, index-consistent at the block)
// U one-select columns sel(f_k; A, B) = (gt_k ? A : B), A, B in V2, k = any earlier cmp (prefix or new).
// Each new cmp must keep classes <= 2^(C-j) (binary cmps on perms); final classes singletons.
// Exact over this pool (per-class allowed index sets + bitsets). Output: full skeletons, one per line (dagx explicit).
// usage: complete PREFIXFILE C [maxout] > out
#include <bits/stdc++.h>
using namespace std;
typedef array<uint8_t, 120> Col;
static vector<array<uint8_t, 5>> TY;
static vector<pair<Col, Col>> pre;
static int C; static long maxout = 1000000, nout = 0;
static inline int idxof(const Col& c, int t) { for (int k = 0; k < 5; k++) if (TY[t][k] == c[t]) return k; return -1; }
struct Ctx { vector<int> lab; int ncl; };
static Ctx classes(const vector<pair<Col, Col>>& sk) {
  Ctx x; x.lab.assign(120, 0); vector<long> h(120, 0);
  for (auto& [a, b] : sk) for (int t = 0; t < 120; t++) h[t] = h[t] * 3 + (a[t] < b[t] ? 0 : a[t] > b[t] ? 2 : 1);
  map<long, int> m; for (int t = 0; t < 120; t++) x.lab[t] = m.emplace(h[t], m.size()).first->second; x.ncl = m.size(); return x; }
static bool consistent(const Col& c, const Ctx& x) {
  vector<int> id(x.ncl, -1); for (int t = 0; t < 120; t++) { int i = idxof(c, t); if (id[x.lab[t]] < 0) id[x.lab[t]] = i; else if (id[x.lab[t]] != i) return false; } return true; }
static vector<Col> V2;
static void pool(const vector<pair<Col, Col>>& sk, vector<Col>& P) {
  Ctx x = classes(sk); set<Col> S;
  for (auto& c : V2) if (consistent(c, x)) S.insert(c);
  for (size_t k = 0; k < sk.size(); k++) {
    auto& [a, b] = sk[k]; vector<bool> g(120); for (int t = 0; t < 120; t++) g[t] = a[t] > b[t];
    // halves: distinct restrictions to gt / lt types, consistent per class there
    set<vector<uint8_t>> GT, LT;
    for (auto& c : V2) {
      vector<int> id(x.ncl, -1); bool okg = true, okl = true;
      vector<int> idl(x.ncl, -1);
      for (int t = 0; t < 120; t++) { int i = idxof(c, t); auto& r = g[t] ? id : idl; bool& ok = g[t] ? okg : okl; if (r[x.lab[t]] < 0) r[x.lab[t]] = i; else if (r[x.lab[t]] != i) ok = false; }
      vector<uint8_t> hg, hl; for (int t = 0; t < 120; t++) (g[t] ? hg : hl).push_back(c[t]);
      if (okg) GT.insert(hg); if (okl) LT.insert(hl); }
    for (auto& A : GT) for (auto& B : LT) { Col c; int ia = 0, ib = 0; for (int t = 0; t < 120; t++) c[t] = g[t] ? A[ia++] : B[ib++]; S.insert(c); }
  }
  P.assign(S.begin(), S.end()); }

// PAIR-TRACKING class: completion cmp = sel(f_k; X1, Y1) vs sel(f_k; X2, Y2), one flag k (any earlier cmp),
// X*, Y* in V2 (min/max closure depth 2 of prefix operands). Classes refine f_k, so the split test decouples:
// gt half needs (X1, X2), lt half needs (Y1, Y2). Includes lattice cmps (X = Y).
static vector<vector<pair<vector<uint8_t>, vector<uint8_t>>>> dummy;
static void halfpairs(const Ctx& x, const vector<bool>& H, long bound, vector<pair<vector<uint8_t>, vector<uint8_t>>>& out) {
  // distinct restrictions of V2 to types in H, consistent per class
  set<vector<uint8_t>> R;
  for (auto& c : V2) { vector<int> id(x.ncl, -1); bool ok = true; vector<uint8_t> h;
    for (int t = 0; t < 120 && ok; t++) if (H[t]) { int i = idxof(c, t); if (id[x.lab[t]] < 0) id[x.lab[t]] = i; else if (id[x.lab[t]] != i) ok = false; h.push_back(c[t]); }
    if (ok) R.insert(h); }
  vector<vector<uint8_t>> Rv(R.begin(), R.end()); vector<int> ty; for (int t = 0; t < 120; t++) if (H[t]) ty.push_back(t);
  for (size_t a = 0; a < Rv.size(); a++) for (size_t b = 0; b < Rv.size(); b++) {
    map<int, array<int, 3>> cnt; bool ok = true;
    for (size_t q = 0; q < ty.size() && ok; q++) { int o = Rv[a][q] < Rv[b][q] ? 0 : Rv[a][q] > Rv[b][q] ? 2 : 1; if (++cnt[x.lab[ty[q]]][o] > bound) ok = false; }
    if (ok) out.push_back({Rv[a], Rv[b]}); } }
static long nexp = 0, skipped = 0;
static void rec(vector<pair<Col, Col>>& sk) {
  int j = sk.size();
  Ctx x = classes(sk);
  if (j == C) { if (x.ncl < 120) return;
    static double sp = getenv("SAMPLEP") ? atof(getenv("SAMPLEP")) : 1.0; static long tot = 0; tot++;
    for (size_t q = 0; q < sk.size(); q++) { printf("%s=", q ? " " : ""); for (int t = 0; t < 120; t++) putchar('0' + sk[q].first[t]); printf(":="); for (int t = 0; t < 120; t++) putchar('0' + sk[q].second[t]); }
    printf("\n"); if (++nout >= maxout) exit(0); return; }
  long bound = 1L << (C - j - 1);
  set<pair<Col, Col>> seen;
  // flag sets: one flag k, or two flags k1 < k2 (PT2: parts = flag-history quarters, each part its own lattice pair)
  vector<vector<int>> FS; for (int k = 0; k < j; k++) FS.push_back({k});
  if (getenv("PT2")) for (int k1 = 0; k1 < j; k1++) for (int k2 = k1 + 1; k2 < j; k2++) if (!getenv("PT2LAST") || (k2 == j - 1 && j > (int)pre.size())) FS.push_back({k1, k2});
  for (auto& fs : FS) {
    int np = 1 << fs.size(); vector<int> part(120, 0);
    for (int t = 0; t < 120; t++) { int p = 0; for (size_t q = 0; q < fs.size(); q++) p |= (sk[fs[q]].first[t] > sk[fs[q]].second[t]) << q; part[t] = p; }
    vector<vector<pair<vector<uint8_t>, vector<uint8_t>>>> PP(np); bool empty = false; long prod = 1;
    for (int p = 0; p < np; p++) { vector<bool> H(120); int sz = 0; for (int t = 0; t < 120; t++) { H[t] = part[t] == p; sz += H[t]; }
      if (sz == 0) { PP[p].push_back({{}, {}}); continue; }
      halfpairs(x, H, bound, PP[p]); if (PP[p].empty()) { empty = true; break; } prod *= PP[p].size(); }
    if (empty) continue;
    if (j == (int)pre.size() || getenv("VERB")) fprintf(stderr, "level %d flags", j + 1), [&]{ for (int k : fs) fprintf(stderr, " %d", k + 1); fprintf(stderr, " combos %ld\n", prod); }();
    if (!(getenv("SAMPLEP") && j == C - 1) && prod > (long)(getenv("MAXPROD") ? atol(getenv("MAXPROD")) : 2000000)) { fprintf(stderr, "  skip (MAXPROD)\n"); skipped++; continue; }
    vector<int> ix(np, 0);
    double sp = getenv("SAMPLEP") ? atof(getenv("SAMPLEP")) : 1.0;
    if (sp < 1.0 && j == C - 1) {  // last cmp: draw round(prod * sp) random combos (with prob. rounding)
      double want = prod * sp; long nd = (long)want; if (drand48() < want - nd) nd++;
      for (long d = 0; d < nd; d++) {
        for (int p = 0; p < np; p++) ix[p] = lrand48() % PP[p].size();
        Col u, v; vector<int> pos(np, 0);
        for (int t = 0; t < 120; t++) { int p = part[t]; auto& pr = PP[p][ix[p]]; u[t] = pr.first[pos[p]]; v[t] = pr.second[pos[p]]; pos[p]++; }
        if (v < u) swap(u, v);
        if (!(u == v) && seen.insert({u, v}).second) { sk.push_back({u, v}); rec(sk); sk.pop_back(); } }
      continue; }
    while (true) {
      Col u, v; vector<int> pos(np, 0);
      for (int t = 0; t < 120; t++) { int p = part[t]; auto& pr = PP[p][ix[p]]; u[t] = pr.first[pos[p]]; v[t] = pr.second[pos[p]]; pos[p]++; }
      if (v < u) swap(u, v);
      if (!(u == v) && seen.insert({u, v}).second) { sk.push_back({u, v}); rec(sk); sk.pop_back(); }
      int q = 0; while (q < np && ++ix[q] == (int)PP[q].size()) { ix[q] = 0; q++; } if (q == np) break; }
  }
}
int main(int argc, char** argv) {
  srand48(getenv("SEED") ? atol(getenv("SEED")) : 1);
  C = atoi(argv[2]); if (argc > 3) maxout = atol(argv[3]);
  array<uint8_t, 5> p = {0, 1, 2, 3, 4}; do TY.push_back(p); while (next_permutation(p.begin(), p.end()));
  ifstream in(argv[1]); string w; int m = 0;
  while (in >> w) { if (w[0] == '#') { getline(in, w); continue; } size_t c = w.find(':'); string a = w.substr(1, c - 1), b = w.substr(c + 2);
    Col x, y; for (int t = 0; t < 120; t++) { x[t] = a[t] - '0'; y[t] = b[t] - '0'; } pre.push_back({x, y}); }
  int M = atoi(getenv("PREFIX") ? getenv("PREFIX") : "6"); pre.resize(M);
  set<Col> V0; for (auto& [a, b] : pre) { V0.insert(a); V0.insert(b); }
  auto clos = [](const set<Col>& V) { set<Col> W = V; for (auto& a : V) for (auto& b : V) { Col mn, mx; for (int t = 0; t < 120; t++) { mn[t] = min(a[t], b[t]); mx[t] = max(a[t], b[t]); } W.insert(mn); W.insert(mx); } return W; };
  auto V1 = clos(V0); auto V2s = clos(V1); V2.assign(V2s.begin(), V2s.end());
  fprintf(stderr, "prefix %d cmps, V0 %zu V1 %zu V2 %zu\n", M, V0.size(), V1.size(), V2.size());
  vector<pair<Col, Col>> sk = pre; rec(sk);
  fprintf(stderr, "skeletons %ld skipped(MAXPROD) %ld\n", nout, skipped);
}
