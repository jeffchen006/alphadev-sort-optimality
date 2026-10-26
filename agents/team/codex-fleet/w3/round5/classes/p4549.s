# n=5 model=out iset=I1 prefix14_class=4549
mov S1, P0
mov S2, P3
cmp S1, P2
cmovge S1, P2
cmovle P0, P2
cmp P3, P1
cmovge S2, P1
cmovle P3, P1
cmp P3, P0
mov S0, P0
cmovg P1, S2
cmovl S0, P3
cmovg P0, P3
cmp S1, S2
