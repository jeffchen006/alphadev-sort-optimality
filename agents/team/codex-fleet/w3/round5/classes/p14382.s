# n=5 model=out iset=I1 prefix14_class=14382
cmp P1, P3
mov S0, P1
cmovle P1, P3
cmovge S0, P3
cmp P0, P2
cmovge P3, P2
cmovge P2, P0
cmovge P0, P3
mov S2, P0
cmp S2, S0
cmovl S2, S0
mov S1, P2
cmovl S0, P0
cmovl P0, S2
