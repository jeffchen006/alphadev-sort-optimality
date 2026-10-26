# n=5 model=out iset=I1 prefix14_class=11879
cmp P1, P3
cmovl S2, P3
cmovge S2, P1
cmovl P3, P1
cmp P2, P0
mov S1, P3
mov S0, P2
cmovg P2, P0
cmovl S0, P0
cmp S2, S0
cmovle P1, S2
cmovl S2, S0
cmovl S0, P1
cmp S1, P2
