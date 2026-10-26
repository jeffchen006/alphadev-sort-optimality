# n=5 model=out iset=I1 prefix14_class=2758
cmp P0, P2
cmovge S1, P0
cmovl S1, P2
cmovg P0, P2
mov P2, P3
cmp P3, P1
cmovl P3, P1
cmovge P2, P1
mov S2, P2
cmp S1, P3
cmovl S0, P3
cmovle P3, S1
cmovl S1, S0
cmp S2, P0
