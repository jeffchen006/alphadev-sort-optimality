"""Continue after the first batch without concurrent CPU search jobs."""
import json,subprocess,time
from pathlib import Path

def run(cmd,tag):
    print(json.dumps(dict(stage=tag,command=cmd)),flush=True)
    result=subprocess.run(cmd,stdout=Path('logs',tag+'.stdout').open('w'),stderr=Path('logs',tag+'.stderr').open('w'))
    if result.returncode:raise RuntimeError((tag,result.returncode))

def main():
    while True:
        try:
            s=json.loads(Path('logs/first31/summary.json').read_text())
            if s['processed']==s['total']:break
        except (OSError,json.JSONDecodeError):pass
        time.sleep(1)
    run(['g++','-O3','-std=c++17','src/generate.cpp','-o','generate'],'compile_generate')
    run(['g++','-O3','-std=c++17','src/distance.cpp','-o','distance'],'compile_distance')
    run(['python3','src/prepare_prior.py'],'prepare_prior')
    run(['python3','src/audit.py','sk/c8_full6/manifest.jsonl','--layouts','--tag','audit_c8_first'],'audit_c8_first')
    run(['python3','src/run.py','c8_upper32','sk/c8_full6/manifest.jsonl','--k','32','--limit','1000000','--timeout','30'],'c8_upper32_driver')
    run(['python3','src/run.py','c8_deep31','sk/c8_full6/manifest.jsonl','--limit','10000000','--timeout','60'],'c8_deep31_driver')
    run(['python3','src/audit.py','sk/c9_full4/manifest.jsonl','--tag','audit_c9_first'],'audit_c9_first')
    run(['./distance','sk/prior_full.keys','sk/first_distance.jsonl','sk/c8_full6','sk/c9_full4'],'distance_first')
    run(['python3','src/generation_wave.py'],'generation_wave')
    manifests=sorted(str(p) for p in Path('sk').glob('c*_p*_m*/manifest.jsonl'))
    run(['python3','src/audit.py',*manifests,'--tag','audit_wave'],'audit_wave')
    run(['python3','src/run.py','wave31',*manifests,'--limit','100000','--timeout','30'],'wave31_driver')
    print('SERIAL_STAGE_COMPLETE',flush=True)

if __name__=='__main__':main()
