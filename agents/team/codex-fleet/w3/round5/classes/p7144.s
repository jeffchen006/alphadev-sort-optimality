# n=5 model=out iset=I1 prefix14_class=7144
cmp P2, P0
mov S0, P0
cmovge S0, P2
mov S1, P3
cmovl P0, P2
cmp S1, P1
cmovge S1, P1
cmovl P3, P1
cmp P0, S1
cmovg S2, S1
cmovge S1, P0
cmovg P0, S2
mov P2, P3
cmp S0, P3
