# n=5 model=out iset=I1 prefix14_class=4011
mov S2, P0
cmp P0, P1
mov S0, P3
cmovl P0, P1
cmovge S2, P1
mov S1, S2
cmp S0, P2
cmovg P3, P2
cmovge P2, S0
cmp S1, P3
cmovge S2, P3
cmovge P3, S1
cmp P0, P2
cmovge P1, P0
