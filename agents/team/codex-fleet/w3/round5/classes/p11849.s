# n=5 model=out iset=I1 prefix14_class=11849
mov S0, P3
cmp P3, P1
cmovl P3, P1
cmovge S0, P1
cmp P2, P0
cmovle P1, P2
cmovl P2, P0
cmovl P0, P1
mov S2, P3
cmp P2, P3
cmovle P3, P2
cmovl P2, S2
mov S1, S0
cmp P0, S1
