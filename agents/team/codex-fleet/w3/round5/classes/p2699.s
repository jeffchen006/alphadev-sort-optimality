# n=5 model=out iset=I1 prefix14_class=2699
cmp P2, P1
cmovl S1, P2
mov S0, P0
cmovge S1, P1
cmovg P1, P2
cmovl P2, P1
cmp S0, P3
cmovl S0, P3
cmovge P0, P3
cmp P1, S0
cmovl P2, S0
cmovge P1, S0
cmp P0, S1
cmovle P2, S1
