# n=5 model=out iset=I1 prefix14_class=11567
cmp P0, P2
mov S0, P1
mov S2, P2
cmovge P2, P0
cmovl S2, P0
cmp P3, S0
cmovl P1, P3
cmovl P3, S0
cmp P1, S2
cmovle P0, S2
cmovl S2, P1
cmovl P1, P0
mov S0, P3
cmp P2, P3
