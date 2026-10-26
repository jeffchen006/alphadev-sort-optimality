# n=5 model=out iset=I1 prefix14_class=11662
mov S2, P0
cmp S2, P3
cmovl P0, P3
cmovge S2, P3
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
cmovge S0, P2
cmp P0, S0
cmovg P3, S0
cmovge S0, P0
cmovg P0, P3
cmp P1, S2
cmovle P3, S2
