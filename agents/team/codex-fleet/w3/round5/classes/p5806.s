# n=5 model=out iset=I1 prefix14_class=5806
mov S0, P3
cmp S0, P1
mov S2, P2
cmovge S0, P1
cmovge P1, P3
cmp P2, P0
cmovge S2, P0
mov S1, S0
cmovge P0, P2
cmp S2, S0
cmovge S0, S2
cmovge S2, S1
cmp P1, P0
cmovge P3, P0
