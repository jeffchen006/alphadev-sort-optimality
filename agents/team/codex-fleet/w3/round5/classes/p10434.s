# n=5 model=out iset=I1 prefix14_class=10434
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
cmovl P2, S2
mov S0, P0
cmp S0, P1
mov S1, P2
cmovl P0, P1
cmovge S0, P1
cmp P0, P2
cmovle P2, P0
cmovle P0, S1
cmp P3, S0
cmovle P0, P3
