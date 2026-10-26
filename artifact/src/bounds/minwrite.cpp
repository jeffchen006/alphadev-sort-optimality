// minwrite.cpp -- bounds agent. Relaxation R2 = enum's set model (PRUNING.md Lemma S) with cmp FREE.
// Exact minimum of W = #mov + #cmov over all correct programs (T-relaxed, I1 or I0, permutations, M_out snapshot
// outputs, unbounded registers), cmps not counted. Then k >= ceil(log2 n!) + W_min (B1 and R2 hold for every program).
// State: (A = set of non-T columns, f = current flag vector, done = outputs taken). Ops:
//   cmp u,w  (u,w in A or T)                 cost 0, f := flags(u,w)
//   cmovX in place on D in A                 cost 1, A := A - D + M      (M = X(f) ? S : D)
//   cmovX on a fresh T register              cost 1, A := A + M          (M = X(f) ? S : T)
//   cmovX into a copy of D in A (mov+cmov)   cost 2, A := A + M
// done |= {j : t_j in A}. Goal: done = all. Pruning: h = max(und, ceil(Huffman-sum)) <= remaining #cmov <= remaining W.
// Dead: an undone y_j(p) held by no column.  Memo on canonical (A, f, done) under S_n relabelling and flag polarity.
// usage: minwrite N ISET(0|1) MAXW
#include <bits/stdc++.h>
using namespace std;
typedef vector<uint8_t> Col;
int N, NP, T, ISET; vector<array<int, 8>> P; vector<Col> TARGET; Col TCOL;
map<vector<int>, int> pindex; vector<vector<int>> relab, sperm;

