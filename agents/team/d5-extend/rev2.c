// d5-extend reverse view: for each sort5 program, each input m and x_m = +inf / -inf: simulate, fold constant
// flags (cmov always -> mov, never -> deleted, cmp with constant flags -> deleted), map P_m to garbage, then greedy
// randomised DCE as a strict sort4 (M_out, I1). Prints L4 per (m, sign); -1 = folded program is not a sort4.
#include "../../upper/src/sim.h"
static Task t4, t5;
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
  int tries = argc > 1 ? atoi(argv[1]) : 10;
  task_init(&t4, 4, 24, MOD_OUT, 0, "I1");
  task_init(&t5, 5, 24, MOD_OUT, 0, "I1");  // only for parsing register names
  // template task for folding: n=4 tests, 5 input registers; built per (m, sign)
  static uint8_t vals[100][5]; int T4 = gen_weak(4, vals);
  char buf[256]; Ins p5[MAXL]; int L5 = 0, idx = 0;
  int cnt[100] = {0};
  for (int more = 1; more;) {
    more = fgets(buf, sizeof buf, stdin) != NULL;
    if (!more || buf[0] == '#') {
      if (L5) {
        int bestall = 99; printf("%d", idx);
        for (int m = 0; m < 5; m++) for (int sg = 0; sg < 2; sg++) {
          // simulate p5 on 4-input tests with x_m = extreme; register file of t5 indices
          State st; memset(&st, 0, sizeof st);
          for (int r = 0; r < t5.nr; r++) memset(st.r[r], UNK, MAXT);
          for (int k = 0; k < t4.TP; k++) {
            int kk = k < T4 ? k : 0, c = 0;
            for (int i = 0; i < 5; i++) st.r[i][k] = (i == m) ? (sg ? 10 : 0) : vals[kk][c++] + 1;
          }
          memset(st.f, 3, MAXT);
          Ins q[MAXL]; int L = 0, ok = 1;
          int fconst = -1;  // constant flag value of the last cmp, or -1
          for (int i = 0; i < L5; i++) {
            Ins in = p5[i];
            exec1(&t4, &st, in);
            if (in.op == CMP) {
              int f0 = st.f[0], c = 1; for (int k = 1; k < T4; k++) if (st.f[k] != f0) { c = 0; break; }
              fconst = c ? f0 : -1;
              if (!c) q[L++] = in;
              continue;
            }
            if (in.op != MOV && fconst >= 0) {
              int mv;
              switch (in.op) { case CMOVL: mv = fconst == 1; break; case CMOVG: mv = fconst == 2; break;
                case CMOVLE: mv = fconst != 2; break; default: mv = fconst != 1; }
              if (fconst == 3) { q[L++] = in; continue; }
              if (mv) { in.op = MOV; q[L++] = in; }
              continue;
            }
            q[L++] = in;
          }
          // remap registers: inputs != m -> P0..P3, P_m -> garbage register, scratch shifted
          for (int i = 0; i < L; i++) {
            uint8_t *rr[2] = {&q[i].d, &q[i].s};
            for (int w = 0; w < 2; w++) { int r = *rr[w];
              if (r < 5) *rr[w] = r == m ? t4.nr - 1 : (r < m ? r : r - 1); else *rr[w] = r - 1; }
          }
          int best = -1;
          if (wrong(&t4, q, L, NULL) == 0) {
            best = 99;
            for (int r = 0; r < tries; r++) { Ins p[MAXL]; memcpy(p, q, sizeof q); int l = rdce(p, L); if (l < best) best = l; if (best == 20) break; }
          }
          printf(" %d", best); if (best >= 0 && best < bestall) bestall = best;
        }
        printf(" | %d\n", bestall == 99 ? -1 : bestall); idx++; cnt[bestall == 99 ? 0 : bestall]++;
        L5 = 0;
      }
      continue;
    }
    char op[32], a[16], b[16];
    if (sscanf(buf, " %31s %15[^, ] , %15s", op, a, b) != 3 || !strcmp(op, "out")) continue;
    if (L5 == 0) nsmap = 0;
    int o = -1; for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    p5[L5].op = o; p5[L5].d = parse_reg(&t5, a); p5[L5].s = parse_reg(&t5, b); L5++;
  }
  fprintf(stderr, "programs %d; best L4 histogram:", idx);
  for (int i = 0; i < 100; i++) if (cnt[i]) fprintf(stderr, " L4=%d:%d", i, cnt[i]);
  fprintf(stderr, "\n");
  return 0;
}
