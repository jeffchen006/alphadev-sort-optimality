// upper: large-neighbourhood search. For a correct program p of length k, for every window [i, i+w),
// try ALL sequences of length w-1 (over registers used in p plus `fresh` new scratch registers).
// Any hit is a correct program of length k-1. Repeats on the new program until no hit.
// usage: lns -n N -m model -i iset -start f.s -w W [-fresh F] [-out prefix] [-win a:b]
#include "sim.h"

static Task T, Tsub;
static Ins alpha[4096]; static int na;
static Ins P[MAXL]; static int K;
static State pre, pre_sub;
static long tried;
static int hitL; static Ins hit[MAXL];

static int check_from(const Task *t, const State *s0, const Ins *seq, int m, const Ins *suf, int ns) {
  static __thread State st;
  for (int r = 0; r < t->nr; r++) memcpy(st.r[r], s0->r[r], t->TP);
  memcpy(st.f, s0->f, t->TP);
  for (int i = 0; i < m; i++) exec1(t, &st, seq[i]);
  for (int i = 0; i < ns; i++) exec1(t, &st, suf[i]);
  int err[5][MAXR];
  errmat(t, &st, err);
  return assign_cost(t, err, NULL);
}

static Ins seq[8];
static uint64_t liveout; static int flaglive_out;   // registers live after window; flags read by suffix before a cmp
static long pruned;
// read/write sets as bitmasks; bit 63 = flags
static inline uint64_t RD(Ins x) {
  switch (x.op) { case NOP: return 0; case MOV: return 1ULL << x.s; case CMP: return (1ULL << x.s) | (1ULL << x.d);
    case XCHG: return (1ULL << x.s) | (1ULL << x.d); default: return (1ULL << x.s) | (1ULL << x.d) | (1ULL << 63); }
}
static inline uint64_t WR(Ins x) {
  switch (x.op) { case NOP: return 0; case CMP: return 1ULL << 63; case XCHG: return (1ULL << x.s) | (1ULL << x.d);
    default: return 1ULL << x.d; }
}
static inline int key(Ins x) { return (x.op << 16) | (x.d << 8) | x.s; }
static int useless(int m) {
  // backward liveness: every instruction must write something live
  uint64_t live = liveout | (flaglive_out ? 1ULL << 63 : 0);
  for (int k = m - 1; k >= 0; k--) {
    uint64_t w = WR(seq[k]);
    if (!(w & live)) return 1;
    if (seq[k].op == MOV || seq[k].op == CMP) live &= ~w;   // full overwrite
    live |= RD(seq[k]);
  }
  return 0;
}
static void compute_liveout(const Ins *suf, int ns, int nregs_total) {
  uint64_t live = 0, killed = 0; int fl = -1;
  for (int k = 0; k < ns; k++) {
    uint64_t r = RD(suf[k]) & ~(1ULL << 63);
    live |= r & ~killed;
    if ((RD(suf[k]) >> 63) && fl < 0) fl = 1;
    if (suf[k].op == CMP && fl < 0) fl = 0;
    if (suf[k].op == MOV) killed |= 1ULL << suf[k].d;
  }
  // registers never killed in suffix may be final outputs (free/out models): treat as live
  for (int r = 0; r < nregs_total; r++) if (!(killed >> r & 1)) live |= 1ULL << r;
  liveout = live; flaglive_out = fl == 1;
}
static int rec(int depth, int m, const Ins *suf, int ns, int i) {
  if (depth >= 2) {  // canonical order for adjacent commuting instructions
    Ins a = seq[depth - 2], b = seq[depth - 1];
    if (!(WR(a) & (RD(b) | WR(b))) && !(WR(b) & RD(a)) && key(a) > key(b)) { pruned++; return 0; }
  }
  if (depth == m) {
    if (useless(m)) { pruned++; return 0; }
    tried++;
    if (check_from(&Tsub, &pre_sub, seq, m, suf, ns)) return 0;
    if (check_from(&T, &pre, seq, m, suf, ns)) return 0;
    // build hit
    hitL = 0;
    for (int a = 0; a < i; a++) hit[hitL++] = P[a];
    for (int a = 0; a < m; a++) hit[hitL++] = seq[a];
    for (int a = 0; a < ns; a++) hit[hitL++] = suf[a];
    return 1;
  }
  for (int a = 0; a < na; a++) {
    seq[depth] = alpha[a];
    if (rec(depth + 1, m, suf, ns, i)) return 1;
  }
  return 0;
}

