"""Append the completed, audited round to RESULTS.md once."""
import json
from collections import Counter
from pathlib import Path

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
s=json.loads((HERE/'summary.json').read_text())
assert s['status'].startswith('COMPLETE')
marker='# Round 6: failing-value classification and exhaustive insertions'
old=(WORK/'RESULTS.md').read_text()
assert marker not in old,'Round already appended'
lines=['', '', marker, '',
'No program with `k <= 31` was found. All four finite edit searches completed.',
'The completed negative results test **A11**, local repair near specified failing',
'cores. They use the I1 rules in G1 through G4. They do not establish a general',
'lower bound. No assumption was contradicted.', '',
'The inputs are the 15 w6 round 6 representatives and',
'`w9/candidates/residual_b_near31_out.s`. Their paths, hashes, exact instructions,',
'and register names are in [round6/manifest.json](round6/manifest.json).',
'Earlier replacement searches and fixed-value routing searches were not repeated.', '',
'# Round 6: failed weak orders', '',
'All 15 w6 representatives have the same failure condition after input renaming.',
'One specified input is the unique median. A specified pair lies strictly below',
'it. The other pair lies strictly above it. Each pair permits internal ties.',
'This gives four failures with distinct inputs and five failures with ties.',
'Only output 2 fails. The core loses its last register copy of the required',
'median immediately after counted instruction 24 or 25.', '',
'For base b00, the exact condition is `x0 < x1 < x2` and `x3 < x1 < x4`.',
'Here `xi` means original input Pi. All values of each condition were checked',
'against all 541 weak orders. The per-base conditions follow.', '',
'| Base | Median input | Inputs below median | Inputs above median | First loss after instruction |',
'| --- | --- | --- | --- | ---: |']
for row in s['classification'][:15]:
    c=row['condition']
    low=', '.join('x'+str(i) for i in c['low'])
    high=', '.join('x'+str(i) for i in c['high'])
    loss=', '.join(row['loss_times'])
    lines.append(f'| {row["base"]} | x{c["pivot"]} | {low} | {high} | {loss} |')
lines += ['',
'The w9 core fails exactly when',
'`min(x0,x1) < x2 < min(x3,x4)` and',
'`max(x0,x1) >= max(x3,x4)`. Four failures have distinct inputs. Eight have ties.',
'Only output 1 fails. The core loses its last copy of x2 after instruction 23.',
'The independent audit reproduced this earlier w9 classification.', '',
'Every failed case, incorrect output, required value, last copy, and available',
'earlier occurrence is recorded in [round6/analysis.json](round6/analysis.json).',
'The audit checked that the original cores do not compare or output initial',
'scratch data on any weak order. Each conditional move follows a comparison.',
'Thus the classification does not depend on the concrete scratch values or',
'initial flags used by the search.', '',
'# Round 6: exhaustive edit results', '',
'Each inserted instruction permits all six I1 opcodes and all ordered operand',
'pairs, including equal operands. Operands use every base register plus one',
'fresh register. Eleven bases have seven named registers. Five have eight.',
'Fixed-output searches preserve the original output instructions. Free-output',
'searches choose each output register and time independently, with the same',
'choice required across all 541 cases. Retained core instructions stay fixed.', '',
'| Edit | Output choices | Bases | Insertion slots | Raw edits | Relaxed survivors |',
'| --- | --- | ---: | ---: | ---: | ---: |']
for mode in ['fixed','free','relocate_fixed','relocate_free']:
    row=s['searches'][mode]
    kind='Delete one, insert one; k=31' if 'relocate' in mode else 'Insert one; k=32'
    output='Any register and time' if 'free' in mode else 'Original outputs'
    lines.append(f'| {kind} | {output} | 16 | {row["slots"]:,} | {row["raw"]:,} | {row["survivors"]:,} |')
lines += ['',
'An insertion slot is one insertion gap, with a selected deletion where required.',
'Raw edit counts include equivalent and unchanged effects. The two output modes',
'can describe the same core more than once. Counts are edit sequences, not',
'distinct algorithms. Every search completed without truncation or timeout.', '',
'The primary insertion scans found 374 fixed-output repairs and 356 free-output',
'repairs in the concrete relaxation. They include a repair for every base.',
'Every one of these **730 emitted cores passed the shared strict out-model',
'judge at k=32**. The first repair for each base in each mode also passed the',
'strict memory-model judge: **32 memory files, each with length 42**.', '',
'The successful insertions use mov or a conditional move. None uses cmp.',
'None uses the fresh register. The repair therefore copies an existing value',
'within the original registers. A first w6 repair copies the required median',
'before the old core loses it. The w9 repairs copy P2 into S3 at a suitable',
'position or condition. The per-base repair pairs, insertion gaps, and effects',
'on comparison histories are in [round6/summary.json](round6/summary.json).', '',
'For ten w6 representatives, the first checked repair preserves every original',
'comparison outcome on all 541 weak orders. For the other five, it changes',
'comparison outcomes only on the nine failed orders. The first w9 repair changes',
'comparison outcomes only on its twelve failed orders. Thus ten representatives',
'can be repaired by preserving the median without changing the comparison paths.', '',
'The delete-one/insert-one scans tested **13,820,358** raw edits. They retained',
'no candidate, including with free output registers and times. Thus adding',
'one instruction repairs these failures at k=32, but removing another original',
'instruction cannot keep the repair at k=31 in this stated edit family.', '',
'# Round 6: verification and resources', '',
'The independent implementation directly executed every edited program.',
'It regenerated the weak orders in a different order. It matched every',
'surviving edit and every free-output occurrence mask in all four searches.',
'This is independent validation evidence, not a formal certificate.',
'See [round6/audit.log](round6/audit.log) and',
'[round6/METHODS.md](round6/METHODS.md) for the exact scope.', '',
'Each strict judge command used its default 20,000 random concrete tests,',
'in addition to the weak-order and symbolic checks. The command, output log,',
'file hash, and result for every emitted file are recorded in',
'[round6/pass_ledger.json](round6/pass_ledger.json).', '',
f'The largest recorded resident memory was {s["max_recorded_search_rss_kib"]:,} KiB.',
'All CPU jobs ran sequentially on CPU 68 under `nice -n 19`.',
'The search address-space limit was 2,800 MiB. Every job stayed below 3 GB.',
'Reproduction: `nice -n 19 python3 round6/reproduce.py`.',
'This round executed its commands individually. The complete reproduction',
'driver was syntax-checked and was not rerun as one command.', '',
'# Round 6: limits', '',
'The negative result retains the other original instruction operands and order.',
'It permits one new register. It does not cover arbitrary k=31 cores or',
'multiple inserted instructions with broader changes. No global lower bound',
'or new optimality proof is claimed. The shortest verified core remains k=32.', '',
'# Round 6: every strict PASS file', '',
'All register files below have k=32. All memory files have length 42.', '']
for row in s['passes']:
    p=Path(row['path']).relative_to(WORK)
    lines.append(f'- [{p}]({p}): {row["model"]}, {row["cost"]}.')
(WORK/'RESULTS.md').write_text(old+'\n'.join(lines)+'\n')
print('APPENDED',len(s['passes']),'PASS file paths')
