"""Record completed coverage. LIMIT never counts as a negative test."""
import collections
import hashlib
import json
from pathlib import Path
import re
import sys

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
manifest=json.loads((HERE/'manifest.json').read_text())
for row in manifest:
    assert hashlib.sha256(Path(row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']

def records(path):
    return [dict(re.findall(r'(\w+)=([^\s]+)',line))
            for line in path.read_text().splitlines() if line.startswith('RESULT ')]

def resource(path):
    if not path.exists(): return {}
    text=path.read_text()
    out={}
    for key,label in [('user','User time (seconds)'),('system','System time (seconds)'),
                      ('peak_rss_kib','Maximum resident set size (kbytes)')]:
        match=re.search(re.escape(label)+r':\s*([\d.]+)',text)
        if match: out[key]=float(match[1])
    return out

summary={'bases':len(manifest),'c8':144,'c9':26,'direct':{},'reuse':{},'passes':[]}
for mode,slots in [('fixed',17856),('free',15376)]:
    rows=records(HERE/f'{mode}.log')
    assert len(rows)==170
    assert [int(r['index']) for r in rows]==list(range(170))
    assert all(r['status']=='NONE' and int(r['slots'])==slots for r in rows)
    groups={}
    for family,subset in [('c8',rows[:144]),('c9',rows[144:]),('all',rows)]:
        totals={key:sum(int(r[key]) for r in subset)
                for key in ['slots','raw','sims','steps','case_slots','survivors']}
        totals['cpu']=sum(float(r['cpu']) for r in subset)
        groups[family]=totals
    summary['direct'][mode]={'groups':groups,'resources':resource(HERE/f'{mode}.resources')}

for log in sorted(HERE.glob('reuse_*.log')):
    if log.name in ('reuse_build.log','reuse_control.log','reuse_copy_control.log'): continue
    rows=records(log)
    if not rows: continue
    counts=dict(collections.Counter(r['status'] for r in rows))
    coverage=collections.defaultdict(list)
    for row in rows: coverage[row['name']].append(int(row['test']))
    summary['reuse'][log.stem]={
        'tests':len(rows),'status':counts,'cpu':sum(float(r['cpu']) for r in rows),
        'kept':sum(int(r['kept']) for r in rows),
        'coverage':dict(coverage),'resources':resource(log.with_suffix('.resources'))}

reuse_manifest=json.loads((HERE/'reuse_manifest.json').read_text())
summary['reuse_families']={}
for hold_stem in ['reuse_copy_hold','reuse_copy_free_hold']:
    hold_path=HERE/f'{hold_stem}.log'
    if not hold_path.exists(): continue
    hold=records(hold_path)
    resolved=[]
    if hold_stem=='reuse_copy_free_hold':
        ledger=HERE/'resolve_runs.json'
        resolved=[row for item in json.loads(ledger.read_text())
                  for row in records(HERE/f"{item['stem']}.log")] if ledger.exists() else []
        effective={(int(row['index']),int(row['test'])):row for row in hold}
        for row in resolved:
            key=(int(row['index']),int(row['test']))
            assert key in effective
            effective[key]=row
        hold=sorted(effective.values(),key=lambda row:(int(row['index']),int(row['test'])))
    coverage=collections.defaultdict(list)
    for row in hold: coverage[int(row['index'])].append(int(row['test']))
    complete=all(coverage[i]==list(range(row['copy_tests'])) for i,row in enumerate(reuse_manifest))
    summary['reuse_families'][hold_stem]={
        'expected_tests':sum(row['copy_tests'] for row in reuse_manifest),
        'recorded_tests':len(hold),'complete_coverage':complete,
        'all_negative':complete and all(row['status']=='NONE' for row in hold),
        'c8_expected':sum(row['copy_tests'] for row in reuse_manifest[:144]),
        'c9_expected':sum(row['copy_tests'] for row in reuse_manifest[144:]),
        'resolution_tests':len(resolved),
        'status':dict(collections.Counter(row['status'] for row in hold))}
pred_paths=[HERE/'reuse_pred_pilot.log',HERE/'reuse_pred_suffix.log']
if all(path.exists() for path in pred_paths):
    rows=[row for path in pred_paths for row in records(path)]
    complete=all(int(row['index'])==144 for row in rows) and [int(row['test']) for row in rows]==list(range(506))
    summary['reuse_families']['predicate_one_base']={
        'expected_tests':506,'recorded_tests':len(rows),'complete_coverage':complete,
        'all_negative':complete and all(row['status']=='NONE' for row in rows),
        'status':dict(collections.Counter(row['status'] for row in rows))}

for log in sorted(HERE.glob('*judge*.log')):
    for line in log.read_text().splitlines():
        if not line.startswith('PASS '): continue
        path=Path(line.split()[1])
        if not path.is_absolute(): path=WORK/path
        match=re.search(r' L=(\d+).* model=(\w+)',line)
        assert match
        summary['passes'].append({'path':str(path.relative_to(WORK)),
            'length':int(match[1]),'model':match[2],
            'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
            'judge_log':str(log.relative_to(WORK)),'judge_output':line})

summary['source_sha256']={str(p.relative_to(WORK)):hashlib.sha256(p.read_bytes()).hexdigest()
    for p in [HERE/'edit.cpp',HERE/'reuse.cpp',WORK/'round3/reuse.cpp',
              HERE/'prepare.py',HERE/'crosscheck.py',HERE/'manifest.json',
              HERE/'bases.txt',HERE/'problems.txt',HERE/'cases.txt',HERE/'runs.json']}
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='source_sha256'},indent=2))

