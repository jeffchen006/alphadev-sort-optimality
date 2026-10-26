// d5-extend: collect end-state value functions of sort4 cores (strict sim, 75 weak orders of 4):
// every register content at the end + both operands of the last cmp (at cmp time). Global hash set with counts.
#include "../../upper/src/sim.h"
#define HS (1 << 22)
static uint8_t keys[HS][76]; static long cnt[HS]; static int used[HS];
static void add(const uint8_t *v, int T, int tag) {
  uint8_t k[76]; memcpy(k, v, T); k[75] = tag;
  unsigned long h = 1469598103934665603UL; for (int i = 0; i < 76; i++) h = (h ^ k[i]) * 1099511628211UL;
  for (unsigned i = h & (HS - 1);; i = (i + 1) & (HS - 1)) {
    if (!used[i]) { used[i] = 1; memcpy(keys[i], k, 76); cnt[i] = 1; return; }
    if (!memcmp(keys[i], k, 76)) { cnt[i]++; return; }
  }
}
int main() {
  Task t; task_init(&t, 4, 12, MOD_OUT, 0, "I1");
  char buf[256]; Ins p[MAXL]; int L = 0; long np = 0;
  for (int more = 1; more;) {
    more = fgets(buf, sizeof buf, stdin) != NULL;
    if (!more || buf[0] == '#') {
      if (L) {
        State st; state_init(&t, &st); int lastc = -1;
        for (int i = 0; i < L; i++) if (p[i].op == CMP) lastc = i;
        for (int i = 0; i < L; i++) {
          if (i == lastc) { add(st.r[p[i].d], t.T, 1); add(st.r[p[i].s], t.T, 1); }
          exec1(&t, &st, p[i]);
        }
        for (int r = 0; r < t.nr; r++) { int g = 1; for (int k = 0; k < t.T; k++) if (st.r[r][k] != UNK) g = 0; if (!g) add(st.r[r], t.T, 0); }
        np++; L = 0;
      }
      if (more && buf[0] == '#') nsmap = 0;
      continue;
    }
    char op[32], a[16], b[16];
    if (sscanf(buf, " %31s %15[^, ] , %15s", op, a, b) != 3 || !strcmp(op, "out")) continue;
    int o = -1; for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    p[L].op = o; p[L].d = parse_reg(&t, a); p[L].s = parse_reg(&t, b); L++;
  }
  fprintf(stderr, "programs %ld T=%d\n", np, t.T);
  for (int i = 0; i < HS; i++) if (used[i]) {
    printf("%d %ld ", keys[i][75], cnt[i]);
    for (int k = 0; k < t.T; k++) printf("%c", keys[i][k] == UNK ? 'U' : '0' + keys[i][k]);
    printf("\n");
  }
}
