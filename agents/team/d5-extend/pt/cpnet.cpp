// cpnet.cpp -- d5-extend: value skeletons from "conditional-permutation networks" on 5 wires.
// Step: cmp wires (a,b); on gt types apply wire permutation pi (on lt: identity; wlog, wire names are free).
// State up to wire relabeling = sorted multiset of wire columns (+ class partition, implied by history).
// Prune: class sizes <= 2^(C-j) after step j (perms: binary cmps). Final: all 120 classes singleton.
// BFS with dedupe per level on (sorted wire columns, operand history). Output skeletons for dagx (explicit cols).
// usage: cpnet C MAXSTATES > out
#include <bits/stdc++.h>
using namespace std;
typedef array<uint8_t, 120> Col;
struct St { array<Col, 5> w; vector<pair<Col, Col>> ops; vector<int> lab; };
static vector<array<int, 5>> PERM5;
static string key(const St& s, bool withops) {
  array<Col, 5> w = s.w; sort(w.begin(), w.end());
  string k; for (auto& c : w) k.append((const char*)c.data(), 120);
  if (withops) for (auto& [a, b] : s.ops) { Col x = min(a, b), y = max(a, b); k.append((const char*)x.data(), 120); k.append((const char*)y.data(), 120); }
  return k; }
int main(int argc, char** argv) {
  int C = atoi(argv[1]); long MAXS = atol(argv[2]);
  array<int, 5> p = {0, 1, 2, 3, 4}; vector<array<int, 5>> T; do T.push_back(p); while (next_permutation(p.begin(), p.end()));
  PERM5 = T;
  St s0; for (int i = 0; i < 5; i++) for (int t = 0; t < 120; t++) s0.w[i][t] = T[t][i]; s0.lab.assign(120, 0);
  vector<St> lev = {s0};
  for (int j = 0; j < C; j++) {
    long bound = 1L << (C - j - 1);
    unordered_set<string> seen; vector<St> nxt;
    for (auto& s : lev) {
      for (int a = 0; a < 5; a++) for (int b = a + 1; b < 5; b++) {
        if (j == 0 && !(a == 0 && b == 1)) continue;
        vector<int> nl(120); map<int, int> cnt; bool ok = true;
        for (int t = 0; t < 120; t++) { nl[t] = s.lab[t] * 2 + (s.w[a][t] > s.w[b][t]); if (++cnt[nl[t]] > bound) { ok = false; break; } }
        if (!ok) continue;
        if (s.w[a] == s.w[b]) continue;
        map<int, int> rl; for (int t = 0; t < 120; t++) nl[t] = rl.emplace(nl[t], rl.size()).first->second;
        for (auto& pi : PERM5) {
          St n; n.ops = s.ops; n.ops.push_back({s.w[a], s.w[b]}); n.lab = nl;
          for (int w = 0; w < 5; w++) for (int t = 0; t < 120; t++) n.w[w][t] = (s.w[a][t] > s.w[b][t]) ? s.w[pi[w]][t] : s.w[w][t];
          // dedupe: future depends only on wire multiset + classes; skeleton identity needs ops. Keep per (wires, ops).
          string k = key(n, j == C - 1);
          if (j < C - 1) { k += string((const char*)nl.data(), 0); }
          if (!seen.insert(key(n, true)).second) continue;
          nxt.push_back(move(n));
          if ((long)nxt.size() > MAXS) { fprintf(stderr, "level %d: state limit hit\n", j + 1); return 2; }
        }
      }
    }
    lev.swap(nxt);
    fprintf(stderr, "level %d states %zu\n", j + 1, lev.size());
  }
  set<string> outk; long nout = 0;
  for (auto& s : lev) {
    if ((int)set<int>(s.lab.begin(), s.lab.end()).size() < 120) continue;
    string k; for (auto& [a, b] : s.ops) { Col x = min(a, b), y = max(a, b); k.append((const char*)x.data(), 120); k.append((const char*)y.data(), 120); }
    if (!outk.insert(k).second) continue;
    for (size_t q = 0; q < s.ops.size(); q++) { auto& [a, b] = s.ops[q]; printf("%s=", q ? " " : ""); for (int t = 0; t < 120; t++) putchar('0' + a[t]); printf(":="); for (int t = 0; t < 120; t++) putchar('0' + b[t]); }
    printf("\n"); nout++;
  }
  fprintf(stderr, "skeletons %ld\n", nout);
}
