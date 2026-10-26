No k<=31 candidate has a strict judge PASS in this work.
C2 is open. No global UNSAT claim is made.

Latest snapshot: 2026-10-26 08:07 UTC. Revision 2 has 310 closed UNSAT
prefix roots out of 1575. There are 1265 open roots. The replay audit checked
all 314 saved revision-2 UNSAT certificates again. The latest supervisor
decision limits new target runs to completed d2 cases. The d2 results folder
has 12 UNKNOWN records and no verified UNSAT decision. The cross-check has decided
0 / remaining 3280 / unknown 3280 requested position cases. No agreement or
disagreement can be reported yet. See RUNNING.md and independent/REVIEW.md.

## Current independent cross-check

The latest supervisor decision assigns both main C2 variants to d2. This
worker now runs only completed d2 cases through its independent encoder.
No new broad prefix sweep was started in this turn.

`src/peer_cases.py` now distinguishes V1 from V2. The earlier adapter always
restricted comparison operands to lattice values. The new adapter permits
tagged comparison operands in V2. It also translates peer block-prefix cubes
from their saved semantic sizes. It checks the signs and variable identities
across each saved cube table. It does not import a peer encoder.

`src/watch_peer.py` runs the independent prefix partition for each completed,
verified peer case. If all cubes of a parent case close, it also requires an
independently checked cover certificate. The global count covers 1351 V1
position cases and 1929 V2 position cases. It does not treat an empty peer
results folder as completion. The current queue has no completed peer input.

The certificate inventory has 351 checked UNSAT certificates: 19 revision-1
target leaves, 314 revision-2 target leaves, 10 earlier control certificates,
five sort3 control certificates, two cover certificates, and one no-comparison
certificate. The overlapping target revisions are not added to obtain a
closed program scope. The manifest records formula and proof hashes, the
checker path and hash, and the replay evidence. See
`independent/CERTIFICATE_MANIFEST.json`, `logs/replay_revision2.log`, and
`logs/certificate_inventory.log`.
`independent/CLOSED_SCOPE.json` lists every closed prefix, its unit clauses,
and the checked leaf records that close it.

The independent sort3 controls returned k=11,c=3 SAT and k=10,c=1..5 UNSAT.
The SAT program has a strict judge PASS in both models. Each UNSAT has a DRAT
certificate accepted by drat-trim. These results agree with the small sort3
boundary in d2's manifest. They are controls, not sort5 position-case results.
The additional PASS paths are:

- `independent/sort3_controls/k11_c3_answer.s`
- `independent/sort3_controls/k11_c3_answer_mem.s`

The judge output is in `logs/sort3_controls.log` and
`independent/sort3_controls/k11_c3_answer.validation.json`.
The adapter's two cover certificates are in
`independent/peer_adapter_controls/`. The control log is
`logs/peer_adapter_controls.log`. These certificates check the 105 first-data
prefixes and the translated 43-cube block partition.

The four interrupted RUNNING nodes were returned to PENDING. This changes
no decision. `independent/session_recovery.json` records the affected nodes.
The independent encoder and its normal forms still need judge review.
The tool list still has no SendMessage tool. `MESSAGE_TO_D2.md` contains the
updated message for supervisor relay.

## Purpose

Independently encode full-value sort5 programs with at most two non-lattice
written values. Include comparisons that read either exceptional value.
Use prefix cases. Check every UNSAT certificate.

## Observations

The inherited src/two_columns.py imports the copied w10 encoder. The saved
six runs have incomplete solver logs and no final decision records. They do
not provide an independent C2 cross-check. They are retained as prior artifacts.
The current work does not rerun those six searches.

The independent encoder is src/independent_c2.py. It imports only the Python
standard library. Its solver and certificate runner is separate.
MESSAGE_TO_D2.md records the prefix plan. No SendMessage tool is available.
The filesystem rule prevents writes to the shared inbox.

At 2026-10-26 06:58 UTC, d2's c2/results directory has no completed cases.

2026-10-26 06:58 UTC: cases decided 0 / remaining not yet generated / unknown 0.

## Verified controls

The independent encoder completed eight controls. Four have SAT assignments
that satisfy their saved CNF files. Each decoded program has a strict judge
PASS in both models. Four controls have UNSAT certificates accepted by
`agents/proofs/tools/bin/drat-trim`. The expected root-level checker path does
not exist in this snapshot. The actual checker path and hash are recorded.

| Control | Verified result |
|---|---|
| sort2, k=4 | strict judge PASS, both models |
| sort2, k=3 | UNSAT, DRAT checked |
| fixed pure-lattice sort5, k=32, bound zero | strict judge PASS, both models |
| fixed one-exception sort5, k=32, bound two | strict judge PASS, both models |
| same one-exception program, bound zero | UNSAT, DRAT checked |
| fixed sort5 with both exceptions as comparison operands, k=39 | strict judge PASS, both models |
| same two-exception program, bound one | UNSAT, DRAT checked |
| same two-exception program, lattice comparison operands | UNSAT, DRAT checked |

