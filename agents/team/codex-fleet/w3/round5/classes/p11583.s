# n=5 model=out iset=I1 prefix14_class=11583
cmp P0, P1
mov S2, P0
mov S0, P2
cmovle P0, P1
cmovl P1, S2
cmp S0, P3
cmovge P2, P3
cmovl S0, P3
mov S1, P1
cmp P2, S1
cmovle P1, P2
cmovl P2, S1
cmp S0, P0
cmovge P3, P0
