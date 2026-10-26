# n=5 model=out iset=I1 prefix14_class=483
cmp P2, P3
mov S1, P0
mov S0, P3
cmovl P3, P2
cmovge S0, P2
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmp P3, S1
cmovle P0, S1
cmovl S1, P3
cmovl P3, P0
cmp S0, P1
cmovge P0, S0
