// d4-evolve: exhaustive repair of near-miss programs. For each program (length <= K), try every substitution of
// 1 or 2 instructions (positions i < j, any instruction over used registers + 1 fresh, or NOP).
// Filter: the child must be correct on the parent's failing cases (+ learned counterexamples); then full check (541).
// usage: rep2 -K 31 -S 10 -in FILE [-from a -to b] -out PREFIX
#include "sim.h"
#include <time.h>

static Task T, Ts;          // full and sub task (cases = filter set)
static int K = 31;
static Ins P[MAXL];
static Ins AL[8192]; static int na;
static int subidx[MAXT], nsub;

typedef struct { State st; uint8_t ok[5]; } Snap;   // ok[j] = some earlier write matched output j on all sub cases
static Snap pre[MAXL + 1];

static inline void step(Snap *x, Ins in) {
  exec1(&Ts, &x->st, in);
  if (in.op == NOP || in.op == CMP) return;
  const uint8_t *a = x->st.r[in.d];
  for (int j = 0; j < 5; j++) if (!x->ok[j]) {
    const uint8_t *e = Ts.expv[j]; int bad = 0;
    for (int k = 0; k < Ts.T; k++) bad |= (a[k] != e[k]);
    if (!bad) x->ok[j] = 1;
  }
}
static inline void scopy(Snap *d, const Snap *s) {
  for (int r = 0; r < Ts.nr; r++) memcpy(d->st.r[r], s->st.r[r], Ts.TP);
  memcpy(d->st.f, s->st.f, Ts.TP); memcpy(d->ok, s->ok, 5);
}
static inline int allok(const Snap *x) { return x->ok[0] & x->ok[1] & x->ok[2] & x->ok[3] & x->ok[4]; }

// full check; returns #failing weak orders, and fills fail list
static int full_fail(const Ins *p, int L, int *fl) {
  static State st; static uint8_t okc[5][MAXT]; int best[5];
  for (int j = 0; j < 5; j++) best[j] = 1 << 20;
  state_init(&T, &st);
  for (int i = 0; i < L; i++) {
    exec1(&T, &st, p[i]);
    if (p[i].op == NOP || p[i].op == CMP) continue;
    const uint8_t *a = st.r[p[i].d];
    for (int j = 0; j < 5; j++) {
      int c = 0; for (int k = 0; k < T.T; k++) c += a[k] != T.expv[j][k];
      if (c < best[j]) { best[j] = c; for (int k = 0; k < T.T; k++) okc[j][k] = a[k] == T.expv[j][k]; }
    }
  }
  int n = 0;
  for (int k = 0; k < T.T; k++) { int g = 1; for (int j = 0; j < 5; j++) g &= best[j] < (1 << 20) && okc[j][k]; if (!g) fl[n++] = k; }
  return n;
}

static void build_sub(void) {
  task_init(&Ts, 5, T.nr - 5, MOD_OUT, 0, "I1");
  Ts.T = nsub; Ts.TP = (nsub + 31) & ~31;
  for (int q = 0; q < Ts.TP; q++) {
    int k = subidx[q < nsub ? q : 0];
    for (int r = 0; r < T.nr; r++) Ts.init[r][q] = T.init[r][k];
    for (int j = 0; j < 5; j++) Ts.expv[j][q] = T.expv[j][k];
  }
}

static long nfull, ntried;
static FILE *fout;
static int report(Ins *q, int L, const char *what) {
  int fl[MAXT]; nfull++;
  int f = full_fail(q, L, fl);
  if (f == 0) {
    int k = 0; for (int i = 0; i < L; i++) k += q[i].op != NOP;
    fprintf(fout, "# prog PASS k=%d %s\n", k, what);
    Ins z[MAXL]; int m = 0; for (int i = 0; i < L; i++) if (q[i].op) z[m++] = q[i];
    print_prog(fout, &T, z, m); fflush(fout);
    fprintf(stderr, "PASS k=%d %s\n", k, what);
    return 1;
  }
  // learn a counterexample: add first failing case not yet in sub set
  if (nsub < 160) {
    for (int t = 0; t < f; t++) { int k = fl[t], in = 0; for (int u = 0; u < nsub; u++) in |= subidx[u] == k; if (!in) { subidx[nsub++] = k; return 2; } }
  }
  return 0;
}

