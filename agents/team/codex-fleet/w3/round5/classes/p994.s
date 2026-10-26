# n=5 model=out iset=I1 prefix14_class=994
mov S2, P2
cmp P1, S2
mov S0, P0
cmovl P2, P1
cmovge S2, P1
mov S1, P2
cmp P0, P3
cmovge P0, P3
cmovge P3, S0
cmp S2, P3
cmovge S0, P3
cmovge P3, S2
cmovg S2, S0
cmp P0, S1
