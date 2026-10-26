// usage: check <file.s> n model(P|free|mem) [memops 0/1] [iset I0|I1|I1x]
#include "sim.h"
int main(int argc, char **argv) {
  int n = atoi(argv[2]);
  int model = !strcmp(argv[3], "P") ? MOD_P : !strcmp(argv[3], "free") ? MOD_FREE : !strcmp(argv[3], "out") ? MOD_OUT : MOD_MEM;
  int memops = argc > 4 ? atoi(argv[4]) : 0;
  const char *iset = argc > 5 ? argv[5] : "I1x";
  Task t; task_init(&t, n, 34, model, memops, iset);
  Ins p[MAXL]; int L = read_prog(&t, argv[1], p);
  for (int i = 0; i < L; i++) if (!legal(&t, p[i])) { printf("ILLEGAL instr %d in model\n", i + 1); return 2; }
  int out[5]; int w = wrong(&t, p, L, out);
  printf("L=%d tests=%d wrong=%d outputs:", L, t.T, w);
  char b[8]; for (int j = 0; j < n; j++) { regname(&t, out[j], b); printf(" %s", b); } printf("\n");
  return w != 0;
}
