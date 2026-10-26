// critic: independent brute force for minimal core length k of a branchless
// mov/cmp/cmov sorting program on n inputs (all weak orders, values by rank).
// Shares no code with sat/enum. Relaxation as in MODEL.md §2: scratch = T (> all inputs),
// initial flags = eq, unbounded registers (fresh register always available).
// Output modes:
//   fixed    : at the end P_j holds the j-th smallest (MODEL.md v0 §1)
//   final    : at the end the j-th smallest is in SOME register, for each j
//   snapshot : for each j, some register at SOME time holds the j-th smallest on all inputs
//              (= AlphaDev store-once model with loads/stores removed)
// Iset: I0 = cmovl,cmovg ; I1 = I0 + cmovle,cmovge.
// Search: IDDFS + transposition table (128-bit hash of canonical state) + admissible h.
// Exact equivalences used: (a) flags F ~ swap(F) (cmp A,B vs cmp B,A; l<->g, le<->ge);
// (b) free modes: S_n relabelling of inputs (acts on orders only; targets invariant);
// (c) mov always into a fresh register in free modes (overwrite = fresh + drop; extra regs never hurt).
// usage: bf n mode iset maxk
#include <bits/stdc++.h>
using namespace std;
typedef uint64_t u64;
static int n, NORD, MODE, ISET;  // MODE 0 fixed,1 final,2 snapshot
static vector<vector<int>> ords;
typedef vector<uint8_t> Reg;
struct St { vector<Reg> r; vector<uint8_t> f; int mask; bool lastCmp = false; };
static bool FUSE = false, HPLUS = false;
static bool condf(int c, uint8_t fl) { if (c == 0) return fl == 1; if (c == 1) return fl == 2; if (c == 2) return fl != 2; return fl != 1; }
static vector<Reg> target;
static vector<vector<int>> permOrd;  // for each perm: order index map
static int T;

static u64 hmix(u64 h, u64 x) { h ^= x + 0x9e3779b97f4a7c15ULL + (h << 6) + (h >> 2); return h * 0xff51afd7ed558ccdULL; }
static pair<u64,u64> hashSt(const vector<Reg>& r, const vector<uint8_t>& f, int mask) {
  u64 a = 1469598103934665603ULL, b = 0x12345678abcdefULL;
  for (auto& x : r) { for (auto v : x) { a = hmix(a, v); b = b * 1099511628211ULL ^ (v + 7); } a = hmix(a, 255); b = b * 31 + 255; }
  for (auto v : f) { a = hmix(a, v + 300); b = b * 1099511628211ULL ^ (v + 301); }
  a = hmix(a, mask + 1000); b ^= (u64)mask * 0x9e3779b97f4a7c15ULL;
  return {a, b};
}
struct PH { size_t operator()(const pair<u64,u64>& p) const { return p.first ^ (p.second * 31); } };
static unordered_map<pair<u64,u64>, int, PH> TT;

