# n=5 model=out iset=I1 prefix14_class=7458
cmp P3, P0
mov S0, P0
cmovge S0, P3
cmovle P0, P3
mov S2, P1
cmp P2, S2
cmovle P1, P2
cmovl P2, S2
cmp P0, P1
cmovle P3, P0
cmovle P0, P1
cmovl P1, P3
mov S1, P2
cmp P2, S0
