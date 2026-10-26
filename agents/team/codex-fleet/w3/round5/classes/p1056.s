# n=5 model=out iset=I1 prefix14_class=1056
mov S1, P3
mov S0, P0
cmp P0, P1
cmovl S0, P1
cmovl P1, P0
cmp S1, P2
cmovge S1, P2
cmovg P2, P3
cmp P2, S0
mov S2, P2
cmovge P2, S0
cmovge S0, S2
mov S2, P1
mov P0, P2
