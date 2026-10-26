// d6-qd: quality-diversity (MAP-Elites) search for sort5 in M_out, fixed L slots (NOP = empty slot).
// Score = sum over outputs j of #weak orders wrong at the best snapshot of j (upper sim.h, strict semantics).
// Cell = (c = #cmp, m = #mov, b = semantic cmp-skeleton hash mod NB). Each iteration: pick an elite, apply a
// large move (block swap / block re-route / segment crossover / burst of small moves), then a short MCMC descent;
// the best point of the descent goes into its cell if better. Any score 0 -> DCE -> FOUND file.
// usage: qd -seeds f.txt [-L 31] [-time s] [-seed x] [-out prefix] [-desc D] [-T temp] [-nb NB] [-dump s]
#include "sim.h"
#include <math.h>
#include <time.h>
#include <unistd.h>

static uint64_t rs;
static inline uint64_t rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
static inline double urand(void) { return (rnd() >> 11) * (1.0 / 9007199254740992.0); }

static Task T;
static int nops_ok[NOPS], nopl, L = 31, NB = 64;
static Ins rand_ins(void) {
  for (;;) {
    Ins in; in.op = nops_ok[rnd() % nopl]; in.d = rnd() % T.nr; in.s = rnd() % T.nr;
    if (legal(&T, in)) return in;
  }
}
static int score(const Ins *p) { return wrong_out(&T, p, L, NULL, NULL); }

static uint64_t vhash(const uint8_t *a, int n) {
  uint64_t h = 1469598103934665603ULL;
  for (int k = 0; k < n; k++) h = (h ^ a[k]) * 1099511628211ULL;
  return h;
}
static int cell_of(const Ins *p) {
  static State st; state_init(&T, &st);
  int c = 0, m = 0; uint64_t sh = 1469598103934665603ULL;
  for (int i = 0; i < L; i++) {
    if (p[i].op == CMP) {
      uint64_t a = vhash(st.r[p[i].d], T.T), b = vhash(st.r[p[i].s], T.T);
      if (a > b) { uint64_t z = a; a = b; b = z; }
      sh = (sh ^ a) * 1099511628211ULL; sh = (sh ^ b) * 1099511628211ULL; c++;
    } else if (p[i].op == MOV) m++;
    exec1(&T, &st, p[i]);
  }
  if (c > 15) c = 15; if (m > 15) m = 15;
  return (c * 16 + m) * NB + (int)(sh % NB);
}

#define MAXC (16 * 16 * 256)
static Ins elite[MAXC][MAXL]; static int escore[MAXC], occ[MAXC], nocc;
static int insert(const Ins *p, int sc) {
  int c = cell_of(p);
  if (escore[c] < 0) { occ[nocc++] = c; escore[c] = sc; memcpy(elite[c], p, sizeof(Ins) * L); return 2; }
  if (sc < escore[c] || (sc == escore[c] && urand() < 0.3)) { escore[c] = sc; memcpy(elite[c], p, sizeof(Ins) * L); return 1; }
  return 0;
}

static void small_move(Ins *prop) {
  int mv = rnd() % 100, a = rnd() % L, b = rnd() % L;
  if (mv < 25) {
    if (prop[a].op == NOP) prop[a] = rand_ins();
    else { Ins x = prop[a]; x.op = nops_ok[rnd() % nopl]; if (legal(&T, x)) prop[a] = x; }
  } else if (mv < 50) {
    if (prop[a].op == NOP) return;
    Ins x = prop[a];
    if (rnd() & 1) x.d = rnd() % T.nr; else x.s = rnd() % T.nr;
    if (rnd() % 4 == 0) { uint8_t z = x.d; x.d = x.s; x.s = z; }
    if (legal(&T, x)) prop[a] = x;
  } else if (mv < 62) {
    Ins z = prop[a]; prop[a] = prop[b]; prop[b] = z;
  } else if (mv < 72) {
    Ins z = prop[a];
    if (a < b) { memmove(prop + a, prop + a + 1, (b - a) * sizeof(Ins)); prop[b] = z; }
    else if (a > b) { memmove(prop + b + 1, prop + b, (a - b) * sizeof(Ins)); prop[b] = z; }
  } else if (mv < 80) {
    prop[a] = rand_ins();
  } else if (mv < 84) {
    if (prop[a].op == NOP) prop[a] = rand_ins(); else prop[a].op = NOP;
  } else if (mv < 92) {
    int x = rnd() % T.nr, y = rnd() % T.nr;
    if (x == y) return;
    for (int k = a; k < L; k++) {
      if (prop[k].d == x) prop[k].d = y; else if (prop[k].d == y) prop[k].d = x;
      if (prop[k].s == x) prop[k].s = y; else if (prop[k].s == y) prop[k].s = x;
    }
  } else {
    if (prop[a].op != MOV) return;
    int d = prop[a].d, sr = prop[a].s;
    prop[a].op = NOP;
    for (int k = a + 1; k < L; k++) {
      Ins x = prop[k];
      if (x.op == NOP) continue;
      if (x.s == d) prop[k].s = sr;
      if (x.op != MOV && x.d == d) prop[k].d = sr;
      if (x.op == MOV && x.d == d) break;
      if (x.d == sr && x.op != CMP) break;
    }
  }
}

