# n=5 model=out iset=I1 prefix14_class=10584
mov S2, P2
mov S0, P0
cmp S0, P3
cmovle P0, P3
cmovl P3, S0
cmp P1, P2
cmovl S2, P1
mov S1, S2
cmovge P2, P1
cmp P2, P0
cmovle P1, P2
cmovle P2, P0
cmovle P0, P1
cmp P3, S2