The k=39 control has two non-lattice written versions on all 541 weak orders.
Its next two comparisons read those two versions. This checks a scope that
the original w10 round5 encoder omitted. It is not a shorter sort result.

Strict PASS program paths, relative to this folder:

- `independent/controls/sort2_k4_answer.s`
- `independent/controls/sort2_k4_answer_mem.s`
- `independent/controls/control_pure_answer.s`
- `independent/controls/control_pure_answer_mem.s`
- `independent/controls/control_one_exception_answer.s`
- `independent/controls/control_one_exception_answer_mem.s`
- `independent/controls/two_exception_comparands_answer.s`
- `independent/controls/two_exception_comparands_answer_mem.s`

Judge output is in `logs/independent_controls.log`,
`logs/comparand_controls.log`, and each program's `.validation.json` file.
The formula controls and all four certificates remain in
`independent/controls/`. The method and limits are in `independent/METHOD.md`.

## Target cases

Each comparison count has 105 first-data prefixes. The prefix fixes the opcode,
source input, and old destination input for a cmov. It leaves all later choices
free. The target permits either exception as a comparison operand. The current
campaigns start at c=7 and c=8. They use four CPU workers in total at nice>=10.

A conflict-budget stop leaves the case unresolved. The runner divides that
case into two exhaustive child cubes. A checked UNSAT leaf excludes only its
saved cube. It does not close its prefix root until both sides of every split
are closed. The state files list every pending leaf.

The first c=7 smoke run decided five leaves with checked DRAT certificates.
It left 107 leaves pending and closed no complete prefix root. Its original
progress line used `unknown 0` to count unexpanded budget stops only. That
wording was too narrow. Future lines count every pending leaf as unknown.

2026-10-26 07:04 UTC corrected: c=7 cases decided 5 / remaining 107 / unknown 107;
closed prefix roots 0/105.

## Earlier revision 2 campaign

Revision 2 adds necessary value-preservation constraints. A future copy
instruction cannot recover an input value after its last register copy is
lost. Until the program records that value as output, some live version must
hold it. The full argument is in `independent/METHOD.md`.

The same eight controls passed again. Revision 2 has four checked UNSAT
certificates and four decoded programs with strict judge PASS in both models.
The additional PASS paths are:

- `independent/controls_v2/sort2_k4_answer.s`
- `independent/controls_v2/sort2_k4_answer_mem.s`
- `independent/controls_v2/control_pure_answer.s`
- `independent/controls_v2/control_pure_answer_mem.s`
- `independent/controls_v2/control_one_exception_answer.s`
- `independent/controls_v2/control_one_exception_answer_mem.s`
- `independent/controls_v2/two_exception_comparands_answer.s`
- `independent/controls_v2/two_exception_comparands_answer_mem.s`

The judge records are in `logs/controls_v2.log` and the `.validation.json`
files. No sort5 control has k<=31.

The first-prefix c=7 sweep decided all 105 roots once. It returned 80 checked
UNSAT roots and 25 unresolved roots. Each unresolved root was divided into
two exhaustive child cubes. The 80 closed roots have a first cmov whose source
and old destination are different inputs. The five first-mov roots and the
20 self-cmov roots remain open. Thus the closed scope is explicit. It is not
the full c=7 class.

The c=7 continuation now uses two persistent CPU workers. Each worker caches
only the immutable parsed base clauses. It starts a fresh solver and proof for
each cube. Two repeated sort2 rejection checks tested the cache path. Both
proofs passed drat-trim. No learned clause is carried between cubes.

The c=8 and c=15 first-prefix sweeps use one CPU worker each. After they finish,
`src/remaining_sweep.py` uses their two CPU slots for c=1..6 and c=9..14. It
then revisits unresolved cubes. The c=7 runner retains its two CPU slots.
At most four CPU search or certificate workers run in total. Every two hours,
each active runner appends a progress line. The status file also gives the
1575-root scope over all c=1..15. Counts from overlapping revisions are not
added together.

2026-10-26 07:32 UTC: revision-2 c=7 roots decided 80 / remaining 25 / unknown 25;
leaf cases decided 80 / remaining 50 / unknown 50.

## Certificate audit and no-comparison case

The replay audit reconstructed and rechecked all 19 revision-1 target UNSAT
certificates and all eight original and revision-2 control rejection
certificates. It checked the saved formula and proof hashes. It also checked
the complete binary split structure of both revision-1 case trees.
All checks succeeded. The record is `logs/replay_audit.log`.

`src/no_comparison.py` gives a separate finite relaxation for c=0 at any
length. Restrict initial flags to equality and scratch values to one value
above all inputs. Every data instruction then does nothing or copies one
fixed symbol. Output zero must be one fixed input symbol or that scratch
symbol. Each choice has a strict-order witness where it is not the minimum.
The saved CNF permits an arbitrary choice of symbol and is UNSAT.
Its DRAT certificate passed drat-trim. Artifacts are in
`independent/no_comparison/`. The reduction argument still needs judge review.

