# n=5 model=out iset=I1 prefix14_class=13665
mov S2, P1
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmp P2, P0
cmovl P1, P2
cmovle P2, P0
mov S1, S2
cmovl P0, P1
cmp P3, P2
cmovge S0, P3
cmovge P3, P2
cmovg P2, S0
cmp P0, S1
