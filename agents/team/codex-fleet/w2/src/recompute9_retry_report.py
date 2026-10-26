#!/usr/bin/env python3
"""Keep the requested retry record current without changing earlier results."""
from pathlib import Path
import collections
import json
import re

base=Path('logs/recompute9_priority')
priority=json.loads((base/'priority.json').read_text())
counts=collections.Counter();records=[];calls=0;seconds=0;orders=collections.Counter()
for r in priority:
    path=base/'deep'/(Path(r['file']).stem+'.log')
    txt=path.read_text() if path.exists() else ''
    primary_path=path
    primary_txt=txt
    alternative=base/'priority_deeper'/(Path(r['file']).stem+'.log')
    if alternative.exists():
        alt_text=alternative.read_text()
        alt_status=re.findall(r'^RESULT (\w+).*$',alt_text,re.M)
        if alt_status:
            path=alternative;txt=alt_text
    match=re.findall(r'^RESULT (\w+).*$',txt,re.M)
    state=match[-1] if match else ('ACTIVE' if 'skeleton c=' in txt else ('PAUSED' if txt else 'PENDING'))
    counts[state]+=1
    result=re.findall(r'^RESULT .*$',txt,re.M)
    if result:
        c=re.search(r'calls=(\d+)',result[-1]);t=re.search(r'time=([\d.]+)s',result[-1])
        if c:calls+=int(c[1])
        if t:seconds+=float(t[1])
    if txt:
        order=re.search(r'ROOT_ORDER mode=(\d+)',txt)
        orders[order[1] if order else '0']+=1
    records.append(dict(file=r['file'],status=state,log=str(path),result=result[-1] if result else None))
