# n=5 model=out iset=I1 prefix14_class=1645
cmp P1, P2
cmovge S1, P1
cmovl S1, P2
cmovg P1, P2
cmp P3, P0
mov S0, P0
cmovle P0, P3
mov S2, P0
cmovge S0, P3
cmp P0, P1
cmovle P0, P1
cmovge S2, P1
cmovg P1, P0
cmp S0, S1
