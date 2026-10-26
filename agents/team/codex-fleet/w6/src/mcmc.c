// upper: STOKE-style MCMC over fixed-slot programs (NOP = empty slot).
// cost = W * wrong + lam * length.  Records every correct program shorter than the best seen.
#include "sim.h"
#include <math.h>
#include <time.h>
#include <unistd.h>

static uint64_t rs;
static inline uint64_t rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static inline double urand(void) { return (rnd() >> 11) * (1.0 / 9007199254740992.0); }

static Task T;
static int nops_ok[NOPS], nopl;

static Ins rand_ins(void) {
  for (;;) {
    Ins in;
    in.op = nops_ok[rnd() % nopl];
    in.d = rnd() % T.nr; in.s = rnd() % T.nr;
    if (legal(&T, in)) return in;
  }
}


// ---- incremental evaluation: SN[i] = state (and MOD_OUT best-so-far errors) before instruction i of `cur`
typedef struct { State st; int best[5]; } Snap;
static Snap SN[MAXL + 1], TMP;
static inline void scopy(Snap *d, const Snap *s) {
  for (int r = 0; r < T.nr; r++) memcpy(d->st.r[r], s->st.r[r], T.TP);
  memcpy(d->st.f, s->st.f, T.TP); memcpy(d->best, s->best, sizeof d->best);
}
static inline void step(Snap *x, Ins in) {
  exec1(&T, &x->st, in);
  if (T.model != MOD_OUT || in.op == NOP || in.op == CMP) return;
  for (int w = 0; w < (in.op == XCHG ? 2 : 1); w++) {
    const uint8_t *a = x->st.r[w ? in.s : in.d];
    for (int j = 0; j < T.n; j++) {
      const uint8_t *e = T.expv[j]; int c = 0;
      for (int k = 0; k < T.T; k++) c += (a[k] != e[k]);
      if (c < x->best[j]) x->best[j] = c;
    }
  }
}
static int final_cost(Snap *x) {
  if (T.model == MOD_OUT) { int c = 0; for (int j = 0; j < T.n; j++) c += x->best[j]; return c; }
  int err[5][MAXR]; errmat(&T, &x->st, err); return assign_cost(&T, err, NULL);
}
static void snap_build(const Ins *p, int L, int from) {
  if (from == 0) { state_init(&T, &SN[0].st); for (int j = 0; j < 5; j++) SN[0].best[j] = 1 << 20; }
  for (int i = from; i < L; i++) { scopy(&SN[i + 1], &SN[i]); step(&SN[i + 1], p[i]); }
}
static int eval_from(const Ins *p, int L, int lo) {
  scopy(&TMP, &SN[lo]);
  for (int i = lo; i < L; i++) step(&TMP, p[i]);
  return final_cost(&TMP);
}

// ---- collection of distinct correct programs (DCE + scratch renaming by first use; hash set)
#define HSZ (1 << 22)
static uint64_t *hset; static long ncoll;
static uint64_t canon_hash(const Ins *q, int l) {
  int map[MAXR]; for (int r = 0; r < MAXR; r++) map[r] = -1;
  int nx = T.nin; uint64_t h = 1469598103934665603ULL;
  for (int i = 0; i < l; i++) {
    int rr[2] = {q[i].d, q[i].s};
    for (int k = 0; k < 2; k++) { int r = rr[k]; if (r >= T.nin && map[r] < 0) map[r] = nx++; rr[k] = r >= T.nin ? map[r] : r; }
    uint64_t x = (q[i].op << 16) | (rr[0] << 8) | rr[1];
    h = (h ^ x) * 1099511628211ULL;
  }
  return h | 1;
}
static void collect(const Ins *cur, int L, int K, const char *out) {
  Ins q[MAXL]; memcpy(q, cur, sizeof(Ins) * L);
  int l = dce(&T, q, L);
  if (l > K) return;
  if (!hset) hset = calloc(HSZ, 8);
  uint64_t h = canon_hash(q, l); uint64_t i = h & (HSZ - 1);
  while (hset[i]) { if (hset[i] == h) return; i = (i + 1) & (HSZ - 1); }
  if (ncoll > HSZ / 2) return;
  hset[i] = h; ncoll++;
  char fn[512]; sprintf(fn, "%s_coll.txt", out);
  FILE *fo = fopen(fn, "a"); fprintf(fo, "# prog len=%d\n", l); print_prog(fo, &T, q, l); fclose(fo);
}

