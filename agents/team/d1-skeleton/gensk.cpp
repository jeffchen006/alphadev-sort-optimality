// gensk.cpp -- d1-skeleton: enumerate lattice cmp skeletons for sort5 (C++ port of gensk.py).
// Operand = lattice polynomial (7579 columns over 120 perms, out/lat_cols.u8, names out/lat_names.txt) that is
// index-consistent at its block (input index constant on each flag-history class). Every cmp refines the
// partition; a class of size s needs >= ceil(log_B s) more cmps (B = 3: lt/eq/gt can all occur on perms).
// Optional cap on #distinct non-input operand columns. Dedupe by canonical form under S5 x reversal.
// usage: gensk C MAXNEED [B] [THREADS] > out   (one line per skeleton: nneed a:b a:b ...)
#include <bits/stdc++.h>
#include <omp.h>
using namespace std;
typedef uint8_t u8;
static const int NT = 120, NG = 240;
static int NC, C, MAXNEED, B = 3;
static vector<array<u8, NT>> COL, IDX;
static vector<string> NAMES;
static vector<vector<int>> GMAP;  // GMAP[g][col]
static vector<array<u8, 5>> TY;
static vector<int> INPUTS;

typedef vector<int> Seq;  // flattened pairs a0 b0 a1 b1 ...
static vector<int> canon(const Seq& s) {
  vector<int> best;
  int m = s.size() / 2;
  for (int g = 0; g < NG; g++) {
    vector<int> k(s.size());
    for (int j = 0; j < m; j++) { int a = GMAP[g][s[2 * j]], b = GMAP[g][s[2 * j + 1]]; if (a > b) swap(a, b); k[2 * j] = a; k[2 * j + 1] = b; }
    if (best.empty() || k < best) best = k;
  }
  return best;
}
struct VH { size_t operator()(const vector<int>& v) const { size_t h = 1469598103934665603ULL; for (int x : v) { h ^= x; h *= 1099511628211ULL; } return h; } };

