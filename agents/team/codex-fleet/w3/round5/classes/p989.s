# n=5 model=out iset=I1 prefix14_class=989
mov S2, P0
cmp P1, S2
cmovge S2, P1
cmovl P0, P1
mov P1, P3
cmp P1, P2
cmovg P1, P2
mov S1, P1
cmovge P2, P3
mov S0, P2
cmp S2, P2
cmovge P2, S2
cmovge S2, S0
cmp P0, S1
