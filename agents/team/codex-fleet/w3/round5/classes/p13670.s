# n=5 model=out iset=I1 prefix14_class=13670
cmp P3, P2
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
mov S1, P1
cmp P1, P0
mov S0, P3
cmovg P1, P0
cmovl S1, P0
cmp S0, S1
cmovg S0, S1
cmovge S1, P3
cmp P2, P1
mov P3, S0
