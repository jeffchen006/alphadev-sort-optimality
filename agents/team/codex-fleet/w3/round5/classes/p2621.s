# n=5 model=out iset=I1 prefix14_class=2621
mov S2, P1
cmp P0, S2
cmovge S2, P0
cmovg P0, P1
cmp P2, P3
mov P1, P0
cmovl S0, P3
cmovle P3, P2
cmovge S0, P2
cmp S0, S2
cmovl S1, S2
cmovl S2, S0
cmovl S0, S1
cmp P3, P0
