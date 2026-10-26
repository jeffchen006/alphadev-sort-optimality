# n=5 model=out iset=I1 prefix14_class=3335
cmp P0, P3
mov S0, P0
cmovg S0, P3
cmovge P3, P0
cmp P1, P2
mov S2, P2
cmovge P2, P1
mov S1, S0
cmovl S2, P1
cmp S0, S2
cmovge S0, S2
cmovg S2, S1
cmp P3, P2
cmovle P0, P3
