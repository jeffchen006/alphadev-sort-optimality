# n=5 model=out iset=I1 prefix14_class=884
cmp P3, P0
cmovl S0, P0
cmovle P0, P3
cmovl P3, S0
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
mov S0, P3
cmovg P2, S2
cmp P2, P3
cmovg P3, P2
cmovl S0, P2
mov S1, P0
cmp S1, P1
