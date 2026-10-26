# n=5 model=out iset=I1 prefix14_class=13253
mov S1, P1
cmp P2, S1
cmovl S1, P2
mov S0, P0
cmovl P2, P1
cmp S0, P3
cmovle P0, P3
cmovle P3, S0
cmp S1, P3
cmovl S0, P3
cmovl P3, S1
cmovl S1, S0
cmp P0, P2
cmovge P3, P0
