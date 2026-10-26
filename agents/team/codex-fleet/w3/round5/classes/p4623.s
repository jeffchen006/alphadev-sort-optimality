# n=5 model=out iset=I1 prefix14_class=4623
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovl P3, P1
cmp P2, P0
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P2, S2
cmovge P1, P2
cmovl P1, S2
cmovge P2, S2
cmp P0, P3
cmovle P1, P3
