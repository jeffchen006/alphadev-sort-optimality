# n=5 model=out iset=I1 prefix14_class=3961
mov S0, P3
cmp S0, P0
cmovl S0, P0
cmovle P0, P3
mov S1, P2
cmovge P3, P0
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmp P1, P0
cmovge P3, P1
cmovl P0, P1
cmp S0, S1
cmovge S2, S0
