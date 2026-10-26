# n=5 model=out iset=I1 prefix14_class=12324
mov S2, P2
cmp S2, P3
cmovg P2, P3
cmovg P3, S2
mov S1, P0
cmp P0, P1
cmovl S1, P1
cmovl P1, P0
cmp P2, P1
cmovge S0, P2
cmovg P2, P1
cmovge P1, S0
cmp P3, S1
mov S2, P1
