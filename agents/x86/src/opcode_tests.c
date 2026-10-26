/* x86 agent: opcode semantics tests for mov / cmp / cmovl / cmovg / cmovle / cmovge,
 * 32-bit and 64-bit register forms, on the real CPU.
 * Build: gcc -O2 -mno-red-zone -o build/opcode_tests src/opcode_tests.c  (inline push/pushfq needs no red zone)
 * Each test prints PASS/FAIL with counts. Exit 0 = all pass.
 */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <signal.h>
#include <setjmp.h>
#include <sys/mman.h>

#define CF 0x1ull
#define PF 0x4ull
#define AF 0x10ull
#define ZF 0x40ull
#define SF 0x80ull
#define OF 0x800ull
#define FLM (CF | PF | AF | ZF | SF | OF)

static uint64_t z = 0x2545F4914F6CDD1Dull;
static uint64_t rnd(void) { z ^= z << 13; z ^= z >> 7; z ^= z << 17; return z; }
static int fails = 0;
static void report(const char *name, long runs, long bad) {
  printf("%-72s runs=%-9ld fail=%ld %s\n", name, runs, bad, bad ? "FAIL" : "PASS");
  if (bad) fails++;
}

static const int64_t EXT64[] = {INT64_MIN, INT64_MIN + 1, (int64_t)INT_MIN - 1, INT_MIN, INT_MIN + 1, -2, -1, 0, 1, 2,
                                INT_MAX - 1, INT_MAX, (int64_t)INT_MAX + 1, 0xFFFFFFFFll, 0x100000000ll, INT64_MAX - 1, INT64_MAX};
#define NE (int)(sizeof EXT64 / sizeof EXT64[0])
static uint64_t pick(long t) { return (t % 3 == 0) ? (uint64_t)EXT64[rnd() % NE] : (t % 3 == 1) ? rnd() : (rnd() & 0xFFFFFFFF00000000ull) | (uint32_t)EXT64[rnd() % NE]; }

/* ---------- cmp: flags and the four signed conditions ---------- */
static void test_cmp(void) {
  long runs = 0, bad32 = 0, bad64 = 0, badeq = 0;
  for (long t = 0; t < 4000000; t++) {
    uint64_t a = pick(t), b = (t % 7 == 0) ? a : pick(t + 1);   /* many equal pairs */
    if (t % 11 == 0) b = (a & 0xFFFFFFFFull) | (rnd() << 32);    /* equal low 32, different upper */
    uint64_t f32, f64;
    uint8_t l32, g32, le32, ge32, l64, g64, le64, ge64;
    __asm__ volatile("cmp %k3, %k2\n\tpushfq\n\tpop %0\n\tsetl %1\n\tsetg %b4\n\t"
                     : "=r"(f32), "=q"(l32), "+r"(a), "+r"(b), "=q"(g32) :: "cc");
    __asm__ volatile("cmp %k1, %k0\n\tsetle %2\n\tsetge %3" : "+r"(a), "+r"(b), "=q"(le32), "=q"(ge32) :: "cc");
    __asm__ volatile("cmp %3, %2\n\tpushfq\n\tpop %0\n\tsetl %1\n\tsetg %b4\n\t"
                     : "=r"(f64), "=q"(l64), "+r"(a), "+r"(b), "=q"(g64) :: "cc");
    __asm__ volatile("cmp %1, %0\n\tsetle %2\n\tsetge %3" : "+r"(a), "+r"(b), "=q"(le64), "=q"(ge64) :: "cc");
    runs++;
    int32_t A = (int32_t)a, B = (int32_t)b;
    uint32_t d = (uint32_t)A - (uint32_t)B;
    uint64_t want = ((uint32_t)A < (uint32_t)B ? CF : 0) | (__builtin_parity(d & 0xFF) ? 0 : PF) | ((((uint32_t)A ^ (uint32_t)B ^ d) & 0x10) ? AF : 0) |
                    (d == 0 ? ZF : 0) | ((d >> 31) ? SF : 0) | ((((A ^ B) & (A ^ (int32_t)d)) < 0) ? OF : 0);
    if ((f32 & FLM) != want || l32 != (A < B) || g32 != (A > B) || le32 != (A <= B) || ge32 != (A >= B)) bad32++;
    int64_t A6 = (int64_t)a, B6 = (int64_t)b;
    uint64_t d6 = a - b;
    uint64_t want6 = (a < b ? CF : 0) | (__builtin_parity(d6 & 0xFF) ? 0 : PF) | (((a ^ b ^ d6) & 0x10) ? AF : 0) |
                     (d6 == 0 ? ZF : 0) | ((d6 >> 63) ? SF : 0) | ((((A6 ^ B6) & (A6 ^ (int64_t)d6)) < 0) ? OF : 0);
    if ((f64 & FLM) != want6 || l64 != (A6 < B6) || g64 != (A6 > B6) || le64 != (A6 <= B6) || ge64 != (A6 >= B6)) bad64++;
    if (A == B && (l32 || g32 || !le32 || !ge32 || !(f32 & ZF))) badeq++;
  }
  report("cmp r32,r32: ZF/SF/OF/CF/PF/AF and setl/setg/setle/setge == signed 32-bit compare", runs, bad32);
  report("cmp r64,r64: same, signed 64-bit compare", runs, bad64);
  report("cmp r32 equal low halves: ZF=1, l=g=0, le=ge=1 (upper 32 bits ignored)", runs, badeq);
}

