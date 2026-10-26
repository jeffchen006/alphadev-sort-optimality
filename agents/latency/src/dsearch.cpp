// dsearch: exhaustive IDA* search for the shortest sorting program with critical-path depth <= D
// (latency agent; own code, no sharing with sat/enum/critic).
//
// Model: shared/MODEL.md M_out (snapshot outputs, free), relaxed lower-bound semantics
// (scratch = T > all inputs, cmp(T,T) = eq, initial flags = eq), all weak order types,
// registers unbounded.  Latency model: mov latency ML (U: 1, E: 0), cmp latency CL (1, Z2: 2),
// cmov latency 1.  Depth = longest RAW chain (registers + flags), see MODEL_LATENCY.md.
//
// Reductions (each keeps at least one shortest program of depth <= D; see RULES_LATENCY.md):
//  S1 registers are a multiset of (content, depth): register names do not matter (M_out, R unbounded).
//  S2 mov writes a fresh register (overwriting by mov = renaming).
//  S3 a register or flags of depth >= D is dropped after the output check (no instruction of depth <= D
//     can read it).  Flags of depth >= D are dropped.
//  S4 no cmp that gives constant flags on all order types (then each cmov = mov or no-op);
//     no cmp right after a cmp (first one dead); no cmov before the first cmp (flags = eq: cmovl/g no-op,
//     cmovle/ge = mov, mov is not deeper).
//  S5 no instruction whose result equals the old content of its destination (no-op).
//  S6 an all-T register is not stored (fresh pool).
// Heuristic (admissible): every uncaptured output needs >= 1 more cmov (a mov copies an existing
// content, which is already captured if it is an output); +1 if no usable flags.
//
//  S7 a mov is placed right before its first use: the next instruction reads or writes a register with
//     the copied content (moving a mov down past instructions that do not touch the copy or the original
//     keeps the program and its depth).
//  S8 two adjacent independent cmovs (same flags; neither reads/writes what the other writes) are in
//     lexicographic order of (dst content, dst depth, src content, src depth, cond), except for the cmov
//     right after a mov (S7 fixes it).  Adjacent swaps of independent instructions keep the program.
// usage: dsearch n D kmax [ML CL iset(0=I0,1=I1) BC BM]   (BC, BM: proven bounds #cmp >= BC, #cmov >= BM)
#include <bits/stdc++.h>
using namespace std;

int n, D, KMAX, ML = 1, CL = 1, ISET = 1, BC = 0, BM = 0;   // BC/BM: proven #cmp / #cmov lower bounds (0 = off)
int NW;
vector<vector<int>> W;            // order types (ranks)
const int TSYM = 15;

// content interning
map<vector<uint8_t>, int> cid;
vector<vector<uint8_t>> cont;
int intern(const vector<uint8_t>& v) {
    auto it = cid.find(v);
    if (it != cid.end()) return it->second;
    int id = cont.size(); cid[v] = id; cont.push_back(v); return id;
}
map<vector<uint8_t>, int> fidm;   // flags vectors: 0 = eq, 1 = lt, 2 = gt
vector<vector<uint8_t>> flg;
int internf(const vector<uint8_t>& v) {
    auto it = fidm.find(v);
    if (it != fidm.end()) return it->second;
    int id = flg.size(); fidm[v] = id; flg.push_back(v); return id;
}
int rk(int w, int c) { return c == TSYM ? 1000 : W[w][c]; }

vector<vector<int>> target_ok;    // per output j: per w, set of acceptable symbols (bitmask)
int is_output(int c) {             // returns j or -1
    const auto& v = cont[c];
    for (int j = 0; j < n; j++) {
        bool ok = true;
        for (int w = 0; w < NW && ok; w++) ok = v[w] != TSYM && ((target_ok[j][w] >> v[w]) & 1);
        if (ok) return j;
    }
    return -1;
}
vector<int> outmemo;
int outof(int c) {
    while ((int)outmemo.size() <= c) outmemo.push_back(-2);
    if (outmemo[c] == -2) outmemo[c] = is_output(c);
    return outmemo[c];
}

