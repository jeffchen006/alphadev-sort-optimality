# n=5 model=out iset=I1 prefix14_class=3490
mov S2, P2
cmp P3, P1
mov S1, P1
cmovl S1, P3
cmovle P3, P1
cmp S2, P0
cmovl S2, P0
cmovg P2, P0
mov S0, P2
cmp S1, P2
cmovg S0, S1
cmovge S1, P2
mov P2, S2
cmp S2, P3
