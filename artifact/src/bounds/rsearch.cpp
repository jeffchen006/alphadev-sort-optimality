// rsearch.cpp -- bounds agent, fast version of mincmov.cpp (R1) and minwrite.cpp (R2). Proofs: BOUNDS.md §R1, §R2.
// T-relaxed, permutations only, M_out snapshot outputs, unbounded registers.
//  R1: min #cmov. State = set A of columns (only grows). Step (cost 1): A += M, M = X(flags(u,w)) ? S : D,
//      u,w in A+T, S in A, D in A+T.  (cmp and mov free.)
//  R2: min W = #mov + #cmov, cmp free = enum's set model (PRUNING.md Lemma S) with cmp cost 0. State (A, f, done).
//      cmovX in place on D (cost 1, A := A-D+M), on T (cost 1, A += M), into a copy of D (cost 2, A += M);
//      free cmp sets f := flags(u,w), u,w in A+T, and must be followed by a cmov.
//  Pruning (admissible): h = max(#undone, ceil(Huffman-sum)) (BOUNDS.md §H2/H3); dead if an undone y_j(p) is lost.
//  Memo: canonical key under input relabelling S_n (and flag polarity in R2), value = best budget seen.
// usage: rsearch MODE(1|2) N ISET(0|1) MAXCOST
#include <bits/stdc++.h>
using namespace std;
typedef unsigned __int128 u128;
struct BS { uint64_t w[2] = {0, 0};
    void set(int i) { w[i >> 6] |= 1ULL << (i & 63); }
    bool get(int i) const { return w[i >> 6] >> (i & 63) & 1; }
    int pc() const { return __builtin_popcountll(w[0]) + __builtin_popcountll(w[1]); }
    BS operator|(const BS& o) const { BS r; r.w[0] = w[0] | o.w[0]; r.w[1] = w[1] | o.w[1]; return r; }
    bool operator==(const BS& o) const { return w[0] == o.w[0] && w[1] == o.w[1]; } };
int MODE, N, NP, T, ISET; vector<array<int, 8>> P; BS ALL;
vector<vector<uint8_t>> TGT; vector<vector<int>> relab, sperm; map<vector<int>, int> pindex;

// ---- interning of columns and flag vectors ----
struct Interner { vector<vector<int8_t>> data; unordered_map<string, int> idx;
    int get(const vector<int8_t>& v) { string k(v.begin(), v.end()); auto it = idx.find(k); if (it != idx.end()) return it->second;
        int id = data.size(); data.push_back(v); idx[k] = id; return id; } };
