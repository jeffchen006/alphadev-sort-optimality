# n=5 model=out iset=I1 prefix14_class=1033
mov S1, P3
cmp S1, P1
cmovl P3, P1
cmovl P1, S1
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmovge P2, S0
cmp P2, P3
mov S2, P3
cmovge S2, P2
mov S2, P1
cmovg P2, P3
cmp S2, P0
