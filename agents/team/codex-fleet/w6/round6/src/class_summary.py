from pathlib import Path
import re,json,collections
rows=[];total=collections.Counter()
for p in sorted(Path('round6/logs').glob('class_*_two.log')):
 s=[l for l in p.read_text().splitlines() if l.startswith('SUMMARY')]
 if not s:continue
 r={k:float(v) if '.' in v else int(v) for k,v in re.findall(r'(\w+)=([\d.]+)',s[-1])};r['file']=str(p);rows.append(r)
 for k in ['singles','pairs','tried','filtered','full','hits']:total[k]+=r[k]
print(json.dumps(dict(seeds=len(rows),totals=dict(total)),indent=2))
