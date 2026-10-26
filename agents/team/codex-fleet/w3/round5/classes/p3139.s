# n=5 model=out iset=I1 prefix14_class=3139
mov S0, P3
cmp P1, P3
cmovl S0, P1
mov S2, P2
cmovge P3, P1
mov S1, S0
cmp P0, S2
cmovle P2, P0
cmovge S2, P0
cmp S0, P2
cmovl S1, P2
cmovg S0, P2
cmp S2, P3
cmovge S0, P3