// blocks: start indices of cmp blocks (block = cmp .. before next cmp); blk[0] = 0 (header)
static int blocks(const Ins *p, int *st) {
  int nb = 0; st[nb++] = 0;
  for (int i = 0; i < L; i++) if (p[i].op == CMP && i > 0) st[nb++] = i;
  st[nb] = L; return nb;
}
static int large_move(Ins *p) {
  int st[MAXL + 1], nb = blocks(p, st), kind = rnd() % 5;
  if (kind == 0 && nb >= 3) {          // swap two adjacent blocks
    int b = 1 + rnd() % (nb - 2);
    int a0 = st[b], a1 = st[b + 1], b1 = st[b + 2];
    Ins tmp[MAXL]; int k = 0;
    for (int i = a1; i < b1; i++) tmp[k++] = p[i];
    for (int i = a0; i < a1; i++) tmp[k++] = p[i];
    memcpy(p + a0, tmp, k * sizeof(Ins));
  } else if (kind == 1) {              // re-route a block: new operands for all non-cmp instructions
    int b = rnd() % nb;
    for (int i = st[b]; i < st[b + 1]; i++) if (p[i].op != CMP && p[i].op != NOP) {
      Ins x = p[i];
      for (int t = 0; t < 20; t++) { x.d = rnd() % T.nr; x.s = rnd() % T.nr; if (legal(&T, x)) { p[i] = x; break; } }
    }
  } else if (kind == 2) {              // new cmp operands in a block
    int b = 1 + rnd() % (nb > 1 ? nb - 1 : 1);
    if (b < nb && p[st[b]].op == CMP) {
      Ins x = p[st[b]];
      for (int t = 0; t < 20; t++) { x.d = rnd() % T.nr; x.s = rnd() % T.nr; if (legal(&T, x)) { p[st[b]] = x; break; } }
    }
  } else if (kind == 3 && nocc > 1) {  // segment crossover with another elite
    const Ins *q = elite[occ[rnd() % nocc]];
    int a = rnd() % L, len = 2 + rnd() % 8;
    for (int i = a; i < a + len && i < L; i++) p[i] = q[i];
  } else {                             // burst
    int k = 2 + rnd() % 4;
    for (int i = 0; i < k; i++) small_move(p);
  }
  return kind;
}

static void report(const Ins *p, const char *out, long it) {
  Ins q[MAXL]; memcpy(q, p, sizeof(Ins) * L);
  int l2 = dce(&T, q, L);
  char fn[512]; sprintf(fn, "%s_FOUND_len%d_%lx.s", out, l2, (unsigned long)(rnd() & 0xffffff));
  FILE *fo = fopen(fn, "w");
  fprintf(fo, "# n=5 model=out iset=I1 len=%d source=d6-qd qd it=%ld\n", l2, it);
  print_prog(fo, &T, q, l2); fclose(fo);
  printf("FOUND len=%d file=%s\n", l2, fn); fflush(stdout);
}

static void dump(const char *out) {
  char fn[512]; sprintf(fn, "%s_archive.txt", out);
  FILE *fo = fopen(fn, "w");
  for (int i = 0; i < nocc; i++) {
    int c = occ[i];
    fprintf(fo, "# prog cell=%d c=%d m=%d b=%d score=%d slots=%d\n", c, c / NB / 16, (c / NB) % 16, c % NB, escore[c], L);
    print_prog(fo, &T, elite[c], L);
  }
  fclose(fo);
}

