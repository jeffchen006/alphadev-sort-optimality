# n=5 model=out iset=I1 prefix14_class=1862
mov S2, P3
mov S1, P0
cmp P2, P3
cmovle P3, P2
cmovge S2, P2
cmp P1, S1
cmovl S1, P1
cmovg P0, P1
cmp P0, S2
mov S0, P0
cmovle P0, S2
cmovl S2, S0
cmp S1, P3
mov P2, S2