static void canon(const St& s, vector<Reg>& br, vector<uint8_t>& bf) {
  bool first = true;
  int np = (MODE == 0) ? 1 : permOrd.size();
  for (int p = 0; p < np; p++) {
    const auto& pm = permOrd[p];
    vector<Reg> r(s.r.size(), Reg(NORD));
    for (size_t i = 0; i < s.r.size(); i++) for (int o = 0; o < NORD; o++) r[i][pm[o]] = s.r[i][o];
    vector<uint8_t> f(NORD), g(NORD);
    for (int o = 0; o < NORD; o++) { f[pm[o]] = s.f[o]; }
    for (int o = 0; o < NORD; o++) g[o] = f[o] == 1 ? 2 : f[o] == 2 ? 1 : 0;
    if (g < f) f = g;
    if (MODE == 0) sort(r.begin() + n, r.end()); else sort(r.begin(), r.end());
    if (first || make_pair(r, f) < make_pair(br, bf)) { br = r; bf = f; first = false; }
  }
}
static int h(const St& s) {
  int miss = 0;
  if (MODE == 0) { for (int j = 0; j < n; j++) if (s.r[j] != target[j]) miss++; }
  else if (MODE == 1) { for (int j = 0; j < n; j++) { bool ok = false; for (auto& x : s.r) if (x == target[j]) ok = true; if (!ok) miss++; } }
  else { miss = __builtin_popcount((~s.mask) & ((1 << n) - 1)); }
  if (miss == 0 || !HPLUS) return miss;
  // +1 if no missing target can be produced by ONE instruction now (current flags, current regs):
  // then the first target-producing write is preceded by >= 1 other instruction.
  // (Only valid for NORD <= 64: masks are u64.)
  u64 ALL = NORD == 64 ? ~0ULL : ((1ULL << NORD) - 1);
  u64 C[4] = {0, 0, 0, 0};
  for (int o = 0; o < NORD; o++) for (int c = 0; c < 4; c++) if (condf(c, s.f[o])) C[c] |= 1ULL << o;
  int nc = ISET ? 4 : 2;
  for (int j = 0; j < n; j++) {
    bool missing;
    if (MODE == 0) missing = s.r[j] != target[j];
    else if (MODE == 1) { missing = true; for (auto& x : s.r) if (x == target[j]) missing = false; }
    else missing = !((s.mask >> j) & 1);
    if (!missing) continue;
    vector<u64> M(s.r.size());
    for (size_t r = 0; r < s.r.size(); r++) { u64 b = 0; for (int o = 0; o < NORD; o++) if (s.r[r][o] == target[j][o]) b |= 1ULL << o; M[r] = b; }
    if (MODE == 0) { for (auto b : M) if (b == ALL) return miss; }  // mov P_j, S
    for (int c = 0; c < nc; c++) {
      if (C[c] == 0) continue;
      bool hasS = false, hasD = false;
      for (size_t r = 0; r < M.size(); r++) {
        if ((C[c] & ~M[r]) == 0) hasS = true;
        bool dok = ((~C[c] & ALL & ~M[r]) == 0);
        if (MODE == 0) { if ((int)r == j && dok) hasD = true; }
        else if (dok) hasD = true;
      }
      if ((~C[c] & ALL) == 0) hasD = true;  // D = fresh T register (or any) is fully overwritten
      if (hasS && hasD) return miss;
    }
  }
  return miss + 1;
}
static int updMask(int mask, const Reg& x) { for (int j = 0; j < n; j++) if (x == target[j]) mask |= 1 << j; return mask; }
static bool goal(const St& s) { bool hp = HPLUS; HPLUS = false; int v = h(s); HPLUS = hp; return v == 0; }
static vector<string> path;
static long long nodes = 0;
static string rn(const St& s, int i) {  // display name (indices are positions in current list; for info only)
  return "r" + to_string(i);
}
static bool cond(int c, uint8_t fl) {  // c: 0 l,1 g,2 le,3 ge ; fl 0 eq 1 lt 2 gt
  if (c == 0) return fl == 1; if (c == 1) return fl == 2; if (c == 2) return fl != 2; return fl != 1;
}
static const char* cn[4] = {"cmovl", "cmovg", "cmovle", "cmovge"};

static bool dfs(St& s, int rem) {
  nodes++;
  if (goal(s)) return true;
  if (rem == 0) return false;
  if (h(s) > rem) return false;
  vector<Reg> cr; vector<uint8_t> cf; canon(s, cr, cf);
  auto key = hashSt(cr, cf, (MODE == 2 ? s.mask : 0) | (s.lastCmp ? 64 : 0));
  auto it = TT.find(key);
  if (it != TT.end() && it->second >= rem) return false;
  int m = s.r.size();
  Reg Treg(NORD, T);
  // cmp
  bool flagsTrivial = true; for (auto v : s.f) if (v) flagsTrivial = false;
  // no cmp directly after cmp (the first one is dead)
  if (!s.lastCmp) for (int a = 0; a < m; a++) for (int b = a + 1; b < m; b++) {
    vector<uint8_t> f(NORD);
    for (int o = 0; o < NORD; o++) { int x = s.r[a][o], y = s.r[b][o]; f[o] = x < y ? 1 : x > y ? 2 : 0; }
    if (f == s.f) continue;
    St t = s; t.f = f; t.lastCmp = true;
    path.push_back("cmp r" + to_string(a) + ", r" + to_string(b));
    if (dfs(t, rem - 1)) return true;
    path.pop_back();
  }
  // cmov
  if (!flagsTrivial) {
    int nc = ISET ? 4 : 2;
    for (int c = 0; c < nc; c++) for (int d = 0; d <= m; d++) for (int sr = 0; sr <= m; sr++) {
      if (d == sr) continue;
      const Reg& D = d < m ? s.r[d] : Treg; const Reg& S = sr < m ? s.r[sr] : Treg;
      Reg nd = D; bool ch = false;
      for (int o = 0; o < NORD; o++) if (cond(c, s.f[o]) && nd[o] != S[o]) { nd[o] = S[o]; ch = true; }
      if (!ch) continue;
      St t = s; t.lastCmp = false; if (d < m) t.r[d] = nd; else t.r.push_back(nd);
      t.mask = updMask(t.mask, nd);
      path.push_back(string(cn[c]) + " " + (d < m ? "r" + to_string(d) : "new") + ", " + (sr < m ? "r" + to_string(sr) : "T"));
      if (dfs(t, rem - 1)) return true;
      path.pop_back();
      // fused "mov new, D ; cmovX new, S" (cost 2): keeps D, adds the cmov result as a new register
      if (FUSE && MODE != 0 && d < m && rem >= 2) {
        St u = s; u.lastCmp = false; u.r.push_back(nd); u.mask = updMask(u.mask, nd);
        path.push_back("mov new, r" + to_string(d) + " ; " + cn[c] + " new, " + (sr < m ? "r" + to_string(sr) : "T"));
        if (dfs(u, rem - 2)) return true;
        path.pop_back();
      }
    }
  }
  // mov
  for (int sr = 0; sr <= m; sr++) {
    const Reg& S = sr < m ? s.r[sr] : Treg;
    if (MODE != 0) {
      if (sr == m || FUSE) continue;
      St t = s; t.lastCmp = false; t.r.push_back(S);
      path.push_back("mov new, r" + to_string(sr));
      if (dfs(t, rem - 1)) return true;
      path.pop_back();
    } else {
      for (int d = 0; d <= n && d <= m; d++) {  // d<n: overwrite P_d ; d==n: fresh
        int dd = d < n ? d : m;
        if (dd == sr) continue;
        if (d < n && s.r[d] == S) continue;
        if (d == n && sr == m) continue;
        St t = s; t.lastCmp = false; if (d < n) t.r[d] = S; else t.r.push_back(S);
        path.push_back("mov " + (d < n ? "r" + to_string(d) : string("new")) + ", " + (sr < m ? "r" + to_string(sr) : "T"));
        if (dfs(t, rem - 1)) return true;
        path.pop_back();
      }
    }
  }
  TT[key] = rem;
  return false;
}

