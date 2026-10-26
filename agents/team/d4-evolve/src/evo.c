// d4-evolve: MAP-Elites evolution of sort5 programs at fixed length K (M_out, I1, strict 3-valued sim from upper/sim.h).
// fitness = (fail_weak, sum of output mismatches), lower is better. cells = (c, v) x cut-signature bucket.
// operators: point, operand, cond flip, swap, move, del+ins, block move, block replace (compare-exchange), suffix rename,
// crossover (prefix A + suffix B), followed by optional greedy 1-step descent.
// usage: evo -K 31 -S 10 -seeds FILE[,FILE] -time SEC -seed N -out PREFIX [-id i -peers n]
#include "sim.h"
#include <time.h>
#include <unistd.h>

static uint64_t rs;
static inline uint64_t rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static Task T;
static int K = 31;
static const int OPS[6] = {MOV, CMP, CMOVL, CMOVG, CMOVLE, CMOVGE};

typedef struct { Ins p[MAXL]; int fw, sum, c, m, v; uint64_t sig; } Ind;

// evaluate: per output j choose snapshot with fewest mismatches; fw = #cases where some chosen snapshot is wrong
static void eval(Ind *x) {
  static State st; static uint8_t snap[5][MAXT];
  int best[5];
  for (int j = 0; j < 5; j++) { best[j] = 1 << 20; memset(snap[j], UNK, T.TP); }
  state_init(&T, &st);
  int c = 0, m = 0, v = 0;
  for (int i = 0; i < K; i++) {
    Ins in = x->p[i];
    if (in.op == NOP) continue;
    exec1(&T, &st, in);
    if (in.op == CMP) { c++; continue; }
    if (in.op == MOV) v++; else m++;
    const uint8_t *a = st.r[in.d];
    for (int j = 0; j < 5; j++) {
      const uint8_t *e = T.expv[j]; int cc = 0;
      for (int k = 0; k < T.T; k++) cc += (a[k] != e[k]);
      if (cc < best[j]) { best[j] = cc; memcpy(snap[j], a, T.TP); }
    }
  }
  // also allow final P_j (no out) -- P_j registers are written by instructions, covered above; initial P_j only if never best
  int fw = 0, sum = 0; uint64_t sig = 0;
  for (int k = 0; k < T.T; k++) {
    int bad = 0;
    for (int j = 0; j < 5; j++) if (snap[j][k] != T.expv[j][k]) bad |= 1 << j;
    if (bad) { fw++; sig = sig * 31 + k * 7 + bad; }
  }
  for (int j = 0; j < 5; j++) sum += best[j];
  x->fw = fw; x->sum = sum; x->c = c; x->m = m; x->v = v; x->sig = sig;
}

static inline int better(const Ind *a, const Ind *b) { return a->fw < b->fw || (a->fw == b->fw && a->sum < b->sum); }

// ---- archive: cell (c 5..12, v 0..15) x NB sig buckets, each NPC individuals
#define NC 8
#define NV 16
#define NB 16
#define NPC 8
static Ind *A; static int occ[NC][NV][NB];
static inline Ind *slot(int c, int v, int b, int i) { return &A[(((c * NV) + v) * NB + b) * NPC + i]; }
static long ninsert; static int evalonly, macro, xo;
static int insert(const Ind *x) {
  int c = x->c - 5, v = x->v; if (c < 0 || c >= NC || v >= NV) return 0;
  int b = x->sig % NB;
  int n = occ[c][v][b];
  for (int i = 0; i < n; i++) { Ind *y = slot(c, v, b, i); if (y->sig == x->sig && y->sum == x->sum && !memcmp(y->p, x->p, K * sizeof(Ins))) return 0; }
  if (n < NPC) { *slot(c, v, b, n) = *x; occ[c][v][b]++; ninsert++; return 1; }
  int w = 0; for (int i = 1; i < n; i++) if (better(slot(c, v, b, w), slot(c, v, b, i))) w = i;
  if (better(x, slot(c, v, b, w)) || (x->fw == slot(c, v, b, w)->fw && x->sum == slot(c, v, b, w)->sum && rnd() % 4 == 0)) {
    *slot(c, v, b, w) = *x; ninsert++; return 1;
  }
  return 0;
}
static Ind *pick(void) {
  // tournament over random occupied slots, biased to low fw
  Ind *best = NULL;
  for (int t = 0; t < 3; t++) {
    for (int tries = 0; tries < 1000; tries++) {
      int c = rnd() % NC, v = rnd() % NV, b = rnd() % NB;
      if (!occ[c][v][b]) continue;
      Ind *y = slot(c, v, b, rnd() % occ[c][v][b]);
      if (!best || (rnd() % 2 ? better(y, best) : 0)) best = y;
      break;
    }
  }
  return best;
}

