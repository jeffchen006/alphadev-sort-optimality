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
static void rec(vector<pair<Col, Col>>& sk) {
  int j = sk.size();
  Ctx x = classes(sk);
  if (j == C) { if (x.ncl < 120) return;
    for (size_t q = 0; q < sk.size(); q++) { printf("%s=", q ? " " : ""); for (int t = 0; t < 120; t++) putchar('0' + sk[q].first[t]); printf(":="); for (int t = 0; t < 120; t++) putchar('0' + sk[q].second[t]); }
    printf("\n"); if (++nout >= maxout) exit(0); return; }
  long bound = 1L << (C - j - 1);
  vector<Col> P; pool(sk, P); int NP = P.size();
  fprintf(stderr, "level %d pool %d classes %d\n", j + 1, NP, x.ncl);
  // per column: index per class
  vector<vector<uint8_t>> I(NP, vector<uint8_t>(x.ncl));
  for (int p = 0; p < NP; p++) for (int t = 0; t < 120; t++) I[p][x.lab[t]] = idxof(P[p], t);
  vector<vector<int>> mem(x.ncl); for (int t = 0; t < 120; t++) mem[x.lab[t]].push_back(t);
  // allowed[c][iu] = bitmask of iv such that cmp (x_iu vs x_iv) splits class c into parts <= bound
  vector<array<int, 5>> allowed(x.ncl);
  for (int c = 0; c < x.ncl; c++) for (int iu = 0; iu < 5; iu++) { int m = 0;
    for (int iv = 0; iv < 5; iv++) { int lt = 0, gt = 0, eq = 0; for (int t : mem[c]) { int a = TY[t][iu], b = TY[t][iv]; (a < b ? lt : a > b ? gt : eq)++; }
      if (lt <= bound && gt <= bound && eq <= bound) m |= 1 << iv; } allowed[c][iu] = m; }
  int W = (NP + 63) / 64;
  vector<vector<array<vector<uint64_t>, 5>>> B(1);  // B[c][i] bitset over pool: I[p][c] == i
  vector<array<vector<uint64_t>, 5>> Bc(x.ncl);
  for (int c = 0; c < x.ncl; c++) for (int i = 0; i < 5; i++) Bc[c][i].assign(W, 0);
  for (int p = 0; p < NP; p++) for (int c = 0; c < x.ncl; c++) Bc[c][I[p][c]][p >> 6] |= 1ULL << (p & 63);
  vector<uint64_t> cand(W), tmp(W);
  for (int u = 0; u < NP; u++) {
    fill(cand.begin(), cand.end(), ~0ULL);
    for (int c = 0; c < x.ncl && any_of(cand.begin(), cand.end(), [](uint64_t z) { return z; }); c++) {
      int m = allowed[c][I[u][c]]; fill(tmp.begin(), tmp.end(), 0);
      for (int i = 0; i < 5; i++) if (m >> i & 1) for (int w = 0; w < W; w++) tmp[w] |= Bc[c][i][w];
      for (int w = 0; w < W; w++) cand[w] &= tmp[w]; }
    for (int w = 0; w < W; w++) for (uint64_t z = cand[w]; z; z &= z - 1) { int v = w * 64 + __builtin_ctzll(z); if (v <= u) continue;
      sk.push_back({P[u], P[v]}); rec(sk); sk.pop_back(); }
  }
}
int main(int argc, char** argv) {
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
  fprintf(stderr, "skeletons %ld\n", nout);
}
