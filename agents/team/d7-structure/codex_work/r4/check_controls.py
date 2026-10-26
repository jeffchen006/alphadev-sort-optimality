import os,subprocess,json,concurrent.futures
ROOT='codex_work/r4'
try:os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
except (AttributeError,OSError):pass
files=['n3_reference11.s','n4_positive20.s','c9_onewrite_block.s','c10_padding.s']
def run(fn):
 p=subprocess.run(['python3','/path/to/repo/shared/judge.py',ROOT+'/'+fn,'--strict','--model','out'],text=True,capture_output=True)
 assert p.returncode==0,(fn,p.stdout,p.stderr)
 return fn,p.stdout.strip()
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:results=dict(ex.map(run,files))
json.dump(results,open(ROOT+'/controls_judge.json','w'),indent=2)
for fn,msg in results.items():print(msg)
