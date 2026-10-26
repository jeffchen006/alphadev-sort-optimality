#!/usr/bin/env python3
"""Audit all retained routing results and append the completed 04:30 report."""
import json
import re
from collections import Counter
from pathlib import Path

base = Path('logs/round0430')
summary = json.loads((base / 'summary.json').read_text())
assert summary['done'] == summary['total'] == 47, 'Retry remains incomplete'
old = json.loads(Path('logs/recompute9_priority/audit_summary.json').read_text())
old_rows = old['records'] if isinstance(old, dict) else old
records = {Path(r['file']).name: dict(r) for r in old_rows}
assert len(records) == 208
for record in summary['records']:
    txt = Path(record['log']).read_text()
    statuses = re.findall(r'^RESULT (\w+)', txt, re.M)
    assert len(statuses) == 1 and statuses[0] == record['status'], record
    assert record['status'] in ('NONE', 'LIMIT', 'TIMEOUT', 'ERROR', 'FOUND'), record
    if record['status'] in ('NONE', 'LIMIT', 'FOUND'):
        assert 'K=31' in txt
        result = re.search(r'^RESULT .*calls=(\d+).*time=([\d.]+)s', txt, re.M)
        assert result and int(result[1]) == record['calls'], record
        assert (record['calls'] <= record['node_limit']) == (record['status'] != 'LIMIT'), record
    if not record['reused_exhaustive']:
        assert 'node_limit=500000000' in txt
        assert 'assumptions=A4,A6' in txt
        assert 'engine_sha256=' + summary['engine_sha256'] in txt
    records[record['file']] = record
counts = Counter(r['status'] for r in records.values())
assert len(records) == 208
for record in records.values():
    txt = Path(record['log']).read_text()
    status = re.findall(r'^RESULT (\w+)', txt, re.M)
    assert len(status) == 1 and status[0] == record['status'], record
    if record['status'] == 'NONE':
        assert '(node limit hit' not in txt, record
        assert re.search(r'^RESULT NONE K=31 ', txt, re.M), record
audit = dict(scope='208 recomputation skeletons; fixed operands and order; 120 strict orders; K=31',
             assumptions=['A4', 'A6'], counts=dict(counts), records=list(records.values()),
             retry=summary)
(base / 'final_audit.json').write_text(json.dumps(audit, indent=2) + '\n')
unknowns = [r for r in summary['records'] if r['status'] not in ('NONE', 'FOUND')]
(base / 'unknown.tsv').write_text('file\tstatus\tcalls\tseconds\tlog\n' + ''.join(
    f'{r["file"]}\t{r["status"]}\t{r["calls"]}\t{r["seconds"]}\t{r["log"]}\n' for r in unknowns))

lines = ['\n### Completed 04:30 retry audit\n',
         f'Final retained results for the 47-case retry: **NONE {summary["counts"].get("NONE", 0)}, '
         f'LIMIT {summary["counts"].get("LIMIT", 0)}, '
         f'TIMEOUT {summary["counts"].get("TIMEOUT", 0)}, '
         f'ERROR {summary["counts"].get("ERROR", 0)}, '
         f'FOUND {summary["counts"].get("FOUND", 0)}**.\n',
         f'This round exhausted {summary["newly_exhausted"]} additional skeletons. '
         f'It retained {summary["reused_exhaustive"]} earlier exhaustive results without repeating them. '
         f'The cumulative 208-case set now has **{counts["NONE"]} exhaustive NONE** '
         f'and **{sum(counts[s] for s in ("LIMIT", "TIMEOUT", "ERROR"))} unknown** results.\n',
         f'New searches made {summary["new_calls"]:,} recursive calls. Their measured wall time '
         f'was {summary["new_seconds"]:.3f} seconds. Maximum recorded child RSS was '
         f'{summary["child_peak_rss_kib"]:,} KiB. Each search used one CPU job at nice level 19 '
         'and an address-space limit of 2,800,000,000 bytes.\n',
         'Assumptions tested: [A4, A6]. Exhaustive results apply only to the supplied '
         'comparison columns and order on the 120 strict input orders. Limits remain '
         'unknown. These results do not establish a general sort5 lower bound.\n',
         'The router has no register cap. Adding one register would leave its routing '
         'model unchanged. The requested condition that all 47 cases remain unknown '
         'did not occur. No extra-register retry was needed.\n',
         'No new k<=31 sorting program reached strict verification in this retry. '
         'No new strict PASS file was produced. No result contradicts an assumption '
         'listed in `board/ASSUMPTIONS_42.md`.\n',
         '| Skeleton | Result | Calls | Seconds | Log |\n'
         '| --- | --- | ---: | ---: | --- |']
for r in summary['records']:
    suffix = ' (retained)' if r['reused_exhaustive'] else ''
    seconds = r['elapsed'] if r['elapsed'] is not None else r['seconds']
    calls = f'{r["calls"]:,}' if r['calls'] is not None else 'unavailable'
    duration = f'{seconds:.3f}' if seconds is not None else 'unavailable'
    lines.append(f'| {r["file"]} | {r["status"]}{suffix} | {calls} | {duration} | `{r["log"]}` |')
lines += ['\nFull audit: `logs/round0430/final_audit.json`. Remaining unknown cases: '
          '`logs/round0430/unknown.tsv`. Reproduction uses the unchanged `dagx_lb` '
          f'executable with SHA-256 `{summary["engine_sha256"]}`.\n',
          '```sh\n'
          'ulimit -v 2800000\n'
          'nice -n 19 python3 src/round0430.py > logs/round0430_batch.log 2>&1\n'
          'nice -n 19 python3 src/round0430_report.py\n'
          '```\n',
          'The driver retains completed results. Use a fresh log folder for a new '
          'search. Per-case commands set ROOTORDER=1, FASTCPL=1, CACHECPL=1, '
          'LEGACYFILL=1, and FASTLB=1. Each new case uses K=31, a 500M-node limit, '
          'and a 3,600-second wall limit.\n']
assert not summary['counts'].get('FOUND'), 'Candidate needs strict verification and a separate report'
dst = Path('RESULTS.md')
text = dst.read_text()
marker = '\n### Completed 04:30 retry audit\n'
if marker in text:
    text = text.split(marker)[0]
text += '\n'.join(lines)
text = text.replace('This round is active. No new k<=31 program has passed the strict judge.',
                    'This round is complete. No new k<=31 program has passed the strict judge.')
text = text.replace(
    'ten comparisons. The latest round retries 208 nine-comparison skeletons\n'
    'at K=31; its final count is 161 exhaustive NONE and 47 unknown LIMIT.',
    'ten comparisons. The latest completed round routes 208 nine-comparison\n'
    f'skeletons at K=31. It has {counts["NONE"]} exhaustive NONE and '
    f'{sum(counts[s] for s in ("LIMIT", "TIMEOUT", "ERROR"))} unknown results.\n'
    'The 04:30 audit below gives each retry result and run time.')
dst.write_text(text)
print(json.dumps(dict(retry=summary['counts'], cumulative=dict(counts), new_calls=summary['new_calls'],
                      new_seconds=summary['new_seconds']), indent=2))
