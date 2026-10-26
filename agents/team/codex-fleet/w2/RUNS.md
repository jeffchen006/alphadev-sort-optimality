Purpose: search ten-comparison sort5 programs with core length at most 31.

A value column records one register value for each test input order. A value
skeleton fixes the comparison operand columns. The router selects moves,
conditional moves, register reuse, and output times for that skeleton.

Build the conservative routers:

```sh
python3 src/build_flag_router.py
python3 src/build_safe_router.py
nice -n 10 g++ -O3 -std=c++17 src/dagx_safe.cpp -o dagx_safe
nice -n 10 g++ -O3 -std=c++17 src/dagx_flags_safe.cpp -o dagx_flags_safe_bin
```

Run one family at a time. Each command below uses at most eight workers.
Use a new log directory to repeat a search or increase its node limit.
The batch tool reuses any existing log that contains a RESULT line.

```sh
nice -n 10 python3 src/batch.py sk/net10 logs/recheck_net10 --jobs 8 --nodes 30000000 --seconds 180 --engine ./dagx_safe
nice -n 10 python3 src/batch.py sk/repeat logs/recheck_repeat --jobs 8 --nodes 3000000 --seconds 120 --engine ./dagx_safe
nice -n 10 python3 src/batch.py sk/refresh logs/recheck_refresh --jobs 8 --nodes 100000 --seconds 30 --engine ./dagx_flags_safe
nice -n 10 python3 src/batch.py sk/nonlattice10 logs/recheck_nonlattice10 --jobs 8 --nodes 300000 --seconds 60 --engine ./dagx_flags_safe
nice -n 10 python3 src/batch.py sk/refresh_tail logs/recheck_tail --jobs 8 --nodes 300000 --seconds 60 --engine ./dagx_flags_safe_bin
```

The SAT batch uses a fixed value pool and at most two copies of each value.
It tests selected refresh cases and all 462 extensions of worker w6's seed.
It reuses completed logs. A file lock prevents two SAT batches from running
at the same time.

The `dagx_flags_safe` wrapper selects SAT for final-comparison cases and
worker w6's two-refresh cases. Other inputs use `dagx_flags_safe_bin`.
Final-comparison SAT cases have a 5,000-conflict limit. Worker w6 cases have
a 20,000-conflict limit. Their logs state the value pool size.
The SAT batch reuses matching completed results from these wrapper runs.
The SAT router adds value-conservation, instruction-time, and free-copy
gate-count bounds. Standard jobs use Glucose 4. Deep retry jobs use
CaDiCaL 1.9.5. The optional `--solver` argument selects a backend.

```sh
nice -n 10 python3 src/sat_batch.py --jobs 8 --conflicts 20000 --seconds 25
```

Check a routing log and both output models:

```sh
nice -n 10 python3 src/verify_log.py logs/control_c10_k33.log reproduced_control
```

If a candidate fails on ties, try the condition repair. It preserves the
register operands and comparison instructions. A repair still needs both
strict judge checks.

```sh
nice -n 10 python3 src/repair_ties.py programs/sat_w6_control32.s programs/reproduced_tie_repair.s
nice -n 10 python3 src/verify_log.py programs/reproduced_tie_repair.s reproduced_tie_repair
```

Read RESULTS.md for completed counts and judge PASS paths. Read each log's
final RESULT or FINAL line before interpreting a search. LIMIT and TIMEOUT
leave that case unresolved. SAT only supplies a candidate. FOUND from the SAT
batch requires PASS from the strict out and memory judges.

For the streamed retry pass, use six workers for the broad tail pass and
run `nice -n 10 python3 src/deepen_tail.py` with its two workers. After the
broad and selected batches finish, `src/finish_tail.py` can use six more
workers. The retry pass reuses their results. These stages keep the total
at eight solver processes.
