# n=5 model=out iset=I1 prefix14_class=2755
cmp P3, P0
cmovge S1, P3
cmovl S1, P0
cmovge P3, P0
mov P0, P1
cmp P0, P2
cmovge P0, P2
cmovle P1, P2
cmp S1, P1
cmovl S2, P1
cmovl P1, S1
cmovl S1, S2
mov S0, P0
cmp P0, P3
