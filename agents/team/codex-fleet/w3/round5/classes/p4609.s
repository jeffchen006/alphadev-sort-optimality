# n=5 model=out iset=I1 prefix14_class=4609
mov S1, P2
cmp P2, P3
cmovl S1, P3
mov S2, S1
cmovl P3, P2
mov S0, P3
cmp P0, P1
cmovle P2, P1
cmovl P1, P0
cmovle P0, P2
cmp P0, S1
cmovge S2, P0
cmovl S1, P0
cmp P1, P3
