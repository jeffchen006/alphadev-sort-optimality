# n=5 model=out iset=I1 prefix14_class=2163
mov S1, P0
cmp S1, P1
cmovle P0, P1
cmovge S1, P1
cmp P2, P3
cmovl P1, P3
cmovl P3, P2
cmovl P2, P1
mov S0, P0
cmp P2, S0
cmovg P0, P2
cmovl S0, P2
cmp P3, S1
cmovge P2, P3
