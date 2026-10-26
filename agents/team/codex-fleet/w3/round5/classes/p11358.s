# n=5 model=out iset=I1 prefix14_class=11358
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
mov S0, P2
cmovl S0, P1
cmovg P2, P1
cmp S0, P0
cmovge S1, P0
cmovg P0, S0
cmovg S0, S1
cmp P3, P2
mov S2, S0
