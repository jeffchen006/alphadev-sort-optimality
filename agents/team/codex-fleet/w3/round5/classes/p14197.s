# n=5 model=out iset=I1 prefix14_class=14197
cmp P0, P1
cmovl S1, P1
mov S0, P3
cmovl P1, P0
cmovl P0, S1
cmp P2, S0
cmovg S0, P2
cmovge P2, P3
mov S2, S0
cmp S2, P0
cmovl S0, P0
cmovle P0, S2
cmp P1, P2
cmovge P3, P1
