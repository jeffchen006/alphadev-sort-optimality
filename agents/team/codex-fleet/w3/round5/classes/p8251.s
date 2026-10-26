# n=5 model=out iset=I1 prefix14_class=8251
cmp P3, P2
mov S1, P1
cmovl S0, P3
cmovge S0, P2
cmovl P3, P2
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
cmp S0, P0
cmovg S2, P0
cmovle S2, S0
cmovl S0, P0
cmp P3, S1
cmovl S2, P3
