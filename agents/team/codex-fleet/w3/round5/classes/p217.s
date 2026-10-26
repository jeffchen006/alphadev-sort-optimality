# n=5 model=out iset=I1 prefix14_class=217
mov S2, P3
cmp P0, P2
mov S1, P2
cmovle P2, P0
cmovg S1, P0
cmp P3, P1
cmovge S2, P1
mov S0, S2
cmovg P1, P3
cmp S2, P2
cmovl S2, P2
cmovle P2, S0
cmovl S0, S2
mov P0, P1
