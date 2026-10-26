// upper: fast simulator over all weak order types (own code, independent of judge.py)
// Values per test case: dense rank 0..n-1, UNK = 255 (garbage; strict-model sound 3-valued semantics).
// Flags per test: 0 = eq, 1 = lt, 2 = gt, 3 = unknown.
#pragma once
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define MAXR 40
#define MAXT 544      // 541 weak orders for n=5, padded to 32
#define MAXL 96
#define UNK 255

enum { NOP = 0, MOV, CMP, CMOVL, CMOVG, CMOVLE, CMOVGE, XCHG, CMOVE, CMOVNE, NOPS };
static const char *OPN[NOPS] = {"nop", "mov", "cmp", "cmovl", "cmovg", "cmovle", "cmovge", "xchg", "cmove", "cmovne"};

typedef struct { uint8_t op, d, s; } Ins;

// model kinds
enum { MOD_P = 0,   // MODEL.md: P0..Pn-1 hold inputs, outputs fixed in P_j, S garbage
       MOD_FREE,    // AlphaDev counting minus 2n: inputs in P, outputs from ANY distinct registers
       MOD_MEM,     // AlphaDev exact: inputs in memory M0..Mn-1, S garbage; loads/stores are movs; outputs in M_j
       MOD_OUT };   // MODEL.md 4.3: like FREE but output j = value of any register at any step (free 'out j, R')

typedef struct {
  int n, T, TP, nr, nin;       // nin = number of input registers (P or M)
  int model, memops;           // memops: cmp/cmov may take an M operand
  int opsok[NOPS];
  uint8_t init[MAXR][MAXT];
  uint8_t expv[5][MAXT];
} Task;

typedef struct { uint8_t r[MAXR][MAXT]; uint8_t f[MAXT]; } State;

static int gen_weak(int n, uint8_t vals[][5]) {
  // all weak orders: assign values 0..n-1 such that the set of used values is {0..m-1}
  int cnt = 0, tot = 1;
  for (int i = 0; i < n; i++) tot *= n;
  for (int c = 0; c < tot; c++) {
    int v[5], x = c, used = 0;
    for (int i = 0; i < n; i++) { v[i] = x % n; x /= n; used |= 1 << v[i]; }
    if ((used & (used + 1)) != 0) continue;  // must be prefix 0..m-1
    for (int i = 0; i < n; i++) vals[cnt][i] = v[i];
    cnt++;
  }
  return cnt;
}

static int is_ro(const Task *t, int r) { return t->model == MOD_MEM && r < t->nin; }

static void task_init(Task *t, int n, int nscratch, int model, int memops, const char *iset) {
  memset(t, 0, sizeof *t);
  t->n = n; t->model = model; t->memops = memops; t->nin = n;
  t->nr = n + nscratch;
  if (t->nr > MAXR) { fprintf(stderr, "too many regs\n"); exit(1); }
  static uint8_t vals[4000][5];
  t->T = gen_weak(n, vals);
  t->TP = (t->T + 31) & ~31;
  for (int r = 0; r < MAXR; r++) for (int k = 0; k < MAXT; k++) t->init[r][k] = UNK;
  for (int k = 0; k < t->T; k++) {
    uint8_t s[5];
    for (int i = 0; i < n; i++) { t->init[i][k] = vals[k][i]; s[i] = vals[k][i]; }
    for (int i = 1; i < n; i++) for (int j = i; j > 0 && s[j - 1] > s[j]; j--) { uint8_t z = s[j]; s[j] = s[j - 1]; s[j - 1] = z; }
    for (int j = 0; j < n; j++) t->expv[j][k] = s[j];
  }
  for (int k = t->T; k < t->TP; k++) {  // padding: copy test 0 (keeps costs exact if we only count k<T)
    for (int r = 0; r < MAXR; r++) t->init[r][k] = t->init[r][0];
    for (int j = 0; j < n; j++) t->expv[j][k] = t->expv[j][0];
  }
  t->opsok[MOV] = t->opsok[CMP] = t->opsok[CMOVL] = t->opsok[CMOVG] = 1;
  // I0 = mov/cmp/cmovl/cmovg; I1 = + cmovle/cmovge; I2 = I1 + cmove/cmovne/xchg; suffix x = + xchg
  if (strchr(iset, '1') || strchr(iset, '2')) { t->opsok[CMOVLE] = t->opsok[CMOVGE] = 1; }
  if (strchr(iset, '2')) { t->opsok[CMOVE] = t->opsok[CMOVNE] = t->opsok[XCHG] = 1; }
  if (strchr(iset, 'x')) t->opsok[XCHG] = 1;
}