int main(int argc, char** argv) {
  n = atoi(argv[1]); string md = argv[2]; ISET = string(argv[3]) == "I1"; int maxk = atoi(argv[4]); for (int a = 5; a < argc; a++) { if (string(argv[a]) == "fuse") FUSE = true; if (string(argv[a]) == "hplus") HPLUS = true; }
  MODE = md == "fixed" ? 0 : md == "final" ? 1 : 2;
  T = n;
  // weak orders as rank vectors
  set<vector<int>> S;
  vector<int> t(n, 0);
  function<void(int)> gen = [&](int i) {
    if (i == n) { set<int> u(t.begin(), t.end()); vector<int> s(u.begin(), u.end()); vector<int> r(n);
      for (int k = 0; k < n; k++) r[k] = lower_bound(s.begin(), s.end(), t[k]) - s.begin(); S.insert(r); return; }
    for (int v = 0; v < n; v++) { t[i] = v; gen(i + 1); } };
  gen(0);
  ords.assign(S.begin(), S.end()); NORD = ords.size();
  map<vector<int>, int> idx; for (int o = 0; o < NORD; o++) idx[ords[o]] = o;
  vector<int> p(n); iota(p.begin(), p.end(), 0);
  do { vector<int> pm(NORD); for (int o = 0; o < NORD; o++) { vector<int> q(n); for (int i = 0; i < n; i++) q[i] = ords[o][p[i]]; pm[o] = idx[q]; } permOrd.push_back(pm); } while (next_permutation(p.begin(), p.end()));
  target.assign(n, Reg(NORD));
  for (int o = 0; o < NORD; o++) { vector<int> s = ords[o]; sort(s.begin(), s.end()); for (int j = 0; j < n; j++) target[j][o] = s[j]; }
  St s0; s0.f.assign(NORD, 0); s0.mask = 0;
  for (int i = 0; i < n; i++) { Reg x(NORD); for (int o = 0; o < NORD; o++) x[o] = ords[o][i]; s0.r.push_back(x); s0.mask = updMask(s0.mask, x); }
  printf("n=%d orders=%d mode=%s iset=%s fuse=%d\n", n, NORD, md.c_str(), ISET ? "I1" : "I0", FUSE); fflush(stdout);
  for (int k = 0; k <= maxk; k++) {
    auto t0 = chrono::steady_clock::now();
    path.clear(); bool ok = dfs(s0, k);
    double dt = chrono::duration<double>(chrono::steady_clock::now() - t0).count();
    printf("k=%d %s nodes=%lld TT=%zu time=%.1fs\n", k, ok ? "SAT" : "UNSAT", nodes, TT.size(), dt); fflush(stdout);
    if (ok) { for (auto& l : path) printf("  %s\n", l.c_str()); break; }
  }
}
