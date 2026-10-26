# n=5 model=out iset=I1 prefix14_class=6556
cmp P0, P3
mov S0, P0
cmovl S0, P3
cmovge P0, P3
cmp P1, P2
mov S2, S0
cmovle P3, P1
cmovl P1, P2
cmovl P2, P3
cmp P1, S2
cmovl S2, P1
cmovge S0, P1
cmp P2, P0
mov S1, P2
