// vsk.cpp -- d1-skeleton: exact routing search for a FIXED VALUE skeleton (sort5, M_out, I1).
// Set model of agents/enum/PRUNING.md (Lemma S, M): state = set A of columns over the order types,
// j = number of cmps done, done = outputs taken. cmp j+1 must compare columns a_{j+1}, b_{j+1} (both in A).
// Ops: cmp (cost 1); cmovX in place (cost 1); cmovX into a copy (cost 2 = mov + cmov).
// Lower bound h = (c-j) cmps + max(#missing needed columns, #blocks still needing a cmov).
//   needed = operands of cmps j+1..c plus undone targets; only a cmov creates a new column, one per cmov.
//   every block (after each cmp) holds >= 1 cmov (else the cmp is useless and the program has a shorter form).
// Dead rule: a needed value that no column holds at some order type (cmov only copies values).
// Partial-order reduction: two adjacent independent cmovs in one block appear in hash order of their results.
// Types: strict permutations (sound relaxation for "no program"); found programs must be judged on all weak orders.
// usage: vsk SKELFILE K [TTLOG2] [ALLSOL]   (SKELFILE: c lines "a:b" lattice formulas, e.g. 12|34:0)
#include <bits/stdc++.h>
using namespace std;
typedef uint64_t u64; typedef uint8_t u8;
static const int N = 5, NTY = 120;
struct Col { u8 v[NTY]; };
static vector<array<u8, N>> ty;
static int C, K;
static vector<Col> opa, opb;     // cmp operand columns
static vector<vector<u8>> F;     // F[j][t]: 1 lt, 2 gt, 0 eq (cmp a_j, b_j)
static Col tgt[N];
static u64 hcol(const Col& c) { u64 h = 1469598103934665603ULL; for (int i = 0; i < NTY; i++) { h ^= c.v[i]; h *= 1099511628211ULL; } return h ^ (h >> 29); }
static int evf(const string& f, const array<u8, N>& x) {
  int best = -1; size_t p = 0;
  while (p <= f.size()) { size_t q = f.find('|', p); if (q == string::npos) q = f.size();
    int m = 99; for (size_t i = p; i < q; i++) m = min(m, (int)x[f[i] - '0']); best = max(best, m); p = q + 1; }
  return best; }
static inline bool condHolds(int c, u8 f) { switch (c) { case 0: return f == 1; case 1: return f == 2; case 2: return f != 2; default: return f != 1; } }
static const char* CN[4] = {"cmovl", "cmovg", "cmovle", "cmovge"};

struct St { vector<Col> A; vector<u64> H; int j; int done; bool blockHasCmov; u64 lastM, lastD, lastS; int lastKind; };
// needed columns (hashes) for (j, done)
static vector<u64> needH[16][32];
static vector<Col> needC[16][32];
static u8 needMask[16][32][NTY];
static u64 *TT; static u8 *TTg; static u64 TTmask;
static long long nodes = 0; static int ALLSOL = 0; static long long nsol = 0;
static vector<string> prog;

static int hval(const St& s) {
  int jl = C - s.j;
  int miss = 0;
  for (u64 h : needH[s.j][s.done]) { bool in = false; for (u64 x : s.H) if (x == h) { in = true; break; } if (!in) miss++; }
  int blocks = jl + ((s.j >= 1 && !s.blockHasCmov) ? 1 : 0);
  return jl + max(miss, blocks);
}
static bool dead(const St& s) {
  const u8* nm = needMask[s.j][s.done];
  for (int t = 0; t < NTY; t++) { u8 pres = 0; for (auto& c : s.A) pres |= 1 << c.v[t]; if ((pres & nm[t]) != nm[t]) return true; }
  return false;
}
static int doneOf(const St& s, int done) {
  for (int k = 0; k < N; k++) if (!(done >> k & 1)) for (u64 h : s.H) if (h == hcol(tgt[k]) && 1) { done |= 1 << k; break; }
  return done;
}
static u64 tgtH[N];
static string cname(u64 h) { char b[32]; snprintf(b, 32, "c%04llx", (unsigned long long)(h & 0xffff)); return b; }