// ---- mutation
static int regs_used(const Ind *x, int *rl) {
  int seen[MAXR] = {0}, n = 0;
  for (int r = 0; r < 5; r++) seen[r] = 1, rl[n++] = r;
  for (int i = 0; i < K; i++) if (x->p[i].op) {
    if (!seen[x->p[i].d]) seen[x->p[i].d] = 1, rl[n++] = x->p[i].d;
    if (!seen[x->p[i].s]) seen[x->p[i].s] = 1, rl[n++] = x->p[i].s;
  }
  for (int r = 5; r < T.nr; r++) if (!seen[r]) { rl[n++] = r; break; }  // one fresh register
  return n;
}
static Ins rins(const int *rl, int nrl) {
  Ins in; in.op = OPS[rnd() % 6];
  do { in.d = rl[rnd() % nrl]; in.s = rl[rnd() % nrl]; } while (in.d == in.s);
  return in;
}
static void mutate(Ind *x, const Ind *mate) {
  int rl[MAXR], nrl = regs_used(x, rl);
  int op = (xo && rnd() % 2) ? 9 : rnd() % (macro ? 14 : 12), i = rnd() % K, j = rnd() % K;
  Ins *p = x->p;
  switch (op) {
    case 0: p[i] = rins(rl, nrl); break;
    case 1: if (p[i].op) { if (rnd() & 1) p[i].d = rl[rnd() % nrl]; else p[i].s = rl[rnd() % nrl]; if (p[i].d == p[i].s) p[i] = rins(rl, nrl); } break;
    case 2: if (p[i].op >= CMOVL) p[i].op = CMOVL + rnd() % 4; else if (p[i].op == CMP) { uint8_t z = p[i].d; p[i].d = p[i].s; p[i].s = z; } break;
    case 3: if (i + 1 < K) { Ins z = p[i]; p[i] = p[i + 1]; p[i + 1] = z; } break;
    case 4: { Ins z = p[i]; if (i < j) { memmove(p + i, p + i + 1, (j - i) * sizeof(Ins)); } else { memmove(p + j + 1, p + j, (i - j) * sizeof(Ins)); } p[j] = z; } break;
    case 5: { // delete i, insert random at j
      memmove(p + i, p + i + 1, (K - 1 - i) * sizeof(Ins)); p[K - 1].op = NOP;
      memmove(p + j + 1, p + j, (K - 1 - j) * sizeof(Ins)); p[j] = rins(rl, nrl); } break;
    case 6: { // move block [i, i+len) to j
      int len = 2 + rnd() % 4; if (i + len > K) break;
      Ins b[8], q[MAXL]; memcpy(b, p + i, len * sizeof(Ins)); int n = 0;
      for (int t = 0; t < K; t++) if (t < i || t >= i + len) q[n++] = p[t];
      int at = rnd() % (n + 1); memmove(q + at + len, q + at, (n - at) * sizeof(Ins)); memcpy(q + at, b, len * sizeof(Ins));
      memcpy(p, q, K * sizeof(Ins)); } break;
    case 7: { // replace 4 instructions at i with compare-exchange (a,b) via temp t: cmp a,b; mov t,a; cmovg t,b? ; cmovg b,a
      if (i + 4 > K) break;
      int a = rl[rnd() % nrl], b; do b = rl[rnd() % nrl]; while (b == a);
      int t = rl[nrl - 1];
      p[i] = (Ins){CMP, a, b}; p[i + 1] = (Ins){MOV, t, a}; p[i + 2] = (Ins){CMOVG, a, b}; p[i + 3] = (Ins){CMOVG, b, t}; } break;
    case 8: { // rename registers a<->b from position i on
      int a = rl[rnd() % nrl], b = rl[rnd() % nrl]; if (a == b) break;
      for (int t = i; t < K; t++) { if (p[t].d == a) p[t].d = b; else if (p[t].d == b) p[t].d = a; if (p[t].s == a) p[t].s = b; else if (p[t].s == b) p[t].s = a; }
    } break;
    case 9: case 10: if (mate) { // crossover: prefix x[0:i) + mate[j:..)
      Ins q[MAXL]; int n = 0;
      for (int t = 0; t < i; t++) q[n++] = p[t];
      for (int t = j; t < K && n < K; t++) q[n++] = mate->p[t];
      while (n < K) q[n++] = (Ins){NOP, 0, 0};
      memcpy(p, q, K * sizeof(Ins)); } break;
    case 11: p[i].op = NOP; break;
    case 12: case 13: { // pair-swap macro: on one flag swap (a,b) and (a2,b2); op 13 = cheap variant without 2nd temp
      int L = op == 12 ? 7 : 6; if (i + L > K) break;
      int a = rl[rnd() % nrl], b, a2, b2; do b = rl[rnd() % nrl]; while (b == a);
      do a2 = rl[rnd() % nrl]; while (a2 == a || a2 == b); do b2 = rl[rnd() % nrl]; while (b2 == a || b2 == b || b2 == a2);
      int t = rl[nrl - 1]; uint8_t cg = CMOVL + rnd() % 4;
      p[i] = (Ins){CMP, a, b}; p[i + 1] = (Ins){MOV, t, a}; p[i + 2] = (Ins){cg, a, b}; p[i + 3] = (Ins){cg, b, t};
      if (op == 12) { int t2 = a; p[i + 4] = (Ins){MOV, t, a2}; p[i + 5] = (Ins){cg, a2, b2}; p[i + 6] = (Ins){cg, b2, t}; (void)t2; }
      else { p[i + 4] = (Ins){cg, a2, b2}; p[i + 5] = (Ins){cg, b2, a2}; }
    } break;
  }
  for (int t = 0; t < K; t++) if (p[t].op && p[t].d == p[t].s) p[t].op = NOP;
}

