# w14 exact routing results

Status: checks in progress. No new program has passed the strict judge.

The supervisor assigned 10,696 paths in
`agents/team/d1-skeleton/out/w8r4u_half2_for_w14.txt`.
I copied that list to `assigned.txt`. I copied every skeleton to `sk/`.
The manifest contains 10,696 distinct SHA-256 hashes of the comparison lines.
The list contains 9,905 skeletons with 10 comparisons and 791 with 9 comparisons.
This count differs from the earlier brief. I use the explicit assigned list.

I copied `dagx.cpp` from d1-skeleton without changes. Its SHA-256 hash is
`170a39aed7d72b0f065e668876783b1ed33829effcbacc44bc112789cb6dec09`.
Build command: `nice -n 10 g++ -O3 -DNDEBUG -std=c++17 dagx.cpp -o dagx`.

At 2026-10-26 07:01:49 UTC, I switched to a build of the same source with
`-march=native`. The build uses the instructions available on this CPU.
`build_native.json` records both executable hashes and the progress at the switch.
`dagx.generic` retains the first executable. The worker's CPU affinity is `[75]`.
Both the compiler and the solver therefore share one CPU core.

Each check runs `./dagx FILE 31 1`. The command has no node limit.
The runner removes the `SPLIT` and `CPLSLACK` environment settings.
The runner starts one solver at a time. It sets niceness to at least 10 and
limits virtual memory to 3,000,000,000 bytes.

First pass: `python3 run_batch.py --timeout 2`.
A wall timeout produces `LIMIT`. It does not establish `NONE`.
Only a successful process with `RESULT NONE` establishes an exact negative
result for that fixed skeleton in dagx's model.

`resolved.txt` lists the skeleton hash and latest status.
`manifest.json` maps each hash to its assigned source and local copy.
`runs.jsonl` records each attempt, node count, elapsed time, and log path.
`logs/` holds the complete solver output.
`status.json` records current progress.

The solver uses all 120 strict input permutations. It routes fully defined
register values for the fixed comparison operands. A negative result in this
relaxation excludes a strict sorting program for that skeleton within the
solver's scope. It does not cover arbitrary garbage-dependent comparisons.
The source was previously described by d1 as judge-reviewed. I have not
independently proved its search rules.

If the solver emits a candidate, the runner saves both register and memory
programs. The runner applies `shared/judge.py --strict` to both programs.
Only two strict PASS results permit the status `FOUND`.

No PASS file paths yet.

Performance experiment: I tested the existing `CPLSLACK` settings 2, 0, and
999 on `sk/round4_repeat10_r015275.txt`, with a five-second wall limit for
each run. All three runs reached the wall limit. The experiment did not
identify a faster setting. I kept the default setting in the batch.
See `bench/records.json` and `bench/cpl*.out`. These runs do not establish
an exact result and do not change `resolved.txt`.

Restart: the saved history contained 4,963 attempts: 4,770 NONE and 193 LIMIT.
I verified that these attempts form the assigned prefix with no duplicates.
I resumed the first pass without repeating any saved attempt.
The resumed process retains CPU affinity `[75]`, nice level 10, and the
3,000,000,000-byte address-space limit. Its log is `restart_pass1.log`.

`audit_state.py` checks every local skeleton against its source, the exact
assigned list, the manifest hashes, attempt order, and completed solver logs.
The first audit passed at 2026-10-26 07:31:55 UTC. Its snapshot included
5,375 attempts: 5,177 NONE and 198 LIMIT. `audit.json` holds the audit record.
The search continues. LIMIT cases will run after the first pass with a larger
time limit. They remain unknown unless a complete search returns NONE or a
candidate passes both strict judges.
