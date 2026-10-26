/* x86 agent: real-CPU differential test driver.
 * Build: see run_harness.sh. Program table comes from gen_harness.py (PROGS_H).
 *
 * For each program and each test state it:
 *   1. runs the real x86 code (reg mode and spill mode),
 *   2. runs an independent C simulator of MODEL.md section 1 (plus the x86 facts:
 *      32-bit writes zero-extend; a false cmov also zero-extends; cmp sets ZF/SF/OF/CF),
 *   3. compares ALL registers (64 bit) and the arithmetic flags  -> "semantic mismatches",
 *   4. checks P0..P{n-1} (low 32 bits) == sorted inputs         -> "sort failures".
 * Test sets: every weak order type x many value choices, and random inputs.
 * Scratch registers, the upper 32 bits of every register, and the flags get garbage.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <limits.h>
#include PROGS_H

#define FLMASK 0x8D5ull /* CF PF AF ZF SF OF */
#define MAXR 160
#define STSZ (2 * MAXR + 2 + 16)

static uint64_t s[4];
static inline uint64_t rotl(uint64_t x, int k) { return (x << k) | (x >> (64 - k)); }
static uint64_t rnd(void) { /* xoshiro256** */
  uint64_t r = rotl(s[1] * 5, 7) * 9, t = s[1] << 17;
  s[2] ^= s[0]; s[3] ^= s[1]; s[1] ^= s[2]; s[0] ^= s[3]; s[2] ^= t; s[3] = rotl(s[3], 45);
  return r;
}
static void seed(uint64_t x) {
  for (int i = 0; i < 4; i++) { x += 0x9E3779B97F4A7C15ull; uint64_t z = x;
    z = (z ^ (z >> 30)) * 0xBF58476D1CE4E5B9ull; z = (z ^ (z >> 27)) * 0x94D049BB133111EBull; s[i] = z ^ (z >> 31); }
}

static const int32_t EXT[] = {INT_MIN, INT_MIN + 1, -2, -1, 0, 1, 2, INT_MAX - 1, INT_MAX};
#define NEXT (int)(sizeof EXT / sizeof EXT[0])

static int32_t rand_val(int style) {
  switch (style) {
  case 0: return (int32_t)rnd();
  case 1: return EXT[rnd() % NEXT];
  case 2: return (int32_t)(rnd() % 5) - 2;               /* many duplicates */
  default: return (rnd() & 1) ? EXT[rnd() % NEXT] : (int32_t)rnd();
  }
}

/* garbage for a scratch register / upper half */
static uint64_t garbage(int style, const int32_t *x, int n) {
  switch (style) {
  case 0: return rnd();
  case 1: return (rnd() & 0xFFFFFFFF00000000ull) | (uint32_t)INT_MAX;
  case 2: return (rnd() & 0xFFFFFFFF00000000ull) | (uint32_t)INT_MIN;
  case 3: return (rnd() & 0xFFFFFFFF00000000ull) | (uint32_t)x[rnd() % n];
  case 4: return 0;
  default: return (rnd() & 0xFFFFFFFF00000000ull) | (uint32_t)EXT[rnd() % NEXT];
  }
}

static uint64_t base_flags;
static FILE *dumpf;          /* env DUMP=file: write the first DUMPK (in, hw out) vectors per program */
static long dumpk, dumped;

/* independent simulator: returns final regs + flags in st (same layout as real code) */
static void simulate(const prog_t *p, uint64_t *st) {
  int R = p->R;
  uint64_t r[MAXR];
  memcpy(r, st, 8 * R);
  uint64_t fl = st[R];
  int lt = (((fl >> 7) & 1) != ((fl >> 11) & 1));            /* SF != OF */
  int gt = !((fl >> 6) & 1) && !lt;                          /* ZF = 0 and SF = OF */
  for (int i = 0; i < p->len; i++) {
    int op = p->code[i][0], d = p->code[i][1], sr = p->code[i][2];
    int32_t A = (int32_t)r[d], B = (int32_t)r[sr];
    switch (op) {
    case 0: r[d] = (uint32_t)r[sr]; break;
    case 6: st[2 * R + 2 + d] = (uint32_t)r[sr]; break;   /* out d, S: 32-bit store, flags kept */
    case 1: {
      lt = A < B; gt = A > B;
      uint32_t diff = (uint32_t)A - (uint32_t)B;
      int of = ((A < 0) != (B < 0)) && (((int32_t)diff < 0) != (A < 0));
      int cf = (uint32_t)A < (uint32_t)B;
      int pf = !__builtin_parity(diff & 0xFF);
      int af = ((uint32_t)A ^ (uint32_t)B ^ diff) >> 4 & 1;
      fl = (fl & ~FLMASK) | cf | (pf << 2) | (af << 4) | ((diff == 0) << 6) | ((diff >> 31) << 7) | ((uint64_t)of << 11);
      break; }
    default: {
#ifdef SIMBUG   /* negative control: wrong cmovle (as cmovl) */
      int c = op == 2 ? lt : op == 3 ? gt : op == 4 ? lt : !lt;
#else
      int c = op == 2 ? lt : op == 3 ? gt : op == 4 ? !gt : !lt;
#endif
      r[d] = c ? (uint32_t)r[sr] : (uint32_t)r[d];   /* zero-extends even when false */
    }}
  }
  memcpy(st + R + 1, r, 8 * R);
  st[2 * R + 1] = fl;
}

