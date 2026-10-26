from pathlib import Path
import json,subprocess,sys
rows=json.loads(Path('round6/artifacts/seeds.json').read_text());rows={r['name']:r for r in rows}
# One CPU job per dispatcher. Both dispatchers together use two CPU cores.
plans={
 'a': [('net41_c9_0',0.6,9,9),('net41_c9_1',1.5,9,9),('partner_0',3,9,9),('partner_3',6,9,9),('near9_c9_0',1.2,8,9),('partner_8',10,7,9)],
 'b': [('c8_c7_0',0.8,7,7),('c8_c7_1',2,7,7),('c8_c7_0',5,7,7),('partner_1',1,9,9),('partner_5',3,9,9),('near9_c9_0',0.5,9,9)]}
for i,(seed,temp,mn,mx) in enumerate(plans[sys.argv[1]]):
 name=f'mem_{sys.argv[1]}{i}_c{mn}t{temp}';row=rows[seed];cmd=['round6/bin/mcmc2','-n','5','-m','mem','-L','41','-S',str(row['registers']+1),'-i','I1','-start',row['mem'],'-mincmp',str(mn),'-maxcmp',str(mx),'-T',str(temp),'-lam','0.1','-time','75','-iters','10000000000','-restart','0.000003','-seed',str(6261000+100*ord(sys.argv[1])+i),'-out','round6/candidates/'+name]
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py','165',name,*cmd],check=True)
 if Path('round6/artifacts/FOUND').exists():break
