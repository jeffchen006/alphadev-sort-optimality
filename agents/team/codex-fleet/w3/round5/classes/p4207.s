# n=5 model=out iset=I1 prefix14_class=4207
cmp P2, P3
mov S1, P3
cmovge S1, P2
cmovle P3, P2
mov S2, P1
cmp P1, P0
mov S0, P3
cmovl P1, P0
cmovle P0, S2
cmp P0, P3
cmovge P3, P0
cmovl S0, P0
cmp S1, P1
cmovg S0, S1
