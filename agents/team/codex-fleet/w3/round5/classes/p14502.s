# n=5 model=out iset=I1 prefix14_class=14502
cmp P2, P1
cmovge S0, P2
cmovg P2, P1
cmovg P1, S0
mov S1, P2
cmp P0, P3
mov S2, P3
cmovle P3, P0
cmovle P0, S2
cmp S1, P3
cmovl S1, P3
cmovle P3, P2
cmp P0, P1
cmovg P2, S1