Interner CI, FI;
vector<array<BS, 8>> cmask;           // cmask[col][j] = perms where col holds target j
vector<vector<int>> cimg, fimg;        // images under symmetries (lazy)
int TID;                               // id of the all-T column
int colid(const vector<int8_t>& v) {
    int id = CI.get(v);
    if (id == (int)cmask.size()) {
        array<BS, 8> a; for (int j = 0; j < N; j++) for (int i = 0; i < NP; i++) if (v[i] == TGT[j][i]) a[j].set(i);
        cmask.push_back(a); cimg.push_back({});
    }
    return id;
}
int flagid(const vector<int8_t>& v) { int id = FI.get(v); if (id == (int)fimg.size()) fimg.push_back({}); return id; }
int colimage(int c, int s) {
    if (cimg[c].empty()) {
        vector<int> r(sperm.size());
        for (size_t t = 0; t < sperm.size(); t++) { vector<int8_t> v(NP); auto& src = CI.data[c];
            for (int i = 0; i < NP; i++) { int x = src[relab[t][i]]; v[i] = x == T ? T : sperm[t][x]; } r[t] = colid(v); }
        cimg[c] = r;
    }
    return cimg[c][s];
}
int flagimage(int f, int s) {
    if (fimg[f].empty()) {
        vector<int> r(2 * sperm.size());
        for (size_t t = 0; t < sperm.size(); t++) { vector<int8_t> v(NP), w(NP); auto& src = FI.data[f];
            for (int i = 0; i < NP; i++) { v[i] = src[relab[t][i]]; w[i] = -v[i]; } r[2 * t] = flagid(v); r[2 * t + 1] = flagid(w); }
        fimg[f] = r;
    }
    return fimg[f][s];
}
inline int V(int i, int sym) { return sym == T ? 1000 : P[i][sym]; }
int flagof(int a, int b) {
    vector<int8_t> f(NP); auto& x = CI.data[a]; auto& y = CI.data[b];
    for (int i = 0; i < NP; i++) { int p = V(i, x[i]), q = V(i, y[i]); f[i] = (p < q) - (p > q); }
    return flagid(f);
}
double huff(vector<double> w) {
    priority_queue<double, vector<double>, greater<double>> q; for (double x : w) if (x > 0) q.push(x);
    double c = 0; while (q.size() > 1) { double a = q.top(); q.pop(); double b = q.top(); q.pop(); c += a + b; q.push(a + b); }
    return c;
}
int hval(const vector<int>& A, int done) {
    double tot = 0; int und = 0;
    for (int j = 0; j < N; j++) {
        if (done >> j & 1) continue;
        BS U; int sum = 0; bool full = false;
        for (int c : A) { auto& m = cmask[c][j]; U = U | m; int p = m.pc(); sum += p; if (p == NP) full = true; }
        if (!(U == ALL)) return 1 << 20;
        if (full) continue;
        und++;
        if (sum == NP) { vector<double> w; for (int c : A) { int p = cmask[c][j].pc(); if (p) w.push_back((double)p / NP); } tot += huff(w); }
        else { int q = 0; for (int c : A) q = max(q, cmask[c][j].pc()); tot += max(1.0, log2((double)NP / q)); }   // E[l] >= H(g) >= log2(1/q_max)
    }
    return max(und, (int)ceil(tot - 1e-9));
}
int markdone(const vector<int>& A, int done) {
    for (int c : A) for (int j = 0; j < N; j++) if (cmask[c][j].pc() == NP) done |= 1 << j;
    return done;
}
struct VH { size_t operator()(const vector<int>& v) const { size_t h = 1469598103934665603ULL; for (int x : v) { h ^= (size_t)x + 0x9e3779b97f4a7c15ULL + (h << 6) + (h >> 2); } return h; } };
unordered_map<vector<int>, int, VH> seen; long long nodes = 0;
vector<int> canon(const vector<int>& A, int f, int extra) {
    vector<int> best; int S = getenv("NOSYM") ? 1 : sperm.size();
    for (int s = 0; s < S; s++) for (int pol = 0; pol < (MODE >= 2 ? 2 : 1); pol++) {
        vector<int> k; k.reserve(A.size() + 2);
        for (int c : A) k.push_back(colimage(c, s));
        sort(k.begin(), k.end());
        if (MODE >= 2) k.push_back(flagimage(f, 2 * s + pol));
        k.push_back(extra);
        if (best.empty() || k < best) best = k;
    }
    return best;
}
const int CONDS[4][2] = {{1, 1}, {-1, -1}, {1, 0}, {-1, 0}};
int mkM(int f, int cd, int S, int D) {
    auto& fl = FI.data[f]; auto& s = CI.data[S]; auto& d = CI.data[D];
    vector<int8_t> m(NP); bool any = false;
    for (int i = 0; i < NP; i++) { bool fire = fl[i] == CONDS[cd][0] || fl[i] == CONDS[cd][1]; m[i] = fire ? s[i] : d[i]; any |= fire; }
    if (!any) return -1;
    return colid(m);
}
bool inA(const vector<int>& A, int c) { for (int x : A) if (x == c) return true; return false; }

