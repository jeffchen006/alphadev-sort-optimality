# n=5 model=out iset=I1 prefix14_class=5684
mov S0, P1
mov S2, P0
cmp S0, P2
cmovge P1, P2
cmovg P2, S0
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
mov S1, S2
cmp P1, S1
cmovl S1, P1
cmovl P1, S2
cmp P3, P2
cmovge S2, P2
