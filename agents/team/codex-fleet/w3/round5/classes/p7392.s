# n=5 model=out iset=I1 prefix14_class=7392
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P0, P1
cmovge S2, P0
mov S0, P3
cmovge P0, P1
cmovg P1, S2
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
cmovg P2, S1
cmp P1, S0