// greedy descent: try all single-instruction replacements at random positions (budget), accept improvements
static void descend(Ind *x, int budget) {
  int rl[MAXR], nrl = regs_used(x, rl);
  for (int it = 0; it < budget; it++) {
    Ind y = *x; int i = rnd() % K; y.p[i] = rins(rl, nrl); eval(&y);
    if (better(&y, x)) *x = y;
  }
}

static void print_ind(FILE *fo, const Ind *x) {
  Task *t = &T; Ins q[MAXL]; int L = 0;
  for (int i = 0; i < K; i++) if (x->p[i].op) q[L++] = x->p[i];
  fprintf(fo, "# prog k=%d c=%d m=%d v=%d fail_weak=%d sum=%d\n", L, x->c, x->m, x->v, x->fw, x->sum);
  print_prog(fo, t, q, L);
}
static void dump(const char *fn) {
  FILE *fo = fopen(fn, "w");
  for (int c = 0; c < NC; c++) for (int v = 0; v < NV; v++) for (int b = 0; b < NB; b++)
    for (int i = 0; i < occ[c][v][b]; i++) print_ind(fo, slot(c, v, b, i));
  fclose(fo);
}
static int load(const char *fn, int maxp) {  // file with '# prog' separated programs
  FILE *fi = fopen(fn, "r"); if (!fi) return 0;
  char line[256]; Ind x; int L = 0, np = 0; nsmap = 0; memset(&x, 0, sizeof x);
  for (;;) {
    char *r = fgets(line, sizeof line, fi);
    if (!r || !strncmp(line, "# prog", 6)) {
      if (L) {
        for (int i = L; i < K; i++) x.p[i].op = NOP;
        if (L == K + 1) { // one too long: insert every deletion (archive keeps the best per cell)
          Ind y;
          for (int d = 0; d < L; d++) {
            y = x; memmove(y.p + d, y.p + d + 1, (L - 1 - d) * sizeof(Ins)); y.p[K].op = NOP;
            eval(&y); insert(&y);
          }
          np++; if (np >= maxp) break;
          L = 0; nsmap = 0; memset(&x, 0, sizeof x); if (!r) break; continue;
        }
        while (L > K) { int i = rnd() % L; memmove(x.p + i, x.p + i + 1, (L - 1 - i) * sizeof(Ins)); L--; }
        eval(&x); if (evalonly) printf("prog %d: k=%d c=%d m=%d v=%d fail_weak=%d sum=%d\n", np, x.c + x.m + x.v, x.c, x.m, x.v, x.fw, x.sum); else insert(&x); np++;
        if (np >= maxp) break;
      }
      if (!r) break;
      L = 0; nsmap = 0; memset(&x, 0, sizeof x); continue;
    }
    char *h = strchr(line, '#'); if (h) *h = 0;
    char op[32], a[16], b[16];
    if (sscanf(line, " %31s %15[^, ] , %15s", op, a, b) != 3) continue;
    if (!strcmp(op, "out")) continue;
    int o = -1; for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    if (o < 0 || L >= MAXL) continue;
    x.p[L].op = o; x.p[L].d = parse_reg(&T, a); x.p[L].s = parse_reg(&T, b); L++;
  }
  fclose(fi); return np;
}

