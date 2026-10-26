Run commands from this worker folder.

Build:

```sh
g++ -O3 -std=c++17 src/dagx.cpp -o dagx
g++ -O3 -std=c++17 src/switch_prefix.cpp -o switch_prefix
g++ -O3 -std=c++17 src/mutation.cpp -o mutation
g++ -O3 -std=c++17 src/two_switch.cpp -o two_switch
g++ -O3 -std=c++17 src/filter.cpp -o filter_fast
g++ -O3 -std=c++17 src/nonlattice_filter.cpp -o nonlattice_filter_cached
g++ -O3 -std=c++17 src/check_canonical.cpp -o check_canonical
```

Generation:

```sh
nice -n 10 python3 src/partner_networks.py
nice -n 10 ./switch_prefix 2 sk/switch2
nice -n 10 ./switch_prefix 3 sk/switch3
nice -n 10 ./switch_prefix 4 sk/switch4
nice -n 10 ./switch_prefix 5 sk/switch5
nice -n 10 ./switch_prefix 6 sk/switch6
nice -n 10 ./mutation programs/known32.s sk/mutation
nice -n 10 python3 src/second_mutation.py
nice -n 10 ./two_switch sk/two_switch sk/switch2 sk/switch3 sk/switch4 sk/switch5 sk/switch6
nice -n 10 python3 src/priority_dedup.py
```

The saved manifests contain the exact cases used by each batch. The broad
search changed from 100,000 nodes to 20,000 nodes after 3,202 recorded cases.
The second pass skips cases already recorded by the first pass or priority
passes. A skipped limited case remains unresolved.

```sh
nice -n 10 python3 src/route_batch.py sk/broad100k_executed.json --jobs 6 --nodes 100000 --seconds 15 --tag broad100k
nice -n 10 python3 src/route_batch.py sk/broad_nonlattice.json --jobs 6 --nodes 20000 --seconds 10 --tag broad20k --reuse logs/priority17/results.jsonl logs/priority5/results.jsonl logs/broad100k/results.jsonl
nice -n 10 python3 src/route_batch.py sk/selected1m_executed.json --jobs 6 --nodes 1000000 --seconds 30 --tag selected1m
nice -n 10 python3 src/route_batch.py sk/selected_deep_remaining.json --jobs 7 --nodes 1000000 --seconds 30 --tag selected1m_remaining
nice -n 10 python3 src/sat_batch.py sk/mutation2_nonlattice.json --tag mutation2_sat --conflicts 20000 --seconds 45
```

Run no more than eight CPU search jobs at once. Each routing or SAT worker
has a 3 GiB address-space limit. The generators use one CPU job each.

Verification and report:

```sh
nice -n 10 ./check_canonical
nice -n 10 python3 src/fixed_route.py sk/mutation/valid_graphs.jsonl --tag fixed_control --control
nice -n 10 python3 src/audit.py
nice -n 10 python3 src/report.py
nice -n 10 python3 src/final_report.py
```

`src/verify_log.py FILE.s PREFIX` writes register and memory versions and
runs the strict reference judge on both. It saves each exact PASS or FAIL
line in `logs/PREFIX.judge.log` and `logs/PREFIX_mem.judge.log`.

The seven saved PASS files are controls. Their register cores have k=32.
Their memory forms have length 42.

## Round 2 resource update

The supervisor reduced this worker to one CPU job at a time. This round uses
nice -n 19 and a 3 GiB address-space limit. The earlier eight-job commands
above describe the prior round only.

```sh
nice -n 19 python3 src/round2_prepare.py
nice -n 19 ./mutation /path/to/repo/agents/team/d7-structure/fam32/net9_41_k32.s sk/net9_41_mutation
nice -n 19 ./partner_select /path/to/repo/agents/team/d7-structure/fam32/net9_41_k32.s sk/net9_41_partner sk/nonlattice_prior_keys.txt sk/round2_excluded_files.txt
nice -n 19 python3 src/round2_run.py --manifest sk/round2_net9_41.json --tag round2_net41
nice -n 19 python3 src/round2_run.py
nice -n 19 python3 src/round2_audit.py
nice -n 19 python3 src/round2_report.py
```

`round2_run.py` resumes from its completed records. It uses the per-case node
limits in its manifest. The initial unresolved list is frozen before any rerun.
The per-batch `summary.json` files report node counts and all result statuses.
The batch runner records LIMIT as unknown. It has no wall-time cutoff.

The `dagx_round2` wrapper runs `dagx_fast`, built from `src/dagx_fast.cpp`
with `g++ -O3 -march=native -std=c++17`. This build caches exact copy bounds
and prefix-consistency results. Each column also stores its covered-order
mask. Its node counter and traversal match the
uncached build on the saved checks. Cache checks are in
`logs/round2_cache_check.json`, `logs/round2_cache2_check.json`, and
`logs/round2_fast_check.json`.