static int cmp32(const void *a, const void *b) {
  int32_t x = *(const int32_t *)a, y = *(const int32_t *)b; return (x > y) - (x < y);
}

typedef struct { long runs, semfail, sortfail, relaxed_runs, relaxed_fail; } stat_t;

static void one(const prog_t *p, const int32_t *x, int gstyle, int relaxed, stat_t *S, int verbose) {
  uint64_t st[STSZ], sim[STSZ];
  int n = p->n, R = p->R;
  memset(st, 0, sizeof st);
  for (int i = 0; i < n; i++) st[i] = (rnd() & 0xFFFFFFFF00000000ull) | (uint32_t)x[i];
  for (int i = n; i < R; i++) st[i] = relaxed ? (uint32_t)INT_MAX : garbage(gstyle, x, n);
  /* relaxed: ZF=1, SF=OF=0 -> lt = gt = false (eq) */
  st[R] = (base_flags & ~FLMASK) | (relaxed ? 0x40 : (rnd() & FLMASK));
  for (int j = 0; j < n; j++) st[2 * R + 2 + j] = ~0ull;   /* output slots: not written */
  memcpy(sim, st, sizeof st);
  p->fn(st);
  if (dumpf && dumped < dumpk && rnd() % 32 == 0) {
    dumped++;
    fprintf(dumpf, "V");
    for (int i = 0; i <= R; i++) fprintf(dumpf, " %llx", (unsigned long long)sim[i]);
    fprintf(dumpf, " |");
    for (int i = R + 1; i < 2 * R + 2 + n; i++) fprintf(dumpf, " %llx", (unsigned long long)st[i]);
    fprintf(dumpf, "\n");
  }
  simulate(p, sim);
  int bad = 0;
  /* mem mode: P cells are dwords in 8-byte slots; a 32-bit store keeps the slot's high half -> compare low 32 */
  int memP = p->mode[0] == 'm';
  for (int i = 0; i < R; i++)
    if (memP && i < n ? (uint32_t)st[R + 1 + i] != (uint32_t)sim[R + 1 + i] : st[R + 1 + i] != sim[R + 1 + i]) bad = 1;
  if ((st[2 * R + 1] ^ sim[2 * R + 1]) & FLMASK) bad = 1;
  for (int j = 0; j < n; j++) if (st[2 * R + 2 + j] != sim[2 * R + 2 + j]) bad = 1;
  S->runs++;
  if (bad) {
    if (S->semfail++ < 3 && verbose) {
      fprintf(stderr, "  SEM MISMATCH %s/%s:", p->file, p->mode);
      for (int i = 0; i < R; i++) fprintf(stderr, " r%d in=%016llx hw=%016llx sim=%016llx\n", i,
          (unsigned long long)sim[i], (unsigned long long)st[R + 1 + i], (unsigned long long)sim[R + 1 + i]);
      fprintf(stderr, " fl hw=%llx sim=%llx\n", (unsigned long long)st[2 * R + 1], (unsigned long long)sim[2 * R + 1]);
    }
  }
  int32_t want[16];
  memcpy(want, x, 4 * n);
  qsort(want, n, 4, cmp32);
  int sbad = 0;
  int32_t got[16];
  for (int j = 0; j < n; j++) {   /* output j = last 'out j' (model=out), else final Pj */
    uint64_t o = st[2 * R + 2 + j];
    got[j] = (o >> 32) == 0 ? (int32_t)o : (int32_t)st[R + 1 + j];
    if (got[j] != want[j]) sbad = 1;
  }
  if (relaxed) { S->relaxed_runs++; S->relaxed_fail += sbad; }
  else if (sbad) {
    if (S->sortfail++ < 2 && verbose) {
      fprintf(stderr, "  SORT FAIL %s/%s in:", p->file, p->mode);
      for (int j = 0; j < n; j++) fprintf(stderr, " %d", x[j]);
      fprintf(stderr, " garbage:");
      for (int j = n; j < R; j++) fprintf(stderr, " %llx", (unsigned long long)st[j]);
      fprintf(stderr, " flags=%llx out:", (unsigned long long)st[R]);
      for (int j = 0; j < n; j++) fprintf(stderr, " %d", got[j]);
      fprintf(stderr, "\n");
    }
  }
}