// is instruction legal in this model?
static int legal(const Task *t, Ins in) {
  if (in.op == NOP) return 1;
  if (!t->opsok[in.op]) return 0;
  if (in.d == in.s) return 0;
  if (t->model != MOD_MEM) return 1;
  int rd = is_ro(t, in.d), rs = is_ro(t, in.s);
  switch (in.op) {
    case MOV: return !(rd && rs);               // load, store or reg-reg
    case CMP: return t->memops ? !(rd && rs) : !(rd || rs);
    case XCHG: return !rd && !rs;
    default: return !rd && (t->memops || !rs);  // cmov
  }
}

static inline void exec1(const Task *t, State *st, Ins in) {
  const int TP = t->TP;
  uint8_t *d = st->r[in.d], *s = st->r[in.s], *f = st->f;
  switch (in.op) {
    case NOP: break;
    case MOV: memcpy(d, s, TP); break;
    case CMP:
      for (int k = 0; k < TP; k++) {
        uint8_t a = d[k], b = s[k];
        uint8_t u = (a == UNK) | (b == UNK);
        uint8_t v = (a < b) ? 1 : (a > b) ? 2 : 0;
        f[k] = u ? 3 : v;
      }
      break;
    case XCHG:
      for (int k = 0; k < TP; k++) { uint8_t z = d[k]; d[k] = s[k]; s[k] = z; }
      break;
    default: {
      // condition masks: which flag values move
      uint8_t m0, m1, m2;  // move on eq, lt, gt
      switch (in.op) {
        case CMOVL: m0 = 0; m1 = 1; m2 = 0; break;
        case CMOVG: m0 = 0; m1 = 0; m2 = 1; break;
        case CMOVLE: m0 = 1; m1 = 1; m2 = 0; break;
        case CMOVE: m0 = 1; m1 = 0; m2 = 0; break;
        case CMOVNE: m0 = 0; m1 = 1; m2 = 1; break;
        default: m0 = 1; m1 = 0; m2 = 1; break;  // CMOVGE
      }
      for (int k = 0; k < TP; k++) {
        uint8_t fl = f[k], dv = d[k], sv = s[k];
        uint8_t mv = (fl == 0 && m0) | (fl == 1 && m1) | (fl == 2 && m2);
        uint8_t un = (fl == 3) & (dv != sv);
        d[k] = mv ? sv : (un ? UNK : dv);
      }
    }
  }
}

static void state_init(const Task *t, State *st) {
  for (int r = 0; r < t->nr; r++) memcpy(st->r[r], t->init[r], t->TP);
  memset(st->f, 3, t->TP);  // initial flags unknown (strict model)
}

static void run(const Task *t, State *st, const Ins *p, int L) {
  state_init(t, st);
  for (int i = 0; i < L; i++) exec1(t, st, p[i]);
}

// error matrix err[j][r] = #tests where reg r != expected j-th
static void errmat(const Task *t, const State *st, int err[5][MAXR]) {
  for (int j = 0; j < t->n; j++)
    for (int r = 0; r < t->nr; r++) {
      if (t->model == MOD_P && r != j) { err[j][r] = 1 << 20; continue; }
      if (t->model == MOD_MEM && r != j) { err[j][r] = 1 << 20; continue; }
      const uint8_t *a = st->r[r], *e = t->expv[j];
      int c = 0;
      for (int k = 0; k < t->T; k++) c += (a[k] != e[k]);
      err[j][r] = c;
    }
}

// assignment cost (greedy; exact when a zero-cost assignment exists)
static int assign_cost(const Task *t, int err[5][MAXR], int *outreg) {
  int n = t->n, usedr[MAXR] = {0}, done[5] = {0}, tot = 0;
  for (int it = 0; it < n; it++) {
    int bj = -1, br = -1, bc = 1 << 30;
    for (int j = 0; j < n; j++) if (!done[j])
      for (int r = 0; r < t->nr; r++) if (!usedr[r] && err[j][r] < bc) { bc = err[j][r]; bj = j; br = r; }
    done[bj] = 1; usedr[br] = 1; tot += bc; if (outreg) outreg[bj] = br;
  }
  return tot;
}

