# n=5 model=out iset=I1 prefix14_class=8681
mov S1, P0
mov S0, P1
cmp S1, P2
cmovl S1, P2
mov S2, S1
cmovg P0, P2
cmp P3, S0
cmovl S0, P3
cmovle P3, P1
cmp P3, S1
cmovg S2, P3
cmovg P3, S1
cmp P0, S0
cmovge S2, S0