int main(int argc, char** argv) {
  C = atoi(argv[1]); MAXNEED = atoi(argv[2]); if (argc > 3) B = atoi(argv[3]); int TH = argc > 4 ? atoi(argv[4]) : 1;
  omp_set_num_threads(TH);
  { ifstream f("out/lat_names.txt"); string l; while (getline(f, l)) NAMES.push_back(l); }
  NC = NAMES.size(); COL.resize(NC); IDX.resize(NC);
  { FILE* f = fopen("out/lat_cols.u8", "rb"); for (int i = 0; i < NC; i++) if (fread(COL[i].data(), 1, NT, f) != NT) return 1; fclose(f); }
  array<u8, 5> p = {0, 1, 2, 3, 4}; do TY.push_back(p); while (next_permutation(p.begin(), p.end()));
  for (int i = 0; i < NC; i++) for (int t = 0; t < NT; t++) { int v = COL[i][t]; for (int k = 0; k < 5; k++) if (TY[t][k] == v) IDX[i][t] = k; }
  map<array<u8, NT>, int> colIdx; for (int i = 0; i < NC; i++) colIdx[COL[i]] = i;
  for (int i = 0; i < NC; i++) if (NAMES[i].size() == 1) INPUTS.push_back(i);
  map<array<u8, 5>, int> tyIdx; for (int t = 0; t < NT; t++) tyIdx[TY[t]] = t;
  array<int, 5> s = {0, 1, 2, 3, 4};
  do for (int rev = 0; rev < 2; rev++) {
      vector<int> tm(NT);
      for (int t = 0; t < NT; t++) { array<u8, 5> tt; for (int i = 0; i < 5; i++) tt[i] = TY[t][s[i]]; if (rev) for (auto& v : tt) v = 4 - v; tm[t] = tyIdx[tt]; }
      vector<int> gm(NC);
      for (int i = 0; i < NC; i++) { array<u8, NT> c2; for (int t = 0; t < NT; t++) { int v = COL[i][tm[t]]; c2[t] = rev ? 4 - v : v; } gm[i] = colIdx.at(c2); }
      GMAP.push_back(gm); }
  while (next_permutation(s.begin(), s.end()));
  int i0 = -1, i1 = -1; for (int i = 0; i < NC; i++) { if (NAMES[i] == "0") i0 = i; if (NAMES[i] == "1") i1 = i; }
  vector<Seq> level = {Seq{i0, i1}};
  auto pw = [&](int r) { long long x = 1; for (int i = 0; i < r; i++) x *= B; return x; };
  for (int j = 1; j < C; j++) {
    unordered_set<vector<int>, VH> seen; vector<Seq> nxt;
    long long bound = pw(C - j - 1);
#pragma omp parallel
    {
      vector<pair<vector<int>, Seq>> loc;
#pragma omp for schedule(dynamic, 16)
      for (size_t si = 0; si < level.size(); si++) {
        const Seq& sq = level[si];
        vector<int> lab(NT, 0);
        for (size_t q = 0; q < sq.size(); q += 2) for (int t = 0; t < NT; t++) { int a = COL[sq[q]][t], b = COL[sq[q + 1]][t]; lab[t] = lab[t] * 3 + (a < b ? 0 : a > b ? 2 : 1); }
        // compress labels
        map<int, int> cm; for (int t = 0; t < NT; t++) cm.emplace(lab[t], cm.size()); vector<int> cl(NT); for (int t = 0; t < NT; t++) cl[t] = cm[lab[t]]; int ncl = cm.size();
        vector<int> rep(ncl, -1); for (int t = 0; t < NT; t++) if (rep[cl[t]] < 0) rep[cl[t]] = t;
        vector<int> cons;
        for (int i = 0; i < NC; i++) { bool ok = true; for (int t = 0; t < NT && ok; t++) if (IDX[i][t] != IDX[i][rep[cl[t]]]) ok = false; if (ok) cons.push_back(i); }
        set<int> need; for (int x : sq) if (NAMES[x].size() > 1) need.insert(x);
        for (size_t ia = 0; ia < cons.size(); ia++) for (size_t ib = ia + 1; ib < cons.size(); ib++) {
          int a = cons[ia], b = cons[ib];
          int nn = need.size() + (NAMES[a].size() > 1 && !need.count(a)) + (NAMES[b].size() > 1 && !need.count(b));
          if (nn > MAXNEED) continue;
          // refinement + class bound
          vector<int> cnt(ncl * 3, 0); bool refine = false;
          for (int t = 0; t < NT; t++) { int va = COL[a][t], vb = COL[b][t]; cnt[cl[t] * 3 + (va < vb ? 0 : va > vb ? 2 : 1)]++; }
          int mx = 0; for (int k = 0; k < ncl; k++) { int nz = 0; for (int o = 0; o < 3; o++) { mx = max(mx, cnt[k * 3 + o]); nz += cnt[k * 3 + o] > 0; } if (nz > 1) refine = true; }
          if (!refine || mx > bound) continue;
          Seq s2 = sq; s2.push_back(a); s2.push_back(b);
          loc.push_back({canon(s2), s2});
        }
      }
#pragma omp critical
      for (auto& [k, s2] : loc) if (seen.insert(k).second) nxt.push_back(s2);
    }
    level.swap(nxt);
    fprintf(stderr, "level %d skeletons %zu\n", j + 1, level.size());
  }
  for (auto& sq : level) {
    set<int> need; for (int x : sq) if (NAMES[x].size() > 1) need.insert(x);
    printf("%zu", need.size());
    for (size_t q = 0; q < sq.size(); q += 2) printf(" %s:%s", NAMES[sq[q]].c_str(), NAMES[sq[q + 1]].c_str());
    printf("\n");
  }
}