struct Reg { int c, d, nm; bool operator<(const Reg& o) const { return c != o.c ? c < o.c : d < o.d; }
             bool operator==(const Reg& o) const { return c == o.c && d == o.d; } };
struct State {
    vector<Reg> r;    // sorted
    int f, fd;        // flags id (-1 = none/unusable), depth
    int mask;         // captured outputs
    bool cmped;       // a cmp happened (S4)
    bool lastcmp;
    int pend;          // content of the last mov copy (S7), -1 none
    int ncmp, ncmov;   // capped at BC / BM
    int lk[5];         // key of the last cmov if it may be reordered (S8), lk[0] = -2 none
    int lastnew;       // content written by the last cmov (not in the key: only used with lk)
};
string key(const State& s) {
    string k;
    k.reserve(s.r.size() * 8 + 16);
    for (auto& x : s.r) { k.append((char*)&x.c, 4); k.push_back((char)x.d); }
    k.push_back('|'); k.append((char*)&s.f, 4); k.push_back((char)s.fd); k.push_back((char)s.mask);
    k.push_back(s.cmped); k.push_back(s.lastcmp);
    k.append((char*)&s.pend, 4); k.push_back((char)s.ncmp); k.push_back((char)s.ncmov);
    k.append((char*)s.lk, 20); if (s.lk[0] != -2) k.append((char*)&s.lastnew, 4);
    return k;
}

struct Ins { int op; int cond; Reg d, s; };   // op 0 mov 1 cmp 2 cmov
vector<string> trace;
unordered_map<string, int> TT;
long long nodes = 0;
int FULL;
int fresh_ctr = 0;
string rn(int nm) { return nm < n ? "P" + to_string(nm) : "S" + to_string(nm - n); }
const char* CN[4] = {"cmovl", "cmovg", "cmovle", "cmovge"};

bool condv(int cond, uint8_t f) { // f: 0 eq 1 lt 2 gt
    switch (cond) { case 0: return f == 1; case 1: return f == 2; case 2: return f != 2; default: return f != 1; }
}

void normalize(State& s) {
    vector<Reg> r2;
    for (auto& x : s.r) {
        if (x.d >= D) continue;                              // S3
        bool allT = true; for (auto v : cont[x.c]) if (v != TSYM) { allT = false; break; }
        if (allT) continue;                                  // S6
        r2.push_back(x);
    }
    sort(r2.begin(), r2.end());
    s.r = r2;
    if (s.f >= 0 && s.fd >= D) { s.f = -1; }
}

int hval(const State& s) {
    int u = n - __builtin_popcount(s.mask);
    if (u == 0) return 0;
    int needc = max(0, BC - s.ncmp);
    int h = needc + max(u, BM - s.ncmov);
    if (s.f < 0 && needc == 0) h++;
    return h;
}