bool r1(vector<int>& A, int budget) {
    nodes++;
    int done = markdone(A, 0);
    if (done == (1 << N) - 1) return true;
    if (hval(A, done) > budget) return false;
    auto key = canon(A, 0, 0);
    auto it = seen.find(key); if (it != seen.end() && it->second >= budget) return false; seen[key] = budget;
    vector<int> cols = A; cols.push_back(TID);
    set<int> fls; for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) fls.insert(flagof(cols[a], cols[b]));
    vector<pair<int, int>> kids; set<int> ks;
    vector<int> A1 = A; for (int f : fls) for (int cd = 0; cd < (ISET ? 4 : 2); cd++) for (int S : A1) for (int D : cols) {
        if (S == D) continue; int M = mkM(f, cd, S, D);
        if (M < 0 || M == TID || M == D || inA(A, M) || ks.count(M)) continue;
        ks.insert(M); A.push_back(M); int h = hval(A, markdone(A, 0)); A.pop_back();
        if (h <= budget - 1) kids.push_back({h, M});
    }
    sort(kids.begin(), kids.end());
    for (auto& hm : kids) { A.push_back(hm.second); bool r = r1(A, budget - 1); A.pop_back(); if (r) return true; }
    return false;
}
unordered_map<vector<int>, int, VH> onpath;
bool r2body(const vector<int>&, int, int, int, bool, bool&);
bool r3body(const vector<int>&, int, int, int, int, bool, bool&);
bool r2(const vector<int>& A, int f, int done, int budget, bool jc, bool& taint) {
    nodes++;
    if (done == (1 << N) - 1) return true;
    if (hval(A, done) > budget) return false;
    auto key = canon(A, f, done | (jc ? 256 : 0));
    auto it = seen.find(key); if (it != seen.end() && it->second >= budget) return false;
    if (onpath.count(key)) { taint = true; return false; }
    onpath[key] = budget; bool t = false;
    bool res = r2body(A, f, done, budget, jc, t);
    onpath.erase(key);
    if (res) return true;
    if (t) taint = true; else { int& v = seen[key]; v = max(v, budget); }
    return false;
}
bool r2body(const vector<int>& A, int f, int done, int budget, bool jc, bool& t) {
    for (int cd = 0; cd < (ISET ? 4 : 2); cd++) for (size_t si = 0; si < A.size(); si++) for (int di = -1; di < (int)A.size(); di++) {
        if (di == (int)si) continue;
        int D = di < 0 ? TID : A[di]; int M = mkM(f, cd, A[si], D);
        if (M < 0 || M == TID || M == D || inA(A, M)) continue;
        vector<int> B = A; B.push_back(M); int nd = markdone(B, done);
        if (di < 0) { if (r2(B, f, nd, budget - 1, false, t)) return true; continue; }
        vector<int> C; for (size_t a = 0; a < A.size(); a++) if ((int)a != di) C.push_back(A[a]); C.push_back(M);
        if (r2(C, f, nd, budget - 1, false, t)) return true;
        if (budget >= 2 && r2(B, f, nd, budget - 2, false, t)) return true;
    }
    if (!jc && budget >= 1) {
        vector<int> cols = A; cols.push_back(TID); set<int> fls;
        for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) { int g = flagof(cols[a], cols[b]); if (g != f) fls.insert(g); }
        for (int g : fls) if (r2(A, g, done, budget, true, t)) return true;
    }
    return false;
}

bool r3(const vector<int>& A, int f, int done, int kb, int cb, bool jc, bool& taint);
// ---- R3: exact set model (enum's Lemma S), cmp cost 1 with cap CB on #cmp; IDDFS on k = c + W ----
int cls_lb(const vector<int>& A, int f, int done) {
    // H1: classes = perms with equal symbols in every column and equal flag; need ceil(log2 #distinct requirements)
    unordered_map<string, set<string>> cl;
    auto& fl = FI.data[f];
    for (int i = 0; i < NP; i++) {
        string key; key.reserve(A.size() + 1);
        for (int c : A) key.push_back((char)CI.data[c][i]);
        key.push_back((char)fl[i]);
        string req; for (int j = 0; j < N; j++) if (!(done >> j & 1)) req.push_back((char)TGT[j][i]);
        cl[key].insert(req);
    }
    int best = 0; for (auto& kv : cl) { int s = kv.second.size(), b = 0; while ((1 << b) < s) b++; best = max(best, b); }
    return best;
}
bool EXACTC = getenv("EXACTC") != nullptr;   // case "exactly CB cmps" (shortest programs: each cmp owns a cmov, F3)
int NSPLIT = getenv("NSPLIT") ? atoi(getenv("NSPLIT")) : 1, ISPLIT = getenv("ISPLIT") ? atoi(getenv("ISPLIT")) : 0,
    KSPLIT = getenv("KSPLIT") ? atoi(getenv("KSPLIT")) : -1, CURKB = 1 << 20; long long nfront = 0;
