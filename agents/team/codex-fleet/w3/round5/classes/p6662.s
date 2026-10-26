# n=5 model=out iset=I1 prefix14_class=6662
mov S2, P1
cmp P2, P1
cmovg S2, P2
cmovl P1, P2
mov S0, S2
mov S1, P0
cmp P0, P3
cmovg P0, P3
cmovl S1, P3
cmp S1, S0
cmovg S2, S1
cmovl S0, S1
cmovge S1, P0
cmp P0, P1