bool dfs(State& s, int g, int bound) {
    nodes++;
    if (s.mask == FULL) return true;
    if (g + hval(s) > bound) return false;
    string k = key(s);
    auto it = TT.find(k);
    if (it != TT.end() && it->second <= g) return false;
    TT[k] = g;
    int R = s.r.size();
    // candidate list of registers incl. fresh (index R = fresh T)
    auto capture = [&](State& t, const Reg& x) { int j = outof(x.c); if (j >= 0) t.mask |= 1 << j; };
    // mov fresh <- r
    auto involves = [&](int c) { return s.pend < 0 || c == s.pend; };
    for (int i = 0; i < R; i++) {
        if (i > 0 && s.r[i] == s.r[i - 1]) continue;
        if (!involves(s.r[i].c)) continue;                  // S7
        Reg x{s.r[i].c, s.r[i].d + ML, n + fresh_ctr};
        if (x.d >= D && outof(x.c) < 0) continue;
        State t = s; t.r.push_back(x); t.lastcmp = false; t.pend = x.c; t.lk[0] = -2; capture(t, x); normalize(t);
        trace.push_back("mov " + rn(x.nm) + ", " + rn(s.r[i].nm) + (outof(x.c) >= 0 ? "\n  out " + to_string(outof(x.c)) + ", " + rn(x.nm) : ""));
        fresh_ctr++;
        if (dfs(t, g + 1, bound)) return true;
        fresh_ctr--;
        trace.pop_back();
    }
    // cmp a, b
    if (!s.lastcmp) {
        for (int a = 0; a < R; a++) for (int b = 0; b < R; b++) {
            if (a == b) continue;
            if (a > 0 && s.r[a] == s.r[a - 1]) continue;
            if (b > 0 && s.r[b] == s.r[b - 1] && b - 1 != a) continue;
            if (s.pend >= 0 && s.r[a].c != s.pend && s.r[b].c != s.pend) continue;   // S7
            int fd = max(s.r[a].d, s.r[b].d) + CL;
            if (fd >= D) continue;
            vector<uint8_t> fv(NW);
            bool c0 = true, c1 = true, c2 = true;
            for (int w = 0; w < NW; w++) {
                int x = rk(w, cont[s.r[a].c][w]), y = rk(w, cont[s.r[b].c][w]);
                fv[w] = x < y ? 1 : (x > y ? 2 : 0);
                c0 &= fv[w] == 0; c1 &= fv[w] == 1; c2 &= fv[w] == 2;
            }
            if (c0 || c1 || c2) continue;                   // S4 constant flags
            State t = s; t.f = internf(fv); t.fd = fd; t.cmped = true; t.lastcmp = true;
            t.pend = -1; t.lk[0] = -2; t.ncmp = min(BC, s.ncmp + 1);
            normalize(t);
            trace.push_back("cmp " + rn(s.r[a].nm) + ", " + rn(s.r[b].nm));
            if (dfs(t, g + 1, bound)) return true;
            trace.pop_back();
        }
    }
    // cmovX d, s
    if (s.f >= 0 && s.cmped) {
        const vector<uint8_t> fv = flg[s.f];
        int nc = ISET ? 4 : 2;
        for (int di = 0; di <= R; di++) {
            if (di < R && di > 0 && s.r[di] == s.r[di - 1]) continue;
            Reg dold = di < R ? s.r[di] : Reg{-1, 0, n + fresh_ctr};
            for (int si = 0; si <= R; si++) {
                if (si == di && si < R) continue;
                if (si == R && di == R) continue;
                if (si < R && si > 0 && s.r[si] == s.r[si - 1] && si - 1 != di) continue;
                if (s.pend >= 0 && !((di < R && dold.c == s.pend) || (si < R && s.r[si].c == s.pend))) continue;   // S7
                for (int cnd = 0; cnd < nc; cnd++) {
                    int dd = di < R ? dold.d : 0, sd = si < R ? s.r[si].d : 0;
                    int key5[5] = {di < R ? dold.c : -1, dd, si < R ? s.r[si].c : -1, sd, cnd};
                    if (s.lk[0] != -2) {   // S8: previous instr = reorderable cmov with the same flags
                        // independent?  lk = (dst old c, dst old d, src c, src d, cond, new content in lk? )
                        bool indep = !(di < R && dold.c == s.lastnew) && !(si < R && s.r[si].c == s.lastnew) &&
                                     !(di < R && dold.c == s.lk[2] && dold.d == s.lk[3]) && !(di == R && s.lk[0] == -1 && false);
                        if (indep && lexicographical_compare(key5, key5 + 5, s.lk, s.lk + 5)) continue;
                    }
                    int nd = max(max(dd, sd), s.fd) + 1;
                    if (nd > D) continue;
                    vector<uint8_t> v(NW);
                    bool same = true;
                    for (int w = 0; w < NW; w++) {
                        uint8_t dv = di < R ? cont[dold.c][w] : TSYM;
                        uint8_t sv = si < R ? cont[s.r[si].c][w] : TSYM;
                        v[w] = condv(cnd, fv[w]) ? sv : dv;
                        same &= v[w] == dv;
                    }
                    if (same) continue;                     // S5
                    int c = intern(v);
                    if (nd >= D && outof(c) < 0) continue;
                    State t = s;
                    Reg x{c, nd, dold.nm};
                    if (di < R) t.r[di] = x; else t.r.push_back(x);
                    t.lastcmp = false;
                    t.ncmov = min(BM, s.ncmov + 1);
                    if (s.pend >= 0) t.lk[0] = -2; else { memcpy(t.lk, key5, sizeof key5); }
                    t.lastnew = c;
                    t.pend = -1;
                    capture(t, x); normalize(t);
                    // a fresh source is an unwritten scratch register (T): give it its own name
                    string srcn = si < R ? rn(s.r[si].nm) : rn(n + fresh_ctr + (di == R ? 1 : 0));
                    trace.push_back(string(CN[cnd]) + " " + rn(dold.nm) + ", " + srcn + (outof(x.c) >= 0 ? "\n  out " + to_string(outof(x.c)) + ", " + rn(x.nm) : ""));
                    int inc = (di == R) + (si == R);
                    fresh_ctr += inc;
                    if (dfs(t, g + 1, bound)) return true;
                    fresh_ctr -= inc;
                    trace.pop_back();
                }
            }
        }
    }
    return false;
}

