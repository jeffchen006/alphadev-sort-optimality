# n=5 model=out iset=I1 prefix14_class=8464
mov S2, P0
cmp P2, S2
mov S1, P1
cmovl S2, P2
cmovl P2, P0
cmp S1, P3
cmovl S1, P3
cmovle P3, P1
mov S0, P2
cmp S1, S0
cmovl S0, S1
cmovl S1, P2
cmp P3, S2
cmovge P1, P3