int main(int argc, char **argv) {
  int ns = 10, id = 0, peers = 1, maxp = 1 << 30, desc = 30; double tlimit = 60;
  const char *seeds = NULL, *out = "evo"; uint64_t seed = time(NULL) ^ getpid();
  for (int i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-K")) K = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-S")) ns = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-seeds")) seeds = argv[++i];
    else if (!strcmp(argv[i], "-maxp")) maxp = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-time")) tlimit = atof(argv[++i]);
    else if (!strcmp(argv[i], "-seed")) seed = strtoull(argv[++i], 0, 10);
    else if (!strcmp(argv[i], "-out")) out = argv[++i];
    else if (!strcmp(argv[i], "-id")) id = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-peers")) peers = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-desc")) desc = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-eval")) evalonly = 1;
    else if (!strcmp(argv[i], "-macro")) macro = 1;
    else if (!strcmp(argv[i], "-xo")) xo = 1;
  }
  rs = seed * 2654435761ULL + 88172645463325252ULL;
  task_init(&T, 5, ns, MOD_OUT, 0, "I1");
  A = calloc((size_t)NC * NV * NB * NPC, sizeof(Ind));
  char buf[4096]; strncpy(buf, seeds ? seeds : "", sizeof buf - 1);
  for (char *f = strtok(buf, ","); f; f = strtok(NULL, ",")) fprintf(stderr, "seeds %s: %d\n", f, load(f, maxp));
  if (evalonly) return 0;
  time_t t0 = time(NULL), tdump = t0; long it = 0; int bestfw = 1 << 20;
  char fn[512];
  while (difftime(time(NULL), t0) < tlimit) {
    for (int rep = 0; rep < 1000; rep++, it++) {
      Ind *a = pick(); if (!a) { fprintf(stderr, "empty archive\n"); return 1; }
      Ind *b = pick();
      Ind y = *a; int nm = 1 + (rnd() % 3 == 0) + (rnd() % 6 == 0);
      for (int q = 0; q < nm; q++) mutate(&y, b);
      eval(&y);
      if (desc && y.fw < a->fw + 40) descend(&y, desc);
      insert(&y);
      if (y.fw < bestfw) {
        bestfw = y.fw;
        fprintf(stderr, "[%ld s] it=%ld best fw=%d sum=%d c=%d m=%d v=%d\n", (long)difftime(time(NULL), t0), it, y.fw, y.sum, y.c, y.m, y.v);
        sprintf(fn, "%s_best.txt", out); FILE *fo = fopen(fn, "a"); print_ind(fo, &y); fclose(fo);
      }
      if (y.fw == 0) { sprintf(fn, "%s_PASS.txt", out); FILE *fo = fopen(fn, "a"); print_ind(fo, &y); fclose(fo); }
    }
    if (difftime(time(NULL), tdump) > 120) {
      tdump = time(NULL);
      sprintf(fn, "%s_arch%d.txt", out, id); dump(fn);
      if (peers > 1) { int o = rnd() % peers; if (o != id) { sprintf(fn, "%s_arch%d.txt", out, o); load(fn, 200); } }
      long nocc = 0; for (int c = 0; c < NC; c++) for (int v = 0; v < NV; v++) for (int b = 0; b < NB; b++) nocc += occ[c][v][b];
      fprintf(stderr, "[%ld s] it=%ld occ=%ld ins=%ld bestfw=%d\n", (long)difftime(time(NULL), t0), it, nocc, ninsert, bestfw);
    }
  }
  sprintf(fn, "%s_arch%d.txt", out, id); dump(fn);
  return 0;
}