## Remaining limits

The independent C2 sweep is incomplete. Many cubes remain unknown. No target
candidate has passed the strict judge. No encoder review by judge has occurred
through the tools available in this session. C1 is outside this worker's scope.

`src/peer_crosscheck.py` reads only completed verified d2 case records. It builds
a new formula with this worker's encoder. It does not import a peer encoder.
It has not run a target cross-check because the peer results directory is
still empty. `MESSAGE_TO_D2.md` records the prefix plan and the c=15 update.
SendMessage is unavailable, and the filesystem rule prevents shared inbox
writes. The supervisor must relay that message for direct team coordination.

## Resource snapshot at 2026-10-26 07:43 UTC

The completed revision-1 records contain 172 queries: 19 checked UNSAT leaves
and 153 conflict-budget stops that were divided into child cubes. Their saved
solver times sum to 1604.347 CPU seconds. Their checker times sum to 32.648
wall seconds. Those leaves overlap the later revision-2 program classes.

The completed revision-2 records contain 396 queries: 290 checked UNSAT leaves
and 106 conflict-budget stops. Their saved solver times sum to 1236.185 CPU
seconds. Their checker times sum to 735.981 wall seconds. The 290 leaf results
close 286 whole prefix roots at this snapshot. The other checked leaves are
inside roots that remain open.

The largest recorded worker resident memory is 825316 KiB. This is a per-worker
measurement, not an aggregate RAM measurement. All workers run at nice>=10.
The resource record is `independent/resource_snapshot.json`. The figures are
completed-query measurements. They omit work in currently running queries.

2026-10-26 07:04 UTC: c=7 cases decided 5 / remaining 107 / unknown 0; closed prefix roots 0/105.

2026-10-26T07:18:59.955557+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:18:59.955557+00:00: cases_v2 prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26 07:19 UTC: c=7 cases decided 19 / remaining 199 / unknown 0; closed prefix roots 0/105.

2026-10-26 07:20 UTC: c=8 cases decided 0 / remaining 145 / unknown 0; closed prefix roots 0/105.

2026-10-26T07:23:41.958685+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:23:41.958685+00:00: cases_v2 prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:25:50.631622+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:25:50.631622+00:00: cases_v2 prefix roots decided 23 / remaining 1552 / unknown 1552 (1575 roots over c=1..15).

2026-10-26 07:32 UTC: c=7 cases decided 80 / remaining 50 / unknown 50; closed prefix roots 80/105.

2026-10-26T07:34:53.341426+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:34:53.341426+00:00: cases_v2 prefix roots decided 183 / remaining 1392 / unknown 1392 (1575 roots over c=1..15).

2026-10-26T07:37:14.280580+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:37:14.280580+00:00: cases_v2 prefix roots decided 212 / remaining 1363 / unknown 1363 (1575 roots over c=1..15).

2026-10-26 07:38 UTC: c=15 cases decided 80 / remaining 50 / unknown 50; closed prefix roots 80/105.

2026-10-26 07:39 UTC: c=8 cases decided 80 / remaining 50 / unknown 50; closed prefix roots 80/105.

2026-10-26T07:41:38.584903+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:41:38.584903+00:00: cases_v2 prefix roots decided 255 / remaining 1320 / unknown 1320 (1575 roots over c=1..15).

2026-10-26T07:43:05.950921+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:43:05.950921+00:00: cases_v2 prefix roots decided 277 / remaining 1298 / unknown 1298 (1575 roots over c=1..15).

2026-10-26T07:43:44.265403+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:43:44.265403+00:00: cases_v2 prefix roots decided 286 / remaining 1289 / unknown 1289 (1575 roots over c=1..15).

2026-10-26T07:49:14.334381+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:49:14.334381+00:00: cases_v2 prefix roots decided 310 / remaining 1265 / unknown 1265 (1575 roots over c=1..15).

2026-10-26T07:57:56.063200+00:00: cases prefix roots decided 0 / remaining 1575 / unknown 1575 (1575 roots over c=1..15).

2026-10-26T07:57:56.063200+00:00: cases_v2 prefix roots decided 310 / remaining 1265 / unknown 1265 (1575 roots over c=1..15).

2026-10-26T07:59:34.435898+00:00: completed-peer cross-check cases decided 0 / remaining 0 / unknown 0; available peer cases 0. Absent peer decisions remain an external limit.

2026-10-26T08:05:36.780801+00:00: completed-peer cross-check cases decided 0 / remaining 3280 / unknown 3280; available peer records 0. Absent peer decisions remain an external limit.

2026-10-26T08:06:32.244530+00:00: completed-peer cross-check cases decided 0 / remaining 3280 / unknown 3280; available peer records 0. Absent peer decisions remain an external limit.
