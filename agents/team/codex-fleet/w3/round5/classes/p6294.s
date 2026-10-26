# n=5 model=out iset=I1 prefix14_class=6294
cmp P0, P3
cmovl S1, P3
cmovl P3, P0
mov S0, P1
cmovge S1, P0
cmovle P0, S1
cmp S0, P2
cmovg S0, P2
cmovge P2, P1
cmp P2, P0
cmovl S1, P2
cmovg P0, P2
cmp S0, P3
cmovle P0, S0
