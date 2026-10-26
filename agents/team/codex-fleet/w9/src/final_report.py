"""Generate the report from saved records. Never infer missing counters."""
import collections,json,re
from pathlib import Path
def record(name):return json.loads(Path('artifacts/'+name+'.json').read_text())
ledger=record('strict_pass_ledger')
text='''No strict PASS with core k <= 31 was found. The best verified core remains k=32.

## Purpose

Find an eight-comparison sort5 with at most 23 data instructions. A data instruction is mov or a conditional move. The target core length is 31. The target memory length is 41.

## Terms

A value column gives one register value for each tested order. A comparison tree fixes the input-order partitions after comparisons. A merge interleaving describes the order between two sorted groups. SAT is Boolean satisfiability. UNSAT means that the solver found no assignment for the stated constraints. A time limit means UNKNOWN.

## Method

Read the w6 results and the earlier w1 and w4 merge results. The new searches did not repeat their fixed-operand routing searches. All project writes stayed in w9. Search, compiler, and judge commands used nice level 10. The combined CPU affinity used at most CPUs 84 through 91. No agents were started.

The family scan read 167 distinct eight-comparison programs from w6 verified folders. It evaluated all 541 weak orders with one concrete scratch state. This scan describes structure. It does not replace strict verification of the source collection.

At the fifth comparison, 126 programs retain a sorted pair and a sorted triple. The other 41 have started to combine pieces earlier. Prefix lengths are 15 for 63 programs, 16 for 98 programs, and 17 for six programs. All 63 length-15 prefixes retain one register for each sorted value. Their suffix costs 17. Of the length-16 prefixes, 58 retain both sorted pieces and 40 combine pieces earlier. See [family_analysis.json](artifacts/family_analysis.json).

The normalized control sorts a pair in four instructions and a triple in eleven instructions. Its merge costs 17 instructions: four comparisons, twelve conditional moves, and one mov. The extra mov saves the pair maximum.

Write the sorted pair as x <= y and the sorted triple as a <= b <= c. The first merge comparison outputs min(a,x) and retains u=max(a,x). The second comparison tests y against c. It outputs max(y,c). It also needs T, equal to y when y <= c and equal to u when y > c. Later comparisons use T. A saved y lets one conditional move make T. Constructing T in an unrelated register takes two conditional moves in this implementation. This explains its copy cost. It does not establish a bound for every merge.

The searches use the copied bit-plane evaluator in src/bitplanes.cpp. Value 7 means conservatively unknown scratch data. This representation can reject some valid programs. Zero-error proposals require the full-case check before retention. Every retained sorting control also requires the strict judge.

| Stochastic group | Runs | Score cases | Entry state | Target suffix | Registers | Temperatures |
|---|---:|---:|---|---|---|---|
| Sorted pieces | 3 | 10 strict interleavings | Five sorted values | 16; four cmp | 7, 8, 7 | 0.18, 0.35, 0.7 |
| Prefix leftovers | 3 | 120 strict orders | Actual 15-instruction prefix | 16; four cmp | 8, 9, 8 | 0.45, 0.8, 1.5 |
| Early minimum | 2 | 120 strict orders | Actual 16-instruction prefix; output 0 available | 15; four cmp | 10, 9 | 0.4, 0.9 |

The first group checks all 76 sorted weak interleavings before retaining a zero-error state. The other groups check all 541 weak orders. These eight runs stopped when work moved to exact repair. They did not write final counters. Their total iteration counts and CPU times are unavailable. No exclusion follows from these interrupted runs. Logs: logs/m16[a-c].log, logs/residual_[a-c].log, and logs/integrated_[a-b].log.

Two later searches score all 541 weak orders. They start from the new 12-order failure. They retain the original first 15 or first 12 instructions. The second search can change the final triple comparison and the partner selection together. Each has a 60-CPU-second limit and a 120-second wall limit.

'''
lines=[text]
for tag in ['weak12','weak_prefix12']:
    m=re.search(r'SUMMARY iterations=(\d+) accepted=(\d+) strict_zeros=(\d+) best_errors=(\d+) restarts=(\d+) cpu=([\d.]+) cases=(\d+)',Path('logs/'+tag+'.log').read_text())
    assert m,tag
    lines.append(f'- {tag}: {int(m[1]):,} proposals; {int(m[2]):,} accepted; {m[3]} zero-error proposals; best error sum {m[4]}; {m[6]} CPU seconds.')
lines+=['','The first weak_prefix12 launch preceded compiler completion and did not execute. The corrected launch produced the final counters above.','',
'The constraint merge search permits free comparison operands, branch-specific polarity, and arbitrary less/equal/greater padding on finished branches. Thus its trees fix partitions rather than operand identities. Queries use ten strict interleavings. The first instruction is the tree root. Comparisons must read input-derived values. Outputs can select any write snapshot.','']
for name in ['trees_a','trees_b','shapes39','tree39_glucose','debug']:
    j=record(name);cnt=collections.Counter(r['status'] for r in j['results']);cpu=sum(r['cpu'] for r in j['results'])
    lines.append(f'- {name}: {len(j["results"])} recorded queries; {dict(cnt)}; {cpu:.3f} CPU seconds.')
