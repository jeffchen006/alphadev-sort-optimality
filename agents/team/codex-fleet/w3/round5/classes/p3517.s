# n=5 model=out iset=I1 prefix14_class=3517
cmp P1, P3
mov S2, P0
cmovge S1, P1
cmovg P1, P3
mov S0, P1
cmovge P3, S1
cmp P2, S2
cmovg P0, P2
cmovl S2, P2
cmp S2, P1
cmovge S0, S2
mov P2, P0
cmovge S2, P1
cmp P3, P2