/* all weak order types of n items: rank vectors with image {0..m-1} */
static int next_rank(int *rk, int n) {
  for (;;) {
    int i = 0;
    while (i < n && rk[i] == n - 1) rk[i++] = 0;
    if (i == n) return 0;
    rk[i]++;
    int seen[16] = {0}, m = 0;
    for (int j = 0; j < n; j++) seen[rk[j]] = 1;
    while (m < n && seen[m]) m++;
    int ok = 1;
    for (int j = m; j < n; j++) if (seen[j]) ok = 0;
    if (ok) return 1;
  }
}

int main(int argc, char **argv) {
  long per_type = argc > 1 ? atol(argv[1]) : 2000;
  long nrand = argc > 2 ? atol(argv[2]) : 1000000;
  seed(argc > 3 ? atol(argv[3]) : 12345);
  int verbose = 1;
  __asm__ volatile("pushfq; pop %0" : "=r"(base_flags));
  if (getenv("DUMP")) { dumpf = fopen(getenv("DUMP"), "w"); dumpk = getenv("DUMPK") ? atol(getenv("DUMPK")) : 300; }
  int total_bad = 0;
  for (int k = 0; k < NPROGS; k++) {
    const prog_t *p = &PROGS[k];
    if (p->R > MAXR || p->n > 16) { fprintf(stderr, "%s: R or n too large\n", p->file); return 3; }
    stat_t S = {0};
    dumped = 0;
    if (dumpf) {
      fprintf(dumpf, "PROG %s %s %d %d", p->file, p->mode, p->n, p->R);
      for (int i = 0; i < p->len; i++) fprintf(dumpf, " %d.%d.%d", p->code[i][0], p->code[i][1], p->code[i][2]);
      fprintf(dumpf, "\n");
    }
    int n = p->n, rk[16] = {0}, types = 0;
    long relaxed_types_fail = 0;
    /* weak order types (rk = all zeros is the first type) */
    do {
      types++;
      int m = 0;
      for (int j = 0; j < n; j++) if (rk[j] + 1 > m) m = rk[j] + 1;
      long tf0 = S.relaxed_fail;
      for (long t = 0; t < per_type; t++) {
        int32_t v[16], x[16];
        /* m distinct sorted values */
        for (;;) {
          int style = t % 4;
          for (int j = 0; j < m; j++) v[j] = rand_val(style == 2 ? 1 : style);
          qsort(v, m, 4, cmp32);
          int ok = 1;
          for (int j = 1; j < m; j++) if (v[j] == v[j - 1]) ok = 0;
          if (ok) break;
        }
        for (int j = 0; j < n; j++) x[j] = v[rk[j]];
        one(p, x, t % 6, 0, &S, verbose);
        /* relaxed model of MODEL.md section 2: scratch = INT_MAX, flags = eq, inputs < INT_MAX */
        if (t < 8) {
          int ok = 1;
          for (int j = 0; j < n; j++) if (x[j] == INT_MAX) ok = 0;
          if (ok) one(p, x, 0, 1, &S, verbose);
        }
      }
      if (S.relaxed_fail > tf0) relaxed_types_fail++;
    } while (next_rank(rk, n));
    for (long t = 0; t < nrand; t++) {
      int32_t x[16];
      int style = rnd() % 4;
      for (int j = 0; j < n; j++) x[j] = rand_val(style);
      one(p, x, rnd() % 6, 0, &S, verbose);
    }
    printf("%-60s %-5s n=%d R=%-2d len=%-2d L=%-2d types=%d runs=%ld sem_mismatch=%ld sort_fail=%ld relaxed_runs=%ld relaxed_fail=%ld relaxed_fail_types=%ld => %s\n",
           p->file, p->mode, n, p->R, p->len, p->L, types, S.runs, S.semfail, S.sortfail, S.relaxed_runs, S.relaxed_fail,
           relaxed_types_fail, S.semfail ? "SEMANTICS-MISMATCH" : S.sortfail ? "NOT-A-SORT(strict)" : "SORTS(strict)");
    if (S.semfail) total_bad++;
  }
  return total_bad ? 2 : 0;
}
