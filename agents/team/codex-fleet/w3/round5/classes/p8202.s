# n=5 model=out iset=I1 prefix14_class=8202
mov S2, P1
cmp P2, S2
cmovl S2, P2
cmovl P2, P1
cmp P3, P0
mov S0, S2
cmovl P1, P0
cmovle P0, P3
cmovl P3, P1
cmp P0, S2
mov S1, P2
cmovge S2, P0
cmovge P0, S0
cmp P2, P3
