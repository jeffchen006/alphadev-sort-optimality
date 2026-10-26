# n=5 model=out iset=I1 prefix14_class=556
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovg P1, S0
mov S2, P2
cmp S2, P0
cmovg P2, P0
cmovl S2, P0
mov P0, P3
mov S1, S2
cmp P2, P3
cmovl P0, P2
cmovg P3, P2
cmp P1, S2
