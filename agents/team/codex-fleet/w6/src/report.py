"""Build the worker report from recorded results, without new search claims."""
from collections import Counter
import json
from pathlib import Path
import re


def counts(path):
    ops = Counter(line.split()[0] for line in Path(path).read_text().splitlines()
                  if line.strip() and not line.startswith(("#", "out")))
    return sum(ops.values()), ops["cmp"], ops["mov"], sum(v for k, v in ops.items() if k.startswith("cmov"))


audit = json.loads(Path("artifacts/all_judge_results.json").read_text())
verified = json.loads(Path("artifacts/verified_ledger.json").read_text())
base_rows = []
for name in "abcdef":
    path = Path(f"logs/c8{name}.log")
    text = path.read_text()
    m = re.search(r"collected=(\d+) done it=(\d+) acc=(\d+).*time=([\d.]+)s.*best=(\d+)", text)
    assert m, path
    base_rows.append((name, *map(int, m.group(1, 2, 3)), float(m[4]), int(m[5])))
packed_rows = []
for name in ("p31a", "p31b", "p31c", "p32a", "p32b", "p32c", "p32d"):
    text = Path(f"logs/{name}.log").read_text()
    m = re.search(r"SUMMARY iterations=(\d+) accepted=(\d+) correct_visits=(\d+) best=(\d+) best_error=(\d+) cpu=([\d.]+) samples=(\d+)", text)
    assert m, name
    packed_rows.append((name, *map(int, m.group(1, 2, 3, 4, 5)), float(m[6]), int(m[7])))
window_logs = {}
for name in ("window5_sat", "window5_template0", "window5_template2"):
    results = [json.loads(line) for line in Path(f"logs/{name}.log").read_text().splitlines() if line.startswith("{")]
    window_logs[name] = Counter(x["status"] for x in results)
    assert all(x["status"] != "CANDIDATE" for x in results), name
local_sum = 0
local_filtered = 0
for row in verified:
    text = Path(row["local3_log"]).read_text()
    m = re.search(r"RESULT NONE tried=(\d+) filtered=(\d+)", text)
    assert m, row["path"]
    local_sum += int(m[1])
    local_filtered += int(m[2])

report = [
    "No verified program with core k <= 31 was found.", "",
    "## Purpose", "",
    "Find a branchless sort5 with at most 31 register instructions in the AlphaDev model.", "",
    "## Terms", "",
    "Core k counts mov, cmp, and conditional moves. Free out instructions select output snapshots. The memory program adds five loads and five stores. A comparison structure is the ordered list of comparison operand columns over the 120 distinct-value input orders. The analyzer identifies input renaming, comparison reversal, and value-order reversal with 64-bit fingerprints. These fingerprints are search identifiers, not proof certificates.", "",
    "## Method", "",
    "Started from the supplied eight-comparison, 33-instruction program. Restricted the first searches to seven or eight comparisons. This avoids repeating the nine-comparison network searches in the brief. Used 33--35 slots to permit changes to conditional cycles.", "",
    "Copied the supplied simulator, MCMC search, and exact routing code into src/ before building them. Wrote an independent bit-plane simulator in src/local.cpp. Value 7 represents unknown scratch data in that simulator. Its conservative propagation can reject some valid programs. Thus its negative filters are search limits, not general exclusions.", "",
    "The independent packed search scores 120 permutations and 40 selected weak orders. These sets can overlap. It checks every zero-score proposal on all 541 weak orders before acceptance. src/packed.cpp also supports full-case deletion checks. The final authority for every retained result is shared/judge.py --strict.", "",
    "All search commands use nice -n 10. Search processes are single-threaded. No files outside this worker folder were changed. Seeds, slot counts, temperatures, and run limits are recorded in artifacts/search_parameters.json.", "",
    "## Result", "",
    "The best verified core has k=32. It uses **8 cmp + 20 conditional moves + 4 mov**. Its memory version has **42 instructions**. Both strict judges passed:", "",
    "- [Register program](artifacts/sort5_c8_k32_out.s), [judge log](logs/clean32_out_judge.log).",
    "- [Memory program](artifacts/sort5_c8_k32_mem.s), [judge log](logs/clean32_mem_judge.log).", "",
    "This gives an eight-comparison core at the AlphaDev length. It does not beat 42 instructions. The register program sorts a pair and a triple, retains a second copy of the pair maximum, then merges them with four comparisons and twelve conditional moves. The merge has no mov instruction. The extra maximum copy costs one mov before the merge.", "",
    f"The immutable verified folder contains **{len(verified)}** comparison-structure representatives. Each has k=32 and eight comparisons. All passed the strict out-model judge. The representatives include different mov/conditional-move counts. See the table below. The initial collection analysis found 12 fingerprints. The packed-sample analysis found 17 fingerprints among 4,396 saved states. Their union contains 18 fingerprints. Search samples under candidates/ are intermediate states. A sample is not a verified result unless it appears in the strict-judge ledger.", "",
    "| Immutable representative | k | cmp | mov | conditional moves |",
    "|---|---:|---:|---:|---:|",
]
for row in verified:
    k, c, m, cm = counts(row["path"])
    report.append(f"| [{Path(row['path']).name}]({row['path']}) | {k} | {c} | {m} | {cm} |")
