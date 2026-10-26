# n=5 model=out iset=I1 prefix14_class=6544
cmp P1, P3
cmovl S0, P3
cmovge S0, P1
mov S1, P2
cmovle P3, P1
cmp S1, P0
cmovl S1, P0
cmovle P0, P2
mov S2, S1
cmp S2, S0
cmovg S1, S0
cmovl S2, S0
cmp P0, P3
cmovl S0, S1
