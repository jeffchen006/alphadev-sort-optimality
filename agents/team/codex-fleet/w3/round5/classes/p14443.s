# n=5 model=out iset=I1 prefix14_class=14443
cmp P0, P2
cmovl S1, P2
cmovge S1, P0
mov S0, P3
cmovle P2, P0
cmp S0, P1
cmovle P3, P1
cmovg S0, P1
cmp S0, P2
cmovl P1, P2
cmovle P2, S0
cmovl S0, P1
mov P0, S0
mov S2, S1
