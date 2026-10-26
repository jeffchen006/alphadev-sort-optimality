# n=5 model=out iset=I1 prefix14_class=5857
mov S2, P3
cmp P3, P2
cmovge S2, P2
cmovle P3, P2
cmp P0, P1
cmovl S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P0, P3
mov S0, P3
cmovl P3, P0
cmovg S0, P0
mov P2, S2
cmp S2, P1