int main(int argc, char** argv) {
    if (argc < 4) { fprintf(stderr, "usage: dsearch n D kmax [ML CL iset]\n"); return 1; }
    n = atoi(argv[1]); D = atoi(argv[2]); KMAX = atoi(argv[3]);
    if (argc > 4) ML = atoi(argv[4]);
    if (argc > 5) CL = atoi(argv[5]);
    if (argc > 6) ISET = atoi(argv[6]);
    // weak orders
    set<vector<int>> ws;
    vector<int> r(n, 0);
    function<void(int)> gen = [&](int i) {
        if (i == n) { vector<int> v = r; vector<int> s = v; sort(s.begin(), s.end()); s.erase(unique(s.begin(), s.end()), s.end());
                      for (auto& x : v) x = lower_bound(s.begin(), s.end(), x) - s.begin(); ws.insert(v); return; }
        for (int x = 0; x < n; x++) { r[i] = x; gen(i + 1); }
    };
    gen(0);
    W.assign(ws.begin(), ws.end()); NW = W.size();
    target_ok.assign(n, vector<int>(NW, 0));
    for (int w = 0; w < NW; w++) {
        vector<int> s = W[w]; sort(s.begin(), s.end());
        for (int j = 0; j < n; j++) for (int i = 0; i < n; i++) if (W[w][i] == s[j]) target_ok[j][w] |= 1 << i;
    }
    FULL = (1 << n) - 1;
    if (argc > 8) { BC = atoi(argv[7]); BM = atoi(argv[8]); }
    State s0; s0.f = -1; s0.fd = 0; s0.mask = 0; s0.cmped = false; s0.lastcmp = false;
    s0.pend = -1; s0.ncmp = 0; s0.ncmov = 0; s0.lk[0] = -2; s0.lk[1] = s0.lk[2] = s0.lk[3] = s0.lk[4] = 0; s0.lastnew = -1;
    for (int i = 0; i < n; i++) { vector<uint8_t> v(NW); for (int w = 0; w < NW; w++) v[w] = i; s0.r.push_back({intern(v), 0, i}); }
    normalize(s0);
    printf("n=%d D=%d ML=%d CL=%d iset=I%d |W|=%d bounds cmp>=%d cmov>=%d\n", n, D, ML, CL, ISET, NW, BC, BM); fflush(stdout);
    for (int k = 1; k <= KMAX; k++) {
        TT.clear(); trace.clear();
        auto t0 = chrono::steady_clock::now();
        bool ok = dfs(s0, 0, k);
        double sec = chrono::duration<double>(chrono::steady_clock::now() - t0).count();
        printf("k=%d %s nodes=%lld tt=%zu contents=%zu %.1fs\n", k, ok ? "FOUND" : "none", nodes, TT.size(), cont.size(), sec);
        fflush(stdout);
        if (ok) {
            for (auto& x : trace) printf("  %s\n", x.c_str());
            for (size_t c = 0; c < cont.size() && c < 0; c++) {}
            return 0;
        }
    }
    return 0;
}
