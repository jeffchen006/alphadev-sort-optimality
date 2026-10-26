# n=5 model=out iset=I1 prefix14_class=9868
mov S0, P2
cmp P1, P0
cmovge S2, P0
cmovge P0, P1
cmovge P1, S2
cmp P3, P2
mov S1, P0
cmovge S0, P3
cmovge P3, P2
cmp S0, S1
cmovge S1, S0
cmovg S0, P0
cmovle P0, S0
cmp P1, P3