int MCUT = getenv("MCUT") ? atoi(getenv("MCUT")) : 0, MU = 0;   // proven global lower bound on #cmov (R1/B3); MU = cmovs so far
bool r3(const vector<int>& A, int f, int done, int kb, int cb, bool jc, bool& taint) {
    nodes++;
    if (done == (1 << N) - 1) return !EXACTC || cb == 0;
    int hw = hval(A, done); if (hw >= (1 << 20)) return false;
    int cl = cls_lb(A, f, done);
    if (cl > cb) return false;
    int r = EXACTC ? cb : cl;
    if (r + max(max(r, hw), MCUT - MU) > kb) return false;
    auto key = canon(A, f, done | (jc ? 256 : 0) | (cb << 9) | (min(MU, MCUT) << 16));
    // semantic cubes: a node is a FRONTIER node if its parent had budget > KSPLIT and it has budget <= KSPLIT; frontier
    // node (state, kb) belongs to job hash(state, kb) % NSPLIT. Every solution path crosses the frontier exactly once, so
    // the union of the NSPLIT jobs covers all paths; a job's stored failures mean "no solution in my share" (consistent,
    // since the share is a function of (state, kb) only).
    if (NSPLIT > 1 && CURKB > KSPLIT && kb <= KSPLIT) {
        size_t h = VH()(key) ^ (size_t)kb * 0x9E3779B97F4A7C15ULL;
        if ((int)(h % NSPLIT) != ISPLIT) return false;
        nfront++;
    }
    auto it = seen.find(key); if (it != seen.end() && it->second >= kb) return false;
    if (onpath.count(key)) { taint = true; return false; }
    onpath[key] = kb; bool t = false;
    int oldkb = CURKB; CURKB = kb;
    bool res = r3body(A, f, done, kb, cb, jc, t);
    CURKB = oldkb;
    onpath.erase(key);
    if (res) return true;
    if (t) taint = true; else { int& v = seen[key]; v = max(v, kb); }
    return false;
}
bool r3body(const vector<int>& A, int f, int done, int kb, int cb, bool jc, bool& t) {
    for (int cd = 0; cd < (ISET ? 4 : 2); cd++) for (size_t si = 0; si < A.size(); si++) for (int di = -1; di < (int)A.size(); di++) {
        if (di == (int)si) continue;
        int D = di < 0 ? TID : A[di]; int M = mkM(f, cd, A[si], D);
        if (M < 0 || M == TID || M == D || inA(A, M)) continue;
        vector<int> B = A; B.push_back(M); int nd = markdone(B, done);
        MU++;
        if (di < 0) { bool q = r3(B, f, nd, kb - 1, cb, false, t); MU--; if (q) return true; continue; }
        vector<int> C; for (size_t a = 0; a < A.size(); a++) if ((int)a != di) C.push_back(A[a]); C.push_back(M);
        bool q = r3(C, f, nd, kb - 1, cb, false, t) || (kb >= 2 && r3(B, f, nd, kb - 2, cb, false, t));
        MU--; if (q) return true;
    }
    if (!jc && cb >= 1 && kb >= 2) {
        vector<int> cols = A; cols.push_back(TID); set<int> fls;
        for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) { int g = flagof(cols[a], cols[b]); if (g != f) fls.insert(g); }
        for (int g : fls) if (r3(A, g, done, kb - 1, cb - 1, true, t)) return true;
    }
    return false;
}


