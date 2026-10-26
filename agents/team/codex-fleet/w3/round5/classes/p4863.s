# n=5 model=out iset=I1 prefix14_class=4863
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmovge P0, S1
cmp P1, P2
cmovl S0, P2
cmovl P2, P1
cmovl P1, S0
mov S1, P2
cmp P2, P3
cmovl S1, P3
cmovle P3, P2
mov S2, S1
cmp P0, P1
