/* x86 agent: opcode tests for the MM+ variant (memory SOURCE in cmp / cmov), real CPU.
 * Build: gcc -O2 -mno-red-zone -o build/memop_tests src/memop_tests.c
 * 1. cmp r32, m32 and cmp m32, r32 set the same CF PF AF ZF SF OF as cmp r32, r32 (m = same value).
 * 2. cmovcc r32, m32 (l, g, le, ge): true -> zext(mem), false -> zext(dst); flags unchanged;
 *    all 64 combinations of CF PF AF ZF SF OF; memory not written.
 * 3. Fault behaviour: cmovcc r32, m32 on an unreadable page faults for TRUE and FALSE conditions
 *    (the source is always read); cmp with an unreadable memory operand faults.
 * 4. Operand that crosses a cache line and a page boundary: same results.
 */
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <signal.h>
#include <setjmp.h>
#include <sys/mman.h>

#define FLM 0x8D5ull
static uint64_t z = 0x9E3779B97F4A7C15ull;
static uint64_t rnd(void) { z ^= z << 13; z ^= z >> 7; z ^= z << 17; return z; }
static int fails;
static void report(const char *name, long runs, long bad) {
  printf("%-78s runs=%-9ld fail=%ld %s\n", name, runs, bad, bad ? "FAIL" : "PASS");
  if (bad) fails++;
}
static const uint32_t EXT[] = {0x80000000u, 0x80000001u, 0xFFFFFFFEu, 0xFFFFFFFFu, 0, 1, 2, 0x7FFFFFFEu, 0x7FFFFFFFu};
static uint32_t val(long t) { return (t & 1) ? EXT[rnd() % 9] : (uint32_t)rnd(); }

/* flags after cmp in three forms */
static uint64_t cmp_rr(uint64_t a, uint64_t b) { uint64_t f; __asm__ volatile("cmp %k2, %k1\n\tpushfq\n\tpop %0" : "=r"(f) : "r"(a), "r"(b) : "cc"); return f; }
static uint64_t cmp_rm(uint64_t a, const uint32_t *m) { uint64_t f; __asm__ volatile("cmp (%2), %k1\n\tpushfq\n\tpop %0" : "=r"(f) : "r"(a), "r"(m) : "cc", "memory"); return f; }
static uint64_t cmp_mr(const uint32_t *m, uint64_t b) { uint64_t f; __asm__ volatile("cmp %k2, (%1)\n\tpushfq\n\tpop %0" : "=r"(f) : "r"(m), "r"(b) : "cc", "memory"); return f; }

#define CMOVM(OP)                                                                              \
  static uint64_t OP##_m(uint64_t fl, uint64_t d, const uint32_t *m, uint64_t *fo) {           \
    __asm__ volatile("push %3\n\tpopfq\n\t" #OP " (%2), %k0\n\tpushfq\n\tpop %1"               \
                     : "+r"(d), "=r"(*fo) : "r"(m), "r"(fl) : "cc", "memory");                 \
    return d;                                                                                  \
  }
CMOVM(cmovl) CMOVM(cmovg) CMOVM(cmovle) CMOVM(cmovge)
typedef uint64_t (*cm_t)(uint64_t, uint64_t, const uint32_t *, uint64_t *);
static int cond(int op, uint64_t f) {
  int zf = !!(f & 0x40), sf = !!(f & 0x80), of = !!(f & 0x800);
  switch (op) { case 0: return sf != of; case 1: return !zf && sf == of; case 2: return zf || sf != of; default: return sf == of; }
}

static sigjmp_buf jb;
static void on_segv(int s) { (void)s; siglongjmp(jb, 1); }

