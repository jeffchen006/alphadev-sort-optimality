# n=5 model=out iset=I1 prefix14_class=10020
cmp P2, P3
cmovl S0, P3
cmovle P3, P2
cmovl P2, S0
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovl S1, P0
mov P0, S1
cmp S1, P2
cmovle P0, P2
cmovle P2, S1
mov S2, P3
cmp P1, S2
