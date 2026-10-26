"""Collect exact search counts and strict judge records; append round 3."""
import collections
import hashlib
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
WORK = HERE.parent
JOBS = [
    ('Required values retained', 'masked31.log', 143),
    ('One internal write omitted', 'drop31_final.log', 2717),
    ('Values required only at creation', 'loose31_exact.log', 143),
    ('Creation masks plus one write omitted', 'loose_drop31.log', 2717),
    ('One input value requirement waived', 'waive_input31.log', 715),
    ('Free comparisons and early outputs', 'freecmp_early31.log', 143),
    ('Each copy omitted; free comparisons and early outputs', 'copydrop_free31.log', 629),
]


def searches():
    rows = []
    for label, filename, expected in JOBS:
        records = []
        for line in (HERE / filename).read_text().splitlines():
            if not line.startswith('RESULT '):
                continue
            row = dict(word.split('=', 1) for word in line.split()[1:])
            records.append(row)
        statuses = dict(collections.Counter(r['status'] for r in records))
        result = {'label': label, 'log': f'round3/{filename}',
                  'expected': expected, 'completed': len(records),
                  'statuses': statuses}
        for field in ['generated', 'kept', 'write_candidates', 'cmp_candidates']:
            result[field] = sum(int(r[field]) for r in records)
        result['cpu'] = sum(float(r['cpu']) for r in records)
        result['peak_layer'] = max(int(r['peak']) for r in records)
        result['peak_columns'] = max(int(r['columns']) for r in records)
        rows.append(result)
    return rows


def judges():
    ledger = {}
    for log in sorted(HERE.glob('*judge*.log')):
        for line in log.read_text().splitlines():
            m = re.match(r'PASS (.*?) \[relaxed\+strict\] n=5 L=(\d+) R=(\d+) iset=I1 model=(\w+)', line)
            if not m:
                continue
            source = Path(m[1])
            if not source.is_absolute():
                source = WORK / source
            source = source.resolve()
            name = str(source.relative_to(WORK))
            ledger[name] = {'file': name, 'length': int(m[2]), 'model': m[4],
                            'sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
                            'judge_log': str(log.relative_to(WORK))}
    # Each file created by these searches is a candidate or a positive control.
    missing = [str(p.relative_to(WORK)) for p in HERE.glob('*.s')
               if str(p.relative_to(WORK)) not in ledger]
    assert not missing, f'Files lack strict PASS records: {missing}'
    return [ledger[key] for key in sorted(ledger)]


