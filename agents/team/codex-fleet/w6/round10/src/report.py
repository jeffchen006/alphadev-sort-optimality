"""Append the completed round's checked counts and every strict PASS path."""
import collections
import hashlib
import json
from pathlib import Path
import re

art=Path('round10/artifacts')
audit=json.loads((art/'audit.json').read_text())
families=[]
for name in ['ledger','pilot_ledger','macro_ledger','singleton_ledger','invented_ledger','retry_ledger']:
    fn=art/(name+'.json')
    if not fn.exists():continue
    rows=json.loads(fn.read_text())
    families.append(dict(name=name,queries=len(rows),statuses=dict(collections.Counter(x['status'] for x in rows)),cpu_seconds=sum(x['cpu_seconds'] for x in rows),wall_seconds=sum(x['wall_seconds'] for x in rows)))

for manifest,ledger in [('diverse_manifest','singleton_ledger'),('invented_manifest','invented_ledger')]:
    if not (art/(manifest+'.json')).exists():continue
    planned=json.loads((art/(manifest+'.json')).read_text())
    rows=json.loads((art/(ledger+'.json')).read_text())
    assert {x['file'] for x in planned}<={x['file'] for x in rows},manifest

invent_gen=json.loads((art/'invention_generation.json').read_text()) if (art/'invention_generation.json').exists() else None
invent_run=json.loads((art/'invention_run.json').read_text()) if (art/'invention_run.json').exists() else None
summary=dict(audit=audit,families=families,invention_generation=invent_gen,invention_run=invent_run)
(art/'final_summary.json').write_text(json.dumps(summary,indent=2)+'\n')

lines=['','## Round 10 completion','']
target=[]
for row in audit['pass_paths']:
    text=Path(row['log']).read_text();m=re.search(r'n=(\d+) L=(\d+).*model=(\w+)',text)
    assert m,text
    n,k,model=int(m[1]),int(m[2]),m[3]
    if n==5 and ((model=='out' and k<=31) or (model=='mem' and k<=41)):target.append(row)
if not target:
    lines+=['No strict PASS with core k <= 31 was found. The best verified sort5 core remains k=32, or 42 memory instructions. The new strict PASS files are controls and larger source programs.','']
else:
    lines+=['A target strict PASS is recorded at the top of RESULTS.md and in the final audit.','']
lines+=['This round tests A4 and A6 with new fixed ten-comparison structures. The source collector also tests A1 within its five-wire conditional-swap grammar and stated stochastic budget. No result establishes a global lower bound. No listed assumption is contradicted.','',
        '| Routing batch | Query records | Completed NONE | UNKNOWN | CPU seconds |',
        '|---|---:|---:|---:|---:|']
for f in families:
    unk=sum(v for k,v in f['statuses'].items() if k.startswith('UNKNOWN') or k in ['LIMIT','ERROR','CANDIDATE_STRICT_FAIL'])
    lines.append(f'| {f["name"]} | {f["queries"]:,} | {f["statuses"].get("NONE",0):,} | {unk:,} | {f["cpu_seconds"]:.3f} |')
lines+=['',f'The audit records {audit["distinct_scopes"]:,} distinct attempted fixed scopes. Exactly {audit["distinct_exhaustive_none"]:,} completed with NONE. Exactly {audit["distinct_unresolved"]:,} remain unresolved. The completed NONE queries used {audit["completed_none_calls"]:,} recursive calls. A query has no node limit. Every timeout remains UNKNOWN. A NONE result concerns only its stated operand columns, comparison order, router representation, and 120 strict input orders. Registers and conditional-move values are not restricted to the source program.',
        '',f'The independent scalar executor matched {audit["comparison_value_checks"]:,} comparison values from {audit["source_programs"]} source programs. It used all 120 strict input orders and scratch initial values -2147483648, 0, and 2147483647. The scope audit checked {audit["scope_files_checked"]:,} generated files and {audit["repeat_operand_choices_checked"]:,} repeated-flag operand choices. It checked source-file hashes, insertion positions, unchanged original comparisons, and equivalent conditional-move masks. These are tested checks, not a proof of evaluator correctness.']
if invent_gen:
    log=Path('round10/logs/invention.log').read_text().strip()
    lines+=['','The additional collector sampled nine conditional swaps. The compared pair and swapped pair could differ. It retained operand-distinct comparison structures and required at least one differing pair. Its output snapshots map the singleton strict final permutation to ascending ranks. The strict judge tested every retained source before it was used as a correct source. A strict source PASS has k=36; it is not a target result.',
            '',f'Collector counters: `{log}`. The generation audit records {invent_gen["sources"]} source samples, judge statuses {invent_gen["strict_out"]}, {invent_gen["generated"]:,} new repeat structures, and {invent_gen["selected"]:,} selected queries. The exclusion filter omits saved w2/d1 flag classes and the earlier round-10 classes. Its omitted cases inherit no negative result.',
            '',f'The stochastic run used {invent_run["cpu_seconds"]:.3f} child CPU seconds and {invent_run["wall_seconds"]:.3f} wall seconds. Its result is a bounded observation. The selected invented-source queries have all run; limits remain unresolved. The larger generated inventory is not claimed as searched.']
lines+=['',f'Routing used {audit["routing_cpu_seconds"]:.3f} recorded child CPU seconds and {audit["routing_wall_seconds"]:.3f} recorded wall seconds. Peak recorded routing memory was {audit["peak_routing_rss_kib"]:,} KiB. These totals omit compiler jobs and controls. All CPU jobs ran sequentially at nice level 19. Search jobs used one thread and a 2,800 MiB address-space limit. All new files remain inside w6.',
        '', 'The final ledgers preserve UNKNOWN queries and untested inventory. No completed old edit scan was repeated. New scopes passed the saved w2/d1 exclusion filter. Control queries use larger budgets or three inputs. The conservative duplicate filter can omit operand-distinct scopes, so it supplies no completeness claim.',
        '', '### Every strict PASS path produced in round 10','', '| Strict PASS file | Judge log |','|---|---|']
for x in audit['pass_paths']:
    lines.append(f'| [{x["file"]}]({x["file"]}) | [judge]({x["log"]}) |')
lines+=['','Artifacts: [final audit and ledgers](round10/artifacts/final_summary.json), [scope and source audit](round10/artifacts/audit.json), [diverse plan](round10/artifacts/diverse_manifest.json), [full fixed-pair inventory](round10/artifacts/singleton_inventory.json).','']
with Path('RESULTS.md').open('a') as f:f.write('\n'.join(lines))
print(json.dumps({k:audit[k] for k in ['distinct_scopes','distinct_exhaustive_none','distinct_unresolved','routing_cpu_seconds','peak_routing_rss_kib']},indent=2))
