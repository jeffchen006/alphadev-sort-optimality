# n=5 model=out iset=I1 prefix14_class=14024
cmp P3, P2
cmovl S2, P3
cmovl P3, P2
mov S1, P3
cmovge S2, P2
cmp P0, P1
cmovle P2, P0
cmovl P0, P1
cmovl P1, P2
cmp S1, P0
cmovg S1, P0
mov S0, P1
cmovl P3, P0
cmovle P0, S1
