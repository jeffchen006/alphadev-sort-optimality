# n=5 model=out iset=I1 prefix14_class=1478
mov S0, P2
mov S1, P0
cmp P0, P3
cmovle P0, P3
cmovg S1, P3
cmp S0, P1
cmovle P2, P1
cmovle P1, S0
cmp P0, P2
cmovg P3, P2
mov S2, S1
cmovg P2, P0
cmovg P0, P3
cmp P1, S2
