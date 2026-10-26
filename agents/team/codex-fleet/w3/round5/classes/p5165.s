# n=5 model=out iset=I1 prefix14_class=5165
mov S1, P0
cmp P0, P3
mov S0, P1
cmovle P0, P3
cmovl P3, S1
cmp P2, S0
cmovl S0, P2
cmovl P2, P1
cmp S0, P3
cmovge P1, S0
cmovge S0, P3
cmovg P3, P1
mov S0, P0
cmp P2, S0