static bool dfs(St& s, int g) {
  nodes++;
  if ((nodes & ((1LL << 26) - 1)) == 0) { fprintf(stderr, "nodes=%lld depth=%zu g=%d j=%d\n", nodes, prog.size(), g, s.j); }
  if (s.j == C && s.done == 31 && s.blockHasCmov) {
    nsol++;
    printf("SOLUTION cost=%d\n", g); for (auto& l : prog) printf("  %s\n", l.c_str()); fflush(stdout);
    return !ALLSOL;
  }
  if (g + hval(s) > K) return false;
  if (dead(s)) return false;
  // transposition table: key = state (sorted hashes, j, done, blockHasCmov, last M)
  { vector<u64> hs = s.H; sort(hs.begin(), hs.end()); u64 k = 0x9e3779b97f4a7c15ULL * (s.j + 1) ^ (u64)s.done << 40 ^ (u64)s.blockHasCmov << 50;
    for (u64 x : hs) k = (k ^ x) * 0xff51afd7ed558ccdULL; k ^= s.lastM * 0xc4ceb9fe1a85ec53ULL; k = (k ^ s.lastD) * 0xff51afd7ed558ccdULL; k = (k ^ s.lastS ^ (u64)(s.lastKind + 2) << 60) * 0xff51afd7ed558ccdULL; k |= 1;
    u64 i = (k >> 7) & TTmask;
    if (TT[i] == k && TTg[i] <= g) return false;
    TT[i] = k; TTg[i] = g; }
  // cmp
  if (s.j < C && (s.j == 0 || s.blockHasCmov) && g + 1 <= K) {
    u64 ha = hcol(opa[s.j]), hb = hcol(opb[s.j]); bool ia = false, ib = false;
    for (u64 x : s.H) { ia |= x == ha; ib |= x == hb; }
    if (ia && ib) {
      St t = s; t.j++; t.blockHasCmov = false; t.lastM = 0; t.lastKind = -1;
      prog.push_back("cmp " + cname(ha) + ", " + cname(hb));
      if (dfs(t, g + 1)) return true;
      prog.pop_back();
    }
  }
  if (s.j == 0) return false;
  const vector<u8>& f = F[s.j - 1];
  bool haveEq = false; for (int t = 0; t < NTY; t++) haveEq |= f[t] == 0;
  int na = s.A.size();
  for (int d = 0; d < na; d++) for (int sr = 0; sr < na; sr++) { if (d == sr) continue;
    for (int cd = 0; cd < 4; cd++) {
      if (!haveEq && cd >= 2) continue;  // le/ge == l/g when no eq flag
      Col M; bool ch = false;
      for (int t = 0; t < NTY; t++) { M.v[t] = condHolds(cd, f[t]) ? s.A[sr].v[t] : s.A[d].v[t]; ch |= M.v[t] != s.A[d].v[t]; }
      if (!ch) continue;
      u64 hm = hcol(M); bool ex = false; for (u64 x : s.H) if (x == hm) { ex = true; break; } if (ex) continue;
      for (int kind = 1; kind <= 2; kind++) {
        int cost = kind;
        if (g + cost > K) continue;
        // POR: previous op in this block (lastM etc.) independent of this one -> require lastM < hm
        if (s.lastKind > 0) {
          bool dep = (s.H[d] == s.lastM) || (s.H[sr] == s.lastM) || (hm == s.lastD) || (hm == s.lastS);
          if (kind == 1 && (s.H[d] == s.lastS || s.H[d] == s.lastD)) dep = true;
          if (!dep && !(s.lastM < hm)) continue;
        }
        St t = s; t.blockHasCmov = true; t.lastM = hm; t.lastD = s.H[d]; t.lastS = s.H[sr]; t.lastKind = kind;
        if (kind == 1) { t.A[d] = M; t.H[d] = hm; } else { t.A.push_back(M); t.H.push_back(hm); }
        t.done = doneOf(t, t.done);
        char b[96]; snprintf(b, 96, "%s%s %s<-%s => %s", kind == 2 ? "copy+" : "", CN[cd], cname(s.H[d]).c_str(), cname(s.H[sr]).c_str(), cname(hm).c_str());
        prog.push_back(b);
        if (dfs(t, g + cost)) return true;
        prog.pop_back();
      }
    }
  }
  return false;
}

