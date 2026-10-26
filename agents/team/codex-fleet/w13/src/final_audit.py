"""Check durable ledgers and write a final bounded-search record."""
import collections,hashlib,json,re
from pathlib import Path

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
    report=json.loads(Path('logs/report.json').read_text())
    closed={x.strip() for x in Path('closed.txt').read_text().splitlines() if x.strip()}
    records=[json.loads(x) for x in Path('logs/closed.jsonl').read_text().splitlines() if x.strip()]
    support={}
    for r in records:
        assert r['status']=='NONE' and r['k']==31,r
        key=Path(r['file']+'.key').read_text().strip()
        assert hashlib.sha256(key.encode()).hexdigest()==r['sha256'],r['file']
        if r.get('mode')=='SAT':
            cert=json.loads(Path(r['certificate']).read_text())
            assert cert['verified'] and sha(cert['formula'])==cert['formula_sha256'] and sha(cert['proof'])==cert['proof_sha256']
        else:assert re.search(r'RESULT NONE K=31\b',Path(r['log']).read_text()),r
        support[r['sha256']]=r
    assert closed==set(support),(len(closed),len(support))
    assert len(closed)==report['unique_closed'],(len(closed),report['unique_closed'])
    Path('closed.txt').write_text(''.join(x+'\n' for x in sorted(closed)))
    passes=report['judge_passes'];failures=report['judge_failures']
    for r in passes:
        assert 'PASS '+r['file'] in Path(r['log']).read_text(),r
        r['sha256']=sha(r['file'])
    generations=[]
    for p in sorted(Path('logs').glob('*.stage.json')):
        r=json.loads(p.read_text())
        if r.get('command') and r['command'][0] in ('./generate','./generate_focus'):
            mf=Path(r['command'][4])/'manifest.jsonl'
            r['records']=sum(1 for _ in mf.open()) if mf.exists() else 0
            generations.append(r)
    sat=[]
    for p in sorted(Path('logs').glob('*.json')):
        if p.name in ('report.json','final_audit.json'):continue
        r=json.loads(p.read_text())
        if isinstance(r,dict) and 'cnf_sha256' in r and 'status' in r:
            cnf=p.with_suffix('.cnf');assert sha(cnf)==r['cnf_sha256']
            sat.append(dict(file=str(p),k=r['k'],c=r['c'],cases=r['cases'],status=r['status'],seconds=r['elapsed_seconds'],formula_sha256=r['cnf_sha256']))
    sources={str(p):sha(p) for p in sorted(Path('src').glob('*')) if p.is_file()}
    result=dict(report={k:v for k,v in report.items() if k not in ('judge_passes','judge_failures')},closed_sha256=sha('closed.txt'),support_records=len(records),closed_unique=len(closed),passes=passes,failures=failures,generations=generations,sat=sat,source_sha256=sources)
    Path('logs/final_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    lines=['\n## Final continuation audit\n','No k <= 31 program passed the strict judge in this continuation.\n','All compute stages ran serially at nice level 10. Each search process had a\n4 GiB address-space cap. The task used one CPU core.\n','The durable audit is `logs/final_audit.json`. It checks every closed hash\nagainst a negative log or a checked SAT certificate. It also checks saved\nformula hashes and records all source and PASS program hashes.\n','| Batch | Cases | NONE | LIMIT |\n|---|---:|---:|---:|']
    for b in report['batches']:lines.append(f"| {b['batch']} | {b['records']} | {b['statuses'].get('NONE',0)} | {b['statuses'].get('LIMIT',0)} |")
    lines += ['',f"Unique k=31 cases tested: {report['unique_tested']:,}. Closed hashes: {len(closed):,}. Unresolved cases: {report['unique_open']:,}.", '','The closed counts apply to the stated fixed skeleton representations. A\nnode limit or UNKNOWN result remains unresolved. The full minimum routing\ncost has not been established for every skeleton. No general sort5 lower\nbound follows from this search.\n','All strict PASS files in this folder:','']
    for r in passes:
        lines.append(f"- `{r['file']}` — `{r['output'].strip()}`")
    lines += ['','SAT decisions in this continuation:','','| Record | c | k | Strict orders | Decision |','|---|---:|---:|---:|---|']
    for r in sat:lines.append(f"| `{r['file']}` | {r['c']} | {r['k']} | {r['cases']} | {r['status']} |")
    lines += ['','Source generation caps and time limits are in each stage record. A capped\nor timed-out generator does not exhaust its source grammar. The complete\nopen-case list is `sk/open_cases.json`.\n']
    p=Path('RESULTS.md');old=p.read_text();marker='\n## Final continuation audit\n'
    if marker in old:old=old.split(marker)[0]
    p.write_text(old+'\n'.join(lines)+'\n')
    print(json.dumps(dict(closed=len(closed),open=report['unique_open'],passes=len(passes),failures=len(failures),audit='logs/final_audit.json')),flush=True)

if __name__=='__main__':main()
