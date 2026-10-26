# n=5 model=out iset=I1 prefix14_class=6849
cmp P2, P3
cmovl S2, P3
cmovl P3, P2
cmovl P2, S2
cmp P1, P0
mov S2, P0
cmovl P0, P1
cmovle P1, S2
cmp P2, P1
cmovl S2, P2
cmovge S2, P1
cmovge P1, P2
cmp P3, P0
cmovge S0, P3
