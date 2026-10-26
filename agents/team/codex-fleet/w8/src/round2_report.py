"""Append round-two results. Preserve the earlier report and its evidence."""
import collections
import datetime
import hashlib
import json
from pathlib import Path
import re

def read_rows(tag):
    path=Path('logs',tag,'results.jsonl')
    rows={}
    if path.exists():
        for line in path.read_text().splitlines():
            row=json.loads(line);rows[row['file']]=row
    return rows

def main():
    old=json.loads(Path('sk/round2_rerun.json').read_text())
    new=json.loads(Path('sk/round2_net9_41.json').read_text())
    runs={tag:read_rows(tag) for tag in ('round2_rerun','round2_net41')}
    lines=['','## Round 2: tenfold reruns and net9_41 partner selections','',
           'Report time: '+datetime.datetime.now(datetime.timezone.utc).isoformat()+'.','',
           'Assumptions tested: [A4, A8]. Each routing search fixes one comparison skeleton. '
           'The added skeletons use values outside the lattice scope. '
           'No general lower bound follows from this search.','',
           'Resource limits for this round: one routing process at a time; nice -n 19; '
           '3 GiB address-space limit. All writes stay in the w8 folder.','',
           'The frozen initial list is `sk/round2_original_open.json`. It has 6,075 unresolved cases. '
           'Each rerun uses ten times its largest prior node limit. '
           'The queue sorts cases by required non-input columns, then by node limit and file name. '
           'A required non-input column needs at least one conditional move. '
           'State counts are the router\'s recursive-call counts. They include pruned calls and a small overrun while the search returns from the node limit. '
           'There is no wall-time cutoff in this round. LIMIT remains unknown.','',
           '| Required columns | Initial cases | Reruns completed | NONE | LIMIT | Other | Recorded states |',
           '| --- | ---: | ---: | ---: | ---: | ---: | ---: |']
    for g in sorted({r['required_gates'] for r in old}):
        group=[runs['round2_rerun'][r['file']] for r in old if r['required_gates']==g and r['file'] in runs['round2_rerun']]
        h=collections.Counter(r['status'] for r in group)
        lines.append('| '+str(g)+' | '+str(sum(r['required_gates']==g for r in old))+' | '+str(len(group))+' | '+str(h['NONE'])+' | '+str(h['LIMIT'])+' | '+str(len(group)-h['NONE']-h['LIMIT'])+' | '+f"{sum(r.get('calls',0) for r in group):,}"+' |')
    lines+=['','Node limits: 4,611 cases at 200,000; 1,315 at 1,000,000; '
            '148 at 10,000,000; one at 100,000,000.','',
            '`src/partner_select.cpp` inserts a non-lattice selector into the net9_41 functional graph. '
            'It replaces each later comparison operand separately. It also replaces all later uses of each available source value. '
            'Within one comparison block, the generator keeps the first insertion point for each selected column. '
            'It excludes known canonical skeletons. The scan uses both strict and non-strict conditional-move conditions.','',
            'The generator made 1,421 distinct non-lattice selected columns. It tested 12,941 redirects. '
            'Of these, 2,758 separate all 120 strict input orders. '
            'Canonicalization excluded 178 known records and 2,475 duplicates. It retained 105 skeletons. '
            'A separate evaluator checked all 105 saved graphs against their exact skeleton columns and flag histories.','',
            'The single-operation net9_41 mutation pass tested 15,705 changes. '
            'It retained 14 skeletons. Six of the 119 combined skeletons have only lattice comparison operands. '
            'The new routing set has 113 non-lattice skeletons: 61 need at least 15 columns; 52 need at least 16. '
            'Each new case has a 1,000,000-node limit. '
            'A separate audit found no canonical matches against the prior cache or the d6 net9_41 skeleton set. '
            'See `logs/round2_net41_prior_audit.json`.','',
            '| Batch | Planned | Completed | Status counts | Recorded states |',
            '| --- | ---: | ---: | --- | ---: |']
    for tag,planned in (('round2_net41',len(new)),('round2_rerun',len(old))):
        rows=list(runs[tag].values());h=collections.Counter(r['status'] for r in rows)
        lines.append('| '+tag+' | '+str(planned)+' | '+str(len(rows))+' | '+', '.join(k+' '+str(v) for k,v in sorted(h.items()))+' | '+f"{sum(r.get('calls',0) for r in rows):,}"+' |')
    fixed=json.loads(Path('logs/round2_net41_fixed.json').read_text())
    lines+=['','Fixed-graph copy minimization tested two layouts for each of 119 retained sorting traces. '
            'Its length counts are '+', '.join('k='+k+': '+str(v) for k,v in fixed['histogram'].items())+'. '
            'No tested layout had k <= 31. These are fixed-graph layout results, not unrestricted routing results.','',
            '`src/dagx_fast.cpp` caches the exact copy bound. The cache key includes every resolved gate, '
            'its block, its two operand nodes, and all current comparison uses. '
            'It omits value columns because the bound does not read them. '
            'The search order and pruning decisions stay the same. '
            'It also caches the exact prefix-consistency test by partial column and comparison block. '
            'The prefix classes remain fixed within each process. '
            '`logs/round2_cache_check.json` records eight cached/original comparisons. '
            '`logs/round2_cache2_check.json` records eight more comparisons after the second cache was added. '
            '`logs/round2_fast_check.json` records ten comparisons after covered-order masks were stored in each column. '
            'The final change reduced aggregate CPU time in those ten checks from 2.105325 to 1.490461 seconds. '
            'These timings do not establish a full-batch speed ratio. '
            'Every result, node count, and emitted solution matched after timing and cache statistics were removed. '
            'This check is evidence for the implementation. It is not a proof.','']
    for f in ('logs/round2_control32.judge.log','logs/round2_control32_mem.judge.log'):
        if Path(f).exists():
            lines+=['Control judge output (`'+f+'`):','','```text',Path(f).read_text().strip(),'```','']
    remaining=[]
    for row in old:
        result=runs['round2_rerun'].get(row['file'])
        if not result or result['status'] not in ('NONE','FOUND'):
            remaining.append(dict(row,round2_status=result['status'] if result else 'PENDING'))
    Path('sk/round2_remaining.json').write_text(json.dumps(remaining,indent=2)+'\n')
    audit_path=Path('logs/round2_audit.json')
    if audit_path.exists():
        audit=json.loads(audit_path.read_text())
        lines+=['Combined canonical audit (`logs/round2_audit.json`): '+str(audit['canonical_skeletons'])+' selected skeletons; '
                +', '.join(k+' '+str(v) for k,v in sorted(audit['verdicts'].items()))+'. '
                'The full new-case unresolved list, including the 113 added skeletons, is `sk/round2_all_open_cases.json`. '
                'It contains '+str(len(audit['open_cases']))+' cases. '
                'Two unresolved prior-cache matches are recorded separately in the audit.','']
    lines+=['Unclosed cases from the initial 6,075-case list: '+str(len(remaining))+'. '
            '`sk/round2_remaining.json` preserves their status. '
            'Only NONE closes a negative search within the router representation. '
            'LIMIT, ERROR, and unprocessed cases remain unknown.','',
            'New control PASS files: `programs/round2_control32.s` (out, k=32) and '
            '`programs/round2_control32_mem.s` (mem, length 42). '
            'Their exact judge output is shown above. Earlier PASS files remain listed in the first report.','',
            'No k <= 31 strict PASS was recorded in this round.' if not any(r.get('verified') for rs in runs.values() for r in rs.values()) else
            'A candidate passed strict verification. See the FOUND line at the top of this report.','']
    Path('logs/round2_report.md').write_text('\n'.join(lines))
    with Path('RESULTS.md').open('a') as stream:stream.write('\n'.join(lines))
    passes=[]
    for log in sorted(Path('logs').glob('*.judge.log')):
        for line in log.read_text().splitlines():
            if not line.startswith('PASS '):continue
            file=line.split()[1]
            passes.append(dict(file=file,length=int(re.search(r' L=(\d+)',line)[1]),
                               model=re.search(r'model=(\w+)',line)[1],log=str(log),line=line,
                               sha256=hashlib.sha256(Path(file).read_bytes()).hexdigest()))
    Path('logs/judge_registry.json').write_text(json.dumps(passes,indent=2)+'\n')
    print(json.dumps(dict(rerun_completed=len(runs['round2_rerun']),new_completed=len(runs['round2_net41']),unclosed=len(remaining))))

if __name__=='__main__':main()
