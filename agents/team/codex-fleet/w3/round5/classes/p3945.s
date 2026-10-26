# n=5 model=out iset=I1 prefix14_class=3945
mov S2, P3
cmp P0, P3
cmovge S2, P0
cmovl P3, P0
mov S0, P3
mov P0, P2
cmp P0, P1
cmovle P0, P1
cmovl P1, P2
cmp P1, S0
cmovge P3, P1
cmovl S0, P1
cmp S2, P0
cmovl P2, S2
