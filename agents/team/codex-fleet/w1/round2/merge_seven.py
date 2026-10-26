import pathlib,re
p=pathlib.Path(__file__).resolve().parent
prefix=(p/'extend7_prefix.err').read_text().splitlines()[-1]
m=re.fullmatch(r'c=7 done=(\d+) nodes=(\d+) leaves=(\d+) wins=(\d+) seconds=([\d.]+)',prefix)
assert m and int(m[1])==13900
segments=[(0,13900,int(m[2]),int(m[3]),int(m[4]),float(m[5]))]
for name,begin,end in [('extend7_tail_a.log',13900,14402),('extend7_tail_b.log',14402,14904)]:
 text=(p/name).read_text();q=re.search(r'COMPLETE c=7 begin=(\d+) end=(\d+) leaves=(\d+) functional=(\d+) seconds=([\d.]+)',text)
 assert q and int(q[1])==begin and int(q[2])==end,name
 nodes=sum(map(int,re.findall(r'depth=\d+ nodes=(\d+)',text)))
 segments.append((begin,end,nodes,int(q[3]),int(q[4]),float(q[5])))
nodes=sum(s[2] for s in segments);leaves=sum(s[3] for s in segments);wins=sum(s[4] for s in segments);seconds=sum(s[5] for s in segments)
lines=[f'SEGMENT begin={b} end={e} nodes={n} leaves={l} functional={w} seconds={s}' for b,e,n,l,w,s in segments]
lines+=[f'COMPLETE c=7 begin=0 end=14904 leaves={leaves} functional={wins} seconds={seconds:.6f}',f'node_total={nodes}','Seconds are the sum of completed-segment wall times. The two suffix segments ran in parallel.']
(p/'extend7.log').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines))
