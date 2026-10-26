// d5-extend reverse view: for each sort5 program and each dropped input m, find a short subsequence that is a
// strict-correct sort4 (M_out, I1) of the other 4 inputs, P_m treated as garbage. Randomised greedy deletion.
#include "../../upper/src/sim.h"
static Task t4;
static int prog_from_lines(char lines[][64], int nl, int m, Ins *p) {
  // map P_m -> extra scratch register, others -> P0..P3 in order
  int L = 0; nsmap = 0;
  for (int i = 0; i < nl; i++) {
    char op[32], a[16], b[16];
    if (sscanf(lines[i], " %31s %15[^, ] , %15s", op, a, b) != 3) continue;
    if (!strcmp(op, "out")) continue;
    int o = -1; for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    int r[2]; char *x[2] = {a, b};
    for (int w = 0; w < 2; w++) {
      if (x[w][0] == 'P') { int v = atoi(x[w] + 1); if (v == m) { char q[16]; sprintf(q, "S%d", 900); r[w] = parse_reg(&t4, q); } else r[w] = v < m ? v : v - 1; }
      else r[w] = parse_reg(&t4, x[w]);
    }
    p[L].op = o; p[L].d = r[0]; p[L].s = r[1]; L++;
  }
  return L;
}
static unsigned long long rs = 88172645463325252ULL;
static unsigned rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return (unsigned)rs; }
static int rdce(Ins *p, int L) {
  for (int changed = 1; changed;) {
    changed = 0;
    int ord[MAXL]; for (int i = 0; i < L; i++) ord[i] = i;
    for (int i = L - 1; i > 0; i--) { int j = rnd() % (i + 1); int z = ord[i]; ord[i] = ord[j]; ord[j] = z; }
    for (int k = 0; k < L; k++) {
      int i = ord[k]; Ins q[MAXL]; int c = 0;
      for (int j = 0; j < L; j++) if (j != i) q[c++] = p[j];
      if (wrong(&t4, q, c, NULL) == 0) { memcpy(p, q, c * sizeof(Ins)); L = c; changed = 1; break; }
    }
  }
  return L;
}
int main(int argc, char **argv) {
  int tries = argc > 1 ? atoi(argv[1]) : 20;
  task_init(&t4, 4, 20, MOD_OUT, 0, "I1");
  char lines[MAXL][64]; int nl = 0, idx = 0; char buf[256];
  int hist[6][MAXL] = {{0}};
  for (int more = 1; more;) {
    more = fgets(buf, sizeof buf, stdin) != NULL;
    if (!more || buf[0] == '#') {
      if (nl) {
        int bestall = 99; printf("%d", idx);
        for (int m = 0; m < 5; m++) {
          Ins p0[MAXL]; int L0 = prog_from_lines(lines, nl, m, p0);
          int best = 99; Ins bp[MAXL];
          if (wrong(&t4, p0, L0, NULL) == 0)
            for (int r = 0; r < tries; r++) { Ins p[MAXL]; memcpy(p, p0, sizeof p0); int L = rdce(p, L0); if (L < best) { best = L; memcpy(bp, p, sizeof bp); } if (best == 20) break; }
          printf(" %d", best == 99 ? -1 : best); if (best < bestall) bestall = best;
        }
        printf("\n"); idx++; nl = 0;
      }
      continue;
    }
    strncpy(lines[nl++], buf, 63);
  }
  return 0;
}