// ---- R4: R3 + block tracking. bc = #cmov in the current block (-1 before first cmp, capped at 2), sg = some closed block
// had exactly 1 cmov. Goal needs sg (WANT1=1) -> "a correct program of length <= k with a 1-cmov block exists".
int WANT1 = 1;
bool r4body(const vector<int>& A, int f, int done, int kb, int cb, bool jc, int bc, int sg, bool& t);
bool r4(const vector<int>& A, int f, int done, int kb, int cb, bool jc, int bc, int sg, bool& taint) {
    nodes++;
    if (done == (1 << N) - 1) { int s2 = sg | (bc == 1); return s2 == WANT1 || !WANT1 ? (WANT1 ? s2 : true) : false; }
    int hw = hval(A, done); if (hw >= (1 << 20)) return false;
    int cl = cls_lb(A, f, done);
    if (cl > cb) return false;
    if (cl + max(cl, hw) > kb) return false;
    auto key = canon(A, f, done | (jc ? 256 : 0) | (cb << 9) | ((bc + 1) << 16) | (sg << 20));
    auto it = seen.find(key); if (it != seen.end() && it->second >= kb) return false;
    if (onpath.count(key)) { taint = true; return false; }
    onpath[key] = kb; bool t = false;
    bool res = r4body(A, f, done, kb, cb, jc, bc, sg, t);
    onpath.erase(key);
    if (res) return true;
    if (t) taint = true; else { int& v = seen[key]; v = max(v, kb); }
    return false;
}
bool r4body(const vector<int>& A, int f, int done, int kb, int cb, bool jc, int bc, int sg, bool& t) {
    int nbc = bc < 0 ? -1 : min(bc + 1, 2);
    for (int cd = 0; cd < (ISET ? 4 : 2); cd++) for (size_t si = 0; si < A.size(); si++) for (int di = -1; di < (int)A.size(); di++) {
        if (di == (int)si) continue;
        int D = di < 0 ? TID : A[di]; int M = mkM(f, cd, A[si], D);
        if (M < 0 || M == TID || M == D || inA(A, M)) continue;
        vector<int> B = A; B.push_back(M); int nd = markdone(B, done);
        if (di < 0) { if (r4(B, f, nd, kb - 1, cb, false, nbc, sg, t)) return true; continue; }
        vector<int> C; for (size_t a = 0; a < A.size(); a++) if ((int)a != di) C.push_back(A[a]); C.push_back(M);
        if (r4(C, f, nd, kb - 1, cb, false, nbc, sg, t)) return true;
        if (kb >= 2 && r4(B, f, nd, kb - 2, cb, false, nbc, sg, t)) return true;
    }
    if (!jc && cb >= 1 && kb >= 2) {
        int nsg = sg | (bc == 1);
        vector<int> cols = A; cols.push_back(TID); set<int> fls;
        for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) { int g = flagof(cols[a], cols[b]); if (g != f) fls.insert(g); }
        for (int g : fls) if (r4(A, g, done, kb - 1, cb - 1, true, 0, nsg, t)) return true;
    }
    return false;
}

