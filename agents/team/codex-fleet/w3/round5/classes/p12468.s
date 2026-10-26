# n=5 model=out iset=I1 prefix14_class=12468
mov S2, P3
cmp S2, P0
mov S0, P2
cmovle P3, P0
cmovge S2, P0
cmp P2, P1
cmovg S0, P1
cmovg P1, P2
cmp S0, S2
cmovg S1, S2
cmovg S2, S0
cmovg S0, S1
cmp P3, P1
cmovle P2, P1
