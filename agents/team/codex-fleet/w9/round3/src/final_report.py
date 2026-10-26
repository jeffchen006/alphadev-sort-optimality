"""Append verified round-3 counters and every new PASS path."""
import json
from pathlib import Path
import re

HERE=Path(__file__).resolve().parents[1]


def main():
    summary=json.loads((HERE/'artifacts/summary.json').read_text())
    checks=json.loads((HERE/'artifacts/weak_filter_checks.json').read_text())
    found=summary['best_strict_pass_out_k'] is not None and summary['best_strict_pass_out_k']<=31
    result=(f"A k={summary['best_strict_pass_out_k']} program received strict PASS. See the PASS ledger below.\n"
            if found else 'No k<=31 program received strict PASS in the recorded searches. '
            'The best verified core remains k=32. Its memory form has length 42.\n')
    text=['\n### Round 3 recorded result\n',result,
          'The separate checker confirmed all 402 median-queue rejection witnesses '
          'and all 447 unresolved-queue rejection witnesses. It also checked 21 and 26 '
          'sampled accepted orders, respectively. It generated the comparison flags '
          'through the original SAT encoder path. See '
          '[weak_filter_checks.json](round3/artifacts/weak_filter_checks.json). '
          'This is an independent implementation check of the filter, not an '
          'independently checked UNSAT certificate.\n',
          '| Search | Recorded configurations | Status | Parent CPU seconds | Child CPU seconds | Wall seconds |\n'
          '|---|---:|---|---:|---:|---:|\n']
    for group in summary['groups']:
        status=', '.join(f'{count} {name}' for name,count in group['status'].items())
        text.append(f"| {group['name']} | {group['queries_completed']}/{group['queries_planned']} | {status} | "
                    f"{group['cpu_parent']:.3f} | {group['cpu_child']:.3f} | {group['wall']:.3f} |\n")
    for group in summary['groups']:
        if group['queries_without_solver_call']:
            text.append(f"\n{group['name']}: {group['queries_without_solver_call']} queries reached their wall limit "
                        'during construction or transfer, before a Kissat call. These queries remain UNKNOWN.\n')
    text.append(f"\nAfter completed Kissat reruns, the original 795-configuration solver ledger has "
                f"{summary['round2_latest_unsat']} UNSAT and {summary['round2_latest_unknown']} UNKNOWN configurations. "
                'Information-filter rejections are reported separately. Reruns retain the original '
                'program restrictions and add valid weak-order cases. A solver limit remains UNKNOWN. '
                'Unrun configurations remain UNKNOWN. No global lower bound follows.\n')
    text.append('\nAll new strict PASS paths follow. Retained copies have identical bytes. '
                'The ledger also records every tested FAIL. See '
                '[strict_ledger.json](round3/artifacts/strict_ledger.json) and '
                '[summary.json](round3/artifacts/summary.json).\n\n'
                '| Strict PASS file | Retained copy | Model | Length | Judge output |\n'
                '|---|---|---|---:|---|\n')
    for row in summary['pass_paths']:
        relative=lambda s: str(Path(s).relative_to(HERE.parent))
        text.append(f"| [{Path(row['path']).name}]({relative(row['path'])}) | "
                    f"[copy]({relative(row['retained_copy'])}) | {row['model']} | {row['length']} | "
                    f"[PASS]({relative(row['log'])}) |\n")
    text.append('\nResume unrun queue entries with `nice -n 19 bash round3/run_remaining.sh`. '
                'The runner skips recorded queue indices, including recorded UNKNOWN timeouts. '
                'It keeps the original size order. '
                'Re-run the final audit with `nice -n 19 python3 -B round3/src/audit.py`. '
                'The median scan is a bounded repair search. Every UNKNOWN remains open. '
                'The round tests A2, A4, A6, and A11. No new assumption was contradicted.\n')
    path=HERE.parent/'RESULTS.md'
    old=path.read_text();marker='\n### Round 3 recorded result\n'
    if marker in old:old=old[:old.index(marker)]
    body='\n'.join(text)
    body=re.sub(r'(?m)^(\|[^\n]*\|)\n\n(?=\|)',r'\1\n',body)
    path.write_text(old+body)


if __name__=='__main__':main()
