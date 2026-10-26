// critic: brute force for the MEMORY models (MODEL.md §4.2 M_AD = "mem", §4.5 MM+ = "memplus").
// Every instruction counts (load, store, mov, cmp, cmov). n cells hold x at the start and must hold sort(x)
// at the end. Registers unbounded, T-relaxed (registers start T > all inputs, cmp(T,T)=eq, flags eq).
// mem    : cells are touched only by load (mov r, cell) and store (mov cell, r).
// memplus: in addition cmp may read ONE cell, cmov may read a cell as SOURCE (never as destination).
// State (exact, MODEL §4.5): cells in order, MULTISET of register vectors, flags up to lt<->gt swap,
// bit "last instruction was cmp". Values by rank per weak order (T = n).
// Prunings: load/mov write a fresh register (an extra register never hurts); no cmp right after cmp;
// no-op instructions skipped; no store of T (a T cell is never a goal and reading it = reading a T register).
// h = #cells not at goal (each needs its own store) + #their goal vectors held by no register
//     (each needs its own register write: a store copies a register).
// usage: bf_mm n {mem|memplus} {I0|I1} maxL [hc]
#include <bits/stdc++.h>
using namespace std;
typedef uint64_t u64;
typedef vector<uint8_t> Reg;
static int n, NORD, PLUS, ISET, T;
static vector<Reg> target;
static bool HC = false; static vector<int> perm; static vector<vector<uint8_t>> inv;
struct St { vector<Reg> cell, r; vector<uint8_t> f; bool lastCmp = false; };
static u64 hmix(u64 h, u64 x) { h ^= x + 0x9e3779b97f4a7c15ULL + (h << 6) + (h >> 2); return h * 0xff51afd7ed558ccdULL; }
struct PH { size_t operator()(const pair<u64,u64>& p) const { return p.first ^ (p.second * 31); } };
static unordered_map<pair<u64,u64>, int, PH> TT;
static long long nodes = 0;
static vector<string> path;

static pair<u64,u64> key(const St& s) {
  vector<Reg> r = s.r; sort(r.begin(), r.end());
  vector<uint8_t> f = s.f, g(NORD);
  for (int o = 0; o < NORD; o++) g[o] = f[o] == 1 ? 2 : f[o] == 2 ? 1 : 0;
  if (g < f) f = g;
  u64 a = 1469598103934665603ULL, b = 0x12345678abcdefULL;
  auto add = [&](u64 v) { a = hmix(a, v); b = b * 1099511628211ULL ^ (v + 7); };
  for (auto& x : s.cell) { for (auto v : x) add(v); add(500); }
  add(600);
  for (auto& x : r) { for (auto v : x) add(v); add(255); }
  for (auto v : f) add(v + 300);
  add(s.lastCmp ? 1001 : 1002);
  return {a, b};
}
static int h(const St& s) {
  int st = 0, wr = 0;
  for (int j = 0; j < n; j++) if (s.cell[j] != target[j]) {
    st++;
    bool have = false; for (auto& x : s.r) if (x == target[j]) { have = true; break; }
    if (!have) wr++;
  }
  if (st == 0) return 0;
  if (!HC) return st + wr;
  // hc: permutations with equal (flags, index content of every cell and register) form a class; at the goal every
  // class is a singleton (cells hold sigma^-1); a cmp splits a class into <= 2 (same content pair on the class).
  // A shortest completion has no dead cmp, so #cmov >= #cmp >= hc; cmps, stores, register writes are disjoint kinds.
  vector<vector<uint8_t>> keys;
  for (int pi = 0; pi < (int)perm.size(); pi++) {
    int o = perm[pi]; vector<uint8_t> kk; kk.push_back(s.f[o]);
    for (auto& x : s.cell) kk.push_back(x[o] == T ? n : inv[pi][x[o]]);
    vector<uint8_t> rr; for (auto& x : s.r) rr.push_back(x[o] == T ? n : inv[pi][x[o]]);
    for (auto v : rr) kk.push_back(v);
    keys.push_back(kk);
  }
  // registers are a multiset: compare per-register columns, so sort registers jointly is NOT allowed per perm;
  // keys above use the same register order for all perms (one state), which is what the class needs.
  sort(keys.begin(), keys.end());
  int best = 1, run = 1;
  for (size_t i = 1; i < keys.size(); i++) { if (keys[i] == keys[i-1]) { run++; best = max(best, run); } else run = 1; }
  int hc = 0; while ((1 << hc) < best) hc++;
  return st + hc + max(wr, hc);
}
static bool cond(int c, uint8_t fl) { if (c == 0) return fl == 1; if (c == 1) return fl == 2; if (c == 2) return fl != 2; return fl != 1; }
static const char* cn[4] = {"cmovl", "cmovg", "cmovle", "cmovge"};
static string cname(int j) { return "C" + to_string(j); }

