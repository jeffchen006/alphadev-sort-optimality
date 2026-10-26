# n=5 model=out iset=I1 prefix14_class=161
mov S0, P2
cmp P2, P0
cmovge S0, P0
cmovl P2, P0
cmp P3, P1
cmovle P0, P1
cmovle P1, P3
cmovle P3, P0
cmp S0, P1
cmovge S1, S0
cmovl S1, P1
cmovg S0, P1
mov S0, P3
cmp P3, P2
