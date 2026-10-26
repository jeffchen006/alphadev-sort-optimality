# n=5 model=out iset=I1 prefix14_class=12380
mov S0, P2
cmp S0, P0
cmovge S0, P0
mov S2, S0
cmovle P2, P0
cmp P1, P3
cmovle P0, P3
cmovl P3, P1
cmovle P1, P0
cmp P3, S0
cmovg S0, P3
cmovl S2, P3
cmp P1, P2
cmovl S1, P2