summary=dict(total=len(priority),counts=dict(counts),exhausted_new_skeletons=counts['NONE'],completed_calls=calls,completed_router_seconds=round(seconds,1),root_orders=dict(orders),records=records)
(base/'audit_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
none_rows=[]
for r in records:
    if r['status']!='NONE':continue
    mc=re.search(r'calls=(\d+)',r['result']);mt=re.search(r'time=([\d.]+)s',r['result'])
    none_rows.append(f"| {r['file']} | {int(mc[1]):,} | {mt[1]} | `{r['log']}` |")
none_table='\n'.join(none_rows) if none_rows else '| None yet | - | - | - |'
all_calls=0;all_seconds=0;all_runs=0
for folder in [base/'deep',base/'priority_deeper']:
 for log in folder.glob('r*.log'):
  results=re.findall(r'^RESULT .*$',log.read_text(),re.M)
  if not results:continue
  all_runs+=1
  mc=re.search(r'calls=(\d+)',results[-1]);mt=re.search(r'time=([\d.]+)s',results[-1])
  if mc:all_calls+=int(mc[1])
  if mt:all_seconds+=float(mt[1])
summary['all_completed_full_limit_runs']=all_runs
summary['all_full_limit_calls']=all_calls
summary['all_full_limit_router_seconds']=round(all_seconds,1)
(base/'audit_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
old=Path('RESULTS.md').read_text()
marker='\n## Next round: larger c=9 retries, supervisor 23:10\n'
section=f'''
## Next round: larger c=9 retries, supervisor 23:10

No new program with k <= 31 has passed the strict judge in this round.

The requested set contains 208 distinct unresolved skeletons. The earlier
logs actually used 300,000 nodes for 202 cases, 3,000,000 nodes for six
cases, and later 30,000,000-node retries for two of those cases. All 208
were unknown before this round. This retry uses K=31 and a 60,000,000-node
limit per case. The wall limit is 1,800 seconds per case. A limit or timeout
is unknown. Only an exhausted search is a negative.

The initial 208-case pass finished with NONE 161 and LIMIT 47. Both cases
which originally ran with root order zero, r000111 and r000037, received
one further pass with ROOTORDER=1 and a 120,000,000-node limit. Both
returned LIMIT. The table
below uses the latest completed result for each distinct skeleton. Logs
for these two extra runs are in `logs/recompute9_priority/priority_deeper/`.

Final exact count of newly exhausted skeletons: **{counts['NONE']} / 208**.

| Status in this retry | Cases |
| --- | ---: |
| Exhaustive NONE | {counts['NONE']} |
| Unknown LIMIT | {counts['LIMIT']} |
| Unknown TIMEOUT | {counts['TIMEOUT']} |
| Unknown ERROR | {counts['ERROR']} |
| Relaxed FOUND, see strict judge logs | {counts['FOUND']} |
| Active search | {counts['ACTIVE']} |
| Paused between cases | {counts['PAUSED']} |
| Not yet started | {counts['PENDING']} |

Calls for retained per-case results: {calls:,}. Router time for those results: {seconds:.1f} seconds.
All completed full-limit runs: {all_runs}; calls: {all_calls:,}; router time: {all_seconds:.1f} seconds.
Counts above exclude all pilot runs and all previously tested controls.
They apply only to these fixed skeletons in the 120-order routing model.
They do not establish a general sort5 lower bound.

| Exhausted skeleton | Calls | Router seconds | Log |
| --- | ---: | ---: | --- |
{none_table}

Priority measurement:

- A 200,000-node pilot ran on each of the 208 cases. All returned LIMIT.
  Total calls: 41,619,896. Total reported router time: 180.6 seconds.
- The recorded comparison prefix counts assigned operand nodes. Such a
  node can still have unfinished dependencies. The partial cost bound is
  C + current gates + the resolved-DAG copy bound + the open-requirement
  bound after the current requirement is removed. It is a lower bound,
  not a complete program cost.
- At prefix nine, the minimum observed bounds had this distribution:
  27: one case; 28: 16; 29: 61; 30: 119; 31: ten. One case, r000002,
  reached only prefix six during its pilot and is placed last.
- The retry order uses the lowest observed bound first. The first four
  cases are r000111, r000037, r000005, and r000008. Root-bound ties use
  the lower root bound and then the file name.
- Priority records: `logs/recompute9_priority/priority.json`. Pilot logs:
  `logs/recompute9_priority/pilot/`.

The first retry uses `src/dagx_progress.cpp`, which adds progress output
to the conservative router. After the first two cases, the batch uses
`src/dagx_order.cpp` with ROOTORDER=1. It assigns the last comparison
requirements first. Only the initial requirement order changes. The
instruction set and pruning bounds stay the same. Each case records its
root order. Build details are in `logs/recompute9_priority/order_change.json`. The batch driver is
`src/recompute9_priority_batch.py`. Every search uses nice level 19 and an
address-space limit of 2,800,000,000 bytes. One CPU search runs at a time.
The per-case logs state the node and wall limits. The full audit is
`logs/recompute9_priority/audit_summary.json`; individual retry logs are in
`logs/recompute9_priority/deep/`. Live driver counts are in
`logs/recompute9_priority/summary.json` after the first completed case.

Tests and dead ends in this round:

- `src/dagx_priority.cpp` records the partial bound and caches consistency
  checks with exact keys. On r000008, it made exactly the same 1,000,108
  calls as the original router at a one-million-node limit. Both took
  4.3 seconds. This check did not establish a negative.
- `src/dagx_future.cpp` adds a bound for unique values needed by later
  comparisons. The previously exhausted r000001 control returned NONE
  with exactly 28,633,830 calls and 4,320 leaves, as before. Runtime rose
  to 549.3 seconds. This recheck is not a newly exhausted skeleton.
- On 42 three-input sorting skeletons at four cost limits, the added
  bound matched the baseline on all 168 queries. There were 120 matched
  NONE results and 48 matched FOUND results. Both settings made 39,780
  calls. This is a test result, not a proof of the bound. Logs:
  `logs/future_control3/`; summary: `logs/future_control3/summary.json`.
- `src/dagx_memo.cpp` adds an optional cache of failed states. A benchmark
  on r000008 made 600,338 lookups, with zero hits and 250,000 stored
  states. Runtime was 7.6 seconds with the cache and 4.6 seconds without
  it. Both runs reached the same one-million-node limit. The main retry
  does not use this cache or the later-comparison bound.

Requirement-order controls:

- On the same 42 three-input skeletons and four cost limits, five root
  orders matched all 840 exhaustive baseline results. Total calls by
  order 0..4 were 39,780; 38,106; 36,240; 44,741; and 36,240. This is a
  test result, not a proof. Log: `logs/root_order_control3_batch.log`.
- One-million-node pilots on r000111 remained LIMIT for orders 1..4.
  Their reported times were 2.8, 3.6, 6.0, and 7.4 seconds. These are
  unknown results. They do not add any exhaustive negatives. Logs:
  `logs/recompute9_rootorder_r000111_mode1.log` through `mode4.log`.

Further bounded checks:

- Three full-requirement priority orders matched all 504 three-input
  baseline checks. Their one-million-node pilots on r000111 and r000008
  all reached LIMIT. Logs end in `mode5.log` through `mode7.log`.
- `src/dagx_partition.cpp` separates gates whose columns equal a required
  full column from gates outside that pool. An optional mode removes
  repeated conditional-move columns. Across six settings, 504 three-input
  controls matched the baseline. Both one-million-node r000111 pilots
  remained LIMIT. The main batch uses neither setting. Logs:
  `logs/partition_control3/` and `logs/recompute9_partition_r000111_*.log`.
- `src/ssa_exact.py` uses symbolic register versions. A move allocates a
  fresh register. A conditional move replaces its destination version.
  Constraints prevent later reads of an overwritten version. All 120
  strict orders enter the query. Comparisons use the supplied fixed
  columns. Intermediate columns are unrestricted; there is no fixed
  value pool or two-copy restriction. Outputs can record any produced
  sorted-rank column. This is the initialized-operand SSA routing model.
- The fixed k=33 control query was SAT. Its decoded program passed both
  independent strict judges. The unrestricted r000111 query at K=31 was
  UNKNOWN after its 20-second solver timeout. It used 11,331 conflicts
  and a peak RSS of 178,084 KiB. This is not an exhaustive negative.
  Logs: `logs/ssa_control33.log` and `logs/ssa_r000111_k31.log`.

Copy-bound cache used from r000041 onward:

- `src/dagx_fast.cpp` caches the original copy-bound calculation. Each
  entry stores the resolved gate indices, their blocks and destination /
  source edges, and all comparison uses. These are the data read by that
  calculation. Cache hits compare the entire key. Hash collisions cause
  misses; a hash alone never establishes a match.
- The main batch sets LEGACYFILL=1. Every cache miss uses the original
  copy-bound calculation. Program emission also uses the original
  allocator. This change does not add a routing restriction or change a
  cost. It avoids repeated calculations on the same dependency graph.
- The one-million-node r000008 benchmarks all made exactly 1,000,029
  calls. The baseline took 3.4 seconds. The cached original calculation
  took 1.8 seconds, with 480,372 hits and 55,582 misses. Timing depends
  on shared CPU use. Logs: `logs/recompute9_fast_legacy_benchmark.log`
  and `logs/recompute9_legacy_cached_benchmark.log`.
- A separate stack-based calculation matched 535,954 original copy-bound
  results in its one-million-node check. The main batch fills its cache
  with the original calculation, so it does not rely on this rewrite.
- With every cached result checked again against the original, 336
  three-input control queries matched the baseline. The first positive
  control processed later comparison requirements first and reached its three-million
  node limit. That limit is unknown. The corrected control uses root
  order zero; its decoded k=33 program passed both strict judges.
- Build and control records: `logs/recompute9_priority/copy_cache_change.json`,
  `logs/fast_copy_control3/summary.json`, and
  `logs/recompute9_fast_control33_fixed.log`.

Open-requirement bound implementation used from r000044 onward:

- `src/dagx_lb.cpp` computes each requirement domain and each unfinished
  node domain once per bound call. It stores the open list in a local
  array and uses the same size ordering and greedy incompatible set.
  It keeps the original copy-bound calculation on cache misses.
- On r000008, 768,946 fast open bounds matched the original calculation.
  All four one-million-node variants made exactly 1,000,029 calls. Their
  times were 1.7 seconds for the original open bound, 1.6 with both
  calculations checked, 0.7 with the new implementation, and 0.8 with a
  native build. The main build uses `-O3 -mpopcnt`, as recorded in
  `logs/recompute9_priority/open_bound_change.json`.
- Both copy and open bounds were checked on 336 three-input queries.
  Every exhaustive result matched the baseline. The decoded k=33 control
  also passed both independent strict judges. These are implementation
  checks, not a general sorting lower bound.
- Logs: `logs/fast_open_control3/`,
  `logs/recompute9_lb_checked_benchmark.log`, and
  `logs/recompute9_lb_control33_verify.log`.

New strict judge PASS control files:

| Program | Model | Length | Judge log |
| --- | --- | ---: | --- |
| `programs/recompute9_future_control33.s` | out | k=33 | `logs/recompute9_future_control33.judge.log` |
| `programs/recompute9_future_control33_mem.s` | mem | L=43 | `logs/recompute9_future_control33_mem.judge.log` |
| `programs/ssa_control33_verified.s` | out | k=33 | `logs/ssa_control33_verified.judge.log` |
| `programs/ssa_control33_verified_mem.s` | mem | L=43 | `logs/ssa_control33_verified_mem.judge.log` |
| `programs/recompute9_fast_control33.s` | out | k=33 | `logs/recompute9_fast_control33.judge.log` |
| `programs/recompute9_fast_control33_mem.s` | mem | L=43 | `logs/recompute9_fast_control33_mem.judge.log` |
| `programs/recompute9_lb_control33.s` | out | k=33 | `logs/recompute9_lb_control33.judge.log` |
| `programs/recompute9_lb_control33_mem.s` | mem | L=43 | `logs/recompute9_lb_control33_mem.judge.log` |

All eight control files passed the strict judge. They do not improve the sort5 bound.
No sorting candidate with k <= 31 was produced in these retries.
'''
if marker in old:old=old[:old.index(marker)]
Path('RESULTS.md').write_text(old+section)
print(json.dumps({k:v for k,v in summary.items() if k!='records'}),flush=True)
