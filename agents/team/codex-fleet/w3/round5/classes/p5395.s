# n=5 model=out iset=I1 prefix14_class=5395
cmp P2, P1
mov S2, P2
cmovge S2, P1
cmovle P2, P1
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmovl S1, P0
cmp S2, P3
cmovge P1, S2
mov S0, S1
cmovg S2, P3
cmovge P3, P1
cmp P2, S0
