# n=5 model=out iset=I1 prefix14_class=12079
mov S2, P2
cmp S2, P1
cmovg S2, P1
cmovge P1, P2
cmp P0, P3
cmovl S1, P0
cmovge S1, P3
cmovle P0, P3
mov S0, S1
cmp S2, S1
cmovl S0, S2
cmovg S1, S2
cmp P1, P0
mov S0, S1
