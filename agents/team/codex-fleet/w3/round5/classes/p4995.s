# n=5 model=out iset=I1 prefix14_class=4995
cmp P3, P0
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
cmp P2, P1
mov S1, P1
cmovge P1, P2
cmovg P2, S1
cmp P0, P2
cmovl S2, P2
cmovle P2, P0
mov S0, P3
cmovl P0, S2
cmp S0, P1