static bool dfs(St& s, int rem) {
  nodes++;
  int hv = h(s);
  if (hv == 0) return true;
  if (hv > rem) return false;
  auto k = key(s);
  auto it = TT.find(k);
  if (it != TT.end() && it->second >= rem) return false;
  int m = s.r.size();
  Reg Treg(NORD, T);
  // operand list for reads: registers 0..m-1, cells m..m+n-1, T = m+n
  auto opnd = [&](int i) -> const Reg& { return i < m ? s.r[i] : i < m + n ? s.cell[i - m] : Treg; };
  auto oname = [&](int i) { return i < m ? "r" + to_string(i) : i < m + n ? cname(i - m) : string("T"); };
  int NOP = m + n + 1;
  // store
  for (int j = 0; j < n; j++) for (int r = 0; r < m; r++) {
    if (s.cell[j] == s.r[r]) continue;
    St t = s; t.lastCmp = false; t.cell[j] = s.r[r];
    path.push_back("mov " + cname(j) + ", r" + to_string(r));
    if (dfs(t, rem - 1)) return true;
    path.pop_back();
  }
  // load
  for (int j = 0; j < n; j++) {
    St t = s; t.lastCmp = false; t.r.push_back(s.cell[j]);
    path.push_back("mov new, " + cname(j));
    if (dfs(t, rem - 1)) return true;
    path.pop_back();
  }
  // mov reg -> fresh
  for (int r = 0; r < m; r++) {
    St t = s; t.lastCmp = false; t.r.push_back(s.r[r]);
    path.push_back("mov new, r" + to_string(r));
    if (dfs(t, rem - 1)) return true;
    path.pop_back();
  }
  // cmp
  if (!s.lastCmp) for (int a = 0; a < NOP; a++) for (int b = a + 1; b < NOP; b++) {
    bool ca = a >= m && a < m + n, cb = b >= m && b < m + n;
    if ((ca || cb) && !PLUS) continue;
    if (ca && cb) continue;
    const Reg& A = opnd(a); const Reg& B = opnd(b);
    vector<uint8_t> f(NORD);
    for (int o = 0; o < NORD; o++) f[o] = A[o] < B[o] ? 1 : A[o] > B[o] ? 2 : 0;
    if (f == s.f) continue;
    St t = s; t.f = f; t.lastCmp = true;
    path.push_back("cmp " + oname(a) + ", " + oname(b));
    if (dfs(t, rem - 1)) return true;
    path.pop_back();
  }
  // cmov D (register or fresh T), S (register, [cell if PLUS], T)
  bool flagsTrivial = true; for (auto v : s.f) if (v) flagsTrivial = false;
  if (!flagsTrivial || ISET) {
    int nc = ISET ? 4 : 2;
    for (int c = 0; c < nc; c++) for (int d = 0; d <= m; d++) for (int sr = 0; sr < NOP; sr++) {
      if (sr == d && d < m) continue;
      if (sr >= m && sr < m + n && !PLUS) continue;
      const Reg& D = d < m ? s.r[d] : Treg; const Reg& S = opnd(sr);
      Reg nd = D; bool ch = false;
      for (int o = 0; o < NORD; o++) if (cond(c, s.f[o]) && nd[o] != S[o]) { nd[o] = S[o]; ch = true; }
      if (!ch) continue;
      bool allT = true; for (auto v : nd) if (v != T) allT = false;
      if (allT) continue;
      St t = s; t.lastCmp = false; if (d < m) t.r[d] = nd; else t.r.push_back(nd);
      path.push_back(string(cn[c]) + " " + (d < m ? "r" + to_string(d) : string("new")) + ", " + oname(sr));
      if (dfs(t, rem - 1)) return true;
      path.pop_back();
    }
  }
  TT[k] = rem;
  return false;
}

int main(int argc, char** argv) {
  n = atoi(argv[1]); PLUS = string(argv[2]) == "memplus"; ISET = string(argv[3]) == "I1"; int maxL = atoi(argv[4]);
  T = n;
  set<vector<int>> S; vector<int> t(n);
  function<void(int)> gen = [&](int i) {
    if (i == n) { set<int> u(t.begin(), t.end()); vector<int> v(u.begin(), u.end()); vector<int> r(n);
      for (int q = 0; q < n; q++) r[q] = lower_bound(v.begin(), v.end(), t[q]) - v.begin(); S.insert(r); return; }
    for (int v = 0; v < n; v++) { t[i] = v; gen(i + 1); } };
  gen(0);
  vector<vector<int>> ords(S.begin(), S.end()); NORD = ords.size();
  target.assign(n, Reg(NORD));
  for (int o = 0; o < NORD; o++) { auto v = ords[o]; sort(v.begin(), v.end()); for (int j = 0; j < n; j++) target[j][o] = v[j]; }
  for (int o = 0; o < NORD; o++) { set<int> u(ords[o].begin(), ords[o].end()); if ((int)u.size() == n) {
      perm.push_back(o); vector<uint8_t> iv(n); for (int i = 0; i < n; i++) iv[ords[o][i]] = i; inv.push_back(iv); } }
  HC = argc > 5 && string(argv[5]) == "hc";
  St s0; s0.f.assign(NORD, 0);
  for (int i = 0; i < n; i++) { Reg x(NORD); for (int o = 0; o < NORD; o++) x[o] = ords[o][i]; s0.cell.push_back(x); }
  printf("n=%d orders=%d model=%s iset=%s hc=%d\n", n, NORD, PLUS ? "memplus" : "mem", ISET ? "I1" : "I0", (int)HC); fflush(stdout);
  for (int L = 0; L <= maxL; L++) {
    auto t0 = chrono::steady_clock::now();
    path.clear(); bool ok = dfs(s0, L);
    double dt = chrono::duration<double>(chrono::steady_clock::now() - t0).count();
    printf("L=%d %s nodes=%lld TT=%zu time=%.1fs\n", L, ok ? "SAT" : "UNSAT", nodes, TT.size(), dt); fflush(stdout);
    if (ok) { for (auto& l : path) printf("  %s\n", l.c_str()); break; }
  }
}