// ---- critical-path depth (latency agent's definition: RAW data + flags; inputs ready at 0;
// mov latency = latmov (U: 1, E: 0), cmp = cmov = 1; output j = ready time of its snapshot)
static int latmov = 1; static double mu = 0;
static int depth_of(const Ins *p, int L) {
  int outr[5], outt[5], t[MAXR] = {0}, tf = 0, at[MAXL][5];
  wrong_out(&T, p, L, outr, outt);
  int dj[5];
  for (int j = 0; j < T.n; j++) dj[j] = 0;
  for (int i = 0; i < L; i++) {
    Ins x = p[i];
    switch (x.op) {
      case NOP: break;
      case MOV: t[x.d] = t[x.s] + latmov; break;
      case CMP: tf = (t[x.d] > t[x.s] ? t[x.d] : t[x.s]) + 1; break;
      case XCHG: { int z = t[x.d]; t[x.d] = t[x.s] + latmov; t[x.s] = z + latmov; break; }
      default: { int m = t[x.d] > t[x.s] ? t[x.d] : t[x.s]; if (tf > m) m = tf; t[x.d] = m + 1; }
    }
    for (int j = 0; j < T.n; j++) if (outt[j] == i) dj[j] = t[outr[j]];
  }
  int mx = 0; for (int j = 0; j < T.n; j++) if (dj[j] > mx) mx = dj[j];
  (void)at; return mx;
}

