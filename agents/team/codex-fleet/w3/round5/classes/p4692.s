# n=5 model=out iset=I1 prefix14_class=4692
mov S0, P0
mov S1, P2
cmp P1, S0
cmovge S0, P1
cmovl P0, P1
cmp S1, P3
cmovg P2, P3
cmovl S1, P3
cmp S1, S0
mov P1, P2
cmovg S2, S0
cmovg S0, S1
cmovg S1, S2
cmp P2, P0
