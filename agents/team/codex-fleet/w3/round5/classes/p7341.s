# n=5 model=out iset=I1 prefix14_class=7341
mov S0, P1
cmp P0, S0
mov S2, P3
cmovl P1, P0
cmovge S0, P0
cmp P2, P3
cmovle P3, P2
cmovl P2, S2
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
mov P0, S0
cmovl P3, S2
cmp P0, P2
