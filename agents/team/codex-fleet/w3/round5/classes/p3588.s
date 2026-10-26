# n=5 model=out iset=I1 prefix14_class=3588
mov S1, P2
cmp S1, P1
mov S0, P3
cmovle P2, P1
cmovle P1, S1
cmp P0, P3
cmovle P3, P0
cmovge S0, P0
cmp P1, P3
cmovl S2, P3
cmovl P3, P1
cmovl P1, S2
mov P0, S0
cmp P0, P2
