# n=5 model=out iset=I1 prefix14_class=6255
mov S2, P3
cmp P3, P1
cmovge S2, P1
cmovl P3, P1
mov S0, P2
cmp P0, S0
cmovle P2, P0
cmovge S0, P0
mov S1, P3
cmp S0, S1
cmovl S1, S0
cmovge P3, S0
cmovg S0, S1
cmp P2, S2
