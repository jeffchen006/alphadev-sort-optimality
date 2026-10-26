// mincmov.cpp -- bounds agent. Exact minimum #cmov in relaxation R1 (cmp and mov free, all created columns kept),
// T-relaxed, I1, permutations only, any output rule (snapshot). Same algorithm as mincmov.py, faster.
// No R1 run with <= M adds  =>  every correct program (any length, any R) has #cmov >= M+1.  Proof: BOUNDS.md §R1.
// Pruning: admissible h = ceil(Huffman-sum) (BOUNDS.md §H3), memo on (canonical set A) with best budget seen.
// Symmetry: input relabelling S_n (columns map col(p) -> s(col(p o s)) ), state key = lexicographically least image.
// usage: mincmov N MAXM
#include <bits/stdc++.h>
using namespace std;
typedef vector<uint8_t> Col;
int N, NP, T; vector<array<int, 8>> P; vector<Col> TARGET; Col TCOL;
map<vector<int>, int> pindex;
vector<vector<int>> relab;      // relab[s][i] = index of perm (P[i] o s^-1)... see build
vector<vector<int>> sperm;      // the symmetries s

double huff(vector<double> w) {
    priority_queue<double, vector<double>, greater<double>> q;
    for (double x : w) if (x > 0) q.push(x);
    double c = 0;
    while (q.size() > 1) { double a = q.top(); q.pop(); double b = q.top(); q.pop(); c += a + b; q.push(a + b); }
    return c;
}

int hval(const vector<Col>& A) {
    double tot = 0;
    for (auto& t : TARGET) {
        bool have = false;
        for (auto& c : A) if (c == t) { have = true; break; }
        if (have) continue;
        map<int, int> cnt; bool uniq = true;
        for (int i = 0; i < NP; i++) {
            int k = 0, who = -1;
            for (int a = 0; a < (int)A.size(); a++) if (A[a][i] == t[i]) { k++; who = a; }
            if (k == 0) return 1 << 20;
            if (k > 1) { uniq = false; }
            cnt[who]++;
        }
        if (uniq) { vector<double> w; for (auto& kv : cnt) w.push_back((double)kv.second / NP); tot += huff(w); }
        else tot += 1;
    }
    return (int)ceil(tot - 1e-9);
}

inline int V(int i, int sym) { return sym == T ? 1000 : P[i][sym]; }

// image of column c under symmetry s: (s.c)[i] = s[c[j]] where perm i = perm j relabelled
Col image(const Col& c, int s) {
    Col r(NP);
    for (int i = 0; i < NP; i++) { int j = relab[s][i]; int v = c[j]; r[i] = (v == T) ? T : sperm[s][v]; }
    return r;
}

vector<Col> canon(vector<Col> A) {
    vector<Col> best;
    for (int s = 0; s < (int)sperm.size(); s++) {
        vector<Col> B; for (auto& c : A) B.push_back(image(c, s));
        sort(B.begin(), B.end());
        if (best.empty() || B < best) best = B;
    }
    return best;
}

map<vector<Col>, int> seen; long long nodes = 0;

bool dfs(vector<Col> A, int budget) {
    nodes++;
    bool all = true;
    for (auto& t : TARGET) { bool h = false; for (auto& c : A) if (c == t) { h = true; break; } if (!h) { all = false; break; } }
    if (all) return true;
    if (hval(A) > budget) return false;
    if (budget == 0) return false;
    vector<Col> key = canon(A);
    auto it = seen.find(key);
    if (it != seen.end() && it->second >= budget) return false;
    seen[key] = budget;
    vector<Col> cols = A; cols.push_back(TCOL);
    set<vector<int8_t>> fls;
    for (size_t a = 0; a < cols.size(); a++) for (size_t b = a + 1; b < cols.size(); b++) {
        vector<int8_t> f(NP);
        for (int i = 0; i < NP; i++) { int x = V(i, cols[a][i]), y = V(i, cols[b][i]); f[i] = (x < y) - (x > y); }
        fls.insert(f);
    }
    set<Col> kids;
    int conds[4][2] = {{1, 1}, {-1, -1}, {1, 0}, {-1, 0}};
    for (auto& f : fls) for (auto& cd : conds) {
        vector<bool> fire(NP); bool any = false;
        for (int i = 0; i < NP; i++) { fire[i] = (f[i] == cd[0] || f[i] == cd[1]); any |= fire[i]; }
        if (!any) continue;
        for (auto& S : A) for (auto& D : cols) {
            Col M(NP); for (int i = 0; i < NP; i++) M[i] = fire[i] ? S[i] : D[i];
            if (M == TCOL) continue;
            bool in = false; for (auto& c : A) if (c == M) { in = true; break; }
            if (!in) kids.insert(M);
        }
    }
    // order kids by h to find solutions faster
    vector<pair<int, Col>> ord;
    for (auto& M : kids) { vector<Col> B = A; B.push_back(M); int h = hval(B); if (h <= budget - 1) ord.push_back({h, M}); }
    sort(ord.begin(), ord.end());
    for (auto& hm : ord) { vector<Col> B = A; B.push_back(hm.second); if (dfs(B, budget - 1)) return true; }
    return false;
}

int main(int argc, char** argv) {
    N = atoi(argv[1]); int MAXM = atoi(argv[2]); T = N;
    vector<int> p(N); iota(p.begin(), p.end(), 0);
    do { array<int, 8> a{}; for (int i = 0; i < N; i++) a[i] = p[i]; pindex[p] = P.size(); P.push_back(a); } while (next_permutation(p.begin(), p.end()));
    NP = P.size();
    // symmetries: relabel inputs by s: new input s[i] gets old x_i. Perm i (values P[i][q] of x_q) maps to perm j with
    // P[j][s[q]] = P[i][q]. A column (symbol per perm) c maps to c' with c'[j] = s[c[i]].
    iota(p.begin(), p.end(), 0);
    do {
        sperm.push_back(p);
        vector<int> rl(NP);
        for (int i = 0; i < NP; i++) {
            vector<int> q(N); for (int k = 0; k < N; k++) q[p[k]] = P[i][k];
            rl[pindex[q]] = i;
        }
        relab.push_back(rl);
    } while (next_permutation(p.begin(), p.end()));
    TCOL.assign(NP, T);
    for (int j = 0; j < N; j++) {
        Col t(NP);
        for (int i = 0; i < NP; i++) for (int q = 0; q < N; q++) if (P[i][q] == j) t[i] = q;
        TARGET.push_back(t);
    }
    vector<Col> A0; for (int i = 0; i < N; i++) A0.push_back(Col(NP, i));
    int h0 = hval(A0); printf("root h = %d\n", h0); fflush(stdout);
    for (int m = h0; m <= MAXM; m++) {
        seen.clear(); nodes = 0;
        bool r = dfs(A0, m);
        printf("n=%d m<=%d: %s nodes=%lld memo=%zu\n", N, m, r ? "FOUND" : "none", nodes, seen.size()); fflush(stdout);
        if (r) break;
    }
}
