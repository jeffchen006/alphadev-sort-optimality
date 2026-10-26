# n=5 model=out iset=I1 prefix14_class=998
mov S2, P2
cmp P3, S2
mov S0, P0
cmovge S2, P3
cmovle P2, P3
cmp S0, P1
cmovge P0, P1
cmovge P1, S0
cmp S2, P1
cmovge S1, P1
mov S0, P2
cmovge P1, S2
cmovge S2, S1
cmp P0, S0