double huff(vector<double> w) {
    priority_queue<double, vector<double>, greater<double>> q;
    for (double x : w) if (x > 0) q.push(x);
    double c = 0;
    while (q.size() > 1) { double a = q.top(); q.pop(); double b = q.top(); q.pop(); c += a + b; q.push(a + b); }
    return c;
}
int hval(const vector<Col>& A, int done) {
    double tot = 0; int und = 0;
    for (int j = 0; j < N; j++) {
        if (done >> j & 1) continue;
        und++;
        auto& t = TARGET[j];
        map<int, int> cnt; bool uniq = true;
        for (int i = 0; i < NP; i++) {
            int k = 0, who = -1;
            for (int a = 0; a < (int)A.size(); a++) if (A[a][i] == t[i]) { k++; who = a; }
            if (k == 0) return 1 << 20;
            if (k > 1) uniq = false;
            cnt[who]++;
        }
        if (uniq) { vector<double> w; for (auto& kv : cnt) w.push_back((double)kv.second / NP); tot += huff(w); }
        else tot += 1;
    }
    return max(und, (int)ceil(tot - 1e-9));
}
inline int V(int i, int sym) { return sym == T ? 1000 : P[i][sym]; }
Col image(const Col& c, int s) {
    Col r(NP);
    for (int i = 0; i < NP; i++) { int v = c[relab[s][i]]; r[i] = (v == T) ? T : sperm[s][v]; }
    return r;
}
typedef vector<int8_t> Flg;
Flg fimage(const Flg& f, int s) { Flg r(NP); for (int i = 0; i < NP; i++) r[i] = f[relab[s][i]]; return r; }
struct Key { vector<Col> A; Flg f; int done; bool operator<(const Key& o) const { return tie(A, f, done) < tie(o.A, o.f, o.done); } };
bool dfs(const vector<Col>& A, const Flg& f, int done, int budget, bool jc);
Key canon(const vector<Col>& A, const Flg& f, int done) {
    Key best; bool have = false;
    for (int s = 0; s < (int)sperm.size(); s++) for (int pol = 0; pol < 2; pol++) {
        Key k; for (auto& c : A) k.A.push_back(image(c, s)); sort(k.A.begin(), k.A.end());
        k.f = fimage(f, s); if (pol) for (auto& x : k.f) x = -x;
        k.done = done;   // outputs are invariant under relabelling
        if (!have || k < best) { best = k; have = true; }
    }
    return best;
}
map<Key, int> seen; long long nodes = 0;
int markdone(const vector<Col>& A, int done) {
    for (int j = 0; j < N; j++) for (auto& c : A) if (c == TARGET[j]) done |= 1 << j;
    return done;
}
bool dfs(const vector<Col>& A, const Flg& f, int done, int budget, bool jc) {
    nodes++;
    if (done == (1 << N) - 1) return true;
    int h = hval(A, done);
    if (h > budget) return false;
    Key key = canon(A, f, done | (jc ? 1 << 7 : 0));
    auto it = seen.find(key);
    if (it != seen.end() && it->second >= budget) return false;
    seen[key] = budget;
    // cmovs with the current flag
    int conds[4][2] = {{1, 1}, {-1, -1}, {1, 0}, {-1, 0}};
    int nc = ISET ? 4 : 2;
    for (int ci = 0; ci < nc; ci++) {
        vector<bool> fire(NP); bool any = false;
        for (int i = 0; i < NP; i++) { fire[i] = (f[i] == conds[ci][0] || f[i] == conds[ci][1]); any |= fire[i]; }
        if (!any) continue;
        for (size_t si = 0; si < A.size(); si++) for (int di = -1; di < (int)A.size(); di++) {
            if (di == (int)si) continue;
            const Col& D = di < 0 ? TCOL : A[di];
            Col M(NP); for (int i = 0; i < NP; i++) M[i] = fire[i] ? A[si][i] : D[i];
            if (M == D || M == TCOL) continue;
            bool inA = false; for (auto& c : A) if (c == M) { inA = true; break; }
            if (inA) continue;                          // E3: dominated / no change
            // fresh T register (di<0) or copy: add (cost 1 / 2); in place: replace (cost 1)
            vector<Col> B = A; B.push_back(M);
            int nd = markdone(B, done);
            if (di < 0) { if (budget >= 1 && dfs(B, f, nd, budget - 1, false)) return true; }
            else {
                if (budget >= 2 && dfs(B, f, nd, budget - 2, false)) return true;
                vector<Col> Cc; for (size_t a = 0; a < A.size(); a++) if ((int)a != di) Cc.push_back(A[a]);
                Cc.push_back(M);
                if (budget >= 1 && dfs(Cc, f, nd, budget - 1, false)) return true;
            }
        }
    }
    // free cmp: new flag vector (only if it changes f)
    vector<Col> cols = A; cols.push_back(TCOL);
    set<Flg> fls;
    for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) {
        Flg g(NP);
        for (int i = 0; i < NP; i++) { int x = V(i, cols[a][i]), y = V(i, cols[b][i]); g[i] = (x < y) - (x > y); }
        if (g != f) fls.insert(g);
    }
    // a cmp must be followed by a cmov: only recurse if budget >= 1 (cmp itself free)
    if (budget >= 1 && !jc) for (auto& g : fls) if (dfs(A, g, done, budget, true)) return true;
    return false;
}
int main(int argc, char** argv) {
    N = atoi(argv[1]); ISET = atoi(argv[2]); int MAXW = atoi(argv[3]); T = N;
    vector<int> p(N); iota(p.begin(), p.end(), 0);
    do { array<int, 8> a{}; for (int i = 0; i < N; i++) a[i] = p[i]; pindex[p] = P.size(); P.push_back(a); } while (next_permutation(p.begin(), p.end()));
    NP = P.size();
    iota(p.begin(), p.end(), 0);
    do {
        sperm.push_back(p); vector<int> rl(NP);
        for (int i = 0; i < NP; i++) { vector<int> q(N); for (int k = 0; k < N; k++) q[p[k]] = P[i][k]; rl[pindex[q]] = i; }
        relab.push_back(rl);
    } while (next_permutation(p.begin(), p.end()));
    TCOL.assign(NP, T);
    for (int j = 0; j < N; j++) { Col t(NP); for (int i = 0; i < NP; i++) for (int q = 0; q < N; q++) if (P[i][q] == j) t[i] = q; TARGET.push_back(t); }
    vector<Col> A0; for (int i = 0; i < N; i++) A0.push_back(Col(NP, i));
    Flg f0(NP, 0);
    int h0 = hval(A0, 0); printf("root h = %d (n=%d iset=I%d)\n", h0, N, ISET); fflush(stdout);
    for (int w = h0; w <= MAXW; w++) {
        seen.clear(); nodes = 0;
        bool r = dfs(A0, f0, 0, w, false);
        printf("n=%d W<=%d: %s nodes=%lld memo=%zu\n", N, w, r ? "FOUND" : "none", nodes, seen.size()); fflush(stdout);
        if (r) break;
    }
}