lines+=['',
'The broad batches stopped after eight trees each. They did not complete the planned 104 trees. The fixed-placement batch stopped after 41 of its planned 80 placements. The two-second debug query overlaps tree 0. The pinned 17-instruction positive control returned SAT and matches tree 39. See artifacts/sat_control.json. These timed queries give no global exclusion.','',
'The exact repair scan tests every one- and two-instruction replacement in the new 31-instruction failure. Its alphabet contains 441 instructions over nine registers. It includes same-register cmp, every distinct-register mov, and all four permitted conditional moves. The scan completed 13,671 single replacements and 90,433,665 double replacements. None passed the 64-case necessary filter. Counts include unchanged instructions. The total is 90,447,336 edit sequences. Log: [repair12.log](logs/repair12.log).','',
'The failure suggests another copy location. If the merge receives a duplicate triple minimum, its sixteen instructions sort all 76 sorted weak interleavings. A 12-instruction triple prefix supplies that duplicate. Complete sort5 controls passed both strict judges at k=32. An 11-instruction prefix with the same entry values would give k=31.','',
'The triple-prefix encoder requires two distinct physical minimum registers, one median register, and one maximum register at the end. It encodes all thirteen weak orders of three inputs. It requires exactly three comparisons. The first instruction is cmp P0,P1. Comparisons cannot read the initial scratch sentinel. These restrictions define the scope of the results below.','',
'| Query | Registers | Length | Fixed pair prefix | Result | Seconds |',
'|---|---:|---:|---|---|---:|']
for name in ['triple_min11','triple_min11_R4','triple_min11_pairfirst','triple_min11_pair_shapes','triple_min11_pair_R6','triple_min11_pair_R8','triple_min11_full_shapes','triple_min11_R5_shapes','triple_min12_control']:
    j=record(name);a=j['args'];lines.append(f'| [{name}](artifacts/{name}.json) | {a["registers"]} | {a["k"]} | {bool(a.get("pairfirst"))} | {j["status"]} | {j["seconds"]:.3f} |')
lines+=['',
'The fixed pair prefix is cmp P0,P1; mov S0,P0; cmovg P0,P1; cmovg P1,S0. The completed shape searches cover all 21 placements of the remaining comparisons after this prefix. The R=8 query returned UNSAT. This excludes only that eleven-instruction query with the stated prefix, register bound, and operand restrictions. It does not exclude other preparations. The broader shape queries reached their wall limits. Their per-placement records remain in the linked JSON files. The twelve-instruction positive control returned SAT. Its complete sort5 program passed both strict judges.','',
'## Result','',
'No k <= 31 candidate passed the strict judge. Four control implementations have core length 32 and memory length 42. Three use 8 cmp + 20 cmov + 4 mov. The duplicate-triple-minimum control uses 8 cmp + 21 cmov + 3 mov.','',
'The best new eight-comparison failure has k=31 and fails 12/541 weak orders. Four failures have distinct inputs. Eight have ties. Only output 1 fails in the retained snapshots. The strict judge reports FAIL. File: [residual_b_near31_out.s](candidates/residual_b_near31_out.s). Log: [strict judge](logs/residual_b_near31_judge.log).','',
'Let x0 through x4 name the original inputs. The independent evaluator matched this failure condition on all 541 weak orders: min(x0,x1) < x2 < min(x3,x4), and max(x0,x1) >= max(x3,x4). This is a finite test result. In those cases, the merge loses the triple minimum before constructing output 1. See [near12_condition.json](artifacts/near12_condition.json).','',
'The final audit tested every control and every retained copy with shared/judge.py --strict. All sixteen files passed. The ledger records hashes, instruction counts, models, and exact logs: [strict_pass_ledger.json](artifacts/strict_pass_ledger.json). Every PASS file path follows.','',
'| PASS file | Model | Length | Judge log |','|---|---|---:|---|']
for row in ledger:
    relative=Path(row['path']).relative_to(Path.cwd());lines.append(f'| [{relative}]({relative}) | {row["model"]} | {row["length"]} | [{Path(row["log"]).name}]({row["log"]}) |')
lines+=['','## Limits','',
'No global lower bound is claimed. Stochastic failures give no exclusion. Interrupted runs have no inferred counters. The completed repair concerns only its stated edit neighborhood. Prefix exclusions concern only their stated constraints. UNKNOWN is not UNSAT. The 42-instruction controls do not meet the requested 41-instruction memory length.']
Path('RESULTS.md').write_text('\n'.join(lines)+'\n')
print(json.dumps({'PASS_files':len(ledger),'best_verified_core':32,'best_new_failing_weak_orders':12}),flush=True)