static void make_sub(void) {
  // subset: 64 tests chosen spread over all tests (deterministic)
  Tsub = T;
  int m = 0;
  for (int k = 0; k < T.T && m < 64; k += (T.T > 64 ? T.T / 64 : 1)) {
    for (int r = 0; r < MAXR; r++) Tsub.init[r][m] = T.init[r][k];
    for (int j = 0; j < T.n; j++) Tsub.expv[j][m] = T.expv[j][k];
    m++;
  }
  Tsub.T = m; Tsub.TP = (m + 31) & ~31;
  for (int k = m; k < Tsub.TP; k++) {
    for (int r = 0; r < MAXR; r++) Tsub.init[r][k] = Tsub.init[r][0];
    for (int j = 0; j < T.n; j++) Tsub.expv[j][k] = Tsub.expv[j][0];
  }
}

int main(int argc, char **argv) {
  int n = 4, model = MOD_FREE, memops = 0, w = 3, fresh = 1, wa = 0, wb = 1000;
  const char *iset = "I1", *start = NULL, *out = "lns";
  for (int i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-n")) n = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-m")) { i++; model = !strcmp(argv[i], "P") ? MOD_P : !strcmp(argv[i], "free") ? MOD_FREE : !strcmp(argv[i], "out") ? MOD_OUT : MOD_MEM; }
    else if (!strcmp(argv[i], "-memops")) memops = 1;
    else if (!strcmp(argv[i], "-i")) iset = argv[++i];
    else if (!strcmp(argv[i], "-start")) start = argv[++i];
    else if (!strcmp(argv[i], "-w")) w = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-fresh")) fresh = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-out")) out = argv[++i];
    else if (!strcmp(argv[i], "-win")) { sscanf(argv[++i], "%d:%d", &wa, &wb); }
  }
  task_init(&T, n, 16, model, memops, iset);
  K = read_prog(&T, start, P);
  if (wrong(&T, P, K, NULL)) { fprintf(stderr, "start program not correct\n"); return 1; }
  make_sub();
  for (int round = 0;; round++) {
    // alphabet: registers used + fresh scratch
    int used[MAXR] = {0}, regs[MAXR], nreg = 0, maxs = n - 1;
    for (int i = 0; i < n; i++) used[i] = 1;
    for (int i = 0; i < K; i++) { used[P[i].d] = used[P[i].s] = 1; }
    for (int r = 0; r < T.nr; r++) if (used[r]) regs[nreg++] = r, maxs = r;
    for (int f = 0, r = maxs + 1; f < fresh && r < T.nr; f++, r++) regs[nreg++] = r;
    na = 0;
    for (int o = 1; o < NOPS; o++) if (T.opsok[o])
      for (int a = 0; a < nreg; a++) for (int b = 0; b < nreg; b++) {
        Ins in = {o, regs[a], regs[b]};
        if (o == XCHG && a > b) continue;
        if (legal(&T, in)) alpha[na++] = in;
      }
    fprintf(stderr, "round %d: K=%d alphabet=%d (regs %d)\n", round, K, na, nreg);
    int found = 0;
    for (int i = wa; i + w <= K && i <= wb && !found; i++) {
      run(&T, &pre, P, i); run(&Tsub, &pre_sub, P, i);
      tried = 0; pruned = 0;
      compute_liveout(P + i + w, K - i - w, T.nr);
      if (rec(0, w - 1, P + i + w, K - i - w, i)) found = 1;
      fprintf(stderr, "  window %d..%d tried %ld pruned %ld %s\n", i, i + w - 1, tried, pruned, found ? "HIT" : "");
    }
    if (!found) break;
    K = dce(&T, hit, hitL);
    memcpy(P, hit, K * sizeof(Ins));
    int outr[5]; wrong(&T, P, K, outr);
    char fn[512]; sprintf(fn, "%s_len%d.s", out, K);
    FILE *fo = fopen(fn, "w"); char bb[8];
    fprintf(fo, "# n=%d model=%s iset=%s memops=%d len=%d source=upper lns w=%d outputs:", n,
            model == MOD_P ? "P" : model == MOD_FREE ? "free" : model == MOD_OUT ? "out" : "mem", iset, memops, K, w);
    for (int j = 0; j < n; j++) { regname(&T, outr[j], bb); fprintf(fo, " %s", bb); }
    fprintf(fo, "\n"); print_prog(fo, &T, P, K); fclose(fo);
    printf("FOUND len=%d file=%s\n", K, fn); fflush(stdout);
  }
  printf("LNS done: final len=%d\n", K);
  return 0;
}