int main(int argc, char **argv) {
  const char *seeds = NULL, *out = "qd";
  double tlimit = 60, temp = 2.0, dumpint = 600; int D = 400, nseedmax = 1 << 30;
  uint64_t seed = time(NULL) ^ getpid();
  for (int i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-seeds")) seeds = argv[++i];
    else if (!strcmp(argv[i], "-L")) L = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-time")) tlimit = atof(argv[++i]);
    else if (!strcmp(argv[i], "-seed")) seed = strtoull(argv[++i], 0, 10);
    else if (!strcmp(argv[i], "-out")) out = argv[++i];
    else if (!strcmp(argv[i], "-desc")) D = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-T")) temp = atof(argv[++i]);
    else if (!strcmp(argv[i], "-nb")) NB = atoi(argv[++i]);
    else if (!strcmp(argv[i], "-dump")) dumpint = atof(argv[++i]);
    else if (!strcmp(argv[i], "-nseeds")) nseedmax = atoi(argv[++i]);
  }
  rs = seed * 2654435761ULL + 88172645463325252ULL;
  task_init(&T, 5, 9, MOD_OUT, 0, "I1");
  nopl = 0;
  for (int o = 1; o < NOPS; o++) if (T.opsok[o]) nops_ok[nopl++] = o;
  for (int c = 0; c < MAXC; c++) escore[c] = -1;
  // seeds: k=32 programs; for each, all single deletions -> best one(s) (and all with ties) go to the archive
  FILE *fi = fopen(seeds, "r"); if (!fi) { perror(seeds); return 1; }
  char line[256]; Ins p[MAXL]; int K = 0, ns = 0;
  int map[1024];
  for (int done = 0; !done && ns < nseedmax;) {
    char *g = fgets(line, sizeof line, fi);
    if (!g || !strncmp(line, "# prog", 6)) {
      if (K > 0 && K <= L) {             // seed fits: insert as is
        Ins q[MAXL]; memset(q, 0, sizeof q); memcpy(q, p, K * sizeof(Ins));
        int sc = score(q); if (sc == 0) report(q, out, -1);
        insert(q, sc);
      }
      if (K > 0) {
        for (int del = 0; del < K; del++) {
          Ins q[MAXL]; int l = 0;
          memset(q, 0, sizeof q);
          for (int i = 0; i < K; i++) if (i != del && l < L) q[l++] = p[i];
          int sc = score(q);
          if (sc == 0) report(q, out, -1);
          insert(q, sc);
        }
        ns++;
      }
      if (!g) break;
      K = 0; for (int r = 0; r < 1024; r++) map[r] = -1;
      continue;
    }
    char *h = strchr(line, '#'); if (h) *h = 0;
    char op[32], a[16], b[16];
    if (sscanf(line, " %31s %15[^, ] , %15s", op, a, b) != 3 || !strcmp(op, "out")) continue;
    int o = -1; for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    int rr[2]; char *ab[2] = {a, b};
    for (int k = 0; k < 2; k++) {
      int x = atoi(ab[k] + 1);
      if (ab[k][0] == 'P') rr[k] = x;
      else { if (map[x] < 0) { int mx = 5; for (int y = 0; y < 1024; y++) if (map[y] >= mx) mx = map[y] + 1; map[x] = mx; } rr[k] = map[x]; }
      if (rr[k] >= T.nr) o = -2;
    }
    if (o < 0) { K = -1000; continue; }   // skip programs with too many registers
    if (K >= 0) { p[K].op = o; p[K].d = rr[0]; p[K].s = rr[1]; K++; }
  }
  fclose(fi);
  int bs = 1 << 30; for (int i = 0; i < nocc; i++) if (escore[occ[i]] < bs) bs = escore[occ[i]];
  printf("seeds=%d cells=%d best=%d\n", ns, nocc, bs); fflush(stdout);
  time_t t0 = time(NULL), tlast = t0;
  long it = 0, ev = 0, ins_new = 0, ins_imp = 0; int kindcnt[5] = {0}, kindwin[5] = {0};
  for (;; it++) {
    if ((it & 15) == 0) {
      time_t now = time(NULL);
      if (difftime(now, t0) > tlimit) break;
      if (difftime(now, tlast) > dumpint) {
        tlast = now; dump(out);
        bs = 1 << 30; int hist[8] = {0};
        for (int i = 0; i < nocc; i++) { int s = escore[occ[i]]; if (s < bs) bs = s; hist[s < 7 ? s : 7]++; }
        printf("t=%.0f it=%ld ev=%ld cells=%d best=%d hist0..7+=%d %d %d %d %d %d %d %d new=%ld imp=%ld kinds", difftime(now, t0), it, ev, nocc, bs,
               hist[0], hist[1], hist[2], hist[3], hist[4], hist[5], hist[6], hist[7], ins_new, ins_imp);
        for (int k = 0; k < 5; k++) printf(" %d/%d", kindwin[k], kindcnt[k]);
        printf("\n"); fflush(stdout);
      }
    }
    // parent: tournament of 2 random cells (prefer low score)
    int c1 = occ[rnd() % nocc], c2 = occ[rnd() % nocc];
    int pc = escore[c1] <= escore[c2] ? c1 : c2;
    Ins cur[MAXL]; memcpy(cur, elite[pc], sizeof(Ins) * L);
    int kind = large_move(cur); kindcnt[kind]++;
    int cs = score(cur); ev++;
    Ins best[MAXL]; memcpy(best, cur, sizeof(Ins) * L); int bsc = cs;
    for (int d = 0; d < D && bsc > 0; d++) {
      Ins prop[MAXL]; memcpy(prop, cur, sizeof(Ins) * L);
      small_move(prop);
      int ps = score(prop); ev++;
      if (ps <= cs || urand() < exp((cs - ps) / temp)) {
        memcpy(cur, prop, sizeof(Ins) * L); cs = ps;
        if (cs < bsc) { bsc = cs; memcpy(best, cur, sizeof(Ins) * L); }
      }
    }
    if (bsc == 0) report(best, out, it);
    int r = insert(best, bsc);
    if (r == 2) ins_new++; else if (r == 1) ins_imp++;
    if (r) kindwin[kind]++;
  }
  dump(out);
  printf("done it=%ld ev=%ld cells=%d\n", it, ev, nocc);
  return 0;
}
