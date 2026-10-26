# n=5 model=out iset=I1 prefix14_class=1941
mov S0, P3
mov S2, P1
cmp P2, S0
cmovl P3, P2
cmovl P2, S0
cmp P0, S2
cmovl S2, P0
cmovle P0, P1
cmp P0, P2
mov P1, P2
cmovge P2, P0
cmovl P1, P0
cmp P3, S2
cmovge S0, P3
