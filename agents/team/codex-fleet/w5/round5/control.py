from pathlib import Path
HERE=Path(__file__).resolve().parent
rows=(HERE/'seeds/000.txt').read_text().splitlines()
# The second copy is idempotent. Its flags are unchanged.
i=next(i for i,line in enumerate(rows) if line.startswith('cmov'))
rows.insert(i+1,rows[i]);nr,k=map(int,rows[0].split());rows[0]=f'{nr} {k+1}'
p=HERE/'seeds/control33.txt';p.write_text('\n'.join(rows)+'\n')
(HERE/'control_list.txt').write_text(str(p)+'\n')
