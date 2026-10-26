# n=5 model=out iset=I1 prefix14_class=5885
mov S2, P0
cmp P2, P0
cmovge P0, P2
cmovg P2, S2
cmp P1, P3
mov S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
cmovl S1, P1
cmp P3, P2
cmovle P1, P3
