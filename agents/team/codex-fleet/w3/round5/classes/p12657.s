# n=5 model=out iset=I1 prefix14_class=12657
mov S2, P1
cmp P3, S2
cmovl P1, P3
cmovge S2, P3
cmp P2, P0
mov S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P1, P0
cmovl P3, P0
cmovle P0, P1
cmovl P1, P3
mov S1, P2
cmp S1, S2
