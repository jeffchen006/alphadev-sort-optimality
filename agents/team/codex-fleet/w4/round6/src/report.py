"""Append the completed campaign, scope limits, and every retained PASS path."""
from collections import Counter
import json
import os
from pathlib import Path
import subprocess
import sys

BASE = Path(__file__).resolve().parents[1]
WORKER = BASE.parent
PROJECT = WORKER.parents[3]


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    groups = [('First batch', BASE), ('Canonical routing', BASE/'extra'),
              ('Required partial witnesses', BASE/'partial')]
    data = []
    paths = []
    for name, folder in groups:
        audit = json.loads((folder/'logs/independent_audit.json').read_text())
        assert audit['audit_pass']
        progress = json.loads((folder/'logs/progress.json').read_text())
        assert progress['finished']
        data.append((name,folder,progress))
        for row in json.loads((folder/'logs/controls.json').read_text()):
            if row['status'] != 'PASS':
                continue
            tag = row['task']['tag']
            model = next(r['path'] for r in row['records'] if r.get('step')=='candidate')
            paths.extend([(Path(model),'out',Path(model+'.judge')),
                          (folder/'candidates'/f'{tag}.s','out',Path(model+'.judge'))])
            paths.extend([(Path(j['path']),j['model'],Path(j['log'])) for j in row['judges']])
    for row in json.loads((BASE/'logs/symbolic_controls.json').read_text()):
        paths.append((Path(row['path']),'out',BASE/'logs'/f"{row['tag']}.judge"))
    # Archive moves change paths. Recheck these retained controls at their
    # final paths so every listed file has a direct strict judge record.
    archive = BASE/'extra'
    archive_records = []
    for sub in ['preflight_candidates','preflight_verified']:
        for file in sorted((archive/sub).glob('*.s')):
            model = 'mem' if file.stem.endswith('_mem') else 'out'
            checked = subprocess.run([sys.executable,'-B',str(PROJECT/'shared/judge.py'),
                                      str(file),'--strict','--model',model],capture_output=True,text=True)
            log = archive/'preflight_logs'/f'{sub}_{file.name}.recheck.judge'
            log.write_text(checked.stdout+checked.stderr)
            assert not checked.returncode and checked.stdout.startswith('PASS ')
            archive_records.append(dict(path=str(file),model=model,output=checked.stdout+checked.stderr))
            paths.append((file,model,log))
    (BASE/'logs/archive_control_judges.json').write_text(json.dumps(archive_records,indent=2)+'\n')
    models = json.loads((BASE/'logs/model_analysis.json').read_text())
    found = models['strict_passes'] or any(
        r['status']=='PASS' and r.get('k',999)<=31
        for _,folder,_ in data for r in json.loads((folder/'logs/summary.json').read_text()))
    text = '\n### Round-6 completed campaign and final audit\n\n'
    text += '| Batch | Target queries | Checked UNSAT | UNKNOWN | Decoded models |\n'
    text += '|---|---:|---:|---:|---:|\n'
    for name,folder,p in data:
        text += (f"| {name} | {p['completed']} | {p['checked_unsat']} | "
                 f"{p['statuses'].get('UNKNOWN',0)} | {p['decoded_models']} |\n")
    text += ('\nThe six canonical-routing retries revisit unknown scopes. The required-partial '
             'queries add restrictions to unresolved scopes. These row counts are query counts, '
             'not counts of disjoint program classes. The 25 parser failures from the preflight '
             'are excluded from this table. All listed UNSAT certificates were checked. '
             'Every limit remains UNKNOWN.\n\n')
    text += (f"Recorded target query wall time: {sum(p['query_wall_seconds'] for _,_,p in data):.3f} seconds. "
             f"Recorded Kissat CPU time: {sum(p['solver_cpu_seconds'] for _,_,p in data):.3f} seconds. "
             f"Largest sampled combined Python/Kissat resident set: {max(p['peak_job_rss_kib'] for _,_,p in data)} KiB. "
             'Queries, judges, certificate checks, and analysis jobs ran serially at nice level 19.\n\n')
    text += (f"The model analysis covers {models['models']} saved k<=31 candidates with "
             f"{models['unique_cores']} distinct cores. "
             f"The minimum failure count with all scratch values set to 5 and initial flags equal is "
             f"{models['minimum_equal_flags_failure_count']}. These counts are observations for that initial state. "
             'The strict judge determines correctness. The analysis also checks whether another set of '
             'output snapshots can sort all 541 orders for each core. Full records and failure indices '
             'are in `round6/logs/model_analysis.json`.\n\n')
    text += ('Assumptions: [G1,G2,G3,G4,A2,A4,A11]. The first batch keeps physical write destinations. '
             'The broader batches free them. All batches keep comparison-value columns and comparison '
             'positions. Register sets remain finite. The required-partial batch also requires two '
             'mixed conditional-move results and one mixed conditional-move source among its initial '
             '31 binary orders. Its exclusions do not cover partial columns visible only on other '
             'orders. No global lower bound follows. No assumption has been contradicted.\n\n')
    partial_controls = json.loads((BASE/'partial/logs/controls.json').read_text())
    if any(r['task']['tag']=='negative_partial32' and r['status']=='UNSAT' for r in partial_controls):
        text += ('The fixed k=32 program with no partial columns returned UNSAT when required to '
                 'contain two partial results. Its certificate was checked. Together with the '
                 'k=36 partial-data positive control, this checks both outcomes of the extra '
                 'witness condition. Record: `round6/partial/logs/negative_partial32.json`.\n\n')
    text += 'Every retained round-6 control PASS path is listed below. These controls have k=32 or k=36.\n\n'
    for path,model,log in paths:
        text += f'- `{path.relative_to(WORKER)}` ({model}); judge: `{log.relative_to(WORKER)}`.\n'
    text += ('\nThe audit reports are `round6/logs/independent_audit.json`, '
             '`round6/extra/logs/independent_audit.json`, and '
             '`round6/partial/logs/independent_audit.json`. All scheduled jobs have ended.\n\n')
    text += ('A target strict PASS was found; see the FOUND line at the top of this file.\n' if found else
             'No k<=31 program passed the strict judge in this round.\n')
    marker = BASE/'logs/final_report_appended'
    if not marker.exists():
        with (WORKER/'RESULTS.md').open('a') as stream:
            stream.write(text)
        marker.write_text('complete\n')
    report = dict(found=bool(found),batches={name:p for name,_,p in data},
                  model_analysis_summary={k:v for k,v in models.items() if k!='records'},
                  strict_control_paths=[str(p) for p,_,_ in paths])
    (BASE/'logs/final_report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(found=bool(found),batches={name:p['statuses'] for name,_,p in data})),flush=True)


if __name__ == '__main__':
    main()
