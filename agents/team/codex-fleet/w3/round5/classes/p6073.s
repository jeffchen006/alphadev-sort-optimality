# n=5 model=out iset=I1 prefix14_class=6073
cmp P3, P0
cmovge S2, P3
cmovl S2, P0
cmovle P0, P3
mov P3, P1
cmp P1, P2
cmovl P1, P2
mov S1, P1
cmovle P2, P3
cmp S2, P1
cmovle P1, S2
cmovg S1, S2
cmp P0, P2
cmovge S0, P0
