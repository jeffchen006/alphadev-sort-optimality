# n=5 model=out iset=I1 prefix14_class=4857
mov S2, P3
mov S0, P0
cmp P0, P1
cmovg P0, P1
cmovl S0, P1
mov S1, P0
cmp P2, P3
cmovge S2, P2
cmovle P3, P2
cmp P0, P3
cmovl S1, P3
cmovl P3, P0
cmp S0, S2
cmovle P0, S0
