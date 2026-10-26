// neigh2.cpp -- d5-extend: TWO-select neighbours of a complete skeleton (explicit columns, 120 perms).
// Move: pick cmp j, one operand side, flags k1 < k2 < j, one quarter q of (f_k1, f_k2); replace the operand on the
// types of q by another value from V2 (min/max closure depth 2 of all seed operand columns), restricted value
// index-consistent per class at block j. New skeleton must keep class bounds (<= 2^(C-i) after cmp i) and end with
// 120 singleton classes (later cmps unchanged as columns). Dedupe by unordered operand pairs. Output cap.
// usage: neigh2 SEED [maxout] > out
#include <bits/stdc++.h>
using namespace std;
typedef array<uint8_t, 120> Col;
static vector<array<uint8_t, 5>> TY;
static inline int idxof(const Col& c, int t) { for (int k = 0; k < 5; k++) if (TY[t][k] == c[t]) return k; return -1; }
static bool valid(const vector<pair<Col, Col>>& sk) {
  int C = sk.size(); vector<long> h(120, 0);
  for (int i = 0; i < C; i++) {
    for (int t = 0; t < 120; t++) h[t] = h[t] * 3 + (sk[i].first[t] < sk[i].second[t] ? 0 : sk[i].first[t] > sk[i].second[t] ? 2 : 1);
    map<long, int> cnt; long bound = 1L << (C - i - 1); for (int t = 0; t < 120; t++) if (++cnt[h[t]] > bound) return false; }
  return true; }
static vector<int> classesAt(const vector<pair<Col, Col>>& sk, int j) {  // classes before cmp j
  vector<long> h(120, 0); for (int i = 0; i < j; i++) for (int t = 0; t < 120; t++) h[t] = h[t] * 3 + (sk[i].first[t] < sk[i].second[t] ? 0 : sk[i].first[t] > sk[i].second[t] ? 2 : 1);
  map<long, int> m; vector<int> lab(120); for (int t = 0; t < 120; t++) lab[t] = m.emplace(h[t], m.size()).first->second; return lab; }
int main(int argc, char** argv) {
  long maxout = argc > 2 ? atol(argv[2]) : 1000000, nout = 0;
  array<uint8_t, 5> p = {0, 1, 2, 3, 4}; do TY.push_back(p); while (next_permutation(p.begin(), p.end()));
  ifstream in(argv[1]); string w; vector<pair<Col, Col>> sk;
  while (in >> w) { if (w[0] == '#') { getline(in, w); continue; } size_t c = w.find(':'); string a = w.substr(1, c - 1), b = w.substr(c + 2);
    Col x, y; for (int t = 0; t < 120; t++) { x[t] = a[t] - '0'; y[t] = b[t] - '0'; } sk.push_back({x, y}); }
  int C = sk.size(); if (!valid(sk)) { fprintf(stderr, "seed invalid\n"); return 1; }
  set<Col> V0; for (auto& [a, b] : sk) { V0.insert(a); V0.insert(b); }
  auto clos = [](const set<Col>& V) { set<Col> W = V; for (auto& a : V) for (auto& b : V) { Col mn, mx; for (int t = 0; t < 120; t++) { mn[t] = min(a[t], b[t]); mx[t] = max(a[t], b[t]); } W.insert(mn); W.insert(mx); } return W; };
  auto V2s = clos(clos(V0)); vector<Col> V2(V2s.begin(), V2s.end());
  set<vector<pair<Col, Col>>> seen; long tried = 0;
  for (int j = 2; j < C; j++) {
    vector<int> lab = classesAt(sk, j);
    for (int side = 0; side < 2; side++) for (int k1 = 0; k1 < j; k1++) for (int k2 = k1 + 1; k2 < j; k2++) for (int q = 0; q < 4; q++) {
      vector<bool> H(120); int sz = 0;
      for (int t = 0; t < 120; t++) { int g1 = sk[k1].first[t] > sk[k1].second[t], g2 = sk[k2].first[t] > sk[k2].second[t]; H[t] = (g1 | g2 << 1) == q; sz += H[t]; }
      if (!sz) continue;
      set<vector<uint8_t>> R;
      for (auto& c : V2) { map<int, int> id; bool ok = true; vector<uint8_t> hv;
        for (int t = 0; t < 120 && ok; t++) if (H[t]) { int i = idxof(c, t); auto it = id.find(lab[t]); if (it == id.end()) id[lab[t]] = i; else if (it->second != i) ok = false; hv.push_back(c[t]); }
        if (ok) R.insert(hv); }
      for (auto& hv : R) {
        auto s2 = sk; Col& u = side ? s2[j].second : s2[j].first; int pi = 0; bool diff = false;
        for (int t = 0; t < 120; t++) if (H[t]) { if (u[t] != hv[pi]) diff = true; u[t] = hv[pi++]; }
        if (!diff) continue; tried++;
        if (!valid(s2)) continue;
        vector<pair<Col, Col>> key = s2; for (auto& [a, b] : key) if (b < a) swap(a, b);
        if (!seen.insert(key).second) continue;
        for (int i = 0; i < C; i++) { printf("%s=", i ? " " : ""); for (int t = 0; t < 120; t++) putchar('0' + s2[i].first[t]); printf(":="); for (int t = 0; t < 120; t++) putchar('0' + s2[i].second[t]); }
        printf("\n"); if (++nout >= maxout) { fprintf(stderr, "cap hit\n"); return 0; } } }
  }
  fprintf(stderr, "V2 %zu tried %ld neighbours %ld\n", V2.size(), tried, nout);
}