// ---- mode 5: Knuth random-probe estimate of the R3 search TREE size (no memo) for budget K, cmp cap CB ----
struct St { vector<int> A; int f, done, kb, cb; bool jc; };
bool passes(const St& s) {
    if (s.done == (1 << N) - 1) return !EXACTC || s.cb == 0;
    int hw = hval(s.A, s.done); if (hw >= (1 << 20)) return false;
    int cl = cls_lb(s.A, s.f, s.done);
    int r = EXACTC ? s.cb : cl;
    return cl <= s.cb && r + max(r, hw) <= s.kb;
}
vector<St> kids3(const St& s) {
    vector<St> out;
    for (int cd = 0; cd < (ISET ? 4 : 2); cd++) for (size_t si = 0; si < s.A.size(); si++) for (int di = -1; di < (int)s.A.size(); di++) {
        if (di == (int)si) continue;
        int D = di < 0 ? TID : s.A[di]; int M = mkM(s.f, cd, s.A[si], D);
        if (M < 0 || M == TID || M == D || inA(s.A, M)) continue;
        vector<int> B = s.A; B.push_back(M); int nd = markdone(B, s.done);
        if (di < 0) { St c{B, s.f, nd, s.kb - 1, s.cb, false}; if (c.kb >= 0 && passes(c)) out.push_back(c); continue; }
        vector<int> C; for (size_t a = 0; a < s.A.size(); a++) if ((int)a != di) C.push_back(s.A[a]); C.push_back(M);
        St c1{C, s.f, nd, s.kb - 1, s.cb, false}; if (c1.kb >= 0 && passes(c1)) out.push_back(c1);
        St c2{B, s.f, nd, s.kb - 2, s.cb, false}; if (c2.kb >= 0 && passes(c2)) out.push_back(c2);
    }
    if (!s.jc && s.cb >= 1 && s.kb >= 2) {
        vector<int> cols = s.A; cols.push_back(TID); set<int> fls;
        for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) { int g = flagof(cols[a], cols[b]); if (g != s.f) fls.insert(g); }
        for (int g : fls) { St c{s.A, g, s.done, s.kb - 1, s.cb - 1, true}; if (passes(c)) out.push_back(c); }
    }
    return out;
}
void estimate(int K, int CB, int probes, unsigned seed) {
    mt19937_64 rng(seed);
    vector<int> A0; for (int i = 0; i < N; i++) A0.push_back(colid(vector<int8_t>(NP, i)));
    St root{A0, flagid(vector<int8_t>(NP, 0)), 0, K, CB, false};
    vector<double> sums(K + 2, 0.0); double total = 0, tot2 = 0; long goals = 0;
    for (int p = 0; p < probes; p++) {
        St s = root; double w = 1, est = 1; int d = 0;
        while (true) {
            if (s.done == (1 << N) - 1) { goals++; break; }
            auto ks = kids3(s);
            if (ks.empty()) break;
            w *= ks.size(); est += w; d++;
            if (d < (int)sums.size()) sums[d] += w;
            s = ks[rng() % ks.size()];
        }
        total += est; tot2 += est * est;
    }
    double mean = total / probes, var = tot2 / probes - mean * mean;
    printf("n=%d K=%d CB=%d probes=%d  est. tree nodes = %.3g  (rel. stderr %.2f)  goal-hits=%ld\n", N, K, CB, probes, mean,
           sqrt(max(0.0, var) / probes) / max(mean, 1e-300), goals);
    printf("  per depth:"); for (int d = 1; d <= K && d < (int)sums.size(); d++) if (sums[d] > 0) printf(" %d:%.2g", d, sums[d] / probes); printf("\n");
    fflush(stdout);
}
void debugpath() {   // AlphaDev sort3 in set-model steps
    auto C = [&](int i){ return colid(vector<int8_t>(NP, i)); };
    vector<int> A = {C(0), C(1), C(2)}; int x0 = A[0], x1 = A[1], x2 = A[2];
    int done = 0, kb = 11, cb = 3;
    int curf = 0; auto show = [&](const char* s){ int hw = hval(A, done), cl = cls_lb(A, curf, done); seen.clear(); bool tt=false; bool r = r3(A, curf, done, kb, cb, false, tt); printf("%-28s |A|=%zu hw=%d cl=%d kb=%d cb=%d done=%d r3=%d\n", s, A.size(), hw, cl, kb, cb, done, (int)r); };
    auto rm = [&](int c){ A.erase(find(A.begin(), A.end(), c)); };
    int f = flagof(x2, x1); kb--; cb--; curf = f;
    int min12 = mkM(f, 0, x2, x1); A.push_back(min12); kb -= 2; done = markdone(A, done); show("copy min12");
    int max12 = mkM(f, 1, x2, x1); rm(x1); A.push_back(max12); kb -= 1; done = markdone(A, done); show("inplace max12");
    { vector<int> cols = A; cols.push_back(TID);
      for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) { int g = flagof(cols[a], cols[b]);
        seen.clear(); bool tt = false; bool r = r3(A, g, done, kb - 1, cb - 1, true, tt); int cl = cls_lb(A, g, done);
        printf("  cmp %zu,%zu flag=%d cl=%d hw=%d r3=%d\n", a, b, g, cl, hval(A, done), (int)r); } }
    f = flagof(max12, x0); kb--; cb--; curf = f;
    int s11 = mkM(f, 0, max12, x0); A.push_back(s11); kb -= 2; done = markdone(A, done); show("copy s11");
    int mx = mkM(f, 2, x0, max12); rm(max12); A.push_back(mx); kb -= 1; done = markdone(A, done); show("inplace max");
    f = flagof(min12, s11); kb--; cb--; curf = f;
    int mn = mkM(f, 2, min12, x0); rm(x0); A.push_back(mn); kb -= 1; done = markdone(A, done); show("inplace min");
    int md = mkM(f, 1, min12, s11); rm(s11); A.push_back(md); kb -= 1; done = markdone(A, done); show("inplace mid");
}
int main(int argc, char** argv) {
    MODE = atoi(argv[1]); N = atoi(argv[2]); ISET = atoi(argv[3]); int MAXC = atoi(argv[4]); T = N;
    int CB = argc > 5 ? atoi(argv[5]) : 99;
    vector<int> p(N); iota(p.begin(), p.end(), 0);
    do { array<int, 8> a{}; for (int i = 0; i < N; i++) a[i] = p[i]; pindex[p] = P.size(); P.push_back(a); } while (next_permutation(p.begin(), p.end()));
    NP = P.size(); for (int i = 0; i < NP; i++) ALL.set(i);
    iota(p.begin(), p.end(), 0);
    do { sperm.push_back(p); vector<int> rl(NP);
        for (int i = 0; i < NP; i++) { vector<int> q(N); for (int k = 0; k < N; k++) q[p[k]] = P[i][k]; rl[pindex[q]] = i; }
        relab.push_back(rl); } while (next_permutation(p.begin(), p.end()));
    for (int j = 0; j < N; j++) { vector<uint8_t> t(NP); for (int i = 0; i < NP; i++) for (int q = 0; q < N; q++) if (P[i][q] == j) t[i] = q; TGT.push_back(t); }
    TID = colid(vector<int8_t>(NP, T));
    vector<int> A0; for (int i = 0; i < N; i++) A0.push_back(colid(vector<int8_t>(NP, i)));
    int f0 = flagid(vector<int8_t>(NP, 0));
    if (MODE == 9) { debugpath(); return 0; }
    if (MODE == 5) { estimate(MAXC, CB, argc > 6 ? atoi(argv[6]) : 1000, 12345); return 0; }
    int h0 = hval(A0, 0); if (MODE >= 3) { int c0 = cls_lb(A0, f0, 0); if (EXACTC) c0 = max(c0, CB); h0 = c0 + max(c0, h0); } printf("mode R%d n=%d iset=I%d root h = %d\n", MODE, N, ISET, h0); fflush(stdout);
    for (int c = h0; c <= MAXC; c++) {
        seen.clear(); nodes = 0; auto t0 = chrono::steady_clock::now();
        bool tt = false; onpath.clear(); bool r = MODE == 4 ? r4(A0, f0, 0, c, CB, false, -1, 0, tt) : MODE == 1 ? r1(A0, c) : MODE == 2 ? r2(A0, f0, 0, c, false, tt) : r3(A0, f0, 0, c, CB, false, tt);
        double dt = chrono::duration<double>(chrono::steady_clock::now() - t0).count();
        printf("n=%d %s<=%d: %s nodes=%lld memo=%zu cols=%zu front=%lld time=%.1fs\n", N, MODE == 1 ? "m" : MODE == 2 ? "W" : "k", c, r ? "FOUND" : "none", nodes, seen.size(), CI.data.size(), nfront, dt);
        fflush(stdout); if (r) break;
    }
}
