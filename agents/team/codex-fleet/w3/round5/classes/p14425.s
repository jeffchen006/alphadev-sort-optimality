# n=5 model=out iset=I1 prefix14_class=14425
cmp P2, P1
mov S0, P2
cmovle P2, P1
cmovge S0, P1
cmp P0, P3
mov S1, P3
cmovl S1, P0
cmovg P3, P0
mov S2, S1
cmp S2, S0
cmovl S1, P3
cmovge S2, S0
cmovge S0, S1
cmp P2, P3
