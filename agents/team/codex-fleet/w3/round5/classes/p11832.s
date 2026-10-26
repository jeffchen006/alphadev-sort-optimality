# n=5 model=out iset=I1 prefix14_class=11832
cmp P0, P1
cmovl S0, P0
mov S1, P2
cmovle P0, P1
cmovl P1, S0
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
mov S2, P0
cmp S1, P0
cmovg P0, S1
cmovl S2, S1
cmp P1, P3
cmovge P0, P3
