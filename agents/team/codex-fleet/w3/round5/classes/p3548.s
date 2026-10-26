# n=5 model=out iset=I1 prefix14_class=3548
cmp P3, P0
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
mov S2, P1
mov S1, P0
cmp S2, P2
cmovl S2, P2
cmovle P2, P1
cmp P2, P0
cmovl S1, P2
cmovge P0, P2
cmp P3, S2
cmovge P2, P0
