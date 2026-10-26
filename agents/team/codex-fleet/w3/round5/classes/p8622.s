# n=5 model=out iset=I1 prefix14_class=8622
mov S2, P2
cmp P3, P2
cmovg S2, P3
cmovl P2, P3
cmp P0, P1
mov S1, P2
cmovge S0, P0
cmovge P0, P1
cmovge P1, S0
cmp P1, S2
cmovge S0, S2
cmovge S2, P1
cmovge P1, S0
cmp P2, P0
