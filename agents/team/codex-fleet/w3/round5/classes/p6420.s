# n=5 model=out iset=I1 prefix14_class=6420
mov S1, P2
cmp S1, P3
cmovg P2, P3
cmovg P3, S1
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
cmovge S1, P0
cmovl P0, S1
cmp P3, S1
cmovge P0, P3
cmovl S1, P3
cmp P2, P1
cmovge S0, P1