## Round 3: search-order changes

All commands run one CPU process at a time. Use nice -n 19 and a 3 GiB
address-space limit. The benchmark and batch scripts set the address-space
limit before they start routing. Run the listed searches in sequence.

```sh
nice -n 19 g++ -O3 -march=native -std=c++17 src/dagx_order.cpp -o dagx_order
nice -n 19 python3 src/round3_bench.py
nice -n 19 python3 src/round3_bench.py --modes 0,5,9,13 --tag round3_bench2 --small
nice -n 19 python3 src/round3_prepare.py
# The chosen mode is recorded in logs/round3_order200/summary.json.
# The completed batch command is recorded in the final round-three report.
nice -n 19 python3 src/round3_report.py
```

`ROUTE_ORDER` controls only branch and requirement order in `dagx_order`.
Bit 1: resolve the gate side with the larger constrained domain first.
Bit 2: visit earlier allowed comparison blocks first.
Bit 4: reverse the initial comparison-operand requirement order.
Bit 8: resolve output requirements in median-first order.
Mode 0 retains the original traversal. These controls do not remove branches
or change the lower bounds.

The first benchmark used the initial source before bits 4 and 8 were added.
The second benchmark checks mode 0 again after these additions. The saved
logs record each case and its exact node limit.

Selected primary batch:

```sh
nice -n 19 python3 src/round3_run.py --manifest sk/round3_order200.json --tag round3_order200 --mode 13
```

The 200-case queue gives each case 2,000,000 nodes under mode 13. It uses
the supervisor's changed-order alternative. It is not a uniform 100-fold
increase over the previous round's node limits.

Additional 100-fold original-limit batch (run after the primary batch):

```sh
nice -n 19 python3 src/round3_deep_prepare.py
nice -n 19 python3 src/round3_run.py --manifest sk/round3_deep200.json --tag round3_deep200 --mode 13
nice -n 19 python3 src/round3_report.py
```

This second queue contains 200 other cases. It ranks the previous limited
runs by exact-copy-bound visits divided by recursive calls. This is a prefix
statistic. It does not estimate a full search-tree size. The new limit is
2,000,000 nodes: 100 times the original 20,000 and ten times round two.

To resume a batch, run its `round3_run.py` command against the frozen
manifest. Do not regenerate its manifest after partial results have changed
the set of unresolved cases. `logs/round3_build.json` stores the source,
binary, runner, and manifest hashes.

## Round 4: new classes after supervisor correction 05:30

Use one CPU process at a time, nice -n 19, below 3 GiB. Do not rerun the old
nine-comparison unresolved list; d1-skeleton owns that list.

```sh
nice -n 19 g++ -O3 -march=native -std=c++17 src/rotation_prefix.cpp -o rotation_prefix
nice -n 19 g++ -O3 -march=native -std=c++17 src/round4_prepare.cpp -o round4_prepare
# Position-by-position generation and frozen source preparation are recorded
# in logs/round4_rotation*_generation.log and sk/round4_*_files.txt.
nice -n 19 ./round4_prepare
nice -n 19 python3 src/round4_start.py
```

`round4_start.py` runs rotation and delayed-repeat queues in sequence. The
repeat runner first calls `round4_audit.py` if the audit file does not exist.
This audit checks the source columns and runs fixed-graph copy minimization.
It then checks strict controls. Search results use K=31, order mode 13.
Each rotation case gets 100,000 states. Each delayed-repeat case gets 20,000.
The runner records every case and saves progress every 25 cases.

```sh
nice -n 19 python3 src/round4_run.py --manifest sk/round4_rotation.json --tag round4_rotation --mode 13
nice -n 19 python3 src/round4_run.py --manifest sk/round4_repeat10.json --tag round4_repeat10 --mode 13
```

The source files, manifests, and binaries have hashes in
`logs/round4_build.json`. Repeated calls resume the frozen queues. A LIMIT
result remains unknown. Only strict-judge PASS files count as candidates.

A final new-case routing pass gives 200 limited rotation cases ten times their
first node limit. It ranks required-column counts first. Within that group,
it ranks exact-copy-bound visits divided by recursive calls. This statistic
comes from a bounded prefix. It does not estimate the full search-tree size.
Run this pass after the two broad queues complete.

```sh
nice -n 19 python3 src/round4_deep_prepare.py
nice -n 19 python3 src/round4_run.py --manifest sk/round4_deep.json --tag round4_deep --mode 13
nice -n 19 python3 src/round4_report.py
```
