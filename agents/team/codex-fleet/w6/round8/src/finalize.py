"""Append the completed audit. Do not change any previous round."""
from pathlib import Path
import json

r=json.loads(Path('round8/artifacts/final_summary.json').read_text())
assert r['sat_statuses']=={'UNSAT':40}
assert r['best_failures']==9 and not r['saved_le6']
assert r['mcmc_statuses']=={'FINISHED_AT_WALL_LIMIT':4,'FINISHED':56}
assert not r['model_mining']['retained']
assert not Path('round8/artifacts/FOUND').exists()
assert not any(j.get('out',{}).get('pass') for j in r['judges'])
lines=['', '## Round 8 completion', '',
       'No strict PASS with core k <= 31 was found. The best correct core remains k=32, or 42 memory instructions. No new PASS file was produced in this round. No fixed comparison structure was rerouted.', '',
       'All 40 selected window queries returned UNSAT. Their scopes comprise 25 typed windows of width six, seven typed windows of width seven, and eight typed windows of width eight. Every query fixed the outside instructions and retained its register bound. Outputs remained free snapshots. The logged derived constraints are necessary for an all-541-order repair. These results concern only the stated local scopes. They do not establish a global lower bound.', '',
       f"The final audit checked {r['audited_cut_dependencies']} smaller-window dependencies and the hashes of all 15 seeds. The longer pass made {r['solve_calls']} solver calls and produced {r['sat_models']} completed SAT models. Model mining decoded every saved SAT model and retained no program with at most six failing orders. The original 465-scope inventory now has 302 scoped UNSAT results and 163 UNKNOWN results.", '',
       'The stochastic searches ran every representative at four temperatures. Each run used 31 slots, seven to ten comparisons, all 541 weak orders, and two fresh scratch registers. The table gives stochastic proposals, not unique programs. A proposal can be rejected before execution. None of these searches is exhaustive.', '',
       '| Temperature | Runs | Proposals | Accepted transitions | Binary CPU seconds | Best failed orders |',
       '|---:|---:|---:|---:|---:|---:|']
for temp,g in r['mcmc_groups'].items():
    lines.append(f"| {temp} | {g['runs']} | {g['proposals']:,} | {g['accepted']:,} | {g['cpu_seconds']:.3f} | {g['best_failures']} |")
lines += ['',f"The 60 runs made **{r['proposals']:,} proposals** and accepted **{r['accepted']:,} transitions**. No run improved the nine-order failure count. No program with at most six failing orders was retained. The four initial runs reached their 90-second wall limits and returned final counters. The other 56 runs reached their 40-CPU-second targets within their 300-second wall limits. Every bounded result remains a search observation.", '',
          f"The separate scalar executor matched the saved failure counts and output-error sums on all {r['score_check']['files']} search files. It checked all 541 orders for each file. This is tested agreement under the conservative unknown-value semantics, not a proof. No zero-error candidate reached the strict judge. The earlier strict PASS files remain the only correct files cited by this worker.", '',
          f"The SAT queries used {r['sat_cpu_seconds']:.3f} child CPU seconds. The stochastic jobs used {r['mcmc_cpu_seconds']:.3f} child CPU seconds. The recorded jobs used {r['wall_seconds']:.3f} wall seconds in total, excluding the restart gap and final audits. The largest recorded child memory was {r['peak_child_rss_kib']:,} KiB. All bounded jobs had a 2,800 MiB address-space limit. Search and compiler jobs used nice level 19. Search jobs ran sequentially. All new retained files are in w6.", '',
          'This round tests A1, A2, and A11 within the stated search bounds. It does not contradict an assumption in ASSUMPTIONS_42.md. Every remaining UNKNOWN scope remains unresolved.', '',
          'Artifacts: [final audit](round8/artifacts/final_summary.json), [SAT ledger](round8/artifacts/sat_ledger.json), [MCMC ledger](round8/artifacts/mcmc_ledger.json), [model mining](round8/artifacts/mined_models.json), [scalar score check](round8/artifacts/score_check.json). The source files and seed hashes are in the final audit.']
p=Path('RESULTS.md')
assert '## Round 8 completion' not in p.read_text()
with p.open('a') as f:f.write('\n'.join(lines)+'\n')
print(json.dumps(dict(appended='RESULTS.md',proposals=r['proposals'],sat='40 scoped UNSAT',best_failed_orders=9)))
