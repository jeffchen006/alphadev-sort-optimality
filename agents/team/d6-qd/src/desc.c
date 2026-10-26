// d6-qd: descriptors of each program in a collection file ("# prog len=K" headers, out lines ignored).
// Prints: idx c m v nblk blocks(cmov per cmp) skelhash  (skelhash = hash of the sequence of unordered pairs of
// cmp operand value vectors over all weak orders: semantic, independent of register names)
#include "sim.h"

static Task T;
static uint64_t vhash(const uint8_t *a, int n) {
  uint64_t h = 1469598103934665603ULL;
  for (int k = 0; k < n; k++) h = (h ^ a[k]) * 1099511628211ULL;
  return h;
}

int main(int argc, char **argv) {
  task_init(&T, 5, 30, MOD_OUT, 0, "I1");
  char line[256];
  Ins p[MAXL]; int L = 0, idx = -1;
  int map[4096];
  FILE *fi = stdin;
  for (int done = 0; !done;) {
    char *g = fgets(line, sizeof line, fi);
    if (!g || !strncmp(line, "# prog", 6)) {
      if (idx >= 0 && L > 0) {
        static State st;
        state_init(&T, &st);
        int c = 0, m = 0, v = 0, blk[16] = {0}, nb = 0;
        uint64_t sh = 1469598103934665603ULL;
        for (int i = 0; i < L; i++) {
          if (p[i].op == CMP) {
            uint64_t a = vhash(st.r[p[i].d], T.T), b = vhash(st.r[p[i].s], T.T);
            if (a > b) { uint64_t z = a; a = b; b = z; }
            sh = (sh ^ a) * 1099511628211ULL; sh = (sh ^ b) * 1099511628211ULL;
            c++; nb++;
          } else if (p[i].op == MOV) m++;
          else { v++; if (nb > 0 && nb <= 16) blk[nb - 1]++; }
          exec1(&T, &st, p[i]);
        }
        printf("%d %d %d %d ", idx, c, m, v);
        for (int b = 0; b < nb && b < 16; b++) printf("%d", blk[b]);
        printf(" %016llx\n", (unsigned long long)sh);
      }
      if (!g) { done = 1; break; }
      idx++; L = 0;
      for (int r = 0; r < 4096; r++) map[r] = -1;
      continue;
    }
    char *h = strchr(line, '#'); if (h) *h = 0;
    char op[32], a[16], b[16];
    if (sscanf(line, " %31s %15[^, ] , %15s", op, a, b) != 3) continue;
    if (!strcmp(op, "out")) continue;
    int o = -1;
    for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    int rr[2]; char *ab[2] = {a, b};
    for (int k = 0; k < 2; k++) {
      int x = atoi(ab[k] + 1);
      if (ab[k][0] == 'P') rr[k] = x;
      else { if (map[x] < 0) { int mx = 5; for (int y = 0; y < 4096; y++) if (map[y] >= mx) mx = map[y] + 1; map[x] = mx; } rr[k] = map[x]; }
    }
    p[L].op = o; p[L].d = rr[0]; p[L].s = rr[1]; L++;
  }
  return 0;
}
