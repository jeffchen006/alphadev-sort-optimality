# n=5 model=out iset=I1 prefix14_class=7143
mov S1, P1
cmp S1, P2
mov S2, P3
cmovle P1, P2
cmovle P2, S1
cmp P3, P0
cmovg S2, P0
mov S0, P2
cmovle P3, P0
cmp S2, S0
cmovg P2, S2
cmovge S2, S0
cmp P3, P1
cmovg S0, P1