/* ---------- condition codes of cmov: exhaustive over the 6 arithmetic flags ---------- */
#define CMOV_FL(OP, W)                                                                          \
  static uint64_t OP##_##W(uint64_t fl, uint64_t d, uint64_t s, uint64_t *flout) {             \
    __asm__ volatile("push %3\n\tpopfq\n\t" #OP " %" #W "2, %" #W "0\n\tpushfq\n\tpop %1"     \
                     : "+r"(d), "=r"(*flout) : "r"(s), "r"(fl) : "cc");                          \
    return d;                                                                                     \
  }
CMOV_FL(cmovl, k) CMOV_FL(cmovg, k) CMOV_FL(cmovle, k) CMOV_FL(cmovge, k)
CMOV_FL(cmovl, q) CMOV_FL(cmovg, q) CMOV_FL(cmovle, q) CMOV_FL(cmovge, q)
static uint64_t mov_k(uint64_t fl, uint64_t d, uint64_t s, uint64_t *flout) {
  __asm__ volatile("push %3\n\tpopfq\n\tmov %k2, %k0\n\tpushfq\n\tpop %1" : "+r"(d), "=r"(*flout) : "r"(s), "r"(fl) : "cc"); return d; }
static uint64_t mov_q(uint64_t fl, uint64_t d, uint64_t s, uint64_t *flout) {
  __asm__ volatile("push %3\n\tpopfq\n\tmov %q2, %q0\n\tpushfq\n\tpop %1" : "+r"(d), "=r"(*flout) : "r"(s), "r"(fl) : "cc"); return d; }
/* same register as source and destination, 32-bit, condition false/true */
static uint64_t cmovl_same_k(uint64_t fl, uint64_t d, uint64_t *flout) {
  __asm__ volatile("push %2\n\tpopfq\n\tcmovl %k0, %k0\n\tpushfq\n\tpop %1" : "+r"(d), "=r"(*flout) : "r"(fl) : "cc"); return d; }

typedef uint64_t (*cm_t)(uint64_t, uint64_t, uint64_t, uint64_t *);
static int cond(int op, uint64_t f) {
  int zf = !!(f & ZF), sf = !!(f & SF), of = !!(f & OF);
  switch (op) { case 0: return sf != of; case 1: return !zf && sf == of; case 2: return zf || sf != of; case 3: return sf == of; }
  return 1; /* mov */
}

