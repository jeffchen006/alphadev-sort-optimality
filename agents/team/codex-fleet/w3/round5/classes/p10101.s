# n=5 model=out iset=I1 prefix14_class=10101
cmp P1, P2
cmovge S1, P1
cmovl S1, P2
cmovle P2, P1
mov S2, P0
cmp P0, P3
cmovge P0, P3
cmovg P3, S2
cmp S1, P3
mov P1, P2
cmovl S0, S1
cmovl S1, P3
cmovl P3, S0
cmp P0, P2
