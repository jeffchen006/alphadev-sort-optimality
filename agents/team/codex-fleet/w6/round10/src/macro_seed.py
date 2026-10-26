from pathlib import Path
lines=[l.split('#')[0].strip() for l in Path('round5/verified/macro9one_sort_813.s').read_text().splitlines()]
lines=[l for l in lines if l and not l.startswith('out')]
assert len(lines)==36
csv=[]
for j in range(0,36,4):
    op,a,b=lines[j].replace(',',' ').split();assert op=='cmp'
    op,s,c=lines[j+1].replace(',',' ').split();assert op=='mov'
    op,cc,d=lines[j+2].replace(',',' ').split();assert op=='cmovg' and cc==c
    csv.append(' '.join(x[1:] for x in [a,b,c,d]))
Path('round10/artifacts/macro_seed.csv').write_text('\n'.join(csv)+'\n')
