# n=5 model=out iset=I1 prefix14_class=10341
cmp P3, P1
cmovl S1, P1
cmovle P1, P3
cmovge S1, P3
mov S0, P0
cmp P0, P2
cmovge S0, P2
cmovle P0, P2
mov S2, P0
cmp S1, S2
cmovg S2, S1
cmovge S1, P0
cmp P1, S0
cmovge P0, P1
