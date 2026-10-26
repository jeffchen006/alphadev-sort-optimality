# n=5 model=out iset=I1 prefix14_class=7332
mov S0, P3
cmp P0, S0
cmovge S0, P0
mov S2, P1
cmovle P3, P0
cmp P2, P1
cmovle P1, P2
cmovl P2, S2
cmp P1, P3
cmovle P0, P1
cmovl P1, P3
cmovl P3, P0
mov S2, S0
cmp S2, P2