if '--append' in sys.argv:
    direct=summary['direct']
    table=[]
    for mode,label in [('fixed','Original outputs'),('free','Any output register and time')]:
        for family,label2 in [('c8','144 c=8 bases'),('c9','26 c=9 bases')]:
            row=direct[mode]['groups'][family]
            table.append(f"| {label} | {label2} | {row['slots']:,} | {row['raw']:,} | {row['sims']:,} | {row['cpu']:.3f} |")
    reuse=[]
    for name,row in summary['reuse'].items():
        reuse.append(f"- `{name}`: {row['tests']:,} completed test records; "
                     +', '.join(f'{k} {v:,}' for k,v in sorted(row['status'].items()))
                     +f"; recorded CPU {row['cpu']:.3f} seconds.")
    family_notes=[]
    for name,row in summary['reuse_families'].items():
        family_notes.append(f"- `{name}`: expected {row['expected_tests']:,} tests; "
            +f"recorded {row['recorded_tests']:,}; "
            +('coverage complete; ' if row['complete_coverage'] else 'coverage partial; ')
            +('result NONE.' if row['all_negative'] else 'family result unknown.'))
    passes=[]
    for row in summary['passes']:
        passes.append(f"- [{row['path']}]({row['path']}): "
                      +('`k=' if row['model']=='out' else '`L=')
                      +f"{row['length']}`, {row['model']}.")
    peaks=[x['resources'].get('peak_rss_kib',0) for x in direct.values()]
    peaks += [x['resources'].get('peak_rss_kib',0) for x in summary['reuse'].values()]
    report='''

# Round 4: purpose and method

Test delete-two/insert-one changes to all 144 eight-comparison cores and all
26 nine-comparison cores in `d7-structure/fam32`. No core with `k <= 31`
was found. The first 143 c=8 bases are the earlier w6 variants. The additional
base is `../w6/candidates/c8c_len32_c29288.s`.

The direct search deletes every pair of core instructions. It inserts every
permitted opcode with every source and destination from the base register set
plus one fresh register. It keeps the other instruction operands and order.
The free-output run permits every output register and time. The search uses
all 541 weak orders with scratch values fixed above the inputs and equal
initial flags. This is a concrete relaxation of strict correctness.

See [round4/METHODS.md](round4/METHODS.md) for the exact family, action sharing,
output intersection, global reuse extension, and limits. The input ledger is
[round4/manifest.json](round4/manifest.json). No excluded enumeration, dagx,
or Hamming-three search was repeated.

# Round 4: exhaustive direct edit results

Every row completed with NONE. There was no timeout or truncation. A slot is
one deletion pair and insertion gap. Raw edits count all six opcodes and all
ordered register pairs, including self operands. Equivalent concrete effects
share a suffix simulation within one input case.

| Output choices | Bases | Slots | Raw edits | Suffix simulations | CPU seconds |
| --- | --- | ---: | ---: | ---: | ---: |
'''+ '\n'.join(table)+'''

Both runs cover all 496 deletion pairs for every base. The fixed-output run
has 36 gaps per pair. The free-output run has 31 gaps per pair. The logs are
[round4/fixed.log](round4/fixed.log) and [round4/free.log](round4/free.log).
These completed negatives apply to this edit family, not to all programs.

# Round 4: global register reuse

The additional driver deletes one write and makes another write unrestricted.
It can change the opcode, source, and destination of every retained write.
It retains the other masked creation targets. Creation-only modes permit outputs
past their base deadlines. Hold mode retains the other boundary requirements.
One mode also frees every comparison outcome. The other retains
the base required comparison predicates with freely chosen register operands.

'''+ '\n'.join(reuse)+ '\n\n'+ '\n'.join(family_notes)+'''

A NONE record exhausts that finite abstract test. A LIMIT record is unknown.
A completed retry can resolve that test. A family with missing tests or
unresolved LIMIT records is unknown. The summary ledger
records the exact completed test indices. These runs do not establish a global
copy-count minimum. The global driver uses the round 3 unknown-value abstraction
and can reject programs that depend on scratch correlations.

# Round 4: verification and resources

The independent scalar implementation matched 908 candidate-mask hashes.
It directly simulated 186,186 edited programs across 372 insertion slots.
The checks cover 12 deletion pairs from seven bases. Its log is
[round4/crosscheck.log](round4/crosscheck.log). This is validation evidence,
not a formal certificate. The independent check does not cover all edit slots.

The positive control adds one unused copy to a correct 32-instruction core.
Both direct output modes restore a 32-instruction core after two deletions and
one insertion. The following files received strict PASS from the shared judge:

'''+ '\n'.join(passes)+f'''

All CPU jobs ran sequentially under `nice -n 19` on CPU 68. Each search had
a 2,800 MiB virtual-memory limit. The largest recorded search resident memory
was {int(max(peaks)):,} KiB. The strict judge outputs, source hashes, resource
records, and coverage counts are indexed in
[round4/summary.json](round4/summary.json).

The smallest verified core remains 32 instructions. Its memory form has 42
instructions. No four-move improvement or general lower bound was obtained.

The reproduction driver is `nice -n 19 python3 round4/reproduce.py`.
This round ran the commands individually. The full driver was syntax-checked
but was not run as one command.
'''
    with (WORK/'RESULTS.md').open('a') as f: f.write(report)