report += ["", "### Search counts", "",
           "| Supplied MCMC run | Retained records | Iterations | Accepted | CPU seconds | Best k |",
           "|---|---:|---:|---:|---:|---:|"]
for name, retained, iters, accepted, seconds, best in base_rows:
    report.append(f"| c8{name} | {retained:,} | {iters:,} | {accepted:,} | {seconds:.1f} | {best} |")
report += ["", f"Total: {sum(x[1] for x in base_rows):,} retained records and {sum(x[2] for x in base_rows):,} iterations. Records can repeat across runs. Logs: logs/c8[a-f].log. Collections: candidates/c8[a-f]_coll.txt.", "",
           "| Independent packed run | Iterations | Accepted | Correct visits | Best k | CPU seconds |",
           "|---|---:|---:|---:|---:|---:|"]
for name, iters, accepted, visits, best, error, seconds, samples in packed_rows:
    report.append(f"| {name} | {iters:,} | {accepted:,} | {visits:,} | {best if best != 999 else 'none'} | {seconds:.1f} |")
report += ["", f"Total: {sum(x[1] for x in packed_rows):,} packed-search iterations. Iterations include proposals rejected before evaluation. Correct visits can repeat the same program.", "",
           "The best saved k=31 near miss fails 39 weak orders in the independent scorer. It is candidates/p31c_near.s. The strict judge rejects it; see logs/p31c_near_judge.log. This is not an improvement over the earlier 39-case near-miss count in the brief.", "",
           f"The 3-to-2 replacement checks on the immutable representatives enumerated {local_sum:,} sequences. {local_filtered} sequences passed the 32-case filter. None passed the full 541-case conservative check. The separate first-core check enumerated 8,748,000 sequences. The separate new-structure check enumerated 5,598,720 sequences. These two separate checks can overlap the representative checks.", "",
           "A repeat check saved the best of the ten subset-passing replacements. That k=31 program also fails 39 weak orders. It is candidates/local_near31_near.s. Its strict judge failure is logs/local_near31_judge.log. This does not improve the near-miss count.", "",
           "The first 4-to-3 check completed windows 0--23: 24 x 157,464,000 = 3,779,136,000 sequences. It stopped at the 900-second wall limit during the next window. The second 4-to-3 check completed windows 10--28: 1,531,809,792 sequences. Neither check found a replacement. Logs: logs/local4_31.log and logs/local4_13_31.log.", "",
           "### Routing and solver checks", "",
           "The routing search uses the copied dagx tool. It searches register reuse and conditional-move routing for a fixed comparison structure over 120 permutations. A node limit is incomplete. No formal certificate is provided.", "",
           "- Supplied position33 structure at K=31: 5,000,084 calls, LIMIT.",
           "- First new structure at K=31: 20,000,070 calls, LIMIT.",
           "- First twelve representatives at K=31: each reached its five-million-node limit. No solution was found.",
           "- New structure 15d47dd100cf7fcb at K=31: **NONE after 19,619,874 calls**. This run finished. Its scope is that fixed value structure only. Log: logs/c8_13_dag31.log.",
           "- Further structures: see artifacts/new_routing_summary.json. These runs also found no K=31 program within their node limits.", "",
           "src/window_sat.py replaces a five-instruction window with four instructions. It uses packed Z3 bit vectors and adds weak orders when a proposed output witness fails. The two template variants retain the remaining instruction classes and write destinations. Sources and conditional-move conditions remain free. Their results apply only to this encoding and these local constraints.", ""]
for name, statuses in window_logs.items():
    report.append(f"- {name}: " + ", ".join(f"{n} {status}" for status, n in sorted(statuses.items())) + ".")
report += ["", "The fixed 32-instruction positive control passed the solver and the strict judge. See logs/window_sat_control.log and logs/window_sat_control_judge.log.", "",
           "A small first-principles calculation found 15 strict extensions of the paired Ford-Johnson prefix and six balanced four-level decision trees. Another worker owns that direction. No extra Ford-Johnson program search was run here.", "",
           "## Limits", "",
           "No global lower bound is claimed. MCMC results are search observations. The local simulator uses conservative unknown values. A solver timeout is unknown. The completed routing exclusion concerns one fixed comparison structure. The 42-instruction programs do not meet the requested 41-instruction total.", "",
           "The immutable representatives and their SHA-256 hashes are recorded in artifacts/verified_ledger.json. The final strict-judge audit is recorded in artifacts/all_judge_results.json. The audit output is logs/final_judges.log.", "",
           "### Every final strict PASS file", ""]
for row in audit:
    if row["pass"]:
        report.append(f"- [{row['path']}]({row['path']}) ({row['model']}).")
assert all(row["pass"] for row in audit), "Audit has a failure; review it before publishing report"
Path("RESULTS.md").write_text("\n".join(report) + "\n")
print(json.dumps({"verified_structures": len(verified), "strict_PASS_files": len(audit),
                  "base_iterations": sum(x[2] for x in base_rows),
                  "packed_iterations": sum(x[1] for x in packed_rows),
                  "local3_sequences": local_sum}, indent=2))
