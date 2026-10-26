# n=5 model=out iset=I1 prefix14_class=13470
mov S0, P0
cmp P2, S0
cmovg S0, P2
cmovl P0, P2
cmp P1, P3
mov S1, P3
cmovl S1, P1
mov S2, S1
cmovl P1, P3
cmp S1, P0
cmovge S2, P0
cmovl S1, P0
cmp S0, P1
cmovle P2, P1