def main():
    jobs = searches()
    passes = judges()
    analysis = json.loads((HERE / 'analysis.json').read_text())
    classes = json.loads((HERE / 'predicate_classes.json').read_text())
    independent = json.loads((HERE / 'crosscheck.log').read_text().splitlines()[-1])
    resources = {}
    for path in HERE.glob('*.resources'):
        text = path.read_text()
        m = re.search(r'Maximum resident set size \(kbytes\): (\d+)', text)
        if m:
            resources[str(path.relative_to(WORK))] = int(m[1])
    inputs = []
    for row in analysis:
        path = Path(row['file'])
        inputs.append({'file': str(path), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
    summary = {'programs': len(analysis), 'searches': jobs, 'independent': independent,
               'strict_pass_files': passes, 'inputs': inputs,
               'max_recorded_search_rss_kb': max(resources.values()),
               'resource_logs': resources,
               'strict_predicate_classes': len(classes['strict']),
               'weak_predicate_classes': len(classes['weak'])}
    (HERE / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    (HERE / 'pass_ledger.json').write_text(json.dumps(passes, indent=2) + '\n')
    print('programs', len(analysis), 'strict PASS files', len(passes),
          'max recorded search RSS KiB', summary['max_recorded_search_rss_kb'])
    for row in jobs:
        print(row['label'], row['completed'], row['statuses'], 'states', row['kept'])
    if '--append' not in sys.argv:
        return
    assert all(j['completed'] == j['expected'] and j['statuses'] == {'NONE': j['expected']}
               for j in jobs), 'Incomplete or non-negative search: review results before appending'
    table = '\n'.join(f"| {j['label']} | {j['completed']:,} | {j['kept']:,} | {j['cpu']:.3f} |"
                      for j in jobs)
    pass_list = '\n'.join(f"- [{r['file']}]({r['file']}): "
                          + (f"`k={r['length']}`, out." if r['model'] == 'out'
                             else f"`L={r['length']}`, memory.") for r in passes)
    report = f'''# Round 3: purpose

Analyse the 143 new w6 eight-comparison programs. Test removal of a copy with
global register reuse and changes to the remaining conditional moves.
**No program with core `k <= 31` was found.**

The bases are `../w6/round2/verified/*.s`, not the 18 older representatives in
`../w6/verified`. No excluded network enumeration, fixed-operand dagx run, or
Hamming-three search was repeated.

# Round 3: terms and method

A value column records one register value for each of the 541 weak input orders.
A case mask identifies the input orders on which a value is required. The
search can share a register between values that agree on their required cases.
It can also retain partial copies with unknown entries outside those cases.

The search permits any source and destination register, mov or any I1
conditional-move condition at each retained write position, and fresh registers.
Its first modes preserve required comparison conditions rather than exact
operand values. The broader modes free every comparison operand and condition
outcome. They permit earlier outputs and later reconstruction of intermediate
values. They retain original event order and some base masked value targets.
See [round3/METHODS.md](round3/METHODS.md) for each search family and its limits.

# Round 3: common structure

All 143 bases have eight comparisons and 24 writes. Their mov counts range
from zero to five. The collection contains **397 mov copies** and **232
conditional copies**. For each of those conditional copies, the old destination
is never required on a case where the condition is false. These 629 positions
are the direct copy-removal targets. No base write is wholly unused.

Backward analysis found **2,131 writes** whose results are required on only
some input cases. The largest number of required value identifiers at one
boundary is six for 10 bases, seven for 99 bases, and eight for 34 bases.

Every base compares a value that cannot be expressed using only min and max
in **both comparison 7 and comparison 8**. In 115 bases these are the only such
comparisons. The other bases also have such a value in comparison 3 (four
bases), comparison 4 (15 bases), or comparison 5 (nine bases).

Before comparison 5, 102 bases hold a complete sorted pair and sorted triple
in their current registers. The other 41 bases do not. The prefix costs are
15 instructions for 54 bases, 16 for 87 bases, and 17 for two bases. A separate
test found no base that holds a complete sorted quartet plus its remaining
input before comparison 6. Thus that alternative description was rejected.

On 120 distinct input orders, the numbers of comparison histories are:

| After comparisons 1 through 8 | Bases |
| --- | ---: |
| 2, 4, 6, 12, 24, 48, 84, 120 | 26 |
| 2, 4, 8, 12, 24, 48, 84, 120 | 76 |
| 2, 4, 8, 16, 24, 48, 84, 120 | 41 |

Input renaming, value-order reversal, and comparison reversal give **72 exact
comparison-outcome classes** on distinct inputs. They give **141 classes** on
all weak input orders. Ties therefore distinguish many bases that agree on
distinct inputs. Full data is in [round3/analysis.json](round3/analysis.json)
and [round3/predicate_classes.json](round3/predicate_classes.json).

# Round 3: search results

Every row below completed with NONE for all listed tests at `k <= 31`.
No beam truncation, CPU limit, column limit, or state limit occurred in these
runs. A retained state is one register-column multiset and flag state at an
event boundary. The early-output modes also record completed outputs.

| Search | Tests | Retained boundary states | CPU seconds |
| --- | ---: | ---: | ---: |
{table}

Each base has 19 internal write positions, which gives 2,717 single-write
omission tests. The final row omits each of the **629 actual copies** in turn.
It frees all comparison operands, permits earlier outputs, and changes the
sources, destinations, and conditions of all remaining writes. It retains the
other base creation masks. It found no 31-instruction candidate.

The independent Python implementation checked all 143 bases. It omitted the
C++ future-full-column cost bound and retained **{independent['states']:,}**
boundary states. It also found no 31-instruction candidate. Its recorded CPU
time was {independent['cpu']:.3f} seconds. See
[round3/crosscheck.log](round3/crosscheck.log).

All CPU jobs ran one at a time with `nice -n 19` on CPU 68. The largest recorded
search resident memory was **{summary['max_recorded_search_rss_kb']:,} KiB**,
below the 3 GB job limit. Logs, input hashes, counters, and resource records are
indexed in [round3/summary.json](round3/summary.json).

# Round 3: verification

The router regenerated a **32-instruction control for every base**. All 143
controls passed the shared strict out-model judge. An added unused copy gave
a 33-instruction positive control. The broad copy-deletion search removed it
and emitted a strict-PASS 32-instruction control. A delayed-output control
also checked the earlier-output path. Its memory form passed at length 42.

The memory judge reports:

```text
{next(line for line in (HERE / 'control_mem42.judge.log').read_text().splitlines() if line.startswith('PASS '))}
```

Every new strict PASS file is listed below. The full ledger includes SHA-256
hashes and exact judge log paths: [round3/pass_ledger.json](round3/pass_ledger.json).
The 33-instruction padded control tests the search; it is not an improvement.

{pass_list}

# Round 3: limits and conclusion

These are completed finite abstract searches with fixed event positions and
specified masked value targets. They do not cover arbitrary intermediate
values, every comparison schedule, or outputs later than their base deadlines.
The unknown-value simulator can also reject programs that depend on correlations
between scratch values. No general lower bound or formal certificate is claimed.

The direct copy-removal tests found no improvement. The smallest verified core
remains **32 instructions**, with a **42-instruction** memory form. Run
`nice -n 19 python3 round3/reproduce.py` from this worker folder to reproduce
the completed searches and strict checks on one CPU.
'''
    path = WORK / 'RESULTS.md'
    old = path.read_text().split('\n# Round 3: purpose\n')[0].rstrip()
    path.write_text(old + '\n\n' + report)
    print('Appended Round 3 to RESULTS.md')


if __name__ == '__main__':
    main()