int main(int argc, char** argv) {
  if (argc < 3) { fprintf(stderr, "usage: vsk SKELFILE K [TTLOG2] [ALLSOL]\n"); return 1; }
  K = atoi(argv[2]); int ttl = argc > 3 ? atoi(argv[3]) : 26; ALLSOL = argc > 4 ? atoi(argv[4]) : 0;
  array<u8, N> p = {0, 1, 2, 3, 4};
  do ty.push_back(p); while (next_permutation(p.begin(), p.end()));
  ifstream in(argv[1]); string w; vector<pair<string, string>> sk;
  while (in >> w) { if (w[0] == '#') { getline(in, w); continue; } size_t c = w.find(':'); sk.push_back({w.substr(0, c), w.substr(c + 1)}); }
  C = sk.size();
  for (auto& [a, b] : sk) { Col ca, cb; vector<u8> fv(NTY);
    for (int t = 0; t < NTY; t++) { ca.v[t] = evf(a, ty[t]); cb.v[t] = evf(b, ty[t]); fv[t] = ca.v[t] < cb.v[t] ? 1 : ca.v[t] > cb.v[t] ? 2 : 0; }
    opa.push_back(ca); opb.push_back(cb); F.push_back(fv); }
  for (int k = 0; k < N; k++) { for (int t = 0; t < NTY; t++) { auto s = ty[t]; sort(s.begin(), s.end()); tgt[k].v[t] = s[k]; } tgtH[k] = hcol(tgt[k]); }
  for (int j = 0; j <= C; j++) for (int dn = 0; dn < 32; dn++) {
    vector<Col> nc; vector<u64> nh;
    auto add = [&](const Col& c) { u64 h = hcol(c); for (u64 x : nh) if (x == h) return; nh.push_back(h); nc.push_back(c); };
    for (int i = j; i < C; i++) { add(opa[i]); add(opb[i]); }
    for (int k = 0; k < N; k++) if (!(dn >> k & 1)) add(tgt[k]);
    needH[j][dn] = nh; needC[j][dn] = nc;
    for (int t = 0; t < NTY; t++) { u8 m = 0; for (auto& c : nc) m |= 1 << c.v[t]; needMask[j][dn][t] = m; }
  }
  TTmask = (1ULL << ttl) - 1; TT = (u64*)calloc(1ULL << ttl, 8); TTg = (u8*)calloc(1ULL << ttl, 1);
  St s; s.j = 0; s.done = 0; s.blockHasCmov = false; s.lastM = 0; s.lastKind = -1;
  for (int i = 0; i < N; i++) { Col c; for (int t = 0; t < NTY; t++) c.v[t] = ty[t][i]; s.A.push_back(c); s.H.push_back(hcol(c)); }
  printf("skeleton c=%d K=%d h(root)=%d needed=%zu\n", C, K, hval(s), needH[0][0].size()); fflush(stdout);
  auto t0 = chrono::steady_clock::now();
  bool ok = dfs(s, 0);
  double sec = chrono::duration<double>(chrono::steady_clock::now() - t0).count();
  printf("RESULT %s K=%d nodes=%lld sols=%lld time=%.1fs\n", (ok || nsol) ? "FOUND" : "NONE", K, nodes, nsol, sec);
}