static void test_cmov(void) {
  uint64_t base;
  __asm__ volatile("pushfq; pop %0" : "=r"(base));
  base &= ~FLM;
  cm_t f32[] = {cmovl_k, cmovg_k, cmovle_k, cmovge_k, mov_k}, f64[] = {cmovl_q, cmovg_q, cmovle_q, cmovge_q, mov_q};
  const char *nm[] = {"cmovl", "cmovg", "cmovle", "cmovge", "mov"};
  for (int op = 0; op < 5; op++) {
    long runs = 0, bad32 = 0, bad64 = 0, badfl = 0, false32 = 0, false32_zext = 0;
    for (int fb = 0; fb < 64; fb++) {
      uint64_t fl = base | ((fb & 1) ? CF : 0) | ((fb & 2) ? PF : 0) | ((fb & 4) ? AF : 0) | ((fb & 8) ? ZF : 0) | ((fb & 16) ? SF : 0) | ((fb & 32) ? OF : 0);
      for (int t = 0; t < 20000; t++) {
        uint64_t d = rnd() | (1ull << 40), s = rnd(), fo;   /* d has nonzero upper half */
        int c = cond(op, fl);
        uint64_t r = f32[op](fl, d, s, &fo);
        runs++;
        uint64_t want = c ? (uint32_t)s : (uint32_t)d;     /* 32-bit: zero-extend in both cases */
        if (r != want) bad32++;
        if (!c) { false32++; if (r >> 32 == 0) false32_zext++; }
        if ((fo & FLM) != (fl & FLM)) badfl++;
        r = f64[op](fl, d, s, &fo);
        if (r != (c ? s : d)) bad64++;
        if ((fo & FLM) != (fl & FLM)) badfl++;
      }
    }
    char b[200];
    snprintf(b, sizeof b, "%s r32,r32: all 64 flag combos; true -> zext(src), false -> zext(dst)", nm[op]); report(b, runs, bad32);
    if (op < 4) printf("    %s r32 with FALSE condition: %ld runs, upper 32 bits cleared in %ld (SDM: cleared)\n", nm[op], false32, false32_zext);
    snprintf(b, sizeof b, "%s r64,r64: all 64 flag combos; true -> src, false -> dst unchanged", nm[op]); report(b, runs, bad64);
    snprintf(b, sizeof b, "%s r32/r64: arithmetic flags unchanged", nm[op]); report(b, 2 * runs, badfl);
  }
  long runs = 0, bad = 0;
  for (int t = 0; t < 100000; t++) {
    uint64_t d = rnd() | (1ull << 40), fo, fl = base | ((t & 1) ? SF : 0);  /* SF=1,OF=0 -> l true */
    uint64_t r = cmovl_same_k(fl, d, &fo);
    runs++;
    if (r != (uint32_t)d) bad++;
  }
  report("cmovl r32 D,D (same register), true and false: upper 32 bits cleared", runs, bad);
}

/* ---------- cmov with a memory source and a false condition: is the source still read? ---------- */
static sigjmp_buf jb;
static void on_segv(int sig) { (void)sig; siglongjmp(jb, 1); }
static void test_cmov_mem(void) {
  char *page = mmap(NULL, 4096, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  signal(SIGSEGV, on_segv);
  volatile int faulted = 0;
  if (sigsetjmp(jb, 1) == 0) {
    uint32_t d = 7;
    /* cmp 1,0 -> 1 > 0 so l is false */
    __asm__ volatile("mov $1, %%eax\n\tcmp $0, %%eax\n\tcmovl (%1), %0" : "+r"(d) : "r"(page) : "eax", "cc", "memory");
  } else faulted = 1;
  signal(SIGSEGV, SIG_DFL);
  printf("%-72s %s\n", "cmovl r32, m32 with FALSE condition on unreadable page:", faulted ? "FAULTS (source is read; SDM)" : "no fault");
}

int main(void) {
  test_cmp();
  test_cmov();
  test_cmov_mem();
  printf("%s\n", fails ? "SOME TESTS FAILED" : "ALL OPCODE TESTS PASS");
  return fails != 0;
}
