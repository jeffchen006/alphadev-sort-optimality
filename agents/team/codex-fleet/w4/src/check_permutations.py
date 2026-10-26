#!/usr/bin/env python3
import pathlib,re,subprocess,concurrent.futures as cf,json,collections
root=pathlib.Path('candidates/permutation_controls');root.mkdir(exist_ok=True)
def job(src):
 mapping={}
 def sub(m):
  r=m.group(0)
  if r not in mapping:mapping[r]='S'+str(len(mapping))
  return mapping[r]
 raw=re.sub(r'S\d+',sub,src.read_text());dest=root/src.name;dest.write_text(raw);lines=[l for l in raw.splitlines() if l and not l.startswith('#') and not l.startswith('out')];k=len(lines)
 r=subprocess.run(['python3','/path/to/repo/shared/judge.py',str(dest),'--strict','--model','out'],capture_output=True,text=True)
 log=pathlib.Path('logs')/('control_'+src.stem+'.judge');log.write_text(r.stdout+r.stderr)
 return {'file':str(dest),'k':k,'judge':r.stdout.strip()}
with cf.ThreadPoolExecutor(max_workers=8) as pool:
 for result in pool.map(job,sorted(pathlib.Path('sk/permutations').glob('p*.s'))):print(json.dumps(result),flush=True)
