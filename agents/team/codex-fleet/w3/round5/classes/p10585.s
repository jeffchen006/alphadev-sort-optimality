# n=5 model=out iset=I1 prefix14_class=10585
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
mov S2, P1
cmp P3, S2
cmovl S2, P3
cmovg P1, P3
mov P3, P1
cmp P3, P0
cmovl P3, P0
cmovle P0, P1
cmp P2, S2
cmovg P3, S2
