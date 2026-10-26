# n=5 model=out iset=I1 prefix14_class=5390
mov S0, P3
cmp P2, P3
mov S2, P1
cmovl S0, P2
cmovl P2, P3
cmp P1, P0
cmovle P1, P0
cmovge S2, P0
cmovle P0, S2
cmp S0, P0
cmovg S2, S0
cmovl P0, S0
cmp P2, P1
cmovge P3, P2
