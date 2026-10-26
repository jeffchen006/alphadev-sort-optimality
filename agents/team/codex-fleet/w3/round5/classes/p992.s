# n=5 model=out iset=I1 prefix14_class=992
mov S2, P0
cmp P1, S2
cmovl P0, P1
mov S0, P2
cmovge S2, P1
cmp P2, P3
mov S1, P0
cmovg P2, P3
cmovge P3, S0
cmp S2, P3
cmovge P1, P3
cmovge P3, S2
cmovge S2, P1
cmp P2, S1
