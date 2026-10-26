# n=5 model=out iset=I1 prefix14_class=6014
mov S0, P1
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P0, S0
cmovle P1, P0
cmovl P0, S0
mov S1, P0
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmp P3, P1
cmovg P2, P1
