# n=5 model=out iset=I1 prefix14_class=993
mov S2, P2
cmp P1, S2
cmovl P2, P1
mov S0, P0
cmovge S2, P1
cmp P0, P3
mov S1, P2
cmovg P0, P3
cmovge P3, S0
cmp S2, P3
cmovge P1, P3
cmovge P3, S2
cmovge S2, P1
cmp P0, S1
