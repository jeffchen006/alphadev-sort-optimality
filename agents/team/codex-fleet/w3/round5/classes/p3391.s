# n=5 model=out iset=I1 prefix14_class=3391
mov S1, P2
cmp P3, P1
cmovge S0, P1
cmovl S0, P3
cmovge P1, P3
cmp P0, S1
cmovge S1, P0
cmovle P2, P0
mov S2, P2
cmp S0, S2
cmovge S2, S0
cmovg S0, P2
cmp S1, P1
cmovl P3, P1
