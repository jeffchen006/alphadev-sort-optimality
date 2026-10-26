# n=5 model=out iset=I1 prefix14_class=278
cmp P0, P3
mov S1, P0
cmovg P0, P3
mov S0, P2
cmovg P3, S1
cmp P1, S0
cmovge S0, P1
mov S2, P0
cmovle P2, P1
cmp P2, P0
cmovl P0, P2
cmovl P2, S2
cmp S0, P3
cmovl S2, P3
