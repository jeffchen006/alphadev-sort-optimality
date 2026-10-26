# n=5 model=out iset=I1 prefix14_class=4912
cmp P1, P2
cmovl S0, P2
cmovge S0, P1
mov S2, P3
cmovle P2, P1
mov S1, P2
cmp P0, S2
cmovl P3, P0
cmovle P0, S2
cmp P2, P3
cmovge S1, P3
cmovle P2, P3
cmp P0, S0
mov S1, S0
