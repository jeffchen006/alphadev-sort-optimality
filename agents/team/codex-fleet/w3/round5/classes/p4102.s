# n=5 model=out iset=I1 prefix14_class=4102
mov S0, P2
cmp P3, P2
cmovl P2, P3
mov S2, P1
cmovge S0, P3
cmp P0, P1
cmovg S2, P0
cmovge P0, P1
cmp P2, P0
cmovge P1, P0
cmovg P0, P2
cmovg P2, P1
mov S1, S2
cmp S0, S2
