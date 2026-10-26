"""Retain the final strict failures and check the saved near-miss behavior."""
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0,'/path/to/repo/shared')
import judge

cases=judge.weak_orders(5)
def outputs(path):
    _,p=judge.parse(Path(path).read_text())
    regs=judge.regs(5,p)
    columns=[]
    for ranks in cases:
        state={r:ranks[int(r[1:])] if r[0]=='P' else 7 for r in regs}
        final=judge.run_concrete(p,state,(1,0))
        columns.append(judge.outputs(final,final['_out'],5))
    return columns

reference='round2/candidates/near14_frozen.s'
ref=outputs(reference)
ref_bad=[i for i,ranks in enumerate(cases) if ref[i]!=sorted(ranks)]
rows=[]
for name,stem in [('flagswrites_1_seed161_near','near14_judge'),
                  ('cmp2_1_seed161_near','cmp2_near_judge')]:
    path='round4/candidates/'+name+'.s'
    log=Path('round4/logs',stem+'.log')
    assert log.read_text().startswith('FAIL '+path+' [relaxed+strict]')
    out=outputs(path)
    bad=[i for i,ranks in enumerate(cases) if out[i]!=sorted(ranks)]
    rows.append({'path':path,'judge_log':str(log),'strict_pass':False,
                 'failed_orders':len(bad),'same_outputs_as_prior':out==ref,
                 'same_failed_orders_as_prior':bad==ref_bad,
                 'sha256':hashlib.sha256(Path(path).read_bytes()).hexdigest()})
    assert len(bad)==14

summary_path=Path('round4/artifacts/final_summary.json')
summary=json.loads(summary_path.read_text())
summary['near_misses']={'reference':reference,'cases':541,'scratch':7,'initial_flags':'eq','programs':rows}
summary['edit_sequences']=sum(row['tried'] for row in summary['aggregate'].values())
assert summary['edit_sequences']==6153091276
summary['jobs']=[]
for p in sorted(Path('round4/artifacts').glob('*.json')):
    obj=json.loads(p.read_text())
    if isinstance(obj,dict) and 'command' in obj:
        summary['jobs'].append(obj)
assert all(row['exit']==0 for row in summary['jobs'] if row['name'] in {
    'delete2_even','delete2_odd','flagsall_even','flagsall_odd',
    'flagswrites_0','flagswrites_1','cmp2_0','cmp2_1','flagsany_0','flagsany_1'})
assert not Path('round4/artifacts/FOUND_PENDING').exists()
summary_path.write_text(json.dumps(summary,indent=2))
with Path('RESULTS.md').open('a') as f:
    f.write('\nThe five completed scans tested 6,153,091,276 edit sequences in total. Counts can overlap between patterns. No k=31 program passed the full-case filter.\n')
    f.write('\nTwo scans retained a k=31 program with 14 failing weak orders and an output-error sum of 18. Both strict judge commands returned FAIL. For input `[0,1,2,1,3]`, both return `[0,1,2,2,3]` instead of `[0,1,1,2,3]`. These files do not improve the prior near miss.\n\n')
    for row in rows:
        f.write('- ['+Path(row['path']).name+']('+row['path']+'), [strict judge output]('+row['judge_log']+').\n')
    f.write('\nThe final scalar check used all 541 weak orders, scratch value 7, and initial equality flags. ')
    if all(row['same_outputs_as_prior'] for row in rows):
        f.write('Both saved programs produced exactly the same outputs as the prior 14-order near miss on those concrete tests. ')
    else:
        f.write('The programs share the 14-order failure count. Per-program output comparisons are in the ledger. ')
    f.write('This is an observed match under the stated initial state, not a general equivalence proof. The final judge failures and refreshed job ledger are in [round4/artifacts/final_summary.json](round4/artifacts/final_summary.json).\n')
print(json.dumps({'edit_sequences':summary['edit_sequences'],'near_misses':rows,'audit':'MATCH'}))
