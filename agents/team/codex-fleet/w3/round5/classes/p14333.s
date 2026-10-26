# n=5 model=out iset=I1 prefix14_class=14333
cmp P3, P2
mov S1, P1
mov S2, P3
cmovg P3, P2
cmovge P2, S2
cmp S1, P0
cmovl P1, P0
cmovge S1, P0
cmp P3, S1
mov S0, P2
cmovle P0, S1
cmovl S1, P3
cmovl P3, P0
cmp P1, P2
