import os,json,subprocess,time,concurrent.futures,re,sys
ROOT='codex_work/r4'
try:os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
except (AttributeError,OSError):pass
tradeoff='--tradeoff' in sys.argv
K=20 if tradeoff else 19
tasks=[(e,c,w) for e in json.load(open(ROOT+'/net4_manifest.json')) for c,w in ([(5,15),(6,14)] if tradeoff else [(5,14),(6,13)])]
def run(t):
 e,c,w=t;fn=ROOT+'/log_'+e['tag']+'_c%d_w%d.txt'%(c,w);start=time.monotonic()
 try:
  with open(fn,'w') as f:p=subprocess.run([ROOT+'/pool4',e['file'],str(K),'0',str(c),str(w)],stdout=f,stderr=subprocess.STDOUT,timeout=30)
  rc=p.returncode
 except subprocess.TimeoutExpired:rc=-9
 text=open(fn).read();r=re.findall(r'NONE <= \d+|MIN k = \d+|ABORT[^\n]*',text)
 return {'tag':e['tag'],'file':e['file'],'size':e['size'],'c_cap':c,'w_cap':w,'result':r[-1] if r else ('timeout' if rc==-9 else 'error'),'seconds':time.monotonic()-start,'log':fn}
rows=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:
 for row in ex.map(run,tasks):
  rows.append(row);json.dump(rows,open(ROOT+('/net4_tradeoff.json' if tradeoff else '/net4_results.json'),'w'),indent=2)
  print(row,flush=True)