int main(int argc, char **argv) {
  int ns = 10, from = 0, to = 1 << 30, two = 1; const char *in = NULL, *out = "rep2";
  for (int i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-K")) K = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-S")) ns = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-in")) in = argv[++i];
    else if (!strcmp(argv[i], "-from")) from = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-to")) to = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-one")) two = 0;
    else if (!strcmp(argv[i], "-out")) out = argv[++i];
  }
  task_init(&T, 5, ns, MOD_OUT, 0, "I1");
  char fn[512]; sprintf(fn, "%s_found.txt", out); fout = fopen(fn, "a");
  FILE *fi = fopen(in, "r"); char line[256]; int idx = -1, L = 0;
  int done = 0;
  while (!done) {
    char *r = fgets(line, sizeof line, fi);
    int isnew = !r || !strncmp(line, "# prog", 6);
    if (isnew && L && idx >= from && idx < to) {
      // ---- process program P[0..L)
      time_t t0 = time(NULL);
      while (L < K) P[L++] = (Ins){NOP, 0, 0};
      int fl[MAXT]; int f0 = full_fail(P, L, fl);
      nsub = 0; for (int t = 0; t < f0 && nsub < 120; t++) subidx[nsub++] = fl[t];
      // alphabet: registers used + 1 fresh
      int used[MAXR] = {0}, rl[MAXR], nr = 0;
      for (int r = 0; r < 5; r++) used[r] = 1;
      for (int i = 0; i < L; i++) if (P[i].op) used[P[i].d] = used[P[i].s] = 1;
      for (int r = 0; r < T.nr; r++) if (used[r]) rl[nr++] = r;
      for (int r = 5; r < T.nr; r++) if (!used[r]) { rl[nr++] = r; break; }
      na = 0; AL[na++] = (Ins){NOP, 0, 0};
      const int OPS[6] = {MOV, CMP, CMOVL, CMOVG, CMOVLE, CMOVGE};
      for (int o = 0; o < 6; o++) for (int a = 0; a < nr; a++) for (int b = 0; b < nr; b++) if (a != b) AL[na++] = (Ins){OPS[o], rl[a], rl[b]};
      int hits = 0;
      build_sub();
      state_init(&Ts, &pre[0].st); memset(pre[0].ok, 0, 5);
      for (int i = 0; i < L; i++) { scopy(&pre[i + 1], &pre[i]); step(&pre[i + 1], P[i]); }
      static Snap s1, s2, s3;
#define REBUILD(i_, ia_, j_) do { build_sub(); state_init(&Ts, &pre[0].st); memset(pre[0].ok, 0, 5); \
        for (int t_ = 0; t_ < L; t_++) { scopy(&pre[t_ + 1], &pre[t_]); step(&pre[t_ + 1], P[t_]); } \
        scopy(&s1, &pre[i_]); step(&s1, ia_); for (int t_ = i_ + 1; t_ < (j_); t_++) step(&s1, P[t_]); } while (0)
      for (int i = 0; i < L; i++) for (int a = 0; a < na; a++) {
        Ins ia = AL[a]; if (ia.op == P[i].op && ia.d == P[i].d && ia.s == P[i].s) continue;
        scopy(&s1, &pre[i]); step(&s1, ia);
        // single substitution
        scopy(&s2, &s1); for (int t = i + 1; t < L; t++) step(&s2, P[t]);
        ntried++;
        if (allok(&s2)) { Ins q[MAXL]; memcpy(q, P, L * sizeof(Ins)); q[i] = ia; char w[64]; sprintf(w, "src=%d sub1 i=%d", idx, i);
          int rr = report(q, L, w); if (rr == 1) hits++; if (rr == 2) REBUILD(i, ia, i + 1); }
        if (!two) continue;
        for (int j = i + 1; j < L; j++) {
          // s1 = state before j with substitution at i
          for (int b = 0; b < na; b++) {
            Ins ib = AL[b]; if (ib.op == P[j].op && ib.d == P[j].d && ib.s == P[j].s) continue;
            scopy(&s3, &s1); step(&s3, ib);
            for (int t = j + 1; t < L; t++) step(&s3, P[t]);
            ntried++;
            if (allok(&s3)) { Ins q[MAXL]; memcpy(q, P, L * sizeof(Ins)); q[i] = ia; q[j] = ib; char w[64]; sprintf(w, "src=%d sub2 i=%d j=%d", idx, i, j);
              int rr = report(q, L, w); if (rr == 1) hits++; if (rr == 2) REBUILD(i, ia, j); }
          }
          step(&s1, P[j]);
        }
      }
      fprintf(stderr, "prog %d: f0=%d na=%d nsub=%d tried=%ld full=%ld hits=%d %lds\n", idx, f0, na, nsub, ntried, nfull, hits, (long)(time(NULL) - t0));
    }
    if (!r) break;
    if (isnew) { idx++; L = 0; nsmap = 0; if (idx >= to) done = 1; continue; }
    char *h = strchr(line, '#'); if (h) *h = 0;
    char op[32], a[16], b[16];
    if (sscanf(line, " %31s %15[^, ] , %15s", op, a, b) != 3 || !strcmp(op, "out")) continue;
    int o = -1; for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    if (o < 0) continue;
    P[L].op = o; P[L].d = parse_reg(&T, a); P[L].s = parse_reg(&T, b); L++;
  }
  return 0;
}
