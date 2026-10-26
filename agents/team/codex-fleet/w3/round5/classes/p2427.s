# n=5 model=out iset=I1 prefix14_class=2427
mov S2, P0
mov S1, P1
cmp P2, P0
cmovle P0, P2
cmovg S2, P2
cmp P1, P3
cmovle P1, P3
cmovle P3, S1
mov S0, P1
cmp S2, P1
cmovge S0, S2
mov S0, P0
cmovg S2, P1
cmp P3, P0
