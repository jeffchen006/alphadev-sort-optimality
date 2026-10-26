# n=5 model=out iset=I1 prefix14_class=14445
cmp P0, P3
cmovl S1, P3
cmovge S1, P0
cmovl P3, P0
mov S2, P1
cmp S2, P2
cmovg S2, P2
mov S0, S1
cmovle P1, P2
cmp S2, P3
cmovle P0, P3
cmovl P3, S2
cmovl S2, P0
mov P2, S2
