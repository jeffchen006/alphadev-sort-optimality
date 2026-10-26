// genext.cpp -- d5-extend: enumerate lattice cmp skeletons for sort5 with some cmp slots FIXED (sort4 core) and
// the others free (extension). Rules as d1's gensk: a free operand is a lattice column that is index-consistent at
// its block (input index constant on each flag-history class over 120 perms); a free cmp must refine some class;
// class bound: after slot j every class has size <= 3^(C-j). Fixed slots are taken as given (explicit columns).
// Cap: #distinct non-input operand columns over free slots <= MAXNEED.
// usage: genext TEMPLATE MAXNEED LATDIR > out ; TEMPLATE: one line per slot, "*" or "=<120 digits>:=<120 digits>"
// output: one skeleton per line, slots separated by ' ', each "=cols:=cols" (dagx explicit format)
#include <bits/stdc++.h>
using namespace std;
typedef uint8_t u8; static const int NT = 120;
typedef array<u8, NT> Colv;
static vector<Colv> COL, IDX; static vector<string> NAMES; static vector<array<u8, 5>> TY;
static int C, MAXNEED; static vector<int> fixedA, fixedB;  // index into COL, -1 = free
static vector<Colv> FIXA, FIXB; static long long nout = 0;
static string cs(const Colv& c) { string s = "="; for (int t = 0; t < NT; t++) s += char('0' + c[t]); return s; }
static void rec(int j, vector<int>& lab, vector<pair<Colv, Colv>>& sk, set<int>& need) {
  if (j == C) {  // final: all classes singletons (sorting needs it on perms)
    set<int> s(lab.begin(), lab.end()); if ((int)s.size() < NT) return;
    for (int q = 0; q < C; q++) printf("%s%s:%s", q ? " " : "", cs(sk[q].first).c_str(), cs(sk[q].second).c_str());
    printf("\n"); nout++; return; }
  long long bound = 1; for (int i = 0; i < C - j - 1; i++) bound *= 3;
  // classes
  map<int, int> cm; vector<int> cl(NT); for (int t = 0; t < NT; t++) { auto it = cm.emplace(lab[t], cm.size()).first; cl[t] = it->second; }
  int ncl = cm.size(); vector<int> rep(ncl, -1); for (int t = 0; t < NT; t++) if (rep[cl[t]] < 0) rep[cl[t]] = t;
  auto apply = [&](const Colv& a, const Colv& b) {
    vector<int> cnt(ncl * 3, 0); bool refine = false; int mx = 0;
    for (int t = 0; t < NT; t++) cnt[cl[t] * 3 + (a[t] < b[t] ? 0 : a[t] > b[t] ? 2 : 1)]++;
    for (int k = 0; k < ncl; k++) { int nz = 0; for (int o = 0; o < 3; o++) { mx = max(mx, cnt[k * 3 + o]); nz += cnt[k * 3 + o] > 0; } if (nz > 1) refine = true; }
    return make_pair(refine, mx); };
  auto go = [&](const Colv& a, const Colv& b) {
    vector<int> l2(NT); for (int t = 0; t < NT; t++) l2[t] = lab[t] * 3 + (a[t] < b[t] ? 0 : a[t] > b[t] ? 2 : 1);
    // relabel compactly to avoid overflow
    map<int, int> m; for (int t = 0; t < NT; t++) l2[t] = m.emplace(l2[t], m.size()).first->second;
    sk.push_back({a, b}); rec(j + 1, l2, sk, need); sk.pop_back(); };
  if (fixedA[j] == -2) {  // fixed slot
    auto [rf, mx] = apply(FIXA[j], FIXB[j]); if (mx > bound) return; go(FIXA[j], FIXB[j]); return; }
  vector<int> cons;
  for (int i = 0; i < (int)COL.size(); i++) { bool ok = true; for (int t = 0; t < NT && ok; t++) if (IDX[i][t] != IDX[i][rep[cl[t]]]) ok = false; if (ok) cons.push_back(i); }
  for (size_t ia = 0; ia < cons.size(); ia++) for (size_t ib = ia + 1; ib < cons.size(); ib++) {
    int a = cons[ia], b = cons[ib];
    int add = 0; vector<int> ins;
    for (int x : {a, b}) if (NAMES[x].size() > 1 && !need.count(x)) { add++; ins.push_back(x); }
    if ((int)need.size() + add > MAXNEED) continue;
    auto [rf, mx] = apply(COL[a], COL[b]); if (!rf || mx > bound) continue;
    for (int x : ins) need.insert(x);
    go(COL[a], COL[b]);
    for (int x : ins) need.erase(x);
  }
}
int main(int argc, char** argv) {
  MAXNEED = atoi(argv[2]); string dir = argv[3];
  { ifstream f(dir + "/lat_names.txt"); string l; while (getline(f, l)) NAMES.push_back(l); }
  COL.resize(NAMES.size()); IDX.resize(NAMES.size());
  { FILE* f = fopen((dir + "/lat_cols.u8").c_str(), "rb"); for (auto& c : COL) if (fread(c.data(), 1, NT, f) != NT) return 1; fclose(f); }
  array<u8, 5> p = {0, 1, 2, 3, 4}; do TY.push_back(p); while (next_permutation(p.begin(), p.end()));
  for (size_t i = 0; i < COL.size(); i++) for (int t = 0; t < NT; t++) for (int k = 0; k < 5; k++) if (TY[t][k] == COL[i][t]) IDX[i][t] = k;
  ifstream in(argv[1]); string w;
  while (in >> w) {
    if (w == "*") { fixedA.push_back(-1); fixedB.push_back(-1); FIXA.push_back({}); FIXB.push_back({}); continue; }
    size_t c = w.find(':'); string a = w.substr(1, c - 1), b = w.substr(c + 2); Colv x, y;
    for (int t = 0; t < NT; t++) { x[t] = a[t] - '0'; y[t] = b[t] - '0'; }
    fixedA.push_back(-2); fixedB.push_back(-2); FIXA.push_back(x); FIXB.push_back(y); }
  C = fixedA.size();
  vector<int> lab(NT, 0); vector<pair<Colv, Colv>> sk; set<int> need;
  rec(0, lab, sk, need);
  fprintf(stderr, "skeletons %lld\n", nout);
}
