# n=5 model=out iset=I1 prefix14_class=916
cmp P3, P0
mov S2, P1
cmovge S0, P3
cmovl S0, P0
cmovle P0, P3
cmovle P3, S0
cmp P1, P2
cmovge S2, P2
cmovge P2, P1
cmp P2, P3
cmovl P3, P2
mov S1, P0
cmovg S0, P2
cmp S2, S1
