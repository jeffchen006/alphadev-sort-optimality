# n=5 model=out iset=I1 prefix14_class=3998
mov S1, P1
cmp P1, P0
cmovl P1, P0
cmovge S1, P0
mov S0, P3
cmp S0, P2
mov P0, S1
cmovge S0, P2
cmovge P2, P3
cmp P0, S0
cmovg P0, S0
cmovge S0, S1
cmp P1, P2
cmovg P3, P2
