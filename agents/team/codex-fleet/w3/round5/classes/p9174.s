# n=5 model=out iset=I1 prefix14_class=9174
cmp P3, P1
cmovl S2, P3
cmovge S2, P1
cmovge P1, P3
cmp P0, P2
cmovle P3, P2
cmovl P2, P0
cmovl P0, P3
cmp P2, S2
cmovge S0, P2
cmovg P2, S2
cmovge S2, S0
mov S1, P1
cmp P0, S1