int main(int argc, char **argv) {
  int collectK = 0, mincmp = 0, maxcmp = 99, n = 4, L = 20, ns = 4, model = MOD_FREE, memops = 0, del = 0, report_all = 0;
  long iters = 1000000000L; double temp = 1.0, lam = 0.0, W = 1.0, tlimit = 60, prestart = 0.0;
  const char *iset = "I1", *start = NULL, *out = "found";
  uint64_t seed = time(NULL) ^ getpid();
  for (int i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-n")) n = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-L")) L = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-S")) ns = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-m")) { i++; model = !strcmp(argv[i], "P") ? MOD_P : !strcmp(argv[i], "free") ? MOD_FREE : !strcmp(argv[i], "out") ? MOD_OUT : MOD_MEM; }
    else if (!strcmp(argv[i], "-memops")) memops = 1;
    else if (!strcmp(argv[i], "-i")) iset = argv[++i];
    else if (!strcmp(argv[i], "-start")) start = argv[++i];
    else if (!strcmp(argv[i], "-del")) del = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-T")) temp = atof(argv[++i]);
    else if (!strcmp(argv[i], "-lam")) lam = atof(argv[++i]);
    else if (!strcmp(argv[i], "-time")) tlimit = atof(argv[++i]);
    else if (!strcmp(argv[i], "-restart")) prestart = atof(argv[++i]);  // restart prob per iter
    else if (!strcmp(argv[i], "-seed")) seed = strtoull(argv[++i], 0, 10);
    else if (!strcmp(argv[i], "-out")) out = argv[++i];
    else if (!strcmp(argv[i], "-all")) report_all = 1;
    else if (!strcmp(argv[i], "-maxcmp")) maxcmp = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-mincmp")) mincmp = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-iters")) iters = atol(argv[++i]);
    else if (!strcmp(argv[i], "-depth")) { i++; latmov = argv[i][0] == 'E' ? 0 : 1; mu = atof(argv[++i]); }  // -depth U|E weight
    else if (!strcmp(argv[i], "-collect")) collectK = atoi(argv[++i]);   // save every distinct correct program of len <= K
  }
  rs = seed * 2654435761ULL + 88172645463325252ULL;
  task_init(&T, n, ns, model, memops, iset);
  nopl = 0;
  for (int o = 1; o < NOPS; o++) if (T.opsok[o]) nops_ok[nopl++] = o;

  Ins st0[MAXL]; int L0 = 0;
  memset(st0, 0, sizeof st0);
  if (start) {
    L0 = read_prog(&T, start, st0);
    if (L0 > L) { fprintf(stderr, "start longer than L\n"); }
  }
  Ins cur[MAXL], prop[MAXL], best[MAXL];
  int bestlen = 1 << 30;
  clock_t c0 = clock();
  long acc = 0, it;
  double cc = 0;
  int restarts = 0;
  for (it = 0; it < iters; it++) {
    if (it == 0 || (prestart > 0 && urand() < prestart)) {
      // (re)start
      memset(cur, 0, sizeof cur);
      if (start) {
        memcpy(cur, st0, sizeof(Ins) * (L0 < L ? L0 : L));
        for (int k = 0; k < del; k++) cur[rnd() % L].op = NOP;
        // shuffle NOP positions randomly by random rotations
      } else
        for (int k = 0; k < L; k++) cur[k] = urand() < 0.7 ? rand_ins() : (Ins){0, 0, 0};
      snap_build(cur, L, 0);
      int w = final_cost(&SN[L]);
      cc = W * w + lam * count_len(cur, L) + (mu > 0 ? mu * depth_of(cur, L) : 0);
      restarts++;
    }
    if ((it & 4095) == 0) {
      double el = (double)(clock() - c0) / CLOCKS_PER_SEC;
      if (el > tlimit) break;
    }
    memcpy(prop, cur, sizeof(Ins) * L);
    int mv = rnd() % 100, a = rnd() % L, b = rnd() % L, lo = a;
    if (mv >= 50 && mv < 72) lo = a < b ? a : b;
    if (mv < 25) {                 // opcode
      if (prop[a].op == NOP) prop[a] = rand_ins();
      else { Ins x = prop[a]; x.op = nops_ok[rnd() % nopl]; if (legal(&T, x)) prop[a] = x; }
    } else if (mv < 50) {          // operand
      if (prop[a].op == NOP) continue;
      Ins x = prop[a];
      if (rnd() & 1) x.d = rnd() % T.nr; else x.s = rnd() % T.nr;
      if (rnd() % 4 == 0) { uint8_t z = x.d; x.d = x.s; x.s = z; }
      if (!legal(&T, x)) continue;
      prop[a] = x;
    } else if (mv < 62) {          // swap
      Ins z = prop[a]; prop[a] = prop[b]; prop[b] = z;
    } else if (mv < 72) {          // move (rotate)
      Ins z = prop[a];
      if (a < b) { memmove(prop + a, prop + a + 1, (b - a) * sizeof(Ins)); prop[b] = z; }
      else if (a > b) { memmove(prop + b + 1, prop + b, (a - b) * sizeof(Ins)); prop[b] = z; }
    } else if (mv < 80) {          // replace whole instruction
      prop[a] = rand_ins();
    } else if (mv < 84) {          // nop toggle
      if (prop[a].op == NOP) prop[a] = rand_ins(); else prop[a].op = NOP;
    } else if (mv < 92) {          // swap register names x<->y in all instructions from a on
      int x = rnd() % T.nr, y = rnd() % T.nr, bad = 0;
      if (x == y) continue;
      for (int k = a; k < L; k++) {
        if (prop[k].d == x) prop[k].d = y; else if (prop[k].d == y) prop[k].d = x;
        if (prop[k].s == x) prop[k].s = y; else if (prop[k].s == y) prop[k].s = x;
        if (!legal(&T, prop[k])) bad = 1;
      }
      if (bad) continue;
    } else {                       // delete 'mov d,s' at a; later reads of d (until d is overwritten) read s
      if (prop[a].op != MOV) continue;
      int d = prop[a].d, sr = prop[a].s, bad = 0;
      prop[a].op = NOP;
      for (int k = a + 1; k < L; k++) {
        Ins x = prop[k];
        if (x.op == NOP) continue;
        if (x.s == d) prop[k].s = sr;
        if (x.op != MOV && x.d == d) prop[k].d = sr;   // cmp/cmov/xchg on d: use s instead
        if (!legal(&T, prop[k])) bad = 1;
        if (x.op == MOV && x.d == d) break;            // d overwritten
        if (x.d == sr && x.op != CMP) break;           // s changed: stop substituting
      }
      if (bad) continue;
    }
    if (maxcmp < 99 || mincmp > 0) { int nc = 0; for (int k = 0; k < L; k++) nc += prop[k].op == CMP; if (nc > maxcmp || nc < mincmp) continue; }
    int w = eval_from(prop, L, lo);
    int len = count_len(prop, L);
    int dep = mu > 0 ? depth_of(prop, L) : 0;
    double pc = W * w + lam * len + mu * dep;
    if (pc <= cc || urand() < exp((cc - pc) / temp)) {
      memcpy(cur, prop, sizeof(Ins) * L); cc = pc; acc++;
      snap_build(cur, L, lo);
      if (w == 0 && collectK && len <= collectK + 3) collect(cur, L, collectK, out);
      if (mu > 0 && w == 0) {   // depth mode: record each new best (len, depth) after DCE
        static int bestdep[MAXL + 1]; static int initd = 0;
        if (!initd) { for (int k = 0; k <= MAXL; k++) bestdep[k] = 1 << 20; initd = 1; }
        Ins q[MAXL]; memcpy(q, cur, sizeof(Ins) * L);
        int l2 = dce(&T, q, L), d2 = depth_of(q, l2);
        if (d2 < bestdep[l2]) {
          bestdep[l2] = d2;
          char fn[512]; sprintf(fn, "%s_len%d_depth%c%d.s", out, l2, latmov ? 'U' : 'E', d2);
          FILE *fo = fopen(fn, "w");
          fprintf(fo, "# n=%d model=%s iset=%s len=%d depth%c=%d source=upper mcmc depth mode\n", n,
                  model == MOD_OUT ? "out" : "other", iset, l2, latmov ? 'U' : 'E', d2);
          print_prog(fo, &T, q, l2); fclose(fo);
          printf("DEPTH len=%d depth=%d file=%s\n", l2, d2, fn); fflush(stdout);
        }
      }
      if (w == 0 && (len < bestlen || report_all)) {
        Ins q[MAXL]; memcpy(q, cur, sizeof(Ins) * L);
        int l2 = dce(&T, q, L);
        if (l2 < bestlen || report_all) {
          int newbest = l2 < bestlen;
          if (newbest) { bestlen = l2; memcpy(best, q, sizeof(Ins) * l2); }
          int outr[5]; wrong(&T, q, l2, outr);
          char fn[512]; sprintf(fn, "%s_len%d_%lx.s", out, l2, (unsigned long)(rnd() & 0xffffff));
          FILE *fo = fopen(fn, "w");
          char bb[8];
          fprintf(fo, "# n=%d model=%s iset=%s memops=%d len=%d source=upper mcmc seed=%lu it=%ld outputs:", n,
                  model == MOD_P ? "P" : model == MOD_FREE ? "free" : model == MOD_OUT ? "out" : "mem", iset, memops, l2, (unsigned long)seed, it);
          for (int j = 0; j < n; j++) { regname(&T, outr[j], bb); fprintf(fo, " %s", bb); }
          fprintf(fo, "\n");
          print_prog(fo, &T, q, l2);
          fclose(fo);
          printf("FOUND len=%d it=%ld file=%s\n", l2, it, fn);
          fflush(stdout);
        }
      }
    }
  }
  double el = (double)(clock() - c0) / CLOCKS_PER_SEC;
  printf("collected=%ld ", ncoll); printf("done it=%ld acc=%ld restarts=%d time=%.1fs rate=%.0f/s best=%d curcost=%.1f\n", it, acc, restarts, el, it / el,
         bestlen == 1 << 30 ? -1 : bestlen, cc);
  return 0;
}
