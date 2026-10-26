import re,pathlib,json,hashlib
base=pathlib.Path(__file__).resolve().parent
root=base.parent
def stats(name):
 s=(base/name).read_text();m=re.search(r'COMPLETE c=(\d+) begin=(\d+) end=(\d+) leaves=(\d+) functional=(\d+) seconds=([\d.]+)',s)
 assert m and int(m[3])==14904,name
 return {'c':int(m[1]),'leaves':int(m[4]),'functional':int(m[5]),'seconds':float(m[6]),'nodes':int(re.search(r'node_total=(\d+)',s)[1]) if 'node_total=' in s else sum(int(x) for x in re.findall(r'depth=\d+ nodes=(\d+)',s))}
rows={name:stats(name) for name in ('omit7.log','omit8.log','extend1.log','extend2.log','extend7.log')}
assert rows['extend7.log']['functional']==0
assert all(rows[n]['functional']==198 for n in ('omit8.log','extend1.log','extend2.log'))
assert 'tests=46724' in (base/'extra_fast.log').read_text() and 'subset_candidates=0' in (base/'extra_fast.log').read_text()
for name in ('judge33_out.log','judge33_mem.log'):assert (base/name).read_text().startswith('PASS ')
header='\n# Round 2: purpose\n'
s=header+'''
Extend copy reuse to six, seven, and eight comparisons. Permit partial comparator
outputs, copies from any earlier value, and mixed conditional-move/copy counts.
No program with `k <= 31` was found.

# Round 2: method

Used the round 1 diagrams as dataflow templates. Removed one or two comparison
instructions. At each removed comparison, independently selected both outputs
from its operands and the current flags. Then permitted one or both outputs to
select from any earlier value. Old values stayed available until the allocation
search decided which copies to retain. A history-class size bound rejected
comparison sequences that could not distinguish all 120 input orders.
Six comparisons cannot distinguish 120 distinct input orders because `2^6=64`.

For each functional eight-comparison plan, searched min-side, max-side, and
arbitrary-register reuse. Searched all four I1 conditions and every order of
conditional moves in each comparison block. An independent implementation used
tuples of register values and threshold sets. See [round2/METHODS.md](round2/METHODS.md)
for the exact family, counting argument, copy normalization, and limits.

All round 2 CPU jobs ran with `nice -n 19`. At most two CPU jobs ran at once.
All programs were single-threaded. No round 1 search or excluded full `dagx`
comparison-structure search was repeated.

# Round 2: result

The completed semantic searches have these counts. A node is one visited partial
plan. A leaf has enough comparison histories to distinguish the input orders.
A functional plan also produces all five sorted value columns.

| Search | Comparisons | Nodes | Leaves | Functional plans | Recorded seconds |
| --- | ---: | ---: | ---: | ---: | ---: |
'''
labels={'omit7.log':'Local partial outputs','omit8.log':'Local partial outputs','extend1.log':'One unrestricted output per removed stage','extend2.log':'Both outputs unrestricted per removed stage','extend7.log':'One unrestricted output per removed stage'}
for name,d in rows.items():s+=f"| {labels[name]} | {d['c']} | {d['nodes']:,} | {d['leaves']:,} | {d['functional']:,} | {d['seconds']:.3f} |\n"
s+='''
The generalized seven-comparison run completed templates `[0,13900)` before
it was interrupted at its recorded boundary. Two suffix jobs completed
`[13900,14402)` and `[14402,14904)`. The combined log records their exact
coverage. Its node count includes only the completed ranges. Its recorded
seconds are the sum of segment wall times; the suffix jobs overlapped.
Unreported partial work at interruption is excluded from those counts.

The three eight-comparison searches found the same 198 plans. Independent scalar
simulation checked every plan on all 541 weak orders. The broader selections
produced exactly the same strict-order and weak-order value columns as the local
plans. The plans form 33 exact comparison-structure classes. Their complete
comparison and unordered target-block signatures also agree within each class,
after input renaming and value reversal. None matches the 18 immutable w6
comparison structures checked in `prepare.py`.

Every plan contains eighteen distinct non-input value columns. The exhaustive
fixed-column allocation search found these minimum costs:

| Copies | Conditional moves | Comparisons | Core k | Plans |
| ---: | ---: | ---: | ---: | ---: |
| 7 | 18 | 8 | 33 | 18 |
| 8 | 18 | 8 | 34 | 108 |
| 9 | 18 | 8 | 35 | 72 |

Thus this eight-comparison family has no four-copy or five-copy plan. The C++
and independent Python allocation searches both retained **27,048** comparison
boundary states at the five-copy bound. Both rejected all 198 plans. The C++
search over all 541 weak orders and its distinct-order relaxation gave the same
negative result. Earlier unpruned runs are retained. The final cost bound reserves
one instruction for each remaining distinct target column.

A further exhaustive extension added one new full selected value to any
comparison block. It checked **46,724** distinct block/value cases across all
33 representatives. It generated **2,593,446** allocation boundary states.
No case had `k <= 31`. This tests **8 cmp + 19 conditional moves + at most 4 mov**.
The run took 24.369 seconds. Sources: `round2/extra.cpp` and `round2/route.cpp`.
Log: [round2/extra_fast.log](round2/extra_fast.log). An initial unpruned attempt
was stopped before it completed one class; its empty log is retained.

The smallest emitted example uses **8 cmp + 18 conditional moves + 7 mov**.
It passed both strict judges:

```text
'''
s+=(base/'judge33_out.log').read_text()+(base/'judge33_mem.log').read_text()+'''```

Every new strict PASS file is listed here:

- [round2/witness_out.s](round2/witness_out.s): `k=33`.
- [round2/witness_mem.s](round2/witness_mem.s): `L=43`.

The independent scalar audit also checked all 541 weak orders, all four initial
flag states, and initialization of every scratch read. Its log is
[round2/audit33.log](round2/audit33.log). The earlier 34-instruction witness was
replaced with this smaller witness. Its earlier judge log remains historical.

Reproduce round 2 with `nice -n 19 python3 round2/reproduce.py` from this folder.
The script runs CPU jobs sequentially. The complete semantic search logs are
`round2/omit7.log`, `round2/omit8.log`, `round2/extend1.log`,
`round2/extend2.log`, and `round2/extend7.log`. The final allocation logs are
`round2/route_fast23.log` and `round2/route_fast27.log`. Independent checks are
`round2/crossroute.log`, `round2/exact_check.log`,
`round2/compare_extensions.log`, and `round2/check_class_targets.log`.

# Round 2: limits

These results concern the defined dataflow and fixed-column families. They are
search results, not a general lower bound or a formal certificate. The searches
do not cover every program with seven or eight comparisons. In particular, the
seven-comparison search permits one unrestricted output at each of its two
removed stages. It does not exhaust the case where both outputs at both removed
stages are unrestricted. Its semantic selections use greater-than flags and
their complement; it does not vary all I1 conditions when copied identities
compare equal. The additional-value search permits one extra full
selected value. It does not exhaust two extra values, unknown intermediate
scratch values, new comparison operands, or arbitrary intermediate columns.
The verified 43-instruction memory program does not beat AlphaDev's 42.
'''
p=root/'RESULTS.md';old=p.read_text();assert header not in old;p.write_text(old+s)
(base/'summary.json').write_text(json.dumps(rows,indent=2)+'\n')
manifest={str(f.relative_to(base)):hashlib.sha256(f.read_bytes()).hexdigest() for f in base.iterdir() if f.suffix in ('.cpp','.py','.s') and f.name!='finalize.py'}
(base/'sha256.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Appended round 2 results. No FOUND line: no k<=31 candidate exists in these completed searches.')
