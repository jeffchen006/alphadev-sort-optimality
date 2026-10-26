# n=5 model=out iset=I1 prefix14_class=7357
cmp P3, P1
mov S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P0, P2
mov S0, P2
cmovge P2, P0
cmovl S0, P0
cmp P1, S0
cmovle P0, P1
cmovle P1, S0
mov S2, P2
cmovl S0, P0
cmp P3, S2
