/* x86 agent: hardware timing of sort kernels (for `latency`).
 * Build: gcc -O2 -DBENCH_H='"<abs>/bench.h"' -o bench src/bench.c bench.S ; run pinned: taskset -c CORE ./bench
 * Clock: rdtsc (lfence-fenced); converted to core cycles by a calibration chain of dependent adds
 * (1 add = 1 core cycle), measured in the same run.
 * Setups (per kernel, TRIALS trials, report min and median of per-call cycles, minus the baseline
 * bench_empty measured the same way):
 *   lat  : dependent chain. One buffer; after each call x = (OR of all n outputs) & zero (zero is an
 *          opaque 0) and buf[j] ^= x for all j, so EVERY input of call i+1 waits for the LAST output
 *          of call i. Includes store->load forwarding (the AlphaDev form is memory to memory).
 *   thr  : independent calls. 64 buffers (L1-resident), called round robin; out-of-order overlap allowed.
 * Inputs: random int32 (kernels are branchless; cmov timing does not depend on data).
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <x86intrin.h>
#include BENCH_H

#define TRIALS 31
#define ITERS 100000
#define NBUF 64

static inline uint64_t tsc(void) { _mm_lfence(); uint64_t t = __rdtsc(); _mm_lfence(); return t; }
static uint64_t z = 88172645463325252ull;
static uint64_t rnd(void) { z ^= z << 13; z ^= z >> 7; z ^= z << 17; return z; }
static int cmpd(const void *a, const void *b) { double x = *(const double *)a, y = *(const double *)b; return (x > y) - (x < y); }
static int cmpi(const void *a, const void *b) { int x = *(const int *)a, y = *(const int *)b; return (x > y) - (x < y); }

static double ticks_per_cycle(void) {
  double best = 1e9;
  for (int t = 0; t < 21; t++) {
    uint64_t a = 0, t0 = tsc();
    for (int i = 0; i < 1000; i++)
      __asm__ volatile(".rept 1000\n\tadd $1, %0\n\t.endr" : "+r"(a));
    uint64_t t1 = tsc();
    double r = (double)(t1 - t0) / 1e6;
    if (r < best) best = r;
  }
  return best;
}

static volatile int zero_src = 0;

static void measure(void (*fn)(int *), int n, double tpc, double *lat_min, double *lat_med, double *thr_min, double *thr_med) {
  static int buf[16], bufs[NBUF][16];
  double lat[TRIALS], thr[TRIALS];
  int zero = zero_src;
  for (int t = 0; t < TRIALS; t++) {
    for (int j = 0; j < n; j++) buf[j] = (int)rnd();
    uint64_t t0 = tsc();
    for (int i = 0; i < ITERS; i++) {
      fn(buf);
      int x = 0;
      for (int j = 0; j < n; j++) x |= buf[j];
      x &= zero;
      for (int j = 0; j < n; j++) buf[j] ^= x;
    }
    uint64_t t1 = tsc();
    lat[t] = (double)(t1 - t0) / ITERS / tpc;
    for (int b = 0; b < NBUF; b++) for (int j = 0; j < n; j++) bufs[b][j] = (int)rnd();
    t0 = tsc();
    for (int i = 0; i < ITERS / NBUF; i++) for (int b = 0; b < NBUF; b++) fn(bufs[b]);
    t1 = tsc();
    thr[t] = (double)(t1 - t0) / ((ITERS / NBUF) * NBUF) / tpc;
  }
  qsort(lat, TRIALS, sizeof(double), cmpd); qsort(thr, TRIALS, sizeof(double), cmpd);
  *lat_min = lat[0]; *lat_med = lat[TRIALS / 2]; *thr_min = thr[0]; *thr_med = thr[TRIALS / 2];
}

int BENCH_N;
int main(int argc, char **argv) {
  BENCH_N = argc > 1 ? atoi(argv[1]) : 3;
  /* correctness sanity check of each kernel */
  for (int k = 0; k < NBENCH; k++) {
    int n = BENCH[k].n, bad = 0;
    for (int t = 0; t < 200000; t++) {
      int b[16], w[16];
      for (int j = 0; j < n; j++) b[j] = w[j] = (t & 1) ? (int)(rnd() % 3) - 1 : (int)rnd();
      BENCH[k].fn(b); qsort(w, n, sizeof(int), cmpi);
      if (memcmp(b, w, 4 * n)) bad++;
    }
    if (bad) { printf("SANITY FAIL %s: %d\n", BENCH[k].name, bad); return 1; }
  }
  double tpc = ticks_per_cycle();
  printf("# rdtsc ticks per core cycle = %.4f (dependent add chain). Units below: core cycles per call.\n", tpc);
  double bl[4];
  measure(bench_empty, BENCH_N, tpc, &bl[0], &bl[1], &bl[2], &bl[3]);
  printf("# n = %d\n", BENCH_N);
  printf("# baseline (empty call + harness loop): lat min %.2f med %.2f | thr min %.2f med %.2f\n", bl[0], bl[1], bl[2], bl[3]);
  printf("%-34s %2s %3s %5s | %9s %9s | %9s %9s   (baseline subtracted)\n", "kernel", "n", "L", "saves", "lat_min", "lat_med", "thr_min", "thr_med");
  for (int k = 0; k < NBENCH; k++) {
    double r[4];
    if (BENCH[k].n != BENCH_N) continue;
    measure(BENCH[k].fn, BENCH[k].n, tpc, &r[0], &r[1], &r[2], &r[3]);
    printf("%-34s %2d %3d %5d | %9.2f %9.2f | %9.2f %9.2f\n", BENCH[k].name, BENCH[k].n, BENCH[k].L, BENCH[k].saves,
           r[0] - bl[0], r[1] - bl[1], r[2] - bl[2], r[3] - bl[3]);
  }
  return 0;
}
