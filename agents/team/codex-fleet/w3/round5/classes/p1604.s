# n=5 model=out iset=I1 prefix14_class=1604
mov S2, P2
mov S0, P0
cmp P0, P3
cmovge P0, P3
cmovl S0, P3
cmp P1, P2
cmovge S2, P1
cmovl P2, P1
mov S1, P0
mov P3, S0
cmp P0, P2
cmovl S1, P2
cmovle P2, P0
cmovle P0, S1