int main(void) {
  static uint8_t buf[8192 + 64] __attribute__((aligned(4096)));
  uint32_t *al = (uint32_t *)buf;                          /* aligned */
  uint32_t *xl = (uint32_t *)(buf + 62);                   /* crosses a 64-byte line */
  uint32_t *xp = (uint32_t *)(buf + 4094);                 /* crosses a 4 KiB page */
  uint32_t *ms[3] = {al, xl, xp};
  const char *mn[3] = {"aligned", "cache-line split", "page split"};

  for (int k = 0; k < 3; k++) {
    long runs = 0, b1 = 0, b2 = 0;
    for (long t = 0; t < 2000000; t++) {
      uint64_t a = rnd() << 32 | val(t), b = rnd() << 32 | ((t % 5 == 0) ? (uint32_t)a : val(t + 1));
      uint32_t bl = (uint32_t)b, al32 = (uint32_t)a;
      memcpy(ms[k], &bl, 4);
      uint64_t f0 = cmp_rr(a, b) & FLM;
      if ((cmp_rm(a, ms[k]) & FLM) != f0) b1++;
      memcpy(ms[k], &al32, 4);
      if ((cmp_mr(ms[k], b) & FLM) != f0) b2++;
      runs++;
    }
    char s[160];
    snprintf(s, sizeof s, "cmp r32, m32 flags == cmp r32, r32 (%s)", mn[k]); report(s, runs, b1);
    snprintf(s, sizeof s, "cmp m32, r32 flags == cmp r32, r32 (%s)", mn[k]); report(s, runs, b2);
  }

  uint64_t base;
  __asm__ volatile("pushfq; pop %0" : "=r"(base));
  base &= ~FLM;
  cm_t f[4] = {cmovl_m, cmovg_m, cmovle_m, cmovge_m};
  const char *nm[4] = {"cmovl", "cmovg", "cmovle", "cmovge"};
  for (int op = 0; op < 4; op++)
    for (int k = 0; k < 3; k++) {
      long runs = 0, bad = 0, badfl = 0, badmem = 0;
      for (int fb = 0; fb < 64; fb++) {
        uint64_t fl = base | ((fb & 1) ? 1 : 0) | ((fb & 2) ? 4 : 0) | ((fb & 4) ? 0x10 : 0) | ((fb & 8) ? 0x40 : 0) | ((fb & 16) ? 0x80 : 0) | ((fb & 32) ? 0x800 : 0);
        for (int t = 0; t < 5000; t++) {
          uint64_t d = rnd() | (1ull << 40), fo;
          uint32_t m = val(t), mm;
          memcpy(ms[k], &m, 4);
          uint64_t r = f[op](fl, d, ms[k], &fo);
          memcpy(&mm, ms[k], 4);
          runs++;
          if (r != (cond(op, fl) ? m : (uint32_t)d)) bad++;
          if ((fo & FLM) != (fl & FLM)) badfl++;
          if (mm != m) badmem++;
        }
      }
      char s[160];
      snprintf(s, sizeof s, "%s r32, m32 (%s): true -> zext(mem), false -> zext(dst), 64 flag combos", nm[op], mn[k]);
      report(s, runs, bad);
      snprintf(s, sizeof s, "%s r32, m32 (%s): flags and memory unchanged", nm[op], mn[k]);
      report(s, runs, badfl + badmem);
    }

  /* faults: unreadable page */
  uint32_t *page = mmap(NULL, 4096, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  signal(SIGSEGV, on_segv);
  for (int op = 0; op < 4; op++)
    for (int want = 0; want < 2; want++) {
      /* flags: want=1 -> condition true, want=0 -> false */
      uint64_t fl = 0;
      for (int fb = 0; fb < 64; fb++) {
        uint64_t c = base | ((fb & 8) ? 0x40 : 0) | ((fb & 16) ? 0x80 : 0) | ((fb & 32) ? 0x800 : 0);
        if (cond(op, c) == want) { fl = c; break; }
      }
      volatile int faulted = 0;
      if (sigsetjmp(jb, 1) == 0) { uint64_t fo; f[op](fl, 7, page, &fo); }
      else faulted = 1;
      printf("%s r32, m32 on unreadable page, condition %-5s: %s\n", nm[op], want ? "TRUE" : "FALSE",
             faulted ? "SIGSEGV (source read)" : "no fault");
      if (!faulted) fails++;
    }
  volatile int faulted = 0;
  if (sigsetjmp(jb, 1) == 0) cmp_rm(1, page); else faulted = 1;
  printf("cmp r32, m32 on unreadable page: %s\n", faulted ? "SIGSEGV" : "no fault");
  if (!faulted) fails++;
  signal(SIGSEGV, SIG_DFL);
  printf("%s\n", fails ? "SOME MEMOP TESTS FAILED" : "ALL MEMOP TESTS PASS");
  return fails != 0;
}