// MOD_OUT: snapshot outputs. outt[j] = index of instruction after which 'out j' is placed (-1 = at start)
#include "branch_eval.h"
static int wrong_out(const Task*t,const Ins*p,int L,int*orr,int*ort){return branch_eval(t,p,L,orr,ort,NULL);}
static int original_wrong_out(const Task *t, const Ins *p, int L, int *outreg, int *outt) {
  static __thread State st;
  int best[5], bt[5], br[5];
  for (int j = 0; j < t->n; j++) best[j] = 1 << 20, bt[j] = -1, br[j] = 0;
  state_init(t, &st);
  for (int i = 0; i < L; i++) {
    exec1(t, &st, p[i]);
    if (p[i].op == NOP || p[i].op == CMP) continue;
    for (int w = 0; w < (p[i].op == XCHG ? 2 : 1); w++) {
      int r = w ? p[i].s : p[i].d;
      const uint8_t *a = st.r[r];
      for (int j = 0; j < t->n; j++) {
        const uint8_t *e = t->expv[j]; int c = 0;
        for (int k = 0; k < t->T; k++) c += (a[k] != e[k]);
        if (c < best[j]) best[j] = c, bt[j] = i, br[j] = r;
      }
    }
  }
  int tot = 0;
  for (int j = 0; j < t->n; j++) { tot += best[j]; if (outreg) outreg[j] = br[j]; if (outt) outt[j] = bt[j]; }
  return tot;
}

static int wrong(const Task *t, const Ins *p, int L, int *outreg) {
  if (t->model == MOD_OUT) return wrong_out(t, p, L, outreg, NULL);
  static __thread State st;
  int err[5][MAXR];
  run(t, &st, p, L);
  errmat(t, &st, err);
  return assign_cost(t, err, outreg);
}

static void regname(const Task *t, int r, char *buf) {
  if (r < t->nin) sprintf(buf, "%c%d", t->model == MOD_MEM ? 'M' : 'P', r);
  else sprintf(buf, "S%d", r - t->nin);
}

// S registers are renamed densely in order of first use (files may use sparse names)
static int smap[1024], nsmap;
static int parse_reg(const Task *t, const char *s) {
  int v = atoi(s + 1);
  if (s[0] == 'P' || s[0] == 'M') return v;
  if (s[0] == 'S') {
    for (int i = 0; i < nsmap; i++) if (smap[i] == v) return t->nin + i;
    if (t->nin + nsmap >= t->nr) { fprintf(stderr, "too many registers (%s)\n", s); exit(1); }
    smap[nsmap++] = v; return t->nin + nsmap - 1;
  }
  return -1;
}

static void print_prog(FILE *fo, const Task *t, const Ins *p, int L) {
  char a[16], b[16];
  int outr[5], outt[5];
  if (t->model == MOD_OUT) wrong_out(t, p, L, outr, outt);
  for (int i = 0; i < L; i++) {
    if (p[i].op == NOP) continue;
    regname(t, p[i].d, a); regname(t, p[i].s, b);
    fprintf(fo, "%s %s, %s\n", OPN[p[i].op], a, b);
    if (t->model == MOD_OUT)
      for (int j = 0; j < t->n; j++) if (outt[j] == i) { regname(t, outr[j], a); fprintf(fo, "out %d, %s\n", j, a); }
  }
}

// read program in .s format (Intel order). returns length.
static int read_prog(const Task *t, const char *fn, Ins *p) {
  FILE *fi = fopen(fn, "r");
  if (!fi) { perror(fn); exit(1); }
  char line[256]; int L = 0; nsmap = 0;
  // note: 'out' lines are ignored (outputs are recomputed)
  while (fgets(line, sizeof line, fi)) {
    char *h = strchr(line, '#'); if (h) *h = 0;
    char op[32], a[16], b[16];
    if (sscanf(line, " %31s %15[^, ] , %15s", op, a, b) != 3) continue;
    int o = -1;
    for (int k = 1; k < NOPS; k++) if (!strcmp(op, OPN[k])) o = k;
    if (!strcmp(op, "out")) continue;
    if (o < 0) { fprintf(stderr, "bad op %s\n", op); exit(1); }
    p[L].op = o; p[L].d = parse_reg(t, a); p[L].s = parse_reg(t, b);
    L++;
  }
  fclose(fi);
  return L;
}

static int count_len(const Ins *p, int L) { int c = 0; for (int i = 0; i < L; i++) c += p[i].op != NOP; return c; }

// remove NOPs, then greedily delete instructions while still correct
static int dce(const Task *t, Ins *p, int L) {
  int m = 0;
  for (int i = 0; i < L; i++) if (p[i].op != NOP) p[m++] = p[i];
  L = m;
  for (int changed = 1; changed;) {
    changed = 0;
    for (int i = 0; i < L; i++) {
      Ins q[MAXL]; int c = 0;
      for (int j = 0; j < L; j++) if (j != i) q[c++] = p[j];
      if (wrong(t, q, c, NULL) == 0) { memcpy(p, q, c * sizeof(Ins)); L = c; changed = 1; break; }
    }
  }
  return L;
}
